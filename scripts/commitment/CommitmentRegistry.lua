OuttaMyWay.CommitmentRegistry = {}
local Registry = OuttaMyWay.CommitmentRegistry
Registry.__index = Registry

function Registry.new(identityRegistry, epochSequence)
    local self = setmetatable({}, Registry)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.records = {}
    return self
end

function Registry:create(values)
    values = values or {}
    local identity = values.identity or self.identities:issue("COMMITMENT")
    if self.records[identity] ~= nil then error("duplicate Commitment " .. identity, 2) end
    local record = OuttaMyWay.CommitmentRecord.new({
        identity = identity,
        objective = values.objective,
        governingBasis = values.governingBasis,
        state = "ACTIVE",
        strategy = values.strategy or {},
        situationDependencies = values.situationDependencies or {},
        obligationIds = values.obligationIds or {},
        progressActuationOwnership = values.progressActuationOwnership or {},
        postJobActuationOwnership = values.postJobActuationOwnership or {},
        capabilityReservations = values.capabilityReservations or {},
        effectiveActuationCompositionId = values.effectiveActuationCompositionId,
        evidenceContracts = values.evidenceContracts or {},
        intendedTerminalDisposition = nil,
        terminalCause = nil,
        terminalSettlementEvidence = nil,
        epoch = values.epoch or self.epochs:next(),
        revision = 1
    })
    self.records[identity] = record
    return record
end

function Registry:get(identity)
    return self.records[identity]
end

function Registry:save(record)
    OuttaMyWay.ValueRecord.assertType(record, "CommitmentRecord")
    local current = self.records[record.identity]
    if current == nil then error("unknown Commitment " .. tostring(record.identity), 2) end
    if record.revision ~= current.revision + 1 then error("stale or non-sequential Commitment revision", 2) end
    self.records[record.identity] = record
    return record
end

function Registry:list()
    local ids = {}
    for identity, _ in OuttaMyWay.ValueRecord.pairs(self.records) do ids[#ids + 1] = identity end
    table.sort(ids)
    local result = {}
    for _, identity in OuttaMyWay.ValueRecord.ipairs(ids) do result[#result + 1] = self.records[identity] end
    return result
end
