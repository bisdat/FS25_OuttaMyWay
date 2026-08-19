OuttaMyWay.GoverningBasisEvaluator = {}
local Evaluator = OuttaMyWay.GoverningBasisEvaluator
Evaluator.__index = Evaluator

local terminalEvents = {
    OBJECTIVE_SATISFIED={disposition="SUCCEEDED",cause="OBJECTIVE_SATISFIED"},
    OBJECTIVE_FAILED={disposition="FAILED",cause="OBJECTIVE_FAILED"},
    NEW_AUTHORITATIVE_INTENT={disposition="SUPERSEDED_BY_NEW_INTENT",cause="NEW_AUTHORITATIVE_INTENT"},
    PLAYER_CLAIM={disposition="SUPERSEDED_BY_NEW_INTENT",cause="PLAYER_CLAIM"},
    SOURCE_INTENT_TERMINATED={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="SOURCE_INTENT_TERMINATED"},
    PLAYER_TAKEOVER={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="PLAYER_TAKEOVER"},
    GIANTS_ABORT={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="GIANTS_ABORT"},
    GIANTS_FAULT={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="GIANTS_FAULT"},
    OPERATION_TERMINATED={disposition="CANCELLED_BY_OPERATION_TERMINATION",cause="OPERATION_TERMINATED"}
}
local continuingEvents = {
    BLOCKED=true,
    OUTTAMYWAY_HOLD=true,
    TEMPORARY_INACTIVITY=true,
    MISSING_EVIDENCE=true,
    INTENT_EXPIRY=true
}

function Evaluator.new(identityRegistry,epochSequence)
    return setmetatable({identities=identityRegistry,epochs=epochSequence,publishedCount=0},Evaluator)
end

function Evaluator:evaluate(commitment,event)
    OuttaMyWay.ValueRecord.assertType(commitment,"CommitmentRecord")
    if type(event) ~= "table" or type(event.kind) ~= "string" then error("Governing Basis event requires kind",2) end
    local directive = terminalEvents[event.kind]
    if directive == nil and not continuingEvents[event.kind] then error("unsupported Governing Basis event " .. event.kind,2) end
    local values = {
        identity=self.identities:issue("GOVERNING_BASIS_VERDICT"),
        epoch=self.epochs:next(),
        commitmentId=commitment.identity,
        eventKind=event.kind,
        invalidated=directive ~= nil,
        intendedTerminalDisposition=directive and directive.disposition or nil,
        terminalCause=directive and directive.cause or nil,
        reason=directive and "Authoritative event invalidated Governing Basis" or "Event requires continuation or reassessment and does not end Governing Basis",
        evidence=event.evidence or {},
        provenance=event.provenance or {}
    }
    self.publishedCount=self.publishedCount+1
    return OuttaMyWay.GoverningBasisVerdict.new(values)
end
function Evaluator:getPublishedCount() return self.publishedCount end
