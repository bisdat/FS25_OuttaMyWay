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
Exemplar Before Generalisation** therefore continues to apply. The
implementation does not address Quiescent Regulation Deadlock, corner
behaviour, Same-Commitment Responsibility Fusion, Bounded Authority or issue
#33.

## D-0141 GIANTS Reality validation

The `0.3.0.4` Reality episode naturally established Patriot 4450 as leader and
Condor Endurance II as follower. Initial lifecycle application produced
`AP-00001`, `CM-00001` and `OB-00001` for pair
`AS-00002|AS-00001`. The architecture-facing marker then reported:

```text
FOLLOWER_BOUNDARY_TRANSITION_UPSTREAM
commitment=CM-00001
leader=AS-00002
follower=AS-00001
legacyAction=CREATE
responsibilityDisposition=ESTABLISHED
beforePhysicalDispatch=true
```

Downstream `D0141_APPLY` followed for the same `CM-00001` and follower at
`5.15 km/h`. This positively validates responsibility application upstream of
physical Regulation.

The episode then naturally exercised retained purpose and elastic Control. An
observed `legacyAction=MAINTAIN`, `responsibilityDisposition=REVALIDATED` marker
for `CM-00001` preceded `D0141_UPDATE` at `6.21 km/h`, with repeated further
updates. Approximate episode counts were one established marker, 44 revalidated
markers, one physical APPLY, 43 physical updates, two quiescence events and one
reactivation. All retained `CM-00001`.

Quiescence released temporary authority for `AS-00001` while logging
`purposeRetained=true`. Reactivation later acquired `AU-00002`, revalidated the
same `CM-00001` / `OB-00001`, and applied `11.40 km/h` through
`D0141_ACTUATION_REACTIVATED`. This validates responsibility persistence
independently of temporary Bounded Authority, along with elastic magnitude,
quiescence, reactivation and **Maintenance Is Not Transition**. No contrary
evidence of changed GIANTS productive routing or steering ownership was
observed.

Positive D-0141 retirement was **not observed / not required for this tranche**.
That is not a validation failure. Retirement/termination remains deliberately
downstream and unchanged. The observed D-0141 strangler seam passed; standalone
Regulation reconciliation remains incomplete.

# Second Regulation Strangler Seam

> **Action-Space Regulation Responsibility Transition extraction**

Programme step 8b moves all three live Action-Space responsibility application
contexts upstream while retaining their execution envelope downstream:

```text
selected Action-Space Decision
    ↓
LiveControlDispatcher routing / readiness
    ↓
non-mutating transition-required handoff
    ↓
Runtime
    ↓
ActionSpaceRegulationResponsibilityTransition
    ↓
existing LiveTrafficCommitmentLifecycle.applyD0146ActionSpaceDecision()
    ↓
responsibility established / revalidated
    ↓
LiveControlDispatcher continuation
    ↓
existing progression envelope / elastic Regulation / Control
```

[`ActionSpaceRegulationResponsibilityTransition.lua`](../scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua)
is the sole production caller of the retained application function. The three
covered contexts are initial/current application, reactivation after quiescence
and regulated-role migration. Dispatcher readiness still proves the selected
bridge, `REGULATE_SPEED` capability, Control availability and applicable
retained lease context before the handoff.

The unresolved interaction plus current action-space-preservation purpose is
the durable responsibility core. The regulated participant, protected
participant, supporting authority, speed ceiling, progression envelope,
quiescence/reactivation condition and role migration are its mutable execution
envelope. **Responsibility Roles ≠ Regulation Actuation Roles**: changing the
regulated assembly does not establish a new responsibility identity.

The deliberate intermediate asymmetry is:

```text
Action-Space acquisition / revalidation → upstream
Action-Space purpose settlement         → retained downstream legacy
```

Progression-envelope mechanics, physical Regulation, quiescence and settlement
remain downstream. No generic Regulation representation is introduced.

**Successor-Agnostic Regulation** remains authoritative: Action-Space
Regulation exists because the current unresolved interaction justifies
preserving usable action space. It does not predict or reserve Cooperative
Passage; fresh Situation Assessment independently determines any successor.

