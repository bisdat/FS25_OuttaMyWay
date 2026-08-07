# Bounded Live Interaction Diagnostics

## Purpose

Canonical v4.7.15 instruments the existing passive path from GIANTS active-job observation to Encounter construction. It is evidence gathering only. It does not change Field World identity, Operation admission, pair predicates, Encounter admission semantics, Decision, Commitment or Control.

## Diagnostic relationship

A **pair diagnostic** is one unordered relationship between two distinct relevant Operation members. It is an assessment unit, not a two-worker Operation limit and not an Encounter. For `n` relevant workers, the implementation can enumerate `n(n-1)/2` unique relationships. Diagnostic log output is capped independently from operational evaluation; truncation is reported explicitly and does not alter pair evaluation.

## Instrumented chain

The build records:

1. active-job membership and pose acquisition;
2. steering-node or root-node selection and pose failure reason;
3. size metadata, derived radius, component count and Representation Fitness limits;
4. reported motion and position-derived motion classification;
5. all relevant, eligible, evaluated, excluded and qualifying unordered pairs;
6. distance, represented clearance, heading relationship, relative motion, closing rate, tCPA and dCPA;
7. one exhaustive principal pair outcome;
8. interaction evidence emitted by the live source;
9. interaction evidence received by Situation Assessment;
10. Encounter creation and lifecycle;
11. bounded contradiction warnings.

## Principal pair outcomes

- `MISSING_SUBJECT_RADIUS`
- `MISSING_OTHER_RADIUS`
- `RELATIVE_MOTION_BELOW_EPSILON`
- `TCPA_BEHIND_CURRENT_TIME`
- `TCPA_BEYOND_HORIZON`
- `CPA_EXCEEDS_REPRESENTED_ENVELOPE`
- `CURRENT_INTERACTION_QUALIFIED`
- `FUTURE_INTERACTION_QUALIFIED`

These labels explain the existing implementation branch. They are not architectural concepts and do not grant authority.

## Diagnostic contradictions

The build can report, without altering behaviour:

- `ACTIVE_JOB_VEHICLE_WITHOUT_POSE`
- `SAME_OPERATION_ACTIVE_PAIR_NOT_EVALUATED`
- `INTERACTION_EVIDENCE_HANDOFF_LOST`
- `INTERACTION_EVIDENCE_WITHOUT_ENCOUNTER`
- `ENCOUNTER_WITHOUT_INTERACTION_EVIDENCE`
- `BOTH_WORKERS_BLOCKED_WITHOUT_ENCOUNTER`
- `REPRESENTATION_UNFIT_BUT_NEGATIVE_RESULT_USED`
- `PAIR_OPERATION_CHANGED_DURING_JOB_EPISODE`
- `PAIR_DISAPPEARED_WHILE_BOTH_WORKERS_ACTIVE`

A diagnostic contradiction identifies evidence requiring inspection. It is not automatically an architectural contradiction.

## Runtime limits

- one passive sample per second;
- assembly detail on change and heartbeat;
- pair detail once per pair per sample;
- at most 64 pair log lines per sample by default;
- complete counters remain available when log lines are truncated;
- no collision-node enumeration or broad reflection;
- `control=false` remains mandatory.

## Closed diagnostic result

The live TS015 gate established that both sprayers reached pair evaluation but exposed no scalar width, length or radius. Every sample terminated with `MISSING_SUBJECT_RADIUS`; no handoff defect existed. The next representation work is documented in [`../representation/PLAN_VIEW_REPRESENTATION_SHADOW.md`](../representation/PLAN_VIEW_REPRESENTATION_SHADOW.md).
