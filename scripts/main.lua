-- FS25_OuttaMyWay v0.3.0.0 CANONICAL CANDIDATE — Spatial Negotiation Operating Model.
-- modDesc.xml loads only this file. Retired implementation is preserved by repository history, not shipped runtime source.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/contracts/ValueRecord.lua","scripts/contracts/ObservationSnapshot.lua","scripts/contracts/OperationalPicture.lua","scripts/contracts/CandidateAction.lua","scripts/contracts/CandidateInventory.lua","scripts/contracts/ConstraintVerdict.lua","scripts/contracts/ConstraintVerdictSet.lua","scripts/contracts/DecisionRecord.lua","scripts/contracts/CommitmentRecord.lua","scripts/contracts/ObligationRecord.lua","scripts/contracts/ControlRequest.lua","scripts/contracts/ControlOutcome.lua","scripts/contracts/ReplayFixture.lua","scripts/contracts/ReplayRunResult.lua","scripts/contracts/GoverningBasisVerdict.lua","scripts/contracts/CommitmentApplicationRecord.lua","scripts/contracts/PassiveLiveTraceRecord.lua",
    "scripts/identity/EpochSequence.lua","scripts/identity/IdentityRegistry.lua",
    "scripts/representation/catalogues/CondorEndurance2Donor.lua","scripts/representation/PlanViewFootprint.lua","scripts/representation/AssemblyRepresentationCache.lua","scripts/representation/PairSpecificPassageClearance.lua",
    "scripts/diagnostics/LiveInteractionDiagnostics.lua","scripts/observation/LocalIntentObservation.lua","scripts/observation/FieldBoundedFutureSpace.lua","scripts/observation/NativeFieldWorkObservation.lua","scripts/identity/FieldWorldSnapshotRegistry.lua","scripts/identity/FieldWorldEquivalenceEvaluator.lua","scripts/identity/FieldWorldEquivalenceAuthority.lua","scripts/observation/RuntimeObservationAdapter.lua","scripts/observation/LiveAIJobEvidence.lua","scripts/observation/LiveObservationSource.lua","scripts/identity/JobEpisodeAdmission.lua","scripts/identity/OperationAdmission.lua",
    "scripts/assessment/RepresentationFitness.lua","scripts/assessment/EncounterRegistry.lua","scripts/assessment/ProgressionGeometry.lua","scripts/assessment/GuardedRecoveryThreatAssessment.lua","scripts/assessment/FollowerBoundaryDemandAssessment.lua","scripts/assessment/TrajectoryConflictAssessment.lua","scripts/assessment/PassageCapabilityAssessment.lua","scripts/assessment/TerminalOccupancyAssessment.lua","scripts/assessment/SituationAssessment.lua",
    "scripts/commitment/CommitmentStateMachine.lua","scripts/commitment/CommitmentRegistry.lua","scripts/commitment/ObligationLedger.lua","scripts/authority/AuthorityRegistry.lua","scripts/authority/PostJobActuationAuthority.lua","scripts/authority/EffectiveActuationComposition.lua","scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua","scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua","scripts/commitment/LiveTrafficCommitmentLifecycle.lua","scripts/commitment/TerminalEgressCommitmentLifecycle.lua",
    "scripts/candidates/CandidateSpace.lua","scripts/candidates/PassiveLiveCandidateSupport.lua","scripts/candidates/LocalPassagePlanner.lua","scripts/candidates/TerminalEgressCandidateSupport.lua","scripts/candidates/LiveTrafficCandidateSupport.lua","scripts/constraints/ConstraintEvidence.lua",
    "scripts/constraints/evaluators/FieldWorldContainment.lua","scripts/constraints/evaluators/TransitionClearance.lua","scripts/constraints/evaluators/RepresentationFitness.lua","scripts/constraints/evaluators/CapabilityAvailability.lua","scripts/constraints/evaluators/ContinuingIntentPriority.lua","scripts/constraints/evaluators/ProgressPreservation.lua","scripts/constraints/evaluators/ResponsibilityCompatibility.lua","scripts/constraints/evaluators/ObligationCompatibility.lua","scripts/constraints/evaluators/CommitmentPreconditions.lua","scripts/constraints/evaluators/EffectiveActuationComposition.lua","scripts/constraints/evaluators/ReleaseSafety.lua",
    "scripts/constraints/ConstraintEngine.lua","scripts/decision/TrafficPolicemanDecisionPolicy.lua","scripts/decision/DecisionSelector.lua","scripts/diagnostics/ArchitectureTrace.lua","scripts/replay/ConformanceAssertions.lua","scripts/replay/ReplayRunner.lua","scripts/diagnostics/TargetedFieldIdentityProbe.lua","scripts/diagnostics/FutureSpaceHud.lua","scripts/diagnostics/TransitionHud.lua","scripts/diagnostics/PassiveLiveValidator.lua","scripts/diagnostics/ProductiveContinuationProbe.lua","scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua","scripts/diagnostics/GuardedRecoveryConvergenceProbe.lua","scripts/observation/NativeManoeuvreObservationSource.lua","scripts/diagnostics/FollowerMaturationCompressionProbe.lua","scripts/diagnostics/ProgressionPreservationProbe.lua","scripts/diagnostics/VersionHud.lua","scripts/diagnostics/FollowerPacingHud.lua","scripts/prototypes/Prototype22PermissionGate.lua","scripts/prototypes/Prototype22DriveAuthority.lua","scripts/prototypes/Prototype22ConfigurationAuthority.lua","scripts/prototypes/Prototype22CapabilityGate.lua","scripts/control/CooperativePassageControl.lua","scripts/control/TerminalEgressControl.lua","scripts/control/ResolutionSpaceProgressionEnvelope.lua","scripts/control/LiveControlDispatcher.lua","scripts/runtime/LiveRuntimeCoordinator.lua","scripts/runtime/Runtime.lua"
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
OuttaMyWay.followerPacingHud=OuttaMyWay.FollowerPacingHud.new(OuttaMyWay.runtime.liveControlDispatcher,OuttaMyWay.followerMaturationCompressionProbe)

