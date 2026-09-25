from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT/relative).read_text(encoding="utf-8")


def test_blocked_progress_assessment_is_loaded_before_situation_composition():
    main=read("scripts/main.lua")
    module="scripts/assessment/BlockedProgressAssessment.lua"
    situation="scripts/assessment/SituationAssessment.lua"
    assert module in main
    assert main.index(module) < main.index(situation)


def test_blocked_progress_assessment_remains_situation_only():
    source=read("scripts/assessment/BlockedProgressAssessment.lua")
    assert "-- Specification Jurisdictions: `SITUATION_ASSESSMENT`" in source
    for forbidden in (
        "CandidateAction",
        "CandidateSpace",
        "DecisionSelector",
        "ControlRequest",
        "BoundedAuthority",
        "driveToPoint",
        "g_currentMission",
        "outtaMyWayHold",
    ):
        assert forbidden not in source

    assert 'publication:publish("NORMAL"' not in source
    assert 'publication:publish("DEBUG","INFO","BLOCKED_PROGRESS_STALL_ESTABLISHED"' in source
    assert 'publication:publish("DEBUG","INFO","RECOVERY_ANCHOR_SELECTED"' in source
    assert 'publication:publish("DIAGNOSTIC","INFO","BLOCKED_PROGRESS_STALL_EVIDENCE"' in source


def test_blocked_progress_calibration_is_local_and_bounded():
    source=read("scripts/assessment/BlockedProgressAssessment.lua")
    for literal in (
        "TRAIL_CAPACITY_COUNT=40",
        "COLLAPSE_MIN_OBSERVATION_SECONDS=1.0",
        "ANCHOR_MIN_USEFUL_SPAN_M=5.0",
    ):
        assert literal in source

    assert "while #track.trail>=TRAIL_CAPACITY_COUNT do table.remove(track.trail,1) end" in source
    assert "positionDerivedSpeedMps" in source
    assert "positiveRealizedMovement" in source
    assert "collapsedRealizedMovement" in source
    assert 'motion.motionClassification=="TURNING"' in source
    assert 'motion.motionClassification=="STATIONARY"' in source
    assert "progressActuationOwnership" in source
    assert "operationByAssembly" in source
    assert "productiveWorkCommenced" not in source
    assert "productiveWorkCommencement" not in source


def test_situation_publishes_blocked_progress_knowledge_and_resets_retention():
    situation=read("scripts/assessment/SituationAssessment.lua")
    picture=read("scripts/contracts/OperationalPicture.lua")

    assert "self.blockedProgressAssessment=OuttaMyWay.BlockedProgressAssessment.new(jobEpisodes)" in situation
    assert "local blockedProgressKnowledge=self.blockedProgressAssessment:assess({" in situation
    assert "blockedProgressKnowledge=blockedProgressKnowledge" in situation
    assert "self.blockedProgressAssessment:reset()" in situation
    assert '"blockedProgressKnowledge"' in picture


def test_situation_spec_owns_blocked_progress_implementation_while_recovery_remains_unimplemented():
    situation_spec=read("spec/SITUATION_ASSESSMENT.md")
    recovery_spec=read("spec/BLOCKED_WORKER_RECOVERY.md")

    row="| [`scripts/assessment/BlockedProgressAssessment.lua`](../scripts/assessment/BlockedProgressAssessment.lua) | `REALISES` |"
    assert row in situation_spec
    assert "**Implementation Status:** `NOT_IMPLEMENTED`" in recovery_spec
    assert "No production source currently realises the `BLOCKED_WORKER_RECOVERY` Jurisdiction." in recovery_spec
    assert row not in recovery_spec
