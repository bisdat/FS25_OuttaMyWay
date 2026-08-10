OuttaMyWay.Runtime = {}
local Runtime = OuttaMyWay.Runtime
Runtime.__index = Runtime

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
    local runtime=setmetatable({
        identities=identities,epochs=epochs,observationAdapter=OuttaMyWay.RuntimeObservationAdapter.new(identities,epochs),jobEpisodes=jobEpisodes,operations=operations,
        commitments=commitments,obligations=obligations,authorities=authorities,commitmentAdmission=admission,governingBasisEvaluator=governingBasis,terminalSettlementEvaluator=terminalSettlement,
        encounters=encounters,situationAssessment=OuttaMyWay.SituationAssessment.new(identities,epochs,jobEpisodes,operations,encounters,commitments,obligations),
        candidateSpace=OuttaMyWay.CandidateSpace.new(identities,epochs),constraintEngine=OuttaMyWay.ConstraintEngine.new(identities,epochs),decisionSelector=OuttaMyWay.DecisionSelector.new(identities,epochs),
        targetedFieldIdentityProbe=OuttaMyWay.TargetedFieldIdentityProbe.new(),fieldWorldSnapshots=fieldWorldSnapshots,fieldWorldEquivalenceEvaluator=fieldWorldEquivalenceEvaluator,fieldWorldEquivalenceAuthority=fieldWorldEquivalenceAuthority,assemblyRepresentationCache=assemblyRepresentationCache,passiveCandidateSupport=OuttaMyWay.PassiveLiveCandidateSupport.new(identities,epochs),
        trace=OuttaMyWay.ArchitectureTrace.new(),initialized=false,runtimeMode=OuttaMyWay.RUNTIME_MODE,controlAuthorityEnabled=false,generalControlAuthorityEnabled=false
    },Runtime)
    runtime.liveObservationSource=OuttaMyWay.LiveObservationSource.new(runtime.fieldWorldSnapshots,runtime.fieldWorldEquivalenceAuthority,runtime.assemblyRepresentationCache)
    runtime.liveTrafficCandidateSupport=OuttaMyWay.LiveTrafficCandidateSupport.new(identities,epochs,runtime.passiveCandidateSupport)
    runtime.liveControlDispatcher=OuttaMyWay.LiveControlDispatcher.new(runtime)
    runtime.decisionCommitmentBoundary=OuttaMyWay.DecisionCommitmentBoundary.new(identities,epochs,admission,commitments,obligations,authorities,governingBasis,terminalSettlement)
    runtime.replayRunner=OuttaMyWay.ReplayRunner.new(runtime)
    runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime)
    return runtime
end
function Runtime:initialize()
    if self.initialized then return end; self.initialized=true
    self.trace:append("ARCHITECTURE_AUTHORITY_ALIGNMENT_INITIALIZED",self.epochs:next(),"architecture="..OuttaMyWay.ARCHITECTURE_VERSION..";d0140AuthorityReset=true;d0141AlignedFollowerBoundary=true;runtimeOwnedCycle=true;situationOwnsProductiveKnowledge=true;currentAdjacentFollowingKnowledge=true;provisionalDemandSeed=true;historicalNativeManoeuvreBoundaryDemandFitness=UNRESOLVED;stickyPurposeElasticMagnitude=true;committedTransitionControlShadow=true;d0123CentralControl=true;diagnosticsAuthority=false;generalControl=false;boundedP22Control=true")
    print(string.format("FS25_OuttaMyWay v%s CANONICAL CANDIDATE loaded; D-0140 Architecture Authority Alignment loaded and retained; D-0141 aligned follower Regulation retained; functional traffic/Commitment/Control logic retained from live-validated v4.7.75 TEST BUILD; owner-declared v4.7.49 remains canonical pending explicit declaration; live reassessment=250ms; active 0.90 clearance factor retained only after Regulation is otherwise required; positive head-on supersedes follower PRESERVE; same-Commitment supporting authority may succeed to Yield/REPOSITION; outbound-egress lease freeze and Progress Passage retirement retained; D-0123 composition retained; D-0131/D-0133 shadow; D-0134/D-0136/D-0138 passive; D-0137 falsified; diagnostics have no authority; general production Control authority disabled",OuttaMyWay.VERSION))
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
function Runtime:publishObservation(raw) return self.observationAdapter:publish(raw) end
function Runtime:admitJobEpisodes(snapshot) return self.jobEpisodes:observe(snapshot) end
function Runtime:admitOperation(snapshot,episodeResult) return self.operations:observe(snapshot,episodeResult) end
function Runtime:assessOperationalPicture(snapshot,episodeResult,operationResult) return self.situationAssessment:assess(snapshot,episodeResult,operationResult) end
function Runtime:processSealedObservation(raw)
    local snapshot=self:publishObservation(raw)
    local episodes=self:admitJobEpisodes(snapshot)
    local operation=self:admitOperation(snapshot,episodes)
    local picture=self:assessOperationalPicture(snapshot,episodes,operation)
    return {snapshot=snapshot,jobEpisodes=episodes,operation=operation,picture=picture}
