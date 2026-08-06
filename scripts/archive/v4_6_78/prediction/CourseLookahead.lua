-- FS25_OuttaMyWay v4.0.1.0
-- Reads GIANTS AIDriveStrategyFieldCourse data and emits conservative
-- predictive HOLD recommendations. Vehicle control remains in Runtime.lua.

OuttaMyWay.CourseLookahead = OuttaMyWay.CourseLookahead or {}
local CL = OuttaMyWay.CourseLookahead

local function nowMs() return g_time or 0 end

local function vehicleName(vehicle)
    if vehicle == nil then return "<nil>" end
    for _, methodName in ipairs({"getName", "getFullName"}) do
        local method = vehicle[methodName]
        if method ~= nil then
            local ok, value = pcall(method, vehicle)
            if ok and value ~= nil and value ~= "" then return tostring(value) end
        end
    end
    return tostring(vehicle)
end

local function className(value)
    if value == nil then return "nil" end
    local mt = getmetatable(value)
    if mt ~= nil then
        if mt.className ~= nil then return tostring(mt.className) end
        if type(mt.__index) == "table" and mt.__index.className ~= nil then return tostring(mt.__index.className) end
    end
    if type(value) == "table" and value.className ~= nil then return tostring(value.className) end
    return tostring(value)
end

local function finiteNumber(value)
    return type(value) == "number" and value == value and math.abs(value) < 10000000 and value or nil
end

