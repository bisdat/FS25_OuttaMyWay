# OuttaMyWay Runtime Responsibility Architecture

## Purpose and architectural boundary

This document defines OuttaMyWay's end-to-end runtime responsibility architecture: how GIANTS Job Episodes enter and leave cooperative context, how current evidence becomes semantic meaning, when OuttaMyWay may acquire responsibility, how physical permission is bounded, how authorised action is realised, and when responsibility returns to GIANTS AI.

This is current Architecture. It defines responsibilities, concepts, constraints, evidence rules and lifecycle boundaries; it does not define source modules, classes, helper topology or implementation chronology.

The [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) specialises this parent architecture for active spatial competition during cooperative field work. The [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md) owns spatial representation semantics and validity. The [Candidate Support Projection Architecture](CANDIDATE_SUPPORT_PROJECTION.md) owns the current prospective Candidate-support boundary between Situation Assessment and Decision.

## Specification Jurisdictions

This architecture declares the following Specification Jurisdictions.

| Specification Jurisdiction | Primary architectural responsibility |
| --- | --- |
| **Operation Lifecycle** | Establish, maintain and close Local Operation participation from exact GIANTS Job Episode lifecycle evidence. |
| **Observation** | Acquire and preserve current evidence from Reality without assigning semantic purpose. |
| **Situation Assessment** | Interpret current evidence into current Situation meaning without acquiring responsibility. |
| **Responsibility Transition** | Authoritatively establish, terminate or atomically replace Current Responsibility. |
| **Regulation** | Provide bounded temporal coordination while GIANTS retains productive routing. |
| **Resolution Lifecycle** | Own the generic persistence and obligation semantics of Resolution Commitment. |
| **Obstruction Relocation** | Specialise Resolution Lifecycle for bounded removal of a positively causal non-active unclaimed obstruction. |
| **Bounded Authority** | Determine what physical action is permitted now under current responsibility and Reality. |
| **Control** | Realise an already-authorised physical request through available GIANTS mechanisms. |

The Current Responsibility model, Reality, Field World Equivalence Authority, Causal Obstruction, Lifecycle Evidence Asymmetry, Pairwise Resolution Exclusivity and Downstream Authority Monotonicity are architectural concepts, authorities, evidence rules or constraints; they do not create additional Specification Jurisdictions merely by being separately named.

**Operation Lifecycle** now routes to [`../../spec/OPERATION_LIFECYCLE.md`](../../spec/OPERATION_LIFECYCLE.md), **Observation** to [`../../spec/OBSERVATION.md`](../../spec/OBSERVATION.md), **Situation Assessment** to [`../../spec/SITUATION_ASSESSMENT.md`](../../spec/SITUATION_ASSESSMENT.md), **Responsibility Transition** to [`../../spec/RESPONSIBILITY_TRANSITION.md`](../../spec/RESPONSIBILITY_TRANSITION.md), and **Resolution Lifecycle** to [`../../spec/RESOLUTION_LIFECYCLE.md`](../../spec/RESOLUTION_LIFECYCLE.md). The remaining primary `/spec` routes are **pending migration** under the bounded standards-adoption exception in [`../DOCUMENT_STANDARDS.md`](../DOCUMENT_STANDARDS.md), with Issue #141 owning that remaining repository migration. This is not a deferred-runtime status: the responsibilities described here remain current Architecture.

## 1. Cross-jurisdiction runtime loop

The runtime architecture is a feedback loop. Observation and Situation Assessment are continuous; Responsibility Transition is episodic.

```text
Reality
   |
   v
Observation
   |
   v
Situation Assessment
   |
   +-- same Current Responsibility remains justified
   |          |
   |          `-> Current Responsibility persists
   |              without a transition
   |
   `-- lifecycle change or prospective action is justified
              |
              |  Candidate / Constraint / Decision may specialise
              |  this path where strategic selection is required
              v
       Responsibility Transition
       establishes / terminates / atomically replaces
              |
              v
       Current Responsibility
       |-- GIANTS AI
       |-- Regulation
       `-- Resolution Commitment
              |
              v
       Bounded Authority
              |
              v
            Control
              |
              v
            Reality
