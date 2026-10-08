# Blocked-First Situation Assessment — 0.5 Architecture

**Status:** accepted architectural direction and outstanding responsibilities under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). This document records the owner correction that **GIANTS `isBlocked` is the blockage authority**, rather than requiring OuttaMyWay to prove native blockage independently. **TEST 0.5.0.6 remains a control-free shell.** No worker Observation, Situation Assessment, or Control is implemented by this document, and no new Specification Jurisdiction or GIANTS hook is authorised.

## Purpose

OuttaMyWay exists to help a worker resume its GIANTS-owned autonomous activity when native blockage warrants intervention, with the **least disruptive justified response**. GIANTS decides that a worker is blocked. OMW does not duplicate native collision detection or reconstruct GIANTS' fieldwork route.

> **Native `isBlocked` = GIANTS' blocked-state evidence.**
>
> **Blocked-state evidence ≠ identity of blocking partner ≠ automatic authority to intervene.**

This is the architectural separation we need. GIANTS can transiently assert blocked during otherwise successful opposed A8 passage, or alternate blocked and unblocked as it attempts to manoeuvre around a moving worker or static obstacle. These observations are **authentic native states** even when OMW intervention is unnecessary.

[Native Course Advancement](../docs/research/USEFUL_CONTINUATION_EVIDENCE.md) remains completed source research, **not** a required signal, dependency or gate. The physical-obstruction proof step proposed in the initial PR #446 draft is likewise **withdrawn**. **Native Replanning Ownership** remains with GIANTS ([Project Vision](PROJECT_VISION.md)).

## Named evidence and responsibility concepts

| Concept | Architectural meaning | Boundary |
| --- | --- | --- |
| **Native Blockage Edge** | GIANTS reports `isBlocked=true` or `false` for an identifiable worker | Does not identify a causal partner |
| **Native Blockage Pulse** | An interval of positively observed native blocked=true, ending on its known false edge | Not necessarily a distinct obstruction |
| **Unresolved Obstruction Episode** | An evidence-bound blocked/retry concern within one active GIANTS Job Episode, possibly across several pulses associated with the same unresolved encounter | Must not merge unrelated blocked encounters merely because worker/job identity matches |
| **Native Blockage Persistence Gate** | At least **1.000 second of accumulated confirmed blocked time** in one unresolved episode, excluding periods positively observed unblocked | Admits *consideration* only, never automatic hold/relocation |
| **Spatial Pair Inference** | Given a qualifying blocked worker, use current worker positions/proximity to identify a **candidate blocking partner** | The nearby worker need not report blocked; proximity is inference, not cause proof |
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
          yes    v
       Spatial Pair Inference
       (nearby candidate worker)
                 |
                 v
          Situation Assessment
           /       |       \
       no pair   uncertain   plausible pair requiring response?
          |         |               |
          v         v               v
     GIANTS native  WAITING_     separate
      recovery      FOR_        Responsibility /
      remains       EVIDENCE    Pair Commitment
       possible                  (future only)
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

The owner-accepted gate is **≥1 second of accumulated positively confirmed native blocked time** within one unresolved obstruction episode. A false edge closes a *pulse* and prevents time accruing while unblocked; it does **not necessarily** close the unresolved concern. Repeated true/false retries may contribute to the same concern **only while episode continuity is supportable**.

Do not accumulate blocked time across unrelated A8 pass-by events, distinct encounters at different places, new Job Episodes, player takeover, missing/unknown observations or time imposed by OMW's later Control. Positive cessation of the encounter or Job Episode ends its eligibility. Targeted time evaluation may be needed after a true edge with no further notification, but does not imply a continuous all-worker scan.

**The gate is not a physical-obstruction proof step.** It is the agreed safeguard against reacting to fleeting GIANTS native blockage assertions. Reaching it allows a Situation Assessment; it never grants movement authority.

## 3. Infer candidate worker pairs from positions

After a worker satisfies the gate, proximity among in-scope workers is the agreed simple starting point for identifying a candidate blocking partner. **Both workers do not need to report blocked.** There is no need to predict their future courses, invent a collision-geometry stack, measure agronomic progress, or infer how GIANTS would steer next.

`isBlocked` reports the **affected worker**, not the blocker. A nearby worker might be incidental to a hedge/tree blockage. That uncertainty belongs in **Situation Assessment and responsibility selection**, not in an additional physical-collision proof system.

