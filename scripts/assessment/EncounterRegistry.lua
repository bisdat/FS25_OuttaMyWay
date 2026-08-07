OuttaMyWay.EncounterRegistry = {}
local Registry = OuttaMyWay.EncounterRegistry
Registry.__index = Registry

local EncounterRecord = OuttaMyWay.ValueRecord.register(
    "EncounterRecord",
    OuttaMyWay.ValueRecord.define(
        "EncounterRecord",
        {"identity","operationId","interactionReferenceKey","subjectAssemblyId","otherAssemblyId","subjectJobEpisodeId","otherJobEpisodeId","episodeSignature","relationship","status","admittedEpoch","lastObservedEpoch","lastPositiveEvidence","revision"},
        {"endedEpoch","terminalReason","terminalEvidence"},
        function(values)
            if values.status~="ACTIVE" and values.status~="TERMINATED" then
                error("EncounterRecord status must be ACTIVE or TERMINATED",3)
            end
        end
    )
)

local function sortedPair(a,b)
    if tostring(a)<tostring(b) then return a,b end
    return b,a
end

local function episodeSignature(subjectEpisodeId,otherEpisodeId)
    local first,second=sortedPair(subjectEpisodeId,otherEpisodeId)
    return tostring(first).."|"..tostring(second)
end

local function baseKey(operationId,interactionReferenceKey)
    return tostring(operationId).."|"..tostring(interactionReferenceKey)
end

local function activeKey(operationId,interactionReferenceKey,subjectEpisodeId,otherEpisodeId)
    return baseKey(operationId,interactionReferenceKey).."|"..episodeSignature(subjectEpisodeId,otherEpisodeId)
end

local function contains(values,target)
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do if value==target then return true end end
    return false
end

