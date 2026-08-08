OuttaMyWay.ReleaseSafetyConstraint={}
OuttaMyWay.ReleaseSafetyConstraint.id="SAFE_RELEASE_HANDOVER"
OuttaMyWay.ReleaseSafetyConstraint.owner="ReleaseSafetyConstraint"
function OuttaMyWay.ReleaseSafetyConstraint.evaluate(candidate,operationalPicture)
    return OuttaMyWay.ConstraintEvidence.fromCandidate(candidate,OuttaMyWay.ReleaseSafetyConstraint.id)
end
