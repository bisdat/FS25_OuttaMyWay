# ADR-0021 — Field World Equivalence Authority

**Status:** Accepted architecture; implemented and live-validated by canonical v4.7.14  
**Canonical implementation baseline:** owner-declared v4.7.13  
**Implementation status:** live-validated for merged, disconnected and contiguous Field World cases; Control remains disabled

## Context

A Job Episode captures an immutable GIANTS-generated polygon representing the contiguous agronomic workspace experienced at work onset. v4.7.12 closure evidence established two materially different cases:

- four captures seeded across the merged 68–69–70 workspace produced four different exact fingerprints while remaining spatially near-identical;
- the two disconnected portions retaining player-facing locator 77 produced spatially distinct polygons with zero sampled overlap.

Exact representation identity therefore cannot serve as complete Field World identity authority. Conversely, source field number, farmland identity and seed position cannot establish the experienced workspace.

## Decision

A **Field World** is identified by the experienced contiguous agronomic workspace represented by one or more immutable Job-Seeded Field World Snapshots.

Field World Equivalence Authority evaluates a Snapshot against established Field World evidence and produces exactly one outcome:

- `SAME_FIELD_WORLD`;
- `DIFFERENT_FIELD_WORLD`;
- `UNRESOLVED`.

### Representation provenance

Every Job Episode retains its original Snapshot, canonical polygon representation, exact fingerprint, capture provenance and player-facing locators. Recognising equivalence does not merge, rewrite or discard Snapshot evidence.

Exact canonical geometry equality is sufficient for `SAME_FIELD_WORLD`. An exact fingerprint remains a compact representation reference and collision detector; fingerprint equality alone does not independently establish Field World identity.

### Positive identity evidence

`SAME_FIELD_WORLD` requires coherent positive evidence that the Snapshots represent materially the same contiguous agronomic workspace. The evidence must address compatible connected topology, reciprocal workspace coverage, bounded representation variation and absence of a materially exclusive region.

No single measurement—including fingerprint, sampled overlap, bounds, area, perimeter, centroid, point count, containment or boundary distance—may establish identity alone.

### Positive separation evidence

`DIFFERENT_FIELD_WORLD` requires positive evidence of materially different workspaces, such as disconnected occupied regions, substantial mutually exclusive area, incompatible topology or separation inconsistent with representation variation. A shared player-facing field number or farmland does not weaken that result.

### Uncertainty and authority

Insufficient, contradictory or partially overlapping evidence produces `UNRESOLVED`. An unresolved Snapshot remains observable but receives no authority to join or establish an Operation and cannot extend Control authority.

### Coherence

A Snapshot may join an established Field World only when it is compatible with the accepted evidence for that Field World as a whole. Equivalence with one member alone is insufficient. Pairwise tolerance chaining must not create an incoherent identity class.

### Operation lifecycle

Operation admission consumes resolved Field World identity. The Field World relation does not make successive Operations the same Operation: an Operation remains ephemeral and ends according to its own membership and settlement lifecycle.

### Supported-world boundary

The active Job Episode Snapshot remains immutable. Field merging or splitting during that episode is not reconciled. A restarted or replacement Job Episode captures current Reality.

## Consequences

- D-0030's exact-fingerprint Field World and Operation identity authority is superseded.
- Exact fingerprints remain necessary representation provenance and diagnostic evidence.
- The v4.7.12 spatial metrics remain evidence sources, not an architectural threshold formula.
- v4.7.14 implements pairwise evaluation and class-wide authority using conservative compound calibration rather than one architectural threshold.
- Operation grouping consumes resolved Field World identity; unresolved evidence receives no Operation authority.
- Offline fixtures conform. Passive live validation remains required, and Control remains disabled.
