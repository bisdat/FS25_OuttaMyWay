--- Connects Bypass Decision, responsibility, Bubble protection, bounded dispatch and terminal settlement.
-- Specification Jurisdictions: `BOUNDED_BYPASS`
OuttaMyWay.BoundedBypassRuntime={}
local Integration=OuttaMyWay.BoundedBypassRuntime
Integration.__index=Integration
local E=OuttaMyWay.BoundedBypassEvidence
local V=OuttaMyWay.ValueRecord
local publication=OuttaMyWay.LogPublication.origin("RESPONSIBILITY_TRANSITION")
function Integration.new(runtime) return setmetatable({runtime=runtime,currentByOperation={}},Integration) end
function Integration:observe(processed)
    for _,situation in V.ipairs(processed.picture.situations or {}) do
        self.currentByOperation[situation.operationId]={picture=processed.picture,snapshot=processed.snapshot}
    end
end
function Integration:complete(result)
    local runtime=self.runtime
    local event=result.event or (result.status=="SUCCEEDED" and "OBJECTIVE_SATISFIED" or "OBJECTIVE_FAILED")
    local terminal=OuttaMyWay.BoundedBypassCommitmentLifecycle.settle(runtime,result.commitmentId,event,
        {kind=result.reason,playerEscalation=event=="OBJECTIVE_FAILED"})
    if terminal~=nil then runtime.bubbleBulletTime:releaseForCommitment(result.commitmentId,"BOUNDED_BYPASS_TERMINAL") end
    if event=="OBJECTIVE_FAILED" then
        publication:warning("NORMAL","PLAYER_INTERVENTION_REQUIRED","commitment=%s purpose=BOUNDED_BYPASS reason=%s",result.commitmentId,tostring(result.reason))
    end
end
function Integration:dispatch(picture,evaluated,candidate,bridge)
    local runtime=self.runtime
    local control=runtime.liveControlDispatcher.boundedBypassControl
    if control==nil or control:isActive() then return {status="NO_DISPATCH",reason="BYPASS_CONTROL_UNAVAILABLE"} end
    local applied,reason=runtime.responsibilityTransitionAuthority:transitionBoundedBypassResolution(picture,evaluated,
        {status="BOUNDED_BYPASS_RESPONSIBILITY_TRANSITION_REQUIRED",candidateId=candidate.identity,bypassKey=bridge.bypassKey},
        runtime.boundedBypassResponsibilityTransition)
    if applied==nil then return {status="NO_DISPATCH",reason=reason} end
    local function fail(why)
        self:complete({status="FAILED",commitmentId=applied.commitment.identity,reason=why})
        return {status="REJECTED",reason=why,commitment=runtime.commitments:get(applied.commitment.identity)}
    end
    local leases={}
    for _,id in V.ipairs(E.members(picture,bridge.operationId)) do
        if id~=bridge.assemblyId then
            local hold=bridge.blocker.kind=="ACTIVE_BLOCKER_HOLD" and id==bridge.blocker.assemblyId
            leases[#leases+1]={assemblyId=id,maxSpeedKmh=hold and 0 or 1,
                ownerTag=hold and "BYPASS_BLOCKER_HOLD" or "BYPASS_BUBBLE_BULLET_TIME",
                governingPurpose="BOUNDED_BYPASS_PROTECTION",role=hold and "BLOCKER_HOLD" or "BULLET_TIME"}
        end
    end
    local protection,protectionReason=runtime.bubbleBulletTime:prepareProtection(picture,applied,
        {operationId=bridge.operationId,leaseSpecs=leases,releaseWhenAssemblyLeaves={bridge.assemblyId},
            logCodePrefix="BYPASS_BUBBLE",provenanceSource="BoundedBypassRuntime"})
    if protection==nil then return fail(protectionReason) end
    local target={kind="BOUNDED_BYPASS",bridge=bridge}
    local grant,grantReason=runtime:_authorizeBoundedAuthority(applied.currentResponsibility,applied.commitment,applied.authorityToken,
        {assemblyId=bridge.assemblyId,capability="REPOSITION",target=target,
            operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
            preconditions=candidate.preconditions,invalidationConditions=candidate.invalidationConditions,
            provenance={source="BoundedBypassRuntime",candidateId=candidate.identity}})
    if grant==nil then return fail(grantReason) end
    local request,requestReason=runtime:_materializeBoundedAuthorityRequest(picture,evaluated,candidate,grant,target)
    if request==nil then return fail(requestReason) end
    local protected,activationReason=runtime.bubbleBulletTime:activatePrepared(applied.commitment.identity,request,candidate)
    if protected==nil then return fail(activationReason) end
    local started,result=runtime.liveControlDispatcher:dispatch(request,candidate)
    if not started then return fail(result) end
    runtime.liveControlDispatcher:notifyAccepted(request,{kind="BOUNDED_BYPASS_CONTROL_ACCEPTED"})
    return {status="ACCEPTED",request=request,commitment=applied.commitment,currentResponsibility=applied.currentResponsibility,candidate=candidate}
end
