# Completion Settlement Control — Explicit TEST Prototype

## Identity and authority

**Specification Jurisdiction:** Completion Settlement Control  
**Jurisdiction ID:** `COMPLETION_SETTLEMENT_CONTROL`

**Primary Architecture Authority:** [Completion-Triggered Terminal Egress — Completion Settlement Control](../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md#specification-jurisdiction--completion-settlement-control-test)

**Status:** Implemented as an explicitly gated TEST prototype; unvalidated in GIANTS Reality. This is not a generally supported parking capability.

## Admission

A real native successful GIANTS `AIJobFieldWork` stop is the only trigger. The established [Completion Transit](COMPLETION_TRANSIT.md) consumer first requests native TRANSIT configuration; request acceptance, not fold completion, enables the subsequent prototype. A manual job stop, new AI job, disabled mod, missing native vehicle identity, an active blocked-recovery intervention, missing geometry or a vehicle outside the target source field vetoes Control.

Physical movement additionally requires an explicit engineering-only `settlementPrototype="true"` attribute in `modSettings/FS25_OuttaMyWay/diagnostics.xml`, alongside `enabled="true"`. Diagnostic logging alone does **not** enable physical Control. The default is no settlement movement. This is intentionally separate from player Configuration and must not mutate the existing accepted completion-TRANSIT request-only behaviour when the opt-in is absent.

TEST 0.5.5.8 admits only the already surveyed Mindenerwald registered Field **77**, native southern edge **9**, matched by its measured ordered endpoints and length. Other fields remain not admitted. This is a scoped Reality experiment, not field-dependent general product logic.


## Governing objective after the 12 October owner clarification

**Architecture authority:** [Pose-Conditioned Terminal Settlement](../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md#owner-confirmed-architecture-refinement--pose-conditioned-terminal-settlement-12-october-2026).

The subsequent architectural decision defines an **entire-assembly terminal parking region between field boundaries** as the objective, with **success anywhere along a suitable edge**, not a specific point or mandated full-edge traverse. It prefers **brief reverse followed by forward entry** when feasible, otherwise a pose-conditioned manoeuvre such as forward J-entry. Reassess from each independently completed worker's actual root/attached-member pose. The necessary forward distance depends on assembly clearance and final stopping feasibility, not a predetermined 60 m or ~200 m route literal.

**TEST `0.5.5.8` behaviour below is historical implementation, now known not to realise this goal.** In particular its maximum-sweep candidate selection, fixed far staging point, three stop-and-release waypoint transitions, forward-only direction and endpoint-minus-3 m terminal target are prototype-specific and **not accepted architectural constraints**. Do not silently alter or portray those clauses as a future general product contract. The next Control contract must be decided and separately authorised after assessing progressive forward/reverse guidance, physical swept envelopes, continuous waypoint tracking, suitable terminal region membership, stopping, and interruption.

The existing player-Control veto was introduced without explicit authorisation in `0.5.5.8`; owner direction is to **retain it temporarily without retroactive architectural acceptance**. The consent gate remains separately required; no TEST executable change is implied by this specification annotation.

## Route and native physical action

At admission, capture the **actual current root + attached member** nominal rectangle snapshot and run the existing 144 static-pose registered-field screen and bounded continuous straight-sweep. For the selected native Field 77 edge, select the largest reported positive sweep witness with at least 60 metres of bounded nominal uninterrupted polygon-only travel. A reported 204.55 m is a *per-run observation*, not a literal route length or universal threshold. When neither direction yields a geometrically placeable approach/exit, refuse actuation.

Construct three forward-only steering legs relative to the native selected edge-station and outward normal:

1. **Infield Approach** — reach an interior staging root 16 m behind the chosen nominal sweep seed station and 6 m inside the boundary, subject to the polygon-interior check. The native driver steers to that world point, rather than planning a reverse or constructing a new AI job.
2. **Shallow Crossing** — steer 24 m longitudinally forward from that staging station to 8 m beyond the seed station while moving outward to the seed's nominal depth. At 2 m outward depth this is an 8 m lateral change over 24 m longitudinally, about 18.4 degrees from the edge tangent, before later steering transients. The assertion is about **waypoint geometry**, not demonstrated tyre or hitch trajectory.
3. **Forward Run-Out** — steer along the selected tangent at the selected depth to the polygon sweep's lower-bound endpoint minus a 3 m nominal diagnostic buffer. Actual complete-assembly settlement is evaluated after the third leg, never merely on the root reaching the boundary.

These are **point targets**, not a validated safe route or promised lane. The crossing uses the expressly accepted driveable-edge premise for prototyping. Registered productive-field polygons are the only positive nominal travel witness. Roads, hedge colliders, other moving workers, articulation during turns and physical margin obstacles are not certified. Native dynamics may disprove the manoeuvre.

An *independent instance* of [Native Static Assembly Drive](../scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua) supplies the same GIANTS `AIVehicleUtil.driveToPoint`, forward steering node, motor, cruise and release mechanisms already used by blocked recovery. A separate `COMPLETION_SETTLEMENT_LEG` return contract reports root arrival within 2.5 m of its target; completed ordinary blocker-recovery objectives retain their unchanged region semantics. Completion Settlement commands the vehicle's **native forward motor/cruise maximum** without an artificial 8 km/h cap. The new Control path passes a true local-space **point position** into GIANTS `driveToPoint`; the separately validated Hold & Relocate legacy normalised-target path is deliberately unchanged in this TEST. A lateral trajectory divergence over 20 m, failed native command, unobservable pose, unexpected new AI job, other intervention, disable or bounded lease expiry aborts and neutralises motion.

The complete attempt has a finite 240-second Control lease and each leg a 180-second upper bound. Those bounds are failsafes, not claims that a GIANTS vehicle must complete the route in that time. No automatic retry or speculative reversal is permitted.

## Terminal and interruption

After the final forward leg stops, recapture the *current* attached assembly nominal member geometry. A successful TEST observation requires unchanged member count, the root and **every captured member rectangle disjoint from the source and other registered field polygons**. If any member remains inside or current membership cannot be observed, report an interrupted or incomplete terminal rather than celebrating root arrival.

Root arrival at a waypoint is **not** physical stopping. After each leg's arrival, retain the native actuator lease and issue `driveToPoint` with driving disabled, steering neutral and native cruise OFF **every update**. Continue until `lastSpeedReal` is at most 0.12 m/s, and root displacement stays within 0.20 m, for at least 1,200 ms of continuous measured stillness. Require positive cruise-OFF observation before releasing the leg. If speed/position/confirmation is unavailable, Control interrupts without declaring successful settlement. This contract is independently testable from polygon terminal occupancy.

Releasing a Completion Settlement leg keeps native cruise OFF, restores the prior forward/reverse cruise *limits* only and requests the engine to stop where no newer native AI job or player-Control claim has taken over. The prior ACTIVE cruise state must **not** be reactivated on a parked completed vehicle. A final `COMPLETION_SETTLEMENT_FINISHED` requires both verified stopped final-leg release and the fresh full-member geometry check. Disable, a new native AI job or a positive player-Control selection must revoke physical movement and request bounded neutralisation; engine control must not be stolen from a newly active job or player-controlled vehicle. Map teardown discards deleted physical references without issuing stale engine calls. Any failure to neutralise is published as a warning.

**Player Control interlock:** at admission and throughout execution, a positive `getIsControlled()` or `g_currentMission.controlledVehicle` root selection preempts Completion Settlement. A missing or false witness cannot establish exclusive ownership; it only does not veto this tightly opted-in TEST. No active player steering and OuttaMyWay steering may be combined to satisfy a successful autonomous motion test. The turn path remains the same three waypoint legs as TEST 0.5.5.7; a J-entry trajectory change is deliberately deferred until independent steering is retested.

There is no generally verified dynamic-worker demand arbitration, collision-complete physical safety proof, or universal off-field parking allocation. Any such unsupported assumption must remain falsifiable during the explicitly opted-in prototype.

## Observable contract

NORMAL runtime events `COMPLETION_SETTLEMENT_ADMITTED`, `COMPLETION_SETTLEMENT_LEG_STARTED`, `COMPLETION_SETTLEMENT_STOPPING`, `COMPLETION_SETTLEMENT_LEG_FINISHED`, `COMPLETION_SETTLEMENT_FINISHED`, `COMPLETION_SETTLEMENT_NOT_ADMITTED`, `COMPLETION_SETTLEMENT_INTERRUPTED` and `COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED` distinguish stages and failures. The existing `COMPLETED_WORKER_TRANSIT_REQUESTED` still records the separate configuration request. Experimental action must never be inferred merely from the previous DIAGNOSTIC polygon-sweep log. One-second `COMPLETION_SETTLEMENT_MOTION_SAMPLE` payloads are eligible only for `DIAGNOSTIC` publication and include current heading, requested steering state, native velocity, cruise state, player-claim witness and local target distance. They must not be computed when DIAGNOSTIC is disabled.

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
| [`tests/shell/completion_settlement_drive.lua`](../tests/shell/completion_settlement_drive.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |
| [`tests/test_product_shell_structure.py`](../tests/test_product_shell_structure.py) | `CHALLENGES` |
| [`tests/replacement_core/diagnostic_publication_policy_source.lua`](../tests/replacement_core/diagnostic_publication_policy_source.lua) | `CHALLENGES` |

**Validation boundary:** GitHub Actions verifies offline contracts and syntax. Only a controlled GIANTS session on the named savegame can test the forward manoeuvre, attachment tracking, cancellation and end-state. Record any deviation as evidence and retain PR #482 draft until field validation.

## TEST 0.5.5.9 — pose-conditioned regional guidance (experimental revision)

This revises the **historical 0.5.5.8 three-leg route**, which remains described above as evidence of the rejected approach. Only the explicit prototype on registered Field 77 native edge 9 is changed. The owner-confirmed objective is **any stationary complete-assembly pose in a suitable inter-field parking strip** rather than a far longitudinal waypoint. Route planning captures the *current completed vehicle pose and nominal attached-member rectangles* and assesses both directions along the preferred edge.

**Entry candidate generation (bounded TEST hypotheses):** nominal rigid-member paths from the current heading use a short reverse (trial lengths 0, 12, 18, 24 or 30 metres), followed by two opposing forward arcs to move outward while returning to an edge-parallel heading; alternatively, a forward heading-acquisition J turn precedes the outward S-entry. Test radii 12/18/24 m and heading excursion samples 35/45/55/65/75°. Check each ~5-m guidance sample against known neighbouring registered fields, source-field containment during reverse, edge projection and the configured exterior band. *Neither sampled kinematics nor nominal rectangles establish GIANTS tire/implement swept clearance or road/ditch physics.* A candidate exists only if a complete-member terminal region witness is reached within a short continuation. Prefer lower total movement distance over a longer nominal parking strip. A second worker at a different completion pose is replanned independently and may receive different guidance and a different stop station. Refuse with `NO_POSE_REACHABLE_PARKING_REGION` when no sampled candidate exists rather than driving toward a point behind the vehicle.

**Steering contract:** the short targets are **continuous guidance**, not mandatory individual stops. With unchanged travel direction, retarget the native steering point under the same leased movement Control. Reverse→forward or terminal parking transitions require a positive physical stop, cruise OFF, and separate native re-arming. Native reverse uses GIANTS' reverser node and the existing native tool-relative reverse transform. The implicit 8 km/h experimental limit is **not restored**: a per-target braking-envelope speed `sqrt(2 × 1.5 m/s² × clamp(next-target distance, 2.5–12m))` (converted to km/h) is a tunable, unvalidated experimental model constrained by each direction's native motor/cruise ceiling. In particular, this is **not a claim of proven achievable deceleration** or permission to travel at full motor speed into a short stop corridor.

**Observed safety contracts:** an active guidance vector may not accumulate more than 5 m negative signed progress, the root must remain in the source field or the bounded nominated exterior edge band, and all native Control still obeys 240s total, 180s segment, disable/job supersession and the **retained owner-instructed** player-Control interlock. A final waypoint arrival alone cannot assert success; only physical stopping followed by recaptured current complete-member rectangles, outside the source and neighbouring registered field polygons and within the nominal edge strip, may produce `COMPLETION_SETTLEMENT_FINISHED`. The whole-member physical envelope is still incomplete in the presence of changing articulation or other world obstacles. The first field test must use the single-member TS018 sprayer.

**Required validation:** old `0.5.5.8` near-straight drive must not recur for an unreachable distant point; observe short target progression, any reverse→forward stop, actual steering curvature, whole-member final geometry and zero speed *after* completion. Assert CI BWR non-regression, pose-dependent varied terminal station, route refusal when infeasible and continuous same-direction retarget. No field success is inferred from CI. The route is *not* authorised for general maps or as universal reverse capability.
