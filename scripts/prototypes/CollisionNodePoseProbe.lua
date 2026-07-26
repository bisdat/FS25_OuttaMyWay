-- FS25_OuttaMyWay v4.6.10
-- Prototype 08A: passive live pose observation for model-catalogued collision nodes.
-- No mesh extents, containment, projected sweep, or vehicle control.

OuttaMyWay.CollisionNodePoseProbe = OuttaMyWay.CollisionNodePoseProbe or {}
local Probe = OuttaMyWay.CollisionNodePoseProbe

local function endsWith(value, suffix)
    value, suffix = tostring(value or ""), tostring(suffix or "")
    return suffix ~= "" and string.sub(value, -string.len(suffix)) == suffix
end

local function rootVehicle(vehicle)
    if vehicle ~= nil and type(vehicle.getRootVehicle) == "function" then
        local ok, root = pcall(vehicle.getRootVehicle, vehicle)
        if ok and root ~= nil and root.isDeleted ~= true then return root end
    end
    return vehicle
end

local function vehicleName(vehicle)
    if vehicle ~= nil and type(vehicle.getName) == "function" then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return tostring(name) end
    end
    return "Condor Endurance II"
end

local function vehicleAsset(vehicle)
    return tostring(vehicle and (vehicle.configFileName or vehicle.configFileNameClean or vehicle.xmlFilename) or "")
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
    if I3DUtil == nil or type(I3DUtil.indexToObject) ~= "function" then return nil, nil end
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
    if rootNode == nil or rootNode == 0 or type(getNumOfChildren) ~= "function"
    or type(getChildAt) ~= "function" or type(getName) ~= "function" then
        return {}, 0, false
    end
    local found, queue, head, scanned = {}, {rootNode}, 1, 0
    while head <= #queue and scanned < budget do
        local node = queue[head]
        head = head + 1
        scanned = scanned + 1
        local okName, name = pcall(getName, node)
        if okName and wanted[tostring(name)] then found[tostring(name)] = node end
        local okCount, count = pcall(getNumOfChildren, node)
        if okCount and type(count) == "number" then
            for childIndex=0,count-1 do
                local okChild, child = pcall(getChildAt, node, childIndex)
                if okChild and child ~= nil and child ~= 0 then queue[#queue+1] = child end
            end
        end
    end
    return found, scanned, head <= #queue
end

local function foldAnimTime(vehicle)
    local spec = vehicle and vehicle.spec_foldable or nil
    local value = spec and tonumber(spec.foldAnimTime) or nil
    if value == nil and vehicle ~= nil and type(vehicle.getFoldAnimTime) == "function" then
        local ok, result = pcall(vehicle.getFoldAnimTime, vehicle)
        if ok then value = tonumber(result) end
    end
    return value
end

local function foldState(value)
    if value == nil then return "UNKNOWN" end
    if value <= 0.02 then return "DEPLOYED" end
    if value >= 0.98 then return "FOLDED" end
    return "TRANSITION"
end

local function localPose(node, rootNode)
    if node == nil or rootNode == nil then return nil end
    local okWorld, wx, wy, wz = pcall(getWorldTranslation, node)
    if not okWorld then return nil end
    local okLocal, lx, ly, lz = pcall(worldToLocal, rootNode, wx, wy, wz)
    if not okLocal then return nil end
    local function basis(px, py, pz)
        local okPoint, bx, by, bz = pcall(localToWorld, node, px, py, pz)
        if not okPoint then return nil end
        local okBasis, blx, bly, blz = pcall(worldToLocal, rootNode, bx, by, bz)
        if not okBasis then return nil end
        return {blx-lx, bly-ly, blz-lz}
    end
    return {x=lx,y=ly,z=lz,axisX=basis(1,0,0),axisY=basis(0,1,0),axisZ=basis(0,0,1)}
end

local function rmsError(samples, predictionKey)
    local total, count = 0, 0
    for _, sample in ipairs(samples) do
        local expected = sample.catalogue[predictionKey]
        if expected ~= nil and sample.pose ~= nil then
            local dx = sample.pose.x - expected[1]
            local dy = sample.pose.y - expected[2]
            local dz = sample.pose.z - expected[3]
            total = total + dx*dx + dy*dy + dz*dz
            count = count + 1
        end
    end
    if count == 0 then return nil end
    return math.sqrt(total / count)
end

local function fmt(value)
    return value == nil and "unknown" or string.format("%.4f", value)
end

local function axisText(axis)
    if axis == nil then return "unknown" end
    return string.format("%.3f,%.3f,%.3f", axis[1] or 0, axis[2] or 0, axis[3] or 0)
end

function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_08_ENABLED == true
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
    self.lastNoCondorWarningMs = nil
    if self.enabled then
        OuttaMyWay.Logger:info("PROTOTYPE08 ACTIVE: 08A live collision-node pose plus 08B model-derived catalogue; passive, extents unresolved, no containment or control")
    else
        OuttaMyWay.Logger:info("PROTOTYPE08 DISABLED")
    end
end

local function countTableEntries(value)
    if type(value) ~= "table" then return 0 end
    local count = 0
    for _ in pairs(value) do count = count + 1 end
    return count
end

function Probe:findCondors()
    local catalogue = OuttaMyWay.ModelCollisionCatalogues and OuttaMyWay.ModelCollisionCatalogues.condorEndurance2_36m or nil
    local result, seenRoots, seenCondors = {}, {}, {}
    local missionVehicles = g_currentMission and g_currentMission.vehicles or nil
    local vehicleSystemVehicles = g_currentMission and g_currentMission.vehicleSystem and g_currentMission.vehicleSystem.vehicles or nil
    local stats = {
        missionVehicles = countTableEntries(missionVehicles),
        vehicleSystemVehicles = countTableEntries(vehicleSystemVehicles),
        uniqueRoots = 0,
        condorCandidates = 0
    }
    if catalogue == nil then return result, stats end

    local function inspect(source)
        if type(source) ~= "table" then return end
        for _, vehicle in pairs(source) do
            local root = rootVehicle(vehicle)
            if root ~= nil and root.isDeleted ~= true then
                if not seenRoots[root] then
                    seenRoots[root] = true
                    stats.uniqueRoots = stats.uniqueRoots + 1
                end
                if not seenCondors[root] and endsWith(vehicleAsset(root), catalogue.assetSuffix) then
                    seenCondors[root] = true
                    result[#result+1] = root
                    stats.condorCandidates = stats.condorCandidates + 1
                end
            end
        end
    end

    inspect(missionVehicles)
    inspect(vehicleSystemVehicles)
    return result, stats
end

function Probe:resolve(vehicle, catalogue)
    local resolved, wanted = {}, {}
    for _, entry in ipairs(catalogue.activeCollisionNodes) do wanted[entry.name] = true end
    for _, entry in ipairs(catalogue.activeCollisionNodes) do
        local node, source = resolveFromMappingTable(vehicle, entry.name)
        if node == nil then node, source = resolveFromPath(vehicle, entry.mappingPath) end
        if node ~= nil then resolved[entry.name] = {node=node, source=source, catalogue=entry} end
    end
    local missing = false
    for name in pairs(wanted) do if resolved[name] == nil then missing = true break end end
    local scanned, truncated = 0, false
    if missing then
        local found
        found, scanned, truncated = scanNames(vehicle.rootNode, wanted, OuttaMyWay.PROTOTYPE_08_NODE_SCAN_BUDGET or 1800)
        for _, entry in ipairs(catalogue.activeCollisionNodes) do
            if resolved[entry.name] == nil and found[entry.name] ~= nil then
                resolved[entry.name] = {node=found[entry.name], source="name-scan", catalogue=entry}
            end
        end
    end
    local count = 0
    for _ in pairs(resolved) do count = count + 1 end
    return resolved, count, scanned, truncated
end

function Probe:attach(vehicle, catalogue, nowSeconds)
    local key = tostring(vehicle)
    local resolved, count, scanned, truncated = self:resolve(vehicle, catalogue)
    local state = {
        vehicle=vehicle, name=vehicleName(vehicle), catalogue=catalogue, resolved=resolved,
        resolvedCount=count, previousFoldState=nil, previousFoldTime=nil, lastDetailedMs=0
    }
    self.states[key] = state
    OuttaMyWay.Logger:val(
        "PROTOTYPE08A ENTITY_ATTACHED t=%.1fs entity=%s asset=%s geometryFamily=36m collisionNodesExpected=%d collisionNodesResolved=%d scanFallbackNodes=%d scanTruncated=%s extentStatus=%s authoritativeEnvelope=false action=none",
        nowSeconds, state.name, vehicleAsset(vehicle), #catalogue.activeCollisionNodes, count, scanned,
        tostring(truncated), catalogue.meshExtentStatus)
    for _, entry in ipairs(catalogue.activeCollisionNodes) do
        local item = resolved[entry.name]
        OuttaMyWay.Logger:obs(
            "PROTOTYPE08A NODE_RESOLVED t=%.1fs entity=%s node=%s resolved=%s source=%s mappingPath=%s shapeId=%s i3dNodeId=%s meshExtent=%s",
            nowSeconds, state.name, entry.name, tostring(item ~= nil), item and item.source or "none",
            entry.mappingPath, tostring(entry.shapeId), tostring(entry.i3dNodeId), catalogue.meshExtentStatus)
    end
    OuttaMyWay.Logger:val(
        "PROTOTYPE08B CATALOGUE_STATUS t=%.1fs entity=%s configurationId=%d physicalCompoundChildren=%d activeBoomCollisionNodes=%d workingWidth=%.1fm deployedOriginSpanX=%.4fm foldedOriginSpanX=%.4fm meshExtentStatus=%s noWorkingWidthSubstitution=%s",
        nowSeconds, state.name, catalogue.foldingConfigurationId, catalogue.physicalCompoundChildCount,
        catalogue.activeBoomCollisionCount, catalogue.workingWidthM,
        catalogue.predictedOriginSpans.deployed.spanX, catalogue.predictedOriginSpans.folded.spanX,
        catalogue.meshExtentStatus, tostring(catalogue.workingWidthSubstitution == false))
    return state
end

function Probe:sample(state, nowSeconds)
    local vehicle, rootNode = state.vehicle, state.vehicle.rootNode
    local foldTime = foldAnimTime(vehicle)
    local currentFoldState = foldState(foldTime)
    local samples, posedCount, minX, maxX, minZ, maxZ = {}, 0, math.huge, -math.huge, math.huge, -math.huge
    for _, entry in ipairs(state.catalogue.activeCollisionNodes) do
        local resolved = state.resolved[entry.name]
        local pose = resolved and localPose(resolved.node, rootNode) or nil
        samples[#samples+1] = {catalogue=entry, pose=pose, source=resolved and resolved.source or "none"}
        if pose ~= nil then
            posedCount = posedCount + 1
            minX, maxX = math.min(minX, pose.x), math.max(maxX, pose.x)
            minZ, maxZ = math.min(minZ, pose.z), math.max(maxZ, pose.z)
        end
    end
    local found = minX ~= math.huge
    local deployedError = rmsError(samples, "predictedDeployed")
    local foldedError = rmsError(samples, "predictedFolded")
    local aiActive = vehicle.spec_aiFieldWorker ~= nil and vehicle.spec_aiFieldWorker.isActive == true
    local changed = state.previousFoldState ~= currentFoldState
    if changed then
        OuttaMyWay.Logger:obs(
            "PROTOTYPE08A FOLD_STATE_CHANGED t=%.1fs entity=%s previous=%s state=%s previousFoldAnimTime=%s foldAnimTime=%s aiActive=%s identityPreserved=true action=none",
            nowSeconds, state.name, tostring(state.previousFoldState), currentFoldState,
            fmt(state.previousFoldTime), fmt(foldTime), tostring(aiActive))
    end
    local logInterval = currentFoldState == "TRANSITION" and (OuttaMyWay.PROTOTYPE_08_TRANSITION_LOG_MS or 250)
        or (OuttaMyWay.PROTOTYPE_08_ENDPOINT_LOG_MS or 2000)
    OuttaMyWay.Logger:rateLimited("p08-pose-" .. tostring(vehicle), logInterval, "VAL",
        "PROTOTYPE08A POSE_SAMPLE t=%.1fs entity=%s foldState=%s foldAnimTime=%s aiActive=%s nodesResolved=%d nodesPosed=%d originSpanX=%s originSpanZ=%s minX=%s maxX=%s minZ=%s maxZ=%s rmsVsDeployed=%s rmsVsFolded=%s closestOfflineEndpoint=%s meshExtents=unknown physicalEnvelope=not-derived action=none",
        nowSeconds, state.name, currentFoldState, fmt(foldTime), tostring(aiActive), state.resolvedCount,
        posedCount, found and fmt(maxX-minX) or "unknown", found and fmt(maxZ-minZ) or "unknown",
        found and fmt(minX) or "unknown", found and fmt(maxX) or "unknown",
        found and fmt(minZ) or "unknown", found and fmt(maxZ) or "unknown",
        fmt(deployedError), fmt(foldedError),
        (deployedError ~= nil and foldedError ~= nil and (deployedError <= foldedError and "DEPLOYED" or "FOLDED")) or "UNKNOWN")

    local nowMs = g_time or 0
    if changed or nowMs - (state.lastDetailedMs or 0) >= (OuttaMyWay.PROTOTYPE_08_NODE_DETAIL_MS or 5000) then
        state.lastDetailedMs = nowMs
        for _, sample in ipairs(samples) do
            local pose = sample.pose
            OuttaMyWay.Logger:obs(
                "PROTOTYPE08A NODE_POSE t=%.1fs entity=%s foldState=%s foldAnimTime=%s node=%s resolved=%s source=%s localX=%s localY=%s localZ=%s axisX=%s axisY=%s axisZ=%s expectedDeployedX=%.4f expectedDeployedY=%.4f expectedDeployedZ=%.4f expectedFoldedX=%.4f expectedFoldedY=%.4f expectedFoldedZ=%.4f extentStatus=%s",
                nowSeconds, state.name, currentFoldState, fmt(foldTime), sample.catalogue.name,
                tostring(pose ~= nil), sample.source, pose and fmt(pose.x) or "unknown",
                pose and fmt(pose.y) or "unknown", pose and fmt(pose.z) or "unknown",
                pose and axisText(pose.axisX) or "unknown",
                pose and axisText(pose.axisY) or "unknown",
                pose and axisText(pose.axisZ) or "unknown",
                sample.catalogue.predictedDeployed[1], sample.catalogue.predictedDeployed[2], sample.catalogue.predictedDeployed[3],
                sample.catalogue.predictedFolded[1], sample.catalogue.predictedFolded[2], sample.catalogue.predictedFolded[3],
                state.catalogue.meshExtentStatus)
        end
    end
    state.previousFoldState, state.previousFoldTime = currentFoldState, foldTime
end

function Probe:update(dt)
    if self.states == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    if self.elapsedMs < (OuttaMyWay.PROTOTYPE_08_INTERVAL_MS or 100) then return end
    self.elapsedMs = self.elapsedMs % (OuttaMyWay.PROTOTYPE_08_INTERVAL_MS or 100)
    local catalogue = OuttaMyWay.ModelCollisionCatalogues and OuttaMyWay.ModelCollisionCatalogues.condorEndurance2_36m or nil
    if catalogue == nil then return end
    local nowSeconds = ((g_time or 0) - (self.startedAtMs or 0)) / 1000
    local present = {}
    local condors, enumeration = self:findCondors()
    OuttaMyWay.Logger:rateLimited("p08-enumeration", OuttaMyWay.PROTOTYPE_08_ENUMERATION_LOG_MS or 2000, "OBS",
        "PROTOTYPE08A ENUMERATION t=%.1fs missionVehicles=%d vehicleSystemVehicles=%d uniqueRoots=%d condorCandidates=%d authoritativeSources=mission.vehicles,mission.vehicleSystem.vehicles action=none",
        nowSeconds, enumeration.missionVehicles, enumeration.vehicleSystemVehicles, enumeration.uniqueRoots, enumeration.condorCandidates)
    if enumeration.condorCandidates == 0 then
        local nowMs = g_time or 0
        if self.lastNoCondorWarningMs == nil or nowMs - self.lastNoCondorWarningMs >= (OuttaMyWay.PROTOTYPE_08_NO_MATCH_WARNING_MS or 5000) then
            self.lastNoCondorWarningMs = nowMs
            OuttaMyWay.Logger:warning("REC",
                "PROTOTYPE08A NO_MATCHING_ENTITY t=%.1fs missionVehicles=%d vehicleSystemVehicles=%d uniqueRoots=%d expectedAssetSuffix=%s diagnosticBlind=true action=none",
                nowSeconds, enumeration.missionVehicles, enumeration.vehicleSystemVehicles, enumeration.uniqueRoots, catalogue.assetSuffix)
        end
    end
    for _, vehicle in ipairs(condors) do
        local key = tostring(vehicle)
        present[key] = true
        local state = self.states[key] or self:attach(vehicle, catalogue, nowSeconds)
        self:sample(state, nowSeconds)
    end
    for key, state in pairs(self.states) do
        if not present[key] then
            OuttaMyWay.Logger:obs("PROTOTYPE08A ENTITY_REMOVED t=%.1fs entity=%s reason=no-longer-enumerated action=none", nowSeconds, state.name)
            self.states[key] = nil
        end
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
    self.lastNoCondorWarningMs = nil
end
