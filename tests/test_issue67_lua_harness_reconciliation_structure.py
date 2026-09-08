from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_issue67_replacement_core_loader_matches_current_constraint_topology():
    run=read("tests/replacement_core/run.lua")

    retained=(
        "RepresentationFitness.lua",
        "ResponsibilityCompatibility.lua",
        "CommitmentPreconditions.lua",
        "EffectiveActuationComposition.lua",
    )
    for filename in retained:
        assert run.count(f'load("scripts/constraints/evaluators/{filename}")') == 1

    retired=(
        "FieldWorldContainment.lua",
        "TransitionClearance.lua",
        "CapabilityAvailability.lua",
        "ContinuingIntentPriority.lua",
        "ProgressPreservation.lua",
        "ObligationCompatibility.lua",
        "ReleaseSafety.lua",
    )
    for filename in retired:
        assert f'load("scripts/constraints/evaluators/{filename}")' not in run

    current_runtime_dependencies=(
        "scripts/observation/CurrentPhysicalPoseSource.lua",
        "scripts/commitment/ObstructionRelocationCommitmentLifecycle.lua",
        "scripts/candidates/ObstructionRelocationCandidateSupport.lua",
        "scripts/decision/ProspectivePortfolioDecisionPolicy.lua",
        "scripts/candidates/ProspectiveDecisionPortfolioSupport.lua",
        "scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua",
    )
    for relative in current_runtime_dependencies:
        assert run.count(f'load("{relative}")') == 1


def test_issue67_replay_causality_uses_current_constraint_authority():
    replay=read("tests/replay/HistoricalFixtures.lua")

    assert 'local mandatory={"REPRESENTATION_FITNESS","RESPONSIBILITY_COMPATIBILITY","COMMITMENT_PRECONDITIONS","EFFECTIVE_ACTUATION_COMPOSITION"}' in replay

    retired=(
        "FIELD_WORLD_CONTAINMENT",
        "TRANSITION_CLEARANCE",
        "CONTROL_CAPABILITY_AVAILABILITY",
        "CONTINUING_INTENT_PRIORITY",
        "PROGRESS_PRESERVATION",
        "OBLIGATION_COMPATIBILITY",
        "SAFE_RELEASE_HANDOVER",
        "responsibilityException",
    )
    for token in retired:
        assert token not in replay


def test_issue67_focused_obstruction_fixture_has_executable_load_helper():
    focused=read("tests/replacement_core/obstruction_relocation.lua")

    assert "local function load(relativePath) dofile(root .. \"/\" .. relativePath) end" in focused
    assert "local function load(relativePath) do dofile" not in focused


def test_reconciled_lua_workflow_collects_both_outcomes_and_blocks_on_failure():
    workflow=read(".github/workflows/offline-validation.yml")

    assert "name: Lua offline behavioural contracts" in workflow
    assert "id: lua" in workflow
    assert "id: obstruction_relocation" in workflow
    assert workflow.count("continue-on-error: true") == 2
    assert "name: Enforce Lua behavioural contracts" in workflow
    assert 'MAIN_OUTCOME="${{ steps.lua.outcome }}"' in workflow
    assert 'FOCUSED_OUTCOME="${{ steps.obstruction_relocation.outcome }}"' in workflow
    assert 'if [[ "$MAIN_OUTCOME" != "success" || "$FOCUSED_OUTCOME" != "success" ]]; then' in workflow
    assert "any non-success inner outcome fails the enforcement gate" in workflow
    assert "Evidence Collection != CI Enforcement" in " ".join(read("docs/TESTING_METHODOLOGY.md").split())
