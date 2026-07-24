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

DOCUMENT_POLICY_PATH = 'docs/REPOSITORY_POLICY.json'


def load_document_roles(root: Path) -> dict[str, str]:
    policy_path = root / DOCUMENT_POLICY_PATH
    if not policy_path.exists():
        raise RRSError(f'Repository document policy is missing: {DOCUMENT_POLICY_PATH}')
    try:
        policy = json.loads(read_text(policy_path))
    except json.JSONDecodeError as exc:
        raise RRSError(f'Invalid repository document policy JSON: {exc}') from exc

    if policy.get('schema_version') != 1:
        raise RRSError('Unsupported repository document policy schema_version')
    documents = policy.get('documents')
    if not isinstance(documents, dict):
        raise RRSError('Repository document policy requires a documents object')

    roles: dict[str, str] = {}
    for document_id, metadata in documents.items():
        if not isinstance(metadata, dict):
            raise RRSError(f'Invalid document role metadata for {document_id}')
        rel = metadata.get('path')
        role = metadata.get('role')
        if not isinstance(rel, str) or not rel or not isinstance(role, str) or not role:
            raise RRSError(f'Document role requires path and role: {document_id}')
        normalised = Path(rel).as_posix()
        if normalised in roles:
            raise RRSError(f'Duplicate document path in repository policy: {normalised}')
        roles[normalised] = role
    return roles


def document_role(root: Path, rel: str) -> str | None:
    return load_document_roles(root).get(Path(rel).as_posix())


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


def ordered_files(root: Path) -> list[Path]:
    """Return repository files in one platform-neutral relative POSIX-path order."""
    files = (path for path in root.rglob('*') if path.is_file())
    return sorted(files, key=lambda path: path.relative_to(root).as_posix())


def inventory(root: Path) -> dict[str, dict[str, Any]]:
    result: dict[str, dict[str, Any]] = {}
    for path in ordered_files(root):
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
    with zipfile.ZipFile(destination, 'w', compression=zipfile.ZIP_STORED) as zf:
        for path in ordered_files(source):
            rel = path.relative_to(source).as_posix()
            info = zipfile.ZipInfo(rel, date_time=timestamp)
            info.create_system = 3
            info.compress_type = zipfile.ZIP_STORED
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
        if existed:
            role = document_role(root, rel)
            if role == 'knowledge':
                raise RRSError(
                    f'write_file cannot replace knowledge-role document: {rel}'
                )
            if op.get('replace_existing') is not True:
                raise RRSError(
                    f'write_file target already exists and replacement is not authorised: {rel}'
                )
        write_text(path, op['content'])
        result = {'type': kind, 'path': rel, 'change': 'modified' if existed else 'added'}
        if existed:
            result['replacement_authorised'] = True
        return result

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
    elif kind == 'insert_after_if_absent':
        knowledge_id = op.get('knowledge_id')
        if not knowledge_id:
            raise RRSError(f'insert_after_if_absent requires knowledge_id: {rel}')
        identity = op.get('identity') or f'knowledge-id: {knowledge_id}'
        identity_count = text.count(identity)
        if identity_count > 1:
            raise RRSError(
                f'insert_after_if_absent found duplicate identity in {rel}: {identity!r}'
            )
        if identity_count == 1:
            return {
                'type': kind,
                'path': rel,
                'change': 'unchanged',
                'result': 'already_applied',
                'knowledge_id': knowledge_id,
            }
        marker = op['marker']
        count = text.count(marker)
        if count != 1:
            raise RRSError(
                f'insert_after_if_absent expected one marker in {rel}, found {count}: {marker!r}'
            )
        content = op['content']
        if identity not in content:
            raise RRSError(
                f'insert_after_if_absent content must contain identity {identity!r}: {rel}'
            )
        text = text.replace(marker, marker + content, 1)
    else:
        raise RRSError(f'Unsupported operation type: {kind}')

    write_text(path, text)
    return {'type': kind, 'path': rel, 'change': 'modified'}


def apply_plan(root: Path, plan: dict[str, Any]) -> list[dict[str, Any]]:
    operations = plan.get('operations', [])
    knowledge_ids = [
        op.get('knowledge_id')
        for op in operations
        if op.get('knowledge_id') is not None
    ]
    duplicates = sorted({item for item in knowledge_ids if knowledge_ids.count(item) > 1})
    if duplicates:
        raise RRSError(f'Duplicate knowledge_id values in release plan: {duplicates}')

    applied = []
    for op in operations:
        applied.append(apply_operation(root, op))
    return applied


