# Continuation State

## Repository authority

- Accepted Repository State: `main` after PR #137 merge,
  `7874314b69a168e83770092c026afe49506e18dc`.
- Canonical authority remains **v0.3.0.0**.
- Accepted executable identity is
  **`0.3.0.63 TEST — CORE CAPABILITY GATE RETIREMENT`**.
- Post-merge Offline Validation run #339 passed structural and Lua behavioural contracts.
- Issue #87 remains open for Root Surface Closure.
- Issue #139 separately owns supported player Configuration.

## Current workstream — Issue #87

`.63` retired the remaining core-capability/pseudo-authority enable-state layer.
Current core behaviour is governed by Reality / Situation, Responsibility,
Bounded Authority and typed Control rather than per-capability booleans.

The subsequent Root Surface Closure census exposed a distinct surviving debt:
historical decision identifiers still appeared in executable production
provenance, authority labels, evidence/outcome kinds, addressability keys and
telemetry. The Phase-14 strangler corrected authority topology but its naming
contract explicitly allowed historical provenance, and the structural test suite
encoded that exception.

> **Production Vocabulary Closure != Validation Vocabulary Closure**

> **Source Topology Defines Production Surface**

Git owns chronology. Historical decision identity may remain in research/history
and, temporarily, validation fixtures, but it must not cross into the executable
production surface sourced by `scripts/main.lua`.

## Current bounded increment

Implement **`0.3.0.64 TEST — PRODUCTION VOCABULARY CLOSURE`**:

1. replace executable D-number provenance, authority, evidence/outcome, runtime
   identity/addressability and telemetry names with current architectural
   responsibility vocabulary;
2. reverse the structural production-vocabulary contract so it rejects
   historical decision identity across the complete `scripts/main.lua` source
   topology rather than preserving selected exceptions;
3. remove rolling version/decision-history headers from production modules
   touched by the tranche where Git already owns that chronology;
4. preserve runtime behaviour, policy/calibration, geometry, lifecycle,
   authority boundaries and Control semantics;
5. leave replacement-core fixture/test-title vocabulary for a separate
   behaviour-neutral Validation Vocabulary Closure increment.

This tranche does **not** relocate the remaining `scripts/config.lua` constants,
retire `BUILD_LABEL` / `ARCHITECTURE_VERSION` / `RUNTIME_MODE`, implement player
Configuration, redesign HUD behaviour, retune Passage/Regulation policy or touch
the separate Condor donor investigation.

## Root Surface Closure after `.64`

After Production Vocabulary Closure:

1. close validation-only historical vocabulary separately;
2. resume #87 ownership movement/retirement from the closed consumer census;
3. preserve the accepted **Two Root Identities; Everything Else Must Earn an
   Owner** direction;
4. keep player-facing Configuration under #139 and HUD/player communication
   under #89.

## Separate open work

- **#139** — supported player Configuration surface.
- **#138** — Condor representation donor catalogue/fallback investigation.
- **#123** — deferred GIANTS Reality validation.
- **#116** — Cooperative Passage crossing-window jam investigation.
- **#45** — Bubble Bullet Time accepted architecture, not implemented.
- **#89** — deferred HUD / player communication work.
