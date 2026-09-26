--- Establishes the single-subject Blocked Worker Recovery Current Responsibility.
-- Specification Jurisdictions: `RESPONSIBILITY_TRANSITION`, `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.BlockedWorkerRecoveryResponsibilityTransition={}
local Transition=OuttaMyWay.BlockedWorkerRecoveryResponsibilityTransition
Transition.__index=Transition

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

function Transition.new(runtime) return setmetatable({runtime=runtime},Transition) end

function Transition:transition(picture,evaluated,readiness,semantics)
    if type(readiness)~="table" or readiness.status~="BLOCKED_WORKER_RECOVERY_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"BLOCKED_WORKER_RECOVERY_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.blockedWorkerRecoveryBridge or nil
    if candidate==nil or type(bridge)~="table" or bridge.architecture~="BLOCKED_WORKER_RECOVERY"
        or candidate.identity~=readiness.candidateId or bridge.recoveryKey~=readiness.recoveryKey then
        return nil,"BLOCKED_WORKER_RECOVERY_TRANSITION_CONTEXT_MISMATCH"
    end
    local basis=candidate.evidenceBasis and candidate.evidenceBasis.governingBasis or nil
    if type(basis)~="table" or basis.kind~="BLOCKED_WORKER_RECOVERY" or basis.responsibilityKey~=bridge.recoveryKey then
        return nil,"BLOCKED_WORKER_RECOVERY_GOVERNING_BASIS_MISMATCH"
    end
    local applied,reason=OuttaMyWay.BlockedWorkerRecoveryCommitmentLifecycle.applyDecision(self.runtime,picture,evaluated)
    if applied==nil then return nil,reason end
    local current,responsibilityReason=OuttaMyWay.ResolutionCommitmentAdapter.build(self.runtime,applied,{
        source="BlockedWorkerRecoveryResponsibilityTransition",
        purpose=candidate.purpose,
        beneficiaryAssemblyIds={bridge.assemblyId},
        controlledSubjectAssemblyIds={bridge.assemblyId},
        resolutionOutcomeKinds={"BLOCKED_WORKER_RECOVERY_RESTORED_AND_HANDED_BACK"},
        responsibilityIdentity=semantics and semantics.responsibilityIdentity or nil
    })
    if current==nil then return nil,responsibilityReason end
    applied.currentResponsibility=current
    return applied,nil
end
