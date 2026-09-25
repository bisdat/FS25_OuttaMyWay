-- FS25_OuttaMyWay runtime entry point. Current build identity is owned by scripts/config.lua and modDesc.xml.
-- Specification Jurisdictions: `CONFIGURATION`
-- modDesc.xml loads only this file. Retired implementation is preserved by repository history, not shipped runtime source.
local modDirectory=g_currentModDirectory or ""
-- Module source order is dependency-sensitive: sourced modules may consume globals established by earlier modules.
-- Preserve source-before-consumer ordering; this bootstrap sequence does not define architectural authority.
local modules={
    "scripts/config.lua","scripts/configuration/Configuration.lua","scripts/diagnostics/DiagnosticPublicationPolicySource.lua","scripts/publication/LogPublication.lua",
    "scripts/contracts/ValueRecord.lua","scripts/contracts/ObservationSnapshot.lua","scripts/contracts/OperationalPicture.lua","scripts/contracts/CandidateAction.lua","scripts/contracts/CandidateInventory.lua","scripts/contracts/ConstraintVerdict.lua","scripts/contracts/ConstraintVerdictSet.lua","scripts/contracts/DecisionRecord.lua","scripts/contracts/CommitmentRecord.lua","scripts/contracts/ObligationRecord.lua","scripts/contracts/Regulation.lua","scripts/contracts/ResolutionCommitment.lua","scripts/contracts/BoundedAuthorityGrant.lua","scripts/contracts/ControlRequest.lua","scripts/contracts/ControlOutcome.lua","scripts/contracts/GoverningBasisVerdict.lua","scripts/contracts/CommitmentApplicationRecord.lua",
    "scripts/identity/EpochSequence.lua","scripts/identity/IdentityRegistry.lua",
    "scripts/representation/PlanViewFootprint.lua","scripts/representation/EntityLocalShapeEvidence.lua","scripts/representation/AssemblyRepresentationCache.lua","scripts/representation/CurrentPhysicalConflictRepresentation.lua","scripts/representation/PairSpecificPassageClearance.lua",
    "scripts/observation/LiveInteractionObservation.lua","scripts/observation/LocalIntentObservation.lua","scripts/observation/FieldBoundedFutureSpace.lua","scripts/observation/NativeFieldWorkObservation.lua","scripts/identity/FieldWorldSnapshotRegistry.lua","scripts/identity/FieldWorldEquivalenceEvaluator.lua","scripts/identity/FieldWorldEquivalenceAuthority.lua","scripts/observation/RuntimeObservationAdapter.lua","scripts/observation/LiveAIJobEvidence.lua","scripts/observation/CurrentPhysicalAssemblySource.lua","scripts/observation/CurrentPhysicalPoseSource.lua","scripts/observation/LiveObservationSource.lua","scripts/identity/JobEpisodeAdmission.lua","scripts/identity/OperationAdmission.lua",
    "scripts/assessment/RepresentationFitness.lua","scripts/assessment/CurrentPairAssessmentScope.lua","scripts/assessment/ProgressionGeometry.lua","scripts/assessment/ResolutionMarginDemandAssessment.lua","scripts/assessment/FollowerBoundaryDemandAssessment.lua","scripts/assessment/TrajectoryConflictAssessment.lua","scripts/assessment/PassageCapabilityAssessment.lua","scripts/assessment/CausalObstructionAssessment.lua","scripts/assessment/BlockedProgressAssessment.lua","scripts/assessment/StructuralFieldShapeAssessment.lua","scripts/assessment/SpatialConstraintAssessment.lua","scripts/assessment/CurrentResponsibilityAssessment.lua","scripts/assessment/SituationAssessment.lua","scripts/assessment/ResolutionMarginSituationAssessment.lua","scripts/assessment/CurrentResponsibilityContextSituationAssessment.lua",
    "scripts/commitment/CommitmentStateMachine.lua","scripts/commitment/CommitmentRegistry.lua","scripts/commitment/ObligationLedger.lua","scripts/authority/AuthorityRegistry.lua","scripts/control/mechanisms/NonJobActuationMechanism.lua","scripts/authority/EffectiveActuationComposition.lua","scripts/authority/BoundedAuthority.lua","scripts/commitment/CommitmentAdmission.lua","scripts/commitment/GoverningBasisEvaluator.lua","scripts/commitment/TerminalSettlementEvaluator.lua","scripts/commitment/DecisionCommitmentBoundary.lua","scripts/commitment/LiveTrafficCommitmentLifecycle.lua","scripts/authority/BubbleBulletTime.lua","scripts/commitment/ObstructionRelocationCommitmentLifecycle.lua","scripts/responsibility/ResolutionCommitmentAdapter.lua","scripts/responsibility/ResponsibilityTransitionAuthority.lua","scripts/responsibility/FollowerBoundaryResponsibilityTransition.lua","scripts/responsibility/ActionSpaceRegulationResponsibilityTransition.lua","scripts/candidates/BubbleDecisionHorizonCandidateSupport.lua","scripts/responsibility/CooperativePassageResponsibilityTransition.lua","scripts/responsibility/ObstructionRelocationResponsibilityTransition.lua",
    "scripts/candidates/CandidateSpace.lua","scripts/candidates/PassiveLiveCandidateSupport.lua","scripts/candidates/LocalPassagePlanner.lua","scripts/candidates/ObstructionRelocationCandidateSupport.lua","scripts/candidates/LiveTrafficCandidateSupport.lua","scripts/decision/ProspectivePortfolioDecisionPolicy.lua","scripts/candidates/ProspectiveDecisionPortfolioSupport.lua","scripts/constraints/ConstraintEvidence.lua",
    "scripts/constraints/evaluators/RepresentationFitnessConstraint.lua","scripts/constraints/evaluators/ResponsibilityCompatibilityConstraint.lua","scripts/constraints/evaluators/CommitmentPreconditionsConstraint.lua","scripts/constraints/evaluators/EffectiveActuationCompositionConstraint.lua",
    "scripts/constraints/ConstraintEngine.lua","scripts/decision/TrafficPolicemanDecisionPolicy.lua","scripts/decision/DecisionSelector.lua","scripts/diagnostics/PassiveLiveValidator.lua","scripts/diagnostics/VersionHud.lua","scripts/control/mechanisms/FieldWorkHoldMechanism.lua","scripts/control/mechanisms/NativeDriveMechanism.lua","scripts/control/mechanisms/TransitConfigurationMechanism.lua","scripts/control/CooperativePassageControl.lua","scripts/control/ObstructionRelocationControl.lua","scripts/authority/ResolutionSpaceProgressionEnvelope.lua","scripts/authority/FollowerBoundaryMagnitudePolicy.lua","scripts/authority/RegulationBoundedAuthority.lua","scripts/control/RegulationControl.lua","scripts/control/LiveControlDispatcher.lua","scripts/runtime/LiveRuntimeCoordinator.lua","scripts/runtime/Runtime.lua","scripts/lifecycle/ProductLifecycle.lua","scripts/gui/ConfigurationSettingsExtension.lua","scripts/gui/DisabledStartupReminder.lua"
}
for _,relativePath in ipairs(modules) do source(modDirectory..relativePath) end
OuttaMyWay.modDirectory=modDirectory

