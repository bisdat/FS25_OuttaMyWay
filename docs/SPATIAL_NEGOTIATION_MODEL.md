# Spatial Negotiation Operating Model

> **Architectural role:** Spatial Negotiation specialisation beneath the [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md).
>
> **Release authority:** The repository owner has explicitly declared v0.3.0.0 canonical. Accepted documentation changes after that release do not declare another canonical release.
>
> **Runtime boundary:** Architecture only. This document may describe intended behaviour not yet implemented and does not change runtime behaviour or release identity.

Spatial Negotiation operates within the parent architecture's Local Operation and GIANTS AI / Regulation / Resolution Commitment model. This document defines the spatial evidence and policies that justify and execute those responsibilities during active cooperative field work. Generic lifecycle, responsibility, persistence, Bounded Authority and Control semantics belong to the parent and are not redefined here.

## 1. Scope

Spatial Negotiation manages temporary competition for space among active supported workers within one Local Operation. The supported envelope remains at most **three simultaneously active GIANTS AI worker assemblies**, with validation targeted at **different agronomic roles**. Player-controlled vehicles do not count toward that limit.

GIANTS retains AI jobs, productive routing/navigation, native turning and productive work. Spatial Negotiation does not become a route planner, agronomic scheduler or same-agronomy fleet coordinator. Least intervention is preferred; player intervention remains a legitimate final outcome when no supported autonomous resolution remains.

## 2. Spatial governing constraints

1. **Partial observability is permanent.** Future GIANTS intent is not generally known while a worker is `TURNING`.
2. **Physical non-contact is mandatory.** Nominal clearance is a quality target; represented non-contact is the hard safety condition.
3. **Field space is non-uniform.** Corners and headlands reduce manoeuvre options; open field is comparatively cheap spatial capacity.
4. **Time consumes options.** Waiting for certainty is not free when native progression consumes Resolution Space.
5. **Actuation is limited.** Spatial policy must use available native progression, Regulation/Hold, supported configuration, bounded Passage displacement/recovery and terminal movement.
6. **Performance is a hard constraint.** Policy must not require continuous field painting, dense future-route simulation, Successor Rooks or sophisticated articulated swept-volume prediction.
7. **Accepted obligations remain real until discharged.** Changing observations or execution geometry do not erase configuration, displacement or coupled recovery debt created by intervention.

Fresh Situation Assessment may justify spatial Regulation, Cooperative Passage Resolution Commitment or return to GIANTS AI under the parent transition contract. Spatial scarcity alone is evidence, not an automatic slowdown trigger.

## 3. Spatial evidence hierarchy

### A8 — Productive Forward-Line Certainty

While GIANTS AI is positively `isWorking`, its immediate productive continuation is treated as **forward and straight along the current productive axis**. This assumption is local: it does not predict through the end of the productive run or a later headland turn.

The **productive-certainty horizon** is the remaining forward interval over which that continuation can remain authoritative before Field World geometry requires transition. Fresh Reality overrides A8 earlier when GIANTS changes state.

### TURNING uncertainty boundary

`TURNING` primarily reveals intent. Transient turning vectors may support spatial concern or a current Regulation purpose, but do not independently establish Cooperative Passage. Once a worker returns to `isWorking`, A8 certainty is reacquired from fresh Reality. Passage foreseeability is not remembered across this boundary.

### Evidence precedence

Fresh positive Reality outranks historical inference. Sparse demonstrated agronomic progression may adjust confidence when already cheaply available, but Productive History/Rook machinery is not restored and no reconstructed future route gains governing authority.

## 4. Spatial purposes for Regulation

Within the parent's generic Regulation responsibility, spatially supported purposes include:

- allowing native intent to reveal;
- preserving Resolution Margin;
- allowing occupied constrained space to reveal or vacate;
- protecting prospective Passage theatre; and
- managing an independent third worker where applicable.

Spatial Regulation is admissible when developing spatial competition is relevant, uncertainty or preserved theatre still has material value, and continued native progression is consuming the opportunity to wait safely for better evidence or execution space.

Regulation changes timing, not productive routes. Prefer an allocation that preserves more Resolution Space and useful revelation time; if several choices are adequately viable, use a deterministic tie-break rather than expensive optimisation. The regulated party is not a permanent loser.

Intent-Revelation Creep and third-worker Bullet Time retain the exact **1 km/h** architectural policy where applicable. This is fixed policy for those responsibilities, not a general tuning parameter.

## 5. Spatial constraint overlay

The Field World supplies evidence about local option-space scarcity:

- **Category 1 — corner:** very limited manoeuvre option space.
- **Category 2 — headland/boundary:** materially constrained, but less severe than a corner.
- **Open field:** comparatively generous Resolution Space.

Entering a zone does not itself trigger Regulation.

