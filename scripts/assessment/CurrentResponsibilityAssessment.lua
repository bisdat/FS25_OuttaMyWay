OuttaMyWay.CurrentResponsibilityAssessment = {}
local Assessment = OuttaMyWay.CurrentResponsibilityAssessment
Assessment.__index = Assessment

function Assessment.new()
    return setmetatable({},Assessment)
end

function Assessment:assessFollowerBoundary(record)
    if type(record)~="table" then
        return {disposition="PERSIST",reason="FOLLOWER_REGULATION_RETIREMENT_NOT_POSITIVELY_SUPPORTED"}
    end
    if record.status=="RETIRE_SUPPORTED" or record.action=="RETIRE" then
        return {disposition="TERMINATE",reason=record.reason or "FOLLOWER_REGULATION_RETIREMENT_SUPPORTED"}
    end
    return {disposition="PERSIST",reason=record.reason or "FOLLOWER_REGULATION_REMAINS_SUPPORTED_OR_UNRESOLVED"}
end

function Assessment:assessActionSpaceRegulation(current,relation)
    if current==nil then return {disposition="TERMINATE",reason="ACTION_SPACE_REGULATION_NOT_CURRENT"} end
    local forward=current.provenance and current.provenance.admissionKind=="FORWARD_INTERSECTION"
    if relation==nil then
        if forward then
            return {
                disposition="PERSIST",
                evidenceState="WAITING_FOR_EVIDENCE",
                reason="FORWARD_INTERSECTION_EVIDENCE_TEMPORARILY_UNRESOLVED"
            }
        end
        return {disposition="PERSIST",reason="ACTION_SPACE_RELATIONSHIP_TEMPORARILY_UNRESOLVED"}
    end
    if forward then
        if relation.relationshipStatus=="NEGATIVE" then
            return {
                disposition="TERMINATE",
                terminationEvidenceKind="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION",
                reason=relation.reason or "FORWARD_INTERSECTION_POSITIVELY_DISSOLVED"
            }
        end
        if relation.incumbentRelationship~=nil then
            return {
                disposition="TERMINATE",
                terminationEvidenceKind="FORWARD_INTERSECTION_POSITIVE_SUPERSESSION",
                reason=relation.reason or "FORWARD_INTERSECTION_POSITIVELY_SUPERSEDED"
            }
        end
        if relation.relationshipStatus=="POSITIVE"
            and relation.classification=="FORWARD_INTERSECTION"
            and relation.actionable==true then
            return {
                disposition="PERSIST",
                evidenceState="SUPPORTED",
                reason="FORWARD_INTERSECTION_REMAINS_POSITIVELY_SUPPORTED"
            }
        end
        return {
            disposition="PERSIST",
            evidenceState="WAITING_FOR_EVIDENCE",
            reason=relation.reason or "FORWARD_INTERSECTION_EVIDENCE_TEMPORARILY_UNRESOLVED"
        }
    end
    local relationship=relation.resolutionSpaceRelationship
    if type(relationship)=="table" and relationship.positiveDissolution==true then
        return {disposition="TERMINATE",reason=relationship.reason or "ACTION_SPACE_RELATIONSHIP_POSITIVELY_DISSOLVED"}
    end
    return {disposition="PERSIST",reason=(type(relationship)=="table" and relationship.reason) or relation.reason or "ACTION_SPACE_RELATIONSHIP_REMAINS_SUPPORTED_OR_UNRESOLVED"}
end
