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

The `/docs` reconciliation and Specification-design phases are complete. Four bounded Specification tranches have now exercised materially different responsibility shapes: heterogeneous standalone Jurisdictions, explicit parent/child dependencies, a tightly coupled prospective-selection peer chain, and the upstream **Operation Lifecycle → Situation Assessment** semantic handoff.

The current evidence increasingly supports the Specification model. The next useful falsification boundary is the vertical physical-authority chain **Regulation → Bounded Authority → Control**. Source-documentation conventions, generated reference and CI/pre-commit enforcement remain downstream until primary-Spec migration provides sufficiently broad representative source boundaries.

## Accepted understanding

The authority model remains:

- Architecture owns what the system should achieve and why its responsibilities exist;
- Specification owns the implementation-facing contract for one declared Specification Jurisdiction;
- source owns the current implementation mechanism;
- tests and Reality provide evidence without acquiring contract authority; and
- generated implementation reference may later expose source facts without becoming normative meaning.

The common Specification contract spine remains:

1. **Identity and authority**;
2. **Boundary contracts**;
3. **Durable invariants**;
4. **Failure and uncertainty semantics**;
5. **Implementation traceability**; and
6. **Validation route**.

Lifecycle/ordered-flow and semantic-data-contract sections remain conditional on the Jurisdiction actually owning those semantics.

Governing authoring boundaries include:

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

> **Accepted Implementation Value != Specification Requirement.**

> **Primary Specification != Primary Source Module**

> **Semantic Product != Required Concrete Source Type**

> **Tests Are Contract Evidence, Not Contract Authority**

Primary Specifications now cover eleven implemented Jurisdictions:

- Operation Lifecycle;
- Observation;
- Situation Assessment;
- Responsibility Transition;
- Resolution Lifecycle;
- Cooperative Passage;
- Physical Identity Resolution;
- Assessment Representation;
- Candidate Support;
- Constraint Evaluation; and
- Decision.

The remaining implemented runtime Jurisdictions are Regulation, Obstruction Relocation, Bounded Authority and Control. Configuration remains a Deferred Responsibility and correctly has no placeholder Spec.

## Operation Lifecycle and Situation Assessment boundary

The latest tranche confirms that lifecycle/context authority and current semantic interpretation remain separate responsibilities.

**Operation Lifecycle** owns exact Job Episode identity, positive termination/succession, Field World admission, productive-commencement-gated Local Operation participation, dynamic membership and natural closure.

**Situation Assessment** consumes those lifecycle facts together with current Observation and representation evidence to publish current semantic meaning in the Operational Picture. It may identify current relationships, uncertainty, representation fitness for the current question, physical relevance and Causal Obstruction, but it cannot create or rewrite lifecycle truth.

The tranche names:

> **Semantic Interpretation != Lifecycle Authority.**

> **Operational Membership != Spatial Relevance.**

A same-Field active GIANTS worker whose productive commencement is not yet positively witnessed may be physically/Situation-relevant and may constrain Resolution Space while still remaining `operationMember = false`. Conversely, a completed or otherwise non-member physical assembly may remain spatially relevant without remaining a cooperative participant.

The tranche also sharpens Lifecycle Evidence Asymmetry:

> **Lifecycle Certainty and Observation Completeness Are Orthogonal.**

> **Positive Termination != Missing-Membership Evidence.**

Incomplete membership evidence prevents removal **by absence**. It does not erase a separately positive member-specific lifecycle fact. A positively terminated exact Job Episode no longer supports active Local Operation participation merely because another member's evidence is unresolved.

This is an implementation-facing consequence of already accepted Architecture, not a new timeout/grace-period model.

## Separate conformance questions exposed by Specification work

Specification migration is deliberately allowed to expose implementation/test drift without absorbing that drift into the normative contract.

### Prospective portfolio admissibility

The prospective-selection tranche established:

> **Support Precedence != Admissibility Bypass**

Current portfolio source/test behaviour can select a preferred support group before group-local mandatory admissibility is known and intentionally avoids lower-precedence fallback. Accepted Architecture instead defines Decision over supported, constraint-admissible alternatives unless a stronger exclusion relationship is explicitly owned. That investigation remains separate from Specification migration.

