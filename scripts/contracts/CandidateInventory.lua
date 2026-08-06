local function unique(values,label)
    local seen={}
    for _,value in ipairs(values or {}) do
        if seen[value] then error("CandidateInventory contains duplicate " .. label .. " " .. tostring(value),3) end
        seen[value]=true
    end
end

OuttaMyWay.CandidateInventory = OuttaMyWay.ValueRecord.register(
    "CandidateInventory",
    OuttaMyWay.ValueRecord.define(
        "CandidateInventory",
        {"identity","epoch","operationalPictureId","candidateIds","complete","supportBoundary","provenance"},
        {},
        function(values)
            if values.complete ~= true then error("CandidateInventory must represent the complete supportable Candidate Action Space",3) end
            if type(values.supportBoundary) ~= "table" then error("CandidateInventory supportBoundary must be a table",3) end
            unique(values.candidateIds,"candidate identity")
        end
    )
)
