# Prototype 03 — Option Preservation Window

> **Status:** TS001 evidence completed; hypothesis strongly supported; safe-release sufficiency disproved
>
> **Release:** Canonical v4.6.4
>
> **Mode:** Passive observation only

## Architectural hypothesis

Situation Assessment can identify a **Candidate Option Preservation Window** by observing manoeuvre ordering, an identifiable **Progress Entity**, an **Intent Revelation Point**, and remaining **Response Margin** before both trajectories settle into an established conflict.

Prototype 03 asks one question:

> When Condor's intention becomes sufficiently clear, does Patriot still retain meaningful time and manoeuvre freedom that an Information-Gaining Delay could have preserved?

The prototype does not hold either worker. It does not select which worker should wait and does not claim that a hypothetical hold would prevent the collision.

## Evidence inherited from Prototype 02

The accepted TS001 run showed:

- Condor entered a manoeuvre at approximately `t=78.5s`;
- Patriot entered a manoeuvre at approximately `t=89.5s`, before Condor's resulting trajectory had settled;
- Condor returned to working at approximately `t=90.7s`;
- the pair entered `FORMING` at approximately `t=104.0s`;
- the conflict became `ESTABLISHED` at approximately `t=107.5s`;
- both workers then continued to a head-on collision.

The player observed that a brief wait by either worker might have allowed the other worker's intention to become visible before both committed to opposite ends of the same lane. This observation is evidence, not yet a validated intervention design.

## Validation result

The unchanged TS001 run strongly supported the Prototype 03 hypothesis.

The relevant sequence was:

- `t=75.5s`: Condor began manoeuvring;
- `t=86.7s`: Patriot began manoeuvring before Condor's intent settled and the candidate window opened;
- `t=87.7s`: Condor completed its native manoeuvre;
- `t=93.5s`: Condor reached the diagnostic Intent Revelation Point while Patriot remained approximately 56% through its turn;
- `t=93.5s`: the window became `ACTIONABLE`;
- `t=99.0s`: Patriot completed its manoeuvre;
- `t=101.0s`: Prototype 02 entered `FORMING`;
- `t=105.5s`: Prototype 02 entered `ESTABLISHED` and Prototype 03 marked the window `EXHAUSTED`;
- the encounter later ended in the same head-on collision.

At intent revelation, Patriot was travelling at approximately 15 km/h. The provisional stopping estimate was approximately 2.58 s and 6.41 m. Conflict establishment occurred 12.0 s later. Subtracting the stop-time estimate and the exposed 2.0 s safety buffer left approximately 7.42 s of conservative temporal margin.

The player independently observed that, once Condor was established in the lane, Patriot still appeared to have time to wait. The evidence therefore supports an observable Candidate Option Preservation Window, a unique Progress Entity for this encounter, and a meaningful temporal Response Margin before conflict establishment.

The Progress Preservation Invariant was satisfied by the evidence model: Condor remained able to move and reveal information while Patriot was the hypothetical hold candidate. No Observation Deadlock was represented.

## Manual continuation test

A separate limited in-game test stopped Patriot as soon as Condor appeared established in the lane. This player action abandoned Patriot's GIANTS AI job. Condor completed the lane and initially moved away. Patriot was restarted, completed its aborted turn and began down its lane. Condor then performed another repositioning turn across Patriot's lane and directly into Patriot's path, producing a new crossing conflict.

The result disproved the stronger assumption that revelation of the Progress Entity's current lane is sufficient evidence to release the other Entity safely. The original conflict can disappear while a later linked conflict forms.

The intervention contains **Job Restart Perturbation** because the manual stop abandoned and recreated GIANTS AI activity. It therefore does not prove how an OuttaMyWay speed-zero hold would affect route state. It does prove that the simple `up lane → turn → down next lane` description is not a sufficient future-route model and that current settled trajectory is only locally informative.

The evidence suggests later hypotheses around a Local Intent Horizon, Intent Expiry, Encounter Chain and Safe Release Point. Those names remain evidence for future testing; they are not accepted architecture in v4.6.4.

## Instrumentation findings

Two diagnostic defects were exposed without invalidating the real encounter:

- stationary startup states created an unrelated candidate window (**Startup Manoeuvre Contamination**);
- `ALTERNATE_EXHAUSTION_CANDIDATE` repeated after the state was already `EXHAUSTED` (**Exhaustion Event Repetition**).

Both require declared future corrections. Neither changed gameplay behaviour.

## Provisional concepts under test

### Candidate Option Preservation Window

The observed interval during which simultaneous continued manoeuvring may consume safe alternatives, while temporarily restraining one participant might allow another participant's intention to become clearer.

### Progress Entity

The participant allowed to continue so Reality can generate the evidence required for reassessment.

### Intent Revelation Point

The point at which the Progress Entity's post-manoeuvre trajectory becomes provisionally settled and therefore useful to the other participant.

### Response Margin

The time and manoeuvre freedom remaining after intent revelation. Prototype 03 records current speed, native manoeuvre progress, constant-velocity tCPA and a provisional stopping estimate; none is accepted as a complete model of available alternatives.

### Alternate Exhaustion Point

A provisional boundary after which ordinary graceful alternatives appear to have been consumed. Prototype 03 uses Prototype 02's `ESTABLISHED` transition only as an exposed diagnostic proxy, not as accepted proof of literal physical irreversibility.

### Progress Preservation Invariant

An Information-Gaining Delay must leave at least one participant able to generate the evidence required to complete the wait. Prototype 03 therefore identifies one Progress Entity and one hypothetical hold candidate; it never represents holding all participants as a valid observation-enabling option.

## Evidence contract

For each observed worker, record:

- native manoeuvre start and end transitions;
- current manoeuvre progress, speed, phase and blocked state;
- Prototype 02 trajectory settlement;
- the first post-manoeuvre Intent Revelation Point.

For each qualifying pair, record:

- which worker began manoeuvring first;
- which later worker became the hypothetical hold candidate;
- manoeuvre lead and overlap duration;
- whether one Progress Entity remains able to move;
- window opening, observing, actionable and exhaustion transitions;
- hold-candidate manoeuvre progress at intent revelation;
- current separation, closing rate, tCPA and dCPA;
- provisional stop time and stop distance;
- provisional response-time margin;
- elapsed time from window opening and intent revelation to conflict establishment.

Every threshold and stopping assumption must remain visible in the log.

## Provisional diagnostic states

- `CANDIDATE_OPEN` — a later participant begins manoeuvring before an earlier participant's intent has settled.
- `OBSERVING` — the Progress Entity remains able to continue and generate useful evidence.
- `ACTIONABLE` — the Progress Entity's intent is revealed while the hypothetical hold candidate remains unsettled.
- `EXHAUSTED` — Prototype 02 reports an established conflict after the candidate window opened.
- `CLOSED_SAFE` — both trajectories settle without an established conflict.

These labels are diagnostic aids only. `ACTIONABLE` does not authorise a hold, and `EXHAUSTED` does not prove that every emergency response is impossible.

## Provisional interpretation settings

Canonical v4.6.4 retains these exposed diagnostic settings:

- observation radius: 500 m;
- minimum earlier-manoeuvre lead: 0.5 s;
- observation confirmation: 0.5 s;
- safe-close duration: 2.0 s;
- assumed diagnostic deceleration: 2.0 m/s²;
- assumed reaction time: 0.5 s;
- response safety buffer: 2.0 s.

The stopping estimate exists only to expose a comparable Response Margin. It is not a Control design and must not be defended if game evidence contradicts it.

## Passive boundary

Prototype 03 must not change speed, steering, implements, priority, AI state, route, Decision output or Commitment state.

The probe:

- reads the central Observer model;
- reuses Prototype 01's side-effect-free pair kinematics;
- reads Prototype 02's published motion and confidence evidence;
- runs before the observer-only runtime return;
- disables itself if observer-only mode, Traffic Manager configuration or diagnostic dependencies cannot guarantee passivity.

## Retained TS001 test procedure

1. Install the complete v4.6.4 build as the active OuttaMyWay mod.
2. Start the unchanged TS001 save.
3. Stay with either Condor or Patriot so both turn sequences can be observed.
4. Do not intervene.
5. Note when the second worker begins turning, when the first worker's intended lane becomes visually clear, and whether the second worker still appears able to wait without entering that lane.
6. Allow the encounter to continue through collision or GIANTS resolution.
7. Exit normally so the log is flushed.
8. Upload the complete `log.txt` with the brief visual observations.

Useful log filters:

- `PROTOTYPE 03 ACTIVE`
- `PROTOTYPE03 MANOEUVRE_START`
- `PROTOTYPE03 MANOEUVRE_END`
- `PROTOTYPE03 WINDOW_OPEN`
- `PROTOTYPE03 INTENT_REVELATION_POINT`
- `PROTOTYPE03 INTENT_REVEALED_TO_PAIR`
- `PROTOTYPE03 OPTION_PRESERVATION_ACTIONABLE`
- `PROTOTYPE03 ALTERNATE_EXHAUSTION_CANDIDATE`
- `PROTOTYPE03 TRANSITION`
- `PROTOTYPE03 SAMPLE`
- `PROTOTYPE03 HEARTBEAT`

## Validation questions answered

- **Partly disproved:** startup worker states created an unrelated window; meaningful operational movement must gate future detection.
- **Yes:** one clear real window opened when Patriot began turning before Condor's intent settled.
- **Yes:** Condor was the Progress Entity and Patriot the hypothetical hold candidate for the real encounter.
- **Yes:** Condor's Intent Revelation Point occurred while Patriot remained unsettled.
- **Measured:** Patriot was about 56% through its manoeuvre; stop distance was approximately 6.41 m; conservative temporal margin was approximately 7.42 s.
- **Yes:** `ACTIONABLE` occurred approximately 12 s before Prototype 02 became `ESTABLISHED`.
- **Yes:** the earlier harmless head-on pass did not reproduce the real actionable pattern.
- **No:** the evidence model never proposed holding all participants; one Progress Entity was always preserved.
- **Disproved as sufficient release evidence:** current-lane intent did not predict Condor's later repositioning path.

## Conditions that decrease confidence

The hypothesis loses confidence if:

- the window is identified only after conflict establishment;
- no unique Progress Entity can be identified;
- intent revelation occurs only after the other worker has settled;
- the earlier harmless encounter produces the same actionable pattern;
- manoeuvre progress and response estimates provide no stable explanatory value;
- the apparent window exists only because of arbitrary time thresholds;
- the evidence required to complete the hypothetical wait depends on movement by the hypothetical held Entity;
- the probe oscillates without a meaningful world change.

A failed result remains useful when it identifies which part of Option Preservation is not observable.
## Candidate v4.6.5 diagnostic corrections

Prototype 04 carries three declared corrections to the retained Prototype 03 instrumentation:

- both participants must exceed the minimum operational speed before a candidate window opens, reducing stationary startup contamination;
- a Progress Entity's revealed local intent is cleared when it begins a new manoeuvre, preventing stale `ACTIONABLE` evidence;
- Alternate Exhaustion evidence is latched and emitted once per completed window.

These are diagnostic corrections only. They do not change the accepted v4.6.4 evidence or introduce vehicle control.

