-- Subordinate GIANTS directional egress actuator for admitted Hold & Relocate.
-- Retains the native reverse path; a paired worker may instead move forward
-- when the pre-Control option cascade has validated that route.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- No pair admission, TRANSIT assessment, clearance, or native job continuation authority.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeReverseMechanism={}
local Mechanism=OuttaMyWay.NativeReverseMechanism
Mechanism.__index=Mechanism

local MIN_DIRECTION_M=0.0001

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end

-- GIANTS VehicleMotor:getMaximumBackwardSpeed() returns m/s; its native
-- driveToPoint(maxSpeed) expects km/h. Do not substitute the vehicle's
-- *forward* maximum or a retained BWR calibration.
--
-- GIANTS driveToPoint also clamps the motor to the vehicle's current cruise
-- setting. Temporarily lease that native limit at the maximum supported
-- reverse speed; restore the exact prior setting at release.
local function prepareNativeReverseSpeed(vehicle,moveForwards)
    if type(vehicle.getMotor)~="function" then
        return nil,"NATIVE_REVERSE_MOTOR_UNAVAILABLE"
    end
    local ok,motor=pcall(vehicle.getMotor,vehicle)
    local maxMethod=moveForwards and "getMaximumForwardSpeed"
        or "getMaximumBackwardSpeed"
    if not ok or type(motor)~="table"
        or type(motor[maxMethod])~="function" then
        return nil,"NATIVE_REVERSE_SPEED_API_UNAVAILABLE"
    end
    local read,speedMps=pcall(motor[maxMethod],motor)
    if not read or not finite(speedMps) or speedMps<=0 then
        return nil,"NATIVE_REVERSE_SPEED_UNAVAILABLE"
    end
    local cruise=vehicle.spec_drivable and vehicle.spec_drivable.cruiseControl
    if type(cruise)~="table"
        or type(vehicle.setCruiseControlMaxSpeed)~="function"
        or not finite(cruise.speed) or not finite(cruise.speedReverse)
        or not finite(cruise.maxSpeed) or not finite(cruise.maxSpeedReverse)
        or cruise.maxSpeed<=0 or cruise.maxSpeedReverse<=0 then
        return nil,"NATIVE_CRUISE_LIMIT_UNAVAILABLE"
    end
    -- Lease both cruise settings because GIANTS native driveToPoint reads
    -- native cruise state; restore both on either completion or cancellation.
    -- Keep the reverse path's previously validated conservative cap.
    local requestedKmh=math.min(speedMps*3.6,cruise.maxSpeed,
        cruise.maxSpeedReverse)
    if not finite(requestedKmh) or requestedKmh<=0 then
        return nil,"NATIVE_REVERSE_SPEED_UNAVAILABLE"
    end
    return {speedKmh=requestedKmh,nativeMotorMaxReverseKmh=speedMps*3.6,
        oldForwardKmh=cruise.speed,
        oldReverseKmh=cruise.speedReverse}
end

local function restoreNativeCruiseSpeed(vehicle,lease)
    if lease==nil or lease.isRestored then return true end
    local cruise=vehicle.spec_drivable and vehicle.spec_drivable.cruiseControl
    if type(cruise)~="table" or type(vehicle.setCruiseControlMaxSpeed)~="function" then
        return false,"NATIVE_CRUISE_RESTORE_UNAVAILABLE"
    end
    local ok=pcall(vehicle.setCruiseControlMaxSpeed,vehicle,
        lease.oldForwardKmh,lease.oldReverseKmh)
    if not ok or not finite(cruise.speed) or not finite(cruise.speedReverse)
        or math.abs(cruise.speed-lease.oldForwardKmh)>0.001
        or math.abs(cruise.speedReverse-lease.oldReverseKmh)>0.001 then
        return false,"NATIVE_CRUISE_RESTORE_UNCONFIRMED"
    end
    lease.isRestored=true
    return true
end

local function acquireNativeCruiseSpeed(vehicle,lease)
    local cruise=vehicle.spec_drivable.cruiseControl
    local ok=pcall(vehicle.setCruiseControlMaxSpeed,vehicle,
        lease.speedKmh,lease.speedKmh)
    if not ok or not finite(cruise.speed) or not finite(cruise.speedReverse)
        or cruise.speed+0.001<lease.speedKmh
        or cruise.speedReverse+0.001<lease.speedKmh then
        local restored=restoreNativeCruiseSpeed(vehicle,lease)
        return false,restored and "NATIVE_CRUISE_SPEED_NOT_APPLIED"
            or "NATIVE_CRUISE_SPEED_STATE_UNRESOLVED"
    end
    return true