### One worker inside, one outside

Constrained-space occupancy creates an **evacuation preference**. Preserve the occupant's native opportunity to reveal intent and vacate; regulate a relevant worker in less-constrained space where necessary. Do not immobilise the party that must move to free scarce space when another can cheaply wait outside it.

### Neither worker inside, both approaching

Choose the provisional allocation that preserves more Resolution Margin and intent-revelation time. Do not reduce this to in-field position, agronomy, leader/follower identity or nearest-to-corner priority.

### Both workers inside Category 1

This is a degraded-entry condition the normal architecture should try to prevent. Preserve a worker positively creating space and regulate the other. If no clearly safe space-creating action exists, fail safe and allow player escalation rather than inventing heroic choreography.

Spatial precedence is temporary and evidence-based.

## 6. Cooperative Passage foreseeability

Cooperative Passage is a pairwise Resolution Commitment. It is distinct from Regulation: many Regulation episodes never require coupling, and straightforward head-on Passages may require no prior Regulation.

Passage may be **foreseeable** at large separation only while current evidence positively supports all of these conditions:

1. both workers are A8-valid (`isWorking`);
2. their productive directions are substantially opposed;
3. their represented productive corridors genuinely compete rather than merely being adjacent; and
4. the prospective encounter occurs before either productive-certainty horizon expires.

If either worker must first reach a headland or transition, A8 does not predict Passage through that future turn. Foreseeability is an assessment conclusion, not an obligation, and disappears when fresh Reality invalidates its evidence.

### Tactical Regulation

Regulation may shape foreseeable Passage timing when the natural encounter would occur in poor execution theatre. Suitable theatre must support the **complete downstream Passage lifecycle**, including post-crossing Alignment Runout, Axis Settlement/Return where required, restoration and GIANTS handback.

Changing progression for an opposed A8 pair changes its prospective encounter position. Regulation may move that position into a viable interval where both participants retain sufficient downstream space. Stop shaping once Passage is sufficiently viable; least intervention wins.

If shaping moves the encounter beyond either productive-certainty horizon, the forecast legitimately disappears and fresh Situation Assessment takes over. Regulation is never obliged to preserve Passage.

## 7. Passage reserve and capture

The validated nine-phase Passage architecture remains the mechanical donor. Retain its empirical Entry-space construction unless Reality disproves it. Current implementation approximately reserves:

- represented forward physical extents;
- `2 x Development` longitudinal space; and
- the coarse **3 m Passage Entry Control Allowance**.

This is a control-acquisition/spatial reserve, not a GIANTS braking model. Do not add longitudinal Transit prediction or sophisticated articulation modelling. Existing represented geometry and the approximately **1 m nominal Passage-clearance policy** remain sufficient until field Reality demonstrates otherwise. If longer assemblies later demonstrate insufficient clearance, adjust the clearance policy before introducing a dynamics model.

For foreseeable Passage, distinguish the **required Passage reserve** remaining after capture from the **disposable native approach margin** above it. Current closing speed determines how rapidly disposable margin is consumed. Commitment becomes due before independent approach consumes the space/time needed to acquire and settle both workers while retaining the reserve.

Configuration **duration** is not part of pre-commit lead time because capture controls closing progression. Realised Transit **geometry** may affect Development and downstream Passage geometry after capture.

The historical 80 m locality literal is not a commitment rule and must not be replaced by another universal distance literal.

## 8. Cooperative Passage admission and Bubble

Under the parent's Pairwise Resolution Exclusivity rule, Cooperative Passage has exactly two active AI worker participants and at most one coupled Resolution Commitment may exist within a Local Operation.

A **Bubble** is the coupled pairwise context created specifically by Cooperative Passage Resolution Commitment. It forms only when fresh evidence still supports Passage, the required reserve remains viable, independent approach nears the latest safe capture point, and the pair accepts jointly dependent Passage obligations.

Bubble Formation begins the Resolution Epoch. Bubble owns only its participants, coupled obligations, Bubble Protection, Resolution Epoch/third-party protection scope and Last-Handoff Dissolution. It creates no permanent pair history, future-route ownership or right-of-way.

## 9. Committed Passage execution

The full Cooperative Passage obligation persists until legitimate completion or another generic commitment end defined by the parent. The obligation is sticky; execution geometry is adaptive.

Persist through the Bubble:

- coupled membership and joint Passage responsibility;
- required Bubble Protection;
- configuration/restoration debt actually created by Passage; and
- safe completion through final-participant handback.

Remain Reality-sensitive:

- realised Transit width and natural separation;
- actual clearance deficit;
- Development burden;
- execution origin;
- exact guide geometry and lateral allocation until the relevant physical leg begins; and
- recovery debt derived from the manoeuvre actually executed.

