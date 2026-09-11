from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_issue87_runtime_cycle_cadence_belongs_to_live_runtime_coordinator():
    config = read("scripts/config.lua")
    coordinator = read("scripts/runtime/LiveRuntimeCoordinator.lua")

    assert "LIVE_RUNTIME_CONTROL_INTERVAL_MS" not in config
    assert "local LIVE_RUNTIME_CONTROL_INTERVAL_MS=250" in coordinator
    assert "local interval=LIVE_RUNTIME_CONTROL_INTERVAL_MS" in coordinator
    assert "OuttaMyWay.LIVE_RUNTIME_CONTROL_INTERVAL_MS" not in coordinator


def test_issue87_passive_diagnostic_throttles_belong_to_validator():
    config = read("scripts/config.lua")
    validator = read("scripts/diagnostics/PassiveLiveValidator.lua")

    assert "PASSIVE_HEARTBEAT_INTERVAL_MS" not in config
    assert "PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE" not in config
    assert "local PASSIVE_HEARTBEAT_INTERVAL_MS=10000" in validator
    assert "local PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE=8" in validator
    assert "OuttaMyWay.PASSIVE_HEARTBEAT_INTERVAL_MS" not in validator
    assert "OuttaMyWay.PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE" not in validator
    assert "function Validator:update(dt) end" in validator


def test_issue87_bounded_observation_horizon_belongs_to_passive_candidate_support():
    config = read("scripts/config.lua")
    candidate = read("scripts/candidates/PassiveLiveCandidateSupport.lua")

    assert "PASSIVE_SAMPLE_INTERVAL_MS" not in config
    assert "PASSIVE_SAMPLE_INTERVAL_MS" not in candidate
    assert "local BOUNDED_OBSERVATION_REASSESSMENT_HORIZON_SECONDS=1.0" in candidate
    assert candidate.count(
        "reassessmentDeadline=snapshot.timestamp+BOUNDED_OBSERVATION_REASSESSMENT_HORIZON_SECONDS"
    ) == 2
    assert "NEXT_PASSIVE_SAMPLE" in candidate
    assert "MATERIAL_TRACE_CHANGE_OR_REASSESSMENT_DEADLINE" in candidate
