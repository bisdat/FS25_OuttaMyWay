# Spatial Negotiation Operating Model — v0.3.0.0 Candidate

> **Authority:** Canonical-candidate architecture knowledge. Becomes authoritative only if the repository owner explicitly canonicalises the exact v0.3.0.0 candidate fingerprint.
>
> **Baseline:** owner-declared v0.2.0.0 canonical; Git `d1a1f3fd5276a92088701c7a1256b90b35ad8153`; SHA-256 `e0263f562749215d44906f71b5edf65bda4c207283ac4407556f524004326c12`; 264 files.
>
> **Runtime boundary:** documentation/architecture only. Runtime behaviour remains the v0.2.0.0 implementation, behaviourally equivalent to v0.1.15.0. Bubble, time-aware Regulation and spatial-zone mechanics described here are not implemented.

## 1. Scope

OuttaMyWay enables cooperative field working by at most **three simultaneously active GIANTS AI worker assemblies per Operation**, with the supported validation target being **different agronomic roles**. GIANTS retains job ownership and native navigation. Player-controlled vehicles do not count toward the three-AI envelope.

OuttaMyWay negotiates temporary competition for space. It does not become a route planner, agronomic scheduler or same-agronomy fleet coordinator. Least intervention is preferred. Completed assemblies remain physically relevant and may require bounded Terminal Courtesy/egress. Player intervention remains a legitimate final outcome when no supported autonomous resolution remains.

## 2. Governing constraints

1. **GIANTS owns navigation and jobs.** OuttaMyWay may constrain progression or perform bounded cooperative manoeuvres, but must not prescribe productive routing.
2. **Partial observability is permanent.** Future GIANTS intent is not generally known while a worker is `TURNING`.
3. **Physical non-contact is mandatory.** Nominal clearance is a quality target; represented non-contact is the hard safety condition.
4. **Field space is non-uniform.** Corners and headlands reduce manoeuvre options; open field is comparatively cheap spatial capacity.
5. **Time consumes options.** Waiting for certainty is not free if native progression is rapidly consuming Resolution Space.
6. **Actuation is limited.** The architecture must work with the actual controls available: native progression, Regulation/Hold, supported configuration, bounded Passage displacement/recovery and terminal movement.
7. **Performance is a hard engineering constraint.** Do not require continuous field painting, dense future-route simulation, Successor Rooks or sophisticated articulated swept-volume prediction.
8. **Existing obligations remain real until discharged.** Physical displacement, configuration and coupled recovery debt cannot be forgotten because initiating geometry changes.
9. **The supported concurrency limit is three AI workers.** Concurrent coupled resolutions and arbitrary fleet coordination do not drive the design.

## 3. Assumptions and evidence hierarchy

### A8 — Productive Forward-Line Certainty

While GIANTS AI is positively `isWorking`, its immediate productive continuation is treated as **forward and straight along the current productive axis**. The assumption is intentionally local: it does not predict the worker through the end of its current productive run or through a later headland turn.

A worker's **productive-certainty horizon** is the remaining forward interval over which that current productive continuation can remain authoritative before Field World geometry requires a transition. Fresh Reality always overrides the assumption earlier if GIANTS changes state.

### TURNING uncertainty boundary

`TURNING` is primarily an intent-revelation state. Transient turning vectors may support spatial concern or Regulation, but do not by themselves establish Cooperative Passage. Once the worker returns to `isWorking`, A8 certainty is reacquired from the new Reality. Passage foreseeability is not remembered across this productive-certainty boundary.

### Evidence precedence

Fresh positive Reality outranks historical inference. Sparse demonstrated agronomic progression may adjust confidence if already cheaply available, but the retired Rook/Productive-History machinery is not restored and no reconstructed future route gains governing authority.

## 4. Three-State Responsibility Model

Spatial Negotiation has three high-level responsibilities:

```text
GIANTS AI
   ↕
Regulation
   ↓
Resolution Commitment
   ↓
GIANTS AI
```

The diagram is explanatory, not a mandatory route through a state machine. Fresh Situation Assessment governs each responsibility transition. Direct admission from GIANTS AI to Resolution Commitment is valid when current Reality already supplies the required evidence.

