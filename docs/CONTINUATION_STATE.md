# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

Continue reviewing the remaining live documentation responsibility surfaces
after completing the ADR-corpus responsibility review.

## Established

- The ADR corpus exhibited **Decision Record Authority Drift**: historically useful rationale and provenance coexisted with normative/status language that no longer represented current architecture.
- **Decision Responsibility Succession** is accepted. `DECISION_LOG.md` owns the live record of significant project decisions and rationale; current architecture owns present normative meaning; the Concept Register owns current concept state.
- The **Stranded Live Knowledge** check was performed across ADR-0001 through ADR-0023 before retirement. Field World Equivalence Authority, Demonstrated Traversability, and GIANTS field-worker permission semantics were the remaining current items requiring fuller live homes; other current meanings already reside in architecture, the Concept Register, Decision Log, Engine Knowledge, engineering/process documentation, code knowledge, Journal/research, or Git history.
- **Field World Equivalence Authority** is now defined in Runtime Responsibility Architecture and indexed in the Concept Register.
- **Demonstrated Traversability** is now defined in Physical Representation Architecture and indexed in the Concept Register.
- GIANTS field-worker continuation permission and its Constraint Semantics Mismatch are now recorded in Engine Knowledge.
- The ADR corpus was removed after coverage and live-reference repair. It was not copied to archive. Git owns the exact historical ADR records and chronology; plain ADR identifiers may remain as provenance.
- No runtime behaviour or tests changed.
- **Structure-Test Responsibility Drift** remains separate: structural tests retain assertions for retired live documents. The pre-existing result remains 93 passing and 11 failing tests; ADR retirement exposes `ADR-0023` as a further stale dependency in two tests within that same failing set. This drift is not repaired here and remains a future test-governance concern. Retired ADRs or other documents must not be restored merely to satisfy stale tests.

## Current boundary

Decision history, current architecture, current concept state, and Git history
now have distinct owners. Removing the harvested ADR container does not erase
historical provenance or revive superseded Situation, Encounter, Refuge,
Future-Space, waiting, or settling architecture.

## Next boundary

Review remaining live documentation responsibility surfaces for stale,
overlapping, or weakly placed knowledge, one bounded responsibility at a time.
Do not define a runtime-reconstruction or test-governance increment here.

## Not currently active

- Runtime implementation or test changes.
- Release preparation, packaging, publication, or canonicalisation.
- Restoring retired documents to satisfy stale references.
- Reorganising `docs/archive/`.