end

local function pose(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then
        return nil,"POSE_UNAVAILABLE"
    end
    local ok,x,y,z=pcall(getWorldTranslation,node)
    if not ok or not finite(x) or not finite(y) or not finite(z) then
        return nil,"POSE_UNAVAILABLE"
    end
    return {x=x,y=y,z=z}
end

local function reverserNode(vehicle)
    if type(vehicle)~="table" or type(vehicle.getAIReverserNode)~="function" then
        return nil,"AI_REVERSER_NODE_UNAVAILABLE"
    end
    local ok,node=pcall(vehicle.getAIReverserNode,vehicle)
    if not ok or node==nil or node==0 then return nil,"AI_REVERSER_NODE_UNAVAILABLE" end
    return node
end

local function steeringNode(vehicle)
    if type(vehicle)~="table" or type(vehicle.getAISteeringNode)~="function" then
        return nil,"AI_STEERING_NODE_UNAVAILABLE"
    end
    local ok,node=pcall(vehicle.getAISteeringNode,vehicle)
    if not ok or node==nil or node==0 then return nil,"AI_STEERING_NODE_UNAVAILABLE" end
    return node
end

local function toolNodeFor(vehicle)
    if type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.getAIToolReverserDirectionNode)~="function" then
        return nil,"TOOL_REVERSE_API_UNAVAILABLE"
    end
    local ok,node=pcall(AIVehicleUtil.getAIToolReverserDirectionNode,vehicle)
    if not ok then return nil,"TOOL_REVERSE_QUERY_FAILED" end
    if node==nil or node==0 then return nil end
    return node
end

local function toolGeometryReady()
    return type(MathUtil)=="table"
        and type(MathUtil.vector2Length)=="function"
        and type(MathUtil.getProjectOnLineParameter)=="function"
        and type(MathUtil.vector2Normalize)=="function"
        and type(MathUtil.dotProduct)=="function"
        and type(MathUtil.getSignedAngleBetweenVectors2D)=="function"
        and type(MathUtil.isNan)=="function"
        and type(localDirectionToWorld)=="function"
        and type(localToWorld)=="function"
end

-- Preserve archived BWR's GIANTS-equivalent tool-relative rotation. If a tool
-- reverser is present but this geometry is missing, do not silently revert to
-- vehicle-only steering and claim native reversing equivalence.
local function adjustToolTarget(reverseNode,toolNode,targetX,targetZ)
    if toolNode==nil then return targetX,targetZ end
    if not toolGeometryReady() then return nil,nil,"TOOL_GEOMETRY_UNAVAILABLE" end
    local ok,x,z=pcall(function()
        local tx,_,tz=getWorldTranslation(toolNode)
        local dx1,_,dz1=localDirectionToWorld(reverseNode,0,0,1)
        local dx2,_,dz2=localDirectionToWorld(toolNode,0,0,1)
        local length1=MathUtil.vector2Length(dx1,dz1)
        local length2=MathUtil.vector2Length(dx2,dz2)
        if length1<=0 or length2<=0 then return nil,nil end
        dx1,dz1=dx1/length1,dz1/length1
        dx2,dz2=dx2/length2,dz2/length2
        local distance=MathUtil.vector2Length(targetX-tx,targetZ-tz)
        local longitudinal=MathUtil.getProjectOnLineParameter(
            targetX,targetZ,tx,tz,dx2,dz2)
        local lateral=math.sqrt(math.max(0,distance*distance-longitudinal*longitudinal))
        local sideX,sideZ=MathUtil.vector2Normalize(tx-targetX,tz-targetZ)
        local side=MathUtil.dotProduct(-dz2,0,dx2,sideX,0,sideZ)
        lateral=lateral*(side<0 and -1 or (side>0 and 1 or 0))
        local angle=MathUtil.getSignedAngleBetweenVectors2D(dx1,dz1,dx2,dz2)
        local localX=math.cos(angle)*lateral-math.sin(angle)*longitudinal
        local localZ=math.sin(angle)*lateral+math.cos(angle)*longitudinal
        if MathUtil.isNan(localX) or MathUtil.isNan(localZ) then return nil,nil end
        local worldX,_,worldZ=localToWorld(reverseNode,-localX,0,localZ)
        return worldX,worldZ
    end)
    if not ok or not finite(x) or not finite(z) then
        return nil,nil,"TOOL_GEOMETRY_INVALID"
    end
    return x,z
