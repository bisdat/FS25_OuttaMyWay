from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_phase14_4_non_job_actuation_is_a_control_mechanism_not_semantic_authority():
    main = read("scripts/main.lua")
    mechanism_path = ROOT / "scripts/control/mechanisms/NonJobActuationMechanism.lua"

    assert mechanism_path.is_file()
    assert not (ROOT / "scripts/authority/PostJobActuationAuthority.lua").exists()
    assert "scripts/control/mechanisms/NonJobActuationMechanism.lua" in main
    assert "scripts/authority/PostJobActuationAuthority.lua" not in main

    mechanism = mechanism_path.read_text(encoding="utf-8")
    assert "OuttaMyWay.NonJobActuationMechanism={}" in mechanism
    assert "local Mechanism=OuttaMyWay.NonJobActuationMechanism" in mechanism
    assert "OuttaMyWay.PostJobActuationAuthority" not in mechanism

    for forbidden in (
        "AuthorityRegistry",
        "ControlRequest",
        "CandidateSpace",
        "DecisionSelector",
        "ResponsibilityTransition",
        'authorityClass="POST_JOB_ACTUATION"',
        'authorityClass="OBSTRUCTION_RELOCATION_ACTUATION"',
    ):
        assert forbidden not in mechanism

def test_phase14_4_mechanical_surface_is_preserved():
    mechanism = read("scripts/control/mechanisms/NonJobActuationMechanism.lua")

    for method in (
        "steeringTelemetry",
        "isPlayerClaimed",
        "isSourceReactivated",
        "acquireVehicleActivityContext",
        "releaseVehicleActivityContext",
        "position",
        "heading",
        "maximumForwardSpeedKmh",
        "driveInWorldDirection",
        "neutralize",
        "stop",
        "getDirectDriveCallCount",
        "getNeutralizeCallCount",
        "getActivityContextAcquireCallCount",
        "getActivityContextReleaseCallCount",
    ):
        assert f"function Mechanism:{method}" in mechanism

    for token in (
        "vehicle.forceIsActive=true",
        "vehicle.forceIsActive=context.previousForceIsActive",
        "AIVehicleUtil.driveInDirection",
        "WheelsUtil.updateWheelsPhysics",
        "vehicle.motor=motor",
        "vehicle.cruiseControl={state=cruiseState}",
        "vehicle.motor,vehicle.cruiseControl=previousMotor,previousCruise",
    ):
        assert token in mechanism

def test_phase14_4_warm_and_cold_semantic_authorities_remain_separate():
    terminal = read("scripts/control/TerminalEgressControl.lua")
    obstruction = read("scripts/control/ObstructionRelocationControl.lua")

    assert 'token.authorityClass=="POST_JOB_ACTUATION"' in terminal
    assert "OBSTRUCTION_RELOCATION_ACTUATION" not in terminal

    assert 'token.authorityClass=="OBSTRUCTION_RELOCATION_ACTUATION"' in obstruction
    assert "POST_JOB_ACTUATION" not in obstruction

    constructor = "actuationMechanism=OuttaMyWay.NonJobActuationMechanism.new()"
    assert constructor in terminal
    assert constructor in obstruction

    assert "postJobAuthority" not in terminal
    assert "movementDonor" not in obstruction

def test_phase14_4_cold_path_still_denies_completed_job_provenance_and_second_courtesy():
    obstruction = read("scripts/control/ObstructionRelocationControl.lua")
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")

    assert "historicalJobProvenanceRequired=false" in obstruction
    assert 'tonumber(objective.courtesyStage)~=1' in obstruction
    assert 'courtesyStage=1' in candidate
    assert 'secondCourtesyNotAuthorised=true' in candidate

def test_phase14_4_warm_path_retains_double_courtesy_semantics():
    terminal_candidate = read("scripts/candidates/TerminalEgressCandidateSupport.lua")
    terminal_control = read("scripts/control/TerminalEgressControl.lua")

    assert "TERMINAL_FINAL_BOUNDARY_SETTLEMENT" in terminal_candidate
    assert "maximumCourtesyMovesPerEpisode=2" in terminal_candidate
    assert "POST_JOB_ACTUATION" in terminal_control

def test_phase14_4_post_job_failure_reason_vocabulary_is_deliberately_deferred():
    mechanism = read("scripts/control/mechanisms/NonJobActuationMechanism.lua")

    for token in (
        "POST_JOB_MOTOR_MAX_FORWARD_SPEED_UNAVAILABLE",
        "POST_JOB_POSE_UNAVAILABLE",
        "POST_JOB_DIRECTION_DRIVE_CALL_FAILED",
        "POST_JOB_NEUTRALIZE_WHEEL_PHYSICS_FAILED",
    ):
        assert token in mechanism

def test_phase14_4_current_build_identity_is_024():
    config = read("scripts/config.lua")
    main = read("scripts/main.lua")
    moddesc = read("modDesc.xml")

    assert 'OuttaMyWay.VERSION = "0.3.0.25"' in config
    assert 'OuttaMyWay.BUILD_LABEL = "0.3.0.25 TEST — RUNTIME INTEGRATION CONSOLIDATION"' in config
    assert "v0.3.0.25 TEST — RUNTIME INTEGRATION CONSOLIDATION" in main
    assert '<version value="0.3.0.25">0.3.0.25</version>' in moddesc
