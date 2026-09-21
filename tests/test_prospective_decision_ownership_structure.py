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
        'kind="OPPOSED_RELATIONSHIP"',
        "OBSTRUCTION_RELOCATION",
        "FORWARD_INTERSECTION_FAIL_CLOSED",
        "ACTION_SPACE_FAIL_CLOSED",
        "ONE_CONFLICT_SUPPORT_PROJECTION_NO_INTER_CONFLICT_SELECTION",
    ):
        assert token in support
    assert "INCUMBENT_CONTEXT_REQUIRES_EXISTING_SINGLE_PURPOSE_PATH" not in support
    assert "existingCommitmentId" in support
    assert "lowerPrecedenceConstraintFallback" not in support
    for forbidden in ("ControlRequest.new","executeControlRequest","driveInWorldDirection","AIVehicleUtil","g_currentMission"):
        assert forbidden not in support


def test_phase13_decision_owns_admissibility_aware_inter_group_compatibility():
    policy=read("scripts/decision/ProspectivePortfolioDecisionPolicy.lua")
    selector=read("scripts/decision/DecisionSelector.lua")
    for token in (
        'Policy.KIND="PROSPECTIVE_DECISION_PORTFOLIO_COMPATIBILITY"',
        "admissibleGroupKeys",
        "Policy:selectGroup(inventory,admissibleCandidates)",
        'family(groups,"OBSTRUCTION_RELOCATION")',
        'family(groups,"PASSAGE")',
        "SPATIAL_NEGOTIATION_STAGE_TRANSITION",
        "SUPPORTED_ADMISSIBLE_PASSAGE_ENDS_TACTICAL_REGULATION",
        "MULTIPLE_SUPPORTED_ADMISSIBLE_PASSAGES_REQUIRE_COMPARATOR",
        "TACTICAL_REGULATION_SINGLE_PURPOSE",
        "RETAIN_CURRENT_TACTICAL_REGULATION",
        "MULTIPLE_RETAINED_TACTICAL_REGULATION_GROUPS",
        "MULTIPLE_TACTICAL_REGULATION_PURPOSES_REQUIRE_COMPARATOR",
        "TACTICAL_SUPPORT_FAIL_CLOSED",
    ):
        assert token in policy
    for retired in (
        "LEGACY_LIVE_TRAFFIC_COMPATIBILITY",
        "LEGACY_LIVE_TRAFFIC_PRECEDENCE",
        "LEGACY_LIVE_TRAFFIC_FAIL_CLOSED",
        "SAME_PAIR_SUPPORTED_PASSAGE_SUCCEEDS_FRESH_FOLLOWER_PURPOSE",
        "UNRELATED_SUPPORTED_PASSAGE_DOES_NOT_SUPERSEDE_FRESH_FOLLOWER_PURPOSE",
        "FORWARD_INTERSECTION_BEFORE_PASSAGE_WITHOUT_FOLLOWER_PURPOSE",
        "NEAREST_SUPPORTED_PASSAGE_BEFORE_ACTION_SPACE_REGULATION",
        "ACTION_SPACE_REGULATION_BEFORE_FRESH_FOLLOWER_FALLBACK_WHEN_NO_PASSAGE",
    ):
        assert retired not in policy
    for token in (
        "ProspectivePortfolioDecisionPolicy:selectGroup(candidateResult.inventory,viable)",
        "candidateGroupKey(candidate)==groupKey",
        "projectedInventory",
        "admissibilityAwareGroupSelection=true",
        'selection="NO_MANDATORY_ADMISSIBLE_GROUP"',
        "portfolioPolicyReason",
        "reason=portfolioPolicyReason",
    ):
        assert token in selector
    assert "lowerPrecedenceConstraintFallback" not in policy
    assert "lowerPrecedenceConstraintFallback" not in selector
    assert "TrafficPolicemanDecisionPolicy:select" in selector


def test_phase13_runtime_uses_one_portfolio_across_fresh_and_tactical_regulation_scope_but_preserves_active_resolution_horizon():
    runtime=read("scripts/runtime/Runtime.lua")
    for token in (
        "prospectiveDecisionPortfolioSupport",
        "activeResolution",
        "getCurrentResolutionCommitment",
        'boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO"',
        "selectedGroupBoundary",
        "values.supportBoundary=localBoundary",
        "evaluated=normalized",
        "matchesIndependentRegulationPassage",
        "replaceIndependentRegulationWithCooperativePassage",
    ):
        assert token in runtime
    assert "INCUMBENT_CONTEXT_REQUIRES_EXISTING_SINGLE_PURPOSE_PATH" not in runtime
    assert "obstructionRelocationCandidateSupport" in runtime
    assert "completedObstructionCandidateSupport" not in runtime
    assert "runtime.terminalEgressCandidateSupport=" not in runtime


def test_phase13_trigger_and_passage_semantics_survive_generic_obstruction_relocation_execution():
    current=read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    assert not (ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").exists()
    passage=read("scripts/candidates/LocalPassagePlanner.lua")
    terminal_control=read("scripts/control/ObstructionRelocationControl.lua")

    assert 'objectiveKind="CAUSAL_OBSTRUCTION_BOUNDED_INWARD_RELOCATION"' in current
    assert "repeatedActuationRequiresFreshPositiveObstruction=true" in current
    assert "function Planner.plan(picture,snapshot)" in passage
    assert "function Planner.planConflict(picture,snapshot,conflict)" in passage
    assert "local plan,reason,rejected=planConflict(picture,snapshot,conflict)" in passage
    assert "driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)" in terminal_control
    assert 'target.kind~="OBSTRUCTION_RELOCATION"' in terminal_control
    assert "CURRENT_CAUSAL_OBSTRUCTION" not in terminal_control
    assert (ROOT/"scripts"/"control"/"ObstructionRelocationControl.lua").is_file()
    assert not (ROOT/"scripts"/"control"/"TerminalEgressControl.lua").exists()
