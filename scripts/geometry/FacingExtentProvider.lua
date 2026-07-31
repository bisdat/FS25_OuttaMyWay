-- FS25_OuttaMyWay v4.6.32
-- Prototype 17 / TS017-B: fixture-bounded Facing Extent Provider.
--
-- Converts the existing Condor collision-catalogue identity evidence into a
-- one-sided compact facing extent for Shadow Clearance Calculation. The module
-- is observer-only. It never selects roles, sides, targets or Control actions.

OuttaMyWay.FacingExtentProvider = OuttaMyWay.FacingExtentProvider or {}
local Provider = OuttaMyWay.FacingExtentProvider

Provider._cache = Provider._cache or setmetatable({}, {__mode="k"})

local function safeNumber(value)
    value = tonumber(value)
    if value == nil or value ~= value or value == math.huge or value == -math.huge then return nil end
    return value
end

local function normalized(x, z)
    local length = math.sqrt((x or 0) * (x or 0) + (z or 0) * (z or 0))
    if length < 0.001 then return nil, nil end
    return x / length, z / length
end

local function rootVehicle(vehicle)
    if vehicle ~= nil and type(vehicle.getRootVehicle) == "function" then
        local ok, root = pcall(vehicle.getRootVehicle, vehicle)
        if ok and root ~= nil and root.isDeleted ~= true then return root end
    end
    return vehicle
end

