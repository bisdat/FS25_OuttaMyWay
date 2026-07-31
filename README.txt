FS25_OuttaMyWay v4.6.35

Cooperative collision-avoidance research for native GIANTS AI field workers.

Canonical implementation authority: owner-declared v4.6.34
Canonical ZIP SHA-256: 808eb15a388586feabe69a49ec81756300e042af133b070fbc4752c40016dacc
Canonical Git commit: 2ef9da18dc06df263e5705fa3d28b43c241fa0b8
Current package authority: candidate correcting Outboard Refuge Drift; runtime behaviour is unchanged and repository-owner Canonicalisation remains pending
Runtime baseline: FS25 1.21.1.0 build b40785 revision 81824 unless a test record states otherwise

TS018 validated Prototype 18 without any OuttaMyWay console command:

- one `ADMISSION_CANDIDATE` appeared at 316.78 m;
- one `COMMITMENT_POINT` followed after 3.09 s of sustained evidence at 277.92 m;
- the run began with `trigger=automatic-encounter-admission`;
- Condor remained fixed Yield;
- Patriot remained fixed, unmodified GIANTS Progress;
- the physical-right fixture side remained fixed;
- movement remained fixed at 28 m lateral and 12 m rearward;
- passage, rejoin and the complete 20-second handback observation succeeded;
- `failure=nil`, `fenceViolation=false`, `passageConfirmed=true`;
- minimum pair separation was 27.40 m;
- the Encounter Episode Latch remained `LATCHED` and prevented a second activation during the known Split-Start Pass Recovery.

Prototype 17 evidence also remained observer-only and separate:

- closest physical clearance reserve: +2.03 m;
- closest policy reserve: -1.72 m;
- every derived clearance field: `authority=false`.

Prototype 18 is supported only for the exact fixture. It does not establish production Encounter identity, recurring commitments, automatic Yield/Progress selection, world-space outboard-refuge feasibility, geometry-derived movement, field/margin refuge feasibility or obstacle clearance.

Outboard Refuge Drift is corrected: Retreating Unilateral Sidestep has one Outboard Refuge Region per proposed Yield Entity, not two symmetric side candidates. The next architectural activity is observer-only Shadow Candidate Comparison between Condor-outboard and Patriot-outboard role candidates. Neither may influence Control until its evidence and authority are separately justified.

Diagnostic and emergency commands remain:

- `otmTS015Status`
- `otmTS015Cancel`

`otmTS015Arm` remains disabled and is not registered.

Deferred Publication Readiness Review — Mod Description Drift: `modDesc.xml` still summarises the active prototype. Before publication, it should return to a stable description of the mod while release-specific detail remains in the changelog and engineering documents.
