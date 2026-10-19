-- Direct non-job physical movement of a nominated inactive assembly.
-- Specification Jurisdictions: `HOLD_RELOCATE`, `COMPLETION_SETTLEMENT_CONTROL`
-- GIANTS driveToPoint, native steering/reverser frames and bounded motor/physics
-- activity are used by independent BWR and completion-settlement instances.
-- This module never creates an AI job or scans geometry.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeStaticAssemblyDriveMechanism={}
local M=OuttaMyWay.NativeStaticAssemblyDriveMechanism
M.__index=M
-- The static subject uses its own maximum native motor/cruise capability.
-- No arbitrary egress cap; the selected travel direction determines the limit.

local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end

local function pose(node)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then
        return nil
    end
    local ok,x,y,z=pcall(getWorldTranslation,node)
    return ok and finite(x) and finite(y) and finite(z)
        and {x=x,y=y,z=z} or nil
end

local function playerClaimed(vehicle)
    if type(vehicle.getIsControlled)=="function" then
        local ok,active=pcall(vehicle.getIsControlled,vehicle)
        if ok and active==true then return true end
    end
    local selected=g_currentMission and g_currentMission.controlledVehicle
    if selected==vehicle then return true end
    if type(selected)=="table" and type(selected.getRootVehicle)=="function" then
        local ok,root=pcall(selected.getRootVehicle,selected)
        if ok and root==vehicle then return true end
    end
    return false
end

local function newlyAIActive(vehicle)
    -- A new native AI job can legitimately supersede direct static movement.
    -- Merely tabbing into the assembly is not a motion command or veto.
    if type(vehicle.getIsAIActive)=="function" then
        local ok,active=pcall(vehicle.getIsAIActive,vehicle)
        if not ok or active~=false then return true end
    end
    return false
end

function M.new()
    return setmetatable({active=nil},M)
end

