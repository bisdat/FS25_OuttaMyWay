from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_forward_intersection_unresolved_evidence_is_waiting_not_dissolution():
    assessment = (ROOT / "scripts" / "assessment" / "CurrentResponsibilityAssessment.lua").read_text(encoding="utf-8")

    assert 'evidenceState="WAITING_FOR_EVIDENCE"' in assessment
    assert 'relation.relationshipStatus=="NEGATIVE"' in assessment
    assert 'terminationEvidenceKind="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION"' in assessment
    assert 'terminationEvidenceKind="FORWARD_INTERSECTION_POSITIVE_SUPERSESSION"' in assessment
    assert 'FORWARD_INTERSECTION_NO_LONGER_POSITIVELY_SUPPORTED' not in assessment


def test_forward_intersection_runtime_requires_positive_terminal_evidence_before_release():
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    lifecycle = (ROOT / "scripts" / "commitment" / "LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")

    assert 'FORWARD_INTERSECTION_TERMINATION_EVIDENCE_REQUIRED' in runtime
    assert 'FORWARD_INTERSECTION_POSITIVE_DISSOLUTION' in runtime
    assert 'FORWARD_INTERSECTION_POSITIVE_SUPERSESSION' in runtime

    assert 'FORWARD_INTERSECTION_SETTLEMENT_REQUIRES_POSITIVE_DISSOLUTION_OR_SUPERSESSION' in lifecycle
    assert 'FORWARD_INTERSECTION_POSITIVELY_DISSOLVED' in lifecycle
    assert 'FORWARD_INTERSECTION_RESPONSIBILITY_POSITIVELY_SUPERSEDED' in lifecycle


def test_forward_intersection_waiting_reuses_existing_fixed_creep_authority_without_new_timeout():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    assessment = (ROOT / "scripts" / "assessment" / "CurrentResponsibilityAssessment.lua").read_text(encoding="utf-8")

    assert 'if lease.admissionKind=="FORWARD_INTERSECTION" then' in authority
    assert 'FORWARD_INTERSECTION_FIXED_CREEP_REMAINS_ACTIVE' in authority
    assert 'OuttaMyWay.FORWARD_INTERSECTION_REGULATION_SPEED_KMH = 1' in config
    assert "FORWARD_INTERSECTION_TIMEOUT" not in config
    assert "FORWARD_INTERSECTION_TIMEOUT" not in assessment
