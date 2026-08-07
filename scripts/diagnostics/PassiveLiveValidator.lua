OuttaMyWay.PassiveLiveValidator = {}
local Validator=OuttaMyWay.PassiveLiveValidator
Validator.__index=Validator

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][PASSIVE] %s",message) else print("[FS25_OuttaMyWay][PASSIVE] "..message) end
end
local function logWarning(message)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][PASSIVE-DIAGNOSTIC] %s",message) else print("[FS25_OuttaMyWay][PASSIVE-DIAGNOSTIC][WARNING] "..message) end
end
local function logError(message)
    if Logging~=nil and type(Logging.error)=="function" then Logging.error("[FS25_OuttaMyWay][PASSIVE] %s",message) else print("[FS25_OuttaMyWay][PASSIVE][ERROR] "..message) end
end
local function selectedCapability(result)
    local id=result.decision.selectedCandidateId
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(result.candidates or {}) do if candidate.identity==id then return candidate.capability end end
    return nil
end
local function activeAssemblyCount(snapshot)
    local count=0
    for _,state in OuttaMyWay.ValueRecord.pairs(snapshot.aiStates or {}) do if state.observedActive==true or state.fieldActive==true or state.aiActive==true then count=count+1 end end
    return count
end
local function activeAssemblyReferenceKeys(snapshot)
    local result={}
    for referenceKey,state in OuttaMyWay.ValueRecord.pairs(snapshot.aiStates or {}) do if state.observedActive==true then result[#result+1]=referenceKey end end
    table.sort(result)
    return result
end
local function candidateVerdictSummary(result)
    local states={}
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(result.candidates or {}) do states[candidate.identity]={failed=false,unresolved=false} end
    for _,verdict in OuttaMyWay.ValueRecord.ipairs(result.verdicts or {}) do
        local state=states[verdict.candidateId]
        if state~=nil then
            if verdict.result=="FAIL" then state.failed=true elseif verdict.result=="UNRESOLVED" then state.unresolved=true end
        end
    end
    local pass,unresolved,failed=0,0,0
    for _,state in OuttaMyWay.ValueRecord.pairs(states) do
        if state.failed then failed=failed+1 elseif state.unresolved then unresolved=unresolved+1 else pass=pass+1 end
    end
    return pass,unresolved,failed
end
local function numberText(value)
    if value==nil then return "n/a" end
    return string.format("%.3f",tonumber(value) or 0)
end
local function booleanText(value) return value==true and "true" or "false" end
local function sortedArray(values)
    local result={}; for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[#result+1]=value end; table.sort(result); return result
end
local function contains(values,target)
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do if value==target then return true end end
    return false
end

function Validator.new(runtime,source,support,probe,fieldWorldSnapshots)
    return setmetatable({
        runtime=runtime,source=source,support=support,probe=probe,fieldWorldSnapshots=fieldWorldSnapshots,
        elapsed=0,lastLogAt=-math.huge,lastSignature=nil,records={},errorCount=0,
        acquisitionSignatures={},assemblyDiagnosticSignatures={},profileDiagnosticSignatures={},warningLastAt={},
        previousEncounters={},previousPairs={},lastEncounterHeartbeatAt=-math.huge
    },Validator)
end
function Validator:loadMap()
    self.elapsed=0; self.lastSignature=nil; self.lastLogAt=-math.huge; self.records={}; self.errorCount=0
    self.acquisitionSignatures={}; self.assemblyDiagnosticSignatures={}; self.profileDiagnosticSignatures={}; self.warningLastAt={}; self.previousEncounters={}; self.previousPairs={}; self.lastEncounterHeartbeatAt=-math.huge
    self.source:reset(); if self.probe~=nil then self.probe:reset() end; if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:reset() end
    logInfo("Field World Equivalence Authority, bounded interaction diagnostics and passive plan-view representation shadow active; Job Episode geometry cached; predicates unchanged; replacement Control authority disabled")
end
function Validator:deleteMap()
    self.source:reset(); if self.probe~=nil then self.probe:reset() end; if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:reset() end
    self.elapsed=0; self.lastSignature=nil; self.previousEncounters={}; self.previousPairs={}
end
function Validator:keyEvent() end
function Validator:mouseEvent() end
function Validator:draw() end

function Validator:_warn(code,details,nowMilliseconds)
    local pair=details and (details.pairReferenceKey or details.assemblyReferenceKey or details.encounterIdentity) or nil
    local key=tostring(code).."|"..tostring(pair or "global")
    local heartbeat=OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS or 10000
    local last=self.warningLastAt[key]
    if last==nil or nowMilliseconds-last>=heartbeat then
        self.warningLastAt[key]=nowMilliseconds
        logWarning(string.format("code=%s subject=%s operation=%s reason=%s outcome=%s",tostring(code),tostring(pair or "global"),tostring(details and details.operationId or "n/a"),tostring(details and (details.reason or details.exclusionReason) or "n/a"),tostring(details and details.principalOutcome or "n/a")))
    end
end

function Validator:_record(raw)
    if self.runtime.controlAuthorityEnabled~=false or OuttaMyWay.CONTROL_AUTHORITY_ENABLED~=false then error("passive-live validation detected enabled Control authority",2) end
    local processed=self.runtime:processSealedObservation(raw)
    local supported=self.support:attach(processed.picture,processed.snapshot)
    local evaluated=self.runtime:evaluateSealedOperationalPicture(supported)
    local capability=selectedCapability(evaluated)
    local passCandidates,unresolvedCandidates,failedCandidates=candidateVerdictSummary(evaluated)
    local diagnostics=supported.diagnostics or {}
    local counters=diagnostics.counters or {}
    local record=OuttaMyWay.PassiveLiveTraceRecord.new({
        identity=self.runtime.identities:issue("PASSIVE_LIVE_TRACE"),epoch=self.runtime.epochs:next(),timestamp=raw.timestamp,status="TRACE",
        observationSnapshotId=processed.snapshot.identity,operationalPictureId=supported.identity,candidateInventoryId=evaluated.candidateInventory.identity,verdictSetId=evaluated.verdictSet.identity,decisionId=evaluated.decision.identity,
        selectedCandidateId=evaluated.decision.selectedCandidateId,selectedCapability=capability,nonIntervention=evaluated.decision.nonIntervention,
        observedAssemblyCount=OuttaMyWay.ValueRecord.length(processed.snapshot.assemblies),activeAssemblyCount=activeAssemblyCount(processed.snapshot),activeJobEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.activeEpisodeIds),
        admittedEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.admittedEpisodeIds),endedEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.endedEpisodeIds),activeOperationCount=OuttaMyWay.ValueRecord.length(processed.operation.activeOperationIds),
        situationCount=OuttaMyWay.ValueRecord.length(supported.situations),encounterCount=OuttaMyWay.ValueRecord.length(supported.encounters),candidateCount=#evaluated.candidates,allPassCandidateCount=passCandidates,
        unresolvedCandidateCount=unresolvedCandidates,failedCandidateCount=failedCandidates,unavailableSourceCount=OuttaMyWay.ValueRecord.length(processed.snapshot.unavailableSources),
        fieldWorldReferenceKey=processed.snapshot.fieldWorld.referenceKey,fieldWorldFingerprint=processed.snapshot.fieldWorld.geometryFingerprint,
        playerFacingFieldLocators=processed.snapshot.fieldWorld.playerFacingFieldLocators or {},
        globalActiveOperationCount=OuttaMyWay.ValueRecord.length(self.runtime.operations:listActive()),controlAuthorityEnabled=false,
        cycleActiveJobVehicleCount=counters.cycleActiveJobVehicleCount or 0,
        poseResolvedWorkerCount=counters.poseResolvedWorkerCount or 0,
        activeOperationMemberCount=counters.activeOperationMemberCount or 0,
        mathematicallyPossiblePairCount=counters.mathematicallyPossiblePairCount or 0,
        relevantPairCount=counters.relevantPairCount or 0,
        eligiblePairCount=counters.eligiblePairCount or 0,
        evaluatedPairCount=counters.evaluatedPairCount or 0,
        excludedPairCount=counters.excludedPairCount or 0,
        qualifyingPairCount=counters.qualifyingPairCount or 0,
        interactionEvidenceEmittedCount=counters.interactionEvidenceEmittedCount or 0,
        interactionEvidenceReceivedCount=counters.interactionEvidenceReceivedCount or 0,
        encounterCreatedCount=counters.encounterCreatedCount or 0,
        assemblyDiagnostics=diagnostics.assemblyDiagnostics or {},
        pairDiagnostics=diagnostics.pairPipeline or {},
        diagnosticContradictions=diagnostics.contradictions or {},
        encounterDiagnostics=diagnostics.encounterDiagnostics or {},
        activeAssemblyReferenceKeys=activeAssemblyReferenceKeys(processed.snapshot),
        provenance={source="PassiveLiveValidator",fieldWorld=supported.provenance,decisionCommitmentBoundaryApplied=false,interactionPredicatesChanged=false}
    })
    self.records[#self.records+1]=record
    self.runtime.trace:append("PASSIVE_LIVE_TRACE",record.epoch,OuttaMyWay.ValueRecord.canonical(record))
    return record
end

function Validator:_logCycleDiagnostics(cycle,due,nowMilliseconds)
    for _,item in ipairs(cycle.assemblyAcquisition or {}) do
        local signature=table.concat({tostring(item.activeJobVehicleMembership),tostring(item.poseResolved),tostring(item.node),tostring(item.nodeSource),tostring(item.poseReason)},"|")
        if self.acquisitionSignatures[item.assemblyReferenceKey]~=signature or due then
            self.acquisitionSignatures[item.assemblyReferenceKey]=signature
            logInfo(string.format("ACQUISITION assembly=%s name=%s activeJobMember=%s poseResolved=%s node=%s nodeSource=%s reason=%s position=(%s,%s) heading=(%s,%s)",tostring(item.assemblyReferenceKey),tostring(item.name),booleanText(item.activeJobVehicleMembership),booleanText(item.poseResolved),tostring(item.node or "n/a"),tostring(item.nodeSource or "n/a"),tostring(item.poseReason or "n/a"),numberText(item.x),numberText(item.z),numberText(item.headingX),numberText(item.headingZ)))
        end
    end
    for _,item in ipairs(cycle.contradictions or {}) do self:_warn(item.code,item,nowMilliseconds) end
end

function Validator:_logRecordDiagnostics(record,due,nowMilliseconds)
    for _,item in OuttaMyWay.ValueRecord.ipairs(record.assemblyDiagnostics or {}) do
        local motion=item.motion or {}
        local shadow=item.shadowRepresentation or {}
        local signature=table.concat({tostring(item.activeJobVehicleMembership),tostring(item.poseResolved),tostring(item.nodeSource),tostring(item.width),tostring(item.length),tostring(item.radius),tostring(item.componentCount),tostring(item.representationFitnessState),tostring(shadow.configurationProfileId),tostring(shadow.participatingPrimitiveCount),tostring(shadow.inactivePrimitiveCount),tostring(shadow.unresolvedPrimitiveCount),tostring(motion.classification),tostring(item.blocked)},"|")
        if self.assemblyDiagnosticSignatures[item.assemblyReferenceKey]~=signature or due then
            self.assemblyDiagnosticSignatures[item.assemblyReferenceKey]=signature
            local bounds=shadow.planViewSummary and shadow.planViewSummary.bounds or nil
            local stats=shadow.geometryStats or {}            logInfo(string.format("ASSEMBLY assembly=%s name=%s operation=%s activeJobMember=%s pose=%s nodeSource=%s poseReason=%s width=%s length=%s radius=%s assemblyMembers=%d legacyComponentKeys=%d scalarRepresentation=%s footprintRepresentation=%s coverageComplete=%s conservative=%s underApproximationRisk=%s shadowCacheHit=%s shadowMembers=%d shadowEdges=%d shadowInventoryPrimitives=%d shadowParticipatingPrimitives=%d shadowInactivePrimitives=%d shadowUnresolvedPrimitives=%d shadowWorldPrimitives=%d shadowPhysicalPrimitives=%d shadowProfile=%s shadowProfileCacheHit=%s shadowProfiles=%d shadowSelector=%s shadowRuntimeConfirmed=%d shadowDonorFallback=%d shadowBounds=(%s,%s)-(%s,%s) shadowHullPoints=%d geometryAPIMeasurements=%d runtimeActivityChecks=%d hierarchyNodesScanned=%d geometryResolved=%d rootAliasesRejected=%d membershipChanged=%s negativeClearanceAuthority=%s motion=%s reportedSpeed=%s derivedSpeed=%s headingTravelDot=%s yawRateDegPerSec=%s blocked=%s",tostring(item.assemblyReferenceKey),tostring(item.name),tostring(item.operationId or "n/a"),booleanText(item.activeJobVehicleMembership),booleanText(item.poseResolved),tostring(item.nodeSource or "n/a"),tostring(item.poseReason or "n/a"),numberText(item.width),numberText(item.length),numberText(item.radius),tonumber(shadow.memberCount) or 0,tonumber(item.componentCount) or 0,tostring(item.representationFitnessState or "n/a"),shadow.structurallyValid and "PARTIAL_POSITIVE_AUTHORITY" or "UNRESOLVED",booleanText(item.coverageComplete),booleanText(item.conservative),booleanText(item.underApproximationRisk),booleanText(shadow.cacheHit),tonumber(shadow.memberCount) or 0,tonumber(shadow.edgeCount) or 0,tonumber(shadow.inventoryPrimitiveCount or shadow.localPrimitiveCount) or 0,tonumber(shadow.participatingPrimitiveCount) or 0,tonumber(shadow.inactivePrimitiveCount) or 0,tonumber(shadow.unresolvedPrimitiveCount) or 0,tonumber(shadow.worldPrimitiveCount) or 0,tonumber(shadow.physicalPrimitiveCount) or 0,tostring(shadow.configurationProfileId or "n/a"),booleanText(shadow.configurationProfileCacheHit),tonumber(shadow.configurationProfileCount) or 0,tostring(shadow.configurationSelectorSummary or "n/a"),tonumber(shadow.runtimeConfirmedPrimitiveCount) or 0,tonumber(shadow.donorFallbackPrimitiveCount) or 0,numberText(bounds and bounds.minX),numberText(bounds and bounds.minZ),numberText(bounds and bounds.maxX),numberText(bounds and bounds.maxZ),tonumber(shadow.planViewSummary and shadow.planViewSummary.hullPointCount) or 0,tonumber(stats.apiMeasurements) or 0,tonumber(stats.runtimeActivityChecks) or 0,tonumber(stats.hierarchyNodesScanned) or 0,tonumber(stats.resolved) or 0,tonumber(stats.rejectedAliases) or 0,booleanText(shadow.membershipChanged),booleanText(shadow.negativeClearanceAuthority),tostring(motion.classification or "n/a"),numberText(motion.reportedSpeedMps),numberText(motion.positionDerivedSpeedMps),numberText(motion.headingToTravelDot),numberText(motion.yawRateDegreesPerSecond),booleanText(item.blocked)))
        end
        local profileSignature=table.concat({tostring(shadow.configurationProfileId),tostring(shadow.participatingPrimitiveCount),tostring(shadow.inactivePrimitiveCount),tostring(shadow.unresolvedPrimitiveCount),tostring(shadow.configurationSelectorSummary)},"|")
        if shadow.configurationProfileId~=nil and self.profileDiagnosticSignatures[item.assemblyReferenceKey]~=profileSignature then
            self.profileDiagnosticSignatures[item.assemblyReferenceKey]=profileSignature
            logInfo(string.format("PROFILE assembly=%s profile=%s selector=%s inventory=%d participating=%d inactive=%d unresolved=%d runtimeConfirmed=%d donorFallback=%d activeNodes=%s inactiveNodes=%s unresolvedNodes=%s",tostring(item.assemblyReferenceKey),tostring(shadow.configurationProfileId),tostring(shadow.configurationSelectorSummary or "n/a"),tonumber(shadow.inventoryPrimitiveCount) or 0,tonumber(shadow.participatingPrimitiveCount) or 0,tonumber(shadow.inactivePrimitiveCount) or 0,tonumber(shadow.unresolvedPrimitiveCount) or 0,tonumber(shadow.runtimeConfirmedPrimitiveCount) or 0,tonumber(shadow.donorFallbackPrimitiveCount) or 0,table.concat(shadow.participatingPrimitiveNames or {},","),table.concat(shadow.inactivePrimitiveNames or {},","),table.concat(shadow.unresolvedPrimitiveNames or {},",")))
        end
    end

    local maximum=OuttaMyWay.PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE or 64
    local logged=0
    for _,pair in OuttaMyWay.ValueRecord.ipairs(record.pairDiagnostics or {}) do
        if logged<maximum then
            logged=logged+1
            logInfo(string.format("PAIR pair=%s operation=%s sameOperation=%s subject=%s other=%s eligible=%s evaluated=%s excluded=%s exclusion=%s distance=%s required=%s headingDot=%s relativeSpeed=%s closingRate=%s tCPA=%s dCPA=%s scalarCurrent=%s scalarFuture=%s emitted=%s evidenceSource=%s evidenceAuthority=%s received=%s encounter=%s outcome=%s footprintOutcome=%s footprintCurrent=%s footprintFuture=%s footprintTCPA=%s footprintDCPA=%s footprintRequired=%s footprintPrimitives=%d+%d footprintAuthority=%s subjectBlocked=%s otherBlocked=%s",tostring(pair.pairReferenceKey),tostring(pair.operationId or "n/a"),booleanText(pair.sameOperation),tostring(pair.subjectAssemblyReferenceKey),tostring(pair.otherAssemblyReferenceKey),booleanText(pair.eligible),booleanText(pair.evaluated),booleanText(pair.excluded),tostring(pair.exclusionReason or "n/a"),numberText(pair.distance),numberText(pair.required),numberText(pair.headingDot),numberText(pair.relativeSpeedMps),numberText(pair.closingRate),numberText(pair.tcpa),numberText(pair.cpa),booleanText(pair.currentSpaceIntersects),booleanText(pair.futureSpaceConverges),booleanText(pair.interactionEvidenceEmitted),tostring(pair.interactionEvidenceSource or "n/a"),tostring(pair.interactionEvidenceAuthority or "n/a"),booleanText(pair.interactionEvidenceReceived),booleanText(pair.encounterCreated),tostring(pair.principalOutcome or pair.exclusionReason or "n/a"),tostring(pair.shadowOutcome or "n/a"),booleanText(pair.shadowCurrentSpaceIntersects),booleanText(pair.shadowFutureSpaceConverges),numberText(pair.shadowTCPA),numberText(pair.shadowDCPA),numberText(pair.shadowRequired),tonumber(pair.shadowSubjectPhysicalPrimitiveCount) or 0,tonumber(pair.shadowOtherPhysicalPrimitiveCount) or 0,tostring(pair.shadowAuthority or "n/a"),booleanText(pair.subjectBlocked),booleanText(pair.otherBlocked)))
        end
    end
    local pairCount=OuttaMyWay.ValueRecord.length(record.pairDiagnostics or {})
    if pairCount>maximum then logWarning(string.format("code=PAIR_DIAGNOSTIC_LOG_TRUNCATED recorded=%d logged=%d operationalPairEvaluationUnchanged=true",pairCount,maximum)) end
    for _,item in OuttaMyWay.ValueRecord.ipairs(record.diagnosticContradictions or {}) do self:_warn(item.code,item,nowMilliseconds) end
end

function Validator:_logLifecycle(records,nowMilliseconds)
    local currentEncounters,currentPairs,activeReferences={}, {}, {}
    local globalOperations=0
    for _,record in ipairs(records) do
        globalOperations=math.max(globalOperations,tonumber(record.globalActiveOperationCount) or 0)
        for _,referenceKey in OuttaMyWay.ValueRecord.ipairs(record.activeAssemblyReferenceKeys or {}) do activeReferences[referenceKey]=true end
        for _,pair in OuttaMyWay.ValueRecord.ipairs(record.pairDiagnostics or {}) do currentPairs[pair.pairReferenceKey]=pair end
        for _,encounter in OuttaMyWay.ValueRecord.ipairs(record.encounterDiagnostics or {}) do currentEncounters[encounter.encounterIdentity]=encounter end
    end
    local heartbeat=OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS or 10000
    local retainedDue=nowMilliseconds-self.lastEncounterHeartbeatAt>=heartbeat
    if retainedDue then self.lastEncounterHeartbeatAt=nowMilliseconds end

    for identity,encounter in pairs(currentEncounters) do
        if self.previousEncounters[identity]==nil then
            logInfo(string.format("ENCOUNTER lifecycle=CREATED encounter=%s pair=%s operation=%s relationship=%s",tostring(identity),tostring(encounter.pairReferenceKey),tostring(encounter.operationId),tostring(encounter.relationship)))
        elseif retainedDue then
            logInfo(string.format("ENCOUNTER lifecycle=RETAINED encounter=%s pair=%s operation=%s relationship=%s",tostring(identity),tostring(encounter.pairReferenceKey),tostring(encounter.operationId),tostring(encounter.relationship)))
        end
    end
    for identity,previous in pairs(self.previousEncounters) do
        if currentEncounters[identity]==nil then
            local pair=currentPairs[previous.pairReferenceKey]
            local reason
            if globalOperations==0 then reason="OPERATION_ENDED"
            elseif pair~=nil and (pair.sameOperation~=true or pair.eligible~=true) then reason="PAIR_NO_LONGER_ELIGIBLE"
            elseif pair~=nil and pair.qualifying~=true then reason="INTERACTION_PREDICATE_CLEARED"
            elseif pair==nil and (not activeReferences[previous.subjectAssemblyReferenceKey] or not activeReferences[previous.otherAssemblyReferenceKey]) then reason="JOB_EPISODE_ENDED"
            else reason="EVIDENCE_UNAVAILABLE" end
            logInfo(string.format("ENCOUNTER lifecycle=LOST encounter=%s pair=%s operation=%s reason=%s",tostring(identity),tostring(previous.pairReferenceKey),tostring(previous.operationId),reason))
        end
    end

    for pairReferenceKey,pair in pairs(currentPairs) do
        local previous=self.previousPairs[pairReferenceKey]
        if previous~=nil and previous.episodeSignature==pair.episodeSignature and previous.operationId~=nil and pair.operationId~=nil and previous.operationId~=pair.operationId then
            self:_warn("PAIR_OPERATION_CHANGED_DURING_JOB_EPISODE",{pairReferenceKey=pairReferenceKey,operationId=pair.operationId,reason=tostring(previous.operationId).."->"..tostring(pair.operationId)},nowMilliseconds)
        end
    end
    for pairReferenceKey,previous in pairs(self.previousPairs) do
        if currentPairs[pairReferenceKey]==nil and activeReferences[previous.subjectAssemblyReferenceKey] and activeReferences[previous.otherAssemblyReferenceKey] then
            self:_warn("PAIR_DISAPPEARED_WHILE_BOTH_WORKERS_ACTIVE",{pairReferenceKey=pairReferenceKey,operationId=previous.operationId,reason="PAIR_RECORD_ABSENT"},nowMilliseconds)
        end
    end

    self.previousEncounters={}
    for identity,encounter in pairs(currentEncounters) do
        self.previousEncounters[identity]={
            encounterIdentity=identity,pairReferenceKey=encounter.pairReferenceKey,operationId=encounter.operationId,relationship=encounter.relationship,
            subjectAssemblyReferenceKey=currentPairs[encounter.pairReferenceKey] and currentPairs[encounter.pairReferenceKey].subjectAssemblyReferenceKey or nil,
            otherAssemblyReferenceKey=currentPairs[encounter.pairReferenceKey] and currentPairs[encounter.pairReferenceKey].otherAssemblyReferenceKey or nil
        }
    end
    self.previousPairs={}
    for pairReferenceKey,pair in pairs(currentPairs) do
        self.previousPairs[pairReferenceKey]={
            pairReferenceKey=pairReferenceKey,subjectAssemblyReferenceKey=pair.subjectAssemblyReferenceKey,otherAssemblyReferenceKey=pair.otherAssemblyReferenceKey,
            operationId=pair.operationId,episodeSignature=pair.episodeSignature
        }
    end
end

function Validator:update(dt)
    if g_currentMission==nil then return end
    if g_client~=nil and g_server==nil then return end
    if self.fieldWorldSnapshots~=nil then self.fieldWorldSnapshots:update(dt or 0,g_currentMission) end
    self.elapsed=self.elapsed+(dt or 0)
    local interval=OuttaMyWay.PASSIVE_SAMPLE_INTERVAL_MS or 1000
    if self.elapsed<interval then return end
    self.elapsed=self.elapsed%interval
    local now=(tonumber(g_time) or 0)/1000
    local nowMilliseconds=tonumber(g_time) or 0
    if self.probe~=nil then self.probe:update(g_currentMission,now,nowMilliseconds) end
    local observations=self.source:capture(g_currentMission,now)
    local due=nowMilliseconds-self.lastLogAt >= (OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS or 10000)
    self:_logCycleDiagnostics(self.source:getLastDiagnostics(),due,nowMilliseconds)
    local sampleRecords={}
    for _,raw in OuttaMyWay.ValueRecord.ipairs(observations) do
        local ok,result=pcall(self._record,self,raw)
        if ok then
            sampleRecords[#sampleRecords+1]=result
            local signature=table.concat({tostring(result.fieldWorldReferenceKey),tostring(result.observedAssemblyCount),tostring(result.activeAssemblyCount),tostring(result.activeJobEpisodeCount),tostring(result.activeOperationCount),tostring(result.globalActiveOperationCount),tostring(result.situationCount),tostring(result.encounterCount),tostring(result.candidateCount),tostring(result.relevantPairCount),tostring(result.eligiblePairCount),tostring(result.evaluatedPairCount),tostring(result.qualifyingPairCount),tostring(result.interactionEvidenceEmittedCount),tostring(result.interactionEvidenceReceivedCount),tostring(result.unavailableSourceCount)},"|")
            local signatureChanged=signature~=self.lastSignature
            if signatureChanged or due then
                self.lastSignature=signature; self.lastLogAt=nowMilliseconds
                local locators={}
                for _,id in OuttaMyWay.ValueRecord.ipairs(result.playerFacingFieldLocators or {}) do locators[#locators+1]=tostring(id) end
                logInfo(string.format("trace=%s field=%s fingerprint=%s locators=%s observed=%d active=%d activeJobVehicles=%d poseResolved=%d episodes=%d admitted=%d ended=%d operations=%d globalOperations=%d operationMembers=%d operationSituations=%d pairCandidates=%d eligiblePairs=%d evaluatedPairs=%d excludedPairs=%d qualifyingPairs=%d interactionEmitted=%d interactionReceived=%d encounters=%d decisionCandidates=%d pass=%d unresolved=%d failed=%d gaps=%d selected=%s decision=%s control=false",result.identity,tostring(result.fieldWorldReferenceKey),tostring(result.fieldWorldFingerprint or "waiting"),#locators>0 and table.concat(locators,",") or "unresolved",result.observedAssemblyCount or 0,result.activeAssemblyCount,result.cycleActiveJobVehicleCount or 0,result.poseResolvedWorkerCount or 0,result.activeJobEpisodeCount,result.admittedEpisodeCount or 0,result.endedEpisodeCount or 0,result.activeOperationCount,result.globalActiveOperationCount or 0,result.activeOperationMemberCount or 0,result.situationCount,result.relevantPairCount or 0,result.eligiblePairCount or 0,result.evaluatedPairCount or 0,result.excludedPairCount or 0,result.qualifyingPairCount or 0,result.interactionEvidenceEmittedCount or 0,result.interactionEvidenceReceivedCount or 0,result.encounterCount,result.candidateCount or 0,result.allPassCandidateCount or 0,result.unresolvedCandidateCount or 0,result.failedCandidateCount or 0,result.unavailableSourceCount or 0,tostring(result.selectedCapability),tostring(result.nonIntervention and result.nonIntervention.classification)))
            end
            self:_logRecordDiagnostics(result,due,nowMilliseconds)
        else
            self.errorCount=self.errorCount+1; logError(tostring(result))
        end
    end
    self:_logLifecycle(sampleRecords,nowMilliseconds)
end
function Validator:getRecords() local result={}; for i,v in OuttaMyWay.ValueRecord.ipairs(self.records) do result[i]=v end; return result end
function Validator:getErrorCount() return self.errorCount end
