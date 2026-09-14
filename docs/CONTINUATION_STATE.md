# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own TEST build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — post-#141 selection point

Issue #141 has completed the repository-wide documentation/source-documentation standards and source-traceability programme.

The repository is now at a **stable concern-selection boundary**. No successor engineering concern is selected by this document.

The next active concern must be chosen deliberately from current evidence and open repository work rather than inherited from #141 migration chronology.

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

## Structural conformance

The bounded source-traceability adoption period is complete and no longer a live repository state.

`tests/test_document_conformance_structure.py` derives the declared conformance graph from the authoritative Architecture, Specification and source surfaces and runs inside the blocking `Structural contracts` CI job.

The checker validates only objectively knowable declared relationships. It does not infer semantic participation from prose, directories, imports or call topology and cannot establish semantic completeness.

> **Tooling Can Prove Declared Closure; Humans Establish Semantic Completeness.**

> **Machine conformance establishes declared structural coherence. Engineering establishes semantic truth.**

There is no authored central conformance manifest. Generated graph/index or source-reference output, if ever useful, remains derived and non-authoritative.

The former migration batching idea **`Migration Unit = Closed Participation Component` is retired**. Repository graph connectivity is not a required change-set boundary.

> **Migration Slice != Graph Component.**

## Retired #141 migration state

The following are no longer current continuation instructions and must not be resurrected as live programme state:

- participant-classification audit as pending work;
- repository-wide source-acknowledgement migration as pending work;
- bounded-adoption exceptions for incomplete Architecture/Specification/source declarations;
- delaying permanent declared-graph conformance until after migration; and
- treating graph connected components as mandatory migration units.

Historical details of the #141 investigation, POC, migration slices and closure proof remain in GitHub Issue #141, its pull requests and Git history rather than in this live continuation document.

## Executable baseline

The documentation/governance work through #141 did not consume a TEST BUILD or change runtime behaviour. The accepted executable TEST identity remains `.75` unless a later runtime change explicitly advances it.

## Immediate next bounded engineering step

Select the next active engineering concern deliberately.

Before implementation begins:

1. perform the Repository Context Bootstrap and Relevant Knowledge Sweep required by `AGENTS.md`;
2. identify the current evidence-backed problem rather than inheriting a historical phase or migration label;
3. establish the governing Architecture and primary Specification boundary;
4. record the selected concern here as the new continuation boundary; and
5. only then move from observation/discussion into implementation.

Open Issues are candidate work, not automatically the current concern.

> **Concern Selection != Backlog Order**
