import json, tempfile, zipfile
from pathlib import Path
import sys
for parent in Path(__file__).resolve().parents:
    if (parent / 'rrs' / 'rrs.py').exists():
        sys.path.insert(0, str(parent))
        break
from rrs.rrs import build_candidate, RRSError, deterministic_zip, sha256_file, regenerate_manifest


def make_repo(root: Path):
    (root/'docs').mkdir(parents=True)
    files={
      'README.txt':'Demo v1.0.0\n',
      'CHANGELOG.md':'# Changelog\n\n## v1.0.0\n',
      'modDesc.xml':'<modDesc><version>1.0.0</version></modDesc>\n',
      'docs/README.md':'# Map\n',
      'docs/PROJECT_STATUS.md':'# Status\n',
      'docs/ENGINEERING_HANDOVER.md':'# Handover\n',
      'docs/RELEASE_MANIFEST_SHA256.txt':'',
    }
    for rel,text in files.items():
        p=root/rel;p.parent.mkdir(parents=True,exist_ok=True);p.write_text(text)
    (root/'docs/REPOSITORY_POLICY.json').write_text(json.dumps({
      'schema_version': 1,
      'documents': {
        'project_status': {'path': 'docs/PROJECT_STATUS.md', 'role': 'knowledge'},
        'readme': {'path': 'README.txt', 'role': 'general'},
        'manifest': {'path': 'docs/RELEASE_MANIFEST_SHA256.txt', 'role': 'generated'},
      },
    }))


def plan(path: Path, baseline_sha: str, extra=None):
    data={
      'release_name':'probe','baseline_sha256':baseline_sha,'target_version':'1.0.1',
      'candidate_filename':'probe_candidate.zip','evidence_filename':'probe_evidence.zip',
      'declared_changes':[{'change':'modified','path':'modDesc.xml'},{'change':'modified','path':'README.txt'}],
      'operations':[
        {'type':'replace_once','path':'modDesc.xml','old':'<version>1.0.0</version>','new':'<version>1.0.1</version>'},
        {'type':'replace_once','path':'README.txt','old':'Demo v1.0.0','new':'Demo v1.0.1'},
      ]}
    if extra: extra(data)
    path.write_text(json.dumps(data))


def test_success(tmp_path: Path):
    repo=tmp_path/'repo';repo.mkdir();make_repo(repo)
    base=tmp_path/'base.zip';deterministic_zip(repo,base)
    pp=tmp_path/'plan.json';plan(pp,sha256_file(base))
    result=build_candidate(base,pp,tmp_path/'out')
    assert result.report['result']=='PASS'
    assert result.candidate_zip.exists() and result.evidence_zip.exists()
    with zipfile.ZipFile(result.evidence_zip) as z:
        names=set(z.namelist())
        assert {'README.md','validation_report.json','release_findings.json','rrs.py'} <= names


def test_missing_declared_change_blocks(tmp_path: Path):
    repo=tmp_path/'repo';repo.mkdir();make_repo(repo)
    base=tmp_path/'base.zip';deterministic_zip(repo,base)
    pp=tmp_path/'plan.json'
    def extra(data): data['declared_changes'].append({'change':'added','path':'ABSENT.txt'})
    plan(pp,sha256_file(base),extra)
    try: build_candidate(base,pp,tmp_path/'out')
    except RRSError: pass
    else: raise AssertionError('expected block')


def test_unexplained_divergence_blocks(tmp_path: Path):
    repo=tmp_path/'repo';repo.mkdir();make_repo(repo)
    base=tmp_path/'base.zip';deterministic_zip(repo,base)
    pp=tmp_path/'plan.json'
    def extra(data): data['operations'].append({'type':'write_file','path':'EXTRA.txt','content':'x'})
    plan(pp,sha256_file(base),extra)
    try: build_candidate(base,pp,tmp_path/'out')
    except RRSError: pass
    else: raise AssertionError('expected block')


def test_introduced_violation_blocks(tmp_path: Path):
    repo=tmp_path/'repo';repo.mkdir();make_repo(repo)
    base=tmp_path/'base.zip';deterministic_zip(repo,base)
    pp=tmp_path/'plan.json'
    def extra(data):
        data['operations'].append({'type':'write_file','path':'BAD.md','content':'run tools/verify.py\n'})
        data['declared_changes'].append({'change':'added','path':'BAD.md'})
    plan(pp,sha256_file(base),extra)
    try: build_candidate(base,pp,tmp_path/'out')
    except RRSError: pass
    else: raise AssertionError('expected block')


