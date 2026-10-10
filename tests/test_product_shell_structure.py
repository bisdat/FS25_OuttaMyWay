"""Contracts for the admitted server-side Hold & Relocate product shell.

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
    "scripts/coordination/ProjectedEgressRegion.lua",
    "scripts/coordination/PairTransitRegion.lua",
    "scripts/coordination/NativePairCommitmentAuthority.lua",
    "scripts/control/HoldRelocatePhysicalControl.lua",
    "scripts/coordination/LiveHoldRelocateRuntime.lua",
    "scripts/control/mechanisms/NativeReverseMechanism.lua",
    "scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua",
    "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua",
    "scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua",
    "scripts/control/mechanisms/NativeTransitRequestMechanism.lua",
    "scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/observation/StaticBlockageEncounterObservation.lua",
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


def test_shell_wires_only_admitted_hold_relocate_without_legacy_control():
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
    assert text.count("addModEventListener(") == 4
    assert "OuttaMyWay.liveHoldRelocateRuntime=OuttaMyWay.LiveHoldRelocateRuntime.new" in text
    assert "addModEventListener(OuttaMyWay.liveHoldRelocateRuntime)" in text
    assert 'liveHoldRelocateRuntime:relinquish("PLAYER_DISABLED")' in text
    assert "OuttaMyWay.nativeBlockageObservation=OuttaMyWay.NativeBlockageObservation.new" in text
    assert "NativeBlockedProbe" not in text
    assert "NativeBlockedEventTap" not in text


def test_region_based_egress_and_native_regulation():
    authority = (ROOT / "scripts/coordination/NativePairCommitmentAuthority.lua").read_text(encoding="utf-8")
    coordinator = (ROOT / "scripts/coordination/HoldRelocateCoordinator.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts/coordination/LiveHoldRelocateRuntime.lua").read_text(encoding="utf-8")
    hold = (ROOT / "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua").read_text(encoding="utf-8")
    region = (ROOT / "scripts/coordination/ProjectedEgressRegion.lua").read_text(encoding="utf-8")
    regulation = (ROOT / "scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua").read_text(encoding="utf-8")
    reverse = (ROOT / "scripts/control/mechanisms/NativeReverseMechanism.lua").read_text(encoding="utf-8")
    assert "pairWorkingWidthM" not in authority
    assert "diagonalEgress" not in coordinator
    assert "ProjectedEgressRegion.plan" in coordinator
    assert "REGULATION" in coordinator
    assert "FAILED_SAFE" not in coordinator
    assert "REVERSE_BOUND_EXCEEDED" not in reverse
    assert "BOUND_REACHED_WITHOUT_TARGET" not in reverse
    assert "ProjectedEgressRegion.progress" in reverse
    assert "requiredProgressM" in region and "requiredCrossTrackM" in region
    assert "EGRESS_MARGIN_M=5" in region
    assert "OBLIQUE_REVERSE_DEG=70" in region
    pair_admission = authority.split("function Authority:admitCandidate")[1].split(
        "function Authority:admitSingleCandidate")[0]
    assert "blockerWorkingWidthM" not in pair_admission
    assert "a.workingWidthM" in pair_admission
    assert "b.workingWidthM" in pair_admission
    assert "blockerWorkingWidth(first)" in pair_admission
    assert "blockerWorkingWidth(second)" in pair_admission
    transit = (ROOT / "scripts/coordination/PairTransitRegion.lua").read_text(
        encoding="utf-8")
    physical = (ROOT / "scripts/control/HoldRelocatePhysicalControl.lua").read_text(
        encoding="utf-8")
    assert "GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION" in transit
    assert "reachableTravel" in transit and "sceneOccupancy" in transit
    assert "regionStepValid" in transit and "MIN_USEFUL_TRAVEL_M=STEP_M" in transit
    assert "planPair" in transit and "getAIWorkAreaWidth" not in transit
    assert "WORK_CORRIDOR_MARGIN_M=5" in transit
    assert "width+WORK_CORRIDOR_MARGIN_M" in transit
    assert "isPartialEgress" in transit
    assert "DISCOVERY_DIRECTIONS=32" in transit
    assert "math.max(2,required/math.abs(rate))" not in transit
    assert "PAIR_WORKING_CORRIDOR_TRAVEL_REGION" in transit
    assert "PAIR_TRANSIT_WAIT_MS=15000" not in coordinator
    assert "PAIR_PREPARING_TRANSIT" not in coordinator
    assert '"preflightPairMover"' in coordinator
    assert '"pairTransitFootprint"' in coordinator
    assert '"transitStatus"' not in coordinator
    assert "pairedEgressImmediate=true" in coordinator
    assert '"requestTransit",mover.vehicle' in coordinator
    assert "foldTargets" in physical and "hasActiveParts" in physical
    assert "SIGNED_CROSS_TRACK_REGION" in region
    assert "REQUIRED_RETREAT_M=20" not in region
    assert "HOLD_RELOCATE_EGRESS_REGULATION_EVIDENCE" in runtime
    assert "EGRESS_SPEED_KMH=1" in regulation
    assert "physicalDisplacementM" in regulation


def test_reverse_speed_is_native_and_has_scoped_cruise_restoration():
    path = ROOT / "scripts/control/mechanisms/NativeReverseMechanism.lua"
    code = path.read_text(encoding="utf-8")
    assert "getMaximumBackwardSpeed" in code
    assert "speedMps*3.6" in code
    assert "setCruiseControlMaxSpeed" in code
    assert "restoreNativeCruiseSpeed" in code
    assert "REVERSE_SPEED_KMH=8" not in code
    assert "state.speedLease.speedKmh" in code


def test_player_control_takeover_is_not_a_live_authority_predicate():
    assert not (ROOT / "scripts/observation/CurrentPlayerControlObservation.lua").exists()
    for consumer in (
        "scripts/coordination/LiveHoldRelocateRuntime.lua",
        "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua",
        "scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua",
    ):
        content = (ROOT / consumer).read_text(encoding="utf-8")
        assert "CurrentPlayerControlObservation" not in content
        assert "getIsControlled" not in content
        assert "getIsEntered" not in content
        assert "controlledVehicle" not in content
        assert "PLAYER_CONTROL" not in content
        assert "PLAYER_TAKEOVER" not in content
    authority = (ROOT / "scripts/coordination/NativePairCommitmentAuthority.lua").read_text(
        encoding="utf-8")
    assert "admitStaticBlockerCandidate" in authority
    assert "STATIC_SUBJECT_CURRENTLY_CONTROLLED" not in authority
    assert "c.playerControlled==false" not in authority
    assert "math.abs(c.relativeCrossTrackM)<=5" not in authority
    assert "c.relativeForwardM>0" not in authority
    assert "c.distanceM<=30" in authority
    actuator = (ROOT / "scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua").read_text(
        encoding="utf-8")
    assert "STATIC_SUBJECT_CLAIMED" not in actuator
    assert "STATIC_SUBJECT_AI_RECLAIMED" in actuator
    coordinator = (ROOT / "scripts/coordination/HoldRelocateCoordinator.lua").read_text(
        encoding="utf-8")
    assert "STATIC_EGRESS_FAILSAFE_MS=25000" in coordinator
    assert '"STATIC_EGRESS_FAILSAFE_25S"' in coordinator


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
    assert 'aiControl=false' not in main_text()
    assert 'aiControl=g_server~=nil' in main_text()


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


def test_manifest_describes_live_ai_control():
    moddesc = (ROOT / "modDesc.xml").read_text(encoding="utf-8")
    assert "live Hold &amp; Relocate" in moddesc
    assert "This build does not control AI workers." not in moddesc
    assert "AI worker coordination is inactive." not in moddesc


def test_every_production_script_is_reachable_from_the_shell():
    actual = {path.relative_to(ROOT).as_posix() for path in (ROOT / "scripts").rglob("*.lua")}
    assert actual == set(SHELL_MODULES) | {"scripts/main.lua"}
    assert "scripts/diagnostics/NativeBlockedProbe.lua" not in actual
    assert "scripts/diagnostics/NativeBlockedEventTap.lua" not in actual
