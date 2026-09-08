# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve chronology; this file records only what matters for the next decision.

## Repository authority

- Accepted Repository State baseline for this increment: `main` after PR #80 merge, commit `a9eecac520bc4982284a63850f1a4f06d487a207`.
- Canonical authority remains **v0.3.0.0**.
- Accepted non-canonical playable identity is **`0.3.0.27 TEST — FIELD WORLD CANONICAL ZERO NORMALIZATION`**.
- Phase 14.5 Runtime Integration Consolidation is complete.
- Issue #67 is closed after PR #79; the Lua harness is reconciled with current production topology.
- Issue #78 is closed after PR #80; independent CI established a clean Lua baseline of **337/0 main + 9/9 focused**.
- This validation-governance increment changes no executable mod bytes and therefore does **not** consume a new TEST build identity.
- Canonical authority is unchanged.

## Strangler programme status

- Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.
- Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.
- Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **COMPLETE**.
- Phase 14 — Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming — **IN PROGRESS — 14.5 COMPLETE; 14.6 NOT YET STARTED**.
- Phase 15 — Whole-system validation and architecture-to-runtime review — **NOT STARTED**.

Read [Phase 13 Closure Audit](architecture/PHASE_13_CLOSURE_AUDIT.md) for the closure evidence and responsibility verdicts.

## Current Candidate / Constraint / Decision architecture

The current production chain is intentionally retained because each layer now contributes distinct truthful work:

```text
Situation Assessment
        ↓
Candidate construction / planning
        ↓
Constraint evaluation
        ↓
Decision / policy selection
        ↓
Responsibility Transition
```

### Candidate

Candidate owns feasible option construction, planning and support provenance.

`CandidateAction` rejects downstream authority such as selection, admissibility, Commitment operation, Control request and canonical Constraint verdict fields.

Fresh independently supportable purposes are exposed through the **Prospective Decision Portfolio**. Candidate Support Projection narrows the prospective support question without deleting the parent evidence universe or creating another Operational Picture.

Per-conflict Passage arrangement search remains Candidate planning. Choosing among supported conflicts does not.

### Constraint

Constraint owns exactly four independently evaluated mandatory questions:

1. `REPRESENTATION_FITNESS`;
2. `RESPONSIBILITY_COMPATIBILITY`;
3. `COMMITMENT_PRECONDITIONS`;
4. `EFFECTIVE_ACTUATION_COMPOSITION`.

Candidate planning evidence cannot become a canonical Constraint verdict.

### Decision

Decision owns fresh cross-purpose compatibility, nearest-supported Passage conflict selection, local Traffic Policeman preference and minimum-cost selection where applicable.

A selected higher-precedence Portfolio group does not expose lower-precedence groups merely because its Candidate is Constraint-failed or unresolved; this preserves accepted compatibility behaviour while keeping ownership explicit.

### Responsibility Transition

Semantic Regulation / Resolution establishment, preservation, replacement and termination remain downstream in purpose-specific Responsibility Transition.

**Commitment Operation != Responsibility Transition** remains an accepted boundary.

## `.19` Reality failure and `.20` correction

`.19` failed its first GIANTS Passage Reality test because its support-isolation mechanism manufactured intermediate Operational Pictures. Same-Reality Traffic Policeman exhaustion evidence was therefore stale by the time Decision evaluated it.

Named discoveries:

- **Support Projection != New Operational Picture**;
- **Support Scope != Evidence Deletion**.

`.20` corrected the implementation by binding projected support groups directly to one Candidate-support-enriched target Decision picture while retaining the full parent evidence universe.

The direct `.19` regression repeat passed in Reality. Two ordinary Passages completed; warm D-0147 settlement passed; and a cold-start three-assembly run demonstrated two fresh cold blockers reaching Decision sequentially while Player Claim remained authoritative.

Do not reopen Passage geometry, D-0147 or D-0218 mechanics based on the resolved `.19` failure.

## Accepted current limits

### Generic multi-context application cardinality

A semantically targetable retained context may still fail closed at generic Commitment application when more than one retained context exists.

This remains **ACCEPTABLE FAIL-CLOSED LIMIT for current implemented production behaviour**.

Revisit only for a concrete supported consumer, notably Issue #45 Bubble Bullet Time.

### Supported traffic envelope

The supported Operation envelope remains a maximum of **three simultaneously active GIANTS AI worker assemblies**. The player does not count. Validation is aimed at different agronomic roles; same-agronomy or >3-worker scenarios may work incidentally but are outside supported design/validation scope.

## Separate open work

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.
- Issue #65 — Behaviour Regression Contract != Build Identity Contract.

## Immediate next action

Promote the reconciled Lua validation suite to **blocking behavioural-contract
authority** before Phase 14.6.

The accepted clean baseline is:

- main replacement-core Lua behavioural contracts: **337 passed / 0 failed**;
- focused obstruction-relocation Lua behavioural contracts: **9 passed / 0 failed**.

The workflow must preserve both inner outcomes even when one fails, then fail
the Lua job unless both are successful. This is **Evidence Collection != CI
Enforcement**. Blocking offline regression authority does not claim GIANTS
runtime Reality.

GitHub branch protection currently requires only `Structural contracts`. Once
the renamed `Lua offline behavioural contracts` check has appeared on this pull
request, add it to the required status checks for `main` before accepting the
governance increment.

After this validation-governance increment is accepted, begin the already-agreed
**Phase 14.6 Production Vocabulary and Constants-Scope Cleanup** audit.
