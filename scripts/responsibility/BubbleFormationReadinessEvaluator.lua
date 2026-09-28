--- Evaluates whether a selected Cooperative Passage is ready to form its Bubble before Responsibility Transition.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`

OuttaMyWay.BubbleFormationReadinessEvaluator = {}
local Evaluator = OuttaMyWay.BubbleFormationReadinessEvaluator
Evaluator.__index = Evaluator

local publication=OuttaMyWay.LogPublication.origin("COOPERATIVE_PASSAGE")

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function selectedCandidateMatches(evaluated,candidate)
    return candidate~=nil
        and evaluated~=nil
        and evaluated.decision~=nil
        and evaluated.decision.selectedCandidateId==candidate.identity
end

local function opposedRelation(picture,identity)
    if type(identity)~="string" then return nil end
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture and picture.opposedCorridorKnowledge or {}) do
        if relation.identity==identity then return relation end
    end
    return nil
end

local function completeTheatre(bridge)
    local theatre=bridge and bridge.passageCapableTheatre or nil
    if type(theatre)~="table" or theatre.complete~=true then
        return false,"PASSAGE_CAPABLE_THEATRE_NOT_COMPLETE"
    end
    local capture=theatre.captureControlReserve
    if type(capture)~="table" or capture.fieldSupported~=true then
        return false,"PASSAGE_CAPTURE_CONTROL_RESERVE_NOT_SUPPORTED"
    end
    local core=theatre.sharedCrossingCore
    if type(core)~="table" or core.fieldSupported~=true or core.pairSweepSupported~=true then
        return false,"PASSAGE_SHARED_CROSSING_CORE_NOT_SUPPORTED"
    end
    local reacquisition=theatre.lateralExcursionReacquisition or {}
    for _,role in ipairs({"subject","other"}) do
        local item=reacquisition[role]
        if type(item)=="table" and item.required==true and item.fieldSupported~=true then
            return false,"PASSAGE_LATERAL_REACQUISITION_NOT_SUPPORTED:"..role
        end
    end
    return true,nil
end

local function trace(self,result)
    local key=table.concat({
        tostring(result.conflictIdentity or "NONE"),
        tostring(result.status or "UNKNOWN"),
        tostring(result.route or "NONE"),
        tostring(result.reason or "NONE")
    },"|")
    if key==self.lastTraceKey then return end
    self.lastTraceKey=key
    publication:info("DEBUG","BUBBLE_FORMATION_READINESS",
        "conflict=%s candidate=%s status=%s route=%s reason=%s settled=%s/%s approachPerParticipant=%.2fm controlAllowance=%.2fm closingRate=%.2fmps entryReady=%s",
        tostring(result.conflictIdentity or "NONE"),tostring(result.candidateId or "NONE"),tostring(result.status),
        tostring(result.route or "NONE"),tostring(result.reason),
        tostring(result.subjectSettled==true),tostring(result.otherSettled==true),
        tonumber(result.approachDistancePerParticipantM) or -1,tonumber(result.controlAllowanceM) or -1,
        tonumber(result.closingRateMps) or -1,tostring(result.entryReady==true))
end

function Evaluator.new()
    return setmetatable({lastTraceKey=nil},Evaluator)
end

function Evaluator:evaluate(picture,evaluated,candidate,bridge)
    local result={
        status="NOT_READY",route=nil,reason="BUBBLE_FORMATION_READINESS_UNRESOLVED",
        candidateId=candidate and candidate.identity or nil,
        conflictIdentity=bridge and bridge.conflictIdentity or nil
    }

    if not selectedCandidateMatches(evaluated,candidate) then
        result.reason="SELECTED_PASSAGE_CANDIDATE_MISMATCH"
        trace(self,result)
        return result
    end
    if candidate.capability~="REPOSITION" or type(bridge)~="table" or bridge.architecture~="COOPERATIVE_PASSAGE" then
        result.reason="COOPERATIVE_PASSAGE_SELECTED_CANDIDATE_REQUIRED"
        trace(self,result)
        return result
    end

    local theatreOk,theatreReason=completeTheatre(bridge)
    if theatreOk~=true then
        result.reason=theatreReason
        trace(self,result)
        return result
    end

    local relation=opposedRelation(picture,bridge.conflictIdentity)
    if relation==nil or relation.classification~="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then
        result.reason="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_NOT_CURRENT"
        trace(self,result)
        return result
    end

    result.subjectSettled=relation.subjectSettledContinuation==true
    result.otherSettled=relation.otherSettledContinuation==true

    if result.subjectSettled and result.otherSettled then
        result.status="READY"
        result.route="SETTLED_NATIVE_REVELATION"
        result.reason="BOTH_PARTICIPANTS_SETTLED_FOR_SELECTED_PASSAGE"
        trace(self,result)
        return result
    end

    local entry=bridge.passageEntry
    if type(entry)~="table" then
        result.reason="PASSAGE_ENTRY_EVIDENCE_UNAVAILABLE"
        trace(self,result)
        return result
    end

    local approach=tonumber(entry.approachDistancePerParticipantM)
    local allowance=tonumber(entry.controlAllowanceM)
    local currentLongitudinal=tonumber(entry.selectionLongitudinalSeparationM)
    local entryBoundary=tonumber(entry.boundarySeparationM)
    local closing=relation.currentClosing or {}
    local closingRate=tonumber(closing.closingRateMps)

    result.approachDistancePerParticipantM=approach
    result.controlAllowanceM=allowance
    result.currentLongitudinalSeparationM=currentLongitudinal
    result.entryBoundarySeparationM=entryBoundary
    result.closingRateMps=closingRate
    result.entryReady=entry.ready==true

    if not finite(approach) or approach<0 or not finite(allowance) or allowance<0
        or not finite(currentLongitudinal) or currentLongitudinal<0
        or not finite(entryBoundary) or entryBoundary<0 then
        result.reason="CURRENT_PASSAGE_RESERVE_EVIDENCE_UNRESOLVED"
        trace(self,result)
        return result
    end
    if not finite(closingRate) or closingRate<=0 then
        result.reason="CURRENT_POSITIVE_CLOSURE_NOT_ESTABLISHED"
        trace(self,result)
        return result
    end

    -- The candidate planner already converts current pair geometry into the
    -- arrangement-specific disposable approach remaining for each participant.
    -- Reuse the architecture-owned 3 m capture/control allowance rather than
    -- inventing another distance or a fixed time-to-contact literal.  Once each
    -- participant has no more disposable native approach than that current
    -- allowance, further independent closure would consume the reserve intended
    -- to acquire and settle the pair.
    result.latestSafeCaptureApproachM=allowance
    if approach<=allowance then
        result.status="READY"
        result.route="LATEST_SAFE_CAPTURE_POINT"
        result.reason="DISPOSABLE_NATIVE_APPROACH_MARGIN_REACHED_CAPTURE_CONTROL_RESERVE"
        trace(self,result)
        return result
    end

    result.reason="DISPOSABLE_NATIVE_APPROACH_MARGIN_REMAINS"
    trace(self,result)
    return result
end
