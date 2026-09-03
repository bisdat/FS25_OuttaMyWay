# GIANTS API Surfaces

## Catalogue boundary

This is a validated/observed surface catalogue, not a complete FS25 API
reference. Surface existence, observed behaviour, safe inference, and authority
limits remain distinct. Provenance refers to the supplied FS25 1.21.1.0 SDK,
live observation, asset inspection, or current runtime use.

## Field-course and AI surfaces

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `getActiveSegmentData()` | active field-course strategy; method | Returns active segment attributes including turn state, progress, and length. Return slots may contain nil and progress changes continuously. | Preserve raw tuple positions; use as current segment evidence. It is not a complete route or stable whole-state signature. | Live observation; current `LocalIntentObservation` use |
| `getNextSegmentData()` | field-course strategy; method | Exposes next-segment data, but did not reveal a useful future cursor in the tested course. | Observe defensively. Existence is not continuation-horizon authority. | Live TS001 observation |
| `getActiveSegmentSideOffset()` | field-course strategy; method | Exposes active segment side-offset information. | State-scoped course evidence only; not collision extent. | Supplied/observed surface |
| `getIsCornerCutOutActive()` | field-course strategy; method | Reports native corner-cut-out activity. | Use as current native state only; it does not describe a complete manoeuvre sweep. | Supplied/observed surface |
| `getDriveData(...)` | drive strategy; method | Produces the immediate drive tuple and may participate in native cursor/update behaviour. | Consume GIANTS-populated results. Passive diagnostics deliberately do not call it because mutation/advancement could not be excluded. | Supplied SDK; diagnostic safety decision |
| `getPositionOffsetToActiveSegment(x, z)` | field-course strategy; method | Computes position offset relative to the active segment. | Local course-relative measurement only. It is not assembly clearance or future route. | Supplied/observed surface |
| `skipCurrentSubSegment(distance)` | field-course strategy; method | Advances/skips native subsegment state by a distance. | Known control surface, not a passive observation API; no current architectural permission follows from existence. | Supplied/observed surface |
| `update(dt)` | field-course strategy; method | Advances strategy state per update. | Engine-owned mutation surface; do not call as an observer. | Supplied/observed surface |
| `AIDriveStrategyFieldCourse:setAIVehicle()` | `AIDriveStrategyFieldCourse`; method | Associates the vehicle and initializes `aiDriveDirection={0,1}` and `aiDriveTarget={0,0}`. | Explains field invariance. Initial values are not dynamic continuation evidence. | Supplied FS25 1.21.1.0 SDK |
| `AIDriveStrategyFieldCourse:getDriveData()` | `AIDriveStrategyFieldCourse`; method | Returns current target, direction, speed, and stop-related command data; returns initialized zero target/speed when blocked or unable to continue. | Immediate command source only. Zero is ambiguous without independent context. | Supplied SDK; live correlation |
| `AIFieldWorker:updateAIFieldWorker()` | `AIFieldWorker`; method | Collects strategy drive data, applies stop/speed/cruise constraints, populates `aiDriveParams`, transforms the target, and calls `driveToPoint()`. | Documents the native command path; observation does not grant route authority. | Supplied SDK |
| `vehicle.aiDriveDirection` | vehicle; field/table | Initialized by field-course strategy. It remained `(0,1)` across distinct live states. | Treat as initialization/legacy state where observed, not dynamic field-worker intent. | Supplied SDK; live falsification |
| `vehicle.aiDriveTarget` | vehicle; field/table | Initialized by field-course strategy. It remained `(0,0)` across distinct live states. | Not the current native field-worker target or a route cursor. | Supplied SDK; live falsification |
| `spec_aiFieldWorker.aiDriveParams` | AI field-worker specialization; table | Stores `moveForwards,tX,tY,tZ,maxSpeed,valid` after native constraints. Stored target is world-space. | Passively read valid immediate command/rate evidence. Target is not a continuation horizon; zero is unresolved without corroboration. | Supplied SDK; current runtime use |

## Driving and coordinate semantics

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `AIVehicleUtil.driveToPoint(self, dt, acceleration, allowedToDrive, moveForwards, tX, tZ, maxSpeed, ...)` | `AIVehicleUtil`; helper | Drives toward a **local-space position**, computing steering state and propulsion. Native field-worker code transforms a world target against the steering or reverser node first. | Mechanical control surface. `tX,tZ` are not a direction vector; command acceptance/translation does not prove steering realisation or route authority. | Supplied SDK; current runtime use |
| `AIVehicleUtil.driveAlongCurvature(self, dt, curvature, maxSpeed, acceleration)` | `AIVehicleUtil`; helper | Computes steering rotation from curvature, writes `rotatedTime`, and updates propulsion physics. | Can express curvature mechanically; it supplies no Candidate or routing authority and still depends on the activity/steering pipeline. | Supplied SDK; live experiment |
| `AIVehicleUtil.driveInDirection(...)` | `AIVehicleUtil`; helper | Holds a supplied local direction; expects legacy motor/cruise context in the observed non-job donor pattern. | Direction-holding actuator only. It does not import the donor's routing, graph, job, or task semantics. | Supplied SDK; AutoDrive comparison; current runtime use |
| `worldToLocal(node, x, y, z)` | engine transform; function | Converts world position into the selected node's local frame. Native AI uses the steering node forward and reverser node in reverse. | Record the chosen node and forward/reverse semantics. Local labels are not world directions. | Supplied SDK; current runtime use |
| steering node / reverser node | AI-drivable vehicle; node fields/helpers | Provide the coordinate frame used for forward/reverse target conversion. | Coordinate-frame evidence, not physical-envelope or route authority. | Supplied SDK; current runtime use |

