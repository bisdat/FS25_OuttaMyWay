# Physical Representation Architecture

## Purpose

This document defines how OuttaMyWay represents the collision-relevant plan-view occupancy of one job-scoped Physical Assembly. It separates exact physical identity from usable occupancy, preserves uncertainty, and prevents implementation convenience from becoming false architectural truth.

The architecture remains observational. No Physical Occupancy Envelope, containment, sweep prediction, Decision, Commitment or Control behaviour is implemented by this release.

## Planar Collision Semantics

OuttaMyWay reasons in plan view. Height is not currently modelled as a clearance dimension because GIANTS AI does not exploit possible vertical underpass clearance beneath raised or folded machinery. A movement matters when it materially changes the ground-plane projection required by collision reasoning.

This is **Planar Collision Semantics**: model the obstruction world that GIANTS AI can actually use, not hypothetical three-dimensional clearances that the underlying worker cannot realise.

## Exact Identity and Occupancy Continuity

Exact physical identity and usable occupancy are separate questions.

A runtime Entity may be classified as an authoritatively resolved current physical collision shape when source collision membership, current configuration membership, assembly-member ownership and distinct runtime identity form one coherent evidence chain.

Failure to complete that chain does not forbid physical representation. A clearly identified conservative fallback may preserve occupancy knowledge without claiming exact collision-shape identity. Fallbacks degrade precision; they must not silently change the meaning of the result.

## Physical Representation Portfolio

One Physical Assembly may expose several simultaneous representations:

1. **Component Footprint Set** — positioned plan-view footprints for individual physical components.
2. **Convex Planar Envelope** — a conservative simplified polygon between component composition and a full rectangle.
3. **Member-Level Rectangle** — a conservative width-by-breadth fallback for one assembly member.
4. **Assembly-Level Rectangle** — the coarsest useful complete-assembly fallback.
5. **Unknown Occupancy** — explicit absence of trustworthy representation.

This is not a universal best-to-worst ranking. Fitness depends on the question being assessed. A coarse complete representation may be safer for exclusion than a precise incomplete representation.

### Convex Planar Envelope

The Convex Planar Envelope is accepted as a valid conservative fallback. It reduces the empty-corner cost of a full bounding rectangle while remaining simpler than an exact component union.

**Envelope Anchor Selection** remains deferred. Candidate constructions include:

- boom or implement extremities connected to one front-centre anchor;
- extremities connected to front-width corners;
- a convex hull constructed from positioned component footprints.

No universal option is selected until comparative evidence measures containment, false occupied area, state stability and evidence cost.

## Representation Contract

Every representation separates three responsibilities.

### Spatial Core

- **Geometry** — the asserted plan-view shape.
- **Ownership** — the component, family, member or assembly represented.
- **Pose** — the current position and orientation of that geometry.

The Spatial Core says what and where the representation is. Geometry may be directly observed or conservatively constructed; it is not automatically exact physical truth.

### Validity Context

- applicable physical state;
- current ownership and assembly membership;
- pose freshness;
- any state or evidence condition that limits use.

Validity Context says when the representation may still be treated as describing its subject.

### Evidence Quality

- **Provenance** — how the geometry was obtained;
- **Completeness** — what portion of the subject is covered;
- **Conservatism** — whether it contains, approximates or may underestimate reality;
- **Fitness Profile** — which assessment classes it can safely support.

Evidence Quality says what conclusions may safely be drawn. Confidence does not transform a working-width fallback into collision geometry.

## Job-Scoped Representation Catalogue

A Representation Catalogue is constructed once at the start of each GIANTS AI job and expires when that job ends. Equipment selection, purchased configuration and assembly structure belong to that job-start construction. A later job receives a new catalogue.

During the job, normal variation is limited to:

- discrete physical state, such as folded or working;
- continuous plan-view pose, such as position, heading, articulation and live component transforms.

Unexpected evidence that the assembly no longer matches the catalogue is **Catalogue Invalidation**, a defensive exception rather than a routine structural pathway.

### Representation Templates and Pose Realisation

The catalogue contains stable Representation Templates, not a polygon for every possible world pose. A template declares:

- contributing components or members;
- local geometry and placement;
- construction and pose methods;
- applicability, provenance, completeness, conservatism and Fitness Profile.

**Pose Realisation** applies current runtime pose and physical state to the applicable template set to produce current world-space representations.

This creates **Stable Structure–Dynamic Pose Separation**:

```text
job-stable catalogue and templates
        +
current physical state and plan-view poses
        ->
current realised occupancy
```

## Component Families

Homologous components within a segmented implement normally share one representation strategy while retaining individual dimensions, identity, placement and pose. This is **Family Strategy–Member Parameter Separation**.

For the Condor, all eight boom segments currently support one shared strategy. Their geometry is not identical: the outer sections taper and each segment retains its own parameters.

A failed member degrades locally unless evidence disproves the family strategy itself. Localised member failure is retained defensively for OuttaMyWay resolution failures even though GIANTS asset validation makes malformed individual model members unlikely in ordinary play.

## Heterogeneous Footprint Composition