The responsibilities differ by the authority they hold:

- **GIANTS AI** is the default and attractor. OuttaMyWay has no active traffic responsibility merely because workers share an Operation.
- **Regulation** has weak persistence. It is provisional temporal adjustment and survives only while its explicit current purpose remains justified.
- **Resolution Commitment** has strong persistence. It survives changing execution evidence while legitimate obligations created or accepted by intervention remain open.

Responsibility stability comes from continuing evidence or obligation, not elapsed-time stickiness. No minimum duration, cooldown, remembered pair relationship or recent-subject rule is architectural authority. Rapid movement from GIANTS AI to Regulation, back to GIANTS AI and then independently to Regulation again is legitimate when each transition is supported by fresh Reality.

## 5. Continuous Situation Assessment and episodic transition

Situation Assessment is continuous. Fresh Reality continually establishes:

- current worker and Operation relevance;
- productive certainty and spatial scarcity;
- current physical state;
- whether a Regulation purpose remains valid;
- whether committed obligations remain supportable or have been discharged; and
- whether authority evidence or hard-safety conditions have changed.

Responsibility transition is episodic. A strategic responsibility decision occurs when OuttaMyWay acquires or relinquishes Regulation, replaces one Regulation purpose with another, admits or releases Resolution Commitment, or is superseded or escalates. Continuous assessment does not continuously re-decide an existing Resolution Commitment.

### GIANTS AI to and from Regulation

Regulation may be admitted when current Reality supports bounded temporal adjustment to preserve a relevant time/space opportunity. Supported purposes include allowing native intent to reveal, preserving Resolution Margin, allowing occupied constrained space to reveal or vacate, protecting prospective Passage theatre, and managing an independent third worker where applicable. Spatial scarcity is evidence, not an automatic slowdown trigger.

Regulation ends when its temporal purpose is discharged, invalidated or replaced by a fresh responsibility decision. It has no cooldown or residual claim. Intent revelation is a common discharge condition, not the only possible purpose.

One Regulation purpose must not silently mutate into another. The old Regulation ends, fresh Situation Assessment occurs, and a newly justified Regulation is admitted independently. This can happen effectively immediately and need not create an artificial native-speed pulse.

### Admission of Resolution Commitment

Regulation does not mutate into Resolution Commitment. At Regulation's decision point, provisional authority is relinquished; fresh Situation Assessment must then independently admit Resolution Commitment. For Cooperative Passage, fresh Passage and capture evidence must still satisfy the commitment conditions below.

Regulation is not a mandatory precursor. Fresh Reality may justify direct admission from GIANTS AI to Resolution Commitment.

### Release of Resolution Commitment

Resolution Commitment is not downgraded to Regulation merely because observations or execution geometry change. It completes with adapted bounded execution, continues, fails, is superseded, loses its governing basis, or escalates. Only after it legitimately ends may fresh Situation Assessment admit Regulation again.

When all required obligations are discharged and temporary responsibility is relinquished, assessment returns immediately to GIANTS AI. For Cooperative Passage this is Last-Handoff Dissolution; physical crossing alone is not completion.

## 6. GIANTS AI responsibility

GIANTS AI is normal operation, needs no special justification, and retains ownership of AI jobs, productive routing/navigation, native turning, productive work and ordinary worker continuation.

Every OuttaMyWay intervention relinquishes to fresh GIANTS AI assessment as soon as its responsibility ends, even if native responsibility lasts only briefly before new evidence supports another intervention.

## 7. Regulation responsibility

Regulation is **bounded, reversible temporal adjustment**. It changes timing, not productive routes. Its purpose is to preserve useful time/space, Resolution Margin, intent-revelation opportunity or future resolution theatre while workers remain independent.

Regulation does not own the eventual resolution or create a persistent Resolution Commitment. It must have an explicit current temporal purpose and carries no authority after that purpose ends. Reality may reveal enough information for Regulation to be extremely brief.

Regulation is admissible when developing spatial competition is relevant, uncertainty or preserved theatre still has material value, and continued native progression is consuming the opportunity to wait safely for better evidence or execution space.

