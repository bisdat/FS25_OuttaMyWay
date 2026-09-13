# Specification surface

## Purpose

`/spec` is OuttaMyWay's implementation-facing contract surface.

Architecture under `/docs` defines **what the system should achieve and why its responsibilities exist**. A primary Specification defines **what an implementation of one declared Specification Jurisdiction must preserve, expose, reject, sequence or report in order to realise that Architecture**. Source under `/scripts` defines the current mechanism that attempts to satisfy that contract. Tests provide evidence about the contract; they do not own it.

```text
/docs
Architecture — what / why
        ⇅
/spec
Specification — implementation-facing contract
        ⇅
/scripts
Implementation — current mechanism
        ⇅
/tests and Reality
Validation evidence
```

This surface specialises the repository rules in [`docs/DOCUMENT_STANDARDS.md`](../docs/DOCUMENT_STANDARDS.md). Where the two disagree, `DOCUMENT_STANDARDS.md` remains the higher-level documentation authority.

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

A Specification translates architectural responsibility into an implementable contract. It MUST NOT become a second copy of Architecture and MUST NOT redefine architectural meaning merely to match current source.

## Primary ownership

Every implemented Specification Jurisdiction declared by Architecture MUST have exactly one primary Specification.

Every primary Specification MUST:

- identify exactly one governing **Specification Jurisdiction**;
- identify its **Primary Architecture Authority**;
- distinguish related architectural context from primary authority;
- own one cohesive implementation-facing contract;
- provide a discoverable route toward the current implementation; and
- provide a discoverable validation route for the contract it defines.

A primary Specification MUST NOT be created from a source file, class, helper, document heading or implementation subsystem merely because that unit exists. Specification identity follows the architectural Jurisdiction.

A specialised Jurisdiction MAY depend on another Jurisdiction. Its Specification MUST reference the parent or neighbouring contract rather than restating or claiming ownership of that contract.

A recognised Deferred Responsibility with no implementation requirement MAY remain without a Specification. Placeholder, empty or speculative Specifications MUST NOT be created for symmetry.

## Current primary Specifications

The currently migrated primary Specifications are:

| Specification Jurisdiction | Primary Specification |
| --- | --- |
| **Operation Lifecycle** | [`OPERATION_LIFECYCLE.md`](OPERATION_LIFECYCLE.md) |
| **Observation** | [`OBSERVATION.md`](OBSERVATION.md) |
| **Situation Assessment** | [`SITUATION_ASSESSMENT.md`](SITUATION_ASSESSMENT.md) |
| **Responsibility Transition** | [`RESPONSIBILITY_TRANSITION.md`](RESPONSIBILITY_TRANSITION.md) |
| **Regulation** | [`REGULATION.md`](REGULATION.md) |
| **Resolution Lifecycle** | [`RESOLUTION_LIFECYCLE.md`](RESOLUTION_LIFECYCLE.md) |
| **Obstruction Relocation** | [`OBSTRUCTION_RELOCATION.md`](OBSTRUCTION_RELOCATION.md) |
| **Cooperative Passage** | [`COOPERATIVE_PASSAGE.md`](COOPERATIVE_PASSAGE.md) |
| **Physical Identity Resolution** | [`PHYSICAL_IDENTITY_RESOLUTION.md`](PHYSICAL_IDENTITY_RESOLUTION.md) |
| **Assessment Representation** | [`ASSESSMENT_REPRESENTATION.md`](ASSESSMENT_REPRESENTATION.md) |
| **Candidate Support** | [`CANDIDATE_SUPPORT.md`](CANDIDATE_SUPPORT.md) |
| **Constraint Evaluation** | [`CONSTRAINT_EVALUATION.md`](CONSTRAINT_EVALUATION.md) |
| **Decision** | [`DECISION.md`](DECISION.md) |
| **Bounded Authority** | [`BOUNDED_AUTHORITY.md`](BOUNDED_AUTHORITY.md) |
| **Control** | [`CONTROL.md`](CONTROL.md) |

All currently implemented Specification Jurisdictions declared by accepted Architecture now have primary Specifications. **Configuration** remains a Deferred Responsibility and therefore correctly has no placeholder Specification.

This index is navigation, not a second Jurisdiction catalogue. Architecture remains authoritative for the complete Jurisdiction inventory and ownership relationships.

## The Specification contract spine

Primary Specifications do not require one rigid heading template. They MUST, however, make the following semantic obligations directly discoverable.

