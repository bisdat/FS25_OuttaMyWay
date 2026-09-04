OuttaMyWay.ActionSpaceRegulationResponsibilityTransition = {}
local Transition = OuttaMyWay.ActionSpaceRegulationResponsibilityTransition
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

local function actionSpaceBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.d0146ActionSpaceRegulationBridge or nil
    if type(bridge)=="table" and type(bridge.conflictIdentity)=="string" and type(bridge.regulatedAssemblyId)=="string" then return bridge end
    return nil
end

function Transition.new(runtime)
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness)
    if type(readiness)~="table" or readiness.status~="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"ACTION_SPACE_REGULATION_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=actionSpaceBridge(candidate)
    local context=readiness.applicationContext
    if candidate==nil or bridge==nil or candidate.identity~=readiness.candidateId or candidate.capability~="REGULATE_SPEED"
        or bridge.conflictIdentity~=readiness.conflictIdentity or bridge.regulatedAssemblyId~=readiness.regulatedAssemblyId
        or (context~="INITIAL" and context~="REACTIVATION" and context~="ROLE_MIGRATION") then
        return nil,"ACTION_SPACE_REGULATION_TRANSITION_CONTEXT_MISMATCH"
    end
    local preflight,preflightReason=self.runtime.responsibilityTransitionAuthority:preflightActionSpaceRegulation(picture,evaluated,readiness)
    if preflight==nil then return nil,preflightReason end
    local applied,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyD0146ActionSpaceDecision(self.runtime,picture,evaluated)
    if applied==nil then
        logWarning("ACTION_SPACE_REGULATION_TRANSITION_REFUSED decision=%s candidate=%s conflict=%s context=%s reason=%s",
            tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.conflictIdentity),tostring(context),tostring(reason))
        return nil,reason
    end
    local currentResponsibility,responsibilityReason=self.runtime.responsibilityTransitionAuthority:establishOrPreserveActionSpaceRegulation(preflight,applied)
    if currentResponsibility==nil then return nil,responsibilityReason end
    applied.currentResponsibility=currentResponsibility
    local disposition=evaluated.decision.commitmentAction=="CREATE" and "ESTABLISHED" or "REVALIDATED"
    logInfo("ACTION_SPACE_REGULATION_TRANSITION_UPSTREAM decision=%s candidate=%s conflict=%s commitment=%s responsibility=%s regulated=%s protected=%s legacyAction=%s responsibilityDisposition=%s applicationContext=%s beforePhysicalDispatch=true",
        tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.conflictIdentity),tostring(applied.commitment and applied.commitment.identity or "NONE"),
        tostring(currentResponsibility.identity),tostring(bridge.regulatedAssemblyId),tostring(bridge.protectedAssemblyId or bridge.excursionAssemblyId),tostring(evaluated.decision.commitmentAction),disposition,tostring(context))
    return applied,nil
end
