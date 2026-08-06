OuttaMyWay.ObligationLedger = {}
local Ledger = OuttaMyWay.ObligationLedger
Ledger.__index = Ledger

function Ledger.new(identityRegistry, epochSequence, commitmentRegistry)
    local self = setmetatable({}, Ledger)
    self.identities = identityRegistry
    self.epochs = epochSequence
    self.commitments = commitmentRegistry
    self.records = {}
    return self
end

local function requireCommitment(self, identity)
    local record = self.commitments:get(identity)
    if record == nil then error("Obligation owner must be a live internal Commitment", 3) end
    if OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then
        error("terminal Commitment cannot accept an open Obligation", 3)
    end
    return record
end

function Ledger:create(values)
    values = values or {}
    requireCommitment(self, values.ownerCommitmentId)
    local identity = values.identity or self.identities:issue("OBLIGATION")
    if self.records[identity] ~= nil then error("duplicate Obligation " .. identity, 2) end
    local record = OuttaMyWay.ObligationRecord.new({
        identity = identity,
        origin = values.origin,
        basis = values.basis,
        ownerCommitmentId = values.ownerCommitmentId,
        requiredOutcome = values.requiredOutcome,
        requiredAuthority = values.requiredAuthority or {},
        evidenceContract = values.evidenceContract,
        ownershipClass = values.ownershipClass,
        transferPolicy = values.transferPolicy or {},
        terminalDependency = values.terminalDependency ~= false,
        settlementDisposition = nil,
        ownershipHistory = {{ ownerCommitmentId=values.ownerCommitmentId, event="CREATED", evidence=values.creationEvidence }},
        status = "OPEN",
        epoch = values.epoch or self.epochs:next(),
        revision = 1
    })
    self.records[identity] = record
    return record
end

function Ledger:get(identity) return self.records[identity] end

function Ledger:hasOpenObligations(ownerCommitmentId)
    for _, record in pairs(self.records) do
        if record.ownerCommitmentId == ownerCommitmentId and record.status == "OPEN" and record.terminalDependency then
            return true
        end
    end
    return false
end

function Ledger:openForOwner(ownerCommitmentId)
    local result = {}
    for _, record in pairs(self.records) do
        if record.ownerCommitmentId == ownerCommitmentId and record.status == "OPEN" then result[#result + 1] = record end
    end
    table.sort(result, function(a,b) return a.identity < b.identity end)
    return result
end

function Ledger:settle(identity, mode, evidence)
    local record = self.records[identity]
    if record == nil or record.status ~= "OPEN" then error("unknown or settled Obligation", 2) end
    if mode ~= "SATISFACTION" and mode ~= "BASIS_CESSATION" then
        error("Obligation settlement mode must be SATISFACTION or BASIS_CESSATION", 2)
    end
    if evidence == nil then error("Obligation settlement requires evidence", 2) end
    local updated = OuttaMyWay.ValueRecord.update(record, {
        status = "SETTLED",
        settlementDisposition = { mode=mode, evidence=evidence },
        epoch = self.epochs:next(),
        revision = record.revision + 1
    })
    self.records[identity] = updated
    return updated
end

function Ledger:transfer(identity, successorCommitmentId, evidence)
    local record = self.records[identity]
    if record == nil or record.status ~= "OPEN" then error("unknown or settled Obligation", 2) end
    if record.ownershipClass == "ORIGIN_BOUND" then error("origin-bound Obligation cannot transfer", 2) end
    local policy = record.transferPolicy
    if policy.allowed ~= true then error("Obligation transfer policy does not permit transfer", 2) end
    requireCommitment(self, successorCommitmentId)
    if successorCommitmentId == record.ownerCommitmentId then error("successor must differ from current owner", 2) end
    if policy.eligibleCommitmentIds ~= nil then
        local eligible = false
        for _, identity in ipairs(policy.eligibleCommitmentIds) do
            if identity == successorCommitmentId then eligible = true break end
        end
        if not eligible then error("successor is not eligible under the transfer policy", 2) end
    end
    if evidence == nil then error("accepted transfer requires evidence", 2) end
    local history = OuttaMyWay.ValueRecord.toTable(record).ownershipHistory
    history[#history + 1] = {
        fromCommitmentId = record.ownerCommitmentId,
        ownerCommitmentId = successorCommitmentId,
        event = "ACCEPTED_TRANSFER",
        evidence = evidence
    }
    local updated = OuttaMyWay.ValueRecord.update(record, {
        ownerCommitmentId = successorCommitmentId,
        ownershipHistory = history,
        settlementDisposition = nil,
        epoch = self.epochs:next(),
        revision = record.revision + 1
    })
    self.records[identity] = updated
    return updated
end
