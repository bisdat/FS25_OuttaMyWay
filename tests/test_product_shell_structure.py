"""Contracts for the passive native observer shell with no vehicle Control.

The 0.4 behavioural contracts remain in the repository as historic evidence;
they do not describe the presently loaded product.
"""
from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]
SHELL_MODULES = [
    "scripts/config.lua",
    "scripts/assessment/SpatialPairInference.lua",
    "scripts/coordination/HoldRelocateCoordinator.lua",
    "scripts/control/mechanisms/NativeReverseMechanism.lua",
    "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/observation/NativeBlockageObservation.lua",
    "scripts/diagnostics/VersionHud.lua",
    "scripts/gui/ConfigurationSettingsExtension.lua",
    "scripts/gui/DisabledStartupReminder.lua",
]


def main_text():
    return (ROOT / "scripts/main.lua").read_text(encoding="utf-8")


def test_bootstrap_loads_only_explicit_shell_modules():
    text = main_text()
    block = re.search(r"local modules=\{(.*?)\}", text, re.S)
    assert block is not None
    loaded = re.findall(r'"(scripts/[^"]+\.lua)"', block.group(1))
    assert loaded == SHELL_MODULES
    assert all((ROOT / path).is_file() for path in loaded)
    assert "source(modDirectory..relativePath)" in text


def test_shell_has_no_runtime_graph_or_vehicle_authority():
    text = main_text()
    for forbidden in (
        "OuttaMyWay.Runtime", "ProductLifecycle", "LiveRuntimeCoordinator",
        "RegulationControl", "CooperativePassageControl",
        "BlockedWorkerRecoveryControl", "ObstructionRelocationControl",
        "BoundedBypassControl", "FieldWorkHoldMechanism", "NativeDriveMechanism",
        "sharedPhysicalControlMechanisms", "relinquishAllControl",
    ):
        assert forbidden not in text
    assert "OuttaMyWay.runtime=" not in text
    assert text.count("addModEventListener(") == 3
    assert "OuttaMyWay.nativeBlockageObservation=OuttaMyWay.NativeBlockageObservation.new" in text
    assert "NativeBlockedProbe" not in text
    assert "NativeBlockedEventTap" not in text


def test_hud_contains_only_dynamic_version_identity_and_requires_enabled_config():
    hud = (ROOT / "scripts/diagnostics/VersionHud.lua").read_text(encoding="utf-8")
    assert 'local text=string.format("OuttaMyWay %s",tostring(OuttaMyWay.VERSION or "?"))' in hud
    assert 'shell only' not in hud
    assert "configuration:isResolved()~=true" in hud
    assert "configuration:isEnabled()~=true" in hud
    assert "OuttaMyWay.runtime" not in hud


def test_current_test_identity_is_owned_twice_only():
    config = (ROOT / "scripts/config.lua").read_text(encoding="utf-8")
    moddesc = (ROOT / "modDesc.xml").read_text(encoding="utf-8")
    version = re.search(r'OuttaMyWay\.VERSION = "([^"]+)"', config)
    manifest = re.search(r'<version value="([^"]+)">([^<]+)</version>', moddesc)
    assert version is not None and manifest is not None
    assert re.fullmatch(r"0\.\d+\.\d+\.\d+", version.group(1))
    assert manifest.group(1) == manifest.group(2) == version.group(1)
    assert version.group(1) not in main_text()
    assert 'aiControl=false' in main_text()


def test_settings_and_disabled_reminder_are_retained():
    main = main_text()
    assert "OuttaMyWay.configuration:resolvePersistedState()" in main
    assert "OuttaMyWay.configuration:addChangeListener" in main
    assert "OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new" in main
    assert "OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()" in main
    assert "OuttaMyWay.disabledStartupReminder=OuttaMyWay.DisabledStartupReminder.new" in main
    assert "OUTTAMYWAY_SHELL_STARTED" in main
    assert "OUTTAMYWAY_SHELL_ENABLED" in main
    assert "OUTTAMYWAY_SHELL_DISABLED" in main
    assert "OuttaMyWay.nativeBlockedEventTap" not in main


def test_manifest_does_not_promise_active_ai_control():
    moddesc = (ROOT / "modDesc.xml").read_text(encoding="utf-8")
    assert "This build does not control AI workers." in moddesc
    assert "AI worker coordination is inactive." in moddesc


def test_every_production_script_is_reachable_from_the_shell():
    actual = {path.relative_to(ROOT).as_posix() for path in (ROOT / "scripts").rglob("*.lua")}
    assert actual == set(SHELL_MODULES) | {"scripts/main.lua"}
    assert "scripts/diagnostics/NativeBlockedProbe.lua" not in actual
    assert "scripts/diagnostics/NativeBlockedEventTap.lua" not in actual
