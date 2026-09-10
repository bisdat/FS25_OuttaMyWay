from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_projection_materializes_exactly_one_portfolio_picture_and_no_support_views():
    support=read("scripts/candidates/ProspectiveDecisionPortfolioSupport.lua")
    assert 'local targetPictureId=self.identities:issue("PICTURE")' in support
    assert "local targetEpoch=self.epochs:next()" in support
    assert support.count("OuttaMyWay.OperationalPicture.new(") == 1
    assert "OuttaMyWay.OperationalPicture.new(baseValues)" in support
    assert "supportView" not in support
    for deleted_evidence_view in (
        "opposedCorridorKnowledge={}",
        "spatialConstraintKnowledge={}",
        "followerBoundaryKnowledge={}",
        "terminalOccupancyKnowledge={record}",
    ):
        assert deleted_evidence_view not in support


def test_projection_builders_return_groups_without_publishing_operational_pictures():
    paths_and_tokens = (
        ("scripts/candidates/PassiveLiveCandidateSupport.lua", "function Support:buildProjectedGroup"),
        ("scripts/candidates/TerminalEgressCandidateSupport.lua", "function Support:buildProjectedGroup"),
        ("scripts/candidates/ObstructionRelocationCandidateSupport.lua", "function Support:buildFreshProjectedGroup"),
        ("scripts/candidates/LiveTrafficCandidateSupport.lua", "function Support:buildProjectedGroup"),
    )
    for path, token in paths_and_tokens:
        text=read(path)
        assert token in text
        builder=text[text.index(token):text.index("function Support:attach", text.index(token))]
        assert "OperationalPicture.new" not in builder


def test_projection_keeps_full_parent_evidence_and_uses_direct_per_conflict_planning():
    live=read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    planner=read("scripts/candidates/LocalPassagePlanner.lua")
    assert "local values=OuttaMyWay.ValueRecord.toTable(picture)" in live
    assert "values.identity=targetPictureId" in live
    assert "values.epoch=targetEpoch" in live
    assert "LocalPassagePlanner.planConflict(picture,snapshot,relation)" in live
    assert "function Planner.planConflict(picture,snapshot,conflict)" in planner
    assert "return planConflict(picture,snapshot,conflict)" in planner
    assert "ONE_CONFLICT_SUPPORT_PROJECTION_NO_INTER_CONFLICT_SELECTION" in live


def test_same_picture_traffic_exhaustion_contract_remains_strict():
    live=read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    policy=read("scripts/decision/TrafficPolicemanDecisionPolicy.lua")
    portfolio=read("scripts/candidates/ProspectiveDecisionPortfolioSupport.lua")
    assert "operationalPictureId=pictureId" in live
    assert 'return false, "STALE_OPERATIONAL_PICTURE"' in policy
    assert "targetOperationalPictureId=targetPictureId" in portfolio
    assert "operationalPictureId=targetPictureId" not in portfolio


def test_projection_does_not_reopen_d0147_d0218_or_control_mechanics():
    portfolio=read("scripts/candidates/ProspectiveDecisionPortfolioSupport.lua")
    terminal=read("scripts/candidates/TerminalEgressCandidateSupport.lua")
    obstruction=read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    assert "buildProjectedGroup" in terminal
    assert "buildFreshProjectedGroup" in obstruction
    for forbidden in ("driveInWorldDirection", "AIVehicleUtil", "TerminalEgressControl", "ObstructionRelocationControl"):
        assert forbidden not in portfolio
