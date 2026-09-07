-- D-0218 integration seam for generic Causal Obstruction relocation.
-- It composes new Observation/Candidate/Responsibility/Control modules around
-- the accepted Runtime without changing the validated warm D-0147 path.

local Runtime=OuttaMyWay.Runtime
local LiveObservationSource=OuttaMyWay.LiveObservationSource

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION] %s",message) else print("[FS25_OuttaMyWay][OBSTRUCTION-RELOCATION][WARNING] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated and evaluated.candidates or {}) do
        if candidate.identity==selectedId then return candidate end
    end
    return nil
end

local function relocationBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.obstructionRelocationBridge or nil
    if type(bridge)=="table" and bridge.architecture=="CAUSAL_OBSTRUCTION_RELOCATION" and type(bridge.relocationKey)=="string" then return bridge end
    return nil
end

local CompositeCandidateSupport={}
CompositeCandidateSupport.__index=CompositeCandidateSupport
function CompositeCandidateSupport.new(genericSupport,legacySupport)
    return setmetatable({genericSupport=genericSupport,legacySupport=legacySupport},CompositeCandidateSupport)
end
function CompositeCandidateSupport:attach(picture,snapshot)
    local generic=self.genericSupport and self.genericSupport:attach(picture,snapshot) or nil
    if generic~=nil then return generic end
    return self.legacySupport and self.legacySupport:attach(picture,snapshot) or nil
end
function CompositeCandidateSupport:getPublishedCount()
    return (self.genericSupport and self.genericSupport:getPublishedCount() or 0)+(self.legacySupport and self.legacySupport:getPublishedCount() or 0)
end
function CompositeCandidateSupport:getLastStatus()
    local genericStatus=self.genericSupport and self.genericSupport:getLastStatus() or nil
    if genericStatus~=nil and genericStatus~="INACTIVE" and genericStatus~="NO_GENERIC_CAUSAL_OBSTRUCTION_ACTION" then return genericStatus end
    return self.legacySupport and self.legacySupport:getLastStatus() or genericStatus
end

-- Augment raw Observation before RuntimeObservationAdapter seals it. Current
-- physical pose is separate from current conflict representation and grants no
-- Situation or actuation authority by itself.
local originalSourceCapture=LiveObservationSource.capture
function LiveObservationSource:capture(mission,nowSeconds)
    local observations=originalSourceCapture(self,mission,nowSeconds)
    if self.currentPhysicalPoseSource~=nil then
        for _,raw in OuttaMyWay.ValueRecord.ipairs(observations or {}) do
            self.currentPhysicalPoseSource:observe(raw,self)
        end
    end
    return observations
end

-- Runtime construction remains explicit. The generic support is evaluated
-- before warm D-0147 only because its creation path explicitly excludes
-- assemblies already represented by Terminal Occupancy knowledge.
local originalRuntimeNew=Runtime.new
function Runtime.new()
    local runtime=originalRuntimeNew()
    runtime.currentPhysicalPoseSource=OuttaMyWay.CurrentPhysicalPoseSource.new()
    runtime.liveObservationSource.currentPhysicalPoseSource=runtime.currentPhysicalPoseSource
    runtime.obstructionRelocationCandidateSupport=OuttaMyWay.ObstructionRelocationCandidateSupport.new(runtime.identities,runtime.epochs)
    runtime.legacyTerminalEgressCandidateSupport=runtime.terminalEgressCandidateSupport
    runtime.terminalEgressCandidateSupport=CompositeCandidateSupport.new(runtime.obstructionRelocationCandidateSupport,runtime.legacyTerminalEgressCandidateSupport)
    runtime.obstructionRelocationResponsibilityTransition=OuttaMyWay.ObstructionRelocationResponsibilityTransition.new(runtime)
    return runtime
end

function Runtime:setObstructionRelocationControl(control)
    self.liveControlDispatcher:setObstructionRelocationControl(control)
    if control~=nil and type(control.setCompletionHandler)=="function" then
        control:setCompletionHandler(function(result) self:onObstructionRelocationCompletion(result) end)
    end
end

