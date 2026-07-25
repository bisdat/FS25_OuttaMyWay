# Engineering Handover

## Canonical baseline

The exact reviewed v4.6.6 candidate was tested, accepted and explicitly declared canonical by the repository owner.

Accepted candidate SHA-256:

`cef9190ae6738caae66b2efb375bce1c6f94100bd8e967daaeb7260e34b14658`

Every new Engineering Transformation must begin from the complete canonical v4.6.6 package supplied as its immutable baseline.

## Completed increment

Prototype 05 recovered Full-Envelope Field Containment as authoritative architecture and tested whether Situation Assessment can observe vehicle Field World Members independently of active GIANTS AI membership.

The field polygon defines one bounded Field World. Field World Membership, Operational Membership and Situation Relevance are separate classifications. The implementation remains passive and uses conservative current-envelope geometry only as diagnostic evidence.

## Accepted evidence

TS002 is the clean regression fixture for a pre-existing completed vehicle:

- Condor was already completed and parked when the save loaded;
- at `t=6.2s`, Condor was discovered as `NON_OPERATION_VEHICLE` and Patriot as the sole `OPERATION_MEMBER`;
- both remained Field World vehicle members for the complete run;
- the relation began `NOT_RELEVANT` and became `RELEVANT` at `t=241.7s` as Patriot approached the occupied finishing area;
- Patriot became `BLOCKED` at `t=290.7s`, matching the player's observed collision;
- no OuttaMyWay runtime error or control action occurred.

Variable TS001 runs also retained stopped/player-controlled Patriot and completed Condor after their AI membership ended, but manual repositioning and release timing changed the later encounters. Those runs remain supporting evidence rather than the terminal regression fixture.

## Architectural result

- A vehicle can be a Field World Member without being an Operation member.
- A non-operational vehicle can move from not relevant to Situation-relevant as an active worker's plausible trajectory approaches it.
- Operation membership is not the Situation Assessment observation boundary.
- A completed vehicle occupying future space is the same general relevance problem as a parked or player-controlled vehicle; no terminal-specific architecture is justified.
- Full-Envelope Field Containment remains an accepted invariant, not behaviour validated by Prototype 05.

## Instrumentation findings

The next increment must correct three observed defects:

1. membership-change evidence repeats every update for an unchanged non-operational vehicle;
2. existing relationships are not reliably reclassified when a live worker changes from operational to non-operational;
3. provisional containment rectangles produce noisy breach candidates and must remain clearly separated from exact envelope evidence.

TS002 validates discovery and relevance of a vehicle that is already non-operational at load. It does not validate the live completion transition.

## Immediate continuation

The next substantive increment should remain passive and should:

1. latch Operational Membership transitions;
2. rebuild relationship classification after membership changes;
3. preserve TS002 as the pre-existing completed-vehicle regression fixture;
4. create or identify a repeatable live completion-transition fixture;
5. continue separating current occupied-envelope approximation from maximum and projected swept geometry;
6. extend Field World evidence toward identifiable internal static objects;
7. keep active Information-Gaining Delay deferred until observation is complete enough to retain every physically relevant participant.

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
