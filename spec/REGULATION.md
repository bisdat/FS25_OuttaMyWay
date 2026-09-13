# Regulation Specification

## Identity and authority

**Specification Jurisdiction:** Regulation  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#specification-jurisdiction--regulation)

This Specification owns the implementation-facing contract for a current **Regulation** responsibility: bounded temporal coordination of otherwise GIANTS-owned progression while GIANTS retains productive routing.

Regulation does **not** own Situation interpretation, productive routing, successor reservation, spatial displacement, Responsibility Transition, Bounded Authority magnitude/subject permission or physical Control execution.

> **Many Situations, One Regulation Capability.**

> **Regulation Responsibility != `REGULATE_SPEED` Capability.**

A physical speed-limiting effect does not by itself establish a Regulation responsibility. Responsibility Transition owns whether a Regulation responsibility exists and its semantic identity. Conversely, one Regulation responsibility may remain current while its downstream Bounded Authority or physical lease is refreshed, quiescent, reactivated or replaced.

## Boundary contract

### Inputs

A Regulation responsibility begins only after upstream authority has established that bounded temporal coordination is the current semantic responsibility.

The implementation-facing Regulation boundary consumes, as applicable:

- the current Regulation responsibility identity established by Responsibility Transition;
- the governing basis and provenance that explain why this Regulation instance exists;
- current Situation Assessment sufficient to determine whether the same temporal-coordination purpose remains supported, is positively discharged, is positively superseded or remains unresolved;
- the current controlled/protected relationship relevant to that purpose; and
- any current supporting commitment/obligation substrate required by the accepted implementation path.

A retained commitment, authority token, lease, pair key, conflict identity or physical mechanism MUST NOT independently establish Regulation responsibility.

### Regulation product

The semantic Regulation product MUST preserve:

- a stable responsibility-instance identity while the same Regulation persists;
- Regulation kind;
- governing basis;
- provenance sufficient to identify the admitted Regulation purpose; and
- enough correlation context for downstream Bounded Authority and fresh Situation reassessment to act on the same responsibility without treating implementation substrate as semantic identity.

The current Lua `Regulation` record is one representation of this contract, not a mandatory field layout.

### Downstream permission

Regulation itself does not grant physical permission.

A current Regulation responsibility may justify asking Bounded Authority for a temporal-coordination effect, but Bounded Authority independently owns:

- which assembly may be acted upon now;
- which physical capability is permitted;
- the current magnitude or envelope;
- current validity conditions; and
- whether actuation should be quiescent.

Control may act only on the resulting current permission.

> **Responsibility Persistence != Actuation Persistence.**

## Regulation lifecycle

Regulation has weak persistence relative to Resolution Commitment. Its semantic lifecycle is:

```text
fresh Situation justification
        |
        v
Responsibility Transition establishes Regulation
        |
        v
same temporal-coordination purpose remains current
        |
        +-- actuation currently supported
        |       -> Bounded Authority may permit current magnitude
        |
        +-- purpose remains but actuation temporarily unsupported / unnecessary
        |       -> Regulation may remain current while physical authority is quiescent
        |
        +-- evidence temporarily unresolved
        |       -> bounded WAITING_FOR_EVIDENCE may preserve the same responsibility
        |
        +-- positive dissolution / basis cessation
        |       -> Responsibility Transition terminates Regulation
        |
        `-- positively justified successor
                -> atomic Responsibility Transition replacement
