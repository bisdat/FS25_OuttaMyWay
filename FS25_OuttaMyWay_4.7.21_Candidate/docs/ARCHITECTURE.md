# Architecture

## Field World Equivalence Authority

A Field World is the experienced contiguous agronomic workspace represented by one or more immutable Job-Seeded Field World Snapshots. Exact sampled-boundary equality is not required: GIANTS may return seed-dependent polygon representations for the same workspace. Player-facing field labels, farmland identity, seed position and exact fingerprints remain evidence or locators; none independently governs Field World or Operation identity.

Field World Equivalence Authority produces exactly one outcome when a Snapshot is resolved against established Field World evidence:

- `SAME_FIELD_WORLD` — positive, coherent evidence establishes materially the same contiguous workspace;
- `DIFFERENT_FIELD_WORLD` — positive separation evidence establishes materially different workspaces;
- `UNRESOLVED` — evidence is insufficient, contradictory or only partially compatible.

`SAME_FIELD_WORLD` requires compatible connected topology, reciprocal workspace coverage, bounded representation variation and no materially exclusive region. `DIFFERENT_FIELD_WORLD` requires positive evidence such as disconnected occupied regions, substantial mutually exclusive area, incompatible topology or material spatial separation. No individual metric may establish either result alone.

Equivalence must remain coherent across the accepted evidence for the Field World as a whole. A pairwise match with one retained Snapshot is insufficient, and tolerance chaining must not construct an incoherent identity class.

`UNRESOLVED` preserves the Snapshot and observation evidence but grants no authority to join or establish an Operation and cannot extend Control authority.

## Representation provenance

Every Job Episode retains its immutable GIANTS-generated polygon, canonical representation, exact fingerprint, capture provenance and player-facing locators. Recognising Field World equivalence does not merge, rewrite or discard those records. Exact canonical geometry equality is sufficient for `SAME_FIELD_WORLD`; an exact fingerprint remains a compact provenance reference and collision detector, and fingerprint equality alone is not independent Field World identity authority.

## Operation consumption

Operation admission consumes resolved Field World identity. An Operation remains ephemeral: successive Operations in the same Field World are not one persistent Operation. The active v4.7.12-derived implementation still groups by exact fingerprint and is therefore explicitly provisional and non-conforming with this authority contract.

## Supported-world rule

The polygon remains an immutable Job Episode Snapshot. Mid-episode external field merging or splitting is not reconciled. A restarted or replacement Job Episode captures current Reality.

> **Authority:** Normative replacement-core architecture, extended by ADR-0021  
> **Canonical implementation baseline:** owner-declared v4.7.12  
> **Implementation status:** Field World Equivalence Authority not implemented; exact-fingerprint Operation grouping provisional; Control disabled  
> **Governing ADRs:** [ADR-0019](adr/ADR-0019-replacement-core-commitment-lifecycle.md), [ADR-0021](adr/ADR-0021-field-world-equivalence-authority.md)

## 1. Purpose

OuttaMyWay augments native GIANTS AI field workers so that independently generated jobs can coexist inside one field without preventable collision, deadlock or repeated player rescue.

The architecture defines what the cooperative system must achieve. Implementation will discover how those responsibilities can be realised through GIANTS extension points. Runtime convenience must not weaken architectural obligations.

The system remains a light-touch exception handler:

```text
normal GIANTS operation
        ↓
Situation Assessment detects material augmentation need
        ↓
Decision establishes one bounded Commitment
        ↓
Control executes only authorised capabilities
        ↓
observed Reality validates, revises or disproves the hypothesis
        ↓
GIANTS resumes unrestricted ownership when terminal settlement permits
```

OuttaMyWay does not replace GIANTS route generation, agronomic job ownership or ordinary field-work execution.

## 2. Scope boundary

### In scope

- simultaneous native GIANTS AI field workers inside one Field World;
- player-controlled and completed assemblies when their occupancy affects active workers;
- bounded local prediction through the next material manoeuvre and trajectory settlement;
- temporary speed, hold, movement, orientation and configuration-related authority where supported;
- Terminal Occupancy resolution;
- continuing observation, evidence acquisition and obligation settlement;
- safe return of authority to GIANTS.

### Out of scope

- map-wide navigation to a field;
- general route planning or route substitution;
- replacement worker AI;
- Courseplay-style predetermined multi-vehicle routing;
- combine/wagon offloading coordination;
- multiple-combine harvesting systems;
- behavioural control of the player;
- treating Temporary Slack as permanently released space.

