--- Interprets current evidence for persistence, waiting, positive dissolution or supersession of established responsibilities.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

OuttaMyWay.CurrentResponsibilityAssessment = {}
local Assessment = OuttaMyWay.CurrentResponsibilityAssessment
Assessment.__index = Assessment

function Assessment.new()
    return setmetatable({currentOperationalPicture=nil},Assessment)
end

function Assessment:captureOperationalPicture(picture)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    self.currentOperationalPicture=picture
end

function Assessment:clearOperationalPicture()
    self.currentOperationalPicture=nil
end

local function currentRegulatedAssemblyId(picture,current)
    local commitmentId=current and current.provenance and current.provenance.retainedCommitmentId or nil
    if type(commitmentId)~="string" or picture==nil then return nil end
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture.commitmentContext or {}) do
        if context.commitmentId==commitmentId then
            local result=nil
            for _,ownership in OuttaMyWay.ValueRecord.ipairs(context.progressActuationOwnership or {}) do
                if type(ownership.assemblyId)=="string" then
                    if result~=nil and result~=ownership.assemblyId then return nil end
                    result=ownership.assemblyId
                end
            end
            return result
        end
    end
end

local function protectedPairAssemblyId(relation,regulatedAssemblyId)
    if relation==nil or regulatedAssemblyId==nil then return nil end
    if relation.subjectAssemblyId==regulatedAssemblyId then return relation.otherAssemblyId end
    if relation.otherAssemblyId==regulatedAssemblyId then return relation.subjectAssemblyId end
end

local function currentCornerEngagement(picture,relation,protectedAssemblyId)
    if picture==nil or relation==nil or type(protectedAssemblyId)~="string" then return nil end
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        local ownsRelation=false
        for _,candidate in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if candidate.identity==relation.identity then ownsRelation=true break end
        end
        if ownsRelation then
            local cornerKnowledge=knowledge.cornerKnowledge or {}
            for _,engagement in OuttaMyWay.ValueRecord.ipairs(cornerKnowledge.engagements or {}) do
                if engagement.assemblyId==protectedAssemblyId then return engagement end
            end
            return nil
        end
    end
end

function Assessment:cornerEngagementProtection(current,relation)
    if current==nil or relation==nil or current.provenance==nil
        or current.provenance.admissionKind~="FORWARD_INTERSECTION" then return nil end
    local picture=self.currentOperationalPicture
    if picture==nil then return nil end
    local regulatedAssemblyId=currentRegulatedAssemblyId(picture,current)
    local protectedAssemblyId=protectedPairAssemblyId(relation,regulatedAssemblyId)
    local engagement=currentCornerEngagement(picture,relation,protectedAssemblyId)
    if engagement==nil then return nil end
    return {
        regulatedAssemblyId=regulatedAssemblyId,
        protectedAssemblyId=protectedAssemblyId,
        cornerKey=engagement.cornerKey,
        polygonKey=engagement.polygonKey,
        relevanceEvidenceState=engagement.relevanceEvidenceState,
        currentEvidenceState=engagement.currentEvidenceState,
        hasObservedManoeuvring=engagement.hasObservedManoeuvring==true
    }
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
        local cornerProtection=self:cornerEngagementProtection(current,relation)
        if cornerProtection~=nil then
            return {
                disposition="PERSIST",
                evidenceState="CORNER_ENGAGEMENT",
                reason="CORNER_ENGAGEMENT_PRESERVES_INCUMBENT_FORWARD_INTERSECTION_ALLOCATION",
                cornerProtection=cornerProtection
            }
        end
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
