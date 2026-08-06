OuttaMyWay.FieldWorldSnapshotRegistry = {}
local Registry = OuttaMyWay.FieldWorldSnapshotRegistry
Registry.__index = Registry

local function logInfo(message)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][FIELD-WORLD] %s", message)
    else
        print("[FS25_OuttaMyWay][FIELD-WORLD] " .. message)
    end
end

local function logEquivalence(message)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][FIELD-WORLD-EQUIVALENCE] %s", message)
    else
        print("[FS25_OuttaMyWay][FIELD-WORLD-EQUIVALENCE] " .. message)
    end
end

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function referenceKey(vehicle)
    return "vehicle-root:" .. tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function stateKey(reference, captureToken)
    return tostring(reference) .. "|" .. tostring(captureToken)
end

local function pointXZ(point)
    if type(point) == "table" then
        local x = tonumber(point.x or point.worldX or point.posX or point[1])
        local z = tonumber(point.z or point.worldZ or point.posZ or point[3] or point[2])
        if x ~= nil and z ~= nil then return x, z end
        point = point.node or point.rootNode
    end
    if point ~= nil and point ~= 0 and type(getWorldTranslation) == "function" then
        local ok, x, _, z = pcall(getWorldTranslation, point)
        if ok then return x, z end
    end
    return nil
end

