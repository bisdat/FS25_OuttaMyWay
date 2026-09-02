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

Exceptional later movement of a completed obstruction may request semantic capabilities such as `compact`, bounded movement, stop and relinquish. Capability and Control acquire only information needed for that fresh intervention on demand; the ended Job Episode's cache need not survive.

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

## 6. Active participation and physical relevance

An **active participant** is a supported Physical Assembly with a current qualifying GIANTS AI Job Episode participating in the Local Operation.

A **physically relevant entity** can materially affect active work without being an active cooperative worker. Examples include a completed assembly, a player-controlled vehicle, or another supported physical subject where architecture permits.

Active participation is not synonymous with physical relevance. Completed assemblies do not remain active members merely because they remain in the Field World.

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

Nothing automatically moves the completed assembly. A harmless completed assembly remains where GIANTS left it. Completion creates no terminal lifecycle, terminal succession, completed-worker queue, parking duty, tidying duty or automatic settlement responsibility.

## 8. Beneficiary and controlled subject

The entity whose physical state OuttaMyWay changes need not be the entity whose continuity or purpose the intervention serves.

```text
active worker B productively blocked
        |
positive cause = completed assembly A
        |
fresh Resolution Commitment
beneficiary = B
controlled subject = A
purpose = restore B's supported productive continuity
        |
bounded authority over A
        |
Control compacts/moves A only as justified
        |
B can continue
        |
responsibility discharged
```

OuttaMyWay is not looking after or parking the completed worker. Intervention exists on behalf of the active productive beneficiary and requires fresh positive purpose. Once productive continuity is restored, OuttaMyWay has no independent interest in further tidying. The detailed mechanism and its eventual name remain matters for later reconciliation.

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
   +-- no responsibility transition
   |
   +-- Responsibility Transition when justified
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

Situation Assessment is continuous; Responsibility Transition is episodic. Current Responsibility explains why intervention may persist. Bounded Authority specifies what physical action is permitted now. Control realises an already-authorised request through available mechanisms.

## 11. Reality, Observation and Situation Assessment

### Reality

Reality is the physical and GIANTS-owned world OuttaMyWay observes, not an internal truth model OuttaMyWay creates. Fresh contradictory Reality outranks stale internal interpretation.

### Observation

Observation answers: **What evidence exists?**

It samples current Reality and records provenance, timestamp, source, uncertainty, unavailable evidence, and raw physical or Control outcomes. Observation does not assign traffic purpose, decide Passage, choose a yielder, decide persistence or command movement.

> Observation reports evidence; it does not assign purpose.

### Situation Assessment

Situation Assessment answers: **What does current evidence mean for this Local Operation now?**

It interprets participation, physical relevance, productive certainty, constrained-space relationships, obstruction cause, current uncertainty, continuing Regulation purpose, and whether Resolution Commitment obligations remain open, discharged or supportable.

Situation Assessment does not acquire or release responsibility, actuate, or preserve stale predictions merely because they were once true.

> Situation Assessment interprets Reality; it does not acquire responsibility.

## 12. Responsibility Transition

**Responsibility Transition** is an episodic change in OuttaMyWay responsibility justified by fresh Situation Assessment. It establishes the purpose and governing basis of a new responsibility but does not actuate vehicles.

```text
GIANTS AI -> Regulation
Regulation -> GIANTS AI

Regulation purpose ends
fresh assessment
GIANTS AI -> Resolution Commitment

GIANTS AI -> Resolution Commitment directly

Resolution Commitment -> GIANTS AI
```

Regulation is not a mandatory precursor to Resolution Commitment. It cannot silently mutate into another Regulation purpose or into Resolution Commitment; the current responsibility first ends, and fresh assessment independently justifies any successor.

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

### GIANTS AI

GIANTS AI is the default and attractor. GIANTS owns jobs, productive routing and navigation, turning, productive work and ordinary continuation. Shared Local Operation membership alone creates no active OuttaMyWay traffic responsibility.

### Regulation

Regulation is bounded reversible temporal adjustment. It changes timing, not productive routes, and has weak persistence. An explicit current purpose is required, and Regulation ends immediately when that purpose is discharged, invalidated or replaced.

Regulation has no cooldown, pair memory or sticky recent-subject rule. One allocation has a bounded uninterrupted authority lifetime; expiry requires fresh assessment and provides no inference of safety, failure or commitment.

### Resolution Commitment

Resolution Commitment is a durable accepted resolution obligation. It has strong persistence while legitimate obligations remain open. Obligations, not stale admission predictions or geometry, justify persistence; execution may adapt to fresh Reality.

Generic ends are completion, failure, supersession, governing-basis cessation and escalation. The [Spatial Negotiation Model](SPATIAL_NEGOTIATION_MODEL.md) owns detailed spatial admission and policy.

## 14. Operation Context, Relationship Responsibility

The Three-State Responsibility Model is not the state of the whole Local Operation. The Local Operation owns common Field World and lifecycle context; temporary bounded interactions or subjects own active Regulation or Resolution Commitment responsibility.

```text
Local Operation:
A/B : Regulation
C   : GIANTS AI
```

Responsibility contexts may be invoked several times during a Local Operation or never. The architecture creates no persistent state object for every possible pair merely to record GIANTS AI, and retains no historical relationship after responsibility ends.

## 15. Pairwise Resolution Exclusivity

Within one Local Operation, at most one coupled Resolution Commitment is active at a time, and it has exactly two active GIANTS AI worker participants.

Supported:

```text
A <-> B : coupled Resolution Commitment
C       : external / independent / protected
```

Unsupported:

```text
A <-> B <-> C : three-way Resolution Commitment

A <-> B : Resolution #1
B <-> C : Resolution #2
```

The third worker does not join the pairwise commitment. Spatial Negotiation owns Bubble Protection and exact 1 km/h Bullet-Time policy. This exclusivity does not imply that all weaker, purpose-bound Regulation allocations are globally exclusive.

## 16. Bounded Authority

Bounded Authority answers: **Given current responsibility and current Reality, what physical action may OuttaMyWay perform now?**

> Current Responsibility owns **why** intervention persists. Bounded Authority owns **what is permitted now**.

It may apply a specific Regulation limit, request supported compaction, perform one currently justified physical leg, or restore and relinquish when an accepted obligation requires it.

Bounded Authority does not invent strategic purpose, broaden itself because another manoeuvre is convenient, preserve stale geometry as authority, or create a new Regulation or Resolution Commitment.

## 17. Control

Control answers: **How is this already-authorised physical request realised through available GIANTS mechanisms?**

Control may regulate speed, hold, compact, restore, perform bounded forward/reverse/orientation/displacement, stop, and relinquish authority. Capability resolution for a completed obstruction may discover that an assembly is already compact, supports a transition, has no applicable transition, or is unsupported.

Control reports physical feasibility and outcomes. It does not invent strategic alternatives or declare semantic Resolution success merely because an actuator reached a target.

> Control may discover physical feasibility; it may not invent strategic purpose.

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
