from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

ROOT_NAMES = (
    "TRAJECTORY_MIN_SAMPLE_DISTANCE_M",
    "TRAJECTORY_ESTABLISH_DISTANCE_M",
    "TRAJECTORY_COHERENCE_MIN_DOT",
    "TRAJECTORY_PERSISTENCE_ALIGNMENT_MIN_DOT",
    "TRAJECTORY_SUPERSESSION_DISTANCE_M",
    "TRAJECTORY_STABLE_MEMORY_DISTANCE_M",
    "OPPOSED_TRAJECTORY_MAX_DOT",
    "OPPOSED_CURRENT_MAX_DOT",
    "OPPOSED_CURRENT_STABLE_DISTANCE_M",
    "OPPOSED_MIN_CLOSING_RATE_MPS",
)

def test_trajectory_conflict_calibration_is_module_owned_without_situation_courier():
    config = read("scripts/config.lua")
    situation = read("scripts/assessment/SituationAssessment.lua")
    for token in ROOT_NAMES:
        assert token not in config
        assert f"OuttaMyWay.{token}" not in situation

def test_issue87_trajectory_conflict_assessment_owns_exact_accepted_values():
    assessment = read("scripts/assessment/TrajectoryConflictAssessment.lua")
    required = (
        "local TRAJECTORY_MIN_SAMPLE_DISTANCE_M=0.10",
        "local TRAJECTORY_ESTABLISH_DISTANCE_M=3.0",
        "local TRAJECTORY_COHERENCE_MIN_DOT=0.94",
        "local TRAJECTORY_PERSISTENCE_ALIGNMENT_MIN_DOT=0.85",
        "local TRAJECTORY_SUPERSESSION_DISTANCE_M=4.0",
        "local TRAJECTORY_STABLE_MEMORY_DISTANCE_M=12.0",
        "local OPPOSED_TRAJECTORY_MAX_DOT=-0.85",
        "local OPPOSED_CURRENT_MAX_DOT=-0.85",
        "local OPPOSED_CURRENT_STABLE_DISTANCE_M=1.0",
        "local OPPOSED_MIN_CLOSING_RATE_MPS=0.05",
    )
    for token in required:
        assert token in assessment

    defaults = (
        'threshold(context,"minSampleDistanceM",TRAJECTORY_MIN_SAMPLE_DISTANCE_M)',
        'threshold(context,"establishDistanceM",TRAJECTORY_ESTABLISH_DISTANCE_M)',
        'threshold(context,"coherenceMinDot",TRAJECTORY_COHERENCE_MIN_DOT)',
        'threshold(context,"persistenceAlignmentMinDot",TRAJECTORY_PERSISTENCE_ALIGNMENT_MIN_DOT)',
        'threshold(context,"supersessionDistanceM",TRAJECTORY_SUPERSESSION_DISTANCE_M)',
        'threshold(context,"stableMemoryDistanceM",TRAJECTORY_STABLE_MEMORY_DISTANCE_M)',
        'threshold(context,"opposedMaxDot",OPPOSED_TRAJECTORY_MAX_DOT)',
        'threshold(context,"currentOpposedMaxDot",OPPOSED_CURRENT_MAX_DOT)',
        'threshold(context,"currentStableDistanceM",OPPOSED_CURRENT_STABLE_DISTANCE_M)',
        'threshold(context,"minClosingRateMps",OPPOSED_MIN_CLOSING_RATE_MPS)',
    )
    for token in defaults:
        assert token in assessment

def test_assessment_owns_fixed_passage_boundary_without_context_override():
    assessment = read("scripts/assessment/TrajectoryConflictAssessment.lua")
    situation = read("scripts/assessment/SituationAssessment.lua")
    harness = read("tests/replacement_core/run.lua")

    assert 'local value=context and context[name] or nil' in assessment
    assert "local LOCAL_PASSAGE_ACTION_SPACE_MAX_SEPARATION_M = 80.0" in assessment
    assert assessment.count("local maxSeparationM=LOCAL_PASSAGE_ACTION_SPACE_MAX_SEPARATION_M") == 3
    assert "result.maxSeparationM=maxSeparationM" in assessment
    for path in (ROOT / "scripts").rglob("*.lua"):
        source = path.read_text(encoding="utf-8")
        assert "actionSpaceMaxSeparationM" not in source, path
        assert "COOPERATIVE_PASSAGE_LOCAL_MAX_ENTRY_SEPARATION_M" not in source, path
    assert "actionSpaceMaxSeparationM" not in harness
    planner = read("scripts/candidates/LocalPassagePlanner.lua")
    assert "conflict.actionSpaceConservation.maxSeparationM" in planner
    assert 'if not finite(maxSeparation) or maxSeparation<=0 then return nil,"LOCAL_PASSAGE_ACTION_SPACE_BOUNDARY_UNAVAILABLE" end' in planner
    assert 'if separation>maxSeparation then return nil,"ESTABLISHED_CONFLICT_NOT_YET_LOCAL" end' in planner
    assert "80.0" not in planner

    # Behavioural fixtures remain independent of production root placement.
    for token in (
        "minSampleDistanceM=0.10",
        "establishDistanceM=3.0",
        "coherenceMinDot=0.94",
        "persistenceAlignmentMinDot=0.85",
        "supersessionDistanceM=4.0",
        "stableMemoryDistanceM=12.0",
        "opposedMaxDot=-0.85",
        "currentOpposedMaxDot=-0.85",
        "currentStableDistanceM=1.0",
        "minClosingRateMps=0.05",
    ):
        assert token in harness
