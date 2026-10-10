# Specification

Specifications define implementation-facing obligations for responsibilities accepted by [current Architecture](../architecture/README.md), without deriving contracts from a historical source tree.

## Active primary contracts

| Jurisdiction | Primary Specification | Current implementation route |
| --- | --- | --- |
| Configuration | [Configuration Specification](CONFIGURATION.md) | [Configuration.lua](../scripts/configuration/Configuration.lua) and the current shell/GUI consumers |
| Log Publication | [Log Publication Specification](LOG_PUBLICATION.md) | [LogPublication.lua](../scripts/publication/LogPublication.lua) and the shell publisher |
| Spatial Pair Inference | [Spatial Pair Inference Specification](SPATIAL_PAIR_INFERENCE.md) | [SpatialPairInference.lua](../scripts/assessment/SpatialPairInference.lua), pure; native observer now supplies candidate inputs |
| Hold & Relocate | [Hold & Relocate Specification](HOLD_RELOCATE.md) | [HoldRelocateCoordinator.lua](../scripts/coordination/HoldRelocateCoordinator.lua), coordination logic only; no physical adapter or active commitment source |
| Native Blockage Observation | [Native Blockage Observation Specification](NATIVE_BLOCKAGE_OBSERVATION.md) | [NativeBlockageObservation.lua](../scripts/observation/NativeBlockageObservation.lua), server-side read-only samples |
| Obstruction Relocation (partial port) | [Obstruction Relocation Specification](OBSTRUCTION_RELOCATION.md) | [NonJobActuationMechanism.lua](../scripts/control/mechanisms/NonJobActuationMechanism.lua), **archived Causal Obstruction now active pre-stall; GIANTS Reality pending** |

[Current code](../scripts/main.lua) also composes the version-only HUD and disabled reminder according to [GUI Architecture](../architecture/GUI.md).

The 0.5.1.3 shell has **live single-worker and paired Hold & Relocate**, but no archived full Situation Assessment, Passage, global Decision or non-active Obstruction Relocation Resolution. TEST 0.5.1.5 routes positive **archived current physical / realised-motion Causal Obstruction** to bounded non-job actuation without native blocked admission. Completion alone never authorises relocation, and a physical PASS is not yet established. Native blocked pair/solo recovery remains separate and unchanged.

The pre-rewrite contracts and source remain recoverable from the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). Their former implementations were removed from the 0.5 working tree; do not treat historical participant lists as current source traceability.

Normative Specification authoring, source participation, and **Touch One; Validate Three** are governed by [Documentation Standards](../docs/DOCUMENT_STANDARDS.md). Broader worker contracts will be added only after Architecture has established their meaning.
