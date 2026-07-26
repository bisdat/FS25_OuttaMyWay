-- FS25_OuttaMyWay v4.6.20
-- Prototype 13A common candidate evaluator. Route type never grants authority;
-- every candidate is judged through the same identity/geometry/pose evidence.

OuttaMyWay.Prototype13Evaluator = OuttaMyWay.Prototype13Evaluator or {}
local Evaluator = OuttaMyWay.Prototype13Evaluator

local function globalFunction(name)
    local value = _G ~= nil and _G[name] or nil
    return type(value) == "function" and value or nil
end

local function finite(value)
    return type(value) == "number" and value == value and value ~= math.huge and value ~= -math.huge
end

local function validSphere(x, y, z, radius)
    local maxCentre = OuttaMyWay.PROTOTYPE_13_MAX_ABS_CENTRE_M or 10000.0
    local maxRadius = OuttaMyWay.PROTOTYPE_13_MAX_RADIUS_M or 500.0
    return finite(x) and finite(y) and finite(z) and finite(radius)
        and math.abs(x) <= maxCentre and math.abs(y) <= maxCentre and math.abs(z) <= maxCentre
        and radius > 0.0001 and radius <= maxRadius
end

local function sphere(fn, node, shapeId, includeUsesGeometry)
    if fn == nil then return {available=false, valid=false, error="function-unavailable"} end
    local ok, x, y, z, radius, usesGeometry = pcall(fn, node, shapeId or 0)
    if not ok then return {available=true, valid=false, error=tostring(x)} end
    return {
        available=true,
        valid=validSphere(x, y, z, radius),
        x=x, y=y, z=z, radius=radius,
        usesGeometry=includeUsesGeometry and type(usesGeometry) == "boolean" and usesGeometry or nil,
        error=validSphere(x, y, z, radius) and nil or "invalid-return"
    }
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

local function worldCentre(node, localSphere)
    if node == nil or localSphere == nil or type(localToWorld) ~= "function" then return nil end
    local ok, x, y, z = pcall(localToWorld, node, localSphere.x, localSphere.y, localSphere.z)
    if not ok or not finite(x) or not finite(y) or not finite(z) then return nil end
    return {x=x, y=y, z=z, radius=localSphere.radius}
end

local function runtimeName(node)
    local fn = globalFunction("getName")
    if fn == nil or node == nil then return nil end
    local ok, value = pcall(fn, node)
    if ok and value ~= nil then return tostring(value) end
    return nil
end

local function parentNode(node)
    local fn = globalFunction("getParent")
    if fn == nil or node == nil then return nil end
    local ok, value = pcall(fn, node)
    if ok and type(value) == "number" and value ~= 0 then return value end
    return nil
end

