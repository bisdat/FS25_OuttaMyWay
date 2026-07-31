# Project Status

Version: 4.6.35
Canonical implementation authority: owner-declared v4.6.34, SHA-256 `808eb15a388586feabe69a49ec81756300e042af133b070fbc4752c40016dacc`, Git commit `2ef9da18dc06df263e5705fa3d28b43c241fa0b8`
Authority state: Candidate — Outboard Refuge Drift corrected; runtime behaviour unchanged; repository-owner Canonicalisation pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Validated TS018 result

Prototype 18's fixture-bounded hypothesis is supported.

No OuttaMyWay console command was entered or required. The exact Condor/Patriot pair produced:

```text
ADMISSION_CANDIDATE  distance=316.78 m  tCPA=29.94 s  dCPA=2.06 m
COMMITMENT_POINT     candidateFor=3.09 s  distance=277.92 m  tCPA=20.04 s  dCPA=0.03 m
RUN_START            trigger=automatic-encounter-admission
```

The protected actuator completed with `failure=nil`, `fenceViolation=false`, `passageConfirmed=true` and 27.40 m minimum pair separation. Condor remained fixed Yield, Patriot remained `GIANTS_UNMODIFIED`, the physical-right fixture side remained fixed, and movement remained 28 m lateral / 12 m rearward.

Exactly one Admission Candidate, one Commitment Point and one actuator run occurred. The Encounter Episode Latch remained `LATCHED` during later known Split-Start Pass Recovery and no second intervention began.

Closest Shadow Clearance remained observer-only: +2.03 m physical reserve and -1.72 m policy reserve, both `authority=false`.

## Corrected refuge architecture

**Outboard Refuge Drift** is corrected. Retreating Unilateral Sidestep does not compare two symmetric sides for each worker. The bounded comparison space is:

```text
Condor yields  → Condor Outboard Refuge Region
Patriot yields → Patriot Outboard Refuge Region
```

The Outboard Refuge Region is away from the Protected Progress Corridor and must avoid later cross-lane recovery. Human left/right labels and vehicle-local axes do not own this meaning. An inboard or cross-lane refuge is a different intervention concept, not a fallback candidate.

## Supported conclusion

Fixture-Bounded Automatic Encounter Admission can replace the manual command for the exact Condor/Patriot fixture while preserving the established actuator. Outboard-only refuge semantics are an accepted architectural constraint for future candidate comparison.

Not supported:

- general Encounter identity;
- recurring commitments in one Operation;
- autonomous Yield/Progress selection;
- world-space derivation or feasibility of either Outboard Refuge Region;
- geometry-derived movement authority;
- field/margin refuge feasibility, obstacles or complete swept-envelope protection;
- more than two active workers.

## Exact continuation point

Define the Commitment Candidate evidence contract for the two Yield-role alternatives before code is written. Agree how world-space Outboard Refuge Regions are derived, what evidence each candidate contains, how hard invalidation differs from missing evidence, and how all comparison output remains Knowledge only.

The first Prototype 19 implementation, once agreed, should calculate and log both Yield-role candidates without selecting or acting. It must not create an inboard/cross-lane candidate and must not change Control.

## Runtime-change statement

v4.6.35 changes runtime files only for version metadata. Admission thresholds, latch behaviour, roles, fixed physical-right fixture movement, clearance authority and actuator behaviour are unchanged from canonical v4.6.34.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently acts as a prototype/release summary. Before publication readiness, restore it to a stable description of the mod and keep increment-specific reporting in the changelog and engineering documents.
