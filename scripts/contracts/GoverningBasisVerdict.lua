-- Terminal support and Governing-Basis cessation are independent conclusions.
-- `invalidated` means Governing-Basis cessation only; it is not a generic terminal gate.
OuttaMyWay.GoverningBasisVerdict = OuttaMyWay.ValueRecord.register(
    "GoverningBasisVerdict",
    OuttaMyWay.ValueRecord.define(
        "GoverningBasisVerdict",
        {"identity","epoch","commitmentId","eventKind","terminalSupported","invalidated","reason","evidence","provenance"},
        {"intendedTerminalDisposition","terminalCause"},
        function(values)
            if type(values.terminalSupported) ~= "boolean" then error("GoverningBasisVerdict terminalSupported must be boolean",3) end
            if type(values.invalidated) ~= "boolean" then error("GoverningBasisVerdict invalidated must be boolean",3) end
            if values.invalidated and not values.terminalSupported then
                error("Governing Basis cessation cannot be published without terminal support",3)
            end
            if values.terminalSupported then
                if values.intendedTerminalDisposition == nil or values.terminalCause == nil then
                    error("terminal-supported Governing Basis verdict requires terminal disposition and cause",3)
                end
            elseif values.intendedTerminalDisposition ~= nil or values.terminalCause ~= nil then
                error("non-terminal Governing Basis verdict cannot publish a terminal directive",3)
            end
        end
    )
)
