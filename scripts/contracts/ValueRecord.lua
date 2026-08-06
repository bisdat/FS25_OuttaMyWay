OuttaMyWay.ValueRecord = {}
local ValueRecord = OuttaMyWay.ValueRecord

local privateData = setmetatable({}, { __mode = "k" })
local privateType = setmetatable({}, { __mode = "k" })

local function fail(message)
    error("OuttaMyWay ValueRecord: " .. message, 3)
end

local function sortedKeys(value)
    local keys = {}
    for key, _ in pairs(value) do
        keys[#keys + 1] = key
    end
    table.sort(keys, function(a, b)
        local ta, tb = type(a), type(b)
        if ta == tb then return tostring(a) < tostring(b) end
        return ta < tb
    end)
    return keys
end

local function copyPlain(value, seen)
    local kind = type(value)
    if kind == "nil" or kind == "boolean" or kind == "number" or kind == "string" then
        return value
    end
    if kind ~= "table" then
        fail("unsupported value type " .. kind)
    end
    if privateData[value] ~= nil then
        value = privateData[value]
    elseif getmetatable(value) ~= nil then
        fail("runtime/metatable-bearing tables are not value data")
    end
    seen = seen or {}
    if seen[value] then fail("cyclic value data is not permitted") end
    seen[value] = true
    local result = {}
    for key, item in pairs(value) do
        local keyType = type(key)
        if keyType ~= "string" and keyType ~= "number" then
            fail("table keys must be strings or numbers")
        end
        result[copyPlain(key, seen)] = copyPlain(item, seen)
    end
    seen[value] = nil
    return result
end

local function freezeValue(value)
    if type(value) ~= "table" then return value end
    local data = {}
    for key, item in pairs(value) do data[key] = freezeValue(item) end
    local proxy = {}
    privateData[proxy] = data
    privateType[proxy] = "ValueTable"
    setmetatable(proxy, {
        __index = data,
        __newindex = function() fail("attempt to mutate a sealed value") end,
        __metatable = false,
        __len = function() return #data end,
        __pairs = function() return next, data, nil end
    })
    return proxy
end

local function canonical(value)
    local kind = type(value)
    if kind == "nil" then return "null" end
    if kind == "boolean" then return value and "true" or "false" end
    if kind == "number" then return string.format("%.17g", value) end
    if kind == "string" then return string.format("%q", value) end
    if kind ~= "table" then fail("cannot serialise " .. kind) end
    local data = privateData[value] or value
    local parts = {}
    for _, key in ipairs(sortedKeys(data)) do
        parts[#parts + 1] = "[" .. canonical(key) .. "]=" .. canonical(data[key])
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

function ValueRecord.define(typeName, requiredFields, optionalFields, validator)
    local allowed = {}
    for _, name in ipairs(requiredFields or {}) do allowed[name] = true end
    for _, name in ipairs(optionalFields or {}) do allowed[name] = true end

    local definition = {}
    function definition.new(values)
        if type(values) ~= "table" or getmetatable(values) ~= nil then
            fail(typeName .. " values must be a plain table")
        end
        for _, name in ipairs(requiredFields or {}) do
            if values[name] == nil then fail(typeName .. " missing required field " .. name) end
        end
        for name, _ in pairs(values) do
            if not allowed[name] then fail(typeName .. " contains unknown field " .. tostring(name)) end
        end
        local plain = copyPlain(values)
        if validator ~= nil then validator(plain) end
        local data = {}
        for key, item in pairs(plain) do data[key] = freezeValue(item) end
        local proxy = {}
        privateData[proxy] = data
        privateType[proxy] = typeName
        setmetatable(proxy, {
            __index = data,
            __newindex = function() fail("attempt to mutate sealed " .. typeName) end,
            __metatable = false,
            __pairs = function() return next, data, nil end
        })
        return proxy
    end
    return definition
end

function ValueRecord.typeOf(record)
    return privateType[record]
end

function ValueRecord.assertType(record, expected)
    local actual = privateType[record]
    if actual ~= expected then fail("expected " .. expected .. ", observed " .. tostring(actual)) end
end

function ValueRecord.toTable(record)
    if privateData[record] == nil then fail("value is not a sealed record") end
    return copyPlain(privateData[record])
end

function ValueRecord.update(record, changes)
    local typeName = privateType[record]
    if typeName == nil or typeName == "ValueTable" then fail("value is not an updateable record") end
    local values = ValueRecord.toTable(record)
    for key, value in pairs(changes or {}) do values[key] = copyPlain(value) end
    return ValueRecord.definitions[typeName].new(values)
end

function ValueRecord.canonical(record)
    if privateData[record] == nil then fail("value is not a sealed record") end
    return canonical(record)
end

ValueRecord.definitions = {}
function ValueRecord.register(typeName, definition)
    if ValueRecord.definitions[typeName] ~= nil then fail("duplicate record definition " .. typeName) end
    ValueRecord.definitions[typeName] = definition
    return definition
end
