local forbiddenSemanticFields = {
    yieldRole = true,
    progressRole = true,
    candidatePreference = true,
    selectedCandidateId = true,
    commitmentState = true,
    commitmentAction = true,
    terminalCause = true,
    terminalDisposition = true,
    admissibility = true,
    strategy = true,
    jobEpisodeEnded = true,
    operationParticipation = true,
    situationRelevance = true,
    obstacleRelevance = true,
    representationFitness = true,
    responsibilityRelation = true,
    selectedRepresentation = true
}

local function rejectSemanticFields(value, path, seen)
    if type(value) ~= "table" then return end
    seen = seen or {}
    if seen[value] then return end
    seen[value] = true
    for key, item in pairs(value) do
        if forbiddenSemanticFields[key] then
            error("ObservationSnapshot contains forbidden semantic field " .. path .. tostring(key), 3)
        end
        rejectSemanticFields(item, path .. tostring(key) .. ".", seen)
    end
end

OuttaMyWay.ObservationSnapshot = OuttaMyWay.ValueRecord.register(
    "ObservationSnapshot",
    OuttaMyWay.ValueRecord.define(
        "ObservationSnapshot",
        {"identity", "epoch", "timestamp", "provenance", "fieldWorld", "assemblies", "geometry", "motion", "aiStates", "playerControl", "jobEpisodeEvidence", "operationMembershipEvidence", "physicalRepresentationEvidence", "controlOutcomes", "unavailableSources"},
        {},
        function(values)
            rejectSemanticFields(values, "")
        end
    )
)
