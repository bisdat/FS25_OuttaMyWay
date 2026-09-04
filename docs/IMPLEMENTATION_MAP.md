# Implementation Map

> **Implementation Map** records where accepted architectural responsibilities are presently realised in source and identifies material architecture-to-code placement or vocabulary lag. It does not document source behaviour exhaustively, replace the source itself, preserve implementation chronology, or grant architectural authority.

```text
Architecture       → what responsibilities should exist
Implementation Map → where those responsibilities currently appear
Source             → exactly how they are implemented
```

This is a concise map of principal placement, divergence, transition disposition
and planned migration seams. Architectural meaning remains owned by the
[Runtime Responsibility Architecture](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md),
[Spatial Negotiation Model](architecture/SPATIAL_NEGOTIATION_MODEL.md) and
[Physical Representation Architecture](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md).
The [Configuration architecture](CONFIGURATION.md) and
[Naming Conventions](NAMING_CONVENTIONS.md) remain authoritative for their areas.

# High-Level Strangler Plan

## What the strangler is

OuttaMyWay is not being rewritten from scratch. The strangler progressively
replaces or reconciles runtime areas whose responsibilities no longer match the
accepted architecture while retaining proven behaviour and mechanics:

> **Keep the eyes. Reconcile the brain and spinal cord. Keep the hands.**

- The **eyes** are trusted Reality acquisition, Observation, Field World and Representation.
- The **brain and spinal cord** are the semantic and orchestration path from
  Situation Assessment through responsibility and authority to Control.
- The **hands** are proven physical Control mechanisms.

The aim is incremental convergence toward accepted architecture, not an
all-at-once replacement-core rewrite. Useful current machinery may remain behind
truthful boundaries while responsibility and execution order are reconciled.

## Required behaviour during transition

Ordinary strangler tranches should normally preserve currently accepted
supported behaviour:

- GIANTS continues to own jobs, productive routing, navigation, turning and work.
- Validated Passage, Regulation, handoff and completed-obstruction behaviour
  should remain materially unchanged unless a tranche explicitly changes an
  accepted behaviour.
- Non-migrated behaviour remains on its current implementation path.
- Unrelated geometry, calibration, Configuration and mechanical changes should be avoided.
- Each tranche should move only one bounded responsibility or path.

> At every intermediate state there must be exactly one authoritative owner of each semantic responsibility.

Compatibility adapters may call legacy mechanics. Parallel old and new semantic
authority is not acceptable. This principal transition risk is named **Dual
Transition Authority**.

## How old code is removed

```text
existing behaviour
        ↓
introduce a truthful architectural seam
        ↓
route one existing behaviour through it
        ↓
validate equivalent behaviour
        ↓
make the new route authoritative
        ↓
remove the superseded old authority for that path
        ↓
repeat
```

Old code is not deleted merely because it is historical, badly named or
oversized. It is removed only when:

1. its responsibility has a recognised target owner;
2. the replacement path is authoritative;
3. required invariants and behaviour have been validated; and
4. no supported runtime path still relies on the superseded authority.

Useful algorithms and proven mechanical capabilities should be extracted and
preserved where appropriate rather than rediscovered.

## Principal risks

### Behavioural regression

Ownership moves may disturb hard-won working behaviour. Keep tranches bounded,
preserve proven mechanics, regress against previously validated scenarios and
avoid combining migration with unrelated tuning.

### Dual Transition Authority

Old and new mechanisms may both believe they own the same responsibility. This
is the most serious transition risk. Maintain exactly one semantic owner,
migrate one path at a time and remove old ownership when the new path becomes authoritative.

### Semantic translation error

Legacy Candidate, Decision, generic Commitment and D-number lifecycle concepts
may not map one-to-one onto accepted architecture. Map observed implementation
before moving it, retain `UNRESOLVED` where truth is not established and change
architecture deliberately if implementation or Reality disproves it.

### Accidental rewrite

Too many simultaneous changes could turn the strangler into another
replacement-core rewrite. Use one bounded seam or tranche, keep architecture,
implementation and testing distinct, and defer unrelated cleanup.

### Loss of hard-won GIANTS knowledge

