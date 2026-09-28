from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_passage_cruise_control_is_loaded_and_old_speed_ceiling_authority_is_retired():
    main = text("scripts/main.lua")
    assert '"scripts/control/mechanisms/PassageCruiseControl.lua"' in main
    assert '"scripts/authority/PassageApproachSpeedCeiling.lua"' not in main


def test_passage_cruise_constants_are_bound_before_request_helpers():
    authority = text("scripts/authority/RegulationBoundedAuthority.lua")
    constant = 'local PASSAGE_APPROACH_REGULATION_OWNER_TAG="PASSAGE_APPROACH_REGULATION"'
    helper = "function Authority:_passageCruisePrimaryRequest"
    supporting = "function Authority:_supportingSpeedCeilingRequest"
    assert constant in authority and helper in authority and supporting in authority
    assert authority.index(constant) < authority.index(supporting)
    assert authority.index(constant) < authority.index(helper)


def test_passage_approach_uses_atomic_cruise_pair_dispatch_not_native_drive_regulation_leases():
    authority = text("scripts/authority/RegulationBoundedAuthority.lua")
    dispatcher = text("scripts/control/LiveControlDispatcher.lua")
    control = text("scripts/control/RegulationControl.lua")
    assert 'kind="PASSAGE_CRUISE_CEILING"' in authority
    assert "dispatchPassageCruisePair(request,supportingRequest,candidate)" in authority
    assert "function Dispatcher:dispatchPassageCruisePair" in dispatcher
    assert "function Control:executePassageCruisePair" in control
    assert "self.runtime.passageCruiseControl:acquirePair" in control


def test_passage_cruise_pair_is_fail_safe_and_restores_original_forward_reverse_values():
    cruise = text("scripts/control/mechanisms/PassageCruiseControl.lua")
    assert "appliedForwardKmh=math.min(original.forwardKmh,ceiling)" in cruise
    assert "appliedReverseKmh=math.min(original.reverseKmh,ceiling)" in cruise
    assert "for index=1,appliedCount do" in cruise
    assert "applied.original.forwardKmh,applied.original.reverseKmh" in cruise
    assert "entry.original.forwardKmh,entry.original.reverseKmh" in cruise
    assert "PASSAGE_CRUISE_CEILING_APPLIED" in cruise
    assert "PASSAGE_CRUISE_CEILING_RESTORED" in cruise


def test_regulation_to_passage_handoff_preserves_cruise_and_terminal_passage_restores_it():
    authority = text("scripts/authority/RegulationBoundedAuthority.lua")
    runtime = text("scripts/runtime/Runtime.lua")
    assert 'preserveCruise=reason=="COOPERATIVE_PASSAGE_SUPERSEDES_ACTION_SPACE_REGULATION"' in authority
    assert 'self.passageCruiseControl:releaseForCommitment(result.commitmentId,"COOPERATIVE_PASSAGE_"..tostring(result.status))' in runtime
    assert 'result.status=="SUCCEEDED" or result.status=="FAILED"' in runtime


def test_direct_passage_acquires_same_cruise_ceiling_before_physical_joint_dispatch():
    dispatcher = text("scripts/control/LiveControlDispatcher.lua")
    acquire = "cruise:acquirePair(requestA.commitmentId"
    execute = "control:executeJointRequests(requestA,requestB,candidate)"
    assert acquire in dispatcher and execute in dispatcher
    assert dispatcher.index(acquire) < dispatcher.index(execute)


def test_specs_name_cruise_configuration_boundary_and_full_passage_lifecycle():
    architecture = text("architecture/SPATIAL_NEGOTIATION_MODEL.md")
    spec = text("spec/COOPERATIVE_PASSAGE.md")
    regulation = text("spec/REGULATION.md")
    for content in (architecture, spec):
        assert "GIANTS Cruise Control" in content
        assert "Speed Configuration != Movement Authority" in content
        assert "Passage Speed Envelope Spans Responsibility Transitions" in content
    assert "GIANTS Cruise Control" in regulation
    assert "10 km/h" in regulation
