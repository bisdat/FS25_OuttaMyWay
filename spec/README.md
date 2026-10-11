# Specification

Specifications define implementation-facing obligations for the current [System Architecture](../architecture/README.md). Their jurisdictions identify contract boundaries, not code module topology. Source realises the specified mechanisms; tests and GIANTS Reality may challenge them.

## Active primary contracts

| Jurisdiction | Primary Specification | Implementation route |
| --- | --- | --- |
| Configuration | [Configuration Specification](CONFIGURATION.md) | [Configuration.lua](../scripts/configuration/Configuration.lua) and current GUI/runtime consumers |
| Log Publication | [Log Publication Specification](LOG_PUBLICATION.md) | [LogPublication.lua](../scripts/publication/LogPublication.lua) and publication producers |
| Native Blockage Observation | [Native Blockage Observation Specification](NATIVE_BLOCKAGE_OBSERVATION.md) | [NativeBlockageObservation.lua](../scripts/observation/NativeBlockageObservation.lua), bounded native read-only evidence |
| Farm Spatial Context Observation | [Farm Spatial Context Observation Specification](FARM_SPATIAL_CONTEXT_OBSERVATION.md) | [FarmSpatialContextProbe.lua](../scripts/observation/FarmSpatialContextProbe.lua), diagnostic-only Field 77 / Riverbend boundary survey with a separate TEST 0.5.5.3 physics/terrain witness |
| Settlement Corridor Assessment (TEST-only) | [Settlement Corridor Assessment Specification](SETTLEMENT_CORRIDOR_ASSESSMENT.md) | [SettlementCorridorAssessment.lua](../scripts/assessment/SettlementCorridorAssessment.lua) with [AssemblySettlementProbe.lua](../scripts/observation/AssemblySettlementProbe.lua), bounded nominal real-assembly polygon screening, **no movement** |
| Completion Transit | [Completion Transit Specification](COMPLETION_TRANSIT.md) | [CompletionTransitRuntime.lua](../scripts/control/CompletionTransitRuntime.lua), request-only completion configuration |
| Native Job Completion Observation | [Native Job Completion Observation Specification](NATIVE_JOB_COMPLETION_OBSERVATION.md) | [NativeJobCompletionProbe.lua](../scripts/observation/NativeJobCompletionProbe.lua), diagnostic-only FIELDWORK stop-reason evidence |
| Spatial Pair Inference | [Spatial Pair Inference Specification](SPATIAL_PAIR_INFERENCE.md) | [SpatialPairInference.lua](../scripts/assessment/SpatialPairInference.lua), bounded candidate evaluation |
| Hold & Relocate | [Hold & Relocate Specification](HOLD_RELOCATE.md) | [HoldRelocateCoordinator.lua](../scripts/coordination/HoldRelocateCoordinator.lua), native commitment and subordinate physical Control participants |

[Current runtime composition](../scripts/main.lua) invokes the native blocked-first recovery responsibilities alongside enabled Configuration and [GUI Architecture](../architecture/GUI.md). The live recovery contract supports independently admitted active-worker pair, solo and inferred non-active static interventions. This does not establish predictive Passage, comprehensive three-worker arbitration, complete multi-pulse obstruction continuity or universally stable articulated reversing.

[Documentation Standards](../docs/DOCUMENT_STANDARDS.md) govern Specification content, contracted traceability, source participation and cross-surface revalidation. [Blocked Recovery Research](../docs/research/BLOCKED_RECOVERY_INVESTIGATIONS.md) and the [Engineering Journal](../docs/ENGINEERING_JOURNAL.md) preserve experimental evolution rather than embedding it in current contracts.
