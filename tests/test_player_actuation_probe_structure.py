from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_issue412_probe_is_diagnostic_only_and_loaded_after_log_publication():
    main = read("scripts/main.lua")
    probe = read("scripts/diagnostics/PlayerActuationProbe.lua")

    assert '"scripts/publication/LogPublication.lua","scripts/diagnostics/PlayerActuationProbe.lua"' in main
    assert "function Probe.suppressesEnteredClaim()" in probe
    assert "return true" in probe
    assert '"PLAYER_ACTUATION_PROBE"' in probe
    assert "claimAuthority=false diagnosticOnly=true" in probe

    for callback in (
        "Drivable.actionEventAccelerate",
        "Drivable.actionEventBrake",
        "Drivable.actionEventSteer",
        'appendMotor("actionEventToggleMotorState","MOTOR_TOGGLE")',
        'appendMotor("actionEventSetMotorStateIgnition","MOTOR_IGNITION")',
        'appendMotor("actionEventSetMotorStateOn","MOTOR_ON")',
        'appendMotor("actionEventSetMotorStateOff","MOTOR_OFF")',
    ):
        assert callback in probe


def test_issue412_entered_state_claim_is_suppressed_only_through_probe_switch():
    assessment = read("scripts/assessment/CausalObstructionAssessment.lua")
    observation = read("scripts/observation/LiveObservationSource.lua")
    mechanism = read("scripts/control/mechanisms/NonJobActuationMechanism.lua")

    for source in (assessment, observation, mechanism):
        assert "suppressesEnteredClaim" in source

    assert 'player.playerEntered==true and not enteredClaimSuppressedForDiagnostic()' in assessment
    assert "enteredClaimSuppressedForDiagnostic=enteredClaimSuppressedForDiagnostic()" in assessment
    assert "and not enteredClaimSuppressedForDiagnostic() then" in observation
    assert 'local ok,value=safeCall(vehicle,"getIsEntered"); return ok and value==true' in mechanism


def test_issue412_test_identity_is_0491():
    config = read("scripts/config.lua")
    mod_desc = read("modDesc.xml")

    assert 'OuttaMyWay.VERSION = "0.4.9.1"' in config
    assert '<version value="0.4.9.1">0.4.9.1</version>' in mod_desc
