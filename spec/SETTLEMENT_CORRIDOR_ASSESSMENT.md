# Settlement Corridor Assessment — Nominal Static and Straight-Sweep Polygon Evidence (TEST 0.5.5.6)

## Identity and authority

**Specification Jurisdiction:** Settlement Corridor Assessment  
**Jurisdiction ID:** `SETTLEMENT_CORRIDOR_ASSESSMENT`

**Primary Architecture Authority:** [Exterior Margin Profile — Settlement Corridor Assessment](../architecture/EXTERIOR_MARGIN_PROFILE.md#distinct-downstream-responsibility--settlement-corridor-assessment)

The overall architectural responsibility is to assess whether a *specific actual Physical Assembly* can approach, straighten along a run-out and stop fully outside its source registered field, respecting roads, other fields, physical obstacles and operational demand. **TEST 0.5.5.6 extends the already validated nominal stationary-position screen with a bounded, continuous *rigid straight-translation* sweep of the same actual assembly snapshot against registered field polygons.** It does **not** positively establish Approach, Run-Out or Terminal Envelope feasibility, take possession of vehicle Control, register a destination, certify TRANSIT configuration, or select an operational parking place.

The current experiment is a **DIAGNOSTIC-only** participant of the pre-existing Farm Spatial Context survey, not a new production completion consumer. It consumes the existing `PairTransitRegion.capture(vehicle)` *read-only*, preserving its source-defined `GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION` semantics. That source returns member native base-size rectangles at their **current actual articulated poses**, not a verified folded configuration, collision mesh, path sweep or predicted straightened articulation.

## Admission and source-map fixture

- Execute **once**, after a successfully completed `FARM_CONTEXT_SURVEY_FINISHED` baseline and the independent physical-margin adjunct, under the established **server + product enabled + DIAGNOSTIC publication + explicit `spatialSurvey="true"`** research-survey gate. Enabling Completion Settlement prototype alone must not trigger this work. No work runs under NORMAL/DEBUG or without source geometry.
- TEST selection is exclusively registered **Mindenerwald Field 77**, nominated **edge 9**, native endpoints `(228.15,-243.04) → (-0.06,-207.44)`, length **230.97 m**; require matching field identity, no overriding farmland selector, and end coordinates and length within **3 m**. No other map/field is guessed; no general or production edge-selection rule is introduced.
- Enumerate the native **`g_currentMission.vehicleSystem.vehicles`** population, not an assumed `g_currentMission.vehicles` alias (TEST 0.5.5.4 GIANTS Reality proved the latter unavailable). If the VehicleSystem catalogue is absent, publish `VEHICLE_CATALOGUE_UNAVAILABLE`; never silently substitute an empty population. Scan **at most 400** currently registered scene vehicle entries, retaining only actual root vehicles with a readable pose whose root is *inside* Field 77 or no more than **20 m** from the nominated edge. Use available `getRootVehicle` or `getAttacherVehicle` to reject attached members as separate subjects; deduplicate assembly root identity by the current root vehicle.
- Sort by distance to the nominated edge, break ties by stable root identity and screen no more than **three root Physical Assemblies**. These caps bound cost; they do **not** redefine Operation support limits or confer Control authority. If none are present, publish an unavailable reason rather than invent a representative assembly.

## Nominal geometric screen

For each selected **real** assembly:

1. Obtain actual root pose/heading and invoke `PairTransitRegion.capture` once. If any attached member, size, transform, heading or attached-object traversal is unresolved or over the existing 16-member limit, record `WAITING_FOR_EVIDENCE` and a specific reason. Never use a tractor-only surrogate for an unavailable trailer/implement.
2. Treat each member as its current GIANTS **base-size** rectangle, maintaining the captured relative offsets of all attached members. A *virtual rigid rotation* of that current complete articulated snapshot into either **+/- edge-tangent direction** is permissible for this diagnostic necessary-geometry screen. It does not straighten a hitch, predict native steering, request fold or move a node.
3. At each of **nine nominal edge stations (10%–90%)** and depths **+2,+3,+4,+5,+6,+8,+10,+12 m**, test both along-edge directions: **144 bounded hypothetical static root placements** per selected assembly. Reject a stationary placement as a sampled **polygon conflict** when any member rectangle intersects the source registered field polygon or another registered productive field polygon, including edge crossing and containment; also reject members projecting past the two endpoints of this *one* edge (0.5m diagnostic endpoint guard). A polygon table with missing shape/registry coverage is unresolved, not empty space.
4. Report sampled position count, source-field conflict count, other-field conflict count, edge spill and unknown count. If some nominal positions do not intersect any registered field polygon, emit a compact **example** with station, root outward depth, travel direction and the projected union's nominal width/length. The example is **not** selected for movement or parking, and never becomes a held reservation. Absence of candidates in the finite grid is not a universal proof of impossibility.

Report `ASSEMBLY_SETTLEMENT_SCAN`, zero-to-three `ASSEMBLY_SETTLEMENT_NOMINAL_SCREENED`, `ASSEMBLY_SETTLEMENT_FINISHED` and explicit `ASSEMBLY_SETTLEMENT_UNAVAILABLE` reasons under DIAGNOSTIC origin `ASSEMBLY_SETTLEMENT`. All published samples preserve registered field/edge, assembly root identity, number of measured components and provenance of the **nominal** envelope. The number of sampled polygon-nonintersecting poses is only a *necessary-condition discovery*. In every outcome:

- **Approach = `WAITING_FOR_EVIDENCE`** — actual source heading, swept articulation and current active-worker demand not assessed.
- **Run-Out = `WAITING_FOR_EVIDENCE`** — a bounded straight *polygon-only* swept union may be observed, but it establishes no real vehicle journey, articulation/steering feasibility, continuous physical obstacle clearance or sufficient safe run-out distance.
- **Terminal = `WAITING_FOR_EVIDENCE`** — current nominal body rectangles are not a collision-complete static envelope, and road/hedge/terrain/dynamic occupancy exclusion is not established. **Do not add verification of TRANSIT/fold completion as a prerequisite**; completion handling separately requests TRANSIT without a readiness check.

This explicitly prevents `nominalCandidateCount>0` from being misread as `SUPPORTED` or from triggering any Control action. The results cannot be cached as a definitive physical-margin profile or reused as an admitted Movement Control goal.

## TEST 0.5.5.6 — Nominal Straight-Sweep Witness

**Concept:** A *Nominal Straight-Sweep Witness* is positive evidence that, from a hypothetical source- and neighbour-field-polygon-compatible stationary pose, **each coupled member's frozen nominal base rectangle can translate straight forward along a selected native edge without intersecting registered productive-field polygons**, over an explicitly bounded distance. It is a planar geometric necessary-condition witness. It is **not** a continuous physical Settlement Corridor, not a proof of native steering and not an authorised run-out distance.

**Sampling and sweep construction:**

- From the existing 144 finite nominal static placements, preserve at most **two nominally polygon-compatible seed poses per travel direction**: one with maximum remaining **forward** edge-endpoint headroom and one with the shallowest positive outward root depth (prefer longer headroom on ties). Do not reinterpret the original `exampleStationM` as a forward run-out recommendation. At most **four** seeds per actual selected assembly.
- For each member rectangle, compute the **convex hull of its four start corners and four corners translated by the same straight vector**. Because the initial rectangle is convex and the transform is a rigid straight translation, this hull covers **every intermediate member position** over that interval, not just finite midpoint samples.
- Test that entire per-member swept hull for **source registered field** and **every available neighbouring registered productive-field** polygon intersection, including edge-edge crossing, containment and touching. Use only the existing, validated native field polygon catalogue. **No ROAD, hedge, ditch, tree, slope, vehicle, worker demand or parking-eligibility representation is established by these tests.** If source/neighbor registry is incomplete or a member's nominal geometry is unavailable, return explicit unresolved results rather than an all-clear.
- For each seed, bound the forward horizon to the physical edge endpoint minus the nominal member overhang and a diagnostic **0.5 m endpoint buffer**, with an additional **230 m engineering cap**, *not* a required safe run-out length. Check the complete horizon. If blocked, use at most **eight bisections** to report a conservative **continuous polygon-only clear lower bound** and an upper conflict bracket. At most **40 combined swept-union polygon checks per selected assembly** (four seeds × ten calls). A bisection is a precision bound for a monotone *whole-sweep intersection*, not a discontinuous sampling method.
- Publish at most four `ASSEMBLY_SETTLEMENT_STRAIGHT_SWEEP` events per selected assembly with observed root node, captured member count, native field and edge, sample station/depth/direction, tested edge-endpoint horizon, polygon-only clear lower bound, conflict upper bound, limiting registered-field polygon evidence, number of checks, and explicit `RUNOUT=WAITING_FOR_EVIDENCE`. Summarise the seed count and largest polygon-only lower bound in `ASSEMBLY_SETTLEMENT_NOMINAL_SCREENED`, without changing the existing `nominalCandidateCount` interpretation.

**Interpretation:** A positive geometric lower bound means only that a **rigid frozen-articulation footprint** has no intersection with the registered **source/neighbor productive field polygons** along that finite straight displacement. It proves neither a turning/alignment approach to the start pose, nor sufficient native steering run-out, nor physical traffic/road/hedge clearance, nor safe parking at the end. The travelling assembly can change articulation, and an ignored obstacle may lie anywhere in the swept region. Conversely, zero positive geometric length at the **selected finite seeds** does not prove that no Settlement Corridor exists on another depth/station/edge. No numeric run-out threshold has been established. **Approach, Run-Out and Terminal must remain WAITING_FOR_EVIDENCE for every result.**

This module is purely mathematical and passive. It never issues TRANSIT (which is separately request-only), never checks fold completion, never claims a parking position or reserves the examined geometry, never changes GIANTS navigation or terrain and never moves any assembly.

## Authority boundaries and regression

No new native AI job, control message, `driveToPoint`, steering input, fold/lower/raise command, physics mutation, costmap mutation, road registration, player HUD message or persisted Configuration flag is permitted. Completion Transit remains successful-FIELDWORK **request only**; this experimental polygon screen runs independently at map-load observation and must not alter the transit consumer or active Hold & Relocate. Error handling and truncated registries must not overturn a completed Field Spatial Context survey.

This is a bounded *engineering representation* assessment, not a production criterion that a 3 m verge or 12 m lateral search depth suffices.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/SettlementCorridorAssessment.lua`](../scripts/assessment/SettlementCorridorAssessment.lua) | `REALISES` |
| [`scripts/assessment/SettlementStraightRunout.lua`](../scripts/assessment/SettlementStraightRunout.lua) | `REALISES` |
| [`scripts/observation/AssemblySettlementProbe.lua`](../scripts/observation/AssemblySettlementProbe.lua) | `REALISES` |
| [`scripts/observation/FarmSpatialContextProbe.lua`](../scripts/observation/FarmSpatialContextProbe.lua) | `REALISES` |
| [`scripts/coordination/PairTransitRegion.lua`](../scripts/coordination/PairTransitRegion.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/settlement_corridor_assessment.lua`](../tests/shell/settlement_corridor_assessment.lua) | `CHALLENGES` |
| [`tests/shell/settlement_straight_runout.lua`](../tests/shell/settlement_straight_runout.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |
| [`tests/test_product_shell_structure.py`](../tests/test_product_shell_structure.py) | `CHALLENGES` |

## Reality validation and next authority gate

Offline CI must establish that complete coupled member rectangles—not only root center or rectangle corners—are checked, catalogue truncation yields unresolved status, no unknown component is replaced by an optimistic root-only footprint, both tangent directions are considered, caps are respected, identical field IDs with translated world vertices are rejected and no actuator is called.

In **TEST 0.5.5.6**, the user should load **Mindenerwald Field 77** with `<outtaMyWayDiagnostics enabled="true" spatialSurvey="true" />` and at least one complete, real tractor/implement assembly present in the field or within 20 m of edge 9. Collect `[ASSEMBLY_SETTLEMENT]` events and compare the root, member count and nominal dimensions with the visibly selected assembly. If no target is found or size evidence is unavailable, the result is a **valid negative test** identifying what we must observe differently.

The remaining validation responsibilities are **continuous physical corridor access, infield alignment, actual controlled forward run-out and whole-assembly terminal occupancy**. TRANSIT remains a request-only capability; **no dedicated fold-completion or TRANSIT-readiness witness is to be introduced**. Actual behaviour and physical clearance must be validated in GIANTS Reality, with uncertainty retained when nominal geometry is insufficient. No movement test is admitted by this experiment.
