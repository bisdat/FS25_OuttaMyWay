-- FS25_OuttaMyWay v0.1.0.0 CANONICAL CANDIDATE — validated post-job forward-direction actuator substrate retained unchanged from canonical v4.7.128.
-- D-0147 mechanical authority only. No traffic meaning, route construction or
-- spatial-proof policy lives here. Each direct drive call is guarded by the
-- validated Player Claim witness vehicle:getIsEntered(). v4.7.118 added
-- steering-state telemetry and positive actuation neutralisation; v4.7.119
-- validated one bounded Vehicle Activity Context so GIANTS WheelPhysics can
-- realise post-job steering; v4.7.120 validated fixed-world-direction actuation.
-- Current D-0147 consumes one Candidate-supplied fixed Infield Alignment and
-- Control terminates on its bounded retreat allowance, not Positive Field Exit.

OuttaMyWay.PostJobActuationAuthority={}
local Authority=OuttaMyWay.PostJobActuationAuthority
Authority.__index=Authority

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end
local function finite(v) return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge end
local function steeringPose(vehicle)
    local node=nil; local ok,value=safeCall(vehicle,"getAISteeringNode"); if ok and value~=nil and value~=0 then node=value end
    node=node or (vehicle and vehicle.rootNode or nil)
    if node==nil or node==0 or type(getWorldTranslation)~="function" then return nil end
    local good,x,y,z=pcall(getWorldTranslation,node); if not good then return nil end
    return node,x,y,z
end
function Authority.new() return setmetatable({directDriveCalls=0,neutralizeCalls=0,activityContextAcquireCalls=0,activityContextReleaseCalls=0},Authority) end

local function boolOrNil(ok,value) if ok then return value==true end return nil end
function Authority:steeringTelemetry(vehicle)
    if vehicle==nil then return {available=false,reason="VEHICLE_UNAVAILABLE"} end
    local controlledOk,controlled=safeCall(vehicle,"getIsControlled")
    local crab=vehicle.spec_crabSteering
    local telemetry={
        available=true,
        rotatedTime=tonumber(vehicle.rotatedTime),
        minRotTime=tonumber(vehicle.minRotTime),
        maxRotTime=tonumber(vehicle.maxRotTime),
        controlled=boolOrNil(controlledOk,controlled),
        isActive=vehicle.isActive==true,
        forceIsActive=vehicle.forceIsActive==true,
        crabState=type(crab)=="table" and tonumber(crab.state) or nil,
        crabAiSteeringModeIndex=type(crab)=="table" and tonumber(crab.aiSteeringModeIndex) or nil,
        wheels={}
    }
    local wheels=vehicle.spec_wheels and vehicle.spec_wheels.wheels or nil
    if type(wheels)=="table" then
        for index,wheel in ipairs(wheels) do
            local physics=wheel and wheel.physics or nil
            if type(physics)=="table" then
                local rotMin,rotMax=tonumber(physics.rotMin),tonumber(physics.rotMax)
                local steerable=(rotMin~=nil and rotMax~=nil and math.abs(rotMax-rotMin)>0.000001) or math.abs(tonumber(physics.rotSpeed) or 0)>0.000001 or math.abs(tonumber(physics.rotSpeedNeg) or 0)>0.000001
                if steerable then
                    telemetry.wheels[#telemetry.wheels+1]={
                        index=tonumber(wheel.wheelIndex) or index,
                        steeringAngle=tonumber(physics.steeringAngle),
                        rotMin=rotMin,rotMax=rotMax,
                        rotSpeed=tonumber(physics.rotSpeed),
                        rotSpeedNeg=tonumber(physics.rotSpeedNeg),
                        steeringOffset=tonumber(wheel.steeringOffset)
                    }
                    if #telemetry.wheels>=8 then break end
                end
            end
        end
    end
    telemetry.steerableWheelCount=#telemetry.wheels
    return telemetry
end
function Authority:isPlayerClaimed(vehicle)
    local ok,value=safeCall(vehicle,"getIsEntered"); return ok and value==true
end
function Authority:isSourceReactivated(vehicle)
    local ok,value=safeCall(vehicle,"getIsAIActive"); return ok and value==true
end