Historically named or oversized modules may contain valuable validated
mechanical knowledge. Distinguish poor ownership from poor mechanism, preserve
or extract proven capability, and retain Reality as final authority.

## Success criteria

The programme succeeds when the live implementation materially resembles:

```text
Reality
   ↓
Observation
   ↓
Situation Assessment
   ↓
Responsibility Transition
   ↓
Current Responsibility
   ↓
Bounded Authority
   ↓
Control
   ↓
Reality
```

Success means Situation Assessment interprets evidence without acquiring
responsibility; Responsibility Transition occurs before Control; and Current
Responsibility explicitly distinguishes GIANTS AI, Regulation and Resolution
Commitment. Bounded Authority determines what physical action is permitted now
without inventing strategic purpose. Control executes already-authorised
requests and reports outcomes.

Regulation responsibility is not inferred merely from a Regulation actuator.
Resolution Commitment persistence is justified by legitimate obligations, and
generic Commitment vocabulary no longer hides distinct responsibilities.
Semantic responsibility acquisition and settlement leave
`LiveControlDispatcher`; proven mechanics remain behind clear boundaries;
superseded orchestration is removed rather than retained as a dormant second
architecture; and supported in-game behaviour remains valid.

The diagram does not imply one Lua module per box. Ownership should instead be
predictable enough to identify where evidence enters, meaning is established,
responsibility changes, persistence is justified, physical permission is
bounded, execution occurs and outcomes return to Reality.

## Future development rhythm

```text
Observe
   ↓
Discuss
   ↓
Hypothesise
   ↓
Implement one bounded responsibility change
   ↓
Validate
   ↓
Record
   ↓
Repeat
```

> When repeated implementation pressure creates exceptions, first ask whether a missing architectural concept has been revealed rather than where another special case can be inserted.

New capabilities should enter through established responsibility boundaries,
not convenient insertion points in large coordinators. Architecture,
implementation mapping, testing evidence and Continuation State should remain
aligned. The desired rhythm is **incremental architectural maintenance, not
periodic architectural rescue**.

# Detailed Strangler Transition Map

## Current live execution mismatch

The current live semantic path is materially:

```text
Situation Assessment
        ↓
Candidate-support orchestration
        ↓
Candidate materialisation
        ↓
Constraint evaluation
        ↓
Decision selection
        ↓
LiveControlDispatcher
        ↓
purpose-specific Commitment/lifecycle mutation
        ↓
obligation / authority mutation
        ↓
ControlRequest
        ↓
Control
```

The accepted target remains:

```text
Situation Assessment
        ↓
Responsibility Transition
        ↓
Current Responsibility
        ↓
Bounded Authority
        ↓
Control
```

Candidate, Constraint and Decision may initially remain implementation machinery
used to determine a transition. This increment does not decide their final
survival or topology.

## Current-to-target disposition

| Accepted responsibility / boundary | Principal current implementation | Current disposition |
|---|---|---|
| Situation Assessment | [`SituationAssessment.lua`](../scripts/assessment/SituationAssessment.lua) and focused assessment modules | PRESERVE / later decompose where useful |
| Transition proposal/choice machinery | [`LiveTrafficCandidateSupport.lua`](../scripts/candidates/LiveTrafficCandidateSupport.lua), [`TerminalEgressCandidateSupport.lua`](../scripts/candidates/TerminalEgressCandidateSupport.lua), [`CandidateSpace.lua`](../scripts/candidates/CandidateSpace.lua), [`ConstraintEngine.lua`](../scripts/constraints/ConstraintEngine.lua), [`DecisionSelector.lua`](../scripts/decision/DecisionSelector.lua), [`TrafficPolicemanDecisionPolicy.lua`](../scripts/decision/TrafficPolicemanDecisionPolicy.lua) | ADAPT / STRANGLE orchestration; preserve useful policy/invariants |
| Responsibility Transition application | [`DecisionCommitmentBoundary.lua`](../scripts/commitment/DecisionCommitmentBoundary.lua) and purpose-specific lifecycle `apply...Decision()` functions | EXTRACT / ADAPT |
| Current Responsibility | Generic [`CommitmentRecord.lua`](../scripts/contracts/CommitmentRecord.lua), Commitment Registry/State Machine and purpose obligations | STRANGLE generic shell; preserve useful substrate |
| Durable obligations | [`ObligationLedger.lua`](../scripts/commitment/ObligationLedger.lua) | PRESERVE |
| Bounded Authority substrate | [`AuthorityRegistry.lua`](../scripts/authority/AuthorityRegistry.lua), Effective Actuation Composition and capability/precondition evidence | PRESERVE / ADAPT |
| Typed Control boundary | [`ControlRequest.lua`](../scripts/contracts/ControlRequest.lua) / [`ControlOutcome.lua`](../scripts/contracts/ControlOutcome.lua) | PRESERVE / later vocabulary adaptation |
| Control dispatch | [`LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) | STRANGLE semantic responsibilities; preserve routing/execution role |
| Physical Control | [`CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua), [`TerminalEgressControl.lua`](../scripts/control/TerminalEgressControl.lua), progression envelope and proven donors | PRESERVE / decompose / graduate truthful names later |

