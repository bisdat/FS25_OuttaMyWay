--- Interprets purpose-scoped boundary-demand representation into Category-2 Situation meaning.
-- Specification Jurisdiction: SITUATION_ASSESSMENT
-- This assessment is independent of Forward Intersection. It publishes no
-- Candidate, Decision, Responsibility Transition or Control authority.

OuttaMyWay.BoundaryDemandAssessment={}
local Assessment=OuttaMyWay.BoundaryDemandAssessment
Assessment.__index=Assessment

local INTENT_REVELATION_CREEP_KMH=1

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function byAssembly(values)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(value)=="table" and type(value.assemblyId)=="string" then result[value.assemblyId]=value end
    end
    return result
end

local function copyValue(value,seen)
    if type(value)~="table" then return value end
    seen=seen or {}
    if seen[value]~=nil then return seen[value] end
    local result={}
    seen[value]=result
    for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[copyValue(key,seen)]=copyValue(item,seen) end
    return result
end

local function pairIdentity(operationId,a,b)
    local first,second=tostring(a),tostring(b)
    if second<first then first,second=second,first end
    return "shared-category-2:"..tostring(operationId)..":"..first..":"..second
end

local function governingRequirement(identity)
    return "shared-category-2-regulation:"..tostring(identity)
end

local function participantById(relation,assemblyId)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(relation and relation.participants or {}) do
        if participant.assemblyId==assemblyId then return participant end
    end
end

local function otherParticipant(relation,assemblyId)
    for _,participant in OuttaMyWay.ValueRecord.ipairs(relation and relation.participants or {}) do
        if participant.assemblyId~=assemblyId then return participant end
    end
end

-- Retained Shared Category-2 purpose geometry may outlive one participant's
-- fresh boundary projection. Intent fields remain current Situation evidence,
-- so refresh them independently from the retained locality/allocation record.
local function refreshParticipantIntent(relation,motionByAssembly)
    for _,participantValue in OuttaMyWay.ValueRecord.ipairs(relation and relation.participants or {}) do
        local motion=motionByAssembly and motionByAssembly[participantValue.assemblyId] or nil
        participantValue.intentClassification=motion and motion.localIntentClassification or "UNRESOLVED"
        participantValue.intentEpoch=motion and motion.intentEpoch or nil
        participantValue.intentValid=motion and motion.intentValid==true or false
    end
end

local function incumbentContext(commitmentContext,identity)
    local requirement=governingRequirement(identity)
    local match=nil
    for _,context in OuttaMyWay.ValueRecord.ipairs(commitmentContext or {}) do
        local basis=context and context.governingBasis or nil
        if type(basis)=="table" and basis.responsibilityKey==requirement then
            if match~=nil then return nil,"MULTIPLE_SHARED_CATEGORY_2_COMMITMENTS" end
            local regulated=nil
            for _,ownership in OuttaMyWay.ValueRecord.ipairs(context.progressActuationOwnership or {}) do
                if type(ownership.assemblyId)=="string" then
                    if regulated~=nil and regulated~=ownership.assemblyId then
                        return nil,"SHARED_CATEGORY_2_MULTIPLE_PROGRESS_OWNERS"
                    end
                    regulated=ownership.assemblyId
                end
            end
            local obligationBasis=nil
            for _,obligation in OuttaMyWay.ValueRecord.ipairs(context.openObligations or {}) do
                local candidate=obligation and obligation.basis or nil
                if type(candidate)=="table" and candidate.kind=="SHARED_CATEGORY_2_DEMAND_REGULATION"
                    and candidate.conflictIdentity==identity then
                    obligationBasis=candidate
                    break
                end
            end
            match={
                commitmentId=context.commitmentId,
                regulatedAssemblyId=regulated,
                protectedAssemblyId=obligationBasis and obligationBasis.protectedAssemblyId or nil,
                requirement=requirement
            }
        end
    end
    return match,nil
end

local function discFor(projection,reach)
    return {
        contactX=projection.contactX,contactZ=projection.contactZ,
        radiusM=reach.boundaryInteractionReachM,
        boundaryRingKind=projection.boundaryRingKind,
        boundaryRingIndex=projection.boundaryRingIndex,
        terminatingBoundaryEdgeKey=projection.terminatingBoundaryEdge and projection.terminatingBoundaryEdge.edgeKey or nil
    }
end

