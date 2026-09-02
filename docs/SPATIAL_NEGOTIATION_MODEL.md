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
8. **Existing obligations remain real until discharged.** Physical displacement, configuration and coupled recovery debt cannot be forgotten because the initiating relationship changes.
9. **The supported concurrency limit is three AI workers.** Bubble-versus-Bubble and arbitrary fleet coordination do not drive the design.

## 3. Assumptions and evidence hierarchy

### A8 — Productive Forward-Line Certainty

While GIANTS AI is positively `isWorking`, its immediate productive continuation is treated as **forward and straight along the current productive axis**. The assumption is intentionally local: it does not predict the worker through the end of its current productive run or through a later headland turn.

A worker's **productive-certainty horizon** is the remaining forward interval over which that current productive continuation can remain authoritative before Field World geometry requires a transition. Fresh Reality always overrides the assumption earlier if GIANTS changes state.

### TURNING uncertainty boundary

`TURNING` is primarily an intent-revelation state. Transient turning vectors may support spatial concern or Regulation, but do not by themselves establish Cooperative Passage. Once the worker returns to `isWorking`, A8 certainty is reacquired from the new Reality.

### Evidence precedence

Fresh positive Reality outranks historical inference. Sparse demonstrated agronomic progression may adjust confidence if already cheaply available, but the retired Rook/Productive-History machinery is not restored and no reconstructed future route gains governing authority.

## 4. Region A — Native GIANTS operation

Region A is the normal and preferred state. Native GIANTS operation continues whenever adequate cooperative futures remain.

A is an **attractor, not a cooldown**. Every intervention should relinquish to A as soon as its purpose ends, even if A lasts only briefly before fresh Reality independently justifies another intervention.

Healthy sequences include `B -> A -> B`, `B -> A -> Passage`, and `Bubble -> A -> new negotiation`.

## 5. Region B — Bounded Temporal Regulation

Region B is a **bounded, reversible temporal allocation**. Its purpose is to preserve Resolution Margin and useful intent-revelation time while the parties remain independent.

B is admissible when:

- a developing spatial competition is relevant;
- uncertainty still has material value; and
- continued native progression is consuming the opportunity to wait safely for better evidence.

B controls **time**, not routes. One defensible party is regulated while useful native movement by another party continues. The regulated party is not a permanent loser and B never owns the eventual answer.

### Regulation target selection

The system does not need a globally optimal yielder. Prefer a temporary allocation that preserves more Resolution Space and useful revelation time. If several choices are adequately viable, use a deterministic tie-break rather than expensive optimisation.

Fresh evidence may switch which party should be regulated. Architecturally this is `B1 -> A -> B2`; implementation need not create an artificial native-speed pulse if material new Reality independently justifies the new B in the same assessment cycle.

### B authority lifetime

One provisional temporal allocation has a **bounded uninterrupted authority lifetime**. This is not a solution timeout and expiry does not prove safety, failure or Passage. Expiry ends that actuation and returns authority to A for fresh native sampling. Persistent uncertainty alone cannot justify indefinite Regulation.

Repeated `B -> A -> B` is preferable to a soft lock. Repeated B does not force Passage merely to escape oscillation.

## 6. Spatial constraint overlay

The Field World supplies environmental evidence about local option-space scarcity.

- **Category 1 — corner:** very limited manoeuvre option space.
- **Category 2 — headland/boundary:** materially constrained, but less severe than a corner.
- **Open field:** comparatively generous Resolution Space.

Entering a zone does **not** itself trigger Regulation.

### One worker inside, one outside

Constrained-space occupancy creates an **evacuation preference**. If worker A occupies a constrained zone and relevant worker B remains in less-constrained space, preserve A's native opportunity to reveal intent and vacate; regulate B where necessary. Do not immobilise the party that must move to free scarce space when another party can cheaply wait outside it.

### Neither worker inside, both approaching

