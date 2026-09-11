OuttaMyWay.ProspectiveDecisionPortfolioSupport={}
local Support=OuttaMyWay.ProspectiveDecisionPortfolioSupport
Support.__index=Support

local function modeOfGroup(group)
    local boundary=group and group.supportBoundary or nil
    return type(boundary)=="table" and boundary.mode or nil
end

local function candidateMetadata(specification,family,groupKey,ordinal,boundary,extra)
    local evidence=specification.evidenceBasis or {}
    local bridge=evidence.cooperativePassageBridge or evidence.followerBoundaryBridge or evidence.actionSpaceRegulationBridge or evidence.obstructionRelocationBridge or {}
    local metadata={
        groupKey=groupKey,family=family,enumerationOrdinal=ordinal,supportBoundary=boundary,
        conflictIdentity=bridge.conflictIdentity,relocationKey=bridge.relocationKey,
        admissionKind=bridge.admissionKind,initialSeparationM=bridge.initialSeparationM,
        leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        assemblyIds=bridge.assemblyIds
    }
    for key,value in pairs(extra or {}) do metadata[key]=value end
    evidence.candidateSupportGroup=metadata
    specification.evidenceBasis=evidence
    if family=="PASSAGE" then
        local passage=evidence.cooperativePassageBridge
        if type(passage)=="table" and type(passage.progressiveSearch)=="table" then
            passage.progressiveSearch.conflictSelection="ONE_CONFLICT_SUPPORT_PROJECTION_NO_INTER_CONFLICT_SELECTION"
        end
    end
end

local function descriptorFromSpecification(specification,family,groupKey,ordinal,boundary,extra)
    local evidence=specification.evidenceBasis or {}
    local bridge=evidence.cooperativePassageBridge or evidence.followerBoundaryBridge or evidence.actionSpaceRegulationBridge or evidence.obstructionRelocationBridge or {}
    local descriptor={
        groupKey=groupKey,family=family,enumerationOrdinal=ordinal,supportBoundary=boundary,
        conflictIdentity=bridge.conflictIdentity,relocationKey=bridge.relocationKey,
        admissionKind=bridge.admissionKind,initialSeparationM=bridge.initialSeparationM,
        leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        assemblyIds=bridge.assemblyIds
    }
    for key,value in pairs(extra or {}) do descriptor[key]=value end
    return descriptor
end

