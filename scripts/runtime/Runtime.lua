OuttaMyWay.Runtime = {}
local Runtime = OuttaMyWay.Runtime
Runtime.__index = Runtime

local function cooperativeLog(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] %s",message) else print("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] "..message) end
end

function Runtime.new()
    local identities=OuttaMyWay.IdentityRegistry.new(); local epochs=OuttaMyWay.EpochSequence.new(0)
    local commitments=OuttaMyWay.CommitmentRegistry.new(identities,epochs)
    local obligations=OuttaMyWay.ObligationLedger.new(identities,epochs,commitments)
    local authorities=OuttaMyWay.AuthorityRegistry.new(identities,epochs,commitments)
    local fieldWorldSnapshots=OuttaMyWay.FieldWorldSnapshotRegistry.new()
    local fieldWorldEquivalenceEvaluator=OuttaMyWay.FieldWorldEquivalenceEvaluator.new()
    local fieldWorldEquivalenceAuthority=OuttaMyWay.FieldWorldEquivalenceAuthority.new(identities,fieldWorldEquivalenceEvaluator)
    local assemblyRepresentationCache=OuttaMyWay.AssemblyRepresentationCache.new()
    local jobEpisodes=OuttaMyWay.JobEpisodeAdmission.new(identities,epochs)
    local operations=OuttaMyWay.OperationAdmission.new(identities,epochs,jobEpisodes)
    local encounters=OuttaMyWay.EncounterRegistry.new(identities,epochs,jobEpisodes,operations)
    local admission=OuttaMyWay.CommitmentAdmission.new(identities,epochs,commitments,obligations,authorities)
    local governingBasis=OuttaMyWay.GoverningBasisEvaluator.new(identities,epochs)
    local terminalSettlement=OuttaMyWay.TerminalSettlementEvaluator.new(epochs,commitments,obligations,authorities)
    local terminalOccupancyAssessment=OuttaMyWay.TerminalOccupancyAssessment.new(jobEpisodes)
    local runtime=setmetatable({
        identities=identities,epochs=epochs,observationAdapter=OuttaMyWay.RuntimeObservationAdapter.new(identities,epochs),jobEpisodes=jobEpisodes,operations=operations,
        commitments=commitments,obligations=obligations,authorities=authorities,commitmentAdmission=admission,governingBasisEvaluator=governingBasis,terminalSettlementEvaluator=terminalSettlement,terminalOccupancyAssessment=terminalOccupancyAssessment,
        encounters=encounters,situationAssessment=OuttaMyWay.SituationAssessment.new(identities,epochs,jobEpisodes,operations,encounters,commitments,obligations,terminalOccupancyAssessment),
        candidateSpace=OuttaMyWay.CandidateSpace.new(identities,epochs),constraintEngine=OuttaMyWay.ConstraintEngine.new(identities,epochs),decisionSelector=OuttaMyWay.DecisionSelector.new(identities,epochs),
        targetedFieldIdentityProbe=OuttaMyWay.TargetedFieldIdentityProbe.new(),fieldWorldSnapshots=fieldWorldSnapshots,fieldWorldEquivalenceEvaluator=fieldWorldEquivalenceEvaluator,fieldWorldEquivalenceAuthority=fieldWorldEquivalenceAuthority,assemblyRepresentationCache=assemblyRepresentationCache,passiveCandidateSupport=OuttaMyWay.PassiveLiveCandidateSupport.new(identities,epochs),
        trace=OuttaMyWay.ArchitectureTrace.new(),initialized=false,runtimeMode=OuttaMyWay.RUNTIME_MODE,controlAuthorityEnabled=false,generalControlAuthorityEnabled=false,cooperativeVerdictTraceKey=nil
    },Runtime)
    runtime.liveObservationSource=OuttaMyWay.LiveObservationSource.new(runtime.fieldWorldSnapshots,runtime.fieldWorldEquivalenceAuthority,runtime.assemblyRepresentationCache)
    runtime.terminalEgressCandidateSupport=OuttaMyWay.TerminalEgressCandidateSupport.new(identities,epochs)
    runtime.liveTrafficCandidateSupport=OuttaMyWay.LiveTrafficCandidateSupport.new(identities,epochs,runtime.passiveCandidateSupport)
    runtime.liveControlDispatcher=OuttaMyWay.LiveControlDispatcher.new(runtime)
    runtime.decisionCommitmentBoundary=OuttaMyWay.DecisionCommitmentBoundary.new(identities,epochs,admission,commitments,obligations,authorities,governingBasis,terminalSettlement)
    runtime.followerBoundaryResponsibilityTransition=OuttaMyWay.FollowerBoundaryResponsibilityTransition.new(runtime)
    runtime.actionSpaceRegulationResponsibilityTransition=OuttaMyWay.ActionSpaceRegulationResponsibilityTransition.new(runtime)
    runtime.cooperativePassageResponsibilityTransition=OuttaMyWay.CooperativePassageResponsibilityTransition.new(runtime)
    runtime.completedObstructionResponsibilityTransition=OuttaMyWay.CompletedObstructionResponsibilityTransition.new(runtime)
    runtime.replayRunner=OuttaMyWay.ReplayRunner.new(runtime)
    runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime)
    return runtime