function Authority:acquireVehicleActivityContext(vehicle)
    if self:isPlayerClaimed(vehicle) then return false,"PLAYER_CLAIM" end
    if self:isSourceReactivated(vehicle) then return false,"SOURCE_INTENT_REACTIVATED" end
    if vehicle==nil then return false,"VEHICLE_UNAVAILABLE" end
    local context={previousForceIsActive=vehicle.forceIsActive,acquiredForceIsActive=true}
    vehicle.forceIsActive=true
    self.activityContextAcquireCalls=self.activityContextAcquireCalls+1
    context.acquireCall=self.activityContextAcquireCalls
    context.postAcquireSteering=self:steeringTelemetry(vehicle)
    return true,context
end
function Authority:releaseVehicleActivityContext(vehicle,context)
    if vehicle==nil then return false,"VEHICLE_UNAVAILABLE" end
    if type(context)~="table" or context.acquiredForceIsActive~=true then return false,"VEHICLE_ACTIVITY_CONTEXT_UNAVAILABLE" end
    vehicle.forceIsActive=context.previousForceIsActive
    self.activityContextReleaseCalls=self.activityContextReleaseCalls+1
    return true,{releaseCall=self.activityContextReleaseCalls,restoredForceIsActive=context.previousForceIsActive,postReleaseSteering=self:steeringTelemetry(vehicle)}
end
function Authority:position(vehicle)
    local _,x,_,z=steeringPose(vehicle); if x==nil then return nil end; return {x=x,z=z}
end
function Authority:heading(vehicle)
    local node=steeringPose(vehicle); if node==nil or type(localDirectionToWorld)~="function" then return nil end
    local ok,hx,_,hz=pcall(localDirectionToWorld,node,0,0,1)
    if not ok or not finite(hx) or not finite(hz) then return nil end
    local length=math.sqrt(hx*hx+hz*hz); if length<=0.000001 then return nil end
    return {x=hx/length,z=hz/length}
end
function Authority:maximumForwardSpeedKmh(vehicle)
    local motorOk,motor=safeCall(vehicle,"getMotor")
    if not motorOk or motor==nil or type(motor.getMaximumForwardSpeed)~="function" then return nil,"POST_JOB_MOTOR_MAX_FORWARD_SPEED_UNAVAILABLE" end
    local ok,value=pcall(motor.getMaximumForwardSpeed,motor)
    local speedMps=ok and tonumber(value) or nil
    if not finite(speedMps) or speedMps<=0 then return nil,"POST_JOB_MOTOR_MAX_FORWARD_SPEED_INVALID" end
    return speedMps*3.6,nil
end

local function steeringAngleLimitDeg(vehicle)
    -- AutoDrive's proven non-job donor uses the vehicle's maxRotation when
    -- available and otherwise the GIANTS helper's conventional 60-degree band.
    local value=tonumber(vehicle and vehicle.maxRotation)
    if finite(value) and math.abs(value)>0.0001 then
        value=math.abs(value)
        if value<=2*math.pi then value=math.deg(value) end
        if value>=1 then return value end
    end
    return 60
end

