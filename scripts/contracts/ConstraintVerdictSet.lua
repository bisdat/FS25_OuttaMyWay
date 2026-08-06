local function unique(values,label)
    local seen={}
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if seen[value] then error("ConstraintVerdictSet contains duplicate " .. label .. " " .. tostring(value),3) end
        seen[value]=true
    end
end

OuttaMyWay.ConstraintVerdictSet = OuttaMyWay.ValueRecord.register(
    "ConstraintVerdictSet",
    OuttaMyWay.ValueRecord.define(
        "ConstraintVerdictSet",
        {"identity","epoch","operationalPictureId","candidateInventoryId","verdictIds","mandatoryConstraintIds","complete","provenance"},
        {},
        function(values)
            if values.complete ~= true then error("ConstraintVerdictSet must be complete",3) end
            unique(values.verdictIds,"verdict identity")
            unique(values.mandatoryConstraintIds,"constraint identity")
        end
    )
)