end
function Runtime:initialize()
    if self.initialized then return end; self.initialized=true
    -- Structural continuity markers: general production Control authority disabled; Control authority disabled.
    -- D-0146 Step-1 Situation Knowledge is live-validated and Step-2 Established Conflict -> Candidate-owned Local Passage Search -> Passage Guide -> Commitment/Control is ACTIVE.
    self.trace:append("PROGRESSIVE_SITUATIONAL_SUFFICIENCY_INITIALIZED",self.epochs:next(),"architecture="..OuttaMyWay.ARCHITECTURE_VERSION..";d0147TerminalYieldArchitecture=true;d0147BoundedInfieldRetreatImplementation=v4.7.126-60m-native-max-test;automaticTerminalEgress="..tostring(OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true)..";d0146Step1SituationKnowledge=true;trajectoryPersistence=true;opposedCorridorClassification=true;d0146Step2OperationAware=true;d0143CooperativePassage=false;d0143MechanicalDonorHistoricalOnly=true;d0141FollowerRegulation=true;turningRankAwarenessRetained=true;successorRookRetired=true;continuousProductiveHistoryRetired=true;kingRetired=true;continuousRefugeRetired=true;runtimeOwnedCycle=true;situationOwnsCurrentKnowledge=true;diagnosticsAuthority=false;generalControl=false")
    print(string.format("FS25_OuttaMyWay %s loaded; D-0195 Assembly Axis Settlement + D-0194 Two-Stage Terminal Courtesy TEST: Phase-8A settles on captured axis without reproducing Phase-5 articulation; terminal first obstruction -> centroid, renewed obstruction -> one final boundary settlement; no third automatic relocation; D-0192/D-0188/D-0186 remain active; automatic terminal-yield gate=%s",tostring(OuttaMyWay.BUILD_LABEL or ("v"..tostring(OuttaMyWay.VERSION))),tostring(OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true)))
end

function Runtime:setLiveControlCapability(capability)
    self.liveControlDispatcher:setCapability(capability)
end
function Runtime:markAutonomousHeadOnDispatched(governingRequirementKey)
    self.liveTrafficCandidateSupport:markAutonomousHeadOnDispatched(governingRequirementKey)
end
function Runtime:resetAutonomousHeadOnState()
    self.liveTrafficCandidateSupport:resetAutonomousState()
end
function Runtime:resetSituationKnowledge()
    if self.situationAssessment and type(self.situationAssessment.resetSituationKnowledge)=="function" then self.situationAssessment:resetSituationKnowledge() end
