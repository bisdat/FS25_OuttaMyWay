# Known Issues

## 4.0.0.1 course lookahead

- Active segment estimation may jump to a nearby parallel segment during headland turns.
- Finish ETA can change by many minutes within one second and is not yet suitable for live priority decisions.
- Extracted per-segment `length` metadata can disagree with geometric endpoint distance on short connector segments.
- `headland` metadata is not consistently exposed in the currently parsed segment table.
- The 30-second corridor may report CLEAR when the wrong active segment is selected.

## Established behaviour

- Folding an active AI worker may destroy its current GIANTS drive strategy and force expensive course regeneration.
- A fresh AI fieldwork restart on partly worked fields can take more than a minute.
- Passage-assist restart is not reliable enough to be the primary solution.
- Towed implements may need raising before reverse and implement-aware steering.
- Offset implements need asymmetric left/right corridor extents.
- Large worker counts can increase conflicts and CPU cost; current recommendation is no more than four workers on one field.

## Testing gaps

- Multiplayer has only limited host/admin smoke-test coverage.
- Full dedicated-server and second-client testing is not currently available.
