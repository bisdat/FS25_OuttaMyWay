from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_regulation_control_owns_production_speed_execution():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"RegulationControl.lua").read_text(encoding="utf-8")
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
    assert "FOLLOWER_BOUNDARY=true" in control
    assert "ACTION_SPACE_REGULATION=true" in control
    assert "D0141_FOLLOWER_BOUNDARY" not in control
    assert "D0146_ACTION_SPACE_CONSERVATION" not in control
    assert not (ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").exists()
    assert "Prototype22CapabilityGate" not in main

    assert "regulationControl=nil" in dispatcher
    assert "function Dispatcher:setRegulationControl" in dispatcher
    assert "local control=self.regulationControl" in dispatcher
    assert "function Runtime:setRegulationControl" in runtime
    assert "setLiveControlCapability" not in runtime

def test_regulation_control_reuses_mechanics_without_owning_policy():
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
        "FORWARD_INTERSECTION_REGULATION_SPEED_KMH",
    ):
        assert forbidden not in control


def test_production_regulation_vocabulary_and_observation_are_wired():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    authority=(ROOT/"scripts"/"authority"/"RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    coordinator=(ROOT/"scripts"/"runtime"/"LiveRuntimeCoordinator.lua").read_text(encoding="utf-8")
    manoeuvre=(ROOT/"scripts"/"observation"/"NativeManoeuvreObservationSource.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"RegulationControl.lua").read_text(encoding="utf-8")

    assert "P22_REGULATION_LEASE" not in authority
    assert "P22_REGULATION_LEASE" not in control
    assert 'kind="REGULATION_LEASE"' in authority
    assert "setRegulationControl" in authority

    assert "setRegulationControlObservationSource" in manoeuvre
    assert "regulationControlObservationSource" in manoeuvre
    assert "setCapabilityObservationSource" not in manoeuvre
    assert "getRegulationControlObservation" in dispatcher
    assert "getRegulationControlObservation" in coordinator
    assert "appendRegulationControlObservation" in coordinator
    assert "OuttaMyWay.nativeManoeuvreObservationSource:setRegulationControlObservationSource(OuttaMyWay.regulationControl)" in main


def test_p22_is_retired_after_capability_graduation():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    prototype22=ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua"

    assert not prototype22.exists()
    assert "scripts/prototypes/Prototype22CapabilityGate.lua" not in main
    assert "prototype22CapabilityGate" not in main
    assert "PROTOTYPE_22_" not in config
    assert "addModEventListener(OuttaMyWay.regulationControl)" in main
    assert "addModEventListener(OuttaMyWay.cooperativePassageControl)" in main

def test_candidate_support_uses_production_regulation_lease_vocabulary():
    candidate=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    assert "P22_REGULATION_LEASE" not in candidate
    assert 'leaseKind="REGULATION_LEASE"' in candidate
    assert "The production Regulation lease can express the Bounded-Authority-owned Resolution-Space Progression Envelope" in candidate
