# Engineering Handover

> **Canonical baseline:** v4.7.12  
> **Candidate:** v4.7.13 Field World Equivalence Authority Architecture  
> **Control authority:** disabled

## Accepted architecture

ADR-0021 and D-0033 govern Field World identity:

- immutable Job-Seeded Field World Snapshots remain the evidence source;
- exact canonical geometry and fingerprints remain representation provenance;
- Field World identity requires coherent positive spatial equivalence;
- authoritative outcomes are `SAME_FIELD_WORLD`, `DIFFERENT_FIELD_WORLD` and `UNRESOLVED`;
- unresolved evidence grants no Operation admission or Control authority;
- pairwise tolerance chaining is prohibited;
- Operations remain ephemeral even when they occur in the same Field World;
- mid-episode field mutation remains outside the supported-world contract.

## Evidence retained

Merged 68–69–70 is the positive same-world fixture: four different exact fingerprints, identical bounds/topology and near-identical spatial evidence.

Split 77 is the negative fixture: two disconnected workspaces retaining the same locator, materially different geometry and zero sampled overlap.

## Implementation boundary

v4.7.13 is documentation-only except for version metadata and comments. The runtime still groups Operations by exact fingerprint. Do not present that mechanism as architecture and do not enable Control.

## Next objective

Design the implementation of Field World Equivalence Authority against the existing immutable snapshots and comparison evidence. The design must satisfy positive same-world evidence, positive separation evidence, explicit unresolved state and Field-World-wide coherence before code changes are accepted.

Do not reopen the architectural semantics unless implementation evidence demonstrates a genuine contradiction.
