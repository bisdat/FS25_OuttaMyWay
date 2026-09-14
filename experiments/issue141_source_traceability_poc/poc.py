#!/usr/bin/env python3
"""Issue #141 source-traceability representation proof of concept.

This experiment never edits production Lua. It copies three representative modules
into a generated workspace, prepends an LDoc-compatible module block containing an
untyped Jurisdiction acknowledgement, and appends a small LuaCATS-style param/return
probe. The same @participates facts are then consumed independently by a minimal
extractor and by LDoc.
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EXPERIMENT = ROOT / "experiments" / "issue141_source_traceability_poc"
WORKSPACE = EXPERIMENT / "workspace"
SRC = WORKSPACE / "src"
DOC = WORKSPACE / "doc"
GRAPH = WORKSPACE / "graph.json"

TARGETS = (
    {
        "path": "scripts/control/LiveControlDispatcher.lua",
        "module": "OuttaMyWay.LiveControlDispatcher",
        "summary": "Dispatches already-authorised Control requests to purpose-specific executors.",
        "jurisdictions": ("CONTROL",),
    },
    {
        "path": "scripts/control/CooperativePassageControl.lua",
        "module": "OuttaMyWay.CooperativePassageControl",
        "summary": "Executes already-authorised Cooperative Passage choreography and handback.",
        "jurisdictions": ("COOPERATIVE_PASSAGE", "CONTROL"),
    },
    {
        "path": "scripts/representation/AssemblyRepresentationCache.lua",
        "module": "OuttaMyWay.AssemblyRepresentationCache",
        "summary": "Maintains Job-Episode physical-assembly representation and cached capability evidence.",
        "jurisdictions": ("ASSESSMENT_REPRESENTATION", "PHYSICAL_IDENTITY_RESOLUTION"),
    },
)

PARTICIPATES = re.compile(r"^\s*--+\s*@participates\s+([A-Z][A-Z0-9_]*)\s*$")


def generated_name(path: str) -> str:
    return path.replace("/", "__")


def expected_graph() -> dict[str, list[str]]:
    return {
        item["path"]: sorted(item["jurisdictions"])
        for item in TARGETS
    }


def prepare() -> None:
    if WORKSPACE.exists():
        shutil.rmtree(WORKSPACE)
    SRC.mkdir(parents=True)

    for item in TARGETS:
        source_path = ROOT / item["path"]
        if not source_path.is_file():
            raise SystemExit(f"missing production source: {item['path']}")
        source = source_path.read_text(encoding="utf-8")

        header = [
            f"--- {item['summary']}",
            f"-- POC copy of `{item['path']}`; production source is unchanged.",
            f"-- @module {item['module']}",
        ]
        header.extend(f"-- @participates {jurisdiction}" for jurisdiction in item["jurisdictions"])
        header.append("")

        # LDoc 1.5 explicitly supports LuaLS-style @param/@return forms.  This
        # generated local function is intentionally absent from production source;
        # it proves the two documentation syntaxes can be parsed in one file.
        luacats_probe = """

--- LuaLS/LuaCATS coexistence probe for Issue #141.
---@param value string
---@return string
local function __omwIssue141PocIdentity(value)
    return value
end
"""
        output = SRC / generated_name(item["path"])
        output.write_text("\n".join(header) + source + luacats_probe, encoding="utf-8")

    config = """project = 'OuttaMyWay Issue #141 Traceability POC'
title = 'OuttaMyWay Issue #141 Traceability POC'
description = 'Generated experiment only; no production source is modified.'
file = 'experiments/issue141_source_traceability_poc/workspace/src'
dir = 'experiments/issue141_source_traceability_poc/workspace/doc'
format = 'markdown'
all = true
not_luadoc = true
custom_tags = {
    { 'participates', title = 'Specification Jurisdictions' },
}
"""
    (WORKSPACE / "config.ld").write_text(config, encoding="utf-8")
    print(f"prepared {len(TARGETS)} real-source copies in {SRC.relative_to(ROOT)}")


def extract() -> None:
    actual: dict[str, list[str]] = {}
    for item in TARGETS:
        generated = SRC / generated_name(item["path"])
        if not generated.is_file():
            raise SystemExit(f"generated source missing: {generated}")
        found: list[str] = []
        for line in generated.read_text(encoding="utf-8").splitlines():
            match = PARTICIPATES.match(line)
            if match:
                found.append(match.group(1))
        if len(found) != len(set(found)):
            raise SystemExit(f"duplicate @participates declaration in {item['path']}: {found}")
        actual[item["path"]] = sorted(found)

    expected = expected_graph()
    if actual != expected:
        raise SystemExit(
            "deterministic extraction mismatch:\n"
            + json.dumps({"expected": expected, "actual": actual}, indent=2, sort_keys=True)
        )
    GRAPH.write_text(json.dumps(actual, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("deterministic extraction PASS")
    print(GRAPH.read_text(encoding="utf-8"), end="")


def verify_render() -> None:
    html_files = sorted(DOC.rglob("*.html"))
    if not html_files:
        raise SystemExit(f"LDoc produced no HTML under {DOC}")
    rendered = "\n".join(path.read_text(encoding="utf-8", errors="replace") for path in html_files)

    required = {
        jurisdiction
        for jurisdictions in expected_graph().values()
        for jurisdiction in jurisdictions
    }
    required.add("__omwIssue141PocIdentity")
    missing = sorted(value for value in required if value not in rendered)
    if missing:
        raise SystemExit(f"LDoc output missing expected rendered values: {missing}")

    if not GRAPH.is_file():
        raise SystemExit("graph.json missing; extractor did not run")
    print(f"LDoc render PASS ({len(html_files)} HTML files)")
    print("LuaLS/LuaCATS param/return coexistence PASS")
    print("custom @participates rendering PASS")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("prepare", "extract", "verify-render"))
    args = parser.parse_args()
    {"prepare": prepare, "extract": extract, "verify-render": verify_render}[args.command]()


if __name__ == "__main__":
    main()