```

The exact source methods and retained records are not normative. The semantic ordering is.

### Establishment

Regulation requires explicit current justification for temporal coordination. Shared Operation membership, proximity, a historical pair relationship or mere availability of a speed-control mechanism is insufficient.

Different Situation reasons do not create different architectural Regulation Jurisdictions. Follower coordination, action-space conservation, intent revelation and other accepted reasons specialise the governing basis while using the same Regulation responsibility contract.

### Maintenance

If fresh Situation Assessment continues to support the same Regulation purpose, the same responsibility identity persists.

Maintenance MAY include:

- a different Bounded Authority magnitude;
- release and later reacquisition of Bounded Authority;
- actuation quiescence and later reactivation;
- migration of the controlled physical role when the accepted purpose remains the same and Architecture permits that migration;
- refreshed evidence/provenance; or
- replacement of a physical Regulation lease.

None of those events is automatically a Responsibility Transition.

### Waiting for evidence

Temporary evidence loss MUST NOT be converted into positive Regulation success, dissolution or supersession.

Where the admitted Regulation purpose remains materially live but evidence needed to prove continuation or dissolution is temporarily unavailable, Situation Assessment may support `WAITING_FOR_EVIDENCE` for the same responsibility.

That state does not authorise indefinite physical restraint. Bounded Authority may quiesce while the responsibility remains semantically current, and prolonged uncertainty must follow the applicable fail-safe/escalation contract.

A timeout or watchdog expiry is not evidence that Regulation succeeded or became unnecessary.

### Termination

Regulation ends only through an authoritative lifecycle event, including as applicable:

- positive dissolution of its governing Situation relationship;
- positive supersession;
- governing-basis cessation;
- Job Episode / Operation lifecycle change that removes the basis;
- explicit escalation where the architecture provides it; or
- atomic replacement by another Current Responsibility.

Termination MUST invalidate or release Bounded Authority derived solely from the ended Regulation responsibility.

### Successor agnosticism

Regulation may preserve or reveal future option space but MUST NOT reserve, guarantee or force a successor.

A likely Passage, Resolution or return to ordinary GIANTS AI may motivate temporal coordination, but fresh upstream assessment must independently justify what follows.

> **Successor-Agnostic != Future-Blind.**

## Regulation responsibility versus supporting temporal effects

The semantic Regulation responsibility and the physical `REGULATE_SPEED` capability occupy different layers.

A current Regulation responsibility normally obtains physical timing effects through Bounded Authority. However, another Current Responsibility may also legitimately require a bounded supporting temporal effect as part of its own accepted obligations, provided that effect is authorised by that responsibility and Bounded Authority.

Therefore:

- observing a speed lease does not prove that semantic Current Responsibility is Regulation;
- a `REGULATE_SPEED` request does not create a Regulation responsibility;
- a Regulation responsibility may exist with no active speed lease; and
- physical lease ownership must not be used as a substitute for responsibility identity.

This distinction prevents implementation module placement or capability vocabulary from becoming semantic authority.

## Durable invariants

### Temporal coordination does not own productive routing

Regulation may alter relative timing. It MUST NOT select an alternate productive route, perform spatial displacement or replace GIANTS job ownership.

### Responsibility identity follows purpose continuity

The same admitted Regulation purpose retains the same responsibility identity through ordinary maintenance, magnitude updates, quiescence and reactivation.

A genuinely different Regulation responsibility or non-Regulation successor requires Responsibility Transition.

### No cooldown or historical pair authority

Prior Regulation, prior pair participation, recent release or a remembered subject creates no current authority. Fresh current justification is required.

### Physical lease does not prove semantic responsibility

A retained physical lease, actuator handle, authority token or commitment record MUST NOT keep Regulation semantically current after its governing responsibility ends.

### Physical quiescence does not prove semantic termination

Releasing or pausing a downstream speed effect does not itself end the Regulation responsibility while the governing purpose remains current or unresolved.

### Regulation does not own its magnitude

The semantic responsibility explains **why temporal coordination persists**. Bounded Authority owns **what physical timing effect is permitted now**, including subject and magnitude.

### Regulation cannot force its successor

Current temporal coordination may preserve future options but cannot claim Passage, Resolution Commitment or GIANTS handback as an already-selected future responsibility.

## Failure and uncertainty semantics

- **Supported establishment** — current upstream justification exists and Responsibility Transition establishes a Regulation instance.
- **Supported maintenance** — the same purpose remains current; preserve identity.
- **Actuation not currently required** — preserve the Regulation responsibility when its semantic purpose remains current, but allow downstream physical permission to become quiescent.
- **Actuation unsupported** — do not manufacture a physical permission; preserve or terminate the responsibility only according to current semantic evidence.
- **Evidence unresolved** — do not claim positive dissolution; bounded waiting/quiescence may apply.
- **Positive dissolution / basis cessation** — terminate through Responsibility Transition and invalidate dependent Bounded Authority.
- **Positive successor justification** — replace atomically through Responsibility Transition.
- **Control rejection or physical failure** — report/reassess; Control failure does not by itself define Regulation semantic termination.

Regulation MUST fail safe by reducing physical effect when downstream permission or execution becomes unsupported. It MUST NOT create a stronger physical effect to compensate for uncertainty.

## Cross-Jurisdiction dependencies

### Situation Assessment

Situation Assessment owns why temporal coordination is currently justified, unresolved, discharged or superseded. Regulation consumes that semantic meaning; it does not reinterpret raw Reality independently.

### Responsibility Transition

Responsibility Transition exclusively establishes, terminates and replaces Regulation responsibility identity. Regulation maintenance is not a transition.

### Resolution Lifecycle

Resolution Commitment is a different Current Responsibility with stronger obligation persistence. Regulation MUST NOT silently mutate into Resolution Commitment, and a supporting temporal effect under a Resolution does not automatically create a Regulation responsibility.

### Bounded Authority

Bounded Authority owns current physical permission, controlled subject, magnitude and validity envelope. Regulation may persist while those grants change or become quiescent.

### Control

Control realises already-authorised physical timing requests. A physical lease or observed speed effect does not become Regulation lifecycle authority.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Primary current implementation routes include:

- [`scripts/contracts/Regulation.lua`](../scripts/contracts/Regulation.lua) — current value representation for semantic Regulation responsibility;
- [`scripts/responsibility/ResponsibilityTransitionAuthority.lua`](../scripts/responsibility/ResponsibilityTransitionAuthority.lua) and purpose-specific transition collaborators — current establishment, continuity and termination boundary;
- [`scripts/assessment/CurrentResponsibilityAssessment.lua`](../scripts/assessment/CurrentResponsibilityAssessment.lua) — current maintenance/termination interpretation for implemented Regulation purposes;
- [`scripts/authority/RegulationBoundedAuthority.lua`](../scripts/authority/RegulationBoundedAuthority.lua) — current purpose-specific physical-permission collaboration, including quiescence/reactivation and magnitude refresh; and
- [`scripts/control/RegulationControl.lua`](../scripts/control/RegulationControl.lua) — downstream physical lease execution, not Regulation semantic authority.

No one of those modules is the Regulation Jurisdiction. In particular, the `RegulationBoundedAuthority` module also hosts physical Regulation-capability support for non-Regulation responsibilities; module naming does not transfer semantic ownership.

> **Primary Specification != Primary Source Module**

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_regulation_control_structure.py`](../tests/test_regulation_control_structure.py), protecting the Control/mechanism boundary and current Regulation-lease wiring;
- [`tests/test_follower_boundary_assessment_value_ownership_structure.py`](../tests/test_follower_boundary_assessment_value_ownership_structure.py), protecting Situation-owned follower meaning; and
- [`tests/test_forward_intersection_evidence_continuity_structure.py`](../tests/test_forward_intersection_evidence_continuity_structure.py), protecting Regulation evidence-continuity behavior.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises Regulation establishment, maintenance, magnitude changes, quiescence/reactivation, positive retirement and replacement paths in the offline harness.

Offline evidence can challenge lifecycle and authority separation. It cannot prove GIANTS physical timing or in-game intent-revelation evidence.

### Targeted in-game Reality validation

In-game validation is required for claims about actual speed regulation, GIANTS continuation under Regulation, live intent revelation, release/handback effects and physical interaction timing.

### Outside this Specification's validation claim

A correct Regulation lifecycle does not prove that Situation Assessment chose the right temporal-coordination purpose, that Bounded Authority chose a safe/current magnitude, or that Control physically achieved the requested effect.
