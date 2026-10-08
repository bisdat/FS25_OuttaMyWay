-- Exercise the actual 0.5 entry point without a GIANTS runtime.
-- Subsystems outside the product shell must not be sourced or registered.
local expected={
    "scripts/config.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/diagnostics/VersionHud.lua",
    "scripts/gui/ConfigurationSettingsExtension.lua",
    "scripts/gui/DisabledStartupReminder.lua"
}
local loaded={}
local registered={}
local events={}
local enabled=true
local changed=nil
local renders={}
local configuration={
    resolvePersistedState=function() return true,nil end,
    isResolved=function() return true end,
    isEnabled=function() return enabled end,
    isDebugEnabled=function() return false end,
    addChangeListener=function(_,callback) changed=callback; return true end
}
g_currentModDirectory=""
g_currentModName="FS25_OuttaMyWay"
g_currentMission={}
renderText=function(_,_,_,text) renders[#renders+1]=text end
addModEventListener=function(listener) registered[#registered+1]=listener end
source=function(path)
    loaded[#loaded+1]=path
    if path=="scripts/config.lua" then
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
    elseif path=="scripts/diagnostics/VersionHud.lua"
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
assert(#registered==2 and registered[1]==OuttaMyWay.versionHud
    and registered[2]==OuttaMyWay.disabledStartupReminder)
assert(OuttaMyWay.nativeBlockedProbe==nil)
assert(#events==1)
assert(#events>=1 and events[1].code=="OUTTAMYWAY_SHELL_STARTED")
assert(events[1].payload.aiControl==false)
assert(type(changed)=="function")
OuttaMyWay.versionHud:draw()
assert(#renders==2)
local expectedHud="OuttaMyWay "..OuttaMyWay.VERSION
assert(renders[1]==expectedHud and renders[2]==expectedHud)
enabled=false
changed({name="enabled",value=false,durable=true})
OuttaMyWay.versionHud:draw()
assert(#renders==2)
assert(events[#events].code=="OUTTAMYWAY_SHELL_DISABLED")
enabled=true
changed({name="enabled",value=true,durable=true})
OuttaMyWay.versionHud:draw()
assert(#renders==4 and renders[3]==expectedHud and renders[4]==expectedHud)
assert(events[#events].code=="OUTTAMYWAY_SHELL_ENABLED")
print("Product shell bootstrap / no AI runtime / HUD toggle: PASS")
