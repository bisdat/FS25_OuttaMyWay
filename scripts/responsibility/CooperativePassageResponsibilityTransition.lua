OuttaMyWay.CooperativePassageResponsibilityTransition = {}
local Transition = OuttaMyWay.CooperativePassageResponsibilityTransition
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

function Transition.new(runtime)
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness)
    if type(readiness)~="table" or readiness.status~="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"COOPERATIVE_PASSAGE_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    if candidate==nil or candidate.identity~=readiness.candidateId then
        return nil,"COOPERATIVE_PASSAGE_TRANSITION_CANDIDATE_MISMATCH"
    end
    local applied,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision(self.runtime,picture,evaluated)
    if applied==nil then
        logWarning("COOPERATIVE_PASSAGE_TRANSITION_REFUSED decision=%s candidate=%s reason=COMMITMENT_APPLICATION_FAILED detail=%s",
            tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(reason))
        return nil,reason
    end
    logInfo("COOPERATIVE_PASSAGE_TRANSITION_UPSTREAM decision=%s candidate=%s commitment=%s action=%s beforePhysicalDispatch=true",
        tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(applied.commitment and applied.commitment.identity or "NONE"),
        tostring(applied.application and applied.application.action or evaluated.decision.commitmentAction))
    return applied,nil
end
