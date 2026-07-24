# Engineering Handover

## Purpose

This document provides the context required to resume engineering from the repository alone. It explains the immediate continuation point rather than duplicating release history.

## Canonical Baseline

The exact reviewed v4.6.2 candidate was tested, accepted and explicitly declared canonical by the repository owner.

Accepted candidate SHA-256:

`1d4f02cd6204f13ecfa870ca4492b67ed255902aba8623f7b30eb2e4872f2945`

Every new Engineering Transformation must begin from the complete canonical v4.6.2 package supplied as its immutable baseline.

## Current Engineering Focus

Prototype 01 has reached a coherent breakpoint at the Situation Assessment–Commitment boundary.

It asked one question:

> Can Situation Assessment detect a Conflict Emergence Point before two native GIANTS AI workers reach immediate physical conflict?

The first unchanged TS001 evidence run supported that hypothesis.

## Implementation State

Canonical v4.6.2 contains `scripts/prototypes/ConflictEmergenceProbe.lua`.

The probe reads only the central Observer model. It records position, heading, speed, separation, closing rate, heading relationship, closest-approach estimates, projected conflict location, worker state and provisional stage transitions.

The stage labels remain diagnostic aids:

- `INDEPENDENT`
- `CONVERGING_OUTSIDE_HORIZON`
- `CONVERGING`
- `CONFLICT_RELEVANT`
- `IMMEDIATE_CONFLICT`
- `ENCOUNTER_STALLED`
- `RESOLVING`

Do not interpret them as accepted architectural states merely because the first hypothesis was supported.

## Accepted Evidence

The first TS001 run contained two useful encounters:

- an earlier head-on pass whose projected closest separation remained approximately 72 m and was not classified as conflict-relevant;
- a later encounter whose projected miss distance collapsed during manoeuvring and then stabilised near zero.

The probe recorded the later `Conflict Emergence Point` at:

- separation: 318.38 m;
- projected time to closest approach: 29.66 s;
- projected closest separation: 1.98 m;
- relationship: head-on.

The player exited before collision. Final encounter outcome and provisional immediate-conflict classification were therefore not captured.

## Passive Guarantee

Prototype 01 must not control vehicles.

v4.6.2:

- sets `AI_EXPLORER_ONLY = true`;
- sets `TRAFFIC_V2_ENABLED = false`;
- processes the observer-only return before Traffic Manager v2 can update;
- disables the probe and emits an error if the passive configuration is not satisfied.

This addresses the **Passive Boundary Ordering Gap** found in v4.6.1, where Traffic Manager v2 could update before the observer-only return. The accepted TS001 log reported `passive=true` and no OuttaMyWay control action.

## Next Action

Before implementing another prototype:

1. begin from the exact canonical v4.6.2 package;
2. consolidate the accepted Prototype 01 evidence;
3. define one next architectural hypothesis and its evidence contract;
4. keep interpretation, Commitment and Control responsibilities separate;
5. preserve passive observation unless the new hypothesis explicitly requires another boundary.

Do not tune the existing thresholds merely because a diagnostic sample appears surprising. First classify evidence as:

- fact from the game/log;
- interpretation produced by the probe;
- architectural implication;
- implementation defect;
- missing evidence.

## Architectural Context

Accepted concepts include Situation Space, Current Situation, Future Space, Action Space, Situation Assessment, Commitment and derived Conflict Zone.

`Conflict Relevance Transition` and `Conflict Emergence Point` remain Deferred. The first run supports their detectability but does not yet prove stable architectural boundaries. Entity naming and Operational Picture terminology also remain Deferred.

Situation Assessment owns interpretation. It may report that a plausible conflict exists, but it must not issue stop, yield or steering commands. Decision and Commitment remain later responsibilities.

## Repository Entry Point

Read in this order when resuming:

1. `docs/README.md`
2. `docs/PROJECT_STATUS.md`
3. `docs/prototypes/PROTOTYPE_01_CONFLICT_EMERGENCE.md`
4. `docs/CONCEPT_REGISTER.md`
5. `docs/DECISION_LOG.md`
6. `docs/ENGINEERING_JOURNAL.md`
7. `docs/GLOSSARY.md`

## Engineering Method

Continue using:

> Observe → Discuss → Hypothesise → Implement → Validate → Record → Repeat

Reality remains the final architect. Do not advance to avoidance behaviour merely because Prototype 01 detected a future conflict.
