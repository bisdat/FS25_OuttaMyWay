from __future__ import annotations

import argparse
import hashlib
import json
import re
import shutil
import sys
import tempfile
import zipfile
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Iterable

TEXT_SUFFIXES = {'.md', '.txt', '.xml', '.lua', '.json', '.py'}
SKIP_MANIFEST = {'docs/RELEASE_MANIFEST_SHA256.txt'}


class RRSError(RuntimeError):
    pass


def utc_now() -> str:
    return datetime.now(timezone.utc).replace(microsecond=0).isoformat()


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open('rb') as f:
        for block in iter(lambda: f.read(1024 * 1024), b''):
            h.update(block)
    return h.hexdigest()


def inventory(root: Path) -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    for path in sorted(root.rglob('*')):
        if path.is_file():
            rel = path.relative_to(root).as_posix()
            result[rel] = {'sha256': sha256_file(path), 'size': path.stat().st_size}
    return result


def tree_hash(inv: dict[str, dict[str, Any]]) -> str:
    h = hashlib.sha256()
    for rel, meta in sorted(inv.items()):
        h.update(rel.encode('utf-8'))
        h.update(b'\0')
        h.update(meta['sha256'].encode('ascii'))
        h.update(b'\0')
        h.update(str(meta['size']).encode('ascii'))
        h.update(b'\n')
    return h.hexdigest()


def delta(before: dict[str, Any], after: dict[str, Any]) -> dict[str, list[str]]:
    return {
        'added': sorted(set(after) - set(before)),
        'removed': sorted(set(before) - set(after)),
        'modified': sorted(p for p in set(before) & set(after) if before[p] != after[p]),
    }


def safe_extract(zip_path: Path, destination: Path) -> None:
    destination.mkdir(parents=True, exist_ok=True)
    base = destination.resolve()
    with zipfile.ZipFile(zip_path) as zf:
        for member in zf.infolist():
            target = (destination / member.filename).resolve()
            if target != base and base not in target.parents:
                raise RRSError(f'Unsafe ZIP path: {member.filename}')
        zf.extractall(destination)


