-- FS25_OuttaMyWay v0.3.0.62 TEST — FOLLOWER BOUNDARY ASSESSMENT VALUE OWNERSHIP.
-- Follower Boundary assessment calibration is owned by the evaluator that
-- interprets it; the separate Candidate-expression enable gate is unchanged.

OuttaMyWay = OuttaMyWay or {}
OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"
OuttaMyWay.VERSION = "0.3.0.62"
OuttaMyWay.ARCHITECTURE_VERSION = "0.1.2.0"
OuttaMyWay.RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"
OuttaMyWay.CONTROL_AUTHORITY_ENABLED = false
-- Temporary live-gate HUDs. Diagnostic instrumentation only.
-- v4.7.24 retains the lifecycle gate only to verify cleanup causes no behavioural change
-- to Future-Space admission, termination precedence or fresh-Episode identity.
OuttaMyWay.LIFECYCLE_TEST_HUD_ENABLED = false
OuttaMyWay.FUTURE_SPACE_HUD_ENABLED = false
OuttaMyWay.TRANSITION_HUD_ENABLED = false
OuttaMyWay.TRANSITION_HUD_X = 0.985
OuttaMyWay.TRANSITION_HUD_Y = 0.720
OuttaMyWay.TRANSITION_HUD_TITLE_SIZE = 0.016
OuttaMyWay.TRANSITION_HUD_TEXT_SIZE = 0.014
OuttaMyWay.TRANSITION_HUD_LINE_HEIGHT = 0.022

-- Live diagnostic instrument controls are module-owned. Their exact accepted
-- enablement and publication/sample cadences live with the five instruments;
-- they are not player Configuration and do not define Runtime scheduling.

OuttaMyWay.FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED = true
-- Follower Boundary Situation-assessment calibration is module-owned. This root
-- retains only the distinct Candidate-expression enable gate.


-- Trajectory Conflict Assessment owns its sampling, persistence and opposed-current
-- interpretation calibration locally. Passage Action-Space policy remains external.


-- Cooperative Passage policy and implementation calibration.
-- The nominal 1 m Inter-Assembly Clearance is empirical policy rather than an
-- exact collision calculation. Cached complete-assembly Transit geometry
-- constructs Passage; Reality remains the calibration authority.
OuttaMyWay.COOPERATIVE_PASSAGE_ENABLED = true
OuttaMyWay.COOPERATIVE_PASSAGE_LOCAL_MAX_ENTRY_SEPARATION_M = 80.0
OuttaMyWay.COOPERATIVE_PASSAGE_CLEARANCE_TRACE_MAX_SEPARATION_M = 40.0 -- TEST telemetry only; does not alter Candidate evaluation.
OuttaMyWay.COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M = 1.0
OuttaMyWay.COOPERATIVE_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO = 0.95 -- TEST: nominal 1 m remains construction target; 95% is admissible Crossing-Window policy floor.
-- Passage Development is derived from actual participant displacement.
-- Crossing Window extent is derived from represented longitudinal assembly extent,
-- not initial encounter separation.
OuttaMyWay.COOPERATIVE_PASSAGE_MIN_DEVELOPMENT_DISTANCE_M = 4.0
OuttaMyWay.COOPERATIVE_PASSAGE_DEVELOPMENT_FORWARD_PER_LATERAL_M = 2.0
-- Coarse allowance for live sampling / stop acquisition before Development.
-- It is Control allowance, not physical assembly length or braking distance.
OuttaMyWay.COOPERATIVE_PASSAGE_ENTRY_CONTROL_ALLOWANCE_M = 3.0
OuttaMyWay.COOPERATIVE_PASSAGE_DEVELOPMENT_GATE_RADIUS_M = 2.0
OuttaMyWay.COOPERATIVE_PASSAGE_TRAVERSAL_GATE_RADIUS_M = 1.0
OuttaMyWay.COOPERATIVE_PASSAGE_REACQUISITION_GATE_RADIUS_M = 2.0
OuttaMyWay.COOPERATIVE_PASSAGE_FIELD_SWEEP_SAMPLE_M = 2.0
OuttaMyWay.COOPERATIVE_PASSAGE_PAIR_SWEEP_SAMPLES_PER_LEG = 20
OuttaMyWay.COOPERATIVE_PASSAGE_ACTUATION_SPEED_KMH = 8.0
OuttaMyWay.COOPERATIVE_PASSAGE_PHASE_WATCHDOG_MS = 45000
-- Assembly-alignment tolerances are measurements around the captured Transit
-- assembly pose; they are not Passage-clearance geometry.
OuttaMyWay.COOPERATIVE_PASSAGE_ALIGNMENT_LATERAL_TOLERANCE_M = 0.50
OuttaMyWay.COOPERATIVE_PASSAGE_ALIGNMENT_HEADING_MIN_DOT = 0.995

-- Resolution-Space Progression Envelope policy calibration.
-- The reserve is a withheld fraction of positively established usable Resolution
-- Space, not a claimed GIANTS braking distance.
OuttaMyWay.RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION = 0.75

-- When ordinary Resolution Space is exhausted while intent remains unresolved,
-- retain minimal positive progression rather than Hold so fresh native intent can
-- continue to reveal without spending ordinary Resolution Space authority.
OuttaMyWay.RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH = 1

-- Cooperative Passage hold-settlement and heartbeat implementation calibration.
OuttaMyWay.COOPERATIVE_PASSAGE_HOLD_EFFECT_SPEED_KMH = 0.25
OuttaMyWay.COOPERATIVE_PASSAGE_HEARTBEAT_MS = 1000

-- Transit fold settlement is bounded. The preferred ceiling is derived once at
-- Job-Episode bootstrap from the active runtime folding configuration's
-- maxFoldAnimDuration; factor/margin values are implementation fail-safe bounds.
OuttaMyWay.COOPERATIVE_PASSAGE_TRANSIT_FOLD_SETTLEMENT_DURATION_FACTOR = 1.50
OuttaMyWay.COOPERATIVE_PASSAGE_TRANSIT_FOLD_SETTLEMENT_MARGIN_MS = 2000
OuttaMyWay.COOPERATIVE_PASSAGE_TRANSIT_FOLD_SETTLEMENT_FALLBACK_MS = 30000
OuttaMyWay.COOPERATIVE_PASSAGE_TRANSIT_FOLD_SETTLEMENT_MAX_MS = 35000

-- Development build identity plus explanatory test HUD.
OuttaMyWay.BUILD_LABEL = "0.3.0.62 TEST — FOLLOWER BOUNDARY ASSESSMENT VALUE OWNERSHIP"
OuttaMyWay.FORWARD_INTERSECTION_REGULATION_SPEED_KMH = 1
OuttaMyWay.VERSION_HUD_ENABLED = true
OuttaMyWay.VERSION_HUD_X = 0.985
OuttaMyWay.VERSION_HUD_Y = 0.720
OuttaMyWay.VERSION_HUD_TEXT_SIZE = 0.014
OuttaMyWay.FOLLOWER_PACING_HUD_ENABLED = true
OuttaMyWay.FOLLOWER_PACING_HUD_X = 0.985
OuttaMyWay.FOLLOWER_PACING_HUD_Y = 0.697
OuttaMyWay.FOLLOWER_PACING_HUD_TEXT_SIZE = 0.013
OuttaMyWay.FOLLOWER_PACING_HUD_MAX_ROWS = 3
