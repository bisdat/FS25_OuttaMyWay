-- FS25_OuttaMyWay v4.6.50 architecture recovery candidate build.
-- Cooperative collision avoidance for base-game AI field workers.

OuttaMyWay = {}
OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"
OuttaMyWay.VERSION = "4.6.50"
OuttaMyWay.BLOCKED_FOLD_DELAY_MS = 6500
OuttaMyWay.WAIT_FOLD_DELAY_MS = 4500
OuttaMyWay.HEAD_ON_FOLLOW_HOLD_DISTANCE = 55.0
OuttaMyWay.HEAD_ON_FOLLOW_RELEASE_DISTANCE = 65.0

OuttaMyWay.UPDATE_INTERVAL_MS = 100
OuttaMyWay.CONFLICT_DISTANCE = 40.0
OuttaMyWay.HARD_STOP_DISTANCE = 20.0
OuttaMyWay.RELEASE_DISTANCE = 46.0
OuttaMyWay.PREDICTION_SECONDS = 7.0
OuttaMyWay.PREDICTED_CLEARANCE = 9.0
OuttaMyWay.MIN_WAIT_MS = 1200
OuttaMyWay.RELEASE_CONFIRM_MS = 700
OuttaMyWay.MESSAGE_DURATION_MS = 2200
OuttaMyWay.DEBUG_INTERVAL_MS = 5000

-- Architectural diagnostics level: 0 errors, 1 lifecycle/recovery,
-- 2 decisions/validation, 3 observations/control, 4 performance/everything.
OuttaMyWay.DEBUG_LEVEL = 3

-- v4.1 native AIFieldCourse investigation. While enabled, OuttaMyWay is an
-- observer only: no holds, recovery, folding, reversing or AI restart actions.
OuttaMyWay.AI_EXPLORER_ONLY = false
OuttaMyWay.AI_EXPLORER_ENABLED = false
OuttaMyWay.OBSERVER_INTERVAL_MS = 250
OuttaMyWay.OBSERVER_HEARTBEAT_MS = 15000
OuttaMyWay.INTERACTION_GROUP_INTERVAL_MS = 500
OuttaMyWay.INTERACTION_CONTEXT_INTERVAL_MS = 500
OuttaMyWay.INTERACTION_GROUP_HEARTBEAT_MS = 15000
OuttaMyWay.INTERACTION_CONTEXT_HEARTBEAT_MS = 15000
OuttaMyWay.INTERACTION_CONTEXT_RETENTION_S = 60.0
OuttaMyWay.INTERACTION_CANDIDATE_RADIUS = 180.0
OuttaMyWay.INTERACTION_GROUP_RADIUS = 120.0
OuttaMyWay.INTERACTION_GROUP_ALWAYS_LINK_RADIUS = 45.0
OuttaMyWay.INTERACTION_GROUP_PROMOTE_CLOSING_RATE = 0.10
OuttaMyWay.INTERACTION_GROUP_SLOW_SPEED_KMH = 1.0
OuttaMyWay.INTERACTION_CANDIDATE_DROP_GRACE_S = 10.0
OuttaMyWay.INTERACTION_GROUP_DISSOLVE_GRACE_S = 8.0
OuttaMyWay.INTERACTION_CONTINUITY_SAMPLES = 12
OuttaMyWay.INTERACTION_CONTINUITY_PASS_RATIO = 0.85
OuttaMyWay.INTERACTION_CONTINUITY_FAIL_RATIO = 0.50
OuttaMyWay.CONFLICT_PREDICTOR_INTERVAL_MS = 500
OuttaMyWay.CONFLICT_PREDICTOR_HEARTBEAT_MS = 15000
OuttaMyWay.CONFLICT_PREDICTOR_HORIZON_S = 30.0
OuttaMyWay.CONFLICT_PREDICTOR_WATCH_DISTANCE_M = 28.0
OuttaMyWay.CONFLICT_PREDICTOR_POTENTIAL_DISTANCE_M = 14.0
OuttaMyWay.CONFLICT_PREDICTOR_POTENTIAL_TIME_S = 22.0
OuttaMyWay.CONFLICT_PREDICTOR_CRITICAL_DISTANCE_M = 7.0
OuttaMyWay.CONFLICT_PREDICTOR_CRITICAL_TIME_S = 10.0
OuttaMyWay.CONFLICT_PREDICTOR_ACTIVE_LOG_INTERVAL_S = 3.0
OuttaMyWay.CONFLICT_PREDICTOR_RETENTION_S = 15.0

-- Prototype 01: retained passive Conflict Emergence Point evidence capture.
-- Detectability is supported; its thresholds and stage labels remain provisional.
OuttaMyWay.PROTOTYPE_01_ENABLED = true
OuttaMyWay.PROTOTYPE_01_INTERVAL_MS = 500
OuttaMyWay.PROTOTYPE_01_LOG_INTERVAL_MS = 2000
OuttaMyWay.PROTOTYPE_01_HEARTBEAT_MS = 15000
OuttaMyWay.PROTOTYPE_01_OBSERVATION_RADIUS_M = 300.0
OuttaMyWay.PROTOTYPE_01_HORIZON_S = 60.0
OuttaMyWay.PROTOTYPE_01_MIN_CLOSING_RATE_MPS = 0.10
OuttaMyWay.PROTOTYPE_01_RELEVANCE_CLEARANCE_M = 14.0
OuttaMyWay.PROTOTYPE_01_RELEVANCE_TIME_S = 30.0
OuttaMyWay.PROTOTYPE_01_IMMEDIATE_CLEARANCE_M = 7.0
OuttaMyWay.PROTOTYPE_01_IMMEDIATE_TIME_S = 10.0
OuttaMyWay.PROTOTYPE_01_LOW_SPEED_KMH = 0.75
OuttaMyWay.PROTOTYPE_01_HEAD_ON_MIN_DEG = 150.0
OuttaMyWay.PROTOTYPE_01_SAME_DIRECTION_MAX_DEG = 30.0

