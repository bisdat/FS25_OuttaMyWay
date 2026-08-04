# ADR-0015 — Manoeuvre Leg Commitment

**Status:** Accepted architectural refinement; supported by v4.6.68 runtime evidence; implementation inactive in v4.6.71.  
**Date:** 2026-08-04

## Context

v4.6.67 correctly required executable and atomic refuge replacement. Runtime evidence nevertheless showed five accepted target revisions during one final Condor refuge movement. Four revisions changed side. Each proposal was locally executable, but repeated redirection produced indecisive motion and ultimately a centreline-fence failure.

The existing architecture already states that frequent reassessment does not automatically justify frequent intervention. The missing implementation boundary was between continuously updated Knowledge and new physical steering authority.

## Decision

A Native Reposition movement is executed as a bounded **manoeuvre leg**.

```text
select and validate target
→ commit one manoeuvre leg
→ execute decisively while Situation Assessment continues
→ reach a settled movement boundary
→ reassess from current Reality
→ remain or commit one next manoeuvre leg
```

A newly preferred refuge remains advisory while the current leg is viable. It may become authoritative normally only after the leg reaches `SIDESTEP_HOLD` or another explicit settled boundary.

Early interruption is separate authority. It requires demonstrated loss of admissibility, such as imminent collision, field-containment loss, path obstruction or Control-reported inability to complete the leg. A cheaper or differently ranked candidate is insufficient.

## Consequences

- Situation Assessment remains continuous.
- Decision records pending reassessment without revising the Commitment target mid-leg.
- Control rejects ordinary target replacement during `EGRESS`.
- The settled pose becomes the origin for the next transition assessment.
- Atomic transition viability from ADR-0014 remains mandatory for every subsequent leg.
- Repeated movement remains possible: move once, settle, reassess, move again when necessary.

## Validation

Continuous TS015 must show one coherent Condor movement per leg, no ordinary mid-leg side reversal, and any additional refuge movement beginning only after a visible settled boundary.
