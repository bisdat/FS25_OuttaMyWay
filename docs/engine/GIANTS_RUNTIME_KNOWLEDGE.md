# GIANTS Runtime Knowledge

## Evidence and authority boundary

This document records reusable engine behaviour established in the supplied
FS25 SDK, inspected assets, runtime observation, or validated use. It is not an
architectural prescription: what GIANTS does is distinct from what OuttaMyWay
should do. Fixture observations establish bounded evidence, not universal
behaviour for every vehicle, map, mod, or game version.

## AI job lifecycle

### Declared work state and physical progression are separate

**Finding:** GIANTS may retain an active `WORKING` field-worker state while the
assembly remains effectively stationary. Short-lived admitted jobs can also
begin and end between periodic observer samples.

**Safe use:** combine lifecycle observations with measured motion and direct
admission/termination evidence.

**Do not infer:** `WORKING` proves sustained progress, or absence from sampled
history proves that no job episode occurred.

**Evidence:** attached-assembly runtime observations and job-admission probes.

### Admission is not agronomic capability

**Finding:** native admission rejected a manually operable baler and explicitly
rejected tested grape/olive work; an admitted crop-care setup could still fail
when the encountered agronomic state was incompatible.

**Safe use:** treat admission and continued work as observed GIANTS decisions.

**Do not infer:** gameplay class, manual success, or nominal crop compatibility
guarantees native AI admission or progression.

**Evidence:** FS25 1.21-era live observations.

## Field course and intent

### Active segment is local course evidence

**Finding:** `getActiveSegmentData()` exposed turn state, progress, and segment
length. Its progress changes continuously and raw tuple slots may contain nil;
in one observed tuple progress was the third return after a nil second return.
`getNextSegmentData()` did not expose a useful future traversal cursor in the
tested course.

**Safe use:** preserve return slots and use active-segment data as bounded,
current course evidence.

**Do not infer:** a complete future route, stable generic signature, or an
authoritative segment-table index.

**Evidence:** deterministic field-course exploration and later tuple audit.

### Turn segments are broad

**Finding:** `isTurn=true` covered long diagonal repositioning, substantial
forward/reverse travel, lateral displacement, and eventual heading reversal,
not only compact literal headland turns.

**Safe use:** recognise native transitional/reposition provenance.

**Do not infer:** exact turn geometry, boundary demand, or reusable manoeuvre
sweep from turn state, duration, displacement, or heading reversal alone.

**Evidence:** replicated Condor, lime-spreader, and reversible-plough runs.

### Immediate command is not continuation horizon

**Finding:** `spec_aiFieldWorker.aiDriveParams` varied coherently with the
current native drive command. Its target did not discriminate later good and
bad refuge outcomes and therefore did not describe sufficient future demand.
The older `vehicle.aiDriveDirection` and `vehicle.aiDriveTarget` remained at
initial values through materially different states.

**Safe use:** use a valid command as current target/rate evidence with its
coordinate semantics and provenance intact.

**Do not infer:** route continuation, a future traversal cursor, or Decision
authority. A zero target/speed is ambiguous and does not alone prove blockage
or a zero-speed policy.

**Evidence:** live drive-signal probes and supplied FS25 1.21.1.0 SDK.

### Coverage ordering depends on hidden and start state

**Finding:** a worker starting part-way through a pass later completed omitted
work, returned toward its starting area, and then transitioned across the
field. Opposite headland turns could select the same next pass from opposite
ends. A settled lane did not predict all later traversal.

**Safe use:** reassess observable local intent as GIANTS reveals it.

**Do not infer:** a simple alternating-lane model or permanent refuge from
initial route clearance.

**Evidence:** Condor/Patriot field-course observations.

### Field-course settings are opportunistic declared-plan evidence

**Finding:** when a `FieldCourseSettings` object was materialised,
`workHeadlands=false` declared that the productive plan excluded headland work,
while `true` included a productive headland phase. With headland work enabled,
`headlandsFirst` exposed headlands-first versus up/down-first productive phase
order. A normal active default-start field job was also observed with the
settings object unavailable; opening or changing the AI settings UI caused it
to become readable and stable.

**Safe use:** treat available settings as positive evidence of the declared
productive phase set and order for that job.

**Do not infer:** absent settings encode defaults, mean work is inactive, or
require player UI interaction for safe operation. Excluding productive headland
work does not mean the headland or boundary area has no manoeuvring demand.

**Evidence:** live `FieldCourseSettings` observation during active field jobs.

