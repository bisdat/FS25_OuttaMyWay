--- Applies and settles the specialised Obstruction Relocation commitment against parent lifecycle semantics.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`

OuttaMyWay.ObstructionRelocationCommitmentLifecycle={}
local Lifecycle=OuttaMyWay.ObstructionRelocationCommitmentLifecycle

local CENTROID_STRATEGY_EXHAUSTION_REASON="POSITIVE_CAUSAL_OBSTRUCTION_WITHOUT_MEANINGFUL_INWARD_RELOCATION_SPACE"

local function publish(code,publicationClass,severity,payloadBuilder)
    local publisher=OuttaMyWay.logPublication
    if publisher==nil then return false,"LOG_PUBLICATION_UNAVAILABLE" end
    return publisher:publish({code=code,publicationClass=publicationClass,severity=severity,origin="OBSTRUCTION_RELOCATION"},payloadBuilder)
end

local function semanticTerminalEvent(eventKind,evidence)
    if eventKind=="OBJECTIVE_FAILED" and type(evidence)=="table" and evidence.reason==CENTROID_STRATEGY_EXHAUSTION_REASON then
        return "CENTROID_STRATEGY_EXHAUSTED"
    end
    return eventKind
end

local function obligationSettlement(eventKind)
    if eventKind=="OBJECTIVE_SATISFIED" then return "SATISFACTION","OBSTRUCTION_REMOVED" end
    if eventKind=="OBJECTIVE_FAILED" or eventKind=="CENTROID_STRATEGY_EXHAUSTED" then return "SATISFACTION","PLAYER_ESCALATION" end
    if eventKind=="PLAYER_CLAIM" or eventKind=="NEW_AUTHORITATIVE_INTENT" then return "BASIS_CESSATION","RELOCATION_BASIS_CEASED" end
    return nil,nil
end

local function settlementEvidence(semanticEvent,originalEvent,evidence,requiredOutcomeBranch)
    local result={}
    for key,value in OuttaMyWay.ValueRecord.pairs(evidence or {}) do result[key]=value end
    result.terminalEvent=semanticEvent
    result.originalTerminalEvent=originalEvent
    result.requiredOutcomeBranch=requiredOutcomeBranch
    result.causalObstructionBasisCeased=requiredOutcomeBranch=="RELOCATION_BASIS_CEASED"
    result.playerEscalationRequired=requiredOutcomeBranch=="PLAYER_ESCALATION"
    result.centroidStrategyExhausted=semanticEvent=="CENTROID_STRATEGY_EXHAUSTED"
    return result
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
    local semanticEvent=semanticTerminalEvent(eventKind,evidence)
    local mode,requiredOutcomeBranch=obligationSettlement(semanticEvent)
    if mode==nil then return nil,"UNSUPPORTED_OBSTRUCTION_RELOCATION_TERMINAL_EVENT:"..tostring(semanticEvent) end
    local terminalEvidence=settlementEvidence(semanticEvent,eventKind,evidence,requiredOutcomeBranch)
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        runtime.obligations:settle(obligation.identity,mode,terminalEvidence)
    end
    local verdict=runtime.governingBasisEvaluator:evaluate(record,{kind=semanticEvent,evidence=terminalEvidence,provenance={source="ObstructionRelocationCommitmentLifecycle"}})
    local settling=runtime.terminalSettlementEvaluator:enterSettling(commitmentId,verdict)
    local terminal=runtime.terminalSettlementEvaluator:attemptTerminal(commitmentId,terminalEvidence)
    if requiredOutcomeBranch=="PLAYER_ESCALATION" then
        publish("PLAYER_INTERVENTION_REQUIRED","NORMAL","WARNING",function()
            return string.format("commitment=%s event=%s terminal=%s playerEscalation=true basisCessation=%s releasedAuthority=%d",tostring(commitmentId),tostring(semanticEvent),tostring(terminal.state),tostring(verdict.invalidated),OuttaMyWay.ValueRecord.length(settling.releasedAuthorityTokenIds or {}))
        end)
    else
        publish("OBSTRUCTION_RELOCATION_SETTLED","DEBUG","INFO",function()
            return string.format("commitment=%s event=%s terminal=%s basisCessation=%s releasedAuthority=%d",tostring(commitmentId),tostring(semanticEvent),tostring(terminal.state),tostring(verdict.invalidated),OuttaMyWay.ValueRecord.length(settling.releasedAuthorityTokenIds or {}))
        end)
    end
    return terminal,nil
end
