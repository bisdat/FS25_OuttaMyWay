-- Bounded Authority specialisation for live Regulation physical permissions.
-- It preserves the proven Regulation policies and request shapes while
-- LiveControlDispatcher routes only already-authorised requests.

OuttaMyWay.RegulationBoundedAuthority = {}
local Authority = OuttaMyWay.RegulationBoundedAuthority
Authority.__index = Authority

local D0147_PROTECTED_YIELD_OWNER_TAG="D0147_PROTECTED_YIELD"

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][REGULATION-AUTHORITY] %s",message) else print("[FS25_OuttaMyWay][REGULATION-AUTHORITY] "..message) end
end
local function logWarning(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.warning)=="function" then Logging.warning("[FS25_OuttaMyWay][REGULATION-AUTHORITY] %s",message) else print("[FS25_OuttaMyWay][REGULATION-AUTHORITY][WARNING] "..message) end
end

local function selectedCandidate(evaluated)
    local selectedId=evaluated and evaluated.decision and evaluated.decision.selectedCandidateId or nil
    if selectedId==nil then return nil end
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated.candidates or {}) do if candidate.identity==selectedId then return candidate end end
    return nil
end
function Authority.new(runtime)
    return setmetatable({
        runtime=runtime,capability=nil,requests={},outcomes={},dispatchCount=0,
        d0147ProtectedYieldLeases={},
        followerBoundaryLease=nil,followerBoundaryApplyCount=0,followerBoundaryReleaseCount=0,followerBoundaryUpdateCount=0,
        d0146ActionSpaceLease=nil,d0146ActionSpaceApplyCount=0,d0146ActionSpaceReleaseCount=0,d0146ActionSpaceEnvelopeUpdateCount=0,d0146ActionSpaceRoleMigrationCount=0,
        d0146ActionSpaceQuiescenceCount=0,d0146ActionSpaceReactivationCount=0,
        followerBoundaryQuiescenceCount=0,followerBoundaryReactivationCount=0
    },Authority)
end
function Authority:setCapability(capability)
    self.capability=capability
    if self.runtime~=nil and self.runtime.liveControlDispatcher~=nil and type(self.runtime.liveControlDispatcher.setCapability)=="function" then
        self.runtime.liveControlDispatcher:setCapability(capability)
    end
end

function Authority:getCapabilityObservation()
    if self.capability~=nil and type(self.capability.getControlExecutionObservation)=="function" then return self.capability:getControlExecutionObservation() end
    return nil
