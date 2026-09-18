--- Diagnostic-only support/turn trajectory probe for Issue #234 implementation discovery.
-- Consumes Boundary Feature Persistence stages and publishes how a surviving
-- boundary sample's directional support evolves as subordinate samples disappear.
-- Grants no Situation, Candidate, Decision, Responsibility, Bounded Authority or Control authority.

OuttaMyWay.BoundaryTurnTrajectoryProbe = {}
local Probe=OuttaMyWay.BoundaryTurnTrajectoryProbe
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

local function nextIndex(index,count)
    return (index%count)+1
end

local function previousIndex(index,count)
    return ((index-2)%count)+1
end

local function forwardArcLengthM(boundary,startIndex,endIndex)
    local count=OuttaMyWay.ValueRecord.length(boundary or {})
    if count<2 or startIndex==endIndex then return 0 end
    local cursor,total,guard=startIndex,0,0
    while cursor~=endIndex and guard<=count do
        local nextValue=nextIndex(cursor,count)
        total=total+distance(boundary[cursor],boundary[nextValue])
        cursor=nextValue
        guard=guard+1
    end
    if cursor~=endIndex then return nil end
    return total
end

local function intervalTurn(boundary,startIndex,endIndex)
    local count=OuttaMyWay.ValueRecord.length(boundary or {})
    if count<3 or startIndex==endIndex then return nil,nil,nil end
    local cursor=nextIndex(startIndex,count)
    local net,absolute,turnCount,guard=0,0,0,0
    while cursor~=endIndex and guard<=count do
        local turn=signedTurnDegrees(
            boundary[previousIndex(cursor,count)],
            boundary[cursor],
            boundary[nextIndex(cursor,count)]
        )
        if turn~=nil then
            net=net+turn
            absolute=absolute+math.abs(turn)
            turnCount=turnCount+1
        end
        cursor=nextIndex(cursor,count)
        guard=guard+1
    end
    if cursor~=endIndex then return nil,nil,nil end
    return net,absolute,turnCount
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

local function removalByOriginalIndex(persistence)
    local result={}
    for _,record in OuttaMyWay.ValueRecord.ipairs(persistence and persistence.removals or {}) do
        result[record.originalIndex]=record
    end
    return result
end

local function newTrajectory(vertex,removal)
    return {
        originalIndex=vertex.originalIndex,
        x=vertex.x,
        z=vertex.z,
        removalOrdinal=removal and removal.removalOrdinal or nil,
        removalScaleM=removal and removal.removalScaleM or nil,
        removedAtRemainingCount=removal and removal.remainingBeforeRemoval or nil,
        states={}
    }
end

