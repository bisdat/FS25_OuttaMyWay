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
