from pathlib import Path
import re

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
    "PROGRESSION_PRESERVATION_PROBE_ENABLED",
    "PROGRESSION_PRESERVATION_PROBE_HEARTBEAT_MS",
)

HUD_ROOT_NAMES = (
    "FUTURE_SPACE_HUD_ENABLED",
    "TRANSITION_HUD_X",
    "TRANSITION_HUD_Y",
    "TRANSITION_HUD_TITLE_SIZE",
    "TRANSITION_HUD_TEXT_SIZE",
    "TRANSITION_HUD_LINE_HEIGHT",
    "VERSION_HUD_ENABLED",
    "VERSION_HUD_X",
    "VERSION_HUD_Y",
    "VERSION_HUD_TEXT_SIZE",
    "FOLLOWER_PACING_HUD_ENABLED",
    "FOLLOWER_PACING_HUD_X",
    "FOLLOWER_PACING_HUD_Y",
    "FOLLOWER_PACING_HUD_TEXT_SIZE",
    "FOLLOWER_PACING_HUD_MAX_ROWS",
    "LIFECYCLE_TEST_HUD_ENABLED",
    "TRANSITION_HUD_ENABLED",
)


def test_diagnostic_hud_values_are_absent_from_root_and_legacy_gates_are_dead():
    config = read("scripts/config.lua")
    main = read("scripts/main.lua")
    paths = {"scripts/main.lua", *re.findall(r'"(scripts/[^"]+\.lua)"', main)}
    for name in HUD_ROOT_NAMES:
        assert re.search(rf"\b{re.escape(name)}\b", config) is None, name
    for path in sorted(paths):
        source = read(path)
        for name in HUD_ROOT_NAMES:
            # Neither dot nor quoted bracket access may restore a root dependency.
            assert re.search(
                rf'OuttaMyWay\s*(?:\.\s*{name}\b|\[\s*["\']{name}["\']\s*\])',
                source,
            ) is None, (path, name)
        for name in ("LIFECYCLE_TEST_HUD_ENABLED", "TRANSITION_HUD_ENABLED"):
            assert re.search(rf"\b{name}\b", source) is None, (path, name)


def test_diagnostic_hud_owners_keep_exact_local_presentation_values_and_consumers():
    # Expectations are accepted literals, independent of implementation values.
    owners = (
        ("FutureSpaceHud", "FUTURE_SPACE_HUD", {
            "ENABLED": "false", "X": "0.985", "Y": "0.720",
            "TITLE_SIZE": "0.016", "TEXT_SIZE": "0.014", "LINE_HEIGHT": "0.022",
        }),
        ("VersionHud", "VERSION_HUD", {
            "ENABLED": "true", "X": "0.985", "Y": "0.720", "TEXT_SIZE": "0.014",
        }),
        ("FollowerPacingHud", "FOLLOWER_PACING_HUD", {
            "ENABLED": "true", "X": "0.985", "Y": "0.697",
            "TEXT_SIZE": "0.013", "MAX_ROWS": "3",
        }),
    )
    for module, prefix, values in owners:
        source = read(f"scripts/diagnostics/{module}.lua")
        draw = source.split("function Hud:draw()", 1)[1]
        for suffix, value in values.items():
            name = f"{prefix}_{suffix}"
            assert re.search(
                rf"^local\s+{name}\s*=\s*{re.escape(value)}\s*$", source, re.M
            ), (module, name, value)
            assert re.search(rf"\b{name}\b", draw), (module, name)
        assert f"if {prefix}_ENABLED~=true or g_currentMission==nil or renderText==nil then return end" in draw
    future = read("scripts/diagnostics/FutureSpaceHud.lua")
    assert "TRANSITION_" not in future
    assert "local lineHeight=FUTURE_SPACE_HUD_LINE_HEIGHT" in future
    assert "renderLine(x,y,FUTURE_SPACE_HUD_TITLE_SIZE,self.lines[1])" in future
    for row, offset in ((2, "lineHeight"), (3, "lineHeight*2"), (4, "lineHeight*3")):
        assert f"renderLine(x,y-{offset},FUTURE_SPACE_HUD_TEXT_SIZE,self.lines[{row}])" in future
    version = read("scripts/diagnostics/VersionHud.lua")
    assert 'string.format("OuttaMyWay %s",tostring(OuttaMyWay.VERSION or "?"))' in version
    follower = read("scripts/diagnostics/FollowerPacingHud.lua")
    assert "math.min(#lines,maxRows)" in follower
    assert "local yy=y-(i-1)*(size*1.35)" in follower