-- Prototype 02: passive evidence capture for Trajectory Settlement and Conflict
-- Confidence. These thresholds are provisional interpretations and are emitted
-- in the log so the TS001 run can validate or disprove them.
OuttaMyWay.PROTOTYPE_02_ENABLED = true
OuttaMyWay.PROTOTYPE_02_INTERVAL_MS = 500
OuttaMyWay.PROTOTYPE_02_LOG_INTERVAL_MS = 2000
OuttaMyWay.PROTOTYPE_02_HEARTBEAT_MS = 15000
OuttaMyWay.PROTOTYPE_02_MIN_SPEED_KMH = 0.75
OuttaMyWay.PROTOTYPE_02_MIN_CLOSING_RATE_MPS = 0.10
OuttaMyWay.PROTOTYPE_02_CONFLICT_CLEARANCE_M = 14.0
OuttaMyWay.PROTOTYPE_02_CONFLICT_TIME_S = 30.0
OuttaMyWay.PROTOTYPE_02_MAX_HEADING_RATE_DEG_S = 4.0
OuttaMyWay.PROTOTYPE_02_MAX_SPEED_RATE_KMH_S = 2.0
OuttaMyWay.PROTOTYPE_02_SETTLEMENT_DURATION_S = 2.0
OuttaMyWay.PROTOTYPE_02_PERSISTENCE_DURATION_S = 2.0
OuttaMyWay.PROTOTYPE_02_WINDOW_S = 3.0
OuttaMyWay.PROTOTYPE_02_MAX_DCPA_SPREAD_M = 5.0
OuttaMyWay.PROTOTYPE_02_MAX_ZONE_DRIFT_MPS = 2.0
OuttaMyWay.PROTOTYPE_02_MAX_TCPA_COUNTDOWN_ERROR_S = 1.5
OuttaMyWay.PROTOTYPE_02_CLEAR_DURATION_S = 2.0
OuttaMyWay.PROTOTYPE_02_OUTCOME_LOW_SPEED_KMH = 0.75

-- Prototype 03: passive evidence capture for a Candidate Option Preservation
-- Window. It observes manoeuvre ordering, Progress Entity viability, Intent
-- Revelation and provisional Response Margin. It never issues a hold.
OuttaMyWay.PROTOTYPE_03_ENABLED = false
OuttaMyWay.PROTOTYPE_03_INTERVAL_MS = 250
OuttaMyWay.PROTOTYPE_03_LOG_INTERVAL_MS = 1000
OuttaMyWay.PROTOTYPE_03_HEARTBEAT_MS = 15000
OuttaMyWay.PROTOTYPE_03_OBSERVATION_RADIUS_M = 500.0
OuttaMyWay.PROTOTYPE_03_MIN_MANOEUVRE_LEAD_S = 0.5
OuttaMyWay.PROTOTYPE_03_OBSERVING_CONFIRM_S = 0.5
OuttaMyWay.PROTOTYPE_03_SAFE_CLOSE_DURATION_S = 2.0
OuttaMyWay.PROTOTYPE_03_ASSUMED_DECELERATION_MPS2 = 2.0
OuttaMyWay.PROTOTYPE_03_REACTION_TIME_S = 0.5
OuttaMyWay.PROTOTYPE_03_RESPONSE_SAFETY_BUFFER_S = 2.0
OuttaMyWay.PROTOTYPE_03_COMPLETED_RETENTION_MS = 5000
OuttaMyWay.PROTOTYPE_03_MIN_OPERATIONAL_SPEED_KMH = 2.0

-- Prototype 04: passive evidence capture for Local Intent Horizon, Intent
-- Expiry and retrospective Safe Release assessment through the Progress
-- Entity's next repositioning event. It never issues a hold or release.
OuttaMyWay.PROTOTYPE_04_ENABLED = false
OuttaMyWay.PROTOTYPE_04_INTERVAL_MS = 250
OuttaMyWay.PROTOTYPE_04_LOG_INTERVAL_MS = 1000
OuttaMyWay.PROTOTYPE_04_HEARTBEAT_MS = 15000
OuttaMyWay.PROTOTYPE_04_MIN_OPERATIONAL_SPEED_KMH = 2.0
OuttaMyWay.PROTOTYPE_04_SAFE_CONFIRM_S = 3.0
OuttaMyWay.PROTOTYPE_04_TRIAL_RETENTION_S = 120.0

-- Prototype 05: passive Field World vehicle observation. The field polygon
-- bounds one Operation's world. Vehicle membership is retained independently
-- of active AI membership; relevance is interpreted dynamically. Current
-- envelope rectangles are conservative diagnostics only and issue no control.
OuttaMyWay.PROTOTYPE_05_ENABLED = true
OuttaMyWay.PROTOTYPE_05_INTERVAL_MS = 250
OuttaMyWay.PROTOTYPE_05_HEARTBEAT_MS = 15000
OuttaMyWay.PROTOTYPE_05_RELEVANCE_HORIZON_S = 45.0
OuttaMyWay.PROTOTYPE_05_RELEVANCE_MARGIN_M = 5.0
OuttaMyWay.PROTOTYPE_05_CONTAINMENT_LOG_MS = 3000

-- Prototype 06: passive evidence for latched Operational Membership transitions
-- and relationship reclassification when a retained Field World Member changes
-- role or control class. It adds no control behaviour.
OuttaMyWay.PROTOTYPE_06_ENABLED = true

