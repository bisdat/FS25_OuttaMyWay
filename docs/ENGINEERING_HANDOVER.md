# Engineering Handover

## Canonical baseline

The exact reviewed v4.6.5 candidate was tested, accepted and explicitly declared canonical by the repository owner.

Canonical package SHA-256:

`3c7cfa56fe0bd74dc3d3aabbcaddf52c1d49e10637b248ce75a7193e264d9431`

Prototype 05 candidate v4.6.6 was produced from that immutable baseline.

## Current candidate

Prototype 05 restores the missing architectural boundary and tests physical observation beyond active AI membership.

The field polygon defines one bounded **Field World**. **Full-Envelope Field Containment** requires the complete vehicle–implement collision envelope, including projected swept geometry, to remain wholly inside that polygon. External objects should therefore never become obstacles merely because an implement sweeps beyond the boundary.

The candidate separates:

- Field World Membership;
- Operational Membership;
- Situation Relevance.

## Implementation

The passive `FieldWorldProbe` enumerates all mission vehicles, groups attached implements under their root vehicle, tests a conservative current occupied envelope against the GIANTS field polygon and retains vehicles after their active AI job ends.

It records dynamic relevance between active Operation members and all other vehicle Field World Members. It also records field-island counts and native static-collision signals, but exact static-object identity remains incomplete.

No containment, hold, release, Decision, Commitment or vehicle-control action exists in this candidate.

## Immediate validation

Repeat the limited TS001 sequence:

1. stop Patriot at the previous wait position;
2. leave it parked while Condor begins the later diagonal repositioning;
3. confirm that the log retains Patriot with `operationalMember=false`;
4. confirm that the Condor–Patriot relation becomes `RELEVANT`;
5. move Patriot before collision if desired, then restart it after Condor clears;
6. let Condor complete and remain parked;
7. let Patriot approach the shared finishing position and confirm completed Condor remains physically observed and relevant;
8. upload the complete game log and visual observations.

## Evidence boundary

Success would establish the vehicle observation boundary only. It would not validate:

- exact maximum collision geometry;
- projected envelope sweep;
- active field containment;
- complete internal static-object observation;
- safe release or Information-Gaining Delay.

## Repository entry point

1. `docs/README.md`
2. `docs/PROJECT_STATUS.md`
3. `docs/prototypes/PROTOTYPE_05_FIELD_WORLD_OBSERVATION.md`
4. `docs/ARCHITECTURE.md`
5. `docs/CONCEPT_REGISTER.md`
6. `docs/DECISION_LOG.md`
7. `docs/ENGINEERING_JOURNAL.md`
8. `docs/ROADMAP.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
