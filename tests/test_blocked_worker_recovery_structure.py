from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]

def read(path):
    return (ROOT/path).read_text(encoding="utf-8")

def test_recovery_jurisdiction_is_implemented_by_truthful_vertical_slice():
    spec=read("spec/BLOCKED_WORKER_RECOVERY.md")
    assert "Implementation Status" not in spec
    for path in (
        "scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua",
        "scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua",
        "scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua",
        "scripts/control/BlockedWorkerRecoveryControl.lua",
    ):
        source=read(path)
        assert "`BLOCKED_WORKER_RECOVERY`" in source
        assert path in spec

def test_recovery_trail_qualification_does_not_select_the_recovery_point():
    assessment=read("scripts/assessment/BlockedProgressAssessment.lua")
    architecture=read("architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md")
    spec=read("spec/BLOCKED_WORKER_RECOVERY.md")
    assert "TRAIL_MIN_USEFUL_SPAN_M=5.0" in assessment
    assert "local first=track.trail[1]" in assessment
    assert "span<TRAIL_MIN_USEFUL_SPAN_M" in assessment
    assert "span>=TRAIL_MIN_USEFUL_SPAN_M" not in assessment
    assert "first/oldest retained compatible" in architecture
    assert "first/oldest retained compatible" in spec

def test_recovery_candidate_owns_physical_and_native_replanning_obligations():
    candidate=read("scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua")
    lifecycle=read("scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua")
    spec=read("spec/BLOCKED_WORKER_RECOVERY.md")

    assert 'requiredOutcome={kind="BLOCKED_WORKER_RECOVERY_ANCHOR_REACHED_IN_TRANSIT"}' in candidate
    assert 'requiredOutcome={kind="BLOCKED_WORKER_RECOVERY_SUCCESSOR_JOB_EPISODE_ADMITTED"}' in candidate
    assert "function Lifecycle.settlePhysicalRecovery" in lifecycle
    assert "Phase Completion != Resolution Completion" in spec
    assert "Resolution Completion = Immediate Recovery Release" in spec

def test_initial_recovery_moves_directly_to_selected_anchor_without_second_geometry_policy():
    candidate=read("scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua")
    control=read("scripts/control/BlockedWorkerRecoveryControl.lua")
    spec=read("spec/BLOCKED_WORKER_RECOVERY.md")

    assert 'recoveryPoint="RECOVERY_ANCHOR"' in candidate
    assert "state.anchorX,state.anchorZ" in control
    assert "setReposition" in control
    assert ",false)" in control
    assert "Recovery Anchor = Initial Recovery Point" in spec

    combined=candidate+"\n"+control
    assert "RecoveryReleaseDirection" not in combined
    assert "recoveryReleaseDirection" not in combined
    assert "excursionDistance" not in combined
    assert "releaseDirection" not in combined

def test_recovery_always_requests_transit_then_native_replans_without_success_restore():
    control=read("scripts/control/BlockedWorkerRecoveryControl.lua")
    request_pos=control.index("function Control:_requestTransit")
    movement_pos=control.index("function Control:_beginMovement")
    assert "prepareCachedTransit" in control[request_pos:]
    assert "WAITING_FOR_TRANSIT" in control
    assert "function Control:_replaceNativeFieldWorkJob" in control
    assert "WAITING_FOR_REPLACEMENT_JOB_EPISODE" in control
    assert "RECOVERY_INTENDED_SUCCESSOR_JOB_EPISODE_ADMITTED" in control
    assert "configurationMechanism:clear(state.vehicle)" in control
    assert "successful Recovery never restores after the Anchor" in control
    assert "BLOCKED_WORKER_RECOVERY_LOCAL_RETURN_REFERENCE" in read("scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua")
    assert 'acceptedStates={"FIT_FOR_LIMITED_HORIZON"}' in read("scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua")
    assert 'configurationPolicy="ALWAYS_REQUEST_TRANSIT_THEN_NATIVE_REPLAN"' in read("scripts/runtime/Runtime.lua")

