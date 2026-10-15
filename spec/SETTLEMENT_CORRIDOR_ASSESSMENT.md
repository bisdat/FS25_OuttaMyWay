# Settlement Corridor Assessment — Nominal Polygon Evidence

## Identity and authority

**Specification Jurisdiction:** Settlement Corridor Assessment  
**Jurisdiction ID:** `SETTLEMENT_CORRIDOR_ASSESSMENT`

**Primary Architecture Authority:** [Exterior Margin Profile — Settlement Corridor Assessment](../architecture/EXTERIOR_MARGIN_PROFILE.md#distinct-downstream-responsibility--settlement-corridor-assessment)

## Current bounded contract (TEST 0.5.5.19)

The architectural Settlement Corridor question asks whether a *specific actual Physical Assembly* can approach, traverse and stop in exterior space with acceptable physical and operational separation. This assessment is not an independent Control authority.

The shared production `SettlementCorridorAssessment` module retains nominal polygon-intersection evidence used directly by `CompletionSettlementRoute`. Its `shapeIntersectsPolygon(rect,poly)` evaluates convex member rectangles and rigid straight-translation hulls against registered productive field polygons, including corners inside polygons, polygon vertices inside shapes, boundary crossings and concavities. Return `true` for positive polygon intersection, `false` for demonstrated polygon-only nonintersection, and `nil` when required geometry is missing. **Unknown is not free space**. No result is road, collision, terrain, worker, articulated, approach or native driving proof.

The route obtains field geometry and physical occupancy through its own demand-driven producers at the appropriate decision point. It does **not** consume `FarmSpatialContextProbe`, `PhysicalMarginConstraintProbe`, `AssemblySettlementProbe` or `SettlementStraightRunout`.

## Retired research responsibility

TEST 0.5.5.4–0.5.5.6 originally explored bounded diagnostic 144-pose nominal static screens and continuous rigid straight-sweep polygon witnesses on Field 77. Those historical positive samples were **necessary-only** hypothetical evidence, never parking waypoints or safety authority. The research findings are retained in [Nominal Assembly Research](../docs/research/ASSEMBLY_SETTLEMENT_NOMINAL_TEST.md) following the owner-validated TEST 0.5.5.18 A/B startup stutter test and two-worker parking regression. They are no longer loaded as game scripts.

These findings remain true historical research, but the finite diagnostic survey is no longer an implementation obligation or a precondition for real Completion Settlement planning.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/SettlementCorridorAssessment.lua`](../scripts/assessment/SettlementCorridorAssessment.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/settlement_corridor_assessment.lua`](../tests/shell/settlement_corridor_assessment.lua) | `CHALLENGES` |
| [`tests/shell/completion_settlement_route.lua`](../tests/shell/completion_settlement_route.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |

## Evidence strength

Offline polygon tests protect the bounded geometry algorithm; only GIANTS Reality can validate driveable approach, real-margin occupation, native stop, articulated clearance, worker conflicts and general-field applicability. The known TS019 .17/.18 successes are Field 77/single-member-bounded and do not settle #484's missing-evidence and incomplete-guide interruption risks.
