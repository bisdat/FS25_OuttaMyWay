--- Non-authoritative multi-scale Field World boundary probe for Issue #234 implementation discovery.
-- Diagnostic only: analyses immutable sampled boundary geometry and grants no Situation,
-- Candidate, Decision, Responsibility, Bounded Authority or Control authority.

OuttaMyWay.BoundaryFeaturePersistenceProbe = {}
local Probe = OuttaMyWay.BoundaryFeaturePersistenceProbe
Probe.__index = Probe

local EPSILON_M=0.000001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function point(value,index)
    if type(value)~="table" then return nil end
    local x=tonumber(value.x or value[1])
    local z=tonumber(value.z or value[2] or value[3])
    if not finite(x) or not finite(z) then return nil end
    return {x=x,z=z,originalIndex=index}
end

local function distance(a,b)
    local x,z=a.x-b.x,a.z-b.z
    return math.sqrt(x*x+z*z)
end

-- The removal scale is the perpendicular deviation of one current boundary
-- sample from the chord joining its current neighbours.  It is an investigative
-- scale measure only; it is not a Corner threshold or semantic classification.
local function removalScaleM(previous,current,nextValue)
    local dx,dz=nextValue.x-previous.x,nextValue.z-previous.z
    local chord=math.sqrt(dx*dx+dz*dz)
    if chord<=EPSILON_M then return distance(current,previous) end
    local area2=math.abs(dx*(current.z-previous.z)-dz*(current.x-previous.x))
    return area2/chord
end

local function turnDegrees(previous,current,nextValue)
    local inX,inZ=current.x-previous.x,current.z-previous.z
    local outX,outZ=nextValue.x-current.x,nextValue.z-current.z
    local inLength=math.sqrt(inX*inX+inZ*inZ)
    local outLength=math.sqrt(outX*outX+outZ*outZ)
    if inLength<=EPSILON_M or outLength<=EPSILON_M then return nil end
    local cosine=(inX*outX+inZ*outZ)/(inLength*outLength)
    if cosine>1 then cosine=1 elseif cosine<-1 then cosine=-1 end
    return math.deg(math.acos(cosine))
end

local function copySurvivors(vertices)
    local result={}
    for _,vertex in OuttaMyWay.ValueRecord.ipairs(vertices) do
        result[#result+1]={
            originalIndex=vertex.originalIndex,
            x=vertex.x,
            z=vertex.z
        }
    end
    return result
end

