-- FS25_OuttaMyWay v4.7.77 CANONICAL CANDIDATE — D-0142 architecture/documentation consolidation over owner-declared canonical v4.7.76; runtime behaviour intentionally retained.
-- modDesc.xml loads only this file. Historical archived modules are never sourced.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/contracts/ValueRecord.lua","scripts/contracts/ObservationSnapshot.lua","scripts/contracts/OperationalPicture.lua","scripts/contracts/CandidateAction.lua","scripts/contracts/CandidateInventory.lua","scripts/contracts/ConstraintVerdict.lua","scripts/contracts/ConstraintVerdictSet.lua","scripts/contracts/DecisionRecord.lua","scripts/contracts/CommitmentRecord.lua","scripts/contracts/ObligationRecord.lua","scripts/contracts/ControlRequest.lua","scripts/contracts/ControlOutcome.lua","scripts/contracts/ReplayFixture.lua","scripts/contracts/ReplayRunResult.lua","scripts/contracts/GoverningBasisVerdict.lua","scripts/contracts/CommitmentApplicationRecord.lua","scripts/contracts/PassiveLiveTraceRecord.lua",
    "scripts/identity/EpochSequence.lua","scripts/identity/IdentityRegistry.lua",
    "scripts/representation/catalogues/CondorEndurance2Donor.lua","scripts/representation/PlanViewFootprint.lua","scripts/representation/AssemblyRepresentationCache.lua",
    "scripts/diagnostics/LiveInteractionDiagnostics.lua","scripts/observation/LocalIntentObservation.lua","scripts/observation/FieldBoundedFutureSpace.lua","scripts/observation/NativeFieldWorkObservation.lua","scripts/identity/FieldWorldSnapshotRegistry.lua","scripts/identity/FieldWorldEquivalenceEvaluator.lua","scripts/identity/FieldWorldEquivalenceAuthority.lua","scripts/observation/RuntimeObservationAdapter.lua","scripts/observation/LiveAIJobEvidence.lua","scripts/observation/LiveObservationSource.lua","scripts/identity/JobEpisodeAdmission.lua","scripts/identity/OperationAdmission.lua",
    "scripts/assessment/RepresentationFitness.lua","scripts/assessment/EncounterRegistry.lua","scripts/assessment/ProgressionGeometry.lua","scripts/assessment/GuardedRecoveryThreatAssessment.lua","scripts/assessment/FollowerBoundaryDemandAssessment.lua","scripts/assessment/SituationAssessment.lua",
    "scripts/commitment/CommitmentStateMachine.lua","scripts/commitment/CommitmentRegistry.lua","scripts/commitment/ObligationLedger.lua","scripts/authority/AuthorityRegistry.lua","scripts/authority/EffectiveActuationComposition.lua","scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua","scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua","scripts/commitment/LiveTrafficCommitmentLifecycle.lua",
    "scripts/candidates/CandidateSpace.lua","scripts/candidates/PassiveLiveCandidateSupport.lua","scripts/candidates/LiveTrafficCandidateSupport.lua","scripts/constraints/ConstraintEvidence.lua",
    "scripts/constraints/evaluators/FieldWorldContainment.lua","scripts/constraints/evaluators/TransitionClearance.lua","scripts/constraints/evaluators/RepresentationFitness.lua","scripts/constraints/evaluators/CapabilityAvailability.lua","scripts/constraints/evaluators/ContinuingIntentPriority.lua","scripts/constraints/evaluators/ProgressPreservation.lua","scripts/constraints/evaluators/ResponsibilityCompatibility.lua","scripts/constraints/evaluators/ObligationCompatibility.lua","scripts/constraints/evaluators/CommitmentPreconditions.lua","scripts/constraints/evaluators/EffectiveActuationComposition.lua","scripts/constraints/evaluators/ReleaseSafety.lua",
    "scripts/constraints/ConstraintEngine.lua","scripts/decision/TrafficPolicemanDecisionPolicy.lua","scripts/decision/DecisionSelector.lua","scripts/diagnostics/ArchitectureTrace.lua","scripts/replay/ConformanceAssertions.lua","scripts/replay/ReplayRunner.lua","scripts/diagnostics/TargetedFieldIdentityProbe.lua","scripts/diagnostics/FutureSpaceHud.lua","scripts/diagnostics/TransitionHud.lua","scripts/diagnostics/PassiveLiveValidator.lua","scripts/diagnostics/ProductiveContinuationProbe.lua","scripts/diagnostics/DemonstratedProductiveCoverageProbe.lua","scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua","scripts/diagnostics/ProductiveCoverageResidualProbe.lua","scripts/diagnostics/RefugeQualificationShadowProbe.lua","scripts/diagnostics/GuardedRecoveryConvergenceProbe.lua","scripts/observation/NativeManoeuvreObservationSource.lua","scripts/diagnostics/FollowerMaturationCompressionProbe.lua","scripts/diagnostics/ProgressionPreservationProbe.lua","scripts/diagnostics/VersionHud.lua","scripts/diagnostics/FollowerPacingHud.lua","scripts/prototypes/Prototype22PermissionGate.lua","scripts/prototypes/Prototype22DriveAuthority.lua","scripts/prototypes/CommittedTransitionRegulationTestBridge.lua","scripts/prototypes/Prototype22ConfigurationAuthority.lua","scripts/prototypes/Prototype22TS015Relocation.lua","scripts/prototypes/Prototype22CapabilityGate.lua","scripts/control/LiveControlDispatcher.lua","scripts/runtime/LiveRuntimeCoordinator.lua","scripts/runtime/Runtime.lua"
}
for _,relativePath in ipairs(modules) do source(modDirectory..relativePath) end
OuttaMyWay.modDirectory=modDirectory
OuttaMyWay.runtime=OuttaMyWay.Runtime.new(); OuttaMyWay.runtime:initialize()

