# Exterior Margin Profile — Evidence for Edge-Aligned Settlement

## Status and purpose

**Status: proposed architectural observation/assessment boundary, grounded in two 11 October 2026 GIANTS Reality surveys and the owner's in-game map judgements. No physical Settlement Control capability or executable parking route is authorised.**

[Completion-Triggered Terminal Egress](COMPLETION_TRIGGERED_TERMINAL_EGRESS.md) seeks to finish with an entire completed, TRANSIT-configured Physical Assembly safely **outside** the source field, without obstructing another active worker, productive field or road. An attractive polygon edge, or a set of individually navigable exterior points, does not establish that outcome.

**Exterior Margin Profile** names the *spatial evidence about the exterior of a registered field boundary, indexed continuously along that boundary*. Its purpose is to expose where an exterior corridor **may** exist and what is known, blocked or unresolved there. It is not a destination, route, rank, movement instruction, reservation or proof that a particular assembly can park.

The profile describes **world space**. A separate **Settlement Corridor Assessment** must determine whether an actual articulated Physical Assembly can use that space. This separation prevents implementation convenience or nominal vehicle-root navigation from redefining what “off-field settlement” means.

This document discovers concepts and evidence requirements. A new Specification Jurisdiction and implementation-facing sampling contract are **deferred** until the evidence sources and their limitations have been experimentally assessed. The archived [Farm Spatial Context Observation Specification](../docs/research/retired/spec__FARM_SPATIAL_CONTEXT_OBSERVATION.md) documents the historical **diagnostic-only, discrete** probe, now retired from runtime.

## Spatial reference — Edge Station and Outward Depth

Retain the actual ordered polygon and its **two-consecutive-vertex Edge Segments** from GIANTS' registered source field, not farmland parcel boundaries or a screenshot label.

For a nominated Edge Segment, describe observations in a local frame:

- **Edge station `s`** — longitudinal distance along that segment, measured from its native first vertex toward its next vertex, in metres. Keep the original edge ID, both endpoints, direction and source polygon identity.
- **Outward depth `d`** — distance from the source polygon boundary towards its geometrically exterior side at that station, in metres. Exterior orientation must be verified. For irregular/concave polygons, an apparently outward point can re-enter the source polygon; such depth is **not available exterior space**.
- **Along-edge continuity** — which consecutive stations can genuinely be connected by space that remains valid *between* measurements. A discrete sample at `d=6 m` does not certify the unmeasured region between `d=2 m` and `d=12 m`, or the longitudinal gap between stations.
- **Along-edge travel direction** — either direction along the same geometric edge may prove suitable, depending on how the assembly can approach and straighten. The native vertex order does **not** prescribe direction of travel. Crossing a corner to a subsequent edge is a separate continuity/heading question, not automatic concatenation.

A profile may retain multiple separated intervals and competing constraints. It must not collapse them into one smallest global field gap, widest-looking margin, or a single “clear/not clear” boolean.

## Evidence the profile needs to preserve

| Evidence dimension | What must be distinguishable | Why it matters / known limitations |
| --- | --- | --- |
| **Identity and provenance** | Map/mission; registered field ID; displayed farmland ID separately; source polygon identity; edge index and endpoints; observation time and freshness; source and confidence/unknown state | Riverbend displayed **Farmland 2** resolves to registered **Field 29**, disproving interchangeability of identifiers. Geometry can change or be captured in a different mission. |
| **Longitudinal support** | Edge length, straightness/heading variation, usable interval start/end, corner influence, whether both travel directions remain possible, gaps in coverage | Total edge length is not a guaranteed straight forward run-out; a long edge can contain multiple disconnected usable portions. |
| **Depth and lateral constraints** | From the source boundary at each relevant `s`, what restricts outward space, its approximate position and type; whether the intervening lateral band has positive coverage rather than isolated points | A 3 m strip might hold a parallel stationary assembly but not an oblique entry. Needed depth depends on which phase is assessed. |
| **Other productive fields** | Actual neighbouring **registered field polygon** crossings and gaps, not only the neighbour's farmland parcel ID; where the first neighbouring field begins along the edge | Field 77 edge 9 can reach another registered field within 12 m. The minimum reported boundary gap, 6.88 m, is a **segment-wide minimum**, not a continuous width measurement. |
| **Road, railway and traffic space** | Whether a road or rail corridor lies between fields; its occupied/required exclusion width, not merely a nearby spline sample; missing road-network representation | Riverbend edge 1 has an apparently deep gap to Field 3 but an intervening road. Both probe runs reported truncated or incomplete road observations. Road surface cannot be treated as spare parking space. |
| **Physical obstacles and terrain** | Hedges, trees, fences, posts, ditches, slopes, collision volumes and other persistent hazards; obstruction positions and continuity; unsupported or missing evidence | Both maps have visible vegetation not reliably reflected in sparse pointwise GIANTS navigation blocking. Zero blocked samples does not mean collision-free. |
| **Land access and occupancy constraints** | Source-farm land access, farmland ownership and registered field membership recorded **independently**; permission/eligibility to occupy the relevant strip remains unproved unless separately supported | Every sampled Riverbend position returned `accessAllowed`, including unowned land. Access does not grant authority to park on a road or another worker's work area. |
| **Dynamic availability — separate assessment overlay** | Current other-worker presence, player vehicles, existing commitments and potential demand intersecting approach, run-out or terminal occupancy | **Not a reusable physical-margin property.** A completed worker may still need to align inside the field without displacing other active workers. Bind this *current* operational evidence during Settlement Corridor Assessment, not into static edge geometry. |
| **Evidence quality** | Sample spacing, coverage, omissions, truncation, unknown physical extent, stale data and contradictory observations; explicit named reason whenever an interval cannot be established | The current `+2/+6/+12 m` probe is point-based and truncated for road splines. Unknown is not “clear” and does not support a positive corridor finding. |