Uncertain future removals remain uncertain; disposition records direction, not a
premature deletion decision.

## Purpose-path discoveries

### Regulation Responsibility ≠ Regulation Actuation

`REGULATE_SPEED` is a physical capability, not automatically a Current
Responsibility. It sometimes realises **Current Responsibility = Regulation**,
including standalone follower-boundary Regulation and D-0146 Action-Space
Regulation. At other times Regulation actuation supports an existing Resolution
Commitment, including Guarded Recovery protection and protected-yield holds
during completed-obstruction resolution. Migration must not proceed by capability name alone.

### Same-Commitment Responsibility Fusion

This is a current implementation divergence. D-0146 Action-Space Regulation may
currently be succeeded by Cooperative Passage by revising the same generic
Commitment and reusing authority. Accepted architecture instead distinguishes
Regulation responsibility ending from fresh Situation Assessment independently
justifying a new Resolution Commitment. This increment records but does not fix it.

### Responsibility Acquisition at the Control Edge

`LiveControlDispatcher` currently performs or invokes semantic lifecycle work
immediately before Control, including combinations of Commitment admission or
revision, obligation creation or settlement, authority-token acquisition or
release, responsibility succession, Control request construction, physical
dispatch and lifecycle settlement after Control outcomes. The target establishes
semantic responsibility before dispatch so the dispatcher routes and executes
already-established authority.

### Proven substrate already exists

Useful existing substrate includes `DecisionCommitmentBoundary`,
`CommitmentAdmission` invariants, Obligation semantics, governing-basis
settlement, Authority-token exclusivity, Effective Actuation Composition,
`ControlRequest` / `ControlOutcome`, Traffic Policeman least-intervention policy
and proven physical Control mechanisms. The primary problem is semantic
ownership, composition and order, not absence of all required machinery.

### Validation Identity Defect

