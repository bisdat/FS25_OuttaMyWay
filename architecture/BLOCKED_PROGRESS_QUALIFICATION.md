# Blocked-First Situation Assessment — 0.5 Architecture

**Status:** accepted architectural direction and outstanding responsibilities under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). This document records the owner correction that **GIANTS `isBlocked` is the blockage authority**, rather than requiring OuttaMyWay to prove native blockage independently. **TEST 0.5.0.6 remains a control-free shell.** No worker Observation, Situation Assessment, or Control is implemented by this document, and no new Specification Jurisdiction or GIANTS hook is authorised.

## Purpose

OuttaMyWay exists to help a worker resume its GIANTS-owned autonomous activity when native blockage warrants intervention, with the **least disruptive justified response**. GIANTS decides that a worker is blocked. OMW does not duplicate native collision detection or reconstruct GIANTS' fieldwork route.

> **Native `isBlocked` = GIANTS' blocked-state evidence.**
>
> **Blocked-state evidence ≠ identity of blocking partner ≠ automatic authority to intervene.**

This is the architectural separation we need. Ordinary opposed A8 passing is expected to produce **less than one second of confirmed GIANTS blockage**, so the existing persistence gate filters it **without an A8 classifier**. GIANTS can also alternate blocked/unblocked while attempting to manoeuvre around a moving worker or static obstacle. These are authentic native states, not automatic intervention requests. The A8 duration is a working scenario assumption, not a universally demonstrated bound.

[Native Course Advancement](../docs/research/USEFUL_CONTINUATION_EVIDENCE.md) remains completed source research, **not** a required signal, dependency or gate. The physical-obstruction proof step proposed in the initial PR #446 draft is likewise **withdrawn**. **Native Replanning Ownership** remains with GIANTS ([Project Vision](PROJECT_VISION.md)).

## Named evidence and responsibility concepts

| Concept | Architectural meaning | Boundary |
| --- | --- | --- |
| **Native Blockage Edge** | GIANTS reports `isBlocked=true` or `false` for an identifiable worker | Does not identify a causal partner |
| **Native Blockage Pulse** | An interval of positively observed native blocked=true, ending on its known false edge | Not necessarily a distinct obstruction |
| **Unresolved Obstruction Episode** | An evidence-bound blocked/retry concern within one active GIANTS Job Episode, possibly across several pulses associated with the same unresolved encounter | Must not merge unrelated blocked encounters merely because worker/job identity matches |
| **Native Blockage Persistence Gate** | At least **1.000 second of accumulated confirmed blocked time** in one unresolved episode, excluding periods positively observed unblocked | Admits *consideration* only, never automatic hold/relocation |
| **Spatial Pair Inference** | After the native one-second gate, nominate the **nearest other eligible worker within 30 m horizontal X/Z root-to-root distance** | This approximate position-based candidate need not report blocked and is not proven causal |
| **Situation Assessment** | Decide whether the native blocked condition and plausible worker relationship justify **considering a cooperative response**, or whether to leave GIANTS to recover / await evidence | Does **not** independently prove GIANTS' collision or blocked state |
| **Pair Commitment** | Separate downstream responsibility, when justified: **hold one participant while the other relocates**, then hand back to GIANTS | Does not follow automatically from the gate or proximity |

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
                                       (future only)
                                            |
                                            v
                                  hold one / relocate other
                                  relinquish to GIANTS
