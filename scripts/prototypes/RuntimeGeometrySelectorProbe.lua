-- FS25_OuttaMyWay v4.6.15
-- Prototype 11: passive runtime geometry-selector semantics.
-- Tests whether a resolved runtime Entity selects component geometry while the
-- second shapeId argument is invariant, selective, or merely validated.
-- No Physical Occupancy Envelope, containment, sweep, Decision or Control.

OuttaMyWay.RuntimeGeometrySelectorProbe = OuttaMyWay.RuntimeGeometrySelectorProbe or {}
local Probe = OuttaMyWay.RuntimeGeometrySelectorProbe

local function globalFunction(name)
    local value = _G ~= nil and _G[name] or nil
    return type(value) == "function" and value or nil
end

local function finite(value)
    return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function validSphere(x, y, z, radius)
    local maxCentre = OuttaMyWay.PROTOTYPE_11_MAX_ABS_CENTRE_M or 10000.0
    local maxRadius = OuttaMyWay.PROTOTYPE_11_MAX_RADIUS_M or 500.0
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

local function transformCentre(node, sphere)
    if node == nil or node == 0 or sphere == nil or type(localToWorld) ~= "function" then return nil end
    local ok, x, y, z = pcall(localToWorld, node, sphere.x, sphere.y, sphere.z)
    if not ok or not finite(x) or not finite(y) or not finite(z) then return nil end
    return {x=x, y=y, z=z, radius=sphere.radius}
end

local function distance(a, b)
    if a == nil or b == nil then return nil end
    local dx, dy, dz = a.x-b.x, a.y-b.y, a.z-b.z
    return math.sqrt(dx*dx + dy*dy + dz*dz)
end

local function sphereDifference(a, b)
    if a == nil or b == nil then return nil, nil end
    return distance(a, b), math.abs(a.radius-b.radius)
end

local function measure(functions, entityId, shapeId, localFrame)
    local geometry = callGeometrySphere(functions.geometry, entityId, shapeId)
    local shape = callShapeSphere(functions.shape, entityId, shapeId)
    local world = callWorldSphere(functions.world, entityId, shapeId)
    local predicted = shape.valid and transformCentre(localFrame, shape) or nil
    local worldCentreError, worldRadiusError = sphereDifference(predicted, world.valid and world or nil)
    local geometryShapeCentreError, geometryShapeRadiusError = sphereDifference(
        geometry.valid and geometry or nil, shape.valid and shape or nil)
    local tolerance = OuttaMyWay.PROTOTYPE_11_COHERENCE_TOLERANCE_M or 0.05
    local coherent = geometry.valid and shape.valid and world.valid
        and worldCentreError ~= nil and worldCentreError <= tolerance
        and worldRadiusError ~= nil and worldRadiusError <= tolerance
    return {
        geometry=geometry, shape=shape, world=world, predicted=predicted,
        worldCentreError=worldCentreError, worldRadiusError=worldRadiusError,
        geometryShapeCentreError=geometryShapeCentreError,
        geometryShapeRadiusError=geometryShapeRadiusError,
        coherent=coherent
    }
end

local function errors(measurement)
    return table.concat({
        "geometry:" .. compactError(measurement.geometry.error),
        "shape:" .. compactError(measurement.shape.error),
        "world:" .. compactError(measurement.world.error)
    }, ",")
end

local function sameSphere(a, b)
    if a == nil or b == nil or a.valid ~= true or b.valid ~= true then return nil end
    local centreError, radiusError = sphereDifference(a, b)
    local tolerance = OuttaMyWay.PROTOTYPE_11_IDENTITY_TOLERANCE_M or 0.0001
    return centreError ~= nil and radiusError ~= nil
        and centreError <= tolerance and radiusError <= tolerance
end

local function sameMeasurement(a, b)
    if a == nil or b == nil then return nil end
    local geometrySame = sameSphere(a.geometry, b.geometry)
    local shapeSame = sameSphere(a.shape, b.shape)
    local worldSame = sameSphere(a.world, b.world)
    if geometrySame == nil or shapeSame == nil or worldSame == nil then return nil end
    return geometrySame and shapeSame and worldSame
end

local function localSignature(measurement)
    if measurement == nil or measurement.geometry == nil or measurement.geometry.valid ~= true then return "invalid" end
    return string.format("%.4f:%.4f:%.4f:%.4f", measurement.geometry.x, measurement.geometry.y, measurement.geometry.z, measurement.geometry.radius)
end

local function worldSignature(measurement)
    if measurement == nil or measurement.world == nil or measurement.world.valid ~= true then return "invalid" end
    return string.format("%.4f:%.4f:%.4f:%.4f", measurement.world.x, measurement.world.y, measurement.world.z, measurement.world.radius)
end

local function countKeys(values)
    local count = 0
    for _ in pairs(values) do count = count + 1 end
    return count
