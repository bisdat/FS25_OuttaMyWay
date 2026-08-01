# Architectural Concept Register

Review status: reviewed for cooperative passage evidence consolidation candidate v4.6.43.

### Headland Turn Overlap

A later independent Encounter in which two GIANTS workers enter interacting headland manoeuvres before either has established a stable outbound working trajectory. Overlap is not itself a conflict; live Future-Space convergence must still be demonstrated.

### Dual-Manoeuvre Admission Gap

A Decision boundary in which Situation Assessment predicts a converging conflict while both workers are manoeuvring, but every current admission mode requires at least one straight-working worker. The relationship remains observable but cannot create a Commitment.

### Completion-Transition Control Gap

A boundary created when an active Operation member completes its job and becomes a static relevant obstacle. Field World may retain the obstacle relationship, while active-worker admission ends and no single-worker obstacle-navigation Control consumes the evidence.

### Timing Changes Encounter Geometry

Changing intervention duration or speed changes later worker phase and separation. This may prevent, delay or transform a particular encounter, but does not by itself resolve the architectural gap that permits a comparable future convergence.

### Forward-Only Rejoin Singularity

A steering singularity in which a forward-only controller receives a target almost exactly behind the vehicle. The local target direction contains virtually no lateral component, so a direct command cannot choose a stable turn direction.

### Rejoin Orientation Phase

A bounded low-speed Control phase that converts a rearward rejoin target into a forward-reachable target before direct translation begins. It is omitted when the target is already in the forward hemisphere.

### Rejoin Progress Watchdog

A closed-loop safeguard that requires rejoin target distance to improve. Sustained non-progress or divergence stops and holds the Yield vehicle before a long uncontrolled departure.

### Automatic Encounter Admission

A Decision-side gate that converts sustained conflict-relevant Situation Assessment evidence into permission to begin an already bounded Commitment. TS018 supports this for the exact Condor/Patriot fixture without console input. It does not itself choose role, side, distance or Control method.

### Admission Candidate

A provisional encounter that currently satisfies the bounded admission conditions but has not yet persisted through the confirmation interval. Loss of evidence withdraws it without intervention.

### Encounter Rearming

The controlled transition from a successfully completed encounter latch back to admission readiness. Rearming requires positive evidence that the completed conflict is no longer active: the pair is at least the established passage-clear distance apart and remains outside the predicted conflict envelope for a sustained interval, or the successfully completed pair is no longer active for the existing absence interval.

### Pair-Latch Suppression

A defect in which a commitment latch is attached to the persistent entity pair rather than the specific Future-Space convergence it resolved. The first full TS016 continuation exposed this when a later independent straight head-on was ignored after a successful earlier passage.

### Encounter Episode Latch

A guard that prevents duplicate commitment to one active encounter. Early TS018 attached it to the continuously active fixture pair. Full TS016 continuation disproved that lifetime: after successful completion the latch must enter Encounter Rearming, while failed or unresolved encounters remain latched until explicit recovery.

### Shadow Clearance Calculation

An observer-only estimate of the separation required by an already selected candidate commitment. It may inform later Decision design but has no current role, side, distance, trigger or Control authority.

### Facing Clearance Extent

The one-sided projection from an assembly reference to its furthest relevant physical point toward the opposing corridor or refuge. Required separation combines the opposing facing extents rather than using whole width or centre distance alone.

### Clearance Calculation Closure

Both opposing Facing Clearance Extents are available in one reference frame, allowing the required separation formula to be evaluated. Missing operands remain explicit rather than being replaced by a hidden constant.

### Origin Coverage Is Not Bound Coverage

Resolving every declared physical identity and node origin does not establish usable shape bounds, exact physical extents or Coverage Closure. Origin evidence may support a separately qualified fallback, but the unresolved physical remainder must remain explicit.

### Physical Clearance Is Not Policy Clearance

Physical clearance asks whether represented assemblies overlap. Policy clearance asks whether additional uncertainty, tracking, motion and safety margins are also satisfied. The two results must be reported separately and may legitimately disagree.

### Refuge Pose

The position and orientation occupied by a Yield Assembly while Progress passes. Clearance depends on pose, not merely target-point displacement.

### Encounter Identity Is Not Entity-Pair Identity

An Encounter belongs to a particular convergence of Future Spaces. The same two entities may form several independent encounters during one Operation.

### Perspective Is Not Role Authority

Player vehicle, camera location or observation viewpoint does not assign Progress or Yield responsibility. Role authority must come from an explicit Decision.

### Vehicle-Centre Passage Is Not Assembly Passage

A reference point or vehicle centre may cross a longitudinal marker while the complete Behavioural Assembly remains in conflict. Passage and release conclusions must use assembly geometry rather than centre progression alone.

### Clearance Budget Underrun

A commanded refuge displacement that separates vehicle centres but leaves insufficient space for the complete facing assembly extents, alignment uncertainty, movement sweep and safety margin. TS015-A demonstrated this for the 22 m Condor refuge.

### Retreating Unilateral Sidestep

A Unilateral Sidestep whose first movement is outward and rearward relative to the Yield Entity's confirmed stopped working direction. It increases longitudinal separation while clearing laterally, then rejoins slightly forward for handback.

### Forward Route Reacquisition

Giants accepts a displaced worker returned to its route farther ahead, makes only a bounded convergence correction and continues useful work rather than returning to the intervention point.

### Egress-Ready Configuration

A changing assembly state in which retreat may begin while compacting continues. It is distinct from Full Compact Configuration and requires physical-envelope evidence before production authority.

### Folding and Retreat Overlap

Concurrent compacting and rearward/outward movement intended to reduce stationary Configuration Latency. TS014 tests compatibility; it does not yet prove passing clearance.

### Native Motion Envelope

The speeds and movement behaviours Giants already demonstrates as normal for a specific Behavioural Assembly. For the tested Condor, observed working and repositioning speeds are approximately 25 km/h and 15 km/h.

### Unilateral Sidestep

A Bounded Route Deviation in which one Progress Entity remains on its Giants-selected route while one Yield Entity compacts, moves outward, waits, rejoins and returns to Giants. Only one worker receives route-deviation control.

### Minimum Necessary Authority

The minimum control strength, distance and duration required to change physical reality and resolve an otherwise unavoidable conflict. Least intervention does not require weak intervention.

### Bounded Route Deviation

A temporary spatial departure from a Giants-selected route, authorised only for conflict resolution and ended as soon as a safe handback is possible. Giants retains the job and coverage objective.

