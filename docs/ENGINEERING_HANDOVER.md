# Engineering Handover

## Purpose

This document provides the context required for an engineer to resume work on the repository after any interruption. It is intentionally version-independent and complements the repository's permanent engineering records. Its purpose is to explain where engineering should continue, not to record release history.



## Canonical Baseline

The current canonical repository is always supplied separately by the engineer.

The Repository Release System (RRS) consumes that canonical baseline together with a declared repository transition and produces:

- a candidate repository package;
- an accompanying evidence package.

The RRS validates the repository transition but does not declare a repository canonical. Canonical status is an explicit engineering decision made only after independent verification.



## Current Engineering Focus

Continue architectural discovery at the boundary between Situation Assessment and Commitment.

Implementation should not begin until:

- ownership is understood;
- evidence thresholds are defined;
- commitment lifecycle transitions are understood.

Vocabulary reviews (for example Entity naming or Operational Picture terminology) should remain architectural discussions rather than implementation work.



## Architectural Context

The architectural seminar series established several enduring concepts that now form part of the repository knowledge.

Accepted concepts include:

- Situation Space
- Future Space
- Action Space
- Current Situation
- Situation Assessment
- Reality and Knowledge as distinct concepts
- Time as the dimension in which the architecture evolves
- Conflict Zone as a derived operational concept

Rejected concepts include:

- Conditions

Deferred concepts include:

- Entity naming
- Operational Picture terminology

The authoritative status of every concept is maintained within the Concept Register rather than this document.



## Repository Entry Point

When resuming engineering work, read the repository in the following order:

1. `docs/README.md`
2. `PROJECT_STATUS.md`
3. `CONCEPT_REGISTER.md`
4. `DECISION_LOG.md`
5. `GLOSSARY.md`
6. `ARCHITECTURAL_SEMINARS.md`

This sequence provides project status, accepted concepts, engineering decisions, shared vocabulary and the reasoning behind the architecture.



## Repository Release System

The Repository Release System exists to support disciplined repository evolution.

Its responsibilities are to:

- Preserve Engineering Knowledge
- Protect Repository Transitions
- Validate Repository State

The Repository Release System is responsible for validating repository transitions and producing release artefacts.

The engineer remains responsible for:

- architectural intent;
- engineering judgement;
- implementation decisions;
- reviewing release evidence;
- declaring a repository canonical.



## Engineering Principles

Engineering work should continue using the established workflow:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat

Evidence takes precedence over assumptions.

Architecture should describe the observed system rather than implementation convenience.

When evidence contradicts architecture, the architecture should evolve.

Implementation should preserve architectural intent while minimising behavioural change.



## Repository Philosophy

The repository is intended to be a self-sustaining engineering system.

Its documentation should allow future engineering work to resume from repository knowledge rather than conversation history.

Every enduring architectural discovery should eventually become repository knowledge.

The Repository Release System exists to protect that knowledge while enabling safe, repeatable and traceable repository evolution.


## RRS Recovery Continuation Point

The accepted RRS decisions D-RRS-01 through D-RRS-23 have been promoted into the repository's governing and supporting knowledge stores. Continue by independently reviewing the v4.6.0 candidate and its RRS evidence. The repository owner alone may Canonicalise the exact reviewed candidate.

Do not treat candidate production as Canonicalisation. The recovered implementation currently ends after candidate validation and evidence production. Authority Transformation, ordered state enforcement and candidate-to-canonical purity verification remain explicit future implementation boundaries.
