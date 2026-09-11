# Continuation State

## Repository authority

- Accepted Repository State: `main` after PR #134 merge,
  `b06f78a74443a5b547affcb8eca91e0fa3579d1c`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.60 TEST — LIVE DIAGNOSTIC VALUE OWNERSHIP`**.
- Post-merge Offline Validation run #332 passed on that exact merge commit.
- Issue #87 remains open.

## Current workstream — Issue #87

The remaining mixed-root families were re-evaluated by responsibility rather than
prefix. HUD ownership is intentionally deferred because #89 owns later player/HUD
work. Follower Boundary is not one ownership family: assessment calibration and
the production enable gate have different meanings.

Trajectory is cleaner. Ten trajectory/opposed-current values are interpreted by
`TrajectoryConflictAssessment`; `SituationAssessment` currently forwards them
only because they historically live in `scripts/config.lua`.

> **Parameter Courier != Semantic Owner**

The Lua behavioural harness already supplies these thresholds directly as focused
fixture inputs, so behavioural regression evidence is independent of root placement.

## Next bounded increment

Implement **`0.3.0.61 TEST — TRAJECTORY ASSESSMENT VALUE OWNERSHIP`**:

1. preserve all ten accepted trajectory/opposed-current literals exactly;
2. make `TrajectoryConflictAssessment` their explicit module-local owner;
3. retain optional context overrides for focused tests/fixtures;
4. remove only those ten historical root definitions from `scripts/config.lua`;
5. stop production `SituationAssessment` forwarding evaluator-private calibration;
6. preserve all current Trajectory Conflict Assessment semantics;
7. retain `COOPERATIVE_PASSAGE_LOCAL_MAX_ENTRY_SEPARATION_M = 80` as external
   Passage/Action-Space context supplied by `SituationAssessment`;
8. add focused structural ownership protection while preserving the existing
   independent Lua behavioural fixtures unchanged.

No HUD/#89, Follower Boundary, Passage/Resolution-Space policy, #123, #116 or #45
work belongs in this increment.

## Separate open work

- **#123** — deferred GIANTS Reality validation.
- **#116** — Cooperative Passage crossing-window jam investigation.
- **#45** — Bubble Bullet Time accepted architecture, not implemented.
- **#89** — deferred HUD / player communication work.
