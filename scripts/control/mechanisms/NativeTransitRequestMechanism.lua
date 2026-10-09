-- Sends cached GIANTS TRANSIT configuration commands without awaiting posture settlement.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- A request is not physical readiness. The independently admitted coordinator
-- may begin native reverse immediately while raise/fold changes are underway.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeTransitRequestMechanism={}
local Mechanism=OuttaMyWay.NativeTransitRequestMechanism
Mechanism.__index=Mechanism

local ALLOWED_ACTIONS={
    setIsTurnedOn=true,
    setLowered=true,
    setFoldDirection=true
}

local function sendActions(actions)
    for i=1,#actions do
        local action=actions[i]
        local object=action.object
        local method=action.method
        if type(object[method])~="function" then
            return false,"TRANSIT_NATIVE_METHOD_UNAVAILABLE:"..tostring(method)
        end
        -- Preserve native no-event-send semantics used by archived BWR.
        local ok,answer=pcall(object[method],object,action.value,true)
        if not ok or answer==false then
            return false,"TRANSIT_NATIVE_REQUEST_FAILED:"..tostring(method)
        end
    end
    return true
end

local function validActions(actions)
    if type(actions)~="table" then return false end
    for i=1,#actions do
        local a=actions[i]
        if type(a)~="table" or type(a.object)~="table"
            or a.object.isDeleted==true or not ALLOWED_ACTIONS[a.method] then
            return false
        end
        if a.method=="setFoldDirection" then
            if type(a.value)~="number" or a.value==0
                or a.value~=a.value or a.value==math.huge or a.value==-math.huge then
                return false
            end
        elseif type(a.value)~="boolean" then
            return false
        end
    end
    return true
end

function Mechanism.new(configurationSource)
    return setmetatable({
        configurationSource=configurationSource,
        requests=setmetatable({},{__mode="k"})
    },Mechanism)
end

-- Upstream supplies the accepted Job Episode's previously captured capability
-- and selected native commands. This module neither scans attachments nor
-- reads fold position, lowering progress, movement clearance or readiness.
function Mechanism:requestTransit(vehicle)
    if g_server==nil then return false,"SERVER_REQUIRED" end
    if type(vehicle)~="table" then return false,"VEHICLE_UNAVAILABLE" end
    if self.requests[vehicle]~=nil then return false,"TRANSIT_REQUEST_ALREADY_ACTIVE" end
    local source=self.configurationSource
    if type(source)~="table" or type(source.getTransitRequests)~="function" then
        return false,"TRANSIT_REQUEST_SOURCE_UNAVAILABLE"
    end
    local ok,plan=pcall(source.getTransitRequests,source,vehicle)
    if not ok or type(plan)~="table"
        or validActions(plan.transitActions)~=true
        or validActions(plan.restoreActions)~=true then
        return false,"TRANSIT_REQUEST_PLAN_INVALID"
    end
    -- Mark potential effect before any GIANTS call; partial failure retains
    -- the restoration request rather than reporting no side effects.
    local state={transitActions=plan.transitActions,
        restoreActions=plan.restoreActions,isRequestAccepted=false,
        isRestoreRequested=false,isConfigurationVerified=false}
    self.requests[vehicle]=state
    local sent,reason=sendActions(state.transitActions)
    if not sent then return false,reason end
    state.isRequestAccepted=true
    return true,{isTransitRequested=true,isConfigurationVerified=false,
        isReadyGateRequired=false}
end

-- Cancellation sends cached inverse requests without waiting for completion.
-- A successful cancellation means only that reverse commands were submitted,
-- not that GIANTS has finished restoring implements.
function Mechanism:cancelTransit(vehicle)
    if type(vehicle)~="table" then return false,"VEHICLE_UNAVAILABLE" end
    local state=self.requests[vehicle]
    if state==nil then return true,{isRestoreRequested=false,isRestorationVerified=false} end
    local sent,reason=sendActions(state.restoreActions)
    if not sent then return false,reason end
    state.isRestoreRequested=true
    self.requests[vehicle]=nil
    return true,{isRestoreRequested=true,isRestorationVerified=false}
end

-- Successful native FIELDWORK replacement transfers configuration to GIANTS.
-- Drop the old request record WITHOUT asking old-job implements to restore.
function Mechanism:relinquishTransit(vehicle)
    if type(vehicle)~="table" then return false,"VEHICLE_UNAVAILABLE" end
    self.requests[vehicle]=nil
    return true
end

function Mechanism:getRequestEvidence(vehicle)
    local state=type(vehicle)=="table" and self.requests[vehicle] or nil
    if state==nil then return {isActive=false,isConfigurationVerified=false} end
    return {isActive=true,isRequestAccepted=state.isRequestAccepted,
        isConfigurationVerified=false,isReadyGateRequired=false}
end
