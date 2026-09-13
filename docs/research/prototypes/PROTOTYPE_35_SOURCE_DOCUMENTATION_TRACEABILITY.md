# Prototype 35 — Source Documentation and Traceability

## Status

Bounded non-production prototype evidence for Issue #141.

This record does **not** establish the live source-documentation standard. It tests whether a candidate model can represent real current implementation shapes without turning source topology, comments, tests or generated output into normative system authority.

No production Lua is changed by this prototype.

## Question

Can OuttaMyWay describe source responsibility and generate useful implementation reference while preserving the accepted authority chain:

```text
Architecture
what / why
    |
    v
Specification
implementation-facing contract
    |
    v
Source
current mechanism
    |
    v
Tests + Reality
contract evidence
```

Specifically, can the model survive all of the following without forcing a one-module/one-Spec fiction?

1. a semantic producer;
2. a large physical Control implementation;
3. a low-semantic-authority shared substrate; and
4. a compact contract-value declaration.

## Fixtures

The prototype uses four current production donors without modifying them:

- [`TrajectoryConflictAssessment.lua`](../../../scripts/assessment/TrajectoryConflictAssessment.lua) — semantic Situation Assessment producer;
- [`CooperativePassageControl.lua`](../../../scripts/control/CooperativePassageControl.lua) — large specialised Control implementation crossing Control and Cooperative Passage concerns;
- [`AuthorityRegistry.lua`](../../../scripts/authority/AuthorityRegistry.lua) — shared actuation-ownership substrate and negative authority donor; and
- [`ControlRequest.lua`](../../../scripts/contracts/ControlRequest.lua) — compact semantic contract-value representation.

The temporary machine-readable fixture is [`tests/source_reference_prototype_manifest.json`](../../../tests/source_reference_prototype_manifest.json). It deliberately stands in for future colocated source metadata while the annotation contract is still under falsification.

The prototype generator is [`tests/source_reference_prototype.py`](../../../tests/source_reference_prototype.py). Its committed deterministic output is [`PROTOTYPE_35_SOURCE_REFERENCE.generated.md`](PROTOTYPE_35_SOURCE_REFERENCE.generated.md).

## Method

The prototype does not execute production Lua.

It reads source text and verifies:

- each declared source path exists;
- each declared module export exists in that source;
- selected semantic-boundary symbols actually exist;
- every declared Specification path exists;
- a semantic-boundary or contract-value module has a primary Spec;
- that primary Spec already routes back to the source path;
- a shared substrate does **not** manufacture a primary Spec merely for structural symmetry; and
- compact `ValueRecord.define(...)` schemas can be discovered structurally from source declarations.

The resulting generated reference reports only source facts and declared traceability. It does not reproduce Architecture or Specification prose.

## Observations

### TrajectoryConflictAssessment — semantic producer

The module already has a useful authority-limiting header: it consumes Situation evidence and has no Candidate, Decision or Control authority.

Its implementation shape does not need exhaustive prose for every helper. The important documentation need is concentrated at semantic boundaries such as `updateTrajectories`, where physical motion becomes reusable trajectory Situation knowledge.

The governing implementation contract is Situation Assessment, and the accepted [`SITUATION_ASSESSMENT.md`](../../../spec/SITUATION_ASSESSMENT.md) already names this module as a current implementation route.

### CooperativePassageControl — large specialised Control

The module contains substantial useful local explanation, especially around execution-origin capture, axis recovery, participant vacatur and failure handling.

Its current header mixes several levels of information: module responsibility, choreography, current mechanism and safety behaviour. A future source-documentation pass should preserve the local explanation needed to understand non-obvious mechanisms while routing normative semantics upward instead of restating the full Control or Cooperative Passage contracts.

The module's primary implementation contract is [`CONTROL.md`](../../../spec/CONTROL.md). [`COOPERATIVE_PASSAGE.md`](../../../spec/COOPERATIVE_PASSAGE.md) is materially related specialised context. Requiring the source module to choose one and erase the other would lose useful traceability; treating both as co-equal normative owners would be equally wrong.

### AuthorityRegistry — negative authority donor

`AuthorityRegistry.lua` demonstrates why source topology cannot determine Specification ownership.

The module issues and tracks exclusive actuation-owner tokens for active Commitments. Those tokens are implementation substrate used across neighbouring responsibilities. Accepted Specifications already distinguish mechanical exclusivity and actuation tokens from semantic Bounded Authority.

Therefore this module must **not** be labelled as the Bounded Authority Jurisdiction merely because its name contains `Authority` or because downstream authority logic consumes its tokens.

The prototype classifies it as a shared substrate with related Specifications but no manufactured primary Spec.

This preserves the existing principle:

> **Actuation Token != Bounded Authority Grant.**

### ControlRequest — compact contract value

`ControlRequest.lua` is almost entirely a sealed `ValueRecord` declaration. Repeating every field in authored prose would create a drift surface with little explanatory value.

The generator can discover the current required/optional field structure directly from the source declaration while the human-authored source documentation only needs to identify the value's role and governing Control contract where that is not already obvious locally.

This donor therefore disproves any rule that equates useful source documentation with comment volume.

## Findings

### Source traceability may be many-to-many; normative ownership is not

The prototype supports the following distinction:

> **Source Traceability May Be Many-to-Many; Normative Ownership Is Not.**

A Specification may be realised by several source modules. A source module may support several Specifications. That implementation relationship does not alter the rule that each maintained normative contract statement has one authoritative owner.

A semantic-boundary module can identify one governing primary Specification while also identifying materially related neighbouring Specifications.

A genuinely shared substrate may have no primary Specification of its own. Forcing one would make source topology manufacture architecture.

### Generated structure is not authored semantics

> **Generated Structure != Authored Semantics.**

