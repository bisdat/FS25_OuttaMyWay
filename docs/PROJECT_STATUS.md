# Project Status

Version: 4.6.6

Authority state: Canonical — Prototype 05 vehicle Field World observation strongly supported; exact geometry and static-world observation unresolved

Canonical source: exact accepted v4.6.6 candidate

Accepted candidate SHA-256: cef9190ae6738caae66b2efb375bce1c6f94100bd8e967daaeb7260e34b14658

Current focus: correct Field World membership-transition evidence and relationship reclassification, then extend observation toward exact internal static objects and full-envelope geometry before any active Information-Gaining Delay

## Engineering Increment Result

Prototype 05 asked:

> Can Situation Assessment retain vehicle Field World Members independently of active GIANTS AI membership and identify when inactive, completed or player-controlled vehicles become relevant to an active Operation member's plausible trajectory?

**Result:** Strongly supported for vehicle members. A clean TS002 fixture discovered completed Condor as a non-operational Field World Member at save load, kept Patriot as the sole Operation member, and promoted Condor from `NOT_RELEVANT` to `RELEVANT` as Patriot approached the occupied finishing area. Patriot later became blocked in the visually observed collision.

The canonical release remains passive. It does not hold or release either worker, select a Commitment, constrain the field boundary or alter GIANTS AI behaviour.

## Accepted Evidence

TS002 provided a repeatable pre-existing non-operational vehicle relevance fixture with no manual intervention after the run began:

- `t=6.2s`: the field polygon was discovered with 12 boundary points and no reported field islands;
- `t=6.2s`: Condor was attached as `NON_OPERATION_VEHICLE`, `operationalMember=false`;
- `t=6.2s`: Patriot was attached as the sole `OPERATION_MEMBER`;
- `t=6.2s`: Patriot-to-Condor relevance began `NOT_RELEVANT` at 462.99 m separation with a projected closest distance of 301.04 m;
- a brief relationship transition occurred during earlier manoeuvring and cleared again, demonstrating that relevance is dynamic rather than permanent;
- `t=241.7s`: Condor became `RELEVANT` as Patriot approached the shared finishing area, with 227.95 m separation and a projected closest distance of 40.22 m against the provisional 41.35 m envelope clearance;
- `t=290.7s`: Patriot became `BLOCKED`, consistent with the player's observed collision with parked Condor;
- throughout the run the heartbeat retained one active Operation member, two Field World vehicle members and one relevance relationship;
- no OuttaMyWay Lua runtime error or vehicle-control action occurred.

Variable TS001 runs additionally showed stopped or player-controlled Patriot and completed Condor remaining physically observed after Operational Membership ended. Manual movement and timing made those runs unsuitable as the clean terminal regression fixture, which is why TS002 was created.

## Interpretation

Prototype 05 supports:

- **Field World Membership** as physical vehicle presence independent of active AI participation;
- **Operational Membership** as a distinct, dynamic participation classification;
- **Situation Relevance** as a changing relationship rather than a property inherited from membership;
- TS002 as a repeatable completed-vehicle relevance fixture rather than a terminal-parking special case.

The evidence does not validate exact full-envelope collision geometry, projected swept geometry, active containment or complete internal static-object identity.

## Instrumentation Findings

Three diagnostic defects remain:

1. `OPERATIONAL_MEMBERSHIP_CHANGED` was emitted repeatedly for an unchanged non-operational Condor and must be latched to actual transitions.
2. An existing active-worker relationship was not reliably rebuilt when a live worker completed and changed classification; this Relationship Reclassification Gap remains to be corrected and validated.
3. Conservative rectangle containment candidates were noisy and must not be treated as evidence of actual Full-Envelope Field Containment compliance.

These are observation and interpretation defects. They do not weaken the clean TS002 result that a pre-existing non-operational vehicle can be retained and promoted to Situation-relevant.

## Passive Guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototypes 01 through 05 run before the observer-only return;
- no speed, steering, implement, route, AI-job, Decision, Commitment, hold, release or containment action is permitted.

## Next Evidence Boundary

The next declared Engineering Increment should:

1. latch Operational Membership events to real state changes;
2. rebuild or reclassify Situation Relevance when an existing Field World Member enters or leaves Operational Membership;
3. retain TS002 as a regression fixture for a pre-existing completed vehicle;
4. establish a repeatable live `OPERATION_MEMBER → NON_OPERATION_VEHICLE` transition fixture;
5. separate provisional current-envelope diagnostics from exact Operational Collision Envelope knowledge;
6. extend Field World observation toward identifiable internal static objects before active hold/release behaviour is reconsidered.

## Known Constraints

- Exact maximum collision geometry and projected swept geometry are not implemented.
- Current containment rectangles generate false or ambiguous breach candidates.
- Internal static-object identity remains incomplete; field islands and native collision signals are evidence only.
- TS002 begins after Condor has completed, so it does not itself validate live relationship reclassification at job completion.
- The test map still lacks the external hedges removed to work around missing containment behaviour.
- Older control code remains in the repository but is bypassed by the observer-only boundary.
