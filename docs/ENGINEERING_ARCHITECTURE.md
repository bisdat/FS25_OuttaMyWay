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

### Continuation State

**Continuation State is the compact, replace-in-place description of the project's present engineering boundary: what workstream is active, what is currently understood, what remains unresolved, and what bounded question should be addressed next.**

`CONTINUATION_STATE.md` owns this responsibility. Accepted engineering replaces its contents in place; current state must not become an appended historical ledger. Git owns the chronology of previous Continuation States. The archived historical snapshots in `archive/reconciliation/stale-authority-surface/PROJECT_STATUS.md` and instructions in `archive/reconciliation/stale-authority-surface/ENGINEERING_HANDOVER.md` remain evidence but do not establish current authority.

GitHub Issues may own a substantial bounded prospective question or piece of work where useful; trivial increments do not require an Issue. An Issue describes work being undertaken, but it does not establish accepted architecture or implementation authority. Accepted repository state still changes through reviewed pull-request merge.

A **Context Transfer Artifact** is a disposable reconstruction aid used to transfer sufficient working context between collaboration sessions. It does not establish architecture, engineering state, decisions or implementation authority. Chat carry-forwards therefore do not form a permanent accumulating repository document class; any durable discovery they contain is promoted into its responsible repository home.

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
- **Discuss:** separate facts/observations, interpretations, hypotheses, decisions and implementation ideas.
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

The declaration increment changes only material genuinely required to express release identity, such as runtime version metadata, the root `../CHANGELOG.md`, or another first-class release record whose responsibility requires it. It does not stamp every engineering document with the release version or proliferate package fingerprints and candidate/canonical headers.

The exact files and validation required are determined when a release is prepared.

### Canonicalisation Is a Reference Operation, Not a Content Transformation

Canonicalisation identifies the exact merge commit produced by the Canonical Merge as a named immutable checkpoint. It does not transform accepted repository content into a different canonical repository.

The repository does not require ordinary changes to pass through a separate candidate repository, Authority Transformation, package-to-Git synchronisation or canonical-package baseline. A canonical release remains immutable as a referenced Git checkpoint while accepted `main` continues to evolve.

### Pre-1.0 Versioning Policy

Before the first public release, release identity uses `0.MINOR.PATCH.BUILD`.
Canonical named releases use `BUILD=0`, while non-canonical TEST iterations
increment `BUILD`. An accepted compatible correction increments `PATCH` and
resets `BUILD`; a significant architecture or capability milestone increments
`MINOR` and resets both `PATCH` and `BUILD`. The first public release is reserved
for `1.0.0.0`.

Historical `4.7.x` identities remain immutable provenance and are not
renumbered. Version identity does not itself establish accepted or canonical
authority.

## Git Owns Document Chronology

Git owns when a file changed, what it contained at a commit, its authorship and history, comparisons between accepted and release states, and the exact source associated with a release checkpoint.

Ordinary current first-class documents do not maintain parallel rolling metadata such as `Currency`, `Canonical baseline`, `Last reviewed for canonical release` or `Candidate fingerprint` unless release identity is substantive to that document's responsibility. Historical documents retain versions and release identity when those facts are part of their subject. The root `../CHANGELOG.md` owns externally meaningful release chronology.

## Repository knowledge model

Every enduring item has one authoritative home; other documents link rather than create competing definitions.

| Responsibility | Primary record |
|---|---|
| Engineering governance | `ENGINEERING_ARCHITECTURE.md` |
| Scope / Supported Validation Envelope | `SCOPE_AND_VALIDATION_ENVELOPE.md` |
| Testing methodology / evidence-strength process | `TESTING_METHODOLOGY.md` |
| Executable offline validation mechanisms and fixtures | root `../tests/` and its `README.md` |
| Runtime architecture | `architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md` and specialised architecture breadcrumbs |
| Current engineering continuation | `CONTINUATION_STATE.md` |
| Current concept state | `CONCEPT_REGISTER.md` |
| Significant choices and rationale | `DECISION_LOG.md` |
| Evidence and discoveries | `ENGINEERING_JOURNAL.md`, test records and `research/` |
| Implementation placement / architecture-to-code mapping | `IMPLEMENTATION_MAP.md` |
| Configuration architecture | `CONFIGURATION.md` (Deferred placeholder) |
| GUI architecture | `GUI.md` (Deferred placeholder) |
| Release history | root `../CHANGELOG.md` |

The development repository may be richer than an external publication package. It preserves knowledge needed for continuation, architectural evolution, disproven hypotheses, validation evidence, implementation and diagnostics.

## Document governance

Every first-class document has a focused responsibility and a discoverable breadcrumb. Current architecture documents express present responsibility without claiming per-file canonical status. Historical records preserve provenance; compatibility documents preserve routes; archived material preserves knowledge without current authority.