**The first limiting feature matters, not merely the next field.** In particular, the exterior cross-section can be:

```text
source FIELD boundary  | grass margin | ROAD exclusion | further margin | next FIELD
                         candidate       not space for parking
```

The far side of the road cannot enlarge the candidate corridor on the near side.

### Proposed profile output, without a prescribed algorithm

A profile should be able to express, in the original field-coordinate frame, **several along-edge intervals**, each retaining evidence-backed exterior depth bands or **unresolved** depth bands. For each limiting boundary, preserve *what* it is (field, road, solid object, terrain, operational occupancy), *where* it is supported, *how* it was observed, and *where coverage stops*. This is an **evidence representation**, not a new numeric width threshold, map raster, steering plan or product runtime structure.

No positive continuous-width claim is justified by the current surveys. Their measured values remain **point samples**, polygon nearest distances, access samples and partial spline observations.

**Profile boundary:** The reusable world-space profile describes static or slowly changing physical evidence **with provenance and freshness**. Current active-worker demand and per-assembly swept motion belong to the downstream Settlement Corridor Assessment; they must not be mistaken for stable terrain features. This distinction does not make map-derived evidence timeless or automatically safe to cache.

## Distinct downstream responsibility — Settlement Corridor Assessment

A **Settlement Corridor** is a *possible connected journey plus final occupied region* for one actual assembly. The profile alone cannot establish one. Assessment must consider **all coupled components** of the actual Physical Assembly, not only the tractor root or nominal implement width. **TRANSIT is requested, not verified or used as a readiness gate**; the currently observed nominal footprint and uncertainty about actual geometry must remain explicit. Assess the following three questions independently.

### 1. Approach Envelope — can the entire assembly reach and align?

An approach may occupy permitted, available space **inside the completed source field**. This owner-accepted option is particularly important when the exterior margin is narrow: perform most of the heading change inside the field, then cross shallowly. A deeper margin may allow more alignment after crossing. These are **conditions to assess**, not hard-coded parking modes.

Assessment needs the source pose/heading, component dimensions, articulation, swept path through turns and crossing, nearby physical obstacles and **other active workers' committed/potential demand**. It may find that neither approach is supported. “Completed source field” never means “exclusive manoeuvring authority over its interior.”

### 2. Run-Out Envelope — can it continue forward and straighten?

An unobstructed *forward traversal*, from the end of approach through the boundary crossing to the proposed final stop, must be long enough for the actual assembly to straighten and settle. This requirement depends on articulation, steering response, initial heading and available stopping/control evidence. The run-out may start inside the field, but its final portion and stopped occupancy must be beyond the boundary.

A candidate edge's total length, a nominal root-centreline trajectory or a universally chosen number of metres is not proof of a feasible run-out. Both **along-edge directions** can require separate feasibility assessment.

### 3. Terminal Envelope — will the whole assembly finish safely outside?

