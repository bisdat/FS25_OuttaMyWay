OuttaMyWay.ReplayRunner = {}
local Runner=OuttaMyWay.ReplayRunner
Runner.__index=Runner

local function resolvePath(context,path)
    local current=context
    for segment in string.gmatch(path,"[^%.]+") do
        if type(current)~="table" then error("replay reference cannot resolve " .. path,3) end
        local numeric=tonumber(segment); current=current[numeric or segment]
    end
    if current==nil then error("replay reference absent " .. path,3) end
    return current
end

local function resolve(value,context)
    if type(value)=="string" and string.sub(value,1,1)=="$" then return resolvePath(context,string.sub(value,2)) end
    if type(value)~="table" then return value end
    local result={}; for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=resolve(item,context) end; return result
end

local function selectedCapability(result)
    if result.decision.selectedCandidateId==nil then return nil end
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(result.candidates) do if candidate.identity==result.decision.selectedCandidateId then return candidate.capability end end
end

local function verdictSummary(result)
    local candidatePurpose={}; for _,candidate in OuttaMyWay.ValueRecord.ipairs(result.candidates) do candidatePurpose[candidate.identity]=candidate.purpose.referenceKey or candidate.capability end
    local summary={}
    for _,verdict in OuttaMyWay.ValueRecord.ipairs(result.verdicts) do
        local key=candidatePurpose[verdict.candidateId] .. ":" .. verdict.constraintId
        summary[key]=verdict.result
    end
    return summary
end

function Runner.new(runtime)
    return setmetatable({runtime=runtime,runCount=0},Runner)
end

function Runner:_execute(step,context)
    local input=resolve(step.input or {},context)
    if step.kind=="NO_ACTIVITY" then
        return {activityCount=0}
    elseif step.kind=="PROCESS_OBSERVATION" then
        local result=self.runtime:processSealedObservation(input.raw)
        return result,{encounterCount=#result.picture.encounters,situationCount=#result.picture.situations,activeOperationCount=#result.operation.activeOperationIds,commitmentCount=#self.runtime.commitments:list()}
    elseif step.kind=="EVALUATE_PICTURE" then
        local picture=OuttaMyWay.OperationalPicture.new(input.picture)
        local result=self.runtime:evaluateSealedOperationalPicture(picture)
        result.picture=picture
        return result,{selectedCapability=selectedCapability(result),decisionAction=result.decision.commitmentAction,nonInterventionClass=result.decision.nonIntervention.classification,viableCount=#result.decision.viableCandidateIds,verdicts=verdictSummary(result)}
    elseif step.kind=="APPLY_DECISION" then
        local result=input.decisionResult
        local application=self.runtime.decisionCommitmentBoundary:apply(result.picture,result)
        return application,{action=application.action,commitmentId=application.commitmentId,previousState=application.previousState,resultingState=application.resultingState,createdObligationCount=#application.createdObligationIds,authorityTokenCount=#application.authorityTokenIds,commitmentCount=#self.runtime.commitments:list()}
    elseif step.kind=="CREATE_COMMITMENT" then
        local admitted=self.runtime.commitmentAdmission:admit(input.values)
        return admitted,{commitmentId=admitted.commitment.identity,state=admitted.commitment.state,obligationCount=#admitted.obligationIds,authorityTokenCount=#admitted.authorityTokens,commitmentCount=#self.runtime.commitments:list()}
    elseif step.kind=="GOVERNING_BASIS_EVENT" then
        local commitment=self.runtime.commitments:get(input.commitmentId)
        local verdict=self.runtime.governingBasisEvaluator:evaluate(commitment,input.event)
        local settlement=self.runtime.terminalSettlementEvaluator:enterSettling(commitment.identity,verdict)
        return {verdict=verdict,settlement=settlement},{invalidated=verdict.invalidated,state=settlement.commitment.state,intendedTerminalDisposition=settlement.commitment.intendedTerminalDisposition,terminalCause=settlement.commitment.terminalCause,releasedAuthorityCount=#settlement.releasedAuthorityTokenIds,openObligationCount=#self.runtime.obligations:openForOwner(commitment.identity)}
    elseif step.kind=="SETTLE_OBLIGATION" then
        local obligation=self.runtime.obligations:settle(input.obligationId,input.mode,input.evidence)
        return obligation,{obligationId=obligation.identity,status=obligation.status,mode=obligation.settlementDisposition.mode}
    elseif step.kind=="ATTEMPT_TERMINAL" then
        local commitment=self.runtime.terminalSettlementEvaluator:attemptTerminal(input.commitmentId,input.evidence)
        return commitment,{commitmentId=commitment.identity,state=commitment.state,openObligationCount=#self.runtime.obligations:openForOwner(commitment.identity)}
    elseif step.kind=="REGISTRY_STATUS" then
        local commitment=input.commitmentId and self.runtime.commitments:get(input.commitmentId) or nil
        return {commitment=commitment},{commitmentCount=#self.runtime.commitments:list(),commitmentState=commitment and commitment.state or nil,openObligationCount=commitment and #self.runtime.obligations:openForOwner(commitment.identity) or 0,progressAuthorityCount=commitment and #self.runtime.authorities:tokensForCommitment(commitment.identity) or 0}
    else error("unsupported replay step " .. tostring(step.kind),2) end
end

function Runner:run(fixture)
    OuttaMyWay.ValueRecord.assertType(fixture,"ReplayFixture")
    local context={}; local stepResults={}; local divergence
    for index,stepValue in OuttaMyWay.ValueRecord.ipairs(fixture.steps) do
        local step=OuttaMyWay.ConformanceAssertions.plain(stepValue)
        local ok,result,summary=pcall(function()
            local a,b=self:_execute(step,context); return a,b
        end)
        if step.expectErrorContains~=nil then
            if ok then
                divergence={step=index,kind=step.kind,reason="expected rejection was not observed"}
            elseif not string.find(tostring(result),step.expectErrorContains,1,true) then
                divergence={step=index,kind=step.kind,reason="rejection mismatch: " .. tostring(result)}
            else
                summary={rejected=true,error=tostring(result)}; result=summary; ok=true
            end
        elseif not ok then
            divergence={step=index,kind=step.kind,reason=tostring(result)}
        end
        if divergence==nil then
            local expected=resolve(step.expect or {},context)
            local passed,reason=OuttaMyWay.ConformanceAssertions.check(summary or result,expected)
            if not passed then divergence={step=index,kind=step.kind,reason=reason} end
        end
        stepResults[#stepResults+1]={index=index,kind=step.kind,alias=step.alias,summary=summary or {}}
        if divergence~=nil then break end
        if step.alias~=nil then context[step.alias]=result end
    end
    self.runCount=self.runCount+1
    local fingerprint=OuttaMyWay.ValueRecord.canonical(OuttaMyWay.ValueRecord.definitions.ReplayFixture.new(OuttaMyWay.ValueRecord.toTable(fixture)))
    return OuttaMyWay.ReplayRunResult.new({
        identity=self.runtime.identities:issue("REPLAY_RUN"),epoch=self.runtime.epochs:next(),fixtureId=fixture.identity,
        stepResults=stepResults,conformance=divergence and "FAIL" or "PASS",earliestDivergence=divergence,
        fingerprints={fixture=fingerprint,steps=OuttaMyWay.ValueRecord.canonical(OuttaMyWay.ReplayFixture.new(OuttaMyWay.ValueRecord.toTable(fixture)))},
        provenance={source="ReplayRunner",architectureVersion=OuttaMyWay.ARCHITECTURE_VERSION}
    })
end
function Runner:getRunCount() return self.runCount end