### 1. Identity and authority

The Specification MUST make clear:

- which Specification Jurisdiction it implements;
- which Architecture is primary authority;
- what implementation-facing responsibility this Specification owns; and
- which neighbouring responsibilities it deliberately does not own where confusion is plausible.

The responsibility statement MUST be implementation-facing rather than a pasted architectural summary.

### 2. Boundary contracts

The Specification MUST define the semantic boundary by which the Jurisdiction participates in the wider system.

As applicable, this includes:

- accepted inputs, evidence or upstream products;
- identity, freshness, provenance or validity requirements on those inputs;
- products, outcomes or guarantees produced by the Jurisdiction;
- downstream consumers and the limits of what those products may establish;
- ownership of any state or identity crossing the boundary; and
- preconditions or admission conditions that must hold before the contract can produce its stronger conclusions.

Boundary contracts describe semantic obligations. They MUST NOT be reduced to a current Lua function signature or helper call graph.

### 3. Durable invariants

The Specification MUST identify the implementation-facing invariants necessary to preserve the governing Architecture.

An invariant belongs in Specification when an implementation could plausibly violate it while appearing locally convenient.

Examples include preserving provenance, atomic replacement, exact-picture identity, non-overlapping responsibility ownership, completeness requirements, or claim-specific uncertainty.

Where Architecture already owns the normative rule, the Specification MUST reference that authority and state the implementation obligation it creates rather than independently redefining the architectural rule.

> **Traceability Replaces Duplicated Authority.**

### 4. Failure and uncertainty semantics

Every primary Specification MUST define how the Jurisdiction behaves when required evidence, capability, representation, consistency or execution preconditions are absent, contradictory, stale or unsupported.

The Specification MUST make clear which outcomes are:

- positively supported;
- positively contradicted;
- unresolved or unavailable;
- rejected / fail-closed;
- retryable through fresh evidence or reassessment; or
- terminal within the Jurisdiction's own contract, where such terminal semantics exist.

Failure semantics MUST preserve the Architecture's authority boundaries. Failure MUST NOT manufacture a stronger conclusion merely to keep the implementation active.

### 5. Implementation traceability

Every primary Specification MUST provide a discoverable route to the implementation that currently realises it.

Exact source-file, function and helper placement are traceability facts, not normative contract meaning. They MAY be supplied by generated reference or by a clearly non-normative authored mapping while generated traceability is not yet available.

A primary Specification does not imply one primary source module. One Jurisdiction may be realised by several modules, and one module may realise semantic slices of several neighbouring contracts, provided ownership remains explicit and traceable.

> **Primary Specification != Primary Source Module**

Generated implementation reference MUST remain distinguishable from authored Specification text. Generated reference may report source facts; it MUST NOT become the owner of implementation-contract semantics.

When implementation topology changes without changing the contract, the Specification's normative meaning SHOULD remain stable. The legitimate exception is a topology change that reveals the Specification itself named an implementation mechanism rather than a durable contract boundary; that is contract-design evidence and the Specification SHOULD then be corrected deliberately.

### 6. Validation route

Every primary Specification MUST identify how its contract is challenged.

The route MUST distinguish, as applicable:

- structural/source-contract validation;
- offline behavioural/conformance validation;
- targeted in-game Reality validation; and
- evidence that lies outside the claim of the Specification.

A Specification MUST NOT maintain rolling pass/fail counts, build-by-build evidence, scenario chronology or CI run history.

> **Tests Are Contract Evidence, Not Contract Authority.**

A test link establishes a validation route. It does not transfer contract ownership to the test.

## Conditional contract sections

The contract spine defines semantic obligations, not mandatory Markdown headings. Additional sections become mandatory when the Jurisdiction's semantics require them.

### Lifecycle or ordered flow

When a Jurisdiction owns progression, persistence, atomic replacement, obligation discharge, terminal disposition or order-sensitive processing, its Specification MUST define that lifecycle or ordered flow sufficiently for implementation and debugging.

This requirement is expected to be central for lifecycle-rich Jurisdictions such as Responsibility Transition or Cooperative Passage, but MUST NOT force artificial state machines onto evidence-acquisition or resolution contracts that do not own one.

A tactical flowchart MAY be used where it materially clarifies the contract. Normative meaning MUST remain available in text.

### Semantic data contracts

Where a Jurisdiction publishes or consumes durable semantic products, the Specification MUST define the fields or properties whose meaning is contractually significant.