end
function Authority:_outcome(request,status,effect,failure)
    local values={identity=self.runtime.identities:issue("CONTROL_OUTCOME"),requestId=request.identity,status=status,observedPhysicalEffect=effect or {},progress={},provenance={source="RegulationBoundedAuthority"},timestamp=(tonumber(g_time) or 0)/1000}
    if failure~=nil then values.failureEvidence=failure end
    local outcome=OuttaMyWay.ControlOutcome.new(values); self.outcomes[#self.outcomes+1]=outcome; return outcome
end

function Authority:_authorizeBoundedAuthority(currentResponsibility,commitment,token,values)
    if currentResponsibility==nil then return nil,"CURRENT_RESPONSIBILITY_REQUIRED_FOR_BOUNDED_AUTHORITY" end
    if self.runtime.boundedAuthority==nil then return nil,"BOUNDED_AUTHORITY_UNAVAILABLE" end
    return self.runtime.boundedAuthority:authorize({
        responsibilityId=currentResponsibility.identity,commitmentId=commitment.identity,assemblyId=values.assemblyId,capability=values.capability,
        target=values.target,authorityToken=token.identity,operationalPictureEpoch=values.operationalPictureEpoch,evidenceEpoch=values.evidenceEpoch,
        effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,preconditions=values.preconditions or {},invalidationConditions=values.invalidationConditions or {},
        provenance=values.provenance or {}
    })
end

function Authority:_releaseBoundedAuthority(grantId,reason)
    if self.runtime.boundedAuthority~=nil and type(grantId)=="string" then self.runtime.boundedAuthority:release(grantId,reason) end
end

function Authority:_releaseRequestBoundedAuthority(request,reason)
    if request~=nil then self:_releaseBoundedAuthority(request.boundedAuthorityId,reason) end
end

function Authority:_requestFromGrant(picture,evaluated,candidate,grant,target)
    local request,reason=self.runtime.boundedAuthority:materializeRequest({
        boundedAuthorityId=grant.identity,target=target,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
        preconditions=candidate and candidate.preconditions or grant.preconditions or {},
        invalidationConditions=candidate and candidate.invalidationConditions or grant.invalidationConditions or {}
    })
    if request==nil then return nil,reason end
    self.requests[#self.requests+1]=request
    return request
end

local function d0147TokenFor(runtime,commitmentId,assemblyId,authorityClass)
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
        if token.assemblyId==assemblyId and token.authorityClass==authorityClass and runtime.authorities:validate(token)==true then return token end
    end
    return nil
end

function Authority:_releaseD0147ProtectedYield(commitmentId,reason)
    local leases=self.d0147ProtectedYieldLeases[commitmentId]
    if type(leases)~="table" then return 0 end
    local released=0
    for _,lease in ipairs(leases) do
        if self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" and type(lease.referenceKey)=="string" then
            local ok=self.capability:clearRegulationLeaseByReference(lease.referenceKey,D0147_PROTECTED_YIELD_OWNER_TAG)
            if ok==true then released=released+1 end
        end
        self:_releaseBoundedAuthority(lease.boundedAuthorityId,reason)
    end
    self.d0147ProtectedYieldLeases[commitmentId]=nil
    logInfo("D0147_PROTECTED_YIELD_RELEASE commitment=%s released=%d reason=%s",tostring(commitmentId),released,tostring(reason))
    return released
end

function Authority:d0147ProtectedYieldAssemblyIds(commitmentId)
    local ids={}
    for _,lease in ipairs(self.d0147ProtectedYieldLeases[commitmentId] or {}) do
        if type(lease.assemblyId)=="string" then ids[#ids+1]=lease.assemblyId end
    end
    table.sort(ids)
    return ids
end

function Authority:_applyD0147ProtectedYield(picture,evaluated,candidate,commitment,currentResponsibility,bridge)
    if bridge.phase~="INFIELD" then return true,"NOT_TRANSLATING" end
    -- protectedDemandAssemblies is nested architecture value data and may be a sealed
    -- ValueRecord proxy in GIANTS. Never use native #/pairs/ipairs here.
    local protected=bridge.protectedDemandAssemblies or {}
    if OuttaMyWay.ValueRecord.length(protected)==0 then return false,"D0147_PROTECTED_YIELD_AUTHORISING_DEMAND_UNAVAILABLE" end
    if self.capability==nil or type(self.capability.executeControlRequest)~="function" then return false,"D0147_PROTECTED_YIELD_CONTROL_CAPABILITY_UNAVAILABLE" end
    if self.d0147ProtectedYieldLeases[commitment.identity]~=nil then return true,"ALREADY_PROTECTED" end
    local leases={}
    local function rollbackLeases(reason)
        for _,lease in ipairs(leases) do
            if type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.referenceKey,D0147_PROTECTED_YIELD_OWNER_TAG) end
            self:_releaseBoundedAuthority(lease.boundedAuthorityId,reason)
        end
    end
    for _,item in OuttaMyWay.ValueRecord.ipairs(protected) do
        if type(item.assemblyId)~="string" or type(item.referenceKey)~="string" then
            rollbackLeases("D0147_PROTECTED_YIELD_REFERENCE_UNAVAILABLE")
            return false,"D0147_PROTECTED_YIELD_REFERENCE_UNAVAILABLE"
        end
        local token=d0147TokenFor(self.runtime,commitment.identity,item.assemblyId,"PROGRESS_ACTUATION")
        if token==nil then
            rollbackLeases("D0147_PROTECTED_YIELD_PROGRESS_AUTHORITY_UNAVAILABLE")
            return false,"D0147_PROTECTED_YIELD_PROGRESS_AUTHORITY_UNAVAILABLE"
        end
        local regulationBridge={regulatedAssemblyId=item.assemblyId,regulatedReferenceKey=item.referenceKey,governingPurpose="D0147_PROTECTED_YIELD_INTERVAL"}
        local request,requestReason=self:_regulationRequest(picture,evaluated,candidate,commitment,token,regulationBridge,"APPLY",D0147_PROTECTED_YIELD_OWNER_TAG,0.0,currentResponsibility)
        if request==nil then
            rollbackLeases("D0147_PROTECTED_YIELD_REQUEST_FAILED")
            return false,requestReason
        end
        local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
        local outcome=self:_outcome(request,started and "ACCEPTED" or "REJECTED",{kind=started and "D0147_PROTECTED_YIELD_HOLD_APPLIED" or "NO_PHYSICAL_EFFECT_CONFIRMED",capability="REGULATE_SPEED",maxSpeedKmh=0.0},started and nil or {reason=tostring(result)})
        if started~=true then
            self:_releaseBoundedAuthority(request.boundedAuthorityId,"D0147_PROTECTED_YIELD_START_REJECTED")
            rollbackLeases("D0147_PROTECTED_YIELD_START_REJECTED")
            return false,"D0147_PROTECTED_YIELD_HOLD_REJECTED:"..tostring(result),outcome
        end
        leases[#leases+1]={assemblyId=item.assemblyId,referenceKey=item.referenceKey,requestId=request.identity,outcomeId=outcome.identity,boundedAuthorityId=request.boundedAuthorityId}
        logInfo("D0147_PROTECTED_YIELD_HOLD commitment=%s assembly=%s ref=%s request=%s cap=0.00kmh",tostring(commitment.identity),tostring(item.assemblyId),tostring(item.referenceKey),tostring(request.identity))
    end
    self.d0147ProtectedYieldLeases[commitment.identity]=leases
    return true,"PROTECTED_YIELD_HOLD_APPLIED"
end

local D0141_OWNER_TAG="D0141_FOLLOWER_BOUNDARY"
local D0146_ACTION_SPACE_OWNER_TAG="D0146_ACTION_SPACE_CONSERVATION"
local FORWARD_INTERSECTION_OWNER_TAG="FORWARD_INTERSECTION_INTENT_REVELATION"

function Authority:_regulationRequest(picture,evaluated,candidate,commitment,token,bridge,operation,ownerTag,maxSpeedKmh,currentResponsibility,existingBoundedAuthorityId)
    if type(ownerTag)~="string" then return nil,"REGULATION_OWNER_TAG_REQUIRED" end
    local speed=maxSpeedKmh
    if operation=="APPLY" and speed==nil then speed=1.0 end
    local assemblyId=bridge.progressAssemblyId or bridge.followerAssemblyId or bridge.regulatedAssemblyId
    local referenceKey=bridge.progressReferenceKey or bridge.followerReferenceKey or bridge.regulatedReferenceKey
    local target={kind="P22_REGULATION_LEASE",operation=operation,vehicleReferenceKey=referenceKey,ownerTag=ownerTag,
        maxSpeedKmh=operation=="APPLY" and speed or nil,governingPurpose=bridge.governingPurpose}
    local boundedAuthorityId=nil
    if type(existingBoundedAuthorityId)=="string" then
        local grant=self.runtime.boundedAuthority and self.runtime.boundedAuthority:get(existingBoundedAuthorityId) or nil
        if grant==nil then return nil,"BOUNDED_AUTHORITY_GRANT_NOT_CURRENT" end
        boundedAuthorityId=grant.identity
    elseif currentResponsibility~=nil then
        local grant,grantReason=self:_authorizeBoundedAuthority(currentResponsibility,commitment,token,{
            assemblyId=assemblyId,capability="REGULATE_SPEED",
            target={kind="P22_REGULATION_LEASE",vehicleReferenceKey=referenceKey,ownerTag=ownerTag,maxSpeedKmh=speed,governingPurpose=bridge.governingPurpose},
            operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
            preconditions=candidate and candidate.preconditions or {},invalidationConditions=candidate and candidate.invalidationConditions or {},
            provenance={source="RegulationBoundedAuthority",exemplar=bridge.governingPurpose or ownerTag}
        })
        if grant==nil then return nil,grantReason end
        boundedAuthorityId=grant.identity
    end
    local request=nil
    if type(boundedAuthorityId)=="string" then
        local requestReason=nil
        request,requestReason=self.runtime.boundedAuthority:materializeRequest({
            boundedAuthorityId=boundedAuthorityId,target=target,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
            preconditions=candidate and candidate.preconditions or {},invalidationConditions=candidate and candidate.invalidationConditions or {}
        })
        if request==nil then return nil,requestReason end
    else
        request=OuttaMyWay.ControlRequest.new({
            identity=self.runtime.identities:issue("CONTROL_REQUEST"),commitmentId=commitment.identity,assemblyId=assemblyId,capability="REGULATE_SPEED",
            target=target,
            authorityToken=token.identity,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
            effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,preconditions=candidate and candidate.preconditions or {},invalidationConditions=candidate and candidate.invalidationConditions or {},
            boundedAuthorityId=boundedAuthorityId
        })
    end
    self.requests[#self.requests+1]=request
    return request
end

local function followerBoundaryBridge(candidate)
    local basis=candidate and candidate.evidenceBasis or nil
    local bridge=basis and basis.followerBoundaryBridge or nil
    if type(bridge)=="table" and type(bridge.pairKey)=="string" and type(bridge.followerAssemblyId)=="string" then return bridge end
    return nil
end

local function d0146ActionSpaceBridge(candidate)
    local basis=candidate and candidate.evidenceBasis or nil
    local bridge=basis and basis.d0146ActionSpaceRegulationBridge or nil
    if type(bridge)=="table" and type(bridge.conflictIdentity)=="string" and type(bridge.regulatedAssemblyId)=="string" then return bridge end
    return nil
end

local function d0146ActionSpaceRelation(picture,lease)
    if lease==nil then return nil end
    for _,relation in OuttaMyWay.ValueRecord.ipairs(picture.opposedCorridorKnowledge or {}) do
        if relation.identity==lease.conflictIdentity then return relation end
    end
    for _,knowledge in OuttaMyWay.ValueRecord.ipairs(picture.spatialConstraintKnowledge or {}) do
        for _,relation in OuttaMyWay.ValueRecord.ipairs(knowledge.pairRelationships or {}) do
            if relation.identity==lease.conflictIdentity then return relation end
        end
    end
    return nil
end

local function d0146ActionSpaceActuationState(relation)
    local action=relation and relation.actionSpaceConservation or nil
    if type(action)~="table" then return "UNRESOLVED",nil end
    if action.status=="REGULATE_SUPPORTED" and action.supported==true then return "SUPPORTED",action end
    if action.status=="NOT_REQUIRED" and action.supported~=true then return "NOT_REQUIRED",action end
    return "UNRESOLVED",action
end

local function followerBoundaryRecord(picture,lease)
    for _,record in OuttaMyWay.ValueRecord.ipairs(picture.followerBoundaryKnowledge or {}) do
        if lease==nil or record.pairKey==lease.pairKey then return record end
    end
    return nil
end

function Authority:_otherRegulationPurposeOwnsAuthority(commitmentId,assemblyId,excluding)
    if excluding~="D0141" then
        local lease=self.followerBoundaryLease
        if lease~=nil and lease.actuationActive~=false and lease.commitmentId==commitmentId and lease.followerAssemblyId==assemblyId then return true end
    end
    if excluding~="D0146_ACTION_SPACE" then
        local lease=self.d0146ActionSpaceLease
        if lease~=nil and lease.actuationActive~=false and lease.commitmentId==commitmentId and lease.regulatedAssemblyId==assemblyId then return true end
    end
    return false
end

function Authority:hasActiveRegulationForAssembly(commitmentId,assemblyId,excluding)
    return self:_otherRegulationPurposeOwnsAuthority(commitmentId,assemblyId,excluding)
end

function Authority:preflightFollowerBoundaryNeutralization(commitmentId,pairKey)
    local lease=self.followerBoundaryLease
    if lease==nil or lease.commitmentId~=commitmentId or lease.pairKey~=pairKey then
        return nil,"FOLLOWER_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    return {commitmentId=lease.commitmentId,pairKey=lease.pairKey},nil
end

function Authority:preflightActionSpaceNeutralization(commitmentId,conflictIdentity)
    local lease=self.d0146ActionSpaceLease
    if lease==nil or lease.commitmentId~=commitmentId or lease.conflictIdentity~=conflictIdentity then
        return nil,"ACTION_SPACE_PASSAGE_PREFLIGHT_CONTEXT_MISMATCH"
    end
    return {commitmentId=lease.commitmentId,conflictIdentity=lease.conflictIdentity},nil
end

function Authority:neutralizeFollowerBoundaryPhysical(picture,evaluated,candidate,reason)
    local lease=self.followerBoundaryLease
    if lease==nil then return {status="NO_DISPATCH",reason="D0141_NO_ACTIVE_LEASE_TO_RETIRE",followerBoundary=true} end
    local commitment=self.runtime.commitments:get(lease.commitmentId)
    local token=nil
    if commitment~=nil then
        for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(commitment.identity)) do
            if candidateToken.assemblyId==lease.followerAssemblyId then token=candidateToken break end
        end
    end
    local request,outcome=nil,nil
    local released=false
    local releaseReason=nil
    if token~=nil and self.runtime.authorities:validate(token)==true and self.capability~=nil and type(self.capability.executeControlRequest)=="function" then
        request=self:_regulationRequest(picture,evaluated,candidate,commitment,token,{followerAssemblyId=lease.followerAssemblyId,followerReferenceKey=lease.followerReferenceKey,governingPurpose=lease.governingPurpose},"RELEASE",D0141_OWNER_TAG,nil,nil,lease.boundedAuthorityId)
        if request==nil then return {status="NO_DISPATCH",reason="D0141_RELEASE_BOUNDED_AUTHORITY_UNAVAILABLE",followerBoundary=true} end
        local ok,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "REGULATION_LEASE_RELEASED" or "REGULATION_RELEASE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        released=ok==true
        releaseReason=result
        if released~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then
            local cleared,clearReason=self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG)
            released=cleared==true
            if released~=true then releaseReason=clearReason or result end
        end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        local cleared,clearReason=self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG)
        released=cleared==true
        releaseReason=clearReason
    end
    if released~=true then
        return {status="NO_DISPATCH",reason=releaseReason or "D0141_PHYSICAL_RELEASE_NOT_CONFIRMED",request=request,outcome=outcome,followerBoundary=true}
    end
    self:_releaseBoundedAuthority(lease.boundedAuthorityId,reason)
    self.followerBoundaryReleaseCount=self.followerBoundaryReleaseCount+1
    self.followerBoundaryLease=nil
    logInfo("D0141_RELEASE commitment=%s pair=%s follower=%s ref=%s reason=%s",tostring(lease.commitmentId),tostring(lease.pairKey),tostring(lease.followerAssemblyId),tostring(lease.followerReferenceKey),tostring(reason))
    return {status="RELEASED",reason=reason,request=request,outcome=outcome,followerBoundary=true,commitment=commitment}
end

function Authority:_quiesceFollowerBoundaryActuation(picture,evaluated,candidate,bridge)
    local lease=self.followerBoundaryLease
    if lease==nil then return {status="NO_DISPATCH",reason="D0141_QUIESCENCE_NO_RETAINED_PURPOSE",followerBoundary=true} end
    if lease.actuationActive==false then
        return {status="QUIESCENT",reason="D0141_UNRESOLVED_PURPOSE_RETAINED_ACTUATION_REMAINS_QUIESCENT",followerBoundary=true,commitmentId=lease.commitmentId}
    end
    local commitment=self.runtime.commitments:get(lease.commitmentId)
    local token=nil
    if commitment~=nil then
        for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(commitment.identity)) do
            if candidateToken.identity==lease.authorityTokenId and candidateToken.assemblyId==lease.followerAssemblyId and self.runtime.authorities:validate(candidateToken)==true then token=candidateToken break end
        end
    end
    local request,outcome=nil,nil
    if commitment~=nil and token~=nil and self.capability~=nil and type(self.capability.executeControlRequest)=="function" then
        request=self:_regulationRequest(picture,evaluated,candidate,commitment,token,{followerAssemblyId=lease.followerAssemblyId,followerReferenceKey=lease.followerReferenceKey,governingPurpose=lease.governingPurpose},"RELEASE",D0141_OWNER_TAG,nil,nil,lease.boundedAuthorityId)
        if request==nil then return {status="NO_DISPATCH",reason="D0141_QUIESCENCE_BOUNDED_AUTHORITY_UNAVAILABLE",followerBoundary=true} end
        local ok,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "D0141_ACTUATION_QUIESCED" or "D0141_ACTUATION_QUIESCENCE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG) end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG)
    end
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        local preserve=self:_otherRegulationPurposeOwnsAuthority(commitment.identity,lease.followerAssemblyId,"D0141")
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,commitment.identity,lease.followerAssemblyId,{reason="D0198_D0141_CURRENT_FOLLOWER_TOPOLOGY_UNRESOLVED_ACTUATION_QUIESCENCE",preserveAuthority=preserve})
    end
    lease.actuationActive=false
    self:_releaseBoundedAuthority(lease.boundedAuthorityId,"D0141_ACTUATION_QUIESCENCE")
    lease.authorityTokenId=nil
    lease.boundedAuthorityId=nil
    lease.requestId=nil
    lease.currentCapKmh=nil
    lease.quiescenceReason=bridge and bridge.reason or "D0141_CURRENT_FOLLOWER_TOPOLOGY_UNRESOLVED"
    lease.quiescenceCount=(tonumber(lease.quiescenceCount) or 0)+1
    self.followerBoundaryQuiescenceCount=(tonumber(self.followerBoundaryQuiescenceCount) or 0)+1
    logInfo("D0141_ACTUATION_QUIESCENT commitment=%s pair=%s follower=%s reason=%s purposeRetained=true quiescenceCount=%d",tostring(lease.commitmentId),tostring(lease.pairKey),tostring(lease.followerAssemblyId),tostring(lease.quiescenceReason),tonumber(lease.quiescenceCount) or 0)
    return {status="QUIESCENT",reason="D0141_CURRENT_FOLLOWER_TOPOLOGY_UNRESOLVED_ACTUATION_QUIESCENT",request=request,outcome=outcome,followerBoundary=true,commitmentId=lease.commitmentId}
