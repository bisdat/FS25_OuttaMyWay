import json, tempfile, zipfile
from pathlib import Path
import sys
for parent in Path(__file__).resolve().parents:
    if (parent / 'rrs' / 'rrs.py').exists():
        sys.path.insert(0, str(parent))
        break
from rrs.rrs import build_candidate, RRSError, deterministic_zip, sha256_file


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
