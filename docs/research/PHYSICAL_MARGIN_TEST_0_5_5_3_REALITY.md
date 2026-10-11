# TEST 0.5.5.3 — GIANTS Reality, Mindenerwald then Riverbend (11 October 2026)

**Owner-supplied evidence:** `log(20261011-150455).txt`, 5,003 lines, FS25 **1.24.0.0**, OuttaMyWay TEST **0.5.5.3**. Both map sessions are in the **same** log, separated by a GIANTS soft restart. Owner reports they had to force-close the game after the Riverbend session; logs do not establish its cause.

**Scope:** `FARM_SPATIAL_CONTEXT` plus the new `PHYSICAL_MARGIN` DIAGNOSTIC experiment only. No settlement Control is implemented. Findings are *positive/negative representation evidence*, not a verdict on parking an articulated assembly.

## Session chronology and target-resolution correction

| Session | Loaded map, time | Logged native selection | Survey / physics result |
| --- | --- | --- | --- |
| 1 | **Mindenerwald** (`FS25_CliviosMindenerwald/maps/map.i3d`), launched 16:02:10 | `FARM_CONTEXT_FIELD field=2 selectedFarmlandId=2 resolvedFarmlandId=2 targetSelection=FARMLAND`, **6 edges** | Baseline 321 offset samples, `FARM_CONTEXT_SURVEY_FINISHED` at **16:02:51.117**. Physical `PHYSICAL_MARGIN_UNAVAILABLE reason=UNSUPPORTED_EXPERIMENT_FIXTURE`. This is **not Field 77**, and does **not test its nominated edge 9 or hedge control edge 2**. |
| 2 | **Riverbend Springs** (`data/maps/mapUS/mapUS.i3d`), launched 16:03:03 | `FARM_CONTEXT_FIELD field=29 selectedFarmlandId=2 resolvedFarmlandId=2 targetSelection=FARMLAND`, **14 edges** | Baseline 282 offset samples, `FARM_CONTEXT_SURVEY_FINISHED` at **16:03:49.080**. Physics experiment finished **16:03:49.081**. |

**Root cause of the missing Field 77 test:** The diagnostics sidecar retained `spatialFarmlandId="2"` during the Mindenerwald session, so the spatial survey *correctly selected* native Field 2 on that map. The adjunct correctly rejected a fixture for a *different* field/map rather than pretending Field 2 was Field 77. This is **test configuration, not a source crash**. For the missing run, set `<outtaMyWayDiagnostics enabled="true" />` (omit `spatialFarmlandId`) before loading Mindenerwald; no AI workers are needed.

## Riverbend source-compatibility result

`PHYSICAL_MARGIN_CAPABILITY` at 16:03:49.080 reported:

- `overlapBoxApi=true`, `raycastApi=true`, `sweepBoxApi=true`, `terrainHeightApi=true`, `terrainNormalApi=true`, `roadFlagApi=true`, `groupClassifierApi=true`.
- Native `collisionMask=14370`, small experimental oriented box half-extents `0.45,1.00,0.45 m`.
- **20 observed positions** (14 preferred edge 1 including two infield references, six control edge 7), **18 synchronous physics calls**, **zero query errors**, no budget or per-point hit-list truncation.
- **Exactly one physics hit:** the visible-road control, **native field 29 / edge 7 / station 29.99 m / outward depth +30 m**, world `x=-936.87 z=90.32`, `farmlandId=255`, `navBlocking=blocked`, `physics=HIT`, `physicsHits=1`, `roadGroupHits=1`, `treeGroupHits=0`, collision node `709812:collision`.
- The other five control samples at +2,+6,+12,+18,+24 m are `NO_REPRESENTED_HIT` and nav-unblocked. A single ROAD-labelled collision at +30 m **does not locate the road's first physical edge, prove continuous road coverage or establish traffic/parking exclusion**. It *does* validate a real GIANTS 1.24 positive physics callback and ROAD-group classification for **at least one represented object**.

**Preferred eastern edge 1:** Stations **35.50 m** and **106.49 m**, each sampled at depths `-2,2,6,12,18,24,30 m`. Twelve exterior boxes: **12/12 `NO_REPRESENTED_HIT`**, and all twelve sampled navigation points unblocked. At +30 m, both tested positions change from farmland **2** to **255**; at +2 through +24 m both remain parcel 2. This says nothing about the exact road shoulder; a road can be physically rendered without a matching queried collider, or lie between the chosen stations/depths, and the 0.9 m box is not an articulated vehicle envelope.

