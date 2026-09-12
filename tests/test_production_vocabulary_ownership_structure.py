from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]


def test_primary_live_vocabulary_uses_current_responsibilities():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    capability = (ROOT / "scripts" / "assessment" / "PassageCapabilityAssessment.lua").read_text(encoding="utf-8")
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")

    planner = (ROOT / "scripts/candidates/LocalPassagePlanner.lua").read_text(encoding="utf-8")

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
        assert token in config + support + capability + authority + runtime + planner

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
        assert stale not in config + support + capability + authority + runtime + planner


def test_issue112_graduated_physical_representation_uses_current_names_without_erasing_distinct_evidence_contracts():
    current_paths = (
        ROOT / "scripts" / "observation" / "LiveObservationSource.lua",
        ROOT / "scripts" / "observation" / "FieldBoundedFutureSpace.lua",
        ROOT / "scripts" / "observation" / "CurrentPhysicalPoseSource.lua",
        ROOT / "scripts" / "assessment" / "SituationAssessment.lua",
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
    native_drive = (ROOT / "scripts" / "diagnostics" / "NativeFieldWorkerDriveCommandProbe.lua").read_text(encoding="utf-8")

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
        assert not (ROOT / rel).exists()


def test_test_build_identity_has_two_dynamic_source_owners():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    moddesc = (ROOT / "modDesc.xml").read_text(encoding="utf-8")

    version_match = re.search(r'OuttaMyWay\.VERSION = "([^"]+)"', config)
    moddesc_match = re.search(r'<version value="([^"]+)">([^<]+)</version>', moddesc)

    assert version_match is not None
    assert moddesc_match is not None

    version = version_match.group(1)
    assert re.fullmatch(r"0\.\d+\.\d+\.\d+", version)
    assert moddesc_match.group(1) == version
    assert moddesc_match.group(2) == version

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


def _loaded_production_lua_paths():
    main_path = ROOT / "scripts" / "main.lua"
    main = main_path.read_text(encoding="utf-8")
    paths = [main_path]
    for relative in re.findall(r'"(scripts/[^"]+\.lua)"', main):
        path = ROOT / relative
        assert path.is_file(), relative
        paths.append(path)
    return paths


def test_sourced_production_has_no_retired_root_identity():
    # Match identifiers, not substrings of distinct Passage rejection reasons.
    retired_identity = re.compile(
        r"\b(?:BUILD_LABEL|ARCHITECTURE_VERSION|RUNTIME_MODE|runtimeMode)\b"
    )
    paths = set(_loaded_production_lua_paths())
    paths.add(ROOT / "scripts" / "config.lua")
    offenders = []
    for path in sorted(paths):
        text = path.read_text(encoding="utf-8")
        for match in retired_identity.finditer(text):
            line = text.count("\n", 0, match.start()) + 1
            offenders.append(
                f"{path.relative_to(ROOT).as_posix()}:{line}:{match.group(0)}"
            )
    assert offenders == []


def test_sourced_production_vocabulary_has_no_historical_decision_identity():
    historical_identity = re.compile(r"(?i)d-?\d{4}")
    offenders = []
    for path in _loaded_production_lua_paths():
        text = path.read_text(encoding="utf-8")
        for match in historical_identity.finditer(text):
            line = text.count("\n", 0, match.start()) + 1
            offenders.append(
                f"{path.relative_to(ROOT).as_posix()}:{line}:{match.group(0)}"
            )
    assert offenders == []



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

    # Current production provenance and forensic telemetry name current
    # responsibilities. Historical decision identity is enforced repository-wide
    # over the sourced production surface by the dedicated test above.
    assert 'decision="COOPERATIVE_PASSAGE"' in support + lifecycle
    assert 'decision="FOLLOWER_BOUNDARY"' in support + lifecycle
    assert 'logInfo("COOPERATIVE_PASSAGE_' in passage

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
    assert "local COOPERATIVE_PASSAGE_ACTUATION_SPEED_KMH = 8.0" in passage
    assert "COOPERATIVE_PASSAGE_MOVE_SPEED_KMH = 8.0" not in config
    assert "speedKmh=COOPERATIVE_PASSAGE_ACTUATION_SPEED_KMH" in passage

    # Entry-Point Retirement Implies Lifecycle-Tail Retirement.
    assert "function Control:_beginParticipantRestore(run,participant)" in passage
    assert 'run.phase=="RESTORING_PARTICIPANT"' in passage
    assert "function Control:_passageRestoreReady(run)" not in passage
    assert "function Control:_finishPassageRestore(run)" not in passage
    assert "function Control:_complete(run)" not in passage
    assert 'run.phase=="RESTORING"' not in passage

    # Validation Inventory Is Executable Topology.
    assert "tests/test_production_vocabulary_ownership_structure.py" in workflow


def test_cooperative_passage_control_owns_execution_calibration():
    config = (ROOT / "scripts/config.lua").read_text(encoding="utf-8")
    owner = ROOT / "scripts/control/CooperativePassageControl.lua"
    passage = owner.read_text(encoding="utf-8")
    # Independent accepted literals and their operational paths, not values
    # inferred from the implementation declarations.
    expected = (
        ("COOPERATIVE_PASSAGE_ACTUATION_SPEED_KMH", "8.0",
         "_executeCooperativePassageJointRequests", "speedKmh="),
        ("COOPERATIVE_PASSAGE_PHASE_WATCHDOG_MS", "45000",
         "update", "local timeout="),
        ("COOPERATIVE_PASSAGE_ALIGNMENT_LATERAL_TOLERANCE_M", "0.50",
         "_assemblyAxisSettled", "local lateralTolerance="),
        ("COOPERATIVE_PASSAGE_ALIGNMENT_HEADING_MIN_DOT", "0.995",
         "_assemblyAxisSettled", "local headingMinDot="),
        ("COOPERATIVE_PASSAGE_HOLD_EFFECT_SPEED_KMH", "0.25",
         "_allStopped", "local limit="),
        ("COOPERATIVE_PASSAGE_HEARTBEAT_MS", "1000",
         "update", "self.nextHeartbeatMs=nowMs+"),
    )
    for name, literal, method, use in expected:
        assert name not in config
        assert re.search(rf"^local {name} = {re.escape(literal)}$", passage, re.M)
        block = passage.split(f"function Control:{method}(", 1)[1].split("\nfunction Control:", 1)[0]
        assert re.search(rf"{re.escape(use + name)}\s*$", block, re.M)
        assert f"OuttaMyWay.{name}" not in passage
        for path in _loaded_production_lua_paths():
            if path != owner:
                assert name not in path.read_text(encoding="utf-8"), path

    assert "run.nextReturnClearDiagnosticMs=nowMs+COOPERATIVE_PASSAGE_HEARTBEAT_MS" in passage
    for use in (
        "actualSpeedKmh(p.vehicle)>limit",
        "math.abs(vehicleLateral)>lateralTolerance",
        "vehicleHeadingDot<headingMinDot",
        "memberHeadingDot<headingMinDot",
        "nowMs-(run.phaseStartedAt or nowMs)>=timeout",
    ):
        assert use in passage


def test_passage_guide_radius_and_axis_station_tolerance_have_independent_owners():
    planner_owner = ROOT / "scripts/candidates/LocalPassagePlanner.lua"
    control_owner = ROOT / "scripts/control/CooperativePassageControl.lua"
    planner = planner_owner.read_text(encoding="utf-8")
    passage = control_owner.read_text(encoding="utf-8")
    config = (ROOT / "scripts/config.lua").read_text(encoding="utf-8")
    radius = "COOPERATIVE_PASSAGE_TRAVERSAL_GATE_RADIUS_M"
    tolerance = "COOPERATIVE_PASSAGE_AXIS_TRAVEL_STATION_TOLERANCE_M"
    # Calibration equality does not create shared policy or a mutable root seam.
    for name, owner, text in ((radius, planner_owner, planner), (tolerance, control_owner, passage)):
        assert name not in config
        assert re.search(rf"^local {name} = 1\.0$", text, re.M)
        assert len(re.findall(rf"\b{name}\s*=(?!=)", text)) == 1
        assert not re.search(rf"[.\[]\s*[\"']?{name}\b", text)
        for path in _loaded_production_lua_paths():
            if path != owner:
                assert name not in path.read_text(encoding="utf-8"), path
        for path in (ROOT / "tests").rglob("*.lua"):
            assert name not in path.read_text(encoding="utf-8"), path

    guide = planner.split("local function makeGuide(", 1)[1].split("\nlocal function ", 1)[0]
    assert f"local traversalRadius={radius}" in guide
    for kind, forward in (("CROSSING_WINDOW_ENTRY", "development"),
                          ("CROSSING_WINDOW_EXIT", "development+traversal")):
        assert f'{{kind="{kind}",forwardM={forward},lateralFraction=1.0,radiusM=traversalRadius}}' in guide
    for participant in ("subject", "other"):
        assert re.search(rf"gate\.{participant}=\{{[^\n]+radiusM=gate\.radiusM\}}", guide)

    for method, station, forwards in (("_startRunoutChunk", "progress+length", "true"),
                                      ("_beginAxisReturn", "0", "false")):
        block = passage.split(f"function Control:{method}(", 1)[1].split("\nfunction Control:", 1)[0]
        assert f"local tolerance={tolerance}" in block
        assert ("self.driveMechanism:setAxisTravel(participant.vehicle,participant.executionOriginX,"
                "participant.executionOriginZ,participant.axisForwardX,participant.axisForwardZ,"
                f"{station},run.speedKmh,{forwards},tolerance)") in block
    gate = passage.split("function Control:_startGuideGate(", 1)[1].split("\nfunction Control:", 1)[0]
    assert tolerance not in gate
    assert "local target=self:_guideTargetFor(run,p,gate)" in gate
    assert "p.targetX,p.targetZ,p.targetRadiusM=target.x,target.z,target.radiusM" in gate
    assert "self.driveMechanism:setReposition(p.vehicle,target.x,target.z,run.speedKmh,target.radiusM)" in gate


def test_native_drive_materialises_distinct_spatial_and_station_completion():
    drive = (ROOT / "scripts/control/mechanisms/NativeDriveMechanism.lua").read_text(encoding="utf-8")
    axis = drive.split('state.mode == "AXIS_TRAVEL"', 1)[1].split('state.mode == "REPOSITION"', 1)[0]
    for expression in (
        "local progress=(x-ox)*fx+(z-oz)*fz",
        "local targetStation=tonumber(state.targetStationM)",
        "local tolerance=math.max(0,tonumber(state.stationToleranceM) or 0)",
        "local reached=(forwards and progress+tolerance>=targetStation) or ((not forwards) and progress-tolerance<=targetStation)",
    ):
        assert expression in axis
    reposition = drive.split('state.mode == "REPOSITION"', 1)[1]
    assert "local dx, dz = state.targetX - x, state.targetZ - z" in reposition
    assert "local remaining = math.sqrt(dx * dx + dz * dz)" in reposition
    assert "remaining <= (tonumber(state.targetRadiusM) or 1.0)" in reposition
    assert "stationToleranceM=stationToleranceM" in drive
    assert "targetRadiusM = targetRadiusM" in drive


def test_local_passage_planner_owns_fixed_construction_policy_and_calibration():
    owner = ROOT / "scripts/candidates/LocalPassagePlanner.lua"
    planner = owner.read_text(encoding="utf-8")
    config = (ROOT / "scripts/config.lua").read_text(encoding="utf-8")
    expected = {
        "COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M": "1.0",
        "COOPERATIVE_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO": "0.95",
        "COOPERATIVE_PASSAGE_MIN_DEVELOPMENT_DISTANCE_M": "4.0",
        "COOPERATIVE_PASSAGE_DEVELOPMENT_FORWARD_PER_LATERAL_M": "2.0",
        "COOPERATIVE_PASSAGE_ENTRY_CONTROL_ALLOWANCE_M": "3.0",
        "COOPERATIVE_PASSAGE_DEVELOPMENT_GATE_RADIUS_M": "2.0",
        "COOPERATIVE_PASSAGE_REACQUISITION_GATE_RADIUS_M": "2.0",
        "COOPERATIVE_PASSAGE_FIELD_SWEEP_SAMPLE_M": "2.0",
        "COOPERATIVE_PASSAGE_PAIR_SWEEP_SAMPLES_PER_LEG": "20",
    }
    # Pin accepted literals independently. One local declaration, no reassignment,
    # root lookup, exported setting or alternate production consumer.
    for name, literal in expected.items():
        assert name not in config
        assert re.search(rf"^local\s+{name}\s*=\s*{re.escape(literal)}\s*$", planner, re.M)
        assert len(re.findall(rf"\b{name}\s*=(?!=)", planner)) == 1
        assert not re.search(rf"[.\[]\s*[\"']?{name}\b", planner)
        for path in _loaded_production_lua_paths():
            if path != owner:
                assert name not in path.read_text(encoding="utf-8"), path

    # Whitespace-independent expressions protect calculation and use, including
    # both independent sweep sites. Existing guide/Transit/Control contracts remain.
    code = re.sub(r"\s+", "", re.sub(r"--[^\n]*", "", planner))
    for expression in (
        "localnominalClearance=COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M",
        "PairSpecificPassageClearance.currentPair(aPhysical,aSpace,bPhysical,bSpace,rightX,rightZ,nominalClearance)",
        "localminimumDevelopment=COOPERATIVE_PASSAGE_MIN_DEVELOPMENT_DISTANCE_M",
        "localforwardPerLateral=COOPERATIVE_PASSAGE_DEVELOPMENT_FORWARD_PER_LATERAL_M",
        "ifmaximumOffset>0.001then",
        "development=math.max(minimumDevelopment,maximumOffset*forwardPerLateral)",
        "localrecovery=development",
        "localentryAllowance=COOPERATIVE_PASSAGE_ENTRY_CONTROL_ALLOWANCE_M",
        "localentryBoundary=frontOverlap+2*development+entryAllowance",
        "localtraversalRadius=COOPERATIVE_PASSAGE_TRAVERSAL_GATE_RADIUS_M",
        "localdevelopmentRadius=math.min(COOPERATIVE_PASSAGE_DEVELOPMENT_GATE_RADIUS_M,math.max(traversalRadius,development*0.25))",
        "localrecoveryRadius=math.min(COOPERATIVE_PASSAGE_REACQUISITION_GATE_RADIUS_M,math.max(traversalRadius,recovery*0.25))",
        "localstepM=COOPERATIVE_PASSAGE_FIELD_SWEEP_SAMPLE_M",
        "segmentInsideField(p0.x,p0.z,p1.x,p1.z,fieldWorld,stepM)",
        "localrequired=tonumber(nominalClearanceM)or1.0",
        "localacceptanceRatio=COOPERATIVE_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO",
        "acceptanceRatio=math.max(0,acceptanceRatio)",
        "localacceptedFloor=required*acceptanceRatio",
        'ifminimumCrossing==math.hugeorminimumCrossing+0.001<acceptedFloorthenreturnfalse,"PAIR_SPECIFIC_NOMINAL_CLEARANCE_FLOOR_NOT_SUPPORTED_IN_CROSSING_WINDOW",evidence()end',
        'ifminimumOutsideCrossing<-0.001thenreturnfalse,"PAIR_SPECIFIC_NON_CONTACT_NOT_SUPPORTED_OUTSIDE_CROSSING_WINDOW",evidence()end',
    ):
        assert expression in code, expression
    assert code.count("localsamples=COOPERATIVE_PASSAGE_PAIR_SWEEP_SAMPLES_PER_LEG") == 2
    for method in ("pairSweepSupport", "thirdPartyGuideSupport"):
        block = planner.split(f"local function {method}(", 1)[1].split("\nlocal function ", 1)[0]
        compact = re.sub(r"\s+", "", block)
        assert "localsamples=COOPERATIVE_PASSAGE_PAIR_SWEEP_SAMPLES_PER_LEG" in compact
        if method == "pairSweepSupport":
            assert "fori=0,samplesdo" in compact
        else:
            assert "segmentDirectionalEnvelopeAgainstThirdParty(" in compact
            assert "segmentAgainstThirdParty(" in compact
            assert compact.count("third,nominalClearanceM,samples)") == 2

    helper = (ROOT / "scripts/representation/PairSpecificPassageClearance.lua").read_text(encoding="utf-8")
    assert "rightX,rightZ,nominalClearanceM)" in helper
    assert "local margin=tonumber(nominalClearanceM)" in helper
    assert re.findall(r"function Planner\.([^\n]+)", planner) == [
        "planConflict(picture,snapshot,conflict)", "plan(picture,snapshot)"
    ]
    # Counterfactual Test Input != Supported Runtime Policy: no harness retains
    # a root lookup/write, including a bracket-form override.
    for path in (ROOT / "tests").rglob("*.lua"):
        assert "COOPERATIVE_PASSAGE_CLEARANCE_ACCEPTANCE_RATIO" not in path.read_text(encoding="utf-8"), path


def test_config_root_is_comment_free_identity_only():
    config = (ROOT / "scripts/config.lua").read_text(encoding="utf-8")
    assignments = re.findall(r"^OuttaMyWay\.(\w+)\s*=\s*([^\n]+)$", config, re.M)
    assert [name for name, _ in assignments] == ["MOD_NAME", "VERSION"]
    assert config.splitlines() == [
        "OuttaMyWay = OuttaMyWay or {}",
        'OuttaMyWay.MOD_NAME = g_currentModName or "FS25_OuttaMyWay"',
        f"OuttaMyWay.VERSION = {dict(assignments)['VERSION']}",
    ]
    assert config.endswith("\n")
    assert "--" not in config
