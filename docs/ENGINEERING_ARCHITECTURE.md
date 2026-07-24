# Engineering Architecture

## Purpose

This document defines how FS25_OuttaMyWay is engineered.

The immediate purpose of the development repository is to operate as a self-sustaining engineering knowledge system: sufficient current understanding, evidence, decisions and continuation guidance must survive independently of any chat, engineer, AI system or platform.

The longer-term purpose is to make the project understandable to intelligent contributors who did not participate in its discovery. These purposes are compatible: continuity requires explicit knowledge, and explicit knowledge is also what makes contribution possible.

## Scope

This architecture governs:

- separation of architecture, implementation and validation;
- the evidence-led development cycle;
- ownership and promotion of architectural concepts;
- repository knowledge responsibilities;
- canonical development releases;
- the relationship between architecture and tooling.

## Non-scope

This document does not define:

- vehicle-control algorithms;
- Lua implementation details;
- tuning values;
- test results;
- release history;
- the future public repository's final editorial scope.

Those belong in their own authoritative records.

## Principles

1. **Reality is the final architect.** When evidence contradicts the architecture, update the architecture.
2. **Architecture defines what the system should achieve.** Implementation discovers how it can be achieved. Validation supports or disproves the assumptions. Repository Review then tests whether the released knowledge system remains navigable, predictable and complete enough to continue.
3. **Optimise for understanding before behaviour.** Invest effort where it permanently reduces uncertainty or future complexity.
4. **Discover concepts; do not invent layers for implementation convenience.** A concept enters the architecture only when repeated observation shows that it explains behaviour better than existing concepts.
5. **Protect abstraction levels.** Architecture speaks in enduring concepts and responsibilities; implementation details must not silently redefine it.
6. **Name durable discoveries.** A stable name makes a recurring phenomenon available to the architecture.
7. **Celebrate disproven hypotheses.** A failed test is evidence that improves the model.
8. **Prefer ownership over special cases.** Repeated implementation difficulty may indicate a missing responsibility or concept.
9. **Preserve autonomous continuity through the least disruptive justified intervention.**
10. **The repository is the source of project knowledge, not the source of reality.** It records the project's current understanding and must change when reality disproves it.

## Vocabulary

### Observation
A fact read from the repository, game, logs, measurements, video or test environment without interpreting what should be done.

### Interpretation
A proposed explanation of one or more observations. Interpretations remain uncertain until supported by evidence.

### Hypothesis
A testable interpretation used to guide a bounded implementation or experiment.

### Decision
A deliberate project choice. A decision may govern process or implementation without becoming an architectural concept.

### Architectural Discovery
An evidence-supported understanding that changes the project's model of responsibilities, concepts or boundaries.

### Commitment
A persistent intention to perform an action. It owns creation, maintenance, completion and cancellation. Continuing Situation Assessment may test its validity but should not continuously rewrite it.

### Canonical Development Release
A complete, validated repository package that records current project knowledge and becomes the sole baseline for subsequent work.

### Document Authority
The role a document plays in the knowledge system: Canonical, Reference, Historical, Compatibility or Archive.

### Document Currency
The release in which a document was last reviewed for continued accuracy. Document currency is distinct from repository version and from the historical period a document describes.

### Engineering Continuity Test
A release challenge that asks whether a competent engineer can continue the project correctly using only the candidate repository.

### Architectural Review
The explicit review of Accepted, Deferred and Rejected concepts performed before every canonical development release.

## Engineering Cycle

```text
Observe → Discuss → Hypothesise → Decide → Implement → Validate → Engineering Consolidation → Repository Transition → Repeat
```

- **Observe:** collect facts before proposing change.
- **Discuss:** separate facts, interpretations, decisions and implementation ideas.
- **Hypothesise:** state what is expected and what evidence could disprove it.
- **Decide:** make the deliberate project choice that authorises a bounded transformation.
- **Implement:** make the smallest isolated change that can test the hypothesis while preserving architectural intent.
- **Validate:** compare expected and observed outcomes.
- **Engineering Consolidation:** promote durable architectural, implementation and operational knowledge into its authoritative repository homes, then review that promotion for completeness.
- **Repository Transition:** express the approved change as fingerprint-bound Engineering Intent, then use the local Repository Release System to transform the exact Canonical Repository Snapshot into a validated Release Candidate; independent review and explicit Canonicalisation remain human decisions.

Skipping directly from observation to implementation is discouraged because it allows implementation convenience to choose the architecture.

## Repository Knowledge Model

The development repository is intentionally richer than a future public distribution repository.

| Responsibility | Authoritative record |
|---|---|
| Engineering constitution | `ENGINEERING_ARCHITECTURE.md` |
| Current project snapshot and continuation point | `PROJECT_STATUS.md` and `ENGINEERING_HANDOVER.md` |
| Current concept state | `CONCEPT_REGISTER.md` |
| Significant project choices and rationale | `DECISION_LOG.md` and ADRs |
| Evolving evidence and discoveries | `ENGINEERING_JOURNAL.md`, test records and design history |
| Driving-system architecture | `ARCHITECTURE.md`, `DESIGN.md` and the handbook |
| Release history | root and documentation changelogs |
| Repository transformation and evidence | `REPOSITORY_RELEASE_SYSTEM.md` and `rrs/` |

