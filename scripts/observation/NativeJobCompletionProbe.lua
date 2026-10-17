-- Passive GIANTS FIELDWORK stop-reason witness for Issue #476.
-- Specification Jurisdictions: `NATIVE_JOB_COMPLETION_OBSERVATION`
-- This diagnostic never starts, stops, configures or moves a vehicle.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeJobCompletionProbe={}
local Probe=OuttaMyWay.NativeJobCompletionProbe
Probe.__index=Probe
local publication=OuttaMyWay.LogPublication.origin("NATIVE_JOB_COMPLETION")
local SOURCE_INTERVAL_MS=1000
local MAX_ACTIVE_REGISTRY=512

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
    return setmetatable({configuration=configuration,subscribed=false,
        seen={},sourceFields=setmetatable({},{__mode="k"}),sourceSampleElapsedMs=0,
        completionListener=nil},Probe)
end

function Probe:setCompletionListener(listener)
    self.completionListener=listener
end

-- This is a DIAGNOSTIC-only identity experiment. Sample the active native
-- job, never retrospectively infer its field from the stopped vehicle root.
-- The seed match is only a candidate witness, not production field authority.
function Probe:update(dt)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true then
        self.sourceFields=setmetatable({},{__mode="k"})
        self.sourceSampleElapsedMs=0
        return
    end
    if type(publication.isEligible)~="function" or not
        publication:isEligible("DIAGNOSTIC","INFO",
            "NATIVE_COMPLETION_SOURCE_FIELD_CANDIDATE") then return end
    if type(dt)~="number" or dt<=0 or dt>5000 then return end
    self.sourceSampleElapsedMs=self.sourceSampleElapsedMs+dt
    if self.sourceSampleElapsedMs<SOURCE_INTERVAL_MS then return end
    self.sourceSampleElapsedMs=0
    local mission=g_currentMission
    local registry=mission and mission.aiSystem
        and mission.aiSystem.activeJobVehicles
    if type(registry)~="table" then return end
    local seen,examined={},0
    local function consider(vehicle)
        if type(vehicle)~="table" or seen[vehicle] then return end
        seen[vehicle]=true
        local fieldSpec=vehicle.spec_aiFieldWorker
        if type(fieldSpec)~="table" or fieldSpec.isActive~=true then return end
        local jobSpec=vehicle.spec_aiJobVehicle
        local job=(type(jobSpec)=="table" and jobSpec.job) or fieldSpec.fieldJob
        -- A different native job on the same worker supersedes any cached
        -- identity candidate from its preceding Job Episode.
        for earlier,record in pairs(self.sourceFields) do
            if record.vehicle==vehicle and earlier~=job then
                self.sourceFields[earlier]=nil
            end
        end
        if not isFieldWorkJob(job) or self.sourceFields[job]~=nil then return end
        local candidate=OuttaMyWay.CompletionSourceFieldObservation.observe(
            vehicle,job)
        if candidate~=nil then
            self.sourceFields[job]={vehicle=vehicle,candidate=candidate}
        end
    end
    for key,value in pairs(registry) do
        examined=examined+1
        if examined>MAX_ACTIVE_REGISTRY then return end
        consider(key)
        consider(value)
        if type(value)=="table" then
            consider(value.vehicle)
            consider(value.object)
            consider(value.rootVehicle)
            consider(value[1])
        end
    end
end

function Probe:onJobStopped(job,aiMessage)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true
        or not isFieldWorkJob(job) then
        self.sourceFields[job]=nil
        return
    end
    if self.seen[job] then return end
    self.seen[job]=true
    local vehicle=vehicleOf(job)
    local observed=self.sourceFields[job]
    self.sourceFields[job]=nil
    local sourceField=observed~=nil and observed.vehicle==vehicle
        and observed.candidate or nil

    -- Do not collapse the native message into a claim of completed agronomy.
    -- This witness has no connection to Terminal Egress Control.
    publication:publish("DIAGNOSTIC","INFO","NATIVE_FIELDWORK_JOB_STOPPED",function()
        return {
            jobId=job.jobId or "unavailable",
            rootNode=vehicleIdentity(vehicleOf(job)),
            message=messageIdentity(aiMessage),
            successClass=isSuccessMessage(aiMessage)
        }
    end)
    if isSuccessMessage(aiMessage) then
        publication:publish("DIAGNOSTIC","INFO",
            "NATIVE_COMPLETION_SOURCE_FIELD_CANDIDATE",function()
                return {
                    jobId=job.jobId or "unavailable",
                    rootNode=vehicleIdentity(vehicle),
                    fieldId=sourceField and sourceField.fieldId or "unavailable",
                    detectionX=sourceField and sourceField.detectionX or "unavailable",
                    detectionZ=sourceField and sourceField.detectionZ or "unavailable",
                    status=sourceField and sourceField.status or "NOT_OBSERVED",
                    provenance=sourceField and sourceField.provenance
                        or "NO_ACTIVE_FIELD_DETECTION_WITNESS"
                }
            end)
    end
    if isSuccessMessage(aiMessage) and type(self.completionListener)=="function" then
        -- Observation is never allowed to break native GIANTS job dispatch.
        pcall(self.completionListener,job,vehicle,sourceField)
    end
end

function Probe:loadMap()
    self.seen={}
    self.sourceFields=setmetatable({},{__mode="k"})
    self.sourceSampleElapsedMs=0
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
    self.sourceFields=setmetatable({},{__mode="k"})
    self.sourceSampleElapsedMs=0
end