-- Prototype 07: passive evidence discovery for GIANTS collision/physics geometry,
-- complete-Entity aggregation and a conservative current Physical Occupancy
-- Envelope. Working width is logged separately and never substitutes for physical
-- geometry. No containment, projected sweep or vehicle control is permitted.
OuttaMyWay.PROTOTYPE_07_ENABLED = false
OuttaMyWay.PROTOTYPE_07_INTERVAL_MS = 500
OuttaMyWay.PROTOTYPE_07_HEARTBEAT_MS = 15000
OuttaMyWay.PROTOTYPE_07_PAIR_LOG_MS = 1000
OuttaMyWay.PROTOTYPE_07_PAIR_WATCH_DISTANCE_M = 150.0
OuttaMyWay.PROTOTYPE_07_NODE_SCAN_BUDGET = 800
OuttaMyWay.PROTOTYPE_07_INVENTORY_REFRESH_MS = 5000

-- Prototype 08A/08B: passive model-derived collision-node pose validation.
-- 08A resolves the eight active 36 m Condor boom collision nodes and samples
-- their live transforms through folded, transitional and deployed poses. 08B
-- supplies asset-bound identity/hierarchy/offline endpoint predictions while
-- keeping binary mesh extents explicitly unresolved.
OuttaMyWay.PROTOTYPE_08_ENABLED = true
OuttaMyWay.PROTOTYPE_08_INTERVAL_MS = 100
OuttaMyWay.PROTOTYPE_08_TRANSITION_LOG_MS = 250
OuttaMyWay.PROTOTYPE_08_ENDPOINT_LOG_MS = 2000
OuttaMyWay.PROTOTYPE_08_NODE_DETAIL_MS = 5000
OuttaMyWay.PROTOTYPE_08_NODE_SCAN_BUDGET = 1800
OuttaMyWay.PROTOTYPE_08_ENUMERATION_LOG_MS = 2000
OuttaMyWay.PROTOTYPE_08_NO_MATCH_WARNING_MS = 5000

-- Prototype 09: passive Runtime Shape-Bound Evidence. It consumes Prototype
-- 08's source-bound collision identities and live nodes, tests documented
-- entityId+shapeId sphere APIs through a protected invocation matrix, and
-- records local stability plus local-to-world coherence. Bounding spheres are
-- evidence candidates only; no Physical Occupancy Envelope or Control follows.
OuttaMyWay.PROTOTYPE_09_ENABLED = false
OuttaMyWay.PROTOTYPE_09_INTERVAL_MS = 100
OuttaMyWay.PROTOTYPE_09_TRANSITION_LOG_MS = 250
OuttaMyWay.PROTOTYPE_09_ENDPOINT_LOG_MS = 2000
OuttaMyWay.PROTOTYPE_09_TRANSITION_DETAIL_MS = 1000
OuttaMyWay.PROTOTYPE_09_ENDPOINT_DETAIL_MS = 5000
OuttaMyWay.PROTOTYPE_09_SOURCE_WARNING_MS = 5000
OuttaMyWay.PROTOTYPE_09_COHERENCE_TOLERANCE_M = 0.05
OuttaMyWay.PROTOTYPE_09_MAX_ABS_CENTRE_M = 10000.0
OuttaMyWay.PROTOTYPE_09_MAX_RADIUS_M = 500.0

-- Prototype 11: passive runtime geometry-selector semantics. It compares
-- zero, own-asset, sibling-asset and deliberately invalid shapeId arguments on
-- already resolved runtime collision nodes and on the vehicle root. Geometry
-- identity is evaluated independently from local/world self-coherence.
OuttaMyWay.PROTOTYPE_11_ENABLED = false
OuttaMyWay.PROTOTYPE_11_INTERVAL_MS = 250
OuttaMyWay.PROTOTYPE_11_TRANSITION_LOG_MS = 1000
OuttaMyWay.PROTOTYPE_11_ENDPOINT_LOG_MS = 4000
OuttaMyWay.PROTOTYPE_11_SOURCE_WARNING_MS = 5000
OuttaMyWay.PROTOTYPE_11_COHERENCE_TOLERANCE_M = 0.05
OuttaMyWay.PROTOTYPE_11_IDENTITY_TOLERANCE_M = 0.0001
OuttaMyWay.PROTOTYPE_11_MAX_ABS_CENTRE_M = 10000.0
OuttaMyWay.PROTOTYPE_11_MAX_RADIUS_M = 500.0
OuttaMyWay.PROTOTYPE_11_INVALID_SHAPE_OFFSET = 1000

-- Prototype 12: completed passive Physical Assembly Discovery. Retained for
-- future replication but disabled after strong integrated/attached validation.
-- It does not infer collision membership or physical occupancy.
OuttaMyWay.PROTOTYPE_12_ENABLED = false
OuttaMyWay.PROTOTYPE_12_INTERVAL_MS = 250
OuttaMyWay.PROTOTYPE_12_ENUMERATION_LOG_MS = 3000
OuttaMyWay.PROTOTYPE_12_MOTION_LOG_MS = 2000
OuttaMyWay.PROTOTYPE_12_MEMBER_BUDGET = 16
OuttaMyWay.PROTOTYPE_12_NODE_SCAN_BUDGET = 3000
OuttaMyWay.PROTOTYPE_12_SUMMARY_NODE_SCAN_BUDGET = 1

-- Prototype 13A: passive Declared Route Evaluation. Fixture-specific Lua tables
-- declare candidate lookup routes for Condor, Tiger 8 MT and TopDown 600. The
-- common evaluator preserves all candidates, route convergence/disagreement,
-- Entity-local geometry evidence and negative controls. No footprint or control.
OuttaMyWay.PROTOTYPE_13_ENABLED = true
OuttaMyWay.PROTOTYPE_13_INTERVAL_MS = 100
OuttaMyWay.PROTOTYPE_13_ENUMERATION_LOG_MS = 3000
OuttaMyWay.PROTOTYPE_13_CHANGING_LOG_MS = 250
OuttaMyWay.PROTOTYPE_13_STABLE_LOG_MS = 2000
OuttaMyWay.PROTOTYPE_13_ANIMATION_CHANGE_EPSILON = 0.0005
OuttaMyWay.PROTOTYPE_13_ANIMATION_STABLE_MS = 500
OuttaMyWay.PROTOTYPE_13_COHERENCE_TOLERANCE_M = 0.05
OuttaMyWay.PROTOTYPE_13_ALIAS_TOLERANCE_M = 0.0001
OuttaMyWay.PROTOTYPE_13_MOTION_THRESHOLD_M = 0.02
OuttaMyWay.PROTOTYPE_13_MAX_ABS_CENTRE_M = 10000.0
OuttaMyWay.PROTOTYPE_13_MAX_RADIUS_M = 500.0

