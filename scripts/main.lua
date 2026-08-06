-- FS25_OuttaMyWay v4.7.1 Observation and Job Episode Identity entry point.
-- modDesc.xml loads only this file. Historical archived modules are never sourced.

local modDirectory = g_currentModDirectory or ""

local modules = {
    "scripts/config.lua",
    "scripts/contracts/ValueRecord.lua",
    "scripts/contracts/ObservationSnapshot.lua",
    "scripts/contracts/OperationalPicture.lua",
    "scripts/contracts/CandidateAction.lua",
    "scripts/contracts/ConstraintVerdict.lua",
    "scripts/contracts/DecisionRecord.lua",
    "scripts/contracts/CommitmentRecord.lua",
    "scripts/contracts/ObligationRecord.lua",
    "scripts/contracts/ControlRequest.lua",
    "scripts/contracts/ControlOutcome.lua",
    "scripts/identity/EpochSequence.lua",
    "scripts/identity/IdentityRegistry.lua",
    "scripts/observation/RuntimeObservationAdapter.lua",
    "scripts/identity/JobEpisodeAdmission.lua",
    "scripts/commitment/CommitmentStateMachine.lua",
    "scripts/commitment/CommitmentRegistry.lua",
    "scripts/commitment/ObligationLedger.lua",
    "scripts/authority/AuthorityRegistry.lua",
    "scripts/authority/EffectiveActuationComposition.lua",
    "scripts/diagnostics/ArchitectureTrace.lua",
    "scripts/runtime/Runtime.lua"
}

for _, relativePath in ipairs(modules) do
    source(modDirectory .. relativePath)
end

OuttaMyWay.modDirectory = modDirectory
OuttaMyWay.runtime = OuttaMyWay.Runtime.new()
OuttaMyWay.runtime:initialize()