end

function Authority:assessFollowerBoundaryPermission(picture,evaluated,candidate,semanticAssessment)
    local bridge=followerBoundaryBridge(candidate)
    if semanticAssessment~=nil and semanticAssessment.disposition=="TERMINATE" then return nil end
    if bridge~=nil and bridge.action=="PRESERVE" then
        return self:_quiesceFollowerBoundaryActuation(picture,evaluated,candidate,bridge)
    end
    if bridge==nil or bridge.action~="APPLY" or candidate.capability~="REGULATE_SPEED" then return nil end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",followerBoundary=true} end
    return {status="FOLLOWER_BOUNDARY_RESPONSIBILITY_TRANSITION_REQUIRED",candidateId=candidate.identity,pairKey=bridge.pairKey,followerAssemblyId=bridge.followerAssemblyId,followerBoundary=true}
end

function Authority:continueFollowerBoundary(picture,evaluated,applied)
    if picture==nil or evaluated==nil or evaluated.decision==nil or type(applied)~="table" or applied.commitment==nil then
        return {status="NO_DISPATCH",reason="FOLLOWER_BOUNDARY_ESTABLISHED_RESPONSIBILITY_REQUIRED",followerBoundary=true}
    end
    local candidate=selectedCandidate(evaluated)
    local bridge=followerBoundaryBridge(candidate)
    if candidate==nil or bridge==nil or bridge.action~="APPLY" or candidate.capability~="REGULATE_SPEED" then
        return {status="NO_DISPATCH",reason="FOLLOWER_BOUNDARY_ESTABLISHED_RESPONSIBILITY_MISMATCH",followerBoundary=true}
    end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",followerBoundary=true} end
    local current=self.followerBoundaryLease
    local token=applied.authorityToken
    if token==nil or self.runtime.authorities:validate(token)~=true then
        return {status="NO_DISPATCH",reason="D0141_VALID_AUTHORITY_TOKEN_UNAVAILABLE",followerBoundary=true}
    end
    local request,requestReason=self:_regulationRequest(picture,evaluated,candidate,applied.commitment,token,bridge,"APPLY",D0141_OWNER_TAG,bridge.requestedFollowerCapKmh,applied.currentResponsibility)
    if request==nil then return {status="NO_DISPATCH",reason=requestReason,followerBoundary=true} end
    local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
    if started~=true then
        self:_releaseRequestBoundedAuthority(request,"D0141_CONTROL_REQUEST_REJECTED")
        local preserve=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.followerAssemblyId,"D0141")
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.followerAssemblyId,{reason="D0141_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=preserve}) end
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,followerBoundary=true}
    end
    local update=current~=nil and current.pairKey==bridge.pairKey
    local reactivated=update and current.actuationActive==false
    local previousBoundedAuthorityId=update and current.boundedAuthorityId or nil
    local priorQuiescenceCount=update and tonumber(current.quiescenceCount) or 0
    local priorReactivationCount=update and tonumber(current.reactivationCount) or 0
    self.followerBoundaryLease={commitmentId=applied.commitment.identity,pairKey=bridge.pairKey,leaderAssemblyId=bridge.leaderAssemblyId,followerAssemblyId=bridge.followerAssemblyId,
        leaderReferenceKey=bridge.leaderReferenceKey,followerReferenceKey=bridge.followerReferenceKey,leaderName=bridge.leaderName,followerName=bridge.followerName,governingPurpose=bridge.governingPurpose,
        authorityTokenId=token.identity,boundedAuthorityId=request.boundedAuthorityId,requestId=request.identity,currentCapKmh=bridge.requestedFollowerCapKmh,nativeUnrestrictedFollowerKmh=bridge.nativeUnrestrictedFollowerKmh,
        leaderRateUsedKmh=bridge.leaderRateUsedKmh,transitionPreservation=bridge.transitionPreservation==true,actuationActive=true,quiescenceReason=nil,
        quiescenceCount=priorQuiescenceCount or 0,reactivationCount=(priorReactivationCount or 0)+(reactivated and 1 or 0)}
    if update then self.followerBoundaryUpdateCount=self.followerBoundaryUpdateCount+1 else self.followerBoundaryApplyCount=self.followerBoundaryApplyCount+1 end
    if previousBoundedAuthorityId~=nil and previousBoundedAuthorityId~=request.boundedAuthorityId then self:_releaseBoundedAuthority(previousBoundedAuthorityId,"D0141_GRANT_REPLACED_BY_CURRENT_MAGNITUDE") end
    if reactivated then self.followerBoundaryReactivationCount=(tonumber(self.followerBoundaryReactivationCount) or 0)+1 end
    self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind=reactivated and "D0141_ACTUATION_REACTIVATED" or (update and "ELASTIC_REGULATION_MAGNITUDE_UPDATED" or "FOLLOWER_BOUNDARY_REGULATION_ADMITTED"),capability="REGULATE_SPEED",maxSpeedKmh=bridge.requestedFollowerCapKmh},nil)
    if reactivated then
        logInfo("D0141_ACTUATION_REACTIVATED commitment=%s pair=%s follower=%s cap=%.2fkmh purposeRetained=true reactivationCount=%d",tostring(applied.commitment.identity),tostring(bridge.pairKey),tostring(bridge.followerAssemblyId),tonumber(bridge.requestedFollowerCapKmh) or 0,tonumber(self.followerBoundaryLease.reactivationCount) or 0)
    else
        logInfo("D0141_%s commitment=%s pair=%s follower=%s ref=%s request=%s cap=%.2fkmh native=%.2fkmh leaderRate=%s transition=%s purpose=%s",update and "UPDATE" or "APPLY",tostring(applied.commitment.identity),tostring(bridge.pairKey),tostring(bridge.followerAssemblyId),tostring(bridge.followerReferenceKey),tostring(request.identity),tonumber(bridge.requestedFollowerCapKmh) or 0,tonumber(bridge.nativeUnrestrictedFollowerKmh) or 0,tostring(bridge.leaderRateUsedKmh or "n/a"),tostring(bridge.transitionPreservation==true),tostring(bridge.governingPurpose))
    end
    return {status=reactivated and "REACTIVATED" or "ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,result=result,followerBoundary=true,elasticUpdate=update,reactivated=reactivated}
end

function Authority:getFollowerBoundaryStatus()
    local lease=self.followerBoundaryLease
    return {active=lease~=nil and lease.actuationActive~=false,retainedPurpose=lease~=nil,actuationActive=lease~=nil and lease.actuationActive~=false,commitmentId=lease and lease.commitmentId or nil,pairKey=lease and lease.pairKey or nil,
        leaderName=lease and lease.leaderName or nil,followerName=lease and lease.followerName or nil,
        followerReferenceKey=lease and lease.followerReferenceKey or nil,currentCapKmh=lease and lease.currentCapKmh or nil,
        nativeUnrestrictedFollowerKmh=lease and lease.nativeUnrestrictedFollowerKmh or nil,leaderRateUsedKmh=lease and lease.leaderRateUsedKmh or nil,
        transitionPreservation=lease and lease.transitionPreservation==true or false,quiescenceReason=lease and lease.quiescenceReason or nil,applyCount=self.followerBoundaryApplyCount,
        updateCount=self.followerBoundaryUpdateCount,releaseCount=self.followerBoundaryReleaseCount,quiescenceCount=self.followerBoundaryQuiescenceCount,reactivationCount=self.followerBoundaryReactivationCount,ownerTag=D0141_OWNER_TAG}
end

function Authority:neutralizeActionSpaceRegulationPhysical(picture,evaluated,reason)
    local lease=self.d0146ActionSpaceLease
    if lease==nil then return {status="NO_DISPATCH",reason="D0146_ACTION_SPACE_NO_ACTIVE_LEASE"} end
    local commitment=self.runtime.commitments:get(lease.commitmentId)
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(lease.commitmentId)) do
        if candidateToken.assemblyId==lease.regulatedAssemblyId then token=candidateToken break end
    end
    local request,outcome=nil,nil
    local syntheticCandidate={preconditions={},invalidationConditions={}}
    if commitment~=nil and token~=nil and self.runtime.authorities:validate(token)==true and self.capability~=nil and type(self.capability.executeControlRequest)=="function" then
        request=self:_regulationRequest(picture,evaluated,syntheticCandidate,commitment,token,{
            regulatedAssemblyId=lease.regulatedAssemblyId,regulatedReferenceKey=lease.regulatedReferenceKey,governingPurpose=lease.governingPurpose
        },"RELEASE",lease.ownerTag or D0146_ACTION_SPACE_OWNER_TAG,nil,nil,lease.boundedAuthorityId)
        if request==nil then return {status="NO_DISPATCH",reason="D0146_ACTION_SPACE_RELEASE_BOUNDED_AUTHORITY_UNAVAILABLE"} end
        local ok,result=self.runtime.liveControlDispatcher:dispatch(request,nil)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "REGULATION_LEASE_RELEASED" or "REGULATION_RELEASE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,lease.ownerTag or D0146_ACTION_SPACE_OWNER_TAG) end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,lease.ownerTag or D0146_ACTION_SPACE_OWNER_TAG)
    end
    self.d0146ActionSpaceReleaseCount=self.d0146ActionSpaceReleaseCount+1
    self:_releaseBoundedAuthority(lease.boundedAuthorityId,reason)
    self.d0146ActionSpaceLease=nil
    if lease.admissionKind=="FORWARD_INTERSECTION" then
        logInfo("FORWARD_INTERSECTION_REGULATION_RELEASED commitment=%s relationship=%s yielder=%s reason=%s freshReality=true",
            tostring(lease.commitmentId),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(reason))
    end
    logInfo("D0146_ACTION_SPACE_RELEASE commitment=%s conflict=%s regulated=%s ref=%s reason=%s",tostring(lease.commitmentId),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(lease.regulatedReferenceKey),tostring(reason))
    return {status="RELEASED",reason=reason,request=request,outcome=outcome,d0146ActionSpace=true}
