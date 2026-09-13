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

The `/docs` reconciliation and Specification-design phases are complete. The common Specification model has now survived five materially different application shapes, including the vertical **Regulation → Bounded Authority → Control** chain from semantic responsibility through physical permission to physical execution.

Primary Specifications now cover fourteen implemented Jurisdictions. **Obstruction Relocation** is the only currently implemented Specification Jurisdiction still under the bounded `pending migration` exception. Configuration remains a Deferred Responsibility and correctly has no placeholder Specification.

The immediate work therefore remains Specification migration, but only for the final specialised Resolution Jurisdiction. Source-documentation conventions, generated reference and CI/pre-commit enforcement remain downstream until that last implemented contract has been tested against the common model.

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

Governing authoring boundaries continue to include:

> **Specification Operationalises Architecture; It Does Not Paraphrase It.**

> **Accepted Implementation Value != Specification Requirement.**

> **Primary Specification != Primary Source Module**

> **Semantic Product != Required Concrete Source Type**

> **Tests Are Contract Evidence, Not Contract Authority**

Primary Specifications now cover:

- Operation Lifecycle;
- Observation;
- Situation Assessment;
- Responsibility Transition;
- Regulation;
- Resolution Lifecycle;
- Cooperative Passage;
- Physical Identity Resolution;
- Assessment Representation;
- Candidate Support;
- Constraint Evaluation;
- Decision;
- Bounded Authority; and
- Control.

## Regulation → Bounded Authority → Control boundary

The latest tranche confirms that the physical-authority chain remains three distinct responsibilities rather than one generic actuation subsystem.

```text
Current Regulation responsibility
why temporal coordination persists
        |
        v
Bounded Authority
what positive physical effect is permitted now
        |
        v
Control
how that bounded effect is physically realised
        |
        v
Reality -> Observation
```

### Regulation

Regulation owns bounded temporal coordination while GIANTS retains productive routing. It does not own the controlled physical magnitude or the mechanism that realises it.

The tranche names:

> **Regulation Responsibility != `REGULATE_SPEED` Capability.**

A speed-limiting physical effect does not prove that semantic Current Responsibility is Regulation. Another Current Responsibility may legitimately require a bounded supporting temporal effect. Conversely, a Regulation responsibility may remain current while no physical speed lease is active.

> **Responsibility Persistence != Actuation Persistence.**

The same Regulation identity may survive magnitude refresh, Bounded Authority replacement, physical quiescence and later reactivation. Those are maintenance unless Responsibility Transition establishes a genuine semantic lifecycle change.

### Bounded Authority

Bounded Authority owns current positive physical permission derived from Current Responsibility and current accepted evidence. The common grant registry is only one implementation substrate; purpose-specific authority policy also belongs to this Jurisdiction.

The tranche names:

> **Actuation Token != Bounded Authority Grant.**

A commitment token, capability reservation, mechanical lease or retained handle may be necessary substrate, but none independently proves that a physical effect is permitted now.

> **Positive Physical Actuation Requires Positive Bounded Authority.**

Positive OuttaMyWay actuation must be explicitly bounded for the current responsibility, subject, capability and validity context. Novel vocabulary or executor placement must not manufacture an implicit bypass.

> **Relinquishment Is Authority-Narrowing, Not Authority Creation.**

Fail-safe cleanup may clear, neutralise or release already-owned physical effects without acquiring a new positive grant, provided that path can only reduce OuttaMyWay intervention.

Responsibility continuity may therefore coexist with Bounded Authority discontinuity. A grant may be refreshed, replaced, released or participant-scoped independently without implying responsibility churn.

### Control

Control owns physical feasibility and execution of an already-authorised request. Dispatch selects a compatible executor; it is not strategic Decision.

The tranche names:

> **Permission To Attempt != Proof Of Feasibility.**

A valid Bounded Authority grant permits an attempt. Control may still refuse or stop when current physical Reality, Player Claim, source-AI reactivation, object availability or mechanism feasibility contradicts execution.

> **Physical Completion != Semantic Resolution Completion.**

Control may establish mechanical facts about its own execution but cannot self-certify Situation meaning, responsibility persistence, obstruction discharge or Resolution settlement. Physical outcomes return through Reality and Observation.

Downstream Authority Monotonicity remains decisive: Control may equal or narrow permission, refuse, stop and relinquish; it may not enlarge the strategic action authorised upstream.

## Separate conformance questions exposed by Specification work

Specification migration is deliberately allowed to expose implementation/test drift without absorbing that drift into the normative contract.

### Prospective portfolio admissibility — Issue #170

> **Support Precedence != Admissibility Bypass**