One defensible party is regulated while useful native movement by another continues. The regulated party is not a permanent loser. Prefer an allocation that preserves more Resolution Space and useful revelation time; when several choices are adequately viable, use a deterministic tie-break rather than expensive optimisation.

Intent-Revelation Creep and third-worker Bullet Time retain the exact **1 km/h** architectural policy where applicable. This literal is fixed policy for those responsibilities, not a general tuning parameter.

## 8. Persistence by responsibility

State may persist only because a real architectural responsibility survives the current observation. Legitimate persistent state includes Operation identity, Job Episode identity, Physical Assembly identity and explicitly stable cached capability/representation knowledge, current Regulation allocation for its bounded temporal lifetime, Resolution Commitment, Bubble membership while Cooperative Passage commitment exists, and restoration/recovery/handback debt created by intervention.

Transient `TURNING` geometry, stale prospective Passage or guide geometry, historical pair relationship, a prior Regulation subject and Passage foreseeability beyond its productive-certainty boundary gain no persistent authority merely because they were once observed. This rule does not require a generic persistent knowledge object.

## 9. Spatial constraint overlay

The Field World supplies environmental evidence about local option-space scarcity.

- **Category 1 — corner:** very limited manoeuvre option space.
- **Category 2 — headland/boundary:** materially constrained, but less severe than a corner.
- **Open field:** comparatively generous Resolution Space.

Entering a zone does not itself trigger Regulation.

### One worker inside, one outside

Constrained-space occupancy creates an **evacuation preference**. If one worker occupies a constrained zone and a relevant worker remains in less-constrained space, preserve the occupant's native opportunity to reveal intent and vacate; regulate the outside worker where necessary. Do not immobilise the party that must move to free scarce space when another party can cheaply wait outside it.

### Neither worker inside, both approaching

Choose the provisional allocation that preserves more Resolution Margin and intent-revelation time. Do not reduce this to in-field position, agronomy, leader/follower identity or nearest-to-corner priority.

### Both workers already inside Category 1

This is a degraded-entry condition the normal architecture should try to prevent. If one worker is positively creating space, preserve that movement and regulate the other. If no clear safe space-creating action exists, fail safe and allow player escalation rather than inventing heroic choreography.

Spatial precedence is temporary and evidence-based.

## 10. Cooperative Passage foreseeability

Cooperative Passage is a Resolution Commitment, distinct from Regulation. Many Regulation episodes never require coupling, and many straightforward head-on Passages require no prior Regulation.

Passage may be identified as **foreseeable** at large separation when all of the following are positively supported:

1. both workers are A8-valid (`isWorking`);
2. their productive directions are substantially opposed;
3. their represented productive corridors genuinely compete rather than merely being adjacent; and
4. the prospective encounter occurs before either worker's productive-certainty horizon expires.

If one worker must reach a headland or transition first, current A8 evidence does not predict Passage through that future turn. When `TURNING` begins, uncertainty reasoning and Regulation are appropriate only if a current temporal purpose exists, such as Resolution Margin being consumed.

Foreseeability is an assessment conclusion, not an obligation. It disappears when fresh Reality invalidates its evidence and is not remembered across a productive-certainty boundary.

### Tactical Regulation for foreseeable Passage

Regulation may independently shape a foreseeable Passage's timing when the natural encounter would occur in poor execution theatre. Suitable theatre must support the **complete downstream Passage lifecycle**, including post-crossing Alignment Runout, Axis Settlement/Return where required, restoration and GIANTS handback.

For an opposed A8 pair, changing one worker's progression changes the prospective encounter position. Regulation may move it into a viable encounter interval where both participants retain sufficient downstream space. Stop shaping once Passage is sufficiently viable; least intervention wins.

If shaping moves the encounter beyond either productive-certainty horizon, the forecast legitimately disappears and fresh Situation Assessment takes over. Regulation is never obliged to preserve Passage.

## 11. Passage reserve and commitment

The existing nine-phase Passage architecture remains a strong mechanical donor. Retain the empirical Entry-space construction unless Reality disproves it. Current implementation approximately reserves represented forward physical extents, `2 x Development` longitudinal space, and the existing coarse **3 m Passage Entry Control Allowance**.

