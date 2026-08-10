-- Architecture-alignment live Control dispatcher.
--
-- This module is the only automatic bridge from a sealed live Decision /
-- Commitment application into the bounded P22 capability donor. Diagnostics do
-- not call the capability gate. The dispatcher does not invent traffic meaning:
-- it accepts only a selected physical Candidate that has already passed the
-- mandatory Constraint set and is admitted/revised through Commitment.

OuttaMyWay.LiveControlDispatcher = {}
local Dispatcher = OuttaMyWay.LiveControlDispatcher
Dispatcher.__index = Dispatcher

local physical = {REGULATE_SPEED=true,HOLD=true,REPOSITION=true}

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][CONTROL-DISPATCH] %s",message) else print("[FS25_OuttaMyWay][CONTROL-DISPATCH] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][CONTROL-DISPATCH] %s",message) else print("[FS25_OuttaMyWay][CONTROL-DISPATCH][WARNING] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    if selectedId==nil then return nil end
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated.candidates or {}) do if candidate.identity==selectedId then return candidate end end
    return nil
end
local function headOnBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.autonomousHeadOnBridge or nil
    if type(bridge)=="table" and type(bridge.yieldParticipantReferenceKey)=="string" then return bridge end
    return nil
end
local function assemblyIdForCandidate(candidate)
    local ownership=candidate and candidate.evidenceBasis and candidate.evidenceBasis.progressActuationOwnership or nil
    local ids=ownership and ownership.assemblyIds or nil
    if type(ids)=="table" and #ids==1 then return ids[1] end
    return nil
end

function Dispatcher.new(runtime)
    return setmetatable({
        runtime=runtime,capability=nil,requests={},outcomes={},dispatchCount=0,
        guardedRecoveryLease=nil,guardedRecoveryApplyCount=0,guardedRecoveryReleaseCount=0,
        followerBoundaryLease=nil,followerBoundaryApplyCount=0,followerBoundaryReleaseCount=0,followerBoundaryUpdateCount=0
    },Dispatcher)
end
function Dispatcher:setCapability(capability) self.capability=capability end
function Dispatcher:getCapabilityObservation()
    if self.capability~=nil and type(self.capability.getControlExecutionObservation)=="function" then
        return self.capability:getControlExecutionObservation()
    end
    return nil
end
function Dispatcher:_outcome(request,status,effect,failure)
    local values={identity=self.runtime.identities:issue("CONTROL_OUTCOME"),requestId=request.identity,status=status,observedPhysicalEffect=effect or {},progress={},provenance={source="LiveControlDispatcher",capability="Prototype22CapabilityGate"},timestamp=(tonumber(g_time) or 0)/1000}
    if failure~=nil then values.failureEvidence=failure end
    local outcome=OuttaMyWay.ControlOutcome.new(values); self.outcomes[#self.outcomes+1]=outcome; return outcome
end
function Dispatcher:_controlRequest(picture,evaluated,candidate,commitment,bridge)
    local assemblyId=assemblyIdForCandidate(candidate)
    if assemblyId==nil then return nil,"SELECTED_PHYSICAL_CANDIDATE_REQUIRES_EXACTLY_ONE_PROGRESS_ACTUATION_ASSEMBLY" end
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(commitment.identity)) do if candidateToken.assemblyId==assemblyId then token=candidateToken break end end
    if token==nil or self.runtime.authorities:validate(token)~=true then return nil,"VALID_COMMITMENT_AUTHORITY_TOKEN_UNAVAILABLE" end
    local request=OuttaMyWay.ControlRequest.new({
        identity=self.runtime.identities:issue("CONTROL_REQUEST"),commitmentId=commitment.identity,assemblyId=assemblyId,capability=candidate.capability,
        target={kind="P22_TS015_REFUGE_REPOSITION",yieldParticipantReferenceKey=bridge.yieldParticipantReferenceKey,progressParticipantReferenceKey=bridge.progressParticipantReferenceKey,pairReferenceKey=bridge.pairReferenceKey,encounterIdentity=bridge.encounterIdentity,governingRequirementKey=bridge.governingRequirementKey},
        authorityToken=token.identity,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
        preconditions=candidate.preconditions or {},invalidationConditions=candidate.invalidationConditions or {}
    })
    self.requests[#self.requests+1]=request; return request,nil
end

local D0123_OWNER_TAG="D0123_GUARDED_RECOVERY"
local D0141_OWNER_TAG="D0141_FOLLOWER_BOUNDARY"

local function guardedRecoveryBridge(candidate)
    local basis=candidate and candidate.evidenceBasis or nil
    local bridge=basis and basis.guardedRecoveryBridge or nil
    if type(bridge)=="table" and type(bridge.commitmentId)=="string" and type(bridge.progressAssemblyId)=="string" then return bridge end
    return nil
end

local function guardedRecoveryRecord(picture,lease)
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.guardedRecoveryKnowledge or {}) do
        if lease==nil or (record.commitmentId==lease.commitmentId and record.progressAssemblyId==lease.progressAssemblyId) then return record end
    end
    return nil
