-- Diagnostic experiment for Issue #234. This probe consumes completed
-- Situation-owned Spatial Constraint knowledge and asks a deliberately wider
-- shadow question without changing Corner Atlas, Candidate, Responsibility,
-- Regulation, Bounded Authority, or Control semantics.

OuttaMyWay.SymmetricCornerDiscoveryProbe = {}
local Probe=OuttaMyWay.SymmetricCornerDiscoveryProbe
Probe.__index=Probe

local EPSILON_M=0.00001
local HEARTBEAT_MS=2000

local function finite(value)
    return type(value)=="number" and value==value and value~=math.huge and value~=-math.huge
end

local function logInfo(message)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][SYMMETRIC-CORNER-PROBE] %s",message)
    else
        print("[FS25_OuttaMyWay][SYMMETRIC-CORNER-PROBE] "..message)
    end
end

local function logWarning(message)
    if Logging~=nil and type(Logging.warning)=="function" then
        Logging.warning("[FS25_OuttaMyWay][SYMMETRIC-CORNER-PROBE] %s",message)
    else
        print("[FS25_OuttaMyWay][SYMMETRIC-CORNER-PROBE][WARNING] "..message)
    end
end

local function point(value)
    if type(value)~="table" then return nil end
    local x,z=tonumber(value.x or value[1]),tonumber(value.z or value[2] or value[3])
    if not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end

local function distance(a,b)
    local x,z=a.x-b.x,a.z-b.z
    return math.sqrt(x*x+z*z)
end

local function pointSegmentDistance(p,a,b)
    local x,z=b.x-a.x,b.z-a.z
    local squared=x*x+z*z
    if squared<=EPSILON_M*EPSILON_M then return distance(p,a) end
    local t=((p.x-a.x)*x+(p.z-a.z)*z)/squared
    if t<0 then t=0 elseif t>1 then t=1 end
    return distance(p,{x=a.x+t*x,z=a.z+t*z})
end

local function ringPoints(world,kind,index)
    if kind=="OUTER_BOUNDARY" and index==1 then return world and world.boundary or nil end
    if kind=="ISLAND_BOUNDARY" then
        for islandIndex,island in OuttaMyWay.ValueRecord.ipairs(world and world.islands or {}) do
            if islandIndex==index then return island end
        end
    end
end

local function vertexIdentity(kind,ringIndex,vertexIndex)
    return string.format("%s:%d:VERTEX:%d",tostring(kind),tonumber(ringIndex) or 0,tonumber(vertexIndex) or 0)
end

local function unresolved(reason,relationship)
    return {
        status="UNRESOLVED",positive=false,reason=reason,
        relationshipId=relationship and relationship.identity or nil,
        existingOverlay=relationship and relationship.spatialOverlay or nil,
        hypothesis="SYMMETRIC_MAX_WORKING_WIDTH_CORNER_DISCOVERY",
        authority="DIAGNOSTIC_ONLY",negativeClearanceAuthority=false,
        decisionAuthority=false,speedAuthority=false,controlAuthority=false
    }
end