function Runtime:_obstructionRelocationRequest(picture,evaluated,candidate,applied,bridge)
    local target={kind="CAUSAL_OBSTRUCTION_RELOCATION",relocationKey=bridge.relocationKey,phase=bridge.phase,objective=bridge.objective}
    local grant,grantReason=self:_authorizeBoundedAuthority(applied.currentResponsibility,applied.commitment,applied.authorityToken,{
        assemblyId=bridge.blockerAssemblyId,
        capability="REPOSITION",
        target=target,
        operationalPictureEpoch=picture.epoch,
        evidenceEpoch=evaluated.decision.epoch,
        preconditions=candidate.preconditions or {},
        invalidationConditions=candidate.invalidationConditions or {},
        provenance={source="ObstructionRelocationRuntimeIntegration",candidateId=candidate.identity,relocationKey=bridge.relocationKey,authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false}
    })
    if grant==nil then return nil,grantReason end
    return self:_materializeBoundedAuthorityRequest(picture,evaluated,candidate,grant,target)
end

function Runtime:onObstructionRelocationCompletion(result)
    if type(result)~="table" or type(result.commitmentId)~="string" then return end
    self.regulationBoundedAuthority:_releaseD0147ProtectedYield(result.commitmentId,"OBSTRUCTION_RELOCATION_CONTROL_"..tostring(result.status))
    if type(result.boundedAuthorityId)=="string" then self.boundedAuthority:release(result.boundedAuthorityId,"OBSTRUCTION_RELOCATION_CONTROL_"..tostring(result.status)) end

    if result.status=="MANOEUVRE_COMPLETE" then
        logInfo("MANOEUVRE_COMPLETE commitment=%s relocation=%s freshSituationRequired=true semanticResolutionNotInferred=true",tostring(result.commitmentId),tostring(result.relocationKey))
        return
    end

    local eventKind=nil
    if result.status=="FAILED" then eventKind="OBJECTIVE_FAILED"
    elseif result.status=="PLAYER_CLAIM" then eventKind="PLAYER_CLAIM"
    elseif result.status=="SUPERSEDED" then eventKind="NEW_AUTHORITATIVE_INTENT" end
    if eventKind~=nil then
        local terminal,reason=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,result.commitmentId,eventKind,result.evidence)
        if terminal==nil then logWarning("CONTROL_SETTLEMENT_FAILED commitment=%s event=%s reason=%s",tostring(result.commitmentId),tostring(eventKind),tostring(reason)) end
    end
end

