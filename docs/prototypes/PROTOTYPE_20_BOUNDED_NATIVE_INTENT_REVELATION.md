# Prototype 20 — Bounded Native Intent Revelation

## Purpose

Test one prerequisite capability only: whether one active GIANTS field-worker Job Episode can survive a complete `Hold → transit configuration → bounded native movement → re-Hold → restore → unrestricted native continuation` sequence while the bounded movement exposes useful native Local Intent.

This prototype does not test two-worker Safe Release, Encounter resolution, obstacle avoidance or production Control policy.

## Baseline and candidate

- owner-declared canonical baseline: v4.7.24
- baseline ZIP SHA-256: `ded22bb56893c86c20e0b5654e66a1469b29b31e1be4733c1d212c0be19b0e56`
- baseline Git: `9c2b680f145dd1f7118ab2777e30911367bfe472`
- test candidate: v4.7.26 Single-Worker Transit Intent Capability Probe
- candidate SHA-256: `43e0fc93fcd7810d8460d11e683ad05adef50ada545c8190a3394f015b260ec0`
- runtime: Farming Simulator 25 1.21.1.0
- fixture: Condor Endurance II alone on field 77, settled straight work

## Hypothesis

A suitable Physical Assembly can remain in one active GIANTS Job Episode while OuttaMyWay:

1. Holds translation;
2. captures and changes only required mutable configuration;
3. places the assembly in a compact/transit state;
4. gives GIANTS a bounded non-zero motion allowance without replacing GIANTS steering/forward-reverse/acceleration intent;
5. observes useful native continuation evidence;
6. re-Holds;
7. restores OuttaMyWay-owned configuration mutations;
8. returns the unmodified GIANTS drive path;
9. observes independent native continuation.

The proving values `1 km/h` and `2 m` are experimental parameters only.

## Observed result

**PASS.**

- Probe start: `job=giants-ai-job-id:0`, `localIntent=SETTLED_CONTINUATION`.
- Hold reduced actual speed to effectively zero without ending the Job Episode.
- Full compact was confirmed after approximately 15.48 s.
- GIANTS creep began with only maximum speed bounded to 1 km/h; the same job identity remained authoritative.
- Observed creep speed was approximately 1.01–1.06 km/h.
- Native active-segment progress advanced continuously while compact and `SETTLED_CONTINUATION` remained observable.
- Intent evidence was declared at the experimental 2.00 m proving movement; re-Hold settled at approximately 2.04 m actual travel.
- Restoration unfolded the Condor while Held, restored the work boolean and verified `checked=1 mismatches=0`.
- Full GIANTS drive call was restored for the same Job Episode.
- First handoff sample showed native acceleration to 5.25 km/h with the same job identity and deployed configuration.
- Final probe result: `success=true reason=same-job-native-continuation-observed`; final observed speed 10.27 km/h.

## Additional tuple evidence

The probe preserved raw `getActiveSegmentData()` return positions including nils. During settled continuation it observed:

```text
r1 = false      -- turn state
r2 = nil
r3 = progress
r4 = segment length
r5 = progress-like value
r6 = segment length-like value
r7 = nil
r8 = nil
```

This confirms the v4.7.25 tuple collector had compacted nil slots and mislabelled later values. No authoritative segment-table index was demonstrated.

## Discovery

**Bounded Native Intent Revelation** — actual GIANTS continuation can be revealed under a retained Commitment by granting bounded native motion authority instead of reconstructing the GIANTS route, provided the evidence-acquisition composition itself is admissible.

## Architectural boundaries

- The probe proves the complete chain for the tested Condor configuration only.
- It does not prove all assemblies possess a safe transit configuration or can progress usefully while retaining it.
- A low speed does not make rotational/articulated/configuration geometry safe by itself.
- Revealed Local Intent is new Knowledge for reassessment; it is not the Safe Release Point.
- Coverage Closure and manoeuvre-sweep representation remain separate unresolved prerequisites.
- Static-obstacle recovery is a possible future application only; GIANTS obstacle avoidance is not inferred.

## Next use

Use this architecture first to reason about the two-worker Hold-release problem: after the continuing worker completes its unknown manoeuvre and settles, determine whether the held worker can undergo an admissible Bounded Native Intent Revelation interval, then reassess the resulting joint Operational Picture. Do not embed the v4.7.26 proving literals into production policy.