```

The diagram crosses several Jurisdictions. It does not transfer ownership between them.

Situation Assessment owns the semantic justification for what responsibility is appropriate now. Responsibility Transition exclusively makes lifecycle change authoritative. Current Responsibility explains why intervention may persist. Bounded Authority specifies what physical action is permitted now. Control realises an already-authorised request. Fresh Control outcomes return through Reality and Observation rather than becoming semantic truth inside Control.

Candidate construction, mandatory constraints and Decision are not redefined here. Their prospective support boundary belongs to the Candidate Support architecture.

---

## 2. Specification Jurisdiction — Operation Lifecycle

**Owns:** Local Operation establishment, Job Episode-scoped bootstrap, Field World admission relationship, membership maintenance, positive Job Episode termination, membership removal and natural Local Operation closure.

**Does not own:** general Observation semantics, Situation interpretation, traffic strategy, Current Responsibility selection, physical representation fitness, Bounded Authority or Control.

**Primary Specification:** [`../../spec/OPERATION_LIFECYCLE.md`](../../spec/OPERATION_LIFECYCLE.md)

### Global Runtime and Local Operations

The Global OuttaMyWay Runtime may host independent field-bounded Local Operations concurrently:

```text
GLOBAL OUTTAMYWAY RUNTIME
|
+-- Local Operation — Field World A
|
+-- Local Operation — Field World B
|
`-- Local Operation — Field World C
```

The global level does not coordinate traffic across fields. Each Local Operation belongs to exactly one resolved Field World, and Local Operations in different Field Worlds are independent.

A **Local Operation** is one ephemeral OuttaMyWay cooperative lifecycle within one resolved Field World, containing between one and three currently active supported GIANTS AI worker assemblies.

- A Local Operation may contain only one worker.
- At most three supported GIANTS AI worker assemblies may be simultaneously active in it.
- Player-controlled vehicles do not count toward that three-AI envelope.
- Interaction, Regulation and Resolution Commitment are not required for it to exist.
- Successive Local Operations in the same Field World are distinct lifecycle instances.

Local Operation is lifecycle context, not a controller or traffic state.

### Field World Equivalence Authority

**Architectural role:** supporting Authority inside the Operation Lifecycle Jurisdiction.

A Job Episode may capture an immutable **Job-Seeded Field World Snapshot** of the contiguous agronomic workspace experienced at admission or bootstrap. Snapshot representation identity and resolved Field World identity are distinct. Each snapshot retains its polygon, exact fingerprint, capture provenance and locators when equivalence is recognised; recognition does not rewrite, merge or discard that evidence.

Field World Equivalence Authority produces exactly one conclusion:

- `SAME_FIELD_WORLD` requires coherent positive evidence that snapshots represent materially the same contiguous agronomic workspace;
- `DIFFERENT_FIELD_WORLD` requires positive separation or incompatibility evidence; and
- `UNRESOLVED` records insufficient, contradictory or only partial evidence and grants no Local Operation admission or extension of cooperative authority.

Failure to prove `SAME_FIELD_WORLD` does not manufacture `DIFFERENT_FIELD_WORLD`, and failure to prove `DIFFERENT_FIELD_WORLD` does not manufacture `SAME_FIELD_WORLD`.

Exact polygon equality may be sufficient positive same-world evidence. An exact fingerprint is compact representation provenance, not universal Field World identity authority. Player-facing field number, farmland identity, seed position and any one scalar geometry metric cannot independently establish identity.

A snapshot may join an established Field World only when coherent with the accepted evidence for that Field World as a whole. Pairwise tolerance chaining must not manufacture an incoherent equivalence class. A restarted or replacement Job Episode captures and independently resolves against current Reality.

Evaluator tolerances and calibration are implementation concerns, not Architecture.

### Sparse intervention

**Architectural role:** Policy and Invariant.

The Local Operation lifecycle exists independently of whether OuttaMyWay ever acquires Regulation or Resolution Commitment. A complete successful lifecycle may be entirely GIANTS-owned:

```text
Job Episode starts
    |
Bootstrap
    |
supported active field work
    |
Local Operation established
    |
GIANTS AI
    |
natural completion
    |
Local Operation closes
```

Normality is GIANTS-owned work. Intervention is sparse and must be positively justified.

### Job Episode Bootstrap

**Architectural role:** lifecycle contract inside Operation Lifecycle.