-- Prototype 14: active Single-Worker Information-Gaining Delay. This is an
-- exclusive, one-hold experiment for TS012. It consumes Prototype 02
-- ESTABLISHED confidence, selects the later-admitted worker and uses the
-- native field-worker permission gate. Predictor CLEAR never releases the hold;
-- release candidates are logged only so Safe Release remains a separate claim.
OuttaMyWay.SINGLE_WORKER_DELAY_ENABLED = false
OuttaMyWay.SINGLE_WORKER_DELAY_EXCLUSIVE = false
OuttaMyWay.SINGLE_WORKER_DELAY_INTERVAL_MS = 250
OuttaMyWay.SINGLE_WORKER_DELAY_HEARTBEAT_MS = 15000
OuttaMyWay.SINGLE_WORKER_DELAY_LOG_INTERVAL_MS = 1000
OuttaMyWay.SINGLE_WORKER_DELAY_HEAD_ON_MIN_DEG = 150.0
OuttaMyWay.SINGLE_WORKER_DELAY_MIN_TCPA_S = 5.0
OuttaMyWay.SINGLE_WORKER_DELAY_OBSERVATION_TIMEOUT_MS = 90000
OuttaMyWay.SINGLE_WORKER_DELAY_RELEASE_CANDIDATE_DISTANCE_M = 55.0
OuttaMyWay.SINGLE_WORKER_DELAY_DIVERGENCE_EPSILON_M = 0.10
OuttaMyWay.SINGLE_WORKER_DELAY_DIVERGENCE_CONFIRM_MS = 2000
OuttaMyWay.SINGLE_WORKER_DELAY_MIN_PRIORITY_SPEED_KMH = 2.0
OuttaMyWay.SINGLE_WORKER_DELAY_EFFECT_SPEED_KMH = 0.75
OuttaMyWay.SINGLE_WORKER_DELAY_EFFECT_DEADLINE_MS = 4000

-- Prototype 16 retains the validated hold/fold/egress/passage/rejoin/handback
-- sequence. Prototype 18 admits the exact Condor/Patriot test pair without
-- assigning roles. Prototype 19 calculates both role assignments and both
-- lateral sides, then supplies the selected role and provisional refuge. At the
-- confirmed stop, both sides for the selected Yield role are recalculated and
-- the calculated lateral and rearward movements become Control authority.
-- No fixed Yield role, side, 28 m lateral or 12 m rearward fallback remains.
OuttaMyWay.UNILATERAL_SIDESTEP_ENABLED = true
OuttaMyWay.UNILATERAL_SIDESTEP_EXCLUSIVE = true
OuttaMyWay.TS015_INTERVAL_MS = 100
OuttaMyWay.TS015_LOG_INTERVAL_MS = 500
OuttaMyWay.TS015_HEARTBEAT_MS = 15000
OuttaMyWay.TS015_STABLE_WORKING_MS = 3000
OuttaMyWay.TS015_MIN_WORKING_SPEED_KMH = 2.0
OuttaMyWay.TS015_MIN_PROGRESS_SPEED_KMH = 2.0
OuttaMyWay.TS015_HEAD_ON_MIN_DEG = 150.0
OuttaMyWay.TS015_ARM_TIMEOUT_MS = 90000
OuttaMyWay.TS015_STOP_SPEED_KMH = 0.75
OuttaMyWay.TS015_STOP_CONFIRM_MS = 1000
OuttaMyWay.TS015_HOLD_EFFECT_TIMEOUT_MS = 10000
OuttaMyWay.TS015_EGRESS_READY_TIMEOUT_MS = 12000
OuttaMyWay.TS015_FOLD_TIMEOUT_MS = 22000
OuttaMyWay.TS015_DRIVE_TIMEOUT_MS = 45000
OuttaMyWay.TS015_EGRESS_SPEED_KMH = 15.0
OuttaMyWay.TS015_INGRESS_SPEED_KMH = 15.0
OuttaMyWay.TS015_PRECISION_SPEED_KMH = 6.0
OuttaMyWay.TS015_EGRESS_PRECISION_RADIUS_M = 6.0
OuttaMyWay.TS015_REJOIN_PRECISION_RADIUS_M = 8.0
OuttaMyWay.TS015_REJOIN_FORWARD_M = 6.0
-- Rejoin orientation is a separate low-speed phase. It is entered only when
-- the final rejoin target is behind the Yield vehicle, avoiding the undefined
-- forward-only steering command observed in TS015 with a right-side refuge.
OuttaMyWay.TS015_REJOIN_ORIENTATION_SPEED_KMH = 5.0
OuttaMyWay.TS015_REJOIN_ORIENTATION_STEER_LZ = 0.30
OuttaMyWay.TS015_REJOIN_ORIENTATION_FORWARD_DOT = 0.25
OuttaMyWay.TS015_REJOIN_ORIENTATION_TIMEOUT_MS = 12000
OuttaMyWay.TS015_REJOIN_ORIENTATION_MAX_TRAVEL_M = 20.0
-- Once the final target is in the forward hemisphere, a progress watchdog
-- stops the vehicle promptly if target distance fails to improve or diverges.
OuttaMyWay.TS015_REJOIN_PROGRESS_EPSILON_M = 0.25
OuttaMyWay.TS015_REJOIN_PROGRESS_GRACE_MS = 2000
OuttaMyWay.TS015_REJOIN_PROGRESS_TIMEOUT_MS = 3500
OuttaMyWay.TS015_REJOIN_DIVERGENCE_LIMIT_M = 6.0
OuttaMyWay.TS015_EGRESS_READY_FOLD_ANIM_TIME = 0.15
OuttaMyWay.TS015_FULL_COMPACT_FOLD_ANIM_TIME = 0.98
OuttaMyWay.TS015_TARGET_RADIUS_M = 1.0
OuttaMyWay.TS015_FENCE_TOLERANCE_M = 0.75
OuttaMyWay.TS015_PASS_BEHIND_STOP_M = 20.0
OuttaMyWay.TS015_PASS_CLEAR_DISTANCE_M = 35.0
OuttaMyWay.TS015_PASS_MIN_DIVERGENCE_MPS = 0.20
OuttaMyWay.TS015_PASS_CONFIRM_MS = 1500
OuttaMyWay.TS015_POST_PASS_DWELL_MS = 1000
OuttaMyWay.TS015_PASSAGE_TIMEOUT_MS = 90000
OuttaMyWay.TS015_PROGRESS_BLOCKED_CONFIRM_MS = 1500
OuttaMyWay.TS015_PAIR_GEOMETRY_INTERVAL_MS = 500
OuttaMyWay.TS015_PAIR_GEOMETRY_SCAN_BUDGET = 1000
OuttaMyWay.TS015_HANDOFF_OBSERVE_MS = 20000

