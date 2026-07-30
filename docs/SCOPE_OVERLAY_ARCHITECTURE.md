# Scope Overlay Architecture

> **Authority:** Accepted architecture and calibrated evidence for candidate v4.6.23
>
> **Implementation state:** Architectural knowledge only; no runtime Scope Overlay is implemented

## Purpose

The Scope Overlay converts the reviewed base-game Semantic Catalogue into independent support, testing and runtime-relevance knowledge without treating semantic identity as behaviour, control authority or physical structure.

It protects four separations:

- semantic classification from OuttaMyWay treatment;
- catalogue membership from support eligibility;
- Control Eligibility from representation relevance;
- immediate local avoidance from Operation-level resolution.

The Scope Overlay is not one `IN_SCOPE` or `OUT_OF_SCOPE` flag. It is a set of contextual claims whose subjects, evidence and lifetimes differ.

```text
Reviewed Semantic Catalogue
        -> Scope Overlay
            -> test selection and supported-envelope knowledge
            -> runtime Situation Assessment knowledge
                -> Decision Engine constraints and commitments
                    -> Control and player communication
```

## Catalogue boundary

The Stage 2C catalogue remains the complete reviewed Giants base-game catalogue produced by the declared corpus and semantic-review process. Definitions are not removed because they are unlikely, unsuitable or unsupported for OuttaMyWay.

Catalogue membership records what a definition is and what capabilities its evidence supports. It does not establish:

- Giants AI job viability;
- OuttaMyWay Control Eligibility;
- Operation Participation;
- Assembly Relevance;
- Obstacle Relevance;
- runtime representation structure;
- test admission;
- support for paid DLC or mods.

This is **Catalogue Membership–Support Eligibility Separation**.

Paid DLC and modded definitions remain outside the present catalogue. A future bounded investigation may admit a declared external configuration, but external content does not silently alter the base-game evidence set or support promise.

## Supported Operational Envelope

OuttaMyWay's supported investigation envelope is intentionally narrower than the physically possible game world.

### Player Responsibility Boundary

The game permits the player to place or drive equipment in operationally implausible contexts. OuttaMyWay assumes reasonable player deployment and does not promise to understand or coordinate every game-permitted arrangement.

Crossing this boundary does not make a physical Entity invisible. An unsupported or implausible unit may remain represented, obstacle-relevant and operationally influential. The system excludes unsupported control, not observed reality.

### Base-Game AI Capability Envelope

The present capability baseline is the unmodified Giants base game represented by the reviewed catalogue.

The Base-Game AI Capability Envelope is the set of working configurations that unmodified Giants AI can execute. Mods or external packages may change specializations and expand what Giants AI can operate, but those changes do not automatically expand OuttaMyWay's supported operational envelope.

No category-specific exclusion is architectural. Balers, pickup-equipped forage wagons or a hypothetical AI-enabled forestry configuration are examples of the general baseline rule, not special cases.

## Giants AI job-configuration viability

The relevant capability subject is the **Giants AI job configuration as a whole**, including as applicable:

- the powered vehicle;
- attached implements or vehicles;
- the selected Giants AI job type;
- the working unit that must be operated;
- the required working behaviour.

A controllable powered vehicle does not prove that the complete job configuration is viable.

### Job Admission–Viability Separation

Giants may admit a job, start the engine and briefly expose an active worker before failing when control of an unsupported working unit is required.

```text
Job Admission
    != Job Configuration Viability
    != OuttaMyWay Control Eligibility
```

Successful admission or startup is therefore insufficient evidence.

### Capability Confirmation Point

The Capability Confirmation Point is the first point at which Giants AI successfully exercises the working behaviour required by the complete job configuration. It is an architectural evidence boundary, not a prescribed detection mechanism.

The current architecture recognises confirmed viable, confirmed non-viable and not-yet-established evidence. Exact machine states and observation rules remain implementation and validation work.

## The four Scope Overlay dimensions

The four dimensions are independent. A single Entity may be positive for all four, negative for some, or change state over time without semantic reclassification.

### 1. Control Eligibility Profile

