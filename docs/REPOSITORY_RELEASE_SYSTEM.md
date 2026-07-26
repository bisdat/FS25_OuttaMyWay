# Repository Release System Architecture

> **Authority:** Canonical repository-release architecture
>
> **Currency:** Reviewed for candidate release v4.6.1
>
> **Owner:** Repository governance

## Purpose

The Repository Release System (RRS) is the evidence-producing, human-governed system that transforms the exact current canonical repository into a reviewed Release Candidate and, only after explicit Canonicalisation, into the next canonical repository.

The RRS exists because the previous release workflow did not consistently produce enough evidence for justified confidence. Its primary output is therefore not merely a ZIP file, but evidence that the repository transformation is correct. Human review remains responsible for engineering judgement and authority.

Evidence can justify confidence. Repeated successful application may earn human trust, but trust remains outside the RRS.

The RRS also establishes an execution boundary: engineering collaboration produces declarative Engineering Intent, while repository modification occurs locally through the repository-owned implementation. Repository evolution therefore does not depend on the consolidation author's execution environment.

## Governing Unit

A release exists because an **Engineering Increment** is complete. A chat, session or chosen version number does not itself justify a release.

The RRS governs a compound **Release Candidate** consisting of:

- the complete candidate repository;
- declared Engineering Transformations;
- source-baseline provenance;
- observed repository delta;
- validation findings;
- integrity fingerprints;
- evidence sufficient for Consolidation Review.

## Knowledge Promotion

Repository knowledge moves through three states:

```text
Working Knowledge
        ↓ consolidation
Consolidated Knowledge
        ↓ canonicalisation
Authoritative Knowledge
```

Working Knowledge may exist in discussion, observation, logs or experiments. Consolidation classifies and places durable knowledge in its authoritative repository home. Canonicalisation is the repository owner's explicit recording that authority has already been earned through evidence, validation and review. It does not manufacture authority.

## Engineering Intent Boundary

The Consolidation Author supplies a declarative handoff describing the accepted Engineering Intent. The handoff is not permission to modify an arbitrary repository: it is bound to one exact Canonical Repository Snapshot by SHA-256 fingerprint.

The local RRS alone applies that handoff during Candidate Production. Direct file-editing capability in the authoring environment is optional rather than a release dependency. If the canonical snapshot changes for any reason, the previous handoff is invalid and must be regenerated against the new fingerprint.

## Roles and Authority

- **Release Initiator** — begins the release process; currently either collaborator may initiate.
- **Consolidation Author** — prepares the knowledge consolidation and fingerprint-bound Engineering Intent handoff; primarily the engineering assistant.
- **Consolidation Reviewer** — judges whether the candidate faithfully represents the Engineering Increment; primarily the repository owner.
- **Canonicalisation Authority** — alone may declare the exact reviewed candidate canonical; repository owner only.

Authorship does not confer approval. Review acceptance and Canonicalisation are separate decisions.

## Repository Authority States

```text
Current Canonical Repository
        ↓ Engineering Transformation
Working Repository
        ↓ Candidate Completion Gate
Release Candidate
        ↓ validation + review + explicit Canonicalisation
Accepted Candidate
        ↓ Authority Transformation
Canonical Repository
```

Authority state is independent of version identity. A repository may carry the target version while remaining non-canonical.

## Transformation Classes

### Engineering Transformation

Changes substantive engineering knowledge, implementation, configuration or repository content. It:

- occurs only during Candidate Production;
- begins from the exact current canonical repository;
- must be declared and reconciled against observed delta;
- must complete before Canonicalisation.

### Authority Transformation

Changes only authority state and its release-state representation. It:

- occurs only after explicit Canonicalisation of one exact candidate;
- must derive from that accepted candidate;
- may update candidate/canonical status, verification state and authority records;
- must not alter approved substantive engineering content.

Any substantive change discovered during Authority Transformation invalidates the transition and requires a new candidate cycle.

## Candidate Determinism

The Candidate repository package is an engineering artefact, not merely a convenient container. Given the same exact Canonical Repository Snapshot and the same fingerprint-bound Engineering Intent, supported execution platforms must emit a byte-identical candidate ZIP.

