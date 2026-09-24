from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT/relative).read_text(encoding="utf-8")

def test_retires_runtime_monkey_patch_files():
    main=read("scripts/main.lua")
    runtime=read("scripts/runtime/Runtime.lua")
    source=read("scripts/observation/LiveObservationSource.lua")
    for relative in (
        "scripts/runtime/ObstructionRelocationRuntimeIntegration.lua",
        "scripts/runtime/ProspectiveDecisionPortfolioIntegration.lua",
    ):
        assert not (ROOT/relative).exists()
        assert relative not in main
    for token in ("originalRuntimeNew","originalRuntimeDispatch","originalSourceCapture","local originalDispatch="):
        assert token not in runtime
        assert token not in source

def test_observation_augmentation_is_direct_before_return():
    source=read("scripts/observation/LiveObservationSource.lua")
    capture=source[source.index("function Source:capture(mission, nowSeconds)"):source.index("function Source:getCurrentPhysicalObject")]
    assert "self.currentPhysicalPoseSource:observe(raw,self)" in capture
    assert capture.index("self.currentPhysicalPoseSource:observe(raw,self)") < capture.rindex("return observations")

def test_runtime_construction_preserves_wrapper_order():
    runtime=read("scripts/runtime/Runtime.lua")
    block=runtime[runtime.index("function Runtime.new()"):runtime.index("function Runtime:initialize()")]
    ordered=(
        "runtime.currentPhysicalPoseSource=OuttaMyWay.CurrentPhysicalPoseSource.new()",
        "runtime.obstructionRelocationCandidateSupport=OuttaMyWay.ObstructionRelocationCandidateSupport.new",
        "runtime.obstructionRelocationResponsibilityTransition=OuttaMyWay.ObstructionRelocationResponsibilityTransition.new",
        "runtime.prospectiveDecisionPortfolioSupport=OuttaMyWay.ProspectiveDecisionPortfolioSupport.new",
    )
    positions=[block.index(token) for token in ordered]
    assert positions==sorted(positions)

def test_dispatch_order_is_portfolio_then_cold_then_existing():
    runtime=read("scripts/runtime/Runtime.lua")
    dispatch=runtime[runtime.index("function Runtime:dispatchEvaluatedOperationalPicture"):runtime.index("function Runtime:processLiveObservation")]
    ordered=(
        'boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO"',
        "local obstructionBridge=relocationBridge(candidate)",
        "local followerBridge=followerBoundaryBridge(candidate)",
    )
    positions=[dispatch.index(token) for token in ordered]
    assert positions==sorted(positions)
    assert "values.supportBoundary=localBoundary" in dispatch
    assert "evaluated=normalized" in dispatch
    assert "self:_dispatchObstructionRelocation" in dispatch

def test_tactical_regulation_uses_fresh_portfolio_while_active_resolution_keeps_its_decision_horizon():
    runtime=read("scripts/runtime/Runtime.lua")
    process=runtime[runtime.index("function Runtime:processLiveObservation(raw)"):runtime.index("function Runtime:getStatus()")]
    assert "activeResolution" in process
    assert "getCurrentResolutionCommitment" in process
    assert "self.prospectiveDecisionPortfolioSupport:publishDecisionPicture(processed.picture,processed.snapshot)" in process
    assert process.index("if activeResolution then") < process.index("self.prospectiveDecisionPortfolioSupport:publishDecisionPicture(processed.picture,processed.snapshot)")
    assert "self.obstructionRelocationCandidateSupport:publishDecisionPicture(processed.picture,processed.snapshot)" in process
    assert "self.terminalEgressCandidateSupport" not in process
    assert "self.liveTrafficCandidateSupport:publishDecisionPicture(processed.picture,processed.snapshot)" in process

def test_obstruction_relocation_semantics_survive_shared_execution():
    runtime=read("scripts/runtime/Runtime.lua")
    assert "function Runtime:setObstructionRelocationControl" in runtime
    assert "function Runtime:setTerminalEgressControl" not in runtime
    for token in (
        "function Runtime:onObstructionRelocationControlCompletion",
        "function Runtime:_obstructionRelocationRequest",
        "function Runtime:onObstructionRelocationCompletion",
        "function Runtime:_dispatchObstructionRelocation",
        'kind="OBSTRUCTION_RELOCATION"',
        'triggerKind="CURRENT_CAUSAL_OBSTRUCTION"',
        'authorityClass="OBSTRUCTION_RELOCATION_ACTUATION"',
        "historicalJobProvenanceRequired=false",
        "semanticResolutionNotInferred=true",
        "freshSituationRequired=true",
    ):
        assert token in runtime

def test_obstruction_relocation_methods_use_central_log_publication_without_losing_causal_evidence():
    runtime=read("scripts/runtime/Runtime.lua")
    assert 'OuttaMyWay.LogPublication.origin("RUNTIME")' in runtime
    assert "Logging." not in runtime

    obstruction_relocation=runtime[
        runtime.index("function Runtime:_obstructionRelocationRequest"):
        runtime.index("function Runtime:dispatchEvaluatedOperationalPicture")
    ]
    assert "OBSTRUCTION_RELOCATION_CONTROL_ACCEPTED" in obstruction_relocation
    assert "OBSTRUCTION_RELOCATION_CONTROL_SETTLEMENT_FAILED" in obstruction_relocation

def test_runtime_still_does_not_physically_actuate():
    runtime=read("scripts/runtime/Runtime.lua")
    for forbidden in ("AIVehicleUtil.driveInDirection","AIVehicleUtil.driveToPoint","getCanAIFieldWorkerContinueWork"):
        assert forbidden not in runtime
