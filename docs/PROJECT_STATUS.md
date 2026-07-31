# Project Status

Version: 4.6.34
Canonical implementation authority: owner-declared v4.6.33, SHA-256 `87b24a0865929cdeffa44b7c035a90586ba537f6823e0959cacea1e3e85e74b2`, Git commit `e3ca9d1bce58edaf4d245c609d03409d26fe1a22`
Authority state: Candidate — successful Automatic Encounter Admission evidence consolidated; runtime behaviour unchanged; repository-owner Canonicalisation pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless the test record states otherwise

## Validated TS018 result

Prototype 18's fixture-bounded hypothesis is supported.

No OuttaMyWay console command was entered or required. The exact Condor/Patriot pair produced:

```text
ADMISSION_CANDIDATE  distance=316.78 m  tCPA=29.94 s  dCPA=2.06 m
COMMITMENT_POINT     candidateFor=3.09 s  distance=277.92 m  tCPA=20.04 s  dCPA=0.03 m
RUN_START            trigger=automatic-encounter-admission
```

The protected actuator then completed unchanged:

```text
reason=handoff-observation-complete
failure=nil
fenceViolation=false
passageConfirmed=true
minPairSeparation=27.40 m
```

Condor remained fixed Yield, Patriot remained `GIANTS_UNMODIFIED`, the physical-right fixture side remained fixed, and movement remained 28 m lateral / 12 m rearward.

## Episode-latch evidence

Exactly one Admission Candidate, one Commitment Point and one actuator run occurred. After handback, the known Split-Start Pass Recovery produced later GIANTS coverage movement, but the admission state remained `LATCHED` and no second intervention began.

This validates the bounded one-shot guard. It does not define production Encounter identity or prove how recurring conflicts should be admitted.

## Clearance evidence remained observer-only

Closest-approach Shadow Clearance output remained explicitly separate:

```text
physicalContactThreshold = 25.37 m
liveReferenceSeparation   = 27.40 m
physicalClearanceReserve  = +2.03 m
policyMarginBudget        = 3.75 m
policyRequiredSeparation  = 29.12 m
policyReserve             = -1.72 m
authority                 = false
```

The positive physical reserve and negative policy reserve remained simultaneous, non-contradictory Knowledge. Neither value changed the automatic admission or actuator.

## Supported conclusion

**Fixture-Bounded Automatic Encounter Admission** can replace the manual `otmTS015Arm right` dependency for the exact Condor/Patriot same-pass fixture while preserving the established Unilateral Sidestep behaviour.

Supported scope:

- exact exclusive Condor/Patriot active pair;
- sustained straight-working head-on projection;
- one commitment per continuous fixture episode;
- fixed Condor Yield, Patriot GIANTS Progress, physical-right side and 28 m / 12 m movement.

Not supported:

- general Encounter identity;
- recurring commitments in one Operation;
- autonomous Yield/Progress selection;
- autonomous escape-side selection;
- geometry-derived movement authority;
- field/margin refuge feasibility, obstacles or complete swept-envelope protection;
- more than two active workers.

## Exact continuation point

Define **Shadow Candidate Comparison** as an observer-only Decision experiment before implementation.

The first bounded candidate set should compare, without selecting or acting:

```text
Condor yields toward candidate refuge A
Condor yields toward candidate refuge B
Patriot yields toward candidate refuge A
Patriot yields toward candidate refuge B
```

Before code is written, agree:

1. what constitutes a candidate commitment rather than a mere geometric alternative;
2. which evidence each candidate must contain;
3. how world-space refuge direction replaces left/right label ambiguity;
4. how field/margin feasibility, obstacles, assembly extents and progress preservation are represented;
5. which candidate-invalidity rules can be established without granting selection authority;
6. how comparison remains Knowledge only and cannot alter the validated fixture actuator.

The next implementation, once agreed, should calculate and log candidate evidence only. It must not choose a Yield Entity, side or movement and must not change Control.

## Runtime-change statement

v4.6.34 changes runtime files only for version metadata. Admission thresholds, latch behaviour, roles, side, movement, clearance authority and actuator behaviour are unchanged from canonical v4.6.33.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently acts as a prototype/release summary. Before publication readiness, restore it to a stable description of the mod and keep increment-specific reporting in the changelog and engineering documents.
