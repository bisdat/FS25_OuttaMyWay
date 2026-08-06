from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / "scripts" / "archive" / "v4_6_78"


def test_active_loader_never_sources_archive_or_legacy_core():
    text = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    assert "scripts/archive/" not in text
    for forbidden in ("scripts/core/", "scripts/control/", "scripts/observer/"):
        assert forbidden not in text


def test_archive_contains_exact_declared_legacy_file_set():
    manifest = {}
    for line in (ARCHIVE / "SHA256SUMS.txt").read_text(encoding="utf-8").splitlines():
        digest, rel = line.split(maxsplit=1)
        manifest[rel] = digest
    assert len(manifest) == 48
    for rel, expected in manifest.items():
        path = ARCHIVE / rel
        assert path.is_file()
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected


def test_active_lua_tree_is_small_and_archive_independent():
    active = [p for p in (ROOT / "scripts").rglob("*.lua") if "archive" not in p.parts]
    assert active
    for path in active:
        text = path.read_text(encoding="utf-8")
        assert "archive/v4_6_78" not in text
        assert "TrafficDecisionEngineV2" not in text
        assert "UnilateralSidestepController" not in text
        assert "EncounterController" not in text


def test_runtime_has_no_giants_observation_or_control_hook():
    text = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    forbidden = ("addModEventListener", "driveToPoint", "getCanAIFieldWorkerContinueWork", "AIFieldWorker", "g_currentMission")
    for token in forbidden:
        assert token not in text


def test_observation_identity_modules_are_active_but_not_live_wired():
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    assert "scripts/observation/RuntimeObservationAdapter.lua" in main
    assert "scripts/identity/JobEpisodeAdmission.lua" in main
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    assert "publishObservation" in runtime
    assert "admitJobEpisodes" in runtime
    for token in ("addModEventListener", "updateTick", "g_currentMission", "AIFieldWorker"):
        assert token not in runtime

def test_decision_is_present_but_control_remains_absent():
    assert (ROOT / "scripts" / "decision" / "DecisionSelector.lua").is_file()
    assert not (ROOT / "scripts" / "control").exists()
    active_text = "\n".join(p.read_text(encoding="utf-8") for p in (ROOT / "scripts").rglob("*.lua") if "archive" not in p.parts)
    assert "DecisionSelector" in active_text
    assert "ControlAdmission" not in active_text


def test_operational_picture_modules_are_offline_and_active():
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    for rel in ("scripts/identity/OperationAdmission.lua", "scripts/assessment/RepresentationFitness.lua", "scripts/assessment/SituationAssessment.lua"):
        assert rel in main
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    assert "processSealedObservation" in runtime
    for token in ("addModEventListener", "updateTick", "g_currentMission", "AIFieldWorker", "driveToPoint"):
        assert token not in runtime


def test_v472_knowledge_boundary_remains_separate_from_v473_decision():
    assert (ROOT / "scripts" / "candidates" / "CandidateSpace.lua").is_file()
    assert (ROOT / "scripts" / "constraints" / "ConstraintEngine.lua").is_file()
    assert (ROOT / "scripts" / "decision" / "DecisionSelector.lua").is_file()
    assert not (ROOT / "scripts" / "control").exists()
    assessment = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    assert "CandidateSpace" not in assessment
    assert "DecisionSelector" not in assessment


def test_situation_assessment_does_not_source_archive():
    text = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    assert "scripts/archive" not in text
    for token in ("TrafficDecisionEngineV2", "EncounterController", "ShadowRefugeCandidateComparison"):
        assert token not in text


def test_v473_decision_modules_are_active_and_offline_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    required=(
        "scripts/candidates/CandidateSpace.lua",
        "scripts/constraints/ConstraintEngine.lua",
        "scripts/decision/DecisionSelector.lua",
        "scripts/contracts/CandidateInventory.lua",
        "scripts/contracts/ConstraintVerdictSet.lua",
    )
    for rel in required:
        assert rel in main
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert "evaluateSealedOperationalPicture" in runtime
    for token in ("addModEventListener","updateTick","g_currentMission","AIFieldWorker","driveToPoint"):
        assert token not in runtime


def test_candidate_generation_cannot_select_or_dispatch():
    text=(ROOT/"scripts"/"candidates"/"CandidateSpace.lua").read_text(encoding="utf-8")
    for token in ("DecisionSelector","selectedCandidateId","ControlRequest","source(","scripts/archive"):
        assert token not in text


def test_decision_selector_has_no_control_or_archive_dependency():
    text=(ROOT/"scripts"/"decision"/"DecisionSelector.lua").read_text(encoding="utf-8")
    for token in ("ControlRequest","ControlAdmission","source(","scripts/archive","g_currentMission"):
        assert token not in text


def test_constraint_engine_declares_all_canonical_mandatory_families():
    active="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts"/"constraints").rglob("*.lua"))
    for constraint in (
        "FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS",
        "CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION",
        "RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS",
        "EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER",
    ):
        assert constraint in active


def test_v473_has_no_control_capability_directory():
    assert not (ROOT/"scripts"/"control").exists()


def test_v474_replay_modules_are_active_and_offline_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    for rel in (
        "scripts/replay/ReplayRunner.lua","scripts/replay/ConformanceAssertions.lua",
        "scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua",
        "scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua",
    ):
        assert rel in main
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert "runReplay" in runtime
    for token in ("addModEventListener","updateTick","g_currentMission","driveToPoint"):
        assert token not in runtime


def test_replay_corpus_names_all_required_historical_families():
    text=(ROOT/"scenarios"/"replay"/"HistoricalFixtures.lua").read_text(encoding="utf-8")
    for token in ("V4649","V4657","V4664","V4670","V4677","TS016","NO-MOD","LOADED-NO-ENCOUNTER"):
        assert token in text


def test_replay_has_no_physical_control_dispatch():
    active="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts").rglob("*.lua") if "archive" not in p.parts)
    for token in ("driveToPoint(","setCruiseControlState(","AIFieldWorker:stopCurrentAIJob", "ControlAdmission"):
        assert token not in active


def test_v474_runtime_mode_and_version():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.4"' in config
    assert 'RUNTIME_MODE = "REPLAY_CONFORMANCE_OFFLINE"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
