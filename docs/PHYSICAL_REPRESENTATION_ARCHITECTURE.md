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

## Prototype 13A Resolution Knowledge Consolidation

Prototype 13A completed the declared fixture matrix and validated one common evidence contract across Condor, Tiger 8 MT and TopDown 600. It did not automate candidate discovery, prove complete inventory, construct footprints or establish Coverage Closure.

### Resolution Path terminology

A **Resolution Path** is one method of proposing a runtime candidate from known source, component, mapping and assembly relationships. The term replaces the ambiguous architectural use of `route`, which remains reserved for a worker's navigable field path.

Historical Prototype 13A file names, Lua identifiers and log reasons such as `ROUTE_CONVERGENCE` remain unchanged for traceability. They are legacy implementation labels for Resolution Path evidence and do not describe vehicle navigation.

### Resolution Contract and Claim Set

A source physical shape is `RESOLVED` only when one runtime Entity can be defensibly identified as its corresponding physical runtime representation. The mandatory evidence floor is:

1. the candidate runtime Entity exists and remains addressable;
2. it belongs to the expected Physical Assembly member;
3. its component and hierarchy relationships are compatible with known source evidence;
4. physical geometry queries are attributable to that Entity rather than an unrelated or shared root alias;
5. a current runtime pose can be observed and located coherently within the assembly;
6. no unresolved contradictory evidence establishes a competing coherent runtime identity.

A successful result emits a **Resolution Claim Set**:

- source physical identity;
- runtime Entity identity;
- geometry authority;
- pose authority;
- supporting and contradictory evidence;
- validity dependencies;
- explicit limits.

`RESOLVED` does not mean perfect, complete or closed. It establishes defensible identity, geometry and pose for the stated source shape. It does not establish Inventory Closure, Coverage Closure or footprint correctness.

### Resolution Evidence Model

Different evidence contributes to different claims:

- node existence establishes candidate availability;
- assembly/component/hierarchy coherence supports correspondence;
- Entity-local geometry establishes physical geometry authority;
- current transform establishes pose authority;
- Resolution Path convergence corroborates independence from one lookup assumption;
- negative-control rejection demonstrates discrimination capability;
- motion-derived distinctness corroborates independent physical identity;
- symmetry and repeated temporal observation may provide further corroboration.

This is **Evidence Contribution Separation**. Corroborating evidence strengthens confidence when available but is not a universal gate. A rigid or asymmetric asset must not fail solely because motion or symmetry evidence is unavailable. Conversely, a decisive mandatory contradiction cannot be outweighed by several weaker passes.

Confidence remains **Claim-Specific**. Identity, geometry authority, pose freshness, path corroboration and inventory completeness are separate claims; they must not be collapsed prematurely into one confidence percentage.

### Discovery Independence and Resolution Path provenance

Resolution Path type records how a candidate was proposed; it does not grant physical authority. Situation Assessment consumes what was established, not the lookup mechanism. Path provenance remains attached for audit and reassessment without leaking discovery mechanics into downstream assessment logic.

### Functional Class–Structural Representation Separation

Tiger 8 MT and TopDown 600 share the cultivator gameplay class but expose materially different physics-component, hierarchy, mapping and articulation structures. Their successful Resolution Paths also differ.

Therefore:

> Gameplay class is context, not structural authority.

Class information may guide operational questions, expected work semantics or candidate priorities. It must not establish physical structure, mapping coverage, articulation model or a privileged Resolution Path. Prototype 13A decreased confidence in implement-class structural homogeneity while increasing confidence that one class-independent Resolution Contract can evaluate heterogeneous assets.

## Assessment Representation Contract

Resolution answers what can be defensibly identified. Assessment Representation answers what spatial knowledge is useful now.

> At each assessment cycle, Situation Assessment receives the most informative defensible spatial account achievable within the assessment budget, fit for the relevant plausible futures and future horizon, with coverage limits, evidence age and uncertainty preserved.

