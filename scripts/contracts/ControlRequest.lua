--- Defines the bounded physical execution request product consumed by Control without creating upstream authority.
-- Specification Jurisdictions: `CONTROL`

OuttaMyWay.ControlRequest = OuttaMyWay.ValueRecord.register(
    "ControlRequest",
    OuttaMyWay.ValueRecord.define(
        "ControlRequest",
        {"identity", "commitmentId", "assemblyId", "capability", "target", "operationalPictureEpoch", "evidenceEpoch", "effectiveActuationCompositionId", "preconditions", "invalidationConditions"},
        {"authorityToken", "authorityRole", "boundedAuthorityId"},
        function(values)
            if values.authorityRole=="SUPPORTING_SPEED_CEILING" then
                if values.capability~="REGULATE_SPEED" then error("Supporting Speed Ceiling request capability must be REGULATE_SPEED",3) end
                if values.authorityToken~=nil then error("Supporting Speed Ceiling request must not carry movement-owner token",3) end
            else
                if values.authorityRole~=nil then error("ControlRequest authorityRole unsupported",3) end
                if type(values.authorityToken)~="string" or values.authorityToken=="" then error("ControlRequest requires authorityToken",3) end
            end
        end
    )
)
