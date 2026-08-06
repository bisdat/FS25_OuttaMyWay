# Architecture Conformance Matrix

| Concern | ADR-0021 requirement | v4.7.14 candidate state | Status |
|---|---|---|---|
| Snapshot evidence | immutable per Job Episode | unique Snapshot references and immutable capture retained | conforming offline |
| Exact representation | provenance, not independent identity authority | canonical polygon reference and fingerprint retained separately | conforming offline |
| Field World authority | coherent positive spatial equivalence | dedicated evaluator and stateful authority | conforming offline |
| Authority outcomes | same, different or unresolved | all three outcomes executable and tested | conforming offline |
| Coherence | evaluate accepted Field World evidence as a whole | candidate compared with every class member | conforming offline |
| Tolerance chaining | must not create incoherent identity | mixed class result remains unresolved | conforming offline |
| Operation grouping | consume resolved Field World identity | live grouping uses resolved Field World reference | conforming offline; live evidence pending |
| Operation provenance | retain all member representations | Snapshot and polygon reference arrays retained | conforming offline |
| Unresolved evidence | no Operation or Control authority | isolated observation group; no recognized membership | conforming offline |
| Lifecycle | retire identity evidence when relevance ends | class retirement tested | conforming offline |
| Mid-episode mutation | unsupported; Snapshot fixed | retained immutable | conforming |
| Control | disabled until identity authority is live-validated | enforced | conforming |

## Validation fixtures

| Fixture | Required result | v4.7.14 result |
|---|---|---|
| exact canonical geometry, distinct captures | `SAME_FIELD_WORLD` | passed offline |
| four merged 68–69–70 representations | one Field World and one Operation | passed offline fixture |
| disconnected split-77 representations | two Field Worlds and two Operations | passed offline fixture |
| ambiguous partial overlap | `UNRESOLVED`, no Operation authority | passed offline |
| A same B, B same C, A unresolved C | C rejected from A–B class | passed offline |
| last relevant Job Episode ends | class retires; later capture mints new identity | passed offline |

## Remaining gate

Offline conformance does not prove GIANTS live polygon generation and lifecycle timing compose identically. Passive concurrent validation in the merged 68–69–70 workspace remains required before this authority is treated as live-proven.

> **Architecture currency:** canonical v4.6.78 Replacement-Core Architecture as extended by ADR-0021.  
> **Implementation baseline:** owner-declared canonical v4.7.13.  
> **Control authority:** disabled.
