# Engineering Handover

## Canonical baseline

The exact reviewed v4.6.3 candidate was tested, accepted and explicitly declared canonical by the repository owner.

Accepted candidate SHA-256:

`7f2563ac7b9af43d471a77cd06ae3c532b0e1c826b94e324a761be1d34d18856`

Every new Engineering Transformation must begin from the complete canonical v4.6.3 package supplied as its immutable baseline.

## Completed increment

Prototype 02 tested:

> Situation Assessment can distinguish a transient projected intersection from an established future conflict by observing Trajectory Settlement and prediction persistence.

The unchanged TS001 run strongly supported the hypothesis.

## Accepted evidence

- The earlier harmless head-on pass remained `CLEAR`.
- The later encounter entered `FORMING` while the projected conflict and Patriot's trajectory were still unstable.
- The relationship entered `ESTABLISHED` at approximately `t=107.5s`, 266.5 m separation and about 18.5 s before both workers became blocked.
- Neither worker made a further material direction change after settlement.
- The player visually confirmed the final outcome remained a head-on collision.
- GIANTS marked Condor blocked at approximately `t=125.7s` and Patriot blocked at `t=126.0s`.

The evidence supports distinct responsibilities for per-Entity Trajectory Settlement and relationship-level Conflict Confidence, while both remain Deferred.

## Disproved lifecycle assumption

After collision-induced stopping, the future projection disappeared and Prototype 02 reported `ESTABLISHED → DECAYING → CLEARED` even though both workers remained physically blocked.

This is the **Projection Clearance Fallacy**: absence of a future collision projection does not prove that an already realised conflict is resolved.

A later increment must examine the boundary by which future conflict becomes present unresolved Reality. No new concept is accepted by canonical v4.6.3 merely because it has been named in evidence review.

## Implementation state

- `ConflictEmergenceProbe.lua` retains Prototype 01 evidence and side-effect-free kinematic helpers.
- `ConflictConfidenceProbe.lua` records per-Entity motion stability and pair-level prediction persistence.
- Both probes are passive and execute before the observer-only runtime return.
- Traffic Manager v2 remains disabled.
- No Decision, Commitment or Control behaviour is enabled.

## Immediate continuation point

Before any active waiting, yielding or avoidance test:

1. begin from the exact canonical v4.6.3 package;
2. consolidate the Prototype 02 evidence into one next architectural hypothesis;
3. distinguish safely dissolving future conflict from realised unresolved conflict;
4. define the evidence contract before implementation;
5. preserve Progress, Decision, Commitment and Control as separate responsibilities.

Do not tune Prototype 02 merely to prevent its post-collision state labels from looking wrong. First determine which missing architectural knowledge caused the interpretation failure.

## Repository entry point

1. `docs/README.md`
2. `docs/PROJECT_STATUS.md`
3. `docs/prototypes/PROTOTYPE_02_CONFLICT_CONFIDENCE.md`
4. `docs/prototypes/PROTOTYPE_01_CONFLICT_EMERGENCE.md`
5. `docs/CONCEPT_REGISTER.md`
6. `docs/DECISION_LOG.md`
7. `docs/ENGINEERING_JOURNAL.md`

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat
