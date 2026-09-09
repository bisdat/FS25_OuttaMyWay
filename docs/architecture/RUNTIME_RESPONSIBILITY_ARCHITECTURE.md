# OuttaMyWay Runtime Responsibility Architecture

## Purpose and scope

This document defines OuttaMyWay's end-to-end runtime responsibilities: how GIANTS Job Episodes enter and leave cooperative context, when OuttaMyWay may intervene, how responsibility differs from physical authority, and when that context closes.

These are architectural responsibilities, not required implementation modules, classes or controller states. The [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) specialises this parent architecture for active spatial competition during cooperative field work. The [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md) defines the narrower representation model.

## 1. Global Runtime and Local Operations

The Global OuttaMyWay Runtime may host independent field-bounded operations concurrently:

```text
GLOBAL OUTTAMYWAY RUNTIME
|
+-- Local Operation — Field World A
|
+-- Local Operation — Field World B
|
+-- Local Operation — Field World C
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

A Job Episode may capture an immutable **Job-Seeded Field World Snapshot** of
the contiguous agronomic workspace experienced at admission or bootstrap.
Snapshot representation identity and resolved Field World identity are
distinct. Each snapshot retains its polygon, exact fingerprint, capture
provenance and locators when equivalence is recognised; recognition does not
rewrite, merge or discard that evidence.

**Field World Equivalence Authority** produces exactly one conclusion:

- `SAME_FIELD_WORLD` requires coherent positive evidence that snapshots represent materially the same contiguous agronomic workspace;
- `DIFFERENT_FIELD_WORLD` requires positive separation or incompatibility evidence;
- `UNRESOLVED` records insufficient, contradictory or only partial evidence and grants no Local Operation admission or extension of cooperative authority.

Failure to prove `SAME_FIELD_WORLD` does not manufacture
`DIFFERENT_FIELD_WORLD`, and failure to prove `DIFFERENT_FIELD_WORLD` does not
manufacture `SAME_FIELD_WORLD`. Exact polygon equality may be sufficient
positive same-world evidence. An exact fingerprint is compact representation
provenance, not universal Field World identity authority. Player-facing field
number, farmland identity, seed position and any one scalar geometry metric
cannot independently establish identity.

A snapshot may join an established Field World only when coherent with the
accepted evidence for that Field World as a whole. Pairwise tolerance chaining
must not manufacture an incoherent equivalence class. A restarted or replacement
Job Episode captures and independently resolves against current Reality.
Evaluator tolerances and calibration remain implementation evidence, not
architecture.

## 2. Sparse intervention

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
GIANTS AI
    |
natural completion
    |
Local Operation closes
```

Normality is GIANTS-owned work. Intervention is sparse and must be positively justified.

## 3. Job Episode Bootstrap

**Job Episode Bootstrap** is the lifecycle opportunity to discover and cache expensive stable knowledge needed repeatedly during the active GIANTS Job Episode. The cache exists primarily because repeated GIANTS API discovery, including geometry and capability queries, has demonstrated unacceptable cost.

Bootstrap is Job Episode-scoped. It may establish Job Episode identity, discover the Physical Assembly, and cache expensive stable active-work representation or capability knowledge. It grants no traffic responsibility.

Bootstrap does not freeze dynamic pose, articulation, configuration state, heading, productive direction or future GIANTS intent. Its job-scoped cache may expire when the Job Episode ends and is not extended merely because a completed assembly remains physically present.

Later movement of a non-active **Causal Obstruction** may request semantic capabilities such as `compact`, bounded movement, stop and relinquish. Capability and Control acquire only information needed for that fresh intervention on demand. Historical Job Episode cache or provenance is not a prerequisite for recognising or relocating the blocker.

## 4. Establishment and participation

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

### Participation Authority vs Intervention Capability

A worker may be an unquestioned Local Operation participant even when manoeuvre-specific representation or capability evidence remains unresolved.

## 5. Dynamic membership

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

**Positive or complete lifecycle evidence may establish admission, succession, completion or membership removal. Absence under incomplete observation does not itself establish termination, supersession or membership loss.**

Evidence disappearance is not itself a lifecycle event. An incomplete observation may positively establish newly observed membership, but incomplete evidence cannot prove removal of already admitted membership. Job Episode termination requires positive governing evidence, such as authoritative source-job completion or supported succession/replacement evidence. Local Operation membership removal requires sufficiently complete evidence. Temporary observation gaps therefore do not manufacture lifecycle transitions.

This is an evidence-authority rule, not a timeout, grace period, cooldown or persistent Encounter mechanism. Current positive contradiction may still end a responsibility where its governing basis is explicitly disproved, and the rule must not preserve stale responsibility indefinitely when complete or positive termination evidence exists.

## 6. Active participation and physical relevance

An **active participant** is a supported Physical Assembly with a current
qualifying GIANTS AI Job Episode participating in the Local Operation.

A **physically relevant entity** can materially affect active work without being
an active cooperative worker. Physical relevance is established from current
Reality; it does not require prior participation in the Local Operation.

### Causal Obstruction

A **Causal Obstruction** is a current positive Situation relationship in which a
physical subject is established as the cause preventing an active supported
beneficiary from continuing its supported work.

```text
current Reality
    |
positive causal blockage
    |
CAUSAL OBSTRUCTION
    |-- beneficiary = active supported worker whose continuation is blocked
    `-- blocker     = physical subject causing that blockage
```

**Obstruction Is the Predicate.** The obstruction relationship establishes why
the blocker is relevant and why a Resolution may be justified. A parked,
completed, player-owned or otherwise non-active vehicle creates no responsibility
merely by existing in the Field World. Conversely, a positively causal blocker
must not be made invisible merely because OuttaMyWay has no historical record of
it.

**Physical Relevance != Historical Provenance.** Past Job Episode history,
previous OuttaMyWay observation, completed-worker provenance, vehicle ownership,
and prior Local Operation membership are not prerequisites for Causal Obstruction
recognition.

After Causal Obstruction is established, current blocker classification
determines the applicable response:

```text
Causal Obstruction
    |
    +-- blocker has current qualifying GIANTS AI Job Episode
    |       -> active spatial negotiation; GIANTS keeps job ownership
    |
    `-- blocker is non-active
            |
            +-- getIsEntered() == true
            |       -> Current Player Claim; OuttaMyWay must not actuate blocker
            |
            `-- getIsEntered() == false
                    -> unclaimed non-active blocker;
                       eligible for bounded obstruction relocation
```

**Obstruction Recognition != Actuation Authority.** Recognition answers whether
the subject is currently the blocker. Bounded Authority answers which physical
response is permitted. The non-active, unclaimed branch is sufficient to make
the blocker eligible for bounded relocation; historical Job Episode provenance
does not add a further permission prerequisite.

**Player Entry Is a Claim Boundary, Not a Vehicle Classification.** While the
blocker remains an active GIANTS AI participant, `getIsEntered()` is player
presence evidence only and has no independent Job Episode or responsibility
lifecycle authority. Once the blocker is non-active, `getIsEntered()==true`
means the human currently claims that vehicle and OuttaMyWay must remain
hands-off or relinquish immediately. `getIsEntered()==false` means the
non-active blocker is unclaimed and does not veto otherwise-supported
OuttaMyWay relocation.

**Vehicle Ownership != Obstruction Relocation Authority.** Ownership metadata
does not replace current claim evidence. A non-active, unclaimed vehicle that
positively causes a Causal Obstruction is eligible for the same bounded
relocation assessment whether it was formerly an AI worker, was parked before
load, belongs to the player, or has no known Job history.

Active participation remains distinct from physical relevance. A temporarily
stopped active GIANTS AI worker remains an active participant and does not enter
the non-active relocation branch merely because its speed is zero.

## 7. Completion leaves occupancy, not responsibility

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
responsibilities founded on that Job Episode lose their basis as applicable
    |
Physical Assembly remains Reality
```

**Job Termination Owns Active-Participant Loss.** While a qualifying GIANTS AI
Job Episode remains active, player entry/presence does not independently end
Local Operation participation or Job-founded responsibility. If the player
stops the helper, GIANTS aborts, the job is superseded/restarted, or positive
runtime removal establishes termination, the authoritative lifecycle fact is
the exact Job Episode ending. Downstream responsibilities consume that terminal
fact rather than inferring a parallel player-takeover lifecycle.

**Player Claim Boundary.** For an active GIANTS AI participant, player
entry/presence remains lifecycle-neutral: GIANTS owns the Job Episode until
authoritative Job termination. For a non-active physical vehicle,
`getIsEntered()==true` is a current human claim and OuttaMyWay must not acquire
or retain physical actuation authority over that subject; `false` means the
non-active subject is unclaimed. A known Job termination is one way an
AI-active vehicle can enter the non-active domain, but historical Job provenance
is not required when current Reality already establishes that the blocker is
non-active. The validated D-0147 post-job Player Claim is a donor instance of
this broader current-claim boundary.

**Pre-Semantic Contradiction != Resolution Failure.** Control may observe a raw
native Job-token contradiction before Observation and lifecycle authority have
established what happened to the exact Job Episode. That contradiction is
evidence, not Responsibility Transition authority. Control must issue no new
procedural phase or target progression while the contradiction remains
unreconciled; already-authorised bounded actuation may settle against its
current target. Control must not terminalise the Resolution or demand player
intervention solely from the raw contradiction. If semantic lifecycle later
establishes Job Episode termination, the affected Job-founded responsibility is
reconciled through its normal basis-loss path. If the contradiction disappears
without semantic termination, the existing responsibility may continue.

Nothing automatically moves the completed assembly. A harmless completed assembly remains where GIANTS left it. Completion creates no terminal lifecycle, terminal succession, completed-worker queue, parking duty, tidying duty or automatic settlement responsibility.

## 8. Beneficiary and controlled subject

The entity whose physical state OuttaMyWay changes need not be the entity whose
continuity or purpose the intervention serves.

```text
active worker B productively blocked
        |
positive current cause = physical blocker A
        |
Causal Obstruction
beneficiary = B
blocker / controlled subject = A
        |
classify A from current Reality
        |
non-active + unclaimed
        |
fresh Resolution Commitment
purpose = remove the Causal Obstruction
        |
bounded authority over A
        |
Control optionally compacts/folds and moves A only as justified
        |
B can continue
        |
responsibility discharged
```

OuttaMyWay is not looking after, parking or tidying the blocker. Intervention
exists only because the current Causal Obstruction prevents supported productive
continuation. Once that obstruction is removed, OuttaMyWay has no independent
interest in the subject.

A formerly completed AI worker is one possible blocker, not the architectural
definition of the responsibility. A cold-loaded parked vehicle, a vehicle with
unknown Job history, or another supported non-active physical vehicle can be the
same controlled subject when current positive Reality establishes it as the
blocker and no Player Claim exists.

**Current Obstruction Authority Does Not Depend on Historical Job Provenance.**
Historical Job Episode identity may remain useful diagnostic or implementation
provenance for an already-known warm subject, but it must not gate Causal
Obstruction recognition, Resolution justification or bounded relocation of an
otherwise-supported non-active unclaimed blocker.

## 9. Natural closure

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

## 10. Runtime responsibility loop

The architecture is a feedback loop, not a pipeline in which every observation produces a new strategic decision:

```text
Reality
   |
Observation
   |
Situation Assessment
   |
   +-- same responsibility remains justified
   |          |
   |   Current Responsibility persists
   |   with no transition
   |
   +-- lifecycle change justified
              |
       Responsibility Transition Authority
       establishes / terminates / atomically replaces
              |
       Current Responsibility
       |
       +-- GIANTS AI
       +-- Regulation
       +-- Resolution Commitment
                 |
          Bounded Authority
                 |
              Control
                 |
              Reality
```

Situation Assessment is continuous; Responsibility Transition is episodic.
Situation Assessment owns the semantic justification for what responsibility is
appropriate now. **Responsibility Transition Authority** exclusively makes an
establishment, termination or replacement authoritative. When the same
responsibility remains justified, its Current Responsibility instance simply
persists and no Responsibility Transition occurs. Current Responsibility
explains why intervention may persist. Bounded Authority specifies what physical
action is permitted now. Control realises an already-authorised request through
available mechanisms.

## 11. Reality, Observation and Situation Assessment

### Reality

Reality is the physical and GIANTS-owned world OuttaMyWay observes, not an internal truth model OuttaMyWay creates. Fresh contradictory Reality outranks stale internal interpretation.

### Observation

Observation answers: **What evidence exists?**

It samples current Reality and records provenance, timestamp, source, uncertainty, unavailable evidence, and raw physical or Control outcomes. Observation does not assign traffic purpose, decide Passage, choose a yielder, decide persistence or command movement.

> Observation reports evidence; it does not assign purpose.

### Situation Assessment

Situation Assessment answers: **What does current evidence mean for this Local Operation now?**

It interprets participation, physical relevance, productive certainty,
constrained-space relationships, obstruction cause, current uncertainty,
continuing Regulation purpose, and whether Resolution Commitment obligations
remain open, discharged or supportable. From that evidence it determines
whether the same Current Responsibility remains justified or an establishment,
termination or replacement is justified.

