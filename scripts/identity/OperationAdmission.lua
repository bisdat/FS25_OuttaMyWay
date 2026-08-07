OuttaMyWay.OperationAdmission = {}
local Admission = OuttaMyWay.OperationAdmission
Admission.__index = Admission

local OperationRecord = OuttaMyWay.ValueRecord.register(
    "OperationRecord",
    OuttaMyWay.ValueRecord.define(
        "OperationRecord",
        {"identity", "fieldWorldReferenceKey", "admittedEpoch", "status", "memberAssemblyIds", "memberJobEpisodeIds", "memberFieldWorldSnapshotReferenceKeys", "memberFieldPolygonReferenceKeys", "evidence", "revision"},
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
        if value~=nil and not seen[value] then seen[value] = true; result[#result + 1] = value end
    end
    table.sort(result)
    return result
end

local function mergedUnique(first, second)
    local values = {}
    for _, value in OuttaMyWay.ValueRecord.ipairs(first or {}) do values[#values + 1] = value end
    for _, value in OuttaMyWay.ValueRecord.ipairs(second or {}) do values[#values + 1] = value end
    return sortedUnique(values)
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
    return fieldWorld.referenceKey, fieldWorld.operationMembershipEvidenceComplete == true
end

function Admission:_admit(fieldWorldKey, memberAssemblyIds, memberEpisodeIds, snapshotReferences, polygonReferences, snapshot)
    local identity = self.identities:issue("OPERATION")
    local record = OperationRecord.new({
        identity = identity,
        fieldWorldReferenceKey = fieldWorldKey,
        admittedEpoch = snapshot.epoch,
        status = "ACTIVE",
        memberAssemblyIds = sortedUnique(memberAssemblyIds),
        memberJobEpisodeIds = sortedUnique(memberEpisodeIds),
        memberFieldWorldSnapshotReferenceKeys=sortedUnique(snapshotReferences),
        memberFieldPolygonReferenceKeys=sortedUnique(polygonReferences),
        evidence = { observationSnapshotId=snapshot.identity, provenance=snapshot.provenance },
        revision = 1
    })
    self.records[identity] = record
    self.activeByFieldWorld[fieldWorldKey] = identity
    return record
end

function Admission:_update(record, memberAssemblyIds, memberEpisodeIds, snapshotReferences, polygonReferences, snapshot)
    local updated = OuttaMyWay.ValueRecord.update(record, {
        memberAssemblyIds = sortedUnique(memberAssemblyIds),
        memberJobEpisodeIds = sortedUnique(memberEpisodeIds),
        memberFieldWorldSnapshotReferenceKeys=sortedUnique(snapshotReferences),
        memberFieldPolygonReferenceKeys=sortedUnique(polygonReferences),
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
        memberFieldWorldSnapshotReferenceKeys={},
        memberFieldPolygonReferenceKeys={},
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
    local fieldWorldKey, complete = fieldContext(snapshot)
    local memberAssemblyIds, memberEpisodeIds, snapshotReferences, polygonReferences = {}, {}, {}, {}

    for _, evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.operationMembershipEvidence) do
        if evidence.fieldWorldReferenceKey ~= nil and evidence.fieldWorldReferenceKey ~= fieldWorldKey then
            error("Operation membership evidence belongs to a different Field World", 2)
        end
        if evidence.performingRecognisedFieldWork == true then
            if evidence.fieldWorldReferenceKey==nil then error("recognised Operation membership requires resolved Field World identity",2) end
            if evidence.fieldWorldSnapshotReferenceKey==nil or evidence.fieldPolygonReferenceKey==nil then
                error("recognised Operation membership requires immutable Snapshot and polygon provenance",2)
            end
            memberAssemblyIds[#memberAssemblyIds + 1] = evidence.assemblyId
            snapshotReferences[#snapshotReferences+1]=evidence.fieldWorldSnapshotReferenceKey
            polygonReferences[#polygonReferences+1]=evidence.fieldPolygonReferenceKey
            local activeEpisode = self.jobEpisodes:getActiveForAssembly(evidence.assemblyId)
            if activeEpisode ~= nil then memberEpisodeIds[#memberEpisodeIds + 1] = activeEpisode.identity end
        end
    end

    memberAssemblyIds = sortedUnique(memberAssemblyIds)
    memberEpisodeIds = sortedUnique(memberEpisodeIds)
    snapshotReferences=sortedUnique(snapshotReferences)
    polygonReferences=sortedUnique(polygonReferences)
    local activeId = self.activeByFieldWorld[fieldWorldKey]
    local active = activeId and self.records[activeId] or nil
    local endedIds, transitions = {}, {}

    if #memberAssemblyIds > 0 then
        if active == nil then
            active = self:_admit(fieldWorldKey, memberAssemblyIds, memberEpisodeIds, snapshotReferences, polygonReferences, snapshot)
            transitions[#transitions + 1] = { event="ADMITTED", operationId=active.identity, memberAssemblyIds=memberAssemblyIds }
        elseif complete then
            active = self:_update(active, memberAssemblyIds, memberEpisodeIds, snapshotReferences, polygonReferences, snapshot)
            transitions[#transitions + 1] = { event="MEMBERSHIP_UPDATED", operationId=active.identity, memberAssemblyIds=memberAssemblyIds, membershipEvidenceComplete=true }
        else
            -- Incomplete membership evidence may add positively observed members, but it cannot
            -- prove removal of previously admitted members. Preserve the prior membership set
            -- until complete evidence arrives; this prevents an unresolved Job Episode stop
            -- sample from masquerading as explicit Encounter membership invalidation.
            local retainedEpisodeIds = {}
            for _, assemblyId in OuttaMyWay.ValueRecord.ipairs(active.memberAssemblyIds or {}) do
                local activeEpisode = self.jobEpisodes:getActiveForAssembly(assemblyId)
                if activeEpisode ~= nil then retainedEpisodeIds[#retainedEpisodeIds + 1] = activeEpisode.identity end
            end
            active = self:_update(
                active,
                mergedUnique(active.memberAssemblyIds, memberAssemblyIds),
                mergedUnique(retainedEpisodeIds, memberEpisodeIds),
                mergedUnique(active.memberFieldWorldSnapshotReferenceKeys, snapshotReferences),
                mergedUnique(active.memberFieldPolygonReferenceKeys, polygonReferences),
                snapshot
            )
            transitions[#transitions + 1] = {
                event="MEMBERSHIP_UPDATED_INCOMPLETE", operationId=active.identity,
                memberAssemblyIds=active.memberAssemblyIds, membershipEvidenceComplete=false, removalDeferred=true
            }
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
        provenance = { source="OperationAdmission", observationEpoch=snapshot.epoch, episodeAdmissionEpoch=episodeResult.epoch, fieldWorldAuthority="FieldWorldEquivalenceAuthority" }
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
