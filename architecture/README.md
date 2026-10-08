# System Architecture

This is the **current** authority for the small 0.5 OuttaMyWay shell and its accepted design direction. Architecture describes what the system should achieve; Specifications define implementation-facing obligations; source implements those contracts; tests and GIANTS Reality challenge all three.

## Current boundaries

- [Project Vision](PROJECT_VISION.md) — preserve autonomous GIANTS fieldwork through the least disruptive justified intervention. Worker intervention is **not yet implemented**.
- [Blocked-First Situation Assessment](BLOCKED_PROGRESS_QUALIFICATION.md) — GIANTS native isBlocked, ≥1 s and nearest eligible worker within 30 m; [Native Blockage Observation](../spec/NATIVE_BLOCKAGE_OBSERVATION.md) passively reads GIANTS, feeding [Spatial Pair Inference](../spec/SPATIAL_PAIR_INFERENCE.md), with no worker Control.
- [Configuration](CONFIGURATION.md) — durable player choices and consent to the current product shell.
- [Log Publication](LOG_PUBLICATION.md) — controlled publication of established product/engineering facts, not Observation or runtime decision authority.
- [GUI](GUI.md) — settings, version-only status indicator and disabled reminder; full operational messages remain deferred.

The running shell observes native blocked state **read-only** and uses a pure candidate evaluator, but does **not** regulate, hold, steer, stop, restart or relocate GIANTS workers. The observer performs no independent collision detection, and its diagnostic candidate is not Control authority. The experimental [native blocked-event tap](../docs/research/NATIVE_BLOCKED_EVENT_TAP.md) served its research purpose and was retired in TEST 0.5.0.6. Its Enabled state is not a claim that AI coordination exists. Passive Native Blockage Observation and Spatial Pair Inference are implemented as narrow Specifications; broader Situation Assessment, Recovery or Control is not.

## Deliberately unresolved

The 0.5 worker-cooperation architecture will be established through evidence before new implementation is authorised. [Blocked-First Situation Assessment #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440) uses GIANTS native isBlocked and spatial pair inference; no independent collision-proof or course-progress prerequisite. [Standards reconciliation #441](https://github.com/bisdat/FS25_OuttaMyWay/issues/441) owns unresolved cross-surface questions.

Old predictive/regulation/passage/recovery designs are **not current architectural contracts**. Their history, code and original contracts are recoverable from [archive/0.4.11.0](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). This is a historical reference, not a breadcrumb to a live architecture document.