**Job Episode Bootstrap** is the lifecycle opportunity to discover and cache expensive stable knowledge needed repeatedly during the active GIANTS Job Episode.

Bootstrap is Job Episode-scoped. It may establish Job Episode identity, discover the Physical Assembly, and cache expensive stable active-work representation or capability knowledge. It grants no traffic responsibility.

Bootstrap does not freeze dynamic pose, articulation, configuration state, heading, productive direction or future GIANTS intent. Its job-scoped cache may expire when the Job Episode ends and is not extended merely because a completed assembly remains physically present.

Later movement of a non-active Causal Obstruction may acquire only the fresh capabilities and evidence needed for that intervention. Historical Job Episode cache or provenance is not a prerequisite for recognising or relocating the blocker.

### Establishment and participation

A Job Episode becomes a Local Operation participant when current positive evidence establishes:

```text
qualifying current GIANTS Job Episode
        +
positive supported active field work
        +
resolved Field World relationship
```

The first qualifying participant establishes a Local Operation for that Field World when none exists. A later qualifying Job Episode joins the existing Local Operation.

Job Episode creation alone, worker proximity and conflict do not establish participation. Complete representation capability is not required merely to participate. Representation fitness determines which later conclusions and actions are supportable, not whether an active worker exists in the lifecycle.

**Participation Authority != Intervention Capability.** A worker may be an unquestioned Local Operation participant even when manoeuvre-specific representation or capability evidence remains unresolved.

### Dynamic membership

A stable Local Operation context may contain independently starting and finishing Job Episodes:

```text
membership:
{A}
-> {A,B}
-> {A,B,C}
-> {B,C}
-> {C}
-> {}
```

These are membership changes within one Local Operation, not separate Operations. A restarted or replacement GIANTS job is a new Job Episode and must be independently admitted even when it uses the same Physical Assembly. Prior interaction creates no persistent pair history.

### Lifecycle Evidence Asymmetry

**Architectural role:** Evidence Rule owned here and consumed by other Jurisdictions.

**Positive or complete lifecycle evidence may establish admission, succession, completion or membership removal. Absence under incomplete observation does not itself establish termination, supersession or membership loss.**

Evidence disappearance is not itself a lifecycle event. An incomplete observation may positively establish newly observed membership, but incomplete evidence cannot prove removal of already admitted membership. Job Episode termination requires positive governing evidence, such as authoritative source-job completion or supported succession/replacement evidence. Local Operation membership removal requires sufficiently complete evidence.

This is not a timeout, grace period, cooldown or persistent Encounter mechanism. Current positive contradiction may still end a responsibility where its governing basis is explicitly disproved, and the rule must not preserve stale responsibility indefinitely when complete or positive termination evidence exists.

### Completion leaves occupancy, not responsibility

When a Job Episode completes:

```text
active Job Episode
    |
positive GIANTS completion
    |
Job Episode ends
    |
active Local Operation membership ends
    |
Job-founded responsibilities lose their basis as applicable
    |
Physical Assembly remains Reality
```

**Job Termination Owns Active-Participant Loss.** While a qualifying GIANTS AI Job Episode remains active, player entry or presence does not independently end Local Operation participation or Job-founded responsibility. If the player stops the helper, GIANTS aborts, the job is superseded or restarted, or positive runtime removal establishes termination, the authoritative lifecycle fact is the exact Job Episode ending. Downstream responsibilities consume that terminal fact rather than inventing a parallel player-takeover lifecycle.

Nothing automatically moves a completed assembly. A harmless completed assembly remains where GIANTS left it. Completion creates no terminal lifecycle, completed-worker queue, parking duty, tidying duty or automatic settlement responsibility.

### Natural closure

Natural completion of the final GIANTS worker requires no additional OuttaMyWay closure manoeuvre, settlement phase, parking action or cleanup lifecycle:

```text
one active worker remains
        |
GIANTS AI continues
        |
worker naturally completes
        |
last Job Episode ends
        |
Local Operation closes
```

There is no residual Operation-settling phase. If a Job Episode is externally terminated or superseded during intervention, each affected responsibility loses or surrenders its governing basis according to its own lifecycle, and Control safely neutralises and relinquishes actuation. That is an intervention-termination and Control-safety rule, not a Local Operation closure phase.

