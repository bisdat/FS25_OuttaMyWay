from pathlib import Path
import hashlib

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / "scripts" / "archive" / "v4_6_78"


def test_active_loader_never_sources_archive_or_legacy_core():
    text = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    assert "scripts/archive/" not in text
    for forbidden in ("scripts/core/", "scripts/control/", "scripts/observer/"):
        assert forbidden not in text


def test_archive_contains_exact_declared_legacy_file_set():
    manifest = {}
    for line in (ARCHIVE / "SHA256SUMS.txt").read_text(encoding="utf-8").splitlines():
        digest, rel = line.split(maxsplit=1)
        manifest[rel] = digest
    assert len(manifest) == 48
    for rel, expected in manifest.items():
        path = ARCHIVE / rel
        assert path.is_file()
        assert hashlib.sha256(path.read_bytes()).hexdigest() == expected


def test_active_lua_tree_is_small_and_archive_independent():
    active = [p for p in (ROOT / "scripts").rglob("*.lua") if "archive" not in p.parts]
    assert active
    for path in active:
        text = path.read_text(encoding="utf-8")
        assert "archive/v4_6_78" not in text
        assert "TrafficDecisionEngineV2" not in text
        assert "UnilateralSidestepController" not in text
        assert "EncounterController" not in text


def test_runtime_has_no_giants_observation_or_control_hook():
    text = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    forbidden = ("addModEventListener", "driveToPoint", "getCanAIFieldWorkerContinueWork", "AIFieldWorker", "g_currentMission")
    for token in forbidden:
        assert token not in text


def test_observation_identity_modules_are_active_but_not_live_wired():
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    assert "scripts/observation/RuntimeObservationAdapter.lua" in main
    assert "scripts/identity/JobEpisodeAdmission.lua" in main
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    assert "publishObservation" in runtime
    assert "admitJobEpisodes" in runtime
    for token in ("addModEventListener", "updateTick", "g_currentMission", "AIFieldWorker"):
        assert token not in runtime

def test_decision_is_present_but_control_remains_absent():
    assert (ROOT / "scripts" / "decision" / "DecisionSelector.lua").is_file()
    assert not (ROOT / "scripts" / "control").exists()
    active_text = "\n".join(p.read_text(encoding="utf-8") for p in (ROOT / "scripts").rglob("*.lua") if "archive" not in p.parts)
    assert "DecisionSelector" in active_text
    assert "ControlAdmission" not in active_text


def test_operational_picture_modules_are_offline_and_active():
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    for rel in ("scripts/identity/OperationAdmission.lua", "scripts/assessment/RepresentationFitness.lua", "scripts/assessment/SituationAssessment.lua"):
        assert rel in main
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")
    assert "processSealedObservation" in runtime
    for token in ("addModEventListener", "updateTick", "g_currentMission", "AIFieldWorker", "driveToPoint"):
        assert token not in runtime


def test_v472_knowledge_boundary_remains_separate_from_v473_decision():
    assert (ROOT / "scripts" / "candidates" / "CandidateSpace.lua").is_file()
    assert (ROOT / "scripts" / "constraints" / "ConstraintEngine.lua").is_file()
    assert (ROOT / "scripts" / "decision" / "DecisionSelector.lua").is_file()
    assert not (ROOT / "scripts" / "control").exists()
    assessment = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    assert "CandidateSpace" not in assessment
    assert "DecisionSelector" not in assessment


def test_situation_assessment_does_not_source_archive():
    text = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    assert "scripts/archive" not in text
    for token in ("TrafficDecisionEngineV2", "EncounterController", "ShadowRefugeCandidateComparison"):
        assert token not in text


def test_v473_decision_modules_are_active_and_offline_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    required=(
        "scripts/candidates/CandidateSpace.lua",
        "scripts/constraints/ConstraintEngine.lua",
        "scripts/decision/DecisionSelector.lua",
        "scripts/contracts/CandidateInventory.lua",
        "scripts/contracts/ConstraintVerdictSet.lua",
    )
    for rel in required:
        assert rel in main
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert "evaluateSealedOperationalPicture" in runtime
    for token in ("addModEventListener","updateTick","g_currentMission","AIFieldWorker","driveToPoint"):
        assert token not in runtime


def test_candidate_generation_cannot_select_or_dispatch():
    text=(ROOT/"scripts"/"candidates"/"CandidateSpace.lua").read_text(encoding="utf-8")
    for token in ("DecisionSelector","selectedCandidateId","ControlRequest","source(","scripts/archive"):
        assert token not in text


def test_decision_selector_has_no_control_or_archive_dependency():
    text=(ROOT/"scripts"/"decision"/"DecisionSelector.lua").read_text(encoding="utf-8")
    for token in ("ControlRequest","ControlAdmission","source(","scripts/archive","g_currentMission"):
        assert token not in text


def test_constraint_engine_declares_all_canonical_mandatory_families():
    active="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts"/"constraints").rglob("*.lua"))
    for constraint in (
        "FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS",
        "CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION",
        "RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS",
        "EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER",
    ):
        assert constraint in active


def test_v473_has_no_control_capability_directory():
    assert not (ROOT/"scripts"/"control").exists()


def test_v474_replay_modules_are_active_and_offline_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    for rel in (
        "scripts/replay/ReplayRunner.lua","scripts/replay/ConformanceAssertions.lua",
        "scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua",
        "scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua",
    ):
        assert rel in main
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert "runReplay" in runtime
    for token in ("addModEventListener","updateTick","g_currentMission","driveToPoint"):
        assert token not in runtime


