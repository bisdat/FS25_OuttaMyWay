--- Observes causal player-originated vehicle commands without assigning Player Actuation Claim semantics.
-- Specification Jurisdictions: `OBSERVATION`

OuttaMyWay.PlayerActuationObservation={}
local Observation=OuttaMyWay.PlayerActuationObservation

local installed=false
local available=false
local installReason="NOT_INSTALLED"
local nextSequence=0
local latestByReference={}

local function safeCall(object,methodName,...)
    if object==nil or type(object[methodName])~="function" then return false,nil end
    return pcall(object[methodName],object,...)
end

local function rootVehicle(object)
    if type(object)~="table" then return nil end
    local ok,root=safeCall(object,"getRootVehicle")
    if ok and type(root)=="table" and root.rootNode~=nil and root.rootNode~=0 then return root end
    if object.rootNode~=nil and object.rootNode~=0 then return object end
    return nil
end

local function referenceKey(object)
    local root=rootVehicle(object)
    if root==nil then return nil,nil end
    return "vehicle-root:"..tostring(root.rootNode),root
end

local function record(object,action,inputAction,inputValue,callbackState,isAnalog,always)
    local value=tonumber(inputValue) or 0
    if always~=true and value==0 then return false,"ZERO_INPUT_NOT_CAUSAL" end
    local ref,root=referenceKey(object)
    if ref==nil then return false,"PLAYER_ACTUATION_SUBJECT_UNAVAILABLE" end
    nextSequence=nextSequence+1
    latestByReference[ref]={
        sequence=nextSequence,
        timestampMs=tonumber(g_time) or 0,
        assemblyReferenceKey=ref,
        action=action,
        inputAction=tostring(inputAction),
        inputValue=value,
        callbackState=callbackState,
        isAnalog=isAnalog==true,
        provenance={
            source="PlayerActuationObservation",
            authority="CAUSAL_PLAYER_COMMAND_EVIDENCE_ONLY",
            semanticAuthority=false,
            rootNode=root.rootNode
        }
    }
    return true,"RECORDED"
end

function Observation.latest(referenceKeyValue)
    return latestByReference[referenceKeyValue]
end

function Observation.isAvailable()
    return available,installReason
end

function Observation.reset()
    latestByReference={}
end

function Observation.install()
    if installed then return true,"ALREADY_INSTALLED" end
    if Utils==nil or type(Utils.appendedFunction)~="function" then available=false; installReason="APPENDED_FUNCTION_UNAVAILABLE"; return false,installReason end
    if Drivable==nil then available=false; installReason="DRIVABLE_UNAVAILABLE"; return false,installReason end

    if type(Drivable.actionEventAccelerate)=="function" then
        Drivable.actionEventAccelerate=Utils.appendedFunction(
            Drivable.actionEventAccelerate,
            function(self,actionName,inputValue,callbackState,isAnalog)
                record(self,"ACCELERATE",actionName,inputValue,callbackState,isAnalog,false)
            end)
    end
    if type(Drivable.actionEventBrake)=="function" then
        Drivable.actionEventBrake=Utils.appendedFunction(
            Drivable.actionEventBrake,
            function(self,actionName,inputValue,callbackState,isAnalog)
                record(self,"BRAKE",actionName,inputValue,callbackState,isAnalog,false)
            end)
    end
    if type(Drivable.actionEventSteer)=="function" then
        Drivable.actionEventSteer=Utils.appendedFunction(
            Drivable.actionEventSteer,
            function(self,actionName,inputValue,callbackState,isAnalog)
                record(self,"STEER",actionName,inputValue,callbackState,isAnalog,false)
            end)
    end

    if Motorized~=nil then
        local function appendMotor(functionName,action)
            if type(Motorized[functionName])=="function" then
                Motorized[functionName]=Utils.appendedFunction(
                    Motorized[functionName],
                    function(self,actionName,inputValue,callbackState,isAnalog)
                        record(self,action,actionName,inputValue,callbackState,isAnalog,true)
                    end)
            end
        end
        appendMotor("actionEventToggleMotorState","MOTOR_TOGGLE")
        appendMotor("actionEventSetMotorStateIgnition","MOTOR_IGNITION")
        appendMotor("actionEventSetMotorStateOn","MOTOR_ON")
        appendMotor("actionEventSetMotorStateOff","MOTOR_OFF")
    end

    installed=true
    available=true
    installReason="INSTALLED"
    return true,installReason
end

Observation.install()