function M:startMovement(vehicle,objective)
    if g_server==nil or self.active~=nil then
        return false,"STATIC_DRIVE_UNAVAILABLE"
    end
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(objective)~="table"
        or objective.returnRegion==nil
        or (objective.returnRegion.source~="STATIC_CROSS_TRACK_REGION"
            and objective.returnRegion.source~="COMPLETION_SETTLEMENT_LEG")
        or type(objective.moveForwards)~="boolean"
        or not finite(objective.targetX)
        or not finite(objective.targetZ)
        or (objective.arrivalRadiusM~=nil
            and (not finite(objective.arrivalRadiusM)
                or objective.arrivalRadiusM<=0
                or objective.arrivalRadiusM>2.5))
        or (objective.steeringTargetX~=nil
            and not finite(objective.steeringTargetX))
        or (objective.steeringTargetZ~=nil
            and not finite(objective.steeringTargetZ))
        or (objective.steeringTargetX==nil)~=
            (objective.steeringTargetZ==nil)
        or type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.driveToPoint)~="function"
        or type(worldToLocal)~="function"
        or type(vehicle.getMotor)~="function"
        or type(vehicle.setCruiseControlMaxSpeed)~="function"
        or type(vehicle.startMotor)~="function"
        or type(vehicle.stopMotor)~="function"
        or newlyAIActive(vehicle) then
        return false,"STATIC_DRIVE_NATIVE_PRECONDITION_MISSING"
    end
    local settlement=objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG"
    if settlement and (playerClaimed(vehicle)
        or type(Drivable)~="table"
        or type(Drivable.CRUISECONTROL_STATE_OFF)~="number"
        or type(vehicle.getCruiseControlState)~="function"
        or type(vehicle.setCruiseControlState)~="function") then
        return false,"SETTLEMENT_CONTROL_CLAIMED_OR_CRUISE_UNAVAILABLE"
    end
    local origin=pose(vehicle.rootNode)
    if origin==nil then return false,"STATIC_DRIVE_POSE_UNAVAILABLE" end
    local nodeMethod=objective.moveForwards and "getAISteeringNode"
        or "getAIReverserNode"
    if type(vehicle[nodeMethod])~="function" then
        return false,"STATIC_DRIVE_NODE_UNAVAILABLE"
    end
    local read,node=pcall(vehicle[nodeMethod],vehicle)
    local nodeReference=read and pose(node) or nil
    if nodeReference==nil then
        return false,"STATIC_DRIVE_NODE_UNAVAILABLE"
    end
    local toolNode=nil
    if not objective.moveForwards then
        if type(AIVehicleUtil.getAIToolReverserDirectionNode)~="function"
            or type(OuttaMyWay.NativeReverseMechanism.adjustToolTarget)~="function" then
            return false,"STATIC_NATIVE_TOOL_REVERSE_UNAVAILABLE"
        end
        local toolRead,found=pcall(AIVehicleUtil.getAIToolReverserDirectionNode,vehicle)
        if not toolRead then return false,"STATIC_NATIVE_TOOL_REVERSE_UNAVAILABLE" end
        toolNode=found
    end
    local motorRead,motor=pcall(vehicle.getMotor,vehicle)
    if not motorRead or type(motor)~="table" then
        return false,"STATIC_NATIVE_MOTOR_UNAVAILABLE"
    end
    local maxMethod=objective.moveForwards and "getMaximumForwardSpeed"
        or "getMaximumBackwardSpeed"
    if type(motor[maxMethod])~="function" then
        return false,"STATIC_NATIVE_DRIVE_SPEED_UNAVAILABLE"
    end
    local maxRead,maxMps=pcall(motor[maxMethod],motor)
    if not maxRead or not finite(maxMps) or maxMps<=0 then
        return false,"STATIC_NATIVE_DRIVE_SPEED_UNAVAILABLE"
    end
    local cruise=vehicle.spec_drivable and vehicle.spec_drivable.cruiseControl
    if type(cruise)~="table" or not finite(cruise.speed)
        or not finite(cruise.speedReverse) or not finite(cruise.maxSpeed)
        or not finite(cruise.maxSpeedReverse) then
        return false,"STATIC_NATIVE_CRUISE_UNAVAILABLE"
    end
    local nativeMaximumKmh=maxMps*3.6
    local directionalCruiseMaximum=objective.moveForwards
        and cruise.maxSpeed or cruise.maxSpeedReverse
    local nativeSpeed=math.min(nativeMaximumKmh,directionalCruiseMaximum)
    local speed=nativeSpeed
    if settlement and objective.maximumSpeedKmh~=nil then
        if not finite(objective.maximumSpeedKmh)
            or objective.maximumSpeedKmh<=0 then
            return false,"SETTLEMENT_GUIDANCE_SPEED_INVALID"
        end
        speed=math.min(speed,objective.maximumSpeedKmh)
    end
    if not finite(speed) or speed<=0 then
        return false,"STATIC_NATIVE_DRIVE_SPEED_UNAVAILABLE"
    end
    -- Native motor readback is optional ownership evidence only.
    -- A missing/unconfirmed reading cannot veto native movement.
    local observed,running=false,false
    if type(vehicle.getIsMotorStarted)=="function" then
        observed,running=pcall(vehicle.getIsMotorStarted,vehicle)
    end
    local alreadyStarted=observed and running==true
    local initialMotorState="UNKNOWN"
    if observed then initialMotorState=alreadyStarted end
    local priorCruiseState=nil
    if settlement then
        local read,value=pcall(vehicle.getCruiseControlState,vehicle)
        if not read or type(value)~="number" then
            return false,"SETTLEMENT_CRUISE_STATE_UNKNOWN"
        end
        priorCruiseState=value
    end
    -- Register potential effects before setters, so cancellation can restore
    -- cruise, physics activation and motor even after a partial native call.
    local state={
        vehicle=vehicle,objective=objective,node=node,
        nodeReferenceY=nodeReference.y,toolNode=toolNode,
        originX=origin.x,originZ=origin.z,
        oldForceIsActive=vehicle.forceIsActive,
        oldForwardSpeed=cruise.speed,oldReverseSpeed=cruise.speedReverse,
        speedKmh=speed,nativeSpeedKmh=nativeSpeed,
        startedMotor=not alreadyStarted,
        -- Native acceptance is distinct from confirmed running state.
        -- Retained only for bounded diagnostic attribution, not admission.
        motorWasRunningInitially=initialMotorState,
        motorStartCallAccepted=alreadyStarted,
        motorStartReply=alreadyStarted
            and "NOT_REQUESTED_ALREADY_RUNNING" or "NOT_YET_REQUESTED",
        settlement=settlement,priorCruiseState=priorCruiseState,
        stopping=false,stopped=false,steadyMs=0,
        lastDt=16,commanded=0,isFailed=false,isComplete=false
    }
    self.active=state
    vehicle.forceIsActive=true
    local applied=pcall(vehicle.setCruiseControlMaxSpeed,vehicle,speed,speed)
    if not applied then
        state.isFailed=true
        return false,"STATIC_CRUISE_REQUEST_FAILED"
    end
    if not alreadyStarted then
        local started,answer=pcall(vehicle.startMotor,vehicle,true)
        state.motorStartCallAccepted=started and answer~=false
        state.motorStartReply=tostring(answer)
        if not started or answer==false then
            state.isFailed=true
            return false,"STATIC_MOTOR_START_FAILED"
        end
    end
    return true,{kind="STATIC_DIRECT_DRIVE_ARMED",
        requestedDriveSpeedKmh=speed,
        nativeDirectionalMotorMaximumKmh=nativeMaximumKmh,
        nativeDirectionalCruiseMaximumKmh=directionalCruiseMaximum,
        moveForwards=objective.moveForwards,
        localTargetContract=settlement and "POSITION" or "LEGACY_UNIT",
        initialCruiseState=priorCruiseState}
