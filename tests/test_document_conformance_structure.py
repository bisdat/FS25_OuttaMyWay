from __future__ import annotations

import posixpath
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARCH_DIR = ROOT / "architecture"
SPEC_DIR = ROOT / "spec"
SCRIPTS_DIR = ROOT / "scripts"

ID_RE = re.compile(r"^\*\*Jurisdiction ID:\*\*\s*`([A-Z][A-Z0-9_]*)`\s*$")
PRIMARY_SPEC_RE = re.compile(r"^\*\*Primary Specification:\*\*\s*\[[^\]]+\]\(([^)]+)\)\s*$")
SPECIALISES_RE = re.compile(r"^\*\*Specialises:\*\*\s*`([A-Z][A-Z0-9_]*)`\s*$")
PRIMARY_ARCH_RE = re.compile(r"^\*\*Primary Architecture Authority:\*\*\s*\[[^\]]+\]\(([^)]+)\)\s*$")
ACK_RE = re.compile(r"^-- Specification Jurisdictions:\s*(.+?)\s*$")
BACKTICK_ID_RE = re.compile(r"`([A-Z][A-Z0-9_]*)`")
PARTICIPANT_ROW_RE = re.compile(
    r"^\|\s*\[`([^`]+)`\]\(([^)]+)\)\s*\|\s*`(REALISES|SUPPORTS)`\s*\|\s*$"
)
VALIDATION_ROW_RE = re.compile(
    r"^\|\s*\[`([^`]+)`\]\(([^)]+)\)\s*\|\s*`(CHALLENGES)`\s*\|\s*$"
)


def _repo_path(owner_file: Path, target: str) -> str:
    target = target.split("#", 1)[0]
    owner_rel = owner_file.relative_to(ROOT).as_posix()
    return posixpath.normpath(posixpath.join(posixpath.dirname(owner_rel), target))


def _section(lines: list[str], heading: str, errors: list[str]) -> list[str] | None:
    hits = [index for index, line in enumerate(lines) if line.strip() == heading]
    if not hits:
        return None
    if len(hits) != 1:
        errors.append(f"duplicate section {heading!r}")
        return []
    start = hits[0] + 1
    end = len(lines)
    for index in range(start, len(lines)):
        if lines[index].startswith("## "):
            end = index
            break
    return lines[start:end]


