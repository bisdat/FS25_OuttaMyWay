# Project Continuity

> **Authority:** Canonical continuity procedure
>
> **Currency:** Last reviewed for canonical release v4.5.8

## Purpose

This document answers one question:

> If every previous conversation, engineer-specific memory and earlier repository were lost, can meaningful engineering continue correctly using only this repository?

A canonical release must make the answer **yes**.

## Inheritance Procedure

1. Begin at [`README.md`](README.md) and follow its breadcrumb trail without relying on outside context.
2. Confirm the version in `PROJECT_STATUS.md`, `ENGINEERING_HANDOVER.md`, `modDesc.xml` and `scripts/config.lua` agrees.
3. Read the immediate objective and resume point before proposing implementation.
4. Read the relevant architecture, concept register, decisions, evidence and known issues.
5. Distinguish facts, observations, interpretations, decisions and implementation ideas.
6. Run `python tools/verify_repository.py --version <version>` before trusting repository coherence.
7. Treat reality, logs, measurements and tests as capable of disproving repository knowledge.

## Canonical Baseline Rule

> Any modification to the repository shall begin with the current canonical repository being supplied as the implementation baseline.

This is state-oriented rather than session-oriented. Discussion, review and hypothesis work may occur without modifying the repository. Once repository modification begins, the supplied canonical package is the only permitted baseline.

Every repository modification:

- increments the version;
- preserves the complete development repository;
- records discoveries, decisions and review outcomes;
- passes validation and packaging checks;
- produces a new immutable canonical package.

## Engineering Continuity Test

Before release, the builder must challenge the repository as though no prior context exists.

The test has three explicit outcomes:

- **Navigation:** the engineer can find the correct authoritative document.
- **Prediction:** the engineer can correctly predict which document should contain a class of knowledge.
- **Overall Assessment:** the engineer can continue engineering and identify omissions without outside context.

The release passes only when a competent engineer can determine from the repository alone:

- what player outcome the project seeks;
- how engineering decisions are made;
- the current driving architecture and implementation boundaries;
- the current canonical state and immediate next objective;
- which concepts are Accepted, Deferred or Rejected;
- which hypotheses or approaches have been disproved;
- where evidence, decisions and history belong;
- how to validate and package the next canonical release.

The builder validates internal coherence. An independent reviewer validates the reader journey by following the breadcrumb trail. Reviewer findings are evidence for the next release, not wasted effort. After packaging, the independent reviewer also performs the Repository Identity Check described in `REPOSITORY_REVIEW.md`.

## Continuity Failure

A continuity failure exists when important knowledge is available only through memory, conversation, an unstated assumption or an obsolete document path.

When found:

1. name the missing concept or responsibility;
2. record the evidence;
3. place the knowledge in one authoritative home;
4. update navigation and verification where practical;
5. release the correction as a new canonical version.
