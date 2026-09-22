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
    assert 'FORWARD_INTERSECTION_REGULATION_SPEED_KMH' not in config
    assert "FORWARD_INTERSECTION_TIMEOUT" not in config
    assert "FORWARD_INTERSECTION_TIMEOUT" not in assessment


def test_situation_owns_fixed_creep_and_authority_requires_candidate_evidence():
    spatial = (ROOT / "scripts/assessment/SpatialConstraintAssessment.lua").read_text()
    candidate = (ROOT / "scripts/candidates/LiveTrafficCandidateSupport.lua").read_text()
    authority = (ROOT / "scripts/authority/RegulationBoundedAuthority.lua").read_text()
    assert "local FORWARD_INTERSECTION_INTENT_REVELATION_CREEP_KMH = 1" in spatial
    assert "r.regulationSpeedKmh=FORWARD_INTERSECTION_INTENT_REVELATION_CREEP_KMH" in spatial
    assert "fixedRegulationSpeedKmh=r.regulationSpeedKmh" in spatial
    assert "fixedRegulationSpeedKmh=action.fixedRegulationSpeedKmh" in candidate
    assert candidate.count("fixedRegulationSpeedKmh") == 2
    assert "local magnitude=bridge.fixedRegulationSpeedKmh" in authority
    assert 'if type(magnitude)~="number" or magnitude~=magnitude or magnitude<=0 or magnitude==math.huge then return nil end' in authority
    assert 'local fixedCornerRightOfWay=bridge.admissionKind=="CORNER_RIGHT_OF_WAY"' in authority
    assert "if fixedForwardIntersection or fixedCornerRightOfWay then" in authority
    assert "initialCap=bridge.fixedRegulationSpeedKmh" in authority
    assert "initialCap=tonumber(envelope.capKmh) or 0" in authority
    for path in (ROOT / "scripts").rglob("*.lua"):
        assert "FORWARD_INTERSECTION_REGULATION_SPEED_KMH" not in path.read_text(), path
    assert "FORWARD_INTERSECTION_TIMEOUT" not in authority


def test_corner_engagement_precedes_narrow_fi_dissolution_for_incumbent_allocation():
    assessment = (ROOT / "scripts/assessment/CurrentResponsibilityAssessment.lua").read_text(encoding="utf-8")
    adapter = (ROOT / "scripts/assessment/CurrentResponsibilityContextSituationAssessment.lua").read_text(encoding="utf-8")
    main = (ROOT / "scripts/main.lua").read_text(encoding="utf-8")
    transition = (ROOT / "scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua").read_text(encoding="utf-8")

    assert 'current.provenance.admissionKind~="FORWARD_INTERSECTION"' in assessment
    assert 'progressActuationOwnership' in assessment
    assert 'cornerKnowledge.engagements' in assessment
    assert 'protectedPairAssemblyId' in assessment
    assert 'CORNER_ENGAGEMENT_PRESERVES_INCUMBENT_FORWARD_INTERSECTION_ALLOCATION' in assessment
    assert assessment.index('local cornerProtection=self:cornerEngagementProtection(current,relation)') < assessment.index('if relation.relationshipStatus=="NEGATIVE" then')
    assert 'captureOperationalPicture(picture)' in adapter
    assert 'CurrentResponsibilityContextSituationAssessment.new' in main
    assert 'cornerKnowledge' not in transition
    assert 'CORNER_ENGAGEMENT' not in transition


def test_corner_engagement_does_not_create_new_timeout_or_regulation_type():
    assessment = (ROOT / "scripts/assessment/CurrentResponsibilityAssessment.lua").read_text(encoding="utf-8")
    config = (ROOT / "scripts/config.lua").read_text(encoding="utf-8")
    regulation = (ROOT / "scripts/contracts/Regulation.lua").read_text(encoding="utf-8")

    assert "CORNER_TIMEOUT" not in assessment
    assert "CORNER_TIMEOUT" not in config
    assert 'kind~="REGULATION"' in regulation
    assert "CORNER_REGULATION" not in regulation


def test_forward_intersection_uses_native_progress_opportunity_not_realised_speed():
    spatial = (ROOT / "scripts" / "assessment" / "SpatialConstraintAssessment.lua").read_text(encoding="utf-8")

    assert "local function nativeProgressOpportunity(motion)" in spatial
    assert 'motion.nativeFieldWork and motion.nativeFieldWork.nativeDriveCommand' in spatial
    assert '"GIANTS_IMMEDIATE_NATIVE_MAX_SPEED"' in spatial
    assert "result.progressRateMps,result.progressRateSource=nativeProgressOpportunity(motion)" in spatial
    assert "POSITION_DERIVED_PROGRESS_RATE" not in spatial
    assert "GIANTS_REPORTED_PROGRESS_RATE" not in spatial


def test_bounded_authority_honours_corner_protection_before_fi_role_migration():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")

    assert "forwardIntersectionCornerProtectionRetainsCurrentSubject" in authority
    guard = 'if forwardIntersectionCornerProtectionRetainsCurrentSubject(lease,bridge,semanticAssessment) then'
    migration = 'applicationContext="ROLE_MIGRATION"'
    assert guard in authority
    assert authority.index(guard) < authority.index(migration)
    assert '"CORNER_ENGAGEMENT_PRESERVES_INCUMBENT_FORWARD_INTERSECTION_ALLOCATION"' in authority


def test_forward_intersection_never_physically_regulates_current_corner_incumbent():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")

    assert "local function currentCornerIncumbency(picture,assemblyId)" in authority
    assert 'engagement.cornerIncumbent==true' in authority
    assert authority.count('"CATEGORY_1_CORNER_INCUMBENT_REQUIRES_NATIVE_EVACUATION"') >= 4
    assert 'lease.ownerTag or ACTION_SPACE_REGULATION_OWNER_TAG' in authority
    assert 'local fixedForward=bridge.admissionKind=="FORWARD_INTERSECTION"' in authority
    assert 'lease.fixedForwardIntersection=fixedForward' in authority
    assert 'fixed and "INTENT_REVELATION_CREEP" or envelope.effectClass' in authority
