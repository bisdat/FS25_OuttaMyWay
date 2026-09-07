OuttaMyWay.ProspectiveDecisionPortfolioSupport={}
local Support=OuttaMyWay.ProspectiveDecisionPortfolioSupport
Support.__index=Support

local function modeOf(picture)
    local support=picture and picture.candidateSupportEvidence or nil
    local boundary=support and support.supportBoundary or nil
    return type(boundary)=="table" and boundary.mode or nil
end

local function supportView(self,picture,changes,reason)
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.identity=self.identities:issue("PICTURE")
    values.epoch=self.epochs:next()
    values.provenance={source="ProspectiveDecisionPortfolioSupport",parentOperationalPictureId=picture.identity,view=reason}
    for key,value in pairs(changes or {}) do values[key]=value end
    return OuttaMyWay.OperationalPicture.new(values)
end

local function candidateMetadata(specification,family,groupKey,ordinal,boundary,extra)
    local evidence=specification.evidenceBasis or {}
    local bridge=evidence.cooperativePassageBridge or evidence.followerBoundaryBridge or evidence.d0146ActionSpaceRegulationBridge or evidence.terminalEgressBridge or evidence.obstructionRelocationBridge or evidence.guardedRecoveryBridge or {}
    local metadata={
        groupKey=groupKey,family=family,legacyOrdinal=ordinal,supportBoundary=boundary,
        conflictIdentity=bridge.conflictIdentity,relocationKey=bridge.relocationKey,terminalEpisodeId=bridge.terminalEpisodeId,
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
            passage.progressiveSearch.conflictSelection="ONE_CONFLICT_SUPPORT_VIEW_NO_INTER_CONFLICT_SELECTION"
        end
    end
end

local function descriptorFromSpecification(specification,family,groupKey,ordinal,boundary,extra)
    local evidence=specification.evidenceBasis or {}
    local bridge=evidence.cooperativePassageBridge or evidence.followerBoundaryBridge or evidence.d0146ActionSpaceRegulationBridge or evidence.terminalEgressBridge or evidence.obstructionRelocationBridge or evidence.guardedRecoveryBridge or {}
    local descriptor={
        groupKey=groupKey,family=family,legacyOrdinal=ordinal,supportBoundary=boundary,
        conflictIdentity=bridge.conflictIdentity,relocationKey=bridge.relocationKey,terminalEpisodeId=bridge.terminalEpisodeId,
        admissionKind=bridge.admissionKind,initialSeparationM=bridge.initialSeparationM,
        leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        assemblyIds=bridge.assemblyIds
    }
    for key,value in pairs(extra or {}) do descriptor[key]=value end
    return descriptor
end

local function appendSupported(state,supported,family,groupKey,ordinal,extra)
    if supported==nil then return false end
    local values=OuttaMyWay.ValueRecord.toTable(supported)
    local support=values.candidateSupportEvidence
    if type(support)~="table" or support.complete~=true or type(support.supportBoundary)~="table" then return false end
    local specifications=support.candidateSpecifications or {}
    if #specifications==0 then return false end
    local boundary=support.supportBoundary
    local descriptor=nil
    for _,specification in ipairs(specifications) do
        candidateMetadata(specification,family,groupKey,ordinal,boundary,extra)
        state.specifications[#state.specifications+1]=specification
        descriptor=descriptor or descriptorFromSpecification(specification,family,groupKey,ordinal,boundary,extra)
    end
    state.groups[#state.groups+1]=descriptor
    for _,fitness in ipairs(values.representationFitness or {}) do
        local id=fitness.representationId
        if type(id)=="string" and state.fitnessIds[id]~=true then
            state.fitnessIds[id]=true
            state.representationFitness[#state.representationFitness+1]=fitness
        end
    end
    return true
end

local function passiveFailClosed(self,picture,snapshot,state,family,reason,ordinal)
    local supported=self.passiveSupport:attach(picture,snapshot)
    appendSupported(state,supported,family,"fail-closed:"..string.lower(family)..":"..tostring(reason),ordinal,{failClosedReason=reason})
end

local function activeGuardedRecoveryCount(picture)
    local count=0
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.guardedRecoveryKnowledge or {}) do
        if item.nativeReacquired~=true and item.activeRecovery==true and type(item.commitmentId)=="string" then count=count+1 end
    end
    return count
end

local function terminalEligible(record)
    return record.obstructionPositive==true and record.playerClaimed~=true and record.exhausted~=true and record.yieldAwaitingContinuation~=true
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

local function opposedViewRelations(picture)
    local result={}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        local classification=relation.classification
        if classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" or classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" then result[#result+1]=relation end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

function Support.new(identityRegistry,epochSequence,obstructionSupport,terminalSupport,liveSupport,passiveSupport)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,obstructionSupport=obstructionSupport,terminalSupport=terminalSupport,liveSupport=liveSupport,passiveSupport=passiveSupport,publishedCount=0,lastStatus="INACTIVE"},Support)
end

function Support:attach(picture,snapshot)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    if OuttaMyWay.ValueRecord.length(picture.commitmentContext or {})>0 then
        self.lastStatus="INCUMBENT_CONTEXT_REQUIRES_EXISTING_SINGLE_PURPOSE_PATH"
        return nil
    end

    local baseValues=OuttaMyWay.ValueRecord.toTable(picture)
    local state={specifications={},groups={},representationFitness={},fitnessIds={}}
    for _,fitness in ipairs(baseValues.representationFitness or {}) do
        state.representationFitness[#state.representationFitness+1]=fitness
        if type(fitness.representationId)=="string" then state.fitnessIds[fitness.representationId]=true end
    end

    local cold=self.obstructionSupport and self.obstructionSupport:attach(picture,snapshot) or nil
    if cold~=nil then appendSupported(state,cold,"COLD_OBSTRUCTION","cold-obstruction",1) end

    local terminalOrdinal=0
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.terminalOccupancyKnowledge or {}) do
        if terminalEligible(record) then
            terminalOrdinal=terminalOrdinal+1
            local view=supportView(self,picture,{terminalOccupancyKnowledge={record}},"D0147_TERMINAL_RECORD")
            local warm=self.terminalSupport and self.terminalSupport:attach(view,snapshot) or nil
            if modeOf(warm)=="D0147_BOUNDED_TERMINAL_EGRESS" then
                appendSupported(state,warm,"WARM_D0147","warm-d0147:"..tostring(record.terminalEpisodeId),terminalOrdinal)
            end
        end
    end

    local followerView=supportView(self,picture,{opposedCorridorKnowledge={},spatialConstraintKnowledge={},guardedRecoveryKnowledge={}},"FOLLOWER_ONLY")
    local follower=self.liveSupport:attach(followerView,snapshot)
    local followerMode=modeOf(follower)
    local followerStatus=self.liveSupport:getLastStatus()
    if followerMode=="FOLLOWER_BOUNDARY_D0141" then
        local family="FOLLOWER"
        local fv=OuttaMyWay.ValueRecord.toTable(follower)
        local spec=fv.candidateSupportEvidence and fv.candidateSupportEvidence.candidateSpecifications and fv.candidateSupportEvidence.candidateSpecifications[1] or nil
        local action=spec and spec.evidenceBasis and spec.evidenceBasis.followerBoundaryBridge and spec.evidenceBasis.followerBoundaryBridge.action or nil
        if action=="RETIRE" then family="FOLLOWER_RETIRE" end
        appendSupported(state,follower,family,"follower",1)
    elseif type(followerStatus)=="string" and string.find(followerStatus,"MULTIPLE_SIMULTANEOUS_FOLLOWER_BOUNDARY_CONTEXTS",1,true) then
        passiveFailClosed(self,picture,snapshot,state,"FOLLOWER_FAIL_CLOSED",followerStatus,1)
    end

    local guardCount=activeGuardedRecoveryCount(picture)
    if guardCount>0 then
        local guardView=supportView(self,picture,{followerBoundaryKnowledge={},opposedCorridorKnowledge={},spatialConstraintKnowledge={}},"GUARDED_RECOVERY_ONLY")
        local guard=self.liveSupport:attach(guardView,snapshot)
        local guardMode=modeOf(guard)
        local guardStatus=self.liveSupport:getLastStatus()
        if guardMode=="GUARDED_RECOVERY_D0123" then
            appendSupported(state,guard,"GUARDED_RECOVERY","guarded-recovery",1)
        elseif type(guardStatus)=="string" and string.find(guardStatus,"MULTIPLE_ACTIVE_GUARDED_RECOVERY_CONTEXTS",1,true) then
            passiveFailClosed(self,picture,snapshot,state,"GUARDED_RECOVERY_FAIL_CLOSED",guardStatus,1)
        end
    end

    local forwardCount=forwardRelationshipCount(picture)
    if forwardCount==1 then
        local forwardView=supportView(self,picture,{followerBoundaryKnowledge={},opposedCorridorKnowledge={},guardedRecoveryKnowledge={}},"FORWARD_INTERSECTION_ONLY")
        local forward=self.liveSupport:attach(forwardView,snapshot)
        if modeOf(forward)=="D0146_RESOLUTION_SPACE_REGULATION" then
            appendSupported(state,forward,"FORWARD_INTERSECTION","forward-intersection",1)
        end
    elseif forwardCount>1 then
        passiveFailClosed(self,picture,snapshot,state,"FORWARD_INTERSECTION_FAIL_CLOSED","MULTIPLE_FORWARD_INTERSECTION_CONTEXTS",1)
    end

    local actionSpaceGroups=0
    local relationOrdinal=0
    for _,relation in ipairs(opposedViewRelations(picture)) do
        relationOrdinal=relationOrdinal+1
        local relationView=supportView(self,picture,{followerBoundaryKnowledge={},spatialConstraintKnowledge={},guardedRecoveryKnowledge={},opposedCorridorKnowledge={relation}},"ONE_OPPOSED_RELATIONSHIP")
        local supported=self.liveSupport:attach(relationView,snapshot)
        local mode=modeOf(supported)
        if mode=="D0146_COOPERATIVE_PASSAGE_STEP2_TEST" then
            appendSupported(state,supported,"PASSAGE","passage:"..tostring(relation.identity),relationOrdinal)
        elseif mode=="D0146_RESOLUTION_SPACE_REGULATION" then
            actionSpaceGroups=actionSpaceGroups+1
            appendSupported(state,supported,"ACTION_SPACE","action-space:"..tostring(relation.identity),relationOrdinal)
        end
    end
    if actionSpaceGroups>1 then
        passiveFailClosed(self,picture,snapshot,state,"ACTION_SPACE_FAIL_CLOSED","MULTIPLE_D0146_ACTION_SPACE_CONSERVATION_CONTEXTS",1)
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
        if (a.legacyOrdinal or 0)~=(b.legacyOrdinal or 0) then return (a.legacyOrdinal or 0)<(b.legacyOrdinal or 0) end
        return tostring(a.groupKey)<tostring(b.groupKey)
    end)

    baseValues.identity=self.identities:issue("PICTURE")
    baseValues.epoch=self.epochs:next()
    baseValues.representationFitness=state.representationFitness
    baseValues.provenance={source="ProspectiveDecisionPortfolioSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="CANDIDATE_ENUMERATION_ONLY"}
    baseValues.candidateSupportEvidence={
        complete=true,
        supportBoundary={
            mode="PROSPECTIVE_DECISION_PORTFOLIO",supportedCandidateClasses=capabilities,physicalCapabilitiesImplemented=true,
            controlAuthority="SELECTED_GROUP_SUPPORT_BOUNDARY_ONLY",boundedScope="FRESH_INDEPENDENT_CANDIDATE_SUPPORT_GROUPS",
            groups=state.groups,decisionPolicy={kind=OuttaMyWay.ProspectivePortfolioDecisionPolicy.KIND},
            incumbentLifecycleCompetition=false,lowerPrecedenceConstraintFallback=false
        },
        candidateSpecifications=state.specifications,
        provenance={source="ProspectiveDecisionPortfolioSupport",observationSnapshotId=snapshot.identity,groupCount=#state.groups}
    }
    self.publishedCount=self.publishedCount+1
    self.lastStatus="PROSPECTIVE_DECISION_PORTFOLIO_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(baseValues)
end

function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end
