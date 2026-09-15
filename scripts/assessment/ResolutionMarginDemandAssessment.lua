--- Interprets current represented spatial claims against supported native progression as one-sided Resolution-Margin Demand evidence.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`

-- This module owns Situation meaning only. A positive witness says a represented
-- claim is known no farther than the reported progression entry distance. It
-- does not establish safe clearance, stopping distance, a speed target,
-- Candidate preference, Decision authority, Bounded Authority or Control.
OuttaMyWay.ResolutionMarginDemandAssessment={}
local Assessment=OuttaMyWay.ResolutionMarginDemandAssessment

local usableFitnessState={CURRENTLY_FIT=true,FIT_FOR_LIMITED_HORIZON=true,USABLE_WITH_UNCERTAINTY=true}

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function normalize(x,z)
    if not finite(x) or not finite(z) then return nil,nil end
    local length=math.sqrt(x*x+z*z)
    if length<=0.000001 then return nil,nil end
    return x/length,z/length
end

local function dot(ax,az,bx,bz)
    return ax*bx+az*bz
end

local function byAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil then result[item.assemblyId]=item end
    end
    return result
end

local function fitnessByAssembly(values)
    local result={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if item.assemblyId~=nil and usableFitnessState[item.state]==true then
            local bucket=result[item.assemblyId]
            if bucket==nil then bucket={}; result[item.assemblyId]=bucket end
            bucket[#bucket+1]={
                representationId=item.representationId,
                question=item.question,
                assessmentHorizon=item.assessmentHorizon,
                state=item.state,
                claimPermissions=item.claimPermissions or {},
                coverage=item.coverage,
                uncertainty=item.uncertainty or {},
                validityDependencies=item.validityDependencies or {},
                provenance=item.provenance
            }
        end
    end
    for _,bucket in OuttaMyWay.ValueRecord.pairs(result) do
        table.sort(bucket,function(a,b) return tostring(a.representationId)<tostring(b.representationId) end)
    end
    return result
end

local function positiveDiscs(physical)
    local result={}
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(physical and physical.primitives or {}) do
        if primitive.kind=="DISC" and primitive.positiveConflictSupport==true
            and finite(primitive.x) and finite(primitive.z) and finite(primitive.radius) then
            result[#result+1]=primitive
        end
    end
    return result
end

local function singleSupportedAlternative(future,motion)
    local selected=nil
    local count=0
    for _,alternative in OuttaMyWay.ValueRecord.ipairs(future and future.alternatives or {}) do
        local intentMatches=alternative.intentEpoch==nil or motion.intentEpoch==nil or alternative.intentEpoch==motion.intentEpoch
        if intentMatches and finite(alternative.headingX) and finite(alternative.headingZ) and finite(alternative.boundaryDistance) then
            local hx,hz=normalize(alternative.headingX,alternative.headingZ)
            if hx~=nil and alternative.boundaryDistance>=0 then
                count=count+1
                selected={
                    identity=alternative.identity or future.identity,
                    headingX=hx,headingZ=hz,boundaryDistance=alternative.boundaryDistance,
                    intentEpoch=alternative.intentEpoch or motion.intentEpoch,
                    provenance=alternative.provenance or future.provenance
                }
            end
        end
    end
    if count==0 then return nil,"FIELD_BOUNDED_LOCAL_INTENT_HORIZON_UNAVAILABLE" end
    if count>1 then return nil,"MULTIPLE_LOCAL_INTENT_ALTERNATIVES_UNRESOLVED" end
    return selected,nil
end

local function subjectProjection(motion,future,physical,fitness)
    if motion==nil then return nil,"MOTION_KNOWLEDGE_UNAVAILABLE" end
    if motion.intentValid~=true or motion.localIntentClassification~="SETTLED_CONTINUATION" then
        return nil,"POSITIVE_SETTLED_NATIVE_CONTINUATION_UNAVAILABLE"
    end
    if OuttaMyWay.ValueRecord.length(fitness or {})==0 then return nil,"SUBJECT_REPRESENTATION_FITNESS_UNAVAILABLE" end
    local dx,dz=normalize(motion.travelDirectionX,motion.travelDirectionZ)
    if dx==nil then return nil,"REALIZED_TRAVEL_DIRECTION_UNAVAILABLE" end
    local alternative,reason=singleSupportedAlternative(future,motion)
    if alternative==nil then return nil,reason end
    local alignment=dot(dx,dz,alternative.headingX,alternative.headingZ)
    if alignment<0.5 then
        return nil,"REALIZED_TRAVEL_NOT_REPRESENTED_BY_CURRENT_FIELD_BOUNDED_INTENT_HORIZON"
    end
    local discs=positiveDiscs(physical)
    if OuttaMyWay.ValueRecord.length(discs)==0 then return nil,"SUBJECT_POSITIVE_PHYSICAL_PRIMITIVES_UNAVAILABLE" end
    return {
        assemblyId=motion.assemblyId,
        assemblyReferenceKey=motion.assemblyReferenceKey,
        name=motion.name,
        sourceJobToken=motion.sourceJobToken,
        intentEpoch=motion.intentEpoch,
        directionX=dx,directionZ=dz,
        projectionLimitM=math.max(0,alternative.boundaryDistance*alignment),
        fieldBoundedIntentIdentity=alternative.identity,
        fieldBoundedIntentEpoch=alternative.intentEpoch,
        alignment=alignment,
        discs=discs,
        representationFitness=fitness,
        provenance=alternative.provenance
    },nil
end

local function currentRegions(scopeSet,currentByAssembly,motionByAssembly,physicalByAssembly,fitnessById,subjectId)
    local result={}
    for targetId,_ in OuttaMyWay.ValueRecord.pairs(scopeSet or {}) do
        if targetId~=subjectId then
            local current=currentByAssembly[targetId]
            local physical=physicalByAssembly[targetId]
            local fitness=fitnessById[targetId]
            if current~=nil and physical~=nil and OuttaMyWay.ValueRecord.length(fitness or {})>0 then
                for _,primitive in OuttaMyWay.ValueRecord.ipairs(positiveDiscs(physical)) do
                    result[#result+1]={
                        identity="CURRENT_SPACE|"..tostring(current.identity).."|"..tostring(primitive.identity),
                        claimIdentity=current.identity,
                        claimClass="CURRENT_SPACE",
                        targetAssemblyId=targetId,
                        targetReferenceKey=motionByAssembly[targetId] and motionByAssembly[targetId].assemblyReferenceKey or nil,
                        targetIntentEpoch=motionByAssembly[targetId] and motionByAssembly[targetId].intentEpoch or nil,
                        targetPrimitiveId=primitive.identity,
                        kind="CAPSULE",ax=primitive.x,az=primitive.z,bx=primitive.x,bz=primitive.z,radius=primitive.radius,
                        validityKey="CURRENT|"..tostring(current.identity).."|"..tostring(motionByAssembly[targetId] and motionByAssembly[targetId].intentEpoch or "na"),
                        representationFitness=fitness,
                        representationProvenance=physical.provenance,
                        claimProvenance=current.provenance
                    }
                end
            end
        end
    end
    return result
end

local function demandRegions(scopeSet,demandBucket,className,currentByAssembly,futureByAssembly,motionByAssembly,physicalByAssembly,fitnessById,operationId,subjectId)
    local result={}
    for _,demand in OuttaMyWay.ValueRecord.ipairs(demandBucket or {}) do
        local targetId=demand.assemblyId
        local sameOperation=demand.operationId==nil or demand.operationId==operationId
        if targetId~=nil and targetId~=subjectId and scopeSet[targetId]==true and sameOperation
            and type(demand.space)=="table" and demand.space.futureSpaceIdentity~=nil then
            local current=currentByAssembly[targetId]
            local future=futureByAssembly[targetId]
            local motion=motionByAssembly[targetId]
            local physical=physicalByAssembly[targetId]
            local fitness=fitnessById[targetId]
            local alternative=motion and select(1,singleSupportedAlternative(future,motion)) or nil
            if current~=nil and physical~=nil and alternative~=nil and OuttaMyWay.ValueRecord.length(fitness or {})>0 then
                for _,primitive in OuttaMyWay.ValueRecord.ipairs(positiveDiscs(physical)) do
                    result[#result+1]={
                        identity=className.."|"..tostring(demand.identity).."|"..tostring(primitive.identity),
                        claimIdentity=demand.identity,
                        claimClass=className,
                        targetAssemblyId=targetId,
                        targetReferenceKey=motion and motion.assemblyReferenceKey or nil,
                        targetIntentEpoch=motion and motion.intentEpoch or nil,
                        targetPrimitiveId=primitive.identity,
                        kind="CAPSULE",
                        ax=primitive.x,az=primitive.z,
                        bx=primitive.x+alternative.headingX*alternative.boundaryDistance,
                        bz=primitive.z+alternative.headingZ*alternative.boundaryDistance,
                        radius=primitive.radius,
                        validityKey=tostring(demand.identity).."|"..tostring(alternative.intentEpoch or "na"),
                        representationFitness=fitness,
                        representationProvenance=physical.provenance,
                        claimProvenance=demand.provenance
                    }
                end
            end
        end
    end
    return result
end

local function evaluate(subject,region)
    local best=nil
    local bestSubjectPrimitiveId=nil
    local bestReason=nil
    for _,primitive in OuttaMyWay.ValueRecord.ipairs(subject.discs or {}) do
        local distance,reason=OuttaMyWay.ProgressionGeometry.rayCapsuleEntry(
            primitive.x,primitive.z,subject.directionX,subject.directionZ,
            region.ax,region.az,region.bx,region.bz,(primitive.radius or 0)+(region.radius or 0)
        )
        if distance~=nil and (best==nil or distance<best) then
            best=distance
            bestSubjectPrimitiveId=primitive.identity
            bestReason=reason
        end
    end
    if best==nil or best>subject.projectionLimitM then return nil end
    return {
        knownWitnessEntryM=best,
        subjectPrimitiveId=bestSubjectPrimitiveId,
        witnessReason=bestReason
    }
end

local function positiveRecord(snapshotId,operationId,subject,region,witness)
    return {
        identity="resolution-margin-demand:"..tostring(operationId)..":"..tostring(subject.assemblyId)..":"..tostring(region.identity),
        status="POSITIVE_WITNESS_WITHIN_LOCAL_INTENT",
        operationId=operationId,
        subjectAssemblyId=subject.assemblyId,
        subjectReferenceKey=subject.assemblyReferenceKey,
        subjectJobToken=subject.sourceJobToken,
        subjectIntentEpoch=subject.intentEpoch,
        subjectRepresentationFitness=subject.representationFitness,
        progressionBasis={
            kind="CURRENT_SUPPORTED_NATIVE_PROGRESSION",
            localIntentClassification="SETTLED_CONTINUATION",
            directionX=subject.directionX,directionZ=subject.directionZ,
            projectionLimitM=subject.projectionLimitM,
            fieldBoundedIntentIdentity=subject.fieldBoundedIntentIdentity,
            fieldBoundedIntentEpoch=subject.fieldBoundedIntentEpoch,
            realizedToIntentAlignment=subject.alignment
        },
        representedClaim={
            class=region.claimClass,
            identity=region.claimIdentity,
            targetAssemblyId=region.targetAssemblyId,
            targetReferenceKey=region.targetReferenceKey,
            targetIntentEpoch=region.targetIntentEpoch,
            targetPrimitiveId=region.targetPrimitiveId,
            validityKey=region.validityKey,
            representationFitness=region.representationFitness,
            representationProvenance=region.representationProvenance,
            claimProvenance=region.claimProvenance
        },
        knownWitnessEntryM=witness.knownWitnessEntryM,
        subjectPrimitiveId=witness.subjectPrimitiveId,
        witnessReason=witness.witnessReason,
        claimLimits={
            positiveRepresentedDemandOnly=true,
            negativeClearanceAuthority=false,
            safeClearanceAuthority=false,
            stoppingDistanceAuthority=false,
            speedAuthority=false,
            routePredictionAuthority=false
        },
        provenance={
            source="ResolutionMarginDemandAssessment",
            layer="SITUATION_KNOWLEDGE",
            authority="POSITIVE_RESOLUTION_MARGIN_DEMAND_ONLY",
            observationSnapshotId=snapshotId
        }
    }
end

function Assessment.assess(context)
    context=context or {}
    local currentByAssembly=byAssembly(context.currentSpace)
    local futureByAssembly=byAssembly(context.futureSpace)
    local motionByAssembly=byAssembly(context.motionEvidence)
    local physicalByAssembly=byAssembly(context.physicalSpaceEvidence)
    local fitnessById=fitnessByAssembly(context.representationFitness)
    local demand=context.demand or {}
    local result={}

    for _,situation in OuttaMyWay.ValueRecord.ipairs(context.situations or {}) do
        local scopeSet={}
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(situation.resolutionSpaceAssemblyIds or situation.memberAssemblyIds or {}) do
            scopeSet[assemblyId]=true
        end
        for subjectId,_ in OuttaMyWay.ValueRecord.pairs(scopeSet) do
            local subject=select(1,subjectProjection(motionByAssembly[subjectId],futureByAssembly[subjectId],physicalByAssembly[subjectId],fitnessById[subjectId]))
            if subject~=nil then
                local regions=currentRegions(scopeSet,currentByAssembly,motionByAssembly,physicalByAssembly,fitnessById,subjectId)
                local committed=demandRegions(scopeSet,demand.committedDemand,"COMMITTED_DEMAND",currentByAssembly,futureByAssembly,motionByAssembly,physicalByAssembly,fitnessById,situation.operationId,subjectId)
                local potential=demandRegions(scopeSet,demand.potentialDemand,"POTENTIAL_DEMAND",currentByAssembly,futureByAssembly,motionByAssembly,physicalByAssembly,fitnessById,situation.operationId,subjectId)
                for _,region in OuttaMyWay.ValueRecord.ipairs(committed) do regions[#regions+1]=region end
                for _,region in OuttaMyWay.ValueRecord.ipairs(potential) do regions[#regions+1]=region end
                for _,region in OuttaMyWay.ValueRecord.ipairs(regions) do
                    local witness=evaluate(subject,region)
                    if witness~=nil then
                        result[#result+1]=positiveRecord(context.observationSnapshotId,situation.operationId,subject,region,witness)
                    end
                end
            end
        end
    end

    table.sort(result,function(a,b)
        if tostring(a.operationId)~=tostring(b.operationId) then return tostring(a.operationId)<tostring(b.operationId) end
        if tostring(a.subjectAssemblyId)~=tostring(b.subjectAssemblyId) then return tostring(a.subjectAssemblyId)<tostring(b.subjectAssemblyId) end
        if tostring(a.representedClaim.class)~=tostring(b.representedClaim.class) then return tostring(a.representedClaim.class)<tostring(b.representedClaim.class) end
        return tostring(a.identity)<tostring(b.identity)
    end)
    return result
end
