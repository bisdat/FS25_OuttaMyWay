# Physical Representation Architecture

## Purpose and architectural boundary

This document defines how OuttaMyWay establishes defensible collision-relevant plan-view knowledge about a Physical Assembly and what scoped conclusions that knowledge may support.

It separates physical identity from occupancy knowledge, preserves uncertainty and claim limits, and prevents implementation convenience or geometric precision from becoming authority that the evidence does not support.

This is current Architecture. It defines responsibilities, concepts, evidence rules, constraints and lifecycle boundaries; it does not define source modules, helper topology, implementation calibration or validation history.

The [Runtime Responsibility Architecture](RUNTIME_RESPONSIBILITY_ARCHITECTURE.md) owns Observation, Situation Assessment, Responsibility Transition, Bounded Authority and Control. The [Spatial Negotiation Architecture](SPATIAL_NEGOTIATION_MODEL.md) owns Cooperative Passage semantics. Physical Representation supplies bounded spatial knowledge to those consumers without acquiring traffic responsibility or actuation authority.

## Specification Jurisdictions

Physical Representation is an architectural subject, not one monolithic Specification Jurisdiction.

It declares two cohesive Jurisdictions:

| Specification Jurisdiction | Primary architectural responsibility |
| --- | --- |
| **Physical Identity Resolution** | Determine which runtime physical entity, geometry authority and pose authority can be defensibly associated with observed source physical evidence. |
| **Assessment Representation** | Construct, maintain and publish scoped occupancy knowledge, uncertainty, coverage and claim permissions for downstream assessment. |

Physical Identity Resolution may support Assessment Representation, but identity success does not by itself establish complete occupancy, and occupancy knowledge does not require exact identity when a conservative fallback remains defensible.

Planar Collision Semantics, Purpose-Scoped Geometry Authority, Coverage Closure, Configuration Footprint Authority, Representation Passport, Deployment Sweep, Manoeuvre Sweep and related terms are Concepts, Evidence Rules, Constraints or lifecycle elements inside these Jurisdictions. They do not create additional Specification Jurisdictions merely by being separately named.

**Physical Identity Resolution** routes to [`../../spec/PHYSICAL_IDENTITY_RESOLUTION.md`](../../spec/PHYSICAL_IDENTITY_RESOLUTION.md) and **Assessment Representation** routes to [`../../spec/ASSESSMENT_REPRESENTATION.md`](../../spec/ASSESSMENT_REPRESENTATION.md).

## 1. Cross-jurisdiction representation flow

```text
Reality
   |
   v
Observation
   |
   +-----------------------------+
   |                             |
   v                             v
Physical Identity          direct / conservative
Resolution                 occupancy evidence
   |                             |
   +-------------+---------------+
                 |
                 v
       Assessment Representation
       geometry + validity +
       coverage + claim permissions
                 |
                 v
        Situation Assessment
                 |
                 v
        downstream responsibility
```

Observation acquires evidence from Reality. Physical Identity Resolution answers what physical entity and local geometry can be defensibly identified. Assessment Representation composes the most informative defensible occupancy account for downstream questions. Situation Assessment determines what that representation means for the current Situation.

No representation product establishes Regulation, Resolution Commitment, Bounded Authority or Control permission by itself.

---

## 2. Cross-cutting representation principles

### Planar Collision Semantics

OuttaMyWay reasons about collision-relevant occupancy in plan view.

Height is not a clearance dimension merely because machinery can raise or fold. GIANTS AI does not exploit hypothetical vertical underpass clearance beneath raised or folded equipment. A physical change matters to collision representation when it materially changes the ground-plane projection or sweep relevant to the question.

> **Represent the obstruction world GIANTS AI can use, not three-dimensional clearance it cannot realise.**

### Exact identity and occupancy continuity

Exact physical identity and useful occupancy are different claims.

Failure to establish exact runtime shape identity does not require discarding all occupancy knowledge. A conservative fallback may preserve bounded occupancy knowledge without claiming exact collision-shape identity.

Fallbacks must retain their uncertainty and claim limits. They must not silently gain stronger authority merely because they are easier to construct.

### Purpose-Scoped Geometry Authority

Representation authority belongs to a declared claim scope, not merely to a geometry object.

