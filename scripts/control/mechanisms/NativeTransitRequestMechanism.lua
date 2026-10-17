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

local function validActions(actions,kind)
    if type(actions)~="table" then
        return false,kind.."_ACTIONS_UNAVAILABLE"
    end
    for i=1,#actions do
        local action=actions[i]
        local at=kind.."_ACTION_"..tostring(i)
        if type(action)~="table" or type(action.object)~="table"
            or action.object.isDeleted==true then
            return false,at.."_SUBJECT_UNAVAILABLE"
        end
        if not ALLOWED_ACTIONS[action.method] then
            return false,at.."_METHOD_NOT_ALLOWED"
        end
        if action.method=="setFoldDirection" then
            local value=action.value
            if type(value)~="number" or value==0
                or value~=value or value==math.huge
                or value==-math.huge then
                return false,at.."_FOLD_DIRECTION_INVALID"
            end
        elseif type(action.value)~="boolean" then
            return false,at.."_VALUE_INVALID"
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
    local ok,plan,why=pcall(source.getTransitRequests,source,vehicle)
    if not ok then
        return false,"TRANSIT_REQUEST_SOURCE_EXCEPTION"
    end
    if type(plan)~="table" then
        return false,type(why)=="string" and why or
            "TRANSIT_REQUEST_PLAN_UNAVAILABLE"
    end
    local valid,reason=validActions(plan.transitActions,"TRANSIT")
    if not valid then return false,reason end
    valid,reason=validActions(plan.restoreActions,"RESTORE")
    if not valid then return false,reason end
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
        isReadyGateRequired=false,
        unresolvedFoldCount=plan.unknownFoldCount or 0}
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
