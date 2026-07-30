# Glossary

## Reality
The world as it exists independently of OuttaMyWay's observations or interpretation.

## Observation
A sampled fact about Reality available to the system. Observations may be incomplete, delayed or uncertain.

## Knowledge
The system's evolving estimate of Reality reconstructed from observations.

## Situation Space
The structured set of possible situations relevant to autonomous work, including entities, states and relationships.

## Current Situation
The system's present estimated point within Situation Space. It is Knowledge, not Reality itself.

## Situation Assessment
The transformation that interprets observations and maintains the most plausible Current Situation.

## Future Space
The set of plausible future situations currently under consideration.

## Action Space
The set of actions currently available to an entity or system.

## Entity
A provisional general label for something that participates in Situation Space. The label remains under review.

## Conflict Zone
A derived spatial-temporal region in which intended motion cannot safely coexist without coordination.

## Field World
The bounded physical world defined by one field boundary polygon for one Operation. It is not the entire map.

## Field World Membership
The classification that physical geometry intersects the Field World. Membership does not imply active participation or current relevance.

## Operational Membership
Active participation in one Operation. Membership is dynamic and may end while the Entity remains physically present inside the Field World.

## Situation Relevance
The dynamic relationship by which a Field World Member can affect an Operation member or a plausible future.

## Geometry Domain Separation
The separation of GIANTS Collision Geometry, Physical Occupancy Envelope, Working Footprint, Configuration Transition Sweep and Projected Motion Sweep.

## GIANTS Collision Geometry
Physics geometry attached to model components in the GIANTS modelling environment and game runtime. It is evidence of physical contact and is not synonymous with visible width or agricultural working width.

## Physical Occupancy Envelope
The conservative ground-plane area currently occupied by the complete vehicle–implement Entity.

## Working Footprint
The ground area receiving agricultural work. It may differ from physical occupancy.

## No Silent Under-Approximation
The invariant that uncertain or incomplete geometry remains explicit rather than being represented as exact or smaller than the available evidence supports.

## Geometry Family
The purchased/configured model variant that selects the applicable collision-node, animation and working-width family. It does not describe current fold pose.

## Physical Pose
The current spatial arrangement of an Entity's physical components, including folded, transitional, deployed and articulated states.

## Model-Derived Collision Catalogue
Source-fingerprinted static knowledge of physical collision-node identity, hierarchy, configuration membership, filters and, when available, local mesh extents.

## Collision Mesh Extraction Gap
The current inability to extract trustworthy local collision-mesh bounds from the binary `.i3d.shapes` asset in the available environment.

## Component-Local Extent
A static conservative representation of one identified physical component's geometry in a stable local frame, before live pose transforms place it in world space.

## Component-Local Sphere Bridge
The runtime-validated connection from source physical collision identity through a correctly resolved runtime collision node to a conservative component-local bounding sphere placed by authoritative live pose. Source asset `shapeId` is provenance metadata until selector semantics are independently established.

## Shape-Bound Capability Blind Spot
The discovery that Prototype 07's negative runtime-bound result did not cover the documented per-shape bounding-sphere API family or its two-argument identity semantics.

## Extent Truth–Utility Separation
The distinction between a geometric extent being trustworthy and being sufficiently precise for its proposed operational use.

## Sphere Precision Tax
The conservative empty space added when a bounding sphere represents an elongated or tapered physical component.

## Geometry Availability–Physical Membership Separation
The rule that geometry-bound availability does not establish collision membership or current configuration inclusion.

## Root-Entity Sphere Aliasing
The observed behaviour where source asset `shapeId` variations paired with a vehicle root all return the same root-Entity geometry sphere rather than selecting descendant shapes.

## Self-Coherence Blind Spot
The inability of local/general/world bound agreement to prove that the intended source shape or runtime Entity was selected.

## Source Shape Identity
Asset-side identity consisting of name, hierarchy, source `shapeId`, collision metadata and configuration membership.

## Runtime Entity Identity
The instantiated engine node that owns current geometry and live pose.

## Geometry-Bound Identity
The geometry actually returned by a shape-bound API invocation.

## Source-to-Runtime Shape Resolution
The bridge that associates one source collision identity with the instantiated runtime Entity that owns its geometry and pose.

## Runtime Entity Geometry Authority
The Prototype 11 hypothesis that the first shape-bound API argument selects the geometry owner while known second-argument variants are non-selective on that Entity.

