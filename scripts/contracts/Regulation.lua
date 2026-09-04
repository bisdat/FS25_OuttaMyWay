OuttaMyWay.Regulation = OuttaMyWay.ValueRecord.register(
    "Regulation",
    OuttaMyWay.ValueRecord.define(
        "Regulation",
        {"identity","kind","governingBasis","provenance"},
        {},
        function(values)
            if type(values.identity)~="string" or values.identity=="" then error("Regulation requires responsibility identity",3) end
            if values.kind~="REGULATION" then error("Regulation has invalid kind",3) end
            if type(values.governingBasis)~="table" or type(values.provenance)~="table" then
                error("Regulation requires governing basis and provenance",3)
            end
        end
    )
)
