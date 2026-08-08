# ADR-0012 — Repeated Encounter and Option Preservation

## Status

Accepted architectural composition; refined through v4.7.34 Traffic Policeman Decision Ordering; production Traffic Policeman/Control implementation remains absent.

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

Yield and Progress roles are recalculated from current Reality for every Encounter. ADR-0023 assigns that temporary movement-priority responsibility to Traffic Policeman at Decision level. Roles may transfer within one Commitment only when current evidence shows that transfer reduces or settles unresolved obligations or materially improves admissible resolution capability; repeatedly swapping which participant is held/unknown without such progress is Revelation Oscillation and is not a valid strategy. Later refuge selection remains clearance-first, considers both sides, requires field containment and uses the existing work-restoration/native-handover lifecycle.

## Consequences

- The v4.6.64 primary TS015 lifecycle remains unchanged.
- The duplicate term **Option Creation Window** is retired as an alias of **Option Preservation Window**.
- Persistent Situation Relevance retains useful knowledge but does not preserve an old Commitment or Control prohibition.
- Early temporal shaping may occur while another bounded capability remains active.
- The implementation is generic A/B assembly logic; Condor, Patriot, TS015 and TS016 identities are prohibited from Decision and Control policy.
- Runtime validation must exercise at least three successive Encounters inside one Situation: initial refuge, the Progress participant's return, and the former Yield participant's later return.
- Multiple combines, combine unloading, cross-field coordination and general route planning remain excluded.

## v4.7.29 amendment — current recovery versus later encounter

While a refuge ingress/restoration, BNIR, Native Handover or other obligation created by the current resolution remains unsettled, material changes in either participant are reassessed inside the same governing Encounter. After true Safe Release, a later materially new convergence is a fresh Encounter and receives newly calculated Traffic Policeman roles. OuttaMyWay resolves encounters; it does not permanently deconflict the workers' complete remaining jobs.

## v4.7.34 amendment — strict Traffic Policeman preference ordering

The established action order is a strict **Decision preference sequence**, not a procedural Control fallback ladder:

```text
CONTINUE_OBSERVATION
→ REGULATE_SPEED
→ HOLD_AT_SAFE_POINT
→ NATIVE_REPOSITION
```

A later primary band is considered only after every earlier band is explicitly exhausted against the same current governing traffic requirement in the same Decision epoch. Exhaustion may be established from current Knowledge; candidates need not be physically attempted. A material Reality or Control Outcome starts a fresh Decision epoch and reevaluates the current Candidate Action Space from the least-disruptive end.

`HOLD_AT_SAFE_POINT` means the participant's **current realised occupancy** is itself a supportable stationary waiting occupancy. If GIANTS-owned bounded progression can still reach a useful stopping condition, Regulation remains preferred. If a newly selected spatial displacement is required to create a waiting occupancy, that action is Reposition. Reposition is direction-agnostic and may use forward, reverse or composed bounded movement where capability and Representation Fitness support it.

Reposition exhaustion is participant-complete. Failure of the currently preferred Yield participant's candidates does not establish autonomous-resolution exhaustion; Decision must evaluate supportable spatial candidates under the alternate admissible role assignment before escalation.
