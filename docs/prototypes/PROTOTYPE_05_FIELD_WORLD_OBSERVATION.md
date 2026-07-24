# Prototype 05 — Field World Observation

## Status

Release candidate v4.6.6. Passive in-game validation pending.

## Recovered architectural premise

The field boundary polygon defines the bounded physical world for one field Operation.

The complete operational collision envelope of every AI worker — vehicle plus every attached or towed implement, including configuration-dependent maximum extent and projected swept geometry — must remain wholly inside that polygon at all times.

Objects immediately outside the polygon are therefore outside the Operation's obstacle scope. A hedge, tree, ditch or pylon beyond the boundary should not need to be removed or avoided because the worker envelope must never reach it. The hedges removed from TS001 were a test workaround for missing containment behaviour, not an acceptable product requirement.

Prototype 05 records this invariant as architecture. It does not yet enforce it.

## Classification model

Prototype 05 separates three questions:

1. **Field World Membership** — does the physical geometry intersect the bounded field world?
2. **Operational Membership** — is the Entity currently participating in the Operation as an active GIANTS AI worker?
3. **Situation Relevance** — can that Field World Member affect an Operation member or a plausible near future?

A parked or completed vehicle may therefore be:

- a Field World Member;
- not an Operation member;
- still Situation-relevant.

The same model later extends to moving player-controlled vehicles and internal static objects.

## Hypothesis

> Situation Assessment can retain vehicle Field World Members independently of active GIANTS AI membership and identify when inactive, completed or player-controlled vehicles become relevant to an active Operation member's plausible trajectory.

The prototype additionally records GIANTS field-island and native static-collision evidence, but does not claim complete static-object identity.

## Evidence contract

Prototype 05 must record:

- each discovered Field World boundary and reported island count;
- every mission vehicle whose conservative occupied envelope intersects that boundary;
- whether each vehicle is an active Operation member, player-controlled or another non-operational vehicle;
- Operational Membership transitions without losing Field World Membership;
- dynamic relevance transitions using current separation, closing rate and closest-approach evidence;
- parked Patriot after its AI job ends;
- completed Condor after its AI job ends;
- a relevance transition when Condor's repositioning path approaches parked Patriot;
- a relevance transition when Patriot approaches completed Condor at the shared finishing position.

## Geometry boundary

The current probe uses conservative oriented rectangles derived from live vehicle and attached-implement dimensions and AI-marker width. This is a diagnostic approximation only.

It does **not** yet prove exact maximum collision geometry, projected turn sweep or containment compliance. Any `CONTAINMENT_BREACH_CANDIDATE` entry is evidence for later geometry work, not a control decision.

## Static-object boundary

Prototype 05 records:

- GIANTS FieldCourse island count for the discovered field polygon;
- native static-collision signals reported by active workers.

It does not yet identify every tree, pylon, rock or map-built object inside the polygon. Complete static-world observation remains a later evidence step after the vehicle cases establish the membership boundary.

## Passive guarantee

- `AI_EXPLORER_ONLY = true`;
- `TRAFFIC_V2_ENABLED = false`;
- Prototype 05 runs before the observer-only return;
- no speed, steering, implement, route, AI-job, hold, release, Decision, Commitment or Control action is permitted.

## Searchable log prefix

All evidence begins with:

```text
PROTOTYPE05
```

Important entries include:

- `FIELD_WORLD_DISCOVERED`
- `FIELD_WORLD_MEMBER`
- `FIELD_WORLD_MEMBER_REMOVED`
- `SITUATION_RELEVANCE`
- `CONTAINMENT_BREACH_CANDIDATE`
- `STATIC_COLLISION_SIGNAL`
- `HEARTBEAT`

## TS001 test procedure

1. Run the unchanged TS001 save with Condor and Patriot.
2. At the previously identified candidate wait point, manually stop Patriot. This may abandon its AI job; the prototype must nevertheless retain Patriot as a Field World Member.
3. Leave Patriot stationary while Condor continues until Condor's next repositioning path approaches the parked vehicle.
4. Avoid an actual collision if desired by moving Patriot only after the encounter has become visually clear or Condor becomes blocked.
5. Restart Patriot after Condor clears.
6. Allow Condor to complete and remain parked at the normal GIANTS finishing position.
7. Allow Patriot to approach that same position until the terminal occupancy conflict becomes apparent or Patriot becomes blocked.
8. Exit normally and upload the complete game log with the observed stop, move, restart and terminal outcome.

## Validation questions

- Does Patriot remain logged as a Field World Member after `operationalMember` becomes false?
- Does the probe identify Patriot as Situation-relevant when Condor approaches it?
- Does completed Condor remain logged after leaving Operational Membership?
- Does Condor become Situation-relevant to Patriot at the shared finishing position?
- Does moving Patriot classify it as player-controlled without losing Field World Membership?
- Does the observed field boundary report internal islands or native static-collision evidence?
- Are external hedges absent from obstacle evidence, as required by the containment architecture?

## What would disprove the hypothesis

- a stopped or completed vehicle disappears from Field World observation with the AI job;
- the probe cannot distinguish Field World Membership from Operational Membership;
- obvious parked-vehicle encounters remain `NOT_RELEVANT` throughout approach;
- player control removes the vehicle from observation;
- the field boundary cannot be discovered reliably enough to define the bounded world.

## Deferred after this prototype

- exact full-envelope geometry and projected sweep;
- active boundary containment;
- complete identity of internal static objects;
- safe hold/release Control;
- Information-Gaining Delay.
