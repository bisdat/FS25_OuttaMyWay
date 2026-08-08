OuttaMyWay.EffectiveActuationCompositionConstraint={}
local Evaluator=OuttaMyWay.EffectiveActuationCompositionConstraint
Evaluator.id="EFFECTIVE_ACTUATION_COMPOSITION"
Evaluator.owner="EffectiveActuationCompositionConstraint"
local physical={REGULATE_SPEED=true,HOLD=true,REPOSITION=true,RESTORE_CONFIGURATION=true,HANDOVER_TO_GIANTS=true}

function Evaluator.evaluate(candidate,operationalPicture)
    if not physical[candidate.capability] then
        return OuttaMyWay.ConstraintEvidence.pass("No physical actuation composition is proposed",{}, {operationalPictureId=operationalPicture.identity},{kind="CANDIDATE_CHANGE"})
    end
    local values=candidate.evidenceBasis.effectiveActuationComposition
    if type(values)~="table" then
        return OuttaMyWay.ConstraintEvidence.unresolved("Physical candidate lacks Effective Actuation Composition evidence",{}, {operationalPictureId=operationalPicture.identity},{kind="COMPOSITION_REFRESH"})
    end
    local ok,record=pcall(OuttaMyWay.EffectiveActuationComposition.create,values)
    if not ok then
        return OuttaMyWay.ConstraintEvidence.fail("Effective Actuation Composition rejected: " .. tostring(record),{composition=values},{operationalPictureId=operationalPicture.identity},{kind="COMPOSITION_CHANGE"})
    end
    local packet=(candidate.evidenceBasis.constraintEvidence or {})[Evaluator.id]
    if packet~=nil then
        local result=OuttaMyWay.ConstraintEvidence.fromCandidate(candidate,Evaluator.id)
        result.evidence={compositionId=record.identity,declared=result.evidence}
        return result
    end
    return OuttaMyWay.ConstraintEvidence.pass("Effective Actuation Composition is structurally valid",{compositionId=record.identity},{operationalPictureId=operationalPicture.identity},{kind="COMPOSITION_CHANGE"})
end
