# Known Issues

## Future-Space and Safe-Release implementation gap

- Canonical v4.6.50 runtime does not implement ADR-0006.
- Temporary v4.6.51–v4.6.55 implementations are evidence only and must not be promoted wholesale.
- Current straight-line and constant-velocity prediction cannot represent continuation through the next material headland manoeuvre.
- Relationship changes can fragment one continuing Situation into multiple episode records.
- A Control capability can report `EFFECTIVE` while operational reserve continues to collapse.
- Commitment completion can occur on current separation without proving a Safe Release Point.
- `CONTINUE_OBSERVATION` lacks a universal bounded evidence-and-option-preservation contract.
- Blocked or failed Reality can fall back to normal operation without an authorised recovery or explicit unresolved state.

The next active candidate must correct these ownership and lifecycle gaps generically. TS015 is the first validation fixture, not the policy definition.

## Architecture recovery boundaries

- **Runtime remains v4.6.43:** v4.6.50 does not contain the temporary v4.6.44–v4.6.49 behavioural mechanisms.
- **Prototype Boundary Leakage:** the audited temporary TS015/TS016 path accumulated top-level Situation Assessment, Decision, Commitment and Control responsibilities inside fixture-bounded controllers.
- **Architectural Constraint Enforcement Gap:** full Field World containment and other invariants exist architecturally but are not yet universal runtime admissibility gates.
- **Fragmented Commitment Ownership:** the current runtime has no shared continuing Commitment record spanning observation, regulation, hold, refuge, passage, continuation and handback.
- **Passive architecture not implemented:** the agreed shadow Operational Picture and authority-trace path remains future work.
- **Experimental Capability Corpus only:** Persistent Speed Authority, Temporal Separation Reserve, Protected Controller Handoff semantics and Refuge Viability evidence are not active in this candidate.
- **Hardcoded authority remains unresolved:** the v4.6.49 audit identified 79 significant configured or embedded values. Several are harmless cadence/watchdog values; others stand in for richer concepts and require classification before reuse.
- **Native Repositioning Motion unresolved:** fixed 5, 6, 7.5 and 15 km/h prototype values must not become architectural meanings. Assembly-appropriate repositioning remains to be derived from Native Motion Envelope.
- **Fixture identity remains in canonical prototype code:** Condor/Patriot name and asset checks remain because runtime behaviour is intentionally unchanged from v4.6.43. They are not accepted production generalisation.
- **Mutual continuation remains unresolved:** Safe Release Point and Continuation Safety Horizon exist, but their application to both assemblies after refuge occupancy has not yet been formalised in the implementation contract.

## Current open encounter boundaries

- **TS015 Headland Turn Overlap / Dual-Manoeuvre Admission Gap:** after a successful passage and GIANTS handback, both workers may enter interacting headland manoeuvres. Situation Assessment sees the convergence, but current admission accepts only straight/straight or one manoeuvring plus one straight-working. The later encounter is not new to v4.6.42; earlier left-side 15 km/h TS015 evidence also left a later headland convergence unresolved.
- **TS016 Completion-Transition Control Gap:** a completed assembly remains a relevant static obstacle, but active-active admission ends and the remaining worker receives no obstacle-navigation Control.
- Faster egress/ingress increases temporal and spatial separation, but no evidence yet proves that orientation speed is the direct cause or solution for the TS015 final collision.
- `REJOIN_ORIENTING` is runtime-supported for the tested rearward right-side TS015 target. Its 5 km/h cap remains fixture-bounded and should not be generalised before additional assemblies are tested.


- Encounter numbering and rearming remain fixture-bounded, not a general traffic-manager implementation.
- Rearming currently uses the established 35 m passage-clear threshold plus three seconds outside the predicted conflict envelope. This remains a fixture-calibrated hypothesis, not a universal production threshold.
- Failed or unresolved encounters remain latched until explicit recovery. Automated failure recovery is not designed.

## Publication readiness

- **Mod Description Drift:** `modDesc.xml` currently acts as an active prototype/release summary rather than a stable description of the mod. Correct this during Publication Readiness Review, not during the current evidence increment.

## Calculated refuge authority, automatic admission and clearance evidence

- v4.6.40 runtime-validated calculated Yield-role, refuge-side, lateral-distance and rearward-distance authority with Patriot as Yield. v4.6.41 does not change that authority; it changes only successful encounter lifetime.
- Automatic Encounter Admission remains fixture-bounded: exactly the exclusive Condor/Patriot active pair is required. v4.6.41 adds pair-local encounter numbering and rearming but does not establish general encounter identity across arbitrary operations.
- The selected role is calculated at admission. Both sides for that role are recalculated from the confirmed stopped pose before Control receives a target.
- No fixed Condor, physical-right, 28 m or 12 m fallback remains. Calculation failure withholds admission or leaves an already-held worker in the existing safe held failure state.
- The rearward distance is calculated from predicted compact-assembly forward extent plus geometry/tracking margin so the complete compact assembly rests behind the stop line.
- Field-polygon containment, obstacle occupancy and complete egress swept-space checks are not yet implemented in the calculated-selection gate. The current runtime test therefore remains limited to the known open Condor/Patriot fixture.
- When compact Yield geometry is unavailable, the live AI working-marker half-width may be used as a labelled `LOW_CONSERVATIVE` upper-bound operand. This can overstate movement and is not compact-geometry closure.
- Role comparison can still be influenced by unequal representation quality. TS016 deliberately selects the straight-working worker by runtime state before confirmed-stop side/distance calculation.
- `otmTS015Arm` remains disabled. One Encounter Episode Latch permits one commitment per continuous fixture episode.
- The 2.50 m Condor origin allowance and 3.75 m clearance-margin budget remain fixture/evidence assumptions, not universal production constants.
- Prototype 17 clearance logs remain diagnostic Knowledge. The new calculated Control target is independently logged and must not be confused with retrospective closest-approach evidence.

## Prototype 15 / TS014

- `foldAnimTime=0.15` is a fixture-specific Egress-Ready Candidate, not complete-assembly clearance authority.
- Complete Behavioural Assembly swept-envelope compliance remains unresolved; only a vehicle-centre virtual fence is enforced.
- The 15 km/h pace is justified only for the tested Condor Native Motion Envelope and still requires runtime overshoot/stopping validation.
- TS014 excludes a second active worker, automatic role and side selection, refuge suitability and Egress Protection Hold.
- Prototype 08 records collision-node origin spans but mesh extents and Coverage Closure remain unresolved.
- `FAILED_HELD` still requires operator cancellation; production failure recovery is not designed. v4.6.40 suppresses repeated terminal log spam but does not automate recovery.

## Prototype 14 retained findings and limits

- TS012 validated that the native permission-gate HOLD can arrest one selected worker while preserving its Giants AI job.
- TS012 also disproved the in-lane Information-Gaining Delay as conflict resolution: the progressing worker did not route around the held assembly and both workers reached stable blockage through Static Obstacle Conversion.
- Later-admitted selection was a bounded TS012 experiment, not an accepted general priority policy.
- Predictor `CLEAR` is known to occur after collision or blocked convergence and cannot authorise release.
- Automatic Safe Release was deliberately absent and remains unvalidated.
- Prototype 14 remains disabled in v4.6.38; only one active hold was supported and multi-conflict arbitration remains unimplemented.

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
