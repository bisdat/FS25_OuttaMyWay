OuttaMyWay.RepresentationFitness = {}
local Fitness = OuttaMyWay.RepresentationFitness

local function copyArray(values)
    local result = {}; for _, value in ipairs(values or {}) do result[#result + 1] = value end; return result
end

function Fitness.evaluate(evidence, snapshot)
    if type(evidence) ~= "table" then error("Representation Fitness evidence must be a table", 2) end
    if evidence.representationId == nil then error("Representation Fitness evidence requires representationId", 2) end
    if evidence.assemblyId == nil then error("Representation Fitness evidence requires assemblyId", 2) end
    if evidence.question == nil then error("Representation Fitness evidence requires question", 2) end

    local state
    if evidence.structurallyValid == false then
        state = "STRUCTURALLY_INVALID"
    elseif evidence.refreshRequired == true then
        state = "REFRESH_REQUIRED"
    elseif evidence.uncertaintyPresent == true
        or evidence.coverageComplete ~= true
        or evidence.conservative ~= true
        or evidence.currentForQuestion ~= true then
        state = "USABLE_WITH_UNCERTAINTY"
    elseif evidence.coversAssessmentHorizon == false then
        state = "FIT_FOR_LIMITED_HORIZON"
    else
        state = "CURRENTLY_FIT"
    end

    local permissions = copyArray(evidence.permittedConclusions)
    table.sort(permissions)
    if state == "STRUCTURALLY_INVALID" then permissions = {} end

    return {
        representationId = evidence.representationId,
        assemblyId = evidence.assemblyId,
        question = evidence.question,
        assessmentHorizon = evidence.assessmentHorizon,
        state = state,
        claimPermissions = permissions,
        coverage = {
            complete = evidence.coverageComplete == true,
            conservative = evidence.conservative == true,
            coveredHorizon = evidence.coveredHorizon,
            underApproximationRisk = evidence.coverageComplete ~= true and evidence.conservative ~= true
        },
        uncertainty = evidence.uncertainty or {},
        refreshNeed = evidence.refreshNeed,
        validityDependencies = evidence.validityDependencies or {},
        provenance = { observationSnapshotId=snapshot.identity, source=evidence.provenance }
    }
end
