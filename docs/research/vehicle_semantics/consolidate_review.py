#!/usr/bin/env python3
"""Rebuild the reviewed FS25 base-game semantic catalogue.

This tool consumes the repository-bundled Stage 2C suggestion assignments and
human review-unit decisions. It does not read or modify game assets.
"""

from __future__ import annotations

import argparse
import csv
import hashlib
import json
from collections import Counter
from pathlib import Path


CATALOGUE_VERSION = "1.0"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(
            handle,
            fieldnames=fieldnames,
            extrasaction="ignore",
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, value: object) -> None:
    path.write_text(
        json.dumps(value, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def split_pipe(value: str) -> list[str]:
    return [item.strip() for item in (value or "").split("|") if item.strip()]


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--assignments",
        type=Path,
        default=Path(__file__).with_name("stage2c_semantic_assignments.csv"),
    )
    parser.add_argument(
        "--decisions",
        type=Path,
        default=Path(__file__).with_name("review_unit_decisions.csv"),
    )
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()

    assignments = read_csv(args.assignments)
    decisions = read_csv(args.decisions)

    if len(assignments) != 606:
        raise ValueError(f"Expected 606 assignments; found {len(assignments)}")
    if len(decisions) != 170:
        raise ValueError(f"Expected 170 review-unit decisions; found {len(decisions)}")

    decision_by_unit: dict[str, dict[str, str]] = {}
    for decision in decisions:
        unit_id = decision["review_unit_id"]
        if unit_id in decision_by_unit:
            raise ValueError(f"Duplicate review unit: {unit_id}")
        if decision["final_review_state"] != "RESOLVED":
            raise ValueError(f"Unresolved review unit: {unit_id}")
        if not decision["final_primary_family"] or not decision["final_primary_role"]:
            raise ValueError(f"Incomplete final semantic profile: {unit_id}")
        decision_by_unit[unit_id] = decision

    result: list[dict[str, str]] = []
    for assignment in assignments:
        unit_id = assignment["review_unit_id"]
        decision = decision_by_unit.get(unit_id)
        if decision is None:
            raise ValueError(f"Assignment has no review decision: {unit_id}")

        result.append(
            {
                **assignment,
                "reviewer_decision_status": decision["reviewer_decision_status"],
                "reviewed_primary_family": decision["final_primary_family"],
                "reviewed_primary_role": decision["final_primary_role"],
                "reviewed_secondary_roles": decision["final_secondary_roles"],
                "reviewed_capabilities": decision["final_capabilities"],
                "reviewer_notes": decision["reviewer_notes"],
                "consolidation_resolution": decision["consolidation_resolution"],
                "semantic_profile_state": "HUMAN_REVIEWED",
                "semantic_catalogue_version": CATALOGUE_VERSION,
            }
        )

    result.sort(key=lambda row: row["definition_xml"])

    if len({row["definition_xml"] for row in result}) != 606:
        raise ValueError("Definition identity is not unique")
    if any(
        not row["reviewed_primary_family"] or not row["reviewed_primary_role"]
        for row in result
    ):
        raise ValueError("One or more definitions lack a final semantic profile")

    args.output.mkdir(parents=True, exist_ok=True)
    catalogue_path = args.output / "reviewed_semantic_catalogue.csv"
    fieldnames = list(result[0].keys())
    write_csv(catalogue_path, result, fieldnames)

    family_counts = Counter(row["reviewed_primary_family"] for row in result)
    role_counts = Counter(row["reviewed_primary_role"] for row in result)
    capability_counts: Counter[str] = Counter()
    for row in result:
        capability_counts.update(split_pipe(row["reviewed_capabilities"]))

    review_status_counts = Counter(row["reviewer_decision_status"] for row in decisions)
    review_resolution_counts = Counter(row["consolidation_resolution"] for row in decisions)
    asset_resolution_counts = Counter(row["consolidation_resolution"] for row in result)

    summary = {
        "schema_version": 1,
        "semantic_catalogue_version": CATALOGUE_VERSION,
        "definition_count": len(result),
        "review_unit_count": len(decisions),
        "review_unit_status_counts": dict(sorted(review_status_counts.items())),
        "review_unit_resolution_counts": dict(sorted(review_resolution_counts.items())),
        "asset_resolution_counts": dict(sorted(asset_resolution_counts.items())),
        "family_count": len(family_counts),
        "primary_role_count": len(role_counts),
        "capability_count": len(capability_counts),
        "family_distribution": dict(sorted(family_counts.items())),
        "review_complete": True,
        "unresolved_review_units": 0,
        "unresolved_definitions": 0,
        "scope_assigned": False,
        "catalogue_sha256": sha256_file(catalogue_path),
    }
    write_json(args.output / "semantic_catalogue_summary.json", summary)

    print(f"Definitions: {len(result)}")
    print(f"Review units: {len(decisions)}")
    print(f"Catalogue: {catalogue_path}")
    print(f"SHA-256: {summary['catalogue_sha256']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
