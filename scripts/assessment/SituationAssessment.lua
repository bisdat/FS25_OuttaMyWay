OuttaMyWay.SituationAssessment = {}
local Assessment = OuttaMyWay.SituationAssessment
Assessment.__index = Assessment

local function copyValue(value, seen)
    if type(value) ~= "table" then return value end
    seen=seen or {}
    if seen[value] then return nil end
    seen[value]=true
    local result={}
    for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=copyValue(item,seen) end
    seen[value]=nil
    return result
end

local function appendContradiction(target,code,details)
    local item={code=code}
    for key,value in OuttaMyWay.ValueRecord.pairs(details or {}) do item[key]=value end
    target[#target+1]=item
end

local function sortedUnique(values)
    local seen, result = {}, {}
    for _, value in OuttaMyWay.ValueRecord.ipairs(values or {}) do if not seen[value] then seen[value]=true; result[#result+1]=value end end
    table.sort(result); return result
end

local function assemblyMap(snapshot)
    local map = {}
    for _, assembly in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies) do
        map[type(assembly.referenceKey) .. ":" .. tostring(assembly.referenceKey)] = assembly.assemblyId
        map[assembly.assemblyId] = assembly.assemblyId
    end
    return map
end

local function resolveAssembly(map, item, field)
    local direct = item.assemblyId or item[field or "assemblyReferenceKey"]
    local key = map[direct] and direct or (type(direct) .. ":" .. tostring(direct))
    local identity = map[key]
    if identity == nil then error("Situation Assessment cannot resolve assembly reference " .. tostring(direct), 3) end
    return identity
end

local function normalizeSpaces(values, map, kind)
    local result = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[#result + 1] = {
            identity = item.identity,
            assemblyId = resolveAssembly(map, item),
            kind = kind,
            occupancy = item.occupancy,
            alternatives = item.alternatives or {},
            horizon = item.horizon,
            validityDependencies = item.validityDependencies or {},
            uncertainty = item.uncertainty or {},
            provenance = item.provenance
        }
    end
    table.sort(result, function(a,b)
        if a.assemblyId ~= b.assemblyId then return a.assemblyId < b.assemblyId end
        return tostring(a.identity or "") < tostring(b.identity or "")
    end)
    return result
end

local demandMap = {
    COMMITTED_DEMAND = "committedDemand",
    POTENTIAL_DEMAND = "potentialDemand",
    TEMPORARY_SLACK = "temporarySlack"
}

local function normalizeMotion(values,map)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[#result+1]={
            assemblyId=resolveAssembly(map,item),assemblyReferenceKey=item.assemblyReferenceKey,name=item.name,sourceJobToken=item.sourceJobToken,
            reportedSpeedMps=item.reportedSpeedMps,positionDerivedSpeedMps=item.positionDerivedSpeedMps,
            travelDirectionX=item.travelDirectionX,travelDirectionZ=item.travelDirectionZ,headingX=item.headingX,headingZ=item.headingZ,
            headingToTravelDot=item.headingToTravelDot,motionClassification=item.motionClassification,motionReason=item.motionReason,
            sampleIntervalSeconds=item.sampleIntervalSeconds,blocked=item.blocked==true,localIntentClassification=item.localIntentClassification,
            intentEpoch=item.intentEpoch,intentValid=item.intentValid==true,nativeFieldWork=copyValue(item.nativeFieldWork),provenance=item.provenance
        }
    end
    table.sort(result,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    return result
end


local function productiveContinuationKnowledge(motionEvidence)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(motionEvidence or {}) do
        local raw=item.nativeFieldWork or {}
        local positive=raw.segmentAvailable==true and raw.isTurn~=true and raw.implementLineClassification=="ACTIVE"
        local evidenceClass="UNRESOLVED"
        if raw.segmentAvailable~=true then evidenceClass="SEGMENT_UNRESOLVED"
        elseif raw.isTurn==true then evidenceClass="TURN_SEGMENT"
        elseif raw.implementLineClassification=="ACTIVE" then evidenceClass="NON_TURN_LINE_ACTIVE"
        elseif raw.implementLineClassification=="INACTIVE" then evidenceClass="NON_TURN_LINE_INACTIVE"
        elseif raw.implementLineClassification=="MIXED" then evidenceClass="NON_TURN_LINE_MIXED"
        else evidenceClass="NON_TURN_LINE_UNRESOLVED" end
        result[#result+1]={
            assemblyId=item.assemblyId,assemblyReferenceKey=item.assemblyReferenceKey,jobToken=item.sourceJobToken,
            evidenceClass=evidenceClass,productivePositive=positive,
            segmentAvailable=raw.segmentAvailable==true,isTurn=raw.isTurn,movingDirection=raw.movingDirection,
            implementLineClassification=raw.implementLineClassification,
            representationFitness=positive and "FIT_FOR_LIMITED_HORIZON" or "UNRESOLVED",
            provenance={source="SituationAssessment.ProductiveContinuation",layer="KNOWLEDGE",authority="POSITIVE_PRODUCTIVE_ONLY",observationSource=raw.provenance and raw.provenance.source or nil}
        }
    end
    table.sort(result,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    return result
end


local function assemblyIdForReference(map, referenceKey)
    if referenceKey==nil then return nil end
    return map[type(referenceKey)..":"..tostring(referenceKey)] or map[referenceKey]
end

local function normalizePhysicalSpace(values,map)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        result[#result+1]={
            assemblyId=resolveAssembly(map,item),assemblyReferenceKey=item.assemblyReferenceKey,episodeKey=item.episodeKey,
            configurationProfileId=item.configurationProfileId,configurationEvidence=copyValue(item.configurationEvidence or {}),configurationAlternatives=copyValue(item.configurationAlternatives or {}),directionalPassageEnvelope=copyValue(item.directionalPassageEnvelope),transitPassageEnvelope=copyValue(item.transitPassageEnvelope),transitPassageReason=item.transitPassageReason,transitFoldCapability=copyValue(item.transitFoldCapability),primitives=item.primitives or {},summary=item.summary,
            coverageComplete=item.coverageComplete==true,negativeClearanceAuthority=item.negativeClearanceAuthority==true,
            provenance=item.provenance
        }
    end
    table.sort(result,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)
    return result
end

local function normalizeDemand(values, map)
    local result = { committedDemand={}, potentialDemand={}, temporarySlack={} }
    for _, item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        local bucket = demandMap[item.class]
        if bucket == nil then error("unsupported demand class " .. tostring(item.class), 3) end
        local entry = {
            identity = item.identity,
            assemblyId = item.assemblyReferenceKey and resolveAssembly(map,item) or item.assemblyId,
            operationId = item.operationId,
            space = item.space,
            horizon = item.horizon,
            basis = item.basis,
            uncertainty = item.uncertainty or {},
            provenance = item.provenance
        }
        result[bucket][#result[bucket]+1] = entry
    end
    for _, bucket in OuttaMyWay.ValueRecord.pairs(result) do table.sort(bucket,function(a,b) return tostring(a.identity or a.assemblyId or "") < tostring(b.identity or b.assemblyId or "") end) end
    return result
end

function Assessment.new(identityRegistry, epochSequence, jobEpisodes, operations, commitments, obligations, causalObstructionAssessment)
    local self = setmetatable({}, Assessment)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.jobEpisodes = jobEpisodes
    self.operations = operations
    self.commitments = commitments
    self.obligations = obligations
    self.causalObstructionAssessment=causalObstructionAssessment
    self.spatialConstraintAssessment=OuttaMyWay.SpatialConstraintAssessment.new()
    self.publishedCount = 0
    self.latestProductiveContinuationByReference={}
    self.trajectoryTracks={}
    return self
end

function Assessment:assess(snapshot, episodeResult, operationResult)
    OuttaMyWay.ValueRecord.assertType(snapshot, "ObservationSnapshot")
    OuttaMyWay.ValueRecord.assertType(episodeResult, "JobEpisodeAdmissionResult")
    OuttaMyWay.ValueRecord.assertType(operationResult, "OperationAdmissionResult")
    local map = assemblyMap(snapshot)
    local activeOperationIds = {}; for _, id in OuttaMyWay.ValueRecord.ipairs(operationResult.activeOperationIds) do activeOperationIds[#activeOperationIds+1]=id end
    local currentSpace = normalizeSpaces(snapshot.geometry.currentSpaceEvidence or {}, map, "CURRENT_SPACE")
    local futureSpace = normalizeSpaces(snapshot.geometry.futureSpaceEvidence or {}, map, "FUTURE_SPACE")
    local demand = normalizeDemand(snapshot.geometry.demandEvidence or {}, map)
    local motionEvidence = normalizeMotion(snapshot.motion.progressionEvidence or {}, map)
    local physicalSpaceEvidence = normalizePhysicalSpace(snapshot.geometry.planViewOccupancyEvidence or {}, map)
    local productiveKnowledge = productiveContinuationKnowledge(motionEvidence)
    self.latestProductiveContinuationByReference={}
    for _,evidence in OuttaMyWay.ValueRecord.ipairs(productiveKnowledge) do
        self.latestProductiveContinuationByReference[evidence.assemblyReferenceKey]=copyValue(evidence)
    end
    local sourceDiagnostics = snapshot.diagnostics or {}

    local relevant = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(currentSpace) do relevant[#relevant+1]=item.assemblyId end
    for _, item in OuttaMyWay.ValueRecord.ipairs(futureSpace) do relevant[#relevant+1]=item.assemblyId end
    for _, bucket in OuttaMyWay.ValueRecord.pairs(demand) do for _, item in OuttaMyWay.ValueRecord.ipairs(bucket) do if item.assemblyId then relevant[#relevant+1]=item.assemblyId end end end

    local situations = {}
    local situationByOperation={}
    local operationMembership={}
    local operationEvidenceByAssembly={}
    for _,evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.operationMembershipEvidence or {}) do
        operationEvidenceByAssembly[resolveAssembly(map,evidence)]=evidence
    end
    for _, operationId in OuttaMyWay.ValueRecord.ipairs(activeOperationIds) do
        local operation = self.operations:get(operationId)
        local memberSet={}
        local resolutionSpaceAssemblyIds={}
        local resolutionSpaceParticipation={}
        for _, id in OuttaMyWay.ValueRecord.ipairs(operation.memberAssemblyIds) do
            relevant[#relevant+1]=id
            memberSet[id]=true
            resolutionSpaceAssemblyIds[#resolutionSpaceAssemblyIds+1]=id
            resolutionSpaceParticipation[id]={
                class="OPERATION_MEMBER",operationMember=true,resolutionSpaceEligible=true,
                productiveCommencementPending=false,fieldWorldReferenceKey=operation.fieldWorldReferenceKey,
                provenance={source="OperationAdmission",authority="ACTIVE_OPERATION_MEMBERSHIP"}
            }
        end
        -- Operational Membership and Situation Relevance are deliberately distinct.
        -- An active GIANTS field-work worker whose Job Episode has not yet shown a
        -- positive productive-commencement witness is not yet a cooperative Operation
        -- participant, but it may already constrain a productive member of this Field
        -- World.  Keep GIANTS in control of that unrevealed job-entry intent while
        -- allowing D-0146 Resolution-Space Conservation to regulate/hold the known
        -- productive member. Completed/non-active workers are excluded from this class.
        for assemblyId,evidence in OuttaMyWay.ValueRecord.pairs(operationEvidenceByAssembly) do
            local details=evidence.evidence or {}
            if memberSet[assemblyId]~=true
                and evidence.fieldWorldReferenceKey==operation.fieldWorldReferenceKey
                and details.activeJobVehicleMembership==true
                and details.fieldWorkerSpecializationPresent==true
                and details.productiveWorkCommenced~=true then
                relevant[#relevant+1]=assemblyId
                resolutionSpaceAssemblyIds[#resolutionSpaceAssemblyIds+1]=assemblyId
                resolutionSpaceParticipation[assemblyId]={
                    class="ACTIVE_JOB_INTENT_REVELATION_PENDING",operationMember=false,resolutionSpaceEligible=true,
                    productiveCommencementPending=true,fieldWorldReferenceKey=evidence.fieldWorldReferenceKey,
                    provenance={source="OperationMembershipEvidence",authority="SAME_FIELD_WORLD_ACTIVE_JOB_INTENT_REVELATION_PENDING"}
                }
            end
        end
        resolutionSpaceAssemblyIds=sortedUnique(resolutionSpaceAssemblyIds)
        operationMembership[operationId]=memberSet
        local situation={
            identity = self.identities:resolve("SITUATION", operationId),
            operationId = operationId,
            memberAssemblyIds = operation.memberAssemblyIds,
            resolutionSpaceAssemblyIds = resolutionSpaceAssemblyIds,
            resolutionSpaceParticipation = resolutionSpaceParticipation,
            relevantAssemblyIds = {},
            futureSpaceRelationships = {},
            opposedCorridorRelationships = {},
            spatialConstraintKnowledge = nil,
            provenance = { observationSnapshotId=snapshot.identity, operationRevision=operation.revision }
        }
        situations[#situations+1]=situation
        situationByOperation[operationId]=situation
    end

    for _, item in OuttaMyWay.ValueRecord.ipairs(snapshot.geometry.futureSpaceRelationshipEvidence or {}) do
        local subject=resolveAssembly(map,item,"subjectAssemblyReferenceKey")
        local other=resolveAssembly(map,item,"otherAssemblyReferenceKey")
        relevant[#relevant+1]=subject; relevant[#relevant+1]=other
        local operationId=nil
        for _,candidateOperationId in OuttaMyWay.ValueRecord.ipairs(activeOperationIds) do
            local members=operationMembership[candidateOperationId] or {}
            if members[subject] and members[other] then operationId=candidateOperationId; break end
        end
        if operationId~=nil then
            local classification="UNRESOLVED"
            if item.positiveIntersection==true then classification="FUTURE_SPACE_INTERSECTION"
            elseif item.subjectLocalIntentClassification=="TURNING" or item.otherLocalIntentClassification=="TURNING" then classification="MANOEUVRING" end
            local relationship={
                interactionReferenceKey=item.interactionReferenceKey,
                subjectAssemblyId=subject,otherAssemblyId=other,
                classification=classification,
                positiveIntersection=item.positiveIntersection==true,
                unresolved=item.unresolved==true,
                outcome=item.outcome,
                subjectLocalIntentClassification=item.subjectLocalIntentClassification,
                otherLocalIntentClassification=item.otherLocalIntentClassification,
                subjectIntentEpoch=item.subjectIntentEpoch,otherIntentEpoch=item.otherIntentEpoch,
                subjectBoundaryDistance=item.subjectBoundaryDistance,otherBoundaryDistance=item.otherBoundaryDistance,
                distance=item.distance,required=item.required,authority=item.authority,
                negativeClearanceAuthority=false,
                provenance=item.provenance
            }
            local situation=situationByOperation[operationId]
            situation.futureSpaceRelationships[#situation.futureSpaceRelationships+1]=relationship
        end
    end
    for _,situation in OuttaMyWay.ValueRecord.ipairs(situations) do
        table.sort(situation.futureSpaceRelationships,function(a,b) return tostring(a.interactionReferenceKey)<tostring(b.interactionReferenceKey) end)
    end

    local interactionEvidenceByKey={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(snapshot.geometry.interactionEvidence or {}) do
        local subject=resolveAssembly(map,item,"subjectAssemblyReferenceKey")
        local other=resolveAssembly(map,item,"otherAssemblyReferenceKey")
        relevant[#relevant+1]=subject; relevant[#relevant+1]=other
        if item.interactionReferenceKey==nil then error("interaction evidence requires interactionReferenceKey",2) end
        local pairKey=OuttaMyWay.LiveInteractionObservation.pairReferenceKey(
            item.subjectAssemblyReferenceKey,item.otherAssemblyReferenceKey)
        interactionEvidenceByKey[pairKey]=item
    end

    local currentPairAssessmentScope=OuttaMyWay.CurrentPairAssessmentScope.build(
        snapshot,activeOperationIds,self.operations,self.jobEpisodes)
    local pairScopeByReference={}
    for _,pair in OuttaMyWay.ValueRecord.ipairs(currentPairAssessmentScope) do
        pairScopeByReference[pair.pairReferenceKey]=pair
    end

    local responsibilityRelations = {}
    for _, item in OuttaMyWay.ValueRecord.ipairs(snapshot.motion.closureEvidence or {}) do
        if item.closingObserved == true then
            responsibilityRelations[#responsibilityRelations+1] = {
                relation = "FOLLOWER_OWNS_CLOSURE",
                followerAssemblyId = resolveAssembly(map,item,"followerAssemblyReferenceKey"),
                leaderAssemblyId = resolveAssembly(map,item,"leaderAssemblyReferenceKey"),
                closingRate = item.closingRate,
                horizon = item.horizon,
                provenance = item.provenance
            }
        end
    end
    table.sort(responsibilityRelations,function(a,b) return a.followerAssemblyId < b.followerAssemblyId end)

    local representationFitness, uncertainty = {}, {}
    for _, evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.physicalRepresentationEvidence) do
        local fitness = OuttaMyWay.RepresentationFitness.evaluate(evidence,snapshot)
        representationFitness[#representationFitness+1] = fitness
        relevant[#relevant+1] = fitness.assemblyId
        if fitness.state ~= "CURRENTLY_FIT" then
            uncertainty[#uncertainty+1] = { class="REPRESENTATION_FITNESS", subjectId=fitness.representationId, state=fitness.state, provenance=fitness.provenance }
        end
    end
    for _, source in OuttaMyWay.ValueRecord.ipairs(snapshot.unavailableSources) do
        uncertainty[#uncertainty+1] = { class="UNAVAILABLE_SOURCE", source=source, provenance={observationSnapshotId=snapshot.identity} }
    end
    if operationResult.membershipEvidenceComplete ~= true then
        uncertainty[#uncertainty+1] = { class="OPERATION_MEMBERSHIP_INCOMPLETE", provenance={observationSnapshotId=snapshot.identity} }
    end

    local operationByAssembly={}
    local activeOperationMemberSet={}
    for _,operationId in OuttaMyWay.ValueRecord.ipairs(activeOperationIds) do
        local operation=self.operations:get(operationId)
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(operation.memberAssemblyIds or {}) do
            operationByAssembly[assemblyId]=operationId
            activeOperationMemberSet[assemblyId]=true
        end
    end
    local activeOperationMemberCount=0
    for _ in OuttaMyWay.ValueRecord.pairs(activeOperationMemberSet) do activeOperationMemberCount=activeOperationMemberCount+1 end

    local causalObstructionKnowledge={}
    if self.causalObstructionAssessment~=nil then
        causalObstructionKnowledge=self.causalObstructionAssessment:assess(
            snapshot,futureSpace,physicalSpaceEvidence,activeOperationMemberSet,operationByAssembly
        )
        for _,relation in OuttaMyWay.ValueRecord.ipairs(causalObstructionKnowledge) do
            relevant[#relevant+1]=relation.beneficiaryAssemblyId
            relevant[#relevant+1]=relation.blockerAssemblyId
        end
    end

    local representationByAssembly={}
    for _,fitness in OuttaMyWay.ValueRecord.ipairs(representationFitness) do representationByAssembly[fitness.assemblyId]=fitness end

    local diagnosticContradictions={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(sourceDiagnostics.contradictions or {}) do diagnosticContradictions[#diagnosticContradictions+1]=copyValue(item) end
    local pairPipeline={}
    local pairByReference={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(sourceDiagnostics.pairDiagnostics or {}) do
        local subject=resolveAssembly(map,item,"subjectAssemblyReferenceKey")
        local other=resolveAssembly(map,item,"otherAssemblyReferenceKey")
        local subjectOperation=operationByAssembly[subject]
        local otherOperation=operationByAssembly[other]
        local sameOperation=subjectOperation~=nil and subjectOperation==otherOperation
        local pairScope=pairScopeByReference[item.pairReferenceKey]
        local received=interactionEvidenceByKey[item.pairReferenceKey]~=nil
        local subjectFitness=representationByAssembly[subject]
        local otherFitness=representationByAssembly[other]
        local pipeline=copyValue(item)
        pipeline.subjectAssemblyId=subject; pipeline.otherAssemblyId=other
        pipeline.sameOperation=sameOperation
        pipeline.operationId=sameOperation and subjectOperation or nil
        pipeline.interactionEvidenceReceived=received
        pipeline.currentPairScopePresent=pairScope~=nil
        pipeline.currentPairRelationshipStatus=pairScope and pairScope.relationshipStatus or nil
        pipeline.currentSpaceStatus=pairScope and pairScope.currentSpaceStatus or nil
        pipeline.futureSpaceStatus=pairScope and pairScope.futureSpaceStatus or nil
        pipeline.subjectJobEpisodeId=pairScope and pairScope.subjectJobEpisodeId or nil
        pipeline.otherJobEpisodeId=pairScope and pairScope.otherJobEpisodeId or nil
        pipeline.subjectRepresentationFitnessState=subjectFitness and subjectFitness.state or nil
        pipeline.otherRepresentationFitnessState=otherFitness and otherFitness.state or nil
        pipeline.episodeSignature=pairScope and pairScope.episodeSignature
            or (tostring(item.subjectSourceJobToken).."|"..tostring(item.otherSourceJobToken))
        pairPipeline[#pairPipeline+1]=pipeline
        pairByReference[item.pairReferenceKey]=pipeline
        if sameOperation and item.subjectActive==true and item.otherActive==true and item.evaluated~=true then
            appendContradiction(diagnosticContradictions,"SAME_OPERATION_ACTIVE_PAIR_NOT_EVALUATED",{pairReferenceKey=item.pairReferenceKey,operationId=subjectOperation,exclusionReason=item.exclusionReason})
        end
        if item.interactionEvidenceEmitted==true and not received then
            appendContradiction(diagnosticContradictions,"INTERACTION_EVIDENCE_HANDOFF_LOST",{pairReferenceKey=item.pairReferenceKey,operationId=subjectOperation})
        end
        if received and pairScope==nil then
            appendContradiction(diagnosticContradictions,"INTERACTION_EVIDENCE_WITHOUT_CURRENT_PAIR_SCOPE",{pairReferenceKey=item.pairReferenceKey,operationId=subjectOperation})
        end
        if sameOperation and item.subjectBlocked==true and item.otherBlocked==true
            and (pairScope==nil or pairScope.relationshipStatus~="POSITIVE") then
            appendContradiction(diagnosticContradictions,"BOTH_WORKERS_BLOCKED_WITH_UNRESOLVED_CURRENT_PAIR",{pairReferenceKey=item.pairReferenceKey,operationId=subjectOperation})
        end
    end
    table.sort(pairPipeline,function(a,b) return tostring(a.pairReferenceKey)<tostring(b.pairReferenceKey) end)

    local currentPairScopeDiagnostics={}
    for _,pair in OuttaMyWay.ValueRecord.ipairs(currentPairAssessmentScope) do
        currentPairScopeDiagnostics[#currentPairScopeDiagnostics+1]={
            pairReferenceKey=pair.pairReferenceKey,operationId=pair.operationId,
            relationshipStatus=pair.relationshipStatus,relationship=pair.relationship,
            currentSpaceStatus=pair.currentSpaceStatus,futureSpaceStatus=pair.futureSpaceStatus,
            subjectAssemblyId=pair.subjectAssemblyId,otherAssemblyId=pair.otherAssemblyId,
            subjectJobEpisodeId=pair.subjectJobEpisodeId,otherJobEpisodeId=pair.otherJobEpisodeId,
            episodeSignature=pair.episodeSignature,negativeClearanceAuthority=false
        }
    end
    table.sort(currentPairScopeDiagnostics,function(a,b) return tostring(a.pairReferenceKey)<tostring(b.pairReferenceKey) end)

    local assemblyDiagnostics={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(sourceDiagnostics.assemblyDiagnostics or {}) do
        local copied=copyValue(item)
        local assemblyId=resolveAssembly(map,item)
        local fitness=representationByAssembly[assemblyId]
        copied.assemblyId=assemblyId
        copied.operationId=operationByAssembly[assemblyId]
        copied.representationFitnessState=fitness and fitness.state or nil
        copied.representationClaimPermissions=fitness and fitness.claimPermissions or {}
        assemblyDiagnostics[#assemblyDiagnostics+1]=copied
    end
    table.sort(assemblyDiagnostics,function(a,b) return tostring(a.assemblyReferenceKey)<tostring(b.assemblyReferenceKey) end)

    local sourceCounters=sourceDiagnostics.sourceCounters or {}
    local diagnostics={
        counters={
            cycleActiveJobVehicleCount=sourceCounters.cycleActiveJobVehicleCount or 0,
            cycleRelevantVehicleCount=sourceCounters.cycleRelevantVehicleCount or 0,
            groupWorkerCount=sourceCounters.groupWorkerCount or 0,
            activeGroupWorkerCount=sourceCounters.activeGroupWorkerCount or 0,
            poseResolvedWorkerCount=sourceCounters.poseResolvedWorkerCount or 0,
            activeOperationMemberCount=activeOperationMemberCount,
            causalObstructionCount=#causalObstructionKnowledge,
            mathematicallyPossiblePairCount=sourceCounters.mathematicallyPossiblePairCount or 0,
            relevantPairCount=sourceCounters.relevantPairCount or 0,
            eligiblePairCount=sourceCounters.eligiblePairCount or 0,
            evaluatedPairCount=sourceCounters.evaluatedPairCount or 0,
            excludedPairCount=sourceCounters.excludedPairCount or 0,
            qualifyingPairCount=sourceCounters.qualifyingPairCount or 0,
            interactionEvidenceEmittedCount=sourceCounters.interactionEvidenceEmittedCount or 0,
            interactionEvidenceReceivedCount=OuttaMyWay.ValueRecord.length(snapshot.geometry.interactionEvidence or {}),
            operationSituationCount=#situations,
            currentPairAssessmentCount=#currentPairAssessmentScope
        },
        assemblyDiagnostics=assemblyDiagnostics,
        pairPipeline=pairPipeline,
        currentPairScopeDiagnostics=currentPairScopeDiagnostics,
        contradictions=diagnosticContradictions,
        provenance={source="SituationAssessment diagnostic handoff",observationSnapshotId=snapshot.identity}
    }

    relevant = sortedUnique(relevant)
    for _, situation in OuttaMyWay.ValueRecord.ipairs(situations) do situation.relevantAssemblyIds = relevant end

    local componentIds = {}
    local assemblyIds = {}
    for _, assembly in OuttaMyWay.ValueRecord.ipairs(snapshot.assemblies) do
        assemblyIds[#assemblyIds+1]=assembly.assemblyId
        for _, id in OuttaMyWay.ValueRecord.ipairs(assembly.componentIds) do componentIds[#componentIds+1]=id end
    end

    local commitmentContext = {}
    for _, commitment in OuttaMyWay.ValueRecord.ipairs(self.commitments:list()) do
        if not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
            local openObligations={}
            if self.obligations~=nil then
                for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.obligations:openForOwner(commitment.identity)) do
                    openObligations[#openObligations+1]={
                        identity=obligation.identity,origin=obligation.origin,basis=obligation.basis,requiredOutcome=obligation.requiredOutcome,
                        requiredAuthority=obligation.requiredAuthority,evidenceContract=obligation.evidenceContract,ownershipClass=obligation.ownershipClass,
                        terminalDependency=obligation.terminalDependency,status=obligation.status,epoch=obligation.epoch,revision=obligation.revision
                    }
                end
            end
            commitmentContext[#commitmentContext+1] = {
                commitmentId=commitment.identity,
                identity=commitment.identity,
                lifecycleState=commitment.state,
                governingBasis=commitment.governingBasis,
                situationDependencies=commitment.situationDependencies,
                obligationIds=commitment.obligationIds,
                openObligations=openObligations,
                progressActuationOwnership=commitment.progressActuationOwnership,
                capabilityReservations=commitment.capabilityReservations,
                effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
                evidenceContracts=commitment.evidenceContracts
            }
        end
    end

    local trajectoryKnowledge=OuttaMyWay.TrajectoryConflictAssessment.updateTrajectories(self.trajectoryTracks,{
        observationSnapshotId=snapshot.identity,timestamp=snapshot.timestamp,
        motionEvidence=motionEvidence,currentSpace=currentSpace,productiveKnowledge=productiveKnowledge
    })
    local opposedCorridorKnowledge=OuttaMyWay.TrajectoryConflictAssessment.classifyPairs({
        situations=situations,trajectoryKnowledge=trajectoryKnowledge,motionEvidence=motionEvidence,currentSpace=currentSpace,
        physicalSpaceEvidence=physicalSpaceEvidence,
        actionSpaceMaxSeparationM=OuttaMyWay.COOPERATIVE_PASSAGE_LOCAL_MAX_ENTRY_SEPARATION_M
    })
    for _,relation in OuttaMyWay.ValueRecord.ipairs(opposedCorridorKnowledge) do
        local situation=situationByOperation[relation.operationId]
        if situation~=nil then situation.opposedCorridorRelationships[#situation.opposedCorridorRelationships+1]=copyValue(relation) end
    end

    -- D-0141 follower-purpose reassessment consumes the stronger D-0146
    -- trajectory relationship witness.  This ordering is intentional: stale
    -- follower Regulation must retire before Candidate selection when current
    -- Reality has succeeded into Established Opposed Corridor Conflict or has
    -- positively passed the former follower relationship.
    local followerBoundaryKnowledge=OuttaMyWay.FollowerBoundaryDemandAssessment.buildKnowledge({
        currentSpace=currentSpace,futureSpace=futureSpace,motionEvidence=motionEvidence,productiveKnowledge=productiveKnowledge,
        opposedCorridorKnowledge=opposedCorridorKnowledge,
        commitmentContext=commitmentContext,operationByAssembly=operationByAssembly
    })

    -- Established follower relationships are assessed first. Prospective
    -- geometry remains visible, but cannot displace that incumbent ownership.
    local spatialConstraintKnowledge={}
    for _,operationId in OuttaMyWay.ValueRecord.ipairs(activeOperationIds) do
        local situation=situationByOperation[operationId]
        if situation~=nil then
            local knowledge=self.spatialConstraintAssessment:assess({
                operationId=operationId,assemblyIds=situation.memberAssemblyIds,
                fieldWorld=snapshot.fieldWorld,fieldWorldReferenceKey=self.operations:get(operationId).fieldWorldReferenceKey,
                futureSpace=futureSpace,motionEvidence=motionEvidence,followerBoundaryKnowledge=followerBoundaryKnowledge
            })
            situation.spatialConstraintKnowledge=knowledge
            spatialConstraintKnowledge[#spatialConstraintKnowledge+1]=knowledge
        end
    end

    -- D-0146 Step 2: Situation owns only purpose-specific mechanical
    -- Representation Fitness. Candidate responsibility later searches Local
    -- Passage Space and chooses the sufficient Arrangement/Guide.
    local cooperativePassageFitness=OuttaMyWay.PassageCapabilityAssessment.buildFitness({
        opposedCorridorKnowledge=opposedCorridorKnowledge,motionEvidence=motionEvidence,physicalSpaceEvidence=physicalSpaceEvidence
    })
    for _,fitness in OuttaMyWay.ValueRecord.ipairs(cooperativePassageFitness or {}) do
        representationFitness[#representationFitness+1]=fitness
    end

    -- D-0184: retired D-0143 CooperativePassageAssessment implementation is deleted.
    -- Production Situation Assessment publishes no D-0143 knowledge or fitness;
    -- D-0146 owns current Cooperative Passage fitness.
    local cooperativePassageKnowledge={}
    table.sort(representationFitness,function(a,b) return tostring(a.representationId)<tostring(b.representationId) end)

    local candidateSupportEvidence = {
        currentSpaceEvidenceCount=#currentSpace,
        futureSpaceEvidenceCount=#futureSpace,
        demandEvidenceCount=#demand.committedDemand + #demand.potentialDemand + #demand.temporarySlack,
        representationEvidenceCount=#representationFitness,
        interactionEvidenceCount=OuttaMyWay.ValueRecord.length(snapshot.geometry.interactionEvidence or {}),
        provenance={observationSnapshotId=snapshot.identity}
    }

    local picture = OuttaMyWay.OperationalPicture.new({
        identity=self.identities:issue("PICTURE"),
        epoch=self.epochs:next(),
        observationSnapshotId=snapshot.identity,
        situations=situations,
        currentPairAssessmentScope=currentPairAssessmentScope,
        identities={
            assemblies=sortedUnique(assemblyIds),
            components=sortedUnique(componentIds),
            jobEpisodes={active=episodeResult.activeEpisodeIds, admitted=episodeResult.admittedEpisodeIds, ended=episodeResult.endedEpisodeIds},
            operations={active=operationResult.activeOperationIds, ended=operationResult.endedOperationIds}
        },
        currentSpace=currentSpace,
        futureSpace=futureSpace,
        demand=demand,
        responsibilityRelations=responsibilityRelations,
        motionEvidence=motionEvidence,
        physicalSpaceEvidence=physicalSpaceEvidence,
        productiveContinuationKnowledge=productiveKnowledge,
        followerBoundaryKnowledge=followerBoundaryKnowledge,
        trajectoryKnowledge=trajectoryKnowledge,
        opposedCorridorKnowledge=opposedCorridorKnowledge,
        spatialConstraintKnowledge=spatialConstraintKnowledge,
        cooperativePassageKnowledge=cooperativePassageKnowledge,
        causalObstructionKnowledge=causalObstructionKnowledge,
        uncertainty=uncertainty,
        representationFitness=representationFitness,
        provenance={source="SituationAssessment", observationSnapshotId=snapshot.identity, observationEpoch=snapshot.epoch},
        controlOutcomeEvidence={sourceObservationSnapshotId=snapshot.identity,outcomes=snapshot.controlOutcomes},
        candidateSupportEvidence=candidateSupportEvidence,
        commitmentContext=commitmentContext,
        diagnostics=diagnostics
    })
    self.publishedCount = self.publishedCount + 1
    return picture
end


function Assessment:resetSituationKnowledge()
    self.trajectoryTracks={}
    self.latestProductiveContinuationByReference={}
    if self.spatialConstraintAssessment~=nil then self.spatialConstraintAssessment:reset() end
end

function Assessment:getEvidence(referenceKeyValue, jobToken)
    local evidence=self.latestProductiveContinuationByReference and self.latestProductiveContinuationByReference[referenceKeyValue] or nil
    if evidence==nil then return nil end
    if jobToken~=nil and evidence.jobToken~=jobToken then return nil end
    return copyValue(evidence)
end

function Assessment:getPublishedCount() return self.publishedCount end