def regenerate_manifest(root: Path) -> None:
    manifest = root / 'docs/RELEASE_MANIFEST_SHA256.txt'
    entries = []
    for path in ordered_files(root):
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
        text = read_text(path)
        for line_no, line in enumerate(text.splitlines(), 1):
            if re.search(r'(?<![A-Za-z0-9_])\.\./tools/|(?<![A-Za-z0-9_])tools/', line):
                findings.append({'rule': 'active_reference_to_removed_tools', 'path': rel, 'line': line_no, 'evidence': line.strip()})

    manifest = root / 'docs/RELEASE_MANIFEST_SHA256.txt'
    if manifest.exists():
        for line_no, line in enumerate(read_text(manifest).splitlines(), 1):
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
        text = read_text(path)
        match = re.search(pattern, text, re.M | re.I)
        if match:
            line_no = text[:match.start()].count('\n') + 1
            findings.append({'rule': rule, 'path': rel, 'line': line_no, 'evidence': text.splitlines()[line_no - 1].strip()})

    for finding in findings:
        finding['finding_id'] = finding_id(finding)
    return sorted(findings, key=lambda x: (x['rule'], x['path'], x['line']))


def classify_delta(
    observed: dict[str, list[str]],
    declared: list[dict[str, str]],
    applied_operations: list[dict[str, Any]] | None = None,
) -> list[dict[str, Any]]:
    observed_set = {(kind[:-1] if kind.endswith('ed') else kind, p) for kind in () for p in []}  # type aid
    observed_set = set()
    mapping = {'added': 'added', 'removed': 'removed', 'modified': 'modified'}
    for kind, paths in observed.items():
        for path in paths:
            observed_set.add((mapping[kind], path))
    declared_set = {(item['change'], item['path']) for item in declared}
    already_applied_paths = {
        item['path']
        for item in (applied_operations or [])
        if item.get('change') == 'unchanged' and item.get('result') == 'already_applied'
    }
    result = []
    for change, path in sorted(observed_set):
        expected = (change, path) in declared_set
        result.append({'classification': 'Expected Change' if expected else 'Unexplained Divergence', 'change': change, 'path': path, 'blocking': not expected})
    for change, path in sorted(declared_set - observed_set):
        if path in already_applied_paths:
            result.append({
                'classification': 'Already Applied',
                'change': change,
                'path': path,
                'blocking': False,
            })
        else:
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
    for line in read_text(manifest).splitlines():
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


def _json_text(value: Any) -> str:
    return json.dumps(value, indent=2, ensure_ascii=False) + '\n'


def _safe_plan_details(plan_path: Path) -> tuple[dict[str, Any] | None, str | None]:
    try:
        return json.loads(read_text(plan_path)), None
    except Exception as exc:
        return None, f'{type(exc).__name__}: {exc}'


def _failure_evidence_name(plan: dict[str, Any] | None) -> str:
    if plan:
        configured = plan.get('evidence_filename')
        if isinstance(configured, str) and configured:
            return configured
    return 'rrs_failed_evidence.zip'


def _write_execution_failure_evidence(
    *,
    evidence_dir: Path,
    evidence_zip: Path,
    work: Path,
    baseline_zip: Path,
    plan_path: Path,
    plan: dict[str, Any] | None,
    failure: Exception,
    phase: str,
) -> None:
    evidence_dir.mkdir(parents=True, exist_ok=True)
    failure_record = {
        'rrs_version': '1.2.0',
        'result': 'EXECUTION_FAILURE',
        'phase': phase,
        'exception_type': type(failure).__name__,
        'message': str(failure),
        'workspace_retained': True,
        'workspace_path': work.name,
        'baseline_path': str(baseline_zip),
        'plan_path': str(plan_path),
    }
    write_text(evidence_dir / 'execution_failure.json', _json_text(failure_record))
    write_text(evidence_dir / 'workspace_path.txt', f'{work.name}\n')
    if plan is not None:
        write_text(evidence_dir / 'release_plan.json', _json_text(plan))
    elif plan_path.exists():
        try:
            shutil.copy2(plan_path, evidence_dir / 'release_plan_unparsed.json')
        except OSError:
            pass
    if baseline_zip.exists():
        try:
            write_text(
                evidence_dir / 'baseline_package_sha256.txt',
                f'{sha256_file(baseline_zip)}  {baseline_zip.name}\n',
            )
        except OSError:
            pass
    shutil.copy2(Path(__file__), evidence_dir / 'rrs.py')
    deterministic_zip(evidence_dir, evidence_zip)