**Terrain cross-section:** Height is observed independently of physics hits:

| Edge 1 station | At -2m | +2m | +6m | +12m | +18m | +24m | +30m | Rise +2 to +24 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| `s=35.50m` | 45.70 | 46.15 | 46.68 | 47.67 | 49.07 | 49.99 | 50.01 | **+3.84m** |
| `s=106.49m` | 43.05 | 43.18 | 43.54 | 44.81 | 46.17 | 46.98 | 47.28 | **+3.80m** |

**Discovery — Terrain Ramp Profile:** both transverse sections show a **substantial change in elevation across the exterior strip**, which is invisible to a binary navigation-unblocked result. Height differences are measured; whether an actual TRANSIT-configured assembly can align or park on the slope requires separate vehicle geometry and ground-contact evidence. Notably the logged `terrainNormalY=6.00` at **all twenty** positions, while horizontal normal components vary. The returned normal triplets are **not unit-length**. Do not read them as normalized unit normals, grades or angles without validating the native scaling/normalization convention. The independent height sequence remains a valid observed terrain profile.

## Forced close / failure attribution

The successful Riverbend `PHYSICAL_MARGIN_SURVEY_FINISHED` precedes `quit savegame` at **16:04:01.272** by about twelve seconds. Then native job-stop events are non-success (consistent with quitting), followed by **`Application restart (soft restart)`** at **16:04:01.599**. The captured file ends at **16:04:02.503** during the ensuing mod enumeration; no third loaded map/probe appears.

There is **no logged Lua exception** or physics-query failure associated with OMW in the Riverbend session. The ending is consistent with a manual force-close *during the post-savegame soft restart*, but the text log does **not establish why the client did not complete the restart**. Do not claim either that OMW crashed GIANTS or that the absence of an exception proves no hang/deadlock.

**Non-OMW map errors:** the Mindenerwald session reported `Farmland-Id '114' not defined` and four FieldManager pixel-touch errors (fields 52, 55, 67, 68); they arose during loading **before** the 0.5.5.3 survey and are source-map data errors, not this new probe's runtime exceptions. The first session also saw a separate ongoing `HOLD_RELOCATE_STARTED` single-worker operation, cancelled when the savegame was quit; do not count this as physical-margin movement.

## Falsification verdict and next step

| Hypothesis | Current status |
| --- | --- |
| Native 1.24 physics callback and a positive `ROAD` group witness exist | **SUPPORTED for one control sample on Riverbend** |
| Sparse collision boxes / unblocked costmap infer physical exterior margin width | **NOT SUPPORTED** |
| Riverbend preferred edge has a terrain elevation change across 2–24 m | **SUPPORTED at two chosen sections** |
| Continuous road boundary / lateral clearance measurable from these sources | **WAITING_FOR_EVIDENCE** |
| Field 77 edge 9 / hedge control produces native physics witnesses | **NOT TESTED due to retained Farmland 2 selector** |
| OMW 0.5.5.3 caused the reported force-close | **UNDETERMINED; no supporting logged failure** |

**Minimum next action:** rerun **only Mindenerwald Field 77**, with `spatialFarmlandId` **absent** and DIAGNOSTICS enabled; wait for `PHYSICAL_MARGIN_SURVEY_FINISHED` or `PHYSICAL_MARGIN_UNAVAILABLE` and supply the log. Do not create a new build, widen the physics scan or introduce settlement Control based on these observations. After that, compare the known hedge and preferred south edge with the Riverbend data before deciding what physical boundary evidence is still missing.

**Architecture/Specification disposition:** existing [Exterior Margin Profile](../../architecture/EXTERIOR_MARGIN_PROFILE.md), [source-review plan](PHYSICAL_MARGIN_CONSTRAINT_SOURCE_REVIEW.md) and [Farm Spatial Context Observation Spec](../../spec/FARM_SPATIAL_CONTEXT_OBSERVATION.md) remain valid. This report **updates evidence only**. The running TEST `0.5.5.3` and accepted request-only Completion TRANSIT remain unchanged.