-- Product-shell Configuration resolves before Log Publication policy and before
-- any normal Runtime bootstrap. Engineering DIAGNOSTIC remains a separate override.
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
    productPublication:publish("NORMAL","INFO","OUTTAMYWAY_STARTED",function()
        return {version=OuttaMyWay.VERSION,enabled=OuttaMyWay.configuration:isEnabled()}
    end)
else
    local configurationPublication=OuttaMyWay.LogPublication.origin("CONFIGURATION")
    configurationPublication:publish("NORMAL","ERROR","CONFIGURATION_STORAGE_FAILED",function()
        return {version=OuttaMyWay.VERSION,reason=configurationReason}
    end)
end

-- Hold and Native Drive install transparent GIANTS interception wrappers which
-- intentionally remain installed. Reusing these cleared subordinate mechanisms
-- across semantic Runtime lifetimes avoids stacking equivalent wrappers on live re-enable.
local sharedPhysicalControlMechanisms={
    holdMechanism=OuttaMyWay.FieldWorkHoldMechanism.new(),
    driveMechanism=OuttaMyWay.NativeDriveMechanism.new(),
    configurationMechanism=OuttaMyWay.TransitConfigurationMechanism.new()
}

local function registerRuntimeBundleListeners()
    if type(addModEventListener)~="function" then return false,"ADD_MOD_EVENT_LISTENER_UNAVAILABLE" end
    -- Runtime capture/process/dispatch is causally upstream of diagnostics.
    addModEventListener(OuttaMyWay.liveRuntimeCoordinator)
    addModEventListener(OuttaMyWay.regulationControl)
    addModEventListener(OuttaMyWay.cooperativePassageControl)
    if OuttaMyWay.runtime.bubbleBulletTime~=nil then addModEventListener(OuttaMyWay.runtime.bubbleBulletTime) end
    addModEventListener(OuttaMyWay.obstructionRelocationControl)
    addModEventListener(OuttaMyWay.runtime.passiveLiveValidator)
    addModEventListener(OuttaMyWay.versionHud)
    return true,"RUNTIME_LISTENERS_REGISTERED"
