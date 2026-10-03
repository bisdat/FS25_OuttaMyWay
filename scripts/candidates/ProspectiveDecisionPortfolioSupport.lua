--- Composes complete fresh Candidate-support groups into one Candidate-support-enriched Decision picture.
-- Specification Jurisdictions: `CANDIDATE_SUPPORT`, `BOUNDED_BYPASS`

OuttaMyWay.ProspectiveDecisionPortfolioSupport={}
local Support=OuttaMyWay.ProspectiveDecisionPortfolioSupport
Support.__index=Support

local function modeOfGroup(group)
    local boundary=group and group.supportBoundary or nil
    return type(boundary)=="table" and boundary.mode or nil
end

local function candidateMetadata(specification,family,groupKey,ordinal,boundary,extra)
    local evidence=specification.evidenceBasis or {}
    local bridge=evidence.compositeRegulationBridge or evidence.cooperativePassageBridge or evidence.followerBoundaryBridge or evidence.actionSpaceRegulationBridge or evidence.obstructionRelocationBridge or evidence.blockedWorkerRecoveryBridge or {}
    local metadata={
        groupKey=groupKey,family=family,enumerationOrdinal=ordinal,supportBoundary=boundary,
        conflictIdentity=bridge.conflictIdentity,relocationKey=bridge.relocationKey,recoveryKey=bridge.recoveryKey,
        admissionKind=bridge.admissionKind,initialSeparationM=bridge.initialSeparationM,
        leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        assemblyIds=bridge.assemblyIds,existingCommitmentId=bridge.existingCommitmentId or evidence.existingCommitmentId
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
    local bridge=evidence.compositeRegulationBridge or evidence.cooperativePassageBridge or evidence.followerBoundaryBridge or evidence.actionSpaceRegulationBridge or evidence.obstructionRelocationBridge or evidence.blockedWorkerRecoveryBridge or {}
    local descriptor={
        groupKey=groupKey,family=family,enumerationOrdinal=ordinal,supportBoundary=boundary,
        conflictIdentity=bridge.conflictIdentity,relocationKey=bridge.relocationKey,
        admissionKind=bridge.admissionKind,initialSeparationM=bridge.initialSeparationM,
        leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        assemblyIds=bridge.assemblyIds,existingCommitmentId=bridge.existingCommitmentId or evidence.existingCommitmentId
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
    -- One Decision Picture may contain more than one fail-closed support scope.
    -- Namespace each projected passive expression before Candidate Space
    -- materialisation; ordinary passive support keeps its own stable key.
    for index,specification in ipairs(group and group.candidateSpecifications or {}) do
        specification.referenceKey="passive-fail-closed:"..tostring(targetPictureId)
            ..":"..string.lower(tostring(family))..":"..tostring(reason)
            ..":"..tostring(ordinal)..":"..tostring(#state.groups+index)
    end
    appendGroup(state,group,family,"fail-closed:"..string.lower(family)..":"..tostring(reason),ordinal,{failClosedReason=reason})
end

local function playerControlledObstructions(picture)
    local result={}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.causalObstructionKnowledge or {}) do
        if relation.blockerClassification=="NON_ACTIVE_PLAYER_CONTROLLED"
            and relation.positiveDissolution~=true and relation.positiveSupersession~=true then
            result[#result+1]=relation
        end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

local function sharedCornerSituations(picture)
    local result={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        local corner=knowledge.cornerKnowledge or {}
        for _,situation in OuttaMyWay.ValueRecord.ipairs(corner.sharedCornerSituations or {}) do
            if situation.competingDemand==true and type(situation.identity)=="string" then
                result[#result+1]=situation
            end
        end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

local function pairKey(a,b)
    local first,second=tostring(a),tostring(b)
    if second<first then first,second=second,first end
    return first.."|"..second
end

local function followerUnorderedPairKey(bridge)
    if type(bridge)~="table" then return nil end
    if type(bridge.leaderAssemblyId)~="string" or type(bridge.followerAssemblyId)~="string" then return nil end
    return pairKey(bridge.leaderAssemblyId,bridge.followerAssemblyId)
end

local function sharedCategory2Situations(picture)
    local result={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,situation in OuttaMyWay.ValueRecord.ipairs(knowledge.sharedCategory2Demands or {}) do
            if type(situation.identity)=="string"
                and situation.positiveDissolution~=true
                and (situation.competingDemand==true or situation.currentEvidenceState=="WAITING_FOR_EVIDENCE") then
                result[#result+1]=situation
            end
        end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

local function sharedCategory2PairSet(situations)
    local result={}
    for _,situation in OuttaMyWay.ValueRecord.ipairs(situations or {}) do
        result[pairKey(situation.subjectAssemblyId,situation.otherAssemblyId)]=true
    end
    return result
end

local function incumbentSharedCategory2Situation(situations)
    local match=nil
    for _,situation in OuttaMyWay.ValueRecord.ipairs(situations or {}) do
        if type(situation.incumbentCommitmentId)=="string"
            and type(situation.incumbentRegulatedAssemblyId)=="string" then
            if match~=nil and match.identity~=situation.identity then
                return nil,"MULTIPLE_INCUMBENT_SHARED_CATEGORY_2_SITUATIONS"
            end
            match=situation
        end
    end
    if match==nil then return nil,"INCUMBENT_SHARED_CATEGORY_2_SITUATION_UNAVAILABLE" end
    return match,nil
end

local function currentResponsibilityKey(picture,commitmentId)
    if type(commitmentId)~="string" then return nil end
    for _,context in OuttaMyWay.ValueRecord.ipairs(picture.commitmentContext or {}) do
        if context.commitmentId==commitmentId then
            local basis=context.governingBasis
            return type(basis)=="table" and basis.responsibilityKey or nil
        end
    end
    return nil
end

local function followerGroupContext(group)
    local specification=group and group.candidateSpecifications and group.candidateSpecifications[1] or nil
    local evidence=specification and specification.evidenceBasis or nil
    local bridge=evidence and evidence.followerBoundaryBridge or nil
    if type(bridge)~="table" or type(bridge.pairKey)~="string" then return nil,nil end
    return specification,bridge
end

local function mergeRepresentationRequirements(target,source)
    local seen={}
    for _,item in ipairs(target.requirements or {}) do
        if type(item.representationId)=="string" then seen[item.representationId]=true end
    end
    for _,item in ipairs(source.requirements or {}) do
        if type(item.representationId)~="string" or seen[item.representationId]~=true then
            target.requirements[#target.requirements+1]=item
            if type(item.representationId)=="string" then seen[item.representationId]=true end
        end
    end
end

local function mergeGroupFitness(first,second)
    local result,seen={},{}
    for _,group in ipairs({first,second}) do
        for _,fitness in ipairs(group and group.representationFitness or {}) do
            local id=fitness.representationId
            if type(id)~="string" or seen[id]~=true then
                result[#result+1]=fitness
                if type(id)=="string" then seen[id]=true end
            end
        end
    end
    return result
end

local function appendUniqueValue(values,value)
    if type(value)~="string" then return end
    for _,existing in ipairs(values or {}) do if existing==value then return end end
    values[#values+1]=value
end

local function composeFollowerCategory2Group(picture,follower,category2,situation,targetPictureId,targetEpoch)
    if modeOfGroup(follower)~="FOLLOWER_BOUNDARY" or modeOfGroup(category2)~="SHARED_CATEGORY_2_DEMAND" then return nil,"NOT_COMPOSABLE" end
    local followerSpecification,followerBridge=followerGroupContext(follower)
    if followerSpecification==nil then return nil,"FOLLOWER_TRIGGER_UNAVAILABLE" end
    local situationPair=pairKey(situation.subjectAssemblyId,situation.otherAssemblyId)
    local followerPair=followerUnorderedPairKey(followerBridge)
    local samePair=followerPair~=nil and followerPair==situationPair

    local existingCommitmentId=followerBridge.existingCommitmentId
    for _,specification in ipairs(category2.candidateSpecifications or {}) do
        local bridge=specification.evidenceBasis and specification.evidenceBasis.actionSpaceRegulationBridge or nil
        if type(bridge)=="table" and type(bridge.existingCommitmentId)=="string" then
            if existingCommitmentId~=nil and existingCommitmentId~=bridge.existingCommitmentId then
                return nil,"COMPOSED_REGULATION_EXISTING_COMMITMENT_CONFLICT"
            end
            existingCommitmentId=bridge.existingCommitmentId
        end
    end
    if not samePair and type(existingCommitmentId)~="string" then
        return nil,"SHARED_PROTECTED_DEMAND_REQUIRES_CURRENT_REGULATION"
    end

    local governingRequirementKey=currentResponsibilityKey(picture,existingCommitmentId)
        or ("pairwise-regulation:"..tostring(followerBridge.operationId)..":"..tostring(followerBridge.pairKey))

    local specifications={}
    for _,specification in ipairs(category2.candidateSpecifications or {}) do
        local evidence=specification.evidenceBasis or {}
        local actionBridge=evidence.actionSpaceRegulationBridge
        local crossPairCompatible=not samePair
            and type(actionBridge)=="table"
            and actionBridge.admissionKind=="SHARED_CATEGORY_2_DEMAND"
            and actionBridge.protectedAssemblyId==followerBridge.leaderAssemblyId
            and actionBridge.regulatedAssemblyId~=followerBridge.followerAssemblyId
            and actionBridge.operationId==followerBridge.operationId
            and actionBridge.existingCommitmentId==existingCommitmentId
            and (followerBridge.action=="APPLY"
                or (followerBridge.action=="RETIRE" and followerBridge.existingCommitmentId==existingCommitmentId))
        local roleCompatible=(samePair and (
                followerBridge.action=="RETIRE"
                or (type(actionBridge)=="table"
                    and actionBridge.regulatedAssemblyId==followerBridge.followerAssemblyId
                    and actionBridge.protectedAssemblyId==followerBridge.leaderAssemblyId)))
            or crossPairCompatible

        if roleCompatible then
            local compositionScope=samePair and "SAME_PAIR" or "SHARED_PROTECTED_DEMAND"
            actionBridge.governingRequirementKey=governingRequirementKey
            actionBridge.existingCommitmentId=existingCommitmentId
            followerBridge.governingRequirementKey=governingRequirementKey
            followerBridge.existingCommitmentId=existingCommitmentId
            evidence.governingBasis.responsibilityKey=governingRequirementKey
            evidence.maintainsExistingCommitment=existingCommitmentId~=nil
            if type(evidence.withinGroupTrafficPreference)=="table" then
                local preference=evidence.withinGroupTrafficPreference
                preference.governingRequirementKey=governingRequirementKey
                for _,record in pairs(preference.exhaustionEvidence or {}) do
                    if type(record)=="table" then record.governingRequirementKey=governingRequirementKey end
                end
            end

            evidence.followerBoundaryBridge=followerBridge
            evidence.compositeRegulationBridge={
                architecture="COMPOSED_REGULATION_TRIGGERS",compositionScope=compositionScope,
                pairKey=followerBridge.pairKey,operationId=followerBridge.operationId,
                leaderAssemblyId=followerBridge.leaderAssemblyId,followerAssemblyId=followerBridge.followerAssemblyId,
                regulatedAssemblyId=actionBridge.regulatedAssemblyId,protectedAssemblyId=actionBridge.protectedAssemblyId,
                incumbentRegulatedAssemblyId=actionBridge.regulatedAssemblyId,
                sharedProtectedAssemblyId=actionBridge.protectedAssemblyId,
                conflictIdentity=actionBridge.conflictIdentity,admissionKind=actionBridge.admissionKind,
                existingCommitmentId=existingCommitmentId,governingRequirementKey=governingRequirementKey,
                followerAction=followerBridge.action,
                assemblyIds={followerBridge.leaderAssemblyId,followerBridge.followerAssemblyId},
                triggerKinds={"FOLLOWER_BOUNDARY","SHARED_CATEGORY_2_DEMAND"}
            }

            if not samePair then
                specification.subject=specification.subject or {}
                specification.subject.assemblyIds=specification.subject.assemblyIds or {}
                appendUniqueValue(specification.subject.assemblyIds,actionBridge.regulatedAssemblyId)
                appendUniqueValue(specification.subject.assemblyIds,followerBridge.followerAssemblyId)

                evidence.progressActuationOwnership=evidence.progressActuationOwnership or {assemblyIds={}}
                evidence.progressActuationOwnership.assemblyIds=evidence.progressActuationOwnership.assemblyIds or {}
                appendUniqueValue(evidence.progressActuationOwnership.assemblyIds,actionBridge.regulatedAssemblyId)
                appendUniqueValue(evidence.progressActuationOwnership.assemblyIds,followerBridge.followerAssemblyId)

                local composition=evidence.effectiveActuationComposition
                if type(composition)=="table" then
                    composition.relevantAssemblyIds=composition.relevantAssemblyIds or {}
                    appendUniqueValue(composition.relevantAssemblyIds,actionBridge.protectedAssemblyId)
                    appendUniqueValue(composition.relevantAssemblyIds,actionBridge.regulatedAssemblyId)
                    appendUniqueValue(composition.relevantAssemblyIds,followerBridge.followerAssemblyId)
                    composition.entries=composition.entries or {}
                    local followerEntry=false
                    for _,entry in ipairs(composition.entries) do
                        if entry.assemblyId==followerBridge.followerAssemblyId
                            and entry.capability=="REGULATE_SPEED" then followerEntry=true break end
                    end
                    if not followerEntry then
                        composition.entries[#composition.entries+1]={
                            assemblyId=followerBridge.followerAssemblyId,commitmentId=existingCommitmentId,
                            capability="REGULATE_SPEED",effectClass="SPEED_LIMIT_OR_HOLD",progressActuation=true
                        }
                    end
                end
            end

            specification.referenceKey="composed-regulation:"..tostring(compositionScope)
                ..":"..tostring(followerBridge.pairKey)..":"..tostring(actionBridge.regulatedAssemblyId)
            specification.purpose={
                kind=samePair and "PAIRWISE_REGULATION_TRIGGER_COMPOSITION"
                    or "SHARED_PROTECTED_DEMAND_TRIGGER_COMPOSITION",
                result="PRESERVE_TEMPORAL_ORDERING_WHILE_ANY_ADMITTED_TRIGGER_REMAINS_CURRENT"
            }
            specification.expectedEffect.composedRegulationTriggers=true
            specification.expectedEffect.multipleCompatibleSpeedCeilings=true
            specification.obligationsCreated=specification.obligationsCreated or {}
            for _,obligation in ipairs(followerSpecification.obligationsCreated or {}) do
                specification.obligationsCreated[#specification.obligationsCreated+1]=obligation
            end
            mergeRepresentationRequirements(specification.representationFitness,followerSpecification.representationFitness or {requirements={}})
            for _,condition in ipairs(followerSpecification.invalidationConditions or {}) do
                specification.invalidationConditions[#specification.invalidationConditions+1]=condition
            end
            specifications[#specifications+1]=specification
        end
    end
    if #specifications==0 then
        return nil,samePair and "COMPOSED_REGULATION_TRIGGER_ROLE_CONFLICT"
            or "SHARED_PROTECTED_DEMAND_TRIGGER_ROLE_CONFLICT"
    end
    return {
        supportBoundary={
            mode="COMPOSED_REGULATION_TRIGGERS",supportedCandidateClasses={"REGULATE_SPEED"},
            physicalCapabilitiesImplemented=true,controlAuthority="COMPOSED_SPEED_CEILINGS",
            boundedScope=samePair and "SAME_PAIR_FOLLOWER_BOUNDARY_OR_SHARED_CATEGORY_2_TEMPORAL_COORDINATION"
                or "SHARED_PROTECTED_DEMAND_WITH_PARTICIPANT_SPECIFIC_REGULATION",
            decisionPolicy={kind=OuttaMyWay.WithinGroupTrafficDecisionPolicy.KIND,governingRequirementKey=governingRequirementKey}
        },
        candidateSpecifications=specifications,
        representationFitness=mergeGroupFitness(follower,category2),
        provenance={
            source="ProspectiveDecisionPortfolioSupport",targetOperationalPictureId=targetPictureId,targetEpoch=targetEpoch,
            candidateSupportProjection=true,
            authority=samePair and "SAME_PAIR_REGULATION_TRIGGER_COMPOSITION" or "SHARED_PROTECTED_DEMAND_COMPOSITION",
            pairKey=followerBridge.pairKey,sharedCategory2Identity=situation.identity
        }
    },nil
end

local function forwardRelationshipCount(picture,excludedPairKeys)
    local count=0
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relation in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            local key=pairKey(relation.subjectAssemblyId,relation.otherAssemblyId)
            if relation.classification=="FORWARD_INTERSECTION" and relation.actionable==true
                and relation.incumbentRelationship==nil and type(relation.actionSpaceConservation)=="table"
                and not (type(excludedPairKeys)=="table" and excludedPairKeys[key]==true) then count=count+1 end
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

function Support.new(identityRegistry,epochSequence,obstructionSupport,recoverySupport,liveSupport,passiveSupport,bypassSupport)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,obstructionSupport=obstructionSupport,recoverySupport=recoverySupport,liveSupport=liveSupport,passiveSupport=passiveSupport,bypassSupport=bypassSupport,publishedCount=0,lastStatus="INACTIVE"},Support)
end

function Support:publishDecisionPicture(picture,snapshot)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
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

    local playerControlled=playerControlledObstructions(picture)
    if #playerControlled==1 then
        local group,reason=self.liveSupport:buildProjectedGroup(
            picture,snapshot,{kind="PLAYER_CONTROLLED_OBSTRUCTION",relationshipIdentity=playerControlled[1].identity},targetPictureId,targetEpoch)
        if modeOfGroup(group)=="ACTION_SPACE_REGULATION" then
            appendGroup(state,group,"PLAYER_CONTROLLED_OBSTRUCTION","player-controlled-obstruction:"..tostring(playerControlled[1].identity),1)
        elseif reason~=nil then
            passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"PLAYER_CONTROLLED_OBSTRUCTION_FAIL_CLOSED",reason,1)
        end
    elseif #playerControlled>1 then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,
            "PLAYER_CONTROLLED_OBSTRUCTION_FAIL_CLOSED","MULTIPLE_PLAYER_CONTROLLED_OBSTRUCTION_CONTEXTS",1)
    end

    local recovery,recoveryReason=nil,nil
    if self.recoverySupport~=nil then
        recovery,recoveryReason=self.recoverySupport:buildFreshProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    end
    if recovery~=nil then
        appendGroup(state,recovery,"RECOVERY","blocked-worker-recovery",1)
    elseif recoveryReason=="MULTIPLE_RECOVERY_STALLS_REQUIRE_COMPARATOR" then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"RECOVERY_FAIL_CLOSED",recoveryReason,1)
    end

    local bypass=self.bypassSupport and self.bypassSupport:buildFreshProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    if bypass~=nil then appendGroup(state,bypass,"BOUNDED_BYPASS","bounded-bypass",1) end

    local follower,followerReason=self.liveSupport:buildProjectedGroup(picture,snapshot,{kind="FOLLOWER_BOUNDARY"},targetPictureId,targetEpoch)
    local followerFamily=nil
    if modeOfGroup(follower)=="FOLLOWER_BOUNDARY" then
        followerFamily="FOLLOWER"
        local spec=follower.candidateSpecifications and follower.candidateSpecifications[1] or nil
        local action=spec and spec.evidenceBasis and spec.evidenceBasis.followerBoundaryBridge and spec.evidenceBasis.followerBoundaryBridge.action or nil
        if action=="RETIRE" then followerFamily="FOLLOWER_RETIRE" end
    elseif type(followerReason)=="string" and string.find(followerReason,"MULTIPLE_SIMULTANEOUS_FOLLOWER_BOUNDARY_CONTEXTS",1,true) then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"FOLLOWER_FAIL_CLOSED",followerReason,1)
    end

    local sharedCorners=sharedCornerSituations(picture)
    if #sharedCorners==1 then
        local corner,cornerReason=self.liveSupport:buildProjectedGroup(
            picture,snapshot,{kind="CORNER_RIGHT_OF_WAY",sharedCornerIdentity=sharedCorners[1].identity},targetPictureId,targetEpoch)
        if modeOfGroup(corner)=="CORNER_RIGHT_OF_WAY" then
            appendGroup(state,corner,"CORNER_RIGHT_OF_WAY","corner-right-of-way:"..tostring(sharedCorners[1].identity),1)
        elseif cornerReason~=nil then
            passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"CORNER_FAIL_CLOSED",cornerReason,1)
        end
    elseif #sharedCorners>1 then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,"CORNER_FAIL_CLOSED","MULTIPLE_SHARED_CORNER_SITUATIONS",1)
    end

    local sharedCategory2=sharedCategory2Situations(picture)
    local category2Pairs=sharedCategory2PairSet(sharedCategory2)
    local category2,category2Reason=nil,nil
    local category2Situation=nil
    local category2FreshAmbiguity=nil

    if #sharedCategory2==1 then
        category2Situation=sharedCategory2[1]
    elseif #sharedCategory2>1 then
        local incumbent,incumbentReason=incumbentSharedCategory2Situation(sharedCategory2)
        if incumbent~=nil then
            category2Situation=incumbent
            category2FreshAmbiguity="MULTIPLE_FRESH_SHARED_CATEGORY_2_SITUATIONS_WITH_INCUMBENT"
        else
            category2Reason=incumbentReason=="MULTIPLE_INCUMBENT_SHARED_CATEGORY_2_SITUATIONS"
                and incumbentReason or "MULTIPLE_SHARED_CATEGORY_2_SITUATIONS"
        end
    end

    if category2Situation~=nil then
        local _,followerBridge=followerGroupContext(follower)
        local compatibleExistingCommitmentId=nil
        if followerBridge~=nil and followerUnorderedPairKey(followerBridge)==pairKey(
            category2Situation.subjectAssemblyId,category2Situation.otherAssemblyId) then
            compatibleExistingCommitmentId=followerBridge.existingCommitmentId
        end
        category2,category2Reason=self.liveSupport:buildProjectedGroup(
            picture,snapshot,{
                kind="SHARED_CATEGORY_2_DEMAND",sharedCategory2Identity=category2Situation.identity,
                compatibleExistingCommitmentId=compatibleExistingCommitmentId
            },targetPictureId,targetEpoch)
    end

    if category2FreshAmbiguity~=nil then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,
            "CATEGORY_2_BOUNDARY_DEMAND_FAIL_CLOSED",category2FreshAmbiguity,1)
    elseif category2Situation==nil and category2Reason~=nil then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,
            "CATEGORY_2_BOUNDARY_DEMAND_FAIL_CLOSED",category2Reason,1)
    end

    local composed,compositionReason=nil,nil
    if followerFamily~=nil and modeOfGroup(category2)=="SHARED_CATEGORY_2_DEMAND" and category2Situation~=nil then
        composed,compositionReason=composeFollowerCategory2Group(
            picture,follower,category2,category2Situation,targetPictureId,targetEpoch)
    end
    if composed~=nil then
        local _,bridge=followerGroupContext(follower)
        appendGroup(state,composed,"COMPOSED_REGULATION",
            "composed-regulation:"..tostring(bridge and bridge.pairKey or category2Situation.identity),1)
    elseif compositionReason=="COMPOSED_REGULATION_TRIGGER_ROLE_CONFLICT"
        or compositionReason=="COMPOSED_REGULATION_EXISTING_COMMITMENT_CONFLICT"
        or compositionReason=="SHARED_PROTECTED_DEMAND_TRIGGER_ROLE_CONFLICT" then
        passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,
            "COMPOSED_REGULATION_FAIL_CLOSED",compositionReason,1)
    else
        if followerFamily~=nil then appendGroup(state,follower,followerFamily,"follower",1) end
        if modeOfGroup(category2)=="SHARED_CATEGORY_2_DEMAND" then
            appendGroup(state,category2,"CATEGORY_2_BOUNDARY_DEMAND",
                "category-2-boundary-demand:"..tostring(category2Situation and category2Situation.identity or "UNKNOWN"),1)
        elseif category2Reason~=nil and category2FreshAmbiguity==nil and category2Situation~=nil then
            passiveFailClosed(self,picture,snapshot,state,targetPictureId,targetEpoch,
                "CATEGORY_2_BOUNDARY_DEMAND_FAIL_CLOSED",category2Reason,1)
        end
    end

    local forwardCount=forwardRelationshipCount(picture,category2Pairs)
    if forwardCount==1 then
        local forward=self.liveSupport:buildProjectedGroup(
            picture,snapshot,{kind="FORWARD_INTERSECTION",excludedPairKeys=category2Pairs},targetPictureId,targetEpoch)
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
        return self.passiveSupport:publishDecisionPicture(picture,snapshot)
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
            incumbentLifecycleCompetition=false,
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
