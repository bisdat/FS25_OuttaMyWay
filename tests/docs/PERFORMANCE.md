# Performance Notes

## Design targets

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
