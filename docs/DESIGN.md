# Design

> **Authority:** Replacement-core design boundary
>
> **Currency:** v4.7.13 Field World Equivalence Authority Architecture Candidate; v4.6.78 remains the replacement-core foundation
>
> **Implementation status:** v4.7.12 passive runtime preserves immutable Field World evidence; ADR-0021 authority is not implemented; Control disabled

## Purpose

OuttaMyWay coordinates native GIANTS AI field workers inside one field through the least disruptive justified augmentation. It preserves GIANTS ownership of job generation, route execution and agronomic work.

The replacement core is designed around explicit responsibility rather than scenario-specific controller phases.

## Architectural shape

```text
Observation
→ Situation Assessment
→ Operational Picture
→ Candidate Action Space
→ mandatory constraint and composition validation
→ Decision
→ Commitment
→ bounded Control
→ Outcome Observation
```

## Component responsibilities

### Observation

- sample Reality;
- retain source, timestamp and provenance;
- expose uncertainty;
- report Control outcomes.

Observation does not interpret operational meaning.

### Situation Assessment

- maintain identity and relevance;
- construct Current and bounded Future Space;
- assess Committed Demand, Potential Demand and Temporary Slack;
- evaluate Representation Fitness;
- publish constraints, uncertainty and evidence gaps.

Situation Assessment produces Knowledge only.

### Decision

- determine whether augmentation is required;
- construct the complete supportable Candidate Action Space;
- apply mandatory architectural constraints;
- validate Effective Actuation Composition;
- create, maintain, revise or settle Commitments.

Decision does not actuate vehicles.

### Commitment

- preserve continuing objective and Governing Basis;
- own the lifecycle state;
- own the Obligation Set;
- own objective-progress actuation authority for the selected assembly;
- preserve evidence contracts, capability reservations and terminal cause;
- prevent capability completion from being mistaken for terminal completion.

### Control

- accept only bounded capability requests;
- validate current authority and composition;
- execute the requested capability;
- report physical outcomes;
- reconcile and release owned temporary effects.

Control does not choose roles, strategies, refuge policy or terminal dispositions.

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

Decision evaluates viability before preference.

A lower-preference candidate remains valid when it is the only clear supportable option. The opposite lateral side is not excluded merely because another side is normally cheaper.

Preference bands:

1. least disruptive temporal shaping;
2. safe waiting outside another worker's required space;
3. bounded spatial displacement;
4. more disruptive but still supportable movement/configuration;
5. explicit failure/escalation when no supportable autonomous candidate remains.

The architecture does not require this exact numerical ordering in code; it requires preference exhaustion not to masquerade as candidate exhaustion.

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

It owns:

- clearing the conflict;
- leaving the assembly in a stable, representable and controllable state;
- releasing temporary authority;
- observing native continuation;
- completing terminal obligations.

GIANTS owns the exact continuation once unrestricted authority is returned.

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
