# Roadmap

## Development policy

Development remains in a private repository until the first GIANTS ModHub release. Internal builds use 4-part development versions. The first submitted/public ModHub release will use `1.0.0.0` in `modDesc.xml`.

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
