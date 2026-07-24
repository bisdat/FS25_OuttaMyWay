# Roadmap

## Development policy

Development remains in a private repository until the first GIANTS ModHub release. Internal builds use 4-part development versions. The first submitted/public ModHub release will use `1.0.0.0` in `modDesc.xml`.

## Architectural Prototyping

### Prototype 01 — Conflict Emergence Point

- [x] Select the unchanged TS001 two-worker head-on encounter as the natural observation fixture.
- [x] Define a passive evidence contract.
- [x] Add read-only pair instrumentation and explicit provisional thresholds.
- [x] Place the observer-only guard before decision and control consumers.
- [x] Run TS001 and upload the complete game log plus visual observations.
- [x] Validate the Prototype 01 hypothesis: early Conflict Emergence detection is supported.
- [x] Consolidate the changing-projection evidence into the Prototype 02 hypothesis before considering intervention behaviour.

### Prototype 02 — Conflict Confidence

- [x] Name Trajectory Settlement, Conflict Confidence and Conflict Formation Window as provisional concepts.
- [x] Define one passive hypothesis and evidence contract.
- [x] Add per-Entity stability and pair-level persistence instrumentation.
- [x] Run unchanged TS001 through the complete encounter.
- [x] Validate the `FORMING → ESTABLISHED` interpretation: the Prototype 02 hypothesis is strongly supported.
- [x] Establish that Trajectory Settlement and Conflict Confidence have useful distinct provisional responsibilities.
- [x] Record that future-projection decay after collision is not equivalent to real conflict resolution.
- [ ] Consolidate the realised-conflict boundary into the next single-hypothesis increment before active intervention.

### Prototype 03 — Option Preservation Window

- [x] Name Candidate Option Preservation Window, Progress Entity, Intent Revelation Point, Response Margin and Alternate Exhaustion Point as provisional concepts.
- [x] Scope Information-Gaining Delay and the Progress Preservation Invariant.
- [x] Define one passive hypothesis and evidence contract.
- [x] Add manoeuvre-ordering, intent-revelation and response-margin instrumentation.
- [x] Run unchanged TS001 through the complete encounter.
- [x] Observe a real `ACTIONABLE` interval approximately 12 s before conflict establishment.
- [x] Validate that Condor's local intent became clear while Patriot retained approximately 7.42 s of conservative temporal margin.
- [x] Preserve one Progress Entity and avoid Observation Deadlock in the evidence model.
- [x] Record Startup Manoeuvre Contamination and Exhaustion Event Repetition as instrumentation defects.
- [x] Run a limited manual continuation test and disprove current-lane intent as sufficient safe-release evidence.
- [x] Decide that an active Information-Gaining Delay is not yet justified because continuation and release safety remain unproven.

### Prototype 04 — Continuation Intent and Safe Release

- [ ] Define one passive hypothesis separating locally revealed intent from route continuation.
- [ ] Expire previously revealed intent when a new manoeuvre begins or materially changes the trajectory.
- [ ] Observe whether a hypothetical release remains clear through the Progress Entity's next repositioning event.
- [ ] Distinguish a resolved encounter from a later linked Encounter Chain.
- [ ] Correct Prototype 03 startup contamination and repeated exhaustion-event logging within the declared increment.
- [ ] Consider an active Information-Gaining Delay only after a Safe Release Point is observable.

## Repository Release System follow-up

The v4.6.0 recovery cycle validated Candidate Production sufficiently to return project focus to OuttaMyWay. The following work remains deliberately deferred:

- [ ] Add a non-blocking dirty-working-tree notice that explains local changes are not included when a separate canonical ZIP is the declared baseline.
- [ ] Architect and run the adversarial Repository Challenge Suite.
- [ ] Implement governed Authority Transformation and candidate-to-canonical substantive-purity verification.
- [ ] Enforce the complete ordered repository-authority-state sequence.

## 4.0 — Predictive traffic manager

### Current

- [x] Read live GIANTS field-course strategies.
- [x] Extract nested segment positions.
- [x] Build future polylines.
- [x] Observer-only route-intersection diagnostics.
- [x] Observer-only completion-priority diagnostics.
- [x] Change-driven diagnostic caching.
- [ ] Reliably map GIANTS active segment/progress to extracted segment index.
- [ ] Correct course-relative remaining distance through turns.
- [ ] Build swept corridors using half working width A + half working width B.
- [ ] Validate arrival-time estimates over repeated test runs.
- [ ] Enable timing-only HOLD action.

### Later 4.x

- [ ] Timing-based SLOW action.
- [ ] Stable traffic reservations across multiple workers.
- [ ] Completion priority when it reduces total field congestion.
- [ ] Course-aware headland ownership.
- [ ] Preserve reactive logic strictly as emergency fallback.
- [ ] Safe handling of offset implements.
- [ ] Towed-implement reverse preparation and steering.

## Release 1.0.0.0 definition

Required:

- [ ] No repeatable Lua errors.
- [ ] Stable single-player behaviour across multiple maps and implement widths.
- [ ] Sensible maximum-worker guidance documented.
- [ ] English, German, French, Spanish and Italian localisation.
- [ ] HUD readable at common UI scales and weather conditions.
- [ ] Simulation/debug controls documented.
- [ ] Performance tested with mod enabled, idle and active.
- [ ] Proper icon, screenshots, description and changelog.
- [ ] Private repository history cleaned of test-only binaries/secrets.
- [ ] ModHub package version set to `1.0.0.0`.

Multiplayer:

- [ ] Host/admin smoke test on a multiplayer save.
- [ ] Confirm clients can join and receive state without Lua/network errors if a second client becomes available.
- [ ] Document multiplayer as limited testing unless a genuine multi-client test is completed.

## Optional single-worker recovery (back burner)

- [ ] Detect a lone AI worker that repeatedly fails to make progress toward its native steering target.
- [ ] Distinguish temporary obstruction from genuine hedge, branch, boundary or map-object entanglement.
- [ ] Attempt conservative recovery without destroying the GIANTS field-course job.
- [ ] Escalate from pause/retry to short reverse/reposition only when confidence is high.
- [ ] Remain optional and independently disableable from multi-worker traffic management.

## Post-1.0 ideas

- Move completed workers to a safe nearby field edge.
- Farm-wide cost optimisation for three or more workers.
- In-game settings page.
- Additional localisations based on community contributions.