OuttaMyWay.TS018_AUTOMATIC_ADMISSION_ENABLED = true
OuttaMyWay.TS018_ADMISSION_CONFIRM_MS = 3000
OuttaMyWay.TS018_EPISODE_RESET_MS = 5000
OuttaMyWay.TS018_MIN_CLOSING_RATE_MPS = 0.10
OuttaMyWay.TS018_MAX_TCPA_S = 30.0
OuttaMyWay.TS018_MAX_DCPA_M = 14.0
OuttaMyWay.TS018_MIN_COMMIT_TCPA_S = 6.0
-- Successful encounter completion does not permanently suppress the same pair.
-- Rearming uses the already validated passage-clear distance and requires the
-- pair to remain outside the predicted conflict envelope for a sustained period.
OuttaMyWay.TS018_REARM_MIN_SEPARATION_M = OuttaMyWay.TS015_PASS_CLEAR_DISTANCE_M
OuttaMyWay.TS018_REARM_CLEAR_CONFIRM_MS = 3000

-- TS016 repeatable turn-exit head-on admission. Lane crossing alone is not
-- authority. Admission requires exactly one straight-working worker, exactly one
-- manoeuvring worker, live opposed headings, positive closure, and predicted
-- closest approach inside the conflict envelope. The straight-working worker is
-- the early Yield role for this path; confirmed-stop refuge calculation remains
-- authoritative.
OuttaMyWay.TS016_MANOEUVRE_ADMISSION_ENABLED = true
OuttaMyWay.TS016_ADMISSION_CONFIRM_MS = 0
OuttaMyWay.TS016_MIN_MANOEUVRE_SPEED_KMH = 1.0
OuttaMyWay.TS016_MAX_TCPA_S = 12.0
OuttaMyWay.TS016_MAX_DCPA_M = 14.0
OuttaMyWay.TS016_MIN_COMMIT_TCPA_S = 6.0

-- Prototype 19 calculated-refuge authority. Lateral separation is derived from
-- the Progress working-width extent, the predicted compact Yield assembly extent
-- and the existing clearance-margin budget. Rearward movement is derived from
-- the compact assembly forward extent plus geometry and tracking margins so the
-- complete compact assembly rests behind the confirmed stop line.
OuttaMyWay.TS019_SHADOW_REFUGE_COMPARISON_ENABLED = true

-- Prototype 17 shadow-only policy-clearance margins. They are evidence hypotheses,
-- individually logged, excluded from the physical contact threshold and deliberately
-- excluded from live Control.
OuttaMyWay.TS017_SHADOW_CLEARANCE_ENABLED = true
OuttaMyWay.TS017_PROGRESS_WORKING_WIDTH_FALLBACK_M = 36.0
OuttaMyWay.TS017_GEOMETRY_UNCERTAINTY_M = 0.75
OuttaMyWay.TS017_TRACKING_TOLERANCE_M = 1.00
OuttaMyWay.TS017_MOTION_ALLOWANCE_M = 0.50
OuttaMyWay.TS017_POLICY_MARGIN_M = 1.50

-- TS017-B fixture-bounded Condor Facing Extent Provider. The empirical folded
-- origin template comes from repeated Prototype 08 runtime observations. The
-- allowance closes unresolved mesh/chassis radius only for shadow evidence; it
-- has no Control authority and is deliberately logged as a separate operand.
OuttaMyWay.TS017_CONDOR_NODE_SCAN_BUDGET = 2200
OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MIN_X_M = -1.42
OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MAX_X_M = 1.42
OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MIN_Z_M = -5.21
OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MAX_Z_M = -1.61
OuttaMyWay.TS017_CONDOR_ORIGIN_ALLOWANCE_M = 2.50

