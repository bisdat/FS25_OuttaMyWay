local allowed = { TRACE=true, ERROR=true }
OuttaMyWay.PassiveLiveTraceRecord = OuttaMyWay.ValueRecord.register(
    "PassiveLiveTraceRecord",
    OuttaMyWay.ValueRecord.define(
        "PassiveLiveTraceRecord",
        {"identity","epoch","timestamp","status","activeAssemblyCount","activeJobEpisodeCount","activeOperationCount","situationCount","encounterCount","generalControlAuthorityEnabled","provenance"},
        {"observationSnapshotId","operationalPictureId","candidateInventoryId","verdictSetId","decisionId","selectedCandidateId","selectedCapability","nonIntervention","error",
         "observedAssemblyCount","admittedEpisodeCount","endedEpisodeCount","candidateCount","allPassCandidateCount","unresolvedCandidateCount","failedCandidateCount","unavailableSourceCount","fieldWorldReferenceKey","fieldWorldFingerprint","playerFacingFieldLocators","globalActiveOperationCount",
         "cycleActiveJobVehicleCount","poseResolvedWorkerCount","activeOperationMemberCount","mathematicallyPossiblePairCount","relevantPairCount","eligiblePairCount","evaluatedPairCount","excludedPairCount","qualifyingPairCount","interactionEvidenceEmittedCount","interactionEvidenceReceivedCount","encounterCreatedCount","activeEncounterCount","encounterLifecycleTransitionCount","admittedEpisodeIds","endedEpisodeIds","assemblyDiagnostics","pairDiagnostics","diagnosticContradictions","encounterDiagnostics","encounterLifecycleTransitions","activeAssemblyReferenceKeys","futureSpaceRelationshipCount","futureSpaceRelationships","boundedControlDispatchStatus","boundedControlRequestId","boundedControlOutcomeId"},
        function(values)
            if not allowed[values.status] then error("PassiveLiveTraceRecord status must be TRACE or ERROR",3) end
            if values.generalControlAuthorityEnabled ~= false then error("passive-live trace requires general Control authority disabled",3) end
            if values.status == "ERROR" and values.error == nil then error("error trace requires error evidence",3) end
        end
    )
)
