OuttaMyWay.GoverningBasisVerdict = OuttaMyWay.ValueRecord.register(
    "GoverningBasisVerdict",
    OuttaMyWay.ValueRecord.define(
        "GoverningBasisVerdict",
        {"identity","epoch","commitmentId","eventKind","invalidated","reason","evidence","provenance"},
        {"intendedTerminalDisposition","terminalCause"},
        function(values)
            if type(values.invalidated) ~= "boolean" then error("GoverningBasisVerdict invalidated must be boolean",3) end
            if values.invalidated then
                if values.intendedTerminalDisposition == nil or values.terminalCause == nil then
                    error("invalidated Governing Basis requires terminal disposition and cause",3)
                end
            elseif values.intendedTerminalDisposition ~= nil or values.terminalCause ~= nil then
                error("valid Governing Basis cannot publish a terminal directive",3)
            end
        end
    )
)