Reverse is architecturally available as a possible movement capability. Reverse Actuation Discovery remains an implementation and validation activity.

## 3. Foundational distinctions

### Reality, Observation and Knowledge

- **Reality** is the world as it exists.
- **Observation** is sourced evidence sampled from Reality.
- **Knowledge** is the system's current interpretation of those observations.
- **Situation Assessment** produces Knowledge only.
- **Decision** decides whether augmentation is required and what action is admissible.
- **Control** executes bounded authority and reports realised outcomes.

No layer may silently substitute its interpretation for another layer's responsibility.

### Situation, Encounter and Commitment

- A **Situation** may persist while entities remain materially relevant.
- An **Encounter** is one locally coherent interaction within that Situation.
- A **Commitment** is Decision-owned continuing responsibility established to achieve one governing objective.

A persistent Situation does not imply a permanent Encounter or Commitment. Repeated Encounters may occur between the same assemblies.

### Assembly and Job Episode identity

Assembly identity may persist across stops, player control and restarted work.

A **Job Episode** is one independently admitted GIANTS AI job instance. Its identity ends when:

- the player manually stops the worker;
- the player enters or takes control;
- GIANTS aborts or faults the job;
- the job is replaced or restarted.

The following do not end a Job Episode:

- the worker becomes blocked;
- OuttaMyWay temporarily Holds it;
- temporary loss of movement while the admitted job remains authoritative.

A restarted or replacement job is independently admitted even when the assembly, work type and apparent purpose are unchanged.

## 4. Bounded Field World and space knowledge

The field polygon defines the bounded Field World for one Operation. OuttaMyWay does not assume responsibility for arbitrary external navigation or obstacles.

Full-Envelope Field Containment remains mandatory: the complete represented assembly and its relevant movement/configuration sweep must remain within the field polygon for any OuttaMyWay-authorised repositioning.

While any worker remains active, intra-field space is not permanently released. Situation Assessment may support only:

- **Committed Demand** — space required by current admitted continuation;
- **Potential Demand** — space plausibly required by a future local continuation;
- **Temporary Slack** — space not currently demanded but not permanently relinquished.

Historical coverage, current vacancy or completion of one pass cannot establish permanent release.

## 5. Replacement-core information flow

```text
Reality
    ↓
Observation adapters
    ↓
Situation Assessment
    ↓
Operational Picture Knowledge
    ↓
Complete supportable Candidate Action Space
    ↓
Mandatory constraint and composition verdicts
    ↓
Decision selection
    ↓
Commitment
    ↓
Bounded Control authority
    ↓
Outcome Observation
    ↺
```

### Situation Assessment

Situation Assessment maintains:

- Entity and assembly identity;
- Operation Participation and Situation Relevance;
- Current Space and bounded Future Space;
- Committed Demand, Potential Demand and Temporary Slack;
- representation provenance, confidence and Representation Fitness;
- applicable environmental and architectural constraints;
- observed Control outcomes;
- uncertainty and evidence gaps.

Situation Assessment does not select roles, strategies, terminal dispositions or Control actions.

### Candidate Action Space

Decision must evaluate the complete set of actions currently supportable by available representation, authority and capability. Preference-band exhaustion is not total candidate exhaustion.

A candidate may be rejected because it is:

- physically inadmissible;
- outside Field World containment;
- unsupported by Representation Fitness;
- incompatible with current obligations or authority;
- compositionally unsafe;
- unavailable through proven Control capability;
- insufficient for the governing purpose.

The absence of a preferred candidate does not authorise an unsafe special case.

### Mandatory constraint enforcement

Architectural constraints are admissibility gates, not advisory annotations. A candidate receives authority only after every applicable constraint has been evaluated sufficiently for that action.

Control may reject stale or compositionally changed authority. It may not waive or reinterpret Decision constraints.

## 6. Continuing Intent Priority

A live admitted intent continues to govern ordinary resolution until it genuinely ends or another independently admitted authoritative intent replaces it.

Therefore:

- blockage does not end intent;
- temporary inactivity does not end intent;
- OuttaMyWay Hold does not end intent;
- strategy failure does not end intent;
- insufficient evidence does not end intent;
- confirmed player stop/takeover ends the affected AI Job Episode;
- confirmed GIANTS abort/fault ends it;
- a newly admitted replacement intent supersedes it.

