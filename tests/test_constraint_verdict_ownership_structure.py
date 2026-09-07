from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_phase13_candidate_cannot_carry_constraint_verdict_authority():
    contract=read("scripts/contracts/CandidateAction.lua")
    space=read("scripts/candidates/CandidateSpace.lua")
    evidence=read("scripts/constraints/ConstraintEvidence.lua")
    assert "constraintEvidence=true" in contract
    assert "forbiddenDownstreamAuthorityFields" in contract
    assert 'key~="constraintEvidence"' in space
    assert "candidatePlanningEvidence" in space
    assert "packet.result" not in space
    assert "packet.applicable" not in space
    assert "fromCandidate" not in evidence

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
    assert "FOLLOWER_OWNS_CLOSURE" in responsibility
    assert "responsibilityException" not in responsibility
    assert "boundedObservationContract" in preconditions
    assert "EffectiveActuationComposition.create" in composition

def test_phase13_constraint_ownership_test_identity_is_coherent():
    config=read("scripts/config.lua")
    main=read("scripts/main.lua")
    moddesc=read("modDesc.xml")
    assert 'OuttaMyWay.VERSION = "0.3.0.18"' in config
    assert 'OuttaMyWay.BUILD_LABEL = "0.3.0.18 TEST — CONSTRAINT VERDICT OWNERSHIP"' in config
    assert 'v0.3.0.18 TEST — CONSTRAINT VERDICT OWNERSHIP' in main
    assert '<version value="0.3.0.18">0.3.0.18</version>' in moddesc
