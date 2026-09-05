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
    CONTROL_OUTCOME = "CO",
    ASSEMBLY = "AS",
    COMPONENT = "CP",
    JOB_EPISODE = "JE",
    OPERATION = "OR",
    FIELD_WORLD = "FW",
    SITUATION = "SI",
    ENCOUNTER = "EN",
    CANDIDATE_INVENTORY = "CI",
    VERDICT_SET = "VS",
    GOVERNING_BASIS_VERDICT = "BV",
    COMMITMENT_APPLICATION = "AP",
    RESPONSIBILITY = "RS",
    BOUNDED_AUTHORITY = "BA",
    REPLAY_RUN = "RR",
    PASSIVE_LIVE_TRACE = "LT"
}

function IdentityRegistry.new(prefixes)
    local self = setmetatable({}, IdentityRegistry)
    self.prefixes = prefixes or defaultPrefixes
    self.counters = {}
    self.issued = {}
    self.references = {}
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

local function referenceIndex(kind, referenceKey)
    local keyType = type(referenceKey)
    if (keyType ~= "string" and keyType ~= "number") or tostring(referenceKey) == "" then
        error("reference key must be a non-empty string or number", 3)
    end
    return kind .. "\0" .. keyType .. "\0" .. tostring(referenceKey)
end

function IdentityRegistry:resolve(kind, referenceKey)
    if self.prefixes[kind] == nil then error("unknown identity kind " .. tostring(kind), 2) end
    local index = referenceIndex(kind, referenceKey)
    local identity = self.references[index]
    if identity == nil then
        identity = self:issue(kind)
        self.references[index] = identity
    end
    return identity
end

function IdentityRegistry:lookup(kind, referenceKey)
    return self.references[referenceIndex(kind, referenceKey)]
end

function IdentityRegistry:isIssued(identity)
    return self.issued[identity] == true
end