Choose the provisional allocation that preserves more Resolution Margin and intent-revelation time. Do not reduce this to "more in-field", agronomy, leader/follower identity or nearest-to-corner priority.

### Both workers already inside Category 1

This is a degraded-entry condition the normal architecture should try to prevent. If one worker is positively creating space, preserve that movement and regulate the other. If no clear safe space-creating action exists, fail safe and allow player escalation rather than inventing heroic choreography.

Spatial precedence is temporary and evidence-based.

## 7. Phase 1 Cooperative Passage identification

Passage remains a separate lifecycle from Region B. Many Regulation episodes never require coupling; many straightforward head-on Passages require no prior B.

Phase 1 may identify **foreseeable Passage** at large separation when all of the following are positively supported:

1. both workers are A8-valid (`isWorking`);
2. their productive directions are substantially opposed;
3. their represented productive corridors genuinely compete rather than merely being adjacent; and
4. the prospective encounter occurs before either worker's productive-certainty horizon expires.

If one worker must reach a headland/transition first, current A8 evidence does not predict Passage through that future turn. When TURNING begins, uncertainty reasoning and Region B become the appropriate tools if Resolution Margin is being consumed.

Phase 1 is an assessment conclusion, not an obligation. It may disappear immediately when fresh Reality invalidates any of its evidence.

## 8. Tactical Region B for a foreseeable Passage

A foreseeable Passage may be identified long before commitment. Region B may independently shape its timing when the natural encounter would occur in a poor execution theatre.

The target is not a prettier crossing point. A suitable Passage theatre must support the **complete downstream Passage lifecycle**, including post-crossing Alignment Runout, Axis Settlement/Return where required, restoration and GIANTS handback.

For an opposed A8 pair, changing one worker's progression changes the prospective encounter position. Tactical B may therefore move the encounter into a **viable encounter interval** where both participants retain enough downstream space. Stop shaping once the Passage is sufficiently viable; least intervention wins.

If tactical B moves the encounter beyond either productive-certainty horizon, the current Passage forecast legitimately disappears. The worker reaches TURNING uncertainty and fresh Situation Assessment takes over. B is never obliged to preserve Passage.

## 9. Passage reserve and time-aware Bubble commitment

The existing nine-phase Passage architecture remains a strong donor. In particular, retain the empirical Entry-space construction unless Reality disproves it. Current implementation approximately reserves:

- represented forward physical extents;
- `2 x Development` longitudinal space; and
- the existing coarse **3 m Passage Entry Control Allowance**.

This is a control-acquisition/spatial reserve, not a GIANTS braking model.

Do not add longitudinal Transit prediction or sophisticated articulation modelling. Existing represented geometry plus the approximately 1 m nominal Passage-clearance policy remains sufficient until field Reality demonstrates otherwise. If longer assemblies later need more clearance, the clearance policy may be adjusted before introducing a dynamics model.

### Capture margin

For a foreseeable Passage, distinguish:

- the **required Passage reserve** that must remain after capture so the known Passage mechanism can execute; and
- the **disposable native approach margin** above that reserve.

Time replaces the old universal-distance intuition. Current closing speed determines how rapidly the disposable margin is being consumed. Bubble commitment becomes due before continued native approach would consume the space/time needed to acquire and settle both workers while leaving the Passage reserve intact.

Configuration **duration** is not part of pre-commit lead time because closing progression is controlled after capture. Realised Transit **geometry** may affect Development and downstream Passage geometry after capture.

The historical 80 m locality literal is not an architectural commitment rule. It remains retained implementation baggage pending the later implementation tranche.

## 10. Bubble Formation and Resolution Epoch

A Bubble forms only at **committed Cooperative Passage**, not at initial foreseeability and not because Region B exists.

At commitment:

- fresh Phase-1 evidence still supports Passage;
- the required Passage reserve remains viable;
- continued independent approach is approaching the latest safe capture point; and
- the pair accepts jointly dependent persistent Passage obligations.

