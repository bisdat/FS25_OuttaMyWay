# Design

> **Authority:** Replacement-core design boundary
>
> **Currency:** v4.7.77 D-0142 architecture candidate; owner-declared canonical v4.7.76 is the implementation baseline
>
> **Implementation status:** v4.7.77 changes architecture/documentation only. The v4.7.76 runtime remains behaviourally unchanged and contains legacy P22/head-on/follower/Guarded-Recovery mechanisms pending D-0142 alignment.

## Purpose

OuttaMyWay coordinates native GIANTS AI field workers inside one field through the least disruptive justified augmentation. It preserves GIANTS ownership of job generation, route execution and agronomic work.

The replacement core is designed around explicit responsibility rather than scenario-specific controller phases.

## Architectural shape

```text
Reality
→ Observation
→ Situation Assessment
→ Operational Picture Knowledge
→ Candidate Action Space
→ Mandatory Constraints
→ Traffic Policeman / Decision
→ Commitment + Obligations
→ Bounded Authority
→ Control
→ GIANTS / Outcome Observation
```

## Component responsibilities

### Observation

- sample Reality;
- retain source, timestamp and provenance;
- expose uncertainty;
- report raw physical/Control outcomes.

Observation does not assign Productive/Transitional meaning or traffic policy.

### Situation Assessment

- maintain Field World identity, participation and positive cooperative relevance;
- establish Productive Regime / Rook Knowledge;
- maintain positive productive-history colouring;
- derive Successor Rook Set and bounded Transitional Demand;
- evaluate configuration/phase-specific Representation Fitness;
- maintain King Reserve Availability and Resolution-Space state;
- publish uncertainty and evidence gaps.

Situation Assessment produces Knowledge only.

### Operational Picture Knowledge

- publish immutable current supported Knowledge and provenance;
- contain no Candidate specifications or mandatory verdicts.

### Encounter Registry

- own active and terminal Encounter identity where Encounter lifecycle remains useful;
- bind each Encounter to current Operation/interactions/Job Episodes;
- terminate only from supported lifecycle evidence.

Encounter is lifecycle infrastructure, not a head-on/follower resolution class.

### Candidate Action Space

- enumerate complete supportable actions from Operational Picture Knowledge;
- represent exact bounded A↔R opportunities only where Knowledge supports them;
- identify Purpose/evidence/preconditions/invalidation without selecting among alternatives;
- never manufacture mandatory `PASS` verdicts.

### Mandatory Constraints

- independently evaluate Field World containment;
- evaluate phase-specific representation and transition fitness;
- evaluate Productive/Transitional/Committed Demand compatibility;
- evaluate obligation/capability/authority composition;
- return `PASS`, `FAIL` or `UNRESOLVED` without optimisation.

### Traffic Policeman / Decision

- determine whether augmentation/admission is required;
- select among admissible Candidate Actions;
- own temporary movement ordering;
- use Conflict Serialization to reduce concurrent complexity;
- refuse/adapt admission where progression would destroy local resolvability.

Decision does not plan routes or actuate vehicles.

### Commitment + Obligations

- preserve Governing Basis and continuing purpose;
- own lifecycle and Obligation Set;
- make the selected resolution relation durable;
- publish post-Decision Committed Demand;
- own objective-progress actuation authority;
- determine lifecycle meaning from physical outcomes.

### Bounded Authority

- specify the exact currently permitted physical phase/manoeuvre;
- expire/revalidate according to Commitment and current Reality.

### Control

- accept only bounded physical requests;
- Hold, Regulate native GIANTS speed, compact/restore, execute selected bounded displacement and relinquish;
- report physical outcomes.

Control does not select Refuge, infer HEAD_ON/follower classes, interpret Rook/King/Transitional Demand or settle Commitments.

## Commitment state model

The only non-terminal states are:

- `ACTIVE`
- `WAITING_FOR_EVIDENCE`
- `SETTLING`

The terminal dispositions are:

- `SUCCEEDED`
- `FAILED`
- `SUPERSEDED_BY_NEW_INTENT`
- `CANCELLED_BY_SOURCE_INTENT_TERMINATION`
- `CANCELLED_BY_OPERATION_TERMINATION`

Strategy stages are not lifecycle states.

## Data design principles

### Identity and value separation

Live GIANTS objects remain exact identity references. Architectural evidence is carried as allowlisted value snapshots. Generic recursive copying of engine objects is forbidden.

### Stable obligation identity

