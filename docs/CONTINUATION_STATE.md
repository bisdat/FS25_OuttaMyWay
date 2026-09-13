# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns the exact accepted `main` commit and repository chronology. The executable version owners own current TEST build identity. GitHub Issues and pull requests own their own open/closed state and discussion history. Canonical-release identity is owned by release governance. This document must not duplicate those authorities merely for convenience.

> **Continuation Boundary != Repository Status Dashboard**

### Maintenance contract

Only the copy on accepted `main` is authoritative.

On a working branch, this file describes the continuation state that would become current **if that branch were accepted and merged**. The branch copy is therefore a proposed replacement, not an assertion that the branch itself is accepted.

Update this file only when an Engineering Increment materially changes at least one of:

- the active engineering concern;
- the accepted understanding required to continue that concern;
- the unresolved boundary or question; or
- the immediate next bounded engineering step.

Do **not** touch this file merely because another pull request merged, a commit SHA changed, a TEST build number advanced, an Issue changed status, or unrelated repository work moved forward.

In particular, this file must not maintain an exact `main` SHA, mirrored TEST identity, repeated canonical identity, branch/PR ledger, exhaustive Issue list or completed chronology.

> **Merge-Address Paradox** — a document accepted by a merge cannot truthfully pre-record the exact commit identity created by that same merge.

A useful Continuation State should remain correct across unrelated merges. Its review question is:

> **Could a new engineer determine what is currently being worked on, what has already been established for that work, what remains unresolved, and what bounded question comes next?**

## Current engineering concern — Issue #141

Issue #141 is establishing durable authoring, ownership and traceability standards across `/docs`, `/spec` and `/scripts` before those standards are adopted into root working governance or automated enforcement.

The `/docs` reconciliation, Specification design and primary-Spec migration phases are complete. Every currently implemented Specification Jurisdiction declared by accepted Architecture has one primary Specification. **Configuration** remains a Deferred Responsibility and correctly has no placeholder Specification.

The active falsification boundary is now **source documentation and generated implementation reference**.

A bounded non-production prototype has tested the model against four materially different current source shapes without modifying production Lua:

- semantic producer — `TrajectoryConflictAssessment.lua`;
- large specialised Control implementation — `CooperativePassageControl.lua`;
- shared substrate / negative authority donor — `AuthorityRegistry.lua`; and
- compact contract-value declaration — `ControlRequest.lua`.

The prototype record is [`research/prototypes/PROTOTYPE_35_SOURCE_DOCUMENTATION_TRACEABILITY.md`](research/prototypes/PROTOTYPE_35_SOURCE_DOCUMENTATION_TRACEABILITY.md).

## Accepted authority model

The repository authority chain remains:

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

Generated reference may expose source facts and traceability, but it does not acquire normative contract authority.

Governing boundaries remain:

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

> **Accepted Implementation Value != Specification Requirement.**

> **Primary Specification != Primary Source Module**

> **Tests Are Contract Evidence, Not Contract Authority**

> **Traceability Replaces Duplicated Authority.**

## Source-documentation prototype findings

The current evidence supports the existing principles:

> **Code Documentation Is Colocated Explanation, Not System Authority.**

> **Semantic Boundary Requires Documentation.**

> **Contract Semantics Must Survive Mechanism Replacement.**

and adds several sharper distinctions.

### Source traceability may be many-to-many; normative ownership is not

> **Source Traceability May Be Many-to-Many; Normative Ownership Is Not.**

A Specification may be realised by several modules, and one module may support several neighbouring Specifications. That does not create overlapping normative contract ownership.

A semantic-boundary module may truthfully identify one governing primary Specification plus related context. A genuinely shared substrate may have **no primary Specification of its own**; forcing one would let source topology manufacture Architecture.

`AuthorityRegistry.lua` is the negative donor. Its actuation-owner tokens are implementation substrate and must not be relabelled as Bounded Authority merely for documentation symmetry.

### Generated structure is not authored semantics

> **Generated Structure != Authored Semantics.**

Deterministic tooling can expose source path, export, declared source role, Spec links, selected boundary symbols and structurally declared record fields. Those are useful navigation/reference facts, not explanations of architectural purpose or contract meaning.

The prototype therefore separates:

