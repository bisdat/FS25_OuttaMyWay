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
| `AIDriveStrategyFieldCourse.lastVehiclePosition` | `AIDriveStrategyFieldCourse`; field | GIANTS-populated record of the strategy's last vehicle position after its normal drive processing. | Passive observation surface used when independently calling `getDriveData()` was avoided because mutation/cursor advancement could not be excluded. It is not a future traversal cursor. | Live diagnostic observation |
| `AIDriveStrategyFieldCourse.lastTargetPosition` | `AIDriveStrategyFieldCourse`; field | GIANTS-populated record of the strategy's last target position after its normal drive processing. | Passive immediate-target observation under the same no-independent-`getDriveData()` boundary. It is not a complete route plan. | Live diagnostic observation |
| `vehicle.aiDriveDirection` | vehicle; field/table | Initialized by field-course strategy. It remained `(0,1)` across distinct live states. | Treat as initialization/legacy state where observed, not dynamic field-worker intent. | Supplied SDK; live falsification |
| `vehicle.aiDriveTarget` | vehicle; field/table | Initialized by field-course strategy. It remained `(0,0)` across distinct live states. | Not the current native field-worker target or a route cursor. | Supplied SDK; live falsification |
| `spec_aiFieldWorker.aiDriveParams` | AI field-worker specialization; table | Stores `moveForwards,tX,tY,tZ,maxSpeed,valid` after native constraints. Stored target is world-space. | Passively read valid immediate command/rate evidence. Target is not a continuation horizon; zero is unresolved without corroboration. | Supplied SDK; current runtime use |
| `FieldCourseSettings.workHeadlands` | `FieldCourseSettings`; field | When the settings object is available, declares whether the productive plan excludes headland work (`false`) or includes a productive headland phase (`true`). | Positive declared-plan evidence only. `false` does not remove manoeuvring demand from the headland/boundary area; an absent settings object means unknown, not a default or inactive job. | Live observation |
| `FieldCourseSettings.headlandsFirst` | `FieldCourseSettings`; field | With headland work enabled, declares headlands-first versus up/down-first productive phase order. | Interpret only with a materialised settings object and the headland-work setting. Availability is opportunistic and must not depend on player UI interaction. | Live observation |
| `vehicle.getCanAIFieldWorkerContinueWork(isTurning)` | AI field-worker vehicle; method/interception surface | Returns native continuation permission plus stop-related values. Current Hold code wraps the vehicle method, preserves any existing false result, and returns `false, false, nil` while its bounded hold is active. | This is a broader field-worker progression permission, not a translation-only gate: denying it historically also suppressed native configuration restoration. Current interception demonstrates use, not architectural ownership. | Historical live validation; current `Prototype22PermissionGate` use |

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
| `getFoldAnimTime()` | Foldable specialization; method | Returns fold-animation position where the runtime specialization exposes it; current representation code uses it as a fallback to `spec_foldable.foldAnimTime`. | Configuration-position evidence only. Interior values do not universally mean motion or name a semantic configuration. | Current runtime use; live observation |
| `getIsLowered()` / `getIsLowering()` / `getIsImplementLowered()` | implement specializations; methods | Return boolean lowered/lowering evidence when implemented; current representation code probes them in order and records the responding method. | Opportunistic configuration evidence. Method absence remains unknown, and these booleans do not establish complete assembly pose or functional engagement. | Current runtime use |
| `getToggledFoldDirection()` | Foldable specialization; method | Returns the fold direction GIANTS would use for a toggle in the validated configuration-control path. | Use only for a runtime-selected, cached fold actuator and reject nil/zero. It does not prove that motion began or completed. | Current validated implementation use |
| `setFoldDirection(direction[, noEventSend])` | Foldable specialization; method | Requests the supplied native fold direction; current control uses the cached actuator and later observes animation endpoints. | Mechanical command surface only. Successful invocation is not readiness, geometry, or settlement authority. | Current validated implementation use |

## Physical assembly and representation

