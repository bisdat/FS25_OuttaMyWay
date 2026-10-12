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

## GIANTS Reality — TS018, 12 October 2026

**Evidence:** supplied archive `0.5.5.7_TS018.zip`, containing a complete 2,928-line GIANTS log and a 352.875-second (2560×1440, 60 fps) in-game video, Mindenerwald Field 77.

**Observed native completion/Control sequence** (log clock):

| Time | Runtime evidence |
| --- | --- |
| 05:22:19.808 | `AIMessageSuccessFinishedJob` for root `398874`, job 0 |
| 05:22:19.808 | `COMPLETED_WORKER_TRANSIT_REQUESTED` |
| 05:22:20.195 | Prototype admitted: edge 9, `memberCount=1`, selected `202.83 m` **polygon-only** sweep (different from the earlier 204.55 m two-member fixture) |
| 05:22:20.195 | `INFIELD_APPROACH` starts, target (220.21, −247.88), initial root distance 21.08 m, requested cap 8 km/h |
| 05:23:09.307 | Approach marked complete; `SHALLOW_CROSSING` starts, target (197.73, −236.27), root distance 23.93 m |
| 05:23:34.825 | Crossing marked complete; `FORWARD_RUNOUT` starts, target (8.20, −206.70), root distance 194.31 m |
| 05:25:12.779–12.783 | Final leg and `WHOLE_NOMINAL_ASSEMBLY_OUTSIDE_REGISTERED_FIELDS` both reported as success |

**Video contradiction:** The completed sprayer visibly remains stationary for considerable intervals after the first steering objective is armed. The player reports that it moved only with manual steering input. The video shows irregular motion and manual manoeuvring around the first turn; the log records only position-based leg completion, not actual independent steering or who moved it. It cannot prove a native steering call was *rejected*. Crucially, at approximately **05:25:17** (roughly five seconds *after* `COMPLETION_SETTLEMENT_FINISHED`), the speedometer reads approximately **30 km/h** while the machine is still in motion; a subsequent frame around **05:25:22** reads **0 km/h**, after the player's reported manual stop. This is **positive evidence of an incomplete terminal stopping/relinquishment contract**, despite successful geometric occupancy.

**Discovery — Waypoint Orientation Blindness:** The three-leg planner selects an infield *point* only 21.08 m away from the end-of-job pose without requiring an entry heading or physically realised turn curvature. Passing that point, even with manual input, is not evidence of a stable edge-aligned approach. A forward **J-shaped heading acquisition** before shallow entry is a plausible engineering hypothesis, not proven by the existing steering logs.

