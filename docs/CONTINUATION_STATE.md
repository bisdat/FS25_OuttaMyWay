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

Issue #141 is establishing durable authoring, ownership, topology and conformance standards for the repository's first-class engineering surfaces before those standards are adopted into root working governance or automated enforcement.

The `/docs` reconciliation, Specification design and primary-Spec migration are complete enough to distinguish two responsibilities that had previously been conflated:

- `/architecture` — current System Architecture: what OuttaMyWay should achieve, why its responsibilities exist, and which concepts, constraints and authority relationships govern them; and
- `/docs` — engineering knowledge and governance: method, continuation, standards, naming, validation methodology, engine knowledge, research/evidence routes and decision/journal records.

> **Documentation Surface != Architecture Surface.**

System Architecture occupies a first-class root `/architecture` surface alongside `/spec`, `/scripts` and `/tests`. This topology change does not change OuttaMyWay behavioural Architecture.

Every currently implemented Specification Jurisdiction declared by accepted Architecture has one primary Specification. **Configuration** remains a Deferred Responsibility and correctly has no placeholder Specification.

The repository requires tooling that protects objective relationships among Architecture, Specification, source and validation and detects drift. A generated implementation-reference system is not assumed to be that tooling; it must earn a separate responsibility if a demonstrated need emerges.

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

The common Specification contract spine has survived materially different Jurisdiction shapes: lifecycle/context, evidence/representation, prospective selection, generic and specialised Resolution, semantic Regulation, current Bounded Authority and physical Control.

Governing boundaries include:

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

> **Accepted Implementation Value != Specification Requirement.**

> **Primary Specification != Primary Source Module**

> **Semantic Product != Required Concrete Source Type**

> **Tests Are Contract Evidence, Not Contract Authority**

> **Traceability Replaces Duplicated Authority.**

All implemented primary Specifications are indexed by [`../spec/README.md`](../spec/README.md). Architecture remains authoritative for the complete Jurisdiction inventory.

## Obstruction Relocation boundary

The final migration confirms that Obstruction Relocation is a specialised **Resolution** contract, not a completed-worker lifecycle, parking subsystem or generic movement service.

The governing chain is:

```text
Situation Assessment
positive Causal Obstruction + blocker classification
        |
        v
prospective selection / Responsibility Transition
        |
        v
Obstruction Relocation Resolution
persistent obstruction-removal obligation
        |
        v
Bounded Authority
one current positive physical permission
        |
        v
Control
one authorised physical attempt + owned cleanup
        |
        v
Reality -> Observation -> Situation Assessment
```

The specialisation preserves these distinctions:

> **Causal Obstruction != Relocation Responsibility.**

Situation Assessment owns the current causal relationship. A relocation Resolution exists only after the strategic and Responsibility Transition boundaries establish that responsibility.

> **Beneficiary != Controlled Subject.**

The beneficiary is the active supported worker whose continuity justifies intervention; the blocker is the controlled physical subject. OuttaMyWay has no independent duty to park or tidy the blocker.

> **Historical Provenance != Relocation Eligibility.**

Current positive Reality may establish an otherwise-supported non-active unclaimed blocker without historical Job Episode provenance.

> **Relocation Is Geometry-Bounded, Not Count-Bounded.**

One bounded inward actuation is authorised from current Reality. There is no first/second-courtesy state, completed-worker movement budget or automatic boundary-away stage.

> **Actuation Recurrence != Resolution Settlement Evidence.**

> **Manoeuvre Completion != Obstruction Removal.**

A physical move ends its own Bounded Authority and returns to fresh Reality. A fresh positive obstruction may justify another bounded actuation under the same Resolution; physical target attainment alone cannot settle the semantic obligation.

> **Obstruction Absence != Supported Continuation.**

Where the representation/evidence contract does not own negative clearance, disappearance of the previously positive obstruction relation is insufficient by itself. Successful discharge requires positive evidence that the beneficiary obligation is actually satisfied.

> **Resolution Persistence != Actuation Persistence.**

The Resolution may remain current while no physical grant is active and the system waits for fresh evidence. That is not a generic WAITING responsibility.

## Current source conformance questions

