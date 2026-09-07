from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def text(rel):
    return (ROOT/rel).read_text(encoding="utf-8")

def test_phase14_3_live_interaction_support_is_in_observation_scope():
    main=text("scripts/main.lua")
    assert (ROOT/"scripts/observation/LiveInteractionObservation.lua").is_file()
    assert not (ROOT/"scripts/diagnostics/LiveInteractionDiagnostics.lua").exists()
    assert "scripts/observation/LiveInteractionObservation.lua" in main
    assert "scripts/diagnostics/LiveInteractionDiagnostics.lua" not in main

def test_phase14_3_module_owns_only_bounded_live_observation_calculation():
    observation=text("scripts/observation/LiveInteractionObservation.lua")
    assert "OuttaMyWay.LiveInteractionObservation = {}" in observation
    for fn in ("pairReferenceKey","deriveMotion","observePairState"):
        assert f"function Observation.{fn}" in observation
    for forbidden in (
        "DecisionSelector","CandidateSpace","ConstraintEngine",
        "ResponsibilityTransition","BoundedAuthority","ControlRequest",
        "driveToPoint","getCanAIFieldWorkerContinueWork","addModEventListener",
    ):
        assert forbidden not in observation

def test_phase14_3_live_source_consumes_observation_not_diagnostic_authority():
    source=text("scripts/observation/LiveObservationSource.lua")
    assert "OuttaMyWay.LiveInteractionObservation.observePairState" in source
    assert "OuttaMyWay.LiveInteractionObservation.deriveMotion" in source
    assert "OuttaMyWay.LiveInteractionObservation.pairReferenceKey" in source
    assert "OuttaMyWay.LiveInteractionDiagnostics" not in source

def test_phase14_3_raw_observation_evidence_and_diagnostic_projection_remain_distinct():
    source=text("scripts/observation/LiveObservationSource.lua")
    adapter=text("scripts/observation/RuntimeObservationAdapter.lua")
    for token in (
        "raw.geometry.futureSpaceRelationshipEvidence",
        "raw.geometry.interactionEvidence",
        "motion=worker.motionDiagnostic",
        "raw.diagnostics.pairDiagnostics",
    ):
        assert token in source
    assert "geometry=shallowCopy(raw.geometry)" in adapter
    assert "motion=shallowCopy(raw.motion)" in adapter
    assert "diagnostics=shallowCopy(raw.diagnostics)" in adapter

def test_phase14_3_pair_key_remains_correlation_not_identity_authority():
    observation=text("scripts/observation/LiveInteractionObservation.lua")
    assert 'return "live-pair:" .. first .. ":" .. second' in observation
    for forbidden in ("IdentityRegistry","identities:resolve","identities:issue"):
        assert forbidden not in observation

def test_phase14_3_current_build_identity_is_023():
    config=text("scripts/config.lua")
    main=text("scripts/main.lua")
    moddesc=text("modDesc.xml")
    assert 'OuttaMyWay.VERSION = "0.3.0.23"' in config
    assert 'OuttaMyWay.BUILD_LABEL = "0.3.0.23 TEST — LIVE INTERACTION OBSERVATION GRADUATION"' in config
    assert "v0.3.0.23 TEST — LIVE INTERACTION OBSERVATION GRADUATION" in main
    assert '<version value="0.3.0.23">0.3.0.23</version>' in moddesc