end

local function pictureContainsAssembly(picture,assemblyId)
    for _,id in OuttaMyWay.ValueRecord.ipairs(picture.identities and picture.identities.assemblies or {}) do if id==assemblyId then return true end end
    return false
end

function Dispatcher:_regulationRequest(picture,evaluated,candidate,commitment,token,bridge,operation,ownerTag,maxSpeedKmh)
    ownerTag=ownerTag or D0123_OWNER_TAG
    local speed=maxSpeedKmh
    if operation=="APPLY" and speed==nil then speed=OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_KMH or OuttaMyWay.PROTOTYPE_22_REGULATE_DEFAULT_KMH or 1.0 end
    local assemblyId=bridge.progressAssemblyId or bridge.followerAssemblyId
    local referenceKey=bridge.progressReferenceKey or bridge.followerReferenceKey
    local request=OuttaMyWay.ControlRequest.new({
        identity=self.runtime.identities:issue("CONTROL_REQUEST"),commitmentId=commitment.identity,assemblyId=assemblyId,capability="REGULATE_SPEED",
        target={kind="P22_REGULATION_LEASE",operation=operation,vehicleReferenceKey=referenceKey,ownerTag=ownerTag,
            maxSpeedKmh=operation=="APPLY" and speed or nil,governingPurpose=bridge.governingPurpose},
        authorityToken=token.identity,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
        effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,preconditions=candidate and candidate.preconditions or {},invalidationConditions=candidate and candidate.invalidationConditions or {}
    })
    self.requests[#self.requests+1]=request
    return request
end

local function followerBoundaryBridge(candidate)
    local basis=candidate and candidate.evidenceBasis or nil
    local bridge=basis and basis.followerBoundaryBridge or nil
    if type(bridge)=="table" and type(bridge.pairKey)=="string" and type(bridge.followerAssemblyId)=="string" then return bridge end
    return nil
end

local function followerBoundaryRecord(picture,lease)
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.followerBoundaryKnowledge or {}) do
        if lease==nil or record.pairKey==lease.pairKey then return record end
    end
    return nil
end

function Dispatcher:_otherRegulationPurposeOwnsAuthority(commitmentId,assemblyId,excluding)
    if excluding~="D0123" then
        local lease=self.guardedRecoveryLease
        if lease~=nil and lease.commitmentId==commitmentId and lease.progressAssemblyId==assemblyId then return true end
    end
    if excluding~="D0141" then
        local lease=self.followerBoundaryLease
        if lease~=nil and lease.commitmentId==commitmentId and lease.followerAssemblyId==assemblyId then return true end
    end
    return false
end