def test_insert_after_if_absent_is_idempotent(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    target = repo / 'docs' / 'PROJECT_STATUS.md'
    operation = {
        'type': 'insert_after_if_absent',
        'path': 'docs/PROJECT_STATUS.md',
        'knowledge_id': 'RES-001',
        'marker': '# Status\n',
        'content': '\n<!-- knowledge-id: RES-001 -->\nRepository Engineering System.\n',
    }

    from rrs.rrs import apply_operation
    first = apply_operation(repo, operation)
    after_first = target.read_text()
    second = apply_operation(repo, operation)
    after_second = target.read_text()

    assert first['change'] == 'modified'
    assert second['change'] == 'unchanged'
    assert second['result'] == 'already_applied'
    assert after_second == after_first
    assert after_second.count('knowledge-id: RES-001') == 1


def test_insert_after_if_absent_requires_identity_in_content(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    operation = {
        'type': 'insert_after_if_absent',
        'path': 'docs/PROJECT_STATUS.md',
        'knowledge_id': 'RES-001',
        'marker': '# Status\n',
        'content': '\nRepository Engineering System.\n',
    }

    from rrs.rrs import apply_operation
    try:
        apply_operation(repo, operation)
    except RRSError as exc:
        assert 'content must contain identity' in str(exc)
    else:
        raise AssertionError('expected identity validation failure')


def test_duplicate_knowledge_ids_in_plan_block(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    from rrs.rrs import apply_plan
    operation = {
        'type': 'insert_after_if_absent',
        'path': 'docs/PROJECT_STATUS.md',
        'knowledge_id': 'RES-001',
        'marker': '# Status\n',
        'content': '\n<!-- knowledge-id: RES-001 -->\nRepository Engineering System.\n',
    }

    try:
        apply_plan(repo, {'operations': [operation, dict(operation)]})
    except RRSError as exc:
        assert 'Duplicate knowledge_id' in str(exc)
    else:
        raise AssertionError('expected duplicate knowledge_id failure')


def test_complete_build_accepts_already_applied_knowledge(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    target = repo / 'docs' / 'PROJECT_STATUS.md'
    target.write_text(
        '# Status\n\n<!-- knowledge-id: RES-001 -->\nRepository Engineering System.\n'
    )
    regenerate_manifest(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'
    data = {
        'release_name': 'idempotence-probe',
        'baseline_sha256': sha256_file(base),
        'target_version': '1.0.0',
        'candidate_filename': 'idempotent_candidate.zip',
        'evidence_filename': 'idempotent_evidence.zip',
        'declared_changes': [
            {'change': 'modified', 'path': 'docs/PROJECT_STATUS.md'},
        ],
        'operations': [
            {
                'type': 'insert_after_if_absent',
                'path': 'docs/PROJECT_STATUS.md',
                'knowledge_id': 'RES-001',
                'marker': '# Status\n',
                'content': '\n<!-- knowledge-id: RES-001 -->\nRepository Engineering System.\n',
            }
        ],
    }
    pp.write_text(json.dumps(data))

    result = build_candidate(base, pp, tmp_path / 'out')

    assert result.report['result'] == 'PASS'
    assert result.report['observed_delta'] == {'added': [], 'removed': [], 'modified': []}
    assert result.report['applied_operations'][0]['result'] == 'already_applied'
    assert {
        'classification': 'Already Applied',
        'change': 'modified',
        'path': 'docs/PROJECT_STATUS.md',
        'blocking': False,
    } in result.report['delta_findings']
    assert result.candidate_zip.exists()
    assert result.evidence_zip.exists()


def test_write_file_existing_target_requires_explicit_authorisation(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    from rrs.rrs import apply_operation

    try:
        apply_operation(repo, {
            'type': 'write_file',
            'path': 'README.txt',
            'content': 'Replaced\n',
        })
    except RRSError as exc:
        assert 'replacement is not authorised' in str(exc)
    else:
        raise AssertionError('expected existing-file replacement to be blocked')


def test_write_file_knowledge_role_blocks_even_with_authorisation(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    from rrs.rrs import apply_operation

    try:
        apply_operation(repo, {
            'type': 'write_file',
            'path': 'docs/PROJECT_STATUS.md',
            'content': '# Replaced\n',
            'replace_existing': True,
        })
    except RRSError as exc:
        assert 'cannot replace knowledge-role document' in str(exc)
    else:
        raise AssertionError('expected knowledge-role replacement to be blocked')


def test_write_file_non_knowledge_target_allows_explicit_authorisation(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    from rrs.rrs import apply_operation

    result = apply_operation(repo, {
        'type': 'write_file',
        'path': 'README.txt',
        'content': 'Replaced\n',
        'replace_existing': True,
    })

    assert result == {
        'type': 'write_file',
        'path': 'README.txt',
        'change': 'modified',
        'replacement_authorised': True,
    }
    assert (repo / 'README.txt').read_text() == 'Replaced\n'


def test_document_roles_are_repository_owned(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    from rrs.rrs import apply_operation
    policy_path = repo / 'docs' / 'REPOSITORY_POLICY.json'
    policy = json.loads(policy_path.read_text())
    policy['documents']['readme']['role'] = 'knowledge'
    policy_path.write_text(json.dumps(policy))

    try:
        apply_operation(repo, {
            'type': 'write_file',
            'path': 'README.txt',
            'content': 'Replaced\n',
            'replace_existing': True,
        })
    except RRSError as exc:
        assert 'cannot replace knowledge-role document' in str(exc)
    else:
        raise AssertionError('expected policy-defined knowledge role to be enforced')


def test_write_file_new_target_needs_no_replacement_authorisation(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    from rrs.rrs import apply_operation

    result = apply_operation(repo, {
        'type': 'write_file',
        'path': 'docs/NEW_DISCOVERY.md',
        'content': '# New discovery\n',
    })

    assert result == {
        'type': 'write_file',
        'path': 'docs/NEW_DISCOVERY.md',
        'change': 'added',
    }


def test_evolve_command_runs_complete_workflow(tmp_path: Path, capsys):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'handoff.json'; plan(pp, sha256_file(base))
    out = tmp_path / 'out'
    from rrs.rrs import main

    exit_code = main([
        'evolve',
        '--baseline', str(base),
        '--handoff', str(pp),
        '--output', str(out),
    ])

    assert exit_code == 0
    payload = json.loads(capsys.readouterr().out)
    assert payload['result'] == 'PASS'
    assert Path(payload['candidate_zip']).exists()
    assert Path(payload['evidence_zip']).exists()


def test_evolve_command_reports_blocked_transition(tmp_path: Path, capsys):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'handoff.json'
    def extra(data):
        data['declared_changes'].append({'change': 'added', 'path': 'ABSENT.txt'})
    plan(pp, sha256_file(base), extra)
    from rrs.rrs import main

    exit_code = main([
        'evolve',
        '--baseline', str(base),
        '--handoff', str(pp),
        '--output', str(tmp_path / 'out'),
    ])

    assert exit_code == 2
    assert 'RRS BLOCKED:' in capsys.readouterr().err


def test_build_and_evolve_produce_equivalent_validated_outputs(tmp_path: Path, capsys):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'handoff.json'; plan(pp, sha256_file(base))
    from rrs.rrs import main

    build_out = tmp_path / 'build_out'
    build_exit = main([
        'build',
        '--baseline', str(base),
        '--plan', str(pp),
        '--output', str(build_out),
    ])
    build_payload = json.loads(capsys.readouterr().out)

    evolve_out = tmp_path / 'evolve_out'
    evolve_exit = main([
        'evolve',
        '--baseline', str(base),
        '--handoff', str(pp),
        '--output', str(evolve_out),
    ])
    evolve_payload = json.loads(capsys.readouterr().out)

    assert build_exit == evolve_exit == 0
    assert build_payload['result'] == evolve_payload['result'] == 'PASS'
    assert build_payload['candidate_sha256'] == evolve_payload['candidate_sha256']
    assert sha256_file(Path(build_payload['candidate_zip'])) == sha256_file(Path(evolve_payload['candidate_zip']))
    assert sha256_file(Path(build_payload['evidence_zip'])) == sha256_file(Path(evolve_payload['evidence_zip']))


def test_build_and_evolve_block_equivalently_and_write_evidence(tmp_path: Path, capsys):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'handoff.json'

    def extra(data):
        data['declared_changes'].append({'change': 'added', 'path': 'ABSENT.txt'})

    plan(pp, sha256_file(base), extra)
    from rrs.rrs import main

    build_out = tmp_path / 'build_out'
    build_exit = main([
        'build',
        '--baseline', str(base),
        '--plan', str(pp),
        '--output', str(build_out),
    ])
    build_capture = capsys.readouterr()

    evolve_out = tmp_path / 'evolve_out'
    evolve_exit = main([
        'evolve',
        '--baseline', str(base),
        '--handoff', str(pp),
        '--output', str(evolve_out),
    ])
    evolve_capture = capsys.readouterr()

    assert build_exit == evolve_exit == 2
    assert 'RRS BLOCKED:' in build_capture.err
    assert 'RRS BLOCKED:' in evolve_capture.err

    build_evidence = build_out / 'probe_evidence.zip'
    evolve_evidence = evolve_out / 'probe_evidence.zip'
    assert build_evidence.exists()
    assert evolve_evidence.exists()
    assert sha256_file(build_evidence) == sha256_file(evolve_evidence)


def test_success_removes_workspace(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'; plan(pp, sha256_file(base))
    out = tmp_path / 'out'

    result = build_candidate(base, pp, out)

    assert result.report['workspace_retained'] is False
    assert result.report['workspace_path'] is None
    assert not (out / 'rrs_workspace').exists()


def test_blocked_build_retains_workspace_and_records_it(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'

    def extra(data):
        data['declared_changes'].append({'change': 'added', 'path': 'ABSENT.txt'})

    plan(pp, sha256_file(base), extra)
    out = tmp_path / 'out'

    try:
        build_candidate(base, pp, out)
    except RRSError as exc:
        assert 'workspace retained' in str(exc)
    else:
        raise AssertionError('expected blocked candidate')

    workspace = out / 'rrs_workspace'
    evidence = out / 'probe_evidence.zip'
    assert workspace.exists()
    assert evidence.exists()
    with zipfile.ZipFile(evidence) as zf:
        report = json.loads(zf.read('validation_report.json').decode('utf-8'))
        assert report['workspace_retained'] is True
        assert report['workspace_path'] == 'rrs_workspace'
        assert zf.read('workspace_path.txt').decode('utf-8') == 'rrs_workspace\n'


def test_execution_failure_writes_evidence_and_retains_workspace(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'; plan(pp, sha256_file(base))
    data = json.loads(pp.read_text(encoding='utf-8'))
    data['operations'].append({'type': 'unsupported', 'path': 'README.txt'})
    pp.write_text(json.dumps(data), encoding='utf-8')
    out = tmp_path / 'out'

    try:
        build_candidate(base, pp, out)
    except RRSError as exc:
        assert 'Execution failed during apply_release_plan' in str(exc)
        assert 'evidence written' in str(exc)
    else:
        raise AssertionError('expected execution failure')

    assert (out / 'rrs_workspace').exists()
    evidence = out / 'probe_evidence.zip'
    assert evidence.exists()
    with zipfile.ZipFile(evidence) as zf:
        failure = json.loads(zf.read('execution_failure.json').decode('utf-8'))
        assert failure['result'] == 'EXECUTION_FAILURE'
        assert failure['phase'] == 'apply_release_plan'
        assert failure['workspace_retained'] is True
        assert failure['workspace_path'] == 'rrs_workspace'
        assert 'rrs.py' in zf.namelist()


def test_invalid_plan_json_still_writes_failure_evidence(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'; pp.write_text('{not json', encoding='utf-8')
    out = tmp_path / 'out'

    try:
        build_candidate(base, pp, out)
    except RRSError as exc:
        assert 'load_release_plan' in str(exc)
    else:
        raise AssertionError('expected invalid plan failure')

    evidence = out / 'rrs_failed_evidence.zip'
    assert evidence.exists()
    assert (out / 'rrs_workspace').exists()
    with zipfile.ZipFile(evidence) as zf:
        assert 'execution_failure.json' in zf.namelist()
        assert 'release_plan_unparsed.json' in zf.namelist()


def test_utf8_content_round_trips_through_candidate_and_evidence(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'; plan(pp, sha256_file(base))
    data = json.loads(pp.read_text(encoding='utf-8'))
    content = '# Discovery\n\nGraceful coopération — “Reality is the final architect.”\n'
    data['operations'].append({
        'type': 'write_file',
        'path': 'docs/UTF8_DISCOVERY.md',
        'content': content,
    })
    data['declared_changes'].append({'change': 'added', 'path': 'docs/UTF8_DISCOVERY.md'})
    data['release_name'] = 'UTF-8 évolution'
    pp.write_text(json.dumps(data, ensure_ascii=False), encoding='utf-8')

    result = build_candidate(base, pp, tmp_path / 'out')

    with zipfile.ZipFile(result.candidate_zip) as zf:
        assert zf.read('docs/UTF8_DISCOVERY.md').decode('utf-8') == content
    with zipfile.ZipFile(result.evidence_zip) as zf:
        plan_text = zf.read('release_plan.json').decode('utf-8')
        report_text = zf.read('validation_report.json').decode('utf-8')
        assert 'UTF-8 évolution' in plan_text
        assert 'UTF-8 évolution' in report_text
        assert '\\u00e9' not in plan_text


def test_invalid_utf8_repository_text_fails_with_evidence(tmp_path: Path):
    repo = tmp_path / 'repo'; repo.mkdir(); make_repo(repo)
    (repo / 'README.txt').write_bytes(b'Demo v1.0.0\n\xff')
    regenerate_manifest(repo)
    base = tmp_path / 'base.zip'; deterministic_zip(repo, base)
    pp = tmp_path / 'plan.json'; plan(pp, sha256_file(base))
    out = tmp_path / 'out'

    try:
        build_candidate(base, pp, out)
    except RRSError as exc:
        assert 'Execution failed during inventory_baseline' in str(exc)
    else:
        raise AssertionError('expected UTF-8 decoding failure')

    assert (out / 'probe_evidence.zip').exists()
    assert (out / 'rrs_workspace').exists()
