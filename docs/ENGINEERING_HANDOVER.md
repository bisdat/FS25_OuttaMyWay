# Engineering Handover

## Authority

Canonical implementation authority is owner-declared v4.6.34:

- ZIP SHA-256: `808eb15a388586feabe69a49ec81756300e042af133b070fbc4752c40016dacc`
- Git commit: `2ef9da18dc06df263e5705fa3d28b43c241fa0b8`
- canonical generator: 132 files, clean Git status, all release bytes matched Git HEAD directly.

v4.6.35 is a documentation-correction candidate. Runtime behaviour is unchanged; runtime files differ only in version metadata.

## Accepted runtime result

TS018 ran without any OuttaMyWay console command.

```text
ADMISSION_CANDIDATE  at 316.78 m
COMMITMENT_POINT     after 3.09 s at 277.92 m
RUN_START            trigger=automatic-encounter-admission
RUN_END              failure=nil, passageConfirmed=true, minPairSeparation=27.40 m
```

The complete fixed actuator sequence succeeded through passage, rejoin and the 20-second GIANTS handback observation. Condor remained fixed Yield; Patriot remained `GIANTS_UNMODIFIED`; the physical-right side and 28 m lateral / 12 m rearward movement remained unchanged.

Exactly one admission and one commitment occurred. The Encounter Episode Latch remained `LATCHED` through the later known Split-Start Pass Recovery and prevented a second activation.

Shadow Clearance remained observer-only. Closest physical reserve was +2.03 m and closest policy reserve was -1.72 m; all records remained `authority=false`.

## Architectural correction

Canonical v4.6.34 contained **Outboard Refuge Drift** in its continuation wording: it described four alternatives formed from two possible Yield Entities and two refuge directions. Earlier accepted architecture had already selected outward-only refuge for Retreating Unilateral Sidestep.

The corrected comparison space is:

```text
Condor yields  → Condor Outboard Refuge Region
Patriot yields → Patriot Outboard Refuge Region
```

Each proposed Yield Entity has one applicable outboard refuge family. An inboard or cross-lane refuge is not a peer alternative and must not be substituted when outboard refuge evidence is unavailable.

## Exact continuation point

Define the observer-only **Commitment Candidate evidence contract** for the two Yield-role candidates before implementation.

The discussion must establish:

- how Situation Assessment derives each Outboard Refuge Region in world space;
- what minimum proposition turns a Yield-role alternative into a Commitment Candidate;
- how candidate evidence records field/margin containment, obstacles, complete-assembly representation, physical clearance, policy clearance, transition sweep, Progress preservation and rejoin feasibility;
- how `FAIL`, `UNKNOWN` and positive evidence aggregate without becoming preference or Control authority;
- how an unavailable outboard refuge leaves a candidate `INVALIDATED` or `UNRESOLVED` rather than creating a cross-lane fallback.

Only after that contract is agreed should Prototype 19 be implemented. Its first form must log both Yield-role candidates and exclusions without selecting one and without modifying the validated automatic-admission actuator.

## Protected invariants for the next implementation

- canonical v4.6.33 behaviour remains the reference actuator;
- no console arming dependency returns;
- the existing automatic gate remains fixture-bounded;
- the current one-shot latch remains unchanged;
- each proposed Yield Entity contributes only its Outboard Refuge Region;
- no inboard or cross-lane fallback is introduced;
- no candidate may alter role, refuge, movement or Progress control;
- all candidate and clearance calculations remain `authority=false`;
- field/margin, obstacle and complete-assembly uncertainty must remain explicit rather than silently approximated.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently summarises the active prototype/release. Before publication, return it to a stable mod description and keep release summaries in the changelog and engineering documents.
