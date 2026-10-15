# Retired Farm Spatial Context Research Instruments

## Disposition — 15 October 2026

[Historical System Architecture](architecture__FARM_SPATIAL_CONTEXT_OBSERVATION.txt) and [historical primary Specification](spec__FARM_SPATIAL_CONTEXT_OBSERVATION.txt) are verbatim text archives, **not active** Architecture/Specification jurisdictions. This avoids stale references appearing to be current authority.

The owner-validated TEST 0.5.5.18 startup comparison produced a **clean** load without the Field 77 research survey and a **stutter** when the same research was deliberately enabled; an independently completed two-worker TS019 .18 run parked both assemblies without this survey. These observations justify **retirement from the shipped product**, not continued maintenance of a permanent gated world-scanning research instrument.

The following are exact retained historical files, not modules loaded by `scripts/main.lua`. Their original Git history remains available. Links to companion production modules in their historical comments reflect the original experiment and are **not current implementation routes**.

| Historical artifact | Original responsibility |
| --- | --- |
| [FarmSpatialContextProbe.lua](scripts__observation__FarmSpatialContextProbe.lua) | One-shot field-edge, farmland, native road and navigation-point survey |
| [PhysicalMarginConstraintProbe.lua](scripts__observation__PhysicalMarginConstraintProbe.lua) | Bounded exterior static physics/terrain research witness |
| [AssemblySettlementProbe.lua](scripts__observation__AssemblySettlementProbe.lua) | Hypothetical assembly member/nominal pose assessment |
| [SettlementStraightRunout.lua](scripts__assessment__SettlementStraightRunout.lua) | Rigid straight-translation polygon sweep study |
| [farm_spatial_context_probe.lua](tests__shell__farm_spatial_context_probe.lua) | Synthetic Field 77 and Riverbend survey test |
| [physical_margin_constraint_probe.lua](tests__shell__physical_margin_constraint_probe.lua) | Finite physics-margin test fixture |
| [settlement_straight_runout.lua](tests__shell__settlement_straight_runout.lua) | Bounded nominal straight-sweep fixture |
| [Original settlement_corridor_assessment.lua experiment](tests__shell__settlement_corridor_assessment_experiment.lua) | Retired multi-assembly nominal-probe fixture; replaced with live polygon intersection tests |
| [Historical TEST 0.5.5.6 Corridor Specification](spec__SETTLEMENT_CORRIDOR_ASSESSMENT.txt) | Retired nominal static and straight-swept research contract |
| [Historical Farm Spatial Context Specification](spec__FARM_SPATIAL_CONTEXT_OBSERVATION.txt) | Completed field-edge survey contract and limits |

**Preserved in current runtime:** `FarmEdgeGeometry` and the `SettlementCorridorAssessment.shapeIntersectsPolygon` mathematical helper continue to serve the actual `CompletionSettlementRoute`. Operational occupancy, planning, claims and physical Control have their own current evidence contracts. The retirement neither weakens them nor generalises Field 77 eligibility.

**Configuration separation:** `diagnostics.xml` now controls only DIAGNOSTIC log publication. The former `settlementPrototype`, `spatialSurvey` and `spatialFarmlandId` attributes have no control meaning. TEST 0.5.5.19 physical Completion Parking follows master Enabled (default On). A supported default-On independent player `Full Completion Parking` choice is deferred to [#139](https://github.com/bisdat/FS25_OuttaMyWay/issues/139). Issue [#484](https://github.com/bisdat/FS25_OuttaMyWay/issues/484) retains general-field productionisation and safety work.

**Claim limits:** Removing the unneeded synchronous research workload establishes a less intrusive startup architecture. It does not optimise the retired survey for explicit use, validate new fields or resolve known incomplete-guide safety-stop behaviour.