### Compact Transit Configuration

The smallest practical assembly configuration suitable for conflict-avoidance movement. For the Condor/Patriot fixture this means work off, raised and booms folded.

### Protected Progress Corridor

The space reserved for the unchanged Progress Entity during a Unilateral Sidestep. The Yield Assembly's complete swept envelope must not enter it.

### Minimum Sufficient Displacement

The smallest outward displacement that keeps both assemblies' passing and movement envelopes disjoint, including configuration transition, turning sweep, waiting and rejoin margins.

### Route Reassertion

Giants AI behaviour after OuttaMyWay releases a displaced worker: continuing ahead, converging onto the route, returning toward the departure point, recovering missed coverage or stopping.

### Static Obstacle Conversion

A failed resolution in which stopping one worker inside another's required path converts a moving conflict into a stationary obstruction.

### Opposed Next-Pass Claim

Two independent Giants workers select the same next working pass from opposite ends during separate headland turns.

### Spatial Commitment Precedes Collision Urgency

After both assemblies commit to incompatible space, a long time-to-collision does not preserve a passive waiting solution. Safe waiting or deviation must occur before or alter that commitment.

### Waiting-Position Closure

A location that appears clear when a worker stops but is later consumed by another worker's evolving route or transition space.

### Start-State-Dependent Coverage

Giants field coverage sequence is materially influenced by the legitimate position, orientation and incomplete work state from which the AI job begins.

### Coverage-Strategy Agnosticism

OuttaMyWay must not require knowledge of Giants' complete field-coverage ordering. It reacts to observable evolving Future Space and reassesses commitments.


### Configuration-Latency Hiding

Useful clearance movement performed while an assembly continues changing configuration, preventing the full configuration duration from becoming stationary delay. TS014 showed Condor reaching refuge almost simultaneously with Full Compact Configuration.

### Unprotected Two-Worker Passage

A bounded cooperative experiment in which the Progress Entity receives no OuttaMyWay control while the Yield Entity executes an already validated route deviation. Failure distinguishes inadequate egress opportunity from failure of the sidestep actuator itself.

### Positive Passage Evidence

Observed evidence that the Progress Entity has fully moved beyond the Yield Entity's rejoin conflict: it is behind a reference anchor, sufficiently separated, moving and diverging for a sustained interval. Absence of closing alone is insufficient.

### Decision-to-Motion Direction Integrity

The requirement that a world-space direction selected by Decision is the same physical direction executed by Control. Console labels and local-axis names are test-harness conveniences, not spatial authority.

### Lateral Refuge Candidate

A world-space refuge region on either lateral side of the Protected Progress Corridor for one proposed Yield Entity. Both sides may remain candidates until path, pose, containment, obstacle or other declared evidence invalidates or leaves one unresolved. Human left/right labels and local-axis signs do not own spatial authority.

### Clearance-First, Cost-Second Refuge Selection

The rule that candidate survival is determined first by transition-path and refuge-pose clearance, including preservation of the Progress Entity's required Future Space. Operational cost such as lateral displacement or interruption duration compares only candidates that survive those constraints.

### Viability Before Preference

The implementation consequence of clearance-first, cost-second selection. Evidence first classifies each candidate as `VIABLE`, `REJECTED` or `UNRESOLVED`; preference is calculated only among candidates whose mandatory evidence is fully clear.

### Shadow Refuge Candidate Comparison

An observer-only Decision experiment that evaluates both world-space lateral refuge candidates for both possible Yield-role assignments from one Assessment Epoch. It records evidence and travel cost without selecting or executing a candidate.

### Authority Migration

The staged transfer of runtime authority from validated fixture constants to evidence-backed Decision outputs. After Prototype 19, role, refuge side, lateral displacement and rearward displacement must each move from hard-coded Control inputs to validated runtime decisions in isolated increments.

### Assessment Epoch Clock-Domain Drift

An instrumentation defect in which evidence describing one real event is timestamped against different runtime origins. Prototype 19 v4.6.37 used raw mission time while Prototype 18 used Observer-relative time, obscuring direct epoch alignment without changing the underlying snapshot.

### Fixture-Distance Leakage

An evidence-integrity defect in which a fixed test-actuator distance escapes an internal calculation seed and appears as though it were derived candidate Knowledge. Unavailable geometry must produce unavailable target and cost fields rather than a plausible fixture value.

### Conservative Working-Width Upper Bound

A low-confidence numerical operand used only when compact Yield geometry is unavailable but a live AI working marker exists. The marker half-width is retained as an orientation-independent conservative upper bound for shadow comparison. It does not prove compact geometry, candidate viability or Control authority.

### Preferred Refuge Is Not Required Refuge

The lower-disruption reachable refuge is preferred, but it is not mandatory. The opposite lateral side remains a legitimate candidate when it is the only clear option. Symmetric geometry may provide two equivalent refuges; unequal or offset geometry may produce a clear cost preference.

### Outboard Refuge Region

A context-specific lower-disruption lateral refuge, commonly on the side requiring less displacement from the proposed Yield Assembly's current relation to the Protected Progress Corridor. It may be preferred when viable but is not the only permitted refuge family. Symmetric geometry may provide no unique outboard side.

### Outboard Refuge Drift

Historical name assigned in v4.6.35 to the perceived restoration of false left/right symmetry. Concrete symmetric and unequal-width examples subsequently showed that the outboard-only correction was itself too restrictive. The term is retained as design history, not current refuge-selection architecture.

### Egress Protection Hold

A future bounded hold of the Progress Entity used only when continued approach would consume the space or time required for the Yield Entity to escape. It remains unimplemented in TS015-B.

## Accepted Concepts

### Start-Order-Independent Conflict

A conflict whose occurrence remains stable when worker admission precedence is reversed. TS011-A and TS011-B support this classification for the Condor/Patriot fixture; the concept does not imply that admission order is irrelevant to priority selection.

### Evidence-Bounded Intervention Window

The measured interval between reliable conflict establishment and observed loss of ordinary unhindered movement. TS011 produced several seconds of reliable evidence before first blockage under both start orders.

### Conflict Cessation Is Not Conflict Resolution

Relative closing can cease because participants collided and became blocked. Absence of future closing or predictor `CLEAR` is therefore not positive evidence that the encounter is resolved.

### Information-Gaining Delay Commitment

A bounded Commitment that holds exactly one worker while preserving another Progress Entity so the changing situation can reveal continuation intent or disprove the waiting hypothesis. Prototype 14 selects the later-admitted worker only for the TS012 experiment.

