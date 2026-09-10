OuttaMyWay.ResponsibilityCompatibilityConstraint={}
local Evaluator=OuttaMyWay.ResponsibilityCompatibilityConstraint
Evaluator.id="RESPONSIBILITY_COMPATIBILITY"
Evaluator.owner="ResponsibilityCompatibilityConstraint"

function Evaluator.evaluate(candidate,operationalPicture)
    return OuttaMyWay.ConstraintEvidence.pass(
        "No conflicting responsibility relation applies",
        {},
        {operationalPictureId=operationalPicture.identity},
        {kind="RESPONSIBILITY_CHANGE"}
    )
end
