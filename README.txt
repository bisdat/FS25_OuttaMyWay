FS25_OuttaMyWay v4.6.33

Cooperative collision-avoidance research for native GIANTS AI field workers.

Current canonical authority: owner-declared v4.6.32, SHA-256 37cfd18d959cdbec43818265c7bcda789b2f3c7ce6df16210daec469b80206c7
Current package authority: candidate implementing fixture-bounded Automatic Encounter Admission; runtime validation and repository-owner Canonicalisation remain pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless a test record states otherwise

v4.6.32 runtime validation passed. Physical and policy clearance evidence remained distinct while the established Condor/Patriot actuator completed passage, rejoin and GIANTS handback unchanged:

- physical contact threshold: 25.37 m;
- physical clearance reserve: +2.01 m at 27.38 m live reference separation;
- policy margin budget: 3.75 m;
- policy required separation: 29.12 m;
- policy reserve: -1.74 m;
- every derived clearance field: authority=false.

v4.6.33 introduces Prototype 18 — Fixture-Bounded Automatic Encounter Admission. No manual OuttaMyWay arming command is required or registered.

Protected fixture behaviour:

- Condor remains fixed Yield;
- Patriot remains fixed, unmodified GIANTS Progress;
- the validated physical-right fixture side remains fixed;
- movement remains fixed at 28 m lateral and 12 m rearward;
- Shadow Clearance remains Knowledge only and cannot trigger or alter Control.

Automatic admission requires exactly two active workers forming the exact Condor/Patriot fixture. Both must remain straight, working, moving and unblocked with opposed headings and a closing conflict-relevant projection for three seconds. One commitment is permitted per continuous worker episode.

Normal validation procedure:

1. Start Condor and Patriot in the established same-pass head-on fixture.
2. Enter no OuttaMyWay arming command.
3. Observe `PROTOTYPE18 ADMISSION_CANDIDATE` followed by one `PROTOTYPE18 COMMITMENT_POINT`.
4. Confirm the existing passage, rejoin and 20-second handback observation.
5. Confirm no second activation during later known Split-Start Pass Recovery.

Diagnostic and emergency commands remain:

- `otmTS015Status`
- `otmTS015Cancel`

`otmTS015Arm` is disabled and is not registered.

Deferred Publication Readiness Review — Mod Description Drift: `modDesc.xml` still summarises the active prototype. Before publication, it should return to a stable description of the mod while release-specific detail remains in the changelog and engineering documents.
