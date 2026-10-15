# Field 77 Farm Spatial Context — Screenshot Comparison Plan

## Reference

Annotated player screenshot supplied 11 October 2026: Field 77 is outlined in blue; roads across the **upper** image edge have X markings, and physical hedge protrusions on the **right** have X markings. The user is interested in continuous boundary segments defined by **two neighbouring polygon vertices**, particularly along left, right-lower and bottom sides.

**Status:** human visual fixture only. No world-coordinate control points are available from this image. Do not assert road distance, ownership, edge index, collision cost, or traversability from pixels.

## Source-backed hypotheses to falsify

| Reference observation | Diagnostic data to compare | Useful counterexample |
| --- | --- | --- |
| Blue boundary shape | `FARM_CONTEXT_FIELD` bounds/vertices and `FARM_CONTEXT_EDGE` vertex A/B chain | Polygon differs from screenshot or Field 77 identity is wrong |
| Road corridor at top | `FARM_CONTEXT_SIDE_SUMMARY` nearest sampled road spline; edges labelled by world X/Z geometry | Top road has no nearby AI road spline, or map image orientation disagrees with presumed world axes |
| Hedge protrusions on right | `FIELD_EDGE_OUTSIDE_SAMPLE` exterior `navBlockedIntervalsM`, at +2/+6/+12m | Road/nav costmap regards visible hedge as unblocked |
| Left and bottom margins | Farmland IDs, owners, access, neighbour-field membership and native block samples | Apparently open land has no accessible parcel or reports native blocking |
| Two adjacent polygon vertices | `FARM_CONTEXT_EDGE` `edge`, `nextVertex`, `ax,az,bx,bz`, `lengthM` | More vertices than the screenshot suggests; curved physical boundaries not represented by a straight polygon segment |

The probe's `X_MIN/X_MAX/Z_MIN/Z_MAX` side labels are **coordinate descriptions**, not asserted screen directions. Cross-check the polygon shape and camera/map orientation before interpreting `Z_MIN` as the screenshot's upper road.

## How to collect one run

1. Launch the Field 77 save with TEST `0.5.5.1`, global Enabled=true, and `modSettings/FS25_OuttaMyWay/diagnostics.xml` set to `diagnostics=true` (or the existing diagnostics flag syntax).
2. Let the map finish loading. The probe runs once after approximately 6 seconds, conditional on available GIANTS field/map data, without requiring a worker to complete a job.
3. Preserve the complete `log.txt` and this screenshot for comparison. Locate `[FARM_SPATIAL_CONTEXT]` entries, beginning with `FARM_CONTEXT_FIELD` and ending at `FARM_CONTEXT_SURVEY_FINISHED`.
4. Compare each indexed `FARM_CONTEXT_EDGE` endpoint pair against the polygon outline; then inspect `FARM_CONTEXT_SIDE_SUMMARY` and the exterior sample blocked intervals for the top/right/left/bottom references.
5. Report any `FARM_CONTEXT_SURVEY_UNAVAILABLE`, `navUnknown`, `roadTruncated`, `neighborRegistryTruncated`, `sampleTruncated`, or `sourcePolygonReentry` as unresolved. An unblocked cell is a **native navigation judgement at one position**, never parking proof.

## Expected learning

The experiment should establish whether native registered field edges align with the player's visual Field 77; whether a top road is covered by the native AI spline representation; whether right hedge protrusions are represented as navigation blocking; and whether the exterior of the remaining boundary edges belongs to different farmland parcels.

A mismatch improves the architecture by identifying missing physical/world concepts. **No settlement location is selected in this experiment.**

## Authority

