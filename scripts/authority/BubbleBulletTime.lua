--- Applies purpose-scoped supporting speed ceilings to non-principal participants of a current Resolution Bubble.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`, `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.BubbleBulletTime = {}
local Bubble = OuttaMyWay.BubbleBulletTime
Bubble.__index = Bubble

local PASSAGE_OWNER_TAG = "BUBBLE_BULLET_TIME"
local PASSAGE_GOVERNING_PURPOSE = "COOPERATIVE_PASSAGE_BUBBLE_BULLET_TIME"
local AUTHORITY_ROLE = "SUPPORTING_SPEED_CEILING"
local INTENT_REVELATION_CREEP_KMH = 1.0

local publication=OuttaMyWay.LogPublication.origin("BOUNDED_AUTHORITY")
local function logInfo(code,formatText,...)
    return publication:info("DEBUG",code,formatText,...)
end

local function passagePairSet(candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
    if type(bridge)~="table" then return nil,nil end
    local pair={}
    local count=0
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(bridge.assemblyIds or {}) do
        if type(assemblyId)=="string" and pair[assemblyId]~=true then pair[assemblyId]=true; count=count+1 end
    end
    if count~=2 then return nil,bridge end
    return pair,bridge
end

local function referenceForAssembly(picture,assemblyId)
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.motionEvidence or {}) do
        if item.assemblyId==assemblyId and type(item.assemblyReferenceKey)=="string" then return item.assemblyReferenceKey end
    end
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.physicalSpaceEvidence or {}) do
        if item.assemblyId==assemblyId and type(item.assemblyReferenceKey)=="string" then return item.assemblyReferenceKey end
    end
    for _,item in OuttaMyWay.ValueRecord.ipairs(picture and picture.productiveContinuationKnowledge or {}) do
        if item.assemblyId==assemblyId and type(item.assemblyReferenceKey)=="string" then return item.assemblyReferenceKey end
    end
    return nil
end

local function operationMembers(picture,operationId)
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture and picture.situations or {}) do
        if situation.operationId==operationId then return situation.memberAssemblyIds or {} end
    end
    return {}
end

local function operationContainsAssembly(picture,operationId,assemblyId)
    for _,memberId in OuttaMyWay.ValueRecord.ipairs(operationMembers(picture,operationId)) do
        if memberId==assemblyId then return true end
    end
    return false
end

