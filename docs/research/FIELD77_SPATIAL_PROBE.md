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

[Architecture](../../architecture/FARM_SPATIAL_CONTEXT_OBSERVATION.md); [Specification](../../spec/FARM_SPATIAL_CONTEXT_OBSERVATION.md); [Source API clues, #420](https://github.com/bisdat/FS25_OuttaMyWay/issues/420); [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476).
