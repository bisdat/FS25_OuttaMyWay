-- FS25_OuttaMyWay runtime core.
-- Behaviour-preserving v3 modular baseline.

local function logInfo(text, ...)
    if OuttaMyWay.Logger ~= nil then
        OuttaMyWay.Logger:info(text, ...)
    else
        Logging.info("[OuttaMyWay][INFO] %s", string.format(text, ...))
    end
end

local function logWarning(text, ...)
    if OuttaMyWay.Logger ~= nil then
        OuttaMyWay.Logger:warning("REC", text, ...)
    else
        Logging.warning("[OuttaMyWay][REC] %s", string.format(text, ...))
    end
end

local function isDeleted(vehicle)
    return vehicle == nil or vehicle.isDeleted == true or vehicle.rootNode == nil or vehicle.rootNode == 0
end

local function getName(vehicle)
    if vehicle ~= nil and vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return name end
    end
    return "AI vehicle"
end

local function getNode(vehicle)
    if vehicle.getAISteeringNode ~= nil then
        local ok, node = pcall(vehicle.getAISteeringNode, vehicle)
        if ok and node ~= nil and node ~= 0 then return node end
    end
    return vehicle.rootNode
end

local function isActiveFieldWorker(vehicle)
    if isDeleted(vehicle) then return false end

    -- This is the authoritative FS25 field-worker state.
    local fieldSpec = vehicle.spec_aiFieldWorker
    if fieldSpec ~= nil and fieldSpec.isActive == true then
        return true
    end

    -- Retain these fallbacks for unusual mod vehicles.
    if vehicle.getIsFieldWorkActive ~= nil then
        local ok, active = pcall(vehicle.getIsFieldWorkActive, vehicle)
        if ok and active == true then return true end
    end
    if vehicle.getIsAIActive ~= nil then
        local ok, active = pcall(vehicle.getIsAIActive, vehicle)
        if ok and active == true and fieldSpec ~= nil then return true end
    end
    return false
end

local function getFieldId(x, z)
    if g_currentMission == nil then return 0 end
    local candidates = {
        g_currentMission.fieldGroundSystem,
        g_currentMission.fieldManager,
        g_fieldManager
    }
    for _,system in ipairs(candidates) do
        if system ~= nil and system.getFieldIdAtWorldPosition ~= nil then
            local ok, id = pcall(system.getFieldIdAtWorldPosition, system, x, z)
            if ok and id ~= nil and id ~= 0 then return id end
            -- Some map/script implementations expose this as a plain function.
            ok, id = pcall(system.getFieldIdAtWorldPosition, x, z)
            if ok and id ~= nil and id ~= 0 then return id end
        end
    end
    return 0
end


local function getVehicleLength(vehicle)
    local length = vehicle ~= nil and tonumber(vehicle.sizeLength) or nil
    if length == nil or length < 2.0 or length > 40.0 then
        length = OuttaMyWay.DEFAULT_VEHICLE_LENGTH
    end
    return length
end

-- Best-effort field occupancy probe. Unlike field IDs, this can still work on
-- maps/jobs that report field=0. Every call is protected because maps expose
-- slightly different field-ground APIs.
local function isOnFieldAt(x, z)
    local id = getFieldId(x, z)
    if id ~= 0 then return true end
    if g_currentMission ~= nil then
        local systems = { g_currentMission.fieldGroundSystem, g_currentMission.fieldManager, g_fieldManager }
        for _,system in ipairs(systems) do
            if system ~= nil then
                for _,name in ipairs({"getIsFieldAtWorldPosition", "getIsOnField", "isFieldAtWorldPosition"}) do
                    local fn = system[name]
                    if fn ~= nil then
                        local ok, value = pcall(fn, system, x, z)
                        if not ok then ok, value = pcall(fn, x, z) end
                        if ok and type(value) == "boolean" then return value end
                    end
                end
            end
        end
    end
    if FSDensityMapUtil ~= nil and FSDensityMapUtil.getFieldStatus ~= nil then
        local ok, value = pcall(FSDensityMapUtil.getFieldStatus, x, z)
        if ok then
            if type(value) == "boolean" then return value end
            if type(value) == "number" then return value > 0 end
        end
    end
    return nil
end

-- Returns a best-effort signature for the actual worked-field surface under a
-- point. This is intentionally different from a broad "is on any field" test:
-- when two fields are separated by a grass strip, the first transition from the
-- original cultivated/field-ground surface to grass is the inner edge we want.
-- All API calls are guarded because map versions expose different names.
local function getFieldSurfaceSignature(x, z)
    if g_currentMission ~= nil then
        local systems = { g_currentMission.fieldGroundSystem, g_currentMission.fieldManager, g_fieldManager }
        for _,system in ipairs(systems) do
            if system ~= nil then
                for _,name in ipairs({
                    "getFieldGroundTypeAtWorldPosition",
                    "getFieldGroundTypeAtWorldPos",
                    "getFieldGroundType"
                }) do
                    local fn = system[name]
                    if fn ~= nil then
                        local ok, a, b, c = pcall(fn, system, x, z)
                        if not ok then ok, a, b, c = pcall(fn, x, z) end
                        if ok and a ~= nil then
                            return string.format("FG:%s:%s:%s", tostring(a), tostring(b), tostring(c))
                        end
                    end
                end
            end
        end
    end
    if FSDensityMapUtil ~= nil and FSDensityMapUtil.getFieldStatus ~= nil then
        local ok, a, b, c, d = pcall(FSDensityMapUtil.getFieldStatus, x, z)
        if ok and a ~= nil then
            return string.format("FS:%s:%s:%s:%s", tostring(a), tostring(b), tostring(c), tostring(d))
        end
    end
    return nil
end

local function getFrontPoint(vehicle, node, x, z)
    local dx, _, dz = localDirectionToWorld(node, 0, 0, 1)
    local halfLength = getVehicleLength(vehicle) * 0.5
    return x + dx * halfLength, z + dz * halfLength
end


-- Scan backwards from the vehicle's CURRENT front point and return the first
-- inside-to-outside field transition. This directly locates the inner field
-- edge and does not depend on pass-distance tracking or where the AI job began.
local function scanReverseDistanceToInnerFieldEdge(data)
    local vehicle = data.vehicle
    local node = getNode(vehicle)
    if node == nil or node == 0 then return nil end
    local x, _, z = getWorldTranslation(node)
    local frontX, frontZ = getFrontPoint(vehicle, node, x, z)
    local startFieldId = getFieldId(frontX, frontZ)
    local startOnField = isOnFieldAt(frontX, frontZ)
    local startSurface = getFieldSurfaceSignature(frontX, frontZ)
    local dx, dz = data.dx, data.dz
    local step = 1.0
    local maxDistance = OuttaMyWay.HEAD_ON_BACKOUT_MAX

    for d = step, maxDistance, step do
        local px = frontX - dx*d
        local pz = frontZ - dz*d
        local fieldId = getFieldId(px, pz)
        local onField = isOnFieldAt(px, pz)
        local surface = getFieldSurfaceSignature(px, pz)
        local crossed = false

        if startFieldId ~= 0 and fieldId ~= startFieldId then
            crossed = true
        elseif startOnField == true and onField == false then
            crossed = true
        elseif startSurface ~= nil and surface ~= nil and surface ~= startSurface and onField ~= true then
            crossed = true
        end

        if crossed then
            return d + OuttaMyWay.FIELD_EDGE_OVERSHOOT
        end
    end
    return nil
end

-- Debug-only scan in both directions along the worker's current trajectory.
-- Returns the shortest detected distance to the first field/non-field or field-ID
-- transition. It never influences avoidance decisions.
local function debugNearestFieldEdgeDistance(data)
    local vehicle = data.vehicle
    local node = getNode(vehicle)
    if node == nil or node == 0 then return nil end
    local x, _, z = getWorldTranslation(node)
    local startFieldId = getFieldId(x, z)
    local startOnField = isOnFieldAt(x, z)
    local startSurface = getFieldSurfaceSignature(x, z)

    local function scanDirection(sign)
        for d = OuttaMyWay.FIELD_EDGE_DEBUG_STEP, OuttaMyWay.FIELD_EDGE_DEBUG_MAX, OuttaMyWay.FIELD_EDGE_DEBUG_STEP do
            local px = x + data.dx * d * sign
            local pz = z + data.dz * d * sign
            local fieldId = getFieldId(px, pz)
            local onField = isOnFieldAt(px, pz)
            local surface = getFieldSurfaceSignature(px, pz)
            local crossed = false
            if startFieldId ~= 0 then
                crossed = fieldId ~= startFieldId
            elseif startOnField == true and onField == false then
                crossed = true
            elseif startOnField == false and onField == true then
                crossed = true
            elseif startSurface ~= nil and surface ~= nil and surface ~= startSurface then
                crossed = true
            end
            if crossed then return d end
        end
        return nil
    end

    local forward = scanDirection(1)
    local backward = scanDirection(-1)
    if forward == nil then return backward, nil, backward end
    if backward == nil then return forward, forward, nil end
    return math.min(forward, backward), forward, backward
end



-- The base-game helper does not locate headlands by polling field IDs at each
-- world position. It follows a generated FieldCourse. This diagnostic searches
-- the active AI job/drive strategies for the course waypoint array and reports
-- the distance to the next meaningful direction change (the end of the current
-- straight pass). Everything is guarded and debug-only.
local function getPointXZ(point)
    if type(point) ~= "table" then return nil end
    local x = tonumber(point.x or point.worldX or point.posX)
    local z = tonumber(point.z or point.worldZ or point.posZ)
    if x ~= nil and z ~= nil then return x, z end
    local pos = point.position or point.pos
    if type(pos) == "table" then
        x = tonumber(pos.x or pos[1])
        z = tonumber(pos.z or pos[3] or pos[2])
        if x ~= nil and z ~= nil then return x, z end
    end
    return nil
end

local function looksLikeWaypointArray(value)
    if type(value) ~= "table" then return false end
    local count = #value
    if count < 3 then return false end
    local valid = 0
    for i=1, math.min(count, 8) do
        if getPointXZ(value[i]) ~= nil then valid = valid + 1 end
    end
    return valid >= math.min(3, math.min(count, 8))
end

local function findWaypointArray(root, visited, depth, path)
    if type(root) ~= "table" or depth > 5 then return nil end
    visited = visited or {}
    if visited[root] then return nil end
    visited[root] = true
    if looksLikeWaypointArray(root) then return root, path or "root" end

    -- Prefer keys normally used by GIANTS AI course/path objects.
    local preferred = {"waypoints", "points", "course", "fieldCourse", "path", "generatedCourse"}
    for _, key in ipairs(preferred) do
        local value = rawget(root, key)
        if looksLikeWaypointArray(value) then
            return value, string.format("%s.%s", path or "root", key)
        end
    end
    for key, value in pairs(root) do
        if type(value) == "table" then
            local lower = string.lower(tostring(key))
            if string.find(lower, "course", 1, true) ~= nil
            or string.find(lower, "waypoint", 1, true) ~= nil
            or string.find(lower, "path", 1, true) ~= nil
            or string.find(lower, "strategy", 1, true) ~= nil
            or string.find(lower, "job", 1, true) ~= nil then
                local found, foundPath = findWaypointArray(value, visited, depth + 1,
                    string.format("%s.%s", path or "root", tostring(key)))
                if found ~= nil then return found, foundPath end
            end
        end
    end
    return nil
end

local function getAICourseRoots(vehicle)
    local roots = {}
    local function add(value, name)
        if type(value) == "table" then table.insert(roots, {value=value, name=name}) end
    end
    add(vehicle.spec_aiFieldWorker, "spec_aiFieldWorker")
    add(vehicle.spec_aiJobVehicle, "spec_aiJobVehicle")
    add(vehicle.spec_aiVehicle, "spec_aiVehicle")
    add(vehicle.spec_aiDrivable, "spec_aiDrivable")
    if vehicle.getCurrentAIJob ~= nil then
        local ok, job = pcall(vehicle.getCurrentAIJob, vehicle)
        if ok then add(job, "getCurrentAIJob()") end
    end
    return roots
end

local function collectDriveStrategyRoots(vehicle)
    local roots = {}
    local function add(value, name)
        if type(value) == "table" then table.insert(roots, {value=value, name=name}) end
    end
    local spec = vehicle.spec_aiVehicle
    if type(spec) == "table" then
        add(spec.driveStrategies, "spec_aiVehicle.driveStrategies")
        if type(spec.driveStrategies) == "table" then
            for i,strategy in ipairs(spec.driveStrategies) do
                add(strategy, string.format("spec_aiVehicle.driveStrategies.%d", i))
            end
        end
    end
    add(vehicle.spec_aiFieldWorker, "spec_aiFieldWorker")
    add(vehicle.spec_aiJobVehicle, "spec_aiJobVehicle")
    if vehicle.getCurrentAIJob ~= nil then
        local ok, job = pcall(vehicle.getCurrentAIJob, vehicle)
        if ok then add(job, "getCurrentAIJob()") end
    end
    return roots
end

local function safeCallNumber(root, methodName)
    local fn = root[methodName]
    if type(fn) ~= "function" then return nil end
    local ok, a = pcall(fn, root)
    if ok and type(a) == "number" and a == a and math.abs(a) < 100000 then return a end
    return nil
end

local function debugStrategyEdgeDistance(data)
    local vehicle = data.vehicle
    local node = getNode(vehicle)
    if node == nil or node == 0 then return nil, "no vehicle node" end
    local vx, _, vz = getWorldTranslation(node)
    local hx, hz = data.dx, data.dz

    -- Probe names used by GIANTS drive strategies across game versions. Calls
    -- are protected; unsupported methods are simply ignored.
    local methods = {
        "getDistanceToEndOfField", "getDistanceToFieldEnd",
        "getDistanceToNextTurn", "getDistanceToTurn",
        "getDistanceToNextWaypoint", "getDistanceToTarget",
        "getRemainingDistance", "getDistanceToGoal"
    }
    for _,entry in ipairs(collectDriveStrategyRoots(vehicle)) do
        for _,name in ipairs(methods) do
            local value = safeCallNumber(entry.value, name)
            if value ~= nil and value >= 0 then
                return value, entry.name .. "." .. name .. "()"
            end
        end
    end

    -- Some strategies expose only a current target point. Report its distance
    -- along the present trajectory; this is not assumed to be the field edge,
    -- but it reveals the target the helper is actually driving toward.
    local coordinatePairs = {
        {"targetX","targetZ"}, {"goalX","goalZ"},
        {"currentTargetX","currentTargetZ"}, {"driveTargetX","driveTargetZ"},
        {"lookAheadX","lookAheadZ"}, {"nextX","nextZ"}
    }
    for _,entry in ipairs(collectDriveStrategyRoots(vehicle)) do
        for _,pair in ipairs(coordinatePairs) do
            local x, z = tonumber(entry.value[pair[1]]), tonumber(entry.value[pair[2]])
            if x ~= nil and z ~= nil then
                local rx, rz = x-vx, z-vz
                local longitudinal = rx*hx + rz*hz
                local lateral = math.abs(rx*(-hz) + rz*hx)
                if longitudinal >= 0 and lateral <= math.max(15.0, (data.workingWidth or 6.0)) then
                    return longitudinal, string.format("%s.%s/%s target", entry.name, pair[1], pair[2])
                end
            end
        end
    end
    return nil, "no exposed distance method or forward target"
end

local function debugStrategyKeys(vehicle)
    local out = {}
    for _,entry in ipairs(collectDriveStrategyRoots(vehicle)) do
        local keys = {}
        for k,v in pairs(entry.value) do
            if type(k) == "string" and (type(v) == "number" or type(v) == "function") then
                local lower = string.lower(k)
                if string.find(lower,"distance",1,true) or string.find(lower,"target",1,true)
                or string.find(lower,"turn",1,true) or string.find(lower,"field",1,true)
                or string.find(lower,"waypoint",1,true) then
                    table.insert(keys, k .. ":" .. type(v))
                end
            end
        end
        table.sort(keys)
        if #keys > 0 then
            while #keys > 18 do table.remove(keys) end
            table.insert(out, entry.name .. "{" .. table.concat(keys, ",") .. "}")
        end
    end
    if #out == 0 then return "no relevant strategy keys exposed" end
    return table.concat(out, " | ")
end

local function getSpeedKmh(vehicle)
    if vehicle.getLastSpeed ~= nil then
        local ok, speed = pcall(vehicle.getLastSpeed, vehicle)
        if ok and speed ~= nil then return math.abs(speed) end
    end
    return math.abs(vehicle.lastSpeed or 0)
end

local function markerDistance(leftNode, rightNode)
    if leftNode == nil or rightNode == nil or leftNode == 0 or rightNode == 0 then return nil end
    local lx, _, lz = getWorldTranslation(leftNode)
    local rx, _, rz = getWorldTranslation(rightNode)
    local dx, dz = lx-rx, lz-rz
    local width = math.sqrt(dx*dx + dz*dz)
    if width >= OuttaMyWay.MIN_WORKING_WIDTH and width <= OuttaMyWay.MAX_WORKING_WIDTH then
        return width
    end
    return nil
end

local function probeObjectWidth(object)
    if object == nil then return nil end
    local best = nil

    -- Most AI-capable implements expose left/right AI markers. Their live node
    -- positions naturally reflect many folding/configuration changes.
    if object.getAIMarkers ~= nil then
        local ok, left, right = pcall(object.getAIMarkers, object)
        if ok then best = markerDistance(left, right) end
    end

    -- Work-area geometry is a robust fallback for sprayers, spreaders, seeders
    -- and many mod implements that do not expose getAIMarkers directly.
    local spec = object.spec_workArea
    if spec ~= nil and spec.workAreas ~= nil then
        for _, area in pairs(spec.workAreas) do
            local startNode = area.start or area.startNode
            local widthNode = area.width or area.widthNode
            local candidate = markerDistance(startNode, widthNode)
            if candidate ~= nil and (best == nil or candidate > best) then best = candidate end
        end
    end

    -- Some vehicles/implements provide a direct working-width accessor.
    if object.getWorkingWidth ~= nil then
        local ok, candidate = pcall(object.getWorkingWidth, object)
        if ok and type(candidate) == "number"
            and candidate >= OuttaMyWay.MIN_WORKING_WIDTH
            and candidate <= OuttaMyWay.MAX_WORKING_WIDTH
            and (best == nil or candidate > best) then
            best = candidate
        end
    end
    return best
end