end

function M:movementStatus(vehicle,dt)
    local s=self.active
    if s==nil or s.vehicle~=vehicle then
        return {isFailed=true,reason="STATIC_DRIVE_NOT_ACTIVE"}
    end
    if s.isFailed then return {isFailed=true,reason=s.reason or "STATIC_DRIVE_FAILED"} end
    if newlyAIActive(vehicle) then
        s.isFailed=true;s.reason="STATIC_SUBJECT_AI_RECLAIMED"
        return {isFailed=true,reason=s.reason}
    end
    local p=pose(vehicle.rootNode)
    local progress
    if p~=nil and s.objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG" then
        local tx,tz=s.objective.targetX-s.originX,
            s.objective.targetZ-s.originZ
        local length=math.sqrt(tx*tx+tz*tz)
        if length>=0.001 then
            local dx,dz=p.x-s.originX,p.z-s.originZ
            local remaining=math.sqrt((p.x-s.objective.targetX)^2
                +(p.z-s.objective.targetZ)^2)
            progress={progressM=(dx*tx+dz*tz)/length,
                remainingM=remaining,isInRegion=remaining<=
                    (s.objective.arrivalRadiusM or 2.5),
                lateralOffsetM=math.abs(dx*tz-dz*tx)/length}
        end
    else
        progress=p and OuttaMyWay.ProjectedEgressRegion.progress(
            s.objective.returnRegion,p.x,p.z) or nil
    end
    if progress==nil then
        s.isFailed=true;s.reason="STATIC_PROGRESS_UNAVAILABLE"
        return {isFailed=true,reason=s.reason}
    end
    -- These are already-read values; store them for a single progress report
    -- without an additional GIANTS physics query or ongoing trace.
    local dx,dz=p.x-s.originX,p.z-s.originZ
    s.physicalDisplacementM=math.sqrt(dx*dx+dz*dz)
    s.regionProgressM=progress.progressM
    if s.objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG"
        and progress.progressM< -5 then
        s.isFailed=true;s.reason="SETTLEMENT_GUIDANCE_NEGATIVE_PROGRESS"
        return {isFailed=true,reason=s.reason}
    end
    if s.objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG"
        and progress.lateralOffsetM>12 then
        s.isFailed=true;s.reason="SETTLEMENT_LEG_TRAJECTORY_DIVERGED"
        return {isFailed=true,reason=s.reason}
    end
    if s.commanded>0 and progress.isInRegion then
        s.isComplete=true
        return {isComplete=true,progressM=progress.progressM,
            commandedDriveCount=s.commanded,
            physicalDisplacementM=s.physicalDisplacementM}
    end
    -- Do not wait for GIANTS motor-running readback here. A native
    -- start request has already been dispatched; the normal movement
    -- command, geometry guards and measured stopping establish outcomes.
    local targetX,targetZ=s.objective.targetX,s.objective.targetZ
    if s.settlement and not s.objective.moveForwards
        and s.objective.steeringTargetX~=nil then
        -- An independent reverse look-through never extends the movement
        -- region or native stop boundary, unlike unbounded point pursuit.
        targetX=s.objective.steeringTargetX
        targetZ=s.objective.steeringTargetZ
    end
    if not s.objective.moveForwards then
        local x,z,reason=OuttaMyWay.NativeReverseMechanism.adjustToolTarget(
            s.node,s.toolNode,targetX,targetZ)
        if x==nil then
            s.isFailed=true;s.reason=reason or "STATIC_REVERSE_FRAME_UNAVAILABLE"
            return {isFailed=true,reason=s.reason}
        end
        targetX,targetZ=x,z
    end
    -- Native reverse transforms the world target in the reverser-node
    -- frame, using its sampled reference height, not the root-node height.
    local ok,lx,_,lz=pcall(worldToLocal,s.node,targetX,
        s.nodeReferenceY,targetZ)
    local length=ok and finite(lx) and finite(lz)
        and math.sqrt(lx*lx+lz*lz) or nil
    if not finite(length) or length<0.0001 then
        s.isFailed=true;s.reason="STATIC_LOCAL_STEERING_UNAVAILABLE"
        return {isFailed=true,reason=s.reason}
    end
    if type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.driveToPoint)~="function" then
        s.isFailed=true;s.reason="STATIC_NATIVE_DRIVE_UNAVAILABLE"
        return {isFailed=true,reason=s.reason}
    end
    s.lastDt=finite(dt) and dt or 16
    -- On approaching a direction-change or the final parking stop, start
    -- reducing native cruise demand BEFORE reaching the last steering point.
    -- The remaining tangent distance comes from the already-planned short
    -- guidance points. Native braking response is still GIANTS-unvalidated.
    if s.settlement and finite(s.objective.remainingAfterTargetM)
        and finite(progress.remainingM) then
        local remaining=progress.remainingM+s.objective.remainingAfterTargetM
        local brakingKmh=math.sqrt(2*1.5*math.max(0,
            remaining-(s.objective.arrivalRadiusM or 2.5)))*3.6
        local bounded=math.min(s.speedKmh,math.max(2.5,brakingKmh))
        local applied=pcall(vehicle.setCruiseControlMaxSpeed,
            vehicle,bounded,bounded)
        if not applied then
            s.isFailed=true;s.reason="SETTLEMENT_APPROACH_BRAKING_UNAVAILABLE"
            return {isFailed=true,reason=s.reason}
        end
        s.requestedSpeedKmh=bounded
    else
        s.requestedSpeedKmh=s.speedKmh
    end
    s.commanded=s.commanded+1
    -- GIANTS driveToPoint expects a local-space POSITION. Historical BWR
    -- supplies unit vectors; preserve that validated legacy path, and fix
    -- only the new Completion Settlement caller for this TEST.
    local tx,tz=lx/length,lz/length
    if s.settlement then tx,tz=lx,lz end
    s.localTargetDistanceM=length
    local driven=pcall(AIVehicleUtil.driveToPoint,vehicle,s.lastDt,
        1,true,s.objective.moveForwards,tx,tz,s.requestedSpeedKmh,false)
    if not driven then
        s.isFailed=true;s.reason="STATIC_NATIVE_DRIVE_FAILED"
        return {isFailed=true,reason=s.reason}
    end
    return {isComplete=false,progressM=progress.progressM,
        physicalDisplacementM=s.physicalDisplacementM,
        commandedDriveCount=s.commanded,
        localTargetDistanceM=s.localTargetDistanceM}
