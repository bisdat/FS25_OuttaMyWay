# Continuation State

## Repository authority

- Accepted Repository State: `main` after PR #136 merge,
  `bbb23dfee0b2b5c55e241d54e2f66bfef64d6a40`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.62 TEST — FOLLOWER BOUNDARY ASSESSMENT VALUE OWNERSHIP`**.
- Post-merge Offline Validation run #336 passed on that exact merge commit.
- Issue #87 remains open.

## Current workstream — Issue #87

Post-`.62`, review of three apparent capability booleans exposed a deeper
architectural mismatch. Two guarded `.63` preflights aborted before mutation and
proved that the historical gates were more deeply embedded than root constants:
Cooperative Passage was checked in planning and active Control, while the old
Control flag was duplicated into PassiveLiveValidator.

That evidence changed the question from **where should these flags live?** to
**should a core capability or architectural prohibition have a boolean state at
all?**

> **Core Capability Has No Enable State**

> **Master Enablement != Per-Capability Enablement**

> **Committed Responsibility Cannot Be Revoked by a Feature Flag**

> **Architectural Prohibition Has No Disable Flag**

> **Diagnostic Assertion != Enforcement Mechanism**

> **Negative Authority Annotation != Capability Enable State**

Master OuttaMyWay enablement is the accepted product-level consent boundary.
Below it, Situation / Responsibility / Bounded Authority determine whether a
supported core action exists. Typed Control realises that action. Unsupported or
generic Control has no authorised route rather than a boolean set to false.

The three Field World identity/equivalence modules retain their explicit
`controlAuthorityEnabled=false` evidence annotations. Those values scope the
authority of the evidence product itself; they are not Runtime capability state
and are not consumed as a rollout veto.

## Next bounded increment

Implement **`0.3.0.63 TEST — CORE CAPABILITY GATE RETIREMENT`**:

1. retire root `COOPERATIVE_PASSAGE_ENABLED`,
   `FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED` and
   `CONTROL_AUTHORITY_ENABLED`;
2. remove the Follower Candidate-expression rollout veto;
3. remove Cooperative Passage planner/admission/active-Commitment feature-gate
   checks and gate-only `COOPERATIVE_PASSAGE_DISABLED*` reasons;
4. remove Runtime `controlAuthorityEnabled` /
   `generalControlAuthorityEnabled` pseudo-state and status publication while
   preserving the Field World evidence-level `controlAuthorityEnabled=false`
   annotations;
5. remove PassiveLiveValidator / PassiveLiveTraceRecord general-Control boolean
   assertion/publication/schema state;
6. preserve actual authority and safety topology: current evidence, Responsibility,
   Bounded Authority, typed dispatcher, executor availability and current
   Control/safety evidence;
7. reconcile historical tests from boolean placement/state to those architectural
   invariants and remove test setup that merely forces core Passage enabled;
8. preserve Passage geometry/policy/calibration, Follower assessment/magnitude
   and all supported Control behaviour.

Master enablement implementation itself remains deferred player Configuration and
is outside `.63`. HUD/#89, #123, #116 and #45 remain separate.

## Separate open work

- **#123** — deferred GIANTS Reality validation.
- **#116** — Cooperative Passage crossing-window jam investigation.
- **#45** — Bubble Bullet Time accepted architecture, not implemented.
- **#89** — deferred HUD / player communication work.
