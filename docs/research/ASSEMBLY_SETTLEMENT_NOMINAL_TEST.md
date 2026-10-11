# TEST 0.5.5.4–0.5.5.5 — Field 77 Nominal Assembly Polygon Screen

**Status:** TEST **0.5.5.5 GIANTS 1.24.0.0 run validated the native vehicle-population fix and nominal static polygon screening of two real *single-member* vehicles** on Field 77; the originally requested *articulated multi-member* case remains untested. No movement or parking. Keep PR draft. The acceptance target remains a complete live tractor-plus-implement, not a root-only surrogate or synthetic map-only corridor.

## Why this test follows the source studies

The owner accepted [Settlement Corridor](../../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md) with three independent requirements: **Approach Envelope, Run-Out Envelope, Terminal Envelope**. The [Exterior Margin Profile](../../architecture/EXTERIOR_MARGIN_PROFILE.md) describes the world-space constraints; the actual assembly must be assessed separately. The previous **0.5.5.3** run completed both maps and showed native representation discordance: Riverbend returned one **ROAD** physics collider but a sizable terrain ramp; Field 77's two hedge-control locations were **navigation-blocked with no physics collision hits**, while preferred south edge 9 was mostly level at its two cross-sections.

Therefore another arbitrary point-cloud scan cannot *prove* a parked articulated assembly fits. This test makes the **first falsifiable assembly-specific geometric claim**, while preserving missing evidence.

## GIANTS Reality — first 0.5.5.4 run, 11 October 2026

Owner-supplied `log(20261011-155307).txt`, GIANTS 1.24.0.0, Mindenerwald, confirms **TEST 0.5.5.4 loaded enabled**, native source Field **77** edge **9** (230.97 m), complete `FARM_CONTEXT_SURVEY_FINISHED` (690 samples), and completed Physical Margin adjunct (20 physics calls, no errors and zero represented physics hits at selected points). The original nominal assembly screen emitted `ASSEMBLY_SETTLEMENT_UNAVAILABLE reason=VEHICLE_CATALOGUE_UNAVAILABLE`. **No real member footprint, no polygon candidate count and no terminal feasibility result were produced.**

**Discovery — VehicleSystem Catalogue Authority:** the probe incorrectly looked up `g_currentMission.vehicles`. The project's pre-existing [GIANTS Runtime Knowledge](../engine/GIANTS_RUNTIME_KNOWLEDGE.md#vehiclesystem-exposes-current-savegame-vehicles-and-root-assemblies) already specifies the native `g_currentMission.vehicleSystem.vehicles` catalogue. This is an implementation source defect, not a missing architectural responsibility, nonexistent in-field vehicle or invalid requested southern edge. The original mock test supplied the same erroneous alias, so it could not falsify the mistake.

**Corrective TEST 0.5.5.5:** change only `AssemblySettlementProbe` source to `g_currentMission.vehicleSystem.vehicles`, update the behavioural fixture to model the true GIANTS mission hierarchy, assert that a fake legacy `mission.vehicles` alias does **not** suffice, and preserve the original one-shot diagnostic gating, geometry and no-Control behaviour. GIANTS Reality validation of this correction remains pending.

## GIANTS Reality — 0.5.5.5 rerun, 11 October 2026

Owner-supplied `log(20261011-160156).txt` confirms OuttaMyWay **0.5.5.5** was enabled on GIANTS **1.24.0.0**, Mindenerwald savegame 3. The original read-only surveys repeated successfully: registered **Field 77, south edge 9, 230.97 m**, **690** field-edge samples, **22 physical-margin points / 20 physics queries**, **0 physics query errors**, and no represented physics hits. The field/margin surveys do **not** certify settlement clearance.

**VehicleSystem Catalogue Authority was corrected and validated in GIANTS.** At 17:01:28.837 the one-shot `ASSEMBLY_SETTLEMENT_SCAN` found **56 registered scene vehicles**, **two in-field roots** eligible, **two selected**, without scene or neighbouring-field registry truncation.

| Recorded witness | rootNode 396337 | rootNode 400645 |
| --- | ---: | ---: |
| Root world X/Z, metres | −0.18 / −233.18 | 28.81 / −611.39 |
| Actual root inside source polygon | yes | yes |
| Distance to preferred edge 9 | 25.45 m | 394.67 m |
| Real runtime members captured | **1** | **1** |
| Nominal selected-member longitudinal extent | 11.10 m | 9.00 m |
| Nominal selected-member lateral extent | 3.50 m | 3.90 m |
| Hypothetical static poses screened | 144 | 144 |
| **No registered productive-field polygon intersections** | **82** | **71** |
| Neighbour registered-field conflicts | 62 | 64 |
| Source registered-field conflicts | 0 | 9 |
| Chosen-edge endpoint spill | 0 | 0 |
| Unresolved polygon computations | 0 | 0 |
| Example pose (both): station / root depth / direction | 207.88 m / +2.00 m / +1 | 207.88 m / +2.00 m / +1 |

Counts partition each **finite, hypothetical** screening grid of 144 positions; they are not evidence of 82 or 71 continuously connected parking places, nor are these real vehicle positions. The repeated example is determined by the nominal sampler's example-ranking rule, **not** an optimised or authorised terminal destination. Both outcomes explicitly remain `Approach=WAITING_FOR_EVIDENCE`, `Run-Out=WAITING_FOR_EVIDENCE`, `Terminal=WAITING_FOR_EVIDENCE`, `configuration=UNVERIFIED_TRANSIT`. No OuttaMyWay runtime exception appears; four `FieldManager` map-farmland touching errors predate the diagnostic survey and are not attributed to the probe.

