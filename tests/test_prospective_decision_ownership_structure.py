from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_phase13_prospective_decision_modules_are_loaded_in_order():
    main=read("scripts/main.lua")
    for relative in (
        "scripts/decision/ProspectivePortfolioDecisionPolicy.lua",
        "scripts/candidates/ProspectiveDecisionPortfolioSupport.lua",
        "scripts/runtime/Runtime.lua",
    ):
        assert relative in main
    assert main.index("scripts/decision/ProspectivePortfolioDecisionPolicy.lua") < main.index("scripts/candidates/ProspectiveDecisionPortfolioSupport.lua")
    assert main.index("scripts/candidates/ProspectiveDecisionPortfolioSupport.lua") < main.index("scripts/decision/DecisionSelector.lua")
    assert "scripts/runtime/ObstructionRelocationRuntimeIntegration.lua" not in main
    assert "scripts/runtime/ProspectiveDecisionPortfolioIntegration.lua" not in main


def test_phase13_fresh_portfolio_enumerates_support_groups_without_control_authority():
    support=read("scripts/candidates/ProspectiveDecisionPortfolioSupport.lua")
    for token in (
        'mode="PROSPECTIVE_DECISION_PORTFOLIO"',
        "candidateSupportGroup",
        'kind="TERMINAL_OCCUPANCY"',
        'kind="OPPOSED_RELATIONSHIP"',
        "COLD_OBSTRUCTION",
        "WARM_D0147",
        "FORWARD_INTERSECTION_FAIL_CLOSED",
        "ACTION_SPACE_FAIL_CLOSED",
        "ONE_CONFLICT_SUPPORT_PROJECTION_NO_INTER_CONFLICT_SELECTION",
        "lowerPrecedenceConstraintFallback=false",
    ):
        assert token in support
    assert 'OuttaMyWay.ValueRecord.length(picture.commitmentContext or {})>0' in support
    for forbidden in ("ControlRequest.new","executeControlRequest","driveInWorldDirection","AIVehicleUtil","g_currentMission"):
        assert forbidden not in support


def test_phase13_decision_owns_inter_group_compatibility_and_no_constraint_fallback():
    policy=read("scripts/decision/ProspectivePortfolioDecisionPolicy.lua")
    selector=read("scripts/decision/DecisionSelector.lua")
    for token in (
        'Policy.KIND="PROSPECTIVE_DECISION_PORTFOLIO_COMPATIBILITY"',
        'family(groups,"COLD_OBSTRUCTION")',
        'family(groups,"WARM_D0147")',
        "SAME_PAIR_SUPPORTED_PASSAGE_SUCCEEDS_FRESH_FOLLOWER_PURPOSE",
        "UNRELATED_SUPPORTED_PASSAGE_DOES_NOT_SUPERSEDE_FRESH_FOLLOWER_PURPOSE",
        "FORWARD_INTERSECTION_BEFORE_PASSAGE_WITHOUT_FOLLOWER_PURPOSE",
        "NEAREST_SUPPORTED_PASSAGE_BEFORE_ACTION_SPACE_REGULATION",
    ):
        assert token in policy
    for token in (
        "ProspectivePortfolioDecisionPolicy:selectGroup",
        "candidateGroupKey(candidate)==groupKey",
        "projectedInventory",
        "lowerPrecedenceConstraintFallback=false",
        "Selected governing support group contains no admissible candidate",
    ):
        assert token in selector
    assert "TrafficPolicemanDecisionPolicy:select" in selector


def test_phase13_runtime_uses_portfolio_only_for_fresh_scope_and_projects_dispatch_boundary():
    runtime=read("scripts/runtime/Runtime.lua")
    for token in (
        "prospectiveDecisionPortfolioSupport",
        'OuttaMyWay.ValueRecord.length(processed.picture.commitmentContext or {})>0',
        'boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO"',
        "selectedGroupBoundary",
        "values.supportBoundary=localBoundary",
        "evaluated=normalized",
    ):
        assert token in runtime
    assert "completedObstructionCandidateSupport" in runtime
    assert "obstructionRelocationCandidateSupport" in runtime


def test_phase13_trigger_and_passage_semantics_survive_shared_terminal_egress_execution():
    completed=read("scripts/candidates/TerminalEgressCandidateSupport.lua")
    current=read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    passage=read("scripts/candidates/LocalPassagePlanner.lua")
    terminal_control=read("scripts/control/TerminalEgressControl.lua")

    assert "local function selectRecord(picture,context)" in completed
    assert "TERMINAL_FINAL_BOUNDARY_SETTLEMENT" in completed
    assert "maximumCourtesyMovesPerEpisode=2" in completed
    assert "courtesyStage=1" in current
    assert "secondCourtesyNotAuthorised=true" in current
    assert "function Planner.plan(picture,snapshot)" in passage
    assert "function Planner.planConflict(picture,snapshot,conflict)" in passage
    assert "local plan,reason,rejected=planConflict(picture,snapshot,conflict)" in passage
    assert "driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)" in terminal_control
    assert 'target.kind~="TERMINAL_EGRESS"' in terminal_control
    assert "CURRENT_CAUSAL_OBSTRUCTION" not in terminal_control
    assert not (ROOT/"scripts"/"control"/"ObstructionRelocationControl.lua").exists()