This is a control-acquisition/spatial reserve, not a GIANTS braking model. Do not add longitudinal Transit prediction or sophisticated articulation modelling. Existing represented geometry plus the approximately 1 m nominal Passage-clearance policy remains sufficient until field Reality demonstrates otherwise. If longer assemblies later need more clearance, adjust clearance policy before introducing a dynamics model.

For foreseeable Passage, distinguish the **required Passage reserve** that must remain after capture from the **disposable native approach margin** above it. Current closing speed determines how rapidly disposable margin is consumed. Commitment becomes due before independent approach consumes the space/time required to acquire and settle both workers while retaining the Passage reserve.

Configuration **duration** is not part of pre-commit lead time because closing progression is controlled after capture. Realised Transit **geometry** may affect Development and downstream Passage geometry after capture.

The historical 80 m locality literal is not an architectural commitment rule. It remains retained implementation baggage pending the later implementation tranche and must not be replaced by another universal distance literal.

## 12. Resolution Commitment

Resolution Commitment begins when OuttaMyWay accepts a durable obligation to complete a resolution. Its generic lifecycle is obligation-led:

```text
admission
→ obligations created
→ bounded execution + fresh observation
→ obligations progressively discharged
→ responsibility relinquished
```

It persists while legitimate obligations remain open, owns obligations created by intervention, and may adapt execution to fresh Reality. It does not preserve a forecast or geometry merely because that evidence justified admission.

Legitimate ends are completion (obligations positively discharged), failure (no longer safely or legitimately dischargeable within supported authority), supersession (higher-authority responsibility takes ownership), governing-basis cessation (for example Operation or Job Episode termination), or escalation to the player when autonomous supported resolution is exhausted.

Stale original geometry, an invalid original guide or the existence of a preferable manoeuvre is not by itself failure or supersession. Legitimate player takeover or authoritative source-intent replacement may supersede commitment; escalation is distinct from player supersession. The architecture does not require a generic controller-phase or terminal enum to express this lifecycle.

### Commitment remembers obligations, not predictions

Admission evidence may establish commitment, but its predictions do not automatically gain persistent authority. For Cooperative Passage, the Passage obligation is sticky while realised execution geometry remains adaptive. Stale early guides have no independent authority; execution reacts to fresh Reality until local physical-leg commitment makes a particular action physically authoritative. Hard safety remains authoritative throughout.

### Intervention debt

A Resolution Commitment owns restoration, recovery or handback debt only when OuttaMyWay's intervention created that debt. This may include configuration restoration, controlled displacement recovery, Axis Return where applicable, and authority handback. It does not require OuttaMyWay to reconstruct every pre-existing imperfection or articulation state in Reality.

## 13. Cooperative Passage commitment and Bubble

Resolution Commitment is broader than Bubble:

```text
Resolution Commitment
    |
    +-- Cooperative Passage
    |       |
    |       +-- Bubble
    |
    +-- Terminal Resolution
            |
            +-- no Bubble required
```

A **Bubble** is specifically the coupled pairwise context created by a Cooperative Passage Resolution Commitment. It forms only at committed Passage, not at initial foreseeability or because Regulation exists.

At commitment, fresh Passage evidence must still support Passage, the required Passage reserve must remain viable, continued independent approach must be approaching the latest safe capture point, and the pair must accept jointly dependent persistent Passage obligations.

The Resolution Epoch begins at Bubble Formation.

Bubble owns only what the committed coupled resolution requires: Passage participants, coupled obligations, Resolution Epoch and third-party protection scope, and Last-Handoff Dissolution. It is not permanent pair history, future-route ownership, permanent right-of-way or a relationship surviving dissolution.

## 14. Committed Passage execution

The full Cooperative Passage obligation persists through completion unless fresh physical evidence makes safe continuation unsupported. The obligation is sticky; the geometry is not.

Persist through the Bubble: coupled membership and joint Passage responsibility, required Bubble Protection, configuration/restoration debt actually created by Passage, and safe completion through final-participant handback.

