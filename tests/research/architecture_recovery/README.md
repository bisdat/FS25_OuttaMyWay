# Architecture Recovery Evidence

## Status

This directory preserves the evidence used by the v4.6.50 Architecture Recovery Candidate.

The files compare owner-declared canonical v4.6.43 with temporary non-canonical v4.6.44–v4.6.49. They do not grant runtime authority and do not promote the temporary controller implementation.

## Files

- `canonical_knowledge_inventory.csv` — 36 recovered canonical Knowledge entries and ownership expectations.
- `canonical_constraint_inventory.csv` — 28 recovered constraints and their v4.6.49 enforcement status.
- `discovery_reconciliation_v4.6.44-v4.6.49.csv` — 23 temporary discoveries classified as established architecture, refinement, capability, defect or enforcement gap.
- `hardcoded_authority_register_v4.6.49.csv` — 79 configured or embedded values classified by role, risk and proposed disposition.

## Governing interpretation

Recent executable code does not supersede canonical architecture merely because it is newer. Existing architectural Knowledge remains valid until evidence challenges it.

The experimental work is retained as an **Experimental Capability Corpus**:

```text
discovery retained
implementation not promoted
```

The next active implementation must begin from a passive, traceable architecture path rather than from further fixture-controller branching.