Specification work has deliberately exposed questions that remain owned by separate evidence-led investigations. They must not be normalised into contract wording merely because current source behaves that way.

### Prospective portfolio admissibility — Issue #170

> **Support Precedence != Admissibility Bypass**

Current portfolio precedence may suppress a lower-precedence mandatory-admissible alternative before group-local admissibility is known. Testing must determine whether that is implementation/test drift or a missing architectural exclusion relationship.

### Mixed lifecycle evidence — Issue #172

> **Lifecycle Certainty and Observation Completeness Are Orthogonal.**

> **Positive Termination != Missing-Membership Evidence.**

The unresolved question is whether group-wide incomplete membership preservation can retain an assembly whose exact Job Episode has independently positive terminal evidence.

### Regulation Control positive-authority gate — Issue #174

Current Regulation Control requires Bounded Authority only for a hard-coded set of known owner tags. The unresolved question is whether an unknown positive `REGULATION_LEASE` purpose can fail open despite the accepted rule:

> **Positive Physical Actuation Requires Positive Bounded Authority.**

Release/cleanup remains a separate authority-narrowing case.

### Obstruction Relocation failure / basis semantics — Issue #176

The final Spec migration exposed a terminal-semantics contradiction.

Current source emits `OBJECTIVE_FAILED` when the Causal Obstruction remains positively present but no meaningful inward relocation remains. The specialised lifecycle then currently settles non-success obligations as `BASIS_CESSATION`, while the generic Governing Basis evaluator treats `OBJECTIVE_FAILED` as basis invalidation.

Accepted Architecture instead distinguishes autonomous strategy exhaustion from disappearance of the Causal Obstruction itself:

> **Resolution Failure / Escalation != Causal-Obstruction Basis Cessation.**

The investigation must determine whether this is implementation/substrate drift or whether a narrower relocation-strategy basis exists but has not yet been named architecturally. No runtime change follows from source inspection alone.

## Immediate next bounded #141 engineering step

After the Architecture surface migration is accepted, define the missing **production source-documentation standard** in `DOCUMENT_STANDARDS.md`.

The standard should establish the minimum durable expectations for `/scripts` without selecting tooling prematurely:

1. module responsibility and semantic boundary where names/source structure are insufficient;
2. governing Specification traceability where the relationship is meaningful;
3. non-obvious invariants, evidence limits, GIANTS/runtime constraints and failure/conservative semantics;
4. explanation of *why / constraint / ownership* rather than paraphrase of obvious code;
5. no duplication of Architecture or Specification authority; and
6. no blanket requirement to document every private helper or implementation step.

This is a standards activity first. No generated reference, manifest, annotation framework or CI checker is authorised merely by defining the source-documentation contract.

## Subsequent #141 boundaries

After the source-documentation standard is explicit:

1. perform the required **Stranded Live Knowledge** harvest for `docs/IMPLEMENTATION_MAP.md`, transfer any unique current knowledge to its responsible Architecture, Specification, source or engineering-governance owner, and delete the transitional Map;
2. define the contract for repository conformance tooling that protects objective `/architecture ↔ /spec ↔ /scripts` relationships and the applicable `/tests` evidence routes without claiming semantic authority;
3. implement only the objective checks justified by that contract, including live breadcrumb/link integrity and durable traceability invariants;
4. decide separately whether any generated reference product has demonstrated enough value to own a durable responsibility; and
5. only after the standards and tooling survive application, update `AGENTS.md` and permanent CI/pre-commit governance.

> **Tooling Enforces Relationships; It Does Not Own Meaning.**

> **Adoption follows validation.**

If tooling or later Reality disproves the standards, Specification model or Jurisdiction boundaries, update those authorities rather than preserving the programme for its own sake.

## Separate adjacent responsibilities

The active conformance investigations above are independent of the #141 documentation/tooling migration unless their evidence changes Architecture or a primary Specification.

Issue #139 remains the design-to-implementation investigation for supported player Configuration. Configuration remains without a speculative primary Specification until that responsibility matures enough to require implementation.

Issue #89 remains the deferred GUI/HUD/player-communication responsibility. Diagnostic HUDs are not promoted into product GUI merely because they exist.
