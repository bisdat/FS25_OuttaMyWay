OuttaMyWay.ResponsibilityCompatibilityConstraint={}
local Evaluator=OuttaMyWay.ResponsibilityCompatibilityConstraint
Evaluator.id="RESPONSIBILITY_COMPATIBILITY"
Evaluator.owner="ResponsibilityCompatibilityConstraint"

function Evaluator.evaluate(candidate,operationalPicture)
    local assemblyId=candidate.subject.assemblyId
    if candidate.capability=="REPOSITION" and assemblyId~=nil then
        for _,relation in ipairs(operationalPicture.responsibilityRelations) do
            if relation.relation=="FOLLOWER_OWNS_CLOSURE" and relation.leaderAssemblyId==assemblyId then
                local exception=candidate.evidenceBasis.responsibilityException
                if exception==nil then
                    return OuttaMyWay.ConstraintEvidence.fail("Follower Owns Closure prohibits generic Leader reposition without explicit exception evidence",{relation=relation},{operationalPictureId=operationalPicture.identity},{kind="RESPONSIBILITY_REASSESSMENT",relation="FOLLOWER_OWNS_CLOSURE"})
                end
                if exception.result=="PASS" then
                    return OuttaMyWay.ConstraintEvidence.pass(exception.reason or "Explicit responsibility-transfer evidence supports Leader reposition",exception.evidence or {},exception.provenance or {},exception.revalidationTrigger or {})
                elseif exception.result=="UNRESOLVED" then
                    return OuttaMyWay.ConstraintEvidence.unresolved(exception.reason or "Responsibility exception remains unresolved",exception.evidence or {},exception.provenance or {},exception.revalidationTrigger or {})
                elseif exception.result=="FAIL" then
                    return OuttaMyWay.ConstraintEvidence.fail(exception.reason or "Responsibility exception rejected",exception.evidence or {},exception.provenance or {},exception.revalidationTrigger or {})
                else
                    error("responsibilityException requires PASS, FAIL or UNRESOLVED",2)
                end
            end
        end
    end
    local packet=(candidate.evidenceBasis.constraintEvidence or {})[Evaluator.id]
    if packet~=nil then return OuttaMyWay.ConstraintEvidence.fromCandidate(candidate,Evaluator.id) end
    return OuttaMyWay.ConstraintEvidence.pass("No conflicting responsibility relation applies",{}, {operationalPictureId=operationalPicture.identity},{kind="RESPONSIBILITY_CHANGE"})
end
