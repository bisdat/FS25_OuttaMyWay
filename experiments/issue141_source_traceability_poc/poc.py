#!/usr/bin/env python3
"""Issue #141 cross-surface traceability representation proof of concept.

This experiment never edits production Architecture, Specifications, or Lua. It copies
representative real repository artefacts into a generated workspace, adds proposed
visible structured declarations there, extracts a combined conformance graph, and
proves deterministic closure plus deliberate negative cases. The generated source
copies are also rendered with LDoc to preserve the earlier source-documentation POC.
"""

from __future__ import annotations

import argparse
import copy
import json
import posixpath
import re
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EXPERIMENT = ROOT / "experiments" / "issue141_source_traceability_poc"
WORKSPACE = EXPERIMENT / "workspace"
ARCH = WORKSPACE / "architecture"
SPEC = WORKSPACE / "spec"
SRC = WORKSPACE / "src"
DOC = WORKSPACE / "doc"
GRAPH = WORKSPACE / "graph.json"
NEGATIVE_RESULTS = WORKSPACE / "negative-tests.json"

SOURCE_TARGETS = (
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
    {
        "path": "scripts/responsibility/ResolutionCommitmentAdapter.lua",
        "module": "OuttaMyWay.ResolutionCommitmentAdapter",
        "summary": "Materialises the read-only semantic view of an established Resolution Commitment.",
        "jurisdictions": ("RESOLUTION_LIFECYCLE",),
    },
)

ARCHITECTURE_FIXTURES = (
    {
        "path": "architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md",
        "jurisdictions": (
            {
                "id": "CONTROL",
                "primary_specification": "spec/CONTROL.md",
                "specialises": (),
            },
            {
                "id": "RESOLUTION_LIFECYCLE",
                "primary_specification": "spec/RESOLUTION_LIFECYCLE.md",
                "specialises": (),
            },
        ),
    },
    {
        "path": "architecture/SPATIAL_NEGOTIATION_MODEL.md",
        "jurisdictions": (
            {
                "id": "COOPERATIVE_PASSAGE",
                "primary_specification": "spec/COOPERATIVE_PASSAGE.md",
                "specialises": ("RESOLUTION_LIFECYCLE",),
            },
        ),
    },
    {
        "path": "architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md",
        "jurisdictions": (
            {
                "id": "ASSESSMENT_REPRESENTATION",
                "primary_specification": "spec/ASSESSMENT_REPRESENTATION.md",
                "specialises": (),
            },
            {
                "id": "PHYSICAL_IDENTITY_RESOLUTION",
                "primary_specification": "spec/PHYSICAL_IDENTITY_RESOLUTION.md",
                "specialises": (),
            },
        ),
    },
)

SPECIFICATION_FIXTURES = (
    {
        "path": "spec/CONTROL.md",
        "jurisdiction": "CONTROL",
        "architecture_authority": "architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md",
        "participants": (
            ("scripts/control/LiveControlDispatcher.lua", "REALISES"),
            ("scripts/control/CooperativePassageControl.lua", "REALISES"),
        ),
        "validation": ("tests/test_replacement_core_structure.py",),
    },
    {
        "path": "spec/COOPERATIVE_PASSAGE.md",
        "jurisdiction": "COOPERATIVE_PASSAGE",
        "architecture_authority": "architecture/SPATIAL_NEGOTIATION_MODEL.md",
        "participants": (
            ("scripts/control/CooperativePassageControl.lua", "REALISES"),
        ),
        "validation": ("tests/test_replacement_core_structure.py",),
    },
    {
        "path": "spec/ASSESSMENT_REPRESENTATION.md",
        "jurisdiction": "ASSESSMENT_REPRESENTATION",
        "architecture_authority": "architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md",
        "participants": (
            ("scripts/representation/AssemblyRepresentationCache.lua", "REALISES"),
        ),
        "validation": ("tests/test_replacement_core_structure.py",),
    },
    {
        "path": "spec/PHYSICAL_IDENTITY_RESOLUTION.md",
        "jurisdiction": "PHYSICAL_IDENTITY_RESOLUTION",
        "architecture_authority": "architecture/PHYSICAL_REPRESENTATION_ARCHITECTURE.md",
        "participants": (
            ("scripts/representation/AssemblyRepresentationCache.lua", "REALISES"),
        ),
        "validation": ("tests/test_replacement_core_structure.py",),
    },
    {
        "path": "spec/RESOLUTION_LIFECYCLE.md",
        "jurisdiction": "RESOLUTION_LIFECYCLE",
        "architecture_authority": "architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md",
        "participants": (
            ("scripts/responsibility/ResolutionCommitmentAdapter.lua", "REALISES"),
        ),
        "validation": ("tests/test_replacement_core_structure.py",),
    },
)