“Most informative defensible” is preferred to “most complete”: a representation may be the best available while remaining explicitly partial. The assessment budget, evidence age and future horizon are independent dimensions.

### Assessment Representation Portfolio

Situation Assessment need not select one universal geometry. It may compose a portfolio such as:

```text
resolved rigid vehicle core
+
resolved articulated members
+
conservative envelope for unresolved regions
+
explicit unknown remainder
```

Selection occurs at the smallest useful scope: physical region, assembly member, plausible future and assessment horizon. The goal is the **Minimum Sufficient Defensible Portfolio**, not maximum detail or minimum computational cost in isolation.

Sufficiency is conclusion-relative:

- known overlap may be sufficient for `CONFLICT_SUPPORTED`;
- incomplete or conservative evidence may support `CONFLICT_POSSIBLE`;
- only current relevant non-underestimating closed coverage may support `CONFLICT_EXCLUDED`;
- insufficient defensible evidence remains `CLEARANCE_UNRESOLVED`.

### Representation Passport and self-description

Every representation offered downstream must be self-describing through a **Representation Passport**:

- physical scope and ownership;
- evidence authority and provenance;
- validity dependencies;
- coverage statement and underestimation risk;
- observation and refresh time;
- cost profile;
- permitted assessment conclusions.

This is **Discovery Independence** and **Representation Claim Permission**. Situation Assessment should not need to reconstruct how a representation was discovered before deciding how it may be used.

### Representation Cost Profile

Representation cost is multidimensional:

- acquisition latency;
- refresh cost;
- future-projection cost;
- volatility and expected invalidation rate;
- portfolio composition and synchronisation cost;
- assessment-delay exposure.

Cost remains separate from fitness and evidence quality. **Admissibility Before Optimisation** is mandatory: unsupported cheap geometry cannot defeat slower defensible evidence. The architecture retains a cost vector; exact weighting or a single scalar score remains an implementation and measurement question.

### Situation Assessment as Representation-Fitness Arbiter

Representations report evidence, dependencies, age and observed changes. Situation Assessment determines whether each remains fit for the current question, plausible futures and horizon. Possible Knowledge states include:

- `CURRENTLY_FIT`;
- `FIT_FOR_LIMITED_HORIZON`;
- `USABLE_WITH_UNCERTAINTY`;
- `REFRESH_REQUIRED`;
- `STRUCTURALLY_INVALID`.

Staleness is assessment-relative. Older evidence is not discarded automatically; its permitted conclusions are restricted. Situation Assessment produces Knowledge and may identify refresh need, while observation and representation maintenance perform routine refresh. Any active response to unresolved knowledge remains a Decision Engine concern.

### Dependency-Scoped Invalidation

A material change invalidates only the claims that depended on the previous steady state:

- speed or direction change invalidates the previous future projection;
- normal translation or rotation refreshes pose while stable identity and geometry remain valid;
- implement articulation invalidates affected member pose, footprint and sweep assumptions;
- attachment or configuration change may invalidate assembly structure and the catalogue;
- AI job completion invalidates active membership and prior motion expectation while preserving physical identity and obstacle relevance.

This is **Smallest-Scope Refresh**. Implementation tolerances must later distinguish meaningful change from physics settling or sensor noise.

## Completion and persistent obstacle boundary

### GIANTS Completion Acceptance Boundary

Wherever and however GIANTS AI finishes an original job is accepted as the final disposition. OuttaMyWay does not choose a parking position, move the vehicle off-field or continue navigation after job completion. There is no universally correct post-job location and relocation remains a player responsibility.

At completion:

```text
ACTIVE_COOPERATIVE_WORKER
→ COMPLETED_NONMEMBER_OBSTACLE
```

The role, membership and future-motion assumptions change. Physical identity and geometry remain valid, the final pose is refreshed, and the assembly remains spatially relevant for as long as it can affect remaining workers. This is **Operational Membership–Spatial Relevance Separation**, **Role-State Invalidation** and the **Persistent Completed-Worker Obstacle**.

### Deferred Post-Job Configuration Normalisation