-- First live Traffic Manager v2 prototype. Disabled while validated passive prototype evidence is consolidated.
-- Its retained settings are not executed in this candidate.
OuttaMyWay.TRAFFIC_V2_ENABLED = false
OuttaMyWay.TRAFFIC_V2_MIN_CONFIDENCE = 0.80
OuttaMyWay.TRAFFIC_V2_HOLD_MS = 4000 -- legacy prototype value, retained for compatibility
OuttaMyWay.TRAFFIC_V2_MIN_HOLD_MS = 3000
OuttaMyWay.TRAFFIC_V2_MAX_HOLD_MS = 15000
OuttaMyWay.TRAFFIC_V2_CLEAR_CONFIRM_MS = 1200
OuttaMyWay.TRAFFIC_V2_HEARTBEAT_MS = 15000
OuttaMyWay.AI_EXPLORER_INTERVAL_MS = 250
OuttaMyWay.AI_EXPLORER_SCAN_HEARTBEAT_MS = 15000
OuttaMyWay.AI_EXPLORER_TARGET_BEARING_STEP_DEG = 15
OuttaMyWay.AI_EXPLORER_TARGET_HISTORY_SECONDS = 4.0
OuttaMyWay.AI_EXPLORER_PROJECTION_SECONDS = 3.0
OuttaMyWay.AI_EXPLORER_TURN_START_ANGLE_DEG = 12
OuttaMyWay.AI_EXPLORER_TURN_APEX_ANGLE_DEG = 3
OuttaMyWay.AI_EXPLORER_TURN_COMPLETE_ANGLE_DEG = 5
OuttaMyWay.AI_EXPLORER_TURN_STABLE_SECONDS = 1.5

-- Diagnostic-only constant-velocity conflict prediction. This layer never
-- changes speed, steering, implements, priority or AI state.

-- GIANTS AI course lookahead. Only conservative brief HOLD control is enabled.
OuttaMyWay.COURSE_LOOKAHEAD_LOG_INTERVAL_MS = 2000
OuttaMyWay.COURSE_LOOKAHEAD_PAIR_LOG_MS = 3000
OuttaMyWay.COURSE_LOOKAHEAD_HEARTBEAT_MS = 15000
OuttaMyWay.COURSE_LOOKAHEAD_MAX_POINTS = 140
OuttaMyWay.COURSE_LOOKAHEAD_MAX_SEGMENTS = 8
OuttaMyWay.COURSE_LOOKAHEAD_HORIZON_SECONDS = 30.0
OuttaMyWay.COURSE_LOOKAHEAD_MIN_DISTANCE = 45.0
OuttaMyWay.COURSE_LOOKAHEAD_MIN_SPEED_MPS = 1.5
OuttaMyWay.COURSE_LOOKAHEAD_TIME_GAP_SECONDS = 8.0
OuttaMyWay.COURSE_INTERSECTION_CLEARANCE_SECONDS = 3.0
OuttaMyWay.COURSE_COMPLETION_PRIORITY_MIN_DELTA_SECONDS = 15.0
OuttaMyWay.COURSE_HOLD_MAX_ETA_SECONDS = 25.0
OuttaMyWay.COURSE_HOLD_MAX_GAP_SECONDS = 5.0
OuttaMyWay.COURSE_HOLD_MAX_SECONDS = 10.0
OuttaMyWay.COURSE_HOLD_ENTER_CONFIDENCE = 0.70
OuttaMyWay.COURSE_HOLD_RELEASE_CONFIDENCE = 0.45
OuttaMyWay.COURSE_HOLD_COMMIT_MS = 5000

OuttaMyWay.VECTOR_DEBUG_HORIZON_SECONDS = 20.0
OuttaMyWay.VECTOR_DEBUG_UPDATE_MS = 2000
OuttaMyWay.VECTOR_DEBUG_MIN_SPEED_KMH = 0.75
OuttaMyWay.VECTOR_DEBUG_MAX_TURN_FACTOR = 0.18
OuttaMyWay.VECTOR_DEBUG_NEAR_MARGIN = 8.0
OuttaMyWay.VECTOR_DEBUG_CRITICAL_FACTOR = 0.5

-- Observer-only time/corridor reservation layer.
OuttaMyWay.RESERVATION_TIME_PADDING_SECONDS = 2.5
OuttaMyWay.RESERVATION_CLEARANCE_SECONDS = 4.0
OuttaMyWay.RESERVATION_MIN_CONFIDENCE = 0.60
OuttaMyWay.RESERVATION_LOG_INTERVAL_MS = 3000
OuttaMyWay.RESERVATION_RETENTION_MS = 5000

-- Predictive live-action commitment. Once SLOW or YIELD is executed it is
-- held through brief vector/reservation jitter. Only confirmed clearance, a
-- safety timeout, or a critical SLOW-to-YIELD escalation can change it.
OuttaMyWay.PREDICTIVE_CLEAR_CONFIRM_MS = 1500
OuttaMyWay.PREDICTIVE_COMMIT_TIMEOUT_MS = 30000

-- Head-on deadlock recovery. If both vehicles are virtually stopped and
-- facing each other, right of way is transferred to the vehicle that was
-- waiting so it can clear the obstruction.
OuttaMyWay.DEADLOCK_DISTANCE = 25.0
OuttaMyWay.DEADLOCK_DETECT_MS = 1800
OuttaMyWay.DEADLOCK_MAX_SPEED_KMH = 1.2
OuttaMyWay.HEAD_ON_DOT = -0.65

-- Perpendicular intersection recovery. Stalled crossing traffic needs the
-- same asymmetric move-aside manoeuvre as a head-on conflict; a simple wait
-- cannot clear two implements that have entered the crossing together.
OuttaMyWay.CROSSING_DOT_MAX = 0.50
OuttaMyWay.CROSSING_DETECT_MS = 2200

