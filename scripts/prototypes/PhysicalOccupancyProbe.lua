-- FS25_OuttaMyWay v4.6.8
-- Prototype 07: passive Physical Occupancy Evidence lifecycle and diagnostics.
-- Geometry discovery is isolated in PhysicalEnvelopeEvidence.lua. This module
-- never controls a vehicle and never substitutes working width for physical geometry.

OuttaMyWay.PhysicalOccupancyProbe = OuttaMyWay.PhysicalOccupancyProbe or {}
local Probe = OuttaMyWay.PhysicalOccupancyProbe
local Evidence = OuttaMyWay.PhysicalEnvelopeEvidence

local globalFunction = Evidence.globalFunction
local rootVehicle = Evidence.rootVehicle
local vehicleKey = Evidence.vehicleKey
local buildGeometry = Evidence.buildGeometry
local envelopeCorners = Evidence.envelopeCorners
local polygonClearance = Evidence.polygonClearance
local rootPosition = Evidence.rootPosition
local formatNumber = Evidence.formatNumber
function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_07_ENABLED == true
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.entities = {}
    self.lastHeartbeatMs = 0
    self.capabilitiesLogged = false
    if self.enabled then
        OuttaMyWay.Logger:info("PROTOTYPE07 ACTIVE: passive GIANTS geometry evidence and compound Physical Occupancy Envelope discovery; no containment or vehicle control")
    else
        OuttaMyWay.Logger:info("PROTOTYPE07 DISABLED")
    end
end

function Probe:logCapabilities()
    if self.capabilitiesLogged then return end
    self.capabilitiesLogged = true
    OuttaMyWay.Logger:obs(
        "PROTOTYPE07 ENGINE_CAPABILITIES getShapeBoundingBox=%s getBoundingBox=%s getWorldBoundingBox=%s getRigidBodyType=%s getCollisionMask=%s getNumOfChildren=%s getChildAt=%s interpretation=capability-inventory-not-proof",
        tostring(globalFunction("getShapeBoundingBox") ~= nil),
        tostring(globalFunction("getBoundingBox") ~= nil),
        tostring(globalFunction("getWorldBoundingBox") ~= nil),
        tostring(globalFunction("getRigidBodyType") ~= nil),
        tostring(globalFunction("getCollisionMask") ~= nil),
        tostring(globalFunction("getNumOfChildren") ~= nil),
        tostring(globalFunction("getChildAt") ~= nil))
end

