--- Owns the Cooperative Passage participant speed ceiling during GIANTS-native approach before Capture/Hold.
-- Specification Jurisdictions: `COOPERATIVE_PASSAGE`

OuttaMyWay.PassageApproachSpeedCeiling={}
local Ceiling=OuttaMyWay.PassageApproachSpeedCeiling
Ceiling.__index=Ceiling

local OWNER_TAG="PASSAGE_APPROACH_SPEED_CEILING"
local GOVERNING_PURPOSE="COOPERATIVE_PASSAGE_APPROACH"
local AUTHORITY_ROLE="SUPPORTING_SPEED_CEILING"
local APPROACH_SPEED_CEILING_KMH=10.0

local publication=OuttaMyWay.LogPublication.origin("BOUNDED_AUTHORITY")
local function logInfo(code,formatText,...) return publication:info("DEBUG",code,formatText,...) end

local function participants(candidate)
    local bridge=candidate and candidate.evidenceBasis and candidate.evidenceBasis.cooperativePassageBridge or nil
    if type(bridge)~="table" then return nil,"PASSAGE_APPROACH_CEILING_BRIDGE_UNAVAILABLE" end
    local subjectId,otherId=bridge.subjectAssemblyId,bridge.otherAssemblyId
    local subjectRef,otherRef=bridge.subjectReferenceKey,bridge.otherReferenceKey
    if type(subjectId)~="string" or type(otherId)~="string" or subjectId==otherId
        or type(subjectRef)~="string" or type(otherRef)~="string" then
        return nil,"PASSAGE_APPROACH_CEILING_PARTICIPANT_CONTEXT_INVALID"
    end
    return {
        {assemblyId=subjectId,referenceKey=subjectRef,physicalActive=false},
        {assemblyId=otherId,referenceKey=otherRef,physicalActive=false}
    },nil
end

function Ceiling.new(runtime) return setmetatable({runtime=runtime,leasesByCommitmentId={}},Ceiling) end

function Ceiling:_regulationControl()
    return self.runtime and self.runtime.liveControlDispatcher and self.runtime.liveControlDispatcher.regulationControl or nil
end

function Ceiling:_clearParticipant(participant,reason)
    if participant==nil then return false end
    local cleared=false
    if participant.physicalActive==true then
        local control=self:_regulationControl()
        if control~=nil and type(control.clearRegulationLeaseByReference)=="function" then
            cleared=control:clearRegulationLeaseByReference(participant.referenceKey,OWNER_TAG)==true
        end
    end
    if type(participant.boundedAuthorityId)=="string" and self.runtime.boundedAuthority~=nil then
        self.runtime.boundedAuthority:release(participant.boundedAuthorityId,reason)
    end
    participant.physicalActive=false
    participant.boundedAuthorityId=nil
    participant.controlRequestId=nil
    return cleared
end

