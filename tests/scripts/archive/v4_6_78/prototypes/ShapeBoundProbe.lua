-- FS25_OuttaMyWay v4.6.15
-- Prototype 09: passive runtime shape-bound evidence.
-- Tests documented per-shape bounding-sphere APIs against Prototype 08's
-- source-bound collision identities and authoritative live node poses.
-- No Physical Occupancy Envelope, containment, sweep, Decision or Control.

OuttaMyWay.ShapeBoundProbe = OuttaMyWay.ShapeBoundProbe or {}
local Probe = OuttaMyWay.ShapeBoundProbe

local function globalFunction(name)
    local value = _G ~= nil and _G[name] or nil
    return type(value) == "function" and value or nil
end

local function finite(value)
    return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function validSphere(x, y, z, radius)
    local maxCentre = OuttaMyWay.PROTOTYPE_09_MAX_ABS_CENTRE_M or 10000.0
    local maxRadius = OuttaMyWay.PROTOTYPE_09_MAX_RADIUS_M or 500.0
    return finite(x) and finite(y) and finite(z) and finite(radius)
        and math.abs(x) <= maxCentre and math.abs(y) <= maxCentre and math.abs(z) <= maxCentre
        and radius > 0.0001 and radius <= maxRadius
end

local function compactError(value)
    if value == nil then return "none" end
    local text = string.gsub(tostring(value), "%s+", "_")
    if string.len(text) > 140 then text = string.sub(text, 1, 140) end
    return text
end

local function fmt(value)
    return finite(value) and string.format("%.6f", value) or "unknown"
end

local function boolText(value)
    if value == nil then return "unknown" end
    return tostring(value == true)
end

local function vectorDistance(a, b)
    if a == nil or b == nil then return nil end
    local dx, dy, dz = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

local function sphereDifference(a, b)
    if a == nil or b == nil then return nil, nil end
    return vectorDistance(a, b), math.abs(a.radius-b.radius)
end

local function transformCentre(node, sphere)
    if node == nil or node == 0 or sphere == nil or type(localToWorld) ~= "function" then return nil end
    local ok, x, y, z = pcall(localToWorld, node, sphere.x, sphere.y, sphere.z)
    if not ok or not finite(x) or not finite(y) or not finite(z) then return nil end
    return {x=x, y=y, z=z, radius=sphere.radius}
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

local function callGeometrySphere(fn, entityId, shapeId)
    if fn == nil then return {available=false, valid=false, error="function-unavailable"} end
    local ok, x, y, z, radius = pcall(fn, entityId, shapeId)
    if not ok then return {available=true, valid=false, error=compactError(x)} end
    local valid = validSphere(x, y, z, radius)
    local error = nil
    if not valid then error = "invalid-return" end
    return {
        available=true, valid=valid, x=x, y=y, z=z, radius=radius,
        error=error
    }
end

local function callShapeSphere(fn, entityId, shapeId)
    if fn == nil then return {available=false, valid=false, error="function-unavailable"} end
    local ok, x, y, z, radius, usesGeometry = pcall(fn, entityId, shapeId)
    if not ok then return {available=true, valid=false, error=compactError(x)} end
    local valid = validSphere(x, y, z, radius)
    local error = nil
    if not valid then error = "invalid-return" end
    return {
        available=true, valid=valid, x=x, y=y, z=z, radius=radius,
        usesGeometry=type(usesGeometry) == "boolean" and usesGeometry or nil,
        error=error
    }
end

local function callWorldSphere(fn, entityId, shapeId)
    if fn == nil then return {available=false, valid=false, error="function-unavailable"} end
    local ok, x, y, z, radius = pcall(fn, entityId, shapeId)
    if not ok then return {available=true, valid=false, error=compactError(x)} end
    local valid = validSphere(x, y, z, radius)
    local error = nil
    if not valid then error = "invalid-return" end
    return {
        available=true, valid=valid, x=x, y=y, z=z, radius=radius,
        error=error
    }
end

