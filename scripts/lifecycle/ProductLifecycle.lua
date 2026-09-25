--- Consumes master product enablement and owns live withdrawal of the current Runtime graph.
-- Specification Jurisdictions: `CONFIGURATION`

OuttaMyWay.ProductLifecycle={}
local Lifecycle=OuttaMyWay.ProductLifecycle
Lifecycle.__index=Lifecycle

local publication=OuttaMyWay.LogPublication.origin("PRODUCT_RUNTIME")
local HAND_BACK_TEXT_KEY="omw_disabledHandBack"

function Lifecycle.new(configuration)
    return setmetatable({
        configuration=configuration,
        runtime=nil,
        runtimeListeners={},
        operational=false,
        subscribed=false
    },Lifecycle)
end

function Lifecycle:subscribe()
    if self.subscribed then return true,"ALREADY_SUBSCRIBED" end
    if self.configuration==nil or type(self.configuration.addChangeListener)~="function" then
        return false,"CONFIGURATION_CHANGE_NOTIFICATION_UNAVAILABLE"
    end
    local ok,reason=self.configuration:addChangeListener(function(notification)
        self:onConfigurationChanged(notification)
    end)
    if ok~=true then return false,reason end
    self.subscribed=true
    return true,"SUBSCRIBED"
end

function Lifecycle:adoptRuntime(runtime,listeners)
    if runtime==nil then return false,"RUNTIME_REQUIRED" end
    self.runtime=runtime
    self.runtimeListeners={}
    for _,listener in OuttaMyWay.ValueRecord.ipairs(listeners or {}) do
        self.runtimeListeners[#self.runtimeListeners+1]=listener
    end
    self.operational=true
    return true,"RUNTIME_ADOPTED"
end

function Lifecycle:isOperational()
    return self.operational==true
end

function Lifecycle:_removeRuntimeListeners()
    if type(removeModEventListener)~="function" then
        return false,"REMOVE_MOD_EVENT_LISTENER_UNAVAILABLE"
    end
    local failures=0
    for _,listener in OuttaMyWay.ValueRecord.ipairs(self.runtimeListeners) do
        local ok,reason=pcall(removeModEventListener,listener)
        if not ok then
            failures=failures+1
            publication:error("NORMAL","RUNTIME_LISTENER_RELEASE_FAILED","detail=%s",tostring(reason))
        end
    end
    self.runtimeListeners={}
    if failures>0 then return false,"RUNTIME_LISTENER_RELEASE_FAILED" end
    return true,"RUNTIME_LISTENERS_RELEASED"
end

function Lifecycle:_clearRuntimeGlobals(runtime)
    if OuttaMyWay.runtime==runtime then OuttaMyWay.runtime=nil end
    OuttaMyWay.liveRuntimeCoordinator=nil
    OuttaMyWay.regulationControl=nil
    OuttaMyWay.cooperativePassageControl=nil
    OuttaMyWay.obstructionRelocationControl=nil
    OuttaMyWay.physicalControlMechanisms=nil
    OuttaMyWay.versionHud=nil
end

function Lifecycle:_showHandBackMessage()
    if self.configuration==nil or self.configuration:isHudVisible()~=true then return false,"HUD_HIDDEN" end
    if g_currentMission==nil or type(g_currentMission.showBlinkingWarning)~="function" then
        return false,"PLAYER_WARNING_SURFACE_UNAVAILABLE"
    end
    if g_i18n==nil or type(g_i18n.getText)~="function" then
        return false,"LOCALISATION_SURFACE_UNAVAILABLE"
    end
    local textOk,message=pcall(g_i18n.getText,g_i18n,HAND_BACK_TEXT_KEY)
    if not textOk or type(message)~="string" or message=="" then
        return false,"HAND_BACK_TEXT_UNAVAILABLE"
    end
    local shown,reason=pcall(g_currentMission.showBlinkingWarning,g_currentMission,message)
    if not shown then return false,tostring(reason) end
    return true,"PLAYER_HAND_BACK_MESSAGE_SHOWN"
end

function Lifecycle:disable(reason)
    if self.operational~=true or self.runtime==nil then
        self.operational=false
        return true,{status="ALREADY_DISABLED"}
    end

    local runtime=self.runtime
    self.operational=false

    local relinquished,relinquishmentResult=true,nil
    if type(runtime.relinquishAllControl)=="function" then
        local callOk,result,failureCount=pcall(runtime.relinquishAllControl,runtime,reason or "PLAYER_CONFIGURATION_DISABLED")
        relinquishmentResult=result
        relinquished=callOk and (tonumber(failureCount) or 0)==0
        if not relinquished then
            publication:error("NORMAL","PRODUCT_CONTROL_RELINQUISHMENT_INCOMPLETE","failures=%s detail=%s",
                tostring(failureCount or "call"),tostring(result))
        end
    else
        relinquished=false
        relinquishmentResult="RUNTIME_RELINQUISHMENT_UNAVAILABLE"
        publication:error("NORMAL","PRODUCT_CONTROL_RELINQUISHMENT_INCOMPLETE","failures=unavailable detail=%s",relinquishmentResult)
    end

    local listenersReleased,listenersReason=self:_removeRuntimeListeners()
    if not listenersReleased then
        publication:warning("NORMAL","RUNTIME_LISTENER_RELEASE_INCOMPLETE","reason=%s",tostring(listenersReason))
    end

    self:_clearRuntimeGlobals(runtime)
    self.runtime=nil

    local messageShown,messageReason=self:_showHandBackMessage()
    if not messageShown and messageReason~="HUD_HIDDEN" then
        publication:warning("NORMAL","PLAYER_HAND_BACK_MESSAGE_UNAVAILABLE","reason=%s",tostring(messageReason))
    end

    publication:publish("NORMAL","INFO","OUTTAMYWAY_DISABLED",function()
        return {
            reason=reason or "PLAYER_CONFIGURATION_DISABLED",
            listenersReleased=listenersReleased,
            relinquished=relinquished,
            playerMessage=messageShown
        }
    end)

    return relinquished,{
        status="DISABLED",
        listenersReason=listenersReason,
        relinquishment=relinquishmentResult,
        playerMessageReason=messageReason
    }
end

function Lifecycle:onConfigurationChanged(notification)
    if type(notification)~="table" or notification.name~="enabled" then return end
    if notification.value==false then
        self:disable("PLAYER_CONFIGURATION_DISABLED")
    end
end