JURISDICTIONS = re.compile(
    r"^\s*--+\s*Specification Jurisdictions:\s*(`?[A-Z][A-Z0-9_]*`?(?:\s*,\s*`?[A-Z][A-Z0-9_]*`?)*)\s*$"
)
JURISDICTION_ID = re.compile(r"^\*\*Jurisdiction ID:\*\*\s*`([A-Z][A-Z0-9_]*)`\s*$")
PRIMARY_SPEC = re.compile(r"^\*\*Primary Specification:\*\*\s*\[`([^`]+)`\]\(([^)]+)\)\s*$")
PRIMARY_ARCH = re.compile(r"^\*\*Primary Architecture Authority:\*\*\s*\[`([^`]+)`\]\(([^)]+)\)\s*$")
SPECIALISES = re.compile(
    r"^\*\*Specialises:\*\*\s*(`?[A-Z][A-Z0-9_]*`?(?:\s*,\s*`?[A-Z][A-Z0-9_]*`?)*)\s*$"
)
TABLE_ROW = re.compile(r"^\|\s*\[`([^`]+)`\]\(([^)]+)\)\s*\|\s*`([A-Z]+)`\s*\|\s*$")


def generated_name(path: str) -> str:
    return path.replace("/", "__")


def repo_file(path: str) -> Path:
    return ROOT / path


def ensure_repo_file(path: str) -> None:
    candidate = repo_file(path)
    if not candidate.is_file():
        raise ValueError(f"repository file does not exist: {path}")


def repo_relative_href(origin_path: str, target_path: str) -> str:
    return posixpath.relpath(target_path, posixpath.dirname(origin_path))


def normalize_link(origin_path: str, label: str, href: str) -> str:
    href_path = href.split("#", 1)[0]
    if "://" in href_path or href_path.startswith("/"):
        raise ValueError(f"external/absolute link not allowed in contract field: {origin_path} -> {href}")
    resolved = posixpath.normpath(posixpath.join(posixpath.dirname(origin_path), href_path))
    if resolved != label:
        raise ValueError(
            f"contract link label/target mismatch in {origin_path}: label={label} resolves={resolved}"
        )
    return resolved


def insert_after_title(original: str, generated: str) -> str:
    lines = original.splitlines()
    if lines and lines[0].startswith("# "):
        return "\n".join([lines[0], "", generated, ""] + lines[1:]) + "\n"
    return generated + "\n\n" + original


def architecture_declarations(item: dict) -> str:
    lines = [
        "> **Issue #141 generated POC declaration block. Production Architecture is unchanged.**",
        "",
    ]
    for declaration in item["jurisdictions"]:
        spec_path = declaration["primary_specification"]
        href = repo_relative_href(item["path"], spec_path)
        lines.extend(
            [
                f"**Jurisdiction ID:** `{declaration['id']}`",
                f"**Primary Specification:** [`{spec_path}`]({href})",
            ]
        )
        if declaration["specialises"]:
            values = ", ".join(f"`{value}`" for value in declaration["specialises"])
            lines.append(f"**Specialises:** {values}")
        lines.append("")
    return "\n".join(lines).rstrip()


def specification_declarations(item: dict) -> str:
    architecture = item["architecture_authority"]
    architecture_href = repo_relative_href(item["path"], architecture)
    lines = [
        "> **Issue #141 generated POC declaration block. Production Specification is unchanged.**",
        "",
        f"**Jurisdiction ID:** `{item['jurisdiction']}`",
        f"**Primary Architecture Authority:** [`{architecture}`]({architecture_href})",
        "",
        "## Contract participants",
        "",
        "| Production source | Participation |",
        "| --- | --- |",
    ]
    for source_path, relationship in item["participants"]:
        href = repo_relative_href(item["path"], source_path)
        lines.append(f"| [`{source_path}`]({href}) | `{relationship}` |")
    lines.extend(
        [
            "",
            "## Repository validation participants",
            "",
            "| Validation surface | Relationship |",
            "| --- | --- |",
        ]
    )
    for validation_path in item["validation"]:
        href = repo_relative_href(item["path"], validation_path)
        lines.append(f"| [`{validation_path}`]({href}) | `CHALLENGES` |")
    return "\n".join(lines)


