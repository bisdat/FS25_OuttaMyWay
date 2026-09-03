# Physical Representation Architecture

## Purpose

This document defines how OuttaMyWay represents collision-relevant plan-view occupancy and what conclusions those representations may support. It separates exact physical identity from useful occupancy, preserves uncertainty, and prevents implementation convenience from becoming architectural truth.

## Architectural Boundary

Physical Representation observes and constructs defensible spatial knowledge about a Physical Assembly. It supplies evidence, validity limits and claim permissions to Situation Assessment.

Representation does not acquire Current Responsibility, choose Regulation, create Resolution Commitment, enlarge Bounded Authority or issue Control. Situation Assessment interprets representation fitness and current Reality but likewise does not acquire responsibility or actuate. Those responsibilities belong to the boundaries defined by [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md).

## Planar Collision Semantics

OuttaMyWay reasons in plan view. Height is not a clearance dimension because GIANTS AI does not exploit hypothetical vertical underpass clearance beneath raised or folded machinery. A physical change matters when it materially changes the ground-plane projection or sweep required by collision reasoning.

This is **Planar Collision Semantics**: represent the obstruction world GIANTS AI can use rather than three-dimensional clearance it cannot realise.

## Exact Identity and Occupancy Continuity

Exact physical identity and useful occupancy are separate claims. A runtime Entity is an authoritatively resolved current physical collision shape only when source collision membership, current configuration membership, assembly-member ownership and distinct runtime identity form one coherent evidence chain.

Failure to establish exact identity does not require discarding all occupancy knowledge. A clearly identified conservative fallback may preserve occupancy continuity without claiming exact collision-shape identity. Fallbacks reduce precision and retain their uncertainty; they must not silently change the meaning or permissions of the result.

## Physical Representation Portfolio

One Physical Assembly may expose several simultaneous representations:

1. **Component Footprint Set** — positioned plan-view footprints for physical components.
2. **Convex Planar Envelope** — a conservative simplified polygon between component composition and a full rectangle.
3. **Member-Level Rectangle** — a conservative rectangle for one assembly member.
4. **Assembly-Level Rectangle** — the coarsest useful complete-assembly fallback.
5. **Unknown Occupancy** — explicit absence of trustworthy representation.

The portfolio is not a universal ranking. Fitness depends on the assessment question: a coarse complete representation may be safer for exclusion than a precise incomplete one. Purpose-specific geometry remains purpose-specific and does not supersede component representations, uncertainty layers or sweep representations.

A representation must preserve directional extents when Reality supports asymmetric occupancy. Total width must not be assumed symmetrically centred on the powered vehicle or an arbitrary assembly origin. Geometry and its passport preserve the reference, directional extents and pose validity needed to interpret such occupancy.

### Convex Planar Envelope

The Convex Planar Envelope is an accepted conservative fallback. It reduces the empty-corner cost of a full bounding rectangle while remaining simpler than an exact component union.

**Envelope Anchor Selection is Deferred.** Candidate constructions may use extremities and a declared anchor or a convex hull of positioned component footprints. No universal anchor is selected until evidence establishes containment, false occupied area, state stability and evidence cost.

## Representation Contract

Every representation separates Spatial Core, Validity Context and Evidence Quality.

### Spatial Core

- **Geometry** — the asserted plan-view shape, including any directional extents.
- **Ownership** — the component, family, member or assembly represented.
- **Pose** — the current position and orientation of that geometry relative to its declared reference.

The Spatial Core states what and where the representation is. Geometry may be directly observed or conservatively constructed; it is not automatically exact physical truth.

### Validity Context

Validity Context records applicable physical state, ownership and assembly membership, pose freshness, dependencies, and any state or evidence condition that limits use. It states when the representation may still describe its subject.

### Evidence Quality

Evidence Quality records:

- **Provenance** — how the geometry was obtained;
- **Completeness** — which portion of the stated subject is covered;
- **Conservatism** — whether it contains, approximates or may underestimate Reality; and
- **Fitness Profile** — which assessment classes it may safely support.

Evidence Quality controls conclusions. Confidence cannot transform working-width metadata, an origin, or internally complete geometry for known members into complete collision occupancy.

### Purpose-Scoped Geometry Authority

