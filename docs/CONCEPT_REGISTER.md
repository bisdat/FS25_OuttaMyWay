# Architectural Concept Register

Review status: reviewed for candidate release v4.6.16.

## Accepted Concepts

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

## Accepted in Prototype 13A design

- **Route-Independent Resolution Contract** — different asset-specific routes produce one common evidence record.
- **Resolution Candidate Set** — every applicable declared route produces a candidate before selection.
- **Resolution Route Convergence** — independent routes reaching one Entity are corroborating evidence.
- **Resolution Route Disagreement** — coherent routes reaching different Entities remain visible as ambiguity.
- **Route–Authority Separation** — discovery route type does not determine physical authority.
- **Disposable Fixture Declaration** — asset-specific Lua tables are diagnostic scaffolding, not production configuration.
- **Runtime Distinctness Proof** — handle inequality is necessary but insufficient; ownership, hierarchy, geometry authority and pose are required.
- **Signature Equality Is Not Aliasing** — symmetric family members may share geometry signatures while remaining distinct Entities.

## Accepted from Prototype 13A validation and TS004 state observation

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

## Deferred after Prototype 13A

- **Prototype 13B Route Discovery** — automated route discovery begins only after declared-route evidence identifies reusable patterns.
