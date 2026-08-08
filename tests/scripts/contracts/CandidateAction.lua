local allowedCapabilities = {
    CONTINUE_UNCHANGED=true,
    CONTINUE_OBSERVATION=true,
    REGULATE_SPEED=true,
    HOLD=true,
    REPOSITION=true,
    RESTORE_CONFIGURATION=true,
    HANDOVER_TO_GIANTS=true,
    ESCALATE=true
}

local forbiddenSelectionFields = {
    selected=true,
    selectedCandidateId=true,
    admissible=true,
    viable=true,
    commitmentAction=true,
    controlRequest=true
}

local function rejectSelection(value, path, seen)
    if type(value) ~= "table" then return end
    seen = seen or {}
    if seen[value] then return end
    seen[value] = true
    for key,item in OuttaMyWay.ValueRecord.pairs(value) do
        if forbiddenSelectionFields[key] then
            error("CandidateAction contains forbidden selection field " .. path .. tostring(key),3)
        end
        rejectSelection(item,path .. tostring(key) .. ".",seen)
    end
end

OuttaMyWay.CandidateAction = OuttaMyWay.ValueRecord.register(
    "CandidateAction",
    OuttaMyWay.ValueRecord.define(
        "CandidateAction",
        {"identity","epoch","purpose","subject","capability","expectedEffect","evidenceBasis","representationFitness","preconditions","invalidationConditions","reversibility","obligationsCreated","releaseImplications","uncertainty","comparisonCost"},
        {},
        function(values)
            if not allowedCapabilities[values.capability] then
                error("CandidateAction contains unsupported capability " .. tostring(values.capability),3)
            end
            if type(values.subject) ~= "table" then error("CandidateAction subject must be a table",3) end
            if type(values.evidenceBasis) ~= "table" then error("CandidateAction evidenceBasis must be a table",3) end
            if type(values.representationFitness) ~= "table" then error("CandidateAction representationFitness must be a table",3) end
            if type(values.comparisonCost) ~= "number" or values.comparisonCost < 0 then
                error("CandidateAction comparisonCost must be a non-negative number",3)
            end
            rejectSelection(values,"")
        end
    )
)