function Dispatcher:_releaseFollowerBoundaryLease(picture,evaluated,candidate,bridge,reason)
    local lease=self.followerBoundaryLease
    if lease==nil then return {status="NO_DISPATCH",reason="D0141_NO_ACTIVE_LEASE_TO_RETIRE",followerBoundary=true} end
    local applied,applyReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyFollowerBoundaryRetirementDecision(self.runtime,picture,evaluated)
    if applied==nil then return {status="NO_DISPATCH",reason=applyReason,followerBoundary=true} end
    local commitment=applied.commitment
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.assemblyId==lease.followerAssemblyId then token=candidateToken break end
    end
    local request,outcome=nil,nil
    if token~=nil and self.runtime.authorities:validate(token)==true and self.capability~=nil and type(self.capability.executeControlRequest)=="function" then
        request=self:_regulationRequest(picture,evaluated,candidate,commitment,token,{followerAssemblyId=lease.followerAssemblyId,followerReferenceKey=lease.followerReferenceKey,governingPurpose=lease.governingPurpose},"RELEASE",D0141_OWNER_TAG,nil)
        local ok,result=self.capability:executeControlRequest(request,candidate)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "REGULATION_LEASE_RELEASED" or "REGULATION_RELEASE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG) end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG)
    end
    local preserve=self:_otherRegulationPurposeOwnsAuthority(commitment.identity,lease.followerAssemblyId,"D0141")
    if not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,commitment.identity,lease.followerAssemblyId,{reason=reason,preserveAuthority=preserve})
        OuttaMyWay.LiveTrafficCommitmentLifecycle.settleFollowerBoundaryPurpose(self.runtime,commitment.identity,bridge or lease,{kind="D0141_POSITIVE_RETIREMENT",reason=reason,pairKey=lease.pairKey})
    end
    self.followerBoundaryReleaseCount=self.followerBoundaryReleaseCount+1
    self.followerBoundaryLease=nil
    logInfo("D0141_RELEASE commitment=%s pair=%s follower=%s ref=%s preserveAuthority=%s reason=%s",tostring(commitment.identity),tostring(lease.pairKey),tostring(lease.followerAssemblyId),tostring(lease.followerReferenceKey),tostring(preserve),tostring(reason))
    return {status="RELEASED",reason=reason,request=request,outcome=outcome,followerBoundary=true,commitment=commitment}
end

function Dispatcher:_dispatchFollowerBoundary(picture,evaluated,candidate)
    local bridge=followerBoundaryBridge(candidate)
    local current=self.followerBoundaryLease
    if bridge~=nil and bridge.action=="RETIRE" then
        return self:_releaseFollowerBoundaryLease(picture,evaluated,candidate,bridge,bridge.reason or "D0141_POSITIVE_RETIREMENT")
    end
    if bridge~=nil and bridge.action=="PRESERVE" then
        return {status="NO_DISPATCH",reason="D0141_UNRESOLVED_PRESERVE_EXISTING_REGULATION",followerBoundary=true,commitmentId=bridge.existingCommitmentId}
    end
    if bridge==nil or bridge.action~="APPLY" or candidate.capability~="REGULATE_SPEED" then return nil end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",followerBoundary=true} end
    local applied,applyReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyFollowerBoundaryDecision(self.runtime,picture,evaluated)
    if applied==nil then return {status="NO_DISPATCH",reason=applyReason,followerBoundary=true} end
    local token=applied.authorityToken
    if token==nil or self.runtime.authorities:validate(token)~=true then return {status="NO_DISPATCH",reason="D0141_VALID_AUTHORITY_TOKEN_UNAVAILABLE",followerBoundary=true} end
    local request=self:_regulationRequest(picture,evaluated,candidate,applied.commitment,token,bridge,"APPLY",D0141_OWNER_TAG,bridge.requestedFollowerCapKmh)
    local started,result=self.capability:executeControlRequest(request,candidate)
    if started~=true then
        local preserve=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.followerAssemblyId,"D0141")
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.followerAssemblyId,{reason="D0141_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=preserve}) end
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,followerBoundary=true}
    end
    local update=current~=nil and current.pairKey==bridge.pairKey
    self.followerBoundaryLease={commitmentId=applied.commitment.identity,pairKey=bridge.pairKey,leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        leaderReferenceKey=bridge.leaderReferenceKey,followerReferenceKey=bridge.followerReferenceKey,leaderName=bridge.leaderName,followerName=bridge.followerName,governingPurpose=bridge.governingPurpose,
        authorityTokenId=token.identity,requestId=request.identity,currentCapKmh=bridge.requestedFollowerCapKmh,nativeUnrestrictedFollowerKmh=bridge.nativeUnrestrictedFollowerKmh,
        leaderRateUsedKmh=bridge.leaderRateUsedKmh,transitionPreservation=bridge.transitionPreservation==true}
    if update then self.followerBoundaryUpdateCount=self.followerBoundaryUpdateCount+1 else self.followerBoundaryApplyCount=self.followerBoundaryApplyCount+1 end
    self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind=update and "ELASTIC_REGULATION_MAGNITUDE_UPDATED" or "FOLLOWER_BOUNDARY_REGULATION_ADMITTED",capability="REGULATE_SPEED",maxSpeedKmh=bridge.requestedFollowerCapKmh},nil)
    logInfo("D0141_%s commitment=%s pair=%s follower=%s ref=%s request=%s cap=%.2fkmh native=%.2fkmh leaderRate=%s transition=%s purpose=%s",update and "UPDATE" or "APPLY",tostring(applied.commitment.identity),tostring(bridge.pairKey),tostring(bridge.followerAssemblyId),tostring(bridge.followerReferenceKey),tostring(request.identity),tonumber(bridge.requestedFollowerCapKmh) or 0,tonumber(bridge.nativeUnrestrictedFollowerKmh) or 0,tostring(bridge.leaderRateUsedKmh or "n/a"),tostring(bridge.transitionPreservation==true),tostring(bridge.governingPurpose))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,result=result,followerBoundary=true,elasticUpdate=update}
