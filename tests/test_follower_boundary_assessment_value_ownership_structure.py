from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

ROOT_NAMES = (
    "FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR",
    "FOLLOWER_BOUNDARY_CURRENT_ALIGNMENT_MIN_DOT",
    "FOLLOWER_BOUNDARY_ESTABLISHED_LATERAL_RETENTION_M",
    "FOLLOWER_BOUNDARY_ESTABLISHED_ALIGNMENT_MIN_DOT",
    "FOLLOWER_BOUNDARY_ESTABLISHED_OPPOSED_SUCCESSION_MAX_DOT",
    "FOLLOWER_BOUNDARY_PROVISIONAL_DURATION_SEC",
)

def test_issue87_follower_boundary_assessment_calibration_leaves_mixed_root_and_situation_courier():
    config = read("scripts/config.lua")
    situation = read("scripts/assessment/SituationAssessment.lua")
    for token in ROOT_NAMES:
        assert token not in config
        assert f"OuttaMyWay.{token}" not in situation

def test_issue87_follower_boundary_assessment_owns_exact_accepted_values():
    assessment = read("scripts/assessment/FollowerBoundaryDemandAssessment.lua")
    required = (
        "local FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR=0.90",
        "local FOLLOWER_BOUNDARY_CURRENT_ALIGNMENT_MIN_DOT=0.99",
        "local FOLLOWER_BOUNDARY_ESTABLISHED_LATERAL_RETENTION_M=1.0",
        "local FOLLOWER_BOUNDARY_ESTABLISHED_ALIGNMENT_MIN_DOT=0.95",
        "local FOLLOWER_BOUNDARY_ESTABLISHED_OPPOSED_SUCCESSION_MAX_DOT=-0.95",
        "local FOLLOWER_BOUNDARY_PROVISIONAL_DURATION_SEC=13.0",
        "options.clearanceFactor or FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR",
        "options.minHeadingDot or FOLLOWER_BOUNDARY_CURRENT_ALIGNMENT_MIN_DOT",
        "options.provisionalDurationSec or FOLLOWER_BOUNDARY_PROVISIONAL_DURATION_SEC",
        "options.establishedLateralRetentionM) or FOLLOWER_BOUNDARY_ESTABLISHED_LATERAL_RETENTION_M",
        "options.establishedAlignmentMinDot) or FOLLOWER_BOUNDARY_ESTABLISHED_ALIGNMENT_MIN_DOT",
        "options.establishedOpposedSuccessionMaxDot) or FOLLOWER_BOUNDARY_ESTABLISHED_OPPOSED_SUCCESSION_MAX_DOT",
    )
    for token in required:
        assert token in assessment
    for token in ROOT_NAMES:
        assert f"OuttaMyWay.{token}" not in assessment

def test_issue87_focused_overrides_remain_and_aligned_candidate_expression_is_unconditional():
    assessment = read("scripts/assessment/FollowerBoundaryDemandAssessment.lua")
    config = read("scripts/config.lua")
    support = read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    harness = read("tests/replacement_core/run.lua")

    for token in (
        "minHeadingDot=values.minHeadingDot",
        "provisionalDurationSec=values.provisionalDurationSec",
        "establishedLateralRetentionM=values.establishedLateralRetentionM",
        "establishedAlignmentMinDot=values.establishedAlignmentMinDot",
        "establishedOpposedSuccessionMaxDot=values.establishedOpposedSuccessionMaxDot",
        "clearanceFactor=values.clearanceFactor",
    ):
        assert token in assessment

    assert "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED" not in config
    assert "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED" not in support
    assert "local function followerBoundaryRecord(picture)" in support
    assert "local follower,followerReason=followerBoundaryRecord(picture)" in support

    # Independent behavioural fixtures continue to inject accepted values directly.
    for token in (
        "provisionalDurationSec=13",
        "minHeadingDot=0.99",
        "establishedLateralRetentionM=1.0",
        "establishedAlignmentMinDot=0.95",
        "establishedOpposedSuccessionMaxDot=-0.95",
        "clearanceFactor=0.90",
    ):
        assert token in harness

    assert "applyClearanceFactor(25,10,0.90)" in harness
