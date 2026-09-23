OuttaMyWay.ReplayRunResult = OuttaMyWay.ValueRecord.register(
    "ReplayRunResult",
    OuttaMyWay.ValueRecord.define(
        "ReplayRunResult",
        {"identity","epoch","fixtureId","stepResults","conformance","fingerprints","provenance"},
        {"earliestDivergence"},
        function(values)
            if values.conformance ~= "PASS" and values.conformance ~= "FAIL" then
                error("ReplayRunResult conformance must be PASS or FAIL",3)
            end
            if values.conformance == "PASS" and values.earliestDivergence ~= nil then
                error("passing ReplayRunResult cannot contain a divergence",3)
            end
            if values.conformance == "FAIL" and values.earliestDivergence == nil then
                error("failing ReplayRunResult requires earliest divergence",3)
            end
        end
    )
)