end

function Dispatcher:getFollowerBoundaryStatus()
    local lease=self.followerBoundaryLease
    return {active=lease~=nil,commitmentId=lease and lease.commitmentId or nil,pairKey=lease and lease.pairKey or nil,
        leaderName=lease and lease.leaderName or nil,followerName=lease and lease.followerName or nil,
        followerReferenceKey=lease and lease.followerReferenceKey or nil,currentCapKmh=lease and lease.currentCapKmh or nil,
        nativeUnrestrictedFollowerKmh=lease and lease.nativeUnrestrictedFollowerKmh or nil,leaderRateUsedKmh=lease and lease.leaderRateUsedKmh or nil,
        transitionPreservation=lease and lease.transitionPreservation==true or false,applyCount=self.followerBoundaryApplyCount,
        updateCount=self.followerBoundaryUpdateCount,releaseCount=self.followerBoundaryReleaseCount,ownerTag=D0141_OWNER_TAG}
end

-- A role-reversed head-on may select the currently regulated follower itself as
-- the new Yield/Reposition worker.  Once the head-on REVISE Decision has been
-- applied, that D-0141 speed lease is no longer compatible with the worker's
-- new role.  Clear only the D-0141 physical lease and settle its follower
-- obligation; the generic same-Commitment AuthorityToken is deliberately kept
-- live and has already been rebound by applyHeadOnDecision to REPOSITION.
function Dispatcher:_supersedeFollowerBoundaryForHeadOn(commitment,candidate)
    local lease=self.followerBoundaryLease
    if lease==nil or commitment==nil or candidate==nil then return nil end
    local yieldAssemblyId=assemblyIdForCandidate(candidate)
    if lease.commitmentId~=commitment.identity or lease.followerAssemblyId~=yieldAssemblyId then return nil end

    if self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG)
    end
    local settled,settleReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleFollowerBoundaryPurpose(self.runtime,commitment.identity,{
        pairKey=lease.pairKey,reason="HEAD_ON_REPOSITION_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION"
    },{kind="D0141_HEAD_ON_ROLE_SUCCESSION",pairKey=lease.pairKey,yieldAssemblyId=yieldAssemblyId})
    if settled==nil then
        logWarning("D0141_HEAD_ON_SUPERSESSION follower=%s commitment=%s pair=%s physicalLeaseCleared=true obligationSettlement=%s",
            tostring(yieldAssemblyId),tostring(commitment.identity),tostring(lease.pairKey),tostring(settleReason))
    else
        logInfo("D0141_HEAD_ON_SUPERSESSION follower=%s commitment=%s pair=%s physicalLeaseCleared=true authorityTokenReusedForYield=true obligation=%s",
            tostring(yieldAssemblyId),tostring(commitment.identity),tostring(lease.pairKey),tostring(settled.settledObligationId or "NONE"))
    end
    self.followerBoundaryReleaseCount=self.followerBoundaryReleaseCount+1
    self.followerBoundaryLease=nil
    return {settled=settled,reason=settleReason,yieldAssemblyId=yieldAssemblyId}
