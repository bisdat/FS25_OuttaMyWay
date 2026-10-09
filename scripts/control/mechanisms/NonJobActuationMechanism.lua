--- Provides subordinate non-job physical actuation, claim checks and neutralisation below Control without relocation-purpose authority.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`

-- Shared non-job physical actuation mechanism for provenance-neutral Obstruction Relocation.
-- Mechanical safety boundary only: semantic movement permission remains in the
-- current Responsibility / Bounded Authority / Control path. This mechanism neither
-- infers historical Job provenance nor creates relocation purpose.
-- Current player control and source-AI reactivation remain higher-priority Reality boundaries.

OuttaMyWay.NonJobActuationMechanism={}
local Mechanism=OuttaMyWay.NonJobActuationMechanism
Mechanism.__index=Mechanism

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
function Mechanism.new() return setmetatable({directDriveCalls=0,neutralizeCalls=0,activityContextAcquireCalls=0,activityContextReleaseCalls=0,propulsionStartCalls=0,propulsionStopCalls=0,deferredPropulsionRestoration=setmetatable({}, {__mode="k"})},Mechanism) end

local function boolOrNil(ok,value) if ok then return value==true end return nil end
function Mechanism:steeringTelemetry(vehicle)
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
function Mechanism:isPlayerControlled(vehicle)
    return OuttaMyWay.CurrentPlayerControlObservation.isControlled(g_currentMission,vehicle)
end
function Mechanism:isSourceReactivated(vehicle)
    local ok,value=safeCall(vehicle,"getIsAIActive"); return ok and value==true
end

function Mechanism:acquireVehicleActivityContext(vehicle)
    if self:isPlayerControlled(vehicle) then return false,"PLAYER_CONTROL" end
    if self:isSourceReactivated(vehicle) then return false,"SOURCE_INTENT_REACTIVATED" end
    if vehicle==nil then return false,"VEHICLE_UNAVAILABLE" end
    local context={previousForceIsActive=vehicle.forceIsActive,acquiredForceIsActive=true}
    vehicle.forceIsActive=true
    self.activityContextAcquireCalls=self.activityContextAcquireCalls+1
    context.acquireCall=self.activityContextAcquireCalls
    context.postAcquireSteering=self:steeringTelemetry(vehicle)
    return true,context
end
function Mechanism:releaseVehicleActivityContext(vehicle,context)
    if vehicle==nil then return false,"VEHICLE_UNAVAILABLE" end
    if type(context)~="table" or context.acquiredForceIsActive~=true then return false,"VEHICLE_ACTIVITY_CONTEXT_UNAVAILABLE" end
    vehicle.forceIsActive=context.previousForceIsActive
    self.activityContextReleaseCalls=self.activityContextReleaseCalls+1
    return true,{releaseCall=self.activityContextReleaseCalls,restoredForceIsActive=context.previousForceIsActive,postReleaseSteering=self:steeringTelemetry(vehicle)}
end

local function motorStateEvidence(vehicle)
    if type(MotorState)~="table"
        or MotorState.OFF==nil or MotorState.IGNITION==nil
        or MotorState.STARTING==nil or MotorState.ON==nil then
        return nil,"NON_JOB_MOTOR_STATE_ENUM_UNAVAILABLE"
    end
    local stateOk,state=safeCall(vehicle,"getMotorState")
    if not stateOk then return nil,"NON_JOB_MOTOR_STATE_UNAVAILABLE" end
    local runningOk,running=safeCall(vehicle,"getIsMotorStarted")
    if not runningOk then return nil,"NON_JOB_MOTOR_RUNNING_STATE_UNAVAILABLE" end
    return {state=state,running=running==true},nil
end

function Mechanism:refreshDeferredPropulsionRestoration()
    local cleared=0
    for vehicle,_ in pairs(self.deferredPropulsionRestoration) do
        if vehicle==nil or vehicle.isDeleted==true or self:isSourceReactivated(vehicle) then
            self.deferredPropulsionRestoration[vehicle]=nil
            cleared=cleared+1
        else
            local evidence=motorStateEvidence(vehicle)
            if evidence~=nil and evidence.state~=MotorState.STARTING and evidence.state~=MotorState.ON then
                self.deferredPropulsionRestoration[vehicle]=nil
                cleared=cleared+1
            end
        end
    end
    return cleared
end

function Mechanism:clearDeferredPropulsionRestoration()
    self.deferredPropulsionRestoration=setmetatable({}, {__mode="k"})
end

function Mechanism:acquirePropulsionContext(vehicle)
    if self:isPlayerControlled(vehicle) then return false,"PLAYER_CONTROL" end
    if self:isSourceReactivated(vehicle) then
        self.deferredPropulsionRestoration[vehicle]=nil
        return false,"SOURCE_INTENT_REACTIVATED"
    end
    self:refreshDeferredPropulsionRestoration()
    local evidence,reason=motorStateEvidence(vehicle)
    if evidence==nil then return false,reason end
    local inheritedDebt=self.deferredPropulsionRestoration[vehicle]
    local context={
        initialState=evidence.state,
        initialRunning=evidence.running,
        startedByOuttaMyWay=inheritedDebt~=nil,
        inheritedRestorationDebt=inheritedDebt~=nil,
        restorationOriginState=inheritedDebt and inheritedDebt.restorationOriginState or evidence.state,
        readyObserved=evidence.running
    }
    if inheritedDebt~=nil then
        if evidence.running then return true,context end
        if evidence.state==MotorState.STARTING then
            context.transitionalStartObserved=true
            return true,context
        end
        self.deferredPropulsionRestoration[vehicle]=nil
        context.startedByOuttaMyWay=false
        context.inheritedRestorationDebt=false
        context.restorationOriginState=evidence.state
    end
    if evidence.running then return true,context end
    if evidence.state==MotorState.STARTING then
        context.transitionalStartObserved=true
        return true,context
    end
    if evidence.state~=MotorState.OFF and evidence.state~=MotorState.IGNITION then
        return false,"NON_JOB_MOTOR_STATE_UNSUPPORTED:"..tostring(evidence.state)
    end
    local canRunOk,canRun=safeCall(vehicle,"getCanMotorRun")
    if not canRunOk then return false,"NON_JOB_MOTOR_CAN_RUN_UNAVAILABLE" end
    if canRun~=true then return false,"NON_JOB_MOTOR_CANNOT_RUN" end
    local startOk=safeCall(vehicle,"startMotor",true)
    if not startOk then return false,"NON_JOB_MOTOR_START_FAILED" end
    self.propulsionStartCalls=self.propulsionStartCalls+1
    context.startedByOuttaMyWay=true
    context.restorationOriginState=evidence.state
    context.startCall=self.propulsionStartCalls
    local after,afterReason=motorStateEvidence(vehicle)
    if after~=nil then
        context.postStartState=after.state
        context.readyObserved=after.running
    else
        context.postStartEvidenceUnavailable=afterReason
    end
    return true,context
end

function Mechanism:propulsionReadiness(vehicle,context)
    if type(context)~="table" then return "FAILED",{reason="NON_JOB_PROPULSION_CONTEXT_UNAVAILABLE"} end
    local evidence,reason=motorStateEvidence(vehicle)
    if evidence==nil then return "FAILED",{reason=reason} end
    if evidence.running then
        context.readyObserved=true
        return "READY",{state=evidence.state,running=true,owned=context.startedByOuttaMyWay==true}
    end
    if context.readyObserved==true then
        return "FAILED",{reason="NON_JOB_PROPULSION_READINESS_LOST",state=evidence.state,running=false,owned=context.startedByOuttaMyWay==true}
    end
    if evidence.state==MotorState.STARTING then
        return "PENDING",{reason="NON_JOB_PROPULSION_STARTING",state=evidence.state,running=false,owned=context.startedByOuttaMyWay==true}
    end
    local notReadyReason=context.startedByOuttaMyWay==true and "NON_JOB_PROPULSION_START_DID_NOT_PROGRESS" or "NON_JOB_PROPULSION_NOT_RUNNING"
    return "FAILED",{reason=notReadyReason,state=evidence.state,running=false,owned=context.startedByOuttaMyWay==true}
end

function Mechanism:releasePropulsionContext(vehicle,context)
    if type(context)~="table" then return false,"NON_JOB_PROPULSION_CONTEXT_UNAVAILABLE" end
    if context.startedByOuttaMyWay~=true then
        return true,{owned=false,stopRequested=false,stopped=false,reason="PROPULSION_NOT_OWNED"}
    end
    if vehicle==nil then return false,"VEHICLE_UNAVAILABLE" end
    local restorationDebt={
        restorationOriginState=context.restorationOriginState or context.initialState,
        deferredByPlayerControl=false
    }
    if self:isPlayerControlled(vehicle) then
        restorationDebt.deferredByPlayerControl=true
        self.deferredPropulsionRestoration[vehicle]=restorationDebt
        return true,{owned=true,stopRequested=false,stopped=false,deferred=true,reason="PLAYER_CONTROL_HIGHER_AUTHORITY"}
    end
    if self:isSourceReactivated(vehicle) then
        self.deferredPropulsionRestoration[vehicle]=nil
        return true,{owned=true,stopRequested=false,stopped=false,relinquished=true,reason="SOURCE_INTENT_REACTIVATED_HIGHER_AUTHORITY"}
    end
    self.deferredPropulsionRestoration[vehicle]=restorationDebt
    local before,reason=motorStateEvidence(vehicle)
    if before==nil then return false,reason end
    if before.state==MotorState.OFF and before.running~=true then
        self.deferredPropulsionRestoration[vehicle]=nil
        return true,{owned=true,stopRequested=false,stopped=true,reason="ALREADY_STOPPED",state=before.state}
    end
    local stopOk=safeCall(vehicle,"stopMotor",true)
    if not stopOk then return false,"NON_JOB_MOTOR_STOP_FAILED" end
    self.propulsionStopCalls=self.propulsionStopCalls+1
    local after,afterReason=motorStateEvidence(vehicle)
    if after==nil then return false,afterReason end
    if after.state~=MotorState.OFF or after.running==true then
        return false,"NON_JOB_MOTOR_STOP_NOT_SETTLED:"..tostring(after.state)
    end
    self.deferredPropulsionRestoration[vehicle]=nil
    return true,{owned=true,stopRequested=true,stopped=true,stopCall=self.propulsionStopCalls,state=after.state,inheritedRestorationDebt=context.inheritedRestorationDebt==true}
end

function Mechanism:position(vehicle)
    local _,x,_,z=steeringPose(vehicle); if x==nil then return nil end; return {x=x,z=z}
end
function Mechanism:heading(vehicle)
    local node=steeringPose(vehicle); if node==nil or type(localDirectionToWorld)~="function" then return nil end
    local ok,hx,_,hz=pcall(localDirectionToWorld,node,0,0,1)
    if not ok or not finite(hx) or not finite(hz) then return nil end
    local length=math.sqrt(hx*hx+hz*hz); if length<=0.000001 then return nil end
    return {x=hx/length,z=hz/length}
end
function Mechanism:maximumForwardSpeedKmh(vehicle)
    local motorOk,motor=safeCall(vehicle,"getMotor")
    if not motorOk or motor==nil or type(motor.getMaximumForwardSpeed)~="function" then return nil,"NON_JOB_MOTOR_MAX_FORWARD_SPEED_UNAVAILABLE" end
    local ok,value=pcall(motor.getMaximumForwardSpeed,motor)
    local speedMps=ok and tonumber(value) or nil
    if not finite(speedMps) or speedMps<=0 then return nil,"NON_JOB_MOTOR_MAX_FORWARD_SPEED_INVALID" end
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

function Mechanism:driveInWorldDirection(vehicle,dt,directionX,directionZ,speedKmh)
    if self:isPlayerControlled(vehicle) then return false,"PLAYER_CONTROL" end
    if self:isSourceReactivated(vehicle) then return false,"SOURCE_INTENT_REACTIVATED" end
    if AIVehicleUtil==nil or type(AIVehicleUtil.driveInDirection)~="function" then return false,"AIVEHICLEUTIL_DRIVE_IN_DIRECTION_UNAVAILABLE" end
    local node=steeringPose(vehicle); if node==nil then return false,"NON_JOB_POSE_UNAVAILABLE" end
    local dx,dz=tonumber(directionX),tonumber(directionZ)
    if not finite(dx) or not finite(dz) then return false,"NON_JOB_EXIT_DIRECTION_UNAVAILABLE" end
    local worldLength=math.sqrt(dx*dx+dz*dz); if worldLength<=0.000001 then return false,"NON_JOB_EXIT_DIRECTION_DEGENERATE" end
    dx,dz=dx/worldLength,dz/worldLength
    if type(worldDirectionToLocal)~="function" then return false,"WORLD_DIRECTION_TO_LOCAL_UNAVAILABLE" end
    local transformed,lx,_,lz=pcall(worldDirectionToLocal,node,dx,0,dz)
    if not transformed or not finite(lx) or not finite(lz) then return false,"WORLD_DIRECTION_TO_LOCAL_FAILED" end
    local localLength=math.sqrt(lx*lx+lz*lz); if localLength<=0.000001 then return false,"NON_JOB_LOCAL_EXIT_DIRECTION_DEGENERATE" end
    lx,lz=lx/localLength,lz/localLength

    -- driveInDirection is used by AutoDrive outside a GIANTS AI job. GIANTS'
    -- helper still expects legacy self.motor / self.cruiseControl fields, so
    -- provide those only for the duration of this call and restore exact prior
    -- values immediately afterwards. Vehicle Activity Context separately owns
    -- the WheelPhysics update gate; these compatibility fields do not create AI
    -- job identity or persist beyond the physical command.
    local motorOk,motor=safeCall(vehicle,"getMotor")
    local cruiseOk,cruiseState=safeCall(vehicle,"getCruiseControlState")
    if not motorOk or motor==nil then return false,"NON_JOB_MOTOR_UNAVAILABLE" end
    if not cruiseOk then return false,"NON_JOB_CRUISE_STATE_UNAVAILABLE" end
    local previousMotor,previousCruise=vehicle.motor,vehicle.cruiseControl
    vehicle.motor=motor
    vehicle.cruiseControl={state=cruiseState}
    local steeringLimit=steeringAngleLimitDeg(vehicle)
    self.directDriveCalls=self.directDriveCalls+1
    local ok,result=pcall(AIVehicleUtil.driveInDirection,vehicle,dt or 0,steeringLimit,1,0.8,steeringLimit,true,true,lx,lz,tonumber(speedKmh) or 8.0,1)
    vehicle.motor,vehicle.cruiseControl=previousMotor,previousCruise
    if not ok then return false,"NON_JOB_DIRECTION_DRIVE_CALL_FAILED:"..tostring(result) end
    local headingErrorDeg=math.deg(math.acos(math.max(-1,math.min(1,lz))))
    return true,{localDirectionX=lx,localDirectionZ=lz,headingErrorDeg=headingErrorDeg,steeringAngleLimitDeg=steeringLimit,directDriveCalls=self.directDriveCalls,postCommandSteering=self:steeringTelemetry(vehicle)}
end

function Mechanism:neutralize(vehicle,dt)
    if self:isPlayerControlled(vehicle) then return false,"PLAYER_CONTROL" end
    if self:isSourceReactivated(vehicle) then return false,"SOURCE_INTENT_REACTIVATED" end
    if WheelsUtil==nil or type(WheelsUtil.updateWheelsPhysics)~="function" then return false,"WHEELSUTIL_UPDATE_PHYSICS_UNAVAILABLE" end
    self.neutralizeCalls=self.neutralizeCalls+1
    vehicle.rotatedTime=0
    local wheelOk,wheelResult=pcall(WheelsUtil.updateWheelsPhysics,vehicle,dt or 0,0,0,true,true)
    if not wheelOk then return false,"NON_JOB_NEUTRALIZE_WHEEL_PHYSICS_FAILED:"..tostring(wheelResult) end
    local brakeOk=nil; if type(vehicle.brake)=="function" then brakeOk=select(1,safeCall(vehicle,"brake",1)) end
    local stopOk=nil; if type(vehicle.stopVehicle)=="function" then stopOk=select(1,safeCall(vehicle,"stopVehicle")) end
    local cruiseOk=nil
    if type(vehicle.setCruiseControlState)=="function" and Drivable~=nil and Drivable.CRUISECONTROL_STATE_OFF~=nil then cruiseOk=select(1,safeCall(vehicle,"setCruiseControlState",Drivable.CRUISECONTROL_STATE_OFF,true)) end
    return true,{neutralizeCalls=self.neutralizeCalls,wheelPhysicsNeutralized=true,brakeRequested=brakeOk,stopVehicleRequested=stopOk,cruiseControlOffRequested=cruiseOk,postNeutralizeSteering=self:steeringTelemetry(vehicle)}
end
function Mechanism:stop(vehicle,dt) return self:neutralize(vehicle,dt) end
function Mechanism:getDirectDriveCallCount() return self.directDriveCalls end
function Mechanism:getNeutralizeCallCount() return self.neutralizeCalls end
function Mechanism:getActivityContextAcquireCallCount() return self.activityContextAcquireCalls end
function Mechanism:getActivityContextReleaseCallCount() return self.activityContextReleaseCalls end
function Mechanism:getPropulsionStartCallCount() return self.propulsionStartCalls end
function Mechanism:getPropulsionStopCallCount() return self.propulsionStopCalls end
