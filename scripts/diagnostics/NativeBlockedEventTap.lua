--- TEST-only observer of GIANTS blocked-event construction, NOT a worker-control module.
-- Deliberately intercepts the outgoing event constructor, never the engine-owned
-- collision-handler callback. Does not send events, mutate workers or qualify blockage.
OuttaMyWay.NativeBlockedEventTap = {}
local Tap=OuttaMyWay.NativeBlockedEventTap
Tap.__index=Tap

local publication=OuttaMyWay.LogPublication.origin("NATIVE_BLOCKED_EVENT_TAP")

function Tap.new(configuration,diagnosticSource)
    return setmetatable({
        configuration=configuration,diagnosticSource=diagnosticSource,
        mapLoaded=false,active=false,original=nil,wrapper=nil
    },Tap)
end

function Tap:_requested()
    local config=self.configuration
    if self.mapLoaded~=true or g_server==nil or config==nil or config:isResolved()~=true
        or config:isEnabled()~=true then return false end
    if config:isDebugEnabled()==true then return true end
    return self.diagnosticSource~=nil
        and self.diagnosticSource:publicationPolicy()=="DIAGNOSTIC"
end

function Tap:_observe(object,isBlocked)
    -- The event constructor is shared by multiple AI modes. Narrow only to
    -- field-worker-capable vehicles; this is NOT proof of active field-course strategy.
    if g_server==nil or type(object)~="table" or type(object.spec_aiFieldWorker)~="table"
        or type(isBlocked)~="boolean" then return end

    local name=nil
    if type(object.getName)=="function" then
        local ok,value=pcall(object.getName,object)
        if ok and type(value)=="string" then name=value end
    end
    publication:publish("DEBUG","INFO","NATIVE_BLOCKED_EVENT_CONSTRUCTED",function()
        return {
            vehicleNode=object.rootNode,vehicleName=name,
            nativeBlocked=isBlocked,engineTimeMs=type(g_time)=="number" and g_time or nil,
            source="AIVehicleIsBlockedEvent.new",scope="fieldWorkerCapable"
        }
    end)
end

function Tap:_install()
    if self.wrapper~=nil then
        -- A different mod may have wrapped ours. Never overwrite its hook or
        -- assume our retained wrapper remains in the active call chain.
        if type(AIVehicleIsBlockedEvent)=="table"
            and AIVehicleIsBlockedEvent.new==self.wrapper then
            self.active=true
        else
            self.active=false
            publication:info("DEBUG","NATIVE_BLOCKED_TAP_CHAIN_UNVERIFIED",
                "other code replaced the event constructor; observation disabled")
        end
        return
    end

    if type(AIVehicleIsBlockedEvent)~="table"
        or type(AIVehicleIsBlockedEvent.new)~="function" then
        publication:warning("DEBUG","NATIVE_BLOCKED_TAP_UNAVAILABLE",
            "GIANTS event constructor unavailable")
        return
    end

    local original=AIVehicleIsBlockedEvent.new
    local observer=self
    local wrapper=function(object,isBlocked,...)
        -- Native event construction must succeed/fail exactly as it did before.
        local event=original(object,isBlocked,...)
        if observer.active==true then
            -- Diagnostic failure may never propagate into the GIANTS event path.
            pcall(observer._observe,observer,object,isBlocked)
        end
        return event
    end
    self.original=original
    self.wrapper=wrapper
    self.active=true
    AIVehicleIsBlockedEvent.new=wrapper
    publication:info("DEBUG","NATIVE_BLOCKED_TAP_INSTALLED",
        "outgoing native event construction only; no callback replacement")
end

function Tap:_release()
    self.active=false
    if self.wrapper==nil then return end
    if type(AIVehicleIsBlockedEvent)=="table"
        and AIVehicleIsBlockedEvent.new==self.wrapper then
        AIVehicleIsBlockedEvent.new=self.original
        self.original=nil
        self.wrapper=nil
    else
        -- Do not clobber a later hook. Our retained wrapper remains inert if
        -- another mod still delegates to it; do not install another wrapper.
        publication:warning("DEBUG","NATIVE_BLOCKED_TAP_RELEASE_DEFERRED",
            "event constructor changed since installation; retained observer inactive")
    end
end

function Tap:sync()
    if self:_requested() then self:_install() else self:_release() end
end

function Tap:onConfigurationChange(notification)
    if notification~=nil
        and (notification.name=="enabled" or notification.name=="debug") then
        self:sync()
    end
end

function Tap:loadMap()
    self.mapLoaded=true
    self:sync()
end

function Tap:loadMapFinished()
    -- Some GIANTS setups only expose server authority after loadMap.
    self:sync()
end

function Tap:deleteMap()
    self.mapLoaded=false
    self:_release()
end

function Tap:update() end
function Tap:draw() end
function Tap:keyEvent() end
function Tap:mouseEvent() end