local originalRuntimeDispatch=Runtime.dispatchEvaluatedOperationalPicture
function Runtime:dispatchEvaluatedOperationalPicture(picture,evaluated)
    local candidate=selectedCandidate(evaluated)
    local bridge=relocationBridge(candidate)
    if bridge==nil then return originalRuntimeDispatch(self,picture,evaluated) end

    local boundary=evaluated.candidateInventory and evaluated.candidateInventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="CAUSAL_OBSTRUCTION_RELOCATION_TEST" then
        return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_SUPPORT_BOUNDARY_MISMATCH"}
    end

    if bridge.terminalEvent~=nil then
        local commitmentId=bridge.existingCommitmentId
        if type(commitmentId)~="string" then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_SETTLEMENT_WITHOUT_COMMITMENT"} end
        self.regulationBoundedAuthority:_releaseD0147ProtectedYield(commitmentId,"OBSTRUCTION_RELOCATION_SITUATION_SETTLEMENT")
        local terminal,reason=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,commitmentId,bridge.terminalEvent,{kind="CAUSAL_OBSTRUCTION_RELOCATION_SITUATION_SETTLEMENT",relocationKey=bridge.relocationKey})
        return {status=terminal and "SETTLED" or "NO_DISPATCH",reason=reason,obstructionRelocation=true,terminalEvent=bridge.terminalEvent,commitment=terminal}
    end

    if bridge.phase=="WAITING_FOR_EVIDENCE" then
        return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_WAITING_FOR_POSITIVE_CONTINUATION",obstructionRelocation=true,commitmentId=bridge.existingCommitmentId}
    end
    if candidate.capability~="REPOSITION" then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_NON_REPOSITION_CANDIDATE",obstructionRelocation=true} end
    local control=self.liveControlDispatcher.obstructionRelocationControl
    if control==nil then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_CONTROL_UNAVAILABLE",obstructionRelocation=true} end
    if type(control.isActive)=="function" and control:isActive() then return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_CONTROL_ALREADY_ACTIVE",obstructionRelocation=true} end

    local readiness={status="OBSTRUCTION_RELOCATION_RESPONSIBILITY_TRANSITION_REQUIRED",candidateId=candidate.identity,relocationKey=bridge.relocationKey}
    -- transitionCompletedObstructionResolution is the existing central Resolution
    -- exposure seam. Despite its legacy name it supplies only RS identity/current
    -- responsibility ownership here; no terminalEpisodeId or completed-Job
    -- provenance enters the generic transition.
    local applied,reason=self.responsibilityTransitionAuthority:transitionCompletedObstructionResolution(
        picture,evaluated,readiness,self.obstructionRelocationResponsibilityTransition)
    if applied==nil then
        return {status="NO_DISPATCH",reason="OBSTRUCTION_RELOCATION_RESPONSIBILITY_APPLICATION_FAILED",detail=reason,obstructionRelocation=true,candidateId=candidate.identity}
    end

    local protected,protectedReason=self.regulationBoundedAuthority:_applyD0147ProtectedYield(
        picture,evaluated,candidate,applied.commitment,applied.currentResponsibility,bridge)
    if protected~=true then
        self.regulationBoundedAuthority:_releaseD0147ProtectedYield(applied.commitment.identity,"OBSTRUCTION_RELOCATION_PROTECTED_YIELD_START_FAILED")
        local terminal=OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,applied.commitment.identity,"OBJECTIVE_FAILED",{kind="OBSTRUCTION_RELOCATION_PROTECTED_YIELD_START_FAILED",reason=protectedReason})
        return {status="REJECTED",reason=protectedReason,obstructionRelocation=true,commitment=terminal or applied.commitment}
    end

    local request,requestReason=self:_obstructionRelocationRequest(picture,evaluated,candidate,applied,bridge)
    if request==nil then
        self.regulationBoundedAuthority:_releaseD0147ProtectedYield(applied.commitment.identity,"OBSTRUCTION_RELOCATION_REQUEST_FAILED")
        OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,applied.commitment.identity,"OBJECTIVE_FAILED",{kind="OBSTRUCTION_RELOCATION_REQUEST_FAILED",reason=requestReason})
        return {status="NO_DISPATCH",reason=requestReason,obstructionRelocation=true,commitment=applied.commitment}
    end

    local started,result=self.liveControlDispatcher:dispatch(request,candidate)
    local outcome=started and self.liveControlDispatcher:notifyAccepted(request,{kind="OBSTRUCTION_RELOCATION_CONTROL_ACCEPTED",authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false})
        or self.liveControlDispatcher:notifyRejected(request,result,{kind="NO_PHYSICAL_EFFECT_CONFIRMED",authorityClass="OBSTRUCTION_RELOCATION_ACTUATION",historicalJobProvenanceRequired=false})
    if started~=true then
        self.boundedAuthority:release(request.boundedAuthorityId,"OBSTRUCTION_RELOCATION_START_REJECTED")
        self.regulationBoundedAuthority:_releaseD0147ProtectedYield(applied.commitment.identity,"OBSTRUCTION_RELOCATION_START_REJECTED")
        local eventKind=result=="PLAYER_CLAIM_AT_CONTROL_BOUNDARY" and "PLAYER_CLAIM" or (result=="SOURCE_AI_REACTIVATED_AT_CONTROL_BOUNDARY" and "NEW_AUTHORITATIVE_INTENT" or "OBJECTIVE_FAILED")
        OuttaMyWay.ObstructionRelocationCommitmentLifecycle.settle(self,applied.commitment.identity,eventKind,{kind="OBSTRUCTION_RELOCATION_START_REJECTED",reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,obstructionRelocation=true,commitment=applied.commitment}
    end

    logInfo("ACCEPTED commitment=%s responsibility=%s relocation=%s blocker=%s request=%s beneficiaries=%d authority=OBSTRUCTION_RELOCATION_ACTUATION",
        tostring(applied.commitment.identity),tostring(applied.currentResponsibility.identity),tostring(bridge.relocationKey),tostring(bridge.blockerAssemblyReferenceKey),tostring(request.identity),OuttaMyWay.ValueRecord.length(bridge.protectedDemandAssemblies or {}))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,currentResponsibility=applied.currentResponsibility,obstructionRelocation=true,result=result}
end