function Probe.analyzeBoundary(boundary,persistence)
    local metric=boundaryPoints(boundary)
    local count=OuttaMyWay.ValueRecord.length(metric or {})
    local result={
        status="UNRESOLVED",
        reason=nil,
        originalPointCount=count,
        trajectories={},
        semanticAuthority=false,
        controlAuthority=false,
        provenance={source="BoundaryTurnTrajectoryProbe",authority="DIAGNOSTIC_ONLY"}
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

    local removals=removalByOriginalIndex(persistenceAnalysis)
    local trajectoriesByIndex={}
    for index,vertex in OuttaMyWay.ValueRecord.ipairs(metric) do
        local originalIndex=vertex.originalIndex or index
        local trajectory=newTrajectory(vertex,removals[originalIndex])
        trajectoriesByIndex[originalIndex]=trajectory
        result.trajectories[#result.trajectories+1]=trajectory
    end

    for _,stage in OuttaMyWay.ValueRecord.ipairs(persistenceAnalysis.stages or {}) do
        local survivors=stage.survivors or {}
        local survivorCount=OuttaMyWay.ValueRecord.length(survivors)
        if survivorCount>=3 then
            for position,current in OuttaMyWay.ValueRecord.ipairs(survivors) do
                local previous=survivors[previousIndex(position,survivorCount)]
                local nextValue=survivors[nextIndex(position,survivorCount)]
                local trajectory=trajectoriesByIndex[current.originalIndex]
                if trajectory~=nil then
                    local chordSigned=signedTurnDegrees(previous,current,nextValue)
                    local beforeArc=forwardArcLengthM(metric,previous.originalIndex,current.originalIndex)
                    local afterArc=forwardArcLengthM(metric,current.originalIndex,nextValue.originalIndex)
                    local intervalNet,intervalAbsolute,intervalTurnCount=
                        intervalTurn(metric,previous.originalIndex,nextValue.originalIndex)
                    local netToAbsolute=nil
                    if intervalNet~=nil and intervalAbsolute~=nil and intervalAbsolute>EPSILON then
                        netToAbsolute=math.abs(intervalNet)/intervalAbsolute
                    end
                    trajectory.states[#trajectory.states+1]={
                        remainingPointCount=stage.remainingPointCount,
                        previousOriginalIndex=previous.originalIndex,
                        nextOriginalIndex=nextValue.originalIndex,
                        supportArcBeforeM=beforeArc,
                        supportArcAfterM=afterArc,
                        supportArcTotalM=(beforeArc and afterArc) and (beforeArc+afterArc) or nil,
                        chordTurnSignedDegrees=chordSigned,
                        chordTurnMagnitudeDegrees=chordSigned and math.abs(chordSigned) or nil,
                        supportNetSignedTurnDegrees=intervalNet,
                        supportAbsoluteTurnDegrees=intervalAbsolute,
                        supportTurnCount=intervalTurnCount,
                        netToAbsoluteTurnRatio=netToAbsolute,
                        isTerminalSimplificationStage=stage.remainingPointCount==3
                    }
                end
            end
        end
    end

    result.persistenceAnalysis=persistenceAnalysis
    result.status="SUPPORTED_DIAGNOSTIC_ANALYSIS"
    result.reason="PERSISTENCE_SUPPORT_TURN_TRAJECTORIES_ANALYSED"
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
        Logging.info("[FS25_OuttaMyWay][BOUNDARY-TURN-TRAJECTORY] %s",message)
    else
        print("[FS25_OuttaMyWay][BOUNDARY-TURN-TRAJECTORY] "..message)
    end
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
        "SNAPSHOT snapshot=%s polygon=%s input=%s units=%s quantumM=%s points=%d trajectories=%d status=%s semanticAuthority=false control=false",
        tostring(snapshot.referenceKey),tostring(snapshot.fieldPolygonReferenceKey),tostring(analysis.inputSource),
        tostring(analysis.coordinateUnits or "UNRESOLVED"),
        analysis.quantizationMetres and string.format("%.3f",analysis.quantizationMetres) or "UNRESOLVED",
        tonumber(analysis.originalPointCount) or 0,
        OuttaMyWay.ValueRecord.length(analysis.trajectories or {}),
        tostring(analysis.status)
    )

    for _,trajectory in OuttaMyWay.ValueRecord.ipairs(analysis.trajectories or {}) do
        logInfo(
            "TRAJECTORY snapshot=%s candidate=%d point=(%.1f,%.1f) removalOrdinal=%s removalScaleM=%s removedAt=%s semanticAuthority=false control=false",
            tostring(snapshot.referenceKey),trajectory.originalIndex,trajectory.x,trajectory.z,
            tostring(trajectory.removalOrdinal or "TERMINAL"),
            trajectory.removalScaleM and string.format("%.3f",trajectory.removalScaleM) or "TERMINAL",
            tostring(trajectory.removedAtRemainingCount or "TERMINAL")
        )
        for _,state in OuttaMyWay.ValueRecord.ipairs(trajectory.states or {}) do
            logInfo(
                "STATE snapshot=%s candidate=%d remaining=%d neighbours=%d>%d supportM=%s+%s=%s chordTurnDeg=%s intervalNetDeg=%s intervalAbsDeg=%s netToAbs=%s terminal=%s semanticAuthority=false control=false",
                tostring(snapshot.referenceKey),trajectory.originalIndex,state.remainingPointCount,
                state.previousOriginalIndex,state.nextOriginalIndex,
                state.supportArcBeforeM and string.format("%.3f",state.supportArcBeforeM) or "UNRESOLVED",
                state.supportArcAfterM and string.format("%.3f",state.supportArcAfterM) or "UNRESOLVED",
                state.supportArcTotalM and string.format("%.3f",state.supportArcTotalM) or "UNRESOLVED",
                state.chordTurnMagnitudeDegrees and string.format("%.3f",state.chordTurnMagnitudeDegrees) or "UNRESOLVED",
                state.supportNetSignedTurnDegrees and string.format("%.3f",state.supportNetSignedTurnDegrees) or "UNRESOLVED",
                state.supportAbsoluteTurnDegrees and string.format("%.3f",state.supportAbsoluteTurnDegrees) or "UNRESOLVED",
                state.netToAbsoluteTurnRatio and string.format("%.3f",state.netToAbsoluteTurnRatio) or "UNRESOLVED",
                tostring(state.isTerminalSimplificationStage)
            )
        end
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
