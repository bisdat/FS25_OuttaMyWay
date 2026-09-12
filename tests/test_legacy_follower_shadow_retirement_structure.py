from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_issue87_legacy_follower_shadow_is_not_shipped_or_wired():
    main = read("scripts/main.lua")
    config = read("scripts/config.lua")
    hud = read("scripts/diagnostics/FollowerPacingHud.lua")

    assert not (ROOT / "scripts/diagnostics/FollowerMaturationCompressionProbe.lua").exists()
    assert "FollowerMaturationCompressionProbe" not in main
    assert "followerMaturationCompressionProbe" not in main
    assert "FOLLOWER_MATURATION_" not in config
    assert "shadowSource" not in hud
    assert "legacy follower SHADOW" not in hud
    assert "FollowerPacingHud.new(OuttaMyWay.runtime.regulationBoundedAuthority)" in main

def test_issue87_aligned_follower_boundary_path_remains_current():
    config = read("scripts/config.lua")
    follower = read("scripts/assessment/FollowerBoundaryDemandAssessment.lua")
    support = read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    magnitude = read("scripts/authority/FollowerBoundaryMagnitudePolicy.lua")
    authority = read("scripts/authority/RegulationBoundedAuthority.lua")
    hud = read("scripts/diagnostics/FollowerPacingHud.lua")

    assert "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED" not in config
    assert "FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED" not in support
    assert "local function followerBoundaryRecord(picture)" in support
    assert "local FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR=0.90" in follower
    assert "local clearanceFactor=options.clearanceFactor or FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR" in follower
    assert "OuttaMyWay.FollowerBoundaryDemandAssessment" in follower
    assert "OuttaMyWay.FollowerBoundaryMagnitudePolicy" in magnitude
    assert "FOLLOWER_BOUNDARY_OWNER_TAG" in authority
    assert "Follower regulation ALIGNED%s | %s for %s | cap %s / native %s km/h" in hud

def test_issue87_separate_native_manoeuvre_and_progression_diagnostics_remain():
    main = read("scripts/main.lua")
    assert "scripts/observation/NativeManoeuvreObservationSource.lua" in main
    assert "scripts/diagnostics/ProgressionPreservationProbe.lua" in main
    assert "OuttaMyWay.nativeManoeuvreObservationSource" in main
    assert "OuttaMyWay.progressionPreservationProbe" in main