| Surface | Owner / kind | Observed or documented purpose | Safe use and authority limit | Provenance |
|---|---|---|---|---|
| `getAttachedImplements()` / `getAttachedVehicles()` / `getChildVehicles()` | vehicle/implement; methods | Return attachment/child collections in the shapes exposed by the loaded specialization. Current cache normalises known descriptor/object forms from all three. | Protected recursive discovery input with object-identity deduplication and a bounded member budget. Any one method may be absent; discovery does not itself prove complete geometry or AI progress. | Current `AssemblyRepresentationCache` use; assembly observations |
| `spec_attacherJoints.attachedImplements` | AttacherJoints specialization; table | Provides an additional runtime attachment collection consumed by current assembly discovery. | Fallback/complementary structural evidence, normalised and deduplicated with method results. Table presence is not Coverage Closure. | Current `AssemblyRepresentationCache` use |
| `object.components` / component roots | vehicle/implement; table | Identifies physics/component roots for loaded objects. | Structural anchors and identity inputs. Count is not articulation or collision inventory. | Asset inspection; current runtime use |
| `getI3DMapping(key)` | loaded vehicle/implement; method | Resolves a named mapping key to a runtime node when the object exposes the mapping. Current cache also checks loaded `i3dMappings`/`i3dMapping` tables. | Provenance-bearing node-resolution input. A resolved mapping is an anchor, not a physical or collision inventory. | Current `AssemblyRepresentationCache` use; asset/runtime inspection |
| `I3DUtil.indexToObject(...)` | `I3DUtil`; helper | Resolves a declared I3D index path against components/object and, where supported, mapping tables; the current cache protects several observed call forms. | Use only with a declared path and preserve which call form resolved it. Resolution establishes a node, not collision membership, extent, or Coverage Closure. | Current `AssemblyRepresentationCache` use |
| `getWorldTranslation(node)` | engine entity; function | Returns a runtime node's current world position. | Authoritative live origin/pose evidence for that node only; origin coverage is not bound or assembly coverage. | Current runtime use; live physical-representation observation |
| `localDirectionToWorld(node, x, y, z)` | engine transform; function | Transforms a local direction through the node; current observation derives a normalised world-forward axis from local `(0,0,1)`. | Frame-specific direction evidence. Reject failed/degenerate results; local axis labels are not world-direction authority by themselves. | Current runtime use |
| `getHasClassId(node, ClassIds.SHAPE)` | engine entity/class functions | Tests whether a runtime entity is a Shape before current code invokes shape-bound APIs. | Required positive type gate for these measurements. Shape identity permits a query but does not establish collision relevance or complete coverage. | Current `AssemblyRepresentationCache` use; live error-driven validation |
| `getNumOfChildren(node)` / `getChildAt(node, index)` | engine hierarchy functions | Enumerate direct runtime descendants; current cache performs a bounded breadth-first scan. | Bounded discovery only. Traversal can be unavailable/truncated, and descendant presence does not prove physical or collision relevance. | Current `AssemblyRepresentationCache` use |
| `getName(node)` | engine entity function and vehicle/implement method | Supplies runtime entity/object names used for diagnostics and donor-name matching. | Identity hint and matching input only; names do not confer shape class, collision membership, or semantic authority. | Current runtime use |
| `getShapeGeometryBoundingSphere(node, 0)` | shape-bound engine function | For positively verified Shape entities, may return a component-local geometry sphere. Current cache prefers a valid result as its local conservative sphere. | Validate finite centre/radius and corroborate against a world sphere. It is not an exact mesh bound or complete occupancy envelope. | Current `AssemblyRepresentationCache` use; runtime shape-bound evidence |
| `getShapeBoundingSphere(node, 0)` | shape-bound engine function | May return a component-local shape sphere; current cache uses a valid result only as fallback when the geometry sphere is invalid. | Same positive Shape gate and coherence requirements apply. Availability or a valid sphere does not prove complete physical coverage. | Current `AssemblyRepresentationCache` use; runtime shape-bound evidence |
| `getShapeWorldBoundingSphere(node, 0)` | shape-bound engine function | May return the shape sphere in world coordinates; current cache compares it with the local sphere transformed to world space and rejects incoherent/root-alias evidence. | World-space coherence check and bounded extent evidence only. It is not exact mesh geometry or complete assembly clearance authority. | Current `AssemblyRepresentationCache` use; runtime shape-bound evidence |
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