end

function Dispatcher:_releaseGuardedRecoveryLease(picture,evaluated,reason)
    local lease=self.guardedRecoveryLease
    if lease==nil then return nil end
    local commitment=self.runtime.commitments:get(lease.commitmentId)
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(lease.commitmentId)) do
        if candidateToken.assemblyId==lease.progressAssemblyId then token=candidateToken break end
    end
    local request,outcome=nil,nil
    if commitment~=nil and token~=nil and self.runtime.authorities:validate(token)==true and self.capability~=nil and type(self.capability.executeControlRequest)=="function" then
        local syntheticCandidate={preconditions={},invalidationConditions={}}
        request=self:_regulationRequest(picture,evaluated,syntheticCandidate,commitment,token,{
            progressAssemblyId=lease.progressAssemblyId,progressReferenceKey=lease.progressReferenceKey,governingPurpose=lease.governingPurpose
        },"RELEASE")
        local ok,result=self.capability:executeControlRequest(request,nil)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "REGULATION_LEASE_RELEASED" or "REGULATION_RELEASE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.progressReferenceKey,D0123_OWNER_TAG) end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.progressReferenceKey,D0123_OWNER_TAG)
    end
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,lease.commitmentId,lease.progressAssemblyId,{reason=reason,preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(lease.commitmentId,lease.progressAssemblyId,"D0123")})
    end
    self.guardedRecoveryReleaseCount=self.guardedRecoveryReleaseCount+1
    logInfo("D0123_RELEASE commitment=%s progress=%s ref=%s reason=%s",tostring(lease.commitmentId),tostring(lease.progressAssemblyId),tostring(lease.progressReferenceKey),tostring(reason))
    self.guardedRecoveryLease=nil
    return {status="RELEASED",reason=reason,request=request,outcome=outcome}
end

