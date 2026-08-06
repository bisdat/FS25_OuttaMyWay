OuttaMyWay.ControlOutcome = OuttaMyWay.ValueRecord.register(
    "ControlOutcome",
    OuttaMyWay.ValueRecord.define("ControlOutcome", {"identity", "requestId", "status", "observedPhysicalEffect", "progress", "provenance", "timestamp"}, {"completionEvidence", "failureEvidence"}, function(values)
    local allowed = { ACCEPTED=true, REJECTED=true, DEFERRED=true, IN_PROGRESS=true, COMPLETED=true, FAILED=true }
    if not allowed[values.status] then error("ControlOutcome contains an invalid status", 3) end
end)
)
