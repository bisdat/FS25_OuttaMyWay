# Current Concept Register

This file records current concept state. It is a thin index, not the owner of detailed semantics; linked architecture owns each full definition and boundary. Historical status changes are recovered from Git, the Decision Log and evidence records. Each concept appears once in its present state, never repeatedly under old release/version headings.

## Status model

- **Accepted** — current architecture supports an independent concept, responsibility or lifecycle.
- **Deferred** — current architecture names a potentially useful concept or question without full architectural authority.
- **Rejected** — current architecture deliberately excludes it; retained only where the exclusion prevents regression.

## Engineering knowledge concepts

| Concept | Status | Current meaning / boundary | Authority |
|---|---|---|---|
| Breadcrumb Completeness | Accepted | Live knowledge is intentionally discoverable through direct-child README navigation. A missing link is an Orphan Signal requiring responsibility review, not automatic proof of staleness or deletion. | [Engineering Architecture](ENGINEERING_ARCHITECTURE.md#predictable-knowledge-placement) |

## Runtime responsibility concepts

| Concept | Status | Current meaning / boundary | Authority |
|---|---|---|---|
| Global OuttaMyWay Runtime | Accepted | Hosts independent field-bounded Operations without cross-field coordination. | [Runtime §1](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#1-global-runtime-and-local-operations) |
| Local Operation | Accepted | Ephemeral lifecycle for one Field World and one to three active supported AI assemblies; not a controller or traffic state. | [Runtime §1](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#1-global-runtime-and-local-operations) |
| Field World Equivalence Authority | Accepted | Resolves immutable Job-Seeded Field World Snapshots as `SAME_FIELD_WORLD`, `DIFFERENT_FIELD_WORLD`, or `UNRESOLVED` from coherent positive evidence; unresolved evidence grants no Operation authority. | [Field World equivalence](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#field-world-equivalence-authority) |
| Job Episode Bootstrap | Accepted | Job-scoped stable-knowledge cache opportunity that grants no traffic responsibility or frozen dynamic intent. | [Runtime §3](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#3-job-episode-bootstrap) |
| active participant | Accepted | Supported assembly with a current qualifying GIANTS AI Job Episode in the Operation. | [Runtime §6](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#6-active-participation-and-physical-relevance) |
| physically relevant entity | Accepted | Entity able to affect active work without being an active cooperative worker. | [Runtime §6](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#6-active-participation-and-physical-relevance) |
| Participation Authority vs Intervention Capability | Accepted | Participation can be certain while manoeuvre representation or capability is unresolved. | [Runtime §4](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#participation-authority-vs-intervention-capability) |
| Completion Leaves Occupancy, Not Responsibility | Accepted | Completion ends membership and job-founded responsibility while the assembly remains Reality. | [Runtime §7](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#7-completion-leaves-occupancy-not-responsibility) |
| Beneficiary / Controlled Subject Separation | Accepted | Intervention may control one entity only to restore another's productive continuity. | [Runtime §8](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#8-beneficiary-and-controlled-subject) |
| Natural Closure | Accepted | Final Job Episode closes the Operation without settlement, parking or cleanup. | [Runtime §9](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#9-natural-closure) |
| Reality | Accepted | Physical/GIANTS-owned world; fresh contradiction outranks stale interpretation. | [Runtime §11](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#reality) |
| Observation | Accepted | Samples evidence and provenance without purpose or actuation. | [Runtime §11](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#observation) |
| Situation Assessment | Accepted | Interprets evidence without acquiring responsibility, actuating or preserving stale prediction. | [Runtime §11](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#situation-assessment) |
| Responsibility Transition | Accepted | Freshly justified episodic responsibility change establishing purpose, not actuation. | [Runtime §12](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#12-responsibility-transition) |
| Current Responsibility | Accepted | Explains why GIANTS AI, Regulation or Resolution Commitment currently persists. | [Runtime §13](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#13-current-responsibility) |
| GIANTS AI | Accepted | Default/attractor owning jobs, routing, turning, work and ordinary continuation. | [Runtime §13](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#giants-ai) |
| Regulation | Accepted | Reversible temporal adjustment with explicit purpose, weak persistence and no route authority. | [Runtime §13](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#regulation) |
| Resolution Commitment | Accepted | Durable accepted obligation persisting while legitimate obligations remain open. | [Runtime §13](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#resolution-commitment) |
| Operation Context / Relationship Responsibility | Accepted | Operation owns common context; temporary interactions/subjects own active responsibility. | [Runtime §14](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#14-operation-context-relationship-responsibility) |
| Pairwise Resolution Exclusivity | Accepted | At most one coupled commitment per Operation, with exactly two active AI participants. | [Runtime §15](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#15-pairwise-resolution-exclusivity) |
| Bounded Authority | Accepted | Determines permitted action from responsibility and Reality without enlarging purpose. | [Runtime §16](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#16-bounded-authority) |
| Control | Accepted | Realises authorised requests through GIANTS mechanisms and reports outcomes. | [Runtime §17](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#17-control) |
| Downstream Authority Monotonicity | Accepted | Downstream may narrow/refuse authority, never enlarge upstream strategy. | [Runtime §18](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#18-downstream-authority-monotonicity) |

## Spatial Negotiation concepts

| Concept | Status | Current meaning / boundary | Authority |
|---|---|---|---|
| Spatial Negotiation | Accepted | Manages temporary space competition while GIANTS retains productive work/navigation. | [Spatial scope](architecture/SPATIAL_NEGOTIATION_MODEL.md#1-scope) |
| Supported Traffic Envelope | Accepted | At most three active AI assemblies of targeted different agronomic roles; player excluded. | [Spatial scope](architecture/SPATIAL_NEGOTIATION_MODEL.md#1-scope) |
| A8 — Productive Forward-Line Certainty | Accepted | `isWorking` supports immediate straight productive continuation, not a later turn. | [Spatial §3](architecture/SPATIAL_NEGOTIATION_MODEL.md#a8--productive-forward-line-certainty) |
| Productive-Certainty Horizon | Accepted | Forward interval over which A8 remains authoritative before transition/contradiction. | [Spatial §3](architecture/SPATIAL_NEGOTIATION_MODEL.md#a8--productive-forward-line-certainty) |
| TURNING Uncertainty Boundary | Accepted | Turning vectors may support concern/Regulation, not establish or preserve Passage. | [Spatial §3](architecture/SPATIAL_NEGOTIATION_MODEL.md#turning-uncertainty-boundary) |
| Resolution Margin | Accepted | Spatial/temporal option capacity Regulation may preserve. | [Spatial §4](architecture/SPATIAL_NEGOTIATION_MODEL.md#4-spatial-purposes-for-regulation) |
| Spatial Constraint Overlay | Accepted | Field option-scarcity evidence that does not itself trigger Regulation. | [Spatial §5](architecture/SPATIAL_NEGOTIATION_MODEL.md#5-spatial-constraint-overlay) |
| Category 1 — Corner | Accepted | Corner with very limited manoeuvre options. | [Spatial §5](architecture/SPATIAL_NEGOTIATION_MODEL.md#5-spatial-constraint-overlay) |
| Category 2 — Headland/Boundary | Accepted | Materially constrained region less severe than a corner. | [Spatial §5](architecture/SPATIAL_NEGOTIATION_MODEL.md#5-spatial-constraint-overlay) |
| Evacuation Preference | Accepted | Preserve constrained occupant's chance to reveal/vacate while cheaper outside space waits. | [Spatial §5](architecture/SPATIAL_NEGOTIATION_MODEL.md#one-worker-inside-one-outside) |
| Foreseeable Passage | Accepted | Opposed A8-valid competing corridors encountering within both certainty horizons. | [Spatial §6](architecture/SPATIAL_NEGOTIATION_MODEL.md#6-cooperative-passage-foreseeability) |
| Cooperative Passage | Accepted | Pairwise Resolution Commitment for jointly dependent Passage obligations. | [Spatial §6](architecture/SPATIAL_NEGOTIATION_MODEL.md#6-cooperative-passage-foreseeability) |
| Tactical Regulation | Accepted | Shapes timing toward theatre viable for the complete downstream Passage lifecycle. | [Spatial §6](architecture/SPATIAL_NEGOTIATION_MODEL.md#tactical-regulation) |
| Viable Passage Interval | Accepted | Encounter positions retaining downstream capture, recovery, restoration and handback space. | [Spatial §6](architecture/SPATIAL_NEGOTIATION_MODEL.md#tactical-regulation) |
| Passage Reserve | Accepted | Required capture/execution space retained after coupled control starts. | [Spatial §7](architecture/SPATIAL_NEGOTIATION_MODEL.md#7-passage-reserve-and-capture) |
| Capture / Disposable Native Approach Margin | Accepted | Approach above reserve is consumable; capture is due before acquisition capacity is lost. | [Spatial §7](architecture/SPATIAL_NEGOTIATION_MODEL.md#7-passage-reserve-and-capture) |
| Interaction Bubble / Bubble | Accepted | Coupled Passage context owning participants/obligations but no persistent pair history. | [Spatial §8](architecture/SPATIAL_NEGOTIATION_MODEL.md#8-cooperative-passage-admission-and-bubble) |
| Bubble Protection | Accepted | Protects coupled obligations/Epoch from independent spatial consumption. | [Spatial §8](architecture/SPATIAL_NEGOTIATION_MODEL.md#8-cooperative-passage-admission-and-bubble) |
| Resolution Epoch | Accepted | Bubble Formation through discharge and dissolution. | [Spatial §8](architecture/SPATIAL_NEGOTIATION_MODEL.md#8-cooperative-passage-admission-and-bubble) |
| Adaptive Execution Geometry / Stale-Guide Non-Authority | Accepted | Obligations persist while unrealised geometry adapts; stale guides lack authority. | [Spatial §9](architecture/SPATIAL_NEGOTIATION_MODEL.md#9-committed-passage-execution) |
| Intent-Revelation Creep | Accepted | Exact 1 km/h intent-revelation policy, not general tuning. | [Spatial §4](architecture/SPATIAL_NEGOTIATION_MODEL.md#4-spatial-purposes-for-regulation) |
| Bullet Time | Accepted | Exact 1 km/h Regulation of the independent third worker for the Epoch. | [Spatial §10](architecture/SPATIAL_NEGOTIATION_MODEL.md#10-third-worker-serialization) |
| Third-Worker Serialization | Accepted | Keeps third worker independent while protecting the pair's decision horizon. | [Spatial §10](architecture/SPATIAL_NEGOTIATION_MODEL.md#10-third-worker-serialization) |
| Last-Handoff Dissolution | Accepted | Dissolves at final GIANTS handback without tail, timeout, cooldown or memory. | [Spatial §11](architecture/SPATIAL_NEGOTIATION_MODEL.md#11-last-handoff-dissolution) |

## Physical Representation concepts

| Concept | Status | Current meaning / boundary | Authority |
|---|---|---|---|
| Planar Collision Semantics | Accepted | Models usable ground-plane occupancy, not hypothetical vertical clearance. | [Planar Collision](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#planar-collision-semantics) |
| Exact Identity and Occupancy Continuity | Accepted | Separates exact identity from useful conservative occupancy. | [Identity](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#exact-identity-and-occupancy-continuity) |
| Physical Representation Portfolio | Accepted | Simultaneous representations selected by assessment fitness, not universal rank. | [Portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#physical-representation-portfolio) |
| Component Footprint Set | Accepted | Positioned footprints for physical components. | [Portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#physical-representation-portfolio) |
| Convex Planar Envelope | Accepted | Conservative polygon between component composition and full rectangle. | [Envelope](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#convex-planar-envelope) |
| Member-Level Rectangle | Accepted | Conservative rectangle for one member. | [Portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#physical-representation-portfolio) |
| Assembly-Level Rectangle | Accepted | Coarsest useful complete-assembly fallback. | [Portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#physical-representation-portfolio) |
| Unknown Occupancy | Accepted | Explicit absence of trustworthy representation. | [Portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#physical-representation-portfolio) |
| Representation Contract | Accepted | Separates Spatial Core, Validity Context and Evidence Quality. | [Contract](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-contract) |
| Spatial Core | Accepted | Geometry, ownership and current pose. | [Spatial Core](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#spatial-core) |
| Validity Context | Accepted | State applicability, ownership, membership, freshness and limits. | [Validity](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#validity-context) |
| Evidence Quality | Accepted | Provenance, completeness, conservatism and safe uses. | [Evidence](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#evidence-quality) |
| Purpose-Scoped Geometry Authority | Accepted | Representation authority is limited to a declared subject/state/purpose/horizon; purpose-specific Transit Passage authority can exist without generic collision-clearance authority. | [Authority](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#purpose-scoped-geometry-authority) |
| Job-Scoped Representation Catalogue | Accepted | Job-start stable templates, expiring with the Episode and invalidated by structural contradiction. | [Catalogue](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#job-scoped-representation-catalogue) |
| Representation Template | Accepted | Declares contributors, local geometry, realisation, applicability and evidence. | [Templates](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-templates-and-pose-realisation) |
| Pose Realisation | Accepted | Applies current state/pose to templates for world-space occupancy. | [Templates](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-templates-and-pose-realisation) |
| Stable Structure–Dynamic Pose Separation | Accepted | Separates job-stable structure from current state and pose. | [Templates](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-templates-and-pose-realisation) |
| Configuration Footprint Authority | Accepted | Current footprint, fitness and sweep—not opaque token—govern assessment. | [Configuration](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#configuration-footprint-authority-and-alternating-working-sides) |
| Family Strategy–Member Parameter Separation | Accepted | Homologous members share strategy while retaining individual parameters/pose. | [Families](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#component-families) |
| Coverage-First Composition | Accepted | Prioritises trustworthy coverage before uniform precision. | [Composition](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#heterogeneous-footprint-composition) |
| Smallest-Scope Fallback | Accepted | Applies fallback only where unresolved occupancy requires it. | [Composition](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#heterogeneous-footprint-composition) |
| Localised Uncertainty | Accepted | Keeps uncertainty attached to affected regions. | [Composition](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#heterogeneous-footprint-composition) |
| Precision–Coverage Separation | Accepted | Treats detail and coverage independently. | [Composition](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#heterogeneous-footprint-composition) |
| Layer-Preserving Composition | Accepted | Retains contributing layers rather than anonymous flattening. | [Composition](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#heterogeneous-footprint-composition) |
| Stationary Configuration Motion | Accepted | Implement moves while base vehicle remains stationary. | [Deployment](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#stable-states-and-deployment) |
| Deployment Clearance Envelope | Accepted | Area potentially occupied between configuration endpoints. | [Deployment](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#stable-states-and-deployment) |
| Deployment Commitment Point | Accepted | Pre-motion point when transition clearance should exist. | [Deployment](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#stable-states-and-deployment) |
| Endpoint–Sweep Distinction | Accepted | Endpoint occupancy need not contain transition occupancy. | [Deployment](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#stable-states-and-deployment) |
| Planar Rigidity | Accepted | Constant relative plan-view geometry permits local-envelope reuse. | [Rigidity](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#planar-rigidity-and-envelope-lifecycle) |
| Planar Relevance Test | Accepted | Change matters when it materially alters ground-plane projection. | [Rigidity](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#planar-rigidity-and-envelope-lifecycle) |
| Deployment Sweep | Accepted | Sweep from configuration motion with stationary base. | [Sweeps](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#deployment-sweep-and-manoeuvre-sweep) |
| Manoeuvre Sweep | Accepted | Sweep from translation, steering and articulation. | [Sweeps](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#deployment-sweep-and-manoeuvre-sweep) |
| Steering-Mode Sweep Dependency | Accepted | Sweep depends on steering mode/kinematics, not midpoint pivot. | [Sweeps](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#deployment-sweep-and-manoeuvre-sweep) |
| Inventory Closure | Accepted | All relevant components known; does not prove represented coverage. | [Closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#coverage-closure) |
| Coverage Closure | Accepted | All collision-relevant occupancy represented for stated subject/state. | [Closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#coverage-closure) |
| Enumerative Closure | Accepted | Inventory plus representation/pose for every active component. | [Closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#coverage-closure) |
| Enclosing Closure | Accepted | Proven conservative geometry contains the subject. | [Closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#coverage-closure) |
| Hybrid Closure | Accepted | Precise regions plus fallback covering unresolved remainder. | [Closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#coverage-closure) |
| Structural Coverage Closure | Accepted | Catalogue templates cover a stated physical state. | [Structural closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#structural-and-realised-coverage-closure) |
| Realised Coverage Closure | Accepted | Applicable templates have current valid poses. | [Structural closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#structural-and-realised-coverage-closure) |
| Coverage Ledger | Accepted | Records closure scope, basis, contributors, gaps, risk, pose and status. | [Structural closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#structural-and-realised-coverage-closure) |
| Known-Coverage Trap | Accepted | All discovered represented does not prove none remain undiscovered. | [Closure](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#coverage-closure) |
| Conflict Excluded | Accepted | Current non-underestimating closed coverage supports scoped separation. | [Claims](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#layered-occupancy-claims) |
| Conflict Supported | Accepted | Geometry positively supports overlap/convergence. | [Claims](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#layered-occupancy-claims) |
| Conflict Possible | Accepted | Conservative/incomplete coverage leaves a credible conflict route. | [Claims](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#layered-occupancy-claims) |
| Clearance Unresolved | Accepted | Evidence establishes neither conflict nor safe separation. | [Claims](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#layered-occupancy-claims) |
| Scope-Local Non-Exclusion | Accepted | Gaps withhold all-clear only where relevant to scoped assessment. | [Claims](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#layered-occupancy-claims) |
| Orthogonal Physical State Dimensions | Accepted | Deployment, vertical configuration, contact, engagement and phase are distinct. | [State](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#orthogonal-physical-state-dimensions) |
| Configuration–Function Separation | Accepted | Configuration/pose does not universally establish function. | [Raise/lower](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#raiselower-semantic-diversity) |
| Contact-Dependent Functional Engagement | Accepted | Soil-contact implements require realised contact for ground operation. | [Raise/lower](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#raiselower-semantic-diversity) |
| Commanded State–Realised Contact Separation | Accepted | Lower command does not prove realised contact/engagement. | [Raise/lower](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#raiselower-semantic-diversity) |
| Player Obstacle Boundary | Accepted | Player contributes occupancy; player policy is not modelled. | [Player](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#player-obstacle-boundary) |
| Resolution Path | Accepted | Candidate proposal provenance grants no physical/navigation authority. | [Path](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#resolution-path-terminology) |
| Resolution Contract | Accepted | Evidence floor for defensible runtime Entity identity. | [Resolution](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#resolution-contract-and-claim-set) |
| Resolution Claim Set | Accepted | Records identity, geometry, pose, evidence, dependencies and limits. | [Resolution](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#resolution-contract-and-claim-set) |
| Evidence Contribution Separation | Accepted | Evidence supports distinct claims; weak corroboration cannot defeat contradiction. | [Evidence model](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#resolution-evidence-model) |
| Claim-Specific Confidence | Accepted | Keeps identity, geometry, pose, path and completeness confidence separate. | [Evidence model](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#resolution-evidence-model) |
| Discovery Independence | Accepted | Assessment consumes claims without reconstructing discovery mechanics. | [Provenance](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#discovery-independence-and-resolution-path-provenance) |
| Functional Class–Structural Representation Separation | Accepted | Gameplay class cannot establish structure, coverage, articulation or path. | [Class separation](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#functional-classstructural-representation-separation) |
| Assessment Representation Contract | Accepted | Supplies most informative defensible account within budget, preserving limits. | [Assessment](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#assessment-representation-contract) |
| Assessment Representation Portfolio | Accepted | Composes representations/unknown remainder at smallest useful scope. | [Assessment portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#assessment-representation-portfolio) |
| Minimum Sufficient Defensible Portfolio | Accepted | Seeks enough defensible information for the question, not maximum detail. | [Assessment portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#assessment-representation-portfolio) |
| Conclusion-Relative Sufficiency | Accepted | Sufficiency depends on the conclusion sought. | [Assessment portfolio](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#assessment-representation-portfolio) |
| Representation Passport | Accepted | Self-describes scope, provenance, dependencies, coverage, age, cost and permissions. | [Passport](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-passport-and-self-description) |
| Representation Claim Permission | Accepted | Makes downstream-use authority explicit. | [Passport](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-passport-and-self-description) |
| Demonstrated Traversability | Accepted | Actual assembly occupation/traversal may support bounded local accommodation conclusions only within a materially equivalent subject, configuration, environment, domain and movement basis. | [Demonstrated Traversability](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#demonstrated-traversability) |
| Representation Cost Profile | Accepted | Keeps acquisition, refresh, projection, invalidation and delay costs separate from fitness. | [Cost](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-cost-profile) |
| Admissibility Before Optimisation | Accepted | Unsupported cheap geometry cannot defeat defensible evidence. | [Cost](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#representation-cost-profile) |
| Situation Assessment as Representation-Fitness Arbiter | Accepted | Assessment decides fitness for current question, futures and horizon. | [Fitness](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#situation-assessment-as-representation-fitness-arbiter) |
| Assessment-Relative Staleness | Accepted | Age restricts permissions by question rather than forcing discard. | [Fitness](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#situation-assessment-as-representation-fitness-arbiter) |
| Dependency-Scoped Invalidation | Accepted | Change invalidates only dependent claims. | [Invalidation](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#dependency-scoped-invalidation) |
| Smallest-Scope Refresh | Accepted | Refreshes only affected identity, pose, footprint, sweep, structure or projection. | [Invalidation](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#dependency-scoped-invalidation) |
| GIANTS Completion Acceptance Boundary | Accepted | Accepts GIANTS job-end disposition without parking/post-job navigation. | [Completion](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#giants-completion-acceptance-boundary) |
| Operational Membership–Spatial Relevance Separation | Accepted | Completion ends membership/motion assumptions while relevance may persist. | [Completion](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#giants-completion-acceptance-boundary) |
| Role-State Invalidation | Accepted | Completion invalidates active role/motion expectation, preserving identity/geometry. | [Completion](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#giants-completion-acceptance-boundary) |
| Persistent Completed-Worker Obstacle | Accepted | Completed nonmember occupancy remains while it can affect active work. | [Completion](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#giants-completion-acceptance-boundary) |

## Deferred concepts

| Concept | Status | Current meaning / boundary | Authority |
|---|---|---|---|
| Envelope Anchor Selection | Deferred | No universal conservative-envelope anchor is selected. | [Envelope](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#convex-planar-envelope) |
| Detailed Manoeuvre Sweep Construction | Deferred | Turning centre/radius, articulation and steering-kinematics construction remain evidence questions. | [Sweeps](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#deployment-sweep-and-manoeuvre-sweep) |
| Deferred Post-Job Configuration Normalisation | Deferred | In-place footprint reduction may be examined later; no behaviour is authorised. | [Completion](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#deferred-post-job-configuration-normalisation) |
| Parked Assessment Deadline Escalation | Deferred | Future Decision work may examine failsafe response to unrefreshable knowledge; no policy selected. | [Deadline](architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#parked-assessment-deadline-escalation) |

## Current rejected / excluded concepts

| Concept | Status | Current meaning / boundary | Authority |
|---|---|---|---|
| Generic `WAITING_FOR_EVIDENCE` / `SETTLING` Responsibility Lifecycle | Rejected | Uncertainty/termination do not create generic Operation lifecycle states. | [Runtime boundaries](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#19-architectural-boundaries) |
| Persistent Pair-First / Encounter History | Rejected | Temporary responsibility leaves no pair history/object after ending. | [Runtime §14](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#14-operation-context-relationship-responsibility) |
| Completed-Worker Parking Duty / Terminal Settlement Lifecycle | Rejected | Completion creates no parking, tidying or settlement phase. | [Runtime §7](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#7-completion-leaves-occupancy-not-responsibility) |
| Universal Fixed-Distance Passage or Commitment Authority | Rejected | Historical 80 m locality is not authority and gets no universal replacement. | [Spatial §7](architecture/SPATIAL_NEGOTIATION_MODEL.md#7-passage-reserve-and-capture) |
| Productive History / Rook / Dense Future-Route Reconstruction | Rejected | Reconstructed routes gain no governing authority. | [Spatial §3](architecture/SPATIAL_NEGOTIATION_MODEL.md#evidence-precedence) |
| Transient `TURNING` Vectors as Cooperative Passage Authority | Rejected | Turning vectors cannot independently establish Passage. | [Spatial §3](architecture/SPATIAL_NEGOTIATION_MODEL.md#turning-uncertainty-boundary) |
| Regulation as Mandatory Passage Precursor | Rejected | Passage may be justified directly; Regulation is optional/purpose-specific. | [Runtime §12](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#12-responsibility-transition) |
| Three-Worker or Concurrent Coupled Pairwise Resolution Commitments | Rejected | Only one coupled two-participant commitment may exist per Operation. | [Runtime §15](architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md#15-pairwise-resolution-exclusivity) |
| Same-Agronomy Fleet Coordination or More-Than-Three Active-AI Obligation | Rejected | Outside supported Spatial Negotiation scope. | [Spatial non-goals](architecture/SPATIAL_NEGOTIATION_MODEL.md#14-spatial-non-goals) |
