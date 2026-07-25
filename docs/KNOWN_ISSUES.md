# Known Issues

## Physical assembly coverage

- Physical Assembly Discovery is validated for one integrated self-propelled fixture and two tractor–cultivator fixtures. Other attachment chains, front/rear combinations, trailed subassemblies and mod-defined attachment mechanisms remain untested.
- Attachment membership is not collision membership. Physical shapes inside each member remain unresolved.
- Member-local source-to-runtime identity resolution has not yet been implemented.

## AI progression evidence

- GIANTS may report an active `WORKING` state while measured physical movement remains effectively zero.
- The S 416 + Tiger 8 MT could cultivate manually, so its observed AI stall was not simple equipment incapability. The cause remains unresolved.
- Declared AI state, drive-strategy state and demonstrated motion must remain separate observations until stronger evidence exists.

## Physical geometry identity

- Runtime component-local spheres are established for the eight resolved active Condor boom collision nodes only.
- `vehicle.rootNode + source asset shapeId` aliases to root-Entity geometry and must not be used for descendant physical coverage.
- Local/general/world sphere self-coherence does not independently prove intended shape identity.
- Runtime Entities for the five permanent current physical collision shapes remain unresolved.
- Exact mesh dimensions and operationally useful compound occupancy remain unresolved; bounding spheres carry a substantial Sphere Precision Tax.

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
