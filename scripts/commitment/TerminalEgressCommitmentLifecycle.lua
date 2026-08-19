-- D-0147 Commitment lifecycle adapter. The generic Decision boundary remains
-- authoritative for admission/revision. This module owns only purpose-specific
-- terminal settlement and its Player Escalation outcome.

OuttaMyWay.TerminalEgressCommitmentLifecycle={}
local Lifecycle=OuttaMyWay.TerminalEgressCommitmentLifecycle

local function logInfo(fmt,...)
    local msg=string.format(fmt,...); if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][D0147] %s",msg) else print("[FS25_OuttaMyWay][D0147] "..msg) end
end
local function logWarning(fmt,...)
    local msg=string.format(fmt,...); if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][D0147] %s",msg) else print("[FS25_OuttaMyWay][D0147][WARNING] "..msg) end
end
function Lifecycle.applyDecision(runtime,picture,evaluated)
    local ok,application=pcall(runtime.decisionCommitmentBoundary.apply,runtime.decisionCommitmentBoundary,picture,evaluated)
    if not ok then return nil,tostring(application) end
    local commitment=application.commitmentId and runtime.commitments:get(application.commitmentId) or nil
    if commitment==nil then return nil,"D0147_COMMITMENT_APPLICATION_PRODUCED_NO_COMMITMENT" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.authorityClass=="POST_JOB_ACTUATION" then token=candidateToken break end
    end
    if token==nil then return nil,"D0147_POST_JOB_AUTHORITY_TOKEN_UNAVAILABLE" end
    return {application=application,commitment=commitment,authorityToken=token},nil
end
function Lifecycle.settle(runtime,commitmentId,eventKind,evidence,terminalEpisodeId)
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return record,"ALREADY_TERMINAL" end
    local satisfaction=eventKind=="OBJECTIVE_SATISFIED"
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        runtime.obligations:settle(obligation.identity,satisfaction and "SATISFACTION" or "BASIS_CESSATION",evidence or {kind=eventKind})
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind=eventKind,evidence=evidence or {},provenance={source="TerminalEgressCommitmentLifecycle"}})
    local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    local terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,evidence or {kind=eventKind})
    if terminalEpisodeId~=nil and runtime.terminalOccupancyAssessment~=nil then
        if eventKind=="OBJECTIVE_FAILED" then runtime.terminalOccupancyAssessment:markExhausted(terminalEpisodeId)
        elseif eventKind=="PLAYER_CLAIM" then runtime.terminalOccupancyAssessment:markPlayerClaimed(terminalEpisodeId) end
    end
    if eventKind=="OBJECTIVE_FAILED" then
        logWarning("TERMINAL_EGRESS_EXHAUSTION commitment=%s episode=%s terminal=%s playerEscalation=true releasedAuthority=%d",tostring(commitmentId),tostring(terminalEpisodeId),tostring(terminal.state),#(settling.releasedAuthorityTokenIds or {}))
    else
        logInfo("TERMINAL_EGRESS_SETTLED commitment=%s episode=%s event=%s terminal=%s releasedAuthority=%d",tostring(commitmentId),tostring(terminalEpisodeId),tostring(eventKind),tostring(terminal.state),#(settling.releasedAuthorityTokenIds or {}))
    end
    return terminal,nil
end