function Dispatcher:_dispatchGuardedRecovery(picture,evaluated,candidate)
    local currentLease=self.guardedRecoveryLease
    local record=guardedRecoveryRecord(picture,currentLease)
    if currentLease~=nil then
        if record~=nil then
            if record.signalStatus=="NEGATIVE" or record.signalStatus=="INVALIDATED" or record.signalStatus=="EXPIRED" then
                return self:_releaseGuardedRecoveryLease(picture,evaluated,record.reason or record.signalStatus)
            elseif record.signalStatus=="UNRESOLVED" then
                return {status="NO_DISPATCH",reason="D0123_UNRESOLVED_PRESERVE_EXISTING_REGULATION",guardedRecovery=true}
            end
        elseif pictureContainsAssembly(picture,currentLease.progressAssemblyId) and pictureContainsAssembly(picture,currentLease.yieldAssemblyId) then
            return self:_releaseGuardedRecoveryLease(picture,evaluated,"GUARDED_RECOVERY_CONTEXT_NOT_OBSERVED")
        end
    end

    local bridge=guardedRecoveryBridge(candidate)
    if bridge==nil then return nil end
    if bridge.signalStatus~="POSITIVE" or candidate.capability~="REGULATE_SPEED" then
        return {status="NO_DISPATCH",reason="D0123_OBSERVE_REMAINS_PRIMARY",guardedRecovery=true,signalStatus=bridge.signalStatus}
    end
    if currentLease~=nil and currentLease.commitmentId==bridge.commitmentId and currentLease.progressAssemblyId==bridge.progressAssemblyId then
        return {status="MAINTAINED",reason="D0123_POSITIVE_PURPOSE_PERSISTS",guardedRecovery=true,commitmentId=bridge.commitmentId}
    end
    if currentLease~=nil then self:_releaseGuardedRecoveryLease(picture,evaluated,"GUARDED_RECOVERY_CONTEXT_CHANGED") end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",guardedRecovery=true} end

    local acquired,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.acquireSupportingRegulationAuthority(self.runtime,bridge.commitmentId,bridge.progressAssemblyId,{governingPurpose=bridge.governingPurpose})
    if acquired==nil then return {status="NO_DISPATCH",reason=reason,guardedRecovery=true,commitmentId=bridge.commitmentId} end
    local request=self:_regulationRequest(picture,evaluated,candidate,acquired.commitment,acquired.authorityToken,bridge,"APPLY")
    local started,result=self.capability:executeControlRequest(request,candidate)
    if started~=true then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,bridge.commitmentId,bridge.progressAssemblyId,{reason="D0123_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(bridge.commitmentId,bridge.progressAssemblyId,"D0123")})
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,guardedRecovery=true}
    end
    self.guardedRecoveryLease={commitmentId=bridge.commitmentId,yieldAssemblyId=bridge.yieldAssemblyId,progressAssemblyId=bridge.progressAssemblyId,progressReferenceKey=bridge.progressReferenceKey,governingPurpose=bridge.governingPurpose,authorityTokenId=acquired.authorityToken.identity,requestId=request.identity}
    self.guardedRecoveryApplyCount=self.guardedRecoveryApplyCount+1; self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind="BOUNDED_REGULATION_DISPATCH_ACCEPTED",capability="REGULATE_SPEED"},nil)
    logInfo("D0123_APPLY commitment=%s progress=%s ref=%s request=%s speedLiteral=%.2fkmh purpose=%s",tostring(bridge.commitmentId),tostring(bridge.progressAssemblyId),tostring(bridge.progressReferenceKey),tostring(request.identity),tonumber(request.target.maxSpeedKmh) or 0,tostring(bridge.governingPurpose))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=acquired.commitment,candidate=candidate,result=result,guardedRecovery=true}
end

function Dispatcher:getGuardedRecoveryStatus()
    local lease=self.guardedRecoveryLease
    return {active=lease~=nil,commitmentId=lease and lease.commitmentId or nil,progressReferenceKey=lease and lease.progressReferenceKey or nil,applyCount=self.guardedRecoveryApplyCount,releaseCount=self.guardedRecoveryReleaseCount,ownerTag=D0123_OWNER_TAG}
end