The Control Eligibility Profile belongs inside the Scope Overlay. It describes whether a Giants AI job configuration is within the supported control-investigation envelope under the declared capability baseline.

It guides:

- positive candidate selection;
- known exclusion recording;
- unresolved evidence identification;
- bounded negative testing;
- downstream Control Exclusion Constraints.

It is not the runtime permission to issue a particular intervention.

#### Runtime Control Admissibility

Runtime Control Admissibility is a later contextual conclusion:

> May OuttaMyWay apply this proposed intervention to this particular Entity now?

It may depend on the Control Eligibility Profile, current Giants job state, Operation relationship, player control, available control mechanism, existing commitments and the proposed action.

```text
Control Eligibility Profile
        + runtime Entity state
        + Operation context
        + proposed intervention
        -> Runtime Control Admissibility
```

#### Control Exclusion Constraint

Known ineligibility is carried into the Operational Picture as a hard Control Exclusion Constraint. Downstream reasoning may account for the Entity but must not select it as an unsupported intervention target.

This establishes **Observe Broadly, Control Narrowly**:

> Relevant to understand does not imply eligible to control.

Situation Assessment produces the knowledge. The Decision Engine determines whether player communication is warranted. The Control or UI layer presents any message.

### 2. Operation Participation

Operation Participation is a temporal relationship between one runtime Entity and one specific Operation. It asks whether the Entity has a recognised functional relationship to the current field work.

Physical presence inside the field polygon or immediate margins is insufficient. Merely affecting progress is also insufficient.

#### Presence–Participation Separation

An Entity may be present without participating.

#### Participation–Obstacle Separation

An Entity may influence an Operation as an obstacle without participating in its work.

#### Operational Influence

Operational Influence records whether an Entity currently affects progress, options or completion. It is broader than participation. Obstacle Relevance is one source of Operational Influence.

Examples include:

```text
Active AI field worker
    -> participating; potentially obstacle-relevant

Player deliberately performing the same field work
    -> potentially participating; not automatically control-admissible

Completed worker parked clear
    -> not participating; not currently influential

Completed worker blocking a headland
    -> not participating; influential and obstacle-relevant

Unrelated unit crossing the field
    -> not participating; temporarily influential and obstacle-relevant
```

#### Participation Transition

Participation changes with observed state:

```text
Travelling to the field
    -> not participating

Performing recognised field work
    -> participating

Job completed or stopped
    -> no longer participating

Remaining in relevant space
    -> still represented and potentially obstacle-relevant
```

A Participation Potential Profile may guide test selection. Runtime Operation Participation belongs in the Operational Picture.

### 3. Assembly Relevance

Assembly membership and Assembly Relevance are distinct.

#### Assembly Membership

Assembly Membership is an observed physical or logical relationship indicating that runtime Entities or components currently form a connected or functionally unified configuration.

#### Membership–Relevance Separation

Membership alone does not prove that a member matters to the current assessment. Internal or decorative members may be structurally present but irrelevant to occupancy, movement or working behaviour.

#### Behavioural Assembly

A Behavioural Assembly is the set of connected runtime Entities and components whose combined state determines relevant:

- working behaviour;
- current occupied space;
- future movement or clearance;
- folding, unfolding, raising or lowering transitions;
- articulation and control response.

It may span multiple vehicle definitions, runtime roots, physics components and animated nodes. It does not merely reproduce the XML, visual or attachment hierarchy.

A member may be Assembly Relevant even when it is not independently controllable. Control Eligibility does not gate physical representation.

#### Dynamic Assembly Relevance

Members may remain constant while their contribution changes with pose or configuration. Folded, transitional and deployed states may require different occupancy and sweep evidence.

#### Player-Mediated Assembly Transition

Under the current base-game capability baseline, an AI worker does not detach its implement during a job. Attachment or detachment is player-mediated.

Detachment triggers reassessment of relationships rather than another pose of the former assembly:

```text
Attached implement
    -> Assembly Relevant to the Behavioural Assembly

Player detaches implement
    -> former assembly relationship ends
    -> detached implement becomes an independently represented Entity
    -> Obstacle Relevance remains possible
```

