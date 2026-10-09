# System Architecture

This is the **current** authority for the small 0.5 OuttaMyWay shell and its accepted design direction. Architecture describes what the system should achieve; Specifications define implementation-facing obligations; source implements those contracts; tests and GIANTS Reality challenge all three.

## Current boundaries

- [Project Vision](PROJECT_VISION.md) — preserve autonomous GIANTS fieldwork through the least disruptive justified intervention. Worker intervention is **not yet implemented**.
- [Blocked-First Situation Assessment and Hold & Relocate](BLOCKED_PROGRESS_QUALIFICATION.md) — the GIANTS native ≥1 s blocked trigger and nearest eligible worker within 30 m are implemented for candidate identification; the **accepted six-stage Hold & Relocate operating sequence** chooses the worker nearest the field centroid, uses a **5 s nearby-blocker Hold and a separate 10 s relocated-worker Hold released only by timers**, requires established GIANTS-native BWR steering for centroid-directed reverse ≤30 m + offset, **requests TRANSIT without awaiting fold/raise completion and reverses while configuration proceeds**, and immediately stops/restarts the AI job. Hold & Relocate is one architectural responsibility with one primary Specification; the live server runtime now independently validates Pair Commitment and drives GIANTS native mechanisms when admission evidence is complete; physical outcomes require in-game validation.
- [Configuration](CONFIGURATION.md) — durable player choices and consent to the current product shell.
- [Log Publication](LOG_PUBLICATION.md) — controlled publication of established product/engineering facts, not Observation or runtime decision authority.
- [GUI](GUI.md) — settings, version-only status indicator and disabled reminder; full operational messages remain deferred.

The running shell observes GIANTS native blocked state read-only and nominates a pair. The separate **live, server-side Pair Commitment authority** validates current jobs, field geometry and native blockage before a bounded Hold & Relocate runtime may hold, reverse or restart GIANTS workers. This is an implemented Control path, **not yet GIANTS in-game validated**. Player-control and takeover predicates are intentionally absent from this path as of TEST 0.5.0.25; native current-job identity and lifecycle remain mandatory. The observer performs no independent collision detection, and its diagnostic candidate is not Control authority. The experimental [native blocked-event tap](../docs/research/NATIVE_BLOCKED_EVENT_TAP.md) served its research purpose and was retired in TEST 0.5.0.6. Its Enabled state is not a claim that AI coordination exists. Passive Native Blockage Observation, Spatial Pair Inference and Hold & Relocate have distinct primary Specifications; broader Situation Assessment, Recovery or physical Control is not implemented.

The live path currently admits a pair only when a common GIANTS field polygon and centroid can be established, with an explicit zero offset and maximum 30 m reverse; no remote or cross-field Control is authorised. Native TRANSIT is requested without waiting for fold/raise completion. Missing/contradictory evidence fails closed.

## Deliberately unresolved

The six-stage Hold & Relocate path is live but its physical outcomes and supported assembly envelope require independent in-game validation. [Blocked-First Situation Assessment #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440) uses GIANTS native isBlocked and spatial pair inference; no independent collision-proof or course-progress prerequisite. [Standards reconciliation #441](https://github.com/bisdat/FS25_OuttaMyWay/issues/441) owns unresolved cross-surface questions.

Old predictive/regulation/passage/recovery designs are **not current architectural contracts**. Their history, code and original contracts are recoverable from [archive/0.4.11.0](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). This is a historical reference, not a breadcrumb to a live architecture document.
