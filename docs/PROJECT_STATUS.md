# Project Status

Version: 4.6.1
Status: RRS consolidation Release Candidate pending independent user verification and Canonicalisation
Baseline package: canonical v4.6.0
Behavioural baseline: unchanged from v4.3.5

## Current Focus

Milestone 4 — Architectural Prototyping: validate architectural hypotheses through targeted prototypes.

Version 4.6.0 is the canonical Repository Release System recovery release. The v4.6.1 consolidation increment captures the operational discoveries proven while producing, reviewing, Canonicalising and synchronising that release, after which project focus returns to OuttaMyWay architectural prototyping.

## Project Purpose

Enable players to trust autonomous workers to complete their work without supervision.

Mission: preserve autonomous continuity through the least disruptive justified intervention.

Success criterion:

> A successful autonomous worker is one the player stops thinking about.

## Current Architectural Understanding

- Reality exists independently; observations sample it; Knowledge is reconstructed rather than possessed directly.
- Situation Space describes the structured set of possible situations, including entities, states and relationships.
- Current Situation is the system's present estimated point within Situation Space.
- Situation Assessment transforms observations into the maintained Current Situation and remains the sole interpreter of observations.
- Future Space preserves multiple plausible futures rather than committing to one prediction.
- Action Space describes the actions currently available; anticipation is valuable because it preserves Action Space.
- Time is the dimension in which Reality, observations, Knowledge, Future Space and Action Space evolve.
- Conflict Zone remains operationally useful but is now treated as a derived phenomenon rather than a root primitive.
- Commitment remains an Accepted concept with creation, maintenance, completion and cancellation lifecycle semantics.
- Execution acts within an active commitment and validated capability boundaries.
- Outcomes return as observations through Situation Assessment before further decisions.
- Native GIANTS AI remains authoritative unless OuttaMyWay has a specific, bounded reason to intervene.

## Immediate Development Objective

Define the architectural contract connecting Situation Assessment to Commitment.

Questions to resolve before implementation:

- What evidence is sufficient to create a commitment?
- What evidence maintains, completes or cancels it?
- Which component owns each lifecycle transition?
- How is a commitment protected from continuous reassessment and oscillation?
- How do execution outcomes alter the Current Situation without bypassing Situation Assessment?
- Does the provisional Entity concept require independent ownership or only shared vocabulary?

## Engineering Baseline

The repository is the source of project knowledge. Its primary operational audience is the continuing collaboration across new sessions; its secondary audience is future intelligent contributors.

Authoritative engineering records:

- `ENGINEERING_ARCHITECTURE.md` — constitution and release contract.
- `ENGINEERING_HANDOVER.md` — current continuation guidance.
- `CONCEPT_REGISTER.md` — accepted, deferred and rejected concepts.
- `DECISION_LOG.md` — explicit choices and rationale.
- `ENGINEERING_JOURNAL.md` and `ARCHITECTURAL_SEMINARS.md` — discovery history.
- `GLOSSARY.md` — current shared vocabulary.
- `PROJECT_CONTINUITY.md` — inheritance procedure and Engineering Continuity Test.
- `REPOSITORY_RELEASE_SYSTEM.md` and `../rrs/README.md` — repository transformation, validation evidence and operational boundary.

## Known Constraints

- Active GIANTS course-segment mapping remains unreliable through some turns.
- Course-relative ETA and remaining-distance estimates are not yet trustworthy enough for broad live priority decisions.
- Multiplayer testing remains limited.
- Older reactive and recovery systems coexist with the newer architecture and must not be casually rewritten.
- A passing repository pipeline validates packaging and selected knowledge invariants, not vehicle behaviour.

## Concept Review — v4.5.8

- Accepted: Situation Space, Current Situation, Future Space, Action Space, Situation Assessment, Commitment and derived operational Conflict Zone.
- Deferred: Opportunity; Entity naming; repository folder numbering; Operational Picture versus Current Situation terminology.
- Rejected: Conditions as a separate concept.
- Architectural distinctions: Reality versus Knowledge; Time as the evolution dimension.

## Release Character

No intentional vehicle-control, steering, speed, recovery or AI-job behaviour changes are included in v4.6.1.


## Repository Release System Consolidation

The current Engineering Increment records D-RRS-24, D-RRS-25 and D-RRS-26 and promotes Engineering Intent, Canonical Repository Snapshot, Repository Transformation and Candidate Determinism into the repository's authoritative vocabulary and architecture.

The v4.6.0 cycle validated that the consolidation author can supply declarative intent while local `rrs evolve` performs the Repository Transformation. The fingerprint gate correctly blocked a handoff after its baseline changed; regeneration against the new fingerprint passed. Independent owner review then Canonicalised the exact candidate, and the accepted content was synchronised into Git with a clean, up-to-date working tree.

The first v4.6.1 cross-platform run exposed the Artifact Determinism Gap: semantically equivalent Windows and Linux candidates had different package hashes because manifest ordering and ZIP origin metadata were platform-dependent. Candidate Production now applies one relative POSIX-path order, explicit archive metadata and platform-independent stored entries. Matching Linux and Windows candidate SHA-256 values are required before this increment may be Canonicalised.

The repository-owned implementation still performs Candidate Production only. Authority Transformation, complete ordered authority-state enforcement, independent candidate-to-canonical purity verification, a Repository Challenge Suite and a non-blocking dirty-working-tree notice remain future RRS work. They are recorded without delaying return to OuttaMyWay after the current determinism gate passes.