### Mixed lifecycle evidence

The Operation Lifecycle tranche exposed a mixed-evidence edge case: `JobEpisodeAdmission` can positively terminate one member while `OperationAdmission` receives an otherwise incomplete Field World membership sample because another member remains unresolved. Current incomplete-membership merging can preserve the ended assembly in `memberAssemblyIds` even though its active Job Episode has disappeared from `memberJobEpisodeIds`.

The ordinary single-completion path does not exhibit this because positive end evidence normally leaves that membership sample complete. The unresolved question is specifically whether group-wide incompleteness is currently applied too coarsely when one exact member has independent positive terminal evidence.

No runtime or test change is justified from source inspection alone. The next investigation for this debt is a controlled offline fixture with independent positive termination and unrelated membership uncertainty, followed by architectural classification before implementation.

These conformance questions do not silently alter their governing Specifications. If evidence disproves Architecture, Architecture and the affected Specs must be updated first.

## Immediate next bounded #141 engineering step

Apply the Specification model to the vertical physical-authority chain:

1. **Regulation** — bounded temporal coordination while GIANTS retains productive routing;
2. **Bounded Authority** — current physical permission derived from Current Responsibility and fresh Reality; and
3. **Control** — physical realisation of an already-authorised request through supported GIANTS mechanisms.

This tranche should test whether the three layers remain semantically distinct even where current source paths are tightly integrated:

```text
Situation Assessment / Responsibility Transition
        |
        v
Regulation
why temporal intervention persists
        |
        v
Bounded Authority
what physical action is permitted now
        |
        v
Control
how the permitted action is realised
        |
        v
Reality -> Observation
```

The tranche must preserve these established boundaries:

- Regulation changes timing, not productive route;
- Regulation remains successor-agnostic but not future-blind;
- `WAITING_FOR_EVIDENCE` is bounded evidence-state continuity, not a generic lifecycle state;
- exact 1 km/h policies remain purpose-bound architectural policies where applicable, not universal Control calibration;
- Current Responsibility continuity may coexist with Bounded Authority discontinuity;
- mechanical exclusivity/leases do not create semantic permission;
- Bounded Authority may narrow or end but never enlarge upstream strategic authority;
- Control may discover physical feasibility but may not invent strategic purpose; and
- Control outcomes return through Reality/Observation rather than self-certifying semantic success.

If source review reveals that a current Control helper, lease/token mechanism or Regulation adapter is carrying semantic authority beyond these boundaries, record that as conformance evidence rather than defining the Spec around the mechanism.

## Subsequent #141 boundaries

If the Regulation / Bounded Authority / Control tranche survives review:

1. migrate **Obstruction Relocation** as the remaining specialised Resolution Jurisdiction against already-migrated Resolution Lifecycle, Situation Assessment, Bounded Authority and Control contracts;
2. confirm all implemented Jurisdictions have primary Specifications while Configuration remains honestly Deferred;
3. prototype source-documentation and generated-reference tooling against representative migrated modules;
4. establish deterministic Architecture -> Specification -> source -> test traceability without turning generated reference into normative authority;
5. once `/spec` and source traceability replace the legitimate placement/navigation role, perform a Stranded Live Knowledge harvest and retire `docs/IMPLEMENTATION_MAP.md`, updating bootstrap/navigation/governance references atomically; and
6. only after these models have survived application, adopt the proven rules into `AGENTS.md` and CI/pre-commit enforcement.

This sequence remains evidence-led. If Specification work or later Reality disproves the current standards, Architecture or Jurisdiction model, update those authorities rather than preserving the migration plan for its own sake.

## Separate adjacent responsibilities

The prospective-portfolio admissibility/precedence investigation and the mixed lifecycle-membership investigation remain separate implementation/architecture conformance work. They must not be silently fixed through Specification wording.

Issue #139 remains the design-to-implementation investigation for supported player Configuration. Configuration remains without a speculative primary Specification until that responsibility matures enough to require implementation.

Issue #89 remains the deferred GUI/HUD/player-communication responsibility. Diagnostic HUDs are not promoted into product GUI merely because they exist.
