OuttaMyWay.CompletedObstructionResponsibilityTransition = {}
local Transition = OuttaMyWay.CompletedObstructionResponsibilityTransition
Transition.__index = Transition

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][RESPONSIBILITY] %s",message) else print("[FS25_OuttaMyWay][RESPONSIBILITY] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][RESPONSIBILITY] %s",message) else print("[FS25_OuttaMyWay][RESPONSIBILITY][WARNING] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function completedObstructionBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.terminalEgressBridge or nil
    if type(bridge)=="table" and bridge.architecture=="D0147" and type(bridge.terminalEpisodeId)=="string" then return bridge end
    return nil
end

local function semanticAssemblyIds(values)
    local identities={}
    local seen={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(assemblyId)~="string" or assemblyId=="" then return nil,"COMPLETED_OBSTRUCTION_ROLE_CONTEXT_INVALID" end
        if not seen[assemblyId] then seen[assemblyId]=true; identities[#identities+1]=assemblyId end
    end
    table.sort(identities)
    if #identities==0 then return nil,"COMPLETED_OBSTRUCTION_ROLE_CONTEXT_INVALID" end
    return identities,nil
end

function Transition.new(runtime)
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness,semantics)
    if type(readiness)~="table" or readiness.status~="COMPLETED_OBSTRUCTION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"COMPLETED_OBSTRUCTION_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=completedObstructionBridge(candidate)
    if candidate==nil or bridge==nil or candidate.identity~=readiness.candidateId or bridge.terminalEpisodeId~=readiness.terminalEpisodeId then
        return nil,"COMPLETED_OBSTRUCTION_TRANSITION_CONTEXT_MISMATCH"
    end
    local governingBasis=candidate.evidenceBasis and candidate.evidenceBasis.governingBasis or nil
    local beneficiaryIds,beneficiaryReason=semanticAssemblyIds(governingBasis and governingBasis.authorizingDemandAssemblyIds or {})
    if beneficiaryIds==nil or type(bridge.assemblyId)~="string" or bridge.assemblyId=="" then return nil,beneficiaryReason or "COMPLETED_OBSTRUCTION_ROLE_CONTEXT_INVALID" end
    local applied,reason=OuttaMyWay.TerminalEgressCommitmentLifecycle.applyDecision(self.runtime,picture,evaluated)
    if applied==nil then
        logWarning("COMPLETED_OBSTRUCTION_TRANSITION_REFUSED decision=%s candidate=%s episode=%s reason=D0147_COMMITMENT_APPLICATION_FAILED detail=%s",
            tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.terminalEpisodeId),tostring(reason))
        return nil,reason
    end
    local currentResponsibility,responsibilityReason=OuttaMyWay.ResolutionCommitmentAdapter.build(self.runtime,applied,{
        source="CompletedObstructionResponsibilityTransition",purpose=candidate.purpose,
        beneficiaryAssemblyIds=beneficiaryIds,controlledSubjectAssemblyIds={bridge.assemblyId},
        resolutionOutcomeKinds={"CURRENT_TERMINAL_CONFLICT_YIELDED_OR_ESCALATED"},
        responsibilityIdentity=semantics and semantics.responsibilityIdentity or nil
    })
    if currentResponsibility==nil then return nil,responsibilityReason end
    applied.currentResponsibility=currentResponsibility
    local exposure=applied.application.action=="MAINTAIN" and "RESOLUTION_COMMITMENT_PERSISTED" or "RESOLUTION_COMMITMENT_ESTABLISHED"
    logInfo("%s commitment=%s kind=%s beneficiaries=%s controlledSubjects=%s legacyAction=%s",
        exposure,tostring(currentResponsibility.identity),tostring(currentResponsibility.kind),
        table.concat(beneficiaryIds,","),tostring(bridge.assemblyId),tostring(applied.application.action))
    logInfo("COMPLETED_OBSTRUCTION_TRANSITION_UPSTREAM decision=%s candidate=%s episode=%s commitment=%s action=%s beforeProtectedYield=true beforePhysicalDispatch=true",
        tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.terminalEpisodeId),
        tostring(applied.commitment and applied.commitment.identity or "NONE"),
        tostring(applied.application and applied.application.action or evaluated.decision.commitmentAction))
    return applied,nil
end
