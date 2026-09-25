--- Constructs live-traffic Candidate support including Cooperative Passage purpose-local Candidate semantics.
-- Specification Jurisdictions: `CANDIDATE_SUPPORT`, `COOPERATIVE_PASSAGE`

-- Live traffic Candidate Support consumes Situation-owned encounter meaning and
-- publishes current Follower Boundary, Action-Space Regulation and Cooperative
-- Passage candidate contracts. Cooperative Passage is a REPOSITION Candidate;
-- it does not re-derive encounter meaning or invent King/Refuge or unilateral
-- Yield/Progress roles. Historical donor identity has no production authority.

OuttaMyWay.LiveTrafficCandidateSupport = {}
local Support = OuttaMyWay.LiveTrafficCandidateSupport
Support.__index = Support

-- Diagnostic Publication Window != Passage Search Horizon.
local COOPERATIVE_PASSAGE_CLEARANCE_TRACE_MAX_SEPARATION_M = 40.0

local publication=OuttaMyWay.LogPublication.origin("CANDIDATE_SUPPORT")
local function logInfo(code,formatText,...)
    return publication:info("DIAGNOSTIC",code,formatText,...)
end

function Support.new(identityRegistry,epochSequence,passiveSupport)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,passiveSupport=passiveSupport,publishedCount=0,lastStatus="PASSIVE",lastCooperativeTraceKey=nil,lastPassageRejectionTraceKey=nil,projectedPassageRejectionTraceKeys={}},Support)
end

-- Candidate Support status is observational and is reset when the live map/runtime
-- context is reinitialised.
function Support:resetStatus() self.lastStatus="PASSIVE" end
function Support:getLastStatus() return self.lastStatus end

-- Cooperative Passage Candidate expression.  Established conflict meaning is
-- consumed, not re-derived. LocalPassagePlanner owns the progressive local
-- search and returns one sufficient Arrangement/Guide plus its bounded
-- mechanical Representation Fitness requirements.
local function cooperativePassageRequirementKey(plan)
    return "cooperative-passage:"..tostring(plan.conflictIdentity)
end

-- Job Episode Dependency Collapse provenance is pair-specific. Current Pair
-- Assessment Scope supplies exact current Job Episodes; no persistent generic
-- pair identity is required.
local function currentPairDependency(pictureValues,subjectAssemblyId,otherAssemblyId,preferredPairReferenceKey)
    for _,pair in OuttaMyWay.ValueRecord.ipairs(pictureValues.currentPairAssessmentScope or {}) do
        local samePair=(pair.subjectAssemblyId==subjectAssemblyId and pair.otherAssemblyId==otherAssemblyId)
            or (pair.subjectAssemblyId==otherAssemblyId and pair.otherAssemblyId==subjectAssemblyId)
        if samePair and (preferredPairReferenceKey==nil or pair.pairReferenceKey==preferredPairReferenceKey) then
            if type(pair.subjectJobEpisodeId)~="string" or type(pair.otherJobEpisodeId)~="string" then return pair.pairReferenceKey,nil,nil end
            local episodes={pair.subjectJobEpisodeId,pair.otherJobEpisodeId}
            table.sort(episodes,function(a,b) return tostring(a)<tostring(b) end)
            return pair.pairReferenceKey,episodes,{[pair.subjectAssemblyId]=pair.subjectJobEpisodeId,[pair.otherAssemblyId]=pair.otherJobEpisodeId}
        end
    end
    return preferredPairReferenceKey,nil,nil
end

local function cooperativePassageBandExhaustion(pictureId,governingRequirementKey,capability,reason)
    return {
        result="PASS",operationalPictureId=pictureId,governingRequirementKey=governingRequirementKey,
        capability=capability,reason=reason,
        evidence={establishedOpposedCorridorConflict=true,sufficientLocalPassageArrangement=true,passagePresumption=true},
        provenance={source="LiveTrafficCandidateSupport",authority="COOPERATIVE_PASSAGE_PREFERENCE_EXHAUSTION"}
    }
end

