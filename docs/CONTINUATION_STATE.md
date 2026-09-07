# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve chronology; this file records only what matters for the next decision.

## Repository authority

- Accepted Repository State baseline for this increment: `main` after PR #75 merge, commit `5b13bcc6251d6b482402e6ba1d37e740dd050d8a`.
- Canonical authority remains **v0.3.0.0**.
- Last accepted non-canonical playable identity is **`0.3.0.23 TEST — LIVE INTERACTION OBSERVATION GRADUATION`**.
- PR #70 passed Offline Validation Run #187 blocking Structural contracts and changed-runtime Lua syntax, then passed owner GIANTS Reality validation before merge.
- Issue #68 is closed as the `.19` failure / `.20` correction record.

## Strangler programme status

- Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.
- Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.
- Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **COMPLETE**.
- Phase 14 — Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming — **IN PROGRESS — 14.4 NON-JOB ACTUATION MECHANISM GRADUATION**.
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
- Issue #67 — Workflow Success != Observation Success / non-blocking Lua harness reconciliation.

These are not Phase-13 closure blockers.

## Immediate next action

Validate **Phase 14.4 — Non-Job Actuation Mechanism Graduation**.

The candidate graduates the shared non-job physical actuation donor from
`PostJobActuationAuthority` to `NonJobActuationMechanism` while preserving the
separate warm `POST_JOB_ACTUATION` and cold
`OBSTRUCTION_RELOCATION_ACTUATION` semantic authority classes.

Do not begin Phase 14.5 until blocking CI and owner GIANTS Reality confirm both
warm D-0147 and cold D-0218 still execute and clean up the shared physical
mechanics correctly.