end

local function d0146ActionSpaceToken(dispatcher,commitment,lease)
    if commitment==nil or lease==nil then return nil end
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(dispatcher.runtime.authorities:tokensForCommitment(commitment.identity)) do
        if candidateToken.identity==lease.authorityTokenId and candidateToken.assemblyId==lease.regulatedAssemblyId and dispatcher.runtime.authorities:validate(candidateToken)==true then
            return candidateToken
        end
    end
    return nil
end

local function d0146CurrentPoseSeparation(picture,lease)
    if picture==nil or lease==nil then return nil end
    local aSpace,bSpace=nil,nil
    local aId=lease.regulatedAssemblyId
    local bId=lease.protectedAssemblyId or lease.excursionAssemblyId
    for _,space in OuttaMyWay.ValueRecord.ipairs(picture.currentSpace or {}) do
        if space.assemblyId==aId then aSpace=space elseif space.assemblyId==bId then bSpace=space end
    end
    local ax=tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.x)
    local az=tonumber(aSpace and aSpace.occupancy and aSpace.occupancy.z)
    local bx=tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.x)
    local bz=tonumber(bSpace and bSpace.occupancy and bSpace.occupancy.z)
    if ax==nil or az==nil or bx==nil or bz==nil then return nil end
    local dx,dz=bx-ax,bz-az
    return math.sqrt(dx*dx+dz*dz)
end

local function d0146CurrentSeparation(picture,lease,relation,bridge)
    local closing=relation and relation.currentClosing or nil
    local separation=closing and tonumber(closing.separationM) or nil
    if separation==nil then separation=d0146CurrentPoseSeparation(picture,lease) end
    if separation==nil and bridge~=nil then separation=tonumber(bridge.separationM) end
    return separation
end

-- D-0198 Witness Absence Is Not Quiescence Authority. Situation owns the
-- interpretation of raw GIANTS intent evidence and publishes a pair-local veto
-- naming assemblies whose native intent is still being revealed. Control only
-- asks whether the currently protected participant is covered by that veto.
local function d0146ActionSpaceQuiescenceSupported(picture,lease,action)
    if type(action)~="table" or action.status~="NOT_REQUIRED" then return false,"D0155_CURRENT_ACTION_SPACE_NOT_POSITIVELY_NOT_REQUIRED" end
    if action.reason~="NO_CURRENT_EXCURSION" then return true,action.reason end
    local veto=action.intentRevelationQuiescenceVeto
    local protectedId=lease and (lease.protectedAssemblyId or lease.excursionAssemblyId) or nil
    if type(veto)=="table" and veto.active==true and protectedId~=nil then
        for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(veto.assemblyIds or {}) do
            if assemblyId==protectedId then return false,"D0198_NO_CURRENT_EXCURSION_PROTECTED_INTENT_REVELATION_REMAINS_LOCAL" end
        end
    end
    return true,action.reason
