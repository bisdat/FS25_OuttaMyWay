-- Direct non-job physical movement of a nominated inactive assembly.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- GIANTS driveToPoint, native steering/reverser frames and bounded motor/physics
-- activity are used. This module never creates an AI job or scans geometry.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeStaticAssemblyDriveMechanism={}
local M=OuttaMyWay.NativeStaticAssemblyDriveMechanism
M.__index=M
local SPEED_CAP_KMH=8

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

local function controlled(vehicle)
    local mission=g_currentMission
    if mission~=nil and mission.controlledVehicle==vehicle then return true end
    if type(vehicle.getIsControlled)=="function" then
        local ok,result=pcall(vehicle.getIsControlled,vehicle)
        if not ok or result==true then return true end
    end
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
        or objective.returnRegion.source~="STATIC_CROSS_TRACK_REGION"
        or type(objective.moveForwards)~="boolean"
        or not finite(objective.targetX)
        or not finite(objective.targetZ)
        or type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.driveToPoint)~="function"
        or type(worldToLocal)~="function"
        or type(vehicle.getMotor)~="function"
        or type(vehicle.setCruiseControlMaxSpeed)~="function"
        or type(vehicle.getIsMotorStarted)~="function"
        or type(vehicle.startMotor)~="function"
        or type(vehicle.stopMotor)~="function"
        or controlled(vehicle) then
        return false,"STATIC_DRIVE_NATIVE_PRECONDITION_MISSING"
    end
    local origin=pose(vehicle.rootNode)
    if origin==nil then return false,"STATIC_DRIVE_POSE_UNAVAILABLE" end
    local nodeMethod=objective.moveForwards and "getAISteeringNode"
        or "getAIReverserNode"
    if type(vehicle[nodeMethod])~="function" then
        return false,"STATIC_DRIVE_NODE_UNAVAILABLE"
    end
    local read,node=pcall(vehicle[nodeMethod],vehicle)
    if not read or pose(node)==nil then
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
    local speed=math.min(SPEED_CAP_KMH,maxMps*3.6,
        cruise.maxSpeed,cruise.maxSpeedReverse)
    if speed<=0 then return false,"STATIC_NATIVE_DRIVE_SPEED_UNAVAILABLE" end
    local wasRunning,alreadyStarted=pcall(vehicle.getIsMotorStarted,vehicle)
    if not wasRunning or type(alreadyStarted)~="boolean" then
        return false,"STATIC_MOTOR_STATE_UNKNOWN"
    end
    -- Register potential effects before setters, so cancellation can restore
    -- cruise, physics activation and motor even after a partial native call.
    local state={
        vehicle=vehicle,objective=objective,node=node,toolNode=toolNode,
        oldForceIsActive=vehicle.forceIsActive,
        oldForwardSpeed=cruise.speed,oldReverseSpeed=cruise.speedReverse,
        speedKmh=speed,startedMotor=not alreadyStarted,
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
        if not started or answer==false then
            state.isFailed=true
            return false,"STATIC_MOTOR_START_FAILED"
        end
    end
    return true,{kind="STATIC_DIRECT_DRIVE_ARMED",
        requestedDriveSpeedKmh=speed,moveForwards=objective.moveForwards}
end

function M:movementStatus(vehicle,dt)
    local s=self.active
    if s==nil or s.vehicle~=vehicle then
        return {isFailed=true,reason="STATIC_DRIVE_NOT_ACTIVE"}
    end
    if s.isFailed then return {isFailed=true,reason=s.reason or "STATIC_DRIVE_FAILED"} end
    if controlled(vehicle) then
        s.isFailed=true;s.reason="STATIC_SUBJECT_CLAIMED"
        return {isFailed=true,reason=s.reason}
    end
    local p=pose(vehicle.rootNode)
    local progress=p and OuttaMyWay.ProjectedEgressRegion.progress(
        s.objective.returnRegion,p.x,p.z) or nil
    if progress==nil then
        s.isFailed=true;s.reason="STATIC_PROGRESS_UNAVAILABLE"
        return {isFailed=true,reason=s.reason}
    end
    if s.commanded>0 and progress.isInRegion then
        s.isComplete=true
        return {isComplete=true,progressM=progress.progressM}
    end
    local read,motorOn=pcall(vehicle.getIsMotorStarted,vehicle)
    if not read then
        s.isFailed=true;s.reason="STATIC_MOTOR_STATE_UNAVAILABLE"
        return {isFailed=true,reason=s.reason}
    end
    if motorOn~=true then
        return {isComplete=false,progressM=progress.progressM,
            reason="NATIVE_MOTOR_STARTING"}
    end
    local targetX,targetZ=s.objective.targetX,s.objective.targetZ
    if not s.objective.moveForwards then
        local x,z,reason=OuttaMyWay.NativeReverseMechanism.adjustToolTarget(
            s.node,s.toolNode,targetX,targetZ)
        if x==nil then
            s.isFailed=true;s.reason=reason or "STATIC_REVERSE_FRAME_UNAVAILABLE"
            return {isFailed=true,reason=s.reason}
        end
        targetX,targetZ=x,z
    end
    local ok,lx,_,lz=pcall(worldToLocal,s.node,targetX,p.y,targetZ)
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
    s.commanded=s.commanded+1
    local driven=pcall(AIVehicleUtil.driveToPoint,vehicle,s.lastDt,
        1,true,s.objective.moveForwards,lx/length,lz/length,s.speedKmh,false)
    if not driven then
        s.isFailed=true;s.reason="STATIC_NATIVE_DRIVE_FAILED"
        return {isFailed=true,reason=s.reason}
    end
    return {isComplete=false,progressM=progress.progressM,
        commandedDriveCount=s.commanded}
end

local function release(self,vehicle,requireComplete)
    local s=self.active
    if s==nil or s.vehicle~=vehicle then return false,"STATIC_DRIVE_NOT_ACTIVE" end
    if requireComplete and not s.isComplete then
        return false,"STATIC_REGION_NOT_REACHED"
    end
    local failures={}
    if type(AIVehicleUtil)=="table"
        and type(AIVehicleUtil.driveToPoint)=="function" then
        pcall(AIVehicleUtil.driveToPoint,vehicle,s.lastDt,0,false,
            false,0,1,0,false)
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
    if s.startedMotor then
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

function M:stopMovement(vehicle)
    return release(self,vehicle,true)
end

function M:cancelMovement(vehicle)
    return release(self,vehicle,false)
end