end

-- Shared native tool-relative transform for reverse movements that must
-- explicitly issue drive commands because no GIANTS AI job remains active.
Mechanism.adjustToolTarget=adjustToolTarget

function Mechanism.new()
    return setmetatable({states=setmetatable({},{__mode="k"}),
        activeVehicle=nil,originalDrive=nil,wrapper=nil},Mechanism)
end

-- A positive command does not establish actual movement. Each sampling point
-- accumulates horizontal physical distance to challenge the movement bound.
function Mechanism:observeDisplacement(state)
    if state.isFailed then return end
    local current,reason=pose(state.vehicle.rootNode)
    if current==nil then state.isFailed=true;state.reason=reason;return end
    local dx,dz=current.x-state.lastX,current.z-state.lastZ
    local stepM=math.sqrt(dx*dx+dz*dz)
    state.lastX,state.lastZ=current.x,current.z
    state.travelledM=state.travelledM+stepM
    if state.initialMotionDeviationDeg==nil and stepM>=0.05 then
        local vx,vz=dx/stepM,dz/stepM
        local region=state.returnRegion
        local dot=vx*region.directionX+vz*region.directionZ
        state.initialMotionDeviationDeg=math.deg(math.acos(
            math.max(-1,math.min(1,dot))))
        if state.nativeReverseHeadingX~=nil then
            local reverseDot=vx*state.nativeReverseHeadingX+
                vz*state.nativeReverseHeadingZ
            state.initialMotionRelativeToReverseDeg=math.deg(math.acos(
                math.max(-1,math.min(1,reverseDot))))
        end
    end
    if not finite(state.travelledM) then
        state.isFailed=true;state.reason="DISPLACEMENT_UNAVAILABLE";return
    end
    -- An archived-BWR-style Return Region is a projected progress predicate,
    -- independent of the distant steering reference. No chord-length abort.
    local progress=OuttaMyWay.ProjectedEgressRegion.progress(
        state.returnRegion,current.x,current.z)
    if progress==nil then
        state.isFailed=true;state.reason="REVERSE_REGION_EVIDENCE_UNAVAILABLE";return
    end
    state.regionProgressM=progress.progressM
    state.regionCrossTrackM=progress.crossTrackM
    state.regionLateralOffsetM=progress.lateralOffsetM
    state.regionRemainingM=progress.remainingM
    if state.commandedDriveCount>0 and progress.isInRegion then
        state.isComplete=true
    end
end

-- Global wrapper is installed only after an explicit startReverse, and only
-- one commanded vehicle is altered. All other calls forward the ninth
-- doNotSteer argument unchanged to GIANTS' original driveToPoint.
function Mechanism:install()
    if self.wrapper~=nil then
        if type(AIVehicleUtil)=="table" and AIVehicleUtil.driveToPoint==self.wrapper then return true end
        return false,"DRIVE_WRAPPER_CHANGED"
    end
    if type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.driveToPoint)~="function" then
        return false,"DRIVE_API_UNAVAILABLE"
    end
    local original=AIVehicleUtil.driveToPoint
    local mechanism=self
    local function wrapper(vehicle,dt,accel,allowed,moveForwards,lx,lz,maxSpeed,doNotSteer)
        local state=mechanism.states[vehicle]
        if state==nil then
            return original(vehicle,dt,accel,allowed,moveForwards,lx,lz,maxSpeed,doNotSteer)
        end
        mechanism:observeDisplacement(state)
        if state.isComplete or state.isFailed then
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        local node,reason=state.moveForwards
            and steeringNode(vehicle) or reverserNode(vehicle)
        local reference=node and pose(node) or nil
        if node==nil or reference==nil or type(worldToLocal)~="function" then
            state.isFailed=true;state.reason=reason or "REVERSE_FRAME_UNAVAILABLE"
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        local worldX,worldZ,why
        if state.moveForwards then
            worldX,worldZ=state.steeringTargetX,state.steeringTargetZ
        else
            worldX,worldZ,why=adjustToolTarget(node,state.toolNode,
                state.steeringTargetX,state.steeringTargetZ)
        end
        if worldX==nil then
            state.isFailed=true;state.reason=why
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        local ok,targetX,_,targetZ=pcall(worldToLocal,node,worldX,reference.y,worldZ)
        local length=ok and finite(targetX) and finite(targetZ)
            and math.sqrt(targetX*targetX+targetZ*targetZ) or nil
        if not finite(length) or length<=MIN_DIRECTION_M then
            state.isFailed=true;state.reason="REVERSE_LOCAL_TARGET_UNAVAILABLE"
            return original(vehicle,dt,0,false,false,0,1,0,false)
        end
        state.commandedDriveCount=state.commandedDriveCount+1
        -- Reverse keeps GIANTS' reverser frame and tool-relative target.
        -- Forward uses its native AI steering frame, without reverse tool
        -- rotation; both permit steering and normal propulsion.
        return original(vehicle,dt,1,true,state.moveForwards,
            targetX/length,targetZ/length,state.speedLease.speedKmh,false)
    end
    self.originalDrive=original
    self.wrapper=wrapper
    AIVehicleUtil.driveToPoint=wrapper
    return true
