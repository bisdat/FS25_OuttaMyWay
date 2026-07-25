# Changelog

## v4.6.10 — Prototype 08: Collision Node Pose and Model-Derived Catalogue

- Supersedes archival noncanonical v4.6.9, whose TS001 run exposed a Diagnostic Enumeration Blind Spot: the probe inspected only an empty `g_currentMission.vehicles` collection.
- Enumerates both `g_currentMission.vehicles` and `g_currentMission.vehicleSystem.vehicles`, deduplicates by root Entity, logs source counts and emits an explicit no-match warning.

- Named Configuration–Pose Separation, Save-State Geometry Bridge and Collision Mesh Extraction Gap.
- Split geometry reconstruction into Prototype 08A live collision-node pose observation and Prototype 08B offline model-derived catalogue extraction.
- Added an asset-fingerprinted extractor for vehicle XML, I3D hierarchy, collision filters, configuration membership and fold-animation endpoint prediction without distributing GIANTS assets.
- Generated a Condor 36 m catalogue containing 29 physical compound-child shapes, the eight active boom collision nodes, all eight I3D mapping paths and explicit unresolved mesh extents.
- Added a runtime Condor pose probe that resolves the eight named collision nodes, records root-local origins and axes, follows `foldAnimTime`, and compares live poses with offline folded/deployed predictions.
- Uses TS001 and TS003 as a controlled same-Entity folded/deployed pair; TS001 is the primary live transition fixture.
- Disables the expensive completed Prototype 07 hierarchy-bound scan while retaining its canonical negative evidence.
- Preserves No Silent Under-Approximation: collision-node origins are not collision-mesh bounds, working width is never substituted, and no Physical Occupancy Envelope is claimed.
- Traffic Manager v2 remains disabled; no containment, projected sweep, Decision, Commitment, hold, release or vehicle-control behaviour is introduced.
- Candidate implementation completed in observer-only mode; accepted validation evidence follows.
- Corrected enumeration observed `missionVehicles=0`, `vehicleSystemVehicles=54`, `uniqueRoots=53` and `condorCandidates=1`; Condor attached once and no no-match warning occurred.
- All eight configured 36 m boom collision nodes resolved once through I3D mappings and retained one Entity identity throughout the run.
- TS001 produced one complete `FOLDED -> TRANSITION -> DEPLOYED` lifecycle: `foldAnimTime=1.0000` at `t=0.1s`, transition from `t=8.3s`, and stable deployment at `foldAnimTime=0.0000` from `t=25.4s`.
- The live collision-node origin span changed continuously from approximately 2.8237 m folded to 30.2403 m deployed, strongly supporting runtime collision-node pose reconstruction.
- Prototype 08B correctly predicted the folded and deployed lateral origin spans and retained exact collision identity/configuration membership, but complete per-node endpoint reconstruction remained approximate: the folded `Col04` longitudinal prediction was materially wrong and stable deployed RMS error remained approximately 0.55 m.
- The accepted reconstruction boundary is therefore static catalogue identity and future local mesh extents plus authoritative live runtime node transforms; offline animation pose is diagnostic, not authoritative.
- Condor's four boom segments per side appear progressively thinner toward the tips, supporting Segmented Tapered Occupancy for this model. This observation must not be generalised: other foldable implements may use different segmentation, proportions, activation or articulation.
- Binary `.i3d.shapes` collision-mesh extents remain unresolved, so no Physical Occupancy Envelope, containment, projected sweep or Control claim is made.
- The repository owner reviewed and tested the exact v4.6.10 candidate and explicitly declared v4.6.10 canonical.

## v4.6.8 — Prototype 07: Physical Occupancy Evidence

