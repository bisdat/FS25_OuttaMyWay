--- Defines the bounded physical execution request product consumed by Control without creating upstream authority.
-- Specification Jurisdictions: `CONTROL`

OuttaMyWay.ControlRequest = OuttaMyWay.ValueRecord.register(
    "ControlRequest",
    OuttaMyWay.ValueRecord.define("ControlRequest", {"identity", "commitmentId", "assemblyId", "capability", "target", "authorityToken", "operationalPictureEpoch", "evidenceEpoch", "effectiveActuationCompositionId", "preconditions", "invalidationConditions"}, {"boundedAuthorityId"})
)