---

## 3. External Authority — Reality

Reality is the physical and GIANTS-owned world OuttaMyWay observes. It is not an internal truth model OuttaMyWay creates.

Fresh contradictory Reality outranks stale internal interpretation.

Reality constrains every Specification Jurisdiction but is not itself an OuttaMyWay Specification Jurisdiction.

---

## 4. Specification Jurisdiction — Observation

**Owns:** acquisition and faithful preservation of current evidence from Reality, including provenance, source, freshness, uncertainty, unavailable evidence and raw physical or Control outcomes.

**Does not own:** semantic traffic purpose, Situation classification, Passage choice, regulated subject selection, responsibility persistence, Bounded Authority or physical command.

**Primary Specification:** [`../../spec/OBSERVATION.md`](../../spec/OBSERVATION.md)

Observation answers: **What evidence exists?**

> **Observation reports evidence; it does not assign purpose.**

Missing evidence is not negative evidence. Raw evidence is not a semantic conclusion. Evidence provenance and limits must survive downstream consumption so later Jurisdictions can distinguish positive support, contradiction and unresolved knowledge.

Control outcomes re-enter the architecture through Reality and Observation. Control does not self-certify semantic success.

---

## 5. Specification Jurisdiction — Situation Assessment

**Owns:** semantic interpretation of current evidence for the current Local Operation, including participation meaning, physical relevance, current relationships, obstruction cause, current uncertainty, Regulation justification and whether Resolution obligations remain open, discharged or supportable.

**Does not own:** raw evidence acquisition, representation truth construction, Candidate construction, strategic selection, Responsibility Transition, Bounded Authority or Control.

**Primary Specification:** [`../../spec/SITUATION_ASSESSMENT.md`](../../spec/SITUATION_ASSESSMENT.md)

Situation Assessment answers: **What does current evidence mean for this Local Operation now?**

From current evidence it determines whether the same Current Responsibility remains semantically justified or whether establishment, termination or replacement is justified. It does not itself acquire or release responsibility.

> **Situation Assessment interprets Reality; it does not acquire responsibility.**

### Active participation and physical relevance

An **active participant** is a supported Physical Assembly with a current qualifying GIANTS AI Job Episode participating in the Local Operation.

A **physically relevant entity** can materially affect active work without being an active cooperative worker. Physical relevance is established from current Reality; it does not require prior participation in the Local Operation.

A temporarily stopped active GIANTS AI worker remains an active participant and does not become a non-active blocker merely because its speed is zero.

### Causal Obstruction

**Architectural role:** Situation relationship produced by Situation Assessment.

A **Causal Obstruction** is a current positive Situation relationship in which a physical subject is established as the cause preventing an active supported beneficiary from continuing its supported work.

```text
current Reality
    |
positive causal blockage
    |
CAUSAL OBSTRUCTION
    |-- beneficiary = active supported worker whose continuation is blocked
    `-- blocker     = physical subject causing that blockage
```

**Obstruction Is the Predicate.** A parked, completed, player-owned or otherwise non-active vehicle creates no responsibility merely by existing in the Field World. Conversely, a positively causal blocker must not be made invisible merely because OuttaMyWay has no historical record of it.

**Physical Relevance != Historical Provenance.** Past Job Episode history, previous OuttaMyWay observation, completed-worker provenance, vehicle ownership and prior Local Operation membership are not prerequisites for Causal Obstruction recognition.

### Non-active classification and Player Claim

After Causal Obstruction is established, current blocker classification determines which downstream response may be considered:

```text
Causal Obstruction
    |
    +-- blocker has a current qualifying GIANTS AI Job Episode
    |       -> active spatial negotiation; GIANTS keeps Job ownership
    |
    `-- blocker is non-active
            |
            +-- current Player Claim exists
            |       -> OuttaMyWay must not actuate blocker
            |
            `-- no current Player Claim
                    -> non-active unclaimed blocker;
                       eligible for bounded obstruction resolution
