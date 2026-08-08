-- FS25_OuttaMyWay v4.7.41 Guarded Recovery Observe-exhaustion contract candidate; canonical v4.7.40 baseline; production Decision/Control remains disabled.
-- Canonical architecture authority: v4.6.78.

OuttaMyWay = OuttaMyWay or {}
OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"
OuttaMyWay.VERSION = "4.7.41"
OuttaMyWay.ARCHITECTURE_VERSION = "4.6.78"
OuttaMyWay.RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"
OuttaMyWay.CONTROL_AUTHORITY_ENABLED = false
OuttaMyWay.PASSIVE_SAMPLE_INTERVAL_MS = 1000
OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS = 10000
OuttaMyWay.PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE = 8

-- Temporary live-gate HUDs. Diagnostic instrumentation only.
-- v4.7.24 retains the lifecycle gate only to verify cleanup causes no behavioural change
-- to Future-Space admission, termination precedence or fresh-Episode identity.
OuttaMyWay.LIFECYCLE_TEST_HUD_ENABLED = true
OuttaMyWay.FUTURE_SPACE_HUD_ENABLED = false
OuttaMyWay.TRANSITION_HUD_ENABLED = true
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

-- Prototype 22: manual-only Traffic Policeman capability validation. These
-- literals are experimental safety/observation bounds only and carry no
-- production Decision or policy authority. Production CONTROL_AUTHORITY remains
-- false; P22 cannot arm without an explicit console command.
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
-- after an explicit operator command. They are evidence-fixture values only:
-- they grant no production Refuge Region, clearance, Durable Separation or
-- Safe Release authority.
OuttaMyWay.PROTOTYPE_22_TS015_RELOCATE_ENABLED = true
OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_SPEED_KMH = 15.0
OuttaMyWay.PROTOTYPE_22_TS015_REPOSITION_TARGET_RADIUS_M = 1.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FORWARD_M = 10.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_LATERAL_M = 30.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_RADIUS_M = 8.0
OuttaMyWay.PROTOTYPE_22_TS015_REFUGE_FIT_SAMPLE_COUNT = 12
OuttaMyWay.PROTOTYPE_22_TS015_SETTLE_TIMEOUT_MS = 15000
OuttaMyWay.PROTOTYPE_22_TS015_MOVE_TIMEOUT_MS = 45000
OuttaMyWay.PROTOTYPE_22_TS015_MIN_TOTAL_REFUGE_HOLD_MS = 20000
-- v4.7.40 restoration-first comparison: preserve the settled pre-egress pose as
-- a Rejoin Anchor, return compact toward a short forward rejoin reference using
-- the archived empirically successful orientation mechanism, then restore the
-- original configuration before GIANTS handback. All values remain fixture-only.
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_FORWARD_M = 6.0
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_SPEED_KMH = 5.0
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_STEER_LZ = 0.30
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_FORWARD_DOT = 0.25
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_TIMEOUT_MS = 12000
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_ORIENTATION_MAX_TRAVEL_M = 20.0
OuttaMyWay.PROTOTYPE_22_TS015_REJOIN_SETTLE_TIMEOUT_MS = 15000
OuttaMyWay.PROTOTYPE_22_TS015_OBSERVE_MS = 120000
OuttaMyWay.PROTOTYPE_22_TS015_OBSERVE_LOG_MS = 2000

-- Transition-only operator signalling: raw forensic logs remain available but
-- the tester need not follow the scrolling console during live actuation.
OuttaMyWay.PROTOTYPE_22_HUD_ENABLED = true
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