local function terminalEpisodeEvidence(jobEpisodes,record)
    local result={}
    for _,episodeId in OuttaMyWay.ValueRecord.ipairs({record.subjectJobEpisodeId,record.otherJobEpisodeId}) do
        local episode=jobEpisodes:get(episodeId)
        if episode~=nil and episode.status=="ENDED" then
            result[#result+1]={jobEpisodeId=episodeId,assemblyId=episode.assemblyId,terminalCause=episode.terminalCause,endedEpoch=episode.endedEpoch,terminalEvidence=episode.terminalEvidence}
        end
    end
    table.sort(result,function(a,b) return tostring(a.jobEpisodeId)<tostring(b.jobEpisodeId) end)
    return result
end

function Registry.new(identityRegistry,epochSequence,jobEpisodes,operations)
    return setmetatable({
        identities=identityRegistry,epochs=epochSequence,jobEpisodes=jobEpisodes,operations=operations,
        records={},activeByKey={},activeByBaseKey={}
    },Registry)
end

function Registry:_terminate(record,reason,snapshot,details)
    if record.status~="ACTIVE" then return record,nil end
    local updated=OuttaMyWay.ValueRecord.update(record,{
        status="TERMINATED",
        endedEpoch=snapshot.epoch,
        terminalReason=reason,
        terminalEvidence={observationSnapshotId=snapshot.identity,details=details or {},provenance=snapshot.provenance},
        lastObservedEpoch=snapshot.epoch,
        revision=record.revision+1
    })
    self.records[record.identity]=updated
    self.activeByKey[activeKey(record.operationId,record.interactionReferenceKey,record.subjectJobEpisodeId,record.otherJobEpisodeId)]=nil
    if self.activeByBaseKey[baseKey(record.operationId,record.interactionReferenceKey)]==record.identity then
        self.activeByBaseKey[baseKey(record.operationId,record.interactionReferenceKey)]=nil
    end
    return updated,{
        lifecycle="TERMINATED",encounterIdentity=updated.identity,operationId=updated.operationId,
        interactionReferenceKey=updated.interactionReferenceKey,relationship=updated.relationship,
        terminalReason=reason,terminalEvidence=updated.terminalEvidence,
        subjectJobEpisodeId=updated.subjectJobEpisodeId,otherJobEpisodeId=updated.otherJobEpisodeId,
        episodeSignature=updated.episodeSignature
    }
end

function Registry:_stillValid(record)
    local subjectEpisode=self.jobEpisodes:get(record.subjectJobEpisodeId)
    local otherEpisode=self.jobEpisodes:get(record.otherJobEpisodeId)
    if subjectEpisode==nil or otherEpisode==nil or subjectEpisode.status~="ACTIVE" or otherEpisode.status~="ACTIVE" then
        return false,"JOB_EPISODE_ENDED",{endedJobEpisodes=terminalEpisodeEvidence(self.jobEpisodes,record)}
    end
    local operation=self.operations:get(record.operationId)
    if operation==nil or operation.status~="ACTIVE" then
        return false,"OPERATION_ENDED",{operationId=record.operationId}
    end
    if not contains(operation.memberAssemblyIds,record.subjectAssemblyId) or not contains(operation.memberAssemblyIds,record.otherAssemblyId) then
        return false,"MEMBERSHIP_INVALIDATED",{memberAssemblyIds=operation.memberAssemblyIds}
    end
    local activeSubject=self.jobEpisodes:getActiveForAssembly(record.subjectAssemblyId)
    local activeOther=self.jobEpisodes:getActiveForAssembly(record.otherAssemblyId)
    if activeSubject==nil or activeOther==nil or activeSubject.identity~=record.subjectJobEpisodeId or activeOther.identity~=record.otherJobEpisodeId then
        return false,"INTENT_SUPERSEDED",{
            previousSubjectJobEpisodeId=record.subjectJobEpisodeId,previousOtherJobEpisodeId=record.otherJobEpisodeId,
            currentSubjectJobEpisodeId=activeSubject and activeSubject.identity or nil,currentOtherJobEpisodeId=activeOther and activeOther.identity or nil
        }
    end
    return true,nil,nil
end

function Registry:_admit(item,snapshot)
    local identity=self.identities:issue("ENCOUNTER")
    local record=EncounterRecord.new({
        identity=identity,operationId=item.operationId,interactionReferenceKey=item.interactionReferenceKey,
        subjectAssemblyId=item.subjectAssemblyId,otherAssemblyId=item.otherAssemblyId,
        subjectJobEpisodeId=item.subjectJobEpisodeId,otherJobEpisodeId=item.otherJobEpisodeId,
        episodeSignature=episodeSignature(item.subjectJobEpisodeId,item.otherJobEpisodeId),relationship=item.relationship,
        status="ACTIVE",admittedEpoch=snapshot.epoch,lastObservedEpoch=snapshot.epoch,lastPositiveEvidence=item.evidence,revision=1
    })
    self.records[identity]=record
    self.activeByKey[activeKey(record.operationId,record.interactionReferenceKey,record.subjectJobEpisodeId,record.otherJobEpisodeId)]=identity
    self.activeByBaseKey[baseKey(record.operationId,record.interactionReferenceKey)]=identity
    return record,{
        lifecycle="CREATED",encounterIdentity=identity,operationId=record.operationId,
        interactionReferenceKey=record.interactionReferenceKey,relationship=record.relationship,
        subjectJobEpisodeId=record.subjectJobEpisodeId,otherJobEpisodeId=record.otherJobEpisodeId,
        episodeSignature=record.episodeSignature,positiveObservedThisAssessment=true
    }
end

function Registry:_retain(record,item,snapshot,positiveObserved)
    local changes={lastObservedEpoch=snapshot.epoch,revision=record.revision+1}
    if item~=nil then
        changes.relationship=item.relationship
        changes.lastPositiveEvidence=item.evidence
    end
    local updated=OuttaMyWay.ValueRecord.update(record,changes)
    self.records[updated.identity]=updated
    return updated,{
        lifecycle="RETAINED",encounterIdentity=updated.identity,operationId=updated.operationId,
        interactionReferenceKey=updated.interactionReferenceKey,relationship=updated.relationship,
        subjectJobEpisodeId=updated.subjectJobEpisodeId,otherJobEpisodeId=updated.otherJobEpisodeId,
        episodeSignature=updated.episodeSignature,positiveObservedThisAssessment=positiveObserved==true
    }
end

function Registry:reconcile(snapshot,episodeResult,operationResult,positiveItems)
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    OuttaMyWay.ValueRecord.assertType(episodeResult,"JobEpisodeAdmissionResult")
    OuttaMyWay.ValueRecord.assertType(operationResult,"OperationAdmissionResult")
    local transitions={}
    local scopedOperationIds={}
    for _,operationId in OuttaMyWay.ValueRecord.ipairs(operationResult.activeOperationIds or {}) do scopedOperationIds[operationId]=true end
    for _,operationId in OuttaMyWay.ValueRecord.ipairs(operationResult.endedOperationIds or {}) do scopedOperationIds[operationId]=true end

    local activeIdentities={}
    for identity,record in OuttaMyWay.ValueRecord.pairs(self.records) do
        if record.status=="ACTIVE" and scopedOperationIds[record.operationId] then activeIdentities[#activeIdentities+1]=identity end
    end
    table.sort(activeIdentities)
    for _,identity in OuttaMyWay.ValueRecord.ipairs(activeIdentities) do
        local record=self.records[identity]
        local valid,reason,details=self:_stillValid(record)
        if not valid then
            local _,transition=self:_terminate(record,reason,snapshot,details)
            transitions[#transitions+1]=transition
        end
    end

    local positiveByIdentity={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(positiveItems or {}) do
        local activeSubject=self.jobEpisodes:getActiveForAssembly(item.subjectAssemblyId)
        local activeOther=self.jobEpisodes:getActiveForAssembly(item.otherAssemblyId)
        if activeSubject==nil or activeOther==nil then
            error("positive Encounter evidence requires two active Job Episodes",2)
        end
        item.subjectJobEpisodeId=activeSubject.identity
        item.otherJobEpisodeId=activeOther.identity
        local key=activeKey(item.operationId,item.interactionReferenceKey,activeSubject.identity,activeOther.identity)
        local identity=self.activeByKey[key]
        local record=identity and self.records[identity] or nil
        if record==nil then
            local previousIdentity=self.activeByBaseKey[baseKey(item.operationId,item.interactionReferenceKey)]
            local previous=previousIdentity and self.records[previousIdentity] or nil
            if previous~=nil and previous.status=="ACTIVE" then
                local _,transition=self:_terminate(previous,"INTENT_SUPERSEDED",snapshot,{
                    previousEpisodeSignature=previous.episodeSignature,
                    currentEpisodeSignature=episodeSignature(activeSubject.identity,activeOther.identity)
                })
                transitions[#transitions+1]=transition
            end
            local transition
            record,transition=self:_admit(item,snapshot)
            transitions[#transitions+1]=transition
        else
            local transition
            record,transition=self:_retain(record,item,snapshot,true)
            transitions[#transitions+1]=transition
        end
        positiveByIdentity[record.identity]=true
    end

    local activeRecords={}
    activeIdentities={}
    for identity,record in OuttaMyWay.ValueRecord.pairs(self.records) do
        if record.status=="ACTIVE" and scopedOperationIds[record.operationId] then activeIdentities[#activeIdentities+1]=identity end
    end
    table.sort(activeIdentities)
    for _,identity in OuttaMyWay.ValueRecord.ipairs(activeIdentities) do
        local record=self.records[identity]
        if not positiveByIdentity[identity] then
            local transition
            record,transition=self:_retain(record,nil,snapshot,false)
            transitions[#transitions+1]=transition
        end
        activeRecords[#activeRecords+1]=record
    end

    table.sort(transitions,function(a,b)
        if a.encounterIdentity~=b.encounterIdentity then return a.encounterIdentity<b.encounterIdentity end
        return a.lifecycle<b.lifecycle
    end)
    return {activeRecords=activeRecords,transitions=transitions}
end

function Registry:get(identity) return self.records[identity] end
function Registry:list()
    local ids={}; for identity in OuttaMyWay.ValueRecord.pairs(self.records) do ids[#ids+1]=identity end; table.sort(ids)
    local result={}; for _,identity in OuttaMyWay.ValueRecord.ipairs(ids) do result[#result+1]=self.records[identity] end
    return result
end
function Registry:listActive()
    local result={}; for _,record in OuttaMyWay.ValueRecord.ipairs(self:list()) do if record.status=="ACTIVE" then result[#result+1]=record end end
    return result
end
