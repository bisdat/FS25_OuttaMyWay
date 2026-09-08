# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary. Git history, pull requests, issues and the Engineering Journal preserve chronology; this file records only what matters for the next decision.

## Repository authority

- Accepted Repository State baseline for this increment: `main` after PR #85 merge, commit `466424f5fe6e984d041c9f00c484a9bd9e82b397`.
- Canonical authority remains **v0.3.0.0**.
- This branch advances executable identity to **`0.3.0.30 TEST — TERMINAL EGRESS OBSERVABILITY AND CI RECONCILIATION`**; it makes no canonical claim.
- Protected `main` requires both `Structural contracts` and `Lua offline behavioural contracts`.
- Issue #82 is closed after the bounded `.28` follower-HUD correction and targeted GIANTS Reality validation.
- Phase 14 remains **ACTIVE**. Phase 14.6A is implemented on this branch; independent offline validation is green and the final `.30` GIANTS smoke is an apparent pass. PR #88 is at the owner-acceptance boundary.

## Documentation responsibility correction

Phase 14 exposed a repository-governance defect: engineering tranche documents had been accumulated under `docs/architecture/` even though their responsibility was migration history rather than current architecture.

The governing correction is:

- **Engineering Increment Documentation != Durable Architecture**;
- **Current Architecture Should Not Require Historical Reconstruction**.

`AGENTS.md` now contains a mandatory **Documentation Creation Gate — Malicious Compliance guard**. A request to record, audit, design or document work does not authorise creation of another live document. New live documentation requires an enduring responsibility that no current document already owns. Phase/tranche/audit/closure chronology belongs in existing current owners plus authorised history/evidence surfaces, not in a chain of live architecture deltas.

The Phase-14 tranche documents are being removed after their still-current knowledge is reconciled into the Implementation Map, this Continuation State and existing architectural/governance owners. Git and PR history retain the exact historical documents.

## Current strangler boundary

The current production responsibility chain remains:

```text
Reality
    ↓
Observation
    ↓
Situation Assessment
    ↓
Candidate
    ↓
Constraint
    ↓
Decision
    ↓
Responsibility Transition
    ↓
Current Responsibility
    ↓
Bounded Authority
    ↓
Control
    ↓
Reality
```

Candidate, Constraint, Decision and Responsibility Transition remain distinct because each contributes independently owned work. Phase 14 is not authorised to collapse those layers for implementation convenience.

## Current Phase-14 implementation state

Already accepted source placement now includes:

- production `RegulationControl` separated from the former Prototype22 Control surface;
- production `FieldWorkHoldMechanism`, `NativeDriveMechanism` and `TransitConfigurationMechanism` under `scripts/control/mechanisms/`;
- production `LiveInteractionObservation` under Observation placement;
- shared `NonJobActuationMechanism` under Control mechanisms;
- direct Runtime/Observation composition for accepted Causal Obstruction relocation and Prospective Decision Portfolio responsibilities, with the former load-order integration wrappers retired.

The current Implementation Map owns exact source placement and remaining drift.

## Current Phase-14.6 architectural interpretation

### Trigger Provenance != Terminal Egress Execution

Completed Obstruction and current Causal Obstruction remain distinct reasons for establishing Resolution responsibility. Their admission, governing basis, beneficiary/controlled-subject semantics, Commitment/Obligation lifecycle and settlement evidence remain upstream and may differ.

Once an already-authorised bounded movement reaches Control, the execution problem is Terminal Egress. The current hypothesis is that physical execution should depend on the supplied objective, current physical subject and current Bounded Authority rather than D-0147/D-0218 trigger provenance.

This branch removes the `TerminalEgressControl` / `ObstructionRelocationControl` split: both already-authorised movement paths now enter one `TerminalEgressControl`, while their trigger-specific Responsibility and lifecycle semantics remain upstream. Independent offline contracts are green and the `.30` GIANTS smoke is an apparent pass; this does not imply that the two triggers are semantically identical or prove the whole Supported Envelope.

### Shared execution support

