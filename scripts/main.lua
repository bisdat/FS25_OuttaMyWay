-- FS25_OuttaMyWay v0.3.0.36 TEST — PRODUCTION VOCABULARY SEMANTIC CLOSURE.
-- modDesc.xml loads only this file. Retired implementation is preserved by repository history, not shipped runtime source.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/contracts/ValueRecord.lua","scripts/contracts/ObservationSnapshot.lua","scripts/contracts/OperationalPicture.lua","scripts/contracts/CandidateAction.lua","scripts/contracts/CandidateInventory.lua","scripts/contracts/ConstraintVerdict.lua","scripts/contracts/ConstraintVerdictSet.lua","scripts/contracts/DecisionRecord.lua","scripts/contracts/CommitmentRecord.lua","scripts/contracts/ObligationRecord.lua","scripts/contracts/Regulation.lua","scripts/contracts/ResolutionCommitment.lua","scripts/contracts/BoundedAuthorityGrant.lua","scripts/contracts/ControlRequest.lua","scripts/contracts/ControlOutcome.lua","scripts/contracts/ReplayFixture.lua","scripts/contracts/ReplayRunResult.lua","scripts/contracts/GoverningBasisVerdict.lua","scripts/contracts/CommitmentApplicationRecord.lua","scripts/contracts/PassiveLiveTraceRecord.lua",
    "scripts/identity/EpochSequence.lua","scripts/identity/IdentityRegistry.lua",
    "scripts/representation/catalogues/CondorEndurance2Donor.lua","scripts/representation/PlanViewFootprint.lua","scripts/representation/AssemblyRepresentationCache.lua","scripts/representation/CurrentPhysicalConflictRepresentation.lua","scripts/representation/PairSpecificPassageClearance.lua",
    "scripts/observation/LiveInteractionObservation.lua","scripts/observation/LocalIntentObservation.lua","scripts/observation/FieldBoundedFutureSpace.lua","scripts/observation/NativeFieldWorkObservation.lua","scripts/identity/FieldWorldSnapshotRegistry.lua","scripts/identity/FieldWorldEquivalenceEvaluator.lua","scripts/identity/FieldWorldEquivalenceAuthority.lua","scripts/observation/RuntimeObservationAdapter.lua","scripts/observation/LiveAIJobEvidence.lua","scripts/observation/CurrentPhysicalAssemblySource.lua","scripts/observation/CurrentPhysicalPoseSource.lua","scripts/observation/LiveObservationSource.lua","scripts/identity/JobEpisodeAdmission.lua","scripts/identity/OperationAdmission.lua",
    "scripts/assessment/RepresentationFitness.lua","scripts/assessment/EncounterRegistry.lua","scripts/assessment/ProgressionGeometry.lua","scripts/assessment/GuardedRecoveryThreatAssessment.lua","scripts/assessment/FollowerBoundaryDemandAssessment.lua","scripts/assessment/TrajectoryConflictAssessment.lua","scripts/assessment/PassageCapabilityAssessment.lua","scripts/assessment/CausalObstructionAssessment.lua","scripts/assessment/TerminalOccupancyAssessment.lua","scripts/assessment/SpatialConstraintAssessment.lua","scripts/assessment/CurrentResponsibilityAssessment.lua","scripts/assessment/SituationAssessment.lua",
    "scripts/commitment/CommitmentStateMachine.lua","scripts/commitment/CommitmentRegistry.lua","scripts/commitment/ObligationLedger.lua","scripts/authority/AuthorityRegistry.lua","scripts/control/mechanisms/NonJobActuationMechanism.lua","scripts/authority/EffectiveActuationComposition.lua","scripts/authority/BoundedAuthority.lua","scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua","scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua","scripts/commitment/LiveTrafficCommitmentLifecycle.lua","scripts/commitment/TerminalEgressCommitmentLifecycle.lua","scripts/commitment/ObstructionRelocationCommitmentLifecycle.lua","scripts/responsibility/ResolutionCommitmentAdapter.lua","scripts/responsibility/ResponsibilityTransitionAuthority.lua","scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua","scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua","scripts/responsibility/CooperativePassageResponsibilityTransition.lua","scripts/responsibility/CompletedObstructionResponsibilityTransition.lua","scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua",
    "scripts/candidates/CandidateSpace.lua","scripts/candidates/PassiveLiveCandidateSupport.lua","scripts/candidates/LocalPassagePlanner.lua","scripts/candidates/TerminalEgressCandidateSupport.lua","scripts/candidates/ObstructionRelocationCandidateSupport.lua","scripts/candidates/LiveTrafficCandidateSupport.lua","scripts/decision/ProspectivePortfolioDecisionPolicy.lua","scripts/candidates/ProspectiveDecisionPortfolioSupport.lua","scripts/constraints/ConstraintEvidence.lua",
    "scripts/constraints/evaluators/RepresentationFitness.lua","scripts/constraints/evaluators/ResponsibilityCompatibility.lua","scripts/constraints/evaluators/CommitmentPreconditions.lua","scripts/constraints/evaluators/EffectiveActuationComposition.lua",
    "scripts/constraints/ConstraintEngine.lua","scripts/decision/TrafficPolicemanDecisionPolicy.lua","scripts/decision/DecisionSelector.lua","scripts/diagnostics/ArchitectureTrace.lua","scripts/replay/ConformanceAssertions.lua","scripts/replay/ReplayRunner.lua","scripts/diagnostics/TargetedFieldIdentityProbe.lua","scripts/diagnostics/FutureSpaceHud.lua","scripts/diagnostics/TransitionHud.lua","scripts/diagnostics/PassiveLiveValidator.lua","scripts/diagnostics/ProductiveContinuationProbe.lua","scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua","scripts/diagnostics/GuardedRecoveryConvergenceProbe.lua","scripts/observation/NativeManoeuvreObservationSource.lua","scripts/diagnostics/FollowerMaturationCompressionProbe.lua","scripts/diagnostics/ProgressionPreservationProbe.lua","scripts/diagnostics/VersionHud.lua","scripts/diagnostics/FollowerPacingHud.lua","scripts/control/mechanisms/FieldWorkHoldMechanism.lua","scripts/control/mechanisms/NativeDriveMechanism.lua","scripts/control/mechanisms/TransitConfigurationMechanism.lua","scripts/control/CooperativePassageControl.lua","scripts/control/TerminalEgressControl.lua","scripts/authority/ResolutionSpaceProgressionEnvelope.lua","scripts/authority/RegulationBoundedAuthority.lua","scripts/control/GuardedRecoveryCompatibility.lua","scripts/control/RegulationControl.lua","scripts/control/LiveControlDispatcher.lua","scripts/runtime/LiveRuntimeCoordinator.lua","scripts/runtime/Runtime.lua"
}
for _,relativePath in ipairs(modules) do source(modDirectory..relativePath) end
OuttaMyWay.modDirectory=modDirectory
OuttaMyWay.runtime=OuttaMyWay.Runtime.new(); OuttaMyWay.runtime:initialize()