- Named Geometry Domain Separation and Physical–Agronomic Separation: GIANTS collision geometry, Physical Occupancy Envelope and Working Footprint are distinct evidence domains.
- Added the No Silent Under-Approximation invariant: unknown or partial geometry must remain explicit and may not masquerade as exact physical occupancy.
- Added a passive GIANTS geometry capability inventory covering shape/local/world bounds, rigid-body evidence, collision masks and hierarchy traversal.
- Isolated geometry discovery/derivation in `scripts/geometry/PhysicalEnvelopeEvidence.lua` and lifecycle/logging in `scripts/prototypes/PhysicalOccupancyProbe.lua`.
- Aggregates the root vehicle and every attached or towed implement as one complete Entity.
- Derives a conservative current compound ground-plane envelope only from discovered bounded evidence and records provenance, coverage, confidence and frame stability.
- Logs AI marker working width and vehicle size metadata separately; neither substitutes for physical geometry.
- Adds pair diagnostics for physical-envelope clearance during known encounters such as adjacent-lane Condor/Patriot passes.
- Detects configuration or evidence changes in Entity-local envelope signatures while treating ordinary translation separately.
- Separates infrequent hierarchy inventory from frequent bound sampling to reduce diagnostic performance distortion.
- Adds the Prototype 07 hypothesis, staged validation contract and planned configuration-change fixture.
- Traffic Manager v2 remains disabled; no containment, projected sweep, safety padding, Decision, Commitment, hold, release or vehicle-control behaviour is introduced.
- Candidate implementation completed in observer-only mode; accepted validation evidence follows.
- TS003 exposed the tested runtime capability boundary: `getRigidBodyType=true`, while `getShapeBoundingBox`, `getBoundingBox`, `getWorldBoundingBox` and `getCollisionMask` were unavailable.
- Condor and Patriot each scanned 800 hierarchy nodes with truncation but produced zero bounded nodes, zero physics-bound nodes, `coverage=NONE`, `confidence=UNKNOWN` and no compound envelope.
- Across approximately 337 s, every Prototype 07 heartbeat retained two Entities but reported zero discovered envelopes and zero Entities with physics-bound evidence; no `NODE_EVIDENCE`, `PAIR_GEOMETRY` or `ENVELOPE_CHANGED` event could be produced.
- The probe correctly retained `workingMarkerWidth=36.00` as separate agronomic evidence and never substituted it for unknown physical geometry, satisfying No Silent Under-Approximation.
- Named the Runtime Geometry Access Gap: GIANTS uses physical collision geometry internally, but the tested Lua runtime boundary did not expose usable bounds for complete-Entity occupancy derivation.
- The final sweeping manoeuvre, near miss and observed reverse deadlock retained the relevant parked Entity but left current clearance and swept occupancy unknown, exposing Retained Entity, Missing Spatial Truth.
- Prototype 07 therefore disproves the tested Direct Geometry Retrieval route while preserving Physical Occupancy Envelope as an architectural requirement; alternative evidence sources must be investigated before containment mathematics or Control.
- The repository owner reviewed and tested the exact v4.6.8 candidate and explicitly declared v4.6.8 canonical.

## v4.6.7 — Prototype 06: Membership Transition Reclassification

- Corrected the Lua false-to-nil latching defect that caused repeated `OPERATIONAL_MEMBERSHIP_CHANGED` events for an unchanged non-operational vehicle.
- Added per-Entity classification revisions that advance only on attach or real Operational Membership/control-class change.
- Added relationship signatures containing source and target role/classification revisions.
- Added explicit `PROTOTYPE06 MEMBERSHIP_TRANSITION`, `RELATIONSHIP_RECLASSIFIED` and `RELATIONSHIP_REMOVED` evidence.
- Preserves one Field World identity while participant roles change and reclassifies relationships independently of geometric relevance changes.
- Retains TS002 as the pre-existing non-operational regression fixture and defines a planned TS003 live-completion fixture.
- Regenerates the release manifest from the clean owner-supplied v4.6.6 baseline, excluding transient local environments and caches.
- Traffic Manager v2 remains disabled; no Decision, Commitment, hold, release, containment or vehicle-control behaviour is introduced.
- Candidate implementation completed in observer-only mode; accepted validation evidence follows.
- TS002 passed as the negative control: Condor remained `NON_OPERATION_VEHICLE` from save load, produced no `PROTOTYPE06 MEMBERSHIP_TRANSITION`, `RELATIONSHIP_RECLASSIFIED` or `RELATIONSHIP_REMOVED` events, and still became `RELEVANT` during Patriot's terminal approach before the observed collision.
- Added TS003 as the repeatable live Operational Completion fixture after substantial setup to control GIANTS restart repositioning.
- At approximately `t=225.5s` in TS003, Condor completed while Patriot remained active; the probe emitted exactly one latched membership transition from `OPERATION_MEMBER` to `NON_OPERATION_VEHICLE`, exactly one relationship reclassification with `identityPreserved=true`, and one explicit retirement of the obsolete reverse directional relation.
- Condor retained the same Field World identity, no unchanged membership event repeated, and no OuttaMyWay Lua runtime error or vehicle-control action occurred.
- Several transient relevance and GIANTS blocked episodes cleared without deadlock; a blocked warning remains an operational symptom rather than proof of realised collision or deadlock.
- Prototype 06 therefore strongly supports latched Operational Membership transitions and role-aware relationship reclassification independently of geometric relevance change.
- The repository owner reviewed and tested the exact v4.6.7 candidate and explicitly declared v4.6.7 canonical.