OuttaMyWay.prototype22CapabilityGate=OuttaMyWay.Prototype22CapabilityGate.new(OuttaMyWay.runtime)
OuttaMyWay.runtime:setLiveControlCapability(OuttaMyWay.prototype22CapabilityGate)
OuttaMyWay.nativeManoeuvreObservationSource:setCapabilityObservationSource(OuttaMyWay.prototype22CapabilityGate)

-- D-0181: production Cooperative Passage is D-0146 only. Historical D-0143
-- donor modules are not sourced into the live runtime.
OuttaMyWay.cooperativePassageControl=OuttaMyWay.CooperativePassageControl.new(OuttaMyWay.runtime,OuttaMyWay.prototype22CapabilityGate)
OuttaMyWay.runtime.liveControlDispatcher:setCooperativePassageControl(OuttaMyWay.cooperativePassageControl)

-- D-0147 production attempt: direct post-job control is separately bounded by
-- POST_JOB_ACTUATION authority and the config.lua Automatic Terminal Egress switch.
OuttaMyWay.terminalEgressControl=OuttaMyWay.TerminalEgressControl.new(OuttaMyWay.runtime,OuttaMyWay.runtime.liveObservationSource)
OuttaMyWay.runtime.liveControlDispatcher:setTerminalEgressControl(OuttaMyWay.terminalEgressControl)

OuttaMyWay.liveRuntimeCoordinator=OuttaMyWay.LiveRuntimeCoordinator.new(OuttaMyWay.runtime,OuttaMyWay.runtime.liveObservationSource,OuttaMyWay.runtime.targetedFieldIdentityProbe,OuttaMyWay.runtime.fieldWorldSnapshots,OuttaMyWay.runtime.passiveLiveValidator)
OuttaMyWay.runtime.liveRuntimeCoordinator=OuttaMyWay.liveRuntimeCoordinator

if type(addModEventListener)=="function" then
    -- Runtime capture/process/dispatch is causally upstream of diagnostics.
    addModEventListener(OuttaMyWay.liveRuntimeCoordinator)
    addModEventListener(OuttaMyWay.productiveContinuationProbe)
    addModEventListener(OuttaMyWay.nativeFieldWorkerDriveCommandProbe)
    addModEventListener(OuttaMyWay.nativeManoeuvreObservationSource)
    addModEventListener(OuttaMyWay.followerMaturationCompressionProbe)
    addModEventListener(OuttaMyWay.prototype22CapabilityGate)
    addModEventListener(OuttaMyWay.cooperativePassageControl)
    addModEventListener(OuttaMyWay.terminalEgressControl)
    addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.followerPacingHud)
end
