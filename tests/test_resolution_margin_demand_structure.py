from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def text(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_resolution_margin_modules_are_situation_jurisdiction_and_loaded_before_runtime():
    main = text("scripts/main.lua")
    evaluator = '"scripts/assessment/ResolutionMarginDemandAssessment.lua"'
    decorator = '"scripts/assessment/ResolutionMarginSituationAssessment.lua"'
    runtime = '"scripts/runtime/Runtime.lua"'
    assert evaluator in main
    assert decorator in main
    assert main.index(evaluator) < main.index(decorator) < main.index(runtime)
    assert "OuttaMyWay.runtime.situationAssessment=OuttaMyWay.ResolutionMarginSituationAssessment.new" in main
    for path in (
        "scripts/assessment/ResolutionMarginDemandAssessment.lua",
        "scripts/assessment/ResolutionMarginSituationAssessment.lua",
    ):
        source = text(path)
        assert "Specification Jurisdictions: `SITUATION_ASSESSMENT`" in source


def test_operational_picture_exposes_resolution_margin_as_optional_situation_knowledge():
    contract = text("scripts/contracts/OperationalPicture.lua")
    assert '"resolutionMarginDemandKnowledge"' in contract
    decorator = text("scripts/assessment/ResolutionMarginSituationAssessment.lua")
    assert "values.resolutionMarginDemandKnowledge=knowledge" in decorator
    assert "values.identity" not in decorator
    assert "values.epoch" not in decorator


def test_resolution_margin_evidence_is_one_sided_and_uses_neutral_geometry():
    source = text("scripts/assessment/ResolutionMarginDemandAssessment.lua")
    assert "OuttaMyWay.ProgressionGeometry.rayCapsuleEntry" in source
    assert 'status="POSITIVE_WITNESS_WITHIN_LOCAL_INTENT"' in source
    assert "negativeClearanceAuthority=false" in source
    assert "safeClearanceAuthority=false" in source
    assert "stoppingDistanceAuthority=false" in source
    assert "speedAuthority=false" in source
    assert "routePredictionAuthority=false" in source
    assert "ProgressionPreservationProbe" not in source
    assert "maxSpeedKmh" not in source
    assert "capKmh" not in source
    assert "ControlRequest" not in source


def test_no_downstream_runtime_layer_consumes_resolution_margin_in_079():
    forbidden_roots = (
        "scripts/candidates",
        "scripts/decision",
        "scripts/constraints",
        "scripts/responsibility",
        "scripts/commitment",
        "scripts/authority",
        "scripts/control",
    )
    consumers = []
    for root in forbidden_roots:
        for path in (ROOT / root).rglob("*.lua"):
            if "resolutionMarginDemandKnowledge" in path.read_text(encoding="utf-8"):
                consumers.append(str(path.relative_to(ROOT)))
    assert consumers == []
