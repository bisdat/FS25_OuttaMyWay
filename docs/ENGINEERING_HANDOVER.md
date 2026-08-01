# Engineering Handover

## Current candidate: v4.6.43

v4.6.43 continues from exact temporary v4.6.42 (`205bb2f435c54bca5e280bffa64d3f1174b9ce4f77d31da23b1f35897d31f64e`). Canonical authority remains owner-declared v4.6.36 until the owner explicitly Canonicalises this exact candidate.

The candidate intentionally preserves v4.6.42 runtime behaviour. It consolidates the calculated-refuge, encounter-rearming and rejoin-orientation evidence into one coherent baseline.

## Current validated sequence

```text
admit -> calculated Yield/refuge selection
-> hold -> confirmed stop -> compact
-> calculated egress -> passage confirmation
-> optional REJOIN_ORIENTING for rearward target
-> direct rejoin -> deploy -> GIANTS handback
-> successful encounter rearming
```

This sequence has completed with Condor and Patriot as Yield and with refuges on both physical lateral sides. No fixed role, side, 28 m or 12 m authority remains.

## Open problem 1 — TS015 dual-manoeuvre encounter

The first TS015 encounter now completes. A later independent collision occurs when both workers enter interacting headland manoeuvres. At the useful warning point only Condor was turning and predicted clearance remained broad; when collision geometry became convincing, both workers were manoeuvring and no admission path was eligible.

Resume with architecture, not code:

1. reconstruct the Headland Turn Overlap timeline;
2. identify what evidence distinguishes harmless simultaneous turns from converging turns;
3. determine the latest safe Commitment Point;
4. decide whether one worker can be assigned Yield before either route settles;
5. only then design an implementation experiment.

Do not treat the 5 km/h orientation speed as the established cause. Faster movement increases separation, but the earlier 15 km/h left-side TS015 run also left the later headland encounter unresolved.

## Open problem 2 — TS016 completion transition

Condor completed and became a static relevant obstacle while Patriot remained active. Situation Assessment retained the relationship, but active-active admission ended. This requires single-worker obstacle-navigation architecture, not the existing pass/wait/rejoin sequence. Keep it separate from the TS015 active-active problem.

## Repository continuation

If the owner declares this exact candidate canonical, synchronise the unchanged package into local and GitHub repositories, record its SHA-256 and Git commit, then begin the next discussion from v4.6.43 canonical.

## Deferred Publication Readiness Review

**Mod Description Drift:** restore `modDesc.xml` to a stable mod description before publication.