end

-- Requires independently validated commitment/TRANSIT authority. The 40 m
-- world steering reference guides motion; Return Region entry terminates it.
function Mechanism:startReverse(vehicle,objective)
    if g_server==nil then return false,"SERVER_REQUIRED" end
    if self.activeVehicle~=nil then return false,"REVERSE_ALREADY_ACTIVE" end
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(objective)~="table"
        or (objective.isReverse~=true
            and not (objective.isReverse==false
                and type(objective.returnRegion)=="table"
                and (objective.returnRegion.source=="SIGNED_CROSS_TRACK_REGION"
                    or objective.returnRegion.source==
                        "PAIR_WORKING_CORRIDOR_TRAVEL_REGION")))
        or not finite(objective.targetX) or not finite(objective.targetZ)
        or type(objective.returnRegion)~="table"
        or not finite(objective.returnRegion.originX)
        or not finite(objective.returnRegion.originZ)
        or not finite(objective.returnRegion.directionX)
        or not finite(objective.returnRegion.directionZ)
        or not finite(objective.returnRegion.requiredProgressM)
        or objective.returnRegion.requiredProgressM<=0
        -- Solo and the full-distance paired Return Region use directional
        -- progress. A paired travel region does not have a cross-track
        -- completion threshold; only legacy cross-track regions require it.
        or (objective.returnRegion.source~="SINGLE_REVERSE_REGION"
            and objective.returnRegion.source~=
                "PAIR_WORKING_CORRIDOR_TRAVEL_REGION"
            and (not finite(objective.returnRegion.requiredCrossTrackM)
                or not finite(objective.returnRegion.blockerOriginX)
                or not finite(objective.returnRegion.blockerOriginZ)
                or not finite(objective.returnRegion.corridorNormalX)
                or not finite(objective.returnRegion.corridorNormalZ)
                or not finite(objective.returnRegion.sideSign)))
        or not finite(objective.steeringHorizonM)
        or objective.steeringHorizonM<=0 then
        return false,"REVERSE_REQUEST_INVALID"
    end
    local origin,why=pose(vehicle.rootNode)
    if origin==nil then return false,why end
    local moveForwards=objective.isReverse==false
    local reference,frameReason=moveForwards
        and steeringNode(vehicle) or reverserNode(vehicle)
    if reference==nil then return false,frameReason end
    if pose(reference)==nil or type(worldToLocal)~="function" then
        return false,"REVERSE_FRAME_UNAVAILABLE"
    end
    local toolNode,toolReason
    if not moveForwards then
        toolNode,toolReason=toolNodeFor(vehicle)
    end
    if toolReason=="TOOL_REVERSE_QUERY_FAILED" then return false,toolReason end
    if toolNode~=nil and not toolGeometryReady() then
        return false,"TOOL_GEOMETRY_UNAVAILABLE"
    end
    local dx,dz=objective.targetX-origin.x,objective.targetZ-origin.z
    local distanceM=math.sqrt(dx*dx+dz*dz)
    if not finite(distanceM) or distanceM<=MIN_DIRECTION_M then
        return false,"STEERING_REFERENCE_UNAVAILABLE"
    end
    local steeringX=objective.targetX
    local steeringZ=objective.targetZ
    if not finite(steeringX) or not finite(steeringZ) then
        return false,"STEERING_REFERENCE_UNAVAILABLE"
    end
    local speedLease,speedReason=prepareNativeReverseSpeed(vehicle,moveForwards)
    if speedLease==nil then return false,speedReason end
    local installed,installReason=self:install()
    if not installed then return false,installReason end
    local accelerated,cruiseReason=acquireNativeCruiseSpeed(vehicle,speedLease)
    if not accelerated then
        if cruiseReason=="NATIVE_CRUISE_SPEED_STATE_UNRESOLVED" then
            -- A native setter can have partially applied before throwing.
            -- Keep an inert reverse lease so the coordinator's ordinary
            -- cancellation can retry restoration and report unresolved debt.
            self.activeVehicle=vehicle
            self.states[vehicle]={vehicle=vehicle,speedLease=speedLease,
                isFailed=true,reason=cruiseReason,commandedDriveCount=0,
                travelledM=0}
        else
            self:uninstall()
        end
        return false,cruiseReason
    end
    self.activeVehicle=vehicle
    self.states[vehicle]={vehicle=vehicle,speedLease=speedLease,
        originX=origin.x,originZ=origin.z,
        lastX=origin.x,lastZ=origin.z,targetX=objective.targetX,targetZ=objective.targetZ,
        steeringTargetX=steeringX,steeringTargetZ=steeringZ,
        returnRegion=objective.returnRegion,toolNode=toolNode,
        moveForwards=moveForwards,travelledM=0,
        nativeReverseHeadingX=objective.nativeReverseHeadingX,
        nativeReverseHeadingZ=objective.nativeReverseHeadingZ,
        regionProgressM=0,regionRemainingM=objective.returnRegion.requiredProgressM,
        commandedDriveCount=0,isComplete=false,isFailed=false}
    -- In Lua, `condition and nil or value` cannot encode an absent
    -- field: it falls through to value. Publish one truthful direction
    -- label, not a reverse request on a forward-driven worker.
    local evidence={kind=moveForwards and "PAIR_FORWARD_ARMED" or "REVERSE_ARMED",
        hasToolReverser=toolNode~=nil,
        nativeMotorMaxReverseKmh=moveForwards and nil
            or speedLease.nativeMotorMaxReverseKmh,
        isPhysicalMotionConfirmed=false}
    if moveForwards then
        evidence.requestedDriveSpeedKmh=speedLease.speedKmh
        evidence.nativeMotorMaxReverseKmh=nil
    else
        evidence.requestedReverseSpeedKmh=speedLease.speedKmh
    end
    return true,evidence
