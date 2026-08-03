# ADR-0003 — Situation Assessment

Status: Accepted; clarified by v4.6.50 architecture recovery

## Context

OuttaMyWay must maintain a current understanding of one bounded Field World while workers, vehicles, implements, boundaries, obstacles, player actions and Control outcomes continue to change.

The architecture must distinguish observations from interpreted Knowledge and must not allow a Control implementation to become a competing source of operational truth.

## Decision

Situation Assessment maintains the most plausible current explanation of the evolving operational situation.

It:

- remains aware of the complete bounded Field World;
- interprets observations and uncertainty;
- infers operational intent and plausible Future Space;
- maintains participant, relevance, constraint and representation Knowledge;
- publishes that Knowledge through the Operational Picture;
- incorporates Control and Recovery outcomes as new observations.

Situation Assessment assesses. The Decision Engine decides.

```text
Observer
    ↓
Situation Assessment
    ↓
Operational Picture Knowledge
    ↓
Decision Engine
    ↓
Commitment
    ↓
Control
    ↓
Outcome Observation
    ↺ Situation Assessment
```

Situation Assessment does not select actions, assign Yield/Progress roles, choose a refuge, determine passage completion or authorise release.

## Sufficiency over Completeness

Complete Knowledge is not required. Available Knowledge must be sufficient for the particular conclusion or action.

Unresolved evidence cannot silently support an action that depends upon it. At the same time, Decision must assess the consequences of continued unchanged operation or passive observation when waiting may remove safer, less disruptive or more reversible options.

## Constraint ownership

Architecture and policy define non-negotiable invariants.

Situation Assessment maintains current constraint Knowledge and uncertainty.

Decision applies every constraint relevant to the candidate action or continuing Commitment.

Control cannot waive or bypass admissibility.

## Retired v4.3.8 labels

The v4.3.8 session named five terms without preserving sufficient definitions:

- Decision Readiness
- Decision-Relevant World
- Decision-Relevant Constraints
- Relevance Envelope
- Option Horizon

The v4.6.50 recovery review retired all five as independent concepts.

Their valid concerns remain represented by Field World, Operational Picture, Situation Relevance, Future Space, Action Space, explicit constraint applicability, Runtime Control Admissibility, Sufficiency over Completeness and Option Preservation.

Historical references remain provenance only.

## Consequences

- Situation Assessment awareness is not narrowed by a relevance filter.
- Relevance and materiality may change while awareness of the Field World remains.
- Decision consumes interpreted Knowledge rather than raw observations.
- Evidence sufficiency is conclusion- and action-specific, not one global ready state.
- A physical action automatically invokes the constraints applicable to its action class.
- Private controller state cannot supersede the Operational Picture.
