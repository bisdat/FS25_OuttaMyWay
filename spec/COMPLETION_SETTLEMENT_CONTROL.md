# Completion Settlement Control — Explicit TEST Prototype

## Identity and authority

**Specification Jurisdiction:** Completion Settlement Control  
**Jurisdiction ID:** `COMPLETION_SETTLEMENT_CONTROL`

**Primary Architecture Authority:** [Completion-Triggered Terminal Egress — Completion Settlement Control](../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md#specification-jurisdiction--completion-settlement-control-test)

**Status:** Implemented as an explicitly gated TEST prototype; unvalidated in GIANTS Reality. This is not a generally supported parking capability.

## Admission

A real native successful GIANTS `AIJobFieldWork` stop is the only trigger. The established [Completion Transit](COMPLETION_TRANSIT.md) consumer first requests native TRANSIT configuration; request acceptance, not fold completion, enables the subsequent prototype. A manual job stop, new AI job, disabled mod, missing native vehicle identity, an active blocked-recovery intervention, missing geometry or a vehicle outside the target source field vetoes Control.

Physical movement additionally requires an explicit engineering-only `settlementPrototype="true"` attribute in `modSettings/FS25_OuttaMyWay/diagnostics.xml`, alongside `enabled="true"`. Diagnostic logging alone does **not** enable physical Control. The default is no settlement movement. This is intentionally separate from player Configuration and must not mutate the existing accepted completion-TRANSIT request-only behaviour when the opt-in is absent.

TEST 0.5.5.7 admits only the already surveyed Mindenerwald registered Field **77**, native southern edge **9**, matched by its measured ordered endpoints and length. Other fields remain not admitted. This is a scoped Reality experiment, not field-dependent general product logic.

## Route and native physical action

At admission, capture the **actual current root + attached member** nominal rectangle snapshot and run the existing 144 static-pose registered-field screen and bounded continuous straight-sweep. For the selected native Field 77 edge, select the largest reported positive sweep witness with at least 60 metres of bounded nominal uninterrupted polygon-only travel. A reported 204.55 m is a *per-run observation*, not a literal route length or universal threshold. When neither direction yields a geometrically placeable approach/exit, refuse actuation.

Construct three forward-only steering legs relative to the native selected edge-station and outward normal:

1. **Infield Approach** — reach an interior staging root 16 m behind the chosen nominal sweep seed station and 6 m inside the boundary, subject to the polygon-interior check. The native driver steers to that world point, rather than planning a reverse or constructing a new AI job.
2. **Shallow Crossing** — steer 24 m longitudinally forward from that staging station to 8 m beyond the seed station while moving outward to the seed's nominal depth. At 2 m outward depth this is an 8 m lateral change over 24 m longitudinally, about 18.4 degrees from the edge tangent, before later steering transients. The assertion is about **waypoint geometry**, not demonstrated tyre or hitch trajectory.
3. **Forward Run-Out** — steer along the selected tangent at the selected depth to the polygon sweep's lower-bound endpoint minus a 3 m nominal diagnostic buffer. Actual complete-assembly settlement is evaluated after the third leg, never merely on the root reaching the boundary.

These are **point targets**, not a validated safe route or promised lane. The crossing uses the expressly accepted driveable-edge premise for prototyping. Registered productive-field polygons are the only positive nominal travel witness. Roads, hedge colliders, other moving workers, articulation during turns and physical margin obstacles are not certified. Native dynamics may disprove the manoeuvre.

An *independent instance* of [Native Static Assembly Drive](../scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua) supplies the same GIANTS `AIVehicleUtil.driveToPoint`, forward steering node, motor, cruise and release mechanisms already used by blocked recovery. A separate `COMPLETION_SETTLEMENT_LEG` return contract reports root arrival within 2.5 m of its target; completed ordinary blocker-recovery objectives retain their unchanged region semantics. Prototype maximum commanded speed is **8 km/h** (or lower native limit). A lateral trajectory divergence over 20 m, failed native command, unobservable pose, unexpected new AI job, other intervention, disable or bounded lease expiry aborts and neutralises motion.

The complete attempt has a finite 240-second Control lease and each leg a 180-second upper bound. Those bounds are failsafes, not claims that a GIANTS vehicle must complete the route in that time. No automatic retry or speculative reversal is permitted.

## Terminal and interruption

After the final forward leg stops, recapture the *current* attached assembly nominal member geometry. A successful TEST observation requires unchanged member count, the root and **every captured member rectangle disjoint from the source and other registered field polygons**. If any member remains inside or current membership cannot be observed, report an interrupted or incomplete terminal rather than celebrating root arrival.

Release the active native steering/motor/cruise lease after each leg and on any interruption. Do not restore WORKING posture to the completed vehicle. A player disabling the mod must immediately request neutralisation; a subsequently acquired GIANTS AI job supersedes the completion attempt. Map teardown discards deleted physical references without issuing stale engine calls. Any failure to neutralise is published as a warning.

There is no generally verified dynamic-worker demand arbitration, collision-complete physical safety proof, or universal off-field parking allocation. Any such unsupported assumption must remain falsifiable during the explicitly opted-in prototype.

## Observable contract

NORMAL runtime events `COMPLETION_SETTLEMENT_ADMITTED`, `COMPLETION_SETTLEMENT_LEG_STARTED`, `COMPLETION_SETTLEMENT_LEG_FINISHED`, `COMPLETION_SETTLEMENT_FINISHED`, `COMPLETION_SETTLEMENT_NOT_ADMITTED`, `COMPLETION_SETTLEMENT_INTERRUPTED` and `COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED` distinguish stages and failures. The existing `COMPLETED_WORKER_TRANSIT_REQUESTED` still records the separate configuration request. Experimental action must never be inferred merely from the previous DIAGNOSTIC polygon-sweep log.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/coordination/CompletionSettlementRoute.lua`](../scripts/coordination/CompletionSettlementRoute.lua) | `REALISES` |
| [`scripts/control/CompletionSettlementRuntime.lua`](../scripts/control/CompletionSettlementRuntime.lua) | `REALISES` |
| [`scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua`](../scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua) | `SUPPORTS` |
| [`scripts/diagnostics/DiagnosticPublicationPolicySource.lua`](../scripts/diagnostics/DiagnosticPublicationPolicySource.lua) | `SUPPORTS` |
| [`scripts/control/CompletionTransitRuntime.lua`](../scripts/control/CompletionTransitRuntime.lua) | `SUPPORTS` |
| [`scripts/main.lua`](../scripts/main.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/completion_settlement.lua`](../tests/shell/completion_settlement.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |
| [`tests/test_product_shell_structure.py`](../tests/test_product_shell_structure.py) | `CHALLENGES` |
| [`tests/replacement_core/diagnostic_publication_policy_source.lua`](../tests/replacement_core/diagnostic_publication_policy_source.lua) | `CHALLENGES` |

**Validation boundary:** GitHub Actions verifies offline contracts and syntax. Only a controlled GIANTS session on the named savegame can test the forward manoeuvre, attachment tracking, cancellation and end-state. Record any deviation as evidence and retain PR #482 draft until field validation.
