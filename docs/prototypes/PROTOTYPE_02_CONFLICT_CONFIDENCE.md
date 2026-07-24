# Prototype 02 — Conflict Confidence

> **Status:** TS001 evidence completed; hypothesis strongly supported
>
> **Release:** Canonical v4.6.3
>
> **Mode:** Passive observation only

## Architectural hypothesis

Situation Assessment can distinguish a transient projected intersection from an established future conflict by observing **Trajectory Settlement** and the persistence of the projected conflict relationship over time.

Prototype 02 asks one question:

> When has a forming projected conflict become stable enough to be presented as established Current Situation knowledge?

It does not decide whether intervention is justified and does not create, replace or cancel a Commitment.

## Evidence inherited from Prototype 01

The first TS001 run contained:

- an earlier harmless head-on pass whose projected closest separation remained approximately 72 m;
- a later sequential manoeuvre in which closest-approach estimates changed substantially;
- a projected head-on conflict whose closest separation then stabilised near zero.

During manoeuvring, projected closest separation changed approximately:

`356 m → 166 m → 170 m → 104 m → 1.79 m`

That evidence supports early conflict detection but disproves the assumption that one projected intersection is automatically stable knowledge.

## Validation result

The unchanged TS001 run strongly supported the Prototype 02 hypothesis.

The earlier harmless head-on pass remained `CLEAR`. During the later encounter, the relationship entered `FORMING` at approximately `t=104.0s` while Patriot was not yet settled and the projected Conflict Zone was moving rapidly. It entered `ESTABLISHED` at approximately `t=107.5s`, after both trajectories had settled and the projected Conflict Zone drift had fallen within the exposed threshold.

At establishment:

- separation was approximately 266.5 m;
- projected closest separation was effectively zero;
- the transition occurred approximately 18.5 s before both workers became blocked.

The player observed no further material direction change after settlement and confirmed the final outcome remained a head-on collision. GIANTS marked Condor blocked at approximately `t=125.7s` and Patriot blocked at approximately `t=126.0s`.

The evidence therefore distinguishes harmless proximity, unstable conflict formation, established future conflict and the final encounter.

## Disproved provisional lifecycle interpretation

Following physical contact, the probe reported `ESTABLISHED → DECAYING → CLEARED` as both vehicles slowed and the future constant-velocity collision projection disappeared. Both workers nevertheless remained physically blocked.

The run therefore disproved the assumption that loss of future conflict evidence means the real conflict has cleared. This is recorded as the **Projection Clearance Fallacy** and suggests a missing **Conflict Realisation** boundary. Those names remain evidence for a later single-hypothesis increment; they are not accepted architecture in v4.6.3.

## Provisional concepts under test

### Trajectory Settlement

The condition in which an Entity's observed motion has remained sufficiently consistent that its near-future trajectory can be treated as stable knowledge rather than a temporary manoeuvre projection.

### Conflict Confidence

Situation Assessment's confidence that a projected Conflict Zone represents a persistent plausible future rather than a transient consequence of manoeuvring or observation variability.

Conflict Confidence belongs to the relationship, not to either Entity alone.

### Conflict Formation Window

The interval during which manoeuvring Entities progressively reshape their trajectories but the resulting conflict has not yet become stable knowledge.

These concepts remain provisional until evidence demonstrates useful boundaries and lifecycle behaviour.

## Evidence contract

For each observed worker, record:

- heading change and heading-change rate;
- speed change and speed-change rate;
- native turn and worker phase;
- duration of continuously stable motion;
- provisional settled/not-settled interpretation.

For each observed pair, record:

- current separation, closing rate, tCPA and dCPA;
- projected closest-approach midpoint;
- conflict-positive duration and sample count;
- dCPA spread across a rolling window;
- movement rate of the projected Conflict Zone;
- error in the expected tCPA countdown;
- provisional confidence state and every transition;
- the exact thresholds used by the interpretation.

The complete game log must preserve both Prototype 01 and Prototype 02 entries so emergence and confidence can be correlated.

