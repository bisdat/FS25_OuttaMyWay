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

`LiveControlDispatcher` still performs or invokes semantic lifecycle work for
non-migrated paths immediately before Control, including combinations of Commitment admission or
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

# Second Strangler Seam

> **Completed-Obstruction Resolution Responsibility Transition extraction**

The physical acquisition seam is implemented and Reality-validated for one
in-session completed-obstruction episode. The topology is:

```text
Terminal physical Decision
    ↓
LiveControlDispatcher readiness checks
    ↓
non-mutating readiness handoff
    ↓
Runtime
    ↓
CompletedObstructionResponsibilityTransition
    ↓
existing TerminalEgressCommitmentLifecycle.applyDecision()
    ↓
responsibility already established
    ↓
LiveControlDispatcher continuation
    ↓
existing Protected Yield where required
    ↓
existing TerminalEgress ControlRequest / Control
    ↓
existing downstream settlement
```

[`CompletedObstructionResponsibilityTransition.lua`](../scripts/responsibility/CompletedObstructionResponsibilityTransition.lua)
is the sole live physical owner of `TerminalEgressCommitmentLifecycle.applyDecision()`;
`LiveControlDispatcher` no longer applies physical completed-obstruction
responsibility. Terminal settlement and Protected Yield deliberately remain
downstream. The generic Commitment, Obligation and Authority machinery remains
in use, and no generic Resolution Commitment abstraction was introduced.

The `0.3.0.2` Reality episode produced two upstream application logs for the
same `CM-00005`, not two responsibility acquisitions. `CREATE` established the
Commitment before `COMPACT`; compaction completed and required fresh Situation
Assessment; `MAINTAIN` then preserved the same Commitment before Protected Yield
and `INFIELD`. The existing stage-1 centroid-bearing, fixed-initial-bearing,
no-course-correction movement remained bounded to `60.00 m`. Protected Yield
released on manoeuvre completion, terminal settlement reached `SUCCEEDED`, two
authority tokens were released, and productive Continuation Renewal was observed.
There was no application failure, physical rejection, Player Claim, Protected
Yield rejection, new Commitment identity, altered courtesy geometry or
observable regression in this episode.

## Resolution Persistence Across Control Phases

One Resolution responsibility may legitimately persist while the currently
permitted physical Control phase changes. `CM-00005` persisted from compaction
through fresh Situation Assessment into protected bounded movement, while
physical authority changed and settlement waited for the continuation-restoring
movement. This supports the architectural distinction between Current
Responsibility (why intervention persists) and Bounded Authority (what action is
permitted now), but one run does not establish the final Bounded Authority representation.

## Maintenance Is Not Transition

The second call through the compatibility transition seam reported `MAINTAIN`.
Architecturally, fresh Situation Assessment positively preserving an existing
Resolution responsibility is not a new Responsibility Transition. The module
still delegates legacy `CREATE` / `MAINTAIN` / `REVISE` vocabulary through one
transition-shaped seam. This semantic mismatch is observed but not corrected here.

## Transition–Execution Readiness Coupling

Both Cooperative Passage and completed-obstruction Resolution now provide
independent evidence that physical/readiness checks occur before the upstream
semantic application seam. This is cross-cutting architectural debt rather than
a Passage-specific accident; this tranche records but does not resolve it.

## Second Exemplar Before Generalisation

The programme deliberately migrated a materially different second Resolution
exemplar before introducing a generic explicit Resolution Commitment. Cooperative
Passage couples two active workers with progress-plus-progress actuation and has
direct `CREATE` evidence. Completed obstruction couples an active beneficiary to
a completed controlled subject with progress-plus-post-job actuation,
player-consented capability, and `CREATE` → `MAINTAIN` evidence across Control
phases. Comparing them now offers a stronger empirical basis for identifying
genuinely common Resolution semantics without presupposing an abstraction.

## Cold-Start Physical Relevance Gap

Two cold-loaded-save attempts did not exercise this seam. The completed Condor
was stationary Reality but was not a current active-job vehicle, had no retained
runtime track and had no observed positive active-to-ended Job Episode transition.
Consequently no Terminal Occupancy, D-0147 Candidate or upstream transition was
established. Stationarity alone is insufficient completed-worker provenance.