local function appendGroup(state,group,family,groupKey,ordinal,extra)
    if type(group)~="table" or type(group.supportBoundary)~="table" then return false end
    local specifications=group.candidateSpecifications or {}
    if #specifications==0 then return false end
    local descriptor=nil
    for _,specification in ipairs(specifications) do
        candidateMetadata(specification,family,groupKey,ordinal,group.supportBoundary,extra)
        state.specifications[#state.specifications+1]=specification
        descriptor=descriptor or descriptorFromSpecification(specification,family,groupKey,ordinal,group.supportBoundary,extra)
    end
    state.groups[#state.groups+1]=descriptor
    for _,fitness in ipairs(group.representationFitness or {}) do
        local id=fitness.representationId
        if type(id)=="string" and state.fitnessIds[id]~=true then
            state.fitnessIds[id]=true
            state.representationFitness[#state.representationFitness+1]=fitness
        end
    end
    return true
end

local function passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,family,reason,ordinal)
    local group=self.passiveSupport:buildProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    appendGroup(state,group,family,"fail-closed:"..string.lower(family)..":"..tostring(reason),ordinal,{failClosedReason=reason})
end


local function forwardRelationshipCount(picture)
    local count=0
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relation in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if relation.classification=="FORWARD_INTERSECTION" and relation.actionable==true and relation.incumbentRelationship==nil and type(relation.actionSpaceConservation)=="table" then count=count+1 end
        end
    end
    return count
end

local function opposedRelations(picture)
    local result={}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        local classification=relation.classification
        if classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" or classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" then result[#result+1]=relation end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

function Support.new(identityRegistry,epochSequence,obstructionSupport,liveSupport,passiveSupport)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,obstructionSupport=obstructionSupport,liveSupport=liveSupport,passiveSupport=passiveSupport,publishedCount=0,lastStatus="INACTIVE"},Support)
end

function Support:attach(picture,snapshot)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    if OuttaMyWay.ValueRecord.length(picture.commitmentContext or {})>0 then
        self.lastStatus="INCUMBENT_CONTEXT_REQUIRES_EXISTING_SINGLE_PURPOSE_PATH"
        return nil
    end

    local targetPictureId=self.identities:issue("PICTURE")
    local targetEpoch=self.epochs:next()
    local baseValues=OuttaMyWay.ValueRecord.toTable(picture)
    local state={specifications={},groups={},representationFitness={},fitnessIds={}}
    for _,fitness in ipairs(baseValues.representationFitness or {}) do
        state.representationFitness[#state.representationFitness+1]=fitness
        if type(fitness.representationId)=="string" then state.fitnessIds[fitness.representationId]=true end
    end

    local relocation=self.obstructionSupport and self.obstructionSupport:buildFreshProjectedGroup(picture,snapshot,targetPictureId,targetEpoch) or nil
    if relocation~=nil then appendGroup(state,relocation,"OBSTRUCTION_RELOCATION","obstruction-relocation",1) end

    local follower,followerReason=self.liveSupport:buildProjectedGroup(picture,snapshot,{kind="FOLLOWER_BOUNDARY"},targetPictureId,targetEpoch)
    if modeOfGroup(follower)=="FOLLOWER_BOUNDARY" then
        local family="FOLLOWER"
        local spec=follower.candidateSpecifications and follower.candidateSpecifications[1] or nil
        local action=spec and spec.evidenceBasis and spec.evidenceBasis.followerBoundaryBridge and spec.evidenceBasis.followerBoundaryBridge.action or nil
        if action=="RETIRE" then family="FOLLOWER_RETIRE" end
        appendGroup(state,follower,family,"follower",1)
    elseif type(followerReason)=="string" and string.find(followerReason,"MULTIPLE_SIMULTANEOUS_FOLLOWER_BOUNDARY_CONTEXTS",1,true) then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"FOLLOWER_FAIL_CLOSED",followerReason,1)
    end

    local forwardCount=forwardRelationshipCount(picture)
    if forwardCount==1 then
        local forward=self.liveSupport:buildProjectedGroup(picture,snapshot,{kind="FORWARD_INTERSECTION"},targetPictureId,targetEpoch)
        if modeOfGroup(forward)=="ACTION_SPACE_REGULATION" then
            appendGroup(state,forward,"FORWARD_INTERSECTION","forward-intersection",1)
        end
    elseif forwardCount>1 then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"FORWARD_INTERSECTION_FAIL_CLOSED","MULTIPLE_FORWARD_INTERSECTION_CONTEXTS",1)
    end

    local actionSpaceGroups=0
    local relationOrdinal=0
    for _,relation in ipairs(opposedRelations(picture)) do
        relationOrdinal=relationOrdinal+1
        local group=self.liveSupport:buildProjectedGroup(
            picture,snapshot,{kind="OPPOSED_RELATIONSHIP",relationshipIdentity=relation.identity},targetPictureId,targetEpoch)
        local mode=modeOfGroup(group)
        if mode=="COOPERATIVE_PASSAGE" then
            appendGroup(state,group,"PASSAGE","passage:"..tostring(relation.identity),relationOrdinal)
        elseif mode=="ACTION_SPACE_REGULATION" then
            actionSpaceGroups=actionSpaceGroups+1
            appendGroup(state,group,"ACTION_SPACE","action-space:"..tostring(relation.identity),relationOrdinal)
        end
    end
    if actionSpaceGroups>1 then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"ACTION_SPACE_FAIL_CLOSED","MULTIPLE_ACTION_SPACE_REGULATION_CONTEXTS",1)
    end

    if #state.groups==0 then
        self.lastStatus="NO_PROSPECTIVE_SUPPORT_GROUPS"
        return self.passiveSupport:attach(picture,snapshot)
    end

    local capabilities,capabilitySet={},{}
    for _,specification in ipairs(state.specifications) do
        if type(specification.capability)=="string" and not capabilitySet[specification.capability] then
            capabilitySet[specification.capability]=true
            capabilities[#capabilities+1]=specification.capability
        end
    end
    table.sort(capabilities)
    table.sort(state.groups,function(a,b)
        if (a.enumerationOrdinal or 0)~=(b.enumerationOrdinal or 0) then return (a.enumerationOrdinal or 0)<(b.enumerationOrdinal or 0) end
        return tostring(a.groupKey)<tostring(b.groupKey)
    end)

    baseValues.identity=targetPictureId
    baseValues.epoch=targetEpoch
    baseValues.representationFitness=state.representationFitness
    baseValues.provenance={source="ProspectiveDecisionPortfolioSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="CANDIDATE_ENUMERATION_ONLY",candidateSupportProjection=true}
    baseValues.candidateSupportEvidence={
        complete=true,
        supportBoundary={
            mode="PROSPECTIVE_DECISION_PORTFOLIO",supportedCandidateClasses=capabilities,physicalCapabilitiesImplemented=true,
            controlAuthority="SELECTED_GROUP_SUPPORT_BOUNDARY_ONLY",boundedScope="FRESH_INDEPENDENT_CANDIDATE_SUPPORT_GROUPS",
            groups=state.groups,decisionPolicy={kind=OuttaMyWay.ProspectivePortfolioDecisionPolicy.KIND},
            incumbentLifecycleCompetition=false,lowerPrecedenceConstraintFallback=false,
            parentOperationalPictureId=picture.identity,targetOperationalPictureId=targetPictureId
        },
        candidateSpecifications=state.specifications,
        provenance={source="ProspectiveDecisionPortfolioSupport",observationSnapshotId=snapshot.identity,groupCount=#state.groups,parentOperationalPictureId=picture.identity,targetOperationalPictureId=targetPictureId,candidateSupportProjection=true}
    }
    self.publishedCount=self.publishedCount+1
    self.lastStatus="PROSPECTIVE_DECISION_PORTFOLIO_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(baseValues)
end

function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end
