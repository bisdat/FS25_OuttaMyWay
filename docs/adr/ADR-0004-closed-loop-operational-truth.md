# ADR-0004 — Closed-Loop Operational Truth

Status: Accepted

## Context

Decision issues a selected change to Control. Control may realise it, partially realise it, reject it or expose that a presumed capability is unavailable. A direct Control-to-Decision feedback path would allow Decision to react to raw execution events without first updating the system's understanding of the operational world.

## Decision

Situation Assessment is the sole interpreter of observations and the single source of operational truth.

All new information enters the architecture through Situation Assessment, regardless of origin. This includes observer facts, Control outcomes, capability changes, player intervention and Recovery outcomes.

The closed loop is:

```text
Observer
    ↓
Situation Assessment
    ↓
Decision
    ↓
Control
    ↓
Outcome Observation
    ↺ Situation Assessment
```

Control does not instruct Decision to choose again. It reports what was attempted, what effect was observed and what capability was demonstrated or disproved. Situation Assessment incorporates that evidence into the Operational Picture before any further decision is made.

## Consequences

- Decision consumes interpreted understanding rather than raw observations.
- Decision does not maintain a competing source of operational truth.
- Control failures are evidence, not merely implementation errors.
- Capability feedback updates the Intervention Capability Model through Situation Assessment.
- A decision remains provisional until its intended operational effect is confirmed, superseded or abandoned through the updated assessment.
- Recovery returns resulting-state observations through the same loop; no special direct Recovery-to-Decision path is required.

## Related Open Question

The category and final name of Decision's positive output remain deliberately unresolved. **Remedy**, **variance**, **operational intent** and **temporary operational constraint** are candidates, but the architecture currently preserves only the discovered concept: when passivity is no longer justified, Decision selects a realizable, least-disruptive change to normal autonomous operation.