end

local function createRuntimeBundle()
    sharedPhysicalControlMechanisms.holdMechanism:clear()
    sharedPhysicalControlMechanisms.driveMechanism:clearAll()
    sharedPhysicalControlMechanisms.configurationMechanism:clearAll()

    local runtime=OuttaMyWay.Runtime.new()
    runtime.situationAssessment=OuttaMyWay.ResolutionMarginSituationAssessment.new(runtime.situationAssessment)
    runtime.situationAssessment=OuttaMyWay.CurrentResponsibilityContextSituationAssessment.new(
        runtime.situationAssessment,runtime.currentResponsibilityAssessment)
    runtime:initialize()

    local versionHud=OuttaMyWay.VersionHud.new()
    local regulationControl=OuttaMyWay.RegulationControl.new(runtime,sharedPhysicalControlMechanisms.driveMechanism)
    runtime:setRegulationControl(regulationControl)

    local cooperativePassageControl=OuttaMyWay.CooperativePassageControl.new(runtime,sharedPhysicalControlMechanisms)
    runtime:setCooperativePassageControl(cooperativePassageControl)

    local obstructionRelocationControl=OuttaMyWay.ObstructionRelocationControl.new(runtime,runtime.liveObservationSource)
    runtime:setObstructionRelocationControl(obstructionRelocationControl)

    local liveRuntimeCoordinator=OuttaMyWay.LiveRuntimeCoordinator.new(
        runtime,runtime.liveObservationSource,runtime.fieldWorldSnapshots,runtime.passiveLiveValidator)
    runtime.liveRuntimeCoordinator=liveRuntimeCoordinator

    local listeners={liveRuntimeCoordinator,regulationControl,cooperativePassageControl}
    if runtime.bubbleBulletTime~=nil then listeners[#listeners+1]=runtime.bubbleBulletTime end
    listeners[#listeners+1]=obstructionRelocationControl
    listeners[#listeners+1]=runtime.passiveLiveValidator
    listeners[#listeners+1]=versionHud

    return {
        runtime=runtime,
        versionHud=versionHud,
        physicalControlMechanisms=sharedPhysicalControlMechanisms,
        regulationControl=regulationControl,
        cooperativePassageControl=cooperativePassageControl,
        obstructionRelocationControl=obstructionRelocationControl,
        liveRuntimeCoordinator=liveRuntimeCoordinator,
        listeners=listeners,
        registerListeners=registerRuntimeBundleListeners
    }
end

OuttaMyWay.productLifecycle=OuttaMyWay.ProductLifecycle.new(OuttaMyWay.configuration,createRuntimeBundle)
OuttaMyWay.productLifecycle:subscribe()

if configurationReady and OuttaMyWay.configuration:isEnabled()==true then
    OuttaMyWay.productLifecycle:enable("STARTUP",false)
end

-- ConfigurationSettingsExtension is installed at source-load time into the existing
-- GIANTS General Settings frame. It is not a map listener and therefore remains
-- available independently of semantic Runtime existence without owning menu lifecycle.

-- DisabledStartupReminder is product-shell status communication. It remains
-- available when Runtime is absent and evaluates resolved Configuration per mission load.
OuttaMyWay.disabledStartupReminder=OuttaMyWay.DisabledStartupReminder.new(OuttaMyWay.configuration)
if type(addModEventListener)=="function" then
    addModEventListener(OuttaMyWay.disabledStartupReminder)
end
