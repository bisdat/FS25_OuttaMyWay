OuttaMyWay.FollowerBoundaryResponsibilityTransition = {}
local Transition = OuttaMyWay.FollowerBoundaryResponsibilityTransition
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

local function followerBoundaryBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.followerBoundaryBridge or nil
    if type(bridge)=="table" and type(bridge.pairKey)=="string" and type(bridge.followerAssemblyId)=="string" and type(bridge.leaderAssemblyId)=="string" then return bridge end
    return nil
end

function Transition.new(runtime)
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness)
    if type(readiness)~="table" or readiness.status~="FOLLOWER_BOUNDARY_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"FOLLOWER_BOUNDARY_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=followerBoundaryBridge(candidate)
    if candidate==nil or bridge==nil or candidate.identity~=readiness.candidateId or bridge.pairKey~=readiness.pairKey
        or bridge.followerAssemblyId~=readiness.followerAssemblyId or bridge.action~="APPLY" or candidate.capability~="REGULATE_SPEED" then
        return nil,"FOLLOWER_BOUNDARY_TRANSITION_CONTEXT_MISMATCH"
    end
    local applied,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyFollowerBoundaryDecision(self.runtime,picture,evaluated)
    if applied==nil then
        logWarning("FOLLOWER_BOUNDARY_TRANSITION_REFUSED decision=%s candidate=%s pair=%s reason=%s",
            tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.pairKey),tostring(reason))
        return nil,reason
    end
    local disposition=applied.application~=nil and "ESTABLISHED" or "REVALIDATED"
    logInfo("FOLLOWER_BOUNDARY_TRANSITION_UPSTREAM decision=%s candidate=%s pair=%s commitment=%s leader=%s follower=%s legacyAction=%s responsibilityDisposition=%s beforePhysicalDispatch=true",
        tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(bridge.pairKey),tostring(applied.commitment and applied.commitment.identity or "NONE"),
        tostring(bridge.leaderAssemblyId),tostring(bridge.followerAssemblyId),tostring(evaluated.decision.commitmentAction),disposition)
    return applied,nil
end
