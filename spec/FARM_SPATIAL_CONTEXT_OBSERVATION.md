# Farm Spatial Context Observation Specification

## Identity and authority

**Specification Jurisdiction:** Farm Spatial Context Observation  
**Jurisdiction ID:** `FARM_SPATIAL_CONTEXT_OBSERVATION`

**Primary Architecture Authority:** [Farm Spatial Context Observation](../architecture/FARM_SPATIAL_CONTEXT_OBSERVATION.md#specification-jurisdiction--farm-spatial-context-observation)

This is a server-side, **DIAGNOSTIC-only**, strictly passive survey of one registered GIANTS field, selected only for an engineering experiment. No production settlement consumer exists. It does not authorise parking, off-field egress, GIANTS navigation agents, AI-job changes, road crossing or any existing completion TRANSIT / Hold & Relocate behaviour.

## Admission and lifecycle

Only when the profile Configuration is enabled and resolved, `g_server` exists, and the independent diagnostic publication sidecar resolves to `DIAGNOSTIC` may map geometry or native nav/farmland queries be calculated. `DEBUG` and `NORMAL` must not calculate them at all. The update listener performs one bounded survey approximately six seconds after map load, retrying missing prerequisites no later than 20 seconds, then records an explicit unavailable reason. Clear one-shot state on map deletion.

Failure to resolve exactly one registered field for the selected farmland, or to discover default Field 77, missing road splines/costmap/farmland data, invalid geometry or exceeded sampling budgets must never be silently interpreted as a clear edge.

## Edge Segment definition

With no spatial selector, preserve the original GIANTS Field 77 fixture using `g_fieldManager:getFieldById(77)` when available, with fallback to the field registry. When the diagnostics sidecar contains optional `spatialFarmlandId`, enumerate the native registered fields, compare an interior field position against `FarmlandManager:getFarmlandIdAtWorldPosition`, and survey **only when exactly one** registered field maps to the selected farmland. A farmland number is not assumed to equal a registered field ID. Missing, invalid or ambiguous selection yields an unavailable result, never a guessed substitute. Read native ordered `densityMapPolygon.pointsX` and `pointsZ`; validate finite coordinates and nonzero polygon area. Construct each edge as the exact pair `vertex[i], vertex[i+1]`, including last-to-first wrap. Preserve both endpoints, their indices, edge length, the geometric minimum distance to any other registered field polygon (with its ID), and coordinate-based side label `X_MIN`, `X_MAX`, `Z_MIN` or `Z_MAX`. Side labels indicate world-coordinate extremes; do not equate `Z_MIN` with image top unless orientation is verified.

Determine the local outward normal using polygon winding and the native polygon point-in-containment test on both sides of a 0.25 m offset. If the local side is ambiguous, record unresolved evidence instead of assuming outside.

At most 96 samples per edge, spaced nominally 6 m with 6000 total sample budget, measured at interior segment positions, at 2, 6 and 12 metres along the **local outward** normal. Each offset reports farmland ID/owner distributions, source-field owner access permission when that owner is known, membership of other registered field polygons and GIANTS native point navigation cost/blocking distribution. Record blocked intervals along that segment in metres and count any offset points that re-enter the source polygon (a possible concavity). Summarise each coordinate-oriented side using 2 m costmap sample counts and nearest sampled road-spline distance. A sampled `navUnblocked` position is not full vehicle-clearance authority. The nearest-field measurement is horizontal X/Z polygon geometry only, not traversability of the intervening gap.

## Road-spline observation

Read `g_currentMission.aiSystem.roadSplines` without changing it. Sample each admitted native spline using `getSplineLength` and `getSplinePosition`, bounded to 300 splines, 8000 nearby spline points, within the Field 77 bounding box expanded by 60 m. Report approximate nearest sampled spline-to-edge distance; it is **not the distance to a road surface edge**. Missing or truncated spline evidence is unknown, never proof of no road.

No invocation of `AISystem:addBlockingRegion`, `addObstacle`, `setAreaDirty`, `addRoadSpline`, vehicle jobs, vehicle controls, map update, or any mutation API is admitted.

## Comparison fixtures — owner's screenshots

For the existing Field 77 reference, compare four conditions using native logs from an actual play session:

1. The reported polygon and consecutive edge pairs should resemble the annotated blue Field 77 outline.
2. Road spline proximity should be examined along the **upper** screenshot boundary marked by road crosses; absence is a valuable negative result, not evidence that the road is absent.
3. Native exterior navigation blocking should be contrasted with the **right-hand hedge protrusions**. An unblocked report against an observed hedge falsifies the costmap's sufficiency for static geometry.
4. Inspect **left, right-lower and bottom** edge strips as possible directions for further investigation, not parking approvals. Distinguish different farmland IDs, ownership/access and physically obstructed stretches.

A non-georeferenced screenshot cannot directly validate metre offsets or world-coordinate side orientation. For the second experiment, Riverbend Springs Farmland 2 (TS004), use `<outtaMyWayDiagnostics enabled="true" spatialFarmlandId="2" />` from the engineering diagnostics sidecar to select the matching registered field; verify `selectedFarmlandId` and `resolvedFarmlandId` in `FARM_CONTEXT_FIELD`. Compare the irregular vegetation margin, north/east access roads, eastern railway and southern road with reported edges. No parking judgement is derived from the image alone.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/observation/FarmEdgeGeometry.lua`](../scripts/observation/FarmEdgeGeometry.lua) | `REALISES` |
| [`scripts/observation/FarmSpatialContextProbe.lua`](../scripts/observation/FarmSpatialContextProbe.lua) | `REALISES` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/farm_edge_geometry.lua`](../tests/shell/farm_edge_geometry.lua) | `CHALLENGES` |
| [`tests/shell/farm_spatial_context_probe.lua`](../tests/shell/farm_spatial_context_probe.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |

## Test envelope

Offline tests use a four-edge synthetic Field 77, neighboring Field 78, a top-side native road spline, a mock right-hand hedge obstruction, and a second synthetic registered field selected through Farmland 2. Duplicate fields in a selected farmland must be rejected as ambiguous. Assert true exterior orientation under both polygon windings, discrete blocked intervals on the right, foreign farmland/access identity and the source-field owner. Assert no map calculations under NORMAL/DEBUG and only one survey under DIAGNOSTIC. In-game validation remains necessary; no physical or road-crossing consequence is tested.
