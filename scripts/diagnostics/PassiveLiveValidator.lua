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

local function futureSpaceRelationships(picture)
    local result={}
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture and picture.situations or {}) do
        for _,relationship in OuttaMyWay.ValueRecord.ipairs(situation.futureSpaceRelationships or {}) do
            result[#result+1]=relationship
        end
    end
    table.sort(result,function(a,b) return tostring(a.interactionReferenceKey)<tostring(b.interactionReferenceKey) end)
    return result
end
function Validator.new(runtime)
    return setmetatable({
        runtime=runtime,progressionPreservationProbe=nil,
        elapsed=0,lastLogAt=-math.huge,lastSignature=nil,records={},errorCount=0,
        acquisitionSignatures={},assemblyDiagnosticSignatures={},profileDiagnosticSignatures={},pairDiagnosticSignatures={},warningLastAt={},
        previousEncounters={},previousPairs={},lastEncounterHeartbeatAt=-math.huge,futureSpaceHud=OuttaMyWay.FutureSpaceHud.new(),transitionHud=OuttaMyWay.TransitionHud.new(),futureSpaceLogSignatures={},followerBoundaryLogSignatures={}
    },Validator)
end
function Validator:setProgressionPreservationProbe(probe) self.progressionPreservationProbe=probe end
function Validator:loadMap()
    self.elapsed=0; self.lastSignature=nil; self.lastLogAt=-math.huge; self.records={}; self.errorCount=0
    self.acquisitionSignatures={}; self.assemblyDiagnosticSignatures={}; self.profileDiagnosticSignatures={}; self.pairDiagnosticSignatures={}; self.warningLastAt={}; self.previousEncounters={}; self.previousPairs={}; self.lastEncounterHeartbeatAt=-math.huge; self.futureSpaceLogSignatures={}; self.followerBoundaryLogSignatures={}; self.futureSpaceHud:reset(); self.transitionHud:reset()
    logInfo("Diagnostic observer active; Runtime processing and bounded Control dispatch are already complete before trace publication; diagnosticOnly=true")
end
function Validator:deleteMap()
    self.elapsed=0; self.lastSignature=nil; self.previousEncounters={}; self.previousPairs={}; self.futureSpaceLogSignatures={}; self.followerBoundaryLogSignatures={}; self.futureSpaceHud:reset(); self.transitionHud:reset()
end
function Validator:keyEvent() end
function Validator:mouseEvent() end
function Validator:draw() self.futureSpaceHud:draw(); self.transitionHud:draw() end

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

function Validator:_record(raw,live)
    if self.runtime.generalControlAuthorityEnabled~=false or OuttaMyWay.CONTROL_AUTHORITY_ENABLED~=false then error("passive-live diagnostic detected enabled general Control authority",2) end
    if type(live)~="table" or live.snapshot==nil or live.picture==nil or live.decision==nil then error("Runtime live result required before diagnostic publication",2) end
    local processed={snapshot=live.snapshot,jobEpisodes=live.jobEpisodes,operation=live.operation}
    local supported=live.picture
    local evaluated={candidateInventory=live.candidateInventory,candidates=live.candidates,verdictSet=live.verdictSet,verdicts=live.verdicts,decision=live.decision}
    local capability=selectedCapability(evaluated)
    local passCandidates,unresolvedCandidates,failedCandidates=candidateVerdictSummary(evaluated)
    if self.progressionPreservationProbe~=nil then self.progressionPreservationProbe:observe(processed.snapshot,supported,evaluated,raw.timestamp) end
    local diagnostics=supported.diagnostics or {}; local counters=diagnostics.counters or {}; local assessedFutureSpaceRelationships=futureSpaceRelationships(supported)
    local dispatch=live.controlDispatch or {}; local request=dispatch.request; local outcome=dispatch.outcome
    local record=OuttaMyWay.PassiveLiveTraceRecord.new({
        identity=self.runtime.identities:issue("PASSIVE_LIVE_TRACE"),epoch=self.runtime.epochs:next(),timestamp=raw.timestamp,status="TRACE",
        observationSnapshotId=processed.snapshot.identity,operationalPictureId=supported.identity,candidateInventoryId=evaluated.candidateInventory.identity,verdictSetId=evaluated.verdictSet.identity,decisionId=evaluated.decision.identity,
        selectedCandidateId=evaluated.decision.selectedCandidateId,selectedCapability=capability,nonIntervention=evaluated.decision.nonIntervention,
        observedAssemblyCount=OuttaMyWay.ValueRecord.length(processed.snapshot.assemblies),activeAssemblyCount=activeAssemblyCount(processed.snapshot),activeJobEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.activeEpisodeIds),
        admittedEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.admittedEpisodeIds),endedEpisodeCount=OuttaMyWay.ValueRecord.length(processed.jobEpisodes.endedEpisodeIds),activeOperationCount=OuttaMyWay.ValueRecord.length(processed.operation.activeOperationIds),
        situationCount=OuttaMyWay.ValueRecord.length(supported.situations),encounterCount=OuttaMyWay.ValueRecord.length(supported.encounters),candidateCount=#evaluated.candidates,allPassCandidateCount=passCandidates,
        unresolvedCandidateCount=unresolvedCandidates,failedCandidateCount=failedCandidates,unavailableSourceCount=OuttaMyWay.ValueRecord.length(processed.snapshot.unavailableSources),
        fieldWorldReferenceKey=processed.snapshot.fieldWorld.referenceKey,fieldWorldFingerprint=processed.snapshot.fieldWorld.geometryFingerprint,playerFacingFieldLocators=processed.snapshot.fieldWorld.playerFacingFieldLocators or {},
        globalActiveOperationCount=OuttaMyWay.ValueRecord.length(self.runtime.operations:listActive()),generalControlAuthorityEnabled=false,
        boundedControlDispatchStatus=dispatch.status,boundedControlRequestId=request and request.identity or nil,boundedControlOutcomeId=outcome and outcome.identity or nil,
        cycleActiveJobVehicleCount=counters.cycleActiveJobVehicleCount or 0,poseResolvedWorkerCount=counters.poseResolvedWorkerCount or 0,activeOperationMemberCount=counters.activeOperationMemberCount or 0,mathematicallyPossiblePairCount=counters.mathematicallyPossiblePairCount or 0,relevantPairCount=counters.relevantPairCount or 0,eligiblePairCount=counters.eligiblePairCount or 0,evaluatedPairCount=counters.evaluatedPairCount or 0,excludedPairCount=counters.excludedPairCount or 0,qualifyingPairCount=counters.qualifyingPairCount or 0,interactionEvidenceEmittedCount=counters.interactionEvidenceEmittedCount or 0,interactionEvidenceReceivedCount=counters.interactionEvidenceReceivedCount or 0,encounterCreatedCount=counters.encounterCreatedCount or 0,activeEncounterCount=counters.activeEncounterCount or 0,encounterLifecycleTransitionCount=counters.encounterLifecycleTransitionCount or 0,
        admittedEpisodeIds=processed.jobEpisodes.admittedEpisodeIds,endedEpisodeIds=processed.jobEpisodes.endedEpisodeIds,assemblyDiagnostics=diagnostics.assemblyDiagnostics or {},pairDiagnostics=diagnostics.pairPipeline or {},diagnosticContradictions=diagnostics.contradictions or {},encounterDiagnostics=diagnostics.encounterDiagnostics or {},encounterLifecycleTransitions=diagnostics.encounterLifecycleTransitions or {},futureSpaceRelationshipCount=#assessedFutureSpaceRelationships,futureSpaceRelationships=assessedFutureSpaceRelationships,activeAssemblyReferenceKeys=activeAssemblyReferenceKeys(processed.snapshot),
        provenance={source="PassiveLiveValidator",runtimeProcessingComplete=true,fieldWorld=supported.provenance,decisionCommitmentBoundaryApplied=dispatch.commitment~=nil,interactionPredicatesChanged=false,diagnosticOnly=true}
    })
    self.records[#self.records+1]=record; self.runtime.trace:append("PASSIVE_LIVE_TRACE",record.epoch,OuttaMyWay.ValueRecord.canonical(record)); return record
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
            local stats=shadow.geometryStats or {}            logInfo(string.format("ASSEMBLY assembly=%s name=%s operation=%s activeJobMember=%s pose=%s nodeSource=%s poseReason=%s width=%s length=%s radius=%s assemblyMembers=%d legacyComponentKeys=%d scalarRepresentation=%s footprintRepresentation=%s coverageComplete=%s conservative=%s underApproximationRisk=%s shadowCacheHit=%s shadowMembers=%d shadowEdges=%d shadowInventoryPrimitives=%d shadowParticipatingPrimitives=%d shadowInactivePrimitives=%d shadowUnresolvedPrimitives=%d shadowWorldPrimitives=%d shadowPhysicalPrimitives=%d shadowProfile=%s shadowProfileCacheHit=%s shadowProfiles=%d shadowSelector=%s shadowRuntimeConfirmed=%d shadowDonorFallback=%d shadowBounds=(%s,%s)-(%s,%s) shadowHullPoints=%d geometryAPIMeasurements=%d shapeClassChecks=%d runtimeActivityChecks=%d hierarchyNodesScanned=%d geometryResolved=%d rootAliasesRejected=%d nonShapesRejected=%d shapeClassUnresolved=%d membershipChanged=%s negativeClearanceAuthority=%s motion=%s reportedSpeed=%s derivedSpeed=%s headingTravelDot=%s yawRateDegPerSec=%s blocked=%s",tostring(item.assemblyReferenceKey),tostring(item.name),tostring(item.operationId or "n/a"),booleanText(item.activeJobVehicleMembership),booleanText(item.poseResolved),tostring(item.nodeSource or "n/a"),tostring(item.poseReason or "n/a"),numberText(item.width),numberText(item.length),numberText(item.radius),tonumber(shadow.memberCount) or 0,tonumber(item.componentCount) or 0,tostring(item.representationFitnessState or "n/a"),shadow.structurallyValid and "PARTIAL_POSITIVE_AUTHORITY" or "UNRESOLVED",booleanText(item.coverageComplete),booleanText(item.conservative),booleanText(item.underApproximationRisk),booleanText(shadow.cacheHit),tonumber(shadow.memberCount) or 0,tonumber(shadow.edgeCount) or 0,tonumber(shadow.inventoryPrimitiveCount or shadow.localPrimitiveCount) or 0,tonumber(shadow.participatingPrimitiveCount) or 0,tonumber(shadow.inactivePrimitiveCount) or 0,tonumber(shadow.unresolvedPrimitiveCount) or 0,tonumber(shadow.worldPrimitiveCount) or 0,tonumber(shadow.physicalPrimitiveCount) or 0,tostring(shadow.configurationProfileId or "n/a"),booleanText(shadow.configurationProfileCacheHit),tonumber(shadow.configurationProfileCount) or 0,tostring(shadow.configurationSelectorSummary or "n/a"),tonumber(shadow.runtimeConfirmedPrimitiveCount) or 0,tonumber(shadow.donorFallbackPrimitiveCount) or 0,numberText(bounds and bounds.minX),numberText(bounds and bounds.minZ),numberText(bounds and bounds.maxX),numberText(bounds and bounds.maxZ),tonumber(shadow.planViewSummary and shadow.planViewSummary.hullPointCount) or 0,tonumber(stats.apiMeasurements) or 0,tonumber(stats.shapeClassChecks) or 0,tonumber(stats.runtimeActivityChecks) or 0,tonumber(stats.hierarchyNodesScanned) or 0,tonumber(stats.resolved) or 0,tonumber(stats.rejectedAliases) or 0,tonumber(stats.nonShapeRejected) or 0,tonumber(stats.shapeClassUnresolved) or 0,booleanText(shadow.membershipChanged),booleanText(shadow.negativeClearanceAuthority),tostring(motion.classification or "n/a"),numberText(motion.reportedSpeedMps),numberText(motion.positionDerivedSpeedMps),numberText(motion.headingToTravelDot),numberText(motion.yawRateDegreesPerSecond),booleanText(item.blocked)))
        end
        local profileSignature=table.concat({tostring(shadow.configurationProfileId),tostring(shadow.participatingPrimitiveCount),tostring(shadow.inactivePrimitiveCount),tostring(shadow.unresolvedPrimitiveCount),tostring(shadow.configurationSelectorSummary)},"|")
        if shadow.configurationProfileId~=nil and self.profileDiagnosticSignatures[item.assemblyReferenceKey]~=profileSignature then
            self.profileDiagnosticSignatures[item.assemblyReferenceKey]=profileSignature
            logInfo(string.format("PROFILE assembly=%s profile=%s selector=%s inventory=%d participating=%d inactive=%d unresolved=%d runtimeConfirmed=%d donorFallback=%d activeNodes=%s inactiveNodes=%s unresolvedNodes=%s",tostring(item.assemblyReferenceKey),tostring(shadow.configurationProfileId),tostring(shadow.configurationSelectorSummary or "n/a"),tonumber(shadow.inventoryPrimitiveCount) or 0,tonumber(shadow.participatingPrimitiveCount) or 0,tonumber(shadow.inactivePrimitiveCount) or 0,tonumber(shadow.unresolvedPrimitiveCount) or 0,tonumber(shadow.runtimeConfirmedPrimitiveCount) or 0,tonumber(shadow.donorFallbackPrimitiveCount) or 0,table.concat(shadow.participatingPrimitiveNames or {},","),table.concat(shadow.inactivePrimitiveNames or {},","),table.concat(shadow.unresolvedPrimitiveNames or {},",")))
        end
    end

    local maximum=OuttaMyWay.PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE or 8
    local logged,eligibleToLog=0,0
    for _,pair in OuttaMyWay.ValueRecord.ipairs(record.pairDiagnostics or {}) do
        local signature=table.concat({tostring(pair.operationId),tostring(pair.episodeSignature),tostring(pair.eligible),tostring(pair.evaluated),tostring(pair.exclusionReason),tostring(pair.principalOutcome),tostring(pair.currentFootprintOutcome),tostring(pair.interactionEvidenceEmitted),tostring(pair.interactionEvidenceReceived),tostring(pair.encounterCreated),tostring(pair.subjectBlocked),tostring(pair.otherBlocked)},"|")
        local changed=self.pairDiagnosticSignatures[pair.pairReferenceKey]~=signature
        if changed then self.pairDiagnosticSignatures[pair.pairReferenceKey]=signature end
        if changed or due then
            eligibleToLog=eligibleToLog+1
            if logged<maximum then
                logged=logged+1
                logInfo(string.format("PAIR pair=%s operation=%s sameOperation=%s subject=%s other=%s eligible=%s evaluated=%s excluded=%s exclusion=%s distance=%s required=%s headingDot=%s relativeSpeed=%s closingRate=%s currentScalar=%s currentFootprint=%s futureSpacePositive=%s emitted=%s evidenceSource=%s evidenceAuthority=%s received=%s encounter=%s outcome=%s footprintOutcome=%s footprintDistance=%s footprintRequired=%s footprintPrimitives=%d+%d footprintAuthority=%s subjectBlocked=%s otherBlocked=%s",tostring(pair.pairReferenceKey),tostring(pair.operationId or "n/a"),booleanText(pair.sameOperation),tostring(pair.subjectAssemblyReferenceKey),tostring(pair.otherAssemblyReferenceKey),booleanText(pair.eligible),booleanText(pair.evaluated),booleanText(pair.excluded),tostring(pair.exclusionReason or "n/a"),numberText(pair.distance),numberText(pair.required),numberText(pair.headingDot),numberText(pair.relativeSpeedMps),numberText(pair.closingRate),booleanText(pair.currentSpaceIntersects),booleanText(pair.currentFootprintIntersects),booleanText(pair.fieldBoundedFutureSpacePositive),booleanText(pair.interactionEvidenceEmitted),tostring(pair.interactionEvidenceSource or "n/a"),tostring(pair.interactionEvidenceAuthority or "n/a"),booleanText(pair.interactionEvidenceReceived),booleanText(pair.encounterCreated),tostring(pair.principalOutcome or pair.exclusionReason or "n/a"),tostring(pair.currentFootprintOutcome or "n/a"),numberText(pair.currentFootprintDistance),numberText(pair.currentFootprintRequired),tonumber(pair.currentFootprintSubjectPhysicalPrimitiveCount) or 0,tonumber(pair.currentFootprintOtherPhysicalPrimitiveCount) or 0,tostring(pair.currentFootprintAuthority or "n/a"),booleanText(pair.subjectBlocked),booleanText(pair.otherBlocked)))
            end
        end
    end
    if eligibleToLog>maximum then logWarning(string.format("code=PAIR_DIAGNOSTIC_LOG_TRUNCATED eligible=%d logged=%d operationalPairEvaluationUnchanged=true",eligibleToLog,maximum)) end
    for _,item in OuttaMyWay.ValueRecord.ipairs(record.diagnosticContradictions or {}) do self:_warn(item.code,item,nowMilliseconds) end
end

function Validator:_logFutureSpaceRelationships(record)
    for _,relationship in OuttaMyWay.ValueRecord.ipairs(record.futureSpaceRelationships or {}) do
        local key=tostring(relationship.interactionReferenceKey or "pair")
        local signature=table.concat({
            tostring(relationship.classification),tostring(relationship.outcome),
            tostring(relationship.subjectIntentEpoch),tostring(relationship.otherIntentEpoch),
            tostring(relationship.subjectLocalIntentClassification),tostring(relationship.otherLocalIntentClassification),
            numberText(relationship.subjectBoundaryDistance),numberText(relationship.otherBoundaryDistance)
        },"|")
        if self.futureSpaceLogSignatures[key]~=signature then
            self.futureSpaceLogSignatures[key]=signature
            logInfo(string.format("FUTURE_SPACE pair=%s classification=%s outcome=%s subjectIntent=%s/%s otherIntent=%s/%s subjectBoundary=%s otherBoundary=%s positive=%s unresolved=%s authority=%s control=false",
                key,tostring(relationship.classification),tostring(relationship.outcome),
                tostring(relationship.subjectLocalIntentClassification),tostring(relationship.subjectIntentEpoch),
                tostring(relationship.otherLocalIntentClassification),tostring(relationship.otherIntentEpoch),
                numberText(relationship.subjectBoundaryDistance),numberText(relationship.otherBoundaryDistance),
                booleanText(relationship.positiveIntersection),booleanText(relationship.unresolved),tostring(relationship.authority or "n/a")))
        end
    end
end

function Validator:_logFollowerBoundaryKnowledge(picture,due)
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.followerBoundaryKnowledge or {}) do
        local relation=item.relationship or {}
        local seed=item.demandSeed or {}
        local magnitude=item.controlMagnitude or {}
        local key=tostring(item.pairKey or "pair")
        local signature=table.concat({tostring(item.status),tostring(item.purposeState),tostring(item.reason),tostring(relation.status),numberText(relation.headingDot),numberText(relation.leaderToFollowerForwardM),numberText(relation.lateralOffsetM),numberText(magnitude.requestedFollowerCapKmh),tostring(item.existingCommitmentId),tostring(item.progressPassage and item.progressPassage.sourcePhase)} ,"|")
        if self.followerBoundaryLogSignatures[key]~=signature or due then
            self.followerBoundaryLogSignatures[key]=signature
            logInfo(string.format("FOLLOWER_BOUNDARY pair=%s leader=%s follower=%s status=%s purposeState=%s reason=%s relation=%s headingDot=%s forward=%sm lateral=%sm corridorHalfWidth=%sm demandRF=%s seedEntry=(%s,%s)m seedDuration=%ss native=%skmh cap=%skmh leaderRate=%skmh transition=%s restrictive=%s existingCommitment=%s progressPassage=%s controlAuthority=false",
                key,tostring(item.leaderName or item.leaderReferenceKey or item.leaderAssemblyId),tostring(item.followerName or item.followerReferenceKey or item.followerAssemblyId),
                tostring(item.status),tostring(item.purposeState),tostring(item.reason),tostring(relation.status),numberText(relation.headingDot),numberText(relation.leaderToFollowerForwardM),numberText(relation.lateralOffsetM),numberText(relation.corridorHalfWidthM),
                tostring(item.representationFitness or "n/a"),numberText(seed.leaderEntryBoundaryDistanceM),numberText(seed.followerEntryBoundaryDistanceM),numberText(seed.durationSec),numberText(magnitude.nativeUnrestrictedFollowerKmh),numberText(magnitude.requestedFollowerCapKmh),numberText(magnitude.leaderRateUsedKmh),tostring(item.transitionPreservation==true),booleanText(magnitude.regulationRequired),tostring(item.existingCommitmentId or "NONE"),tostring(item.progressPassage and item.progressPassage.sourcePhase or "NONE")))
        end
    end
