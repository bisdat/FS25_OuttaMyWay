from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_passage_approach_ceiling_module_is_loaded_before_passage_transition_and_runtime():
    main = text("scripts/main.lua")
    ceiling = '"scripts/authority/PassageApproachSpeedCeiling.lua"'
    transition = '"scripts/responsibility/CooperativePassageResponsibilityTransition.lua"'
    runtime = '"scripts/runtime/Runtime.lua"'
    assert ceiling in main
    assert main.index(ceiling) < main.index(transition) < main.index(runtime)


def test_passage_transition_prepares_and_dispatcher_activates_ceiling_before_joint_control():
    transition = text("scripts/responsibility/CooperativePassageResponsibilityTransition.lua")
    dispatcher = text("scripts/control/LiveControlDispatcher.lua")
    assert "prepareAtBubbleFormation(candidate,applied)" in transition
    activate = "approach:activatePrepared(requestA.commitmentId,requestA,candidate)"
    execute = "control:executeJointRequests(requestA,requestB,candidate)"
    assert activate in dispatcher and execute in dispatcher
    assert dispatcher.index(activate) < dispatcher.index(execute)


def test_passage_approach_ceiling_is_fixed_ten_kmh_supporting_authority():
    ceiling = text("scripts/authority/PassageApproachSpeedCeiling.lua")
    assert 'local OWNER_TAG="PASSAGE_APPROACH_SPEED_CEILING"' in ceiling
    assert 'local AUTHORITY_ROLE="SUPPORTING_SPEED_CEILING"' in ceiling
    assert "local APPROACH_SPEED_CEILING_KMH=10.0" in ceiling
    assert "self.runtime.boundedAuthority:authorize" in ceiling
    assert "supportingSpeedCeilingComposition" in ceiling
    assert 'capability="REGULATE_SPEED"' in ceiling
    assert 'effectClass="SPEED_LIMIT"' in ceiling


def test_capture_hold_supersedes_ceiling_only_after_both_holds_are_established():
    passage = text("scripts/control/CooperativePassageControl.lua")
    block = passage.split("function Control:_beginPassageSettling(run,reason)", 1)[1].split("\nfunction Control:", 1)[0]
    hold = 'self.holdMechanism:setHold(participant.vehicle,"COOPERATIVE-PASSAGE")'
    release = 'approachCeiling:releaseForCommitment(run.commitmentId,"PASSAGE_CAPTURE_HOLD_SUPERSEDES_APPROACH_CEILING")'
    settling = 'self:_setPhase(run,"SETTLING",g_time or 0)'
    assert block.index(hold) < block.index(release) < block.index(settling)


def test_passage_spec_declares_ten_kmh_approach_and_preserves_eight_kmh_actuation():
    spec = text("spec/COOPERATIVE_PASSAGE.md")
    assert "Passage Approach Speed Ceiling" in spec
    assert "**10 km/h per participant**" in spec
    assert "common **8 km/h** Cooperative Passage actuation speed" in spec
    assert "Passage Approach Responsibility != Unrestricted Native Reset" in spec
