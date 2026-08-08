OuttaMyWay.ConstraintVerdict = OuttaMyWay.ValueRecord.register(
    "ConstraintVerdict",
    OuttaMyWay.ValueRecord.define("ConstraintVerdict", {"identity", "epoch", "constraintId", "evaluator", "candidateId", "result", "mandatory", "evidence", "provenance", "reason", "revalidationTrigger"}, {}, function(values)
    local allowed = { PASS=true, FAIL=true, UNRESOLVED=true }
    if not allowed[values.result] then error("ConstraintVerdict result must be PASS, FAIL or UNRESOLVED", 3) end
    if type(values.mandatory) ~= "boolean" then error("ConstraintVerdict mandatory must be boolean", 3) end
end)
)
