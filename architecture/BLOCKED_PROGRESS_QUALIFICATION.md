# Blocked-First Situation Assessment — 0.5 Architecture

**Status:** accepted architectural direction and outstanding responsibilities under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). This document records the accepted correction that **GIANTS `isBlocked` is the blockage authority**, rather than requiring OuttaMyWay to prove native blockage independently. The live TEST product now performs **server-gated Hold & Relocate Control** after independent Pair Commitment; passive native Observation itself still only reads GIANTS blocked-state fields, with no native event hook. This is executable implementation, **not a claim of in-game validation**.

## Purpose

OuttaMyWay exists to help a worker resume its GIANTS-owned autonomous activity when native blockage warrants intervention, with the **least disruptive justified response**. GIANTS decides that a worker is blocked. OMW does not duplicate native collision detection or reconstruct GIANTS' fieldwork route.

> **Native `isBlocked` = GIANTS' blocked-state evidence.**
>
> **Blocked-state evidence ≠ identity of blocking partner ≠ automatic authority to intervene.**

This is the architectural separation we need. Ordinary opposed A8 passing is expected to produce **less than one second of confirmed GIANTS blockage**, so the existing persistence gate filters it **without an A8 classifier**. GIANTS can also alternate blocked/unblocked while attempting to manoeuvre around a moving worker or static obstacle. These are authentic native states, not automatic intervention requests. The A8 duration is a working scenario assumption, not a universally demonstrated bound.

[Native Course Advancement](../docs/research/USEFUL_CONTINUATION_EVIDENCE.md) remains completed source research, **not** a required signal, dependency or gate. The physical-obstruction proof step proposed in the initial PR #446 draft is likewise **withdrawn**. **GIANTS retains native replanning authority** ([Project Vision](PROJECT_VISION.md)).

## Named evidence and responsibility concepts

| Concept | Architectural meaning | Boundary |
| --- | --- | --- |
| **Native Blockage Edge** | GIANTS reports `isBlocked=true` or `false` for an identifiable worker | Does not identify a causal partner |
| **Native Blockage Pulse** | An interval of positively observed native blocked=true, ending on its known false edge | Not necessarily a distinct obstruction |
| **Unresolved Obstruction Episode** | An evidence-bound blocked/retry concern within one active GIANTS Job Episode, possibly across several pulses associated with the same unresolved encounter | Must not merge unrelated blocked encounters merely because worker/job identity matches |
| **Native Blockage Persistence Gate** | At least **1.000 second of accumulated confirmed blocked time** in one unresolved episode, excluding periods positively observed unblocked | Admits *consideration* only, never automatic hold/relocation |
| **Spatial Pair Inference** | After the native one-second gate, nominate the **nearest other eligible worker within 30 m horizontal X/Z root-to-root distance** | This approximate position-based candidate need not report blocked and is not proven causal |
| **Situation Assessment** | Decide whether the native blocked condition and plausible worker relationship justify **considering a cooperative response**, or whether to leave GIANTS to recover / await evidence | Does **not** independently prove GIANTS' collision or blocked state |
| **Hold & Relocate** | After selecting one worker to relocate, temporarily hold nearby blocker(s) to protect egress, reverse the selected assembly towards the field centroid in TRANSIT, hold it to allow the blocker to resume, then stop and immediately restart its GIANTS AI job | Live server-side TEST mechanism now wired behind independent Pair Commitment; in-game effects not yet validated |

## Evidence-to-responsibility flow

```text
GIANTS native isBlocked (worker and Job Episode)
                 |
                 v
   Blocked/unblocked pulse evidence
                 |
                 v
    Unresolved Obstruction Episode
                 |
                 v
 >= 1.000 s accumulated confirmed blocked time?
                 |
          +------+------+
          |             |
        NO (<1 s)      YES
          |             |
          v             v
      No OMW       Spatial Pair Inference
      candidate     (nearest ≤30 m)
      GIANTS owns        |
      continuation       v
                   Situation Assessment
                    /      |       \
                no pair  uncertain  plausible pair?
                   |       |              |
                   v       v              v
                GIANTS  WAITING_FOR_   separate
                continues EVIDENCE     Responsibility /
                                       Pair Commitment
                                       (live, independently admitted)
                                            |
                                            v
                                  Hold & Relocate
                                  (5 s blocker hold;
                                   transit + centroid reverse;
                                   10 s relocated-worker hold;
                                   GIANTS stop → immediate restart)
```

