from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ARCHIVE = ROOT / "scripts" / "archive"


def test_active_loader_never_sources_archive_or_legacy_core():
    text = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    assert "scripts/archive/" not in text
    for forbidden in ("scripts/core/", "scripts/observer/"):
        assert forbidden not in text
    assert "scripts/control/LiveControlDispatcher.lua" in text
    assert "scripts/control/CooperativePassageControl.lua" in text
    assert text.count("scripts/control/") == 4



def test_active_lua_tree_is_small_and_archive_independent():
    active = [p for p in (ROOT / "scripts").rglob("*.lua") if "archive" not in p.parts]
    assert active
    for path in active:
        text = path.read_text(encoding="utf-8")
        assert "archive/v4_6_78" not in text
        assert "TrafficDecisionEngineV2" not in text
        assert "UnilateralSidestepController" not in text
        assert "EncounterController" not in text


def test_d0184_retired_passage_and_fixture_implementation_is_deleted_not_archived():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    lifecycle=(ROOT/"scripts"/"commitment"/"LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")

    assert not ARCHIVE.exists()
    for rel in (
        "scripts/assessment/CooperativePassageAssessment.lua",
        "scripts/prototypes/Prototype22TS015Relocation.lua",
        "scripts/prototypes/CommittedTransitionRegulationTestBridge.lua",
        "scripts/prototypes/GuardedRecoveryRegulationTestBridge.lua",
    ):
        assert not (ROOT/rel).exists()
        assert rel not in main

    for token in ("TS015_RELOCATE","Prototype22TS015Relocation","CommittedTransitionRegulationTestBridge","P22_TS015_CONTROL_EXECUTION_OBSERVATION"):
        assert token not in gate
    assert 'request.capability=="REPOSITION"' not in gate
    assert 'otmP22 reposition' not in gate
    assert 'otmP22 relocate' not in gate
    assert 'function Control:_beginRestore(run)' not in control
    assert 'requestRestore(run.a.vehicle)' not in control

    assert 'OuttaMyWay.D0123_NATIVE_HANDOVER_CREEP_KMH = 1.0' in config
    assert 'GUARDED_RECOVERY_REGULATION_TEST_KMH' not in config
    assert 'GUARDED_RECOVERY_REGULATION_TEST_ENABLED' not in config
    assert 'GUARDED_RECOVERY_REGULATION_TEST_HEARTBEAT_MS' not in config
    assert 'PROTOTYPE_22_TS015_' not in config
    assert 'D0123_NATIVE_HANDOVER_CREEP_KMH or 1.0' in dispatcher

    assert 'D0143_COOPERATIVE_PASSAGE_REVISE' not in lifecycle
    assert 'D0143_POSITIVE_RESTORATION_AND_HANDOFF' not in lifecycle
    assert 'decision="D-0143"' not in lifecycle
    assert 'D0146_COOPERATIVE_PASSAGE_REVISE' in lifecycle
    assert 'D0146_POSITIVE_RESTORATION_AND_HANDOFF' in lifecycle

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
    assert (ROOT / "scripts" / "control" / "LiveControlDispatcher.lua").is_file()
    control = (ROOT / "scripts" / "control" / "LiveControlDispatcher.lua").read_text(encoding="utf-8")
    assert "DecisionSelector" not in control
    assert "SituationAssessment" not in control
    assert "executeControlRequest" in control
    assert "ControlRequest.new" in control



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
    assert (ROOT / "scripts" / "control" / "LiveControlDispatcher.lua").is_file()
    assessment = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    for token in ("CandidateSpace", "DecisionSelector", "LiveControlDispatcher", "Prototype22CapabilityGate"):
        assert token not in assessment



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


def test_d0143_adds_one_bounded_control_module_beside_the_central_dispatcher():
    control_dir = ROOT / "scripts" / "control"
    assert control_dir.is_dir()
    assert sorted(p.name for p in control_dir.glob("*.lua")) == ["CooperativePassageControl.lua", "LiveControlDispatcher.lua", "ResolutionSpaceProgressionEnvelope.lua", "TerminalEgressControl.lua"]
    dispatcher = (control_dir / "LiveControlDispatcher.lua").read_text(encoding="utf-8")
    for token in ("g_currentMission", "AIVehicleUtil.driveToPoint", "getCanAIFieldWorkerContinueWork"):
        assert token not in dispatcher
    cooperative = (control_dir / "CooperativePassageControl.lua").read_text(encoding="utf-8")
    assert "executeJointRequests" in cooperative
    assert "CooperativePassageControl requires the existing physical capability donor" in cooperative
    terminal = (control_dir / "TerminalEgressControl.lua").read_text(encoding="utf-8")
    assert "POST_JOB_ACTUATION" in terminal
    assert "D0147_TERMINAL_YIELD_EXHAUSTION" in terminal



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
    text=(ROOT/"tests"/"replay"/"HistoricalFixtures.lua").read_text(encoding="utf-8")
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
    assert "JOB_EPISODE_END_EVIDENCE" in source


def test_v476_activity_onset_tokens_and_unresolved_termination_are_explicit():
    text=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assert "OBSERVED_NATIVE_AI_ACTIVITY_EPISODE" in text
    assert "JOB_EPISODE_END_EVIDENCE" in text
    assert "observed-ai-episode:" in text
    assert "sourceJobEndEvidence" in text


def test_v476_trace_reports_candidate_verdict_diagnostics():
    text=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    for token in ("candidateCount","allPassCandidateCount","unresolvedCandidateCount","failedCandidateCount","unavailableSourceCount"):
        assert token in text
    assert "decisionCommitmentBoundary:apply" not in text



def test_v478_targeted_job_episode_and_field_identity_path_is_active():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    assert "scripts/observation/LiveAIJobEvidence.lua" in main
    assert "scripts/diagnostics/TargetedFieldIdentityProbe.lua" in main
    assert "scripts/runtime/LiveRuntimeCoordinator.lua" in main
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    coordinator=(ROOT/"scripts"/"runtime"/"LiveRuntimeCoordinator.lua").read_text(encoding="utf-8")
    assert "GIANTS_ACTIVE_JOB_IDENTITY" in source
    assert "activeJobVehicleMembership" in source
    assert "observeRuntimeResult" in validator
    assert "processLiveObservation" not in validator
    assert "self.runtime.processLiveObservation" in coordinator
    assert main.index("addModEventListener(OuttaMyWay.liveRuntimeCoordinator)") < main.index("addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)")



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
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config


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
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config


def test_v4711_parallel_validation_reports_global_operation_count():
    trace=(ROOT/"scripts"/"contracts"/"PassiveLiveTraceRecord.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    assert "globalActiveOperationCount" in trace
    assert "globalOperations=%d" in validator
    assert "decisionCommitmentBoundary:apply" not in validator


def test_source_job_end_is_positive_giants_evidence_and_not_a_parallel_terminal_cause():
    evidence=(ROOT/"scripts"/"observation"/"LiveAIJobEvidence.lua").read_text(encoding="utf-8")
    for token in ("spec_aiJobVehicle.lastJob","jobActiveInMission","PREVIOUS_JOB_RETAINED_AS_LAST_JOB_AND_NO_LONGER_ACTIVE","sourceJobEndEvidence"):
        assert token in evidence
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assert "sourceJobEndEvidence" in source
    admission=(ROOT/"scripts"/"identity"/"JobEpisodeAdmission.lua").read_text(encoding="utf-8")
    assert "sourceJobEnded" in admission
    terminal=(ROOT/"scripts"/"assessment"/"TerminalOccupancyAssessment.lua").read_text(encoding="utf-8")
    assert 'terminalCause=="SOURCE_INTENT_TERMINATION"' not in terminal
    live_code="\n".join(p.read_text(encoding="utf-8") for p in (ROOT/"scripts").rglob("*.lua"))
    assert "sourceIntentTerminationObserved" not in live_code
    assert 'cause="SOURCE_INTENT_TERMINATION"' not in live_code


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
    assert "D-0146 Step-1 Situation Knowledge is live-validated and Step-2 Established Conflict -> Candidate-owned Local Passage Search -> Passage Guide -> Commitment/Control is ACTIVE" in runtime
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
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config
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
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config
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
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config
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
    assert "D-0146 Step-1 Situation Knowledge is live-validated and Step-2 Established Conflict -> Candidate-owned Local Passage Search -> Passage Guide -> Commitment/Control is ACTIVE" in runtime
    for text in (source,intent,future,assessment,hud,validator,runtime):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text

def test_v4722_incomplete_membership_cannot_preempt_job_episode_terminal_evidence():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    operation=(ROOT/"scripts"/"identity"/"OperationAdmission.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    hud=(ROOT/"scripts"/"diagnostics"/"TransitionHud.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config
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
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'RUNTIME_MODE = "ARCHITECTURE_AUTHORITY_ALIGNMENT"' in config
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
    assert "d0143CooperativePassage=false" in runtime and "d0143MechanicalDonorHistoricalOnly=true" in runtime and "kingRetired=true" in runtime and "generalControl=false" in runtime
    for text in (source,assessment,hud,validator,runtime):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text


def test_v4731_productive_continuation_probe_is_passive_and_speed_non_authoritative():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"ProductiveContinuationProbe.lua").read_text(encoding="utf-8")
    observation=(ROOT/"scripts"/"observation"/"NativeFieldWorkObservation.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    assert "scripts/observation/NativeFieldWorkObservation.lua" in main
    assert "scripts/diagnostics/ProductiveContinuationProbe.lua" in main
    assert "SituationAssessment.ProductiveContinuation" in assessment
    assert "productiveContinuationKnowledge" in assessment
    assert "nativeFieldWork" in assessment
    assert "SituationAssessment-owned Productive Continuation" in probe
    for token in ("getActiveSegmentData", "getCruiseControlSpeed", "getSpeedLimit", "driveToPoint(", "decisionCommitmentBoundary:apply"):
        assert token not in probe
    assert "semanticAuthority=false" in observation



def test_v4742_traffic_policeman_decision_policy_current_implementation_contract():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    selector=(ROOT/"scripts"/"decision"/"DecisionSelector.lua").read_text(encoding="utf-8")
    policy=(ROOT/"scripts"/"decision"/"TrafficPolicemanDecisionPolicy.lua").read_text(encoding="utf-8")
    passive=(ROOT/"scripts"/"candidates"/"PassiveLiveCandidateSupport.lua").read_text(encoding="utf-8")

    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'CONTROL_AUTHORITY_ENABLED = false' in config
    assert 'TrafficPolicemanDecisionPolicy.lua' in main
    assert main.index('TrafficPolicemanDecisionPolicy.lua') < main.index('DecisionSelector.lua')
    assert 'TRAFFIC_POLICEMAN_SEQUENTIAL_PRIMARY' in policy
    for capability in ('CONTINUE_OBSERVATION','REGULATE_SPEED','HOLD','REPOSITION','ESCALATE'):
        assert capability in policy
    assert 'STALE_OPERATIONAL_PICTURE' in policy
    assert 'completeSupportableAutonomousSpace' in policy
    assert 'participantComplete' in policy
    assert 'WAIT_FOR_PREFERENCE_EXHAUSTION_EVIDENCE' in selector
    assert 'TrafficPolicemanDecisionPolicy:select' in selector
    assert 'PASSIVE_LIVE_ZERO_CONTROL' in passive



def test_v4745_guarded_recovery_convergence_probe_is_parallel_shadow_only():
    probe=(ROOT/"scripts"/"diagnostics"/"GuardedRecoveryConvergenceProbe.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"GuardedRecoveryThreatAssessment.lua").read_text(encoding="utf-8")
    situation=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    assert "Situation-owned Guarded Recovery Knowledge" in probe
    assert "evaluateGeometry" in assessment and "evaluateCurrentHeadingSignal" in assessment
    assert "guardedRecoveryKnowledge" in situation
    for token in ("setRegulationLease", "executeControlRequest", "addModEventListener", "decisionCommitmentBoundary"):
        assert token not in probe




def test_v4746_d0123_regulation_bridge_is_bounded_test_authority_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    assert "scripts/prototypes/GuardedRecoveryRegulationTestBridge.lua" not in main
    assert "D0123_GUARDED_RECOVERY" in control
    assert "REGULATE_SPEED" in control
    assert "GUARDED_RECOVERY_D0123" in candidate
    assert "boundedObservationContract" in candidate



def test_v4753_d0124_persistent_follower_boundary_demand_lifecycle_is_bounded_test_only():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"FollowerMaturationCompressionProbe.lua").read_text(encoding="utf-8")
    assert "FOLLOWER_MATURATION_REGULATION_TEST_ENABLED = false" in config
    assert "boundaryDemandFitness" in probe and "UNRESOLVED" in probe
    assert "boundaryDemandAuthority=false" in probe
    assert "control=false" in probe
    for token in ("setDriveAuthoritySource", "setRegulationLease", "_applyOrUpdate"):
        assert token not in probe



def test_v4754_resolution_strategy_succession_contract():
    probe=(ROOT/"scripts"/"diagnostics"/"FollowerMaturationCompressionProbe.lua").read_text(encoding="utf-8")
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    assert "RESOLUTION_STRATEGY_SUPERSEDED_BY_" not in probe
    assert "PROGRESS_PASSAGE" not in probe
    assert "PROGRESS_PASSAGE" not in gate
    assert "PRESERVE_BOUNDARY_TRANSITION_CLEARANCE_SHADOW" in probe



def test_v4755_transition_clearance_factor_and_hud_consolidation_are_bounded():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"FollowerMaturationCompressionProbe.lua").read_text(encoding="utf-8")
    hud=(ROOT/"scripts"/"diagnostics"/"FollowerPacingHud.lua").read_text(encoding="utf-8")
    assert "FOLLOWER_MATURATION_TRANSITION_CLEARANCE_FACTOR = 0.90" in config
    assert "hypotheticalAfterTestFactor" in probe
    assert "boundaryDemandAuthority=false" in probe
    assert "control=false" in probe
    assert "Follower" in hud or "follower" in hud



def test_v4756_deferred_native_sweep_closure_is_fail_closed_and_freezes_measurement():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"NativeManoeuvreObservationSource.lua").read_text(encoding="utf-8")
    assert "scripts/observation/NativeManoeuvreObservationSource.lua" in main
    assert "scripts/diagnostics/HeadlandManoeuvreSweepProbe.lua" not in main
    assert "WAITING_FOR_EVIDENCE" in source
    assert "GIANTS_TURN_SEGMENT_ENDED_AFTER_WAITING_FOR_EVIDENCE" in source
    assert "representationFitnessForBoundaryDemand" in source and "UNRESOLVED" in source
    assert "boundaryDemandAuthority=false" in source