```

A positively ended Job Episode may establish that the same Physical Assembly is non-active for that former Job. An assembly with no Job lifecycle evidence instead requires current observed GIANTS inactivity before non-active relocation may be considered. These are different evidence routes to one non-active classification, not different obstruction responsibilities.

If the same assembly later begins a fresh GIANTS Job, that is an ordinary Situation change. A new active Job Episode is admitted, GIANTS again owns worker mechanics, and any non-active relocation purpose loses its basis.

**Player Entry Is a Claim Boundary, Not a Vehicle Classification.** While a blocker remains an active GIANTS AI participant, player presence does not independently alter Job Episode or responsibility lifecycle. Once the blocker is non-active, current player presence is a human claim and OuttaMyWay must remain hands-off or relinquish actuation.

**Vehicle Ownership != Obstruction Relocation Authority.** Ownership metadata does not replace current claim evidence.

**Obstruction Recognition != Actuation Authority.** Situation Assessment establishes whether the subject is currently the blocker. Resolution and Bounded Authority determine whether and how OuttaMyWay may act.

---

## 6. Specification Jurisdiction — Responsibility Transition

**Owns:** authoritative establishment, termination and atomic replacement of Current Responsibility, including semantic responsibility-instance identity.

**Does not own:** reinterpretation of Reality, Situation Assessment, spatial strategy, regulated-subject selection, magnitude selection, productive routing, retained Resolution obligation lifecycle, Bounded Authority or Control construction.

**Primary Specification:** [`../../spec/RESPONSIBILITY_TRANSITION.md`](../../spec/RESPONSIBILITY_TRANSITION.md)

**Responsibility Transition** is the semantic lifecycle boundary between Current Responsibility instances. A transition is an episodic change justified by fresh Situation Assessment, not ordinary continuation.

If fresh Situation Assessment continues to support the same Current Responsibility, that responsibility and its identity persist without a transition.

> **Maintenance Is Not Transition.**

The authority acts only at these semantic boundaries:

```text
no responsibility       -> new responsibility
existing responsibility -> no responsibility
existing responsibility -> different responsibility
```

Regulation is not a mandatory precursor to Resolution Commitment. It cannot silently mutate into another Regulation purpose or into Resolution Commitment. Fresh assessment justifies the lifecycle change and Responsibility Transition makes it authoritative.

### Atomic semantic replacement

Fresh Situation Assessment may justify direct replacement of Regulation by Resolution Commitment without an artificial GIANTS-AI tick or uncontrolled physical interval:

```text
REGULATION R1
    |
Responsibility Transition
    |-- ends R1
    `-- establishes R2
    |
RESOLUTION COMMITMENT R2
```

The labels illustrate distinct semantic identities, not a prescribed identifier format.

### Responsibility-instance identity

**Responsibility Identity Belongs to Responsibility, Not Its Substrate.** Identity remains stable while the same responsibility persists. Changing Situation evidence, governing basis, Bounded Authority, Control, actuation role, or authority quiescence/reactivation does not churn it. Genuine termination ends that identity; replacement establishes a distinct identity for the successor.

Evidence succession is not Responsibility succession. Continuity of an implementation substrate, mechanical lease or retained commitment mechanism does not prove continuity of Current Responsibility. Settlement of one obligation likewise does not itself create a Responsibility Transition.

---

## 7. Architectural model — Current Responsibility

**Current Responsibility** explains why an intervention may persist now. It is a responsibility model, not a Specification Jurisdiction of its own.

The available responsibility lifecycle is:

```text
GIANTS AI
   <-> Regulation
    |
    v
Resolution Commitment
    |
    v
GIANTS AI
```

This is explanatory, not a mandatory state-machine route.

### GIANTS AI

**Architectural role:** default external responsibility.

GIANTS AI is the default and attractor. GIANTS owns jobs, productive routing and navigation, turning, productive work and ordinary continuation. Shared Local Operation membership alone creates no active OuttaMyWay traffic responsibility.

### Specification Jurisdiction — Regulation

**Owns:** bounded temporal coordination of otherwise GIANTS-owned progression.

**Does not own:** Situation reasons, productive routing, successor reservation, spatial displacement, Responsibility Transition or physical materialisation.

**Primary Specification:** pending `/spec` migration under Issue #141.

Regulation is bounded and reversible. It changes timing rather than productive routes and has weak persistence. An explicit current positive justification is required, and Regulation ends when that justification is positively discharged, invalidated or replaced.

Different Situation reasons do not create architectural Regulation subtypes.

