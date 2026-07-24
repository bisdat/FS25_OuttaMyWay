# Project Status

Version: 4.6.4

Authority state: Canonical — Prototype 03 evidence reviewed and hypothesis strongly supported

Canonical source: exact accepted v4.6.4 candidate

Accepted candidate SHA-256: 11928affbc62d41b3a67534147266ffdfc1a0cdd1915c062010094a9705fc13c

Current focus: distinguish locally revealed intent from safe route continuation before any active Information-Gaining Delay

## Engineering Increment Result

Prototype 03 asked one architectural question:

> Can Situation Assessment identify a Candidate Option Preservation Window using manoeuvre ordering, a Progress Entity, an Intent Revelation Point and remaining Response Margin before both trajectories settle into an established conflict?

**Result:** Strongly supported by the unchanged TS001 run.

No intervention behaviour was included. The canonical release remains observer-only.

## Accepted Evidence

The unchanged TS001 run produced the expected sequence:

- `t=75.5s`: Condor began manoeuvring;
- `t=86.7s`: Patriot began manoeuvring before Condor's intent had settled, opening the Candidate Option Preservation Window;
- `t=87.7s`: Condor completed its GIANTS manoeuvre;
- `t=93.5s`: Condor reached the diagnostic Intent Revelation Point while Patriot remained approximately 56% through its turn;
- `t=93.5s`: the window became `ACTIONABLE`;
- `t=99.0s`: Patriot completed its manoeuvre;
- `t=101.0s`: Prototype 02 entered `FORMING`;
- `t=105.5s`: Prototype 02 entered `ESTABLISHED` and Prototype 03 marked the candidate window `EXHAUSTED`;
- `t=114.0s`: Prototype 01 reported immediate conflict;
- approximately `t=123–124.5s`: the vehicles collided and became blocked.

At intent revelation, Patriot was travelling at approximately 15 km/h. The provisional stopping estimate was approximately 2.58 s and 6.41 m. Conflict establishment occurred 12.0 s later, leaving approximately 7.42 s after subtracting the stopping-time estimate and the exposed 2.0 s safety buffer.

The player's independent observation agreed with the diagnostic interpretation: after Condor was established in the lane, Patriot still appeared to have time to wait.

The evidence supports the existence of an observable temporal option-preservation interval and supports the Progress Preservation Invariant for this two-participant encounter: Condor could remain the Progress Entity while Patriot was the hypothetical hold candidate.

## Follow-up Evidence and Disproved Sufficiency

A limited manual follow-up stopped Patriot as soon as Condor appeared established in the lane. Stopping abandoned Patriot's GIANTS AI job. Condor completed the lane and initially moved away. Patriot was later restarted, completed its aborted turn and began down the lane. Condor then performed another repositioning turn across Patriot's lane, producing a new crossing conflict.

This evidence disproved the stronger provisional interpretation:

> Revelation of the Progress Entity's current lane is sufficient evidence to release the held Entity safely.

Current-lane intent was locally useful but did not reveal Condor's later route continuation. The original head-on conflict was avoided, yet a later linked encounter formed. The manual stop also introduced **Job Restart Perturbation**, so it does not prove how a future speed-zero hold would behave.

The evidence suggests later hypotheses around a **Local Intent Horizon**, **Intent Expiry**, **Encounter Chain** and **Safe Release Point**. These observations are recorded for future testing; no new concept is accepted by this Authority Transformation.

## Instrumentation Findings

Two non-architectural diagnostic defects were observed:

- **Startup Manoeuvre Contamination:** stationary initial worker states created an unrelated candidate window during startup;
- **Exhaustion Event Repetition:** `ALTERNATE_EXHAUSTION_CANDIDATE` was emitted repeatedly after the state had already become `EXHAUSTED`.

Neither defect changed vehicle behaviour or invalidated the real encounter evidence. Both should be corrected in a future declared increment rather than during Canonicalisation.

## Architectural Interpretation

The evidence increases confidence that:

- a Candidate Option Preservation Window is observable before conflict establishment;
- a Progress Entity can preserve the evidence source needed for reassessment;
- Intent Revelation can be locally meaningful while another Entity retains measurable temporal Response Margin;
- the Progress Preservation Invariant prevents Observation Deadlock in an Information-Gaining Delay;
- temporal margin alone does not establish a spatially safe hold or release position;
- current settled trajectory must not be treated as complete route intent.

The named concepts remain Deferred pending broader lifecycle, continuation and multi-participant evidence.

## Passive Guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototypes 01, 02 and 03 run before the observer-only return;
- Prototype 03 disables itself if passivity or diagnostic dependencies are unavailable;
- no speed, steering, implement, route, AI-job, Decision or Commitment change is permitted.

The accepted unchanged game run contained no OuttaMyWay vehicle-control action. The separate manual follow-up was performed by the player and is not implemented behaviour.

## Next Engineering Boundary

Prototype 03 has reached a coherent breakpoint. Any new Repository Transformation must begin from this exact canonical v4.6.4 repository snapshot.

Before an active Information-Gaining Delay is attempted, the next single-hypothesis increment should test whether Situation Assessment can:

- distinguish locally revealed intent from continuing route intent;
- expire stale intent when a new manoeuvre begins;
- recognise whether a hypothetical release remains safe through the Progress Entity's next repositioning event.

## Known Constraints

- Native manoeuvre `progress` remains diagnostic evidence whose cross-vehicle meaning is not established.
- Constant-velocity closest approach and the stopping estimate remain provisional comparison tools, not accepted navigation or braking architecture.
- Prototype 02's `ESTABLISHED` transition remains only a diagnostic proxy for alternate exhaustion.
- The manual stop abandoned and restarted Patriot's GIANTS AI job, so the follow-up contains Job Restart Perturbation.
- One successful or failed continuation does not establish GIANTS route handedness or determinism.
- Static objects and more than two participants are not tested by this increment.
- Older control code remains in the repository but is bypassed by the observer-only boundary.
