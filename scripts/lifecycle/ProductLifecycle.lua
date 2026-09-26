--- Consumes master product enablement and owns existence of the current semantic Runtime graph.
-- Specification Jurisdictions: `CONFIGURATION`

OuttaMyWay.ProductLifecycle={}
local Lifecycle=OuttaMyWay.ProductLifecycle
Lifecycle.__index=Lifecycle

local publication=OuttaMyWay.LogPublication.origin("PRODUCT_RUNTIME")
local HAND_BACK_TEXT_KEY="omw_disabledHandBack"

function Lifecycle.new(configuration,runtimeFactory)
    return setmetatable({
        configuration=configuration,
        runtimeFactory=runtimeFactory,
        runtime=nil,
        runtimeBundle=nil,
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

function Lifecycle:_publishRuntimeBundle(bundle)
    OuttaMyWay.runtime=bundle.runtime
    OuttaMyWay.versionHud=bundle.versionHud
    OuttaMyWay.physicalControlMechanisms=bundle.physicalControlMechanisms
    OuttaMyWay.regulationControl=bundle.regulationControl
    OuttaMyWay.cooperativePassageControl=bundle.cooperativePassageControl
    OuttaMyWay.obstructionRelocationControl=bundle.obstructionRelocationControl
    OuttaMyWay.blockedWorkerRecoveryControl=bundle.blockedWorkerRecoveryControl
    OuttaMyWay.liveRuntimeCoordinator=bundle.liveRuntimeCoordinator
end

function Lifecycle:adoptRuntime(runtime,listeners,bundle)
    if runtime==nil then return false,"RUNTIME_REQUIRED" end
    self.runtime=runtime
    self.runtimeBundle=bundle
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

function Lifecycle:_initializeCurrentMapListeners(listeners)
    local initialized={}
    for _,listener in OuttaMyWay.ValueRecord.ipairs(listeners or {}) do
        if type(listener)=="table" and type(listener.loadMap)=="function" then
            local ok,reason=pcall(listener.loadMap,listener)
            if not ok then
                return false,"CURRENT_MAP_INITIALIZATION_FAILED:"..tostring(reason),initialized
            end
            initialized[#initialized+1]=listener
        end
    end
    return true,"CURRENT_MAP_INITIALIZED",initialized
end

function Lifecycle:_rollbackCurrentMapInitialization(initialized)
    for index=#(initialized or {}),1,-1 do
        local listener=initialized[index]
        if type(listener)=="table" and type(listener.deleteMap)=="function" then
            pcall(listener.deleteMap,listener)
        end
    end
end

function Lifecycle:_removeListeners(listeners)
    if type(removeModEventListener)~="function" then
        return false,"REMOVE_MOD_EVENT_LISTENER_UNAVAILABLE"
    end
    local failures=0
    for _,listener in OuttaMyWay.ValueRecord.ipairs(listeners or {}) do
        local ok=pcall(removeModEventListener,listener)
        if not ok then failures=failures+1 end
    end
    if failures>0 then return false,"RUNTIME_LISTENER_RELEASE_FAILED" end
    return true,"RUNTIME_LISTENERS_RELEASED"
end

function Lifecycle:_removeRuntimeListeners()
    local ok,reason=self:_removeListeners(self.runtimeListeners)
    self.runtimeListeners={}
    return ok,reason
end

function Lifecycle:_clearRuntimeGlobals(runtime)
    if OuttaMyWay.runtime==runtime then OuttaMyWay.runtime=nil end
    OuttaMyWay.liveRuntimeCoordinator=nil
    OuttaMyWay.regulationControl=nil
    OuttaMyWay.cooperativePassageControl=nil
    OuttaMyWay.obstructionRelocationControl=nil
    OuttaMyWay.blockedWorkerRecoveryControl=nil
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

function Lifecycle:enable(reason,initializeCurrentMap)
    if self.operational==true and self.runtime~=nil then
        return true,{status="ALREADY_ENABLED",runtime=self.runtime}
    end
    if self.configuration==nil or type(self.configuration.isResolved)~="function"
        or self.configuration:isResolved()~=true then
        return false,{status="CONFIGURATION_UNRESOLVED"}
    end
    if self.configuration:isEnabled()~=true then
        return false,{status="PRODUCT_CONSENT_NOT_ENABLED"}
    end
    if type(self.runtimeFactory)~="function" then
        publication:error("NORMAL","RUNTIME_BOOTSTRAP_FAILED","reason=RUNTIME_FACTORY_UNAVAILABLE")
        return false,{status="RUNTIME_FACTORY_UNAVAILABLE"}
    end

    local created,bundle=pcall(self.runtimeFactory)
    if not created or type(bundle)~="table" or bundle.runtime==nil or type(bundle.listeners)~="table" then
        publication:error("NORMAL","RUNTIME_BOOTSTRAP_FAILED","reason=%s",tostring(bundle or "INVALID_RUNTIME_BUNDLE"))
        return false,{status="RUNTIME_FACTORY_FAILED",reason=bundle}
    end

    self:_publishRuntimeBundle(bundle)

    local currentMapInitialized={}
    if initializeCurrentMap==true then
        local initialized,initializationReason,initializedListeners=self:_initializeCurrentMapListeners(bundle.listeners)
        currentMapInitialized=initializedListeners or {}
        if not initialized then
            self:_rollbackCurrentMapInitialization(currentMapInitialized)
            self:_clearRuntimeGlobals(bundle.runtime)
            publication:error("NORMAL","RUNTIME_BOOTSTRAP_FAILED","reason=%s",tostring(initializationReason))
            return false,{status="CURRENT_MAP_INITIALIZATION_FAILED",reason=initializationReason}
        end
    end

    if type(bundle.registerListeners)~="function" then
        self:_rollbackCurrentMapInitialization(currentMapInitialized)
        self:_clearRuntimeGlobals(bundle.runtime)
        publication:error("NORMAL","RUNTIME_BOOTSTRAP_FAILED","reason=RUNTIME_LISTENER_REGISTRATION_UNAVAILABLE")
        return false,{status="RUNTIME_LISTENER_REGISTRATION_UNAVAILABLE"}
    end

    local registered,registerOk,registerReason=pcall(bundle.registerListeners)
    if not registered or registerOk~=true then
        self:_removeListeners(bundle.listeners)
        self:_rollbackCurrentMapInitialization(currentMapInitialized)
        self:_clearRuntimeGlobals(bundle.runtime)
        local detail=registered and registerReason or registerOk
        publication:error("NORMAL","RUNTIME_BOOTSTRAP_FAILED","reason=%s",tostring(detail or "RUNTIME_LISTENER_REGISTRATION_FAILED"))
        return false,{status="RUNTIME_LISTENER_REGISTRATION_FAILED",reason=detail}
    end

    self:adoptRuntime(bundle.runtime,bundle.listeners,bundle)

    local why=reason or "PRODUCT_CONFIGURATION_ENABLED"
    if why~="STARTUP" then
        publication:publish("NORMAL","INFO","OUTTAMYWAY_ENABLED",function()
            return {reason=why,version=OuttaMyWay.VERSION}
        end)
    end
    return true,{status="ENABLED",runtime=bundle.runtime,currentMapInitialized=initializeCurrentMap==true}
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
    self.runtimeBundle=nil

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
    elseif notification.value==true and notification.durable==true then
        self:enable("PLAYER_CONFIGURATION_ENABLED",true)
    end
end