The Resolution Epoch begins at Bubble Formation.

## 11. Committed Passage: persistent obligation, adaptive geometry

Once the Bubble commits, the **full Cooperative Passage obligation persists through completion** unless fresh physical evidence makes safe continuation unsupported.

The obligation is sticky; the geometry is not.

Persist through the Bubble:

- coupled membership and joint Passage responsibility;
- required Bubble Protection;
- configuration/restoration debt actually created by Passage;
- safe completion through final participant handback.

Remain Reality-sensitive:

- realised Transit width and natural separation;
- actual clearance deficit;
- Development burden;
- execution origin;
- exact guide geometry and lateral allocation until the relevant physical leg begins;
- recovery debt derived from the manoeuvre actually executed.

The existing Phase-5 Transit/settlement boundary is the natural donor for reality-verified execution geometry. A stale preliminary guide must not survive contrary realised geometry. Once a physical leg begins, its local execution choice should normally remain stable to avoid oscillation.

Passage recovery remains part of the coupled obligation. Physical crossing alone is not settlement.

## 12. Third-worker composition and Bullet Time

Before Bubble Formation all three workers remain independent. If a third worker L is consuming the foreseeable J/K Passage theatre, ordinary Region B may regulate L before commitment. If L already materially occupies spatial demand essential to J/K's proposed coupled resolution, J/K Bubble Formation is not yet admissible; independent ordering must first make that space available.

At Bubble Formation, any independent third active AI Traffic Party immediately enters the fixed **1 km/h Bullet Time** defined by D-0202.

The speed literal is fixed. What adapts is applicability: no external worker means no actuation; an independent external worker means 1 km/h for the Resolution Epoch.

During the Resolution Epoch:

- the third worker remains physically and semantically independent;
- its Reality continues to be observed;
- developing J/L or K/L relationships are **deferred**, not independently negotiated;
- the active Bubble owns the decision horizon until its committed resolution is discharged.

Bullet Time does not solve the third worker. It prevents the third worker from forcing concurrent resolution while the Bubble completes.

Unexpected hard safety evidence still outranks persistence; fail safe rather than permit physical contact.

## 13. Bubble dissolution

The Bubble dissolves immediately after the **last participant is handed back to GIANTS AI**. There is no distance tail, arbitrary timeout, relationship-settlement delay or cooldown.

Fresh Region A assessment then determines any subsequent B or Passage relationship involving the former Bubble members and the third worker. A may be transient.

## 14. Terminal occupancy

Existing bounded Terminal Courtesy/egress remains a separate responsibility. Completed/stationary assemblies have real Occupancy Demand but do not automatically create a Bubble because they do not acquire the jointly dependent persistent Passage obligations described above.

Player intervention remains the final supported escalation when no safe bounded terminal or traffic resolution exists.

## 15. Evidence that shaped this model

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

## 16. Explicit non-goals / retained boundaries

Do not, without new evidence:

- replace 80 m with another universal distance literal;
- create a numeric collision-probability engine;
- restore continuous Productive History, Successor Rooks or dense geometry sampling;
- promote transient TURNING vectors into Passage authority;
- make Region B a mandatory Passage precursor;
- plan immutable Passage geometry in Region B;
- search for a globally optimal Regulation winner when multiple viable allocations exist;
- vary the 1 km/h Bullet-Time literal or optimise its cadence;
- design Bubble-versus-Bubble behaviour for the three-worker supported envelope;
- expand into same-agronomy fleet coordination or more than three simultaneous AI workers.

## 17. Implementation gate

No runtime implementation is authorised by this candidate. After owner canonicalisation and the proposed workflow discussion, the next engineering activity should map this operating model against the existing v0.2.0.0 code responsibilities and select the smallest falsifiable tranche.

The implementation should reuse validated nine-phase Passage mechanics where they satisfy this model, especially the Entry-space donor and post-crossing recovery responsibilities, while replacing literal-driven front-end admission/timing only where the new model requires it.
