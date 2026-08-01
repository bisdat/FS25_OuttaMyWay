# Project Status

Version: 4.6.36
Canonical implementation authority: owner-declared v4.6.35, SHA-256 `d178145a5953fe5d46b86b04502e635e5ad221dded6b34e6433338862b5d9c04`, Git commit `ca983514ba18b104a185fc13534992a10ff8ae62`
Authority state: Candidate — clearance-first refuge-selection correction; runtime behaviour unchanged; repository-owner Canonicalisation pending
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

The v4.6.35 outboard-only restriction is superseded by **Preferred Refuge Is Not Required Refuge**.

Two geometry examples establish the boundary:

- equal-width workers on a coincident centre line may have two equivalent clear lateral refuges;
- offset workers with unequal widths may have one lower-cost refuge, while the opposite, longer route remains valid when the preferred route is unavailable and the longer path is clear.

The governing rule is:

> **Refuge selection is clearance-first and cost-second. Both lateral sides may be candidates. The preferred refuge is the least disruptive reachable refuge, but the opposite side remains valid when it is the only clear option.**

For each proposed Yield Entity, Situation Assessment may therefore produce two world-space lateral Refuge Candidates. Human left/right labels and vehicle-local axes do not own their meaning. Candidate validity depends on evidenced path and refuge clearance, including protection of the Progress Entity's required Future Space. Preference is considered only among candidates that survive those constraints.

## Supported conclusion

Fixture-Bounded Automatic Encounter Admission can replace the manual command for the exact Condor/Patriot fixture while preserving the established actuator. Both lateral refuge sides may remain under consideration until evidence invalidates or leaves one unresolved.

Not supported:

- general Encounter identity;
- recurring commitments in one Operation;
- autonomous Yield/Progress selection;
- world-space derivation or feasibility of either lateral Refuge Candidate;
- geometry-derived movement authority;
- field/margin refuge feasibility, obstacles or complete swept-envelope protection;
- more than two active workers.

## Exact continuation point

Define the observer-only Commitment Candidate evidence contract before code is written. For each proposed Yield Entity, define both world-space lateral refuge candidates and record:

- transition-path clearance;
- refuge-pose clearance;
- field/margin and obstacle evidence;
- complete-assembly representation and swept-space limits;
- Progress Future Space preservation;
- required lateral and rearward movement;
- hard invalidation, missing evidence and later cost comparison as separate outcomes.

The first Prototype 19 implementation, once agreed, should calculate and log all applicable role/refuge candidates without selecting or acting. It must not alter the validated automatic-admission actuator, and all outputs remain `authority=false`.

## Runtime-change statement

v4.6.36 changes runtime files only for version metadata. Admission thresholds, latch behaviour, roles, fixed physical-right fixture movement, clearance authority and actuator behaviour are unchanged from canonical v4.6.35.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently acts as a prototype/release summary. Before publication readiness, restore it to a stable description of the mod and keep increment-specific reporting in the changelog and engineering documents.
