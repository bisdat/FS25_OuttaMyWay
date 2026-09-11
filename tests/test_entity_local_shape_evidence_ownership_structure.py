from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")


def test_issue87_entity_local_shape_evidence_owns_shared_resolution_calibration():
    config = read("scripts/config.lua")
    evidence = read("scripts/representation/EntityLocalShapeEvidence.lua")
    cache = read("scripts/representation/AssemblyRepresentationCache.lua")
    current = read("scripts/representation/CurrentPhysicalConflictRepresentation.lua")

    for retired in (
        "REPRESENTATION_GEOMETRY_COHERENCE_TOLERANCE_METRES",
        "REPRESENTATION_ROOT_ALIAS_TOLERANCE_METRES",
    ):
        assert retired not in config
        assert retired not in cache
        assert retired not in current

    assert "local GEOMETRY_COHERENCE_TOLERANCE_METRES=0.05" in evidence
    assert "local ROOT_ALIAS_TOLERANCE_METRES=0.0001" in evidence
    assert "function Evidence.evaluate(" in evidence
    assert "accepted=coherent and not rootAlias" in evidence

    assert cache.count("OuttaMyWay.EntityLocalShapeEvidence.evaluate(") == 1
    assert current.count("OuttaMyWay.EntityLocalShapeEvidence.evaluate(") == 1
    assert "sphereDifference(" not in cache
    assert "sphereDifference(" not in current


def test_issue87_entity_local_shape_evidence_does_not_acquire_representation_product_authority():
    evidence = read("scripts/representation/EntityLocalShapeEvidence.lua")

    for forbidden in (
        "coverageComplete",
        "negativeClearanceAuthority",
        "positiveConflictSupport",
        "discoverAssembly",
        "discoverCandidates",
        "currentMembers",
        "JobEpisode",
        "CandidateAction",
        "ResolutionCommitment",
        "ControlRequest",
    ):
        assert forbidden not in evidence


def test_issue87_shared_evidence_precedes_both_representation_products_in_all_loaders():
    main = read("scripts/main.lua")
    harness = read("tests/replacement_core/run.lua")
    module = "scripts/representation/EntityLocalShapeEvidence.lua"
    cache = "scripts/representation/AssemblyRepresentationCache.lua"
    current = "scripts/representation/CurrentPhysicalConflictRepresentation.lua"

    for loader in (main, harness):
        assert module in loader
        assert cache in loader
        assert current in loader
        assert loader.index(module) < loader.index(cache) < loader.index(current)


def test_issue87_entity_local_shape_evidence_has_independent_behavioural_witnesses():
    harness = read("tests/replacement_core/run.lua")

    assert 'test("Entity-Local Shape Evidence preserves coherence and root-alias discrimination"' in harness
    assert "equal(admitted.coherent,true)" in harness
    assert "equal(admitted.rootAlias,false)" in harness
    assert "equal(admitted.accepted,true)" in harness
    assert "equal(incoherent.coherent,false)" in harness
    assert "equal(incoherent.accepted,false)" in harness
    assert "equal(alias.coherent,true)" in harness
    assert "equal(alias.rootAlias,true)" in harness
    assert "equal(alias.accepted,false)" in harness


def test_issue87_historical_placement_contracts_no_longer_freeze_resolved_shape_evidence():
    old55 = read("tests/test_assembly_discovery_bound_ownership_structure.py")
    old56 = read("tests/test_representation_cache_bound_ownership_structure.py")

    for retired in (
        "REPRESENTATION_GEOMETRY_COHERENCE_TOLERANCE_METRES",
        "REPRESENTATION_ROOT_ALIAS_TOLERANCE_METRES",
    ):
        assert retired not in old55
        assert retired not in old56
