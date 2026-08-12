-- FS25_OuttaMyWay v4.7.95 CANONICAL CANDIDATE — D-0143 Cooperative Passage Production Direction; owner-declared v4.7.77 is canonical.
-- Runtime traffic/Commitment/Control behaviour remains the v4.7.77 implementation; v4.7.95 changes architecture/documentation and release identity only.
-- King/continuous Refuge production direction is retired by D-0143; existing runtime/probe machinery remains untouched as historical implementation evidence/donors.
-- P23 v4.7.91-v4.7.94 is evidence only and is not sourced into this canonical-based candidate.
-- Next implementation objective after canonicalisation: TS015 Cooperative Passage Production Integration through the normal architecture chain.
-- Canonical-candidate architecture authority: v4.7.95 D-0143 over surviving v4.7.77 D-0142.

OuttaMyWay = OuttaMyWay or {}
OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"
OuttaMyWay.VERSION = "4.7.95"
OuttaMyWay.ARCHITECTURE_VERSION = "4.7.95"
OuttaMyWay.RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"
OuttaMyWay.CONTROL_AUTHORITY_ENABLED = false
OuttaMyWay.PASSIVE_SAMPLE_INTERVAL_MS = 1000
-- Active live traffic/control reassessment cadence. Kept separate from passive logging cadence so
-- bounded Control can react to GIANTS native rate changes before a boundary transition matures.
OuttaMyWay.LIVE_RUNTIME_CONTROL_INTERVAL_MS = 250
OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS = 10000
OuttaMyWay.PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE = 8

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

-- Passive representation-foundation limits. Geometry discovery is Job Episode
-- scoped; only current transforms and configuration selection repeat per sample.
OuttaMyWay.REPRESENTATION_ASSEMBLY_MEMBER_BUDGET = 32
OuttaMyWay.REPRESENTATION_HIERARCHY_SCAN_BUDGET = 2200
OuttaMyWay.REPRESENTATION_ASSEMBLY_REVALIDATION_INTERVAL_SECONDS = 5
OuttaMyWay.REPRESENTATION_GEOMETRY_COHERENCE_TOLERANCE_METRES = 0.05
OuttaMyWay.REPRESENTATION_ROOT_ALIAS_TOLERANCE_METRES = 0.0001

OuttaMyWay.FIELD_IDENTITY_PROBE_HEARTBEAT_INTERVAL_MS = 10000

-- Prototype 21: passive Productive Continuation evidence discovery. These are
-- diagnostic sampling/logging intervals only; speed values are observations and
-- carry no Productive/Transitional classification authority.
OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_ENABLED = true
OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_INTERVAL_MS = 250
OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_HEARTBEAT_MS = 2000

-- D-0134 passive chessboard-style productive-history evidence. The grid is
-- Job-Episode scoped and only paints cells swept between consecutive live AI/work-area
-- marker segments while Productive Continuation is positively supported. These are
-- diagnostic resolution/cadence values only; unpainted cells remain UNKNOWN and no
-- coverage result grants Refuge, Decision or Control authority.
OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_ENABLED = true
OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_INTERVAL_MS = 250
OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M = 5.0
OuttaMyWay.DEMONSTRATED_PRODUCTIVE_COVERAGE_MAX_SAMPLE_GAP_M = 12.0

-- D-0138 passive GIANTS Native Field-Worker Drive Command shadow probe.
-- Reads spec_aiFieldWorker.aiDriveParams only after GIANTS has populated it;
-- the observer never calls getDriveData() and never changes driveToPoint input.
OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_ENABLED = true
OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_INTERVAL_MS = 250
OuttaMyWay.NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_HEARTBEAT_MS = 1000

-- D-0136 passive intent-based Productive Coverage Residual settlement witness.
-- D-0135 coarse residual geometry remains Potential Demand evidence, but geometric
-- fill percentage is not settlement authority. These values are diagnostic
-- cadence/resolution only; the witness follows native intent lifecycle evidence.
OuttaMyWay.PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_ENABLED = true
OuttaMyWay.PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_INTERVAL_MS = 250
OuttaMyWay.PRODUCTIVE_COVERAGE_RESIDUAL_HEARTBEAT_MS = 2000

-- D-0134 passive Refuge Resulting-Situation qualification shadow. Existing fixture
-- selection is untouched. Additional infield points are evidence probes only.
OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_PROBE_ENABLED = true
OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_INFIELD_OFFSETS_M = {20.0, 35.0, 50.0}
OuttaMyWay.REFUGE_QUALIFICATION_SHADOW_COVERAGE_SAMPLE_COUNT = 12