Continuing Intent Priority governs ordinary `ACTIVE` and `WAITING_FOR_EVIDENCE` behaviour. It ends when the Commitment enters `SETTLING`.

## 7. Commitment contract

A Commitment begins only after Decision establishes enforceable continuing intent. Candidate proposals are not Commitments.

Conceptually, each Commitment records:

```text
Identity
Objective
Governing Basis
Lifecycle state
Strategy
Situation dependencies
Obligation Set
Progress-actuation owner
Capability reservations
Validated Effective Actuation Composition
Evidence contracts
Intended terminal disposition
Terminal cause
Terminal settlement evidence
```

### Governing Basis

The **Governing Basis** identifies the admitted intent or intent set and Operation context that make the Commitment objective applicable.

A participant state change terminates or supersedes a Commitment only when it invalidates that Governing Basis. Incidental changes to another participant do not automatically terminate every Commitment that observes it.

The first authoritative event that invalidates the Governing Basis determines the intended terminal cause. Later events may affect settlement or create a successor, but do not rewrite history.

## 8. Commitment lifecycle

The replacement core has three non-terminal states.

### `ACTIVE`

The Commitment owns an applicable objective and may progress toward it.

It may:

- observe and reassess;
- revise strategy;
- evaluate candidates;
- issue authorised progress Control;
- preserve immediate safety;
- create, satisfy or transfer eligible obligations;
- enter `WAITING_FOR_EVIDENCE`;
- begin terminal settlement.

Multi-stage movement, capability changes, retries and refuge revisions remain one Commitment while the Governing Basis and objective remain applicable.

### `WAITING_FOR_EVIDENCE`

The Commitment remains responsible, but evidence is insufficient to justify further progress Control.

It may:

- observe;
- acquire evidence under an explicit evidence contract;
- maintain bounded immediate safety;
- preserve only necessary existing effects;
- return to `ACTIVE` when sufficient evidence arrives;
- enter `SETTLING` through a fail-safe or terminal cause.

It may not:

- treat elapsed time as confirmation;
- infer success from silence or inactivity;
- initiate speculative progress;
- abandon responsibility because evidence is unavailable.

Every evidence contract identifies:

- the unresolved proposition;
- expected evidence;
- evidence provenance;
- preserved useful action;
- exhaustion condition;
- reassessment deadline;
- fail-safe exit.

### `SETTLING`

Ordinary objective-progress authority has ended, but unresolved obligations remain.

It may:

- observe;
- reconcile Control it issued;
- obtain settlement evidence;
- release capability authority;
- satisfy obligations;
- establish evidenced basis cessation;
- transfer eligible obligations atomically;
- maintain bounded immediate safety.

It may not:

- revive the ended objective;
- select a new strategy for that objective;
- issue new objective-progress Control;
- terminate while an obligation remains unaccounted for.

`SETTLING` carries an intended terminal disposition. The disposition becomes final only at Terminal Settlement.

## 9. Obligation architecture

An **Obligation** is an owned requirement that remains in force while its basis remains valid and until an evidenced settlement disposition occurs.

Every obligation has:

- stable identity;
- origin;
- basis;
- exactly one current owning Commitment;
- required outcome;
- required authority;
- evidence contract;
- transfer policy;
- terminal dependency;
- settlement disposition.

An obligation settles only through:

1. **Satisfaction** — its required outcome is achieved and evidenced.
2. **Basis cessation** — authoritative evidence proves the condition requiring it no longer exists.
3. **Accepted transfer** — an eligible successor Commitment atomically accepts ownership.

No obligation may become ownerless.

### Ownership classes

#### Origin-bound

Cannot transfer:

- reconcile Control issued by the Commitment;
- prove predecessor effects ceased;
- release acquired authority;
- record terminal cause and provenance;
- record accepted transfers.

#### Continuity

May transfer to an eligible accepting Commitment:

- immediate physical safety;
- stable Configuration Integrity;
- continuing clearance;
- Terminal Occupancy resolution;
- observation of a still-relevant hazard.

#### Intent-relative

Remain valid only while a particular intent requirement remains authoritative:

- return to the former working line;
- resume the former Job Episode;
- complete a former refuge strategy;
- restore a configuration required only by the displaced intent.

A new authoritative intent may close these through evidenced basis cessation.

### Recognised internal owner

All internal obligations are owned by Commitments.