Situation Assessment does not acquire or release responsibility, actuate, or preserve stale predictions merely because they were once true.

> Situation Assessment interprets Reality; it does not acquire responsibility.

## 12. Responsibility Transition

**Responsibility Transition** is the semantic lifecycle boundary between Current
Responsibility instances. A transition is an episodic change justified by fresh
Situation Assessment, not ordinary continuation.

**Responsibility Transition Authority** is the sole architectural authority
permitted to establish a new Current Responsibility, terminate an existing
Current Responsibility, or atomically replace one Current Responsibility with
another. Situation Assessment supplies the assessed semantic conclusion;
Responsibility Transition Authority makes the resulting lifecycle change
authoritative. It also establishes the semantic identity of each newly
established responsibility instance.

Responsibility Transition Authority does not reinterpret Reality, redo Situation
Assessment, choose spatial strategy, select a regulated subject or speed
magnitude, select productive routing, construct Control actions, own retained
Commitment or Obligation lifecycle, decide Bounded Authority, or guarantee a
successor.

If fresh Situation Assessment continues to support the same Current
Responsibility, that instance and its identity persist without a transition.
**Maintenance Is Not Transition**: there is no `CONTINUE` transition event merely
for symmetry. The authority acts only at these boundaries:

```text
no responsibility       -> new responsibility
existing responsibility -> no responsibility
existing responsibility -> different responsibility
```

```text
GIANTS AI -> Regulation
Regulation -> GIANTS AI

Regulation -> Resolution Commitment
when fresh assessment justifies atomic replacement

GIANTS AI -> Resolution Commitment directly

Resolution Commitment -> GIANTS AI
```

Regulation is not a mandatory precursor to Resolution Commitment. It cannot silently mutate into another Regulation purpose or into Resolution Commitment; the current responsibility first ends, and fresh assessment independently justifies any successor.

**Semantic Discontinuity Can Be Atomic.** Fresh Situation Assessment may justify
direct replacement of Regulation by Resolution Commitment without an artificial
GIANTS-AI tick, uncontrolled physical interval or mandatory intermediate Current
Responsibility:

```text
REGULATION R1
    |
Responsibility Transition Authority
    |-- ends R1
    `-- establishes R2
    |
RESOLUTION_COMMITMENT R2
```

The notation illustrates distinct semantic identities, not a prescribed
identifier format. Regulation does not mutate into Resolution Commitment, and
this architecture does not decide whether retained AuthorityTokens may be reused
across replacement.

## 13. Current Responsibility

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

### Responsibility-instance identity

**Responsibility Identity Belongs to Responsibility, Not Its Substrate.** When
Responsibility Transition Authority establishes a new Current Responsibility,
it establishes that responsibility instance's semantic identity. Architecture
does not prescribe how the opaque identity is generated, stored or represented.

Identity remains stable while the same responsibility persists. Changing
Situation evidence, governing basis, Bounded Authority, Control, actuation role,
or authority quiescence/reactivation does not churn it. Genuine termination ends
that identity; replacement establishes a distinct identity for the successor.

**Evidence Succession ≠ Responsibility Succession**, and **Substrate Continuity
≠ Responsibility Continuity**. A retained generic Commitment may remain
continuous across a responsibility replacement without becoming Current
Responsibility identity authority. Likewise, **Commitment `REVISE` ≠
Responsibility Continuation** and **Obligation Settlement ≠ Responsibility
Transition**: those substrate operations may participate in implementation but
do not own or prove the semantic boundary.

The known Regulation-to-Cooperative-Passage path is the motivating exemplar:

```text
retained generic Commitment CM-00001
    |-- Regulation responsibility R1
    |-- retained Commitment REVISE
    `-- Resolution Commitment responsibility R2

R1 != R2
```

The identity labels are illustrative only. The direct Resolution exemplars
validated the existing `ResolutionCommitmentAdapter` mapping where retained
Commitment lifetime and observed Resolution lifetime coincided. **Coincident
Identity ≠ Identity Equivalence**: that accepted transitional mapping is not
retrospectively invalid, but it requires reconciliation when Responsibility
Transition Authority is implemented because generic Commitment identity is not
the universal Current Responsibility identity domain.

### GIANTS AI

GIANTS AI is the default and attractor. GIANTS owns jobs, productive routing and navigation, turning, productive work and ordinary continuation. Shared Local Operation membership alone creates no active OuttaMyWay traffic responsibility.

### Regulation

