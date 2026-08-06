OuttaMyWay.AuthorityRegistry = {}
local Registry = OuttaMyWay.AuthorityRegistry
Registry.__index = Registry

local Token = OuttaMyWay.ValueRecord.register(
    "AuthorityToken",
    OuttaMyWay.ValueRecord.define("AuthorityToken", {"identity","assemblyId","commitmentId","epoch","generation"}, {})
)

function Registry.new(identityRegistry, epochSequence, commitmentRegistry)
    local self = setmetatable({}, Registry)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.commitments = commitmentRegistry
    self.byAssembly = {}
    self.generations = {}
    return self
end

function Registry:acquireProgress(assemblyId, commitmentId)
    if type(assemblyId) ~= "string" or assemblyId == "" then error("assembly identity required", 2) end
    local commitment = self.commitments:get(commitmentId)
    if commitment == nil or commitment.state ~= "ACTIVE" then
        error("only an ACTIVE Commitment may own progress actuation", 2)
    end
    if self.byAssembly[assemblyId] ~= nil then
        error("assembly already has a progress-actuation owner", 2)
    end
    local generation = (self.generations[assemblyId] or 0) + 1
    self.generations[assemblyId] = generation
    local token = Token.new({
        identity = self.identities:issue("AUTHORITY"),
        assemblyId = assemblyId,
        commitmentId = commitmentId,
        epoch = self.epochs:next(),
        generation = generation
    })
    self.byAssembly[assemblyId] = token
    return token
end

function Registry:ownerOf(assemblyId)
    local token = self.byAssembly[assemblyId]
    return token and token.commitmentId or nil
end

function Registry:validate(token)
    OuttaMyWay.ValueRecord.assertType(token, "AuthorityToken")
    return self.byAssembly[token.assemblyId] == token and self.generations[token.assemblyId] == token.generation
end

function Registry:release(token)
    if not self:validate(token) then error("stale or foreign authority token", 2) end
    self.byAssembly[token.assemblyId] = nil
    return true
end