The Operation, Situation Assessment, Decision and Control layers are not fallback obligation owners. The player is an external actor with physical agency, not an internal Obligation owner.

If no eligible successor exists, the current Commitment remains in `SETTLING`.

## 10. Authority integrity

Many Commitments may observe or reason about one assembly. Only one Commitment may own objective-progress actuation for that assembly at a time.

Capability reservations refine that ownership but do not permit independent progress authorities to act through different capabilities on the same assembly.

### Effective Actuation Composition

Every proposed action must be validated as part of the complete **Effective Actuation Composition**, including:

- existing commands;
- capability reservations;
- residual predecessor effects;
- simultaneous actions on relevant assemblies;
- Future-Space interactions;
- global invariants such as never holding all participants.

Decision validates the composition before authorisation. Control validates that the composition remains materially current immediately before actuation.

A mechanically valid action is inadmissible when its combined effect is unsafe.

### Safety authority

Bounded safety inhibition may prevent unsafe progress while ordinary capability ownership is unavailable or ambiguous. Safety authority is a veto/protective constraint, not a second progress owner.

## 11. Terminal settlement

A Commitment may enter a terminal disposition only after every obligation has been:

- satisfied;
- closed through evidenced basis cessation; or
- atomically transferred to an eligible accepting Commitment.

This point is the **Terminal Settlement Point**.

### Safe Release Point

A Terminal Settlement Point where no continuing responsibility transfers to a successor.

### Safe Handover Point

A Terminal Settlement Point where continuing obligations transfer to a successor Commitment, or where external physical agency changes while internal coordination responsibilities remain correctly owned.

Intent authority may change immediately. Physical actuation authority transfers only when conflicting predecessor effects are reconciled.

## 12. Terminal dispositions

### `SUCCEEDED`

The objective was achieved and Terminal Settlement completed.

### `FAILED`

The applicable objective could not be achieved, but all resulting obligations were safely settled. Structured causes may include:

- supportable candidates exhausted;
- Representation Fitness insufficient;
- required capability unavailable;
- Control failure;
- evidence fail-safe exhausted;
- autonomous resolution unavailable.

### `SUPERSEDED_BY_NEW_INTENT`

A newly admitted authoritative intent displaced the Governing Basis of a still-live Commitment.

The successor owns progress under the new intent. The predecessor enters `SETTLING`, retains origin-bound obligations and may transfer eligible continuity obligations.

### `CANCELLED_BY_SOURCE_INTENT_TERMINATION`

The governing source Job Episode genuinely ended without being replaced by a newly admitted authoritative intent.

Structured causes include player stop, player takeover, GIANTS abort and GIANTS fault.

### `CANCELLED_BY_OPERATION_TERMINATION`

The Operation context forming the Governing Basis ended and no continuing operational basis remained.

Operation membership reaching zero does not instantly terminate the Commitment. Origin-bound Control, authority, configuration and evidence obligations keep it in `SETTLING` until resolved.

## 13. Intent Supersession

A newly admitted replacement Job Episode becomes authoritative immediately.

During the bounded **Supersession Handover Interval**:

- the successor is the Governing Successor;
- the predecessor is the Settling Predecessor;
- old objective-progress authority ends immediately;
- the predecessor reconciles its own effects;
- the successor may assess and prepare immediately;
- successor actuation is bounded by unavailable or reserved capabilities;
- eligible obligations transfer only through atomic acceptance;
- conflicting progress Control is forbidden.

`SUPERSEDED_BY_NEW_INTENT` becomes terminal only after predecessor Terminal Settlement.

## 14. Player takeover

Player takeover ends the affected AI Job Episode and OuttaMyWay progress authority over that player-controlled assembly.

It does not transfer internal Obligation objects to the player.

The settling Commitment must still:

- reconcile OuttaMyWay-issued Control;
- release acquired authority;
- reassess intent-relative obligations;
- preserve or transfer continuing safety and spatial obligations;
- continue representing the player-controlled assembly as an obstacle where relevant.

Player control transfers physical actuation agency, not necessarily Situation responsibility.

## 15. Terminal Occupancy

A completed worker may leave ordinary Operation Participation while its assembly remains Situation-relevant.

A Terminal Occupancy Commitment is justified when:

```text
completed-worker occupancy
materially affects
Committed Demand or Potential Demand
of active workers
```

Its obligations may include:

- Spatial Responsibility;
- Physical Safety;
- Evidence Integrity;
- Configuration Integrity.