The diagram names separate responsibilities, **not** obligatory serial code or an invitation to implement a second obstruction detector. A single-worker obstruction to a tree/hedge remains a different situation from a worker-to-worker pair; a pair cannot be invented from the blocked flag alone.

## 1. Trust GIANTS for the blocked state

GIANTS' `isBlocked` is the input authority. There is no need for OuttaMyWay to recreate the native collision system, calculate a contact overlap, classify hedge versus worker from a separate obstacle detector, or independently prove physical obstruction before accepting a native blocked assertion.

Native `false` means GIANTS ceased reporting blocked **at that instant**. It does not prove that a temporarily moving neighbour will not obstruct again. Conversely, native `true` is not proof that GIANTS' own manoeuvres will fail or that OMW should act immediately.

The preferred *candidate observation direction* is native **blocked/unblocked edge-driven evidence**, not indiscriminate 500 ms scanning of all workers. [TEST 0.5.0.5 research](../docs/research/NATIVE_BLOCKED_EVENT_TAP.md) observed both directions, including a 174 ms pulse, in FS25 1.24.0.0. The experimental global constructor hook was **retired** in TEST 0.5.0.6; it is **not** a verified public subscription and must not be restored merely because a signal contract has been described.

## 2. Filter transient native blockage with the accepted persistence gate

The accepted gate is **≥1 second of accumulated positively confirmed native blocked time** within one unresolved obstruction episode. **Below 1 second, OMW ignores the blockage for intervention purposes: no Spatial Pair Inference, Situation Assessment or resolution candidate.** A false edge closes a *pulse* and prevents time accruing while unblocked; it does **not necessarily** close the unresolved concern. Repeated true/false retries may contribute to the same concern **only while episode continuity is supportable**.

Do not accumulate blocked time across unrelated passing encounters, distinct obstacles at different places, new Job Episodes, player takeover, missing/unknown observations or time imposed by OMW's later Control. Positive cessation of the encounter or Job Episode ends its eligibility. Targeted time evaluation may be needed after a true edge with no further notification, but does not imply a continuous all-worker scan.

**The gate is not a physical-obstruction proof step.** It already filters the expected short native assertions during ordinary opposed A8 passing; **no A8 recognition, classification, special distance, or dedicated exemption is required**. If ordinary successful passing later proves to generate ≥1 second of accumulated confirmed blockage, that challenges the duration assumption and should be recorded as Reality evidence—not pre-emptively patched with A8 logic. Reaching the gate allows generic Situation Assessment; it never grants movement authority.

## 3. Infer candidate worker pairs from positions

After a worker satisfies the gate, **choose the nearest other eligible local worker with a current assembly-root position within a 30-metre radius of the blocked worker's assembly root**, comparing horizontal **X/Z** coordinates. Deduplicate the root assemblies and exclude the blocked assembly itself. **The threshold is radius 30 m (distance ≤30 m), not diameter.** If there is no eligible worker in that radius, **there is no worker-pair candidate**; do not select a remote worker because it is the nearest available. **The candidate blocker need not report blocked.** This deliberately approximate root-position rule is accepted without implement geometry, clearance or route reconstruction.

`isBlocked` reports the **affected worker**, not the blocker. A nearby worker might be incidental to a hedge/tree blockage. That uncertainty belongs in **Situation Assessment and responsibility selection**, not in an additional physical-collision proof system.

**The 30 m radius is the accepted locality policy**, not an empirical physical-clearance or causal-contact threshold. No implement-width correction, vehicle-specific radius, collision hull, trajectory prediction or geometric precision is required. An in-radius worker is a *possible* blocker, not a proven one. If there is no candidate, do not invent a worker pair; where eligibility or attribution is uncertain, Situation Assessment may remain **WAITING_FOR_EVIDENCE**. Re-evaluate current positions/authority before any later Pair Commitment.

## Specification Jurisdiction — Native Blockage Observation

**Jurisdiction ID:** `NATIVE_BLOCKAGE_OBSERVATION`  
**Primary Specification:** [`spec/NATIVE_BLOCKAGE_OBSERVATION.md`](../spec/NATIVE_BLOCKAGE_OBSERVATION.md)

This read-only jurisdiction observes the **GIANTS-owned field-course `isBlocked` state** for active native AI field jobs and feeds the already accepted one-second/30 m candidate evaluator. It does not replace GIANTS callbacks, intercept event constructors, modify vehicles, reconstruct collision geometry, or establish a Pair Commitment.