This may include identity, provenance, evidence quality, freshness, completeness, claim permissions, terminal disposition, support provenance or exact-picture binding.

A semantic data contract MUST describe meaning and required relationships. It MUST NOT become an exhaustive dump of current object members merely because those members exist in source.

### Cross-Jurisdiction dependencies

Where a contract depends on another Jurisdiction, the Specification MUST identify the dependency and the assumption made about the neighbouring contract.

It MUST NOT copy the neighbouring contract into its own text. Cross-Jurisdiction architectural rules retain one architectural owner; affected Specifications reference that authority.

## Architecture, Specification and implementation values

Architecture owns architectural policy and system responsibility. Specification owns the implementation-facing obligation needed to realise that Architecture. Source owns current mechanism and calibration unless a value is part of the accepted contract.

> **Accepted Implementation Value != Specification Requirement.**

A literal, threshold, timeout, sample count, tolerance, geometry constant or algorithm parameter MUST NOT become a Specification requirement solely because current source uses it or tests happen to assert it.

A value belongs in normative Specification only when changing it would violate:

- explicit Architecture;
- an accepted cross-boundary contract;
- a required compatibility or interoperability condition; or
- another durable implementation-facing invariant.

Where Architecture itself owns an exact value or policy, the Specification MUST reference that architectural authority and express the implementation obligation without claiming independent ownership of the value.

Implementation-local calibration belongs in source documentation or generated reference unless evidence later proves that a stronger contract exists.

## Current truth, history and unresolved work

A primary Specification describes the current accepted implementation-facing contract.

It MUST NOT become the primary owner of:

- engineering chronology;
- PR or Issue narratives;
- migration/tranche history;
- rolling test results;
- build identity history;
- unresolved work queues;
- speculative future APIs;
- abandoned implementation generations; or
- current-source trivia with no contract significance.

Issues own unresolved work. Git, pull requests, the Engineering Journal, Research and scenario records own historical evidence as applicable.

A supported limitation MAY be stated in Specification when it is part of the accepted current contract. An unresolved idea MUST NOT be promoted into Specification merely because implementation work is expected later.

## Source documentation boundary

Specification is not source documentation.

Source documentation explains how a module or semantic boundary realises its contract and why non-obvious mechanisms exist. A source module MAY link to its governing Specification. The Specification MUST NOT duplicate ordinary helper topology, private algorithm steps or exhaustive APIs when those facts can change without changing the contract.

Public interfaces almost always require source documentation. Private mechanisms require explanation when they establish, transform, validate or terminate important semantic authority or when their behaviour would otherwise be misleading.

> **Semantic Boundary Requires Documentation.**

The future source-documentation/tooling increment will define the exact source annotation and generated-reference mechanism. This README intentionally does not select LDoc, LuaLS/LuaCATS or another toolchain.

## Validation against different Jurisdiction shapes

The contract spine is intentionally capable of representing materially different contracts without forcing identical prose structure:

- an evidence-oriented Jurisdiction must make provenance, freshness, uncertainty and output permissions explicit;
- a lifecycle-oriented Jurisdiction must make establishment, persistence, atomicity and terminal boundaries explicit;
- a specialised Resolution Jurisdiction must make parent-contract dependencies, obligations, execution-validity boundaries and failure/handback semantics explicit;
- an identity/representation Jurisdiction must make claim composition, contradiction, validity and permitted conclusions explicit; and
- a prospective-selection Jurisdiction must make input-picture identity, support completeness, provenance, fail-closed composition and downstream handoff explicit.

These are examples of contract shape, not separate authoring templates.

## Maintenance and review test

Before accepting or materially changing a primary Specification, ask:

- Can a new engineer identify the governing Jurisdiction and primary Architecture without source archaeology?
- Does the Specification state an implementation-facing contract rather than paraphrase Architecture?
- Are its boundary products, identity/freshness rules and failure semantics explicit enough to implement and debug?
- Are lifecycle/ordering semantics present where the Jurisdiction actually owns them?
- Are neighbouring contracts referenced rather than duplicated?
- Can current source be reached without source placement becoming normative meaning?
- Can the contract be challenged through a clear validation route without embedding validation history?
- Did any current implementation value become normative merely because it exists today?
- Would the Specification remain meaningful if the internal mechanism were replaced?

A useful Specification is one whose implementation can change substantially while the contract remains stable, unless Reality or architectural change proves that the contract itself was wrong.