```

The diagram names separate responsibilities, **not** obligatory serial code or an invitation to implement a second obstruction detector. A single-worker obstruction to a tree/hedge remains a different situation from a worker-to-worker pair; a pair cannot be invented from the blocked flag alone.

## 1. Trust GIANTS for the blocked state

GIANTS' `isBlocked` is the input authority. There is no need for OuttaMyWay to recreate the native collision system, calculate a contact overlap, classify hedge versus worker from a separate obstacle detector, or independently prove physical obstruction before accepting a native blocked assertion.

Native `false` means GIANTS ceased reporting blocked **at that instant**. It does not prove that a temporarily moving neighbour will not obstruct again. Conversely, native `true` is not proof that GIANTS' own manoeuvres will fail or that OMW should act immediately.

The preferred *candidate observation direction* is native **blocked/unblocked edge-driven evidence**, not indiscriminate 500 ms scanning of all workers. [TEST 0.5.0.5 research](../docs/research/NATIVE_BLOCKED_EVENT_TAP.md) observed both directions, including a 174 ms pulse, in FS25 1.24.0.0. The experimental global constructor hook was **retired** in TEST 0.5.0.6; it is **not** a verified public subscription and must not be restored merely because a signal contract has been described.

## 2. Filter transient native blockage with the accepted persistence gate

The owner-accepted gate is **≥1 second of accumulated positively confirmed native blocked time** within one unresolved obstruction episode. **Below 1 second, OMW ignores the blockage for intervention purposes: no Spatial Pair Inference, Situation Assessment or resolution candidate.** A false edge closes a *pulse* and prevents time accruing while unblocked; it does **not necessarily** close the unresolved concern. Repeated true/false retries may contribute to the same concern **only while episode continuity is supportable**.

Do not accumulate blocked time across unrelated passing encounters, distinct obstacles at different places, new Job Episodes, player takeover, missing/unknown observations or time imposed by OMW's later Control. Positive cessation of the encounter or Job Episode ends its eligibility. Targeted time evaluation may be needed after a true edge with no further notification, but does not imply a continuous all-worker scan.

**The gate is not a physical-obstruction proof step.** It already filters the expected short native assertions during ordinary opposed A8 passing; **no A8 recognition, classification, special distance, or dedicated exemption is required**. If ordinary successful passing later proves to generate ≥1 second of accumulated confirmed blockage, that challenges the duration assumption and should be recorded as Reality evidence—not pre-emptively patched with A8 logic. Reaching the gate allows generic Situation Assessment; it never grants movement authority.

## 3. Infer candidate worker pairs from positions

After a worker satisfies the gate, **choose the nearest other eligible local worker with a current assembly-root position within a 30-metre radius of the blocked worker's assembly root**, comparing horizontal **X/Z** coordinates. Deduplicate the root assemblies and exclude the blocked assembly itself. **The threshold is radius 30 m (distance ≤30 m), not diameter.** If there is no eligible worker in that radius, **there is no worker-pair candidate**; do not select a remote worker because it is the nearest available. **The candidate blocker need not report blocked.** The owner accepts this deliberately approximate root-position rule without implement geometry, clearance or route reconstruction.

`isBlocked` reports the **affected worker**, not the blocker. A nearby worker might be incidental to a hedge/tree blockage. That uncertainty belongs in **Situation Assessment and responsibility selection**, not in an additional physical-collision proof system.

**The 30 m radius is the owner-selected locality policy**, not an empirical physical-clearance or causal-contact threshold. No implement-width correction, vehicle-specific radius, collision hull, trajectory prediction or geometric precision is required. An in-radius worker is a *possible* blocker, not a proven one. If there is no candidate, do not invent a worker pair; where eligibility or attribution is uncertain, Situation Assessment may remain **WAITING_FOR_EVIDENCE**. Re-evaluate current positions/authority before any later Pair Commitment.

## Specification Jurisdiction — Spatial Pair Inference

**Jurisdiction ID:** `SPATIAL_PAIR_INFERENCE`  
**Primary Specification:** [`spec/SPATIAL_PAIR_INFERENCE.md`](../spec/SPATIAL_PAIR_INFERENCE.md)

Only the accepted **≥1 s confirmed blocked input and nearest eligible worker within 30 m** belong to this narrow evaluator contract. It does not capture GIANTS events, accumulate retry pulses, determine causal obstruction, assess the full Situation or authorize/control workers. Those responsibilities remain distinct.

## 4. Keep Situation Assessment and Pair Commitment distinct

**Situation Assessment** examines native blockage persistence, present candidate pair proximity and whether a paired response is justified. It can decline intervention when GIANTS is evidently recovering or the blocking pair is unsupported, but **does not require an independently measured physical overlap or GIANTS course advancement**.

Only a later, explicitly justified **Pair Commitment** may hold one participant while the other relocates. The pair's roles, required movement, third-worker interactions, safe completion, release timing, and hand-back evidence remain separate open responsibilities. A held worker's resulting inactivity must not be counted as fresh evidence of its native inability to progress. GIANTS retains its own productive route and replanning.

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
- Current TEST 0.5.0.6 source still provides **no worker observation or control**.

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

## Authority Triad / current disposition

**Architecture:** blocked-first Situation Assessment uses GIANTS native blocked signals, persistence and spatial pair inference; no separate physical-obstruction proof stage or GIANTS course-progress gate.

**Specification:** Configuration and Log Publication remain unchanged. The narrow Spatial Pair Inference Specification covers only a pure candidate evaluator. Worker Observation, broader Situation Assessment, Pair Commitment and Control are still unimplemented.

**Source:** TEST 0.5.0.7 includes an inert, pure Spatial Pair Inference evaluator. No GIANTS worker observation, event hook, caller, scan, pair actuation or course-progress tracker is introduced; the native event tap stays retired.

**Testing:** Offline evidence can validate pure numeric gate/selection logic only. TEST 0.5.0.6's owner-waived smoke is not an in-game PASS. Any eventual native Observation or Control needs separate GIANTS Reality validation.

**Unresolved in [#440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440):** stable native edge collection, bounded continuity across retries, candidate eligibility and uncertainty when the nearest in-radius worker is incidental, and separate Pair Commitment authority/settlement. **The proximity radius is settled by owner decision at 30 m**, with its practical effectiveness subject to future Reality rather than speculative geometric refinement. **Independent physical-collision proof and native course advancement are not required work packages.**