local function largestScaleGap(removals)
    local positive={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(removals) do
        if finite(record.removalScaleM) and record.removalScaleM>EPSILON_M then
            positive[#positive+1]=record.removalScaleM
        end
    end
    table.sort(positive)
    local bestRatio,beforeM,afterM=nil,nil,nil
    for index=2,#positive do
        local before,after=positive[index-1],positive[index]
        if before>EPSILON_M then
            local ratio=after/before
            if bestRatio==nil or ratio>bestRatio then
                bestRatio,beforeM,afterM=ratio,before,after
            end
        end
    end
    return bestRatio,beforeM,afterM
end

function Probe.analyzeBoundary(boundary)
    local count=OuttaMyWay.ValueRecord.length(boundary or {})
    local result={
        status="UNRESOLVED",
        reason=nil,
        originalPointCount=count,
        removals={},
        stages={},
        largestScaleGapRatio=nil,
        largestScaleGapBeforeM=nil,
        largestScaleGapAfterM=nil,
        semanticAuthority=false,
        controlAuthority=false,
        provenance={source="BoundaryFeaturePersistenceProbe",authority="DIAGNOSTIC_ONLY"}
    }
    if count<4 then
        result.reason="BOUNDARY_REQUIRES_AT_LEAST_FOUR_POINTS"
        return result
    end

    local vertices={}
    for index,value in OuttaMyWay.ValueRecord.ipairs(boundary) do
        local resolved=point(value,index)
        if resolved==nil then
            result.reason="BOUNDARY_POINT_UNRESOLVED"
            return result
        end
        vertices[#vertices+1]=resolved
    end

    local ordinal=0
    while #vertices>3 do
        result.stages[#result.stages+1]={
            remainingPointCount=#vertices,
            survivors=copySurvivors(vertices)
        }
        local bestIndex,bestScale,bestTurn=nil,nil,nil
        for index,current in OuttaMyWay.ValueRecord.ipairs(vertices) do
            local previous=vertices[((index-2)%#vertices)+1]
            local nextValue=vertices[(index%#vertices)+1]
            local scale=removalScaleM(previous,current,nextValue)
            local turn=turnDegrees(previous,current,nextValue)
            if bestScale==nil or scale<bestScale-EPSILON_M
                or (math.abs(scale-bestScale)<=EPSILON_M and current.originalIndex<vertices[bestIndex].originalIndex) then
                bestIndex,bestScale,bestTurn=index,scale,turn
            end
        end
        ordinal=ordinal+1
        local removed=vertices[bestIndex]
        result.removals[#result.removals+1]={
            removalOrdinal=ordinal,
            remainingBeforeRemoval=#vertices,
            originalIndex=removed.originalIndex,
            x=removed.x,
            z=removed.z,
            removalScaleM=bestScale,
            localTurnDegrees=bestTurn
        }
        table.remove(vertices,bestIndex)
    end
    result.stages[#result.stages+1]={
        remainingPointCount=#vertices,
        survivors=copySurvivors(vertices)
    }
    result.finalSurvivors=copySurvivors(vertices)
    result.largestScaleGapRatio,result.largestScaleGapBeforeM,result.largestScaleGapAfterM=largestScaleGap(result.removals)
    result.status="SUPPORTED_DIAGNOSTIC_ANALYSIS"
    result.reason="MULTI_SCALE_BOUNDARY_SAMPLE_REMOVAL_ANALYSED"
    return result
end

-- Live Field World analysis deliberately consumes the canonical open ring rather
-- than the source boundary encoding.  A repeated closing point is representation
-- syntax, not a Boundary Feature, and must not enter the persistence sequence.
function Probe.analyzeSnapshot(snapshot)
    if type(snapshot)~="table" then
        local result=Probe.analyzeBoundary(nil)
        result.reason="FIELD_WORLD_SNAPSHOT_UNAVAILABLE"
        result.inputSource="UNAVAILABLE"
        return result
    end
    local canonical=snapshot.canonicalRootVertices
    if OuttaMyWay.ValueRecord.length(canonical or {})<4 then
        local result=Probe.analyzeBoundary(nil)
        result.reason="CANONICAL_ROOT_VERTICES_UNAVAILABLE"
        result.inputSource="FIELD_WORLD_CANONICAL_ROOT_VERTICES"
        result.sourceBoundaryPointCount=OuttaMyWay.ValueRecord.length(snapshot.boundary or {})
        result.canonicalBoundaryPointCount=OuttaMyWay.ValueRecord.length(canonical or {})
        return result
    end
    local result=Probe.analyzeBoundary(canonical)
    result.inputSource="FIELD_WORLD_CANONICAL_ROOT_VERTICES"
    result.sourceBoundaryPointCount=OuttaMyWay.ValueRecord.length(snapshot.boundary or {})
    result.canonicalBoundaryPointCount=OuttaMyWay.ValueRecord.length(canonical)
    result.registryBoundaryPointCount=tonumber(snapshot.boundaryPointCount)
    return result
end

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][BOUNDARY-PERSISTENCE] %s",message)
    else
        print("[FS25_OuttaMyWay][BOUNDARY-PERSISTENCE] "..message)
    end
end

local function survivorText(survivors)
    local values={}
    for _,vertex in OuttaMyWay.ValueRecord.ipairs(survivors or {}) do
        values[#values+1]=string.format("%d:(%.1f,%.1f)",vertex.originalIndex,vertex.x,vertex.z)
    end
    return table.concat(values,",")
end

function Probe.new(fieldWorldSnapshots)
    return setmetatable({
        fieldWorldSnapshots=fieldWorldSnapshots,
        processedSnapshots={}
    },Probe)
end

function Probe:reset()
    self.processedSnapshots={}
end

function Probe:_publish(snapshot)
    if type(snapshot)~="table" or type(snapshot.referenceKey)~="string" then return nil end
    if self.processedSnapshots[snapshot.referenceKey] then return nil end
    self.processedSnapshots[snapshot.referenceKey]=true
    local analysis=Probe.analyzeSnapshot(snapshot)
    logInfo(
        "SNAPSHOT snapshot=%s polygon=%s input=%s sourcePoints=%d canonicalPoints=%d registryPoints=%s status=%s gapRatio=%s gap=%s->%s semanticAuthority=false control=false",
        tostring(snapshot.referenceKey),tostring(snapshot.fieldPolygonReferenceKey),tostring(analysis.inputSource),
        tonumber(analysis.sourceBoundaryPointCount) or 0,tonumber(analysis.canonicalBoundaryPointCount) or 0,
        tostring(analysis.registryBoundaryPointCount or "UNRESOLVED"),tostring(analysis.status),
        analysis.largestScaleGapRatio and string.format("%.3f",analysis.largestScaleGapRatio) or "UNRESOLVED",
        analysis.largestScaleGapBeforeM and string.format("%.3f",analysis.largestScaleGapBeforeM) or "UNRESOLVED",
        analysis.largestScaleGapAfterM and string.format("%.3f",analysis.largestScaleGapAfterM) or "UNRESOLVED"
    )
    for _,stage in OuttaMyWay.ValueRecord.ipairs(analysis.stages or {}) do
        if stage.remainingPointCount<=12 and stage.remainingPointCount>=4 then
            logInfo(
                "STAGE snapshot=%s remaining=%d survivors=%s semanticAuthority=false control=false",
                tostring(snapshot.referenceKey),stage.remainingPointCount,survivorText(stage.survivors)
            )
        end
    end
    for _,record in OuttaMyWay.ValueRecord.ipairs(analysis.removals or {}) do
        logInfo(
            "REMOVAL snapshot=%s ordinal=%d before=%d originalIndex=%d point=(%.1f,%.1f) scaleM=%.3f turnDeg=%s semanticAuthority=false control=false",
            tostring(snapshot.referenceKey),record.removalOrdinal,record.remainingBeforeRemoval,record.originalIndex,
            record.x,record.z,record.removalScaleM,
            record.localTurnDegrees and string.format("%.3f",record.localTurnDegrees) or "UNRESOLVED"
        )
    end
    return analysis
end

function Probe:update()
    local registry=self.fieldWorldSnapshots
    if registry==nil or type(registry.getRecords)~="function" or type(registry.get)~="function" then return end
    for _,record in OuttaMyWay.ValueRecord.ipairs(registry:getRecords() or {}) do
        local snapshot=registry:get(record.vehicleReferenceKey,record.captureToken)
        if snapshot~=nil then self:_publish(snapshot) end
    end
end

function Probe:loadMap() self:reset() end
function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end