def test_replay_corpus_names_all_required_historical_families():
    text=(ROOT/"scenarios"/"replay"/"HistoricalFixtures.lua").read_text(encoding="utf-8")
    for token in ("V4649","V4657","V4664","V4670","V4677","TS016","NO-MOD","LOADED-NO-ENCOUNTER"):
        assert token in text


def test_replay_has_no_physical_control_dispatch():
    active="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts").rglob("*.lua") if "archive" not in p.parts)
    for token in ("driveToPoint(","setCruiseControlState(","AIFieldWorker:stopCurrentAIJob", "ControlAdmission"):
        assert token not in active


def test_v475_passive_live_modules_are_active_and_zero_control():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    for rel in ("scripts/observation/LiveObservationSource.lua","scripts/candidates/PassiveLiveCandidateSupport.lua","scripts/diagnostics/PassiveLiveValidator.lua","scripts/contracts/PassiveLiveTraceRecord.lua"):
        assert rel in main
    assert "addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)" in main
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    assert "decisionCommitmentBoundary:apply" not in validator
    assert "Control authority disabled" in (ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")


def test_v475_live_source_does_not_import_archive_or_control():
    active="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts").rglob("*.lua") if "archive" not in p.parts)
    assert "scripts/archive/" not in active
    for token in ("driveToPoint(","setCruiseControlState(","stopCurrentAIJob(","setMotorTurnedOn("):
        assert token not in active


def test_v475_candidate_support_is_non_actuating_only():
    text=(ROOT/"scripts"/"candidates"/"PassiveLiveCandidateSupport.lua").read_text(encoding="utf-8")
    assert '"CONTINUE_OBSERVATION"' in text
    assert '"CONTINUE_UNCHANGED"' in text
    for capability in ('"HOLD"','"REGULATE_SPEED"','"REPOSITION"','"HANDOVER_TO_GIANTS"'):
        assert capability not in text


def test_v476_admission_correction_remains_present_under_later_probe_builds():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    assert "OBSERVED_NATIVE_AI_ACTIVITY_EPISODE" in source
    assert "JOB_EPISODE_TERMINATION_CAUSE" in source


def test_v476_activity_onset_tokens_and_unresolved_termination_are_explicit():
    text=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assert "OBSERVED_NATIVE_AI_ACTIVITY_EPISODE" in text
    assert "JOB_EPISODE_TERMINATION_CAUSE" in text
    assert "observed-ai-episode:" in text
    assert "playerTakeoverObserved" in text


def test_v476_trace_reports_candidate_verdict_diagnostics():
    text=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    for token in ("candidateCount","allPassCandidateCount","unresolvedCandidateCount","failedCandidateCount","unavailableSourceCount"):
        assert token in text
    assert "decisionCommitmentBoundary:apply" not in text



def test_v478_targeted_job_episode_and_field_identity_path_is_active():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    assert "scripts/observation/LiveAIJobEvidence.lua" in main
    assert "scripts/diagnostics/TargetedFieldIdentityProbe.lua" in main
    assert "scripts/diagnostics/LiveAIStateProbe.lua" not in main
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config
    evidence=(ROOT/"scripts"/"observation"/"LiveAIJobEvidence.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"TargetedFieldIdentityProbe.lua").read_text(encoding="utf-8")
    for token in ("activeJobVehicles","spec_aiJobVehicle.job","spec_aiFieldWorker.fieldJob","farmlandIdFieldMapping","jobId"):
        assert token in evidence
    assert "GIANTS_ACTIVE_JOB_IDENTITY" in source
    assert "activeJobVehicleMembership" in source
    assert "FIELD-PROBE" in probe
    for text in (evidence, source, probe):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    assert "self.probe:update" in validator
    assert "decisionCommitmentBoundary:apply" not in validator


def test_v478_broad_reflection_probe_is_removed_from_active_tree():
    assert not (ROOT/"scripts"/"diagnostics"/"LiveAIStateProbe.lua").exists()
    active="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts").rglob("*.lua") if "archive" not in p.parts)
    assert "collectSystemSummary" not in active
    assert "objectAIFields" not in active


def test_v479_giants_compatible_value_traversal_is_explicit():
    value=(ROOT/"scripts"/"contracts"/"ValueRecord.lua").read_text(encoding="utf-8")
    for token in ("function ValueRecord.pairs", "function ValueRecord.ipairs", "function ValueRecord.length", "GIANTS uses a Lua runtime"):
        assert token in value
    for path in (
        ROOT/"scripts"/"identity"/"JobEpisodeAdmission.lua",
        ROOT/"scripts"/"identity"/"OperationAdmission.lua",
        ROOT/"scripts"/"assessment"/"SituationAssessment.lua",
        ROOT/"scripts"/"candidates"/"CandidateSpace.lua",
        ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua",
    ):
        text=path.read_text(encoding="utf-8")
        assert "OuttaMyWay.ValueRecord.ipairs(" in text or "OuttaMyWay.ValueRecord.pairs(" in text


def test_v479_polygon_field_identity_fallback_is_read_only():
    text=(ROOT/"scripts"/"observation"/"LiveAIJobEvidence.lua").read_text(encoding="utf-8")
    for token in ("fieldManager.fields", "field.getPolygonPoints", "NO_FIELD_POLYGON_MATCH", "MULTIPLE_FIELD_POLYGONS_MATCH"):
        assert token in text
    for forbidden in ("driveToPoint(","stopCurrentAIJob(","setCruiseControlState("):
        assert forbidden not in text
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config


