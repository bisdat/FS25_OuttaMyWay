from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

ROOT_NAMES = (
    "FIELD_IDENTITY_PROBE_HEARTBEAT_INTERVAL_MS",
    "PRODUCTIVE_CONTINUATION_PROBE_ENABLED",
    "PRODUCTIVE_CONTINUATION_PROBE_INTERVAL_MS",
    "PRODUCTIVE_CONTINUATION_PROBE_HEARTBEAT_MS",
    "NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_ENABLED",
    "NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_INTERVAL_MS",
    "NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_HEARTBEAT_MS",
    "NATIVE_MANOEUVRE_OBSERVATION_ENABLED",
    "NATIVE_MANOEUVRE_OBSERVATION_INTERVAL_MS",
    "NATIVE_MANOEUVRE_OBSERVATION_LOG_INTERVAL_MS",
    "PROGRESSION_PRESERVATION_PROBE_ENABLED",
    "PROGRESSION_PRESERVATION_PROBE_HEARTBEAT_MS",
)

def test_issue87_live_diagnostic_values_leave_mixed_root():
    config = read("scripts/config.lua")
    for token in ROOT_NAMES:
        assert token not in config

def test_issue87_live_diagnostic_instruments_own_exact_accepted_values():
    field = read("scripts/diagnostics/TargetedFieldIdentityProbe.lua")
    productive = read("scripts/diagnostics/ProductiveContinuationProbe.lua")
    native = read("scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua")
    manoeuvre = read("scripts/observation/NativeManoeuvreObservationSource.lua")
    progression = read("scripts/diagnostics/ProgressionPreservationProbe.lua")

    for token in (
        "local FIELD_IDENTITY_HEARTBEAT_INTERVAL_MS=10000",
        "local due = (nowMs or 0) - self.lastHeartbeatMs >= FIELD_IDENTITY_HEARTBEAT_INTERVAL_MS",
    ):
        assert token in field

    for token in (
        "local PRODUCTIVE_CONTINUATION_ENABLED=true",
        "local PRODUCTIVE_CONTINUATION_SAMPLE_INTERVAL_MS=250",
        "local PRODUCTIVE_CONTINUATION_HEARTBEAT_MS=2000",
        "local interval=PRODUCTIVE_CONTINUATION_SAMPLE_INTERVAL_MS",
        "local heartbeat=PRODUCTIVE_CONTINUATION_HEARTBEAT_MS",
    ):
        assert token in productive

    for token in (
        "local NATIVE_FIELD_WORKER_DRIVE_COMMAND_ENABLED=true",
        "local NATIVE_FIELD_WORKER_DRIVE_COMMAND_SAMPLE_INTERVAL_MS=250",
        "local NATIVE_FIELD_WORKER_DRIVE_COMMAND_HEARTBEAT_MS=1000",
        "local interval=NATIVE_FIELD_WORKER_DRIVE_COMMAND_SAMPLE_INTERVAL_MS",
        "local heartbeat=NATIVE_FIELD_WORKER_DRIVE_COMMAND_HEARTBEAT_MS",
    ):
        assert token in native

    for token in (
        "local NATIVE_MANOEUVRE_OBSERVATION_ENABLED=true",
        "local NATIVE_MANOEUVRE_OBSERVATION_SAMPLE_INTERVAL_MS=100",
        "local NATIVE_MANOEUVRE_OBSERVATION_LOG_INTERVAL_MS=250",
        "local interval=NATIVE_MANOEUVRE_OBSERVATION_SAMPLE_INTERVAL_MS",
        "local logInterval=NATIVE_MANOEUVRE_OBSERVATION_LOG_INTERVAL_MS",
    ):
        assert token in manoeuvre

    for token in (
        "local PROGRESSION_PRESERVATION_ENABLED=true",
        "local PROGRESSION_PRESERVATION_HEARTBEAT_MS=1000",
    ):
        assert token in progression

    for owner in (field, productive, native, manoeuvre, progression):
        for token in ROOT_NAMES:
            assert f"OuttaMyWay.{token}" not in owner

def test_issue87_diagnostic_localisation_does_not_move_runtime_or_semantic_authority():
    main = read("scripts/main.lua")
    coordinator = read("scripts/runtime/LiveRuntimeCoordinator.lua")
    productive = read("scripts/diagnostics/ProductiveContinuationProbe.lua")
    native = read("scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua")
    manoeuvre = read("scripts/observation/NativeManoeuvreObservationSource.lua")
    progression = read("scripts/diagnostics/ProgressionPreservationProbe.lua")

    assert "local LIVE_RUNTIME_CONTROL_INTERVAL_MS=250" in coordinator
    assert "local interval=LIVE_RUNTIME_CONTROL_INTERVAL_MS" in coordinator
    for token in (
        "addModEventListener(OuttaMyWay.productiveContinuationProbe)",
        "addModEventListener(OuttaMyWay.nativeFieldWorkerDriveCommandProbe)",
        "addModEventListener(OuttaMyWay.nativeManoeuvreObservationSource)",
        "setProgressionPreservationProbe(OuttaMyWay.progressionPreservationProbe)",
    ):
        assert token in main

    assert "no Decision or Control authority" in productive
    assert "controlAuthority=false" in native
    assert "boundaryDemandAuthority=false" in manoeuvre
    assert 'responseAdjustedSupportableProgression="UNRESOLVED"' in progression
    assert "controlAuthority=false" in progression