-- Diagnostics consume Situation-owned Knowledge; no diagnostic object supplies
-- semantic evidence to Candidate/Decision/Control.
OuttaMyWay.productiveContinuationProbe=OuttaMyWay.ProductiveContinuationProbe.new(OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.demonstratedProductiveCoverageProbe=OuttaMyWay.DemonstratedProductiveCoverageProbe.new(OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.nativeFieldWorkerDriveCommandProbe=OuttaMyWay.NativeFieldWorkerDriveCommandProbe.new(OuttaMyWay.runtime,OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.productiveCoverageResidualProbe=OuttaMyWay.ProductiveCoverageResidualProbe.new(OuttaMyWay.runtime,OuttaMyWay.runtime.situationAssessment,OuttaMyWay.demonstratedProductiveCoverageProbe,OuttaMyWay.nativeFieldWorkerDriveCommandProbe)

OuttaMyWay.guardedRecoveryConvergenceProbe=OuttaMyWay.GuardedRecoveryConvergenceProbe.new(OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.nativeManoeuvreObservationSource=OuttaMyWay.NativeManoeuvreObservationSource.new(OuttaMyWay.runtime)
OuttaMyWay.refugeQualificationShadowProbe=OuttaMyWay.RefugeQualificationShadowProbe.new(OuttaMyWay.runtime,OuttaMyWay.demonstratedProductiveCoverageProbe,OuttaMyWay.nativeManoeuvreObservationSource,OuttaMyWay.nativeFieldWorkerDriveCommandProbe)
OuttaMyWay.followerMaturationCompressionProbe=OuttaMyWay.FollowerMaturationCompressionProbe.new(OuttaMyWay.runtime,OuttaMyWay.nativeManoeuvreObservationSource,OuttaMyWay.runtime.situationAssessment)
OuttaMyWay.progressionPreservationProbe=OuttaMyWay.ProgressionPreservationProbe.new(OuttaMyWay.runtime,OuttaMyWay.nativeManoeuvreObservationSource)
OuttaMyWay.runtime.passiveLiveValidator:setProgressionPreservationProbe(OuttaMyWay.progressionPreservationProbe)
OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()
OuttaMyWay.followerPacingHud=OuttaMyWay.FollowerPacingHud.new(OuttaMyWay.runtime.liveControlDispatcher,OuttaMyWay.followerMaturationCompressionProbe)

OuttaMyWay.committedTransitionRegulationTestBridge=OuttaMyWay.CommittedTransitionRegulationTestBridge.new()
OuttaMyWay.prototype22CapabilityGate=OuttaMyWay.Prototype22CapabilityGate.new(OuttaMyWay.runtime,OuttaMyWay.committedTransitionRegulationTestBridge)
OuttaMyWay.runtime:setLiveControlCapability(OuttaMyWay.prototype22CapabilityGate)
OuttaMyWay.nativeManoeuvreObservationSource:setCapabilityObservationSource(OuttaMyWay.prototype22CapabilityGate)

OuttaMyWay.liveRuntimeCoordinator=OuttaMyWay.LiveRuntimeCoordinator.new(OuttaMyWay.runtime,OuttaMyWay.runtime.liveObservationSource,OuttaMyWay.runtime.targetedFieldIdentityProbe,OuttaMyWay.runtime.fieldWorldSnapshots,OuttaMyWay.runtime.passiveLiveValidator)
OuttaMyWay.runtime.liveRuntimeCoordinator=OuttaMyWay.liveRuntimeCoordinator

if type(addModEventListener)=="function" then
    -- Runtime capture/process/dispatch is causally upstream of diagnostics.
    addModEventListener(OuttaMyWay.liveRuntimeCoordinator)
    addModEventListener(OuttaMyWay.productiveContinuationProbe)
    addModEventListener(OuttaMyWay.demonstratedProductiveCoverageProbe)
    addModEventListener(OuttaMyWay.nativeFieldWorkerDriveCommandProbe)
    addModEventListener(OuttaMyWay.productiveCoverageResidualProbe)
    addModEventListener(OuttaMyWay.nativeManoeuvreObservationSource)
    addModEventListener(OuttaMyWay.followerMaturationCompressionProbe)
    addModEventListener(OuttaMyWay.prototype22CapabilityGate)
    -- Selection shadow observes neutral capability fixture publication; it never
    -- sits on the capability call path.
    addModEventListener(OuttaMyWay.refugeQualificationShadowProbe)
    addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.followerPacingHud)
end
