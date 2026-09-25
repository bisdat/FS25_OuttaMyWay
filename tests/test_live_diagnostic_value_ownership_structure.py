from pathlib import Path
import re

ROOT = Path(__file__).resolve().parents[1]

def read(relative):
    return (ROOT / relative).read_text(encoding="utf-8")

RETIRED_DIAGNOSTICS = (
    "scripts/diagnostics/ArchitectureTrace.lua",
    "scripts/diagnostics/TargetedFieldIdentityProbe.lua",
    "scripts/diagnostics/FutureSpaceHud.lua",
    "scripts/diagnostics/ProductiveContinuationProbe.lua",
    "scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua",
    "scripts/diagnostics/ProgressionPreservationProbe.lua",
    "scripts/diagnostics/FollowerPacingHud.lua",
)

def test_issue152_completed_question_diagnostics_are_not_shipped_or_wired():
    main = read("scripts/main.lua")
    runtime = read("scripts/runtime/Runtime.lua")
    coordinator = read("scripts/runtime/LiveRuntimeCoordinator.lua")
    validator = read("scripts/diagnostics/PassiveLiveValidator.lua")

    for relative in RETIRED_DIAGNOSTICS:
        assert not (ROOT / relative).exists(), relative
        assert relative not in main

    for token in (
        "ArchitectureTrace",
        "TargetedFieldIdentityProbe",
        "FutureSpaceHud",
        "ProductiveContinuationProbe",
        "NativeFieldWorkerDriveCommandProbe",
        "ProgressionPreservationProbe",
        "FollowerPacingHud",
        "targetedFieldIdentityProbe",
        "productiveContinuationProbe",
        "nativeFieldWorkerDriveCommandProbe",
        "progressionPreservationProbe",
        "futureSpaceHud",
        "followerPacingHud",
    ):
        assert token not in main + runtime + coordinator + validator, token

    assert "fieldIdentityProbeSampleCount" not in runtime
    assert "traceCount" not in runtime
    assert "self.trace" not in runtime
    assert "runtime.trace" not in validator

def test_issue152_promoted_knowledge_survives_probe_retirement():
    main = read("scripts/main.lua")
    situation = read("scripts/assessment/SituationAssessment.lua")
    resolution_margin = read("scripts/assessment/ResolutionMarginDemandAssessment.lua")
    live_jobs = read("scripts/observation/LiveAIJobEvidence.lua")
    native_field_work = read("scripts/observation/NativeFieldWorkObservation.lua")

    assert "scripts/observation/LiveAIJobEvidence.lua" in main
    assert "scripts/observation/NativeFieldWorkObservation.lua" in main
    assert "scripts/assessment/ResolutionMarginDemandAssessment.lua" in main

    assert "SituationAssessment.ProductiveContinuation" in situation
    assert "productiveContinuationKnowledge" in situation
    assert "latestProductiveContinuationByReference" in situation
    assert "nativeFieldWork" in situation
    assert "semanticAuthority=false" in native_field_work

    assert "OuttaMyWay.ResolutionMarginDemandAssessment" in resolution_margin
    assert "POSITIVE_WITNESS_WITHIN_LOCAL_INTENT" in resolution_margin
    assert "ProgressionGeometry.rayCapsuleEntry" in resolution_margin
    assert "negativeClearanceAuthority=false" in resolution_margin

    assert "activeJobVehicles" in live_jobs
    assert "resolveField" in live_jobs
    assert "jobToken" in live_jobs

def test_issue152_native_drive_research_knowledge_survives_runtime_probe_retirement():
    decision = read("docs/DECISION_LOG.md")
    d0137 = read("docs/research/prototypes/PROTOTYPE_32_NATIVE_AI_DRIVE_SIGNAL_SHADOW.md")
    d0138 = read("docs/research/prototypes/PROTOTYPE_33_NATIVE_FIELD_WORKER_DRIVE_COMMAND_SHADOW.md")
    assert "D-0137" in decision and "falsified" in decision
    assert "D-0138" in decision and "aiDriveParams" in decision
    assert "Result — falsified" in d0137
    assert "Fast falsification" in d0138

def test_issue152_version_hud_remains_temporary_development_build_identity_only():
    main = read("scripts/main.lua")
    config = read("scripts/config.lua")
    hud = read("scripts/diagnostics/VersionHud.lua")

    assert "scripts/diagnostics/VersionHud.lua" in main
    assert "local versionHud=OuttaMyWay.VersionHud.new()" in main
    lifecycle = read("scripts/lifecycle/ProductLifecycle.lua")
    assert "OuttaMyWay.versionHud=bundle.versionHud" in lifecycle
    assert "addModEventListener(OuttaMyWay.versionHud)" in main
    assert "local VERSION_HUD_ENABLED=true" in hud
    assert "local VERSION_HUD_X=0.985" in hud
    assert "local VERSION_HUD_Y=0.720" in hud
    assert "local VERSION_HUD_TEXT_SIZE=0.014" in hud
    assert 'string.format("OuttaMyWay %s",tostring(OuttaMyWay.VERSION or "?"))' in hud
    for name in ("VERSION_HUD_ENABLED","VERSION_HUD_X","VERSION_HUD_Y","VERSION_HUD_TEXT_SIZE"):
        assert re.search(rf"OuttaMyWay\.{name}\b", config) is None

def test_issue152_stage2a_passive_diagnostics_are_ephemeral_and_do_not_own_runtime_history():
    main = read("scripts/main.lua")
    runtime = read("scripts/runtime/Runtime.lua")
    coordinator = read("scripts/runtime/LiveRuntimeCoordinator.lua")
    validator = read("scripts/diagnostics/PassiveLiveValidator.lua")
    identities = read("scripts/identity/IdentityRegistry.lua")

    assert "scripts/diagnostics/PassiveLiveValidator.lua" in main
    assert "scripts/contracts/PassiveLiveTraceRecord.lua" not in main
    assert not (ROOT / "scripts/contracts/PassiveLiveTraceRecord.lua").exists()
    assert "runtime.passiveLiveValidator=OuttaMyWay.PassiveLiveValidator.new(runtime)" in runtime
    assert "addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)" in main
    assert "PASSIVE_HEARTBEAT_INTERVAL_MS=10000" in validator
    assert "PASSIVE_DIAGNOSTIC_MAX_PAIR_LOG_LINES_PER_SAMPLE=8" in validator
    assert "function Validator:_project(live)" in validator
    assert "function Validator:observeRuntimeResult(live,due,nowMilliseconds)" in validator
    assert "self.runtime.identities" not in validator
    assert "self.runtime.epochs" not in validator
    assert "PASSIVE_LIVE_TRACE" not in validator
    assert "PASSIVE_LIVE_TRACE" not in identities
    assert "self.records" not in validator
    assert "getRecords" not in validator
    assert "getErrorCount" not in validator
    assert "passiveTraceCount" not in runtime
    assert "passiveErrorCount" not in runtime
    assert "local records={}" not in coordinator
    assert "endRuntimeCycle" not in coordinator
    assert "observeRuntimeError" not in coordinator + validator
    assert "pcall(self.diagnosticObserver.observeRuntimeResult" in coordinator