local function participant(projection,motion,physical)
    local reach=OuttaMyWay.BoundaryDemandRepresentation.measureReach(projection,physical)
    if reach.status~="SUPPORTED" then
        return nil,reach.reason,{reach=reach}
    end
    local disc=discFor(projection,reach)
    return {
        assemblyId=projection.assemblyId,
        assemblyReferenceKey=projection.assemblyReferenceKey,
        category2Demand=true,
        demandBasis="BOUNDED_A8_TO_BOUNDARY_CONTACT",
        boundaryContact={x=projection.contactX,z=projection.contactZ},
        boundaryRingKind=projection.boundaryRingKind,boundaryRingIndex=projection.boundaryRingIndex,
        terminatingBoundaryEdgeKey=disc.terminatingBoundaryEdgeKey,
        boundaryDistanceM=projection.boundaryDistanceM,
        boundaryInteractionReachM=reach.boundaryInteractionReachM,
        boundaryDemandDisc=disc,
        intentClassification=motion and motion.localIntentClassification or "UNRESOLVED",
        intentEpoch=motion and motion.intentEpoch or nil,
        intentValid=motion and motion.intentValid==true or false,
        nativeTimeToBoundarySec=projection.provisionalTimeToBoundarySec,
        representationCoverageComplete=reach.coverageComplete==true,
        negativeClearanceAuthority=false,
        provenance={
            source="BoundaryDemandAssessment",layer="SITUATION_ASSESSMENT",
            reach=reach.provenance
        }
    },nil,{reach=reach,disc=disc}
end

-- Boundary Option-Space, current occupancy and Boundary Demand Disc overlap are
-- yielder/physical-context evidence, not Shared Category-2 admission gates.
-- Evaluate them after positive shared terminating-boundary-domain support and
-- never let absent local disc overlap erase that boundary demand.
local function enrichOrderingEvidence(participantValue,physical,fieldWorld,evidence)
    if type(participantValue)~="table"
        or participantValue.boundaryOptionSpaceEvidence~=nil
        or participantValue.currentBoundaryDemandOccupancyEvidence~=nil then return end
    evidence=evidence or {}
    local disc=participantValue.boundaryDemandDisc

    local option=OuttaMyWay.BoundaryDemandRepresentation.measureOptionSpace(fieldWorld,disc)
    evidence.optionSpace=option
    participantValue.boundaryOptionSpaceEvidence=option
    if option.status=="SUPPORTED" and finite(option.boundaryOptionSpaceRatio) then
        participantValue.boundaryOptionSpaceRatio=option.boundaryOptionSpaceRatio
        participantValue.boundaryOptionSpaceClippedAreaM2=option.clippedAreaM2
        participantValue.boundaryOptionSpaceFullDiscAreaM2=option.fullDiscAreaM2
        participantValue.boundaryOptionSpaceRatioTolerance=option.ratioNumericalTolerance
        participantValue.provenance.optionSpace=option.provenance
    end

    local occupancy=OuttaMyWay.BoundaryDemandRepresentation.currentOccupancyInDisc(fieldWorld,physical,disc)
    evidence.occupancy=occupancy
    participantValue.currentBoundaryDemandOccupancyEvidence=occupancy
    if occupancy and occupancy.positive==true then
        participantValue.currentBoundaryDemandOccupancy=true
    end
end

local function sameBoundaryDomain(a,b)
    local aEdge=a and a.terminatingBoundaryEdgeKey or nil
    local bEdge=b and b.terminatingBoundaryEdgeKey or nil
    return type(aEdge)=="string" and type(bEdge)=="string"
        and a.boundaryRingKind==b.boundaryRingKind
        and tonumber(a.boundaryRingIndex)==tonumber(b.boundaryRingIndex)
        and aEdge==bEdge
end

local function freshRelation(operationId,fieldWorldReferenceKey,a,b,fieldWorld)
    local identity=pairIdentity(operationId,a.assemblyId,b.assemblyId)
    local overlap=OuttaMyWay.BoundaryDemandRepresentation.sharedOverlap(fieldWorld,a.boundaryDemandDisc,b.boundaryDemandDisc)
    local relation={
        identity=identity,operationId=operationId,fieldWorldReferenceKey=fieldWorldReferenceKey,
        classification="SHARED_CATEGORY_2_DEMAND",relationshipStatus="UNRESOLVED",
        subjectAssemblyId=a.assemblyId,otherAssemblyId=b.assemblyId,
        subjectReferenceKey=a.assemblyReferenceKey,otherReferenceKey=b.assemblyReferenceKey,
        participants={a,b},
        sharedBoundaryDemandOverlap=overlap,
        sharedBoundaryDomain={
            ringKind=a.boundaryRingKind,ringIndex=a.boundaryRingIndex,
            terminatingBoundaryEdgeKey=a.terminatingBoundaryEdgeKey
        },
        competingDemand=false,
        positiveOnly=true,decisionAuthority=false,controlAuthority=false,negativeClearanceAuthority=false,
        regulationSpeedKmh=INTENT_REVELATION_CREEP_KMH,
        governingRequirementKey=governingRequirement(identity),
        provenance={source="BoundaryDemandAssessment",layer="SITUATION_ASSESSMENT",independentOfForwardIntersection=true}
    }
    if not sameBoundaryDomain(a,b) then
        relation.reason="BOUNDARY_DEMANDS_DO_NOT_SHARE_SUPPORTED_TERMINATING_DOMAIN"
        return relation
    end
    relation.relationshipStatus="POSITIVE"
    relation.competingDemand=true
    relation.currentEvidenceState="SUPPORTED"
    relation.reason="CURRENT_A8_BOUNDARY_DEMANDS_SHARE_TERMINATING_CATEGORY_2_DOMAIN"
    return relation