### Safe Release Candidate

Observed positive continuation evidence that may justify a later release hypothesis but does not itself execute or authorise release. Prototype 14 requires turn completion, movement, separation and sustained divergence, while retaining the hold.

### Situation Space

The structured set of possible situations relevant to autonomous work. It contains entities, states and relationships rather than merely an inventory of nearby objects. Environmental influences such as weather belong within Situation Space rather than requiring a separate Conditions concept.

### Current Situation

The system's present estimated point within Situation Space. It is knowledge reconstructed from observations, not Reality itself. The existing term `Operational Picture` remains in use while the vocabulary relationship is reviewed.

### Future Space

The set of plausible future situations currently under consideration. It deliberately preserves multiple possibilities rather than treating one prediction as certain.

### Action Space

The set of actions currently available to an entity or system. Anticipation is valuable because it preserves Action Space before options collapse.

### Situation Assessment

The transformation that interprets observations and maintains the most plausible Current Situation. It represents evolving risk, uncertainty, constraints and permitted responses; it does not issue control commands.

### Commitment

A persistent intention to perform an action. Commitment owns creation, maintenance, completion and cancellation. Situation Assessment may provide evidence that a commitment remains valid or should end, but does not continuously replace it with each new observation.

### Conflict Zone

A derived operational concept: a spatial-temporal region in which intended motion cannot safely coexist without coordination. It remains useful for describing elevated interaction risk, but is no longer treated as a root architectural primitive.

### Field World

The bounded physical world defined by one field boundary polygon for one Operation. It includes physical geometry within the polygon but does not expand to the whole map.

### Field World Membership

The classification that physical geometry intersects the bounded Field World. Membership does not imply active participation, agency or current relevance. Prototype 05 strongly validated vehicle membership independently of active AI state, and Prototype 06 retained the same Condor Field World identity through a live completion transition in TS003.

### Operational Membership

The dynamic subset of Entities actively participating in one Operation. Prototype 05 validated that a completed vehicle may remain a Field World Member while excluded from Operational Membership. Prototype 06 strongly validated that a live `OPERATION_MEMBER -> NON_OPERATION_VEHICLE` transition can be latched exactly once while Field World identity is retained.

### Situation Relevance

The dynamic relationship by which a Field World Member can affect an Operation member or a plausible future. Prototype 05 strongly validated changing geometric relevance. Prototype 06 additionally validated role-aware relationship reclassification when a participant leaves Operational Membership, even when the relevant/not-relevant result itself does not change. Relevance is not inferred from membership alone.

### Geometry Domain Separation

The accepted separation between GIANTS Collision Geometry, the derived Physical Occupancy Envelope, the agronomic Working Footprint, Configuration Transition Sweep and Projected Motion Sweep. None may silently substitute for another.

### GIANTS Collision Geometry

Physics evidence attached to GIANTS model components. It is an implementation evidence source for physical contact, not the same as visible model width or agricultural working width.

### Physical Occupancy Envelope

A conservative ground-plane representation of the complete Entity's current physical extent, aggregated across the vehicle and every attached or towed implement. Prototype 08 validated configuration-aware live collision-node identity and pose for Condor, but local collision-mesh extents remain unresolved; no authoritative envelope yet exists.

### Working Footprint

The area currently affected agronomically. It may be wider, equal to or narrower than the Physical Occupancy Envelope and shall not be used as a substitute for collision geometry.

### No Silent Under-Approximation

The invariant that unknown, partial or low-confidence geometry remains explicit. Situation Assessment may not present an Entity as physically smaller than the discovered evidence supports.

### Runtime Geometry Access Gap

The accepted implementation finding that GIANTS' internal collision geometry is not necessarily exposed as usable bounds through the mod Lua runtime. Prototype 07 found rigid-body type but no tested shape/local/world bounding functions or collision-mask query, and therefore produced no complete-Entity Physical Occupancy Envelope.

### Operational Collision Envelope

The complete collision geometry of the vehicle and every attached or towed implement, including configuration-dependent maximum extent and the projected swept geometry of the intended movement.

### Full-Envelope Field Containment

The invariant that every AI worker's complete Operational Collision Envelope remains wholly inside the field polygon at all times. External geometry should not require obstacle handling because the worker envelope must never reach beyond the boundary. Prototype 05 promoted the invariant but did not validate exact envelope geometry, projected sweep or active containment.

### Configuration–Pose Separation

The purchased Geometry Family, current Physical Pose and Operational State are independent dimensions. Configuration selects the applicable collision-node family; live transforms establish current pose. Prototype 08A strongly validated this separation for the 36 m Condor through one complete folded-to-deployed lifecycle.

### Save-State Geometry Bridge

Model assets provide collision identity, hierarchy and configuration membership, while save/runtime state provides persistent Entity identity, selected configuration, root pose, fold state and authoritative live node transforms. Prototype 08 showed that offline animation reconstruction is useful diagnostic evidence but must not replace live pose.

### Collision Mesh Extraction Gap

The I3D XML exposes physical collision-node identity and transforms, but trustworthy local mesh extents remain inside the binary `.i3d.shapes` asset until a validated extraction route exists. The gap must remain explicit.

### Live Collision Node Pose

The current runtime transform of a named physical collision node relative to its complete Entity root. Prototype 08A strongly validated that all eight configured Condor boom collision nodes can retain identity and move continuously through a full fold transition. Node pose is not node extent.

### Segmented Tapered Occupancy

A model-specific compound-geometry pattern in which articulated sections have distinct dimensions and may become progressively narrower toward an outer tip. Condor's four sections per side support this interpretation visually, but the concept does not prescribe a generic shape: every foldable implement must derive segmentation, dimensions, activation and articulation from its own evidence.

### Shape-Bound Capability Blind Spot

The implementation finding that Prototype 07's tested box-oriented runtime route did not cover the documented two-argument shape-sphere API family. Negative evidence remains scoped to the capabilities and signatures actually tested.

### Component-Local Sphere Bridge

The runtime-validated route joining source physical collision identity to a correctly resolved runtime collision node whose geometry sphere can be placed by authoritative live pose. Prototype 09 strongly supported this bridge for all eight active Condor 36 m boom nodes. Source asset `shapeId` is provenance metadata until its selector semantics are independently established.

### Extent Truth–Utility Separation

The architectural distinction between a geometry representation being trustworthy and being sufficiently precise for an operational use. Prototype 09 established truthful component-local spheres while also exposing their potential coarseness.