end
function Runtime:publishObservation(raw) return self.observationAdapter:publish(raw) end
function Runtime:admitJobEpisodes(snapshot) return self.jobEpisodes:observe(snapshot) end
function Runtime:admitOperation(snapshot,episodeResult) return self.operations:observe(snapshot,episodeResult) end
function Runtime:assessOperationalPicture(snapshot,episodeResult,operationResult) return self.situationAssessment:assess(snapshot,episodeResult,operationResult) end
function Runtime:processSealedObservation(raw)
    local snapshot=self:publishObservation(raw)
    local episodes=self:admitJobEpisodes(snapshot)
    local operation=self:admitOperation(snapshot,episodes)
    -- D-0200: positive Job Episode termination collapses any traffic Commitment
    -- whose Encounter dependency includes that episode before Situation publishes
    -- Commitment context. This prevents dead traffic authority from blocking D-0147
    -- terminal succession in the same sealed observation.
    local trafficCommitmentCollapse=OuttaMyWay.LiveTrafficCommitmentLifecycle.collapseEndedJobEpisodeDependencies(self,episodes,snapshot)
    local picture=self:assessOperationalPicture(snapshot,episodes,operation)
    return {snapshot=snapshot,jobEpisodes=episodes,operation=operation,picture=picture,trafficCommitmentCollapse=trafficCommitmentCollapse}
end
function Runtime:evaluateSealedOperationalPicture(picture)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    local candidates=self.candidateSpace:generate(picture)
    local verdicts=self.constraintEngine:evaluate(picture,candidates)
    local decision=self.decisionSelector:select(picture,candidates,verdicts)
    return {picture=picture,candidateInventory=candidates.inventory,candidates=candidates.candidates,verdictSet=verdicts.set,verdicts=verdicts.verdicts,decision=decision}
end

function Runtime:dispatchEvaluatedOperationalPicture(picture,evaluated)
    local dispatch=self.liveControlDispatcher:dispatch(picture,evaluated)
    if dispatch.status=="FOLLOWER_BOUNDARY_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=self.followerBoundaryResponsibilityTransition:transition(picture,evaluated,dispatch)
        if applied==nil then
            return {status="NO_DISPATCH",reason="FOLLOWER_BOUNDARY_RESPONSIBILITY_APPLICATION_FAILED",detail=reason,candidateId=dispatch.candidateId,followerBoundary=true}
        end
        return self.liveControlDispatcher:continueFollowerBoundary(picture,evaluated,applied)
    end
    if dispatch.status=="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=self.actionSpaceRegulationResponsibilityTransition:transition(picture,evaluated,dispatch)
        if applied==nil then return self.liveControlDispatcher:actionSpaceRegulationTransitionFailed(dispatch,reason) end
        return self.liveControlDispatcher:continueActionSpaceRegulation(picture,evaluated,applied,dispatch)
    end
    if dispatch.status=="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=self.cooperativePassageResponsibilityTransition:transition(picture,evaluated,dispatch)
        if applied==nil then
            return {status="NO_DISPATCH",reason="COMMITMENT_APPLICATION_FAILED",detail=reason,candidateId=dispatch.candidateId}
        end
        local continued=self.liveControlDispatcher:continueCooperativePassage(picture,evaluated,applied)
        continued.currentResponsibility=applied.currentResponsibility
        return continued
    end
    if dispatch.status=="COMPLETED_OBSTRUCTION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        local applied,reason=self.completedObstructionResponsibilityTransition:transition(picture,evaluated,dispatch)
        if applied==nil then
            return {status="NO_DISPATCH",reason="D0147_COMMITMENT_APPLICATION_FAILED",detail=reason,candidateId=dispatch.candidateId,terminalEgress=true}
        end
        local continued=self.liveControlDispatcher:continueCompletedObstruction(picture,evaluated,applied)
        continued.currentResponsibility=applied.currentResponsibility
        return continued
    end
    return dispatch
end

