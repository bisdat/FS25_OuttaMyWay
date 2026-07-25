-- FS25_OuttaMyWay v4.6.8
-- Prototype 07 geometry evidence adapter.
-- Discovers capability-gated GIANTS physics/bound evidence and derives a
-- conservative complete-Entity ground-plane envelope. No control or containment.

OuttaMyWay.PhysicalEnvelopeEvidence = OuttaMyWay.PhysicalEnvelopeEvidence or {}
local Evidence = OuttaMyWay.PhysicalEnvelopeEvidence

local function safeNumber(value, fallback)
    value = tonumber(value)
    if value == nil or value ~= value or value == math.huge or value == -math.huge then return fallback end
    return value
end

local function round(value, step)
    step = step or 0.05
    if value == nil then return nil end
    return math.floor((value / step) + 0.5) * step
end

local function objectName(object)
    if object ~= nil and type(object.getName) == "function" then
        local ok, name = pcall(object.getName, object)
        if ok and name ~= nil and name ~= "" then return tostring(name) end
    end
    return "vehicle"
end

local function objectNode(object)
    if object == nil or object.isDeleted == true then return nil end
    local node = object.rootNode
    if node == nil or node == 0 then return nil end
    return node
end

local function rootVehicle(object)
    if object ~= nil and type(object.getRootVehicle) == "function" then
        local ok, root = pcall(object.getRootVehicle, object)
        if ok and root ~= nil and root.isDeleted ~= true then return root end
    end
    return object
end

local function vehicleKey(vehicle)
    return tostring(rootVehicle(vehicle))
end

local function globalFunction(name)
    local value = _G ~= nil and _G[name] or nil
    if type(value) == "function" then return value end
    return nil
end

local function callOne(name, node)
    local fn = globalFunction(name)
    if fn == nil then return nil, false end
    local ok, value = pcall(fn, node)
    if not ok then return nil, true end
    return value, true
end

local function validBounds(minX, maxX, minY, maxY, minZ, maxZ)
    local values = {minX, maxX, minY, maxY, minZ, maxZ}
    for _, value in ipairs(values) do
        if safeNumber(value, nil) == nil then return nil end
    end
    if minX > maxX or minY > maxY or minZ > maxZ then return nil end
    local width, height, length = maxX-minX, maxY-minY, maxZ-minZ
    if width < 0 or height < 0 or length < 0 then return nil end
    if width > 500 or height > 200 or length > 500 then return nil end
    if width < 0.001 and height < 0.001 and length < 0.001 then return nil end
    return {minX=minX,maxX=maxX,minY=minY,maxY=maxY,minZ=minZ,maxZ=maxZ}
end

local function callBounds(name, node, preferredOrder)
    local fn = globalFunction(name)
    if fn == nil then return nil, false end
    local ok, a, b, c, d, e, f = pcall(fn, node)
    if not ok then return nil, true end

    local alternate
    local preferred
    if preferredOrder == "XYZXYZ" then
        preferred = validBounds(a, d, b, e, c, f)
        alternate = validBounds(a, b, c, d, e, f)
    else
        preferred = validBounds(a, b, c, d, e, f)
        alternate = validBounds(a, d, b, e, c, f)
    end
    return preferred or alternate, true
end

local function transformLocalBoundsToEntity(bounds, node, entityNode)
    if bounds == nil or node == nil or entityNode == nil then return nil end
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    for _, x in ipairs({bounds.minX, bounds.maxX}) do
        for _, y in ipairs({bounds.minY, bounds.maxY}) do
            for _, z in ipairs({bounds.minZ, bounds.maxZ}) do
                local okWorld, wx, wy, wz = pcall(localToWorld, node, x, y, z)
                if okWorld then
                    local okLocal, lx, _, lz = pcall(worldToLocal, entityNode, wx, wy, wz)
                    if okLocal then
                        minX, maxX = math.min(minX, lx), math.max(maxX, lx)
                        minZ, maxZ = math.min(minZ, lz), math.max(maxZ, lz)
                    end
                end
            end
        end
    end
    if minX == math.huge then return nil end
    return {minX=minX,maxX=maxX,minZ=minZ,maxZ=maxZ,frame="ENTITY_LOCAL"}