Remain Reality-sensitive: realised Transit width and natural separation, actual clearance deficit, Development burden, execution origin, exact guide geometry and lateral allocation until the relevant physical leg begins, and recovery debt derived from the manoeuvre actually executed.

The existing Phase-5 Transit/settlement boundary is the natural donor for reality-verified execution geometry. A stale preliminary guide must not survive contrary realised geometry. Once a physical leg begins, its local execution choice should normally remain stable to avoid unsafe oscillation.

Passage recovery remains part of the coupled obligation. Physical crossing alone is not settlement or completion.

## 15. Third-worker serialization and Bullet Time

Before Cooperative Passage commitment all three workers remain independent. If an independent third worker is consuming foreseeable Passage theatre, Regulation may manage it before commitment. If it already materially occupies spatial demand essential to a proposed coupled resolution, commitment is not admissible; independent ordering must first make that space available.

At Bubble Formation, any independent third active AI Traffic Party immediately enters the fixed **1 km/h Bullet Time** defined by D-0202. No external worker means no actuation; an independent external worker means exactly 1 km/h for the Resolution Epoch.

During the Resolution Epoch, the third worker remains physically and semantically independent, its Reality continues to be observed, developing relationships with either Bubble participant are deferred rather than independently negotiated, and the Bubble owns the decision horizon until its committed resolution is discharged. Unexpected hard-safety evidence remains authoritative.

Bullet Time does not solve the third worker. It prevents concurrent relationship negotiation from forcing another resolution while the Bubble completes.

## 16. Last-Handoff Dissolution and GIANTS handback

The Bubble dissolves immediately after the **last participant is handed back to GIANTS AI**. There is no distance tail, arbitrary timeout, relationship-settlement delay, cooldown or surviving Bubble memory.

Fresh GIANTS AI assessment then determines any subsequent responsibility involving former Bubble participants and the third worker. Native responsibility may be transient.

## 17. Terminal Resolution

Existing bounded Terminal Courtesy/egress is a separate possible Resolution Commitment. Completed or stationary assemblies have real Occupancy Demand but do not automatically create a Bubble because they do not acquire Cooperative Passage's coupled pairwise obligations.

Mechanical or physical completion conditions such as folding, unfolding, settling, restoration or movement completion belong to their resolution/control responsibilities. A commitment simply remains open until its required obligations are discharged. Intent revelation instead belongs to Regulation when temporary adjustment is required to expose useful native intent. Neither concern requires a generic architectural waiting lifecycle.

Player intervention remains the final supported escalation when no safe bounded terminal or traffic resolution exists.

## 18. Evidence that shaped this model

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

## 19. Explicit non-goals and retained boundaries

Do not, without new evidence:

- replace 80 m with another universal distance literal;
- create a numeric collision-probability engine;
- restore continuous Productive History, Successor Rooks or dense geometry sampling;
- promote transient `TURNING` vectors into Passage authority;
- make Regulation a mandatory Passage precursor;
- plan immutable Passage geometry during Regulation;
- search for a globally optimal Regulation winner when multiple viable allocations exist;
- vary the 1 km/h Intent-Revelation Creep/Bullet-Time literal or optimise its cadence;
- establish Traffic Policeman, Operational Picture Knowledge, Candidate Action Space or Mandatory Constraints as required named subsystems;
- make Encounter a persistent relationship;
- restore King, King Reserve or Refuge concepts;
- suppress evidence-supported responsibility changes with arbitrary anti-oscillation stickiness;
- design concurrent coupled resolutions for the three-worker supported envelope; or
- expand into same-agronomy fleet coordination or more than three simultaneous AI workers.

Absence of a named subsystem does not remove underlying safety or admissibility constraints.

## 20. Implementation gate

No runtime implementation is authorised by this candidate. After owner canonicalisation and the proposed workflow discussion, the next engineering activity should map this operating model against the existing v0.2.0.0 code responsibilities and select the smallest falsifiable tranche.

The implementation should reuse validated nine-phase Passage mechanics where they satisfy this model, especially the Entry-space donor and post-crossing recovery responsibilities, while replacing literal-driven front-end admission/timing only where the new model requires it.