function Runtime:processLiveObservation(raw)
    local processed=self:processSealedObservation(raw)
    local supported=self.terminalEgressCandidateSupport:attach(processed.picture,processed.snapshot)
    if supported==nil then supported=self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot) end
    local evaluated=self:evaluateSealedOperationalPicture(supported)
    local boundary=supported.candidateSupportEvidence and supported.candidateSupportEvidence.supportBoundary or nil
    if type(boundary)=="table" and (boundary.mode=="TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST" or boundary.mode=="D0146_COOPERATIVE_PASSAGE_STEP2_TEST") and #(evaluated.candidates or {})>0 then
        local candidate=evaluated.candidates[1]
        local bridge=candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
        local traceKey=tostring(bridge and (bridge.encounterIdentity or bridge.pairReferenceKey) or candidate.identity)
        if self.cooperativeVerdictTraceKey~=traceKey then
            self.cooperativeVerdictTraceKey=traceKey
            local summary={}
            for _,verdict in OuttaMyWay.ValueRecord.ipairs(evaluated.verdicts or {}) do
                if verdict.candidateId==candidate.identity then summary[#summary+1]=tostring(verdict.constraintId).."="..tostring(verdict.result) end
            end
            table.sort(summary)
            cooperativeLog("COOPERATIVE_CONSTRAINT_VERDICT encounter=%s candidate=%s decision=%s selected=%s verdicts=%s",
                tostring(bridge and bridge.encounterIdentity or "n/a"),tostring(candidate.identity),tostring(evaluated.decision and evaluated.decision.identity or "n/a"),
                tostring(evaluated.decision and evaluated.decision.selectedCandidateId==candidate.identity),table.concat(summary,","))
        end
    else
        self.cooperativeVerdictTraceKey=nil
    end
    local dispatch=self:dispatchEvaluatedOperationalPicture(supported,evaluated)
    return {
        snapshot=processed.snapshot,jobEpisodes=processed.jobEpisodes,operation=processed.operation,picture=supported,
        candidateInventory=evaluated.candidateInventory,candidates=evaluated.candidates,verdictSet=evaluated.verdictSet,verdicts=evaluated.verdicts,decision=evaluated.decision,
        controlDispatch=dispatch
    }
end

function Runtime:runReplay(fixture) return self.replayRunner:run(fixture) end
function Runtime:getStatus()
    return {initialized=self.initialized,runtimeMode=self.runtimeMode,controlAuthorityEnabled=self.controlAuthorityEnabled,
        observationCount=self.observationAdapter:getPublishedCount(),jobEpisodeCount=#self.jobEpisodes:list(),operationCount=#self.operations:list(),operationalPictureCount=self.situationAssessment:getPublishedCount(),candidateInventoryCount=self.candidateSpace:getPublishedCount(),constraintVerdictSetCount=self.constraintEngine:getPublishedCount(),decisionCount=self.decisionSelector:getPublishedCount(),commitmentApplicationCount=self.decisionCommitmentBoundary:getPublishedCount(),governingBasisVerdictCount=self.governingBasisEvaluator:getPublishedCount(),replayRunCount=self.replayRunner:getRunCount(),passiveCandidateSupportCount=self.passiveCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportCount=self.liveTrafficCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportStatus=self.liveTrafficCandidateSupport:getLastStatus(),terminalEgressCandidateSupportStatus=self.terminalEgressCandidateSupport:getLastStatus(),terminalEgressCandidateSupportCount=self.terminalEgressCandidateSupport:getPublishedCount(),liveControlDispatchCount=self.liveControlDispatcher:getDispatchCount(),cooperativePassageControlStatus=(self.liveControlDispatcher.cooperativePassageControl and self.liveControlDispatcher.cooperativePassageControl:getStatus() or nil),terminalEgressControlStatus=(self.liveControlDispatcher.terminalEgressControl and self.liveControlDispatcher.terminalEgressControl:getStatus() or nil),liveRuntimeCoordinatorCycleCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getCycleCount() or 0,liveRuntimeCoordinatorErrorCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getErrorCount() or 0,passiveTraceCount=#self.passiveLiveValidator:getRecords(),passiveErrorCount=self.passiveLiveValidator:getErrorCount(),fieldIdentityProbeSampleCount=self.targetedFieldIdentityProbe:getSampleCount(),fieldWorldSnapshotCount=self.fieldWorldSnapshots:getRecordCount(),fieldWorldComparisonCount=self.fieldWorldEquivalenceAuthority:getComparisonRecordCount(),fieldWorldResolutionCount=self.fieldWorldEquivalenceAuthority:getResolutionRecordCount(),activeFieldWorldCount=self.fieldWorldEquivalenceAuthority:getActiveClassCount(),representationCacheRetiredCount=self.assemblyRepresentationCache.retiredCount or 0,activeOperationCount=#self.operations:listActive(),encounterCount=#self.encounters:list(),activeEncounterCount=#self.encounters:listActive(),commitmentCount=#self.commitments:list(),traceCount=self.trace:count()}
end
