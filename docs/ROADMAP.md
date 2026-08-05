# Roadmap

> **Currency:** v4.6.78 Replacement-Core Architecture Candidate
>
> **Canonical runtime source:** v4.6.71, containing active v4.6.56 runtime behaviour.

## Immediate objective

Review and owner-canonicalise the exact v4.6.78 documentation-only candidate. No behavioural implementation begins before that authority decision.

## Implementation programme

1. **Offline Architecture Kernel** — implement immutable records, enforcing lifecycle and deterministic replay with no GIANTS actuation.
2. **Passive live shadow** — publish live candidates, verdicts, Decisions, Commitments and obligations with zero Control authority.
3. **Active TS015 vertical slice** — grant authority to one complete Encounter only after offline and passive gates pass.
4. **Controlled expansion** — add repeated Encounters, TS016 and wider fixtures one responsibility at a time.

Detailed gates are defined in [`MIGRATION_PLAN.md`](MIGRATION_PLAN.md).

## Required pre-implementation contracts

- [`ARCHITECTURE_CONFORMANCE_MATRIX.md`](ARCHITECTURE_CONFORMANCE_MATRIX.md)
- [`COMMITMENT_STATE_MACHINE.md`](COMMITMENT_STATE_MACHINE.md)
- [`CANDIDATE_ACTION_CONTRACT.md`](CANDIDATE_ACTION_CONTRACT.md)
- [`RESPONSIBILITY_MAP.md`](RESPONSIBILITY_MAP.md)
- [`REPLAY_VALIDATION_SPECIFICATION.md`](REPLAY_VALIDATION_SPECIFICATION.md)
- [`REMOVAL_REGISTER.md`](REMOVAL_REGISTER.md)

## Explicitly deferred implementation discovery

- Native Continuation Speed Estimate;
- Reverse Actuation Discovery;
- exact candidate-generation geometry;
- action-specific Representation Fitness algorithms;
- numerical thresholds and time budgets;
- player communication design.

These may refine operands and capabilities. They must not redefine the ownership, lifecycle or obligation model.

## Prohibited shortcuts

- do not promote v4.6.72–v4.6.77 branch logic as the replacement core;
- do not use live runtime as the first composition test;
- do not add another procedural fallback to compensate for a failed architectural gate;
- do not infer implementation compliance from vocabulary, module names or isolated branch tests;
- do not grant Control authority before deterministic replay and passive-shadow conformance.

## Publication readiness

Publication review remains deferred until the replacement core has passed replay, passive shadow and a bounded active vertical slice. ModHub packaging, localisation completeness and user-facing HUD refinement are not current blockers.
