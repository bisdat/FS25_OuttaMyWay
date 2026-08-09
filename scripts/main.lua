-- FS25_OuttaMyWay v4.7.49 CERTIFICATION CANDIDATE; behaviourally identical to the live-PASS v4.7.48 runtime apart from coherent release identity/status metadata.
-- modDesc.xml loads only this file. Historical archived modules are never sourced.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/contracts/ValueRecord.lua","scripts/contracts/ObservationSnapshot.lua","scripts/contracts/OperationalPicture.lua","scripts/contracts/CandidateAction.lua","scripts/contracts/CandidateInventory.lua","scripts/contracts/ConstraintVerdict.lua","scripts/contracts/ConstraintVerdictSet.lua","scripts/contracts/DecisionRecord.lua","scripts/contracts/CommitmentRecord.lua","scripts/contracts/ObligationRecord.lua","scripts/contracts/ControlRequest.lua","scripts/contracts/ControlOutcome.lua","scripts/contracts/ReplayFixture.lua","scripts/contracts/ReplayRunResult.lua","scripts/contracts/GoverningBasisVerdict.lua","scripts/contracts/CommitmentApplicationRecord.lua","scripts/contracts/PassiveLiveTraceRecord.lua",
    "scripts/identity/EpochSequence.lua","scripts/identity/IdentityRegistry.lua",
    "scripts/representation/catalogues/CondorEndurance2Donor.lua","scripts/representation/PlanViewFootprint.lua","scripts/representation/AssemblyRepresentationCache.lua",
    "scripts/diagnostics/LiveInteractionDiagnostics.lua","scripts/observation/LocalIntentObservation.lua","scripts/observation/FieldBoundedFutureSpace.lua","scripts/identity/FieldWorldSnapshotRegistry.lua","scripts/identity/FieldWorldEquivalenceEvaluator.lua","scripts/identity/FieldWorldEquivalenceAuthority.lua","scripts/observation/RuntimeObservationAdapter.lua","scripts/observation/LiveAIJobEvidence.lua","scripts/observation/LiveObservationSource.lua","scripts/identity/JobEpisodeAdmission.lua","scripts/identity/OperationAdmission.lua",
    "scripts/assessment/RepresentationFitness.lua","scripts/assessment/EncounterRegistry.lua","scripts/assessment/SituationAssessment.lua",
    "scripts/commitment/CommitmentStateMachine.lua","scripts/commitment/CommitmentRegistry.lua","scripts/commitment/ObligationLedger.lua","scripts/authority/AuthorityRegistry.lua","scripts/authority/EffectiveActuationComposition.lua","scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua","scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua","scripts/commitment/LiveTrafficCommitmentLifecycle.lua",
    "scripts/candidates/CandidateSpace.lua","scripts/candidates/PassiveLiveCandidateSupport.lua","scripts/candidates/LiveTrafficCandidateSupport.lua","scripts/constraints/ConstraintEvidence.lua",
    "scripts/constraints/evaluators/FieldWorldContainment.lua","scripts/constraints/evaluators/TransitionClearance.lua","scripts/constraints/evaluators/RepresentationFitness.lua","scripts/constraints/evaluators/CapabilityAvailability.lua","scripts/constraints/evaluators/ContinuingIntentPriority.lua","scripts/constraints/evaluators/ProgressPreservation.lua","scripts/constraints/evaluators/ResponsibilityCompatibility.lua","scripts/constraints/evaluators/ObligationCompatibility.lua","scripts/constraints/evaluators/CommitmentPreconditions.lua","scripts/constraints/evaluators/EffectiveActuationComposition.lua","scripts/constraints/evaluators/ReleaseSafety.lua",
    "scripts/constraints/ConstraintEngine.lua","scripts/decision/TrafficPolicemanDecisionPolicy.lua","scripts/decision/DecisionSelector.lua","scripts/diagnostics/ArchitectureTrace.lua","scripts/replay/ConformanceAssertions.lua","scripts/replay/ReplayRunner.lua","scripts/diagnostics/TargetedFieldIdentityProbe.lua","scripts/diagnostics/FutureSpaceHud.lua","scripts/diagnostics/TransitionHud.lua","scripts/diagnostics/PassiveLiveValidator.lua","scripts/diagnostics/ProductiveContinuationProbe.lua","scripts/diagnostics/GuardedRecoveryConvergenceProbe.lua","scripts/prototypes/Prototype22PermissionGate.lua","scripts/prototypes/Prototype22DriveAuthority.lua","scripts/prototypes/GuardedRecoveryRegulationTestBridge.lua","scripts/prototypes/Prototype22ConfigurationAuthority.lua","scripts/prototypes/Prototype22TS015Relocation.lua","scripts/prototypes/Prototype22CapabilityGate.lua","scripts/runtime/Runtime.lua"
}
for _,relativePath in ipairs(modules) do source(modDirectory..relativePath) end
OuttaMyWay.modDirectory=modDirectory; OuttaMyWay.runtime=OuttaMyWay.Runtime.new(); OuttaMyWay.runtime:initialize()
OuttaMyWay.productiveContinuationProbe=OuttaMyWay.ProductiveContinuationProbe.new()
OuttaMyWay.runtime:setProductiveContinuationEvidenceSource(OuttaMyWay.productiveContinuationProbe)
OuttaMyWay.guardedRecoveryConvergenceProbe=OuttaMyWay.GuardedRecoveryConvergenceProbe.new()
OuttaMyWay.guardedRecoveryRegulationTestBridge=OuttaMyWay.GuardedRecoveryRegulationTestBridge.new()
OuttaMyWay.prototype22CapabilityGate=OuttaMyWay.Prototype22CapabilityGate.new(OuttaMyWay.runtime,OuttaMyWay.guardedRecoveryConvergenceProbe,OuttaMyWay.guardedRecoveryRegulationTestBridge)
if type(addModEventListener)=="function" then
    addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)
    addModEventListener(OuttaMyWay.productiveContinuationProbe)
    addModEventListener(OuttaMyWay.prototype22CapabilityGate)
end
