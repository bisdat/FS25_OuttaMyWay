# Continuation State

Continuation State is the compact, replace-in-place description of the project's
present engineering boundary. Git history, pull requests, Issues and the
Engineering Journal preserve chronology.

## Repository authority

- Accepted Repository State: `main` after PR #126 merge,
  `3863982e0f9ad18c25a497e3f3014ce69f8b105e`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.52 TEST — OBSTRUCTION RELOCATION CORE CAPABILITY`**.
- Protected post-merge Offline Validation run #312 passed on the exact PR #126
  merge commit.
- Owner-run short GIANTS Reality smoke also passed for `.52`.
- Issue #87 remains open; `.52` retired `AUTOMATIC_TERMINAL_EGRESS` and established
  supported non-active, unclaimed Causal Obstruction relocation as a core
  OuttaMyWay capability rather than a separate consent option.

## Current workstream — Issue #87

`scripts/config.lua` remains a **Mixed Runtime Constants Surface**. Ownership
decomposition proceeds family-by-family from current semantics rather than
historical location or naming.

The next resolved ownership finding is:

> **Policy Concept != Shared Global Constant**

> **Watchdog Bound Belongs to the Actuator It Protects**

The historical `TERMINAL_*` pair is not one current family:

- the **60 m** per-actuation maximum is consumed only while
  `ObstructionRelocationCandidateSupport` constructs the bounded inward objective;
- the **45 s** bounded-move watchdog is consumed only by
  `ObstructionRelocationControl` while executing an already-authorised actuation.

The architecture requires a bounded inward actuation and safe physical fail-safe,
but current evidence does not justify root/global ownership of either numeric
calibration.

## Next bounded increment

Implement **`0.3.0.53 TEST — OBSTRUCTION RELOCATION BOUND OWNERSHIP`**:

1. preserve the accepted 60 m and 45 s values exactly;
2. move the 60 m calibration into `ObstructionRelocationCandidateSupport.lua`;
3. move the 45 s watchdog into `ObstructionRelocationControl.lua`;
4. remove `TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M` and
   `TERMINAL_EGRESS_MOVE_TIMEOUT_MS` from `scripts/config.lua`;
5. structurally protect those narrow ownership boundaries;
6. preserve all `.52` Candidate, responsibility, authority, recurrence,
   Player Claim/new-Job and Control semantics.

This increment is ownership/name reconciliation only. It does not retune the
relocation distance or watchdog duration and does not perform the broader
Player / Developer-Debug / Internal presentation reordering.

## Separate open work

- **#123** — deferred GIANTS Reality validation: new Job and Player Claim during
  Obstruction Relocation.
- **#116** — Cooperative Passage crossing-window jam investigation.
- **#45** — Bubble Bullet Time accepted architecture, not implemented.
- **#89** — deferred HUD / player communication work.

Do not fold those workstreams into #87 for convenience.