-- Head-on recovery is asymmetric. One vehicle temporarily leaves the
-- opposing track, parks clear, lets the other pass, then returns to its AI job.
OuttaMyWay.RECOVERY_SPEED_KMH = 6.0
OuttaMyWay.REVERSE_ESCAPE_DISTANCE = 6.0
OuttaMyWay.REVERSE_ESCAPE_SPEED_KMH = 3.5
OuttaMyWay.REVERSE_ESCAPE_TIMEOUT_MS = 6000
OuttaMyWay.REVERSE_TRIGGER_SEPARATION = 8.0
OuttaMyWay.RECOVERY_STEER_X = 0.85
OuttaMyWay.RECOVERY_STEER_Z = 0.45
OuttaMyWay.ESCAPE_TARGET_LATERAL = 22.0
OuttaMyWay.ESCAPE_TARGET_REARWARD = 7.0
OuttaMyWay.ESCAPE_TARGET_RADIUS = 2.5
OuttaMyWay.ESCAPE_TIMEOUT_MS = 18000
OuttaMyWay.ESCAPE_MIN_TIME_MS = 1800
OuttaMyWay.ESCAPE_MIN_DISTANCE = 16.0
OuttaMyWay.ESCAPE_MIN_LATERAL = 12.0
OuttaMyWay.ESCAPE_MIN_SEPARATION = 26.0
OuttaMyWay.HOLD_TIMEOUT_MS = 30000
OuttaMyWay.PASS_CLEAR_DISTANCE = 32.0
OuttaMyWay.PASS_MIN_TIME_MS = 2500
OuttaMyWay.PASS_PROGRESS_CHECK_MS = 5000
OuttaMyWay.PASS_MIN_PROGRESS = 2.0
OuttaMyWay.SECOND_ESCAPE_LATERAL = 10.0
OuttaMyWay.RECOVERY_PRIORITY_MS = 7000
OuttaMyWay.PAIR_COOLDOWN_MS = 45000
OuttaMyWay.RELEASE_PRIORITY_MS = 20000
OuttaMyWay.RELEASE_PRIORITY_MIN_TRAVEL = 16.0
OuttaMyWay.RELEASE_PRIORITY_MIN_SEPARATION = 30.0
OuttaMyWay.ABSOLUTE_CLEAR_DISTANCE = 55.0

-- Same-direction queue protection. A moving helper approaching the rear of a
-- stopped/yielding helper must queue behind it rather than inheriting priority.
OuttaMyWay.REAR_QUEUE_DISTANCE = 44.0
OuttaMyWay.REAR_RELEASE_DISTANCE = 52.0
OuttaMyWay.REAR_LATERAL_LIMIT = 5.5
OuttaMyWay.REAR_HEADING_DOT = 0.55
OuttaMyWay.WIDE_REAR_EXTRA_MARGIN = 34.0
OuttaMyWay.WIDE_REAR_RELEASE_MARGIN = 12.0
OuttaMyWay.REAR_MIN_CLOSING_KMH = 0.5

-- Parallel-lane exclusion. Helpers travelling in stable neighbouring lanes
-- must not yield to each other merely because their vehicle envelopes are
-- close. Only pairs whose lateral spacing is predicted to collapse are kept.
OuttaMyWay.PARALLEL_HEADING_DOT = 0.70
OuttaMyWay.PARALLEL_MIN_LATERAL = 5.5
OuttaMyWay.PARALLEL_MAX_LATERAL = 18.0
OuttaMyWay.PARALLEL_MIN_PREDICTED_LATERAL = 4.5

-- Dynamic implement envelope. Each helper is represented by an envelope based
-- on half of its largest attached implement working width plus a margin.
OuttaMyWay.DEFAULT_WORKING_WIDTH = 6.0
OuttaMyWay.MIN_WORKING_WIDTH = 2.5
OuttaMyWay.MAX_WORKING_WIDTH = 80.0
OuttaMyWay.WIDTH_SIDE_MARGIN = 3.0
OuttaMyWay.WIDTH_LONGITUDINAL_MARGIN = 6.0
OuttaMyWay.TURN_SWEEP_MULTIPLIER = 1.35
OuttaMyWay.TURN_RATE_FULL_DEG = 12.0
OuttaMyWay.WIDTH_CACHE_MS = 3000

-- Straight opposite-direction passes use the combined half working widths.
-- No physical-boom multiplier or additional pass margin is applied. Turning
-- conflicts continue to use the full working-width sweep envelope.
OuttaMyWay.BOOM_PASS_MAX_TURN = 0.08

-- Blocked-yield AI handback. After a compact recovery, move the complete
-- vehicle one length forward before restoring the implement and returning the
-- original GIANTS AI drive call. This mirrors the proven head-on re-entry path.
OuttaMyWay.AI_HANDOFF_FORWARD_MIN = 6.0
OuttaMyWay.AI_HANDOFF_SPEED_KMH = 8.0
OuttaMyWay.AI_HANDOFF_VERIFY_MS = 3000
OuttaMyWay.AI_HANDOFF_RETRY_DISTANCE = 3.0
OuttaMyWay.CLEARANCE_LOG_INTERVAL_MS = 2000

-- Field-edge diagnostic scan. This is debug-only and does not affect driving.
OuttaMyWay.FIELD_EDGE_DEBUG_INTERVAL_MS = 30000
OuttaMyWay.FIELD_EDGE_DEBUG_STEP = 1.0
OuttaMyWay.FIELD_EDGE_DEBUG_MAX = 1200.0

-- Wide-boom head-on reservation. Two large implements need enough room for
-- the priority helper to complete its normal headland turn before the other
-- reaches the turn sweep. This is intentionally much earlier than the normal
-- tractor-centre conflict threshold.
OuttaMyWay.WIDE_IMPLEMENT_THRESHOLD = 20.0
OuttaMyWay.HEAD_ON_RESERVATION_FACTOR = 2.25
OuttaMyWay.HEAD_ON_RESERVATION_MARGIN = 12.0
OuttaMyWay.HEAD_ON_MIN_RESERVATION = 80.0

