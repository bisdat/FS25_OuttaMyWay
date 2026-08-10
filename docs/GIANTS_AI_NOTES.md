## 2026-08-10 — D-0141 GIANTS observations used by aligned follower protection

D-0141 consumes only two additional raw GIANTS surfaces for its provisional follower-demand representation: observed working width and the already-validated D-0138 `spec_aiFieldWorker.aiDriveParams.maxSpeed`. Working width is used as a coarse demand seed, not Assembly footprint. `aiDriveParams.maxSpeed` is used only as the current pre-OuttaMyWay unrestricted rate; target coordinates still have no route/continuation authority. A zero command is treated as unresolved rate evidence.

Historical native turn/reposition traces are deliberately not promoted. `NativeManoeuvreObservationSource` remains boundary-demand Representation Fitness `UNRESOLVED`; a GIANTS `TURN_SEGMENT`, heading reversal, duration, displacement or boundary proximity cannot by itself create active follower demand.

## 2026-08-10 — Native manoeuvre semantics after D-0140 alignment

Live v4.7.69 evidence reinforces the established warning that GIANTS `turn=true` / `TURN_SEGMENT` is broader than a literal compact headland turn. Native field workers can remain in Transitional/reposition behaviour for long duration and distance, including substantial lateral displacement and eventual heading reversal. Therefore native provenance, `turn=true`, boundary proximity and heading reversal are Observation evidence only; none alone qualifies the manoeuvre as reusable boundary-demand geometry.

The aligned `NativeManoeuvreObservationSource` preserves these observations but publishes `representationFitnessForBoundaryDemand=UNRESOLVED`. Future promotion requires a separate Situation-level Representation-Fitness contract; no fixed distance/time/headland heuristic is authorised. D-0138 `spec_aiFieldWorker.aiDriveParams` remains an immediate native command surface only, not a route/continuation horizon.

## FS25 1.21.1.0 SDK — field-worker drive-command path (D-0138)

Exact supplied SDK (`sdk(3).zip`, SHA-256 `34135527b9be4ed5fc8b5b84824e1e2469bc3705818f561035d4a386286189a4`) shows:

- `AIDriveStrategyFieldCourse:setAIVehicle()` initializes `vehicle.aiDriveDirection={0,1}` and `vehicle.aiDriveTarget={0,0}`. D-0137 live invariance is therefore explained; those fields must not be treated as native field-worker continuation authority.
- `AIFieldWorker:updateAIFieldWorker()` obtains `tX,tZ,moveForwards,maxSpeed,distanceToStop` from the active drive strategies, applies distance-to-stop, vehicle speed-limit and cruise-control constraints, then writes `moveForwards,tX,tY,tZ,maxSpeed,valid` into `spec_aiFieldWorker.aiDriveParams`.
- The `aiDriveParams` target is world-space at storage. `AIFieldWorker` converts it with `worldToLocal()` against the AI steering node when forward and the AI reverser node when reverse before invoking `AIVehicleUtil.driveToPoint()`.
- `AIVehicleUtil.driveToPoint()` documents its `tX,tZ` arguments as a local-space position. Do not describe those parameters as a direction vector.
- `AIDriveStrategyFieldCourse:getDriveData()` returns its initialized zero target / zero speed command while it cannot continue or is blocked. This gives D-0138 a useful live falsification state.

# GIANTS AIFieldCourse Notes

## Purpose

This file records observations from the deterministic TS001 save. Versions 4.1.x are diagnostic-only.

## Known native methods

- `getActiveSegmentData()`
- `getNextSegmentData()`
- `getActiveSegmentSideOffset()`
- `getIsCornerCutOutActive()`
- `getDriveData(...)`
- `getPositionOffsetToActiveSegment(x, z)`
- `skipCurrentSubSegment(distance)`
- `update(dt)`

## Safety decision

The explorer does not call native `getDriveData()` itself because that method may advance or mutate the native cursor. Instead it observes `AIDriveStrategyFieldCourse.lastVehiclePosition` and `lastTargetPosition`, which are populated by the base-game strategy after its normal drive call.

## Prototype 12 assembly and motion observations

- Condor exposed one integrated runtime assembly member.
- S 416 + Tiger 8 MT and 8RX 410 + TopDown 600 exposed two-member attached assemblies with independent assets and roots.
- In the first attached run, GIANTS retained active `WORKING` state while measured movement remained effectively zero for at least fifteen seconds.
- The same equipment cultivated manually, disproving simple equipment incapability without revealing the AI cause.
- The second attached fixture sustained normal work, so assembly discovery and AI progression must remain separate concerns.

## TS001 objective

Correlate changes in active/next segment return values with the repeatable Condor/Patriot encounter and identify the engine-owned traversal cursor.


## Explorer 4.1.1 observations

`getActiveSegmentData()` includes continuously changing progress values. Those values must not be included in a general state signature or every sample appears to be a state transition. Explorer 4.1.1 therefore records structural native changes separately from 10% progress milestones and steering-target bearing changes.
## Prototype 03 continuation observation

A manual stop/restart test showed that a worker's settled current lane is not a complete prediction of its subsequent route. Condor completed the observed lane, later performed additional repositioning, and then crossed Patriot's resumed lane. The stop/restart introduced Job Restart Perturbation, so the exact continuation cannot be assumed deterministic, but the observation establishes that immediate kinematic intent and route continuation are separate evidence responsibilities.

## TS004 stationary deployment and asset-structure contrast

The repository owner observed that GIANTS AI holds the base vehicle stationary until a foldable implement is fully extended or lowered. This creates two principal stable occupancy states, folded and working, separated by stationary configuration motion whose Deployment Clearance Envelope must be assessed before commitment.

Static TS004 source examination found:

- Tiger 8 MT: multi-component wing articulation;
- TopDown 600: one physics component with internally animated collision-bearing descendants;
- materially different direct mapping coverage;
- base width and working width with different physical meanings.

These are static asset observations, not runtime identity-resolution proof.


## Prototype 13A hierarchy notes

- Condor provides direct collision-node mappings for the positive-control boom family.
- Tiger exposes collision-bearing wing descendants beneath separate physics-component roots.
- TopDown exposes unmapped collision-bearing descendants beneath mapped folding-arm anchors inside one physics component.
- Runtime rotations are radians; source-authored I3D/XML rotations are interpreted in their source format and must not be compared without explicit conversion.

## TS004 work-engagement state evidence

For TopDown 600, GIANTS AI used an extended-raised pose for initial positioning and end-of-pass repositioning, then lowered the implement for direct-soil-contact work. The raw foldable timeline held a stable interior value at `0.1250` while raised and moved toward `0.0000` while lowering. `WORKING` phase began before the stable low endpoint was reached.

This evidence is fixture-specific. It supports separating deployment, vertical configuration, terrain contact, functional engagement and AI phase; it does not justify universal numerical meanings for fold animation values.
