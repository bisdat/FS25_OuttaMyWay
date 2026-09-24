from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
PUBLISHER = SCRIPTS / "publication" / "LogPublication.lua"
CONFIG = SCRIPTS / "config.lua"
MAIN = SCRIPTS / "main.lua"

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


def test_publisher_owns_dynamic_destination_and_migration_policy_is_config_input() -> None:
    publisher = PUBLISHER.read_text(encoding="utf-8")
    config = CONFIG.read_text(encoding="utf-8")
    main = MAIN.read_text(encoding="utf-8")

    assert "Logging and Logging[method]" in publisher
    assert "DIAGNOSTIC_LOGGING" not in config
    assert "if OuttaMyWay.DIAGNOSTIC_LOGGING==nil then OuttaMyWay.DIAGNOSTIC_LOGGING=true end" in main
    assert 'OuttaMyWay.DIAGNOSTIC_LOGGING==true and "DIAGNOSTIC" or "NORMAL"' in main
    assert 'OUTTAMYWAY_STARTED' in main


def test_suppressed_diagnostic_projection_stops_before_avoidable_source_work() -> None:
    observation = (SCRIPTS / "observation" / "LiveObservationSource.lua").read_text(encoding="utf-8")
    adapter = (SCRIPTS / "observation" / "RuntimeObservationAdapter.lua").read_text(encoding="utf-8")
    situation = (SCRIPTS / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    validator = (SCRIPTS / "diagnostics" / "PassiveLiveValidator.lua").read_text(encoding="utf-8")
    physical = (SCRIPTS / "observation" / "CurrentPhysicalAssemblySource.lua").read_text(encoding="utf-8")
    causal = (SCRIPTS / "assessment" / "CausalObstructionAssessment.lua").read_text(encoding="utf-8")
    runtime = (SCRIPTS / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    passage = (SCRIPTS / "control" / "CooperativePassageControl.lua").read_text(encoding="utf-8")
    relocation = (SCRIPTS / "control" / "ObstructionRelocationControl.lua").read_text(encoding="utf-8")

    assert 'local diagnosticActive=diagnosticProjectionEnabled()' in observation
    assert 'if diagnosticActive then\n            raw.diagnostics={' in observation
    assert 'diagnostics=raw.diagnostics~=nil and shallowCopy(raw.diagnostics) or nil' in adapter
    assert 'local diagnosticProjectionActive=snapshot.diagnostics~=nil' in situation
    assert 'if diagnosticProjectionActive then' in situation

    validator_gate = validator.index('if not publicationEnabled() then return end', validator.index('function Validator:observeRuntimeResult'))
    validator_projection = validator.index('local projection=self:_project(live)', validator.index('function Validator:observeRuntimeResult'))
    assert validator_gate < validator_projection

    assert 'diagnosticPublicationEnabled("MISSION_ASSEMBLY_CENSUS")' in physical
    assert 'publication:isEligible("DIAGNOSTIC","INFO","CAUSAL_OBSTRUCTION_RELATION_CENSUS")' in causal
    assert 'publication:isEligible("DIAGNOSTIC","INFO","COOPERATIVE_PASSAGE_CONSTRAINT_VERDICT")' in runtime
    assert 'diagnosticPublicationEnabled("COOPERATIVE_PASSAGE_STATE")' in passage
    assert 'diagnosticPublicationEnabled("OBSTRUCTION_RELOCATION_STEERING_HEARTBEAT")' in relocation
