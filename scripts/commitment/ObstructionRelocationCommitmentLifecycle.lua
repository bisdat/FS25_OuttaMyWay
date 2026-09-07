OuttaMyWay.ObstructionRelocationCommitmentLifecycle={}
local Lifecycle=OuttaMyWay.ObstructionRelocationCommitmentLifecycle

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION][WARNING] "..message) end
end

function Lifecycle.applyDecision(runtime,picture,evaluated)
    local ok,application=pcall(runtime.decisionCommitmentBoundary.apply,runtime.decisionCommitmentBoundary,picture,evaluated)
    if not ok then return nil,tostring(application) end
    local commitment=application.commitmentId and runtime.commitments:get(application.commitmentId) or nil
    if commitment==nil then return nil,"OBSTRUCTION_RELOCATION_COMMITMENT_APPLICATION_PRODUCED_NO_COMMITMENT" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.authorityClass=="OBSTRUCTION_RELOCATION_ACTUATION" then token=candidateToken break end
    end
    if token==nil then return nil,"OBSTRUCTION_RELOCATION_ACTUATION_AUTHORITY_TOKEN_UNAVAILABLE" end
    return {application=application,commitment=commitment,authorityToken=token},nil
end

function Lifecycle.settle(runtime,commitmentId,eventKind,evidence)
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return record,"ALREADY_TERMINAL" end
    local satisfaction=eventKind=="OBJECTIVE_SATISFIED"
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        runtime.obligations:settle(obligation.identity,satisfaction and "SATISFACTION" or "BASIS_CESSATION",evidence or {kind=eventKind})
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind=eventKind,evidence=evidence or {},provenance={source="ObstructionRelocationCommitmentLifecycle"}})
    local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    local terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,evidence or {kind=eventKind})
    if eventKind=="OBJECTIVE_FAILED" then
        logWarning("SETTLED commitment=%s event=%s terminal=%s playerEscalation=true releasedAuthority=%d",tostring(commitmentId),tostring(eventKind),tostring(terminal.state),OuttaMyWay.ValueRecord.length(settling.releasedAuthorityTokenIds or {}))
    else
        logInfo("SETTLED commitment=%s event=%s terminal=%s releasedAuthority=%d",tostring(commitmentId),tostring(eventKind),tostring(terminal.state),OuttaMyWay.ValueRecord.length(settling.releasedAuthorityTokenIds or {}))
    end
    return terminal,nil
end