### 4. Obstacle Relevance

An obstacle is not a permanent semantic type.

#### Occupancy–Obstacle Separation

Physical occupancy alone does not establish Obstacle Relevance. The contextual question is whether current occupancy, expected movement or changing geometry constrains another Entity's safe or viable behaviour or the progress of the Operation.

```text
Entity occupancy or plausible future space
        + assessed Entity or Operation demand
        + relevant time horizon
        -> Obstacle Relevance
```

#### Assessed-Against Relationship

Obstacle Relevance is relational and directional. Entity A may be obstacle-relevant to Entity B while currently irrelevant to Entity C. Reciprocal spatial constraint does not prescribe which Entity should yield; that belongs to the Decision Engine.

#### Future-Space Inclusion

Obstacle Relevance may arise before current occupancy intersects. Expected motion, articulation or configuration transition may enter another Entity's required space.

#### Assessment Before Decision

Situation Assessment may establish Obstacle Relevance, a Conflict Zone or unresolved clearance. It does not choose the intervention target or issue Control.

#### Entity–Environment Separation

The catalogue-derived Scope Overlay applies to runtime Entities. Environmental features such as field boundaries, hedges, ditches, buildings and map geometry remain part of the wider Situation Assessment obstacle model without semantic catalogue membership.

## Test Admission

Control ineligibility does not imply test ineligibility.

### Positive Test Candidate

A positive candidate is expected to satisfy the Control Eligibility Profile and is selected to test supported Giants operation, Operation Participation, representation, conflict assessment, intervention and successful return to Giants AI.

### Bounded Negative Test Candidate

A Bounded Negative Test Candidate is a known or expected control-ineligible configuration selected to validate the system boundary.

A successful negative test demonstrates that OuttaMyWay:

- preserves representation;
- creates or carries the Control Exclusion Constraint;
- assesses Assembly and Obstacle Relevance independently;
- prevents unsupported downstream intervention;
- communicates a material limitation appropriately;
- reassesses after player action.

Test admission does not change support status, imply category compatibility or expand the supported operational envelope.


## Empirical Test-Role Calibration

The bounded TS005–TS010 investigation has calibrated the proposed Scope Overlay evidence roles. `SCOPE_OVERLAY_TEST_CALIBRATION.md` owns the complete configurations, runtime baselines and bounded conclusions.

Testing follows:

```text
Test-Role Obligation
    -> Agronomic Role Candidate
        -> Configuration Candidate
            -> Verified Test Configuration
                -> Essential Evidence Horizon
                    -> bounded conclusion
```

The final role portfolio is:

- Reference Positive — satisfied;
- Dynamic-Extent Positive — satisfied;
- Non-Tractor Operational Assembly — satisfied;
- Material-Chain Boundary — satisfied;
- Distinct Spatial-Regime Positive — retired after Native Crop-System Exclusion prevented admission;
- Asymmetric Working Envelope — satisfied;
- Admission-Rejection Negative — satisfied at configuration and crop-system boundaries;
- Post-Admission Failure Negative — strongly supported with a declared transient-observation limitation.

The role count is not an architectural invariant. A role may be renamed, retired or replaced when evidence shows that it does not describe an OuttaMyWay responsibility.

### Control boundary evidence

TS006 and TS007 establish that material-chain continuity does not imply Control Eligibility continuity. TS007 and TS009 establish that manual agricultural viability does not imply native Job Admission. TS008 establishes that Control Eligibility does not imply viability in every agronomic state.

### Assembly and routing evidence

TS006 and TS008-P establish valid Non-Tractor Operational Assemblies. TS008-P establishes dynamic Physical Assembly extent. TS010 establishes an Offset Working Envelope and Work-Envelope-Anchored Routing: Giants may deliberately displace the powered-vehicle path so the active implement follows the operational boundary.

Therefore a Scope Overlay or later Conflict Zone model must not infer a centred working envelope from powered-vehicle trajectory or total working width alone.

### Test closure boundary

