from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_confirmed_passage_outside_entry_readiness_becomes_regulation_not_passage():
    support = text("scripts/candidates/LiveTrafficCandidateSupport.lua")
    assert "local PASSAGE_APPROACH_SPEED_CEILING_KMH = 10.0" in support
    assert 'action.admissionKind=="PASSAGE_APPROACH"' in support
    guard = "if not (plan.passageEntry and plan.passageEntry.ready==true) then"
    regulation = "return publishActionSpaceRegulationPicture(self,picture,snapshot,approachItem)"
    passage = "local specification=makeCooperativePassageCandidate(pictureId,values,plan,governingRequirementKey)"
    assert guard in support and regulation in support and passage in support
    assert support.index(guard) < support.index(regulation) < support.index(passage)
    assert "PASSAGE_APPROACH_REGULATION_SUPPORTED" in support


def test_passage_approach_regulation_composes_pairwise_ten_kmh_ceiling():
    support = text("scripts/candidates/LiveTrafficCandidateSupport.lua")
    authority = text("scripts/authority/RegulationBoundedAuthority.lua")
    assert 'fixedRegulationSpeedKmh=PASSAGE_APPROACH_SPEED_CEILING_KMH' in support
    assert 'authorityRole="SUPPORTING_SPEED_CEILING"' in support
    assert 'effectClass="SPEED_LIMIT"' in support
    assert 'local PASSAGE_APPROACH_REGULATION_OWNER_TAG="PASSAGE_APPROACH_REGULATION"' in authority
    assert 'local PASSAGE_APPROACH_SUPPORTING_OWNER_TAG="PASSAGE_APPROACH_SPEED_CEILING"' in authority
    assert "function Authority:_supportingSpeedCeilingRequest" in authority
    assert "fixedPassageApproach=bridge.admissionKind==\"PASSAGE_APPROACH\"" in authority
    assert "PASSAGE_APPROACH_REGULATION_APPLIED" in authority
    assert 'effectClass="PAIRWISE_SPEED_CEILING"' in authority


def test_passage_approach_regulation_is_fixed_until_capture_succession_not_elastic_envelope():
    authority = text("scripts/authority/RegulationBoundedAuthority.lua")
    block = authority.split("function Authority:_updateActionSpaceRegulationEnvelope", 1)[1].split("\nfunction Authority:", 1)[0]
    assert 'if lease.admissionKind=="PASSAGE_APPROACH" then' in block
    assert "PASSAGE_APPROACH_PAIRWISE_SPEED_CEILING_REMAINS_ACTIVE" in block
    assert block.index('if lease.admissionKind=="PASSAGE_APPROACH" then') < block.index("ResolutionSpaceProgressionEnvelope.update")


def test_passage_approach_pairwise_secondary_lease_is_cleaned_up_with_regulation():
    authority = text("scripts/authority/RegulationBoundedAuthority.lua")
    neutralize = authority.split("function Authority:neutralizeActionSpaceRegulationPhysical", 1)[1].split("\nlocal function actionSpaceRegulationToken", 1)[0]
    assert "lease.supportingReferenceKey" in neutralize
    assert "PASSAGE_APPROACH_SUPPORTING_OWNER_TAG" in neutralize
    assert "lease.supportingBoundedAuthorityId" in neutralize


def test_passage_successor_handoff_ceiling_remains_subordinate_to_regulation_stage():
    main = text("scripts/main.lua")
    ceiling = text("scripts/authority/PassageApproachSpeedCeiling.lua")
    transition = text("scripts/responsibility/CooperativePassageResponsibilityTransition.lua")
    dispatcher = text("scripts/control/LiveControlDispatcher.lua")
    assert '"scripts/authority/PassageApproachSpeedCeiling.lua"' in main
    assert 'local APPROACH_SPEED_CEILING_KMH=10.0' in ceiling
    assert "prepareAtBubbleFormation(candidate,applied)" in transition
    activate = "approach:activatePrepared(requestA.commitmentId,requestA,candidate)"
    execute = "control:executeJointRequests(requestA,requestB,candidate)"
    assert dispatcher.index(activate) < dispatcher.index(execute)


def test_capture_hold_supersedes_successor_handoff_ceiling_after_both_holds():
    passage = text("scripts/control/CooperativePassageControl.lua")
    block = passage.split("function Control:_beginPassageSettling(run,reason)", 1)[1].split("\nfunction Control:", 1)[0]
    hold = 'self.holdMechanism:setHold(participant.vehicle,"COOPERATIVE-PASSAGE")'
    release = 'approachCeiling:releaseForCommitment(run.commitmentId,"PASSAGE_CAPTURE_HOLD_SUPERSEDES_APPROACH_CEILING")'
    settling = 'self:_setPhase(run,"SETTLING",g_time or 0)'
    assert block.index(hold) < block.index(release) < block.index(settling)


def test_specs_separate_passage_approach_regulation_from_passage_resolution():
    regulation = text("spec/REGULATION.md")
    passage = text("spec/COOPERATIVE_PASSAGE.md")
    architecture = text("architecture/SPATIAL_NEGOTIATION_MODEL.md")
    for content in (regulation, passage, architecture):
        assert "Passage Approach Regulation" in content
        assert "Confirmed Passage != Immediate Passage Responsibility" in content
        assert "Passage Approach Regulation != Passage Resolution" in content
    assert "**10 km/h per participant**" in passage
    assert "common **8 km/h** Cooperative Passage actuation speed" in passage