end

function Authority:_quiesceD0146ActionSpaceActuation(picture,evaluated,lease,relation,action)
    if lease==nil then return {status="NO_DISPATCH",reason="D0155_ACTUATION_QUIESCENCE_NO_ACTIVE_RELATIONSHIP",d0146ActionSpace=true} end
    if lease.actuationActive==false then
        return {status="QUIESCENT",reason="D0155_CURRENT_ACTION_SPACE_NOT_REQUIRED_ACTUATION_REMAINS_QUIESCENT",d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local commitment=self.runtime.commitments:get(lease.commitmentId)
    local token=commitment and d0146ActionSpaceToken(self,commitment,lease) or nil
    local request,outcome=nil,nil
    local syntheticCandidate={preconditions={},invalidationConditions={}}
    if commitment~=nil and token~=nil and self.runtime.authorities:validate(token)==true and self.capability~=nil and type(self.capability.executeControlRequest)=="function" then
        request=self:_regulationRequest(picture,evaluated,syntheticCandidate,commitment,token,{
            regulatedAssemblyId=lease.regulatedAssemblyId,regulatedReferenceKey=lease.regulatedReferenceKey,governingPurpose=lease.governingPurpose
        },"RELEASE",D0146_ACTION_SPACE_OWNER_TAG,nil,nil,lease.boundedAuthorityId)
        if request==nil then return {status="NO_DISPATCH",reason="D0155_QUIESCENCE_BOUNDED_AUTHORITY_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId} end
        local ok,result=self.runtime.liveControlDispatcher:dispatch(request,nil)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "D0155_ACTUATION_QUIESCED" or "D0155_ACTUATION_QUIESCENCE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG) end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG)
    end
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        local preserve=self:_otherRegulationPurposeOwnsAuthority(commitment.identity,lease.regulatedAssemblyId,"D0146_ACTION_SPACE")
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,commitment.identity,lease.regulatedAssemblyId,{
            reason="D0197_ACTION_SPACE_NOT_REQUIRED_ACTUATION_QUIESCENCE",preserveAuthority=preserve
        })
    end
    lease.actuationActive=false
    self:_releaseBoundedAuthority(lease.boundedAuthorityId,"D0146_ACTION_SPACE_ACTUATION_QUIESCENCE")
    lease.authorityTokenId=nil
    lease.boundedAuthorityId=nil
    lease.requestId=nil
    lease.currentCapKmh=nil
    lease.progressionEnvelope=nil
    lease.quiescenceReason=action and action.reason or "D0146_CURRENT_ACTION_SPACE_NOT_REQUIRED"
    lease.quiescenceCount=(tonumber(lease.quiescenceCount) or 0)+1
    self.d0146ActionSpaceQuiescenceCount=(self.d0146ActionSpaceQuiescenceCount or 0)+1
    logInfo("D0155_ACTUATION_QUIESCENT commitment=%s conflict=%s regulated=%s protected=%s actionSpace=NOT_REQUIRED actionReason=%s relationshipRetained=true quiescenceCount=%d",
        tostring(lease.commitmentId),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(lease.protectedAssemblyId or lease.excursionAssemblyId),tostring(lease.quiescenceReason),tonumber(lease.quiescenceCount) or 0)
    return {status="QUIESCENT",reason="D0155_CURRENT_ACTION_SPACE_NOT_REQUIRED_ACTUATION_QUIESCENT",request=request,outcome=outcome,d0146ActionSpace=true,commitmentId=lease.commitmentId}
end

function Authority:_continueD0146ActionSpaceReactivation(picture,evaluated,candidate,lease,bridge,applied)
    if applied.commitment.identity~=lease.commitmentId then return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_COMMITMENT_ID_CHANGED",d0146ActionSpace=true,commitmentId=lease.commitmentId} end
    local token=applied.authorityToken
    if token==nil or self.runtime.authorities:validate(token)~=true then return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_VALID_AUTHORITY_TOKEN_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId} end
    local envelope,envelopeReason=OuttaMyWay.ResolutionSpaceProgressionEnvelope.establish(bridge.separationM,bridge.nativeUnrestrictedKmh,OuttaMyWay.D0146_RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION or 0.75,OuttaMyWay.D0146_RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH or 1)
    if envelope==nil then
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0155_ACTUATION_REACTIVATION_ENVELOPE_ESTABLISH_FAILED:"..tostring(envelopeReason),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")}) end
        return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_ENVELOPE_ESTABLISH_FAILED:"..tostring(envelopeReason),d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local cap=tonumber(envelope.capKmh) or 0
    local request,requestReason=self:_regulationRequest(picture,evaluated,candidate,applied.commitment,token,bridge,"APPLY",D0146_ACTION_SPACE_OWNER_TAG,cap,applied.currentResponsibility)
    if request==nil then return {status="QUIESCENT",reason=requestReason,d0146ActionSpace=true,commitmentId=lease.commitmentId} end
    local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
    if started~=true then
        self:_releaseRequestBoundedAuthority(request,"D0155_ACTUATION_REACTIVATION_CONTROL_REQUEST_REJECTED")
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0155_ACTUATION_REACTIVATION_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")}) end
        local outcome=self:_outcome(request,"REJECTED",{kind="D0155_ACTUATION_REACTIVATION_NOT_CONFIRMED",capability="REGULATE_SPEED"},{reason=tostring(result)})
        return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_CONTROL_REQUEST_REJECTED",request=request,outcome=outcome,d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    lease.regulatedAssemblyId=bridge.regulatedAssemblyId; lease.regulatedReferenceKey=bridge.regulatedReferenceKey
    lease.protectedAssemblyId=bridge.protectedAssemblyId or bridge.excursionAssemblyId; lease.protectedReferenceKey=bridge.protectedReferenceKey or bridge.excursionReferenceKey
    lease.excursionAssemblyId=bridge.excursionAssemblyId; lease.excursionReferenceKey=bridge.excursionReferenceKey; lease.admissionKind=bridge.admissionKind
    lease.governingPurpose=bridge.governingPurpose; lease.authorityTokenId=token.identity; lease.boundedAuthorityId=request.boundedAuthorityId; lease.requestId=request.identity
    lease.currentCapKmh=cap; lease.progressionEnvelope=envelope; lease.actuationActive=true; lease.quiescenceReason=nil
    lease.nativeClosureContributionKmh=bridge.nativeClosureContributionKmh; lease.nativeMoveForwards=bridge.nativeMoveForwards
    lease.reactivationCount=(tonumber(lease.reactivationCount) or 0)+1
    self.d0146ActionSpaceReactivationCount=(self.d0146ActionSpaceReactivationCount or 0)+1
    self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind="D0155_ACTUATION_REACTIVATED",capability="REGULATE_SPEED",effectClass=envelope.effectClass,maxSpeedKmh=cap},nil)
    logInfo("D0155_ACTUATION_REACTIVATED commitment=%s conflict=%s regulated=%s protected=%s cap=%dkmh actionSpace=REGULATE_SUPPORTED envelopeRebased=true reactivationCount=%d",
        tostring(lease.commitmentId),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(lease.protectedAssemblyId or lease.excursionAssemblyId),cap,tonumber(lease.reactivationCount) or 0)
    return {status="REACTIVATED",reason="D0155_CURRENT_ACTION_SPACE_REGULATION_REACTIVATED",request=request,outcome=outcome,d0146ActionSpace=true,commitmentId=lease.commitmentId}
end

