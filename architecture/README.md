# System Architecture

This is the current navigation entry to OuttaMyWay's 0.5 responsibilities.
Architecture describes what the system should achieve; Specifications provide executable-facing obligations; source realises them; GIANTS Reality challenges each claim.

## Current boundaries

- [Project Vision](PROJECT_VISION.md) — preserve autonomous GIANTS fieldwork through minimal justified intervention.
- [Blocked-First Situation Assessment and Hold & Relocate](BLOCKED_PROGRESS_QUALIFICATION.md) — native ≥1 s blocked evidence and the nearest eligible other worker within 30 m; independently admitted Hold & Relocate chooses the worker nearer the field centroid, regulates its blocker to 1 km/h for 5 s, requests TRANSIT while GIANTS-native reverse begins, prefers field-inward Cross-Track Egress scaled to blocker working width + 5 m, Holds the relocated worker for 7 s, then immediately requests native FIELDWORK stop/start. No completed or failed job-attempt history is retained between collisions.
- [Configuration](CONFIGURATION.md) — supported player choices and consent.
- [Log Publication](LOG_PUBLICATION.md) — bounded runtime/engineering fact publication.
- [GUI](GUI.md) — current settings and status indication; full operational messaging deferred.

Field-validated TEST 0.5.1.3 (#461), GIANTS TS003 **PASS** on 9 October 2026, retains solo BWR **outside** field polygons and TRANSIT / 40 m oblique region / immediate FIELDWORK STOP/START, with no solo Hold timer. The preferred inward direction uses the **worker's native active course field**, never an adjacent field in the global registry. Paired mechanisms are unchanged. Native blocked Observation nominates candidates only. Independent commitment checks current GIANTS FIELDWORK jobs, field polygon and physical references before Control begins. The active shell does not invent native blockage or rebuild historic predictive Passage responsibilities.

## Deliberately unresolved

The GIANTS physical consequences of repeated Cross-Track Egress, fold configuration and FIELDWORK handback still require Reality validation under [issue #440](https://github.com/bisdat/FS25_OuttaMyWay/issues/440). [Standards reconciliation #441](https://github.com/bisdat/FS25_OuttaMyWay/issues/441) remains a separate responsibility.

Archived 0.4 source and evidence remain historical context under [archive/0.4.11.0](https://github.com/bisdat/FS25_OuttaMyWay/tree/archive/0.4.11.0).
