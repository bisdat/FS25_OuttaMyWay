# Design

## Purpose

OuttaMyWay coordinates multiple base-game FS25 AI field workers so they avoid preventable collisions and clear shared working corridors with the least disruption.

The long-term goal is cooperative traffic management rather than repeated collision recovery.

## Design principles

1. **Look ahead before reacting.** Prefer the GIANTS AI field course over extrapolating current velocity alone.
2. **Use the least disruptive action.** Brief hold, then slow, then yield, then fold/backout only when needed.
3. **Keep decisions stable.** A committed encounter must not alternate ownership every update.
4. **Remain vehicle agnostic.** Use AI state, course geometry, working width, implement state and field boundaries rather than vehicle names.
5. **Fail safely.** When route or AI state is unavailable, retain conservative reactive handling and clear warnings.
6. **Do not fake certainty.** Diagnostics distinguish confirmed course information from inferred geometry.

## Traffic-manager model

```text
Active AI workers
       |
       v
GIANTS course reader
       |
       v
Future corridor builder
       |
       v
Intersection + arrival-time predictor
       |
       v
Priority / cost evaluator
       |
       v
Traffic reservation
       |
       v
Vehicle controller
       |
       v
Reactive emergency fallback
```

## Priority policy

Priority is not simply first-come-first-served. Candidate decisions may consider:

- estimated arrival time at the conflict;
- current committed lane ownership;
- distance to a safe field edge;
- working width and turn sweep;
- whether one worker is already yielding or under direct control;
- estimated course completion time;
- whether allowing one worker through removes it from the field sooner;
- total delay imposed on all affected workers.

Completion priority is advisory until course-relative remaining-time estimates are stable.

## Action ladder

1. **HOLD** — wait briefly so another planned path clears.
2. **SLOW** — adjust arrival time without stopping fieldwork.
3. **YIELD** — stop one worker while preserving its AI course where possible.
4. **PASSAGE ASSIST** — raise/fold only when physical overlap requires it.
5. **BACKOUT** — reverse toward a confirmed rearward field edge.
6. **MANUAL WARNING** — when safe automated recovery is not available.

## Course completion parking

Future feature only. When a worker finishes, OuttaMyWay may move it to a nearby safe field edge. This requires reliable detection of true job completion, safe direction, implement/towed geometry and available field-edge clearance.

## Rejected or limited approaches

- Nearest-edge scans alone: they do not identify the required rearward intersection.
- Constant-velocity vectors alone: useful as emergency fallback, but cannot predict planned headland turns.
- Saving deleted drive-strategy objects: GIANTS destroys and recreates strategies; old references are unsafe.
- Blind `aiContinue()`: clears blocked state but does not create a missing course strategy.
- Short AI restart timeout: partly worked fields can require extended course generation.
- Unlimited reverse to a distant field edge: may create a larger obstruction and excessive disruption.