The unresolved question remains whether current prospective-portfolio precedence is implementation/test drift or represents a stronger architectural exclusion relationship not yet named. No implementation change follows merely from the Spec review.

### Mixed lifecycle evidence — Issue #172

> **Lifecycle Certainty and Observation Completeness Are Orthogonal.**

> **Positive Termination != Missing-Membership Evidence.**

The unresolved case is whether group-wide incomplete membership preservation can incorrectly retain an assembly whose exact Job Episode has independently positive terminal evidence. A controlled offline fixture must classify that evidence before implementation changes.

### Regulation Control unknown-owner authority bypass — Issue #174

The physical-authority tranche exposed a fail-closed question at the Regulation Control boundary. Current source requires a Bounded Authority grant only for a hard-coded set of known Regulation owner tags. A novel positive `REGULATION_LEASE` owner tag can potentially reach physical `APPLY` execution without a `boundedAuthorityId` if its commitment/token/composition checks otherwise pass.

Current production callers appear to use the known tags, so this is a latent conformance question rather than an observed runtime caller bypass. Structural tests protect the known-tag gate but do not establish that unknown positive actuation fails closed.

The investigation must distinguish:

1. implementation/test drift — every positive Regulation `APPLY` must require Bounded Authority regardless of owner-tag vocabulary; or
2. a missing architectural exception — some positive Regulation actuation is intentionally authorised without Bounded Authority, in which case Architecture must own that exception explicitly.

Accepted Architecture currently supports the first interpretation, but testing must validate rather than assume it. Release/cleanup remains a distinct authority-narrowing case.

These conformance questions remain outside the Specification migration itself. If evidence disproves Architecture, Architecture and affected Specs must change before implementation is defended.

## Immediate next bounded #141 engineering step

Apply the Specification model to **Obstruction Relocation**, the final currently implemented Jurisdiction still pending migration.

Obstruction Relocation is a specialised child of Resolution Lifecycle. The tranche should test the whole already-migrated dependency chain rather than treat the current source module as the responsibility boundary:

```text
Situation Assessment
Causal Obstruction + non-active/unclaimed classification
        |
        v
Resolution Lifecycle
persistent accepted obligation semantics
        |
        v
Obstruction Relocation
specialised objective / bounded recurrence / discharge semantics
        |
        v
Bounded Authority
current permission for blocker-specific physical effect
        |
        v
Control
one authorised physical actuation + owned cleanup
        |
        v
Reality -> reassessment
```

The tranche should specifically test:

- whether Causal Obstruction remains wholly Situation-owned rather than being recreated by relocation Candidate/Control code;
- whether Obstruction Relocation adds only specialised Resolution semantics instead of duplicating generic commitment/obligation lifecycle;
- whether **Relocation Is Geometry-Bounded, Not Count-Bounded** remains an objective contract rather than a source-loop prescription;
- whether **Actuation Recurrence != Resolution Settlement Evidence** remains explicit across repeated bounded moves;
- whether historical Job provenance remains non-authoritative for current blocker recognition and relocation eligibility;
- whether Player Claim and fresh source-AI reactivation terminate or supersede physical permission at the correct authority layer; and
- whether current source reveals any additional Architecture-to-implementation drift that must be recorded separately instead of normalised into the Spec.

If this final migration disproves the common Specification model, update the model. Do not preserve completion symmetry for its own sake.

## Subsequent #141 boundaries

If the Obstruction Relocation tranche survives review:

1. confirm every currently implemented Specification Jurisdiction has one primary Specification while Configuration remains honestly Deferred;
2. prototype source-documentation and generated-reference tooling against representative modules from different Jurisdiction shapes;
3. establish deterministic Architecture -> Specification -> source -> test traceability without turning generated reference into normative authority;
4. once `/spec` and source traceability replace the legitimate placement/navigation role, perform a **Stranded Live Knowledge** harvest and retire `docs/IMPLEMENTATION_MAP.md`, updating bootstrap/navigation/governance references atomically; and
5. only after these models have survived application, adopt the proven rules into `AGENTS.md` and CI/pre-commit enforcement.

This sequence remains evidence-led. If later Reality or the conformance investigations disprove the current standards, Architecture or Jurisdiction model, update those authorities rather than preserving the migration plan for its own sake.

## Separate adjacent responsibilities

Issues #170, #172 and #174 are active conformance investigations exposed by Specification work; they must not be silently fixed through Specification wording.

Issue #139 remains the design-to-implementation investigation for supported player Configuration. Configuration remains without a speculative primary Specification until that responsibility matures enough to require implementation.

Issue #89 remains the deferred GUI/HUD/player-communication responsibility. Diagnostic HUDs are not promoted into product GUI merely because they exist.
