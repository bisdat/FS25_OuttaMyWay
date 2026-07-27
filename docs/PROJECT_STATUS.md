# Project Status

Version: 4.6.21

Authority state: Release Candidate — Base-Game Vehicle Semantic Catalogue Consolidation awaiting repository-owner review

Implementation baseline: exact canonical v4.6.20

Baseline SHA-256: `08000f111892e076fe68972ae08a129e652dacea77a8a2428b3739c212847a52`

Last canonical baseline: v4.6.20

Current focus: review and canonicalise the consolidated semantic catalogue; then design the Scope Overlay before selecting targeted structural challenges

## Completed evidence chain

The base-game vehicle research now forms one traceable chain:

```text
Vehicle Definition Corpus Extraction
    -> Raw Definition Evidence
    -> Selected-Field Inheritance Projection
    -> Runtime English Localisation
    -> Semantic Suggestion Cohorts
    -> Human Review and Asset Exceptions
    -> Reviewed Semantic Catalogue
```

The selected Stage 1 corpus contained 1,365 XML/I3D files from the base-game installation. Stage 2A identified 606 vehicle or implement definitions, including 41 inherited variants and three bundle definitions. The inherited variants contain arbitrary GIANTS `<set>` and `<remove>` operations, so the catalogue claims selected-field inheritance projection rather than a complete GIANTS merge implementation.

Readable installation and user-data search found references to all 567 localisation keys but no authoritative readable definitions. The temporary runtime probe then resolved all 567 keys in English through `g_i18n:getText`. The deliberately missing key returned a GIANTS missing-key diagnostic; the consolidation classifies that independently rather than trusting the probe's original `RESOLVED` label.

## Human semantic review result

The 606 definitions were grouped into 147 declared-function cohorts and split where type, category or role evidence required distinct treatment. This produced 170 review units:

- 166 `APPROVED` through Approval Inheritance;
- 2 `AMENDED`;
- 2 initially `DEFERRED`, then resolved by adding `LIQUID_TANK_TRAILER` and `FUEL_TRAILER`;
- 0 unresolved review units;
- 0 definitions without a reviewed semantic profile.

Propagation produced 600 definitions accepted from the initial suggestion, three definitions changed by human amendment and three definitions changed by the two vocabulary additions.

The accepted catalogue contains 11 broad families, 90 used primary roles and 42 used capabilities. Reviewer notes that mention likely scope remain preserved as evidence but are not formal scope assignments.

## Architectural result

A flat replacement category is insufficient. Each definition now carries a **Semantic Profile**:

```text
Primary Family
Primary Role
Secondary Roles
Capabilities
Evidence and Review Provenance
```

Role and capability remain orthogonal. Purchase category, declared GIANTS type and declared functions are preserved as evidence rather than promoted automatically to semantic truth.

Function cohorts are review anchors, not decisions. One cohort may require several review units, while asset-specific contradictions remain explicit exceptions.

Semantic classification is separate from:

- OuttaMyWay control eligibility;
- active Operation participation;
- attached-assembly relevance;
- obstacle relevance;
- physical-structure or representation difficulty.

## Candidate implementation state

- v4.6.21 adds a self-contained reviewed semantic research catalogue and deterministic consolidation script.
- The canonical v4.6.20 runtime implementation is otherwise unchanged.
- The repository contains no GIANTS proprietary source assets and no temporary diagnostic mod.
- Paid DLC and modded vehicle definitions remain parked.
- No Scope Overlay assignments have been made.
- No Prototype 13B fixture or implementation has been selected.

## Next gate

Discuss and define the **Scope Overlay** at the highest useful architectural level. At minimum it should determine separately whether a semantic role is:

1. eligible for active OuttaMyWay control;
2. eligible for active Operation membership;
3. relevant as part of an attached or integrated Physical Assembly;
4. relevant as a non-controlled obstacle.

Only after those dimensions are agreed should the catalogue be filtered for targeted structural challenge profiling and future Resolution Contract disproof fixtures.