local function referenceNode(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return nil end
    if type(vehicle.getAISteeringNode) == "function" then
        local ok, node = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and node ~= nil and node ~= 0 then return node end
    end
    return vehicle.rootNode ~= nil and vehicle.rootNode ~= 0 and vehicle.rootNode or nil
end

local function assetName(vehicle)
    local root = rootVehicle(vehicle)
    return tostring(root and (root.configFileName or root.configFileNameClean or root.xmlFilename) or "")
end

local function endsWith(value, suffix)
    value, suffix = tostring(value or ""), tostring(suffix or "")
    return suffix ~= "" and string.sub(value, -string.len(suffix)) == suffix
end

local function globalFunction(name)
    local fn = _G ~= nil and _G[name] or nil
    return type(fn) == "function" and fn or nil
end

local function asNode(value)
    if type(value) == "number" and value ~= 0 then return value end
    if type(value) == "table" then
        for _, key in ipairs({"node", "nodeId", "object", "id"}) do
            local node = value[key]
            if type(node) == "number" and node ~= 0 then return node end
        end
    end
    return nil
end

local function resolveFromMappingTable(vehicle, id)
    for _, field in ipairs({"i3dMappings", "i3dMapping"}) do
        local mappings = vehicle and vehicle[field] or nil
        if type(mappings) == "table" then
            local node = asNode(mappings[id])
            if node ~= nil then return node, field end
        end
    end
    if vehicle ~= nil and type(vehicle.getI3DMapping) == "function" then
        local ok, value = pcall(vehicle.getI3DMapping, vehicle, id)
        local node = ok and asNode(value) or nil
        if node ~= nil then return node, "getI3DMapping" end
    end
    return nil, nil
end

local function resolveFromPath(vehicle, path)
    if path == nil or I3DUtil == nil or type(I3DUtil.indexToObject) ~= "function" then return nil, nil end
    local attempts = {
        function() return I3DUtil.indexToObject(vehicle.components, path, vehicle.i3dMappings) end,
        function() return I3DUtil.indexToObject(vehicle.components, path) end,
        function() return I3DUtil.indexToObject(vehicle, path, vehicle.i3dMappings) end
    }
    for index, attempt in ipairs(attempts) do
        local ok, value = pcall(attempt)
        local node = ok and asNode(value) or nil
        if node ~= nil then return node, "I3DUtil.indexToObject#" .. tostring(index) end
    end
    return nil, nil
end

local function scanNames(rootNode, wanted, budget)
    local childCount = globalFunction("getNumOfChildren")
    local childAt = globalFunction("getChildAt")
    local getNameFn = globalFunction("getName")
    if rootNode == nil or rootNode == 0 or childCount == nil or childAt == nil or getNameFn == nil then
        return {}, 0, false
    end
    local found, queue, head, scanned = {}, {rootNode}, 1, 0
    while head <= #queue and scanned < budget do
        local node = queue[head]
        head = head + 1
        scanned = scanned + 1
        local okName, name = pcall(getNameFn, node)
        if okName and wanted[tostring(name)] then found[tostring(name)] = node end
        local okCount, count = pcall(childCount, node)
        if okCount and type(count) == "number" then
            for childIndex=0,count-1 do
                local okChild, child = pcall(childAt, node, childIndex)
                if okChild and child ~= nil and child ~= 0 then queue[#queue+1] = child end
            end
        end
    end
    return found, scanned, head <= #queue
end

local function validBounds(minX, maxX, minY, maxY, minZ, maxZ)
    local values = {minX, maxX, minY, maxY, minZ, maxZ}
    for _, value in ipairs(values) do if safeNumber(value) == nil then return nil end end
    if minX > maxX or minY > maxY or minZ > maxZ then return nil end
    if maxX-minX > 500 or maxY-minY > 200 or maxZ-minZ > 500 then return nil end
    if maxX-minX < 0.001 and maxY-minY < 0.001 and maxZ-minZ < 0.001 then return nil end
    return {minX=minX,maxX=maxX,minY=minY,maxY=maxY,minZ=minZ,maxZ=maxZ}
end

local function callBounds(name, node, preferredOrder)
    local fn = globalFunction(name)
    if fn == nil then return nil, false end
    local ok, a, b, c, d, e, f = pcall(fn, node)
    if not ok then return nil, true end
    local preferred, alternate
    if preferredOrder == "XYZXYZ" then
        preferred = validBounds(a, d, b, e, c, f)
        alternate = validBounds(a, b, c, d, e, f)
    else
        preferred = validBounds(a, b, c, d, e, f)
        alternate = validBounds(a, d, b, e, c, f)
    end
    return preferred or alternate, true
end

local function referencePosition(vehicle)
    local node = referenceNode(vehicle)
    if node == nil then return nil, nil, nil end
    local ok, x, _, z = pcall(getWorldTranslation, node)
    if not ok then return nil, nil, nil end
    return x, z, node
end

local function projectWorldPoint(wx, wz, referenceX, referenceZ, axisX, axisZ)
    return (wx-referenceX) * axisX + (wz-referenceZ) * axisZ
end

local function projectLocalBounds(node, bounds, referenceX, referenceZ, axisX, axisZ)
    local maximum = nil
    for _, x in ipairs({bounds.minX, bounds.maxX}) do
        for _, y in ipairs({bounds.minY, bounds.maxY}) do
            for _, z in ipairs({bounds.minZ, bounds.maxZ}) do
                local ok, wx, _, wz = pcall(localToWorld, node, x, y, z)
                if ok then
                    local value = projectWorldPoint(wx, wz, referenceX, referenceZ, axisX, axisZ)
                    maximum = maximum == nil and value or math.max(maximum, value)
                end
            end
        end
    end
    return maximum
end

local function projectWorldBounds(bounds, referenceX, referenceZ, axisX, axisZ)
    local maximum = nil
    for _, x in ipairs({bounds.minX, bounds.maxX}) do
        for _, z in ipairs({bounds.minZ, bounds.maxZ}) do
            local value = projectWorldPoint(x, z, referenceX, referenceZ, axisX, axisZ)
            maximum = maximum == nil and value or math.max(maximum, value)
        end
    end
    return maximum
end

local function nodeBoundProjection(node, referenceX, referenceZ, axisX, axisZ)
    local bounds = select(1, callBounds("getShapeBoundingBox", node, "XYZXYZ"))
    if bounds ~= nil then
        return projectLocalBounds(node, bounds, referenceX, referenceZ, axisX, axisZ), "getShapeBoundingBox"
    end
    bounds = select(1, callBounds("getBoundingBox", node, "MINMAX"))
    if bounds ~= nil then
        return projectLocalBounds(node, bounds, referenceX, referenceZ, axisX, axisZ), "getBoundingBox"
    end
    bounds = select(1, callBounds("getWorldBoundingBox", node, "MINMAX"))
    if bounds ~= nil then
        return projectWorldBounds(bounds, referenceX, referenceZ, axisX, axisZ), "getWorldBoundingBox"
    end
    return nil, "none"
end

local function originProjection(node, referenceX, referenceZ, axisX, axisZ)
    local ok, x, _, z = pcall(getWorldTranslation, node)
    if not ok then return nil end
    return projectWorldPoint(x, z, referenceX, referenceZ, axisX, axisZ)
end

local function resolveCatalogue(vehicle, catalogue)
    local root = rootVehicle(vehicle)
    if root == nil or root.isDeleted == true then return nil end
    local cached = Provider._cache[root]
    if cached ~= nil and cached.rootNode == root.rootNode then return cached end

    local entries = catalogue.currentPhysicalCollisionShapes or catalogue.activeCollisionNodes or {}
    local resolved, wanted = {}, {}
    for _, entry in ipairs(entries) do wanted[entry.name] = true end
    for _, entry in ipairs(entries) do
        local node, source = resolveFromMappingTable(root, entry.name)
        if node == nil then node, source = resolveFromPath(root, entry.mappingPath) end
        if node ~= nil then resolved[entry.name] = {node=node,source=source,entry=entry} end
    end

    local missing = false
    for name in pairs(wanted) do if resolved[name] == nil then missing = true break end end
    local scanned, truncated = 0, false
    if missing then
        local found
        found, scanned, truncated = scanNames(root.rootNode, wanted,
            tonumber(OuttaMyWay.TS017_CONDOR_NODE_SCAN_BUDGET) or 2200)
        for _, entry in ipairs(entries) do
            if resolved[entry.name] == nil and found[entry.name] ~= nil then
                resolved[entry.name] = {node=found[entry.name],source="name-scan",entry=entry}
            end
        end
    end

    local resolvedCount = 0
    for _ in pairs(resolved) do resolvedCount = resolvedCount + 1 end
    cached = {
        root=root,
        rootNode=root.rootNode,
        entries=entries,
        resolved=resolved,
        expectedCount=#entries,
        resolvedCount=resolvedCount,
        scanned=scanned,
        scanTruncated=truncated
    }
    Provider._cache[root] = cached
    return cached
end

local function apiSummary(counts)
    local keys = {}
    for key in pairs(counts or {}) do keys[#keys+1] = key end
    table.sort(keys)
    local parts = {}
    for _, key in ipairs(keys) do parts[#parts+1] = key .. ":" .. tostring(counts[key]) end
    return #parts > 0 and table.concat(parts, ",") or "none"
end

local function liveCondorExtent(vehicle, catalogue, axisX, axisZ)
    local referenceX, referenceZ = referencePosition(vehicle)
    if referenceX == nil then return nil end
    local resolution = resolveCatalogue(vehicle, catalogue)
    if resolution == nil then return nil end

    local maximumBound, maximumOrigin = nil, nil
    local boundedCount, originCount, apis = 0, 0, {}
    for _, item in pairs(resolution.resolved) do
        local projectedBound, api = nodeBoundProjection(item.node, referenceX, referenceZ, axisX, axisZ)
        if projectedBound ~= nil then
            maximumBound = maximumBound == nil and projectedBound or math.max(maximumBound, projectedBound)
            boundedCount = boundedCount + 1
            apis[api] = (apis[api] or 0) + 1
        end
        local projectedOrigin = originProjection(item.node, referenceX, referenceZ, axisX, axisZ)
        if projectedOrigin ~= nil then
            maximumOrigin = maximumOrigin == nil and projectedOrigin or math.max(maximumOrigin, projectedOrigin)
            originCount = originCount + 1
        end
    end

    maximumBound = maximumBound ~= nil and math.max(0, maximumBound) or nil
    maximumOrigin = maximumOrigin ~= nil and math.max(0, maximumOrigin) or nil
    local completeBounds = resolution.expectedCount > 0
        and resolution.resolvedCount == resolution.expectedCount
        and boundedCount == resolution.expectedCount
        and resolution.scanTruncated ~= true

    if completeBounds and maximumBound ~= nil then
        return {
            extent=maximumBound,
            source="CONDOR_CURRENT_PHYSICAL_CATALOGUE_RUNTIME_BOUNDS",
            confidence="MEDIUM_FIXTURE_BOUNDED",
            coverage="CURRENT_PHYSICAL_CATALOGUE_COMPLETE",
            expectedCount=resolution.expectedCount,
            resolvedCount=resolution.resolvedCount,
            boundedCount=boundedCount,
            originCount=originCount,
            originExtent=maximumOrigin,
            physicalAllowance=0,
            apiSummary=apiSummary(apis),
            scanTruncated=resolution.scanTruncated == true,
            poseSource="LIVE_RUNTIME_POSE"
        }
    end

    if maximumOrigin ~= nil then
        local allowance = safeNumber(OuttaMyWay.TS017_CONDOR_ORIGIN_ALLOWANCE_M) or 2.50
        return {
            extent=maximumOrigin + allowance,
            source="CONDOR_LIVE_CATALOGUED_ORIGINS_PLUS_ALLOWANCE",
            confidence="LOW_FIXTURE_BOUNDED",
            coverage=resolution.resolvedCount == resolution.expectedCount
                and "CURRENT_PHYSICAL_ORIGINS_COMPLETE_BOUNDS_INCOMPLETE"
                or "PARTIAL_CURRENT_PHYSICAL_ORIGINS",
            expectedCount=resolution.expectedCount,
            resolvedCount=resolution.resolvedCount,
            boundedCount=boundedCount,
            originCount=originCount,
            originExtent=maximumOrigin,
            physicalAllowance=allowance,
            apiSummary=apiSummary(apis),
            scanTruncated=resolution.scanTruncated == true,
            poseSource="LIVE_RUNTIME_POSE"
        }
    end
    return nil
end

local function predictedTemplateExtent(vehicle, predictedForwardX, predictedForwardZ, axisX, axisZ)
    local root = rootVehicle(vehicle)
    local rootNode = root and root.rootNode or nil
    local refNode = referenceNode(vehicle)
    if rootNode == nil or refNode == nil then return nil end
    local okWorld, wx, wy, wz = pcall(getWorldTranslation, refNode)
    if not okWorld then return nil end
    local okLocal, refX, _, refZ = pcall(worldToLocal, rootNode, wx, wy, wz)
    if not okLocal then return nil end

    local forwardX, forwardZ = normalized(predictedForwardX, predictedForwardZ)
    if forwardX == nil then return nil end
    local rightX, rightZ = forwardZ, -forwardX
    local minX = safeNumber(OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MIN_X_M) or -1.42
    local maxX = safeNumber(OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MAX_X_M) or 1.42
    local minZ = safeNumber(OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MIN_Z_M) or -5.21
    local maxZ = safeNumber(OuttaMyWay.TS017_CONDOR_FOLDED_ORIGIN_MAX_Z_M) or -1.61
    local maximum = nil
    for _, localX in ipairs({minX, maxX}) do
        for _, localZ in ipairs({minZ, maxZ}) do
            local dx, dz = localX-refX, localZ-refZ
            local worldDx = rightX*dx + forwardX*dz
            local worldDz = rightZ*dx + forwardZ*dz
            local value = worldDx*axisX + worldDz*axisZ
            maximum = maximum == nil and value or math.max(maximum, value)
        end
    end
    if maximum == nil then return nil end
    local originExtent = math.max(0, maximum)
    local allowance = safeNumber(OuttaMyWay.TS017_CONDOR_ORIGIN_ALLOWANCE_M) or 2.50
    return {
        extent=originExtent + allowance,
        source="CONDOR_EMPIRICAL_FOLDED_ORIGIN_TEMPLATE_PLUS_ALLOWANCE",
        confidence="LOW_FIXTURE_MODEL",
        coverage="EMPIRICAL_ACTIVE_BOOM_ORIGIN_TEMPLATE",
        expectedCount=13,
        resolvedCount=0,
        boundedCount=0,
        originCount=8,
        originExtent=originExtent,
        physicalAllowance=allowance,
        apiSummary="template",
        scanTruncated=false,
        poseSource="PREDICTED_DIRECT_EGRESS_BEARING"
    }
end

function Provider:compactYieldExtent(vehicle, axisX, axisZ, mode, predictedForwardX, predictedForwardZ)
    axisX, axisZ = normalized(axisX, axisZ)
    if vehicle == nil or axisX == nil then return nil end
    local catalogue = OuttaMyWay.ModelCollisionCatalogues
        and OuttaMyWay.ModelCollisionCatalogues.condorEndurance2_36m or nil
    if catalogue == nil or not endsWith(assetName(vehicle), catalogue.assetSuffix) then return nil end

    if mode == "PRE" then
        return predictedTemplateExtent(vehicle, predictedForwardX, predictedForwardZ, axisX, axisZ)
    end
    return liveCondorExtent(vehicle, catalogue, axisX, axisZ)
end

function Provider:clear(vehicle)
    local root = rootVehicle(vehicle)
    if root ~= nil then Provider._cache[root] = nil end
end
