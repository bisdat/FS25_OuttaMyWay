# Specification

Specifications define implementation-facing obligations for responsibilities accepted by [current Architecture](../architecture/README.md), without deriving contracts from a historical source tree.

## Active primary contracts

| Jurisdiction | Primary Specification | Current implementation route |
| --- | --- | --- |
| Configuration | [Configuration Specification](CONFIGURATION.md) | [Configuration.lua](../scripts/configuration/Configuration.lua) and the current shell/GUI consumers |
| Log Publication | [Log Publication Specification](LOG_PUBLICATION.md) | [LogPublication.lua](../scripts/publication/LogPublication.lua) and the shell publisher |

[Current code](../scripts/main.lua) also composes the version-only HUD and disabled reminder according to [GUI Architecture](../architecture/GUI.md).

There is **no active production worker-Observation, Situation Assessment, Regulation, Passage, Recovery, Decision, Bounded Authority or Control implementation or current 0.5 normative primary Specification**. A research signal does not establish a new Jurisdiction.

The pre-rewrite contracts and source remain recoverable from the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). Their former implementations were removed from the 0.5 working tree; do not treat historical participant lists as current source traceability.

Normative Specification authoring, source participation, and **Touch One; Validate Three** are governed by [Documentation Standards](../docs/DOCUMENT_STANDARDS.md). Broader worker contracts will be added only after Architecture has established their meaning.