def _derive_declared_graph() -> list[str]:
    errors: list[str] = []

    architecture: dict[str, dict[str, str | None]] = {}
    for path in sorted(ARCH_DIR.glob("*.md")):
        lines = path.read_text(encoding="utf-8").splitlines()
        positions = [(index, match.group(1)) for index, line in enumerate(lines) if (match := ID_RE.match(line.strip()))]
        for position_index, (start, jurisdiction_id) in enumerate(positions):
            end = positions[position_index + 1][0] if position_index + 1 < len(positions) else len(lines)
            block = lines[start:end]
            primary = [match.group(1) for line in block if (match := PRIMARY_SPEC_RE.match(line.strip()))]
            specialisation = [match.group(1) for line in block if (match := SPECIALISES_RE.match(line.strip()))]
            if jurisdiction_id in architecture:
                errors.append(f"duplicate Architecture Jurisdiction ID {jurisdiction_id}")
                continue
            if len(primary) != 1:
                errors.append(f"Architecture {jurisdiction_id} has {len(primary)} Primary Specification declarations")
                primary_path = None
            else:
                primary_path = _repo_path(path, primary[0])
            if len(specialisation) > 1:
                errors.append(f"Architecture {jurisdiction_id} has multiple Specialises declarations")
            architecture[jurisdiction_id] = {
                "file": path.relative_to(ROOT).as_posix(),
                "primary_spec": primary_path,
                "specialises": specialisation[0] if specialisation else None,
            }

    specifications: dict[str, dict] = {}
    spec_path_to_id: dict[str, str] = {}
    participant_edges: dict[tuple[str, str], str] = {}

    for path in sorted(SPEC_DIR.glob("*.md")):
        lines = path.read_text(encoding="utf-8").splitlines()
        ids = [match.group(1) for line in lines if (match := ID_RE.match(line.strip()))]
        if not ids:
            continue
        if len(ids) != 1:
            errors.append(f"Spec {path.relative_to(ROOT)} has {len(ids)} Jurisdiction ID declarations")
            continue
        jurisdiction_id = ids[0]
        if jurisdiction_id in specifications:
            errors.append(f"duplicate Specification Jurisdiction ID {jurisdiction_id}")
            continue

        architecture_links = [match.group(1) for line in lines if (match := PRIMARY_ARCH_RE.match(line.strip()))]
        if len(architecture_links) != 1:
            errors.append(f"Spec {jurisdiction_id} has {len(architecture_links)} Primary Architecture Authority declarations")
            architecture_path = None
        else:
            architecture_path = _repo_path(path, architecture_links[0])

        participants = _section(lines, "## Contract participants", errors)
        if participants is None:
            errors.append(f"Spec {jurisdiction_id} lacks ## Contract participants")
        else:
            for line in participants:
                stripped = line.strip()
                if not stripped.startswith("|"):
                    continue
                match = PARTICIPANT_ROW_RE.match(stripped)
                if match:
                    label, link, relation = match.groups()
                    source_path = _repo_path(path, link)
                    if label != source_path:
                        errors.append(f"Spec {jurisdiction_id} participant label/path disagree: {label} != {source_path}")
                    if not source_path.startswith("scripts/") or not source_path.endswith(".lua"):
                        errors.append(f"Spec {jurisdiction_id} participant is not an exact production Lua source: {source_path}")
                    if not (ROOT / source_path).is_file():
                        errors.append(f"Spec {jurisdiction_id} participant path does not resolve: {source_path}")
                    key = (source_path, jurisdiction_id)
                    if key in participant_edges:
                        errors.append(f"duplicate participant classification for {source_path} / {jurisdiction_id}")
                    else:
                        participant_edges[key] = relation
                elif "Production source" in stripped or re.fullmatch(r"\|[\s\-:|]+\|", stripped):
                    pass
                else:
                    errors.append(f"Spec {jurisdiction_id} has unparseable Contract participants row: {stripped}")

        validation = _section(lines, "## Repository validation participants", errors)
        if validation is not None:
            for line in validation:
                stripped = line.strip()
                if not stripped.startswith("|"):
                    continue
                match = VALIDATION_ROW_RE.match(stripped)
                if match:
                    label, link, _ = match.groups()
                    validation_path = _repo_path(path, link)
                    if label != validation_path:
                        errors.append(f"Spec {jurisdiction_id} validation label/path disagree: {label} != {validation_path}")
                    if not (ROOT / validation_path).is_file():
                        errors.append(f"Spec {jurisdiction_id} validation path does not resolve: {validation_path}")
                elif "Validation surface" in stripped or re.fullmatch(r"\|[\s\-:|]+\|", stripped):
                    pass
                else:
                    errors.append(f"Spec {jurisdiction_id} has unparseable Repository validation participants row: {stripped}")

        spec_path = path.relative_to(ROOT).as_posix()
        specifications[jurisdiction_id] = {"file": spec_path, "architecture": architecture_path}
        spec_path_to_id[spec_path] = jurisdiction_id

    if set(architecture) != set(specifications):
        errors.append(
            "Architecture/Specification Jurisdiction ID sets differ: "
            f"architecture_only={sorted(set(architecture) - set(specifications))} "
            f"spec_only={sorted(set(specifications) - set(architecture))}"
        )

    for jurisdiction_id, declaration in architecture.items():
        primary_spec = declaration["primary_spec"]
        if primary_spec is None:
            continue
        if not (ROOT / primary_spec).is_file():
            errors.append(f"Architecture {jurisdiction_id} Primary Specification does not resolve: {primary_spec}")
        if spec_path_to_id.get(primary_spec) != jurisdiction_id:
            errors.append(
                f"Architecture {jurisdiction_id} routes to {primary_spec}, whose declared Jurisdiction is "
                f"{spec_path_to_id.get(primary_spec)!r}"
            )
        specification = specifications.get(jurisdiction_id)
        if specification and specification["architecture"] != declaration["file"]:
            errors.append(
                f"Architecture/Spec authority mismatch for {jurisdiction_id}: "
                f"Architecture={declaration['file']} Spec={specification['architecture']}"
            )

    specialisations: dict[str, str] = {}
    for jurisdiction_id, declaration in architecture.items():
        target = declaration["specialises"]
        if target is None:
            continue
        if target not in architecture:
            errors.append(f"{jurisdiction_id} SPECIALISES unknown Jurisdiction {target}")
            continue
        if target == jurisdiction_id:
            errors.append(f"{jurisdiction_id} SPECIALISES itself")
            continue
        specialisations[jurisdiction_id] = target

    for start in specialisations:
        seen: set[str] = set()
        current = start
        while current in specialisations:
            if current in seen:
                errors.append(f"SPECIALISES cycle detected from {start}")
                break
            seen.add(current)
            current = specialisations[current]

    by_jurisdiction: dict[str, list[str]] = defaultdict(list)
    for (_, jurisdiction_id), relation in participant_edges.items():
        by_jurisdiction[jurisdiction_id].append(relation)
    for jurisdiction_id in specifications:
        if "REALISES" not in by_jurisdiction[jurisdiction_id]:
            errors.append(f"Spec {jurisdiction_id} has no REALISES participant")

    source_acknowledgements: dict[str, tuple[str, ...]] = {}
    for path in sorted(SCRIPTS_DIR.rglob("*.lua")):
        lines = path.read_text(encoding="utf-8").splitlines()
        acknowledgements = [(match.group(1), line) for line in lines if (match := ACK_RE.match(line.strip()))]
        if len(acknowledgements) > 1:
            errors.append(f"Source {path.relative_to(ROOT)} has multiple Specification Jurisdictions acknowledgement lines")
        if not acknowledgements:
            continue
        body, original = acknowledgements[0]
        ids = BACKTICK_ID_RE.findall(body)
        if not ids:
            errors.append(f"Source {path.relative_to(ROOT)} has empty/malformed acknowledgement: {original.strip()}")
            continue
        canonical = ", ".join(f"`{jurisdiction_id}`" for jurisdiction_id in ids)
        if body != canonical:
            errors.append(f"Source {path.relative_to(ROOT)} acknowledgement is not exact contracted syntax")
        if len(ids) != len(set(ids)):
            errors.append(f"Source {path.relative_to(ROOT)} acknowledgement repeats a Jurisdiction ID")
        source_path = path.relative_to(ROOT).as_posix()
        source_acknowledgements[source_path] = tuple(ids)
        for jurisdiction_id in ids:
            if jurisdiction_id not in specifications:
                errors.append(f"Source {source_path} acknowledges unknown Jurisdiction {jurisdiction_id}")

    for (source_path, jurisdiction_id), relation in participant_edges.items():
        if source_path not in source_acknowledgements:
            errors.append(f"Spec {jurisdiction_id} classifies {source_path} as {relation}, but source has no acknowledgement")
        elif jurisdiction_id not in source_acknowledgements[source_path]:
            errors.append(f"Spec {jurisdiction_id} classifies {source_path} as {relation}, but source acknowledgement lacks {jurisdiction_id}")

    for source_path, ids in source_acknowledgements.items():
        for jurisdiction_id in ids:
            if (source_path, jurisdiction_id) not in participant_edges:
                errors.append(
                    f"Source {source_path} acknowledges {jurisdiction_id}, but primary Spec supplies no REALISES/SUPPORTS classification"
                )

    expected_by_source: dict[str, set[str]] = defaultdict(set)
    for source_path, jurisdiction_id in participant_edges:
        expected_by_source[source_path].add(jurisdiction_id)
    for source_path in sorted(set(expected_by_source) | set(source_acknowledgements)):
        expected = expected_by_source.get(source_path, set())
        actual = set(source_acknowledgements.get(source_path, ()))
        if expected != actual:
            errors.append(
                f"Source {source_path} acknowledgement set mismatch: expected={sorted(expected)} actual={sorted(actual)}"
            )

    return errors


def test_declared_cross_surface_conformance_graph_closes():
    errors = _derive_declared_graph()
    assert not errors, "Declared cross-surface conformance graph is open:\n- " + "\n- ".join(errors)
