# Engineering Handover

## Authority

Canonical implementation authority is owner-declared v4.6.33:

- ZIP SHA-256: `87b24a0865929cdeffa44b7c035a90586ba537f6823e0959cacea1e3e85e74b2`
- Git commit: `e3ca9d1bce58edaf4d245c609d03409d26fe1a22`
- canonical generator: 132 files, clean Git status, all release bytes matched Git HEAD directly.

v4.6.34 is an evidence-consolidation candidate. Runtime behaviour is unchanged; runtime files differ only in version metadata.

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

## Architectural conclusion

Fixture-Bounded Automatic Encounter Admission is supported for the exact Condor/Patriot fixture. The result removes manual admission from the normal test path but does not generalise Decision authority.

Do not infer from this result:

- production Encounter identity;
- permission for repeated commitments;
- automatic Yield/Progress selection;
- automatic side selection;
- geometry-derived movement;
- complete field, obstacle or swept-envelope feasibility;
- multi-worker arbitration.

## Exact continuation point

Discuss and define an observer-only **Shadow Candidate Comparison** before implementation.

The intended first comparison space is four alternatives formed by two possible Yield Entities and two world-space refuge directions. The labels are provisional; candidate directions must ultimately be represented as world-space refuge regions rather than human left/right strings.

The discussion must separate:

- facts available from Situation Assessment;
- candidate commitment construction;
- candidate invalidation;
- comparison evidence;
- selection authority;
- Control execution.

Only after the candidate evidence contract is agreed should a new prototype be implemented. Its first version must log all alternatives and exclusions without selecting one and without modifying the validated automatic-admission actuator.

## Protected invariants for the next implementation

- canonical v4.6.33 behaviour remains the reference actuator;
- no console arming dependency returns;
- the existing automatic gate remains fixture-bounded;
- the current one-shot latch remains unchanged;
- no candidate may alter role, side, movement or Progress control;
- all candidate and clearance calculations remain `authority=false`;
- field/margin, obstacle and complete-assembly uncertainty must remain explicit rather than silently approximated.

## Deferred Publication Readiness Review

**Mod Description Drift:** `modDesc.xml` currently summarises the active prototype/release. Before publication, return it to a stable mod description and keep release summaries in the changelog and engineering documents.
