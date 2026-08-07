local allowedActions={CREATE=true,MAINTAIN=true,REVISE=true,WAIT=true,SETTLE=true}
local function contains(values,target)
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do if value==target then return true end end
    return false
end

OuttaMyWay.DecisionRecord = OuttaMyWay.ValueRecord.register(
    "DecisionRecord",
    OuttaMyWay.ValueRecord.define(
        "DecisionRecord",
        {"identity","epoch","operationalPictureId","candidateInventoryId","mandatoryVerdictSetId","viableCandidateIds","nonIntervention","comparisonBasis","commitmentAction","explanation","provenance"},
        {"selectedCandidateId"},
        function(values)
            if not allowedActions[values.commitmentAction] then
                error("DecisionRecord contains unsupported Commitment action " .. tostring(values.commitmentAction),3)
            end
            if type(values.nonIntervention) ~= "table" or type(values.nonIntervention.explicit) ~= "boolean" then
                error("DecisionRecord nonIntervention must explicitly state whether non-intervention was selected",3)
            end
            if values.selectedCandidateId ~= nil and not contains(values.viableCandidateIds,values.selectedCandidateId) then
                error("DecisionRecord selected candidate is not viable",3)
            end
            if values.selectedCandidateId == nil and values.nonIntervention.explicit ~= true then
                error("DecisionRecord without a selected candidate requires explicit non-intervention",3)
            end
        end
    )
)