**Purpose-Scoped Geometry Authority** means that representation authority belongs to a declared claim scope, not merely to a geometry object. That scope identifies the subject, physical state or configuration, geometric question or purpose, horizon, coverage basis, validity dependencies and permitted conclusions. A Representation Passport must distinguish purposes equivalent to generic current collision occupancy, current working or productive corridor geometry, Transit Passage geometry, deployment-transition geometry and manoeuvre-sweep geometry; implementations need not encode these as literal universal enumerations.

Authority for one purpose does not silently transfer to another. In particular, a representation may have no generic negative-clearance authority while independently possessing purpose-specific Transit Passage geometry authority. That narrower authority establishes only the stated Transit Passage conclusion; it does not claim that the same geometry completely represents current-working collision occupancy.

## Job-Scoped Representation Catalogue

A **Job-Scoped Representation Catalogue** is constructed at the start of a GIANTS AI Job Episode and expires when that Episode ends. It describes equipment selection, purchased configuration, assembly structure and the representation templates justified for that scope. A later Episode receives a new catalogue.

Normal pose and state changes do not require rebuilding stable structure. Unexpected evidence that structure or configuration membership no longer matches the catalogue invalidates only affected catalogue claims; it is a defensive contradiction, not permission to preserve stale structure.

### Representation Templates and Pose Realisation

The catalogue contains stable **Representation Templates**, not a polygon for every possible world pose. A template declares contributors, local geometry and placement, construction and pose methods, applicability, provenance, completeness, conservatism and fitness.

**Pose Realisation** applies current physical state and pose to applicable templates to produce world-space occupancy. This creates **Stable Structure–Dynamic Pose Separation**:

```text
job-scoped structure and templates
        +
current multidimensional state and plan-view pose
        ->
current realised occupancy
```

### Configuration Footprint Authority and alternating working sides

Job-time physical configuration may change without changing the Job Episode. An implementation token or profile ordinal is diagnostic provenance only; it has no universal physical semantics without independent evidence.

**Configuration Footprint Authority** rests in:

- the current realised component footprint;
- the evidence quality and fitness of that footprint;
- the transition sweep between materially different footprints; and
- the equivalent footprint domain to which earlier traversability or clearance evidence applies.

Evidence for one working-side footprint does not automatically establish admissibility for an opposite or mirrored footprint, or for the sweep between them. A rotating, reversing, raised or functionally inactive implement remains spatially relevant while its configuration changes.

## Component Families

Homologous components may share one representation strategy while retaining individual dimensions, identity, placement and pose. This is **Family Strategy–Member Parameter Separation**. A failed member degrades locally unless evidence disproves the family strategy itself.

## Heterogeneous Footprint Composition

A realised assembly may mix representation methods and pose authorities. One weak component does not force the entire assembly into its coarsest fallback.

The governing rules are:

- **Coverage-First Composition** — prioritise trustworthy coverage before uniform precision;
- **Smallest-Scope Fallback** — add fallback only where unresolved occupancy requires it;
- **Localised Uncertainty** — keep uncertainty attached to affected regions;
- **Precision–Coverage Separation** — treat geometric detail and subject coverage independently; and
- **Layer-Preserving Composition** — retain the provenance and permissions of contributing layers rather than flattening them into anonymous geometry.

## Physical State and Configuration Motion

Physical state is multidimensional. Folded and working may describe useful configurations for a particular implement, but they are not a universal state axis and cannot replace current pose evidence.

### Orthogonal Physical State Dimensions

The independently meaningful dimensions are:

- **Deployment State** — folded, extended or unknown;
- **Vertical Configuration** — raised, lowered, intermediate or unknown;
- **Terrain Contact** — contacting, clear, not applicable or unknown;
- **Functional Engagement** — engaged, disengaged, not applicable or unknown; and
- **Operational Phase** — GIANTS AI activity such as manoeuvring or working.

These dimensions may correlate for a particular implement but are not universally equivalent. One animation or command may encode several dimensions, and an interior animation value may be a stable pose. Runtime physical pose is authoritative; implementation values and Operational Phase are supporting evidence only. Operational Phase does not establish physical state or pose.

### Raise/Lower Semantic Diversity

This architecture preserves **Configuration–Function Separation**: configuration or pose does not universally establish function. For direct-soil-contact implements, realised Terrain Contact is required before ground operation can be treated as functionally engaged; this is **Contact-Dependent Functional Engagement**. A lower command states intended motion but does not prove realised contact or engagement; this is **Commanded State–Realised Contact Separation**.

