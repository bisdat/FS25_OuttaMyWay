from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_issue87_legacy_follower_shadow_and_diagnostic_hud_are_not_shipped_or_wired():
    main = read("scripts/main.lua")
    config = read("scripts/config.lua")

    assert not (ROOT / "scripts/diagnostics/FollowerMaturationCompressionProbe.lua").exists()
    assert not (ROOT / "scripts/diagnostics/FollowerPacingHud.lua").exists()
    assert "FollowerMaturationCompressionProbe" not in main
    assert "followerMaturationCompressionProbe" not in main
    assert "FollowerPacingHud" not in main
    assert "FOLLOWER_MATURATION_" not in config

def test_issue87_aligned_follower_boundary_path_remains_current():
    config = read("scripts/config.lua")
    follower = read("scripts/assessment/FollowerBoundaryDemandAssessment.lua")
    support = read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    magnitude = read("scripts/authority/FollowerBoundaryMagnitudePolicy.lua")
    authority = read("scripts/authority/RegulationBoundedAuthority.lua")

    assert "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED" not in config
    assert "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED" not in support
    assert "local function followerBoundaryRecord(picture)" in support
    assert "local FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR=0.90" in follower
    assert "local clearanceFactor=options.clearanceFactor or FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR" in follower
    assert "OuttaMyWay.FollowerBoundaryDemandAssessment" in follower
    assert "OuttaMyWay.FollowerBoundaryMagnitudePolicy" in magnitude
    assert "FOLLOWER_BOUNDARY_OWNER_TAG" in authority

def test_current_resolution_margin_knowledge_replaces_progression_diagnostic():
    main = read("scripts/main.lua")
    module = read("scripts/assessment/ResolutionMarginDemandAssessment.lua")
    assert "scripts/assessment/ResolutionMarginDemandAssessment.lua" in main
    assert not (ROOT / "scripts/diagnostics/ProgressionPreservationProbe.lua").exists()
    assert "ProgressionPreservationProbe" not in main
    assert "POSITIVE_WITNESS_WITHIN_LOCAL_INTENT" in module