-- Diagnostics consume Situation-owned Knowledge; no diagnostic object supplies
-- semantic evidence to Candidate/Decision/Control.
-- D-0144: chessboard/Productive-Coverage/Refuge-qualification diagnostics are intentionally
-- unsourced from the live runtime. Their files remain historical evidence only.
OuttaMyWay.productiveContinuationProbe=OuttaMyWay.ProductiveContinuationProbe.new(OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.nativeFieldWorkerDriveCommandProbe=OuttaMyWay.NativeFieldWorkerDriveCommandProbe.new(OuttaMyWay.runtime,OuttaMyWay.runtime.situationAssessment)

OuttaMyWay.guardedRecoveryConvergenceProbe=OuttaMyWay.GuardedRecoveryConvergenceProbe.new(OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.nativeManoeuvreObservationSource=OuttaMyWay.NativeManoeuvreObservationSource.new(OuttaMyWay.runtime)
OuttaMyWay.followerMaturationCompressionProbe=OuttaMyWay.FollowerMaturationCompressionProbe.new(OuttaMyWay.runtime,OuttaMyWay.nativeManoeuvreObservationSource,OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.progressionPreservationProbe=OuttaMyWay.ProgressionPreservationProbe.new(OuttaMyWay.runtime,OuttaMyWay.nativeManoeuvreObservationSource)
OuttaMyWay.runtime.passiveLiveValidator:setProgressionPreservationProbe(OuttaMyWay.progressionPreservationProbe)
OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()
OuttaMyWay.followerPacingHud=OuttaMyWay.FollowerPacingHud.new(OuttaMyWay.runtime.regulationBoundedAuthority,OuttaMyWay.followerMaturationCompressionProbe)

OuttaMyWay.physicalControlMechanisms={
    holdMechanism=OuttaMyWay.FieldWorkHoldMechanism.new(),
    driveMechanism=OuttaMyWay.NativeDriveMechanism.new(),
    configurationMechanism=OuttaMyWay.TransitConfigurationMechanism.new()
}
OuttaMyWay.regulationControl=OuttaMyWay.RegulationControl.new(OuttaMyWay.runtime,OuttaMyWay.physicalControlMechanisms.driveMechanism)
OuttaMyWay.runtime:setRegulationControl(OuttaMyWay.regulationControl)
OuttaMyWay.nativeManoeuvreObservationSource:setRegulationControlObservationSource(OuttaMyWay.regulationControl)

-- Production Cooperative Passage consumes the production physical mechanisms directly.
-- No prototype owns or installs those shared mechanisms.
OuttaMyWay.cooperativePassageControl=OuttaMyWay.CooperativePassageControl.new(OuttaMyWay.runtime,OuttaMyWay.physicalControlMechanisms)
OuttaMyWay.runtime:setCooperativePassageControl(OuttaMyWay.cooperativePassageControl)

-- Completed Obstruction and current Causal Obstruction retain distinct upstream
-- authority/lifecycle semantics but share one provenance-neutral physical Terminal Egress executor.
OuttaMyWay.terminalEgressControl=OuttaMyWay.TerminalEgressControl.new(OuttaMyWay.runtime,OuttaMyWay.runtime.liveObservationSource)
OuttaMyWay.runtime:setTerminalEgressControl(OuttaMyWay.terminalEgressControl)

OuttaMyWay.liveRuntimeCoordinator=OuttaMyWay.LiveRuntimeCoordinator.new(OuttaMyWay.runtime,OuttaMyWay.runtime.liveObservationSource,OuttaMyWay.runtime.targetedFieldIdentityProbe,OuttaMyWay.runtime.fieldWorldSnapshots,OuttaMyWay.runtime.passiveLiveValidator)
OuttaMyWay.runtime.liveRuntimeCoordinator=OuttaMyWay.liveRuntimeCoordinator

if type(addModEventListener)=="function" then
    -- Runtime capture/process/dispatch is causally upstream of diagnostics.
    addModEventListener(OuttaMyWay.liveRuntimeCoordinator)
    addModEventListener(OuttaMyWay.productiveContinuationProbe)
    addModEventListener(OuttaMyWay.nativeFieldWorkerDriveCommandProbe)
    addModEventListener(OuttaMyWay.nativeManoeuvreObservationSource)
    addModEventListener(OuttaMyWay.followerMaturationCompressionProbe)
    addModEventListener(OuttaMyWay.regulationControl)
    addModEventListener(OuttaMyWay.cooperativePassageControl)
    addModEventListener(OuttaMyWay.terminalEgressControl)
    addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.followerPacingHud)
end