-- Deliberately artificial experiment: both current bounded A8 centre-line
-- segments receive the pair's maximum current working width. The common width
-- is used only as a finite corridor around those existing segments. It does not
-- alter either worker's real productive demand and cannot establish clearance.
function Probe.evaluate(world,relationship)
    if type(relationship)~="table" then return unresolved("RELATIONSHIP_UNAVAILABLE",relationship) end
    if relationship.classification~="FORWARD_INTERSECTION" or relationship.relationshipStatus~="POSITIVE" then
        local result=unresolved("CURRENT_FORWARD_INTERSECTION_NOT_POSITIVE",relationship)
        result.status="NOT_APPLICABLE"
        return result
    end

    local a,b=relationship.subjectProjection,relationship.otherProjection
    if type(a)~="table" or type(b)~="table" or a.status~="SUPPORTED" or b.status~="SUPPORTED" then
        return unresolved("SUPPORTED_BOUNDED_PROJECTIONS_UNAVAILABLE",relationship)
    end
    local aWidth,bWidth=tonumber(a.workingWidthM),tonumber(b.workingWidthM)
    if not finite(aWidth) or aWidth<=0 or not finite(bWidth) or bWidth<=0 then
        return unresolved("POSITIVE_WORKING_WIDTH_EVIDENCE_UNAVAILABLE",relationship)
    end
    if a.boundaryRingKind~=b.boundaryRingKind or a.boundaryRingIndex~=b.boundaryRingIndex then
        local result=unresolved("PROJECTIONS_TERMINATE_ON_DIFFERENT_FIELD_WORLD_RINGS",relationship)
        result.status="NO_POSITIVE_WITNESS"
        result.subjectActualWorkingWidthM=aWidth; result.otherActualWorkingWidthM=bWidth
        return result
    end

    local points=ringPoints(world,a.boundaryRingKind,a.boundaryRingIndex)
    if points==nil or OuttaMyWay.ValueRecord.length(points)<2 then
        return unresolved("TERMINATING_FIELD_WORLD_RING_UNAVAILABLE",relationship)
    end

    local a0,a1={x=tonumber(a.currentX),z=tonumber(a.currentZ)},{x=tonumber(a.contactX),z=tonumber(a.contactZ)}
    local b0,b1={x=tonumber(b.currentX),z=tonumber(b.currentZ)},{x=tonumber(b.contactX),z=tonumber(b.contactZ)}
    if not finite(a0.x) or not finite(a0.z) or not finite(a1.x) or not finite(a1.z)
        or not finite(b0.x) or not finite(b0.z) or not finite(b1.x) or not finite(b1.z) then
        return unresolved("BOUNDED_PROJECTION_SEGMENTS_INVALID",relationship)
    end

    local commonWidthM=math.max(aWidth,bWidth)
    local commonHalfWidthM=commonWidthM/2
    local candidates={}
    for index,value in OuttaMyWay.ValueRecord.ipairs(points) do
        local vertex=point(value)
        if vertex~=nil then
            local subjectDistanceM=pointSegmentDistance(vertex,a0,a1)
            local otherDistanceM=pointSegmentDistance(vertex,b0,b1)
            if subjectDistanceM<=commonHalfWidthM+EPSILON_M and otherDistanceM<=commonHalfWidthM+EPSILON_M then
                candidates[#candidates+1]={
                    identity=vertexIdentity(a.boundaryRingKind,a.boundaryRingIndex,index),
                    x=vertex.x,z=vertex.z,
                    subjectDistanceToBoundedAxisM=subjectDistanceM,
                    otherDistanceToBoundedAxisM=otherDistanceM
                }
            end
        end
    end

    local result={
        status="NO_POSITIVE_WITNESS",positive=false,
        reason="NO_FIELD_WORLD_VERTEX_WITHIN_BOTH_SYMMETRIC_BOUNDED_CORRIDORS",
        relationshipId=relationship.identity,subjectAssemblyId=relationship.subjectAssemblyId,otherAssemblyId=relationship.otherAssemblyId,
        existingOverlay=relationship.spatialOverlay,
        subjectActualWorkingWidthM=aWidth,otherActualWorkingWidthM=bWidth,
        symmetricWorkingWidthM=commonWidthM,symmetricHalfWidthM=commonHalfWidthM,
        subjectWidthInflated=aWidth<commonWidthM,otherWidthInflated=bWidth<commonWidthM,
        candidateCount=OuttaMyWay.ValueRecord.length(candidates),candidates=candidates,
        hypothesis="SYMMETRIC_MAX_WORKING_WIDTH_CORNER_DISCOVERY",
        authority="DIAGNOSTIC_ONLY",negativeClearanceAuthority=false,
        decisionAuthority=false,speedAuthority=false,controlAuthority=false
    }
    if result.candidateCount==1 then
        result.status="POSITIVE_SYMMETRIC_CORNER_WITNESS"
        result.positive=true
        result.reason="ONE_FIELD_WORLD_VERTEX_WITHIN_BOTH_SYMMETRIC_BOUNDED_CORRIDORS"
        result.sharedVertex=candidates[1]
    elseif result.candidateCount>1 then
        result.status="UNRESOLVED"
        result.reason="MULTIPLE_FIELD_WORLD_VERTICES_WITHIN_BOTH_SYMMETRIC_BOUNDED_CORRIDORS"
    end
    return result
end

local function motionNames(picture)
    local result={}
    for _,motion in OuttaMyWay.ValueRecord.ipairs(picture and picture.motionEvidence or {}) do
        result[motion.assemblyId]=motion.name or tostring(motion.assemblyId)
    end
    return result
end

local function resultSignature(result)
    local vertex=result.sharedVertex
    return table.concat({
        tostring(result.status),tostring(result.reason),tostring(result.existingOverlay),
        tostring(result.subjectActualWorkingWidthM),tostring(result.otherActualWorkingWidthM),
        tostring(result.symmetricWorkingWidthM),tostring(result.candidateCount),
        tostring(vertex and vertex.identity or "none")
    },"|")
end

