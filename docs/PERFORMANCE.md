# Performance Notes

## v4.7.95 performance disposition — continuous King path retired

Post-canonical v4.7.77 evidence isolated a material performance problem in the continuous King-space implementation family:

- with OuttaMyWay disabled under comparable load, the characteristic severe stutter was absent;
- broad Knowledge/Productive-History work before actual King clearance did not reproduce the same regression;
- introducing repeated actual-TRANSIT-footprint King placement/swept-clearance produced conspicuous stutter;
- removing exact polygon decomposition and per-frame Knowledge-copy amplification did not remove it;
- restoring older circle-style King clearance materially improved performance but lacked authoritative geometry;
- reducing exact King re-proof count through retained certificates did not improve FPS proportionately;
- attempted direct runtime timing instrumentation exposed an `os.clock()` availability gap and did not produce valid timings.

**D-0143 consequence:** do not spend the TS015 tranche profiling or optimising continuous King/Refuge discovery. The governing path is retired. Cooperative Passage asks a bounded on-demand local question only when a supported opposed conflict requires Reposition. Performance must still be measured during production integration, but no background King-space fixture should be reintroduced.

---

## Historical/general design targets

- No expensive full-field scan every frame.
- Cache working widths and course geometry.
- Run the main controller at 10 Hz.
- Log on state changes rather than every update.
- Keep observer-only diagnostics separable from live control.

## Current cadence

- Main update interval: 100 ms.
- Course vehicle log interval: 2 s.
- Pair log interval: 3 s.
- Course heartbeat: 15 s.
- Width cache: 3 s.
- Field-boundary retry/log interval: 30 s.

## Profiling checklist

Measure in the same save and camera position:

1. Mod disabled.
2. Mod enabled with no AI workers.
3. One active worker.
4. Two active workers with no conflict.
5. Two active workers with course intersection.
6. Four active workers on one field.

Record frame rate, frame-time spikes, log volume and update-loop timings.