local function makeCooperativePassageCandidate(pictureId,pictureValues,plan,governingRequirementKey)
    local compositionEntries={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(plan.assemblyIds or {}) do
        compositionEntries[#compositionEntries+1]={assemblyId=assemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="MOVE",progressActuation=true}
    end
    table.sort(compositionEntries,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    local requirements={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(plan.representationFitnessIds or {}) do requirements[#requirements+1]={representationId=id,acceptedStates={"FIT_FOR_LIMITED_HORIZON","CURRENTLY_FIT"}} end
    local dependentPairReferenceKey,dependentJobEpisodeIds,dependentJobEpisodeIdByAssembly=currentPairDependency(pictureValues,plan.subjectAssemblyId,plan.otherAssemblyId,plan.pairReferenceKey)
    local passageLegObligations={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(plan.assemblyIds or {}) do
        local jobToken=assemblyId==plan.subjectAssemblyId and plan.subjectJobToken or plan.otherJobToken
        local jobEpisodeId=dependentJobEpisodeIdByAssembly and dependentJobEpisodeIdByAssembly[assemblyId] or nil
        passageLegObligations[#passageLegObligations+1]={
            origin={kind="OTM_MATERIAL_DISPLACEMENT",decision="COOPERATIVE_PASSAGE",conflictIdentity=plan.conflictIdentity,passageLegAssemblyId=assemblyId},
            basis={kind="COOPERATIVE_PASSAGE_LEG",assemblyId=assemblyId,originalAssemblyIds=plan.assemblyIds,jobEpisodeId=jobEpisodeId,jobToken=jobToken},
            requiredOutcome={kind="COOPERATIVE_PASSAGE_LEG_HANDED_BACK",assemblyId=assemblyId},
            requiredAuthority={capabilities={"REPOSITION","RESTORE_CONFIGURATION","HANDOVER_TO_GIANTS"}},
            evidenceContract={kind="PARTICIPANT_PASSAGE_DEBT_DISCHARGED_THEN_GIANTS_HANDOFF_OR_POSITIVE_BASIS_CESSATION"},
            ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true
        }
    end

    return {
        referenceKey="cooperative-passage:"..tostring(plan.conflictIdentity),
        purpose={kind="COOPERATIVE_PASSAGE",result="RESOLVE_ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_BY_SUFFICIENT_LOCAL_PASSAGE"},
        subject={assemblyIds=plan.assemblyIds},capability="REPOSITION",
        expectedEffect={physicalChange=true,jointReposition=true,passageArrangementId=plan.passageArrangement and plan.passageArrangement.identity,passageGuideId=plan.passageGuide and plan.passageGuide.identity,passageCapableTheatre=true,bothParticipantsForwardThroughEncounter=true,sameJobRestorationRequired=true},
        evidenceBasis={
            governingBasis={responsibilityKey=governingRequirementKey,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active,dependentPairReferenceKey=dependentPairReferenceKey,dependentJobEpisodeIds=dependentJobEpisodeIds},
            progressActuationOwnership={assemblyIds=plan.assemblyIds},
            effectiveActuationComposition={identity="cooperative-passage-composition:"..tostring(plan.conflictIdentity)..":"..pictureId,epoch=pictureValues.epoch,relevantAssemblyIds=plan.assemblyIds,entries=compositionEntries},
            trafficPolicemanPreference={primaryResolution=true,governingRequirementKey=governingRequirementKey,exhaustionEvidence={
                CONTINUE_OBSERVATION=cooperativePassageBandExhaustion(pictureId,governingRequirementKey,"CONTINUE_OBSERVATION","Established conflict is already locally actionable and Candidate search found a sufficient supported passage expression"),
                REGULATE_SPEED=cooperativePassageBandExhaustion(pictureId,governingRequirementKey,"REGULATE_SPEED","Regulation preserves Action Space but does not itself resolve the Established opposed spatial incompatibility"),
                HOLD=cooperativePassageBandExhaustion(pictureId,governingRequirementKey,"HOLD","In-path Hold alone does not create a Stable Passing Relationship")
            }},
            cooperativePassageBridge={
                architecture="COOPERATIVE_PASSAGE",governingRequirementKey=governingRequirementKey,operationId=plan.operationId,
                conflictIdentity=plan.conflictIdentity,pairReferenceKey=plan.pairReferenceKey,
                assemblyIds=plan.assemblyIds,subjectAssemblyId=plan.subjectAssemblyId,otherAssemblyId=plan.otherAssemblyId,
                subjectReferenceKey=plan.subjectReferenceKey,otherReferenceKey=plan.otherReferenceKey,
                subjectJobToken=plan.subjectJobToken,otherJobToken=plan.otherJobToken,
                subjectStartX=plan.subjectStartX,subjectStartZ=plan.subjectStartZ,otherStartX=plan.otherStartX,otherStartZ=plan.otherStartZ,
                initialSeparationM=plan.separationM,trajectoryDot=plan.trajectoryDot,
                localPassageSpace=plan.localPassageSpace,passageCapableTheatre=plan.passageCapableTheatre,
                passageArrangement=plan.passageArrangement,passageGuide=plan.passageGuide,passageConfiguration=plan.passageConfiguration,
                passageEntry=plan.passageEntry,passageExcursion=plan.passageExcursion,progressiveSearch=plan.progressiveSearch,
                controlProfile=plan.controlProfile
            }
        },
        representationFitness={requirements=requirements},
        preconditions={evidenceContracts={},operatorCommandRequired=false,sameJobEpisodes=true,establishedOpposedCorridorConflict=true,sufficientLocalPassageArrangement=true,passageCapableTheatre=true,controlProfile=plan.controlProfile},
        invalidationConditions={{kind="JOB_EPISODE_CHANGE"},{kind="ESTABLISHED_CONFLICT_CHANGE"},{kind="PASSAGE_SUPPORT_LOSS"}},
        reversibility={physicalEffect=true,restoreParticipantBeforeLegRelease=true,passageReassessment=true},
        obligationsCreated=passageLegObligations,
        releaseImplications={releaseParticipantProgressAuthorityAfterLegTerminal=true,postHandoffObservationAuthority=false},
        uncertainty={"GENERIC_CURRENT_PHYSICAL_CONFLICT_IS_NOT_PASSAGE_CLEARANCE_AUTHORITY","GENERIC_NEGATIVE_CLEARANCE_AUTHORITY_NOT_CLAIMED","BOUNDARY_ENCROACHMENT_NOT_REQUIRED_BY_SELECTED_EXPRESSION","STATIC_OBSTACLE_EXCLUSION_BEYOND_ACTIVE_ASSEMBLIES_NOT_CLAIMED"},
        comparisonCost=plan.passageArrangement and tonumber(plan.passageArrangement.combinedLateralBurdenM) or 0
    }
end

-- Resolution-Space Conservation. Situation owns admission evidence and
-- temporary role assignment. Candidate does not re-derive raw GIANTS state.
-- Current Excursion can justify early Potential-conflict admission; an already
-- Established conflict may also justify Regulation when Local Passage Search
-- has not yet found a supported Passage expression.
local function actionSpaceRegulationRecord(picture)
    local actionable={}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        local action=relation.actionSpaceConservation
        if (relation.classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" or relation.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT") and type(action)=="table"
            and action.status=="REGULATE_SUPPORTED" and action.supported==true then
            actionable[#actionable+1]={relation=relation,action=action}
        end
    end
    table.sort(actionable,function(a,b)
        local sa=tonumber(a.action.separationM) or math.huge
        local sb=tonumber(b.action.separationM) or math.huge
        if math.abs(sa-sb)>0.001 then return sa<sb end
        return tostring(a.relation.identity)<tostring(b.relation.identity)
    end)
    if #actionable==0 then return nil,nil end
    if #actionable>1 then return nil,"MULTIPLE_ACTION_SPACE_REGULATION_CONTEXTS" end
    return actionable[1],nil
end

-- Forward Intersection geometry and temporal allocation are owned by Situation.
-- Candidate support only publishes the already-assessed bounded Regulation.
local function forwardIntersectionRecord(picture)
    local actionable={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relation in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if relation.classification=="FORWARD_INTERSECTION" and relation.actionable==true
                and relation.incumbentRelationship==nil and type(relation.actionSpaceConservation)=="table" then
                actionable[#actionable+1]={relation=relation,action=relation.actionSpaceConservation}
            end
        end
    end
    table.sort(actionable,function(a,b) return tostring(a.relation.identity)<tostring(b.relation.identity) end)
    if #actionable==0 then return nil,nil end
    if #actionable>1 then return nil,"MULTIPLE_FORWARD_INTERSECTION_CONTEXTS" end
    return actionable[1],nil
end

local function sharedCornerSituations(picture)
    local result={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        local corner=knowledge.cornerKnowledge or {}
        for _,situation in OuttaMyWay.ValueRecord.ipairs(corner.sharedCornerSituations or {}) do
            if situation.competingDemand==true and type(situation.identity)=="string"
                and type(situation.cornerKey)=="string" then
                result[#result+1]=situation
            end
        end
    end
    table.sort(result,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    return result
end

local function sharedCornerSituation(picture,identity)
    local matches=sharedCornerSituations(picture)
    if identity~=nil then
        for _,situation in OuttaMyWay.ValueRecord.ipairs(matches) do
            if situation.identity==identity then return situation,nil end
        end
        return nil,"SHARED_CORNER_SITUATION_NOT_FOUND"
    end
    if #matches==0 then return nil,nil end
    if #matches>1 then return nil,"MULTIPLE_SHARED_CORNER_SITUATIONS" end
    return matches[1],nil
end

local function cornerParticipantByAssembly(situation,assemblyId)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(situation and situation.participants or {}) do
        if participant.assemblyId==assemblyId then return participant end
    end
end

local function cornerActionItem(situation,regulated,protected)
    local relation={
        identity=situation.identity,operationId=situation.operationId,
        classification="SHARED_CORNER_COMPETING_DEMAND",relationshipStatus="POSITIVE",
        subjectAssemblyId=regulated.assemblyId,otherAssemblyId=protected.assemblyId,
        subjectReferenceKey=regulated.assemblyReferenceKey,otherReferenceKey=protected.assemblyReferenceKey,
        cooperativePassageEligible=false,cornerKey=situation.cornerKey,
        fieldWorldReferenceKey=situation.fieldWorldReferenceKey
    }
    local action={
        status="REGULATE_SUPPORTED",supported=true,admissionKind="CORNER_RIGHT_OF_WAY",
        regulatedAssemblyId=regulated.assemblyId,regulatedReferenceKey=regulated.assemblyReferenceKey,
        protectedAssemblyId=protected.assemblyId,protectedReferenceKey=protected.assemblyReferenceKey,
        regulationSpeedKmh=situation.regulationSpeedKmh,nativeUnrestrictedKmh=situation.regulationSpeedKmh,
        governingPurpose="PRESERVE_SHARED_CORNER_TEMPORARY_RIGHT_OF_WAY",
        reason="SHARED_CORNER_COMPETING_DEMAND_REQUIRES_TEMPORARY_RIGHT_OF_WAY_ALLOCATION",
        roleBasis="DECISION_ALLOCATED_SHARED_CORNER_RIGHT_OF_WAY",
        cornerKey=situation.cornerKey
    }
    return {relation=relation,action=action,cornerSituation=situation,
        regulatedParticipant=regulated,protectedParticipant=protected}
end

local function actionSpaceExistingCommitmentForRequirement(pictureValues,requirement)
    local contexts=pictureValues.commitmentContext or {}
    local match=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(contexts) do
        local basis=context.governingBasis
        if type(basis)=="table" and basis.responsibilityKey==requirement then
            if match~=nil then return nil,"MULTIPLE_ACTION_SPACE_REGULATION_COMMITMENTS" end
            match=context.commitmentId
        end
    end
    if match==nil and OuttaMyWay.ValueRecord.length(contexts)>0 then return nil,"OTHER_LIVE_COMMITMENT_CONTEXT_PRECLUDES_NEW_ACTION_SPACE_REGULATION_PURPOSE" end
    return match,nil
end

local function actionSpaceRegulationRepresentation(values,pictureId,item)
    local relation=item.relation
    local action=item.action
    local representationId="action-space-regulation:"..tostring(relation.identity)..":"..tostring(pictureId)
    if action.admissionKind=="CORNER_RIGHT_OF_WAY" then
        representationId=representationId..":"..tostring(action.regulatedAssemblyId)
    end
    values.representationFitness=values.representationFitness or {}
    values.representationFitness[#values.representationFitness+1]={
        representationId=representationId,
        assemblyId=action.regulatedAssemblyId,
        question=action.admissionKind=="FORWARD_INTERSECTION" and "FORWARD_INTERSECTION_TEMPORAL_REGULATION"
            or (action.admissionKind=="CORNER_RIGHT_OF_WAY" and "SHARED_CORNER_TEMPORARY_RIGHT_OF_WAY" or "ACTION_SPACE_REGULATION"),
        assessmentHorizon=action.admissionKind=="FORWARD_INTERSECTION" and "CURRENT_POSITIVELY_SUPPORTED_FIELD_BOUNDED_FORWARD_CONTINUATIONS"
            or (action.admissionKind=="CORNER_RIGHT_OF_WAY" and "CURRENT_SHARED_CORNER_INCUMBENCY_OR_PROSPECTIVE_ARRIVAL_EVIDENCE"
            or (action.admissionKind=="ESTABLISHED_CONFLICT" and "ESTABLISHED_OPPOSED_CONFLICT_INSIDE_LOCAL_PASSAGE_ENVELOPE" or "CURRENT_EXCURSION_PLUS_CURRENT_POSITIVE_CORRIDOR_CLOSURE_INSIDE_LOCAL_PASSAGE_ENVELOPE")),
        state="USABLE_WITH_UNCERTAINTY",
        claimPermissions={"REGULATE_SPEED_TO_PRESERVE_LOCAL_PASSAGE_ACTION_SPACE","ESCALATE_REALIZED_INSUFFICIENT_REGULATION_TO_ZERO_SPEED_HOLD"},
        coverage={complete=false,conservative=false},
        uncertainty={"RELATIONSHIP_MAY_CHANGE_BEFORE_PASSAGE_SUPPORT","NO_EVENTUAL_ROUTE_OR_PASSAGE_GEOMETRY_AUTHORITY","REGULATION_RATE_IS_IMPLEMENTATION_CALIBRATION"},
        validityDependencies=action.admissionKind=="FORWARD_INTERSECTION" and {"CURRENT_FIELD_BOUNDED_FORWARD_CONTINUATIONS","POSITIVE_FORWARD_INTERSECTION","POSITIVE_PROGRESS_RATES"}
            or (action.admissionKind=="CORNER_RIGHT_OF_WAY" and {"POSITIVE_STRUCTURAL_CORNER_FEATURE","CURRENT_CORNER_INCUMBENCY_OR_SUPPORTED_ARRIVAL_EVIDENCE","SHARED_CORNER_COMPETING_DEMAND"}
            or {"ACTIVE_OPPOSED_CORRIDOR_RELATIONSHIP","POSITIVE_CURRENT_CORRIDOR_SUPPORT","POSITIVE_CURRENT_CLOSURE","CURRENT_NATIVE_PROGRESS_RATE","LOCAL_PASSAGE_ENVELOPE"}),
        provenance={source=(action.admissionKind=="FORWARD_INTERSECTION" or action.admissionKind=="CORNER_RIGHT_OF_WAY") and "SpatialConstraintAssessment" or "TrajectoryConflictAssessment",layer="SITUATION_KNOWLEDGE",authority="REGULATION_CANDIDATE_SUPPORT",negativeClearanceAuthority=false}
    }
    return representationId
end

local function makeActionSpaceRegulationCandidate(pictureId,pictureValues,item,governingRequirementKey,existingCommitmentId,representationId)
    local relation=item.relation
    local action=item.action
    local forward=action.admissionKind=="FORWARD_INTERSECTION"
    local corner=action.admissionKind=="CORNER_RIGHT_OF_WAY"
    local fixed=forward or corner
    local protectedAssemblyId=action.protectedAssemblyId or action.excursionAssemblyId
    local protectedReferenceKey=action.protectedReferenceKey or action.excursionReferenceKey
    local dependentPairReferenceKey,dependentJobEpisodeIds=currentPairDependency(pictureValues,relation.subjectAssemblyId,relation.otherAssemblyId,nil)
    local composition={
        identity="action-space-regulation-composition:"..tostring(relation.identity)..":"..pictureId,epoch=pictureValues.epoch,
        relevantAssemblyIds={protectedAssemblyId,action.regulatedAssemblyId},
        entries={{assemblyId=action.regulatedAssemblyId,commitmentId=existingCommitmentId or "$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="SPEED_LIMIT_OR_HOLD",progressActuation=true}}
    }
    local referenceKey=(forward and "forward-intersection-regulation:" or "action-space-regulation:")..tostring(relation.identity)
    local purpose=forward and {kind="FORWARD_INTERSECTION_INTENT_REVELATION",result="PRESERVE_INTENT_REVELATION_TIME_UNTIL_FORWARD_INTERSECTION_DISSOLVES"}
        or {kind="ACTION_SPACE_REGULATION",result="PRESERVE_LOCAL_PASSAGE_ACTION_SPACE_UNTIL_SUPPORTED_PASSAGE_OR_POSITIVE_DISSOLUTION"}
    if corner then
        referenceKey="corner-right-of-way-regulation:"..tostring(relation.identity)..":"..tostring(action.regulatedAssemblyId)
        purpose={kind="CORNER_RIGHT_OF_WAY",result="PRESERVE_TEMPORARY_RIGHT_OF_WAY_UNTIL_SHARED_CORNER_COMPETING_DEMAND_DISSOLVES"}
    end
    return {
        referenceKey=referenceKey,
        purpose=purpose,
        subject={assemblyId=action.regulatedAssemblyId,assemblyIds={action.regulatedAssemblyId}},capability="REGULATE_SPEED",
        expectedEffect={physicalChange=true,speedCeilingOnly=true,giantsRoute=true,giantsSteering=true,giantsDirection=true,protectedParticipantUnrestricted=true,
            elasticProgressionEnvelope=not fixed,fixedIntentRevelationCreep=fixed,zeroSpeedHoldExpression=not fixed},
        evidenceBasis={
            governingBasis={responsibilityKey=governingRequirementKey,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active,dependentPairReferenceKey=dependentPairReferenceKey,dependentJobEpisodeIds=dependentJobEpisodeIds},
            maintainsExistingCommitment=existingCommitmentId~=nil,existingProgressMayContinue=true,
            progressActuationOwnership={assemblyIds={action.regulatedAssemblyId}},effectiveActuationComposition=composition,
            trafficPolicemanPreference={primaryResolution=true,governingRequirementKey=governingRequirementKey,exhaustionEvidence={
                CONTINUE_OBSERVATION={result="PASS",operationalPictureId=pictureId,governingRequirementKey=governingRequirementKey,capability="CONTINUE_OBSERVATION",
                    reason=corner and "Current shared Corner competing demand requires an allocated temporary right-of-way rather than observation-only progression"
                        or "The active opposed relationship has no selected supported Passage expression while unrestricted progression is positively consuming the bounded local Passage envelope",
                    evidence={actionSpaceConservation=action},provenance={source="LiveTrafficCandidateSupport",authority="ACTION_SPACE_REGULATION_OBSERVE_EXHAUSTION"}}
            },cornerRightOfWay=corner and {
                sharedCornerIdentity=relation.identity,cornerKey=action.cornerKey,
                regulatedAssemblyId=action.regulatedAssemblyId,protectedAssemblyId=protectedAssemblyId,
                regulatedParticipant=item.regulatedParticipant,protectedParticipant=item.protectedParticipant
            } or nil},
            actionSpaceRegulationBridge={
                action="APPLY",architecture="ACTION_SPACE_REGULATION",conflictIdentity=relation.identity,operationId=relation.operationId,
                governingRequirementKey=governingRequirementKey,existingCommitmentId=existingCommitmentId,
                regulatedAssemblyId=action.regulatedAssemblyId,regulatedReferenceKey=action.regulatedReferenceKey,
                protectedAssemblyId=protectedAssemblyId,protectedReferenceKey=protectedReferenceKey,
                excursionAssemblyId=action.excursionAssemblyId,excursionReferenceKey=action.excursionReferenceKey,admissionKind=action.admissionKind,
                cornerKey=action.cornerKey,
                nativeUnrestrictedKmh=action.nativeUnrestrictedKmh,
                fixedRegulationSpeedKmh=action.fixedRegulationSpeedKmh or action.regulationSpeedKmh,
                nativeClosureContributionKmh=action.nativeClosureContributionKmh,nativeSignedClosureContributionKmh=action.nativeSignedClosureContributionKmh,nativeMoveForwards=action.nativeMoveForwards,
                governingPurpose=action.governingPurpose,separationM=action.separationM,actionSpaceReason=action.reason,
                cooperativePassageEligible=relation.cooperativePassageEligible~=false,
                subjectOperationMember=relation.subjectOperationMember,otherOperationMember=relation.otherOperationMember
            }
        },
        representationFitness={requirements={{representationId=representationId,acceptedStates={"USABLE_WITH_UNCERTAINTY"}}}},
        preconditions={evidenceContracts={},relationshipClassification=relation.classification,actionSpaceConservationStatus="REGULATE_SUPPORTED",cooperativePassageEligible=relation.cooperativePassageEligible~=false},
        invalidationConditions={{kind="POSITIVE_RELATIONSHIP_DISSOLUTION"},{kind="COOPERATIVE_PASSAGE_SUCCESSION"},{kind="JOB_EPISODE_CHANGE"}},
        reversibility={physicalEffect=true,releaseOnPurposeExpiry=true},
        obligationsCreated={{
            origin={kind="TRAFFIC_INTERVENTION",decision=forward and "FORWARD_INTERSECTION" or (corner and "CORNER_RIGHT_OF_WAY" or "ACTION_SPACE_REGULATION"),conflictIdentity=relation.identity},
            basis={kind=forward and "FORWARD_INTERSECTION_INTENT_REVELATION" or (corner and "CORNER_RIGHT_OF_WAY" or "ACTION_SPACE_REGULATION"),conflictIdentity=relation.identity,cornerKey=action.cornerKey,admissionKind=action.admissionKind,roleAssignmentMutable=not forward},
            requiredOutcome={kind=forward and "FORWARD_INTERSECTION_DISSOLVED_OR_SUCCEEDED" or (corner and "CORNER_RIGHT_OF_WAY_PRESERVED_UNTIL_COMPETING_DEMAND_DISSOLVES" or "ACTION_SPACE_REGULATION_PRESERVED_UNTIL_RELATIONSHIP_MATURES_OR_DISSOLVES"),conflictIdentity=relation.identity},
            requiredAuthority={capabilities={"REGULATE_SPEED"},trafficPoliceman=true},
            evidenceContract={kind=forward and "FRESH_FORWARD_INTERSECTION_POSITIVE_OR_DISSOLVED" or (corner and "FRESH_SHARED_CORNER_COMPETING_DEMAND_OR_POSITIVE_DISSOLUTION" or "POSITIVE_RELATIONSHIP_DISSOLUTION_OR_COOPERATIVE_PASSAGE_SUCCESSION"),absenceDoesNotRetire=not forward and not corner},
            ownershipClass="CONTINUITY",transferPolicy={allowed=false},terminalDependency=true
        }},
        releaseImplications={releaseOnlyPurposeBoundRegulation=true,trafficSettlement=false,sameCommitmentPassageSuccession=true,currentRoleMayMigrateWithoutSettlingObligation=true},
        uncertainty={"CONTINGENCY_RESERVE_FRACTION_IS_PROVISIONAL_POLICY_CALIBRATION","NO_ROUTE_OR_PASSAGE_GEOMETRY_AUTHORITY"},comparisonCost=0
    }
end

local function publishActionSpaceRegulationPicture(self,picture,snapshot,item)
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next()
    local requirement=(item.action.admissionKind=="FORWARD_INTERSECTION" and "forward-intersection-regulation:" or "cooperative-passage:")..tostring(item.relation.identity)
    local existing,existingReason=actionSpaceExistingCommitmentForRequirement(values,requirement)
    if existingReason~=nil then self.lastStatus=existingReason; return self.passiveSupport:publishDecisionPicture(picture,snapshot) end
    values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="ACTION_SPACE_REGULATION"}
    local representationId=actionSpaceRegulationRepresentation(values,pictureId,item)
    local specification=makeActionSpaceRegulationCandidate(pictureId,values,item,requirement,existing,representationId)
    values.candidateSupportEvidence={
        complete=true,
        supportBoundary={mode="ACTION_SPACE_REGULATION",supportedCandidateClasses={"REGULATE_SPEED"},physicalCapabilitiesImplemented=true,controlAuthority="RESOLUTION_SPACE_PROGRESSION_ENVELOPE",boundedScope="POTENTIAL_CURRENT_EXCURSION_OR_ESTABLISHED_OPPOSED_CONFLICT_INSIDE_LOCAL_PASSAGE_ENVELOPE_WITH_TRANSITIONAL_NATIVE_INTENT_REVELATION",decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
        candidateSpecifications={specification},provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="ACTION_SPACE_REGULATION"}
    }
    local action=item.action
    logInfo("ACTION_SPACE_REGULATION_SUPPORTED","conflict=%s classification=%s admission=%s regulated=%s protected=%s role=%s separation=%.2f overlap=%.2f native=%.2fkmh closureContribution=%.2fkmh moveForwards=%s envelope=BOUNDED_AUTHORITY_OWNED existingCommitment=%s",
        tostring(item.relation.identity),tostring(item.relation.classification),tostring(action.admissionKind or "CURRENT_EXCURSION"),tostring(action.regulatedReferenceKey or action.regulatedAssemblyId),tostring(action.protectedReferenceKey or action.excursionReferenceKey or action.protectedAssemblyId or action.excursionAssemblyId),tostring(action.roleBasis or "CURRENT_EXCURSION_STABLE_PARTICIPANT"),
        tonumber(action.separationM) or -1,tonumber(action.currentCorridorOverlap and action.currentCorridorOverlap.overlapM) or -1,
        tonumber(action.nativeUnrestrictedKmh) or -1,tonumber(action.nativeClosureContributionKmh) or -1,tostring(action.nativeMoveForwards),tostring(existing or "NONE"))
    self.publishedCount=self.publishedCount+1
    self.lastStatus="ACTION_SPACE_REGULATION_CANDIDATE_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end

-- Aligned Follower Boundary Candidate support.  The Situation layer has
-- already decided whether current topology + a Provisional Demand Seed are
-- Representation-Fit enough to support follower protection.  Candidate support
-- does not inspect raw GIANTS state or historical manoeuvre probes.
local function followerBoundaryRecord(picture)
    local actionable={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.followerBoundaryKnowledge or {}) do
        local existing=type(record.existingCommitmentId)=="string"
        if record.status=="RETIRE_SUPPORTED" and existing then
            actionable[#actionable+1]={record=record,priority=1}
        elseif record.status=="UNRESOLVED" and existing then
            actionable[#actionable+1]={record=record,priority=2}
        elseif record.status=="REGULATE_SUPPORTED" then
            actionable[#actionable+1]={record=record,priority=existing and 2 or 3}
        end
    end
    if #actionable==0 then return nil,nil end
    table.sort(actionable,function(a,b)
        if a.priority~=b.priority then return a.priority<b.priority end
        return tostring(a.record.pairKey)<tostring(b.record.pairKey)
    end)
    local best=actionable[1]
    local same=0
    for _,entry in ipairs(actionable) do if entry.priority==best.priority then same=same+1 end end
    if same>1 then return nil,"MULTIPLE_SIMULTANEOUS_FOLLOWER_BOUNDARY_CONTEXTS" end
    return best.record,nil
end

local function followerRepresentation(values,pictureId,record)
    local representationId="follower-boundary-demand:"..tostring(record.pairKey)..":"..tostring(pictureId)
    values.representationFitness=values.representationFitness or {}
    values.representationFitness[#values.representationFitness+1]={
        representationId=representationId,
        assemblyId=record.followerAssemblyId,
        question="FOLLOWER_BOUNDARY_DEMAND_REGULATION",
        assessmentHorizon=record.transitionPreservation==true and "EXISTING_FOLLOWER_PURPOSE_PLUS_CURRENT_NATIVE_TRANSITION_RATE" or "CURRENT_ADJACENT_FOLLOWING_PLUS_PROVISIONAL_DEMAND_SEED",
        state="USABLE_WITH_UNCERTAINTY",
        claimPermissions={"FOLLOWER_BOUNDARY_REGULATION"},
        coverage={complete=false,conservative=true},
        uncertainty=record.transitionPreservation==true and {"TRANSITION_RATE_MAGNITUDE_ONLY","NATIVE_ROUTE_REMAINS_UNRESOLVED"} or (record.demandSeed and record.demandSeed.uncertainty or {"PROVISIONAL_DEMAND_SEED"}),
        validityDependencies=record.transitionPreservation==true and {"EXISTING_FOLLOWER_PURPOSE","CURRENT_GIANTS_NATIVE_TRANSITION_RATE"} or {"CURRENT_ADJACENT_FOLLOWING_TOPOLOGY","CURRENT_PRODUCTIVE_CONTINUATION","PROVISIONAL_DEMAND_SEED"},
        provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
    }
    return representationId
end

local function followerObligation(record)
    return {
        origin={kind="TRAFFIC_INTERVENTION",decision="FOLLOWER_BOUNDARY",pairKey=record.pairKey},
        basis={kind="FOLLOWER_BOUNDARY_PROTECTION",pairKey=record.pairKey,
            leaderAssemblyId=record.leaderAssemblyId,followerAssemblyId=record.followerAssemblyId,
            leaderName=record.leaderName,followerName=record.followerName,
            leaderReferenceKey=record.leaderReferenceKey,followerReferenceKey=record.followerReferenceKey,
            governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING"},
        requiredOutcome={kind="FOLLOWER_BOUNDARY_ORDERING_PRESERVED_UNTIL_POSITIVE_RETIREMENT",pairKey=record.pairKey},
        requiredAuthority={capabilities={"REGULATE_SPEED"},trafficPoliceman=true},
        evidenceContract={kind="POSITIVE_CURRENT_RELATIONSHIP_INVERSE_OR_PURPOSE_SUCCESSION",absenceDoesNotRetire=true},
        ownershipClass="CONTINUITY",transferPolicy={allowed=false},terminalDependency=true
    }
end

local function followerSpecification(pictureId,pictureValues,record,representationId)
    local requirement="follower-boundary:"..tostring(record.operationId)..":"..tostring(record.leaderAssemblyId)..":"..tostring(record.followerAssemblyId)
    local existing=type(record.existingCommitmentId)=="string"
    local capability="CONTINUE_OBSERVATION"
    local operation="PRESERVE"
    if record.status=="RETIRE_SUPPORTED" then capability="CONTINUE_UNCHANGED"; operation="RETIRE"
    elseif record.status=="REGULATE_SUPPORTED" then capability="REGULATE_SPEED"; operation="APPLY" end
    local physicalCandidate=capability=="REGULATE_SPEED"
    local exhaustion={}
    if physicalCandidate then
        local currentlyRestrictive=record.controlMagnitude and record.controlMagnitude.regulationRequired==true
        local exhaustionReason=currentlyRestrictive
            and "Positive Action-Space Compression evidence shows unrestricted native follower progression would mature before leader demand can vacate"
            or "Previously admitted follower-protection purpose remains positively current; elastic magnitude may relax without treating temporary current supportability as retirement"
        exhaustion.CONTINUE_OBSERVATION={
            result="PASS",operationalPictureId=pictureId,governingRequirementKey=requirement,capability="CONTINUE_OBSERVATION",
            reason=exhaustionReason,
            evidence={pairKey=record.pairKey,relationship=record.relationship,demandSeed=record.demandSeed,controlMagnitude=record.controlMagnitude,existingPurpose=existing,currentMagnitudeRestrictive=currentlyRestrictive},
            provenance={source="FollowerBoundaryDemandAssessment",authority="FOLLOWER_BOUNDARY_OBSERVATION_EXHAUSTION"}
        }
    end
    local preference=nil
    if capability~="CONTINUE_UNCHANGED" then preference={primaryResolution=true,governingRequirementKey=requirement,exhaustionEvidence=exhaustion} end
    local dependentPairReferenceKey,dependentJobEpisodeIds=currentPairDependency(pictureValues,record.leaderAssemblyId,record.followerAssemblyId,nil)
    local evidence={
        governingBasis={responsibilityKey=requirement,operationIds=pictureValues.identities.operations.active,sourceIntentIds=pictureValues.identities.jobEpisodes.active,dependentPairReferenceKey=dependentPairReferenceKey,dependentJobEpisodeIds=dependentJobEpisodeIds},
        maintainsExistingCommitment=existing or (#(pictureValues.commitmentContext or {})==1),
        existingProgressMayContinue=true,
        trafficPolicemanPreference=preference,
        followerBoundaryBridge={
            action=operation,pairKey=record.pairKey,operationId=record.operationId,
            leaderAssemblyId=record.leaderAssemblyId,followerAssemblyId=record.followerAssemblyId,
            leaderName=record.leaderName,followerName=record.followerName,
            leaderReferenceKey=record.leaderReferenceKey,followerReferenceKey=record.followerReferenceKey,
            existingCommitmentId=record.existingCommitmentId,existingObligationId=record.existingObligationId,
            governingRequirementKey=requirement,governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
            magnitudeEvidence=record.controlMagnitude and {
                status=record.controlMagnitude.status,
                regulationRequired=record.controlMagnitude.regulationRequired==true,
                nativeUnrestrictedFollowerKmh=record.controlMagnitude.nativeUnrestrictedFollowerKmh,
                maxAdmissibleFollowerKmh=record.controlMagnitude.maxAdmissibleFollowerKmh,
                unscaledMaxAdmissibleFollowerKmh=record.controlMagnitude.unscaledMaxAdmissibleFollowerKmh,
                clearanceFactor=record.controlMagnitude.clearanceFactor,
                clearanceFactorApplied=record.controlMagnitude.clearanceFactorApplied==true,
                leaderObservedProgressKmh=record.controlMagnitude.leaderObservedProgressKmh,
                leaderNativeCommandKmh=record.controlMagnitude.leaderNativeCommandKmh,
                leaderRateUsedKmh=record.controlMagnitude.leaderRateUsedKmh,
                transitionPreservation=record.transitionPreservation==true
            } or nil,
            transitionPreservation=record.transitionPreservation==true,
            representationId=representationId,reason=record.reason,purposeState=record.purposeState
        }
    }
    if physicalCandidate then
        evidence.progressActuationOwnership={assemblyIds={record.followerAssemblyId}}
        evidence.effectiveActuationComposition={
            identity="follower-boundary-composition:"..tostring(record.pairKey)..":"..tostring(pictureId),epoch=pictureValues.epoch,
            relevantAssemblyIds={record.leaderAssemblyId,record.followerAssemblyId},
            entries={{assemblyId=record.followerAssemblyId,commitmentId=record.existingCommitmentId or "$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="SPEED_LIMIT_OR_HOLD",progressActuation=true}}
        }
    end
    return {
        referenceKey="follower-boundary:"..string.lower(capability)..":"..tostring(record.pairKey),
        purpose={kind="FOLLOWER_BOUNDARY_DEMAND_PROTECTION",result=operation=="RETIRE" and "RETIRE_SUPERSEDED_OR_SATISFIED_FOLLOWER_PURPOSE" or "PRESERVE_BOUNDARY_TRANSITION_ORDERING"},
        subject={assemblyId=record.followerAssemblyId,assemblyIds={record.followerAssemblyId}},capability=capability,
        expectedEffect=physicalCandidate and {physicalChange=true,speedCeilingOnly=true,giantsRoute=true,giantsSteering=true,giantsDirection=true,elasticMagnitude=true} or {physicalChange=false,existingProgressMayContinue=true},
        evidenceBasis=evidence,
        representationFitness=physicalCandidate and {requirements={{representationId=representationId,acceptedStates={"USABLE_WITH_UNCERTAINTY"}}}} or {requirements={}},
        preconditions={evidenceContracts={},existingCommitmentId=record.existingCommitmentId,relationshipStatus=record.relationship and record.relationship.status,
            boundedObservationContract=capability=="CONTINUE_OBSERVATION" and {knowledgeGap="CURRENT_FOLLOWER_BOUNDARY_PURPOSE_REASSESSMENT",expectedRealityEvolution="CURRENT_TOPOLOGY_OR_NATIVE_COMMAND_CHANGES",preservedUsefulAction="EXISTING_PURPOSE_AND_LEASE_REMAIN_UNCHANGED",exhaustionCondition="POSITIVE_REGULATION_OR_RETIREMENT_EVIDENCE",reassessmentDeadline="NEXT_LIVE_OPERATIONAL_PICTURE",progressParticipantId=record.followerAssemblyId} or nil},
        invalidationConditions={{kind="CURRENT_FOLLOWING_RELATIONSHIP_CHANGE"},{kind="JOB_EPISODE_CHANGE"},{kind="PROGRESS_PASSAGE_PURPOSE_SUCCESSION"}},
        reversibility={physicalEffect=physicalCandidate,releaseOnPurposeExpiry=true},
        obligationsCreated=(physicalCandidate and not existing) and {followerObligation(record)} or {},
        releaseImplications={trafficSettlement=false,releaseOnlyPurposeBoundFollowerRegulation=operation=="RETIRE"},
        uncertainty=record.demandSeed and record.demandSeed.uncertainty or {"CURRENT_PURPOSE_REASSESSMENT"},
        comparisonCost=0
    },requirement
end

local function publishFollowerBoundaryPicture(self,picture,snapshot,record)
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    local pictureId=self.identities:issue("PICTURE")
    values.identity=pictureId; values.epoch=self.epochs:next()
    values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="FOLLOWER_BOUNDARY"}
    local representationId=followerRepresentation(values,pictureId,record)
    local specification,requirement=followerSpecification(pictureId,values,record,representationId)
    local decisionPolicy=nil
    if specification.capability~="CONTINUE_UNCHANGED" then decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement} end
    values.candidateSupportEvidence={
        complete=true,
        supportBoundary={mode="FOLLOWER_BOUNDARY",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=specification.capability=="REGULATE_SPEED",controlAuthority=false,boundedScope="CURRENT_ADJACENT_FOLLOWING_WITH_PROVISIONAL_DEMAND_SEED",decisionPolicy=decisionPolicy},
        candidateSpecifications={specification},
        provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="FOLLOWER_BOUNDARY"}
    }
    self.publishedCount=self.publishedCount+1
    self.lastStatus="FOLLOWER_BOUNDARY_"..tostring(record.status).."_CANDIDATE_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end


local function passageRejectionTelemetry(allRejected)
    if type(allRejected)~="table" then return nil,nil end
    local geometry,field,sweep,third,other,total=0,0,0,0,0,0
    local details={}
    local conflictId,topReason=nil,nil
    for _,conflict in ipairs(allRejected) do
        conflictId=conflictId or conflict.conflictIdentity
        topReason=topReason or conflict.reason
        for _,candidate in ipairs(conflict.rejected or {}) do
            total=total+1
            local reason=nil
            if candidate.guideReason~=nil then geometry=geometry+1; reason="GUIDE:"..tostring(candidate.guideReason)
            elseif candidate.fieldReason~=nil then
                field=field+1
                local component=candidate.fieldEvidence and candidate.fieldEvidence.theatreComponent or "UNCLASSIFIED"
                reason="FIELD:"..tostring(component)..":"..tostring(candidate.fieldReason)
            elseif candidate.sweepReason~=nil then sweep=sweep+1; reason="SWEEP:"..tostring(candidate.sweepReason)
            elseif candidate.thirdPartyReason~=nil then third=third+1; reason="THIRD:"..tostring(candidate.thirdPartyReason)
            else other=other+1; reason="OTHER" end
            if #details<6 then details[#details+1]=tostring(candidate.index or "?").."="..reason end
        end
    end
    local signature=table.concat({tostring(conflictId),tostring(topReason),geometry,field,sweep,third,other,total,table.concat(details,"|")},":")
    local text=string.format("conflict=%s reason=%s candidates=%d geometry=%d field=%d sweep=%d thirdParty=%d other=%d details=%s",
        tostring(conflictId or "n/a"),tostring(topReason or "n/a"),total,geometry,field,sweep,third,other,#details>0 and table.concat(details,",") or "none")
    return signature,text
end


local function finiteNumber(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function clearanceTraceCandidate(candidate)
    if type(candidate)~="table" or type(candidate.sweepEvidence)~="table" then return nil end
    local sweep=candidate.sweepEvidence
    local crossing=tonumber(sweep.minimumCrossingWindowClearanceM)
    local required=tonumber(sweep.requiredNominalClearanceM)
    if not finiteNumber(crossing) or not finiteNumber(required) then return nil end
    return {
        candidate=candidate,
        crossing=crossing,
        required=required,
        residue=crossing-required,
        outside=tonumber(sweep.minimumOutsideCrossingClearanceM),
        minimum=tonumber(sweep.minimumRepresentedClearanceM),
        floor=tonumber(sweep.acceptedNominalClearanceFloorM),
        floorResidue=(finiteNumber(crossing) and finiteNumber(tonumber(sweep.acceptedNominalClearanceFloorM))) and (crossing-tonumber(sweep.acceptedNominalClearanceFloorM)) or nil
    }
end

-- Clearance telemetry consumes evidence already computed by the
-- ordinary LocalPassagePlanner pass.  It does not call the planner, sweep, or
-- geometry functions again.  The trace is intentionally limited to the local
-- 40 m approach so the field comparison exposes NO -> YES -> NO clearance
-- behaviour without recreating Candidate Search Amplification.
local function passageClearanceRejectionTelemetry(allRejected)
    local lines={}
    if type(allRejected)~="table" then return lines end
    local maxTraceSeparation=COOPERATIVE_PASSAGE_CLEARANCE_TRACE_MAX_SEPARATION_M
    for _,conflict in ipairs(allRejected) do
        local best=nil
        local residues={}
        local firstCandidate=nil
        for _,candidate in ipairs(conflict.rejected or {}) do
            firstCandidate=firstCandidate or candidate
            local trace=clearanceTraceCandidate(candidate)
            if trace~=nil then
                residues[#residues+1]=string.format("%s=%+.3f",tostring(candidate.index or "?"),trace.residue)
                if best==nil or trace.residue>best.residue then best=trace end
            end
        end
        local reference=(best and best.candidate) or firstCandidate
        local separation=tonumber(reference and reference.separationM)
        if reference~=nil and finiteNumber(separation) and separation<=maxTraceSeparation then
            local c=best and best.candidate or reference
            local sweep=c and c.sweepEvidence or nil
            local crossing=best and best.crossing or nil
            local required=best and best.required or nil
            local residue=best and best.residue or nil
            local outside=best and best.outside or nil
            local minimum=best and best.minimum or nil
            local floor=best and best.floor or tonumber(sweep and sweep.acceptedNominalClearanceFloorM)
            local floorResidue=best and best.floorResidue or ((finiteNumber(crossing) and finiteNumber(floor)) and (crossing-floor) or nil)
            lines[#lines+1]=string.format(
                "COOPERATIVE_PASSAGE_CLEARANCE_TRACE conflict=%s outcome=REJECTED separation=%.2f longitudinal=%.2f lateral=%.3f bestIndex=%s crossing=%s nominal=%s nominalResidue=%s floor=%s floorResidue=%s outside=%s minimum=%s contact=%.3f offsets=%+.3f/%+.3f relation=%s configuration=%s/%s geometry=%s sweepReason=%s residues=%s",
                tostring(conflict.conflictIdentity or "n/a"),separation,tonumber(c and c.longitudinalSeparationM) or -1,tonumber(c and c.currentLateralSeparationM) or -1,
                tostring(c and c.index or "n/a"),finiteNumber(crossing) and string.format("%.3f",crossing) or "n/a",finiteNumber(required) and string.format("%.3f",required) or "n/a",
                finiteNumber(residue) and string.format("%+.3f",residue) or "n/a",finiteNumber(floor) and string.format("%.3f",floor) or "n/a",finiteNumber(floorResidue) and string.format("%+.3f",floorResidue) or "n/a",finiteNumber(outside) and string.format("%.3f",outside) or "n/a",finiteNumber(minimum) and string.format("%.3f",minimum) or "n/a",
                tonumber(c and c.physicalContactThresholdM) or -1,tonumber(c and c.subjectLateralOffsetM) or 0,tonumber(c and c.otherLateralOffsetM) or 0,tostring(c and c.relationSign or "n/a"),
                tostring(c and c.subjectConfigurationMode or "n/a"),tostring(c and c.otherConfigurationMode or "n/a"),tostring(c and c.passageGeometrySource or "n/a"),tostring(c and c.sweepReason or "n/a"),#residues>0 and table.concat(residues,"|") or "none")
        end
    end
    return lines
end

-- Diagnostic-only visibility for the prospective portfolio path.  The
-- per-conflict planner already computes bounded rejection evidence; projected
-- support must not make that evidence disappear merely because Action-Space
-- Regulation remains independently supportable.  This helper owns no Candidate,
-- Decision, Responsibility, Authority or Control meaning.
local function traceProjectedPassageRejection(self,relation,reason,rejected,fallbackActionSpaceSupported)
    if type(relation)~="table" or type(relation.identity)~="string" then return end
    local eligible=publication:isEligible("DIAGNOSTIC","INFO","COOPERATIVE_PASSAGE_PROJECTED_REJECTED")
    if eligible~=true then return end
    local allRejected={{conflictIdentity=relation.identity,reason=reason,rejected=rejected or {}}}
    local rejectionKey,rejectionText=passageRejectionTelemetry(allRejected)
    local signature=table.concat({
        tostring(reason or "UNRESOLVED"),
        tostring(rejectionKey or "NO_DETAIL"),
        tostring(fallbackActionSpaceSupported==true)
    },"|")
    if self.projectedPassageRejectionTraceKeys[relation.identity]~=signature then
        self.projectedPassageRejectionTraceKeys[relation.identity]=signature
        logInfo("COOPERATIVE_PASSAGE_PROJECTED_REJECTED","conflict=%s classification=%s passageEligible=%s fallbackActionSpaceSupported=%s %s",
            tostring(relation.identity),tostring(relation.classification),tostring(relation.cooperativePassageEligible~=false),
            tostring(fallbackActionSpaceSupported==true),tostring(rejectionText or ("reason="..tostring(reason))))
        for _,clearanceTrace in ipairs(passageClearanceRejectionTelemetry(allRejected)) do
            logInfo("COOPERATIVE_PASSAGE_PROJECTED_REJECTION_DETAIL","%s",clearanceTrace)
        end
    end
end

local function passageClearanceSelectedTelemetry(plan)
    if type(plan)~="table" then return nil end
    local separation=tonumber(plan.separationM)
    local maxTraceSeparation=COOPERATIVE_PASSAGE_CLEARANCE_TRACE_MAX_SEPARATION_M
    if not finiteNumber(separation) or separation>maxTraceSeparation then return nil end
    local arrangement=plan.passageArrangement or {}
    local guide=plan.passageGuide or {}
    local sweep=guide.pairSweepSupport or {}
    local crossing=tonumber(sweep.minimumCrossingWindowClearanceM)
    local required=tonumber(sweep.requiredNominalClearanceM)
    local residue=(finiteNumber(crossing) and finiteNumber(required)) and (crossing-required) or nil
    local outside=tonumber(sweep.minimumOutsideCrossingClearanceM)
    local minimum=tonumber(sweep.minimumRepresentedClearanceM)
    local floor=tonumber(sweep.acceptedNominalClearanceFloorM)
    local floorResidue=(finiteNumber(crossing) and finiteNumber(floor)) and (crossing-floor) or nil
    local config=plan.passageConfiguration or {}
    local participants=config.participants or {}
    local c1,c2=participants[1] or {},participants[2] or {}
    return string.format(
        "COOPERATIVE_PASSAGE_CLEARANCE_TRACE conflict=%s outcome=SELECTED separation=%.2f longitudinal=%.2f lateral=%.3f selectedIndex=%s crossing=%s nominal=%s nominalResidue=%s floor=%s floorResidue=%s outside=%s minimum=%s contact=%.3f offsets=%+.3f/%+.3f relation=%s configuration=%s/%s geometry=%s",
        tostring(plan.conflictIdentity or "n/a"),separation,tonumber(plan.longitudinalSeparationM) or -1,tonumber(arrangement.currentLateralSeparationM) or -1,
        tostring(plan.progressiveSearch and plan.progressiveSearch.selectedIndex or "n/a"),finiteNumber(crossing) and string.format("%.3f",crossing) or "n/a",finiteNumber(required) and string.format("%.3f",required) or "n/a",
        finiteNumber(residue) and string.format("%+.3f",residue) or "n/a",finiteNumber(floor) and string.format("%.3f",floor) or "n/a",finiteNumber(floorResidue) and string.format("%+.3f",floorResidue) or "n/a",finiteNumber(outside) and string.format("%.3f",outside) or "n/a",finiteNumber(minimum) and string.format("%.3f",minimum) or "n/a",
        tonumber(arrangement.physicalContactThresholdM) or -1,tonumber(arrangement.subjectLateralOffsetM) or 0,tonumber(arrangement.otherLateralOffsetM) or 0,tostring(arrangement.relationSign or "n/a"),
        tostring(c1.mode or "n/a"),tostring(c2.mode or "n/a"),tostring(arrangement.passageGeometrySource or arrangement.directionalPassageEnvelopeBasis or "n/a"))
end

local function followerMatchesCooperative(follower,record)
    if type(follower)~="table" or type(record)~="table" then return false end
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(record.assemblyIds or {}) do ids[id]=true end
    return ids[follower.leaderAssemblyId]==true and ids[follower.followerAssemblyId]==true
end


local function projectedFitnessAdditions(values,baselineCount)
    local result={}
    local fitness=values.representationFitness or {}
    for index=baselineCount+1,#fitness do result[#result+1]=fitness[index] end
    return result
end

local function projectedOpposedRelation(picture,relationshipIdentity)
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        if relation.identity==relationshipIdentity then return relation end
    end
    return nil
end

local function projectedCornerRightOfWayGroup(self,picture,snapshot,values,targetPictureId,situation)
    local participants={}
    for _,participant in OuttaMyWay.ValueRecord.ipairs(situation and situation.participants or {}) do
        if type(participant.assemblyId)=="string" and type(participant.assemblyReferenceKey)=="string" then
            participants[#participants+1]=participant
        end
    end
    table.sort(participants,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    if #participants~=2 then return nil,"SHARED_CORNER_RIGHT_OF_WAY_REQUIRES_EXACTLY_TWO_CURRENT_PARTICIPANTS" end

    local requirement="corner-right-of-way:"..tostring(situation.identity)
    local existing,existingReason=actionSpaceExistingCommitmentForRequirement(values,requirement)
    if existingReason~=nil then return nil,existingReason end
    local baseline=#(values.representationFitness or {})
    local specifications={}
    for index=1,2 do
        local regulated=participants[index]
        local protected=participants[index==1 and 2 or 1]
        local item=cornerActionItem(situation,regulated,protected)
        local representationId=actionSpaceRegulationRepresentation(values,targetPictureId,item)
        specifications[#specifications+1]=makeActionSpaceRegulationCandidate(
            targetPictureId,values,item,requirement,existing,representationId)
    end
    logInfo("CORNER_RIGHT_OF_WAY_CANDIDATES_SUPPORTED","situation=%s corner=%s participants=%s/%s targetPicture=%s decisionAllocation=true",
        tostring(situation.identity),tostring(situation.cornerKey),tostring(participants[1].assemblyId),
        tostring(participants[2].assemblyId),tostring(targetPictureId))
    return {
        supportBoundary={mode="CORNER_RIGHT_OF_WAY",supportedCandidateClasses={"REGULATE_SPEED"},physicalCapabilitiesImplemented=true,
            controlAuthority="FIXED_INTENT_REVELATION_CREEP",boundedScope="CURRENT_SHARED_STRUCTURAL_CORNER_COMPETING_DEMAND",
            decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
        candidateSpecifications=specifications,
        representationFitness=projectedFitnessAdditions(values,baseline),
        provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,
            targetOperationalPictureId=targetPictureId,candidateSupportProjection=true,authority="CORNER_RIGHT_OF_WAY_CANDIDATE_SUPPORT"}
    },nil
end

local function projectedActionSpaceGroup(self,picture,snapshot,values,targetPictureId,item)
    local requirement=(item.action.admissionKind=="FORWARD_INTERSECTION" and "forward-intersection-regulation:" or "cooperative-passage:")..tostring(item.relation.identity)
    local existing,existingReason=actionSpaceExistingCommitmentForRequirement(values,requirement)
    if existingReason~=nil then return nil,existingReason end
    local baseline=#(values.representationFitness or {})
    local representationId=actionSpaceRegulationRepresentation(values,targetPictureId,item)
    local specification=makeActionSpaceRegulationCandidate(targetPictureId,values,item,requirement,existing,representationId)
    local action=item.action
    logInfo("ACTION_SPACE_REGULATION_SUPPORTED","conflict=%s classification=%s admission=%s regulated=%s protected=%s role=%s separation=%.2f overlap=%.2f native=%.2fkmh closureContribution=%.2fkmh moveForwards=%s envelope=BOUNDED_AUTHORITY_OWNED existingCommitment=%s",
        tostring(item.relation.identity),tostring(item.relation.classification),tostring(action.admissionKind or "CURRENT_EXCURSION"),tostring(action.regulatedReferenceKey or action.regulatedAssemblyId),tostring(action.protectedReferenceKey or action.excursionReferenceKey or action.protectedAssemblyId or action.excursionAssemblyId),tostring(action.roleBasis or "CURRENT_EXCURSION_STABLE_PARTICIPANT"),
        tonumber(action.separationM) or -1,tonumber(action.currentCorridorOverlap and action.currentCorridorOverlap.overlapM) or -1,
        tonumber(action.nativeUnrestrictedKmh) or -1,tonumber(action.nativeClosureContributionKmh) or -1,tostring(action.nativeMoveForwards),tostring(existing or "NONE"))
    return {
        supportBoundary={mode="ACTION_SPACE_REGULATION",supportedCandidateClasses={"REGULATE_SPEED"},physicalCapabilitiesImplemented=true,controlAuthority="RESOLUTION_SPACE_PROGRESSION_ENVELOPE",boundedScope="POTENTIAL_CURRENT_EXCURSION_OR_ESTABLISHED_OPPOSED_CONFLICT_INSIDE_LOCAL_PASSAGE_ENVELOPE_WITH_TRANSITIONAL_NATIVE_INTENT_REVELATION",decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}},
        candidateSpecifications={specification},
        representationFitness=projectedFitnessAdditions(values,baseline),
        provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,targetOperationalPictureId=targetPictureId,candidateSupportProjection=true,authority="ACTION_SPACE_REGULATION"}
    },nil
end

-- Candidate Support Projection asks one already-assessed prospective support
-- question while retaining the complete parent Operational Picture as evidence.
-- It returns a plain support-group fragment and never publishes a picture.
function Support:buildProjectedGroup(picture,snapshot,projection,targetPictureId,targetEpoch)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    if type(projection)~="table" or type(projection.kind)~="string" then return nil,"CANDIDATE_SUPPORT_PROJECTION_REQUIRED" end
    if type(targetPictureId)~="string" or targetPictureId=="" or type(targetEpoch)~="number" then return nil,"TARGET_DECISION_PICTURE_REQUIRED" end

    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.identity=targetPictureId
    values.epoch=targetEpoch

    if projection.kind=="FOLLOWER_BOUNDARY" then
        local record,reason=followerBoundaryRecord(picture)
        if record==nil then return nil,reason or "NO_FOLLOWER_BOUNDARY_SUPPORT" end
        local baseline=#(values.representationFitness or {})
        local representationId=followerRepresentation(values,targetPictureId,record)
        local specification,requirement=followerSpecification(targetPictureId,values,record,representationId)
        local decisionPolicy=nil
        if specification.capability~="CONTINUE_UNCHANGED" then
            decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=requirement}
        end
        return {
            supportBoundary={mode="FOLLOWER_BOUNDARY",supportedCandidateClasses={specification.capability},physicalCapabilitiesImplemented=specification.capability=="REGULATE_SPEED",controlAuthority=false,boundedScope="CURRENT_ADJACENT_FOLLOWING_WITH_PROVISIONAL_DEMAND_SEED",decisionPolicy=decisionPolicy},
            candidateSpecifications={specification},
            representationFitness=projectedFitnessAdditions(values,baseline),
            provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,targetOperationalPictureId=targetPictureId,candidateSupportProjection=true,authority="FOLLOWER_BOUNDARY"}
        },nil
    end

    if projection.kind=="CORNER_RIGHT_OF_WAY" then
        local situation,reason=sharedCornerSituation(picture,projection.sharedCornerIdentity)
        if situation==nil then return nil,reason or "NO_SHARED_CORNER_COMPETING_DEMAND" end
        return projectedCornerRightOfWayGroup(self,picture,snapshot,values,targetPictureId,situation)
    end

    if projection.kind=="FORWARD_INTERSECTION" then
        local item,reason=forwardIntersectionRecord(picture)
        if item==nil then return nil,reason or "NO_FORWARD_INTERSECTION_SUPPORT" end
        return projectedActionSpaceGroup(self,picture,snapshot,values,targetPictureId,item)
    end

    if projection.kind=="OPPOSED_RELATIONSHIP" then
        if type(projection.relationshipIdentity)~="string" then return nil,"OPPOSED_RELATIONSHIP_ID_REQUIRED" end
        local relation=projectedOpposedRelation(picture,projection.relationshipIdentity)
        if relation==nil then return nil,"PROJECTED_OPPOSED_RELATIONSHIP_NOT_FOUND" end

        local passageReason=nil
        local passageRejected=nil
        if relation.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" and relation.cooperativePassageEligible~=false then
            local plan,reason,rejected=OuttaMyWay.LocalPassagePlanner.planConflict(picture,snapshot,relation)
            passageReason=reason
            passageRejected=rejected
            if plan~=nil then
                self.projectedPassageRejectionTraceKeys[relation.identity]=nil
                if type(plan.progressiveSearch)=="table" then
                    plan.progressiveSearch.conflictSelection="ONE_CONFLICT_SUPPORT_PROJECTION_NO_INTER_CONFLICT_SELECTION"
                end
                local governingRequirementKey=cooperativePassageRequirementKey(plan)
                local specification=makeCooperativePassageCandidate(targetPictureId,values,plan,governingRequirementKey)
                logInfo("COOPERATIVE_PASSAGE_SUPPORTED","conflict=%s separation=%.2f entryReady=%s targetPicture=%s projection=true",
                    tostring(plan.conflictIdentity),tonumber(plan.separationM) or -1,tostring(plan.passageEntry and plan.passageEntry.ready==true),tostring(targetPictureId))
                return {
                    supportBoundary={mode="COOPERATIVE_PASSAGE",supportedCandidateClasses={"REPOSITION"},physicalCapabilitiesImplemented=true,controlAuthority="COOPERATIVE_PASSAGE_BOUNDED_CONTROL",boundedScope="ESTABLISHED_CONFLICT_CONFIGURATION_FIRST_PAIR_SPECIFIC_CLEARANCE_WITH_OPERATION_AWARE_LOCAL_SPACE",vehicleNameAdmissionGate=false,generalVehicleAuthority=false,decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=governingRequirementKey}},
                    candidateSpecifications={specification},
                    representationFitness={},
                    provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,targetOperationalPictureId=targetPictureId,candidateSupportProjection=true,authority="COOPERATIVE_PASSAGE_CANDIDATE_SUPPORT",operatorCommandRequired=false}
                },nil
            end
        end

        local action=relation.actionSpaceConservation
        local actionSpaceSupported=(relation.classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" or relation.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT")
            and type(action)=="table" and action.status=="REGULATE_SUPPORTED" and action.supported==true
        if passageReason~=nil then
            traceProjectedPassageRejection(self,relation,passageReason,passageRejected,actionSpaceSupported)
        end
        if actionSpaceSupported then
            return projectedActionSpaceGroup(self,picture,snapshot,values,targetPictureId,{relation=relation,action=action})
        end
        return nil,passageReason or "PROJECTED_OPPOSED_RELATIONSHIP_HAS_NO_SUPPORTED_CANDIDATE"
    end

    return nil,"UNSUPPORTED_CANDIDATE_SUPPORT_PROJECTION_KIND:"..tostring(projection.kind)
end

function Support:publishDecisionPicture(picture,snapshot)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")

    local follower,followerReason=followerBoundaryRecord(picture)
    if follower~=nil and follower.status=="RETIRE_SUPPORTED" then return publishFollowerBoundaryPicture(self,picture,snapshot,follower) end
    if followerReason~=nil then self.lastStatus=followerReason; return self.passiveSupport:publishDecisionPicture(picture,snapshot) end

    -- An established follower purpose has precedence. Otherwise the earliest
    -- supported Forward Intersection is considered before Passage planning.
    if follower==nil then
        local forward,forwardReason=forwardIntersectionRecord(picture)
        if forward~=nil then return publishActionSpaceRegulationPicture(self,picture,snapshot,forward) end
        if forwardReason~=nil then self.lastStatus=forwardReason; return self.passiveSupport:publishDecisionPicture(picture,snapshot) end
    end

    -- Cooperative Passage has a single production Candidate path.
    -- There is no feature switch or retired prototype fallback path to resurrect.
        local plan,reason,rejected=OuttaMyWay.LocalPassagePlanner.plan(picture,snapshot)
        if plan==nil then
            local diagnosticEligible=publication:isEligible("DIAGNOSTIC","INFO","COOPERATIVE_PASSAGE_CLEARANCE_REJECTION_DETAIL")
            if diagnosticEligible==true then
                for _,clearanceTrace in ipairs(passageClearanceRejectionTelemetry(rejected)) do
                    logInfo("COOPERATIVE_PASSAGE_CLEARANCE_REJECTION_DETAIL","%s",clearanceTrace)
                end
                local rejectionKey,rejectionText=passageRejectionTelemetry(rejected)
                if rejectionKey~=nil and rejectionKey~=self.lastPassageRejectionTraceKey then
                    self.lastPassageRejectionTraceKey=rejectionKey
                    logInfo("COOPERATIVE_PASSAGE_REJECTED","%s",rejectionText)
                end
            end
            local actionSpace,actionReason=actionSpaceRegulationRecord(picture)
            if actionSpace~=nil then return publishActionSpaceRegulationPicture(self,picture,snapshot,actionSpace) end
            if actionReason~=nil then self.lastStatus=actionReason; return self.passiveSupport:publishDecisionPicture(picture,snapshot) end
            if follower~=nil then return publishFollowerBoundaryPicture(self,picture,snapshot,follower) end
            self.lastCooperativeTraceKey=nil
            self.lastStatus=reason or "NO_SUPPORTED_COOPERATIVE_PASSAGE"
            return self.passiveSupport:publishDecisionPicture(picture,snapshot)
        end
        self.lastPassageRejectionTraceKey=nil
        local selectedTraceEligible=publication:isEligible("DIAGNOSTIC","INFO","COOPERATIVE_PASSAGE_CLEARANCE_SELECTED_DETAIL")
        if selectedTraceEligible==true then
            local selectedClearanceTrace=passageClearanceSelectedTelemetry(plan)
            if selectedClearanceTrace~=nil then logInfo("COOPERATIVE_PASSAGE_CLEARANCE_SELECTED_DETAIL","%s",selectedClearanceTrace) end
        end
        if follower~=nil and not followerMatchesCooperative(follower,{assemblyIds=plan.assemblyIds or {}}) then
            return publishFollowerBoundaryPicture(self,picture,snapshot,follower)
        end

        -- Passage Selection immediately hands authority from Action-Space Regulation
        -- to Cooperative Passage. Physical Passage Entry may still be delayed,
        -- but that delay is owned inside Cooperative Passage execution rather
        -- than by retaining Action-Space Regulation.

        local values=OuttaMyWay.ValueRecord.toTable(picture)
        local pictureId=self.identities:issue("PICTURE")
        values.identity=pictureId; values.epoch=self.epochs:next()
        values.provenance={source="LiveTrafficCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="COOPERATIVE_PASSAGE_CANDIDATE_SUPPORT",followerBoundarySupportingLeaseRetained=follower~=nil}
        local governingRequirementKey=cooperativePassageRequirementKey(plan)
        local traceKey=tostring(plan.conflictIdentity)
        local selectionTraceEligible=publication:isEligible("DIAGNOSTIC","INFO","COOPERATIVE_PASSAGE_SELECTED")
        local firstTrace=selectionTraceEligible==true and self.lastCooperativeTraceKey~=traceKey
        if firstTrace then
            self.lastCooperativeTraceKey=traceKey
            local arrangement=plan.passageArrangement or {}; local guide=plan.passageGuide or {}; local sweep=guide.pairSweepSupport or {}
            local config=plan.passageConfiguration or {}; local participants=config.participants or {}
            local c1=participants[1] or {}; local c2=participants[2] or {}
            local theatre=plan.passageCapableTheatre or {}; local reacquisition=theatre.lateralExcursionReacquisition or {}
            local subjectReacquisition=reacquisition.subject or {}; local otherReacquisition=reacquisition.other or {}
            logInfo("COOPERATIVE_PASSAGE_SELECTED","conflict=%s separation=%.2f entryReady=%s entryBoundary=%.2f lateral=%.2f contact=%.2f nominal=%.2f required=%.2f reserve=%+.2f envelopeBasis=%s sweepBasis=%s crossingBasis=%s arrangement=%s offsets=%+.2f/%+.2f deficit=%.2f configuration=%s/%s release=%.2f profiles=%s/%s guide=%s gates=%d crossingForward=%.2f lateralExcursionRequired=%s/%s reacquisition=%.2f/%.2f theatreComplete=%s minimumRepresentedClearance=%.2f searchIndex=%s",
                tostring(plan.conflictIdentity),tonumber(plan.separationM) or -1,tostring(plan.passageEntry and plan.passageEntry.ready==true),tonumber(plan.passageEntry and plan.passageEntry.boundarySeparationM) or -1,tonumber(arrangement.currentLateralSeparationM) or -1,tonumber(arrangement.physicalContactThresholdM) or -1,tonumber(arrangement.nominalInterAssemblyClearanceM) or -1,tonumber(arrangement.policyRequiredSeparationM) or -1,tonumber(arrangement.currentPolicyReserveM) or -1,
                tostring(arrangement.directionalPassageEnvelopeBasis or "DISC_FALLBACK"),tostring(sweep.supportBasis or "n/a"),tostring(plan.passageExcursion and plan.passageExcursion.crossingWindowBasis or "n/a"),tostring(arrangement.identity),tonumber(arrangement.subjectLateralOffsetM) or 0,tonumber(arrangement.otherLateralOffsetM) or 0,tonumber(plan.passageExcursion and plan.passageExcursion.clearanceDeficitM) or 0,
                tostring(c1.mode or "n/a"),tostring(c2.mode or "n/a"),tonumber(config.totalConfigurationReleasedSpaceM) or 0,tostring(c1.expectedCompactConfigurationProfileId or c1.currentConfigurationProfileId or "n/a"),tostring(c2.expectedCompactConfigurationProfileId or c2.currentConfigurationProfileId or "n/a"),
                tostring(guide.identity),#(guide.gates or {}),tonumber(plan.passageExcursion and plan.passageExcursion.crossingWindowForwardPerParticipantM) or 0,tostring(subjectReacquisition.required==true),tostring(otherReacquisition.required==true),tonumber(subjectReacquisition.distanceM) or 0,tonumber(otherReacquisition.distanceM) or 0,tostring(theatre.complete==true),tonumber(sweep.minimumRepresentedClearanceM) or -1,tostring(plan.progressiveSearch and plan.progressiveSearch.selectedIndex or "n/a"))
        end
        local specification=makeCooperativePassageCandidate(pictureId,values,plan,governingRequirementKey)
        values.candidateSupportEvidence={
            complete=true,
            supportBoundary={mode="COOPERATIVE_PASSAGE",supportedCandidateClasses={"REPOSITION"},physicalCapabilitiesImplemented=true,controlAuthority="COOPERATIVE_PASSAGE_BOUNDED_CONTROL",boundedScope="ESTABLISHED_CONFLICT_CONFIGURATION_FIRST_PAIR_SPECIFIC_CLEARANCE_WITH_OPERATION_AWARE_LOCAL_SPACE",vehicleNameAdmissionGate=false,generalVehicleAuthority=false,decisionPolicy={kind=OuttaMyWay.TrafficPolicemanDecisionPolicy.KIND,governingRequirementKey=governingRequirementKey}},
            candidateSpecifications={specification},
            provenance={source="LiveTrafficCandidateSupport",observationSnapshotId=snapshot.identity,authority="COOPERATIVE_PASSAGE_CANDIDATE_SUPPORT",operatorCommandRequired=false}
        }
        self.publishedCount=self.publishedCount+1
        self.lastStatus="COOPERATIVE_PASSAGE_CANDIDATE_PUBLISHED"
        return OuttaMyWay.OperationalPicture.new(values)
end

function Support:getPublishedCount() return self.publishedCount end
