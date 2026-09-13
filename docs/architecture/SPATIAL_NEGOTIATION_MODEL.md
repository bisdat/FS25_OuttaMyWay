# Spatial Negotiation Architecture

## Purpose and architectural boundary

This document specialises the [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) for temporary competition for space among active supported GIANTS AI workers inside one Local Operation.

It defines the spatial Situation meaning, temporal-coordination policy and concrete Cooperative Passage contract needed to preserve useful space while GIANTS retains productive-job ownership.

This is current Architecture. It defines responsibilities, concepts, constraints, evidence rules, policies and lifecycle boundaries; it does not define source modules, helper topology, implementation chronology or validation history.

The [Physical Representation Architecture](PHYSICAL_REPRESENTATION_ARCHITECTURE.md) owns representation semantics and validity. The [Candidate Support Projection Architecture](CANDIDATE_SUPPORT_PROJECTION.md) owns the generic prospective Candidate-support boundary between Situation Assessment and Decision. Generic Current Responsibility, Resolution persistence, Bounded Authority and Control semantics remain owned by the parent Runtime architecture.

## Specification Jurisdictions and specialisations

Spatial Negotiation is an architectural specialisation, not a Specification Jurisdiction of its own.

This architecture specialises two Jurisdictions declared by the Runtime architecture and declares one concrete Resolution Jurisdiction:

| Specification Jurisdiction | Spatial architectural responsibility |
| --- | --- |
| **Situation Assessment** | Interpret current spatial evidence, pair relationships, constrained-space scarcity and Passage foreseeability. |
| **Regulation** | Apply the parent's temporal-coordination responsibility to spatial reasons such as intent revelation, Resolution-Space preservation and Passage-theatre shaping. |
| **Cooperative Passage** | Own the purpose-specific Passage Candidate/commitment contract, Bubble and Passage-Leg lifecycle, coupled obligations, third-party protection requirement and Last-Leg Dissolution. |

**Cooperative Passage** is a specialised Jurisdiction beneath the parent **Resolution Lifecycle** Jurisdiction. It depends on generic Resolution persistence and obligation semantics but does not redefine them.

Current Pair Assessment Scope, Productive Forward-Line Certainty, TURNING uncertainty, the Spatial Constraint Overlay, Bubble, Passage Leg, Resolution Epoch and Passage reserve are Concepts, Evidence Rules, Policies or lifecycle elements within these Jurisdictions. They do not create additional Specification Jurisdictions merely by being separately named.

The primary Cooperative Passage `/spec` route is [`../../spec/COOPERATIVE_PASSAGE.md`](../../spec/COOPERATIVE_PASSAGE.md). The inherited Situation Assessment and Regulation `/spec` routes remain pending under the bounded standards-adoption exception in [`../DOCUMENT_STANDARDS.md`](../DOCUMENT_STANDARDS.md), with Issue #141 owning that remaining repository migration.

## 1. Cross-jurisdiction spatial flow

Spatial Negotiation crosses several Jurisdictions without transferring their ownership:

```text
Reality
   |
   v
Observation
   |
   v
Situation Assessment
   |-- current pair scope
   |-- spatial scarcity
   |-- productive certainty / uncertainty
   `-- Passage foreseeability
   |
   +---------------------------+
   |                           |
   | temporal coordination     | prospective Resolution
   v                           v
Regulation              Candidate Support / Decision
   |                           |
   |                           v
   |                  Responsibility Transition
   |                           |
   |                           v
   |                  Cooperative Passage
   |                    Resolution Commitment
   |                           |
   +---------------------------+
                               |
                        Bounded Authority
                               |
                               v
                             Control
                               |
                               v
                             Reality
