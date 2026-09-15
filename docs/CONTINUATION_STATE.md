# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #141 generated source-reference adoption

Issue #141 completed the repository-wide documentation/source-documentation standards, source-traceability and selective semantic source-documentation programme, but its final closure review recovered one deliberately deferred tooling question: the successful LDoc source-rendering proof of concept had never been adopted as a permanent derived reference.

The repository owner has now selected a bounded **LDoc generated source-reference trial** under #141.

The adopted responsibility is deliberately narrow:

- production source comments remain the authored source-documentation authority;
- primary Specifications remain the authority for `REALISES` / `SUPPORTS` source participation;
- structural conformance remains independent of the documentation renderer;
- LDoc renders a disposable human-facing reference from current source;
- generated HTML is published as a GitHub Actions artifact rather than committed into the repository; and
- whether generated HTML should ever become checked-in repository material remains a separate future decision that must earn its own responsibility.

> **Generated Reference != Repository Authority.**

> **Shared Source Documentation; Independent Consumers.**

## Accepted steady-state documentation model

`docs/DOCUMENT_STANDARDS.md` is the normative authoring, ownership and cross-surface conformance standard for live engineering documentation and source documentation.

The Authority Triad remains:

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

## Steady-state source traceability

Specification Jurisdiction is the stable semantic identity joining Architecture, primary Specification and materially participating production source.

Architecture owns Jurisdiction existence and `SPECIALISES` topology. A primary Specification owns source-participation classification as `REALISES` or `SUPPORTS`. Participating source reciprocally acknowledges the complete set of Jurisdiction IDs in which it materially participates, without assigning itself authority or relationship type.

Navigation remains richer than the machine graph:

> **Navigation Trace != Contract Participation.**

Source participation follows implemented meaning rather than directory placement, imports or call topology.

> **Source Participation Follows Implemented Meaning, Not Directory Placement.**

> **Calling a Contract != Implementing the Contract.**

> **Support Is Direct, Not Transitive.**

Validation remains evidence. A Specification may declare exact repository validation artefacts as `CHALLENGES`; the validation artefact does not self-certify coverage.

> **A Validation Surface Challenges a Contract; It Does Not Certify It.**

## Accepted source-documentation closure

Source-documentation sufficiency is selective and semantics-weighted. The closure review did not treat comment density or zero-comment files as defects by themselves; it reviewed implementation areas where missing local explanation could cause a maintainer to violate an ownership boundary, causal ordering, fail-safe condition, or other non-obvious contract.

> **Comment Need Follows Semantic Risk, Not Comment Density.**

The final bootstrap review established one additional local source contract: `scripts/main.lua` module source order is dependency-sensitive because sourced modules may consume globals established by earlier modules. That order must therefore remain source-before-consumer, but it does not define architectural authority or Specification sequencing.

> **Bootstrap Order Is Dependency Order, Not Architectural Authority.**

The event-listener list was not promoted into a broader ordering contract. Only evidence-backed causal relationships are documented; incidental registration sequence must not be converted into architecture without supporting Reality or contract evidence.

## Structural conformance and generated reference

The bounded source-traceability adoption period is complete and no longer a live repository state.

`tests/test_document_conformance_structure.py` derives the declared conformance graph from the authoritative Architecture, Specification and source surfaces and runs inside the blocking `Structural contracts` CI job.

The checker validates only objectively knowable declared relationships. It does not infer semantic participation from prose, directories, imports or call topology and cannot establish semantic completeness.

> **Tooling Can Prove Declared Closure; Humans Establish Semantic Completeness.**

> **Machine conformance establishes declared structural coherence. Engineering establishes semantic truth.**

There is no authored central conformance manifest. Generated graph/index output remains derived and non-authoritative.

The LDoc source reference is now a separately adopted derived presentation consumer. CI prepares disposable copies of production Lua, adds generated renderer-only module identities where needed, renders with LDoc, verifies that accepted Jurisdiction identifiers remain visible, and uploads the result as an Actions artifact. The renderer does not own or validate semantic contract relationships.

The former migration batching idea **`Migration Unit = Closed Participation Component` is retired**. Repository graph connectivity is not a required change-set boundary.

> **Migration Slice != Graph Component.**

## Retired #141 migration and audit state

The following are no longer current continuation instructions and must not be resurrected as live programme state:

- participant-classification audit as pending work;
- repository-wide source-acknowledgement migration as pending work;
- repository-wide zero-comment or comment-density sweeps as pending work;
- bounded-adoption exceptions for incomplete Architecture/Specification/source declarations;
- delaying permanent declared-graph conformance until after migration;
- treating graph connected components as mandatory migration units; and
- promoting incidental bootstrap or event-listener sequence into architectural authority without evidence.

Historical details of the #141 investigation, POC, migration slices, source-documentation audit and closure proof remain in GitHub Issue #141, its pull requests and Git history rather than in this live continuation document.

## Executable baseline

The documentation/governance/tooling work through #141 does not advance the build component or change runtime behaviour. The accepted executable build identity remains `.75` unless a later runtime change explicitly advances it.

## Immediate next bounded engineering step

Validate the generated source-reference adoption against the real current repository:

1. GitHub Actions must preserve the existing blocking `Structural contracts` and `Lua offline behavioural contracts` unchanged in authority;
2. the separate `Generated source reference` job must prepare and render the complete current production Lua corpus successfully with pinned LDoc tooling;
3. the produced Actions artifact must contain the generated HTML plus source-commit provenance and the explicit non-authoritative boundary;
4. rendering must preserve the accepted visible `Specification Jurisdictions:` metadata without requiring LDoc-specific production annotations; and
5. review the artifact as a human navigation aid before deciding whether the trial is useful enough to retain.

Generated HTML remains outside the repository tree during this trial. Moving generated reference into the repository, making renderer success a blocking acceptance criterion, or requiring LDoc-specific annotations in production source each require a separate explicit decision.

After the LDoc adoption increment is accepted, complete the remaining #141 closure audit rather than beginning another source-comment sweep. In particular, confirm whether the original Live Breadcrumb / relative-link structural-enforcement completion criterion is fully satisfied before closing the Issue.
