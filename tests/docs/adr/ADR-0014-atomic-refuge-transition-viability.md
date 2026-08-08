# ADR-0014 — Atomic Refuge Transition Viability

**Status:** Accepted architectural refinement; supported by later runtime evidence; implementation inactive in v4.6.71.

## Context

v4.6.66 correctly treated refuge occupancy as provisional and recalculated a replacement after material intent change. During the first TS015 encounter, Condor had already reached a viable refuge. At approximately 47.94 m separation and 5.52 s to closest approach, Decision selected an opposite-side replacement requiring approximately 58.20 m of travel. The endpoint was geometrically viable, but the transition was not executable in the remaining time.

Control committed the replacement target and new side frame before validating that transition. Condor's existing safe pose therefore appeared to violate the new centreline fence immediately. Native Reposition failed held, later Decision actions held Patriot as well, and the system produced the prohibited all-hold outcome.

This is a refinement of **Commitment Preconditions**, **Commitment Viability Decay** and **Passage Corridor Is Not Continuation Corridor**. It does not introduce a new architectural subsystem.

## Decision

1. Endpoint viability is necessary but insufficient. A replacement refuge requires a viable transition from the assembly's current pose.
2. Decision shall assess and publish: candidate identity, current-pose travel, optimistic Control duration, available temporal reserve, path/field/progress-preservation evidence, and whether the movement changes refuge side.
3. A replacement is authoritative only when the transition is classified `VIABLE`. An `UNSAFE` or unresolved transition leaves the current refuge and current side frame authoritative.
4. Decision and Control form a two-stage transaction. Decision proposes and authorises; Control revalidates the same candidate and evidence before mutating active-run state.
5. Target, side vector and centreline-fence authority are committed atomically. A failed Control validation must not partially alter the run.
6. An explicitly authorised cross-side transition uses a temporary transition frame. The new centreline fence becomes authoritative only after the assembly reaches the new side.
7. Where replacement movement is unsafe, Decision retains the current refuge and may use admissible upstream temporal support. It must not create an implicit all-hold state.
8. Role changes remain separate Decisions and capability transitions; target revision cannot silently exchange Yield and Progress.

## Consequences

- A geometrically attractive but unreachable refuge cannot displace a currently safe refuge.
- The centreline fence remains a safety mechanism rather than becoming a side-change failure trigger.
- Same-side, longitudinal and diagonal revisions remain available when their transitions are executable.
- Cross-side revisions remain possible but require explicit evidence and authority.
- Supporting speed remains purpose-bound and is not claimed sufficient when it cannot create the required transition time.
- Existing Native Handover, configuration restoration, repeated Encounter and identity/value architecture remains unchanged.

## Validation

Run TS015 continuously. Require the approximately 58 m / 5.52 s first-encounter cross-side proposal to be rejected without changing Condor's target or side frame. Patriot must remain under GIANTS control and pass the retained refuge. Later executable refuge revisions must still produce `ARCHITECTURE REFUGE_REVISED ... authority=atomic-current-pose-transition`, followed by positive passage, work restoration and independent GIANTS continuation.
