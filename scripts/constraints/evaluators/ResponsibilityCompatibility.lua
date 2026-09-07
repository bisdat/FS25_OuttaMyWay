OuttaMyWay.ResponsibilityCompatibilityConstraint={}
local Evaluator=OuttaMyWay.ResponsibilityCompatibilityConstraint
Evaluator.id="RESPONSIBILITY_COMPATIBILITY"
Evaluator.owner="ResponsibilityCompatibilityConstraint"

function Evaluator.evaluate(candidate,operationalPicture)
    local assemblyId=candidate.subject.assemblyId
    if candidate.capability=="REPOSITION" and assemblyId~=nil then
        for _,relation in OuttaMyWay.ValueRecord.ipairs(operationalPicture.responsibilityRelations) do
            if relation.relation=="FOLLOWER_OWNS_CLOSURE" and relation.leaderAssemblyId==assemblyId then
                return OuttaMyWay.ConstraintEvidence.fail(
                    "Follower Owns Closure prohibits generic Leader reposition",
                    {relation=relation},
                    {operationalPictureId=operationalPicture.identity},
                    {kind="RESPONSIBILITY_REASSESSMENT",relation="FOLLOWER_OWNS_CLOSURE"}
                )
            end
        end
    end
    return OuttaMyWay.ConstraintEvidence.pass(
        "No conflicting responsibility relation applies",
        {},
        {operationalPictureId=operationalPicture.identity},
        {kind="RESPONSIBILITY_CHANGE"}
    )
end