Regulation is the one Current Responsibility for bounded temporal coordination
of otherwise GIANTS-owned progression. It is bounded and reversible, changes
timing rather than productive routes, and has weak persistence. An explicit
current positive justification is required, and Regulation ends immediately
when that justification is discharged, invalidated or replaced. Different
Situation reasons do not create architectural Regulation subtypes.

The responsibility split is:

```text
Situation Assessment → why temporal coordination is currently justified
Regulation           → bounded responsibility to alter relative timing
Bounded Authority    → which subject may be regulated and by how much now
Control              → physical realisation of the authorised adjustment
fresh assessment     → justification for continuation or lifecycle change
Transition Authority → authoritative establishment / termination / replacement
```

This is **Many Situations, One Regulation Capability**. Intent revelation,
preserved option space, improved ordering, improved prospective Passage theatre
and Bubble protection may be Situation-dependent benefits or strategic
objectives. Regulation's invariant capability remains temporal coordination.
The current participant roles, speed magnitude, authority token, progression
envelope and quiescence/reactivation condition belong downstream and do not
define generic Regulation identity.

Regulation is **successor-agnostic**, not future-blind. It does not own, reserve,
guarantee or force its successor. Situation Assessment may nevertheless use
positive foreseeability of a likely future interaction—for example, a highly
probable Cooperative Passage whose natural meeting theatre is poor—to justify
temporal coordination now. Regulation may then alter relative timing so the
probable encounter moves toward better theatre, without acquiring route-planning
or Passage authority. Fresh Situation Assessment must still independently
determine whether GIANTS AI, Regulation or Resolution Commitment follows.

Regulation has no cooldown, pair memory or sticky recent-subject rule. One allocation has a bounded uninterrupted authority lifetime; expiry requires fresh assessment and provides no inference of safety, failure or commitment.

**Unresolved Evidence != Positive Responsibility Expiry.** Weak persistence does
not permit incomplete evidence to manufacture termination. Once Regulation is
established, fresh Situation Assessment may positively classify the current
relationship evidence as `WAITING_FOR_EVIDENCE` when the same admitted temporal
coordination purpose remains materially live but the evidence needed to prove
continuation or dissolution is temporarily unavailable. The same Regulation
responsibility and allocation may persist through that bounded uncertainty; this
is maintenance, not a new Current Responsibility or generic Commitment state.

Positive dissolution, positive supersession, governing-basis cessation or
another authoritative lifecycle event may end the Regulation. `UNRESOLVED`,
temporary evidence absence, or a watchdog expiry alone cannot be relabelled as
successful dissolution. Prolonged uncertainty still requires bounded fail-safe
handling or escalation; uncertainty is not authority to hold indefinitely and a
timeout is not evidence of safety.

### Resolution Commitment

Resolution Commitment is a durable accepted resolution obligation. It has strong
persistence while legitimate obligations remain open. Obligations, not stale
admission predictions or geometry, justify persistence; execution may adapt to
fresh Reality.

A Resolution may contain more than one subject-scoped obligation or bounded
physical effect. Positive loss of support for one such obligation settles only
the obligation whose basis has actually ceased. It does not terminate the wider
Resolution while other legitimate committed obligations remain open.

**Partial Basis Cessation != Responsibility Termination.** A dependency must not
be allowed to manufacture settlement outside the scope it actually governs.

Generic ends are completion, failure, supersession, governing-basis cessation
and escalation. The [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md)
owns detailed Cooperative Passage admission, Passage Leg and Bubble policy.

## 14. Operation Context, Relationship Responsibility

The Three-State Responsibility Model is not the state of the whole Local Operation. The Local Operation owns common Field World and lifecycle context; temporary bounded interactions or subjects own active Regulation or Resolution Commitment responsibility.

```text
Local Operation:
A/B : Regulation
C   : GIANTS AI
```

Responsibility contexts may be invoked several times during a Local Operation or never. The architecture creates no persistent state object for every possible pair merely to record GIANTS AI, and retains no historical relationship after responsibility ends.

## 15. Pairwise Resolution Exclusivity

Within one Local Operation, at most one coupled Resolution Commitment is active
at a time. Cooperative Passage is admitted only from exactly two current active
GIANTS AI worker participants.

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

**Coupled Admission != Coupled Execution Persistence.** The pair is an admission
requirement. After commitment, participant-scoped Passage obligations may
progress and reach terminal conditions independently. Positive loss of one
original participant does not admit a replacement participant, create a new
one-participant Passage, or automatically terminate the existing Resolution
while another legitimate Passage obligation remains open.

