# Continuation State

Continuation State is the compact, replace-in-place description of the project's
present engineering boundary. Git history, pull requests, Issues and the
Engineering Journal preserve chronology.

## Repository authority

- Accepted Repository State: `main` after PR #127 merge,
  `df3493e1cdbb3770287ed1cfba88ec60b0ee7813`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.53 TEST — OBSTRUCTION RELOCATION BOUND OWNERSHIP`**.
- Protected post-merge Offline Validation run #314 passed on the exact PR #127
  merge commit.
- Issue #87 remains open. `.53` localised the Obstruction Relocation 60 m
  per-actuation calibration to Candidate Support and the 45 s physical move
  watchdog to Control without retuning either value.

## Current workstream — Issue #87

`scripts/config.lua` remains a **Mixed Runtime Constants Surface**. Ownership
decomposition proceeds family-by-family from current semantics rather than
historical location or naming.

The resolved cadence-family findings are:

> **Similar Cadence Values != Shared Scheduling Responsibility**

> **Diagnostic Observer Has No Independent Sampling Clock**

> **Sampling Cadence != Bounded Observation Deadline**

The first `.54` preflight disproved the hypothesis that
`PASSIVE_SAMPLE_INTERVAL_MS = 1000` was orphan residue. Current source instead
establishes four live values with three owners:

- `LiveRuntimeCoordinator` schedules the complete live
  Observation -> Situation -> Decision -> bounded Control cycle at **250 ms**;
- `PassiveLiveValidator` owns diagnostic publication/throttling only:
  **10 s** heartbeat and **8** pair-log lines per sample;
- `PassiveLiveCandidateSupport` uses the historical **1 s** "sample interval"
  solely to construct the `CONTINUE_OBSERVATION` Bounded Observation Contract
  `reassessmentDeadline`.

`CommitmentPreconditionsConstraint` requires that deadline and exposes its
exhaustion as `BOUNDED_OBSERVATION_EXHAUSTION`. The 1 s value is therefore live
evidence-contract calibration, not a scheduling clock.

## Next bounded increment

Implement **`0.3.0.54 TEST — RUNTIME CADENCE OWNERSHIP`**:

1. preserve **250 ms** exactly and localise it to `LiveRuntimeCoordinator`;
2. preserve **10 s** and **8** exactly and localise them to
   `PassiveLiveValidator`;
3. preserve **1 s** exactly, rename it as a Candidate-owned Bounded Observation
   reassessment horizon, and localise it to `PassiveLiveCandidateSupport`;
4. remove all four values from the root mixed constants surface;
5. structurally protect the three ownership boundaries.

The contract vocabulary `NEXT_PASSIVE_SAMPLE` remains unchanged in this tranche.
Its truthfulness is a separate semantic question and must not be casually renamed
as part of constant placement.

This is ownership/name reconciliation only. It does not redesign scheduling,
retune any value, alter Bounded Observation semantics, create player
Configuration, change probe-specific cadences, or perform the broader
Player / Developer-Debug / Internal presentation reordering.

## Separate open work

- **#123** — deferred GIANTS Reality validation: new Job and Player Claim during
  Obstruction Relocation.
- **#116** — Cooperative Passage crossing-window jam investigation.
- **#45** — Bubble Bullet Time accepted architecture, not implemented.
- **#89** — deferred HUD / player communication work.

Do not fold those workstreams into #87 for convenience.
