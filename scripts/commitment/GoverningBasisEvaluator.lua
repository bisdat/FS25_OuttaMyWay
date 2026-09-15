--- Interprets authoritative Governing Basis evidence into continuation or canonical Resolution terminal meaning.
-- Specification Jurisdictions: `RESOLUTION_LIFECYCLE`

OuttaMyWay.GoverningBasisEvaluator = {}
local Evaluator = OuttaMyWay.GoverningBasisEvaluator
Evaluator.__index = Evaluator

-- Terminal support and Governing-Basis cessation are separate axes.  A Resolution
-- can fail or escalate while the reason for the Resolution remains physically true.
local terminalEvents = {
    OBJECTIVE_SATISFIED={disposition="SUCCEEDED",cause="OBJECTIVE_SATISFIED",basisCessation=false},
    OBJECTIVE_FAILED={disposition="FAILED",cause="OBJECTIVE_FAILED",basisCessation=false},
    CENTROID_STRATEGY_EXHAUSTED={disposition="FAILED",cause="CENTROID_STRATEGY_EXHAUSTED",basisCessation=false},
    NEW_AUTHORITATIVE_INTENT={disposition="SUPERSEDED_BY_NEW_INTENT",cause="NEW_AUTHORITATIVE_INTENT",basisCessation=true},
    PLAYER_CLAIM={disposition="SUPERSEDED_BY_NEW_INTENT",cause="PLAYER_CLAIM",basisCessation=true},
    SOURCE_INTENT_TERMINATED={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="SOURCE_INTENT_TERMINATED",basisCessation=true},
    PLAYER_TAKEOVER={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="PLAYER_TAKEOVER",basisCessation=true},
    GIANTS_ABORT={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="GIANTS_ABORT",basisCessation=true},
    GIANTS_FAULT={disposition="CANCELLED_BY_SOURCE_INTENT_TERMINATION",cause="GIANTS_FAULT",basisCessation=true},
    OPERATION_TERMINATED={disposition="CANCELLED_BY_OPERATION_TERMINATION",cause="OPERATION_TERMINATED",basisCessation=true}
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
    local terminalSupported=directive~=nil
    local basisCessationSupported=directive~=nil and directive.basisCessation==true
    local reason
    if terminalSupported then
        reason=basisCessationSupported
            and "Authoritative event supports terminal settlement through Governing Basis cessation"
            or "Authoritative event supports terminal settlement without Governing Basis cessation"
    else
        reason="Event requires continuation or reassessment and does not support terminal settlement"
    end
    local values = {
        identity=self.identities:issue("GOVERNING_BASIS_VERDICT"),
        epoch=self.epochs:next(),
        commitmentId=commitment.identity,
        eventKind=event.kind,
        terminalSupported=terminalSupported,
        invalidated=basisCessationSupported,
        intendedTerminalDisposition=directive and directive.disposition or nil,
        terminalCause=directive and directive.cause or nil,
        reason=reason,
        evidence=event.evidence or {},
        provenance=event.provenance or {}
    }
    self.publishedCount=self.publishedCount+1
    return OuttaMyWay.GoverningBasisVerdict.new(values)
end
function Evaluator:getPublishedCount() return self.publishedCount end