local function candidateDefinitions(vehicle, resolved, entry)
    return {
        {
            id="RUNTIME_NODE_ASSET_SHAPE_ID",
            entityId=resolved.node,
            shapeId=entry.shapeId,
            localFrame=resolved.node,
            sourceBound=true,
            preference=1
        },
        {
            id="VEHICLE_ROOT_ASSET_SHAPE_ID",
            entityId=vehicle.rootNode,
            shapeId=entry.shapeId,
            localFrame=vehicle.rootNode,
            sourceBound=true,
            preference=2
        },
        {
            id="VEHICLE_ROOT_ASSET_SHAPE_ID_NODE_FRAME",
            entityId=vehicle.rootNode,
            shapeId=entry.shapeId,
            localFrame=resolved.node,
            sourceBound=true,
            preference=3
        },
        {
            id="RUNTIME_NODE_SHAPE_ZERO",
            entityId=resolved.node,
            shapeId=0,
            localFrame=resolved.node,
            sourceBound=false,
            preference=4
        }
    }
end

local function measureCandidate(candidate, functions)
    local geometry = callGeometrySphere(functions.geometry, candidate.entityId, candidate.shapeId)
    local shape = callShapeSphere(functions.shape, candidate.entityId, candidate.shapeId)
    local world = callWorldSphere(functions.world, candidate.entityId, candidate.shapeId)
    local predictedWorld = shape.valid and transformCentre(candidate.localFrame, shape) or nil
    local shapeWorldCentreError, shapeWorldRadiusError = sphereDifference(predictedWorld, world.valid and world or nil)
    local geometryShapeCentreError, geometryShapeRadiusError = sphereDifference(
        geometry.valid and geometry or nil, shape.valid and shape or nil)
    return {
        candidate=candidate,
        geometry=geometry,
        shape=shape,
        world=world,
        predictedWorld=predictedWorld,
        shapeWorldCentreError=shapeWorldCentreError,
        shapeWorldRadiusError=shapeWorldRadiusError,
        geometryShapeCentreError=geometryShapeCentreError,
        geometryShapeRadiusError=geometryShapeRadiusError
    }
end

local function isCoherent(measurement)
    local tolerance = OuttaMyWay.PROTOTYPE_09_COHERENCE_TOLERANCE_M or 0.05
    return measurement.geometry.valid == true
        and measurement.shape.valid == true
        and measurement.world.valid == true
        and measurement.shapeWorldCentreError ~= nil
        and measurement.shapeWorldCentreError <= tolerance
        and measurement.shapeWorldRadiusError ~= nil
        and measurement.shapeWorldRadiusError <= tolerance
end

local function isSelectable(measurement)
    return measurement.candidate.sourceBound == true and isCoherent(measurement)
end

local function betterCandidate(candidate, current)
    if current == nil then return true end
    local candidateError = candidate.shapeWorldCentreError or math.huge
    local currentError = current.shapeWorldCentreError or math.huge
    if math.abs(candidateError-currentError) > 0.000001 then return candidateError < currentError end
    local candidateRadiusError = candidate.shapeWorldRadiusError or math.huge
    local currentRadiusError = current.shapeWorldRadiusError or math.huge
    if math.abs(candidateRadiusError-currentRadiusError) > 0.000001 then return candidateRadiusError < currentRadiusError end
    return (candidate.candidate.preference or 99) < (current.candidate.preference or 99)
end

local function measurementErrors(measurement)
    return table.concat({
        "geometry:" .. compactError(measurement.geometry.error),
        "shape:" .. compactError(measurement.shape.error),
        "world:" .. compactError(measurement.world.error)
    }, ",")
end

function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_09_ENABLED == true
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
    self.capabilitiesLogged = false
    self.functions = {
        geometry=globalFunction("getShapeGeometryBoundingSphere"),
        shape=globalFunction("getShapeBoundingSphere"),
        world=globalFunction("getShapeWorldBoundingSphere")
    }
    if self.enabled then
        OuttaMyWay.Logger:info("PROTOTYPE09 ACTIVE: runtime per-shape bounding-sphere evidence; consumes Prototype 08 collision identity/live pose; passive; no envelope, containment, sweep or control")
    else
        OuttaMyWay.Logger:info("PROTOTYPE09 DISABLED")
    end
end

function Probe:logCapabilities(nowSeconds)
    if self.capabilitiesLogged then return end
    self.capabilitiesLogged = true
    OuttaMyWay.Logger:val(
        "PROTOTYPE09 CAPABILITY t=%.1fs getShapeGeometryBoundingSphere=%s getShapeBoundingSphere=%s getShapeWorldBoundingSphere=%s documentedIdentity=entityId+shapeId invocationSemantics=under-test action=none",
        nowSeconds, tostring(self.functions.geometry ~= nil), tostring(self.functions.shape ~= nil),
        tostring(self.functions.world ~= nil))
end

