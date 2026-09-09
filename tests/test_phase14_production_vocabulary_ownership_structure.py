from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def test_phase14_6c_primary_live_vocabulary_uses_current_responsibilities():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")
    capability = (ROOT / "scripts" / "assessment" / "PassageCapabilityAssessment.lua").read_text(encoding="utf-8")
    authority = (ROOT / "scripts" / "authority" / "RegulationBoundedAuthority.lua").read_text(encoding="utf-8")
    recovery = (ROOT / "scripts" / "control" / "GuardedRecoveryCompatibility.lua").read_text(encoding="utf-8")
    runtime = (ROOT / "scripts" / "runtime" / "Runtime.lua").read_text(encoding="utf-8")

    for token in (
        "COOPERATIVE_PASSAGE_NOMINAL_INTER_ASSEMBLY_CLEARANCE_M",
        "COOPERATIVE_PASSAGE_EXCURSION_V6",
        'purpose={kind="COOPERATIVE_PASSAGE"',
        'architecture="COOPERATIVE_PASSAGE"',
        "cooperative-passage:",
        "actionSpaceRegulationBridge",
        "FOLLOWER_BOUNDARY_OWNER_TAG",
        "ACTION_SPACE_REGULATION_OWNER_TAG",
        "GUARDED_RECOVERY_OWNER_TAG",
        "GUARDED_RECOVERY_NATIVE_HANDOVER_CREEP_KMH",
        "completedObstructionCandidateSupport",
    ):
        assert token in config + support + capability + authority + recovery + runtime

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
    ):
        assert stale not in config + support + capability + authority + recovery + runtime


def test_phase14_6c_passage_contract_uses_purpose_specific_representation_authority():
    support = (ROOT / "scripts" / "candidates" / "LiveTrafficCandidateSupport.lua").read_text(encoding="utf-8")

    assert 'invalidationConditions={{kind="JOB_EPISODE_CHANGE"},{kind="ESTABLISHED_CONFLICT_CHANGE"},{kind="PASSAGE_SUPPORT_LOSS"}}' in support
    assert 'invalidationConditions={{kind="JOB_EPISODE_CHANGE"},{kind="ESTABLISHED_CONFLICT_CHANGE"},{kind="PASSAGE_SUPPORT_LOSS"},{kind="CURRENT_PHYSICAL_INTERACTION"}}' not in support
    assert "complete-assembly Transit directional envelopes" in support
    assert "generic current physical-conflict DISC overlap is not Passage-clearance authority" in support
    assert "GENERIC_CURRENT_PHYSICAL_CONFLICT_IS_NOT_PASSAGE_CLEARANCE_AUTHORITY" in support


def test_phase14_6c_retired_unsourced_config_residue_is_removed():
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


def test_phase14_6c_test_build_identity_is_atomic():
    config = (ROOT / "scripts" / "config.lua").read_text(encoding="utf-8")
    main = (ROOT / "scripts" / "main.lua").read_text(encoding="utf-8")
    moddesc = (ROOT / "modDesc.xml").read_text(encoding="utf-8")

    assert 'OuttaMyWay.VERSION = "0.3.0.34"' in config
    assert 'OuttaMyWay.BUILD_LABEL = "0.3.0.34 TEST — PRODUCTION VOCABULARY OWNERSHIP RECONCILIATION"' in config
    assert "v0.3.0.34 TEST — PRODUCTION VOCABULARY OWNERSHIP RECONCILIATION" in main
    assert '<version value="0.3.0.34">0.3.0.34</version>' in moddesc
