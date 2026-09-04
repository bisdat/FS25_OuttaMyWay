OuttaMyWay.ResponsibilityTransitionAuthority = {}
local Authority = OuttaMyWay.ResponsibilityTransitionAuthority
Authority.__index = Authority

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][RESPONSIBILITY] %s",message) else print("[FS25_OuttaMyWay][RESPONSIBILITY] "..message) end
end

local function selectedBridge(evaluated,name)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then
            local evidence=candidate.evidenceBasis
            return evidence and evidence[name] or nil
        end
    end
    return nil
end

function Authority.new(runtime)
    return setmetatable({runtime=runtime,currentActionSpaceRegulation=nil},Authority)
end

-- INITIAL establishes the semantic responsibility. REACTIVATION and
-- ROLE_MIGRATION preserve it; neither mutable actuation event is a transition.
function Authority:establishOrPreserveActionSpaceRegulation(evaluated,readiness,applied)
    local bridge=selectedBridge(evaluated,"d0146ActionSpaceRegulationBridge")
    local commitment=applied and applied.commitment or nil
    if bridge==nil or commitment==nil then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_MISSING" end
    local context=readiness and readiness.applicationContext or nil
    local current=self.currentActionSpaceRegulation
    if context=="INITIAL" then
        if current~=nil then
            if current.provenance.conflictIdentity==bridge.conflictIdentity and current.provenance.retainedCommitmentId==commitment.identity then return current,nil end
            return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_ALREADY_CURRENT"
        end
        current=OuttaMyWay.Regulation.new({
            identity=self.runtime.identities:issue("RESPONSIBILITY"),kind="REGULATION",
            governingBasis=commitment.governingBasis,
            provenance={source="ActionSpaceRegulationResponsibilityTransition",conflictIdentity=bridge.conflictIdentity,retainedCommitmentId=commitment.identity}
        })
        self.currentActionSpaceRegulation=current
        return current,nil
    end
    if context~="REACTIVATION" and context~="ROLE_MIGRATION" then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_UNSUPPORTED" end
    if current==nil or current.kind~="REGULATION" or current.provenance.conflictIdentity~=bridge.conflictIdentity
        or current.provenance.retainedCommitmentId~=commitment.identity then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_MISMATCH"
    end
    return current,nil
end

-- This is deliberately the one migrated replacement exemplar. The retained
-- Commitment succession and dispatcher cleanup are subordinate collaborators;
-- neither owns the semantic R1 -> R2 boundary.
function Authority:replaceActionSpaceRegulationWithCooperativePassage(picture,evaluated,readiness,passageTransition,dispatcher)
    local current=self.currentActionSpaceRegulation
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    if current==nil or bridge==nil or bridge.architecture~="D0146_STEP2"
        or current.provenance.conflictIdentity~=bridge.conflictIdentity then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_PREDECESSOR_MISMATCH"
    end
    local successorIdentity=self.runtime.identities:issue("RESPONSIBILITY")
    local applied,reason=passageTransition:transition(picture,evaluated,readiness,{responsibilityIdentity=successorIdentity,deferResponsibilityExposureLog=true})
    if applied==nil then return nil,reason end
    if applied.commitment.identity~=current.provenance.retainedCommitmentId then
        return nil,"ACTION_SPACE_PASSAGE_RETAINED_COMMITMENT_CHANGED"
    end
    local retired,retireReason=dispatcher:supersedeActionSpaceRegulationForCooperativePassage(applied.commitment,evaluated)
    if retired==nil or retired.settled==nil then return nil,retireReason or "ACTION_SPACE_REGULATION_RETIREMENT_FAILED" end
    self.currentActionSpaceRegulation=nil
    logInfo("RESPONSIBILITY_REPLACED predecessor=%s predecessorKind=REGULATION successor=%s successorKind=RESOLUTION_COMMITMENT commitment=%s atomic=true beforePhysicalDispatch=true",
        tostring(current.identity),tostring(applied.currentResponsibility.identity),tostring(applied.commitment.identity))
    return applied,nil
end

function Authority:matchesActionSpacePassage(evaluated)
    local current=self.currentActionSpaceRegulation
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    return current~=nil and bridge~=nil and bridge.architecture=="D0146_STEP2"
        and current.provenance.conflictIdentity==bridge.conflictIdentity
end

function Authority:terminateActionSpaceRegulation(commitmentId,conflictIdentity)
    local current=self.currentActionSpaceRegulation
    if current==nil then return true end
    if current.provenance.retainedCommitmentId~=commitmentId or current.provenance.conflictIdentity~=conflictIdentity then return false end
    self.currentActionSpaceRegulation=nil
    return true
end

function Authority:getCurrentActionSpaceRegulation()
    return self.currentActionSpaceRegulation
end