local function scanWorkingWidth(vehicle)
    local best = probeObjectWidth(vehicle)
    local visited = {}
    local function scan(object)
        if object == nil or visited[object] then return end
        visited[object] = true
        local candidate = probeObjectWidth(object)
        if candidate ~= nil and (best == nil or candidate > best) then best = candidate end
        if object.getAttachedImplements ~= nil then
            local ok, attached = pcall(object.getAttachedImplements, object)
            if ok and attached ~= nil then
                for _, entry in pairs(attached) do scan(entry.object or entry) end
            end
        end
    end
    scan(vehicle)
    return math.max(OuttaMyWay.MIN_WORKING_WIDTH,
        math.min(OuttaMyWay.MAX_WORKING_WIDTH, best or OuttaMyWay.DEFAULT_WORKING_WIDTH))
end

local function getWorkingWidth(vehicle)
    local now = g_time or 0
    local cache = OuttaMyWay.widthCache[vehicle]
    if cache == nil or now >= (cache.expiresAt or 0) then
        local width = scanWorkingWidth(vehicle)
        if cache == nil or math.abs(width-(cache.width or 0)) > 0.25 then
            logInfo("Envelope width: %s = %.1fm", getName(vehicle), width)
        end
        cache = {width=width, expiresAt=now+OuttaMyWay.WIDTH_CACHE_MS}
        OuttaMyWay.widthCache[vehicle] = cache
    end
    return cache.width
end

local function safeAtan2(y, x)
    if math.atan2 ~= nil then return math.atan2(y, x) end
    if x > 0 then return math.atan(y/x) end
    if x < 0 and y >= 0 then return math.atan(y/x) + math.pi end
    if x < 0 and y < 0 then return math.atan(y/x) - math.pi end
    if x == 0 and y > 0 then return math.pi*0.5 end
    if x == 0 and y < 0 then return -math.pi*0.5 end
    return 0
end

local function getTurnFactor(vehicle, dx, dz)
    local now = g_time or 0
    local heading = safeAtan2(dx, dz)
    local old = OuttaMyWay.headingHistory[vehicle]
    OuttaMyWay.headingHistory[vehicle] = {heading=heading, time=now}
    if old == nil or now <= (old.time or now) then return 0 end
    local delta = heading - old.heading
    while delta > math.pi do delta = delta - math.pi*2 end
    while delta < -math.pi do delta = delta + math.pi*2 end
    local dt = math.max(0.05, (now-old.time)/1000)
    local rateDeg = math.abs(delta) * 180/math.pi / dt
    return math.max(0, math.min(1, rateDeg/OuttaMyWay.TURN_RATE_FULL_DEG))
end

local function getData(vehicle)
    local node = getNode(vehicle)
    if node == nil or node == 0 then return nil end
    local x, _, z = getWorldTranslation(node)
    local dx, _, dz = localDirectionToWorld(node, 0, 0, 1)
    local len = math.sqrt(dx * dx + dz * dz)
    if len > 0.001 then dx, dz = dx / len, dz / len else dx, dz = 0, 1 end
    local speedKmh = getSpeedKmh(vehicle)
    local workingWidth = getWorkingWidth(vehicle)
    local turnFactor = getTurnFactor(vehicle, dx, dz)

    -- Record the actual AI-job start/headland position once. Map field IDs and
    -- terrain surface queries are unreliable on some maps (often field=0), but
    -- the worker's own starting position is stable and is exactly where it can
    -- safely wait without entering an adjacent field.
    local now = g_time or 0
    if OuttaMyWay.aiStartAnchor[vehicle] == nil then
        OuttaMyWay.aiStartAnchor[vehicle] = {x=x, z=z, dx=dx, dz=dz, time=now}
        logInfo("AI START ANCHOR: %s at %.1f, %.1f", getName(vehicle), x, z)
    end

    -- Track distance travelled since the most recent headland turn/slow phase.
    -- For field jobs that report field=0 this gives us a reliable estimate of
    -- how far the worker must reverse to return to its own headland.
    local progress = OuttaMyWay.passProgress[vehicle]
    if progress == nil then
        progress = {anchorX=x, anchorZ=z, lastX=x, lastZ=z, distance=0, lastReset=now}
        OuttaMyWay.passProgress[vehicle] = progress
    end
    -- Only a real heading change starts a new pass. Brief AI slowdowns must not
    -- reset the distance, otherwise a long pass collapses to the minimum backout.
    if turnFactor >= 0.14 then
        progress.anchorX, progress.anchorZ = x, z
        progress.distance = 0
        progress.lastReset = now
    else
        local adx, adz = x-progress.anchorX, z-progress.anchorZ
        progress.distance = math.sqrt(adx*adx + adz*adz)
    end
    progress.lastX, progress.lastZ = x, z

    local halfWidth = workingWidth * 0.5
    local sideRadius = halfWidth + OuttaMyWay.WIDTH_SIDE_MARGIN
    local turnRadius = sideRadius * (1 + (OuttaMyWay.TURN_SWEEP_MULTIPLIER-1) * turnFactor)
    return {
        vehicle=vehicle, x=x, z=z, dx=dx, dz=dz, dirX=dx, dirZ=dz,
        speedKmh=speedKmh, speedMps=speedKmh / 3.6,
        fieldId=getFieldId(x, z), workingWidth=workingWidth,
        passDistance=progress.distance or 0,
        halfWidth=halfWidth, sideRadius=sideRadius,
        turnFactor=turnFactor, turnRadius=turnRadius
    }
end

local function getOrder(vehicle)
    if OuttaMyWay.vehicleOrder[vehicle] == nil then
        OuttaMyWay.vehicleOrder[vehicle] = OuttaMyWay.nextOrder
        OuttaMyWay.nextOrder = OuttaMyWay.nextOrder + 1
    end
    return OuttaMyWay.vehicleOrder[vehicle]
end

local function closestApproach(a, b)
    local rx, rz = b.x-a.x, b.z-a.z
    local rvx = b.dx*b.speedMps - a.dx*a.speedMps
    local rvz = b.dz*b.speedMps - a.dz*a.speedMps
    local rv2 = rvx*rvx + rvz*rvz
    if rv2 < 0.0001 then return math.sqrt(rx*rx+rz*rz), 0 end
    local t = -(rx*rvx + rz*rvz) / rv2
    t = math.max(0, math.min(OuttaMyWay.PREDICTION_SECONDS, t))
    local cx, cz = rx + rvx*t, rz + rvz*t
    return math.sqrt(cx*cx+cz*cz), t
end

local function pairEnvelope(a, b)
    local straightSide = (a.halfWidth or 3) + (b.halfWidth or 3) + OuttaMyWay.WIDTH_SIDE_MARGIN
    local turningSide = (a.turnRadius or a.sideRadius or 6) + (b.turnRadius or b.sideRadius or 6)
    local sideClearance = math.max(straightSide, turningSide)
    local longitudinal = OuttaMyWay.WIDTH_LONGITUDINAL_MARGIN
        + math.max((a.halfWidth or 3)*0.35, (b.halfWidth or 3)*0.35)
    local predicted = math.max(OuttaMyWay.PREDICTED_CLEARANCE, sideClearance)
    local hardStop = math.max(OuttaMyWay.HARD_STOP_DISTANCE, sideClearance * 0.65)
    local conflictDistance = math.max(OuttaMyWay.CONFLICT_DISTANCE, sideClearance + longitudinal)
    local releaseDistance = math.max(OuttaMyWay.RELEASE_DISTANCE, sideClearance + longitudinal + 8)
    local absoluteClear = math.max(OuttaMyWay.ABSOLUTE_CLEAR_DISTANCE, releaseDistance + 9)
    return sideClearance, longitudinal, predicted, hardStop, conflictDistance, releaseDistance, absoluteClear
end

local function physicalBoomClearance(a, b)
    local aHalf = (a.workingWidth or OuttaMyWay.DEFAULT_WORKING_WIDTH) * 0.5
    local bHalf = (b.workingWidth or OuttaMyWay.DEFAULT_WORKING_WIDTH) * 0.5
    return aHalf + bHalf
end

local function isConflict(a, b)
    if a.fieldId ~= 0 and b.fieldId ~= 0 and a.fieldId ~= b.fieldId then return false end

    local rx, rz = b.x-a.x, b.z-a.z
    local distance = math.sqrt(rx*rx+rz*rz)
    local sideClearance, longitudinalMargin, predictedClearance, hardStop,
        conflictDistance, releaseDistance, absoluteClear = pairEnvelope(a,b)

    if distance >= absoluteClear then return false end

    local headingDot = a.dx*b.dx + a.dz*b.dz

    -- Opposite-direction passes use one simple authoritative rule: if the
    -- centre-line lateral spacing is at least half working width A plus half
    -- working width B, the tools are clear and neither worker yields. Offset
    -- tools are intentionally not handled here yet.
    if headingDot <= -0.45
        and (a.turnFactor or 0) <= OuttaMyWay.BOOM_PASS_MAX_TURN
        and (b.turnFactor or 0) <= OuttaMyWay.BOOM_PASS_MAX_TURN then
        local axisSource = ((a.turnFactor or 0) <= (b.turnFactor or 0)) and a or b
        local oppositeLateral = math.abs(rx*(-axisSource.dz) + rz*axisSource.dx)
        local requiredBoomClearance = physicalBoomClearance(a, b)
        if oppositeLateral >= requiredBoomClearance then
            local oa, ob = getOrder(a.vehicle), getOrder(b.vehicle)
            if oa > ob then oa, ob = ob, oa end
            local key = tostring(oa) .. ":" .. tostring(ob)
            local now = g_time or 0
            local last = OuttaMyWay.clearanceLogState[key] or 0
            if now-last >= OuttaMyWay.CLEARANCE_LOG_INTERVAL_MS then
                OuttaMyWay.clearanceLogState[key] = now
                logInfo("CLEARANCE CHECK: %s / %s lateral=%.1fm required=%.1fm headingDot=%.2f result=SAFE",
                    getName(a.vehicle), getName(b.vehicle), oppositeLateral, requiredBoomClearance, headingDot)
            end
            return false
        end
    end

    -- Wide implements meeting head-on must reserve the approach before their
    -- boom envelopes overlap. At 36m each this begins at roughly 100m, giving
    -- the priority worker room to complete its normal AI headland turn while
    -- the yielding worker remains straight and stationary.
    if headingDot <= OuttaMyWay.HEAD_ON_DOT then
        local maxWidth = math.max(a.workingWidth or 0, b.workingWidth or 0)
        if maxWidth >= OuttaMyWay.WIDE_IMPLEMENT_THRESHOLD then
            local reservationDistance = math.max(
                OuttaMyWay.HEAD_ON_MIN_RESERVATION,
                sideClearance * OuttaMyWay.HEAD_ON_RESERVATION_FACTOR
                    + OuttaMyWay.HEAD_ON_RESERVATION_MARGIN)
            if distance <= reservationDistance then
                return true
            end
        end
    end

    if headingDot >= OuttaMyWay.PARALLEL_HEADING_DOT then
        local hx, hz = a.dx+b.dx, a.dz+b.dz
        local hLen = math.sqrt(hx*hx + hz*hz)
        if hLen > 0.001 then
            hx, hz = hx/hLen, hz/hLen
            local nx, nz = -hz, hx
            local signedLateral = rx*nx + rz*nz
            local lateral = math.abs(signedLateral)
            local longitudinal = math.abs(rx*hx + rz*hz)
            local rvx = b.dx*b.speedMps - a.dx*a.speedMps
            local rvz = b.dz*b.speedMps - a.dz*a.speedMps
            local predictedLateral = math.abs(signedLateral + (rvx*nx + rvz*nz)*OuttaMyWay.PREDICTION_SECONDS)

            -- Adjacent passes are safe only when the complete implement
            -- envelopes remain separated, not merely the tractor centres.
            if lateral >= sideClearance and predictedLateral >= sideClearance then
                return false
            end

            -- Same-direction machines with overlapping booms are only a
            -- conflict while they are also close enough longitudinally.
            if longitudinal > conflictDistance and predictedLateral >= sideClearance*0.85 then
                return false
            end
        end
    end

    local existing = OuttaMyWay.waiting[a.vehicle] ~= nil or OuttaMyWay.waiting[b.vehicle] ~= nil
    if existing then return distance <= releaseDistance end
    if distance <= hardStop then return true end
    if distance > conflictDistance then return false end

    local closest, time = closestApproach(a, b)
    return time > 0.05 and closest <= predictedClearance
end


local function getRearQueueRelation(a, b)
    -- Returns follower, leader for broadly same-direction traffic. Use the
    -- pair's averaged heading instead of only vehicle A's heading: a front
    -- helper may already be turning or stopped when the follower catches it,
    -- which made the old test occasionally reverse front and rear.
    local headingDot = a.dx*b.dx + a.dz*b.dz
    if headingDot < OuttaMyWay.REAR_HEADING_DOT then return nil, nil end

    local hx, hz = a.dx+b.dx, a.dz+b.dz
    local hLen = math.sqrt(hx*hx + hz*hz)
    if hLen < 0.001 then return nil, nil end
    hx, hz = hx/hLen, hz/hLen

    local rx, rz = b.x-a.x, b.z-a.z
    local longitudinal = rx*hx + rz*hz
    local lateral = math.abs(rx*(-hz) + rz*hx)
    local dynamicLaneLimit = math.max(OuttaMyWay.REAR_LATERAL_LIMIT,
        math.min((a.halfWidth or 3)+(b.halfWidth or 3)+1.0, 12.0))
    if lateral > dynamicLaneLimit then return nil, nil end

    -- Ignore nearly side-by-side pairs; this rule is only for a genuine queue.
    if math.abs(longitudinal) < 3.0 then return nil, nil end

    if longitudinal > 0 then
        return a, b -- A follows B
    else
        return b, a -- B follows A
    end
end

local function distanceToRearFieldEdge(data)
    if data == nil or data.fieldId == nil or data.fieldId == 0 then return nil end
    local step = OuttaMyWay.LANE_SAMPLE_STEP
    local maxDistance = OuttaMyWay.LANE_SAMPLE_MAX
    local d = step
    while d <= maxDistance do
        local x = data.x - data.dx*d
        local z = data.z - data.dz*d
        local id = getFieldId(x, z)
        if id ~= data.fieldId then return d end
        d = d + step
    end
    return nil
end

local priorityScore

local function wideHeadOnLaneRelation(a, b)
    if math.max(a.workingWidth or 0, b.workingWidth or 0) < OuttaMyWay.WIDE_IMPLEMENT_THRESHOLD then return nil end
    if a.fieldId ~= 0 and b.fieldId ~= 0 and a.fieldId ~= b.fieldId then return nil end

    local rx, rz = b.x-a.x, b.z-a.z
    local separation = math.sqrt(rx*rx + rz*rz)
    local axisSource = ((a.turnFactor or 0) <= (b.turnFactor or 0)) and a or b
    local axisX, axisZ = axisSource.dx, axisSource.dz
    local lateral = math.abs(rx*(-axisZ) + rz*axisX)
    local longitudinal = math.abs(rx*axisX + rz*axisZ)
    local sideClearance = select(1, pairEnvelope(a,b))
    local headingDot = a.dx*b.dx + a.dz*b.dz
    local boomPassClearance = physicalBoomClearance(a, b)

    -- Opposite-direction workers in stable adjacent lanes may pass boom-to-boom
    -- when the physical spans are clear. They must not create a full-field
    -- head-on reservation merely because the working-width bubbles overlap.
    if headingDot <= OuttaMyWay.HEAD_ON_DOT
        and lateral >= boomPassClearance
        and (a.turnFactor or 0) <= OuttaMyWay.BOOM_PASS_MAX_TURN
        and (b.turnFactor or 0) <= OuttaMyWay.BOOM_PASS_MAX_TURN then
        return nil
    end

    -- Full-field head-on reservation: two wide workers on the same lane axis,
    -- travelling at working speed in directly opposite directions, are handled
    -- immediately regardless of longitudinal separation. Same-direction pairs
    -- are deliberately excluded so the existing following/queue logic remains
    -- unchanged.
    local oa, ob = getOrder(a.vehicle), getOrder(b.vehicle)
    if oa > ob then oa, ob = ob, oa end
    local headOnPairKey = tostring(oa) .. ":" .. tostring(ob)
    local headOnCooldownActive = (OuttaMyWay.headOnCompleted[headOnPairKey] or 0) > (g_time or 0)

    local directHeadOn = not headOnCooldownActive
        and headingDot <= OuttaMyWay.DIRECT_HEAD_ON_DOT
        and lateral <= sideClearance * OuttaMyWay.LANE_ALIGNMENT_FACTOR
        and (a.turnFactor or 0) <= OuttaMyWay.DIRECT_HEAD_ON_MAX_TURN
        and (b.turnFactor or 0) <= OuttaMyWay.DIRECT_HEAD_ON_MAX_TURN
        and (a.speedKmh or 0) >= OuttaMyWay.HEAD_ON_WORKING_SPEED_KMH
        and (b.speedKmh or 0) >= OuttaMyWay.HEAD_ON_WORKING_SPEED_KMH

    if directHeadOn then
        -- Return the vacating worker to the headland it started from, then move
        -- only far enough for the FRONT of the vehicle to cross the inner field
        -- edge. A fixed 14 m margin pushed long sprayers across the grass strip
        -- and into the neighbouring field.
        local function distanceBackToStart(data)
            local boundaryDistance, edges = OuttaMyWay:getBoundaryBackoutDistance(data, getVehicleLength(data.vehicle))
            if boundaryDistance ~= nil then return boundaryDistance, "GIANTS rear ray", edges end
            local anchor = OuttaMyWay.aiStartAnchor[data.vehicle]
            if anchor == nil then return nil, nil, edges end
            local travelled = (data.x-anchor.x)*data.dx + (data.z-anchor.z)*data.dz
            if travelled < 0 then travelled = -travelled end
            return travelled, "AI start anchor fallback", edges
        end
        local aBack, aSource, aEdges = distanceBackToStart(a)
        local bBack, bSource, bEdges = distanceBackToStart(b)
        if aBack == nil or bBack == nil then
            logWarning("HEAD-ON boundary/start target unavailable; holding both workers for manual clearance")
            return nil
        end
        -- This pair is evaluated repeatedly before the authoritative head-on
        -- state is installed. Throttle the diagnostic so it remains useful.
        local now = g_time or 0
        local edgeLog = OuttaMyWay.headOnEdgeLog[headOnPairKey]
        local changed = edgeLog == nil
            or math.abs((edgeLog.aBack or aBack)-aBack) >= 5.0
            or math.abs((edgeLog.bBack or bBack)-bBack) >= 5.0
        if edgeLog == nil or (changed and now >= (edgeLog.nextAt or 0)) then
            local function edgeText(edges)
                if edges == nil then return "unavailable" end
                return string.format("rear=%s forward=%s nearest=%s",
                    edges.rear ~= nil and string.format("%.1f", edges.rear) or "nil",
                    edges.forward ~= nil and string.format("%.1f", edges.forward) or "nil",
                    edges.nearest ~= nil and string.format("%.1f", edges.nearest) or "nil")
            end
            logInfo("HEAD-ON EDGE RETURN: %s target=%.1fm (%s; %s); %s target=%.1fm (%s; %s)",
                getName(a.vehicle), aBack, tostring(aSource), edgeText(aEdges),
                getName(b.vehicle), bBack, tostring(bSource), edgeText(bEdges))
            OuttaMyWay.headOnEdgeLog[headOnPairKey] = {
                aBack=aBack, bBack=bBack, nextAt=now+2000
            }
        end
        local owner, vacater, reverseDistance
        if aBack < bBack - 1.0 then
            vacater, owner, reverseDistance = a, b, aBack
        elseif bBack < aBack - 1.0 then
            vacater, owner, reverseDistance = b, a, bBack
        elseif priorityScore(a) >= priorityScore(b) then
            owner, vacater, reverseDistance = a, b, bBack
        else
            owner, vacater, reverseDistance = b, a, aBack
        end
        reverseDistance = math.max(2.0,
            math.min(OuttaMyWay.HEAD_ON_BACKOUT_MAX, reverseDistance))
        return vacater, owner, reverseDistance, sideClearance, "HEAD_ON_BACKOUT"
    end

    -- A completed head-on encounter owns this pair until the cooldown expires.
    -- Do not let the ordinary local lane-reservation path immediately recreate a
    -- second conflict while the vehicles are still geometrically opposed.
    if headOnCooldownActive then return nil end

    -- Ordinary local headland ownership is only for genuinely opposing lanes.
    -- Perpendicular crossings and ordinary adjacent passes are handled by their
    -- own yield logic and must never escalate into a reverse-to-headland move.
    if headingDot > OuttaMyWay.HEAD_ON_DOT then return nil end

    -- Ordinary local headland ownership remains distance-limited.
    if separation > OuttaMyWay.LANE_LONGITUDINAL_LIMIT then return nil end
    if lateral > sideClearance * OuttaMyWay.LANE_ALIGNMENT_FACTOR then return nil end
    if longitudinal > OuttaMyWay.LANE_LONGITUDINAL_LIMIT then return nil end

    local aHeadland = (a.turnFactor or 0) >= OuttaMyWay.HEADLAND_TURN_TRIGGER
        or (a.speedKmh or 0) <= OuttaMyWay.HEADLAND_SPEED_TRIGGER_KMH
    local bHeadland = (b.turnFactor or 0) >= OuttaMyWay.HEADLAND_TURN_TRIGGER
        or (b.speedKmh or 0) <= OuttaMyWay.HEADLAND_SPEED_TRIGGER_KMH
    if not aHeadland and not bHeadland then return nil end

    local owner, vacater
    if aHeadland ~= bHeadland then
        owner, vacater = aHeadland and a or b, aHeadland and b or a
    elseif priorityScore(a) >= priorityScore(b) then
        owner, vacater = a, b
    else
        owner, vacater = b, a
    end

    local rear = distanceToRearFieldEdge(vacater)
    local reverseDistance = math.min(OuttaMyWay.LANE_REVERSE_MAX,
        math.max(8.0, rear or OuttaMyWay.LANE_FALLBACK_REVERSE))
    return vacater, owner, reverseDistance, sideClearance, "HEADLAND"
