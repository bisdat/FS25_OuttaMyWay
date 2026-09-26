from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT/relative).read_text(encoding="utf-8")


def test_bootstrap_field_domain_and_giants_control_are_separate_operation_inputs():
    source=read("scripts/observation/LiveObservationSource.lua")
    admission=read("scripts/identity/OperationAdmission.lua")

    assert "bootstrappedFieldDomainMember" in source
    assert "activeJobVehicleMembership" in source
    assert "semanticAuthority=false" in source
    assert "operationMembershipRecognised" not in source
    assert "productiveWorkCommencementWitness" not in source
    assert "productiveWorkCommenced" not in source

    assert "details.bootstrappedFieldDomainMember==true" in admission
    assert "details.activeJobVehicleMembership==true" in admission
    assert "details.fieldWorkerSpecializationPresent==true" in admission
    assert "performingRecognisedFieldWork" not in admission


def test_operation_membership_no_longer_depends_on_productive_commencement_workaround():
    situation=read("scripts/assessment/SituationAssessment.lua")
    trajectory=read("scripts/assessment/TrajectoryConflictAssessment.lua")
    candidates=read("scripts/candidates/LiveTrafficCandidateSupport.lua")

    for text in (situation,trajectory,candidates):
        assert "ACTIVE_JOB_INTENT_REVELATION_PENDING" not in text
        assert "productiveCommencementPending" not in text
        assert "PRE_PRODUCTIVE" not in text


def test_passage_evaluation_readiness_is_pairwise_and_not_a_settled_continuation_gate():
    trajectory=read("scripts/assessment/TrajectoryConflictAssessment.lua")
    assert "positiveSettledContinuation" in trajectory
    assert "record.passageEvaluationReady=aParticipation.operationMember==true" in trajectory
    assert 'record.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT"' in trajectory
    assert "record.cooperativePassageEligible=record.passageEvaluationReady" in trajectory
    assert "and record.subjectSettledContinuation==true" not in trajectory
    assert "and record.otherSettledContinuation==true" not in trajectory


def test_operation_architecture_records_cold_start_invariant():
    architecture=read("architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md")
    operation_spec=read("spec/OPERATION_LIFECYCLE.md")
    situation_spec=read("spec/SITUATION_ASSESSMENT.md")

    assert "**Bootstrap Defines the Operation Domain; GIANTS AI Control Defines Active Operation Membership.**" in architecture
    assert "**Operation Membership != Productive State.**" in architecture
    assert "**Operation Membership Must Be Cold-Start Invariant.**" in architecture
    assert "**Operation Membership != Passage Readiness.**" in architecture

    assert "**Operation Membership Must Be Cold-Start Invariant.**" in operation_spec
    assert "productive commencement witness" not in operation_spec.lower()
    assert "**Operation Membership != Passage Readiness.**" in situation_spec