end
function Runtime:evaluateSealedOperationalPicture(picture)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    local candidates=self.candidateSpace:generate(picture)
    local verdicts=self.constraintEngine:evaluate(picture,candidates)
    local decision=self.decisionSelector:select(picture,candidates,verdicts)
    return {picture=picture,candidateInventory=candidates.inventory,candidates=candidates.candidates,verdictSet=verdicts.set,verdicts=verdicts.verdicts,decision=decision}
end

function Runtime:processLiveObservation(raw)
    local processed=self:processSealedObservation(raw)
    local supported=self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot)
    local evaluated=self:evaluateSealedOperationalPicture(supported)
    local dispatch=self.liveControlDispatcher:dispatch(supported,evaluated)
    return {
        snapshot=processed.snapshot,jobEpisodes=processed.jobEpisodes,operation=processed.operation,picture=supported,
        candidateInventory=evaluated.candidateInventory,candidates=evaluated.candidates,verdictSet=evaluated.verdictSet,verdicts=evaluated.verdicts,decision=evaluated.decision,
        controlDispatch=dispatch
    }
end

function Runtime:runReplay(fixture) return self.replayRunner:run(fixture) end
function Runtime:getStatus()
    return {initialized=self.initialized,runtimeMode=self.runtimeMode,controlAuthorityEnabled=self.controlAuthorityEnabled,
        observationCount=self.observationAdapter:getPublishedCount(),jobEpisodeCount=#self.jobEpisodes:list(),operationCount=#self.operations:list(),operationalPictureCount=self.situationAssessment:getPublishedCount(),candidateInventoryCount=self.candidateSpace:getPublishedCount(),constraintVerdictSetCount=self.constraintEngine:getPublishedCount(),decisionCount=self.decisionSelector:getPublishedCount(),commitmentApplicationCount=self.decisionCommitmentBoundary:getPublishedCount(),governingBasisVerdictCount=self.governingBasisEvaluator:getPublishedCount(),replayRunCount=self.replayRunner:getRunCount(),passiveCandidateSupportCount=self.passiveCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportCount=self.liveTrafficCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportStatus=self.liveTrafficCandidateSupport:getLastStatus(),liveControlDispatchCount=self.liveControlDispatcher:getDispatchCount(),liveRuntimeCoordinatorCycleCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getCycleCount() or 0,liveRuntimeCoordinatorErrorCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getErrorCount() or 0,passiveTraceCount=#self.passiveLiveValidator:getRecords(),passiveErrorCount=self.passiveLiveValidator:getErrorCount(),fieldIdentityProbeSampleCount=self.targetedFieldIdentityProbe:getSampleCount(),fieldWorldSnapshotCount=self.fieldWorldSnapshots:getRecordCount(),fieldWorldComparisonCount=self.fieldWorldEquivalenceAuthority:getComparisonRecordCount(),fieldWorldResolutionCount=self.fieldWorldEquivalenceAuthority:getResolutionRecordCount(),activeFieldWorldCount=self.fieldWorldEquivalenceAuthority:getActiveClassCount(),representationCacheRetiredCount=self.assemblyRepresentationCache.retiredCount or 0,activeOperationCount=#self.operations:listActive(),encounterCount=#self.encounters:list(),activeEncounterCount=#self.encounters:listActive(),commitmentCount=#self.commitments:list(),traceCount=self.trace:count()}
end