## v4.6.6 — Prototype 05: Field World Observation

- Recovered and promoted Full-Envelope Field Containment: the complete vehicle–implement collision envelope, including projected swept geometry, remains wholly inside the field polygon at all times.
- Defined the field polygon as the bounded Field World for one Operation.
- Separated Field World Membership, Operational Membership and dynamic Situation Relevance.
- Added passive Prototype 05 vehicle observation across active, inactive, completed and player-controlled mission vehicles.
- Retains physically present vehicles after active GIANTS AI membership ends and records dynamic closest-approach relevance to active workers.
- Preserves GIANTS field-island counts and native static-collision signals as limited static-world evidence.
- Uses conservative current-envelope rectangles for diagnostics only; exact maximum collision geometry, projected sweep and containment control remain unimplemented.
- Added the parked-Patriot and completed-Condor TS001 validation procedure.
- Traffic Manager v2 remains disabled; no hold, release, Decision, Commitment, containment or vehicle-control behaviour is introduced.
- Variable TS001 runs confirmed that stopped or player-controlled Patriot and completed Condor remained Field World vehicle members after leaving active Operational Membership; manual timing and movement prevented a clean terminal regression result.
- Added TS002 as a repeatable pre-existing non-operational vehicle relevance fixture: completed Condor is parked, Patriot remains active and approaches the same finishing area without player intervention.
- In TS002, Condor was discovered at `t=6.2s` as `NON_OPERATION_VEHICLE` while Patriot was the sole `OPERATION_MEMBER`; the relation began `NOT_RELEVANT`, became `RELEVANT` at `t=241.7s`, and Patriot became blocked at `t=290.7s` in the observed collision.
- Prototype 05 therefore strongly supports independent Field World Membership, Operational Membership and dynamic Situation Relevance for vehicle members.
- The test also exposed repeated Operational Membership event logging, incomplete relationship reclassification after a live worker completes, and noisy provisional containment candidates; exact static-object identity and exact full-envelope geometry remain unresolved.
- The repository owner reviewed and tested the exact v4.6.6 candidate and explicitly declared v4.6.6 canonical.

## v4.6.5 — Prototype 04: Continuation Intent and Safe Release

- Added passive Prototype 04 instrumentation for Local Intent Horizon, Intent Expiry and retrospective next-manoeuvre release safety.
- Correlates Prototype 03 Progress Entity/hold-candidate evidence across worker detachment and reattachment without issuing control.
- Records local intent epochs, explicit expiry at a new manoeuvre, observed release timing, continuation manoeuvres and later conflict-positive evidence.
- Adds retrospective `SAFE_THROUGH_NEXT_MANOEUVRE` and `UNSAFE_THROUGH_NEXT_MANOEUVRE` outcomes within a deliberately limited Continuation Safety Horizon.
- Names Local Intent Horizon, Intent Expiry, Encounter Chain, Safe Release Point and Continuation Safety Horizon as Deferred concepts under test.
- Corrects Prototype 03 Startup Manoeuvre Contamination by requiring meaningful motion from both participants before opening a window.
- Corrects stale Prototype 03 `ACTIONABLE` evidence by expiring local intent when the Progress Entity begins a new manoeuvre.
- Latches Prototype 03 Alternate Exhaustion evidence so it is emitted once per completed window.
- Adds the Prototype 04 hypothesis, evidence contract and limited player stop/restart TS001 procedure.
- Traffic Manager v2 remains disabled; no hold, release, Decision, Commitment or vehicle-control behaviour is introduced.
- The limited TS001 run confirmed bounded local intent epochs and immediate Intent Expiry when Condor began a new manoeuvre or left active observation.
- Patriot was manually stopped at the candidate wait position and left active AI-worker observation; Condor later repositioned toward the physically parked Patriot and became blocked until the player moved Patriot.
- The original stopped position was therefore unsafe through a later repositioning, while the probe could not classify the encounter automatically because the parked non-worker was outside its observation scope.
- A later restart after manual relocation remained clear through the measured continuation but does not validate a Safe Release Point for the original hold site.
- Completed Condor later occupied the normal GIANTS finishing position and Patriot became blocked when it attempted to use the same location, exposing physical relevance beyond active Operational Membership.
- The repository owner reviewed and tested the exact v4.6.5 candidate and explicitly declared v4.6.5 canonical.

