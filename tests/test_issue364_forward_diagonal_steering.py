from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_forward_diagonal_helper_is_loaded_before_local_passage_planner():
    main = read("scripts/main.lua")
    helper = '"scripts/candidates/ForwardDiagonalSteeringHelper.lua"'
    planner = '"scripts/candidates/LocalPassagePlanner.lua"'
    assert helper in main
    assert main.index(helper) < main.index(planner)


def test_2_to_1_ratio_is_owned_by_helper_and_has_no_reserve_vocabulary():
    helper = read("scripts/candidates/ForwardDiagonalSteeringHelper.lua")
    assert "local FORWARD_PER_LATERAL_M=2.0" in helper
    assert 'kind="FORWARD_DIAGONAL_2_TO_1"' in helper
    assert "forwardDistanceM=required and burden*FORWARD_PER_LATERAL_M or 0" in helper
    for forbidden in ("CAPTURE_RESERVE", "ENTRY_BOUNDARY", "passageEntry", "captureReserve"):
        assert forbidden not in helper


def test_prospective_planner_keeps_reserve_independent_of_helper():
    planner = read("scripts/candidates/LocalPassagePlanner.lua")
    profile_start = planner.index("local function participantExcursionProfile")
    geometry_start = planner.index("local function excursionGeometry", profile_start)
    profile = planner[profile_start:geometry_start]
    assert "developmentDistanceM=0" in profile
    assert "reacquisitionDistanceM=0" in profile
    geometry_end = planner.index("local function makeGuide", geometry_start)
    prospective_geometry = planner[geometry_start:geometry_end]
    assert "ForwardDiagonalSteeringHelper" not in prospective_geometry
    assert "local entryBoundary=frontOverlap" in prospective_geometry


def test_helper_materialises_at_realised_execution_origin_before_pair_sweep():
    planner = read("scripts/candidates/LocalPassagePlanner.lua")
    control = read("scripts/control/CooperativePassageControl.lua")
    assert "function Planner.realiseExecutionSteeringGuide" in planner
    assert 'activation="REALISED_TRANSIT_EXECUTION_ORIGIN"' in planner
    assert "reserveAuthority=false" in planner
    materialise = "planner.realiseExecutionSteeringGuide("
    validate = "planner.validateRebasedGuidePairSweep("
    assert materialise in control and validate in control
    assert control.index(materialise) < control.index(validate)
    assert "COOPERATIVE_PASSAGE_STEERING_HELPER_REALISED" in control


def test_fresh_execution_adaptation_uses_same_helper_before_pair_sweep():
    planner = read("scripts/candidates/LocalPassagePlanner.lua")
    adapt = planner[planner.index("function Planner.adaptExecutionGuide"):]
    realise = "guide,guideReason=realiseExecutionSteeringGuide(guide,arrangement,subjectPose,otherPose)"
    sweep = "local supported,sweepReason,sweepEvidence=pairSweepSupport("
    assert realise in adapt
    assert sweep in adapt
    assert adapt.index(realise) < adapt.index(sweep)


def test_architecture_and_spec_separate_outcome_reserve_and_trajectory():
    architecture = read("architecture/SPATIAL_NEGOTIATION_MODEL.md")
    spec = read("spec/COOPERATIVE_PASSAGE.md")
    for content in (architecture, spec):
        assert "Development Reserve != Steering Trajectory" in content
        assert "Steering Helper May Consume Reserve; It Does Not Define Reserve" in content
        assert "Lateral Excursion Outcome != Steering Trajectory" in content
    assert "2.0 m forward per 1.0 m lateral" in spec
    assert "Required lateral excursion MUST be expressed as Transit sidestep" not in spec