Initial source counts **one continuous positively sampled native blocked pulse** toward the gate. This is sufficient to exercise candidate selection after a full one-second pulse. The accepted broader **multi-pulse Unresolved Obstruction Episode** remains a separately unimplemented continuity capability; do not substitute uncontrolled job-lifetime accumulation for episode evidence or invent a new duration/progress test.

## Specification Jurisdiction — Spatial Pair Inference

**Jurisdiction ID:** `SPATIAL_PAIR_INFERENCE`  
**Primary Specification:** [`spec/SPATIAL_PAIR_INFERENCE.md`](../spec/SPATIAL_PAIR_INFERENCE.md)

Only the accepted **≥1 s confirmed blocked input and nearest eligible worker within 30 m** belong to this narrow evaluator contract. It does not capture GIANTS events, accumulate retry pulses, determine causal obstruction, assess the full Situation or authorize/control workers. Those responsibilities remain distinct.

## One physical worker pair, one candidate occurrence

Native blockage is worker-specific, so in an opposed encounter both workers may independently nominate one another after the same one-second gate. **Those are two observations of the same unordered worker pair, not two independent pair resolutions.** Observation unifies the active pair identity from the two assembly roots; it neither adds another blockage qualification gate nor selects movement roles.

The active occurrence retires when both workers are natively unblocked, either native job or strategy turns over, a participant disappears, the pair leaves the accepted 30 m neighbourhood, or OMW observation stops. A later qualifying encounter may nominate that pair again. This protects future coordinated Control from **competing reciprocal commitments**, without claiming that candidate observation itself grants Control.

## 4. Hold & Relocate — accepted six-stage architecture

**Architectural decision (9 October 2026):** This is the general operational architecture for resolving a worker-to-worker physical blockage. It is the target responsibility after the verified native blocked evidence and pair-candidate identification, **not a claim that current source already controls vehicles**.

1. **Native blockage:** react after GIANTS reports at least **1 second** of confirmed `isBlocked` evidence. Retain the existing one-second gate and the accepted nearest eligible candidate within **30 m** as the present upstream identification policy.
2. **Select a relocating worker:** of the two identified workers, choose the worker whose **current assembly root is nearest to the field centroid** (horizontal X/Z distance). This chooses the relocating participant, whether or not it was the one first reported natively blocked. A tie-breaking mechanism and acquisition of the correct field centroid remain implementation details; do not infer the centroid from the pair midpoint.
3. **Protect egress:** hold **any blocker in the immediate vicinity** for **5 seconds**, starting with the relocation's egress protection, allowing the selected worker to begin moving away. At the end of **5 seconds**, release the blocker Hold **by timer**; do not require that the pair has separated, the obstruction has cleared, or the relocating worker has already completed its move. This is a purpose-bound blocker hold, not a general all-worker freeze. No independent numerical definition of *immediate vicinity* has yet been specified.
4. **Transit and relocation:** **request TRANSIT and immediately start reversing towards the field centroid** for a bounded displacement **≤30 m + offset**, while native raise/fold configuration is still underway. TRANSIT is a non-blocking configuration request; **do not wait for folding, raising or configuration completion, and do not impose a TRANSIT-readiness gate**. The offset's interpretation and computation are not yet specified. This **movement bound is a different quantity from the 30 m pair-selection radius**; do not silently conflate the two. **Control MUST implement reverse driving using the GIANTS-native reversing methodology previously established for Blocked Worker Recovery (BWR)**, not merely a forward steering transform with a reverse gear flag; the exact implementation evidence is recorded below.
5. **Allow blocker continuation:** hold the **relocated worker** for **10 seconds** starting when its bounded relocation ends, allowing the blocker to resume native GIANTS work. On expiry, proceed to native hand-back **by timer** without requiring pairwise separation, native unblocked state, causal-clearance proof or another pair-release gate. This is a distinct hold with a distinct beneficiary and purpose from the 5-second egress hold.
6. **Native hand-back:** **stop the relocated worker's GIANTS AI job and immediately restart it**, returning route choice, productive configuration and continuation to GIANTS. OMW does not reconstruct a productive course or require an exact-axis return.

