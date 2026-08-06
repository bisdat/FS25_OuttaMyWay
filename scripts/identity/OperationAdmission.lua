OuttaMyWay.OperationAdmission = {}
local Admission = OuttaMyWay.OperationAdmission
Admission.__index = Admission

local OperationRecord = OuttaMyWay.ValueRecord.register(
    "OperationRecord",
    OuttaMyWay.ValueRecord.define(
        "OperationRecord",
        {"identity", "fieldWorldReferenceKey", "fieldPolygonReferenceKey", "admittedEpoch", "status", "memberAssemblyIds", "memberJobEpisodeIds", "evidence", "revision"},
        {"endedEpoch", "terminalEvidence"},
        function(values)
            if values.status ~= "ACTIVE" and values.status ~= "ENDED" then
                error("OperationRecord status must be ACTIVE or ENDED", 3)
            end
        end
    )
)

local OperationAdmissionResult = OuttaMyWay.ValueRecord.register(
    "OperationAdmissionResult",
    OuttaMyWay.ValueRecord.define(
        "OperationAdmissionResult",
        {"observationSnapshotId", "epoch", "activeOperationIds", "endedOperationIds", "transitions", "membershipEvidenceComplete", "provenance"},
        {}
    )
)

local function sortedUnique(values)
    local seen, result = {}, {}
    for _, value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if not seen[value] then seen[value] = true; result[#result + 1] = value end
    end
    table.sort(result)
    return result
end

function Admission.new(identityRegistry, epochSequence, jobEpisodes)
    local self = setmetatable({}, Admission)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.jobEpisodes = jobEpisodes
    self.activeByFieldWorld = {}
    self.records = {}
    return self
end

local function fieldContext(snapshot)
    local fieldWorld = snapshot.fieldWorld
    if type(fieldWorld.referenceKey) ~= "string" or fieldWorld.referenceKey == "" then
        error("Operation admission requires fieldWorld.referenceKey", 3)
    end
    if type(fieldWorld.fieldPolygonReferenceKey) ~= "string" or fieldWorld.fieldPolygonReferenceKey == "" then
        error("Operation admission requires fieldWorld.fieldPolygonReferenceKey", 3)
    end
    return fieldWorld.referenceKey, fieldWorld.fieldPolygonReferenceKey,
        fieldWorld.operationMembershipEvidenceComplete == true
end

function Admission:_admit(fieldWorldKey, polygonKey, memberAssemblyIds, memberEpisodeIds, snapshot)
    local identity = self.identities:issue("OPERATION")
    local record = OperationRecord.new({
        identity = identity,
        fieldWorldReferenceKey = fieldWorldKey,
        fieldPolygonReferenceKey = polygonKey,
        admittedEpoch = snapshot.epoch,
        status = "ACTIVE",
        memberAssemblyIds = sortedUnique(memberAssemblyIds),
        memberJobEpisodeIds = sortedUnique(memberEpisodeIds),
        evidence = { observationSnapshotId=snapshot.identity, provenance=snapshot.provenance },
        revision = 1
    })
    self.records[identity] = record
    self.activeByFieldWorld[fieldWorldKey] = identity
    return record
end

function Admission:_update(record, memberAssemblyIds, memberEpisodeIds, snapshot)
    local updated = OuttaMyWay.ValueRecord.update(record, {
        memberAssemblyIds = sortedUnique(memberAssemblyIds),
        memberJobEpisodeIds = sortedUnique(memberEpisodeIds),
        evidence = { observationSnapshotId=snapshot.identity, provenance=snapshot.provenance },
        revision = record.revision + 1
    })
    self.records[record.identity] = updated
    return updated
end

function Admission:_end(record, snapshot)
    local ended = OuttaMyWay.ValueRecord.update(record, {
        status = "ENDED",
        memberAssemblyIds = {},
        memberJobEpisodeIds = {},
        endedEpoch = snapshot.epoch,
        terminalEvidence = { observationSnapshotId=snapshot.identity, reason="MEMBERSHIP_ZERO", provenance=snapshot.provenance },
        revision = record.revision + 1
    })
    self.records[record.identity] = ended
    self.activeByFieldWorld[record.fieldWorldReferenceKey] = nil
    return ended
end

function Admission:observe(snapshot, episodeResult)
    OuttaMyWay.ValueRecord.assertType(snapshot, "ObservationSnapshot")
    OuttaMyWay.ValueRecord.assertType(episodeResult, "JobEpisodeAdmissionResult")
    local fieldWorldKey, polygonKey, complete = fieldContext(snapshot)
    local memberAssemblyIds, memberEpisodeIds = {}, {}

    for _, evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.operationMembershipEvidence) do
        if evidence.fieldWorldReferenceKey ~= nil and evidence.fieldWorldReferenceKey ~= fieldWorldKey then
            error("Operation membership evidence belongs to a different Field World", 2)
        end
        if evidence.fieldPolygonReferenceKey ~= nil and evidence.fieldPolygonReferenceKey ~= polygonKey then
            error("Operation membership evidence belongs to a different field polygon", 2)
        end
        if evidence.performingRecognisedFieldWork == true then
            memberAssemblyIds[#memberAssemblyIds + 1] = evidence.assemblyId
            local activeEpisode = self.jobEpisodes:getActiveForAssembly(evidence.assemblyId)
            if activeEpisode ~= nil then memberEpisodeIds[#memberEpisodeIds + 1] = activeEpisode.identity end
        end
    end

    memberAssemblyIds = sortedUnique(memberAssemblyIds)
    memberEpisodeIds = sortedUnique(memberEpisodeIds)
    local activeId = self.activeByFieldWorld[fieldWorldKey]
    local active = activeId and self.records[activeId] or nil
    local endedIds, transitions = {}, {}

    if #memberAssemblyIds > 0 then
        if active == nil then
            active = self:_admit(fieldWorldKey, polygonKey, memberAssemblyIds, memberEpisodeIds, snapshot)
            transitions[#transitions + 1] = { event="ADMITTED", operationId=active.identity, memberAssemblyIds=memberAssemblyIds }
        else
            active = self:_update(active, memberAssemblyIds, memberEpisodeIds, snapshot)
            transitions[#transitions + 1] = { event="MEMBERSHIP_UPDATED", operationId=active.identity, memberAssemblyIds=memberAssemblyIds }
        end
    elseif active ~= nil and complete then
        active = self:_end(active, snapshot)
        endedIds[#endedIds + 1] = active.identity
        transitions[#transitions + 1] = { event="ENDED", operationId=active.identity, cause="MEMBERSHIP_ZERO" }
        active = nil
    end

    local activeIds = {}
    if active ~= nil and active.status == "ACTIVE" then activeIds[1] = active.identity end
    return OperationAdmissionResult.new({
        observationSnapshotId = snapshot.identity,
        epoch = self.epochs:next(),
        activeOperationIds = activeIds,
        endedOperationIds = endedIds,
        transitions = transitions,
        membershipEvidenceComplete = complete,
        provenance = { source="OperationAdmission", observationEpoch=snapshot.epoch, episodeAdmissionEpoch=episodeResult.epoch }
    })
end

function Admission:get(identity) return self.records[identity] end
function Admission:listActive()
    local result={}
    for _,record in OuttaMyWay.ValueRecord.pairs(self.records) do if record.status=="ACTIVE" then result[#result+1]=record end end
    table.sort(result,function(a,b) return a.identity<b.identity end)
    return result
end
function Admission:getActiveForFieldWorld(fieldWorldReferenceKey)
    local identity = self.activeByFieldWorld[fieldWorldReferenceKey]
    return identity and self.records[identity] or nil
end
function Admission:list()
    local ids = {}; for identity, _ in OuttaMyWay.ValueRecord.pairs(self.records) do ids[#ids + 1] = identity end; table.sort(ids)
    local result = {}; for _, identity in OuttaMyWay.ValueRecord.ipairs(ids) do result[#result + 1] = self.records[identity] end
    return result
end