### Productive and transitional evidence is asymmetric

**Finding:** an active work line combined with coherent implement/work state
was positive productive evidence. An inactive line alone was only absence of
that authority; brief inactive samples occurred between transition completion
and the next productive line. `lastContinueWorkState=true` also persisted in
transitions.

**Safe use:** require corroborating lifecycle and native-transition evidence
for positive Transitional classification.

**Do not infer:** line inactivity alone proves Transitional state, or one signal
is a universal productive-state contract.

**Evidence:** cross-assembly productive/transition observations.

## Movement, speed, and steering

### Speed has no productive-state authority

**Finding:** cruise limits affected productive and transitional movement;
different assemblies had different native work limits, and one reversible
plough transitioned faster than it worked.

**Safe use:** treat speed as current motion evidence affected by cruise control,
terrain, traction, implements, and other mods.

**Do not infer:** productive/transitional semantics from absolute speed or
relative speed ordering. Low actual/requested ratio requires progress and target
context.

**Evidence:** multiple live assembly observations.

### Native zero and blocked states are ambiguous and reactive

**Finding:** GIANTS can hold an active field worker at zero without ending its
job. A blocked course may return a zero command, but zero commands also occur
without independent blockage. Native blocked evidence can arrive after the
predictive intervention opportunity, and GIANTS did not proactively route
around a held obstacle in the tested field course.

**Safe use:** blocked state establishes that GIANTS is not currently
continuing; combine it with physical and lifecycle evidence.

**Do not infer:** the cause, a universal clearance distance, automatic
rerouting, or authority to keep relocating an obstacle.

**Evidence:** Condor/Patriot blocked and permission-gate observations.

### Powered-vehicle trajectory differs from working envelope

**Finding:** GIANTS displaced a tractor path so a right-offset mower followed
the field edge. The powered unit's centre could clear while the deployed
assembly still obstructed passage.

**Safe use:** observe complete assembly geometry and working offsets.

**Do not infer:** powered-vehicle centreline or centre passage represents the
working or collision envelope.

**Evidence:** mower routing and complete-assembly passage observations.

### Local axes do not name world directions

**Finding:** fixture command labels based on local axes were inverted relative
to observed world-space motion.

**Safe use:** transform and validate directions in the required reference frame.

**Do not infer:** labels such as left/right/forward are world-space authority
without explicit frame conversion.

**Evidence:** single-worker egress observations.

## Physical configuration

### Configuration is multidimensional

**Finding:** deployment, vertical pose, terrain contact, functional engagement,
working-side selection, and AI phase can differ. GIANTS reported `WORKING`
before one implement reached its stable low endpoint, and a stable interior
fold animation value represented a raised plateau rather than motion.

**Safe use:** observe realised pose and relevant transition sweep separately
from operational phase.

**Do not infer:** an interior animation value is moving, or AI phase is physical
pose authority.

**Evidence:** TopDown and reversible-plough runtime observations.

### Base vehicle can remain stationary during configuration motion

**Finding:** GIANTS held tested base vehicles stationary while implements
unfolded or lowered, although their changing assemblies occupied plan-view
space. In another fixture useful egress overlapped most folding latency.

**Safe use:** include configuration-motion occupancy and allow overlap only
where independently supported.

**Do not infer:** zero base speed means static occupancy, or full compactness is
always required before useful movement.

**Evidence:** TS004 and bounded Condor egress observations.

### Fold intent is not semantic state or generic motion

**Finding:** GIANTS processes Foldable motion while
`abs(foldMoveDirection) > 0.1` and normally clears direction at the requested
endpoint, but a non-zero direction was observed latched without visible
progress. Numeric configuration identifiers also changed without supplying
semantic names.

**Safe use:** treat fold direction as a narrow, corroborated actuation-motion
witness and realised geometry as spatial evidence.

**Do not infer:** Transit, folded, productive, left/right, readiness, or actual
progress from direction/ordinal alone.

**Evidence:** supplied Foldable implementation and live S416/K105 observations.

### Runtime-selected capability differs from asset availability

**Finding:** `spec_foldable.foldingParts` reflects the selected runtime folding
configuration; asset XML may include shop configurations that were not
instantiated.

**Safe use:** derive available actuation from the instantiated assembly.

**Do not infer:** every asset-declared configuration or actuator is active.

**Evidence:** asset inspection, runtime configuration inspection, and validated
implementation use.

## Assembly and physical structure

### One worker may own multiple runtime assets

