# Roadmap

## Current increment — Clearance evidence separation

Preserve the validated Condor-yields actuator and fixture-bounded Facing Extent Provider. Separate physical contact evidence from policy-margin evidence before introducing automatic decisions.

## Active — Prototype 17 consolidation and next validation

- [x] Validate the isolated and two-worker Unilateral Sidestep actuator through TS013–TS015-B.
- [x] Establish the failed 21.44 m and successful 27.38 m actual lateral fixture observations.
- [x] Add observer-only Facing Clearance Extent and explicit margin calculation.
- [x] Run TS017-A and confirm Patriot extent acquisition plus safe `n/a` handling for missing Condor extent.
- [x] Add exact Condor current-physical catalogue resolution and runtime-bound/origin fallback.
- [x] Run TS017-B and complete the full handoff observation.
- [x] Resolve 13/13 Condor identities/origins and record 0/13 usable runtime bounds.
- [x] Compare the 25.37 m live physical threshold against the failed and successful fixture evidence.
- [x] Name Origin Coverage Is Not Bound Coverage and Physical Clearance Is Not Policy Clearance.
- [x] Separate `physicalContactThreshold` and `physicalClearanceReserve` from `policyMarginBudget`, `policyRequiredSeparation` and `policyReserve` in v4.6.32 candidate output.
- [ ] Repeat the established manual run to validate the separated output without actuator change.
- [ ] After validation, discuss shadow generation and comparison of Condor/Patriot Yield and escape-side candidates.
- [ ] Keep derived movement, automatic trigger, role selection and side selection without authority until their own evidence increments.

## Deferred Publication Readiness Review

- [ ] **Mod Description Drift:** return `modDesc.xml` to a stable mod description rather than an increment-specific release summary.

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
- [x] Consolidate the realised-conflict boundary through TS011 and authorise one active Prototype 14 hypothesis.

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
- [x] At that stage, defer active delay until complete physical observation and repeatable intervention evidence existed.
- [x] Reopen only the bounded delay claim after TS011 established repeatable pre-blockage evidence; Safe Release remains deferred.

### Prototype 04 — Continuation Intent and Safe Release

- [x] Define one passive hypothesis separating locally revealed intent from route continuation.
- [x] Expire previously revealed intent when a new manoeuvre begins or the worker detaches.
- [x] Run the limited TS001 stop/reposition/restart procedure.
- [x] Validate bounded local intent epochs and immediate Intent Expiry.
- [x] Observe that the original parked position became unsafe during a later Condor repositioning.
- [x] Record that the active-worker observer could not classify the physical encounter after Patriot left Operational Membership.
- [x] Observe a later terminal occupancy conflict after completed Condor left active observation.
- [x] Correct Prototype 03 startup contamination, stale intent and repeated exhaustion-event logging within the declared increment.
- [x] Preserve this earlier deferral as valid for the evidence then available.
- [x] Keep automatic Safe Release deferred while Prototype 14 tests only the one-worker delay Commitment.

### Prototype 14 — Single-Worker Information-Gaining Delay

- [x] Establish a Start-Order-Independent Conflict through TS011-A/B.
- [x] Define one active Commitment: hold the later-admitted worker after `ESTABLISHED` confidence.
- [x] Reuse the native field-worker permission gate without ending or restarting the Giants AI job.
- [x] Enforce one active hold and an exclusive runtime boundary.
- [x] Forbid predictor `CLEAR` from authorising release.
- [x] Log Safe Release Candidate evidence without releasing.
- [x] Run TS012-A/B and classify the outcome: control viability supported; in-lane delay disproved as conflict resolution through Static Obstacle Conversion.

### Prototype 15 — Unilateral Sidestep

- [x] Name Minimum Necessary Authority, Bounded Route Deviation, Compact Transit Configuration, Protected Progress Corridor, Minimum Sufficient Displacement and Route Reassertion.
- [x] Prefer one diverted Yield Entity and one unchanged Progress Entity.
- [x] Require initial movement to the selected outward side rather than across the unselected lane boundary.
- [x] Implement manual left/right arming for a one-worker capability probe.
- [x] Keep full Behavioural Assembly fence compliance explicitly unclaimed.
- [x] Validate hold, compacting, egress, rejoin, deployment and handback in TS013.
- [x] Establish Forward Route Reacquisition rather than return to the switch/departure point.
- [x] Validate Retreating Unilateral Sidestep pace and folding overlap through TS014.

### Prototype 05 — Field World Observation

- [x] Recover and promote Full-Envelope Field Containment into authoritative architecture and vocabulary.
- [x] Define the field polygon as the bounded Field World for one Operation.
- [x] Separate Field World Membership, Operational Membership and Situation Relevance.
- [x] Validate stopped/player-controlled Patriot as a retained non-operational Field World Member and detect relevance during Condor approaches in supporting TS001 runs.
- [x] Validate completed Condor as a retained non-operational Field World Member and detect Patriot's terminal approach in repeatable TS002.
- [x] Include moving player-controlled vehicles in the vehicle observation boundary.
- [ ] Extend later evidence to complete static-object identity wholly inside the field polygon.
- [x] Record external hedges, trees and other geometry as outside obstacle scope under Full-Envelope Field Containment.
- [ ] Implement and validate exact full-envelope containment control.
- [x] Establish the vehicle observation boundary before reconsidering active Information-Gaining Delay.
- [x] Correct Operational Membership event latching and live relationship reclassification.
- [x] Validate a repeatable live `OPERATION_MEMBER → NON_OPERATION_VEHICLE` transition in TS003.
- [ ] Reconsider active Information-Gaining Delay only after transition evidence, internal static-world observation and exact geometry boundaries are sufficiently understood.