The calibration closes test-role discovery, not implementation validation. Multi-worker conflicts, interventions, performance, containment enforcement and patch-triggered revalidation remain separate claim-driven activities.

## Persistent obstruction and completion

A locally successful diversion may leave the underlying Operation problem unchanged.

### Local Resolution–Operational Resolution Separation

Local Resolution means the immediate encounter was handled safely. Operational Resolution means the underlying cause no longer prevents useful progress or completion.

Repeated local success is not evidence of Operational Resolution.

### Persistent Spatial Constraint

A Persistent Spatial Constraint exists when stable occupied or unavailable space continues to conflict with required or repeatedly requested Operation space.

The Entity remains the obstacle source. Persistence belongs to the continuing relationship between its occupancy and the Operation's demand; it does not turn the Entity into a permanent obstacle type.

### Denied Work Space

Denied Work Space is space required or repeatedly requested by an Operation but currently unavailable because of a Persistent Spatial Constraint.

A Conflict Zone identifies potentially incompatible future occupancy. Denied Work Space identifies required occupancy that remains unavailable.

### Recurring Commitment Loop

A Recurring Commitment Loop occurs when OuttaMyWay applies a locally valid commitment, returns control to Giants AI, and Giants reconstructs a materially equivalent unresolved situation.

Recurrence is evidence that the previous commitment treated the symptom rather than the cause. Situation Assessment records the recurrence and persistent knowledge; the Decision Engine must reconsider rather than assume indefinite repetition remains productive.

### Completion Blocker

A Persistent Spatial Constraint becomes a Completion Blocker when it prevents, or increasingly appears likely to prevent, completion of the original Giants AI job without an external change.

A persistent obstacle parked outside required work may be harmless. A persistent obstacle occupying repeatedly requested unfinished ground may become a Completion Blocker.

When resolution requires physical action beyond OuttaMyWay's authority, the Decision Engine may escalate to the player rather than repeat ineffective diversion indefinitely. The blocking Entity remains represented throughout.

## Architectural information flow

```text
Complete Reviewed Semantic Catalogue
        -> Scope Overlay
            -> Control Eligibility Profile
            -> Participation Potential
            -> Assembly Relevance knowledge
            -> Obstacle Relevance knowledge
        -> test selection
            -> Positive Test Candidates
            -> Bounded Negative Test Candidates
        -> Runtime Observation and Situation Assessment
            -> Runtime Operation Participation
            -> Behavioural Assemblies
            -> Control Exclusion Constraints
            -> current occupancy and Future Space
            -> Operational Influence
            -> Persistent Spatial Constraints
            -> Denied Work Space
            -> possible Completion Blockers
        -> Decision Engine
            -> Runtime Control Admissibility
            -> commitment selection and recurrence response
            -> player-escalation decision
        -> Control and UI
```

## Architectural invariants

1. Semantic identity never silently determines a Scope Overlay conclusion.
2. No Scope Overlay dimension silently determines another.
3. Control ineligibility never removes a physically or operationally relevant Entity from the Operational Picture.
4. Physical presence never establishes Operation Participation by itself.
5. Assembly membership never establishes Assembly Relevance by itself.
6. Occupancy never establishes Obstacle Relevance without an assessed relationship.
7. Job admission never establishes complete job-configuration viability.
8. External mods never expand the supported baseline implicitly.
9. Test admission never changes support status.
10. Repeated local avoidance never proves Operation-level resolution.
11. Situation Assessment produces knowledge; Decision selects commitments; Control and UI act or communicate.

## Explicitly deferred

This architecture does not yet select:

- a machine-readable Scope Overlay schema;
- exact outcome enums or confidence encodings;
- runtime evidence sources and refresh rules;
- a complete per-definition or per-job assignment table;
- recurrence-equivalence thresholds;
- Completion Blocker confidence thresholds;
- player-message wording, timing or suppression;
- the targeted Structural Challenge Profile derived from the calibrated configurations;
- Prototype 13B implementation;
- paid-DLC or general mod compatibility.

Those belong to later test-selection, implementation and validation increments.