end

local function protectedBoundaryTurnCompletion(state,protectedId,protectedMotion)
    if type(state)~="table" or type(state.relation)~="table" or type(protectedId)~="string"
        or type(protectedMotion)~="table" or protectedMotion.localIntentClassification~="TURNING" then
        return false,nil
    end
    local previous=participantById(state.relation,protectedId)
    local edgeKey=previous and previous.terminatingBoundaryEdgeKey or nil
    if type(previous)~="table"
        or previous.intentClassification~="SETTLED_CONTINUATION"
        or type(edgeKey)~="string" then
        return false,nil
    end
    return true,{
        predecessorIntentClassification=previous.intentClassification,
        predecessorIntentEpoch=previous.intentEpoch,
        terminatingBoundaryEdgeKey=edgeKey,
        boundaryRingKind=previous.boundaryRingKind,
        boundaryRingIndex=previous.boundaryRingIndex,
        boundaryDistanceM=previous.boundaryDistanceM,
        boundaryInteractionReachM=previous.boundaryInteractionReachM
    }
end

local function incumbentAction(relation,incumbent)
    if relation==nil or incumbent==nil or type(incumbent.regulatedAssemblyId)~="string" then return nil end
    local regulated=participantById(relation,incumbent.regulatedAssemblyId)
    local protected=incumbent.protectedAssemblyId and participantById(relation,incumbent.protectedAssemblyId)
        or otherParticipant(relation,incumbent.regulatedAssemblyId)
    if regulated==nil or protected==nil then return nil end
    return {
        status="REGULATE_SUPPORTED",supported=true,admissionKind="SHARED_CATEGORY_2_DEMAND",
        regulatedAssemblyId=regulated.assemblyId,regulatedReferenceKey=regulated.assemblyReferenceKey,
        protectedAssemblyId=protected.assemblyId,protectedReferenceKey=protected.assemblyReferenceKey,
        regulationSpeedKmh=INTENT_REVELATION_CREEP_KMH,fixedRegulationSpeedKmh=INTENT_REVELATION_CREEP_KMH,
        nativeUnrestrictedKmh=INTENT_REVELATION_CREEP_KMH,
        governingPurpose="PRESERVE_SHARED_CATEGORY_2_INTENT_REVELATION",
        reason=relation.currentEvidenceState=="WAITING_FOR_EVIDENCE"
            and "INCUMBENT_SHARED_CATEGORY_2_PURPOSE_WAITING_FOR_BOUNDARY_TURN"
            or "INCUMBENT_SHARED_CATEGORY_2_PURPOSE_REMAINS_CURRENT",
        roleBasis="INCUMBENT_SHARED_CATEGORY_2_ALLOCATION",
        roleAssignmentMutable=false
    }
end

function Assessment.new()
    return setmetatable({retained={},lastSignatures={}},Assessment)
end

function Assessment:reset()
    self.retained={}
    self.lastSignatures={}
end

