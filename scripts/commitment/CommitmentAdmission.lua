OuttaMyWay.CommitmentAdmission = {}
local Admission = OuttaMyWay.CommitmentAdmission
Admission.__index = Admission

local function live(record)
    return record ~= nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(record.state)
end

local function validateObligationSpecification(specification)
    if type(specification) ~= "table" then error("Obligation specification must be a table",3) end
    for _, field in OuttaMyWay.ValueRecord.ipairs({"origin","basis","requiredOutcome","evidenceContract","ownershipClass"}) do
        if specification[field] == nil then error("Obligation specification missing " .. field,3) end
    end
end

function Admission.new(identityRegistry, epochSequence, commitmentRegistry, obligationLedger, authorityRegistry)
    return setmetatable({
        identities=identityRegistry, epochs=epochSequence, commitments=commitmentRegistry,
        obligations=obligationLedger, authorities=authorityRegistry
    },Admission)
end

function Admission:findLiveByResponsibilityKey(responsibilityKey)
    local result = {}
    for _, record in OuttaMyWay.ValueRecord.ipairs(self.commitments:list()) do
        if live(record) and record.governingBasis.responsibilityKey == responsibilityKey then
            result[#result+1] = record
        end
    end
    return result
end

function Admission:admit(values)
    values = values or {}
    if type(values.governingBasis) ~= "table" then error("Commitment admission requires Governing Basis",2) end
    local responsibilityKey = values.governingBasis.responsibilityKey
    if type(responsibilityKey) ~= "string" or responsibilityKey == "" then
        error("Commitment admission requires Governing Basis responsibilityKey",2)
    end
    local existing = self:findLiveByResponsibilityKey(responsibilityKey)
    for _, record in OuttaMyWay.ValueRecord.ipairs(existing) do
        local permittedSuccessor = values.supersedesCommitmentId == record.identity
            and record.state == "SETTLING"
            and record.intendedTerminalDisposition == "SUPERSEDED_BY_NEW_INTENT"
        if not permittedSuccessor then
            error("unresolved responsibility already owned by Commitment " .. record.identity,2)
        end
    end
    for _, specification in OuttaMyWay.ValueRecord.ipairs(values.obligationSpecifications or {}) do validateObligationSpecification(specification) end
    for _, assemblyId in OuttaMyWay.ValueRecord.ipairs(values.progressAssemblyIds or {}) do
        local owner=self.authorities:ownerOf(assemblyId); if owner~=nil then error("actuation authority already owned for assembly "..assemblyId,2) end
    end
    for _, assemblyId in OuttaMyWay.ValueRecord.ipairs(values.postJobAssemblyIds or {}) do
        local owner=self.authorities:ownerOf(assemblyId); if owner~=nil then error("actuation authority already owned for assembly "..assemblyId,2) end
    end

    local record = self.commitments:create({
        objective=values.objective,
        governingBasis=values.governingBasis,
        strategy=values.strategy or {},
        situationDependencies=values.situationDependencies or {},
        evidenceContracts=values.evidenceContracts or {},
        effectiveActuationCompositionId=values.effectiveActuationCompositionId
    })
    local obligationIds = {}
    for _, specification in OuttaMyWay.ValueRecord.ipairs(values.obligationSpecifications or {}) do
        local obligation = self.obligations:create({
            origin=specification.origin,
            basis=specification.basis,
            ownerCommitmentId=record.identity,
            requiredOutcome=specification.requiredOutcome,
            requiredAuthority=specification.requiredAuthority or {},
            evidenceContract=specification.evidenceContract,
            ownershipClass=specification.ownershipClass,
            transferPolicy=specification.transferPolicy or {},
            terminalDependency=specification.terminalDependency ~= false,
            creationEvidence=specification.creationEvidence
        })
        obligationIds[#obligationIds+1] = obligation.identity
    end
    local authorityTokens,ownership,postJobOwnership={},{},{}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(values.progressAssemblyIds or {}) do
        local token=self.authorities:acquireProgress(assemblyId,record.identity); authorityTokens[#authorityTokens+1]=token; ownership[#ownership+1]={assemblyId=assemblyId,authorityTokenId=token.identity}
    end
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(values.postJobAssemblyIds or {}) do
        local token=self.authorities:acquirePostJob(assemblyId,record.identity); authorityTokens[#authorityTokens+1]=token; postJobOwnership[#postJobOwnership+1]={assemblyId=assemblyId,authorityTokenId=token.identity}
    end
    if #obligationIds>0 or #ownership>0 or #postJobOwnership>0 then
        local revised=OuttaMyWay.CommitmentStateMachine.revise(record,{
            obligationIds=obligationIds,progressActuationOwnership=ownership,postJobActuationOwnership=postJobOwnership,epoch=self.epochs:next()
        })
        record = self.commitments:save(revised)
    end
    return {commitment=record,obligationIds=obligationIds,authorityTokens=authorityTokens}
end