The scope must identify, as applicable:

- subject and ownership;
- relevant physical state or configuration;
- geometric question or purpose;
- spatial or temporal horizon;
- coverage basis;
- validity dependencies; and
- permitted conclusions.

Authority for one purpose must not silently transfer to another.

A representation may, for example, have no generic negative-clearance authority while independently possessing purpose-specific Transit Passage geometry authority. That narrower authority establishes only the stated Passage conclusion; it does not prove complete generic current-working collision occupancy.

### Directional asymmetry

A representation must preserve directional extents when Reality supports asymmetric occupancy.

Total width must not be assumed to be symmetrically centred on the powered vehicle or an arbitrary assembly origin. Geometry must retain the reference and directional extents required to interpret the represented occupancy correctly.

---

## 3. Specification Jurisdiction — Physical Identity Resolution

**Owns:** defensible correspondence between source physical evidence and a runtime physical entity, including entity identity, geometry authority, pose authority, contradictions and explicit claim limits.

**Does not own:** Physical Assembly inventory closure, occupancy coverage closure, Situation meaning, Regulation, Resolution Commitment, Bounded Authority or Control.

**Primary Specification:** [`../../spec/PHYSICAL_IDENTITY_RESOLUTION.md`](../../spec/PHYSICAL_IDENTITY_RESOLUTION.md)

Physical Identity Resolution answers:

> **What runtime physical thing can this evidence defensibly identify?**

### Resolution Path

A **Resolution Path** is a method of proposing a runtime candidate from source, component, mapping and Physical Assembly relationships.

Resolution Path provenance records how a candidate was proposed. It does not itself establish physical authority, navigation authority, occupancy completeness or downstream assessment permission.

`Route` remains reserved for navigable worker path semantics.

### Resolution Contract

A source physical shape is resolved only when the evidence coherently supports the required correspondence. This includes, as applicable:

1. the candidate runtime Entity exists and is addressable;
2. it belongs to the expected Physical Assembly member;
3. component and hierarchy relationships are compatible with source evidence;
4. geometry evidence is attributable to that Entity rather than an unrelated or shared alias;
5. current pose can be observed coherently within the assembly; and
6. no unresolved contradiction establishes a competing coherent identity.

A successful result emits a **Resolution Claim Set** containing the identity, geometry authority, pose authority, supporting evidence, contradictory evidence, validity dependencies and explicit limits that were actually established.

Resolution success does not establish Inventory Closure, Coverage Closure, footprint correctness beyond the admitted claim, or downstream responsibility.

### Evidence Contribution Separation

Different evidence supports different claims.

Existence supports availability. Assembly, component and hierarchy coherence support correspondence. Entity-local geometry supports geometry authority. Current transform supports pose authority. Independent Resolution Paths may corroborate identity. Negative controls may demonstrate discrimination.

These contributions must remain separable.

> **Weak corroboration must not defeat a mandatory contradiction.**

**Claim-Specific Confidence** keeps identity, geometry, pose freshness, path corroboration and completeness separate rather than collapsing them into one universal score.

### Entity-Local Shape Evidence

**Entity-Local Shape Evidence** asks whether already-acquired runtime shape measurements are attributable and pose-coherent enough to be admitted as Entity-local physical evidence.

Its bounded evidence questions include:

- **Geometry–World Coherence** — whether Entity-local geometry transformed into world space agrees sufficiently with observed world geometry; and
- **Descendant–Root Alias Discrimination** — whether an apparent descendant shape is distinguishable from an alias of its Physical Assembly member root.

This evidence responsibility does not discover Physical Assembly members, choose candidate shapes, own cache lifetime, establish Coverage Closure, create negative-clearance authority, interpret Situation meaning, acquire responsibility or authorise Control.

> **Shared Resolution Predicate != Shared Representation Product**

> **Evidence Ownership May Be Shared Even When Product Authority Is Not**

Numerical tolerances used to evaluate these evidence questions are implementation and validation concerns, not Architecture.

### Discovery Independence

Downstream consumers must be able to use admitted identity and geometry claims without reconstructing the discovery mechanics that produced them.

Resolution provenance remains attached for audit, contradiction and reassessment, but discovery mechanism is not downstream semantic authority.

