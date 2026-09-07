from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_phase14_1_regulation_control_owns_production_speed_execution():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"RegulationControl.lua").read_text(encoding="utf-8")
    p22=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")

    assert "scripts/control/RegulationControl.lua" in main
    assert "OuttaMyWay.RegulationControl" in control
    assert "function Control:executeControlRequest" in control
    assert "function Control:clearRegulationLeaseByReference" in control
    assert "function Control:getVehicleControlObservation" in control
    assert 'target.kind~="REGULATION_LEASE"' in control
    assert "boundedAuthority:validateRequest(request)" in control
    assert "boundedAuthorityRequiredOwnerTags" in control

    for production_method in (
        "function Probe:getVehicleControlObservation",
        "function Probe:getVehicleControlObservationByReference",
        "function Probe:executeControlRequest",
        "function Probe:clearRegulationLeaseByReference",
    ):
        assert production_method not in p22

    assert "regulationControl=nil" in dispatcher
    assert "function Dispatcher:setRegulationControl" in dispatcher
    assert "local control=self.regulationControl" in dispatcher
    assert "function Runtime:setRegulationControl" in runtime
    assert "setLiveControlCapability" not in runtime


def test_phase14_1_regulation_control_reuses_mechanics_without_owning_policy():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"RegulationControl.lua").read_text(encoding="utf-8")
    drive=(ROOT/"scripts"/"control"/"mechanisms"/"NativeDriveMechanism.lua").read_text(encoding="utf-8")
    passage=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")

    assert "NativeDriveMechanism.new" not in control
    assert "driveMechanism=driveMechanism" in control
    assert "driveMechanism:setRegulationLease" in control
    assert "driveMechanism:clearRegulationLease" in control
    assert "AIVehicleUtil.driveToPoint" in drive
    assert "OuttaMyWay.RegulationControl.new(OuttaMyWay.runtime,OuttaMyWay.physicalControlMechanisms.driveMechanism)" in main
    assert "OuttaMyWay.CooperativePassageControl.new(OuttaMyWay.runtime,OuttaMyWay.physicalControlMechanisms)" in main
    assert "CooperativePassageControl requires Hold, Drive and Configuration mechanisms" in passage

    for forbidden in (
        "DecisionSelector",
        "CandidateSpace",
        "ControlRequest.new",
        "D0123_NATIVE_HANDOVER_CREEP_KMH",
        "FORWARD_INTERSECTION_REGULATION_SPEED_KMH",
    ):
        assert forbidden not in control


def test_phase14_1_production_regulation_vocabulary_and_observation_are_wired():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    authority=(ROOT/"scripts"/"authority"/"RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    compatibility=(ROOT/"scripts"/"control"/"GuardedRecoveryCompatibility.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    coordinator=(ROOT/"scripts"/"runtime"/"LiveRuntimeCoordinator.lua").read_text(encoding="utf-8")
    manoeuvre=(ROOT/"scripts"/"observation"/"NativeManoeuvreObservationSource.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"RegulationControl.lua").read_text(encoding="utf-8")

    assert "P22_REGULATION_LEASE" not in authority
    assert "P22_REGULATION_LEASE" not in compatibility
    assert "P22_REGULATION_LEASE" not in control
    assert 'kind="REGULATION_LEASE"' in authority
    assert 'kind="REGULATION_LEASE"' in compatibility
    assert "setRegulationControl" in authority
    assert "liveControlDispatcher.regulationControl" in compatibility

    assert "setRegulationControlObservationSource" in manoeuvre
    assert "regulationControlObservationSource" in manoeuvre
    assert "setCapabilityObservationSource" not in manoeuvre
    assert "getRegulationControlObservation" in dispatcher
    assert "getRegulationControlObservation" in coordinator
    assert "appendRegulationControlObservation" in coordinator
    assert "OuttaMyWay.nativeManoeuvreObservationSource:setRegulationControlObservationSource(OuttaMyWay.regulationControl)" in main


def test_phase14_1_p22_remains_manual_harness_and_passage_donor_only():
    p22=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")

    assert 'addConsoleCommand("otmP22"' in p22
    assert "PROTOTYPE_22_CAPABILITY_GATE_ENABLED" in p22
    assert "mechanisms.holdMechanism" in p22
    assert "mechanisms.driveMechanism" in p22
    assert "addModEventListener(OuttaMyWay.prototype22CapabilityGate)" in main
    assert "addModEventListener(OuttaMyWay.regulationControl)" in main

def test_phase14_1_candidate_support_uses_production_regulation_lease_vocabulary():
    candidate=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    assert "P22_REGULATION_LEASE" not in candidate
    assert 'leaseKind="REGULATION_LEASE"' in candidate
    assert "The production Regulation lease can express the Bounded-Authority-owned Resolution-Space Progression Envelope" in candidate