The Planar Relevance Test remains decisive. A vertical or functional change matters to collision representation only when realised pose or transition materially changes plan-view occupancy or sweep.

### Stable States and Deployment

Configuration motion may occur while the powered or base vehicle remains stationary. This is **Stationary Configuration Motion**; the moving implement continues to consume space.

Before such motion, Situation Assessment evaluates a **Deployment Clearance Envelope**: the plan-view area potentially occupied between the relevant configuration endpoints. The **Deployment Commitment Point** is the pre-motion point at which sufficient transition-clearance knowledge must exist for the intended conclusion.

Endpoint occupancy need not contain intermediate occupancy. This **Endpoint–Sweep Distinction** means stable endpoint footprints cannot stand in for the transition sweep. Current motion observations may refresh knowledge, but do not retroactively manufacture pre-commitment clearance.

### Planar Rigidity and Envelope Lifecycle

A structure is **Planarly Rigid** while its relative plan-view geometry remains effectively constant, even if it moves vertically over terrain. It is planarly articulated when relative plan-view poses change.

Local envelope geometry may be reused while all contributors remain planarly rigid. It must be regenerated when relevant relative poses change materially. The **Planar Relevance Test** asks whether a change materially alters ground-plane projection or sweep; irrelevant vertical movement alone does not require regeneration.

## Deployment Sweep and Manoeuvre Sweep

A **Deployment Sweep** results from configuration motion while the base vehicle is stationary. A **Manoeuvre Sweep** results from translation, steering and articulation. They are distinct even when an assessment composes both.

Manoeuvre Sweep must not assume midpoint pivoting. **Steering-Mode Sweep Dependency** requires the sweep to reflect the active steering mode and defensible kinematics.

**Detailed Manoeuvre Sweep Construction is Deferred.** Turning centre, radius, articulation and steering-kinematics construction remain evidence questions; no universal construction or implementation is authorised.

Deployment Sweep and Manoeuvre Sweep remain accepted concepts for assessments that genuinely require them. Cooperative Passage does not currently require sophisticated articulated Manoeuvre Sweep, animation swept-volume closure or longitudinal-arc reconstruction when its accepted purpose-specific Transit Passage contract supplies the crossing geometry. This does not reject or resolve Deferred Detailed Manoeuvre Sweep Construction, and Passage must not make that Deferred construction a prerequisite.

## Coverage Closure

**Inventory Closure** means all collision-relevant components for the stated subject and state are known. Geometry completeness for known or discovered members is not Inventory Closure and does not imply that the Physical Assembly is complete.

**Coverage Closure** means the relevant plan-view occupancy is represented for a stated subject, physical state and intended conclusion. It may be established by:

- **Enumerative Closure** — authoritative inventory plus representation and pose for every relevant active component;
- **Enclosing Closure** — independently proven conservative geometry containing the complete subject; or
- **Hybrid Closure** — precise representations plus smallest-scope fallback covering the unresolved remainder.

The **Known-Coverage Trap** is the error of treating representation of every discovered member as proof that none remain undiscovered. Complete generic collision geometry is not required for every geometric question: an independently justified enclosing or parametric representation may establish conclusion-relative closure for its declared purpose while remaining insufficient for other purposes. This does not weaken the Known-Coverage Trap. A purpose-specific geometry representation inherits unresolved assembly-membership uncertainty, and any purpose claiming complete-assembly geometry still requires complete Physical Assembly membership. Generic negative-clearance authority requires relevant generic collision Coverage Closure; local or discovered-member geometry completeness cannot supply it.

### Structural and Realised Coverage Closure

**Structural Coverage Closure** states that catalogue templates cover all relevant occupancy for a declared subject and physical state. **Realised Coverage Closure** additionally requires every applicable template to have a current valid pose.

Assembly closure may compose independently closed members whose closure methods differ, or use one independently proven whole-assembly enclosure. A **Coverage Ledger** records subject and state, closure scope and basis, contributors, unresolved regions, underestimation risk, pose authority and freshness, and closure status.

## Layered Occupancy Claims

Situation Assessment preserves a portfolio rather than selecting one universal geometry. Each representation declares its permitted assessment classes, such as screening, confirmation, containment, clearance and attribution.

Occupancy knowledge uses these claims:

- **Conflict Excluded** — current, relevant, non-underestimating closed coverage supports scoped separation;
- **Conflict Supported** — geometry positively supports overlap or convergence;
- **Conflict Possible** — conservative or incomplete coverage leaves a credible conflict route; and
- **Clearance Unresolved** — evidence establishes neither conflict nor safe separation.

Missing, unavailable or non-positive representation evidence cannot establish safe clearance. Where Realised Coverage Closure is incomplete, partial knowledge remains usable, but the gap withholds an all-clear wherever it can affect the scoped assessment. This is **Scope-Local Non-Exclusion**.

> Uncertainty prevents clearance; it does not manufacture collision or separation.

These are knowledge claims, not Regulation, Resolution Commitment, Bounded Authority or Control decisions.

### Player Obstacle Boundary

Player-controlled assemblies are outside cooperative-worker behavioural modelling. Their physical occupancy may be observed where it can affect an AI worker, but OuttaMyWay does not infer, optimise or correct player operating policy.

## Resolution Contract

Resolution establishes whether a source physical shape can be defensibly identified as a corresponding runtime Entity. It does not establish Inventory Closure, Coverage Closure, footprint correctness or downstream authority.

### Resolution Path terminology

A **Resolution Path** is a method of proposing a runtime candidate from source, component, mapping and assembly relationships. Candidate provenance grants no physical, navigation or assessment authority. `Route` remains reserved for a worker's navigable path.

### Resolution Contract and Claim Set

A source physical shape is resolved only when:

1. the candidate runtime Entity exists and is addressable;
2. it belongs to the expected Physical Assembly member;
3. its component and hierarchy relationships are compatible with source evidence;
4. geometry queries are attributable to that Entity rather than an unrelated or shared root alias;
5. a current pose can be observed coherently within the assembly; and
6. no unresolved contradiction establishes a competing coherent identity.

A successful result emits a **Resolution Claim Set** containing source identity, runtime Entity identity, geometry authority, pose authority, supporting and contradictory evidence, validity dependencies and explicit limits.

### Resolution Evidence Model

Evidence supports distinct claims: existence supports availability; assembly, component and hierarchy coherence support correspondence; Entity-local geometry supports geometry authority; current transform supports pose authority; independent Resolution Paths may corroborate identity; and negative controls may demonstrate discrimination.

This **Evidence Contribution Separation** prevents weak corroboration from defeating a mandatory contradiction. **Claim-Specific Confidence** keeps identity, geometry, pose freshness, path corroboration and completeness separate rather than collapsing them into one score.

### Discovery Independence and Resolution Path provenance

Resolution Path provenance records how a candidate was proposed, not what conclusions it permits. **Discovery Independence** allows Situation Assessment to consume the resulting claims and limits without reconstructing discovery mechanics; provenance remains attached for audit and reassessment.

### Functional Class–Structural Representation Separation

**Functional Class–Structural Representation Separation** means gameplay or functional class cannot establish physical structure, collision mapping, articulation, coverage or Resolution Path. Class may guide operational questions or candidate priorities, but asset-specific evidence must establish structural representation claims.

## Assessment Representation Contract

Resolution answers what can be defensibly identified. The **Assessment Representation Contract** supplies Situation Assessment with the most informative defensible spatial account achievable within the assessment budget, fit for relevant plausible futures and horizon, while preserving coverage limits, age and uncertainty.

### Assessment Representation Portfolio

The **Assessment Representation Portfolio** composes representations and explicit unknown remainder at the smallest useful scope: physical region, member, plausible future and horizon. It seeks a **Minimum Sufficient Defensible Portfolio**, not maximum detail or minimum cost in isolation.

Sufficiency is conclusion-relative. Known overlap may suffice for Conflict Supported; incomplete or conservative evidence may support Conflict Possible; only current relevant non-underestimating closed coverage may support Conflict Excluded; otherwise clearance remains unresolved. This is **Conclusion-Relative Sufficiency**.

### Representation Passport and self-description

Every downstream representation carries a **Representation Passport** describing physical scope and ownership, evidence authority and provenance, validity dependencies, directional reference and pose validity, coverage and underestimation risk, observation and refresh time, cost profile and permitted conclusions.

These explicit **Representation Claim Permissions** prevent evidence absence, cheap approximation or discovery provenance from silently gaining clearance authority.

