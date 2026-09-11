from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_phase13_obstruction_relocation_uses_provenance_neutral_current_physical_reference():
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

    assert "currentAssemblyReferences" in pose
    assert 'source.kind=="CURRENT_MISSION_PHYSICAL_ASSEMBLY_FIELD_WITNESS"' not in pose
    assert "getCurrentPhysicalRelocationRepresentation(referenceKey" in pose
    assert "getCurrentPhysicalObject(referenceKey)" in pose
    assert 'negativeClearanceAuthority=false' in pose
    assert 'semanticAuthority=false' in pose
    assert 'historicalJobProvenanceRequired=false' in pose
    assert "currentPhysicalPoseSource:observe" in source
    assert "function Source:getCurrentPhysicalRelocationRepresentation" in source


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


def test_phase13_relocation_is_geometry_bounded_not_count_bounded():
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    assert 'objectiveKind="CAUSAL_OBSTRUCTION_BOUNDED_INWARD_RELOCATION"' in candidate
    assert "maximumRelocationDistanceM" in candidate
    assert "repeatedActuationRequiresFreshPositiveObstruction=true" in candidate
    assert "moveCountBudget=false" in candidate
    assert 'NO_NEGATIVE_CLEARANCE_AUTHORITY' in candidate
    for retired in ("secondCourtesyNotAuthorised","secondCourtesyWithheldByEvidence","CAUSAL_OBSTRUCTION_FIRST_COURTESY","ONE_BOUNDED_COURTESY_THEN_FRESH_REALITY"):
        assert retired not in candidate


def test_phase13_manoeuvre_completion_does_not_semantically_resolve_without_supported_continuation():
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")
    runtime = read("scripts/runtime/Runtime.lua")

    assert "productiveContinuationKnowledge" in candidate
    assert "productive.productivePositive==true" in candidate
    assert 'productive.representationFitness=="FIT_FOR_LIMITED_HORIZON"' in candidate
    assert "retainedPositiveGroup" in candidate
    assert "POSITIVE_CAUSAL_OBSTRUCTION_WITHOUT_MEANINGFUL_INWARD_RELOCATION_SPACE" in candidate
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
    assert 'state.cleanupFailurePolicy=="FAIL_COMPLETION"' in control

    assert "setObstructionRelocationControl" in dispatcher
    assert "setTerminalEgressControl" not in dispatcher
    assert 'target.kind=="OBSTRUCTION_RELOCATION"' in dispatcher
    assert "getObstructionRelocationObservation" in dispatcher
    assert "appendObstructionRelocationObservation" in coordinator
    assert "getObstructionRelocationObservation" in coordinator


def test_issue112_donor_topology_is_retired_after_generic_reality_validation():
    main = read("scripts/main.lua")
    runtime = read("scripts/runtime/Runtime.lua")
    control = read("scripts/control/ObstructionRelocationControl.lua")
    active = "\n".join(
        path.read_text(encoding="utf-8")
        for path in (ROOT / "scripts").rglob("*.lua")
    )
    for relative in (
        "scripts/assessment/TerminalOccupancyAssessment.lua",
        "scripts/candidates/TerminalEgressCandidateSupport.lua",
        "scripts/commitment/TerminalEgressCommitmentLifecycle.lua",
        "scripts/responsibility/CompletedObstructionResponsibilityTransition.lua",
    ):
        assert not (ROOT / relative).exists()
        assert relative not in main
    for stale in (
        "POST_JOB_ACTUATION",
        "postJobActuationOwnership",
        "postJobAssemblyIds",
        "terminalOccupancyKnowledge",
    ):
        assert stale not in active
    for stale in ("terminalEpisodeId", "courtesyStage", "courtesyExhausted", "COURTESY_ALREADY_EXHAUSTED", 'phase=="COMPACT"'):
        assert stale not in control
    assert "obstructionRelocationResponsibilityTransition" in runtime
    assert "OBSTRUCTION_RELOCATION_ACTUATION" in runtime


def test_issue121_ended_job_evidence_resolves_activity_without_creating_provenance_specific_responsibility():
    assessment = read("scripts/assessment/CausalObstructionAssessment.lua")
    observation = read("scripts/observation/LiveObservationSource.lua")
    candidate = read("scripts/candidates/ObstructionRelocationCandidateSupport.lua")

    assert 'elseif episode.status=="ENDED"' in assessment
    assert 'local activeEpisodes,endedEpisodes=jobEpisodesByAssembly(self.jobEpisodes)' in assessment
    assert 'local endedEpisode=endedEpisodes[blockerAssemblyId]' in assessment
    assert 'local nonActiveActivityResolved=endedEpisode~=nil or currentAiInactiveObserved' in assessment
    assert 'endedJobEpisodeMayResolveNonActiveActivity=true' in assessment
    assert 'historicalJobProvenanceRequired=false' in assessment
    assert 'aiState.observedActive==true' in assessment

    assert 'playerEnteredObserved=okEntered' in observation
    assert 'aiActiveObserved=worker.aiActiveObserved==true' in observation

    assert 'state.observedActive==true' in candidate
    assert 'terminalSpec(context,"NEW_AUTHORITATIVE_INTENT"' in candidate