```text
Situation Assessment -> why temporal coordination is justified
Regulation            -> bounded responsibility to alter relative timing
Bounded Authority     -> who may be regulated and by how much now
Control               -> physical realisation of the authorised adjustment
fresh assessment      -> continuation or lifecycle-change justification
Transition            -> authoritative establishment / termination / replacement
```

> **Many Situations, One Regulation Capability.**

Intent revelation, preserved option space, improved ordering, improved prospective Passage theatre and Bubble protection may be Situation-dependent benefits. Regulation's invariant capability remains temporal coordination.

Regulation is **successor-agnostic, not future-blind**. Positive foreseeability of a likely future interaction may justify temporal coordination now, but Regulation does not own, reserve, guarantee or force its successor. Fresh Situation Assessment must independently determine what follows.

Regulation has no cooldown, pair memory or sticky recent-subject rule. One allocation has a bounded uninterrupted authority lifetime; expiry requires fresh assessment and provides no inference of safety, failure or commitment.

**Unresolved Evidence != Positive Responsibility Expiry.** When the same admitted temporal-coordination purpose remains materially live but evidence needed to prove continuation or dissolution is temporarily unavailable, Situation Assessment may classify the relationship as `WAITING_FOR_EVIDENCE`. The same Regulation responsibility may persist through bounded uncertainty. This is maintenance, not a new responsibility.

Positive dissolution, positive supersession, governing-basis cessation or another authoritative lifecycle event may end Regulation. `UNRESOLVED`, temporary evidence absence or watchdog expiry alone cannot be relabelled as successful dissolution. Prolonged uncertainty still requires bounded fail-safe handling or escalation; uncertainty is not authority to hold indefinitely and a timeout is not evidence of safety.

### Specification Jurisdiction — Resolution Lifecycle

**Owns:** the generic persistence, obligation and terminal semantics of Resolution Commitment.

**Does not own:** Situation recognition, concrete resolution choreography, purpose-specific geometry, Bounded Authority or Control mechanics.

**Primary Specification:** [`../../spec/RESOLUTION_LIFECYCLE.md`](../../spec/RESOLUTION_LIFECYCLE.md)

**Resolution Commitment** is a durable accepted resolution obligation. It has strong persistence while legitimate obligations remain open. Obligations, not stale admission predictions or geometry, justify persistence; execution may adapt to fresh Reality.

A Resolution may contain more than one subject-scoped obligation or bounded physical effect. Positive loss of support for one obligation settles only the obligation whose basis has actually ceased. It does not terminate the wider Resolution while other legitimate committed obligations remain open.

> **Partial Basis Cessation != Responsibility Termination.**

Generic terminal reasons are completion, failure, supersession, governing-basis cessation and escalation. Concrete Resolution Jurisdictions specialise these semantics without independently redefining them.

The [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) owns Cooperative Passage admission, Bubble, Passage Leg and dissolution policy. The Obstruction Relocation specialisation is defined below.

### Pre-Semantic Contradiction != Resolution Failure

Control may observe raw evidence that contradicts continued Job ownership before Observation and Operation Lifecycle have established what happened to the exact Job Episode. That raw contradiction is evidence, not Responsibility Transition authority.

While such a contradiction remains unreconciled, Control must not invent a new procedural target or terminalise a Resolution solely from the raw signal. Already-authorised bounded actuation may settle against its current target where that remains safe. Once semantic lifecycle establishes Job Episode termination, the affected Job-founded responsibility is reconciled through its normal basis-loss path. If the contradiction disappears without semantic termination, the existing responsibility may continue.

---

## 8. Specification Jurisdiction — Obstruction Relocation

**Parent Jurisdiction:** Resolution Lifecycle.

**Owns:** the concrete Resolution contract for removing a positively established Causal Obstruction where the blocker is non-active, unclaimed and otherwise supportable for bounded relocation.

**Does not own:** Causal Obstruction recognition, non-active classification, Player Claim classification, general Bounded Authority or generic Control mechanics.

**Primary Specification:** pending `/spec` migration under Issue #141.

### Beneficiary and controlled subject

The entity whose physical state OuttaMyWay changes need not be the entity whose continuity or purpose the intervention serves.

