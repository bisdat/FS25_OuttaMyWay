# Assessment Representation Specification

## Identity and authority

**Specification Jurisdiction:** Assessment Representation  
**Primary Architecture Authority:** [`docs/architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md`](../docs/architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#4-specification-jurisdiction--assessment-representation)

This Specification owns the implementation-facing contract for constructing, maintaining and publishing the most informative **defensible spatial representation** for a declared subject, physical state, purpose and conclusion scope.

Assessment Representation owns geometry products, validity context, coverage, uncertainty, provenance, claim permissions, refresh boundaries and purpose scope. It does **not** own Situation interpretation, strategic Candidate choice, Responsibility Transition, Regulation, Resolution Commitment, Bounded Authority or Control.

[`PHYSICAL_IDENTITY_RESOLUTION.md`](PHYSICAL_IDENTITY_RESOLUTION.md) is a neighbouring upstream contract, not a parent lifecycle. Assessment Representation may consume its admitted identity/geometry/pose claims, but exact identity success is neither sufficient nor universally necessary for every defensible occupancy product.

> **Representation Product != Fitness Verdict**

Assessment Representation publishes what a representation may legitimately support. Situation Assessment remains the arbiter of whether that representation is fit for the current question.

## Boundary contract

### Inputs

Assessment Representation may consume, as applicable:

- admitted Physical Identity Resolution claims;
- current physical pose and configuration evidence from Observation;
- Physical Assembly structure and membership evidence;
- direct current occupancy evidence;
- conservative enclosing or fallback evidence;
- job-scoped stable structure/configuration knowledge;
- current articulation, deployment, vertical/contact or other physical-state evidence relevant to plan-view occupancy;
- purpose-specific geometry evidence accepted by a specialised consumer contract; and
- prior representation products whose stated validity dependencies remain satisfied.

The implementation MUST preserve the provenance and claim limits of each contributor. A weak or partial input MUST NOT silently gain stronger authority merely because it is composed with other evidence.

### Representation product

Every published representation product MUST make three semantic classes of information recoverable, whether or not the implementation stores them in one concrete object.

#### Spatial Core

The product MUST identify what spatial occupancy it claims and for which subject/reference, including geometry and directional/asymmetric extents where the conclusion requires them.

The product MUST distinguish directly observed geometry from conservative construction or fallback where that difference affects permitted conclusions.

#### Validity Context

The product MUST identify the dependencies under which it remains usable, including as applicable:

- Physical Assembly membership/ownership;
- physical configuration or state;
- pose/reference validity;
- job-scoped catalogue identity;
- purpose/question scope;
- observation or refresh dependency; and
- any transition/sweep condition that limits endpoint-only geometry.

#### Evidence Quality and claim permissions

The product MUST preserve enough evidence quality to determine what it may legitimately prove, including as applicable:

- provenance;
- completeness/coverage state;
- conservatism and underestimation risk;
- uncertainty and unresolved regions;
- freshness/age or refresh need;
- cost/volatility characteristics when relevant to selection; and
- explicitly permitted conclusion classes.

These semantics collectively form the architectural **Representation Passport**. The current implementation MAY distribute them across several records; this contract does not require one class or file named `RepresentationPassport`.

> **Semantic Product != Required Concrete Source Type**

## Representation portfolio contract

One Physical Assembly MAY have several simultaneously valid representation products for different questions.

The implementation MUST support layered representation authority rather than collapsing all geometry into one universal "best" shape.

Architecturally recognised product families include:

- Component Footprint Set;
- Convex Planar Envelope;
- Member-Level Rectangle;
- Assembly-Level Rectangle; and
- Unknown Occupancy.

The portfolio is not a universal precision ranking. A coarse complete representation may support a conclusion that a precise but incomplete representation cannot.

The implementation MUST prefer the **Minimum Sufficient Defensible Portfolio** for the question rather than maximum detail or minimum cost in isolation.

> **Admissibility Before Optimisation**

Cost may influence selection only after the representation is defensible for the intended claim.

### Heterogeneous composition

A realised assembly MAY combine different representation methods and pose authorities across members/components.

Composition MUST preserve:

- **Coverage-First Composition**;
- **Smallest-Scope Fallback**;
- **Localised Uncertainty**;
- **Precision–Coverage Separation**; and
- **Layer-Preserving Composition**.

One weak member MUST NOT force unrelated well-supported members to lose their stronger local claims. Conversely, strong local precision MUST NOT be mistaken for complete-assembly coverage.

## Coverage and conclusion contract

### Inventory Closure

Inventory Closure means all collision-relevant components for the stated subject/state are known.

Complete geometry for all **discovered** members does not prove Inventory Closure.

> **Known Coverage != Inventory Closure**

### Coverage Closure

Coverage Closure means the relevant plan-view occupancy is represented for a stated subject, physical state and intended conclusion.

The implementation MAY establish closure through:

- enumerative closure;
- independently proven enclosing closure; or
- hybrid closure combining precise layers with smallest-scope fallback.

Complete-assembly geometry claims require complete Physical Assembly membership or another independently defensible whole-assembly enclosure. Generic negative-clearance authority requires the relevant generic collision Coverage Closure.

A purpose-specific representation MAY establish conclusion-relative closure for its declared purpose while remaining insufficient for another purpose.

### Structural vs realised closure

The implementation MUST distinguish stable structural/template coverage from current realised coverage when pose/state freshness matters.

Structural Coverage Closure does not imply Realised Coverage Closure when one or more applicable representations lack a current valid pose.

### Layered occupancy claims

The following architectural claim classes MUST retain distinct evidence requirements:

- **Conflict Excluded** — current, relevant, non-underestimating closed coverage supports scoped separation;
- **Conflict Supported** — geometry positively supports overlap or convergence;
- **Conflict Possible** — conservative or incomplete coverage leaves a credible conflict route; and
- **Clearance Unresolved** — evidence establishes neither conflict nor safe separation.

Missing, unavailable or non-positive evidence MUST NOT establish `Conflict Excluded`.

Where incomplete coverage can affect the scoped conclusion, the unresolved gap withholds an all-clear without manufacturing a positive collision claim.

> **Uncertainty prevents clearance; it does not manufacture collision or separation.**

## Stable structure and dynamic pose

Job-scoped representation knowledge MAY cache stable structure, purchased configuration, assembly relationships and representation templates for one active Job Episode.

Normal translation/rotation or other dynamic pose change MUST NOT require rediscovery of stable structure when its dependencies remain valid.

Current realised occupancy MUST combine stable structure/templates with current physical state and pose.

> **Stable Structure–Dynamic Pose Separation**

Unexpected evidence that assembly structure or configuration membership no longer matches the cached catalogue invalidates the affected claims. The implementation MUST NOT preserve stale structure solely because rediscovery is expensive.

Job-scoped catalogue authority expires with the Job Episode for claims whose validity depends on that scope. Physical identity/obstacle evidence that remains independently supported by Reality may persist through separate representation routes.

## Physical-state and configuration contract

Physical state is multidimensional. Fold state, vertical configuration, terrain contact, functional engagement and operational phase MUST NOT be collapsed into one universal configuration axis when their physical meanings differ.

Runtime realised physical pose is authoritative for representation. Operational phase or implementation tokens are supporting evidence only.

### Configuration–Function Separation

Configuration/pose does not universally establish functional engagement.

For direct-soil-contact equipment, a command to lower or unfold does not prove realised contact or functional engagement.

> **Commanded State != Realised Contact**

### Planar relevance

A physical-state change matters to this Jurisdiction only when it affects the plan-view occupancy/sweep or claim validity relevant to the current question.

Vertical change alone MUST NOT invalidate or regenerate plan-view representation if evidence supports unchanged relevant plan-view occupancy.

### Transition sweep

Endpoint occupancy MUST NOT be used as proof of safe configuration transition when the intermediate **Deployment Sweep** can occupy additional space.

Where a consumer requires transition-clearance authority, sufficient evidence MUST exist before the Deployment Commitment Point; later observation cannot retroactively manufacture pre-commitment clearance.

Detailed Manoeuvre Sweep construction remains deferred unless a consumer contract genuinely requires it. A specialised purpose-specific representation that is already sufficient MUST NOT be rejected merely because a more elaborate generic sweep model is absent.

## Purpose-scoped authority

Every representation's authority is scoped to its declared subject, physical state, purpose/question, horizon, coverage basis, validity dependencies and permitted conclusions.

A representation that is sufficient for one purpose MUST NOT automatically inherit another purpose's claim permissions.

In particular:

- positive current-conflict evidence may support `Conflict Supported` while having no negative-clearance authority;
- purpose-specific Transit/Passage geometry may support Cooperative Passage planning/execution questions without becoming generic current-working collision truth; and
- current relocation-reference evidence may support bounded obstruction-relocation planning without proving safe clearance elsewhere.

> **Purpose-Specific Representation Authority Takes Precedence.**

The correct question is not "which representation is globally best?" but "which defensible representation has the permissions required for this conclusion?"

## Dependency-scoped invalidation

A change in Reality MUST invalidate only claims that depended on what changed.

Examples include:

- translation/rotation refreshing pose while stable identity remains valid;
- articulation invalidating affected pose/footprint/sweep while unrelated structure remains valid;
- attachment/configuration change invalidating affected structure/catalogue claims; and
- Job completion invalidating active-role/future-motion assumptions while independently supported final occupancy may remain relevant.

The implementation SHOULD perform **Smallest-Scope Refresh** rather than discarding the whole portfolio when a narrower dependency changed.

Implementation tolerances for deciding material change are mechanism unless a stronger contract explicitly owns them.

## Boundary to Situation Assessment

Assessment Representation publishes representation evidence, uncertainty, dependencies, age and permitted conclusions.

Situation Assessment owns the **Representation-Fitness Arbiter** role for the current question and horizon.

The implementation MUST preserve this boundary:

- Assessment Representation MAY say what a representation permits;
- Situation Assessment MAY determine whether those permissions are fit/current for a specific Situation;
- neither representation construction nor a source publishing layer may turn geometry directly into Regulation, Resolution Commitment or Control authority.

A refresh need MAY be identified downstream, but Observation/representation maintenance performs the refresh.

## Failure and uncertainty semantics

- **Structurally invalid representation** — publish no stronger claim than the remaining independently supported evidence permits.
- **Pose or state dependency stale** — mark affected claim unresolved/refresh-required; do not preserve stale world occupancy.
- **Coverage incomplete** — retain supported partial positive/conflict-possible claims, but withhold negative-clearance conclusions affected by the gap.
- **Inventory unresolved** — do not convert known-member completeness into complete-assembly closure.
- **Purpose mismatch** — reject transfer of claim authority to the new question unless independent evidence establishes equivalence.
- **Configuration transition not covered** — endpoint geometry does not authorise the sweep.
- **One component/member degrades** — localise uncertainty/fallback where possible; do not erase unrelated valid layers.
- **No trustworthy occupancy evidence** — publish Unknown Occupancy / unresolved clearance rather than a fabricated empty footprint.

Failure to prove safe clearance MUST NOT manufacture a collision, and failure to prove a collision MUST NOT manufacture safe clearance.

## Durable invariants

### Representation precision does not create authority

More detailed geometry may improve a product but cannot widen its permitted conclusions without supporting evidence.

### Coverage and precision remain separate

A precise partial representation and a coarse complete representation have different authority. The implementation MUST preserve that distinction.

### Purpose scope cannot silently widen

Authority for Passage, relocation, positive-conflict or another declared purpose remains bounded to that purpose unless an independently supported contract grants broader use.

### Provenance and uncertainty survive composition

Composition MUST NOT erase the limitations of contributing evidence.

### Current pose governs realised occupancy

Cached/stable structure is reusable; stale world pose is not.

### Representation does not acquire traffic responsibility

No representation product may establish Regulation, Resolution Commitment, Bounded Authority or Control permission merely by being spatially informative.

## Cross-Jurisdiction dependencies

### Physical Identity Resolution

[`PHYSICAL_IDENTITY_RESOLUTION.md`](PHYSICAL_IDENTITY_RESOLUTION.md) supplies admitted identity/geometry/pose claims where available. Assessment Representation consumes those claims without promoting identity success into Coverage Closure.

### Observation

[`OBSERVATION.md`](OBSERVATION.md) acquires/preserves current raw evidence and unavailable-source facts. Representation construction must retain their provenance and freshness limits.

### Situation Assessment

Situation Assessment determines representation fitness for the current question. This Jurisdiction supplies the claim-bearing product; it does not decide current traffic meaning.

### Cooperative Passage

[`COOPERATIVE_PASSAGE.md`](COOPERATIVE_PASSAGE.md) consumes purpose-specific representation for Passage recognition, Candidate planning and Reality-verified execution. It owns the Passage question and specialised sufficiency requirements; this Jurisdiction owns the evidence product and its claim permissions.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation routes include:

- [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua) — current Job-Episode-scoped assembly representation catalogue, local primitives, physical/configuration evidence and purpose-specific Transit Passage products;
- [`scripts/representation/CurrentPhysicalConflictRepresentation.lua`](../scripts/representation/CurrentPhysicalConflictRepresentation.lua) — current positive-conflict representation with explicit `coverageComplete=false` and `negativeClearanceAuthority=false` limits;
- [`scripts/representation/PlanViewFootprint.lua`](../scripts/representation/PlanViewFootprint.lua) — current plan-view footprint summarisation mechanism;
- [`scripts/observation/CurrentPhysicalPoseSource.lua`](../scripts/observation/CurrentPhysicalPoseSource.lua) and neighbouring Observation sources — current publication of purpose-scoped physical-representation evidence into the Observation boundary; and
- [`scripts/assessment/RepresentationFitness.lua`](../scripts/assessment/RepresentationFitness.lua) — current **consumer-side Situation Assessment** fitness evaluation. Its placement is useful traceability but it does not transfer the Representation-Fitness Arbiter responsibility into this Specification.

Current source does not require one universal Representation object or concrete `RepresentationPassport` type. Contract semantics may be distributed across representation records so long as scope, validity, provenance, uncertainty, coverage and claim permissions remain coherently recoverable.

> **Representation Product != Fitness Verdict**

## Validation route

### Structural/source-contract validation

Relevant structural evidence includes:

- [`tests/test_representation_cache_bound_ownership_structure.py`](../tests/test_representation_cache_bound_ownership_structure.py) — separate discovery-budget and revalidation validity domains;
- [`tests/test_entity_local_shape_evidence_ownership_structure.py`](../tests/test_entity_local_shape_evidence_ownership_structure.py) — shared physical evidence without representation-product authority leakage; and
- [`tests/test_replacement_core_structure.py`](../tests/test_replacement_core_structure.py) — wider representation/assessment ownership and downstream boundary checks.

Structural tests that assert current numeric scan budgets or refresh intervals validate source ownership, not normative Specification values.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) exercises representation-fitness, claim-permission, conflict/clearance uncertainty and purpose-scoped geometry behaviour in the offline harness.

Offline evidence can challenge product semantics and uncertainty propagation. It cannot prove that GIANTS runtime geometry APIs are complete or physically faithful for every equipment topology.

### Targeted in-game Reality validation

Reality validation is required for complete Physical Assembly coverage, realised configuration footprints, directional asymmetry, compound-shape correspondence, Deployment Sweep assumptions and purpose-specific Passage/obstruction geometry.

### Outside this Specification's validation claim

A defensible representation product does not prove that Situation Assessment interpreted it correctly, that a Candidate should be selected, or that a physical manoeuvre is safe beyond the product's declared claim permissions.