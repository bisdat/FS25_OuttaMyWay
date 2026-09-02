# Continuation State

Continuation State is the compact, replace-in-place description of the project's present engineering boundary: what workstream is active, what is currently understood, what remains unresolved, and what bounded question should be addressed next.

This document is the current engineering continuation authority. Replace its state in place as accepted engineering changes; do not append earlier current states. Git history preserves its prior forms. Continuation State is not a changelog, release record, test ledger or canonical-release record.

## Current engineering concern

Semantic reconciliation of the documentation corpus by knowledge responsibility.

## Established

- `docs/architecture/` owns the current accepted system and runtime architecture set.
- `docs/ENGINEERING_ARCHITECTURE.md` owns engineering governance.
- `docs/code/README.md` is the implementation-navigation route.
- Ordinary engineering proceeds from clean, current accepted `main` through bounded branch and pull-request increments.
- Canonicalisation is a separate, deliberate Release Declaration process.
- `docs/PROJECT_STATUS.md` and `docs/ENGINEERING_HANDOVER.md` are historical ledgers, not current continuation authority.
- This documentation-reconciliation work has selected no runtime behaviour change.
- `DESIGN.md` and the identified replacement-core contract family have been
  semantically classified as historical lineage and moved into transitional
  archive staging.
- Obsolete live implementation does not preserve superseded documentation's
  architectural authority. Mutual consistency between the two is not current
  validation.
- Archived files remain candidates for deletion after knowledge harvesting and
  reference/dependency closure; Git is the permanent historical record.

## Current boundary

Continue semantic classification of the unreconciled documentation corpus. Determine which knowledge remains current, which is evidence or history, which belongs in another authoritative home, and which can eventually be retired. Do not classify documents from filenames alone. No runtime behaviour change is active.

## Next boundary

The next semantic boundary is `docs/ARCHITECTURE_CODE_ALIGNMENT.md`. Audit it
to harvest genuinely current v0.3 architecture-versus-implementation-gap
knowledge before classifying its accumulated historical alignment ledger.

## Not currently active

- Runtime implementation changes.
- Release preparation or canonicalisation.
- Final historical placement or disposition of the old status and handover ledgers.
- RRS tooling audit.
- Broad documentation filesystem reorganisation.
