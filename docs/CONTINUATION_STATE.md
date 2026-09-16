# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #170 prospective portfolio admissibility

Issue #170 owns the conformance question **Support Precedence != Admissibility Bypass**.

Accepted `main` at the start of this Engineering Increment is merge `ea9b6fd2fe5300f48ba44f685f5cfaaca394f584` from PR #221, with executable build identity **0.3.0.81**.

The active branch advances executable identity to **0.3.0.82** for a bounded correction to prospective Decision scope selection.

## Established observation

The accepted prospective-selection chain is:

```text
Candidate Support
    -> Candidate Space
    -> Constraint Evaluation
    -> Decision
    -> Responsibility Transition
```

Current Architecture and primary Specifications establish that mandatory Constraint admissibility precedes Decision compatibility/preference. A Candidate with mandatory FAIL or UNRESOLVED evidence is not admissible, and Decision may not enlarge or bypass that result through preference.

Before `.82`, source first computed the globally mandatory-PASS Candidate set, but prospective portfolio policy selected one support group from the complete support-group metadata without receiving that admissible set. Decision then filtered the admissible Candidates to the selected group. A preferred support group could therefore suppress an independently supported mandatory-PASS Candidate in another group even when every Candidate in the preferred group was FAIL or UNRESOLVED.

## Deterministic investigation evidence

Closed, unmerged draft PR #222 was used only as a disposable deterministic probe.

The probe directly supplied the real Decision path with two independently supported groups:

- `FORWARD_INTERSECTION` — the normally preferred group;
- `PASSAGE` — the lower-precedence group.

With Passage mandatory-PASS:

- Forward Intersection mandatory-FAIL still caused the Forward group to be selected, Passage to remain globally viable but unselected, and Decision to SETTLE;
- Forward Intersection mandatory-UNRESOLVED still caused the Forward group to be selected, Passage to remain globally viable but unselected, and Decision to WAIT.

The dedicated probe passed because it asserted that current source behaviour. Normal Offline Validation #510 also passed, proving the accepted regression suite did not challenge the condition.

## Historical provenance

The no-fallback behaviour was deliberate, not accidental.

Phase-13 PR #63 moved prospective independent-purpose ordering toward Decision while requiring existing behaviour to be preserved unless Architecture or Reality disproved it. Merged design PR #64 then explicitly preserved the old first-success result: lower-precedence groups were not to become accidental fallback merely because the historically selected group failed or remained unresolved, because the pre-portfolio implementation would never have exposed those lower groups.

The `.19` implementation failed GIANTS Reality for the separate **Support Projection != New Operational Picture** defect. PR #69 / `.20` corrected that defect while deliberately retaining Decision compatibility precedence. `.20` subsequently passed Reality and Phase 13 closed.

The historical rationale for no-fallback was therefore migration behaviour preservation. No current or historical architectural evidence located by #170 establishes that fresh support for a preferred purpose semantically makes another independently supported mandatory-admissible purpose impermissible.

> **Behaviour Preservation != Semantic Exclusion.**

A migration rule that reproduces old first-success control flow does not by itself establish an enduring semantic veto between prospective purposes.

## `.82` implementation hypothesis — Admissibility-Aware Governing Scope Selection

The correction is not a retry/fallback loop.

Prospective Decision compatibility/precedence is applied to support groups represented by **mandatory-admissible Candidates**:

```text
complete supported portfolio
        |
        v
complete mandatory Constraint verdicts
        |
        v
mandatory-admissible Candidates
        |
        v
groups containing admissible alternatives
        |
        v
Decision compatibility / precedence
        |
        v
selected governing scope
        |
        v
existing within-group policy
        |
        v
selected Candidate or explicit non-selection
```

This preserves established compatibility precedence when competing groups are both admissible. It prevents a group containing no admissible Candidate from acquiring stronger exclusion authority merely because its support exists.

When the complete prospective portfolio has no admissible Candidate, no inadmissible support group is promoted to governing scope. Decision instead uses the complete verdict evidence to produce explicit non-selection:

- unresolved mandatory evidence -> `WAIT_FOR_EVIDENCE`;
- complete mandatory failure/exhaustion -> `COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED` / SETTLE.

Candidate Support no longer publishes the historical `lowerPrecedenceConstraintFallback=false` policy token because fallback/precedence is Decision authority, not Candidate-support semantics.

## Authority Triad Revalidation

- **Architecture — validated unchanged.** `architecture/CANDIDATE_SUPPORT_PROJECTION.md` already defines complete support, mandatory admissibility before Decision, and prohibits preference from bypassing mandatory Constraints. Spatial Negotiation gives no fresh Forward-Intersection support a generic veto over an independently admissible Passage Candidate.
- **Specification — validated unchanged.** `spec/CANDIDATE_SUPPORT.md`, `spec/CONSTRAINT_EVALUATION.md` and `spec/DECISION.md` already operationalise the accepted ownership boundaries; Decision explicitly states **Support Precedence != Admissibility Bypass**.
- **Source — changed.** `ProspectivePortfolioDecisionPolicy` now receives mandatory-admissible Candidates and limits compatibility policy to their groups. `DecisionSelector` distinguishes admissible-scope selection from global no-admissible WAIT/SETTLE. `ProspectiveDecisionPortfolioSupport` no longer publishes the historical Decision-policy fallback token.

> **Touch One; Validate Three.**

## Behavioural Validation Matrix

Focused offline Decision evidence challenges:

1. preferred Forward Intersection PASS + Passage PASS -> existing Forward precedence remains;
2. preferred Forward Intersection FAIL + Passage PASS -> Passage remains selectable;
3. preferred Forward Intersection UNRESOLVED + Passage PASS -> Passage remains selectable;
4. no admissible Candidate with unresolved mandatory evidence -> explicit WAIT remains;
5. all Candidates mandatory-FAIL -> explicit SETTLE remains.

The full accepted offline suite remains responsible for neighbouring/regression coverage including follower Regulation, Forward Intersection, Cooperative Passage, Action-Space Regulation, Obstruction Relocation, Responsibility Transition and downstream authority/control contracts.

## Offline validation evidence

Offline Validation **#511** passed on implementation/test head `6ce123e47b4b6fef88163c26b6843377db90f297`:

- Structural contracts — PASS;
- Lua offline behavioural contracts — PASS, including the new focused Prospective Decision Admissibility contract;
- focused Obstruction Relocation contract — PASS;
- changed runtime Lua syntax checks — PASS;
- Generated source reference — PASS.

A later branch commit restored an unchanged workflow step label only; no executable or test bytes changed after #511. Final PR-head CI remains the merge-gating evidence for the exact review state.

Because `.82` changes which already-supported Candidate may be selected in a condition that previously produced WAIT/SETTLE, offline conformance alone is not a complete GIANTS Reality claim. An owner-performed in-game smoke should challenge ordinary supported traffic behaviour before merge. No Passage geometry, Regulation magnitude, Bounded Authority rule or physical Control mechanism is intentionally changed.

## Next bounded engineering step

Interpret final PR-head GitHub Actions evidence, then perform the bounded in-game Reality smoke.

Treat any unexpected physical behaviour as evidence against the implementation hypothesis rather than weakening the admissibility contract to obtain the historical result.

Issue #170 remains open until the accepted correction and required evidence are complete.
