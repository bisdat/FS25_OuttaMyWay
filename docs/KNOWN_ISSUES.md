# Known Issues

## Prototype 17 and clearance authority

- Shadow Clearance Calculation remains observer-only and fixture-specific. It must not be read as automatic Decision or Control authority.
- All 13 current Condor identities and origins resolved, but no usable runtime shape bounds were exposed through the tested APIs.
- The 2.50 m unresolved physical allowance is a fixture hypothesis, not Coverage Closure or a production constant.
- Existing v4.6.30 logging combines physical geometry and provisional policy margins in one requirement/reserve pair. This obscures a positive physical reserve when the policy target remains unmet.
- Physical threshold/reserve and policy target/reserve must be separated before further authority is considered.
- Condor remains hard-coded as Yield and Patriot as Progress. Patriot-yields role-transfer validity is untested.
- The console direction labels remain inverted relative to observed physical movement.
- Triggering and side choice remain manual; field/margin refuge availability, obstacles and complete assembly swept paths are not evaluated.
- The 28 m movement, 3.75 m margin budget and 36 m working-marker fallback are fixture evidence rather than universal values.

## Prototype 15 / TS014

- `foldAnimTime=0.15` is a fixture-specific Egress-Ready Candidate, not complete-assembly clearance authority.
- Complete Behavioural Assembly swept-envelope compliance remains unresolved; only a vehicle-centre virtual fence is enforced.
- The 15 km/h pace is justified only for the tested Condor Native Motion Envelope and still requires runtime overshoot/stopping validation.
- TS014 excludes a second active worker, automatic role and side selection, refuge suitability and Egress Protection Hold.
- Prototype 08 records collision-node origin spans but mesh extents and Coverage Closure remain unresolved.
- `FAILED_HELD` still requires operator cancellation; production failure recovery is not designed.

## Prototype 14 retained findings and limits

- TS012 validated that the native permission-gate HOLD can arrest one selected worker while preserving its Giants AI job.
- TS012 also disproved the in-lane Information-Gaining Delay as conflict resolution: the progressing worker did not route around the held assembly and both workers reached stable blockage through Static Obstacle Conversion.
- Later-admitted selection was a bounded TS012 experiment, not an accepted general priority policy.
- Predictor `CLEAR` is known to occur after collision or blocked convergence and cannot authorise release.
- Automatic Safe Release was deliberately absent and remains unvalidated.
- Prototype 14 is disabled in v4.6.31; only one active hold was supported and multi-conflict arbitration remains unimplemented.

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


## Scope Overlay calibration boundaries

- TS008-N's brief post-admission rejection was directly observed but occurred between current observer samples; the Transient Admission Visibility Gap remains an instrumentation limitation.
- TS010's conservative current envelope reported non-containment during visually valid right-offset mowing. Valid Boundary Straddling, coarse rectangle overreach and immediate-margin use have not yet been distinguished.
- Left-offset, mirrored and reversible working-envelope asymmetry remain untested.
- Empirical results are version-bound. TS005–TS009 use FS25 1.21.0.0; TS010 uses the undocumented 1.21.1.0 build b40785.

## Testing gaps

- Multiplayer has only limited host/admin smoke-test coverage.
- Full dedicated-server and second-client testing is not currently available.
