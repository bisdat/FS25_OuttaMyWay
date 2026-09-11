-- FS25_OuttaMyWay v0.3.0.58 TEST — FIELD WORLD VALUE OWNERSHIP.
-- Field World production, interpretation and evidence-history values now live
-- with the three implementation responsibilities that give them meaning.

OuttaMyWay = OuttaMyWay or {}
OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"
OuttaMyWay.VERSION = "0.3.0.58"
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

OuttaMyWay.FIELD_IDENTITY_PROBE_HEARTBEAT_INTERVAL_MS = 10000

-- Prototype 21: passive Productive Continuation evidence discovery. These are
-- diagnostic sampling/logging intervals only; speed values are observations and
-- carry no Productive/Transitional classification authority.
OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_ENABLED = true
OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_INTERVAL_MS = 250
OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_HEARTBEAT_MS = 2000


-- D-0138 passive GIANTS Native Field-Worker Drive Command shadow probe.
-- Reads spec_aiFieldWorker.aiDriveParams only after GIANTS has populated it;
-- the observer never calls getDriveData() and never changes driveToPoint input.
OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_ENABLED = true
OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_INTERVAL_MS = 250
OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_HEARTBEAT_MS = 1000



-- Native manoeuvre observation is retained, but TURNING/head-reversal does not
-- qualify boundary-demand authority.
OuttaMyWay.NATIVE_MANOEUVRE_OBSERVATION_ENABLED = true
OuttaMyWay.NATIVE_MANOEUVRE_OBSERVATION_INTERVAL_MS = 100
OuttaMyWay.NATIVE_MANOEUVRE_OBSERVATION_LOG_INTERVAL_MS = 250
OuttaMyWay.FOLLOWER_MATURATION_COMPRESSION_PROBE_ENABLED = true
OuttaMyWay.FOLLOWER_MATURATION_COMPRESSION_PROBE_INTERVAL_MS = 100
OuttaMyWay.FOLLOWER_MATURATION_COMPRESSION_PROBE_HEARTBEAT_MS = 500

-- D-0129 passive progression-preservation probe. This publishes/consumes motion and
-- obligation Knowledge and records positive demand-witness geometry only. It has no
-- Decision, speed, clearance or Control authority; response-adjusted progression is unresolved.
OuttaMyWay.PROGRESSION_PRESERVATION_PROBE_ENABLED = true
OuttaMyWay.PROGRESSION_PRESERVATION_PROBE_HEARTBEAT_MS = 1000

-- Bounded active test authority. The cap is derived from live geometry plus
-- uncontaminated demonstrated demand. 0.99/3 are admission Representation-
-- Fitness test mechanics only and are not policy.
OuttaMyWay.FOLLOWER_MATURATION_REGULATION_TEST_ENABLED = false
OuttaMyWay.FOLLOWER_MATURATION_TEST_MIN_HEADING_DOT = 0.99
OuttaMyWay.FOLLOWER_MATURATION_TEST_REQUIRED_COHERENT_SAMPLES = 3
-- Historical follower-shadow calibration remains available for forensic comparison.
OuttaMyWay.FOLLOWER_MATURATION_TRANSITION_CLEARANCE_FACTOR = 0.90
OuttaMyWay.FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED = true
-- Live D-0141 clearance margin. Applied only after the unscaled calculation has
-- already established that Regulation is required, so it cannot manufacture a
-- restriction for an otherwise naturally safe/distant follower.
OuttaMyWay.FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR = 0.90
-- Representation-Fitness test threshold for "coherent line-astern", not architectural policy.
OuttaMyWay.FOLLOWER_BOUNDARY_CURRENT_ALIGNMENT_MIN_DOT = 0.99
-- Existing-purpose hysteresis only: a sub-metre corridor/near-threshold heading fluctuation
-- is insufficient positive evidence to retire an already-admitted follower obligation.
OuttaMyWay.FOLLOWER_BOUNDARY_ESTABLISHED_LATERAL_RETENTION_M = 1.0
OuttaMyWay.FOLLOWER_BOUNDARY_ESTABLISHED_ALIGNMENT_MIN_DOT = 0.95
-- Existing-purpose strategy succession retention. A clean near-opposed continuation
-- is not positive retirement evidence; the admitted lease remains until the existing
-- lifecycle supplies a stronger event such as Progress Passage.
OuttaMyWay.FOLLOWER_BOUNDARY_ESTABLISHED_OPPOSED_SUCCESSION_MAX_DOT = -0.95
-- Provisional Demand Seed temporal component. Evidence/test mechanic only; D-0124 explicitly denies fixed-value authority.
OuttaMyWay.FOLLOWER_BOUNDARY_PROVISIONAL_DURATION_SEC = 13.0


-- D-0146 Step-1 implementation calibration. These are empirical filtering/measurement
-- mechanics, not architecture. Step-2 may consume the resulting sealed Situation Knowledge.
OuttaMyWay.TRAJECTORY_MIN_SAMPLE_DISTANCE_M = 0.10
OuttaMyWay.TRAJECTORY_ESTABLISH_DISTANCE_M = 3.0
OuttaMyWay.TRAJECTORY_COHERENCE_MIN_DOT = 0.94
OuttaMyWay.TRAJECTORY_PERSISTENCE_ALIGNMENT_MIN_DOT = 0.85
OuttaMyWay.TRAJECTORY_SUPERSESSION_DISTANCE_M = 4.0
OuttaMyWay.TRAJECTORY_STABLE_MEMORY_DISTANCE_M = 12.0
OuttaMyWay.OPPOSED_TRAJECTORY_MAX_DOT = -0.85
OuttaMyWay.OPPOSED_CURRENT_MAX_DOT = -0.85
OuttaMyWay.OPPOSED_CURRENT_STABLE_DISTANCE_M = 1.0
OuttaMyWay.OPPOSED_MIN_CLOSING_RATE_MPS = 0.05


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
OuttaMyWay.BUILD_LABEL = "0.3.0.58 TEST — FIELD WORLD VALUE OWNERSHIP"
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