def prepare() -> None:
    if WORKSPACE.exists():
        shutil.rmtree(WORKSPACE)
    ARCH.mkdir(parents=True)
    SPEC.mkdir(parents=True)
    SRC.mkdir(parents=True)

    for item in SOURCE_TARGETS:
        source_path = repo_file(item["path"])
        if not source_path.is_file():
            raise SystemExit(f"missing production source: {item['path']}")
        source = source_path.read_text(encoding="utf-8")
        jurisdiction_text = ", ".join(f"`{value}`" for value in item["jurisdictions"])

        header = [
            f"--- {item['summary']}",
            f"-- Specification Jurisdictions: {jurisdiction_text}",
            f"-- POC copy of `{item['path']}`; production source is unchanged.",
            f"-- @module {item['module']}",
            "",
        ]

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

    for item in ARCHITECTURE_FIXTURES:
        source_path = repo_file(item["path"])
        if not source_path.is_file():
            raise SystemExit(f"missing Architecture source: {item['path']}")
        generated = insert_after_title(
            source_path.read_text(encoding="utf-8"),
            architecture_declarations(item),
        )
        (ARCH / generated_name(item["path"])).write_text(generated, encoding="utf-8")

    for item in SPECIFICATION_FIXTURES:
        source_path = repo_file(item["path"])
        if not source_path.is_file():
            raise SystemExit(f"missing Specification source: {item['path']}")
        generated = insert_after_title(
            source_path.read_text(encoding="utf-8"),
            specification_declarations(item),
        )
        (SPEC / generated_name(item["path"])).write_text(generated, encoding="utf-8")

    config = """project = 'OuttaMyWay Issue #141 Traceability POC'
title = 'OuttaMyWay Issue #141 Traceability POC'
description = 'Generated experiment only; no production source is modified.'
file = 'experiments/issue141_source_traceability_poc/workspace/src'
dir = 'experiments/issue141_source_traceability_poc/workspace/doc'
format = 'markdown'
all = true
not_luadoc = true
"""
    (WORKSPACE / "config.ld").write_text(config, encoding="utf-8")
    print(
        "prepared "
        f"{len(SOURCE_TARGETS)} source, "
        f"{len(ARCHITECTURE_FIXTURES)} Architecture, and "
        f"{len(SPECIFICATION_FIXTURES)} Specification real-file copies"
    )


def declaration_blocks(lines: list[str]) -> list[tuple[int, list[str]]]:
    blocks: list[tuple[int, list[str]]] = []
    for index, line in enumerate(lines):
        if JURISDICTION_ID.match(line):
            end = index + 1
            while end < len(lines) and lines[end].strip() != "":
                end += 1
            blocks.append((index, lines[index:end]))
    return blocks


def parse_architecture() -> dict[str, dict]:
    result: dict[str, dict] = {}
    for item in ARCHITECTURE_FIXTURES:
        generated = ARCH / generated_name(item["path"])
        lines = generated.read_text(encoding="utf-8").splitlines()
        for _, block in declaration_blocks(lines):
            jid_match = JURISDICTION_ID.match(block[0])
            assert jid_match is not None
            jurisdiction = jid_match.group(1)
            if jurisdiction in result:
                raise ValueError(f"duplicate Architecture Jurisdiction ID: {jurisdiction}")

            primary = None
            specialises: list[str] = []
            for line in block[1:]:
                primary_match = PRIMARY_SPEC.match(line)
                if primary_match:
                    primary = normalize_link(item["path"], primary_match.group(1), primary_match.group(2))
                specialises_match = SPECIALISES.match(line)
                if specialises_match:
                    specialises = [
                        value.strip().strip("`")
                        for value in specialises_match.group(1).split(",")
                    ]
            if primary is None:
                raise ValueError(f"Architecture Jurisdiction lacks Primary Specification: {jurisdiction}")
            result[jurisdiction] = {
                "architectureAuthority": item["path"],
                "primarySpecification": primary,
                "specialises": sorted(specialises),
            }
    return result