function Probe:attach(sourceState, nowSeconds)
    local vehicle = sourceState.vehicle
    local state = {
        vehicle=vehicle,
        name=sourceState.name,
        sourceState=sourceState,
        nodes={},
        previousFoldState=nil,
        lastDetailedMs=0,
        maxShapeWorldCentreError=0,
        maxShapeWorldRadiusError=0,
        maxGeometryLocalDrift=0,
        maxGeometryRadiusDrift=0
    }
    self.states[tostring(vehicle)] = state

    OuttaMyWay.Logger:val(
        "PROTOTYPE09 ENTITY_ATTACHED t=%.1fs entity=%s geometryFamily=36m sourcePrototype=08 collisionNodesExpected=%d collisionNodesResolved=%d positiveControl=activePhysicalBoomShapes permanentChassisControl=not-catalogued renderControl=not-catalogued action=none",
        nowSeconds, state.name, #sourceState.catalogue.activeCollisionNodes, sourceState.resolvedCount or 0)

    for _, entry in ipairs(sourceState.catalogue.activeCollisionNodes) do
        local resolved = sourceState.resolved[entry.name]
        local nodeState = {entry=entry, resolved=resolved, candidates={}, selected=nil, baseline=nil, coherentDiagnosticRoutes=0}
        state.nodes[entry.name] = nodeState
        if resolved ~= nil then
            for _, candidate in ipairs(candidateDefinitions(vehicle, resolved, entry)) do
                local measurement = measureCandidate(candidate, self.functions)
                nodeState.candidates[#nodeState.candidates+1] = measurement
                OuttaMyWay.Logger:obs(
                    "PROTOTYPE09 INVOCATION_RESULT t=%.1fs entity=%s node=%s route=%s entityId=%s shapeId=%s sourceBound=%s geometryValid=%s shapeValid=%s worldValid=%s usesGeometry=%s shapeWorldCentreError=%s shapeWorldRadiusError=%s geometryShapeCentreError=%s geometryShapeRadiusError=%s coherent=%s selectable=%s errors=%s action=none",
                    nowSeconds, state.name, entry.name, candidate.id, tostring(candidate.entityId), tostring(candidate.shapeId), tostring(candidate.sourceBound == true),
                    tostring(measurement.geometry.valid), tostring(measurement.shape.valid), tostring(measurement.world.valid),
                    boolText(measurement.shape.usesGeometry), fmt(measurement.shapeWorldCentreError),
                    fmt(measurement.shapeWorldRadiusError), fmt(measurement.geometryShapeCentreError),
                    fmt(measurement.geometryShapeRadiusError), tostring(isCoherent(measurement)), tostring(isSelectable(measurement)), measurementErrors(measurement))
                if isCoherent(measurement) and candidate.sourceBound ~= true then
                    nodeState.coherentDiagnosticRoutes = nodeState.coherentDiagnosticRoutes + 1
                end
                if isSelectable(measurement) and betterCandidate(measurement, nodeState.selected) then
                    nodeState.selected = measurement
                end
            end
        end

        if nodeState.selected ~= nil then
            nodeState.baseline = {
                geometry=nodeState.selected.geometry,
                shape=nodeState.selected.shape
            }
            OuttaMyWay.Logger:val(
                "PROTOTYPE09 ROUTE_SELECTED t=%.1fs entity=%s node=%s route=%s assetShapeId=%s geometryLocalCentre=%.6f,%.6f,%.6f geometryRadius=%.6f shapeLocalCentre=%.6f,%.6f,%.6f shapeRadius=%.6f usesGeometry=%s initialWorldError=%.6f initialRadiusError=%.6f provenance=physical-compoundChild+configuration-catalogue action=none",
                nowSeconds, state.name, entry.name, nodeState.selected.candidate.id, tostring(entry.shapeId),
                nodeState.selected.geometry.x, nodeState.selected.geometry.y, nodeState.selected.geometry.z,
                nodeState.selected.geometry.radius, nodeState.selected.shape.x, nodeState.selected.shape.y,
                nodeState.selected.shape.z, nodeState.selected.shape.radius, boolText(nodeState.selected.shape.usesGeometry),
                nodeState.selected.shapeWorldCentreError or -1, nodeState.selected.shapeWorldRadiusError or -1)
        else
            OuttaMyWay.Logger:warning("REC",
                "PROTOTYPE09 NO_COHERENT_SOURCE_BOUND_ROUTE t=%.1fs entity=%s node=%s assetShapeId=%s testedRoutes=%d coherentDiagnosticRoutes=%d physicalExtent=unknown noUnderApproximation=true action=none",
                nowSeconds, state.name, entry.name, tostring(entry.shapeId), #nodeState.candidates, nodeState.coherentDiagnosticRoutes)
        end
    end
    return state
end

local function sampleNode(nodeState, functions)
    if nodeState.selected == nil then return nil end
    local current = measureCandidate(nodeState.selected.candidate, functions)
    local baseline = nodeState.baseline
    local geometryCentreDrift, geometryRadiusDrift = sphereDifference(
        current.geometry.valid and current.geometry or nil, baseline and baseline.geometry or nil)
    local shapeCentreDrift, shapeRadiusDrift = sphereDifference(
        current.shape.valid and current.shape or nil, baseline and baseline.shape or nil)
    current.geometryCentreDrift = geometryCentreDrift
    current.geometryRadiusDrift = geometryRadiusDrift
    current.shapeCentreDrift = shapeCentreDrift
    current.shapeRadiusDrift = shapeRadiusDrift
    return current
end

function Probe:sample(state, nowSeconds)
    local vehicle = state.vehicle
    local foldTime = foldAnimTime(vehicle)
    local currentFoldState = foldState(foldTime)
    local changed = state.previousFoldState ~= currentFoldState
    local selectedCount, validCount, usesGeometryCount = 0, 0, 0
    local samples = {}

    for _, entry in ipairs(state.sourceState.catalogue.activeCollisionNodes) do
        local nodeState = state.nodes[entry.name]
        if nodeState ~= nil and nodeState.selected ~= nil then
            selectedCount = selectedCount + 1
            local sample = sampleNode(nodeState, self.functions)
            samples[#samples+1] = {entry=entry, nodeState=nodeState, measurement=sample}
            if sample ~= nil and sample.geometry.valid and sample.shape.valid and sample.world.valid then
                validCount = validCount + 1
                if sample.shape.usesGeometry == true then usesGeometryCount = usesGeometryCount + 1 end
                state.maxShapeWorldCentreError = math.max(state.maxShapeWorldCentreError, sample.shapeWorldCentreError or 0)
                state.maxShapeWorldRadiusError = math.max(state.maxShapeWorldRadiusError, sample.shapeWorldRadiusError or 0)
                state.maxGeometryLocalDrift = math.max(state.maxGeometryLocalDrift, sample.geometryCentreDrift or 0)
                state.maxGeometryRadiusDrift = math.max(state.maxGeometryRadiusDrift, sample.geometryRadiusDrift or 0)
            end
        end
    end

    if changed then
        OuttaMyWay.Logger:obs(
            "PROTOTYPE09 FOLD_STATE_CHANGED t=%.1fs entity=%s previous=%s state=%s foldAnimTime=%s selectedRoutes=%d validSamples=%d action=none",
            nowSeconds, state.name, tostring(state.previousFoldState), currentFoldState, fmt(foldTime), selectedCount, validCount)
    end

    local summaryInterval = currentFoldState == "TRANSITION" and (OuttaMyWay.PROTOTYPE_09_TRANSITION_LOG_MS or 250)
        or (OuttaMyWay.PROTOTYPE_09_ENDPOINT_LOG_MS or 2000)
    OuttaMyWay.Logger:rateLimited("p09-summary-" .. tostring(vehicle), summaryInterval, "VAL",
        "PROTOTYPE09 SHAPE_BOUND_SAMPLE t=%.1fs entity=%s foldState=%s foldAnimTime=%s nodesExpected=%d routesSelected=%d validSamples=%d usesGeometryTrue=%d maxShapeWorldCentreError=%.6f maxShapeWorldRadiusError=%.6f maxGeometryLocalDrift=%.6f maxGeometryRadiusDrift=%.6f extentRepresentation=bounding-sphere physicalEnvelope=not-derived utility=not-evaluated action=none",
        nowSeconds, state.name, currentFoldState, fmt(foldTime), #state.sourceState.catalogue.activeCollisionNodes,
        selectedCount, validCount, usesGeometryCount, state.maxShapeWorldCentreError,
        state.maxShapeWorldRadiusError, state.maxGeometryLocalDrift, state.maxGeometryRadiusDrift)

    local nowMs = g_time or 0
    local detailInterval = currentFoldState == "TRANSITION" and (OuttaMyWay.PROTOTYPE_09_TRANSITION_DETAIL_MS or 1000)
        or (OuttaMyWay.PROTOTYPE_09_ENDPOINT_DETAIL_MS or 5000)
    if changed or nowMs - (state.lastDetailedMs or 0) >= detailInterval then
        state.lastDetailedMs = nowMs
        for _, sample in ipairs(samples) do
            local measurement = sample.measurement
            if measurement ~= nil then
                OuttaMyWay.Logger:obs(
                    "PROTOTYPE09 NODE_BOUND t=%.1fs entity=%s foldState=%s foldAnimTime=%s node=%s route=%s assetShapeId=%s geometryValid=%s geometryLocalCentre=%s,%s,%s geometryRadius=%s geometryCentreDrift=%s geometryRadiusDrift=%s shapeValid=%s shapeLocalCentre=%s,%s,%s shapeRadius=%s shapeCentreDrift=%s shapeRadiusDrift=%s usesGeometry=%s worldValid=%s worldCentre=%s,%s,%s worldRadius=%s predictedWorldCentre=%s,%s,%s shapeWorldCentreError=%s shapeWorldRadiusError=%s geometryShapeCentreError=%s geometryShapeRadiusError=%s provenance=physical-compoundChild+configuration-catalogue action=none",
                    nowSeconds, state.name, currentFoldState, fmt(foldTime), sample.entry.name,
                    sample.nodeState.selected.candidate.id, tostring(sample.entry.shapeId),
                    tostring(measurement.geometry.valid), fmt(measurement.geometry.x), fmt(measurement.geometry.y),
                    fmt(measurement.geometry.z), fmt(measurement.geometry.radius), fmt(measurement.geometryCentreDrift),
                    fmt(measurement.geometryRadiusDrift), tostring(measurement.shape.valid), fmt(measurement.shape.x),
                    fmt(measurement.shape.y), fmt(measurement.shape.z), fmt(measurement.shape.radius),
                    fmt(measurement.shapeCentreDrift), fmt(measurement.shapeRadiusDrift), boolText(measurement.shape.usesGeometry),
                    tostring(measurement.world.valid), fmt(measurement.world.x), fmt(measurement.world.y),
                    fmt(measurement.world.z), fmt(measurement.world.radius), fmt(measurement.predictedWorld and measurement.predictedWorld.x),
                    fmt(measurement.predictedWorld and measurement.predictedWorld.y), fmt(measurement.predictedWorld and measurement.predictedWorld.z),
                    fmt(measurement.shapeWorldCentreError), fmt(measurement.shapeWorldRadiusError),
                    fmt(measurement.geometryShapeCentreError), fmt(measurement.geometryShapeRadiusError))
            end
        end
    end

    state.previousFoldState = currentFoldState
end

function Probe:update(dt)
    if self.states == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_09_INTERVAL_MS or 100
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local nowSeconds = ((g_time or 0) - (self.startedAtMs or 0)) / 1000
    self:logCapabilities(nowSeconds)

    local sourceProbe = OuttaMyWay.CollisionNodePoseProbe
    local sourceStates = sourceProbe and sourceProbe.states or nil
    if type(sourceStates) ~= "table" then
        OuttaMyWay.Logger:rateLimited("p09-source-unavailable", OuttaMyWay.PROTOTYPE_09_SOURCE_WARNING_MS or 5000, "REC",
            "PROTOTYPE09 SOURCE_UNAVAILABLE t=%.1fs requiredPrototype=08 reason=no-source-states physicalExtent=unknown action=none",
            nowSeconds)
        return
    end

    local present = {}
    for key, sourceState in pairs(sourceStates) do
        local vehicle = sourceState.vehicle
        if vehicle ~= nil and vehicle.isDeleted ~= true and vehicle.rootNode ~= nil and vehicle.rootNode ~= 0 then
            present[key] = true
            local state = self.states[key] or self:attach(sourceState, nowSeconds)
            state.sourceState = sourceState
            self:sample(state, nowSeconds)
        end
    end

    for key, state in pairs(self.states) do
        if not present[key] then
            OuttaMyWay.Logger:obs("PROTOTYPE09 ENTITY_REMOVED t=%.1fs entity=%s reason=prototype08-source-removed action=none", nowSeconds, state.name)
            self.states[key] = nil
        end
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.startedAtMs = g_time or 0
    self.states = {}
    self.capabilitiesLogged = false
end
