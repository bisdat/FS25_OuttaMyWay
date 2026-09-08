# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve chronology; this file records only what matters for the next decision.

## Repository authority

- Accepted Repository State baseline for this increment: `main` after PR #84 merge, commit `57f65c0dccdf39764bca6cfea4bfe082a93852f0`.
- Canonical authority remains **v0.3.0.0**.
- Accepted non-canonical playable identity remains **`0.3.0.28 TEST — FOLLOWER HUD GLYPH COMPATIBILITY`**.
- PR #84 is merged. Issue #82 is closed after targeted follower-Regulation Reality demonstrated the `.28` correction with no Character 8226 warning on the exercised active path.
- Protected `main` requires both `Structural contracts` and `Lua offline behavioural contracts`.
- Phase 14.5 Runtime Integration Consolidation is complete.
- **Phase 14.6 is ACTIVE at architecture/design stage.** This documentation-only design increment changes no executable mod bytes and consumes no TEST build identity.
- Canonical authority is unchanged.

## Strangler programme status

- Phase 11 — Reduce `LiveControlDispatcher` to Authorised Control Routing — **COMPLETE**.
- Phase 12 — Retire superseded generic Commitment/orchestration only when no supported path relies on it — **COMPLETE**.
- Phase 13 — Simplify Candidate/Constraint/Decision only where evidence proves duplication — **COMPLETE**.
- Phase 14 — Graduate remaining prototype/diagnostic production mechanics, runtime scoping and naming — **IN PROGRESS — 14.6 ACTIVE**.
- Phase 15 — Whole-system validation and architecture-to-runtime review — **NOT STARTED**.

Read [Phase 13 Closure Audit](architecture/PHASE_13_CLOSURE_AUDIT.md) for Phase-13 closure evidence.

Read [Phase 14.6 Terminal Egress Execution and Production Vocabulary](architecture/PHASE_14_6_TERMINAL_EGRESS_EXECUTION_AND_PRODUCTION_VOCABULARY.md) for the current engineering boundary.

## Current Candidate / Constraint / Decision architecture

The current production chain remains intentionally separated:

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
        ↓
Bounded Authority
        ↓
Control
```

Candidate owns feasible option construction, planning and support provenance. Constraint owns independently evaluated mandatory questions. Decision owns supported choice/policy selection. Responsibility Transition establishes or preserves current semantic responsibility. Bounded Authority narrows permitted actuation. Control realises already-authorised requests through GIANTS mechanisms and reports outcomes.

**Commitment Operation != Responsibility Transition** and **Downstream Authority Monotonicity** remain accepted boundaries.

## Phase 14.6 architectural discoveries

### Trigger Provenance != Terminal Egress Execution

Completed Obstruction and current Causal Obstruction are distinct triggers for Resolution responsibility. They are not distinct physical Terminal Egress executors.

Trigger-specific admission, governing basis, beneficiary/controlled-subject semantics, Commitment/Obligation lifecycle and semantic Authority remain upstream. Once Terminal Egress is authorised, Control should execute the supplied plan against current physical Reality without branching on historical D-0147/D-0218 provenance.

### Shared Execution Support != Trigger-Specific Mechanism

Protected Yield, configuration handling, bounded fixed-direction movement, Player Claim/source-AI supersession, neutralisation and Vehicle Activity Context are execution-support concepts. They should use provenance-neutral Terminal Egress vocabulary.

`RegulationBoundedAuthority` already supplies the same zero-speed Protected Yield mechanism to both trigger paths; its current `d0147ProtectedYield...` naming is production-vocabulary debt.

### Trigger History != Execution Addressability

Completed-Job history may establish a Completed Obstruction trigger, but Terminal Egress execution should address the current physical subject through `CurrentPhysicalAssemblySource` rather than retain Job-history object lookup as an execution prerequisite.

`CurrentPhysicalAssemblySource` observes usable current mission vehicle roots independently of active Job membership.

### Prototype Graduation Implies Prototype Retirement

Prototype22 was a transient capability-discovery/manual-validation harness. Its Hold, Drive and Configuration mechanisms have graduated to production.

The hypothesis that Prototype22 remained necessary to install the shared `NativeDriveMechanism` was disproved: `CooperativePassageControl:loadMap()` independently installs the same idempotent mechanism.

The architectural disposition of Prototype22 is therefore **RETIRE**, subject to an exact implementation dependency scan.

### Decision Provenance != Production Vocabulary

D-numbers, TEST labels, Step labels and prototype identifiers may remain as historical comments/provenance where they explain a current constraint. They must not remain the primary names of current production support boundaries, architecture modes, runtime targets, owner tags, failure reasons or constants.

## Phase 14.6 target execution boundary

```text
Completed Obstruction ──────┐
                            │