### Sphere Precision Tax

The excess empty space introduced when a long, thin or tapered component is represented by a bounding sphere. The representation remains conservative and truthful, but its operational utility requires separate validation.

### Geometry Availability–Physical Membership Separation

A runtime geometry bound says that geometry exists; it does not say the shape is physical or active now. Source collision metadata establishes physical membership, and configuration classification establishes current inclusion. Prototype 10's nonphysical control reinforced this separation even though its descendant-selection route failed.

### Root-Entity Sphere Aliasing

The observed behaviour in Prototype 10 where every tested source asset `shapeId` paired with `vehicle.rootNode` returned the same root-Entity sphere. Vehicle-root self-coherence must not be interpreted as descendant geometry coverage.

### Self-Coherence Blind Spot

The limitation that geometry-local, general-shape and world bounds may agree internally while all describing the wrong Entity. Intended identity must be validated through evidence independent of the bound's own transform coherence.

### Source-to-Runtime Shape Resolution

The required bridge from source asset collision identity and configuration membership to the instantiated runtime Entity that owns the corresponding geometry and live pose.

### Current Physical Set

The source-identified physical shapes active for the current Geometry Family plus permanent physical shapes. For the Condor 36 m source catalogue this is eight active boom shapes plus five permanent physical shapes; complete runtime resolution of that set remains unresolved.

### Runtime Entity Geometry Authority

The strongly supported finding that the runtime Entity first argument selected geometry for all tested shape-bound calls. Known and invalid second-argument variants were invariant on each Entity, while different runtime Entities remained geometrically differentiated.

### Mapping-Key Locality

An asset mapping key is local vocabulary. Mapping mechanisms may assist resolution, but key spelling does not provide universal collision semantics.

### Operational Entity–Physical Assembly Separation

The accepted distinction between the Operation-facing AI worker and the current physical assembly, which may contain separate powered and attached runtime objects.

### Physical Assembly

The current runtime graph of the operational worker and recursively attached vehicle/implement members. Prototype 12 strongly supported this concept across one integrated and two attached base-game fixtures.

### Physical Assembly Search Boundary

The accepted resolution order in which the operational worker identifies the Operation participant, assembly discovery identifies the current member set, and physical identity resolution proceeds independently inside each member's own source asset and runtime root.

### Attached-Assembly Replication

The Prototype 12 result that the same two-member attached structure was discovered for both S 416 + Tiger 8 MT and 8RX 410 + TopDown 600 despite different manufacturers, mapping vocabularies, components and hierarchy sizes.

### Working-State Motion Divergence

The observed condition in which GIANTS reports an active `WORKING` state while measured physical movement remains effectively zero. It establishes an observation distinction, not a cause or control policy.

### Planar Collision Semantics

The accepted restriction of physical occupancy reasoning to collision-relevant ground-plane projection because GIANTS AI does not exploit hypothetical vertical underpass clearance.

### Physical Representation Portfolio

The simultaneous set of exact, derived and fallback plan-view representations available for one subject, each retaining validity, provenance, completeness, conservatism and fitness.

### Component Footprint Set

The union-ready collection of positioned plan-view component footprints belonging to a Physical Assembly.

### Convex Planar Envelope

A conservative simplified plan-view polygon between component composition and a full bounding rectangle. Accepted as a fallback class; anchor selection remains Deferred.

### Representation Contract

The separation of Spatial Core, Validity Context and Evidence Quality carried by every Physical Representation.

### Job-Scoped Representation Catalogue

The job-bounded catalogue of stable Representation Templates constructed at AI job start and expired at job end.

### Representation Template

A job-stable definition of component ownership, local geometry, placement, construction method, applicability and evidence quality from which current world-space occupancy is realised.

### Pose Realisation

The application of current physical state and plan-view pose to applicable Representation Templates.

### Component Family

A set of homologous components sharing one representation strategy while retaining member-specific dimensions, identity, placement and pose.

### Heterogeneous Footprint Composition

The accepted combination of representations with differing precision and pose authority inside one assembly while preserving their individual limitations.

### Coverage-First Composition

The rule that trustworthy coverage takes priority over uniform precision, with fallback introduced at the smallest safe scope.

### Stationary Configuration Motion

Implement geometry motion while the AI-controlled base vehicle remains stationary during folding, unfolding, raising or lowering.

### Deployment Clearance Envelope

The conservative plan-view area that may be occupied between folded and working endpoints and must be assessed before deployment commitment.

### Deployment Commitment Point

The pre-deployment boundary at which sufficient clearance for expected configuration motion must already be established.

### Endpoint–Sweep Distinction

The rule that folded and working endpoint footprints do not necessarily contain the intermediate deployment sweep.

### Planar Rigidity

Relative plan-view geometry remains effectively constant even when contributors move vertically or otherwise articulate outside the ground plane.

### Steering-Mode Sweep Dependency

The dependency of manoeuvre sweep on active steering mode and actual kinematics rather than a naïve midpoint-pivot model.

### Inventory Closure

Evidence that all collision-relevant components in the stated scope and physical state have been discovered.

### Coverage Closure

Evidence that all collision-relevant plan-view occupancy is represented for the stated scope and physical state.

### Structural Coverage Closure

A job-catalogue claim that applicable templates cover all relevant occupancy for one physical state.

### Realised Coverage Closure

Structural Coverage Closure whose applicable representations all have current valid poses.

### Coverage Ledger

The persistent record of closure scope, basis, contributors, unresolved regions, underestimation risk, pose authority and status.

### Known-Coverage Trap

The false inference that representing every discovered component proves that no relevant component remains undiscovered.

### Clearance Unresolved

A Situation Assessment knowledge state where evidence cannot establish either conflict or safe separation.

### Scope-Local Non-Exclusion

The rule that a coverage gap removes authority to exclude conflict only where that gap could affect the scoped assessment.

### Internal Articulation Representation Diversity

The TS004 finding that plan-view articulation may be encoded through multiple physics components or through moving collision-bearing descendants inside one component.

### Direct-Mapping Coverage Variability

The TS004 finding that asset mappings may expose many, some or almost none of the collision Entities needed for physical resolution.

### State-Scoped Dimensional Evidence

Declared dimensions are useful only with their physical-state and semantic scope; working width, transport width and AI offsets are not automatic collision authority.

## Deferred Concepts

### Envelope Anchor Selection

The method used to construct a conservative Convex Planar Envelope from available anchor points or component footprints. Options A, B and C remain implementation hypotheses pending comparative evidence.