## Provisional diagnostic states

- `CLEAR` — no plausible shared Conflict Zone is currently projected.
- `FORMING` — a conflict-positive projection exists, but trajectory or relationship evidence is not yet stable.
- `ESTABLISHED` — conflict-positive evidence persists while both trajectories are provisionally settled and prediction variability remains within exposed thresholds.
- `DECAYING` — previous conflict knowledge is weakening or has lost supporting evidence.
- `CLEARED` — a previously active conflict relationship has remained absent for the provisional clear duration.

These labels are diagnostic aids, not accepted architecture and not permission to intervene.

## Provisional interpretation thresholds

Candidate v4.6.3 exposes:

- trajectory settlement duration: 2.0 s;
- maximum settled heading rate: 4.0 degrees/s;
- maximum settled speed-change rate: 2.0 km/h/s;
- conflict persistence duration: 2.0 s;
- rolling evidence window: 3.0 s;
- maximum dCPA spread: 5.0 m;
- maximum Conflict Zone drift: 2.0 m/s;
- maximum mean tCPA countdown error: 1.5 s;
- clear duration: 2.0 s.

These values exist only to produce testable transitions. They must be validated or disproved rather than defended.

## Passive boundary

Prototype 02 must not change speed, steering, implements, priority, AI state, route, Decision output or Commitment state.

The probe:

- reads the central Observer model;
- reuses only side-effect-free pair kinematics published by Prototype 01;
- runs before the observer-only runtime return;
- disables itself if observer-only mode or Traffic Manager v2 configuration cannot guarantee passivity.

## Retained TS001 test procedure

The accepted evidence run used this procedure.


1. Install the complete v4.6.3 build as the active OuttaMyWay mod.
2. Start the existing TS001 save without changing either worker's route or setup.
3. Allow both workers to complete their manoeuvres and continue through the entire encounter.
4. Do not intervene unless needed to protect the save.
5. Note when the conflict first appears visually stable, whether either vehicle changes direction again, and what GIANTS AI ultimately does.
6. Exit normally after the encounter so the log is flushed.
7. Upload the complete `log.txt` and the brief visual observations.

Useful log filters:

- `PROTOTYPE 02 ACTIVE`
- `PROTOTYPE02 TRANSITION`
- `PROTOTYPE02 SAMPLE`
- `PROTOTYPE02 CONFLICT_CONFIDENCE_ESTABLISHED`
- `PROTOTYPE02 OUTCOME_CANDIDATE`
- `PROTOTYPE02 PAIR_EXIT`
- `PROTOTYPE02 PAIR_ENDED`
- `PROTOTYPE02 HEARTBEAT`

## Validation questions answered

- **Yes:** the harmless head-on pass remained `CLEAR`.
- **Yes:** the later manoeuvre created a meaningful `FORMING` interval.
- **Yes:** `ESTABLISHED` occurred only after the projected conflict became visually and numerically persistent.
- **Yes:** trajectory settlement, dCPA spread and Conflict Zone drift explained why confidence increased.
- **No harmful pre-collision oscillation was observed.**
- **Yes, with combined evidence:** the player observed the collision and the log recorded both GIANTS workers becoming blocked.
- **Increasing confidence:** Trajectory Settlement and Conflict Confidence show distinct per-Entity and relationship-level explanatory responsibilities, but remain Deferred.
- **Disproved:** `DECAYING` and `CLEARED` cannot describe resolution after the predicted future conflict has already materialised.

## Conditions that decrease confidence

The hypothesis loses confidence if:

- the harmless encounter becomes established;
- a brief projection spike becomes established immediately;
- an obvious stable conflict never becomes established;
- settlement depends entirely on arbitrary elapsed time rather than observed motion consistency;
- confidence oscillates rapidly without meaningful world change;
- the projected Conflict Zone moves unpredictably after establishment;
- the evidence cannot distinguish trajectory instability from relationship instability.

A failed test remains successful architectural evidence when it identifies the missing knowledge.
