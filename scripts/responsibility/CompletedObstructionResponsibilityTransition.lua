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

function Transition.new(runtime)
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness)
    if type(readiness)~="table" or readiness.status~="COMPLETED_OBSTRUCTION_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"COMPLETED_OBSTRUCTION_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=completedObstructionBridge(candidate)
    if candidate==nil or bridge==nil or candidate.identity~=readiness.candidateId or bridge.terminalEpisodeId~=readiness.terminalEpisodeId then
        return nil,"COMPLETED_OBSTRUCTION_TRANSITION_CONTEXT_MISMATCH"
    end
    local applied,reason=OuttaMyWay.TerminalEgressCommitmentLifecycle.applyDecision(self.runtime,picture,evaluated)
    if applied==nil then
        logWarning("COMPLETED_OBSTRUCTION_TRANSITION_REFUSED decision=%s candidate=%s episode=%s reason=D0147_COMMITMENT_APPLICATION_FAILED detail=%s",
            tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.terminalEpisodeId),tostring(reason))
        return nil,reason
    end
    logInfo("COMPLETED_OBSTRUCTION_TRANSITION_UPSTREAM decision=%s candidate=%s episode=%s commitment=%s action=%s beforeProtectedYield=true beforePhysicalDispatch=true",
        tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.terminalEpisodeId),
        tostring(applied.commitment and applied.commitment.identity or "NONE"),
        tostring(applied.application and applied.application.action or evaluated.decision.commitmentAction))
    return applied,nil
end
