# Replay Validation Specification

> **Purpose:** make architecture composition testable before another live Control build.

## Input contract

A replay fixture contains ordered, immutable records for:

- Observation Snapshots;
- source and timestamp provenance;
- admitted Job Episode and Operation epochs;
- assembly identities and representation records;
- historical Control Outcomes where the fixture reaches an executed action;
- expected material decision and lifecycle epochs.

Replay does not simulate GIANTS physics. It verifies architecture decisions and lifecycle reactions against recorded Reality.

## Required historical fixtures

1. v4.6.49 successful local passage behaviour as behavioural-oracle evidence.
2. v4.6.57 freeze-line evidence where available.
3. v4.6.64 primary work recovery and Native Handover evidence.
4. v4.6.70 Hold-release failure.
5. v4.6.72–v4.6.77 TS015 traces, especially v4.6.77 around architecture time `t=209.3s`.
6. TS016 crossing/head-on evidence.
7. no-mod and loaded/no-encounter controls.

## Mandatory assertions

- no `SUCCEEDED` or ordinary completion with unresolved Terminal Settlement;
- Intent Expiry cannot erase open obligations;
- v4.6.77 `CM-00001` remains live after the illegal `safeRelease=false` completion request;
- no `CM-00002` is admitted against the same unresolved recovery responsibility;
- Follower Owns Closure makes generic Leader reposition inadmissible unless explicit exception evidence passes all constraints;
- a settled refuge may authorise another manoeuvre leg only within the same unresolved Commitment;
- no candidate with `FAIL` or `UNRESOLVED` mandatory fitness receives progress authority;
- no stale Operational Picture or Governing Basis reaches Control;
- one assembly never has two objective-progress owners;
- Effective Actuation Composition rejects incompatible concurrent or residual effects;
- player takeover ends OuttaMyWay progress authority over that assembly while preserving relevant observation and coordination;
- Operation membership reaching zero does not erase origin-bound settlement obligations.

## Gate results

A replay run produces:

- deterministic Candidate Action inventory;
- complete Constraint Verdict Sets;
- selected Decision or explicit non-intervention;
- Commitment transition record;
- Obligation ownership history;
- authority and capability reservations;
- conformance pass/fail with the earliest divergence.

No passive-live or active Control gate opens until the mandatory replay suite passes from a clean repository state.
