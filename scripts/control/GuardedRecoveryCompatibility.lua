OuttaMyWay.GuardedRecoveryCompatibility = {}
local Compatibility = OuttaMyWay.GuardedRecoveryCompatibility
Compatibility.__index = Compatibility

local D0123_OWNER_TAG="D0123_GUARDED_RECOVERY"

local function logInfo(formatText,...)
    local message=string.format(formatText,...)
    if Logging~=nil and type(Logging.info)=="function" then Logging.info("[FS25_OuttaMyWay][GUARDED-RECOVERY] %s",message) else print("[FS25_OuttaMyWay][GUARDED-RECOVERY] "..message) end
end

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

function Compatibility.new(runtime)
    return setmetatable({runtime=runtime,guardedRecoveryLease=nil,guardedRecoveryApplyCount=0,guardedRecoveryReleaseCount=0,outcomes={}},Compatibility)
end

function Compatibility:_capability()
    return self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher.capability or nil
end

function Compatibility:_outcome(request,status,effect,failure)
    local values={identity=self.runtime.identities:issue("CONTROL_OUTCOME"),requestId=request.identity,status=status,observedPhysicalEffect=effect or {},progress={},provenance={source="GuardedRecoveryCompatibility"},timestamp=(tonumber(g_time) or 0)/1000}
    if failure~=nil then values.failureEvidence=failure end
    local outcome=OuttaMyWay.ControlOutcome.new(values)
    self.outcomes[#self.outcomes+1]=outcome
    return outcome
end

function Compatibility:_legacyRegulationRequest(picture,evaluated,candidate,commitment,token,bridge,operation)
    local speed=nil
    if operation=="APPLY" then speed=OuttaMyWay.D0123_NATIVE_HANDOVER_CREEP_KMH or 1.0 end
    local target={kind="P22_REGULATION_LEASE",operation=operation,vehicleReferenceKey=bridge.progressReferenceKey,ownerTag=D0123_OWNER_TAG,
        maxSpeedKmh=speed,governingPurpose=bridge.governingPurpose}
    local request=OuttaMyWay.ControlRequest.new({
        identity=self.runtime.identities:issue("CONTROL_REQUEST"),commitmentId=commitment.identity,assemblyId=bridge.progressAssemblyId,capability="REGULATE_SPEED",
        target=target,authorityToken=token.identity,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,
        effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,preconditions=candidate and candidate.preconditions or {},invalidationConditions=candidate and candidate.invalidationConditions or {},
        boundedAuthorityId=nil
    })
    return request
end

function Compatibility:_otherRegulationPurposeOwnsAuthority(commitmentId,assemblyId)
    local authority=self.runtime and self.runtime.regulationBoundedAuthority or nil
    if authority~=nil and type(authority.hasActiveRegulationForAssembly)=="function" then
        return authority:hasActiveRegulationForAssembly(commitmentId,assemblyId,nil)
    end
    return false
end

function Compatibility:_releaseGuardedRecoveryLease(picture,evaluated,reason)
    local lease=self.guardedRecoveryLease
    if lease==nil then return nil end
    local commitment=self.runtime.commitments:get(lease.commitmentId)
    local token=nil
    for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(lease.commitmentId)) do
        if candidateToken.assemblyId==lease.progressAssemblyId then token=candidateToken break end
    end
    local request,outcome=nil,nil
    local capability=self:_capability()
    if commitment~=nil and token~=nil and self.runtime.authorities:validate(token)==true and capability~=nil and type(capability.executeControlRequest)=="function" then
        local syntheticCandidate={preconditions={},invalidationConditions={}}
        request=self:_legacyRegulationRequest(picture,evaluated,syntheticCandidate,commitment,token,{
            progressAssemblyId=lease.progressAssemblyId,progressReferenceKey=lease.progressReferenceKey,governingPurpose=lease.governingPurpose
        },"RELEASE")
        local ok,result=self.runtime.liveControlDispatcher:dispatch(request,nil)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "REGULATION_LEASE_RELEASED" or "REGULATION_RELEASE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(capability.clearRegulationLeaseByReference)=="function" then capability:clearRegulationLeaseByReference(lease.progressReferenceKey,D0123_OWNER_TAG) end
    elseif capability~=nil and type(capability.clearRegulationLeaseByReference)=="function" then
        capability:clearRegulationLeaseByReference(lease.progressReferenceKey,D0123_OWNER_TAG)
    end
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,lease.commitmentId,lease.progressAssemblyId,{reason=reason,preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(lease.commitmentId,lease.progressAssemblyId)})
    end
    self.guardedRecoveryReleaseCount=self.guardedRecoveryReleaseCount+1
    logInfo("D0123_RELEASE commitment=%s progress=%s ref=%s reason=%s",tostring(lease.commitmentId),tostring(lease.progressAssemblyId),tostring(lease.progressReferenceKey),tostring(reason))
    self.guardedRecoveryLease=nil
    return {status="RELEASED",reason=reason,request=request,outcome=outcome,guardedRecovery=true}
