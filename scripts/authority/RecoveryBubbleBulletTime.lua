--- Protects a current Blocked Worker Recovery with Operation-wide Bullet Time without acquiring other workers' movement objectives.
-- Specification Jurisdictions: `BLOCKED_WORKER_RECOVERY`

OuttaMyWay.RecoveryBubbleBulletTime = {}
local BulletTime = OuttaMyWay.RecoveryBubbleBulletTime
BulletTime.__index = BulletTime

local OWNER_TAG = "RECOVERY_BUBBLE_BULLET_TIME"
local GOVERNING_PURPOSE = "BLOCKED_WORKER_RECOVERY_BUBBLE_BULLET_TIME"
local AUTHORITY_ROLE = "SUPPORTING_SPEED_CEILING"
local INTENT_REVELATION_CREEP_KMH = 1.0

local publication=OuttaMyWay.LogPublication.origin("BOUNDED_AUTHORITY")
local function logInfo(code,formatText,...)
    return publication:info("DEBUG",code,formatText,...)
end

local function recoveryBridge(candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.blockedWorkerRecoveryBridge or nil
    if type(bridge)~="table" or bridge.architecture~="BLOCKED_WORKER_RECOVERY"
        or type(bridge.operationId)~="string" or type(bridge.assemblyId)~="string" then
        return nil
    end
    return bridge
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

local function protectedParticipantsAtFormation(picture,candidate)
    local bridge=recoveryBridge(candidate)
    if bridge==nil then return nil,nil,"RECOVERY_BUBBLE_CONTEXT_UNAVAILABLE" end
    local ids,seen={},{}
    for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(operationMembers(picture,bridge.operationId)) do
        if assemblyId~=bridge.assemblyId and type(assemblyId)=="string" and seen[assemblyId]~=true then
            seen[assemblyId]=true
            ids[#ids+1]=assemblyId
        end
    end
    table.sort(ids)
    if #ids>2 then return nil,bridge,"RECOVERY_BUBBLE_REQUIRES_AT_MOST_TWO_OTHER_PARTICIPANTS" end
    local participants={}
    for _,assemblyId in ipairs(ids) do
        local referenceKey=referenceForAssembly(picture,assemblyId)
        if type(referenceKey)~="string" then
            return nil,bridge,"RECOVERY_BUBBLE_PARTICIPANT_REFERENCE_UNAVAILABLE:"..tostring(assemblyId)
        end
        participants[#participants+1]={assemblyId=assemblyId,referenceKey=referenceKey}
    end
    return participants,bridge,nil
end

function BulletTime.new(runtime)
    return setmetatable({runtime=runtime,protectionsByCommitmentId={}},BulletTime)
end

function BulletTime:_regulationControl()
    return self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher.regulationControl or nil
end

function BulletTime:_clearPhysical(lease,reason)
    if lease==nil or lease.physicalActive~=true then return false end
    local control=self:_regulationControl()
    local cleared=false
    if control~=nil and type(control.clearRegulationLeaseByReference)=="function" then
        cleared=control:clearRegulationLeaseByReference(lease.referenceKey,OWNER_TAG)==true
    end
    if type(lease.boundedAuthorityId)=="string" and self.runtime.boundedAuthority~=nil then
        self.runtime.boundedAuthority:release(lease.boundedAuthorityId,reason)
    end
    lease.physicalActive=false
    lease.boundedAuthorityId=nil
    logInfo("RECOVERY_BUBBLE_BULLET_TIME_RELEASE",
        "commitment=%s assembly=%s ref=%s cleared=%s reason=%s",
        tostring(lease.commitmentId),tostring(lease.assemblyId),tostring(lease.referenceKey),tostring(cleared),tostring(reason))
    return cleared
end

function BulletTime:_clearProtection(protection,reason)
    if protection==nil then return 0 end
    local cleared=0
    for _,lease in ipairs(protection.leases or {}) do
        if self:_clearPhysical(lease,reason) then cleared=cleared+1 end
    end
    return cleared
end

function BulletTime:_releaseEndedRecoveryProtection()
    for commitmentId,protection in OuttaMyWay.ValueRecord.pairs(self.protectionsByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority
            and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then
            self:_clearProtection(protection,"RECOVERY_BUBBLE_RESOLUTION_ENDED")
            self.protectionsByCommitmentId[commitmentId]=nil
        end
    end
end

function BulletTime:prepareAtRecoveryBubbleFormation(picture,candidate,applied)
    if type(applied)~="table" or applied.commitment==nil then
        return nil,"RECOVERY_BUBBLE_COMMITMENT_CONTEXT_REQUIRED"
    end
    local commitmentId=applied.commitment.identity
    if self.protectionsByCommitmentId[commitmentId]~=nil then
        return self.protectionsByCommitmentId[commitmentId],nil
    end

    local participants,bridge,reason=protectedParticipantsAtFormation(picture,candidate)
    if reason~=nil then return nil,reason end
    if #participants==0 then
        local notRequired={
            status="NOT_REQUIRED",commitmentId=commitmentId,operationId=bridge.operationId,
            recoveringAssemblyId=bridge.assemblyId,leases={}
        }
        self.protectionsByCommitmentId[commitmentId]=notRequired
        return notRequired,nil
    end

    local entries,relevantAssemblyIds,leases={},{},{}
    for _,participant in ipairs(participants) do
        entries[#entries+1]={
            assemblyId=participant.assemblyId,commitmentId=commitmentId,capability="REGULATE_SPEED",
            effectClass="SPEED_LIMIT",authorityRole=AUTHORITY_ROLE
        }
        relevantAssemblyIds[#relevantAssemblyIds+1]=participant.assemblyId
        leases[#leases+1]={
            commitmentId=commitmentId,assemblyId=participant.assemblyId,referenceKey=participant.referenceKey,
            physicalActive=false,status="PREPARED"
        }
    end
    local composition=OuttaMyWay.EffectiveActuationComposition.create({
        identity=self.runtime.identities:issue("COMPOSITION"),epoch=self.runtime.epochs:next(),
        entries=entries,relevantAssemblyIds=relevantAssemblyIds
    })
    local protection={
        status="PREPARED",commitmentId=commitmentId,operationId=bridge.operationId,
        recoveringAssemblyId=bridge.assemblyId,ownerTag=OWNER_TAG,governingPurpose=GOVERNING_PURPOSE,
        maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,authorityRole=AUTHORITY_ROLE,
        effectiveActuationCompositionId=applied.commitment.effectiveActuationCompositionId,
        supportingSpeedCeilingComposition=composition,leases=leases
    }
    self.protectionsByCommitmentId[commitmentId]=protection
    logInfo("RECOVERY_BUBBLE_BULLET_TIME_PREPARED",
        "commitment=%s operation=%s recovering=%s protectedCount=%d movementComposition=%s ceilingComposition=%s cap=%.2fkmh",
        tostring(commitmentId),tostring(bridge.operationId),tostring(bridge.assemblyId),#leases,
        tostring(protection.effectiveActuationCompositionId),tostring(composition.identity),INTENT_REVELATION_CREEP_KMH)
    return protection,nil
end

function BulletTime:activatePrepared(commitmentId,requestContext,candidate)
    local protection=self.protectionsByCommitmentId[commitmentId]
    if protection==nil then return nil,"RECOVERY_BUBBLE_PREPARATION_MISSING" end
    if protection.status=="NOT_REQUIRED" or protection.status=="ACTIVE" then return protection,nil end
    if protection.status~="PREPARED" then return nil,"RECOVERY_BUBBLE_PREPARED_STATE_INVALID:"..tostring(protection.status) end

    local commitment=self.runtime.commitments:get(commitmentId)
    local current=self.runtime.responsibilityTransitionAuthority
        and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
    if commitment==nil or commitment.state~="ACTIVE" or current==nil then
        return nil,"RECOVERY_BUBBLE_CURRENT_RESOLUTION_REQUIRED"
    end
    if requestContext==nil or requestContext.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId
        or protection.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId then
        return nil,"RECOVERY_BUBBLE_COMPOSITION_MISMATCH"
    end

    for _,lease in ipairs(protection.leases) do
        local grant,grantReason=self.runtime.boundedAuthority:authorize({
            responsibilityId=current.identity,commitmentId=commitmentId,assemblyId=lease.assemblyId,
            capability="REGULATE_SPEED",
            target={
                kind="REGULATION_LEASE",vehicleReferenceKey=lease.referenceKey,ownerTag=OWNER_TAG,
                maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,governingPurpose=GOVERNING_PURPOSE
            },
            authorityRole=AUTHORITY_ROLE,
            operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
            effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
            supportingSpeedCeilingComposition=protection.supportingSpeedCeilingComposition,
            preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {},
            provenance={
                source="RecoveryBubbleBulletTime",purpose=GOVERNING_PURPOSE,operationId=protection.operationId,
                recoveringAssemblyId=protection.recoveringAssemblyId,protectedAssemblyId=lease.assemblyId
            }
        })
        if grant==nil then
            self:_clearProtection(protection,"RECOVERY_BUBBLE_ACTIVATION_ROLLBACK")
            return nil,"RECOVERY_BUBBLE_BOUNDED_AUTHORITY_FAILED:"..tostring(grantReason)
        end

        local request,requestReason=self.runtime.boundedAuthority:materializeRequest({
            boundedAuthorityId=grant.identity,
            target={
                kind="REGULATION_LEASE",operation="APPLY",vehicleReferenceKey=lease.referenceKey,ownerTag=OWNER_TAG,
                maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,governingPurpose=GOVERNING_PURPOSE
            },
            operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
            preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {}
        })
        if request==nil then
            self.runtime.boundedAuthority:release(grant.identity,"RECOVERY_BUBBLE_REQUEST_FAILED")
            self:_clearProtection(protection,"RECOVERY_BUBBLE_ACTIVATION_ROLLBACK")
            return nil,"RECOVERY_BUBBLE_REQUEST_FAILED:"..tostring(requestReason)
        end

        local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
        if started~=true then
            self.runtime.boundedAuthority:release(grant.identity,"RECOVERY_BUBBLE_CONTROL_REJECTED")
            self:_clearProtection(protection,"RECOVERY_BUBBLE_ACTIVATION_ROLLBACK")
            return nil,"RECOVERY_BUBBLE_CONTROL_REJECTED:"..tostring(result)
        end
        if type(self.runtime.liveControlDispatcher.notifyAccepted)=="function" then
            self.runtime.liveControlDispatcher:notifyAccepted(request,{
                kind="RECOVERY_BUBBLE_BULLET_TIME_APPLIED",capability="REGULATE_SPEED",
                maxSpeedKmh=INTENT_REVELATION_CREEP_KMH
            })
        end
        lease.status="ACTIVE"
        lease.boundedAuthorityId=grant.identity
        lease.controlRequestId=request.identity
        lease.physicalActive=true
    end

    protection.status="ACTIVE"
    logInfo("RECOVERY_BUBBLE_BULLET_TIME_APPLIED",
        "commitment=%s operation=%s recovering=%s protectedCount=%d cap=%.2fkmh",
        tostring(commitmentId),tostring(protection.operationId),tostring(protection.recoveringAssemblyId),
        #protection.leases,INTENT_REVELATION_CREEP_KMH)
    return protection,nil
end

function BulletTime:releaseForCommitment(commitmentId,reason)
    local protection=self.protectionsByCommitmentId[commitmentId]
    if protection==nil then return false end
    self:_clearProtection(protection,reason or "RECOVERY_BUBBLE_BULLET_TIME_RELEASE")
    self.protectionsByCommitmentId[commitmentId]=nil
    return true
end

function BulletTime:releaseUnsupportedProtection(live)
    local picture=live and live.picture or nil
    local outcomes={}
    for commitmentId,protection in OuttaMyWay.ValueRecord.pairs(self.protectionsByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority
            and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then
            self:_clearProtection(protection,"RECOVERY_BUBBLE_RESOLUTION_ENDED")
            self.protectionsByCommitmentId[commitmentId]=nil
            outcomes[#outcomes+1]={commitmentId=commitmentId,status="RELEASED",reason="RECOVERY_BUBBLE_RESOLUTION_ENDED"}
        elseif protection.status=="ACTIVE" and picture~=nil then
            if not operationContainsAssembly(picture,protection.operationId,protection.recoveringAssemblyId) then
                self:_clearProtection(protection,"RECOVERY_BUBBLE_RECOVERING_PARTICIPANT_LEFT_LOCAL_OPERATION")
                protection.status="QUIESCENT_BASIS_ENDED"
                outcomes[#outcomes+1]={
                    commitmentId=commitmentId,status=protection.status,
                    reason="RECOVERY_BUBBLE_RECOVERING_PARTICIPANT_LEFT_LOCAL_OPERATION"
                }
            else
                for _,lease in ipairs(protection.leases) do
                    if lease.physicalActive==true and not operationContainsAssembly(picture,protection.operationId,lease.assemblyId) then
                        self:_clearPhysical(lease,"RECOVERY_BUBBLE_PARTICIPANT_LEFT_LOCAL_OPERATION")
                        lease.status="QUIESCENT_BASIS_ENDED"
                        outcomes[#outcomes+1]={
                            commitmentId=commitmentId,assemblyId=lease.assemblyId,status=lease.status,
                            reason="RECOVERY_BUBBLE_PARTICIPANT_LEFT_LOCAL_OPERATION"
                        }
                    end
                end
            end
        end
    end
    return outcomes
end

function BulletTime:releaseAll(reason)
    for commitmentId,protection in OuttaMyWay.ValueRecord.pairs(self.protectionsByCommitmentId) do
        self:_clearProtection(protection,reason or "RECOVERY_BUBBLE_BULLET_TIME_RELEASE_ALL")
        self.protectionsByCommitmentId[commitmentId]=nil
    end
end

function BulletTime:update() self:_releaseEndedRecoveryProtection() end
function BulletTime:loadMap() end
function BulletTime:deleteMap() self:releaseAll("MAP_DELETE") end
function BulletTime:keyEvent() end
function BulletTime:mouseEvent() end
function BulletTime:draw() end

function BulletTime:getProtection(commitmentId)
    return self.protectionsByCommitmentId[commitmentId]
end

function BulletTime:getOwnerTag() return OWNER_TAG end
function BulletTime:getSpeedKmh() return INTENT_REVELATION_CREEP_KMH end