A realised assembly may mix representation methods and pose authorities. One weak component must not force the complete assembly into its coarsest fallback.

The governing rules are:

- use the best currently valid representation for each physical region;
- introduce fallback at the smallest scope that safely covers unresolved occupancy;
- prioritise trustworthy coverage before uniform precision;
- preserve uncertainty locally;
- retain contributing layers rather than flattening them into one anonymous polygon.

This is **Coverage-First Composition**, **Smallest-Scope Fallback**, **Localised Uncertainty**, **Precision–Coverage Separation** and **Layer-Preserving Composition**.

## Stable States and Deployment

For AI-controlled field work, folded and working are the principal stable occupancy states. GIANTS keeps the base vehicle stationary while an implement unfolds, lowers or otherwise reaches its working state. The implement itself still moves.

This is **Stationary Configuration Motion**. Before deployment, Situation Assessment must consider a **Deployment Clearance Envelope**: the plan-view area that may be occupied between the folded and working endpoints. The **Deployment Commitment Point** occurs before GIANTS begins that configuration motion, when sufficient clearance should already be established.

The folded and working endpoints do not necessarily contain the intermediate transition sweep. This is the **Endpoint–Sweep Distinction**. Live transitional geometry may validate or monitor the motion, but frame-by-frame reaction should not replace pre-commitment clearance assessment.

## Planar Rigidity and Envelope Lifecycle

A structure is **Planarly Rigid** when its relative plan-view geometry remains effectively constant even if it moves vertically over terrain. A structure is planarly articulated when relative plan-view poses change, such as tractor–implement yaw.

A Convex Planar Envelope may be cached in local coordinates where all contributors remain planarly rigid. It must be regenerated when relative plan-view poses change materially. Vertical movement alone does not require regeneration unless it materially changes the ground-plane projection.

This is the **Planar Relevance Test**.

## Deployment Sweep and Manoeuvre Sweep

Deployment Sweep and Manoeuvre Sweep remain separate concepts. Deployment Sweep is caused by implement configuration motion while the base vehicle is stationary. Manoeuvre Sweep is caused by the assembly translating, steering and articulating.

Manoeuvre sweep must not assume that a vehicle pivots about its midpoint. It depends on active steering mode and observed or authoritative kinematics. The Condor contrast between all-wheel/crab steering and rear-wheel steering establishes **Steering-Mode Sweep Dependency**. Turning radius, instantaneous centre of rotation and articulation remain future evidence questions.

## Coverage Closure

Representing every discovered component does not prove that no relevant component remains undiscovered. This is the **Known-Coverage Trap**.

**Inventory Closure** means all relevant components are known. **Coverage Closure** means all collision-relevant plan-view occupancy is represented for a stated subject and physical state. Coverage Closure may be established by:

- **Enumerative Closure** — authoritative inventory plus representation and pose for every active component;
- **Enclosing Closure** — independently proven conservative geometry containing the complete subject;
- **Hybrid Closure** — precise representations combined with smallest-scope fallbacks covering the unresolved remainder.

Closure claims are scoped to component family, member or assembly and record their basis. A coarse whole-member enclosure can establish coverage without identifying every internal part; a complete inventory cannot establish coverage when geometry or pose is missing.

### Structural and Realised Coverage Closure

**Structural Coverage Closure** is declared by the job-start catalogue for a stated physical state. It says the available templates cover all relevant occupancy.

**Realised Coverage Closure** exists only when those applicable templates have current valid poses. Assembly closure may compose independently closed members even when their closure methods differ, or may be established directly by one proven whole-assembly enclosure.

A **Coverage Ledger** preserves:

- subject and physical state;
- closure scope and basis;
- contributing representations;
- unresolved regions;
- underestimation risk;
- pose authority and freshness;
- closure status.

## Layered Occupancy Claims

Situation Assessment preserves a portfolio rather than selecting one universal geometry. Each representation declares a Fitness Profile for classes such as screening, confirmation, containment, clearance and attribution. Situation Assessment selects the eligible representation appropriate to the current question.

Occupancy knowledge uses these states:

- **Conflict Excluded** — current, relevant, non-underestimating closed coverage supports separation;
- **Conflict Supported** — represented geometry positively supports overlap or convergence;
- **Conflict Possible** — conservative geometry or incomplete coverage leaves a credible conflict route;
- **Clearance Unresolved** — evidence cannot establish either conflict or safe separation.

Where Realised Coverage Closure is incomplete, assessment continues with partial knowledge. The authority to issue an all-clear is lost only where the gap could affect that scoped assessment. This is **Scope-Local Non-Exclusion**.

> Uncertainty prevents clearance; it does not manufacture collision.

Situation Assessment reports Knowledge. Terms such as caution, slow, wait or hold remain Decision Engine and Commitment concerns.

## TS004 Static Contrast Evidence

TS004 contains two tractor–cultivator combinations:

- unit1: Valtra S 416 with Horsch Tiger 8 MT;
- unit2: John Deere 8RX 410 with Väderstad TopDown 600.

Static source examination established materially different internal representation patterns:

- Tiger uses five saved physics components, including separate left and right wing components;
- TopDown uses one saved physics component while folding collision-bearing descendants move inside its hierarchy;
- Tiger exposes nine possible `compoundChild` collision shapes and the saved configuration indicates six current shapes;
- TopDown exposes fourteen possible `compoundChild` collision shapes and the saved plain-cultivator configuration indicates twelve current shapes;
- direct collision-node mapping coverage differs substantially between the two assets;
- Tiger declares 3.05 m base width and 7.5 m working width; TopDown declares 3.0 m base width and 6.0 m working width.

This supports **Internal Articulation Representation Diversity**, **Direct-Mapping Coverage Variability** and **State-Scoped Dimensional Evidence**. Physics-component counts, mapping counts and declared working width cannot establish Inventory Closure or collision authority.

The supplied GIANTS assets are temporary research evidence and are not redistributed in this repository. Runtime validation remains required before source observations become runtime resolution claims.

## Orthogonal Physical State Dimensions

Runtime evidence disproves a universal one-dimensional `folded → transition → extended` model. A physical assembly may expose several independently meaningful dimensions:

- **Deployment State** — folded, extended or unknown;
- **Vertical Configuration** — raised, lowered, intermediate or unknown;
- **Terrain Contact** — contacting, clear, not applicable or unknown;
- **Functional Engagement** — engaged, disengaged, not applicable or unknown;
- **Operational Phase** — GIANTS AI activity such as manoeuvring or working.

These dimensions may correlate for one implement but are not universally equivalent. One asset may encode several of them inside one animation timeline, while another may use separate controls or specialisations. Runtime physical pose remains authoritative; implementation values and AI phase are supporting evidence only.

### Stable Interior Animation State and Compound Animation Timeline

TS004 TopDown remained stably at `foldAnimTime=0.1250` while extended and raised for manoeuvring. It later moved from `0.1250` toward `0.0000` while lowering for work. Therefore an interior numerical animation value may be a stable physical pose, not incomplete transition.

A **Compound Animation Timeline** is an implementation timeline that encodes more than one architectural state dimension. Its numerical endpoints and interior plateaus must not be assigned universal physical semantics without asset-specific evidence.

### Extended Manoeuvring State and Work Engagement Cycle

For the AI-controlled TopDown fixture, GIANTS unfolded the implement, retained an extended-raised pose for positioning, lowered it for direct-soil-contact work, raised it for end-of-pass repositioning, then lowered it for the next pass. This establishes the observed **Extended Manoeuvring State** and **Work Engagement Cycle** for that fixture:

```text
EXTENDED + RAISED
→ lower
→ EXTENDED + CONTACTING / functionally capable of work
→ raise
→ EXTENDED + RAISED
```

GIANTS `WORKING` began before the implement reached its stable low animation endpoint. This is **Operational Phase–Physical State Separation**: operational phase must not be used as authoritative pose evidence.

### Raise/Lower Semantic Diversity

Raise/lower controls do not have one universal functional meaning.

- Direct-soil-contact implements such as ploughs, cultivators and rollers must lower until their working elements contact the soil before their intended ground operation can occur.
- Non-contact implements such as sprayer booms may change vertical configuration for role-play or real-world crop-clearance plausibility without requiring soil contact and without changing crop treatment in the current game simulation.

This supports **Configuration–Function Separation**, **Contact-Dependent Functional Engagement** and **Commanded State–Realised Contact Separation**. A lower command describes intended configuration movement; it does not prove realised terrain contact or functional engagement.

The Planar Relevance Test remains decisive for collision representation. A vertical change matters to OuttaMyWay only where its realised pose or transition materially changes plan-view occupancy or sweep.

### Player Obstacle Boundary

Player-controlled assemblies are outside cooperative-worker behavioural modelling. They are observed only insofar as their physical occupancy may obstruct an AI worker. OuttaMyWay does not infer, optimise or correct player operating policy.

## Current Boundary

Member-Local Physical Resolution remains the next prototype gate. Prototype 13 must investigate how source collision identities are connected to distinct runtime Entities inside each assembly member while retaining unresolved identities and alias detection. Physical Representation construction may then test exact and fallback routes without requiring exact identity as a prerequisite for all useful occupancy.

Prototype 13A is authorised as a passive declared-route evidence probe only; automated route discovery and footprint construction remain unauthorised pending evidence.

## Member-Local Physical Resolution

Physical identity resolution may follow different asset-specific routes while emitting one Route-Independent Resolution Contract. Direct mapping, physics-component descendants and mapped-ancestor descendants are candidate-generation methods, not authority rankings.

Each source physical shape owns a Resolution Candidate Set. Applicable routes are evaluated through common evidence: member/component ownership, hierarchy coherence, distinct runtime identity, Entity-local geometry authority, current pose and alias rejection. Multiple routes reaching one Entity provide Resolution Route Convergence; coherent disagreement remains `AMBIGUOUS`. A found node with unproven geometry remains `NODE_RESOLVED_GEOMETRY_UNPROVEN`.

Prototype 13A tests explicit Disposable Fixture Declarations before any automated route discovery. Complete footprint construction and Coverage Closure remain separate later activities.
