# Physical Margin Constraints — FS25 Native Source Review

**Issue:** [#476 Completion-Triggered Terminal Egress](https://github.com/bisdat/FS25_OuttaMyWay/issues/476) / [#420 Native API Investigation](https://github.com/bisdat/FS25_OuttaMyWay/issues/420)  
**Date:** 11 October 2026  
**Status:** **Source findings with bounded TEST 0.5.5.3 diagnostic implementation; physics/terrain semantics NOT YET validated by user in-game Reality.**

## Question and bounded sources

Can the GIANTS FS25 engine provide *physical outer-constraint evidence* for an exterior strip along a completed field's boundary—especially **road surfaces, hedges/fences, ditches, terrain shape**—that the existing Farm Spatial Context diagnostic costmap and polygon survey do not observe reliably?

This review uses:

- Public **GIANTS Developer Network FS25 LUADOC** for **engine/script v1.20.0.0**, with linked definitions below;
- the public FS25 v1.20 `AISystem` implementation, in particular its AI spline registration, physics interference diagnostic and collision filters; and
- existing **FS25 1.24.0.0 Reality** logged on diagnostic TEST `0.5.5.1` (Mindenerwald, Field 77) and `0.5.5.2` (Riverbend Springs, registered Field 29).

**Version distinction:** Available documented signatures are from **v1.20**. The user's installed engine is **FS25 1.24**. We have **not** verified or invoked the new candidate physics/terrain APIs in that runtime. A callable function in source is a hypothesis to test, not a proven safe witness of full vehicle clearance.

Ground Truth: [Field 77 log and owner map](FIELD77_SPATIAL_PROBE.md), [Riverbend log and owner map](RIVERBEND_FIELD2_SPATIAL_PROBE.md). Governing conceptual boundary: [Exterior Margin Profile](../../architecture/EXTERIOR_MARGIN_PROFILE.md).

## Source findings — candidate read-only evidence

| Surface and source | Positive evidence it might supply | Limits and source-specific cautions | Status |
| --- | --- | --- | --- |
| `overlapBox(x,y,z,rx,ry,rz,ex,ey,ez,callbackName,target,collisionMask,includeDynamics,includeKinematics,includeStatics,exactTest)` — [FS25 physics](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=19&function=496&version=engine) | Hit callbacks for rigid-body shapes intersecting an *oriented volume*; can distinguish a fence or tree collider from a clear navigation-map point **when the map actually has an appropriate collision shape and mask**. | Synchronous/blocking; `exactTest=true` tests precise shape rather than AABB (costlier); callback returns a boolean to continue. Mask and static/kinematic/dynamic categories must be known. **No hit is not a certificate** when geometry has no collider or is omitted by filters. A box is not the complete articulated assembly. | Public documented API; **untried in 1.24** |
| `raycastAll(...)` / `raycastClosest(...)` — [FS25 all-hits ray](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=19&function=512&version=engine), [closest ray](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=19&function=516&version=engine) | Location, normal, distance and shape identity at an intercepted collider along a bounded ray. Could distinguish collision-bearing hedges and raised objects from flat ground. | A line does not establish lateral or vertical clearance; downward rays can hit terrain before objects unless appropriately filtered; masks and missing colliders produce false apparent negatives. Not a road-surface classifier. | Public documented API; **untried in 1.24** |
| `sweepBoxVector(center,rotation,halfExtents,direction,maxDistance,...)` — [FS25 swept-box query](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=19&function=561&version=engine) | First/all intersection along a **straight translation of a box**, stronger evidence for a bounded forward volume than isolated point samples. | Synchronous/blocking physics query; callback returns collision shape. A *single rigid box translating straight* cannot establish compound articulated turning, steering stability, terrain-following, folding, wheel contact or final assembly pose; collision masks/omitted shapes remain limiting. It does **not** authorise movement. | Public documented API; **untried in 1.24** |
| `getTerrainHeightAtWorldPos` / `getTerrainNormalAtWorldPos` — [height](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=28&function=811&version=engine), [normal](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=28&function=814&version=engine) | Cross-section elevation and local surface orientation. Can support **terrain-profile discontinuity hypotheses**, such as a ditch/bank lying between two unblocked costmap points. | Terrain height/normal are not passability, wheel-ground contact, weight, implement-ground interaction or safe rollover evidence. A visually shallow ditch may be traversable, and discontinuities may be beneath a bridge/collision surface. Resolution and field-slope coverage matter. | Public documented API; **untried in 1.24 for margin** |
| `getTerrainAttributesAtWorldPos` — [FS25 terrain attributes](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=28&function=810&version=engine) | Exposes terrain attribute components at a position. | The public API defines *five returned values* but **no general, map-independent semantic mapping to “road surface” or “legal grass verge.”** It is not a reliable road-edge classifier without separately identified map data and validation. | API exists; **road semantics unproven** |
| `CollisionFlag.ROAD`, `AI_BLOCKING`, `getCollisionFilterMask` — [AISystem spline diagnostic](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=154&version=script), [filter query](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=19&function=459&version=engine) | The shipped AI source checks ROAD-group collision shapes and ignores those from its spline-interference warnings. A **positively identified ROAD-tagged hit** is a useful representation clue if that map uses such collision objects. | The source does not promise all roads, tracks or railways have ROAD colliders, or that all ROAD colliders follow their visible surface exactly. Filters distinguish physics membership, **not a traffic/parking permission policy**. Non-ROAD or no hit cannot prove absence of road. | Source clue; **coverage unproven** |
| `AISystem.roadSplines`, `addRoadSpline`, user attribute `maxWidth` — [AISystem native code](https://gdn.giants-software.com/documentation_scripting_fs25.php?category=3&class=154&version=script) | AI navigational spline identity, sampled position/direction and maximum **vehicle width accepted by the navigation path**. | **`maxWidth` is NOT the measured physical road width.** The source passes `maxWidth` to `addRoadsToVehicleNavigationMap` with navigation height and turning radius. Missing splines do not prove missing roads; the original probe has truncated spline observations on both maps. Do not turn spline width into parking/verge clearance. | Existing spline positions observed in TEST; interpretation of maxWidth is **source-only** |
| Existing registered field polygons and neighbouring field containment | Positively represented **productive field** boundary and whether tested locations enter a different GIANTS field. | It captures **productive** boundaries, not physical roads, ditches or collision obstacles. A min neighbour gap over a whole segment is not a continuous depth value. | TEST `0.5.5.1` and `0.5.5.2` Reality-confirmed |

### GIANTS' own physics query precedent

The FS25 `AISystem:consoleCommandAICheckSplineInterference` routine walks registered splines, builds oriented boxes, calls `overlapBox` (its own source uses `exactTest=true` in the current public v1.20 listing), filters certain vehicle/traffic/ROAD collision objects and reports possible obstruction objects. It therefore shows **GIANTS itself uses physics-space intersections separately from navigation-map point cost**.

This is proof of a **source pattern**, not proof that *every* map tree/hedge/road is covered by a collider, nor a contract to reuse the console command. A diagnostic experiment should query a small known region, **not invoke the console command** across the full road network and not register or change any physics object.

The navigation costmap's `navigationCollision` info layer, `AI_DRIVABLE` and `AI_BLOCKING` masks, and configurable slope threshold describe the engine's **AI route-cost model**. They do not by themselves delimit a protected road surface or certify a parked articulated Physical Assembly.

## Named discoveries and negative conclusions

### Physical Constraint Witness

A **Physical Constraint Witness** is a positive, localized piece of evidence that a particular represented collision shape, terrain discontinuity or registered polygon occupies a specified position/volume, with its source, mask, position, observation time and reliability preserved.

It is not an object label inferred from an unblocked AI navigation cell; it is not all-clear authority. A witness should say **what was hit or measured**, and separately **what remains unknown**.

The Exterior Margin Profile can consume witnesses from several GIANTS domains without claiming they share one unified world representation.

### Road Identity Gap

An AI-road spline and a ROAD-tagged physics object are **different possible representations**. Neither establishes a complete **road surface boundary** across maps. In Riverbend the user's chosen grass strip is bounded by the road *before* the next field; its usable depth must not be inferred from a nearby field or the spline's `maxWidth`.

**Negative result of source study:** no version-verified, universal **road-edge/road-pavement query** has yet been identified from the inspected APIs. Do not promote painted terrain attributes or navigable spline widths to a road-exclusion boundary without in-game evidence.

### Swept Physics Clearance Is Not Articulated Manoeuvre Feasibility

A physics sweep of a fixed box may **positively detect** an obstacle in a representative forward volume, but a negative test cannot model the changing footprint of a tractor plus trailing implement around a turn or across changing terrain. Keep physical obstacle observation, assembly-specific approach/run-out assessment and final verified occupancy independent.

## Bounded GIANTS Reality experiment — implemented in TEST 0.5.5.3, not yet field-validated

**Purpose:** challenge whether physics/terrain adds reliable *positive physical obstacle and terrain-profile evidence* that `FARM_CONTEXT_EDGE` plus navigation-map cost lacks. **Do not attempt to prove an entire 231 m parking corridor in one step.**

1. **Version and API gate:** On FS25 1.24, log availability of `overlapBox`, `raycastAll`, `sweepBoxVector`, `getTerrainHeightAtWorldPos`, `getTerrainNormalAtWorldPos`, and `CollisionFlag.ROAD`. If absent, mark unsupported and do not guess old signatures or call mutation APIs.
2. **Positive/negative controls:** On Mindenerwald, include a screenshot-identified protruding **hedge** location (especially the previously noted upper-right edge 2) and an apparently open middle cross-section of **preferred southern edge 9**. On Riverbend, include a **roadside** cross-section from east **edge 1** (owner-preferred strip) and a known road-adjacent location near north edge 7 as a positive visible-road control.
3. **Very small, bounded transverse measurements:** At a few explicitly chosen along-edge stations, measure *terrain height/normal* across the source-field boundary and into the margin, read farmland identity and AI nav-point status, and report **positive** collision hits using a **bounded 0.9 m × 0.9 m × 2 m overlap box**. Raycast and box-sweep availability are logged but not invoked in this first experiment. Keep raw station `s`, outward depth `d`, field/edge identity and sample size. Keep raw station `s`, outward depth `d`, map/field/edge identity and sample size.
4. **Cross-check what is visible:** Ask whether a known hedge generates a collider hit; whether a known ditch generates an elevation/normal change; whether a known road has a ROAD collider and, if so, whether it aligns with the physical road surface. **No hit**, especially where a road/hedge is visible, is a valuable representation failure.
5. **Performance/authority controls:** One-shot, diagnostics-only, small bounded number of queries; avoid per-tick work or repeatedly enumerating world physics. Read-only: no `setAreaDirty`, road registration, `addObstacle`, physics state change, native AI job or movement. Beware synchronous query cost and log publication perturbing GIANTS behaviour. Prefer initial stationary map observations without workers so native temporal variation is minimized.

**Falsification outcomes:**
- If the known hedge has no physics witness, physics is not a complete static-obstacle representation. Preserve unknown in the profile.
- If the known road has no reliable ROAD surface hit, a ROAD flag cannot be an outer-depth boundary; road classification remains unresolved.
- If a terrain ditch is measured but traversability differs by assembly, terrain profile is necessary *data*, not a universal reject rule.
- If a box sweep detects objects missed by the old point navmap, it supports **better positive hazard observation**, not an automatic clearance pass.
- If new APIs differ in v1.24, update the source contract and do not paper over with fallback claims.

**Acceptance for the implemented diagnostic experiment:** capture at least one meaningful positive witness and one meaningful counterexample or explicit missing-representation result on the named map control points; preserve unknowns. **Do not require parking success**, since no parking controller exists.

## TEST 0.5.5.3 experimental implementation (pending Reality)

The bounded plan above has been encoded as a **fixture-guarded, bounded** adjunct `scripts/observation/PhysicalMarginConstraintProbe.lua` called after the existing successful `FarmSpatialContextProbe:survey()`; it produces `PHYSICAL_MARGIN_CAPABILITY`, `PHYSICAL_MARGIN_POINT`, `PHYSICAL_MARGIN_SURVEY_FINISHED`, or explicit `PHYSICAL_MARGIN_UNAVAILABLE`. This experiment runs exclusively with the original server-only DIAGNOSTIC gate and is allowed to fail without overturning the preceding native Field Polygon / nav / farmland baseline.

**Probe regions:**
- Mindenerwald default Field 77: preferred edge **9**, stations at 25% and 75%, depths `-2,1,2,3,4,6,8,12 m`; known hedge control edge **2**, stations 8 m and 40 m, depths `2,6,12 m`.
- Riverbend with `spatialFarmlandId=2`: resolved registered Field **29**, preferred edge **1**, quarter/three-quarter stations at depths `-2,2,6,12,18,24,30 m`; north-road control edge **7** at half-length with `2,6,12,18,24,30 m`.
- Both fixtures require their logged source edge lengths and the four X/Z endpoint coordinates each within **3 m** of the original Reality observations, preventing accidental activation for similarly numbered fields on unrelated maps. Other map identities are explicitly unavailable rather than guessed.
- Per survey maximum **24** transverse point positions, **22** synchronous overlap calls, bounded per-box hit records. The box is intentionally small (0.9 m × 0.9 m × 2 m, bottom 0.1 m above terrain): it is a *representation witness*, **not** the vehicle envelope.

**Validation disposition:** CI covers fake native `overlapBox` callbacks with TREE/ROAD flags, absent and failing APIs, and mismatched fixture geometry. These only validate observation discipline, not GIANTS 1.24 runtime availability or actual road/hedge coverage.

**Requested logs:** Both maps in TEST `0.5.5.3`, DIAGNOSTICS=true; Riverbend also requires `spatialFarmlandId="2"`. Compare `[PHYSICAL_MARGIN]` messages against the two in-game map references and preserve a screenshot if a collider was actually seen along the chosen cross-section. A missing hedge or ROAD hit is a **useful negative discovery**; do not silently broaden the scan or invent parking clearance.

## Authority and version disposition

- **Architecture:** The [Exterior Margin Profile](../../architecture/EXTERIOR_MARGIN_PROFILE.md) needs evidence of limiting features and unknowns; these sources offer candidate *witnesses*, not a change in settlement policy.
- **Specification:** [Farm Spatial Context Observation](../../spec/FARM_SPATIAL_CONTEXT_OBSERVATION.md) retains the implemented `2/6/12 m` baseline and now explicitly contracts the separate TEST `0.5.5.3` physics adjunct. It does not constitute a continuous Exterior Margin Profile.
- **Source:** a separate experimental `PhysicalMarginConstraintProbe.lua` now makes guarded, bounded read-only native queries in TEST `0.5.5.3`. It is **not** production settlement assessment or Control.
- **Validation:** New synthetic CI confirms API gating, query bounds and explicit failure handling, but **does not validate real physics/terrain surfaces**. Installed FS25 1.24 Reality must challenge the source-derived signatures before relying on them.
- **Engine Knowledge:** Findings remain in Research until confirmed in 1.24; do **not** revise `docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md` to imply validation that has not occurred.

**Decision gate:** The owner agreed to the bounded read-only TEST `0.5.5.3` experiment. Next: collect GIANTS Reality on both maps before deciding whether observed physical constraints can support a future continuous Exterior Margin Profile or Settlement Corridor Assessment.