## Current Physical Set
All source-identified physical shapes active in the current Geometry Family together with permanent physical shapes. Runtime resolution of each member is a separate requirement.


## Physical Assembly
The current runtime object graph whose powered vehicle and attached implements together form the physical working combination associated with one operational worker.

## Physical Assembly Search Boundary
The resolution order from operational worker to current assembly to individual member-local asset/runtime hierarchies.

## Attached-Assembly Replication
The repeated Prototype 12 discovery of coherent two-member attached assemblies across materially different tractor–implement combinations.

## Working-State Motion Divergence
A condition where GIANTS reports active `WORKING` state while measured physical movement does not demonstrate continued progression.

## Member-Local Physical Resolution
The proposed mapping of source physical collision identities to runtime Entities independently inside each Physical Assembly member.

## Stable Interior Animation State
A stable physical pose represented by a numerical animation value that lies between the animation's endpoints. Interior value does not imply ongoing transition.

## Compound Animation Timeline
An asset implementation timeline that encodes more than one architectural state dimension, such as deployment and vertical configuration.

## Deployment State
Whether a physical assembly is folded, extended or otherwise deployed. It is separate from vertical configuration and functional engagement.

## Vertical Configuration
The raised, lowered or intermediate physical height configuration of an implement or implement subassembly.

## Terrain Contact
Whether the relevant working elements are physically contacting terrain. It may be required for direct-soil-contact work or not applicable to a non-contact implement.

## Functional Engagement
Whether an implement is physically configured and able to perform its intended operation. It is not universally equivalent to `LOWERED` or to GIANTS AI `WORKING` phase.

## Extended Manoeuvring State
An observed AI state in which an implement remains deployed but is raised while the assembly positions or repositions.

## Work Engagement Cycle
The repeated within-job sequence of raising a deployed direct-soil-contact implement for manoeuvring and lowering it for work.

## Operational Phase–Physical State Separation
The rule that GIANTS AI activity phase is contextual evidence and does not establish the implement's realised physical pose.

## Raise/Lower Semantic Diversity
The implement-family-specific meaning of vertical movement. Lowering may establish soil contact, may merely change boom height, or may have another physical role.

## Configuration–Function Separation
The distinction between changing physical pose and changing the gameplay function currently performed.

## Contact-Dependent Functional Engagement
The requirement that some direct-soil-contact implements establish realised terrain contact before their intended ground operation can occur.

## Commanded State–Realised Contact Separation
The distinction between a command or animation target to lower and the observed fact of terrain contact.

## Player Obstacle Boundary
The scope rule that player-controlled assemblies are represented only as potential physical obstacles to AI workers, not as cooperative workers whose behaviour is modelled or controlled.

## Resolution Path
A method that proposes a runtime Entity candidate from source, component, mapping and assembly relationships; distinct from a worker navigation route.

## Resolution Contract
The mandatory evidence required before one source physical shape may be classified `RESOLVED`.

## Resolution Claim Set
The bounded source identity, runtime identity, geometry authority, pose authority, evidence, validity dependencies and explicit limits produced by resolution.

## Resolution Path Convergence
Corroborating evidence produced when independent Resolution Paths reach one coherent runtime Entity.

## Resolution Path Disagreement
An ambiguity state in which coherent Resolution Paths reach different runtime Entities.

## Resolution Path–Authority Separation
The rule that candidate-generation mechanism does not grant physical authority.

## Mandatory Evidence Floor
Candidate existence, assembly and structural coherence, Entity-local geometry authority, current pose authority and no unresolved contradictory runtime identity.

## Corroboration Without Gatekeeping
The rule that convergence, negative controls, motion, symmetry and repeated observation strengthen claims when available but are not universal resolution requirements.

## Claim-Specific Confidence
Confidence retained separately for identity, geometry, pose, freshness, path corroboration and closure rather than collapsed into one score.

## Functional Class–Structural Representation Separation
The distinction between what an implement does in gameplay and how its physical assembly is represented at runtime.

## Class as Context, Not Contract
The rule that gameplay class may guide questions but cannot establish physical structure or Resolution Path authority.

## Best Available Defensible Representation
The most informative defensible spatial account achievable within the assessment budget for the current question and future horizon.

## Assessment-Horizon Fitness
Suitability of a representation for the plausible futures and time horizon currently being assessed.

## Assessment Representation Portfolio
A complementary collection of exact, derived, fallback and unknown spatial layers supplied to Situation Assessment.

## Minimum Sufficient Defensible Portfolio
The least-cost admissible portfolio sufficient for the assessment conclusion being attempted.

