# Bounded Authority Specification

## Identity and authority

**Specification Jurisdiction:** Bounded Authority  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#10-specification-jurisdiction--bounded-authority)

This Specification owns the implementation-facing contract that turns a current semantic responsibility plus current accepted evidence into **specific physical permission that is valid now**.

Bounded Authority does **not** own Situation meaning, Candidate/Decision policy, Responsibility Transition, productive routing, Resolution settlement semantics, physical execution or semantic success.

> **Current Responsibility owns why intervention persists. Bounded Authority owns what is permitted now.**

> **Actuation Token != Bounded Authority Grant.**

An authority token, capability reservation, retained commitment or mechanical lease may be necessary implementation substrate. None of them independently establishes current physical permission.

## Boundary contract

### Inputs

A positive Bounded Authority decision MUST be grounded in the exact current responsibility and current evidence relevant to the proposed physical effect.

The contract consumes, as applicable:

- the current responsibility identity;
- the current supporting commitment/obligation context where that responsibility uses one;
- the exact controlled assembly/subject;
- the proposed physical capability;
- the proposed target, magnitude or movement envelope;
- current Situation / representation / physical evidence needed by the purpose-specific authority policy;
- a current authority token or equivalent accepted actuation substrate where required;
- the current effective actuation composition where concurrent effects are composed;
- the Operational Picture / evidence epoch or equivalent freshness binding;
- preconditions and invalidation conditions material to the permission; and
- provenance identifying the authority policy that derived the grant.

A caller MUST NOT obtain positive physical permission merely by naming a capability or presenting a mechanically valid token.

### Positive grant

A Bounded Authority grant is a current permission envelope, not an instruction that physical actuation must occur.

Contractually significant properties include:

- unique grant identity;
- governing responsibility identity;
- supporting commitment identity where applicable;
- controlled assembly/subject identity;
- capability;
- permitted target / magnitude / envelope;
- current authority-token or equivalent substrate binding where applicable;
- evidence / Operational Picture freshness binding;
- effective actuation composition binding where applicable;
- preconditions;
- invalidation conditions; and
- provenance.

The current `BoundedAuthorityGrant` Lua record is one implementation representation of this contract.

### Control request materialisation

A Control request derived from a grant MUST remain within the grant.

It MAY equal the granted effect or narrow it where the capability contract permits narrowing. It MUST NOT:

- change the controlled subject;
- change capability into a stronger/different capability;
- broaden movement geometry;
- increase Regulation magnitude beyond the granted limit;
- substitute a different governing purpose; or
- discard material validity bindings in order to make execution easier.

> **Request Materialisation != Authority Enlargement.**

### Currentness

A grant is usable only while its governing authority remains current.

At minimum, positive request validation MUST fail when the grant's required semantic or actuation substrate is no longer current, including as applicable:

- ended/replaced Current Responsibility;
- terminal or mismatched supporting commitment;
- stale/invalid authority token;
- stale effective actuation composition;
- controlled-subject mismatch; or
- request target/capability broader than the grant.

Purpose-specific authority policy MUST additionally respect current evidence and validity conditions that constrain the physical effect.

No implementation should interpret retention of a grant object as proof that Reality has not changed.

## Authority lifecycle

Bounded Authority is intentionally shorter-lived than the responsibility from which it derives.

```text
Current Responsibility persists
        |
        v
fresh evidence supports physical effect
        |
        v
Bounded Authority grant
        |
        +-- Control may execute within grant
        |
        +-- magnitude / subject / validity changes
        |       -> release / replace / refresh grant
        |
        +-- actuation becomes unnecessary or unresolved
        |       -> release / quiesce grant
        |
        `-- responsibility ends
                -> grant cannot remain current
