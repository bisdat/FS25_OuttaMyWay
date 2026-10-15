# Farm Spatial Context Observation Specification

## Identity and authority

**Specification Jurisdiction:** Farm Spatial Context Observation  
**Jurisdiction ID:** `FARM_SPATIAL_CONTEXT_OBSERVATION`

**Primary Architecture Authority:** [Farm Spatial Context Observation](../architecture/FARM_SPATIAL_CONTEXT_OBSERVATION.md#specification-jurisdiction--farm-spatial-context-observation)

This is a server-side, **DIAGNOSTIC-only**, strictly passive survey of one registered GIANTS field, selected only for an engineering experiment. No production settlement consumer exists. It does not authorise parking, off-field egress, GIANTS navigation agents, AI-job changes, road crossing or any existing completion TRANSIT / Hold & Relocate behaviour.

## Admission and lifecycle

Only when the profile Configuration is enabled and resolved, `g_server` exists, the independent diagnostic sidecar resolves to `DIAGNOSTIC`, **and that same engineering sidecar explicitly contains `spatialSurvey="true"`**, may this survey calculate field geometry or native nav/farmland queries. The default is survey OFF, including when DIAGNOSTIC publication is enabled for physical Completion Settlement. `DEBUG`, `NORMAL`, absent/false survey selection and unresolved Configuration must do no survey geometry. This explicit engineering survey consent is neither supported player Configuration nor Control authority.

When and only when admitted, the existing update listener performs one bounded survey approximately six seconds after map load, retrying missing prerequisites no later than 20 seconds, then records an explicit unavailable reason. Total sampling caps **do not** guarantee bounded per-frame execution: the experimental survey remains synchronous within a single update and may cause frame-pacing disruption. Clear one-shot state on map deletion. A missing or malformed optional survey flag must fail closed; no implicit opt-in is inferred from `spatialFarmlandId` or `settlementPrototype`.

Failure to resolve exactly one registered field for the selected farmland, or to discover default Field 77, missing road splines/costmap/farmland data, invalid geometry or exceeded sampling budgets must never be silently interpreted as a clear edge.

## Edge Segment definition

With no spatial selector, preserve the original GIANTS Field 77 fixture using `g_fieldManager:getFieldById(77)` when available, with fallback to the field registry. When the diagnostics sidecar contains optional `spatialFarmlandId`, enumerate the native registered fields, compare an interior field position against `FarmlandManager:getFarmlandIdAtWorldPosition`, and survey **only when exactly one** registered field maps to the selected farmland. A farmland number is not assumed to equal a registered field ID. Missing, invalid or ambiguous selection yields an unavailable result, never a guessed substitute. Read native ordered `densityMapPolygon.pointsX` and `pointsZ`; validate finite coordinates and nonzero polygon area. Construct each edge as the exact pair `vertex[i], vertex[i+1]`, including last-to-first wrap. Preserve both endpoints, their indices, edge length, the geometric minimum distance to any other registered field polygon (with its ID), and coordinate-based side label `X_MIN`, `X_MAX`, `Z_MIN` or `Z_MAX`. Side labels indicate world-coordinate extremes; do not equate `Z_MIN` with image top unless orientation is verified.

Determine the local outward normal using polygon winding and the native polygon point-in-containment test on both sides of a 0.25 m offset. If the local side is ambiguous, record unresolved evidence instead of assuming outside.

At most 96 samples per edge, spaced nominally 6 m with 6000 total sample budget, measured at interior segment positions, at 2, 6 and 12 metres along the **local outward** normal. Each offset reports farmland ID/owner distributions, source-field owner access permission when that owner is known, membership of other registered field polygons and GIANTS native point navigation cost/blocking distribution. Record blocked intervals along that segment in metres and count any offset points that re-enter the source polygon (a possible concavity). Summarise each coordinate-oriented side using 2 m costmap sample counts and nearest sampled road-spline distance. A sampled `navUnblocked` position is not full vehicle-clearance authority. The nearest-field measurement is horizontal X/Z polygon geometry only, not traversability of the intervening gap.

## Road-spline observation

Read `g_currentMission.aiSystem.roadSplines` without changing it. Sample each admitted native spline using `getSplineLength` and `getSplinePosition`, bounded to 300 splines, 8000 nearby spline points, within the Field 77 bounding box expanded by 60 m. Report approximate nearest sampled spline-to-edge distance; it is **not the distance to a road surface edge**. Missing or truncated spline evidence is unknown, never proof of no road.

No invocation of `AISystem:addBlockingRegion`, `addObstacle`, `setAreaDirty`, `addRoadSpline`, vehicle jobs, vehicle controls, map update, or any mutation API is admitted.

## TEST 0.5.5.3 — isolated Physical Margin Constraint witness

The adjacent `PhysicalMarginConstraintProbe` is an **engineering-only**, strictly read-only source-compatibility experiment within this Observation jurisdiction. It runs **once**, after the existing `FARM_CONTEXT_SURVEY_FINISHED` on the same explicitly requested server-only DIAGNOSTIC research survey. Its failure or missing API must **not** invalidate or retry the prior spatial survey. There is no new client, normal/debug, configuration, production assessment or Control consumer.

**Guarded Ground Truth fixtures only:**

- Without an explicit farmland selector, survey Mindenerwald registered **Field 77**, preferred south **edge 9** (expected length 230.97 m), and known hedge control **edge 2** (48.26 m).
- With `spatialSurvey=true` and `spatialFarmlandId=2`, survey Riverbend registered **Field 29**, preferred east **edge 1** (141.99 m), and north-road control **edge 7** (59.99 m).
- Reject any unsupported selector, registered field identity, edge-length or recorded **world-coordinate endpoint** mismatch (3 m fixture tolerance). These numeric fixture IDs are **test selection**, not a general settlement preference or production edge ranking.

At quarter and three-quarter stations of a preferred segment, sample a bounded set of inward/exterior depths. Field 77 uses `-2,1,2,3,4,6,8,12 m`; Riverbend `-2,2,6,12,18,24,30 m`. At Field 77's hedge control, sample at stations `8 m` and `40 m` with exterior depths `2,6,12 m`; at Riverbend's north road control, sample halfway along its edge at `2,6,12,18,24,30 m`. Budget **no more than 24 stations/offset positions and 22 synchronous physics queries** per completed survey. Every reading carries the native registered field/edge, station `s`, signed depth `d`, world X/Z, source polygon membership, farmland ID, navigation point status and terrain-height/normal availability.

**Positive physics witnesses:** when available, call native `overlapBox` at exterior points with a horizontal 0.9 m × 0.9 m and vertical 2 m box, 0.1 m above terrain, using represented `STATIC_OBJECT`, `BUILDING`, `TREE`, `ROAD` and `AI_BLOCKING` mask groups; dynamic objects excluded, static/kinematic enabled, exact overlap requested. Record hit count, a bounded list of node IDs/names and, if native collision-group classification works, ROAD/TREE/STATIC group presence. Terrain height and terrain normal, and optional nav costmap blocking, are read independently and may be unavailable. Record a grouped capability event, point events and a summary under `PHYSICAL_MARGIN`, including query failures and truncations.

`NO_REPRESENTED_HIT` means only **no callback hit in this finite test volume using the selected mask**, never a terrain/road/assembly clearance pass; `QUERY_FAILED` and `API_UNAVAILABLE` are different from no hit. Spline `maxWidth` is *not* used to infer road-surface width. This experiment does not compute a continuous Exterior Margin Profile, choose a parking position, perform collision-map mutations, move vehicles, or authorise a Settlement Corridor. Missing or differing v1.24 APIs are evidence to record, not conditions to invent fallback “clear” values.

Runtime acceptance requires user-supplied TEST 0.5.5.3 GIANTS Reality on both maps: a positive known hedge/road witness **or** explicit representation failure, compared with visible Ground Truth. Offline mocks only establish bounds and missing-evidence contract semantics. See [Physical Margin Constraint source study](../docs/research/PHYSICAL_MARGIN_CONSTRAINT_SOURCE_REVIEW.md).

## Comparison fixtures — owner's screenshots

For the existing Field 77 reference, compare four conditions using native logs from an actual play session:

1. The reported polygon and consecutive edge pairs should resemble the annotated blue Field 77 outline.
2. Road spline proximity should be examined along the **upper** screenshot boundary marked by road crosses; absence is a valuable negative result, not evidence that the road is absent.
3. Native exterior navigation blocking should be contrasted with the **right-hand hedge protrusions**. An unblocked report against an observed hedge falsifies the costmap's sufficiency for static geometry.
4. Inspect **left, right-lower and bottom** edge strips as possible directions for further investigation, not parking approvals. Distinguish different farmland IDs, ownership/access and physically obstructed stretches.

A non-georeferenced screenshot cannot directly validate metre offsets or world-coordinate side orientation. For the second experiment, Riverbend Springs Farmland 2 (TS004), use `<outtaMyWayDiagnostics enabled="true" spatialSurvey="true" spatialFarmlandId="2" />` from the engineering diagnostics sidecar to select the matching registered field; verify `selectedFarmlandId` and `resolvedFarmlandId` in `FARM_CONTEXT_FIELD`. Compare the irregular vegetation margin, north/east access roads, eastern railway and southern road with reported edges. No parking judgement is derived from the image alone.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/observation/FarmEdgeGeometry.lua`](../scripts/observation/FarmEdgeGeometry.lua) | `REALISES` |
| [`scripts/observation/PhysicalMarginConstraintProbe.lua`](../scripts/observation/PhysicalMarginConstraintProbe.lua) | `REALISES` |
| [`scripts/observation/FarmSpatialContextProbe.lua`](../scripts/observation/FarmSpatialContextProbe.lua) | `REALISES` |
| [`scripts/diagnostics/DiagnosticPublicationPolicySource.lua`](../scripts/diagnostics/DiagnosticPublicationPolicySource.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/farm_edge_geometry.lua`](../tests/shell/farm_edge_geometry.lua) | `CHALLENGES` |
| [`tests/shell/physical_margin_constraint_probe.lua`](../tests/shell/physical_margin_constraint_probe.lua) | `CHALLENGES` |
| [`tests/shell/farm_spatial_context_probe.lua`](../tests/shell/farm_spatial_context_probe.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |

## Test envelope

Offline tests use a four-edge synthetic Field 77, neighboring Field 78, a top-side native road spline, a mock right-hand hedge obstruction, and a second synthetic registered field selected through Farmland 2. Duplicate fields in a selected farmland must be rejected as ambiguous. Assert true exterior orientation under both polygon windings, discrete blocked intervals on the right, foreign farmland/access identity and the source-field owner. Assert no map calculations under NORMAL/DEBUG **or DIAGNOSTIC without explicit `spatialSurvey=true`**, and only one survey when engineering consent and DIAGNOSTIC are both present. In-game validation remains necessary; no physical or road-crossing consequence is tested.