Stale early guides have no independent authority. The existing Phase-5 Transit/settlement boundary is the donor for reality-verified execution geometry. Once a physical leg begins, its locally authorised execution choice should normally remain stable to avoid unsafe oscillation. Hard safety remains authoritative.

Passage owns only intervention-created debt. It does not reconstruct pre-existing imperfections or articulation. Physical crossing alone is not completion; required recovery, restoration and handback remain coupled obligations.

## 10. Third-worker serialization

Before Passage commitment, all workers remain independent. Regulation may manage an independent third worker whose progression threatens prospective Passage theatre. Existing third-worker occupancy of spatial demand essential to the proposed pairwise resolution blocks commitment until independent ordering makes that space available.

At Bubble Formation, an independent third active AI Traffic Party immediately enters exactly **1 km/h Bullet Time** for the Resolution Epoch. During that epoch:

- the third worker remains physically and semantically independent;
- its Reality remains observed;
- relationships with either Bubble participant are deferred rather than independently negotiated;
- the Bubble owns the decision horizon until its obligations are discharged; and
- unexpected hard-safety evidence remains authoritative.

The third worker never joins the pairwise commitment. Bullet Time serializes it; it does not solve it or create a general claim that all Regulation is globally exclusive.

## 11. Last-Handoff Dissolution

The Bubble dissolves immediately after its **last participant is handed back to GIANTS AI**. It has no distance tail, arbitrary timeout, relationship-settlement delay, cooldown or surviving relationship memory.

Fresh Situation Assessment under the parent architecture then determines any responsibility involving former participants and the independent third worker.

## 12. Completed obstructions

A completed or stationary assembly may remain physically relevant without remaining an active Local Operation participant. It does not automatically create a Bubble or any other responsibility.

When fresh positive evidence establishes that such an assembly obstructs an active worker's supported productive continuity, the parent architecture's beneficiary/controlled-subject separation may justify a bounded Resolution Commitment. Existing Terminal Courtesy/egress mechanics remain a possible donor, but detailed naming and lifecycle reconciliation are out of scope here. Physical completion conditions such as compaction, movement, restoration and relinquishment belong to the authorised resolution and Control, not to a generic spatial waiting state.

## 13. Evidence that shaped this model

### TS004 repeatable two-worker laboratory

The new TS004 theatre (Deere 8RX + cultivator versus MT665 + manure spreader) exposed that current scenario success is fixture-fragile.

- Around 08:27:12 MT665 approached constrained spatial theatre while future intent remained unresolved.
- Around 08:27:23 MT665 reversed, positively demonstrating why TURN intent should be allowed to reveal.
- Around 08:27:31 both workers were productively moving at similar speed/headings toward the same future constrained headland/corner theatre.
- By roughly 08:27:49 insufficient useful Resolution Space remained to shape the collision cleanly.
- A manual ~30 s hold of Deere from about 12:54:28 allowed MT665 to reveal/clear and later produced an uneventful, zero-deficit-style safe Passage in clearer space.
- A manual ~30 s hold of MT665 from about 13:08:51 instead produced a normal adjacent-lane pass. This disproved the emerging assumption that there is necessarily one uniquely correct early yielder and increased confidence that **temporal separation itself** is often the high-value intervention.
- Later TS004 runs reproducibly showed a separate historic Passage fragility: transient TURN geometry could promote Passage where settled Reality became ordinary adjacent-lane traffic, while stale early guide geometry then forced unnecessary lateral displacement and difficult Axis recovery.

### TS016 spatial corroboration

TS016 visually showed Condor and Patriot both vectoring at high speed toward the same Category-1 corner. Reality happened to resolve benignly when Patriot turned away before intersection, but the case corroborates the central spatial point: shared approach to constrained space supplies useful early Situation evidence even when collision is not inevitable.

These observations support option-space preservation rather than collision prediction.

## 14. Spatial non-goals

Without new evidence, Spatial Negotiation does not:

- replace 80 m with another universal distance literal;
- create a numeric collision-probability engine;
- restore Productive History, Rook/Successor-Rook or dense geometry sampling;
- promote transient `TURNING` vectors into Passage authority;
- make Regulation a mandatory Passage precursor;
- plan immutable Passage geometry during Regulation;
- optimise globally when multiple Regulation allocations are viable;
- vary the exact 1 km/h Intent-Revelation Creep/Bullet-Time policy;
- create persistent Encounter or pair history;
- establish a three-worker or concurrent pairwise Resolution Commitment; or
- expand into same-agronomy fleet coordination or more than three active AI workers.

## 15. Implementation gate

This architecture does not authorise runtime implementation. Implementation should reuse validated nine-phase Passage mechanics where they satisfy the model, especially the Entry-space donor and post-crossing recovery responsibilities. Agent-side documentation validation is not field/runtime validation.