## v4.6.4 — Prototype 03: Option Preservation Window

- Added passive Prototype 03 instrumentation for manoeuvre ordering, Intent Revelation and provisional Response Margin.
- Named Candidate Option Preservation Window, Progress Entity, Alternate Exhaustion Point, Information-Gaining Delay, Observation Deadlock, Mutual Commitment Trap and the Progress Preservation Invariant as Deferred concepts under test.
- Recorded the invariant that an observation-enabling delay must preserve at least one participant able to generate completion evidence; Prototype 03 never represents holding all participants as valid.
- Added `CANDIDATE_OPEN`, `OBSERVING`, `ACTIONABLE`, `EXHAUSTED` and `CLOSED_SAFE` diagnostic states.
- Added provisional stopping-time, stopping-distance, manoeuvre-progress and response-time-margin evidence with every assumption exposed in the log.
- Published read-only Prototype 02 motion/confidence accessors for passive diagnostic reuse.
- Added the Prototype 03 hypothesis, evidence contract and unchanged TS001 procedure.
- Traffic Manager v2 remains disabled; no Decision, Commitment, hold or vehicle-control behaviour is introduced.
- The unchanged TS001 run produced an `ACTIONABLE` window approximately 12 s before conflict establishment and about 7.42 s of conservative temporal margin after the diagnostic stopping allowance and safety buffer.
- The player independently observed that Patriot still had time to wait after Condor became established in the lane; the Prototype 03 hypothesis is strongly supported.
- A manual stop/restart follow-up avoided the original head-on encounter but later produced a crossing conflict when Condor repositioned across Patriot's resumed path, disproving current-lane intent as sufficient safe-release evidence and reducing confidence in the simple alternating-lane model.
- Recorded Job Restart Perturbation, Startup Manoeuvre Contamination and Exhaustion Event Repetition as evidence and diagnostic constraints requiring later declared work.
- The repository owner reviewed and tested the exact v4.6.4 candidate and explicitly declared v4.6.4 canonical.

## v4.6.3 — Prototype 02: Conflict Confidence

- Added passive Prototype 02 instrumentation for Trajectory Settlement and conflict-persistence evidence.
- Named Conflict Formation Window and Sequential Manoeuvre Conflict from the first TS001 evidence without assigning fault to either worker.
- Added per-Entity heading/speed change rates, stable-motion duration and provisional settlement interpretation.
- Added pair-level conflict-positive persistence, dCPA spread, projected Conflict Zone drift and tCPA countdown-consistency evidence.
- Added provisional `CLEAR`, `FORMING`, `ESTABLISHED`, `DECAYING` and `CLEARED` diagnostic states with every threshold exposed in the log.
- Retained Prototype 01 and published only its side-effect-free kinematic helpers for diagnostic reuse.
- Added the Prototype 02 hypothesis, evidence contract, unchanged TS001 procedure and validation questions.
- Traffic Manager v2 remains disabled; no Decision, Commitment or vehicle-control behaviour is introduced.
- The unchanged TS001 run kept the earlier harmless head-on pass `CLEAR`, produced a meaningful `FORMING` interval, and reached `ESTABLISHED` at approximately 266.5 m separation, about 18.5 s before both workers became blocked.
- The player observed no further direction change after settlement and confirmed the final outcome remained a head-on collision.
- Disproved the provisional assumption that loss of future-trajectory evidence means resolution: after collision the probe reported `DECAYING` then `CLEARED` while both workers remained physically blocked.
- The repository owner reviewed and tested the exact v4.6.3 candidate and explicitly declared v4.6.3 canonical.

## v4.6.2 — Prototype 01: Conflict Emergence Point

- Added passive Prototype 01 instrumentation for the unchanged TS001 two-worker head-on encounter.
- Recorded position, heading, speed, separation, closing rate, closest-approach time/distance, projected conflict location and provisional stage transitions.
- Deferred Conflict Relevance Transition and Conflict Emergence Point pending in-game evidence.
- Discovered and corrected the Passive Boundary Ordering Gap: observer-only mode now returns before Traffic Manager v2 can decide or execute.
- Disabled Traffic Manager v2 explicitly and added a runtime passive-configuration check for the probe.
- Added the evidence contract, TS001 procedure, validation questions and searchable log prefixes.
- No avoidance response, Commitment change or positive vehicle-control action is introduced.
- First TS001 evidence distinguished harmless head-on proximity from an emerging projected conflict and recorded the Conflict Emergence Point at 318.38 m separation with 29.66 s projected time to closest approach.
- The repository owner reviewed and tested the exact v4.6.2 candidate and explicitly declared v4.6.2 canonical.

