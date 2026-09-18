--- Diagnostic-only Boundary Feature Lineage probe for Issue #234 implementation discovery.
-- Reconstructs how exact canonical boundary intervals are inherited as persistence
-- removals replace adjacent simplified arcs.  The lineage is representation
-- provenance only and grants no Corner, Situation, Candidate, Decision,
-- Responsibility, Bounded Authority or Control authority.

OuttaMyWay.BoundaryFeatureLineageProbe = {}
local Probe=OuttaMyWay.BoundaryFeatureLineageProbe
Probe.__index=Probe

local EPSILON=0.000001

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function point(value,index)
    if type(value)~="table" then return nil end
    local x=tonumber(value.x or value[1])
    local z=tonumber(value.z or value[2] or value[3])
    if not finite(x) or not finite(z) then return nil end
    return {x=x,z=z,originalIndex=tonumber(value.originalIndex) or index}
end

local function boundaryPoints(boundary)
    local result={}
    for index,value in OuttaMyWay.ValueRecord.ipairs(boundary or {}) do
        local resolved=point(value,index)
        if resolved==nil then return nil end
        result[#result+1]=resolved
    end
    return result
end

local function nextIndex(index,count)
    return (index%count)+1
end

local function previousIndex(index,count)
    return ((index-2)%count)+1
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
    if inLength<=EPSILON or outLength<=EPSILON then return nil end
    local cross=inX*outZ-inZ*outX
    local dot=inX*outX+inZ*outZ
    return math.deg(atan2(cross,dot))
end

local function forwardIndices(startIndex,endIndex,count)
    local result={}
    local cursor=nextIndex(startIndex,count)
    local guard=0
    while cursor~=endIndex and guard<=count do
        result[#result+1]=cursor
        cursor=nextIndex(cursor,count)
        guard=guard+1
    end
    if cursor~=endIndex then return nil end
    return result
end

local function intervalGeometry(boundary,startIndex,endIndex)
    local count=OuttaMyWay.ValueRecord.length(boundary or {})
    if count<3 or startIndex==endIndex then return nil end
    local interior=forwardIndices(startIndex,endIndex,count)
    if interior==nil then return nil end

    local startPoint,endPoint=boundary[startIndex],boundary[endIndex]
    local chordLength=distance(startPoint,endPoint)
    local supportArcLength=0
    local cursor=startIndex
    local guard=0
    while cursor~=endIndex and guard<=count do
        local nextValue=nextIndex(cursor,count)
        supportArcLength=supportArcLength+distance(boundary[cursor],boundary[nextValue])
        cursor=nextValue
        guard=guard+1
    end
    if cursor~=endIndex then return nil end

    local netTurn,absoluteTurn,turnCount=0,0,0
    local maxDeviation=0
    local chordX,chordZ=endPoint.x-startPoint.x,endPoint.z-startPoint.z
    for _,originalIndex in OuttaMyWay.ValueRecord.ipairs(interior) do
        local turn=signedTurnDegrees(
            boundary[previousIndex(originalIndex,count)],
            boundary[originalIndex],
            boundary[nextIndex(originalIndex,count)]
        )
        if turn~=nil then
            netTurn=netTurn+turn
            absoluteTurn=absoluteTurn+math.abs(turn)
            turnCount=turnCount+1
        end
        local value=boundary[originalIndex]
        local deviation
        if chordLength<=EPSILON then
            deviation=distance(startPoint,value)
        else
            deviation=math.abs(
                chordX*(value.z-startPoint.z)-chordZ*(value.x-startPoint.x)
            )/chordLength
        end
        if deviation>maxDeviation then maxDeviation=deviation end
    end

    local netToAbsolute=nil
    if absoluteTurn>EPSILON then netToAbsolute=math.abs(netTurn)/absoluteTurn end
    return {
        collapsedOriginalIndices=interior,
        collapsedPointCount=OuttaMyWay.ValueRecord.length(interior),
        supportArcLengthM=supportArcLength,
        chordLengthM=chordLength,
        arcExcessM=supportArcLength-chordLength,
        maxDeviationM=maxDeviation,
        netSignedTurnDegrees=netTurn,
        absoluteTurnDegrees=absoluteTurn,
        turnCount=turnCount,
        netToAbsoluteTurnRatio=netToAbsolute
    }
end

local function edgeKey(startIndex,endIndex)
    return tostring(startIndex)..">"..tostring(endIndex)
end

local function copyIndices(values)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[#result+1]=value end
    return result
end

local function findCurrentPosition(current,originalIndex)
    for position,value in OuttaMyWay.ValueRecord.ipairs(current) do
        if value==originalIndex then return position end
    end
    return nil
end

function Probe.analyzeBoundary(boundary,persistence)
    local metric=boundaryPoints(boundary)
    local count=OuttaMyWay.ValueRecord.length(metric or {})
    local result={
        status="UNRESOLVED",
        reason=nil,
        originalPointCount=count,
        lineages={},
        rootLineageIds={},
        terminalSurvivorIndices={},
        semanticAuthority=false,
        controlAuthority=false,
        provenance={source="BoundaryFeatureLineageProbe",authority="DIAGNOSTIC_ONLY"}
    }
    if metric==nil or count<4 then
        result.reason="BOUNDARY_REQUIRES_AT_LEAST_FOUR_RESOLVED_POINTS"
        return result
    end

    local persistenceAnalysis=persistence
    if type(persistenceAnalysis)~="table" then
        persistenceAnalysis=OuttaMyWay.BoundaryFeaturePersistenceProbe.analyzeBoundary(metric)
    end
    if type(persistenceAnalysis)~="table" or persistenceAnalysis.status~="SUPPORTED_DIAGNOSTIC_ANALYSIS" then
        result.reason="BOUNDARY_PERSISTENCE_ANALYSIS_UNAVAILABLE"
        return result
    end

    local current={}
    local edgeLineage={}
    local lineageById={}
    for index=1,count do
        current[#current+1]=index
        edgeLineage[edgeKey(index,nextIndex(index,count))]=nil
    end

    for _,removal in OuttaMyWay.ValueRecord.ipairs(persistenceAnalysis.removals or {}) do
        local removedIndex=removal.originalIndex
        local position=findCurrentPosition(current,removedIndex)
        if position==nil or OuttaMyWay.ValueRecord.length(current)<=3 then
            result.reason="PERSISTENCE_REMOVAL_SEQUENCE_INCONSISTENT"
            return result
        end

        local currentCount=OuttaMyWay.ValueRecord.length(current)
        local previousOriginalIndex=current[previousIndex(position,currentCount)]
        local nextOriginalIndex=current[nextIndex(position,currentCount)]
        local leftLineageId=edgeLineage[edgeKey(previousOriginalIndex,removedIndex)]
        local rightLineageId=edgeLineage[edgeKey(removedIndex,nextOriginalIndex)]
        local geometry=intervalGeometry(metric,previousOriginalIndex,nextOriginalIndex)
        if geometry==nil then
            result.reason="LINEAGE_INTERVAL_GEOMETRY_UNRESOLVED"
            return result
        end

        local lineageId="BL-"..tostring(removal.removalOrdinal)
        local childLineageIds={}
        if leftLineageId~=nil then childLineageIds[#childLineageIds+1]=leftLineageId end
        if rightLineageId~=nil then childLineageIds[#childLineageIds+1]=rightLineageId end

        local depth=1
        for _,childId in OuttaMyWay.ValueRecord.ipairs(childLineageIds) do
            local child=lineageById[childId]
            if child~=nil then
                child.parentLineageId=lineageId
                local childDepth=tonumber(child.lineageDepth) or 1
                if childDepth+1>depth then depth=childDepth+1 end
            end
        end

        local lineage={
            lineageId=lineageId,
            collapseOrdinal=removal.removalOrdinal,
            removalScaleM=removal.removalScaleM,
            removedOriginalIndex=removedIndex,
            startOriginalIndex=previousOriginalIndex,
            endOriginalIndex=nextOriginalIndex,
            childLineageIds=childLineageIds,
            parentLineageId=nil,
            lineageDepth=depth,
            remainingBeforeRemoval=currentCount,
            remainingAfterRemoval=currentCount-1,
            collapsedOriginalIndices=copyIndices(geometry.collapsedOriginalIndices),
            collapsedPointCount=geometry.collapsedPointCount,
            supportArcLengthM=geometry.supportArcLengthM,
            chordLengthM=geometry.chordLengthM,
            arcExcessM=geometry.arcExcessM,
            maxDeviationM=geometry.maxDeviationM,
            netSignedTurnDegrees=geometry.netSignedTurnDegrees,
            absoluteTurnDegrees=geometry.absoluteTurnDegrees,
            turnCount=geometry.turnCount,
            netToAbsoluteTurnRatio=geometry.netToAbsoluteTurnRatio
        }
        lineageById[lineageId]=lineage
        result.lineages[#result.lineages+1]=lineage

        edgeLineage[edgeKey(previousOriginalIndex,removedIndex)]=nil
        edgeLineage[edgeKey(removedIndex,nextOriginalIndex)]=nil
        edgeLineage[edgeKey(previousOriginalIndex,nextOriginalIndex)]=lineageId
        table.remove(current,position)
    end

    for _,originalIndex in OuttaMyWay.ValueRecord.ipairs(current) do
        result.terminalSurvivorIndices[#result.terminalSurvivorIndices+1]=originalIndex
    end
    local terminalCount=OuttaMyWay.ValueRecord.length(current)
    for position,startOriginalIndex in OuttaMyWay.ValueRecord.ipairs(current) do
        local endOriginalIndex=current[nextIndex(position,terminalCount)]
        local lineageId=edgeLineage[edgeKey(startOriginalIndex,endOriginalIndex)]
        if lineageId~=nil then result.rootLineageIds[#result.rootLineageIds+1]=lineageId end
    end

    result.persistenceAnalysis=persistenceAnalysis
    result.status="SUPPORTED_DIAGNOSTIC_ANALYSIS"
    result.reason="BOUNDARY_COLLAPSE_LINEAGE_ANALYSED"
    return result
end

function Probe.analyzeSnapshot(snapshot)
    local persistence=OuttaMyWay.BoundaryFeaturePersistenceProbe.analyzeSnapshot(snapshot)
    local metric=persistence and persistence.metricBoundary or nil
    if type(metric)~="table" then
        local result=Probe.analyzeBoundary(nil,persistence)
        result.reason="PERSISTENCE_METRIC_BOUNDARY_UNAVAILABLE"
        result.inputSource=persistence and persistence.inputSource or "UNRESOLVED"
        return result
    end
    local result=Probe.analyzeBoundary(metric,persistence)
    result.inputSource=persistence.inputSource
    result.coordinateUnits=persistence.coordinateUnits
    result.quantizationMetres=persistence.quantizationMetres
    result.sourceBoundaryPointCount=persistence.sourceBoundaryPointCount
    result.canonicalBoundaryPointCount=persistence.canonicalBoundaryPointCount
    result.registryBoundaryPointCount=persistence.registryBoundaryPointCount
    return result
end

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][BOUNDARY-FEATURE-LINEAGE] %s",message)
    else
        print("[FS25_OuttaMyWay][BOUNDARY-FEATURE-LINEAGE] "..message)
    end
end

local function indexText(values)
    local result={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do result[#result+1]=tostring(value) end
    return table.concat(result,",")
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
        "SNAPSHOT snapshot=%s polygon=%s input=%s units=%s quantumM=%s points=%d lineages=%d roots=%s terminalSurvivors=%s status=%s semanticAuthority=false control=false",
        tostring(snapshot.referenceKey),tostring(snapshot.fieldPolygonReferenceKey),tostring(analysis.inputSource),
        tostring(analysis.coordinateUnits or "UNRESOLVED"),
        analysis.quantizationMetres and string.format("%.3f",analysis.quantizationMetres) or "UNRESOLVED",
        tonumber(analysis.originalPointCount) or 0,
        OuttaMyWay.ValueRecord.length(analysis.lineages or {}),
        indexText(analysis.rootLineageIds),indexText(analysis.terminalSurvivorIndices),
        tostring(analysis.status)
    )
    for _,lineage in OuttaMyWay.ValueRecord.ipairs(analysis.lineages or {}) do
        logInfo(
            "LINEAGE snapshot=%s id=%s ordinal=%d removed=%d interval=%d>%d collapsed=%s children=%s parent=%s depth=%d remaining=%d>%d scaleM=%s arcM=%.3f chordM=%.3f excessM=%.3f maxDeviationM=%.3f netDeg=%.3f absDeg=%.3f netToAbs=%s semanticAuthority=false control=false",
            tostring(snapshot.referenceKey),lineage.lineageId,lineage.collapseOrdinal,lineage.removedOriginalIndex,
            lineage.startOriginalIndex,lineage.endOriginalIndex,indexText(lineage.collapsedOriginalIndices),
            indexText(lineage.childLineageIds),tostring(lineage.parentLineageId or "ROOT"),lineage.lineageDepth,
            lineage.remainingBeforeRemoval,lineage.remainingAfterRemoval,
            lineage.removalScaleM and string.format("%.3f",lineage.removalScaleM) or "UNRESOLVED",
            lineage.supportArcLengthM,lineage.chordLengthM,lineage.arcExcessM,lineage.maxDeviationM,
            lineage.netSignedTurnDegrees,lineage.absoluteTurnDegrees,
            lineage.netToAbsoluteTurnRatio and string.format("%.3f",lineage.netToAbsoluteTurnRatio) or "UNRESOLVED"
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
