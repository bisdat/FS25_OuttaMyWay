#!/usr/bin/env python3
"""Prepare and verify the derived LDoc source reference.

The generated workspace is disposable and non-authoritative. Production Lua is
never rewritten: this tool copies /scripts into .generated/source-reference/src
and adds only generated LDoc module identities where needed so the existing
source documentation can be rendered consistently.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SCRIPTS = ROOT / "scripts"
WORKSPACE = ROOT / ".generated" / "source-reference"
SRC = WORKSPACE / "src"
HTML = WORKSPACE / "html"
MANIFEST = WORKSPACE / "manifest.json"
ACK_RE = re.compile(r"^-- Specification Jurisdictions:\s*(.+?)\s*$", re.MULTILINE)
BACKTICK_ID_RE = re.compile(r"`([A-Z][A-Z0-9_]*)`")
MODULE_RE = re.compile(r"^--+\s*@module\s+\S+", re.MULTILINE)


def module_name(path: Path) -> str:
    relative = path.relative_to(SCRIPTS).with_suffix("")
    return "OuttaMyWay.Source." + ".".join(relative.parts)


def add_generated_module_identity(source: str, path: Path) -> str:
    if MODULE_RE.search(source):
        return source

    lines = source.splitlines()
    if not lines:
        lines = ["--- Empty production source file."]

    first = 0
    while first < len(lines) and lines[first].strip() == "":
        first += 1

    module_line = f"-- @module {module_name(path)}"

    if first < len(lines) and lines[first].startswith("--"):
        if not lines[first].startswith("---"):
            lines[first] = "---" + lines[first][2:]
        insert_at = first + 1
        while insert_at < len(lines) and lines[insert_at].startswith("--"):
            insert_at += 1
        lines.insert(insert_at, module_line)
    else:
        header = [
            f"--- Generated source-reference entry for `{path.relative_to(ROOT).as_posix()}`.",
            "-- Production source contains no leading documentation block; inspect the source and governing Specification for semantic meaning.",
            module_line,
            "",
        ]
        lines[first:first] = header

    return "\n".join(lines) + "\n"


def prepare() -> None:
    if WORKSPACE.exists():
        shutil.rmtree(WORKSPACE)
    SRC.mkdir(parents=True)

    source_files = sorted(SCRIPTS.rglob("*.lua"))
    jurisdictions: set[str] = set()
    modules: list[dict[str, str]] = []

    for path in source_files:
        relative = path.relative_to(SCRIPTS)
        source = path.read_text(encoding="utf-8")
        for declaration in ACK_RE.findall(source):
            jurisdictions.update(BACKTICK_ID_RE.findall(declaration))

        output = SRC / relative
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_text(add_generated_module_identity(source, path), encoding="utf-8")
        modules.append(
            {
                "source": path.relative_to(ROOT).as_posix(),
                "generatedModule": module_name(path),
            }
        )

    tested_commit = os.environ.get("GITHUB_SHA", "LOCAL_OR_UNKNOWN")
    source_head_commit = os.environ.get("OMW_SOURCE_HEAD_SHA", tested_commit)
    manifest = {
        "authority": "DERIVED_NON_AUTHORITATIVE_SOURCE_REFERENCE",
        "sourceHeadCommit": source_head_commit,
        "testedCommit": tested_commit,
        "moduleCount": len(modules),
        "jurisdictions": sorted(jurisdictions),
        "modules": modules,
    }
    MANIFEST.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    (WORKSPACE / "README.txt").write_text(
        "OuttaMyWay generated source reference\n"
        "\n"
        "This output is a derived human reference generated from production source.\n"
        "It is not Architecture, Specification, source authority, or conformance evidence.\n"
        "The manifest distinguishes the source head revision from the exact commit tested by the workflow.\n",
        encoding="utf-8",
    )
    print(f"prepared {len(modules)} production Lua modules for LDoc")


def verify() -> None:
    if not MANIFEST.is_file():
        raise SystemExit("missing source-reference manifest")
    if not (HTML / "index.html").is_file():
        raise SystemExit("LDoc did not produce index.html")

    manifest = json.loads(MANIFEST.read_text(encoding="utf-8"))
    html_files = sorted(HTML.rglob("*.html"))
    if not html_files:
        raise SystemExit("LDoc produced no HTML files")

    rendered = "\n".join(path.read_text(encoding="utf-8", errors="replace") for path in html_files)
    for jurisdiction in manifest["jurisdictions"]:
        if jurisdiction not in rendered:
            raise SystemExit(f"rendered source reference omitted Jurisdiction ID: {jurisdiction}")

    if manifest["jurisdictions"] and "Specification Jurisdictions" not in rendered:
        raise SystemExit("rendered source reference omitted Specification Jurisdictions metadata")

    print(
        "verified generated source reference: "
        f"modules={manifest['moduleCount']} jurisdictions={len(manifest['jurisdictions'])} htmlFiles={len(html_files)}"
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("command", choices=("prepare", "verify"))
    args = parser.parse_args()
    if args.command == "prepare":
        prepare()
    else:
        verify()


if __name__ == "__main__":
    main()
