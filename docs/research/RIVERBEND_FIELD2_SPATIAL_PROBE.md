# Riverbend Springs — Farmland 2, TS004 Cross-Map Spatial Probe

## Reference and purpose

Owner's 11 October 2026 aerial screenshot of **Riverbend Springs / TS004**. The GIANTS Field Info overlay explicitly reports **Farmland 2**. The visible field outline is irregular with rounded/oblique corners. This second map is a deliberate challenge to the Field 77 observation findings, **not** approval to select a parking edge.

Important identity contract: `Farmland 2` as shown by Field Info is **not proof** that the native registered agricultural polygon has field ID 2. The `0.5.5.2` diagnostics selector resolves **one** field by sampled native farmland identity. If zero or multiple registered fields match, it reports unavailable/ambiguous evidence rather than surveying an arbitrary field.

## Screenshot-derived observations (non-georeferenced)

- Northern side: curved grass/hedge margin with a road beyond it; northwest merges with a farm access area.
- Eastern side: grass verge and road/track extending around a junction. A railway runs farther to the east; do not equate railway with an AI-road spline.
- Southern/southwestern side: a broad green margin with vegetation and a road visible farther outside, especially at the southwest.
- Western side: vegetation, shaded ground, farm access road/track and boundaries shaped differently from Field 77's nearly straight left edge.
- The nearby road corridor occupies multiple sides, unlike Field 77's conspicuous top roadside. There are no user-supplied measurements of width, passability or legal parking permissions.
- TS004's workers may be active in the image; their presence does not prove a settlement location for a completed assembly.

Do not derive compass direction, segment indices, native obstacle identity, slope, or any measurable distance from image pixels alone.

## Next GIANTS Reality run

Use TEST `0.5.5.2` from [PR #482](https://github.com/bisdat/FS25_OuttaMyWay/pull/482).

In the existing engineering-only file `modSettings/FS25_OuttaMyWay/diagnostics.xml`, use:

```xml
<outtaMyWayDiagnostics enabled="true" spatialFarmlandId="2" />
```

The supported player Configuration does **not** change. The special value is a diagnostic selector only, loaded once at mod startup. Keep global Enabled=true. Once Riverbend Springs finishes loading, the one-shot probe should run approximately 6 seconds later. No AI work or completion is needed.

Expected success: `FARM_CONTEXT_FIELD selectedFarmlandId=2 targetSelection=FARMLAND resolvedFarmlandId=2`; note the actual `field` ID **may not equal 2**. Observe `FARM_CONTEXT_EDGE`, `FIELD_EDGE_OUTSIDE_SAMPLE`, `FARM_CONTEXT_SIDE_SUMMARY`, and `FARM_CONTEXT_SURVEY_FINISHED`. `FARM_CONTEXT_SURVEY_UNAVAILABLE` with `NO_FIELD_FOR_SELECTED_FARMLAND` or `FARMLAND_CONTAINS_MULTIPLE_FIELDS` is a useful identity counterexample, not a reason to select an arbitrary polygon.

## Cross-map discriminators

| Question | Field 77 evidence | Riverbend TS004 challenge |
| --- | --- | --- |
| Consecutive edge topology | 12 registered polygon edges | Do GIANTS polygon segments follow visibly curved/oblique boundaries? |
| Road knowledge | Spline nearby the upper boundary; spline observations truncated | Do splines register all northern/eastern tracks? Is railway excluded as expected? |
| Exterior physical blocking | Sparse blocking at +2/+6 m; visible right hedges not fully explained | Do trees/vegetation/road structures register as blocked, and at what offsets? |
| Neighbour fields | Other registered fields intrude by 6–12 m | Is exterior space primarily access land/roads rather than neighbouring fields? |
| Candidate assessment | Field 77 edge 9 preferred by owner for parallel tractor settlement | Which Riverbend edge *would* the owner prefer? Do not assume from map appearance |

For each actual edge, compare native field ID, endpoints, length, exterior farmland IDs/access and nav blocking distributions with the screenshot. A segment-wide minimum proximity to a road spline cannot distinguish a long roadside parallel run from a short meeting at one corner.

## Architectural status

A Field Edge Segment is an observation unit connecting **consecutive polygon vertices**. **Edge-Aligned Settlement** is a plausible *hypothesis*, not yet a Control capability. A region able to contain a complete folded Physical Assembly needs continuous clearance in length and depth, static obstacles and other fields, road exclusion and actual movement feasibility. This experiment only observes.

Original Field 77 baseline: [Field 77 Spatial Probe](FIELD77_SPATIAL_PROBE.md). Current Architecture: [Farm Spatial Context Observation](retired/architecture__FARM_SPATIAL_CONTEXT_OBSERVATION.txt).

## GIANTS Reality — Riverbend Springs TS004, TEST 0.5.5.2 (11 October 2026)

**Input:** player's `log(20261011-122200).txt` and the overhead screenshot of Riverbend Springs with `FIELD INFO: Farmland 2`. Runtime FS25 `1.24.0.0`; base map `data/maps/mapUS/mapUS.i3d`. OuttaMyWay `0.5.5.2` started at 13:20:51.825. One-shot survey emitted at **13:21:21.305–13:21:21.312** without Lua error.

### Field/farmland identity validation

`FARM_CONTEXT_FIELD` confirms `targetSelection=FARMLAND`, `selectedFarmlandId=2`, **`field=29`**, `resolvedFarmlandId=2`, `sourceFarmOwner=1`. Thus selected Farmland 2 is **not** GIANTS Field 2 on this map: the separate identities are an experimentally validated necessity, not implementation ornament. The field has **14 registered polygon edges**, BBox X `-979.42…-849.01` (130.41 m), Z `117.04…304.13` (187.09 m). `neighborFieldCount=76`; `neighborRegistryTruncated=false`. 14 consecutive edge vectors trace the screenshot's irregular/rounded crop boundary.

**Native road evidence limitation:** 301 spline entries enumerated; 300 considered valid before `MAX_ROAD_SPLINES=300` stopped the lookup, with 234 nearby sampled spline points; **`roadTruncated=true`**, `roadReadFailures=0`. Consequently measured nearest road-spline *sample* distances are provisional and can be greater than the true nearest road-spline distance. Spline distance is not physical road-edge distance. The probe cannot distinguish railway splines, road centreline splines or unrepresented roads without further evidence.

### Edge correspondence and measurements

Derived from the ordered world X/Z vertices and screenshot silhouette. Edge-to-screen mapping is a qualitative comparison, not a surveyed image calibration.

| Screenshot side | Consecutive polygon edges | Strongest geometric segment | Nearest sampled road point (m) | Blocked native samples (+2/+6/+12 m) | Farmland / surrounding evidence |
| --- | --- | --- | ---: | --- | --- |
| East / right (road parallel) | 1–4 | **Edge 1 = 141.99 m** | **11.61** (on short edge 4); edge 1 itself **26.84** | **1 at edge 1, +12 m**, first 5.92 m of segment | Up to +6 m all sampled points in farmland 2; at +12 m edges 3–4 reach unowned farmland 255 |
| North / top (road) | 5–8 | **Edge 7 = 59.99 m** | **7.26** (edge 7) | **0 of 60** across offsets | At +12 m all 20 north-side samples fall in farmland 255 (owner 0); edge 7 already has 6/10 unowned at +6 m |
| West / left (vegetation and tracks) | 9–12 | **Edge 10 = 119.24 m** | **29.16** (edge 9); edge 10 **34.77** | **1 at edge 12, +6 m**, 5.40–10.79 m along that short edge | Edge 10 remains farmland 2 throughout +2/+6 m; 15/20 +12 m samples are unowned farmland 255. Point samples on edge 10 have **zero native blocking** |
| South / bottom (vegetation / road farther out) | 13–14 | **Edge 14 = 58.80 m** | **27.57** (edge 14) | **3**: edge 13 +6 m (1); edge 14 +12 m (2) | Edge 14 has farmland 2 throughout +2/+6 m; 3/10 +12 m samples unowned; southwest hedge/road physical clearance unresolved |

Side correspondence note: edge 1 runs down the right-hand border; edges 2–6 round the upper-right corner toward the north; edge 7 is the main northern straight; edges 8–9 round the northwest; edge 10 is the main western straight; edges 11–13 round the southwest; edge 14 closes the bottom to edge 1. "Nearest sampled road point" for a group may come from a short corner edge and MUST NOT be generalized over a whole side.

**Native samples:** 94 exterior sample sites × offsets 2, 6 and 12 m = **282** evaluations. `navBlocked=5`, `navUnblocked=277`, `navUnknown=0`; `sourcePolygonReentry=0`; `accessAllowed=282`, `accessDenied=0`. No sampled position lies inside another registered field at any offset: **`neighborFieldIds=none`** for all 42 edge/offset reports. Every registered neighbouring field is at least **36.74 m** from an observed edge (Field 30 nearest), which is an important contrast with Field 77's near-adjacent productive fields. `sampleTruncated=false`.

**Unowned / road ambiguity:** At north edge 7, +12 m samples have `farmlandIds=255:10`, `ownerIds=0:10` while `accessAllowed=10`. Across the complete survey **58 samples** have owner ID 0 (including 7 samples at +6 m and 51 samples at +12 m), yet every source-farm access check returns allowed. As on Field 77, **access permission != legal/safe parked occupancy**. The screenshot shows a road along the north and east; GIS/AI spline proximity supports the northern road but does not qualify a roadside position.

**Vegetation mismatch:** Along the visually vegetated west edge 10, all +2/+6/+12 m point samples are unblocked. Four of five blocked points occur around the southwestern edges 12–14 (two at +6 m, two at +12 m across 12–14, including the southwestern-to-bottom transition), and one occurs at the beginning of right edge 1 at +12 m. GIANTS native point navigation blocking thus **does not establish that all visible hedges, grass banks or railway hazards are represented**. The absence of a blocked point is not an occupancy certificate for the whole folded Assembly.

**Concurrent runtime:** `HOLD_RELOCATE_RUNTIME_ACTIVE` published at 13:21:15.335. Later, at 13:21:46.473 and .475, two non-success `NATIVE_FIELDWORK_JOB_STOPPED` observations occurred; neither is a native completion success signal. No Completion TRANSIT, egress or park authority was enacted by this survey.

### Cross-map finding

**PASS: Farmland-based field identification, ordered polygon discovery, read-only point acquisition and repeatable observation on a second map.**

**UNVALIDATED:** Native road network completeness (`roadTruncated=true`), distinction of railway vs road, physical collision envelope/terrain/ditches, parking permission and a continuous edge-aligned settlement strip. Field 77's dominant constraint was **other productive fields within roughly 3–10 m**, whereas this Riverbend example has **no other field within 12 m**; its risks are **road adjacency and physical vegetation/terrain**, which sparse native nav samples only partially characterize.

**New concept for architectural discussion: Exterior Margin Profile.** The longitudinal and outward-depth evidence of a given Edge Segment, preserving known field membership, farmland ownership/access, road proximity, native obstacles and explicit uncertainty. A single `nearestOtherFieldBoundaryM` cannot substitute for this profile; neither can a clean native costmap. This is a proposed observation concept, **not a settlement decision or movement permission**.

**Next architectural discussion:** Is Edge 10 (long, mostly source-owned, sampled-unblocked western margin) the human-preferred choice on this screenshot despite vegetation? Edge 14 (southern) is shorter, with blocking farther out, while northern edge 7 is adjacent to a verified road corridor and eastern edge 1 is also visibly roadside. Discuss Ground Truth before proposing any automated candidate selection. No new runtime change is warranted by these observations.

## Owner's in-game map correction — eastern strip between displayed Fields 2 and 3 (11 October 2026)

**New Ground Truth:** The owner supplied the in-game overhead farmland map, showing Riverbend's cropped Farmland 2 (registered GIANTS Field **29**), displayed Field 3 to its right, and the intervening road network. The owner's explicit human settlement choice is **the wide grass strip between displayed Fields 2 and 3**. The farm map provides materially better spatial orientation than the first elevated camera screenshot. This **reverses our earlier speculative preference for western edge 10**.

**Identity and edge correspondence:** The selected margin is on the **right/eastern side**, principally the long GIANTS **edge 1** (`ax=-898.15, az=304.13` → `bx=-849.01, bz=170.91`; **141.99 m**, outward vector ~`(+0.94,+0.35)`). Native field ID 29 is not the displayed farmland label 2. The pronounced grass margin must be distinguished from the **road that separates it from the land of displayed Field 3**. This is a three-part cross-section: *Field 2 crop boundary → adjacent green margin → road → Field 3*, rather than an uninterrupted strip extending all the way to Field 3.

**Edge 1 numeric verification from TEST 0.5.5.2:**
- `+2 m`: **24/24** samples are farmland 2, owner 1, access allowed, and native navigation unblocked.
- `+6 m`: **24/24** likewise farmland 2, owner 1, unblocked.
- `+12 m`: **24/24** still farmland 2, owner 1; **23/24** native navigation-unblocked, **1/24 blocked** in the first along-edge station (reported `0.00–5.92 m` from its first vertex, at the southern end in the map view).
- No sampled point is in a different registered field. Field 30's nearest registered boundary is **36.74 m** from edge 1. The nearest *sampled* AI road-spline point is **26.84 m**, with `roadTruncated=true` — therefore do **not** promote that value to a measured physical road setback or fully enumerated road distance.

**Contrast with rejected western edge 10:** All 20 western +6 m samples are inside source farmland 2 and unblocked, but by +12 m **15/20** are unowned farmland 255. The in-game map shows a road running close beside the western boundary, explaining why the previously inferred long "open" west edge was not the human-preferred parking location even though the native navigation samples were clear. Its 34.77 m road-spline sample distance is unreliable for *road exclusion* here, particularly under spline-list truncation.

**Discovery — Road-Bounded Exterior Margin:** A margin may have a large separation to the next **productive field** yet have its usable outer edge constrained by a road *inside that separation*. Settlement Assessment must not equate nearest-field separation, farmland access or an unblocked costmap point with usable verge depth. It needs the position/width of the intervening road and uninterrupted along-edge clearance. A road is a limiting boundary, not automatically a settlement surface.

**Revised interpretation:** **Edge 1 is the correct owner-nominated first candidate for further passive investigation**, with the middle portion more plausible than the corner-adjacent southern end because of the +12 m blocked station. This is human preference corroborated by native farmland and point-navigation evidence, **not** approval to park an actual articulated assembly. Avoid changing Control, GIANTS AI jobs or road occupancy authority on this evidence.
