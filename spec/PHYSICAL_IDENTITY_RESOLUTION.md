# Physical Identity Resolution Specification

## Identity and authority

**Specification Jurisdiction:** Physical Identity Resolution  
**Primary Architecture Authority:** [`docs/architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md`](../docs/architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md#3-specification-jurisdiction--physical-identity-resolution)

This Specification owns the implementation-facing contract for defensible correspondence between observed source physical evidence and a runtime physical entity, including the identity, geometry-authority and pose-authority claims that may legitimately be attached to that correspondence.

Physical Identity Resolution does **not** own Physical Assembly inventory closure, occupancy Coverage Closure, downstream Assessment Representation selection, Situation meaning, Regulation, Resolution Commitment, Bounded Authority or Control.

> **Exact physical identity and occupancy authority are different contracts.**

Related Observation supplies source evidence. Assessment Representation consumes admitted identity/geometry/pose claims and may combine them with conservative fallbacks. Neither neighbouring Jurisdiction is redefined here.

## Boundary contract

### Inputs

Physical Identity Resolution consumes current or job-scoped source physical evidence whose provenance is available from Observation or another authorised evidence surface.

A resolution attempt MAY consider, as applicable:

- Physical Assembly member identity/context;
- runtime entity/node candidates;
- component and hierarchy relationships;
- candidate-discovery / Resolution Path provenance;
- entity-local geometry measurements;
- world geometry measurements;
- current pose/transform evidence;
- member-root or assembly-root relationships; and
- independent corroborating or contradictory evidence.

Functional class, gameplay role, asset name or convenient hierarchy proximity MAY guide candidate discovery. They MUST NOT independently establish physical correspondence, geometry authority, pose authority or occupancy completeness.

### Resolution Path

A **Resolution Path** records how a runtime candidate was proposed from source/component/assembly evidence.

Resolution Path provenance MUST remain available for audit and contradiction handling, but the path itself is not authority.

Two different paths may corroborate the same candidate. A greater number of weak paths MUST NOT defeat one mandatory contradiction.

> **Discovery path count is not physical authority.**

### Successful correspondence

A source physical subject may be treated as resolved only when the evidence coherently supports the claims required by the consumer.

Where applicable, resolution MUST establish:

1. the candidate runtime entity exists and is addressable for the required observation;
2. it belongs to the expected Physical Assembly member or otherwise has an explicitly supported ownership relationship;
3. source component/hierarchy relationships are compatible with the candidate;
4. geometry evidence can be attributed to that entity rather than an unrelated/shared alias;
5. current pose can be observed coherently enough for the claimed pose authority; and
6. no unresolved mandatory contradiction establishes a competing coherent identity.

Not every consumer requires every stronger claim. Identity, geometry authority and pose authority MUST remain separable.

### Resolution Claim Set

The semantic output of a successful or partially successful resolution attempt is a **Resolution Claim Set**.

This is a semantic product, not a required Lua class or file name.

A Resolution Claim Set MUST make discoverable, as applicable:

- the source subject / Physical Assembly member being resolved;
- the candidate runtime entity identity or reference;
- identity authority actually established;
- geometry authority actually established;
- pose authority actually established;
- supporting evidence and Resolution Path provenance;
- contradictory or rejected evidence relevant to the claim;
- validity dependencies; and
- explicit limits on conclusions the claim may support.

A claim set MAY be represented across several current implementation records provided those semantics remain available and coherent to the consuming representation contract.

> **Semantic product identity does not require one concrete source type.**

### Claim-specific confidence

Identity confidence, geometry confidence, pose freshness, path corroboration and completeness MUST NOT be collapsed into one universal score if doing so would let strength in one claim silently upgrade another.

A consumer must be able to distinguish, for example:

- high-confidence identity with unresolved complete geometry;
- useful entity-local geometry with limited occupancy completeness;
- coherent geometry with stale or unavailable pose; and
- conservative occupancy evidence without exact runtime shape identity.

## Entity-local shape-evidence contract

Entity-local physical evidence may be admitted when already-acquired local geometry and current world geometry/pose are mutually coherent for the bounded claim.

The current architecture names two important evidence questions:

- **Geometry–World Coherence** — whether entity-local geometry transformed by current pose agrees with observed world geometry sufficiently for the claimed correspondence; and
- **Descendant–Root Alias Discrimination** — whether an apparent descendant shape is distinguishable from an alias of its Physical Assembly member root.

A candidate that is established as a root alias where an independent descendant identity is required MUST NOT be admitted as that independent physical entity.

The exact numeric tolerances used by the current evidence evaluator are implementation/validation calibration and are **not** normative requirements of this Specification.

> **Accepted Implementation Value != Specification Requirement.**

Changing a tolerance is a Spec change only if evidence proves that a durable cross-boundary identity/geometry contract requires a particular value or bound.

## Durable invariants

### Identity success does not imply occupancy completeness

A resolved runtime entity MUST NOT automatically grant Inventory Closure, Coverage Closure, complete collision occupancy or negative-clearance authority.

Those are separate Assessment Representation / purpose-specific contracts.

### Occupancy evidence does not require exact identity in all cases

Failure to establish exact identity MUST NOT force downstream code to discard independently defensible conservative occupancy evidence. Physical Identity Resolution must report its own claim limit; Assessment Representation decides whether another representation remains useful.

### Geometry authority is attributable

Geometry admitted as entity-local evidence MUST be attributable to the claimed runtime entity/member relationship. Shared aliases, incoherent transforms or unrelated node measurements MUST NOT be silently promoted.

### Pose authority is explicit

A geometry claim with no defensible current pose MUST NOT be presented as current world occupancy merely because local geometry exists.

### Contradiction outranks weak corroboration

An unresolved mandatory contradiction MUST block the stronger claim it contradicts. Additional weak corroborating paths MUST NOT numerically vote it away.

### Resolution provenance survives downstream use

Downstream consumers MUST be able to use the admitted claim without reconstructing candidate-discovery mechanics, while enough provenance remains attached for contradiction, debugging and reassessment.

### Functional class does not establish structure

Agronomic role, implement category or gameplay class MUST NOT substitute for physical structural evidence.

### Purpose authority does not broaden automatically

A claim sufficient to identify geometry for one bounded purpose MUST NOT silently gain authority for another purpose, horizon or completeness question.

## Failure and uncertainty semantics

Physical Identity Resolution is expected to produce partial and unresolved outcomes.

- **Resolved identity / geometry / pose claim** — publish only the claims actually supported and their limits.
- **Candidate unavailable or deleted** — do not retain a stale positive identity solely from historical discovery.
- **Required runtime API unavailable** — mark the affected claim unresolved/unavailable; do not manufacture a negative identity conclusion.
- **Geometry/world incoherence** — reject the affected geometry correspondence; retain diagnostic contradiction evidence where useful.
- **Root-alias evidence** — reject the independent descendant claim that the alias contradicts.
- **Competing coherent candidate** — stronger identity remains unresolved until the governing contract can discriminate or fail closed.
- **Pose unavailable/stale** — identity may remain supported while current pose authority does not.
- **Discovery scan/budget truncation** — MUST NOT be represented as proof that no additional physical entity exists.
- **Only partial member evidence available** — publish only partial claims; do not imply Coverage Closure.

Fresh evidence or a different Resolution Path may retry an unresolved claim. Retry does not permit historical evidence to be restamped as current without revalidation of the dependencies that changed.

## Cross-Jurisdiction dependencies

### Observation

Observation owns acquisition and provenance of source physical evidence. Physical Identity Resolution interprets that evidence only for physical correspondence/authority questions and MUST NOT mutate the raw Observation into a broader semantic conclusion.

### Assessment Representation

Assessment Representation consumes admitted claims and composes the best defensible occupancy account for a purpose. It owns Coverage Closure, representation portfolio selection, uncertainty composition and downstream claim permissions.

A Physical Identity Resolution success therefore does not tell Situation Assessment which representation to use.

### Situation Assessment and downstream traffic responsibilities

Those Jurisdictions may consume representation products downstream. Physical Identity Resolution itself creates no Regulation, Resolution Commitment, Bounded Authority or Control permission.

## Implementation traceability

The following mapping is **non-normative source traceability**.

Current implementation is intentionally not one-module-per-Jurisdiction.

Relevant implementation routes include:

- [`scripts/representation/AssemblyRepresentationCache.lua`](../scripts/representation/AssemblyRepresentationCache.lua) — current shared mechanism for Physical Assembly discovery, candidate hierarchy scanning, entity-local geometry measurement, rejection/provenance capture and job-scoped representation knowledge;
- [`scripts/representation/EntityLocalShapeEvidence.lua`](../scripts/representation/EntityLocalShapeEvidence.lua) — current shared bounded evaluator for geometry/world coherence and root-alias discrimination;
- current physical-evidence sources under [`scripts/observation/`](../scripts/observation/) — Observation-owned inputs supplying assembly and pose evidence; and
- shared representation consumers that reuse admitted entity-local evidence for their own separate products.

`AssemblyRepresentationCache.lua` spans more than Physical Identity Resolution. Only the semantic slice that establishes correspondence/claim evidence is governed by this Specification; cache lifetime, coverage composition and final Assessment Representation permissions belong to neighbouring contracts.

> **Primary Specification != Primary Source Module**

A future refactor may split or merge these modules without changing this contract.

## Validation route

### Structural/source-contract validation

Current structural evidence includes:

- [`tests/test_entity_local_shape_evidence_ownership_structure.py`](../tests/test_entity_local_shape_evidence_ownership_structure.py), which protects shared evidence ownership and ensures the evidence evaluator does not acquire downstream representation-product authority;
- [`tests/test_assembly_discovery_bound_ownership_structure.py`](../tests/test_assembly_discovery_bound_ownership_structure.py); and
- [`tests/test_representation_cache_bound_ownership_structure.py`](../tests/test_representation_cache_bound_ownership_structure.py).

These tests protect current implementation placement/ownership and selected contract boundaries; they do not become normative authority for the Spec.

### Offline behavioural/conformance validation

[`tests/replacement_core/run.lua`](../tests/replacement_core/run.lua) contains behavioural witnesses for entity-local coherence and root-alias discrimination and exercises downstream representation use in the offline harness.

Offline evidence can validate the implementation contract under stubbed runtime semantics. It cannot prove the equivalence of GIANTS shape APIs, node ownership or live transforms in-game.

### Targeted in-game Reality validation

Claims that depend on GIANTS runtime entity hierarchy, shape APIs, transform coherence, attached-implement structure or live configuration require targeted in-game Reality evidence.

### Outside this Specification's validation claim

A correct Resolution Claim Set does not establish complete Physical Assembly inventory, Coverage Closure, safe negative clearance, Passage fitness or any traffic responsibility.

Those are neighbouring Assessment Representation, purpose-specific representation and downstream runtime contracts.
