# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve chronology; this file records only what matters for the next decision.

## Repository authority

- Accepted Repository State baseline for this increment: `main` after PR #81 merge, commit `42b8b4c1afc5de4dcc7b1d74fee039bb81a32dfd`.
- Canonical authority remains **v0.3.0.0**.
- Accepted non-canonical playable identity remains **`0.3.0.27 TEST — FIELD WORLD CANONICAL ZERO NORMALIZATION`**.
- Phase 14.5 Runtime Integration Consolidation is complete; Phase 14.6 has not started.
- Issue #67 is closed after PR #79; the Lua harness is reconciled with current production topology.
- Issue #78 is closed after PR #80; independent CI established the clean **337/0 main + 9/9 focused** Lua baseline.
- PR #81 promoted `Lua offline behavioural contracts` to blocking CI. Protected `main` now requires both `Structural contracts` and `Lua offline behavioural contracts`.
- The `.27` smoke re-observed the previously known PR #35 **Follower HUD Glyph Compatibility Leak**; Issue #82 now tracks closure as **KNOWN OPEN / RE-OBSERVED**, not a new `.27` defect.
- This repository-knowledge reconciliation changes no executable mod bytes and consumes no new TEST build identity.
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
- Issue #82 — known Follower HUD Glyph Compatibility Leak, re-observed in `.27`; knowledge reconciliation precedes the bounded runtime correction.

## Immediate next action

Complete the **repository context / stranded-knowledge reconciliation** exposed by
Issue #82 before changing follower HUD executable bytes or beginning Phase 14.6.

This increment establishes:

- **Repository Context Bootstrap** — reconstruct current authority from
  `AGENTS.md` -> `docs/README.md` -> Engineering Architecture + Continuation
  State -> task-relevant responsibility routes;
- **Relevant Knowledge Sweep** — search current docs/source/tests, open and
  closed Issues, PR history, journal/research and Git provenance before
  classifying an observation as NEW;
- durable GIANTS texture-font knowledge: U+2022 BULLET is unsupported on the
  observed texture-font HUD surfaces and ASCII-safe `|` is the demonstrated
  separator;
- pull-request Knowledge Trace visibility; and
- a Structural governance contract protecting the bootstrap/sweep and durable
  knowledge placement.

After that governance increment is accepted, perform one bounded Issue #82
runtime correction: replace the known follower-HUD U+2022 separators with `|`,
add the blocking rendered-HUD regression contract atomically with the fix,
advance TEST build identity, validate in CI, then obtain targeted GIANTS Reality
evidence that the warning is gone without Regulation behaviour change.

Only then begin the already-agreed **Phase 14.6 Production Vocabulary and
Constants-Scope Cleanup** audit.