```

> **Responsibility Continuity Allows Authority Discontinuity.**

A Regulation responsibility may persist while no current speed grant exists. A Resolution Commitment may persist while one participant's grant has ended and another participant's grant remains current. Fresh authority may later be acquired under the same semantic responsibility when current evidence again supports it.

### Grant establishment

Positive establishment requires current responsibility plus purpose-specific evidence sufficient to derive the requested physical permission.

Bounded Authority MUST fail closed if the semantic responsibility, subject, capability, target or required substrate cannot be established.

### Grant refresh/replacement

A changed physical magnitude or validity envelope MAY require a fresh grant while the same responsibility identity persists.

Replacing a grant for current magnitude/role MUST retire or otherwise prevent use of the superseded grant once the new permission becomes current.

### Quiescence

When the semantic responsibility remains current but positive physical actuation is not currently required or supportable, Bounded Authority may release its grant and leave the responsibility quiescent.

Quiescence is not semantic termination.

### Participant-scoped release

Where one Resolution owns several participant-scoped physical effects, one participant's grant may end independently of another participant's grant or of the parent responsibility.

Release scope MUST follow the actual permission dependency rather than treating one mechanical effect as proof that the whole Resolution ended.

### Responsibility termination

A Bounded Authority grant MUST NOT outlive the Current Responsibility from which it derives.

Responsibility termination/replacement must make dependent grants unusable even if a Control mechanism or lease remains mechanically present.

## Positive actuation and relinquishment

### Positive physical actuation

Every positive physical effect performed by OuttaMyWay MUST be supported by current Bounded Authority for that effect.

This includes tightening/creating a speed Regulation, acquiring Hold, beginning/revising an authorised reposition leg, configuration actuation where the governing contract requires positive permission, or another supported physical effect.

A vocabulary label, owner tag, executor name or capability implementation MUST NOT create an implicit bypass.

> **Positive Physical Actuation Requires Positive Bounded Authority.**

### Relinquishment / cleanup

Authority-reducing action is different.

Releasing an already-owned speed lease, clearing a Hold, stopping an owned movement, neutralising owned actuation or relinquishing an actuator does not require acquisition of a **new positive actuation grant** merely to reduce or remove OuttaMyWay's effect.

Such cleanup MUST be restricted to authority narrowing. It MUST NOT use the cleanup path to create, tighten, redirect or otherwise enlarge physical intervention.

> **Relinquishment Is Authority-Narrowing, Not Authority Creation.**

This distinction allows fail-safe cleanup even when the positive permission that originally created the physical effect has just expired or been invalidated.

## Durable invariants

### Semantic permission is distinct from mechanical exclusivity

Retaining a lease, actuator handle, authority token or exclusive mechanism does not keep physical permission alive after semantic authority ends.

> **Mechanical Exclusivity != Semantic Permission.**

### Permission cannot be inferred from capability availability

The fact that Control can physically perform an action does not mean Bounded Authority may grant it.

### Grants are subject-specific and capability-specific

A grant for one assembly, one capability or one purpose MUST NOT be silently repurposed for another.

### Downstream authority is monotonic

Control may equal or narrow a current grant. It may refuse, stop or clean up. It MUST NOT broaden the grant.

### Current responsibility is mandatory for positive grants

No positive grant exists without a current governing responsibility. A retained commitment or authority token alone is insufficient.

### Grant identity is not responsibility identity

A responsibility may receive several successive Bounded Authority grants during one semantic lifetime. Grant churn MUST NOT imply responsibility churn.

### Authority release is narrower than semantic termination

Releasing a grant ends that physical permission. It does not itself prove that the parent Regulation or Resolution responsibility ended.

### Reality can invalidate execution without creating new purpose

Fresh physical contradiction or safety evidence may make a previously authorised effect infeasible. Control may stop/refuse and authority may be withdrawn; neither may invent a different strategic action.

## Failure and uncertainty semantics

- **Current positive permission supported** — create a grant bound to current responsibility, subject, capability, target and validity context.
- **Responsibility unavailable/mismatched** — no grant.
- **Supporting commitment not current** — no grant where the permission depends on that commitment.
- **Authority token invalid/stale** — no grant or request validation failure where the token is required.
- **Effective actuation composition stale** — reject the grant/request rather than silently recomposing physical authority downstream.
- **Target/magnitude broadening attempt** — reject materialisation/validation.
- **Current evidence insufficient** — no positive actuation permission; preserve semantic responsibility only according to its own contract.
- **Current permission becomes unnecessary** — release/quiesce the grant without manufacturing responsibility termination.
- **Responsibility ends** — release/invalidate every dependent grant.
- **Control cannot realise the grant** — Control rejects/stops; the grant does not become evidence that physical success occurred.

Unknown or newly introduced physical-purpose vocabulary MUST fail closed for positive actuation unless a purpose-specific Bounded Authority policy positively establishes the permission.

## Cross-Jurisdiction dependencies

### Current Responsibility / Responsibility Transition

Responsibility Transition owns which semantic responsibility is current. Bounded Authority consumes that state and cannot keep permission alive after the responsibility ends.

### Situation Assessment

Situation Assessment owns semantic meaning of current evidence. Purpose-specific Bounded Authority policies consume that meaning and current physical/representation evidence; they do not rewrite Situation classifications.

### Regulation

Regulation owns why temporal coordination persists. Bounded Authority owns the controlled subject, current physical magnitude and whether a speed effect is currently permitted or quiescent.

### Resolution Lifecycle and specialised Resolutions

Resolution contracts own obligations/purpose. Bounded Authority may grant participant- or subject-scoped physical effects needed by those obligations without becoming the Resolution lifecycle owner.

### Control

Control consumes current Bounded Authority and realises no broader physical effect. Control may independently reject/narrow/stop on physical feasibility/safety grounds.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Primary current implementation routes include:

- [`scripts/contracts/BoundedAuthorityGrant.lua`](../scripts/contracts/BoundedAuthorityGrant.lua) — current grant value representation;
- [`scripts/authority/BoundedAuthority.lua`](../scripts/authority/BoundedAuthority.lua) — current common grant registry, current-responsibility/token/composition validation, target monotonicity and Control-request materialisation;
- [`scripts/authority/RegulationBoundedAuthority.lua`](../scripts/authority/RegulationBoundedAuthority.lua) — current purpose-specific temporal-permission policy, magnitude refresh, quiescence/reactivation and supporting Regulation effects;
- runtime purpose-specific request construction for Cooperative Passage and Obstruction Relocation; and
- responsibility-transition / terminal-settlement paths that release dependent grants when their semantic basis ends.

The common `BoundedAuthority` module is not the entire Jurisdiction. Purpose-specific authority policies remain part of this contract even when placed elsewhere.

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_regulation_control_structure.py`](../tests/test_regulation_control_structure.py), protecting Regulation request validation and Control separation;
- [`tests/test_relocation_serialization_structure.py`](../tests/test_relocation_serialization_structure.py), protecting supporting temporal permission under current Obstruction Relocation;
- [`tests/test_obstruction_relocation_structure.py`](../tests/test_obstruction_relocation_structure.py), protecting relocation request/authority boundaries; and
- [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py), protecting current Bounded Authority, participant-scoped authority and Control ordering.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises grant issuance, request materialisation, stale/mismatched authority rejection, Regulation magnitude refresh/quiescence/reactivation, Passage participant authority and obstruction relocation in the offline harness.

Offline evidence can validate the repository's semantic permission contract. It cannot prove GIANTS physical feasibility or live safety conditions.

### Targeted in-game Reality validation

In-game validation is required for claims that a granted physical effect is actually safe/available under GIANTS runtime mechanics, and for timing-sensitive revocation/release behavior.

### Outside this Specification's validation claim

A valid Bounded Authority grant does not prove that the upstream responsibility was semantically correct or that Control physically achieved the effect. It proves only that the system had current permission to attempt the bounded effect under the accepted contract.