### Prototype 06 — Membership Transition Reclassification

- [x] Preserve Boolean false when comparing previous Operational Membership.
- [x] Assign and retain per-Entity classification revisions.
- [x] Preserve TS002 relevance behaviour with zero false role-transition events.
- [x] Establish repeatable TS003 live completion despite GIANTS restart repositioning.
- [x] Emit exactly one live membership transition when Condor completes.
- [x] Retain the same Condor Field World identity.
- [x] Reclassify the active Patriot-to-Condor relationship exactly once.
- [x] Retire the obsolete reverse directional relationship explicitly.
- [x] Confirm no repeated unchanged event, Lua error or vehicle-control action.
- [x] Record that transient GIANTS blocked warnings may clear without deadlock.

### Prototype 07 — Physical Occupancy Evidence

- [x] Name Geometry Domain Separation and Physical–Agronomic Separation.
- [x] Establish No Silent Under-Approximation.
- [x] Define one passive evidence-discovery hypothesis.
- [x] Inventory GIANTS geometry capabilities without assuming a single collision-box API.
- [x] Aggregate root vehicle and attached/towed implements as one Entity in the evidence model.
- [x] Record provenance, coverage, confidence and frame stability.
- [x] Keep working width separate from physical occupancy.
- [x] Validate runtime capability inventory for Condor and Patriot.
- [x] Confirm both Entities remained `coverage=NONE`, `confidence=UNKNOWN` with zero bounded evidence.
- [x] Confirm the probe never substituted 36 m working-marker width for physical geometry.
- [x] Close the adjacent-lane clearance stage as unexecutable under the tested source because no envelope existed.
- [x] Defer folded/unfolded validation because Stage 1 discovered no usable source.
- [x] Record Runtime Geometry Access Gap and reject the tested Direct Geometry Retrieval route.
- [x] Decide that the discovered evidence is insufficient for current field containment.

### Prototype 08 — Collision Node Pose and Model-Derived Catalogue

- [x] Extract Condor physical collision identities, mappings and configuration membership.
- [x] Generate source-fingerprinted 08B catalogue and endpoint origin predictions.
- [x] Expose and correct the Diagnostic Enumeration Blind Spot through explicit dual-source enumeration.
- [x] Resolve all eight active 36 m collision nodes through I3D mappings.
- [x] Validate one persistent `FOLDED -> TRANSITION -> DEPLOYED` lifecycle in TS001.
- [x] Validate continuous lateral origin-span growth from approximately 2.8237 m to 30.2403 m.
- [x] Establish live runtime transforms as authoritative pose evidence.
- [x] Restrict offline endpoint reconstruction to diagnostic status because full per-node comparison remained approximate.
- [x] Record Condor's Segmented Tapered Occupancy observation with an explicit model-specific caution.

### Prototype 09 — Runtime Shape-Bound Evidence

- [x] Discover the untested runtime shape-sphere API family.
- [x] Resolve stable component-local spheres for all eight active 36 m boom collision nodes.
- [x] Validate `usesGeometry=true` and local-to-world coherence through a full fold lifecycle.
- [x] Record Component-Local Sphere Bridge, Extent Truth–Utility Separation and Sphere Precision Tax.

### Prototype 10 — Physical Shape Coverage

- [x] Expand the source catalogue to all 29 physical `compoundChild` identities.
- [x] Test `vehicle.rootNode + source asset shapeId` descendant selection.
- [x] Disprove the route through repeated root-Entity sphere aliasing.
- [x] Record Self-Coherence Blind Spot and Source-to-Runtime Shape Resolution.

### Prototype 11 — Runtime Geometry Selector Semantics

- [x] Determine that the runtime Entity first argument owns geometry selection.
- [x] Compare zero, own, sibling and invalid second arguments across all eight resolved boom nodes.
- [x] Confirm cross-Entity geometry differentiation independently of self-coherence.
- [x] Confirm vehicle-root known-ID aliasing and selector stability through articulation.

### Prototype 12 — Physical Assembly Discovery

- [x] Validate an integrated single-member assembly with Condor.
- [x] Validate attached multi-member assemblies with two different tractor–cultivator combinations.
- [x] Confirm distinct per-member asset identities and runtime roots.
- [x] Confirm coherent attachment edges through unfolding and work observation.
- [x] Replicate the attached structure across different manufacturers and runtime hierarchies.
- [x] Use continuous motion evidence to distinguish declared AI state from demonstrated progress.
- [x] Record Working-State Motion Divergence without inventing a cause.

### Prototype 13 — Member-Local Runtime Identity Resolution

**Status:** discussion gate; not implemented.

Test whether configuration-aware source collision identities can be connected to distinct runtime Entities inside materially different assembly-member structures while preserving unresolved identities and alias evidence.

Candidate fixtures:

- Condor: repeated-family resolution and completion of the known current physical catalogue;
- Tiger or TopDown: contrast between multi-component and internally articulated single-component hierarchy routes.

Prototype 13 must distinguish exact identity resolution from fallback Physical Representation construction. It may collect the evidence needed for later Coverage Closure, but must not introduce aggregate occupancy, containment, sweep prediction or Control.

### After member-local resolution

- [ ] Extract or derive sufficiently precise local extents for chassis and active collision shapes.
- [ ] Derive and validate the current compound Physical Occupancy Envelope.
- [ ] Validate assembly-level occupancy across integrated and attached equipment.
- [ ] Generalise further only after additional materially different equipment structures are observed.

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

