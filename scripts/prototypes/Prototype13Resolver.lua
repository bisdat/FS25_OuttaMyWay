-- FS25_OuttaMyWay v4.6.20
-- Prototype 13A declared-route executor. It resolves diagnostic candidates but
-- does not decide physical authority, construct footprints or discover routes.

OuttaMyWay.Prototype13Resolver = OuttaMyWay.Prototype13Resolver or {}
local Resolver = OuttaMyWay.Prototype13Resolver

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

local function parsePath(value)
    local result = {}
    if type(value) == "table" then
        for _, index in ipairs(value) do result[#result+1] = tonumber(index) end
        return result
    end
    for token in string.gmatch(tostring(value or ""), "[^|]+") do
        local index = tonumber(token)
        if index == nil or index < 0 then return nil, "invalid-path-token:" .. tostring(token) end
        result[#result+1] = index
    end
    return result
end

local function mappingNode(object, key)
    for _, field in ipairs({"i3dMappings", "i3dMapping"}) do
        local mappings = object and object[field] or nil
        if type(mappings) == "table" then
            local node = asNode(mappings[key])
            if node ~= nil then return node, field end
        end
    end
    if object ~= nil and type(object.getI3DMapping) == "function" then
        local ok, value = pcall(object.getI3DMapping, object, key)
        local node = ok and asNode(value) or nil
        if node ~= nil then return node, "getI3DMapping" end
    end
    return nil, "mapping-not-found"
end

local function componentNode(object, index)
    local component = object and type(object.components) == "table" and object.components[index] or nil
    return asNode(component), component
end

local function traverse(anchor, pathValue)
    if anchor == nil or anchor == 0 then return nil, "anchor-unavailable", 0 end
    if type(getChildAt) ~= "function" or type(getNumOfChildren) ~= "function" then
        return nil, "hierarchy-api-unavailable", 0
    end
    local path, parseError = parsePath(pathValue)
    if path == nil then return nil, parseError, 0 end
    local node = anchor
    local depth = 0
    for _, index in ipairs(path) do
        local okCount, count = pcall(getNumOfChildren, node)
        if not okCount or type(count) ~= "number" then return nil, "child-count-unavailable", depth end
        if index >= count then return nil, "child-index-out-of-range:" .. tostring(index) .. "/" .. tostring(count), depth end
        local okChild, child = pcall(getChildAt, node, index)
        if not okChild or type(child) ~= "number" or child == 0 then return nil, "child-unavailable:" .. tostring(index), depth end
        node = child
        depth = depth + 1
    end
    return node, nil, depth
end

function Resolver:resolveRoute(object, route)
    local candidate = {
        label=route.label,
        routeType=route.routeType,
        control=route.control == true,
        expectedControl=route.expectedControl,
        declaredComponentIndex=route.componentIndex,
        expectedAnchorComponentIndex=route.expectedAnchorComponentIndex,
        mappingKey=route.mappingKey,
        path=tostring(route.path or ""),
        node=nil,
        anchorNode=nil,
        anchorSource="none",
        error=nil,
        traversedDepth=0
    }

    if route.routeType == "DIRECT_MAPPING" then
        local node, source = mappingNode(object, route.mappingKey)
        candidate.node = node
        candidate.anchorNode = node
        candidate.anchorSource = source
        if node == nil then candidate.error = source end
        return candidate
    end

    local anchor = nil
    if route.routeType == "COMPONENT_DESCENDANT" then
        anchor = componentNode(object, route.componentIndex)
        candidate.anchorSource = "components[" .. tostring(route.componentIndex) .. "]"
    elseif route.routeType == "MAPPED_ANCHOR_DESCENDANT" then
        local source
        anchor, source = mappingNode(object, route.mappingKey)
        candidate.anchorSource = source
    else
        candidate.error = "unsupported-route-type"
        return candidate
    end

    candidate.anchorNode = anchor
    if anchor == nil then
        candidate.error = "anchor-unavailable:" .. tostring(candidate.anchorSource)
        return candidate
    end
    local node, err, depth = traverse(anchor, route.path)
    candidate.node = node
    candidate.error = err
    candidate.traversedDepth = depth or 0
    return candidate
end

function Resolver:resolveShape(object, shape)
    local result = {}
    for _, route in ipairs(shape.routes or {}) do
        result[#result+1] = self:resolveRoute(object, route)
    end
    return result
end

Resolver.asNode = asNode
Resolver.mappingNode = mappingNode
Resolver.componentNode = componentNode
Resolver.traverse = traverse