local function componentRoots(object)
    local result = {}
    if object ~= nil and type(object.components) == "table" then
        for index, component in ipairs(object.components) do
            local node = OuttaMyWay.Prototype13Resolver.asNode(component)
            if node ~= nil then result[#result+1] = {index=index, node=node} end
        end
    end
    if #result == 0 and object ~= nil and type(object.rootNode) == "number" and object.rootNode ~= 0 then
        result[1] = {index=1, node=object.rootNode}
    end
    return result
end

local function containingComponent(object, node)
    if node == nil then return nil end
    local roots = componentRoots(object)
    local rootByNode = {}
    for _, item in ipairs(roots) do rootByNode[item.node] = item.index end
    local current, guard = node, 0
    while current ~= nil and current ~= 0 and guard < 4096 do
        if rootByNode[current] ~= nil then return rootByNode[current] end
        current = parentNode(current)
        guard = guard + 1
    end
    return nil
end

local function pose(node)
    if node == nil or type(getWorldTranslation) ~= "function" or type(getWorldRotation) ~= "function" then
        return {valid=false}
    end
    local okP, x, y, z = pcall(getWorldTranslation, node)
    local okR, rx, ry, rz = pcall(getWorldRotation, node)
    local valid = okP and okR and finite(x) and finite(y) and finite(z) and finite(rx) and finite(ry) and finite(rz)
    return {valid=valid, x=x, y=y, z=z, rx=rx, ry=ry, rz=rz}
end

local function rootWorldSphere(object, functions)
    local node = object and object.rootNode or nil
    return sphere(functions.world, node, 0, false)
end

function Evaluator:init()
    self.functions = {
        geometry=globalFunction("getShapeGeometryBoundingSphere"),
        shape=globalFunction("getShapeBoundingSphere"),
        world=globalFunction("getShapeWorldBoundingSphere")
    }
end

function Evaluator:evaluateCandidate(object, shape, candidate)
    if self.functions == nil then self:init() end
    local result = candidate
    result.runtimeName = runtimeName(candidate.node)
    result.actualComponentIndex = containingComponent(object, candidate.node)
    result.nodeExists = candidate.node ~= nil and candidate.node ~= 0
    result.ownership = result.actualComponentIndex ~= nil and "PASS" or "FAIL"
    result.componentCoherence = result.actualComponentIndex == shape.expectedComponentIndex and "PASS" or "FAIL"
    if result.runtimeName == nil then
        result.nameCoherence = "NOT_OBSERVABLE"
    else
        result.nameCoherence = result.runtimeName == shape.expectedRuntimeName and "PASS" or "FAIL"
    end

    result.pose = pose(candidate.node)
    result.poseValidity = result.pose.valid and "PASS" or "FAIL"
    result.geometry = sphere(self.functions.geometry, candidate.node, 0, false)
    result.shape = sphere(self.functions.shape, candidate.node, 0, true)
    result.world = sphere(self.functions.world, candidate.node, 0, false)
    local predicted = result.shape.valid and worldCentre(candidate.node, result.shape) or nil
    result.worldCentreError, result.worldRadiusError = sphereDifference(predicted, result.world.valid and result.world or nil)
    local tolerance = OuttaMyWay.PROTOTYPE_13_COHERENCE_TOLERANCE_M or 0.05
    result.geometryAuthority = result.geometry.valid and result.shape.valid and result.world.valid
        and result.worldCentreError ~= nil and result.worldCentreError <= tolerance
        and result.worldRadiusError ~= nil and result.worldRadiusError <= tolerance
        and "PASS" or "FAIL"

    local rootSphere = rootWorldSphere(object, self.functions)
    local aliasCentre, aliasRadius = sphereDifference(result.world.valid and result.world or nil, rootSphere.valid and rootSphere or nil)
    local aliasTolerance = OuttaMyWay.PROTOTYPE_13_ALIAS_TOLERANCE_M or 0.0001
    result.rootAlias = aliasCentre ~= nil and aliasRadius ~= nil
        and aliasCentre <= aliasTolerance and aliasRadius <= aliasTolerance
    result.aliasCheck = result.rootAlias and "FAIL" or (result.world.valid and rootSphere.valid and "PASS" or "NOT_OBSERVABLE")

    result.overallPass = result.nodeExists
        and result.ownership == "PASS"
        and result.componentCoherence == "PASS"
        and result.nameCoherence ~= "FAIL"
        and result.geometryAuthority == "PASS"
        and result.poseValidity == "PASS"
        and result.aliasCheck == "PASS"
    return result
end

function Evaluator:evaluateShape(object, shape, candidates)
    local realCandidates = {}
    local controlCandidates = {}
    for _, candidate in ipairs(candidates) do
        local evaluated = self:evaluateCandidate(object, shape, candidate)
        if evaluated.control then controlCandidates[#controlCandidates+1] = evaluated
        else realCandidates[#realCandidates+1] = evaluated end
    end

    local validByHandle, validRoutes = {}, 0
    local anyNode, anyAlias, anyGeometryUnproven = false, false, false
    for _, candidate in ipairs(realCandidates) do
        if candidate.nodeExists then anyNode = true end
        if candidate.rootAlias then anyAlias = true end
        if candidate.nodeExists and (candidate.geometryAuthority ~= "PASS" or candidate.aliasCheck ~= "PASS") then
            anyGeometryUnproven = true
        end
        if candidate.overallPass then
            validRoutes = validRoutes + 1
            local key = tostring(candidate.node)
            validByHandle[key] = validByHandle[key] or {node=candidate.node, routes={}}
            validByHandle[key].routes[#validByHandle[key].routes+1] = candidate.label
        end
    end

    local unique = {}
    for _, value in pairs(validByHandle) do unique[#unique+1] = value end
    table.sort(unique, function(a,b) return tostring(a.node) < tostring(b.node) end)
    local outcome = {
        result="UNRESOLVED",
        reason="NO_COHERENT_CANDIDATE",
        selectedNode=nil,
        selectedRoutes={},
        uniqueCoherentHandles=#unique,
        validRoutes=validRoutes,
        candidates=realCandidates,
        controls=controlCandidates
    }
    if #unique == 1 then
        outcome.result = "RESOLVED"
        outcome.selectedNode = unique[1].node
        outcome.selectedRoutes = unique[1].routes
        outcome.reason = #unique[1].routes > 1 and "ROUTE_CONVERGENCE" or "SINGLE_ROUTE"
    elseif #unique > 1 then
        outcome.result = "AMBIGUOUS"
        outcome.reason = "ROUTE_DISAGREEMENT"
    elseif anyAlias then
        outcome.result = "ALIASED"
        outcome.reason = "MEMBER_ROOT_ALIAS"
    elseif anyGeometryUnproven then
        outcome.result = "NODE_RESOLVED_GEOMETRY_UNPROVEN"
        outcome.reason = "ENTITY_LOCAL_GEOMETRY_NOT_ESTABLISHED"
    elseif anyNode then
        outcome.result = "UNRESOLVED"
        outcome.reason = "STRUCTURAL_COHERENCE_FAILED"
    end
    return outcome
end

function Evaluator:applyCrossShapeDistinctness(shapeResults)
    local byNode = {}
    for shapeId, result in pairs(shapeResults) do
        if result.result == "RESOLVED" and result.selectedNode ~= nil then
            local key = tostring(result.selectedNode)
            byNode[key] = byNode[key] or {}
            byNode[key][#byNode[key]+1] = shapeId
        end
    end
    for _, shapeIds in pairs(byNode) do
        if #shapeIds > 1 then
            table.sort(shapeIds)
            for _, shapeId in ipairs(shapeIds) do
                local result = shapeResults[shapeId]
                result.result = "ALIASED"
                result.reason = "CROSS_SOURCE_HANDLE_REUSE"
                result.crossSourceAliases = table.concat(shapeIds, ",")
            end
        end
    end
end

Evaluator.finite = finite
Evaluator.pose = pose
Evaluator.containingComponent = containingComponent
