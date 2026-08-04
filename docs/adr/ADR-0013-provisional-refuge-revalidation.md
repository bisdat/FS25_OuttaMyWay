# ADR-0013 — Provisional Refuge Revalidation and Purpose-Bound Speed Support

**Status:** Accepted architectural refinement; v4.6.66 implementation failed and is inactive in v4.6.71.

## Context

v4.6.65 validated repeated Encounter identity, Intent Expiry, work restoration and field-contained refuge selection. The final TS015 Encounter still failed after Condor reached an initially viable refuge. Patriot then changed intent during its headland manoeuvre and its continuation corridor rotated through the occupied refuge. Situation Assessment calculated materially different candidates, but the active Native Reposition continued treating the first refuge as final. The supporting speed lease also acquired and released on alternating samples.

This is an implementation instance of existing architecture: **Commitment Viability Decay**, **Passage Corridor Is Not Continuation Corridor**, **Intent Expiry** and **Option Preservation Window**. No duplicate discovery name is introduced.

## Decision

1. A refuge is a provisional safe state relative to current Knowledge. It remains subject to Commitment Preconditions until positive passage and Safe Release.
2. A material pair-intent change invalidates the refuge assessment cache and requires current-role refuge revalidation across conflict-relevant relationship classes.
3. Situation Assessment publishes the full candidate epoch. Decision selects the least-cost viable candidate for the currently controlled Yield assembly and compares it with the occupied refuge.
4. When the revised candidate requires material additional travel, Decision revises the same Commitment. Control changes the active Native Reposition target from the assembly's current pose without restarting the run, recapturing configuration or reconstructing the GIANTS route.
5. A role change cannot be smuggled through a target revision. It requires a separate capability decision.
6. Supporting speed authority is purpose-bound. It remains active while refuge viability or passage is unresolved and is released only after positive passage or sustained clear and improving evidence.

## Consequences

- A single Encounter may contain more than one refuge movement.
- Additional movement may be lateral, longitudinal or diagonal; no x/y fixture rule exists.
- The first viable candidate is not permanent authority.
- Speed-control chatter is prevented by separate acquisition and release evidence.
- Native Handover, work restoration, identity/value separation and repeated Encounter architecture remain unchanged.

## Validation

Run TS015 through the final Condor refuge. Require `ARCHITECTURE REFUGE_REVISED` before terminal blockage when Patriot changes intent, stable supporting-speed authority, field-contained additional movement, positive passage, work restoration and independent GIANTS continuation.
