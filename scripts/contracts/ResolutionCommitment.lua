local function validateAssemblyIds(name,values)
    local previous=nil
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if type(assemblyId)~="string" or assemblyId=="" then error(name.." must contain assembly identities",3) end
        if previous~=nil and previous>=assemblyId then error(name.." must be sorted and distinct",3) end
        previous=assemblyId
    end
end

OuttaMyWay.ResolutionCommitment = OuttaMyWay.ValueRecord.register(
    "ResolutionCommitment",
    OuttaMyWay.ValueRecord.define(
        "ResolutionCommitment",
        {"identity","kind","purpose","governingBasis","beneficiaryAssemblyIds","controlledSubjectAssemblyIds","openResolutionObligationIds","provenance"},
        {},
        function(values)
            if type(values.identity)~="string" or values.identity=="" then error("ResolutionCommitment requires retained Commitment identity",3) end
            if values.kind~="RESOLUTION_COMMITMENT" then error("ResolutionCommitment has invalid kind",3) end
            if type(values.purpose)~="table" or type(values.governingBasis)~="table" or type(values.provenance)~="table" then
                error("ResolutionCommitment requires semantic purpose, governing basis and provenance",3)
            end
            validateAssemblyIds("beneficiaryAssemblyIds",values.beneficiaryAssemblyIds)
            validateAssemblyIds("controlledSubjectAssemblyIds",values.controlledSubjectAssemblyIds)
            if OuttaMyWay.ValueRecord.length(values.beneficiaryAssemblyIds)==0 or OuttaMyWay.ValueRecord.length(values.controlledSubjectAssemblyIds)==0 then
                error("ResolutionCommitment requires explicit beneficiary and controlled-subject roles",3)
            end
            local previous=nil
            for _,obligationId in OuttaMyWay.ValueRecord.ipairs(values.openResolutionObligationIds or {}) do
                if type(obligationId)~="string" or obligationId=="" then error("openResolutionObligationIds must contain obligation identities",3) end
                if previous~=nil and previous>=obligationId then error("openResolutionObligationIds must be sorted and distinct",3) end
                previous=obligationId
            end
            if OuttaMyWay.ValueRecord.length(values.openResolutionObligationIds)==0 then error("ResolutionCommitment requires an open Resolution obligation",3) end
        end
    )
)