end

priorityScore = function(data)
    local now = g_time or 0
    if OuttaMyWay.recovery[data.vehicle] ~= nil then return 2000000 end
    local forcedUntil = OuttaMyWay.forcedPriorityUntil[data.vehicle] or 0
    if forcedUntil > now then
        return 1000000 + data.speedKmh * 1000
    end
    if OuttaMyWay.waiting[data.vehicle] ~= nil then return -100000 end
    -- Moving machine wins; deterministic order resolves equal speeds.
    return data.speedKmh * 1000 - getOrder(data.vehicle) * 0.001
end

local function setObjectWorkState(object, enabled)
    if object == nil or object.isDeleted == true then return end
    if object.getIsTurnedOn ~= nil and object.setIsTurnedOn ~= nil then
        local ok, isOn = pcall(object.getIsTurnedOn, object)
        if ok and isOn ~= enabled then
            pcall(object.setIsTurnedOn, object, enabled, true)
        end
    end
    if object.getAttachedImplements ~= nil then
        local ok, implements = pcall(object.getAttachedImplements, object)
        if ok and type(implements) == "table" then
            for _, implement in pairs(implements) do
                if implement ~= nil then setObjectWorkState(implement.object, enabled) end
            end
        end
    end
end

function OuttaMyWay:setParkedWorkState(vehicle, parked)
    if vehicle == nil then return end
    if parked then
        if self.parkedWorkState[vehicle] ~= true then
            self.parkedWorkState[vehicle] = true
            setObjectWorkState(vehicle, false)
            logInfo("PARKED IMPLEMENT OFF: %s", getName(vehicle))
        end
    elseif self.parkedWorkState[vehicle] ~= nil then
        self.parkedWorkState[vehicle] = nil
        setObjectWorkState(vehicle, true)
        logInfo("PARKED IMPLEMENT RESTORED: %s", getName(vehicle))
    end
end



local function setObjectRaisedState(object, raised)
    if object == nil or object.isDeleted == true then return 0 end
    local changed = 0
    if object.setLowered ~= nil then
        local desiredLowered = not raised
        local current = nil
        if object.getIsLowered ~= nil then
            local ok, value = pcall(object.getIsLowered, object)
            if ok then current = value end
        end
        if current == nil or current ~= desiredLowered then
            local ok = pcall(object.setLowered, object, desiredLowered, true)
            if not ok then ok = pcall(object.setLowered, object, desiredLowered) end
            if ok then changed = changed + 1 end
        end
    end
    if object.getAttachedImplements ~= nil then
        local ok, implements = pcall(object.getAttachedImplements, object)
        if ok and type(implements) == "table" then
            for _, implement in pairs(implements) do
                if implement ~= nil then changed = changed + setObjectRaisedState(implement.object, raised) end
            end
        end
    end
    return changed
end

function OuttaMyWay:setBackoutRaisedState(vehicle, raised)
    if vehicle == nil then return false end
    if raised then
        if self.raisedState[vehicle] ~= true then
            local count = setObjectRaisedState(vehicle, true)
            self.raisedState[vehicle] = true
            logInfo("BACKOUT BOOM RAISED: %s (%d object(s))", getName(vehicle), count)
            return true
        end
    elseif self.raisedState[vehicle] == true then
        self.raisedState[vehicle] = nil
        local count = setObjectRaisedState(vehicle, false)
        logInfo("BACKOUT BOOM LOWER RESTORED: %s (%d object(s))", getName(vehicle), count)
        return true
    end
    return false
end

local function toggleObjectFold(object)
    if object == nil or object.isDeleted == true then return 0 end
    local toggled = 0
    if object.getToggledFoldDirection ~= nil and object.setFoldDirection ~= nil then
        local okDir, direction = pcall(object.getToggledFoldDirection, object)
        if okDir and direction ~= nil and direction ~= 0 then
            local ok = pcall(object.setFoldDirection, object, direction, true)
            if not ok then ok = pcall(object.setFoldDirection, object, direction) end
            if ok then toggled = toggled + 1 end
        end
    end
    if object.getAttachedImplements ~= nil then
        local ok, implements = pcall(object.getAttachedImplements, object)
        if ok and type(implements) == "table" then
            for _, implement in pairs(implements) do
                if implement ~= nil then toggled = toggled + toggleObjectFold(implement.object) end
            end
        end
    end
    return toggled
end

function OuttaMyWay:setParkedFoldState(vehicle, folded)
    if vehicle == nil then return false end
    self.parkedFoldState = self.parkedFoldState or {}
    if folded then
        if self.parkedFoldState[vehicle] ~= true then
            local count = toggleObjectFold(vehicle)
            if count > 0 then
                self.parkedFoldState[vehicle] = true
                logInfo("PARKED BOOM FOLD: %s (%d foldable object(s))", getName(vehicle), count)
                return true
            end
        end
    elseif self.parkedFoldState[vehicle] == true then
        self.parkedFoldState[vehicle] = nil
        local count = toggleObjectFold(vehicle)
        logInfo("PARKED BOOM UNFOLD: %s (%d foldable object(s))", getName(vehicle), count)
        return count > 0
    end
    return false
end

function OuttaMyWay:isYielding(vehicle)
    return self.waiting[vehicle] ~= nil
end

