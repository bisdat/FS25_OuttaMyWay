# OuttaMyWay

OuttaMyWay is a work-in-progress Farming Simulator 25 mod intended to preserve autonomous GIANTS fieldwork when workers compete for local space. GIANTS retains productive routing and normal AI jobs; the product goal is to minimise justified intervention and return authority as soon as possible.

## Current product

The accepted product observes current GIANTS field-course blockage and may admit bounded **Hold & Relocate** assistance for qualified active-worker pairs, solo blocked workers or stationary physical blockers. Following positively confirmed native FIELDWORK completion, **Completion TRANSIT** independently requests native transport configuration, while **Completion Parking** may admit separately qualified physical movement of the complete assembly. GIANTS retains productive routing, normal AI jobs and native job-completion authority. These capabilities do not constitute predictive traffic coordination or guaranteed physical resolution.

Persistent **Configuration** exposes Enabled, Operational messages and Debug through GIANTS General Settings. Enabled supplies master consent but never independently authorises movement; each intervention requires fresh evidence, separate admission and bounded Control. The dedicated Full Completion Parking setting is architecturally accepted but not yet implemented. Log Publication, the version-only Product Status Indicator and the Disabled Startup Reminder are present; the broader Operational Player Messages and in-game Help surfaces remain outstanding.

The earlier 500 ms native-state probe and [TEST 0.5.0.5 blocked-event tap](docs/research/NATIVE_BLOCKED_EVENT_TAP.md) are retired instruments. Their evidence remains in [Research](docs/research/NATIVE_BLOCKED_STATE_PROBE.md) and version-qualified [GIANTS Engine Knowledge](docs/engine/GIANTS_RUNTIME_KNOWLEDGE.md). They must not be confused with the current [Native Blockage Observation](spec/NATIVE_BLOCKAGE_OBSERVATION.md).

## Engineering breadcrumbs

- [Architecture](architecture/README.md) — the current responsibility model, scope and authority boundaries.
- [Specification](spec/README.md) — implementation-facing contracts for active responsibilities.
- [Engineering start here](docs/README.md) — standards, validation methodology, engine evidence and research.
- [Current source entry](scripts/main.lua) — explicit composition of the active runtime and product interfaces.
- [Executable contract tests](tests/README.md) — the current CI boundary and historical fixture status.

The pre-rewrite implementation is preserved in the immutable [archive/0.4.11.0 Git branch](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0). It remains historical evidence, not a competing current implementation. Current native-blockage and recovery responsibilities are described in [System Architecture](architecture/BLOCKED_PROGRESS_QUALIFICATION.md), with validation limits in their governing Specifications and GIANTS evidence.
