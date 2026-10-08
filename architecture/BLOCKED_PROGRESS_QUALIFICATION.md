# Native Blockage and Physical Obstruction Assessment — 0.5 Architecture

**Status:** accepted architectural direction and remaining evidence questions under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). This document supersedes the earlier proposal to make *failed GIANTS course/useful-work advancement* a prerequisite for intervention. **The TEST 0.5.0.6 shell does not implement worker Observation, Situation Assessment or Control.** No worker Specification Jurisdiction or GIANTS hook is authorised by this document.

## Purpose and governing principle

OuttaMyWay exists to resolve **local physical obstructions** to GIANTS-owned autonomous work through the **least disruptive justified intervention**. It does **not** have to know how GIANTS advances through its planned fieldwork route, nor prove agronomic or course progress before examining a physical obstruction. [Native Replanning Ownership](PROJECT_VISION.md) remains GIANTS' responsibility.

> **Native Blocked Assertion ≠ Persistent Physical Obstruction ≠ Authority to Intervene.**

GIANTS may report native blockage during safe adjacent passage or manoeuvre around a hedge/tree, briefly unblock as a moving worker passes, or turn/reverse to negotiate an obstruction. Legitimate native manoeuvring is welcome. OMW's question is not whether GIANTS has completed the next course segment, but **whether a relevant physical obstruction remains and warrants cooperative intervention**.

The completed [Native Course Advancement research](../docs/research/USEFUL_CONTINUATION_EVIDENCE.md) is retained as historical/optional corroborating knowledge. **It is not a prerequisite, admission gate, timer reset rule or critical-path subsystem.** Do not reconstruct GIANTS trajectories, segment identities, work quality, route advancement or progress percentages for this purpose.

## Named concepts and boundaries

| Concept | Architectural meaning | Does not prove |
| --- | --- | --- |
| **Native Blockage Edge** | GIANTS-produced change in a particular worker's blocked state to true or false | Cause, duration by itself, physical relationship, or OMW responsibility |
| **Native Blockage Pulse** | A known blocked=true interval for that worker, bounded by a matching false edge where observed | A distinct obstruction; failure of native self-recovery |
| **Unresolved Obstruction Episode** | Evidence-bound continuity of the **same suspected physical obstruction** for the same active GIANTS Job Episode, possibly over repeated blocked/unblocked pulses | All pulses in a job are necessarily related |
| **Native Blockage Persistence Gate** | At least **1.000 s accumulated positively confirmed blocked time** for that unresolved obstruction, excluding time known unblocked | Physical cause, automatic intervention or a required course-progress measurement |
| **Spatial Pair Inference** | From a qualifying blocked worker, use known worker positions/proximity to identify plausible neighbouring worker blockers | Collision attribution or certainty that a neighbour caused the problem |
| **Physical Obstruction Assessment** | Determine whether a **current, relevant physical obstruction** is supported and whether it still obstructs the worker, distinguishing plausible worker-pair and single-worker obstruction contexts | Permission to hold, stop, relocate or restart |
| **Pair Commitment** | **Downstream** coordinated responsibility: once justified, hold one participant while the other relocates, then verify physical clearance and relinquish control to GIANTS | An automatic consequence of the native blocked flag or the 1-second gate |

A blocking worker may itself be moving and never report blocked. Two simultaneous native blocked flags do not prove a blocking pair. A nearby worker may be entirely incidental to a hedge/tree obstruction.

## Architectural flow

```text
GIANTS-owned active Job Episode + blocked/unblocked evidence
                             |
                             v
       Native Blockage Pulses / Unresolved Obstruction Episode
                             |
                             v
  >= 1.000 s confirmed blocked time in that unresolved obstruction
                             |
                             v
                 Spatial Pair Inference
              (nearby candidate workers)
                             |
                             v
                Physical Obstruction Assessment
                   /         |         \
      physically clear?   uncertain?   relevant obstruction supported?
            |                |                 |
            v                v                 v
  retire obstruction   WAITING_FOR_EVIDENCE   consider responsibility
   GIANTS continues       GIANTS owns         without auto-actuation
                           continuation            |
                                                   v
                                     Pair Commitment (future)
                                    hold one / relocate other
                                                   |
                                                   v
                                  verify physical clearance
                                  release to GIANTS continuation
```

These are **responsibilities and evidence/authority separations**, not a mandatory sequential update loop. Single-worker encounters with static obstacles may require their own Situation/Responsibility analysis rather than pair commitment. Passing the gate and being near another worker do **not** together prove the pair caused the obstruction.

### 1. Observe native blockage without taking control

Prefer native blocked/unblocked **edges** to continuous 500 ms fleet-wide blocked-state polling. The retired TEST 0.5.0.5 [event-construction experiment](../docs/research/NATIVE_BLOCKED_EVENT_TAP.md) demonstrated true and false edges in FS25 1.24.0.0, including a 174 ms pulse. Its global event-constructor wrapper is **retired** and was not validated as a general safe public subscription API. Do not restore it automatically.

Observation must respect worker identity, active Job Episode, source authority and uncertain/missed events. A continuing blocked=true state may have no further edge, so future assessment may require **targeted elapsed-time evaluation of that known pulse**, not repeated sampling of every worker. Unknown intervals must not be credited as confirmed blocked time.

### 2. Keep physical obstruction continuity separate from signal pulses

A native false edge **ends one pulse**, not necessarily the **Unresolved Obstruction Episode**. If the same physical obstruction credibly persists while GIANTS briefly retries, retain that episode. Accumulate **only positively confirmed blocked time** within it and exclude known unblocked intervals. Native fluctuations do not reset the concern by themselves.