end

-- Progressive local targets share one native lease while the direction
-- stays unchanged. A direction reversal requires physical stop + release.
function M:retargetSettlement(vehicle,objective)
    local s=self.active
    if s==nil or s.vehicle~=vehicle or not s.settlement
        or not s.isComplete or s.stopping or s.stopped
        or type(objective)~="table"
        or type(objective.returnRegion)~="table"
        or objective.returnRegion.source~="COMPLETION_SETTLEMENT_LEG"
        or objective.moveForwards~=s.objective.moveForwards
        or not finite(objective.targetX)
        or not finite(objective.targetZ)
        or (objective.arrivalRadiusM~=nil
            and (not finite(objective.arrivalRadiusM)
                or objective.arrivalRadiusM<=0
                or objective.arrivalRadiusM>2.5))
        or (objective.steeringTargetX~=nil
            and not finite(objective.steeringTargetX))
        or (objective.steeringTargetZ~=nil
            and not finite(objective.steeringTargetZ))
        or (objective.steeringTargetX==nil)~=
            (objective.steeringTargetZ==nil) then
        return false,"SETTLEMENT_RETARGET_UNAVAILABLE"
    end
    local p=pose(vehicle.rootNode)
    if p==nil then return false,"SETTLEMENT_RETARGET_POSE_UNKNOWN" end
    local speed=s.nativeSpeedKmh
    if objective.maximumSpeedKmh~=nil then
        if not finite(objective.maximumSpeedKmh)
            or objective.maximumSpeedKmh<=0 then
            return false,"SETTLEMENT_GUIDANCE_SPEED_INVALID"
        end
        speed=math.min(speed,objective.maximumSpeedKmh)
    end
    local applied=pcall(vehicle.setCruiseControlMaxSpeed,vehicle,speed,speed)
    if not applied then return false,"SETTLEMENT_RETARGET_SPEED_UNAVAILABLE" end
    s.objective=objective
    s.speedKmh=speed
    s.originX,s.originZ=p.x,p.z
    s.isComplete=false
    s.commanded=0
    return true