Candidate Production therefore uses one platform-neutral ordering of relative POSIX paths, fixed ZIP timestamps, explicit originating-platform metadata, fixed file permissions and storage without platform-dependent compression. The release manifest, inventories and package entries derive from the same path-ordering rule.

Evidence packages preserve execution provenance. They may differ in genuinely run-specific metadata, but each must identify the same candidate fingerprint and agree on all substantive repository findings.

A candidate-hash mismatch across supported platforms is a blocking Release Finding until the content or packaging divergence is explained and corrected.

### RRS Bootstrap Boundary

An RRS process cannot use implementation changes that exist only inside the candidate it is currently producing. When an Engineering Increment changes Candidate Production itself, the proposed RRS implementation must run from a separate fingerprinted bootstrap package while the Canonical Repository Snapshot remains unchanged. The evidence package preserves the exact runner source used. If the candidate is accepted, that same implementation enters the canonical repository through the normal review and Canonicalisation path.

This is an implementation bootstrap, not an authority shortcut: the external runner does not modify the canonical Git repository, approve its own output or bypass independent review.

## Repository-Native Line-Ending Authority

Repository text is stored and checked out with LF line endings under `.gitattributes`. Candidate Production and release-manifest generation preserve those repository-declared bytes. Contributor operating-system defaults and Git checkout settings must not silently redefine canonical release content.

The v4.6.16 transition normalises four inherited CRLF files: `.gitignore`, `rrs/__init__.py`, `rrs/__main__.py` and `rrs/requirements-dev.txt`. Earlier v4.6.15 canonical bytes remain historically valid; the normalisation is a declared Engineering Transformation, not a retrospective change.

## Ordered Gates

### Canonical Baseline Gate

Candidate Production may begin only after the exact current canonical package is established by identity and integrity evidence. The planning handoff records that package's SHA-256 fingerprint; a mismatch blocks execution, and any deliberate baseline change requires a regenerated handoff. A previous candidate, reconstructed repository, locally edited copy or assumed equivalent is not an acceptable baseline.

### Candidate Completion Gate

The declared Engineering Increment must be completely represented, candidate identity must be coherent, source-baseline provenance must remain correct, and the repository must not claim canonical authority.

### Validation Gate

Validation is both absolute and baseline-relative. It must identify expected change, missing declared change, unexplained divergence, inherited baseline debt, introduced violation and intentionally resolved baseline findings.

Inherited Baseline Debt is state, not delta. Under WA-01, accepted baseline inconsistencies remain visible without being silently repaired during RRS development.

### Consolidation Review Gate

The reviewer determines whether accepted decisions, discoveries, unresolved questions and implementation changes are faithfully represented in their authoritative repository homes.

### Canonicalisation Authority Gate

Only an explicit repository-owner decision tied to one exact candidate artefact and fingerprint authorises Authority Transformation.

### Authority Transformation Integrity Gate

Every candidate-to-canonical difference must be explainable solely by the authority transition. Substantive changes are forbidden.

### Canonical Package Gate

The final package must derive from the exact accepted candidate, contain only permitted Authority Transformations, possess coherent identity and a stable fingerprint, and exclude temporary or candidate-only evidence.

### Post-Canonicalisation Synchronisation

After the repository owner explicitly Canonicalises the exact reviewed candidate, the accepted package is synchronised into the local Git repository, committed and pushed. A clean, up-to-date working tree confirms that the engineering repository and the accepted canonical package represent the same content before further work begins. This synchronisation records and distributes the authority decision; it does not create that authority.

## Release Findings

The RRS produces classified findings rather than a single undifferentiated pass/fail result:

- **Expected Change** — declared and observed.
- **Missing Declared Change** — declared but not observed.
- **Unexplained Divergence** — observed but undeclared.
- **Inherited Baseline Debt** — present in the canonical baseline and preserved.
- **Introduced Violation** — new violation created by the candidate.
- **Resolved Baseline Finding** — inherited issue deliberately resolved within declared scope.

A release may contain non-blocking inherited findings. It may not conceal them.

## Evidence-Driven Confidence

