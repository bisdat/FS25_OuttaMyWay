from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def active_lua():
    return {
        path.relative_to(ROOT).as_posix(): path.read_text(encoding="utf-8")
        for path in (ROOT / "scripts").rglob("*.lua")
        if "archive" not in path.parts
    }

def test_issue87_core_capability_pseudo_state_is_absent_but_field_world_negative_authority_annotation_remains():
    source = active_lua()
    for token in (
        "CONTROL_AUTHORITY_ENABLED",
        "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED",
        "COOPERATIVE_PASSAGE_ENABLED",
        "generalControlAuthorityEnabled",
        "COOPERATIVE_PASSAGE_DISABLED",
        "COOPERATIVE_PASSAGE_DISABLED_DURING_ACTIVE_COMMITMENT",
    ):
        assert all(token not in text for text in source.values()), token

    runtime = read("scripts/runtime/Runtime.lua")
    assert "controlAuthorityEnabled" not in runtime

    expected_field_world_counts = {
        "scripts/identity/FieldWorldEquivalenceAuthority.lua": 3,
        "scripts/identity/FieldWorldEquivalenceEvaluator.lua": 1,
        "scripts/identity/FieldWorldSnapshotRegistry.lua": 2,
    }
    for relative, count in expected_field_world_counts.items():
        assert read(relative).count("controlAuthorityEnabled=false") == count
    for relative, text in source.items():
        if relative not in expected_field_world_counts:
            assert "controlAuthorityEnabled" not in text, relative

def test_issue87_follower_boundary_is_unconditional_current_candidate_path():
    support = read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    assessment = read("scripts/assessment/FollowerBoundaryDemandAssessment.lua")
    authority = read("scripts/authority/RegulationBoundedAuthority.lua")
    lifecycle = read("scripts/commitment/LiveTrafficCommitmentLifecycle.lua")
    assert "local function followerBoundaryRecord(picture)" in support
    assert "local follower,followerReason=followerBoundaryRecord(picture)" in support
    assert "OuttaMyWay.FollowerBoundaryDemandAssessment" in assessment
    assert "FOLLOWER_BOUNDARY_OWNER_TAG" in authority
    assert "applyFollowerBoundaryDecision" in lifecycle

def test_issue87_cooperative_passage_is_evidence_and_authority_gated_not_feature_gated():
    planner = read("scripts/candidates/LocalPassagePlanner.lua")
    control = read("scripts/control/CooperativePassageControl.lua")
    runtime = read("scripts/runtime/Runtime.lua")
    assert "function Planner.planConflict(picture,snapshot,conflict)" in planner
    assert "function Planner.plan(picture,snapshot)" in planner
    assert "function Control:_executeCooperativePassageJointRequests" in control
    assert "boundedAuthority:isCurrent" in control
    assert "BOUNDED_AUTHORITY_LOST" in control
    assert "COOPERATIVE_PASSAGE_CONTROL_UNAVAILABLE" in runtime
    assert "COOPERATIVE_PASSAGE_SUPPORT_BOUNDARY_MISMATCH" in runtime
    assert "transitionCooperativePassageResolution" in runtime

def test_issue87_control_permission_is_typed_bounded_topology():
    runtime = read("scripts/runtime/Runtime.lua")
    dispatcher = read("scripts/control/LiveControlDispatcher.lua")
    bounded = read("scripts/authority/BoundedAuthority.lua")
    main = read("scripts/main.lua")
    for token in (
        "OuttaMyWay.RegulationControl.new",
        "OuttaMyWay.CooperativePassageControl.new",
        "OuttaMyWay.ObstructionRelocationControl.new",
    ):
        assert token in main
    assert "function Authority:authorize" in bounded
    for token in ("responsibilityId", "commitmentId", "authorityToken"):
        assert token in bounded
    assert 'request.capability=="REGULATE_SPEED"' in dispatcher
    assert 'request.capability=="REPOSITION"' in dispatcher
    assert 'target.kind=="OBSTRUCTION_RELOCATION"' in dispatcher
    assert "JOINT_REPOSITION_REQUIRES_DISPATCH_JOINT" in dispatcher
    assert "CONTROL_REQUEST_CAPABILITY_UNSUPPORTED" in dispatcher
    assert "runtime.boundedAuthority=OuttaMyWay.BoundedAuthority.new(runtime)" in runtime

def test_issue87_passive_diagnostics_report_actual_bounded_dispatch_not_pseudo_authority_state():
    validator = read("scripts/diagnostics/PassiveLiveValidator.lua")
    record = read("scripts/contracts/PassiveLiveTraceRecord.lua")
    assert "boundedControlDispatchStatus=dispatch.status" in validator
    assert "boundedControlRequestId=request and request.identity or nil" in validator
    assert "boundedControlOutcomeId=outcome and outcome.identity or nil" in validator
    assert '"boundedControlDispatchStatus","boundedControlRequestId","boundedControlOutcomeId"' in record
