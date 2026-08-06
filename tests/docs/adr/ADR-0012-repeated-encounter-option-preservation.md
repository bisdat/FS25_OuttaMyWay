# ADR-0012 — Repeated Encounter and Option Preservation

## Status

Accepted architectural composition; supported in part by v4.6.65 runtime evidence; implementation inactive in v4.6.71.

## Context

v4.6.64 completed the primary TS015 intervention: refuge entry, positive passage, approximate return, restoration of OuttaMyWay-owned configuration, native handover and independent continuation all succeeded without a freeze. A later convergence nevertheless became actionable only at approximately 27 m separation and 3 s to closest approach, after useful avoidance options had already collapsed.

The repository had already established **Option Preservation Window**, **Intent Expiry**, **Encounter Identity Is Not Entity-Pair Identity**, **Earliest Sufficient Action**, **Option-Preserving Augmentation**, **Commitment Viability Decay**, **Headland Turn Overlap** and **Passage Corridor Is Not Continuation Corridor**. The failure was therefore not absence of architecture. These concepts were not composed into the active repeated-encounter lifecycle.

## Decision

### Situation, Encounter and Commitment identity

One persistent Situation may contain multiple Encounters. Each new material manoeuvre produces a new local intent epoch. After a recovered Encounter reaches Safe Release, its Commitment completes while Situation relevance may persist. A later convergence receives a fresh Encounter and Commitment identity; the completed Commitment and post-handover guard do not carry forward.

### Intent Expiry

Intent does not expire on every small heading increment. During a material turn it is represented as `TURNING`; settlement into a materially different bounded heading sector creates the next intent epoch. Fold/deploy and working/manoeuvring transitions continue to invalidate the previous continuation assumption.

### Option Preservation Window

When a still-relevant participant begins or settles a manoeuvre that redirects its Future Space toward another participant's occupied or unresolved continuation space, Situation Assessment publishes a bounded distance/time option plan. Decision applies the earliest sufficient action before a direct emergency conflict is required.

The action order remains:

```text
CONTINUE_OBSERVATION
→ REGULATE_SPEED
→ HOLD_AT_SAFE_POINT
→ NATIVE_REPOSITION
```

The speed ceiling is derived from current separation, both assemblies' represented widths, clearance margin and required temporal reserve. It is not tied to a fixture identity or a fixed phase speed.

### Supporting speed lease

A cooperative refuge Commitment may retain one primary Native Reposition capability while applying a bounded supporting speed lease to the Progress participant. The lease preserves option space during a returning manoeuvre, retains the exact original forward and reverse cruise values, and can be promoted after native handover without recapturing an already constrained speed as the restoration baseline.

### Control outcome projection

The public Control outcome must preserve every postcondition needed by Commitment completion. Native Reposition therefore projects configuration restoration, work capability, handover time and authority relinquishment from the controller result into the Operational Picture. Physical evidence may not be discarded at a layer boundary.

### Repeated role assessment

Yield and Progress roles are recalculated from current Reality for every Encounter. Later refuge selection remains clearance-first, considers both sides, requires field containment and uses the existing work-restoration/native-handover lifecycle.

## Consequences

- The v4.6.64 primary TS015 lifecycle remains unchanged.
- The duplicate term **Option Creation Window** is retired as an alias of **Option Preservation Window**.
- Persistent Situation Relevance retains useful knowledge but does not preserve an old Commitment or Control prohibition.
- Early temporal shaping may occur while another bounded capability remains active.
- The implementation is generic A/B assembly logic; Condor, Patriot, TS015 and TS016 identities are prohibited from Decision and Control policy.
- Runtime validation must exercise at least three successive Encounters inside one Situation: initial refuge, the Progress participant's return, and the former Yield participant's later return.
- Multiple combines, combine unloading, cross-field coordination and general route planning remain excluded.
