--- Defers ordinary live-traffic negotiation while an active Cooperative Passage Bubble owns the decision horizon.
-- Specification Jurisdictions: `CANDIDATE_SUPPORT`

OuttaMyWay.BubbleDecisionHorizonCandidateSupport = {}
local Support = OuttaMyWay.BubbleDecisionHorizonCandidateSupport
Support.__index = Support

local function activePassageContext(picture)
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture and picture.commitmentContext or {}) do
        if context.lifecycleState=="ACTIVE" then
            for _,obligation in OuttaMyWay.ValueRecord.ipairs(context.openObligations or {}) do
                local basis=obligation.basis or {}
                if basis.kind=="COOPERATIVE_PASSAGE_LEG" then return context end
            end
        end
    end
    return nil
end

function Support.new(delegate,passiveSupport)
    if delegate==nil then error("BubbleDecisionHorizonCandidateSupport requires live-traffic delegate",2) end
    if passiveSupport==nil then error("BubbleDecisionHorizonCandidateSupport requires passive support",2) end
    return setmetatable({delegate=delegate,passiveSupport=passiveSupport,lastStatus="PASSIVE"},Support)
end

function Support.install(runtime)
    if runtime==nil then return nil,"RUNTIME_REQUIRED" end
    if runtime.bubbleDecisionHorizonCandidateSupport~=nil then return runtime.bubbleDecisionHorizonCandidateSupport,nil end
    if runtime.liveTrafficCandidateSupport==nil or runtime.passiveCandidateSupport==nil then return nil,"CANDIDATE_SUPPORT_DEPENDENCIES_UNAVAILABLE" end
    local wrapper=Support.new(runtime.liveTrafficCandidateSupport,runtime.passiveCandidateSupport)
    runtime.liveTrafficCandidateSupport=wrapper
    runtime.bubbleDecisionHorizonCandidateSupport=wrapper
    return wrapper,nil
end

function Support:publishDecisionPicture(picture,snapshot)
    local context=activePassageContext(picture)
    if context~=nil then
        self.lastStatus="BUBBLE_RESOLUTION_EPOCH_DEFERS_INDEPENDENT_TRAFFIC_NEGOTIATION"
        return self.passiveSupport:publishDecisionPicture(picture,snapshot)
    end
    local result=self.delegate:publishDecisionPicture(picture,snapshot)
    if type(self.delegate.getLastStatus)=="function" then self.lastStatus=self.delegate:getLastStatus() end
    return result
end

function Support:buildProjectedGroup(picture,snapshot,projection,targetPictureId,targetEpoch)
    local context=activePassageContext(picture)
    if context~=nil then
        self.lastStatus="BUBBLE_RESOLUTION_EPOCH_DEFERS_INDEPENDENT_TRAFFIC_NEGOTIATION"
        return self.passiveSupport:buildProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    end
    return self.delegate:buildProjectedGroup(picture,snapshot,projection,targetPictureId,targetEpoch)
end

function Support:resetStatus()
    self.lastStatus="PASSIVE"
    if type(self.delegate.resetStatus)=="function" then self.delegate:resetStatus() end
end

function Support:getLastStatus() return self.lastStatus end
function Support:getPublishedCount()
    if type(self.delegate.getPublishedCount)=="function" then return self.delegate:getPublishedCount() end
    return 0
end
