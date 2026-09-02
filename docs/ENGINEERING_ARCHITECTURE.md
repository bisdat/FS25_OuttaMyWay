# Engineering Architecture

## Purpose

This document defines how FS25_OuttaMyWay is engineered and how reviewed repository work becomes accepted or, at deliberately selected checkpoints, canonical.

The repository is a self-sustaining engineering knowledge system. Current understanding, evidence, decisions and continuation guidance must survive independently of any chat, engineer, AI system or platform and remain understandable to contributors who did not participate in discovery.

## Scope

This architecture governs:

- separation of architecture, implementation and validation;
- the evidence-led engineering lifecycle;
- repository acceptance and release canonicalisation;
- ownership and promotion of architectural concepts;
- repository knowledge and document responsibilities;
- runtime evidence governance; and
- the boundary between repository authority, tooling and publication.

It does not define vehicle-control algorithms, Lua implementation, tuning values, individual test results, release history or external publication requirements. Those belong in their own responsible records.

## Principles

1. **Reality is the final architect.** When evidence contradicts architecture, update the architecture deliberately.
2. **Architecture, implementation and validation are distinct.** Architecture defines what the system should achieve. Implementation discovers how it may be realised. Validation supports or disproves the assumptions.
3. **Optimise for understanding before behaviour.** Invest where work permanently reduces uncertainty or future complexity.
4. **Discover concepts; do not invent layers for implementation convenience.** A concept enters architecture only when evidence shows that it explains responsibility better than existing concepts.
5. **Protect abstraction levels.** Implementation detail must not silently redefine architecture.
6. **Name durable discoveries.** Stable names make recurring phenomena available to engineering.
7. **Celebrate disproven hypotheses.** Failed validation is evidence that improves the model.
8. **Prefer ownership over special cases.** Repeated implementation difficulty may reveal a missing responsibility.
9. **Preserve autonomous continuity through the least disruptive justified intervention.**
10. **The repository records project knowledge; it does not create Reality.**

## Engineering vocabulary

### Observation

A fact read from the repository, game, logs, measurements, video or test environment without interpreting what should be done.

### Interpretation

A proposed explanation of observations. It remains uncertain until supported by evidence.

### Hypothesis

A testable interpretation used to guide a bounded implementation or experiment.

### Decision

A deliberate project choice. A decision may govern process or implementation without becoming an architectural concept.

### Architectural Discovery

Evidence-supported understanding that changes the model of responsibilities, concepts or boundaries.

### Engineering Increment

A bounded unit of engineering purpose whose implementation and effects can be reviewed and attributed. Chat boundaries and version numbers do not define it.

### Accepted Repository State

**Accepted Repository State** is the exact current `main` commit after reviewed Engineering Increments have been merged. It is the normal baseline for subsequent engineering.

Accepted `main` may be newer than the latest canonical release. This is normal. A pull-request merge advances accepted repository state but does not, by itself, declare a canonical release.

## Engineering lifecycle

```text
Observe
  ↓
Discuss
  ↓
Hypothesise
  ↓
define bounded Engineering Increment
  ↓
branch from clean/current main
  ↓
Implement
  ↓
Validate
  ↓
Record
  ↓
PR Review
  ↓
repository owner accepts by merge
  ↓
Accepted Repository State (main)
  ↓
Repeat
```

- **Observe:** collect facts before proposing change.
- **Discuss:** separate observations, interpretations, hypotheses and implementation ideas.
- **Hypothesise:** state what is expected and what evidence could disprove it.
- **Define:** bound the increment so intentional effects are attributable.
- **Implement:** make the smallest constructive change that tests the hypothesis while preserving architectural intent.
- **Validate:** compare expected and observed outcomes at the appropriate implementation and Reality levels.
- **Record:** promote durable architecture, implementation knowledge, evidence and decisions into their responsible repository homes.
- **Review:** inspect the complete increment through a pull request.
- **Accept:** the repository owner's merge makes the result part of accepted `main`.

Failed validation returns work to the engineering loop. It does not invoke release or canonicalisation machinery.

## Repository workflow and provenance

Ordinary Engineering Increments begin from clean, current `main`, proceed on a short-lived branch and are reviewed by pull request. The repository owner accepts an increment by merging it. Git branch, commit and pull-request history provides repository provenance.

Normal engineering does not require a canonical ZIP, package fingerprint, candidate-production transform or new release version. It does not pause merely because accepted `main` is newer than the last named release.

## Canonical release governance

### Canonical Is a Release Property, Not a Document Property

**Canonical** is reserved for a deliberately selected, named, immutable release checkpoint represented by one exact Git commit.

Canonical does not mean a current document, current architecture truth, an accepted PR, current `main`, file freshness or the mandatory starting point for ordinary engineering. Repository responsibility and breadcrumbs identify current architecture authority; accepted `main` supplies its exact content.

The latest owner-declared canonical release remains v0.3.0.0. Current accepted engineering after that checkpoint does not silently create another release.

### Canonical Merge

**A Canonical Merge is the repository owner's intentional merge of an explicitly designated Release Declaration PR. That merge declares the resulting exact `main` commit to be the canonical repository checkpoint for the named version.**

```text
Accepted Repository State
       ↓
owner and engineering collaborator agree a named release is warranted
       ↓
Release Declaration Engineering Increment
       ↓
release branch and explicitly designated PR
       ↓
release-specific review and validation
       ↓
OWNER MERGES THE RELEASE DECLARATION PR
       ↓
resulting exact main commit
= canonical named release
```

Not every merge is canonical. Only a PR explicitly designated in advance as a **Release Declaration PR** carries this authority. Its body must state unambiguously, in substance:

> If the repository owner merges this PR, that merge constitutes the explicit declaration that the resulting `main` commit is canonical `<version>`.

The owner's merge is the declaration; no second declaration is required. A later Git tag or GitHub Release may record or reference the checkpoint but does not create authority or change repository bytes.

### Release Declaration PR responsibility

A Release Declaration PR should be intentionally boring. Substantive architecture, implementation and validation normally enter accepted `main` through preceding Engineering Increments.

The declaration increment changes only material genuinely required to express release identity, such as runtime version metadata, `CHANGELOG.md`, or another first-class release record whose responsibility requires it. It does not stamp every engineering document with the release version or proliferate package fingerprints and candidate/canonical headers.

The exact files and validation required are determined when a release is prepared.

### Canonicalisation Is a Reference Operation, Not a Content Transformation

Canonicalisation identifies the exact merge commit produced by the Canonical Merge as a named immutable checkpoint. It does not transform accepted repository content into a different canonical repository.

The repository does not require ordinary changes to pass through a separate candidate repository, Authority Transformation, package-to-Git synchronisation or canonical-package baseline. A canonical release remains immutable as a referenced Git checkpoint while accepted `main` continues to evolve.

## Git Owns Document Chronology

Git owns when a file changed, what it contained at a commit, its authorship and history, comparisons between accepted and release states, and the exact source associated with a release checkpoint.

Ordinary current first-class documents do not maintain parallel rolling metadata such as `Currency`, `Canonical baseline`, `Last reviewed for canonical release` or `Candidate fingerprint` unless release identity is substantive to that document's responsibility. Historical documents retain versions and release identity when those facts are part of their subject. `CHANGELOG.md` owns externally meaningful release chronology.

## Repository knowledge model

Every enduring item has one authoritative home; other documents link rather than create competing definitions.

| Responsibility | Primary record |
|---|---|
| Engineering governance | `ENGINEERING_ARCHITECTURE.md` |
| Runtime architecture | `RUNTIME_RESPONSIBILITY_ARCHITECTURE.md` and specialised architecture breadcrumbs |
| Current project continuation | `PROJECT_STATUS.md` and `ENGINEERING_HANDOVER.md` |
| Current concept state | `CONCEPT_REGISTER.md` |
| Significant choices and rationale | `DECISION_LOG.md` and ADRs |
| Evidence and discoveries | `ENGINEERING_JOURNAL.md`, test records and research |
| Implementation responsibilities | code maps and implementation documentation |
| Release history | `CHANGELOG.md` |

The development repository may be richer than an external publication package. It preserves knowledge needed for continuation, architectural evolution, disproven hypotheses, validation evidence, implementation and diagnostics.

## Document governance

Every first-class document has a focused responsibility and a discoverable breadcrumb. Current architecture documents express present responsibility without claiming per-file canonical status. Historical records preserve provenance; compatibility documents preserve routes; archived material preserves knowledge without current authority.

Document lifecycle and authority should be visible through responsibility and navigation, not a rolling version header in every file. Git provides chronology. Removing development history for an external publication is a publication choice, not a reason to erase it from the engineering repository.

## Concept governance

Concepts are governed as:

- **Accepted:** evidence supports an independent concept, responsibility or lifecycle.
- **Deferred:** potentially useful, but evidence is insufficient for architectural status.
- **Rejected:** deliberately excluded, with reason and reconsideration conditions recorded.

Significant evidence triggers review of affected concepts and dependent architecture. Release preparation may perform a broader readiness review, but ordinary concept correction does not wait for a release. Architecture remains provisional against Reality.

## Runtime evidence governance

Durable empirical evidence identifies the runtime baseline on which it was observed: FS25 version/build when available, OuttaMyWay version or commit, date, map/fixture and relevant configuration.

A game update does not automatically invalidate evidence. Evidence may be current, version-bound, a revalidation candidate or invalidated by contrary Reality. Patch-impact review targets affected assumptions and sentinel scenarios; the full portfolio is rerun only when evidence justifies it.

Published notes, runtime logs and tests are evidence inputs. They do not outsource architectural judgement.

## Canonical Source ≠ Publication Package

The canonical release object is the exact Git commit produced by Canonical Merge. Packaging is a separate downstream operational concern.

Canonical source authority requires no ZIP, ZIP SHA-256, deterministic package, ModHub submission package or copying of package contents back into Git. A local FS25 test ZIP is a developer convenience artefact. External packages follow the requirements of their target environment.

### Publication Validation Is External Authority

Repository completeness and publication-package completeness are different responsibilities. Valid engineering material may be inappropriate for a publication package; a publication or test runner may impose requirements irrelevant to repository authority.

Publication acceptance neither creates nor revokes canonical source authority. Packaging, GIANTS/ModHub validation and submission occur only when explicitly requested and under their own requirements.

## Tooling boundary

Tooling enforces selected properties; it does not define architecture or confer repository authority. A passing tool cannot prove that an architecture is correct, and a check that is not automated remains an engineering obligation.

The Repository Release System authority architecture is retired. Its implementation remains as legacy tooling pending an independent KEEP/MERGE/EXTRACT/DELETE audit. It is not used for normal Engineering Increments or Canonical Merge, and no RRS run can declare canonical authority.

## Human review and traceability

Authorship does not confer acceptance. Review considers intended purpose, complete diff, validation evidence, architectural fit, affected prior scenarios and repository navigability. Owner merge accepts an ordinary increment; only owner merge of an explicitly designated Release Declaration PR performs Canonical Merge.

The repository must remain understandable to a fallible human engineer. Explicit ownership, call paths, breadcrumbs, recorded discoveries and bounded increments are engineering requirements, not optional editorial polish.