### Functional Class–Structural Representation Separation

Gameplay or functional class cannot establish physical structure, collision mapping, articulation, coverage or Resolution Path.

Functional class may guide operational questions or candidate priorities. Structural representation claims require physical evidence.

---

## 4. Specification Jurisdiction — Assessment Representation

**Owns:** construction, maintenance and publication of the most informative defensible occupancy account for downstream assessment, including geometry, physical-state validity, coverage, uncertainty, provenance, claim permissions, refresh boundaries and purpose scope.

**Does not own:** Situation interpretation, strategic Candidate choice, Responsibility Transition, Regulation, Resolution Commitment, Bounded Authority or Control.

**Primary Specification:** [`../../spec/ASSESSMENT_REPRESENTATION.md`](../../spec/ASSESSMENT_REPRESENTATION.md)

Assessment Representation answers:

> **What spatial account is defensible for this subject and question, and what may that account legitimately prove?**

### Representation Portfolio

One Physical Assembly may expose several simultaneous representations, including:

1. **Component Footprint Set** — positioned plan-view footprints for physical components;
2. **Convex Planar Envelope** — a conservative simplified polygon;
3. **Member-Level Rectangle** — a conservative rectangle for one assembly member;
4. **Assembly-Level Rectangle** — the coarsest useful complete-assembly fallback; and
5. **Unknown Occupancy** — explicit absence of trustworthy representation.

The portfolio is not a universal precision ranking.

Fitness depends on the question. A coarse complete representation may support a conclusion that a more precise but incomplete representation cannot. Purpose-specific geometry remains purpose-specific and does not supersede unrelated representation layers.

### Convex Planar Envelope

The **Convex Planar Envelope** is an accepted conservative fallback between component composition and a full bounding rectangle.

**Envelope Anchor Selection** remains Deferred. No universal anchor or construction is selected until evidence establishes the required containment, false occupied area, state stability and evidence cost.

### Representation Contract

Every representation separates three kinds of knowledge.

#### Spatial Core

The Spatial Core describes what and where the representation claims to describe:

- geometry, including directional extents where required;
- ownership and represented subject; and
- current pose relative to its declared reference.

Geometry may be directly observed or conservatively constructed. It is not automatically exact physical truth.

#### Validity Context

Validity Context states when the representation may still describe its subject.

It may include physical state, ownership, assembly membership, pose freshness, dependencies and any other condition that limits use.

#### Evidence Quality

Evidence Quality describes how strongly the representation supports downstream conclusions, including:

- provenance;
- completeness;
- conservatism and underestimation risk; and
- the classes of conclusion it is permitted to support.

Evidence quality controls claim permissions. Confidence cannot transform incomplete or unrelated metadata into complete collision occupancy.

### Representation Passport

Every downstream representation carries a **Representation Passport** sufficient to describe its physical scope, ownership, provenance, validity dependencies, directional reference, pose validity, coverage, underestimation risk, observation/refresh age, cost characteristics and permitted conclusions.

The passport is the self-description that prevents evidence absence, cheap approximation or discovery provenance from silently acquiring authority.

### Job-Scoped Representation Catalogue

A **Job-Scoped Representation Catalogue** captures stable representation knowledge for one GIANTS AI Job Episode and expires with that Episode.

It may describe equipment selection, purchased configuration, Physical Assembly structure and representation templates justified for the Job scope.

Normal pose and state changes do not require rebuilding stable structure. Unexpected evidence that structure or configuration membership no longer matches the catalogue invalidates the affected claims; it is not permission to preserve stale structure.

The catalogue is representation knowledge. It grants no traffic responsibility.

### Representation Templates and Pose Realisation

A catalogue contains stable **Representation Templates**, not one world-space polygon for every possible pose.

A template may declare contributors, local geometry, construction method, placement method, applicability, provenance, completeness, conservatism and fitness.

**Pose Realisation** combines stable structure with current physical state and pose:

```text
job-scoped structure and templates
        +
current physical state and plan-view pose
        |
        v
current realised occupancy
```

This is **Stable Structure–Dynamic Pose Separation**.

### Configuration Footprint Authority

