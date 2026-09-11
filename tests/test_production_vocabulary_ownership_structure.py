from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def test_primary_live_vocabulary_uses_current_responsibilities():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    capability = (ROOT / "scripts" / "assessment" / "PassageCapabilityAssessment.lua").read_text(encoding="utf-8")
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")

    for token in (
        "COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M",
        "COOPERATIVE_PASSAGE_EXCURSION",
        'purpose={kind="COOPERATIVE_PASSAGE"',
        'architecture="COOPERATIVE_PASSAGE"',
        "cooperative-passage:",
        "actionSpaceRegulationBridge",
        "FOLLOWER_BOUNDARY_OWNER_TAG",
        "ACTION_SPACE_REGULATION_OWNER_TAG",
        "obstructionRelocationCandidateSupport",
    ):
        assert token in config + support + capability + authority + runtime

    for stale in (
        "D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED",
        "D0146_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M",
        "D0146_PASSAGE_EXCURSION_V6",
        'purpose={kind="D0146_COOPERATIVE_PASSAGE"',
        'architecture="D0146_STEP2"',
        "d0146ActionSpaceRegulationBridge",
        "D0141_OWNER_TAG",
        "D0146_ACTION_SPACE_OWNER_TAG",
        "D0123_OWNER_TAG",
        "_legacyRegulationRequest",
        "legacyTerminalEgressCandidateSupport",
        "completedObstructionCandidateSupport",
    ):
        assert stale not in config + support + capability + authority + runtime


def test_issue112_graduated_physical_representation_uses_current_names_without_erasing_true_shadow():
    current_paths = (
        ROOT / "scripts" / "observation" / "LiveObservationSource.lua",
        ROOT / "scripts" / "observation" / "FieldBoundedFutureSpace.lua",
        ROOT / "scripts" / "observation" / "CurrentPhysicalPoseSource.lua",
        ROOT / "scripts" / "assessment" / "SituationAssessment.lua",
        ROOT / "scripts" / "candidates" / "TerminalEgressCandidateSupport.lua",
        ROOT / "scripts" / "diagnostics" / "PassiveLiveValidator.lua",
    )
    current = "\n".join(path.read_text(encoding="utf-8") for path in current_paths)

    for stale in (
        "shadowRepresentation",
        "shadowPlanViewEvidence",
        "subjectShadowRepresentationAvailable",
        "otherShadowRepresentationAvailable",
        "shadowCacheHit",
        "shadowInventoryPrimitives",
        "shadowProfileCacheHit",
    ):
        assert stale not in current

    for required in (
        "assemblyRepresentation",
        "planViewOccupancyEvidence",
        "subjectAssemblyRepresentationAvailable",
        "otherAssemblyRepresentationAvailable",
        "assemblyRepresentationCacheHit",
        "assemblyRepresentationInventoryPrimitives",
        "assemblyRepresentationProfileCacheHit",
    ):
        assert required in current

    # Existing question/fitness/permission evidence is a different contract.
    live = (ROOT / "scripts" / "observation" / "LiveObservationSource.lua").read_text(encoding="utf-8")
    assert "physicalRepresentationEvidence" in live
    assert "planViewOccupancyEvidence" in live

    # Current Interface Identity != Historical Evidence Identity.
    residual = (ROOT / "scripts" / "diagnostics" / "ProductiveCoverageResidualProbe.lua").read_text(encoding="utf-8")
    refuge = (ROOT / "scripts" / "diagnostics" / "RefugeQualificationShadowProbe.lua").read_text(encoding="utf-8")
    follower = (ROOT / "scripts" / "diagnostics" / "FollowerMaturationCompressionProbe.lua").read_text(encoding="utf-8")
    native_drive = (ROOT / "scripts" / "diagnostics" / "NativeFieldWorkerDriveCommandProbe.lua").read_text(encoding="utf-8")

    assert "assemblyRepresentation=track.shadowRepresentation" in residual
    assert "track.shadowRepresentation" in residual
    assert "track.shadowRepresentation" in refuge
    assert "PASSIVE_SHADOW_ONLY" in follower
    assert "PASSIVE_SHADOW_ONLY" in native_drive


