-- Phase 13 final integration seam. Fresh prospective support is composed into
-- one Decision portfolio; incumbent responsibilities continue through the
-- existing single-purpose Runtime path. Physical Control is not implemented here.
local Runtime=OuttaMyWay.Runtime

local function cooperativeLog(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] %s",message) else print("[FS25_OuttaMyWay][COOPERATIVE-PRODUCTION] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    if selectedId==nil then return nil end
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function selectedGroupBoundary(evaluated)
    local inventory=evaluated and evaluated.candidateInventory or nil
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="PROSPECTIVE_DECISION_PORTFOLIO" then return boundary end
    local candidate=selectedCandidate(evaluated)
    local group=candidate and candidate.evidenceBasis and candidate.evidenceBasis.candidateSupportGroup or nil
    return type(group)=="table" and group.supportBoundary or nil
end

local originalRuntimeNew=Runtime.new
function Runtime.new()
    local runtime=originalRuntimeNew()
    runtime.prospectiveDecisionPortfolioSupport=OuttaMyWay.ProspectiveDecisionPortfolioSupport.new(
        runtime.identities,runtime.epochs,
        runtime.obstructionRelocationCandidateSupport,
        runtime.legacyTerminalEgressCandidateSupport,
        runtime.liveTrafficCandidateSupport,
        runtime.passiveCandidateSupport)
    return runtime
end

-- Existing dispatchers retain their exact support-boundary checks. Portfolio
-- dispatch projects only the selected Candidate's original local boundary back
-- onto an ephemeral inventory with the same canonical identity.
local originalDispatch=Runtime.dispatchEvaluatedOperationalPicture
function Runtime:dispatchEvaluatedOperationalPicture(picture,evaluated)
    local inventory=evaluated and evaluated.candidateInventory or nil
    local boundary=inventory and inventory.supportBoundary or nil
    if type(boundary)=="table" and boundary.mode=="PROSPECTIVE_DECISION_PORTFOLIO" then
        local localBoundary=selectedGroupBoundary(evaluated)
        if type(localBoundary)~="table" then
            return {status="NO_DISPATCH",reason="SELECTED_PORTFOLIO_CANDIDATE_SUPPORT_BOUNDARY_UNAVAILABLE"}
        end
        local values=OuttaMyWay.ValueRecord.toTable(inventory)
        values.supportBoundary=localBoundary
        values.provenance={source="ProspectiveDecisionPortfolioIntegration",portfolioCandidateInventoryId=inventory.identity,selectedGroupBoundary=true}
        local projected=OuttaMyWay.CandidateInventory.new(values)
        local normalized={}
        for key,value in pairs(evaluated) do normalized[key]=value end
        normalized.candidateInventory=projected
        return originalDispatch(self,picture,normalized)
    end
    return originalDispatch(self,picture,evaluated)
end

function Runtime:processLiveObservation(raw)
    local processed=self:processSealedObservation(raw)
    local supported=nil
    if OuttaMyWay.ValueRecord.length(processed.picture.commitmentContext or {})>0 then
        -- Incumbent lifecycle gating remains exactly on the accepted path.
        supported=self.terminalEgressCandidateSupport:attach(processed.picture,processed.snapshot)
        if supported==nil then supported=self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot) end
    else
        supported=self.prospectiveDecisionPortfolioSupport:attach(processed.picture,processed.snapshot)
        if supported==nil then
            -- Conservative escape hatch only; a fresh Portfolio helper normally
            -- returns either a Portfolio or the existing passive support.
            supported=self.terminalEgressCandidateSupport:attach(processed.picture,processed.snapshot)
            if supported==nil then supported=self.liveTrafficCandidateSupport:attach(processed.picture,processed.snapshot) end
        end
    end

    local evaluated=self:evaluateSealedOperationalPicture(supported)
    local boundary=selectedGroupBoundary(evaluated)
    if type(boundary)=="table" and (boundary.mode=="TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST" or boundary.mode=="D0146_COOPERATIVE_PASSAGE_STEP2_TEST") then
        local candidate=selectedCandidate(evaluated)
        if candidate~=nil then
            local bridge=candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
            local traceKey=tostring(bridge and (bridge.encounterIdentity or bridge.conflictIdentity) or candidate.identity)
            if self.cooperativeVerdictTraceKey~=traceKey then
                self.cooperativeVerdictTraceKey=traceKey
                local summary={}
                for _,verdict in OuttaMyWay.ValueRecord.ipairs(evaluated.verdicts or {}) do
                    if verdict.candidateId==candidate.identity then summary[#summary+1]=tostring(verdict.constraintId).."="..tostring(verdict.result) end
                end
                table.sort(summary)
                cooperativeLog("COOPERATIVE_CONSTRAINT_VERDICT encounter=%s candidate=%s decision=%s selected=true verdicts=%s",
                    tostring(bridge and bridge.encounterIdentity or "n/a"),tostring(candidate.identity),tostring(evaluated.decision and evaluated.decision.identity or "n/a"),table.concat(summary,","))
            end
        end
    else
        self.cooperativeVerdictTraceKey=nil
    end

    local dispatch=self:dispatchEvaluatedOperationalPicture(supported,evaluated)
    return {
        snapshot=processed.snapshot,jobEpisodes=processed.jobEpisodes,operation=processed.operation,picture=supported,
        candidateInventory=evaluated.candidateInventory,candidates=evaluated.candidates,verdictSet=evaluated.verdictSet,verdicts=evaluated.verdicts,decision=evaluated.decision,
        controlDispatch=dispatch
    }
end