Job-time physical configuration may change without changing the Job Episode.

**Configuration Footprint Authority** rests in the current realised footprint, its evidence quality and purpose fitness, any required transition sweep, and the equivalent footprint domain to which earlier traversability or clearance evidence legitimately transfers.

Evidence for one working-side footprint does not automatically establish admissibility for an opposite or mirrored footprint, or for the sweep between them.

Implementation tokens, profile ordinals or animation values have no universal physical semantics without independent evidence.

### Component families and heterogeneous composition

Homologous components may share one representation strategy while retaining individual dimensions, identity, placement and pose.

> **Family Strategy–Member Parameter Separation**

A failed member degrades locally unless evidence disproves the family strategy itself.

A realised assembly may mix representation methods and pose authorities. One weak component does not force the entire assembly into its coarsest fallback.

The governing composition rules are:

- **Coverage-First Composition** — prioritise trustworthy coverage before uniform precision;
- **Smallest-Scope Fallback** — add fallback only where unresolved occupancy requires it;
- **Localised Uncertainty** — keep uncertainty attached to affected regions;
- **Precision–Coverage Separation** — treat geometric detail and subject coverage independently; and
- **Layer-Preserving Composition** — retain the provenance and permissions of contributing layers.

### Physical state is multidimensional

Folded and working may describe useful configurations for particular implements, but they are not a universal physical-state axis.

Independently meaningful dimensions may include:

- **Deployment State** — folded, extended or unknown;
- **Vertical Configuration** — raised, lowered, intermediate or unknown;
- **Terrain Contact** — contacting, clear, not applicable or unknown;
- **Functional Engagement** — engaged, disengaged, not applicable or unknown; and
- **Operational Phase** — GIANTS AI activity such as manoeuvring or working.

These dimensions may correlate for a particular implement but are not universally equivalent.

Runtime physical pose is authoritative for representation. Operational Phase and implementation state values are supporting evidence only.

### Configuration–Function Separation

Configuration or pose does not universally establish function.

For direct-soil-contact implements, realised Terrain Contact may be required before ground operation can be treated as functionally engaged. A lower command states intended motion; it does not prove realised contact or engagement.

> **Commanded State != Realised Contact**

The **Planar Relevance Test** determines whether a vertical, functional or configuration change matters to collision representation: it matters only when the realised pose or transition materially changes plan-view occupancy or sweep for the question.

### Configuration motion and Deployment Sweep

Configuration motion may occur while the base vehicle remains stationary. The moving implement continues to consume space.

A **Deployment Sweep** is the plan-view occupancy created by configuration motion while the base vehicle is stationary.

Endpoint occupancy need not contain intermediate occupancy.

> **Endpoint Occupancy != Transition Sweep**

A **Deployment Commitment Point** is the pre-motion boundary at which sufficient transition-clearance knowledge must already exist for the intended conclusion. Observation during the movement may refresh knowledge but cannot retroactively manufacture pre-commitment clearance.

### Planar rigidity and envelope lifecycle

A structure is **Planarly Rigid** while its relative plan-view geometry remains effectively constant. It is planarly articulated when relevant relative plan-view poses change.

Local envelope geometry may be reused while all contributors remain planarly rigid. It must be refreshed or regenerated when relevant relative poses materially change.

Vertical movement alone does not require regeneration when it does not materially alter the plan-view projection or relevant sweep.

### Manoeuvre Sweep

A **Manoeuvre Sweep** results from translation, steering and articulation rather than stationary configuration motion.

Manoeuvre Sweep must not assume midpoint pivoting. **Steering-Mode Sweep Dependency** requires any accepted sweep to reflect the active steering mode and defensible kinematics.

**Detailed Manoeuvre Sweep Construction** remains Deferred. No universal turning-centre, radius, articulation or steering-kinematics construction is authorised by this architecture.

Deployment Sweep and Manoeuvre Sweep remain available concepts for assessments that genuinely require them. A specialised consumer must not promote detailed sweep construction into a prerequisite when its own accepted purpose-specific representation already supplies sufficient authority.

### Inventory Closure and Coverage Closure

**Inventory Closure** means all collision-relevant components for the stated subject and state are known.

Geometry completeness for every discovered member is not Inventory Closure and does not prove that no member remains undiscovered.