def test_d0181_d0143_runtime_literals_and_resurrection_switch_are_retired():
    config=(ROOT/"scripts/config.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts/candidates/LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts/control/LiveControlDispatcher.lua").read_text(encoding="utf-8")
    for token in (
        "COOPERATIVE_PASSAGE_TS015_ENABLED",
        "COOPERATIVE_PASSAGE_TS015_MIN_START_SEPARATION_M",
        "COOPERATIVE_PASSAGE_TS015_MAX_START_SEPARATION_M",
        "COOPERATIVE_PASSAGE_LATERAL_OFFSET_M",
        "COOPERATIVE_PASSAGE_SIDESTEP_FORWARD_M",
        "COOPERATIVE_PASSAGE_PASS_MARGIN_M",
        "COOPERATIVE_PASSAGE_POST_PASS_FORWARD_M",
        "COOPERATIVE_PASSAGE_MOVE_SPEED_KMH",
    ):
        assert token not in config
    assert "TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST" not in support
    assert 'bridge.architecture~="D0146_STEP2"' in dispatcher
    assert 'kind="D0146_COOPERATIVE_PASSAGE"' in dispatcher

def test_v4758_progression_preservation_probe_is_passive_and_knowledge_backed():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    op=(ROOT/"scripts"/"contracts"/"OperationalPicture.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"ProgressionPreservationProbe.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'PROGRESSION_PRESERVATION_PROBE_ENABLED = true' in config
    assert 'scripts/diagnostics/ProgressionPreservationProbe.lua' in main
    assert 'progressionEvidence = {}' in source
    assert 'LIVE_MOTION_DIAGNOSTIC_PLUS_GIANTS_LOCAL_INTENT' in source
    assert 'motionEvidence=motionEvidence' in assessment
    assert 'physicalSpaceEvidence=physicalSpaceEvidence' in assessment
    assert 'openObligations=openObligations' in assessment
    assert '"motionEvidence", "physicalSpaceEvidence"' in op
    assert 'setProgressionPreservationProbe' in validator
    assert 'responseAdjustedSupportableProgression="UNRESOLVED"' in probe
    assert 'negativeClearanceAuthority=false' in probe
    assert 'speedAuthority=false' in probe and 'controlAuthority=false' in probe
    assert 'WITNESS_OPEN' in probe and 'consumedFromBaseline' in probe and 'WITNESS_INVALIDATED' in probe
    assert 'MATURATION_WITNESS' in probe and 'COMMITTED_DEMAND' in probe and 'CURRENT_SPACE' in probe



def test_v4759_d0130_purpose_preserving_regulation_catchup():
    probe=(ROOT/"scripts"/"diagnostics"/"FollowerMaturationCompressionProbe.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert "CAP_RELAXATION_REJECTED_PURPOSE_PERSISTS" not in probe
    assert "FOLLOWER_MATURATION_REGULATION_TEST_ENABLED = false" in config
    assert "hypotheticalCapKmh" in probe
    assert "setRegulationLease" not in probe



def test_v4765_d0136_productive_coverage_residual_settlement_is_intent_based_and_passive():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    residual=(ROOT/"scripts"/"diagnostics"/"ProductiveCoverageResidualProbe.lua").read_text(encoding="utf-8")
    coverage=(ROOT/"scripts"/"diagnostics"/"DemonstratedProductiveCoverageProbe.lua").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_ENABLED = false' in config
    assert 'scripts/diagnostics/ProductiveCoverageResidualProbe.lua' not in main
    assert 'addModEventListener(OuttaMyWay.productiveCoverageResidualProbe)' not in main
    assert 'FIRST_POSITIVE_PRODUCTIVE_CORRIDOR_BACK_TO_FIELD_WORLD_BOUNDARY' in residual
    assert 'unpaintedIsNotDemand=true' in residual
    assert 'interpretation=POTENTIAL_PRODUCTIVE_DEMAND_ONLY' in residual
    assert 'NATIVE_CONVERGENCE_OBSERVED' in residual
    assert 'RESIDUAL_INTENT_SETTLED' in residual
    assert 'RESIDUAL_GEOMETRICALLY_FILLED' in residual
    assert 'geometricCompletionRequired=false' in residual
    assert 'PRODUCTIVE_REENTRY_OBSERVED' in residual
    assert 'COHERENT_RETURN_CONSUMPTION_OBSERVED' in residual
    assert 'ORIGINATING_PRODUCTIVE_REGION_REACQUIRED' in residual
    assert 'Productive-to-GIANTS-turn' not in residual  # implementation uses machine-readable witness token
    assert 'SETTLEMENT_REASSESSMENT' in residual
    assert 'action=NO_ACTUATION' in residual
    assert 'regulationAuthority=false holdAuthority=false' in residual
    assert 'getWorkingSegment' in coverage and 'isCellDemonstrated' in coverage
    assert 'D-0136' in decision and 'native intent' in decision




def test_v4798_d0144_unsources_chessboard_productive_history_and_refuge_shadow_from_live_runtime():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    for rel in (
        "scripts/diagnostics/DemonstratedProductiveCoverageProbe.lua",
        "scripts/diagnostics/ProductiveCoverageResidualProbe.lua",
        "scripts/diagnostics/RefugeQualificationShadowProbe.lua",
    ):
        assert rel not in main
    assert 'DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_ENABLED = false' in config
    assert 'PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_ENABLED = false' in config
    assert 'REFUGE_QUALIFICATION_SHADOW_PROBE_ENABLED = false' in config
    # Historical files remain in-repository as evidence donors rather than being silently deleted.
    assert (ROOT/"scripts"/"diagnostics"/"DemonstratedProductiveCoverageProbe.lua").is_file()
    assert (ROOT/"scripts"/"diagnostics"/"ProductiveCoverageResidualProbe.lua").is_file()
    assert (ROOT/"scripts"/"diagnostics"/"RefugeQualificationShadowProbe.lua").is_file()

def test_v4767_d0138_native_field_worker_drive_command_probe_is_passive_and_sdk_aligned():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    probe=(ROOT/"scripts"/"diagnostics"/"NativeFieldWorkerDriveCommandProbe.lua").read_text(encoding="utf-8")
    refuge=(ROOT/"scripts"/"diagnostics"/"RefugeQualificationShadowProbe.lua").read_text(encoding="utf-8")
    residual=(ROOT/"scripts"/"diagnostics"/"ProductiveCoverageResidualProbe.lua").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    d0137=(ROOT/"docs"/"research"/"prototypes"/"PROTOTYPE_32_NATIVE_AI_DRIVE_SIGNAL_SHADOW.md").read_text(encoding="utf-8")
    d0138=(ROOT/"docs"/"research"/"prototypes"/"PROTOTYPE_33_NATIVE_FIELD_WORKER_DRIVE_COMMAND_SHADOW.md").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'NATIVE_FIELD_WORKER_DRIVE_COMMAND_PROBE_ENABLED = true' in config
    assert 'scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua' in main
    assert 'addModEventListener(OuttaMyWay.nativeFieldWorkerDriveCommandProbe)' in main
    assert 'spec_aiFieldWorker' in probe and 'aiDriveParams' in probe
    assert 'params.moveForwards' in probe and 'params.tX' in probe and 'params.tZ' in probe and 'params.maxSpeed' in probe
    assert 'getDriveData()' in probe and 'never calls' in probe
    assert 'driveToPoint' in probe and 'never' in probe
    assert 'vehicle.aiDriveDirection' in probe and 'falsified' in probe
    assert 'routePrediction=false' in probe and 'futureSpaceAuthority=false' in probe
    assert 'refugeSelectionAuthority=false' in probe and 'controlAuthority=false' in probe
    assert 'candidateRelation' in probe and 'nativeCommandTargetDelta' in refuge and 'nativeCommandTargetDistance' in refuge
    assert 'selectionInfluence=false' in refuge and 'nativeCommandRoutePrediction=false' in refuge
    assert 'track.active==true' in residual and 'Probe.trackIsActive(otherTrack)' in residual
    assert 'RESIDUAL_INTENT_SETTLED_OTHER' in residual
    assert 'D-0137' in decision and 'falsified' in decision
    assert 'D-0138' in decision and 'aiDriveParams' in decision
    assert 'Result — falsified' in d0137
    assert 'Fast falsification' in d0138


def test_v4768_d0136_settlement_future_space_uses_explicit_observation_adapter():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    residual=(ROOT/"scripts"/"diagnostics"/"ProductiveCoverageResidualProbe.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'futureSpaceWorkerFromTrack' in residual
    assert 'activeObserved=Probe.trackIsActive(track)' in residual
    assert 'local settlingWorker=Probe.futureSpaceWorkerFromTrack(settlingTrack)' in residual
    assert 'local otherWorker=Probe.futureSpaceWorkerFromTrack(otherTrack)' in residual
    assert 'FieldBoundedFutureSpace.build(settlingWorker)' in residual
    assert 'FieldBoundedFutureSpace.build(otherWorker)' in residual
    assert 'FieldBoundedFutureSpace.evaluatePair(settlingWorker,otherWorker' in residual
    assert 'FieldBoundedFutureSpace.build(settlingTrack)' not in residual
    assert 'FieldBoundedFutureSpace.build(otherTrack)' not in residual
    assert 'track.activeObserved=' not in residual
    assert 'settlementFutureSpaceInput=PERSISTENT_TRACK_TO_OBSERVATION_ADAPTER' in residual
    assert 'general production Control authority disabled' in runtime


def test_v4769_d0139_refuge_progress_passage_succeeds_old_follower_compression_purpose():
    gate=(ROOT/"scripts"/"prototypes"/"Prototype22CapabilityGate.lua").read_text(encoding="utf-8")
    follower=(ROOT/"scripts"/"diagnostics"/"FollowerMaturationCompressionProbe.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    assert "progressPassageContextForRun" not in gate
    assert "setPurposeSuccessionSource" not in follower
    assert "_retireForProgressPassage" not in follower
    assert "FOLLOWER_TRANSITION_CLEARANCE_REGULATION" not in control
    assert "D0123_GUARDED_RECOVERY" in control



def test_v4769_lua_harness_uses_d0138_probe_not_falsified_d0137_probe():
    harness=(ROOT/"tests"/"replacement_core"/"run.lua").read_text(encoding="utf-8")
    assert 'load("scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua")' in harness
    assert 'load("scripts/diagnostics/NativeAIDriveSignalProbe.lua")' not in harness
    assert 'NativeAIDriveSignalProbe.' not in harness
    assert 'NativeFieldWorkerDriveCommandProbe.candidateRelation' in harness



def test_v0165_d0179_transit_base_uses_job_start_cached_capability_and_bounded_settlement():
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    authority=(ROOT/"scripts"/"prototypes"/"Prototype22ConfigurationAuthority.lua").read_text(encoding="utf-8")
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    ready=control.split('function Control:_d0146ConfigurationReady(run)',1)[1].split('function Control:_beginD0146Restore(run)',1)[0]
    assert 'getTransitFoldCapability(participant.referenceKey,participant.startJobToken)' in control
    assert 'prepareCachedTransit(participant.vehicle,capability)' in control
    assert 'getCachedTransitSettlement(participant.vehicle)' in ready
    assert 'TRANSIT_FOLD_SETTLEMENT_EXHAUSTED' in ready
    for forbidden in ('getActiveFoldMotionEvidence','configurationAuthority:getEvidence','allFolded','allDeployed','transitionCount','_transitGeometryCompatible','directionalPassageEnvelope','transitPassageEnvelope','foldMoveDirection','COMPACT_REQUIRED','RETAIN_CURRENT'):
        assert forbidden not in ready
    assert 'bootstrapTransitFoldCapability(record.members,nowSeconds)' in cache
    assert 'spec.hasFoldingParts==true' in cache
    assert 'spec.allowUnfoldingByAI~=false' in cache
    assert 'spec.maxFoldAnimDuration' in cache
    assert 'foldingConfigurations.foldingConfiguration(0).foldingParts#allowUnfoldingByAI' not in cache
    assert 'D0146_TRANSIT_FOLD_SETTLEMENT_DURATION_FACTOR = 1.50' in config
    assert 'D0146_TRANSIT_FOLD_SETTLEMENT_FALLBACK_MS = 30000' in config
    assert 'D0146_TRANSIT_FOLD_SETTLEMENT_MAX_MS = 35000' in config
    assert 'targetFoldAnimTime' in authority and 'value>=0.999' in authority

def test_alignment_authority_surface_is_central_and_diagnostics_are_downstream_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    forbidden_tokens=(
        "setRegulationLease",
        "executeControlRequest",
        "decisionCommitmentBoundary:apply",
        "ControlRequest.new",
        "authorities:acquire",
        "authorities:release",
    )
    for dirname in ("diagnostics","observation","assessment","candidates"):
        for path in (ROOT/"scripts"/dirname).glob("*.lua"):
            text=path.read_text(encoding="utf-8")
            for token in forbidden_tokens:
                assert token not in text, f"{path.relative_to(ROOT)} must not acquire physical authority via {token}"
    for path in (ROOT/"scripts"/"assessment").glob("*.lua"):
        text=path.read_text(encoding="utf-8")
        assert "OuttaMyWay.runtime" not in text, f"{path.relative_to(ROOT)} must consume supplied evidence rather than global Runtime state"
        assert "g_currentMission" not in text, f"{path.relative_to(ROOT)} must not read GIANTS mission Reality directly"
    assert 'scripts/control/LiveControlDispatcher.lua' in main
    assert 'scripts/prototypes/GuardedRecoveryRegulationTestBridge.lua' not in main
    assert main.index('addModEventListener(OuttaMyWay.liveRuntimeCoordinator)') < main.index('addModEventListener(OuttaMyWay.productiveContinuationProbe)')
    assert main.index('addModEventListener(OuttaMyWay.liveRuntimeCoordinator)') < main.index('addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)')


def test_d0141_aligned_follower_boundary_regulation_uses_current_knowledge_and_central_control_only():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    observation=(ROOT/"scripts"/"observation"/"NativeFieldWorkObservation.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"FollowerBoundaryDemandAssessment.lua").read_text(encoding="utf-8")
    situation=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    lifecycle=(ROOT/"scripts"/"commitment"/"LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    operational=(ROOT/"scripts"/"contracts"/"OperationalPicture.lua").read_text(encoding="utf-8")
    coordinator=(ROOT/"scripts"/"runtime"/"LiveRuntimeCoordinator.lua").read_text(encoding="utf-8")

    hud=(ROOT/"scripts"/"diagnostics"/"FollowerPacingHud.lua").read_text(encoding="utf-8")

    assert 'scripts/assessment/FollowerBoundaryDemandAssessment.lua' in main
    assert 'FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED = true' in config
    assert 'FOLLOWER_BOUNDARY_PROVISIONAL_DURATION_SEC = 13.0' in config
    assert 'LIVE_RUNTIME_CONTROL_INTERVAL_MS = 250' in config
    assert 'FOLLOWER_BOUNDARY_ESTABLISHED_LATERAL_RETENTION_M = 1.0' in config
    assert 'FOLLOWER_BOUNDARY_ESTABLISHED_ALIGNMENT_MIN_DOT = 0.95' in config
    assert 'FOLLOWER_BOUNDARY_ESTABLISHED_OPPOSED_SUCCESSION_MAX_DOT = -0.95' in config
    assert 'FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR = 0.90' in config
    assert 'workingWidth=workingWidth' in observation
    assert 'nativeDriveCommand=nativeDriveCommand' in observation
    assert 'followerBoundaryKnowledge' in situation and '"followerBoundaryKnowledge"' in operational
    assert 'CURRENT_COHERENT_LINE_ASTERN_PRODUCTIVE_TOPOLOGY' in assessment
    assert 'CURRENT_PRODUCTIVE_WORK_CORRIDORS_DO_NOT_OVERLAP' in assessment
    assert 'PROVISIONAL_DEMAND_SEED' in assessment
    assert 'FOLLOWER_NATIVE_ZERO_COMMAND_HAS_NO_RATE_AUTHORITY' in assessment
    assert 'ESTABLISHED_FOLLOWER_CORRIDOR_WITHIN_RETENTION_MARGIN' in assessment
    assert 'ESTABLISHED_FOLLOWER_ALIGNMENT_WITHIN_RETENTION_BAND' in assessment
    assert 'ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION' in assessment
    assert 'EXISTING_FOLLOWER_PURPOSE_BOUNDED_BY_LEADER_TRANSITION_PROGRESS_RATE' in assessment
    assert 'LEADER_NATIVE_REVERSE_COMMAND_REQUIRES_FOLLOWER_STOP' in assessment
    assert 'leader.turning==true' in assessment
    assert 'historicalNativeManoeuvreAuthority=false' in assessment
    assert 'NativeManoeuvreObservationSource' not in assessment
    assert 'forensicDemandEnvelope' not in assessment
    assert 'FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR' in assessment
    assert 'FOLLOWER_BOUNDARY_D0141' in support
    assert 'FOLLOWER_BOUNDARY_ALIGNED_REGULATION_ENABLED~=true' in support
    assert 'FOLLOWER_BOUNDARY_PROTECTION' in support
    assert 'applyFollowerBoundaryDecision' in lifecycle
    assert 'settleFollowerBoundaryPurpose' in lifecycle
    assert 'D0141_FOLLOWER_BOUNDARY' in control
    assert 'ELASTIC_REGULATION_MAGNITUDE_UPDATED' in control
    assert 'CAP_RELAXATION_REJECTED_PURPOSE_PERSISTS' not in control
    assert 'FOLLOWER_MATURATION_TRANSITION_CLEARANCE_FACTOR' not in control
    assert 'LIVE_RUNTIME_CONTROL_INTERVAL_MS or 250' in coordinator
    assert 'PASSIVE_SAMPLE_INTERVAL_MS' not in coordinator
    assert 'FollowerMaturationCompressionProbe' not in assessment
    assert 'FollowerMaturationCompressionProbe' not in support
    assert 'FollowerMaturationCompressionProbe' not in control
    assert 'Follower regulation ALIGNED' in hud
    assert 'legacy follower SHADOW' in hud
    assert 'FollowerPacingHud.new(OuttaMyWay.runtime.liveControlDispatcher,OuttaMyWay.followerMaturationCompressionProbe)' in main


def test_v47100_d0146_step1_remains_situation_owned_knowledge_under_step2_consumption():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    module=(ROOT/"scripts"/"assessment"/"TrajectoryConflictAssessment.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    picture=(ROOT/"scripts"/"contracts"/"OperationalPicture.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")

    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert "scripts/assessment/TrajectoryConflictAssessment.lua" in main
    assert main.index("scripts/assessment/TrajectoryConflictAssessment.lua") < main.index("scripts/assessment/SituationAssessment.lua")
    for token in ("updateTrajectories","classifyPairs","ESTABLISHED_TRAJECTORY","CURRENT_EXCURSION","POTENTIAL_OPPOSED_CORRIDOR_CONFLICT","ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT","D0146_SITUATION_KNOWLEDGE"):
        assert token in module
    for token in ("trajectoryKnowledge","opposedCorridorKnowledge","trajectoryTracks"):
        assert token in assessment
    assert '"trajectoryKnowledge", "opposedCorridorKnowledge"' in picture
    assert "TRAJECTORY assembly=%s" in validator
    assert "OPPOSED_CORRIDOR pair=%s" in validator
    assert "positive=positive" in module and "local positive=overlapM>0" in module
    assert "negativeClearanceAuthority=false" in module
    for text in (module,assessment,validator):
        for forbidden in ("stopCurrentAIJob(","driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
            assert forbidden not in text
    assert "opposedCorridorKnowledge" in planner and "trajectoryKnowledge" in planner
    assert "LocalPassagePlanner.plan" in candidate
    assert "trajectoryKnowledge" not in control and "opposedCorridorKnowledge" not in control


def test_v47101_d0146_step2_is_active_candidate_owned_and_control_executes_only_supplied_guide():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    fitness=(ROOT/"scripts"/"assessment"/"PassageCapabilityAssessment.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")

    assert "scripts/assessment/PassageCapabilityAssessment.lua" in main
    assert "scripts/candidates/LocalPassagePlanner.lua" in main
    assert 'D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED = true' in config
    assert "D0146_PASSAGE_EXCURSION_V6" in fitness
    assert "vehicleNameAdmissionGate=false" in fitness
    assert "Condor Endurance II" not in fitness and "Patriot 4450" not in fitness
    assert "Condor Endurance II" not in planner and "Patriot 4450" not in planner
    for token in ("Passage Arrangement","Progressive Passage Search","pairSweepSupport","guideFieldSupport","thirdPartyGuideSupport","satisficed=true"):
        assert token in planner
    for token in ("thirdPartyConstraints","LOCAL_SPATIAL_CONSTRAINT_THIRD_PARTY_CURRENT_OCCUPANCY","CURRENT_POSITIVE_THIRD_PARTY_PHYSICAL_OCCUPANCY"):
        assert token in planner
    assert "D0146_COOPERATIVE_PASSAGE_STEP2_TEST" in support
    assert 'architecture="D0146_STEP2"' in support
    assert "D0146_COOPERATIVE_PASSAGE" in dispatcher
    assert "_startGuideGate" in control and "PASSAGE_REASSESSMENT" in control
    assert "_thirdPartySupport" in control and "PASSAGE_SUPPORT_LOSS_THIRD_PARTY_ACTIVE_LEG" in control
    assert "controlBroadening=false" in control
    assert "sharedRightX*lateralM*p.sideSign" in control  # retained D-0143 donor only
    assert "trajectoryKnowledge" not in control and "opposedCorridorKnowledge" not in control
    assert "numberText(item.currentDirectionX)" in validator  # values still visible
    # But continuously changing values are no longer part of transition signatures.
    sig=validator[validator.index("local signature=table.concat({",validator.index("_logTrajectoryConflictKnowledge")):validator.index("if self.trajectoryLogSignatures",validator.index("_logTrajectoryConflictKnowledge"))]
    assert "currentDirectionX" not in sig and "formationDistanceM" not in sig



def test_v47103_d0146_relationship_succession_retires_stale_follower_and_local_passage_is_operation_aware():
    situation=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    follower=(ROOT/"scripts"/"assessment"/"FollowerBoundaryDemandAssessment.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    fitness=(ROOT/"scripts"/"assessment"/"PassageCapabilityAssessment.lua").read_text(encoding="utf-8")

    assert situation.index("TrajectoryConflictAssessment.classifyPairs") < situation.index("FollowerBoundaryDemandAssessment.buildKnowledge")
    assert "opposedCorridorKnowledge=opposedCorridorKnowledge" in situation
    assert "ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION" in follower
    assert "ESTABLISHED_OPPOSED_PASSAGE_INVALIDATES_FOLLOWER_BOUNDARY_PROTECTION" in follower
    assert "D0146_POSITIVE_RELATIONSHIP_SUCCESSION" in follower
    assert "operationMembers" in planner and "thirdPartyGuideSupport" in planner
    assert "thirdPartyConstraints" in planner and "thirdPartyConstraints" in control
    assert "PASSAGE_SUPPORT_LOSS_THIRD_PARTY_ACTIVE_LEG" in control
    assert "vehicleNameAdmissionGate=false" in fitness
    for text in (fitness,planner):
        assert "Condor Endurance II" not in text and "Patriot 4450" not in text
    for forbidden in ("driveToPoint(","setCruiseControlState(","decisionCommitmentBoundary:apply"):
        assert forbidden not in planner and forbidden not in fitness


def test_v0104_d0146_pair_specific_clearance_is_transit_only_and_has_no_configuration_conditioned_fallback():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    helper=(ROOT/"scripts"/"representation"/"PairSpecificPassageClearance.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    fitness=(ROOT/"scripts"/"assessment"/"PassageCapabilityAssessment.lua").read_text(encoding="utf-8")
    assert "scripts/representation/PairSpecificPassageClearance.lua" in main
    assert "D0146_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M = 1.0" in config
    for token in ("subjectFacingExtentM","otherFacingExtentM","physicalContactThresholdM","policyRequiredSeparationM"):
        assert token in helper
    assert "PairSpecificPassageClearance.currentPair" in planner
    assert 'mode="TRANSIT_REQUIRED"' in planner
    assert 'policy="TRANSIT_ONLY_REALISATION_BEFORE_PASSAGE"' in planner
    assert 'selection="TRANSIT_REQUIRED_FOR_ALL_PARTICIPANTS"' in planner
    assert 'TRANSIT_BASE_PAIR_CLEARANCE_UNAVAILABLE' in planner
    for forbidden in ('configurationConditionedPair','compactParticipantGeometry','COMPACT_REQUIRED','RETAIN_CURRENT','LEGACY_CONFIGURATION_CONDITIONED'):
        assert forbidden not in planner
    assert "passageConfiguration=plan.passageConfiguration" in support
    assert "D0146_PASSAGE_EXCURSION_V6" in fitness
    assert 'participant.configurationMode~="TRANSIT_REQUIRED"' in control
    assert 'COMPACT_REQUIRED' not in control and 'RETAIN_CURRENT' not in control
    assert "policy=ALWAYS_ATTEMPT_TRANSIT" in control
    assert "TRANSIT_REQUEST_IGNORED" in control
    assert "TRANSIT_FOLD_WAIT" in control
    assert "TRANSIT_CAPABILITY_CACHE" in control
    assert "getCachedTransitSettlement" in control
    assert "RESTORE_SKIPPED" in control and "selective=true" in control

def test_v47105_d0146_control_uses_giants_safe_value_record_traversal_for_candidate_collections():
    control = (ROOT / "scripts/control/CooperativePassageControl.lua").read_text()
    assert "for _,entry in OuttaMyWay.ValueRecord.ipairs(plan.participants)" in control
    assert "for _,constraint in OuttaMyWay.ValueRecord.ipairs(run.thirdPartyConstraints or {})" in control
    assert "for index,gate in OuttaMyWay.ValueRecord.ipairs(run.guide.gates)" in control
    assert "for _,entry in ipairs(plan.participants)" not in control
    assert "for _,constraint in ipairs(run.thirdPartyConstraints or {})" not in control
    assert "for index,gate in ipairs(run.guide.gates)" not in control


def test_v47106_d0146_current_excursion_conserves_action_space_before_established_passage():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    situation=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"TrajectoryConflictAssessment.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    lifecycle=(ROOT/"scripts"/"commitment"/"LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    envelope=(ROOT/"scripts"/"control"/"ResolutionSpaceProgressionEnvelope.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")

    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'D0146_RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION = 0.75' in config
    assert 'D0146_RESOLUTION_SPACE_REGULATION_KMH' not in config
    assert 'actionSpaceMaxSeparationM=OuttaMyWay.D0146_STEP2_LOCAL_PASSAGE_MAX_ENTRY_SEPARATION_M' in situation
    assert 'actionSpaceRegulationKmh' not in situation

    for token in (
        "actionSpaceConservation", "currentCorridorOverlapOnAxis", "nativeForwardRateKmh", "nativeClosureContribution",
        "CURRENT_EXCURSION_CONSUMES_LOCAL_PASSAGE_ACTION_SPACE", "REGULATE_SUPPORTED",
        "PRESERVE_D0146_PASSAGE_ACTION_SPACE_UNTIL_SUPPORTED_PASSAGE_OR_POSITIVE_DISSOLUTION",
        "resolutionSpaceRelationship", "positiveDissolution",
        "D0146_TRANSIENT_EXCURSION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION",
    ):
        assert token in assessment
    assert 'requestedCapKmh' not in assessment
    assert 'NATIVE_PROGRESS_ALREADY_WITHIN_ACTION_SPACE_CONSERVATION_RATE' not in assessment
    assert 'ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_CONSUMES_LOCAL_PASSAGE_ACTION_SPACE' in assessment
    assert 'PRESERVE_TRANSITIONAL_NATIVE_REVELATION' in assessment
    assert 'DEFER_GREATER_NATIVE_CLOSURE_CONTRIBUTION' in assessment
    assert 'ESTABLISHED_CONFLICT_POSITIVE_NATIVE_CLOSURE_CONTRIBUTION_UNAVAILABLE' in assessment
    assert 'D0146_STEP2_LOCAL_PASSAGE_MIN_ENTRY_SEPARATION_M' not in config
    assert 'D0146_RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH = 1' in config
    planner=(ROOT/'scripts'/'candidates'/'LocalPassagePlanner.lua').read_text(encoding='utf-8')
    assert 'LOCAL_PASSAGE_DEVELOPMENT_DISTANCE_INSUFFICIENT' not in planner
    assert 'result.negativeClearanceAuthority' not in assessment
    assert 'negativeClearanceAuthority=false' in assessment
    for forbidden in ("executeControlRequest(", "setRegulationLease", "decisionCommitmentBoundary:apply"):
        assert forbidden not in assessment and forbidden not in situation

    for token in (
        "d0146ActionSpaceRepresentation", "D0146_RESOLUTION_SPACE_REGULATION",
        "d0146ActionSpaceRegulationBridge", "D0146_PASSAGE_ACTION_SPACE_CONSERVATION",
        "D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES",
        '"d0146-cooperative-passage:"..tostring(item.relation.identity)',
        'controlAuthority="D0155_RESOLUTION_SPACE_PROGRESSION_ENVELOPE"',
    ):
        assert token in support
    assert 'requestedCapKmh' not in support
    assert 'acceptedStates={"USABLE_WITH_UNCERTAINTY"}' in support

    for token in ("applyD0146ActionSpaceDecision", "settleD0146ActionSpacePurpose", "D0146_ACTION_SPACE_PURPOSE_SETTLED"):
        assert token in lifecycle
    for token in (
        'function Envelope.establish', 'function Envelope.update', 'function Envelope.rebaseRole',
        'math.sqrt', 'math.floor', 'reverseCreatedReserveM', 'contingencyReserveM', 'remainingOrdinaryM', 'policyDecelerationMps2', 'INTENT_REVELATION_CREEP'
    ):
        assert token in envelope
    for token in (
        'D0146_ACTION_SPACE_OWNER_TAG="D0146_ACTION_SPACE_CONSERVATION"',
        "_dispatchD0146ActionSpace", "_releaseD0146ActionSpaceLease", "_updateD0146ActionSpaceEnvelope",
        "_supersedeD0146ActionSpaceForCooperativePassage", "D0146_ACTION_SPACE_PASSAGE_SUPERSESSION",
        "d0146ActionSpaceRelationshipState", "positiveDissolution", "D0155_ENVELOPE_UPDATE", "D0155_ROLE_REBASE",
        "d0146CurrentPoseSeparation", "D0155_INTENT_REVELATION_CREEP",
        "D0146_POTENTIAL_CONFLICT_RESOLUTION_SPACE_OBLIGATION_PERSISTS",
    ):
        assert token in dispatcher
    assert '_escalateD0146ActionSpaceToHold' not in dispatcher
    assert '_deescalateD0146ActionSpaceHold' not in dispatcher
    assert 'd0146RegulationRealised' not in dispatcher
    dispatch_body=dispatcher[dispatcher.index("function Dispatcher:dispatch"):dispatcher.index("function Dispatcher:getRequests")]
    assert dispatch_body.index("_dispatchD0146ActionSpace") < dispatch_body.index("local follower=self:_dispatchFollowerBoundary")
    assert "trajectoryKnowledge" not in dispatcher
    assert "currentExcursion" not in dispatcher and "nativeFieldWork" not in dispatcher
    assert "currentCorridorOverlapOnAxis" not in dispatcher
    assert "actionSpace=%s" in validator and "actionNative=%s" in validator and "magnitudeAuthority=CONTROL" in validator

    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    assert "for _,entry in OuttaMyWay.ValueRecord.ipairs(plan.participants)" in control
    assert "for index,gate in OuttaMyWay.ValueRecord.ipairs(run.guide.gates)" in control

def test_v01141_d0197_obligation_persistence_is_not_actuation_persistence():
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")

    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    for token in (
        "d0146ActionSpaceActuationState",
        "_quiesceD0146ActionSpaceActuation",
        "_reactivateD0146ActionSpaceActuation",
        'action.status=="NOT_REQUIRED"',
        'action.status=="REGULATE_SUPPORTED"',
        "D0155_ACTUATION_QUIESCENT",
        "D0155_ACTUATION_REACTIVATED",
        "D0197_ACTION_SPACE_NOT_REQUIRED_ACTUATION_QUIESCENCE",
        "relationshipRetained=true",
        "envelopeRebased=true",
    ):
        assert token in dispatcher

    quiesce=dispatcher[dispatcher.index("function Dispatcher:_quiesceD0146ActionSpaceActuation"):dispatcher.index("function Dispatcher:_reactivateD0146ActionSpaceActuation")]
    assert "releaseSupportingRegulationAuthority" in quiesce
    assert "settleD0146ActionSpacePurpose" not in quiesce
    assert "g_time" not in quiesce and "timeout" not in quiesce.lower() and "hysteresis" not in quiesce.lower()

    reactivate=dispatcher[dispatcher.index("function Dispatcher:_reactivateD0146ActionSpaceActuation"):dispatcher.index("function Dispatcher:_updateD0146ActionSpaceEnvelope")]
    assert "ResolutionSpaceProgressionEnvelope.establish" in reactivate
    assert "applyD0146ActionSpaceDecision" in reactivate
    assert "settleD0146ActionSpacePurpose" not in reactivate


def test_v47108_settled_relationship_dissolution_requires_positive_non_turn_continuation():
    assessment=(ROOT/"scripts"/"assessment"/"TrajectoryConflictAssessment.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    validator=(ROOT/"scripts"/"diagnostics"/"PassiveLiveValidator.lua").read_text(encoding="utf-8")

    for token in (
        "positiveSettledContinuation",
        'trajectory.contextEvidenceClass=="NON_TURN_LINE_ACTIVE"',
        'motion.localIntentClassification=="SETTLED_CONTINUATION"',
        "subjectSettledContinuation", "otherSettledContinuation",
        "D0146_TRANSITIONAL_CONTINUATION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION",
        "D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION",
    ):
        assert token in assessment
    assert 'D0146_POSITIVE_STABLE_TRAJECTORY_RELATIONSHIP_DISSOLUTION' not in assessment
    # Situation owns the settlement interpretation; Control remains semantic-only.
    for forbidden in ("TURN_SEGMENT", "SETTLED_CONTINUATION", "productivePositive", "localIntentClassification"):
        assert forbidden not in dispatcher
    assert "settled=%s/%s" in validator
    assert "relationshipReason=%s" in validator



def test_v47117_d0147_value_record_boundary_accessors_remain_after_fixed_point_controller_retirement():
    authority=(ROOT/"scripts"/"authority"/"PostJobActuationAuthority.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")

    # v4.7.117 fixed-point curvature was live-tested then retired by v4.7.120's
    # Exit Vector / Exit Heading correction. No stale fixed-target actuator remains.
    assert 'POST_JOB_FIXED_TARGET_NO_LONGER_FORWARD_REACHABLE' not in authority
    assert 'targetCurvature=(2*lx)/localDenominator' not in authority
    assert 'driveToWorldTarget' not in authority

    # v4.7.122 retires outer-boundary egress traversal from the live D-0147 path.
    assert 'ValueRecord.ipairs(boundary)' not in candidate
    assert 'ValueRecord.length(boundary)' not in candidate
    assert 'positiveRepresentedFieldExit' not in control
    assert 'geometryMetrics' in candidate
    assert 'centroidX' in candidate and 'centroidZ' in candidate


def test_v47118_d0147_diagnostic_steering_telemetry_and_owned_exit_neutralization():
    authority=(ROOT/"scripts"/"authority"/"PostJobActuationAuthority.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")
    for token in (
        "steeringTelemetry",
        "spec_crabSteering",
        "crabAiSteeringModeIndex",
        "physics.steeringAngle",
        "getNeutralizeCallCount",
        "WheelsUtil.updateWheelsPhysics",
        "vehicle.rotatedTime=0",
    ):
        assert token in authority
    for token in (
        "STEERING_BASELINE",
        "STEERING_COMMAND_STATE",
        "STEERING_NEXT_UPDATE",
        "STEERING_HEARTBEAT",
        "ACTUATION_NEUTRALIZED",
        "PLAYER_CLAIM_HIGHER_AUTHORITY",
        "SOURCE_INTENT_REACTIVATED_HIGHER_AUTHORITY",
    ):
        assert token in control
    assert 'state.phase=="INFIELD" and state.actuationIssued==true' in control


def test_v47119_d0147_vehicle_activity_context_is_bounded_and_restored():
    authority=(ROOT/"scripts"/"authority"/"PostJobActuationAuthority.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")
    for token in (
        "acquireVehicleActivityContext",
        "releaseVehicleActivityContext",
        "previousForceIsActive",
        "vehicle.forceIsActive=true",
        "vehicle.forceIsActive=context.previousForceIsActive",
        "getActivityContextAcquireCallCount",
        "getActivityContextReleaseCallCount",
        "forceIsActive=vehicle.forceIsActive==true",
        "isActive=vehicle.isActive==true",
    ):
        assert token in authority
    for token in (
        "VEHICLE_ACTIVITY_CONTEXT_ACQUIRED",
        "VEHICLE_ACTIVITY_CONTEXT_RELEASED",
        "state.activityContext=activityContext",
        "releaseVehicleActivityContext(vehicle,state.activityContext)",
    ):
        assert token in control
    # Vehicle Activity Context remains intact while v4.7.122 deliberately retires
    # Positive Field-Exit Settlement from the live D-0147 courtesy path.
    assert "positiveRepresentedFieldExit" not in control
    assert 'state.phase=="INFIELD" and state.activityContext~=nil' in control

def test_v47120_d0147_exit_alignment_is_direction_locked_and_positive_exit_terminated():
    authority=(ROOT/"scripts"/"authority"/"PostJobActuationAuthority.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")

    for token in (
        "driveInWorldDirection",
        "worldDirectionToLocal",
        "AIVehicleUtil.driveInDirection",
        "POST_JOB_DIRECTION_DRIVE_CALL_FAILED",
        "steeringAngleLimitDeg",
    ):
        assert token in authority
    assert "AIVehicleUtil.driveAlongCurvature" not in authority
    assert "driveToWorldTarget" not in authority

    # v4.7.122 preserves the validated fixed-direction actuator but points it once
    # toward the immutable Field World centroid instead of an outer-boundary exit.
    assert 'alignmentMode="FIXED_INITIAL_CENTRE_BEARING"' in candidate
    assert 'continuousCourseCorrection=false' in candidate
    assert 'fieldCentreIsDestination=not capped' in candidate
    assert 'targetX,targetZ=occupancy.x+dirX*targetProgress,occupancy.z+dirZ*targetProgress' in candidate
    assert 'targetProgress=math.min(distance,distanceCap)' in candidate
    assert 'settlement="POSITIVE_FIELD_EXIT_ONLY"' not in candidate

    for token in (
        "state.infieldDirectionX=objective.infieldDirectionX",
        "state.infieldDirectionZ=objective.infieldDirectionZ",
        "driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)",
        "INFIELD_ALIGNMENT_ACTUATION",
        "continuousCourseCorrection=false",
    ):
        assert token in control
    assert "positiveRepresentedFieldExit" not in control
    assert "state.targetX=objective.targetX" in control
    assert "state.targetZ=objective.targetZ" in control
    assert "driveToWorldTarget" not in control



def test_v47122_d0147_bounded_infield_retreat_is_one_shot_and_reactive():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"TerminalOccupancyAssessment.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")

    assert 'TERMINAL_INFIELD_RETREAT_DISTANCE_M' not in config
    assert 'TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M = 60.0' in config
    assert 'geometryMetrics=representative and representative.geometryMetrics or nil' in source
    assert 'alignmentMode="FIXED_INITIAL_CENTRE_BEARING"' in candidate
    assert 'continuousCourseCorrection=false' in candidate
    assert 'fieldCentreIsDestination=not capped' in candidate
    assert 'dirX,dirZ=dx/distance,dz/distance' in candidate
    assert 'targetProgress=math.min(distance,distanceCap)' in candidate
    assert 'CENTROID_BEARING_DISTANCE_CAP' in candidate
    assert 'phase="INFIELD"' in candidate
    assert 'positiveRepresentedFieldExit' not in control
    assert 'driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)' in control
    assert 'local realisedProgress=dx*state.infieldDirectionX+dz*state.infieldDirectionZ' in control
    assert 'realisedProgress>=state.targetProgressM' in control
    assert 'continuousCourseCorrection=false' in control

    assert 'yieldRenewalState' in assessment
    assert 'continuationWitnessAssemblyIds' in assessment
    assert 'authorizing[assemblyId]' not in assessment
    assert 'markRetreatCompleted' in assessment
    assert 'positivePhysicalProgress' in assessment
    assert 'renewal.continuationObserved=true' in assessment
    assert 'aiState.blocked==true' in assessment
    assert 'record.yieldAwaitingContinuation~=true' in candidate
    assert 'markRetreatCompleted(result.terminalEpisodeId,protectedDemandAssemblyIds,courtesyStage)' in dispatcher
    assert 'TerminalEgressCommitmentLifecycle.settle(self.runtime,result.commitmentId,"OBJECTIVE_SATISFIED"' in dispatcher
    assert 'DOUBLE_COURTESY_ALREADY_EXHAUSTED' in control


def test_v01131_d0194_two_stage_terminal_courtesy_is_bounded_and_geometry_derived():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"TerminalOccupancyAssessment.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    assert 'TERMINAL_INFIELD_RETREAT_DISTANCE_M' not in config
    assert 'TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M = 60.0' in config
    for token in ('TERMINAL_INTERIOR_SETTLEMENT','FIELD_CENTROID','CENTROID_BEARING_DISTANCE_CAP','TERMINAL_FINAL_BOUNDARY_SETTLEMENT','OUTER_BOUNDARY_AWAY_FROM_PROTECTED_DEMAND','forwardBoundaryPoint','maximumContainedProgress','protectedOccupancyTransitionClearanceSupported=true'):
        assert token in candidate
    for token in ('courtesyMoveCount','completed>=2','DOUBLE_COURTESY_EXHAUSTED','noThirdAutomaticRelocation=true'):
        assert token in assessment
    assert 'courtesyStage=result.evidence and tonumber(result.evidence.courtesyStage) or nil' in dispatcher
    assert 'markRetreatCompleted(result.terminalEpisodeId,protectedDemandAssemblyIds,courtesyStage)' in dispatcher
    assert 'realisedProgress>=state.targetProgressM' in control
    assert 'ONE_TERMINAL_COURTESY_WATCHDOG_EXPIRED' in control
    assert 'driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)' in control




def test_v01144_d0199_courtesy_budget_belongs_to_moved_obstacle_and_centroid_is_capped():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"TerminalOccupancyAssessment.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    assert 'TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M = 60.0' in config
    assert 'targetProgress=math.min(distance,distanceCap)' in candidate
    assert 'maximumCourtesyDistanceM=distanceCap' in candidate
    assert 'fieldCentreIsDestination=not capped' in candidate
    assert 'continuationWitnessAssemblyIds' in assessment
    assert 'blockedAttributedToMovedAssembly=true' in assessment
    assert 'blockerIdentityUnbound=true' in assessment
    assert 'authorizing[assemblyId]' not in assessment
    assert 'courtesyBudgetOwner="MOVED_COMPLETED_JOB_EPISODE"' in candidate

def test_v47124_d0147_protected_yield_interval_uses_valuerecord_traversal_and_sequences_productive_hold():
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    boundary=(ROOT/"scripts"/"commitment"/"DecisionCommitmentBoundary.lua").read_text(encoding="utf-8")
    drive=(ROOT/"scripts"/"prototypes"/"Prototype22DriveAuthority.lua").read_text(encoding="utf-8")

    for token in (
        "protectedDemandAssemblies",
        "authorizingDemandAssemblyIds",
        "progressActuationOwnership={assemblyIds=protectedIds}",
        'capability="REGULATE_SPEED",effectClass="HOLD",progressActuation=true',
        'controlAuthority="D0147_POST_JOB_PLUS_PROTECTED_YIELD_HOLD"',
    ):
        assert token in candidate
    for token in (
        'D0147_PROTECTED_YIELD_OWNER_TAG="D0147_PROTECTED_YIELD"',
        "_applyD0147ProtectedYield",
        "_releaseD0147ProtectedYield",
        'bridge.phase=="INFIELD"',
        '"APPLY",D0147_PROTECTED_YIELD_OWNER_TAG,0.0',
        'D0147_PROTECTED_YIELD_HOLD_APPLIED',
        'self:_releaseD0147ProtectedYield(result.commitmentId,"TERMINAL_CONTROL_"..tostring(result.status))',
    ):
        assert token in dispatcher
    assert "physical selected Candidate must select one actuation authority class" not in boundary
    assert "one assembly cannot simultaneously own progress and post-job actuation" in boundary
    assert "D-0186 Regulation–Hold Boundary" in drive
    assert "local outputAllowedToDrive = isAllowedToDrive == true and outputMax > 0" in drive
    assert "state.lastOutputAllowed = outputAllowedToDrive" in drive

    # v4.7.124: protectedDemandAssemblies is a sealed nested ValueRecord in GIANTS.
    # Native #/ipairs silently skipped the collection in v4.7.123, so the hold was never applied.
    assert 'OuttaMyWay.ValueRecord.length(protected)==0' in dispatcher
    assert 'for _,item in OuttaMyWay.ValueRecord.ipairs(protected) do' in dispatcher
    assert 'if #protected==0' not in dispatcher
    assert 'for _,item in ipairs(protected) do' not in dispatcher


def test_v47125_d0147_continuation_renewal_requires_progress_then_later_block():
    assessment=(ROOT/"scripts"/"assessment"/"TerminalOccupancyAssessment.lua").read_text(encoding="utf-8")
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    for token in (
        "yieldRenewalState",
        "continuationWitnessAssemblyIds",
        "positivePhysicalProgress",
        'class=="STABLE_FORWARD" or class=="TURNING" or class=="REVERSING_OR_OPPOSED_TRAVEL"',
        "renewal.continuationObserved=true",
        "repeatBlockedPositive",
        'aiState.blocked==true',
    ):
        assert token in assessment
    assert "not obstructionPositive" not in assessment.split("-- Continuation Renewal:",1)[1].split("local representationId",1)[0]
    assert 'record.yieldAwaitingContinuation~=true' in candidate
    assert 'repeatRequiresContinuationRenewal=true' in candidate
    assert 'laterRetryRequiresContinuationRenewal=true' in candidate
    assert 'markRetreatCompleted(result.terminalEpisodeId,protectedDemandAssemblyIds,courtesyStage)' in dispatcher
    assert 'continuationRenewalRequired=true' in dispatcher


def test_v47127_d0147_courtesy_constraint_and_valuerecord_regression_contract():
    candidate=(ROOT/"scripts"/"candidates"/"TerminalEgressCandidateSupport.lua").read_text(encoding="utf-8")
    boundary=(ROOT/"scripts"/"commitment"/"DecisionCommitmentBoundary.lua").read_text(encoding="utf-8")
    lifecycle=(ROOT/"scripts"/"commitment"/"LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    passage_control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    capability_assessment=(ROOT/"scripts"/"assessment"/"PassageCapabilityAssessment.lua").read_text(encoding="utf-8")

    # Courtesy Evidence Gap is resolved by an explicit D-0147-only N/A contract,
    # not by inventing geometry evidence or weakening mandatory constraints globally.
    assert 'local function courtesyExemption' in candidate
    assert 'applicable=false' in candidate
    assert 'D0147_COURTESY_CONSTRAINT_EXCEPTION' in candidate
    assert 'stageTwoClearance' in candidate
    assert 'protectedOccupancyTransitionClearanceSupported' in candidate
    assert 'exemptMandatoryConstraintIds=stageTwoClearance and {"FIELD_WORLD_CONTAINMENT"} or {"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE"}' in candidate
    assert 'constraints.FIELD_WORLD_CONTAINMENT=courtesyExemption' in candidate
    assert 'constraints.TRANSITION_CLEARANCE=courtesyExemption' in candidate
    assert 'constraints.TRANSITION_CLEARANCE=packet' in candidate
    assert 'constraints.FIELD_WORLD_CONTAINMENT=packet' not in candidate

    # Standing-order audit: proven sealed ValueRecord collections use explicit length accessors.
    assert 'OuttaMyWay.ValueRecord.length(contexts)==0' in candidate
    assert 'if #contexts==0' not in candidate
    assert 'OuttaMyWay.ValueRecord.length(contexts) == 0' in boundary
    assert 'OuttaMyWay.ValueRecord.length(progressOwnership.assemblyIds)' in boundary
    assert 'OuttaMyWay.ValueRecord.length(postJobOwnership.assemblyIds)' in boundary
    assert '#progressOwnership.assemblyIds' not in boundary
    assert '#postJobOwnership.assemblyIds' not in boundary
    assert 'OuttaMyWay.ValueRecord.length(contexts)~=1' in lifecycle
    assert 'OuttaMyWay.ValueRecord.length(candidate.evidenceBasis.progressActuationOwnership and candidate.evidenceBasis.progressActuationOwnership.assemblyIds or {})' in lifecycle
    assert 'OuttaMyWay.ValueRecord.length(ring)<3' in planner
    assert 'OuttaMyWay.ValueRecord.length(fieldWorld.boundary)<3' in planner
    assert 'OuttaMyWay.ValueRecord.length(run.guide.gates)<1' in passage_control
    assert 'OuttaMyWay.ValueRecord.length(run.thirdPartyConstraints or {})' in passage_control
    assert 'OuttaMyWay.ValueRecord.length(item.primitives)<1' in capability_assessment

    # The live-validated courtesy calibration remains frozen in this audit tranche.
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"TerminalEgressControl.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'TERMINAL_INFIELD_RETREAT_DISTANCE_M' not in config
    assert 'driveInWorldDirection(vehicle,dt,state.infieldDirectionX,state.infieldDirectionZ,state.speedKmh)' in control
    assert 'continuousCourseCorrection=false' in control


def test_v0181_transit_base_missing_evidence_fails_closed_without_legacy_configuration_authority():
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'local pairClearance,transitReason=transitConditionedPair(baselinePairClearance' in planner
    assert 'if pairClearance==nil then return nil,"TRANSIT_BASE_PAIR_CLEARANCE_UNAVAILABLE:"..tostring(transitReason) end' in planner
    assert 'mode="TRANSIT_REQUIRED"' in planner
    assert 'policy="TRANSIT_ONLY_REALISATION_BEFORE_PASSAGE"' in planner
    assert 'selection="TRANSIT_REQUIRED_FOR_ALL_PARTICIPANTS"' in planner
    for forbidden in ('configurationConditionedPair','compactParticipantGeometry','participantSelection','COMPACT_REQUIRED','RETAIN_CURRENT','LEGACY_CONFIGURATION_CONDITIONED'):
        assert forbidden not in planner
    assert 'D0146_COOPERATIVE_PASSAGE_BRIDGE_REQUIRED' in control
    assert '_executeLegacyJointRequests' not in control
    assert 'TRANSIT_REALISATION_DIRECTIONAL_TOLERANCE_RATIO' not in config

def test_v0100_pre_1_0_versioning_epoch_contract():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    moddesc=(ROOT/"modDesc.xml").read_text(encoding="utf-8")
    decision=(ROOT/"docs"/"DECISION_LOG.md").read_text(encoding="utf-8")
    engineering=(ROOT/"docs"/"ENGINEERING_ARCHITECTURE.md").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'OuttaMyWay.ARCHITECTURE_VERSION = "0.1.2.0"' in config
    assert '<version value="0.3.0.0">0.3.0.0</version>' in moddesc
    for token in ('0.MINOR.PATCH.BUILD','canonical releases use `BUILD=0`','TEST iterations increment BUILD','first public release is `1.0.0.0`'):
        assert token in decision
    for token in ('0.MINOR.PATCH.BUILD','Canonical named releases use `BUILD=0`','non-canonical TEST iterations','first public release is reserved'):
        assert token in engineering
    assert 'Historical `4.7.x` identities remain immutable provenance and are not renumbered.' in " ".join(engineering.split())


def test_v0107_d0146_transit_first_preserves_native_blocked_as_observation_not_passage_abort_authority():
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    observation=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    for token in ("nativeObservationCount","outtaMyWayObservationCount","beginOuttaMyWayConfigurationAuthority","endOuttaMyWayConfigurationAuthority","configurationAlternatives"):
        assert token in cache
    assert "OBSERVED_WITHOUT_OUTTAMYWAY_CONFIGURATION_AUTHORITY" in cache
    # Configuration history remains representation evidence but has no D-0146 planner authority.
    assert "configurationConditionedPair" not in planner
    assert "COMPACT_REQUIRED" not in planner and "RETAIN_CURRENT" not in planner
    assert "D0146_PASSAGE_EXCURSION_V6" in planner and "D0146_PASSAGE_EXCURSION_V6" in control
    assert "spec_aiFieldWorker.isBlocked == true" in observation
    assert "POSITIVE_NATIVE_BLOCKED_DURING_PASSAGE_GUIDE" not in control
    assert "configurationPreserved=true" in control
    assert 'if run.mode~="D0146_GUIDE" then self:_failHeld("NON_D0146_RUNTIME_MODE_REJECTED")' in control

def test_v01013_d0146_safe_release_vetoes_blocked_or_positive_future_space_false_dissolution():
    assessment=(ROOT/"scripts"/"assessment"/"TrajectoryConflictAssessment.lua").read_text(encoding="utf-8")
    for token in (
        "D0146_BLOCKED_PARTICIPANT_VETOES_POSITIVE_RELATIONSHIP_DISSOLUTION",
        "D0146_POSITIVE_FUTURE_SPACE_VETOES_POSITIVE_RELATIONSHIP_DISSOLUTION",
        "POSITIVE_DISSOLUTION_VETOED",
        "relevantFutureSpacePositive",
        "subjectBlocked", "otherBlocked",
    ):
        assert token in assessment
    assert assessment.index('if record.subjectBlocked==true or record.otherBlocked==true') < assessment.index('D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION')
    assert assessment.index('if record.relevantFutureSpacePositive==true') < assessment.index('D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION')

def test_v0132_d0159_passage_excursion_restores_selection_handoff_and_rebases_execution_origin():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    clearance=(ROOT/"scripts"/"representation"/"PairSpecificPassageClearance.lua").read_text(encoding="utf-8")

    for retired in (
        "D0146_STEP2_DEVELOPMENT_DISTANCE_M",
        "D0146_STEP2_TRAVERSAL_MARGIN_M",
        "D0146_STEP2_REACQUISITION_DISTANCE_M",
    ):
        assert retired not in config
    for token in (
        "D0146_STEP2_MIN_DEVELOPMENT_DISTANCE_M",
        "D0146_STEP2_DEVELOPMENT_FORWARD_PER_LATERAL_M",
        "D0146_STEP2_PASSAGE_ENTRY_CONTROL_ALLOWANCE_M",
    ):
        assert token in config
    for token in (
        "longitudinalPairSeparation",
        "passageEntryReady",
        "CROSSING_WINDOW_ENTRY",
        "CROSSING_WINDOW_EXIT",
        "DEVELOPMENT_CROSSING_WINDOW_RECOVERY_EXCURSION",
        "entryOrigins",
        "D0146_PASSAGE_EXCURSION_V6",
    ):
        assert token in planner
    assert "longitudinalSupportFromRelativeDiscs" in clearance
    assert "D0146_PASSAGE_SELECTED_APPROACH_RESOLUTION_SPACE_RETAINED" not in support
    assert "D0146_PASSAGE_SELECTED" in support
    assert "PASSAGE_APPROACH" in control
    assert "D0146_PASSAGE_APPROACH_START" in control
    assert "D0146_PASSAGE_ENTRY_TRIGGER" in control
    assert "D0146_EXECUTION_ORIGIN_CAPTURE" in control
    assert "executionFrame" in planner
    assert "D0146_PASSAGE_GUIDE_COMPLETE" in control
    assert "D0146_PASSAGE_SECOND_WHISTLE" not in control
    assert "D0146_PASSAGE_EXCURSION_V6" in control
    # Isolation guardrails for the first field experiment.
    assert "OuttaMyWay.D0146_STEP2_MOVE_SPEED_KMH = 8.0" in config
    assert "AGRONOMIC_DEBT_RETURN" not in control



def test_v0133_directional_passage_envelope_uses_bootstrap_giants_size_with_disc_fallback():
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    for token in (
        "vehicle.base.size#width", "vehicle.base.size#length", "directionalPassageEnvelope",
        "GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST", "SINGLE_MEMBER_BASE_SIZE",
    ):
        assert token in cache
    assert "directionalPassageEnvelope" in source
    assert "directionalPassageEnvelope" in assessment
    for token in (
        "directionalEnvelopeValid", "GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPES",
        "TRANSLATED_GIANTS_BASE_SIZE_DIRECTIONAL_ENVELOPES", "directionalRectangleClearance",
    ):
        assert token in planner
    assert "minimumTranslatedDiscClearance" in planner  # explicit fallback retained
    assert "OuttaMyWay.D0146_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M = 1.0" in config
    assert "OuttaMyWay.D0146_STEP2_MOVE_SPEED_KMH = 8.0" in config


def test_v0134_passage_settling_uses_owned_hold_plus_physical_stationary_not_permission_gate_causation():
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    start=control.index("function Control:_allStopped(run)")
    end=control.index("function Control:_d0146LongitudinalSeparation", start)
    block=control[start:end]
    assert "self.permissionGate:isHolding(p.vehicle)~=true" in block
    assert "actualSpeedKmh(p.vehicle)>limit" in block
    assert "getCallCount" not in block
    assert "GIANTS may already refuse native continuation" in block

def test_d0163_generic_directional_member_union_passage_envelope_is_vehicle_independent():
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    assert "GIANTS_DIRECTIONAL_MEMBER_UNION_PASSAGE_TEST" in cache
    assert "directionalRectangleMemberCount" in cache
    assert "representedDiscFallbackMemberCount" in cache
    assert "leftExtentM" in cache and "rightExtentM" in cache
    assert "frontExtentM" in cache and "rearExtentM" in cache
    assert "GIANTS_DIRECTIONAL_ASSEMBLY_ENVELOPES" in planner
    assert "TRANSLATED_GIANTS_DIRECTIONAL_ASSEMBLY_ENVELOPES" in planner
    assert "S416" not in cache and "S 416" not in cache
    assert "plough" not in cache.lower() and "mower" not in cache.lower()


def test_d0164_mechanical_foldability_does_not_bypass_passage_configuration_reachability():
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    assert "allowUnfoldingByAI" in cache
    assert "MECHANICAL_ONLY_FOLDABILITY_AI_DISABLED" in cache
    assert "raw mechanical foldability is not Passage-configuration authority" in cache
    # Deployed foldable members without positive AI-disabled evidence remain conservative.
    assert 'member.currentConfiguration and member.currentConfiguration.foldState=="FOLDED"' in cache
    assert 'reachability.aiUnfoldingAllowed==false' in cache


def test_d0164_passage_rejection_telemetry_reports_candidate_failure_class_without_changing_planner_policy():
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    assert "passageRejectionTelemetry" in support
    assert "D0146_PASSAGE_REJECTED" in support
    for token in ("geometry=%d","field=%d","sweep=%d","thirdParty=%d","other=%d"):
        assert token in support
    assert "rejected[#rejected+1]" in planner
    assert 'return nil,"LOCAL_PASSAGE_SPACE_EXHAUSTED_WITHIN_SUPPORTED_PROFILE",rejected' in planner


def test_d0165_nominal_passage_clearance_is_crossing_window_scoped_not_global():
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    assert "minimumCrossingWindowClearanceM" in planner
    assert "minimumOutsideCrossingClearanceM" in planner
    assert "NON_CONTACT_OUTSIDE_CROSSING_WINDOW_NOMINAL_TARGET_WITH_POLICY_FLOOR_INSIDE_CROSSING_WINDOW" in planner
    assert "PAIR_SPECIFIC_NON_CONTACT_NOT_SUPPORTED_OUTSIDE_CROSSING_WINDOW" in planner
    assert "PAIR_SPECIFIC_NOMINAL_CLEARANCE_FLOOR_NOT_SUPPORTED_IN_CROSSING_WINDOW" in planner
    assert 'gate.kind=="CROSSING_WINDOW_ENTRY"' in planner
    assert 'gate.kind=="CROSSING_WINDOW_EXIT"' in planner
    assert 'OuttaMyWay.D0146_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M = 1.0' in (ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.D0146_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO = 0.95' in (ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert "acceptedNominalClearanceFloorM" in planner
    assert "clearanceAcceptanceRatio" in planner


def test_v0146_clearance_telemetry_reuses_existing_sweep_evidence_without_extra_planner_calls():
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert "D0146_PASSAGE_CLEARANCE_TRACE" in support
    assert "passageClearanceRejectionTelemetry" in support
    assert "passageClearanceSelectedTelemetry" in support
    assert "candidate.sweepEvidence" in support
    assert "minimumCrossingWindowClearanceM" in support
    assert "requiredNominalClearanceM" in support
    assert "nominalResidue" in support
    assert "floorResidue" in support
    assert "sweepEvidence=sweepEvidence" in planner
    assert "D0146_CLEARANCE_TRACE_MAX_SEPARATION_M = 40.0" in config
    # The telemetry layer must consume the planner result passed to attach(); it must not invoke planning itself.
    start=support.index("local function passageClearanceRejectionTelemetry")
    end=support.index("local function followerMatchesCooperative",start)
    telemetry=support[start:end]
    assert "LocalPassagePlanner.plan" not in telemetry
    assert "pairSweepSupport(" not in telemetry
    assert "guideFieldSupport(" not in telemetry
    assert "thirdPartyGuideSupport(" not in telemetry


def test_d0173_transit_passage_geometry_is_owned_by_representation_from_cached_giants_base_size():
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    source=(ROOT/"scripts"/"observation"/"LiveObservationSource.lua").read_text(encoding="utf-8")
    assessment=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    assert "function Cache:_transitPassageEnvelope" in cache
    assert 'authority="GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY"' in cache
    assert 'configurationBasis="TRANSIT_POLICY_STATIC_BASE_SIZE"' in cache
    assert "memberBaseSizeComplete=true" in cache
    assert "representedDiscFallbackMemberCount=0" in cache
    assert "record.cachedTransitPassageEnvelope" in cache
    assert "record.transitPassageBootstrapAttempted" in cache
    assert "transitPassageEnvelope" in source
    assert "transitPassageEnvelope" in assessment
    # Loaded XML is preferred over runtime dimensions so authored base-size offsets survive.
    assert cache.index('local xmlFile=object.xmlFile') < cache.index('local width,length=tonumber(object.sizeWidth)')


def test_d0181_local_passage_requires_cached_transit_base_and_has_no_legacy_fallback():
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    assert "local function transitConditionedPair" in planner
    assert 'planningGeometrySource="TRANSIT_BASE"' in planner
    assert 'TRANSIT_BASE_PAIR_CLEARANCE_UNAVAILABLE' in planner
    for forbidden in ('legacyPairClearance','compactParticipantGeometry','participantSelection','configurationConditionedPair','LEGACY_CONFIGURATION_CONDITIONED'):
        assert forbidden not in planner
    assert "TRANSLATED_GIANTS_BASE_SIZE_TRANSIT_PASSAGE_GEOMETRY" in planner
    assert "passageGeometrySource" in planner
    assert "geometry=%s" in support



def test_v0181_d0182_d0146_restore_uses_cached_actuator_symmetry_only():
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    authority=(ROOT/"scripts"/"prototypes"/"Prototype22ConfigurationAuthority.lua").read_text(encoding="utf-8")
    start=control.index('function Control:_beginD0146Restore(run)')
    end=control.index('function Control:_notify(result)',start)
    restore=control[start:end]
    assert 'function Control:_beginRestore(run)' not in control
    assert 'requestCachedTransitRestore(participant.vehicle)' in restore
    assert 'getCachedRestoreSettlement(participant.vehicle)' in restore
    assert 'finishCachedTransitRestore(participant.vehicle)' in restore
    assert 'RESTORE_FOLD_SETTLEMENT_EXHAUSTED' in restore
    for forbidden in ('requestRestore(participant.vehicle)','finishRestore(participant.vehicle)','getEvidence(participant.vehicle)','allDeployed','allFolded','collectAssembly','spec_foldable'):
        assert forbidden not in restore
    assert 'function Authority:requestCachedTransitRestore(vehicle)' in authority
    assert 'state.transitActuatorStates' in authority
    assert 'initialTargetFoldAnimTime' in authority
    assert 'physicallyChanged' in authority
    assert 'function Authority:getCachedRestoreSettlement(vehicle)' in authority
    assert 'function Authority:finishCachedTransitRestore(vehicle)' in authority



def test_v01124_d0192_bounded_axis_return_is_isolated_after_canonical_passage_guide():
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    control=(ROOT/"scripts"/"control"/"CooperativePassageControl.lua").read_text(encoding="utf-8")
    drive=(ROOT/"scripts"/"prototypes"/"Prototype22DriveAuthority.lua").read_text(encoding="utf-8")
    cache=(ROOT/"scripts"/"representation"/"AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    planner=(ROOT/"scripts"/"candidates"/"LocalPassagePlanner.lua").read_text(encoding="utf-8")
    situation=(ROOT/"scripts"/"assessment"/"SituationAssessment.lua").read_text(encoding="utf-8")
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    # Phases 1-7 retain the v0.1.12.0 locality/regulation/planner behaviour.
    assert 'D0146_STEP2_LOCAL_PASSAGE_MAX_ENTRY_SEPARATION_M = 80.0' in config
    assert 'PASSAGE_APPROACH' in control and 'D0146_PASSAGE_APPROACH_START' in control
    assert 'D0146_ACTION_SPACE_REGULATION_SUPPORTED' in support
    assert 'D0146_STEP2_LOCAL_PASSAGE_MAX_ENTRY_SEPARATION_M' in planner
    assert 'D0146_STEP2_LOCAL_PASSAGE_MAX_ENTRY_SEPARATION_M' in situation
    assert 'D0146_STEP2_PAIR_SWEEP_SAMPLES_PER_LEG' in planner
    assert 'D0146_STEP2_FIELD_SWEEP_SAMPLE_M' in planner
    # D-0192 begins only after the existing guide completes.
    assert 'D0146_PASSAGE_GUIDE_COMPLETE' in control
    assert 'RECOVERY_ALIGNMENT_START' in control
    assert 'RETURN_STAGING_READY' in control
    assert 'AXIS_RETURN_START' in control
    assert 'steering=CAPTURED_AXIS_ONLY' in control
    assert 'AXIS_RETURN_ALIGNMENT_LOST' in control
    assert 'RETURN_CLEARANCE_WAIT' in control
    assert 'AXIS_RETURN_CLEARANCE_LOST' in control
    assert 'PARTICIPANT_WAVE_ON' in control
    assert 'PAIR_CONTEXT_DISSOLVED' in control
    assert 'function Authority:setAxisTravel' in drive
    assert 'state.mode == "AXIS_TRAVEL"' in drive
    assert 'function Cache:getAssemblyAlignmentSnapshot' in cache
    assert 'function Control:_assemblyAxisSettled' in control
    assert 'ASSEMBLY_MEMBER_AXIS_HEADING_NOT_SETTLED' in control
    assert 'ASSEMBLY_MEMBER_LATERAL_TRANSLATION_NOT_SETTLED' not in control
    assert 'alignmentBaseline' not in control
    assert 'D0146_ASSEMBLY_ALIGNMENT_LATERAL_TOLERANCE_M = 0.50' in config
    assert 'D0146_ASSEMBLY_ALIGNMENT_HEADING_MIN_DOT = 0.995' in config


def test_v01143_d0198_regulation_authority_semantics():
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    for token in (
        "_quiesceFollowerBoundaryActuation",
        "D0141_ACTUATION_QUIESCENT",
        "D0141_ACTUATION_REACTIVATED",
        "purposeRetained=true",
        "d0146ActionSpaceQuiescenceSupported",
        "D0198_NO_CURRENT_EXCURSION_PROTECTED_INTENT_REVELATION_REMAINS_LOCAL",
        "intentRevelationQuiescenceVeto",
        'action.reason~="NO_CURRENT_EXCURSION"',
        'actionSpace.status~="QUIESCENT"',
    ):
        assert token in dispatcher
    # Quiescence is an authority-lifetime change, not semantic purpose settlement.
    q=dispatcher[dispatcher.index("function Dispatcher:_quiesceFollowerBoundaryActuation"):dispatcher.index("function Dispatcher:_dispatchFollowerBoundary")]
    assert "releaseSupportingRegulationAuthority" in q
    assert "settleFollowerBoundaryPurpose" not in q
    assert "g_time" not in q and "timeout" not in q.lower() and "hysteresis" not in q.lower()
    # Quiescent D0155 must not monopolise dispatch before D0141.
    dispatch=dispatcher[dispatcher.index("function Dispatcher:dispatch"):]
    assert 'if actionSpace~=nil and actionSpace.status~="QUIESCENT" then return actionSpace end' in dispatch
    assert 'local follower=self:_dispatchFollowerBoundary(picture,evaluated,candidate)' in dispatch
    # Diagnostic-only 0.1.14.2 hot-path instrumentation is withdrawn.
    assert "D0141_AUTHORITY_ATTEMPT" not in dispatcher
    assert "D0141_AUTHORITY_DIAG" not in dispatcher


def test_v01145_d0200_job_episode_dependency_collapse_precedes_terminal_candidate_context():
    lifecycle=(ROOT/"scripts"/"commitment"/"LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    config=(ROOT/"scripts"/"config.lua").read_text(encoding="utf-8")
    assert 'OuttaMyWay.VERSION = "0.3.0.0"' in config
    assert 'function Lifecycle.collapseEndedJobEpisodeDependencies' in lifecycle
    support=(ROOT/"scripts"/"candidates"/"LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    assert 'dependentJobEpisodeIds' in lifecycle
    assert 'dependentEncounterId' in lifecycle
    assert 'd0146PairDependency' in support
    assert 'dependentJobEpisodeIds=dependentJobEpisodeIds' in support
    assert '"BASIS_CESSATION"' in lifecycle
    assert 'kind="OBJECTIVE_SATISFIED"' in lifecycle
    assert 'JOB_EPISODE_DEPENDENCY_COLLAPSE' in lifecycle
    section=lifecycle[lifecycle.index('function Lifecycle.collapseEndedJobEpisodeDependencies'):lifecycle.index('local function clearReleasedOwnership')]
    assert 'SOURCE_INTENT_TERMINATED' not in section
    process=runtime[runtime.index('function Runtime:processSealedObservation'):runtime.index('function Runtime:evaluateSealedOperationalPicture')]
    assert process.index('collapseEndedJobEpisodeDependencies') < process.index('assessOperationalPicture')
    assert 'trafficCommitmentCollapse=trafficCommitmentCollapse' in process
    assert 'function Dispatcher:retireTrafficLeasesForCommitment' in dispatcher
    for token in ('D0155_DEPENDENT_COMMITMENT_TERMINATED','D0141_DEPENDENT_COMMITMENT_TERMINATED','D0123_DEPENDENT_COMMITMENT_TERMINATED'):
        assert token in dispatcher


def test_cooperative_passage_responsibility_transition_is_upstream_and_singular():
    main=(ROOT/"scripts"/"main.lua").read_text(encoding="utf-8")
    runtime=(ROOT/"scripts"/"runtime"/"Runtime.lua").read_text(encoding="utf-8")
    dispatcher=(ROOT/"scripts"/"control"/"LiveControlDispatcher.lua").read_text(encoding="utf-8")
    transition_path=ROOT/"scripts"/"responsibility"/"CooperativePassageResponsibilityTransition.lua"
    transition=transition_path.read_text(encoding="utf-8")

    assert transition_path.is_file()
    assert "scripts/responsibility/CooperativePassageResponsibilityTransition.lua" in main
    assert "CooperativePassageResponsibilityTransition.new(runtime)" in runtime
    orchestration=runtime[runtime.index("function Runtime:dispatchEvaluatedOperationalPicture"):runtime.index("function Runtime:processLiveObservation")]
    assert orchestration.index("liveControlDispatcher:dispatch") < orchestration.index("cooperativePassageResponsibilityTransition:transition")
    assert orchestration.index("cooperativePassageResponsibilityTransition:transition") < orchestration.index("liveControlDispatcher:continueCooperativePassage")
    assert 'status="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED"' in dispatcher
    assert "function Dispatcher:continueCooperativePassage" in dispatcher
    assert "LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision" not in dispatcher
    assert transition.count("LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision") == 1
    for legacy_transition in ("applyD0146ActionSpaceDecision", "acquireSupportingRegulationAuthority", "TerminalEgressCommitmentLifecycle.applyDecision"):
        assert legacy_transition in dispatcher
