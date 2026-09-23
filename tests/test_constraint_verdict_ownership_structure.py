from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_candidate_support_cannot_publish_constraint_verdict_authority():
    contract=read("scripts/contracts/CandidateAction.lua")
    space=read("scripts/candidates/CandidateSpace.lua")
    evidence=read("scripts/constraints/ConstraintEvidence.lua")
    main=read("scripts/main.lua")

    assert "constraintEvidence=true" in contract
    assert "forbiddenDownstreamAuthorityFields" in contract
    assert "evidenceBasis=specification.evidenceBasis" in space
    assert "candidateEvidenceBasis" not in space
    assert "fromCandidate" not in evidence

    sourced = [ROOT / "scripts/main.lua"]
    for relative in __import__("re").findall(r'"(scripts/[^"]+\.lua)"', main):
        sourced.append(ROOT / relative)

    # Candidate Support publishes current support facts directly; it must not
    # manufacture Constraint-shaped verdict packets for CandidateSpace to scrub.
    for path in sourced:
        if path.parent.name == "candidates":
            assert "constraintEvidence" not in path.read_text(encoding="utf-8"), path

    # The retired translation product has no current production responsibility.
    for path in sourced:
        assert "candidatePlanningEvidence" not in path.read_text(encoding="utf-8"), path

def test_phase13_constraint_engine_owns_only_independent_bounded_questions():
    main=read("scripts/main.lua")
    engine=read("scripts/constraints/ConstraintEngine.lua")
    retained={
        "RepresentationFitness.lua":("RepresentationFitnessConstraint","REPRESENTATION_FITNESS"),
        "ResponsibilityCompatibility.lua":("ResponsibilityCompatibilityConstraint","RESPONSIBILITY_COMPATIBILITY"),
        "CommitmentPreconditions.lua":("CommitmentPreconditionsConstraint","COMMITMENT_PRECONDITIONS"),
        "EffectiveActuationComposition.lua":("EffectiveActuationCompositionConstraint","EFFECTIVE_ACTUATION_COMPOSITION"),
    }
    for filename,(evaluator_name,constraint_id) in retained.items():
        assert f"scripts/constraints/evaluators/{filename}" in main
        assert evaluator_name in engine
        assert f'Evaluator.id="{constraint_id}"' in read(f"scripts/constraints/evaluators/{filename}")
    retired=(
        "FieldWorldContainment.lua","TransitionClearance.lua","CapabilityAvailability.lua",
        "ContinuingIntentPriority.lua","ProgressPreservation.lua","ObligationCompatibility.lua","ReleaseSafety.lua",
    )
    for filename in retired:
        assert f"scripts/constraints/evaluators/{filename}" not in main
        assert not (ROOT/"scripts"/"constraints"/"evaluators"/filename).exists()

def test_phase13_retained_evaluators_do_not_relabel_candidate_verdicts():
    responsibility=read("scripts/constraints/evaluators/ResponsibilityCompatibility.lua")
    preconditions=read("scripts/constraints/evaluators/CommitmentPreconditions.lua")
    composition=read("scripts/constraints/evaluators/EffectiveActuationComposition.lua")
    for text in (responsibility,preconditions,composition):
        assert "fromCandidate" not in text
        assert "constraintEvidence" not in text
    assert "FOLLOWER_OWNS_CLOSURE" not in responsibility
    assert "No conflicting responsibility relation applies" in responsibility
    assert "responsibilityException" not in responsibility
    assert "boundedObservationContract" in preconditions
    assert "EffectiveActuationComposition.create" in composition
