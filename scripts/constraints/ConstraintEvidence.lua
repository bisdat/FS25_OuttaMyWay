OuttaMyWay.ConstraintEvidence={}
local Evidence=OuttaMyWay.ConstraintEvidence

function Evidence.pass(reason,evidence,provenance,revalidationTrigger)
    return {result="PASS",reason=reason,evidence=evidence or {},provenance=provenance or {},revalidationTrigger=revalidationTrigger or {}}
end
function Evidence.fail(reason,evidence,provenance,revalidationTrigger)
    return {result="FAIL",reason=reason,evidence=evidence or {},provenance=provenance or {},revalidationTrigger=revalidationTrigger or {}}
end
function Evidence.unresolved(reason,evidence,provenance,revalidationTrigger)
    return {result="UNRESOLVED",reason=reason,evidence=evidence or {},provenance=provenance or {},revalidationTrigger=revalidationTrigger or {}}
end
