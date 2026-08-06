from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / "scripts" / "archive" / "v4_6_78"


def test_active_loader_never_sources_archive_or_legacy_core():
    text = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    assert "scripts/archive/" not in text
    for forbidden in ("scripts/core/", "scripts/control/", "scripts/decision/", "scripts/observer/"):
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

def test_no_decision_or_control_implementation_added():
    assert not (ROOT / "scripts" / "decision").exists()
    assert not (ROOT / "scripts" / "control").exists()
    active_text = "\n".join(p.read_text(encoding="utf-8") for p in (ROOT / "scripts").rglob("*.lua") if "archive" not in p.parts)
    assert "DecisionSelector" not in active_text
    assert "ControlAdmission" not in active_text
