local forbiddenDecisionFields = {
    yieldRole = true,
    progressRole = true,
    candidatePreference = true,
    selectedCandidateId = true,
    selectedAction = true,
    commitmentAction = true,
    terminalDisposition = true,
    controlRequest = true,
    admissibility = true,
    strategy = true
}

local allowedFitnessStates = {
    CURRENTLY_FIT = true,
    FIT_FOR_LIMITED_HORIZON = true,
    USABLE_WITH_UNCERTAINTY = true,
    REFRESH_REQUIRED = true,
    STRUCTURALLY_INVALID = true
}

local function rejectDecisionFields(value, path, seen)
    if type(value) ~= "table" then return end
    seen = seen or {}
    if seen[value] then return end
    seen[value] = true
    for key, item in OuttaMyWay.ValueRecord.pairs(value) do
        if forbiddenDecisionFields[key] then
            error("OperationalPicture contains forbidden Decision/Control field " .. path .. tostring(key), 3)
        end
        rejectDecisionFields(item, path .. tostring(key) .. ".", seen)
    end
end

local function validate(values)
    rejectDecisionFields(values, "")
    local demand = values.demand
    if type(demand) ~= "table" then error("OperationalPicture demand must be a table", 3) end
    for _, required in OuttaMyWay.ValueRecord.ipairs({"committedDemand", "potentialDemand", "temporarySlack"}) do
        if type(demand[required]) ~= "table" then
            error("OperationalPicture demand missing " .. required, 3)
        end
    end
    for key, _ in OuttaMyWay.ValueRecord.pairs(demand) do
        if key ~= "committedDemand" and key ~= "potentialDemand" and key ~= "temporarySlack" then
            error("OperationalPicture contains unsupported demand class " .. tostring(key), 3)
        end
    end
    for _, item in OuttaMyWay.ValueRecord.ipairs(values.representationFitness) do
        if not allowedFitnessStates[item.state] then
            error("OperationalPicture contains unsupported Representation Fitness state " .. tostring(item.state), 3)
        end
    end
end

OuttaMyWay.OperationalPicture = OuttaMyWay.ValueRecord.register(
    "OperationalPicture",
    OuttaMyWay.ValueRecord.define(
        "OperationalPicture",
        {"identity", "epoch", "observationSnapshotId", "situations", "encounters", "identities", "currentSpace", "futureSpace", "demand", "responsibilityRelations", "uncertainty", "representationFitness", "provenance", "controlOutcomeEvidence", "candidateSupportEvidence", "commitmentContext"},
        {"diagnostics", "motionEvidence", "physicalSpaceEvidence", "productiveContinuationKnowledge", "guardedRecoveryKnowledge", "followerBoundaryKnowledge", "trajectoryKnowledge", "opposedCorridorKnowledge", "cooperativePassageKnowledge"},
        validate
    )
)
