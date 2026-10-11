# Exterior Margin Profile — Evidence for Edge-Aligned Settlement

## Status and purpose

**Status: proposed architectural observation/assessment boundary, grounded in two 11 October 2026 GIANTS Reality surveys and the owner's in-game map judgements. No physical Settlement Control capability or executable parking route is authorised.**

[Completion-Triggered Terminal Egress](COMPLETION_TRIGGERED_TERMINAL_EGRESS.md) seeks to finish with an entire completed, TRANSIT-configured Physical Assembly safely **outside** the source field, without obstructing another active worker, productive field or road. An attractive polygon edge, or a set of individually navigable exterior points, does not establish that outcome.

**Exterior Margin Profile** names the *spatial evidence about the exterior of a registered field boundary, indexed continuously along that boundary*. Its purpose is to expose where an exterior corridor **may** exist and what is known, blocked or unresolved there. It is not a destination, route, rank, movement instruction, reservation or proof that a particular assembly can park.

The profile describes **world space**. A separate **Settlement Corridor Assessment** must determine whether an actual articulated Physical Assembly can use that space. This separation prevents implementation convenience or nominal vehicle-root navigation from redefining what “off-field settlement” means.

This document discovers concepts and evidence requirements. A new Specification Jurisdiction and implementation-facing sampling contract are **deferred** until the evidence sources and their limitations have been experimentally assessed. The active [Farm Spatial Context Observation Specification](../spec/FARM_SPATIAL_CONTEXT_OBSERVATION.md) still defines the existing **diagnostic-only, discrete** probe.

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

A **Settlement Corridor** is a *possible connected journey plus final occupied region* for one actual assembly. The profile alone cannot establish one. Assessment must consider the assembly as **all coupled components** in its verified TRANSIT state, not only the tractor root or nominal implement width, and independently answer three questions.

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

**Open discoveries, in order:** (1) reliable physical **outer constraint** of the near-field strip, especially road/obstacle boundaries; (2) continuous along-edge coverage, rather than isolated clear sample points; (3) actual assembly TRANSIT footprint and forward-swept feasibility; (4) positive terminal occupancy verification. Investigate each independently before composing an actuator.

**Source/Specification disposition:** No script change. The existing `FARM_SPATIAL_CONTEXT_OBSERVATION` jurisdiction remains intentionally **diagnostic and pointwise**; it is neither expanded nor claimed to provide continuous proof. The present Completion TRANSIT Specification remains **request-only** and authorises no movement. A new implementation-facing contract is premature until physical-constraint observation feasibility has been challenged in GIANTS Reality.

**Validation disposition:** The existing offline tests and TEST `0.5.5.1`/`0.5.5.2` runs demonstrate *observation acquisition*, not Approach/Run-Out/Terminal Assessment. Separate prospective validation scenarios are in [Exterior Margin Profile Investigation](../docs/research/EXTERIOR_MARGIN_PROFILE_VALIDATION.md).
