OuttaMyWay.ResolutionCommitmentAdapter = {}
local Adapter = OuttaMyWay.ResolutionCommitmentAdapter

local function sortedDistinct(values)
    local result={}
    local seen={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(value)~="string" or value=="" then return nil,"INVALID_SEMANTIC_IDENTITY" end
        if not seen[value] then seen[value]=true; result[#result+1]=value end
    end
    table.sort(result)
    return result,nil
end

local function openResolutionObligationIds(runtime,commitmentId,outcomeKinds)
    local accepted={}
    for _,kind in OuttaMyWay.ValueRecord.ipairs(outcomeKinds or {}) do accepted[kind]=true end
    local identities={}
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        local outcome=obligation.requiredOutcome
        if type(outcome)=="table" and accepted[outcome.kind] then identities[#identities+1]=obligation.identity end
    end
    return sortedDistinct(identities)
end

-- This adapter materializes a read-only architectural view. It owns no
-- responsibility or retained Commitment/Obligation lifecycle authority.
function Adapter.build(runtime,applied,semantics)
    local commitment=applied and applied.commitment or nil
    local application=applied and applied.application or nil
    if runtime==nil or commitment==nil or application==nil or type(semantics)~="table" then return nil,"MISSING_RESOLUTION_CONTEXT" end
    if application.commitmentId~=commitment.identity then return nil,"RESOLUTION_IDENTITY_MISMATCH" end
    local beneficiaries,beneficiaryReason=sortedDistinct(semantics.beneficiaryAssemblyIds)
    if beneficiaries==nil then return nil,beneficiaryReason end
    local subjects,subjectReason=sortedDistinct(semantics.controlledSubjectAssemblyIds)
    if subjects==nil then return nil,subjectReason end
    local obligationIds,obligationReason=openResolutionObligationIds(runtime,commitment.identity,semantics.resolutionOutcomeKinds)
    if obligationIds==nil then return nil,obligationReason end
    if #beneficiaries==0 or #subjects==0 or #obligationIds==0 then return nil,"INCOMPLETE_RESOLUTION_SEMANTICS" end
    local responsibilityIdentity=semantics.responsibilityIdentity
    if type(responsibilityIdentity)~="string" or responsibilityIdentity=="" then return nil,"INVALID_RESOLUTION_RESPONSIBILITY_IDENTITY" end
    return OuttaMyWay.ResolutionCommitment.new({
        identity=responsibilityIdentity,
        kind="RESOLUTION_COMMITMENT",
        purpose=semantics.purpose,
        governingBasis=commitment.governingBasis,
        beneficiaryAssemblyIds=beneficiaries,
        controlledSubjectAssemblyIds=subjects,
        openResolutionObligationIds=obligationIds,
        provenance={source=semantics.source,legacyApplicationAction=application.action,genericCommitmentIdentity=commitment.identity,genericCommitmentRevision=commitment.revision}
    }),nil
end