### Predictable Knowledge Placement

**Navigation** means an engineer can find the relevant record. **Prediction**
means an engineer can predict which responsible record should contain that
class of knowledge. Repository responsibility is stronger when both are true; a
breadcrumb alone is insufficient when responsibility remains ambiguous.

**Live Breadcrumb Invariant.** Every live documentation folder's `README.md`
links each direct intentionally retained live document other than itself and
each direct live documentation subfolder through that child's `README.md`.
Direct-child navigation is sufficient; a parent need not duplicate a complete
descendant tree. A breadcrumb asserts intentional discoverability, not semantic
authority by itself.

A missing breadcrumb is an **Orphan Signal** requiring review of the child's
current responsibility. It is neither proof of staleness nor an automatic
deletion rule. Conversely, adding a link must not preserve a stale document
whose responsibility no longer exists. Predictable Knowledge Placement
therefore asks two complementary questions: **Navigation** — can the knowledge
be reached through the README tree? **Prediction** — would an engineer know
where responsibility-specific knowledge should live?

**Archive Navigation Exemption.** `archive/` and its descendants are outside
the live breadcrumb tree. Archive material has no current authority and exists
primarily for bounded recovery or harvesting until deletion is safe. The live
`docs/README.md` does not present it as a primary route. This exemption does not
turn archive into permanent storage.

**Archive Is a Transition, Not a Cemetery.** A current document retains a
present-tense responsibility. Once superseded, it may be archived temporarily
only while knowledge reconciliation, dependency closure or reference repair
still requires the file itself. After those purposes are exhausted, remove the
file from the working tree; Git retains its history. The archive is not a
permanent retention requirement.

### Stale Responsibility Surface

A document may remain visible among current engineering documentation after the
responsibility that once justified it has moved elsewhere, expired or been
superseded. Its presence can falsely imply current authority.

> **Stale responsibility → archive. Live responsibility + stale content → reconcile in place.**

**Decision Record Authority Drift** occurs when a historical decision record
retains useful rationale or provenance while its original normative or status
language presents superseded meaning as current authority. Current architecture
owns present normative architectural meaning; the Concept Register owns current
concept state; the Decision Log is the live repository record for significant
choices and rationale.

**Decision Responsibility Succession** means that when a later record assumes
the live responsibility of an earlier decision-document class, the earlier
class does not remain live merely to preserve history after unique knowledge
and references have been reconciled. Git owns exact historical text and
chronology, and historical identifiers may remain as provenance without a live
source file.

Before retiring such a container, apply the **Stranded Live Knowledge** check:
identify any still-current meaning whose only complete home is the stale
container and harvest it into its present responsible home. A fully harvested
container with no transitional responsibility may then be removed; Git retains
its history.

File age or version is a risk signal, not itself the decision criterion.
`CONCEPT_REGISTER.md` remains active because this architecture assigns it the
live responsibility of current concept state, despite its accumulated historical
content. `DECISION_LOG.md`, `ENGINEERING_JOURNAL.md` and the root
`../CHANGELOG.md` remain active because historical chronology is intrinsic to
their live responsibilities. Documents such as the archived `ARCHITECTURE.md`,
`KNOWN_ISSUES.md` and `ROADMAP.md` lose active-surface status because their
present-tense responsibilities have moved elsewhere.

### Evidence responsibility and instrument lifetime

**Evidence Responsibility Fragmentation** occurs when records belonging to one evidence lifecycle are spread across peer documentation roots, making placement unpredictable. Research owns bounded experimental and investigative evidence, including prototypes and focused representation investigations, without granting those records current architectural authority.

**Evidence Record ≠ Instrument Record.** A durable evidence record preserves the engineering question, method, observations, result and limitations. An instrument record primarily preserves temporary logging, HUD or probe configuration, labels, or sampling mechanics. Instrumentation history does not automatically justify a permanent live documentation responsibility after its durable findings have been harvested.

**Probe Lifetime Follows Question Lifetime.** A diagnostic probe is justified by a bounded engineering question. When the question closes, its durable evidence or discovery moves to the knowledge store that owns it; the probe and its instrumentation gain no permanent documentation authority merely because code or logs once existed. This governance rule does not itself authorise pruning diagnostic implementation.

**Diagnostic Documentation Generation Drift** occurs when a documentation surface claims current diagnostic responsibility while substantially describing an earlier runtime generation. Such a surface is not a trustworthy current-runtime reference and must undergo the Stranded Live Knowledge check rather than persist through its current-sounding label.

