# TEST 0.5.5.4 — Field 77 Physical Assembly Nominal Feasibility Screen

**Status:** executable **read-only** assembly-specific TEST awaiting GIANTS 1.24 Reality, no movement or parking. The acceptance target is an observed *real vehicle plus all attached implements*, not a synthetic map-only corridor.

## Why this test follows the source studies

The owner accepted [Settlement Corridor](../../architecture/COMPLETION_TRIGGERED_TERMINAL_EGRESS.md) with three independent requirements: **Approach Envelope, Run-Out Envelope, Terminal Envelope**. The [Exterior Margin Profile](../../architecture/EXTERIOR_MARGIN_PROFILE.md) describes the world-space constraints; the actual assembly must be assessed separately. The previous **0.5.5.3** run completed both maps and showed native representation discordance: Riverbend returned one **ROAD** physics collider but a sizable terrain ramp; Field 77's two hedge-control locations were **navigation-blocked with no physics collision hits**, while preferred south edge 9 was mostly level at its two cross-sections.

Therefore another arbitrary point-cloud scan cannot *prove* a parked articulated assembly fits. This test makes the **first falsifiable assembly-specific geometric claim**, while preserving missing evidence.

## Reality fixture and tested claim

**Mindenerwald registered Field 77, owner-preferred southern edge 9**, 230.97 m long. Keep `spatialFarmlandId` **absent** in the engineering diagnostic sidecar. Run **TEST 0.5.5.4** with at least one real tractor/implement assembly *physically present inside Field 77* or with its tractor root within 20 m of edge 9 when the initial six-second survey executes. The existing Field 77 work-save may already satisfy this. **No AI worker, native success event or parking manoeuvre is required.**

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