## v4.6.1 — Repository Release System Consolidation Candidate

- Accepted D-RRS-24 (Engineering Intent Boundary), D-RRS-25 (Fingerprint-Bound Engineering Intent) and D-RRS-26 (Candidate Determinism and Evidence Provenance).
- Promoted Engineering Intent, Canonical Repository Snapshot, Repository Transformation and Candidate Determinism into authoritative architecture and vocabulary.
- Recorded the first complete local RRS evolution, fingerprint-block, regenerated-handoff, owner-review, Canonicalisation and Git-synchronisation cycle.
- Disproved the assumption that fixed timestamps and permissions alone guaranteed cross-platform package determinism; named the Artifact Determinism Gap.
- Implemented one relative POSIX-path ordering rule for inventory, manifest and package generation, explicit ZIP origin/permission metadata, and stored entries independent of host compression libraries.
- Added focused regression tests for mixed-case path ordering, creation-order independence and ZIP metadata.
- Documented post-Canonicalisation Git alignment and clarified that Git working state is distinct from repository authority state.
- Clarified that documents use the ordering natural to their human-reading purpose; no global sorting rule applies.
- Recorded dirty-working-tree awareness and the remaining RRS assurance boundaries as deferred follow-up.
- No intentional vehicle-control behaviour changes.

## v4.6.0 — Repository Release System Recovery

- Recorded D-RRS-01 through D-RRS-23 as the accepted Repository Release System decision set.
- Promoted the RRS lifecycle, authority states, roles, gates, transformations and evidence responsibilities into authoritative repository knowledge homes.
- Registered the RRS architecture and operational documentation in repository policy and navigation.
- Documented the recovered candidate-production implementation boundary and its deferred Authority Transformation work.
- No intentional vehicle-control behaviour changes.

## v4.5.9
- Seminar Series 4 repository mining.
- Decision Engine refined as continuous commitment evaluator.
- Adopted Least Intervention and Grace as architectural quality attributes.
- Introduced Architectural Prototyping as next project phase.

- Repository mining from Seminar 06.
- Refined Operational Picture as coherent operational understanding.
- Clarified Continuous Operation vs Temporary Augmentation.
- Decision Engine identified as consumer of Operational Picture.
- Recorded architectural governance that ADRs may be refined/superseded by evidence.

## v4.5.6 — Seminar Knowledge Distribution Release

- Classified Seminar 01–06 outputs across the Concept Register, Decision Log, Glossary, Project Status and Handover.
- Accepted Situation Space, Current Situation, Future Space and Action Space; clarified Situation Assessment as a transformation.
- Distinguished Reality from Knowledge and recorded Time as the architectural evolution dimension.
- Retained Conflict Zone as a derived operational concept, explicitly rejected Conditions, and deferred Entity and Operational Picture terminology.
- Recorded the process discovery that seminar mining must distribute knowledge by ownership and lifecycle.
- No intentional vehicle-control behaviour changes.

## v4.5.4 — Governance Recovery and Architectural Seminar Release

- Reconstructed the release from the last verified v4.5.3 canonical baseline and preserved Chat 04 governance findings plus the complete Chat 05 seminar series.
- Added Repository Review, Repository Completion Patch, independent packaged-release Repository Identity Check and evidence-based recovery rules.
- Expanded Engineering Continuity into Navigation, Prediction and Overall Assessment.
- Recorded deferred repository numbering and Operational Picture/Current Situation review, rejected Conditions, and preserved the evolution from Conflict Zone through Future Space, Action Space, Situation Space, Reality/Knowledge and Time.
- No intentional vehicle-control behaviour changes.

## v4.5.3 — Repository Identity and Compatibility Cleanup

- Restored one canonical v4.5.3 identity across runtime metadata, package entry points, current-state documents and tooling examples.
- Distinguished current release identity from historical version records so changelogs, decisions and archived lifecycle statements retain their original versions.
- Removed expired root-level compatibility signposts and retained the superseded documents solely under `docs/archive/compatibility/`.
- Populated `DOCUMENTATION_STANDARD.md` and enforced the canonical `OuttaMyWay` name and project-free document titles.
- Strengthened release preparation and verification so stale current-version examples and compatibility signposts fail validation.
- No intentional vehicle-control behaviour changes.

## 4.5.1 — Repository Governance Release