end

local function transformWorldBoundsToEntity(bounds, entityNode)
    if bounds == nil or entityNode == nil then return nil end
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    for _, x in ipairs({bounds.minX, bounds.maxX}) do
        for _, y in ipairs({bounds.minY, bounds.maxY}) do
            for _, z in ipairs({bounds.minZ, bounds.maxZ}) do
                local okLocal, lx, _, lz = pcall(worldToLocal, entityNode, x, y, z)
                if okLocal then
                    minX, maxX = math.min(minX, lx), math.max(maxX, lx)
                    minZ, maxZ = math.min(minZ, lz), math.max(maxZ, lz)
                end
            end
        end
    end
    if minX == math.huge then return nil end
    return {minX=minX,maxX=maxX,minZ=minZ,maxZ=maxZ,frame="WORLD_AABB_DERIVED"}
end

local function nodePhysicsEvidence(node)
    local rigidBodyType, rigidApi = callOne("getRigidBodyType", node)
    local collisionMask, maskApi = callOne("getCollisionMask", node)
    local rigid = rigidBodyType ~= nil and tostring(rigidBodyType) ~= "0"
    local maskNumber = tonumber(collisionMask)
    local masked = collisionMask ~= nil and ((maskNumber ~= nil and maskNumber ~= 0) or (maskNumber == nil and tostring(collisionMask) ~= "0"))
    return {
        rigidBodyType=rigidBodyType,
        collisionMask=collisionMask,
        rigid=rigid,
        masked=masked,
        physicsConfirmed=rigid or masked,
        rigidApi=rigidApi,
        maskApi=maskApi
    }
end

local function nodeName(node)
    local fn = globalFunction("getName")
    if fn == nil then return tostring(node) end
    local ok, value = pcall(fn, node)
    if ok and value ~= nil and value ~= "" then return tostring(value) end
    return tostring(node)
end

local function discoverNodeBound(node, entityNode, role)
    local physics = nodePhysicsEvidence(node)

    local localBounds, shapeApi = callBounds("getShapeBoundingBox", node, "XYZXYZ")
    if localBounds ~= nil then
        local transformed = transformLocalBoundsToEntity(localBounds, node, entityNode)
        if transformed ~= nil then
            return transformed, "GIANTS_SHAPE_BOUND", physics, shapeApi
        end
    end

    localBounds = select(1, callBounds("getBoundingBox", node, "MINMAX"))
    if localBounds ~= nil then
        local transformed = transformLocalBoundsToEntity(localBounds, node, entityNode)
        if transformed ~= nil then
            local source = physics.physicsConfirmed and "GIANTS_PHYSICS_NODE_LOCAL_BOUND" or (role .. "_LOCAL_BOUND")
            return transformed, source, physics, true
        end
    end

    local worldBounds, worldApi = callBounds("getWorldBoundingBox", node, "MINMAX")
    if worldBounds ~= nil then
        local transformed = transformWorldBoundsToEntity(worldBounds, entityNode)
        if transformed ~= nil then
            local source = physics.physicsConfirmed and "GIANTS_PHYSICS_NODE_WORLD_BOUND" or (role .. "_WORLD_BOUND")
            return transformed, source, physics, worldApi
        end
    end

    return nil, "NO_BOUND", physics, shapeApi or worldApi
end