[Architecture](../retired/architecture__FARM_SPATIAL_CONTEXT_OBSERVATION.txt); [Specification](retired/spec__FARM_SPATIAL_CONTEXT_OBSERVATION.txt); [Source API clues, #420](https://github.com/bisdat/FS25_OuttaMyWay/issues/420); [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476).

## GIANTS Reality evidence — Field 77, TEST 0.5.5.1 (11 October 2026)

**Input:** `log(20261011-115103).txt`, FS25 1.24.0.0, annotated Field 77 screenshot above. The map was `FS25_CliviosMindenerwald`. The read-only survey ran once at **12:50:24.838–.850**. `FARM_CONTEXT_SURVEY_FINISHED` reports 12 edges and **690 exterior samples** (230 sites × +2, +6, +12 m), `sampleTruncated=false`, `neighborRegistryTruncated=false`, `sourcePolygonReentry=0`. `sourceFarmOwner=1`; 84 other field polygons enumerated. 27 road splines were registered and read, with 89 near-field point samples; **`roadTruncated=true`**, so do not claim complete road evidence. No `navUnknown` across the 690 sample results.

**Polygon orientation established from consecutive endpoints and screenshot silhouette:** Edge 12 is the *upper* 173.63 m boundary. Edges 1–7 form the upper/right irregular portion; edge 8 is the 229.98 m lower-right boundary. Edge 9 is the 230.97 m *bottom*. Edges 10 (136.78 m) and 11 (334.91 m) form the *left*. This identification is geometric/visual, not a georeferenced registration. BBox X = -40.20…228.15 m; Z = -701.23…-207.44 m. The probe's side categories (`Z_MIN` etc.) are *nearest world-coordinate extrema*, not reliable screen-side labels for slanted edges.

| Visual reference | Observed segments and exterior evidence | Confidence/limits |
| --- | --- | --- |
| Upper road | Edge 12 nearest sampled AI road-spline point **5.46 m**; top-right edge 1 **6.51 m** | Consistent with visible road; spline-point distance is not road-edge distance, and road sampling was truncated |
| Upper-right hedges | Edge 2: at +2 m, **1/9 blocked** over along-edge **0.00–5.36 m**; at +6 m, **2/9 blocked** (5.36–10.72 m, 37.53–42.90 m). Edges 3–7 report no blocked points at sampled offsets | Sparse partial correspondence only. No object identity; could miss narrow protrusions or represent other obstacles. Not evidence that remaining hedge marks are collision-free |
| Lower right | Edge 8: at +2 m, **3/39 blocked**, 76.66–94.35 m along edge; at +6 m, **1/39 blocked**, 165.11–171.01 m; at +12 m **0/39 blocked**. Nearest other registered field: **78, minimum 6.51 m**. At +6 m, farmland 82 (32/39) and 65 (7/39), both owner 1; at +12 m, sampled locations enter registered Field 78 | Point navigation blocking is sparse; minimum inter-field gap is not a contiguous clearance corridor |
| Bottom | Edge 9: **0/39 blocked** at each offset; all +6/+12 m farmland samples are parcel **49**, owner 1. +12 m reaches registered Field 49 at some positions. Nearest other registered field is **66, minimum 6.88 m** (segment-wide minimum, may be near a corner) | Visually attractive but other field membership and full assembly footprint unresolved |
| Left | Edge 10: nearest registered Field 67 **4.65 m**; +6 m parcel 68, owner 1; +12 m includes registered Field 66. Edge 11: nearest Field 68 **2.97 m**; +6 m parcels 69/70, owner 1, and locations inside registered Fields 67/68. **0 navigation-blocked samples** throughout both edges at all offsets | Apparently grass/paddocks may belong to adjacent registered fields. Edge 11 road proximity **6.22 m** is a segment-wide minimum plausibly from its *upper road junction*, not evidence of road along the whole left edge |

**Additional cross-checks:** For every field-edge offset the probe evaluated, `accessDenied=0`. On upper edge 12, the +6 m strip is farmland **255**, owner **0**, yet `accessAllowed=29/29` for source farm owner 1. **Land access is not parking permission**; ownership of a parcel and membership of a registered productive field are also distinct. `farmlandIds=77` in exterior samples names the **farmland parcel**, not evidence that a point remains inside Field Polygon 77.

**Map discrepancy:** Native `FieldManager` logged boundary mismatches: registered Field 67 (centred in farmland 69) touched farmland 77 by **6 pixels**; registered Field 68 (centred in farmland 70) touched farmland 77 by **12 pixels**. These are relevant to the surveyed *left-side* neighbourhood. At 2 m offsets, mixed farmland IDs should not be overinterpreted as physically exact boundaries.

**Result:** **PASS for passive data acquisition and initial polygon/road correspondence; NOT a settlement-space clearance PASS.** Only seven of 690 sample measurements have `navBlocked=true` (4 at +2 m, 3 at +6 m, none at +12 m); this sparse classification does not adequately explain all annotated hedge protrusions. No two-vertex Edge Segment has yet been shown to offer a **continuous, collision-free, whole-assembly occupancy strip**. In particular, Field 77's left/bottom/right-lower margins can approach or enter neighbouring registered fields within 6–12 m.

**Next observation question:** What is the *along-edge continuous free-space interval* and distance to the first other field/physical obstacle at each edge station, rather than the segment's single minimum neighbouring-field gap and aggregate IDs? Investigate road/hedge native collision evidence independently before any Settlement Assessment. No change to Completion TRANSIT or other Control is justified by this survey.

**Concurrent unrelated OMW behaviour:** Shortly after surveying, at 12:50:26–.39, an existing Hold & Relocate episode ran and reported `NATIVE_RESTART_ACCEPTED`; native stop reason `nil` was classified `successClass=false`. This is not evidence that the spatial survey commanded movement or caused the recovery.

## Owner's in-game map update — southern preference and vertex indexing (11 October 2026)

The owner supplied a higher-quality FS25 in-game map of displayed **Field/Farmland 77** with visible neighbouring areas labelled **68, 69, 70** to the left, a road across the top and a green exterior band across the bottom. The owner explicitly prefers the **southernmost exterior margin** for parallel parking and referred to it as "edge 10".

**Numbering check against recorded GIANTS coordinates:** In the TEST `0.5.5.1` diagnostic ordered-vertex sequence, the south-facing near-horizontal edge is **probe edge 9**, from `(X=228.15,Z=-243.04)` to `(X=-0.06,Z=-207.44)`, length **230.97 m**, local outward normal `(+0.15,+0.99)`. Probe **edge 10** continues from the latter southwest endpoint to `(X=-10.56,Z=-343.82)`, length **136.78 m**, facing west (outward `(-1.00,+0.08)`). Probe **edge 11** then runs the upper western boundary. Edge indices are therefore *geometry-registration labels*, not visual map labels.

**Owner confirmation (11 October 2026):** The preferred *southernmost* strip is **probe edge 9**. The earlier reference to edge 10 was a numbering mistake and is superseded. Retain GIANTS' original ordered polygon indexing; edge 10 is the lower-left boundary and is **not** the nominated settlement reference.

**Existing empirical cross-check:** Probe edge 9 has **39/39 unblocked navigation-point samples at each +2/+6/+12 m offset**. At +6/+12 m the sampled farmland parcel is **49** with owner **1** (native farmland ID, not necessarily displayed Field 49). At +12 m some stations also lie inside a *different registered field polygon*. Nearest other field boundary across edge 9 is **6.88 m**, a segment-wide minimum that may be near a corner. The map does not georeference the *usable* strip width and gives no full-envelope or road clearance certificate.

**Architectural significance:** The owner corroborates the southern margin as a first human-preferred **Edge-Aligned Settlement** investigation fixture, parallel to Riverbend's eastern edge 1. Keep separate the player's visual boundary names, the GIANTS native ordered `edge` index, the registered `field` ID and `farmlandId`. No parking permission or movement is admitted by the new screenshot.
