from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_non_job_actuation_is_a_control_mechanism_not_semantic_authority():
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

def test_mechanical_surface_is_preserved():
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

def test_single_generic_obstruction_relocation_authority_uses_shared_non_job_mechanism():
    control = read("scripts/control/ObstructionRelocationControl.lua")
    current = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")

    assert '"OBSTRUCTION_RELOCATION_ACTUATION"' in current
    assert "POST_JOB_ACTUATION" not in current
    assert "POST_JOB_ACTUATION" not in control
    assert "actuationMechanism=OuttaMyWay.NonJobActuationMechanism.new()" in control
    assert (ROOT / "scripts" / "control" / "ObstructionRelocationControl.lua").is_file()
    assert not (ROOT / "scripts" / "candidates" / "TerminalEgressCandidateSupport.lua").exists()


def test_current_causal_obstruction_is_provenance_neutral_and_geometry_bounded():
    terminal = read("scripts/control/ObstructionRelocationControl.lua")
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")

    assert 'boundedInwardRelocation=true' in candidate
    assert 'repeatedActuationRequiresFreshPositiveObstruction=true' in candidate
    assert 'moveCountBudget=false' in candidate
    assert 'historicalJobProvenanceRequired=false' in candidate
    assert 'courtesyStage=1' not in candidate
    assert 'secondCourtesyNotAuthorised=true' not in candidate
    assert 'tonumber(objective.courtesyStage)~=1' not in terminal
    assert "CURRENT_CAUSAL_OBSTRUCTION" not in terminal

def test_non_job_failure_reason_vocabulary_is_provenance_neutral():
    mechanism = read("scripts/control/mechanisms/NonJobActuationMechanism.lua")

    for token in (
        "NON_JOB_MOTOR_MAX_FORWARD_SPEED_UNAVAILABLE",
        "NON_JOB_POSE_UNAVAILABLE",
        "NON_JOB_DIRECTION_DRIVE_CALL_FAILED",
        "NON_JOB_NEUTRALIZE_WHEEL_PHYSICS_FAILED",
    ):
        assert token in mechanism
    assert "POST_JOB_" not in mechanism
