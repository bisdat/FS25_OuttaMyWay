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
    return setmetatable({runtime=runtime,regulationsByCommitmentId={},resolutionsByCommitmentId={}},Authority)
end

function Authority:preflightActionSpaceRegulation(picture,evaluated,readiness)
    local bridge=selectedBridge(evaluated,"d0146ActionSpaceRegulationBridge")
    local context=readiness and readiness.applicationContext or nil
    local current=self:findRegulation("conflictIdentity",bridge and bridge.conflictIdentity)
    if bridge==nil or readiness==nil or bridge.conflictIdentity~=readiness.conflictIdentity then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_PREFLIGHT_CONTEXT_MISMATCH"
    end
    if context=="INITIAL" then
        for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
            local retained=self:getCurrentRegulation(item.commitmentId)
            if retained~=nil and retained~=current then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_ALREADY_CURRENT" end
        end
        if current~=nil then
            local targeted=false
            for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
                if item.commitmentId==current.provenance.retainedCommitmentId then targeted=true break end
            end
            if targeted~=true then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_NOT_TARGETED" end
        end
        return {context=context,current=current,conflictIdentity=bridge.conflictIdentity},nil
    end
    if context~="REACTIVATION" and context~="ROLE_MIGRATION" then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_UNSUPPORTED" end
    if current==nil or current.kind~="REGULATION" or current.provenance.conflictIdentity~=bridge.conflictIdentity
        or current.provenance.retainedCommitmentId~=readiness.commitmentId then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_MISMATCH"
    end
    return {context=context,current=current,conflictIdentity=bridge.conflictIdentity,commitmentId=readiness.commitmentId},nil
end

-- INITIAL establishes the semantic responsibility. REACTIVATION and
-- ROLE_MIGRATION preserve it; neither mutable actuation event is a transition.
function Authority:establishOrPreserveActionSpaceRegulation(preflight,applied)
    local commitment=applied and applied.commitment or nil
    if preflight==nil or commitment==nil then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_MISSING" end
    local context=preflight.context
    local current=preflight.current or self:getCurrentRegulation(commitment.identity)
    if context=="INITIAL" then
        if current~=nil then
            if current.provenance.conflictIdentity==preflight.conflictIdentity and current.provenance.retainedCommitmentId==commitment.identity then return current,nil end
            return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_ALREADY_CURRENT"
        end
        current=OuttaMyWay.Regulation.new({
            identity=self.runtime.identities:issue("RESPONSIBILITY"),kind="REGULATION",
            governingBasis=commitment.governingBasis,
            provenance={source="ActionSpaceRegulationResponsibilityTransition",conflictIdentity=preflight.conflictIdentity,retainedCommitmentId=commitment.identity}
        })
        self.regulationsByCommitmentId[commitment.identity]=current
        return current,nil
    end
    if context~="REACTIVATION" and context~="ROLE_MIGRATION" then return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTEXT_UNSUPPORTED" end
    if current==nil or current.provenance.retainedCommitmentId~=commitment.identity then
        return nil,"ACTION_SPACE_REGULATION_RESPONSIBILITY_CONTINUITY_MISMATCH"
    end
    return current,nil
end

-- The Action-Space donor replacement boundary. The retained
-- Commitment succession and dispatcher cleanup are subordinate collaborators;
-- neither owns the semantic R1 -> R2 boundary.
function Authority:replaceActionSpaceRegulationWithCooperativePassage(picture,evaluated,readiness,passageTransition,dispatcher)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local current=self:findRegulation("conflictIdentity",bridge and bridge.conflictIdentity)
    if current==nil or bridge==nil or bridge.architecture~="D0146_STEP2"
        or current.provenance.conflictIdentity~=bridge.conflictIdentity then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_PREDECESSOR_MISMATCH"
    end
    local preflight,preflightReason=dispatcher:preflightActionSpaceRegulationForCooperativePassage(evaluated,readiness)
    if preflight==nil then return nil,preflightReason end
    if preflight.commitmentId~=current.provenance.retainedCommitmentId or preflight.conflictIdentity~=current.provenance.conflictIdentity then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_SUBSTRATE_MISMATCH"
    end
    local targeted=false
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if context.commitmentId==preflight.commitmentId then targeted=true break end
    end
    if targeted~=true or evaluated.decision.commitmentAction~="REVISE" then
        return nil,"ACTION_SPACE_PASSAGE_RESPONSIBILITY_SUCCESSION_NOT_TARGETED"
    end
    return self:replaceRegulationWithCooperativePassage(current,preflight,picture,evaluated,readiness,passageTransition,dispatcher,
        dispatcher.supersedeActionSpaceRegulationForCooperativePassage)
