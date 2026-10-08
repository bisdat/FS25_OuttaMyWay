# Current Concept Register

This register is a **thin index of present architectural concepts**, not a replacement for their governing Architecture. It must not silently carry concepts from retired implementations into the 0.5 design. Historical concepts remain accessible through [the 0.4 archive branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0) and Git provenance.

## Accepted current concepts

| Concept | Current meaning | Authority |
| --- | --- | --- |
| Autonomous Continuity | The product objective is to preserve worker completion without unnecessary supervision; it does not require uninterrupted vehicle movement. | [Project Vision](../architecture/PROJECT_VISION.md) |
| Configuration as Consent Surface | Players select supported product settings; Enabled does not assert currently implemented AI coordination. | [Configuration Architecture](../architecture/CONFIGURATION.md) |
| Publication Authority != Semantic Authority | Log Publication controls eligibility and output, not truth, evidence, or decisions. | [Log Publication Architecture](../architecture/LOG_PUBLICATION.md) |
| Evidence Production != Evidence Publication | Diagnostic work and whether an already-produced fact is published are distinct; suppressed publication should not construct avoidable payloads. | [Log Publication Architecture](../architecture/LOG_PUBLICATION.md#9-diagnostic-production-and-publication-are-separate) |
| Version-Only Product Status | A visible running product shows its dynamic OuttaMyWay version without mode suffix or operational message; hidden when disabled. | [GUI Architecture](../architecture/GUI.md#rewrite-shell-product-status) |

## Investigation, not accepted runtime authority

**Native Blocked Assertion != Recovery Necessity** is supported by the completed [native-state evidence study](research/NATIVE_BLOCKED_STATE_PROBE.md) and version-qualified [engine findings](engine/GIANTS_RUNTIME_KNOWLEDGE.md). This is an evidence limitation, **not** an implemented recovery capability.

Future **Blocked Progress Qualification** remains under investigation in [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). It is not a currently implemented Specification Jurisdiction or a decision to restore former spatial-prediction machinery.

A new concept enters this live register only when its accepted Architecture gives it enduring meaning; research, issues, tests and source code cannot establish that authority by themselves.
