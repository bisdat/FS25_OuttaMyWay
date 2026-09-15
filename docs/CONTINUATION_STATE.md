# Continuation State

## Responsibility

This document is the compact, replace-in-place description of OuttaMyWay's **current engineering continuation boundary**: the active concern, the accepted understanding needed to continue it, the unresolved question, and the next bounded engineering step.

It is **not** a repository-status dashboard.

Git owns exact accepted commit chronology. Executable-version owners own build identity. GitHub Issues and pull requests own their own state and discussion history. Canonical-release identity remains owned by release governance.

> **Continuation Boundary != Repository Status Dashboard**

Only the copy on accepted `main` is authoritative. On a working branch this file describes the continuation state that would become current if the branch were accepted.

## Current engineering boundary — Issue #172 lifecycle conformance

The post-#141 concern-selection boundary has selected **Issue #172 — mixed membership incompleteness retaining positively ended participant** as the active engineering concern.

#172 was not prompted by an in-game failure. It was discovered during the Issue #141 Operation Lifecycle / Situation Assessment primary-Specification review in PR #173, when accepted lifecycle authority was compared with existing `OperationAdmission.lua` reconciliation behaviour. Git history shows the coarse incomplete-membership preservation mechanism existed at least as early as v4.7.23, so this is treated as latent implementation drift rather than a `.75` regression.

The governing `OPERATION_LIFECYCLE` contract is settled for this concern:

- absence under incomplete observation does not terminate a previously active member;
- positive termination of an exact Job Episode is authoritative active-participant loss; and
- wider membership incompleteness must not defer that separately positive terminal fact.

The bounded implementation correction therefore changes incomplete Operation reconciliation so a previously admitted assembly is retained only while its exact Job Episode remains active. Another member's unresolved evidence can still preserve that unresolved member, but cannot preserve a positively terminated participant.

The focused offline regression models one Operation containing A, B and C, then observes A positively terminated, B unresolved and C positively active. The required result is A removed, B conservatively retained and C retained.

> **Structural Conformance Contradiction != Runtime Reproduction Requirement.**

> **Targeted Regression Proves the Rule; In-Game Validation Challenges the Integration.**

A later normal cold/warm in-game validation is therefore an integration challenge. A successful run supports that ordinary GIANTS Reality still behaves correctly after the repair; it does not claim the exact mixed-evidence edge condition was reproduced in-game.

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

This lifecycle conformance correction changes executable runtime behaviour and therefore advances the branch's current build identity from `.75` to **`.76`** under the four-component version policy. `scripts/config.lua` and `modDesc.xml` remain the two build-identity owners and must agree exactly.

No canonical-release identity changes.

## Immediate next bounded engineering step

Before this increment is accepted, blocking repository CI must validate the focused #172 regression together with the existing replacement-core, obstruction-relocation and structural contracts.

If the branch is accepted, the next bounded evidence step is a **normal cold/warm in-game lifecycle validation** using build `.76`. Its purpose is to challenge integration with GIANTS Reality after the conformance correction, not to recreate or claim direct in-game proof of the exact A-ended / B-unresolved / C-active edge fixture.

After that Reality evidence is recorded, close or revise #172 according to what the combined offline and in-game evidence supports. Issues #170, #174 and #176 remain separate parked conformance concerns; Issue #210 remains a parked generated-reference improvement concern.
