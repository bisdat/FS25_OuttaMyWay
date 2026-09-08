# Phase 14.5 — Runtime Integration Consolidation

## Purpose

Phase 14.5 removes the remaining load-order monkey-patching used to introduce
accepted D-0218 Causal Obstruction relocation and the Phase-13 Prospective
Decision Portfolio.

Accepted baseline is `main` after PR #76 merge:

`4c4924b9d52dbfb15afe99f7f2ae231466a0b29a`

Canonical authority remains **v0.3.0.0**. Last accepted playable identity at
design time is:

**`0.3.0.24 TEST — NON-JOB ACTUATION MECHANISM GRADUATION`**

The governing discoveries are:

**Runtime Composition != Runtime Patching**

and:

**Composition Order != Load Order**

## Current Reality

Two accepted strangler seams remain active:

- `scripts/runtime/ObstructionRelocationRuntimeIntegration.lua`
- `scripts/runtime/ProspectiveDecisionPortfolioIntegration.lua`

Their behaviour is accepted. Their placement is not intended to be permanent.

`main.lua` currently loads `Runtime.lua`, then D-0218 integration, then Portfolio
integration. Each later file captures and replaces functions from the previous
layer, so source load order currently carries production orchestration meaning.

## Permanent ownership

There is no durable architectural responsibility named "Integration" here.

- raw current-physical relocation pose augmentation belongs to production
  **Observation**, specifically `LiveObservationSource`;
- collaborator construction, live-cycle orchestration, selected Portfolio
  support-boundary projection and purpose dispatch sequencing belong to
  **Runtime**;
- Candidate, Decision, Responsibility Transition, Bounded Authority and Control
  remain owned by their existing modules.

## Target composition

### Observation

Absorb the accepted `CurrentPhysicalPoseSource` augmentation at the exact same
causal point as today: after `LiveObservationSource.capture()` has constructed
its complete raw Observation set and before those values return to Runtime for
sealing.

The existing assignment of `currentPhysicalPoseSource` to the live source is
preserved. This tranche does not redesign the constructor API.

### Runtime construction

Absorb the wrapper additions immediately before `Runtime.new()` returns,
preserving accepted construction order:

1. base Runtime construction;
2. `CurrentPhysicalPoseSource`;
3. cold `ObstructionRelocationCandidateSupport`;
4. warm/cold composite support;
5. `ObstructionRelocationResponsibilityTransition`;
6. `ProspectiveDecisionPortfolioSupport`.

### Runtime dispatch

Encode the accepted wrapper order explicitly:

**Portfolio Projection → Cold D-0218 → Existing Runtime Dispatch**

The selected Portfolio Candidate's original local support boundary is projected
before D-0218 or the existing warm D-0147 / Regulation / Cooperative Passage
path consumes it.

### Live-cycle orchestration

Absorb the accepted Portfolio implementation of
`Runtime:processLiveObservation()` unchanged in behaviour:

- incumbent Commitment context remains on the existing single-purpose support
  path;
- fresh scope uses `ProspectiveDecisionPortfolioSupport`;
- the conservative fallback remains;
- Cooperative Passage constraint-verdict tracing remains.

## Behaviour preservation contract

Phase 14.5 is a restructure only. It must preserve:

- GIANTS Job Episode and productive-route ownership;
- current physical pose evidence and provenance;
- warm D-0147 versus cold D-0218 separation;
- cold-before-warm support ordering;
- D-0218 first-courtesy semantics and fresh-Situation settlement;
- `OBSTRUCTION_RELOCATION_ACTUATION`;
- `historicalJobProvenanceRequired=false`;
- Prospective Portfolio fresh-scope use only;
- incumbent Commitment lifecycle gating;
- selected Portfolio local support-boundary projection;
- existing Portfolio compatibility / Decision policy;
- Regulation ordering and speed;
- Cooperative Passage geometry, Commitment and Control behaviour;
- Player Claim and source-AI supersession;
- Bounded Authority / ControlRequest contracts;
- externally visible reasons and provenance values.

Historical provenance strings naming the old integration seams may remain where
changing them would widen this tranche into vocabulary migration. Phase 14.6
owns that cleanup.

## Explicit non-goals

Phase 14.5 does not create a new Runtime Coordinator abstraction, move Candidate
or Decision authority into Runtime, alter support precedence, rename support
boundary modes, tune traffic policy, modify Passage geometry, alter D-0147 or
D-0218 physical mechanics, redesign `LiveObservationSource.new()`, or address
Phase-14.6 configuration/constants/vocabulary debt.

## Validation

Blocking Structural contracts must prove:

- both integration files are deleted and unsourced;
- no production source retains `originalRuntimeNew`, `originalRuntimeDispatch`
  or `originalSourceCapture`;
- Observation directly performs current physical pose augmentation before raw
  observations return for sealing;
- Runtime explicitly constructs all formerly injected collaborators;
- Runtime owns Portfolio projection and D-0218 sequencing;
- fresh Portfolio and incumbent lifecycle branches remain distinct;
- semantic authority classes and purpose-specific Control remain unchanged.

GitHub Actions remains the pytest execution authority.

Local preflight is limited to deterministic source/equivalence guards, LuaJIT
syntax checks for changed production Lua and `git diff --check`.

Because this tranche touches central live-cycle composition, GIANTS Reality
must demonstrate routing for: fresh Regulation, fresh Cooperative Passage, warm
D-0147 terminal courtesy, and cold D-0218 Causal Obstruction relocation.