function Dispatcher:dispatch(picture,evaluated)
    if picture==nil or evaluated==nil or evaluated.decision==nil then return {status="NO_DISPATCH",reason="MISSING_SEALED_DECISION"} end
    local candidate=selectedCandidate(evaluated)
    local followerBridge=followerBoundaryBridge(candidate)
    if followerBridge~=nil and followerBridge.action=="RETIRE" then
        return self:_dispatchFollowerBoundary(picture,evaluated,candidate)
    end
    local guarded=self:_dispatchGuardedRecovery(picture,evaluated,candidate)
    if guarded~=nil then return guarded end
    local follower=self:_dispatchFollowerBoundary(picture,evaluated,candidate)
    if follower~=nil then return follower end
    if candidate==nil or physical[candidate.capability]~=true then return {status="NO_DISPATCH",reason="NO_SELECTED_PHYSICAL_CANDIDATE"} end
    -- D-0141 follower Regulation is aligned through Situation/Candidate/Decision/
    -- Commitment/central Control. Committed-transition D-0131/D-0133 remains shadow.
    local bridge=headOnBridge(candidate)
    if candidate.capability~="REPOSITION" or bridge==nil then return {status="NO_DISPATCH",reason="PHYSICAL_CANDIDATE_NOT_YET_ALIGNED_FOR_LIVE_CONTROL",candidateId=candidate.identity} end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",candidateId=candidate.identity} end
    local inventory=evaluated.candidateInventory; local boundary=inventory and inventory.supportBoundary or nil
    local independentHeadOnSupported=type(boundary)=="table" and boundary.mode=="AUTONOMOUS_HEAD_ON_RESOLUTION_TEST"
    local disposition="ALLOW"
    if type(self.capability.getAutonomousHeadOnAvailability)=="function" then disposition=self.capability:getAutonomousHeadOnAvailability(independentHeadOnSupported) end
    if disposition=="BLOCK_ACTIVE_REFUGE_RESOLUTION" or disposition=="BLOCK_PRIOR_REFUGE_HANDOFF_UNRESOLVED" or disposition=="BLOCK_NO_INDEPENDENT_HEAD_ON_SUPPORT" then return {status="NO_DISPATCH",reason=disposition,candidateId=candidate.identity} end
    if disposition=="ALLOW_SUPERSEDE_PRIOR_REFUGE_MONITOR_AFTER_INDEPENDENT_HEAD_ON_SUPPORT" and type(self.capability.supersedePriorRefugeMonitorForCurrentHeadOn)=="function" then self.capability:supersedePriorRefugeMonitorForCurrentHeadOn() end

    local applied,applyReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyHeadOnDecision(self.runtime,picture,evaluated)
    if applied==nil then logWarning("REFUSED decision=%s candidate=%s reason=COMMITMENT_APPLICATION_FAILED detail=%s",tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(applyReason)); return {status="NO_DISPATCH",reason="COMMITMENT_APPLICATION_FAILED",detail=applyReason,candidateId=candidate.identity} end
    local commitment=applied.commitment
    -- v4.7.75: if this exact Yield assembly was the active D-0141 follower, the
    -- positive head-on strategy has now superseded that speed-control role.
    -- Keep the generic same-Commitment authority token, but remove the physical
    -- D-0141 cap before starting the Yield/Reposition manoeuvre.
    self:_supersedeFollowerBoundaryForHeadOn(commitment,candidate)
    local request,requestReason=self:_controlRequest(picture,evaluated,candidate,commitment,bridge)
    if request==nil then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.markActuationStartFailed(self.runtime,commitment.identity,{reason=requestReason,source="LiveControlDispatcher"})
        return {status="NO_DISPATCH",reason=requestReason,candidateId=candidate.identity,commitmentId=commitment.identity}
    end
    local started,result=false,"CAPABILITY_REJECTED"
    if type(self.capability.executeControlRequest)=="function" then started,result=self.capability:executeControlRequest(request,candidate) end
    if started~=true then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.markActuationStartFailed(self.runtime,commitment.identity,{reason=tostring(result),source="LiveControlDispatcher.executeControlRequest",requestId=request.identity})
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        logWarning("REJECTED request=%s commitment=%s candidate=%s detail=%s",tostring(request.identity),tostring(commitment.identity),tostring(candidate.identity),tostring(result))
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,commitment=commitment,candidate=candidate}
    end
    self.dispatchCount=self.dispatchCount+1
    if self.runtime~=nil and type(self.runtime.markAutonomousHeadOnDispatched)=="function" then self.runtime:markAutonomousHeadOnDispatched(bridge.governingRequirementKey) end
    local outcome=self:_outcome(request,"ACCEPTED",{kind="BOUNDED_REPOSITION_DISPATCH_ACCEPTED",capability="REPOSITION"},nil)
    logInfo("ACCEPTED decision=%s candidate=%s commitment=%s request=%s yieldRef=%s progressRef=%s result=%s",tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(commitment.identity),tostring(request.identity),tostring(bridge.yieldParticipantReferenceKey),tostring(bridge.progressParticipantReferenceKey),tostring(result))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=commitment,candidate=candidate,result=result}
end
function Dispatcher:getDispatchCount() return self.dispatchCount end
function Dispatcher:getRequests() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.requests) do out[#out+1]=v end; return out end
function Dispatcher:getOutcomes() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.outcomes) do out[#out+1]=v end; return out end
