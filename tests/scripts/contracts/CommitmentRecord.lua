OuttaMyWay.CommitmentRecord = OuttaMyWay.ValueRecord.register(
    "CommitmentRecord",
    OuttaMyWay.ValueRecord.define("CommitmentRecord", {"identity", "objective", "governingBasis", "state", "strategy", "situationDependencies", "obligationIds", "progressActuationOwnership", "capabilityReservations", "evidenceContracts", "epoch", "revision"}, {"effectiveActuationCompositionId", "intendedTerminalDisposition", "terminalCause", "terminalSettlementEvidence"}, function(values)
    local allowed = { ACTIVE=true, WAITING_FOR_EVIDENCE=true, SETTLING=true, SUCCEEDED=true, FAILED=true, SUPERSEDED_BY_NEW_INTENT=true, CANCELLED_BY_SOURCE_INTENT_TERMINATION=true, CANCELLED_BY_OPERATION_TERMINATION=true }
    if not allowed[values.state] then error("CommitmentRecord contains an invalid state", 3) end
end)
)
