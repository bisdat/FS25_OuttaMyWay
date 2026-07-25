# Prototype 05 — Field World Observation

## Status

Canonical v4.6.6. Vehicle Field World observation hypothesis strongly supported by TS001 supporting evidence and the repeatable TS002 fixture.

## Architectural premise

The field boundary polygon defines the bounded physical world for one field Operation.

The complete operational collision envelope of every AI worker — vehicle plus every attached or towed implement, including configuration-dependent maximum extent and projected swept geometry — must remain wholly inside that polygon at all times.

Objects immediately outside the polygon are therefore outside the Operation's obstacle scope. A hedge, tree, ditch or pylon beyond the boundary should not need to be removed or avoided because the worker envelope must never reach it. The hedges removed from TS001 were a test workaround for missing containment behaviour, not an acceptable product requirement.

Prototype 05 records this invariant as architecture. It does not enforce it.

## Classification model

Prototype 05 separates three questions:

1. **Field World Membership** — does the physical geometry intersect the bounded Field World?
2. **Operational Membership** — is the Entity currently participating in the Operation as an active GIANTS AI worker?
3. **Situation Relevance** — can that Field World Member affect an Operation member or a plausible near future?

A parked or completed vehicle may therefore be:

- a Field World Member;
- not an Operation member;
- still Situation-relevant.

The same model later extends to moving player-controlled vehicles and internal static objects.

## Hypothesis

> Situation Assessment can retain vehicle Field World Members independently of active GIANTS AI membership and identify when inactive, completed or player-controlled vehicles become relevant to an active Operation member's plausible trajectory.

## Result

**Strongly supported for vehicle members.**

Prototype 05 successfully retained non-operational vehicles inside the Field World and independently assessed their relevance to the active Operation member. TS002 supplied the cleanest evidence because it began with Condor already completed and parked, while Patriot continued without player intervention until collision.

## Accepted TS002 evidence

- `t=6.2s`: the field polygon was discovered with 12 boundary points and zero reported FieldCourse islands;
- `t=6.2s`: Condor attached as `NON_OPERATION_VEHICLE`, `operationalMember=false`;
- `t=6.2s`: Patriot attached as `OPERATION_MEMBER`, `operationalMember=true`;
- `t=6.2s`: the Patriot-to-Condor relation began `NOT_RELEVANT`, with 462.99 m separation and 301.04 m projected closest distance;
- `t=117.5s`: an earlier manoeuvre briefly produced `RELEVANT`, then returned to `NOT_RELEVANT` at `t=118.0s`, showing that relevance is dynamic;
- `t=241.7s`: the terminal approach produced the decisive `RELEVANT` transition, with 227.95 m separation and 40.22 m projected closest distance against the provisional 41.35 m envelope clearance;
- `t=290.7s`: Patriot became `BLOCKED`, consistent with the player's observed collision with parked Condor;
- periodic heartbeats retained one active Operation member, two Field World vehicle members and one relationship throughout;
- no OuttaMyWay Lua runtime error or vehicle-control action occurred.

## Supporting TS001 evidence

Variable TS001 runs showed that:

- manually stopped Patriot remained observed after leaving active AI membership and could be classified as player-controlled;
- Condor's approach could promote parked Patriot to Situation-relevant;
- completed Condor remained a Field World vehicle member after leaving active-worker observation;
- manual repositioning and restart timing changed the later encounters, making TS001 unsuitable as the clean terminal regression fixture.

TS001 therefore supports the broader observation boundary, while TS002 is retained as the repeatable pre-existing non-operational vehicle relevance fixture.

## Interpretation

The evidence establishes that:

```text
Field World Membership
        ≠
Operational Membership
        ≠
Situation Relevance
```

A completed vehicle does not disappear from Situation Assessment merely because its GIANTS job has ended. Its relevance changes according to its relationship with active workers and their plausible trajectories.

The terminal parking encounter is not a special architectural case. It is one instance of a non-operational Field World Member occupying space required by an active Operation member.

## Geometry boundary

The current probe uses conservative oriented rectangles derived from live vehicle and attached-implement dimensions and AI-marker width. This is a diagnostic approximation only.

It does **not** prove exact maximum collision geometry, projected turn sweep or containment compliance. The repeated `CONTAINMENT_BREACH_CANDIDATE` entries in the tested logs are noisy provisional evidence and must not be interpreted as actual boundary violations.

## Static-object boundary

Prototype 05 records:

- GIANTS FieldCourse island count for the discovered field polygon;
- native static-collision signals reported by active workers.

It does not identify every tree, pylon, rock or map-built object inside the polygon. Complete static-world observation remains a later evidence step.

## Instrumentation findings

### Membership Transition Repetition

`OPERATIONAL_MEMBERSHIP_CHANGED` was repeatedly emitted for Condor even though its state remained non-operational. The event must be latched to an actual previous-to-current state change.

### Relationship Reclassification Gap

TS002 validates a relationship created when Condor is already non-operational at load. Earlier TS001 evidence showed that an existing active-worker relationship was not reliably rebuilt when Condor completed and changed classification. A live completion-transition fixture remains necessary.

### Containment Candidate Noise

The conservative current rectangle frequently reported candidates that are not yet trustworthy. Exact Operational Collision Envelope and projected swept geometry remain separate future work.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototype 05 runs before the observer-only return;
- no speed, steering, implement, route, AI-job, hold, release, Decision, Commitment or Control action is permitted.

## Validation conclusion

The following capabilities pass:

- discover a non-operational vehicle at save load;
- retain it as a Field World Member;
- keep it outside Operational Membership;
- dynamically promote and demote Situation Relevance;
- correlate a later relevant approach with an observed blocked collision;
- retain moving player-controlled vehicle evidence in supporting TS001 runs.

The following remain unresolved:

- latched membership transition evidence;
- relationship reclassification when a live worker completes;
- exact full-envelope geometry and projected sweep;
- active boundary containment;
- complete identity of internal static objects;
- safe hold/release Control and Information-Gaining Delay.

## Next evidence step

The next passive increment should correct membership-event latching and relationship reclassification, preserve TS002 as a regression fixture, and establish a repeatable live `OPERATION_MEMBER → NON_OPERATION_VEHICLE` transition before broadening static-world observation.