local function independentThirdAtFormation(picture,candidate)
    local pair,bridge=passagePairSet(candidate)
    if pair==nil or type(bridge.operationId)~="string" then return nil,nil,"PASSAGE_PAIR_CONTEXT_UNAVAILABLE" end
    local thirdIds={}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(operationMembers(picture,bridge.operationId)) do
        if pair[assemblyId]~=true then thirdIds[#thirdIds+1]=assemblyId end
    end
    if #thirdIds==0 then return nil,bridge,nil end
    if #thirdIds~=1 then return nil,bridge,"BUBBLE_BULLET_TIME_REQUIRES_AT_MOST_ONE_INDEPENDENT_THIRD_PARTY" end
    local assemblyId=thirdIds[1]
    local referenceKey=referenceForAssembly(picture,assemblyId)
    if type(referenceKey)~="string" then return nil,bridge,"BUBBLE_BULLET_TIME_THIRD_PARTY_REFERENCE_UNAVAILABLE" end
    return {assemblyId=assemblyId,referenceKey=referenceKey},bridge,nil
end

local function syncSingleLease(protection)
    if protection==nil or #(protection.leases or {})~=1 then return protection end
    local lease=protection.leases[1]
    protection.assemblyId=lease.assemblyId
    protection.referenceKey=lease.referenceKey
    protection.ownerTag=lease.ownerTag
    protection.maxSpeedKmh=lease.maxSpeedKmh
    protection.physicalActive=lease.physicalActive
    protection.boundedAuthorityId=lease.boundedAuthorityId
    protection.controlRequestId=lease.controlRequestId
    return protection
end

function Bubble.new(runtime)
    return setmetatable({runtime=runtime,protectionsByCommitmentId={}},Bubble)
end

function Bubble:_regulationControl()
    return self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher.regulationControl or nil
end

function Bubble:_clearPhysical(lease,reason,logCodePrefix)
    if lease==nil or lease.physicalActive~=true then return false end
    local control=self:_regulationControl()
    local cleared=false
    if control~=nil and type(control.clearRegulationLeaseByReference)=="function" then
        cleared=control:clearRegulationLeaseByReference(lease.referenceKey,lease.ownerTag)==true
    end
    if type(lease.boundedAuthorityId)=="string" and self.runtime.boundedAuthority~=nil then
        self.runtime.boundedAuthority:release(lease.boundedAuthorityId,reason)
    end
    lease.physicalActive=false
    lease.boundedAuthorityId=nil
    logInfo((logCodePrefix or "BUBBLE_BULLET_TIME").."_RELEASE",
        "commitment=%s assembly=%s role=%s ref=%s cap=%.2fkmh cleared=%s reason=%s",
        tostring(lease.commitmentId),tostring(lease.assemblyId),tostring(lease.role),
        tostring(lease.referenceKey),tonumber(lease.maxSpeedKmh) or -1,tostring(cleared),tostring(reason))
    return cleared
end

function Bubble:_clearProtection(protection,reason)
    if protection==nil then return 0 end
    local cleared=0
    for _,lease in ipairs(protection.leases or {}) do
        if self:_clearPhysical(lease,reason,protection.logCodePrefix) then cleared=cleared+1 end
    end
    syncSingleLease(protection)
    return cleared
end

function Bubble:_releaseEndedResolutionProtection()
    for commitmentId,protection in OuttaMyWay.ValueRecord.pairs(self.protectionsByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority
            and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then
            self:_clearProtection(protection,"BUBBLE_RESOLUTION_EPOCH_ENDED")
            self.protectionsByCommitmentId[commitmentId]=nil
        end
    end
end

function Bubble:prepareProtection(picture,applied,values)
    values=values or {}
    if type(applied)~="table" or applied.commitment==nil then
        return nil,"BUBBLE_SUPPORTING_PROTECTION_COMMITMENT_CONTEXT_REQUIRED"
    end
    if type(values.operationId)~="string" then return nil,"BUBBLE_SUPPORTING_PROTECTION_OPERATION_REQUIRED" end
    local commitmentId=applied.commitment.identity
    if self.protectionsByCommitmentId[commitmentId]~=nil then
        return self.protectionsByCommitmentId[commitmentId],nil
    end

    local leases,entries,relevantAssemblyIds={}, {}, {}
    local seen={}
    for _,spec in ipairs(values.leaseSpecs or {}) do
        local assemblyId=spec and spec.assemblyId or nil
        local speed=spec and tonumber(spec.maxSpeedKmh) or nil
        if type(assemblyId)~="string" or speed==nil or speed<0
            or type(spec.ownerTag)~="string" or type(spec.governingPurpose)~="string" then
            return nil,"BUBBLE_SUPPORTING_PROTECTION_LEASE_SPEC_INVALID"
        end
        if seen[assemblyId]==true then return nil,"BUBBLE_SUPPORTING_PROTECTION_DUPLICATE_ASSEMBLY:"..tostring(assemblyId) end
        seen[assemblyId]=true
        local referenceKey=spec.referenceKey or referenceForAssembly(picture,assemblyId)
        if type(referenceKey)~="string" then
            return nil,"BUBBLE_SUPPORTING_PROTECTION_REFERENCE_UNAVAILABLE:"..tostring(assemblyId)
        end
        entries[#entries+1]={
            assemblyId=assemblyId,commitmentId=commitmentId,capability="REGULATE_SPEED",
            effectClass="SPEED_LIMIT",authorityRole=AUTHORITY_ROLE
        }
        relevantAssemblyIds[#relevantAssemblyIds+1]=assemblyId
        leases[#leases+1]={
            commitmentId=commitmentId,assemblyId=assemblyId,referenceKey=referenceKey,
            ownerTag=spec.ownerTag,governingPurpose=spec.governingPurpose,
            maxSpeedKmh=speed,role=spec.role or "BULLET_TIME",
            effectKind=spec.effectKind or "BUBBLE_SUPPORTING_SPEED_APPLIED",
            physicalActive=false,status="PREPARED"
        }
    end

    local prefix=values.logCodePrefix or "BUBBLE_BULLET_TIME"
    if #leases==0 then
        local notRequired={
            status="NOT_REQUIRED",commitmentId=commitmentId,operationId=values.operationId,
            leases={},logCodePrefix=prefix,releaseWhenAssemblyLeaves=values.releaseWhenAssemblyLeaves or {}
        }
        self.protectionsByCommitmentId[commitmentId]=notRequired
        return notRequired,nil
    end

    local composition=OuttaMyWay.EffectiveActuationComposition.create({
        identity=self.runtime.identities:issue("COMPOSITION"),epoch=self.runtime.epochs:next(),
        entries=entries,relevantAssemblyIds=relevantAssemblyIds
    })
    local protection={
        status="PREPARED",commitmentId=commitmentId,operationId=values.operationId,
        leases=leases,logCodePrefix=prefix,provenanceSource=values.provenanceSource or "BubbleBulletTime",
        effectiveActuationCompositionId=applied.commitment.effectiveActuationCompositionId,
        supportingSpeedCeilingComposition=composition,
        releaseWhenAssemblyLeaves=values.releaseWhenAssemblyLeaves or {}
    }
    self.protectionsByCommitmentId[commitmentId]=protection
    syncSingleLease(protection)
    logInfo(prefix.."_PREPARED",
        "commitment=%s operation=%s protectedCount=%d movementComposition=%s ceilingComposition=%s",
        tostring(commitmentId),tostring(values.operationId),#leases,
        tostring(protection.effectiveActuationCompositionId),tostring(composition.identity))
    return protection,nil
end

-- Cooperative Passage wrapper: A/B remain movement principals; an independent
-- third participant, when present, receives exactly 1 km/h Bubble Bullet Time.
function Bubble:prepareAtBubbleFormation(picture,candidate,applied)
    local third,bridge,reason=independentThirdAtFormation(picture,candidate)
    if reason~=nil then return nil,reason end
    local leaseSpecs={}
    if third~=nil then
        leaseSpecs[1]={
            assemblyId=third.assemblyId,referenceKey=third.referenceKey,
            ownerTag=PASSAGE_OWNER_TAG,governingPurpose=PASSAGE_GOVERNING_PURPOSE,
            maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,role="BULLET_TIME",
            effectKind="BUBBLE_BULLET_TIME_APPLIED"
        }
    end
    return self:prepareProtection(picture,applied,{
        operationId=bridge.operationId,leaseSpecs=leaseSpecs,
        logCodePrefix="BUBBLE_BULLET_TIME",provenanceSource="BubbleBulletTime"
    })
end

function Bubble:activatePrepared(commitmentId,requestContext,candidate)
    local protection=self.protectionsByCommitmentId[commitmentId]
    if protection==nil then return nil,"BUBBLE_SUPPORTING_PROTECTION_PREPARATION_MISSING" end
    if protection.status=="NOT_REQUIRED" or protection.status=="ACTIVE" then return protection,nil end
    if protection.status~="PREPARED" then
        return nil,"BUBBLE_SUPPORTING_PROTECTION_PREPARED_STATE_INVALID:"..tostring(protection.status)
    end

    local commitment=self.runtime.commitments:get(commitmentId)
    local current=self.runtime.responsibilityTransitionAuthority
        and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
    if commitment==nil or commitment.state~="ACTIVE" or current==nil then
        return nil,"BUBBLE_SUPPORTING_PROTECTION_CURRENT_RESOLUTION_REQUIRED"
    end
    if requestContext==nil or requestContext.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId
        or protection.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId then
        return nil,"BUBBLE_SUPPORTING_PROTECTION_COMPOSITION_MISMATCH"
    end

    for _,lease in ipairs(protection.leases) do
        local grantTarget={
            kind="REGULATION_LEASE",vehicleReferenceKey=lease.referenceKey,ownerTag=lease.ownerTag,
            maxSpeedKmh=lease.maxSpeedKmh,governingPurpose=lease.governingPurpose
        }
        local grant,grantReason=self.runtime.boundedAuthority:authorize({
            responsibilityId=current.identity,commitmentId=commitmentId,assemblyId=lease.assemblyId,
            capability="REGULATE_SPEED",target=grantTarget,authorityRole=AUTHORITY_ROLE,
            operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
            effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
            supportingSpeedCeilingComposition=protection.supportingSpeedCeilingComposition,
            preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {},
            provenance={
                source=protection.provenanceSource,purpose=lease.governingPurpose,
                operationId=protection.operationId,protectedAssemblyId=lease.assemblyId,role=lease.role
            }
        })
        if grant==nil then
            self:_clearProtection(protection,"BUBBLE_SUPPORTING_PROTECTION_ACTIVATION_ROLLBACK")
            return nil,"BUBBLE_SUPPORTING_PROTECTION_BOUNDED_AUTHORITY_FAILED:"..tostring(grantReason)
        end

        local request,requestReason=self.runtime.boundedAuthority:materializeRequest({
            boundedAuthorityId=grant.identity,
            target={
                kind="REGULATION_LEASE",operation="APPLY",vehicleReferenceKey=lease.referenceKey,
                ownerTag=lease.ownerTag,maxSpeedKmh=lease.maxSpeedKmh,governingPurpose=lease.governingPurpose
            },
            operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
            preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {}
        })
        if request==nil then
            self.runtime.boundedAuthority:release(grant.identity,"BUBBLE_SUPPORTING_PROTECTION_REQUEST_FAILED")
            self:_clearProtection(protection,"BUBBLE_SUPPORTING_PROTECTION_ACTIVATION_ROLLBACK")
            return nil,"BUBBLE_SUPPORTING_PROTECTION_REQUEST_FAILED:"..tostring(requestReason)
        end

        local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
        if started~=true then
            self.runtime.boundedAuthority:release(grant.identity,"BUBBLE_SUPPORTING_PROTECTION_CONTROL_REJECTED")
            self:_clearProtection(protection,"BUBBLE_SUPPORTING_PROTECTION_ACTIVATION_ROLLBACK")
            return nil,"BUBBLE_SUPPORTING_PROTECTION_CONTROL_REJECTED:"..tostring(result)
        end
        if type(self.runtime.liveControlDispatcher.notifyAccepted)=="function" then
            self.runtime.liveControlDispatcher:notifyAccepted(request,{
                kind=lease.effectKind,capability="REGULATE_SPEED",maxSpeedKmh=lease.maxSpeedKmh,role=lease.role
            })
        end
        lease.status="ACTIVE"
        lease.boundedAuthorityId=grant.identity
        lease.controlRequestId=request.identity
        lease.physicalActive=true
        logInfo(protection.logCodePrefix.."_APPLIED",
            "commitment=%s operation=%s assembly=%s role=%s ref=%s request=%s cap=%.2fkmh",
            tostring(commitmentId),tostring(protection.operationId),tostring(lease.assemblyId),tostring(lease.role),
            tostring(lease.referenceKey),tostring(request.identity),lease.maxSpeedKmh)
    end

    protection.status="ACTIVE"
    syncSingleLease(protection)
    return protection,nil
end

function Bubble:releaseForCommitment(commitmentId,reason)
    local protection=self.protectionsByCommitmentId[commitmentId]
    if protection==nil then return false end
    self:_clearProtection(protection,reason or "BUBBLE_SUPPORTING_PROTECTION_RELEASE")
    self.protectionsByCommitmentId[commitmentId]=nil
    return true
end

function Bubble:releaseUnsupportedProtection(live)
    local picture=live and live.picture or nil
    local outcomes={}
    for commitmentId,protection in OuttaMyWay.ValueRecord.pairs(self.protectionsByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority
            and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then
            self:_clearProtection(protection,"BUBBLE_RESOLUTION_EPOCH_ENDED")
            self.protectionsByCommitmentId[commitmentId]=nil
            outcomes[#outcomes+1]={commitmentId=commitmentId,status="RELEASED",reason="BUBBLE_RESOLUTION_EPOCH_ENDED"}
        elseif picture~=nil then
            local principalLeft=nil
            for _,assemblyId in ipairs(protection.releaseWhenAssemblyLeaves or {}) do
                if not operationContainsAssembly(picture,protection.operationId,assemblyId) then principalLeft=assemblyId; break end
            end
            if principalLeft~=nil then
                self:_clearProtection(protection,"BUBBLE_PRINCIPAL_LEFT_LOCAL_OPERATION")
                protection.status="QUIESCENT_BASIS_ENDED"
                outcomes[#outcomes+1]={
                    commitmentId=commitmentId,assemblyId=principalLeft,status=protection.status,
                    reason="BUBBLE_PRINCIPAL_LEFT_LOCAL_OPERATION"
                }
            elseif protection.status=="ACTIVE" then
                for _,lease in ipairs(protection.leases or {}) do
                    if lease.physicalActive==true
                        and not operationContainsAssembly(picture,protection.operationId,lease.assemblyId) then
                        self:_clearPhysical(lease,"BUBBLE_PROTECTED_PARTICIPANT_LEFT_LOCAL_OPERATION",protection.logCodePrefix)
                        lease.status="QUIESCENT_BASIS_ENDED"
                        outcomes[#outcomes+1]={
                            commitmentId=commitmentId,assemblyId=lease.assemblyId,status=lease.status,
                            reason="BUBBLE_PROTECTED_PARTICIPANT_LEFT_LOCAL_OPERATION"
                        }
                    end
                end
                syncSingleLease(protection)
            end
        end
    end
    return outcomes
end

function Bubble:releaseAll(reason)
    for commitmentId,protection in OuttaMyWay.ValueRecord.pairs(self.protectionsByCommitmentId) do
        self:_clearProtection(protection,reason or "BUBBLE_SUPPORTING_PROTECTION_RELEASE_ALL")
        self.protectionsByCommitmentId[commitmentId]=nil
    end
end

function Bubble:update() self:_releaseEndedResolutionProtection() end
function Bubble:loadMap() end
function Bubble:deleteMap() self:releaseAll("MAP_DELETE") end
function Bubble:keyEvent() end
function Bubble:mouseEvent() end
function Bubble:draw() end

function Bubble:getProtection(commitmentId)
    return self.protectionsByCommitmentId[commitmentId]
end

function Bubble:getLease(commitmentId)
    local protection=self.protectionsByCommitmentId[commitmentId]
    if protection==nil then return nil end
    if #(protection.leases or {})==1 then return protection.leases[1] end
    return protection
end

function Bubble:getOwnerTag() return PASSAGE_OWNER_TAG end
function Bubble:getSpeedKmh() return INTENT_REVELATION_CREEP_KMH end
