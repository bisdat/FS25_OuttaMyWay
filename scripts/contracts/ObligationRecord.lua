OuttaMyWay.ObligationRecord = OuttaMyWay.ValueRecord.register(
    "ObligationRecord",
    OuttaMyWay.ValueRecord.define("ObligationRecord", {"identity", "origin", "basis", "ownerCommitmentId", "requiredOutcome", "requiredAuthority", "evidenceContract", "ownershipClass", "transferPolicy", "terminalDependency", "ownershipHistory", "status", "epoch", "revision"}, {"settlementDisposition"}, function(values)
    local ownership = { ORIGIN_BOUND=true, CONTINUITY=true, INTENT_RELATIVE=true }
    local status = { OPEN=true, SETTLED=true }
    if not ownership[values.ownershipClass] then error("ObligationRecord contains an invalid ownership class", 3) end
    if not status[values.status] then error("ObligationRecord contains an invalid status", 3) end
end)
)
