--- Applies and settles the single-subject Bounded Bypass commitment.
-- Specification Jurisdictions: `BOUNDED_BYPASS`

OuttaMyWay.BoundedBypassCommitmentLifecycle={}
local Lifecycle=OuttaMyWay.BoundedBypassCommitmentLifecycle

function Lifecycle.applyDecision(runtime,picture,evaluated)
    local ok,application=pcall(runtime.decisionCommitmentBoundary.apply,runtime.decisionCommitmentBoundary,picture,evaluated)
    if not ok then return nil,tostring(application) end
    local commitment=application.commitmentId and runtime.commitments:get(application.commitmentId) or nil
    if commitment==nil then return nil,"BOUNDED_BYPASS_COMMITMENT_APPLICATION_PRODUCED_NO_COMMITMENT" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.authorityClass=="PROGRESS_ACTUATION" then token=candidateToken break end
    end
    if token==nil then return nil,"BOUNDED_BYPASS_PROGRESS_AUTHORITY_TOKEN_UNAVAILABLE" end
    return {application=application,commitment=commitment,authorityToken=token},nil
end

function Lifecycle.settle(runtime,commitmentId,eventKind,evidence)
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return record,"ALREADY_TERMINAL" end
    local mode=nil
    if eventKind=="OBJECTIVE_SATISFIED" or eventKind=="OBJECTIVE_FAILED" then mode="SATISFACTION"
    elseif eventKind=="PLAYER_CLAIM" or eventKind=="NEW_AUTHORITATIVE_INTENT" or eventKind=="SOURCE_INTENT_TERMINATED" then mode="BASIS_CESSATION"
    else return nil,"UNSUPPORTED_BOUNDED_BYPASS_TERMINAL_EVENT:"..tostring(eventKind) end

    local terminalEvidence={}
    for k,v in OuttaMyWay.ValueRecord.pairs(evidence or {}) do terminalEvidence[k]=v end
    terminalEvidence.terminalEvent=eventKind
    -- The obligation explicitly permits escalation; failure never claims Rejoin.
    terminalEvidence.requiredOutcomeBranch=eventKind=="OBJECTIVE_FAILED" and "PLAYER_ESCALATION" or eventKind
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        runtime.obligations:settle(obligation.identity,mode,terminalEvidence)
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind=eventKind,evidence=terminalEvidence,provenance={source="BoundedBypassCommitmentLifecycle"}})
    runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    return runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,terminalEvidence),nil
end
