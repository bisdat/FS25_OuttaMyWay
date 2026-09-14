# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own TEST build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering concern — Issue #141

Issue #141 is establishing durable authoring, ownership and structural-conformance standards across the repository's Authority Triad:

```text
/architecture
Architecture — what / why
        ⇅
/spec
Specification — implementation-facing contract
        ⇅
/scripts
Source — current mechanism
        |
        v
/tests + Reality
Validation evidence
```

The governing cross-surface rule remains:

> **Touch One; Validate Three.**

Tests are evidence rather than a fourth authority surface. `/docs` remains the separate engineering-knowledge and governance surface.

## Accepted #141 understanding

The documentation-standard work and subsequent whiteboard/POC have established the following model.

### Specification Jurisdiction is the semantic anchor

Architecture owns the existence and topology of Specification Jurisdictions. Each implemented Jurisdiction has one primary Specification. A Jurisdiction receives one canonical machine-stable ID, while subordinate Responsibilities remain human architectural concepts unless evidence later establishes another need.

> **Specification Jurisdiction Is the Cross-Surface Semantic Anchor.**

A distinct Jurisdiction may declare `SPECIALISES` against another distinct Jurisdiction. Architectural specialisation inside one Jurisdiction does not create a machine specialisation edge.

A generic machine `DEPENDS_ON` relationship is deliberately not adopted. Current cross-Jurisdiction prose mixes prerequisites, optional contributors, downstream consumers, handoffs and authority boundaries; forcing those into one edge would invent semantics.

### Specification owns source-participation classification

The source-role vocabulary survived a whole-portfolio dry classification across all 15 current primary Jurisdictions without requiring a third role:

- `REALISES` — the source directly implements Jurisdiction-owned semantic meaning;
- `SUPPORTS` — the source provides materially Jurisdiction-specific subordinate infrastructure without owning the semantic boundary.

`SUPPORTS` is direct rather than transitive. Mere imports, calls, upstream production, downstream consumption, shared technical utility or implementation of another Jurisdiction do not create source participation automatically.

> **Calling a Contract != Implementing the Contract.**

> **Technical Dependency != Contract Support.**

> **Support Is Direct, Not Transitive.**

Source placement does not determine contract participation. One module may truthfully realise several Jurisdictions when it directly implements several semantic slices.

> **Source Participation Follows Implemented Meaning, Not Directory Placement.**

### Source acknowledges participation without assigning authority

The primary Specification owns `REALISES` / `SUPPORTS`. Source reciprocally acknowledges only the Jurisdiction IDs in which it materially participates.

The demonstrated source representation is a visible module-documentation line of the form:

