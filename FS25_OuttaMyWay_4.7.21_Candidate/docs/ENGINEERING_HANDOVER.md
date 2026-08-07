# Engineering Handover

> **Canonical baseline:** v4.7.18  
> **Candidate:** v4.7.21 Future Space Conformance  
> **Control authority:** disabled

## v4.7.21 current continuation point

Repository archaeology confirmed that ADR-0006/ADR-0012 already define Future Space, Local Intent Horizon, Intent Expiry and Option Preservation. The replacement-core defect is implementation non-conformance: the live producer had reduced Future Space to a ten-second constant-velocity corridor.

v4.7.21 passively recovers settled/turning Local Intent from native GIANTS FieldCourse `isTurn`, bounds settled straight continuation by the current Job-Seeded Field World, leaves the unrepresented manoeuvre sweep unresolved, advances intent epoch after post-turn settlement, and publishes positive field-bounded pair intersection into Situation Assessment as Knowledge only. The historical ten-second predictor remains isolated solely for the previously validated Encounter-admission path.

**Live objective:** capture a native `straight → turning → straight` sequence and verify the Future Space HUD/log changes correspondingly, with a positive field-bounded relationship appearing whenever supported by settled Local Intent. No collision is required. Do not activate Decision/Control. The separate lifecycle termination-precedence defect remains open.

## Closed gates

- Field World and Operation identity: canonical v4.7.14.
- Exact TS015 non-admission diagnosis: canonical v4.7.15.
- Configuration-filtered approximately 36 m physical representation: canonical v4.7.17.
- Positive footprint evidence handoff and Encounter creation: canonical v4.7.18.

## Carried lifecycle implementation

The v4.7.19 `EncounterRegistry` remains unchanged in purpose: active Encounter identity is bound to Operation, interaction reference and participating Job Episodes; temporary evidence absence retains it; explicit lifecycle evidence terminates it; a restarted job receives a fresh Episode identity; renewed positive evidence creates a fresh Encounter.

## v4.7.20 corrections

The first v4.7.19 live attempt did not reach the required action order because the manual stop occurred before Encounter creation. This exposed **Diagnostic Signal Saturation**. The same run also exposed invalid shape-bound calls on transform groups.

v4.7.20 adds:

```text
WAITING FOR ENCOUNTER
→ ENCOUNTER ACTIVE: stop either AI worker
→ ENCOUNTER TERMINATED: restart stopped worker
→ NEW JOB EPISODE: re-establish approach
→ NEW ENCOUNTER CREATED: test complete
```

The HUD is temporary diagnostic instrumentation. A matching `[OTM TEST GATE]` line is emitted once per transition. Routine pair console output is state-change/heartbeat throttled, while trace records remain complete. `AssemblyRepresentationCache` now requires positive `ClassIds.SHAPE` evidence before invoking a shape-bound API.

## Live objective

Follow the HUD. Confirm the first Encounter is created and retained, terminates with `JOB_EPISODE_ENDED`, the restart admits a fresh Job Episode, and renewed convergence creates a different Encounter identity. Decision must remain passive, no Commitment may be applied and `control=false` throughout.

## Deferred boundary

Do not interpret absence of positive evidence as same-Episode safe separation. That remains the next distinct architecture and evidence problem.
