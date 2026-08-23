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
    runtime.replayRunner=OuttaMyWay.ReplayRunner.new(runtime)
    runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime)
    return runtime
end
function Runtime:initialize()
    if self.initialized then return end; self.initialized=true
    self.trace:append("PROGRESSIVE_SITUATIONAL_SUFFICIENCY_INITIALIZED",self.epochs:next(),"architecture="..OuttaMyWay.ARCHITECTURE_VERSION..";d0147TerminalYieldArchitecture=true;d0147BoundedInfieldRetreatImplementation=v4.7.126-60m-native-max-test;automaticTerminalEgress="..tostring(OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true)..";d0146Step1SituationKnowledge=true;trajectoryPersistence=true;opposedCorridorClassification=true;d0146Step2OperationAware=true;d0143CooperativePassage=true;d0143MechanicalDonor=true;d0141FollowerRegulation=true;turningRankAwarenessRetained=true;successorRookRetired=true;continuousProductiveHistoryRetired=true;kingRetired=true;continuousRefugeRetired=true;runtimeOwnedCycle=true;situationOwnsCurrentKnowledge=true;diagnosticsAuthority=false;generalControl=false")
    print(string.format("FS25_OuttaMyWay v%s CANONICAL CANDIDATE loaded; D-0159 Passage Excursion ACTIVE: Passage Selection immediately supersedes Resolution-Space conservation, Passage-owned native Approach continues until the Entry Boundary, actual stopped/configured execution origins rebase the short excursion guide, non-negative Clearance Deficit drives only necessary lateral excursion, directional member-union envelopes generalise Passage width/length for multi-member assemblies with per-member DISC fallback; D-0164 prevents AI-disabled mechanical foldability from suppressing directional member evidence and adds bounded Passage rejection telemetry; D-0165 requires nominal Passage clearance only through the physical Crossing Window while retaining non-contact throughout Development and Recovery; represented longitudinal extents define the Crossing Window, and Recovery returns toward the native lateral axis before existing restoration/reacquisition; no agronomic reverse recovery is implemented in this build; D-0155 Resolution-Space Progression Envelope ACTIVE with provisional 75%% Resolution Contingency Reserve, whole-integer km/h Supportable Progression, 1 km/h unresolved-intent creep floor, continuous Commitment-lifetime magnitude updates, Reverse-Created Resolution Reserve protection and Magnitude Rebase on Role Migration; D-0146 Situation owns obligation/roles while Control owns elastic magnitude; D-0146 Step-1 Situation Knowledge is live-validated and Step-2 Established Conflict -> Candidate-owned Local Passage Search -> Passage Guide -> Commitment/Control is ACTIVE; general production Control authority disabled outside bounded admitted commitments; Control authority disabled outside bounded admitted commitments; D-0146 Cooperative Passage succession remains ACTIVE; v0.1.4.0 Passage geometry/timing retained while Control always attempts Transit compaction at the existing configuration point; failed opportunistic RETAIN_CURRENT attempts are ignored and Candidate-required compaction remains fail-safe; v0.1.4.7 keeps that telemetry and accepts Crossing-Window clearance down to 95%% of the nominal 1 m target while represented non-contact remains hard; v0.1.4.8 keeps required compaction strict while RETAIN_CURRENT Transit attempts wait only for observed physical transition and cannot veto Passage when physically inert; v0.1.5.0 is the no-new-behaviour canonical candidate checkpoint after TS009/TS010/TS010S/TS015/TS016 regression passes, with Zero-Development Entry Compression retained as open observation; inherited 8 km/h guide speed retained; D-0147 Bounded Infield Retreat unchanged; automatic terminal-yield test gate=%s; Player Claim uses vehicle:getIsEntered()",OuttaMyWay.VERSION,tostring(OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true)))
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
        observationCount=self.observationAdapter:getPublishedCount(),jobEpisodeCount=#self.jobEpisodes:list(),operationCount=#self.operations:list(),operationalPictureCount=self.situationAssessment:getPublishedCount(),candidateInventoryCount=self.candidateSpace:getPublishedCount(),constraintVerdictSetCount=self.constraintEngine:getPublishedCount(),decisionCount=self.decisionSelector:getPublishedCount(),commitmentApplicationCount=self.decisionCommitmentBoundary:getPublishedCount(),governingBasisVerdictCount=self.governingBasisEvaluator:getPublishedCount(),replayRunCount=self.replayRunner:getRunCount(),passiveCandidateSupportCount=self.passiveCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportCount=self.liveTrafficCandidateSupport:getPublishedCount(),liveTrafficCandidateSupportStatus=self.liveTrafficCandidateSupport:getLastStatus(),terminalEgressCandidateSupportStatus=self.terminalEgressCandidateSupport:getLastStatus(),terminalEgressCandidateSupportCount=self.terminalEgressCandidateSupport:getPublishedCount(),liveControlDispatchCount=self.liveControlDispatcher:getDispatchCount(),cooperativePassageControlStatus=(self.liveControlDispatcher.cooperativePassageControl and self.liveControlDispatcher.cooperativePassageControl:getStatus() or nil),terminalEgressControlStatus=(self.liveControlDispatcher.terminalEgressControl and self.liveControlDispatcher.terminalEgressControl:getStatus() or nil),liveRuntimeCoordinatorCycleCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getCycleCount() or 0,liveRuntimeCoordinatorErrorCount=self.liveRuntimeCoordinator and self.liveRuntimeCoordinator:getErrorCount() or 0,passiveTraceCount=#self.passiveLiveValidator:getRecords(),passiveErrorCount=self.passiveLiveValidator:getErrorCount(),fieldIdentityProbeSampleCount=self.targetedFieldIdentityProbe:getSampleCount(),fieldWorldSnapshotCount=self.fieldWorldSnapshots:getRecordCount(),fieldWorldComparisonCount=self.fieldWorldEquivalenceAuthority:getComparisonRecordCount(),fieldWorldResolutionCount=self.fieldWorldEquivalenceAuthority:getResolutionRecordCount(),activeFieldWorldCount=self.fieldWorldEquivalenceAuthority:getActiveClassCount(),representationCacheRetiredCount=self.assemblyRepresentationCache.retiredCount or 0,activeOperationCount=#self.operations:listActive(),encounterCount=#self.encounters:list(),activeEncounterCount=#self.encounters:listActive(),commitmentCount=#self.commitments:list(),traceCount=self.trace:count()}
end
