-- Passive GIANTS FIELDWORK stop-reason witness for Issue #476.
-- Specification Jurisdictions: `NATIVE_JOB_COMPLETION_OBSERVATION`
-- This diagnostic never starts, stops, configures or moves a vehicle.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeJobCompletionProbe={}
local Probe=OuttaMyWay.NativeJobCompletionProbe
Probe.__index=Probe
local publication=OuttaMyWay.LogPublication.origin("NATIVE_JOB_COMPLETION")

local function isInstance(value,klass)
    if type(value)~="table" or type(klass)~="table"
        or type(value.isa)~="function" then return false end
    local ok,result=pcall(value.isa,value,klass)
    return ok and result==true
end

local function isFieldWorkJob(job)
    return isInstance(job,AIJobFieldWork)
end

local function isSuccessMessage(aiMessage)
    return isInstance(aiMessage,AIMessageSuccessFinishedJob)
end

local function vehicleOf(job)
    local parameter=job and job.vehicleParameter
    if parameter==nil or type(parameter.getVehicle)~="function" then return nil end
    local ok,vehicle=pcall(parameter.getVehicle,parameter)
    if ok and type(vehicle)=="table" then return vehicle end
    return nil
end

local function vehicleIdentity(vehicle)
    if vehicle==nil then return "unavailable" end
    if vehicle.rootNode~=nil then return tostring(vehicle.rootNode) end
    return "unavailable"
end

local function messageIdentity(aiMessage)
    if aiMessage==nil then return "nil" end
    if isSuccessMessage(aiMessage) then return "AIMessageSuccessFinishedJob" end
    if type(aiMessage)=="table" then
        if type(aiMessage.className)=="string" then return aiMessage.className end
        if type(aiMessage.class)=="table"
            and type(aiMessage.class.className)=="string" then
            return aiMessage.class.className
        end
    end
    return "other-or-unknown"
end

function Probe.new(configuration)
    return setmetatable({configuration=configuration,subscribed=false,seen={}},Probe)
end

function Probe:onJobStopped(job,aiMessage)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true
        or not isFieldWorkJob(job) then return end
    if self.seen[job] then return end
    self.seen[job]=true

    -- Do not collapse the native message into a claim of completed agronomy.
    -- This witness has no connection to Terminal Egress Control.
    publication:publish("DIAGNOSTIC","INFO","NATIVE_FIELDWORK_JOB_STOPPED",function()
        return {
            jobId=job.jobId or "unavailable",
            rootNode=vehicleIdentity(vehicleOf(job)),
            message=messageIdentity(aiMessage),
            successClass=isSuccessMessage(aiMessage),
            version=OuttaMyWay.VERSION
        }
    end)
end

function Probe:loadMap()
    self.seen={}
    if g_server==nil or g_messageCenter==nil
        or MessageType==nil or MessageType.AI_JOB_STOPPED==nil
        or type(g_messageCenter.subscribe)~="function" then return end
    g_messageCenter:subscribe(MessageType.AI_JOB_STOPPED,self.onJobStopped,self)
    self.subscribed=true
end

function Probe:deleteMap()
    if self.subscribed and g_messageCenter~=nil
        and type(g_messageCenter.unsubscribeAll)=="function" then
        g_messageCenter:unsubscribeAll(self)
    end
    self.subscribed=false
    self.seen={}
end
