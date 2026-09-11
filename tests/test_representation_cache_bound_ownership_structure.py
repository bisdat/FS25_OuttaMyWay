from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_issue87_hierarchy_scan_budgets_belong_to_distinct_budget_domains():
    config = read("scripts/config.lua")
    cache = read("scripts/representation/AssemblyRepresentationCache.lua")
    current = read("scripts/representation/CurrentPhysicalConflictRepresentation.lua")

    assert "REPRESENTATION_HIERARCHY_SCAN_BUDGET" not in config
    assert "OuttaMyWay.REPRESENTATION_HIERARCHY_SCAN_BUDGET" not in cache
    assert "OuttaMyWay.REPRESENTATION_HIERARCHY_SCAN_BUDGET" not in current

    assert "local MEMBER_HIERARCHY_DISCOVERY_SCAN_BUDGET=2200" in cache
    assert "self:_scanHierarchy(member.object.rootNode,MEMBER_HIERARCHY_DISCOVERY_SCAN_BUDGET" in cache

    assert "local CURRENT_ASSEMBLY_CANDIDATE_HIERARCHY_SCAN_BUDGET=2200" in current
    assert "local budget=CURRENT_ASSEMBLY_CANDIDATE_HIERARCHY_SCAN_BUDGET" in current


def test_issue87_revalidation_horizons_belong_to_distinct_validity_domains():
    config = read("scripts/config.lua")
    cache = read("scripts/representation/AssemblyRepresentationCache.lua")
    current = read("scripts/representation/CurrentPhysicalConflictRepresentation.lua")

    assert "REPRESENTATION_ASSEMBLY_REVALIDATION_INTERVAL_SECONDS" not in config
    assert "OuttaMyWay.REPRESENTATION_ASSEMBLY_REVALIDATION_INTERVAL_SECONDS" not in cache
    assert "OuttaMyWay.REPRESENTATION_ASSEMBLY_REVALIDATION_INTERVAL_SECONDS" not in current

    assert "local ASSEMBLY_MEMBERSHIP_REVALIDATION_INTERVAL_SECONDS=5" in cache
    assert "local interval=ASSEMBLY_MEMBERSHIP_REVALIDATION_INTERVAL_SECONDS" in cache

    assert "local CANDIDATE_DISCOVERY_REFRESH_INTERVAL_SECONDS=5" in current
    assert "local interval=CANDIDATE_DISCOVERY_REFRESH_INTERVAL_SECONDS" in current
    assert "local currentMemberSet={}" in current
    assert "for _,member in OuttaMyWay.ValueRecord.ipairs(currentMembers(root)) do" in current
    assert "currentMemberSet[member]=true" in current
    assert "local memberCurrent=currentMemberSet[candidate.member]==true" in current