function Authority:driveInWorldDirection(vehicle,dt,directionX,directionZ,speedKmh)
    if self:isPlayerClaimed(vehicle) then return false,"PLAYER_CLAIM" end
    if self:isSourceReactivated(vehicle) then return false,"SOURCE_INTENT_REACTIVATED" end
    if AIVehicleUtil==nil or type(AIVehicleUtil.driveInDirection)~="function" then return false,"AIVEHICLEUTIL_DRIVE_IN_DIRECTION_UNAVAILABLE" end
    local node=steeringPose(vehicle); if node==nil then return false,"POST_JOB_POSE_UNAVAILABLE" end
    local dx,dz=tonumber(directionX),tonumber(directionZ)
    if not finite(dx) or not finite(dz) then return false,"POST_JOB_EXIT_DIRECTION_UNAVAILABLE" end
    local worldLength=math.sqrt(dx*dx+dz*dz); if worldLength<=0.000001 then return false,"POST_JOB_EXIT_DIRECTION_DEGENERATE" end
    dx,dz=dx/worldLength,dz/worldLength
    if type(worldDirectionToLocal)~="function" then return false,"WORLD_DIRECTION_TO_LOCAL_UNAVAILABLE" end
    local transformed,lx,_,lz=pcall(worldDirectionToLocal,node,dx,0,dz)
    if not transformed or not finite(lx) or not finite(lz) then return false,"WORLD_DIRECTION_TO_LOCAL_FAILED" end
    local localLength=math.sqrt(lx*lx+lz*lz); if localLength<=0.000001 then return false,"POST_JOB_LOCAL_EXIT_DIRECTION_DEGENERATE" end
    lx,lz=lx/localLength,lz/localLength

    -- driveInDirection is used by AutoDrive outside a GIANTS AI job. GIANTS'
    -- helper still expects legacy self.motor / self.cruiseControl fields, so
    -- provide those only for the duration of this call and restore exact prior
    -- values immediately afterwards. Vehicle Activity Context separately owns
    -- the WheelPhysics update gate; these compatibility fields do not create AI
    -- job identity or persist beyond the physical command.
    local motorOk,motor=safeCall(vehicle,"getMotor")
    local cruiseOk,cruiseState=safeCall(vehicle,"getCruiseControlState")
    if not motorOk or motor==nil then return false,"POST_JOB_MOTOR_UNAVAILABLE" end
    if not cruiseOk then return false,"POST_JOB_CRUISE_STATE_UNAVAILABLE" end
    local previousMotor,previousCruise=vehicle.motor,vehicle.cruiseControl
    vehicle.motor=motor
    vehicle.cruiseControl={state=cruiseState}
    local steeringLimit=steeringAngleLimitDeg(vehicle)
    self.directDriveCalls=self.directDriveCalls+1
    local ok,result=pcall(AIVehicleUtil.driveInDirection,vehicle,dt or 0,steeringLimit,1,0.8,steeringLimit,true,true,lx,lz,tonumber(speedKmh) or 8.0,1)
    vehicle.motor,vehicle.cruiseControl=previousMotor,previousCruise
    if not ok then return false,"POST_JOB_DIRECTION_DRIVE_CALL_FAILED:"..tostring(result) end
    local headingErrorDeg=math.deg(math.acos(math.max(-1,math.min(1,lz))))
    return true,{localDirectionX=lx,localDirectionZ=lz,headingErrorDeg=headingErrorDeg,steeringAngleLimitDeg=steeringLimit,directDriveCalls=self.directDriveCalls,postCommandSteering=self:steeringTelemetry(vehicle)}
end

function Authority:neutralize(vehicle,dt)
    if self:isPlayerClaimed(vehicle) then return false,"PLAYER_CLAIM" end
    if self:isSourceReactivated(vehicle) then return false,"SOURCE_INTENT_REACTIVATED" end
    if WheelsUtil==nil or type(WheelsUtil.updateWheelsPhysics)~="function" then return false,"WHEELSUTIL_UPDATE_PHYSICS_UNAVAILABLE" end
    self.neutralizeCalls=self.neutralizeCalls+1
    vehicle.rotatedTime=0
    local wheelOk,wheelResult=pcall(WheelsUtil.updateWheelsPhysics,vehicle,dt or 0,0,0,true,true)
    if not wheelOk then return false,"POST_JOB_NEUTRALIZE_WHEEL_PHYSICS_FAILED:"..tostring(wheelResult) end
    local brakeOk=nil; if type(vehicle.brake)=="function" then brakeOk=select(1,safeCall(vehicle,"brake",1)) end
    local stopOk=nil; if type(vehicle.stopVehicle)=="function" then stopOk=select(1,safeCall(vehicle,"stopVehicle")) end
    local cruiseOk=nil
    if type(vehicle.setCruiseControlState)=="function" and Drivable~=nil and Drivable.CRUISECONTROL_STATE_OFF~=nil then cruiseOk=select(1,safeCall(vehicle,"setCruiseControlState",Drivable.CRUISECONTROL_STATE_OFF,true)) end
    return true,{neutralizeCalls=self.neutralizeCalls,wheelPhysicsNeutralized=true,brakeRequested=brakeOk,stopVehicleRequested=stopOk,cruiseControlOffRequested=cruiseOk,postNeutralizeSteering=self:steeringTelemetry(vehicle)}
end
function Authority:stop(vehicle,dt) return self:neutralize(vehicle,dt) end
function Authority:getDirectDriveCallCount() return self.directDriveCalls end
function Authority:getNeutralizeCallCount() return self.neutralizeCalls end
function Authority:getActivityContextAcquireCallCount() return self.activityContextAcquireCalls end
function Authority:getActivityContextReleaseCallCount() return self.activityContextReleaseCalls end
