OuttaMyWay.ObstructionRelocationCandidateSupport={}
local Support=OuttaMyWay.ObstructionRelocationCandidateSupport
Support.__index=Support

local mandatory={"FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS","CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS","EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"}

local function packet(reason,evidence,applicable)
    return {result="PASS",applicable=applicable~=false,evidence=evidence or {},reason=reason,provenance={source="ObstructionRelocationCandidateSupport",authority="CAUSAL_OBSTRUCTION_RELOCATION"},revalidationTrigger={kind="NEXT_LIVE_OPERATIONAL_PICTURE"}}
end

local function allPassEvidence(reason)
    local result={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(mandatory) do result[id]=packet(reason,{bounded=true}) end
    return result
end

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function genericContext(picture)
    local contexts=picture.commitmentContext or {}
    if OuttaMyWay.ValueRecord.length(contexts)==0 then return nil,nil end
    if OuttaMyWay.ValueRecord.length(contexts)~=1 then return nil,"OTHER_OR_MULTIPLE_COMMITMENTS_ACTIVE" end
    local basis=contexts[1].governingBasis or {}
    if basis.kind~="CAUSAL_OBSTRUCTION_RELOCATION" then return nil,"OTHER_COMMITMENT_ACTIVE" end
    return contexts[1],nil
end


local function referencesByAssembly(snapshot)
    local result={}
    for _,assembly in OuttaMyWay.ValueRecord.ipairs(snapshot and snapshot.assemblies or {}) do
        if type(assembly.assemblyId)=="string" and type(assembly.referenceKey)=="string" then result[assembly.assemblyId]=assembly.referenceKey end
    end
    return result
end

local function posesByReference(snapshot)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(snapshot and snapshot.geometry and snapshot.geometry.currentPhysicalPoseEvidence or {}) do
        if type(item.assemblyReferenceKey)=="string" and finite(item.x) and finite(item.z) then result[item.assemblyReferenceKey]=item end
    end
    return result
end

local function activeRelationsByKey(picture)
    local result={}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.causalObstructionKnowledge or {}) do
        local operationId=relation.operationId
        local blockerId=relation.blockerAssemblyId
        if type(operationId)=="string" and type(blockerId)=="string" then
            local key="obstruction-relocation:"..operationId..":"..blockerId
            local group=result[key]
            if group==nil then
                group={relocationKey=key,operationId=operationId,blockerAssemblyId=blockerId,blockerAssemblyReferenceKey=relation.blockerAssemblyReferenceKey,relations={},beneficiaryIds={},beneficiarySet={}}
                result[key]=group
            end
            group.relations[#group.relations+1]=relation
            if type(relation.beneficiaryAssemblyId)=="string" and not group.beneficiarySet[relation.beneficiaryAssemblyId] then
                group.beneficiarySet[relation.beneficiaryAssemblyId]=true
                group.beneficiaryIds[#group.beneficiaryIds+1]=relation.beneficiaryAssemblyId
            end
        end
    end
    for _,group in OuttaMyWay.ValueRecord.pairs(result) do table.sort(group.beneficiaryIds) end
    return result
end

local function eligibleGroup(group)
    if group==nil or OuttaMyWay.ValueRecord.length(group.relations)==0 then return false end
    for _,relation in OuttaMyWay.ValueRecord.ipairs(group.relations) do
        if relation.blockerClassification~="NON_ACTIVE_UNCLAIMED" or relation.relocationEligible~=true then return false end
    end
    return true
end

local function relocationSerializationBeneficiaries(group,references)
    local result={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(group.beneficiaryIds or {}) do
        result[#result+1]={assemblyId=assemblyId,referenceKey=references[assemblyId]}
    end
    return result
end

local function boundedInwardObjective(snapshot,pose)
    local metrics=snapshot and snapshot.fieldWorld and snapshot.fieldWorld.geometryMetrics or nil
    local cx,cz=metrics and tonumber(metrics.centroidX),metrics and tonumber(metrics.centroidZ)
    if not finite(cx) or not finite(cz) then return nil,"FIELD_WORLD_CENTROID_UNAVAILABLE" end
    if pose==nil or not finite(pose.x) or not finite(pose.z) then return nil,"CURRENT_BLOCKER_REFERENCE_POSE_UNAVAILABLE" end
    local dx,dz=cx-pose.x,cz-pose.z
    local distance=math.sqrt(dx*dx+dz*dz)
    if distance<=0.05 then return nil,"CENTROID_BEARING_DEGENERATE" end
    local directionX,directionZ=dx/distance,dz/distance
    local cap=math.max(0,tonumber(OuttaMyWay.TERMINAL_INTERIOR_SETTLEMENT_MAX_DISTANCE_M) or 60.0)
    local progress=math.min(distance,cap)
    if progress<=0.05 then return nil,"BOUNDED_RELOCATION_PROGRESS_UNAVAILABLE" end
    return {
        objectiveKind="CAUSAL_OBSTRUCTION_BOUNDED_INWARD_RELOCATION",
        boundedInwardRelocation=true,
        destinationKind=progress+0.000001<distance and "CENTROID_BEARING_DISTANCE_CAP" or "FIELD_CENTROID",
        alignmentMode="FIXED_INITIAL_CENTRE_BEARING",
        fieldCentreX=cx,fieldCentreZ=cz,
        initialDistanceToCentreM=distance,
        infieldDirectionX=directionX,infieldDirectionZ=directionZ,
        targetProgressM=progress,retreatDistanceM=progress,
        targetX=pose.x+directionX*progress,targetZ=pose.z+directionZ*progress,
        maximumRelocationDistanceM=cap,
        distanceCapped=progress+0.000001<distance,
        continuousCourseCorrection=false,
        parking=false
    },nil
end

local function physicalSpec(picture,snapshot,group,context,references,pose)
    local objective,objectiveReason=boundedInwardObjective(snapshot,pose)
    if objective==nil then return nil,objectiveReason end
    local protected=relocationSerializationBeneficiaries(group,references)
    for _,item in OuttaMyWay.ValueRecord.ipairs(protected) do if type(item.referenceKey)~="string" then return nil,"BENEFICIARY_REFERENCE_UNAVAILABLE" end end
    if OuttaMyWay.ValueRecord.length(protected)==0 then return nil,"BENEFICIARY_UNAVAILABLE" end

    local constraints=allPassEvidence("Bounded Causal Obstruction relocation candidate")
    constraints.FIELD_WORLD_CONTAINMENT=packet("Bounded inward relocation uses the validated fixed centroid-bearing movement without claiming predictive full-sweep Field World containment",{predictiveContainmentClaim=false,routePlanning=false,maximumRelocationDistanceM=objective.maximumRelocationDistanceM},false)
    constraints.TRANSITION_CLEARANCE=packet("Positive-only representation does not authorise a boundary-away search or negative-clearance inference; each bounded inward actuation returns to fresh Reality",{negativeFutureClearanceAuthority=false,parking=false,routePlanning=false,repeatedActuationRequiresFreshPositiveObstruction=true},false)
    constraints.REPRESENTATION_FITNESS=packet("Current Physical Assembly pose and positive-conflict representation support only this bounded relocation reference",{representationId="current-obstruction-relocation:"..group.blockerAssemblyReferenceKey})
    constraints.CONTROL_CAPABILITY_AVAILABILITY=packet("Validated non-active direct movement mechanics supply current Player Claim/source-AI checks, opportunistic compaction, Vehicle Activity Context, forward-only fixed-direction actuation and neutralisation",{mechanicalDonor="NonJobActuationMechanism",authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false,relocationSerialization=true})
    constraints.CONTINUING_INTENT_PRIORITY=packet("Only active supported beneficiaries positively obstructed by this blocker are protected while it translates",{beneficiaryAssemblyIds=group.beneficiaryIds,productiveJobsRemainGiantsOwned=true})
    constraints.PROGRESS_PRESERVATION=packet("The non-active blocker has no supported productive progress to preserve; movement exists only to remove current Causal Obstruction",{parking=false,tidying=false})
    constraints.RESPONSIBILITY_COMPATIBILITY=packet("One relocation responsibility is keyed by Local Operation plus blocker Physical Assembly, aggregating pairwise beneficiaries",{relocationKey=group.relocationKey,blockerAssemblyId=group.blockerAssemblyId})
    constraints.OBLIGATION_COMPATIBILITY=packet("The same unresolved obstruction responsibility may authorise another bounded inward actuation only from fresh positive Causal Obstruction; no move-count budget or boundary-away stage exists",{repeatedActuationRequiresFreshPositiveObstruction=true,moveCountBudget=false,boundaryAwayStage=false})
    constraints.COMMITMENT_PRECONDITIONS=packet("Current Causal Obstruction, NON_ACTIVE_UNCLAIMED classification, current relocation pose and development consent are independently present",{relocationEligible=true,historicalJobProvenanceRequired=false,developmentConsent=OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS==true})
    constraints.EFFECTIVE_ACTUATION_COMPOSITION=packet("One retained Commitment owns OBSTRUCTION_RELOCATION_ACTUATION for the blocker and PROGRESS_ACTUATION only to protect active beneficiaries",{blockerAuthorityClass="OBSTRUCTION_RELOCATION_ACTUATION",serializedBeneficiaryAssemblyIds=group.beneficiaryIds})
    constraints.SAFE_RELEASE_HANDOVER=packet("Current Player Claim or source AI reactivation immediately outranks relocation; owned completion neutralises actuation before releasing Vehicle Activity Context",{playerClaimCurrentNotSticky=true,actuationNeutralisation=true,relocationSerializationRelease=true})

    local protectedIds={}
    local relevantIds={group.blockerAssemblyId}
    local compositionEntries={{assemblyId=group.blockerAssemblyId,commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="OBSTRUCTION_RELOCATION",obstructionRelocationActuation=true}}
    for _,item in OuttaMyWay.ValueRecord.ipairs(protected) do
        protectedIds[#protectedIds+1]=item.assemblyId
        relevantIds[#relevantIds+1]=item.assemblyId
        compositionEntries[#compositionEntries+1]={assemblyId=item.assemblyId,commitmentId="$NEW_COMMITMENT",capability="REGULATE_SPEED",effectClass="HOLD",progressActuation=true}
    end
    table.sort(protectedIds); table.sort(relevantIds)
    local existingCommitmentId=context and context.commitmentId or nil
    return {
        referenceKey=group.relocationKey..":bounded-inward-relocation",
        purpose={kind="CAUSAL_OBSTRUCTION_RELOCATION",result="REMOVE_CURRENT_CAUSAL_OBSTRUCTION"},
        subject={assemblyId=group.blockerAssemblyId},capability="REPOSITION",
        expectedEffect={physicalChange=true,phase="INFIELD",boundedInwardRelocation=true,oneFixedAlignment=true,parking=false},
        evidenceBasis={
            constraintEvidence=constraints,
            governingBasis={kind="CAUSAL_OBSTRUCTION_RELOCATION",responsibilityKey=group.relocationKey,operationIds={group.operationId},sourceIntentIds={},authorizingDemandAssemblyIds=protectedIds,blockerAssemblyId=group.blockerAssemblyId},
            progressActuationOwnership={assemblyIds=protectedIds},
            obstructionRelocationActuationOwnership={assemblyIds={group.blockerAssemblyId}},
            effectiveActuationComposition={identity="obstruction-relocation-composition:"..group.relocationKey..":"..picture.identity,epoch=picture.epoch,relevantAssemblyIds=relevantIds,entries=compositionEntries},
            maintainsExistingCommitment=existingCommitmentId~=nil,
            obstructionRelocationBridge={architecture="CAUSAL_OBSTRUCTION_RELOCATION",relocationKey=group.relocationKey,phase="INFIELD",operationId=group.operationId,blockerAssemblyId=group.blockerAssemblyId,blockerAssemblyReferenceKey=group.blockerAssemblyReferenceKey,objective=objective,objectiveReason=objectiveReason,existingCommitmentId=existingCommitmentId,relocationSerializationBeneficiaries=protected,authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false}
        },
        representationFitness={requirements={{representationId="current-obstruction-relocation:"..group.blockerAssemblyReferenceKey,acceptedStates={"USABLE_WITH_UNCERTAINTY","FIT_FOR_LIMITED_HORIZON","CURRENTLY_FIT"}}}},
        preconditions={evidenceContracts={{kind="CURRENT_CAUSAL_OBSTRUCTION",relocationKey=group.relocationKey},{kind="NON_ACTIVE_UNCLAIMED_BLOCKER"},{kind="CURRENT_PHYSICAL_RELOCATION_REFERENCE"}}},
        invalidationConditions={{kind="PLAYER_CLAIM"},{kind="SOURCE_AI_REACTIVATION"},{kind="BLOCKER_PHYSICAL_IDENTITY_LOST"}},
        reversibility={kind="BOUNDED_INWARD_RELOCATION_THEN_FRESH_REALITY"},
        obligationsCreated={{origin={kind="CAUSAL_OBSTRUCTION",relocationKey=group.relocationKey},basis={kind="CURRENT_CAUSAL_OBSTRUCTION",blockerAssemblyId=group.blockerAssemblyId,beneficiaryAssemblyIds=protectedIds},requiredOutcome={kind="CAUSAL_OBSTRUCTION_REMOVED_OR_ESCALATED"},requiredAuthority={classes={"OBSTRUCTION_RELOCATION_ACTUATION","PROGRESS_ACTUATION"}},evidenceContract={kind="FRESH_POSITIVE_CONTINUATION_AFTER_BOUNDED_RELOCATION"},ownershipClass="ORIGIN_BOUND",transferPolicy={allowed=false},terminalDependency=true,creationEvidence={relations=group.relations}}},
        releaseImplications={releaseBoundedAuthorityAfterActuation=true,freshSituationRequired=true,repeatedActuationRequiresFreshPositiveObstruction=true},
        uncertainty={{kind="NO_NEGATIVE_CLEARANCE_AUTHORITY"}},
        comparisonCost=1
    },nil
end

local function latestControlOutcome(picture,commitmentId)
    local latest=nil
    for _,outcome in OuttaMyWay.ValueRecord.ipairs(picture.controlOutcomeEvidence and picture.controlOutcomeEvidence.outcomes or {}) do
        local context=outcome.completionContext or {}
        if outcome.kind=="OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION" and context.triggerKind=="CURRENT_CAUSAL_OBSTRUCTION" and outcome.commitmentId==commitmentId then latest=outcome end
    end
    return latest
end

local function relationFor(picture,blockerAssemblyId,beneficiaryAssemblyId)
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.causalObstructionKnowledge or {}) do
        if relation.blockerAssemblyId==blockerAssemblyId and relation.beneficiaryAssemblyId==beneficiaryAssemblyId then return relation end
    end
    return nil
end

local function motionByAssembly(picture)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.motionEvidence or {}) do result[item.assemblyId]=item end
    return result
end

local function productiveByAssembly(picture)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture.productiveContinuationKnowledge or {}) do result[item.assemblyId]=item end
    return result
end

local function positiveMotion(item)
    if type(item)~="table" then return false end
    local class=item.motionClassification
    local moving=class=="STABLE_FORWARD" or class=="TURNING" or class=="REVERSING_OR_OPPOSED_TRAVEL"
    local speed=math.max(math.abs(tonumber(item.reportedSpeedMps) or 0),math.abs(tonumber(item.positionDerivedSpeedMps) or 0))
    return moving and speed>0.02
end

local function positiveSupportedContinuation(motion,productive)
    return positiveMotion(motion)
        and type(productive)=="table"
        and productive.productivePositive==true
        and productive.representationFitness=="FIT_FOR_LIMITED_HORIZON"
end

local function currentPlayerClaim(snapshot,referenceKey)
    local control=snapshot and snapshot.playerControl and snapshot.playerControl[referenceKey] or nil
    return type(control)=="table" and control.playerEnteredObserved==true and control.playerEntered==true
end

local function currentSourceAi(snapshot,referenceKey)
    local state=snapshot and snapshot.aiStates and snapshot.aiStates[referenceKey] or nil
    return type(state)=="table" and state.aiActiveObserved==true and state.aiActive==true
end

local function terminalSpec(context,eventKind,blockerAssemblyId,referenceKey,terminalReason)
    local basis=context.governingBasis or {}
    local constraints=allPassEvidence("Causal Obstruction relocation settlement consumes fresh current evidence and requests no new actuation")
    return {
        referenceKey=tostring(basis.responsibilityKey)..":settlement:"..eventKind,
        purpose={kind="CAUSAL_OBSTRUCTION_RELOCATION_SETTLEMENT",eventKind=eventKind},
        subject={assemblyId=blockerAssemblyId},capability=eventKind=="OBJECTIVE_FAILED" and "ESCALATE" or "CONTINUE_UNCHANGED",
        expectedEffect={physicalChange=false,terminalEvent=eventKind,playerEscalationRequired=eventKind=="OBJECTIVE_FAILED"},
        evidenceBasis={constraintEvidence=constraints,maintainsExistingCommitment=true,obstructionRelocationBridge={architecture="CAUSAL_OBSTRUCTION_RELOCATION",relocationKey=basis.responsibilityKey,terminalEvent=eventKind,terminalReason=terminalReason,blockerAssemblyId=blockerAssemblyId,blockerAssemblyReferenceKey=referenceKey,existingCommitmentId=context.commitmentId}},
        representationFitness={requirements={}},preconditions={evidenceContracts={}},invalidationConditions={},reversibility={kind="NOT_APPLICABLE_SETTLEMENT"},obligationsCreated={},releaseImplications={releasePhysicalAuthority=true},uncertainty={},comparisonCost=0
    }
end

local function waitingSpec(context,blockerAssemblyId,referenceKey)
    local basis=context.governingBasis or {}
    local constraints=allPassEvidence("Fresh positive supported beneficiary continuation has not yet discharged the Causal Obstruction responsibility")
    return {
        referenceKey=tostring(basis.responsibilityKey)..":wait-for-positive-continuation",
        purpose={kind="CAUSAL_OBSTRUCTION_RELOCATION_REASSESSMENT"},subject={assemblyId=blockerAssemblyId},capability="CONTINUE_OBSERVATION",
        expectedEffect={physicalChange=false,waitingForEvidence=true},
        evidenceBasis={constraintEvidence=constraints,maintainsExistingCommitment=true,existingProgressMayContinue=true,obstructionRelocationBridge={architecture="CAUSAL_OBSTRUCTION_RELOCATION",relocationKey=basis.responsibilityKey,phase="WAITING_FOR_EVIDENCE",blockerAssemblyId=blockerAssemblyId,blockerAssemblyReferenceKey=referenceKey,existingCommitmentId=context.commitmentId}},
        representationFitness={requirements={}},preconditions={evidenceContracts={{kind="FRESH_POSITIVE_SUPPORTED_CONTINUATION_REQUIRED"}}},invalidationConditions={{kind="PLAYER_CLAIM"},{kind="SOURCE_AI_REACTIVATION"}},reversibility={kind="OBSERVE_ONLY"},obligationsCreated={},releaseImplications={noActuation=true},uncertainty={{kind="OBSTRUCTION_CESSATION_OR_SUPPORTED_CONTINUATION_NOT_YET_POSITIVELY_ESTABLISHED"}},comparisonCost=0
    }
end

local function retainedPositiveGroup(picture,basis)
    local relocationKey=basis and basis.responsibilityKey or nil
    local blockerAssemblyId=basis and basis.blockerAssemblyId or nil
    if type(relocationKey)~="string" or type(blockerAssemblyId)~="string" then return nil end
    local source=activeRelationsByKey(picture)[relocationKey]
    if source==nil then return nil end
    local authorised={}
    for _,beneficiaryId in OuttaMyWay.ValueRecord.ipairs(basis.authorizingDemandAssemblyIds or {}) do authorised[beneficiaryId]=true end
    local group={relocationKey=relocationKey,operationId=source.operationId,blockerAssemblyId=blockerAssemblyId,blockerAssemblyReferenceKey=source.blockerAssemblyReferenceKey,relations={},beneficiaryIds={},beneficiarySet={}}
    for _,relation in OuttaMyWay.ValueRecord.ipairs(source.relations or {}) do
        local beneficiaryId=relation.beneficiaryAssemblyId
        if authorised[beneficiaryId]==true then
            group.relations[#group.relations+1]=relation
            if group.beneficiarySet[beneficiaryId]~=true then group.beneficiarySet[beneficiaryId]=true; group.beneficiaryIds[#group.beneficiaryIds+1]=beneficiaryId end
        end
    end
    if OuttaMyWay.ValueRecord.length(group.relations)==0 then return nil end
    table.sort(group.beneficiaryIds)
    return group
end

local function reassessmentSpec(picture,snapshot,context,references)
    local basis=context.governingBasis or {}
    local blockerAssemblyId=basis.blockerAssemblyId
    local blockerReferenceKey=references[blockerAssemblyId]
    if type(blockerAssemblyId)~="string" or type(blockerReferenceKey)~="string" then return nil,"BLOCKER_CONTEXT_UNAVAILABLE" end
    if currentPlayerClaim(snapshot,blockerReferenceKey) then return terminalSpec(context,"PLAYER_CLAIM",blockerAssemblyId,blockerReferenceKey),nil end
    if currentSourceAi(snapshot,blockerReferenceKey) then return terminalSpec(context,"NEW_AUTHORITATIVE_INTENT",blockerAssemblyId,blockerReferenceKey),nil end
    local outcome=latestControlOutcome(picture,context.commitmentId)
    if outcome==nil then return nil,"CONTROL_OUTCOME_NOT_YET_OBSERVED" end
    if outcome.status=="FAILED" then return terminalSpec(context,"OBJECTIVE_FAILED",blockerAssemblyId,blockerReferenceKey),nil end
    if outcome.status=="PLAYER_CLAIM" then return terminalSpec(context,"PLAYER_CLAIM",blockerAssemblyId,blockerReferenceKey),nil end
    if outcome.status=="SUPERSEDED" then return terminalSpec(context,"NEW_AUTHORITATIVE_INTENT",blockerAssemblyId,blockerReferenceKey),nil end
    if outcome.status~="MANOEUVRE_COMPLETE" then return waitingSpec(context,blockerAssemblyId,blockerReferenceKey),nil end

    local blockedGroup=retainedPositiveGroup(picture,basis)
    if blockedGroup~=nil then
        if eligibleGroup(blockedGroup) then
            local poses=posesByReference(snapshot)
            local specification,reason=physicalSpec(picture,snapshot,blockedGroup,context,references,poses[blockerReferenceKey])
            if specification~=nil then return specification,nil end
            if reason=="CENTROID_BEARING_DEGENERATE" or reason=="BOUNDED_RELOCATION_PROGRESS_UNAVAILABLE" then
                return terminalSpec(context,"OBJECTIVE_FAILED",blockerAssemblyId,blockerReferenceKey,"POSITIVE_CAUSAL_OBSTRUCTION_WITHOUT_MEANINGFUL_INWARD_RELOCATION_SPACE"),nil
            end
        end
        return waitingSpec(context,blockerAssemblyId,blockerReferenceKey),nil
    end

    local motion=motionByAssembly(picture)
    local productive=productiveByAssembly(picture)
    local beneficiaries=basis.authorizingDemandAssemblyIds or {}
    local allReleased=OuttaMyWay.ValueRecord.length(beneficiaries)>0
    for _,beneficiaryId in OuttaMyWay.ValueRecord.ipairs(beneficiaries) do
        if not positiveSupportedContinuation(motion[beneficiaryId],productive[beneficiaryId]) then allReleased=false; break end
    end
    if allReleased then return terminalSpec(context,"OBJECTIVE_SATISFIED",blockerAssemblyId,blockerReferenceKey),nil end
    return waitingSpec(context,blockerAssemblyId,blockerReferenceKey),nil
end

function Support.new(identityRegistry,epochSequence)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,publishedCount=0,lastStatus="INACTIVE"},Support)
end


-- Fresh-only Candidate Support Projection seam. It reuses the accepted cold
-- blocker classification and first-courtesy specification while binding the
-- group's generated composition evidence to the caller-owned target picture.
function Support:buildFreshProjectedGroup(picture,snapshot,targetPictureId,targetEpoch)
    OuttaMyWay.ValueRecord.assertType(picture,"OperationalPicture")
    OuttaMyWay.ValueRecord.assertType(snapshot,"ObservationSnapshot")
    if OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS~=true then return nil,"DEVELOPMENT_CONSENT_DISABLED" end
    if type(targetPictureId)~="string" or targetPictureId=="" or type(targetEpoch)~="number" then
        return nil,"TARGET_DECISION_PICTURE_REQUIRED"
    end
    local context,contextReason=genericContext(picture)
    if contextReason~=nil then return nil,contextReason end
    if context~=nil then return nil,"INCUMBENT_CONTEXT_REQUIRES_EXISTING_SINGLE_PURPOSE_PATH" end

    local references=referencesByAssembly(snapshot)
    local groups=activeRelationsByKey(picture)
    local poses=posesByReference(snapshot)
    local keys={}
    for key in OuttaMyWay.ValueRecord.pairs(groups) do keys[#keys+1]=key end
    table.sort(keys)
    local specifications={}
    local pictureBasis={identity=targetPictureId,epoch=targetEpoch}
    for _,key in OuttaMyWay.ValueRecord.ipairs(keys) do
        local group=groups[key]
        if eligibleGroup(group) and type(group.blockerAssemblyReferenceKey)=="string" then
            local specification=physicalSpec(pictureBasis,snapshot,group,nil,references,poses[group.blockerAssemblyReferenceKey])
            if specification~=nil then specifications[#specifications+1]=specification end
        end
    end
    if OuttaMyWay.ValueRecord.length(specifications)==0 then return nil,"NO_GENERIC_CAUSAL_OBSTRUCTION_ACTION" end

    return {
        supportBoundary={mode="CAUSAL_OBSTRUCTION_RELOCATION_TEST",supportedCandidateClasses={"REPOSITION","CONTINUE_OBSERVATION","CONTINUE_UNCHANGED","ESCALATE"},physicalCapabilitiesImplemented=true,controlAuthority="OBSTRUCTION_RELOCATION_ACTUATION_PLUS_PROTECTED_BENEFICIARY_HOLD",boundedScope="NON_ACTIVE_UNCLAIMED_BLOCKER_REPEATED_BOUNDED_INWARD_RELOCATION_WHILE_FRESH_POSITIVE_OBSTRUCTION_PERSISTS",parking=false,tidying=false,historicalJobProvenanceRequired=false,moveCountBudget=false},
        candidateSpecifications=specifications,
        representationFitness={},
        provenance={source="ObstructionRelocationCandidateSupport",observationSnapshotId=snapshot.identity,targetOperationalPictureId=targetPictureId,candidateSupportProjection=true}
    },nil
end

function Support:attach(picture,snapshot)
    if OuttaMyWay.AUTOMATIC_TERMINAL_EGRESS~=true then self.lastStatus="DEVELOPMENT_CONSENT_DISABLED"; return nil end
    local context,contextReason=genericContext(picture)
    if contextReason~=nil then self.lastStatus=contextReason; return nil end
    local references=referencesByAssembly(snapshot)
    local specifications={}
    if context~=nil then
        local specification,reason=reassessmentSpec(picture,snapshot,context,references)
        if specification==nil then self.lastStatus=reason or "GENERIC_REASSESSMENT_UNRESOLVED"; return nil end
        specifications[1]=specification
    else
        local groups=activeRelationsByKey(picture)
        local poses=posesByReference(snapshot)
        local keys={}
        for key in OuttaMyWay.ValueRecord.pairs(groups) do keys[#keys+1]=key end
        table.sort(keys)
        for _,key in OuttaMyWay.ValueRecord.ipairs(keys) do
            local group=groups[key]
            if eligibleGroup(group) and type(group.blockerAssemblyReferenceKey)=="string" then
                local specification=physicalSpec(picture,snapshot,group,nil,references,poses[group.blockerAssemblyReferenceKey])
                if specification~=nil then specifications[#specifications+1]=specification end
            end
        end
        if OuttaMyWay.ValueRecord.length(specifications)==0 then self.lastStatus="NO_GENERIC_CAUSAL_OBSTRUCTION_ACTION"; return nil end
    end

    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.identity=self.identities:issue("PICTURE")
    values.epoch=self.epochs:next()
    values.provenance={source="ObstructionRelocationCandidateSupport",parentOperationalPictureId=picture.identity,observationSnapshotId=snapshot.identity,authority="CAUSAL_OBSTRUCTION_RELOCATION_CANDIDATE_SUPPORT"}
    values.candidateSupportEvidence={complete=true,supportBoundary={mode="CAUSAL_OBSTRUCTION_RELOCATION_TEST",supportedCandidateClasses={"REPOSITION","CONTINUE_OBSERVATION","CONTINUE_UNCHANGED","ESCALATE"},physicalCapabilitiesImplemented=true,controlAuthority="OBSTRUCTION_RELOCATION_ACTUATION_PLUS_PROTECTED_BENEFICIARY_HOLD",boundedScope="NON_ACTIVE_UNCLAIMED_BLOCKER_REPEATED_BOUNDED_INWARD_RELOCATION_WHILE_FRESH_POSITIVE_OBSTRUCTION_PERSISTS",parking=false,tidying=false,historicalJobProvenanceRequired=false,moveCountBudget=false},candidateSpecifications=specifications,provenance={source="ObstructionRelocationCandidateSupport",observationSnapshotId=snapshot.identity}}
    self.publishedCount=self.publishedCount+1
    self.lastStatus="GENERIC_CAUSAL_OBSTRUCTION_CANDIDATES_PUBLISHED"
    return OuttaMyWay.OperationalPicture.new(values)
end

function Support:getPublishedCount() return self.publishedCount end
function Support:getLastStatus() return self.lastStatus end