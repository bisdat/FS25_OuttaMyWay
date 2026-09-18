--- Interprets immutable Field World geometry into conservative Structural Field Shape Corner Feature knowledge.
-- Specification Jurisdictions: `SITUATION_ASSESSMENT`
--
-- This assessment promotes only convergent positive geometry.  It does not treat
-- every sampled polygon vertex as a Corner, does not manufacture a negative
-- "no Corner" conclusion, and owns no Candidate, Decision, Responsibility,
-- Bounded Authority or Control semantics.

OuttaMyWay.StructuralFieldShapeAssessment={}
local Assessment=OuttaMyWay.StructuralFieldShapeAssessment
Assessment.__index=Assessment

local EPSILON_M=0.00001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function point(value,index,quantum)
    if type(value)~="table" then return nil end
    local x=tonumber(value.x or value[1])
    local z=tonumber(value.z or value[2] or value[3])
    if not finite(x) or not finite(z) then return nil end
    local scale=tonumber(quantum) or 1
    return {x=x*scale,z=z*scale,originalIndex=index}
end

local function copyVertex(value)
    return {x=value.x,z=value.z,originalIndex=value.originalIndex}
end

local function distance(a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    return math.sqrt(dx*dx+dz*dz)
end

local function atan2(y,x)
    if type(math.atan2)=="function" then return math.atan2(y,x) end
    if x>0 then return math.atan(y/x) end
    if x<0 and y>=0 then return math.atan(y/x)+math.pi end
    if x<0 and y<0 then return math.atan(y/x)-math.pi end
    if x==0 and y>0 then return math.pi/2 end
    if x==0 and y<0 then return -math.pi/2 end
    return 0
end

local function signedTurnDegrees(previous,current,nextValue)
    local inX,inZ=current.x-previous.x,current.z-previous.z
    local outX,outZ=nextValue.x-current.x,nextValue.z-current.z
    local inLength=math.sqrt(inX*inX+inZ*inZ)
    local outLength=math.sqrt(outX*outX+outZ*outZ)
    if inLength<=EPSILON_M or outLength<=EPSILON_M then return nil end
    return math.deg(atan2(inX*outZ-inZ*outX,inX*outX+inZ*outZ))
end

local function removalScaleM(previous,current,nextValue)
    local dx,dz=nextValue.x-previous.x,nextValue.z-previous.z
    local squared=dx*dx+dz*dz
    if squared<=EPSILON_M*EPSILON_M then return distance(previous,current) end
    local t=((current.x-previous.x)*dx+(current.z-previous.z)*dz)/squared
    if t<0 then t=0 elseif t>1 then t=1 end
    return distance(current,{x=previous.x+t*dx,z=previous.z+t*dz})
end

local function stage(vertices)
    local result={remainingPointCount=#vertices,survivors={}}
    for index,current in ipairs(vertices) do
        local previous=vertices[((index-2)%#vertices)+1]
        local nextValue=vertices[(index%#vertices)+1]
        result.survivors[#result.survivors+1]={
            x=current.x,z=current.z,originalIndex=current.originalIndex,
            previousOriginalIndex=previous.originalIndex,nextOriginalIndex=nextValue.originalIndex,
            supportM=distance(previous,current)+distance(current,nextValue),
            turnMagnitudeDegrees=math.abs(signedTurnDegrees(previous,current,nextValue) or 0)
        }
    end
    return result
end

local function analyseRing(vertices)
    local result={status="UNRESOLVED",stages={},removals={},cornerFeatures={}}
    if type(vertices)~="table" or #vertices<4 then
        result.reason="STRUCTURAL_RING_REQUIRES_AT_LEAST_FOUR_POINTS"
        return result
    end

    local current={}
    for _,value in ipairs(vertices) do current[#current+1]=copyVertex(value) end
    while #current>3 do
        result.stages[#result.stages+1]=stage(current)
        local bestIndex,bestScale=nil,nil
        for index,value in ipairs(current) do
            local previous=current[((index-2)%#current)+1]
            local nextValue=current[(index%#current)+1]
            local scale=removalScaleM(previous,value,nextValue)
            if bestScale==nil or scale<bestScale-EPSILON_M
                or (math.abs(scale-bestScale)<=EPSILON_M and value.originalIndex<current[bestIndex].originalIndex) then
                bestIndex,bestScale=index,scale
            end
        end
        local removed=current[bestIndex]
        result.removals[#result.removals+1]={
            originalIndex=removed.originalIndex,
            remainingBeforeRemoval=#current,
            removalScaleM=bestScale
        }
        table.remove(current,bestIndex)
    end
    result.stages[#result.stages+1]=stage(current)

    local distinct={}
    for _,record in ipairs(result.removals) do
        local scale=record.removalScaleM
        if finite(scale) and scale>EPSILON_M then
            local found=false
            for _,existing in ipairs(distinct) do
                if math.abs(existing-scale)<=EPSILON_M then found=true break end
            end
            if not found then distinct[#distinct+1]=scale end
        end
    end
    table.sort(distinct)

    local lowerScale,upperScale,bestRatio=nil,nil,nil
    for index=2,#distinct do
        local before,after=distinct[index-1],distinct[index]
        local ratio=after/before
        if bestRatio==nil or ratio>bestRatio then
            bestRatio,lowerScale,upperScale=ratio,before,after
        end
    end

    local structuralCount=#vertices
    if upperScale~=nil then
        for _,record in ipairs(result.removals) do
            if record.removalScaleM>=upperScale-EPSILON_M then
                structuralCount=record.remainingBeforeRemoval
                break
            end
        end
    end
    local structuralStage=nil
    for _,candidate in ipairs(result.stages) do
        if candidate.remainingPointCount==structuralCount then structuralStage=candidate break end
    end
    if structuralStage==nil then
        result.reason="STRUCTURAL_STAGE_UNRESOLVED"
        return result
    end

    local trajectoryByIndex={}
    for _,candidateStage in ipairs(result.stages) do
        if candidateStage.remainingPointCount>=structuralCount then
            for _,survivor in ipairs(candidateStage.survivors) do
                local trajectory=trajectoryByIndex[survivor.originalIndex]
                if trajectory==nil then trajectory={}; trajectoryByIndex[survivor.originalIndex]=trajectory end
                trajectory[#trajectory+1]=survivor
            end
        end
    end

    local function supportStable(originalIndex)
        local trajectory=trajectoryByIndex[originalIndex] or {}
        if #trajectory==0 then return false,"NO_SUPPORT_TRAJECTORY" end
        local first,last=trajectory[1],trajectory[#trajectory]
        if first.previousOriginalIndex==last.previousOriginalIndex
            and first.nextOriginalIndex==last.nextOriginalIndex then
            return true,"STRUCTURAL_SUPPORT_UNCHANGED"
        end
        for index=2,#trajectory do
            local before,after=trajectory[index-1],trajectory[index]
            if after.supportM>before.supportM+EPSILON_M then
                local turnDenominator=math.max(before.turnMagnitudeDegrees,after.turnMagnitudeDegrees,EPSILON_M)
                local supportDenominator=math.max(after.supportM,EPSILON_M)
                local turnChange=math.abs(after.turnMagnitudeDegrees-before.turnMagnitudeDegrees)/turnDenominator
                local supportGrowth=(after.supportM-before.supportM)/supportDenominator
                if turnChange+EPSILON_M<supportGrowth then
                    return true,"SUPPORT_GROWTH_DOMINATES_TURN_CHANGE"
                end
            end
        end
        return false,"DIRECTION_CHANGE_EVOLVES_WITH_SUPPORT"
    end

    result.structuralStagePointCount=structuralCount
    result.structuralScaleEvidence={
        distinctRemovalScaleCount=#distinct,
        largestAdjacentScaleRatio=bestRatio,
        lowerRemovalScaleM=lowerScale,
        upperRemovalScaleM=upperScale,
        selectionRule=upperScale and "STAGE_BEFORE_LARGEST_RELATIVE_REMOVAL_SCALE_TRANSITION" or "NO_DISTINCT_SCALE_TRANSITION"
    }

    for _,survivor in ipairs(structuralStage.survivors) do
        local stable,reason=supportStable(survivor.originalIndex)
        if stable and survivor.turnMagnitudeDegrees>EPSILON_M then
            result.cornerFeatures[#result.cornerFeatures+1]={
                representativePoint={x=survivor.x,z=survivor.z},
                representativeOriginalIndex=survivor.originalIndex,
                supportBeforeOriginalIndex=survivor.previousOriginalIndex,
                supportAfterOriginalIndex=survivor.nextOriginalIndex,
                supportM=survivor.supportM,
                directionChangeMagnitudeDegrees=survivor.turnMagnitudeDegrees,
                supportStabilityEvidence=reason,
                structuralStagePointCount=structuralCount,
                semanticAuthority="POSITIVE_STRUCTURAL_FIELD_SHAPE_EVIDENCE_ONLY",
                negativeCornerAuthority=false
            }
        end
    end

    result.status=#result.cornerFeatures>0 and "POSITIVE_STRUCTURAL_FEATURES_SUPPORTED" or "UNRESOLVED_NO_POSITIVE_STRUCTURAL_FEATURE"
    result.reason=#result.cornerFeatures>0 and "CONVERGENT_PERSISTENCE_AND_SUPPORT_STABLE_DIRECTION_CHANGE" or "NO_CONVERGENT_CORNER_FEATURE_EVIDENCE"
    return result
end

local function coordinateKey(value)
    return string.format("%.3f,%.3f",value.x,value.z)
end

local function featureKey(fieldWorldReferenceKey,ringKind,ringReference,feature,before,after)
    return table.concat({
        tostring(fieldWorldReferenceKey),
        "corner-feature",
        tostring(ringKind),
        tostring(ringReference),
        coordinateKey(before),
        coordinateKey(feature.representativePoint),
        coordinateKey(after)
    },"|")
end

local function canonicalMetricRing(vertices,quantum)
    local count=OuttaMyWay.ValueRecord.length(vertices or {})
    if count<4 then return nil,"CANONICAL_RING_UNAVAILABLE" end
    local result={}
    for index,value in OuttaMyWay.ValueRecord.ipairs(vertices) do
        local resolved=point(value,index,quantum)
        if resolved==nil then return nil,"CANONICAL_RING_POINT_UNRESOLVED" end
        result[#result+1]=resolved
    end
    return result
end

local function decorateRing(fieldWorldReferenceKey,ringKind,ringIndex,ringReference,ringAnalysis,metricRing)
    for _,feature in ipairs(ringAnalysis.cornerFeatures or {}) do
        local before=metricRing[feature.supportBeforeOriginalIndex]
        local after=metricRing[feature.supportAfterOriginalIndex]
        feature.fieldWorldReferenceKey=fieldWorldReferenceKey
        feature.ringKind=ringKind
        feature.ringIndex=ringIndex
        feature.ringReference=ringReference
        feature.supportBefore={x=before.x,z=before.z}
        feature.supportAfter={x=after.x,z=after.z}
        feature.cornerKey=featureKey(fieldWorldReferenceKey,ringKind,ringReference,feature,before,after)
        feature.featureRegion={
            kind="STRUCTURAL_DIRECTION_TRANSITION_SUPPORT",
            representativePoint={x=feature.representativePoint.x,z=feature.representativePoint.z},
            supportBefore={x=before.x,z=before.z},
            supportAfter={x=after.x,z=after.z}
        }
    end
end

local function sortedFeatureSignature(features)
    local values={}
    for _,feature in ipairs(features or {}) do values[#values+1]=feature.cornerKey end
    table.sort(values)
    return table.concat(values,"\n")
end

function Assessment.new()
    return setmetatable({fieldShapes={}},Assessment)
end

function Assessment:reset()
    self.fieldShapes={}
end

function Assessment:assess(fieldWorld,fieldWorldReferenceKey)
    local result={
        status="UNRESOLVED",
        reason=nil,
        fieldWorldReferenceKey=fieldWorldReferenceKey,
        cornerFeatures={},
        ringAnalyses={},
        uncertainty={},
        decisionAuthority=false,
        controlAuthority=false,
        provenance={source="StructuralFieldShapeAssessment",layer="SITUATION_ASSESSMENT"}
    }
    if type(fieldWorldReferenceKey)~="string" or fieldWorldReferenceKey=="" then
        result.reason="FIELD_WORLD_IDENTITY_UNRESOLVED"
        return result
    end
    if type(fieldWorld)~="table" then
        result.reason="FIELD_WORLD_GEOMETRY_UNAVAILABLE"
        return result
    end
    local quantum=tonumber(fieldWorld.quantizationMetres)
    if not finite(quantum) or quantum<=0 then
        result.reason="FIELD_WORLD_CANONICAL_QUANTIZATION_UNAVAILABLE"
        return result
    end

    local root,rootReason=canonicalMetricRing(fieldWorld.canonicalRootVertices,quantum)
    if root==nil then
        result.reason=rootReason
        return result
    end
    local rootAnalysis=analyseRing(root)
    decorateRing(fieldWorldReferenceKey,"OUTER_BOUNDARY",1,tostring(fieldWorld.canonicalRootRing or "ROOT"),rootAnalysis,root)
    result.ringAnalyses[#result.ringAnalyses+1]=rootAnalysis
    for _,feature in ipairs(rootAnalysis.cornerFeatures or {}) do result.cornerFeatures[#result.cornerFeatures+1]=feature end

    for islandIndex,island in OuttaMyWay.ValueRecord.ipairs(fieldWorld.islands or {}) do
        local canonical,reason=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(island,{},quantum)
        if canonical~=nil then
            local metric,islandReason=canonicalMetricRing(canonical.canonicalRootVertices,quantum)
            if metric~=nil then
                local analysis=analyseRing(metric)
                decorateRing(fieldWorldReferenceKey,"ISLAND_BOUNDARY",islandIndex,tostring(canonical.canonicalRootRing),analysis,metric)
                result.ringAnalyses[#result.ringAnalyses+1]=analysis
                for _,feature in ipairs(analysis.cornerFeatures or {}) do result.cornerFeatures[#result.cornerFeatures+1]=feature end
            else
                result.uncertainty[#result.uncertainty+1]={kind="ISLAND_STRUCTURAL_RING_UNRESOLVED",islandIndex=islandIndex,reason=islandReason}
            end
        else
            result.uncertainty[#result.uncertainty+1]={kind="ISLAND_CANONICALIZATION_UNRESOLVED",islandIndex=islandIndex,reason=reason}
        end
    end

    table.sort(result.cornerFeatures,function(a,b) return a.cornerKey<b.cornerKey end)
    result.status=#result.cornerFeatures>0 and "POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED" or "UNRESOLVED_NO_POSITIVE_CORNER_FEATURE"
    result.reason=#result.cornerFeatures>0 and "CONVERGENT_STRUCTURAL_CORNER_FEATURE_EVIDENCE" or "CORNER_FEATURE_EXISTENCE_NOT_POSITIVELY_ESTABLISHED"

    local signature=sortedFeatureSignature(result.cornerFeatures)
    local retained=self.fieldShapes[fieldWorldReferenceKey]
    if retained~=nil and retained.signature~=signature then
        result.uncertainty[#result.uncertainty+1]={
            kind="EQUIVALENT_FIELD_WORLD_STRUCTURAL_INTERPRETATION_CHANGED",
            retainedSignature=retained.signature,currentSignature=signature
        }
        -- Positive retained Field-scoped knowledge is not revoked by one
        -- materially equivalent sampling disagreement.  Preserve the first
        -- positively established feature set and expose the disagreement.
        if retained.status=="POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED" then
            result.cornerFeatures=retained.cornerFeatures
            result.status="POSITIVE_RETAINED_WITH_SAMPLING_DISAGREEMENT"
            result.reason="RETAINED_FIELD_SCOPED_FEATURES_PENDING_EQUIVALENT_SAMPLING_RECONCILIATION"
            return result
        end
    elseif retained~=nil then
        return retained.result
    end

    if result.status=="POSITIVE_STRUCTURAL_FIELD_SHAPE_SUPPORTED" then
        self.fieldShapes[fieldWorldReferenceKey]={
            signature=signature,status=result.status,cornerFeatures=result.cornerFeatures,result=result
        }
    end
    return result
end
