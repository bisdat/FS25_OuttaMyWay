OuttaMyWay.JobEpisodeAdmission = {}
local Admission = OuttaMyWay.JobEpisodeAdmission
Admission.__index = Admission

local JobEpisodeRecord = OuttaMyWay.ValueRecord.register(
    "JobEpisodeRecord",
    OuttaMyWay.ValueRecord.define(
        "JobEpisodeRecord",
        {"identity", "assemblyId", "sourceJobToken", "admittedEpoch", "admittedEvidence", "status", "revision"},
        {"endedEpoch", "terminalCause", "terminalEvidence", "fieldWorldReferenceKey", "fieldWorldSnapshotReferenceKey", "fieldPolygonReferenceKey", "fieldWorldFingerprint", "fieldWorldEquivalenceStatus", "playerFacingFieldId", "playerFacingLocatorSource"},
        function(values)
            if values.status ~= "ACTIVE" and values.status ~= "ENDED" then
                error("JobEpisodeRecord status must be ACTIVE or ENDED", 3)
            end
        end
    )
)

local AdmissionResult = OuttaMyWay.ValueRecord.register(
    "JobEpisodeAdmissionResult",
    OuttaMyWay.ValueRecord.define(
        "JobEpisodeAdmissionResult",
        {"observationSnapshotId", "epoch", "admittedEpisodeIds", "endedEpisodeIds", "activeEpisodeIds", "transitions", "provenance"},
        {}
    )
)

local successionCauseFields = {
    {field="restartObserved", cause="RESTARTED"},
    {field="replacementObserved", cause="REPLACED"}
}

function Admission.new(identityRegistry, epochSequence)
    local self = setmetatable({}, Admission)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.activeByAssembly = {}
    self.records = {}
    return self
end

