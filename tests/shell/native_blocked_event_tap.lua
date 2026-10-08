-- This is a pure Lua source-level test. It does not establish GIANTS 1.24 behaviour.
local delivered={}
local events={}
local enabled=true
local debug=true
local original=function(vehicle,isBlocked)
    local event={object=vehicle,isBlocked=isBlocked}
    events[#events+1]=event
    return event
end
AIVehicleIsBlockedEvent={new=original}
g_server={}
g_time=1234
OuttaMyWay={LogPublication={
    origin=function()
        return {
            publish=function(_,level,_,code,builder)
                delivered[#delivered+1]={level=level,code=code,payload=builder()}
            end,
            info=function(_,_,code) delivered[#delivered+1]={code=code} end,
            warning=function(_,_,code) delivered[#delivered+1]={code=code} end
        }
    end
}}
dofile("scripts/diagnostics/NativeBlockedEventTap.lua")
local config={
    isResolved=function() return true end,
    isEnabled=function() return enabled end,
    isDebugEnabled=function() return debug end
}
local diagnostic={publicationPolicy=function() return "NORMAL" end}
local tap=OuttaMyWay.NativeBlockedEventTap.new(config,diagnostic)
local a={rootNode=42,spec_aiFieldWorker={},getName=function() return "Condor" end}
local other={rootNode=81}
tap:loadMap()
assert(AIVehicleIsBlockedEvent.new~=original)
local created=AIVehicleIsBlockedEvent.new(a,true)
assert(created==events[1] and created.object==a and created.isBlocked==true)
local matched=delivered[#delivered]
assert(matched.code=="NATIVE_BLOCKED_EVENT_CONSTRUCTED")
assert(matched.payload.vehicleNode==42 and matched.payload.nativeBlocked==true)
assert(matched.payload.engineTimeMs==1234 and matched.payload.scope=="fieldWorkerCapable")
local before=#delivered
AIVehicleIsBlockedEvent.new(other,true)
assert(#delivered==before,"unrelated AI mode not published")
AIVehicleIsBlockedEvent.new(a,false)
assert(delivered[#delivered].payload.nativeBlocked==false)
-- No worker state was changed.
assert(a.isBlocked==nil and a.spec_aiFieldWorker.isBlocked==nil)
debug=false
tap:onConfigurationChange({name="debug"})
assert(AIVehicleIsBlockedEvent.new==original,"debug disable must unhook")
local n=#delivered
AIVehicleIsBlockedEvent.new(a,true)
assert(#delivered==n,"disabled probe must be inert")
debug=true
tap:onConfigurationChange({name="debug"})
assert(AIVehicleIsBlockedEvent.new~=original)
enabled=false
tap:onConfigurationChange({name="enabled"})
assert(AIVehicleIsBlockedEvent.new==original,"disabled product unhooks")
enabled=true
tap:onConfigurationChange({name="enabled"})
assert(AIVehicleIsBlockedEvent.new~=original)
tap:deleteMap()
assert(AIVehicleIsBlockedEvent.new==original)
-- Unavailable native API is recorded rather than breaking the game.
AIVehicleIsBlockedEvent=nil
tap:loadMap()
assert(delivered[#delivered].code=="NATIVE_BLOCKED_TAP_UNAVAILABLE")
tap:deleteMap()
AIVehicleIsBlockedEvent={new=original}
-- Guard against our diagnostic publisher raising inside native construction.
local failureObserver=OuttaMyWay.NativeBlockedEventTap.new(config,diagnostic)
local saved=OuttaMyWay.LogPublication.origin
OuttaMyWay.LogPublication.origin=function()
    return {publish=function() error("diagnostic failed") end,
            info=function() end,warning=function() end}
end
-- The module captured publication at source time; emulate observer failure directly.
failureObserver._observe=function() error("diagnostic failed") end
failureObserver:loadMap()
local evt=AIVehicleIsBlockedEvent.new(a,true)
assert(evt.object==a and evt.isBlocked==true,"observer failure changed native return")
failureObserver:deleteMap()
OuttaMyWay.LogPublication.origin=saved
-- Never clobber another mod's later wrapper; our observer becomes inert.
local chained=OuttaMyWay.NativeBlockedEventTap.new(config,diagnostic)
chained:loadMap()
local chainPrev=AIVehicleIsBlockedEvent.new
AIVehicleIsBlockedEvent.new=function(...) return chainPrev(...) end
local count=#delivered
chained:deleteMap()
local unaffected=AIVehicleIsBlockedEvent.new(a,false)
assert(unaffected.object==a and unaffected.isBlocked==false)
assert(#delivered>=count and delivered[#delivered].code=="NATIVE_BLOCKED_TAP_RELEASE_DEFERRED")
assert(AIVehicleIsBlockedEvent.new~=original)
AIVehicleIsBlockedEvent.new=original
print("Native blocked event tap: constructor delegation, opt-in, filter, isolation, lifecycle PASS")