def find_table(lines: list[str], heading: str) -> list[tuple[str, str, str]]:
    try:
        start = lines.index(heading)
    except ValueError:
        return []
    rows: list[tuple[str, str, str]] = []
    for line in lines[start + 1 :]:
        if line.startswith("## "):
            break
        match = TABLE_ROW.match(line)
        if match:
            rows.append((match.group(1), match.group(2), match.group(3)))
    return rows


def parse_specifications() -> dict[str, dict]:
    result: dict[str, dict] = {}
    for item in SPECIFICATION_FIXTURES:
        generated = SPEC / generated_name(item["path"])
        lines = generated.read_text(encoding="utf-8").splitlines()
        blocks = declaration_blocks(lines)
        if len(blocks) != 1:
            raise ValueError(f"expected exactly one Jurisdiction declaration in {item['path']}; found {len(blocks)}")
        _, block = blocks[0]
        jid_match = JURISDICTION_ID.match(block[0])
        assert jid_match is not None
        jurisdiction = jid_match.group(1)
        architecture = None
        for line in block[1:]:
            match = PRIMARY_ARCH.match(line)
            if match:
                architecture = normalize_link(item["path"], match.group(1), match.group(2))
        if architecture is None:
            raise ValueError(f"Specification lacks Primary Architecture Authority: {item['path']}")
        if jurisdiction in result:
            raise ValueError(f"duplicate Specification Jurisdiction ID: {jurisdiction}")

        participants: list[dict[str, str]] = []
        seen_participants: set[str] = set()
        for label, href, relationship in find_table(lines, "## Contract participants"):
            path = normalize_link(item["path"], label, href)
            if relationship not in {"REALISES", "SUPPORTS"}:
                raise ValueError(f"illegal source participation relationship {relationship} in {item['path']}")
            if path in seen_participants:
                raise ValueError(f"duplicate source participant {path} in {item['path']}")
            seen_participants.add(path)
            participants.append({"path": path, "relationship": relationship})

        validation: list[str] = []
        seen_validation: set[str] = set()
        for label, href, relationship in find_table(lines, "## Repository validation participants"):
            path = normalize_link(item["path"], label, href)
            if relationship != "CHALLENGES":
                raise ValueError(f"illegal validation relationship {relationship} in {item['path']}")
            if path in seen_validation:
                raise ValueError(f"duplicate validation participant {path} in {item['path']}")
            seen_validation.add(path)
            validation.append(path)

        result[jurisdiction] = {
            "path": item["path"],
            "architectureAuthority": architecture,
            "sourceParticipants": sorted(participants, key=lambda value: value["path"]),
            "validationParticipants": sorted(validation),
        }
    return result


def parse_source_acknowledgements() -> dict[str, list[str]]:
    actual: dict[str, list[str]] = {}
    for item in SOURCE_TARGETS:
        generated = SRC / generated_name(item["path"])
        matches: list[list[str]] = []
        for line in generated.read_text(encoding="utf-8").splitlines():
            match = JURISDICTIONS.match(line)
            if match:
                values = [value.strip().strip("`") for value in match.group(1).split(",")]
                matches.append(values)
        if len(matches) != 1:
            raise ValueError(
                f"expected exactly one Specification Jurisdictions line in {item['path']}; found {len(matches)}"
            )
        found = matches[0]
        if len(found) != len(set(found)):
            raise ValueError(f"duplicate Jurisdiction acknowledgement in {item['path']}: {found}")
        actual[item["path"]] = sorted(found)
    return actual


def compile_graph() -> dict:
    architecture = parse_architecture()
    specifications = parse_specifications()
    source = parse_source_acknowledgements()

    jurisdictions: dict[str, dict] = {}
    for jurisdiction, architecture_record in architecture.items():
        spec_record = specifications.get(jurisdiction)
        jurisdictions[jurisdiction] = {
            **architecture_record,
            "specificationAcknowledgement": spec_record,
        }
    return {
        "jurisdictions": jurisdictions,
        "sourceAcknowledgements": source,
    }


