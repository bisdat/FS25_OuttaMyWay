# Vehicle Definition Corpus and Semantic Review

> **Status:** Reviewed evidence consolidated for candidate v4.6.21
>
> **Scope:** Farming Simulator 25 base-game vehicle and implement definitions only

## Purpose

The research began as test-subject mining for future Physical Representation prototypes. Its purpose is not to create a universal agricultural taxonomy. It establishes enough defensible semantic knowledge to select representation-diverse fixtures and later apply an explicit OuttaMyWay Scope Overlay.

## Stage 1 — Vehicle Definition Corpus Extraction

The authoritative installation corpus was the base-game vehicle directory, organised primarily by manufacturer rather than purchase category.

A read-only whitelist extraction selected XML and textual I3D files:

- source inventory: 10,695 files, approximately 17.61 GB;
- selected corpus: 1,365 files, approximately 58.76 MB;
- XML: 758;
- I3D: 607;
- represented asset/subasset folders: 750;
- manufacturer folders: 155.

Every selected file was size-verified and hash-verified. All selected XML and I3D files parsed.

The `.i3d.shapes` companions were intentionally excluded from this semantic stage. They remain relevant to later exact geometry work, not to purchase/function classification.

## Stage 2A — Definition Evidence Catalogue

The corpus contained 606 vehicle or implement definitions:

- 562 direct-model definitions;
- 41 inherited variants;
- 3 bundle or combination definitions.

All referenced parent definitions and selected I3D files were found.

### Effective Definition Boundary

The inherited definitions contain 516 arbitrary `<set>` and `<remove>` operations across many paths. Faithfully reproducing the complete effective XML would require implementing and validating GIANTS' full parent-file merge semantics.

The accepted claim is therefore:

> Raw Definition Evidence plus Selected-Field Inheritance Projection.

The projection preserves catalogue-relevant fields and provenance. It is not a complete merged vehicle definition.

### Evidence layers

The catalogue preserves:

- purchase category;
- declared GIANTS vehicle type;
- declared shop functions;
- localisation keys;
- XML feature-section evidence;
- parent-definition evidence;
- selected structural source;
- human interpretation.

Purchase category and declared type are contextual evidence, not semantic or structural contracts.

## Stage 2B — Runtime localisation

A read-only search inventoried 40,584 installation and user-data files. It found references to every one of the 567 required localisation keys but no authoritative readable definitions.

This established:

- **Readable-Source Exhaustion**;
- **Localisation Authority Opacity**;
- **User-Data Diagnostic Echo**.

A separate temporary diagnostic mod then queried the running game through `g_i18n:getText`. In the observed English FS25 1.20.0.0 runtime:

- 567 expected keys were emitted;
- 567 produced substantive English text;
- 0 echoed the raw key;
- 0 were empty, nil, unresolved or references.

The missing-key control returned:

```text
Missing '__omw_localisation_probe_missing_control__' in l10n_en.xml
```

The original probe incorrectly labelled this readable diagnostic `RESOLVED`. Consolidation independently classifies it as `EXPECTED_MISSING_KEY_DIAGNOSTIC`. None of the 567 real keys returned that pattern.

The temporary mod was archived by the repository owner and removed from the active FS mods folder. It is not part of OuttaMyWay.

## Stage 2C — Semantic normalisation

A flat category replacement was rejected. Definitions were represented as Semantic Profiles:

```text
Primary Family
Primary Role
Secondary Roles
Capabilities
Evidence and Review Provenance
```

This preserves **Role–Capability Separation**. A seeder may have `DIRECT_SOWING` and `FERTILISING` capabilities without becoming a fabricated combined role.

The initial suggestions used 147 declared-function cohorts. Evidence differences split those into 170 review units. This established:

> Function Cohort Is an Anchor, Not a Decision.

Human review then completed all 170 units:

| Outcome | Review units |
|---|---:|
| Approved unchanged | 166 |
| Human amendment | 2 |
| Vocabulary addition | 2 |
| Unresolved | 0 |

Approval Inheritance means an approved row accepts the complete suggestion unchanged even where replacement cells were blank.

The two amendments affected three definitions. The two vocabulary additions—`LIQUID_TANK_TRAILER` and `FUEL_TRAILER`—affected three definitions. The other 600 definitions inherited the approved suggestion.

## Reviewed catalogue

The final catalogue contains:

- 606 reviewed definitions;
- 11 broad families;
- 90 used primary roles;
- 42 used capabilities;
- 0 unresolved semantic profiles.

The machine-readable files and exact provenance are stored in `research/vehicle_semantics/`.

## Architectural boundary

Semantic classification answers what an asset is and what it can do. It does not decide:

- active OuttaMyWay control;
- active Operation membership;
- attached-assembly relevance;
- obstacle relevance;
- physical representation method;
- structural challenge.

This establishes **Semantic Classification–Scope Separation**, **Control Eligibility–Representation Relevance Separation** and **Catalogue–Structure Separation**.

A combine example illustrates the boundary: one independently working AI combine may be within project scope, while multiple AI combines and combine-to-trailer offloading coordination remain excluded. A header remains a semantic harvesting component and may be assembly-relevant without being an independent worker.

## Review-depth rule

The accepted review objective is **Minimum Sufficient Semantic Resolution**:

1. fully resolve likely in-scope and boundary cases;
2. resolve excluded but representation-relevant cases enough to support the exclusion and physical relevance decision;
3. use coarse exclusion for clearly irrelevant assets;
4. always correct materially wrong identity;
5. park refinements that cannot change an architectural conclusion.

This protects engineering time without weakening decision coverage.

## Deferred

- machine-readable Scope Overlay assignments and runtime evidence rules;
- paid DLC definitions;
- modded vehicle definitions;
- targeted Structural Challenge Profiles;
- scope-filtered Prototype 13B fixture selection.
