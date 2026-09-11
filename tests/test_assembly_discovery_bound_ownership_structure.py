from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_issue87_assembly_member_discovery_bound_belongs_to_representation_cache():
    config = read("scripts/config.lua")
    cache = read("scripts/representation/AssemblyRepresentationCache.lua")

    assert "REPRESENTATION_ASSEMBLY_MEMBER_BUDGET" not in config
    assert "OuttaMyWay.REPRESENTATION_ASSEMBLY_MEMBER_BUDGET" not in cache
    assert "local ASSEMBLY_MEMBER_BUDGET=32" in cache
    assert cache.count("discoverAssembly(worker,ASSEMBLY_MEMBER_BUDGET)") == 2


def test_issue87_shared_representation_values_remain_unresolved_in_this_tranche():
    config = read("scripts/config.lua")
    cache = read("scripts/representation/AssemblyRepresentationCache.lua")
    current = read("scripts/representation/CurrentPhysicalConflictRepresentation.lua")

    shared = (
        "REPRESENTATION_HIERARCHY_SCAN_BUDGET",
        "REPRESENTATION_ASSEMBLY_REVALIDATION_INTERVAL_SECONDS",
        "REPRESENTATION_GEOMETRY_COHERENCE_TOLERANCE_METRES",
        "REPRESENTATION_ROOT_ALIAS_TOLERANCE_METRES",
    )
    for name in shared:
        assert f"OuttaMyWay.{name}" in config
        assert f"OuttaMyWay.{name}" in cache
        assert f"OuttaMyWay.{name}" in current


def test_issue87_member_budget_regression_oracle_is_independent_from_production_state():
    harness = read("tests/replacement_core/run.lua")

    assert "OuttaMyWay.REPRESENTATION_ASSEMBLY_MEMBER_BUDGET" not in harness
    assert "local expectedMemberBudget=32" in harness
    assert "local budget=expectedMemberBudget" in harness
    assert "equal(evidence.memberCount,expectedMemberBudget)" in harness
    assert 'equal(evidence.transitPassageReason,"TRANSIT_ASSEMBLY_MEMBERSHIP_TRUNCATED")' in harness
