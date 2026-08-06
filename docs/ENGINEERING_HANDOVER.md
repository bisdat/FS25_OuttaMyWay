# Engineering Handover

> **Canonical baseline:** v4.7.13  
> **Candidate:** v4.7.14 Field World Equivalence Authority Implementation  
> **Control authority:** disabled

## Governing architecture

ADR-0021 and D-0033 govern Field World identity. Exact fingerprints remain immutable representation provenance. Authority outcomes are `SAME_FIELD_WORLD`, `DIFFERENT_FIELD_WORLD` and `UNRESOLVED`. Unresolved evidence receives no Operation or Control authority, and pairwise tolerance chaining is prohibited.

## Implementation boundary

v4.7.14 introduces two isolated responsibilities:

- `FieldWorldEquivalenceEvaluator` is pure and classifies one immutable Snapshot pair from compound spatial evidence;
- `FieldWorldEquivalenceAuthority` owns currently relevant Field World classes, enforces all-member coherence, assigns resolved Field World identities and retires classes after relevance ends.

`FieldWorldSnapshotRegistry` continues to own capture, canonical geometry, exact fingerprints and comparison measurements. `LiveObservationSource` resolves identity before grouping. `OperationAdmission` consumes resolved Field World identity and preserves all member Snapshot and exact-polygon references; it performs no geometry reasoning.

The SAME envelope is conservative implementation calibration. A failed SAME condition does not imply DIFFERENT. The first DIFFERENT path requires positive occupied-region separation. Every other ambiguous case is `UNRESOLVED`.

## Offline conformance

The suite proves exact equality, merged-workspace equivalence, disconnected separation, partial-overlap uncertainty, tolerance-chain rejection, lifecycle retirement, unresolved Operation exclusion and multi-representation Operation provenance. Existing replacement-core tests remain green. Control remains disabled.

## Next objective

Run one passive live test with concurrent workers seeded in merged areas 68–69–70. Confirm one resolved Field World and one active Operation while retaining distinct immutable Snapshot and polygon evidence. Preserve full logs. Do not modify thresholds from one run; contradictory evidence must be recorded before any implementation adjustment.