It settles when:

- occupancy is physically resolved;
- an eligible successor Commitment accepts the continuing obligation; or
- relevant active demand demonstrably ceases.

Physical presence alone does not create a permanent obligation after all active demand has ended.

## 16. Operation termination

Commitment lifecycle and Operation membership are separate.

When ordinary Operation membership reaches zero:

- demand-dependent spatial obligations may close through basis cessation;
- issued Control must still be reconciled;
- authority must still be released;
- the assembly must remain in a stable, representable and controllable state;
- terminal evidence and provenance remain required.

A Commitment may outlive ordinary Operation participation in `SETTLING`. No generic remnant owner is required.

## 17. Representation Fitness and candidate exhaustion

Representation Fitness determines which conclusions and actions available Knowledge can support.

Partial representation does not necessarily prevent every action. It removes only claims whose safety depends on missing evidence.

No Silent Under-Approximation remains mandatory: unknown or partial geometry must not be represented as smaller than the available evidence supports.

Preference bands are exhausted sequentially. Only exhaustion of the complete supportable Candidate Action Space may justify autonomous-resolution failure.

## 18. Multi-stage strategy continuity

A Commitment remains one Commitment across:

- slow/hold/refuge progression;
- multiple manoeuvre legs;
- orientation before translation;
- candidate revision at settled boundaries;
- configuration transition;
- Native Handover;
- return to GIANTS;
- bounded evidence waits.

A stage or capability may complete without the Commitment completing.

Strategy revision must preserve:

- Commitment identity;
- Governing Basis;
- open Obligation Set;
- authority history;
- evidence provenance.

## 19. Eight must-not-be-deferred questions

1. **When does a completed worker remain relevant?**  
   While its assembly materially affects active demand, safety, representation, evidence, configuration or another open obligation.

2. **Does Continuing Intent Priority govern ordinary resolution?**  
   Yes, until the source intent genuinely ends or a new authoritative intent is independently admitted.

3. **What obligations does Terminal Occupancy create?**  
   Spatial Responsibility, Physical Safety, Evidence Integrity and, where required, Configuration Integrity.

4. **How do multi-stage strategies remain one Commitment?**  
   Stages and capability changes revise execution without replacing the Governing Basis, identity or Obligation Set.

5. **What constitutes terminal settlement?**  
   Every obligation is satisfied, closed through evidenced basis cessation or atomically transferred to an eligible accepting Commitment.

6. **When may responsibility transfer to the player?**  
   Physical actuation agency changes when player control is evidenced. Internal obligations do not transfer to the player; continuing coordination remains internally owned.

7. **What is the scope of route substitution?**  
   General route substitution and route ownership are outside the replacement core.

8. **What happens if an Operation ends with an unresolved remnant?**  
   The owning Commitment remains in `SETTLING`; demand-dependent obligations may lose basis, while origin-bound obligations remain until settled.

## 20. Implementation boundary

v4.7.0 established the inert structural foundation. v4.7.1 added offline raw Observation publication and canonical assembly/Job Episode identity and admission rules. v4.7.2 adds admitted Operation identity and deterministic Situation Assessment publication of the Operational Picture. Candidate generation, mandatory verdict evaluation, Decision and Control remain unimplemented. The archived v4.6.78 runtime is evidence and donor material only.

Implementation must proceed separately from architecture and should begin with:

1. explicit value contracts and identities;
2. passive lifecycle and obligation traces;
3. state-transition tests;
4. Effective Actuation Composition shadow validation;
5. isolated migration of one bounded Control capability;
6. runtime validation against observed Reality.

Numerical thresholds, Native Continuation Speed estimation, Reverse Actuation Discovery and exact capability adapters remain implementation or empirical discoveries. They may refine implementation without altering the ownership and lifecycle model unless Reality disproves it.

## 21. Normative companion contracts

Implementation must also conform to:

- `ARCHITECTURE_CONFORMANCE_MATRIX.md`;
- `COMMITMENT_STATE_MACHINE.md`;
- `CANDIDATE_ACTION_CONTRACT.md`;
- `RESPONSIBILITY_MAP.md`;
- `REPLAY_VALIDATION_SPECIFICATION.md`;
- `MIGRATION_PLAN.md`;
- `REMOVAL_REGISTER.md`.

These documents refine implementation proof and migration discipline. They do not introduce another architectural subsystem.