- **authored source documentation** — local responsibility, semantic boundary, authority limits and non-obvious mechanism rationale; from
- **generated reference** — reproducible implementation facts and traceability.

### Documentation tooling must not distort runtime design

The current `ValueRecord.define(...)` declarations contain useful field structure in source text without exposing all of that declaration metadata at runtime.

The prototype reads source statically rather than changing production runtime to make documentation easier.

> **Documentation Tooling Must Not Distort Runtime Design.**

### Useful source documentation is selective

The prototype rejects exhaustive-comment rules. Authored explanation is valuable where a boundary establishes, transforms, validates or terminates semantic authority, or where the mechanism would otherwise be misleading.

Compact structural declarations such as `ControlRequest.lua` should not duplicate field membership manually when generated reference can expose it deterministically.

### Source documentation is release material

Production comments are part of production Lua bytes.

> **Source Documentation Is Release Material.**

Applying an accepted source-comment convention therefore belongs in a normal source/build increment even when runtime behaviour is intentionally unchanged. Moving the explanation into detached sidecars merely to avoid build identity would weaken the colocated-explanation principle.

## Prototype tooling boundary

The current prototype uses:

- `tests/source_reference_prototype_manifest.json` — temporary experimental metadata standing in for future source annotations;
- `tests/source_reference_prototype.py` — deterministic static reader/generator;
- `tests/test_source_reference_prototype_structure.py` — staleness/contract check; and
- `research/prototypes/PROTOTYPE_35_SOURCE_REFERENCE.generated.md` — generated non-normative output.

The temporary manifest is **not** an accepted second source-of-truth. Its purpose is to test the content model before production source bytes are changed.

The prototype does not select a permanent third-party documentation renderer. Type/editor tooling may later supplement source documentation, but OuttaMyWay's Architecture/Specification relationship remains repository semantic metadata rather than renderer authority.

## Current source-conformance investigations

Separate evidence-led investigations remain independent of Issue #141 unless their evidence changes Architecture or a primary Specification:

- Issue #170 — **Support Precedence != Admissibility Bypass**;
- Issue #172 — **Lifecycle Certainty and Observation Completeness Are Orthogonal** / **Positive Termination != Missing-Membership Evidence**;
- Issue #174 — positive Regulation Control actuation must not gain a Bounded Authority bypass from unknown owner-tag vocabulary; and
- Issue #176 — **Resolution Failure / Escalation != Causal-Obstruction Basis Cessation**.

These questions must not be normalised into source-documentation wording merely because current source behaves that way.

## Immediate next bounded #141 engineering step

If the non-production prototype is accepted, run a **deliberately versioned production source-annotation trial** on the same representative donors.

The trial should:

1. define the smallest colocated source metadata/comment convention needed by the four donors;
2. preserve the semantic-boundary / contract-value / shared-substrate distinctions;
3. add selective explanation only where the source boundary genuinely needs it;
4. keep `AuthorityRegistry` as the negative case with no fabricated primary Spec;
5. make the generator read real source annotations rather than the temporary manifest;
6. remove the temporary manifest when it no longer owns unique experimental evidence;
7. regenerate the deterministic reference and let independent CI validate it; and
8. consume a fresh TEST BUILD because production source bytes will change.

The source trial is still a falsification experiment. If colocated annotations create noise, duplicate Specification meaning, misrepresent shared substrate or prove awkward across these source shapes, revise the model before broader adoption.

## Subsequent #141 boundaries

Only after the production source trial survives review should the programme:

1. decide which source-documentation rules have enough evidence to enter `DOCUMENT_STANDARDS.md`;
2. establish repository-wide deterministic **Architecture -> Specification -> source -> tests** traceability;
3. define the smallest permanent generated-reference/checker contract;
4. perform a **Stranded Live Knowledge** harvest and retire `IMPLEMENTATION_MAP.md` once its legitimate navigation role has actually been replaced;
5. update bootstrap/navigation references atomically; and
6. only then adopt proven rules into `AGENTS.md` and permanent CI/pre-commit enforcement.

Do not update `AGENTS.md` merely because the prototype generator works. **Adoption follows validation.**

Issue #139 remains the separate design-to-implementation investigation for supported player Configuration. Issue #89 remains the deferred GUI/HUD/player-communication responsibility.