- Added explicit document authority, currency and lifecycle governance.
- Added `PROJECT_CONTINUITY.md` and the Engineering Continuity Test.
- Added the rule that every repository modification begins from a supplied current canonical baseline.
- Completed the documentation map and breadcrumb journey.
- Renamed `Engineering_Handbook.md` to `ENGINEERING_HANDBOOK.md` and replaced stale version metadata with currency metadata.
- Archived superseded engineering documents under `docs/archive/compatibility/` while retaining old-path signposts.
- Extended repository verification to check documentation coverage, filename casing, compatibility/archive placement and stale version declarations.
- No intentional vehicle-control behaviour changes.

## v4.5.0

- Established the development repository as an explicit engineering knowledge system optimised first for seamless continuation across chats and sessions, and second for future contributor comprehension.
- Added `ENGINEERING_ARCHITECTURE.md`, `CONCEPT_REGISTER.md`, `DECISION_LOG.md`, `ENGINEERING_JOURNAL.md` and `tools/README.md`.
- Made current status, continuation guidance, concept governance, decisions, discoveries, history and tooling separate repository responsibilities.
- Added `verify_repository.py` and integrated repository-coherence checks into the release pipeline.
- Reviewed the architectural concept registers: Conflict Zone, Situation Assessment and Commitment remain Accepted; Opportunity remains Deferred; no concepts are Rejected.
- Consolidated overlapping engineering method and workflow authority under `ENGINEERING_ARCHITECTURE.md` while retaining compatibility pointers.
- No intentional vehicle-control behaviour changes.

## v4.4.1

- Accepted Commitment as a first-class architectural concept with creation, maintenance, completion and cancellation lifecycle semantics.
- Deferred Opportunity pending evidence of an independent lifecycle or responsibility.
- Added recurring review of Accepted, Deferred and Rejected concept registers at each canonical repository update.
- Strengthened the release pipeline so both changelogs must contain the target release heading before packaging.
- Reconciled all embedded version records after the incomplete v4.4.0 packaging attempt.
- No intentional vehicle-control behaviour changes.

## v4.3.9

- Established Situation Assessment as the sole interpreter of observations and the single source of operational truth.
- Routed Control and Recovery outcomes back as Outcome Observations through Situation Assessment before further decisions.
- Added Project Vision, Autonomous Continuity and the Trust Test.
- Added the Architectural Discovery Method and Ownership Test.
- Preserved the unnamed Decision output as an open architectural hypothesis; Remedy and Variance remain candidates.
- Added automated release preparation, version audit and manifest generation tooling.
- No intentional vehicle-control behaviour changes.

## v4.3.8

- Completed Situation Assessment architecture.
- Added Decision Readiness.
- Added Decision-Relevant World.
- Added Decision-Relevant Constraints.
- Added Relevance Envelope.
- Added Option Horizon.
- Clarified the Situation Assessment ↔ Decision Engine boundary.

# Changelog

## 4.3.7 — Situation Assessment Architecture

- Completed first-pass architecture for Situation Assessment.
- Adopted explanation-based assessment rather than state-based assessment.
- Established projected interaction as the trigger for Local Situations.
- Clarified OuttaMyWay scope excludes cooperative vehicle coordination.


## 4.3.6 — Baseline Integrity and Handover

- Reconciled package, mod descriptor, runtime configuration and project-status version records.
- Added `ENGINEERING_HANDOVER.md` as the canonical start-of-session record.
- Expanded `PROJECT_STATUS.md` with the proven architecture, known constraints and immediate Milestone 3 objective.
- Added handover/status links to the documentation landing page.
- Regenerated the release manifest to cover the complete current repository.
- No intentional traffic-control, prediction, execution or recovery behaviour changes.

## 4.3.1 — Documentation Baseline Refinement

- Rebuilt the Engineering Handbook as structured GitHub-flavoured Markdown.
- Added a navigable table of contents and consistent chapter/section hierarchy.
- Added Chapter 16, “The Weight of Chains and the Springboard of Memory.”
- Moved collaborative drafting notes into an appendix.
- Added a documentation landing page and assets directory.
- Extracted ADR-0001 into `/docs/adr/`.
- Added cross-links between the handbook and ADRs.
- Established the standing release rule: every document, code or package change requires a version increment and a newly shared complete package.


## 4.2.6.3 — Diagnostics syntax repair

- Corrected malformed closing parentheses in TrafficExecutorV2 and RecoveryHandoff logger calls.
- Updated runtime and mod metadata to 4.2.6.3.
- No intentional decision, control, or recovery behaviour changes.

## 4.2.6.0 — Architectural diagnostics framework