end

-- Shared semantic commit point. A successor is exposed only after subordinate
-- retained revision and predecessor cleanup have both succeeded.
function Authority:replaceRegulationWithCooperativePassage(current,preflight,picture,evaluated,readiness,passageTransition,dispatcher,cleanupMethod)
    local successorIdentity=self.runtime.identities:issue("RESPONSIBILITY")
    local applied,reason=passageTransition:transition(picture,evaluated,readiness,{responsibilityIdentity=successorIdentity,deferResponsibilityExposureLog=true})
    if applied==nil then return nil,reason end
    if applied.commitment.identity~=preflight.commitmentId then
        return nil,"REGULATION_PASSAGE_RETAINED_COMMITMENT_CHANGED"
    end
    local retired,retireReason=cleanupMethod(dispatcher,applied.commitment,evaluated)
    if retired==nil or retired.settled==nil then return nil,retireReason or (retired and retired.reason) or "REGULATION_PREDECESSOR_CLEANUP_FAILED" end
    self.regulationsByCommitmentId[preflight.commitmentId]=nil
    self.resolutionsByCommitmentId[preflight.commitmentId]=applied.currentResponsibility
    logInfo("RESPONSIBILITY_REPLACED predecessor=%s predecessorKind=REGULATION successor=%s successorKind=RESOLUTION_COMMITMENT commitment=%s atomic=true beforePhysicalDispatch=true",
        tostring(current.identity),tostring(applied.currentResponsibility.identity),tostring(applied.commitment.identity))
    return applied,nil
end

function Authority:matchesActionSpacePassage(evaluated)
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local current=self:findRegulation("conflictIdentity",bridge and bridge.conflictIdentity)
    return current~=nil and bridge~=nil and bridge.architecture=="D0146_STEP2"
        and current.provenance.conflictIdentity==bridge.conflictIdentity
end

-- These keys locate implementation substrate; RS-* remains the identity.
function Authority:findRegulation(provenanceKey,value)
    if value==nil then return nil end
    for _,current in pairs(self.regulationsByCommitmentId) do
        if current.provenance[provenanceKey]==value then return current end
    end
    return nil
end

function Authority:getCurrentRegulation(commitmentId)
    return self.regulationsByCommitmentId[commitmentId]
end

function Authority:getCurrentResolutionCommitment(commitmentId)
    return self.resolutionsByCommitmentId[commitmentId]
end

function Authority:terminateRegulation(commitmentId)
    local current=self.regulationsByCommitmentId[commitmentId]
    if current~=nil and self.runtime.boundedAuthority~=nil then self.runtime.boundedAuthority:releaseForResponsibility(current.identity,"REGULATION_RESPONSIBILITY_TERMINATED") end
    self.regulationsByCommitmentId[commitmentId]=nil
    return true
end

function Authority:terminateResolutionCommitment(commitmentId)
    local current=self.resolutionsByCommitmentId[commitmentId]
    if current~=nil and self.runtime.boundedAuthority~=nil then self.runtime.boundedAuthority:releaseForResponsibility(current.identity,"RESOLUTION_RESPONSIBILITY_TERMINATED") end
    self.resolutionsByCommitmentId[commitmentId]=nil
    return true