def test_future_space_hud_remains_indirectly_live_through_passive_validator():
    main = read("scripts/main.lua")
    validator = read("scripts/diagnostics/PassiveLiveValidator.lua")
    runtime = read("scripts/runtime/Runtime.lua")
    assert main.index('"scripts/diagnostics/FutureSpaceHud.lua"') < main.index('"scripts/diagnostics/PassiveLiveValidator.lua"')
    assert "runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime)" in runtime
    assert "futureSpaceHud=OuttaMyWay.FutureSpaceHud.new()" in validator
    assert "self.futureSpaceHud:observeRecord(record)" in validator
    assert "function Validator:draw() self.futureSpaceHud:draw() end" in validator
    assert "self.futureSpaceHud:reset()" in validator
    assert "addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)" in main

def test_issue87_live_diagnostic_values_leave_mixed_root():
    config = read("scripts/config.lua")
    for token in ROOT_NAMES:
        assert token not in config

def test_issue87_live_diagnostic_instruments_own_exact_accepted_values():
    field = read("scripts/diagnostics/TargetedFieldIdentityProbe.lua")
    productive = read("scripts/diagnostics/ProductiveContinuationProbe.lua")
    native = read("scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua")
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
        "local PROGRESSION_PRESERVATION_ENABLED=true",
        "local PROGRESSION_PRESERVATION_HEARTBEAT_MS=1000",
    ):
        assert token in progression

    for owner in (field, productive, native, progression):
        for token in ROOT_NAMES:
            assert f"OuttaMyWay.{token}" not in owner

def test_issue87_diagnostic_localisation_does_not_move_runtime_or_semantic_authority():
    main = read("scripts/main.lua")
    coordinator = read("scripts/runtime/LiveRuntimeCoordinator.lua")
    productive = read("scripts/diagnostics/ProductiveContinuationProbe.lua")
    native = read("scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua")
    progression = read("scripts/diagnostics/ProgressionPreservationProbe.lua")

    assert "local LIVE_RUNTIME_CONTROL_INTERVAL_MS=250" in coordinator
    assert "local interval=LIVE_RUNTIME_CONTROL_INTERVAL_MS" in coordinator
    for token in (
        "addModEventListener(OuttaMyWay.productiveContinuationProbe)",
        "addModEventListener(OuttaMyWay.nativeFieldWorkerDriveCommandProbe)",
        "setProgressionPreservationProbe(OuttaMyWay.progressionPreservationProbe)",
    ):
        assert token in main

    assert "no Decision or Control authority" in productive
    assert "controlAuthority=false" in native
    assert 'responseAdjustedSupportableProgression="UNRESOLVED"' in progression
    assert "controlAuthority=false" in progression


def test_progression_diagnostic_uses_current_picture_without_historical_maturation():
    main = read("scripts/main.lua")
    progression = read("scripts/diagnostics/ProgressionPreservationProbe.lua")
    assert "ProgressionPreservationProbe.new(OuttaMyWay.runtime)" in main
    assert "function Probe.new(runtime)" in progression
    assert "OuttaMyWay.ProgressionGeometry.rayCapsuleEntry(" in progression
    for token in (
        "headlandProbe", "maturationRegions", "MATURATION_WITNESS",
        "COARSE_UNCONTAMINATED_DEMONSTRATED_DEMAND_WITNESS",
        "PRESERVE_NATIVE_BOUNDARY_MATURATION", "forensicDemandEnvelope",
        "getObservations(", "function Probe.rayCapsuleEntry",
    ):
        assert token not in progression
    for relative in (
        "scripts/diagnostics/DemonstratedProductiveCoverageProbe.lua",
        "scripts/diagnostics/ProductiveCoverageResidualProbe.lua",
        "scripts/diagnostics/RefugeQualificationShadowProbe.lua",
        "scripts/observation/NativeManoeuvreObservationSource.lua",
    ):
        assert not (ROOT / relative).exists()
        assert relative not in main
