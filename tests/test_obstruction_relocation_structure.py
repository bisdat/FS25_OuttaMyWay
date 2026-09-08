from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_phase13_obstruction_relocation_is_explicitly_loaded_and_current_physical_only():
    main = read("scripts/main.lua")
    pose = read("scripts/observation/CurrentPhysicalPoseSource.lua")
    source = read("scripts/observation/LiveObservationSource.lua")

    for relative in (
        "scripts/observation/CurrentPhysicalPoseSource.lua",
        "scripts/candidates/ObstructionRelocationCandidateSupport.lua",
        "scripts/commitment/ObstructionRelocationCommitmentLifecycle.lua",
        "scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua",
        "scripts/control/ObstructionRelocationControl.lua",
        "scripts/runtime/Runtime.lua",
    ):
        assert relative in main

    assert 'source.kind=="CURRENT_MISSION_PHYSICAL_ASSEMBLY_FIELD_WITNESS"' in pose
    assert "getCurrentPhysicalObject(referenceKey)" in pose
    assert 'negativeClearanceAuthority=false' in pose
    assert 'semanticAuthority=false' in pose
    assert 'historicalJobProvenanceRequired=false' in pose
    assert "currentPhysicalPoseSource:observe" in source


def test_phase13_obstruction_relocation_identity_aggregates_pairwise_cause_by_operation_and_blocker():
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")

    assert 'local key="obstruction-relocation:"..operationId..":"..blockerId' in candidate
    assert 'blockerClassification~="NON_ACTIVE_UNCLAIMED"' in candidate
    assert 'relation.relocationEligible~=true' in candidate
    assert 'beneficiarySet' in candidate
    assert 'responsibilityKey=group.relocationKey' in candidate
    assert 'blockerAssemblyId=group.blockerAssemblyId' in candidate
    assert "terminalEpisodeId" not in candidate
    assert "nativeBlocked" not in candidate
    assert "blocked==true" not in candidate


def test_phase13_obstruction_relocation_uses_truthful_authority_class_not_post_job_semantics():
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    registry = read("scripts/authority/AuthorityRegistry.lua")
    boundary = read("scripts/commitment/DecisionCommitmentBoundary.lua")
    admission = read("scripts/commitment/CommitmentAdmission.lua")
    composition = read("scripts/authority/EffectiveActuationComposition.lua")

    assert "OBSTRUCTION_RELOCATION_ACTUATION" in candidate
    assert "OBSTRUCTION_RELOCATION_ACTUATION" in registry
    assert "OBSTRUCTION_RELOCATION_ACTUATION" in composition
    assert "obstructionRelocationActuationOwnership" in boundary
    assert "obstructionRelocationAssemblyIds" in admission
    assert "acquireObstructionRelocation" in admission

    assert "postJobActuationOwnership" not in candidate
    assert "POST_JOB_ACTUATION" not in candidate
    assert 'obstructionRelocationActuationOwnership={assemblyIds={group.blockerAssemblyId}}' in candidate
    assert 'obstructionRelocationActuation=true' in candidate
    assert "composition cannot assign multiple actuation authority classes to one assembly" in composition
    assert "one assembly cannot simultaneously own multiple actuation classes" in boundary


def test_phase13_cold_relocation_withholds_second_courtesy_without_negative_clearance_authority():
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    control = read("scripts/control/ObstructionRelocationControl.lua")
    terminal = read("scripts/candidates/TerminalEgressCandidateSupport.lua")

    assert 'courtesyStage=1' in candidate
    assert 'secondCourtesyNotAuthorised=true' in candidate
    assert 'secondCourtesyWithheldByEvidence=true' in candidate
    assert 'NEGATIVE_TRANSITION_CLEARANCE_NOT_AVAILABLE' in candidate
    assert 'NO_NEGATIVE_CLEARANCE_AUTHORITY' in candidate
    assert 'tonumber(objective.courtesyStage)~=1' in control

    # Warm D-0147 remains the separate validated two-courtesy donor path.
    assert 'TERMINAL_FINAL_BOUNDARY_SETTLEMENT' in terminal
    assert 'maximumCourtesyMovesPerEpisode=2' in terminal


def test_phase13_manoeuvre_completion_does_not_semantically_resolve_without_supported_continuation():
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    runtime = read("scripts/runtime/Runtime.lua")

    assert "productiveContinuationKnowledge" in candidate
    assert "productive.productivePositive==true" in candidate
    assert 'productive.representationFitness=="FIT_FOR_LIMITED_HORIZON"' in candidate
    assert "relationFor(picture,blockerAssemblyId,beneficiaryId)~=nil" in candidate
    assert 'outcome.status~="MANOEUVRE_COMPLETE"' in candidate
    assert 'terminalSpec(context,"OBJECTIVE_SATISFIED"' in candidate
    assert "semanticResolutionNotInferred=true" in runtime
    assert "freshSituationRequired=true" in runtime


def test_phase13_obstruction_control_is_addressed_from_current_reality_and_fails_closed_on_owned_cleanup():
    control = read("scripts/control/ObstructionRelocationControl.lua")
    dispatcher = read("scripts/control/LiveControlDispatcher.lua")
    coordinator = read("scripts/runtime/LiveRuntimeCoordinator.lua")

    assert "getCurrentPhysicalObject(referenceKey)" in control
    assert "isPlayerClaimed(vehicle)" in control
    assert "isSourceReactivated(vehicle)" in control
    assert "acquireVehicleActivityContext" in control
    assert "driveInWorldDirection" in control
    assert "neutralize(vehicle" in control
    assert "releaseVehicleActivityContext" in control
    assert 'finalStatus="FAILED"' in control
    assert 'reason="OWNED_ACTUATION_CLEANUP_FAILED"' in control
    assert 'semanticResolutionNotInferred=true' in control

    assert "setObstructionRelocationControl" in dispatcher
    assert 'target.kind=="CAUSAL_OBSTRUCTION_RELOCATION"' in dispatcher
    assert "getObstructionRelocationObservation" in dispatcher
    assert "appendObstructionRelocationObservation" in coordinator
    assert "getObstructionRelocationObservation" in coordinator


def test_phase13_generic_path_preserves_warm_d0147_and_does_not_inherit_native_blocked_gate():
    generic = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    terminal_assessment = read("scripts/assessment/TerminalOccupancyAssessment.lua")
    terminal_candidate = read("scripts/candidates/TerminalEgressCandidateSupport.lua")
    terminal_control = read("scripts/control/TerminalEgressControl.lua")

    assert "aiState.blocked==true" not in generic
    assert "terminalEpisodeId" not in generic
    assert "aiState.blocked==true" in terminal_assessment
    assert "TERMINAL_OCCUPANCY" in terminal_candidate
    assert "POST_JOB_ACTUATION" in terminal_control


def test_phase13_test_identity_is_coherent():
    config = read("scripts/config.lua")
    moddesc = read("modDesc.xml")
    main = read("scripts/main.lua")

    assert 'OuttaMyWay.VERSION = "0.3.0.28"' in config
    assert 'OuttaMyWay.BUILD_LABEL = "0.3.0.28 TEST — FOLLOWER HUD GLYPH COMPATIBILITY"' in config
    assert '<version value="0.3.0.28">0.3.0.28</version>' in moddesc
    assert "v0.3.0.28 TEST — FOLLOWER HUD GLYPH COMPATIBILITY" in main
