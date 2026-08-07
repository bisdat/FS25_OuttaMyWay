## v4.7.24 active interaction diagnostics

The active replacement core no longer computes or logs the superseded fixed-horizon TCPA/DCPA future predictor. Pair diagnostics retain present-state distance, heading relation, relative speed, closing rate, scalar current overlap, configuration-filtered current footprint overlap and field-bounded Future Space state. Future Encounter admission comes from supported field-bounded Future Space or legitimate positive Current Space evidence.

Current-footprint non-overlap remains unresolved and grants no negative-clearance authority. Historical diagnostic sections below describe earlier increments and remain as engineering history, not current runtime behavior.

## v4.7.23 Future-Space Encounter-admission diagnostics

The lifecycle HUD now prompts on `FUTURE SPACE ENCOUNTER`, then guides stop, termination, restart and fresh Future-Space Encounter. Throttled pair diagnostics expose `futureSpacePositive` and `legacyShadowPositive` separately. The legacy ten-second predictor is diagnostic comparison only and has no Encounter-admission authority.

The prior `REPRESENTATION_UNFIT_BUT_NEGATIVE_RESULT_USED` contradiction is removed: the active implementation does not consume non-positive representation output as negative clearance. Non-positive Future-Space/representation evidence remains unresolved.

After this live gate passes, remove the superseded legacy future-prediction code/messages rather than maintaining shadow instrumentation indefinitely.

## v4.7.22 lifecycle-precedence diagnostics

The temporary lifecycle Transition HUD is active again for the stop/restart gate. Each lifecycle transition emits one `[OTM TEST GATE]` line. v4.7.21 Future Space evidence and `[PASSIVE] FUTURE_SPACE` logging remain active, but the Future Space HUD is hidden during this gate to keep the required operator action unambiguous.

An incomplete Operation-membership observation may now report `MEMBERSHIP_UPDATED_INCOMPLETE` with removal deferred. This is diagnostic evidence of withheld removal authority, not a timer or a new lifecycle state. Encounter reconciliation should therefore retain the existing Encounter until complete lifecycle evidence supports an exit.

## v4.7.21 Future Space conformance diagnostics

The temporary HUD now reports Local Intent/Future Space rather than operator lifecycle instructions. Settled native GIANTS FieldCourse segments display `STRAIGHT` with the measured forward Job-Seeded Field World boundary extent; native turns display `TURNING`; the pair line reports positive field-bounded Future-Space intersection, manoeuvring unresolved, or no positive intersection observed. Transition-only `[FUTURE-SPACE HUD]` log lines and `[PASSIVE] FUTURE_SPACE` relationship lines preserve the evidence without making the HUD authoritative. Measured distances are diagnostic values, not behavioural thresholds.

## v4.7.20 live-gate observability

The complete evidence record remains in sealed passive traces, but routine pair console output is emitted only on material diagnostic-state change or heartbeat. A temporary Transition HUD presents the current operator instruction. Each HUD transition emits one `[OTM TEST GATE]` line, allowing the final log to be searched without requiring the player to read the console in real time.

A Shape-Type Gate now prevents `getShapeGeometryBoundingSphere`, `getShapeBoundingSphere` and `getShapeWorldBoundingSphere` from being invoked unless the runtime Entity positively reports `ClassIds.SHAPE`.

## v4.7.19 lifecycle diagnostics

Encounter lifecycle is no longer inferred from current-sample presence. The passive validator reports registry transitions: `CREATED`, heartbeat-bounded `RETAINED`, and explicit `TERMINATED` with reason, Job Episode identity and authoritative terminal cause. `LOST` is retired because evidence disappearance is not a lifecycle fact.

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
