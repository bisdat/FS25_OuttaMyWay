# Engineering Handover

## Authority state

v4.6.20 is the exact canonical baseline for this increment. Canonical SHA-256:

```text
08000f111892e076fe68972ae08a129e652dacea77a8a2428b3739c212847a52
```

v4.6.21 is a noncanonical Base-Game Vehicle Semantic Catalogue Consolidation candidate awaiting repository-owner review.

The candidate adds research data and enduring architectural knowledge only. Runtime behaviour is unchanged apart from package version metadata.

## Consolidated research result

The repository now contains a self-contained semantic evidence set under `research/vehicle_semantics/`:

- `stage2c_semantic_assignments.csv` — 606 machine-generated suggestions with preserved source evidence;
- `review_unit_decisions.csv` — the complete 170-unit human review and notes;
- `reviewed_semantic_catalogue.csv` — one propagated reviewed profile per definition;
- `reviewed_semantic_vocabulary.csv` — accepted vocabulary for the current base-game corpus;
- `semantic_catalogue_summary.json` and `PROVENANCE.json`;
- `consolidate_review.py` — deterministic reconstruction of the final catalogue.

The source chain is bound by hashes recorded in `PROVENANCE.json`. No proprietary GIANTS game asset is included.

## Accepted review result

The final review contained:

- 166 approved review units;
- 2 amended review units;
- 2 deferred units resolved through vocabulary additions;
- 0 unresolved units;
- 606 reviewed definitions.

Approval Inheritance means `APPROVED` accepts the complete suggested profile unchanged. Blank replacement fields are intentional and do not mean missing data.

The two human amendments were:

- `SC-R054` -> `FORESTRY / TIMBER_TRAILER`;
- `SC-R112` -> `CROP_CARE / SLURRY_DISTRIBUTOR`, secondary `CULTIVATOR`, capability `FERTILISING`.

The two vocabulary additions were:

- `SC-R139` -> `TRANSPORT_AND_LOGISTICS / LIQUID_TANK_TRAILER`, capability `LIQUID_TRANSPORT`;
- `SC-R140` -> `SUPPORT_AND_UTILITY / FUEL_TRAILER`, capability `LIQUID_TRANSPORT`.

Reviewer scope notes are retained but remain observations for the next stage rather than final scope decisions.

## Architectural boundaries

Use **Semantic Profile, Not Category**. Preserve primary family, primary role, secondary roles and capabilities separately.

Use **Function Cohort Is an Anchor, Not a Decision**. Cohorts reduce review effort, but evidence may require split review units or asset exceptions.

Use **Semantic Classification–Scope Separation** and **Catalogue–Structure Separation**:

```text
Reviewed Semantic Catalogue
    -> Scope Overlay
        -> control / participation / assembly / obstacle relevance
            -> targeted Structural Challenge Profile
                -> representation-diverse fixture selection
```

A semantic family or role must not silently determine physical structure. Conversely, clear exclusion from active control does not necessarily remove obstacle or attached-assembly relevance.

## Next discussion

Do not begin another broad spreadsheet review or Prototype 13B implementation.

First discuss the Scope Overlay concepts and decision dimensions. The current working proposal separates:

- Control Eligibility;
- Operation Participation;
- Assembly Relevance;
- Obstacle Relevance.

Test whether these dimensions describe the experienced world before implementing scope assignments. Then apply Minimum Sufficient Semantic Resolution: fully review likely or boundary cases, establish only exclusion-supporting detail for representation-relevant exclusions, and avoid exhaustive taxonomy where no architectural conclusion can change.

After the Scope Overlay is reviewed, profile structural challenges only for control-eligible, assembly-relevant or obstacle-relevant assets plus a limited set of disproof controls.
