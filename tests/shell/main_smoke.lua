-- Exercise the actual 0.5 entry point without a GIANTS runtime.
-- Subsystems outside the product shell must not be sourced or registered.
local expected={
    "scripts/config.lua",
    "scripts/assessment/SpatialPairInference.lua",
    "scripts/coordination/HoldRelocateCoordinator.lua",
    "scripts/coordination/NativePairCommitmentAuthority.lua",
    "scripts/control/HoldRelocatePhysicalControl.lua",
    "scripts/coordination/LiveHoldRelocateRuntime.lua",
    "scripts/control/mechanisms/NativeReverseMechanism.lua",
    "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua",
    "scripts/control/mechanisms/NativeTransitRequestMechanism.lua",
    "scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/observation/NativeBlockageObservation.lua",
    "scripts/diagnostics/VersionHud.lua",
    "scripts/gui/ConfigurationSettingsExtension.lua",
    "scripts/gui/DisabledStartupReminder.lua"
}
local loaded={}
local registered={}
local events={}
local enabled=true
local listeners={}
local renders={}
local configuration={
    resolvePersistedState=function() return true,nil end,
    isResolved=function() return true end,
    isEnabled=function() return enabled end,
    isDebugEnabled=function() return false end,
    addChangeListener=function(_,callback) listeners[#listeners+1]=callback; return true end
}
g_currentModDirectory=""
g_currentModName="FS25_OuttaMyWay"
g_currentMission={}
renderText=function(_,_,_,text) renders[#renders+1]=text end
addModEventListener=function(listener) registered[#registered+1]=listener end
source=function(path)
    loaded[#loaded+1]=path
    if path=="scripts/config.lua" or path=="scripts/assessment/SpatialPairInference.lua"
        or path=="scripts/coordination/HoldRelocateCoordinator.lua"
        or path=="scripts/coordination/NativePairCommitmentAuthority.lua"
        or path=="scripts/control/HoldRelocatePhysicalControl.lua"
        or path=="scripts/coordination/LiveHoldRelocateRuntime.lua"
        or path=="scripts/control/mechanisms/NativeReverseMechanism.lua"
        or path=="scripts/control/mechanisms/NativeTranslationHoldMechanism.lua"
        or path=="scripts/control/mechanisms/NativeTransitRequestMechanism.lua"
        or path=="scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua" then
        dofile(path)
    elseif path=="scripts/configuration/Configuration.lua" then
        OuttaMyWay.Configuration={new=function() return configuration end}
    elseif path=="scripts/diagnostics/DiagnosticPublicationPolicySource.lua" then
        OuttaMyWay.DiagnosticPublicationPolicySource={new=function()
            return {loadSidecar=function() end,publicationPolicy=function() return "NORMAL" end}
        end}
    elseif path=="scripts/publication/LogPublication.lua" then
        OuttaMyWay.LogPublication={
            new=function(provider) return {policy=provider} end,
            origin=function()
                return {
                    publish=function(_,_,_,code,payload)
                        events[#events+1]={code=code,payload=payload and payload()}
                    end,
                    warning=function() end
                }
            end
        }
    elseif path=="scripts/observation/NativeBlockageObservation.lua"
        or path=="scripts/diagnostics/VersionHud.lua"
        or path=="scripts/gui/ConfigurationSettingsExtension.lua"
        or path=="scripts/gui/DisabledStartupReminder.lua" then
        dofile(path)
    else
        error("Unexpected Lua module sourced: "..path)
    end
end
dofile("scripts/main.lua")
assert(#loaded==#expected)
for i=1,#expected do assert(loaded[i]==expected[i],tostring(loaded[i])) end
assert(OuttaMyWay.runtime==nil and OuttaMyWay.productLifecycle==nil)
assert(type(OuttaMyWay.liveHoldRelocateRuntime.update)=="function")
assert(OuttaMyWay.CurrentPlayerControlObservation==nil)
assert(OuttaMyWay.liveHoldRelocateRuntime.authority~=nil)
assert(OuttaMyWay.liveHoldRelocateRuntime.physicalControl~=nil)
assert(not OuttaMyWay.liveHoldRelocateRuntime.authority:enabled(),
    "offline client fixture cannot control workers")
assert(#registered==4 and registered[1]==OuttaMyWay.versionHud
    and registered[2]==OuttaMyWay.nativeBlockageObservation
    and registered[3]==OuttaMyWay.liveHoldRelocateRuntime
    and registered[4]==OuttaMyWay.disabledStartupReminder)
assert(OuttaMyWay.nativeBlockedProbe==nil)
assert(OuttaMyWay.nativeBlockedEventTap==nil)
assert(type(OuttaMyWay.nativeBlockageObservation.update)=="function")
assert(type(OuttaMyWay.SpatialPairInference.evaluate)=="function")
assert(type(OuttaMyWay.HoldRelocateCoordinator.begin)=="function")
assert(type(OuttaMyWay.NativeReverseMechanism.startReverse)=="function")
assert(type(OuttaMyWay.NativeTranslationHoldMechanism.hold)=="function")
assert(OuttaMyWay.nativeTranslationHoldMechanism==nil)
assert(type(OuttaMyWay.NativeTransitRequestMechanism.requestTransit)=="function")
assert(OuttaMyWay.nativeTransitRequestMechanism==nil)
assert(type(OuttaMyWay.NativeFieldworkJobReplacementMechanism.restartNativeFieldwork)=="function")
assert(OuttaMyWay.nativeFieldworkJobReplacementMechanism==nil)
assert(OuttaMyWay.nativeReverseMechanism==nil)
assert(#events==1)
assert(#events>=1 and events[1].code=="OUTTAMYWAY_SHELL_STARTED")
assert(events[1].payload.aiControl==false)
assert(#listeners==2)
OuttaMyWay.versionHud:draw()
assert(#renders==2)
local expectedHud="OuttaMyWay "..OuttaMyWay.VERSION
assert(renders[1]==expectedHud and renders[2]==expectedHud)
enabled=false
for _,listener in ipairs(listeners) do listener({name="enabled",value=false,durable=true}) end
OuttaMyWay.versionHud:draw()
assert(#renders==2)
assert(events[#events].code=="OUTTAMYWAY_SHELL_DISABLED")
enabled=true
for _,listener in ipairs(listeners) do listener({name="enabled",value=true,durable=true}) end
OuttaMyWay.versionHud:draw()
assert(#renders==4 and renders[3]==expectedHud and renders[4]==expectedHud)
assert(events[#events].code=="OUTTAMYWAY_SHELL_ENABLED")
print("Product shell bootstrap / live Control server-only / HUD toggle: PASS")