def test_recovery_responsibility_semantics_are_preflighted_before_commitment_admission():
    transition=read("scripts/responsibility/BlockedWorkerRecoveryResponsibilityTransition.lua")
    adapter=read("scripts/responsibility/ResolutionCommitmentAdapter.lua")
    architecture=read("architecture/RUNTIME_RESPONSIBILITY_ARCHITECTURE.md")
    spec=read("spec/RESPONSIBILITY_TRANSITION.md")

    preflight_pos=transition.index("ResolutionCommitmentAdapter.preflightCandidate")
    admission_pos=transition.index("BlockedWorkerRecoveryCommitmentLifecycle.applyDecision")
    assert preflight_pos < admission_pos
    assert '"BLOCKED_WORKER_RECOVERY_ANCHOR_REACHED_IN_TRANSIT"' in transition
    assert '"BLOCKED_WORKER_RECOVERY_SUCCESSOR_JOB_EPISODE_ADMITTED"' in transition
    assert "BLOCKED_WORKER_RECOVERY_RESTORED_AND_HANDED_BACK" not in transition
    assert "function Adapter.preflightCandidate" in adapter
    assert "Successor Semantic Preflight Must Precede Retained Admission" in architecture
    assert "Failed Responsibility Transition Must Not Leak Actuation Ownership" in spec

def test_recovery_resolution_does_not_restore_operation_global_decision_horizon():
    runtime=read("scripts/runtime/Runtime.lua")
    exclusive_block=runtime[runtime.index("local exclusiveResolution=false"):runtime.index("local supported=nil",runtime.index("local exclusiveResolution=false"))]
    assert 'kind~="BLOCKED_WORKER_RECOVERY"' in exclusive_block
    assert "activeResolution" not in runtime

def test_concurrent_recovery_create_is_explicit_and_still_uses_generic_admission_exclusivity():
    recovery=read("scripts/candidates/BlockedWorkerRecoveryCandidateSupport.lua")
    selector=read("scripts/decision/DecisionSelector.lua")
    boundary=read("scripts/commitment/DecisionCommitmentBoundary.lua")
    admission=read("scripts/commitment/CommitmentAdmission.lua")

    assert "independentConcurrentCommitment=true" in recovery
    assert "selected.evidenceBasis.independentConcurrentCommitment==true" in selector
    assert 'local context = action=="CREATE" and nil or targetContext(picture)' in boundary
    assert "actuation authority already owned for assembly" in admission
    assert "unresolved responsibility already owned by Commitment" in admission

def test_recovery_failure_before_anchor_restores_partial_transit_but_success_relinquishes_without_restore():
    runtime=read("scripts/runtime/Runtime.lua")
    lifecycle=read("scripts/commitment/BlockedWorkerRecoveryCommitmentLifecycle.lua")
    control=read("scripts/control/BlockedWorkerRecoveryControl.lua")

    assert "BLOCKED_WORKER_RECOVERY_CONTROL_REQUIRES_REASSESSMENT" in runtime
    assert 'eventKind=="OBJECTIVE_FAILED"' not in lifecycle
    assert "function Control:_failBeforeRecoveryPoint" in control
    assert "requestCachedTransitRestore" in control
    assert "finishCachedTransitRestore" in control
    assert "function Control:_clearOwnedPhysicalState" in control
    assert "configurationMechanism:clear(state.vehicle)" in control
    assert "settlePhysicalRecovery" in lifecycle

def test_product_lifecycle_publishes_and_clears_recovery_control():
    lifecycle=read("scripts/lifecycle/ProductLifecycle.lua")
    assert "OuttaMyWay.blockedWorkerRecoveryControl=bundle.blockedWorkerRecoveryControl" in lifecycle
    assert "OuttaMyWay.blockedWorkerRecoveryControl=nil" in lifecycle

def test_reverse_reposition_is_a_narrow_extension_of_existing_reposition_primitive():
    drive=read("scripts/control/mechanisms/NativeDriveMechanism.lua")
    assert "function Mechanism:setReposition(vehicle, targetX, targetZ, speedKmh, targetRadiusM, moveForwards)" in drive
    assert "moveForwards = moveForwards~=false" in drive
    assert 'mode = "REPOSITION"' in drive
    assert "speedCeilingApplied(state,state.speedKmh)" in drive