## Conclusion-Relative Sufficiency
The rule that representation adequacy depends on whether assessment seeks conflict support, possibility, exclusion or unresolved clearance.

## Representation Claim Permission
The explicit assessment conclusions that one representation's evidence is allowed to support.

## Representation Passport
A representation's self-description of scope, authority, validity, coverage, freshness, cost and permitted conclusions.

## Self-Describing Representation
A representation that downstream assessment can use without reconstructing its discovery mechanism.

## Discovery Independence
The rule that representations are consumed according to established claims rather than lookup mechanics.

## Representation Cost Profile
The multidimensional acquisition, refresh, projection, volatility, composition and delay-exposure cost of a representation.

## Admissibility Before Optimisation
The rule that cost comparison operates only among defensible representations.

## Dependency-Scoped Invalidation
Invalidation of only the representation claims that depended on a materially changed state.

## Smallest-Scope Refresh
Refresh limited to the affected projection, pose, member or assembly rather than indiscriminate rebuilding.

## Assessment-Relative Staleness
The condition in which evidence is no longer adequate for the current question and horizon, rather than merely old by a fixed clock threshold.

## Situation Assessment as Representation-Fitness Arbiter
The responsibility of Situation Assessment to judge representation usability and refresh need while producing Knowledge only.

## Completed Worker Obstacle Transition
The role change from active AI worker to non-member physical obstacle when GIANTS completes the job.

## GIANTS Completion Acceptance Boundary
The policy that OuttaMyWay accepts GIANTS' final job location and configuration and does not relocate the completed vehicle.

## No Correct Parking Inference
The finding that no universally safe or player-preferred post-job destination can be inferred.

## Persistent Completed-Worker Obstacle
A completed assembly retained in the Operational Picture while its physical occupancy can affect remaining workers.

## Post-Job Configuration Normalisation
Deferred possible in-place raising or folding after job completion to reduce obstruction without relocating the vehicle.

## Assessment Deadline Escalation
Deferred Decision Engine handling when useful knowledge cannot be refreshed before the available decision time expires.

## Planar Collision Semantics
Physical occupancy is represented in collision-relevant ground-plane projection because GIANTS AI does not exploit hypothetical vertical underpass clearance.

## Physical Representation Portfolio
The set of exact, derived and fallback plan-view representations simultaneously available for one subject.

## Component Footprint Set
Positioned plan-view component shapes whose union represents current assembly occupancy at component precision.

## Convex Planar Envelope
A conservative simplified polygon between component composition and a full width-by-breadth rectangle.

## Spatial Core
The geometry, ownership and current pose asserted by a Physical Representation.

## Validity Context
The state, ownership, freshness and evidence conditions under which a representation may still be used.

## Evidence Quality
The provenance, completeness, conservatism and Fitness Profile that limit conclusions drawn from a representation.

## Job-Scoped Representation Catalogue
The stable catalogue of Representation Templates constructed at AI job start and expired at job end.

## Representation Template
A stable local definition from which current plan-view geometry is produced.

## Pose Realisation
Application of current physical state and plan-view pose to Representation Templates.

## Component Family
Homologous components sharing representation strategy while retaining individual parameters.

## Heterogeneous Footprint Composition
Composition of exact, derived and fallback representations within one assembly without forcing uniform precision.

## Coverage-First Composition
The rule that complete trustworthy coverage takes priority over equal local precision.

## Stationary Configuration Motion
Implement geometry motion while the AI-controlled base vehicle remains stationary.

## Deployment Clearance Envelope
The plan-view area that may be occupied while moving between folded and working states.

## Deployment Commitment Point
The pre-deployment boundary at which clearance for expected configuration motion must already be established.

## Endpoint–Sweep Distinction
The rule that stable endpoint footprints do not necessarily contain intermediate swept occupancy.

## Planar Rigidity
Constancy of relative plan-view geometry despite movement that does not materially change ground-plane projection.

## Steering-Mode Sweep Dependency
Dependence of manoeuvre sweep on active steering mode and actual kinematics.

## Inventory Closure
Evidence that all relevant physical components have been discovered for a stated scope and state.

## Coverage Closure
Evidence that all relevant plan-view occupancy is represented for a stated scope and state.

## Structural Coverage Closure
Catalogue-level evidence that applicable templates cover all relevant occupancy.

## Realised Coverage Closure
Structural Coverage Closure with current valid pose for every applicable representation.