end

-- A settlement point is only a position witness. Maintain native braking
-- and cruise-OFF Control until actual low speed and stationary displacement
-- are observed over a bounded, continuous interval.
function M:beginSettlementStop(vehicle,forReassessment)
    local s=self.active
    if s==nil or s.vehicle~=vehicle or not s.settlement
        or (not s.isComplete and forReassessment~=true) then
        return false,"SETTLEMENT_STOP_NOT_ADMITTED"
    end
    s.stopping=true
    s.steadyMs=0
    s.steadyOrigin=nil
    return true
end

function M:settlementStopStatus(vehicle,dt)
    local s=self.active
    if s==nil or s.vehicle~=vehicle or not s.settlement
        or not s.stopping then
        return {isFailed=true,reason="SETTLEMENT_STOP_NOT_ACTIVE"}
    end
    if not finite(dt) or dt<=0 or dt>5000 then
        return {isFailed=true,reason="SETTLEMENT_STOP_CLOCK_INVALID"}
    end
    local off=type(Drivable)=="table" and Drivable.CRUISECONTROL_STATE_OFF
    if type(off)~="number" or type(vehicle.setCruiseControlState)~="function"
        or type(vehicle.getCruiseControlState)~="function" then
        return {isFailed=true,reason="SETTLEMENT_CRUISE_CONTROL_UNAVAILABLE"}
    end
    -- GIANTS driveToPoint sets cruise ACTIVE even with allowedToDrive=false.
    -- Therefore native neutral/braking MUST precede cruise-OFF, not follow it.
    local neutral=type(AIVehicleUtil)=="table"
        and type(AIVehicleUtil.driveToPoint)=="function"
        and pcall(AIVehicleUtil.driveToPoint,vehicle,dt,0,false,
            false,0,1,0,false)
    local changed=neutral and pcall(
        vehicle.setCruiseControlState,vehicle,off,true)
    local read,cruise=pcall(vehicle.getCruiseControlState,vehicle)
    if not changed or not neutral or not read or cruise~=off then
        return {isFailed=true,reason="SETTLEMENT_NEUTRAL_REQUEST_UNCONFIRMED"}
    end
    local raw=vehicle.lastSpeedReal
    local current=pose(vehicle.rootNode)
    if not finite(raw) or current==nil then
        return {isFailed=true,reason="SETTLEMENT_STOP_SPEED_OR_POSE_UNKNOWN"}
    end
    local speedMps=math.abs(raw)*1000 -- GIANTS lastSpeedReal is metres/ms
    if s.steadyOrigin==nil or speedMps>0.12 then
        s.steadyMs=0
        s.steadyOrigin=current
    else
        local dx,dz=current.x-s.steadyOrigin.x,
            current.z-s.steadyOrigin.z
        if dx*dx+dz*dz>0.04 then
            s.steadyMs=0
            s.steadyOrigin=current
        else
            s.steadyMs=s.steadyMs+dt
        end
    end
    if speedMps<=0.12 and s.steadyMs>=1200 then
        s.stopped=true
    end
    return {isStopped=s.stopped,speedMps=speedMps,
        steadyMs=s.steadyMs,cruiseState=cruise}