Development builds inherited the visible `0.3.0.0` canonical identity, so HUD
observation alone could not prove which ZIP was under test. Test builds now use
the existing BUILD component of the four-part
[Pre-1.0 Versioning Policy](ENGINEERING_ARCHITECTURE.md#pre-10-versioning-policy).
The first strangler test build is `0.3.0.1`; canonical `0.3.0.0` remains unchanged.

### HUD Glyph Compatibility

GIANTS texture-font Reality does not support the `•` separator previously used
by `VersionHud`. Diagnostic build identity therefore uses the ASCII-safe `|`
separator. This is an implementation observation, not GUI architecture.

# First Strangler Seam

> **Cooperative Passage Responsibility Transition extraction**

This seam is implemented and Reality-validated for one observed direct `CREATE`
Cooperative Passage episode. [`CooperativePassageResponsibilityTransition.lua`](../scripts/responsibility/CooperativePassageResponsibilityTransition.lua)
is the sole live owner that invokes `applyCooperativePassageDecision()`.

The implemented handoff is:

```text
Decision
   ↓
LiveControlDispatcher readiness / pre-emption checks
   ↓
non-mutating readiness handoff
   ↓
Runtime
   ↓
CooperativePassageResponsibilityTransition
   ↓
existing Cooperative Passage lifecycle machinery
   ↓
responsibility already established
   ↓
LiveControlDispatcher
   ↓
existing ControlRequest / CooperativePassageControl
```

`LiveControlDispatcher` retains the existing pre-transition readiness and
pre-emption checks, then returns the non-mutating readiness handoff. Runtime
invokes the upstream transition and passes its already-established Commitment
result to the dedicated dispatcher continuation. Physical Passage Control and
existing completion settlement are preserved. Non-migrated intervention paths
remain on their legacy lifecycle ownership.

The observed `0.3.0.1` episode logged exactly one
`COOPERATIVE_PASSAGE_TRANSITION_UPSTREAM` with `action=CREATE` and
`beforePhysicalDispatch=true`, followed by `COOPERATIVE_ACCEPTED`, normal
physical Passage, Axis Return and GIANTS handoff, pair-context dissolution,
Commitment success and authority release. No duplicate transition,
`COMMITMENT_APPLICATION_FAILED`, `COOPERATIVE_REJECTED` or observable regression
was identified in that episode. This evidence does not independently validate
the Regulation-to-Passage `REVISE` succession path or the full supported envelope.

> `LiveControlDispatcher` must not independently apply the Cooperative Passage transition.

This **No Dual Transition Authority** invariant is structurally protected. The
tranche did not remove generic Commitment semantics or resolve Same-Commitment
Responsibility Fusion.

# Intermediate Programme Steps

1. **Record the transition map — COMPLETE.**
2. **Extract Cooperative Passage Responsibility Transition before Control — COMPLETE.**
3. **Validate the first strangler seam and behavioural equivalence — COMPLETE for the observed direct Cooperative Passage `CREATE` path.**
4. **Expose Resolution Commitment explicitly through migrated paths.**
5. **Migrate completed-obstruction Resolution responsibility.**
6. **Reconcile standalone Regulation.**
7. **Resolve Regulation-to-Passage succession and Same-Commitment Responsibility Fusion.**
8. **Reconcile Bounded Authority as downstream consequence of Current Responsibility.**
9. **Reduce `LiveControlDispatcher` to dispatch/execution responsibilities.**
10. **Retire superseded generic Commitment/orchestration machinery.**
11. **Simplify Candidate/Constraint/Decision only where later evidence proves duplication or ceremony.**
12. **Graduate Prototype/diagnostic production mechanics and naming when their current responsibility is established.**
13. **Perform whole-system validation and another architecture-to-runtime review.**

> This sequence is a plan, not a promise. Update it after each strangler tranche when implementation or validation evidence changes the safest or most truthful route.

The High-Level Strangler Plan is the human-readable programme dashboard and
should be refreshed after each accepted tranche.

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
| Physical Representation | [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua), [`scripts/representation/PlanViewFootprint.lua`](../scripts/representation/PlanViewFootprint.lua), [`scripts/representation/PairSpecificPassageClearance.lua`](../scripts/representation/PairSpecificPassageClearance.lua) |
| Passage capability and planning | [`scripts/assessment/PassageCapabilityAssessment.lua`](../scripts/assessment/PassageCapabilityAssessment.lua), [`scripts/candidates/LocalPassagePlanner.lua`](../scripts/candidates/LocalPassagePlanner.lua) |
| Control dispatch and Cooperative Passage | [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua), [`scripts/control/CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua) |
| Completed-obstruction and terminal control | [`scripts/assessment/TerminalOccupancyAssessment.lua`](../scripts/assessment/TerminalOccupancyAssessment.lua), [`scripts/candidates/TerminalEgressCandidateSupport.lua`](../scripts/candidates/TerminalEgressCandidateSupport.lua), [`scripts/commitment/TerminalEgressCommitmentLifecycle.lua`](../scripts/commitment/TerminalEgressCommitmentLifecycle.lua), [`scripts/control/TerminalEgressControl.lua`](../scripts/control/TerminalEgressControl.lua) |

## Implementation-alignment observations

Historical names and structures such as `shadow`, `TEST`, D-number and prototype
vocabulary, `EncounterRegistry`, `FieldBoundedFutureSpace`, and old diagnostic or
probe names remain in source. This is placement or vocabulary lag, not current
architectural authority. Diagnostic and probe existence does not establish an
architectural responsibility, authorise pruning or determine a permanent inventory.