The **entire stationary Physical Assembly**, including trailing/folded equipment and its actual final articulated configuration, must lie beyond the source field polygon and clear of neighbouring productive fields, roads, terrain/obstacles and required active-worker space. The tractor root outside the polygon, accepted TRANSIT commands, a reached target coordinate, or a clean costmap point are **not terminal settlement evidence**.

The terminal footprint must remain compatible with continued normal GIANTS fieldwork while the assembly is parked; a destination cannot be judged solely by the instant of arrival.

### Assessment outcome and authority

A future assessor must be able to distinguish at least **SUPPORTED**, **UNSUPPORTED** and **WAITING_FOR_EVIDENCE** for each of approach, run-out and terminal occupancy, with an explicit reason and relevant current evidence. For example: terminal fit potentially supported but approach unresolved; road width unknown; dynamic worker demand conflicts with a plausible infield approach.

These describe **assessment results**, never autonomous permission to move. Separate positive post-completion Movement Control admission, revalidation, interruption, safe relinquishment and player communication remain outside this concept, under [Issue #476](https://github.com/bisdat/FS25_OuttaMyWay/issues/476). Do not treat this taxonomy as implemented product states.

## Specification Jurisdiction — Settlement Corridor Assessment

**Jurisdiction ID:** `SETTLEMENT_CORRIDOR_ASSESSMENT`  
**Primary Specification:** [Settlement Corridor Assessment](../spec/SETTLEMENT_CORRIDOR_ASSESSMENT.md)

The full Settlement Corridor Assessment remains an architectural responsibility. Current implemented participants are a **read-only, diagnostic, sampled nominal static pose screen** for the selected Physical Assembly and a **bounded continuous nominal rigid straight-sweep** of that same frozen member snapshot against registered field polygons. These do not establish a steerable approach, true physical run-out, whole-assembly terminal parking clearance or folding state; all three architectural outcomes remain `WAITING_FOR_EVIDENCE`. No Movement Control authority is admitted.

### TEST 0.5.5.4/0.5.5.5: Nominal Assembly Polygon Screen (not complete Assessment)

The existing GIANTS runtime already provides selected real member base-size rectangles and current articulated transforms through `PairTransitRegion.capture`. This is **nominal selected-instance evidence**, not a claim about achieved TRANSIT geometry; no fold-state verification is required or proposed. To move from independent map evidence to an actual assembly, a bounded read-only **Nominal Assembly Polygon Screen** now projects each member rectangle—freezing its current articulation—into hypothetical edge-parallel stationary poses at sampled stations/depths and both along-edge directions. It detects positive intersection with the source or other registered field polygons and rejects member envelopes extending beyond the nominated edge endpoints.

This *necessary-condition screen* may reject sampled placements or identify **polygon-nonintersecting hypothetical poses**, but it does not identify connected free space through an approach, straighten a hitch, exclude roads/hedges/ditches, protect current workers, or authorise a stop. In all cases, the actual architectural Approach, Run-Out and Terminal results remain **WAITING_FOR_EVIDENCE**. A positive count is neither a parking candidate nor an approved position; it cannot be reused by Control. See [Settlement Corridor Assessment Specification](../spec/SETTLEMENT_CORRIDOR_ASSESSMENT.md) and [TEST 0.5.5.4 Reality plan](../docs/research/ASSEMBLY_SETTLEMENT_NOMINAL_TEST.md).

### TEST 0.5.5.6: Nominal Straight-Sweep Witness (continuous polygon geometry only)

**Discovery — Nominal Straight-Sweep Witness.** A set of individually compatible stationary poses is **not** evidence that any pair can be connected without crossing another registered field. To test a stronger but still bounded proposition, form the **continuous convex swept hull** of each captured nominal member rectangle, translated rigidly forward along the selected field-edge tangent, from a polygon-compatible seed. This checks **every intermediate planar position**, not just discretely sampled start, middle and finish points. Source and neighbouring registered field-polygon intersection defeats the witness even when both endpoints are independently compatible.

The experiment chooses at most four static seed poses across **both tangent travel directions** (shallow depth and greatest available **forward** edge-endpoint headroom), caps travel to the same native edge, and reports a **conservative continuous polygon-only forward-distance lower bound** with an obstacle-limited bracket if the full span intersects a registered field. The earlier static example near Field 77 station 207.88 m was never a forward-run-out recommendation; the new direction-aware seed selection does not reuse that example as a route instruction.

A positive result establishes only this: *at the captured member dimensions and frozen articulation, a pure rigid straight translation of the complete nominal assembly snapshot over the measured distance does not intersect any represented registered source/other field polygon*. This is **not** physical corridor clearance or a validation of actual connected Settlement Corridor feasibility. Roads, railway, hedges, terrain, AI collision-map discordance, other live workers, changing hitch articulation, available steering/run-out and final off-field occupancy remain independent, unresolved requirements. In particular, it says nothing about whether the assembly can **approach the virtual starting pose** from its actual infield heading.

**Do not elevate nominal polygon distance to actual Run-Out SUPPORTED**, invent a required metre threshold, or admit parking Control. TRANSIT remains a request with no verification gate. See [the exact TEST 0.5.5.6 Specification](../docs/research/retired/spec__FARM_SPATIAL_CONTEXT_OBSERVATION.md) and [Reality falsification plan](../docs/research/ASSEMBLY_SETTLEMENT_NOMINAL_TEST.md).

## Two human-preferred falsification fixtures

| Fixture | Owner-preferred segment | Reality observation | Evidence not yet available |
| --- | --- | --- | --- |
| Mindenerwald **Field 77** | **Edge 9, southern side**, 230.97 m | `0.5.5.1`: 39/39 native navigation samples unblocked at each +2/+6/+12 m; other registered polygons enter at some +12 m sites; nearest reported other-field gap 6.88 m. Owner reports about 3–10 m margins locally, ample for parallel occupancy but not necessarily oblique approach. | Continuous near-side clear depth, along-edge connected length, non-point collision/terrain, actual infield approach and articulated swept traversal. |
| Riverbend Springs displayed **Farmland 2**, registered **Field 29** | **Edge 1, eastern side**, 141.99 m | `0.5.5.2`: 24/24 sites at +2/+6 m unblocked and inside farmland 2; 23/24 at +12 m unblocked, with one blocked near southern endpoint; roadside grass strip and intervening road shown in owner in-game map. | Actual grass-to-road exclusion depth, road representation/completeness, whole assembly movement geometry and dynamics. |

A good model should explain **both** human selections *without* inventing “Field 77” or “Riverbend” behaviour branches. A third map, assembly configuration or contrary visual observation must be able to falsify its generality.

## Evidence and implementation boundary

**Observed:** GIANTS field polygons, ordered vertices, farmland/ownership/access, sparse navigation-point costs and partially sampled AI road splines. Two in-game surveys and two owner-verified preferred edge choices.

**Interpreted, not measured:** continuous usable lateral width; road surface setbacks; hedge/ditch collision clearance; whether a particular articulated assembly can perform an approach and stop in the margin.

**Accepted architectural option:** use the completed field interior for alignment before a shallow crossing when required; preserve existing active worker rights and separate physical Control authority.

**Physical Constraint Witness source review:** [FS25 Native Physics/Terrain/Road Investigation](../docs/research/PHYSICAL_MARGIN_CONSTRAINT_SOURCE_REVIEW.md) identifies read-only collider and terrain queries that might positively witness obstacles or ditches. Its **Road Identity Gap** remains unresolved: road splines and their vehicle-width eligibility metadata cannot by themselves bound the occupied road surface. Those FS25 v1.20 source findings must be challenged in the user's v1.24 game before any positive continuous-width claim. No new runtime observation contract is admitted.

**Open discoveries, in order:** (1) real **physical outer-constraint** coverage (road, vegetation and terrain); (2) **actual** assembly approach and steering/articulation run-out against those constraints and other live workers, not merely the now-tested nominal rigid polygon sweep; (3) positive whole-assembly exterior terminal occupancy and interruption/handback. TRANSIT is separately **requested**, not verified or gated. Investigate physical evidence and Control admission separately.

**Source/Specification disposition:** The historical `FARM_SPATIAL_CONTEXT_OBSERVATION` research was **diagnostic and pointwise**, and is now retired. The separate `SETTLEMENT_CORRIDOR_ASSESSMENT` jurisdiction now implements a bounded **nominal static and straight-swept registered polygon** witness in TEST `0.5.5.6`; it does not declare real physical corridor continuity or Movement Control authority. Completion TRANSIT remains **request-only** and unaffected.

**Validation disposition:** The existing offline tests and TEST `0.5.5.1`/`0.5.5.2` runs demonstrate *observation acquisition*, not Approach/Run-Out/Terminal Assessment. Separate prospective validation scenarios are in [Exterior Margin Profile Investigation](../docs/research/EXTERIOR_MARGIN_PROFILE_VALIDATION.md).