end

function Mechanism:reverseStatus(vehicle)
    local state=self.states[vehicle]
    if state==nil then return {travelledM=0,isFailed=true,reason="REVERSE_NOT_ACTIVE"} end
    if AIVehicleUtil==nil or AIVehicleUtil.driveToPoint~=self.wrapper then
        state.isFailed=true;state.reason="DRIVE_PATH_CHANGED"
    else
        self:observeDisplacement(state)
    end
    return {travelledM=state.travelledM,isComplete=state.isComplete,
        isFailed=state.isFailed,reason=state.reason,
        regionProgressM=state.regionProgressM,
        regionRemainingM=state.regionRemainingM,
        regionCrossTrackM=state.regionCrossTrackM,
        regionLateralOffsetM=state.regionLateralOffsetM,
        initialMotionDeviationDeg=state.initialMotionDeviationDeg,
        initialMotionRelativeToReverseDeg=state.initialMotionRelativeToReverseDeg,
        commandedDriveCount=state.commandedDriveCount}
end

function Mechanism:uninstall()
    if self.activeVehicle~=nil then return false,"REVERSE_STILL_ACTIVE" end
    if self.wrapper~=nil and type(AIVehicleUtil)=="table"
        and AIVehicleUtil.driveToPoint==self.wrapper then
        AIVehicleUtil.driveToPoint=self.originalDrive
    end
    self.originalDrive=nil
    self.wrapper=nil
    return true
end

function Mechanism:stopReverse(vehicle)
    local state=self.states[vehicle]
    if state==nil or not state.isComplete then
        return false,"REVERSE_NOT_COMPLETE"
    end
    local restored,restoreReason=restoreNativeCruiseSpeed(vehicle,state.speedLease)
    if not restored then return false,restoreReason end
    self.states[vehicle]=nil
    self.activeVehicle=nil
    self:uninstall()
    return true
end

function Mechanism:cancelReverse(vehicle)
    if self.activeVehicle~=nil and self.activeVehicle~=vehicle then
        return false,"OTHER_REVERSE_ACTIVE"
    end
    local state=vehicle~=nil and self.states[vehicle] or nil
    if state~=nil then
        local restored,restoreReason=restoreNativeCruiseSpeed(vehicle,state.speedLease)
        if not restored then return false,restoreReason end
        self.states[vehicle]=nil
    end
    self.activeVehicle=nil
    self:uninstall()
    return true
end
