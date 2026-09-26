--- Applies and settles the single-subject Blocked Worker Recovery commitment.
-- Specification Jurisdictions: `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.BlockedWorkerRecoveryCommitmentLifecycle={}
local Lifecycle=OuttaMyWay.BlockedWorkerRecoveryCommitmentLifecycle

function Lifecycle.applyDecision(runtime,picture,evaluated)
    local ok,application=pcall(runtime.decisionCommitmentBoundary.apply,runtime.decisionCommitmentBoundary,picture,evaluated)
    if not ok then return nil,tostring(application) end
    local commitment=application.commitmentId and runtime.commitments:get(application.commitmentId) or nil
    if commitment==nil then return nil,"BLOCKED_WORKER_RECOVERY_COMMITMENT_APPLICATION_PRODUCED_NO_COMMITMENT" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.authorityClass=="PROGRESS_ACTUATION" then token=candidateToken break end
    end
    if token==nil then return nil,"BLOCKED_WORKER_RECOVERY_PROGRESS_AUTHORITY_TOKEN_UNAVAILABLE" end
    return {application=application,commitment=commitment,authorityToken=token},nil
end

function Lifecycle.settle(runtime,commitmentId,eventKind,evidence)
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return record,"ALREADY_TERMINAL" end
    local mode=nil
    if eventKind=="OBJECTIVE_SATISFIED" then mode="SATISFACTION"
    elseif eventKind=="PLAYER_CLAIM" or eventKind=="NEW_AUTHORITATIVE_INTENT" or eventKind=="SOURCE_INTENT_TERMINATED" then mode="BASIS_CESSATION"
    else return nil,"UNSUPPORTED_BLOCKED_WORKER_RECOVERY_TERMINAL_EVENT:"..tostring(eventKind) end

    local terminalEvidence={}
    for k,v in OuttaMyWay.ValueRecord.pairs(evidence or {}) do terminalEvidence[k]=v end
    terminalEvidence.terminalEvent=eventKind
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        runtime.obligations:settle(obligation.identity,mode,terminalEvidence)
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind=eventKind,evidence=terminalEvidence,provenance={source="BlockedWorkerRecoveryCommitmentLifecycle"}})
    runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    return runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,terminalEvidence),nil
end
