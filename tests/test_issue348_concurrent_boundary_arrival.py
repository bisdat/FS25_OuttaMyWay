from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def test_concurrent_boundary_arrival_is_loaded_before_spatial_constraint_consumer():
    main = read("scripts/main.lua")
    helper = '"scripts/assessment/ConcurrentBoundaryArrivalAssessment.lua"'
    spatial = '"scripts/assessment/SpatialConstraintAssessment.lua"'
    assert helper in main
    assert main.index(helper) < main.index(spatial)


def test_category_2_boundary_arrival_is_independent_of_forward_intersection_and_turn_prediction():
    assessment = read("scripts/assessment/ConcurrentBoundaryArrivalAssessment.lua")
    spatial = read("scripts/assessment/SpatialConstraintAssessment.lua")
    assert 'classification="CONCURRENT_BOUNDARY_ARRIVAL"' in assessment
    assert '"CATEGORY_2_HEADLAND_BOUNDARY"' in assessment
    assert "boundaryContactDistanceM" in assessment
    assert "localDemandReachM" in assessment
    assert "arrivalOverlapWindowSec" in assessment
    assert "FORWARD_INTERSECTION" not in assessment
    assert "TURNING" not in assessment
    assert "ConcurrentBoundaryArrivalAssessment.assessPair" in spatial


def test_candidate_support_exposes_two_temporal_allocations_and_decision_owns_choice():
    candidates = read("scripts/candidates/LiveTrafficCandidateSupport.lua")
    policy = read("scripts/decision/TrafficPolicemanDecisionPolicy.lua")
    assert "CONCURRENT_BOUNDARY_ARRIVAL_CANDIDATES_SUPPORTED" in candidates
    assert 'admissionKind="CONCURRENT_BOUNDARY_ARRIVAL"' in candidates
    assert '"concurrent-boundary-arrival-regulation:"' in candidates
    assert 'referenceKey="concurrent-boundary-arrival-regulation:"..tostring(relation.identity)..":"..tostring(action.regulatedAssemblyId)' in candidates
    assert 'if boundaryArrival or action.admissionKind=="CORNER_RIGHT_OF_WAY" then' in candidates
    assert "concurrentBoundaryArrival=boundaryArrival and" in candidates
    assert "concurrentBoundaryArrivalChoice" in policy
    assert "PROTECT_EARLIER_NATIVE_BOUNDARY_ARRIVAL" in policy
    assert "DETERMINISTIC_EQUAL_BOUNDARY_ARRIVAL_ALLOCATION" in policy


def test_boundary_arrival_reuses_fixed_intent_revelation_regulation_without_new_control_type():
    authority = read("scripts/authority/RegulationBoundedAuthority.lua")
    control = read("scripts/control/RegulationControl.lua")
    assert 'CONCURRENT_BOUNDARY_ARRIVAL_OWNER_TAG="CONCURRENT_BOUNDARY_ARRIVAL_INTENT_REVELATION"' in authority
    assert 'bridge.admissionKind=="CONCURRENT_BOUNDARY_ARRIVAL"' in authority
    assert "fixedConcurrentBoundaryArrival" in authority
    assert "CONCURRENT_BOUNDARY_ARRIVAL_REGULATION_ADMITTED" in authority
    assert "INTENT_REVELATION_CREEP" in authority
    assert "CONCURRENT_BOUNDARY_ARRIVAL" not in control


def test_boundary_arrival_waiting_requires_positive_dissolution_or_supersession():
    assessment = read("scripts/assessment/CurrentResponsibilityAssessment.lua")
    runtime = read("scripts/runtime/Runtime.lua")
    lifecycle = read("scripts/commitment/LiveTrafficCommitmentLifecycle.lua")
    assert 'admissionKind=="CONCURRENT_BOUNDARY_ARRIVAL"' in assessment
    assert "CONCURRENT_BOUNDARY_ARRIVAL_EVIDENCE_TEMPORARILY_UNRESOLVED" in assessment
    assert "CONCURRENT_BOUNDARY_ARRIVAL_POSITIVE_DISSOLUTION" in assessment
    assert "CONCURRENT_BOUNDARY_ARRIVAL_TERMINATION_EVIDENCE_REQUIRED" in runtime
    assert "CONCURRENT_BOUNDARY_ARRIVAL_SETTLEMENT_REQUIRES_POSITIVE_DISSOLUTION_OR_SUPERSESSION" in lifecycle


def test_authority_triad_names_the_same_boundary_arrival_concept():
    architecture = read("architecture/SPATIAL_NEGOTIATION_MODEL.md")
    spec = read("spec/SITUATION_ASSESSMENT.md")
    source = read("scripts/assessment/ConcurrentBoundaryArrivalAssessment.lua")
    for content in (architecture, spec, source):
        assert "Concurrent Boundary Arrival" in content or "ConcurrentBoundaryArrival" in content
    assert "Forward Intersection != Shared Boundary Demand" in architecture
    assert "Forward Intersection != Shared Boundary Demand" in spec