function Probe:observeEntities(activeByVehicle, nowSeconds)
    local roots, seen = {}, {}
    local fieldMembers = OuttaMyWay.FieldWorldProbe ~= nil and OuttaMyWay.FieldWorldProbe.members or nil
    if type(fieldMembers) == "table" then
        for _, member in pairs(fieldMembers) do
            local root = rootVehicle(member.vehicle)
            if root ~= nil and root.isDeleted ~= true and not seen[root] then
                seen[root] = true
                roots[#roots+1] = root
            end
        end
    end

    local present = {}
    for _, vehicle in ipairs(roots) do
        local key = vehicleKey(vehicle)
        present[key] = true
        local previous = self.entities[key]
        local geometry = buildGeometry(vehicle, OuttaMyWay.PROTOTYPE_07_NODE_SCAN_BUDGET or 800,
            previous and previous.inventory or nil, g_time or 0)
        if geometry ~= nil then
            geometry.operational = activeByVehicle[vehicle] ~= nil
            geometry.lastSeen = nowSeconds
            local attached = previous == nil
            local changed = previous ~= nil and previous.signature ~= geometry.signature
            self.entities[key] = geometry
            if attached or changed then
                local e = geometry.envelope
                OuttaMyWay.Logger:val(
                    "PROTOTYPE07 ENTITY_GEOMETRY t=%.1fs entity=%s event=%s operationalMember=%s objects=%d candidateNodes=%d scannedNodes=%d scanTruncated=%s boundedNodes=%d physicsBoundNodes=%d boundedObjects=%d/%d confidence=%s coverage=%s frame=%s compoundWidth=%s compoundLength=%s localMinX=%s localMaxX=%s localMinZ=%s localMaxZ=%s sources=%s workingMarkerWidth=%s sizeMetadataWidth=%s sizeMetadataLength=%s authoritative=false action=none",
                    nowSeconds, geometry.name, attached and "ATTACHED" or "ENVELOPE_CHANGED",
                    tostring(geometry.operational), geometry.objectCount, geometry.nodeCount,
                    geometry.scannedNodes, tostring(geometry.truncated), geometry.boundedNodeCount,
                    geometry.physicsBoundCount, geometry.boundedObjectCount, geometry.objectCount,
                    geometry.confidence, geometry.coverage, geometry.frameStability,
                    formatNumber(e and e.width), formatNumber(e and e.length),
                    formatNumber(e and e.minX), formatNumber(e and e.maxX),
                    formatNumber(e and e.minZ), formatNumber(e and e.maxZ),
                    geometry.sourceSummary, formatNumber(geometry.workingMarkerWidth),
                    formatNumber(geometry.sizeMetadataWidth), formatNumber(geometry.sizeMetadataLength))
                if attached then
                    for _, sample in ipairs(geometry.evidenceSamples or {}) do
                        OuttaMyWay.Logger:obs(
                            "PROTOTYPE07 NODE_EVIDENCE t=%.1fs entity=%s node=%s role=%s source=%s physicsConfirmed=%s rigidBodyType=%s collisionMask=%s localWidth=%.2f localLength=%.2f frame=%s interpretation=discovered-evidence-not-semantic-proof",
                            nowSeconds, geometry.name, tostring(sample.nodeName), tostring(sample.role),
                            tostring(sample.source), tostring(sample.physicsConfirmed),
                            tostring(sample.rigidBodyType), tostring(sample.collisionMask),
                            sample.width or 0, sample.length or 0, tostring(sample.frame))
                    end
                end
                if changed then
                    OuttaMyWay.Logger:obs(
                        "PROTOTYPE07 ENVELOPE_CHANGED t=%.1fs entity=%s previousSignature=%s signature=%s previousConfidence=%s confidence=%s interpretation=configuration-or-evidence-change-not-motion action=none",
                        nowSeconds, geometry.name, tostring(previous.signature), tostring(geometry.signature),
                        tostring(previous.confidence), geometry.confidence)
                end
            end
        end
    end

    for key, state in pairs(self.entities) do
        if not present[key] then
            OuttaMyWay.Logger:obs(
                "PROTOTYPE07 ENTITY_GEOMETRY_REMOVED t=%.1fs entity=%s reason=no-longer-enumerated action=none",
                nowSeconds, tostring(state.name))
            self.entities[key] = nil
        end
    end
end

function Probe:observePairs(activeByVehicle, nowSeconds)
    local values = {}
    for key, geometry in pairs(self.entities) do
        if geometry.envelope ~= nil then values[#values+1] = {key=key,geometry=geometry} end
    end
    table.sort(values, function(a,b) return a.key < b.key end)
    local watch = OuttaMyWay.PROTOTYPE_07_PAIR_WATCH_DISTANCE_M or 150.0
    for i=1,#values-1 do
        for j=i+1,#values do
            local a, b = values[i].geometry, values[j].geometry
            if a.operational or b.operational then
                local ax, az = rootPosition(a.root)
                local bx, bz = rootPosition(b.root)
                if ax ~= nil and bx ~= nil then
                    local centreDistance = math.sqrt((bx-ax)^2 + (bz-az)^2)
                    if centreDistance <= watch then
                        local clearance, intersects = polygonClearance(envelopeCorners(a), envelopeCorners(b))
                        local pairKey = values[i].key .. "|" .. values[j].key
                        OuttaMyWay.Logger:rateLimited(
                            "p07-pair-" .. pairKey, OuttaMyWay.PROTOTYPE_07_PAIR_LOG_MS or 1000, "VAL",
                            "PROTOTYPE07 PAIR_GEOMETRY t=%.1fs entityA=%s confidenceA=%s entityB=%s confidenceB=%s centreDistance=%.2fm physicalEnvelopeClearance=%s physicalEnvelopeIntersect=%s workingMarkerWidthA=%s workingMarkerWidthB=%s basis=compound-discovered-envelope workingWidthSubstitution=false authoritative=false action=none",
                            nowSeconds, a.name, a.confidence, b.name, b.confidence, centreDistance,
                            formatNumber(clearance), tostring(intersects), formatNumber(a.workingMarkerWidth),
                            formatNumber(b.workingMarkerWidth))
                    end
                end
            end
        end
    end
end

function Probe:update(dt)
    if self.entities == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_07_INTERVAL_MS or 500
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    self:logCapabilities()
    local observer = OuttaMyWay.Observer
    local observed = observer ~= nil and observer.states or nil
    if type(observed) ~= "table" then return end
    local activeByVehicle = {}
    local nowSeconds = ((g_time or 0) - (self.startedAtMs or 0)) / 1000
    for vehicle, state in pairs(observed) do
        if state ~= nil and state.active == true then
            activeByVehicle[rootVehicle(vehicle)] = state
            nowSeconds = math.max(nowSeconds, state.timestamp or 0)
        end
    end

    self:observeEntities(activeByVehicle, nowSeconds)
    self:observePairs(activeByVehicle, nowSeconds)

    local nowMs = g_time or 0
    if nowMs - (self.lastHeartbeatMs or 0) >= (OuttaMyWay.PROTOTYPE_07_HEARTBEAT_MS or 15000) then
        self.lastHeartbeatMs = nowMs
        local count, known, physics = 0, 0, 0
        for _, geometry in pairs(self.entities) do
            count = count + 1
            if geometry.envelope ~= nil then known = known + 1 end
            if (geometry.physicsBoundCount or 0) > 0 then physics = physics + 1 end
        end
        OuttaMyWay.Logger:val(
            "PROTOTYPE07 HEARTBEAT t=%.1fs entities=%d envelopesDiscovered=%d entitiesWithPhysicsBoundEvidence=%d physicalAgronomicSeparation=true containment=not-evaluated projectedSweep=not-evaluated passive=true",
            nowSeconds, count, known, physics)
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.entities = {}
    self.lastHeartbeatMs = 0
    self.capabilitiesLogged = false
end
