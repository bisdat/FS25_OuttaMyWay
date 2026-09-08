OuttaMyWay.LiveControlDispatcher = {}
local Dispatcher = OuttaMyWay.LiveControlDispatcher
Dispatcher.__index = Dispatcher

local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][CONTROL-DISPATCH] %s",message) else print("[FS25_OuttaMyWay][CONTROL-DISPATCH][WARNING] "..message) end
end

function Dispatcher.new(runtime)
    return setmetatable({runtime=runtime,regulationControl=nil,cooperativePassageControl=nil,terminalEgressControl=nil,outcomes={},dispatchCount=0},Dispatcher)
end
function Dispatcher:setRegulationControl(control) self.regulationControl=control end
function Dispatcher:setCooperativePassageControl(control) self.cooperativePassageControl=control end
function Dispatcher:setTerminalEgressControl(control) self.terminalEgressControl=control end
function Dispatcher:getTerminalEgressObservation()
    if self.terminalEgressControl~=nil and type(self.terminalEgressControl.getControlExecutionObservation)=="function" then return self.terminalEgressControl:getControlExecutionObservation() end
    return nil
end
function Dispatcher:getRegulationControlObservation()
    if self.regulationControl~=nil and type(self.regulationControl.getControlExecutionObservation)=="function" then return self.regulationControl:getControlExecutionObservation() end
    return nil
end
function Dispatcher:recordOutcome(request,status,effect,failure)
    local values={identity=self.runtime.identities:issue("CONTROL_OUTCOME"),requestId=request.identity,status=status,observedPhysicalEffect=effect or {},progress={},provenance={source="LiveControlDispatcher"},timestamp=(tonumber(g_time) or 0)/1000}
    if failure~=nil then values.failureEvidence=failure end
    local outcome=OuttaMyWay.ControlOutcome.new(values)
    self.outcomes[#self.outcomes+1]=outcome
    return outcome
end
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
        if target.kind=="TERMINAL_EGRESS" then
            local control=self.terminalEgressControl
            if control==nil or type(control.executeControlRequest)~="function" then return false,"TERMINAL_EGRESS_CONTROL_UNAVAILABLE" end
            local started,result=control:executeControlRequest(request,candidate)
            if started==true then self.dispatchCount=self.dispatchCount+1 end
            return started,result
        end
        return false,"JOINT_REPOSITION_REQUIRES_DISPATCH_JOINT"
    end
    return false,"CONTROL_REQUEST_CAPABILITY_UNSUPPORTED"
end
function Dispatcher:dispatchJoint(requestA,requestB,candidate)
    if requestA==nil or requestB==nil then return false,"JOINT_CONTROL_REQUESTS_REQUIRED" end
    local control=self.cooperativePassageControl
    if control==nil or type(control.executeJointRequests)~="function" then return false,"COOPERATIVE_PASSAGE_CONTROL_UNAVAILABLE" end
    local started,result=control:executeJointRequests(requestA,requestB,candidate)
    if started==true then self.dispatchCount=self.dispatchCount+1 end
    return started,result
end
function Dispatcher:notifyRejected(request,reason,effect)
    logWarning("CONTROL_REJECTED request=%s reason=%s",tostring(request and request.identity or "NONE"),tostring(reason))
    return self:recordOutcome(request,"REJECTED",effect or {kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(reason)})
end
function Dispatcher:notifyAccepted(request,effect)
    return self:recordOutcome(request,"ACCEPTED",effect,nil)
end
function Dispatcher:getDispatchCount() return self.dispatchCount end
function Dispatcher:getRequests() return {} end
function Dispatcher:getOutcomes() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.outcomes) do out[#out+1]=v end; return out end