def test_passage_contract_uses_purpose_specific_representation_authority():
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")

    assert 'invalidationConditions={{kind="JOB_EPISODE_CHANGE"},{kind="ESTABLISHED_CONFLICT_CHANGE"},{kind="PASSAGE_SUPPORT_LOSS"}}' in support
    assert 'invalidationConditions={{kind="JOB_EPISODE_CHANGE"},{kind="ESTABLISHED_CONFLICT_CHANGE"},{kind="PASSAGE_SUPPORT_LOSS"},{kind="CURRENT_PHYSICAL_INTERACTION"}}' not in support
    assert "complete-assembly Transit directional envelopes" in support
    assert "generic current physical-conflict DISC overlap is not Passage-clearance authority" in support
    assert "GENERIC_CURRENT_PHYSICAL_CONFLICT_IS_NOT_PASSAGE_CLEARANCE_AUTHORITY" in support


def test_retired_unsourced_config_residue_is_removed():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")

    for token in (
        "DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_ENABLED",
        "DEMONSTRATED_PRODUCTIVE_COVERAGE_PROBE_INTERVAL_MS",
        "DEMONSTRATED_PRODUCTIVE_COVERAGE_CELL_SIZE_M",
        "DEMONSTRATED_PRODUCTIVE_COVERAGE_MAX_SAMPLE_GAP_M",
        "PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_ENABLED",
        "PRODUCTIVE_COVERAGE_RESIDUAL_PROBE_INTERVAL_MS",
        "PRODUCTIVE_COVERAGE_RESIDUAL_HEARTBEAT_MS",
        "REFUGE_QUALIFICATION_SHADOW_PROBE_ENABLED",
        "REFUGE_QUALIFICATION_SHADOW_INFIELD_OFFSETS_M",
        "REFUGE_QUALIFICATION_SHADOW_COVERAGE_SAMPLE_COUNT",
        "HEADLAND_MANOEUVRE_SWEEP_PROBE_ENABLED",
    ):
        assert token not in config

    for rel in (
        "scripts/diagnostics/DemonstratedProductiveCoverageProbe.lua",
        "scripts/diagnostics/ProductiveCoverageResidualProbe.lua",
        "scripts/diagnostics/RefugeQualificationShadowProbe.lua",
    ):
        assert rel not in main
        assert (ROOT / rel).is_file()


def test_test_build_identity_has_two_dynamic_source_owners():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    moddesc = (ROOT / "modDesc.xml").read_text(encoding="utf-8")

    version_match = re.search(r'OuttaMyWay\.VERSION = "([^"]+)"', config)
    label_match = re.search(r'OuttaMyWay\.BUILD_LABEL = "([^"]+)"', config)
    moddesc_match = re.search(r'<version value="([^"]+)">([^<]+)</version>', moddesc)

    assert version_match is not None
    assert label_match is not None
    assert moddesc_match is not None

    version = version_match.group(1)
    build_label = label_match.group(1)
    assert moddesc_match.group(1) == version
    assert moddesc_match.group(2) == version
    assert build_label.startswith(version + " TEST — ")

    # Build Identity Contract != Behaviour Regression Contract.
    assert version not in main

    leaked = []
    for path in sorted((ROOT / "scripts").rglob("*.lua")):
        if path == ROOT / "scripts" / "config.lua":
            continue
        if version in path.read_text(encoding="utf-8"):
            leaked.append(path.relative_to(ROOT).as_posix())
    for path in sorted((ROOT / "tests").rglob("*")):
        if path.is_file() and path.suffix in {".py", ".lua", ".md"}:
            if version in path.read_text(encoding="utf-8"):
                leaked.append(path.relative_to(ROOT).as_posix())
    assert leaked == []