function Probe.new(delegate)
    return setmetatable({delegate=delegate,signatures={},lastHeartbeatAt={}},Probe)
end

function Probe:reset()
    self.signatures={}
    self.lastHeartbeatAt={}
end

function Probe:loadMap()
    self:reset()
    logInfo("Symmetric max-working-width Corner Discovery experiment active; diagnosticOnly=true semanticAuthority=false")
end

function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end
function Probe:update() end

function Probe:_observe(live,nowMilliseconds)
    local picture=live and live.picture
    local snapshot=live and live.snapshot
    if picture==nil or snapshot==nil or snapshot.fieldWorld==nil then return end
    local names=motionNames(picture)
    local seen={}
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relationship in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if relationship.classification=="FORWARD_INTERSECTION" and relationship.relationshipStatus=="POSITIVE" then
                local result=Probe.evaluate(snapshot.fieldWorld,relationship)
                local key=tostring(knowledge.operationId).."|"..tostring(relationship.identity)
                seen[key]=true
                local signature=resultSignature(result)
                local now=tonumber(nowMilliseconds) or 0
                if self.signatures[key]~=signature or self.lastHeartbeatAt[key]==nil or now-self.lastHeartbeatAt[key]>=HEARTBEAT_MS then
                    self.signatures[key]=signature
                    self.lastHeartbeatAt[key]=now
                    local vertex=result.sharedVertex
                    logInfo(string.format(
                    "operation=%s relationship=%s pair=%s(%s)|%s(%s) fiState=%s overlay=%s result=%s reason=%s actualWidths=%.3f|%.3f symmetricWidth=%.3f halfWidth=%.3f inflated=%s|%s candidateCount=%d vertex=%s vertexPosition=(%s,%s) axisDistances=%s|%s diagnosticOnly=true negativeClearanceAuthority=false decisionAuthority=false speedAuthority=false controlAuthority=false",
                    tostring(knowledge.operationId),tostring(relationship.identity),
                    tostring(names[relationship.subjectAssemblyId] or relationship.subjectAssemblyId),tostring(relationship.subjectAssemblyId),
                    tostring(names[relationship.otherAssemblyId] or relationship.otherAssemblyId),tostring(relationship.otherAssemblyId),
                    tostring(relationship.relationshipStatus),tostring(result.existingOverlay or "UNRESOLVED"),
                    tostring(result.status),tostring(result.reason),
                    tonumber(result.subjectActualWorkingWidthM) or -1,tonumber(result.otherActualWorkingWidthM) or -1,
                    tonumber(result.symmetricWorkingWidthM) or -1,tonumber(result.symmetricHalfWidthM) or -1,
                    tostring(result.subjectWidthInflated==true),tostring(result.otherWidthInflated==true),tonumber(result.candidateCount) or 0,
                    tostring(vertex and vertex.identity or "none"),
                    vertex and string.format("%.3f",vertex.x) or "UNRESOLVED",vertex and string.format("%.3f",vertex.z) or "UNRESOLVED",
                        vertex and string.format("%.3f",vertex.subjectDistanceToBoundedAxisM) or "UNRESOLVED",
                        vertex and string.format("%.3f",vertex.otherDistanceToBoundedAxisM) or "UNRESOLVED"))
                end
            end
        end
    end
    for key in OuttaMyWay.ValueRecord.pairs(self.signatures) do
        if not seen[key] then self.signatures[key]=nil; self.lastHeartbeatAt[key]=nil end
    end
end

-- The wrapper preserves the existing PassiveLiveValidator observer contract and
-- isolates this experiment so a probe failure cannot suppress normal diagnostics.
function Probe:beginRuntimeCycle(...)
    if self.delegate and type(self.delegate.beginRuntimeCycle)=="function" then return self.delegate:beginRuntimeCycle(...) end
    return false
end

function Probe:observeRuntimeResult(raw,live,due,nowMilliseconds)
    local record=nil
    if self.delegate and type(self.delegate.observeRuntimeResult)=="function" then
        record=self.delegate:observeRuntimeResult(raw,live,due,nowMilliseconds)
    end
    local ok,err=pcall(self._observe,self,live,nowMilliseconds)
    if not ok then logWarning("probe evaluation failed: "..tostring(err)) end
    return record
end

function Probe:endRuntimeCycle(...)
    if self.delegate and type(self.delegate.endRuntimeCycle)=="function" then return self.delegate:endRuntimeCycle(...) end
end

function Probe:observeRuntimeError(...)
    if self.delegate and type(self.delegate.observeRuntimeError)=="function" then return self.delegate:observeRuntimeError(...) end
end
