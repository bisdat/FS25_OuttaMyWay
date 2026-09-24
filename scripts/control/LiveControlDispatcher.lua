--- Routes already-authorised Control requests to compatible executors and publishes physical dispatch outcomes without strategic choice.
-- Specification Jurisdictions: `CONTROL`

OuttaMyWay.LiveControlDispatcher = {}
local Dispatcher = OuttaMyWay.LiveControlDispatcher
Dispatcher.__index = Dispatcher

local CONTROL_REJECTED={
    code="CONTROL_REJECTED",
    publicationClass="DEBUG",
    severity="WARNING",
    origin="CONTROL"
}

function Dispatcher.new(runtime)
    return setmetatable({runtime=runtime,regulationControl=nil,cooperativePassageControl=nil,obstructionRelocationControl=nil,outcomes={},dispatchCount=0},Dispatcher)
end
function Dispatcher:setRegulationControl(control) self.regulationControl=control end
function Dispatcher:setCooperativePassageControl(control) self.cooperativePassageControl=control end
function Dispatcher:setObstructionRelocationControl(control) self.obstructionRelocationControl=control end
function Dispatcher:getObstructionRelocationObservation()
    if self.obstructionRelocationControl~=nil and type(self.obstructionRelocationControl.getControlExecutionObservation)=="function" then return self.obstructionRelocationControl:getControlExecutionObservation() end
    return nil
end
function Dispatcher:getRegulationControlObservation()
    if self.regulationControl~=nil and type(self.regulationControl.getControlExecutionObservation)=="function" then return self.regulationControl:getControlExecutionObservation() end
    return nil
end
-- Control outcomes report physical dispatch evidence only. Upstream Responsibility /
-- Resolution lifecycle may consume that evidence, but an ACCEPTED outcome here does
-- not itself establish semantic success, obligation settlement or terminal meaning.
function Dispatcher:recordOutcome(request,status,effect,failure)
    local values={identity=self.runtime.identities:issue("CONTROL_OUTCOME"),requestId=request.identity,status=status,observedPhysicalEffect=effect or {},progress={},provenance={source="LiveControlDispatcher"},timestamp=(tonumber(g_time) or 0)/1000}
    if failure~=nil then values.failureEvidence=failure end
    local outcome=OuttaMyWay.ControlOutcome.new(values)
    self.outcomes[#self.outcomes+1]=outcome
    return outcome
end
-- Dispatch is intentionally monotonic with the already-authorised request: capability
-- and target select the compatible executor, but this boundary must not create or
-- broaden Bounded Authority, choose magnitude, or reinterpret Candidate policy.
function Dispatcher:dispatch(request,candidate)
    if request==nil then return false,"CONTROL_REQUEST_REQUIRED" end
    if request.capability=="REGULATE_SPEED" then
        local control=self.regulationControl
        if control==nil or type(control.executeControlRequest)~="function" then return false,"REGULATION_CONTROL_CAPABILITY_UNAVAILABLE" end
        local started,result=control:executeControlRequest(request,candidate)
        if started==true then self.dispatchCount=self.dispatchCount+1 end
        return started,result
    end
    if request.capability=="REPOSITION" then
        local target=request.target or {}
        if target.kind=="OBSTRUCTION_RELOCATION" then
            local control=self.obstructionRelocationControl
            if control==nil or type(control.executeControlRequest)~="function" then return false,"OBSTRUCTION_RELOCATION_CONTROL_UNAVAILABLE" end
            local started,result=control:executeControlRequest(request,candidate)
            if started==true then self.dispatchCount=self.dispatchCount+1 end
            return started,result
        end
        return false,"JOINT_REPOSITION_REQUIRES_DISPATCH_JOINT"
    end
    return false,"CONTROL_REQUEST_CAPABILITY_UNSUPPORTED"
end
-- Cooperative Passage uses a joint dispatch boundary because the two authorised
-- reposition requests form one coordinated physical actuation. Single dispatch
-- deliberately refuses that case rather than starting one participant independently.
-- Bubble Bullet Time, when prepared at Bubble Formation, becomes positive
-- physical authority here: Responsibility Transition has already exposed the
-- Passage Resolution, while physical Passage execution has not yet begun.
function Dispatcher:dispatchJoint(requestA,requestB,candidate)
    if requestA==nil or requestB==nil then return false,"JOINT_CONTROL_REQUESTS_REQUIRED" end
    local control=self.cooperativePassageControl
    if control==nil or type(control.executeJointRequests)~="function" then return false,"COOPERATIVE_PASSAGE_CONTROL_UNAVAILABLE" end

    local bubble=self.runtime and self.runtime.bubbleBulletTime or nil
    local bubbleState=nil
    if bubble~=nil and type(bubble.activatePrepared)=="function" then
        local activated,reason=bubble:activatePrepared(requestA.commitmentId,requestA,candidate)
        if activated==nil then return false,"BUBBLE_BULLET_TIME_ACTIVATION_FAILED:"..tostring(reason) end
        bubbleState=activated
    end

    local started,result=control:executeJointRequests(requestA,requestB,candidate)
    if started==true then
        self.dispatchCount=self.dispatchCount+1
    elseif bubble~=nil and bubbleState~=nil and bubbleState.status=="ACTIVE" and type(bubble.releaseForCommitment)=="function" then
        bubble:releaseForCommitment(requestA.commitmentId,"COOPERATIVE_PASSAGE_JOINT_START_REJECTED")
    end
    return started,result
end
function Dispatcher:notifyRejected(request,reason,effect)
    local publisher=OuttaMyWay.logPublication
    if publisher~=nil then
        publisher:publish(CONTROL_REJECTED,function()
            return string.format("request=%s reason=%s",tostring(request and request.identity or "NONE"),tostring(reason))
        end)
    end
    return self:recordOutcome(request,"REJECTED",effect or {kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(reason)})
end
function Dispatcher:notifyAccepted(request,effect)
    return self:recordOutcome(request,"ACCEPTED",effect,nil)
end
function Dispatcher:getDispatchCount() return self.dispatchCount end
function Dispatcher:getRequests() return {} end
function Dispatcher:getOutcomes() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.outcomes) do out[#out+1]=v end; return out end
