local function requireIdentity(name,value,prefix)
    if type(value)~="string" or value=="" then error("BoundedAuthorityGrant requires "..name,3) end
    if prefix~=nil and string.sub(value,1,string.len(prefix)+1)~=prefix.."-" then
        error("BoundedAuthorityGrant "..name.." must use "..prefix.."- identity",3)
    end
end

OuttaMyWay.BoundedAuthorityGrant = OuttaMyWay.ValueRecord.register(
    "BoundedAuthorityGrant",
    OuttaMyWay.ValueRecord.define(
        "BoundedAuthorityGrant",
        {"identity","responsibilityId","commitmentId","assemblyId","capability","target","authorityToken","operationalPictureEpoch","evidenceEpoch","effectiveActuationCompositionId","preconditions","invalidationConditions","provenance"},
        {},
        function(values)
            requireIdentity("identity",values.identity,"BA")
            requireIdentity("responsibilityId",values.responsibilityId,"RS")
            requireIdentity("commitmentId",values.commitmentId,"CM")
            requireIdentity("assemblyId",values.assemblyId,"AS")
            requireIdentity("authorityToken",values.authorityToken,"AU")
            requireIdentity("effectiveActuationCompositionId",values.effectiveActuationCompositionId)
            if values.capability~="REGULATE_SPEED" and values.capability~="REPOSITION" and values.capability~="HOLD" then
                error("BoundedAuthorityGrant capability unsupported",3)
            end
            if type(values.target)~="table" or type(values.preconditions)~="table" or type(values.invalidationConditions)~="table" or type(values.provenance)~="table" then
                error("BoundedAuthorityGrant requires target, validity envelope and provenance",3)
            end
        end
    )
)