def build_candidate(baseline_zip: Path, plan_path: Path, output_dir: Path) -> BuildResult:
    output_dir.mkdir(parents=True, exist_ok=True)
    work = output_dir / 'rrs_workspace'
    if work.exists():
        raise RRSError(f'Retained RRS workspace already exists: {work}')
    work.mkdir(parents=True)
    baseline_dir = work / 'baseline'
    candidate_dir = work / 'candidate'
    evidence_dir = work / 'evidence'
    evidence_dir.mkdir(parents=True)

    plan: dict[str, Any] | None = None
    phase = 'load_release_plan'
    try:
        plan = json.loads(read_text(plan_path))
        evidence_zip = output_dir / _failure_evidence_name(plan)

        phase = 'extract_baseline'
        safe_extract(baseline_zip, baseline_dir)
        shutil.copytree(baseline_dir, candidate_dir)

        phase = 'verify_baseline_fingerprint'
        baseline_sha = sha256_file(baseline_zip)
        expected_sha = plan.get('baseline_sha256')
        if expected_sha and baseline_sha != expected_sha:
            raise RRSError(f'Canonical baseline fingerprint mismatch: expected {expected_sha}, observed {baseline_sha}')

        phase = 'inventory_baseline'
        baseline_inv = inventory(baseline_dir)
        baseline_findings = repository_findings(baseline_dir)

        phase = 'apply_release_plan'
        applied = apply_plan(candidate_dir, plan)

        phase = 'regenerate_manifest'
        regenerate_manifest(candidate_dir)

        phase = 'validate_candidate'
        candidate_inv = inventory(candidate_dir)
        observed_delta = delta(baseline_inv, candidate_inv)
        declared = list(plan.get('declared_changes', []))
        manifest_change = {'change': 'modified', 'path': 'docs/RELEASE_MANIFEST_SHA256.txt'}
        if (
            'docs/RELEASE_MANIFEST_SHA256.txt' in observed_delta['modified']
            and manifest_change not in declared
        ):
            declared.append(manifest_change)
        delta_findings = classify_delta(observed_delta, declared, applied)
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
            'rrs_version': '1.2.0',
            'generated_at_utc': plan.get('generated_at_utc', '2026-07-23T00:00:00+00:00'),
            'result': status,
            'release_name': plan.get('release_name'),
            'workspace_retained': status != 'PASS',
            'workspace_path': work.name if status != 'PASS' else None,
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
            'release_plan.json': _json_text(plan),
            'baseline_inventory.json': _json_text(baseline_inv),
            'candidate_inventory.json': _json_text(candidate_inv),
            'observed_delta.json': _json_text(observed_delta),
            'release_findings.json': _json_text({'delta': delta_findings, 'repository': repository_classifications, 'blocking': blockers}),
            'validation_report.json': _json_text(report),
            'probe_results.json': _json_text(plan.get('probe_results', {})),
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
            f"- Workspace retained: {'yes' if status != 'PASS' else 'no'}",
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
        write_text(evidence_dir / 'baseline_package_sha256.txt', f'{baseline_sha}  {baseline_zip.name}\n')
        shutil.copy2(Path(__file__), evidence_dir / 'rrs.py')

        if status != 'PASS':
            write_text(evidence_dir / 'workspace_path.txt', f'{work.name}\n')
            deterministic_zip(evidence_dir, evidence_zip)
            raise RRSError(f'Candidate blocked; evidence written to {evidence_zip}; workspace retained at {work}')

        phase = 'package_candidate'
        deterministic_zip(candidate_dir, candidate_zip)
        write_text(evidence_dir / 'candidate_package_sha256.txt', f'{sha256_file(candidate_zip)}  {candidate_zip.name}\n')
        deterministic_zip(evidence_dir, evidence_zip)

        phase = 'cleanup_successful_workspace'
        shutil.rmtree(work)
        return BuildResult(candidate_zip, evidence_zip, report)

    except Exception as exc:
        if isinstance(exc, RRSError) and 'Candidate blocked; evidence written to' in str(exc):
            raise
        evidence_zip = output_dir / _failure_evidence_name(plan)
        try:
            _write_execution_failure_evidence(
                evidence_dir=evidence_dir,
                evidence_zip=evidence_zip,
                work=work,
                baseline_zip=baseline_zip,
                plan_path=plan_path,
                plan=plan,
                failure=exc,
                phase=phase,
            )
        except Exception as evidence_exc:
            raise RRSError(
                f'Execution failed during {phase}: {exc}; failure evidence could not be packaged: {evidence_exc}; workspace retained at {work}'
            ) from exc
        raise RRSError(
            f'Execution failed during {phase}: {exc}; evidence written to {evidence_zip}; workspace retained at {work}'
        ) from exc

def _run_release_workflow(baseline: Path, plan: Path, output: Path) -> int:
    try:
        result = build_candidate(baseline, plan, output)
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


def main(argv: Iterable[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description='OuttaMyWay Repository Release System')
    sub = parser.add_subparsers(dest='command', required=True)

    build = sub.add_parser('build', help='Low-level candidate build and validation command')
    build.add_argument('--baseline', required=True, type=Path)
    build.add_argument('--plan', required=True, type=Path)
    build.add_argument('--output', required=True, type=Path)

    evolve = sub.add_parser(
        'evolve',
        help='Run the complete local repository evolution workflow',
    )
    evolve.add_argument('--baseline', required=True, type=Path)
    evolve.add_argument(
        '--handoff',
        required=True,
        type=Path,
        help='Planning handoff JSON describing the intended repository transition',
    )
    evolve.add_argument('--output', required=True, type=Path)

    args = parser.parse_args(argv)
    plan = args.plan if args.command == 'build' else args.handoff
    return _run_release_workflow(args.baseline, plan, args.output)


if __name__ == '__main__':
    raise SystemExit(main())
