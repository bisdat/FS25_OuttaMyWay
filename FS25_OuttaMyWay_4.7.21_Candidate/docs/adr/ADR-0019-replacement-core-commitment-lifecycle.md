# ADR-0019 — Replacement-Core Commitment Lifecycle and Obligation Continuity

**Status:** Accepted; owner-declared canonical in v4.6.78  
**Date:** 2026-08-05

## Context

The v4.6.57–v4.6.70 experimental cycle demonstrated that locally effective capabilities did not provide a complete architectural owner for:

- continuing intent;
- multi-stage strategy;
- evidence insufficiency;
- completed-worker occupancy;
- player takeover;
- Operation termination;
- replacement Job Episodes;
- terminal restoration and release;
- composition of simultaneous Control effects.

The subsequent architecture-core discussion established completed-worker and Terminal Occupancy concepts, `WAITING_FOR_EVIDENCE`, Preference-band exhaustion, Representation Fitness and independent Job Episode admission.

The remaining lifecycle problem was whether a live Commitment could terminate through Intent Supersession without abandoning obligations or permitting conflicting authority.

## Decision

Adopt a replacement-core Commitment lifecycle with:

### Non-terminal states

- `ACTIVE`
- `WAITING_FOR_EVIDENCE`
- `SETTLING`

### Terminal dispositions

- `SUCCEEDED`
- `FAILED`
- `SUPERSEDED_BY_NEW_INTENT`
- `CANCELLED_BY_SOURCE_INTENT_TERMINATION`
- `CANCELLED_BY_OPERATION_TERMINATION`

### Governing Basis

Every Commitment records the admitted intent or intent set and Operation context that make its objective applicable.

The first authoritative event that invalidates the Governing Basis determines the intended terminal cause.

### Obligation Continuity

Every open Obligation has exactly one owning Commitment.

An Obligation settles only through:

- satisfaction;
- evidenced basis cessation;
- atomic accepted transfer to an eligible successor Commitment.

The player, Operation, Situation Assessment, Decision and Control are not fallback internal Obligation owners.

### Terminal Settlement

A Commitment may enter a terminal disposition only after every Obligation is accounted for.

Safe Release and Safe Handover are specialised Terminal Settlement Points.

### Intent Supersession

`SUPERSEDED_BY_NEW_INTENT` is a first-class terminal disposition.

A newly admitted authoritative intent immediately owns new progress. The predecessor enters `SETTLING`, loses old objective-progress authority and retains origin-bound settlement responsibility.

Predecessor and successor may coexist during a bounded Supersession Handover Interval. Conflicting progress authority is forbidden.

### Player takeover

Player control ends the affected AI Job Episode and OuttaMyWay progress authority over that assembly.

Internal Obligation objects do not transfer to the player. Continuing AI-coordination responsibilities remain internally owned.

### Terminal Occupancy

A completed worker remains relevant when its occupancy materially affects active Committed Demand or Potential Demand.

A Terminal Occupancy Commitment owns resolution until occupancy is resolved, responsibility transfers internally, or relevant active demand demonstrably ceases.

### Operation termination

Operation membership reaching zero does not erase origin-bound Control, authority, configuration or evidence obligations.

A Commitment may remain in `SETTLING` after ordinary Operation participation ends.

### Authority composition

Only one Commitment may own objective-progress actuation for one assembly at a time.

Decision and Control must validate the complete Effective Actuation Composition, including residual predecessor effects and concurrent actions on relevant assemblies.

## Obligation classes

- **Origin-bound:** cannot transfer.
- **Continuity:** may transfer to an eligible accepting Commitment.
- **Intent-relative:** may settle through evidenced basis cessation when the governing intent changes.
- **Evidence:** follows the supported obligation except predecessor-effect evidence, which remains origin-bound.
- **Accountability:** origin-bound.

## Continuing Intent Priority

A live admitted intent governs ordinary resolution until it genuinely ends or a new authoritative intent is independently admitted.

Blockage, temporary Hold, inactivity, evidence insufficiency and strategy failure do not themselves end intent.

## Paper validation

The model was traced through twelve representative situations:

1. ordinary successful resolution;
2. multi-stage refuge and rejoin;
3. evidence insufficiency;
4. preference-band exhaustion;
5. Representation Fitness failure;
6. Terminal Occupancy;
7. player takeover;
8. stop, reposition and restart;
9. GIANTS abort/fault;
10. supersession;
11. Operation termination with remnant;
12. invalid action composition.

No lifecycle dead end or ownerless obligation was found.

The validation added three mandatory refinements:

- Governing Basis;
- first authoritative invalidation determines terminal cause;
- Effective Actuation Composition with one progress owner per assembly.

## Consequences

- Terminal Occupancy, player takeover, Operation termination and Intent Supersession share one lifecycle and obligation model.
- Multi-stage strategies remain one Commitment.
- Capability completion cannot terminate a Commitment.
- Missing evidence cannot manufacture settlement.
- Implementation event order cannot define architectural meaning.
- No generic cleanup owner is introduced.
- Future implementation must begin with passive contracts and tests rather than scenario-specific Control.

## Deferred implementation discoveries

This decision does not define:

- Native Continuation Speed estimation;
- reverse actuation;
- numerical thresholds;
- exact candidate-generation geometry;
- GIANTS capability adapters;
- runtime storage structures.

Those may refine implementation but cannot silently weaken the ownership, lifecycle or settlement contracts.

## Experimental-line reconciliation

The actual v4.6.72–v4.6.77 runtime-validation line is not the implementation of this ADR. Its v4.6.77 lifecycle failure is negative evidence supporting the enforcing state-machine, Obligation Continuity and Effective Actuation Composition requirements.
