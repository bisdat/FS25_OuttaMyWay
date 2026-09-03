# Continuation State

Continuation State is the compact, replace-in-place description of the
project's present engineering boundary. Git history preserves prior states; this
is not a changelog, release ledger, or canonical-release record.

## Current engineering concern

Continue reviewing the remaining live documentation responsibility surfaces
after establishing breadcrumb governance and reusable engine knowledge.

## Established

- The **Live Breadcrumb Invariant** is accepted: every live documentation folder README links each direct intentionally retained live document and each immediate live documentation subfolder. Direct-child navigation is sufficient. A missing link is an Orphan Signal requiring responsibility review, not automatic deletion.
- The **Archive Navigation Exemption** is accepted. `docs/archive/` is outside the live breadcrumb tree, has no current authority, and is not a primary route from `docs/README.md`. It remains temporary recovery/harvesting material, not permanent storage.
- `docs/50_Research/` has been renamed to `docs/research/`; its README owns the direct research breadcrumbs. Research remains evidence and does not establish current architectural authority.
- `docs/engine/` now owns reusable GIANTS/FS25 runtime behaviour and observed or inspected API/surface knowledge. Engine facts do not define OuttaMyWay architecture or grant runtime authority.
- The durable engine content formerly mixed into `AI_DISCOVERIES.md` and `GIANTS_AI_NOTES.md` has been harvested by subject into Runtime Knowledge and API Surfaces. Architecture, decisions, implementation defects, fixture evidence, and chronology remain owned by architecture, the Concept Register, Decision Log, Journal, research, prototypes, code, and Git; the two overlapping source files have no remaining live responsibility.
- `LOCALISATION.md` remains live policy. The detailed readable-source and 567-key runtime experiment remains in the Vehicle Definition Corpus research record and is linked as evidence rather than duplicated into policy.
- ADR, diagnostics, prototypes, representation evidence, architecture, code, engine, and research folders have local breadcrumb owners.
- This engineering increment changes documentation only. No Lua, XML, test, fixture, release, or runtime behaviour is changed, and no in-game validation is claimed.

## Current boundary

Breadcrumb completeness establishes intentional discoverability, not semantic
authority and not proof that every retained document is correctly placed.
Archive remains exempt. Engine observations are reusable evidence with explicit
safe-use and non-inference limits, separate from OuttaMyWay's current
architecture.

## Next boundary

Review remaining live documentation responsibility surfaces for stale,
overlapping, or weakly placed knowledge. Reconcile one bounded responsibility
at a time; do not select runtime implementation changes unless a separate
architecture-to-code discrepancy is established.

## Not currently active

- Runtime implementation changes.
- Release preparation, packaging, publication, or canonicalisation.
- Declaring the entire documentation corpus reconciled.
- Reorganising or treating `docs/archive/` as permanent storage.
