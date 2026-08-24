> **D-0184 amendment (v0.1.9.1):** the in-tree `scripts/archive/v4_6_78/` copy is deleted after replacement-core authority closure. This does not reverse the original v4.7.0 decision; Git/canonical artifacts now provide the historical donor/failure record without shipping executable-looking legacy source.

# ADR-0020 — Replacement-Core Implementation Series

**Status:** Accepted; implemented by v4.7.0 bootstrap  
**Architecture authority:** owner-declared canonical v4.6.78

## Context

The v4.6.x line discovered and canonicalised the replacement-core architecture. Its executable core contains procedural Decision, lifecycle and Control assumptions that must not become the scaffold for the new implementation.

## Decision

v4.7.0 begins a new implementation series.

- The canonical v4.6.78 script tree is archived byte-exactly under `scripts/archive/v4_6_78/`.
- The archive is non-executable donor and failure evidence.
- Active `scripts/` represents the replacement core directly.
- `scripts/main.lua` is the deterministic loader.
- `scripts/runtime/Runtime.lua` is the active orchestrator.
- v4.7.0 is behaviourally inert and has zero GIANTS Observation or Control authority.
- Subsequent v4.7.x increments implement only canonical v4.6.78 responsibilities.

## Consequences

The first release intentionally removes existing gameplay intervention. Functionality returns through bounded, independently validated vertical slices. No active module may source or call archived code. Implementation difficulty cannot introduce new architecture; an apparent contradiction is a stop condition for owner review.