def deterministic_zip(source: Path, destination: Path) -> None:
    destination.parent.mkdir(parents=True, exist_ok=True)
    timestamp = (2026, 1, 1, 0, 0, 0)
    with zipfile.ZipFile(destination, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for path in sorted(source.rglob('*')):
            if not path.is_file():
                continue
            rel = path.relative_to(source).as_posix()
            info = zipfile.ZipInfo(rel, date_time=timestamp)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = (0o100644 & 0xFFFF) << 16
            zf.writestr(info, path.read_bytes())


def read_text(path: Path) -> str:
    return path.read_text(encoding='utf-8')


def write_text(path: Path, text: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding='utf-8', newline='')


def repository_version(root: Path) -> str:
    moddesc = read_text(root / 'modDesc.xml')
    match = re.search(r'<version(?:\s+[^>]*)?>\s*([^<]+?)\s*</version>', moddesc)
    if not match:
        raise RRSError('modDesc.xml does not contain a version')
    return match.group(1)


def apply_operation(root: Path, op: dict[str, Any]) -> dict[str, Any]:
    kind = op['type']
    rel = op['path']
    path = root / rel

    if kind == 'write_file':
        existed = path.exists()
        write_text(path, op['content'])
        return {'type': kind, 'path': rel, 'change': 'modified' if existed else 'added'}

    if kind == 'delete_file':
        if not path.exists():
            raise RRSError(f'delete_file target does not exist: {rel}')
        path.unlink()
        return {'type': kind, 'path': rel, 'change': 'removed'}

    if not path.exists():
        raise RRSError(f'Operation target does not exist: {rel}')
    text = read_text(path)

    if kind == 'replace_once':
        old = op['old']
        count = text.count(old)
        if count != 1:
            raise RRSError(f'replace_once expected one match in {rel}, found {count}: {old!r}')
        text = text.replace(old, op['new'])
    elif kind == 'prepend':
        text = op['content'] + text
    elif kind == 'append':
        text = text + op['content']
    elif kind == 'insert_after':
        marker = op['marker']
        count = text.count(marker)
        if count != 1:
            raise RRSError(f'insert_after expected one marker in {rel}, found {count}: {marker!r}')
        text = text.replace(marker, marker + op['content'], 1)
    else:
        raise RRSError(f'Unsupported operation type: {kind}')

    write_text(path, text)
    return {'type': kind, 'path': rel, 'change': 'modified'}


def apply_plan(root: Path, plan: dict[str, Any]) -> list[dict[str, Any]]:
    applied = []
    for op in plan.get('operations', []):
        applied.append(apply_operation(root, op))
    return applied


def regenerate_manifest(root: Path) -> None:
    manifest = root / 'docs/RELEASE_MANIFEST_SHA256.txt'
    entries = []
    for path in sorted(root.rglob('*')):
        if not path.is_file():
            continue
        rel = path.relative_to(root).as_posix()
        if rel in SKIP_MANIFEST:
            continue
        entries.append(f'{sha256_file(path)}  {rel}')
    write_text(manifest, '\n'.join(entries) + '\n')


def finding_id(finding: dict[str, Any]) -> str:
    basis = '|'.join(str(finding.get(k, '')) for k in ('rule', 'path', 'line', 'evidence'))
    return hashlib.sha256(basis.encode('utf-8')).hexdigest()[:16]


def repository_findings(root: Path) -> list[dict[str, Any]]:
    findings: list[dict[str, Any]] = []

    required = ['README.txt', 'CHANGELOG.md', 'modDesc.xml', 'docs/README.md', 'docs/PROJECT_STATUS.md']
    for rel in required:
        if not (root / rel).exists():
            findings.append({'rule': 'required_file_missing', 'path': rel, 'line': 0, 'evidence': rel})

    active_files = [
        p for p in root.rglob('*')
        if p.is_file() and 'archive' not in p.parts and 'rrs' not in p.parts and p.suffix.lower() in TEXT_SUFFIXES
    ]
    for path in active_files:
        rel = path.relative_to(root).as_posix()
        if rel in {'CHANGELOG.md', 'docs/CHANGELOG.md', 'docs/RELEASE_MANIFEST_SHA256.txt'}:
            continue
        text = path.read_text(encoding='utf-8', errors='replace')
        for line_no, line in enumerate(text.splitlines(), 1):
            if re.search(r'(?<![A-Za-z0-9_])\.\./tools/|(?<![A-Za-z0-9_])tools/', line):
                findings.append({'rule': 'active_reference_to_removed_tools', 'path': rel, 'line': line_no, 'evidence': line.strip()})

    manifest = root / 'docs/RELEASE_MANIFEST_SHA256.txt'
    if manifest.exists():
        for line_no, line in enumerate(manifest.read_text(errors='replace').splitlines(), 1):
            parts = line.split(maxsplit=1)
            if len(parts) != 2:
                continue
            listed = parts[1].strip().replace('\\', '/')
            if not (root / listed).exists():
                findings.append({'rule': 'manifest_references_missing_path', 'path': 'docs/RELEASE_MANIFEST_SHA256.txt', 'line': line_no, 'evidence': listed})

    checks = [
        ('README.txt', r'v4\.5\.8\s+classifies', 'stale_current_release_description'),
        ('CHANGELOG.md', r'^##\s+v[0-9.]+\s+Candidate', 'canonical_release_labelled_candidate'),
        ('docs/ENGINEERING_HANDOVER.md', r'canonical candidate pending independent user verification', 'canonical_status_still_pending'),
    ]
    for rel, pattern, rule in checks:
        path = root / rel
        if not path.exists():
            continue
        text = path.read_text(errors='replace')
        match = re.search(pattern, text, re.M | re.I)
        if match:
            line_no = text[:match.start()].count('\n') + 1
            findings.append({'rule': rule, 'path': rel, 'line': line_no, 'evidence': text.splitlines()[line_no - 1].strip()})

    for finding in findings:
        finding['finding_id'] = finding_id(finding)
    return sorted(findings, key=lambda x: (x['rule'], x['path'], x['line']))


def classify_delta(observed: dict[str, list[str]], declared: list[dict[str, str]]) -> list[dict[str, Any]]:
    observed_set = {(kind[:-1] if kind.endswith('ed') else kind, p) for kind in () for p in []}  # type aid
    observed_set = set()
    mapping = {'added': 'added', 'removed': 'removed', 'modified': 'modified'}
    for kind, paths in observed.items():
        for path in paths:
            observed_set.add((mapping[kind], path))
    declared_set = {(item['change'], item['path']) for item in declared}
    result = []
    for change, path in sorted(observed_set):
        expected = (change, path) in declared_set
        result.append({'classification': 'Expected Change' if expected else 'Unexplained Divergence', 'change': change, 'path': path, 'blocking': not expected})
    for change, path in sorted(declared_set - observed_set):
        result.append({'classification': 'Missing Declared Change', 'change': change, 'path': path, 'blocking': True})
    return result


def classify_repository_findings(baseline: list[dict[str, Any]], candidate: list[dict[str, Any]]) -> list[dict[str, Any]]:
    before = {f['finding_id']: f for f in baseline}
    after = {f['finding_id']: f for f in candidate}
    result = []
    for fid in sorted(after):
        item = dict(after[fid])
        if fid in before:
            item.update(classification='Inherited Baseline Debt', blocking=False)
        else:
            item.update(classification='Introduced Violation', blocking=True)
        result.append(item)
    for fid in sorted(set(before) - set(after)):
        item = dict(before[fid])
        item.update(classification='Resolved Baseline Finding', blocking=False)
        result.append(item)
    return result


def verify_manifest(root: Path) -> list[str]:
    manifest = root / 'docs/RELEASE_MANIFEST_SHA256.txt'
    problems = []
    if not manifest.exists():
        return ['manifest missing']
    for line in manifest.read_text(errors='replace').splitlines():
        parts = line.split(maxsplit=1)
        if len(parts) != 2:
            problems.append(f'malformed manifest line: {line}')
            continue
        expected, rel = parts
        path = root / rel.strip().replace('\\', '/')
        if not path.exists():
            problems.append(f'missing: {rel}')
        elif sha256_file(path) != expected:
            problems.append(f'hash mismatch: {rel}')
    return problems


@dataclass
class BuildResult:
    candidate_zip: Path
    evidence_zip: Path
    report: dict[str, Any]


def build_candidate(baseline_zip: Path, plan_path: Path, output_dir: Path) -> BuildResult:
    plan = json.loads(plan_path.read_text(encoding='utf-8'))
    output_dir.mkdir(parents=True, exist_ok=True)
    work = Path(tempfile.mkdtemp(prefix='rrs_', dir=output_dir))
    baseline_dir = work / 'baseline'
    candidate_dir = work / 'candidate'
    evidence_dir = work / 'evidence'
    evidence_dir.mkdir(parents=True)

    safe_extract(baseline_zip, baseline_dir)
    shutil.copytree(baseline_dir, candidate_dir)

    baseline_sha = sha256_file(baseline_zip)
    expected_sha = plan.get('baseline_sha256')
    if expected_sha and baseline_sha != expected_sha:
        raise RRSError(f'Canonical baseline fingerprint mismatch: expected {expected_sha}, observed {baseline_sha}')

    baseline_inv = inventory(baseline_dir)
    baseline_findings = repository_findings(baseline_dir)
    applied = apply_plan(candidate_dir, plan)
    regenerate_manifest(candidate_dir)

    candidate_inv = inventory(candidate_dir)
    observed_delta = delta(baseline_inv, candidate_inv)
    declared = list(plan.get('declared_changes', []))
    if {'change': 'modified', 'path': 'docs/RELEASE_MANIFEST_SHA256.txt'} not in declared:
        declared.append({'change': 'modified', 'path': 'docs/RELEASE_MANIFEST_SHA256.txt'})
    delta_findings = classify_delta(observed_delta, declared)
    candidate_findings = repository_findings(candidate_dir)
    repository_classifications = classify_repository_findings(baseline_findings, candidate_findings)
    manifest_problems = verify_manifest(candidate_dir)

    blockers = [f for f in delta_findings + repository_classifications if f.get('blocking')]
    for problem in manifest_problems:
        blockers.append({'classification': 'Introduced Violation', 'rule': 'manifest_verification', 'evidence': problem, 'blocking': True})

    expected_version = plan.get('target_version')
    actual_version = repository_version(candidate_dir)
    if expected_version and actual_version != expected_version:
        blockers.append({'classification': 'Introduced Violation', 'rule': 'version_identity_mismatch', 'evidence': f'expected {expected_version}; observed {actual_version}', 'blocking': True})

    status = 'PASS' if not blockers else 'FAIL'
    candidate_name = plan.get('candidate_filename') or f"candidate_v{actual_version}.zip"
    evidence_name = plan.get('evidence_filename') or f"candidate_v{actual_version}_evidence.zip"
    candidate_zip = output_dir / candidate_name
    evidence_zip = output_dir / evidence_name

    report = {
        'rrs_version': '1.0.0-reconstructed',
        'generated_at_utc': plan.get('generated_at_utc', '2026-07-23T00:00:00+00:00'),
        'result': status,
        'release_name': plan.get('release_name'),
        'baseline': {
            'filename': baseline_zip.name,
            'sha256': baseline_sha,
            'version': repository_version(baseline_dir),
            'file_count': len(baseline_inv),
            'tree_sha256': tree_hash(baseline_inv),
        },
        'candidate': {
            'filename': candidate_name,
            'version': actual_version,
            'file_count': len(candidate_inv),
            'tree_sha256': tree_hash(candidate_inv),
        },
        'declared_changes': declared,
        'applied_operations': applied,
        'observed_delta': observed_delta,
        'delta_findings': delta_findings,
        'repository_findings': repository_classifications,
        'manifest_problems': manifest_problems,
        'blocking_findings': blockers,
    }

    for filename, content in {
        'release_plan.json': json.dumps(plan, indent=2) + '\n',
        'baseline_inventory.json': json.dumps(baseline_inv, indent=2) + '\n',
        'candidate_inventory.json': json.dumps(candidate_inv, indent=2) + '\n',
        'observed_delta.json': json.dumps(observed_delta, indent=2) + '\n',
        'release_findings.json': json.dumps({'delta': delta_findings, 'repository': repository_classifications, 'blocking': blockers}, indent=2) + '\n',
        'validation_report.json': json.dumps(report, indent=2) + '\n',
        'probe_results.json': json.dumps(plan.get('probe_results', {}), indent=2) + '\n',
    }.items():
        write_text(evidence_dir / filename, content)

    summary = [
        f"# RRS Validation Report — {plan.get('release_name', actual_version)}",
        '',
        f"**Result:** {status}",
        '',
        f"- Baseline: `{baseline_zip.name}`",
        f"- Baseline SHA-256: `{baseline_sha}`",
        f"- Candidate: `{candidate_name}`",
        f"- Version: `{actual_version}`",
        f"- Declared changes: {len(declared)}",
        f"- Observed changed paths: {sum(len(v) for v in observed_delta.values())}",
        f"- Blocking findings: {len(blockers)}",
        '',
        '## Observed delta',
        '',
    ]
    for kind in ('added', 'modified', 'removed'):
        summary.append(f"### {kind.title()}")
        summary.extend([f"- `{p}`" for p in observed_delta[kind]] or ['- None'])
        summary.append('')
    if blockers:
        summary.extend(['## Blocking findings', ''])
        for item in blockers:
            summary.append(f"- {item.get('classification')}: {item.get('path', item.get('rule', 'unknown'))} — {item.get('evidence', '')}")
    write_text(evidence_dir / 'README.md', '\n'.join(summary) + '\n')

    if status != 'PASS':
        deterministic_zip(evidence_dir, evidence_zip)
        raise RRSError(f'Candidate blocked; evidence written to {evidence_zip}')

    deterministic_zip(candidate_dir, candidate_zip)
    write_text(evidence_dir / 'candidate_package_sha256.txt', f'{sha256_file(candidate_zip)}  {candidate_zip.name}\n')
    write_text(evidence_dir / 'baseline_package_sha256.txt', f'{baseline_sha}  {baseline_zip.name}\n')
    shutil.copy2(Path(__file__), evidence_dir / 'rrs.py')
    deterministic_zip(evidence_dir, evidence_zip)
    shutil.rmtree(work)
    return BuildResult(candidate_zip, evidence_zip, report)


def main(argv: Iterable[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description='OuttaMyWay Repository Release System')
    sub = parser.add_subparsers(dest='command', required=True)
    build = sub.add_parser('build', help='Build and validate a release candidate')
    build.add_argument('--baseline', required=True, type=Path)
    build.add_argument('--plan', required=True, type=Path)
    build.add_argument('--output', required=True, type=Path)
    args = parser.parse_args(argv)

    try:
        result = build_candidate(args.baseline, args.plan, args.output)
    except RRSError as exc:
        print(f'RRS BLOCKED: {exc}', file=sys.stderr)
        return 2

    print(json.dumps({
        'result': result.report['result'],
        'candidate_zip': str(result.candidate_zip),
        'evidence_zip': str(result.evidence_zip),
        'candidate_sha256': sha256_file(result.candidate_zip),
    }, indent=2))
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
