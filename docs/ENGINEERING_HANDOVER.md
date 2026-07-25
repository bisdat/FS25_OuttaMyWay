# Engineering Handover

## Canonical baseline

Canonical v4.6.7 derives from the exact tested Prototype 06 candidate.

Accepted candidate SHA-256:

`bee9382bc8f4f6a187aacbae43b8adefdf117eeb92f14c5e123da17a9de8a9b9`

## Accepted result

Prototype 06 strongly supports the hypothesis that Situation Assessment can preserve
one Field World identity while Operational Membership changes, latch the transition
once and reclassify every existing relation whose participant role changed.

### TS002 negative control

- Condor began and remained `NON_OPERATION_VEHICLE`;
- no membership transition, relationship reclassification or relationship removal
  was emitted merely because that state persisted;
- the Patriot-to-Condor relation still became `RELEVANT` during the terminal approach;
- the observed finishing-area collision remained detectable.

### TS003 positive case

- both workers began active;
- Condor completed at approximately `t=225.5s` while Patriot remained active;
- exactly one `PROTOTYPE06 MEMBERSHIP_TRANSITION` was emitted;
- exactly one `PROTOTYPE06 RELATIONSHIP_RECLASSIFIED` was emitted with
  `identityPreserved=true`;
- the obsolete Condor-as-active-source relation was retired explicitly once;
- Condor retained the same Field World identity;
- no unchanged event repeated and no OuttaMyWay runtime or control error occurred.

Several transient relevance and GIANTS blocked episodes cleared without deadlock.
Blocked state remains evidence requiring interpretation, not a deadlock conclusion.

## Current boundary

Prototype 06 closes the vehicle Operational Membership transition defect. The next
architectural discussion should remain passive and select one evidence boundary at a
time from:

1. complete identity of static Field World Members wholly inside the field polygon;
2. exact current and maximum Operational Collision Envelope sources;
3. projected swept-envelope containment.

Active containment, hold/release, Conflict Realisation and Information-Gaining Delay
remain deferred.

## Repository entry point

1. `docs/PROJECT_STATUS.md`
2. `docs/prototypes/PROTOTYPE_06_MEMBERSHIP_RECLASSIFICATION.md`
3. `docs/prototypes/PROTOTYPE_05_FIELD_WORLD_OBSERVATION.md`
4. `docs/ARCHITECTURE.md`
5. `docs/ROADMAP.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
