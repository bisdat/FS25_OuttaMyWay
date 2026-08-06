OuttaMyWay.IdentityRegistry = {}
local IdentityRegistry = OuttaMyWay.IdentityRegistry
IdentityRegistry.__index = IdentityRegistry

local defaultPrefixes = {
    COMMITMENT = "CM",
    OBLIGATION = "OB",
    AUTHORITY = "AU",
    COMPOSITION = "EC",
    OBSERVATION = "OS",
    PICTURE = "OP",
    CANDIDATE = "CA",
    VERDICT = "CV",
    DECISION = "DE",
    CONTROL_REQUEST = "CR",
    CONTROL_OUTCOME = "CO"
}

function IdentityRegistry.new(prefixes)
    local self = setmetatable({}, IdentityRegistry)
    self.prefixes = prefixes or defaultPrefixes
    self.counters = {}
    self.issued = {}
    return self
end

function IdentityRegistry:register(identity)
    if type(identity) ~= "string" or identity == "" then error("identity must be a non-empty string", 2) end
    if self.issued[identity] then error("duplicate identity " .. identity, 2) end
    self.issued[identity] = true
    return identity
end

function IdentityRegistry:issue(kind)
    local prefix = self.prefixes[kind]
    if prefix == nil then error("unknown identity kind " .. tostring(kind), 2) end
    local nextValue = (self.counters[kind] or 0) + 1
    self.counters[kind] = nextValue
    return self:register(string.format("%s-%05d", prefix, nextValue))
end

function IdentityRegistry:isIssued(identity)
    return self.issued[identity] == true
end
