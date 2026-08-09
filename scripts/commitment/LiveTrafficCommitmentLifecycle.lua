-- FS25_OuttaMyWay v4.7.47 TEST BUILD.
-- Bounded live Commitment lifecycle catch-up for the autonomous initial-head-on
-- test path. It uses the replacement-core Commitment/Obligation/Authority
-- kernel; it does not introduce production Refuge Region or Durable Separation
-- authority.

OuttaMyWay.LiveTrafficCommitmentLifecycle = {}
local Lifecycle = OuttaMyWay.LiveTrafficCommitmentLifecycle

local function logInfo(formatText, ...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then
        Logging.info("[FS25_OuttaMyWay][LIVE-COMMITMENT] %s",message)
    else
        print("[FS25_OuttaMyWay][LIVE-COMMITMENT] "..message)
    end
end

function Lifecycle.applyInitialDecision(runtime, picture, evaluated)
    if runtime==nil or picture==nil or evaluated==nil or evaluated.decision==nil then return nil,"MISSING_CONTEXT" end
    if evaluated.decision.commitmentAction~="CREATE" then return nil,"DECISION_NOT_CREATE" end
    local application=runtime.decisionCommitmentBoundary:apply(picture,evaluated)
    if application==nil or application.commitmentId==nil then return nil,"COMMITMENT_APPLICATION_UNRESOLVED" end
    local record=runtime.commitments:get(application.commitmentId)
    if record==nil then return nil,"COMMITMENT_RECORD_UNAVAILABLE" end
    logInfo("CREATE decision=%s application=%s commitment=%s state=%s obligations=%d authorityTokens=%d responsibility=%s productionControlAuthority=false",
        tostring(evaluated.decision.identity),tostring(application.identity),tostring(record.identity),tostring(record.state),
        #(application.createdObligationIds or {}),#(application.authorityTokenIds or {}),tostring(record.governingBasis and record.governingBasis.responsibilityKey or "n/a"))
    return {application=application,commitment=record},nil
end

local function isRecoveryObligation(obligation)
    local outcome=obligation and obligation.requiredOutcome or nil
    return type(outcome)=="table" and outcome.kind=="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED"
end

function Lifecycle.markActuationStartFailed(runtime, commitmentId, evidence)
    if runtime==nil or commitmentId==nil then return nil,"MISSING_COMMITMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"COMMITMENT_NOT_LIVE" end
    local released=runtime.authorities:releaseForCommitment(commitmentId)
    if record.state=="ACTIVE" then
        record=OuttaMyWay.CommitmentStateMachine.transition(record,"WAITING_FOR_EVIDENCE",{epoch=runtime.epochs:next()},runtime.obligations)
        record=runtime.commitments:save(record)
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    logInfo("ACTUATION_START_FAILED commitment=%s state=%s remainingObligations=%d releasedProgressAuthority=%d responsibilityRetained=true evidence=%s",
        tostring(commitmentId),tostring(record.state),#remaining,#released,tostring(evidence and evidence.reason or "UNSPECIFIED"))
    return {commitment=record,remainingObligations=remaining,releasedAuthorityTokenIds=released},nil
end

function Lifecycle.markNativeReacquisition(runtime, commitmentId, evidence)
    if runtime==nil or commitmentId==nil then return nil,"MISSING_COMMITMENT_CONTEXT" end
    local record=runtime.commitments:get(commitmentId)
    if record==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then return nil,"COMMITMENT_NOT_LIVE" end
    local settled={}
    for _,obligation in OuttaMyWay.ValueRecord.ipairs(runtime.obligations:openForOwner(commitmentId)) do
        if isRecoveryObligation(obligation) then
            runtime.obligations:settle(obligation.identity,"SATISFACTION",evidence or {kind="POSITIVE_GIANTS_REACQUISITION"})
            settled[#settled+1]=obligation.identity
        end
    end
    local released=runtime.authorities:releaseForCommitment(commitmentId)
    record=runtime.commitments:get(commitmentId)
    if record.state=="ACTIVE" then
        record=OuttaMyWay.CommitmentStateMachine.transition(record,"WAITING_FOR_EVIDENCE",{epoch=runtime.epochs:next()},runtime.obligations)
        record=runtime.commitments:save(record)
    end
    local remaining=runtime.obligations:openForOwner(commitmentId)
    logInfo("NATIVE_REACQUISITION commitment=%s state=%s settledRecoveryObligations=%d remainingObligations=%d releasedProgressAuthority=%d trafficSettlementComplete=false",
        tostring(commitmentId),tostring(record.state),#settled,#remaining,#released)
    return {commitment=record,settledObligationIds=settled,remainingObligations=remaining,releasedAuthorityTokenIds=released},nil
end

function Lifecycle.getStatus(runtime, commitmentId)
    if runtime==nil or commitmentId==nil then return nil end
    local record=runtime.commitments:get(commitmentId)
    if record==nil then return nil end
    return {commitment=record,openObligations=runtime.obligations:openForOwner(commitmentId),authorityTokens=runtime.authorities:tokensForCommitment(commitmentId)}
end