Protected Yield, configuration handling, bounded fixed-direction movement, Player Claim/source-AI supersession, Vehicle Activity Context and neutralisation are execution-support concepts. Their production names should not retain D-0147 provenance when the same execution support is used by another legitimate trigger.

`TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M` and `TERMINAL_EGRESS_MOVE_TIMEOUT_MS` are acceptable execution-owned constants if they continue to describe one shared Terminal Egress policy. Do not create per-trigger copies merely because two trigger paths consume the same execution.

### Current physical addressability

Historical Job Episode evidence may establish a Completed Obstruction trigger, but authorised physical execution should address current Reality. `CurrentPhysicalAssemblySource` observes current usable mission vehicle roots independently of active Job membership and is the current candidate addressability boundary for Terminal Egress execution.

### Prototype22

Prototype22 was a transient capability-validation harness. Its Hold, Drive and Configuration mechanisms have graduated to production. The exact dependency scan found no remaining durable runtime responsibility, so this branch removes the harness, event registration and `PROTOTYPE_22_*` runtime constants.

The earlier hypothesis that Prototype22 uniquely installed the shared native drive hook was disproved: production Cooperative Passage independently installs the same idempotent mechanism.

### Production vocabulary

Decision numbers and TEST/Step/Prototype labels may remain as provenance where they explain history. They should not remain the primary identity of current production concepts, support boundaries, target kinds, owner tags, failure reasons or constants.

The cleanup must be ownership-driven rather than a repository-wide textual rename.

## Behaviour preservation boundary

The next executable tranche must preserve:

- GIANTS ownership of jobs, productive route, steering, turning and ordinary navigation;
- the maximum-three-active-AI supported Operation envelope;
- Candidate / Constraint / Decision / Responsibility ownership boundaries;
- Bounded Authority monotonicity;
- Completed Obstruction versus current Causal Obstruction trigger semantics;
- beneficiary / controlled-subject separation;
- current first-courtesy 60 m Interior Settlement policy;
- completed-obstruction second-courtesy Final Boundary Settlement rules;
- current Causal Obstruction first-courtesy-only scope and fresh-Situation reassessment;
- Protected Yield beneficiary protection;
- Player Claim and source-AI supersession;
- compaction/configuration behaviour;
- actuation neutralisation and Vehicle Activity Context release;
- Regulation and Cooperative Passage behaviour.

## Separate open work

- Issue #37 — Category-2 Forward Intersection Reality-validation debt.
- Issue #45 — Bubble Bullet Time, accepted but unimplemented.
- Issue #65 — Behaviour Regression Contract != Build Identity Contract.

These remain separate from the current Phase-14.6 placement/vocabulary work.

## Immediate next action

PR #88 is at the **owner-acceptance boundary** on `0.3.0.30 TEST — TERMINAL EGRESS OBSERVABILITY AND CI RECONCILIATION`.

Final evidence on exact executable/test-contract head `a6d0921a5fff08ae498def74c71296cfbbebdee9` before this docs-only record:

- GitHub Actions run #245: **Structural contracts PASS**;
- GitHub Actions run #245: **Lua offline behavioural contracts PASS**;
- `.30` GIANTS smoke: **apparent pass**;
- the `.29` lingering final `Terminal...` HUD message was **not reproduced in `.30`**; screenshot/owner evidence is recorded in Issue #89.

The HUD symptom is therefore cleared for this increment without a dedicated HUD implementation change. Issue #89 remains open because player-facing HUD/message ownership and lifecycle are still a separate unresolved architecture responsibility.

If the repository owner accepts PR #88, merge it. That merge advances Accepted Repository State only; it does **not** canonicalise `.30`.

After merge, continue Phase 14.6 from clean/current `main`. Protected Yield still carries D-0147 implementation vocabulary and remains a later Phase-14.6 cleanup target. Production TEST/Step/D-number vocabulary and the Mixed Runtime Constants Surface remain ownership-driven follow-up work; Issues #86, #87 and #89 own the newly separated performance, configuration-surface and HUD work respectively.

The `.30` smoke is fixture-bounded Reality evidence, not Supported-Envelope proof. Later regression selection remains causal to the responsibility being changed.

Contrary Reality updates the architecture rather than being hidden behind compatibility special cases.