def test_semantic_contracts_do_not_use_development_identity():
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    planner = (ROOT / "scripts" / "candidates" / "LocalPassagePlanner.lua").read_text(encoding="utf-8")
    lifecycle = (ROOT / "scripts" / "commitment" / "LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    control = (ROOT / "scripts" / "control" / "CooperativePassageControl.lua").read_text(encoding="utf-8")
    transition = (ROOT / "scripts" / "responsibility" / "ResponsibilityTransitionAuthority.lua").read_text(encoding="utf-8")
    portfolio = (ROOT / "scripts" / "candidates" / "ProspectiveDecisionPortfolioSupport.lua").read_text(encoding="utf-8")
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    capability = (ROOT / "scripts" / "assessment" / "PassageCapabilityAssessment.lua").read_text(encoding="utf-8")

    current_contract = support + planner + lifecycle + control + transition + portfolio + authority + capability

    for required in (
        'supportBoundary={mode="COOPERATIVE_PASSAGE"',
        'supportBoundary={mode="ACTION_SPACE_REGULATION"',
        'controlAuthority="COOPERATIVE_PASSAGE_BOUNDED_CONTROL"',
        'controlAuthority="RESOLUTION_SPACE_PROGRESSION_ENVELOPE"',
        'referenceKey=(forward and "forward-intersection-regulation:" or "action-space-regulation:")',
        'purpose=forward and {kind="FORWARD_INTERSECTION_INTENT_REVELATION"',
        'or {kind="ACTION_SPACE_REGULATION"',
        '"ACTION_SPACE_REGULATION_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES"',
        '"cooperative-passage-guide:"',
        'mode="COOPERATIVE_PASSAGE_GUIDE"',
        '"COOPERATIVE_PASSAGE_LEG_HANDED_BACK"',
        '"FOLLOWER_BOUNDARY_ACTUATION_QUIESCED"',
        '"ACTION_SPACE_REGULATION_ACTUATION_QUIESCED"',
        '"RESOLUTION_SPACE_PROGRESSION_ENVELOPE_UPDATED"',
    ):
        assert required in current_contract

    for stale in (
        "{d0146=true}",
        '"d0146-guide:"',
        '"d0146-action-space-regulation:"',
        '"D0146_PASSAGE_ACTION_SPACE_CONSERVATION"',
        '"D0146_PASSAGE_ACTION_SPACE_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES"',
        '"D0146_RESOLUTION_SPACE_REGULATION"',
        '"D0146_COOPERATIVE_PASSAGE_STEP2_TEST"',
        '"D0146_BOUNDED_ACTIVE_TEST"',
        '"D0146_GUIDE"',
        "_d0146LongitudinalSeparation",
        "_beginD0146Settling",
        "_preflightD0146Guide",
        "_rebaseD0146Guide",
        "_beginD0146Configuration",
        "_d0146ConfigurationReady",
        "_d0146RestoreReady",
        "_finishD0146Restore",
        "_executeD0146JointRequests",
        '"REGULATION_RATE_IS_TEST_CALIBRATION"',
        '"D0123_SPEED_IS_TEMPORARY_TEST_LITERAL"',
        '"CURRENT_CONFIGURATION_RETAINED_BY_THIS_PAIR_SPECIFIC_CLEARANCE_TEST_TRANCHE"',
        '"D0141_ACTUATION_QUIESCED"',
        '"D0155_ACTUATION_QUIESCED"',
        '"D0155_RESOLUTION_SPACE_ENVELOPE_UPDATED"',
    ):
        assert stale not in current_contract


def test_preserves_provenance_and_telemetry_separately_from_current_identity():
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    lifecycle = (ROOT / "scripts" / "commitment" / "LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")

    # D-numbers remain legitimate where they identify historical decision provenance.
    assert 'decision="D-0146"' in support
    assert 'decision="D-0141"' in lifecycle

def test_semantic_runtime_categories_are_closed():
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    regulation = (ROOT / "scripts" / "control" / "RegulationControl.lua").read_text(encoding="utf-8")
    lifecycle = (ROOT / "scripts" / "commitment" / "LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    situation = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    trajectory = (ROOT / "scripts" / "assessment" / "TrajectoryConflictAssessment.lua").read_text(encoding="utf-8")
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    planner = (ROOT / "scripts" / "candidates" / "LocalPassagePlanner.lua").read_text(encoding="utf-8")
    representation = (ROOT / "scripts" / "representation" / "AssemblyRepresentationCache.lua").read_text(encoding="utf-8")
    portfolio = (ROOT / "scripts" / "candidates" / "ProspectiveDecisionPortfolioSupport.lua").read_text(encoding="utf-8")
    passage = (ROOT / "scripts" / "control" / "CooperativePassageControl.lua").read_text(encoding="utf-8")
    capability = (ROOT / "scripts" / "assessment" / "PassageCapabilityAssessment.lua").read_text(encoding="utf-8")

    # Semantic Rename Requires Producer–Consumer Closure: the Authority producer
    # and Control validation consumer must use the same current owner tags.
    for current in ("FOLLOWER_BOUNDARY", "ACTION_SPACE_REGULATION"):
        assert f'{current}_OWNER_TAG="{current}"' in authority
        assert f'{current}=true' in regulation
    assert "D0141_FOLLOWER_BOUNDARY" not in regulation + authority
    assert "D0146_ACTION_SPACE_CONSERVATION" not in regulation + authority

    # Current function/addressability vocabulary must not carry prototype identity.
    for stale in (
        "d0146CurrentPoseSeparation",
        "d0146CurrentSeparation",
        "_beginD0146Restore",
        "d0146-action-space-composition:",
        "d0123-guarded-recovery:",
        "legacyOrdinal",
    ):
        assert stale not in authority + lifecycle + situation + trajectory + support + portfolio + passage

    # Current representation/control contracts describe purpose, not test tranche/version.
    for stale in (
        "COOPERATIVE_PASSAGE_EXCURSION_V6",
        "GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_TEST",
        "GIANTS_DIRECTIONAL_MEMBER_UNION_PASSAGE_TEST",
        "P22_TS015_CONTROL_EXECUTION_OBSERVATION",
        "D0123_GUARDED_RECOVERY_CURRENT_HEADING_THREAT",
        "D0123_CURRENT_HEADING_THREAT_CLASSIFICATION",
        "BOUNDED_D0123_TEST_REPRESENTATION_ONLY",
    ):
        assert stale not in capability + planner + representation + situation + support

    assert "COOPERATIVE_PASSAGE_EXCURSION" in capability + planner
    assert "GIANTS_BASE_SIZE_DIRECTIONAL_PASSAGE_GEOMETRY" in representation + planner
    assert "GIANTS_DIRECTIONAL_MEMBER_UNION_PASSAGE_GEOMETRY" in representation
    assert "action-space-regulation-composition:" in support
    assert "enumerationOrdinal" in portfolio

    # Returned/stored current runtime reasons and statuses are production vocabulary.
    semantic_result_files = authority + lifecycle + trajectory + support
    for stale in (
        'reason="D0123_',
        'reason="D0141_',
        'reason="D0146_',
        'reason="D0155_',
        'lastStatus="D0146_',
        '"PRESERVE_D0146_PASSAGE_ACTION_SPACE',
    ):
        assert stale not in semantic_result_files

    # Historical provenance and stable forensic event names remain legitimate.
    assert 'decision="D-0146"' in support
    assert 'decision="D-0141"' in lifecycle
    assert 'logInfo("D0146_' in passage

def test_semantic_recognition_and_validation_topology_are_closed():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    lifecycle = (ROOT / "scripts" / "commitment" / "LiveTrafficCommitmentLifecycle.lua").read_text(encoding="utf-8")
    transition = (ROOT / "scripts" / "responsibility" / "ResponsibilityTransitionAuthority.lua").read_text(encoding="utf-8")
    situation = (ROOT / "scripts" / "assessment" / "SituationAssessment.lua").read_text(encoding="utf-8")
    trajectory = (ROOT / "scripts" / "assessment" / "TrajectoryConflictAssessment.lua").read_text(encoding="utf-8")
    planner = (ROOT / "scripts" / "candidates" / "LocalPassagePlanner.lua").read_text(encoding="utf-8")
    passage = (ROOT / "scripts" / "control" / "CooperativePassageControl.lua").read_text(encoding="utf-8")
    workflow = (ROOT / ".github" / "workflows" / "offline-validation.yml").read_text(encoding="utf-8")

    # Prefix Identity Rename Requires Prefix-Length Revalidation.
    assert 'hasPrefix(responsibility,"cooperative-passage:")' in lifecycle
    assert 'hasPrefix(responsibility,"cooperative-passage:")' in transition
    assert 'string.sub(responsibility,1,26)=="cooperative-passage:"' not in lifecycle
    assert 'string.sub(responsibility,1,26)~="cooperative-passage:"' not in transition
    assert "jobDependentTrafficResponsibility" in lifecycle
    assert "d0146TrafficResponsibility" not in lifecycle

    # Current execution/addressability identity names current responsibilities.
    assert "d0146PassageFitness" not in situation
    assert '"opposed-corridor:"' in trajectory
    assert '"d0146-opposed:"' not in trajectory
    assert '"cooperative-passage-arrangement:"' in planner
    assert '"d0146-arrangement:"' not in planner

    # One current Passage actuation calibration; the retired donor identifier
    # remains retired rather than being resurrected by semantic cleanup.
    assert "COOPERATIVE_PASSAGE_ACTUATION_SPEED_KMH = 8.0" in config
    assert "COOPERATIVE_PASSAGE_MOVE_SPEED_KMH = 8.0" not in config
    assert "COOPERATIVE_PASSAGE_ACTUATION_SPEED_KMH or 8.0" in passage

    # Entry-Point Retirement Implies Lifecycle-Tail Retirement.
    assert "function Control:_beginParticipantRestore(run,participant)" in passage
    assert 'run.phase=="RESTORING_PARTICIPANT"' in passage
    assert "function Control:_passageRestoreReady(run)" not in passage
    assert "function Control:_finishPassageRestore(run)" not in passage
    assert "function Control:_complete(run)" not in passage
    assert 'run.phase=="RESTORING"' not in passage

    # Validation Inventory Is Executable Topology.
    assert "tests/test_production_vocabulary_ownership_structure.py" in workflow