## Coverage Ledger
The evidence record supporting and limiting one Coverage Closure claim.

## Known-Coverage Trap
The false inference that every discovered component being represented proves complete inventory.

## Clearance Unresolved
Knowledge that available evidence establishes neither conflict nor safe clearance.

## Scope-Local Non-Exclusion
A coverage gap removes authority to exclude conflict only where that gap could affect the assessment.

## Operational Entity–Physical Assembly Separation
The distinction between the Entity that owns the AI job and the potentially multi-member runtime assembly whose physical geometry must eventually be represented.

## Mapping-Key Locality
The rule that an asset mapping key has meaning only within the asset that defines it; names such as `colPart` are not universal FS25 semantics.

## Fixture-Absence Warning Noise
A diagnostic defect where the intentional absence of one prototype's vehicle fixture is repeatedly reported as a warning during a different experiment.

## Second-Argument Non-Authority
The Prototype 11 finding that changing the second `shapeId` argument did not redirect geometry selection for the tested runtime Entities and sphere APIs. Wider engine semantics remain unknown.

## Operational Collision Envelope
The complete collision geometry of the vehicle plus every attached or towed implement, including configuration-dependent maximum extent and projected swept geometry.

## Full-Envelope Field Containment
The invariant that the complete Operational Collision Envelope remains wholly inside the field polygon at all times.

## Conflict Relevance Transition
A provisional change in the Current Situation whereby an Entity or object becomes a participant in a plausible conflict rather than merely being present nearby. The concept remains Deferred pending prototype evidence.

## Conflict Emergence Point
The provisional earliest observed point at which previously independent plausible trajectories form a shared Conflict Zone. Prototype 01 tests whether this point can be identified before immediate physical conflict.

## Trajectory Settlement
A provisional condition in which observed motion remains sufficiently consistent for a near-future trajectory to be treated as stable knowledge rather than a temporary manoeuvre projection.

## Conflict Confidence
A provisional relationship-level assessment that a projected Conflict Zone is persistent rather than a transient result of manoeuvring or observation variability.

## Conflict Formation Window
The provisional interval in which changing trajectories are forming a possible conflict but have not yet produced stable conflict knowledge.

## Sequential Manoeuvre Conflict
An encounter in which one Entity's manoeuvre establishes one future trajectory and another Entity's later or overlapping manoeuvre completes the shared conflict trajectory. The first TS001 evidence is consistent with this interpretation but does not assign fault.

## Passive Boundary Ordering Gap
An implementation condition in which a control consumer executes before an observer-only runtime guard, so passivity is declared but not structurally guaranteed. Discovered and corrected during Prototype 01 preparation.

## Commitment Point
The point at which preserving the existing course becomes more disruptive or risky than committing to a coordinated response.

## Traffic Picture
Legacy descriptive term for the current understanding of nearby traffic. Prefer Current Situation or Operational Picture when referring to the maintained architectural knowledge.

## Operational Picture
The existing name for the single current interpretation of decision-relevant observations maintained by Situation Assessment. Its relationship to Current Situation remains under review.

## Candidate Option Preservation Window
A provisional observed interval in which waiting by one participant might preserve alternatives while a Progress Entity reveals intent.

## Progress Entity
The participant allowed to continue so Reality can generate the evidence required for reassessment.

## Intent Revelation Point
The provisional point at which an Entity's resulting trajectory becomes settled enough to provide useful knowledge to other participants.

## Response Margin
The remaining time and manoeuvre freedom after intent revelation. No single stopping estimate is accepted as its complete representation.

## Alternate Exhaustion Point
A provisional boundary after which ordinary graceful alternatives appear to have been consumed.

## Information-Gaining Delay
A possible temporary Commitment whose purpose is to gain useful evidence before a stronger Commitment is made.

## Progress Preservation Invariant
An Information-Gaining Delay must leave at least one relevant moving participant able to generate its completion evidence.

## Observation Deadlock
A soft lock produced when all relevant moving participants are held while the wait can complete only through movement that reveals intent.

## Mutual Commitment Trap
A provisional situation in which independently acting participants commit before either can adapt to the other's revealed intention.

## Local Intent Horizon
The interval during which a settled trajectory remains useful evidence of an Entity's immediate path, without implying knowledge of its complete route.

## Intent Expiry
The transition by which locally revealed intent becomes stale because the Entity begins another manoeuvre, detaches or is no longer observed reliably.

## Encounter Chain
A sequence of linked conflicts in which changing one encounter's timing or form does not remove the underlying coordination problem.