### Deployment Sweep Construction

The exact method for establishing the area occupied during stationary configuration motion. Endpoint union, live transform accumulation and conservative precomputed sweep remain untested alternatives.

### Manoeuvre Sweep and Steering Kinematics

Prediction of assembly occupancy through translation, steering and articulation. Steering mode, turning radius, instantaneous centre of rotation and observed GIANTS control behaviour require future evidence.

### Member-Local Physical Resolution

The proposed process that maps current source physical identities to distinct runtime Entities independently inside every discovered Physical Assembly member. The concept is deferred until Prototype 13's precise evidence contract is agreed and tested.


### Conflict Relevance Transition

A change in the Current Situation whereby an Entity or object moves from being merely present to participating in a plausible conflict. Prototype 01 seeks evidence that this transition can be observed consistently without treating proximity alone as conflict.

### Conflict Emergence Point

The earliest observed point at which previously independent plausible trajectories form a shared Conflict Zone. The first TS001 evidence supports detectability well before immediate physical conflict, but the concept remains Deferred until its stability and architectural lifecycle are established.

### Trajectory Settlement

A provisional condition in which an Entity's observed motion has remained sufficiently consistent that its near-future trajectory may be treated as stable knowledge rather than a temporary manoeuvre projection. Prototype 02 evidence supports an observable boundary and distinct per-Entity explanatory value, but the concept remains Deferred pending broader lifecycle evidence.

### Conflict Confidence

A provisional relationship-level assessment of whether a projected Conflict Zone represents a persistent plausible future rather than a transient projection. Prototype 02 evidence supports a distinct relationship-level responsibility, but the concept remains Deferred pending generalisation beyond the single TS001 encounter and correction of the realised-conflict lifecycle.

### Conflict Formation Window

The provisional interval during which manoeuvring Entities progressively reshape their trajectories but the resulting conflict has not yet become stable knowledge. Prototype 02 observed a meaningful `FORMING` interval before establishment, but the concept remains Deferred until its opening, closing and relation to remaining alternatives are tested directly.

### Candidate Option Preservation Window

A provisional interval in which overlapping unsettled manoeuvres may consume safe alternatives, while temporary restraint of one participant might allow a Progress Entity to reveal useful intent. Prototype 03 observed a meaningful window and an actionable temporal margin before conflict establishment, but the concept remains Deferred pending spatial hold safety, continuation intent and broader scenarios.

### Progress Entity

The participant left able to continue so Reality can generate the evidence required for reassessment. Prototype 03 identified Condor as a useful Progress Entity while Patriot retained temporal margin, but the concept remains Deferred pending continuation and multi-participant evidence.

### Intent Revelation Point

The provisional point at which a manoeuvring Entity's resulting trajectory becomes settled enough to provide useful knowledge to other participants. Prototype 03 observed a locally useful boundary, but the manual follow-up showed that current-lane revelation is not complete route intent or sufficient safe-release evidence. The concept remains Deferred.

### Response Margin

The provisional time and manoeuvre freedom remaining after intent revelation. Prototype 03 measured approximately 7.42 s of conservative temporal margin in TS001, but spatial hold safety and route continuation remained unproven. The concept remains Deferred and must not be reduced to one stopping formula.

### Alternate Exhaustion Point

A provisional boundary after which ordinary graceful alternatives appear to have been consumed. Prototype 03 used conflict establishment as a useful diagnostic proxy, but later encounter formation shows that exhaustion and resolution must be evaluated across continuing route interactions. The concept remains Deferred.

### Information-Gaining Delay

A possible temporary Commitment whose purpose would be to allow Reality to reveal useful intent before a stronger Commitment is made. Prototype 03 supports the availability of temporal margin, but the manual follow-up disproved local intent as sufficient release evidence. The concept remains Deferred and is not implemented.

### Progress Preservation Invariant

A provisional architectural invariant for Information-Gaining Delay: at least one relevant moving participant must remain able to generate the evidence required to complete the wait. Prototype 03 preserved one Progress Entity throughout the real window; the invariant remains Deferred pending active and multi-participant validation.

### Observation Deadlock

A state in which every relevant moving participant is held while the completion condition depends on one of them moving to reveal intent. The concept is scoped to observation-enabling delay and does not prohibit a separately governed Emergency Arrest Commitment.

### Mutual Commitment Trap

A provisional situation in which independently acting participants cross their respective Commitment Points before either can adapt to the other's revealed intention. Prototype 03 observed useful precursors and temporal margin before establishment, but the later crossing encounter showed that avoiding one trap may expose another. The concept remains Deferred.

### Local Intent Horizon

The provisional interval during which an Entity's settled trajectory remains useful knowledge of its immediate path. Prototype 04 observed stable bounded epochs and directly disproved their interpretation as complete route knowledge. The concept remains Deferred pending broader Entities, manoeuvres and Field World observation.

### Intent Expiry

The provisional transition by which previously useful local intent becomes stale. Prototype 04 strongly supported new manoeuvre and worker detachment as explicit expiry evidence. The concept remains Deferred pending generalisation beyond active GIANTS workers and the single TS001 fixture.

### Encounter Chain

A provisional sequence of linked conflicts in which an intervention changes the timing or form of an encounter without eliminating the underlying coordination problem. Prototype 04 observed an unsafe later repositioning toward parked Patriot and a final shared-position conflict after completed Condor left active observation. The concept remains Deferred and the manual intervention remains qualified by Job Restart Perturbation.

### Safe Release Point

A provisional boundary at which releasing a held Entity leaves its resumed path clear through a defined continuation horizon. Prototype 04 did not establish this boundary: the original parked position became unsafe, while the later clear continuation followed manual relocation and could not validate the original hold site. The concept remains Deferred and no release authority exists.

### Continuation Safety Horizon

The bounded future continuation that must remain clear before release can be considered safe. Prototype 04 supports the next manoeuvre as a useful limited horizon, but also shows that the horizon is incomplete when physically relevant non-workers disappear from observation. The concept remains Deferred and does not imply knowledge of a complete GIANTS route.

### Opportunity

Useful descriptive language for a possible pre-commitment course of action, but current evidence does not show an independent lifecycle or responsibility. Reconsider when observations reveal competing intentions that must persist or be governed before Commitment exists.

### Entity Naming

The architecture requires a general participant concept broader than a vehicle or worker. `Entity` is the current candidate label, but naming remains Deferred until the concept's boundary is demonstrated consistently.

### Repository Folder Numbering

