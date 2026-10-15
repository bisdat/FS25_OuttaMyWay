"""Active-source Log Publication producer contracts for issue #486.

These assertions test descriptor decisions where they originate, rather than
mistaking GIANTS Info severity or central cumulative eligibility for NORMAL.
"""

from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
MAIN = SCRIPTS / "main.lua"


def read(path: str) -> str:
    return (SCRIPTS / path).read_text(encoding="utf-8")


def test_live_module_census_and_no_independent_logging_destinations() -> None:
    main = MAIN.read_text(encoding="utf-8")
    loaded = set(re.findall(r'"(scripts/[^"]+\.lua)"', main))
    assert loaded
    assert all((ROOT / path).is_file() for path in loaded)

    producers = {
        "scripts/main.lua",
        "scripts/control/CompletionSettlementRuntime.lua",
        "scripts/control/CompletionTransitRuntime.lua",
        "scripts/coordination/LiveHoldRelocateRuntime.lua",
        "scripts/observation/NativeBlockageObservation.lua",
        "scripts/observation/NativeJobCompletionProbe.lua",
        "scripts/diagnostics/NativeContinuationWitness.lua",
        "scripts/diagnostics/PairClearanceWitness.lua",
        "scripts/diagnostics/ReverseKinematicsProbe.lua",
        "scripts/gui/ConfigurationSettingsExtension.lua",
    }
    assert producers - {"scripts/main.lua"} <= loaded

    direct_destination = re.compile(r"\bLogging\s*(?:\.\s*(?:info|warning|error)\b|\[)")
    for relative in loaded - {"scripts/publication/LogPublication.lua"}:
        source = (ROOT / relative).read_text(encoding="utf-8")
        assert not direct_destination.search(source), relative

    for relative in loaded - producers - {"scripts/publication/LogPublication.lua"}:
        source = (ROOT / relative).read_text(encoding="utf-8")
        # A facade is not a direct log destination. Non-producers must stay silent.
        assert not re.search(r"\bpublication\s*:\s*(?:publish|info|warning|error|format)\s*\(", source), relative
        assert not re.search(r"\bissue\s*\(", source), relative


def test_version_identity_is_published_once_at_startup_not_per_event() -> None:
    main = MAIN.read_text(encoding="utf-8")
    assert main.count("version=OuttaMyWay.VERSION") == 2
    assert '"OUTTAMYWAY_SHELL_STARTED"' in main
    assert '"CONFIGURATION_STORAGE_FAILED"' in main
    assert 'return {aiControl=g_server~=nil and notification.value==true}' in main

    # Startup failure is an alternative to successful startup, not a second
    # routine event. The persistent version-only HUD is deliberately excluded.
    loaded = set(re.findall(r'"(scripts/[^"]+\.lua)"', main))
    for relative in loaded - {"scripts/config.lua", "scripts/diagnostics/VersionHud.lua"}:
        if relative == "scripts/main.lua":
            continue
        source = (ROOT / relative).read_text(encoding="utf-8")
        assert not re.search(r"\bversion\s*=\s*OuttaMyWay\.VERSION", source), relative


def test_completion_settlement_publishes_only_operational_transitions_at_normal() -> None:
    source = read("control/CompletionSettlementRuntime.lua")
    assert 'publication:publish(publicationClass,level,code,' in source
    expected = {
        "COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED": ("NORMAL", "WARNING"),
        "COMPLETION_SETTLEMENT_CLAIM_RETAINED": ("NORMAL", "WARNING"),
        "COMPLETION_SETTLEMENT_ADMITTED": ("NORMAL", "INFO"),
        "COMPLETION_SETTLEMENT_PLANNING_STARTED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_LOCAL_HANDOFF_PLANNING": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_ALLOCATING_REGION": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_REGION_CLAIMED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_LEG_STARTED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_LEG_FINISHED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_STOPPING": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_ALTERNATIVE_STOPPING": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_ALTERNATIVE_STOPPED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_QUEUED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_ALTERNATIVE_QUEUED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_DEFERRED_FOR_PARKING_SPACE": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_QUEUED_REJECTED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_ALREADY_AT_QUALIFIED_ENTRY": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_SCENE_ADMISSION_FAILED": ("DEBUG", "INFO"),
        "COMPLETION_SETTLEMENT_LOCAL_ENTRY_REJECTED": ("DIAGNOSTIC", "INFO"),
    }
    for code, (cls, severity) in expected.items():
        assert f'publish("{cls}","{severity}","{code}"' in source, code

    assert 'publish("NORMAL",\n        (code=="COMPLETION_SETTLEMENT_FINISHED"' in source
    assert 'or reason=="PLAYER_DISABLED" or reason=="CONTROL_REVOKED"' in source
    assert 'publish("DEBUG","INFO","COMPLETION_SETTLEMENT_NOT_ADMITTED"' in source
    assert 'publish("NORMAL","WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED"' in source
    assert '"COMPLETION_SETTLEMENT_ADMISSION_EVIDENCE",function()' in source
    assert '"COMPLETION_SETTLEMENT_LEG_STARTED",function() return {' in source
    assert '"COMPLETION_SETTLEMENT_REGION_CLAIMED",function() return {' in source
    assert 'and publication:isEligible("DIAGNOSTIC","INFO",' in source
    assert '"COMPLETION_SETTLEMENT_LOCAL_ENTRY_REJECTED") then' in source
    assert 'verification="ADMITTED_ROUTE_NOT_PHYSICAL_PARKING_RESULT"' in source