The appropriate spatial proximity boundary and worker/assembly positional representation are still subject to implementation exploration and Reality testing; no universal distance literal or complete geometric collision model is adopted. When a candidate cannot be identified reliably, remain **WAITING_FOR_EVIDENCE** or leave GIANTS to self-recover rather than inventing attribution.

## 4. Keep Situation Assessment and Pair Commitment distinct

**Situation Assessment** examines native blockage persistence, present candidate pair proximity and whether a paired response is justified. It can decline intervention when GIANTS is evidently recovering or the blocking pair is unsupported, but **does not require an independently measured physical overlap or GIANTS course advancement**.

Only a later, explicitly justified **Pair Commitment** may hold one participant while the other relocates. The pair's roles, required movement, third-worker interactions, safe completion, release timing, and hand-back evidence remain separate open responsibilities. A held worker's resulting inactivity must not be counted as fresh evidence of its native inability to progress. GIANTS retains its own productive route and replanning.

## Architectural invariants

- **Native `isBlocked` is authoritative blocked-state evidence**; do not build another blocked-state detector or independently require physical contact proof.
- **1 second confirmed blocked time** is a consideration gate; known unblocked time contributes zero.
- Separate pulses can belong to one unresolved concern; a false edge does not alone mean durable recovery.
- The worker that GIANTS reports blocked is known; **the identity of its blocker is not**.
- Proximity supplies a candidate partner; simultaneous blocked flags are neither necessary nor sufficient for causal identification.
- Transient opposed A8 passing and legitimate GIANTS self-recovery must not automatically trigger pair control.
- No observed physical separation distance, course progression, agronomic output, predicted trajectory or obstacle reconstruction is an extra mandatory prerequisite to trusting the native blocked flag.
- Worker/Job Episode changes, player intervention and OMW-imposed control effects invalidate or quarantine prior evidence as appropriate.
- Missing or contradictory evidence remains **WAITING_FOR_EVIDENCE**, not permission to act.
- Current TEST 0.5.0.6 source still provides **no worker observation or control**.

## Reality discriminators

| Case | Expected interpretation | Forbidden assumption |
| --- | --- | --- |
| Adjacent opposed A8 workers briefly report blocked and pass safely | Native transient pulse; no automatic response before the gate | Every native blocked assertion means OMW must move someone |
| TS015 Condor/Patriot repeatedly report blocked while close | If the one-second gate and pair assessment support it, **consider** a coordinated pair response | Both workers must be blocked or extra collision geometry is required |
| Worker reports blocked beside a hedge with another worker nearby | GIANTS confirms blockage; pair attribution may be uncertain | Closest worker is necessarily its blocker |
| One moving worker blocks another but never reports blocked itself | A candidate pair remains possible by proximity | Both require blocked=true |
| Native blocked true/false repeats while one encounter remains unresolved | Count confirmed true intervals, exclude false intervals | Every false edge resets the concern or automatically proves recovery |
| A worker encounters a second distinct obstacle during the same Job Episode | New encounter must not inherit unrelated blocked time | Accumulate every pulse from the entire job indiscriminately |
| GIANTS job stops/restarts, player takes over or evidence is lost | Do not carry stale admission or attribute blocked time without support | Old timer and pair remain authoritative |
| Later authorised OMW Hold causes stationary worker | OMW-induced quiescence must be separated from native blockage | Held inactivity means fresh native blockage |

## Authority Triad / current disposition

**Architecture:** blocked-first Situation Assessment uses GIANTS native blocked signals, persistence and spatial pair inference; no separate physical-obstruction proof stage or GIANTS course-progress gate.

**Specification:** current Configuration and Log Publication contracts remain unchanged. No worker Observation, Situation Assessment, Pair Commitment or Control primary Specification has yet been authorised.

**Source:** TEST 0.5.0.6 remains a control-free eight-file shell. `NativeBlockedEventTap.lua` remains retired. No worker scan, native hook, course-progress tracker or actuation is introduced here.

**Testing:** this is an Architecture correction, not executable behaviour. TEST 0.5.0.6's owner-waived smoke is not an in-game PASS. Any eventual new worker Observation or Control needs independent Reality validation.

**Unresolved in [#440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440):** stable native edge collection, bounded continuity across retries, the appropriate proximity policy for candidate pairs, uncertainty when a nearby worker is incidental, and the separate authority/settlement contract for Pair Commitment. **Independent physical-collision proof and native course advancement are not required work packages.**