Source declarations can deterministically provide facts such as:

- source path;
- exported module/type;
- declared source role;
- Spec traceability;
- selected semantic-boundary symbols; and
- structural contract fields.

Those facts are useful for navigation and checking. They do not explain why the responsibility exists, what semantic rule governs it, or what current behaviour is required. Architecture and Specification remain the owners of those meanings.

### Semantic-boundary documentation should be selective, not exhaustive

The donors support the existing principle:

> **Semantic Boundary Requires Documentation.**

but reject the stronger and less useful rule that every helper or function requires prose.

Authored source documentation should concentrate on boundaries that establish, transform, validate or terminate important semantic authority, or where a non-obvious mechanism would otherwise be easy to misinterpret.

Routine local mechanics can remain readable code plus generated structural reference.

### Contract-value declaration should not duplicate its schema in prose

Where a compact declaration already structurally owns field membership, generated reference can expose those fields. Human comments should explain semantic role, units, unusual invariants or authority limits only where the declaration itself cannot.

### Generated reference should read source, not execute runtime

`ValueRecord.define(...)` contains useful structure in source text, but the current runtime definition intentionally does not expose all declaration metadata after construction.

Changing production runtime merely to make documentation generation easier would invert the architecture/implementation relationship.

The prototype therefore reads source declarations statically.

> **Documentation Tooling Must Not Distort Runtime Design.**

### Source documentation is release material

Production comments live in production Lua bytes. A future source-documentation migration therefore changes packaged source even when runtime behaviour is intended to remain identical.

> **Source Documentation Is Release Material.**

The current prototype deliberately avoids production Lua changes. If the source convention is accepted later, applying it must follow normal source/build identity governance rather than being disguised as a docs-only edit.

## Candidate source-documentation contract

The experiment supports the following candidate content model, but does not yet make it normative.

### Module/file level

Where responsibility is not self-evident, authored source documentation should identify:

- the module's local implementation responsibility;
- the semantic boundary it does and does not own where confusion is likely;
- its governing primary Specification when the module materially implements one coherent contract boundary; and
- materially related Specifications when implementation legitimately crosses neighbouring contracts.

A shared substrate should identify its substrate role and related contracts without fabricating primary ownership.

### Semantic-boundary level

A public interface normally requires documentation when callers need semantic information not recoverable from its name/signature.

A private helper also requires explanation when it establishes, transforms, validates or terminates important semantic authority, or when its mechanism would otherwise suggest the wrong authority.

The documentation should explain responsibility, preconditions, evidence/authority limits or non-obvious failure semantics. It should not copy the full governing Specification.

### Contract-value level

Typed/sealed record declarations should rely on structural generation for field membership where possible. Authored comments should be reserved for field semantics that are not obvious from names/types, especially units, identity scope, evidence authority and unusual invariants.

## Candidate generated-reference contract

Generated reference should be deterministic and non-normative.

It may report:

- source path and export;
- declared source role;
- primary/related Specification links;
- declared semantic-boundary symbols;
- structurally discoverable record fields; and
- later, other mechanically discoverable signatures/types where useful.

It must not:

- become the owner of architectural responsibility;
- paraphrase Specification requirements as generated normative prose;
- infer a Specification Jurisdiction from a filename/folder/module name;
- assign a primary Spec merely because one is convenient for generation; or
- preserve stale implementation topology as a contract.

The generated file should be reproducible from its declared inputs and checked for staleness rather than hand-edited.

## Tooling result

The prototype demonstrates that the core OuttaMyWay traceability/reference requirement can be implemented with deterministic repository-local tooling and no runtime dependency.

This does **not** decide the final annotation syntax or IDE tooling. LuaLS/LuaCATS-style type/signature annotations may still be useful for editor ergonomics, but type tooling is not required to own OuttaMyWay's Architecture/Specification relationship.

The durable requirement is the semantic/source contract, not a particular renderer.

## Disproven hypotheses

The experiment rejects these candidate assumptions:

1. **Every production module must map to exactly one primary Specification.**  
   Disproved by `AuthorityRegistry.lua` as a genuine shared substrate.

2. **Useful source documentation requires exhaustive authored API documentation.**  
   Disproved by the contrast between `CooperativePassageControl.lua` and generated structural facts.

3. **Contract-value field structure should be restated manually in comments/reference prose.**  
   Disproved by structural extraction from `ControlRequest.lua` and `AuthorityToken` declarations.

4. **Documentation generation should execute production Lua to discover contracts.**  
   Unnecessary for the tested source facts and undesirable where doing so would couple documentation to runtime bootstrapping.

## Limits

This prototype does not prove:

- the final source annotation syntax;
- that the temporary manifest should survive beyond the experiment;
- that every production module has been classified correctly;
- that generated API/type reference is needed for every source shape;
- that source documentation is semantically adequate repository-wide;
- that the checker belongs in permanent CI; or
- that the live Documentation Standard should already adopt these candidate rules.

No `AGENTS.md`, CI workflow, production source or executable build identity is changed here.

## Next bounded experiment

If this prototype is accepted, apply the smallest candidate convention to the same representative production donors in a **deliberately versioned source tranche**.

That increment should:

1. replace the temporary manifest entries with colocated source metadata/comments;
2. keep authored prose selective and responsibility-focused;
3. preserve `AuthorityRegistry` as a shared-substrate negative case rather than manufacturing a primary Spec;
4. make the generator read the real source annotations plus discoverable structure;
5. remove the temporary manifest once it no longer carries unique experimental value;
6. verify the generated reference remains deterministic; and
7. only then decide which rules have survived strongly enough to enter the live Documentation Standard.

Do not adopt the prototype into `AGENTS.md` or permanent CI merely because the generator works. **Adoption follows validation.**