end

function Validator:_logLifecycle(records,nowMilliseconds)
    local currentPairs,activeReferences,transitions={}, {}, {}
    for _,record in ipairs(records) do
        for _,referenceKey in OuttaMyWay.ValueRecord.ipairs(record.activeAssemblyReferenceKeys or {}) do activeReferences[referenceKey]=true end
        for _,pair in OuttaMyWay.ValueRecord.ipairs(record.pairDiagnostics or {}) do currentPairs[pair.pairReferenceKey]=pair end
        for _,transition in OuttaMyWay.ValueRecord.ipairs(record.encounterLifecycleTransitions or {}) do transitions[#transitions+1]=transition end
    end
    table.sort(transitions,function(a,b)
        if tostring(a.encounterIdentity)~=tostring(b.encounterIdentity) then return tostring(a.encounterIdentity)<tostring(b.encounterIdentity) end
        return tostring(a.lifecycle)<tostring(b.lifecycle)
    end)
    local heartbeat=OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS or 10000
    local retainedDue=nowMilliseconds-self.lastEncounterHeartbeatAt>=heartbeat
    if retainedDue then self.lastEncounterHeartbeatAt=nowMilliseconds end

    for _,transition in ipairs(transitions) do
        self.transitionHud:observeEncounterTransition(transition)
        if transition.lifecycle=="CREATED" then
            logInfo(string.format("ENCOUNTER lifecycle=CREATED encounter=%s pair=%s operation=%s relationship=%s episodeSignature=%s",tostring(transition.encounterIdentity),tostring(transition.interactionReferenceKey),tostring(transition.operationId),tostring(transition.relationship),tostring(transition.episodeSignature)))
        elseif transition.lifecycle=="RETAINED" and retainedDue then
            logInfo(string.format("ENCOUNTER lifecycle=RETAINED encounter=%s pair=%s operation=%s relationship=%s episodeSignature=%s positiveObserved=%s",tostring(transition.encounterIdentity),tostring(transition.interactionReferenceKey),tostring(transition.operationId),tostring(transition.relationship),tostring(transition.episodeSignature),booleanText(transition.positiveObservedThisAssessment)))
        elseif transition.lifecycle=="TERMINATED" then
            local endedEpisode,terminalCause="n/a","n/a"
            local details=transition.terminalEvidence and transition.terminalEvidence.details or nil
            local ended=details and details.endedJobEpisodes or nil
            if ended~=nil then
                for _,item in OuttaMyWay.ValueRecord.ipairs(ended) do endedEpisode=tostring(item.jobEpisodeId); terminalCause=tostring(item.terminalCause); break end
            end
            logInfo(string.format("ENCOUNTER lifecycle=TERMINATED encounter=%s pair=%s operation=%s reason=%s endedEpisode=%s terminalCause=%s episodeSignature=%s",tostring(transition.encounterIdentity),tostring(transition.interactionReferenceKey),tostring(transition.operationId),tostring(transition.terminalReason),endedEpisode,terminalCause,tostring(transition.episodeSignature)))
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

    self.previousPairs={}
    for pairReferenceKey,pair in pairs(currentPairs) do
        self.previousPairs[pairReferenceKey]={
            pairReferenceKey=pairReferenceKey,subjectAssemblyReferenceKey=pair.subjectAssemblyReferenceKey,otherAssemblyReferenceKey=pair.otherAssemblyReferenceKey,
            operationId=pair.operationId,episodeSignature=pair.episodeSignature
        }
    end
end

function Validator:beginRuntimeCycle(cycleDiagnostics,nowMilliseconds)
    local due=nowMilliseconds-self.lastLogAt >= (OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS or 10000)
    self:_logCycleDiagnostics(cycleDiagnostics or {},due,nowMilliseconds)
    return due
end
function Validator:observeRuntimeResult(raw,live,due,nowMilliseconds)
    local record=self:_record(raw,live)
    local signature=table.concat({tostring(record.fieldWorldReferenceKey),tostring(record.observedAssemblyCount),tostring(record.activeAssemblyCount),tostring(record.activeJobEpisodeCount),tostring(record.activeOperationCount),tostring(record.globalActiveOperationCount),tostring(record.situationCount),tostring(record.encounterCount),tostring(record.candidateCount),tostring(record.relevantPairCount),tostring(record.eligiblePairCount),tostring(record.evaluatedPairCount),tostring(record.qualifyingPairCount),tostring(record.interactionEvidenceEmittedCount),tostring(record.interactionEvidenceReceivedCount),tostring(record.unavailableSourceCount),tostring(record.boundedControlDispatchStatus)},"|")
    local signatureChanged=signature~=self.lastSignature
    if signatureChanged or due then
        self.lastSignature=signature; self.lastLogAt=nowMilliseconds
        local locators={}; for _,id in OuttaMyWay.ValueRecord.ipairs(record.playerFacingFieldLocators or {}) do locators[#locators+1]=tostring(id) end
        logInfo(string.format("trace=%s field=%s fingerprint=%s locators=%s observed=%d active=%d activeJobVehicles=%d poseResolved=%d episodes=%d admitted=%d ended=%d operations=%d globalOperations=%d operationMembers=%d operationSituations=%d pairCandidates=%d eligiblePairs=%d evaluatedPairs=%d excludedPairs=%d qualifyingPairs=%d interactionEmitted=%d interactionReceived=%d encounters=%d decisionCandidates=%d pass=%d unresolved=%d failed=%d gaps=%d selected=%s decision=%s generalControl=false boundedDispatch=%s",record.identity,tostring(record.fieldWorldReferenceKey),tostring(record.fieldWorldFingerprint or "waiting"),#locators>0 and table.concat(locators,",") or "unresolved",record.observedAssemblyCount or 0,record.activeAssemblyCount,record.cycleActiveJobVehicleCount or 0,record.poseResolvedWorkerCount or 0,record.activeJobEpisodeCount,record.admittedEpisodeCount or 0,record.endedEpisodeCount or 0,record.activeOperationCount,record.globalActiveOperationCount or 0,record.activeOperationMemberCount or 0,record.situationCount,record.relevantPairCount or 0,record.eligiblePairCount or 0,record.evaluatedPairCount or 0,record.excludedPairCount or 0,record.qualifyingPairCount or 0,record.interactionEvidenceEmittedCount or 0,record.interactionEvidenceReceivedCount or 0,record.encounterCount,record.candidateCount or 0,record.allPassCandidateCount or 0,record.unresolvedCandidateCount or 0,record.failedCandidateCount or 0,record.unavailableSourceCount or 0,tostring(record.selectedCapability),tostring(record.nonIntervention and record.nonIntervention.classification),tostring(record.boundedControlDispatchStatus or "NO_DISPATCH")))
    end
    self:_logRecordDiagnostics(record,due,nowMilliseconds); self:_logFutureSpaceRelationships(record); self:_logFollowerBoundaryKnowledge(live.picture,due)
    return record
end
function Validator:observeRuntimeError(errorValue) self.errorCount=self.errorCount+1; logError(tostring(errorValue)) end
function Validator:endRuntimeCycle(sampleRecords,nowMilliseconds)
    self:_logLifecycle(sampleRecords or {},nowMilliseconds)
    for _,record in ipairs(sampleRecords or {}) do self.transitionHud:observeAdmittedEpisodes(record.admittedEpisodeIds or {}); self.futureSpaceHud:observeRecord(record) end
end
function Validator:update(dt) end
function Validator:getRecords() local result={}; for i,v in OuttaMyWay.ValueRecord.ipairs(self.records) do result[i]=v end; return result end
function Validator:getErrorCount() return self.errorCount end
