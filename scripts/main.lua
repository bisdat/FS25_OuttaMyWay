-- FS25_OuttaMyWay v4.6.43 cooperative passage evidence consolidation candidate entry point.
-- modDesc.xml loads only this file; this loader owns module ordering.

local modDirectory = g_currentModDirectory or ""

local modules = {
    "scripts/config.lua",
    "scripts/diagnostics/Logger.lua",
    "scripts/settings/Settings.lua",
    "scripts/settings/ConsoleCommands.lua",
    "scripts/events/OuttaMyWayStateEvent.lua",
    "scripts/geometry/FieldBoundary.lua",
    "scripts/geometry/PhysicalEnvelopeEvidence.lua",
    "scripts/geometry/catalogues/CondorEndurance2CollisionCatalogue.lua",
    "scripts/geometry/FacingExtentProvider.lua",
    "scripts/geometry/ShadowClearanceCalculator.lua",
    "scripts/decision/ShadowRefugeCandidateComparison.lua",
    "scripts/prediction/VectorPrediction.lua",
    "scripts/prediction/CourseLookahead.lua",
    "scripts/observer/EventBus.lua",
    "scripts/observer/NativeAI.lua",
    "scripts/observer/WorkerState.lua",
    "scripts/observer/Observer.lua",
    "scripts/observer/InteractionContexts.lua",
    "scripts/observer/ConflictPredictor.lua",
    "scripts/prototypes/ConflictEmergenceProbe.lua",
    "scripts/prototypes/ConflictConfidenceProbe.lua",
    "scripts/decision/AutomaticEncounterAdmission.lua",
    "scripts/prototypes/OptionPreservationProbe.lua",
    "scripts/prototypes/ContinuationIntentProbe.lua",
    "scripts/prototypes/FieldWorldProbe.lua",
    "scripts/prototypes/PhysicalOccupancyProbe.lua",
    "scripts/prototypes/CollisionNodePoseProbe.lua",
    "scripts/prototypes/ShapeBoundProbe.lua",
    "scripts/prototypes/RuntimeGeometrySelectorProbe.lua",
    "scripts/prototypes/PhysicalAssemblyProbe.lua",
    "scripts/prototypes/Prototype13Fixtures.lua",
    "scripts/prototypes/Prototype13Resolver.lua",
    "scripts/prototypes/Prototype13Evaluator.lua",
    "scripts/prototypes/DeclaredRouteEvaluationProbe.lua",
    "scripts/control/TrafficDecisionEngineV2.lua",
    "scripts/control/TrafficPermissionGate.lua",
    "scripts/control/SingleWorkerDelayController.lua",
    "scripts/control/UnilateralSidestepController.lua",
    "scripts/control/RecoveryHandoff.lua",
    "scripts/control/TrafficExecutorV2.lua",
    "scripts/control/TrafficManagerV2.lua",
    "scripts/diagnostics/AIFieldCourseExplorer.lua",
    "scripts/reservation/ReservationEngine.lua",
    "scripts/control/EncounterController.lua",
    "scripts/decision/DecisionEngine.lua",
    "scripts/ui/Hud.lua",
    "scripts/core/Runtime.lua"
}

for _, relativePath in ipairs(modules) do
    source(modDirectory .. relativePath)
end

-- Retain the resolved mod directory for runtime assets such as the HUD texture.
OuttaMyWay.modDirectory = modDirectory

if OuttaMyWay.registerConsoleCommands ~= nil then
    OuttaMyWay:registerConsoleCommands()
end