**Discovery — Single-Body Nominal Fit:** in GIANTS Reality, at least one modelled edge-parallel *stationary* position for each of two actual single-member root vehicles is polygon-nonintersecting. This falsifies a general claim that no nominal static rectangle could fit on the preferred edge, but **does not demonstrate physical clearance or continuity**. Both nominal widths (**3.50 m, 3.90 m**) also exceed an assumed **3 m** parallel-margin budget; a 3 m corridor should not be treated as sufficient for either measured rectangle without lateral placement/clearance validation. The sampler tests outward root depths of +2 to +12 m, not a measured continuous 3 m corridor.

**Unresolved — Articulated Assembly Witness:** both observed `memberCount=1`. That is normal if the actual roots were self-propelled machines with no attached GIANTS children, but the log does **not** publish vehicle type names and cannot establish their identities or whether the user intended to have an attached implement. Do not reinterpret one member as a tractor-plus-tool or claim hitch geometry was tested. The full selected Physical Assembly contract must be challenged with a recognisable **root tractor + hitched implement** in Field 77 at scan time, expecting `memberCount>=2` and dimensions consistent with both. If such an assembly is actually present but capture still reports one, that becomes **Attachment Membership Evidence** failure to investigate before further movement architecture.

**Decision:** validate the two available single-body results as **polygon-only discovery**; retain the existing TEST **0.5.5.5** for an articulated-assembly rerun rather than change code or add Control. No PATCH promotion, parking manoeuvre or in-field movement test is supported by this evidence alone. If a genuine coupled assembly is available, place it **inside native Field 77 before loading the save**, keeping diagnostics enabled and no `spatialFarmlandId` override. The one-shot survey will select up to three closest eligible roots. Return the `ASSEMBLY_SETTLEMENT` lines and identify which machine is the tractor/tool.

## Reality fixture and tested claim

**Mindenerwald registered Field 77, owner-preferred southern edge 9**, 230.97 m long. Keep `spatialFarmlandId` **absent** in the engineering diagnostic sidecar. Run **TEST 0.5.5.5** with at least one real tractor/implement assembly *physically present inside Field 77* or with its tractor root within 20 m of edge 9 when the initial six-second survey executes. The existing Field 77 work-save may already satisfy this. **No AI worker, native success event or parking manoeuvre is required.**

GIANTS code `PairTransitRegion.capture` already traverses the runtime selected assembly (up to 16 members), using native base-size width/length/offset and actual transform of each member. The new `SettlementCorridorAssessment` projects that **current frozen-articulation snapshot** hypothetically parallel to edge 9 at 9 station fractions × 8 outward depths × 2 travel directions = **144 bounded nominal stationary poses per eligible assembly**. It tests every member's oriented rectangle against source and neighbouring **registered field polygons**, including polygon-edge crossing and interior containment, and rejects overshooting the chosen edge's endpoints. **No game entity is translated or rotated**, and no path is planned.

For at most three eligible root assemblies, publish:

- `[ASSEMBLY_SETTLEMENT][ASSEMBLY_SETTLEMENT_SCAN]` — number of scene roots considered, selected, limits and native field/edge.
- `ASSEMBLY_SETTLEMENT_NOMINAL_SCREENED` — **actual root ID**, approximate current position and member count; number of nominal polygon-only positions screened, conflicts with source/other fields/edge endpoints, and number of nominal polygon-nonintersecting positions. When such a sample exists, one example station, root depth, tangent direction and current nominal width/length. **The example is not a target or parking allocation.**
- `ASSEMBLY_SETTLEMENT_FINISHED` or an explicit `ASSEMBLY_SETTLEMENT_UNAVAILABLE` when no assembly or adequate geometry exists.

Every result **must** retain **Approach=WAITING_FOR_EVIDENCE; Run-Out=WAITING_FOR_EVIDENCE; Terminal=WAITING_FOR_EVIDENCE; configuration=UNVERIFIED_TRANSIT**. The samples assess only hypothetical poses of *current* nominal base rectangles. Actual folded width may differ. The hitch may straighten, jackknife or cut in during movement. The road/hedge/ditch may be missed by native field polygons. Other live workers may need the same space. No positive vehicle-clearance claim is authorised.

## What can be disproved

| Observation | Learning |
| --- | --- |
| No assemblies discovered near source field | Test-set entry condition unmet; do not infer no possible settlement. Position an actual assembly in the field and repeat unchanged TEST. |
| Real tractor detected but member size unavailable | Existing `PairTransitRegion.capture` is insufficient for that vehicle; preserve actual missing member rather than root-only surrogate. |
| MemberCount lower than visually attached components | Representation mismatch; do not trust the nominal screen until native assembly traversal agrees with GIANTS Reality. |
| **0/144** nominal placements escape field polygon conflicts | Bounded station/depth sample did not discover nominal fit for *that live shape*. It is not proof no other geometry/approach could work. |
| Some nominal placements do not intersect field polygons | At least one *modelled stationary pose* is consistent with registered **field polygons only**. Road, physical obstacles, fold, dynamic workers, run-out and alignment still unresolved. |
| Two tangent directions differ | Real current articulation/geometry is directional; no universal approach direction can be assumed. |
| Existing root close to field but partly outside | Its current pose does not certify off-field terminal occupancy; the nominal projection may still reveal potential geometric fit. |

**A validated RESULT DOES NOT INVOLVE MOVEMENT.** After receiving the log, review the actual root/member geometry and whether nominal terminal fit is ever possible on Field 77. Only then decide how to *independently* validate TRANSIT posture and motion, without expanding this diagnostic to a field-specific parking controller.

**Specification:** [Settlement Corridor Assessment](../../spec/SETTLEMENT_CORRIDOR_ASSESSMENT.md). **Previous evidence:** [TEST 0.5.5.3 physical-margin Reality](PHYSICAL_MARGIN_TEST_0_5_5_3_REALITY.md).