-- Prototype 22: capability validation plus bounded autonomous head-on
-- Resolution Strategy dispatch. Manual probe commands remain diagnostic only. These
-- literals are experimental safety/observation bounds only and carry no
-- production Decision or policy authority. Production CONTROL_AUTHORITY remains
-- false; automatic head-on dispatch does not grant general production Control authority.

-- D-0123 Guarded-Recovery Convergence Shadow Validation. Diagnostic cadence only.
-- No distance, time, speed or intersection result below carries policy or Control authority.
OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_ENABLED = true
OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_INTERVAL_MS = 100
OuttaMyWay.GUARDED_RECOVERY_CONVERGENCE_PROBE_HEARTBEAT_MS = 500

-- Architecture alignment: D-0127 native manoeuvre observation is retained,
-- but TURNING/head-reversal no longer qualifies boundary-demand authority.
-- The legacy HeadlandManoeuvreSweepProbe is disabled/removed from active runtime.
OuttaMyWay.HEADLAND_MANOEUVRE_SWEEP_PROBE_ENABLED = false
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

-- D-0128 bounded head-on playbook evidence gate. This is a TEST REPRESENTATION-
-- FITNESS literal, not production head-on policy: the live Refuge bridge is only
-- offered for a clean, positively opposed continuation. The magnitude mirrors the
-- already-bounded 0.99 coherent-heading test band without coupling the two policies.
OuttaMyWay.AUTONOMOUS_HEAD_ON_TEST_MAX_HEADING_DOT = -0.99

-- Persistent neutral build identity plus explanatory test HUD.
OuttaMyWay.BUILD_LABEL = "CANONICAL CANDIDATE"
OuttaMyWay.VERSION_HUD_ENABLED = true
OuttaMyWay.VERSION_HUD_X = 0.985
OuttaMyWay.VERSION_HUD_Y = 0.720
OuttaMyWay.VERSION_HUD_TEXT_SIZE = 0.014
OuttaMyWay.FOLLOWER_PACING_HUD_ENABLED = true
OuttaMyWay.FOLLOWER_PACING_HUD_X = 0.985
OuttaMyWay.FOLLOWER_PACING_HUD_Y = 0.697
OuttaMyWay.FOLLOWER_PACING_HUD_TEXT_SIZE = 0.013
OuttaMyWay.FOLLOWER_PACING_HUD_MAX_ROWS = 3

-- v4.7.49 carries forward the live-PASS D-0123 active-recovery Regulation fallback unchanged. Test-fixture authority only.
-- TEMPORARY IMPLEMENTATION VALUE: the successful v4.7.48 test validated sequencing/integration, not 1 km/h as production speed policy.
OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_ENABLED = true
OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_KMH = 1.0
OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_HEARTBEAT_MS = 500

-- D-0133 retains the latest positively supported Progress field-bounded continuation
-- horizon before committed-transition admission; D-0132 may seal that retained
-- endpoint across the immediate handoff while the same Job Episode and tracked
-- Local Intent epoch remain positively valid. D-0131 threat semantics remain unchanged.
-- D-0131 committed-transition Regulation TEST bridge. The bridge reuses the
-- existing 1 km/h temporary implementation value only after a positive bounded
-- timing witness shows Productive Progress could reach an admitted TS015 egress
-- sweep no later than even ideal max-speed egress completion. No new speed literal.
OuttaMyWay.COMMITTED_TRANSITION_REGULATION_TEST_ENABLED = false

OuttaMyWay.PROTOTYPE_22_CAPABILITY_GATE_ENABLED = true
OuttaMyWay.PROTOTYPE_22_REGULATE_DEFAULT_KMH = 1.0
OuttaMyWay.PROTOTYPE_22_REGULATE_MIN_KMH = 0.5
OuttaMyWay.PROTOTYPE_22_REGULATE_MAX_KMH = 10.0
OuttaMyWay.PROTOTYPE_22_HOLD_EFFECT_SPEED_KMH = 0.25
OuttaMyWay.PROTOTYPE_22_REPOSITION_SPEED_KMH = 5.0
OuttaMyWay.PROTOTYPE_22_REPOSITION_MAX_SPEED_KMH = 8.0
OuttaMyWay.PROTOTYPE_22_REPOSITION_MAX_OFFSET_M = 20.0
OuttaMyWay.PROTOTYPE_22_REPOSITION_TARGET_RADIUS_M = 1.0
OuttaMyWay.PROTOTYPE_22_HEARTBEAT_MS = 1000
OuttaMyWay.PROTOTYPE_22_RELEASE_MONITOR_MS = 5000
OuttaMyWay.PROTOTYPE_22_RELEASE_RESUME_TRAVEL_M = 0.5
OuttaMyWay.PROTOTYPE_22_RELEASE_RESUME_SPEED_KMH = 0.5