function OuttaMyWay:installDriveHook()
    if self.driveHookInstalled then return end
    if AIVehicleUtil == nil or AIVehicleUtil.driveToPoint == nil then
        logWarning("AIVehicleUtil.driveToPoint unavailable; will retry")
        return
    end

    local original = AIVehicleUtil.driveToPoint
    AIVehicleUtil.driveToPoint = function(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
        if OuttaMyWay ~= nil then
            local assist = OuttaMyWay.aiResumeAssist and OuttaMyWay.aiResumeAssist[vehicle] or nil
            if assist ~= nil then
                local node = getNode(vehicle)
                if node ~= nil and node ~= 0 then
                    local x, _, z = getWorldTranslation(node)
                    local dx, dz = assist.targetX-x, assist.targetZ-z
                    local distance = math.sqrt(dx*dx + dz*dz)
                    if distance <= 0.75 then
                        OuttaMyWay.aiResumeAssist[vehicle] = nil
                        OuttaMyWay:setParkedFoldState(vehicle, false)
                        OuttaMyWay:setBackoutRaisedState(vehicle, false)
                        OuttaMyWay:setParkedWorkState(vehicle, false)
                        OuttaMyWay.aiResumeVerify[vehicle] = {
                            startedAt = g_time or 0,
                            startX=x,
                            startZ=z,
                            retried=assist.retried == true,
                            passageAssist=assist.passageAssist == true
                        }
                        if assist.passageAssist == true then
                            OuttaMyWay:requestAIFieldWorkerResume(vehicle, "passage assist wake-up nudge")
                            logInfo("PASSAGE ASSIST WAKE-UP COMPLETE: %s moved %.1fm forward; AI continuation requested",
                                getName(vehicle), assist.distance or 0)
                        else
                            logInfo("RECOVERY AI HANDOFF: %s moved %.1fm forward; implement restored and AI handback requested",
                                getName(vehicle), assist.distance or 0)
                        end
                        return original(vehicle, dt, 0, false, true, 0, 1, 0)
                    end
                    local alx, _, alz = worldDirectionToLocal(node, dx, 0, dz)
                    local alen = math.sqrt(alx*alx + alz*alz)
                    if alen > 0.001 then alx, alz = alx/alen, alz/alen end
                    return original(vehicle, dt, 1, true, true, alx, alz, OuttaMyWay.AI_HANDOFF_SPEED_KMH)
                end
            end
            local laneState = OuttaMyWay.laneVacate[vehicle]
            -- Predictive live-control speed caps are intentionally applied at
            -- the final AI drive call. This avoids relying on transient AI
            -- strategy objects and leaves steering/course ownership with GIANTS.
            local predictiveCap = OuttaMyWay.predictiveSpeedCaps and OuttaMyWay.predictiveSpeedCaps[vehicle] or nil
            if predictiveCap ~= nil and laneState == nil then
                local now = g_time or 0
                if now <= (predictiveCap.untilTime or 0) then
                    maxSpeed = math.min(maxSpeed or predictiveCap.speedKmh, predictiveCap.speedKmh)
                else
                    OuttaMyWay.predictiveSpeedCaps[vehicle] = nil
                end
            end
            if laneState ~= nil then
                local node = getNode(vehicle)
                if laneState.phase == "REENTERING" and node ~= nil and node ~= 0 then
                    local x, _, z = getWorldTranslation(node)
                    local dx, dz = laneState.reentryTargetX-x, laneState.reentryTargetZ-z
                    local distance = math.sqrt(dx*dx + dz*dz)
                    if distance <= 0.75 then
                        laneState.phase = "REENTRY_COMPLETE"
                        OuttaMyWay:setParkedFoldState(vehicle, false)
                        OuttaMyWay:setBackoutRaisedState(vehicle, false)
                        OuttaMyWay:setParkedWorkState(vehicle, false)
                        logInfo("HEAD-ON REENTRY COMPLETE: %s moved %.1fm into field; boom restoring before AI handback",
                            getName(vehicle), laneState.reentryDistance or 0)
                        return original(vehicle, dt, 0, false, true, 0, 1, 0)
                    end
                    local rlx, _, rlz = worldDirectionToLocal(node, dx, 0, dz)
                    local rlen = math.sqrt(rlx*rlx + rlz*rlz)
                    if rlen > 0.001 then rlx, rlz = rlx/rlen, rlz/rlen end
                    -- Keep the implement off, raised and folded until the whole
                    -- vehicle has moved clear of obstacles behind the field edge.
                    return original(vehicle, dt, 1, true, true, rlx, rlz, OuttaMyWay.HEAD_ON_BACKOUT_SPEED_KMH)
                end
                if laneState.phase == "REVERSING" and node ~= nil and node ~= 0 then
                    local x, _, z = getWorldTranslation(node)
                    local dx, dz = laneState.targetX-x, laneState.targetZ-z
                    local distance = math.sqrt(dx*dx + dz*dz)
                    -- Stop when the FRONT of the reversing vehicle has fully left
                    -- its original field, then allow only a small extra margin. Using
                    -- the centre point allowed most of a long sprayer to enter the
                    -- neighbouring field before the stop condition was reached.
                    if laneState.mode == "HEAD_ON_BACKOUT" then
                        local frontX, frontZ = getFrontPoint(vehicle, node, x, z)
                        local currentFieldId = getFieldId(frontX, frontZ)
                        local frontOnField = isOnFieldAt(frontX, frontZ)
                        local currentSurface = getFieldSurfaceSignature(frontX, frontZ)
                        local crossed = false
                        -- Prefer the worked-surface transition. This catches the
                        -- INNER edge immediately where cultivated ground becomes
                        -- the grass headland strip, even if another field lies a
                        -- few metres farther back.
                        if laneState.startFrontSurface ~= nil and currentSurface ~= nil then
                            crossed = currentSurface ~= laneState.startFrontSurface
                        elseif (laneState.startFrontFieldId or 0) > 0 then
                            crossed = currentFieldId ~= laneState.startFrontFieldId
                        elseif laneState.startFrontOnField == true and frontOnField == false then
                            crossed = true
                        end
                        if laneState.edgeExitX == nil and crossed then
                            laneState.edgeExitX, laneState.edgeExitZ = frontX, frontZ
                            logInfo("HEAD-ON FRONT EDGE: %s front cleared original field; allowing %.1fm margin",
                                getName(vehicle), OuttaMyWay.FIELD_EDGE_OVERSHOOT)
                        elseif laneState.edgeExitX ~= nil then
                            local ex, ez = frontX-laneState.edgeExitX, frontZ-laneState.edgeExitZ
                            if math.sqrt(ex*ex+ez*ez) >= OuttaMyWay.FIELD_EDGE_OVERSHOOT then
                                laneState.phase = "PARKED"
                                laneState.reachedAt = g_time or 0
                                OuttaMyWay:setParkedWorkState(vehicle, true)
                                return original(vehicle, dt, 0, false, false, 0, -1, 0)
                            end
                        end
                    end
                    if distance <= 1.5 then
                        laneState.phase = "PARKED"
                        laneState.reachedAt = g_time or 0
                        OuttaMyWay:setParkedWorkState(vehicle, true)
                        return original(vehicle, dt, 0, false, false, 0, -1, 0)
                    end
                    local lx, _, lz = worldDirectionToLocal(node, dx, 0, dz)
                    local length = math.sqrt(lx*lx + lz*lz)
                    if length > 0.001 then lx, lz = lx/length, lz/length end
                    return original(vehicle, dt, 1, true, false, lx, lz, laneState.mode == "HEAD_ON_BACKOUT" and OuttaMyWay.HEAD_ON_BACKOUT_SPEED_KMH or OuttaMyWay.LANE_REVERSE_SPEED_KMH)
                end
                return original(vehicle, dt, 0, false, false, 0, -1, 0)
            end
            if OuttaMyWay.laneOwnerHold[vehicle] ~= nil then
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            local recovery = OuttaMyWay.recovery[vehicle]
            if recovery ~= nil then
                if recovery.phase == "REVERSE" then
                    -- When two implements are physically T-boned, forward
                    -- steering cannot create clearance. Back the selected
                    -- helper straight away first, then resume the normal
                    -- sideways parking manoeuvre.
                    local node = getNode(vehicle)
                    if node ~= nil and node ~= 0 and recovery.reverseTargetX ~= nil then
                        local x, _, z = getWorldTranslation(node)
                        local dx, dz = recovery.reverseTargetX - x, recovery.reverseTargetZ - z
                        local distance = math.sqrt(dx*dx + dz*dz)
                        if distance <= 1.0 then
                            recovery.reverseTargetReached = true
                            return original(vehicle, dt, 0, false, false, 0, -1, 0)
                        end
                        local rlx, _, rlz = worldDirectionToLocal(node, dx, 0, dz)
                        local length = math.sqrt(rlx*rlx + rlz*rlz)
                        if length > 0.001 then rlx, rlz = rlx/length, rlz/length end
                        return original(vehicle, dt, 1, true, false, rlx, rlz, OuttaMyWay.REVERSE_ESCAPE_SPEED_KMH)
                    end
                    return original(vehicle, dt, 0, false, false, 0, -1, 0)
                elseif recovery.phase == "ESCAPE" then
                    -- Drive toward one fixed parking point instead of applying
                    -- a constant steering angle, which causes endless circles.
                    local node = getNode(vehicle)
                    if node ~= nil and node ~= 0 and recovery.targetX ~= nil then
                        local x, _, z = getWorldTranslation(node)
                        local dx, dz = recovery.targetX - x, recovery.targetZ - z
                        local distance = math.sqrt(dx*dx + dz*dz)
                        if distance <= OuttaMyWay.ESCAPE_TARGET_RADIUS then
                            recovery.targetReached = true
                            return original(vehicle, dt, 0, false, true, 0, 1, 0)
                        end
                        local lx, _, lz = worldDirectionToLocal(node, dx, 0, dz)
                        local length = math.sqrt(lx*lx + lz*lz)
                        if length > 0.001 then lx, lz = lx/length, lz/length end
                        return original(vehicle, dt, 1, true, true, lx, lz, OuttaMyWay.RECOVERY_SPEED_KMH)
                    end
                    return original(vehicle, dt, 0, false, true, 0, 1, 0)
                end
                -- HOLD_CLEAR: remain parked while the other helper passes.
                return original(vehicle, dt, 0, false, true, 0, 1, 0)
            end
            if OuttaMyWay:isYielding(vehicle) then
                local waitState = OuttaMyWay.waiting[vehicle]
                local recovery = waitState ~= nil and waitState.blockedRecovery or nil
                if recovery ~= nil then
                    local node = getNode(vehicle)
                    if node ~= nil and node ~= 0 and (recovery.phase == "MOVING_REVERSE" or recovery.phase == "MOVING_FORWARD") then
                        local x, _, z = getWorldTranslation(node)
                        local moved = math.sqrt((x-(recovery.phaseStartX or x))^2 + (z-(recovery.phaseStartZ or z))^2)
                        local elapsed = (g_time or 0) - (recovery.phaseStartedAt or recovery.startedAt or 0)

                        -- Reverse is the preferred escape. If the vehicle is physically
                        -- unable to reverse, switch once to a forward attempt.
                        if recovery.phase == "MOVING_REVERSE" and elapsed >= 5000 and moved < 1.5 then
                            recovery.phase = "MOVING_FORWARD"
                            recovery.phaseStartX, recovery.phaseStartZ = x, z
                            recovery.phaseStartedAt = g_time or 0
                            recovery.targetX = x + recovery.fx*recovery.distance
                            recovery.targetZ = z + recovery.fz*recovery.distance
                            logInfo("BLOCKED YIELD REVERSE FAILED: %s moved only %.1fm; trying forward %.1fm",
                                getName(vehicle), moved, recovery.distance or 0)
                        end

                        local dx, dz = recovery.targetX-x, recovery.targetZ-z
                        local targetDistance = math.sqrt(dx*dx + dz*dz)
                        if targetDistance <= 0.75 then
                            local completedPhase = recovery.phase
                            recovery.phase = completedPhase == "MOVING_REVERSE" and "PARKED_REVERSE" or "PARKED_FORWARD"
                            recovery.completedAt = g_time or 0
                            logInfo("BLOCKED YIELD RECOVERY COMPLETE: %s moved %.1fm %s; waiting folded/raised for route clearance",
                                getName(vehicle), recovery.distance or 0,
                                completedPhase == "MOVING_REVERSE" and "in reverse" or "forward")
                            return original(vehicle, dt, 0, false, true, 0, 1, 0)
                        end
                        local rlx, _, rlz = worldDirectionToLocal(node, dx, 0, dz)
                        local rlen = math.sqrt(rlx*rlx + rlz*rlz)
                        if rlen > 0.001 then rlx, rlz = rlx/rlen, rlz/rlen end
                        local forwards = recovery.phase == "MOVING_FORWARD"
                        return original(vehicle, dt, 1, true, forwards, rlx, rlz, OuttaMyWay.HEAD_ON_BACKOUT_SPEED_KMH)
                    end
                    -- Once clear of the obstruction, stay compact and parked
                    -- until the existing conflict logic confirms the route clear.
                    return original(vehicle, dt, 0, false, true, 0, 1, 0)
                end
                if waitState ~= nil and waitState.trafficV2 == true then
                    waitState.trafficV2DriveCalls = (waitState.trafficV2DriveCalls or 0) + 1
                    local now = g_time or 0
                    if waitState.trafficV2FirstDriveLogged ~= true
                        or now - (waitState.trafficV2LastDriveLog or 0) >= 500 then
                        waitState.trafficV2FirstDriveLogged = true
                        waitState.trafficV2LastDriveLog = now
                        logInfo("TRAFFIC V2 DRIVE INTERCEPT: %s call=%d inputAccel=%.3f inputAllowed=%s inputForward=%s inputMax=%.2f outputAccel=0 outputAllowed=false outputMax=0",
                            getName(vehicle), waitState.trafficV2DriveCalls, tonumber(acceleration) or 0,
                            tostring(isAllowedToDrive), tostring(moveForwards), tonumber(maxSpeed) or 0)
                    end
                end
                return original(vehicle, dt, 0, false, moveForwards, lx, lz, 0)
            end
        end
        return original(vehicle, dt, acceleration, isAllowedToDrive, moveForwards, lx, lz, maxSpeed)
    end
    self.driveHookInstalled = true
    logInfo("Installed AI driveToPoint interception")
end

function OuttaMyWay:startBlockedYieldRecovery(vehicle, state)
    if vehicle == nil or state == nil or state.blockedRecovery ~= nil then return end
    local node = getNode(vehicle)
    if node == nil or node == 0 then return end

    local x, _, z = getWorldTranslation(node)
    local fx, _, fz = localDirectionToWorld(node, 0, 0, 1)
    local flen = math.sqrt(fx*fx + fz*fz)
    if flen < 0.001 then return end
    fx, fz = fx/flen, fz/flen

    local distance = math.max(4.0, getVehicleLength(vehicle))
    state.blockedRecovery = {
        phase = "MOVING_REVERSE",
        startX = x,
        startZ = z,
        phaseStartX = x,
        phaseStartZ = z,
        targetX = x - fx*distance,
        targetZ = z - fz*distance,
        fx = fx,
        fz = fz,
        distance = distance,
        startedAt = g_time or 0,
        phaseStartedAt = g_time or 0
    }

    -- Keep the application off and the wide implement compact while creeping
    -- clear. The normal release path restores everything after the priority
    -- vehicle has passed.
    self:setParkedWorkState(vehicle, true)
    self:setBackoutRaisedState(vehicle, true)
    self:setParkedFoldState(vehicle, true)
    logInfo("BLOCKED YIELD RECOVERY: %s folding/raising and trying reverse %.1fm first",
        getName(vehicle), distance)
end

function OuttaMyWay:installBlockGuard(vehicle)
    if vehicle.omwBlockGuardInstalled or vehicle.aiBlock == nil then return end
    local original = vehicle.aiBlock
    vehicle.aiBlock = function(v, ...)
        if OuttaMyWay ~= nil and OuttaMyWay:isYielding(v) then
            local state = OuttaMyWay.waiting[v]
            if state ~= nil and not state.blockSuppressedLogged then
                state.blockSuppressedLogged = true
                logInfo("Suppressed built-in blocked state for %s while yielding", getName(v))
            end
            if state ~= nil then
                OuttaMyWay:startBlockedYieldRecovery(v, state)
            end
            return
        end
        return original(v, ...)
    end
    vehicle.omwBlockGuardInstalled = true
end

function OuttaMyWay:showTransient(text)
    self.transientText = text or ""
    self.transientUntil = (g_time or 0) + self.MESSAGE_DURATION_MS
end

function OuttaMyWay:receiveNetworkState(count, priority, transient)
    self.activeWaitCount = count or 0
    self.priorityName = priority or ""
    if transient ~= nil and transient ~= "" then self:showTransient(transient) end
end

function OuttaMyWay:broadcastState(force, transient)
    if g_server == nil or OuttaMyWayStateEvent == nil then return end
    local signature = string.format("%d|%s", self.activeWaitCount, self.priorityName or "")
    if force or signature ~= self.lastNetworkSignature then
        self.lastNetworkSignature = signature
        g_server:broadcastEvent(OuttaMyWayStateEvent.new(self.activeWaitCount, self.priorityName, transient or ""), false)
    end
end



local function pairKey(a, b)
    if a == nil or b == nil then return nil end
    local oa, ob = getOrder(a), getOrder(b)
    if oa > ob then oa, ob = ob, oa end
    return tostring(oa) .. ":" .. tostring(ob)
end

function OuttaMyWay:isRecentEncounterPair(vehicleA, vehicleB)
    if vehicleA == nil or vehicleB == nil then return false end
    local key = pairKey(vehicleA, vehicleB)
    if key == nil then return false end
    local untilTime = self.recentEncounterPairs ~= nil and self.recentEncounterPairs[key] or nil
    return untilTime ~= nil and (g_time or 0) <= untilTime
end

function OuttaMyWay:startPassageAssist(vehicle, priorityVehicle)
    if vehicle == nil or priorityVehicle == nil then
        logInfo("PASSAGE ASSIST ELIGIBILITY: missing vehicle or priority worker")
        return false
    end
    self.passageAssist = self.passageAssist or {}
    if self.passageAssist[vehicle] ~= nil then return true end
    if not self:isRecentEncounterPair(vehicle, priorityVehicle) then
        logInfo("PASSAGE ASSIST ELIGIBILITY: %s / %s rejected (not a recent encounter pair)",
            getName(vehicle), getName(priorityVehicle))
        return false
    end
    local width = getWorkingWidth(vehicle)
    if width < self.WIDE_IMPLEMENT_THRESHOLD then
        logInfo("PASSAGE ASSIST ELIGIBILITY: %s rejected (working width %.1fm < %.1fm)",
            getName(vehicle), width, self.WIDE_IMPLEMENT_THRESHOLD)
        return false
    end

    local folded = self:setParkedFoldState(vehicle, true)
    if not folded then
        logInfo("PASSAGE ASSIST ELIGIBILITY: %s rejected (no foldable object toggled)", getName(vehicle))
        return false
    end
    self:setParkedWorkState(vehicle, true)
    self:setBackoutRaisedState(vehicle, true)

    local pNode = getNode(priorityVehicle)
    local px, _, pz = getWorldTranslation(pNode)
    local aiSpec = vehicle.spec_aiVehicle
    local fieldSpec = vehicle.spec_aiFieldWorker
    local savedStrategy = nil
    if aiSpec ~= nil then
        savedStrategy = aiSpec.driveStrategy or aiSpec.currentDriveStrategy
    end
    if savedStrategy == nil and fieldSpec ~= nil then
        savedStrategy = fieldSpec.driveStrategy
    end

    self.passageAssist[vehicle] = {
        owner = priorityVehicle,
        startedAt = g_time or 0,
        ownerStartX = px,
        ownerStartZ = pz,
        width = width,
        savedDriveStrategy = savedStrategy
    }
    logInfo("PASSAGE ASSIST START: %s folding/raising; %s proceeding", getName(vehicle), getName(priorityVehicle))
    local text = string.format("%s folding boom — %s proceeding", getName(vehicle), getName(priorityVehicle))
    self:showTransient(text)
    self:broadcastState(true, text)
    return true
end

function OuttaMyWay:requestAIFieldWorkerResume(vehicle, reason)
    if isDeleted(vehicle) then return false end

    local fieldSpec = vehicle.spec_aiFieldWorker
    local aiSpec = vehicle.spec_aiVehicle
    local strategy = nil
    if aiSpec ~= nil then
        strategy = aiSpec.driveStrategy or aiSpec.currentDriveStrategy
    end
    if strategy == nil and fieldSpec ~= nil then
        strategy = fieldSpec.driveStrategy
    end

    -- OuttaMyWay only pauses the existing field worker; it does not create a new
    -- job here. Clear every known blocked/pause latch before asking GIANTS to
    -- continue the original course.
    if fieldSpec ~= nil then
        fieldSpec.isBlocked = false
        fieldSpec.blockedSince = nil
        fieldSpec.blockedTimer = 0
        fieldSpec.didNotMoveTimer = 0
        fieldSpec.lastBlockedObject = nil
    end
    if aiSpec ~= nil then
        aiSpec.isBlocked = false
        aiSpec.blockedSince = nil
        aiSpec.blockedTimer = 0
        aiSpec.didNotMoveTimer = 0
    end

    local strategyMethod = "none"
    if strategy ~= nil then
        local candidates = {
            {"setIsPaused", false},
            {"setPaused", false},
            {"resume"},
            {"continue"},
            {"onAIFieldWorkerContinue"}
        }
        for _,entry in ipairs(candidates) do
            local fn = strategy[entry[1]]
            if fn ~= nil then
                local ok
                if entry[2] ~= nil then
                    ok = pcall(fn, strategy, entry[2])
                else
                    ok = pcall(fn, strategy)
                end
                if ok then
                    strategyMethod = entry[1]
                    break
                end
            end
        end
    end

    if SpecializationUtil ~= nil and SpecializationUtil.raiseEvent ~= nil then
        pcall(SpecializationUtil.raiseEvent, vehicle, "onAIFieldWorkerContinue")
        pcall(SpecializationUtil.raiseEvent, vehicle, "onAIImplementContinue")
    end

    if vehicle.aiContinue ~= nil then
        local ok = pcall(vehicle.aiContinue, vehicle)
        if ok then
            logInfo("AI RESUME REQUEST: %s via aiContinue + strategy=%s (%s); fieldActive=%s blocked=%s",
                getName(vehicle), strategyMethod, tostring(reason or "resume"),
                tostring(fieldSpec ~= nil and fieldSpec.isActive == true),
                tostring(fieldSpec ~= nil and fieldSpec.isBlocked == true))
            return true
        end
    end

    -- Fallbacks for unusual mod vehicles that do not expose aiContinue.
    local methods = {"resumeAIFieldWorker", "startFieldWorker", "onAIFieldWorkerStart"}
    for _,name in ipairs(methods) do
        local fn = vehicle[name]
        if fn ~= nil then
            local ok = pcall(fn, vehicle)
            if ok then
                logInfo("AI RESUME REQUEST: %s via %s fallback + strategy=%s (%s)",
                    getName(vehicle), name, strategyMethod, tostring(reason or "resume"))
                return true
            end
        end
    end

    logWarning("AI RESUME REQUEST FAILED: %s has no usable continuation path (%s)",
        getName(vehicle), tostring(reason or "resume"))
    return false
end


function OuttaMyWay:isAIPlanningGrace(vehicle)
    if vehicle == nil then return false end
    local state = self.aiRestartGrace and self.aiRestartGrace[vehicle] or nil
    if state == nil then return false end
    local now = g_time or 0
    if now >= (state.untilTime or 0) then
        self.aiRestartGrace[vehicle] = nil
        return false
    end
    return true, state
end

function OuttaMyWay:isRestartEmergencyPair(a, b)
    if a == nil or b == nil then return false end
    local dx, dz = (b.x or 0)-(a.x or 0), (b.z or 0)-(a.z or 0)
    local distance = math.sqrt(dx*dx + dz*dz)
    local required = (a.halfWidth or 3) + (b.halfWidth or 3)
    local emergencyDistance = math.max(8.0, required * 0.30)
    return distance <= emergencyDistance, distance, emergencyDistance
end

function OuttaMyWay:requestFullAIFieldWorkerRestart(vehicle, reason)
    if vehicle == nil then return false end
    self.aiFullRestart = self.aiFullRestart or {}
    if self.aiFullRestart[vehicle] ~= nil then return true end

    local stopMethod = nil
    local stopCandidates = {"stopFieldWorker", "stopCurrentAIJob", "stopAIJob"}
    for _,name in ipairs(stopCandidates) do
        local fn = vehicle[name]
        if fn ~= nil then
            local ok = pcall(fn, vehicle)
            if ok then
                stopMethod = name
                break
            end
        end
    end

    self.aiFullRestart[vehicle] = {
        phase = "WAIT_START",
        requestedAt = g_time or 0,
        startAt = (g_time or 0) + 1000,
        reason = reason or "passage assist",
        stopMethod = stopMethod or "none"
    }
    self.aiRestartGrace = self.aiRestartGrace or {}
    self.aiRestartGrace[vehicle] = {
        startedAt = g_time or 0,
        untilTime = (g_time or 0) + 30000,
        phase = "STOPPING",
        reason = reason or "passage assist"
    }
    logWarning("FULL AI RESTART STOP: %s via %s; fresh field-worker start scheduled; 30s AI planning grace active",
        getName(vehicle), stopMethod or "no exposed stop method")
    return true
end

function OuttaMyWay:updateFullAIFieldWorkerRestarts()
    local now = g_time or 0
    self.aiFullRestart = self.aiFullRestart or {}
    for vehicle,state in pairs(self.aiFullRestart) do
        if isDeleted(vehicle) then
            self.aiFullRestart[vehicle] = nil
        elseif state.phase == "WAIT_START" and now >= (state.startAt or now) then
            local started = false
            local startMethod = "none"
            local startCandidates = {"startFieldWorker", "startAIFieldWorker", "onAIFieldWorkerStart"}
            for _,name in ipairs(startCandidates) do
                local fn = vehicle[name]
                if fn ~= nil then
                    local ok = pcall(fn, vehicle)
                    if ok then
                        started = true
                        startMethod = name
                        break
                    end
                end
            end
            state.phase = "VERIFY"
            state.verifyAt = now + 30000
            state.startMethod = startMethod
            self.aiRestartGrace = self.aiRestartGrace or {}
            self.aiRestartGrace[vehicle] = {
                startedAt = now, untilTime = now + 30000, phase = "PLANNING",
                reason = state.reason
            }
            local node = getNode(vehicle)
            if node ~= nil and node ~= 0 then
                state.startX, _, state.startZ = getWorldTranslation(node)
            end
            logWarning("FULL AI RESTART START: %s via %s success=%s (%s)",
                getName(vehicle), startMethod, tostring(started), tostring(state.reason))
        elseif state.phase == "VERIFY" and now >= (state.verifyAt or now) then
            local node = getNode(vehicle)
            local moved = 0
            if node ~= nil and node ~= 0 then
                local x,_,z = getWorldTranslation(node)
                moved = math.sqrt((x-(state.startX or x))^2 + (z-(state.startZ or z))^2)
            end
            local speedKmh = math.abs((vehicle.lastSpeedReal or 0) * 3600)
            local aiSpec = vehicle.spec_aiVehicle
            local strategyReady = aiSpec ~= nil and aiSpec.driveStrategy ~= nil
            if moved >= 1.0 or speedKmh >= 1.0 or strategyReady then
                logInfo("FULL AI RESTART RESUMED: %s moved %.1fm speed=%.1fkm/h strategy=%s",
                    getName(vehicle), moved, speedKmh, tostring(strategyReady))
                if self.aiRestartGrace ~= nil then self.aiRestartGrace[vehicle] = nil end
            else
                self.strandedWorkers = self.strandedWorkers or {}
                self.strandedWorkers[vehicle] = {
                    since=now,
                    reason="AI restart failed after passage assist",
                    startMethod=state.startMethod or "none"
                }
                if self.aiRestartGrace ~= nil then self.aiRestartGrace[vehicle] = nil end
                self:setParkedWorkState(vehicle, true)
                self:setBackoutRaisedState(vehicle, true)
                self:setParkedFoldState(vehicle, true)
                logWarning("STRANDED WORKER PARKED: %s stationary after 30s via %s; remaining folded and reserved as a fixed obstruction",
                    getName(vehicle), tostring(state.startMethod or "none"))
            end
            self.aiFullRestart[vehicle] = nil
        end
    end
end

function OuttaMyWay:updatePassageAssist(activeSet, shouldWait)
    self.passageAssist = self.passageAssist or {}
    local now = g_time or 0
    for vehicle, state in pairs(self.passageAssist) do
        local owner = state.owner
        if isDeleted(vehicle) or isDeleted(owner) or not activeSet[vehicle] or not activeSet[owner] then
            self.passageAssist[vehicle] = nil
            if not isDeleted(vehicle) then
                self:setParkedFoldState(vehicle, false)
                self:setBackoutRaisedState(vehicle, false)
                self:setParkedWorkState(vehicle, false)
            end
        else
            shouldWait[vehicle] = owner
            shouldWait[owner] = nil
            local vNode, oNode = getNode(vehicle), getNode(owner)
            local vx,_,vz = getWorldTranslation(vNode)
            local ox,_,oz = getWorldTranslation(oNode)
            local sep = math.sqrt((ox-vx)^2 + (oz-vz)^2)
            local ownerMoved = math.sqrt((ox-(state.ownerStartX or ox))^2 + (oz-(state.ownerStartZ or oz))^2)
            state.phase = state.phase or "HOLD_FOLDED"

            if state.phase == "HOLD_FOLDED" then
                -- Keep requesting the compact state while the fold animation completes.
                self:setParkedWorkState(vehicle, true)
                self:setBackoutRaisedState(vehicle, true)
                self:setParkedFoldState(vehicle, true)
                local clear = now-(state.startedAt or now) >= self.PASSAGE_ASSIST_MIN_MS
                    and ownerMoved >= self.PASSAGE_ASSIST_OWNER_MOVE
                    and sep >= self.PASSAGE_ASSIST_CLEAR_DISTANCE
                if clear or now-(state.startedAt or now) >= self.PASSAGE_ASSIST_TIMEOUT_MS then
                    state.phase = "UNFOLDING"
                    state.unfoldStartedAt = now
                    self:setParkedFoldState(vehicle, false)
                    self:setBackoutRaisedState(vehicle, false)
                    self:setParkedWorkState(vehicle, false)
                    logInfo("PASSAGE ASSIST UNFOLD: %s restoring in place after %s passed (owner moved %.1fm, separation %.1fm)",
                        getName(vehicle), getName(owner), ownerMoved, sep)
                end
            elseif state.phase == "UNFOLDING" then
                -- Hold the vehicle stationary until the unfold animation has had time to complete.
                if now-(state.unfoldStartedAt or now) >= (self.PASSAGE_ASSIST_UNFOLD_SETTLE_MS or 3500) then
                    self.passageAssist[vehicle] = nil
                    shouldWait[vehicle] = nil
                    self.waiting[vehicle] = nil
                    self.passageAssistReleaseUntil = self.passageAssistReleaseUntil or {}
                    self.passageAssistReleaseUntil[vehicle] = now + (self.PASSAGE_ASSIST_RESUME_GRACE_MS or 5000)
                    if self.cancelPredictiveActionsForVehicles ~= nil then
                        self:cancelPredictiveActionsForVehicles(vehicle, owner, "passage assist complete")
                    end

                    -- A stationary handback leaves some GIANTS field workers active but
                    -- without a usable drive strategy. Use the same proven direct-drive
                    -- transition as field-edge re-entry, but only for a short 3m wake-up.
                    local node = getNode(vehicle)
                    local x,_,z = getWorldTranslation(node)
                    local fx,_,fz = localDirectionToWorld(node, 0, 0, 1)
                    local flen = math.sqrt(fx*fx + fz*fz)
                    if flen > 0.001 then fx, fz = fx/flen, fz/flen end
                    local distance = self.PASSAGE_ASSIST_WAKE_DISTANCE or 3.0
                    self.aiResumeAssist[vehicle] = {
                        targetX=x+fx*distance,
                        targetZ=z+fz*distance,
                        distance=distance,
                        retried=true,
                        passageAssist=true
                    }
                    logInfo("PASSAGE ASSIST WAKE-UP: %s moving %.1fm forward after unfold before AI handback",
                        getName(vehicle), distance)
                end
            end
        end
    end
end

function OuttaMyWay:setCourseWaiting(vehicle, priorityVehicle, untilTime)
    local now=g_time or 0
    local state=self.waiting[vehicle]
    if state==nil or state.coursePredictive~=true then
        state={startedAt=now,clearSince=nil,priorityVehicle=priorityVehicle,coursePredictive=true,untilTime=untilTime,
            committedUntil=now+(self.COURSE_HOLD_COMMIT_MS or 5000),courseConfidence=1.0}
        self.waiting[vehicle]=state
        local text=string.format("%s holding briefly — planned route crossing",getName(vehicle))
        logInfo("TRAFFIC HOLD START: %s yields briefly to %s until=%d",getName(vehicle),getName(priorityVehicle),untilTime or 0)
        self:showTransient(text)
        self:broadcastState(true,text)
    else
        state.priorityVehicle=priorityVehicle
        state.untilTime=math.max(state.untilTime or 0,untilTime or 0)
        state.clearSince=nil
    end
end

function OuttaMyWay:applyCourseTrafficHolds(activeSet, shouldWait)
    local now=g_time or 0
    self.coursePredictiveWanted={}
    for _,recommendation in ipairs(self.courseTrafficRecommendations or {}) do
        local vehicle=recommendation.hold and recommendation.hold.vehicle or nil
        local priority=recommendation.priority and recommendation.priority.vehicle or nil
        if vehicle~=nil and priority~=nil and activeSet[vehicle] and activeSet[priority] then
            local score=recommendation.confidenceScore or 0
            local existing=self.waiting and self.waiting[vehicle] or nil
            local maintaining=existing~=nil and existing.coursePredictive==true
                and score>=(self.COURSE_HOLD_RELEASE_CONFIDENCE or 0.45)
            local mayStart=recommendation.eligible==true
            local command=self.getEncounterCommand and self:getEncounterCommand(vehicle) or nil
            local hasLaneReservation=false
            for _,laneState in pairs(self.laneReservations or {}) do
                if laneState.owner==vehicle or laneState.vacater==vehicle or laneState.owner==priority or laneState.vacater==priority then
                    hasLaneReservation=true
                    break
                end
            end
            local busy=(command~=nil)
                or (self.recovery and self.recovery[vehicle]~=nil)
                or hasLaneReservation
                or ((self.waiting and self.waiting[vehicle]~=nil) and not maintaining)
                or (shouldWait[vehicle]~=nil and not maintaining)
            if (mayStart or maintaining) and not busy then
                local untilTime=now+math.floor((recommendation.duration or 3)*1000)
                self.coursePredictiveWanted[vehicle]={priority=priority,untilTime=untilTime,confidenceScore=score}
                shouldWait[vehicle]=priority
            end
        end
    end
end

function OuttaMyWay:setWaiting(vehicle, priorityVehicle)
    -- Give the base-game AI a short uninterrupted window to resume its existing
    -- fieldwork course after a passage-assist unfold. No forward nudge is used.
    local releaseUntil = self.passageAssistReleaseUntil ~= nil and self.passageAssistReleaseUntil[vehicle] or nil
    if releaseUntil ~= nil then
        if (g_time or 0) < releaseUntil then return end
        self.passageAssistReleaseUntil[vehicle] = nil
    end

    -- Active encounters are authoritative. Legacy pair logic may still reach
    -- this function, but it must never overwrite GO or DIRECT_CONTROL.
    if self.getEncounterCommand ~= nil then
        local command, encounter = self:getEncounterCommand(vehicle)
        if command == "GO" or command == "DIRECT_CONTROL" then
            return
        elseif command == "WAIT" and encounter ~= nil then
            priorityVehicle = encounter.owner == vehicle and encounter.yielding or encounter.owner
        end
    end
    local now = g_time or 0
    local state = self.waiting[vehicle]
    if state == nil then
        state = {startedAt=now, clearSince=nil, priorityVehicle=priorityVehicle}
        self.waiting[vehicle] = state
        self:startPassageAssist(vehicle, priorityVehicle)
        local text = string.format("%s waiting — %s has right of way", getName(vehicle), getName(priorityVehicle))
        logInfo("YIELD: %s -> %s", getName(vehicle), getName(priorityVehicle))
        self:showTransient(text)
        self:broadcastState(true, text)
    else
        state.priorityVehicle = priorityVehicle
        state.clearSince = nil
    end
end

function OuttaMyWay:release(vehicle, reason)
    -- Lower-priority clearance logic may not release a worker that the active
    -- encounter explicitly commands to WAIT. Encounter authority calls release
    -- only for GO/DIRECT_CONTROL workers, so those paths remain valid.
    if self.getEncounterCommand ~= nil then
        local command = self:getEncounterCommand(vehicle)
        if command == "WAIT" then return end
    end
    local oldState = self.waiting[vehicle]
    if oldState == nil then return end
    self.waiting[vehicle] = nil

    -- A released helper needs a short, exclusive right-of-way window. Without
    -- this, the next 100 ms conflict scan can select the same helper to yield
    -- again before its AI has had time to accelerate, recreating the deadlock.
    if oldState.coursePredictive ~= true and oldState.priorityVehicle ~= nil and not isDeleted(oldState.priorityVehicle) then
        local node = getNode(vehicle)
        local otherNode = getNode(oldState.priorityVehicle)
        local sx,_,sz = getWorldTranslation(node)
        local ox,_,oz = getWorldTranslation(otherNode)
        local dx,dz = sx-ox, sz-oz
        local separation = math.sqrt(dx*dx + dz*dz)
        -- Only create an exclusive release lock while the pair is still close.
        -- At large separation a lock creates a false distant yield loop.
        if separation < self.ABSOLUTE_CLEAR_DISTANCE then
            self.releasePriority[vehicle] = {
                other = oldState.priorityVehicle,
                startedAt = (g_time or 0),
                untilTime = (g_time or 0) + self.RELEASE_PRIORITY_MS,
                startX = sx,
                startZ = sz
            }
        else
            self.releasePriority[vehicle] = nil
        end
    end

    local blockedRecovery = oldState.blockedRecovery
    if oldState.coursePredictive == true then
        -- A route-timing hold never changes implement state. It simply releases
        -- the base-game AI stop and lets the existing course continue.
    elseif blockedRecovery ~= nil then
        local node = getNode(vehicle)
        if node ~= nil and node ~= 0 then
            local x, _, z = getWorldTranslation(node)
            local fx, _, fz = localDirectionToWorld(node, 0, 0, 1)
            local flen = math.sqrt(fx*fx + fz*fz)
            if flen > 0.001 then fx, fz = fx/flen, fz/flen end
            local distance = math.max(self.AI_HANDOFF_FORWARD_MIN, getVehicleLength(vehicle))
            self.aiResumeAssist[vehicle] = {
                targetX=x+fx*distance, targetZ=z+fz*distance, distance=distance, retried=false
            }
            -- Keep the implement compact until it is clear of anything behind.
            self:setParkedWorkState(vehicle, true)
            self:setBackoutRaisedState(vehicle, true)
            self:setParkedFoldState(vehicle, true)
            logInfo("RECOVERY AI HANDOFF PREPARE: %s moving forward %.1fm folded/raised before AI resume",
                getName(vehicle), distance)
        end
    else
        self:setParkedFoldState(vehicle, false)
        self:setBackoutRaisedState(vehicle, false)
        self:setParkedWorkState(vehicle, false)
    end
    -- Ensure no stale direct-control hold survives the release. The active
    -- reservation loop will recreate a hold if one is still genuinely needed.
    self.laneOwnerHold[vehicle] = nil
    local text = string.format("Route clear — %s resuming", getName(vehicle))
    logInfo("RELEASE: %s (%s)", getName(vehicle), reason)
    self:showTransient(text)
    self:broadcastState(true, text)
end

function OuttaMyWay:collectActive()
    local vehicles = g_currentMission ~= nil and g_currentMission.vehicles or nil
    if vehicles == nil and g_currentMission ~= nil and g_currentMission.vehicleSystem ~= nil then
        vehicles = g_currentMission.vehicleSystem.vehicles
    end
    local result, set = {}, {}
    for _, vehicle in pairs(vehicles or {}) do
        if isActiveFieldWorker(vehicle) then
            self:installBlockGuard(vehicle)
            local data = getData(vehicle)
            if data ~= nil then
                table.insert(result, data)
                set[vehicle] = true
                getOrder(vehicle)
            end
        end
    end
    return result, set
end


local function normalizeAngle(angle)
    while angle > math.pi do angle = angle - math.pi * 2 end
    while angle < -math.pi do angle = angle + math.pi * 2 end
    return angle
end

function OuttaMyWay:startRecovery(vehicle, other, vehicleData, otherData)
    if self.recoveryVehicle ~= nil then return false end
    local now = g_time or 0
    local key = pairKey(vehicle, other)
    if (self.pairCooldown[key] or 0) > now then return false end
    local node = getNode(vehicle)
    if node == nil or node == 0 then return false end

    -- Steer away from the obstruction. Store the original forward/right axes
    -- so actual displacement, rather than wheel rotation, determines success.
    local ox = select(1, worldDirectionToLocal(node, otherData.x-vehicleData.x, 0, otherData.z-vehicleData.z))
    local turnDir = ox >= 0 and -1 or 1
    local rightX, _, rightZ = localDirectionToWorld(node, 1, 0, 0)
    local rightLen = math.sqrt(rightX*rightX + rightZ*rightZ)
    if rightLen > 0.001 then rightX, rightZ = rightX/rightLen, rightZ/rightLen end
    local forwardX, _, forwardZ = localDirectionToWorld(node, 0, 0, 1)
    local forwardLen = math.sqrt(forwardX*forwardX + forwardZ*forwardZ)
    if forwardLen > 0.001 then forwardX, forwardZ = forwardX/forwardLen, forwardZ/forwardLen end
    local targetX = vehicleData.x + rightX * turnDir * self.ESCAPE_TARGET_LATERAL - forwardX * self.ESCAPE_TARGET_REARWARD
    local targetZ = vehicleData.z + rightZ * turnDir * self.ESCAPE_TARGET_LATERAL - forwardZ * self.ESCAPE_TARGET_REARWARD
    local separation = math.sqrt((otherData.x-vehicleData.x)^2 + (otherData.z-vehicleData.z)^2)
    local reverseFirst = separation <= self.REVERSE_TRIGGER_SEPARATION
    local reverseTargetX = vehicleData.x - forwardX * self.REVERSE_ESCAPE_DISTANCE
    local reverseTargetZ = vehicleData.z - forwardZ * self.REVERSE_ESCAPE_DISTANCE

    self.recovery[vehicle] = {
        other=other,
        pairKey=key,
        phase=reverseFirst and "REVERSE" or "ESCAPE",
        startedAt=now,
        phaseStartedAt=now,
        startX=vehicleData.x,
        startZ=vehicleData.z,
        rightX=rightX,
        rightZ=rightZ,
        turnDir=turnDir,
        targetX=targetX,
        targetZ=targetZ,
        targetReached=false,
        reverseTargetX=reverseTargetX,
        reverseTargetZ=reverseTargetZ,
        reverseTargetReached=false,
        escapeAttempts=1
    }
    self.recoveryVehicle = vehicle
    self.forcedPriorityUntil[other] = now + self.HOLD_TIMEOUT_MS + self.RECOVERY_PRIORITY_MS
    self:release(vehicle, "starting lane-clear recovery")
    local text = string.format("%s moving clear; %s held", getName(vehicle), getName(other))
    if reverseFirst then
        logInfo("DEADLOCK REVERSE START: %s reversing %.1fm before moving %s; %s held", getName(vehicle), self.REVERSE_ESCAPE_DISTANCE, turnDir < 0 and "right" or "left", getName(other))
    else
        logInfo("DEADLOCK ESCAPE START: %s moving %s; %s held", getName(vehicle), turnDir < 0 and "right" or "left", getName(other))
    end
    self:showTransient(text)
    self:broadcastState(true, text)
    return true
end

function OuttaMyWay:finishRecovery(vehicle, reason)
    local now = g_time or 0
    local state = self.recovery[vehicle]
    if state == nil then return end
    self.recovery[vehicle] = nil
    if self.recoveryVehicle == vehicle then self.recoveryVehicle = nil end
    self.pairCooldown[state.pairKey] = now + self.PAIR_COOLDOWN_MS
    self.forcedPriorityUntil[state.other] = now + self.RECOVERY_PRIORITY_MS
    self:release(vehicle, reason)
    local text = string.format("%s passed — %s resuming AI", getName(state.other), getName(vehicle))
    logInfo("DEADLOCK RECOVERY END: %s (%s)", getName(vehicle), reason)
    self:showTransient(text)
    self:broadcastState(true, text)
end

function OuttaMyWay:updateRecovery(byVehicle, shouldWait)
    local now = g_time or 0
    local vehicle = self.recoveryVehicle
    if vehicle == nil then return end
    local state = self.recovery[vehicle]
    if state == nil then self.recoveryVehicle = nil; return end
    local data, otherData = byVehicle[vehicle], byVehicle[state.other]
    if data == nil or otherData == nil then
        self:finishRecovery(vehicle, "AI inactive")
        return
    end

    -- Remove graph decisions for this pair; recovery owns the right-of-way.
    shouldWait[vehicle] = nil
    shouldWait[state.other] = nil

    local dx, dz = data.x-state.startX, data.z-state.startZ
    local moved = math.sqrt(dx*dx + dz*dz)
    local lateral = math.abs(dx*state.rightX + dz*state.rightZ)
    local ox, oz = otherData.x-data.x, otherData.z-data.z
    local separation = math.sqrt(ox*ox + oz*oz)

    if state.phase == "REVERSE" then
        -- Keep the opposing helper stopped while the selected vehicle backs
        -- out of physical contact. This phase is deliberately short and
        -- bounded so it cannot become another runaway manoeuvre.
        shouldWait[state.other] = vehicle
        local reverseTimedOut = now-state.phaseStartedAt >= self.REVERSE_ESCAPE_TIMEOUT_MS
        local reverseDone = state.reverseTargetReached == true or moved >= self.REVERSE_ESCAPE_DISTANCE - 0.8
        if reverseDone or reverseTimedOut then
            state.phase = "ESCAPE"
            state.phaseStartedAt = now
            state.startX, state.startZ = data.x, data.z
            state.targetReached = false
            state.targetX = data.x + state.rightX * state.turnDir * self.ESCAPE_TARGET_LATERAL - data.dirX * self.ESCAPE_TARGET_REARWARD
            state.targetZ = data.z + state.rightZ * state.turnDir * self.ESCAPE_TARGET_LATERAL - data.dirZ * self.ESCAPE_TARGET_REARWARD
            self:release(vehicle, reverseTimedOut and "reverse escape timeout; trying lateral clearance" or "reverse clearance complete")
            shouldWait[state.other] = vehicle
            local text = string.format("%s backed clear — moving aside", getName(vehicle))
            logInfo("DEADLOCK REVERSE END: %s moved %.1fm (%s); beginning lateral escape", getName(vehicle), moved, reverseTimedOut and "timeout" or "target reached")
            self:showTransient(text)
            self:broadcastState(true, text)
        end
    elseif state.phase == "ESCAPE" then
        -- The other helper stays stopped until the recovering helper has
        -- physically vacated the lane.
        shouldWait[state.other] = vehicle
        local escapeTimedOut = now-state.phaseStartedAt >= self.ESCAPE_TIMEOUT_MS
        local escaped = state.targetReached == true or (
            now-state.phaseStartedAt >= self.ESCAPE_MIN_TIME_MS
            and moved >= self.ESCAPE_MIN_DISTANCE
            and lateral >= self.ESCAPE_MIN_LATERAL
            and separation >= self.ESCAPE_MIN_SEPARATION)
        if escaped or escapeTimedOut then
            state.phase = "HOLD_CLEAR"
            state.phaseStartedAt = now
            state.otherStartX, state.otherStartZ = otherData.x, otherData.z
            shouldWait[state.other] = nil
            shouldWait[vehicle] = state.other
            self:setWaiting(vehicle, state.other)
            self:release(state.other, "recovery vehicle is parked clear")
            local text = string.format("%s parked clear — %s proceeding", getName(vehicle), getName(state.other))
            logInfo("DEADLOCK HOLD CLEAR: %s moved %.1fm (lateral %.1fm, %s); releasing %s", getName(vehicle), moved, lateral, escapeTimedOut and "escape timeout" or "parking point reached", getName(state.other))
            self:showTransient(text)
            self:broadcastState(true, text)
        end
    else
        -- Recovering vehicle remains parked. The other has exclusive priority
        -- until it has moved away and is safely outside the conflict zone.
        shouldWait[vehicle] = state.other
        shouldWait[state.other] = nil
        local odx, odz = otherData.x-(state.otherStartX or otherData.x), otherData.z-(state.otherStartZ or otherData.z)
        local otherMoved = math.sqrt(odx*odx + odz*odz)
        local clear = now-state.phaseStartedAt >= self.PASS_MIN_TIME_MS
            and separation >= self.PASS_CLEAR_DISTANCE
            and otherMoved >= 10.0
        if clear then
            self:finishRecovery(vehicle, "opposing helper passed clear")
        elseif now-state.phaseStartedAt >= self.PASS_PROGRESS_CHECK_MS
            and otherMoved < self.PASS_MIN_PROGRESS
            and (state.escapeAttempts or 1) < 2 then
            -- The nominal parking point was not far enough for the other
            -- vehicle/implement combination. Move the recovery vehicle farther
            -- outward, then try the pass again instead of waiting to timeout.
            state.escapeAttempts = (state.escapeAttempts or 1) + 1
            state.phase = "ESCAPE"
            state.phaseStartedAt = now
            state.targetReached = false
            state.startX, state.startZ = data.x, data.z
            state.targetX = data.x + state.rightX * state.turnDir * self.SECOND_ESCAPE_LATERAL
            state.targetZ = data.z + state.rightZ * state.turnDir * self.SECOND_ESCAPE_LATERAL
            shouldWait[vehicle] = nil
            shouldWait[state.other] = vehicle
            self:release(vehicle, "parking point still blocked; moving farther clear")
            self:setWaiting(state.other, vehicle)
            local text = string.format("%s moving farther clear — %s still held", getName(vehicle), getName(state.other))
            logInfo("DEADLOCK SECOND ESCAPE: %s moving %.1fm farther outward; %s has only moved %.1fm", getName(vehicle), self.SECOND_ESCAPE_LATERAL, getName(state.other), otherMoved)
            self:showTransient(text)
            self:broadcastState(true, text)
        elseif now-state.phaseStartedAt >= self.HOLD_TIMEOUT_MS then
            self:finishRecovery(vehicle, "hold-clear timeout")
        end
    end
end


-- Field-boundary detection and geometry moved to scripts/geometry/FieldBoundary.lua.

-- Vector prediction moved to scripts/prediction/VectorPrediction.lua.

function OuttaMyWay:updateConflicts()
    if self.settings ~= nil and not self.settings.enabled then
        self.lastActiveCount = 0
        return
    end
    if g_currentMission == nil or g_server == nil then return end
    self:installDriveHook()
    -- Refresh pair authority before any legacy yield/release code executes.
    if self.syncEncounterController ~= nil then self:syncEncounterController() end
    local active, activeSet = self:collectActive()
    for _,d in ipairs(active) do
        self:startGiantsBoundaryProbe(d)
        self:logGiantsBoundaryDistance(d)
    end
    self:updateVectorPrediction(active)
    if self.CourseLookahead ~= nil and self.CourseLookahead.update ~= nil then
        self.CourseLookahead:update(active)
    end

    if #active ~= self.lastActiveCount then
        self.lastActiveCount = #active
        logInfo("Detected %d active AI field worker(s)", #active)
        for _, d in ipairs(active) do
            logInfo("  AI: %s field=%s speed=%.1f width=%.1fm turn=%.0f%%", getName(d.vehicle), tostring(d.fieldId), d.speedKmh, d.workingWidth or 0, (d.turnFactor or 0)*100)
        end
    end


    local graph, byVehicle = {}, {}
    for _, d in ipairs(active) do graph[d.vehicle] = {}; byVehicle[d.vehicle] = d end
    for i=1,#active-1 do
        for j=i+1,#active do
            local a,b = active[i],active[j]
            local aGrace = self:isAIPlanningGrace(a.vehicle)
            local bGrace = self:isAIPlanningGrace(b.vehicle)
            local aStranded = self.strandedWorkers ~= nil and self.strandedWorkers[a.vehicle] ~= nil
            local bStranded = self.strandedWorkers ~= nil and self.strandedWorkers[b.vehicle] ~= nil
            local emergency, distance, emergencyDistance = self:isRestartEmergencyPair(a,b)
            local strandedApproach = (aStranded or bStranded) and distance <= (self.STRANDED_APPROACH_DISTANCE or 85.0)
            if strandedApproach then
                graph[a.vehicle][b.vehicle] = true
                graph[b.vehicle][a.vehicle] = true
            elseif (aGrace or bGrace) and not emergency then
                -- Give GIANTS time to rebuild a fresh field-work course. Ordinary
                -- predictive/reactive decisions are suppressed during this window.
            elseif isConflict(a,b) then
                graph[a.vehicle][b.vehicle] = true
                graph[b.vehicle][a.vehicle] = true
                if (aGrace or bGrace) and emergency then
                    logWarning("AI RESTART EMERGENCY OVERRIDE: %s / %s distance=%.1fm threshold=%.1fm; reactive control allowed",
                        getName(a.vehicle), getName(b.vehicle), distance or -1, emergencyDistance or -1)
                end
            end
        end
    end

    local visited, shouldWait, headOnPriorityNoFold = {}, {}, {}
    for _, start in ipairs(active) do
        local sv = start.vehicle
        if not visited[sv] and next(graph[sv]) ~= nil then
            local stack, component = {sv}, {}
            visited[sv] = true
            while #stack > 0 do
                local v = table.remove(stack)
                table.insert(component,v)
                for n in pairs(graph[v]) do
                    if not visited[n] then visited[n]=true; table.insert(stack,n) end
                end
            end
            local priority = component[1]
            local score = priorityScore(byVehicle[priority])
            for k=2,#component do
                local candidate = component[k]
                local s = priorityScore(byVehicle[candidate])
                if s > score then priority,score = candidate,s end
            end
            for _,v in ipairs(component) do if v ~= priority then shouldWait[v]=priority end end
        end
    end

    -- Perpendicular crossing pass-through. When one worker is already moving
    -- through the intersection and the other is slower or beginning a turn,
    -- stopping the moving worker creates the obstruction we are trying to avoid.
    -- Give the faster worker priority so it clears the crossing in one motion.
    for i=1,#active-1 do
        for j=i+1,#active do
            local a,b = active[i],active[j]
            local headingDot = a.dx*b.dx + a.dz*b.dz
            if graph[a.vehicle][b.vehicle] and math.abs(headingDot) <= self.CROSSING_DOT_MAX then
                local speedDelta = (a.speedKmh or 0) - (b.speedKmh or 0)
                if math.abs(speedDelta) >= 0.75 then
                    local mover = speedDelta > 0 and a.vehicle or b.vehicle
                    local slower = speedDelta > 0 and b.vehicle or a.vehicle
                    shouldWait[mover] = nil
                    shouldWait[slower] = mover
                end
            end
        end
    end

    local now = g_time or 0

    -- Wide-implement headland occupancy. This runs before ordinary priority and
    -- recovery overrides, but only for a local headland zone. Workers at
    -- opposite ends of a field are ignored.
    local activeLanePairs = {}
    for i=1,#active-1 do
        for j=i+1,#active do
            local a,b = active[i],active[j]
            local vacater,owner,edgeDistance,sideClearance,mode = wideHeadOnLaneRelation(a,b)
            local aStranded = self.strandedWorkers ~= nil and self.strandedWorkers[a.vehicle] ~= nil
            local bStranded = self.strandedWorkers ~= nil and self.strandedWorkers[b.vehicle] ~= nil
            if (aStranded ~= bStranded) then
                local stranded = aStranded and a or b
                local moving = aStranded and b or a
                local dx, dz = stranded.x-moving.x, stranded.z-moving.z
                local distance = math.sqrt(dx*dx + dz*dz)
                local closing = moving.dx*dx + moving.dz*dz
                if distance <= (self.STRANDED_APPROACH_DISTANCE or 85.0) and closing > 0 then
                    vacater, owner = moving, stranded
                    local boundaryDistance = nil
                    if self.getBoundaryBackoutDistance ~= nil then
                        boundaryDistance = self:getBoundaryBackoutDistance(moving, getVehicleLength(moving.vehicle))
                    end
                    edgeDistance = boundaryDistance or math.min(35.0, math.max(12.0, distance*0.35))
                    sideClearance = (moving.halfWidth or 3)+(stranded.halfWidth or 3)
                    mode = "STRANDED_HEAD_ON_BACKOUT"
                    logWarning("STRANDED APPROACH CONTROL: %s approaching parked %s at %.1fm; %s selected to back out %.1fm",
                        getName(moving.vehicle), getName(stranded.vehicle), distance, getName(moving.vehicle), edgeDistance)
                end
            end
            if vacater ~= nil then
                local key = pairKey(vacater.vehicle, owner.vehicle)
                activeLanePairs[key] = true
                local state = self.laneReservations[key]
                if state == nil then
                    local vacaterGrace = self:isAIPlanningGrace(vacater.vehicle)
                    local ownerGrace = self:isAIPlanningGrace(owner.vehicle)
                    if vacaterGrace or ownerGrace then
                        logWarning("AI RESTART HEAD-ON SELECTION: owner=%s vacater=%s ownerPlanning=%s vacaterPlanning=%s edge=%.1fm mode=%s",
                            getName(owner.vehicle), getName(vacater.vehicle), tostring(ownerGrace == true),
                            tostring(vacaterGrace == true), edgeDistance or -1, tostring(mode))
                    end
                    -- v2.2 keeps vacating local and bounded. A worker no longer
                    -- reverses tens of metres merely because another worker at
                    -- the opposite end shares the same geometric lane.
                    local reverseCap = mode == "HEAD_ON_BACKOUT" and self.HEAD_ON_BACKOUT_MAX or self.LANE_REVERSE_MAX
                    local reverseDistance = math.min(reverseCap, math.max(8.0, edgeDistance))
                    local targetX = vacater.x - vacater.dx*reverseDistance
                    local targetZ = vacater.z - vacater.dz*reverseDistance
                    state = {
                        key=key, vacater=vacater.vehicle, owner=owner.vehicle,
                        startedAt=now, phase="REVERSING", targetX=targetX,
                        startFieldId=vacater.fieldId or 0, edgeExitX=nil, edgeExitZ=nil,
                        startFrontFieldId=0, startFrontOnField=nil, startFrontSurface=nil,
                        targetZ=targetZ, sideClearance=sideClearance,
                        reverseDistance=reverseDistance,
                        startX=vacater.x, startZ=vacater.z,
                        lastMoveCheckAt=now, lastMoveX=vacater.x, lastMoveZ=vacater.z,
                        ownerStartDx=owner.dx, ownerStartDz=owner.dz, ownerStartX=owner.x, ownerStartZ=owner.z,
                        mode=mode,
                        prepareUntil=nil,
                        timeoutAt=now + math.max(
                            mode == "HEAD_ON_BACKOUT" and self.HEAD_ON_BACKOUT_TIMEOUT_MS or self.LANE_REVERSE_TIMEOUT_MS,
                            (reverseDistance / math.max(1.0, mode == "HEAD_ON_BACKOUT" and self.HEAD_ON_BACKOUT_SPEED_KMH or self.LANE_REVERSE_SPEED_KMH)) * 3600 + 30000)
                    }
                    do
                        local node = getNode(vacater.vehicle)
                        if node ~= nil and node ~= 0 then
                            local fx, fz = getFrontPoint(vacater.vehicle, node, vacater.x, vacater.z)
                            state.startFrontFieldId = getFieldId(fx, fz)
                            state.startFrontOnField = isOnFieldAt(fx, fz)
                            state.startFrontSurface = getFieldSurfaceSignature(fx, fz)
                        end
                    end
                    self.laneReservations[key] = state
                    self.laneVacate[vacater.vehicle] = state
                    if self.cancelPredictiveActionsForVehicles ~= nil then
                        self:cancelPredictiveActionsForVehicles(vacater.vehicle, owner.vehicle, "superseded by lane reservation")
                    end
                    if mode == "HEAD_ON_BACKOUT" then
                        -- Owner continues under its normal AI command until the
                        -- protected following gap is reached. Do not install an
                        -- unconditional laneOwnerHold here: the drive hook would
                        -- stop it immediately regardless of separation.
                        self.laneOwnerHold[owner.vehicle] = nil
                        self:setParkedWorkState(vacater.vehicle, true)
                        self:setBackoutRaisedState(vacater.vehicle, true)
                        self:setParkedFoldState(vacater.vehicle, true)
                        self:release(vacater.vehicle, "head-on direct backout")
                        logInfo("HEAD-ON BACKOUT READY: %s implement off, raised/folding; reverse beginning immediately", getName(vacater.vehicle))
                    end
                    self.releasePriority[vacater.vehicle] = nil
                    self.releasePriority[owner.vehicle] = nil
                    self:release(owner.vehicle, "lane ownership granted")
                    if mode == "HEAD_ON_BACKOUT" then
                        logInfo("HEAD-ON BACKOUT: %s proceeding with protected gap; %s reversing %.1fm",
                            getName(owner.vehicle), getName(vacater.vehicle), reverseDistance)
                    else
                        logInfo("LANE RESERVED: %s owns lane; %s reversing %.1fm to headland",
                            getName(owner.vehicle), getName(vacater.vehicle), reverseDistance)
                    end
                    local text
                    if mode == "HEAD_ON_BACKOUT" then
                        text = string.format("HEAD-ON: %s backing out — %s stopped", getName(vacater.vehicle), getName(owner.vehicle))
                    else
                        text = string.format("%s owns lane — %s backing to headland", getName(owner.vehicle), getName(vacater.vehicle))
                    end
                    self:showTransient(text)
                    self:broadcastState(true, text)
                end
                if state.phase == "FOLDING_PARKED" and now >= (state.foldReleaseAt or now) then
                state.phase = "PARKED"
                self.laneOwnerHold[state.owner] = nil
                shouldWait[state.owner] = nil
                shouldWait[state.vacater] = state.owner
                self:release(state.owner, "blocked vacater boom folded")
                logInfo("HEAD-ON FOLD CLEAR: %s folded/secured; %s released", getName(state.vacater), getName(state.owner))
            end
            if state.mode == "HEAD_ON_BACKOUT" and state.phase == "REVERSING" then
                    shouldWait[state.owner] = state.vacater
                    -- The vacater is controlled directly by driveToPoint interception.
                    -- Do not also place it in the ordinary waiting system, otherwise
                    -- both vehicles can become mutually yielded.
                    shouldWait[state.vacater] = nil
                else
                    shouldWait[state.owner] = nil
                    shouldWait[state.vacater] = state.owner
                end
            end
        end
    end

    -- Maintain reservations even after headings diverge while the owner turns.
    for key,state in pairs(self.laneReservations) do
        local vd,od = byVehicle[state.vacater],byVehicle[state.owner]
        if vd == nil or od == nil then
            self.laneVacate[state.vacater] = nil
            self.laneOwnerHold[state.owner] = nil
            self.laneReservations[key] = nil
            self:setParkedWorkState(state.vacater, false)
            self:setParkedFoldState(state.vacater, false)
            self:setBackoutRaisedState(state.vacater, false)
            if vd ~= nil then self:release(state.vacater, "lane owner inactive") end
        else
            if state.phase == "REENTRY_COMPLETE" then
                -- Re-entry is complete, but ownership remains authoritative until
                -- the returning worker has genuinely travelled forward. Separation
                -- alone is not proof that the worker has resumed its course.
                self.laneVacate[state.vacater] = nil
                self.laneOwnerHold[state.owner] = state
                state.phase = "PROTECTED_REENTRY"
                state.protectedStartedAt = now
                state.protectedUntil = now + 15000
                state.protectedStartX, state.protectedStartZ = vd.x, vd.z
                state.protectedLastLogAt = now
                shouldWait[state.vacater] = nil
                shouldWait[state.owner] = state.vacater
                -- Clear any stale wait left on the returning worker before giving
                -- the owner an explicit hold.
                self:release(state.vacater, "folded re-entry complete; protected priority")
                self:setWaiting(state.owner, state.vacater)
                logInfo("LANE REENTRY PROTECTED: %s priority locked; %s held until %.1fm forward travel",
                    getName(state.vacater), getName(state.owner), 25.0)
            elseif state.phase == "PROTECTED_REENTRY" then
                local pdx, pdz = vd.x-(state.protectedStartX or vd.x), vd.z-(state.protectedStartZ or vd.z)
                local protectedTravel = math.sqrt(pdx*pdx + pdz*pdz)
                local sdx, sdz = od.x-vd.x, od.z-vd.z
                local protectedSeparation = math.sqrt(sdx*sdx + sdz*sdz)
                local requiredTravel = 25.0
                shouldWait[state.vacater] = nil
                shouldWait[state.owner] = state.vacater
                self.laneOwnerHold[state.owner] = state
                -- Reconcile stale state every update: returning worker is free,
                -- designated owner remains held.
                if self.waiting[state.vacater] ~= nil then
                    self:release(state.vacater, "protected re-entry priority")
                end
                if self.waiting[state.owner] == nil then
                    self:setWaiting(state.owner, state.vacater)
                end
                if now-(state.protectedLastLogAt or 0) >= 2000 then
                    state.protectedLastLogAt = now
                    logInfo("PROTECTED REENTRY PROGRESS: %s %.1f/%.1fm (separation %.1fm)",
                        getName(state.vacater), protectedTravel, requiredTravel, protectedSeparation)
                end
                local travelledClear = protectedTravel >= requiredTravel
                local timedOutWithProgress = now >= (state.protectedUntil or now) and protectedTravel >= 5.0
                if travelledClear or timedOutWithProgress then
                    self.laneReservations[key] = nil
                    self.laneOwnerHold[state.owner] = nil
                    self.laneVacate[state.vacater] = nil
                    shouldWait[state.owner] = nil
                    shouldWait[state.vacater] = nil
                    -- Explicitly reconcile both sides so neither retains a stale
                    -- waiting record from an earlier controller.
                    self:release(state.owner, "protected re-entry complete")
                    self:release(state.vacater, "protected re-entry complete")
                    logInfo("LANE RELEASED: %s protected re-entry complete (travel %.1fm, separation %.1fm; both workers released)",
                        getName(state.vacater), protectedTravel, protectedSeparation)
                elseif now >= (state.protectedUntil or now) and protectedTravel < 5.0 then
                    -- Do not silently release a worker that has failed to resume.
                    -- Keep ownership stable and surface the condition for manual
                    -- intervention while allowing another progress window.
                    state.protectedUntil = now + 10000
                    local text = string.format("%s has not resumed after re-entry — manual check may be needed", getName(state.vacater))
                    logInfo("PROTECTED REENTRY STALLED: %s travelled only %.1fm; %s remains held",
                        getName(state.vacater), protectedTravel, getName(state.owner))
                    self:showTransient(text)
                    self:broadcastState(true, text)
                end
            elseif state.phase == "REVERSING" then
                local moved = 0
                if state.lastMoveX ~= nil then
                    local mx, mz = vd.x-state.lastMoveX, vd.z-state.lastMoveZ
                    moved = math.sqrt(mx*mx+mz*mz)
                end
                local movementWindowElapsed = now-(state.lastMoveCheckAt or state.startedAt) >= self.LANE_BLOCK_CHECK_MS
                if movementWindowElapsed and moved >= self.LANE_BLOCK_MIN_MOVEMENT then
                    state.lastMoveCheckAt = now
                    state.lastMoveX, state.lastMoveZ = vd.x, vd.z
                end
                if movementWindowElapsed and moved < self.LANE_BLOCK_MIN_MOVEMENT then
                    -- If the selected vacater cannot reverse, treat its current
                    -- position as the parking point. This commonly means it is
                    -- already at its own headland/start anchor. Never hand it back
                    -- to normal AI here: that can send it straight into the owner.
                    state.phase = "PARKED"
                    state.blockedAt = now
                    self.laneVacate[state.vacater] = nil
                    self.laneOwnerHold[state.owner] = nil
                    -- The blocked vacater stays parked and folded. The priority
                    -- worker must be released immediately; never create reciprocal
                    -- yields here, as that is a guaranteed stalemate.
                    shouldWait[state.owner] = nil
                    shouldWait[state.vacater] = state.owner
                    self:setParkedWorkState(state.vacater, true)
                    local folded = self:setParkedFoldState(state.vacater, true)
                    self:release(state.owner, "blocked vacater parked")
                    logInfo("HEAD-ON BACKOUT BLOCKED: %s moved only %.1fm; parked%s. %s released immediately",
                        getName(state.vacater), moved, folded and " and folding" or "", getName(state.owner))
                    local text = string.format("%s parked/folded — %s proceeding", getName(state.vacater), getName(state.owner))
                    self:showTransient(text)
                    self:broadcastState(true, text)
                elseif now >= (state.timeoutAt or (state.startedAt + (state.mode == "HEAD_ON_BACKOUT" and self.HEAD_ON_BACKOUT_TIMEOUT_MS or self.LANE_REVERSE_TIMEOUT_MS))) then
                    state.phase = "PARKED"
                    self:setParkedWorkState(state.vacater, true)
                    logInfo("LANE VACATE TIMEOUT: %s parked after reverse timeout", getName(state.vacater))
                end
            end
            if state.mode == "HEAD_ON_BACKOUT" and state.phase == "REVERSING" then
                -- Protected-gap waiting is managed below through shouldWait.
                -- Keeping laneOwnerHold set would override that calculation and
                -- force the owner to stop from the first frame of the backout.
                self.laneOwnerHold[state.owner] = nil
                headOnPriorityNoFold[state.owner] = true
                local sx, sz = od.x-vd.x, od.z-vd.z
                local separation = math.sqrt(sx*sx + sz*sz)
                local wasWaiting = self.waiting[state.owner] ~= nil
                local holdDistance = wasWaiting and self.HEAD_ON_FOLLOW_RELEASE_DISTANCE or self.HEAD_ON_FOLLOW_HOLD_DISTANCE
                if separation <= holdDistance then
                    shouldWait[state.owner] = state.vacater
                else
                    shouldWait[state.owner] = nil
                end
                shouldWait[state.vacater] = nil
            elseif state.phase == "BLOCKED_RECOVER" then
                self.laneOwnerHold[state.owner] = state
                shouldWait[state.owner] = state.vacater
                shouldWait[state.vacater] = nil
            elseif state.phase == "PROTECTED_REENTRY" then
                self.laneOwnerHold[state.owner] = state
                shouldWait[state.owner] = state.vacater
                shouldWait[state.vacater] = nil
            else
                self.laneOwnerHold[state.owner] = nil
                shouldWait[state.owner] = nil
                shouldWait[state.vacater] = state.owner
            end
            local dx,dz = od.x-vd.x, od.z-vd.z
            local separation = math.sqrt(dx*dx+dz*dz)
            local headingDot = vd.dx*od.dx + vd.dz*od.dz
            local lateral = math.abs(dx*(-vd.dz)+dz*vd.dx)
            -- Release once the owner has genuinely turned away from the reserved
            -- pass, not merely because the pair is no longer exactly head-on.
            local ownerTurnDot = 1.0
            if state.ownerStartDx ~= nil then
                ownerTurnDot = od.dx*state.ownerStartDx + od.dz*state.ownerStartDz
            end
            local ownerMeaningfullyTurned = ownerTurnDot <= self.LANE_OWNER_TURN_RELEASE_DOT
            local ownerNoLongerApproaching = headingDot > -0.15
            local laneClear = separation >= (state.sideClearance + self.LANE_RELEASE_MARGIN)
                and (ownerMeaningfullyTurned or (ownerNoLongerApproaching and lateral >= state.sideClearance))
            local ownerTravel = 0
            if state.ownerStartX ~= nil then
                local otx, otz = od.x-state.ownerStartX, od.z-state.ownerStartZ
                ownerTravel = math.sqrt(otx*otx + otz*otz)
            end
            -- Some FS25 headland manoeuvres do not expose enough lateral motion
            -- for laneClear to become true. Reaching the far end of the pass and
            -- then slowing or starting a turn is an equally valid completion
            -- signal for the parked worker.
            -- For head-on backout, slowing near the parked worker is NOT proof
            -- that the owner completed the pass. Release only after a meaningful
            -- turn and genuine geometric clearance.
            local ownerReachedFarHeadland = false
            local stale = now-state.startedAt >= self.LANE_STALE_TIMEOUT_MS
            if state.phase == "BLOCKED_RECOVER" and laneClear then
                self.laneVacate[state.vacater] = nil
                self.laneOwnerHold[state.owner] = nil
                self.laneReservations[key] = nil
                shouldWait[state.owner] = nil
                shouldWait[state.vacater] = nil
                self:release(state.owner, "obstructed vacater cleared headland sweep")
                logInfo("HEAD-ON RECOVERY CLEAR: %s cleared under normal AI; %s resuming (sep %.1fm, lateral %.1fm)",
                    getName(state.vacater), getName(state.owner), separation, lateral)
            elseif state.phase == "PARKED" and (
                (state.mode == "HEAD_ON_BACKOUT"
                    and ownerMeaningfullyTurned
                    and separation >= (state.sideClearance + self.LANE_RELEASE_MARGIN))
                or (state.mode ~= "HEAD_ON_BACKOUT" and (laneClear or separation >= self.PARKED_ABSOLUTE_RELEASE))
            ) then
                self.laneOwnerHold[state.owner] = nil
                shouldWait[state.vacater] = nil
                if state.mode == "HEAD_ON_BACKOUT" then
                    -- Keep the boom folded and raised while moving the complete
                    -- vehicle back onto the field. Unfolding at the boundary can
                    -- swing the boom into trees or hedges now behind the sprayer.
                    self.headOnCompleted[key] = now + self.HEAD_ON_COMPLETED_COOLDOWN_MS
                    local node = getNode(state.vacater)
                    local vx, _, vz = getWorldTranslation(node)
                    local _, _, forwardZ = localDirectionToWorld(node, 0, 0, 1)
                    local forwardX, _, _ = localDirectionToWorld(node, 0, 0, 1)
                    local flen = math.sqrt(forwardX*forwardX + forwardZ*forwardZ)
                    if flen < 0.001 then
                        forwardX, forwardZ = vd.dx or 0, vd.dz or 1
                        flen = math.sqrt(forwardX*forwardX + forwardZ*forwardZ)
                    end
                    forwardX, forwardZ = forwardX/flen, forwardZ/flen
                    local reentryDistance = math.max(4.0, getVehicleLength(state.vacater))
                    state.phase = "REENTERING"
                    state.reentryDistance = reentryDistance
                    state.reentryTargetX = vx + forwardX*reentryDistance
                    state.reentryTargetZ = vz + forwardZ*reentryDistance
                    state.reentryStartedAt = now
                    self.laneVacate[state.vacater] = state
                    self:setParkedWorkState(state.vacater, true)
                    self:setBackoutRaisedState(state.vacater, true)
                    self:setParkedFoldState(state.vacater, true)
                    logInfo("HEAD-ON REENTRY: %s moving forward %.1fm folded/raised before AI handback",
                        getName(state.vacater), reentryDistance)
                else
                    self.laneVacate[state.vacater] = nil
                    self.laneReservations[key] = nil
                    self:setParkedFoldState(state.vacater, false)
                    self:setBackoutRaisedState(state.vacater, false)
                    self:setParkedWorkState(state.vacater, false)
                    self:release(state.vacater, "lane owner completed turn and cleared parked worker")
                    logInfo("LANE RELEASED: %s completed turn; %s resuming (sep %.1fm, lateral %.1fm)",
                        getName(state.owner), getName(state.vacater), separation, lateral)
                end
            elseif stale and state.phase ~= "MANUAL_HOLD" and state.phase ~= "BLOCKED_RECOVER"
                and state.mode ~= "HEAD_ON_BACKOUT" then
                -- Never swap ownership merely because a timer expired. The old
                -- behaviour released a still-conflicting pair and immediately
                -- recreated the reservation with reversed roles. Keep the
                -- original owner/vacater assignment frozen until real clearance
                -- exists or the player manually separates the machines.
                state.phase = "MANUAL_HOLD"
                self.laneVacate[state.vacater] = state
                self.laneOwnerHold[state.owner] = nil
                shouldWait[state.owner] = nil
                shouldWait[state.vacater] = state.owner
                logInfo("LANE OWNERSHIP HELD: %s remains owner; %s stopped awaiting physical clearance (sep %.1fm, lateral %.1fm)",
                    getName(state.owner), getName(state.vacater), separation, lateral)
                local text = string.format("%s still owns lane — manual clearance may be required", getName(state.owner))
                self:showTransient(text)
                self:broadcastState(true, text)
            end
        end
    end

    -- Same-direction rear queue override. The front helper must never remain
    -- stopped for a faster helper behind it, because the follower cannot pass
    -- and will simply rear-end it. Release the leader and queue the follower.
    local rearQueue = {}
    for i=1,#active-1 do
        for j=i+1,#active do
            local a,b = active[i],active[j]
            local follower,leader = getRearQueueRelation(a,b)
            if follower ~= nil and leader ~= nil then
                local fd,ld = byVehicle[follower],byVehicle[leader]
                -- A helper can change AI state between active-list collection and
                -- this pass. Skip the pair for this frame if either cached record
                -- has disappeared instead of indexing nil and breaking update().
                if fd ~= nil and ld ~= nil and fd.x ~= nil and fd.z ~= nil and ld.x ~= nil and ld.z ~= nil then
                    local dx,dz = ld.x-fd.x, ld.z-fd.z
                    local distance = math.sqrt(dx*dx+dz*dz)
                    local closing = (fd.speedKmh or 0) - (ld.speedKmh or 0)
                    local leaderWaiting = self.waiting[leader] ~= nil
                    local followerWaiting = self.waiting[follower] ~= nil
                    local _, _, _, _, pairConflictDistance, pairReleaseDistance = pairEnvelope(fd,ld)
                    local widePair = math.max(fd.workingWidth or 0, ld.workingWidth or 0) >= self.WIDE_IMPLEMENT_THRESHOLD
                    local wideBase = (fd.halfWidth or 3) + (ld.halfWidth or 3) + self.WIDE_REAR_EXTRA_MARGIN
                    local leaderTurning = (ld.turnFactor or 0) >= 0.10 or (ld.speedKmh or 0) < 5.0
                    local triggerDistance = (leaderWaiting or (ld.speedKmh or 0) < 1.0)
                        and math.max(self.REAR_RELEASE_DISTANCE, pairReleaseDistance)
                        or math.max(self.REAR_QUEUE_DISTANCE, pairConflictDistance)
                    if widePair then
                        -- Large booms need room for the leader to stop, turn and
                        -- reverse at the headland. Begin queuing much earlier than
                        -- an ordinary tractor and keep the extra buffer as soon as
                        -- the leader slows or starts changing heading.
                        triggerDistance = math.max(triggerDistance,
                            wideBase + (leaderTurning and self.WIDE_REAR_RELEASE_MARGIN or 0))
                    end
                    if distance <= triggerDistance and (widePair or closing >= self.REAR_MIN_CLOSING_KMH or leaderWaiting or followerWaiting) then
                        shouldWait[leader] = nil
                        shouldWait[follower] = leader
                        rearQueue[follower] = true
                        if leaderWaiting then
                            self:release(leader, "rear follower queued behind")
                        end
                    end
                end
            end
        end
    end

    -- Preserve a wide rear queue while the leader performs its headland turn.
    -- Once the leader rotates, the ordinary same-heading relation can disappear;
    -- without this persistence the generic crossing recovery may take over while
    -- the two boom envelopes are still only a few metres apart.
    for follower,state in pairs(self.waiting) do
        local leader = state.priorityVehicle
        local fd,ld = byVehicle[follower],byVehicle[leader]
        if fd ~= nil and ld ~= nil
            and math.max(fd.workingWidth or 0, ld.workingWidth or 0) >= self.WIDE_IMPLEMENT_THRESHOLD then
            local dx,dz = ld.x-fd.x, ld.z-fd.z
            local distance = math.sqrt(dx*dx+dz*dz)
            local safeRearDistance = (fd.halfWidth or 3) + (ld.halfWidth or 3)
                + self.WIDE_REAR_EXTRA_MARGIN + self.WIDE_REAR_RELEASE_MARGIN
            local followerToLeaderLong = dx*(fd.dx or 0) + dz*(fd.dz or 0)
            local closeWidePair = distance <= safeRearDistance
            local leaderAheadOrTurning = followerToLeaderLong > -8.0 or (ld.turnFactor or 0) >= 0.10
            if closeWidePair and leaderAheadOrTurning then
                shouldWait[leader] = nil
                shouldWait[follower] = leader
                rearQueue[follower] = true
            end
        end
    end

    -- Authoritative front-vehicle protection. The general width-aware graph
    -- must never make a leader yield to a helper that is physically behind it.
    -- This final pass uses the prospective yielder's own forward direction, so
    -- it still works when the follower is turning and the averaged-heading
    -- queue test above becomes ambiguous.
    for leader, follower in pairs(shouldWait) do
        local ld, fd = byVehicle[leader], byVehicle[follower]
        if ld ~= nil and fd ~= nil and ld.x ~= nil and ld.z ~= nil and fd.x ~= nil and fd.z ~= nil then
            local rx, rz = fd.x-ld.x, fd.z-ld.z
            local longitudinal = rx*(ld.dx or 0) + rz*(ld.dz or 0)
            local lateral = math.abs(rx*(-(ld.dz or 0)) + rz*(ld.dx or 0))
            local headingDot = (ld.dx or 0)*(fd.dx or 0) + (ld.dz or 0)*(fd.dz or 0)
            local laneLimit = math.max(self.REAR_LATERAL_LIMIT,
                math.min((ld.halfWidth or 3)+(fd.halfWidth or 3)+1.0, 12.0))

            -- Negative longitudinal means the selected priority vehicle is
            -- behind the prospective yielder. Keep the front vehicle moving
            -- and queue the rear vehicle instead. Allow a looser heading test
            -- when the leader is nearly stopped at a headland.
            local sameTrafficFlow = headingDot >= self.REAR_HEADING_DOT
                or ((ld.speedKmh or 0) < 1.0 and headingDot > 0.15)
            if longitudinal < -3.0 and lateral <= laneLimit and sameTrafficFlow then
                shouldWait[leader] = nil
                shouldWait[follower] = leader
                rearQueue[follower] = true
                if self.waiting[leader] ~= nil then
                    self:release(leader, "front vehicle protected from rear follower")
                end
                logInfo("REAR QUEUE OVERRIDE: %s held behind %s", getName(follower), getName(leader))
            end
        end
    end

    -- Post-release priority lock. Force the helper that was just released to
    -- keep right of way long enough to begin moving, and hold only the same
    -- opposing helper. This prevents RELEASE -> immediate YIELD oscillation.
    for vehicle,_ in pairs(self.aiStartAnchor) do
        if isDeleted(vehicle) or not activeSet[vehicle] then
            self.aiStartAnchor[vehicle] = nil
            self.passProgress[vehicle] = nil
        end
    end

    for vehicle,lock in pairs(self.releasePriority) do
        if isDeleted(vehicle) or lock == nil or lock.untilTime == nil or not activeSet[vehicle] then
            self.releasePriority[vehicle] = nil
        else
            local other = lock.other
            if other == nil or isDeleted(other) or not activeSet[other] then
                self.releasePriority[vehicle] = nil
            else
                local vd, od = byVehicle[vehicle], byVehicle[other]
                local travelled, separation = 0, 0
                if vd ~= nil then
                    local dx, dz = vd.x - (lock.startX or vd.x), vd.z - (lock.startZ or vd.z)
                    travelled = math.sqrt(dx*dx + dz*dz)
                end
                if vd ~= nil and od ~= nil then
                    local dx, dz = vd.x-od.x, vd.z-od.z
                    separation = math.sqrt(dx*dx + dz*dz)
                end

                local absolutelyClear = separation >= self.ABSOLUTE_CLEAR_DISTANCE
                local safelyClear = travelled >= self.RELEASE_PRIORITY_MIN_TRAVEL
                    and separation >= self.RELEASE_PRIORITY_MIN_SEPARATION
                local timedOut = now >= lock.untilTime

                if absolutelyClear or safelyClear or timedOut then
                    logInfo("RELEASE PRIORITY END: %s travelled %.1fm, separation %.1fm%s",
                        getName(vehicle), travelled, separation, timedOut and " (timeout)" or "")
                    self.releasePriority[vehicle] = nil
                else
                    shouldWait[vehicle] = nil
                    shouldWait[other] = vehicle
                end
            end
        end
    end

    -- Rear-queue traffic must never enter or remain in lane-clear recovery.
    -- If the pair is now recognised as leader/follower, cancel any active
    -- sideways manoeuvre before it can override the normal AI route.
    if self.recoveryVehicle ~= nil then
        local recoveryState = self.recovery[self.recoveryVehicle]
        if recoveryState ~= nil and (rearQueue[self.recoveryVehicle] or rearQueue[recoveryState.other]) then
            self:finishRecovery(self.recoveryVehicle, "rear queue override")
        end
    end

    -- Locked asymmetric recovery: one helper leaves the lane and parks,
    -- then the other passes before the parked helper resumes.
    self:updateRecovery(byVehicle, shouldWait)
    if self.recoveryVehicle == nil then
        for waiter,state in pairs(self.waiting) do
            local priority = state.priorityVehicle
            local wd, pd = byVehicle[waiter], byVehicle[priority]
            if wd ~= nil and pd ~= nil then
                local rx, rz = pd.x-wd.x, pd.z-wd.z
                local distance = math.sqrt(rx*rx + rz*rz)
                local headingDot = wd.dx*pd.dx + wd.dz*pd.dz
                local stopped = wd.speedKmh <= self.DEADLOCK_MAX_SPEED_KMH
                    and pd.speedKmh <= self.DEADLOCK_MAX_SPEED_KMH
                local headOn = headingDot <= self.HEAD_ON_DOT
                local crossing = math.abs(headingDot) <= self.CROSSING_DOT_MAX

                -- v2.0.1: the old fixed 25m deadlock radius was smaller than
                -- the valid conflict envelope of wide implements. A pair could
                -- therefore wait forever at 30-40m without ever qualifying for
                -- recovery. Scale the stalled radius from the pair envelope,
                -- but never apply it to same-direction queue traffic.
                local sideClearance, _, _, _, _, releaseDistance = pairEnvelope(wd, pd)
                local stalledRadius = math.min(releaseDistance,
                    math.max(self.DEADLOCK_DISTANCE, sideClearance + 8.0))
                local nonParallel = headingDot < self.PARALLEL_HEADING_DOT
                local longWait = now - (state.startedAt or now) >= 12000
                local isRearQueuePair = rearQueue[waiter] or rearQueue[priority]
                local laneOwnedPair = self.laneVacate[waiter] ~= nil or self.laneVacate[priority] ~= nil
                local wideHeadOn = headOn and math.max(wd.workingWidth or 0, pd.workingWidth or 0)
                    >= self.WIDE_IMPLEMENT_THRESHOLD

                -- Never command a sideways lane-clear turn for wide head-on
                -- implements. Once two long booms are close, turning one across
                -- the other is more dangerous than holding position. The early
                -- reservation rule above is responsible for preventing this state.
                local stalledConflict = stopped and nonParallel
                    and not isRearQueuePair
                    and not laneOwnedPair
                    and not wideHeadOn
                    and distance <= stalledRadius
                    and (headOn or crossing or longWait)
                if stalledConflict then
                    state.deadlockSince = state.deadlockSince or now
                    local detectMs = crossing and self.CROSSING_DETECT_MS or self.DEADLOCK_DETECT_MS
                    if now-state.deadlockSince >= detectMs then
                        if self:startRecovery(waiter, priority, wd, pd) then
                            shouldWait[waiter] = nil
                            shouldWait[priority] = waiter
                            if crossing then
                                logInfo("INTERSECTION RECOVERY: %s moving clear for %s (heading dot %.2f)", getName(waiter), getName(priority), headingDot)
                            end
                            break
                        end
                    end
                else
                    state.deadlockSince = nil
                end
            end
        end
    end

    -- Final authoritative head-on override. Other queue/recovery passes above
    -- must not release or reassign either member while a direct backout is
    -- active. During reverse both machines are held (the vacater is moved by
    -- the dedicated reverse driver); once parked, only the vacater remains held.
    for _,state in pairs(self.laneReservations) do
        if state.mode == "HEAD_ON_BACKOUT" then
            -- The vacater is directly controlled in reverse. The owner must be
            -- governed only by the protected-gap calculation above; do not
            -- unconditionally stop it here.
            headOnPriorityNoFold[state.owner] = true
            if state.phase == "REVERSING" then
                shouldWait[state.vacater] = nil
                -- Preserve shouldWait[state.owner] as calculated from the
                -- 55m/65m protected-gap hysteresis.
            elseif state.phase == "FOLDING_PARKED" then
                shouldWait[state.vacater] = state.owner
                shouldWait[state.owner] = nil
            else
                shouldWait[state.vacater] = state.owner
                shouldWait[state.owner] = nil
            end
        end
    end

    -- Apply only high-confidence course-timing holds. These are deliberately
    -- lightweight and never invoke passage assist, folding or recovery.
    self:applyCourseTrafficHolds(activeSet, shouldWait)

    -- Passage-assist owns post-encounter wide-implement yields.
    self:updatePassageAssist(activeSet, shouldWait)

    -- Absolute final authority gate. Nothing below or above may alter the pair
    -- commands once an encounter is active. This must run after every legacy
    -- override, including the old head-on block above.
    if self.applyEncounterAuthority ~= nil then
        self:applyEncounterAuthority(shouldWait)
    end

    for v,p in pairs(shouldWait) do
        local courseHold=self.coursePredictiveWanted and self.coursePredictiveWanted[v] or nil
        if courseHold~=nil then
            self:setCourseWaiting(v,p,courseHold.untilTime)
            if self.waiting[v]~=nil then self.waiting[v].courseConfidence=courseHold.confidenceScore or 0 end
        else
            self:setWaiting(v,p)
        end
    end

    -- Do not fold implements during an ordinary crossing or queue yield.
    -- Folding can interrupt the base-game AI work state and leave the helper
    -- seated but inactive after release. Folding is reserved for the dedicated
    -- blocked head-on backout path, where it is explicitly restored.

    local releases = {}
    for v,state in pairs(self.waiting) do
        if isDeleted(v) or not activeSet[v] then
            table.insert(releases,{v,"AI inactive"})
        elseif state.coursePredictive == true and now < (state.committedUntil or 0) then
            state.clearSince = nil
        elseif state.coursePredictive == true and now < (state.untilTime or 0)
            and (state.courseConfidence or 0)>=(self.COURSE_HOLD_RELEASE_CONFIDENCE or 0.45) then
            state.clearSince = nil
        elseif shouldWait[v] ~= nil then
            state.clearSince = nil
        elseif now-state.startedAt >= self.MIN_WAIT_MS then
            state.clearSince = state.clearSince or now
            if now-state.clearSince >= self.RELEASE_CONFIRM_MS then
                table.insert(releases,{v,"clearance confirmed"})
            end
        end
    end
    for _,r in ipairs(releases) do self:release(r[1],r[2]) end

    self.activeWaitCount, self.priorityName = 0, ""
    for _,state in pairs(self.waiting) do
        self.activeWaitCount = self.activeWaitCount + 1
        if self.priorityName == "" and state.priorityVehicle ~= nil then self.priorityName=getName(state.priorityVehicle) end
    end
    self:broadcastState(false, "")
end

function OuttaMyWay:update(dt)
    if self.Observer ~= nil and self.Observer.update ~= nil then
        self.Observer:update(dt)
    end
    if self.InteractionContexts ~= nil and self.InteractionContexts.update ~= nil then
        self.InteractionContexts:update(dt)
    end

    if self.ConflictPredictor ~= nil and self.ConflictPredictor.update ~= nil then
        self.ConflictPredictor:update(dt)
    end

    if self.ConflictEmergenceProbe ~= nil and self.ConflictEmergenceProbe.update ~= nil then
        self.ConflictEmergenceProbe:update(dt)
    end

    if self.ConflictConfidenceProbe ~= nil and self.ConflictConfidenceProbe.update ~= nil then
        self.ConflictConfidenceProbe:update(dt)
    end

    if self.OptionPreservationProbe ~= nil and self.OptionPreservationProbe.update ~= nil then
        self.OptionPreservationProbe:update(dt)
    end

    if self.ContinuationIntentProbe ~= nil and self.ContinuationIntentProbe.update ~= nil then
        self.ContinuationIntentProbe:update(dt)
    end

    if self.FieldWorldProbe ~= nil and self.FieldWorldProbe.update ~= nil then
        self.FieldWorldProbe:update(dt)
    end

    if self.PhysicalOccupancyProbe ~= nil and self.PhysicalOccupancyProbe.update ~= nil then
        self.PhysicalOccupancyProbe:update(dt)
    end

    if self.CollisionNodePoseProbe ~= nil and self.CollisionNodePoseProbe.update ~= nil then
        self.CollisionNodePoseProbe:update(dt)
    end

    if self.ShapeBoundProbe ~= nil and self.ShapeBoundProbe.update ~= nil then
        self.ShapeBoundProbe:update(dt)
    end

    if self.RuntimeGeometrySelectorProbe ~= nil and self.RuntimeGeometrySelectorProbe.update ~= nil then
        self.RuntimeGeometrySelectorProbe:update(dt)
    end

    if self.PhysicalAssemblyProbe ~= nil and self.PhysicalAssemblyProbe.update ~= nil then
        self.PhysicalAssemblyProbe:update(dt)
    end

    if self.DeclaredRouteEvaluationProbe ~= nil and self.DeclaredRouteEvaluationProbe.update ~= nil then
        self.DeclaredRouteEvaluationProbe:update(dt)
    end

    if self.AI_EXPLORER_ENABLED == true and self.AIFieldCourseExplorer ~= nil and self.AIFieldCourseExplorer.update ~= nil then
        self.AIFieldCourseExplorer:update(dt)
    end

    -- Observer-only mode is an execution boundary, not merely a diagnostic
    -- label. It must be evaluated before any decision or control consumer.
    if self.AI_EXPLORER_ONLY == true then return end

    if self.TRAFFIC_V2_ENABLED == true and self.TrafficManagerV2 ~= nil and self.TrafficManagerV2.update ~= nil then
        self.TrafficManagerV2:update(dt)
    end

    self.strandedWorkers = self.strandedWorkers or {}
    for vehicle,state in pairs(self.strandedWorkers) do
        if isDeleted(vehicle) then
            self.strandedWorkers[vehicle] = nil
        else
            local speedKmh = math.abs((vehicle.lastSpeedReal or 0) * 3600)
            if speedKmh >= 1.0 then
                self.strandedWorkers[vehicle] = nil
                self:setParkedFoldState(vehicle, false)
                self:setBackoutRaisedState(vehicle, false)
                self:setParkedWorkState(vehicle, false)
                logInfo("STRANDED WORKER RECOVERED: %s moving at %.1fkm/h; stranded state cleared", getName(vehicle), speedKmh)
            else
                self:setParkedWorkState(vehicle, true)
                self:setBackoutRaisedState(vehicle, true)
                self:setParkedFoldState(vehicle, true)
            end
        end
    end
    self:updateGiantsBoundaryProbes(dt)
    self:updateFullAIFieldWorkerRestarts()
    local now = g_time or 0
    for vehicle,verify in pairs(self.aiResumeVerify or {}) do
        if isDeleted(vehicle) then
            self.aiResumeVerify[vehicle] = nil
        elseif now-(verify.startedAt or now) >= self.AI_HANDOFF_VERIFY_MS then
            local node = getNode(vehicle)
            local x, _, z = getWorldTranslation(node)
            local moved = math.sqrt((x-(verify.startX or x))^2 + (z-(verify.startZ or z))^2)
            if moved >= 1.0 then
                logInfo("RECOVERY AI RESUMED: %s moved %.1fm after handback", getName(vehicle), moved)
                self.aiResumeVerify[vehicle] = nil
            elseif verify.passageAssist == true then
                logWarning("PASSAGE ASSIST AI RESUME UNCONFIRMED: %s remained stationary after 3m wake-up and AI handback; requesting full AI restart",
                    getName(vehicle))
                self.aiResumeVerify[vehicle] = nil
                self:requestFullAIFieldWorkerRestart(vehicle, "passage assist wake-up failed")
            elseif verify.retried ~= true then
                local fx, _, fz = localDirectionToWorld(node, 0, 0, 1)
                local flen = math.sqrt(fx*fx + fz*fz)
                if flen > 0.001 then fx, fz = fx/flen, fz/flen end
                local distance = self.AI_HANDOFF_RETRY_DISTANCE
                self.aiResumeAssist[vehicle] = {
                    targetX=x+fx*distance, targetZ=z+fz*distance, distance=distance, retried=true
                }
                self:setParkedWorkState(vehicle, true)
                self:setBackoutRaisedState(vehicle, true)
                self:setParkedFoldState(vehicle, true)
                self.aiResumeVerify[vehicle] = nil
                logInfo("RECOVERY AI RETRY: %s remained stationary; applying %.1fm forward handoff nudge",
                    getName(vehicle), distance)
            else
                logWarning("RECOVERY AI HANDOFF FAILED: %s remained stationary after retry; manual restart may be required",
                    getName(vehicle))
                self.aiResumeVerify[vehicle] = nil
            end
        end
    end
    self.elapsed = self.elapsed + dt
    self.debugElapsed = self.debugElapsed + dt
    if self.elapsed >= self.UPDATE_INTERVAL_MS then
        self.elapsed = self.elapsed % self.UPDATE_INTERVAL_MS
        self:updateConflicts()
        if self.updateReservationEngine ~= nil then self:updateReservationEngine() end
        if self.updateDecisionEngine ~= nil then self:updateDecisionEngine() end
    end
    if self.debugElapsed >= self.DEBUG_INTERVAL_MS then
        self.debugElapsed = 0
        if self.lastActiveCount > 0 and (self.isDebugEnabled == nil or self:isDebugEnabled("general")) then
            logInfo("Status: active=%d waiting=%d", self.lastActiveCount, self.activeWaitCount)
        end
    end
end

function OuttaMyWay:draw()
    if self.drawHud ~= nil then self:drawHud() end
end

function OuttaMyWay:deleteMap()
    self.waiting = {}
    self.aiRestartGrace = {}
    self.strandedWorkers = {}
    self.aiFullRestart = {}
    self.vehicleOrder = {}
    self.forcedPriorityUntil = {}
    self.recovery = {}
    self.recoveryVehicle = nil
    self.pairCooldown = {}
    self.releasePriority = {}
    self.laneVacate = {}
    self.laneOwnerHold = {}
    self.laneReservations = {}
    self.predictiveSpeedCaps = {}
    self.predictiveActions = {}
    self.headOnCompleted = {}
    self.trajectoryReservations = {}
    self.headOnEdgeLog = {}
    self.parkedFoldState = {}
    self.widthCache = {}
    self.headingHistory = {}
    self.passProgress = {}
    self.aiStartAnchor = {}
    self.giantsFieldBoundary = {}
    self.vectorDebugState = {}
    self.vectorPredictions = {}
    self.decisions = {}
    if self.ConflictEmergenceProbe ~= nil and self.ConflictEmergenceProbe.clear ~= nil then
        self.ConflictEmergenceProbe:clear()
    end
    if self.ConflictConfidenceProbe ~= nil and self.ConflictConfidenceProbe.clear ~= nil then
        self.ConflictConfidenceProbe:clear()
    end
    if self.OptionPreservationProbe ~= nil and self.OptionPreservationProbe.clear ~= nil then
        self.OptionPreservationProbe:clear()
    end
    if self.ContinuationIntentProbe ~= nil and self.ContinuationIntentProbe.clear ~= nil then
        self.ContinuationIntentProbe:clear()
    end
    if self.FieldWorldProbe ~= nil and self.FieldWorldProbe.clear ~= nil then
        self.FieldWorldProbe:clear()
    end
    if self.PhysicalOccupancyProbe ~= nil and self.PhysicalOccupancyProbe.clear ~= nil then
        self.PhysicalOccupancyProbe:clear()
    end
    if self.CollisionNodePoseProbe ~= nil and self.CollisionNodePoseProbe.clear ~= nil then
        self.CollisionNodePoseProbe:clear()
    end
    if self.ShapeBoundProbe ~= nil and self.ShapeBoundProbe.clear ~= nil then
        self.ShapeBoundProbe:clear()
    end
    if self.RuntimeGeometrySelectorProbe ~= nil and self.RuntimeGeometrySelectorProbe.clear ~= nil then
        self.RuntimeGeometrySelectorProbe:clear()
    end
    if self.PhysicalAssemblyProbe ~= nil and self.PhysicalAssemblyProbe.clear ~= nil then
        self.PhysicalAssemblyProbe:clear()
    end
    if self.DeclaredRouteEvaluationProbe ~= nil and self.DeclaredRouteEvaluationProbe.clear ~= nil then
        self.DeclaredRouteEvaluationProbe:clear()
    end
    if self.clearEncounterController ~= nil then self:clearEncounterController() end
end

addModEventListener(OuttaMyWay)
logInfo("HUD draw listener registered")
logInfo("Loaded v%s", OuttaMyWay.VERSION)
