# Cooperative Passage Specification

## Identity and authority

**Specification Jurisdiction:** Cooperative Passage  
**Jurisdiction ID:** `COOPERATIVE_PASSAGE`

**Parent Specification:** [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md)  
**Primary Architecture Authority:** [`architecture/SPATIAL_NEGOTIATION_MODEL.md`](../architecture/SPATIAL_NEGOTIATION_MODEL.md#5-specification-jurisdiction--cooperative-passage)

This Specification owns the implementation-facing contract for the purpose-specific **Cooperative Passage** Resolution: Passage Candidate requirements, Bubble Formation, participant-scoped Passage Legs, shared Passage obligations, Passage-specific third-party protection, Reality-verified execution, intervention-created recovery/restoration debt, and Last-Leg Dissolution.

It does **not** own raw Observation, generic Situation Assessment, the generic Candidate/Constraint/Decision machinery, Responsibility Transition, generic Resolution persistence, generic Bounded Authority, generic Control mechanics, productive routing, or future GIANTS intent.

The parent [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md) owns generic obligation persistence and terminal semantics. This Specification adds the concrete obligations and evidence rules that make one Passage Resolution meaningful.

> **Specialised Resolution Adds Obligations; It Does Not Fork Parent Persistence.**

## Boundary contract

### Admission inputs

A Cooperative Passage Candidate MUST be grounded in current Passage-specific evidence for exactly two active GIANTS AI worker participants in one Local Operation.

Before the Candidate may be selected and committed, the implementation MUST preserve the following distinctions:

- current productive/working geometry may conservatively establish an opposed-corridor Passage concern;
- a positive **Native A8 Clearance Exclusion** proves that Cooperative Passage is unnecessary for that current opposed A8 relationship and MUST prevent Passage Evaluation Readiness / Candidate evaluation;
- unavailable or unresolved Native A8 Clearance Exclusion evidence provides no independent veto and MUST NOT be promoted into positive conflict;
- **Passage Evaluation Readiness** authorises Candidate evaluation after an Established Opposed Corridor Conflict only when no current positive Native A8 Clearance Exclusion applies, and grants no Passage Candidate, commitment or actuation authority;
- complete-assembly Transit geometry MUST support prospective Passage arrangement planning for the declared Passage purpose;
- complete Physical Assembly membership is required for complete-assembly Passage geometry claims;
- directional asymmetry and offsets MUST be preserved where supported by evidence;
- generic positive physical-conflict evidence does not independently establish Passage clearance or contact; and
- Situation foreseeability, Candidate support, mandatory Constraint evaluation, Decision, Bubble Formation Readiness and Responsibility Transition remain distinct authorities/boundaries.

A compact representation MUST NOT be used to make a currently deployed productive corridor artificially narrow for Passage recognition. The purpose-specific **Maximum Productive A8 Envelope** used for Native A8 Clearance Exclusion is likewise not Transit geometry and does not authorise Passage movement.

> **Working Geometry Identifies Passage Concern; Native A8 Clearance May Exclude Passage; Transit Geometry Executes Passage.**

Working geometry identifies the conservative current Passage concern. Native A8 Clearance Exclusion may positively disprove Passage necessity for the same settled opposed A8 relationship. Transit geometry establishes whether a Passage arrangement can be planned and, once physically realised, executed. Cooperative Passage has no supported full-width/working-configuration execution mode.

### Passage Candidate product

A supported Passage Candidate MUST make the purpose-specific arrangement sufficiently explicit for downstream selection and commitment without depending on source helper topology.

As applicable, the semantic product includes:

- the exact two participant assemblies and their current Job Episode provenance;
- the purpose-specific geometry basis and its claim limits;
- the proposed Passage arrangement and participant-specific lateral allocation;
- the **Shared Crossing Core** with required Passage clearance and represented non-contact support;
- capture/control reserve and disposable native approach margin;
- any participant-specific **Lateral Excursion Development/Reacquisition** required by the selected arrangement;
- the sequential-return-space basis required to establish the **Mutual Return Region** used between first-participant handback and second-participant return;
- entry/capture boundary evidence;
- the required Transit configuration plan for both participants;
- Passage guide semantics sufficient to express the intended physical choreography; and
- any third-party occupancy/protection facts that constrain commitment.

A Candidate MUST NOT become supported merely because the Shared Crossing Core fits. Where the selected arrangement requires lateral excursion, the Candidate MUST positively support the required lateral outcome and prospective theatre. Concrete helper-specific steering geometry remains Reality-bound and is materialised only after Transit settlement at the captured execution origin. This is the implementation-facing meaning of a **Passage-Capable Theatre** without allowing helper mechanics to become hidden reserve policy.

The Candidate is prospective. Selection of the Candidate does not establish the Resolution; [`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) owns that semantic lifecycle boundary.

> **Passage Candidate Support != Bubble Formation Readiness**

### Commitment and Bubble Formation

Cooperative Passage is admitted only from exactly two active GIANTS AI participants and only when the parent Pairwise Resolution Exclusivity constraint permits one coupled Resolution Commitment in the Local Operation.

After Decision selects a supported, constraint-admissible Passage Candidate, the implementation MUST establish **Bubble Formation Readiness** from fresh evidence before asking Responsibility Transition to establish or replace Current Responsibility.

Bubble Formation Readiness MUST remain false when the selected Candidate is stale, inadmissible, or no longer supports the complete Passage-Capable Theatre.

When the selected Candidate remains current and complete, Bubble Formation Readiness MUST become positive when either of two supported timing routes is positively established:

1. **settled native-revelation route** — current positive evidence establishes the participants' native continuation sufficiently settled for the selected arrangement; positive settled-continuation evidence for both participants is sufficient for this route; or
2. **latest-safe-capture route** — current independent progression has consumed disposable native approach margin to the arrangement-specific latest safe capture point, so further waiting would begin consuming capture/control reserve or another required part of the complete Passage-Capable Theatre.

A transitional native state such as GIANTS `TURNING` MUST NOT prevent Candidate evaluation or Candidate support after Passage Evaluation Readiness is positive. It also MUST NOT prevent Bubble Formation through the latest-safe-capture route when the complete selected Passage remains supported.

Conversely, a selected Candidate produced while one or both participants remain transitional MUST NOT replace a still-supported Regulation predecessor merely because the Candidate exists while disposable native approach margin remains.

> **Passage Evaluation Readiness != Passage Candidate Support != Bubble Formation Readiness**

A pairwise Passage-entry / `entryReady` conclusion MAY contribute current capture geometry, but MUST NOT be used as the sole Bubble Formation Readiness verdict.

> **Passage Entry Readiness != Bubble Formation Readiness**

At commitment, the implementation MUST establish two participant-scoped **Passage Leg** obligations under one Resolution Commitment.

The Bubble begins only when Bubble Formation Readiness is positive and the pair accepts the jointly dependent obligations. A selected arrangement whose required Lateral Excursion Development/Reacquisition is unsupported MUST NOT establish Bubble Formation.

Bubble Formation begins the Resolution Epoch.

The Bubble MUST NOT create persistent pair history, future-route ownership, permanent right-of-way, a three-worker Resolution, or a replacement participant route.

### Passage reserve and capture

Passage commitment MUST be governed by the Architecture's current reserve policy rather than a universal distance literal.

The implementation MUST preserve the distinction among:

- the **Geometric Entry Boundary** required by the selected manoeuvre itself;
- one pairwise **Capture Reserve** outside that boundary, used to acquire and settle the pair;
- the **Shared Crossing Core** required by the selected Transit-configured pair; and
- any participant-specific **Lateral Excursion Development/Reacquisition** required by the selected arrangement.

The Geometric Entry Boundary MUST be derived from the selected pair's supported **Transit-configured facing longitudinal extents**. Participant-specific lateral excursion MUST NOT be added as longitudinal Entry reserve.

Capture Reserve MUST be represented as the one explicit pairwise longitudinal safety margin outside the Geometric Entry Boundary. The same reserve MUST NOT be re-applied per participant, duplicated elsewhere in Entry geometry, or recreated from lateral excursion magnitude.

A complete supported Cooperative Passage Candidate MAY exist while the pair is still outside the current Capture boundary. In that state the implementation MUST NOT establish Cooperative Passage merely to obtain pre-Capture speed control. Instead, the pair MUST remain under the Regulation Jurisdiction through a **Passage Approach Regulation** while GIANTS-native routing and steering continue.

Passage Approach Regulation MUST cap both prospective Passage participants at an initial maximum of **10 km/h per participant** by temporarily lowering their native **GIANTS Cruise Control** values. For each direction the applied value MUST be `min(original value, 10 km/h)`; OMW MUST NOT increase a lower existing Cruise Control value.

After Passage Approach Regulation has acquired the pairwise ceiling, Candidate Support MUST allow the normal Cooperative Passage Candidate and Bubble Formation Readiness contract to resume. Regulation remains the predecessor while Bubble Formation Readiness is false. Either the settled-native-revelation route or the latest-safe-capture route MAY justify the subsequent sharp Responsibility Transition to Cooperative Passage.

> **Regulation Acquisition != Capture Readiness**

The temporarily modified GIANTS Cruise Control values MUST persist across the Regulation-to-Passage Responsibility Transition and remain in force for the complete Passage lifecycle, including Return. The Cruise Ceiling is configuration state, not movement authority; it MUST NOT create steering, direction, target or displacement authority.

OMW MUST capture each participant's original forward and reverse Cruise Control values before modification and MUST restore those original values on every Passage terminal exit, including success, failure, product disable and other fail-safe relinquishment. Pair application MUST be fail-safe: if both participants cannot be configured, any participant already changed in that attempt MUST be restored before the operation reports failure.

If first complete Passage support occurs only when Capture Reserve is already due, Candidate Support MAY expose Passage directly through the existing latest-safe-capture route; the same Cruise Ceiling MUST then be acquired before physical Passage dispatch rather than manufacturing a zero-duration predecessor Regulation.

> **Speed Configuration != Movement Authority**

> **Passage Speed Envelope Spans Responsibility Transitions**

> **Confirmed Passage != Immediate Passage Responsibility**

> **Passage Approach Regulation != Passage Resolution**

The 10 km/h ceiling MUST NOT be represented as additional Capture Reserve, a braking-distance model, a replacement for latest-safe-capture timing, or the third-party 1 km/h Bullet Time policy. After Capture and Transit settlement, the existing common **8 km/h** Cooperative Passage actuation speed remains the coupled-movement calibration.

> **Passage Approach Responsibility != Unrestricted Native Reset**

Required lateral excursion MUST be represented first as a **Lateral Excursion Outcome**, independent of the mechanical trajectory used to realise it. A Steering Helper MAY use forward progression to make that outcome steerable, but helper-specific forward travel MUST NOT be added to the Geometric Entry Boundary, Capture Reserve, or disposable native approach margin.

The initial Forward-Diagonal Steering Helper uses a **2.0 m forward per 1.0 m lateral** calibration. This is a mechanical steering calibration, not a reserve formula. Development and Reacquisition MUST hold independent helper state even when both currently use the same helper family and calibration.

Prospective Candidate Support MUST establish a supported Transit arrangement, field/third-party theatre and Shared Crossing Core without requiring a complete helper-specific pair sweep from a hypothetical future Entry origin. Prospective planning MUST NOT materialise Forward-Diagonal travel as hidden Entry reserve.

After Capture and Transit settlement, Control MUST rebase the selected guide to the fresh realised execution origin. Candidate Support MUST then materialise the selected Steering Helper from that realised origin and MUST obtain positive pair-sweep support from current realised Transit geometry before any guide movement begins. If the retained arrangement with its materialised helper is unsupported, a fresh arrangement MAY be selected from the same realised origin.

Joint Passage start MUST distinguish prospective guide integrity from realised execution support. Before Transit settlement, Control MAY validate guide/gate structure and participant binding, but MUST NOT convert an exact future guide-target Field World or third-party contradiction into a terminal Resolution verdict. Candidate Support already owns prospective theatre support; exact target execution support is reassessed from the realised Transit origin.

> **Prospective Guide Preflight != Realised Execution Guide Preflight.**

At the realised origin, adaptation MUST NOT select an arrangement on pair-sweep support alone. The retained arrangement and every considered replacement arrangement MUST satisfy the complete current execution constraints required before movement, including Field World target support and current third-party guide support.

A Field World failure is a hard veto on the affected movement target under ordinary in-field authority. It is positive Constraint evidence about that arrangement, not automatic failure of the pairwise Resolution. If the retained arrangement is pair-clearance-valid but field-invalid, Control MUST NOT execute it and MUST route the contradiction into the existing realised-origin arrangement reassessment. The search continues until a complete supported spatial arrangement is found or the existing spatial allocation set is exhausted.

Field support at this boundary is target authority, not a requirement that every point of the Transit-configured assembly remain strictly inside the polygon. A bounded immediate field-margin overhang MAY occur during a local Passage when the selected steering targets remain positively Field-supported and all hard pair / third-party safety predicates remain positive. The accepted TS004 TEST 0.4.8.13 Reality result includes an approximately 0.5–1 m Deere-side margin excursion during successful Passage. No fixed overhang-distance literal is introduced by this observation.

> **Bounded Field-Margin Encroachment != Extra-Field Passage.**

> **Target Outside Field World != Interaction Unresolvable.**

> **Field World Rejection Is Arrangement Evidence, Not Resolution Veto.**

> **Control Veto != Resolution Verdict.**

The existing bounded spatial-allocation set includes participant-asymmetric lateral burdens. Those alternatives MUST remain available under the same support predicates before ordinary local Passage is declared unavailable. This does not authorise a new sequential/single-mover choreography, an off-field steering target, or remote extra-field travel; bounded immediate field-margin overhang is governed by the accepted local-theatre rule above.

> **Fresh Realised Arrangement Support Requires Complete Current Constraints.**

> **Spatial Asymmetry != Temporal Asymmetry.**

If no fresh realised-origin arrangement is supported under the complete current execution constraints, autonomous Passage movement MUST NOT begin.

> **Development Reserve != Steering Trajectory**

> **Steering Helper May Consume Reserve; It Does Not Define Reserve**

> **Lateral Excursion Outcome != Steering Trajectory**

The Capture Reserve magnitude remains Control calibration validated against Reality. It MUST NOT be treated as a braking-model claim, universal stopping-distance claim or fixed time-to-contact literal.

Sequential return space MUST be represented as protected already-created Passage space, not as a second generic rearward reserve.

The implementation MUST also preserve **disposable native approach margin** that can be consumed before capture while retaining the complete required theatre.

Current closing progression determines how quickly disposable margin is consumed.

The implementation MUST derive a current **latest safe capture point** for the selected arrangement from the remaining disposable native approach margin, current supported theatre geometry and current progression. The verdict MUST answer whether further independent progression would begin consuming capture/control reserve or another required part of the complete Passage-Capable Theatre.

The latest safe capture point MUST NOT be reduced to:

- the Passage Entry Boundary alone;
- `entryReady` alone;
- one universal separation distance; or
- one universal time-to-contact literal.

Bubble Formation through the latest-safe-capture route MUST occur before independent approach crosses that boundary. Capture after Bubble Formation MUST still occur before independent approach makes the accepted Passage-Capable Theatre no longer supportable.

> **Full-Lifecycle Feasibility Is An Admission Requirement, Not An Execution Guarantee.**

### Clearance policy

Physical non-contact is mandatory.

The implementation MUST realise the Architecture's approximate **1 m nominal Passage-clearance policy** using purpose-specific Passage representation. That policy margin is empirical and MUST NOT be reinterpreted as a precise universal collision model.

Implementation-local search steps, tolerance literals, sample counts and candidate enumeration remain mechanism unless Architecture or another accepted contract makes them normative.

## Passage Leg contract

Each original participant receives one Passage Leg obligation. A live Passage Leg owns only the intervention-created debt required by the accepted Passage.

Depending on what OuttaMyWay actually changes for that participant, that debt MAY include:

- capture and coupled Passage movement;
- participant-specific displacement or reorientation recovery;
- Alignment Runout where current whole-assembly articulation/alignment requires supported forward settlement for the selected recovery mechanism;
- Axis Settlement or Axis Return where the intervention created spatial restitution debt that actually requires it;
- restoration of configuration or other physical state changed by OuttaMyWay; and
- GIANTS handback.

The implementation MUST NOT reconstruct or "correct" pre-existing articulation, alignment or configuration imperfection that was not created by the Passage intervention.

> **Lateral Excursion Is Optional Passage Geometry, Not A Lifecycle**

A selected arrangement may require lateral excursion or may remain on-axis. That distinction changes only the guide geometry used to create and later remove lateral displacement. It does not create an alternate downstream lifecycle or imply early handback.

The two legs may progress and terminate independently where current evidence supports it. Physical crossing alone does not settle a leg while Return Staging, Passage Return, restoration or handback remains open.

> **Pairwise Resolution != Symmetric Progress Requirement**

> **Bubble Lifetime != Symmetric Control Lifetime**

### Passage Leg terminal dispositions

A Passage Leg has two ordinary terminal dispositions:

- **HANDED_BACK** — the leg's required Passage debt has been positively discharged and the participant returned to GIANTS AI; and
- **VACATED** — authoritative positive lifecycle evidence establishes that the original committed participant can no longer be executed as that original AI Passage subject.

`VACATED` is basis cessation for that participant-scoped obligation, not generic Passage failure.

A Passage Leg MUST NOT be vacated merely because:

- the participant is temporarily stopped;
- the player is present while the same exact Job Episode remains active;
- an observation is incomplete;
- a source disappears without authoritative lifecycle evidence; or
- Control sees an unresolved raw contradiction.

Authoritative termination of that leg's exact original GIANTS Job Episode is sufficient participant-loss evidence when the governing lifecycle contract establishes it.

Vacatur settles only the vacated leg's obligation and physical authority. It MUST NOT admit a replacement participant or create a new Resolution.

### Survivor Invariance

When one leg is vacated, the surviving Passage Leg continues the same already-committed Passage contract, including its own remaining Passage, Return Staging, Passage Return Region, intervention-created restoration and GIANTS handback obligations as applicable.

The vacated leg ceases to be a procedural dependency, but its physical assembly remains current Reality if still present.

> **Choreography Vacatur != Physical Disappearance**

Fresh hard-safety evidence about the former participant's continuing occupancy therefore remains relevant to the survivor's permitted physical progression.

## Reality-verified execution contract

### Crossing Clearance

**Crossing Clearance** is positive current evidence that the original opposed pairwise crossing conflict has physically cleared. It is the semantic boundary after which participant-scoped recovery and early individual GIANTS handback may proceed.

Crossing Clearance MUST be established from current pair geometry / rear-clear evidence fit for that question. Reaching a procedural gate name, elapsed time or nominal crossing midpoint is insufficient by itself.

Before Crossing Clearance, the unresolved original crossing conflict prevents blind native release merely because a downstream recovery mechanism has become difficult. After Crossing Clearance, the implementation MAY discharge and hand back one leg independently when its own intervention-created debt is positively satisfied.

> **Crossing Clearance != Exact Axis Restitution**

A pre-Crossing execution-validity check MUST NOT reject an otherwise supported opposed crossing solely because predicted post-Crossing lateral reacquisition, Return Staging, Passage Return or restoration may later be unsupported. Those obligations are participant-scoped recovery after positive Crossing Clearance and MUST be reassessed at the downstream responsibility that owns them.

> **Post-Crossing Recovery Cannot Retroactively Veto Crossing**

### Passage Return Region

After positive Crossing Clearance, Passage restitution MUST restore **locality**, not an exact productive pose.

Each still-live participant MAY require bounded forward Return Staging so that sequential reverse has positively protected space. Return Staging MUST be owned by separation/occupancy requirements; exact captured-axis alignment MUST NOT be a prerequisite.

A participant with remaining displacement debt MUST then reverse under native steering toward a subordinate **Reverse Steering Horizon** beyond its captured execution origin / original work-lane locality. The completion condition remains entry into a bounded **Passage Return Region**, not steering-target arrival and not exact centreline, heading or articulation reproduction.

For the current capability, Reverse Steering Horizon look-through MUST be derived from the participant's cached Transit longitudinal length. It is steering geometry only: it MUST NOT extend movement authority, enlarge the Return Region, add another longitudinal reserve or become restitution-completion evidence.

The return mechanism MUST:
- keep the participant in Transit while spatial restitution is active;
- return participants sequentially rather than simultaneously;
- preserve the existing first-participant Return Staging, Passage Return Region, restoration and same-Job handback path;
- require positive **Return-Space Clearance** before the waiting second participant begins return;
- retain the existing GIANTS FIELDWORK Job Episode;
- determine Return Region entry independently from the reverse steering mechanism's point-target completion;
- stop/fail safe if the subordinate steering horizon is reached before Return Region entry;
- restore intervention-created configuration debt after the Return Region is reached; and
- hand control back to GIANTS for residual productive-route correction.

### Sequential Return-Space Clearance

The **Mutual Return Region** is the bounded approximate shared interaction region within already-created sequential return space that remains relevant after the first participant has completed Passage Return, restoration and same-Job handback but before the second participant begins its own Passage Return.

Its implementation MAY approximate that region from the accepted Passage crossing/return geometry plus purpose-fit current Physical Assembly representation. It MUST NOT require exact swept-path reconstruction, preserve an unbounded historical Passage-axis corridor, predict the handed-back participant's future GIANTS route or introduce a new universal distance literal.

This contract applies only to the second return. The first participant's Return Staging, Passage Return Region, restoration and handback semantics are unchanged.

After first-leg `HANDED_BACK`, the released participant remains current physical Reality. **Return-Space Clearance** MUST be established from positive current evidence that its represented physical occupancy no longer intersects the Mutual Return Region required by the waiting participant's remaining return.

Return-Space Clearance MUST NOT require the released participant to:

- cross a fixed scalar station on the retained Passage axis;
- continue monotonically along that historical axis; or
- reveal/preserve a future native route.

Normal GIANTS continuation after handback MAY turn, reverse or reposition away from the historical Passage axis without invalidating the first leg's terminal state.

> **Released-Participant Forward Progress != Return-Space Clearance**

> **Native Continuation After Handback Need Not Continue Along The Passage Axis**

Once Return-Space Clearance is positive, the waiting participant MAY begin its already-authorised Passage Return. During that return, fresh current occupancy and hard-safety evidence remain authoritative; later conflict MAY stop or narrow actuation, but absence of future-route prediction MUST NOT recreate the historical-axis progression dependency.

A **Return Clearance Wait** is an evidence wait, not a completion-progress phase. The waiting participant remains stationary because required external current evidence is not yet positive; its lack of movement is therefore not itself evidence of Passage failure.

Return Clearance Wait MUST be bounded by a separate evidence-wait budget. The exact duration is Control calibration validated against Reality and is not specified here.

Expiry of that evidence-wait budget MUST NOT establish Return-Space Clearance, Passage success, recovery completion or safe handback. On expiry the implementation MUST perform fresh post-Crossing safe-native-continuation reassessment. Where restoration plus GIANTS handback of the waiting participant is positively safe, the existing degraded native-settlement contract MAY discharge that remaining leg without completing the planned second Passage Return. Where safe autonomous handback is not positively supported, fail-safe escalation remains required.

> **Clearance Wait Is Evidence Wait, Not Progress Phase**

> **Evidence-Wait Expiry != Return-Space Clearance**

Passage MUST NOT restart or replace the FIELDWORK job merely to perturb GIANTS routing. That behaviour belongs to Blocked Worker Recovery, where blockage invalidates the useful native route; Cooperative Passage does not invalidate the participant's productive route.

> **Passage Return Region != BWR Recovery Return Region**

> **Passage Return Region != Reverse Steering Horizon**

> **Movement Completion Region != Reverse Steering Target**

> **Restitution Sufficiency != Geometric Restoration**

Passage commitment does not freeze execution geometry.

Before geometry-dependent physical Passage movement begins after capture, both participants MUST positively realise their required Transit configuration. The implementation MUST then return to **fresh Reality** and establish that the accepted Transit Passage remains executable for the realised physical state.

The execution-validity question includes, as applicable:

- realised Transit geometry for both participants;
- current natural separation and lateral relationship;
- current clearance deficit;
- Development burden;
- current execution origin;
- current physical occupancy;
- third-party and former-participant occupancy relevant to the active leg; and
- the still-supported relation between the retained arrangement and the current Passage guide.

A guide may be rebased to current execution origins only after its retained geometry remains supported or is replaced by an independently supported adaptation permitted by the committed Passage contract.

> **Execution-Origin Rebase != Arrangement Revalidation**

> **Guide Rebase != Geometry Revalidation**

Rebasing coordinates while preserving stale lateral/clearance assumptions does not satisfy this execution-validity contract.

If fresh Reality cannot positively support the retained or validly adapted Passage arrangement **through Crossing Clearance**, physical Passage progression MUST fail closed at that boundary rather than treating earlier Candidate support as permanent authority. Predicted support loss confined to post-Crossing recovery MUST NOT be promoted into a pre-Crossing Passage veto.

Once a physical leg is underway, its locally authorised execution choice SHOULD remain stable enough to avoid oscillatory retargeting. Hard-safety evidence remains authoritative and may force narrowing, stopping or failure according to the parent/downstream contracts.

## Third-worker protection

Before Passage commitment, an independent third active worker remains an independent Traffic Party. Existing occupancy of space essential to the proposed pairwise Resolution blocks commitment until independent ordering makes that space available.

At Bubble Formation, the Resolution Epoch creates the Architecture-defined requirement for the independent third active worker to enter **1 km/h Bullet Time**.

The implementation MUST realise that requirement through the existing Regulation Jurisdiction; it MUST NOT:

- add the third worker to the Bubble;
- create a new Passage Leg for it;
- create a new Regulation subtype;
- acquire or replace the third worker's independent movement objective merely to apply the speed ceiling; or
- infer that the third worker's independent Situation has permanently disappeared.

Bullet Time is a **Supporting Speed Ceiling**. It applies to the independent third worker regardless of whether that worker is currently progressing under ordinary GIANTS AI or under another compatible independently current OuttaMyWay movement responsibility such as Blocked Worker Recovery.

Where the third worker is already under Blocked Worker Recovery, the Recovery Resolution and its authorised Recovery Excursion continue. Bullet Time narrows only the realised maximum speed to no more than **1 km/h** while the Bubble remains current. It does not pause, restart or replace Recovery and does not acquire the Recovery movement objective.

When the Bubble dissolves, removal of Bullet Time removes only that Passage-owned speed ceiling. Any still-current independent movement responsibility continues under its own remaining authority without a new semantic transition.

The third worker remains observed Reality, and hard-safety evidence remains authoritative during the epoch.

## Last-Leg Dissolution

The Bubble dissolves immediately when both original Passage Legs are terminal.

Valid combinations include:

```text
HANDED_BACK + HANDED_BACK
VACATED    + HANDED_BACK
VACATED    + VACATED
```

While either original Passage Leg remains live, the parent Resolution Commitment and Resolution Epoch remain live subject to the parent lifecycle contract and any shared obligations.

Dissolution MUST NOT add a distance tail, arbitrary timeout, cooldown, relationship-settlement delay or persistent pair memory.

After dissolution, fresh Situation Assessment determines any new responsibility involving former participants or the independent third worker.

## Failure and uncertainty semantics

- **Passage recognition not positively supported** — no Passage Candidate authority.
- **Native A8 Clearance Exclusion positively supported** — no Passage Candidate authority for that current opposed A8 relationship; preserve native GIANTS progression unless another independently supported responsibility applies.
- **Native A8 Clearance Exclusion unavailable or unresolved** — it has no independent exclusion authority; continue the normal Passage-evaluation path without promoting uncertainty into conflict.
- **Complete-assembly purpose-specific geometry unavailable** — reject any Candidate requiring complete-assembly Passage authority; do not substitute subset completeness.
- **Passage-Capable Theatre unavailable before commitment** — do not commit; where Passage remains foreseeable, tactical Regulation may continue shaping the encounter without reserving Passage as the successor.
- **Either participant's required Transit configuration not positively realised** — do not begin geometry-dependent Passage movement; there is no full-width/working-configuration Passage execution fallback.
- **Execution arrangement no longer supported by fresh Reality before Crossing Clearance** — reject/halt unsupported progression and require supported adaptation or failure handling; do not preserve stale guide authority.
- **Required recovery becomes unsupported after Crossing Clearance** — stop unsupported OuttaMyWay recovery actuation and reassess current safe-native-continuation evidence. Where restoration plus GIANTS handback is positively safe, that evidence MAY support degraded native settlement even when exact planned spatial restitution cannot be completed. Agronomic perfection is not itself spatial-safety authority. Where safe autonomous handback is not positively supported, preserve fail-safe escalation rather than inventing geometry.
- **One participant's exact Job Episode authoritatively ends** — vacate only that Passage Leg, release its participant-scoped authority, preserve the survivor contract.
- **Raw contradiction before semantic lifecycle resolution** — suspend unsupported new progression as needed for safety, but do not vacate a leg or dissolve the Bubble from raw evidence alone.
- **Hard-safety contradiction during execution** — downstream authority/control MUST fail closed; no alternative strategic route may be invented inside Control.
- **Both legs terminal** — dissolve the Bubble immediately and allow the parent Resolution lifecycle to reach terminality.

A phase watchdog, target radius, actuation speed, alignment tolerance or other Control calibration MUST NOT become semantic Passage failure evidence merely because a source timer or threshold expires.

The accepted Passage progress watchdog calibration is **10 seconds with no meaningful progress toward the current phase completion condition**. Progress MUST be measured against the phase's completion residual rather than generic vehicle movement. Expiry requires fresh assessment / fail-safe handling; it does not manufacture Passage success, recovery-debt discharge, safe handback or failure.

**Return Clearance Wait is excluded from the progress-watchdog model.** Its completion depends on fresh external occupancy evidence from the already-handed-back participant, which need not improve monotonically and is not movement progress by the waiting participant. The separate bounded evidence-wait budget defined above owns that uncertainty interval.

The common Cooperative Passage actuation speed remains **8 km/h** for both participants. This is Control calibration for coupled crossing coherence, not a claim that equal commanded speed guarantees equal realised motion.

## Durable invariants

### Exactly two committed participants

Cooperative Passage begins with exactly two original active GIANTS AI participants. No third or replacement participant may join the Resolution.

### Purpose-specific geometry remains scoped

Passage geometry may prove Passage-specific conclusions only within its declared state, purpose and coverage. It does not acquire generic collision or negative-clearance authority.

### Working recognition, native-clearance exclusion and Transit execution remain distinct

Working geometry may conservatively identify Passage concern. A purpose-specific Native A8 Clearance Exclusion may positively prove that native opposed A8 retains nominal clearance even at supported maximum productive-A8 extents. Candidate planning uses supported prospective Transit geometry only after Passage Evaluation Readiness remains positive. After commitment/capture, physical Passage execution requires positive Transit realisation for both participants plus fresh realised-state evidence before geometry-dependent movement begins.

> **Working Geometry Identifies Passage Concern; Native A8 Clearance May Exclude Passage; Transit Geometry Executes Passage.**

### Stale guide assumptions have no independent authority

An earlier Candidate/guide cannot override fresh contradictory or materially changed execution Reality.

### Participant loss is obligation-scoped

Vacatur settles one Passage Leg. It does not automatically terminate the survivor leg or the parent Resolution.

### Passage owns only intervention-created debt

Recovery/restoration obligations are bounded to what the Passage changed.

### Last leg owns dissolution

Bubble and Resolution-Epoch Passage protection end exactly when the last original Passage Leg becomes terminal.

## Cross-Jurisdiction dependencies

### Resolution Lifecycle

[`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md) owns generic obligation persistence and terminal meaning. Cooperative Passage defines the concrete Passage Leg obligations and evidence contracts.

### Situation Assessment

Situation Assessment owns current Passage foreseeability and current spatial meaning. Cooperative Passage does not preserve a stale foreseeability conclusion as current evidence.

### Candidate Support / Constraint Evaluation / Decision

The generic prospective-selection chain owns support composition, mandatory admissibility and selection. Cooperative Passage defines what a semantically meaningful Passage Candidate must contain.

### Responsibility Transition

[`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) establishes the Cooperative Passage Resolution Commitment as Current Responsibility and owns any later semantic replacement/termination.

Cooperative Passage supplies Bubble Formation Readiness as the purpose-specific successor-readiness precondition consumed at that boundary. Responsibility Transition MUST NOT infer readiness merely from Candidate selection.

### Assessment Representation

[`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) owns the claim-bearing representation products consumed by Passage. Cooperative Passage owns the purpose-specific question and what evidence is sufficient for this Resolution contract.

### Regulation

Before Bubble Formation, a still-supported Regulation predecessor MAY remain current after Passage Candidate selection while disposable native approach margin remains and transitional native revelation is still materially useful. This is not a hybrid Passage mode because the Bubble does not yet exist.

Candidate support ends any need for further Passage-theatre shaping of an already-supported arrangement, but it does not by itself dissolve another current Regulation purpose.

After Bubble Formation, Regulation owns the third-worker Bullet-Time responsibility. The Passage Resolution supplies the Situation reason and duration of the Resolution Epoch; it does not create a new Regulation type.

### Bounded Authority and Control

Bounded Authority determines participant-scoped physical permission. Control executes already-authorised Passage actions. Neither may invent a replacement strategy or declare semantic Passage success solely from actuator completion.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/candidates/LiveTrafficCandidateSupport.lua`](../scripts/candidates/LiveTrafficCandidateSupport.lua) | `REALISES` |
| [`scripts/candidates/LocalPassagePlanner.lua`](../scripts/candidates/LocalPassagePlanner.lua) | `REALISES` |
| [`scripts/candidates/ForwardDiagonalSteeringHelper.lua`](../scripts/candidates/ForwardDiagonalSteeringHelper.lua) | `REALISES` |
| [`scripts/responsibility/BubbleFormationReadinessEvaluator.lua`](../scripts/responsibility/BubbleFormationReadinessEvaluator.lua) | `REALISES` |
| [`scripts/responsibility/CooperativePassageResponsibilityTransition.lua`](../scripts/responsibility/CooperativePassageResponsibilityTransition.lua) | `REALISES` |
| [`scripts/commitment/LiveTrafficCommitmentLifecycle.lua`](../scripts/commitment/LiveTrafficCommitmentLifecycle.lua) | `REALISES` |
| [`scripts/authority/BubbleBulletTime.lua`](../scripts/authority/BubbleBulletTime.lua) | `REALISES` |
| [`scripts/control/mechanisms/PassageCruiseControl.lua`](../scripts/control/mechanisms/PassageCruiseControl.lua) | `REALISES` |
| [`scripts/control/CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua) | `REALISES` |
| [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) | `REALISES` |
| [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua) | `SUPPORTS` |
| [`scripts/representation/MaximumProductiveA8Representation.lua`](../scripts/representation/MaximumProductiveA8Representation.lua) | `SUPPORTS` |
| [`scripts/assessment/NativeA8ClearanceAssessment.lua`](../scripts/assessment/NativeA8ClearanceAssessment.lua) | `SUPPORTS` |
| [`scripts/representation/PairSpecificPassageClearance.lua`](../scripts/representation/PairSpecificPassageClearance.lua) | `SUPPORTS` |

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/candidates/LiveTrafficCandidateSupport.lua`](../scripts/candidates/LiveTrafficCandidateSupport.lua) and [`scripts/candidates/LocalPassagePlanner.lua`](../scripts/candidates/LocalPassagePlanner.lua) — current Passage-specific Candidate support, arrangement planning and reserve/guide construction within the wider Candidate Support machinery;
- [`scripts/candidates/ForwardDiagonalSteeringHelper.lua`](../scripts/candidates/ForwardDiagonalSteeringHelper.lua) — current mechanically scoped 2:1 forward-diagonal helper used only when realised Transit execution geometry is materialised; it owns no Entry or Capture reserve authority;
- [`scripts/representation/PairSpecificPassageClearance.lua`](../scripts/representation/PairSpecificPassageClearance.lua) and Passage-purpose products from [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua) — current purpose-specific geometry/clearance evidence;
- [`scripts/responsibility/BubbleFormationReadinessEvaluator.lua`](../scripts/responsibility/BubbleFormationReadinessEvaluator.lua) — current purpose-specific successor-readiness evaluation between selected Passage Decision and Responsibility Transition, including settled-native and latest-safe-capture routes;
- [`scripts/responsibility/CooperativePassageResponsibilityTransition.lua`](../scripts/responsibility/CooperativePassageResponsibilityTransition.lua) — current specialised transition collaborator that establishes the Passage Resolution semantic product through the Responsibility Transition boundary;
- [`scripts/commitment/LiveTrafficCommitmentLifecycle.lua`](../scripts/commitment/LiveTrafficCommitmentLifecycle.lua) — current Passage-Leg obligation creation/settlement, participant-loss vacatur and parent terminal integration;
- [`scripts/authority/BubbleBulletTime.lua`](../scripts/authority/BubbleBulletTime.lua) — current formation-time independent-third supporting-ownership preparation, fixed 1 km/h Regulation activation after Passage responsibility exposure, and Resolution-Epoch/basis cleanup;
- [`scripts/control/mechanisms/PassageCruiseControl.lua`](../scripts/control/mechanisms/PassageCruiseControl.lua) — captures/restores native GIANTS forward/reverse Cruise Control values and applies the pairwise 10 km/h Passage ceiling atomically while leaving route and steering with GIANTS;
- [`scripts/runtime/Runtime.lua`](../scripts/runtime/Runtime.lua) — current Passage-specific joint Bounded Authority request construction, survivor-leg authority rebind/failure handling and completion integration;
- [`scripts/responsibility/ResolutionCommitmentAdapter.lua`](../scripts/responsibility/ResolutionCommitmentAdapter.lua) — current semantic Resolution Commitment view over the retained implementation substrate; and
- [`scripts/control/CooperativePassageControl.lua`](../scripts/control/CooperativePassageControl.lua) — current physical Passage executor, configuration settlement, guide execution, recovery and handback mechanism.

The Control module is not the owner of Passage strategy or semantic success merely because it contains the current phase machine.

Current source contains an execution-origin guide rebase and preflight path. This Specification does not treat that mechanism as proof of conformance to the Reality-verified execution boundary; the contract requires arrangement validity against fresh realised evidence regardless of helper names or phase structure.

## Validation route

### Structural/source-contract validation

[`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py) protects pairwise Passage ownership, Responsibility Transition ordering, participant-loss settlement, third-party serialization and Control/authority boundaries.

