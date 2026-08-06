# Repository Review

> **Authority:** Canonical governance record
>
> **Currency:** Last reviewed for canonical release v4.5.8

## Purpose

Repository Review is an explicit engineering stage after canonical release. It evaluates whether the repository itself preserves and exposes enough knowledge for engineering to continue correctly.

## Evidence from the Governance Review

The reviewer naturally followed the repository breadcrumb trail from the documentation map to the Decision Log without guidance. More importantly, the reviewer correctly predicted that a deferred repository-numbering decision should be found in `DECISION_LOG.md`.

This distinguishes two levels of Engineering Continuity:

1. **Navigation** — can an engineer find the correct document?
2. **Prediction** — can an engineer predict which document should contain a class of knowledge?

A repository succeeds when it supports both, exposes omissions, and enables engineering to continue.

## Lifecycle

```text
Architecture
    ↓
Implementation
    ↓
Validation
    ↓
Canonical Release
    ↓
Repository Review
    ↓
Repository Findings
    └──────────────→ Architecture
```

Repository findings are evidence. They may revise governance or architecture in a later canonical release.

## Repository Completion Patch

A Repository Completion Patch records already-agreed knowledge that was omitted from a release. It introduces no new engineering or architecture; it completes the repository record and still requires a version increment and full package.

## Repository Identity Check

Before declaring a package canonical, independently compare the packaged ZIP itself against the intended release identity. At minimum confirm:

- package filename;
- `modDesc.xml` version;
- `scripts/config.lua` version;
- `PROJECT_STATUS.md` version and package;
- `ENGINEERING_HANDOVER.md` version and package;
- both changelog release headings;
- ZIP-root placement of `modDesc.xml`;
- repository verifier and manifest results.

The check is independent of generation. A filename or successful build claim is not evidence that the packaged repository contains the intended state.

## Recovery Rule

If canonical status is questioned, reconstruct history from the last verified canonical baseline and preserved review or seminar records. Do not reconstruct from recollection alone.
