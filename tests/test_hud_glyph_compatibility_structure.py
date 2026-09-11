from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_reality_known_u2022_is_absent_from_demonstrated_texture_font_huds():
    for relative in (
        "scripts/diagnostics/VersionHud.lua",
        "scripts/diagnostics/FollowerPacingHud.lua",
    ):
        assert "•" not in read(relative)


def test_follower_hud_uses_reality_proven_ascii_separators():
    follower = read("scripts/diagnostics/FollowerPacingHud.lua")

    assert "Follower regulation ALIGNED%s | %s for %s | cap %s / native %s km/h" in follower
    assert "legacy follower SHADOW" not in follower
    # Deliberately no generic non-ASCII assertion: current Reality evidence
    # establishes U+2022 as unsupported, not a complete Unicode prohibition.