[`tests/test_bubble_bullet_time_structure.py`](../tests/test_bubble_bullet_time_structure.py) protects the current Bubble-protection wiring, fixed Regulation literal, decision-horizon deferral and cleanup placement.

Representation-specific structural tests protect purpose-scoped geometry ownership and prevent generic representation evidence from silently acquiring Passage authority.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises Passage Candidate/commitment creation, Bubble Formation Readiness routes, participant-scoped obligations, vacatur, survivor continuation, terminal settlement and bounded Control sequencing.

[`tests/replacement_core/bubble_bullet_time.lua`](../tests/replacement_core/bubble_bullet_time.lua) exercises the formation-time third-party preparation, post-transition fixed 1 km/h activation, passive Bubble decision horizon, basis release and two-worker non-interference contract.

Offline tests can challenge semantic lifecycle and deterministic geometry contracts but cannot prove that real GIANTS physical execution preserves required clearance.

### Targeted in-game Reality validation

In-game validation is required for capture timing, configuration settlement, actual Passage clearance, execution-validity refresh, third-worker interaction, GIANTS handback and participant-loss behaviour.

Targeted Reality validation must specifically challenge post-configuration arrangement revalidation, crossing-window progress/failure recognition, stale-guide contradiction, and the distinction between execution-origin rebasing and arrangement validity. Unresolved investigations and evidence history remain owned by Issues and engineering-evidence surfaces rather than this Specification.

### Outside this Specification's validation claim

A successful Cooperative Passage does not validate generic Candidate Support, all representation purposes, generic Regulation policy or arbitrary multi-worker traffic behaviour outside the declared supported envelope.