-- OuttaMyWay product-shell entry point. Build identity lives in scripts/config.lua and modDesc.xml.
-- Specification Jurisdictions: `CONFIGURATION`
-- Passive GIANTS blocked-state Observation is enabled, with no AI Control.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/assessment/SpatialPairInference.lua",
    "scripts/coordination/HoldRelocateCoordinator.lua",
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

-- Passive blocked-state observation may log candidates, but never acquires worker Control.
OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()
OuttaMyWay.nativeBlockageObservation=OuttaMyWay.NativeBlockageObservation.new(OuttaMyWay.configuration)
OuttaMyWay.disabledStartupReminder=OuttaMyWay.DisabledStartupReminder.new(OuttaMyWay.configuration)
if type(addModEventListener)=="function" then
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.nativeBlockageObservation)
    addModEventListener(OuttaMyWay.disabledStartupReminder)
end
