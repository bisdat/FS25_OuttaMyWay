-- OuttaMyWay product-shell entry point. Build identity lives in scripts/config.lua and modDesc.xml.
-- Specification Jurisdictions: `CONFIGURATION`, `LOG_PUBLICATION`
-- 0.5 shell deliberately provides no AI worker coordination, GIANTS hooks or vehicle control.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/diagnostics/VersionHud.lua",
    "scripts/diagnostics/NativeBlockedProbe.lua",
    "scripts/gui/ConfigurationSettingsExtension.lua",
    "scripts/gui/DisabledStartupReminder.lua"
}
for _,relativePath in ipairs(modules) do source(modDirectory..relativePath) end
OuttaMyWay.modDirectory=modDirectory

-- Preserve profile Configuration and the independent engineering diagnostic sidecar.
OuttaMyWay.configuration=OuttaMyWay.Configuration.new(OuttaMyWay.MOD_NAME)
local configurationReady,configurationReason=OuttaMyWay.configuration:resolvePersistedState()
OuttaMyWay.diagnosticPublicationPolicySource=OuttaMyWay.DiagnosticPublicationPolicySource.new(OuttaMyWay.MOD_NAME)
OuttaMyWay.diagnosticPublicationPolicySource:loadSidecar()

local function resolvedPublicationPolicy()
    if OuttaMyWay.diagnosticPublicationPolicySource:publicationPolicy()=="DIAGNOSTIC" then return "DIAGNOSTIC" end
    if configurationReady and OuttaMyWay.configuration:isDebugEnabled()==true then return "DEBUG" end
    return "NORMAL"
end
OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new(resolvedPublicationPolicy)

local productPublication=OuttaMyWay.LogPublication.origin("PRODUCT_RUNTIME")
if configurationReady then
    productPublication:publish("NORMAL","INFO","OUTTAMYWAY_SHELL_STARTED",function()
        return {version=OuttaMyWay.VERSION,enabled=OuttaMyWay.configuration:isEnabled(),aiControl=false}
    end)
else
    local configurationPublication=OuttaMyWay.LogPublication.origin("CONFIGURATION")
    configurationPublication:publish("NORMAL","ERROR","CONFIGURATION_STORAGE_FAILED",function()
        return {version=OuttaMyWay.VERSION,reason=configurationReason}
    end)
end

-- Enabled controls this shell's status indicator, never AI worker actuation.
OuttaMyWay.configuration:addChangeListener(function(notification)
    if notification==nil or notification.name~="enabled" or notification.durable~=true then return end
    local code=notification.value==true and "OUTTAMYWAY_SHELL_ENABLED" or "OUTTAMYWAY_SHELL_DISABLED"
    productPublication:publish("NORMAL","INFO",code,function()
        return {version=OuttaMyWay.VERSION,aiControl=false}
    end)
end)

-- Opt-in Debug observation reads native state only; there is no worker Control.
OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()
OuttaMyWay.nativeBlockedProbe=OuttaMyWay.NativeBlockedProbe.new(
    OuttaMyWay.configuration,OuttaMyWay.diagnosticPublicationPolicySource)
OuttaMyWay.disabledStartupReminder=OuttaMyWay.DisabledStartupReminder.new(OuttaMyWay.configuration)
if type(addModEventListener)=="function" then
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.nativeBlockedProbe)
    addModEventListener(OuttaMyWay.disabledStartupReminder)
end