end

function Authority:terminateSemanticResponsibilitiesForTerminalCommitment(commitmentId)
    local regulation=self.regulationsByCommitmentId[commitmentId]
    local resolution=self.resolutionsByCommitmentId[commitmentId]
    if self.runtime.boundedAuthority~=nil then
        if regulation~=nil then self.runtime.boundedAuthority:releaseForResponsibility(regulation.identity,"TERMINAL_COMMITMENT_RESPONSIBILITY_TERMINATED") end
        if resolution~=nil then self.runtime.boundedAuthority:releaseForResponsibility(resolution.identity,"TERMINAL_COMMITMENT_RESPONSIBILITY_TERMINATED") end
    end
    self.regulationsByCommitmentId[commitmentId]=nil
    self.resolutionsByCommitmentId[commitmentId]=nil
    return true
end

function Authority:resolutionIdentityForCommitment(commitmentId,action)
    local current=self:getCurrentResolutionCommitment(commitmentId)
    if current~=nil then return current.identity,nil end
    if action=="MAINTAIN" or action=="REVISE" then return nil,"RESOLUTION_RESPONSIBILITY_CONTINUITY_MISSING" end
    return self.runtime.identities:issue("RESPONSIBILITY"),nil
end

function Authority:transitionCooperativePassageResolution(picture,evaluated,readiness,passageTransition)
    local commitmentId=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if type(context.commitmentId)=="string" then commitmentId=context.commitmentId break end
    end
    local identity=nil
    if type(commitmentId)=="string" then
        local reason=nil
        identity,reason=self:resolutionIdentityForCommitment(commitmentId,evaluated and evaluated.decision and evaluated.decision.commitmentAction)
        if identity==nil then return nil,reason end
    else
        identity=self.runtime.identities:issue("RESPONSIBILITY")
    end
    local applied,reason=passageTransition:transition(picture,evaluated,readiness,{responsibilityIdentity=identity})
    if applied==nil then return nil,reason end
    self.resolutionsByCommitmentId[applied.commitment.identity]=applied.currentResponsibility
    return applied,nil
end

function Authority:transitionCompletedObstructionResolution(picture,evaluated,readiness,completedTransition)
    local commitmentId=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if type(context.commitmentId)=="string" then commitmentId=context.commitmentId break end
    end
    local identity=nil
    if type(commitmentId)=="string" then
        local reason=nil
        identity,reason=self:resolutionIdentityForCommitment(commitmentId,evaluated and evaluated.decision and evaluated.decision.commitmentAction)
        if identity==nil then return nil,reason end
    else
        identity=self.runtime.identities:issue("RESPONSIBILITY")
    end
    local applied,reason=completedTransition:transition(picture,evaluated,readiness,{responsibilityIdentity=identity})
    if applied==nil then return nil,reason end
    self.resolutionsByCommitmentId[applied.commitment.identity]=applied.currentResponsibility
    return applied,nil
end

function Authority:terminateActionSpaceRegulation(commitmentId,conflictIdentity)
    local current=self:getCurrentRegulation(commitmentId)
    if current==nil then return true end
    if current.provenance.conflictIdentity~=conflictIdentity then return false end
    return self:terminateRegulation(commitmentId)
end

-- Compatibility observation for the original single-exemplar callers. With
-- several Action-Space instances the caller must supply its substrate key.
function Authority:getCurrentActionSpaceRegulation(commitmentId)
    if commitmentId~=nil then
        local current=self:getCurrentRegulation(commitmentId)
        return current and current.provenance.conflictIdentity~=nil and current or nil
    end
    local result=nil
    for _,current in pairs(self.regulationsByCommitmentId) do
        if current.provenance.conflictIdentity~=nil then
            if result~=nil then return nil end
            result=current
        end
    end
    return result
end