function Authority:_updateD0146ActionSpaceEnvelope(picture,evaluated,candidate,lease,relation,relationshipReason)
    if lease.admissionKind=="FORWARD_INTERSECTION" then
        return {status="MAINTAINED",reason=relationshipReason or "FORWARD_INTERSECTION_FIXED_CREEP_REMAINS_ACTIVE",d0146ActionSpace=true,forwardIntersection=true,commitmentId=lease.commitmentId}
    end
    local separation=d0146CurrentSeparation(picture,lease,relation,nil)
    if separation==nil then
        return {status="MAINTAINED",reason=relationshipReason or "D0155_RESOLUTION_SPACE_CURRENT_DISTANCE_UNAVAILABLE_OBLIGATION_RETAINED",d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local envelope,envelopeReason=OuttaMyWay.ResolutionSpaceProgressionEnvelope.update(lease.progressionEnvelope,separation)
    lease.progressionEnvelope=envelope
    if envelopeReason~=nil then
        return {status="MAINTAINED",reason=envelopeReason,d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local requestedCap=tonumber(envelope.capKmh) or 0
    if requestedCap==tonumber(lease.currentCapKmh) then
        return {status="MAINTAINED",reason=relationshipReason,d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end

    local commitment=self.runtime.commitments:get(lease.commitmentId)
    if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        return {status="MAINTAINED",reason="D0155_ENVELOPE_UPDATE_COMMITMENT_NOT_LIVE",d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local token=d0146ActionSpaceToken(self,commitment,lease)
    if token==nil then
        return {status="MAINTAINED",reason="D0155_ENVELOPE_UPDATE_VALID_AUTHORITY_TOKEN_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local bridge={regulatedAssemblyId=lease.regulatedAssemblyId,regulatedReferenceKey=lease.regulatedReferenceKey,protectedAssemblyId=lease.protectedAssemblyId,protectedReferenceKey=lease.protectedReferenceKey,governingPurpose=lease.governingPurpose}
    local request,requestReason=self:_regulationRequest(picture,evaluated,candidate,commitment,token,bridge,"APPLY",D0146_ACTION_SPACE_OWNER_TAG,requestedCap,self.runtime.responsibilityTransitionAuthority:getCurrentRegulation(commitment.identity))
    if request==nil then return {status="MAINTAINED",reason=requestReason,d0146ActionSpace=true,commitmentId=lease.commitmentId} end
    local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
    if started~=true then
        self:_releaseRequestBoundedAuthority(request,"D0155_ENVELOPE_CONTROL_REQUEST_REJECTED")
        local outcome=self:_outcome(request,"REJECTED",{kind="D0155_RESOLUTION_SPACE_ENVELOPE_UPDATE_NOT_CONFIRMED",capability="REGULATE_SPEED",maxSpeedKmh=requestedCap},{reason=tostring(result)})
        return {status="MAINTAINED",reason="D0155_ENVELOPE_CONTROL_REQUEST_REJECTED",request=request,outcome=outcome,d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local priorCap=tonumber(lease.currentCapKmh) or -1
    local previousBoundedAuthorityId=lease.boundedAuthorityId
    lease.currentCapKmh=requestedCap
    lease.boundedAuthorityId=request.boundedAuthorityId
    lease.requestId=request.identity
    self.d0146ActionSpaceEnvelopeUpdateCount=(self.d0146ActionSpaceEnvelopeUpdateCount or 0)+1
    if previousBoundedAuthorityId~=nil and previousBoundedAuthorityId~=request.boundedAuthorityId then self:_releaseBoundedAuthority(previousBoundedAuthorityId,"D0146_ACTION_SPACE_GRANT_REPLACED_BY_CURRENT_MAGNITUDE") end
    self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind="D0155_RESOLUTION_SPACE_ENVELOPE_UPDATED",capability="REGULATE_SPEED",effectClass=envelope.effectClass,maxSpeedKmh=requestedCap},nil)
    logInfo("D0155_ENVELOPE_UPDATE commitment=%s conflict=%s regulated=%s protected=%s priorCap=%dkmh cap=%dkmh raw=%.2fkmh physical=%.2fm conservative=%.2fm reverseReserve=%.2fm contingency=%.2fm ordinaryRemaining=%.2fm effect=%s",
        tostring(commitment.identity),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(lease.protectedAssemblyId or lease.excursionAssemblyId),priorCap,requestedCap,
        tonumber(envelope.rawCapKmh) or 0,tonumber(envelope.currentPhysicalDistanceM) or -1,tonumber(envelope.conservativeDistanceM) or -1,tonumber(envelope.reverseCreatedReserveM) or 0,
        tonumber(envelope.contingencyReserveM) or 0,tonumber(envelope.remainingOrdinaryM) or 0,tostring(envelope.effectClass))
    if envelope.effectClass=="INTENT_REVELATION_CREEP" and priorCap~=requestedCap then
        logInfo("D0155_INTENT_REVELATION_CREEP commitment=%s conflict=%s regulated=%s protected=%s cap=%dkmh physical=%.2fm conservative=%.2fm contingency=%.2fm purpose=%s",
            tostring(commitment.identity),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(lease.protectedAssemblyId or lease.excursionAssemblyId),requestedCap,
            tonumber(envelope.currentPhysicalDistanceM) or -1,tonumber(envelope.conservativeDistanceM) or -1,tonumber(envelope.contingencyReserveM) or 0,tostring(lease.governingPurpose))
    end
    return {status="ENVELOPE_UPDATED",reason=envelope.effectClass=="INTENT_REVELATION_CREEP" and "D0155_INTENT_REVELATION_CREEP_APPLIED" or "D0155_SUPPORTABLE_PROGRESSION_MAGNITUDE_UPDATED",request=request,outcome=outcome,d0146ActionSpace=true,commitmentId=commitment.identity}
end

function Authority:_continueD0146ActionSpaceRoleMigration(picture,evaluated,candidate,lease,bridge,applied)
    if lease==nil or bridge==nil or bridge.conflictIdentity~=lease.conflictIdentity or bridge.regulatedAssemblyId==lease.regulatedAssemblyId then return nil end
    if applied.commitment.identity~=lease.commitmentId then return {status="MAINTAINED",reason="D0146_ROLE_MIGRATION_COMMITMENT_ID_CHANGED",d0146ActionSpace=true,commitmentId=lease.commitmentId} end
    local newToken=applied.authorityToken
    if newToken==nil or self.runtime.authorities:validate(newToken)~=true then return {status="MAINTAINED",reason="D0146_ROLE_MIGRATION_NEW_AUTHORITY_TOKEN_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId} end

    local envelopeCopy=OuttaMyWay.ResolutionSpaceProgressionEnvelope.snapshot(lease.progressionEnvelope)
    local rebased,rebaseReason=OuttaMyWay.ResolutionSpaceProgressionEnvelope.rebaseRole(envelopeCopy,bridge.nativeUnrestrictedKmh,bridge.separationM)
    if rebased==nil or rebaseReason~=nil then
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0155_ROLE_REBASE_FAILED:"..tostring(rebaseReason),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")}) end
        return {status="MAINTAINED",reason="D0155_ROLE_REBASE_FAILED:"..tostring(rebaseReason),d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end
    local newCap=tonumber(rebased.capKmh) or 0
    local newRequest,newRequestReason=self:_regulationRequest(picture,evaluated,candidate,applied.commitment,newToken,bridge,"APPLY",D0146_ACTION_SPACE_OWNER_TAG,newCap,applied.currentResponsibility)
    if newRequest==nil then return {status="MAINTAINED",reason=newRequestReason,d0146ActionSpace=true,commitmentId=lease.commitmentId} end
    local started,newResult=self.runtime.liveControlDispatcher:dispatch(newRequest,candidate)
    if started~=true then
        self:_releaseRequestBoundedAuthority(newRequest,"D0146_ROLE_MIGRATION_NEW_CONTROL_REQUEST_REJECTED")
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0146_ROLE_MIGRATION_NEW_CONTROL_REQUEST_REJECTED:"..tostring(newResult),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")}) end
        local outcome=self:_outcome(newRequest,"REJECTED",{kind="D0146_ROLE_MIGRATION_NEW_REGULATION_NOT_CONFIRMED",capability="REGULATE_SPEED"},{reason=tostring(newResult)})
        return {status="MAINTAINED",reason="D0146_ROLE_MIGRATION_NEW_CONTROL_REQUEST_REJECTED",request=newRequest,outcome=outcome,d0146ActionSpace=true,commitmentId=lease.commitmentId}
    end

    local oldToken=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(lease.commitmentId)) do
        if candidateToken.assemblyId==lease.regulatedAssemblyId and self.runtime.authorities:validate(candidateToken)==true then oldToken=candidateToken break end
    end
    local oldRequest=nil
    if oldToken~=nil then
        local syntheticCandidate={preconditions={},invalidationConditions={}}
        oldRequest=self:_regulationRequest(picture,evaluated,syntheticCandidate,applied.commitment,oldToken,{regulatedAssemblyId=lease.regulatedAssemblyId,regulatedReferenceKey=lease.regulatedReferenceKey,governingPurpose=lease.governingPurpose},"RELEASE",D0146_ACTION_SPACE_OWNER_TAG,nil,nil,lease.boundedAuthorityId)
        if oldRequest==nil then return {status="MAINTAINED",reason="D0146_ROLE_MIGRATION_OLD_BOUNDED_AUTHORITY_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId} end
        local oldReleased=self.runtime.liveControlDispatcher:dispatch(oldRequest,nil)
        if oldReleased~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG) end
    elseif type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG) end
    local preserveOld=self:_otherRegulationPurposeOwnsAuthority(lease.commitmentId,lease.regulatedAssemblyId,"D0146_ACTION_SPACE")
    OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,lease.commitmentId,lease.regulatedAssemblyId,{reason="D0146_RESOLUTION_SPACE_ROLE_MIGRATED",preserveAuthority=preserveOld})
    self:_releaseBoundedAuthority(lease.boundedAuthorityId,"D0146_ACTION_SPACE_ROLE_MIGRATED")

    local oldRegulatedAssemblyId=lease.regulatedAssemblyId
    local oldRegulatedReferenceKey=lease.regulatedReferenceKey
    local oldProtectedAssemblyId=lease.protectedAssemblyId or lease.excursionAssemblyId
    lease.regulatedAssemblyId=bridge.regulatedAssemblyId; lease.regulatedReferenceKey=bridge.regulatedReferenceKey
    lease.protectedAssemblyId=bridge.protectedAssemblyId or bridge.excursionAssemblyId; lease.protectedReferenceKey=bridge.protectedReferenceKey or bridge.excursionReferenceKey
    lease.excursionAssemblyId=bridge.excursionAssemblyId; lease.excursionReferenceKey=bridge.excursionReferenceKey; lease.admissionKind=bridge.admissionKind
    lease.governingPurpose=bridge.governingPurpose; lease.authorityTokenId=newToken.identity; lease.boundedAuthorityId=newRequest.boundedAuthorityId; lease.requestId=newRequest.identity
    lease.currentCapKmh=newCap; lease.progressionEnvelope=rebased
    lease.nativeClosureContributionKmh=bridge.nativeClosureContributionKmh; lease.nativeMoveForwards=bridge.nativeMoveForwards
    self.d0146ActionSpaceRoleMigrationCount=(self.d0146ActionSpaceRoleMigrationCount or 0)+1; self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(newRequest,"ACCEPTED",{kind="D0155_RESOLUTION_SPACE_ROLE_MIGRATED_AND_REBASED",capability="REGULATE_SPEED",effectClass=rebased.effectClass,maxSpeedKmh=newCap},nil)
    logInfo("D0155_ROLE_REBASE commitment=%s conflict=%s oldRegulated=%s oldRef=%s newRegulated=%s newRef=%s oldProtected=%s newProtected=%s cap=%dkmh ordinaryRemaining=%.2fm contingency=%.2fm reverseReserve=%.2fm rebaseCount=%d",
        tostring(lease.commitmentId),tostring(lease.conflictIdentity),tostring(oldRegulatedAssemblyId),tostring(oldRegulatedReferenceKey),tostring(lease.regulatedAssemblyId),tostring(lease.regulatedReferenceKey),tostring(oldProtectedAssemblyId),tostring(lease.protectedAssemblyId),newCap,
        tonumber(rebased.remainingOrdinaryM) or 0,tonumber(rebased.contingencyReserveM) or 0,tonumber(rebased.reverseCreatedReserveM) or 0,tonumber(rebased.roleRebaseCount) or 0)
    return {status="ROLE_MIGRATED",reason="D0155_CURRENT_SITUATION_REASSIGNED_ROLES_WITH_MAGNITUDE_REBASE",request=newRequest,releaseRequest=oldRequest,outcome=outcome,d0146ActionSpace=true,commitmentId=lease.commitmentId}