```

Situation Assessment owns current spatial meaning. Regulation owns bounded temporal coordination once established. Candidate Support, mandatory constraints and Decision own the generic prospective-selection boundary. Responsibility Transition makes the selected Current Responsibility authoritative. Cooperative Passage owns the concrete coupled Resolution contract. Bounded Authority and Control remain downstream.

---

## 2. Scope and governing constraints

Spatial Negotiation manages temporary competition for space among active supported workers within one Local Operation. The supported envelope remains at most **three simultaneously active GIANTS AI worker assemblies**, with validation targeted at **different agronomic roles**. Player-controlled vehicles do not count toward that limit.

GIANTS retains AI jobs, productive routing/navigation, native turning and productive work. Spatial Negotiation does not become a route planner, agronomic scheduler or same-agronomy fleet coordinator.

Least intervention is preferred. Player intervention remains a legitimate final outcome when no supported autonomous resolution remains.

The governing spatial constraints are:

1. **Partial observability is permanent.** Future GIANTS intent is not generally known while a worker is `TURNING`.
2. **Physical non-contact is mandatory.** Nominal Passage clearance is an empirical policy margin, not a precise collision calculation. Passage uses its purpose-specific representation; generic proximity or physical-conflict evidence does not independently establish Passage contact.
3. **Field space is non-uniform.** Corners and headlands reduce manoeuvre options; open field is comparatively cheap spatial capacity.
4. **Time consumes options.** Waiting for certainty is not free when native progression consumes Resolution Space.
5. **Actuation is limited.** Spatial policy must use available native progression, Regulation/Hold, supported configuration, bounded Passage displacement/recovery and supported obstruction relocation.
6. **Performance is a hard constraint.** Policy must not require continuous field painting, dense future-route simulation or sophisticated articulated swept-volume prediction.
7. **Accepted obligations remain real until discharged.** Changing observations or execution geometry do not erase configuration, displacement or recovery debt created by intervention.

Spatial scarcity alone is evidence, not an automatic slowdown trigger.

---

## 3. Situation Assessment specialisation

**Parent Jurisdiction:** Situation Assessment.

This specialisation owns spatial interpretation only. It does not acquire Regulation, construct generic Candidate machinery, establish Resolution Commitment, grant Bounded Authority or actuate.

### Current Pair Assessment Scope

Within one current Local Operation, Situation Assessment enumerates unordered pairs from the exact currently active Job Episodes.

**Current Pair Assessment Scope** is ephemeral scope for pairwise Situation questions, not a persistent relationship object.

The scope is rebuilt from current Operation membership and exact active Job Episodes for every Operational Picture. It may carry current Operation, Physical Assembly and exact Job Episode provenance so purpose-specific assessments ask questions about the same current subjects.

It does not retain a generic pair lifecycle, last-positive relationship, cooldown, right-of-way, responsibility or future-route ownership.

When positive interaction evidence disappears and the relevant representation owns no supported negative conclusion, the current relationship is `UNRESOLVED`. Historical positive evidence is not republished as current Reality.

> **Current Pair Assessment Scope != Persistent Pair History**

> **Evidence Continuity != Evidence Freshness**

> **Absence Is Not Separation**

> **Unresolved Evidence Is Non-Authority, Not Universal Prohibition**

Unresolved generic pair evidence cannot manufacture safe separation or authorise movement. It also does not veto an independently supported purpose-specific Candidate merely because a generic representation lacks negative-clearance authority.

Once Regulation or Resolution Commitment has been established, justified persistence belongs to that Current Responsibility and its obligations. Current Pair Assessment Scope does not survive as a parallel lifecycle object.

### Productive Forward-Line Certainty — A8

**Architectural role:** Evidence Rule.

While GIANTS AI positively establishes productive working progression, its immediate productive continuation is treated as **forward and straight along the current productive axis**.

This assumption is local. It does not predict through the end of the productive run or through a later headland turn.

The **productive-certainty horizon** is the remaining forward interval over which that continuation can remain authoritative before Field World geometry requires transition. Fresh Reality overrides A8 earlier when GIANTS changes state.

### TURNING uncertainty boundary

`TURNING` primarily reveals intent. Transient turning vectors may support spatial concern or a current Regulation purpose, but they do not independently establish Cooperative Passage.

Once productive working progression is positively re-established, A8 certainty is reacquired from fresh Reality. Passage foreseeability is not remembered across the uncertainty boundary.

### Spatial evidence precedence

Fresh positive Reality outranks historical inference.

Sparse demonstrated agronomic progression may adjust confidence when already cheaply available, but no reconstructed future route gains governing authority.

### Spatial Constraint Overlay

**Architectural role:** current option-space evidence consumed by Situation Assessment.

The Field World supplies evidence about local option-space scarcity:

- **Category 1 — corner:** very limited manoeuvre option space;
- **Category 2 — headland/boundary:** materially constrained, but less severe than a corner; and
- **Open field:** comparatively generous Resolution Space.

Entering a zone does not itself trigger Regulation.

The overlay may influence whether temporal coordination is justified, which party can most cheaply give time, and when constrained-space occupancy should be allowed to reveal or vacate. These categories are not Regulation types and do not create another Current Responsibility kind.

#### One worker inside, one outside

Constrained-space occupancy creates an **evacuation preference**. Preserve the occupant's native opportunity to reveal intent and vacate; regulate a relevant worker in less-constrained space where necessary. Do not immobilise the party that must move to free scarce space when another can cheaply wait outside it.

#### Neither worker inside, both approaching

Choose the provisional allocation that preserves more Resolution Margin and intent-revelation time. Do not reduce this to in-field position, agronomy, leader/follower identity or nearest-to-corner priority.

#### Both workers inside Category 1

This is a degraded-entry condition the normal architecture must try to prevent. Preserve a worker positively creating space and regulate the other. If no clearly safe space-creating action exists, fail safe and allow player escalation rather than inventing heroic choreography.

Spatial precedence is temporary and evidence-based.

### Cooperative Passage foreseeability

Cooperative Passage is foreseeable only while current evidence positively supports all of these conditions:

1. both workers are A8-valid;
2. their productive directions are substantially opposed;
3. their represented productive corridors genuinely compete rather than merely being adjacent; and
4. the prospective encounter occurs before either productive-certainty horizon expires.

If either worker must first reach a headland or transition, A8 does not predict Passage through that future turn.

Foreseeability is a Situation Assessment conclusion, not an obligation. It disappears when fresh Reality invalidates its evidence.

### Passage recognition geometry

Passage recognition geometry is not Passage Candidate geometry.

Recognition uses each complete Physical Assembly's actual current productive or working configuration. Current directional working extents and represented productive corridors must establish genuine corridor competition. A compact or Transit representation must not shrink a deployed productive corridor for the recognition question.

Generic broad physical-conflict evidence or GIANTS blocked/proximity signals do not independently establish Passage contact or Passage clearance.

> **Generic Physical Conflict != Passage Physical Conflict**

Purpose-specific Passage representation remains authoritative for the Passage question within the limits granted by the Physical Representation Architecture.

---

## 4. Regulation specialisation

**Parent Jurisdiction:** Regulation.

Spatial Situation Assessment may justify the parent's single Regulation responsibility for reasons including:

- allowing native intent to reveal;
- preserving Resolution Margin;
- allowing occupied constrained space to reveal or vacate;
- protecting prospective Passage theatre; and
- managing an independent third worker during an accepted Resolution Epoch.

These are Situation reasons and strategic benefits, not distinct Regulation types.

> **Many Situations, One Regulation Capability**

Regulation is admissible when developing spatial competition is relevant, uncertainty or preserved theatre still has material value, and continued native progression is consuming the opportunity to wait safely for better evidence or execution space.

Regulation changes timing, not productive routes. Prefer an allocation that preserves more Resolution Space and useful revelation time. If several choices are adequately viable, use a deterministic tie-break rather than expensive optimisation. The regulated party is not a permanent loser.

### Intent-Revelation Creep

Where Intent-Revelation Creep is the accepted temporal policy, its exact magnitude is **1 km/h**.

This is a purpose-bound architectural policy, not a general Regulation tuning parameter.

### Forward Intersection evidence continuity

> **Forward Intersection Unresolved != Forward Intersection Dissolved**

Once a Forward Intersection temporal allocation has been admitted, loss of supported forward continuation while GIANTS reveals a boundary manoeuvre does not itself prove that the constrained spatial relationship has disappeared.

Situation Assessment may classify the same Regulation purpose as `WAITING_FOR_EVIDENCE` and preserve its existing yielder allocation and exact 1 km/h Intent-Revelation Creep while fresh Reality resolves the ambiguity.

This grants no turn-path prediction and creates no `TURNING` route authority. Supported negative Forward Intersection evidence may positively dissolve the allocation; an established valid relationship may positively supersede it. Temporary unresolvability or missing continuation evidence may do neither.

A bounded fail-safe may force reassessment or escalation if evidence does not recover, but timeout expiry alone must not manufacture a safe or dissolved conclusion.

### Passage-theatre shaping

High-confidence Passage foreseeability, poor natural encounter theatre and useful temporal adjustment may justify Regulation before Passage commitment.

Regulation changes relative timing only. It does not create Passage, reserve Passage as the successor or acquire spatial-routing authority.

> **Successor-Agnostic != Future-Blind**

Suitable theatre must support the complete downstream Passage lifecycle, including crossing, Alignment Runout, Axis Settlement/Return where required, restoration and GIANTS handback.

Changing progression for an opposed A8 pair changes its prospective encounter position. Regulation may move that position into a viable interval where both participants retain sufficient downstream space. Stop shaping once Passage is sufficiently viable; least intervention wins.

If shaping moves the encounter beyond either productive-certainty horizon, the forecast legitimately disappears and fresh Situation Assessment takes over. Regulation is never obliged to preserve Passage.

---

## 5. Specification Jurisdiction — Cooperative Passage

**Parent Jurisdiction:** Resolution Lifecycle.

**Owns:** the purpose-specific Passage Candidate and commitment contract; Passage-specific geometry and reserve requirements; Bubble Formation; participant-scoped Passage Legs; shared coupled obligations; Passage-specific third-party protection requirement; intervention-created recovery/restoration debt; and Last-Leg Dissolution.

**Does not own:** raw Observation, generic Situation Assessment, generic Candidate/Constraint/Decision machinery, Responsibility Transition, generic Resolution persistence, generic Bounded Authority, generic Control mechanics, productive routing or future GIANTS intent.

**Primary Specification:** [`../../spec/COOPERATIVE_PASSAGE.md`](../../spec/COOPERATIVE_PASSAGE.md)

Cooperative Passage is a pairwise Resolution Commitment. It is distinct from Regulation: many Regulation episodes never require coupling, and straightforward opposed Passages may require no prior Regulation.

### Candidate and commitment boundary

Situation Assessment establishes current Passage foreseeability and genuine corridor competition. The Candidate Support architecture owns the generic machinery by which prospective alternatives, mandatory constraints and Decision are evaluated. Cooperative Passage owns the purpose-specific requirements that make a Passage Candidate semantically meaningful.

When a Passage Candidate requires a compact or Transit geometry basis, cached directional Transit geometry for the complete Physical Assembly may construct and test the simple Passage arrangement before physical Transit realisation. This may include facing extents, Passage clearance, Development burden and crossing-window physical extents.

Complete Physical Assembly membership is mandatory. Internally complete Transit dimensions for only a subset of the Physical Assembly are insufficient. Directional offsets and asymmetric extents remain valid and must not be recentered without evidence.

```text
current working geometry
    |
    v
