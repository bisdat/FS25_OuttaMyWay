# ADR-0018 — Architecture Consolidation and Experimental Reset

**Status:** Accepted; owner-declared canonical in v4.6.71  
**Date:** 2026-08-04

## Context

Owner-declared canonical v4.6.56 supplied a trusted documentation-first runtime baseline. Temporary v4.6.57–v4.6.70 then formed one long evidence cycle. The cycle produced substantial architectural discoveries and several locally validated capabilities, but every later complete chain retained a material runtime failure.

The final v4.6.70 run completed its first refuge, passage, work restoration and Native Handover. A later Encounter held Patriot until map-clear because the counterfactual release projection used the 60 km/h cruise-control ceiling as expected native speed and required non-closing motion. Promoting v4.6.70 would therefore promote a known failure. Returning to v4.6.56 without consolidation would discard architectural knowledge.

## Decision

Adopt **Experimental Reset**:

1. Build v4.6.71 from the exact v4.6.56 canonical implementation baseline.
2. Preserve v4.6.56 executable runtime behaviour, except coherent version identity.
3. Integrate durable v4.6.57–v4.6.70 architecture, named discoveries, decisions, evidence fingerprints and disproven hypotheses as repository knowledge.
4. Do not include later architecture/control modules, candidate-only lifecycle tests or experimental threshold values as active implementation.
5. Classify each later ADR explicitly as accepted architecture, supported runtime instance, superseded path, rejected hypothesis or unresolved implementation.
6. Begin the next engineering increment with Observe → Discuss → Hypothesise rather than continuing v4.6.70 by default.

## Architectural status

Accepted architectural knowledge includes:

- Situation, Encounter and Commitment identity separation;
- Native Handover responsibility boundaries;
- identity/value and dynamic-configuration snapshot boundaries;
- repeated Encounter and Option Preservation principles;
- provisional-refuge and atomic-transition preconditions;
- manoeuvre-leg commitment, settled boundaries and leg-local frames;
- bounded steering acquisition;
- coherent leases, counterfactual Safe Release and never-hold-all authority.

Acceptance of architecture does not imply acceptance of the first implementation.

## Rejected final hypotheses

- cruise-control ceiling as expected GIANTS continuation speed;
- non-closing motion as a universal release precondition;
- v4.6.70 as a suitable canonical runtime baseline.

## Next unresolved Knowledge

A future **Native Continuation Speed Estimate** may use recent unmodified GIANTS operating behaviour, worker phase and manoeuvre state. This is a research direction, not a decision to implement a particular estimator.

## Consequences

- The repository receives one coherent handoff package instead of requiring a new conversation to reconstruct fourteen temporary candidates.
- Runtime trust and architectural learning are separated rather than traded against each other.
- Future implementation can reuse experimental evidence deliberately, but cannot inherit experimental authority accidentally.
- v4.6.70 remains an optional donor/evidence package, not the baseline.