local function successionCause(evidence, current)
    local causes = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(successionCauseFields) do
        if evidence[item.field] == true then causes[item.cause] = true end
    end
    if current ~= nil and evidence.jobPresent == true and evidence.sourceJobToken ~= nil
        and evidence.sourceJobToken ~= current.sourceJobToken then
        causes.REPLACED = true
    end
    local list = {}
    for cause, _ in OuttaMyWay.ValueRecord.pairs(causes) do list[#list + 1] = cause end
    table.sort(list)
    if #list > 1 then
        error("conflicting authoritative Job Episode succession evidence: " .. table.concat(list, ","), 3)
    end
    return list[1]
end

local function sourceJobEnded(evidence)
    local proof=evidence.sourceJobEndEvidence
    return type(proof)=="table" and proof.observed==true
end

local function canAdmit(evidence)
    return evidence.jobPresent == true
        and evidence.aiControlled == true
        and evidence.sourceJobToken ~= nil
        and tostring(evidence.sourceJobToken) ~= ""
end

function Admission:_admit(evidence, snapshot)
    local identity = self.identities:issue("JOB_EPISODE")
    local record = JobEpisodeRecord.new({
        identity = identity,
        assemblyId = evidence.assemblyId,
        sourceJobToken = evidence.sourceJobToken,
        admittedEpoch = snapshot.epoch,
        admittedEvidence = {
            observationSnapshotId = snapshot.identity,
            jobPresent = evidence.jobPresent,
            aiControlled = evidence.aiControlled,
            provenance = evidence.provenance
        },
        status = "ACTIVE",
        revision = 1,
        fieldWorldReferenceKey = evidence.fieldWorldReferenceKey,
        fieldWorldSnapshotReferenceKey = evidence.fieldWorldSnapshotReferenceKey,
        fieldPolygonReferenceKey = evidence.fieldPolygonReferenceKey,
        fieldWorldFingerprint = evidence.fieldWorldFingerprint,
        fieldWorldEquivalenceStatus = evidence.fieldWorldEquivalenceStatus,
        playerFacingFieldId = evidence.playerFacingFieldId,
        playerFacingLocatorSource = evidence.playerFacingLocatorSource
    })
    self.records[identity] = record
    self.activeByAssembly[evidence.assemblyId] = identity
    return record
end


function Admission:_bindFieldWorld(record, evidence, snapshot)
    if evidence.fieldWorldSnapshotReferenceKey == nil then return record, false end
    local updates={}
    local changed=false
    if record.fieldWorldSnapshotReferenceKey~=nil then
        if record.fieldWorldSnapshotReferenceKey~=evidence.fieldWorldSnapshotReferenceKey
            or record.fieldPolygonReferenceKey~=evidence.fieldPolygonReferenceKey
            or record.fieldWorldFingerprint~=evidence.fieldWorldFingerprint then
            error("Job Episode Field World Snapshot cannot change after capture",3)
        end
    else
        updates.fieldWorldSnapshotReferenceKey=evidence.fieldWorldSnapshotReferenceKey
        updates.fieldPolygonReferenceKey=evidence.fieldPolygonReferenceKey
        updates.fieldWorldFingerprint=evidence.fieldWorldFingerprint
        changed=true
    end
    if evidence.fieldWorldReferenceKey~=nil then
        if record.fieldWorldReferenceKey~=nil and record.fieldWorldReferenceKey~=evidence.fieldWorldReferenceKey then
            error("Job Episode resolved Field World identity cannot change",3)
        elseif record.fieldWorldReferenceKey==nil then
            updates.fieldWorldReferenceKey=evidence.fieldWorldReferenceKey
            changed=true
        end
    end
    if evidence.fieldWorldEquivalenceStatus~=nil and record.fieldWorldEquivalenceStatus~=evidence.fieldWorldEquivalenceStatus then
        updates.fieldWorldEquivalenceStatus=evidence.fieldWorldEquivalenceStatus
        changed=true
    end
    if evidence.playerFacingFieldId~=nil and record.playerFacingFieldId==nil then updates.playerFacingFieldId=evidence.playerFacingFieldId; changed=true end
    if evidence.playerFacingLocatorSource~=nil and record.playerFacingLocatorSource==nil then updates.playerFacingLocatorSource=evidence.playerFacingLocatorSource; changed=true end
    if not changed then return record,false end
    updates.revision=record.revision+1
    local updated=OuttaMyWay.ValueRecord.update(record,updates)
    self.records[record.identity]=updated
    return updated,true
end

function Admission:_end(record, cause, evidence, snapshot)
    local updates = {
        status = "ENDED",
        endedEpoch = snapshot.epoch,
        terminalEvidence = {
            observationSnapshotId = snapshot.identity,
            sourceJobToken = evidence.sourceJobToken,
            sourceJobEndEvidence = evidence.sourceJobEndEvidence,
            provenance = evidence.provenance
        },
        revision = record.revision + 1
    }
    if cause ~= nil then updates.terminalCause=cause end
    local updated = OuttaMyWay.ValueRecord.update(record, updates)
    self.records[record.identity] = updated
    self.activeByAssembly[record.assemblyId] = nil
    return updated
end

function Admission:observe(snapshot)
    OuttaMyWay.ValueRecord.assertType(snapshot, "ObservationSnapshot")
    local admitted, ended, transitions = {}, {}, {}

    for _, evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.jobEpisodeEvidence) do
        local currentId = self.activeByAssembly[evidence.assemblyId]
        local current = currentId and self.records[currentId] or nil
        local cause = successionCause(evidence, current)
        local endedBySourceJob = sourceJobEnded(evidence)
        if current ~= nil and cause == nil and not endedBySourceJob then
            local bound, changed = self:_bindFieldWorld(current,evidence,snapshot)
            current=bound
            if changed then transitions[#transitions+1]={assemblyId=evidence.assemblyId,episodeId=current.identity,event="FIELD_WORLD_BOUND",fieldWorldReferenceKey=current.fieldWorldReferenceKey} end
        end

        if current ~= nil and (cause ~= nil or endedBySourceJob) then
            local endedRecord = self:_end(current, cause, evidence, snapshot)
            ended[#ended + 1] = endedRecord.identity
            transitions[#transitions + 1] = {
                assemblyId = evidence.assemblyId,
                episodeId = endedRecord.identity,
                event = "ENDED",
                cause = cause
            }
            current = nil
        end

        local shouldAdmit = current == nil and canAdmit(evidence)
        if endedBySourceJob and cause == nil then shouldAdmit = false end
        if shouldAdmit then
            local record = self:_admit(evidence, snapshot)
            admitted[#admitted + 1] = record.identity
            transitions[#transitions + 1] = {
                assemblyId = evidence.assemblyId,
                episodeId = record.identity,
                event = "ADMITTED",
                sourceJobToken = record.sourceJobToken
            }
        end
    end

    local active = {}
    for _, identity in OuttaMyWay.ValueRecord.pairs(self.activeByAssembly) do active[#active + 1] = identity end
    table.sort(admitted)
    table.sort(ended)
    table.sort(active)
    table.sort(transitions, function(a, b)
        if a.assemblyId ~= b.assemblyId then return a.assemblyId < b.assemblyId end
        if a.event ~= b.event then return a.event < b.event end
        return a.episodeId < b.episodeId
    end)

    return AdmissionResult.new({
        observationSnapshotId = snapshot.identity,
        epoch = self.epochs:next(),
        admittedEpisodeIds = admitted,
        endedEpisodeIds = ended,
        activeEpisodeIds = active,
        transitions = transitions,
        provenance = { source="JobEpisodeAdmission", observationEpoch=snapshot.epoch }
    })
end

function Admission:get(identity)
    return self.records[identity]
end

function Admission:getActiveForAssembly(assemblyId)
    local identity = self.activeByAssembly[assemblyId]
    return identity and self.records[identity] or nil
end

function Admission:list()
    local ids = {}
    for identity, _ in OuttaMyWay.ValueRecord.pairs(self.records) do ids[#ids + 1] = identity end
    table.sort(ids)
    local result = {}
    for _, identity in OuttaMyWay.ValueRecord.ipairs(ids) do result[#result + 1] = self.records[identity] end
    return result
end