Situation Assessment recognises genuine Passage competition
    |
    v
purpose-specific Passage Candidate
using supported complete-assembly geometry
    |
    v
Candidate Support / mandatory constraints / Decision
    |
    v
Responsibility Transition
    |
    v
Cooperative Passage Resolution Commitment
```

Selection and commitment occur only after a supported Candidate and arrangement exist. Physical compact/Transit realisation is not a prerequisite for Candidate planning authority.

Physical guide movement relying on a compact/Transit-conditioned plan must not treat planned configuration as realised Reality. Fresh Reality at the configuration/settlement and execution-origin boundary governs whether the retained Passage geometry remains executable or requires supported adaptation before physical Passage movement.

This purpose-specific contract does not claim generic current collision-shape Coverage Closure or generic negative-clearance authority. It uses the coarsest representation demonstrated sufficient for the Passage question; more detailed manoeuvre-sweep construction is not a Passage prerequisite without new Reality evidence.

### Passage clearance policy

Physical non-contact is mandatory.

The nominal Passage-clearance policy is approximately **1 m**, with purpose-specific representation supplying the geometry to which that policy applies. The margin is empirical policy, not a precise collision calculation.

If Reality demonstrates that accepted representation plus the current margin is insufficient, the architectural response begins by re-evaluating the empirical clearance policy and its representation assumptions rather than automatically introducing a more complex dynamics model.

### Passage reserve and capture

Passage commitment is governed by remaining usable space and time, not by one universal distance literal.

The required Passage reserve includes:

- represented forward physical extents;
- `2 x Development` longitudinal space; and
- the coarse **3 m Passage Entry Control Allowance**.

The Entry Control Allowance is spatial reserve for acquiring/control-settling the pair. It is not a GIANTS braking model.

For foreseeable Passage, distinguish the **required Passage reserve** remaining after capture from the **disposable native approach margin** above it. Current closing speed determines how rapidly disposable margin is consumed. Commitment becomes due before independent approach consumes the space/time needed to acquire and settle both workers while retaining the required reserve.

Configuration duration is not itself pre-commit lead time because capture controls closing progression. Candidate-scoped geometry may support Development and downstream Passage construction before commitment; physical movement under the accepted Resolution remains Reality-bound.

### Bubble Formation

Under the parent Pairwise Resolution Exclusivity constraint, Cooperative Passage is admitted only from exactly two active GIANTS AI worker participants and at most one coupled Resolution Commitment may exist within a Local Operation.

A **Bubble** is the coupled pairwise context created specifically by Cooperative Passage Resolution Commitment.

It forms only when fresh evidence still supports Passage, the required reserve remains viable, independent approach nears the latest safe capture point, and the pair accepts jointly dependent Passage obligations.

At Bubble Formation the accepted Passage is expressed as two participant-scoped **Passage Legs** under one Resolution Commitment. The pair is required to establish the coupled responsibility; the two execution legs need not remain symmetrically live afterwards.

Bubble Formation begins the **Resolution Epoch**.

Bubble owns only its originating pair, Passage Legs, shared coupled obligations, Bubble Protection, Resolution-Epoch third-party protection scope and Last-Leg Dissolution. It creates no permanent pair history, future-route ownership or right-of-way.

### Passage Leg contract

A **Passage Leg** is one original participant's already-committed physical execution and intervention-created debt within Cooperative Passage.

Depending on what the Passage actually required, a leg may include:

- capture and Passage movement;
- Alignment Runout;
- Axis Settlement/Return;
- intervention-created configuration or physical recovery/restoration debt; and
- GIANTS handback.

The parent Resolution Commitment persists while any legitimate Passage Leg or shared Bubble obligation remains open.

> **Pairwise Resolution != Symmetric Progress Requirement**

The two Passage Legs may progress and terminate at different times.

Passage owns only intervention-created debt. It does not reconstruct pre-existing imperfections or articulation. Physical crossing alone is not completion; each still-live Passage Leg retains its required recovery, restoration and handback debt.

### Reality-verified execution

Committed Passage remains Reality-sensitive.

The execution contract must continue to respect:

- realised compact/Transit width and natural separation;
- actual clearance deficit;
- Development burden;
- execution origin;
- current physical occupancy;
- guide geometry and lateral allocation while they remain prospective rather than physically committed; and
- recovery debt derived from the manoeuvre actually executed.

Stale early guide assumptions have no independent authority. The execution boundary after capture/configuration must return to fresh Reality before Passage movement that depends on the realised geometry.

Once a physical leg begins, its locally authorised execution choice should remain stable enough to avoid unsafe oscillation. Hard safety remains authoritative.

### Passage Leg terminal dispositions

A Passage Leg has two ordinary terminal dispositions:

- **HANDED_BACK** — its required Passage debt is discharged and the participant is returned to GIANTS AI; and
- **VACATED** — positive Reality establishes that OuttaMyWay can no longer execute that original participant as the committed AI Passage subject.

**Participant Loss Vacates a Passage Leg; It Does Not Cancel the Passage.**

For a still-live Passage Leg, active-participant loss is established by authoritative termination of that leg's exact original GIANTS Job Episode. Natural completion, player-stopped work, GIANTS abort/supersession/restart and positive runtime-subject removal may be different causes or evidence paths for that Job Episode termination; they are not parallel Passage lifecycles.

Player presence while the exact Job Episode remains active has no independent Passage lifecycle effect. Incomplete observation or mere absence cannot establish vacatur under Lifecycle Evidence Asymmetry.

Vacatur settles only the obligations and physical authority belonging to that Passage Leg. It admits no replacement participant and creates no new Candidate, Resolution Commitment, cleanup responsibility or survivor mode for the other leg.

**Survivor Invariance:** the surviving Passage Leg continues the same already-committed Passage choreography it would have followed had the other leg remained executable: Passage, runout, Axis recovery/return, intervention-created restoration debt and GIANTS handback as applicable. The vacated leg is removed as a procedural dependency.

**Choreography Vacatur != Physical Disappearance.** A former participant whose Passage Leg is vacated ceases to be a Passage-phase dependency but remains current physical Reality if still present. Current occupancy may therefore still constrain the surviving leg through fresh hard-safety evidence.

### Pre-semantic contradiction

A raw physical or runtime contradiction may be observed before the governing Job Episode lifecycle has been semantically resolved.

Such evidence may suspend unsupported new procedural progression, but it cannot by itself produce Passage failure, dissolve the Bubble, vacate a leg or demand player intervention.

Already-authorised bounded actuation may settle only against its existing authorised target while semantic lifecycle catches up. Once authoritative Job Episode termination is established, normal Passage-Leg vacatur and Survivor Invariance apply.

> **Pre-Semantic Contradiction != Resolution Failure**

### Third-worker serialization

Before Passage commitment, all workers remain independent. Regulation may manage an independent third worker whose progression threatens prospective Passage theatre. Existing third-worker occupancy of spatial demand essential to the proposed pairwise Resolution blocks commitment until independent ordering makes that space available.

At Bubble Formation, an independent third active AI Traffic Party enters exactly **1 km/h Bullet Time** for the Resolution Epoch.

During that epoch:

- the third worker remains physically and semantically independent;
- its Reality remains observed;
- relationships with either Bubble participant are deferred rather than independently negotiated;
- the Bubble owns the coupled Resolution decision horizon until its obligations are discharged; and
- unexpected hard-safety evidence remains authoritative.

The third worker never joins the pairwise commitment.

Bullet Time is an application of the existing Regulation Jurisdiction. The active Resolution Epoch supplies the current Situation reason for temporal coordination; Regulation supplies the bounded timing responsibility. Bullet Time does not create a third-worker Regulation subtype or a new Resolution participant.

Its exact **1 km/h** magnitude is purpose-bound policy and does not become the universal Regulation magnitude.

### Last-Leg Dissolution

The Bubble dissolves immediately when both original Passage Legs are terminal.

Normal two-participant completion is the special case:

```text
HANDED_BACK + HANDED_BACK
```

Participant loss may instead produce:

```text
VACATED + HANDED_BACK
VACATED + VACATED
```

The Resolution Epoch and Bubble Protection persist while at least one Passage Leg remains live.

Dissolution has no distance tail, arbitrary timeout, relationship-settlement delay, cooldown or surviving relationship memory.

Fresh Situation Assessment under the parent architecture then determines any responsibility involving former participants and the independent third worker.

---

## 6. Boundary to completed obstruction handling

A completed or stationary assembly may remain physically relevant without remaining an active Local Operation participant. Its presence does not automatically create a Bubble or any other responsibility.

When fresh positive evidence establishes Causal Obstruction by a non-active unclaimed blocker, the applicable concrete Resolution Jurisdiction is the parent Runtime architecture's **Obstruction Relocation**, not Cooperative Passage.

Spatial Negotiation does not create a separate completed-worker, terminal-egress or generic spatial-waiting lifecycle.

---

## 7. Spatial invariants and non-goals

Spatial Negotiation does not:

- create a universal distance literal for Passage commitment;
- create a numeric collision-probability engine;
- restore dense future-route reconstruction or route-history authority;
- promote transient `TURNING` vectors into Passage authority;
- make Regulation a mandatory Passage precursor;
- permit Regulation to own or guarantee its successor;
- plan immutable Passage geometry during Regulation;
- optimise globally when multiple Regulation allocations are adequately viable;
- vary the exact 1 km/h Intent-Revelation Creep or Bullet-Time policies where those policies apply;
- create persistent Encounter or pair history;
- establish a three-worker or concurrent pairwise Resolution Commitment;
- convert an independent third worker into a Bubble participant;
- make completed-worker tidying a Spatial Negotiation responsibility;
- expand into same-agronomy fleet coordination; or
- support more than three simultaneously active AI worker assemblies within one Local Operation.

Current implementation placement belongs outside this Architecture. Validation evidence and the investigations that shaped these conclusions belong to their authorised engineering-history, testing and scenario surfaces.