function Authority:preflightFollowerRegulation(picture,evaluated)
    local bridge=selectedBridge(evaluated,"followerBoundaryBridge")
    if bridge==nil or bridge.action~="APPLY" then return nil,"FOLLOWER_REGULATION_PREFLIGHT_CONTEXT_MISMATCH" end
    local current=self:findRegulation("pairKey",bridge.pairKey)
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        local targeted=self:getCurrentRegulation(context.commitmentId)
        if targeted~=nil and targeted~=current then return nil,"FOLLOWER_REGULATION_PREFLIGHT_SUBSTRATE_MISMATCH" end
    end
    local retained=bridge.existingCommitmentId and self:getCurrentRegulation(bridge.existingCommitmentId) or nil
    if retained~=nil and retained~=current then return nil,"FOLLOWER_REGULATION_PREFLIGHT_SUBSTRATE_MISMATCH" end
    if current~=nil and current.provenance.retainedCommitmentId~=bridge.existingCommitmentId then
        return nil,"FOLLOWER_REGULATION_PREFLIGHT_CONTINUITY_MISMATCH"
    end
    return {current=current,pairKey=bridge.pairKey},nil
end

function Authority:establishOrPreserveFollowerRegulation(preflight,applied)
    local commitment=applied and applied.commitment or nil
    if preflight==nil or commitment==nil then return nil,"FOLLOWER_REGULATION_CONTEXT_MISSING" end
    local current=preflight.current or self:getCurrentRegulation(commitment.identity)
    if current~=nil then
        if current.provenance.pairKey~=preflight.pairKey or current.provenance.retainedCommitmentId~=commitment.identity then
            return nil,"FOLLOWER_REGULATION_CONTINUITY_MISMATCH"
        end
        return current,nil
    end
    current=OuttaMyWay.Regulation.new({identity=self.runtime.identities:issue("RESPONSIBILITY"),kind="REGULATION",
        governingBasis=commitment.governingBasis,
        provenance={source="FollowerBoundaryResponsibilityTransition",pairKey=preflight.pairKey,retainedCommitmentId=commitment.identity}})
    self.regulationsByCommitmentId[commitment.identity]=current
    return current,nil
end

function Authority:matchesFollowerPassage(picture,evaluated)
    if selectedBridge(evaluated,"cooperativePassageBridge")==nil then return false end
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        local current=self:getCurrentRegulation(context.commitmentId)
        if current~=nil and current.provenance.pairKey~=nil then return true end
    end
    -- Preserve the refusal boundary even if a malformed picture drops its target.
    local bridge=selectedBridge(evaluated,"cooperativePassageBridge")
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(bridge.assemblyIds or {}) do ids[id]=true end
    local lease=self.runtime.liveControlDispatcher.followerBoundaryLease
    return lease~=nil and self:getCurrentRegulation(lease.commitmentId)~=nil
        and ids[lease.followerAssemblyId]==true and ids[lease.leaderAssemblyId]==true
end

function Authority:replaceFollowerRegulationWithCooperativePassage(picture,evaluated,readiness,passageTransition,dispatcher)
    local preflight,reason=dispatcher:preflightFollowerRegulationForCooperativePassage(evaluated,readiness)
    if preflight==nil then return nil,reason end
    local current=self:getCurrentRegulation(preflight.commitmentId)
    if current==nil or current.provenance.pairKey~=preflight.pairKey then return nil,"FOLLOWER_PASSAGE_PREDECESSOR_MISMATCH" end
    local targeted=false
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if context.commitmentId==preflight.commitmentId then targeted=true break end
    end
    if not targeted or OuttaMyWay.ValueRecord.length(picture.commitmentContext)~=1 or evaluated.decision.commitmentAction~="REVISE" then return nil,"FOLLOWER_PASSAGE_SUCCESSION_NOT_TARGETED" end
    return self:replaceRegulationWithCooperativePassage(current,preflight,picture,evaluated,readiness,passageTransition,dispatcher,
        dispatcher.supersedeFollowerRegulationForCooperativePassage)
end
