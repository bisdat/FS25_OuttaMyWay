from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def text(rel):
    return (ROOT/rel).read_text(encoding="utf-8")

def test_production_mechanisms_are_named_and_placed_truthfully():
    main=text("scripts/main.lua")
    for rel in (
        "scripts/control/mechanisms/FieldWorkHoldMechanism.lua",
        "scripts/control/mechanisms/NativeDriveMechanism.lua",
        "scripts/control/mechanisms/TransitConfigurationMechanism.lua",
    ):
        assert (ROOT/rel).is_file()
        assert rel in main
    for rel in (
        "scripts/prototypes/Prototype22PermissionGate.lua",
        "scripts/prototypes/Prototype22DriveAuthority.lua",
        "scripts/prototypes/Prototype22ConfigurationAuthority.lua",
    ):
        assert not (ROOT/rel).exists()
        assert rel not in main

def test_main_is_production_composition_root_and_p22_is_retired():
    main=text("scripts/main.lua")
    prototype22=ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua"
    assert "OuttaMyWay.physicalControlMechanisms={" in main
    assert "holdMechanism=OuttaMyWay.FieldWorkHoldMechanism.new()" in main
    assert "driveMechanism=OuttaMyWay.NativeDriveMechanism.new()" in main
    assert "configurationMechanism=OuttaMyWay.TransitConfigurationMechanism.new()" in main
    assert "RegulationControl.new(OuttaMyWay.runtime,OuttaMyWay.physicalControlMechanisms.driveMechanism)" in main
    assert "CooperativePassageControl.new(OuttaMyWay.runtime,OuttaMyWay.physicalControlMechanisms)" in main
    assert not prototype22.exists()
    assert "prototype22CapabilityGate" not in main
    assert "Prototype22CapabilityGate" not in main

def test_controls_consume_mechanisms_without_new_semantic_authority():
    passage=text("scripts/control/CooperativePassageControl.lua")
    terminal=text("scripts/control/ObstructionRelocationControl.lua")
    candidate=text("scripts/candidates/LiveTrafficCandidateSupport.lua")
    assert "holdMechanism=mechanisms.holdMechanism" in passage
    assert "driveMechanism=mechanisms.driveMechanism" in passage
    assert "configurationMechanism=mechanisms.configurationMechanism" in passage
    assert "OuttaMyWay.TransitConfigurationMechanism.new()" in terminal
    assert "OuttaMyWay.NonJobActuationMechanism.new()" in terminal
    assert "POST_JOB_ACTUATION" not in terminal
    assert "OBSTRUCTION_RELOCATION_ACTUATION" not in terminal
    assert (ROOT/"scripts"/"control"/"ObstructionRelocationControl.lua").is_file()
    assert not (ROOT/"scripts"/"control"/"TerminalEgressControl.lua").exists()
    assert '{"FieldWorkHoldMechanism","NativeDriveMechanism","TransitConfigurationMechanism"}' in candidate

def test_native_drive_retires_only_uncalled_orientation_residue():
    drive=text("scripts/control/mechanisms/NativeDriveMechanism.lua")
    assert "REPOSITION_ORIENT" not in drive
    assert "setRepositionOrientation" not in drive
    for required in ("setRegulationLease","clearRegulationLease","setReposition","setAxisTravel","getState","clear"):
        assert required in drive

def test_configuration_preserves_passage_and_obstruction_relocation_surfaces():
    config=text("scripts/control/mechanisms/TransitConfigurationMechanism.lua")
    for required in (
        "getEvidence","prepareCompact","prepareCachedTransit","getCachedTransitSettlement",
        "requestCachedTransitRestore","getCachedRestoreSettlement","finishCachedTransitRestore",
    ):
        assert required in config

def test_mechanisms_do_not_gain_semantic_pipeline_ownership():
    combined="\n".join(text(rel) for rel in (
        "scripts/control/mechanisms/FieldWorkHoldMechanism.lua",
        "scripts/control/mechanisms/NativeDriveMechanism.lua",
        "scripts/control/mechanisms/TransitConfigurationMechanism.lua",
    ))
    for forbidden in (
        "CandidateSpace","DecisionSelector","ConstraintEngine","ResponsibilityTransitionAuthority",
        "CommitmentRegistry","BoundedAuthority.new","ControlRequest.new",
    ):
        assert forbidden not in combined