end

function Authority:assessActionSpaceRegulationPermission(picture,evaluated,candidate,semanticAssessment)
    local bridge=d0146ActionSpaceBridge(candidate)
    local lease=self.d0146ActionSpaceLease
    if lease~=nil then
        local relation=d0146ActionSpaceRelation(picture,lease)
        local relationshipReason=semanticAssessment and semanticAssessment.reason or nil
        if semanticAssessment==nil or semanticAssessment.disposition=="PERSIST" then
            local actuationState,action=d0146ActionSpaceActuationState(relation)
            if actuationState=="NOT_REQUIRED" then
                local quiesceSupported,quiescenceReason=d0146ActionSpaceQuiescenceSupported(picture,lease,action)
                if quiesceSupported then
                    return self:_quiesceD0146ActionSpaceActuation(picture,evaluated,lease,relation,action)
                end
                if lease.actuationActive~=false then
                    return self:_updateD0146ActionSpaceEnvelope(picture,evaluated,candidate,lease,relation,quiescenceReason)
                end
                return {status="QUIESCENT",reason=quiescenceReason,d0146ActionSpace=true,commitmentId=lease.commitmentId}
            end
            if lease.actuationActive==false then
                if actuationState=="SUPPORTED" and bridge~=nil then
                    if bridge.conflictIdentity~=lease.conflictIdentity then
                        return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_CURRENT_SUPPORT_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId}
                    end
                    if self.capability==nil or type(self.capability.executeControlRequest)~="function" then
                        return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_CONTROL_CAPABILITY_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId}
                    end
                    return {status="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED",applicationContext="REACTIVATION",candidateId=candidate.identity,
                        conflictIdentity=bridge.conflictIdentity,regulatedAssemblyId=bridge.regulatedAssemblyId,commitmentId=lease.commitmentId,d0146ActionSpace=true}
                end
                return {status="QUIESCENT",reason=relationshipReason or "D0155_RELATIONSHIP_RETAINED_CURRENT_ACTUATION_NOT_SUPPORTED",d0146ActionSpace=true,commitmentId=lease.commitmentId}
            end
            if bridge~=nil and bridge.conflictIdentity==lease.conflictIdentity and bridge.regulatedAssemblyId~=lease.regulatedAssemblyId then
                if self.capability==nil or type(self.capability.executeControlRequest)~="function" then
                    return {status="MAINTAINED",reason="D0146_ROLE_MIGRATION_CONTROL_CAPABILITY_UNAVAILABLE",d0146ActionSpace=true,commitmentId=lease.commitmentId}
                end
                return {status="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED",applicationContext="ROLE_MIGRATION",candidateId=candidate.identity,
                    conflictIdentity=bridge.conflictIdentity,regulatedAssemblyId=bridge.regulatedAssemblyId,commitmentId=lease.commitmentId,d0146ActionSpace=true}
            end
            return self:_updateD0146ActionSpaceEnvelope(picture,evaluated,candidate,lease,relation,relationshipReason)
        end
        return nil
    end

    if bridge==nil or candidate.capability~="REGULATE_SPEED" then return nil end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",d0146ActionSpace=true} end
    return {status="ACTION_SPACE_REGULATION_RESPONSIBILITY_TRANSITION_REQUIRED",applicationContext="INITIAL",candidateId=candidate.identity,
        conflictIdentity=bridge.conflictIdentity,regulatedAssemblyId=bridge.regulatedAssemblyId,d0146ActionSpace=true}
end

function Authority:_continueD0146ActionSpaceInitial(picture,evaluated,candidate,bridge,applied)
    local token=applied.authorityToken
    if token==nil or self.runtime.authorities:validate(token)~=true then return {status="NO_DISPATCH",reason="D0146_ACTION_SPACE_VALID_AUTHORITY_TOKEN_UNAVAILABLE",d0146ActionSpace=true} end

    local fixedForwardIntersection=bridge.admissionKind=="FORWARD_INTERSECTION"
    local envelope,envelopeReason=nil,nil
    if not fixedForwardIntersection then
        envelope,envelopeReason=OuttaMyWay.ResolutionSpaceProgressionEnvelope.establish(bridge.separationM,bridge.nativeUnrestrictedKmh,OuttaMyWay.D0146_RESOLUTION_SPACE_CONTINGENCY_RESERVE_FRACTION or 0.75,OuttaMyWay.D0146_RESOLUTION_SPACE_INTENT_REVELATION_CREEP_KMH or 1)
    end
    if not fixedForwardIntersection and envelope==nil then
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0155_ENVELOPE_ESTABLISH_FAILED:"..tostring(envelopeReason),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")}) end
        return {status="NO_DISPATCH",reason="D0155_ENVELOPE_ESTABLISH_FAILED:"..tostring(envelopeReason),d0146ActionSpace=true}
    end
    local initialCap=fixedForwardIntersection and (OuttaMyWay.FORWARD_INTERSECTION_REGULATION_SPEED_KMH or 1) or (tonumber(envelope.capKmh) or 0)
    local ownerTag=fixedForwardIntersection and FORWARD_INTERSECTION_OWNER_TAG or D0146_ACTION_SPACE_OWNER_TAG
    local request,requestReason=self:_regulationRequest(picture,evaluated,candidate,applied.commitment,token,bridge,"APPLY",ownerTag,initialCap,applied.currentResponsibility)
    if request==nil then return {status="NO_DISPATCH",reason=requestReason,d0146ActionSpace=true} end
    local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
    if started~=true then
        self:_releaseRequestBoundedAuthority(request,"D0146_ACTION_SPACE_CONTROL_REQUEST_REJECTED")
        if applied.authorityAcquired then OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0146_ACTION_SPACE_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")}) end
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,d0146ActionSpace=true}
    end
    self.d0146ActionSpaceLease={
        commitmentId=applied.commitment.identity,conflictIdentity=bridge.conflictIdentity,operationId=bridge.operationId,
        regulatedAssemblyId=bridge.regulatedAssemblyId,regulatedReferenceKey=bridge.regulatedReferenceKey,
        protectedAssemblyId=bridge.protectedAssemblyId or bridge.excursionAssemblyId,protectedReferenceKey=bridge.protectedReferenceKey or bridge.excursionReferenceKey,
        excursionAssemblyId=bridge.excursionAssemblyId,excursionReferenceKey=bridge.excursionReferenceKey,admissionKind=bridge.admissionKind,
        governingPurpose=bridge.governingPurpose,ownerTag=ownerTag,authorityTokenId=token.identity,boundedAuthorityId=request.boundedAuthorityId,requestId=request.identity,currentCapKmh=initialCap,progressionEnvelope=envelope,actuationActive=true,fixedForwardIntersection=fixedForwardIntersection,
        nativeClosureContributionKmh=bridge.nativeClosureContributionKmh,nativeMoveForwards=bridge.nativeMoveForwards,quiescenceCount=0,reactivationCount=0
    }
    self.d0146ActionSpaceApplyCount=self.d0146ActionSpaceApplyCount+1; self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind=fixedForwardIntersection and "FORWARD_INTERSECTION_REGULATION_ADMITTED" or "D0155_RESOLUTION_SPACE_ENVELOPE_ADMITTED",capability="REGULATE_SPEED",effectClass=fixedForwardIntersection and "INTENT_REVELATION_CREEP" or envelope.effectClass,maxSpeedKmh=initialCap},nil)
    if fixedForwardIntersection then
        logInfo("FORWARD_INTERSECTION_REGULATION_APPLIED commitment=%s relationship=%s yielder=%s continuing=%s cap=1kmh purpose=%s",
            tostring(applied.commitment.identity),tostring(bridge.conflictIdentity),tostring(bridge.regulatedAssemblyId),tostring(bridge.protectedAssemblyId),tostring(bridge.governingPurpose))
        return {status="ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,result=result,d0146ActionSpace=true,forwardIntersection=true}
    end
    logInfo("D0155_ENVELOPE_ADMIT commitment=%s conflict=%s admission=%s regulated=%s ref=%s protected=%s cap=%dkmh raw=%.2fkmh native=%.2fkmh D0=%.2fm contingency=%.2fm ordinary=%.2fm reserveFraction=%.2f purpose=%s",
        tostring(applied.commitment.identity),tostring(bridge.conflictIdentity),tostring(bridge.admissionKind or "CURRENT_EXCURSION"),tostring(bridge.regulatedAssemblyId),tostring(bridge.regulatedReferenceKey),tostring(bridge.protectedAssemblyId or bridge.excursionAssemblyId),initialCap,
        tonumber(envelope.rawCapKmh) or 0,tonumber(bridge.nativeUnrestrictedKmh) or 0,tonumber(envelope.initialDistanceM) or 0,tonumber(envelope.contingencyReserveM) or 0,tonumber(envelope.ordinaryInitialM) or 0,tonumber(envelope.reserveFraction) or 0,tostring(bridge.governingPurpose))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,result=result,d0146ActionSpace=true}
