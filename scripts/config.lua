-- Runtime root identity and remaining mixed constants pending Issue #87 ownership closure.
-- Core capability availability is established by current responsibility,
-- Bounded Authority and typed Control topology, not per-capability booleans.

OuttaMyWay = OuttaMyWay or {}
OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"
OuttaMyWay.VERSION = "0.3.0.72"

-- Live diagnostic instrument controls are module-owned. Their exact accepted
-- enablement and publication/sample cadences live with the five instruments;
-- they are not player Configuration and do not define Runtime scheduling.

-- Follower Boundary Situation-assessment calibration is module-owned; aligned
-- Candidate expression is a core production path with no separate capability gate.


-- Trajectory Conflict Assessment owns its sampling, persistence and opposed-current
-- interpretation calibration locally. Passage Action-Space policy remains external.


-- Remaining cross-responsibility Passage policy: ownership of the local
-- Action-Space / entry bound remains unresolved. Guide radii are Planner-owned;
-- captured-axis station completion tolerance is independently Control-owned.
OuttaMyWay.COOPERATIVE_PASSAGE_LOCAL_MAX_ENTRY_SEPARATION_M = 80.0

-- Forward Intersection Regulation policy.
OuttaMyWay.FORWARD_INTERSECTION_REGULATION_SPEED_KMH = 1