**Finding:** tested self-propelled equipment exposed one integrated member,
while tractor/implement combinations exposed attached members with independent
assets and roots. Assembly discovery and AI progression were independent.

**Safe use:** traverse the operational attachment assembly with stable identity.

**Do not infer:** one AI worker equals one root asset, or discovered structure
proves that the AI can progress.

**Evidence:** Prototype 12 assembly observations.

### Components and mappings are anchors, not inventories

**Finding:** collision-bearing descendants may exist below mapped ancestors;
one implement used separate articulated physics components while another moved
collision descendants inside one component. Direct `i3dMapping` coverage varied
by asset, and similar gameplay classes had different structures.

**Safe use:** use components and mappings as node-resolution inputs and preserve
source/hierarchy provenance.

**Do not infer:** physics-component count, mapping coverage, or gameplay class
is a collision inventory, articulation inventory, or Coverage Closure.

**Evidence:** Tiger, TopDown, and Condor asset/runtime inspection.

### Origin coverage differs from bound coverage

**Finding:** an observed provider resolved all catalogued physical identities
and origins while tested runtime bound APIs yielded no usable bounds. Later
source-bound runtime shapes exposed conservative component-local spheres, not
exact mesh envelopes.

**Safe use:** state identity, pose, extent, and coverage claims separately.

**Do not infer:** resolved origins prove physical extents or complete assembly
occupancy.

**Evidence:** physical-representation prototypes and live bound probes.

## Native continuation and handover

### Same-job handover can continue usefully but variably

**Finding:** a held worker could be compacted, displaced, rejoined, restored,
and returned to GIANTS without ending its job. Forward handover sometimes
reacquired useful work after a small correction; similar arbitrary refuge
handoffs could skip, repeat, defer, or apparently reacquire interrupted work.

**Safe use:** preserve the native episode and positively observed continuation
context, then observe the result.

**Do not infer:** same-job movement preserves a particular lane or work order,
or exact position/heading reconstruction is necessary or sufficient.

**Evidence:** bounded native continuation and paired refuge-recovery runs.

### Bounded progression can reveal local continuation

**Finding:** under one experimental low ceiling, a compact Condor advanced its
active-segment progress continuously without route reconstruction.

**Safe use:** regard observed progress as fixture-bounded evidence that GIANTS
can reveal its own immediate continuation.

**Do not infer:** a universal safe speed, complete route, or priority from low
speed alone.

**Evidence:** single-worker bounded native-intent observation.

## Completion and post-job behaviour

### Completion ends membership, not occupancy

**Finding:** job completion left assemblies in their final poses, sometimes
with wide implements still unfolded. Significant physical occupancy therefore
persisted after active-worker membership ended.

**Safe use:** separate operational membership from continuing spatial relevance.

**Do not infer:** GIANTS folds, parks, or clears completed equipment.

**Evidence:** repeated completion observations.

### Post-job translation and steering are mechanically possible

**Finding:** direct driving moved a completed vehicle without creating a new AI
job. Drive helpers wrote `rotatedTime`, but physical wheel steering was realised
only when vehicle activity allowed `WheelPhysics:serverUpdate()` to call
`updateSteeringAngle()`. With `forceIsActive` held, steering angles and yaw were
observed after completion.

**Safe use:** distinguish translation command, steering state, physical vehicle
activity, and realised yaw.

**Do not infer:** a target accepted by `driveToPoint()` guarantees steering,
`forceIsActive` is productive intent, or a synthetic job is required.

**Evidence:** supplied SDK and post-job actuation observations.

### Player entry is a direct claim witness

**Finding:** `vehicle:getIsEntered()` changed on player entry; in the validating
probe the direct-drive call count stopped increasing at that claim.

**Safe use:** treat entry as direct runtime evidence of player occupancy/claim.

**Do not infer:** the method alone defines every possible player-control or
ownership state.

**Evidence:** post-job player-claim runtime probe.

## Evidence warnings and common misreadings

- Predictor `CLEAR` after a collision may mean closing has ceased while both
  workers remain blocked; it is not resolution or release authority.
- Physical clearance and GIANTS collision acceptance can disagree. Neither
  supplies a universal metre rule or relocation authority.
- Working width, base dimensions, course offsets, node origins, and collision
  bounds answer different questions.
- Runtime rotations are radians; source-authored I3D/XML rotations use their
  source format and require explicit conversion before comparison.
- Fixture timings, speeds, distances, configuration IDs, and empirical margins
  are provenance, not general engine contracts.
