# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve prior chronology; this file records what matters for the next decision.

## Repository authority

- Accepted Repository State: `main` at merge commit `23370f19f05f912ca9517dcf24ac5930c8fbb5e0` (PR #61).
- Canonical authority remains **v0.3.0.0**.
- Last accepted non-canonical playable identity is **`0.3.0.17 TEST — CAUSAL OBSTRUCTION RELOCATION`**.
- Current Phase-13 Engineering Increment advances the branch identity to **`0.3.0.18 TEST — CONSTRAINT VERDICT OWNERSHIP`**; this is not accepted or Reality-validated until its PR/validation completes.
- Issues #33 and #60 are closed PASS records for the accepted `.17` obstruction-relocation and normal smoke evidence.

## Strangler programme status

Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.

Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.

Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **IN PROGRESS — CONSTRAINT VERDICT OWNERSHIP RECONCILIATION**.

Phase 14 — Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming — **NOT STARTED**.

Phase 15 — Whole-system validation and architecture-to-runtime review — **NOT STARTED**.

## Phase 13 closure-audit discovery

### Candidate Evidence != Constraint Verdict

The closure audit found one proved duplication before Phase 13 can close. Candidate describes a feasible option and its evidence, requirements, obligations and expected effects; it is not selection or verdict authority.

Production nevertheless carried historical `evidenceBasis.constraintEvidence` packets through Candidate creation. Seven nominal mandatory evaluators merely converted Candidate-authored `PASS` / `FAIL` / `UNRESOLVED` into new `ConstraintVerdict` identities without independently answering a bounded question.

Named discoveries:

- **Candidate Evidence != Constraint Verdict**.
- **Candidate Self-Attestation != Constraint Evaluation**.
- **Planning Feasibility != Constraint Re-evaluation**.
- **Release Contract != Pre-Decision Verdict**.

### Independently owned Constraint questions

The current evidence supports four independently evaluated questions:

1. `REPRESENTATION_FITNESS` — current purpose-specific Representation evidence.
2. `RESPONSIBILITY_COMPATIBILITY` — current `FOLLOWER_OWNS_CLOSURE` invariant where applicable.
3. `COMMITMENT_PRECONDITIONS` — Bounded Observation Contract for `CONTINUE_OBSERVATION`.
4. `EFFECTIVE_ACTUATION_COMPOSITION` — structural validity of proposed physical actuation composition.

The former checklist families `FIELD_WORLD_CONTAINMENT`, `TRANSITION_CLEARANCE`, `CONTROL_CAPABILITY_AVAILABILITY`, `CONTINUING_INTENT_PRIORITY`, `PROGRESS_PRESERVATION`, `OBLIGATION_COMPATIBILITY`, and `SAFE_RELEASE_HANDOVER` are not independently evaluated Constraint authority. Their useful evidence and contracts remain at the planning/lifecycle boundary that owns them.

## Current implementation hypothesis — `.18`

> Candidate proposes evidence and a feasible option. Constraint owns any claim that the option satisfies a mandatory invariant.

The bounded `.18` implementation:

- strips historical Candidate-support verdict packets at the canonical `CandidateAction` construction boundary and preserves their non-verdict content as descriptive planning evidence;
- forbids `constraintEvidence` inside canonical `CandidateAction` data;
- removes `ConstraintEvidence.fromCandidate()` and the seven pass-through evaluator modules;
- retains only the four independently owned Constraint questions above;
- removes Candidate-packet fallback from retained evaluators;
- leaves Situation Assessment, Candidate planning, Decision policy, Responsibility Transition, D-0217, D-0218 and physical Control mechanics unchanged.

This is a behavioural-preservation hypothesis until CI and, if warranted by evidence, GIANTS Reality validate it.

## Generic multi-context application cardinality

The closure audit classifies the known generic Commitment multi-context limitation as **ACCEPTABLE FAIL-CLOSED LIMIT for current implemented production behaviour**. Revisit it only when a concrete supported consumer requires it, notably Issue #45 Bubble Bullet Time.

## Deferred final Phase-13 question — Preselection != Candidate Enumeration

Purpose-specific Candidate support still performs some ordering before `DecisionSelector` sees the Candidate inventory. `.18` deliberately does not change that. After Constraint Verdict Ownership is validated, repeat the closure audit only across Candidate enumeration → Decision selection.

## Phase 13 closure rule

Phase 13 can close when `.18` is independently validated and the final Candidate-enumeration / Decision-selection audit either finds distinct truthful responsibilities or proves one final bounded duplication that is then corrected and independently validated.

## Separate non-blocking work

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.

## Immediate next action

Validate the `.18` Constraint Verdict Ownership Engineering Increment through GitHub Actions. If offline contracts pass, decide from the actual behavioural delta whether a GIANTS Reality smoke run is justified. Then repeat the Phase-13 closure audit only at Candidate enumeration → Decision selection.