## Vehicle activity, steering, and physics

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `vehicle.rotatedTime` | vehicle; field | Steering state written by GIANTS drive helpers and later consumed by wheel steering. | Evidence of requested steering state, not proof of realised wheel angle or yaw. | Supplied SDK; live telemetry |
| `WheelPhysics:updateSteeringAngle()` | `WheelPhysics`; method | Reads `rotatedTime`, applies steering ranges/rates, and invokes custom steering specialization updates. | Use to understand steering realisation; calls still depend on vehicle activity. | Supplied SDK |
| `WheelPhysics:serverUpdate()` | `WheelPhysics`; method | Calls steering update inside the active-vehicle path. | Explains the activity gate; a written steering state alone is insufficient. | Supplied SDK; live validation |
| `Vehicle:getIsActive()` | `Vehicle`; method | Determines physical update activity and accepts `forceIsActive`. | Activity evidence/control condition, not productive intent. | Supplied SDK |
| `vehicle.forceIsActive` | vehicle; field | Forces the vehicle active for physics/update purposes in observed non-job use. | A bounded mechanical activity condition. It is not an AI job, productive authority, or ownership proof. | Supplied SDK; AutoDrive comparison; current runtime use |
| `AIJobVehicle:getIsActive()` | `AIJobVehicle`; method | Treats an active AI vehicle as active. | Explains native job activity; do not synthesize a job merely to obtain physics activity. | Supplied SDK |
| `Drivable:updateVehiclePhysics()` | `Drivable`; method | Rewrites `rotatedTime` from steering input when the vehicle is controlled. | Account for possible competing steering writers. It supplies no navigation intent. | Supplied SDK |
| `CrabSteering:startFieldWorker()` / `aiSteeringModeIndex` | `CrabSteering`; method/field | Selects an AI steering mode for field work. No corresponding worker-end restoration was found in supplied source. | Supports specialization-aware steering interpretation. Absence of a found end hook is not universal proof of persistent mode. | Supplied SDK |

## Player and lifecycle

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `vehicle:getIsEntered()` | vehicle; method | Reports player entry into the vehicle. | Direct player-entry witness; current runtime uses it in the player-control boundary. It does not enumerate every possible control/ownership state. | Live validation; current `LiveObservationSource` use |

## Folding and configuration

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `spec_foldable.foldMoveDirection` | Foldable specialization; field | Direction/intention processed as active motion above the engine's observed `0.1` magnitude threshold and normally cleared at an endpoint. | Narrow, corroborated actuation-motion evidence. A latched non-zero value can exist without visible progress and does not name semantic configuration. | Supplied Foldable source; live observation |
| `spec_foldable.foldingParts` | Foldable specialization; runtime table | Contains folding parts instantiated for the selected runtime configuration. | Runtime-selected actuator/capability source. Do not treat unselected asset XML configurations as active. | Asset/runtime inspection; current validated use |
| `spec_foldable.allowUnfoldingByAI` | Foldable specialization; runtime field | Runtime permission associated with AI unfolding where present. | Read from instantiated runtime state; it is not complete physical readiness or geometry authority. | Supplied/runtime inspection |
| fold animation time / folding-part endpoints | Foldable specialization; fields/helpers | Expose animation position and requested endpoints for configured parts. | Compare against the relevant part's native endpoint with provenance. Interior values and ordinals have no universal semantic name. | Supplied SDK; asset and live inspection |

## Physical assembly and representation

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `object:getAttachedImplements()` | vehicle/implement; method | Returns directly attached implement descriptors used by current assembly traversal. | Traverse recursively with deduplication and stable root identity. Attachment discovery does not establish AI progress or complete geometry by itself. | Current `LiveObservationSource` use |
| `object.components` / component roots | vehicle/implement; table | Identifies physics/component roots for loaded objects. | Structural anchors and identity inputs. Count is not articulation or collision inventory. | Asset inspection; current runtime use |
| `object.i3dMappings` / mapped nodes | loaded vehicle asset; mapping table | Resolves named asset nodes into runtime entities. | Use as provenance-bearing anchors. Unmapped collision descendants may remain physically relevant. | Asset/runtime inspection |
| hierarchy child traversal and world transforms | engine entity graph; functions | Resolves descendants and their live poses beneath asset/component anchors. | Preserve source identity and hierarchy. Descendant existence is not automatically collision membership. | Physical-representation prototypes |
| collision mask / rigid-body queries | engine entity; functions | Expose bounded physical-role evidence for runtime nodes where supported. | Capability-gate and retain provenance. API availability does not prove semantic correctness or Coverage Closure. | Runtime capability probes |
| local/world bounding and shape-bound queries | engine entity/shape; functions | Tested routes may expose conservative component-local spheres for source-bound runtime shapes; other apparently resolved nodes returned unusable bounds. | Distinguish identity, origin, extent, precision, and coverage. Spheres are not exact meshes or final occupancy envelopes. | Asset-bound runtime prototypes |
| size/working-width/AI-marker and course-offset helpers | vehicle/implement; methods/fields | Expose operational dimensions and offsets. | State-scoped operational evidence and coarse seeds only. They are not automatic collision or complete-assembly authority. | Current runtime use; live/asset evidence |

## General interpretation rules

- A surface's existence is not evidence that reading it is passive; mutation
  risk matters for strategy methods such as `getDriveData()` and `update(dt)`.
- A successful call is not semantic authority. Coordinate frame, lifecycle,
  validity, provenance, and observed correlation remain part of the evidence.
- A runtime object, component, mapping, collision identity, node origin, bound,
  assembly envelope, and working envelope are distinct layers.
- SDK behaviour is evidence for the supplied version, not proof of every FS25
  version or third-party specialization.
