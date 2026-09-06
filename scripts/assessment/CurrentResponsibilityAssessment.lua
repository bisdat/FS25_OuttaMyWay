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
    if relation==nil then
        if current.provenance and current.provenance.admissionKind=="FORWARD_INTERSECTION" then
            return {disposition="TERMINATE",reason="FORWARD_INTERSECTION_NO_LONGER_POSITIVELY_SUPPORTED"}
        end
        return {disposition="PERSIST",reason="ACTION_SPACE_RELATIONSHIP_TEMPORARILY_UNRESOLVED"}
    end
    if current.provenance and current.provenance.admissionKind=="FORWARD_INTERSECTION" then
        if relation.classification=="FORWARD_INTERSECTION" and relation.actionable==true and relation.incumbentRelationship==nil then
            return {disposition="PERSIST",reason="FORWARD_INTERSECTION_REMAINS_POSITIVELY_SUPPORTED"}
        end
        return {disposition="TERMINATE",reason=relation.reason or "FORWARD_INTERSECTION_DISSOLVED_OR_SUPERSEDED"}
    end
    local relationship=relation.resolutionSpaceRelationship
    if type(relationship)=="table" and relationship.positiveDissolution==true then
        return {disposition="TERMINATE",reason=relationship.reason or "ACTION_SPACE_RELATIONSHIP_POSITIVELY_DISSOLVED"}
    end
    return {disposition="PERSIST",reason=(type(relationship)=="table" and relationship.reason) or relation.reason or "ACTION_SPACE_RELATIONSHIP_REMAINS_SUPPORTED_OR_UNRESOLVED"}
end
