# TEST 0.5.5.7 — Three-Leg Completion Settlement Prototype

**Status:** implemented for independent offline CI and subsequent GIANTS Reality; **no in-game steering outcome validated yet**. Parent: [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476), draft [PR #482](https://github.com/bisdat/FS25_OuttaMyWay/pull/482).

## Accepted premise and why this prototype exists

GIANTS Reality on Mindenerwald Field 77 / south edge 9 in TEST 0.5.5.6 returned a **two-member** frozen-assembly continuous nominal polygon-only straight sweep of **204.55 m**, with no represented registered-field intersection along that sampled tangent. The requested experiment treats that selected edge as driveable, rather than repeating physical terrain/collision-margin studies performed in TEST 0.5.5.3. **No previous log contained an executed parking manoeuvre.**

The falsifiable hypothesis is that GIANTS-native forward steering can use a reached infield staging point, shallow outward crossing and long tangent run-out to stop a complete articulated assembly outside the source polygon. Failed GIANTS steering, overshooting, jackknifing, a blocked verge or attached members remaining in the source field would disprove the proposed mechanism or its assumed route.

## Distinct authority and limits

TEST 0.5.5.7 keeps production Completion Transit request-only unless a **separate experimental consent** is set. Add `settlementPrototype="true"` to the existing `modSettings/FS25_OuttaMyWay/diagnostics.xml` root, alongside `enabled="true"`. Example:

```xml
<outtaMyWayDiagnostics enabled="true" settlementPrototype="true" />
```

Without **both** true values, no terminal movement is eligible. The spatialFarmlandId selector, if any, must be absent for the Field 77 survey fixture. Unlike ordinary DIAGNOSTIC logging, this option **can physically drive a completed vehicle**. Do not enable it on valuable unsaved work or without active in-game supervision. The flag is read on game load; disable the mod in its Settings page to request immediate Control relinquishment. The code never turns an AI job cancellation or manual stop into completion egress.

This prototype only accepts **registered Field 77 / native edge 9**, with matched measured endpoints and a real completed root inside the source field. It requires a successful native FIELDWORK completion and independently accepted completion-TRANSIT request. An active BWR commitment or new native AI job supersedes the manoeuvre. It is not generalised to Riverbend or arbitrary field boundaries in this TEST.

## Proposed three-leg Reality observation

1. `INFIELD_APPROACH`: forward steering to an interior root waypoint about 16 m before the chosen sweep seed station at 6 m infield depth.
2. `SHALLOW_CROSSING`: from that point, steer 24 m longitudinally towards a root waypoint 8 m beyond the seed station and at its sampled shallow exterior depth. With +2 m exterior depth, the nominal chord is about 18.4° from the tangent.
3. `FORWARD_RUNOUT`: continue parallel to the field edge towards the sweep-endpoint horizon minus 3 m; observe steering and attachment alignment, with no numerical run-out guarantee.

Native `AIVehicleUtil.driveToPoint` is reused through a distinct static-driver instance. Speed is capped at 8 km/h, each arrival requires actual root proximity within 2.5 m, and the prototype stops after a finite 240 s total lease or 180 s per leg. Native motor, cruise and physics influence must neutralise on expiry, new job, other BWR authority, disable or driving error.

After the last leg, a *new live snapshot* of root + attachments must show **all nominal member rectangle corners outside Field 77**, with unchanged member count. A root crossing is not full completion. The experiment does not detect every hedge, traffic lane, slope, collision shape or dynamic-worker conflict.

## Evidence to capture

Retain the complete GIANTS log including `COMPLETED_WORKER_TRANSIT_REQUESTED`, `COMPLETION_SETTLEMENT_ADMITTED`, each `COMPLETION_SETTLEMENT_LEG_STARTED` and `LEG_FINISHED`, and final `COMPLETION_SETTLEMENT_FINISHED` or `INTERRUPTED` with reason. Observe visually whether the implement swings across a neighbouring field, the tractor turns sharply while approaching the infield station, the crossing is shallow after physical steering transients, and all articulated members actually clear. Note any pause, reversal, motor intervention, jackknife, overshoot, player takeover and the precise in-game time.

One normal-completion run is the first decisive test. A second deliberate mod-disable test while an approach leg is active challenges relinquishment. Do not call an offline CI PASS a successful GIANTS parking result.

## Result and next decision

**PENDING GIANTS Reality.** CI and review will determine whether the code expresses the agreed TEST premise consistently. Real steering must then validate or disprove the three-leg hypothesis. PR remains draft and unmerged.