local function copyVertices(points)
    local result = {}
    for _, point in OuttaMyWay.ValueRecord.ipairs(points or {}) do
        local x, z = pointXZ(point)
        if x ~= nil and z ~= nil then result[#result + 1] = {x=x, z=z} end
    end
    return result
end

local function islandBoundary(island)
    if type(island) ~= "table" then return nil end
    if type(island.boundaryLine) == "table" then return island.boundaryLine end
    if type(island.fieldRootBoundary) == "table" and type(island.fieldRootBoundary.boundaryLine) == "table" then
        return island.fieldRootBoundary.boundaryLine
    end
    if type(island.rootBoundary) == "table" and type(island.rootBoundary.boundaryLine) == "table" then
        return island.rootBoundary.boundaryLine
    end
    if type(island.points) == "table" then return island.points end
    return nil
end

local function quantize(value, quantum)
    if value >= 0 then return math.floor(value / quantum + 0.5) end
    return math.ceil(value / quantum - 0.5)
end

local function pointToken(point)
    return tostring(point.x) .. "," .. tostring(point.z)
end

local function samePoint(a, b)
    return a ~= nil and b ~= nil and a.x == b.x and a.z == b.z
end

local function cleanedQuantized(points, quantum)
    local result = {}
    for _, point in OuttaMyWay.ValueRecord.ipairs(copyVertices(points)) do
        local q = {x=quantize(point.x, quantum), z=quantize(point.z, quantum)}
        if #result == 0 or not samePoint(result[#result], q) then result[#result + 1] = q end
    end
    if #result > 1 and samePoint(result[1], result[#result]) then result[#result] = nil end
    return result
end

local function orderedRotation(points, start, reverse)
    local values, ordered, count = {}, {}, #points
    for offset=0,count-1 do
        local index
        if reverse then index = ((start - 1 - offset) % count) + 1
        else index = ((start - 1 + offset) % count) + 1 end
        local point=points[index]
        values[#values + 1] = pointToken(point)
        ordered[#ordered + 1] = {x=point.x,z=point.z}
    end
    return table.concat(values, ";"), ordered
end

local function canonicalRing(points, quantum)
    local cleaned = cleanedQuantized(points, quantum)
    if #cleaned < 3 then return nil, cleaned, nil end
    local best, bestOrdered = nil, nil
    for start=1,#cleaned do
        local forward, forwardOrdered = orderedRotation(cleaned, start, false)
        local reverse, reverseOrdered = orderedRotation(cleaned, start, true)
        if best == nil or forward < best then best, bestOrdered = forward, forwardOrdered end
        if reverse < best then best, bestOrdered = reverse, reverseOrdered end
    end
    return best, cleaned, bestOrdered
end

local function polynomialHash(text, multiplier, modulus, seed)
    local value = seed
    for index=1,#text do value = (value * multiplier + string.byte(text, index)) % modulus end
    return value
end

local function geometryFingerprint(canonicalGeometry)
    local a = polynomialHash(canonicalGeometry, 131, 2147483647, 216613626)
    local b = polynomialHash(canonicalGeometry, 137, 2147483629, 16777619)
    return string.format("%010d-%010d", a, b)
end

local function rawRing(points)
    local result={}
    for _,point in OuttaMyWay.ValueRecord.ipairs(copyVertices(points)) do
        local previous=result[#result]
        if previous==nil or previous.x~=point.x or previous.z~=point.z then result[#result+1]={x=point.x,z=point.z} end
    end
    if #result>1 and result[1].x==result[#result].x and result[1].z==result[#result].z then result[#result]=nil end
    return result
end

local function ringSignedDoubleArea(points)
    local ring=rawRing(points)
    if #ring<3 then return 0,ring end
    local sum=0
    for index=1,#ring do
        local nextIndex=(index % #ring)+1
        sum=sum+ring[index].x*ring[nextIndex].z-ring[nextIndex].x*ring[index].z
    end
    return sum,ring
end

local function ringMetrics(points)
    local signedDouble,ring=ringSignedDoubleArea(points)
    if #ring<3 then return {area=0,perimeter=0,centroidX=0,centroidZ=0,pointCount=#ring},ring end
    local perimeter=0
    for index=1,#ring do
        local nextIndex=(index % #ring)+1
        local dx=ring[nextIndex].x-ring[index].x
        local dz=ring[nextIndex].z-ring[index].z
        perimeter=perimeter+math.sqrt(dx*dx+dz*dz)
    end
    local centroidX,centroidZ=0,0
    if math.abs(signedDouble)>0.0000001 then
        for index=1,#ring do
            local nextIndex=(index % #ring)+1
            local cross=ring[index].x*ring[nextIndex].z-ring[nextIndex].x*ring[index].z
            centroidX=centroidX+(ring[index].x+ring[nextIndex].x)*cross
            centroidZ=centroidZ+(ring[index].z+ring[nextIndex].z)*cross
        end
        centroidX=centroidX/(3*signedDouble)
        centroidZ=centroidZ/(3*signedDouble)
    else
        for _,point in OuttaMyWay.ValueRecord.ipairs(ring) do centroidX=centroidX+point.x; centroidZ=centroidZ+point.z end
        centroidX=centroidX/#ring; centroidZ=centroidZ/#ring
    end
    return {area=math.abs(signedDouble)/2,perimeter=perimeter,centroidX=centroidX,centroidZ=centroidZ,pointCount=#ring},ring
end

local function boundsFor(points)
    local ring=rawRing(points)
    if #ring==0 then return {minX=0,maxX=0,minZ=0,maxZ=0} end
    local minX,maxX,minZ,maxZ=ring[1].x,ring[1].x,ring[1].z,ring[1].z
    for _,point in OuttaMyWay.ValueRecord.ipairs(ring) do
        minX=math.min(minX,point.x); maxX=math.max(maxX,point.x)
        minZ=math.min(minZ,point.z); maxZ=math.max(maxZ,point.z)
    end
    return {minX=minX,maxX=maxX,minZ=minZ,maxZ=maxZ}
end

local function pointSegmentDistance(point,a,b)
    local dx,dz=b.x-a.x,b.z-a.z
    local lengthSquared=dx*dx+dz*dz
    if lengthSquared<=0.0000000001 then
        local px,pz=point.x-a.x,point.z-a.z
        return math.sqrt(px*px+pz*pz)
    end
    local t=((point.x-a.x)*dx+(point.z-a.z)*dz)/lengthSquared
    if t<0 then t=0 elseif t>1 then t=1 end
    local qx,qz=a.x+t*dx,a.z+t*dz
    local px,pz=point.x-qx,point.z-qz
    return math.sqrt(px*px+pz*pz)
end

local function pointInRing(point,points)
    local ring=rawRing(points)
    if #ring<3 then return false end
    local inside=false
    local previous=#ring
    for index=1,#ring do
        local a,b=ring[previous],ring[index]
        if pointSegmentDistance(point,a,b)<=0.000001 then return true end
        local crosses=((a.z>point.z)~=(b.z>point.z))
        if crosses then
            local x=a.x+(point.z-a.z)*(b.x-a.x)/(b.z-a.z)
            if x>point.x then inside=not inside end
        end
        previous=index
    end
    return inside
end

local function pointInGeometry(point,geometry)
    if not pointInRing(point,geometry.boundary or {}) then return false end
    for _,island in OuttaMyWay.ValueRecord.ipairs(geometry.islands or {}) do
        if pointInRing(point,island) then return false end
    end
    return true
end

local function allGeometryVertices(geometry)
    local result=rawRing(geometry.boundary or {})
    for _,island in OuttaMyWay.ValueRecord.ipairs(geometry.islands or {}) do
        for _,point in OuttaMyWay.ValueRecord.ipairs(rawRing(island)) do result[#result+1]=point end
    end
    return result
end

local function nearestBoundaryDistance(point,geometry)
    local best=math.huge
    local function inspect(ringSource)
        local ring=rawRing(ringSource)
        for index=1,#ring do
            local nextIndex=(index % #ring)+1
            best=math.min(best,pointSegmentDistance(point,ring[index],ring[nextIndex]))
        end
    end
    inspect(geometry.boundary or {})
    for _,island in OuttaMyWay.ValueRecord.ipairs(geometry.islands or {}) do inspect(island) end
    return best==math.huge and 0 or best
end

local function relativeDelta(a,b)
    local divisor=math.max(math.abs(a or 0),math.abs(b or 0),0.000001)
    return math.abs((a or 0)-(b or 0))/divisor
end

function Registry.measureGeometry(boundary,islands)
    local outer,outerRing=ringMetrics(boundary)
    local area=outer.area
    local perimeter=outer.perimeter
    local weightedX,weightedZ=outer.centroidX*outer.area,outer.centroidZ*outer.area
    local islandCount=0
    local copiedIslands={}
    for _,island in OuttaMyWay.ValueRecord.ipairs(islands or {}) do
        local boundaryLine=islandBoundary(island) or island
        local metrics=ringMetrics(boundaryLine)
        area=area-metrics.area
        perimeter=perimeter+metrics.perimeter
        weightedX=weightedX-metrics.centroidX*metrics.area
        weightedZ=weightedZ-metrics.centroidZ*metrics.area
        islandCount=islandCount+1
        copiedIslands[#copiedIslands+1]=copyVertices(boundaryLine)
    end
    local centroidX,centroidZ=outer.centroidX,outer.centroidZ
    if math.abs(area)>0.000001 then centroidX=weightedX/area; centroidZ=weightedZ/area end
    local bounds=boundsFor(outerRing)
    return {
        areaSquareMetres=area,
        perimeterMetres=perimeter,
        centroidX=centroidX,
        centroidZ=centroidZ,
        minX=bounds.minX,maxX=bounds.maxX,minZ=bounds.minZ,maxZ=bounds.maxZ,
        boundaryPointCount=outer.pointCount,
        islandCount=islandCount,
        boundary=copyVertices(boundary),
        islands=copiedIslands
    }
end

local function sampledOverlap(a,b,sampleSide)
    sampleSide=math.max(5,math.floor(tonumber(sampleSide) or 31))
    local minX=math.min(a.minX,b.minX); local maxX=math.max(a.maxX,b.maxX)
    local minZ=math.min(a.minZ,b.minZ); local maxZ=math.max(a.maxZ,b.maxZ)
    local width,height=maxX-minX,maxZ-minZ
    if width<=0 or height<=0 then return 0,0,0,0,0 end
    local inA,inB,intersection,union=0,0,0,0
    local geometryA={boundary=a.boundary,islands=a.islands}
    local geometryB={boundary=b.boundary,islands=b.islands}
    for ix=1,sampleSide do
        local x=minX+(ix-0.5)*width/sampleSide
        for iz=1,sampleSide do
            local z=minZ+(iz-0.5)*height/sampleSide
            local point={x=x,z=z}
            local insideA=pointInGeometry(point,geometryA)
            local insideB=pointInGeometry(point,geometryB)
            if insideA then inA=inA+1 end
            if insideB then inB=inB+1 end
            if insideA and insideB then intersection=intersection+1 end
            if insideA or insideB then union=union+1 end
        end
    end
    local jaccard=union>0 and intersection/union or 0
    return jaccard,inA,inB,intersection,union
end

function Registry.compareGeometry(a,b,sampleSide)
    local metricsA=a.areaSquareMetres and a or Registry.measureGeometry(a.boundary,a.islands)
    local metricsB=b.areaSquareMetres and b or Registry.measureGeometry(b.boundary,b.islands)
    local verticesA=allGeometryVertices(metricsA)
    local verticesB=allGeometryVertices(metricsB)
    local geometryA={boundary=metricsA.boundary,islands=metricsA.islands}
    local geometryB={boundary=metricsB.boundary,islands=metricsB.islands}
    local sumDistance,maxDistance,count=0,0,0
    local insideAInB,insideBInA=0,0
    for _,point in OuttaMyWay.ValueRecord.ipairs(verticesA) do
        local distance=nearestBoundaryDistance(point,geometryB)
        sumDistance=sumDistance+distance; maxDistance=math.max(maxDistance,distance); count=count+1
        if pointInGeometry(point,geometryB) then insideAInB=insideAInB+1 end
    end
    for _,point in OuttaMyWay.ValueRecord.ipairs(verticesB) do
        local distance=nearestBoundaryDistance(point,geometryA)
        sumDistance=sumDistance+distance; maxDistance=math.max(maxDistance,distance); count=count+1
        if pointInGeometry(point,geometryA) then insideBInA=insideBInA+1 end
    end
    local dx=metricsA.centroidX-metricsB.centroidX
    local dz=metricsA.centroidZ-metricsB.centroidZ
    local boundsMax=math.max(
        math.abs(metricsA.minX-metricsB.minX),math.abs(metricsA.maxX-metricsB.maxX),
        math.abs(metricsA.minZ-metricsB.minZ),math.abs(metricsA.maxZ-metricsB.maxZ)
    )
    local jaccard,inA,inB,intersection,union=sampledOverlap(metricsA,metricsB,sampleSide)
    return {
        sameIslandTopology=metricsA.islandCount==metricsB.islandCount,
        sameBoundaryPointCount=metricsA.boundaryPointCount==metricsB.boundaryPointCount,
        areaRelativeDelta=relativeDelta(metricsA.areaSquareMetres,metricsB.areaSquareMetres),
        perimeterRelativeDelta=relativeDelta(metricsA.perimeterMetres,metricsB.perimeterMetres),
        centroidDistanceMetres=math.sqrt(dx*dx+dz*dz),
        boundsMaxDeltaMetres=boundsMax,
        symmetricBoundaryMeanDistanceMetres=count>0 and sumDistance/count or 0,
        symmetricBoundaryMaxDistanceMetres=maxDistance,
        verticesAInsideBFraction=#verticesA>0 and insideAInB/#verticesA or 0,
        verticesBInsideAFraction=#verticesB>0 and insideBInA/#verticesB or 0,
        sampledJaccard=jaccard,
        sampledInsideA=inA,sampledInsideB=inB,sampledIntersection=intersection,sampledUnion=union,
        sampleSide=math.max(5,math.floor(tonumber(sampleSide) or 31)),
        diagnosticOnly=true,
        identityAuthorityChanged=false
    }
end

function Registry.canonicalizeBoundary(boundary, islands, quantum)
    quantum = tonumber(quantum) or 0.1
    local rootRing, rootPoints, rootOrdered = canonicalRing(boundary, quantum)
    if rootRing == nil then return nil, "FIELD_WORLD_ROOT_BOUNDARY_INVALID" end
    local islandRings, copiedIslands, canonicalIslands = {}, {}, {}
    for _, island in OuttaMyWay.ValueRecord.ipairs(islands or {}) do
        local boundaryLine = islandBoundary(island)
        if boundaryLine == nil then return nil, "FIELD_WORLD_ISLAND_BOUNDARY_UNAVAILABLE" end
        local ring, copied, ordered = canonicalRing(boundaryLine, quantum)
        if ring == nil then return nil, "FIELD_WORLD_ISLAND_BOUNDARY_INVALID" end
        islandRings[#islandRings + 1] = ring
        copiedIslands[#copiedIslands + 1] = copyVertices(boundaryLine)
        canonicalIslands[#canonicalIslands + 1] = {ring=ring,vertices=ordered}
    end
    table.sort(islandRings)
    table.sort(canonicalIslands,function(a,b) return a.ring<b.ring end)
    local canonical = "R:" .. rootRing .. "|I:" .. table.concat(islandRings, "|")
    return {
        canonicalGeometry=canonical,
        canonicalRootRing=rootRing,
        canonicalRootVertices=rootOrdered,
        canonicalIslandRings=islandRings,
        canonicalIslandVertices=canonicalIslands,
        fingerprint=geometryFingerprint(canonical),
        boundary=copyVertices(boundary),
        islands=copiedIslands,
        boundaryPointCount=#rootPoints,
        islandCount=#islandRings,
        quantizationMetres=quantum,
        canonicalizationVersion=OuttaMyWay.FIELD_WORLD_FINGERPRINT_VERSION or "FWG1"
    }, nil
end

function Registry.fingerprintGeometry(boundary, islands, quantum)
    local result, reason = Registry.canonicalizeBoundary(boundary, islands, quantum)
    return result and result.fingerprint or nil, reason
end

local function boundarySummary(boundary)
    local metrics=Registry.measureGeometry(boundary,{})
    return string.format("points=%d bounds=(%.1f,%.1f)-(%.1f,%.1f)",metrics.boundaryPointCount,metrics.minX,metrics.minZ,metrics.maxX,metrics.maxZ)
end

local function evidenceSummary(metrics)
    return string.format("area=%.1f perimeter=%.1f centroid=(%.1f,%.1f) bounds=(%.1f,%.1f)-(%.1f,%.1f)",
        metrics.areaSquareMetres,metrics.perimeterMetres,metrics.centroidX,metrics.centroidZ,
        metrics.minX,metrics.minZ,metrics.maxX,metrics.maxZ)
end

function Registry.new()
    return setmetatable({states={},records={},canonicalByWorldKey={},resolvedSnapshots={},comparisonRecords={},apiUnavailableLogged=false},Registry)
end

function Registry:reset()
    self.states={}; self.records={}; self.canonicalByWorldKey={}; self.resolvedSnapshots={}; self.comparisonRecords={}; self.apiUnavailableLogged=false
end

function Registry:_appendComparison(record)
    self.comparisonRecords[#self.comparisonRecords+1]=record
    local maximum=OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_COMPARISONS or 128
    while #self.comparisonRecords>maximum do table.remove(self.comparisonRecords,1) end
end

function Registry:_compareWithRecent(state,snapshot)
    local maximumReferences=OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_REFERENCE_SNAPSHOTS or 16
    local first=math.max(1,#self.resolvedSnapshots-maximumReferences+1)
    for index=first,#self.resolvedSnapshots do
        local previous=self.resolvedSnapshots[index]
        local comparison=Registry.compareGeometry(snapshot.geometryMetrics,previous.geometryMetrics,OuttaMyWay.FIELD_WORLD_EQUIVALENCE_SAMPLE_SIDE or 31)
        comparison.currentVehicleReferenceKey=state.vehicleReferenceKey
        comparison.currentJobToken=state.jobToken
        comparison.currentFingerprint=snapshot.geometryFingerprint
        comparison.referenceVehicleReferenceKey=previous.vehicleReferenceKey
        comparison.referenceJobToken=previous.sourceJobToken
        comparison.referenceFingerprint=previous.geometryFingerprint
        comparison.exactFingerprint=snapshot.geometryFingerprint==previous.geometryFingerprint
        comparison.relation=comparison.exactFingerprint and "EXACT_FINGERPRINT" or "MEASURED_NON_EXACT"
        comparison.controlAuthorityEnabled=false
        self:_appendComparison(comparison)
        logEquivalence(string.format("COMPARE current=%s/%s/%s reference=%s/%s/%s relation=%s sameIslands=%s samePoints=%s areaRelDelta=%.6f perimeterRelDelta=%.6f centroidDistance=%.3f boundsMaxDelta=%.3f boundaryMean=%.3f boundaryMax=%.3f verticesAInB=%.4f verticesBInA=%.4f sampledJaccard=%.6f samples=%d diagnosticOnly=true identityAuthorityChanged=false control=false",
            tostring(state.vehicleReferenceKey),tostring(state.jobToken),tostring(snapshot.geometryFingerprint),
            tostring(previous.vehicleReferenceKey),tostring(previous.sourceJobToken),tostring(previous.geometryFingerprint),comparison.relation,
            tostring(comparison.sameIslandTopology),tostring(comparison.sameBoundaryPointCount),comparison.areaRelativeDelta,comparison.perimeterRelativeDelta,
            comparison.centroidDistanceMetres,comparison.boundsMaxDeltaMetres,comparison.symmetricBoundaryMeanDistanceMetres,
            comparison.symmetricBoundaryMaxDistanceMetres,comparison.verticesAInsideBFraction,comparison.verticesBInsideAFraction,
            comparison.sampledJaccard,comparison.sampleSide*comparison.sampleSide))
    end
    self.resolvedSnapshots[#self.resolvedSnapshots+1]=snapshot
    local maximumStored=OuttaMyWay.FIELD_WORLD_EQUIVALENCE_MAX_STORED_SNAPSHOTS or 32
    while #self.resolvedSnapshots>maximumStored do table.remove(self.resolvedSnapshots,1) end
end

function Registry:_complete(state, result, success)
    state.pending=false; state.completed=true; state.finishedAt=tonumber(g_time) or 0
    if not success or result==nil or type(result.fieldRootBoundary)~="table" or type(result.fieldRootBoundary.boundaryLine)~="table" then
        state.error="FIELD_WORLD_GENERATION_CALLBACK_FAILED"
        logInfo(string.format("FAILED ref=%s jobToken=%s reason=%s control=false",state.vehicleReferenceKey,tostring(state.jobToken),state.error))
        return
    end
    local canonical, reason = Registry.canonicalizeBoundary(
        result.fieldRootBoundary.boundaryLine,
        result.islands or {},
        OuttaMyWay.FIELD_WORLD_FINGERPRINT_QUANTIZATION_METRES or 0.1
    )
    if canonical==nil then
        state.error=reason
        logInfo(string.format("FAILED ref=%s jobToken=%s reason=%s control=false",state.vehicleReferenceKey,tostring(state.jobToken),state.error))
        return
    end
    local version=canonical.canonicalizationVersion
    local worldKey=string.format("field-world:geometry:%s:%d:%d:%s",version,canonical.boundaryPointCount,canonical.islandCount,canonical.fingerprint)
    local existing=self.canonicalByWorldKey[worldKey]
    if existing~=nil and existing~=canonical.canonicalGeometry then
        state.error="FIELD_WORLD_FINGERPRINT_COLLISION"
        logInfo(string.format("FAILED ref=%s jobToken=%s reason=%s control=false",state.vehicleReferenceKey,tostring(state.jobToken),state.error))
        return
    end
    self.canonicalByWorldKey[worldKey]=canonical.canonicalGeometry
    local metrics=Registry.measureGeometry(canonical.boundary,canonical.islands)
    state.snapshot={
        referenceKey=worldKey,
        fieldPolygonReferenceKey="field-world-polygon:"..version..":"..canonical.fingerprint,
        geometryFingerprint=canonical.fingerprint,
        canonicalizationVersion=version,
        quantizationMetres=canonical.quantizationMetres,
        canonicalRootRing=canonical.canonicalRootRing,
        canonicalRootVertices=canonical.canonicalRootVertices,
        canonicalIslandRings=canonical.canonicalIslandRings,
        boundary=canonical.boundary,
        islands=canonical.islands,
        geometryMetrics=metrics,
        boundaryPointCount=canonical.boundaryPointCount,
        islandCount=canonical.islandCount,
        seedPosition={x=state.seedPosition.x,z=state.seedPosition.z},
        sourceJobToken=state.jobToken,
        vehicleReferenceKey=state.vehicleReferenceKey,
        capturedAt=state.startedAt,
        immutableForJobEpisode=true,
        equivalenceEvidenceDiagnosticOnly=true,
        exactFingerprintOperationAuthorityRetained=true
    }
    local record={
        vehicleReferenceKey=state.vehicleReferenceKey,jobToken=state.jobToken,captureToken=state.captureToken,
        worldKey=worldKey,fieldPolygonReferenceKey=state.snapshot.fieldPolygonReferenceKey,
        geometryFingerprint=canonical.fingerprint,boundaryPointCount=canonical.boundaryPointCount,
        islandCount=canonical.islandCount,seedPosition=state.snapshot.seedPosition,
        canonicalizationVersion=version,geometryMetrics=metrics,canonicalRootRing=canonical.canonicalRootRing,
        equivalenceEvidenceDiagnosticOnly=true,controlAuthorityEnabled=false
    }
    self.records[#self.records+1]=record
    logInfo(string.format("CAPTURED ref=%s jobToken=%s world=%s fingerprint=%s seed=(%.1f,%.1f) %s islands=%d immutable=true control=false",
        state.vehicleReferenceKey,tostring(state.jobToken),worldKey,canonical.fingerprint,
        state.seedPosition.x,state.seedPosition.z,boundarySummary(canonical.boundary),canonical.islandCount))
    local canonicalIslands=#canonical.canonicalIslandRings>0 and table.concat(canonical.canonicalIslandRings,"|") or "none"
    logEquivalence(string.format("GEOMETRY ref=%s jobToken=%s fingerprint=%s quantum=%.3f %s islands=%d canonicalRoot=%s canonicalIslands=%s diagnosticOnly=true identityAuthorityChanged=false control=false",
        state.vehicleReferenceKey,tostring(state.jobToken),canonical.fingerprint,canonical.quantizationMetres,evidenceSummary(metrics),canonical.islandCount,canonical.canonicalRootRing,canonicalIslands))
    self:_compareWithRecent(state,state.snapshot)
end

function Registry:_start(vehicle, pose, jobToken, captureToken)
    local ref=referenceKey(vehicle)
    captureToken=captureToken or jobToken
    local key=stateKey(ref,captureToken)
    if self.states[key]~=nil then return end
    local state={key=key,vehicle=vehicle,vehicleReferenceKey=ref,jobToken=jobToken,captureToken=captureToken,seedPosition={x=pose.x,z=pose.z},pending=false,completed=false,startedAt=tonumber(g_time) or 0,updates=0}
    self.states[key]=state
    if FieldCourseSettings==nil or type(FieldCourseSettings.generate)~="function" or FieldCourseField==nil or type(FieldCourseField.generateAtPosition)~="function" then
        state.error="GIANTS_FIELD_COURSE_API_UNAVAILABLE"
        if not self.apiUnavailableLogged then
            self.apiUnavailableLogged=true
            logInfo("GIANTS FieldCourse boundary API unavailable; Job Episodes remain active while Field World identity waits for evidence; control=false")
        end
        return
    end
    local okSettings,settings=pcall(FieldCourseSettings.generate,vehicle)
    if not okSettings or settings==nil then state.error="FIELD_COURSE_SETTINGS_FAILED"; return end
    local okCreate,courseField=pcall(function()
        return FieldCourseField.generateAtPosition(pose.x,pose.z,settings,function(result,success)
            self:_complete(state,result,success)
        end)
    end)
    if not okCreate or courseField==nil then state.error="FIELD_COURSE_CREATE_FAILED"; return end
    state.courseField=courseField; state.pending=true
    logInfo(string.format("STARTED ref=%s jobToken=%s seed=(%.1f,%.1f) immutable-capture=true control=false",ref,tostring(jobToken),pose.x,pose.z))
end

function Registry:ensure(vehicle,pose,jobToken,captureToken)
    if vehicle~=nil and pose~=nil and jobToken~=nil then self:_start(vehicle,pose,jobToken,captureToken) end
end

function Registry:observe(mission,activeVehicles)
    for _,vehicle in OuttaMyWay.ValueRecord.ipairs(activeVehicles or {}) do
        local job=OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
        local token=OuttaMyWay.LiveAIJobEvidence.jobToken(job)
        local ok,node=safeCall(vehicle,"getAISteeringNode"); node=ok and node or vehicle.rootNode
        local pose=nil
        if node~=nil and node~=0 and type(getWorldTranslation)=="function" then
            local pOk,x,_,z=pcall(getWorldTranslation,node)
            if pOk then pose={x=x,z=z} end
        end
        if token~=nil and pose~=nil then self:_start(vehicle,pose,token,token) end
    end
end

function Registry:update(dt,mission)
    for _,state in OuttaMyWay.ValueRecord.pairs(self.states) do
        if state.pending and state.courseField~=nil and type(state.courseField.update)=="function" then
            local ok,stillRunning=pcall(state.courseField.update,state.courseField,dt or 0,OuttaMyWay.FIELD_WORLD_SNAPSHOT_GENERATION_BUDGET or 0.00025)
            state.updates=(state.updates or 0)+1
            if not ok then state.pending=false; state.error="FIELD_COURSE_UPDATE_FAILED" end
            if stillRunning==false and state.pending and (tonumber(g_time) or 0)-(state.startedAt or 0)>5000 then
                state.pending=false; state.error="FIELD_COURSE_FINISHED_WITHOUT_CALLBACK"
            end
        end
    end
end

function Registry:get(vehicleReferenceKey,captureToken)
    local state=self.states[stateKey(vehicleReferenceKey,captureToken)]
    return state and state.snapshot or nil,state and state.error or nil
end

function Registry:getForVehicle(vehicle,captureToken)
    return self:get(referenceKey(vehicle),captureToken)
end

function Registry:getRecords()
    local result={}; for index,value in OuttaMyWay.ValueRecord.ipairs(self.records) do result[index]=value end; return result
end
function Registry:getComparisonRecords()
    local result={}; for index,value in OuttaMyWay.ValueRecord.ipairs(self.comparisonRecords) do result[index]=value end; return result
end
function Registry:getRecordCount() return #self.records end
function Registry:getComparisonRecordCount() return #self.comparisonRecords end
function Registry:getResolvedCount()
    local count=0; for _,state in OuttaMyWay.ValueRecord.pairs(self.states) do if state.snapshot~=nil then count=count+1 end end; return count
end
