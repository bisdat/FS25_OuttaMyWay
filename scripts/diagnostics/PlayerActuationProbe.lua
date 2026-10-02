--- Engineering-only probe for causal player actuation during Obstruction Relocation.
-- Issue #412 TEST experiment. This module deliberately suppresses the historical
-- entered-state Player Claim so Reality can distinguish tab/seat presence from
-- actual player drive commands while the existing relocation continues.
--
-- This probe owns no production Player Claim semantics. Its action observations
-- are diagnostic evidence only and MUST NOT be consumed as authority in this TEST.

OuttaMyWay.PlayerActuationProbe={}
local Probe=OuttaMyWay.PlayerActuationProbe

local publication=OuttaMyWay.LogPublication.origin("CONTROL")
local installed=false
local samples=setmetatable({},{__mode="k"})
local HEARTBEAT_MS=250

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function boolText(ok,value)
    if ok~=true then return "UNOBSERVED" end
    return value==true and "true" or "false"
end

local function numberText(value)
    return type(value)=="number" and string.format("%.6f",value) or "nil"
end

local function rootVehicle(object)
    if object==nil then return nil end
    local ok,root=safeCall(object,"getRootVehicle")
    if ok and root~=nil then return root end
    return object
end

local function activeRelocation(vehicle)
    local control=OuttaMyWay.obstructionRelocationControl
    local state=control and control.active or nil
    if type(state)~="table" then return nil end
    local activeVehicle=state.vehicle
    if activeVehicle==nil and control~=nil and type(control._vehicle)=="function" then
        activeVehicle=control:_vehicle(state.assemblyReferenceKey)
    end
    if rootVehicle(activeVehicle)~=rootVehicle(vehicle) then return nil end
    return state
end

local function lastInputText(vehicle)
    local spec=vehicle and vehicle.spec_drivable or nil
    local last=type(spec)=="table" and spec.lastInputValues or nil
    if type(last)~="table" then
        return "accelerate=nil brake=nil steer=nil axisForward=nil axisSide=nil handbrake=nil"
    end
    return string.format(
        "accelerate=%s brake=%s steer=%s axisForward=%s axisSide=%s handbrake=%s",
        numberText(last.axisAccelerate),numberText(last.axisBrake),numberText(last.axisSteer),
        numberText(spec.axisForward),numberText(spec.axisSide),tostring(spec.doHandbrake))
end

local function stateText(vehicle)
    local enteredOk,entered=safeCall(vehicle,"getIsEntered")
    local controlledOk,controlled=safeCall(vehicle,"getIsControlled")
    local aiOk,ai=safeCall(vehicle,"getIsAIActive")
    local motorStartedOk,motorStarted=safeCall(vehicle,"getIsMotorStarted")
    local motorStateOk,motorState=safeCall(vehicle,"getMotorState")
    local automaticStart=g_currentMission
        and g_currentMission.missionInfo
        and g_currentMission.missionInfo.automaticMotorStartEnabled
    return string.format(
        "entered=%s controlled=%s aiActive=%s motorStarted=%s motorState=%s automaticMotorStart=%s speedKmh=%s",
        boolText(enteredOk,entered),boolText(controlledOk,controlled),boolText(aiOk,ai),
        boolText(motorStartedOk,motorStarted),motorStateOk and tostring(motorState) or "UNOBSERVED",
        tostring(automaticStart==true),numberText(math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0)*3600))
end

local function shouldPublish(vehicle,action,inputValue,always)
    local perVehicle=samples[vehicle]
    if perVehicle==nil then perVehicle={}; samples[vehicle]=perVehicle end
    local item=perVehicle[action] or {lastValue=0,lastPublishedAt=nil}
    perVehicle[action]=item
    local value=tonumber(inputValue) or 0
    local now=tonumber(g_time) or 0
    local nonZero=value~=0
    local wasNonZero=(tonumber(item.lastValue) or 0)~=0
    local due=item.lastPublishedAt==nil or now-item.lastPublishedAt>=HEARTBEAT_MS
    local publish=always==true or (nonZero and (not wasNonZero or due)) or (not nonZero and wasNonZero)
    item.lastValue=value
    if publish then item.lastPublishedAt=now end
    return publish,value
