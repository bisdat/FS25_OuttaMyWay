# Prototype 01 — Conflict Emergence Point

> **Status:** Awaiting first TS001 evidence run
>
> **Candidate:** v4.6.2
>
> **Mode:** Passive observation only

## Architectural hypothesis

Situation Assessment can detect a **Conflict Emergence Point** before two AI workers reach immediate physical conflict, using observations from the existing TS001 head-on convergence.

The prototype is intended to distinguish:

1. independent trajectories;
2. convergence without established conflict relevance;
3. a plausible shared Conflict Zone;
4. immediate conflict;
5. the encounter outcome.

The provisional stage labels are diagnostic aids, not accepted architecture and not control decisions.

## Observation fixture

Use the existing TS001 game save unchanged. Two GIANTS AI field workers already follow native routes that ultimately converge head-on. The scenario is valuable because the conflict emerges from normal game behaviour rather than a route created to satisfy the prototype.

## Evidence contract

For every observed worker pair within the prototype horizon, record:

- stable vehicle identity and display name;
- timestamp;
- world position;
- heading;
- actual speed;
- worker phase, turn state and native blocked state;
- current separation;
- closing rate;
- heading relationship;
- constant-velocity time to closest approach (tCPA);
- predicted distance at closest approach (dCPA);
- projected midpoint of closest approach;
- provisional stage and every stage transition;
- the exact provisional thresholds used by the probe.

The probe must also record worker attachment/detachment indirectly through Observer diagnostics, pair exit/end, heartbeat state, and whether its passive guarantee is active.

## Provisional interpretation

The probe currently labels evidence as:

- `INDEPENDENT` — no positive near-future convergence is established;
- `CONVERGING_OUTSIDE_HORIZON` — trajectories close, but the predicted encounter lies beyond the observation horizon;
- `CONVERGING` — separation is reducing within the horizon, but provisional conflict relevance is not established;
- `CONFLICT_RELEVANT` — predicted closest approach crosses the provisional relevance distance/time thresholds;
- `IMMEDIATE_CONFLICT` — predicted closest approach crosses the tighter immediate thresholds;
- `ENCOUNTER_STALLED` — both workers become slow after conflict relevance was established;
- `RESOLVING` — a previously relevant pair becomes non-closing or moves beyond the horizon.

These labels make the evidence searchable. The first run must validate or disprove whether they correspond to the observed encounter.

## Passive boundary

Prototype 01 must not change speed, steering, implements, priority, AI state or route.

The candidate therefore:

- runs with `AI_EXPLORER_ONLY = true`;
- disables Traffic Manager v2 explicitly;
- evaluates the observer-only return before any Traffic Manager v2 decision or execution update;
- disables the probe if its passive configuration is not satisfied.

This corrects the **Passive Boundary Ordering Gap** discovered in v4.6.1: Traffic Manager v2 was updated before the runtime reached its observer-only return, so the observer-only declaration was not structurally sufficient by itself.

## Test procedure

1. Install the complete v4.6.2 candidate as the active OuttaMyWay mod.
2. Start the existing TS001 save without changing the vehicle setup or routes.
3. Allow both AI workers to continue through the complete head-on encounter.
4. Do not intervene unless required to prevent loss of the test save.
5. Note approximately when the conflict first becomes visually apparent and what GIANTS AI eventually does.
6. Exit the game normally so the log is flushed.
7. Upload the complete `log.txt` together with the brief visual observations.

Useful log filters are:

- `PROTOTYPE 01 ACTIVE`
- `PROTOTYPE01 TRANSITION`
- `PROTOTYPE01 SAMPLE`
- `PROTOTYPE01 CONFLICT_EMERGENCE_POINT`
- `PROTOTYPE01 PAIR_EXIT`
- `PROTOTYPE01 PAIR_ENDED`
- `PROTOTYPE01 HEARTBEAT`

## Validation questions

The first evidence review should answer:

- Was the pair observed early enough?
- Did the evidence distinguish proximity from convergence?
- Was a Conflict Emergence Point logged before immediate conflict?
- Was the reported relationship correctly classified as head-on?
- Were tCPA and dCPA stable enough to support an architectural transition?
- Did stage changes oscillate during normal GIANTS turns?
- Did the log preserve the final encounter outcome?
- Which observations or concepts are missing?

## Conditions that decrease confidence

The hypothesis loses confidence if:

- the pair becomes visible only at immediate-conflict distance;
- harmless proximity and converging trajectories are indistinguishable;
- predicted closest approach bears little relationship to the actual encounter;
- the provisional state oscillates rapidly without corresponding world changes;
- GIANTS route changes make the prediction unusably unstable;
- the encounter outcome cannot be reconstructed from the evidence.

A failed test remains a successful architectural probe when it identifies the missing knowledge.
