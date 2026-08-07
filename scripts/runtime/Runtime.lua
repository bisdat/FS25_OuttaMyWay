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
    local admission=OuttaMyWay.CommitmentAdmission.new(identities,epochs,commitments,obligations,authorities)
    local governingBasis=OuttaMyWay.GoverningBasisEvaluator.new(identities,epochs)
    local terminalSettlement=OuttaMyWay.TerminalSettlementEvaluator.new(epochs,commitments,obligations,authorities)
    local runtime=setmetatable({
        identities=identities,epochs=epochs,observationAdapter=OuttaMyWay.RuntimeObservationAdapter.new(identities,epochs),jobEpisodes=jobEpisodes,operations=operations,
        commitments=commitments,obligations=obligations,authorities=authorities,commitmentAdmission=admission,governingBasisEvaluator=governingBasis,terminalSettlementEvaluator=terminalSettlement,
        situationAssessment=OuttaMyWay.SituationAssessment.new(identities,epochs,jobEpisodes,operations,commitments),
        candidateSpace=OuttaMyWay.CandidateSpace.new(identities,epochs),constraintEngine=OuttaMyWay.ConstraintEngine.new(identities,epochs),decisionSelector=OuttaMyWay.DecisionSelector.new(identities,epochs),
        targetedFieldIdentityProbe=OuttaMyWay.TargetedFieldIdentityProbe.new(),fieldWorldSnapshots=fieldWorldSnapshots,fieldWorldEquivalenceEvaluator=fieldWorldEquivalenceEvaluator,fieldWorldEquivalenceAuthority=fieldWorldEquivalenceAuthority,assemblyRepresentationCache=assemblyRepresentationCache,passiveCandidateSupport=OuttaMyWay.PassiveLiveCandidateSupport.new(identities,epochs),
        trace=OuttaMyWay.ArchitectureTrace.new(),initialized=false,runtimeMode=OuttaMyWay.RUNTIME_MODE,controlAuthorityEnabled=false
    },Runtime)
    runtime.liveObservationSource=OuttaMyWay.LiveObservationSource.new(runtime.fieldWorldSnapshots,runtime.fieldWorldEquivalenceAuthority,runtime.assemblyRepresentationCache)
    runtime.decisionCommitmentBoundary=OuttaMyWay.DecisionCommitmentBoundary.new(identities,epochs,admission,commitments,obligations,authorities,governingBasis,terminalSettlement)
    runtime.replayRunner=OuttaMyWay.ReplayRunner.new(runtime)
    runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime,runtime.liveObservationSource,runtime.passiveCandidateSupport,runtime.targetedFieldIdentityProbe,runtime.fieldWorldSnapshots)
    return runtime
end
function Runtime:initialize()
    if self.initialized then return end; self.initialized=true
    self.trace:append("CONFIGURATION_FILTERED_PLAN_VIEW_REPRESENTATION_SHADOW_INITIALIZED",self.epochs:next(),"architecture="..OuttaMyWay.ARCHITECTURE_VERSION..";predicatesChanged=false;control=false")
    print(string.format("FS25_OuttaMyWay v%s configuration-filtered plan-view representation shadow loaded; inactive shop geometry excluded; predicates unchanged; Control authority disabled",OuttaMyWay.VERSION))
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
function Runtime:runReplay(fixture) return self.replayRunner:run(fixture) end
function Runtime:getStatus()
    return {initialized=self.initialized,runtimeMode=self.runtimeMode,controlAuthorityEnabled=self.controlAuthorityEnabled,
        observationCount=self.observationAdapter:getPublishedCount(),jobEpisodeCount=#self.jobEpisodes:list(),operationCount=#self.operations:list(),operationalPictureCount=self.situationAssessment:getPublishedCount(),candidateInventoryCount=self.candidateSpace:getPublishedCount(),constraintVerdictSetCount=self.constraintEngine:getPublishedCount(),decisionCount=self.decisionSelector:getPublishedCount(),commitmentApplicationCount=self.decisionCommitmentBoundary:getPublishedCount(),governingBasisVerdictCount=self.governingBasisEvaluator:getPublishedCount(),replayRunCount=self.replayRunner:getRunCount(),passiveCandidateSupportCount=self.passiveCandidateSupport:getPublishedCount(),passiveTraceCount=#self.passiveLiveValidator:getRecords(),passiveErrorCount=self.passiveLiveValidator:getErrorCount(),fieldIdentityProbeSampleCount=self.targetedFieldIdentityProbe:getSampleCount(),fieldWorldSnapshotCount=self.fieldWorldSnapshots:getRecordCount(),fieldWorldComparisonCount=self.fieldWorldEquivalenceAuthority:getComparisonRecordCount(),fieldWorldResolutionCount=self.fieldWorldEquivalenceAuthority:getResolutionRecordCount(),activeFieldWorldCount=self.fieldWorldEquivalenceAuthority:getActiveClassCount(),representationCacheRetiredCount=self.assemblyRepresentationCache.retiredCount or 0,activeOperationCount=#self.operations:listActive(),commitmentCount=#self.commitments:list(),traceCount=self.trace:count()}
end