end

local function argumentDefinitions(entry, siblingShapeId, invalidShapeId)
    return {
        {role="ZERO", shapeId=0},
        {role="OWN_ASSET", shapeId=entry.shapeId},
        {role="SIBLING_ASSET", shapeId=siblingShapeId},
        {role="INVALID_HIGH", shapeId=invalidShapeId}
    }
end

local function representativeNodes(sourceState)
    local wanted = {
        boom01ArmLeftCol01=true,
        boom01ArmLeftCol04=true,
        boom01ArmRightCol02=true,
        boom01ArmRightCol03=true
    }
    local result = {}
    for _, entry in ipairs(sourceState.catalogue.activeCollisionNodes or {}) do
        if wanted[entry.name] then result[#result+1] = entry end
    end
    return result
end

function Probe:init()
    self.enabled = OuttaMyWay.PROTOTYPE_11_ENABLED == true
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
        OuttaMyWay.Logger:info("PROTOTYPE11 ACTIVE: runtime geometry-selector semantics; resolved-node versus vehicle-root identity matrix; passive")
    else
        OuttaMyWay.Logger:info("PROTOTYPE11 DISABLED")
    end
end

function Probe:logCapabilities(nowSeconds)
    if self.capabilitiesLogged then return end
    self.capabilitiesLogged = true
    OuttaMyWay.Logger:val(
        "PROTOTYPE11 CAPABILITY t=%.1fs getShapeGeometryBoundingSphere=%s getShapeBoundingSphere=%s getShapeWorldBoundingSphere=%s question=which-argument-selects-geometry action=none",
        nowSeconds, tostring(self.functions.geometry ~= nil), tostring(self.functions.shape ~= nil), tostring(self.functions.world ~= nil))
end

function Probe:logSelectorResult(nowSeconds, state, entityRole, entry, entityId, argument, measurement, ownMeasurement)
    local sameAsOwn = ownMeasurement ~= nil and sameMeasurement(measurement, ownMeasurement) or nil
    local nodeLabel = entityRole == "VEHICLE_ROOT" and "vehicleRoot" or (entry and entry.name or "unknown")
    OuttaMyWay.Logger:obs(
        "PROTOTYPE11 SELECTOR_RESULT t=%.1fs entity=%s entityRole=%s node=%s entityId=%s argumentRole=%s shapeId=%s geometryValid=%s shapeValid=%s worldValid=%s usesGeometry=%s coherent=%s geometryLocalCentre=%s,%s,%s geometryRadius=%s worldCentre=%s,%s,%s worldRadius=%s sameAsOwn=%s worldCentreError=%s worldRadiusError=%s errors=%s action=none",
        nowSeconds, state.name, entityRole, nodeLabel, tostring(entityId), argument.role,
        tostring(argument.shapeId), tostring(measurement.geometry.valid), tostring(measurement.shape.valid),
        tostring(measurement.world.valid), boolText(measurement.shape.usesGeometry), tostring(measurement.coherent),
        fmt(measurement.geometry.x), fmt(measurement.geometry.y), fmt(measurement.geometry.z), fmt(measurement.geometry.radius),
        fmt(measurement.world.x), fmt(measurement.world.y), fmt(measurement.world.z), fmt(measurement.world.radius),
        boolText(sameAsOwn), fmt(measurement.worldCentreError), fmt(measurement.worldRadiusError), errors(measurement))
end

function Probe:measureEntityMatrix(nowSeconds, state, entityRole, entry, entityId, localFrame, siblingShapeId)
    local invalidShapeId = state.invalidShapeId
    local results = {}
    local ownMeasurement = nil
    for _, argument in ipairs(argumentDefinitions(entry, siblingShapeId, invalidShapeId)) do
        local measurement = measure(self.functions, entityId, argument.shapeId, localFrame)
        results[argument.role] = measurement
        if argument.role == "OWN_ASSET" then ownMeasurement = measurement end
    end
    for _, argument in ipairs(argumentDefinitions(entry, siblingShapeId, invalidShapeId)) do
        self:logSelectorResult(nowSeconds, state, entityRole, entry, entityId, argument, results[argument.role], ownMeasurement)
    end

    local validCount = 0
    local localSignatures = {}
    local worldSignatures = {}
    for _, measurement in pairs(results) do
        if measurement.coherent then
            validCount = validCount + 1
            localSignatures[localSignature(measurement)] = true
            worldSignatures[worldSignature(measurement)] = true
        end
    end
    local ownVsZero = sameMeasurement(results.OWN_ASSET, results.ZERO)
    local ownVsSibling = sameMeasurement(results.OWN_ASSET, results.SIBLING_ASSET)
    local ownVsInvalid = sameMeasurement(results.OWN_ASSET, results.INVALID_HIGH)
    local knownArgumentInvariant = ownVsZero == true and ownVsSibling == true

    local nodeLabel = entityRole == "VEHICLE_ROOT" and "vehicleRoot" or (entry and entry.name or "unknown")
    OuttaMyWay.Logger:val(
        "PROTOTYPE11 ENTITY_SELECTOR_SUMMARY t=%.1fs entity=%s entityRole=%s node=%s entityId=%s ownShapeId=%s siblingShapeId=%s invalidShapeId=%s validArguments=%d distinctLocalSignatures=%d distinctWorldSignatures=%d ownVsZeroSame=%s ownVsSiblingSame=%s ownVsInvalidSame=%s zeroOwnSiblingInvariant=%s selectorInference=%s action=none",
        nowSeconds, state.name, entityRole, nodeLabel, tostring(entityId), tostring(entry.shapeId),
        tostring(siblingShapeId), tostring(invalidShapeId), validCount, countKeys(localSignatures), countKeys(worldSignatures),
        boolText(ownVsZero), boolText(ownVsSibling), boolText(ownVsInvalid), tostring(knownArgumentInvariant),
        knownArgumentInvariant and "first-argument-dominant-among-known-shapeIds" or "unresolved")

    return {
        results=results,
        knownArgumentInvariant=knownArgumentInvariant,
        validCount=validCount,
        distinctLocal=countKeys(localSignatures),
        distinctWorld=countKeys(worldSignatures)
    }
end

function Probe:attach(sourceState, nowSeconds)
    local vehicle = sourceState.vehicle
    local catalogue = sourceState.catalogue
    local maximum = catalogue.maximumCataloguedShapeId or 0
    for _, entry in ipairs(catalogue.activeCollisionNodes or {}) do maximum = math.max(maximum, tonumber(entry.shapeId) or 0) end
    local state = {
        vehicle=vehicle,
        name=sourceState.name,
        sourceState=sourceState,
        previousFoldState=nil,
        lastLifecycleMs=0,
        invalidShapeId=maximum + (OuttaMyWay.PROTOTYPE_11_INVALID_SHAPE_OFFSET or 1000),
        nodeMatrices={},
        rootMatrix=nil
    }
    self.states[tostring(vehicle)] = state

    local localSignatures = {}
    local worldSignatures = {}
    local invariantNodes = 0
    local testedNodes = 0
    local entries = catalogue.activeCollisionNodes or {}
    for index, entry in ipairs(entries) do
        local resolved = sourceState.resolved and sourceState.resolved[entry.name] or nil
        local sibling = entries[(index % #entries) + 1]
        if resolved ~= nil and sibling ~= nil then
            testedNodes = testedNodes + 1
            local matrix = self:measureEntityMatrix(nowSeconds, state, "RESOLVED_COLLISION_NODE", entry, resolved.node, resolved.node, sibling.shapeId)
            state.nodeMatrices[entry.name] = matrix
            if matrix.knownArgumentInvariant then invariantNodes = invariantNodes + 1 end
            local own = matrix.results.OWN_ASSET
            if own ~= nil and own.coherent then
                localSignatures[localSignature(own)] = true
                worldSignatures[worldSignature(own)] = true
            end
        end
    end

    if #entries > 1 then
        state.rootMatrix = self:measureEntityMatrix(nowSeconds, state, "VEHICLE_ROOT", entries[1], vehicle.rootNode, vehicle.rootNode, entries[2].shapeId)
    end

    local distinctLocal = countKeys(localSignatures)
    local distinctWorld = countKeys(worldSignatures)
    local entityDifferentiation = distinctLocal >= 2 and distinctWorld >= 2
    local rootAliasing = state.rootMatrix ~= nil and state.rootMatrix.knownArgumentInvariant == true
    local supported = testedNodes > 0 and invariantNodes == testedNodes and entityDifferentiation and rootAliasing
    local result = supported and "SUPPORTED" or ((invariantNodes > 0 or entityDifferentiation) and "PARTIAL" or "UNSUPPORTED")

    OuttaMyWay.Logger:val(
        "PROTOTYPE11 HYPOTHESIS_SUMMARY t=%.1fs entity=%s testedResolvedNodes=%d invariantResolvedNodes=%d distinctResolvedLocalSignatures=%d distinctResolvedWorldSignatures=%d entityDifferentiation=%s rootZeroOwnSiblingAliasing=%s invalidArgumentRequired=false result=%s interpretation=%s action=none",
        nowSeconds, state.name, testedNodes, invariantNodes, distinctLocal, distinctWorld, tostring(entityDifferentiation),
        tostring(rootAliasing), result, supported and "runtime-entity-geometry-authority-supported" or "selector-semantics-remain-partial")

    return state
end

function Probe:lifecycleCheck(state, nowSeconds)
    local foldTime = foldAnimTime(state.vehicle)
    local currentFoldState = foldState(foldTime)
    local changed = currentFoldState ~= state.previousFoldState
    local representative = representativeNodes(state.sourceState)
    local tested, invariant, distinctWorld = 0, 0, {}

    for index, entry in ipairs(representative) do
        local resolved = state.sourceState.resolved and state.sourceState.resolved[entry.name] or nil
        local sibling = representative[(index % #representative) + 1]
        if resolved ~= nil and sibling ~= nil then
            tested = tested + 1
            local own = measure(self.functions, resolved.node, entry.shapeId, resolved.node)
            local zero = measure(self.functions, resolved.node, 0, resolved.node)
            local siblingResult = measure(self.functions, resolved.node, sibling.shapeId, resolved.node)
            local ownZeroSame = sameMeasurement(own, zero)
            local ownSiblingSame = sameMeasurement(own, siblingResult)
            if ownZeroSame == true and ownSiblingSame == true then invariant = invariant + 1 end
            if own.coherent then distinctWorld[worldSignature(own)] = true end
            if changed then
                OuttaMyWay.Logger:obs(
                    "PROTOTYPE11 LIFECYCLE_NODE_CHECK t=%.1fs entity=%s foldState=%s foldAnimTime=%s node=%s ownShapeId=%s siblingShapeId=%s ownVsZeroSame=%s ownVsSiblingSame=%s ownWorldCentre=%s,%s,%s ownWorldRadius=%s action=none",
                    nowSeconds, state.name, currentFoldState, fmt(foldTime), entry.name, tostring(entry.shapeId), tostring(sibling.shapeId),
                    boolText(ownZeroSame), boolText(ownSiblingSame), fmt(own.world.x), fmt(own.world.y), fmt(own.world.z), fmt(own.world.radius))
            end
        end
    end

    if changed then
        OuttaMyWay.Logger:val(
            "PROTOTYPE11 FOLD_STATE_CHANGED t=%.1fs entity=%s previous=%s state=%s foldAnimTime=%s representativeNodes=%d invariantNodes=%d distinctWorldSignatures=%d selectorStable=%s action=none",
            nowSeconds, state.name, tostring(state.previousFoldState), currentFoldState, fmt(foldTime), tested, invariant,
            countKeys(distinctWorld), tostring(tested > 0 and invariant == tested))
    end

    local interval = currentFoldState == "TRANSITION" and (OuttaMyWay.PROTOTYPE_11_TRANSITION_LOG_MS or 1000)
        or (OuttaMyWay.PROTOTYPE_11_ENDPOINT_LOG_MS or 4000)
    OuttaMyWay.Logger:rateLimited("p11-lifecycle-" .. tostring(state.vehicle), interval, "VAL",
        "PROTOTYPE11 LIFECYCLE_SUMMARY t=%.1fs entity=%s foldState=%s foldAnimTime=%s representativeNodes=%d invariantNodes=%d distinctWorldSignatures=%d selectorStable=%s physicalEnvelope=false action=none",
        nowSeconds, state.name, currentFoldState, fmt(foldTime), tested, invariant, countKeys(distinctWorld),
        tostring(tested > 0 and invariant == tested))

    state.previousFoldState = currentFoldState
end

function Probe:update(dt)
    if self.states == nil then self:init() end
    if self.enabled ~= true then return end
    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_11_INTERVAL_MS or 250
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local nowSeconds = ((g_time or 0) - (self.startedAtMs or 0)) / 1000
    self:logCapabilities(nowSeconds)

    local sourceProbe = OuttaMyWay.CollisionNodePoseProbe
    local sourceStates = sourceProbe and sourceProbe.states or nil
    if type(sourceStates) ~= "table" then
        OuttaMyWay.Logger:rateLimited("p11-source-unavailable", OuttaMyWay.PROTOTYPE_11_SOURCE_WARNING_MS or 5000, "REC",
            "PROTOTYPE11 SOURCE_UNAVAILABLE t=%.1fs requiredPrototype=08 reason=no-resolved-runtime-nodes action=none", nowSeconds)
        return
    end

    local present = {}
    for key, sourceState in pairs(sourceStates) do
        local vehicle = sourceState.vehicle
        if vehicle ~= nil and vehicle.isDeleted ~= true and vehicle.rootNode ~= nil and vehicle.rootNode ~= 0 then
            present[key] = true
            local state = self.states[key] or self:attach(sourceState, nowSeconds)
            state.sourceState = sourceState
            self:lifecycleCheck(state, nowSeconds)
        end
    end

    for key, state in pairs(self.states) do
        if not present[key] then
            OuttaMyWay.Logger:obs("PROTOTYPE11 ENTITY_REMOVED t=%.1fs entity=%s reason=prototype08-source-removed action=none", nowSeconds, state.name)
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
