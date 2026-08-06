OuttaMyWay.CommitmentPreconditionsConstraint={}
local Evaluator=OuttaMyWay.CommitmentPreconditionsConstraint
Evaluator.id="COMMITMENT_PRECONDITIONS"
Evaluator.owner="CommitmentPreconditionsConstraint"
local boundedFields={"knowledgeGap","expectedRealityEvolution","preservedUsefulAction","exhaustionCondition","reassessmentDeadline","progressParticipantId"}

function Evaluator.evaluate(candidate,operationalPicture)
    if candidate.capability=="CONTINUE_OBSERVATION" then
        local contract=candidate.preconditions.boundedObservationContract
        if type(contract)~="table" then
            return OuttaMyWay.ConstraintEvidence.fail("CONTINUE_OBSERVATION lacks a Bounded Observation Contract",{}, {operationalPictureId=operationalPicture.identity},{kind="DECISION_REASSESSMENT"})
        end
        for _,field in ipairs(boundedFields) do
            if contract[field]==nil then
                return OuttaMyWay.ConstraintEvidence.fail("Bounded Observation Contract missing " .. field,{contract=contract},{operationalPictureId=operationalPicture.identity},{kind="DECISION_REASSESSMENT"})
            end
        end
        return OuttaMyWay.ConstraintEvidence.pass("Bounded Observation Contract is complete",{contract=contract},{operationalPictureId=operationalPicture.identity},{kind="BOUNDED_OBSERVATION_EXHAUSTION",deadline=contract.reassessmentDeadline})
    end
    return OuttaMyWay.ConstraintEvidence.fromCandidate(candidate,Evaluator.id)
end