The existing numbered structure is retained. Reconsider only when evidence identifies a navigation or continuity problem that a numbering change would solve.

### Operational Picture versus Current Situation

The two terms may describe the same maintained knowledge. Keep both under review until ownership, lifecycle or explanatory difference is demonstrated.

## Rejected Concepts

### Conditions

Rejected as a separate architectural concept because weather and comparable environmental influences already belong within Situation Space. Reconsider only if an independent lifecycle or responsibility is observed.

## Architectural Dimensions and Distinctions

### Reality and Knowledge

Reality exists independently of the system. Knowledge is the system's evolving estimate reconstructed from observations. This distinction is architectural knowledge rather than an independently owned component.

### Time

Time is the dimension in which Reality evolves, observations occur, Knowledge changes, Future Space is reconsidered and Action Space expands or collapses. It is not another processing component.

## Review Rule

At every canonical release, review all sections against current evidence. Promotion, deferral, rejection or demotion requires a recorded rationale in `DECISION_LOG.md` or an ADR. An unchanged review is still recorded in the release changelog.


## Repository Release Concepts

### Engineering Increment

The bounded unit of engineering purpose. It closes when its declared purpose reaches a coherent breakpoint; time, chat boundaries and version numbering do not define completion.

### Engineering Consolidation

The human-governed promotion of durable architectural, implementation and operational knowledge into authoritative repository homes, followed by review for completeness.

### Engineering Intent

The declarative description of the repository change that has been discussed, decided and approved for Candidate Production. It crosses the collaboration boundary without requiring the consolidation author to modify repository files directly.

### Canonical Repository Snapshot

The exact immutable package and integrity fingerprint established as the baseline for one Candidate Production run. It represents the canonical repository at a specific point and is distinct from an editable Git working tree.

### Repository Transformation

The controlled application of declared Engineering Intent to one exact Canonical Repository Snapshot, with observed delta, validation findings and evidence. It changes repository content; it does not itself confer authority.

### Candidate Determinism

The invariant that the same exact Canonical Repository Snapshot and fingerprint-bound Engineering Intent produce one byte-identical candidate package across supported execution platforms. Platform-neutral path ordering and platform-independent archive metadata are implementation obligations of Candidate Production.

### Repository Transition

The governed movement from the exact canonical baseline through Release Candidate, accepted review and explicit Canonicalisation to the next canonical repository.

### Repository Authority State

Working, Release Candidate and Canonical are distinct authority states independent of version identity and Git working state.

### Engineering Transformation

The declared substantive Repository Transformation performed during Candidate Production from the exact Canonical Repository Snapshot.

### Authority Transformation

The candidate-to-canonical authority change. It must not alter approved substantive engineering content.

## Accepted from Prototype 13A design, validation and consolidation

- **Resolution Path** — a source-to-runtime candidate-generation method; distinct from a worker navigation route.
- **Resolution Contract** — the mandatory claims required before one source shape may be classified `RESOLVED`.
- **Resolution Claim Set** — source identity, runtime identity, geometry authority, pose authority, evidence, dependencies and explicit limits produced by resolution.
- **Resolution Candidate Set** — every applicable declared Resolution Path produces a candidate before selection.
- **Resolution Path Convergence** — independent paths reaching one Entity are corroborating evidence.
- **Resolution Path Disagreement** — coherent paths reaching different Entities remain visible as ambiguity.
- **Resolution Path–Authority Separation** — path type does not determine physical authority.
- **Resolution Path Provenance** — discovery mechanics remain attached for audit without becoming downstream assessment logic.
- **Disposable Fixture Declaration** — asset-specific Lua tables are diagnostic scaffolding, not production configuration.
- **Runtime Distinctness Proof** — handle inequality is necessary but insufficient; ownership, hierarchy, geometry authority and pose are required.
- **Signature Equality Is Not Aliasing** — symmetric family members may share geometry signatures while remaining distinct Entities.
- **Evidence Contribution Separation** — each observation supports a specific resolution claim rather than standing in for the whole contract.
- **Mandatory Evidence Floor** — candidate existence, assembly/structural coherence, Entity-local geometry, pose and no unresolved contradictory identity.
- **Corroboration Without Gatekeeping** — convergence, controls, motion, symmetry and repeated observation strengthen claims but are not universal gates.
- **Claim-Specific Confidence** — confidence attaches to identity, geometry, pose, freshness and closure claims separately rather than one percentage.
- **Stable Interior Animation State** — a numerical value inside an animation range may represent a stable physical pose rather than incomplete movement.
- **Compound Animation Timeline** — one asset animation timeline may encode multiple architectural state dimensions.
- **Orthogonal Physical State Dimensions** — deployment, vertical configuration, terrain contact, functional engagement and operational phase remain separate concepts.
- **Extended Manoeuvring State** — an implement remains extended but raised while an AI worker positions or repositions it.
- **Work Engagement Cycle** — repeated AI-controlled raising for manoeuvring and lowering for direct-soil-contact work within one deployed job.
- **Operational Phase–Physical State Separation** — GIANTS AI phase is contextual evidence, not authoritative physical-pose evidence.
- **Raise/Lower Semantic Diversity** — raising/lowering has implement-family-specific meaning and cannot be mapped universally to engagement.
- **Configuration–Function Separation** — a physical configuration change may not alter gameplay function.
- **Contact-Dependent Functional Engagement** — some implements require realised terrain contact before their intended ground operation can occur.
- **Commanded State–Realised Contact Separation** — a lower command or animation target does not prove terrain contact.
- **Player Obstacle Boundary** — player-controlled assemblies are relevant only as potential obstacles to AI workers, not as cooperative workers or behavioural models.
- **Functional Class–Structural Representation Separation** — shared gameplay function does not imply shared runtime physical structure.
- **Class as Context, Not Contract** — class may guide questions but cannot establish component, hierarchy, mapping or Resolution Path authority.
- **Best Available Defensible Representation** — the most informative defensible spatial account achievable within the assessment budget for the current horizon.
- **Assessment-Horizon Fitness** — representation suitability is relative to the plausible futures and horizon being assessed.
- **Progressive Representation Refinement** — assessment proceeds with explicit uncertainty and refines spatial knowledge over later cycles.
- **Assessment Representation Portfolio** — complementary exact, derived, fallback and unknown layers may be composed rather than selecting one universal shape.
- **Minimum Sufficient Defensible Portfolio** — the least-cost admissible collection sufficient for the attempted assessment conclusion.
- **Conclusion-Relative Sufficiency** — representation adequacy depends on whether assessment seeks conflict support, possibility, exclusion or unresolved clearance.
- **Representation Claim Permission** — each layer declares which assessment conclusions its evidence may support.
- **Representation Passport** — self-description of scope, authority, dependencies, coverage, freshness, cost and permitted conclusions.
- **Self-Describing Representation** — downstream assessment can use a representation without reconstructing its discovery mechanism.
- **Discovery Independence** — representations are consumed according to established claims, not lookup mechanics.
- **Representation Cost Profile** — acquisition, refresh, projection, volatility, composition and delay-exposure costs remain explicit and multidimensional.
- **Admissibility Before Optimisation** — cost comparison occurs only among defensible representations.
- **Context-Weighted Representation Selection** — assessment context may prioritise cost components; exact weighting remains unimplemented.
- **Dependency-Scoped Invalidation** — material change invalidates only claims that depended on the prior state.
- **Material Change Invalidation** — previous steady-state knowledge requires reassessment when relevant motion, pose, structure or role changes.
- **Smallest-Scope Refresh** — refresh pose, projection, member or assembly only at the affected scope.
- **Assessment-Relative Staleness** — age becomes stale only relative to the current question, horizon and changes observed.
- **Representation Usability Knowledge** — Situation Assessment may classify representations as current, horizon-limited, uncertain, refresh-required or structurally invalid.
- **Situation Assessment as Representation-Fitness Arbiter** — Situation Assessment decides usability and refresh need while producing Knowledge only.
- **Operational Membership–Spatial Relevance Separation** — job membership may end while physical obstacle relevance remains.
- **Completed Worker Obstacle Transition** — an active AI worker becomes a non-member obstacle when its GIANTS job completes.
- **GIANTS Completion Acceptance Boundary** — OuttaMyWay accepts GIANTS' final location/configuration and does not relocate the completed vehicle.
- **No Correct Parking Inference** — no universally safe or player-preferred post-job destination can be inferred.
- **Persistent Completed-Worker Obstacle** — a completed assembly remains represented while it can affect remaining workers.
- **Role-State Invalidation** — completion invalidates role and motion expectations while physical identity and geometry remain valid.