The third worker does not join the pairwise commitment. Spatial Negotiation owns
Passage Leg vacatur, Bubble Protection, Last-Leg Dissolution and the exact
1 km/h Bullet-Time policy. This exclusivity does not imply that all weaker,
purpose-bound Regulation allocations are globally exclusive.

## 16. Bounded Authority

Bounded Authority answers: **Given current responsibility and current Reality, what physical action may OuttaMyWay perform now?**

> Current Responsibility owns **why** intervention persists. Bounded Authority owns **what is permitted now**.

It may apply a specific Regulation limit, request supported compaction, perform one currently justified physical leg, or restore and relinquish when an accepted obligation requires it.

For a non-active unclaimed blocker under an accepted Causal Obstruction Resolution, Bounded Authority may permit only the compaction and bounded relocation needed to remove the current obstruction. It does not require completed-Job provenance, vehicle ownership authority or a historical terminal identity.

Bounded Authority does not invent strategic purpose, broaden itself because another manoeuvre is convenient, preserve stale geometry as authority, or create a new Regulation or Resolution Commitment.

A Bounded Authority grant is distinct from both Current Responsibility identity
and mechanical actuation exclusivity. A grant traces a physical permission back
to its `RS-*` Current Responsibility, records the retained `CM-*` substrate and
`AU-*` AuthorityToken provenance, identifies the controlled assembly and
capability, and carries the current bounded target or magnitude plus the
validity envelope supplied by accepted Situation/Candidate evidence.

Mechanical exclusivity is not semantic permission. An `AU-*` AuthorityToken can
show that OuttaMyWay owns actuation exclusivity for an assembly under a retained
Commitment, but it does not by itself answer which physical action is permitted
now. Likewise, retaining or reusing an `AU-*` across an accepted lifecycle path
does not continue old Bounded Authority. Predecessor Bounded Authority ends
before successor physical Control becomes executable.

Responsibility continuity allows authority discontinuity. The same `RS-*`
Regulation may persist while a speed cap changes, current actuation becomes
quiescent, the controlled subject migrates under accepted evidence, or a fresh
grant is later acquired. A single `RS-*` Resolution Commitment may also
authorize multiple simultaneous bounded effects where its accepted obligation
requires them, for example one Cooperative Passage reposition permission per
participant or protected-demand Regulation plus completed-subject movement
during completed-obstruction resolution.

For Cooperative Passage, participant-scoped Bounded Authority may end
independently when that participant's Passage Leg is handed back or vacated.
Releasing one participant's grant does not imply termination of the surviving
participant's grant or of the parent Resolution Commitment while legitimate
Passage obligations remain.

Relinquishment does not require a new grant. A release or quiescence request
references the active grant whose physical effect is being narrowed or ended;
after the physical effect is removed, the grant is released. A grant must not
outlive its Current Responsibility.

## 17. Control

Control answers: **How is this already-authorised physical request realised through available GIANTS mechanisms?**

Control may regulate speed, hold, compact, restore, perform bounded forward/reverse/orientation/displacement, stop, and relinquish authority. For a non-active Causal Obstruction, an available obvious compact/fold action is a mechanical aid to relocation rather than a semantic objective or Transit-state prerequisite. Control may request that compaction and proceed with the already-authorised bounded relocation without waiting for a separate `isTransit` verdict, fold-completion confirmation or configuration-settlement lifecycle. Current hard-safety evidence and the bounded relocation target remain authoritative throughout.

Control reports physical feasibility and outcomes. It does not invent strategic alternatives or declare semantic Resolution success merely because an actuator reached a target.

> Control may discover physical feasibility; it may not invent strategic purpose.

The live dispatch boundary belongs between Bounded Authority and Control. A
dispatcher may select the appropriate Control executor, route an already
authorised `ControlRequest`, fail closed when no executor exists, and forward
Control outcomes. It does not create Bounded Authority, choose Regulation
magnitude, decide responsibility persistence or settlement, or mirror semantic
authority state.

## 18. Downstream Authority Monotonicity

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

## 19. Architectural boundaries

This architecture does not authorise persistent pair-first lifecycle, a single Local Operation traffic state, three-worker or concurrent pairwise Resolution Commitments, completed-worker parking duties, retained ended-job caches for hypothetical movement, cooldown-based responsibility stickiness, dense future-route reconstruction, universal fixed-distance commitment, or generic waiting/settling lifecycle states.

Runtime implementation and validation remain separate engineering activities.
