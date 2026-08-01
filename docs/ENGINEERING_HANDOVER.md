# Engineering Handover

## Authority

Canonical implementation authority is owner-declared v4.6.35:

- ZIP SHA-256: `d178145a5953fe5d46b86b04502e635e5ad221dded6b34e6433338862b5d9c04`
- Git commit: `ca983514ba18b104a185fc13534992a10ff8ae62`
- canonical generator: 132 files, clean Git status, all release bytes matched Git HEAD directly.

v4.6.36 is a documentation-correction candidate. Runtime behaviour is unchanged; runtime files differ only in version metadata.

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

Canonical v4.6.35 restricted each proposed Yield Entity to one Outboard Refuge Region. Equal-width coincident-centreline and unequal-width offset-centreline examples show that restriction is too strong.

The corrected rule is:

> **Refuge selection is clearance-first and cost-second. Both lateral sides may be candidates. The preferred refuge is the least disruptive reachable refuge, but the opposite side remains valid when it is the only clear option.**

This names **Preferred Refuge Is Not Required Refuge**. A shorter or same-side refuge may be preferred, but it is not mandatory. A longer opposite-side route is legitimate when its transition path and refuge are clear and the Progress Entity's required Future Space remains protected.

For each proposed Yield Entity, the comparison space may contain two world-space lateral Refuge Candidates. With two possible Yield-role assignments, Prototype 19 may therefore observe up to four role/refuge candidates. Human left/right labels remain diagnostics only. Approach-Side Provenance is not required as a selection authority; relative assembly geometry and environmental feasibility assess both sides.

## Exact continuation point

Define the observer-only **Commitment Candidate evidence contract** before implementation.

The discussion must establish:

- how Situation Assessment constructs both world-space lateral Refuge Candidates for each proposed Yield Entity;
- what minimum proposition turns a role/refuge alternative into a Commitment Candidate;
- how transition path and refuge pose are independently assessed;
- how candidate evidence records field/margin containment, obstacles, complete-assembly representation, physical clearance, policy clearance, transition sweep, Progress preservation and rejoin feasibility;
- how `FAIL`, `UNKNOWN` and positive evidence aggregate without becoming preference or Control authority;
- how operational cost compares only candidates that remain viable.

Only after that contract is agreed should Prototype 19 be implemented. Its first form must log all applicable role/refuge candidates and exclusions without selecting one and without modifying the validated automatic-admission actuator.

## Protected invariants for the next implementation

- canonical v4.6.33 behaviour remains the reference actuator;
- no console arming dependency returns;
- the existing automatic gate remains fixture-bounded;
- the current one-shot latch remains unchanged;
- both world-space lateral sides may be candidates for each proposed Yield Entity;
- no human left/right label or arbitrary normal sign grants direction authority;
- the selected path and refuge must preserve Progress Future Space;
- candidate validity and later cost preference remain separate;
- no candidate may alter role, refuge, movement or Progress control;
- all candidate and clearance calculations remain `authority=false`;
- field/margin, obstacle and complete-assembly uncertainty must remain explicit rather than silently approximated.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently summarises the active prototype/release. Before publication, return it to a stable mod description and keep release summaries in the changelog and engineering documents.