The saved-corner Reality attempt did not exercise this seam. No Action-Space
Regulation was selected, no `ACTION_SPACE_REGULATION_TRANSITION_UPSTREAM` or
D0155 progression-envelope Regulation occurred, and existing Situation and
selection machinery admitted Cooperative Passage directly. The attempt
therefore neither validates nor disproves the ownership extraction; no PR #36
runtime regression is inferred from a seam bypassed upstream.

This exposed the broader **Spatial Constraint Overlay Implementation Gap**.
The architecture's Category-1 corner and Category-2 headland/boundary overlay
and allocation policy are not yet implemented as a production Situation
concept. Existing boundary, Future Space, opposed-corridor and follower-boundary
mechanisms do not constitute that overlay. The gap is tracked in
[issue #37](https://github.com/bisdat/FS25_OuttaMyWay/issues/37).

**Incidental Regulation ≠ Spatial Regulation**: earlier saved-corner runs that
received Action-Space Regulation through opposed-corridor machinery do not
prove that Category-1 spatial Regulation existed. Without the explicit overlay,
other heuristics may incidentally capture a constrained-space interaction or a
different responsibility may mature first. The exact cause of run-to-run
divergence is not claimed here. The saved-corner fixture is no longer a reliable
PR #36 seam-validation fixture until that gap is addressed or another fixture
reliably selects Action-Space Regulation.

## Regulation exemplar comparison — programme step 8c

Comparison of the extracted follower-boundary and Action-Space seams disproved
the emerging assumption that their Situation-specific forms should become
separate architectural Regulation types. The architectural result is **Many
Situations, One Regulation Capability: Temporal Coordination**. Regulation
remains one Current Responsibility whose invariant capability is bounded,
reversible alteration of relative timing while GIANTS retains productive route
and progression ownership.

The comparison establishes this allocation:

```text
Situation Assessment → why temporal coordination is currently useful
Regulation           → bounded temporal responsibility
Bounded Authority    → which subject and permissible magnitude now
Control              → physical timing adjustment
fresh assessment     → continuation, termination and successor
```

Follower/leader interaction, uncertain intent, constrained option-space
competition, poor prospective Passage theatre and third-worker Bubble
protection are Situation distinctions and benefits, not Regulation subtypes.
This also records **Regulation Cause ≠ Regulation Capability** and preserves
**Responsibility Roles ≠ Regulation Actuation Roles**: follower, leader,
regulated/protected participant, cap, authority token, progression envelope,
quiescence/reactivation and Action-Space role migration do not define generic
Regulation identity.

**Spatial Strategy / Temporal Regulation** permits Situation Assessment to use
positive spatial foreseeability strategically, including moving a highly
probable encounter toward better Passage theatre by changing timing. Regulation
does not thereby acquire routing or Passage authority. **Successor-Agnostic ≠
Future-Blind**: Regulation neither reserves nor guarantees a successor, but
Situation Assessment need not ignore a strongly supported future interaction.
Fresh assessment independently justifies any later Resolution Commitment.

The two purpose-specific transition modules remain legitimate implementation
seams and provenance; their names do not establish architectural subclasses.
Follower-boundary and Action-Space obligations remain retained substrate that
currently encodes Situation-specific provenance and persistence. Neither those
obligation identities nor generic Commitment identity is promoted here as the
final architectural Regulation identity. The smallest truthful explicit,
read-only Regulation representation remains to be determined after review of
this Record; no runtime representation, registry, adapter or lifecycle is
introduced in this tranche.

### Discovery gate: Responsibility Instance Identity Gap

Implementation inspection found no existing truthful witness for one Regulation
responsibility instance across all continuity permitted by the architecture.
The read-only representation hypothesis is therefore blocked rather than
materialised.

**Evidence Succession ≠ Responsibility Succession** governs this result. A
Regulation instance may remain continuous while current Situation evidence and
governing basis evolve, so an evidence identity cannot substitute for the
responsibility instance that persists through that change.

The retained identities fail for distinct reasons:

- generic Commitment identity survives follower revalidation and Action-Space
  role migration, but is broader than Current Responsibility and currently may
  continue across the known Regulation-to-Passage responsibility discontinuity;
- follower-boundary and Action-Space Obligation identities are distinct,
  Situation-specific records keyed through pair or conflict provenance. They
  can witness their own retained obligation, but cannot identify one Regulation
  instance when its governing evidence evolves without turning those causes
  into architectural subtypes;
- authority tokens can be released during quiescence, reacquired during
  reactivation and changed with the regulated actuation role;
- Candidate and Decision identities are assessment/application episodes, while
  pair keys, conflict identities, participant tuples and current Situation
  reasons identify evidence or context rather than Regulation responsibility.

No remaining registry or record explicitly witnesses the interval from
Regulation acquisition to genuine Regulation termination independently of both
Situation cause and generic Commitment lifecycle. Deriving an identity from
those fields, issuing a new counter or adding a parallel registry would create
new lifecycle authority rather than expose retained truth. No fake identity or
parallel Regulation lifecycle was introduced.

This **Responsibility Instance Identity Gap** is the next dependency for the
smallest explicit read-only Regulation representation. It must be reconciled
without pre-empting step 9's Same-Commitment Responsibility Fusion work.

### Responsibility Transition Authority Gap

The failed representation hypothesis exposed the deeper architectural
dependency: current implementation has no explicit sole **Responsibility
Transition Authority** that owns establishment, termination and atomic
replacement of Current Responsibility. **Responsibility Transition Is the
Semantic Boundary**; continuous Situation Assessment may preserve the same
responsibility without invoking that boundary, while a genuine lifecycle change
requires one authoritative transition.

Responsibility-instance identity belongs to the Current Responsibility
established at that boundary, not to retained substrate. It remains stable
through changing evidence and actuation but ends at genuine termination or
replacement. This preserves **Evidence Succession ≠ Responsibility Succession**
and adds **Substrate Continuity ≠ Responsibility Continuity**.

The Regulation-to-Cooperative-Passage `REVISE` path is the primary step-9
exemplar. The retained generic Commitment may remain continuous while
architectural responsibility changes from Regulation R1 to Resolution
Commitment R2. Therefore **Commitment `REVISE` ≠ Responsibility Continuation**.
Likewise, **Obligation Settlement ≠ Responsibility Transition**: obligation
creation or settlement may support a handoff but cannot own its semantic
authority.

**Semantic Discontinuity Can Be Atomic.** Responsibility Transition Authority
may end Regulation R1 and establish Resolution Commitment R2 as one semantic
replacement without a mandatory intermediate GIANTS-AI tick or uncontrolled
interval. Regulation does not mutate into Resolution. Bounded Authority and any
AuthorityToken reuse remain deferred to programme step 10.

The existing purpose-specific transition modules are valuable strangler seams,
not a unified Responsibility Transition Authority. Responsibility application,
generic Commitment revision, obligation settlement and downstream completion
remain fragmented across current Candidate, Decision, transition, lifecycle and
dispatcher surfaces. This is evidence to inspect, not a runtime design decision;
no current module is declared to own the new architectural authority.

The accepted `ResolutionCommitmentAdapter` remains valid transitional
implementation for direct exemplars whose observed Resolution and retained
Commitment lifetimes coincided. **Coincident Identity ≠ Identity Equivalence**:
the same-Commitment succession evidence means that mapping must later be
reconciled, not retrospectively rejected.

### First Responsibility Replacement Seam

The Action-Space Regulation → same-Commitment Cooperative Passage exemplar now
has one explicit semantic replacement seam upstream of physical Passage
Control. This was the first explicit Regulation identity exemplar. Runtime
composes `ResponsibilityTransitionAuthority`; [Phase 9a](#phase-9a--second-regulation-identity-exemplar) extends this donor lifecycle to follower-boundary:

```text
Action-Space Regulation R1 / retained CM-*
    -> fresh Passage Decision
    -> retained Commitment REVISE
    -> predecessor D-0146 purpose settlement and lease cleanup
    -> authoritative replacement by Resolution Commitment R2
    -> Passage Control continuation
```

`IdentityRegistry` issues opaque `RS-*` responsibility identities. Initial
Action-Space Regulation establishes R1; revalidation, authority quiescence and
reactivation, and regulated-role migration preserve that same identity. These
execution-envelope changes are not transitions. The selected conflict remains
validation provenance and is not used as responsibility identity.

For the migrated same-Commitment succession, the authority establishes a fresh
R2 identity and supplies it to the accepted `ResolutionCommitmentAdapter`. The
retained generic Commitment identity remains unchanged, while `R1 != R2` and
neither responsibility identity equals the Commitment identity. Direct Passage
and completed-obstruction Resolution retain their existing transitional
identity mapping in this tranche.

The existing dispatcher helper still performs proven D-0146 physical lease and
obligation cleanup, but Responsibility Transition Authority invokes it as a
subordinate part of replacement before `continueCooperativePassage()` may begin
physical Control. Failed application, Commitment-continuity validation or
predecessor settlement produces no Passage continuation and does not make both
semantic responsibilities current.

This is not general Responsibility Transition Authority coverage. Phase 9a adds
follower Regulation and its same-Commitment succession; completed obstruction,
direct Passage and wider responsibility reconciliation remain deferred. Generic
Commitment, Obligation and AuthorityToken behaviour remains retained substrate;
AuthorityToken reuse is not redesigned before programme step 10.

PR review exposed **Replacement Precondition Lag**: the first implementation
validated retained-Commitment continuity and predecessor cleanup eligibility
only after the Passage `REVISE`. The corrected seam now validates the complete
known boundary before successor mutation: selected Candidate/readiness,
`D0146_STEP2` bridge and conflict, current Regulation identity and retained
Commitment, matching dispatcher lease, open Action-Space obligation, and the
picture's targeted same-Commitment `REVISE`. Action-Space INITIAL,
REACTIVATION and ROLE_MIGRATION likewise preflight semantic compatibility before
their retained lifecycle application. Preflight is read-only and performs no
Control or retained lifecycle mutation.

### Phase 9a — Second Regulation identity exemplar

`0.3.0.9 TEST — REGULATION RESPONSIBILITY GENERALISATION` makes follower-boundary
the second explicit Regulation identity exemplar after Action-Space. Both use
one architectural `Regulation` contract and opaque `RS-*` identity. Purpose,
pair and conflict data are provenance only. The authority's private map uses
retained `CM-*` as an implementation lookup key, so an independent Commitment's
Regulation cannot overwrite another. This adds no worker context, relationship
object or Operation-scoped responsibility container, and does not repair the
remaining Global-to-Local singleton Control state.

Follower application now follows read-only semantic preflight → existing
`applyFollowerBoundaryDecision()` → authority establishment/preservation →
`continueFollowerBoundary()`. Upstream diagnostics expose both identities.
Ordinary maintenance, magnitude changes and quiescence/reactivation preserve the
same semantic identity; none introduces a `CONTINUE` transition.

Fresh same-Commitment follower → Cooperative Passage uses follower preflight
and the donor's shared semantic replacement commit point. Preflight checks the
selected Candidate/readiness, Passage participants and ownership, live retained
target, physical cleanup availability, supporting authority, successor
obligation specification and open predecessor obligation before mutation. The
fresh successor `RS-*` is injected through the existing Passage transition.
Dispatcher physical lease cleanup and follower obligation settlement must
succeed before R1 is removed and R2 is returned to Runtime for Passage Control.
There is no GIANTS-AI tick between responsibilities. Failed preflight performs no
revision; failed revision or cleanup exposes no successor and starts no Passage.
A failed cleanup after revision does not roll back retained substrate; it leaves
only R1 semantically current and refuses physical continuation, as at the donor
boundary. Direct Resolution `CREATE` and completed-obstruction Resolution
identity remain transitional and are the next Phase-9 boundary. Bounded Authority
remains Phase 10.

Positive follower retirement keeps physical lease release, supporting authority
release and obligation settlement in the dispatcher/lifecycle, then terminates
semantic Regulation through the authority. Terminal-path inventory found:

- `TerminalSettlementEvaluator.attemptTerminal()` is the common successful
  terminal boundary used by Decision application and traffic/terminal lifecycle
  settlement. Runtime explicitly connects it to a follower-only authority hook;
  terminal substrate cannot leave follower Regulation current, including after
  a rejected Control acquisition or absent lease.
- Job Episode dependency collapse already terminalises eligible D0146/Forward
  Intersection substrate, then invokes `retireTrafficLeasesForCommitment()`.
  Both paths now clear corresponding follower semantic state. The existing
  collapse eligibility does not include ordinary follower-only substrate; this
  tranche does not broaden that dependency policy.
- Terminal traffic lease retirement also invokes the hook independently of
  whether the follower lease is still present. Quiescence never invokes it.

Intended behavioural changes = **none**: follower admission, variable-speed and
elastic magnitude, reversing-leader handling, quiescence/reactivation and
positive retirement mechanics remain the regression boundary. Action-Space,
Forward Intersection's fixed `1 km/h`, D-0146 magnitude and Issue #37 policy are
unchanged. Failure gating prevents Passage before successful cleanup.

Offline evidence: structural/source contracts **104 passed**; Lua replacement
harness **290 passed / 13 failed**, adding 15 passing cases and preserving the
same historical failure profile. Existing follower end-to-end assertions now
also check semantic identity through magnitude, quiescence/reactivation and
retirement. New tests cover replacement ordering/refusals, terminal settlement,
eligible dependency collapse and independent semantic storage. Lua syntax and
`git diff --check` pass. No GIANTS Reality validation is claimed for Phase 9a.
Later Reality regression should repeat the proven follower behaviour and observe
follower → Passage only if a natural fixture produces it; no policy forces it.

### PR #41 GIANTS Reality observation

The `2026-09-04` `0.3.0.6` run produced exactly one upstream Action-Space
Regulation establishment at `19:25:53.205`: decision `DE-01249`, Candidate
`CA-01249`, conflict `d0146-opposed:OR-00001:AS-00001:AS-00002`, retained
Commitment `CM-00003`, Regulation responsibility `RS-00001`, regulated assembly
`AS-00001` and protected assembly `AS-00002`. It reported `CREATE`,
`ESTABLISHED`, `INITIAL` and `beforePhysicalDispatch=true`.

Existing D0155 Control then admitted `25 km/h` and tightened under the same
`CM-00003` through `21`, `16`, `10` and `1 km/h`, ending in unchanged
`INTENT_REVELATION_CREEP`. At approximately `19:25:55.200`, actuation quiesced
when the excursion pair was no longer positively closing while the relationship
remained retained. This validates explicit `RS-*` Regulation establishment
distinct from retained `CM-*`, establishment before physical dispatch, existing
elastic magnitude policy, and responsibility persistence while current physical
actuation disappears.

The worker subsequently accelerated and turned; Condor was reported blocked at
approximately `19:26:02.456`, Patriot at `19:26:02.953`, and both were stationary
and blocked by approximately `19:26:05`. **Spatial Risk Outlives Closing
Evidence**: current Situation evidence ceased requesting temporal actuation when
instantaneous positive closing disappeared even though constrained-corner risk
remained. Regulation behaved according to supplied Situation evidence. This is
consistent with, but does not solve or fully specify, the [Spatial Constraint
Overlay implementation gap in issue #37](https://github.com/bisdat/FS25_OuttaMyWay/issues/37).

The log contained zero `RESPONSIBILITY_REPLACED` and zero
`COOPERATIVE_PASSAGE_REVISE` events. Other Passage events did not constitute the
target same-Commitment succession. Therefore the PR #41 replacement seam,
distinct predecessor/successor `RS-*` identities, and live replacement ordering
before `COOPERATIVE_ACCEPTED` remain **not GIANTS Reality-validated**. The
fixture ceased requesting Regulation before the constrained interaction was
safely resolved, so this attempt neither validates nor disproves the replacement
implementation. Further use of this corner fixture is confounded by the upstream
Situation/Spatial Constraint Overlay gap.

## Regulation naming governance

D-number runtime vocabulary such as `D0141_APPLY`, `D0141_UPDATE`,
`D0141_ACTUATION_QUIESCENT`, `D0146_ACTION_SPACE_DECISION_APPLIED` and
`D0155_ENVELOPE_UPDATE` is transitional implementation debt, not accepted
Regulation terminology. Under the [Naming Conventions](NAMING_CONVENTIONS.md),
Decision identifiers record provenance and must not become primary module or
architectural names.

The extracted architecture-facing seam already uses
`FollowerBoundaryResponsibilityTransition`,
`FOLLOWER_BOUNDARY_RESPONSIBILITY_TRANSITION_REQUIRED`,
`FOLLOWER_BOUNDARY_TRANSITION_UPSTREAM` and `continueFollowerBoundary()`.
Retained downstream `D0141_*` vocabulary remains unchanged solely to isolate
behaviour in this tranche. Do not infer accepted terminology from it or create a
naming-cleanup increment here.

Remaining Regulation semantic runtime names should be graduated only after
D-0141 and D-0146 have both been extracted and validated, their exemplars have
been compared, and the explicit Regulation representation is stable. Historical
D-identifiers may remain as genuine provenance, including tests that clearly
document historical decision contracts.

## Follower HUD Glyph Compatibility Leak

GIANTS texture-font Reality reported missing character `8226` because retained
follower-regulation HUD text still uses `•`. This is separate UI implementation
debt, not Regulation architecture or PR #35 acceptance evidence. It is not fixed
in this tranche and should use ASCII-safe punctuation when later addressed.

## Forward Intersection tranche for Spatial Constraint

[Issue #37](https://github.com/bisdat/FS25_OuttaMyWay/issues/37) remains open as
non-blocking Category-2 Reality validation debt. GIANTS Reality first
falsified the half-working-width representation hypothesis; subsequent
`0.3.0.8` Reality validated the replacement Category-1 Forward Intersection
behaviour. **Spatial Width Is Not Temporal
Conflict Evidence**: half working width cannot decide whether supported future
trajectories intersect.

```text
two finite, positively supported Field-bounded continuations
        ↓
common Forward Intersection within both extents
        ↓
positive time-to-intersection evidence
        ↓
greater-time participant yields at fixed 1 km/h
        ↓
fresh Reality maintains or promptly releases Regulation
```

`SpatialConstraintAssessment` owns centreline intersection and timing. Candidate,
responsibility and Control consume that Situation knowledge rather than deriving
geometry again. Category 1, Category 2 and open field annotate the future theatre
after the generic relationship is established; they are annotations, not admission
mechanisms. No corner radius, width gate, pair-closing requirement or replacement
for the retired 80 m literal exists.

Where both positive rates support ordering, the greater-time party is selected
as temporal yielder and the retained Regulation substrate applies fixed 1 km/h
Intent-Revelation Creep. Missing rate or exact equal time is unresolved. Fresh
loss of the intersection dissolves the purpose and releases its lease.

**Established Relationship Precedence** prevents this prospective geometry from
displacing a valid follower relationship. Follower Regulation remains variable
speed, including reversing-leader handling. Bubble Bullet Time remains a separate
fixed-1-km/h purpose despite sharing the magnitude.

The successful `0.3.0.8` GIANTS Reality run validated Category-1 prospective
recognition, greater-time temporal yielding, fixed 1 km/h actuation, fresh-evidence
release and downstream Cooperative Passage succession. The run also supplied
positive open-field admission/release evidence. It did not revalidate established
leader/follower precedence or Bubble Bullet Time.

Category-2 Reality validation remains outstanding for Issue #37 closure, but no
longer blocks programme progression. Phase 8 is **ASSUMED COMPLETE FOR PROGRAMME
PROGRESSION**. Materially contrary Category-2 evidence must reopen the affected
Forward Intersection assumptions and dependent conclusions. **Phase 9 — Resolve
Regulation-to-Passage succession and Same-Commitment Responsibility Fusion** is
active; the PR #41 Action-Space Regulation → same-Commitment Cooperative Passage
replacement is again the downstream validation/reconciliation boundary.

# Intermediate Programme Steps

1. **Record the transition map — COMPLETE.**
2. **Extract Cooperative Passage Responsibility Transition before Control — COMPLETE.**
3. **Validate the first strangler seam and behavioural equivalence — COMPLETE for the observed direct Cooperative Passage `CREATE` path.**
4. **Extract completed-obstruction physical Resolution responsibility — COMPLETE.**
5. **Validate the second Resolution exemplar — COMPLETE for the observed in-session `CREATE` → `MAINTAIN`, `COMPACT` → `INFIELD` episode.**
6. **Compare the two migrated Resolution exemplars and determine the smallest truthful explicit Resolution Commitment representation — COMPLETE for the read-only adapter/view hypothesis.**
7. **Expose Resolution Commitment explicitly only where the two exemplars support it — COMPLETE and GIANTS Reality-validated for the observed direct Cooperative Passage `CREATE` and completed-obstruction `CREATE` → `MAINTAIN`, `COMPACT` → `INFIELD` exemplars.**
8. **Reconcile standalone Regulation — ASSUMED COMPLETE FOR PROGRAMME PROGRESSION.** The follower-boundary and Action-Space exemplars, subsequent explicit Regulation identity/replacement work, and successful Category-1 Forward Intersection Reality exemplar provide sufficient evidence to continue the strangler. Issue #37 remains open for non-blocking Category-2 Reality validation; materially contrary later evidence reopens this assumption.
   - **8a. Extract D-0141 follower-boundary Regulation application/revalidation upstream — COMPLETE and GIANTS Reality-validated for the observed establishment, same-responsibility revalidation, elastic update, quiescence and reactivation episode. Positive retirement was not observed and was not required.**
   - **8b. Extract D-0146 Action-Space Regulation as the second standalone exemplar — IMPLEMENTED and offline-validated; GIANTS Reality attempt inconclusive because the saved-corner Situation bypassed Action-Space Regulation upstream of the extracted seam.**
   - **8c. Compare both exemplars and determine the smallest truthful explicit Regulation representation — ARCHITECTURAL COMPARISON COMPLETE; implementation discovery found no truthful retained Regulation instance identity witness, so the Responsibility Instance Identity Gap required the later explicit Action-Space identity seam and Phase 9a follower generalisation.**
9. **Resolve Regulation-to-Passage succession and Same-Commitment Responsibility Fusion — IN PROGRESS. Phase 9a implements follower-boundary as the second explicit Regulation identity exemplar, sharing the Action-Space concept and same-Commitment Passage replacement boundary. Direct Resolution `CREATE` and completed-obstruction identity remain the next boundary.**
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
| Situation Assessment | [`scripts/assessment/SituationAssessment.lua`](../scripts/assessment/SituationAssessment.lua) and focused collaborators in [`scripts/assessment/`](../scripts/assessment/), including representation-only prospective constraint knowledge in [`scripts/assessment/SpatialConstraintAssessment.lua`](../scripts/assessment/SpatialConstraintAssessment.lua) |
| Candidate, Constraint and Decision boundary | [`scripts/candidates/`](../scripts/candidates/), [`scripts/constraints/`](../scripts/constraints/), [`scripts/decision/`](../scripts/decision/), and [`scripts/commitment/DecisionCommitmentBoundary.lua`](../scripts/commitment/DecisionCommitmentBoundary.lua) |
| Commitment, Obligation and Bounded Authority | [`scripts/commitment/`](../scripts/commitment/) and [`scripts/authority/`](../scripts/authority/) |
| Regulation identity, preservation, termination and same-Commitment Passage replacement | [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua), [`scripts/contracts/Regulation.lua`](../scripts/contracts/Regulation.lua); Runtime connects terminal settlement to follower semantic cleanup |
| Explicit Resolution Commitment view | [`scripts/contracts/ResolutionCommitment.lua`](../scripts/contracts/ResolutionCommitment.lua), [`scripts/responsibility/ResolutionCommitmentAdapter.lua`](../scripts/responsibility/ResolutionCommitmentAdapter.lua), and the two purpose-specific transition modules in [`scripts/responsibility/`](../scripts/responsibility/) |
| D-0141 follower-boundary Regulation transition and downstream Control | [`scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua`](../scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua), [`scripts/commitment/LiveTrafficCommitmentLifecycle.lua`](../scripts/commitment/LiveTrafficCommitmentLifecycle.lua), and [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) |
| Action-Space Regulation transition and downstream Control | [`scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua`](../scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua), [`scripts/commitment/LiveTrafficCommitmentLifecycle.lua`](../scripts/commitment/LiveTrafficCommitmentLifecycle.lua), and [`scripts/control/LiveControlDispatcher.lua`](../scripts/control/LiveControlDispatcher.lua) |
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