```text
active worker B productively blocked
        |
Situation Assessment establishes Causal Obstruction
beneficiary = B
blocker / controlled subject = A
        |
A classified non-active + unclaimed
        |
fresh Resolution Commitment
purpose = remove the Causal Obstruction
        |
Bounded Authority over A
        |
Control moves A only as justified
        |
Reality reassessed
        |
B can continue / obstruction discharged
```

OuttaMyWay is not looking after, parking or tidying the blocker. Intervention exists only because the current Causal Obstruction prevents supported productive continuation. Once that obstruction is discharged, OuttaMyWay has no independent interest in the subject.

### Geometry-bounded relocation

**Relocation Is Geometry-Bounded, Not Count-Bounded.** While the Causal Obstruction remains positively established, one bounded inward actuation may be authorised toward the Field World centroid, limited to the nearer of the centroid or the current per-actuation maximum. Control then releases physical authority and Reality is reassessed.

A fresh positive obstruction may justify another bounded inward actuation under the same unresolved Resolution while meaningful centroid-directed space remains. The architecture does not count first/second courtesies, create a completed-worker movement budget or prescribe a later boundary-away settlement.

If the blocker remains positively causal but no meaningful inward relocation space remains, this autonomous relocation strategy has no further supported actuation.

Generic positive-conflict representation does not gain negative-clearance authority from this rule. Absence of positive obstruction stops further movement but does not by itself prove semantic clearance where the Resolution contract requires a positive settlement witness.

> **Actuation Recurrence != Resolution Settlement Evidence.**

Historical Job Episode identity may remain diagnostic provenance for a known subject, but it must not gate Causal Obstruction recognition, Resolution justification or bounded relocation of an otherwise-supported non-active unclaimed blocker.

A cold-loaded parked vehicle, a formerly completed AI worker, a player-owned but currently unclaimed vehicle, or another supported non-active physical vehicle can be the same controlled subject when current positive Reality establishes the blocker relationship.

---

## 9. Constraint — Operation context and pairwise Resolution exclusivity

The Current Responsibility model is not the state of the whole Local Operation. Local Operation owns common Field World and lifecycle context; temporary bounded interactions or subjects own active Regulation or Resolution Commitment responsibility.

```text
Local Operation:
A/B : Regulation
C   : GIANTS AI
```

Responsibility contexts may be invoked several times during a Local Operation or never. The architecture creates no persistent state object for every possible pair merely to record GIANTS AI and retains no historical relationship after responsibility ends.

Within one Local Operation, at most one coupled Resolution Commitment is active at a time. Cooperative Passage is admitted only from exactly two current active GIANTS AI worker participants.

Supported at admission:

```text
A <-> B : coupled Resolution Commitment
C       : external / independent / protected
```

Unsupported at admission:

```text
A <-> B <-> C : three-way Resolution Commitment

A <-> B : Resolution #1
B <-> C : Resolution #2
```

**Coupled Admission != Coupled Execution Persistence.** The pair is an admission requirement. After commitment, participant-scoped obligations may progress and reach terminal conditions independently. Positive loss of one original participant does not admit a replacement participant or automatically terminate the wider Resolution while another legitimate obligation remains open.

The third worker does not join the pairwise commitment. Spatial Negotiation owns Passage Leg vacatur, Bubble Protection, Last-Leg Dissolution and third-worker Bullet Time. Pairwise Resolution exclusivity does not imply that all weaker purpose-bound Regulation allocations are globally exclusive.

---

## 10. Specification Jurisdiction — Bounded Authority

**Owns:** the current physical permission derived from Current Responsibility, current Reality and accepted evidence.

**Does not own:** strategic purpose, Responsibility Transition, productive routing, stale geometry preservation, Control execution or semantic Resolution success.

**Primary Specification:** pending `/spec` migration under Issue #141.

Bounded Authority answers: **Given current responsibility and current Reality, what physical action may OuttaMyWay perform now?**

> **Current Responsibility owns why intervention persists. Bounded Authority owns what is permitted now.**

A grant may apply a specific Regulation limit, request supported compaction, permit one currently justified physical leg, or permit restoration and relinquishment where an accepted obligation requires it.

For a non-active unclaimed blocker under an accepted Obstruction Relocation Resolution, Bounded Authority may permit only the compaction and bounded relocation needed to remove the current obstruction. Historical Job provenance or vehicle ownership does not independently enlarge that permission.

