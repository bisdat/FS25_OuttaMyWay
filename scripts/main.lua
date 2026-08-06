-- FS25_OuttaMyWay v4.7.4 replay-conformance entry point.
-- modDesc.xml loads only this file. Historical archived modules are never sourced.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/contracts/ValueRecord.lua","scripts/contracts/ObservationSnapshot.lua","scripts/contracts/OperationalPicture.lua","scripts/contracts/CandidateAction.lua","scripts/contracts/CandidateInventory.lua","scripts/contracts/ConstraintVerdict.lua","scripts/contracts/ConstraintVerdictSet.lua","scripts/contracts/DecisionRecord.lua","scripts/contracts/CommitmentRecord.lua","scripts/contracts/ObligationRecord.lua","scripts/contracts/ControlRequest.lua","scripts/contracts/ControlOutcome.lua","scripts/contracts/ReplayFixture.lua","scripts/contracts/ReplayRunResult.lua","scripts/contracts/GoverningBasisVerdict.lua","scripts/contracts/CommitmentApplicationRecord.lua",
    "scripts/identity/EpochSequence.lua","scripts/identity/IdentityRegistry.lua","scripts/observation/RuntimeObservationAdapter.lua","scripts/identity/JobEpisodeAdmission.lua","scripts/identity/OperationAdmission.lua",
    "scripts/assessment/RepresentationFitness.lua","scripts/assessment/SituationAssessment.lua",
    "scripts/commitment/CommitmentStateMachine.lua","scripts/commitment/CommitmentRegistry.lua","scripts/commitment/ObligationLedger.lua","scripts/authority/AuthorityRegistry.lua","scripts/authority/EffectiveActuationComposition.lua","scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua","scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua",
    "scripts/candidates/CandidateSpace.lua","scripts/constraints/ConstraintEvidence.lua",
    "scripts/constraints/evaluators/FieldWorldContainment.lua","scripts/constraints/evaluators/TransitionClearance.lua","scripts/constraints/evaluators/RepresentationFitness.lua","scripts/constraints/evaluators/CapabilityAvailability.lua","scripts/constraints/evaluators/ContinuingIntentPriority.lua","scripts/constraints/evaluators/ProgressPreservation.lua","scripts/constraints/evaluators/ResponsibilityCompatibility.lua","scripts/constraints/evaluators/ObligationCompatibility.lua","scripts/constraints/evaluators/CommitmentPreconditions.lua","scripts/constraints/evaluators/EffectiveActuationComposition.lua","scripts/constraints/evaluators/ReleaseSafety.lua",
    "scripts/constraints/ConstraintEngine.lua","scripts/decision/DecisionSelector.lua","scripts/diagnostics/ArchitectureTrace.lua","scripts/replay/ConformanceAssertions.lua","scripts/replay/ReplayRunner.lua","scripts/runtime/Runtime.lua"
}
for _,relativePath in ipairs(modules) do source(modDirectory..relativePath) end
OuttaMyWay.modDirectory=modDirectory; OuttaMyWay.runtime=OuttaMyWay.Runtime.new(); OuttaMyWay.runtime:initialize()
