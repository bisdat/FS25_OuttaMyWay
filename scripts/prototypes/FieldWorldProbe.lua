-- FS25_OuttaMyWay v4.6.6
-- Prototype 05: passive Field World observation independent of active AI membership.
-- This module never controls a vehicle. Current envelope geometry is a conservative
-- diagnostic approximation; it does not implement the accepted containment invariant.

OuttaMyWay.FieldWorldProbe = OuttaMyWay.FieldWorldProbe or {}
local Probe = OuttaMyWay.FieldWorldProbe

local function countTable(values)
    local count = 0
    for _ in pairs(values or {}) do count = count + 1 end
    return count
end

local function safeNumber(value, fallback)
    value = tonumber(value)
    if value == nil then return fallback end
    return value
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

local function positionAndHeading(object)
    local node = objectNode(object)
    if node == nil then return nil end
    local okPos, x, y, z = pcall(getWorldTranslation, node)
    if not okPos then return nil end
    local okDir, dx, _, dz = pcall(localDirectionToWorld, node, 0, 0, 1)
    if not okDir then dx, dz = 0, 1 end
    local length = math.sqrt(dx * dx + dz * dz)
    if length < 0.0001 then dx, dz = 0, 1 else dx, dz = dx / length, dz / length end
    return x, y, z, math.deg(math.atan2(dx, dz)), dx, dz
end

local function markerWidth(object)
    if object == nil or type(object.getAIMarkers) ~= "function" then return nil end
    local ok, left, right = pcall(object.getAIMarkers, object)
    if not ok or left == nil or right == nil or left == 0 or right == 0 then return nil end
    local okLeft, lx, _, lz = pcall(getWorldTranslation, left)
    local okRight, rx, _, rz = pcall(getWorldTranslation, right)
    if not okLeft or not okRight then return nil end
    local width = math.sqrt((rx-lx)^2 + (rz-lz)^2)
    if width < 0.5 or width > 100 then return nil end
    return width
end

local function componentGeometry(object)
    local node = objectNode(object)
    if node == nil then return nil end
    local width = safeNumber(object.sizeWidth, nil)
    local length = safeNumber(object.sizeLength, nil)
    local marker = markerWidth(object)
    if marker ~= nil and (width == nil or marker > width) then width = marker end
    if width == nil or width < 0.5 or width > 100 then width = 3.0 end
    if length == nil or length < 0.5 or length > 60 then length = 5.0 end
    return {object=object, node=node, width=width, length=length, markerWidth=marker}
end

