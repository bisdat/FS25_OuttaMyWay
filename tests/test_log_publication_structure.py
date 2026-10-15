from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
PUBLISHER = SCRIPTS / "publication" / "LogPublication.lua"
CONFIG = SCRIPTS / "config.lua"
MAIN = SCRIPTS / "main.lua"
DIAGNOSTIC_POLICY_SOURCE = SCRIPTS / "diagnostics" / "DiagnosticPublicationPolicySource.lua"
DIAGNOSTIC_EXAMPLE = ROOT / "tools" / "diagnostics.example.xml"

DESTINATION_RE = re.compile(r"\bLogging\s*(?:\.(?:info|warning|error)\b|\[[^\]]+\])")
PREFIX_PRINT_RE = re.compile(r"""\bprint\s*\([^\n]*FS25_OuttaMyWay""")


def test_only_log_publication_addresses_runtime_log_destination() -> None:
    violations: list[str] = []
    for path in sorted(SCRIPTS.rglob("*.lua")):
        text = path.read_text(encoding="utf-8")
        if path == PUBLISHER:
            continue
        for line_number, line in enumerate(text.splitlines(), start=1):
            if DESTINATION_RE.search(line):
                violations.append(f"{path.relative_to(ROOT)}:{line_number}: direct Logging destination access")
            if PREFIX_PRINT_RE.search(line):
                violations.append(f"{path.relative_to(ROOT)}:{line_number}: direct OuttaMyWay print publication")
    assert violations == []


def test_publisher_owns_dynamic_destination_and_engineering_policy_is_separate_from_player_configuration() -> None:
    publisher = PUBLISHER.read_text(encoding="utf-8")
    config = CONFIG.read_text(encoding="utf-8")
    main = MAIN.read_text(encoding="utf-8")
    policy_source = DIAGNOSTIC_POLICY_SOURCE.read_text(encoding="utf-8")
    example = DIAGNOSTIC_EXAMPLE.read_text(encoding="utf-8")

    assert "Logging and Logging[method]" in publisher
    assert "DIAGNOSTIC_LOGGING" not in config
    assert "DIAGNOSTIC_LOGGING" not in main
    assert "DIAGNOSTIC_LOGGING" not in policy_source
    assert '"scripts/diagnostics/DiagnosticPublicationPolicySource.lua"' in main
    assert main.index('"scripts/diagnostics/DiagnosticPublicationPolicySource.lua"') < main.index('"scripts/publication/LogPublication.lua"')
    assert "OuttaMyWay.DiagnosticPublicationPolicySource.new(OuttaMyWay.MOD_NAME)" in main
    assert "OuttaMyWay.diagnosticPublicationPolicySource:loadSidecar()" in main
    assert 'OuttaMyWay.diagnosticPublicationPolicySource:publicationPolicy()=="DIAGNOSTIC"' in main
    assert 'OuttaMyWay.configuration:isDebugEnabled()==true then return "DEBUG"' in main
    assert 'return "NORMAL"' in main
    assert "fileExists" in policy_source
    assert "XMLSchema.new" in policy_source
    assert "XMLFile.loadIfExists" in policy_source
    assert "XMLFile.create" not in policy_source
    assert "createFolder" not in policy_source
    assert "modSettings/<modName>/diagnostics.xml" in example
    assert '<outtaMyWayDiagnostics enabled="true" />' in example
    assert 'OUTTAMYWAY_SHELL_STARTED' in main


def test_suppressed_projection_stops_before_avoidable_source_work() -> None:
    settlement = (SCRIPTS / "control" / "CompletionSettlementRuntime.lua").read_text(encoding="utf-8")
    blockage = (SCRIPTS / "observation" / "NativeBlockageObservation.lua").read_text(encoding="utf-8")
    hold = (SCRIPTS / "coordination" / "LiveHoldRelocateRuntime.lua").read_text(encoding="utf-8")
    clearance = (SCRIPTS / "diagnostics" / "PairClearanceWitness.lua").read_text(encoding="utf-8")
    reverse = (SCRIPTS / "diagnostics" / "ReverseKinematicsProbe.lua").read_text(encoding="utf-8")

    assert 'or not publication:isEligible("DIAGNOSTIC","INFO",' in settlement
    assert '"COMPLETION_SETTLEMENT_MOTION_SAMPLE") then return end' in settlement
    assert 'and publication:isEligible("DIAGNOSTIC","INFO",' in settlement
    assert '"COMPLETION_SETTLEMENT_LOCAL_ENTRY_REJECTED") then' in settlement
    assert 'publication:publish("DEBUG","INFO",' in blockage
    assert 'evidence=OuttaMyWay.StaticBlockageEncounterObservation.describe(' in blockage
    assert 'type(detail)=="function" and detail() or detail' in hold
    assert 'and self.publication:isEligible("DEBUG","INFO",' in hold
    assert 'if not enabled(self.publisher) then return false end' in clearance
    assert 'if not ok or eligible~=true then return nil end' in reverse
