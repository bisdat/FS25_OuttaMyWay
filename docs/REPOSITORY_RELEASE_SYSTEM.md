# Repository Release System Architecture

> **Authority:** TEST Release Candidate — engineering architecture
>
> **Currency:** Reconstructed and tested for v4.5.10 TEST
>
> **Owner:** Repository governance

## Purpose

The Repository Release System (RRS) is the evidence-producing, human-governed system that transforms the exact current canonical repository into a reviewed Release Candidate and, only after explicit Canonicalisation, into the next canonical repository.

The RRS exists because the previous release workflow did not consistently produce enough evidence for justified confidence. Its primary output is therefore not merely a ZIP file, but evidence that the repository transformation is correct. Human review remains responsible for engineering judgement and authority.

Evidence can justify confidence. Repeated successful application may earn human trust, but trust remains outside the RRS.

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

## Roles and Authority

- **Release Initiator** — begins the release process; currently either collaborator may initiate.
- **Consolidation Author** — prepares the knowledge consolidation and controlled repository transformation; primarily the engineering assistant.
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

## Ordered Gates

### Canonical Baseline Gate

Candidate Production may begin only after the exact current canonical package is established by identity and integrity evidence. A previous candidate, reconstructed repository, locally edited copy or assumed equivalent is not an acceptable baseline.

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

The reconstructed RRS must prove itself through controlled success and failure probes before producing a project candidate.