local function collectComponents(vehicle)
    local output, visited = {}, {}
    local function scan(object)
        if object == nil or object.isDeleted == true or visited[object] then return end
        visited[object] = true
        local geometry = componentGeometry(object)
        if geometry ~= nil then output[#output+1] = geometry end
        if type(object.getAttachedImplements) == "function" then
            local ok, attached = pcall(object.getAttachedImplements, object)
            if ok and type(attached) == "table" then
                for _, entry in pairs(attached) do scan(entry.object or entry) end
            end
        end
    end
    scan(rootVehicle(vehicle))
    return output
end

local function componentCorners(component)
    local halfWidth = component.width * 0.5
    local halfLength = component.length * 0.5
    local localCorners = {
        {-halfWidth, -halfLength}, {halfWidth, -halfLength},
        {halfWidth, halfLength}, {-halfWidth, halfLength}
    }
    local corners = {}
    for _, corner in ipairs(localCorners) do
        local ok, x, _, z = pcall(localToWorld, component.node, corner[1], 0, corner[2])
        if ok then corners[#corners+1] = {x=x, z=z} end
    end
    return corners
end

local function pointInOrientedBox(component, x, z)
    local ok, lx, _, lz = pcall(worldToLocal, component.node, x, 0, z)
    if not ok then return false end
    return math.abs(lx) <= component.width * 0.5 and math.abs(lz) <= component.length * 0.5
end

local function orientation(ax, az, bx, bz, cx, cz)
    return (bx-ax)*(cz-az) - (bz-az)*(cx-ax)
end

local function segmentsIntersect(a, b, c, d)
    local o1 = orientation(a.x,a.z,b.x,b.z,c.x,c.z)
    local o2 = orientation(a.x,a.z,b.x,b.z,d.x,d.z)
    local o3 = orientation(c.x,c.z,d.x,d.z,a.x,a.z)
    local o4 = orientation(c.x,c.z,d.x,d.z,b.x,b.z)
    return ((o1 > 0 and o2 < 0) or (o1 < 0 and o2 > 0))
        and ((o3 > 0 and o4 < 0) or (o3 < 0 and o4 > 0))
end

local function componentIntersectsBoundary(component, boundary)
    local corners = componentCorners(component)
    if #corners ~= 4 then return false, false end
    local allInside = true
    for _, corner in ipairs(corners) do
        local inside = OuttaMyWay.FieldBoundary.pointInPolygon(boundary, corner.x, corner.z)
        if inside == true then return true, false end
        allInside = allInside and inside == true
    end
    for _, point in ipairs(boundary or {}) do
        local x, z = point.x or point[1], point.z or point[2] or point[3]
        if x ~= nil and z ~= nil and pointInOrientedBox(component, x, z) then return true, false end
    end
    for i=1,#corners do
        local a = corners[i]
        local b = corners[(i % #corners) + 1]
        for j=1,#boundary do
            local p = boundary[j]
            local q = boundary[(j % #boundary) + 1]
            local c = {x=p.x or p[1], z=p.z or p[2] or p[3]}
            local d = {x=q.x or q[1], z=q.z or q[2] or q[3]}
            if c.x ~= nil and c.z ~= nil and d.x ~= nil and d.z ~= nil and segmentsIntersect(a,b,c,d) then
                return true, false
            end
        end
    end
    return false, allInside
end

local function envelopeMembership(components, boundary)
    local anyInside, fullyContained = false, true
    local radius = 0
    local rootX, rootZ = nil, nil
    for index, component in ipairs(components) do
        local x, _, z = positionAndHeading(component.object)
        if index == 1 then rootX, rootZ = x, z end
        local corners = componentCorners(component)
        local componentContained = #corners == 4
        local componentIntersects = false
        for _, corner in ipairs(corners) do
            local inside = OuttaMyWay.FieldBoundary.pointInPolygon(boundary, corner.x, corner.z)
            componentContained = componentContained and inside == true
            componentIntersects = componentIntersects or inside == true
            if rootX ~= nil and rootZ ~= nil then
                radius = math.max(radius, math.sqrt((corner.x-rootX)^2 + (corner.z-rootZ)^2))
            end
        end
        if not componentIntersects then
            componentIntersects = select(1, componentIntersectsBoundary(component, boundary))
        end
        anyInside = anyInside or componentIntersects
        fullyContained = fullyContained and componentContained
    end
    return anyInside, fullyContained, math.max(radius, 2.0)
end

local function worldKey(boundary)
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    for _, point in ipairs(boundary or {}) do
        local x, z = point.x or point[1], point.z or point[2] or point[3]
        if x ~= nil and z ~= nil then
            minX, maxX = math.min(minX, x), math.max(maxX, x)
            minZ, maxZ = math.min(minZ, z), math.max(maxZ, z)
        end
    end
    if minX == math.huge then return "unknown-field-world" end
    return string.format("%d:%.1f:%.1f:%.1f:%.1f", #boundary, minX, maxX, minZ, maxZ)
end

local function vehicleControlClass(vehicle, operational)
    if operational then return "OPERATION_MEMBER" end
    for _, methodName in ipairs({"getIsControlled", "getIsEntered"}) do
        local method = vehicle ~= nil and vehicle[methodName] or nil
        if type(method) == "function" then
            local ok, value = pcall(method, vehicle)
            if ok and value == true then return "PLAYER_CONTROLLED" end
        end
    end
    return "NON_OPERATION_VEHICLE"
end

local function velocity(member)
    local speed = (member.speedKmh or 0) / 3.6
    local heading = math.rad(member.heading or 0)
    return math.sin(heading) * speed, math.cos(heading) * speed
end

local function closestApproach(a, b, horizon)
    local rx, rz = b.x-a.x, b.z-a.z
    local avx, avz = velocity(a)
    local bvx, bvz = velocity(b)
    local rvx, rvz = bvx-avx, bvz-avz
    local rv2 = rvx*rvx + rvz*rvz
    local distance = math.sqrt(rx*rx + rz*rz)
    local closing = distance > 0.01 and -((rx*rvx + rz*rvz) / distance) or 0
    local t = 0
    if rv2 > 0.0001 then t = math.max(0, math.min(horizon, -(rx*rvx + rz*rvz) / rv2)) end
    local cx, cz = rx + rvx*t, rz + rvz*t
    return distance, closing, t, math.sqrt(cx*cx + cz*cz)
end

function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_05_ENABLED == true
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.worlds = {}
    self.members = {}
    self.relevance = {}
    self.staticSignals = {}
    self.lastHeartbeatMs = 0
    if self.enabled then
        OuttaMyWay.Logger:info("PROTOTYPE05 ACTIVE: passive Field World vehicle observation; operational membership separated; no vehicle control")
    else
        OuttaMyWay.Logger:info("PROTOTYPE05 DISABLED")
    end
end

function Probe:ensureWorlds(activeStates, dt)
    if OuttaMyWay.giantsFieldBoundary == nil then OuttaMyWay.giantsFieldBoundary = {} end
    for _, state in ipairs(activeStates) do
        if OuttaMyWay.startGiantsBoundaryProbe ~= nil then
            OuttaMyWay:startGiantsBoundaryProbe({vehicle=state.vehicle,x=state.x,z=state.z})
        end
    end
    if OuttaMyWay.updateGiantsBoundaryProbes ~= nil then OuttaMyWay:updateGiantsBoundaryProbes(dt) end

    local seen = {}
    for _, state in ipairs(activeStates) do
        local boundaryState = OuttaMyWay.giantsFieldBoundary[state.vehicle]
        if boundaryState ~= nil and type(boundaryState.boundary) == "table" and #boundaryState.boundary >= 3 then
            local key = worldKey(boundaryState.boundary)
            seen[key] = true
            local world = self.worlds[key]
            if world == nil then
                world = {key=key,boundary=boundaryState.boundary,islands=boundaryState.islands or {},firstSeenMs=g_time or 0}
                self.worlds[key] = world
                OuttaMyWay.Logger:obs(
                    "PROTOTYPE05 FIELD_WORLD_DISCOVERED key=%s boundaryPoints=%d fieldIslands=%d definition=field-polygon staticIdentity=not-yet-complete",
                    key, #world.boundary, #(world.islands or {}))
            else
                world.boundary = boundaryState.boundary
                world.islands = boundaryState.islands or world.islands or {}
            end
            world.lastSeenMs = g_time or 0
        end
    end
    return seen
end

function Probe:observeMembers(activeByVehicle, nowSeconds)
    local observer = OuttaMyWay.Observer
    local entries = observer ~= nil and select(1, observer:enumerateVehicles()) or {}
    local roots, seen = {}, {}
    for _, entry in ipairs(entries or {}) do
        local root = rootVehicle(entry.vehicle)
        if root ~= nil and root.isDeleted ~= true and not seen[root] then
            seen[root] = true
            roots[#roots+1] = root
        end
    end

    local present = {}
    for _, vehicle in ipairs(roots) do
        local x, _, z, heading = positionAndHeading(vehicle)
        if x ~= nil and z ~= nil then
            local components = collectComponents(vehicle)
            local operationalState = activeByVehicle[vehicle]
            local operational = operationalState ~= nil
            for key, world in pairs(self.worlds) do
                local inside, contained, radius = envelopeMembership(components, world.boundary)
                local memberKey = key .. "|" .. vehicleKey(vehicle)
                if inside then
                    present[memberKey] = true
                    local previous = self.members[memberKey]
                    local previousOperational = previous ~= nil and previous.operational or nil
                    local previousClass = previous ~= nil and previous.controlClass or nil
                    local speed = math.abs((vehicle.lastSpeedReal or 0) * 3600)
                    local member = previous or {key=memberKey,worldKey=key,vehicle=vehicle,firstSeen=nowSeconds}
                    member.name = objectName(vehicle)
                    member.x, member.z, member.heading = x, z, heading
                    member.speedKmh = speed
                    member.radius = radius
                    member.fullyContained = contained
                    member.operational = operational
                    member.controlClass = vehicleControlClass(vehicle, operational)
                    member.componentCount = #components
                    member.lastSeen = nowSeconds
                    self.members[memberKey] = member
                    local attached = previous == nil
                    local membershipChanged = previous ~= nil and previousOperational ~= operational
                    local classChanged = previous ~= nil and previousClass ~= member.controlClass
                    if attached or membershipChanged or classChanged then
                        OuttaMyWay.Logger:obs(
                            "PROTOTYPE05 FIELD_WORLD_MEMBER t=%.1fs world=%s entity=%s class=%s operationalMember=%s components=%d currentEnvelopeContained=%s geometry=conservative-rectangle-v1 projectedSweep=not-evaluated event=%s",
                            nowSeconds, key, member.name, member.controlClass, tostring(operational),
                            member.componentCount, tostring(contained),
                            attached and "ATTACHED" or (membershipChanged and "OPERATIONAL_MEMBERSHIP_CHANGED" or "CONTROL_CLASS_CHANGED"))
                    end
                    if operational and contained == false then
                        OuttaMyWay.Logger:rateLimited(
                            "p05-containment-" .. memberKey, OuttaMyWay.PROTOTYPE_05_CONTAINMENT_LOG_MS or 3000,
                            "VAL",
                            "PROTOTYPE05 CONTAINMENT_BREACH_CANDIDATE t=%.1fs world=%s entity=%s geometry=conservative-rectangle-v1 invariant=full-envelope-must-remain-inside action=none",
                            nowSeconds, key, member.name)
                    end
                    if operationalState ~= nil and operationalState.staticCollision == true then
                        local signalKey = memberKey .. "|static"
                        if self.staticSignals[signalKey] ~= true then
                            self.staticSignals[signalKey] = true
                            OuttaMyWay.Logger:obs(
                                "PROTOTYPE05 STATIC_COLLISION_SIGNAL t=%.1fs world=%s operationMember=%s objectIdentity=unknown source=GIANTS-native-static-collision action=none",
                                nowSeconds, key, member.name)
                        end
                    end
                end
            end
        end
    end

    for key, member in pairs(self.members) do
        if not present[key] then
            OuttaMyWay.Logger:obs(
                "PROTOTYPE05 FIELD_WORLD_MEMBER_REMOVED t=%.1fs world=%s entity=%s lastClass=%s lastOperationalMember=%s reason=no-longer-intersects-field-world-or-not-enumerated",
                nowSeconds, tostring(member.worldKey), tostring(member.name), tostring(member.controlClass), tostring(member.operational))
            self.members[key] = nil
        end
    end
end

function Probe:observeRelevance(activeByVehicle, nowSeconds)
    local horizon = OuttaMyWay.PROTOTYPE_05_RELEVANCE_HORIZON_S or 45.0
    local margin = OuttaMyWay.PROTOTYPE_05_RELEVANCE_MARGIN_M or 5.0
    local current = {}
    for _, operationState in pairs(activeByVehicle) do
        local operationVehicle = rootVehicle(operationState.vehicle)
        for memberKey, member in pairs(self.members) do
            if member.vehicle ~= operationVehicle and member.worldKey ~= nil then
                local operationMemberKey = member.worldKey .. "|" .. vehicleKey(operationVehicle)
                local operationMember = self.members[operationMemberKey]
                if operationMember ~= nil then
                    local distance, closing, tcpa, dcpa = closestApproach(operationMember, member, horizon)
                    local clearance = (operationMember.radius or 2) + (member.radius or 2) + margin
                    local relevant = distance <= clearance
                        or (closing > 0.05 and tcpa <= horizon and dcpa <= clearance)
                        or ((operationState.blocked == true or operationState.staticCollision == true) and distance <= clearance + 25)
                    local relationKey = operationMemberKey .. "->" .. memberKey
                    current[relationKey] = relevant
                    local previous = self.relevance[relationKey]
                    if previous == nil or previous.relevant ~= relevant then
                        self.relevance[relationKey] = {relevant=relevant,lastSeen=nowSeconds}
                        OuttaMyWay.Logger:val(
                            "PROTOTYPE05 SITUATION_RELEVANCE t=%.1fs world=%s operationMember=%s worldMember=%s worldClass=%s worldOperationalMember=%s transition=%s distance=%.2fm closing=%.2fm/s tCPA=%.2fs dCPA=%.2fm envelopeClearance=%.2fm basis=constant-velocity-plus-envelope action=none",
                            nowSeconds, member.worldKey, operationMember.name, member.name, member.controlClass,
                            tostring(member.operational), relevant and "RELEVANT" or "NOT_RELEVANT",
                            distance, closing, tcpa, dcpa, clearance)
                    else
                        previous.lastSeen = nowSeconds
                    end
                end
            end
        end
    end

    for key, state in pairs(self.relevance) do
        if current[key] == nil and nowSeconds - (state.lastSeen or nowSeconds) > 2.0 then
            self.relevance[key] = nil
        end
    end
end

function Probe:update(dt)
    if self.members == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_05_INTERVAL_MS or 500
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local observer = OuttaMyWay.Observer
    local observed = observer ~= nil and observer.states or nil
    if type(observed) ~= "table" then return end
    local activeStates, activeByVehicle = {}, {}
    local nowSeconds = ((g_time or 0) - (self.startedAtMs or 0)) / 1000
    for vehicle, state in pairs(observed) do
        if state ~= nil and state.active == true and state.x ~= nil and state.z ~= nil then
            activeStates[#activeStates+1] = state
            activeByVehicle[rootVehicle(vehicle)] = state
            nowSeconds = math.max(nowSeconds, state.timestamp or 0)
        end
    end

    self:ensureWorlds(activeStates, dt)
    self:observeMembers(activeByVehicle, nowSeconds)
    self:observeRelevance(activeByVehicle, nowSeconds)

    local nowMs = g_time or 0
    if nowMs - (self.lastHeartbeatMs or 0) >= (OuttaMyWay.PROTOTYPE_05_HEARTBEAT_MS or 15000) then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE05 HEARTBEAT t=%.1fs activeOperationMembers=%d fieldWorlds=%d fieldWorldVehicleMembers=%d relevanceRelations=%d passive=true staticObservation=field-islands-plus-native-signal fullEnvelopeContainment=enforced-by-architecture-not-control",
            nowSeconds, #activeStates, countTable(self.worlds), countTable(self.members), countTable(self.relevance))
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.worlds = {}
    self.members = {}
    self.relevance = {}
    self.staticSignals = {}
    self.lastHeartbeatMs = 0
end
