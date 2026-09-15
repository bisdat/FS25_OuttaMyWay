from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_bubble_runtime_modules_are_loaded_before_runtime_creation():
    main = text("scripts/main.lua")
    bubble = '"scripts/authority/BubbleBulletTime.lua"'
    horizon = '"scripts/candidates/BubbleDecisionHorizonCandidateSupport.lua"'
    transition = '"scripts/responsibility/CooperativePassageResponsibilityTransition.lua"'
    runtime = '"scripts/runtime/Runtime.lua"'
    assert bubble in main
    assert horizon in main
    assert main.index(bubble) < main.index(transition)
    assert main.index(horizon) < main.index(transition)
    assert main.index(transition) < main.index(runtime)


def test_passage_transition_prepares_bubble_before_joint_requests_and_dispatcher_activates_it():
    transition = text("scripts/responsibility/CooperativePassageResponsibilityTransition.lua")
    runtime = text("scripts/runtime/Runtime.lua")
    dispatcher = text("scripts/control/LiveControlDispatcher.lua")
    assert "prepareAtBubbleFormation" in transition
    assert "applied.commitment=self.runtime.commitments:get" in transition
    assert "self:_continueCooperativePassage(picture,evaluated,applied)" in runtime
    assert "activatePrepared(requestA.commitmentId,requestA,candidate)" in dispatcher
    assert dispatcher.index("activatePrepared(requestA.commitmentId,requestA,candidate)") < dispatcher.index("control:executeJointRequests(requestA,requestB,candidate)")


def test_bubble_decision_horizon_uses_passive_support_during_live_passage_leg():
    support = text("scripts/candidates/BubbleDecisionHorizonCandidateSupport.lua")
    assert 'basis.kind=="COOPERATIVE_PASSAGE_LEG"' in support
    assert "return self.passiveSupport:attach(picture,snapshot)" in support
    assert "self.delegate:attach(picture,snapshot)" in support


def test_bubble_regulation_is_fixed_one_kmh_and_bounded_authority_gated():
    bubble = text("scripts/authority/BubbleBulletTime.lua")
    control = text("scripts/control/RegulationControl.lua")
    assert "local INTENT_REVELATION_CREEP_KMH = 1.0" in bubble
    assert 'local OWNER_TAG = "BUBBLE_BULLET_TIME"' in bubble
    assert "self.runtime.boundedAuthority:authorize" in bubble
    assert "BUBBLE_BULLET_TIME=true" in control


def test_live_coordinator_and_bubble_listener_release_owned_protection():
    coordinator = text("scripts/runtime/LiveRuntimeCoordinator.lua")
    main = text("scripts/main.lua")
    bubble = text("scripts/authority/BubbleBulletTime.lua")
    assert "releaseUnsupportedProtection" in coordinator
    assert 'releaseAll("MAP_DELETE")' in coordinator
    assert "addModEventListener(OuttaMyWay.runtime.bubbleBulletTime)" in main
    assert "function BulletTime:update() self:_releaseEndedResolutionProtection() end" in bubble
