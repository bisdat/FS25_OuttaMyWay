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

[Current code](../scripts/main.lua) also composes the version-only HUD and disabled reminder according to [GUI Architecture](../architecture/GUI.md).

There is **no full Situation Assessment, Regulation, Passage, Recovery, Decision, Bounded Authority or worker Control implementation**. Hold & Relocate coordination is implemented as a dormant module within the accepted responsibility; no physical GIANTS adapter or admission is wired. Native Blockage Observation now supplies sampled GIANTS blocked-state input for **single full ≥1 s pulses**; more complex episode continuity is still absent. Retired research signals do not establish a new Jurisdiction.

The pre-rewrite contracts and source remain recoverable from the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). Their former implementations were removed from the 0.5 working tree; do not treat historical participant lists as current source traceability.

Normative Specification authoring, source participation, and **Touch One; Validate Three** are governed by [Documentation Standards](../docs/DOCUMENT_STANDARDS.md). Broader worker contracts will be added only after Architecture has established their meaning.
