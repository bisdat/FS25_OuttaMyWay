# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — post-#141 selection point

Issue #141 has completed the repository-wide documentation/source-documentation standards, Architecture/Specification/source traceability, selective semantic source-documentation review, generated source-reference adoption, and objective live-document navigation enforcement.

The repository is now at a **stable concern-selection boundary**. No successor engineering concern is selected by this document.

The next active concern must be chosen deliberately from current evidence and open repository work rather than inherited from #141 migration, audit, documentation or tooling chronology.

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

`scripts/main.lua` module source order is dependency-sensitive because sourced modules may consume globals established by earlier modules. That order must remain source-before-consumer, but it does not define architectural authority or Specification sequencing.

> **Bootstrap Order Is Dependency Order, Not Architectural Authority.**

The event-listener list is not a broader ordering contract. Only evidence-backed causal relationships are documented; incidental registration sequence must not be converted into architecture without supporting Reality or contract evidence.

## Structural conformance

`tests/test_document_conformance_structure.py` derives the declared conformance graph from the authoritative Architecture, Specification and source surfaces and runs inside the blocking `Structural contracts` CI job.

The checker validates only objectively knowable declared relationships. It does not infer semantic participation from prose, directories, imports or call topology and cannot establish semantic completeness.

`tests/test_live_document_navigation_structure.py` independently enforces the objective live-navigation contract over current Markdown roots `/architecture`, `/spec` and `/docs`: every live documentation directory has a README entry point, each README breadcrumbs its direct live Markdown children and direct live documentation subfolders, and repository-relative links resolve. `docs/archive/**` remains exempt under the Architecture-owned Archive Navigation Exemption.

> **Tooling Can Prove Declared Closure; Humans Establish Semantic Completeness.**

> **Machine conformance establishes declared structural coherence. Engineering establishes semantic truth.**

There is no authored central conformance manifest. Generated graph/index output remains derived and non-authoritative.

The former migration batching idea **`Migration Unit = Closed Participation Component` is retired**. Repository graph connectivity is not a required change-set boundary.

> **Migration Slice != Graph Component.**

## Generated source reference

The LDoc source reference is an adopted derived presentation consumer, not an authority surface and not a blocking semantic-conformance mechanism.

CI prepares disposable copies of production Lua, adds renderer-only module identities where needed, renders with pinned LDoc tooling, verifies that accepted Jurisdiction identifiers remain visible, and publishes the result as the `outtamyway-source-reference` GitHub Actions artifact. The artifact records both source-head and tested-commit provenance.

Generated HTML is not committed into the repository. Whether generated reference should later be published or stored differently remains a separate future engineering decision. Ordinary human use of the artifact may supply evidence about its usefulness without keeping #141 open.

> **Generated Reference != Repository Authority.**

> **Shared Source Documentation; Independent Consumers.**

## Retired #141 programme state

The following are no longer current continuation instructions and must not be resurrected as live programme state:

- participant-classification audit as pending work;
- repository-wide source-acknowledgement migration as pending work;
- repository-wide zero-comment or comment-density sweeps as pending work;
- bounded-adoption exceptions for incomplete Architecture/Specification/source declarations;
- delaying permanent declared-graph conformance until after migration;
- treating graph connected components as mandatory migration units;
- generated source-reference adoption as pending #141 work;
- Live Breadcrumb / relative-link structural enforcement as pending #141 work; and
- promoting incidental bootstrap or event-listener sequence into architectural authority without evidence.

Historical details of the #141 investigation, POC, migration slices, source-documentation audit, tooling adoption and closure proof remain in GitHub Issue #141, its pull requests and Git history rather than in this live continuation document.

## Executable baseline

The documentation/governance/tooling work through #141 does not advance the build component or change runtime behaviour. The accepted executable build identity remains `.75` unless a later runtime change explicitly advances it.

## Immediate next bounded engineering step

Select the next active engineering concern deliberately.

Before implementation begins:

1. perform the Repository Context Bootstrap and Relevant Knowledge Sweep required by `AGENTS.md`;
2. identify the current evidence-backed problem rather than inheriting a historical phase, migration, audit, documentation or tooling label;
3. establish the governing Architecture and primary Specification boundary where applicable;
4. record the selected concern here as the new continuation boundary; and
5. only then move from observation/discussion into implementation.

Open Issues are candidate work, not automatically the current concern.

> **Concern Selection != Backlog Order**
