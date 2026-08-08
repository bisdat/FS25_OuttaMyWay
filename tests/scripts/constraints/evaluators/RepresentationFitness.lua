OuttaMyWay.RepresentationFitnessConstraint={}
local Evaluator=OuttaMyWay.RepresentationFitnessConstraint
Evaluator.id="REPRESENTATION_FITNESS"
Evaluator.owner="RepresentationFitnessConstraint"
local physical={REGULATE_SPEED=true,HOLD=true,REPOSITION=true,RESTORE_CONFIGURATION=true,HANDOVER_TO_GIANTS=true}

local function accepted(requirement,state)
    for _,allowed in OuttaMyWay.ValueRecord.ipairs(requirement.acceptedStates or {}) do if allowed==state then return true end end
    return false
end

function Evaluator.evaluate(candidate,operationalPicture)
    local requirements=candidate.representationFitness.requirements or {}
    if OuttaMyWay.ValueRecord.length(requirements)==0 then
        if physical[candidate.capability] then
            return OuttaMyWay.ConstraintEvidence.unresolved("Physical candidate has no purpose-specific Representation Fitness requirement",{}, {},{kind="REPRESENTATION_ASSESSMENT"})
        end
        return OuttaMyWay.ConstraintEvidence.pass("Representation Fitness not applicable to non-actuating candidate")
    end
    local byId={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(operationalPicture.representationFitness) do byId[item.representationId]=item end
    local observed={}
    for _,requirement in OuttaMyWay.ValueRecord.ipairs(requirements) do
        local item=byId[requirement.representationId]
        if item==nil then
            return OuttaMyWay.ConstraintEvidence.unresolved("Required representation is absent",{representationId=requirement.representationId},{operationalPictureId=operationalPicture.identity},{kind="REPRESENTATION_REFRESH",representationId=requirement.representationId})
        end
        observed[#observed+1]={representationId=item.representationId,state=item.state}
        if item.state=="STRUCTURALLY_INVALID" then
            return OuttaMyWay.ConstraintEvidence.fail("Required representation is structurally invalid",observed,item.provenance,{kind="REPRESENTATION_REPLACEMENT",representationId=item.representationId})
        end
        if not accepted(requirement,item.state) then
            return OuttaMyWay.ConstraintEvidence.unresolved("Representation Fitness does not support this candidate purpose",observed,item.provenance,{kind="REPRESENTATION_REFRESH",representationId=item.representationId})
        end
    end
    return OuttaMyWay.ConstraintEvidence.pass("All purpose-specific Representation Fitness requirements are supported",observed,{operationalPictureId=operationalPicture.identity},{kind="REPRESENTATION_CHANGE"})
end