end

local function observe(vehicle,action,inputValue,callbackState,isAnalog,extra,always)
    local state=activeRelocation(vehicle)
    if state==nil then return false,"NO_ACTIVE_OBSTRUCTION_RELOCATION_FOR_VEHICLE" end
    local publish,value=shouldPublish(vehicle,action,inputValue,always)
    if not publish then return false,"UNCHANGED_INPUT_WITHIN_HEARTBEAT" end
    publication:info("DIAGNOSTIC","PLAYER_ACTUATION_PROBE",
        "commitment=%s assembly=%s ref=%s action=%s input=%s callbackState=%s analog=%s %s %s lastInput={%s} claimAuthority=false diagnosticOnly=true",
        tostring(state.commitmentId),tostring(state.assemblyId),tostring(state.assemblyReferenceKey),
        tostring(action),numberText(value),tostring(callbackState),tostring(isAnalog==true),
        stateText(vehicle),tostring(extra or ""),lastInputText(vehicle))
    return true,"PUBLISHED"
end

-- TEST-only switch consumed by the three historical entered-state Player Claim
-- sites. Presence remains observable; it simply cannot terminate relocation in
-- this diagnostic build.
function Probe.suppressesEnteredClaim()
    return true
end

function Probe.observeDriveAction(vehicle,action,inputValue,callbackState,isAnalog,extra)
    return observe(vehicle,action,inputValue,callbackState,isAnalog,extra,false)
end

function Probe.observeMotorAction(vehicle,action,inputValue,callbackState,isAnalog)
    return observe(vehicle,action,inputValue,callbackState,isAnalog,"motorCommand=true",true)
end

function Probe.install()
    if installed then return true,"ALREADY_INSTALLED" end
    if Utils==nil or type(Utils.appendedFunction)~="function" then
        return false,"APPENDED_FUNCTION_UNAVAILABLE"
    end
    if Drivable==nil then return false,"DRIVABLE_UNAVAILABLE" end

    if type(Drivable.actionEventAccelerate)=="function" then
        Drivable.actionEventAccelerate=Utils.appendedFunction(
            Drivable.actionEventAccelerate,
            function(self,actionName,inputValue,callbackState,isAnalog)
                Probe.observeDriveAction(self,"ACCELERATE",inputValue,callbackState,isAnalog)
            end)
    end
    if type(Drivable.actionEventBrake)=="function" then
        Drivable.actionEventBrake=Utils.appendedFunction(
            Drivable.actionEventBrake,
            function(self,actionName,inputValue,callbackState,isAnalog)
                Probe.observeDriveAction(self,"BRAKE",inputValue,callbackState,isAnalog)
            end)
    end
    if type(Drivable.actionEventSteer)=="function" then
        Drivable.actionEventSteer=Utils.appendedFunction(
            Drivable.actionEventSteer,
            function(self,actionName,inputValue,callbackState,isAnalog,isMouse,deviceCategory,binding)
                Probe.observeDriveAction(
                    self,"STEER",inputValue,callbackState,isAnalog,
                    string.format("mouse=%s deviceCategory=%s binding=%s",tostring(isMouse==true),tostring(deviceCategory),tostring(binding)))
            end)
    end

    if Motorized~=nil then
        local function appendMotor(functionName,action)
            if type(Motorized[functionName])=="function" then
                Motorized[functionName]=Utils.appendedFunction(
                    Motorized[functionName],
                    function(self,actionName,inputValue,callbackState,isAnalog)
                        Probe.observeMotorAction(self,action,inputValue,callbackState,isAnalog)
                    end)
            end
        end
        appendMotor("actionEventToggleMotorState","MOTOR_TOGGLE")
        appendMotor("actionEventSetMotorStateIgnition","MOTOR_IGNITION")
        appendMotor("actionEventSetMotorStateOn","MOTOR_ON")
        appendMotor("actionEventSetMotorStateOff","MOTOR_OFF")
    end

    installed=true
    return true,"INSTALLED"
end

Probe.install()