local function addObjectTree(root, output, visited)
    if root == nil or root.isDeleted == true or visited[root] then return end
    visited[root] = true
    output[#output+1] = root
    if type(root.getAttachedImplements) == "function" then
        local ok, attached = pcall(root.getAttachedImplements, root)
        if ok and type(attached) == "table" then
            for _, entry in pairs(attached) do
                addObjectTree(entry.object or entry, output, visited)
            end
        end
    end
end

local function collectEntityObjects(vehicle)
    local output, visited = {}, {}
    addObjectTree(rootVehicle(vehicle), output, visited)
    return output
end

local function addNode(candidate, output, seen, role, object)
    local node = candidate
    if type(candidate) == "table" then node = candidate.node or candidate.rootNode end
    if node == nil or node == 0 or seen[node] then return end
    seen[node] = true
    output[#output+1] = {node=node,role=role,object=object}
end

local function collectCandidateNodes(objects, budget)
    local output, seen = {}, {}
    local roots = {}
    for _, object in ipairs(objects) do
        local root = objectNode(object)
        if root ~= nil then
            roots[#roots+1] = {node=root,object=object}
            addNode(root, output, seen, "OBJECT_ROOT", object)
        end
        if type(object.components) == "table" then
            for _, component in pairs(object.components) do
                addNode(component, output, seen, "COMPONENT", object)
            end
        end
    end

    local childCountFn = globalFunction("getNumOfChildren")
    local childAtFn = globalFunction("getChildAt")
    local scanned, truncated = 0, false
    if childCountFn ~= nil and childAtFn ~= nil then
        local queue, index = {}, 1
        for _, entry in ipairs(roots) do queue[#queue+1] = entry end
        while index <= #queue do
            if scanned >= budget then truncated = true break end
            local entry = queue[index]
            index = index + 1
            scanned = scanned + 1
            local okCount, count = pcall(childCountFn, entry.node)
            if okCount and tonumber(count) ~= nil then
                for childIndex=0,tonumber(count)-1 do
                    if scanned >= budget then truncated = true break end
                    local okChild, child = pcall(childAtFn, entry.node, childIndex)
                    if okChild and child ~= nil and child ~= 0 then
                        local physics = nodePhysicsEvidence(child)
                        if physics.physicsConfirmed then
                            addNode(child, output, seen, "PHYSICS_DESCENDANT", entry.object)
                        end
                        queue[#queue+1] = {node=child,object=entry.object}
                    end
                end
            end
        end
    end
    return output, scanned, truncated
end

local function markerWidth(object)
    if object == nil or type(object.getAIMarkers) ~= "function" then return nil end
    local ok, left, right = pcall(object.getAIMarkers, object)
    if not ok or left == nil or right == nil or left == 0 or right == 0 then return nil end
    local okLeft, lx, _, lz = pcall(getWorldTranslation, left)
    local okRight, rx, _, rz = pcall(getWorldTranslation, right)
    if not okLeft or not okRight then return nil end
    local width = math.sqrt((rx-lx)^2 + (rz-lz)^2)
    if width < 0.25 or width > 150 then return nil end
    return width
end

local function workingEvidence(objects)
    local marker, sizeWidth, sizeLength = nil, nil, nil
    for _, object in ipairs(objects) do
        local value = markerWidth(object)
        if value ~= nil then marker = math.max(marker or 0, value) end
        local width = safeNumber(object.sizeWidth, nil)
        local length = safeNumber(object.sizeLength, nil)
        if width ~= nil and width > 0 and width < 150 then sizeWidth = math.max(sizeWidth or 0, width) end
        if length ~= nil and length > 0 and length < 150 then sizeLength = math.max(sizeLength or 0, length) end
    end
    return marker, sizeWidth, sizeLength
end

local function sourceSummary(counts)
    local keys = {}
    for key in pairs(counts or {}) do keys[#keys+1] = key end
    table.sort(keys)
    local parts = {}
    for _, key in ipairs(keys) do parts[#parts+1] = key .. ":" .. tostring(counts[key]) end
    if #parts == 0 then return "none" end
    return table.concat(parts, ",")
end

local function geometrySignature(geometry)
    if geometry == nil or geometry.envelope == nil then
        return table.concat({"UNKNOWN",tostring(geometry and geometry.objectCount or 0),tostring(geometry and geometry.nodeCount or 0)}, "|")
    end
    local e = geometry.envelope
    return table.concat({
        string.format("%.2f", round(e.minX, 0.05)),
        string.format("%.2f", round(e.maxX, 0.05)),
        string.format("%.2f", round(e.minZ, 0.05)),
        string.format("%.2f", round(e.maxZ, 0.05)),
        tostring(geometry.physicsBoundCount or 0),
        tostring(geometry.boundedObjectCount or 0),
        tostring(geometry.frameStability or "UNKNOWN"),
        tostring(geometry.truncated == true)
    }, "|")
end

local function objectSetSignature(objects)
    local keys = {}
    for _, object in ipairs(objects or {}) do keys[#keys+1] = tostring(object) end
    table.sort(keys)
    return table.concat(keys, "|")
end

local function buildGeometry(vehicle, scanBudget, previousInventory, nowMs)
    local root = rootVehicle(vehicle)
    local entityNode = objectNode(root)
    if root == nil or entityNode == nil then return nil end
    local objects = collectEntityObjects(root)
    local objectSignature = objectSetSignature(objects)
    local refreshMs = OuttaMyWay.PROTOTYPE_07_INVENTORY_REFRESH_MS or 5000
    local inventory = previousInventory
    if inventory == nil or inventory.objectSignature ~= objectSignature
        or nowMs >= (inventory.nextRefreshMs or 0) then
        local candidates, scanned, truncated = collectCandidateNodes(objects, scanBudget)
        inventory = {
            objectSignature=objectSignature,
            candidates=candidates,
            scannedNodes=scanned,
            truncated=truncated,
            nextRefreshMs=nowMs + refreshMs
        }
    end
    local candidates = inventory.candidates or {}
    local scanned = inventory.scannedNodes or 0
    local truncated = inventory.truncated == true
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    local boundedNodes, physicsBoundNodes, worldDerived = 0, 0, 0
    local boundedObjects, physicsObjects = {}, {}
    local sources = {}
    local evidenceSamples = {}
    local unknownNodes = 0

    for _, candidate in ipairs(candidates) do
        local bound, source, physics = discoverNodeBound(candidate.node, entityNode, candidate.role)
        if bound ~= nil then
            boundedNodes = boundedNodes + 1
            boundedObjects[candidate.object] = true
            sources[source] = (sources[source] or 0) + 1
            minX, maxX = math.min(minX, bound.minX), math.max(maxX, bound.maxX)
            minZ, maxZ = math.min(minZ, bound.minZ), math.max(maxZ, bound.maxZ)
            if bound.frame == "WORLD_AABB_DERIVED" then worldDerived = worldDerived + 1 end
            if physics.physicsConfirmed then
                physicsBoundNodes = physicsBoundNodes + 1
                physicsObjects[candidate.object] = true
            end
            if #evidenceSamples < 16 then
                evidenceSamples[#evidenceSamples+1] = {
                    nodeName=nodeName(candidate.node),
                    role=candidate.role,
                    source=source,
                    physicsConfirmed=physics.physicsConfirmed,
                    rigidBodyType=physics.rigidBodyType,
                    collisionMask=physics.collisionMask,
                    width=bound.maxX-bound.minX,
                    length=bound.maxZ-bound.minZ,
                    frame=bound.frame
                }
            end
        else
            unknownNodes = unknownNodes + 1
        end
    end

    local envelope = nil
    if minX ~= math.huge then
        envelope = {
            minX=minX,maxX=maxX,minZ=minZ,maxZ=maxZ,
            width=maxX-minX,length=maxZ-minZ,
            centreX=(minX+maxX)*0.5,centreZ=(minZ+maxZ)*0.5
        }
    end

    local boundedObjectCount, physicsObjectCount = 0, 0
    for _ in pairs(boundedObjects) do boundedObjectCount = boundedObjectCount + 1 end
    for _ in pairs(physicsObjects) do physicsObjectCount = physicsObjectCount + 1 end

    local confidence = "UNKNOWN"
    if envelope ~= nil then
        if physicsObjectCount == #objects and #objects > 0 and not truncated then
            confidence = "HIGH_DISCOVERED"
        elseif physicsBoundNodes > 0 then
            confidence = "MEDIUM_MIXED"
        else
            confidence = "LOW_COMPONENT_BOUNDS"
        end
    end
    local coverage = "NONE"
    if boundedObjectCount == #objects and #objects > 0 then coverage = "ALL_OBJECTS_DISCOVERED"
    elseif boundedObjectCount > 0 then coverage = "PARTIAL_OBJECTS"
    end
    local frameStability = worldDerived > 0 and "MIXED_WITH_WORLD_AABB" or "ENTITY_LOCAL"
    local workWidth, sizeWidth, sizeLength = workingEvidence(objects)

    local geometry = {
        root=root,
        node=entityNode,
        name=objectName(root),
        objectCount=#objects,
        nodeCount=#candidates,
        scannedNodes=scanned,
        truncated=truncated,
        boundedNodeCount=boundedNodes,
        physicsBoundCount=physicsBoundNodes,
        unknownNodeCount=unknownNodes,
        boundedObjectCount=boundedObjectCount,
        physicsObjectCount=physicsObjectCount,
        envelope=envelope,
        confidence=confidence,
        coverage=coverage,
        frameStability=frameStability,
        sourceSummary=sourceSummary(sources),
        evidenceSamples=evidenceSamples,
        workingMarkerWidth=workWidth,
        sizeMetadataWidth=sizeWidth,
        sizeMetadataLength=sizeLength,
        authoritative=false,
        inventory=inventory
    }
    geometry.signature = geometrySignature(geometry)
    return geometry
end

local function envelopeCorners(geometry)
    if geometry == nil or geometry.envelope == nil or geometry.node == nil then return nil end
    local e = geometry.envelope
    local corners = {}
    for _, point in ipairs({
        {e.minX,e.minZ},{e.maxX,e.minZ},{e.maxX,e.maxZ},{e.minX,e.maxZ}
    }) do
        local ok, x, _, z = pcall(localToWorld, geometry.node, point[1], 0, point[2])
        if not ok then return nil end
        corners[#corners+1] = {x=x,z=z}
    end
    return corners
end

local function orientation(a, b, c)
    return (b.x-a.x)*(c.z-a.z) - (b.z-a.z)*(c.x-a.x)
end

local function segmentsIntersect(a, b, c, d)
    local o1, o2 = orientation(a,b,c), orientation(a,b,d)
    local o3, o4 = orientation(c,d,a), orientation(c,d,b)
    return ((o1 > 0 and o2 < 0) or (o1 < 0 and o2 > 0))
       and ((o3 > 0 and o4 < 0) or (o3 < 0 and o4 > 0))
end

local function pointInConvex(point, polygon)
    local sign = nil
    for i=1,#polygon do
        local value = orientation(polygon[i], polygon[(i % #polygon)+1], point)
        if math.abs(value) > 0.0001 then
            local current = value > 0
            if sign == nil then sign = current elseif sign ~= current then return false end
        end
    end
    return true
end

local function pointSegmentDistance(point, a, b)
    local dx, dz = b.x-a.x, b.z-a.z
    local length2 = dx*dx + dz*dz
    if length2 < 0.000001 then
        return math.sqrt((point.x-a.x)^2 + (point.z-a.z)^2)
    end
    local t = ((point.x-a.x)*dx + (point.z-a.z)*dz) / length2
    t = math.max(0, math.min(1, t))
    local x, z = a.x+t*dx, a.z+t*dz
    return math.sqrt((point.x-x)^2 + (point.z-z)^2)
end

local function polygonClearance(a, b)
    if a == nil or b == nil then return nil, false end
    for i=1,#a do
        for j=1,#b do
            if segmentsIntersect(a[i], a[(i % #a)+1], b[j], b[(j % #b)+1]) then return 0, true end
        end
    end
    if pointInConvex(a[1], b) or pointInConvex(b[1], a) then return 0, true end
    local distance = math.huge
    for _, point in ipairs(a) do
        for j=1,#b do distance = math.min(distance, pointSegmentDistance(point, b[j], b[(j % #b)+1])) end
    end
    for _, point in ipairs(b) do
        for j=1,#a do distance = math.min(distance, pointSegmentDistance(point, a[j], a[(j % #a)+1])) end
    end
    return distance, false
end

local function rootPosition(vehicle)
    local node = objectNode(vehicle)
    if node == nil then return nil end
    local ok, x, _, z = pcall(getWorldTranslation, node)
    if not ok then return nil end
    return x, z
end

local function formatNumber(value)
    if value == nil then return "unknown" end
    return string.format("%.2f", value)
end


Evidence.globalFunction = globalFunction
Evidence.rootVehicle = rootVehicle
Evidence.vehicleKey = vehicleKey
Evidence.buildGeometry = buildGeometry
Evidence.envelopeCorners = envelopeCorners
Evidence.polygonClearance = polygonClearance
Evidence.rootPosition = rootPosition
Evidence.formatNumber = formatNumber
