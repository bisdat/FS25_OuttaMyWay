from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative: str) -> str:
    return (ROOT / relative).read_text(encoding="utf-8")


def test_corner_engagement_preserves_only_incumbent_forward_intersection_regulation():
    source = read("scripts/assessment/CurrentResponsibilityAssessment.lua")
    assert 'admissionKind~="FORWARD_INTERSECTION"' in source
    assert 'progressActuationOwnership' in source
    assert 'cornerKnowledge.engagements' in source
    assert 'protectedPairAssemblyId' in source
    assert 'CORNER_ENGAGEMENT_PRESERVES_INCUMBENT_FORWARD_INTERSECTION_ALLOCATION' in source
    assert source.index('local cornerProtection=self:cornerEngagementProtection(current,relation)') < source.index('if relation.relationshipStatus=="NEGATIVE" then')


def test_corner_context_is_current_situation_composition_not_transition_state():
    adapter = read("scripts/assessment/CurrentResponsibilityContextSituationAssessment.lua")
    main = read("scripts/main.lua")
    transition = read("scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua")
    assert 'captureOperationalPicture(picture)' in adapter
    assert 'CurrentResponsibilityContextSituationAssessment.new' in main
    assert 'cornerKnowledge' not in transition
    assert 'CORNER_ENGAGEMENT' not in transition


def test_087_identity_is_coherent():
    config = read("scripts/config.lua")
    mod_desc = read("modDesc.xml")
    assert 'OuttaMyWay.VERSION = "0.3.0.87"' in config
    assert '<version value="0.3.0.87">0.3.0.87</version>' in mod_desc