For Cooperative Passage, current working-configuration geometry and directional extents support current occupancy, productive-corridor competition and Passage recognition. After Cooperative Passage selects, requires and positively realises Transit configuration, cached directional Transit dimensions for the complete Physical Assembly support facing extents, Passage arrangement, clearance and crossing. Generic DISC/component geometry remains useful for current obstacle and boundary reasoning. Transit geometry does not supersede current working geometry or make a deployed assembly artificially narrow before Transit is relevant; greater detail in current working geometry likewise does not turn it into the Transit Passage envelope. Directional asymmetry remains authoritative and must not be recentered without evidence. [Spatial Negotiation owns the specialised lifecycle contract](SPATIAL_NEGOTIATION_MODEL.md#passage-geometry-contract).

### Representation Cost Profile

A **Representation Cost Profile** separates acquisition latency, refresh cost, future-projection cost, volatility and expected invalidation, portfolio composition and synchronisation, and assessment-delay exposure.

Cost remains separate from fitness and evidence quality. **Admissibility Before Optimisation** requires evidence to be defensible for the intended claim before cost can influence selection. No universal scalar cost or weighting is selected here.

### Situation Assessment as Representation-Fitness Arbiter

Representations report evidence, dependencies, age and observed change. **Situation Assessment as Representation-Fitness Arbiter** determines whether each representation remains fit for the current question, plausible futures and horizon.

**Assessment-Relative Staleness** means age restricts claim permissions according to the question; it does not force universal discard. Situation Assessment may identify a refresh need, while observation and representation maintenance perform routine refresh. Representation fitness does not create responsibility or active response policy.

### Dependency-Scoped Invalidation

**Dependency-Scoped Invalidation** invalidates only claims that depended on changed Reality. Translation or rotation refreshes pose while stable identity may remain valid; articulation invalidates affected pose, footprint and sweep; attachment or configuration change may invalidate structure or catalogue claims; job completion invalidates active membership and motion expectation while preserving supported physical identity and obstacle relevance.

**Smallest-Scope Refresh** refreshes only the affected identity, pose, footprint, sweep, structure or projection. Implementation tolerances for material change remain implementation and validation work.

## Completion and persistent obstacle boundary

### GIANTS Completion Acceptance Boundary

Wherever and however GIANTS AI finishes an original job is accepted as final disposition. OuttaMyWay does not choose a parking position, continue productive navigation or create a post-job relocation duty.

Completion ends the Job Episode and active cooperative membership, but does not erase the Physical Assembly:

```text
active cooperative worker
        ->
completed nonmember obstacle
```

This is **Operational Membership–Spatial Relevance Separation**. **Role-State Invalidation** invalidates active role and future-motion expectations while preserving any still-supported identity, geometry and final pose. A **Persistent Completed-Worker Obstacle** remains spatially relevant for as long as its occupancy can affect active work.

### Deferred Post-Job Configuration Normalisation

**Deferred Post-Job Configuration Normalisation is Deferred.** Safe in-place raising or folding may later be examined as footprint reduction without relocation. No behaviour is authorised; any future decision requires evidence for available control, correct sequence, clear configuration sweep, useful footprint reduction and safe failure conditions.

### Parked Assessment Deadline Escalation

**Parked Assessment Deadline Escalation is Deferred.** When useful representation cannot be refreshed before an assessment deadline, Situation Assessment reports the insufficiency. No timeout, all-stop, emergency freeze or escalation policy is selected or authorised here.

## Deferred Questions

The following registered Physical Representation questions remain Deferred:

- **Envelope Anchor Selection** — no universal conservative-envelope anchor is selected.
- **Detailed Manoeuvre Sweep Construction** — no universal turning or articulation construction is selected.
- **Deferred Post-Job Configuration Normalisation** — no post-job configuration behaviour is authorised.
- **Parked Assessment Deadline Escalation** — no response policy for unrefreshable knowledge is selected.

Deferral preserves the question without promoting it into architecture or implementation authority.

## Current Architectural Boundary

Physical Representation defines how collision-relevant plan-view occupancy is represented and which scoped conclusions those representations may support. It is observational and knowledge-producing. Representation and Situation Assessment neither acquire responsibility nor authorise or issue Control.

Runtime implementation may lag this accepted architecture. Reconstructing implementation against the accepted representation responsibilities is subsequent engineering work and is not prescribed here. The four registered Physical Representation questions listed above remain Deferred.

Reality remains authoritative. New evidence that contradicts these semantics requires explicit architectural review and revision rather than silent implementation accommodation.