def test_hold_relocate_distinguishes_attempt_and_rejected_candidate() -> None:
    source = read("coordination/LiveHoldRelocateRuntime.lua")
    assert 'publication:publish(publicationClass or "DEBUG",level,code,' in source
    assert 'publication:publish("DEBUG","INFO","HOLD_RELOCATE_ADMISSION_REJECTED"' in source
    assert '"HOLD_RELOCATE_STARTED",' in source
    assert '"HOLD_RELOCATE_ADMISSION_EVIDENCE") then' in source
    assert '"HOLD_RELOCATE_ADMISSION_EVIDENCE",\n                        details,"DEBUG")' in source
    assert '"HOLD_RELOCATE_NOT_STARTED",why,"NORMAL")' in source
    assert '"HOLD_RELOCATE_UNRESOLVED",why,"NORMAL")' in source
    assert '"HOLD_RELOCATE_OUTCOME",\n                        "commitmentId="' in source
    assert '"PAIR_TRANSIT_SETTLEMENT_EXHAUSTED",function() return' in source
    assert 'type(detail)=="function" and detail() or detail' in source
    for code in (
        "HOLD_RELOCATE_EGRESS_STARTED",
        "HOLD_RELOCATE_STEERING_SELECTION",
        "HOLD_RELOCATE_STATIC_ACTUATION_EVIDENCE",
        "HOLD_RELOCATE_INITIAL_REVERSE_VECTOR",
        "HOLD_RELOCATE_EGRESS_REGULATION_EVIDENCE",
    ):
        assert re.search(rf'"{code}",\s*function\(\) return', source), code


def test_diagnostic_witnesses_are_targeted_and_request_only_transit_is_normal() -> None:
    transit = read("control/CompletionTransitRuntime.lua")
    job = read("observation/NativeJobCompletionProbe.lua")
    blockage = read("observation/NativeBlockageObservation.lua")
    continuation = read("diagnostics/NativeContinuationWitness.lua")
    clearance = read("diagnostics/PairClearanceWitness.lua")
    reverse = read("diagnostics/ReverseKinematicsProbe.lua")

    assert 'publication:publish("NORMAL",accepted and "INFO" or "WARNING"' in transit
    assert '"COMPLETED_WORKER_TRANSIT_REQUESTED"' in transit
    assert '"COMPLETED_WORKER_TRANSIT_UNAVAILABLE"' in transit
    assert 'publication:publish("DIAGNOSTIC","INFO","NATIVE_FIELDWORK_JOB_STOPPED"' in job
    assert 'publication:publish("DEBUG","INFO",' in blockage
    assert 'publication:publish("DEBUG","INFO",code,' in blockage
    assert 'state.publisher,\n        "DIAGNOSTIC","INFO",code,' in continuation
    assert 'publisher,"DIAGNOSTIC","INFO",code,' in clearance
    assert 'publisher,"DIAGNOSTIC","INFO",code,' in reverse
    assert 'if not enabled(self.publisher) then return false end' in continuation
    assert 'if not enabled(self.publisher) then return false end' in clearance
    assert 'if not ok or eligible~=true then return nil end' in reverse


def test_configuration_warnings_stay_normal_and_renderer_contract_stays_intact() -> None:
    settings = read("gui/ConfigurationSettingsExtension.lua")
    renderer = read("publication/LogPublication.lua")
    policy = read("diagnostics/DiagnosticPublicationPolicySource.lua")
    for code in ("CONFIGURATION_CHANGE_PERSISTENCE_FAILED", "CONFIGURATION_SECTION_UNAVAILABLE"):
        assert f'publication:warning("NORMAL","{code}"' in settings
    assert 'if CLASS_RANK[descriptor.publicationClass]>CLASS_RANK[policy]' in renderer
    assert 'local ok,payload=pcall(payloadBuilder,...)' in renderer
    assert 'if descriptor.publicationClass=="NORMAL" then' in renderer
    assert '"[FS25_OuttaMyWay][%s][%s]"' in renderer
    assert 'XMLFile.create' not in policy
