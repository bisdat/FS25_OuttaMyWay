OuttaMyWay.ObstructionRelocationResponsibilityTransition={}
local Transition=OuttaMyWay.ObstructionRelocationResponsibilityTransition
Transition.__index=Transition

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][RESPONSIBILITY] %s",message) else print("[FS25_OuttaMyWay][RESPONSIBILITY] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function bridgeFor(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.obstructionRelocationBridge or nil
    if type(bridge)=="table" and bridge.architecture=="CAUSAL_OBSTRUCTION_RELOCATION" and type(bridge.relocationKey)=="string" then return bridge end
    return nil
end

local function sortedAssemblyIds(values)
    local result,seen={},{}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(value)~="string" or value=="" then return nil,"OBSTRUCTION_RELOCATION_ROLE_CONTEXT_INVALID" end
        if not seen[value] then seen[value]=true; result[#result+1]=value end
    end
    table.sort(result)
    if OuttaMyWay.ValueRecord.length(result)==0 then return nil,"OBSTRUCTION_RELOCATION_ROLE_CONTEXT_INVALID" end
    return result,nil
end

function Transition.new(runtime)
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness,semantics)
    if type(readiness)~="table" or readiness.status~="OBSTRUCTION_RELOCATION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"OBSTRUCTION_RELOCATION_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=bridgeFor(candidate)
    if candidate==nil or bridge==nil or candidate.identity~=readiness.candidateId or bridge.relocationKey~=readiness.relocationKey then
        return nil,"OBSTRUCTION_RELOCATION_TRANSITION_CONTEXT_MISMATCH"
    end
    local governingBasis=candidate.evidenceBasis and candidate.evidenceBasis.governingBasis or nil
    if type(governingBasis)~="table" or governingBasis.kind~="CAUSAL_OBSTRUCTION_RELOCATION" or governingBasis.responsibilityKey~=bridge.relocationKey then
        return nil,"OBSTRUCTION_RELOCATION_GOVERNING_BASIS_MISMATCH"
    end
    local beneficiaryIds,beneficiaryReason=sortedAssemblyIds(governingBasis.authorizingDemandAssemblyIds or {})
    if beneficiaryIds==nil or type(bridge.blockerAssemblyId)~="string" or bridge.blockerAssemblyId=="" then return nil,beneficiaryReason or "OBSTRUCTION_RELOCATION_ROLE_CONTEXT_INVALID" end

    local existingCommitmentId=bridge.existingCommitmentId
    if type(existingCommitmentId)=="string" then
        local existing=self.runtime.commitments:get(existingCommitmentId)
        if existing==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(existing.state)
            or existing.governingBasis.responsibilityKey~=bridge.relocationKey then
            return nil,"OBSTRUCTION_RELOCATION_RESPONSIBILITY_CONTINUITY_MISMATCH"
        end
    end

    local applied,reason=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.applyDecision(self.runtime,picture,evaluated)
    if applied==nil then return nil,reason end
    if existingCommitmentId~=nil and applied.commitment.identity~=existingCommitmentId then return nil,"OBSTRUCTION_RELOCATION_RETAINED_COMMITMENT_CHANGED" end

    local currentResponsibility,responsibilityReason=OuttaMyWay.ResolutionCommitmentAdapter.build(self.runtime,applied,{
        source="ObstructionRelocationResponsibilityTransition",
        purpose=candidate.purpose,
        beneficiaryAssemblyIds=beneficiaryIds,
        controlledSubjectAssemblyIds={bridge.blockerAssemblyId},
        resolutionOutcomeKinds={"CAUSAL_OBSTRUCTION_REMOVED_OR_ESCALATED"},
        responsibilityIdentity=semantics and semantics.responsibilityIdentity or nil
    })
    if currentResponsibility==nil then return nil,responsibilityReason end
    applied.currentResponsibility=currentResponsibility
    local exposure=semantics and semantics.responsibilityAlreadyCurrent==true and "RESOLUTION_COMMITMENT_PERSISTED" or "RESOLUTION_COMMITMENT_ESTABLISHED"
    logInfo("%s commitment=%s responsibility=%s relocation=%s beneficiaries=%s controlledSubject=%s beforePhysicalDispatch=true",
        exposure,tostring(applied.commitment.identity),tostring(currentResponsibility.identity),tostring(bridge.relocationKey),
        table.concat(beneficiaryIds,","),tostring(bridge.blockerAssemblyId))
    return applied,nil
end
