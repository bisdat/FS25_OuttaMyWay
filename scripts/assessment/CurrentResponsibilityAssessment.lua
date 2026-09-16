--- Interprets current evidence for persistence, waiting, positive dissolution or supersession of established responsibilities.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

OuttaMyWay.CurrentResponsibilityAssessment = {}
local Assessment = OuttaMyWay.CurrentResponsibilityAssessment
Assessment.__index = Assessment

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][CURRENT-RESPONSIBILITY] %s",message) else print("[FS25_OuttaMyWay][CURRENT-RESPONSIBILITY] "..message) end
end

local function projectionForAssembly(relation,assemblyId)
    if relation==nil or assemblyId==nil then return nil end
    local subject=relation.subjectProjection
    if subject~=nil and subject.assemblyId==assemblyId then return subject end
    local other=relation.otherProjection
    if other~=nil and other.assemblyId==assemblyId then return other end
    return nil
end

function Assessment.new()
    return setmetatable({category1ByResponsibilityId={}},Assessment)
end

-- Category-1 lifecycle memory is keyed by the semantic Regulation identity, not
-- by a generic pair. Responsibility Transition seeds the current allocation;
-- Situation Assessment alone advances its evidence phase from approach ->
-- protected manoeuvre -> positive discharge.
function Assessment:registerActionSpaceRegulation(current,relation,bridge)
    if current==nil or type(current.identity)~="string" then return nil end
    local forward=current.provenance and current.provenance.admissionKind=="FORWARD_INTERSECTION"
    if not forward then return nil end
    local existing=self.category1ByResponsibilityId[current.identity]
    local category1=relation~=nil
        and relation.relationshipStatus=="POSITIVE"
        and relation.classification=="FORWARD_INTERSECTION"
        and relation.spatialOverlay=="CATEGORY_1_CORNER"
    if category1~=true then
        if existing~=nil and existing.protectedManoeuvreEntered~=true then
            self.category1ByResponsibilityId[current.identity]=nil
        end
        return existing
    end
    local regulatedAssemblyId=bridge and bridge.regulatedAssemblyId or relation.temporalYielderAssemblyId
    local protectedAssemblyId=bridge and (bridge.protectedAssemblyId or bridge.excursionAssemblyId) or relation.continuingAssemblyId
    if type(regulatedAssemblyId)~="string" or type(protectedAssemblyId)~="string" then return existing end
    if existing~=nil and existing.protectedManoeuvreEntered==true then return existing end
    local projection=projectionForAssembly(relation,protectedAssemblyId)
    local state=existing or {}
    state.regulatedAssemblyId=regulatedAssemblyId
    state.protectedAssemblyId=protectedAssemblyId
    state.approachA8Current=projection~=nil and projection.a8ProductivePositive==true
    state.protectedManoeuvreEntered=false
    self.category1ByResponsibilityId[current.identity]=state
    if existing==nil then
        logInfo("CATEGORY_1_APPROACH_REGISTERED responsibility=%s regulated=%s protected=%s approachA8=%s",
            tostring(current.identity),tostring(regulatedAssemblyId),tostring(protectedAssemblyId),tostring(state.approachA8Current))
    end
    return state
end

function Assessment:isCategory1EvacuationProtectionActive(current)
    local identity=current and current.identity or nil
    local state=identity and self.category1ByResponsibilityId[identity] or nil
    return state~=nil and state.protectedManoeuvreEntered==true
end

function Assessment:category1RegulatedAssemblyId(current)
    local identity=current and current.identity or nil
    local state=identity and self.category1ByResponsibilityId[identity] or nil
    return state and state.regulatedAssemblyId or nil
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
    if forward then
        local state=self.category1ByResponsibilityId[current.identity]
        if state~=nil and state.protectedManoeuvreEntered~=true
            and relation~=nil and relation.relationshipStatus=="POSITIVE"
            and relation.classification=="FORWARD_INTERSECTION"
            and relation.spatialOverlay~=nil and relation.spatialOverlay~="CATEGORY_1_CORNER" then
            self.category1ByResponsibilityId[current.identity]=nil
            state=nil
        end
        if state~=nil then
            local projection=projectionForAssembly(relation,state.protectedAssemblyId)
            if state.protectedManoeuvreEntered==true then
                if projection~=nil and projection.a8ProductivePositive==true then
                    self.category1ByResponsibilityId[current.identity]=nil
                    logInfo("CATEGORY_1_EVACUATION_DISCHARGED responsibility=%s regulated=%s protected=%s witness=FRESH_A8",
                        tostring(current.identity),tostring(state.regulatedAssemblyId),tostring(state.protectedAssemblyId))
                    return {
                        disposition="TERMINATE",
                        terminationEvidenceKind="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION",
                        reason="CATEGORY_1_EVACUATION_POSITIVELY_DISCHARGED_BY_FRESH_A8"
                    }
                end
                return {
                    disposition="PERSIST",
                    evidenceState=(projection~=nil and projection.turningPositive==true) and "SUPPORTED" or "WAITING_FOR_EVIDENCE",
                    category1EvacuationProtection=true,
                    regulatedAssemblyId=state.regulatedAssemblyId,
                    protectedAssemblyId=state.protectedAssemblyId,
                    reason=(projection~=nil and projection.turningPositive==true)
                        and "CATEGORY_1_EVACUATION_PROTECTION_ACTIVE_PROTECTED_WORKER_TURNING"
                        or "CATEGORY_1_EVACUATION_PROTECTION_AWAITS_FRESH_A8"
                }
            end
            if state.approachA8Current==true and projection~=nil and projection.turningPositive==true then
                state.protectedManoeuvreEntered=true
                logInfo("CATEGORY_1_PROTECTED_MANOEUVRE_ENTRY responsibility=%s regulated=%s protected=%s",
                    tostring(current.identity),tostring(state.regulatedAssemblyId),tostring(state.protectedAssemblyId))
                return {
                    disposition="PERSIST",
                    evidenceState="SUPPORTED",
                    category1EvacuationProtection=true,
                    regulatedAssemblyId=state.regulatedAssemblyId,
                    protectedAssemblyId=state.protectedAssemblyId,
                    reason="CATEGORY_1_PROTECTED_MANOEUVRE_ENTRY"
                }
            end
            state.approachA8Current=projection~=nil and projection.a8ProductivePositive==true
        end
    end
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
            self.category1ByResponsibilityId[current.identity]=nil
            return {
                disposition="TERMINATE",
                terminationEvidenceKind="FORWARD_INTERSECTION_POSITIVE_DISSOLUTION",
                reason=relation.reason or "FORWARD_INTERSECTION_POSITIVELY_DISSOLVED"
            }
        end
        if relation.incumbentRelationship~=nil then
            self.category1ByResponsibilityId[current.identity]=nil
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