end

function Authority:actionSpaceRegulationTransitionFailed(readiness,reason)
    if readiness.applicationContext=="REACTIVATION" then
        return {status="QUIESCENT",reason="D0155_ACTUATION_REACTIVATION_COMMITMENT_APPLICATION_FAILED:"..tostring(reason),d0146ActionSpace=true,commitmentId=readiness.commitmentId}
    end
    if readiness.applicationContext=="ROLE_MIGRATION" then
        return {status="MAINTAINED",reason="D0146_ROLE_MIGRATION_COMMITMENT_APPLICATION_FAILED:"..tostring(reason),d0146ActionSpace=true,commitmentId=readiness.commitmentId}
    end
    return {status="NO_DISPATCH",reason=reason,d0146ActionSpace=true}
end

function Authority:continueActionSpaceRegulation(picture,evaluated,applied,readiness)
    local candidate=selectedCandidate(evaluated)
    local bridge=d0146ActionSpaceBridge(candidate)
    if candidate==nil or bridge==nil or candidate.identity~=readiness.candidateId or bridge.conflictIdentity~=readiness.conflictIdentity
        or bridge.regulatedAssemblyId~=readiness.regulatedAssemblyId then
        return {status="NO_DISPATCH",reason="ACTION_SPACE_REGULATION_CONTINUATION_CONTEXT_MISMATCH",d0146ActionSpace=true}
    end
    if readiness.applicationContext=="INITIAL" then
        return self:_continueD0146ActionSpaceInitial(picture,evaluated,candidate,bridge,applied)
    end
    local lease=self.d0146ActionSpaceLease
    if lease==nil or lease.commitmentId~=readiness.commitmentId or lease.conflictIdentity~=readiness.conflictIdentity then
        return {status="NO_DISPATCH",reason="ACTION_SPACE_REGULATION_CONTINUATION_LEASE_MISMATCH",d0146ActionSpace=true}
    end
    if readiness.applicationContext=="REACTIVATION" then
        return self:_continueD0146ActionSpaceReactivation(picture,evaluated,candidate,lease,bridge,applied)
    end
    if readiness.applicationContext=="ROLE_MIGRATION" then
        return self:_continueD0146ActionSpaceRoleMigration(picture,evaluated,candidate,lease,bridge,applied)
    end
    return {status="NO_DISPATCH",reason="ACTION_SPACE_REGULATION_CONTINUATION_CONTEXT_UNSUPPORTED",d0146ActionSpace=true}
end

-- A terminalizing traffic Commitment cannot leave owner-tag Control leases or
-- Regulation authority state behind. D-0200 invokes this before terminal
-- settlement so terminal succession observes no stale actuation context.
function Authority:retireTrafficLeasesForCommitment(commitmentId,reason)
    if type(commitmentId)~="string" then return {released=0} end
    local released=0
    local function clear(referenceKey,ownerTag)
        if self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" and type(referenceKey)=="string" then
            self.capability:clearRegulationLeaseByReference(referenceKey,ownerTag)
        end
    end
    local actionSpace=self.d0146ActionSpaceLease
    if actionSpace~=nil and actionSpace.commitmentId==commitmentId then
        clear(actionSpace.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG)
        self.d0146ActionSpaceLease=nil
        self.d0146ActionSpaceReleaseCount=self.d0146ActionSpaceReleaseCount+1
        released=released+1
        logInfo("D0155_DEPENDENT_COMMITMENT_TERMINATED commitment=%s conflict=%s regulated=%s reason=%s",
            tostring(commitmentId),tostring(actionSpace.conflictIdentity),tostring(actionSpace.regulatedAssemblyId),tostring(reason))
    end
    local follower=self.followerBoundaryLease
    if follower~=nil and follower.commitmentId==commitmentId then
        clear(follower.followerReferenceKey,D0141_OWNER_TAG)
        self.followerBoundaryLease=nil
        self.followerBoundaryReleaseCount=self.followerBoundaryReleaseCount+1
        released=released+1
        logInfo("D0141_DEPENDENT_COMMITMENT_TERMINATED commitment=%s pair=%s follower=%s reason=%s",
            tostring(commitmentId),tostring(follower.pairKey),tostring(follower.followerAssemblyId),tostring(reason))
    end
    return {released=released}
end

function Authority:getD0146ActionSpaceStatus()
    local lease=self.d0146ActionSpaceLease
    local envelope=lease and lease.progressionEnvelope or nil
    return {active=lease~=nil,actuationActive=lease~=nil and lease.actuationActive~=false or false,commitmentId=lease and lease.commitmentId or nil,conflictIdentity=lease and lease.conflictIdentity or nil,
        regulatedAssemblyId=lease and lease.regulatedAssemblyId or nil,regulatedReferenceKey=lease and lease.regulatedReferenceKey or nil,excursionReferenceKey=lease and lease.excursionReferenceKey or nil,currentCapKmh=lease and lease.currentCapKmh or nil,quiescenceReason=lease and lease.quiescenceReason or nil,
        effectClass=envelope and envelope.effectClass or nil,initialDistanceM=envelope and envelope.initialDistanceM or nil,contingencyReserveM=envelope and envelope.contingencyReserveM or nil,
        conservativeDistanceM=envelope and envelope.conservativeDistanceM or nil,reverseCreatedReserveM=envelope and envelope.reverseCreatedReserveM or nil,remainingOrdinaryM=envelope and envelope.remainingOrdinaryM or nil,
        roleRebaseCount=envelope and envelope.roleRebaseCount or 0,applyCount=self.d0146ActionSpaceApplyCount,releaseCount=self.d0146ActionSpaceReleaseCount,envelopeUpdateCount=self.d0146ActionSpaceEnvelopeUpdateCount,roleMigrationCount=self.d0146ActionSpaceRoleMigrationCount,
        quiescenceCount=self.d0146ActionSpaceQuiescenceCount,reactivationCount=self.d0146ActionSpaceReactivationCount,ownerTag=D0146_ACTION_SPACE_OWNER_TAG}
end

function Authority:getDispatchCount() return self.dispatchCount end
function Authority:getRequests() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.requests) do out[#out+1]=v end; return out end
function Authority:getOutcomes() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.outcomes) do out[#out+1]=v end; return out end
