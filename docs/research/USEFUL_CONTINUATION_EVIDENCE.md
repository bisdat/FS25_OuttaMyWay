# Useful Continuation Evidence — Native Course Advancement Source Study

**Disposition (owner decision, 8 October 2026):** Research retained, but **Native Course Advancement is removed from the critical path for physical obstruction detection and resolution**. OuttaMyWay need not measure GIANTS route/segment advancement to determine whether a physical obstruction persists. The study remains historical/optional corroborating source knowledge, not a requirement, gate, Specification, or implementation instruction.

**Research status:** Source-and-existing-Reality investigation for [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). **Not a validated progress-detector contract, current Architecture decision, or implementation authority.** The governing [Blocked Progress Qualification Architecture](../../architecture/BLOCKED_PROGRESS_QUALIFICATION.md) is already on main through PR #444. TEST 0.5.0.6 remains an eight-script **control-free shell**, with no worker Observation and with owner-waived smoke (not an in-game PASS).

## Question and scope

What is the *minimum positive evidence* that a GIANTS field worker has **usefully continued its own active Job Episode**, as distinct from moving, repeatedly trying to escape an obstruction, performing agronomy, or merely reporting `nativeBlocked=false`?

We are exploring **Native Course Advancement**: positive advancement relative to GIANTS' *own current field course*, corroborated by actual movement and job continuity. The hypothesis is preferable to OuttaMyWay predicting a worker's future route or inferring useful continuation from distance travelled alone. It is an *observation candidate* and must be falsifiable.

## Provenance: source, project Reality and interpretation are not interchangeable

### Source-derived facts — GIANTS scripting v1.20

Official [AIDriveStrategyFieldCourse source](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=151&version=script):

- `AIDriveStrategyFieldCourse:update(dt)` calls `self.aiFieldCourse:update(dt)`, then reads `getActiveSegmentData()` as **`segmentIsTurn, segmentIsInitial, segmentPosition, _, _, _`**. In its native debug path the six returned values are bound as **`_, _, segmentPosition, segmentLength, subSegmentPosition, subSegmentLength`**, with `segmentPosition` displayed as a percentage of segment length. This is **current segment** information, not a proven route cursor (published lines 218–253, 508–515).
- Native strategy logic calls `aiFieldWorkerStartTurn` / `aiFieldWorkerEndTurn` when the reported turn state changes; while turning it calls `aiFieldWorkerTurnProgress(segmentPosition,...)`. These describe GIANTS current declared manoeuvre state and its associated progress report, **not a universal completion event** (published lines 242–254).
- Field-course `update` manages implement `aiImplementStartLine` / `aiImplementEndLine` and `VehicleStateChange.AI_START_LINE` / `AI_END_LINE`; native implement activation or a line-start announcement does not by itself prove completed agronomic work (published lines 256–363).
- GIANTS' `getDriveData(dt,...)` invokes `getCanAIFieldWorkerContinueWork`, can stop the active job on a failure path, and uses `aiFieldCourse:getDriveData`. **It is not a passive probe to call from OMW** (published lines 394–475). `lastContinueWorkState` indicates a native *permission to continue* decision in this branch; `true` does not independently demonstrate realised movement or useful continuation.
- The six `getActiveSegmentData()` values shown in these GIANTS call sites **do not contain an explicit segment identifier**. Do not compare successive percentage reports as belonging to the same segment merely because a course object exists.

### Existing OuttaMyWay Reality

[GIANTS Runtime Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md) records earlier live field-course observations: `getActiveSegmentData()` exposed turn/progress/length, with a nil second return in one tuple; recorded progress changed as a worker moved. `getNextSegmentData()` did not reveal a useful future traversal cursor. Observed turn segments included long diagonal moves, significant reverse/forward manoeuvres, and heading reversals. Active `WORKING` did not guarantee movement, and inactive implement-line state alone did not prove a transition.

The retired [0.5.0.5 native blocked-event tap](NATIVE_BLOCKED_EVENT_TAP.md) captured raw true/false events (one 174 ms complete pulse) but did **not** capture course position, realised worker movement or evidence that the separate Patriot pulses represented one causal obstruction. No claim of useful continuation can be retroactively derived from those logs.

### Interpretation — candidate, not fact

**Native Course Advancement Witness** is a candidate *positive* continuation witness consisting of correlated observations of:

1. **Current authority:** same active GIANTS Job Episode and currently valid field-course strategy. Identify player takeover, stop/restart, strategy reconstruction and loss of course data rather than pretending continuity.
2. **Native advancement:** an interpretable forward progression in GIANTS' reported current course/segment, or independently evidenced legitimate native segment transition. Preserve tuple positions and segment continuity; neither a `segmentPosition` increment nor a reset across unknown segment identity is sufficient in isolation.
3. **Realised progression:** coherent world-space movement of the correct physical worker/assembly, in the context of that native advancement. Pure displacement, steering demand and requested speed are weaker signals.
4. **Task-consistent context:** an indicated working segment or legitimate transition/turn may corroborate advancement. **Productive agronomy is not required** for useful continuation, and work-line activation does not prove agronomic outcome.

This remains a **hypothesis** until Reality establishes how native `segmentPosition` behaves through reverses, turns, segment switches, blocked retries, and course/Job Episode reconstruction. We have **no validated segment identity token or universal measured threshold**. If the evidence is unrecognisable, remain `WAITING_FOR_EVIDENCE`, rather than inventing a monotonic progress score.