## Deferred after Prototype 13A

- **Prototype 13B Resolution Path Discovery** — automated candidate generation begins only after representation-diverse fixtures challenge the Resolution Contract.
- **Post-Job Configuration Normalisation** — possible safe in-place raise/fold action to reduce obstruction without relocation; control, sequence, sweep and benefit remain unproven.
- **Assessment Deadline Escalation** — possible Decision Engine response when useful knowledge cannot be refreshed before decision time expires; no all-stop, selective-hold or other failsafe is selected.
- **Representation weighting mechanism** — retain cost vectors and context priorities until measurement shows whether thresholds, Pareto comparison or a scalar score are justified.

## Accepted from Base-Game Vehicle Corpus and Semantic Review

- **Vehicle Definition Corpus Extraction** — read-only selection of catalogue-relevant base-game XML/I3D evidence from the manufacturer-organised installation corpus.
- **Definition Inheritance Resolution** — explicit tracing of parent-definition relationships before catalogue inference.
- **Effective Definition Boundary** — the accepted limit of Raw Definition Evidence plus Selected-Field Inheritance Projection; not a complete GIANTS merge implementation.
- **Purchase Category as Context, Not Contract** — shop placement is useful evidence but cannot establish semantic identity, scope or physical structure alone.
- **Type–Capability Entanglement** — declared GIANTS type names may combine role and optional capability and must not be copied directly into semantic identity.
- **Function Declaration–Specialization Separation** — declared shop functions express intended capability but do not prove implementation method, active configuration or participating geometry.
- **Runtime Localisation Authority** — the running GIANTS localisation service is authoritative for the text it presents in the observed environment when readable source storage is opaque.
- **Readable-Source Exhaustion** — a bounded search completed without finding authoritative readable localisation definitions.
- **Semantic Profile, Not Category** — classification preserves primary family, primary role, secondary roles and capabilities rather than one replacement category.
- **Role–Capability Separation** — additional abilities remain orthogonal to an asset's principal semantic identity.
- **Function Cohort Is an Anchor, Not a Decision** — shared declared functions define an efficient review group but do not guarantee one final profile.
- **Group Decision–Asset Exception** — repeated evidence is reviewed once where defensible while contradictions and minority profiles remain explicit.
- **Approval Inheritance Rule** — `APPROVED` accepts the complete suggestion unchanged; blank replacement fields are intentional.
- **Minimum Sufficient Semantic Resolution** — review stops when the semantic evidence is sufficient for the architectural conclusion being attempted.
- **Scope-Driven Review Depth** — likely scope and boundary cases receive greater review depth than clearly irrelevant exclusions.
- **Semantic Classification–Scope Separation** — what an asset is remains separate from how OuttaMyWay may treat it.
- **Control Eligibility–Representation Relevance Separation** — an asset excluded from active control may remain relevant as assembly geometry or an obstacle.
- **Catalogue–Structure Separation** — semantic catalogue evidence does not establish physical hierarchy, geometry authority or Resolution Path difficulty.

## Accepted from Scope Overlay Architecture

