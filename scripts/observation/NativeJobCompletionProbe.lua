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
        seen={},sourceFields=setmetatable({},{__mode="k"}),
        sourceByVehicle=setmetatable({},{__mode="k"}),
        sourceSampleStatus="NOT_SAMPLED",sourceSampleElapsedMs=0,
        completionListener=nil},Probe)
end

function Probe:setCompletionListener(listener)
    self.completionListener=listener
end

-- This is DIAGNOSTIC evidence only. Preserve the precise negative witness
-- for the *same native job* rather than collapsing all missed observations
-- into an undifferentiated NOT_OBSERVED at successful job termination.
local function discardSourceSamples(self)
    self.sourceFields=setmetatable({},{__mode="k"})
    self.sourceByVehicle=setmetatable({},{__mode="k"})
    self.sourceSampleStatus="NOT_SAMPLED"
    self.sourceSampleElapsedMs=0
end

function Probe:update(dt)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true then
        discardSourceSamples(self)
        return
    end
    if type(publication.isEligible)~="function" or not
        publication:isEligible("DIAGNOSTIC","INFO",
            "NATIVE_COMPLETION_SOURCE_FIELD_CANDIDATE") then
        discardSourceSamples(self)
        return
    end
    if type(dt)~="number" or dt<=0 or dt>5000 then
        self.sourceSampleStatus="INVALID_SAMPLE_DELTA"
        return
    end
    self.sourceSampleElapsedMs=self.sourceSampleElapsedMs+dt
    if self.sourceSampleElapsedMs<SOURCE_INTERVAL_MS then return end
    self.sourceSampleElapsedMs=0

    local mission=g_currentMission
    local registry=mission and mission.aiSystem
        and mission.aiSystem.activeJobVehicles
    if type(registry)~="table" then
        self.sourceSampleStatus="ACTIVE_JOB_REGISTRY_UNAVAILABLE"
        return
    end
    local seen,examined,activeCount={},0,0
    local function consider(vehicle)
        if type(vehicle)~="table" or seen[vehicle] then return end
        seen[vehicle]=true
        local fieldSpec=vehicle.spec_aiFieldWorker
        if type(fieldSpec)~="table" or fieldSpec.isActive~=true then return end
        activeCount=activeCount+1
        local jobSpec=vehicle.spec_aiJobVehicle
        local job=(type(jobSpec)=="table" and jobSpec.job) or fieldSpec.fieldJob
        for earlier,record in pairs(self.sourceFields) do
            if record.vehicle==vehicle and earlier~=job then
                self.sourceFields[earlier]=nil
            end
        end
        local previous=type(job)=="table" and self.sourceFields[job] or nil
        local record={
            job=job,vehicle=vehicle,
            samples=(previous and previous.samples or 0)+1,
            reason=nil,candidate=nil
        }
        if not isFieldWorkJob(job) then
            record.reason=job==nil and "ACTIVE_JOB_REFERENCE_UNAVAILABLE"
                or "ACTIVE_JOB_CLASS_NOT_FIELDWORK"
        elseif previous~=nil and previous.candidate~=nil
            and previous.vehicle==vehicle then
            -- Retain a positive witness throughout this same Job Episode.
            record.candidate=previous.candidate
            record.reason="CANDIDATE_OBSERVED"
        else
            local candidate,why=
                OuttaMyWay.CompletionSourceFieldObservation.observe(vehicle,job)
            record.candidate=candidate
            record.reason=candidate~=nil and "CANDIDATE_OBSERVED"
                or (why or "FIELD_OBSERVATION_UNAVAILABLE")
        end
        self.sourceByVehicle[vehicle]=record
        if isFieldWorkJob(job) then self.sourceFields[job]=record end
    end
    for key,value in pairs(registry) do
        examined=examined+1
        if examined>MAX_ACTIVE_REGISTRY then
            self.sourceSampleStatus="ACTIVE_JOB_REGISTRY_LIMIT"
            return
        end
        consider(key)
        consider(value)
        if type(value)=="table" then
            consider(value.vehicle)
            consider(value.object)
            consider(value.rootVehicle)
            consider(value[1])
        end
    end
    self.sourceSampleStatus=activeCount>0
        and "ACTIVE_FIELDWORK_WORKERS_SAMPLED"
        or "NO_ACTIVE_FIELDWORK_WORKERS"
end

function Probe:onJobStopped(job,aiMessage)
    if g_server==nil or self.configuration==nil
        or self.configuration:isResolved()~=true
        or self.configuration:isEnabled()~=true
        or not isFieldWorkJob(job) then
        if type(job)=="table" then self.sourceFields[job]=nil end
        return
    end
    if self.seen[job] then return end
    self.seen[job]=true
    local vehicle=vehicleOf(job)
    local observed=self.sourceFields[job]
    self.sourceFields[job]=nil
    local lastVehicleSample=vehicle~=nil and self.sourceByVehicle[vehicle] or nil
    if lastVehicleSample~=nil and lastVehicleSample.job==job then
        self.sourceByVehicle[vehicle]=nil
    end
    local sourceField=observed~=nil and observed.vehicle==vehicle
        and observed.candidate or nil
    local sourceReason
    if sourceField~=nil then
        sourceReason="CANDIDATE_OBSERVED"
    elseif observed~=nil then
        sourceReason=observed.vehicle==vehicle
            and (observed.reason or "FIELD_OBSERVATION_UNAVAILABLE")
            or "SAMPLED_VEHICLE_IDENTITY_MISMATCH"
    elseif lastVehicleSample~=nil then
        sourceReason=lastVehicleSample.job~=job
            and "ACTIVE_JOB_REFERENCE_MISMATCH_AT_COMPLETION"
            or (lastVehicleSample.reason or "FIELD_OBSERVATION_UNAVAILABLE")
    else
        sourceReason="NO_MATCHING_ACTIVE_WORKER_SAMPLE"
    end

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
                    reason=sourceReason,
                    sampleStatus=self.sourceSampleStatus,
                    sampleCount=observed and observed.samples or 0,
                    sampledJobId=lastVehicleSample
                        and type(lastVehicleSample.job)=="table"
                        and lastVehicleSample.job.jobId or "unavailable",
                    provenance=sourceField and sourceField.provenance
                        or "ACTIVE_JOB_FIELD_OBSERVATION"
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
    discardSourceSamples(self)
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
    discardSourceSamples(self)
end