Causal Obstruction ─────────┤
                            ▼
                  Responsibility / Authority
                            │
                            ▼
                   Terminal Egress Plan
                            │
                            ▼
                   TerminalEgressControl
                            │
             ┌──────────────┼──────────────┐
             ▼              ▼              ▼
       Configuration   Protected Yield   Non-job Actuation
                            │
                            ▼
                          Reality
```

`TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M` and `TERMINAL_EGRESS_MOVE_TIMEOUT_MS` remain acceptable execution-owned constants if they continue to describe the actual shared Terminal Egress policy. Do not create parallel per-trigger copies merely because different trigger paths consume the same execution.

## Planned Phase 14.6 sequence

### 14.6A — Terminal Egress Execution Consolidation and Prototype Retirement

Behaviour-preserving structural target:

- one provenance-neutral `TerminalEgressControl`;
- retain distinct Completed Obstruction and Causal Obstruction trigger semantics upstream;
- absorb the physical behaviour of `ObstructionRelocationControl` into Terminal Egress execution and retire the duplicate Control;
- rename Protected Yield execution support away from D-0147 provenance;
- use current-physical subject addressability at Control;
- neutralise misleading post-job mechanical failure vocabulary;
- retire `Prototype22CapabilityGate`, `otmP22`, P22 HUD/event registration and `PROTOTYPE_22_*` constants after exact dependency validation;
- preserve production Hold/Drive/Configuration behaviour.

The first pushed executable implementation revision after `.28` must carry a fresh TEST build identity.

Primary validation hypothesis:

**For an already-authorised Terminal Egress plan, physical execution depends on the plan and current physical subject, not on whether Completed Obstruction or Causal Obstruction triggered the responsibility.**

GIANTS Reality must exercise completed-obstruction Terminal Egress, current Causal Obstruction Terminal Egress, Regulation after Prototype22 retirement, and Cooperative Passage after the shared-drive/prototype cleanup.

### 14.6B — Production Vocabulary and Constants Scope

After 14.6A is accepted, reconcile remaining production D-number/TEST/Step/prototype vocabulary across Cooperative Passage, Regulation, Guarded Recovery, Action-Space Regulation and related Runtime/contracts.

Rename or relocate constants only where current ownership is established. Do not perform blind textual substitution or aesthetic repository-wide cleanup.

### Phase 14 closure audit

After 14.6A/14.6B, perform an explicit closure audit for surviving prototype/diagnostic production responsibility, duplicate execution ownership, runtime patching/load-order seams, primary production D-number/TEST/Step vocabulary, misleading constants ownership and stale implementation/navigation guidance.

Do not declare Phase 14 complete merely because the two implementation increments merge.

## Accepted current limits

### Generic multi-context application cardinality

A semantically targetable retained context may still fail closed at generic Commitment application when more than one retained context exists.

This remains **ACCEPTABLE FAIL-CLOSED LIMIT for current implemented production behaviour**. Revisit only for a concrete supported consumer, notably Issue #45 Bubble Bullet Time.

### Supported traffic envelope

The supported Operation envelope remains a maximum of **three simultaneously active GIANTS AI worker assemblies**. The player does not count. Validation is aimed at different agronomic roles; same-agronomy or >3-worker scenarios may work incidentally but are outside supported design/validation scope.

## Separate open work

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.
- Issue #65 — Behaviour Regression Contract != Build Identity Contract.

## Immediate next action

Review and accept the documentation-only **Phase 14.6 Terminal Egress Execution and Production Vocabulary** design increment.

After merge, begin **14.6A Terminal Egress Execution Consolidation and Prototype Retirement** from clean/current `main`. Do not begin with mechanical renaming. First preserve trigger semantics and establish the single Terminal Egress execution contract; then remove duplicate/prototype implementation only where the dependency audit proves retirement safe.