## Safe Release Point
A provisional retrospective boundary at which release remains clear through a defined continuation horizon.

## Continuation Safety Horizon
The bounded future continuation that must remain clear before release can be considered safe. Prototype 04 uses the next observed repositioning manoeuvre and subsequent settlement.

## Commitment
A persistent intention with explicit creation, maintenance, completion and cancellation lifecycle semantics.

## Outcome Observation
An authoritative report of what Control attempted, what effect was observed and what capability was demonstrated or disproved.

## Intervention Capability Model
Control's validated account of the influence currently available to the system.

## Realizable Response Space
The overlap between what Situation Assessment says the world permits and what Control can actually influence.

## Autonomous Continuity
The continued progress of autonomous work toward completion without unnecessary player attention.

## Player Trust
The player's confidence that autonomous workers can complete their work without supervision.

## Decision Output — Name Pending
The realizable, least-disruptive change selected by Decision when passivity is no longer justified. Remedy and Variance remain candidate names, not accepted terminology.


## Engineering Increment
A bounded unit of engineering purpose that closes at a coherent breakpoint rather than at a time, chat or version boundary.

## Engineering Consolidation
Human-governed promotion and review of durable knowledge into authoritative repository homes.

## Engineering Intent
The declarative description of the accepted repository change supplied to Candidate Production instead of direct repository editing by the consolidation author.

## Canonical Repository Snapshot
The exact immutable canonical package and fingerprint used as the baseline for one Candidate Production run. It is distinct from an editable Git working tree.

## Repository Transformation
The controlled application of declared Engineering Intent to one exact Canonical Repository Snapshot, producing observable change and validation evidence without conferring authority.

## Candidate Determinism
The requirement that the same exact Canonical Repository Snapshot and fingerprint-bound Engineering Intent produce a byte-identical candidate package across supported execution platforms.

## Repository Transition
The governed movement from exact canonical baseline through Release Candidate to explicit Canonicalisation.

## Release Candidate
The governed unit comprising the candidate repository, provenance, declared transformation, findings and evidence.

## Repository Authority State
The authority classification Working, Release Candidate or Canonical; it is distinct from version identity and Git working state.

## Engineering Transformation
Substantive repository change performed during Candidate Production from the exact canonical baseline.

## Authority Transformation
The substantively pure candidate-to-canonical transformation performed only after validation, accepted review and explicit Canonicalisation.

## Canonicalisation
The repository owner's explicit declaration that the exact reviewed candidate is canonical.

## Vehicle semantic research vocabulary

### Semantic Profile

A reviewed description of an asset's primary family, primary role, secondary roles and orthogonal capabilities, with preserved source and review provenance.

### Primary Family

A broad operational domain used to organise semantic roles without defining OuttaMyWay scope or physical structure.

### Primary Role

The principal real-world purpose of an asset for the current semantic catalogue.

### Secondary Role

A genuine additional purpose that remains subordinate to the selected primary role.

### Capability

An additional ability or configuration-dependent function that does not replace the asset's primary semantic identity.

### Effective Definition Boundary

The declared limit of Raw Definition Evidence plus Selected-Field Inheritance Projection. It prevents a partial catalogue projection from being presented as the complete GIANTS parent-file merge result.

### Runtime Localisation Authority

The observed authority of the running GIANTS localisation service to provide displayed text when the underlying readable definition source is unavailable.

### Function Cohort

A review group formed from a shared declared-function set. It is an efficiency mechanism, not a guaranteed semantic decision.

### Review Unit

The smallest grouped semantic profile presented for one human decision after evidence splits a Function Cohort where necessary.

### Approval Inheritance Rule

The rule that `APPROVED` accepts every suggested semantic field unchanged, including intentional blanks, while `AMENDED` supplies a complete replacement profile.

### Minimum Sufficient Semantic Resolution

The least semantic detail required to support the current scope, representation or fixture-selection conclusion defensibly.

### Scope-Driven Review Depth

The practice of investing full review in likely or boundary cases, sufficient review in representation-relevant exclusions and coarse review where no architectural conclusion can change.

### Scope Overlay

The accepted contextual knowledge layer that assigns Control Eligibility Profile, Operation Participation, Assembly Relevance and Obstacle Relevance independently from semantic identity. It is not one scalar in-scope/out-of-scope property.

### Control Eligibility Profile

Scope Overlay knowledge describing whether a Giants AI job configuration belongs inside the supported control-investigation envelope under the declared capability baseline.

