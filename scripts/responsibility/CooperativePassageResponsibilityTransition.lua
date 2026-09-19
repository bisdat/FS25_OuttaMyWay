--- Validates Cooperative Passage successor context and orders establishment of its Resolution responsibility before physical dispatch.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`, `RESPONSIBILITY_TRANSITION`

OuttaMyWay.CooperativePassageResponsibilityTransition = {}
local Transition = OuttaMyWay.CooperativePassageResponsibilityTransition
Transition.__index = Transition

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][RESPONSIBILITY] %s",message) else print("[FS25_OuttaMyWay][RESPONSIBILITY] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][RESPONSIBILITY][WARNING] %s",message) else print("[FS25_OuttaMyWay][RESPONSIBILITY][WARNING] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function passageRoles(candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
    local ids={}
    local seen={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(bridge and bridge.assemblyIds or {}) do
        if type(assemblyId)~="string" or assemblyId=="" or seen[assemblyId] then return nil,"COOPERATIVE_PASSAGE_PARTICIPANT_CONTEXT_INVALID" end
        seen[assemblyId]=true; ids[#ids+1]=assemblyId
    end
    if #ids~=2 then return nil,"COOPERATIVE_PASSAGE_REQUIRES_TWO_DISTINCT_PARTICIPANTS" end
    table.sort(ids)
    return ids,nil
end

local function productionRuntime()
    return type(g_currentModDirectory)=="string" and g_currentModDirectory~=""
end

function Transition.new(runtime)
    if OuttaMyWay.BubbleDecisionHorizonCandidateSupport~=nil and type(OuttaMyWay.BubbleDecisionHorizonCandidateSupport.install)=="function" then
        local _,reason=OuttaMyWay.BubbleDecisionHorizonCandidateSupport.install(runtime)
        if reason~=nil then error("Cooperative Passage Bubble Candidate Support installation failed: "..tostring(reason),2) end
    elseif productionRuntime() then
        error("Cooperative Passage Bubble Candidate Support unavailable in production runtime",2)
    end

    if runtime.bubbleBulletTime==nil and OuttaMyWay.BubbleBulletTime~=nil and type(OuttaMyWay.BubbleBulletTime.new)=="function" then
        runtime.bubbleBulletTime=OuttaMyWay.BubbleBulletTime.new(runtime)
    elseif runtime.bubbleBulletTime==nil and productionRuntime() then
        error("Cooperative Passage Bubble Bullet Time authority unavailable in production runtime",2)
    end
    return setmetatable({runtime=runtime},Transition)
end

function Transition:transition(picture,evaluated,readiness,semantics)
    if type(readiness)~="table" or readiness.status~="COOPERATIVE_PASSAGE_RESPONSIBILITY_TRANSITION_REQUIRED" then
        return nil,"COOPERATIVE_PASSAGE_TRANSITION_NOT_READY"
    end
    local candidate=selectedCandidate(evaluated)
    if candidate==nil or candidate.identity~=readiness.candidateId then
        return nil,"COOPERATIVE_PASSAGE_TRANSITION_CANDIDATE_MISMATCH"
    end
    local participantIds,participantReason=passageRoles(candidate)
    if participantIds==nil then return nil,participantReason end
    local applied,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision(self.runtime,picture,evaluated,semantics)
    if applied==nil then
        logWarning("COOPERATIVE_PASSAGE_TRANSITION_REFUSED decision=%s candidate=%s reason=COMMITMENT_APPLICATION_FAILED detail=%s",
            tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(reason))
        return nil,reason
    end
    local currentResponsibility,responsibilityReason=OuttaMyWay.ResolutionCommitmentAdapter.build(self.runtime,applied,{
        source="CooperativePassageResponsibilityTransition",purpose=candidate.purpose,
        beneficiaryAssemblyIds=participantIds,controlledSubjectAssemblyIds=participantIds,
        resolutionOutcomeKinds={"COOPERATIVE_PASSAGE_LEG_HANDED_BACK","COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK"},
        responsibilityIdentity=semantics and semantics.responsibilityIdentity or nil
    })
    if currentResponsibility==nil then return nil,responsibilityReason end
    applied.currentResponsibility=currentResponsibility

    -- Bubble Formation may prepare supporting third-party mechanical ownership
    -- before semantic exposure. Positive Bounded Authority is deliberately
    -- deferred until ResponsibilityTransitionAuthority has registered this
    -- Resolution as current and LiveControlDispatcher is about to dispatch the
    -- jointly authorised Passage requests.
    local protection={status="LEGACY_HARNESS_NOT_COMPOSED"}
    if self.runtime.bubbleBulletTime~=nil then
        local protectionReason=nil
        protection,protectionReason=self.runtime.bubbleBulletTime:prepareAtBubbleFormation(picture,candidate,applied)
        if protection==nil then
            logWarning("COOPERATIVE_PASSAGE_TRANSITION_REFUSED decision=%s candidate=%s reason=BUBBLE_BULLET_TIME_PREPARATION_FAILED detail=%s",
                tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(protectionReason))
            if type(self.runtime.onCooperativePassageCompletion)=="function" then
                self.runtime:onCooperativePassageCompletion({
                    status="FAILED",commitmentId=applied.commitment.identity,
                    evidence={kind="BUBBLE_BULLET_TIME_PREPARATION_FAILED",reason=protectionReason}
                })
            end
            return nil,"BUBBLE_BULLET_TIME_PREPARATION_FAILED:"..tostring(protectionReason)
        end
        applied.commitment=self.runtime.commitments:get(applied.commitment.identity) or applied.commitment
    end
    applied.bubbleBulletTime=protection

    if not (semantics and semantics.deferResponsibilityExposureLog==true) then
        local exposure=semantics and semantics.responsibilityAlreadyCurrent==true and "RESOLUTION_COMMITMENT_PERSISTED" or "RESOLUTION_COMMITMENT_ESTABLISHED"
        logInfo("%s commitment=%s kind=%s beneficiaries=%s controlledSubjects=%s legacyAction=%s",
            exposure,tostring(currentResponsibility.identity),tostring(currentResponsibility.kind),
            table.concat(participantIds,","),table.concat(participantIds,","),tostring(applied.application.action))
    end
    logInfo("COOPERATIVE_PASSAGE_TRANSITION_UPSTREAM decision=%s candidate=%s commitment=%s action=%s beforePhysicalDispatch=true bubbleBulletTime=%s",
        tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(applied.commitment and applied.commitment.identity or "NONE"),
        tostring(applied.application and applied.application.action or evaluated.decision.commitmentAction),tostring(protection.status or "PREPARED"))
    return applied,nil
end