## Candidate evidence ranking

| Evidence state | What it can support | What it cannot support |
| --- | --- | --- |
| `nativeBlocked=false` edge | GIANTS ceased to assert blocked at that moment | Successful escape, task progress, or termination of an Unresolved Obstruction Episode |
| Actual world-space displacement | Movement happened | Task-consistent direction; whether movement was a fruitless loop |
| Turn / reverse state | GIANTS declared a manoeuvre is underway | That it advanced or settled; how far to a future work target |
| Active-segment `segmentPosition` change | A local course coordinate changed | Same-segment identity or useful global progress without corroboration |
| Coherent current-segment advance **plus** realised motion in one known Job Episode | **Candidate Native Course Advancement Witness** | Universal proof of work completion or a guaranteed lack of subsequent obstruction |
| Independently verified segment progression into subsequent GIANTS-owned work | Stronger *positive continuation* evidence | That every nearby blockage has disappeared forever |
| Job end / no active job | Lifecycle termination (after source verification) | Whether the job **succeeded**; whether it ended because of failure/player intervention |

**Crucial asymmetry:** positive continuation can retire a *particular* unresolved obstruction when provenance/continuity are sufficient. But the **absence of such a witness cannot by itself establish failed progress**, especially while GIANTS waits, lifts an implement, works an unrepresented manoeuvre, or course information is unavailable. Negative qualification needs independent evidence of a persistent deficit, not just an expired clock.

## Adversarial bench cases before implementation

| Case | Candidate expected interpretation | What would disprove the candidate |
| --- | --- | --- |
| Safe adjacent A8 opposed pass; brief native block | After clear passage, positively correlated native course advance and world motion may retire concern | Progress coordinate advances even though worker never escapes, or no accessible segment evidence despite obvious useful continuation |
| True worker-to-worker deadlock, small forward/back retries | Displacement and false pulses alone cannot end the Unresolved Obstruction Episode; need evidence of actual task-directed advancement | Back-and-forth movement is repeatedly marked useful by the candidate despite repeating the same local task state |
| Single worker navigates a hedge by reversing and turning | Recognise legitimate GIANTS turn/reverse advancement even without agronomy | Reverses or turns produce inconsistent/non-comparable progress, so a legitimate exit would be misclassified as failure |
| Worker reverses and returns to **the same position** but subsequently begins next work line | Later native progression can be useful; zero net displacement is not proof of futility | A pure net-distance rule falsely calls the manoeuvre failed |
| Repeated turn-segment percentage resets | Reset may be a segment change, not negative advancement; require continuity | No stable segment identity available, so percentages of different segments are accidentally summed |
| Native blocked briefly clears while vehicle remains stationary | No positive continuation; obstruction remains unresolved or unknown | A false edge alone incorrectly retires it |
| GIANTS strategy/object replaced; player claims worker | Old course/progress continuity becomes ineligible; no inherited blocker verdict | An old percentage or timer is assigned to the new Job Episode |
| A moving neighbour happens to be near a hedge-blocked worker | Course advancement and spatial proximity are independent evidence dimensions | Nearby movement is treated as proof the neighbour caused obstruction |
| A native command is zero or implement is raised for preparation | No automatic failure, whether course data exists or not | Low speed, job `WORKING`, or `AI_END_LINE` alone triggers intervention |

## Focused next Reality discriminator — still requires separate approval

The **minimum passive, read-only comparison** worth validating in a future dedicated experiment is:

- Worker identity, GIANTS Job Episode reference and strategy/course availability.
- The six `getActiveSegmentData()` return slots with their exact nil handling and provenance; observe GIANTS-owned progress **without invoking `getDriveData()` or `update(dt)`**.
- Two or more timestamped worker world positions, preferably the same stable AI direction/reference node, to distinguish actual movement from a changing native scalar. A current position is not the complete assembly envelope.
- Existing GIANTS blocked edge information when *safely* available, with no manufactured/missing edge interpolation.

Observe only a **small bounded set of relevant active workers or already-evidenced blockage candidates**, not repeated 500 ms fleet-wide scanning, and publish only while engineering diagnostics are authorised. No new hook mechanism has been approved. Contrast known independent continuation, A8 passing, futile blocked retries and GIANTS turn/reverse manoeuvring. Validate whether a real **segment identity / transition witness** exists; if it does not, the source-supported tuple is insufficient for a general course-progress contract.

**Acceptance criterion:** repeatable, positive correlation between native course advancement and meaningful native continuation, without qualifying false recoveries on oscillations or false failures during productive-independent manoeuvres. **Falsification is equally valuable:** if course progress is unavailable/unreliable or not distinguishable from retry cycling, use only as corroboration or retire the idea. No speculative new course planner, displacement threshold, AI hook or Control follows from this note.

## Decision boundary and disposition

This document is source research, **not** an owner adoption of a Native Course Advancement contract. Under [#440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440), architecture may recognise the evidence category provisionally, but Specification/Source remain unchanged until its semantics and falsifiers are validated.

The accepted **1-second Native Blockage Persistence Gate** still accumulates *confirmed blocked time* across linked pulses of the **same unresolved obstruction** and excludes true unblocked time. This paper does not decide how to establish cross-pulse causal identity or how to infer a blocking pair beyond already-agreed proximity. It does not change the waived 0.5.0.6 smoke status or request another tap experiment.