Mechanical exclusivity is not semantic permission. Retaining an actuator lease or exclusive mechanical handle cannot continue stale Bounded Authority after the governing semantic permission ends.

Responsibility continuity allows authority discontinuity. The same Regulation responsibility may persist while a speed cap changes, actuation becomes quiescent, the controlled subject changes under accepted evidence, or a fresh grant is later acquired. One Resolution Commitment may also support multiple simultaneous bounded effects where its accepted obligations require them.

For Cooperative Passage, participant-scoped Bounded Authority may end independently when that participant's Passage Leg is handed back or vacated. Releasing one participant's permission does not imply termination of the surviving participant's permission or of the parent Resolution while legitimate obligations remain.

Relinquishment does not require a new grant. A release or quiescence action narrows or ends the active permission. A Bounded Authority grant must not outlive its Current Responsibility.

---

## 11. Specification Jurisdiction — Control

**Owns:** physical realisation of an already-authorised request through supported GIANTS mechanisms and reporting of physical feasibility/outcome.

**Does not own:** strategic purpose, Responsibility Transition, Bounded Authority creation, Regulation magnitude policy, Resolution settlement semantics or alternative-strategy invention.

**Primary Specification:** pending `/spec` migration under Issue #141.

Control answers: **How is this already-authorised physical request realised through available GIANTS mechanisms?**

Control may regulate speed, hold, compact, restore, perform bounded translation/orientation/displacement, stop, neutralise and relinquish authority when those actions are already permitted.

For a non-active Causal Obstruction, an obvious supported compact/fold action is a mechanical aid to relocation rather than an independent semantic objective. The relocation Resolution does not require a separate generic Transit-state lifecycle before already-authorised bounded movement can proceed; current hard-safety evidence and the authorised relocation target remain decisive.

Control reports physical feasibility and outcomes. It does not declare semantic Resolution success merely because an actuator reached a target.

> **Control may discover physical feasibility; it may not invent strategic purpose.**

The dispatch boundary belongs between Bounded Authority and Control. Dispatch may select the appropriate executor, route an authorised request, fail closed when no supported executor exists, and return Control outcomes. Dispatch does not create Bounded Authority or decide responsibility persistence.

### Core capability availability is structural

A core runtime capability has no independent enabled/disabled state beneath the product-level OuttaMyWay master enablement boundary. Once current evidence, Responsibility Transition and Bounded Authority establish a supported action, availability of its supported Control path is part of the runtime topology rather than a second consent or feature decision.

> **Core Capability Has No Enable State.**

> **Master Enablement != Per-Capability Enablement.**

Unsupported or unbounded Control is absent because no valid responsibility and Bounded Authority can authorise it. A boolean implementation flag cannot establish an architectural prohibition.

> **Architectural Prohibition Has No Disable Flag.**

Evidence may explicitly state that it grants no Control authority. Such a negative authority annotation limits what the evidence can prove; it is not a mutable capability-enable state.

> **Negative Authority Annotation != Capability Enable State.**

---

## 12. Invariant — Downstream Authority Monotonicity

A downstream responsibility may narrow, refuse, stop or terminate an authorised action when current safety or feasibility evidence no longer supports it. It may never enlarge strategic authority granted upstream.

```text
Bounded Authority:
move forward under condition Y

Reality:
Y no longer holds

Control:
stop/refuse        = valid
turn left instead  = invalid unless separately authorised
```

Control outcomes return through Reality, Observation and Situation Assessment. Any different strategic action requires fresh upstream authority.

---

## 13. Architectural boundaries

This architecture does not authorise:

- persistent pair-first lifecycle;
- a single Local Operation traffic state;
- three-worker or concurrent pairwise Resolution Commitments;
- completed-worker parking or tidying duties;
- retained ended-job caches as prerequisites for hypothetical future movement;
- cooldown-based responsibility stickiness;
- dense future-route reconstruction;
- universal fixed-distance commitment;
- generic waiting/settling lifecycle states;
- implementation feature flags as semantic authority; or
- Control enlargement of upstream strategic authority.

Runtime implementation and validation remain separate engineering activities. Current implementation placement belongs outside this Architecture; validation evidence belongs to the authorised testing and scenario surfaces.