### Runtime Control Admissibility

The downstream contextual conclusion that a proposed OuttaMyWay intervention may target a particular runtime Entity now.

### Control Exclusion Constraint

Authoritative Operational Picture knowledge that an Entity or configuration must not be selected for unsupported intervention while remaining represented for assessment.

### Base-Game AI Capability Envelope

The set of working configurations executable by unmodified Giants AI under the declared base-game baseline.

### Giants AI Job Configuration

The complete powered vehicle, attached working assembly, selected Giants AI job and required working behaviour considered as one capability subject.

### Capability Confirmation Point

The first evidence point at which Giants AI successfully controls the working behaviour required by the complete job configuration, rather than merely admitting and initialising the job.

### Player Responsibility Boundary

The support boundary that assumes operationally reasonable player deployment without making unsupported physical presence invisible.

### Operational Influence

The contextual relationship by which an Entity affects an Operation's progress, options or completion without necessarily participating in its work.

### Behavioural Assembly

The connected runtime Entities and components whose combined state determines relevant working behaviour, occupied space, future movement or control response.

### Bounded Negative Test Candidate

A known or expected control-ineligible configuration explicitly selected to validate safe exclusion, persistent representation, obstacle assessment and player communication without expanding support.

### Persistent Spatial Constraint

A continuing incompatibility between stable occupied or unavailable space and Operation space that remains required or repeatedly requested.

### Denied Work Space

Operation-required or repeatedly requested space that remains unavailable because of a Persistent Spatial Constraint.

### Recurring Commitment Loop

Repeated application of a locally valid commitment followed by Giants reconstruction of a materially equivalent unresolved situation.

### Completion Blocker

A Persistent Spatial Constraint that prevents, or increasingly appears likely to prevent, completion of the original Giants AI job without an external change.

### Catalogue–Structure Separation

The rule that semantic catalogue membership cannot establish runtime hierarchy, geometry authority, occupancy representation or Resolution Path difficulty.

## Scope Overlay Test Calibration Vocabulary

### Complete Test Configuration

The complete runtime baseline, fixture, agronomic state, operation, exact powered vehicle, working assembly, required behaviour, pose, claim, contradiction and Evidence Horizon to which a test conclusion belongs.

### State Sufficiency

The requirement that all known operation prerequisites are satisfied before a negative result is interpreted as capability evidence.

### Essential Evidence Horizon

The earliest point at which the declared test claim is decided. Full completion is required only when the claim depends on a late lifecycle event.

### Coverage Compression

The valid acquisition of several separately bounded evidence claims from one controlled session.

### Admission-Rejection Boundary

The boundary where an agriculturally and manually valid configuration remains outside native Giants AI Control Eligibility because no suitable job is admitted.

### Execution-Time State Rejection

Failure after admission when a necessary condition not rejected at job creation is discovered to be unsatisfied during execution.

### Agronomic State Gate

The contextual crop or field-state condition that can make a particular operation non-viable without making the underlying configuration generally Control Ineligible.

### Material-Chain Control Boundary

The point at which agricultural material or process continuity continues but native Giants AI Control Eligibility does not.

### Native Crop-System Exclusion

Native Giants AI rejection caused by an unsupported crop system rather than by manual invalidity of the assembly.

### Agronomic Proxy Drift

Mistaking a crop property for a system test obligation even though OuttaMyWay neither controls nor reasons about that property.

### Offset Working Envelope

An active working area materially displaced to one side of the powered-vehicle trajectory.

### Trajectory–Work Displacement

The lateral separation between the powered-vehicle trajectory and the effective centre of the active working area.

### Work-Envelope-Anchored Routing

Routing in which Giants displaces the powered-vehicle path so an asymmetric implement's effective work area follows the required operational boundary.

### Silent Baseline Transition

A game executable change without enough published information to determine which earlier empirical assumptions remain invariant.

### Patch Impact Watch

The governance process that reviews GIANTS changes for intersections with recorded architecture, tests and supported categories.

### Patch Sentinel Set

A small representative scenario set used for targeted revalidation after a relevant game change.

### Evidence Currency State

One of Current, Version-bound, Revalidation candidate or Invalidated, describing how an empirical conclusion relates to the active runtime baseline.

### Valid Boundary Straddling

A provisional interpretation in which a legitimate working or physical envelope uses the immediate field margin while a coarse representation reports non-containment. It is not yet accepted as a replacement for Full-Envelope Field Containment.