- **Independent Contextual Scope Overlay** — Control Eligibility Profile, Operation Participation, Assembly Relevance and Obstacle Relevance are separate claims whose subjects, evidence and lifetimes may differ.
- **Catalogue Membership–Support Eligibility Separation** — inclusion in the complete Semantic Catalogue does not imply support, controllability, participation, representation structure or test admission.
- **Player Responsibility Boundary** — OuttaMyWay assumes operationally plausible player deployment while retaining unsupported physical Entities when they affect the situation.
- **Base-Game AI Capability Envelope** — supported control investigation uses the unmodified Giants base-game capability baseline; external capability changes do not expand it implicitly.
- **Giants AI Job Configuration** — the complete powered vehicle, attached working assembly, selected job and required working behaviour form the capability subject.
- **Job Admission–Viability Separation** — job acceptance, engine start or brief activity does not prove the complete job configuration can execute.
- **Capability Confirmation Point** — the evidence boundary where Giants successfully exercises the required working behaviour.
- **Control Eligibility Profile** — Scope Overlay support and test-selection knowledge for a Giants AI job configuration.
- **Runtime Control Admissibility** — downstream contextual permission for a proposed OuttaMyWay intervention against one runtime Entity.
- **Control Exclusion Constraint** — authoritative knowledge that prevents unsupported intervention while preserving representation.
- **Observe Broadly, Control Narrowly** — every relevant Entity may be assessed, while only a narrower admissible subset may be controlled.
- **Independent Test Admission** — positive and bounded-negative candidates may be tested independently from support status.
- **Bounded Negative Test Candidate** — an ineligible configuration selected to prove safe exclusion, persistent representation, obstacle assessment and player communication.
- **Presence–Participation Separation** — Field World presence does not establish Operation Participation.
- **Participation–Obstacle Separation** — an Entity may obstruct or influence an Operation without participating in its work.
- **Operational Influence** — the broader relationship by which an Entity affects progress, options or completion without necessarily participating.
- **Participation Transition** — runtime participation changes with the Entity's functional relationship to one Operation.
- **Membership–Relevance Separation** — assembly membership does not automatically establish Assembly Relevance.
- **Behavioural Assembly** — connected Entities and components whose combined state determines relevant behaviour, occupancy, movement or control response.
- **Dynamic Assembly Relevance** — a member's contribution may change with pose, articulation or configuration.
- **Player-Mediated Assembly Transition** — attachment or detachment changes assembly relationships through player action under the current baseline.
- **Occupancy–Obstacle Separation** — physical occupancy becomes obstacle-relevant only relative to another Entity or Operation demand.
- **Assessed-Against Relationship** — Obstacle Relevance is contextual and directional rather than a permanent object type.
- **Entity Obstacle–Environment Obstacle Separation** — catalogue-derived Entity scope remains distinct from environmental obstacle knowledge.
- **Local Resolution–Operational Resolution Separation** — successful immediate avoidance does not prove the Operation can progress or complete.
- **Persistent Spatial Constraint** — stable unavailable space continues to conflict with required or repeatedly requested Operation space.
- **Denied Work Space** — Operation-required space remains unavailable because of a persistent constraint.
- **Recurring Commitment Loop** — a locally valid commitment returns control and materially the same unresolved situation is reconstructed.
- **Completion Blocker** — a persistent constraint prevents or increasingly threatens completion of the original Giants job without external change.

## Deferred after Base-Game Vehicle Semantic Consolidation

- **Scope Overlay implementation model** — machine-readable states, evidence requirements, confidence encoding and runtime refresh rules.
- **Targeted Structural Challenge Profile** — scope-filtered classification of representation difficulty; not an exhaustive pass across all 606 definitions.
- **Paid DLC semantic corpus** — parked until the base-game scope and fixture process is proven.
- **Modded vehicle semantic corpus** — parked because mod variability should not precede a stable base-game method.

## Accepted from Scope Overlay Test-Role Calibration

- **Complete Test Configuration** — the full runtime baseline, fixture, agronomic state, operation, exact powered vehicle, working assembly, required behaviour, pose, claim, contradiction and Evidence Horizon to which a test conclusion belongs.
- **Candidate Ladder** — Test-Role Obligation to Agronomic Role Candidate to Configuration Candidate to Verified Test Configuration.
- **State Sufficiency** — all known prerequisites must be satisfied before a negative result is interpreted as capability evidence.
- **Essential Evidence Horizon** — the earliest point at which the declared claim is decided; completion is required only for a completion-sensitive claim.
- **Coverage Compression** — one controlled session may validly answer several independent claims when each conclusion remains separately bounded.
- **Fixture-Generation Evidence** — a preparation operation may also become evidence when its exact configuration, state and outcome are sufficiently observed.
- **Admission-Rejection Boundary** — agricultural and manual viability can coexist with native Giants AI Control Ineligibility because no suitable job is admitted.
- **Execution-Time State Rejection** — an otherwise viable job is admitted but aborts when a necessary condition not rejected at admission is discovered during execution.
- **Agronomic State Gate** — Control Eligibility of a configuration does not imply operation viability in every crop or field state.
- **Transient Admission Visibility Gap** — a short-lived admitted job may begin and terminate between observer samples; absence from periodic observation does not prove admission never occurred.
- **Material-Chain Boundary Pair** — adjacent upstream and downstream configurations reveal where native Giants AI control stops while agricultural material continuity persists.
- **Material-Chain Control Boundary** — continuity of agricultural material or purpose does not imply continuity of Giants AI Control Eligibility.
- **Non-Tractor Operational Assembly** — a valid Operation participant may be an integrated or specialist powered machine with required attached or integrated working systems.
- **Native Crop-System Exclusion** — Giants AI may reject an otherwise valid assembly because the crop system itself is unsupported.
- **Agronomic Proxy Drift** — a crop characteristic is mistaken for an OuttaMyWay test obligation even though the system neither controls nor reasons about that characteristic.
- **Fixture-to-Assembly Scale Compatibility** — a valid fixture may be poorly scaled for a particular working width or manoeuvring claim; a Reference Field Fixture is not a Universal Field Fixture.
- **Offset Working Envelope** — the active working area is materially displaced from the powered-vehicle trajectory rather than symmetrically centred on it.
- **Trajectory–Work Displacement** — lateral separation between powered-vehicle trajectory and effective working-area centre.
- **Work-Envelope-Anchored Routing** — Giants displaces the powered-vehicle route so an asymmetric working envelope follows the operational boundary.
- **Silent Baseline Transition** — the executable game baseline changes without enough published information to determine which earlier empirical assumptions remain invariant.
- **Runtime Baseline Governance** — empirical evidence remains bound to its declared game and mod versions until targeted revalidation or contradiction changes its status.
- **Patch Impact Watch** — review of GIANTS releases for changes that intersect categories, AI behaviour, physics, SDK/API evidence, crop eligibility or recorded tests.
- **Patch Sentinel Set** — a small representative set of high-value scenarios used for targeted post-patch confidence checks.
- **Evidence Currency State** — Current, Version-bound, Revalidation candidate or Invalidated classification for empirical conclusions.

## Retired or provisional after Scope Overlay Test-Role Calibration

- **Distinct Spatial-Regime Positive as a mandatory role** — retired after the strongest permanent-row candidate was excluded at native job admission; reconsider only when an in-scope native AI regime is evidenced.
- **Persistent/Regrowing Lifecycle as a test role** — retired as Agronomic Proxy Drift; crop biology is not an OuttaMyWay responsibility.
- **Valid Boundary Straddling** — provisional interpretation that legitimate working or physical space may use the immediate field margin while a coarse envelope reports non-containment; requires targeted evidence before changing Full-Envelope Field Containment.
- **Mirrored Working Envelope** — deferred reserve question for reversible implements whose active offset changes side between passes.
