# Continuation State

## Repository authority

- Accepted Repository State: `main` after PR #135 merge,
  `b04cc98cb4d66aeccb77fd146205903d89b35d09`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.61 TEST — TRAJECTORY ASSESSMENT VALUE OWNERSHIP`**.
- Post-merge Offline Validation run #334 passed on that exact merge commit.
- Issue #87 remains open.

## Current workstream — Issue #87

After `.61`, Follower Boundary was examined by responsibility rather than prefix.
Six values govern Situation-level Follower Boundary assessment: current alignment,
provisional temporal seed, established-purpose retention and clearance-factor
calibration. `SituationAssessment` currently forwards them from the historical
mixed root, while `FollowerBoundaryDemandAssessment` is the module that gives
them meaning.

A seventh similarly named value is different:
`FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED` is consumed later by
`LiveTrafficCandidateSupport` as a Candidate-expression gate.

> **Capability Gate != Assessment Calibration**

> **Parameter Courier != Semantic Owner**

The Lua behavioural harness already supplies the accepted assessment values
directly in focused D-0141 fixtures, so behavioural regression evidence remains
independent of root placement.

## Next bounded increment

Implement **`0.3.0.62 TEST — FOLLOWER BOUNDARY ASSESSMENT VALUE OWNERSHIP`**:

1. preserve the six accepted assessment calibrations exactly;
2. make `FollowerBoundaryDemandAssessment` their explicit module-local owner;
3. retain direct options/values as focused-test override seams;
4. remove only those six historical root definitions from `scripts/config.lua`;
5. stop production `SituationAssessment` couriering evaluator-private calibration;
6. preserve all current Follower Boundary assessment semantics and reason/provenance vocabulary;
7. preserve `FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED = true` unchanged as
   the separate Candidate-expression gate in `LiveTrafficCandidateSupport`;
8. reconcile historical tests that froze the old root placement while preserving
   their substantive aligned-production and behavioural witnesses.

No speed retune, enable-gate ownership, HUD/#89, Passage/Resolution-Space policy,
#123, #116 or #45 work belongs in this increment.

## Separate open work

- **#123** — deferred GIANTS Reality validation.
- **#116** — Cooperative Passage crossing-window jam investigation.
- **#45** — Bubble Bullet Time accepted architecture, not implemented.
- **#89** — deferred HUD / player communication work.