Do not join unrelated A8 passes, different worker identities, different Job Episodes, unrelated physical sites, or time under later OMW-imposed Hold. Positive physical separation/clearance, worker departure from the obstructed context, verified cessation of the relevant Job Episode or player takeover can terminate or invalidate an obstruction concern. Mere distance travelled, a false edge, or course progress percentage do not independently certify clearance.

**Unresolved evidence question:** what *minimum positive physical evidence* is enough to link pulses to the same obstruction or establish that it has cleared? The current research does not justify a universal metre, time or footprint literal; uncertainty remains **WAITING_FOR_EVIDENCE**, not manufactured continuity or premature clearance.

### 3. Assess the physical relationship, not GIANTS route advancement

Once the owner-agreed one-second **consideration gate** is met, use **Spatial Pair Inference** to find nearby worker candidates. Then **Physical Obstruction Assessment** distinguishes:

- **Plausible continuing worker-to-worker obstruction:** a nearby worker may be physically blocking another; the blocking worker need not report blocked.
- **Transient safe passage/clearing:** workers may be in proximity while already passing, moving clear or physically separated, even if a blocked edge occurred.
- **Single-worker obstruction and native manoeuvring:** GIANTS may legitimately reverse, turn, raise an implement or seek its own route past a static obstacle. Do not treat those behaviours as failures simply because there is no productive agronomy or course advancement.
- **Incidental proximity / incomplete evidence:** a worker beside a hedge-blocked tractor is not automatically its blocker. Missing geometry, uncertain cause or stale positions prevent confident attribution.

Current relative **physical position, proximity, separation and clearance** are the relevant evidence questions. The exact reliable observation surfaces and threshold/assembly representation policy require subsequent implementation investigation and Reality validation. No predicted course intersection, GIANTS route model or fixed clearance rule is adopted here.

### 4. Separate assessment from Pair Commitment

Only after an obstruction is supported and the downstream Responsibility decision is justified may a **Pair Commitment** impose temporary coordination: **one worker held while the other relocates**. Who moves, who holds, how far, how GIANTS hands back, third-worker protection, fail-safe exits and physical clearance verification remain separate unimplemented responsibilities.

The one-second gate is **not** permission to actuate. OMW-caused zero movement during any later Hold is not evidence of native failure. Clearance and legitimate release must be verified, with GIANTS retaining productive route and replanning ownership.

## Evidence/lifecycle invariants

- A native blocked message is an observation, never an instruction to OMW.
- **≥1.000 s accumulated confirmed blocked time** admits *assessment*, not intervention. Unblocked intervals add zero.
- Separate pulses belong to one obstruction only when that link has support; **same Job Episode alone is not sufficient**.
- A native false event is not sufficient physical-clearance evidence. Positive physical clearance can dissolve concern without a native course-progress witness.
- Nearby worker proximity does not prove causation; neither worker must necessarily report blocked simultaneously.
- Physical movement, turning/reversing, work-line activity, native segment percentage and agronomic progress are **not mandatory evidence** for this responsibility.
- GIANTS remains entitled to attempt self-recovery; do not force OMW intervention during legitimate clearing.
- Missing/ambiguous evidence, stale identities, source-job changes, player intervention and control-caused effects preserve uncertainty or invalidate prior authority; never fabricate certainty.
- No current shell source installs native hooks, scans workers, claims Control or performs any of these proposed responsibilities.

## Adversarial Reality discriminators

| Scenario | Assessment question | Prohibited shortcut |
| --- | --- | --- |
| TS015 adjacent opposed A8 workers pass safely | Have they physically separated / cleared without OMW? | "Native blocked=true requires relocation" |
| TS015 opposed Condor/Patriot repeatedly obstruct one another | Is there still a physically relevant worker pair after repeated pulses? | "Both blocked flags prove causality" |
| A worker reverses/turns around a hedge | Is native self-recovery clearing the physical obstacle? | "No work/course progress means recovery failed" |
| A worker happens to be near a hedge-blocked worker | Is the neighbour actually physically implicated? | "Closest worker caused the obstruction" |
| Worker moves briefly, native blocked clears, and the same blockage recurs | Does the original physical relationship remain? | "One false edge proves resolution" |
| Same worker encounters two different obstacles in one Job Episode | Is this a **new** physical obstruction episode? | "Accumulate all blocked time for the whole job" |
| Player enters, native job restarts or a blocked edge is lost | Is evidence still valid under current ownership? | "Retain a previous actionable verdict" |
| Future OMW Hold creates zero worker motion | Is OMW itself imposing that state? | "Stationary means GIANTS was blocked" |

## Authority Triad and remaining questions

**Architecture (this document):** the critical path is now **native blockage persistence → spatial pair inference → physical obstruction assessment → separate Responsibility/Pair Commitment**, not GIANTS course advancement. The broader [Project Vision](PROJECT_VISION.md) is unchanged.

**Specification:** current 0.5 Configuration and Log Publication Specifications remain unchanged. No primary worker-Observation, physical-obstruction, Pair Commitment or Control Specification is yet authorised; do not author a placeholder simply because a concept has been named.

**Source:** TEST **0.5.0.6** remains the control-free product shell; the event tap, worker scanner, course-progress tracker, Pair Commitment and worker movement are absent. No runtime changes accompany this Architecture decision.

**Testing:** the previous 0.5.0.6 post-retirement smoke was **waived by the owner**, not recorded as a PASS; no new executable behaviour arises from this document. Any eventual worker observation/decision/control requires its own offline and GIANTS Reality tests.

**Open questions in [#440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440):** what establishes positive *physical obstruction and clearance*, how to associate blocked pulses with the same physical obstruction, what proximity/representation is sufficient to identify a plausible pair without confusing incidental neighbours, and how to receive GIANTS native blocked edges safely. **Native course-segment identity/progression is not on the critical path.**