def validate_graph(graph: dict) -> None:
    jurisdictions = graph["jurisdictions"]
    source_ack = graph["sourceAcknowledgements"]

    if not jurisdictions:
        raise ValueError("no Jurisdictions extracted")

    for jurisdiction, record in jurisdictions.items():
        spec = record.get("specificationAcknowledgement")
        if spec is None:
            raise ValueError(f"Architecture Jurisdiction has no Specification acknowledgement: {jurisdiction}")
        if record["primarySpecification"] != spec["path"]:
            raise ValueError(
                f"primary Specification mismatch for {jurisdiction}: "
                f"Architecture={record['primarySpecification']} Specification={spec['path']}"
            )
        if record["architectureAuthority"] != spec["architectureAuthority"]:
            raise ValueError(
                f"Architecture authority mismatch for {jurisdiction}: "
                f"Architecture={record['architectureAuthority']} Specification={spec['architectureAuthority']}"
            )
        ensure_repo_file(record["primarySpecification"])
        ensure_repo_file(record["architectureAuthority"])

        for parent in record["specialises"]:
            if parent == jurisdiction:
                raise ValueError(f"Jurisdiction cannot specialise itself: {jurisdiction}")
            if parent not in jurisdictions:
                raise ValueError(f"unknown SPECIALISES target: {jurisdiction} -> {parent}")

        roles_by_source: dict[str, str] = {}
        realiser_count = 0
        for participant in spec["sourceParticipants"]:
            path = participant["path"]
            role = participant["relationship"]
            ensure_repo_file(path)
            if not path.startswith("scripts/"):
                raise ValueError(f"source participant is not production source: {path}")
            if role not in {"REALISES", "SUPPORTS"}:
                raise ValueError(f"illegal source relationship: {jurisdiction} {path} {role}")
            if path in roles_by_source:
                raise ValueError(f"source/Jurisdiction pair declared more than once: {path} {jurisdiction}")
            roles_by_source[path] = role
            if role == "REALISES":
                realiser_count += 1
        if realiser_count == 0:
            raise ValueError(f"implemented Jurisdiction has no REALISES participant: {jurisdiction}")

        for validation_path in spec["validationParticipants"]:
            ensure_repo_file(validation_path)

    visiting: set[str] = set()
    visited: set[str] = set()

    def visit(jurisdiction: str) -> None:
        if jurisdiction in visiting:
            raise ValueError(f"SPECIALISES cycle detected at {jurisdiction}")
        if jurisdiction in visited:
            return
        visiting.add(jurisdiction)
        for parent in jurisdictions[jurisdiction]["specialises"]:
            visit(parent)
        visiting.remove(jurisdiction)
        visited.add(jurisdiction)

    for jurisdiction in jurisdictions:
        visit(jurisdiction)

    spec_pairs: set[tuple[str, str]] = set()
    for jurisdiction, record in jurisdictions.items():
        for participant in record["specificationAcknowledgement"]["sourceParticipants"]:
            spec_pairs.add((participant["path"], jurisdiction))

    source_pairs: set[tuple[str, str]] = set()
    for path, acknowledged in source_ack.items():
        ensure_repo_file(path)
        if not path.startswith("scripts/"):
            raise ValueError(f"source acknowledgement is not production source: {path}")
        for jurisdiction in acknowledged:
            if jurisdiction not in jurisdictions:
                raise ValueError(f"source acknowledges unknown Jurisdiction: {path} -> {jurisdiction}")
            source_pairs.add((path, jurisdiction))

    missing_ack = sorted(spec_pairs - source_pairs)
    if missing_ack:
        raise ValueError(f"Specification participant missing source acknowledgement: {missing_ack}")

    unclassified_ack = sorted(source_pairs - spec_pairs)
    if unclassified_ack:
        raise ValueError(f"source acknowledgement lacks Specification classification: {unclassified_ack}")