-- v2.1 lane ownership. Wide head-on workers cannot safely pass or turn around
-- one another with deployed booms. The worker closest to the field edge behind
-- it reverses straight back to the headland and parks while the other owns the
-- lane and completes the pass.
OuttaMyWay.LANE_SAMPLE_STEP = 2.0
OuttaMyWay.LANE_SAMPLE_MAX = 180.0
OuttaMyWay.LANE_EDGE_MARGIN = 12.0
OuttaMyWay.LANE_REVERSE_MAX = 35.0
OuttaMyWay.LANE_REVERSE_SPEED_KMH = 6.0
OuttaMyWay.LANE_REVERSE_TIMEOUT_MS = 15000
OuttaMyWay.LANE_ALIGNMENT_FACTOR = 0.45
OuttaMyWay.LANE_RELEASE_MARGIN = 16.0
OuttaMyWay.LANE_FALLBACK_REVERSE = 20.0
OuttaMyWay.LANE_STALE_TIMEOUT_MS = 60000
OuttaMyWay.LANE_OWNER_TURN_RELEASE_DOT = 0.70
-- v2.2: lane ownership is local to an active headland manoeuvre. Workers at
-- opposite ends of a field must not reserve the same geometric lane.
OuttaMyWay.LANE_LONGITUDINAL_LIMIT = 100.0
OuttaMyWay.HEADLAND_TURN_TRIGGER = 0.08
OuttaMyWay.HEADLAND_SPEED_TRIGGER_KMH = 5.5
OuttaMyWay.LANE_BLOCK_CHECK_MS = 8000
OuttaMyWay.LANE_BLOCK_MIN_MOVEMENT = 0.5

-- v2.3 direct head-on backout. For two wide workers travelling almost exactly
-- toward one another, stop the selected owner and immediately reverse one
-- fixed vacating worker. Roles remain fixed for the entire encounter.
OuttaMyWay.DIRECT_HEAD_ON_DOT = -0.90
OuttaMyWay.DIRECT_HEAD_ON_MAX_TURN = 0.06
OuttaMyWay.HEAD_ON_BACKOUT_SPEED_KMH = 8.0
OuttaMyWay.HEAD_ON_BACKOUT_MIN = 12.0
OuttaMyWay.HEAD_ON_BACKOUT_MAX = 1200.0
OuttaMyWay.HEAD_ON_BACKOUT_EXTRA = 24.0
OuttaMyWay.HEAD_ON_BACKOUT_TIMEOUT_MS = 600000
OuttaMyWay.HEAD_ON_WORKING_SPEED_KMH = 6.0
OuttaMyWay.HEAD_ON_HEADLAND_MARGIN = 0.5
OuttaMyWay.FIELD_EDGE_OVERSHOOT = 0.5
OuttaMyWay.HEAD_ON_FAR_HEADLAND_MIN_TRAVEL = 100.0
OuttaMyWay.HEAD_ON_FAR_HEADLAND_MIN_MS = 30000
OuttaMyWay.DEFAULT_VEHICLE_LENGTH = 10.0
OuttaMyWay.PARKED_ABSOLUTE_RELEASE = 110.0
OuttaMyWay.HEAD_ON_COMPLETED_COOLDOWN_MS = 180000
OuttaMyWay.BACKOUT_PREPARE_MS = 6500
OuttaMyWay.widthCache = {}
OuttaMyWay.headingHistory = {}
OuttaMyWay.passProgress = {}
OuttaMyWay.aiStartAnchor = {}
OuttaMyWay.fieldEdgeDebugLast = {}
OuttaMyWay.fieldEdgeDebugDumped = {}
OuttaMyWay.giantsFieldBoundary = {}
OuttaMyWay.vectorDebugState = {}
OuttaMyWay.vectorPredictions = {}
OuttaMyWay.MAX_RECOMMENDED_WORKERS_PER_FIELD = 4
OuttaMyWay.GIANTS_BOUNDARY_RETRY_MS = 30000
OuttaMyWay.GIANTS_BOUNDARY_LOG_INTERVAL_MS = 30000

OuttaMyWay.elapsed = 0
OuttaMyWay.debugElapsed = 0
OuttaMyWay.waiting = {}
OuttaMyWay.vehicleOrder = {}
OuttaMyWay.nextOrder = 1
OuttaMyWay.activeWaitCount = 0
OuttaMyWay.priorityName = ""
OuttaMyWay.transientText = ""
OuttaMyWay.transientUntil = 0
OuttaMyWay.lastActiveCount = -1
OuttaMyWay.lastNetworkSignature = ""
OuttaMyWay.driveHookInstalled = false
OuttaMyWay.forcedPriorityUntil = {}
OuttaMyWay.recovery = {}
OuttaMyWay.recoveryVehicle = nil
OuttaMyWay.pairCooldown = {}
OuttaMyWay.releasePriority = {}
OuttaMyWay.laneVacate = {}
OuttaMyWay.laneOwnerHold = {}
OuttaMyWay.laneReservations = {}
OuttaMyWay.headOnCompleted = {}
OuttaMyWay.headOnEdgeLog = {}
OuttaMyWay.parkedFoldState = {}
OuttaMyWay.parkedWorkState = {}
OuttaMyWay.raisedState = {}
OuttaMyWay.aiResumeAssist = {}
OuttaMyWay.aiResumeVerify = {}
OuttaMyWay.clearanceLogState = {}

OuttaMyWay.PASSAGE_ASSIST_WINDOW_MS = 20000
OuttaMyWay.PASSAGE_ASSIST_MIN_MS = 6000
OuttaMyWay.PASSAGE_ASSIST_UNFOLD_SETTLE_MS = 3500
OuttaMyWay.PASSAGE_ASSIST_OWNER_MOVE = 18.0
OuttaMyWay.PASSAGE_ASSIST_CLEAR_DISTANCE = 45.0
OuttaMyWay.PASSAGE_ASSIST_TIMEOUT_MS = 20000
OuttaMyWay.PASSAGE_ASSIST_RESUME_GRACE_MS = 5000

-- v4.2.5.5 diagnostic manual-handoff experiment.
OuttaMyWay.RECOVERY_HANDOFF_MOVE_THRESHOLD_M = 8.0
OuttaMyWay.RECOVERY_HANDOFF_SETTLE_MS = 2000
