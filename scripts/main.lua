-- OuttaMyWay product-shell entry point. Build identity lives in scripts/config.lua and modDesc.xml.
-- Specification Jurisdictions: `CONFIGURATION`
-- Native blockage Observation feeds independently admitted live Hold & Relocate Control.
local modDirectory=g_currentModDirectory or ""
local modules={
    "scripts/config.lua",
    "scripts/assessment/SpatialPairInference.lua",
    "scripts/assessment/NonActiveObstructionAssessment.lua",
    "scripts/coordination/HoldRelocateCoordinator.lua",
    "scripts/coordination/ProjectedEgressRegion.lua",
    "scripts/coordination/NativePairCommitmentAuthority.lua",
    "scripts/control/HoldRelocatePhysicalControl.lua",
    "scripts/coordination/LiveHoldRelocateRuntime.lua",
    "scripts/control/mechanisms/NativeReverseMechanism.lua",
    "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua",
    "scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua",
    "scripts/control/mechanisms/NativeTransitRequestMechanism.lua",
    "scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua",
    "scripts/control/mechanisms/NonJobActuationMechanism.lua",
    "scripts/control/NonActiveRelocationControl.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/observation/NativeBlockageObservation.lua",
    "scripts/observation/CurrentPlayerControlObservation.lua",
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
        return {version=OuttaMyWay.VERSION,enabled=OuttaMyWay.configuration:isEnabled(),aiControl=g_server~=nil and OuttaMyWay.configuration:isEnabled()==true}
    end)
else
    local configurationPublication=OuttaMyWay.LogPublication.origin("CONFIGURATION")
    configurationPublication:publish("NORMAL","ERROR","CONFIGURATION_STORAGE_FAILED",function()
        return {version=OuttaMyWay.VERSION,reason=configurationReason}
    end)
end

-- Enabled governs current runtime admission and immediate physical relinquishment.
OuttaMyWay.configuration:addChangeListener(function(notification)
    if notification==nil or notification.name~="enabled" or notification.durable~=true then return end
    local code=notification.value==true and "OUTTAMYWAY_SHELL_ENABLED" or "OUTTAMYWAY_SHELL_DISABLED"
    productPublication:publish("NORMAL","INFO",code,function()
        return {version=OuttaMyWay.VERSION,aiControl=g_server~=nil and notification.value==true}
    end)
end)

-- Observation supplies native pair evidence but never issues a Pair Commitment.
OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()
OuttaMyWay.nativeBlockageObservation=OuttaMyWay.NativeBlockageObservation.new(OuttaMyWay.configuration)
OuttaMyWay.liveHoldRelocateRuntime=OuttaMyWay.LiveHoldRelocateRuntime.new(
    OuttaMyWay.configuration,OuttaMyWay.nativeBlockageObservation)
OuttaMyWay.configuration:addChangeListener(function(notification)
    if notification~=nil and notification.name=="enabled"
        and notification.value==false then
        OuttaMyWay.liveHoldRelocateRuntime:relinquish("PLAYER_DISABLED")
    end
end)
OuttaMyWay.disabledStartupReminder=OuttaMyWay.DisabledStartupReminder.new(OuttaMyWay.configuration)
if type(addModEventListener)=="function" then
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.nativeBlockageObservation)
    addModEventListener(OuttaMyWay.liveHoldRelocateRuntime)
    addModEventListener(OuttaMyWay.disabledStartupReminder)
end