- Added a central diagnostics logger using `[OuttaMyWay][CATEGORY]` prefixes.
- Added INFO, OBS, DEC, CTL, VAL, REC and PERF categories with debug-level filtering.
- Instrumented Observer, DecisionEngine, TrafficExecutorV2, RecoveryHandoff and Runtime entry points without intentional behaviour changes.
- Added self-contained architectural log messages and retained existing control decisions.
- Set the development diagnostic level to 3 for the first Milestone 2 evidence run.

## 4.2.5.4

- Replaced the ineffective downstream drive hook with a narrow overwrite of `getCanAIFieldWorkerContinueWork`.
- The overwrite is installed only on vehicles actually selected for a Traffic Manager hold.
- Existing GIANTS and third-party refusal results are respected by calling the previous function first.
- An OuttaMyWay hold returns `false, false, nil`, preventing movement without ending or regenerating the AI job.
- Added permission-gate call and progress diagnostics.

## 4.2.5.3

- Added an execution microscope around Traffic Manager v2 HOLD.
- Logs worker, native strategy, wait ownership, drive-hook state, and repeated post-apply probes.
- Logs the actual AI `driveToPoint` interception input and forced zero-speed output.
- No decision or avoidance logic changes.

## 4.2.5.2

- Enabled the first live Traffic Manager v2 executor experiment.
- Applies only a lightweight predictive course wait; never folds, reverses, steers or restarts AI.
- Holds are committed for at least 3 seconds and capped at 15 seconds.
- Releases on confirmed geometric clearance, native blockage, inactive AI, lost ownership or safety timeout.
- Decision and execution remain separate modules.

## 4.2.5.1

- Fixed the runaway exception caused by a local `pairs` table shadowing Lua's global `pairs()` iterator.
- Split Traffic Manager v2 into a pure decision engine and an explicit executor.
- Executor is dry-run only and cannot modify AI, vehicles, implements or waiting state.
- Logs `TRAFFIC V2 WOULD HOLD` once per changed recommendation for TS001 validation.

# Changelog

## 4.2.5.0 — Traffic Manager v2 control-path prototype

- Added the first live consumer of Observer and Conflict Predictor state.
- Starts a four-second, non-folding HOLD only for high-confidence CRITICAL pairs where both workers are straight, working and unblocked.
- Uses current-segment progress as a deterministic prototype right-of-way rule: the worker less advanced through its current commitment yields.
- Releases on timeout, clear prediction, inactive worker or native blocked state.
- No reversing, steering, implement control, recovery or AI restart is enabled.
- This build proves the architecture can intervene; a hold alone is not expected to resolve TS001 once both workers are already head-on in the same lane.

## 4.2.4.0 - Diagnostic conflict prediction

- Added a read-only Conflict Predictor consumer for active Interaction Contexts.
- Calculates current separation, closing rate, constant-velocity time to closest approach and closest distance.
- Adds heading difference and reciprocal lateral-offset diagnostics for same-lane and crossing analysis.
- Classifies pair observations as CLEAR, WATCH, POTENTIAL or CRITICAL with explicit confidence context.
- Emits `conflictPredictionChanged` events but performs no vehicle control.

## 4.2.3.0 - Persistent interaction contexts

- Replaced short-lived interaction groups with persistent ACTIVE/DORMANT contexts.
- Context IDs survive temporary separation and normal headland manoeuvres.
- Added first-seen, last-active, cumulative-active and encounter-count diagnostics.
- Added a 60-second dormant-context retention window.
- Removed the resolved active-discovery-miss count from the Observer heartbeat.
- No vehicle-control behaviour is enabled.

## 4.2.2.0

- Added two-stage diagnostic locality: candidate pairs are tracked before promotion into interaction groups.
- Added Observer-relative timestamps throughout interaction diagnostics.
- Added candidate and group hysteresis to prevent headland-turn churn.
- Added advisory straight-line field-continuity sampling with PASS, FAIL, or UNKNOWN outcomes.
- Field continuity is never treated as proof and performs no vehicle control.

## 4.2.1.0

- Added a central synchronous EventBus for global read-only Observer facts.
- Observer now emits per-sample `workerObserved` facts plus explicit phase, turn and blocked transitions.
- Added diagnostic-only Interaction Groups based on proximity and observed closing behaviour.
- Interaction grouping deliberately ignores field IDs and performs no vehicle control.
- Added group create, dissolve and heartbeat diagnostics for multi-field testing.

## 4.2.0.2

