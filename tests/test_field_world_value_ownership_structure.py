from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

RETIRED = (
    "FIELD_WORLD_SNAPSHOT_GENERATION_BUDGET",
    "FIELD_WORLD_FINGERPRINT_QUANTIZATION_METRES",
    "FIELD_WORLD_FINGERPRINT_VERSION",
    "FIELD_WORLD_EQUIVALENCE_SAMPLE_SIDE",
    "FIELD_WORLD_EQUIVALENCE_MAX_COMPARISONS",
    "FIELD_WORLD_EQUIVALENCE_SAME_MAX_AREA_RELATIVE_DELTA",
    "FIELD_WORLD_EQUIVALENCE_SAME_MAX_PERIMETER_RELATIVE_DELTA",
    "FIELD_WORLD_EQUIVALENCE_SAME_MAX_CENTROID_DISTANCE_METRES",
    "FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDS_DELTA_METRES",
    "FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDARY_MEAN_DISTANCE_METRES",
    "FIELD_WORLD_EQUIVALENCE_SAME_MAX_BOUNDARY_MAX_DISTANCE_METRES",
    "FIELD_WORLD_EQUIVALENCE_SAME_MIN_SAMPLED_JACCARD",
    "FIELD_WORLD_EQUIVALENCE_DIFFERENT_MIN_BOUNDARY_SEPARATION_METRES",
    "FIELD_WORLD_EQUIVALENCE_MAX_RESOLUTIONS",
)

def test_issue87_field_world_root_value_family_is_retired():
    config = read("scripts/config.lua")
    active = "\n".join(p.read_text(encoding="utf-8") for p in (ROOT / "scripts").rglob("*.lua"))
    for name in RETIRED:
        assert name not in config
        assert f"OuttaMyWay.{name}" not in active

def test_issue87_snapshot_registry_owns_snapshot_and_fingerprint_values():
    source = read("scripts/identity/FieldWorldSnapshotRegistry.lua")
    assert "local SNAPSHOT_GENERATION_BUDGET=0.00025" in source
    assert "local FINGERPRINT_QUANTIZATION_METRES=0.1" in source
    assert 'local FINGERPRINT_SCHEMA_VERSION="FWG1"' in source
    assert "canonicalizationVersion=FINGERPRINT_SCHEMA_VERSION" in source

def test_issue87_equivalence_evaluator_owns_interpretation_values():
    source = read("scripts/identity/FieldWorldEquivalenceEvaluator.lua")
    for declaration in (
        "local EQUIVALENCE_SAMPLE_SIDE=31",
        "local SAME_MAX_AREA_RELATIVE_DELTA=0.005",
        "local SAME_MAX_PERIMETER_RELATIVE_DELTA=0.002",
        "local SAME_MAX_CENTROID_DISTANCE_METRES=0.5",
        "local SAME_MAX_BOUNDS_DELTA_METRES=0.5",
        "local SAME_MAX_BOUNDARY_MEAN_DISTANCE_METRES=0.5",
        "local SAME_MAX_BOUNDARY_MAX_DISTANCE_METRES=2.0",
        "local SAME_MIN_SAMPLED_JACCARD=0.995",
        "local DIFFERENT_MIN_BOUNDARY_SEPARATION_METRES=0.2",
    ):
        assert declaration in source
    assert "threshold(" not in source

def test_issue87_equivalence_authority_owns_evidence_history_retention():
    source = read("scripts/identity/FieldWorldEquivalenceAuthority.lua")
    assert "local COMPARISON_RECORD_RETENTION_LIMIT=128" in source
    assert "local RESOLUTION_RECORD_RETENTION_LIMIT=128" in source
    assert "local maximum=COMPARISON_RECORD_RETENTION_LIMIT" in source
    assert "local maximum=RESOLUTION_RECORD_RETENTION_LIMIT" in source

def test_issue87_existing_field_world_behavioural_witnesses_remain_independent():
    harness = read("tests/replacement_core/run.lua")
    for witness in (
        "Field World fingerprint is invariant to ring start winding and sub-quantum jitter",
        "different split polygons receive different Field World fingerprints",
        "Field World evaluator resolves strong compound overlap as SAME",
        "split Field World comparison exposes low overlap",
        "exact canonical geometry shares Field World while retaining distinct Snapshot identity",
        "four non-exact merged representations form one coherent Field World",
    ):
        assert witness in harness
    for name in RETIRED:
        assert name not in harness
