from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT/relative).read_text(encoding="utf-8")

def test_phase14_5_retires_runtime_monkey_patch_files():
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

def test_phase14_5_observation_augmentation_is_direct_before_return():
    source=read("scripts/observation/LiveObservationSource.lua")
    capture=source[source.index("function Source:capture(mission, nowSeconds)"):source.index("function Source:getCurrentPhysicalObject")]
    assert "self.currentPhysicalPoseSource:observe(raw,self)" in capture
    assert capture.index("self.currentPhysicalPoseSource:observe(raw,self)") < capture.rindex("return observations")

def test_phase14_5_runtime_construction_preserves_wrapper_order():
    runtime=read("scripts/runtime/Runtime.lua")
    block=runtime[runtime.index("function Runtime.new()"):runtime.index("function Runtime:initialize()")]
    ordered=(
        "runtime.currentPhysicalPoseSource=OuttaMyWay.CurrentPhysicalPoseSource.new()",
        "runtime.obstructionRelocationCandidateSupport=OuttaMyWay.ObstructionRelocationCandidateSupport.new",
        "runtime.legacyTerminalEgressCandidateSupport=runtime.terminalEgressCandidateSupport",
        "runtime.terminalEgressCandidateSupport=CompositeCandidateSupport.new",
        "runtime.obstructionRelocationResponsibilityTransition=OuttaMyWay.ObstructionRelocationResponsibilityTransition.new",
        "runtime.prospectiveDecisionPortfolioSupport=OuttaMyWay.ProspectiveDecisionPortfolioSupport.new",
    )
    positions=[block.index(token) for token in ordered]
    assert positions==sorted(positions)

def test_phase14_5_dispatch_order_is_portfolio_then_cold_then_existing():
    runtime=read("scripts/runtime/Runtime.lua")
    dispatch=runtime[runtime.index("function Runtime:dispatchEvaluatedOperationalPicture"):runtime.index("function Runtime:processLiveObservation")]
    ordered=(
        'boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO"',
        "local obstructionBridge=relocationBridge(candidate)",
        "local terminalBridge=terminalEgressBridge(candidate)",
    )
    positions=[dispatch.index(token) for token in ordered]
    assert positions==sorted(positions)
    assert "values.supportBoundary=localBoundary" in dispatch
    assert "evaluated=normalized" in dispatch
    assert "self:_dispatchObstructionRelocation" in dispatch

def test_phase14_5_fresh_and_incumbent_live_cycle_split_is_preserved():
    runtime=read("scripts/runtime/Runtime.lua")
    process=runtime[runtime.index("function Runtime:processLiveObservation(raw)"):runtime.index("function Runtime:runReplay(fixture)")]
    assert "OuttaMyWay.ValueRecord.length(processed.picture.commitmentContext or {})>0" in process
    assert "self.prospectiveDecisionPortfolioSupport:attach(processed.picture,processed.snapshot)" in process
    assert "self.terminalEgressCandidateSupport:attach(processed.picture,processed.snapshot)" in process
    assert "self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot)" in process

def test_phase14_5_d0218_semantics_and_cleanup_remain_in_runtime():
    runtime=read("scripts/runtime/Runtime.lua")
    for token in (
        "function Runtime:setObstructionRelocationControl",
        "function Runtime:_obstructionRelocationRequest",
        "function Runtime:onObstructionRelocationCompletion",
        "function Runtime:_dispatchObstructionRelocation",
        'authorityClass="OBSTRUCTION_RELOCATION_ACTUATION"',
        "historicalJobProvenanceRequired=false",
        "semanticResolutionNotInferred=true",
        "freshSituationRequired=true",
    ):
        assert token in runtime

def test_phase14_5_absorbed_d0218_methods_retain_lexical_logging_dependencies():
    runtime=read("scripts/runtime/Runtime.lua")
    assert "local function logInfo(formatText,...)" in runtime
    assert "local function logWarning(formatText,...)" in runtime
    assert '[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s' in runtime
    assert '[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION][WARNING] ' in runtime

    d0218=runtime[
        runtime.index("function Runtime:setObstructionRelocationControl(control)"):
        runtime.index("function Runtime:dispatchEvaluatedOperationalPicture")
    ]
    assert "logInfo(" in d0218
    assert "logWarning(" in d0218


def test_phase14_5_runtime_still_does_not_physically_actuate():
    runtime=read("scripts/runtime/Runtime.lua")
    for forbidden in ("AIVehicleUtil.driveInDirection","AIVehicleUtil.driveToPoint","getCanAIFieldWorkerContinueWork"):
        assert forbidden not in runtime

def test_phase14_5_current_build_identity_is_025():
    config=read("scripts/config.lua")
    main=read("scripts/main.lua")
    moddesc=read("modDesc.xml")
    assert 'OuttaMyWay.VERSION = "0.3.0.26"' in config
    assert 'OuttaMyWay.BUILD_LABEL = "0.3.0.26 TEST — RUNTIME INTEGRATION DEPENDENCY CLOSURE"' in config
    assert "v0.3.0.26 TEST — RUNTIME INTEGRATION DEPENDENCY CLOSURE" in main
    assert '<version value="0.3.0.26">0.3.0.26</version>' in moddesc