> **Known Coverage != Inventory Closure**

**Coverage Closure** means the relevant plan-view occupancy is represented for a stated subject, physical state and intended conclusion.

It may be established through:

- **Enumerative Closure** — authoritative inventory plus representation and pose for every relevant component;
- **Enclosing Closure** — independently proven conservative geometry containing the complete subject; or
- **Hybrid Closure** — precise representations plus smallest-scope fallback covering unresolved remainder.

A purpose-specific representation may establish conclusion-relative closure for its declared purpose while remaining insufficient for another purpose.

Any purpose claiming complete-assembly geometry still requires complete Physical Assembly membership. Generic negative-clearance authority requires relevant generic collision Coverage Closure; completeness of known or local geometry cannot supply it.

### Structural and Realised Coverage Closure

**Structural Coverage Closure** states that representation templates cover all relevant occupancy for a declared subject and physical state.

**Realised Coverage Closure** additionally requires every applicable representation to have a current valid pose.

Assembly closure may compose independently closed members whose closure methods differ, or use an independently proven whole-assembly enclosure.

A **Coverage Ledger** may record closure scope, basis, contributors, unresolved regions, underestimation risk, pose authority, freshness and closure status.

### Layered occupancy claims

Representation remains layered rather than collapsing to one universal geometry.

Permitted knowledge claims include:

- **Conflict Excluded** — current, relevant, non-underestimating closed coverage supports scoped separation;
- **Conflict Supported** — geometry positively supports overlap or convergence;
- **Conflict Possible** — conservative or incomplete coverage leaves a credible conflict route; and
- **Clearance Unresolved** — evidence establishes neither conflict nor safe separation.

Missing, unavailable or non-positive representation evidence cannot establish safe clearance.

Where Realised Coverage Closure is incomplete, partial knowledge remains usable, but the unresolved gap withholds an all-clear wherever that gap can affect the scoped conclusion. This is **Scope-Local Non-Exclusion**.

> **Uncertainty prevents clearance; it does not manufacture collision or separation.**

These are representation claims, not Regulation, Resolution Commitment, Bounded Authority or Control decisions.

### Minimum Sufficient Defensible Portfolio

Assessment Representation seeks the **Minimum Sufficient Defensible Portfolio**, not maximum detail or minimum cost in isolation.

Sufficiency is conclusion-relative. Known overlap may suffice for Conflict Supported. Conservative or incomplete evidence may support Conflict Possible. Only current relevant non-underestimating closed coverage may support Conflict Excluded. Otherwise clearance remains unresolved.

This is **Conclusion-Relative Sufficiency**.

### Demonstrated Traversability

**Demonstrated Traversability** is bounded positive Reality-derived evidence that the real Physical Assembly successfully occupied or traversed a local spatial domain under materially relevant conditions.

Its authority is subject-, state-, purpose- and domain-specific.

Transfer to another conclusion requires materially equivalent Physical Assembly and configuration, compatible local environment, and a proposed spatial domain contained within what was actually demonstrated. Materially different articulation, configuration sweep, steering, kinematics or movement direction may invalidate transfer.

Demonstrated Traversability does not establish universal Inventory Closure or Coverage Closure, exact collision-shape identity, arbitrary reverse feasibility, arbitrary turns, permanent release of space or current availability against another participant.

It contributes only to conclusions for which the bounded evidence is fit.

### Representation cost

A **Representation Cost Profile** may separate acquisition latency, refresh cost, future-projection cost, volatility, expected invalidation, portfolio composition/synchronisation and assessment-delay exposure.

Cost remains separate from evidence fitness.

> **Admissibility Before Optimisation**

Evidence must be defensible for the intended claim before cost may influence representation selection. No universal scalar cost or weighting is selected here.

### Dependency-Scoped Invalidation

A change in Reality invalidates only claims that depended on what changed.

Examples include:

- translation or rotation refreshing pose while stable identity remains valid;
- articulation invalidating affected pose, footprint or sweep;
- attachment/configuration change invalidating affected structure or catalogue claims; and
- Job completion invalidating active-role expectations while preserving still-supported physical identity and obstacle relevance.

