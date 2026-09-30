from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT/relative).read_text(encoding="utf-8")


def test_realised_motion_demand_is_loaded_before_causal_obstruction_and_situation_composition():
    main=read("scripts/main.lua")
    module="scripts/assessment/RealisedMotionDemandAssessment.lua"
    causal="scripts/assessment/CausalObstructionAssessment.lua"
    situation="scripts/assessment/SituationAssessment.lua"
    assert module in main
    assert main.index(module) < main.index(causal) < main.index(situation)


def test_realised_motion_demand_remains_situation_evidence_only():
    source=read("scripts/assessment/RealisedMotionDemandAssessment.lua")
    assert "-- Specification Jurisdictions: \u0060SITUATION_ASSESSMENT\u0060" in source
    for forbidden in (
        "CandidateAction",
        "CandidateSpace",
        "DecisionSelector",
        "ControlRequest",
        "BoundedAuthority",
        "ObstructionRelocationCandidateSupport",
        "driveToPoint",
        "g_currentMission",
    ):
        assert forbidden not in source

    assert "LOOKAHEAD_MAX_M=100.0" in source
    assert "math.min(alignedDistanceM,LOOKAHEAD_MAX_M)" in source
    assert "realisedMotionReachM=reachM" in source
    assert 'reachBasis="CURRENT_ALIGNED_DISTANCE_M"' in source
    assert "turningPromoted=false" in source
    assert "futureRouteAuthority=false" in source
    assert "negativeClearanceAuthority=false" in source
    assert "currentExcursion~=true" in source
    assert "progressActuationOwnership" in source


def test_operational_picture_exposes_realised_motion_demand_and_causal_obstruction_consumes_it_only_as_evidence():
    picture=read("scripts/contracts/OperationalPicture.lua")
    situation=read("scripts/assessment/SituationAssessment.lua")
    causal=read("scripts/assessment/CausalObstructionAssessment.lua")

    assert '"realisedMotionDemandKnowledge"' in picture
    assert "local realisedMotionDemandKnowledge=OuttaMyWay.RealisedMotionDemandAssessment.build({" in situation
    assert "realisedMotionDemandKnowledge=realisedMotionDemandKnowledge" in situation
    assert "REALISED_MOTION_DEMAND" in causal
    assert "futureSweepConflict" in causal
    assert "realisedMotionDemandConflict" in causal
    assert causal.index("futureSweepConflict(blockerPhysical,beneficiaryPhysical,beneficiaryFuture)") < causal.index("realisedMotionDemandConflict(blockerPhysical,realisedDemand)")


def test_situation_spec_traces_realised_motion_demand_production_participant():
    spec=read("spec/SITUATION_ASSESSMENT.md")
    row="| [\u0060scripts/assessment/RealisedMotionDemandAssessment.lua\u0060](../scripts/assessment/RealisedMotionDemandAssessment.lua) | \u0060REALISES\u0060 |"
    assert row in spec
    assert "Established Trajectory != Future Route Authority." in spec
    assert "Prospective Demand != Realised Motion Demand." in spec
    assert "current production source does not yet consume Realised Motion Demand" not in spec
