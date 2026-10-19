-- OuttaMyWay product-shell entry point. Build identity lives in scripts/config.lua and modDesc.xml.
-- Specification Jurisdictions: `CONFIGURATION`, `COMPLETION_SETTLEMENT_CONTROL`
-- Native blockage Observation feeds independently admitted live Hold & Relocate Control.
local modDirectory=g_currentModDirectory or ""
-- Module sequence is a contract: some modules capture dependencies as
-- file-scope locals when sourced. Producers MUST be loaded first.
local modules={
    "scripts/config.lua",
    "scripts/assessment/SpatialPairInference.lua",
    "scripts/coordination/HoldRelocateCoordinator.lua",
    "scripts/coordination/ProjectedEgressRegion.lua",
    "scripts/coordination/PairTransitRegion.lua",
    "scripts/coordination/PairSteeringDemand.lua",
    "scripts/coordination/NativePairCommitmentAuthority.lua",
    "scripts/control/HoldRelocatePhysicalControl.lua",
    "scripts/coordination/LiveHoldRelocateRuntime.lua",
    "scripts/diagnostics/NativeContinuationWitness.lua",
    "scripts/diagnostics/PairClearanceWitness.lua",
    "scripts/diagnostics/ReverseKinematicsProbe.lua",
    "scripts/control/mechanisms/NativeReverseMechanism.lua",
    "scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua",
    "scripts/control/mechanisms/NativeTranslationHoldMechanism.lua",
    "scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua",
    "scripts/control/mechanisms/NativeTransitRequestMechanism.lua",
    "scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua",
    "scripts/configuration/Configuration.lua",
    "scripts/diagnostics/DiagnosticPublicationPolicySource.lua",
    "scripts/publication/LogPublication.lua",
    "scripts/observation/StaticBlockageEncounterObservation.lua",
    "scripts/observation/NativeBlockageObservation.lua",
    "scripts/observation/NativeJobCompletionProbe.lua",
    "scripts/observation/FarmEdgeGeometry.lua",
    "scripts/observation/CompletionFieldMembership.lua",
    "scripts/observation/CompletionParkingGeometry.lua",
    "scripts/assessment/SettlementCorridorAssessment.lua",
    "scripts/assessment/ExteriorMarginComparison.lua",
    "scripts/observation/CompletionAssemblyFieldOccupancy.lua",
    "scripts/coordination/SettlementPhysicalOccupancy.lua",
    "scripts/coordination/CompletionSettlementRoute.lua",
    "scripts/coordination/ExtendedInfieldApproach.lua",
    "scripts/coordination/SettlementDestinationAssessment.lua",
    "scripts/coordination/ParkingRegionAllocation.lua",
    "scripts/control/CompletionTransitRuntime.lua",
    "scripts/control/CompletionSettlementRuntime.lua",
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
        return {aiControl=g_server~=nil and notification.value==true}
    end)
end)

-- Observation supplies native pair evidence but never issues a Pair Commitment.
OuttaMyWay.versionHud=OuttaMyWay.VersionHud.new()
OuttaMyWay.nativeBlockageObservation=OuttaMyWay.NativeBlockageObservation.new(OuttaMyWay.configuration)
OuttaMyWay.nativeJobCompletionProbe=OuttaMyWay.NativeJobCompletionProbe.new(OuttaMyWay.configuration)
OuttaMyWay.completionFieldMembership=OuttaMyWay.CompletionFieldMembership.new(OuttaMyWay.configuration)
OuttaMyWay.nativeJobCompletionProbe:setFieldMembership(OuttaMyWay.completionFieldMembership)
OuttaMyWay.completionTransitRuntime=OuttaMyWay.CompletionTransitRuntime.new(OuttaMyWay.configuration)
-- The dedicated default-On player parking choice will be implemented under #139.
-- Until then, Completion Parking observes master product Enabled consent.
OuttaMyWay.completionSettlementRuntime=OuttaMyWay.CompletionSettlementRuntime.new(
    OuttaMyWay.configuration)
-- TRANSIT and optional parking independently consume positive job completion.
OuttaMyWay.nativeJobCompletionProbe:setCompletionListener(function(job,vehicle)
    OuttaMyWay.completionTransitRuntime:onNativeCompletion(job,vehicle)
end)
OuttaMyWay.nativeJobCompletionProbe:setParkingListener(function(job,vehicle,sourceField)
    OuttaMyWay.completionSettlementRuntime:onNativeCompletion(
        job,vehicle,sourceField)
end)
OuttaMyWay.liveHoldRelocateRuntime=OuttaMyWay.LiveHoldRelocateRuntime.new(
    OuttaMyWay.configuration,OuttaMyWay.nativeBlockageObservation)
OuttaMyWay.configuration:addChangeListener(function(notification)
    if notification~=nil and notification.name=="enabled"
        and notification.value==false then
        OuttaMyWay.liveHoldRelocateRuntime:relinquish("PLAYER_DISABLED")
        OuttaMyWay.completionTransitRuntime:relinquish()
        OuttaMyWay.completionFieldMembership:reset()
        OuttaMyWay.completionSettlementRuntime:relinquish("PLAYER_DISABLED")
    end
end)
OuttaMyWay.disabledStartupReminder=OuttaMyWay.DisabledStartupReminder.new(OuttaMyWay.configuration)
if type(addModEventListener)=="function" then
    addModEventListener(OuttaMyWay.versionHud)
    addModEventListener(OuttaMyWay.nativeBlockageObservation)
    addModEventListener(OuttaMyWay.nativeJobCompletionProbe)
    addModEventListener(OuttaMyWay.completionTransitRuntime)
    addModEventListener(OuttaMyWay.completionSettlementRuntime)
    addModEventListener(OuttaMyWay.liveHoldRelocateRuntime)
    addModEventListener(OuttaMyWay.disabledStartupReminder)
end