- Restored the exact field-course strategy discovery order proven by the v4.1.3 Explorer.
- Enumerates `mission.vehicles` and `mission.vehicleSystem.vehicles` additively with de-duplication.
- Added heartbeat counts for scanned vehicles, source tables, field courses and discovery misses.
- Observer remains read-only; no traffic or recovery control is enabled.

## 4.2.0.1

- Fixed Observer worker discovery by adding field-work activity fallback and robust nested strategy discovery.
- Heartbeat now reports active flags, discovered strategies, and observed states separately.

# 4.1.3.0

- Added observer-only steering-target phase detection: TURN_START, TURN_APEX and TURN_COMPLETE.
- Added a four-second rolling target history and short projected steering endpoint to phase events.
- Preserved all existing pair, progress and native-state diagnostics.
- Added optional single-worker obstruction recovery to the long-term roadmap; no recovery behaviour is active.

## 4.1.2.0 - Native transition and pair correlation

- Adds vehicle heading and steering-target relative bearing to native state transitions.
- Uses 5% progress milestones on turn segments and 10% milestones on work segments.
- Adds observer-only pair distance and closing-rate events below 100 metres.
- Correlates pair proximity with each worker's native turn flag, progress, segment length and blocked state.
- No HUD or vehicle-control changes.

## 4.1.1.0 - AIFieldCourse transition timeline

- Replaced repetitive five-second per-worker snapshots with transition-only diagnostics.
- Separates structural native state changes, 10% course-progress milestones, and 15-degree steering-target changes.
- Adds compact timestamps to correlate native cursor changes with vehicle motion.
- Retains a single 15-second global scan heartbeat.
- Observer-only: no traffic-control, steering, speed, implement or AI-job changes.

# 4.1.0.2

- Fixed immediate AIFieldCourse Explorer exception when a strategy exposes `class` as a function rather than a class table.
- Added a strict type guard before reading `class.className`.
- Observer-only behaviour unchanged.

# 4.1.0.1

- Fixed Explorer scans on sparse mission vehicle tables.
- Discover strategies before applying activity filters.
- Added startup and five-second scan heartbeat diagnostics.
- Added separate field-worker and generic AI activity flags.

# 4.1.0.0

- Added diagnostic-only `AIFieldCourseExplorer`.
- Logs all return slots from native `getActiveSegmentData()` and `getNextSegmentData()`.
- Logs native side-offset and corner-cut-out state.
- Correlates native cursor data with the field-course strategy's actual last drive target.
- Reports only on state changes plus a five-second heartbeat.
- Disabled all OuttaMyWay traffic control while explorer mode is active.

## 4.0.1.1

- Lowered predictive course-HOLD entry confidence to 0.70.
- Added 0.45 release hysteresis to prevent hold/release chatter.
- Added a five-second minimum committed hold before reassessment.
- Retained the ten-second safety cap and all existing reactive authority.

# Changelog

## 4.0.1.0

- Added the first live Traffic Manager action: high-confidence predictive brief HOLD.
- Added active-segment scoring and hysteresis using course geometry, segment length and turn state.
- Predictive holds bypass passage assist and never fold, raise, reverse or restart implements.
- Existing reactive and encounter systems remain authoritative safety fallbacks.
- Completion priority remains diagnostic-only.

## 4.0.0.2 — Maintenance baseline

- Added design, architecture, roadmap, known-issues, performance and localisation documentation.
- Defined first-release `1.0.0.0` policy for GIANTS ModHub.
- Defined five mandatory release languages: English, German, French, Spanish and Italian.
- Documented limited multiplayer verification policy.
- Recorded 4.0 active-segment/ETA instability as a blocker before live course-based control.
- No vehicle-control behaviour changes.

## 4.0.0.1

- Fixed nil comparison during initial course acquisition.

## 4.0.0.0

- Added course-relative future-corridor and completion-priority diagnostics.

## 4.2.0.1
- Added central read-only Observer subsystem.
- Added NativeAI adapter as the sole intended GIANTS AI access layer.
- Added normalised WorkerState model with actual/requested speed ratio.
- Added observer event subscription interface.
- Disabled the legacy Explorer by default while retaining it for reference.
- No vehicle control behaviour is enabled.

## 4.2.5.5 — Manual handoff boundary experiment

- Added a diagnostic Recovery Handoff observer.
- Native blockage or automated-hold timeout now closes the current automated episode and hands ownership to the player.
- The Observer continues running and records meaningful player/external changes.
- Immediate recreation of the same incident is suppressed until vehicle position or AI state changes materially.
- No automated backout, steering, folding, restart, or recovery manoeuvre is added in this build.
