# Prototype 14 — Single-Worker Information-Gaining Delay

> **Status:** TS012 completed; hold mechanism supported, in-lane resolution hypothesis disproved; execution disabled in v4.6.26
>
> **Runtime baseline:** FS25 1.21.1.0, build b40785, revision 81824
>
> **Implementation baseline:** exact canonical v4.6.23, SHA-256 `87d3548463c2f77b81e26098ecd9faa7dd88b498e628f24b13582738e4766db3`

## Evidence origin

TS011-A and TS011-B replayed the Condor Endurance II / Patriot 4450 same-lane encounter with opposite worker-start orders.

Both runs ended in a head-on collision and stable blocked encounter. Reversing admission precedence did not remove the conflict. The current `CRITICAL` prediction preceded first blockage by approximately 7.7 seconds in TS011-A and 7.2 seconds in TS011-B. Prototype 02 `ESTABLISHED` confidence occurred earlier in both runs.

The passive baseline therefore supports:

- **Start-Order-Independent Conflict** — the conflict persists when admission precedence is reversed;
- **Evidence-Bounded Intervention Window** — reliable conflict evidence exists before physical blockage;
- **Conflict Cessation Is Not Conflict Resolution** — prediction returned `CLEAR` after collision because closing ceased, while both workers remained blocked.

## Hypothesis

> When a head-on conflict becomes `ESTABLISHED`, holding exactly the later-admitted worker through the native field-worker permission gate will preserve one Progress Entity and reveal whether the earlier-admitted worker can clear or materially change the situation before collision.

This is an Information-Gaining Delay, not a complete conflict-resolution policy.

## Implementation boundary

Prototype 14:

1. observes active workers through the existing central Observer;
2. records admission order when workers first enter observation;
3. consumes Prototype 02 `ESTABLISHED` Conflict Confidence;
4. requires a settled head-on relationship and at least five seconds predicted time to closest approach;
5. selects the later-admitted worker as the sole hold subject;
6. applies `getCanAIFieldWorkerContinueWork -> false, false, nil` through `TrafficPermissionGate`;
7. permits only one active hold;
8. leaves the earlier-admitted worker under Giants AI control;
9. logs the priority worker's travel, turn transition, separation and blockage;
10. never treats predictor `CLEAR` as release authority.

The experiment runs behind an exclusive execution boundary. Legacy Traffic Manager, recovery, reservation and Decision paths remain dormant.

Prototype 03 and Prototype 04 are disabled during this active run because their evidence contracts assumed a wholly passive system.

## Safe-release boundary

Prototype 14 does **not** automatically release a successful hold. It may log a **Safe Release Candidate** only after:

- the priority worker has entered and completed a turn;
- both workers remain active and unblocked;
- the priority worker is moving;
- separation is at least 55 m;
- separation has increased continuously for at least two seconds.

The hold remains active after that observation. This protects the abstraction boundary:

> Evidence that a release might be safe is not yet authority to release.

The hold is removed automatically only when a worker becomes inactive or detaches, or when the map unloads. A blocked or 90-second unresolved outcome retains the hold for player observation rather than converting lack of prediction into movement permission.

## TS012-A procedure

Use the unchanged TS011 fixture:

1. start Patriot first;
2. wait approximately 18 seconds;
3. start Condor;
4. apply no player intervention;
5. confirm `PROTOTYPE14 HOLD_START` selects Condor as later admitted;
6. observe whether the permission gate actually arrests Condor without ending its Giants AI job;
7. observe Patriot until it clears, turns, becomes blocked or the experiment times out;
8. stop the run after the decisive outcome and retain the full log plus visual observations.

## Expected observation

The strongest positive result is:

```text
ESTABLISHED conflict
→ later-admitted Condor held
→ Condor remains an active Operation member
→ Patriot continues
→ Patriot reveals a turn or clears contested space
→ Safe Release Candidate logged
→ no collision before the evidence horizon
```

## Decisive contradictions

The hypothesis is weakened or disproved if:

- the permission gate does not stop the selected worker;
- holding one worker ends or corrupts its Giants AI job;
- the progressing worker still collides with the held assembly;
- both workers become blocked despite the hold;
- the held position itself removes the progressing worker's viable options;
- admission order is not recoverable reliably;
- or the observed outcome requires a second simultaneous hold.

A failed run remains valuable. It will distinguish an insufficient Commitment from an insufficient detection window or control mechanism.

## Interpretation boundary

A positive TS012 result would establish only that one information-gaining hold is viable in the exact fixture. It would not establish:

- a general priority rule;
- automatic Safe Release;
- correct physical-envelope clearance;
- later repositioning safety;
- offset or narrow-implement generalisation;
- or complete multi-worker cooperation.

## Empirical result — TS012-A/B

The permission gate successfully arrested Condor while preserving its active Giants AI job. This supports the **control-mechanism hypothesis**: OuttaMyWay can hold one field worker without stopping or restarting the job.

The progressing Patriot did not route around the held Condor. Condor was stopped inside Patriot's required working corridor, so the moving head-on conflict became a stationary obstruction. Condor later reported blocked and Patriot then reached stable blockage at approximately the same physical encounter. Predictor `CLEAR` followed cessation of relative closing and did not indicate resolution.

The result establishes:

- **Static Obstacle Conversion** — an in-path hold changes a moving conflict into a stationary obstruction;
- **Hold Location Matters** — the actuator may work while the Commitment remains spatially invalid;
- **Spatial Commitment Precedes Collision Urgency** — once both workers occupy the opposed corridor, long time-to-collision does not make an in-lane hold safe;
- **Opposed Next-Pass Claim** — the fixture conflict emerged when opposite headland turns selected the same next pass from opposite ends.

The original Information-Gaining Delay hypothesis is therefore split:

```text
permission-gate control viability: SUPPORTED
in-lane delay as conflict resolution: DISPROVED
automatic release authority: NOT TESTED
```

Prototype 14 remains as evidence and reusable control knowledge. Its execution is disabled while Prototype 15 investigates a geometry-changing **Unilateral Sidestep**.

