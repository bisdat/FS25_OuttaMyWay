local allowed = { CREATE=true, MAINTAIN=true, REVISE=true, WAIT=true, SETTLE=true, NO_MUTATION=true }
OuttaMyWay.CommitmentApplicationRecord = OuttaMyWay.ValueRecord.register(
    "CommitmentApplicationRecord",
    OuttaMyWay.ValueRecord.define(
        "CommitmentApplicationRecord",
        {"identity","epoch","decisionId","action","createdObligationIds","authorityTokenIds","explanation","provenance"},
        {"commitmentId","selectedCandidateId","previousState","resultingState","effectiveActuationCompositionId"},
        function(values)
            if not allowed[values.action] then error("unsupported Commitment application action",3) end
            if values.action ~= "NO_MUTATION" and values.commitmentId == nil then
                error("mutating Commitment application requires commitment identity",3)
            end
        end
    )
)