```lua
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`, `CONTROL`
```

The acknowledgement is intentionally untyped. Declaration order carries no authority.

> **Reciprocity != Co-Ownership.**

> **Specification Owns Contract-Participation Classification.**

> **Source Acknowledges Participation; It Does Not Assign Itself Contract Authority.**

> **Authoritative Edge, Reciprocal Acknowledgement.**

### Navigation remains richer than the machine graph

A Specification's ordinary Implementation traceability may route to upstream producers, downstream consumers, neighbouring authorities, shared mechanisms or directories that are useful to an engineer but are not material contract participants.

> **Navigation Trace != Contract Participation.**

Machine participant rows therefore use exact production-file paths. Directory links, globs and phrases such as "runtime orchestration" remain human navigation rather than semantic graph edges.

### Validation remains evidence

A primary Specification may name exact repository evidence as `CHALLENGES`. The validation artefact does not reciprocally self-certify contract coverage.

> **A Validation Surface Challenges a Contract; It Does Not Certify It.**

> **A Contract Names Its Evidence Route; Evidence Does Not Self-Certify Its Contract Coverage.**

Targeted in-game Reality validation and scenario interpretation remain human-readable evidence routes rather than invented repository nodes.

## POC evidence

Draft PR #184 is a branch-only experiment and is not an adoption candidate.

Its first phase proved that a visible source documentation line can be consumed independently by a deterministic extractor and LDoc 1.5.0 while coexisting with LuaLS/LuaCATS-style parameter/return annotations. A custom module-level LDoc `@participates` tag was weaker because default generated HTML omitted the custom values; visible structured prose rendered correctly. Semantic IDs containing underscores must appear as inline code to preserve literal identity through Markdown rendering.

The second phase extended the experiment across generated copies of real Architecture, Specification and source artefacts. It covered five representative Jurisdictions, including specialisation and many-to-many source participation.

The POC successfully derived a disposable conformance graph and rejected six deliberately injected defects for the intended reasons:

1. Architecture / primary-Spec disagreement;
2. missing source acknowledgement;
3. source acknowledgement without Spec classification;
4. unknown `SPECIALISES` target;
5. a `SPECIALISES` cycle; and
6. an implemented Jurisdiction with no `REALISES` participant.

Normal repository Offline Validation also remained green on the experimental branch.

The experiment supports:

> **Parse the Contracted Surface; Do Not Interpret the Document.**

> **The Conformance Graph Should Be Derived, Not Authored.**

> **Derived Index != Authority Surface.**

> **Shared Syntax; Independent Consumers.**

Generated LDoc or other reference output remains optional and derived.

> **Documentation Renderer != Documentation Authority.**

## Structural-conformance boundary

Machine conformance is intentionally narrow. It may prove declared structural coherence including canonical Jurisdiction identity, primary-Spec reciprocity, `SPECIALISES` target/cycle validity, exact source paths, legal `REALISES` / `SUPPORTS` classification, at least one realiser per implemented Jurisdiction, Spec/source acknowledgement closure, repository validation-path resolution, incoming relationship closure after rename/deletion, and eventual Authority-Triad change disposition.

It must not infer undeclared semantic relationships from prose, directories, imports or call topology. It cannot establish that Architecture is correct, that a source classification is semantically right, that an omitted participant should have been declared, or that a test adequately represents Reality.

> **Tooling Can Prove Declared Closure; Humans Establish Semantic Completeness.**

> **No Speculative Linting in Normative Conformance.**

> **Machine conformance establishes declared structural coherence. Engineering establishes semantic truth.**

## Bounded migration state

The representation has now been selected, but the accepted repository has not yet migrated all Architecture, Specifications and source to it.

The bounded adoption exception therefore remains necessary until all current implemented Jurisdictions have canonical IDs and exact primary-Spec routes; every primary Specification classifies its complete material production participant set by exact path as `REALISES` or `SUPPORTS`; every participating source module reciprocally acknowledges its complete Jurisdiction set; every implemented Jurisdiction has at least one realiser; and the derived graph closes with zero unresolved relationships.

No authored central manifest is required or desired. A generated graph/index may exist as a disposable diagnostic or presentation product.

Permanent CI/pre-commit enforcement remains a later adoption decision after the repository-wide migration proves the contract in accepted source.

## Immediate next bounded #141 engineering step

After the conformance-standard change is accepted, plan and execute the **bounded repository traceability migration** across all 15 current primary Jurisdictions.

That migration must be evidence-led rather than mechanical. For each Jurisdiction it must:

1. add the Architecture-owned canonical Jurisdiction ID and exact primary-Spec route;
2. add the reciprocal Specification identity/Architecture route;
3. audit current implementation traceability and separate material `REALISES` / `SUPPORTS` participants from navigation-only routes;
4. add exact participant rows to the primary Specification;
5. add the untyped Jurisdiction acknowledgement to each material production source module;
6. preserve or improve concise module-level semantic documentation without narrating Lua syntax;
7. validate Authority-Triad impact; and
8. prove full declared graph closure before calling the migration complete.

The migration must not classify source from directory placement, blindly convert all existing traceability links, create transitive support edges, manufacture `DEPENDS_ON`, or introduce generated documentation as an authority requirement.

Draft PR #184 should remain unmerged as experimental evidence while the standards are adopted. Once its findings are incorporated into accepted authority and no further POC work is needed, it can be closed unmerged; GitHub retains the experimental history.

## Subsequent #141 boundaries

After repository-wide traceability migration succeeds:

1. implement only the deterministic conformance checker justified by the accepted contract;
2. apply Authority Triad change-set disposition enforcement without pretending to validate the human judgement behind `VALIDATED_UNCHANGED`;
3. decide separately whether LDoc or another generated source-reference product has demonstrated enough value to own an optional presentation responsibility; and
4. adopt permanent CI/pre-commit/root governance only after the checker survives real repository use.

> **Adoption follows validation.**

If tooling or later Reality disproves the standards, Specification model or Jurisdiction boundaries, update those authorities rather than preserving the programme for its own sake.

## Separate adjacent responsibilities

The current source-conformance investigations exposed by Specification work remain separate from #141 unless their evidence changes Architecture or a primary Specification:

- Issue #170 — **Support Precedence != Admissibility Bypass**;
- Issue #172 — **Lifecycle Certainty and Observation Completeness Are Orthogonal** and **Positive Termination != Missing-Membership Evidence**;
- Issue #174 — **Positive Physical Actuation Requires Positive Bounded Authority**;
- Issue #176 — **Resolution Failure / Escalation != Causal-Obstruction Basis Cessation**;
- Issue #152 — live diagnostic-responsibility review;
- Issue #139 — supported player Configuration investigation; and
- Issue #89 — deferred GUI/HUD/player-communication responsibility.

Configuration remains a Deferred Responsibility and does not receive a speculative primary Specification merely to satisfy structural symmetry.
