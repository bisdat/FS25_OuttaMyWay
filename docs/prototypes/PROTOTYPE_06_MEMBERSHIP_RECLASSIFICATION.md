# Prototype 06 — Membership Transition Reclassification

## Status

Canonical v4.6.7. Hypothesis strongly supported by TS002 and TS003.

## Observation

Prototype 05 retained vehicles independently of active GIANTS AI membership, but two
implementation defects remained:

1. `OPERATIONAL_MEMBERSHIP_CHANGED` repeated every update for an unchanged false
   membership state.
2. An existing relevance relationship did not explicitly reclassify when a live
   worker completed and changed from `OPERATION_MEMBER` to
   `NON_OPERATION_VEHICLE`.

The first defect was caused by treating Lua `false` through an `and/or` expression,
which collapsed the previous value to `nil`. The second occurred because relevance
state tracked only the Boolean relevant/not-relevant result and not the participants'
classification roles.

## Hypothesis

> Situation Assessment can latch Operational Membership transitions to one real
> previous-to-current change and reclassify every retained relevance relationship
> when a participant changes operational role, without losing Field World identity or
> inventing repeated events.

## Evidence contract

### Membership transition

A live completion must produce exactly one event resembling:

```text
PROTOTYPE06 MEMBERSHIP_TRANSITION
entity=Condor
previousClass=OPERATION_MEMBER
class=NON_OPERATION_VEHICLE
previousOperationalMember=true
operationalMember=false
latched=true
```

No identical transition may repeat on later samples unless the Entity genuinely
changes role again.

### Relationship reclassification

If Patriot remains active while Condor completes, the existing relationship must be
retained by identity and explicitly reclassified:

```text
PROTOTYPE06 RELATIONSHIP_RECLASSIFIED
operationMember=Patriot
worldMember=Condor
previousWorldClass=OPERATION_MEMBER
worldClass=NON_OPERATION_VEHICLE
identityPreserved=true
```

The event must occur even when the relation remains `RELEVANT` or remains
`NOT_RELEVANT`; role change is architectural evidence independent of geometric
relevance change.

### Relationship retirement

A directional relationship whose source is no longer operational may be retired, but
that removal must be explicit and must not remove the retained Field World Member.

## Implementation

Prototype 06 extends the passive Field World probe by:

- preserving Boolean `false` when reading previous Operational Membership;
- assigning a monotonically increasing classification revision to each retained
  Field World vehicle member;
- including source and target classifications in the relationship signature;
- emitting `RELATIONSHIP_RECLASSIFIED` when that signature changes;
- emitting one explicit relationship-removal event when an old directional source is
  no longer an Operation member.

Prototype 05 relevance calculations and conservative geometry remain unchanged.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- `PROTOTYPE_06_ENABLED = true`;
- no speed, steering, implement, route, AI-job, Decision, Commitment, hold, release
  or containment action is permitted.

## Validation fixtures

### TS002 regression

TS002 begins with Condor already non-operational and Patriot active. It should confirm:

- Condor produces one `ATTACHED` Field World event, not repeated membership changes;
- the relation still moves dynamically between `NOT_RELEVANT` and `RELEVANT`;
- Patriot still becomes blocked at the occupied finishing area.

TS002 cannot validate a live completion transition because Condor is already complete
when the save loads.

### TS003 live completion transition

TS003 was created as a repeatable fixture in which:

- Condor and Patriot begin as active Operation members;
- Condor completes while Patriot remains active;
- no player repositioning is required before the transition.

Reloading partially completed GIANTS jobs often causes initial repositioning, so the
fixture required substantial setup. The eventual completion transition is repeatable.

## Success criteria

Prototype 06 is supported when:

1. a live worker completion emits exactly one membership transition;
2. the completed vehicle remains the same Field World Member;
3. the active worker's existing relation is explicitly reclassified;
4. TS002 relevance behaviour remains unchanged;
5. no vehicle-control behaviour or Lua runtime error occurs.

## What would disprove or weaken the hypothesis

- membership events continue repeating without real state changes;
- the completed vehicle is removed and reattached as a different identity;
- the active relation disappears without reclassification;
- reclassification occurs only when geometric relevance also changes;
- the fix alters Prototype 05 relevance behaviour or GIANTS AI control.

## Deferred boundaries

Prototype 06 does not address exact Operational Collision Envelope geometry, projected
sweep, active Field Containment, complete static-object identity or active
Information-Gaining Delay.

## Accepted validation evidence

### TS002 negative control

TS002 began with Condor already non-operational and Patriot active.

- Condor attached once as `NON_OPERATION_VEHICLE`.
- `PROTOTYPE06 MEMBERSHIP_TRANSITION`: zero events.
- `PROTOTYPE06 RELATIONSHIP_RECLASSIFIED`: zero events.
- `PROTOTYPE06 RELATIONSHIP_REMOVED`: zero events.
- Patriot-to-Condor relevance still changed dynamically and became relevant during
  the terminal approach before the observed finishing-area collision.
- No OuttaMyWay runtime error or control action occurred.

These zero counts are correct because no participant role changed during TS002.

### TS003 positive case

TS003 was created as a repeatable live Operational Completion fixture. Setup was
substantial because reloading partially completed GIANTS jobs often causes initial
repositioning, but the eventual completion transition is repeatable.

At approximately `t=225.5s`:

- Condor completed while Patriot remained active;
- exactly one `PROTOTYPE06 MEMBERSHIP_TRANSITION` changed Condor from
  `OPERATION_MEMBER` to `NON_OPERATION_VEHICLE`;
- exactly one `PROTOTYPE06 RELATIONSHIP_RECLASSIFIED` retained the active
  Patriot-to-Condor relationship with `identityPreserved=true`;
- one `PROTOTYPE06 RELATIONSHIP_REMOVED` retired only the obsolete direction whose
  source Condor was no longer operational;
- Condor retained the same Field World identity and advanced to classification
  revision 2;
- no identical membership event repeated;
- no OuttaMyWay Lua runtime error or vehicle-control action occurred.

Several transient relevance episodes and GIANTS blocked warnings cleared without
collision deadlock. A blocked state is therefore an operational symptom requiring
interpretation, not by itself proof of deadlock.

## Result

**Strongly supported.**

Situation Assessment can latch a real Operational Membership transition once,
preserve the Entity as the same Field World Member and reclassify existing relevance
relationships independently of geometric relevance change.

## Retained boundaries

Prototype 06 does not address exact Operational Collision Envelope geometry,
projected sweep, active Field Containment, complete static-object identity, Conflict
Realisation or active Information-Gaining Delay.

