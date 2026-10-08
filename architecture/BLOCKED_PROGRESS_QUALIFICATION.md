# Blocked Progress Qualification — 0.5 Architecture

**Status:** accepted conceptual boundaries and open architectural questions, developed under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). **No worker Observation, assessment or Control is implemented by TEST 0.5.0.6.** This document establishes what OuttaMyWay must understand before seeking control; it is **not yet a declared Specification Jurisdiction** or permission to implement a GIANTS hook.

## Purpose and governing principle

GIANTS owns autonomous fieldwork and may encounter native blocked assertions while it continues its own attempts to work or manoeuvre. OuttaMyWay should intervene only when evidence justifies helping autonomous work continue; it must not interpret a momentary GIANTS blocked assertion as a command to take over.

The [Project Vision](PROJECT_VISION.md) requires the *least disruptive justified intervention* and preserves **Native Replanning Ownership**. For the blocked-first rewrite, the key distinction is:

> **Native Blocked Assertion ≠ Failed Useful Continuation ≠ Responsibility to Intervene.**

**Useful Continuation** includes legitimate GIANTS manoeuvring that advances the job toward completion, even when that movement temporarily performs no productive agronomy. Pure physical displacement does not prove useful continuation; nor does a low speed, temporary work interruption or native unblocked event prove its absence or success.

## Named evidence concepts

| Concept | Architectural meaning | Does not establish |
| --- | --- | --- |
| **Native Blockage Edge** | GIANTS-produced observation of the blocked state changing to true or false for an identifiable worker | A causal obstacle, failed continuation, or OMW authority |
| **Native Blockage Pulse** | A worker's positively observed blocked=true interval, bounded by a matching false edge when available | A standalone unresolved obstruction or permanent failure |
| **Unresolved Obstruction Episode** | A continuity hypothesis that a *specific active GIANTS Job Episode* still faces an unrelieved obstruction, potentially across multiple native pulses and GIANTS retry manoeuvres | That every pulse in the Job Episode is the same obstruction |
| **Native Blockage Persistence Gate** | At least **1.000 s** of accumulated **confirmed blocked time** within the *same unresolved obstruction*, excluding observed unblocked periods | Immediate intervention; a specific blocker; failed useful continuation |
| **Blocked Progress Qualification** | Assessment of whether GIANTS has failed to achieve *useful continuation* despite its own efforts | Control of the worker or confirmation of who is responsible |
| **Spatial Pair Inference** | A candidate worker-to-worker causal relationship inferred from physical proximity to a qualifying blocked worker | Collision identity or responsibility certainty |
| **Pair Commitment** | A later, explicit cooperative resolution in which one worker is held while the other relocates and GIANTS resumes | An activity of native-state Observation or an obligation implied by a blocked flag alone |

A worker may be blocking another without itself reporting blocked. Conversely, two workers reporting blocked simultaneously need not be blocking each other. A nearby worker may be incidental to a hedge or other static obstruction.

## Architectural separation of responsibilities

```text
GIANTS-owned job and native blocked/unblocked evidence
        |
        v
Observation: worker identity + current Job Episode + native edges
        |
        v
Native Blockage Pulses
        |
        v
Unresolved Obstruction Episode (only while evidentially supportable)
        |
        v
>= 1.000 s confirmed-blocked-time gate
        |
        v
Blocked Progress Qualification: failed useful continuation?
        |
        +---- Positive useful continuation ------> retire concern; GIANTS continues
        |
        +---- Evidence insufficient -------------> WAITING_FOR_EVIDENCE
        |
        +---- Qualification supported
                        |
                        v
              Situation Assessment
               /             \
     Spatial Pair Inference   Single-worker obstruction
               |              (allow native retry while useful)
               v
     possible Pair Commitment
        (one held; one relocated)
               |
               v
     verify clearance / release / GIANTS-owned continuation
```

The ordering establishes distinct **evidence**, **interpretation** and **authority** boundaries, not mandatory sequential code execution. A later implementation may observe native progress concurrently, but may not collapse the gate, qualification and responsibility into one boolean. Any downstream Control action requires its own Architecture and Specification.

### 1. Observe without governing GIANTS

The preferred *candidate input direction* is **event-driven native blocked/unblocked observation**, not continuous fleet-wide 500 ms blocked-state polling. The historic [0.5.0.5 event-construction research](../docs/research/NATIVE_BLOCKED_EVENT_TAP.md) observed true and false GIANTS events (including one 174 ms pulse) in FS25 1.24.0.0. Its global constructor wrapper was retired in TEST 0.5.0.6.

**Architecture does not make that wrapper a public subscription API.** The exact non-invasive Observation interface, complete edge coverage and coexistence with other mods have not been established. Missing or out-of-order edges invalidate duration assumptions rather than authorise reconstruction of unobserved intervals.

A continuing true edge may produce no further notifications. A future observer therefore requires some **targeted time evaluation** of pending evidence; this need does *not* imply scanning all workers every 500 ms. Observation remains passive and must not call GIANTS strategy computation to 'discover' the next instruction.

### 2. Persist the right thing, for no longer than justified

A true edge begins or confirms a **Native Blockage Pulse**; a matching false edge ends the *pulse* and stops accruing blocked time. The false edge **alone** does not prove useful continuation or end the higher-level **Unresolved Obstruction Episode**.

When successive pulses are sufficiently evidenced as belonging to the **same unresolved obstruction**, only their positively observed blocked durations may accumulate. No time spent known unblocked counts toward the gate. **The 1-second limit is an owner-accepted minimum admissibility condition**, never an expiry timeout or automatic Intervention trigger.

Do **not** accumulate unrelated transient A8 encounters, different Job Episodes, worker identity changes, unobserved time, stale observation after player takeover, or time caused by a later OMW-imposed hold. **Job Episode succession** or positive termination invalidates inherited admission state. Positive resumed useful continuation retires the concern, even if a prior pulse satisfied the gate. When linkage/identity/progress evidence is insufficient, preserve **WAITING_FOR_EVIDENCE** rather than either resetting all history by convenience or carrying it forward as unquestioned truth.

**Still unresolved:** the minimal positive evidence that establishes *same unresolved obstruction* across pulses, and the minimal positive evidence that GIANTS has independently resumed useful continuation. These cannot be derived from edges alone.

### 3. Qualify failed continuation independently of the timer

The accepted question is whether GIANTS is **actually failing to progress toward completion**, not whether it is stationary, reports blocked, or has ceased agronomy for an arbitrary interval. Native turns, reverses, temporary manoeuvres and obstacle avoidance are eligible forms of legitimate continuation.

Assess useful continuation using **positively interpretable current-job evidence**. Position and movement are available in principle; GIANTS field-course segment progress and work state are possible corroborators, but their representativeness for all manoeuvres and worker types is not proven. No invented universal metre, speed, time or course-progress threshold belongs to this Architecture.

Until the evidence is qualified, even a 1-second-gated worker remains in **WAITING_FOR_EVIDENCE**, or is classified as native continuation when positive continuation is seen; it is not automatically 'failed'.

### 4. Infer situation before any resolution

Once a blocked worker passes the gate and its lack of useful continuation is supported, **Spatial Pair Inference** considers other in-scope worker positions. Proximity is the owner's agreed starting point; no predictive route stack, collision-geometry reconstruction or GIANTS course ownership is required to name a **candidate pair**.

Proximity does not alone prove causation. A nearby unrelated worker can coincide with a hedge-blocked worker. If a pair cannot be supported, maintain uncertainty or consider single-worker obstruction on its own evidence. For a positively established pair that justifies cooperative intervention, the owner-agreed downstream architectural intent is: **hold one participant while the other relocates**; verify clearance and relinquish authority to GIANTS. The hold is *part of Pair Commitment*, not part of the blocked-evidence detector.

Which worker holds, how it relocates, bounded authority, third-party interaction, actual clearance and return-to-GIANTS settlement remain distinct unanswered design questions. They must not be implemented opportunistically in Blocked Progress Qualification.

## Evidence and lifecycle invariants

- A native blocked signal is **evidence**, not a GIANTS-requested instruction for OMW.
- The **1.000 s** gate admits *further assessment* only; it is not an intervention deadline or proof of useful-progress failure.
- Positive, known-unblocked periods contribute **zero** blocked time.
- Same-worker and same-active-Job-Episode identity are necessary but **not sufficient** to assert that separated pulses belong to the same obstruction.
- A false edge closes a blockage pulse; it does **not** alone prove independent continuation.
- Any evidence generated by OMW's own later Hold must be causally isolated from GIANTS' original obstruction.
- Player intervention, job stop/restart, lost observations, changed authority and uncertain episode identity must **not silently preserve an actionable conclusion**.
- No current shell module may install a native hook, scan workers or control GIANTS merely because these concepts are documented.

## Adversarial Reality discriminators

| Scenario | Evidence interpretation required | Premature conclusion prohibited |
| --- | --- | --- |
| TS015 opposed adjacent A8 passes without intervention | Brief native blocked assertions followed by useful autonomous continuation | 'Blocked = relocate'; timed passage alone proves deadlock |
| TS015 Condor/Patriot blocking pair | Repeated native pulses, deficit of useful continuation, proximate candidate pair | 'Two blocked flags prove one must hold' |
| Single worker navigating a hedge or static obstacle | Native oscillation can coexist with legitimate self-recovery | 'Oscillation proves a pair or failure' |
| Another worker is near the hedge-blocked worker | Possible coincidental proximity | 'Closest worker caused blocked state' |
| GIANTS legitimately reverses/turns, then resumes | Temporary non-productive motion can be useful continuation | 'No current agronomy = failure' |
| Job ends/restarts or player takes control during a pulse | Invalidate or quarantine stale evidence and responsibility assumptions | 'Old blocked time transfers to new authority' |
| False edge never arrives, observation hook unavailable | Bounded epistemic uncertainty and lifecycle verification | 'Worker remains blocked indefinitely' |
| OMW later holds one member of an authorised pair | OMW-generated quiescence is a Control effect | 'Held vehicle confirms native deadlock' |

## Implementation / validation disposition

**Current source:** TEST 0.5.0.6 is a **control-free shell**. The former native event tap was deliberately retired after research. This document adds no source file and no periodic worker scan.

**Specification:** no worker Observation, Blocked Progress Qualification, Situation Assessment or Pair Commitment **Specification Jurisdiction** is yet mature enough to declare a primary normative contract. The eventual contracts must wait for a minimal positive useful-continuation evidence model and a safe native event-observation seam. Existing Configuration and Log Publication Jurisdictions are not changed.

**Testing:** these discriminators are architectural bench cases. Historical 0.5.0.5 logs support true/false event-construction evidence in one GIANTS game build, not end-to-end coverage, job continuity, safe hook interoperability or the validity of any future intervention. An eventual implementation requires separate offline and GIANTS Reality tests. The owner explicitly **waived the 0.5.0.6 retirement smoke**, which is not an in-game PASS and does not waive future tests for new worker features.

**Open decisions for #440:** how to positively recognise useful continuation without reconstructing GIANTS routes; how to corroborate same-obstruction continuity across retry pulses; what positional proximity evidence makes a pair merely plausible versus sufficient to commit; and how to establish a safe source of native edges without reintroducing the retired experiment as a permanent observer.
