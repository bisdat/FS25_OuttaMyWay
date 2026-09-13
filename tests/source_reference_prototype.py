#!/usr/bin/env python3
"""Deterministic non-production source-reference prototype for Issue #141.

This tool intentionally reads source text rather than executing production Lua.
The temporary JSON manifest stands in for future colocated source metadata while
that annotation contract is still under falsification.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any

ROOT = Path(__file__).resolve().parents[1]
MANIFEST_PATH = ROOT / "tests/source_reference_prototype_manifest.json"
DEFAULT_GENERATED_PATH = (
    ROOT / "docs/research/prototypes/PROTOTYPE_35_SOURCE_REFERENCE.generated.md"
)

ALLOWED_ROLES = {"semantic-boundary", "contract-value", "shared-substrate"}


def _load_manifest() -> dict[str, Any]:
    return json.loads(MANIFEST_PATH.read_text(encoding="utf-8"))


def _relative_link(path: str) -> str:
    return "../../../" + path


def _function_symbol_exists(source_text: str, symbol: str) -> bool:
    escaped = re.escape(symbol)
    pattern = rf"function\s+(?:OuttaMyWay\.[A-Za-z_]\w*|[A-Za-z_]\w*)[\.:]{escaped}\s*\("
    return re.search(pattern, source_text) is not None


def _record_schema(source_text: str) -> tuple[str, list[str], list[str]] | None:
    match = re.search(
        r"ValueRecord\.define\(\s*\"([^\"]+)\"\s*,\s*\{([^}]*)\}\s*,\s*\{([^}]*)\}",
        source_text,
        re.DOTALL,
    )
    if match is None:
        return None
    required = re.findall(r'\"([^\"]+)\"', match.group(2))
    optional = re.findall(r'\"([^\"]+)\"', match.group(3))
    return match.group(1), required, optional


def validate_manifest() -> list[str]:
    manifest = _load_manifest()
    errors: list[str] = []

    if manifest.get("schema") != 1:
        errors.append("manifest schema must be 1")

    entries = manifest.get("entries")
    if not isinstance(entries, list) or not entries:
        errors.append("manifest entries must be a non-empty list")
        return errors

    seen_sources: set[str] = set()
    for entry in entries:
        source = entry.get("source")
        role = entry.get("role")
        export = entry.get("export")
        primary_spec = entry.get("primary_spec")
        related_specs = entry.get("related_specs") or []
        boundary_symbols = entry.get("boundary_symbols") or []

        if not isinstance(source, str) or not source:
            errors.append("entry source must be a non-empty string")
            continue
        if source in seen_sources:
            errors.append(f"duplicate source entry: {source}")
        seen_sources.add(source)

        if role not in ALLOWED_ROLES:
            errors.append(f"{source}: unsupported role {role!r}")
        if role == "shared-substrate" and primary_spec is not None:
            errors.append(f"{source}: shared-substrate must not manufacture a primary Spec")
        if role in {"semantic-boundary", "contract-value"} and not primary_spec:
            errors.append(f"{source}: {role} requires a primary Spec")

        source_path = ROOT / source
        if not source_path.is_file():
            errors.append(f"{source}: source path does not exist")
            continue
        source_text = source_path.read_text(encoding="utf-8")

        if not isinstance(export, str) or not export:
            errors.append(f"{source}: export must be declared")
        elif re.search(rf"{re.escape(export)}\s*=", source_text) is None:
            errors.append(f"{source}: declared export {export} not found")

        if not isinstance(boundary_symbols, list):
            errors.append(f"{source}: boundary_symbols must be a list")
        else:
            for symbol in boundary_symbols:
                if not isinstance(symbol, str) or not symbol:
                    errors.append(f"{source}: boundary symbol must be a non-empty string")
                elif not _function_symbol_exists(source_text, symbol):
                    errors.append(f"{source}: boundary symbol {symbol} not found")

        all_specs = ([primary_spec] if primary_spec else []) + list(related_specs)
        for spec_path_text in all_specs:
            spec_path = ROOT / spec_path_text
            if not spec_path.is_file():
                errors.append(f"{source}: referenced Spec does not exist: {spec_path_text}")

        if primary_spec:
            spec_text = (ROOT / primary_spec).read_text(encoding="utf-8")
            if source not in spec_text:
                errors.append(
                    f"{source}: primary Spec does not route back to this source: {primary_spec}"
                )

        if role == "contract-value" and _record_schema(source_text) is None:
            errors.append(f"{source}: contract-value prototype expects a ValueRecord schema")

    return errors


def render_reference() -> str:
    manifest = _load_manifest()
    lines = [
        "# Generated source-reference prototype",
        "",
        "> **Generated prototype evidence — do not edit by hand.** This file is",
        "> deterministic output from `tests/source_reference_prototype.py` and the",
        "> temporary prototype manifest. It reports source facts and traceability; it",
        "> does not own Architecture or Specification semantics.",
        "",
    ]

    for entry in sorted(manifest["entries"], key=lambda item: item["source"]):
        source = entry["source"]
        source_text = (ROOT / source).read_text(encoding="utf-8")
        primary_spec = entry.get("primary_spec")
        related_specs = entry.get("related_specs") or []
        boundary_symbols = entry.get("boundary_symbols") or []

        lines.append(f"## [`{source}`]({_relative_link(source)})")
        lines.append("")
        lines.append(f"- Prototype source role: `{entry['role']}`")
        lines.append(f"- Export: `{entry['export']}`")
        if primary_spec:
            lines.append(
                f"- Primary Specification: [`{primary_spec}`]({_relative_link(primary_spec)})"
            )
        else:
            lines.append("- Primary Specification: none — shared implementation substrate")
        if related_specs:
            rendered = ", ".join(
                f"[`{path}`]({_relative_link(path)})" for path in related_specs
            )
            lines.append(f"- Related Specifications: {rendered}")
        else:
            lines.append("- Related Specifications: none")
        if boundary_symbols:
            lines.append(
                "- Declared semantic-boundary symbols: "
                + ", ".join(f"`{symbol}`" for symbol in boundary_symbols)
            )
        else:
            lines.append("- Declared semantic-boundary symbols: none")

        schema = _record_schema(source_text)
        if schema is not None:
            record_name, required, optional = schema
            lines.append(f"- Discovered `ValueRecord`: `{record_name}`")
            lines.append(
                "  - required fields: "
                + (", ".join(f"`{name}`" for name in required) if required else "none")
            )
            lines.append(
                "  - optional fields: "
                + (", ".join(f"`{name}`" for name in optional) if optional else "none")
            )
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--check",
        nargs="?",
        const=str(DEFAULT_GENERATED_PATH),
        help="compare generated output with PATH (default: committed prototype output)",
    )
    parser.add_argument(
        "--write",
        nargs="?",
        const=str(DEFAULT_GENERATED_PATH),
        help="write generated output to PATH (default: committed prototype output)",
    )
    args = parser.parse_args()

    errors = validate_manifest()
    if errors:
        for error in errors:
            print(f"source-reference prototype error: {error}", file=sys.stderr)
        return 1

    rendered = render_reference()

    if args.write:
        target = Path(args.write)
        if not target.is_absolute():
            target = ROOT / target
        target.write_text(rendered, encoding="utf-8")
        return 0

    if args.check:
        target = Path(args.check)
        if not target.is_absolute():
            target = ROOT / target
        if not target.is_file():
            print(f"generated reference missing: {target}", file=sys.stderr)
            return 1
        current = target.read_text(encoding="utf-8")
        if current != rendered:
            print(
                "generated source-reference prototype is stale; run "
                "`python tests/source_reference_prototype.py --write`",
                file=sys.stderr,
            )
            return 1
        return 0

    sys.stdout.write(rendered)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