The RRS exists so human review scales with the Engineering Increment rather than total repository size. It supplies evidence for transformation correctness; it does not replace engineering judgement.

A successful release should allow the reviewer to answer:

> Does this Engineering Increment deserve to become authoritative?

without first re-verifying every unchanged repository file.

## Proven Implementation Discoveries

Architecture Probe 01 established:

- baseline and candidate must be independently inventoried;
- identity extraction must be schema-aware;
- declared scope is independently testable;
- baseline findings are state, not delta;
- global version replacement is invalid because version-bearing fields have distinct semantic roles.

Architecture Probe 02 established:

- Candidate Production and Canonical Package Production are separate transformations;
- candidate identity can advance while canonical authority remains at the baseline;
- explicit Canonicalisation is a real gate;
- Authority Transformation can be constrained to authority-bearing files and independently proven pure.

The v4.6.0 recovery cycle then validated the operational path:

- a declarative handoff drove local Candidate Production without direct repository editing by the consolidation author;
- changing the canonical snapshot invalidated the old handoff and the fingerprint gate correctly blocked execution;
- regenerating the handoff against the new fingerprint produced a validated candidate and evidence package;
- independent owner review Canonicalised the exact candidate;
- synchronising that accepted package into Git ended with the local branch clean and aligned with its remote.

A subsequent v4.6.1 cross-platform comparison disproved the stronger assumption that the emitted candidate ZIP was already byte-deterministic. The Windows and Linux candidates contained the same repository payload except for manifest line ordering, while ZIP originating-platform metadata also differed. This was named the **Artifact Determinism Gap**.

The correction introduced one relative POSIX-path ordering rule for inventory, manifest and package generation, explicit ZIP originating-platform metadata, and platform-independent stored entries. Focused tests now protect mixed-case path ordering, archive metadata and creation-order independence. Cross-platform candidate hash equality is a release validation requirement under D-RRS-26.

## Work Allowances

### WA-01 — Canonical Baseline Tolerance

The declared canonical baseline is accepted as the baseline even when it contains known historical inconsistencies. RRS development must expose but not opportunistically repair that inherited debt.

### WA-02 — Packaging Capability Required

Packaging is a required RRS capability, but architecture defines its contract before implementation convenience determines its form.

## Architectural Integrity and Deferred Assurance Work

The next RRS engineering increment should attempt to break the system through a **Repository Challenge Suite**. Candidate challenge families include:

- broken or partial versioning;
- retrospective modification of a prior canonical package;
- candidate derived from an altered or stale baseline;
- duplicated or conflicting canonical authority;
- authority transition before review or validation;
- substantive edits during Authority Transformation;
- stale, missing or contradictory knowledge distribution;
- mismatched fingerprints, manifests or release histories.

This is deliberately Deferred. The challenge suite must first be architected as an adversarial assurance activity that attempts to disprove RRS assumptions rather than merely adding more release features.


## Engineering Increment Boundary

An Engineering Increment closes when its declared engineering purpose reaches a coherent breakpoint. Elapsed time, chat boundaries and version numbering do not define that boundary. A new purpose begins a new increment.

## Knowledge Promotion Completeness

Working artefacts may be retired only after their durable architectural, implementation and operational knowledge has been promoted into authoritative repository homes. Executable engineering capability is knowledge and must be preserved alongside its architecture.

## Recovered Implementation

The working implementation is repository-owned under `rrs/`. Its source was reconstructed from Probe 01, Probe 01 Stage 2, Probe 01 Stage 3 and Authority Transformation evidence. The recovery established that probe code contained a real implementation lineage but had not been promoted into the repository. That omission caused avoidable capability loss and is treated as a process failure rather than an architectural success.

The reconstructed RRS proved its current Candidate Production boundary through controlled success and failure paths and the complete v4.6.0 recovery cycle. The v4.6.1 correction adds byte-deterministic candidate packaging across supported platforms and focused regression tests. Cross-platform candidate hash equality remains an explicit release validation gate.

Authority Transformation, complete ordered authority-state enforcement, candidate-to-canonical purity verification and the deferred Repository Challenge Suite remain future work.