Every enduring item should have one authoritative home. Other documents may reference it, but should not create competing definitions.

### Development Repository

The development repository preserves:

- current knowledge required for seamless continuation;
- why the architecture evolved;
- disproven hypotheses and validation evidence;
- internal handovers and release machinery;
- implementation and diagnostics.

### Future Public Repository

A future GitHub or ModHub-facing repository may present a narrower, contributor-oriented view. Removing development history is a publication decision, not a reason to omit knowledge from the canonical development repository now.


## Document Governance

Every first-class document must have one purpose, one authority classification, one lifecycle state and a discoverable route from `docs/README.md`.

| Authority | Meaning | Version treatment |
|---|---|---|
| Canonical | Current project truth within a named responsibility | Current-state fields must match the release where specified |
| Reference | Enduring knowledge used by current engineering | No rolling repository version; record last-reviewed currency where useful |
| Historical | Accurate evidence for the period described | Preserve historical version or period |
| Compatibility | Old path retained only to redirect readers | No independent authority or release version |
| Archive | Preserved knowledge that is no longer authoritative | Preserve provenance and archive date |

Current-state documents must identify the active canonical version. Enduring references must not imply that their content version equals the package version. A `Last reviewed for canonical release` field records currency without rewriting history.

Documents move through an explicit lifecycle: Active → Superseded → Compatibility or Archive. Archiving preserves knowledge; compatibility preserves a route. They are not synonyms.

The documentation map must classify every first-class Markdown document. The reader journey is part of the architecture: each breadcrumb should answer the next natural question rather than require prior conversational knowledge.

## Architectural Governance

Concepts are governed through three registers:

- **Accepted:** evidence supports an independent concept, responsibility or lifecycle.
- **Deferred:** potentially useful, but evidence is insufficient to justify architectural status.
- **Rejected:** considered and deliberately excluded, with reason and reconsideration conditions recorded.

At every canonical release:

1. review all three registers;
2. compare them with new observations and validation results;
3. promote, defer or reject only with recorded evidence;
4. update dependent architecture documents;
5. record the review outcome even when no concept changes.

Architecture is not defended because it already exists. It remains provisional against reality.

## Canonical Release Contract

A canonical development release must satisfy all of the following:

1. Current status and handover describe the same version and continuation point.
2. `modDesc.xml`, `scripts/config.lua` and `PROJECT_STATUS.md` contain the target version.
3. Both changelogs contain a target-version release heading.
4. The concept register has been reviewed for the release.
5. Significant discoveries and decisions have been recorded in their authoritative homes.
6. The repository verifier passes.
7. The SHA-256 manifest is regenerated from the final repository contents.
8. The release pipeline passes.
9. The ZIP contains the complete repository with `modDesc.xml` at its root.
10. The resulting ZIP becomes the only canonical baseline for subsequent work.
11. The Engineering Continuity Test passes from the repository alone.
12. Every first-class document is classified and discoverable through the documentation map.
13. The packaged ZIP passes an independent Repository Identity Check.
14. Repository Review findings are recorded as evidence for the next architecture cycle.
15. After explicit Canonicalisation, the local Git repository is synchronised to the exact accepted package, committed, pushed and confirmed clean before further engineering begins.

Any modification to the repository shall begin with the current canonical repository being supplied as the implementation baseline. Any change to code, documentation, tooling or package content requires a new version and a complete canonical package. Canonical releases are immutable once issued.

## Tooling Boundary

Tooling enforces selected properties of this architecture; it does not define them.

A check that is not automated remains an engineering obligation. A passing tool cannot prove that the architecture is correct; it can only prove that specified repository invariants were satisfied.


## Repository Release Governance

An **Engineering Increment** is the bounded unit of engineering purpose. It closes at a coherent breakpoint established by engineering judgement; time, chat boundaries and version numbering do not define completion.

After an increment closes, Engineering Consolidation promotes its durable knowledge. The resulting approved change is expressed as declarative **Engineering Intent** rather than direct repository modification by the consolidation author. Repository Transition then begins only from the exact **Canonical Repository Snapshot** identified by integrity fingerprint. The Repository Release System governs three distinct authority states: Working, Release Candidate and Canonical. Version identity and Git working state do not themselves confer authority.

Candidate Production is the Engineering Transformation that applies the fingerprint-bound Engineering Intent to the Canonical Repository Snapshot. Review acceptance and Canonicalisation are separate human decisions. Candidate-to-canonical processing is an Authority Transformation and must not alter approved substantive engineering content. Only the repository owner may declare the exact reviewed candidate canonical.

The RRS is the execution boundary that makes repository evolution independent of the consolidation author's file-editing environment. It produces provenance, declared and observed change, repository findings and validation evidence so that review can concentrate on engineering judgement.

For the same exact Canonical Repository Snapshot and fingerprint-bound Engineering Intent, Candidate Production must emit one byte-identical candidate package across supported execution platforms. Evidence packages retain execution provenance and may differ in non-substantive run metadata, but must identify the same candidate and agree on substantive findings. Authorship does not confer approval, and authority states may be entered only through their defined gates. The detailed state model, roles, gates and findings are owned by `REPOSITORY_RELEASE_SYSTEM.md`; the executable candidate-production boundary is owned by `rrs/`.
