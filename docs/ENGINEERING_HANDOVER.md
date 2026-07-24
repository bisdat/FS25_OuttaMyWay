# Engineering Handover

## Purpose

This document provides the context required to resume engineering from the repository alone. It explains the immediate continuation point rather than duplicating release history.

## Canonical Baseline

The supplied baseline for this increment was the exact canonical v4.6.1 package. Candidate Production is governed by the Repository Release System and does not itself confer canonical authority.

## Current Engineering Focus

Validate Prototype 01 at the Situation Assessment–Commitment boundary.

The prototype asks one question:

> Can Situation Assessment detect a Conflict Emergence Point before two native GIANTS AI workers reach immediate physical conflict?

Use the existing TS001 save unchanged. Two workers already follow native routes that ultimately converge head-on.

## Implementation State

Candidate v4.6.2 adds `scripts/prototypes/ConflictEmergenceProbe.lua`.

The probe reads only the central Observer model. It records position, heading, speed, separation, closing rate, heading relationship, closest-approach estimates, projected conflict location, worker state and provisional stage transitions.

The stage labels are diagnostic aids:

- `INDEPENDENT`
- `CONVERGING_OUTSIDE_HORIZON`
- `CONVERGING`
- `CONFLICT_RELEVANT`
- `IMMEDIATE_CONFLICT`
- `ENCOUNTER_STALLED`
- `RESOLVING`

Do not interpret them as accepted architectural states until game evidence supports stable boundaries.

## Passive Guarantee

Prototype 01 must not control vehicles.

The candidate:

- sets `AI_EXPLORER_ONLY = true`;
- sets `TRAFFIC_V2_ENABLED = false`;
- processes the observer-only return before Traffic Manager v2 can update;
- disables the probe and emits an error if the passive configuration is not satisfied.

This addresses the **Passive Boundary Ordering Gap** found in v4.6.1, where Traffic Manager v2 could update before the observer-only return.

## Next Action — TS001 Evidence Run

1. Install the complete v4.6.2 candidate.
2. Load the existing TS001 save without changing the two-worker setup.
3. Allow the full head-on encounter to unfold under GIANTS AI.
4. Avoid manual intervention unless necessary to protect the save.
5. Note when the conflict first appears visually plausible and what the workers eventually do.
6. Exit normally and upload the complete `log.txt` plus those brief observations.

Searchable evidence prefixes include:

- `PROTOTYPE 01 ACTIVE`
- `PROTOTYPE01 TRANSITION`
- `PROTOTYPE01 SAMPLE`
- `PROTOTYPE01 CONFLICT_EMERGENCE_POINT`
- `PROTOTYPE01 PAIR_EXIT`
- `PROTOTYPE01 PAIR_ENDED`
- `PROTOTYPE01 HEARTBEAT`

The complete evidence contract and validation questions are in `prototypes/PROTOTYPE_01_CONFLICT_EMERGENCE.md`.

## Validation Discipline

Do not tune thresholds merely because a line looks surprising. First reconstruct the observed sequence and classify each result as:

- fact from the game/log;
- interpretation produced by the probe;
- architectural implication;
- implementation defect;
- missing evidence.

A disproven hypothesis is useful if it reveals a missing concept such as Trajectory Confidence, Prediction Stability or a better representation of working geometry.

## Architectural Context

Accepted concepts include Situation Space, Current Situation, Future Space, Action Space, Situation Assessment, Commitment and derived Conflict Zone.

`Conflict Relevance Transition` and `Conflict Emergence Point` are Deferred pending Prototype 01 evidence. Entity naming and Operational Picture terminology also remain Deferred.

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

Reality remains the final architect. Do not advance to avoidance behaviour until Prototype 01 evidence has been reviewed and the architectural hypothesis has either gained or lost confidence.
