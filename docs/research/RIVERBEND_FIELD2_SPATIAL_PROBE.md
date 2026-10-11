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

Original Field 77 baseline: [Field 77 Spatial Probe](FIELD77_SPATIAL_PROBE.md). Current Architecture: [Farm Spatial Context Observation](../../architecture/FARM_SPATIAL_CONTEXT_OBSERVATION.md).