Safe in-place raising or folding may later be examined as footprint reduction without relocating the vehicle. It is not current behaviour. Any future commitment requires evidence that control remains available, the correct sequence is known, the configuration sweep is clear, the compact state materially reduces relevant occupancy and failure leaves a known safe condition.

### Parked Assessment Deadline Escalation

When useful representation cannot be refreshed before decision time expires, Situation Assessment reports the remaining insufficiency. A future Decision Engine session may examine selective hold, emergency freeze or another failsafe. No timeout, all-stop or escalation policy is selected by this consolidation.


## Facing Extent Provider evidence from TS017-B

A Facing Extent Provider is an assessment adapter, not a replacement for Physical Representation. It asks a narrower question: what one-sided extent can current evidence support along a declared axis and reference?

For the exact compact Condor fixture, TS017-B resolved all 13 catalogued current physical identities and node origins. The tested GIANTS runtime-bound APIs produced zero usable bounds. This establishes **Origin Coverage Is Not Bound Coverage** and preserves the distinction between identity/origin resolution and geometric Coverage Closure.

The provider used a lower-confidence fixture model:

```text
4.87 m live one-sided origin projection
+ 2.50 m explicit unresolved physical allowance
= 7.37 m compact Facing Clearance Extent
```

The allowance is part of the Representation Passport and must remain visible. It is not proof of full assembly bounds, a production constant or authority to exclude conflict. The provider output remains suitable for shadow comparison only until broader structural evidence and policy separation are validated.

## Current Boundary

Prototype 13A is complete for its declared fixture matrix. Prototype 13B automated Resolution Path discovery remains deferred. The next evidence activity is selection—potentially through data mining—of fixtures that attempt to disprove the Resolution Contract across broader representation structures.

No Physical Occupancy Envelope, Inventory Closure, Coverage Closure, containment, sweep prediction, Decision, Commitment or Control behaviour is authorised by v4.6.23.

## Semantic catalogue, Scope Overlay and structural challenge boundary (v4.6.23)

The reviewed Semantic Catalogue is an input to Scope Overlay and fixture selection, not a Physical Representation. The detailed overlay is owned by `SCOPE_OVERLAY_ARCHITECTURE.md`.

A semantic role or overlay result can suggest useful disproof questions but cannot establish:

- Physical Assembly membership;
- source collision membership;
- runtime Entity identity;
- geometry or pose authority;
- Inventory or Coverage Closure;
- a preferred Resolution Path.

The required sequence is:

```text
Reviewed Semantic Catalogue
    -> Scope Overlay
        -> Control Eligibility / Participation / Assembly / Obstacle claims
            -> targeted Structural Challenge and test selection
                -> source/runtime evidence and Resolution Contract
```

Assembly Relevance identifies the Behavioural Assembly that matters to assessment; it does not authorise a geometry representation or copy the attachment hierarchy. Obstacle Relevance may require representation even when Control Eligibility is negative.

Structural profiling should be limited to selected positive candidates, representation-relevant assets and bounded negative or disproof controls. Exhaustively profiling all 606 definitions would confuse taxonomy completion with architectural evidence. Every selected semantic role or overlay claim still requires asset-specific structural evidence.

## Asymmetric working-envelope evidence (v4.6.23)

TS010 adds a structural challenge not represented by centred working-width assumptions. The SaMASZ XT 390 worked persistently to the tractor's right while Giants displaced the tractor route so the mower followed the field edge.

```text
Powered-Vehicle Trajectory
    != Working-Envelope Trajectory
        != complete Physical-Assembly Envelope
```

A future Representation Contract must preserve directional left/right extents and their pose validity. Total width divided equally around the vehicle centreline is not a safe default.

TS010 also produced repeated conservative-envelope containment warnings during apparently valid work. This creates a provisional Valid Boundary Straddling question: legitimate immediate-margin use and conservative rectangle over-approximation must be distinguished before strict containment control is implemented. Full-Envelope Field Containment remains accepted until that targeted evidence exists.

