OuttaMyWay.TerminalSettlementEvaluator = {}
local Evaluator = OuttaMyWay.TerminalSettlementEvaluator
Evaluator.__index = Evaluator

function Evaluator.new(epochSequence,commitmentRegistry,obligationLedger,authorityRegistry)
    return setmetatable({epochs=epochSequence,commitments=commitmentRegistry,obligations=obligationLedger,authorities=authorityRegistry},Evaluator)
end

function Evaluator:enterSettling(commitmentId,governingBasisVerdict)
    local record = self.commitments:get(commitmentId)
    if record == nil then error("unknown Commitment " .. tostring(commitmentId),2) end
    OuttaMyWay.ValueRecord.assertType(governingBasisVerdict,"GoverningBasisVerdict")
    if governingBasisVerdict.commitmentId ~= commitmentId then error("Governing Basis verdict belongs to another Commitment",2) end
    if not governingBasisVerdict.invalidated then return {commitment=record,releasedAuthorityTokenIds={}} end
    if record.state == "SETTLING" then
        if record.terminalCause ~= governingBasisVerdict.terminalCause then
            error("first authoritative invalidation already fixed terminal cause",2)
        end
        local released = self.authorities:releaseForCommitment(commitmentId)
        if #released > 0 then
            record = OuttaMyWay.CommitmentStateMachine.revise(record,{progressActuationOwnership={},postJobActuationOwnership={},epoch=self.epochs:next()})
            record = self.commitments:save(record)
        end
        return {commitment=record,releasedAuthorityTokenIds=released}
    end
    if OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then error("terminal Commitment cannot re-enter SETTLING",2) end
    local updated = OuttaMyWay.CommitmentStateMachine.transition(record,"SETTLING",{
        epoch=self.epochs:next(),
        intendedTerminalDisposition=governingBasisVerdict.intendedTerminalDisposition,
        terminalCause=governingBasisVerdict.terminalCause
    },self.obligations)
    updated = self.commitments:save(updated)
    local released = self.authorities:releaseForCommitment(commitmentId)
    if #released > 0 then
        updated = OuttaMyWay.CommitmentStateMachine.revise(updated,{progressActuationOwnership={},postJobActuationOwnership={},epoch=self.epochs:next()})
        updated = self.commitments:save(updated)
    end
    return {commitment=updated,releasedAuthorityTokenIds=released}
end

function Evaluator:attemptTerminal(commitmentId,terminalSettlementEvidence)
    local record = self.commitments:get(commitmentId)
    if record == nil then error("unknown Commitment " .. tostring(commitmentId),2) end
    if record.state ~= "SETTLING" then error("Terminal Settlement requires SETTLING Commitment",2) end
    if self.authorities:hasAnyAuthority(commitmentId) then error("Terminal Settlement rejected while actuation authority remains",2) end
    local terminal = OuttaMyWay.CommitmentStateMachine.transition(record,record.intendedTerminalDisposition,{
        epoch=self.epochs:next(),terminalSettlementEvidence=terminalSettlementEvidence
    },self.obligations)
    return self.commitments:save(terminal)
end