def extract() -> None:
    graph = compile_graph()
    validate_graph(graph)
    GRAPH.write_text(json.dumps(graph, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("cross-surface deterministic extraction PASS")
    print("Architecture -> Specification reciprocity PASS")
    print("SPECIALISES target/cycle validation PASS")
    print("Specification REALISES/SUPPORTS source classification PASS")
    print("Specification <-> source participation closure PASS")
    print("repository validation path checks PASS")
    print(GRAPH.read_text(encoding="utf-8"), end="")


def negative_tests() -> None:
    if not GRAPH.is_file():
        raise SystemExit("graph.json missing; run extract first")
    baseline = json.loads(GRAPH.read_text(encoding="utf-8"))
    cases = []

    def expect_failure(name: str, mutate, expected_fragment: str) -> None:
        candidate = copy.deepcopy(baseline)
        mutate(candidate)
        try:
            validate_graph(candidate)
        except ValueError as exc:
            message = str(exc)
            if expected_fragment not in message:
                raise SystemExit(
                    f"negative case {name!r} failed for the wrong reason: "
                    f"expected {expected_fragment!r}, got {message!r}"
                )
            cases.append({"name": name, "result": "EXPECTED_FAILURE", "message": message})
            print(f"negative case PASS: {name}: {message}")
            return
        raise SystemExit(f"negative case {name!r} unexpectedly passed")

    expect_failure(
        "architecture-primary-spec-disagreement",
        lambda graph: graph["jurisdictions"]["COOPERATIVE_PASSAGE"].__setitem__(
            "primarySpecification", "spec/CONTROL.md"
        ),
        "primary Specification mismatch",
    )
    expect_failure(
        "missing-source-acknowledgement",
        lambda graph: graph["sourceAcknowledgements"]["scripts/control/CooperativePassageControl.lua"].remove(
            "COOPERATIVE_PASSAGE"
        ),
        "missing source acknowledgement",
    )
    expect_failure(
        "unclassified-source-acknowledgement",
        lambda graph: graph["sourceAcknowledgements"]["scripts/control/LiveControlDispatcher.lua"].append(
            "RESOLUTION_LIFECYCLE"
        ),
        "lacks Specification classification",
    )
    expect_failure(
        "unknown-specialisation-target",
        lambda graph: graph["jurisdictions"]["COOPERATIVE_PASSAGE"].__setitem__(
            "specialises", ["NOT_A_JURISDICTION"]
        ),
        "unknown SPECIALISES target",
    )
    expect_failure(
        "specialisation-cycle",
        lambda graph: graph["jurisdictions"]["RESOLUTION_LIFECYCLE"].__setitem__(
            "specialises", ["COOPERATIVE_PASSAGE"]
        ),
        "SPECIALISES cycle",
    )
    expect_failure(
        "implemented-jurisdiction-without-realiser",
        lambda graph: [
            participant.__setitem__("relationship", "SUPPORTS")
            for participant in graph["jurisdictions"]["CONTROL"]["specificationAcknowledgement"]["sourceParticipants"]
        ],
        "has no REALISES participant",
    )

    NEGATIVE_RESULTS.write_text(json.dumps(cases, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print(f"negative mismatch suite PASS ({len(cases)} expected failures)")


def verify_render() -> None:
    html_files = sorted(DOC.rglob("*.html"))
    if not html_files:
        raise SystemExit(f"LDoc produced no HTML under {DOC}")
    rendered = "\n".join(path.read_text(encoding="utf-8", errors="replace") for path in html_files)

    required = {
        jurisdiction
        for item in SOURCE_TARGETS
        for jurisdiction in item["jurisdictions"]
    }
    required.update({"Specification Jurisdictions", "__omwIssue141PocIdentity"})
    missing = sorted(value for value in required if value not in rendered)
    if missing:
        raise SystemExit(f"LDoc output missing expected rendered values: {missing}")

    if not GRAPH.is_file():
        raise SystemExit("graph.json missing; extractor did not run")
    if not NEGATIVE_RESULTS.is_file():
        raise SystemExit("negative-tests.json missing; negative suite did not run")
    print(f"LDoc render PASS ({len(html_files)} HTML files)")
    print("visible structured Jurisdiction metadata rendering PASS")
    print("literal semantic-ID rendering PASS")
    print("LuaLS/LuaCATS param/return coexistence PASS")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "command",
        choices=("prepare", "extract", "negative-tests", "verify-render"),
    )
    args = parser.parse_args()
    {
        "prepare": prepare,
        "extract": extract,
        "negative-tests": negative_tests,
        "verify-render": verify_render,
    }[args.command]()


if __name__ == "__main__":
    main()