function Assessment:assess(input)
    local projections=input.projections or {}
    local physicalByAssembly=byAssembly(input.physicalSpaceEvidence)
    local motionByAssembly=byAssembly(input.motionEvidence)
    local participants={}
    local participantEvidence={}
    for _,projection in OuttaMyWay.ValueRecord.ipairs(projections) do
        if projection.status=="SUPPORTED" then
            local current,reason,evidence=participant(
                projection,motionByAssembly[projection.assemblyId],
                physicalByAssembly[projection.assemblyId])
            participantEvidence[projection.assemblyId]=evidence
            if current~=nil then participants[#participants+1]=current
            else
                participantEvidence[projection.assemblyId].reason=reason
            end
        end
    end
    table.sort(participants,function(a,b) return tostring(a.assemblyId)<tostring(b.assemblyId) end)

    local freshByIdentity={}
    local pairAssessments={}
    for i=1,#participants-1 do
        for j=i+1,#participants do
            local relation=freshRelation(
                input.operationId,input.fieldWorldReferenceKey,
                participants[i],participants[j],input.fieldWorld)
            pairAssessments[#pairAssessments+1]=relation
            if relation.competingDemand==true then
                enrichOrderingEvidence(
                    participants[i],physicalByAssembly[participants[i].assemblyId],input.fieldWorld,
                    participantEvidence[participants[i].assemblyId])
                enrichOrderingEvidence(
                    participants[j],physicalByAssembly[participants[j].assemblyId],input.fieldWorld,
                    participantEvidence[participants[j].assemblyId])
                freshByIdentity[relation.identity]=relation
            end
        end
    end

    local incumbentByIdentity={}
    for identity,_ in OuttaMyWay.ValueRecord.pairs(self.retained) do
        local incumbent=incumbentContext(input.commitmentContext,identity)
        if incumbent~=nil then incumbentByIdentity[identity]=incumbent end
    end
    for identity,relation in OuttaMyWay.ValueRecord.pairs(freshByIdentity) do
        local incumbent=incumbentContext(input.commitmentContext,identity)
        if incumbent~=nil then incumbentByIdentity[identity]=incumbent end
        if self.retained[identity]==nil then
            self.retained[identity]={relation=copyValue(relation)}
        else
            self.retained[identity].relation=copyValue(relation)
        end
    end

    local shared={}
    local seen={}
    for identity,relation in OuttaMyWay.ValueRecord.pairs(freshByIdentity) do
        local incumbent=incumbentByIdentity[identity]
        if incumbent==nil then
            shared[#shared+1]=relation
            seen[identity]=true
        end
    end

    for identity,incumbent in OuttaMyWay.ValueRecord.pairs(incumbentByIdentity) do
        local state=self.retained[identity]
        local current=freshByIdentity[identity]
        if state==nil and current~=nil then
            state={relation=copyValue(current)}
            self.retained[identity]=state
        end
        if state~=nil then
            local base=current and copyValue(current) or copyValue(state.relation)
            local protectedId=incumbent.protectedAssemblyId
            if type(protectedId)~="string" and type(incumbent.regulatedAssemblyId)=="string" then
                local other=otherParticipant(base,incumbent.regulatedAssemblyId)
                protectedId=other and other.assemblyId or nil
            end
            local protectedMotion=protectedId and motionByAssembly[protectedId] or nil
            local boundaryTurn,boundaryTurnEvidence=protectedBoundaryTurnCompletion(state,protectedId,protectedMotion)

            refreshParticipantIntent(base,motionByAssembly)
            base.incumbentCommitmentId=incumbent.commitmentId
            base.incumbentRegulatedAssemblyId=incumbent.regulatedAssemblyId
            base.incumbentProtectedAssemblyId=protectedId

            if boundaryTurn then
                base.classification="SHARED_CATEGORY_2_DEMAND_DISSOLVED_BY_BOUNDARY_TURN"
                base.relationshipStatus="NEGATIVE"
                base.currentEvidenceState="POSITIVE_DISSOLUTION"
                base.competingDemand=false
                base.positiveDissolution=true
                base.boundaryTurnCompletion=true
                base.boundaryTurnEvidence=boundaryTurnEvidence
                base.reason="PROTECTED_PARTICIPANT_BEGAN_NATIVE_BOUNDARY_TURN"
                base.actionSpaceConservation={
                    status="NOT_REQUIRED",supported=false,admissionKind="SHARED_CATEGORY_2_DEMAND",
                    reason=base.reason,roleAssignmentMutable=false
                }
                self.retained[identity]=nil
            else
                if current==nil then
                    base.relationshipStatus="UNRESOLVED"
                    base.currentEvidenceState="WAITING_FOR_EVIDENCE"
                    base.competingDemand=true
                    base.reason="INCUMBENT_SHARED_CATEGORY_2_PURPOSE_WAITING_FOR_BOUNDARY_TURN"
                else
                    base.currentEvidenceState="SUPPORTED"
                    base.competingDemand=true
                    base.reason="INCUMBENT_SHARED_CATEGORY_2_PURPOSE_REMAINS_POSITIVELY_SUPPORTED"
                    state.relation=copyValue(base)
                end
                base.actionSpaceConservation=incumbentAction(base,incumbent)
            end
            shared[#shared+1]=base
            seen[identity]=true
        end
    end

    for identity,_ in OuttaMyWay.ValueRecord.pairs(self.retained) do
        if incumbentByIdentity[identity]==nil and freshByIdentity[identity]==nil then self.retained[identity]=nil end
    end

    table.sort(shared,function(a,b) return tostring(a.identity)<tostring(b.identity) end)
    table.sort(pairAssessments,function(a,b) return tostring(a.identity)<tostring(b.identity) end)

    return {
        operationId=input.operationId,
        participants=participants,
        participantEvidence=participantEvidence,
        pairAssessments=pairAssessments,
        sharedCategory2Demands=shared,
        decisionAuthority=false,controlAuthority=false,
        provenance={source="BoundaryDemandAssessment",layer="SITUATION_ASSESSMENT",independentOverlay=true}
    }
end

return Assessment
