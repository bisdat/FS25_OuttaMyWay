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
    assert candidate.count("fixedRegulationSpeedKmh") >= 2
    assert "fixedRegulationSpeedKmh=PASSAGE_APPROACH_SPEED_CEILING_KMH" in candidate
    assert "local magnitude=bridge.fixedRegulationSpeedKmh" in authority
    assert 'if type(magnitude)~="number" or magnitude~=magnitude or magnitude<=0 or magnitude==math.huge then return nil end' in authority
    assert 'local fixedCornerRightOfWay=bridge.admissionKind=="CORNER_RIGHT_OF_WAY"' in authority
    assert 'local fixedSharedCategory2=bridge.admissionKind=="SHARED_CATEGORY_2_DEMAND"' in authority
    assert 'local fixedPassageApproach=bridge.admissionKind=="PASSAGE_APPROACH"' in authority
    assert "local fixed=fixedForwardIntersection or fixedCornerRightOfWay or fixedSharedCategory2 or fixedPassageApproach" in authority
    assert "if fixed then" in authority
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

    assert "currentCornerIncumbency=function(picture,assemblyId)" in authority
    assert 'engagement.cornerIncumbent==true' in authority
    assert authority.count('"CATEGORY_1_CORNER_INCUMBENT_REQUIRES_NATIVE_EVACUATION"') >= 4
    assert 'lease.ownerTag or ACTION_SPACE_REGULATION_OWNER_TAG' in authority
    assert 'local fixedForward=bridge.admissionKind=="FORWARD_INTERSECTION"' in authority
    assert 'lease.fixedForwardIntersection=fixedForward' in authority
    assert 'fixed and "INTENT_REVELATION_CREEP" or envelope.effectClass' in authority


def test_category_1_corner_incumbency_is_generic_regulation_ineligibility():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    policy = (ROOT / "scripts" / "decision" / "TrafficPolicemanDecisionPolicy.lua").read_text(encoding="utf-8")

    assert 'if operation=="APPLY" and currentCornerIncumbency(picture,assemblyId)~=nil then' in authority
    assert '"CATEGORY_1_CORNER_INCUMBENT_REQUIRES_NATIVE_EVACUATION"' in authority
    assert 'currentCornerIncumbency(picture,lease.followerAssemblyId)' in authority
    assert 'currentCornerIncumbency(picture,bridge.followerAssemblyId)' in authority
    assert 'migrationAwayFromCorner' in authority
    assert 'currentCornerIncumbency(picture,bridge.regulatedAssemblyId)' in authority
    assert 'RELOCATION_SERIALIZATION' in authority
    assert 'requiresCornerEvacuation' in policy
    assert 'currentConstrainedCornerOccupancy==true' in policy
    assert '"REGULATE_ONLY_NON_CORNER_OCCUPANT"' in policy
    assert '"BOTH_REGULATED_PARTICIPANTS_REQUIRE_CATEGORY_1_CORNER_EVACUATION"' in policy

def test_issue388_category2_turn_completion_and_responsibility_lease_are_separate():
    boundary = (ROOT / "scripts" / "assessment" / "BoundaryDemandAssessment.lua").read_text(encoding="utf-8")
    candidate = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    current = (ROOT / "scripts" / "assessment" / "CurrentResponsibilityAssessment.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    lifecycle = (ROOT / "scripts" / "commitment" / "LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    spatial = (ROOT / "scripts" / "assessment" / "SpatialConstraintAssessment.lua").read_text(encoding="utf-8")

    assert "local SHARED_CATEGORY_2_RESPONSIBILITY_LEASE_SECONDS=10" in boundary
    assert "protectedBoundaryTurnCompletion" in boundary
    assert 'protectedMotion.localIntentClassification~="TURNING"' in boundary
    assert 'previous.intentClassification~="SETTLED_CONTINUATION"' in boundary
    assert "distanceM>reachM" not in boundary
    assert 'classification="SHARED_CATEGORY_2_DEMAND_DISSOLVED_BY_BOUNDARY_TURN"' in boundary
    assert 'reason="PROTECTED_PARTICIPANT_BEGAN_NATIVE_BOUNDARY_TURN"' in boundary

    assert "regulationAdmissionTimestamp" in candidate
    assert "snapshot.timestamp" in candidate
    assert "protectedNativeTimeToBoundarySecAtAdmission" not in candidate
    assert "SHARED_CATEGORY_2_ORDERING_PRESERVED_UNTIL_BOUNDARY_TURN_OR_RESPONSIBILITY_LEASE_EXPIRY" in candidate

    assert 'classification="SHARED_CATEGORY_2_RESPONSIBILITY_LEASE_EXPIRED"' in boundary
    assert 'currentEvidenceState="FAIL_SAFE_ABANDONMENT"' in boundary
    assert "responsibilityLeaseExpired=true" in boundary
    assert "positiveDissolution=false" in boundary
    assert "SHARED_CATEGORY_2_RESPONSIBILITY_LEASE_EXPIRED" in spatial

    assert "SHARED_CATEGORY_2_BOUNDARY_TURN_POSITIVE_DISSOLUTION" in current
    assert "SHARED_CATEGORY_2_RESPONSIBILITY_LEASE_EXPIRY" in current
    assert "SHARED_CATEGORY_2_BOUNDARY_TURN_POSITIVE_DISSOLUTION" in runtime
    assert "SHARED_CATEGORY_2_RESPONSIBILITY_LEASE_EXPIRY" in runtime
    assert 'responsibilityLeaseExpiry and "OBJECTIVE_FAILED"' in lifecycle
    assert 'settlementMode="BASIS_CESSATION"' in lifecycle
    assert "SHARED_CATEGORY_2_RESPONSIBILITY_LEASE_EXPIRED" in lifecycle

    assert "PROTECTED_PARTICIPANT_REVEALED_NEW_SETTLED_CONTINUATION" not in boundary
    assert "SHARED_CATEGORY_2_INTENT_REVELATION_POSITIVE_DISSOLUTION" not in current
    assert "SHARED_CATEGORY_2_WATCHDOG_FAIL_SAFE" not in spatial
    assert "failSafeAbandonment=category2" not in lifecycle

