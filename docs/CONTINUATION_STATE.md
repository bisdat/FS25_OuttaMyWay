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

The `/docs` reconciliation, Specification design and primary-Spec migration phases are now complete enough to move the falsification boundary down one layer.

Every currently implemented Specification Jurisdiction declared by accepted Architecture now has one primary Specification. **Configuration** remains a Deferred Responsibility and correctly has no placeholder Specification.

The bounded `pending migration` exception is therefore no longer needed for implemented runtime responsibilities. The next #141 question is whether the accepted source-documentation model and generated-reference/traceability design can represent the implementation **without turning source topology or generated output into normative authority**.

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

Prototype **source documentation + generated implementation reference** against representative current modules.

This is a contract-design experiment, not a mass-commenting exercise and not yet a CI-enforcement tranche.

The experiment should answer four questions:

1. **What must authored source documentation own?**  
   It should identify module responsibility, semantic boundary, governing primary Specification and non-obvious mechanisms needed to preserve that contract, without copying Architecture or Spec prose.

2. **What should generated reference own?**  
   It should expose deterministic source facts such as modules, public contracts, declared Spec relationships and machine-readable traceability, without becoming normative meaning.

3. **Which source boundaries require documentation?**  
   Public interfaces nearly always do. Private helpers require explanation when they establish, transform, validate, terminate or otherwise carry important semantic authority, or when their mechanism would be misleading without explanation.

4. **Can the model survive different source shapes?**  
   Test it on at least one semantic producer and one physical/control-oriented module, with a low-semantic-authority module as a negative comparison. Do not infer a one-module/one-Spec mapping where the implementation legitimately crosses neighbouring contracts.

The standing principles are:

> **Code Documentation Is Colocated Explanation, Not System Authority.**

> **Semantic Boundary Requires Documentation.**

> **Contract Semantics Must Survive Mechanism Replacement.**

The toolchain remains an implementation choice to be tested against these requirements. Do not select LDoc, LuaLS/LuaCATS or another format merely because it is convenient to generate.

## Subsequent #141 boundaries

If the source-documentation/reference prototype survives application:

1. define the smallest durable source annotation convention and generated-reference contract;
2. establish deterministic **Architecture -> Specification -> source -> tests** traceability, including a machine-readable representation suitable for checking;
3. design one cheap deterministic contract checker that can run locally and independently in CI without making CI the semantic authority;
4. once `/spec` plus source/generated traceability replaces the legitimate placement/navigation role, perform a **Stranded Live Knowledge** harvest and retire `docs/IMPLEMENTATION_MAP.md`, updating bootstrap/navigation/governance references atomically; and
5. only after these models have survived real application, adopt the proven rules into `AGENTS.md` and CI/pre-commit enforcement.

Do not update `AGENTS.md` merely because primary Specification migration is complete. **Adoption follows validation.**

This sequence remains evidence-led. If source-tooling work or later Reality disproves the current standards, Specification model or Jurisdiction boundaries, update those authorities rather than preserving the programme for its own sake.

## Separate adjacent responsibilities

The active conformance investigations above are independent of the #141 documentation/tooling migration unless their evidence changes Architecture or a primary Specification.

Issue #139 remains the design-to-implementation investigation for supported player Configuration. Configuration remains without a speculative primary Specification until that responsibility matures enough to require implementation.

Issue #89 remains the deferred GUI/HUD/player-communication responsibility. Diagnostic HUDs are not promoted into product GUI merely because they exist.