**Coordination and timed release:** one identified unordered pair is one cooperative resolution, not reciprocal, competing worker manoeuvres. The five-second egress Hold protects the moving worker **concurrently with egress**; it is not a mandatory five-second idle delay before relocation. **Transit Request ≠ Transit Readiness:** command submission and reverse start happen in the same admitted coordination step; native configuration is allowed to continue during movement. This deliberately permits movement with partially raised or folded implements. GIANTS in-game Reality must challenge that physical overlap; successful native requests do not prove clearance or physical configuration. **Hold release is timer-driven only:** the blocker Hold ends at its 5-second expiry and the relocated-worker Hold ends at its 10-second expiry, not at any pair-distance, native-`isBlocked`, geometry, trajectory, post-egress or clearance threshold. The relocation movement itself remains distance-bounded; an invalid job, loss of player consent, disablement or physical inability to continue must still relinquish unsafe authority. These safety/lifecycle exits are **not** alternative pairwise release gates. Neither timed Hold nor immediate restart is evidence that physical clearance has been proved.

**GIANTS-native reverse method — established BWR implementation constraint:** The [GIANTS API surfaces](../docs/engine/GIANTS_API_SURFACES.md) and [GIANTS runtime knowledge](../docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md) document the approved reverse control mechanics, previously realised by [archived `NativeDriveMechanism`](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/scripts/control/mechanisms/NativeDriveMechanism.lua) and [archived BWR Control](https://github.com/bisdat/FS25_OuttaMyWay/blob/archive/0.4.11.0/scripts/control/BlockedWorkerRecoveryControl.lua) (see [issue #336](https://github.com/bisdat/FS25_OuttaMyWay/issues/336)). Control MUST preserve:

- The reverse steering frame from `vehicle:getAIReverserNode()`, **not** the forward `getAISteeringNode()` frame for reverse target conversion.
- Where available, `AIVehicleUtil.getAIToolReverserDirectionNode(vehicle)` and the GIANTS-equivalent **tool-relative lateral/longitudinal target adjustment** for an articulated assembly; then transform the adjusted world target with `worldToLocal` against the vehicle reverser node.
- Native `AIVehicleUtil.driveToPoint()` semantics with `moveForwards=false` and its **local-space target coordinates**, preserving its optional `doNotSteer` input if interposing on an existing native call. A reverse flag alone does **not** reproduce native steering.
- BWR's demonstrated separation of **reverse steering look-ahead** from **authorised movement extent**. The archived BWR used a **40 m Reverse Steering Horizon** for articulated stability: that is a subordinate steering reference, **not** permission to travel 40 m, extend the Hold & Relocate limit of **≤30 m + offset**, or drive to a point beyond the authorised bound.

This is a requirement to reuse the **verified reversing method**, not an instruction to restore the archived BWR architecture wholesale or to choose an interception mechanism before testing. The new centroid-directed target and bounded completion belong to Hold & Relocate, while native reverse geometry belongs to subordinate Control. The precise offset, steering target construction and interface composition still require implementation-facing specification and GIANTS Reality validation.

**Current live admission and its limits:** the server runtime reads GIANTS' active-pair observation but never treats nomination or DEBUG publication as authority. A separate Pair Commitment validates both current native worker jobs, native field-course strategies, player control, the ≥1 s observed pulse, ≤30 m proximity and a common GIANTS field polygon. It derives its area centroid from native world polygon points and currently uses a conservative **zero-metre offset** (maximum 30 m reverse), with no inferred positive allowance. Its immediate blocker set contains the other admitted participant; a wider multi-worker blocker neighbourhood and durable field-geometry bootstrap remain outside this first live implementation. Missing field geometry or native capability means **no relocation**; there is no replacement collision detector. The live adapter binds existing reverse, translation Hold, request-only TRANSIT and immediate FIELDWORK hand-back. Runtime activation is distinct from GIANTS physical validation, which must challenge wrapper composition, reverse trajectories, configuration overlap, stop/start and safe disablement.

**Outstanding implementation-facing questions, not reasons to reopen the accepted principles:** how to obtain the authoritative field centroid, break an exact equidistance tie, identify immediate-vicinity blockers, construct the reverse steering target and offset, and relinquish authority safely on native job changes, player takeover, disablement or movement failure. **Role selection and the two timed Hold releases are decided** and must not be converted into additional pairwise release gates. These require Specifications, source and GIANTS Reality validation in separate increments. Do not promote old 0.4 Passage/Regulation mechanisms to current architecture by default.

## Specification Jurisdiction — Hold & Relocate

**Jurisdiction ID:** `HOLD_RELOCATE`  
**Primary Specification:** [`spec/HOLD_RELOCATE.md`](../spec/HOLD_RELOCATE.md)

This is the implementation-facing boundary for the **existing Hold & Relocate responsibility as a whole**, not a separate jurisdiction inferred from a coordinator module or procedural phase. It coordinates the selected relocating assembly and bounded blocker Holds, delegates native physical actuation to Control, and hands continuation back to GIANTS AI. A candidate pair cannot authorise itself: commitment authority is independently established, then verified at the action boundary. A Control request or successfully invoked native API never alone proves the requested physical outcome; unresolved Hold, movement or job state must remain visible for intervention.

## 5. Keep Situation Assessment and Hold & Relocate responsibility distinct

**Situation Assessment** examines native blockage persistence, present candidate pair proximity and whether a paired response is justified. It can decline intervention when GIANTS is evidently recovering or the blocking pair is unsupported, but **does not require an independently measured physical overlap or GIANTS course advancement**.

Only a downstream, explicitly authorised **Hold & Relocate responsibility** may operate the accepted six-stage sequence. **Relocation selection is centroid-nearest; Hold release is governed by the two fixed 5 s / 10 s timers, with no pairwise release gates; GIANTS-native BWR reversing semantics are mandatory.** The means of acquiring the field centroid, the physical mechanisms, handling additional nearby blockers, bounded movement completion, lifecycle invalidation and the exact offset remain unresolved at implementation-facing detail. A held worker's resulting inactivity must not be counted as fresh evidence of its native inability to progress. GIANTS retains its own productive route and replanning.

## Architectural invariants

- **Native `isBlocked` is authoritative blocked-state evidence**; do not build another blocked-state detector or independently require physical contact proof.
- **1 second confirmed blocked time** is a consideration gate; known unblocked time contributes zero.
- Separate pulses can belong to one unresolved concern; a false edge does not alone mean durable recovery.
- The worker that GIANTS reports blocked is known; **the identity of its blocker is not**.
- After the ≥1 s gate, **the nearest eligible worker at current horizontal assembly-root distance ≤30 m** is the candidate; a worker beyond the radius is not. Simultaneous blocked flags are neither necessary nor sufficient for causal identification.
- Native blockage below the one-second gate produces **no OMW intervention candidate**, regardless of the encounter type; no A8-specific filter or classifier exists.
- The **30 m root-position radius is only for candidate selection**, not an independent physical-clearance or blockage proof. Implement geometry, course progression, agronomic output and trajectory reconstruction are not required.
- Worker/Job Episode changes, player intervention and OMW-imposed control effects invalidate or quarantine prior evidence as appropriate.
- Missing or contradictory evidence remains **WAITING_FOR_EVIDENCE**, not permission to act.

## Reality discriminators

| Case | Expected interpretation | Forbidden assumption |
| --- | --- | --- |
| Ordinary opposed A8 passage with <1 s accumulated confirmed native blockage | Ignore for OMW intervention; no pair inference or special A8 classification | Brief native blocked assertion triggers an A8-specific detection/resolution branch |
| TS015 Condor/Patriot repeatedly report blocked with assembly roots ≤30 m apart | After the one-second gate, nominate the nearest eligible in-radius worker for Situation Assessment | Both workers must be blocked or extra collision geometry is required |
| Worker reports blocked beside a hedge, with an unrelated worker ≤30 m away | The nearest worker is a candidate, not causal proof; Situation Assessment may remain uncertain | Nearest in-radius worker necessarily caused the blockage |
| An in-radius moving worker blocks another but never reports blocked itself | The moving worker can be nominated by proximity | Both require blocked=true |
| Nearest eligible other worker is >30 m away | No worker-pair candidate; do not expand the fixed radius | Choose a remote worker merely because it is nearest |
| Native blocked true/false repeats while one encounter remains unresolved | Count confirmed true intervals, exclude false intervals | Every false edge resets the concern or automatically proves recovery |
| A worker encounters a second distinct obstacle during the same Job Episode | New encounter must not inherit unrelated blocked time | Accumulate every pulse from the entire job indiscriminately |
| GIANTS job stops/restarts, player takes over or evidence is lost | Do not carry stale admission or attribute blocked time without support | Old timer and pair remain authoritative |
| Later authorised OMW Hold causes stationary worker | OMW-induced quiescence must be separated from native blockage | Held inactivity means fresh native blockage |