An Obligation retains identity and provenance across transfer. Transfer changes the current owning Commitment; it does not replace the obligation with an unrelated copy.

### Explicit Governing Basis

Every Commitment records which admitted intent and Operation context make its objective applicable.

### Evidence contracts

Any wait, release, settlement or transfer conclusion must identify the evidence required and the fail-safe response when evidence is not obtained.

### Representation Fitness

Representation is action-specific. Missing evidence may prohibit one action without prohibiting every conservative action. Unknown geometry may never be silently under-approximated.

## Authority design

- one objective-progress actuation owner per assembly;
- capability reservations subordinate to that owner;
- bounded safety veto available without becoming a second progress owner;
- predecessor/successor coexistence permitted only with authority partitioning;
- all proposed actions validated in the full Effective Actuation Composition.

## Candidate policy

Candidate generation exposes every complete supportable action from current Knowledge. Mandatory Constraints evaluate viability independently before Decision preference. A lower-preference candidate remains visible when it is the only supportable option; an alternate subject, side or direction is not excluded merely because an older scenario solver preferred another.

For the Traffic Policeman primary-resolution responsibility, Decision applies this strict sequential preference after mandatory gates:

1. `CONTINUE_OBSERVATION` — bounded maturation while useful evidence is emerging and enough Action Space remains to wait;
2. `REGULATE_SPEED` — bounded GIANTS-owned progression while some positive native movement can preserve/improve the governing traffic requirement;
3. `HOLD_AT_SAFE_POINT` — stationary waiting only when the current realised occupancy itself is a sufficient safe waiting state;
4. `NATIVE_REPOSITION` — bounded spatial displacement when the current occupancy cannot provide a sufficient Hold;
5. explicit escalation when the complete currently supportable autonomous Candidate Action Space is exhausted.

The ordering is mandatory **Decision preference**, not a procedural actuator sequence. A later primary band requires explicit exhaustion of every earlier band in the same Decision epoch, but rejected candidates need not be physically attempted. Material Reality/Control change creates a fresh epoch and reevaluation from the least-disruptive end. Supporting capabilities from an earlier band may coexist with a stronger primary Commitment when independently justified by a current obligation.

## Movement capability boundary

Movement is requested semantically and resolved through available assembly capability and current evidence.

Possible capabilities include:

- regulate speed;
- hold;
- forward movement;
- reverse movement;
- orientation;
- bounded reposition;
- configuration transition;
- authority release.

Reverse remains architecturally available but unproven. No fixed prototype speed, distance or manoeuvre is an architectural definition.

## Native handover

OuttaMyWay does not own exact lane reconstruction or GIANTS route recreation.

When OuttaMyWay materially displaces a worker under the ordinary local Refuge model, the Commitment owns restoration toward **Native Reacquisition Anchor A**, the positively demonstrated pre-egress pose/area where productive continuation and the deployed configuration were already valid.

The provisional ordinary sequence is:

```text
A (ROOK)
→ compact
→ KING
→ A→R
→ Hold at R
→ R→A
→ restore
→ GIANTS native reacquisition
```

The selected A↔R relation is post-Decision **Committed Demand** until the corresponding obligation is discharged or invalidated.

Control owns only authorised physical phases. Observation/Assessment determine whether GIANTS has positively reacquired native continuation; Commitment determines whether that evidence settles the obligation.

Historical Native Continuation Restoration / Rejoin Anchor / Guarded Recovery terminology remains evidence provenance, not permission to create independent routing or recovery-policy subsystems.

## Player boundary

The player is not a cooperative worker controlled by OuttaMyWay and is not an internal Obligation owner.

Player-controlled assemblies remain represented as physical entities when they affect active AI demand.

## Terminal Occupancy boundary

A completed worker may become a Terminal Occupancy subject. This is a Decision/Commitment concern, not a continuation of the completed Job Episode.

## Implementation order

1. introduce passive contracts and identities;
2. implement lifecycle trace without physical Control;
3. test transition precedence and obligation settlement;
4. implement shadow composition validation;
5. migrate one capability at a time;
6. validate against runtime evidence;
7. update architecture when Reality disproves it.

The v4.6.56 runtime remains the behavioural baseline. Experimental v4.6.57–v4.6.70 controllers are evidence donors only.

## Conformance artefacts

The replacement implementation is accepted only when the conformance matrix, state machine, Candidate Action contract, responsibility map and replay specification agree with the normative architecture. Module names or isolated tests are not sufficient evidence.
