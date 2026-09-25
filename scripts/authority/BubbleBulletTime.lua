--- Establishes and reconciles Cooperative Passage third-party Bullet Time without creating another semantic responsibility.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`

OuttaMyWay.BubbleBulletTime = {}
local BulletTime = OuttaMyWay.BubbleBulletTime
BulletTime.__index = BulletTime

local OWNER_TAG = "BUBBLE_BULLET_TIME"
local GOVERNING_PURPOSE = "COOPERATIVE_PASSAGE_BUBBLE_BULLET_TIME"
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

local function independentThirdAtFormation(picture,candidate)
    local pair,bridge=passagePairSet(candidate)
    if pair==nil or type(bridge.operationId)~="string" then return nil,nil,"PASSAGE_PAIR_CONTEXT_UNAVAILABLE" end
    local thirdIds={}
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture and picture.situations or {}) do
        if situation.operationId==bridge.operationId then
            for _,assemblyId in OuttaMyWay.ValueRecord.ipairs(situation.memberAssemblyIds or {}) do
                if pair[assemblyId]~=true then thirdIds[#thirdIds+1]=assemblyId end
            end
            break
        end
    end
    if OuttaMyWay.ValueRecord.length(thirdIds)==0 then return nil,bridge,nil end
    if OuttaMyWay.ValueRecord.length(thirdIds)~=1 then return nil,bridge,"BUBBLE_BULLET_TIME_REQUIRES_AT_MOST_ONE_INDEPENDENT_THIRD_PARTY" end
    local assemblyId=thirdIds[1]
    local referenceKey=referenceForAssembly(picture,assemblyId)
    if type(referenceKey)~="string" then return nil,bridge,"BUBBLE_BULLET_TIME_THIRD_PARTY_REFERENCE_UNAVAILABLE" end
    return {assemblyId=assemblyId,referenceKey=referenceKey},bridge,nil
end

local function operationContainsAssembly(picture,operationId,assemblyId)
    for _,situation in OuttaMyWay.ValueRecord.ipairs(picture and picture.situations or {}) do
        if situation.operationId==operationId then
            for _,memberId in OuttaMyWay.ValueRecord.ipairs(situation.memberAssemblyIds or {}) do
                if memberId==assemblyId then return true end
            end
            return false
        end
    end
    return false
end

function BulletTime.new(runtime)
    return setmetatable({runtime=runtime,leasesByCommitmentId={}},BulletTime)
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
    logInfo("BUBBLE_BULLET_TIME_RELEASE","commitment=%s assembly=%s ref=%s cleared=%s reason=%s",tostring(lease.commitmentId),tostring(lease.assemblyId),tostring(lease.referenceKey),tostring(cleared),tostring(reason))
    return cleared
end

function BulletTime:_releaseEndedResolutionProtection()
    for commitmentId,lease in OuttaMyWay.ValueRecord.pairs(self.leasesByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then
            self:_clearPhysical(lease,"BUBBLE_RESOLUTION_EPOCH_ENDED")
            self.leasesByCommitmentId[commitmentId]=nil
        end
    end
end

-- Bubble Formation may revise mechanical supporting ownership before the
-- Resolution responsibility is exposed, but positive physical permission must
-- wait until Responsibility Transition has made that Resolution current.
function BulletTime:prepareAtBubbleFormation(picture,candidate,applied)
    if type(applied)~="table" or applied.commitment==nil then return nil,"BUBBLE_BULLET_TIME_COMMITMENT_CONTEXT_REQUIRED" end
    local commitmentId=applied.commitment.identity
    if self.leasesByCommitmentId[commitmentId]~=nil then return self.leasesByCommitmentId[commitmentId],nil end

    local third,bridge,thirdReason=independentThirdAtFormation(picture,candidate)
    if thirdReason~=nil then return nil,thirdReason end
    if third==nil then
        local notRequired={status="NOT_REQUIRED",commitmentId=commitmentId,operationId=bridge and bridge.operationId or nil,pairAssemblyIds=bridge and bridge.assemblyIds or {}}
        self.leasesByCommitmentId[commitmentId]=notRequired
        return notRequired,nil
    end

    local supportingComposition=OuttaMyWay.EffectiveActuationComposition.create({
        identity=self.runtime.identities:issue("COMPOSITION"),epoch=self.runtime.epochs:next(),
        entries={{
            assemblyId=third.assemblyId,commitmentId=commitmentId,capability="REGULATE_SPEED",
            effectClass="SPEED_LIMIT",authorityRole=AUTHORITY_ROLE
        }},
        relevantAssemblyIds={third.assemblyId}
    })

    local prepared={
        status="PREPARED",commitmentId=commitmentId,operationId=bridge.operationId,assemblyId=third.assemblyId,referenceKey=third.referenceKey,
        ownerTag=OWNER_TAG,governingPurpose=GOVERNING_PURPOSE,maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,
        authorityRole=AUTHORITY_ROLE,effectiveActuationCompositionId=applied.commitment.effectiveActuationCompositionId,
        supportingSpeedCeilingComposition=supportingComposition,
        physicalActive=false,pairAssemblyIds=bridge.assemblyIds
    }
    self.leasesByCommitmentId[commitmentId]=prepared
    logInfo("BUBBLE_BULLET_TIME_PREPARED","commitment=%s operation=%s assembly=%s ref=%s movementComposition=%s ceilingComposition=%s cap=%.2fkmh",tostring(commitmentId),tostring(bridge.operationId),tostring(third.assemblyId),tostring(third.referenceKey),tostring(prepared.effectiveActuationCompositionId),tostring(supportingComposition.identity),INTENT_REVELATION_CREEP_KMH)
    return prepared,nil
end

-- Called only after Responsibility Transition has exposed the Passage
-- Resolution as current, but before the two participant REPOSITION requests are
-- handed to Cooperative Passage Control.
function BulletTime:activatePrepared(commitmentId,requestContext,candidate)
    local lease=self.leasesByCommitmentId[commitmentId]
    if lease==nil then return nil,"BUBBLE_BULLET_TIME_PREPARATION_MISSING" end
    if lease.status=="NOT_REQUIRED" then return lease,nil end
    if lease.status=="ACTIVE" then return lease,nil end
    if lease.status~="PREPARED" then return nil,"BUBBLE_BULLET_TIME_PREPARED_STATE_INVALID:"..tostring(lease.status) end

    local commitment=self.runtime.commitments:get(commitmentId)
    local current=self.runtime.responsibilityTransitionAuthority and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
    if commitment==nil or commitment.state~="ACTIVE" or current==nil then return nil,"BUBBLE_BULLET_TIME_CURRENT_RESOLUTION_REQUIRED" end
    if requestContext==nil or requestContext.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId
        or lease.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId then
        return nil,"BUBBLE_BULLET_TIME_COMPOSITION_MISMATCH"
    end
    local grantTarget={kind="REGULATION_LEASE",vehicleReferenceKey=lease.referenceKey,ownerTag=OWNER_TAG,maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,governingPurpose=GOVERNING_PURPOSE}
    local grant,grantReason=self.runtime.boundedAuthority:authorize({
        responsibilityId=current.identity,commitmentId=commitmentId,assemblyId=lease.assemblyId,capability="REGULATE_SPEED",
        target=grantTarget,authorityRole=AUTHORITY_ROLE,
        operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
        effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
        supportingSpeedCeilingComposition=lease.supportingSpeedCeilingComposition,
        preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {},
        provenance={source="BubbleBulletTime",purpose=GOVERNING_PURPOSE,operationId=lease.operationId,thirdPartyAssemblyId=lease.assemblyId}
    })
    if grant==nil then return nil,"BUBBLE_BULLET_TIME_BOUNDED_AUTHORITY_FAILED:"..tostring(grantReason) end

    local request,requestReason=self.runtime.boundedAuthority:materializeRequest({
        boundedAuthorityId=grant.identity,
        target={kind="REGULATION_LEASE",operation="APPLY",vehicleReferenceKey=lease.referenceKey,ownerTag=OWNER_TAG,maxSpeedKmh=INTENT_REVELATION_CREEP_KMH,governingPurpose=GOVERNING_PURPOSE},
        operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
        preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {}
    })
    if request==nil then
        self.runtime.boundedAuthority:release(grant.identity,"BUBBLE_BULLET_TIME_REQUEST_FAILED")
        return nil,"BUBBLE_BULLET_TIME_REQUEST_FAILED:"..tostring(requestReason)
    end

    local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
    if started~=true then
        self.runtime.boundedAuthority:release(grant.identity,"BUBBLE_BULLET_TIME_CONTROL_REJECTED")
        return nil,"BUBBLE_BULLET_TIME_CONTROL_REJECTED:"..tostring(result)
    end
    if type(self.runtime.liveControlDispatcher.notifyAccepted)=="function" then
        self.runtime.liveControlDispatcher:notifyAccepted(request,{kind="BUBBLE_BULLET_TIME_APPLIED",capability="REGULATE_SPEED",maxSpeedKmh=INTENT_REVELATION_CREEP_KMH})
    end

    lease.status="ACTIVE"
    lease.boundedAuthorityId=grant.identity
    lease.controlRequestId=request.identity
    lease.physicalActive=true
    logInfo("BUBBLE_BULLET_TIME_APPLIED","commitment=%s operation=%s assembly=%s ref=%s request=%s cap=%.2fkmh",tostring(commitmentId),tostring(lease.operationId),tostring(lease.assemblyId),tostring(lease.referenceKey),tostring(request.identity),INTENT_REVELATION_CREEP_KMH)
    return lease,nil
end

function BulletTime:releaseForCommitment(commitmentId,reason)
    local lease=self.leasesByCommitmentId[commitmentId]
    if lease==nil then return false end
    self:_clearPhysical(lease,reason or "BUBBLE_BULLET_TIME_RELEASE")
    self.leasesByCommitmentId[commitmentId]=nil
    return true
end

-- Sealed live evidence owns membership-basis release. Semantic Resolution
-- termination is also checked here, while the event-listener update below
-- provides prompt mechanical cleanup independent of the 250 ms Observation cadence.
function BulletTime:releaseUnsupportedProtection(live)
    local picture=live and live.picture or nil
    local outcomes={}
    for commitmentId,lease in OuttaMyWay.ValueRecord.pairs(self.leasesByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then
            self:_clearPhysical(lease,"BUBBLE_RESOLUTION_EPOCH_ENDED")
            self.leasesByCommitmentId[commitmentId]=nil
            outcomes[#outcomes+1]={commitmentId=commitmentId,status="RELEASED",reason="BUBBLE_RESOLUTION_EPOCH_ENDED"}
        elseif lease.status=="ACTIVE" and picture~=nil and not operationContainsAssembly(picture,lease.operationId,lease.assemblyId) then
            -- The physical effect must end promptly when the formation-time third party
            -- leaves the Local Operation. Keep the supporting token/composition inert
            -- until the parent Resolution reaches terminality so the executing pair's
            -- already-authorised composition is not rewritten underneath Control.
            self:_clearPhysical(lease,"BUBBLE_THIRD_PARTY_LEFT_LOCAL_OPERATION")
            lease.status="QUIESCENT_BASIS_ENDED"
            outcomes[#outcomes+1]={commitmentId=commitmentId,status=lease.status,reason="BUBBLE_THIRD_PARTY_LEFT_LOCAL_OPERATION"}
        end
    end
    return outcomes
end

function BulletTime:releaseAll(reason)
    for commitmentId,lease in OuttaMyWay.ValueRecord.pairs(self.leasesByCommitmentId) do
        self:_clearPhysical(lease,reason or "BUBBLE_BULLET_TIME_RELEASE_ALL")
        self.leasesByCommitmentId[commitmentId]=nil
    end
end

-- GIANTS event callback. This does not create a timing policy: it merely
-- neutralises this module's mechanical lease once the semantic Passage
-- responsibility has already ended.
function BulletTime:update() self:_releaseEndedResolutionProtection() end
function BulletTime:loadMap() end
function BulletTime:deleteMap() self:releaseAll("MAP_DELETE") end
function BulletTime:keyEvent() end
function BulletTime:mouseEvent() end
function BulletTime:draw() end

function BulletTime:getLease(commitmentId)
    return self.leasesByCommitmentId[commitmentId]
end

function BulletTime:getOwnerTag() return OWNER_TAG end
function BulletTime:getSpeedKmh() return INTENT_REVELATION_CREEP_KMH end