**Speculative Container Persistence** occurs when a repository container remains reserved for a possible future responsibility despite containing no current artefact or dependency that requires it. Repository structure follows demonstrated responsibility rather than reserving empty topology in advance. If a future responsibility needs a container, create its appropriate location when that need exists.

**Unreferenced Asset Persistence** occurs when an artefact remains after no current implementation or declared responsibility depends on it. File presence does not establish responsibility; an unreferenced artefact with no independent purpose may be removed, with Git retaining its history.

**Scenario Responsibility Conflation** occurs when human-readable in-game fixture knowledge and executable replay fixture data share one repository container despite belonging to Research and test machinery respectively. A Scenario describes reproducible starting Reality; a Test asks a question of Reality using that Scenario. Repeatability improves attribution but does not expand claim breadth.

Document lifecycle and authority should be visible through responsibility and navigation, not a rolling version header in every file. Git provides chronology. Removing development history for an external publication is a publication choice, not a reason to erase it from the engineering repository.

## Concept governance

Concepts are governed as:

- **Accepted:** evidence supports an independent concept, responsibility or lifecycle.
- **Deferred:** potentially useful, but evidence is insufficient for architectural status.
- **Rejected:** deliberately excluded, with reason and reconsideration conditions recorded.

Significant evidence triggers review of affected concepts and dependent architecture. Release preparation may perform a broader readiness review, but ordinary concept correction does not wait for a release. Architecture remains provisional against Reality.

### Concept State Is Not Concept History

The Concept Register is a replace-in-place current-state record. Each concept
appears once in its current state, and a status change replaces the prior
register state rather than appending another version section. Concept rationale
and history belong in the Decision Log and Git; empirical discovery
history belongs in the Engineering Journal, tests and research evidence.

Each current entry links to the architecture document that owns its full
semantics. A rejected concept remains in the register only while its present
rejection materially helps prevent accidental reintroduction. Version headings,
candidate fingerprints, validation chronology and historical implementation
status do not belong in the current Concept Register.

## Structural-test governance

> **Tests protect current contracts, not historical repository topology.**

**Historical Test Responsibility Persistence** occurs when a test created to certify a historical architecture or document constellation remains active after those surfaces have lost current responsibility. A test must not preserve a retired repository or document responsibility merely because it historically asserted it; Git retains the deleted assertion and its provenance.

**First-Failure Masking** occurs when one structural test has several obsolete dependencies but execution reports only the first missing file. When a structural test fails on a missing repository surface, review the complete test body and dependency class instead of repairing only the first failing read.

A test may consume retained historical evidence when that evidence legitimately participates in a current validation contract. Such use does not grant the evidence current architectural authority. Current implementation may also remain regression-protected while architectural reconciliation is pending, provided the test does not present implementation persistence as current architectural authority.

Root `/tests` owns executable offline validation mechanisms and replay fixtures. [Testing Methodology](TESTING_METHODOLOGY.md) separately owns how claims are challenged and evidence strength increases; tests do not define architecture.

**Test-Sustained Implementation Persistence** is the observation that implementation which has lost production-runtime responsibility may remain executable because tests still load and validate it. This is evidence for later diagnostic/probe investigation, not authority to delete that implementation here.

Validation strength must match claim breadth. Validation depth should remain high while conceptual stability is low; systematic breadth follows later stability. Material assumptions and supported claims should be human-traceable through their [scope and validation obligation](SCOPE_AND_VALIDATION_ENVELOPE.md), architectural and implementation owners, and applicable offline and field evidence.

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

The Repository Release System authority architecture is retired. By owner decision,
the RRS implementation and its repository-specific policy and manifest have been
removed from the current working tree. Ordinary Engineering Increments and
Canonical Merge do not depend on RRS. Git history retains the historical mechanism
and artefacts; no historical RRS record can confer current repository authority.

### Retired Tooling Dependency Does Not Preserve Artefact Responsibility

Tooling that no longer has current operational responsibility cannot force obsolete
repository artefacts to remain merely because it references their paths. Once the
tool itself is retired, its implementation, generated artefacts and
repository-specific policy inputs may be removed when they have no independent
current responsibility. Git owns the historical implementation and historical input
state, and historical records may continue to mention RRS without creating current
tooling authority. Retired tooling must not be silently reconstructed or
reintroduced into ordinary engineering without a new explicit engineering decision.

## Human review and traceability

Authorship does not confer acceptance. Review considers intended purpose, complete diff, validation evidence, architectural fit, affected prior scenarios and repository navigability. Owner merge accepts an ordinary increment; only owner merge of an explicitly designated Release Declaration PR performs Canonical Merge.

The repository must remain understandable to a fallible human engineer. Explicit ownership, call paths, breadcrumbs, recorded discoveries and bounded increments are engineering requirements, not optional editorial polish.
