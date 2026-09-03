# Base-Game Vehicle Semantic Catalogue

This directory preserves the reviewed semantic evidence produced while selecting future physical-representation test subjects.

## Result

The catalogue contains 606 Farming Simulator 25 base-game vehicle and implement definitions. Every definition has one human-reviewed semantic profile:

- 170 review units;
- 166 suggestions approved unchanged through the Approval Inheritance Rule;
- 2 review units amended;
- 2 deferred review units resolved by adding `LIQUID_TANK_TRAILER` and `FUEL_TRAILER`;
- 0 unresolved definitions.

The resulting catalogue contains 11 broad families, 90 used primary roles and 42 used capabilities.

## Evidence chain

```text
Base-game definition corpus
    -> raw definition evidence
    -> selected-field inheritance projection
    -> runtime English localisation
    -> semantic suggestions
    -> cohort review and asset exceptions
    -> reviewed semantic catalogue
```

`PROVENANCE.json` records the exact evidence-package and final-workbook fingerprints.

## Files

- `stage2c_semantic_assignments.csv` — the 606 machine-generated Stage 2C suggestions and preserved source evidence.
- `review_unit_decisions.csv` — the complete 170-unit human review, including final decisions and notes.
- `reviewed_semantic_catalogue.csv` — the propagated reviewed profile for every definition.
- `reviewed_semantic_vocabulary.csv` — accepted families, roles, capabilities and confidence terms for this corpus.
- `semantic_catalogue_summary.json` — validation counts and distribution.
- `PROVENANCE.json` — evidence identities and declared boundaries.
- `consolidate_review.py` — deterministic reconstruction of the reviewed catalogue from the two input CSV files.

## Architectural boundary

The semantic catalogue answers:

- what the asset is;
- what its principal role is;
- what additional capabilities it declares.

It does **not** answer:

- whether OuttaMyWay may control it;
- whether it may participate as an active Operation member;
- whether it must be represented as attached assembly geometry;
- whether it remains relevant only as an obstacle;
- how difficult its physical structure is to resolve.

Those are separate Scope Overlay and Structural Challenge questions.

## Effective-definition boundary

The catalogue is based on Raw Definition Evidence plus Selected-Field Inheritance Projection. The 41 inherited definitions contain arbitrary GIANTS `<set>` and `<remove>` operations. This research does not claim to reproduce the complete GIANTS parent-file merge system.

## Reproduce the consolidation

```text
python docs/research/vehicle_semantics/consolidate_review.py   --output /temporary/output
```

The generated catalogue and summary should match the repository-bundled outputs byte for byte.
