# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not document source behaviour exhaustively, replace the source itself, preserve implementation chronology, or grant architectural authority.

```text
Architecture
    → what responsibilities should exist

Implementation Map
    → where those responsibilities currently appear

Source
    → exactly how they are implemented
```

This is a concise map of principal placement, not a module or function manual.

## Composition and principal responsibility placement

| Architectural responsibility | Principal current source placement |
|---|---|
| Runtime entrypoint | [`modDesc.xml`](../modDesc.xml) → [`scripts/main.lua`](../scripts/main.lua) |
| Global Runtime and Local Operation lifecycle | [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua), [`scripts/runtime/LiveRuntimeCoordinator.lua`](../scripts/runtime/LiveRuntimeCoordinator.lua), [`scripts/identity/OperationAdmission.lua`](../scripts/identity/OperationAdmission.lua) |
| Job Episode admission | [`scripts/identity/JobEpisodeAdmission.lua`](../scripts/identity/JobEpisodeAdmission.lua) |
| Field World Snapshot, Equivalence and Operation admission | [`scripts/identity/FieldWorldSnapshotRegistry.lua`](../scripts/identity/FieldWorldSnapshotRegistry.lua), [`scripts/identity/FieldWorldEquivalenceAuthority.lua`](../scripts/identity/FieldWorldEquivalenceAuthority.lua), [`scripts/identity/FieldWorldEquivalenceEvaluator.lua`](../scripts/identity/FieldWorldEquivalenceEvaluator.lua), [`scripts/identity/OperationAdmission.lua`](../scripts/identity/OperationAdmission.lua) |
| Observation | [`scripts/observation/`](../scripts/observation/) and [`scripts/observation/LiveObservationSource.lua`](../scripts/observation/LiveObservationSource.lua) |
| Situation Assessment | [`scripts/assessment/SituationAssessment.lua`](../scripts/assessment/SituationAssessment.lua) and focused collaborators in [`scripts/assessment/`](../scripts/assessment/) |
| Candidate, Constraint and Decision boundary | [`scripts/candidates/`](../scripts/candidates/), [`scripts/constraints/`](../scripts/constraints/), [`scripts/decision/`](../scripts/decision/), and [`scripts/commitment/DecisionCommitmentBoundary.lua`](../scripts/commitment/DecisionCommitmentBoundary.lua) |
| Commitment, Obligation and Bounded Authority | [`scripts/commitment/`](../scripts/commitment/) and [`scripts/authority/`](../scripts/authority/) |
| Physical Representation | [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua), [`scripts/representation/PlanViewFootprint.lua`](../scripts/representation/PlanViewFootprint.lua), and [`scripts/representation/PairSpecificPassageClearance.lua`](../scripts/representation/PairSpecificPassageClearance.lua) |
| Passage capability and planning | [`scripts/assessment/PassageCapabilityAssessment.lua`](../scripts/assessment/PassageCapabilityAssessment.lua) and [`scripts/candidates/LocalPassagePlanner.lua`](../scripts/candidates/LocalPassagePlanner.lua) |
| Control dispatch and Cooperative Passage | [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) and [`scripts/control/CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua) |
| Completed-obstruction and terminal control still loaded by the runtime | [`scripts/assessment/TerminalOccupancyAssessment.lua`](../scripts/assessment/TerminalOccupancyAssessment.lua), [`scripts/candidates/TerminalEgressCandidateSupport.lua`](../scripts/candidates/TerminalEgressCandidateSupport.lua), [`scripts/commitment/TerminalEgressCommitmentLifecycle.lua`](../scripts/commitment/TerminalEgressCommitmentLifecycle.lua), and [`scripts/control/TerminalEgressControl.lua`](../scripts/control/TerminalEgressControl.lua) |

## Implementation-alignment observations

Historical names and structures such as `shadow`, `TEST`, D-number and prototype vocabulary, `EncounterRegistry`, `FieldBoundedFutureSpace`, and old diagnostic or probe names remain in parts of the source. Their persistence is implementation placement or vocabulary lag; it does not grant them current architectural authority or show that architecture requires those forms.

Diagnostic and probe existence does not define a first-class architectural responsibility. This documentation increment neither establishes a permanent diagnostic inventory nor authorises probe pruning. Any later implementation alignment or removal requires its own bounded investigation.
