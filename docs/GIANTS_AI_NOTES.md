# v4.7.121 note — native clearance is evidence, not relocation authority

v4.7.120 live evidence shows GIANTS may later mark a continuing field worker blocked after a completed assembly has positively exited the source Field World and remains physically separate. A subsequent debug-physics-overlay reconstruction showed substantial body clearance. This supports a distinction between physical/Field-World clearance and GIANTS' conservative runtime collision acceptance.

The native blocked state remains authoritative evidence that GIANTS is not continuing. It does not establish a universal metre clearance and does not by itself authorise OuttaMyWay to keep relocating a completed vehicle farther into external or neighbouring Field World space. v4.7.121 architecture records this as Clearance Authority Conflict and applies Egress Externality Constraint above the actuator layer.

---

# v4.7.120 note — direction holding after Vehicle Activity Context validation

TS016 v4.7.119 closed the previous WheelPhysics Activity Gate question: while D-0147 owned `forceIsActive`, GIANTS realised non-zero `rotatedTime` as non-zero physical wheel steering angles and the completed Patriot yawed. Post-job steering is therefore mechanically available without restarting a GIANTS Job Episode.

The remaining problem was controller semantics. A fixed oblique point caused a pursuit arc of about 86 degrees even though Candidate's intended Exit Alignment was the heading/outward bisector. AutoDrive supplies a useful non-job donor for this distinction: its normal route follower calls `AIVehicleUtil.driveInDirection()` with a local direction and temporarily provides the legacy `self.motor` / `self.cruiseControl` fields expected by that GIANTS helper.

v4.7.120 uses that helper only as a physical direction-holding surface. Candidate still owns the single world Exit Alignment and selected boundary; Control does not import AutoDrive routing, graph search, jobs or task semantics. Vehicle Activity Context remains the separate WheelPhysics activity condition.

# v4.7.119 note — WheelPhysics activity gate and non-job driving context

Live v4.7.118 telemetry showed persistent non-zero `vehicle.rotatedTime`, CrabSteering still in AI mode, and zero realised wheel steering angles. The supplied FS25 SDK narrows the handoff: `WheelPhysics:serverUpdate()` calls `updateSteeringAngle(dt)` only inside `if self.vehicle.isActive then ... end`. `Vehicle:getIsActive()` accepts `forceIsActive`; `AIJobVehicle:getIsActive()` accepts active AI.

Courseplay therefore succeeds inside a genuine AI-active lifecycle. AutoDrive demonstrates a separate pattern: it is not a GIANTS AI job but asserts `forceIsActive=true` while its own driving state is active. v4.7.119 tests only that activity condition around the existing D-0147 actuator.

Do not infer from this note that `forceIsActive` is itself productive AI intent or that a synthetic Job Episode is required. The live test must show whether wheel steering angles and yaw begin to realise once the completed vehicle is physically active.

---

# v4.7.118 note — deferred steering realisation in supplied FS25 SDK

The supplied SDK `debugger/gameSource.zip` establishes a two-stage steering path relevant to D-0147:

1. `AIVehicleUtil.driveToPoint()` / `driveAlongCurvature()` compute/write `vehicle.rotatedTime` while also invoking wheel propulsion physics.
2. Actual physical wheel steering is realised later by `WheelPhysics:updateSteeringAngle()`, which reads `vehicle.rotatedTime`, applies wheel steering ranges/speeds and, when present, the vehicle's custom `updateSteeringAngle()` specialization chain such as CrabSteering.

`Drivable:updateVehiclePhysics()` rewrites `vehicle.rotatedTime` from steering input only when `getIsControlled()` is true. `CrabSteering:startFieldWorker()` selects `aiSteeringModeIndex`, but no corresponding CrabSteering worker-end restoration is present in the supplied source. This makes a simple "AI crab mode disappeared at completion" explanation unsupported.

Courseplay comparison: Courseplay customises routing/drive strategy but remains inside an active GIANTS AI worker lifecycle and ultimately invokes `AIVehicleUtil.driveToPoint()` with steering-node local targets. The useful question is therefore where post-job `rotatedTime` stops becoming physical wheel steering, not which additional target formula to try.

---

# v4.7.117 note — post-job curvature steering surface

**Repository/live evidence:** v4.7.116 proved that supplying a materially lateral full local-space target to `AIVehicleUtil.driveToPoint()` can still produce essentially straight post-job travel after the Job Episode has ended. Therefore the earlier R3 post-job actuation result is authority for translation, not steering.

**GIANTS FS25 LuaDoc evidence:** `AIVehicleUtil.driveAlongCurvature(self, dt, curvature, maxSpeed, acceleration)` obtains steering rotation from `getSteeringRotTimeByCurvature(curvature)`, assigns the resulting steering state directly to `rotatedTime`, and then updates wheel physics. Normal active AIDrivable agent execution uses this function for navigation-agent curvature.

**v4.7.117 production use:** derive target-circle curvature from the already-selected fixed Oblique Boundary Egress target. This is a mechanical control surface only; it creates no route-planning or Candidate authority. Live validation remains required.

---

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
