from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

def test_reality_known_u2022_is_absent_from_retained_version_hud():
    assert "•" not in read("scripts/diagnostics/VersionHud.lua")

def test_retired_follower_diagnostic_hud_cannot_reintroduce_known_glyph_leak():
    main = read("scripts/main.lua")
    assert not (ROOT / "scripts/diagnostics/FollowerPacingHud.lua").exists()
    assert "FollowerPacingHud" not in main
