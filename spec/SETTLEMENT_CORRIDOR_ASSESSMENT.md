# Settlement Corridor Assessment — Nominal Polygon Screen (TEST 0.5.5.4)

## Identity and authority

**Specification Jurisdiction:** Settlement Corridor Assessment  
**Jurisdiction ID:** `SETTLEMENT_CORRIDOR_ASSESSMENT`

**Primary Architecture Authority:** [Exterior Margin Profile — Settlement Corridor Assessment](../architecture/EXTERIOR_MARGIN_PROFILE.md#distinct-downstream-responsibility--settlement-corridor-assessment)

The overall architectural responsibility is to assess whether a *specific actual Physical Assembly* can approach, straighten along a run-out and stop fully outside its source registered field, respecting roads, other fields, physical obstacles and operational demand. **TEST 0.5.5.4 implements only an isolated, nominal, polygon-only stationary-position screen.** It does **not** positively establish Approach, Run-Out or Terminal Envelope feasibility, take possession of vehicle Control, register a destination, certify TRANSIT configuration, or select an operational parking place.

The current experiment is a **DIAGNOSTIC-only** participant of the pre-existing Farm Spatial Context survey, not a new production completion consumer. It consumes the existing `PairTransitRegion.capture(vehicle)` *read-only*, preserving its source-defined `GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION` semantics. That source returns member native base-size rectangles at their **current actual articulated poses**, not a verified folded configuration, collision mesh, path sweep or predicted straightened articulation.

## Admission and source-map fixture

- Execute **once**, after a successfully completed `FARM_CONTEXT_SURVEY_FINISHED` baseline and the independent physical-margin adjunct, under the already established **server + enabled + DIAGNOSTIC publication** gate. No work runs under NORMAL/DEBUG or without source geometry.
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
- **Run-Out = `WAITING_FOR_EVIDENCE`** — no forward journey, steering, continuous obstacle/boundary evidence or run-out distance is established.
- **Terminal = `WAITING_FOR_EVIDENCE`** — current nominal body rectangles are not a verified TRANSIT-folded or collision-complete static envelope, and road/hedge/terrain/dynamic occupancy exclusion is not established.

This explicitly prevents `nominalCandidateCount>0` from being misread as `SUPPORTED` or from triggering any Control action. The results cannot be cached as a definitive physical-margin profile or reused as an admitted Movement Control goal.

## Authority boundaries and regression

No new native AI job, control message, `driveToPoint`, steering input, fold/lower/raise command, physics mutation, costmap mutation, road registration, player HUD message or persisted Configuration flag is permitted. Completion Transit remains successful-FIELDWORK **request only**; this experimental polygon screen runs independently at map-load observation and must not alter the transit consumer or active Hold & Relocate. Error handling and truncated registries must not overturn a completed Field Spatial Context survey.

This is a bounded *engineering representation* assessment, not a production criterion that a 3 m verge or 12 m lateral search depth suffices.

## Contract participants

| Production source | Participation |
| --- | --- |
| [`scripts/assessment/SettlementCorridorAssessment.lua`](../scripts/assessment/SettlementCorridorAssessment.lua) | `REALISES` |
| [`scripts/observation/AssemblySettlementProbe.lua`](../scripts/observation/AssemblySettlementProbe.lua) | `REALISES` |
| [`scripts/observation/FarmSpatialContextProbe.lua`](../scripts/observation/FarmSpatialContextProbe.lua) | `REALISES` |
| [`scripts/coordination/PairTransitRegion.lua`](../scripts/coordination/PairTransitRegion.lua) | `SUPPORTS` |

## Repository validation participants

| Validation surface | Relationship |
| --- | --- |
| [`tests/shell/settlement_corridor_assessment.lua`](../tests/shell/settlement_corridor_assessment.lua) | `CHALLENGES` |
| [`tests/shell/main_smoke.lua`](../tests/shell/main_smoke.lua) | `CHALLENGES` |
| [`tests/test_product_shell_structure.py`](../tests/test_product_shell_structure.py) | `CHALLENGES` |

## Reality validation and next authority gate

Offline CI must establish that complete coupled member rectangles—not only root center or rectangle corners—are checked, catalogue truncation yields unresolved status, no unknown component is replaced by an optimistic root-only footprint, both tangent directions are considered, caps are respected, identical field IDs with translated world vertices are rejected and no actuator is called.

In **TEST 0.5.5.4**, the user should load **Mindenerwald Field 77** with `<outtaMyWayDiagnostics enabled="true" />` and at least one complete, real tractor/implement assembly present in the field or within 20 m of edge 9. Collect `[ASSEMBLY_SETTLEMENT]` events and compare the root, member count and nominal dimensions with the visibly selected assembly. If no target is found or size evidence is unavailable, the result is a **valid negative test** identifying what we must observe differently.

Only after that logged GIANTS Reality may we decide whether the current folded/TRANSIT envelope needs a dedicated verified-configuration witness, then test actual connected run-out and infield alignment as separate responsibilities. No movement test is admitted by this experiment.