function Ceiling:prepareAtBubbleFormation(candidate,applied)
    if type(applied)~="table" or applied.commitment==nil then return nil,"PASSAGE_APPROACH_CEILING_COMMITMENT_CONTEXT_REQUIRED" end
    local commitmentId=applied.commitment.identity
    if self.leasesByCommitmentId[commitmentId]~=nil then return self.leasesByCommitmentId[commitmentId],nil end
    local pair,pairReason=participants(candidate)
    if pair==nil then return nil,pairReason end
    local entries,relevant={},{}
    for _,participant in OuttaMyWay.ValueRecord.ipairs(pair) do
        entries[#entries+1]={assemblyId=participant.assemblyId,commitmentId=commitmentId,capability="REGULATE_SPEED",effectClass="SPEED_LIMIT",authorityRole=AUTHORITY_ROLE}
        relevant[#relevant+1]=participant.assemblyId
    end
    local composition=OuttaMyWay.EffectiveActuationComposition.create({
        identity=self.runtime.identities:issue("COMPOSITION"),epoch=self.runtime.epochs:next(),
        entries=entries,relevantAssemblyIds=relevant
    })
    local prepared={
        status="PREPARED",commitmentId=commitmentId,participants=pair,ownerTag=OWNER_TAG,
        governingPurpose=GOVERNING_PURPOSE,maxSpeedKmh=APPROACH_SPEED_CEILING_KMH,authorityRole=AUTHORITY_ROLE,
        effectiveActuationCompositionId=applied.commitment.effectiveActuationCompositionId,
        supportingSpeedCeilingComposition=composition
    }
    self.leasesByCommitmentId[commitmentId]=prepared
    logInfo("PASSAGE_APPROACH_SPEED_CEILING_PREPARED",
        "commitment=%s participants=%s,%s movementComposition=%s ceilingComposition=%s cap=%.2fkmh",
        tostring(commitmentId),tostring(pair[1].assemblyId),tostring(pair[2].assemblyId),
        tostring(prepared.effectiveActuationCompositionId),tostring(composition.identity),APPROACH_SPEED_CEILING_KMH)
    return prepared,nil
end

function Ceiling:activatePrepared(commitmentId,requestContext,candidate)
    local lease=self.leasesByCommitmentId[commitmentId]
    if lease==nil then return nil,"PASSAGE_APPROACH_CEILING_PREPARATION_MISSING" end
    if lease.status=="ACTIVE" then return lease,nil end
    if lease.status~="PREPARED" then return nil,"PASSAGE_APPROACH_CEILING_PREPARED_STATE_INVALID:"..tostring(lease.status) end
    local commitment=self.runtime.commitments:get(commitmentId)
    local current=self.runtime.responsibilityTransitionAuthority and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
    if commitment==nil or commitment.state~="ACTIVE" or current==nil then return nil,"PASSAGE_APPROACH_CEILING_CURRENT_RESOLUTION_REQUIRED" end
    if requestContext==nil or requestContext.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId
        or lease.effectiveActuationCompositionId~=commitment.effectiveActuationCompositionId then
        return nil,"PASSAGE_APPROACH_CEILING_COMPOSITION_MISMATCH"
    end
    for _,participant in OuttaMyWay.ValueRecord.ipairs(lease.participants) do
        local target={kind="REGULATION_LEASE",vehicleReferenceKey=participant.referenceKey,ownerTag=OWNER_TAG,maxSpeedKmh=APPROACH_SPEED_CEILING_KMH,governingPurpose=GOVERNING_PURPOSE}
        local grant,grantReason=self.runtime.boundedAuthority:authorize({
            responsibilityId=current.identity,commitmentId=commitmentId,assemblyId=participant.assemblyId,capability="REGULATE_SPEED",
            target=target,authorityRole=AUTHORITY_ROLE,operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
            effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
            supportingSpeedCeilingComposition=lease.supportingSpeedCeilingComposition,
            preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {},
            provenance={source="PassageApproachSpeedCeiling",purpose=GOVERNING_PURPOSE}
        })
        if grant==nil then
            self:releaseForCommitment(commitmentId,"PASSAGE_APPROACH_CEILING_BOUNDED_AUTHORITY_FAILED")
            return nil,"PASSAGE_APPROACH_CEILING_BOUNDED_AUTHORITY_FAILED:"..tostring(grantReason)
        end
        participant.boundedAuthorityId=grant.identity
        local request,requestReason=self.runtime.boundedAuthority:materializeRequest({
            boundedAuthorityId=grant.identity,
            target={kind="REGULATION_LEASE",operation="APPLY",vehicleReferenceKey=participant.referenceKey,ownerTag=OWNER_TAG,maxSpeedKmh=APPROACH_SPEED_CEILING_KMH,governingPurpose=GOVERNING_PURPOSE},
            operationalPictureEpoch=requestContext.operationalPictureEpoch,evidenceEpoch=requestContext.evidenceEpoch,
            preconditions=requestContext.preconditions or {},invalidationConditions=requestContext.invalidationConditions or {}
        })
        if request==nil then
            self:releaseForCommitment(commitmentId,"PASSAGE_APPROACH_CEILING_REQUEST_FAILED")
            return nil,"PASSAGE_APPROACH_CEILING_REQUEST_FAILED:"..tostring(requestReason)
        end
        local started,result=self.runtime.liveControlDispatcher:dispatch(request,candidate)
        if started~=true then
            self:releaseForCommitment(commitmentId,"PASSAGE_APPROACH_CEILING_CONTROL_REJECTED")
            return nil,"PASSAGE_APPROACH_CEILING_CONTROL_REJECTED:"..tostring(result)
        end
        if type(self.runtime.liveControlDispatcher.notifyAccepted)=="function" then
            self.runtime.liveControlDispatcher:notifyAccepted(request,{kind="PASSAGE_APPROACH_SPEED_CEILING_APPLIED",capability="REGULATE_SPEED",maxSpeedKmh=APPROACH_SPEED_CEILING_KMH})
        end
        participant.controlRequestId=request.identity
        participant.physicalActive=true
    end
    lease.status="ACTIVE"
    logInfo("PASSAGE_APPROACH_SPEED_CEILING_APPLIED","commitment=%s participants=%s,%s cap=%.2fkmh nativeRoutingPreserved=true",
        tostring(commitmentId),tostring(lease.participants[1].assemblyId),tostring(lease.participants[2].assemblyId),APPROACH_SPEED_CEILING_KMH)
    return lease,nil
end

function Ceiling:releaseForCommitment(commitmentId,reason)
    local lease=self.leasesByCommitmentId[commitmentId]
    if lease==nil then return false end
    local cleared=0
    for _,participant in OuttaMyWay.ValueRecord.ipairs(lease.participants or {}) do
        if self:_clearParticipant(participant,reason or "PASSAGE_APPROACH_SPEED_CEILING_RELEASE") then cleared=cleared+1 end
    end
    self.leasesByCommitmentId[commitmentId]=nil
    logInfo("PASSAGE_APPROACH_SPEED_CEILING_RELEASED","commitment=%s cleared=%d reason=%s",tostring(commitmentId),cleared,tostring(reason))
    return true
end

function Ceiling:_releaseEndedResolutionCeilings()
    local ended={}
    for commitmentId,_ in OuttaMyWay.ValueRecord.pairs(self.leasesByCommitmentId) do
        local commitment=self.runtime.commitments:get(commitmentId)
        local current=self.runtime.responsibilityTransitionAuthority and self.runtime.responsibilityTransitionAuthority:getCurrentResolutionCommitment(commitmentId) or nil
        if commitment==nil or OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) or current==nil then ended[#ended+1]=commitmentId end
    end
    for _,commitmentId in OuttaMyWay.ValueRecord.ipairs(ended) do self:releaseForCommitment(commitmentId,"PASSAGE_RESOLUTION_EPOCH_ENDED") end
end

function Ceiling:releaseAll(reason)
    local ids={}
    for commitmentId,_ in OuttaMyWay.ValueRecord.pairs(self.leasesByCommitmentId) do ids[#ids+1]=commitmentId end
    for _,commitmentId in OuttaMyWay.ValueRecord.ipairs(ids) do self:releaseForCommitment(commitmentId,reason or "PASSAGE_APPROACH_SPEED_CEILING_RELEASE_ALL") end
end

function Ceiling:update() self:_releaseEndedResolutionCeilings() end
function Ceiling:loadMap() end
function Ceiling:deleteMap() self:releaseAll("MAP_DELETE") end
function Ceiling:keyEvent() end
function Ceiling:mouseEvent() end
function Ceiling:draw() end
function Ceiling:getLease(commitmentId) return self.leasesByCommitmentId[commitmentId] end
function Ceiling:getOwnerTag() return OWNER_TAG end
function Ceiling:getSpeedKmh() return APPROACH_SPEED_CEILING_KMH end
