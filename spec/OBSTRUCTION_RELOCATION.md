# Obstruction Relocation Specification

## Identity and authority

**Specification Jurisdiction:** Obstruction Relocation  
**Parent Jurisdiction:** [`Resolution Lifecycle`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md`](../docs/architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#8-specification-jurisdiction--obstruction-relocation)

This Specification owns the implementation-facing contract for the specialised **Resolution Commitment** that removes a positively established **Causal Obstruction** when the blocker is currently non-active, unclaimed and otherwise supportable for bounded relocation.

Obstruction Relocation does **not** own Causal Obstruction recognition, active/non-active classification, Player Claim classification, generic Candidate enumeration, mandatory Constraint meaning, Decision, Responsibility Transition, generic Bounded Authority, generic Control mechanics or productive routing.

It inherits the obligation, persistence and terminal rules of [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

> **Causal Obstruction != Relocation Responsibility.**

A current Causal Obstruction is Situation meaning. It becomes an Obstruction Relocation responsibility only after the prospective-selection and Responsibility Transition boundaries establish this specialised Resolution.

> **Beneficiary != Controlled Subject.**

The beneficiary is the active supported worker whose continuation is obstructed. The controlled subject is the non-active unclaimed blocker whose physical state may be changed to remove that obstruction.

## Boundary contract

### Admission inputs

A new Obstruction Relocation Resolution MUST be grounded in one coherent current evidence/selection context containing, directly or through its upstream products:

- a current positive Causal Obstruction relationship from [`SITUATION_ASSESSMENT.md`](SITUATION_ASSESSMENT.md);
- one exact physical blocker identity and current physical reference;
- current positive evidence that the blocker is **non-active** for the relevant GIANTS authority question;
- current evidence that no Player Claim prevents OuttaMyWay actuation;
- one or more active supported beneficiary assemblies whose continuation is currently obstructed by that blocker;
- representation and physical-reference evidence sufficient for the bounded relocation question being asked;
- a supported and mandatory-constraint-admissible relocation Candidate where strategic selection is required; and
- the current responsibility/commitment context needed to distinguish fresh establishment from maintenance of an existing relocation Resolution.

Historical Job Episode identity, prior OuttaMyWay observation, vehicle ownership, completed-worker provenance and prior Local Operation membership MUST NOT be required merely to establish relocation eligibility when current Reality already establishes the required blocker relationship and classification.

> **Historical Provenance != Relocation Eligibility.**

### Resolution identity and roles

One Obstruction Relocation Resolution MUST preserve the semantic distinction between:

- **beneficiary set** — the active supported demand whose continuation justifies the intervention; and
- **controlled subject** — the blocker whose physical state may be changed.

Multiple current pairwise Causal Obstruction relations involving the same blocker within the same Local Operation MAY contribute to one blocker-scoped relocation responsibility when they express one current obstruction-removal purpose. An implementation MUST NOT manufacture independent parking/tidying duties merely because several beneficiaries or historical pair relationships exist.

The Resolution identity MUST follow the current semantic relocation responsibility, not a completed Job Episode, prior courtesy count, actuator lease or one beneficiary pair record.

A repeated bounded actuation under the same unresolved obstruction-removal purpose is maintenance of the same Resolution, not a new Current Responsibility.

### Resolution purpose and obligation

The specialised Resolution purpose is to remove the current Causal Obstruction sufficiently for the supported beneficiary demand to continue, or to reach another **positively supported parent-consistent terminal route** such as supersession, failure or escalation.

The Resolution MUST retain at least one terminal-dependent obligation that prevents semantic completion merely because a physical manoeuvre ended.

That obligation contract MUST preserve enough information to determine:

- which blocker is being controlled;
- which beneficiary demand authorised the intervention;
- which current Causal Obstruction basis made the obligation legitimate;
- what positive evidence can establish successful discharge;
- what positive evidence can establish loss of relocation eligibility or other basis cessation;
- what physical authority classes may be used while discharging the obligation; and
- what terminal outcomes remain legitimate when autonomous relocation cannot continue.

Obligation representation MAY be one aggregate obligation or several scoped obligations if parent Resolution semantics remain equivalent. Source record count is not normative.

## Geometry-bounded relocation contract

### One bounded inward actuation

When current evidence supports physical relocation, one actuation MAY be authorised from the blocker's current physical reference toward the current Field World centroid.

The actuation MUST be bounded by the nearer of:

- the meaningful remaining centroid-directed displacement; and
- the current per-actuation maximum owned by the implementation/policy boundary responsible for that calibration.

The exact current distance cap is an implementation value unless Architecture later promotes it to contract authority.

The relocation objective MUST remain an **inward obstruction-removal manoeuvre**. It MUST NOT become:

- a parking destination;
- a tidying objective;
- a completed-worker settlement location;
- a boundary-away search;
- a generic route-planning problem; or
- an inference that unobserved future space is clear.

> **Relocation Is Geometry-Bounded, Not Count-Bounded.**

The contract defines no first/second courtesy budget, fixed number of moves or terminal movement quota.

### Representation authority

A positive current physical reference and purpose-fit representation may support the bounded inward objective. That evidence MUST NOT be enlarged into generic negative-clearance authority.

If representation supports only positive occupancy/conflict claims, the relocation path MUST NOT infer that the unobserved remainder of the field, boundary or manoeuvre sweep is clear merely because no conflict is currently represented there.

A bounded move therefore returns to fresh Reality rather than projecting an unsupported complete route.

### Supporting physical effects

The Resolution MAY require additional bounded physical effects while the blocker moves, for example temporal protection of active beneficiaries or supported compaction of the controlled subject.

Those effects remain subordinate to the same Resolution purpose:

- beneficiary protection does not establish a separate semantic Regulation responsibility merely because a speed/hold mechanism is used;
- compaction does not create a separate configuration objective or generic Transit lifecycle; and
- every positive physical effect still requires current [`BOUNDED_AUTHORITY.md`](BOUNDED_AUTHORITY.md) permission.

The specialisation MUST NOT infer new strategic purpose from the availability of a convenient physical mechanism.

## Actuation / reassessment cycle

The specialised Resolution progresses through an evidence cycle rather than a courtesy counter:

```text
positive Causal Obstruction
        +
non-active unclaimed blocker
        |
        v
supported Obstruction Relocation Resolution
        |
        v
fresh Bounded Authority for one bounded actuation
        |
        v
Control attempts authorised physical effect
        |
        v
physical authority released / narrowed
        |
        v
Reality -> Observation -> Situation Assessment
        |
        +-- fresh positive same obstruction + meaningful inward space
        |       -> another bounded actuation may be authorised
        |          under the same Resolution
        |
        +-- positive success witness
        |       -> obligation may settle as satisfaction
        |
        +-- Player Claim / new authoritative GIANTS intent
        |       -> relocation eligibility is superseded / basis lost
        |
        +-- supported physical or strategy failure
        |       -> failure / escalation path
        |
        `-- evidence insufficient
                -> retain Resolution if its obligation remains legitimate,
                   but do not manufacture new physical authority
```

The exact helper/state sequence is not normative. The authority transitions and evidence dependencies are.

> **Actuation Recurrence != Resolution Settlement Evidence.**

> **Manoeuvre Completion != Obstruction Removal.**

### Repeated actuation

A completed bounded actuation MUST release or otherwise end the positive physical permission for that actuation before another independent positive actuation is treated as authorised.

Another bounded inward actuation MAY occur under the same Resolution only after fresh current evidence again establishes:

- the relevant Causal Obstruction remains positive;
- the blocker remains non-active and unclaimed;
- meaningful inward relocation space remains; and
- all required downstream permission/feasibility contracts are satisfied again.

The existence of a retained Resolution, actuator token, prior grant or previous successful move MUST NOT by itself authorise the next move.

### Waiting for fresh evidence

After physical movement, the Resolution may remain current while no positive Bounded Authority is active.

If the obligation remains legitimate but current evidence does not yet prove either fresh obstruction-supported actuation or terminal settlement, the implementation MUST preserve the unresolved evidence state and continue observation without movement.

This is evidence-state continuity inside the existing Resolution. It MUST NOT create a generic WAITING Current Responsibility or use a timeout as proof of success, failure or clearance.

> **Resolution Persistence != Actuation Persistence.**

## Success and terminal evidence

### Successful obstruction discharge

Physical target attainment is only Control evidence. It MUST NOT self-certify successful Obstruction Relocation.

Successful discharge requires positive current semantic evidence that the obstruction-removal obligation has been satisfied. Absence of a formerly positive Causal Obstruction relation, by itself, is insufficient where the evidence contract does not own negative clearance.

The implementation MUST obtain a positive continuation/discharge witness for the beneficiary demand. Where one Resolution was justified by multiple still-relevant beneficiaries, evidence for only one beneficiary MUST NOT silently settle the remaining demand.

A current implementation may use positive supported productive continuation as that witness. The durable contract is the positive discharge requirement, not a particular source field or motion threshold.

> **Obstruction Absence != Supported Continuation.**

### Player Claim

A current Player Claim over the non-active blocker is higher authority than autonomous relocation.

Once positively established, OuttaMyWay MUST stop acquiring new relocation authority and MUST relinquish/neutralise owned physical effects according to Control safety. The relocation responsibility may then terminate or be superseded through the parent lifecycle using evidence truthful to that claim boundary.

Vehicle ownership metadata alone is not Player Claim evidence.

### New authoritative GIANTS intent

If the blocker begins a fresh authoritative GIANTS AI activity/job, the non-active relocation premise no longer applies.

OuttaMyWay MUST stop acquiring new relocation authority, relinquish incompatible physical effects, and allow the semantic responsibility to terminate/supersede through the parent lifecycle. Historical completion provenance does not outrank current GIANTS intent.

### Physical execution failure

Control failure proves that the authorised physical request was not successfully realised. It does not by itself prove that the Causal Obstruction disappeared, that the blocker became claimed, or that the Resolution's semantic basis ceased.

A supported physical failure MAY make the specialised Resolution fail or escalate according to its accepted terminal contract. The evidence MUST retain the distinction between **physical execution failure** and **Situation/basis change**.

### Strategy exhaustion and escalation

If fresh Reality still positively establishes the Causal Obstruction but no meaningful supported inward relocation actuation remains, this autonomous strategy has no further supported physical action.

The implementation MUST NOT invent a boundary-away move, parking stage, extra courtesy or unsupported route merely to keep automation active.

A supported failure/escalation path may terminate autonomous Obstruction Relocation and require player intervention.

> **Resolution Failure / Escalation != Causal-Obstruction Basis Cessation.**

Positive persistence of the Causal Obstruction MUST NOT be relabelled as Causal-Obstruction basis cessation solely because the autonomous inward-relocation strategy is exhausted. Any parent obligation settlement and terminal mapping MUST remain evidence-truthful and consistent with [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

## Durable invariants

### Obstruction is the purpose boundary

A non-active vehicle that is not positively causing supported work to be obstructed creates no relocation responsibility.

Once the committed Causal Obstruction is discharged or the relocation responsibility otherwise reaches a supported terminal disposition, OuttaMyWay has no independent interest in positioning the blocker.

### Beneficiary demand and controlled-subject authority remain distinct

Movement of the blocker is justified by beneficiary continuity, not by a duty to improve the blocker's final state.

### Current Reality outranks historical provenance

Historical Job Episode identity MAY remain diagnostic provenance. It MUST NOT gate recognition, continuation or bounded relocation when current evidence already establishes the required physical subject and Situation.

### No count-based relocation lifecycle

Repeated physical acts do not create courtesy stages, movement budgets or automatic boundary-away follow-up.

### Every positive actuation is freshly bounded

The same Resolution may persist across several physical actuation episodes. Each new positive effect MUST satisfy the current Bounded Authority contract.

### Control outcomes are evidence, not settlement authority

Control reports manoeuvre completion, failure, Player Claim, supersession or other physical observations. Those outcomes return through Reality/Observation/Situation and do not settle the Resolution solely by being emitted.

### Core capability is structural

Obstruction Relocation is a core runtime capability beneath the product-level OuttaMyWay enablement boundary. A per-capability configuration switch MUST NOT create or withdraw semantic relocation authority.

Current Situation evidence, Player Claim, Responsibility Transition and Bounded Authority remain the relevant authority boundaries.

## Failure and uncertainty semantics

- **No positive Causal Obstruction** — do not establish a new relocation responsibility.
- **Blocker active under current authoritative GIANTS intent** — do not admit non-active relocation; active spatial handling belongs elsewhere.
- **Player Claim present** — do not acquire positive relocation authority; relinquish owned effects safely.
- **Historical provenance unavailable** — not a relocation veto when current Reality otherwise supplies the required evidence.
- **Current physical blocker reference unavailable** — no new positive relocation actuation; preserve only the strongest supported semantic conclusion.
- **Purpose-fit representation unavailable/unfit** — fail closed for the unsupported physical claim; do not manufacture clearance or geometry.
- **Bounded actuation completes** — release that actuation's authority and reassess; do not infer semantic success.
- **Fresh positive obstruction remains and meaningful inward actuation is supportable** — the same Resolution may continue with a newly bounded actuation.
- **Fresh positive obstruction remains but no meaningful supported autonomous actuation exists** — fail/escalate; do not invent another strategy or falsely claim obstruction-basis cessation.
- **Positive beneficiary continuation/discharge witness establishes success** — settle the relevant obligation(s) according to the parent Resolution contract.
- **Player Claim or new authoritative GIANTS intent arises during execution** — stop/narrow physical effect immediately as Control safety requires; semantic terminal meaning is reconciled through current evidence and parent lifecycle.
- **Control/mechanism failure** — report physical failure; do not manufacture semantic clearance or basis loss.
- **Required post-actuation evidence remains unresolved** — retain unresolved evidence and observe without positive actuation until fresh authority exists or a supported terminal route emerges.

## Cross-Jurisdiction dependencies

### Situation Assessment

Situation Assessment owns Causal Obstruction, blocker active/non-active meaning and Player Claim interpretation. Obstruction Relocation consumes those conclusions and MUST NOT recreate them from raw vehicle mechanics.

### Candidate Support / Constraint Evaluation / Decision

Prospective selection owns whether a relocation alternative is supported, mandatory-admissible and selected. Obstruction Relocation owns the specialised Resolution contract after that strategic path is accepted.

A retained Resolution may request fresh purpose-specific support for another bounded actuation without converting actuation count into Decision authority.

### Responsibility Transition

Responsibility Transition establishes, preserves or ends the semantic Resolution Commitment identity. Repeated bounded moves under the same unresolved relocation purpose are maintenance, not new responsibilities.

### Resolution Lifecycle

The parent contract owns generic obligation persistence, settlement and terminal semantics. Obstruction Relocation specialises the purpose-specific evidence and outcomes but MUST NOT redefine parent meanings for implementation convenience.

### Bounded Authority

Bounded Authority owns each current positive physical permission over the blocker and any subordinate supporting effect. The Resolution may persist when no grant is active.

### Control

Control executes the already-authorised relocation/support request, rechecks current physical feasibility and higher-priority Reality boundaries, safely neutralises/relinquishes owned effects, and reports outcomes. It does not decide whether the Causal Obstruction is semantically discharged.

### Configuration

Core Obstruction Relocation availability does not depend on a per-capability player configuration toggle. Product master enablement and current claim/authority boundaries remain separate concerns.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/assessment/CausalObstructionAssessment.lua`](../scripts/assessment/CausalObstructionAssessment.lua) — upstream Situation production for current Causal Obstruction and blocker classification;
- [`scripts/candidates/ObstructionRelocationCandidateSupport.lua`](../scripts/candidates/ObstructionRelocationCandidateSupport.lua) — current blocker-scoped support, bounded inward objective, reassessment and purpose-specific terminal evidence construction;
- [`scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua`](../scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua) — current specialised Resolution establishment/maintenance adapter;
- [`scripts/commitment/ObstructionRelocationCommitmentLifecycle.lua`](../scripts/commitment/ObstructionRelocationCommitmentLifecycle.lua) — current specialised commitment/settlement integration with the generic Resolution substrate;
- [`scripts/authority/BoundedAuthority.lua`](../scripts/authority/BoundedAuthority.lua) plus purpose-specific authority construction — current grant/validation substrate for positive physical permission;
- [`scripts/control/ObstructionRelocationControl.lua`](../scripts/control/ObstructionRelocationControl.lua) — current physical executor, current Player Claim/source-intent checks, opportunistic compaction, bounded movement, cleanup and raw outcome publication;
- [`scripts/control/mechanisms/NonJobActuationMechanism.lua`](../scripts/control/mechanisms/NonJobActuationMechanism.lua) — current non-active physical movement mechanism; and
- the generic obligation/governing-basis/terminal-settlement modules listed by [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md).

These modules realise several neighbouring contracts. Their current decomposition is not the normative Specification boundary.

> **Primary Specification != Primary Source Module**

## Validation route

### Structural/source-contract validation

[`tests/test_obstruction_relocation_structure.py`](../tests/test_obstruction_relocation_structure.py) protects the current architectural placement, blocker-scoped identity, provenance-neutrality, geometry-bounded/non-count-bounded policy, post-actuation reassessment, Control cleanup boundary and retirement of the old Terminal Egress/post-Job responsibility model.

Structural tests are evidence of the current implementation contract; they do not define the architecture.

### Offline behavioural/conformance validation

[`tests/replacement_core/obstruction_relocation.lua`](../tests/replacement_core/obstruction_relocation.lua) exercises blocker/beneficiary role separation, one responsibility across several pairwise causal relations, no-obstruction non-admission, repeated actuation under fresh positive obstruction, positive supported-continuation success, strategy exhaustion, Player Claim and physical failure/cleanup behavior.

The broader [`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises integration with generic commitment, obligation, Responsibility Transition and authority machinery.

Offline evidence can challenge the semantic sequencing and fail-closed boundaries. It cannot prove equivalent GIANTS physical execution, player-entry timing or field-world movement in game.

### Targeted in-game Reality validation

Targeted Reality validation is required for claims depending on:

- actual non-active vehicle movement and steering;
- live Player Claim timing;
- GIANTS AI reactivation/succession;
- implement compaction behavior;
- field geometry and meaningful inward movement;
- physical neutralisation/cleanup; and
- positive beneficiary continuation after relocation.

### Outside this Specification's validation claim

A correct Obstruction Relocation contract does not prove that Causal Obstruction recognition is correct, that a relocation Candidate was strategically preferable, that generic Bounded Authority is sound for every capability, or that Control can physically move every supported vehicle assembly.

Those claims remain with their governing Jurisdictions and Reality evidence.