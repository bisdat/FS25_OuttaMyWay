--- Defines the current Bounded Authority grant product binding responsibility, subject, capability, target and validity context.
-- Specification Jurisdictions: `BOUNDED_AUTHORITY`

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
        {"identity","responsibilityId","commitmentId","assemblyId","capability","target","operationalPictureEpoch","evidenceEpoch","effectiveActuationCompositionId","preconditions","invalidationConditions","provenance"},
        {"authorityToken","authorityRole"},
        function(values)
            requireIdentity("identity",values.identity,"BA")
            requireIdentity("responsibilityId",values.responsibilityId,"RS")
            requireIdentity("commitmentId",values.commitmentId,"CM")
            requireIdentity("assemblyId",values.assemblyId,"AS")
            if values.authorityRole=="SUPPORTING_SPEED_CEILING" then
                if values.capability~="REGULATE_SPEED" then error("Supporting Speed Ceiling grant capability must be REGULATE_SPEED",3) end
                if values.authorityToken~=nil then error("Supporting Speed Ceiling grant must not carry movement-owner token",3) end
            else
                if values.authorityRole~=nil then error("BoundedAuthorityGrant authorityRole unsupported",3) end
                requireIdentity("authorityToken",values.authorityToken,"AU")
            end
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