Cold-start non-active obstruction recognition remains in scope as a separate
Observation/provenance problem. [Issue #33 — Cold-Start Non-Active Obstruction
Recognition](https://github.com/bisdat/FS25_OuttaMyWay/issues/33)
owns its unresolved investigation; it is not a PR #32 transition regression or fix.

# Explicit Resolution Commitment Representation

The two migrated Resolution seams now materialize an explicit, read-only
[`ResolutionCommitment`](../scripts/contracts/ResolutionCommitment.lua) through
[`ResolutionCommitmentAdapter.lua`](../scripts/responsibility/ResolutionCommitmentAdapter.lua)
after the retained generic lifecycle application succeeds. The representation
uses the existing generic Commitment identity and exposes purpose, governing
basis, explicit beneficiary and controlled-subject roles, the open
purpose-specific Resolution obligations, and diagnostic provenance.

This is a semantic view over the retained substrate, not another lifecycle.
`CommitmentRegistry`, `ObligationLedger`, admission, authority allocation and
settlement remain singular and authoritative. Neither Control nor Bounded
Authority consumes the view in this tranche. **No Dual Responsibility Record
Authority** is therefore preserved.

Roles are supplied from semantic context at each Responsibility Transition:

- Cooperative Passage validates exactly two distinct coupled participant
  assemblies and represents both as beneficiaries and controlled subjects.
- Completed obstruction represents the authorising active demand assemblies as
  beneficiaries and the completed terminal assembly as the controlled subject.

Authority ownership, authority tokens and Effective Actuation Composition are
not used to infer these roles. Candidate identity, Control phase, capability,
authority tokens and legacy lifecycle action are not part of Resolution
identity. `CREATE` and `REVISE` expose an established Resolution view;
completed-obstruction `MAINTAIN` re-exposes the same identity as persistence of
Current Responsibility, not a new architectural transition. The legacy action
is retained only as diagnostic provenance.

GitHub Structural contracts and Lua offline observation completed successfully.
GIANTS Reality then validated both required `0.3.0.3` exemplars. Direct
Cooperative Passage logged `RESOLUTION_COMMITMENT_ESTABLISHED` with
`legacyAction=CREATE`, the retained generic Commitment identity, and both
coupled workers explicitly represented as beneficiaries and controlled
subjects; existing Passage Control and participant-handoff settlement completed
successfully. Completed obstruction logged
`RESOLUTION_COMMITMENT_ESTABLISHED` with `legacyAction=CREATE`, then after
`COMPACT` and fresh Situation Assessment logged
`RESOLUTION_COMMITMENT_PERSISTED` with the same identity and
`legacyAction=MAINTAIN`, followed by Protected Yield, `INFIELD`, terminal
`SUCCEEDED`, authority release and Continuation Renewal.

This positively validates the explicit representation, identity reuse, role
separation, Resolution Persistence Across Control Phases and Maintenance Is Not
Transition in the observed run. Downstream Passage and completed-obstruction
mechanics remained consistent with their retained behaviour. It does not claim
full supported-envelope regression coverage. Standalone Regulation,
Same-Commitment Regulation-to-Passage fusion, Bounded Authority and issue #33
remain outside this tranche.

## A/B behavioural-equivalence evidence

The `0.3.0.3` run later encountered a corner sequence in a different location
from the original uninterrupted `0.3.0.2` run: D-0146 Action-Space Regulation
progressively regulated the Condor, Regulation actuation became quiescent, both
workers became physically blocked, and player intervention was required.

The same saved-game fixture was rerun on accepted `0.3.0.2` at
`2aa47fda4d6c0e75f24c9e5f2200c8c1c2eae921`. It reproduced a closely comparable
ordering and timing: Cooperative Passage, later D-0146 Action-Space Regulation,
Regulation quiescence, mutual corner blockage and required player intervention.
Therefore **PR #34 regression suspicion is cleared** for this failure. The
corner outcome predates the explicit Resolution Commitment representation.

### Saved-State Test Fixture Divergence

A saved game created during an uninterrupted GIANTS AI run is not necessarily a
behaviourally identical continuation fixture after reload, even when visible
vehicle and field state appears equivalent. The original uninterrupted
`0.3.0.2` run completed successfully, while later reloads reconstructed enough
different GIANTS continuation or path state for subsequent encounters to occur
elsewhere. This is primarily a test-fixture and reproducibility finding, not a
new OuttaMyWay architectural defect. The saved fixture remains a useful
repeatable corner/deadlock scenario; the historical scenario is not claimed to
be deterministic across save/reload.

### Quiescent Regulation Deadlock

The saved-state A/B runs provide an unresolved working observation:

```text
unresolved Regulation responsibility
    ↓
preventative actuation quiesces
    ↓
physical corner / pinch conflict persists or worsens
    ↓
both workers become blocked
    ↓
no autonomous resolution follows
    ↓
player intervention required
```

Positive native forward-rate evidence became unavailable while the relationship
remained unresolved, causing Regulation actuation to become quiescent. Later
trajectory interpretation no longer supported an opposed-corridor conflict even
though the physical corner conflict remained. This supports the narrower
working distinction **Opposed-Corridor Conflict ≠ Corner Conflict**.

These are Reality observations for the later standalone Regulation
reconciliation, not accepted architecture or an implementation proposal. PR #34
does not authorise or implement a fix to Regulation, Situation Assessment,
D-0146, corner modelling or Control. The evidence is unrelated to issue #33's
separate cold-start non-active obstruction-recognition investigation.

# First Regulation Strangler Seam

> **D-0141 Follower-Boundary Regulation Responsibility Transition extraction**

The first standalone Regulation implementation hypothesis moves only D-0141
`APPLY` responsibility application and revalidation upstream of physical
Control:

```text
selected follower-boundary Decision
    ↓
LiveControlDispatcher APPLY routing / readiness checks
    ↓
non-mutating transition-required handoff
    ↓
Runtime
    ↓
FollowerBoundaryResponsibilityTransition
    ↓
existing LiveTrafficCommitmentLifecycle.applyFollowerBoundaryDecision()
    ↓
responsibility application / revalidation established
    ↓
LiveControlDispatcher continuation
    ↓
existing elastic Regulation request / lease / Control
```

[`FollowerBoundaryResponsibilityTransition.lua`](../scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua)
is the sole production caller of `applyFollowerBoundaryDecision()`. The
dispatcher first confirms the selected semantic bridge is D-0141 `APPLY`, the
Candidate capability is `REGULATE_SPEED`, and the existing Control capability
is available. Runtime then invokes the purpose-specific transition and returns
the already-applied result to `continueFollowerBoundary()`. Authority-token
validation, `ControlRequest` construction, requested elastic cap, owner tag,
lease application/update, quiescence/reactivation bookkeeping, outcomes,
rejection rollback and physical Control remain downstream and unchanged in
intent.

This is a deliberately incomplete Regulation strangler boundary:

```text
D-0141 acquisition / revalidation → upstream
D-0141 retirement / termination   → retained downstream legacy
```

Positive RETIRE application, physical lease release, purpose-bound authority
release and follower-obligation settlement remain in the dispatcher/lifecycle
path. PRESERVE and quiescent/reactivated physical actuation bookkeeping also
remain downstream. Repeated `APPLY` for an already-live purpose is logged as
retained/revalidated responsibility rather than claimed as a new architectural
Responsibility Transition.

No explicit or generic Regulation representation, registry or lifecycle is
introduced. D-0146 Action-Space Regulation remains the required second
standalone exemplar before comparing common Regulation semantics. **Second
Exemplar Before Generalisation** therefore continues to apply. GIANTS Reality
validation of this D-0141 seam is pending; the implementation does not address
Quiescent Regulation Deadlock, corner behaviour, Same-Commitment Responsibility
Fusion, Bounded Authority or issue #33.

# Intermediate Programme Steps

1. **Record the transition map — COMPLETE.**
2. **Extract Cooperative Passage Responsibility Transition before Control — COMPLETE.**
3. **Validate the first strangler seam and behavioural equivalence — COMPLETE for the observed direct Cooperative Passage `CREATE` path.**
4. **Extract completed-obstruction physical Resolution responsibility — COMPLETE.**
5. **Validate the second Resolution exemplar — COMPLETE for the observed in-session `CREATE` → `MAINTAIN`, `COMPACT` → `INFIELD` episode.**
6. **Compare the two migrated Resolution exemplars and determine the smallest truthful explicit Resolution Commitment representation — COMPLETE for the read-only adapter/view hypothesis.**
7. **Expose Resolution Commitment explicitly only where the two exemplars support it — COMPLETE and GIANTS Reality-validated for the observed direct Cooperative Passage `CREATE` and completed-obstruction `CREATE` → `MAINTAIN`, `COMPACT` → `INFIELD` exemplars.**
8. **Reconcile standalone Regulation — IN PROGRESS.**
   - **8a. Extract D-0141 follower-boundary Regulation application/revalidation upstream — IMPLEMENTED; GitHub and GIANTS Reality validation pending.**
   - **8b. Extract and validate D-0146 Action-Space Regulation as the second standalone exemplar — PLANNED.**
   - **8c. Compare both exemplars and determine the smallest truthful explicit Regulation representation — DEFERRED pending 8a/8b evidence.**
9. **Resolve Regulation-to-Passage succession and Same-Commitment Responsibility Fusion.**
10. **Reconcile Bounded Authority as downstream consequence of Current Responsibility.**
11. **Reduce `LiveControlDispatcher` toward dispatch/execution responsibilities.**
12. **Retire superseded generic Commitment/orchestration only when no supported path relies on it.**
13. **Simplify Candidate/Constraint/Decision only where evidence proves duplication.**
14. **Graduate Prototype/diagnostic production mechanics and naming.**
15. **Perform whole-system validation and another architecture-to-runtime review.**

> This sequence is a plan, not a promise. Update it after each strangler tranche when implementation or validation evidence changes the safest or most truthful route.

The order evolved through **Second Exemplar Before Generalisation**: Reality
evidence from two distinct Resolution purposes now precedes any attempt to define
their common explicit representation.

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
| Explicit Resolution Commitment view | [`scripts/contracts/ResolutionCommitment.lua`](../scripts/contracts/ResolutionCommitment.lua), [`scripts/responsibility/ResolutionCommitmentAdapter.lua`](../scripts/responsibility/ResolutionCommitmentAdapter.lua), and the two purpose-specific transition modules in [`scripts/responsibility/`](../scripts/responsibility/) |
| D-0141 follower-boundary Regulation transition and downstream Control | [`scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua`](../scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua), [`scripts/commitment/LiveTrafficCommitmentLifecycle.lua`](../scripts/commitment/LiveTrafficCommitmentLifecycle.lua), and [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) |
| Physical Representation | [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua), [`scripts/representation/PlanViewFootprint.lua`](../scripts/representation/PlanViewFootprint.lua), [`scripts/representation/PairSpecificPassageClearance.lua`](../scripts/representation/PairSpecificPassageClearance.lua) |
| Passage capability and planning | [`scripts/assessment/PassageCapabilityAssessment.lua`](../scripts/assessment/PassageCapabilityAssessment.lua), [`scripts/candidates/LocalPassagePlanner.lua`](../scripts/candidates/LocalPassagePlanner.lua) |
| Control dispatch and Cooperative Passage | [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua), [`scripts/control/CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua) |
| Completed-obstruction transition, settlement and Control | [`scripts/responsibility/CompletedObstructionResponsibilityTransition.lua`](../scripts/responsibility/CompletedObstructionResponsibilityTransition.lua), [`scripts/assessment/TerminalOccupancyAssessment.lua`](../scripts/assessment/TerminalOccupancyAssessment.lua), [`scripts/candidates/TerminalEgressCandidateSupport.lua`](../scripts/candidates/TerminalEgressCandidateSupport.lua), [`scripts/commitment/TerminalEgressCommitmentLifecycle.lua`](../scripts/commitment/TerminalEgressCommitmentLifecycle.lua), [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua), [`scripts/control/TerminalEgressControl.lua`](../scripts/control/TerminalEgressControl.lua) |

## Implementation-alignment observations

Historical names and structures such as `shadow`, `TEST`, D-number and prototype
vocabulary, `EncounterRegistry`, `FieldBoundedFutureSpace`, and old diagnostic or
probe names remain in source. This is placement or vocabulary lag, not current
architectural authority. Diagnostic and probe existence does not establish an
architectural responsibility, authorise pruning or determine a permanent inventory.