**Discovery — Player-Control/Native-Steering Conflict:** The native direct drive mechanism checks new AI activity but not current player selection/physical Control. Existing [GIANTS Runtime Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md#selected-assembly-motion-suppression--tab-context-can-claim-physical-actuation) documents an earlier independent TS018 in which hundreds of successful native drive calls moved a selected Condor by only 0.0022 m until the player tabbed away. `Drivable:updateVehiclePhysics` may rewrite `rotatedTime` for a controlled vehicle. This makes a GIANTS steering-writer conflict a **strong, previously supported explanation**, not independently instrumented proof for this specific sprayer. Neither current completion mechanism explicitly interlocks `vehicle:getIsControlled()` nor `g_currentMission.controlledVehicle`.

**Discovery — Release Is Not Physical Stop:** `NativeStaticAssemblyDriveMechanism.release` issues one zero-acceleration `driveToPoint` call, restores prior cruise settings and ends the lease; it does not measure subsequent velocity, require sustained braking, or verify stationarity. When the engine was already running at arm time, release does not request `stopMotor`. `CompletionSettlementRuntime` calls `verifyTerminal` immediately after the final point-within-2.5m leg completes, so its “FINISHED” means nominal **occupancy**, not confirmed **stopped settlement**. The 30 km/h post-success video falsifies the compound “parked safely” interpretation.

**Assembly scope:** The vehicle in this TS018 run reports `memberCount=1` (a self-propelled sprayer in video), so articulated attachment behaviour is still untested. The chosen sweep was **202.83 m**, not the earlier two-member **204.55 m** figure. Preserve both run-scoped observations; no fixed literal is embedded in the route planner.

**Speed decision:** The 8 km/h artificial prototype cap is **unnecessary**, per the test assessment, and should be removed in a subsequent executable TEST increment. Native motor and cruise capabilities should remain governing bounds. Lifting that cap in isolation **before reliable terminal stopping** would increase the consequences of the observed release defect; do not retest unattended.

**Dispositions:**

1. Treat **autonomous steering unvalidated** and **safe terminal stop disproven**. TEST `0.5.5.7` is a **qualified failure**, not an accepted field-validated plateau.
2. Before changing the turn geometry, explicitly address the player-Control/native-drive writer conflict; an occupied/selected vehicle should not silently remain under competing physical writers.
3. Replace orientation-blind approach-point admission with a forward, heading-aware **J-Entry** hypothesis; validate actual infield heading acquisition separately from the later shallow crossing.
4. Make *Stopped Terminal Settlement* a positive end condition: continue native neutral/braking responsibility until the whole assembly is outside and physical speed has settled, then relinquish; report failure/inability to stop rather than nominal `FINISHED`.
5. Remove the prototype's artificial 8 km/h speed cap while retaining native limits and safety termination. Make each change independently falsifiable.
6. Keep draft PR #482 unmerged; separate observation/discussion from the next controlled executable revision.

**Authority Triad disposition:** existing Architecture's intended full-assembly **stopped** terminal outcome remains correct; the currently implemented Specification/Source interpretation is demonstrably insufficient. A follow-on contract revision must distinguish **position arrival** from **heading realised**, **player Control** and **physical stop**, with independent GIANTS validation.


## FS25 native source cross-check — two concrete Control defects

After correlating TS018 video/log, inspect the native [GIANTS FS25 `AIVehicleUtil.driveToPoint`](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=91&class=881&version=script) source, documented for FS25 script v1.20 and consistent with the project's supplied 1.24 source knowledge. **The current source behaviour on this exact running 1.24 machine is not instrumented, but the API contract supplies a stronger explanation than the earlier “steering rejected” hypothesis.**

**Discovery — Local Target Distance Destruction:** `NativeStaticAssemblyDriveMechanism:movementStatus` constructs `lx,lz=worldToLocal(steeringNode,worldTarget)`, correctly a **local position**, then calls `AIVehicleUtil.driveToPoint(..., lx/length, lz/length, ...)`. The native `driveToPoint` computes geometric turning *curvature* from **the actual local point coordinates**: they are not merely a unit direction. Scaling a 20+ metre waypoint to length 1 metre raises requested curvature approximately in proportion to the removed scale, potentially saturating steering. The native helper additionally applies sharp speed reduction and can set `acceleration=0` when target steering change would reduce forward speed below 1 km/h. This gives a **source-supported causal hypothesis** for the initial prolonged stationary interval under steering demand, compounded by the already documented player-controlled vehicle steering-writer conflict. **Correction:** pass actual local `lx,lz` as a position in the completion-settlement path; do not silently alter the previously field-tested Hold & Relocate driver path in the same increment. Distinguish actual heading/steer/yaw/progress in next diagnostic evidence.

**Discovery — Cruise State Restoration Omission:** The native `driveToPoint` explicitly calls `setCruiseControlState(ACTIVE)` during allowed drive. The current release function sends one `driveToPoint(acceleration=0,allowed=false,maxSpeed=0)`, restores `setCruiseControlMaxSpeed` and ends its lease **without restoring `getCruiseControlState()` or guaranteeing an inactive cruise state**. A call with `allowed=false` does not by itself undo an earlier activation. This can leave native cruise ACTIVE at the reinstated previous speed (visually about 30 km/h after termination). The TS018 video **directly falsifies successful final physical stop**. The particular engine state remains unmeasured, but this source-backed omission is a concrete corrective target. A normal terminal success must include actual stopped-speed evidence, not just restoring cruise limits.

**Next controlled experiment ordering:** fix the completion-only local-point contract; establish scoped cruise-state acquisition/neutralisation and speed-confirmed stop on terminal or failure; add player selection/Control attribution and heading/steering telemetry; then test whether a forward **J-shaped entry** is still required. Remove the blanket 8 km/h cap per the accepted TS018 decision, using native motor/cruise limits. Do **not** release or test an unguarded faster build before correcting the demonstrated stop defect. No executable change is contained in this evidence record.

## TEST 0.5.5.8 corrective hypothesis and GIANTS validation protocol

**Change under test:** correct the completion-only native steering target from unit `(lx/length,lz/length)` to full local point `(lx,lz)`; remove the artificial 8 km/h cap; explicitly turn cruise OFF and maintain native neutral braking until low speed (≤0.12 m/s) and less than 0.20 m of root travel persist for ≥1,200 ms at each waypoint; refuse current player-controlled selection; sample steering request, heading, root progress, cruise, native speed, Control context at 1 s intervals when DIAGNOSTIC is enabled. TEST `0.5.5.7` TS018 remains a failure and is not retroactively upgraded.

**Preserved:** the same three waypoint route/fixture, no invented J-turn path yet, no change to the previously accepted Hold & Relocate unit-vector driver; completion TRANSIT request still has no fold-readiness wait. Native speed limits prevail; the unchanged overall 240-second attempt and per-leg 180-second failsafes bound the experiment. This is a supervised prototype; higher native speed increases risk despite the added stop requirement.

**Target tests:** initial motor + accepted steering should create forward displacement **without any manual steering** when the completed sprayer is *not selected*; verify that actual local target distance starts at the physical tens-of-metres range rather than 1 m. Approach, crossing, run-out and STOPPING stages should all log independently. Confirm a stationary engine/cruise-OFF vehicle for at least 1,200 ms **before** `COMPLETION_SETTLEMENT_FINISHED`; watch the vehicle for several seconds afterwards to disprove recurring cruise acceleration. Separately, test a player tab-selection mid-route: it must explicitly interrupt rather than silently accept manual movement. With an articulated assembly, verify the whole physical footprint and turn behaviour separately.

**Evidence needed:** the complete GIANTS log, actual video through and *after* terminal stop, positive or negative `COMPLETION_SETTLEMENT_MOTION_SAMPLE` evidence, failure/interruption reasons and any mismatch between observed physics and status. CI validates offline wiring, exact native API inputs, cruise-OFF/low-speed release and inherited BWR assumptions; CI **cannot** prove road clearance, curvature, player-control timing or GIANTS physical stop.

**Validation status:** PENDING GIANTS Reality for TEST 0.5.5.8. Do not treat passing an offline contract as a successful terminal parking result.
