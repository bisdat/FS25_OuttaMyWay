OuttaMyWay.ConstraintEvidence={}
local Evidence=OuttaMyWay.ConstraintEvidence
local allowed={PASS=true,FAIL=true,UNRESOLVED=true}

function Evidence.fromCandidate(candidate,constraintId)
    local basis=candidate.evidenceBasis or {}
    local packets=basis.constraintEvidence or {}
    local packet=packets[constraintId]
    if packet==nil then
        return {result="UNRESOLVED",evidence={},provenance={},reason="No evidence supplied for mandatory constraint",revalidationTrigger={kind="EVIDENCE_REFRESH",constraintId=constraintId}}
    end
    if packet.applicable==false then
        return {result="PASS",evidence=packet.evidence or {},provenance=packet.provenance or {},reason=packet.reason or "Constraint not applicable to this candidate",revalidationTrigger=packet.revalidationTrigger or {}}
    end
    if not allowed[packet.result] then error("constraint evidence requires PASS, FAIL or UNRESOLVED for " .. constraintId,3) end
    return {
        result=packet.result,
        evidence=packet.evidence or {},
        provenance=packet.provenance or {},
        reason=packet.reason or packet.result,
        revalidationTrigger=packet.revalidationTrigger or {}
    }
end

function Evidence.pass(reason,evidence,provenance,revalidationTrigger)
    return {result="PASS",reason=reason,evidence=evidence or {},provenance=provenance or {},revalidationTrigger=revalidationTrigger or {}}
end
function Evidence.fail(reason,evidence,provenance,revalidationTrigger)
    return {result="FAIL",reason=reason,evidence=evidence or {},provenance=provenance or {},revalidationTrigger=revalidationTrigger or {}}
end
function Evidence.unresolved(reason,evidence,provenance,revalidationTrigger)
    return {result="UNRESOLVED",reason=reason,evidence=evidence or {},provenance=provenance or {},revalidationTrigger=revalidationTrigger or {}}
end