local function sortedKeys(value, maxKeys)
    if type(value) ~= "table" then return "<" .. type(value) .. ">" end
    local rendered = {}
    for key, item in pairs(value) do
        local itemType = type(item)
        local suffix = ""
        if itemType == "number" or itemType == "boolean" or itemType == "string" then
            suffix = "=" .. tostring(item)
        end
        rendered[#rendered + 1] = tostring(key) .. ":" .. itemType .. suffix
        if #rendered >= (maxKeys or 36) then break end
    end
    table.sort(rendered)
    return table.concat(rendered, ", ")
end

local function findFieldCourseStrategy(vehicle)
    if vehicle == nil then return nil, "vehicle=nil" end
    local candidates = {}
    local function append(spec, source)
        if type(spec) == "table" and type(spec.driveStrategies) == "table" then
            for index, strategy in ipairs(spec.driveStrategies) do
                candidates[#candidates + 1] = {strategy=strategy, source=source .. ".driveStrategies[" .. index .. "]"}
            end
        end
    end
    append(vehicle.spec_aiVehicle, "spec_aiVehicle")
    append(vehicle.spec_aiFieldWorker, "spec_aiFieldWorker")
    if type(vehicle.driveStrategies) == "table" then
        for index, strategy in ipairs(vehicle.driveStrategies) do
            candidates[#candidates + 1] = {strategy=strategy, source="vehicle.driveStrategies[" .. index .. "]"}
        end
    end
    for _, candidate in ipairs(candidates) do
        local strategy = candidate.strategy
        local name = className(strategy)
        if strategy ~= nil and (strategy.aiFieldCourse ~= nil or string.find(name, "FieldCourse", 1, true) ~= nil) then
            return strategy, candidate.source
        end
    end
    return nil, #candidates > 0 and ("searched=" .. #candidates) or "no strategy arrays"
end

local namedCoordinatePairs = {
    {"x", "z"}, {"worldX", "worldZ"}, {"positionX", "positionZ"},
    {"startX", "startZ"}, {"endX", "endZ"}, {"targetX", "targetZ"},
    {"cx", "cz"}, {"posX", "posZ"}
}

local function addCandidate(candidates, x, z, source, confidence)
    x, z = finiteNumber(x), finiteNumber(z)
    if x == nil or z == nil then return end
    candidates[#candidates + 1] = {x=x, z=z, source=source, confidence=confidence or 1}
end

-- Position records vary between builds. Extract named fields first, then common
-- compact vector layouts ([1],[2]) and ([1],[3]). All choices are logged.
local function extractPositionRecord(record, prefix)
    local candidates = {}
    if type(record) ~= "table" then return candidates end
    for _, names in ipairs(namedCoordinatePairs) do
        addCandidate(candidates, record[names[1]], record[names[2]], prefix .. "." .. names[1] .. "/" .. names[2], 4)
    end
    addCandidate(candidates, record[1], record[2], prefix .. ".[1]/[2]", 2)
    addCandidate(candidates, record[1], record[3], prefix .. ".[1]/[3]", 1)
    for key, child in pairs(record) do
        if type(child) == "table" then
            for _, names in ipairs(namedCoordinatePairs) do
                addCandidate(candidates, child[names[1]], child[names[2]], prefix .. "." .. tostring(key) .. "." .. names[1] .. "/" .. names[2], 3)
            end
            addCandidate(candidates, child[1], child[2], prefix .. "." .. tostring(key) .. ".[1]/[2]", 1)
        end
    end
    table.sort(candidates, function(a,b) return a.confidence > b.confidence end)
    return candidates
end

local function selectCandidate(candidates, referenceX, referenceZ)
    if #candidates == 0 then return nil end
    local best, bestScore = nil, math.huge
    for _, candidate in ipairs(candidates) do
        local proximity = 0
        if referenceX ~= nil and referenceZ ~= nil then
            local dx, dz = candidate.x-referenceX, candidate.z-referenceZ
            proximity = math.sqrt(dx*dx+dz*dz)
        end
        -- Confidence dominates, proximity breaks ties and rejects absurd layouts.
        local score = proximity - candidate.confidence * 10000
        if score < bestScore then best, bestScore = candidate, score end
    end
    return best
end

local function segmentSummary(segment, index, referenceX, referenceZ)
    local summary = {
        index=index, keys=sortedKeys(segment, 40), points={}, positionSchemas={},
        length=type(segment)=="table" and segment.length or nil,
        isHeadland=type(segment)=="table" and segment.isHeadlandSegment or nil,
        isIsland=type(segment)=="table" and segment.isIslandSegment or nil,
        lineGroupIndex=type(segment)=="table" and segment.lineGroupIndex or nil,
        offsetLineIndex=type(segment)=="table" and segment.offsetLineIndex or nil,
        segmentId=type(segment)=="table" and segment.segmentId or nil
    }
    if type(segment) ~= "table" then return summary end
    local positions = segment.positions
    if type(positions) ~= "table" then return summary end
    for positionIndex, record in ipairs(positions) do
        if positionIndex <= 3 then
            summary.positionSchemas[#summary.positionSchemas+1] = {
                index=positionIndex,
                keys=sortedKeys(record, 32),
                rawType=type(record)
            }
        end
        local candidates = extractPositionRecord(record, "segment.positions[" .. positionIndex .. "]")
        local selected = selectCandidate(candidates, referenceX, referenceZ)
        if selected ~= nil then
            local previous = summary.points[#summary.points]
            if previous == nil or math.abs(previous.x-selected.x) > 0.01 or math.abs(previous.z-selected.z) > 0.01 then
                summary.points[#summary.points+1] = {
                    x=selected.x, z=selected.z, source=selected.source,
                    positionIndex=positionIndex, candidates=candidates
                }
            end
        end
    end
    return summary
end

local function pointDistance(a,b)
    local dx, dz = b.x-a.x, b.z-a.z
    return math.sqrt(dx*dx+dz*dz)
end

local function pointSegmentDistance(px,pz,a,b)
    local vx,vz=b.x-a.x,b.z-a.z
    local wx,wz=px-a.x,pz-a.z
    local len2=vx*vx+vz*vz
    if len2 < 0.0001 then return math.sqrt(wx*wx+wz*wz),0 end
    local t=math.max(0,math.min(1,(wx*vx+wz*vz)/len2))
    local qx,qz=a.x+t*vx,a.z+t*vz
    local dx,dz=px-qx,pz-qz
    return math.sqrt(dx*dx+dz*dz),t
end

local function findClosestSegment(segments,x,z)
    if x == nil or z == nil then return nil,nil,nil end
    local bestIndex,bestDistance,bestFraction=nil,math.huge,nil
    for index, segment in ipairs(segments) do
        for p=1,#segment.points-1 do
            local d,t=pointSegmentDistance(x,z,segment.points[p],segment.points[p+1])
            if d < bestDistance then
                bestIndex,bestDistance,bestFraction=index,d,(p-1+t)/math.max(1,#segment.points-1)
            end
        end
    end
    return bestIndex,bestDistance,bestFraction
end

local function segmentTurnAngle(previous,current)
    if previous == nil or current == nil or #previous.points < 2 or #current.points < 2 then return nil end
    local a1,a2=previous.points[#previous.points-1],previous.points[#previous.points]
    local b1,b2=current.points[1],current.points[2]
    local ax,az=a2.x-a1.x,a2.z-a1.z
    local bx,bz=b2.x-b1.x,b2.z-b1.z
    local al,bl=math.sqrt(ax*ax+az*az),math.sqrt(bx*bx+bz*bz)
    if al < 0.001 or bl < 0.001 then return nil end
    local dot=math.max(-1,math.min(1,(ax*bx+az*bz)/(al*bl)))
    local cross=ax*bz-az*bx
    local angle=math.deg(math.acos(dot))
    return cross < 0 and -angle or angle
end

local function appendPoint(points, point, segmentIndex)
    if point == nil then return end
    local previous=points[#points]
    if previous == nil or math.abs(previous.x-point.x)>0.01 or math.abs(previous.z-point.z)>0.01 then
        points[#points+1]={x=point.x,z=point.z,segment=segmentIndex,source=point.source}
    end
end

local function projectToSegment(px,pz,a,b)
    local vx,vz=b.x-a.x,b.z-a.z
    local len2=vx*vx+vz*vz
    if len2 < 0.0001 then return {x=a.x,z=a.z},0 end
    local t=math.max(0,math.min(1,((px-a.x)*vx+(pz-a.z)*vz)/len2))
    return {x=a.x+t*vx,z=a.z+t*vz,source="vehicleProjection"},t
end

local function remainingSegmentPoints(segment, vehicleX, vehicleZ)
    local output={}
    if segment == nil or #segment.points < 2 then return output,0 end
    local bestP,bestDistance,bestT=1,math.huge,0
    for p=1,#segment.points-1 do
        local d,t=pointSegmentDistance(vehicleX,vehicleZ,segment.points[p],segment.points[p+1])
        if d < bestDistance then bestP,bestDistance,bestT=p,d,t end
    end
    local projected=projectToSegment(vehicleX,vehicleZ,segment.points[bestP],segment.points[bestP+1])
    output[#output+1]=projected
    for p=bestP+1,#segment.points do output[#output+1]=segment.points[p] end
    local remaining=0
    for p=1,#output-1 do remaining=remaining+pointDistance(output[p],output[p+1]) end
    return output,remaining,bestDistance,bestT
end

local function buildPolyline(strategy, vehicleX, vehicleZ, speedKmh, activeInfo, previousActive)
    local result={points={},segments={},source="none",activeIndex=nil,totalRemainingDistance=0,horizonDistance=0}
    local aiFieldCourse=strategy and strategy.aiFieldCourse or nil
    local fieldCourse=aiFieldCourse and aiFieldCourse.fieldCourse or nil
    local segments=fieldCourse and fieldCourse.segments or nil
    if type(segments) ~= "table" then return result end
    result.source="strategy.aiFieldCourse.fieldCourse.segments"
    for index, segment in ipairs(segments) do
        result.segments[#result.segments+1]=segmentSummary(segment,index,vehicleX,vehicleZ)
    end
    local nearestIndex,nearestDistance,nearestFraction=findClosestSegment(result.segments,vehicleX,vehicleZ)
    local bestIndex,bestScore=nil,math.huge
    local activeLength=activeInfo and finiteNumber(activeInfo.length) or nil
    local activeIsTurn=activeInfo and activeInfo.isTurn or nil
    for index,segment in ipairs(result.segments) do
        if #segment.points >= 2 then
            local distance=math.huge
            local fraction=0
            for p=1,#segment.points-1 do
                local d,t=pointSegmentDistance(vehicleX,vehicleZ,segment.points[p],segment.points[p+1])
                if d<distance then distance,fraction=d,(p-1+t)/math.max(1,#segment.points-1) end
            end
            local score=distance
            if activeLength~=nil and finiteNumber(segment.length)~=nil then
                score=score+math.min(80,math.abs(segment.length-activeLength)*0.35)
            end
            if activeIsTurn~=nil then
                local candidateTurn=segment.isHeadland==true or math.abs(segmentTurnAngle(result.segments[index-1],segment) or 0)>25
                if candidateTurn~=activeIsTurn then score=score+35 end
            end
            if previousActive and previousActive.index then
                local delta=math.abs(index-previousActive.index)
                if delta>2 then score=score+math.min(120,(delta-2)*25) end
                if index<previousActive.index-1 then score=score+60 end
            end
            if score<bestScore then bestIndex,bestScore=index,score end
        end
    end
    result.activeIndex=bestIndex or nearestIndex
    result.activeDistance=nearestDistance
    result.activeFraction=nearestFraction
    if result.activeIndex~=nil then
        local selected=result.segments[result.activeIndex]
        local _,distance,fraction=findClosestSegment({selected},vehicleX,vehicleZ)
        result.activeDistance=distance
        result.activeFraction=fraction
    end
    result.activeConfidence=(result.activeDistance~=nil and result.activeDistance<=12) and "high" or ((result.activeDistance~=nil and result.activeDistance<=25) and "medium" or "low")
    local startIndex=result.activeIndex or 1
    local maxSegments=OuttaMyWay.COURSE_LOOKAHEAD_MAX_SEGMENTS or 8
    local maxPoints=OuttaMyWay.COURSE_LOOKAHEAD_MAX_POINTS or 140
    local horizonSeconds=OuttaMyWay.COURSE_LOOKAHEAD_HORIZON_SECONDS or 30
    local speedMps=math.max((speedKmh or 0)/3.6, OuttaMyWay.COURSE_LOOKAHEAD_MIN_SPEED_MPS or 1.5)
    local maxDistance=math.max(OuttaMyWay.COURSE_LOOKAHEAD_MIN_DISTANCE or 45, speedMps*horizonSeconds)
    result.horizonDistance=maxDistance

    for index=startIndex,#result.segments do
        local segment=result.segments[index]
        segment.turnAngle=segmentTurnAngle(result.segments[index-1],segment)
        local points
        if index==startIndex then
            points,segment.remainingDistance,segment.closestDistance,segment.closestFraction=remainingSegmentPoints(segment,vehicleX,vehicleZ)
        else
            points=segment.points
            local len=0
            for p=1,#points-1 do len=len+pointDistance(points[p],points[p+1]) end
            segment.remainingDistance=len
        end
        result.totalRemainingDistance=result.totalRemainingDistance+(segment.remainingDistance or 0)
        if index<=startIndex+maxSegments-1 and #result.points<maxPoints then
            for _,point in ipairs(points or {}) do
                if #result.points > 0 and (result.lookaheadDistance or 0) >= maxDistance then break end
                local before=result.points[#result.points]
                appendPoint(result.points,point,index)
                local after=result.points[#result.points]
                if before~=nil and after~=before then
                    result.lookaheadDistance=(result.lookaheadDistance or 0)+pointDistance(before,after)
                end
            end
        end
    end
    result.lookaheadDistance=result.lookaheadDistance or 0
    result.estimatedRemainingSeconds=result.totalRemainingDistance/speedMps
    return result
end
local function lineIntersection(a1,a2,b1,b2)
    local rx,rz=a2.x-a1.x,a2.z-a1.z
    local sx,sz=b2.x-b1.x,b2.z-b1.z
    local denominator=rx*sz-rz*sx
    if math.abs(denominator)<0.0001 then return nil end
    local qx,qz=b1.x-a1.x,b1.z-a1.z
    local t=(qx*sz-qz*sx)/denominator
    local u=(qx*rz-qz*rx)/denominator
    if t>=0 and t<=1 and u>=0 and u<=1 then return {x=a1.x+t*rx,z=a1.z+t*rz,t=t,u=u} end
    return nil
end

local function pathDistanceTo(points,segmentIndex,fraction)
    local total=0
    for index=1,segmentIndex-1 do total=total+pointDistance(points[index],points[index+1]) end
    if points[segmentIndex] and points[segmentIndex+1] then
        total=total+pointDistance(points[segmentIndex],points[segmentIndex+1])*(fraction or 0)
    end
    return total
end

local function findIntersections(a,b)
    local hits={}
    for i=1,#a.points-1 do
        for j=1,#b.points-1 do
            local hit=lineIntersection(a.points[i],a.points[i+1],b.points[j],b.points[j+1])
            if hit then
                hit.aSegment=i; hit.bSegment=j
                hit.aDistance=pathDistanceTo(a.points,i,hit.t)
                hit.bDistance=pathDistanceTo(b.points,j,hit.u)
                hits[#hits+1]=hit
                if #hits>=12 then return hits end
            end
        end
    end
    return hits
end

function CL:init()
    self.lastVehicleLog=self.lastVehicleLog or {}
    self.lastPairLog=self.lastPairLog or {}
    self.schemaLogged=self.schemaLogged or {}
    self.vehicleSignature=self.vehicleSignature or {}
    self.pairSignature=self.pairSignature or {}
    self.activeState=self.activeState or {}
    self.recommendations=self.recommendations or {}
end

function CL:readVehicle(data)
    local vehicle=data.vehicle
    local strategy,source=findFieldCourseStrategy(vehicle)
    local snapshot={vehicle=vehicle,name=vehicleName(vehicle),strategy=strategy,strategySource=source,
        strategyClass=className(strategy),speedKmh=data.speedKmh or 0,workingWidth=data.workingWidth or 0,
        x=data.x,z=data.z,dx=data.dx,dz=data.dz}
    if strategy==nil then return snapshot end
    snapshot.fieldDetectionInProgress=strategy.fieldDetectionInProgress
    snapshot.isBlocked=strategy.isBlocked
    snapshot.hasStaticCollision=strategy.hasStaticCollision
    snapshot.collisionDistance=strategy.collisionDistance
    snapshot.lastSegmentIsTurn=strategy.lastSegmentIsTurn
    snapshot.lastMovingDirection=strategy.lastMovingDirection
    snapshot.nextSegmentTurnSide=strategy.nextSegmentTurnSide
    snapshot.lastSegmentTurnSide=strategy.lastSegmentTurnSide
    snapshot.aiFieldCourse=strategy.aiFieldCourse
    if snapshot.aiFieldCourse and snapshot.aiFieldCourse.getActiveSegmentData then
        local ok,a,b,c,d,e,f=pcall(snapshot.aiFieldCourse.getActiveSegmentData,snapshot.aiFieldCourse)
        snapshot.activeCallOk=ok
        if ok then snapshot.activeIsTurn=a; snapshot.activeIsInitial=b; snapshot.activePosition=c; snapshot.activeLength=d; snapshot.activeSubPosition=e; snapshot.activeSubLength=f
        else snapshot.activeError=tostring(a) end
    end
    if snapshot.aiFieldCourse and snapshot.aiFieldCourse.getNextSegmentData then
        local values={pcall(snapshot.aiFieldCourse.getNextSegmentData,snapshot.aiFieldCourse)}
        snapshot.nextCallOk=table.remove(values,1); snapshot.nextValues=values
    end
    local previous=self.activeState[vehicle]
    snapshot.polyline=buildPolyline(strategy,snapshot.x,snapshot.z,snapshot.speedKmh,{
        isTurn=snapshot.activeIsTurn,
        length=snapshot.activeLength,
        position=snapshot.activePosition
    },previous)
    if snapshot.polyline.activeIndex~=nil then
        self.activeState[vehicle]={
            index=snapshot.polyline.activeIndex,
            distance=snapshot.polyline.activeDistance,
            at=nowMs()
        }
    end
    return snapshot
end

local function rounded(value, quantum)
    if type(value)~="number" then return "nil" end
    quantum=quantum or 1
    return tostring(math.floor(value/quantum+0.5)*quantum)
end

local function vehicleSignature(snapshot)
    local p=snapshot.polyline or {}
    return table.concat({
        tostring(p.activeIndex), rounded(snapshot.activePosition,0.05), tostring(snapshot.activeIsTurn),
        rounded(snapshot.speedKmh,1), rounded(p.lookaheadDistance,5), rounded(p.totalRemainingDistance,10),
        tostring(snapshot.fieldDetectionInProgress), tostring(snapshot.isBlocked)
    },"|")
end

local function pairKey(a,b)
    local av,bv=tostring(a.vehicle),tostring(b.vehicle)
    return av<bv and av.."|"..bv or bv.."|"..av
end

function CL:logVehicle(snapshot,force)
    local now=nowMs(); local last=self.lastVehicleLog[snapshot.vehicle] or 0
    local signature=vehicleSignature(snapshot)
    local changed=self.vehicleSignature[snapshot.vehicle]~=signature
    local heartbeat=now-last>=(OuttaMyWay.COURSE_LOOKAHEAD_HEARTBEAT_MS or 15000)
    if not force and not changed and not heartbeat then return end
    self.vehicleSignature[snapshot.vehicle]=signature
    self.lastVehicleLog[snapshot.vehicle]=now
    if snapshot.strategy==nil then
        print(string.format("Info: [FS25_OuttaMyWay] COURSE AI: %s strategy=NOT_FOUND (%s)",snapshot.name,snapshot.strategySource or "unknown")); return
    end
    print(string.format("Info: [FS25_OuttaMyWay] COURSE AI: %s source=%s class=%s detection=%s course=%s blocked=%s static=%s collision=%s speed=%.1f",
        snapshot.name,tostring(snapshot.strategySource),tostring(snapshot.strategyClass),tostring(snapshot.fieldDetectionInProgress),
        tostring(snapshot.aiFieldCourse~=nil),tostring(snapshot.isBlocked),tostring(snapshot.hasStaticCollision),
        snapshot.collisionDistance and string.format("%.1f",snapshot.collisionDistance) or "nil",snapshot.speedKmh or 0))
    print(string.format("Info: [FS25_OuttaMyWay] COURSE ACTIVE: %s ok=%s turn=%s initial=%s pos=%s len=%s subPos=%s subLen=%s lastTurn=%s moveDir=%s nextTurnSide=%s",
        snapshot.name,tostring(snapshot.activeCallOk),tostring(snapshot.activeIsTurn),tostring(snapshot.activeIsInitial),
        snapshot.activePosition and string.format("%.3f",snapshot.activePosition) or "nil",snapshot.activeLength and string.format("%.1f",snapshot.activeLength) or "nil",
        snapshot.activeSubPosition and string.format("%.3f",snapshot.activeSubPosition) or "nil",snapshot.activeSubLength and string.format("%.1f",snapshot.activeSubLength) or "nil",
        tostring(snapshot.lastSegmentIsTurn),tostring(snapshot.lastMovingDirection),tostring(snapshot.nextSegmentTurnSide)))
    local poly=snapshot.polyline
    print(string.format("Info: [FS25_OuttaMyWay] COURSE FUTURE PATH: %s source=%s segments=%d points=%d active=%s confidence=%s courseOffset=%s fraction=%s horizon=%.1fm extracted=%.1fm remaining=%.1fm finishETA=%.1fs",
        snapshot.name,tostring(poly.source),#poly.segments,#poly.points,tostring(poly.activeIndex),tostring(poly.activeConfidence),
        poly.activeDistance and string.format("%.1f",poly.activeDistance) or "nil",poly.activeFraction and string.format("%.3f",poly.activeFraction) or "nil",
        poly.horizonDistance or 0,poly.lookaheadDistance or 0,poly.totalRemainingDistance or 0,poly.estimatedRemainingSeconds or 0))
    if not self.schemaLogged[snapshot.vehicle] and #poly.segments>0 then
        self.schemaLogged[snapshot.vehicle]=true
        for i=1,math.min(5,#poly.segments) do
            local segment=poly.segments[i]
            print(string.format("Info: [FS25_OuttaMyWay] COURSE SEGMENT SCHEMA: %s #%d id=%s len=%s headland=%s island=%s lineGroup=%s offset=%s keys={%s}",
                snapshot.name,segment.index,tostring(segment.segmentId),tostring(segment.length),tostring(segment.isHeadland),tostring(segment.isIsland),
                tostring(segment.lineGroupIndex),tostring(segment.offsetLineIndex),segment.keys))
            for _, schema in ipairs(segment.positionSchemas) do
                print(string.format("Info: [FS25_OuttaMyWay] COURSE POSITION SCHEMA: %s segment=%d position=%d type=%s keys={%s}",
                    snapshot.name,segment.index,schema.index,schema.rawType,schema.keys))
            end
            for p=1,math.min(5,#segment.points) do
                local point=segment.points[p]
                print(string.format("Info: [FS25_OuttaMyWay] COURSE SEGMENT POINT: %s #%d p%d=(%.2f,%.2f) via=%s candidates=%d",
                    snapshot.name,segment.index,p,point.x,point.z,point.source,#(point.candidates or {})))
            end
        end
    end
    if poly.activeIndex then
        for i=poly.activeIndex,math.min(#poly.segments,poly.activeIndex+3) do
            local segment=poly.segments[i]
            local first,last=segment.points[1],segment.points[#segment.points]
            print(string.format("Info: [FS25_OuttaMyWay] COURSE FUTURE SEGMENT: %s #%d rel=%d points=%d start=%s end=%s len=%s headland=%s angle=%s",
                snapshot.name,i,i-poly.activeIndex,#segment.points,
                first and string.format("(%.1f,%.1f)",first.x,first.z) or "nil",
                last and string.format("(%.1f,%.1f)",last.x,last.z) or "nil",
                tostring(segment.length),tostring(segment.isHeadland),segment.turnAngle and string.format("%.1fdeg",segment.turnAngle) or "nil"))
        end
    end
end

function CL:logPair(a,b)
    local key=pairKey(a,b)
    local now=nowMs()
    if not a.polyline or not b.polyline or #a.polyline.points<2 or #b.polyline.points<2 then
        local sig="unavailable:"..tostring(a.polyline and #a.polyline.points or 0)..":"..tostring(b.polyline and #b.polyline.points or 0)
        if self.pairSignature[key]~=sig or now-(self.lastPairLog[key] or 0)>=(OuttaMyWay.COURSE_LOOKAHEAD_HEARTBEAT_MS or 15000) then
            self.pairSignature[key]=sig; self.lastPairLog[key]=now
            print(string.format("Info: [FS25_OuttaMyWay] COURSE LOOKAHEAD: %s / %s unavailable points=%d/%d",a.name,b.name,a.polyline and #a.polyline.points or 0,b.polyline and #b.polyline.points or 0))
        end
        return
    end
    local hits=findIntersections(a.polyline,b.polyline)
    local best=nil
    local aSpeed=math.max((a.speedKmh or 0)/3.6,OuttaMyWay.COURSE_LOOKAHEAD_MIN_SPEED_MPS or 1.5)
    local bSpeed=math.max((b.speedKmh or 0)/3.6,OuttaMyWay.COURSE_LOOKAHEAD_MIN_SPEED_MPS or 1.5)
    for _,hit in ipairs(hits) do
        hit.aEta=hit.aDistance/aSpeed; hit.bEta=hit.bDistance/bSpeed
        hit.gap=math.abs(hit.aEta-hit.bEta)
        hit.maxEta=math.max(hit.aEta,hit.bEta)
        if hit.maxEta<=(OuttaMyWay.COURSE_LOOKAHEAD_HORIZON_SECONDS or 30) and (best==nil or hit.maxEta<best.maxEta) then best=hit end
    end
    local completionA=a.polyline.estimatedRemainingSeconds or math.huge
    local completionB=b.polyline.estimatedRemainingSeconds or math.huge
    local completionPriority=completionA<completionB and a or b
    local completionDelta=math.abs(completionA-completionB)
    local sig
    if best==nil then
        sig=string.format("clear:%s:%s",rounded(completionA,10),rounded(completionB,10))
    else
        local conflict=best.gap<=(OuttaMyWay.COURSE_LOOKAHEAD_TIME_GAP_SECONDS or 8)
        local arrivalFirst=best.aEta<best.bEta and a or b
        local hold=arrivalFirst
        if conflict and completionDelta>=(OuttaMyWay.COURSE_COMPLETION_PRIORITY_MIN_DELTA_SECONDS or 15) then
            -- If the later-arriving worker is much closer to finishing, hold the other one.
            hold=completionPriority==a and b or a
        end
        local clearDelay=math.max(0,(OuttaMyWay.COURSE_INTERSECTION_CLEARANCE_SECONDS or 3)+best.gap)
        best.conflict=conflict; best.hold=hold; best.completionPriority=completionPriority; best.clearDelay=clearDelay
        sig=table.concat({"hit",rounded(best.x,2),rounded(best.z,2),rounded(best.aEta,1),rounded(best.bEta,1),tostring(conflict),hold.name,completionPriority.name},"|")
    end
    local changed=self.pairSignature[key]~=sig
    local heartbeat=now-(self.lastPairLog[key] or 0)>=(OuttaMyWay.COURSE_LOOKAHEAD_HEARTBEAT_MS or 15000)
    local shouldLog=changed or heartbeat
    if shouldLog then
        self.pairSignature[key]=sig
        self.lastPairLog[key]=now
    end
    if best==nil then
        if shouldLog then
            print(string.format("Info: [FS25_OuttaMyWay] TRAFFIC FORECAST CLEAR: %s / %s no intersection inside %.0fs horizon finishETA=%.1f/%.1fs completionPriority=%s delta=%.1fs",
                a.name,b.name,OuttaMyWay.COURSE_LOOKAHEAD_HORIZON_SECONDS or 30,completionA,completionB,completionPriority.name,completionDelta))
        end
        return
    end
    if shouldLog then
        print(string.format("Info: [FS25_OuttaMyWay] TRAFFIC FORECAST: %s / %s at=(%.1f,%.1f) distance=%.1f/%.1fm ETA=%.1f/%.1fs gap=%.1fs result=%s",
            a.name,b.name,best.x,best.z,best.aDistance,best.bDistance,best.aEta,best.bEta,best.gap,best.conflict and "CONFLICT" or "TIME_SEPARATED"))
        print(string.format("Info: [FS25_OuttaMyWay] TRAFFIC RECOMMENDATION: hold=%s suggested=%.1fs arrivalFirst=%s completionPriority=%s finishETA=%.1f/%.1fs delta=%.1fs reason=%s",
            best.conflict and best.hold.name or "none",best.conflict and best.clearDelay or 0,
            (best.aEta<best.bEta and a.name or b.name),best.completionPriority.name,completionA,completionB,completionDelta,
            best.conflict and (best.hold==best.completionPriority and "arrival_timing" or "clear_shorter_course_first") or "no_timing_overlap"))
    end
    local maxActiveDistance=math.max(a.polyline.activeDistance or 999,b.polyline.activeDistance or 999)
    local distanceConfidence=math.max(0,math.min(1,1-(maxActiveDistance/40)))
    local timingConfidence=math.max(0,math.min(1,1-(best.gap/(OuttaMyWay.COURSE_LOOKAHEAD_TIME_GAP_SECONDS or 8))))
    local confidenceScore=distanceConfidence*0.60+timingConfidence*0.40
    if a.polyline.activeConfidence~="high" or b.polyline.activeConfidence~="high" then
        confidenceScore=confidenceScore*0.75
    end
    if a.fieldDetectionInProgress==true or b.fieldDetectionInProgress==true then
        confidenceScore=0
    end
    local structurallyValid = best.conflict
        and best.maxEta>=2.0
        and best.maxEta<=(OuttaMyWay.COURSE_HOLD_MAX_ETA_SECONDS or 25.0)
        and best.gap<=(OuttaMyWay.COURSE_HOLD_MAX_GAP_SECONDS or 5.0)
    if structurallyValid then
        local arrivalFirst=best.aEta<best.bEta and a or b
        local other=arrivalFirst==a and b or a
        local duration=math.max(1.5,math.min(OuttaMyWay.COURSE_HOLD_MAX_SECONDS or 10.0,
            math.abs(best.aEta-best.bEta)+(OuttaMyWay.COURSE_INTERSECTION_CLEARANCE_SECONDS or 3.0)))
        local eligible=confidenceScore>=(OuttaMyWay.COURSE_HOLD_ENTER_CONFIDENCE or 0.70)
        local recommendation={
            hold=arrivalFirst, priority=other, duration=duration,
            a=a,b=b,hit=best,updatedAt=now,confidenceScore=confidenceScore,eligible=eligible
        }
        self.recommendations[#self.recommendations+1]=recommendation
        if shouldLog then
            print(string.format("Info: [FS25_OuttaMyWay] TRAFFIC HOLD %s: hold=%s priority=%s duration=%.1fs confidence=%.2f enter=%.2f release=%.2f activeDistance=%.1f/%.1fm",
                eligible and "ELIGIBLE" or "WATCH",arrivalFirst.name,other.name,duration,confidenceScore,
                OuttaMyWay.COURSE_HOLD_ENTER_CONFIDENCE or 0.70,OuttaMyWay.COURSE_HOLD_RELEASE_CONFIDENCE or 0.45,
                a.polyline.activeDistance or -1,b.polyline.activeDistance or -1))
        end
    end
    OuttaMyWay.courseTrafficRecommendation={a=a,b=b,hit=best,updatedAt=now}
end

function CL:update(active)
    self:init()
    self.recommendations={}
    if OuttaMyWay.settings and OuttaMyWay.settings.developerMode==false then return end
    local snapshots={}
    for _,data in ipairs(active or {}) do
        local snapshot=self:readVehicle(data); snapshots[#snapshots+1]=snapshot; self:logVehicle(snapshot,false)
    end
    for i=1,#snapshots-1 do for j=i+1,#snapshots do self:logPair(snapshots[i],snapshots[j]) end end
    OuttaMyWay.courseLookaheadSnapshots=snapshots
    OuttaMyWay.courseTrafficRecommendations=self.recommendations
end