def test_v4711_job_seeded_snapshot_capture_remains_active_under_equivalence_authority():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    assert "scripts/identity/FieldWorldSnapshotRegistry.lua" in main
    assert "scripts/diagnostics/DerivedFieldWorldProbe.lua" not in main
    registry=(ROOT/"scripts"/"identity"/"FieldWorldSnapshotRegistry.lua").read_text(encoding="utf-8")
    for token in ("canonicalizeBoundary","geometryFingerprint","immutableForJobEpisode","FIELD_WORLD_FINGERPRINT_COLLISION","FieldCourseField.generateAtPosition","function Registry:ensure"):
        assert token in registry
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    for token in ("JOB_SEEDED_FIELD_WORLD_EQUIVALENCE_AUTHORITY","fieldWorldSnapshot","fieldWorldResolution","playerFacingFieldId","FARMLAND_LABEL_CORRELATION"):
        assert token in source
    assert "field-world:provisional-source-field:" not in source


def test_v4711_field_world_snapshot_is_bound_once_to_job_episode():
    admission=(ROOT/"scripts"/"identity"/"JobEpisodeAdmission.lua").read_text(encoding="utf-8")
    assert "_bindFieldWorld" in admission
    assert "cannot change after capture" in admission
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config


def test_v4711_parallel_validation_reports_global_operation_count():
    trace=(ROOT/"scripts"/"contracts"/"PassiveLiveTraceRecord.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    assert "globalActiveOperationCount" in trace
    assert "globalOperations=%d" in validator
    assert "decisionCommitmentBoundary:apply" not in validator


def test_v4710_source_intent_termination_is_positive_evidence_not_inactivity_guess():
    evidence=(ROOT/"scripts"/"observation"/"LiveAIJobEvidence.lua").read_text(encoding="utf-8")
    for token in ("spec_aiJobVehicle.lastJob","jobActiveInMission","PREVIOUS_JOB_RETAINED_AS_LAST_JOB_AND_NO_LONGER_ACTIVE"):
        assert token in evidence
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assert "sourceIntentTerminationObserved" in source
    admission=(ROOT/"scripts"/"identity"/"JobEpisodeAdmission.lua").read_text(encoding="utf-8")
    assert 'cause="SOURCE_INTENT_TERMINATION"' in admission


def test_v4714_field_world_equivalence_authority_is_active_and_conservative():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    for rel in ("scripts/identity/FieldWorldSnapshotRegistry.lua","scripts/identity/FieldWorldEquivalenceEvaluator.lua","scripts/identity/FieldWorldEquivalenceAuthority.lua"):
        assert rel in main
    registry=(ROOT/"scripts"/"identity"/"FieldWorldSnapshotRegistry.lua").read_text(encoding="utf-8")
    for token in ("measureGeometry","compareGeometry","sampledJaccard","symmetricBoundaryMaxDistanceMetres","minimumBoundaryDistanceMetres","occupiedRegionsDisjoint","canonicalRootRing"):
        assert token in registry
    evaluator=(ROOT/"scripts"/"identity"/"FieldWorldEquivalenceEvaluator.lua").read_text(encoding="utf-8")
    for token in ("SAME_FIELD_WORLD","DIFFERENT_FIELD_WORLD","UNRESOLVED","COMPOUND_POSITIVE_SPATIAL_EQUIVALENCE","COMPOUND_POSITIVE_SPATIAL_SEPARATION"):
        assert token in evaluator
    authority=(ROOT/"scripts"/"identity"/"FieldWorldEquivalenceAuthority.lua").read_text(encoding="utf-8")
    for token in ("CLASS_WIDE_POSITIVE_SPATIAL_EQUIVALENCE","NO_SINGLE_COHERENT_FIELD_WORLD_ASSIGNMENT","beginObservationCycle","endObservationCycle","NO_RELEVANT_JOB_EPISODE_EVIDENCE"):
        assert token in authority
    operation=(ROOT/"scripts"/"identity"/"OperationAdmission.lua").read_text(encoding="utf-8")
    for token in ("memberFieldWorldSnapshotReferenceKeys","memberFieldPolygonReferenceKeys","resolved Field World identity"):
        assert token in operation
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    for token in ("FIELD_WORLD_EQUIVALENCE_SAMPLE_SIDE","FIELD_WORLD_EQUIVALENCE_SAME_MAX_AREA_RELATIVE_DELTA","FIELD_WORLD_EQUIVALENCE_SAME_MIN_SAMPLED_JACCARD","FIELD_WORLD_EQUIVALENCE_DIFFERENT_MIN_BOUNDARY_SEPARATION_METRES"):
        assert token in config
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert "legacy-shadow cleanup conformance loaded" in runtime
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in (ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")


def test_v4715_bounded_interaction_diagnostics_are_multi_worker_and_passive():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    assert "scripts/diagnostics/LiveInteractionDiagnostics.lua" in main
    diagnostics=(ROOT/"scripts"/"diagnostics"/"LiveInteractionDiagnostics.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    for token in ("MISSING_SUBJECT_RADIUS","MISSING_OTHER_RADIUS","CURRENT_INTERACTION_UNRESOLVED","CURRENT_INTERACTION_QUALIFIED","closingRate","relativeSpeedMps"):
        assert token in diagnostics
    for forbidden in ("TCPA_BEYOND_HORIZON","CPA_EXCEEDS_REPRESENTED_ENVELOPE","FUTURE_INTERACTION_QUALIFIED","predictPair("):
        assert forbidden not in diagnostics
    for token in ("mathematicallyPossiblePairCount","relevantPairCount","eligiblePairCount","evaluatedPairCount","qualifyingPairCount","pairDiagnostics"):
        assert token in source
    for token in ("interactionEvidenceReceivedCount","encounterCreatedCount","SAME_OPERATION_ACTIVE_PAIR_NOT_EVALUATED","BOTH_WORKERS_BLOCKED_WITHOUT_ENCOUNTER"):
        assert token in assessment
    for token in ("PAIR pair=","ENCOUNTER lifecycle=CREATED","ENCOUNTER lifecycle=RETAINED","ENCOUNTER lifecycle=TERMINATED","PAIR_OPERATION_CHANGED_DURING_JOB_EPISODE","PAIR_DISAPPEARED_WHILE_BOTH_WORKERS_ACTIVE"):
        assert token in validator
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config
    assert "PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE" in config
    for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
        assert forbidden not in diagnostics
        assert forbidden not in source
        assert forbidden not in validator


def test_v4717_plan_view_representation_foundation_remains_active():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    for rel in (
        "scripts/representation/catalogues/CondorEndurance2Donor.lua",
        "scripts/representation/PlanViewFootprint.lua",
        "scripts/representation/AssemblyRepresentationCache.lua",
    ):
        assert rel in main
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    footprint=(ROOT/"scripts"/"representation"/"PlanViewFootprint.lua").read_text(encoding="utf-8")
    donor=(ROOT/"scripts"/"representation"/"catalogues"/"CondorEndurance2Donor.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    for token in ("discoverAssembly","assemblyFingerprint","configurationProfileCacheHit","getShapeGeometryBoundingSphere","getShapeWorldBoundingSphere","rootAlias"):
        assert token in cache
    for token in ("convexHull","CURRENT_FOOTPRINT_INTERACTION_POSITIVE","CURRENT_FOOTPRINT_INTERACTION_UNRESOLVED","NO_NEGATIVE_CLEARANCE_AUTHORITY","evaluateCurrentOverlap"):
        assert token in footprint
    for forbidden in ("SHADOW_FUTURE_CONVERGENCE_POSITIVE","evaluateShadowPair(","composePositiveEvidence("):
        assert forbidden not in footprint
    for token in ("boom01ArmLeftCol01","boom01ArmRightCol04","PERMANENT_PHYSICAL_CONTROL","PROTOTYPES_08_09_10_11_13"):
        assert token in donor
    for token in ("shadowPlanViewEvidence","currentFootprintOutcome","POSITIVE_INTERACTION_ONLY"):
        assert token in source
    for token in ("shadowInventoryPrimitives","shadowParticipatingPrimitives","shadowInactivePrimitives","shadowProfileCacheHit","currentFootprintOutcome"):
        assert token in validator
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config
    assert "POTENTIAL_INTERACTION_FROM_REPRESENTED_COMPONENTS" in cache
    assert "negativeClearanceAuthority=false" in cache
    for text in (cache,footprint,source,validator):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text


def test_v4718_positive_filtered_footprint_admission_is_monotonic_and_passive():
    footprint=(ROOT/"scripts"/"representation"/"PlanViewFootprint.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    for token in ("evaluateCurrentOverlap","CURRENT_FOOTPRINT_INTERACTION_POSITIVE","NO_NEGATIVE_CLEARANCE_AUTHORITY"):
        assert token in footprint
    for token in ("interactionEvidenceSource","interactionEvidenceAuthority","POSITIVE_INTERACTION_ONLY","currentFootprintIntersects","negativeClearanceAuthority = false"):
        assert token in source
    for forbidden in ("composePositiveEvidence(","FILTERED_PLAN_VIEW_POSITIVE","SCALAR_AND_FILTERED_PLAN_VIEW_POSITIVE","evaluateShadowPair("):
        assert forbidden not in footprint + source
    assert "interaction evidence requires interactionReferenceKey" in assessment
    assert "evidenceSource=%s" in validator
    assert "decisionCommitmentBoundary:apply" not in validator
    for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState("):
        assert forbidden not in source


def test_v4719_encounter_exit_contract_is_first_class_and_passive():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    assert "scripts/assessment/EncounterRegistry.lua" in main
    registry=(ROOT/"scripts"/"assessment"/"EncounterRegistry.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    for token in ("JOB_EPISODE_ENDED","OPERATION_ENDED","MEMBERSHIP_INVALIDATED","INTENT_SUPERSEDED","positiveObservedThisAssessment","EncounterRecord"):
        assert token in registry
    assert "encounterLifecycleTransitions" in assessment
    assert "ENCOUNTER lifecycle=TERMINATED" in validator
    assert "Control authority disabled" in runtime
    assert "controlAuthorityEnabled=false" in runtime


def test_v4720_shape_gate_and_diagnostic_throttling_remain_passive():
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    for token in ("getHasClassId","classIds.SHAPE","NOT_SHAPE","SHAPE_CLASS_API_UNAVAILABLE"):
        assert token in cache
    assert "pairDiagnosticSignatures" in validator
    for text in (validator,cache):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text


def test_v4721_future_space_conformance_recovers_existing_local_intent_architecture_passively():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    intent=(ROOT/"scripts"/"observation"/"LocalIntentObservation.lua").read_text(encoding="utf-8")
    future=(ROOT/"scripts"/"observation"/"FieldBoundedFutureSpace.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    hud=(ROOT/"scripts"/"diagnostics"/"FutureSpaceHud.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    for rel in ("scripts/observation/LocalIntentObservation.lua","scripts/observation/FieldBoundedFutureSpace.lua","scripts/diagnostics/FutureSpaceHud.lua"):
        assert rel in main
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config
    assert "PASSIVE_FUTURE_HORIZON_SECONDS" not in config
    assert "LEGACY_SHADOW_INTERACTION_PROBE_HORIZON_SECONDS" not in config
    for token in ("FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION","futureSpaceRelationshipEvidence","NEXT_MATERIAL_MANOEUVRE"):
        assert token in source
    for token in ("getActiveSegmentData","TURNING","SETTLED_CONTINUATION","INTENT_EXPIRED_BY_MANOEUVRE","LOCAL_INTENT_REVEALED_AFTER_MANOEUVRE"):
        assert token in intent
    for token in ("forwardBoundaryDistance","FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE","NO_NEGATIVE_CLEARANCE_AUTHORITY","MANOEUVRE_SWEEP_NOT_YET_REPRESENTED"):
        assert token in future
    for token in ("futureSpaceRelationships","FUTURE_SPACE_INTERSECTION","MANOEUVRING"):
        assert token in assessment
    for token in ("OTM FUTURE SPACE","FUTURE SPACES INTERSECT","UNRESOLVED WHILE MANOEUVRING","FUTURE-SPACE HUD"):
        assert token in hud
    assert "FUTURE_SPACE pair=%s classification=%s" in validator
    assert "legacy-shadow cleanup conformance loaded" in runtime
    for text in (source,intent,future,assessment,hud,validator,runtime):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text

def test_v4722_incomplete_membership_cannot_preempt_job_episode_terminal_evidence():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    operation=(ROOT/"scripts"/"identity"/"OperationAdmission.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    hud=(ROOT/"scripts"/"diagnostics"/"TransitionHud.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config
    assert "MEMBERSHIP_UPDATED_INCOMPLETE" in operation
    assert "removalDeferred=true" in operation
    assert "mergedUnique(active.memberAssemblyIds, memberAssemblyIds)" in operation
    assert "scripts/diagnostics/TransitionHud.lua" in main
    for token in ("OTM TEST", "FUTURE SPACE ENCOUNTER", "ENCOUNTER TERMINATED", "NEW JOB EPISODE", "NEW FUTURE SPACE ENCOUNTER"):
        assert token in hud
    assert "transitionHud:observeEncounterTransition" in validator
    assert "transitionHud:observeAdmittedEpisodes" in validator
    for text in (operation,validator,hud):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text

def test_v4724_removes_legacy_future_predictor_without_changing_future_space_admission_authority():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    diagnostics=(ROOT/"scripts"/"diagnostics"/"LiveInteractionDiagnostics.lua").read_text(encoding="utf-8")
    footprint=(ROOT/"scripts"/"representation"/"PlanViewFootprint.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    hud=(ROOT/"scripts"/"diagnostics"/"TransitionHud.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    assert 'RUNTIME_MODE = "LEGACY_SHADOW_CLEANUP_CONFORMANCE"' in config
    assert "LEGACY_SHADOW_INTERACTION_PROBE_HORIZON_SECONDS" not in config
    for forbidden in ("predictPair(", "evaluateShadowPair(", "composePositiveEvidence(", "legacyShadowPositive", "legacyTCPA", "legacyDCPA"):
        assert forbidden not in source + diagnostics + footprint + validator
    assert "observePairState" in diagnostics
    assert "evaluateCurrentOverlap" in footprint
    for token in ("FIELD_BOUNDED_FUTURE_SPACE_POSITIVE", "FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION", "fieldBoundedFutureSpacePositive"):
        assert token in source
    assert "relationship=item.relationship or" in assessment
    assert "OTM TEST — FUTURE SPACE ENCOUNTER" in hud
    assert "OTM TEST — NEW FUTURE SPACE ENCOUNTER" in hud
    assert "futureSpacePositive=%s" in validator
    assert "legacyFutureProbeRemoved=true" in runtime
    assert "fixed-horizon future predictor removed from active runtime" in runtime
    for text in (source,assessment,hud,validator,runtime):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text


def test_v4728_traffic_policeman_architecture_is_documented_without_production_control():
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    adr=(ROOT/"docs"/"adr"/"ADR-0023-traffic-policeman-movement-priority.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    concepts=(ROOT/"docs"/"CONCEPT_REGISTER.md").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    for token in ("Traffic Policeman","Demonstrated Traversability","Revelation Oscillation"):
        assert token in adr
        assert token in glossary
        assert token in concepts
    assert "Encounter-relative" in adr
    assert "Static-object recovery/avoidance is deliberately parked" in adr
    assert "Traffic Policeman" in architecture
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in runtime


def test_v4729_staged_recovery_architecture_is_documented_without_production_control():
    adr23=(ROOT/"docs"/"adr"/"ADR-0023-traffic-policeman-movement-priority.md").read_text(encoding="utf-8")
    adr22=(ROOT/"docs"/"adr"/"ADR-0022-bounded-native-intent-revelation.md").read_text(encoding="utf-8")
    adr9=(ROOT/"docs"/"adr"/"ADR-0009-native-handover-envelope.md").read_text(encoding="utf-8")
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    for token in (
        "Progress priority is not exclusive movement authority",
        "positively available recovery corridor",
        "Protect the recovery obligation, not the clock",
        "Obligation retirement defines progress",
    ):
        assert token in adr23
    assert "stage evidence versus operational authority" in adr22
    assert "BNIR evidence lifetime across restoration" in adr9
    assert "entitlement to unrestricted speed" in architecture
    assert "Purpose-bound supporting speed — refined" in glossary
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in runtime


def test_v4730_encounter_maturation_architecture_is_documented_without_production_control():
    adr23=(ROOT/"docs"/"adr"/"ADR-0023-traffic-policeman-movement-priority.md").read_text(encoding="utf-8")
    adr6=(ROOT/"docs"/"adr"/"ADR-0006-future-space-safe-release.md").read_text(encoding="utf-8")
    adr19=(ROOT/"docs"/"adr"/"ADR-0019-replacement-core-commitment-lifecycle.md").read_text(encoding="utf-8")
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    concepts=(ROOT/"docs"/"CONCEPT_REGISTER.md").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    for token in ("Encounter Maturation","Action-Space Compression"):
        assert token in adr23
        assert token in architecture
        assert token in glossary
        assert token in concepts
    assert "Bounded Observation Contract" in adr23
    assert "Action-Space Compression" in adr6
    assert "Preference-Band Exhaustion" in adr23
    assert "must not deliberately wait" in architecture
    assert "Continuing Intent Priority" in adr19
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in runtime


def test_v4731_productive_continuation_probe_is_passive_and_speed_non_authoritative():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"ProductiveContinuationProbe.lua").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_21_PRODUCTIVE_CONTINUATION_EVIDENCE.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    assert "scripts/diagnostics/ProductiveContinuationProbe.lua" in main
    assert "productiveContinuationProbe" in main
    for token in (
        "PRODUCTIVE_CONTINUATION_PROBE_ENABLED",
        "PRODUCTIVE_CONTINUATION_PROBE_INTERVAL_MS",
        "PRODUCTIVE_CONTINUATION_PROBE_HEARTBEAT_MS",
    ):
        assert token in config
    for token in (
        "getActiveSegmentData",
        "isInitial",
        "implementData",
        "isLowered",
        "lastContinueWorkState",
        "lastMovingDirection",
        "getCruiseControlState",
        "getCruiseControlSpeed",
        "getCruiseControlMaxSpeed",
        "getSpeedLimit",
        "NON_TURN_LINE_ACTIVE",
        "NON_TURN_LINE_INACTIVE",
        "TURN_SEGMENT",
    ):
        assert token in probe
    for forbidden in (
        "stopCurrentAIJob(",
        "driveToPoint(",
        "setCruiseControlState(",
        "setCruiseControlMaxSpeed(",
        "setSpeedLimit(",
        "Utils.overwrittenFunction",
        "decisionCommitmentBoundary:apply",
    ):
        assert forbidden not in probe
    for token in (
        "low-cruise falsification",
        "absolute speed",
        "does not classify Traffic Policeman priority",
        "naturally occurring non-headland repositioning",
        "contrasting assembly",
    ):
        assert token in protocol
    assert "no 25/15/10 km/h literal receives semantic authority" in decision


def test_v4732_productive_continuation_preference_is_documented_without_production_control():
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    adr23=(ROOT/"docs"/"adr"/"ADR-0023-traffic-policeman-movement-priority.md").read_text(encoding="utf-8")
    adr6=(ROOT/"docs"/"adr"/"ADR-0006-future-space-safe-release.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    concepts=(ROOT/"docs"/"CONCEPT_REGISTER.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_21_PRODUCTIVE_CONTINUATION_EVIDENCE.md").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    for token in (
        "Productive Continuation Preference",
        "Productive-Line Cross-Assembly Replication",
        "GIANTS Turn-Segment Breadth",
        "Apparent Departure Reversal",
    ):
        assert token in glossary
        assert token in concepts
    assert "otherwise-roomy" in adr23
    assert "Absolute speed" in adr23
    assert "tie" in adr23.lower()
    assert "Apparent Departure Reversal" in adr6
    assert "D-0113" in decision
    assert "LIVE EVIDENCE GATE PASSED" in protocol
    assert "10 km/h" in protocol and "18 km/h" in protocol and "25 km/h" in protocol
    assert "Productive Continuation Preference" in architecture
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in runtime


def test_v4733_speed_ordering_evidence_asymmetry_and_configuration_footprint_authority():
    concepts=(ROOT/"docs"/"CONCEPT_REGISTER.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    physical=(ROOT/"docs"/"PHYSICAL_REPRESENTATION_ARCHITECTURE.md").read_text(encoding="utf-8")
    adr23=(ROOT/"docs"/"adr"/"ADR-0023-traffic-policeman-movement-priority.md").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_21_PRODUCTIVE_CONTINUATION_EVIDENCE.md").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'VERSION = "4.7.41"' in config
    for token in (
        "Native Speed-Ordering Variability",
        "Productive-State Evidence Asymmetry",
        "Alternating Working-Side Configuration",
        "Configuration Footprint Authority",
    ):
        assert token in concepts
        assert token in glossary
    assert "D-0114" in decision
    assert "line=INACTIVE" in decision or "line `INACTIVE`" in decision
    assert "~12.2 km/h" in decision and "~15 km/h" in decision
    assert "provenance only" in physical
    assert "realised component footprint" in physical
    assert "materially equivalent footprint domain" in physical
    assert "inactive line state alone" in adr23
    assert "supportable interruption state" in adr23
    assert "P21-F" in protocol
    assert "12.2 km/h" in protocol and "15 km/h" in protocol
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in runtime


def test_v4736_prototype22_is_manual_capability_gate_not_production_traffic_policeman():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    permission=(ROOT/"scripts"/"prototypes"/"Prototype22PermissionGate.lua").read_text(encoding="utf-8")
    drive=(ROOT/"scripts"/"prototypes"/"Prototype22DriveAuthority.lua").read_text(encoding="utf-8")
    configuration=(ROOT/"scripts"/"prototypes"/"Prototype22ConfigurationAuthority.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")

    assert 'VERSION = "4.7.41"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    assert 'PROTOTYPE_22_CAPABILITY_GATE_ENABLED = true' in config
    for rel in (
        "scripts/prototypes/Prototype22PermissionGate.lua",
        "scripts/prototypes/Prototype22DriveAuthority.lua",
        "scripts/prototypes/Prototype22ConfigurationAuthority.lua",
        "scripts/prototypes/Prototype22CapabilityGate.lua",
    ):
        assert rel in main
    assert "prototype22CapabilityGate" in main
    assert 'addConsoleCommand("otmP22"' in gate
    assert "#vehicles < 2" in gate
    assert "self.run ~= nil" in gate
    assert "automaticDecision=false" in gate
    assert "decisionCommitmentBoundary:apply" not in gate
    assert "DecisionSelector" not in gate
    assert "SituationAssessment" not in gate
    assert "getCanAIFieldWorkerContinueWork" in permission
    assert "return false, false, nil" in permission
    assert "AIVehicleUtil.driveToPoint" in drive
    assert "getToggledFoldDirection" in configuration
    assert "setFoldDirection" in configuration
    assert "setLowered" in configuration
    assert 'state.mode == "REGULATE"' in drive
    assert 'state.mode == "REPOSITION"' in drive
    assert "moveForwards=true" in gate
    assert "REVERSE_REPOSITION_UNRESOLVED" in gate
    assert "target-clearance" in protocol.lower()
    assert "participant-complete" in protocol
    assert "D-0116" in decision
    assert "Control authority disabled" in runtime
    assert "decisionCommitmentBoundary:apply" not in runtime


def test_v4736_regulation_preserves_giants_route_direction_and_reposition_is_one_forward_leg():
    drive=(ROOT/"scripts"/"prototypes"/"Prototype22DriveAuthority.lua").read_text(encoding="utf-8")
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md").read_text(encoding="utf-8")

    assert "Preserve GIANTS route, steering, acceleration, permission" in drive
    assert "return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, outputMax)" in drive
    assert "return original(vehicle, dt, 1, true, true, localX, localZ, cap)" in drive
    assert "forwardM < 0" in gate
    assert "reverse Reposition is architecturally valid but UNRESOLVED" in gate
    assert "same Hold remains active" in protocol
    assert "operator-selected" in protocol


def test_v4736_p22_spatial_reposition_requires_real_compaction_and_allows_fold_move_overlap():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    configuration=(ROOT/"scripts"/"prototypes"/"Prototype22ConfigurationAuthority.lua").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")

    assert 'VERSION = "4.7.41"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    assert 'PROTOTYPE_22_HUD_ENABLED = true' in config
    assert 'PROTOTYPE_22_SPAN_REDUCTION_MIN_M' in config
    assert 'Prototype22ConfigurationAuthority.lua' in (ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    assert 'REPOSITION_COMPACT_START' in gate
    assert 'movementOverlap=WAIT_FOR_ACTUAL_FOLD_MOTION' in gate
    assert 'foldMovementOverlap=true' in gate
    assert 'fold.motionObserved' in gate
    assert 'fold.allFolded and targetSettled' in gate
    assert 'run.initialSpanM - span' in gate
    assert 'REPOSITION_SPATIAL_PASS' in gate
    assert 'REPOSITION_SPATIAL_UNRESOLVED' in gate
    assert 'REPOSITION_RESTORE_PASS' in gate
    assert 'SUMMARY kind=%s' in gate
    assert 'OTM P22 — REPOSITION PASS' in gate
    assert 'foldAnimTime' in configuration
    assert 'spatial PASS is established separately' in configuration
    assert 'does not require full folding before movement' in protocol.lower()
    assert 'foldanimtime' in protocol.lower() and 'diagnostic' in protocol.lower()
    assert 'D-0117' in decision


def test_v4737_ts015_autonomous_relocation_characterisation_harness_is_explicit_and_non_production():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    harness=(ROOT/"scripts"/"prototypes"/"Prototype22TS015Relocation.lua").read_text(encoding="utf-8")

    assert 'VERSION = "4.7.41"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    assert 'Prototype22TS015Relocation.lua' in main
    assert main.index('Prototype22TS015Relocation.lua') < main.index('Prototype22CapabilityGate.lua')
    assert 'action == "relocate"' in gate
    assert 'TS015_RELOCATE' in gate

    # One explicit command may orchestrate the complete evidence fixture, but
    # no production Decision/Traffic-Policeman path may arm it.
    assert 'PROTOTYPE_22_TS015_RELOCATE_ENABLED = true' in config
    assert 'PROTOTYPE_22_TS015_REPOSITION_SPEED_KMH = 15.0' in config
    assert 'PROTOTYPE_22_TS015_REFUGE_LATERAL_M = 30.0' in config
    assert 'PROTOTYPE_22_TS015_REFUGE_FORWARD_M = 10.0' in config
    assert 'PROTOTYPE_22_TS015_MIN_TOTAL_REFUGE_HOLD_MS = 20000' in config
    assert 'PROTOTYPE_22_TS015_OBSERVE_MS = 120000' in config
    assert 'requires exactly two active GIANTS AI field workers' in harness
    assert 'P22 TS015 requires selected Yield assembly fully deployed' in harness
    assert 'sameSourceField' in harness and 'qualifyTarget' in harness
    assert 'obstacleClearance=OPERATOR_OWNED productionAuthority=false' in harness
    assert 'targetClearanceAuthority=FIXTURE_ONLY' in harness
    assert 'basis=PROBE_LITERAL_NOT_SAFE_RELEASE_AUTHORITY' in harness
    assert 'handsOff=true' in harness
    assert 'result=CHARACTERISED' in harness
    assert 'COMPACT_CONFIRMED_DURING_MOVE' in harness
    assert 'watchdog=RETIRED_FOR_MANOEUVRE' in harness
    assert 'run.fullCompactObservedAt == nil and nowMs - (run.targetReachedAt or nowMs)' in harness
    assert 'target-full-compact-timeout' in harness
    assert 'nowMs - (run.compactRequestedAt or nowMs) >= (OuttaMyWay.PROTOTYPE_22_FULL_COMPACT_TIMEOUT_MS' not in harness
    assert 'setReposition' in harness
    assert 'requestRestore' in harness
    assert '_releaseImmediate' in harness
    assert 'DecisionSelector' not in harness
    assert 'SituationAssessment' not in harness
    assert 'SafeRelease' not in harness


def test_v4739_ts015_restoration_first_handoff_returns_to_rejoin_anchor_before_giants_release():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    harness=(ROOT/"scripts"/"prototypes"/"Prototype22TS015Relocation.lua").read_text(encoding="utf-8")
    drive=(ROOT/"scripts"/"prototypes"/"Prototype22DriveAuthority.lua").read_text(encoding="utf-8")

    assert 'VERSION = "4.7.41"' in config
    assert 'PROTOTYPE_22_TS015_REJOIN_FORWARD_M = 6.0' in config
    assert 'PROTOTYPE_22_TS015_REJOIN_ORIENTATION_SPEED_KMH = 5.0' in config
    assert 'PROTOTYPE_22_TS015_REJOIN_ORIENTATION_FORWARD_DOT = 0.25' in config
    assert 'run.rejoinAnchorX, run.rejoinAnchorZ = anchor.x, anchor.z' in harness
    assert 'run.rejoinTargetX = anchor.x + anchor.dx * rejoinForwardM' in harness
    assert 'TS015_REJOIN_ORIENTING' in harness
    assert 'TS015_REJOINING' in harness
    assert 'TS015_REJOIN_SETTLING' in harness
    assert 'TS015_REJOIN_RESTORING' in harness
    assert 'NATIVE_CONTINUATION_RESTORATION_PASS' in harness
    assert 'ts015-restoration-first-handoff' in harness
    assert 'setRepositionOrientation' in drive
    assert 'mode = "REPOSITION_ORIENT"' in drive
    assert 'legacyMechanismEvidenceOnly=true policyAuthority=false' in harness

    # Direct refuge release is deliberately absent from the autonomous success path.
    assert 'ts015-autonomous-timed-handoff' not in harness
    assert 'TIMED_RELEASE_READY' not in harness
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config


def test_v4740_guarded_recovery_architecture_consolidation_preserves_non_production_boundary():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    handover=(ROOT/"docs"/"ENGINEERING_HANDOVER.md").read_text(encoding="utf-8")
    protocol=(ROOT/"docs"/"prototypes"/"PROTOTYPE_22_TRAFFIC_POLICEMAN_CAPABILITY_GATE.md").read_text(encoding="utf-8")

    assert 'VERSION = "4.7.41"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    for token in (
        "Native Continuation Restoration",
        "Rejoin Anchor",
        "Guarded Recovery",
        "Protected Progress Alternation",
        "Expedient Manoeuvre Execution",
    ):
        assert token in architecture
        assert token in glossary
        assert token in decision
    assert "D-0122" in decision
    assert "greatest speed positively supportable" in decision
    assert "Precision Farming is not part of the standard OuttaMyWay test environment" in decision
    assert "standard testing remains DLC-free" in handover
    assert "does **not** implement Guarded Recovery" in protocol
    assert "Situation Assessment evidence contract" in handover


def test_v4741_guarded_recovery_observe_exhaustion_contract_is_documented_without_production_control():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    architecture=(ROOT/"docs"/"ARCHITECTURE.md").read_text(encoding="utf-8")
    glossary=(ROOT/"docs"/"GLOSSARY.md").read_text(encoding="utf-8")
    concepts=(ROOT/"docs"/"CONCEPT_REGISTER.md").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    roadmap=(ROOT/"docs"/"ROADMAP.md").read_text(encoding="utf-8")

    assert 'VERSION = "4.7.41"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    assert "D-0123" in decision
    for token in ("Vulnerable Space", "Convergent Projection"):
        assert token in architecture
        assert token in glossary
        assert token in concepts
        assert token in decision
    assert "CONTINUE_OBSERVATION` is exhausted" in decision
    assert "REGULATE_SPEED" in decision and "HOLD_AT_SAFE_POINT" in decision
    assert "fully reacquired native authority" in decision
    assert "not traffic settlement" in decision.lower()
    assert "no permanent exclusion zone" in decision.lower()
    assert "fixed-distance" in decision.lower() and "TCPA/DCPA" in decision
    assert "passively" in roadmap.lower() and "validate" in roadmap.lower()