end

function Compatibility:dispatch(picture,evaluated,candidate)
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
    local capability=self:_capability()
    if capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",guardedRecovery=true} end

    local acquired,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.acquireSupportingRegulationAuthority(self.runtime,bridge.commitmentId,bridge.progressAssemblyId,{governingPurpose=bridge.governingPurpose})
    if acquired==nil then return {status="NO_DISPATCH",reason=reason,guardedRecovery=true,commitmentId=bridge.commitmentId} end
    local request=self:_legacyRegulationRequest(picture,evaluated,candidate,acquired.commitment,acquired.authorityToken,bridge,"APPLY")
    local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
    if started~=true then
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,bridge.commitmentId,bridge.progressAssemblyId,{reason="D0123_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(bridge.commitmentId,bridge.progressAssemblyId)})
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,guardedRecovery=true}
    end
    self.guardedRecoveryLease={commitmentId=bridge.commitmentId,yieldAssemblyId=bridge.yieldAssemblyId,progressAssemblyId=bridge.progressAssemblyId,progressReferenceKey=bridge.progressReferenceKey,governingPurpose=bridge.governingPurpose,authorityTokenId=acquired.authorityToken.identity,requestId=request.identity}
    self.guardedRecoveryApplyCount=self.guardedRecoveryApplyCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind="BOUNDED_REGULATION_DISPATCH_ACCEPTED",capability="REGULATE_SPEED"},nil)
    logInfo("D0123_APPLY commitment=%s progress=%s ref=%s request=%s speedLiteral=%.2fkmh purpose=%s",tostring(bridge.commitmentId),tostring(bridge.progressAssemblyId),tostring(bridge.progressReferenceKey),tostring(request.identity),tonumber(request.target.maxSpeedKmh) or 0,tostring(bridge.governingPurpose))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=acquired.commitment,candidate=candidate,result=result,guardedRecovery=true}
end

function Compatibility:retireTrafficLeaseForCommitment(commitmentId,reason)
    local lease=self.guardedRecoveryLease
    if type(commitmentId)~="string" or lease==nil or lease.commitmentId~=commitmentId then return {released=0} end
    local capability=self:_capability()
    if capability~=nil and type(capability.clearRegulationLeaseByReference)=="function" then
        capability:clearRegulationLeaseByReference(lease.progressReferenceKey,D0123_OWNER_TAG)
    end
    self.guardedRecoveryLease=nil
    self.guardedRecoveryReleaseCount=self.guardedRecoveryReleaseCount+1
    logInfo("D0123_DEPENDENT_COMMITMENT_TERMINATED commitment=%s progress=%s reason=%s",
        tostring(commitmentId),tostring(lease.progressAssemblyId),tostring(reason))
    return {released=1}
end

function Compatibility:getGuardedRecoveryStatus()
    local lease=self.guardedRecoveryLease
    return {active=lease~=nil,commitmentId=lease and lease.commitmentId or nil,progressReferenceKey=lease and lease.progressReferenceKey or nil,applyCount=self.guardedRecoveryApplyCount,releaseCount=self.guardedRecoveryReleaseCount,ownerTag=D0123_OWNER_TAG}
end