**Smallest-Scope Refresh** refreshes only the affected identity, pose, footprint, sweep, structure or projection.

Implementation tolerances for material change remain implementation and validation concerns.

---

## 5. Boundary to Situation Assessment

Assessment Representation publishes evidence, uncertainty, dependencies, age and permitted conclusions.

**Situation Assessment remains the Representation-Fitness Arbiter for the current question.** It determines whether a representation remains fit for the current Situation, plausible futures and horizon.

Assessment Representation does not decide traffic purpose merely because it publishes a geometry or claim permission.

**Assessment-Relative Staleness** means age restricts claim permission according to the question; age does not create a universal discard rule.

Situation Assessment may identify a refresh need. Observation and representation maintenance perform the refresh. Representation fitness does not create Current Responsibility.

---

## 6. Boundary to Cooperative Passage

Cooperative Passage consumes representation but owns its own purpose-specific Resolution contract.

For Passage:

- current working-configuration geometry and directional extents may support current occupancy, productive-corridor competition and Passage recognition;
- a prospective Passage Candidate may use supported complete-assembly compact/Transit geometry for its declared Passage purpose before physical configuration realisation;
- compact/Transit geometry does not supersede current working geometry or make a deployed assembly artificially narrow for recognition;
- current working geometry does not automatically become the compact/Transit Passage envelope;
- complete-assembly claims require complete Physical Assembly membership; and
- directional asymmetry must remain preserved.

The [Spatial Negotiation Architecture](SPATIAL_NEGOTIATION_MODEL.md#candidate-and-commitment-boundary) owns the specialised Candidate/commitment lifecycle and [Reality-verified execution boundary](SPATIAL_NEGOTIATION_MODEL.md#reality-verified-execution). Physical Representation owns only the representation authority those contracts consume.

---

## 7. Player and completion boundaries

### Player obstacle boundary

Player-controlled assemblies are outside cooperative-worker behavioural modelling.

Their physical occupancy may still be represented where it can affect active AI work. Physical relevance does not grant authority to infer, optimise or correct player operating policy.

### Completion and persistent obstacle relevance

GIANTS Job completion ends active Job Episode participation; it does not erase the Physical Assembly from Reality.

```text
active cooperative worker
        |
        v
completed nonmember physical subject
```

This is **Operational Membership–Spatial Relevance Separation**.

**Role-State Invalidation** invalidates active-role and future-motion expectations while preserving any still-supported identity, geometry and final pose.

A completed assembly remains spatially relevant only for as long as current Reality supports its relevance to active work. Physical Representation does not create a post-job parking, tidying or relocation duty.

The Runtime architecture owns any later Causal Obstruction and Obstruction Relocation responsibility.

---

## 8. Deferred questions

The following Physical Representation questions remain Deferred:

- **Envelope Anchor Selection** — no universal conservative-envelope anchor is selected;
- **Detailed Manoeuvre Sweep Construction** — no universal turning or articulation construction is selected;
- **Post-Job Configuration Normalisation** — no post-job configuration behaviour is authorised; and
- **Parked Assessment Deadline Escalation** — no timeout or escalation policy for unrefreshable representation is selected.

These are deferred questions, not implemented responsibilities or Specification Jurisdictions.

Deferral preserves the question without granting architectural or implementation authority.

---

## 9. Architectural invariants and non-goals

Physical Representation does not:

- convert geometric precision into authority without evidence;
- treat discovered-member completeness as proof of complete Physical Assembly inventory;
- allow one purpose-specific representation to silently inherit another purpose's claim permissions;
- infer safe clearance from missing or unresolved evidence;
- flatten provenance, uncertainty or claim permissions when composing representations;
- treat Operational Phase as authoritative physical configuration;
- treat endpoint footprints as proof of configuration-transition clearance;
- require detailed Manoeuvre Sweep construction for consumers already supported by a narrower accepted representation;
- make player-controlled equipment a cooperative worker;
- create post-job parking or tidying responsibility;
- acquire Regulation, Resolution Commitment, Bounded Authority or Control authority; or
- let implementation calibration become architectural policy merely because it currently works.

Reality remains authoritative. New evidence that contradicts these semantics requires explicit architectural review rather than silent implementation accommodation.
