OuttaMyWay.CommitmentStateMachine = {}
local StateMachine = OuttaMyWay.CommitmentStateMachine

StateMachine.NON_TERMINAL = {
    ACTIVE = true,
    WAITING_FOR_EVIDENCE = true,
    SETTLING = true
}
StateMachine.TERMINAL = {
    SUCCEEDED = true,
    FAILED = true,
    SUPERSEDED_BY_NEW_INTENT = true,
    CANCELLED_BY_SOURCE_INTENT_TERMINATION = true,
    CANCELLED_BY_OPERATION_TERMINATION = true
}

local legal = {
    ACTIVE = { WAITING_FOR_EVIDENCE=true, SETTLING=true },
    WAITING_FOR_EVIDENCE = { ACTIVE=true, SETTLING=true },
    SETTLING = {
        SUCCEEDED=true,
        FAILED=true,
        SUPERSEDED_BY_NEW_INTENT=true,
        CANCELLED_BY_SOURCE_INTENT_TERMINATION=true,
        CANCELLED_BY_OPERATION_TERMINATION=true
    }
}

function StateMachine.isTerminal(state)
    return StateMachine.TERMINAL[state] == true
end

function StateMachine.canTransition(fromState, toState)
    return legal[fromState] ~= nil and legal[fromState][toState] == true
end

function StateMachine.transition(record, toState, context, obligationLedger)
    OuttaMyWay.ValueRecord.assertType(record, "CommitmentRecord")
    context = context or {}
    if not StateMachine.canTransition(record.state, toState) then
        error("illegal Commitment transition " .. tostring(record.state) .. " -> " .. tostring(toState), 2)
    end

    local changes = {
        state = toState,
        epoch = context.epoch or record.epoch,
        revision = record.revision + 1
    }

    if toState == "SETTLING" then
        if not StateMachine.TERMINAL[context.intendedTerminalDisposition] then
            error("SETTLING requires one canonical intended terminal disposition", 2)
        end
        if context.terminalCause == nil then error("SETTLING requires a terminal cause", 2) end
        if record.terminalCause ~= nil and record.terminalCause ~= context.terminalCause then
            error("first authoritative invalidation already fixed terminal cause", 2)
        end
        changes.intendedTerminalDisposition = context.intendedTerminalDisposition
        changes.terminalCause = context.terminalCause
    elseif StateMachine.TERMINAL[toState] then
        if record.intendedTerminalDisposition ~= toState then
            error("terminal disposition does not match the intended disposition", 2)
        end
        if obligationLedger == nil then error("terminal transition requires an ObligationLedger", 2) end
        if obligationLedger:hasOpenObligations(record.identity) then
            error("terminal transition rejected while obligations remain open", 2)
        end
        if context.terminalSettlementEvidence == nil then
            error("terminal transition requires settlement evidence", 2)
        end
        changes.terminalSettlementEvidence = context.terminalSettlementEvidence
    end

    return OuttaMyWay.ValueRecord.update(record, changes)
end

function StateMachine.revise(record, changes)
    OuttaMyWay.ValueRecord.assertType(record, "CommitmentRecord")
    if StateMachine.isTerminal(record.state) then error("terminal Commitment cannot be revised", 2) end
    changes = changes or {}
    if changes.state ~= nil and changes.state ~= record.state then
        error("lifecycle state may change only through transition", 2)
    end
    changes.state = record.state
    changes.identity = record.identity
    changes.revision = record.revision + 1
    changes.epoch = changes.epoch or record.epoch
    return OuttaMyWay.ValueRecord.update(record, changes)
end