end

-- During map teardown GIANTS may already have deleted the root. There is
-- no valid physics object to neutralise: forget only the scoped Lua lease.
-- Normal completion, expiry and disable still call stop/cancelMovement.
function M:discardOnMapDelete(vehicle)
    local s=self.active
    if s==nil or s.vehicle~=vehicle then
        return false,"STATIC_DRIVE_NOT_ACTIVE"
    end
    vehicle.forceIsActive=s.oldForceIsActive
    self.active=nil
    return true
end

local function release(self,vehicle,requireComplete)
    local s=self.active
    if s==nil or s.vehicle~=vehicle then return false,"STATIC_DRIVE_NOT_ACTIVE" end
    if requireComplete and not s.isComplete then
        return false,"STATIC_REGION_NOT_REACHED"
    end
    if requireComplete and s.settlement and not s.stopped then
        return false,"SETTLEMENT_PHYSICAL_STOP_NOT_CONFIRMED"
    end
    local failures={}
    if type(AIVehicleUtil)=="table"
        and type(AIVehicleUtil.driveToPoint)=="function" then
        pcall(AIVehicleUtil.driveToPoint,vehicle,s.lastDt,0,false,
            false,0,1,0,false)
    end
    -- Completion parking never restores an engine's ACTIVE cruise state.
    -- A neutral drive call alone does not clear it in GIANTS.
    local off=type(Drivable)=="table" and Drivable.CRUISECONTROL_STATE_OFF
    if s.settlement then
        local applied=type(off)=="number"
            and type(vehicle.setCruiseControlState)=="function"
            and pcall(vehicle.setCruiseControlState,vehicle,off,true)
        if not applied then
            failures[#failures+1]="SETTLEMENT_CRUISE_OFF_REQUEST_FAILED"
        end
    end
    local cruise=vehicle.spec_drivable and vehicle.spec_drivable.cruiseControl
    local restored=pcall(vehicle.setCruiseControlMaxSpeed,vehicle,
        s.oldForwardSpeed,s.oldReverseSpeed)
    if not restored or type(cruise)~="table"
        or not finite(cruise.speed) or not finite(cruise.speedReverse)
        or math.abs(cruise.speed-s.oldForwardSpeed)>0.001
        or math.abs(cruise.speedReverse-s.oldReverseSpeed)>0.001 then
        failures[#failures+1]="STATIC_CRUISE_RESTORE_UNCONFIRMED"
    end
    if s.settlement then
        local read,state=pcall(vehicle.getCruiseControlState,vehicle)
        if not read or state~=off then
            failures[#failures+1]="SETTLEMENT_CRUISE_OFF_UNCONFIRMED"
        end
    end
    local stopMotor=(not s.settlement and s.startedMotor)
        or (s.settlement and not newlyAIActive(vehicle)
            and not playerClaimed(vehicle))
    if stopMotor then
        local stopped,answer=pcall(vehicle.stopMotor,vehicle,true)
        if not stopped or answer==false then
            failures[#failures+1]="STATIC_MOTOR_STOP_UNCONFIRMED"
        end
    end
    vehicle.forceIsActive=s.oldForceIsActive
    if #failures>0 then return false,table.concat(failures,",") end
    self.active=nil
    return true
end

function M:stopMovement(vehicle,forReassessment)
    if forReassessment==true then
        local s=self.active
        -- Releasing an incomplete guide still requires a verified
        -- stopped assembly and cruise-OFF; no unconfirmed handoff.
        if s==nil or s.vehicle~=vehicle or not s.settlement
            or s.stopped~=true then
            return false,"SETTLEMENT_REASSESSMENT_STOP_NOT_CONFIRMED"
        end
        return release(self,vehicle,false)
    end
    return release(self,vehicle,true)
end

function M:cancelMovement(vehicle)
    return release(self,vehicle,false)
end