-- P22-C configuration/spatial evidence parameters. These are probe-only
-- observation bounds, never Traffic Policeman policy thresholds. Movement may
-- overlap folding after actual fold motion is observed; spatial PASS still
-- requires full compact configuration plus positive represented-span reduction.
OuttaMyWay.PROTOTYPE_22_FOLD_MOTION_TIMEOUT_MS = 5000
OuttaMyWay.PROTOTYPE_22_FULL_COMPACT_TIMEOUT_MS = 25000
OuttaMyWay.PROTOTYPE_22_SPATIAL_VERIFY_TIMEOUT_MS = 5000
OuttaMyWay.PROTOTYPE_22_RESTORE_TIMEOUT_MS = 25000
OuttaMyWay.PROTOTYPE_22_SPAN_REDUCTION_MIN_M = 1.0

-- TS015 autonomous native-recovery characterisation fixture. These literals
-- deliberately simulate one complete Traffic Policeman passing-place instruction
-- after a genuine live autonomous head-on Decision. They are evidence-fixture values only:
-- they grant no production Refuge Region, clearance, Durable Separation or
-- Safe Release authority.
OuttaMyWay.PROTOTYPE_22_TS015_RELOCATE_ENABLED = true
OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_SPEED_KMH = 15.0 -- TEMPORARY TEST MECHANISM; not policy authority
OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_TARGET_RADIUS_M = 1.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FORWARD_M = 10.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_LATERAL_M = 30.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_RADIUS_M = 8.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_COUNT = 12
OuttaMyWay.PROTOTYPE_22_TS015_SETTLE_TIMEOUT_MS = 15000 -- watchdog/failure detection only
OuttaMyWay.PROTOTYPE_22_TS015_MOVE_TIMEOUT_MS = 45000 -- watchdog/failure detection only
-- v4.7.40 restoration-first comparison: preserve the settled pre-egress pose as
-- a Rejoin Anchor, return compact toward a short forward rejoin reference using
-- the archived empirically successful orientation mechanism, then restore the
-- original configuration before GIANTS handback. All values remain fixture-only.
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_FORWARD_M = 6.0
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_SPEED_KMH = 5.0 -- TEMPORARY TEST MECHANISM; not policy authority
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_STEER_LZ = 0.30
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_FORWARD_DOT = 0.25
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_TIMEOUT_MS = 12000 -- watchdog/failure detection only
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_MAX_TRAVEL_M = 20.0
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_SETTLE_TIMEOUT_MS = 15000 -- watchdog/failure detection only
OuttaMyWay.PROTOTYPE_22_TS015_OBSERVE_MS = 120000 -- forensic observation window only; no settlement authority
OuttaMyWay.PROTOTYPE_22_TS015_OBSERVE_LOG_MS = 2000

-- Transition-only operator signalling: raw forensic logs remain available but
-- the tester need not follow the scrolling console during live actuation.
OuttaMyWay.PROTOTYPE_22_HUD_ENABLED = false
OuttaMyWay.PROTOTYPE_22_HUD_X = 0.985
OuttaMyWay.PROTOTYPE_22_HUD_Y = 0.590
OuttaMyWay.PROTOTYPE_22_HUD_TITLE_SIZE = 0.016
OuttaMyWay.PROTOTYPE_22_HUD_TEXT_SIZE = 0.014
OuttaMyWay.PROTOTYPE_22_HUD_LINE_HEIGHT = 0.021

OuttaMyWay.FIELD_WORLD_SNAPSHOT_GENERATION_BUDGET = 0.00025
OuttaMyWay.FIELD_WORLD_FINGERPRINT_QUANTIZATION_METRES = 0.1
OuttaMyWay.FIELD_WORLD_FINGERPRINT_VERSION = "FWG1"

OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAMPLE_SIDE = 31
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_COMPARISONS = 128

OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MAX_AREA_RELATIVE_DELTA = 0.005
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MAX_PERIMETER_RELATIVE_DELTA = 0.002
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MAX_CENTROID_DISTANCE_METRES = 0.5
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDS_DELTA_METRES = 0.5
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDARY_MEAN_DISTANCE_METRES = 0.5
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDARY_MAX_DISTANCE_METRES = 2.0
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAME_MIN_SAMPLED_JACCARD = 0.995
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_DIFFERENT_MIN_BOUNDARY_SEPARATION_METRES = 0.2
OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_RESOLUTIONS = 128
