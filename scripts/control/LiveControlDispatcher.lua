-- FS25_OuttaMyWay v0.1.0.0 CANONICAL CANDIDATE — D-0147 Continuation Renewal dispatcher; behaviour inherited unchanged from canonical v4.7.128.
--
-- This module is the only automatic bridge from a sealed live Decision /
-- Commitment application into physical Control. D-0146 Step-2 adds an active
-- Candidate-supplied Passage Guide path while retaining the mechanically proven
-- D-0143 donor and existing D-0141/D-0123 Regulation paths. The dispatcher does
-- not invent traffic meaning or passage geometry.

OuttaMyWay.LiveControlDispatcher = {}
local Dispatcher = OuttaMyWay.LiveControlDispatcher
Dispatcher.__index = Dispatcher

local physical = {REGULATE_SPEED=true,HOLD=true,REPOSITION=true}
local D0147_PROTECTED_YIELD_OWNER_TAG="D0147_PROTECTED_YIELD"

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
local function cooperativePassageBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.cooperativePassageBridge or nil
    if type(bridge)~="table" then return nil end
    if bridge.architecture=="D0146_STEP2" then
        if type(bridge.subjectReferenceKey)=="string" and type(bridge.otherReferenceKey)=="string" and type(bridge.passageGuide)=="table" then return bridge end
        return nil
    end
    if type(bridge.condorReferenceKey)=="string" and type(bridge.patriotReferenceKey)=="string" then return bridge end
    return nil
end

local function terminalEgressBridge(candidate)
    local evidence=candidate and candidate.evidenceBasis or nil
    local bridge=evidence and evidence.terminalEgressBridge or nil
    if type(bridge)=="table" and bridge.architecture=="D0147" and type(bridge.terminalEpisodeId)=="string" then return bridge end
    return nil
end

local function ownershipAssemblyIds(candidate)
    local ownership=candidate and candidate.evidenceBasis and candidate.evidenceBasis.progressActuationOwnership or nil
    local ids={}
    for _,id in OuttaMyWay.ValueRecord.ipairs(ownership and ownership.assemblyIds or {}) do ids[#ids+1]=id end
    table.sort(ids)
    return ids
end

function Dispatcher.new(runtime)
    return setmetatable({
        runtime=runtime,capability=nil,cooperativePassageControl=nil,terminalEgressControl=nil,requests={},outcomes={},dispatchCount=0,
        d0147ProtectedYieldLeases={},
        guardedRecoveryLease=nil,guardedRecoveryApplyCount=0,guardedRecoveryReleaseCount=0,
        followerBoundaryLease=nil,followerBoundaryApplyCount=0,followerBoundaryReleaseCount=0,followerBoundaryUpdateCount=0,
        d0146ActionSpaceLease=nil,d0146ActionSpaceApplyCount=0,d0146ActionSpaceReleaseCount=0
    },Dispatcher)
end
function Dispatcher:setCapability(capability) self.capability=capability end
function Dispatcher:setCooperativePassageControl(control)
    self.cooperativePassageControl=control
    if control~=nil and type(control.setCompletionHandler)=="function" then
        control:setCompletionHandler(function(result) self:_onCooperativePassageCompletion(result) end)
    end
end
function Dispatcher:setTerminalEgressControl(control)
    self.terminalEgressControl=control
    if control~=nil and type(control.setCompletionHandler)=="function" then control:setCompletionHandler(function(result) self:_onTerminalEgressCompletion(result) end) end
end
function Dispatcher:getTerminalEgressObservation()
    if self.terminalEgressControl~=nil and type(self.terminalEgressControl.getControlExecutionObservation)=="function" then return self.terminalEgressControl:getControlExecutionObservation() end
    return nil
end
function Dispatcher:getCapabilityObservation()
    if self.capability~=nil and type(self.capability.getControlExecutionObservation)=="function" then return self.capability:getControlExecutionObservation() end
    return nil
end
function Dispatcher:_outcome(request,status,effect,failure)
    local values={identity=self.runtime.identities:issue("CONTROL_OUTCOME"),requestId=request.identity,status=status,observedPhysicalEffect=effect or {},progress={},provenance={source="LiveControlDispatcher"},timestamp=(tonumber(g_time) or 0)/1000}
    if failure~=nil then values.failureEvidence=failure end
    local outcome=OuttaMyWay.ControlOutcome.new(values); self.outcomes[#self.outcomes+1]=outcome; return outcome
end

function Dispatcher:_jointCooperativeRequests(picture,evaluated,candidate,commitment,bridge)
    local ids=ownershipAssemblyIds(candidate)
    if #ids~=2 then return nil,"COOPERATIVE_PASSAGE_REQUIRES_EXACTLY_TWO_PROGRESS_ACTUATION_ASSEMBLIES" end
    local requests={}
    for _,assemblyId in ipairs(ids) do
        local token=nil
        for _,candidateToken in OuttaMyWay.ValueRecord.ipairs(self.runtime.authorities:tokensForCommitment(commitment.identity)) do
            if candidateToken.assemblyId==assemblyId then token=candidateToken break end
        end
        if token==nil or self.runtime.authorities:validate(token)~=true then return nil,"VALID_JOINT_COMMITMENT_AUTHORITY_TOKEN_UNAVAILABLE" end
        local target
        if bridge.architecture=="D0146_STEP2" then
            target={kind="D0146_COOPERATIVE_PASSAGE",conflictIdentity=bridge.conflictIdentity,encounterIdentity=bridge.encounterIdentity,governingRequirementKey=bridge.governingRequirementKey,
                subjectReferenceKey=bridge.subjectReferenceKey,otherReferenceKey=bridge.otherReferenceKey,passageGuideId=bridge.passageGuide and bridge.passageGuide.identity,controlProfile=bridge.controlProfile}
        else
            target={kind="TS015_COOPERATIVE_PASSAGE",pairReferenceKey=bridge.pairReferenceKey,encounterIdentity=bridge.encounterIdentity,governingRequirementKey=bridge.governingRequirementKey,
                condorReferenceKey=bridge.condorReferenceKey,patriotReferenceKey=bridge.patriotReferenceKey,controlProfile=bridge.controlProfile}
        end
        local request=OuttaMyWay.ControlRequest.new({
            identity=self.runtime.identities:issue("CONTROL_REQUEST"),commitmentId=commitment.identity,assemblyId=assemblyId,capability="REPOSITION",
            target=target,
            authorityToken=token.identity,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
            preconditions=candidate.preconditions or {},invalidationConditions=candidate.invalidationConditions or {}
        })
        self.requests[#self.requests+1]=request; requests[#requests+1]=request
    end
    return requests,nil
end

local function d0147TokenFor(runtime,commitmentId,assemblyId,authorityClass)
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
        if token.assemblyId==assemblyId and token.authorityClass==authorityClass and runtime.authorities:validate(token)==true then return token end
    end
    return nil
end

function Dispatcher:_releaseD0147ProtectedYield(commitmentId,reason)
    local leases=self.d0147ProtectedYieldLeases[commitmentId]
    if type(leases)~="table" then return 0 end
    local released=0
    for _,lease in ipairs(leases) do
        if self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" and type(lease.referenceKey)=="string" then
            local ok=self.capability:clearRegulationLeaseByReference(lease.referenceKey,D0147_PROTECTED_YIELD_OWNER_TAG)
            if ok==true then released=released+1 end
        end
    end
    self.d0147ProtectedYieldLeases[commitmentId]=nil
    logInfo("D0147_PROTECTED_YIELD_RELEASE commitment=%s released=%d reason=%s",tostring(commitmentId),released,tostring(reason))
    return released
end

function Dispatcher:_applyD0147ProtectedYield(picture,evaluated,candidate,commitment,bridge)
    if bridge.phase~="INFIELD" then return true,"NOT_TRANSLATING" end
    -- protectedDemandAssemblies is nested architecture value data and may be a sealed
    -- ValueRecord proxy in GIANTS. Never use native #/pairs/ipairs here.
    local protected=bridge.protectedDemandAssemblies or {}
    if OuttaMyWay.ValueRecord.length(protected)==0 then return false,"D0147_PROTECTED_YIELD_AUTHORISING_DEMAND_UNAVAILABLE" end
    if self.capability==nil or type(self.capability.executeControlRequest)~="function" then return false,"D0147_PROTECTED_YIELD_CONTROL_CAPABILITY_UNAVAILABLE" end
    if self.d0147ProtectedYieldLeases[commitment.identity]~=nil then return true,"ALREADY_PROTECTED" end
    local leases={}
    for _,item in OuttaMyWay.ValueRecord.ipairs(protected) do
        if type(item.assemblyId)~="string" or type(item.referenceKey)~="string" then
            for _,lease in ipairs(leases) do if type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.referenceKey,D0147_PROTECTED_YIELD_OWNER_TAG) end end
            return false,"D0147_PROTECTED_YIELD_REFERENCE_UNAVAILABLE"
        end
        local token=d0147TokenFor(self.runtime,commitment.identity,item.assemblyId,"PROGRESS_ACTUATION")
        if token==nil then
            for _,lease in ipairs(leases) do if type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.referenceKey,D0147_PROTECTED_YIELD_OWNER_TAG) end end
            return false,"D0147_PROTECTED_YIELD_PROGRESS_AUTHORITY_UNAVAILABLE"
        end
        local regulationBridge={regulatedAssemblyId=item.assemblyId,regulatedReferenceKey=item.referenceKey,governingPurpose="D0147_PROTECTED_YIELD_INTERVAL"}
        local request=self:_regulationRequest(picture,evaluated,candidate,commitment,token,regulationBridge,"APPLY",D0147_PROTECTED_YIELD_OWNER_TAG,0.0)
        local started,result=self.capability:executeControlRequest(request,candidate)
        local outcome=self:_outcome(request,started and "ACCEPTED" or "REJECTED",{kind=started and "D0147_PROTECTED_YIELD_HOLD_APPLIED" or "NO_PHYSICAL_EFFECT_CONFIRMED",capability="REGULATE_SPEED",maxSpeedKmh=0.0},started and nil or {reason=tostring(result)})
        if started~=true then
            for _,lease in ipairs(leases) do if type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.referenceKey,D0147_PROTECTED_YIELD_OWNER_TAG) end end
            return false,"D0147_PROTECTED_YIELD_HOLD_REJECTED:"..tostring(result),outcome
        end
        leases[#leases+1]={assemblyId=item.assemblyId,referenceKey=item.referenceKey,requestId=request.identity,outcomeId=outcome.identity}
        logInfo("D0147_PROTECTED_YIELD_HOLD commitment=%s assembly=%s ref=%s request=%s cap=0.00kmh",tostring(commitment.identity),tostring(item.assemblyId),tostring(item.referenceKey),tostring(request.identity))
    end
    self.d0147ProtectedYieldLeases[commitment.identity]=leases
    return true,"PROTECTED_YIELD_HOLD_APPLIED"
end

function Dispatcher:_onTerminalEgressCompletion(result)
    if type(result)~="table" or type(result.commitmentId)~="string" then return end
    if result.status=="COMPACTION_COMPLETE" then
        logInfo("D0147_COMPACTION_COMPLETE commitment=%s episode=%s freshSituationRequired=true",tostring(result.commitmentId),tostring(result.terminalEpisodeId))
        return
    end
    local protectedDemandAssemblyIds={}
    for _,lease in ipairs(self.d0147ProtectedYieldLeases[result.commitmentId] or {}) do
        if type(lease.assemblyId)=="string" then protectedDemandAssemblyIds[#protectedDemandAssemblyIds+1]=lease.assemblyId end
    end
    table.sort(protectedDemandAssemblyIds)
    self:_releaseD0147ProtectedYield(result.commitmentId,"TERMINAL_CONTROL_"..tostring(result.status))
    if result.status=="MANOEUVRE_COMPLETE" then
        if self.runtime.terminalOccupancyAssessment~=nil then self.runtime.terminalOccupancyAssessment:markRetreatCompleted(result.terminalEpisodeId,protectedDemandAssemblyIds) end
        local terminal,reason=OuttaMyWay.TerminalEgressCommitmentLifecycle.settle(self.runtime,result.commitmentId,"OBJECTIVE_SATISFIED",result.evidence,result.terminalEpisodeId)
        if terminal==nil then
            logWarning("D0147_INFIELD_RETREAT_SETTLEMENT_FAILED commitment=%s episode=%s reason=%s",tostring(result.commitmentId),tostring(result.terminalEpisodeId),tostring(reason))
        else
            logInfo("D0147_INFIELD_RETREAT_COMPLETE commitment=%s episode=%s continuationRenewalRequired=true freshSituationRequired=true",tostring(result.commitmentId),tostring(result.terminalEpisodeId))
        end
        return
    end
    local eventKind=nil
    if result.status=="FAILED" then eventKind="OBJECTIVE_FAILED"
    elseif result.status=="PLAYER_CLAIM" then eventKind="PLAYER_CLAIM"
    elseif result.status=="SUPERSEDED" then eventKind="NEW_AUTHORITATIVE_INTENT" end
    if eventKind~=nil then
        local terminal,reason=OuttaMyWay.TerminalEgressCommitmentLifecycle.settle(self.runtime,result.commitmentId,eventKind,result.evidence,result.terminalEpisodeId)
        if terminal==nil then logWarning("D0147_COMPLETION_SETTLEMENT_FAILED commitment=%s event=%s reason=%s",tostring(result.commitmentId),tostring(eventKind),tostring(reason)) end
    end
end

function Dispatcher:_dispatchTerminalEgress(picture,evaluated,candidate)
    local bridge=terminalEgressBridge(candidate); if bridge==nil then return nil end
    local boundary=evaluated.candidateInventory and evaluated.candidateInventory.supportBoundary or nil
    if type(boundary)~="table" or boundary.mode~="D0147_BOUNDED_TERMINAL_EGRESS" then return {status="NO_DISPATCH",reason="D0147_SUPPORT_BOUNDARY_MISMATCH"} end
    if bridge.terminalEvent~=nil then
        local commitmentId=bridge.existingCommitmentId
        if type(commitmentId)~="string" then return {status="NO_DISPATCH",reason="D0147_SETTLEMENT_WITHOUT_LIVE_COMMITMENT"} end
        self:_releaseD0147ProtectedYield(commitmentId,"SITUATION_SETTLEMENT_"..tostring(bridge.terminalEvent))
        local terminal,reason=OuttaMyWay.TerminalEgressCommitmentLifecycle.settle(self.runtime,commitmentId,bridge.terminalEvent,{kind="D0147_SITUATION_SETTLEMENT",terminalEpisodeId=bridge.terminalEpisodeId,playerEscalationRequired=bridge.terminalEvent=="OBJECTIVE_FAILED"},bridge.terminalEpisodeId)
        return {status=terminal and "SETTLED" or "NO_DISPATCH",reason=reason,terminalEgress=true,terminalEvent=bridge.terminalEvent,commitment=terminal}
    end
    if candidate.capability~="REPOSITION" then return {status="NO_DISPATCH",reason="D0147_NON_REPOSITION_PHYSICAL_CANDIDATE",terminalEgress=true} end
    if self.terminalEgressControl==nil then return {status="NO_DISPATCH",reason="D0147_CONTROL_UNAVAILABLE",terminalEgress=true} end
    if type(self.terminalEgressControl.isActive)=="function" and self.terminalEgressControl:isActive() then return {status="NO_DISPATCH",reason="D0147_CONTROL_ALREADY_ACTIVE",terminalEgress=true} end
    local applied,reason=OuttaMyWay.TerminalEgressCommitmentLifecycle.applyDecision(self.runtime,picture,evaluated)
    if applied==nil then return {status="NO_DISPATCH",reason="D0147_COMMITMENT_APPLICATION_FAILED",detail=reason,terminalEgress=true} end
    if bridge.phase=="INFIELD" then
        local protected,protectedReason=self:_applyD0147ProtectedYield(picture,evaluated,candidate,applied.commitment,bridge)
        if protected~=true then
            self:_releaseD0147ProtectedYield(applied.commitment.identity,"PROTECTED_YIELD_START_FAILED")
            local terminal,settleReason=OuttaMyWay.TerminalEgressCommitmentLifecycle.settle(self.runtime,applied.commitment.identity,"OBJECTIVE_FAILED",{kind="D0147_PROTECTED_YIELD_START_FAILED",reason=protectedReason},bridge.terminalEpisodeId)
            logWarning("D0147_PROTECTED_YIELD_REJECTED commitment=%s episode=%s reason=%s settlement=%s",tostring(applied.commitment.identity),tostring(bridge.terminalEpisodeId),tostring(protectedReason),tostring(settleReason))
            return {status="REJECTED",reason=protectedReason,terminalEgress=true,commitment=terminal or applied.commitment}
        end
    end
    local request=OuttaMyWay.ControlRequest.new({identity=self.runtime.identities:issue("CONTROL_REQUEST"),commitmentId=applied.commitment.identity,assemblyId=bridge.assemblyId,capability="REPOSITION",target={kind="D0147_BOUNDED_TERMINAL_EGRESS",phase=bridge.phase,terminalEpisodeId=bridge.terminalEpisodeId,objective=bridge.objective},authorityToken=applied.authorityToken.identity,operationalPictureEpoch=picture.epoch,evidenceEpoch=evaluated.decision.epoch,effectiveActuationCompositionId=applied.commitment.effectiveActuationCompositionId,preconditions=candidate.preconditions or {},invalidationConditions=candidate.invalidationConditions or {}})
    self.requests[#self.requests+1]=request
    local started,result=self.terminalEgressControl:executeControlRequest(request,candidate)
    local outcome=self:_outcome(request,started and "ACCEPTED" or "REJECTED",{kind=started and "D0147_POST_JOB_CONTROL_ACCEPTED" or "NO_PHYSICAL_EFFECT_CONFIRMED",phase=bridge.phase,postJobActuation=true},started and nil or {reason=tostring(result)})
    if started then self.dispatchCount=self.dispatchCount+1; logInfo("D0147_ACCEPTED commitment=%s episode=%s assembly=%s phase=%s request=%s result=%s",tostring(applied.commitment.identity),tostring(bridge.terminalEpisodeId),tostring(bridge.assemblyReferenceKey),tostring(bridge.phase),tostring(request.identity),tostring(result))
    else logWarning("D0147_REJECTED commitment=%s episode=%s phase=%s reason=%s",tostring(applied.commitment.identity),tostring(bridge.terminalEpisodeId),tostring(bridge.phase),tostring(result)) end
    return {status=started and "ACCEPTED" or "REJECTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,result=result,terminalEgress=true}
end

function Dispatcher:_onCooperativePassageCompletion(result)
    if type(result)~="table" or type(result.commitmentId)~="string" then return end
    if result.status=="SUCCEEDED" then
        local settled,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.completeCooperativePassage(self.runtime,result.commitmentId,result.evidence)
        if settled==nil then
            logWarning("COOPERATIVE_COMPLETION_UNRESOLVED commitment=%s reason=%s",tostring(result.commitmentId),tostring(reason))
        else
            logInfo("COOPERATIVE_COMPLETION commitment=%s terminal=%s authorityReleased=true cooldown=false",tostring(result.commitmentId),tostring(settled.commitment and settled.commitment.state or "n/a"))
        end
    elseif result.status=="FAILED" then
        local record=self.runtime.commitments:get(result.commitmentId)
        if record~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(record.state) then
            for _,obligation in OuttaMyWay.ValueRecord.ipairs(self.runtime.obligations:openForOwner(result.commitmentId)) do
                local outcome=obligation.requiredOutcome
                if type(outcome)=="table" and outcome.kind=="COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK" then
                    self.runtime.obligations:settle(obligation.identity,"BASIS_CESSATION",result.evidence or {kind="COOPERATIVE_PASSAGE_FAILED"})
                end
            end
            local verdict=self.runtime.governingBasisEvaluator:evaluate(record,{kind="OBJECTIVE_FAILED",evidence=result.evidence or {},provenance={source="LiveControlDispatcher"}})
            local settling=self.runtime.terminalSettlementEvaluator:enterSettling(result.commitmentId,verdict)
            if not self.runtime.obligations:hasOpenObligations(result.commitmentId) then
                self.runtime.terminalSettlementEvaluator:attemptTerminal(result.commitmentId,result.evidence or {kind="COOPERATIVE_PASSAGE_FAILED"})
            end
            logWarning("COOPERATIVE_ABORT_SETTLEMENT commitment=%s releasedAuthority=%d",tostring(result.commitmentId),#(settling.releasedAuthorityTokenIds or {}))
        end
    end
end

local D0123_OWNER_TAG="D0123_GUARDED_RECOVERY"
local D0141_OWNER_TAG="D0141_FOLLOWER_BOUNDARY"
local D0146_ACTION_SPACE_OWNER_TAG="D0146_ACTION_SPACE_CONSERVATION"

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

-- Resolution-Space Conservation is an obligation lifetime, not the lifetime of
-- the Current Excursion witness that first justified Regulation.  Control consumes
-- only Situation-owned positive relationship invalidation; it does not reinterpret
-- trajectory/current-motion evidence at this authority boundary.
local function d0146ActionSpaceRelationshipState(picture,lease,relation)
    if relation==nil then
        local subjectPresent=pictureContainsAssembly(picture,lease.excursionAssemblyId)
        local regulatedPresent=pictureContainsAssembly(picture,lease.regulatedAssemblyId)
        if subjectPresent and regulatedPresent then
            return "PERSIST","D0146_RELATIONSHIP_TEMPORARILY_UNRESOLVED_ACTION_SPACE_OBLIGATION_RETAINED"
        end
        return "DISSOLVED","D0146_RELATIONSHIP_PARTICIPANT_NO_LONGER_ACTIVE"
    end
    local relationship=relation.resolutionSpaceRelationship
    if type(relationship)=="table" and relationship.positiveDissolution==true then
        return "DISSOLVED",relationship.reason or "D0146_POSITIVE_RELATIONSHIP_DISSOLUTION"
    end
    if relation.classification=="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT" then
        return "PERSIST","D0146_ESTABLISHED_CONFLICT_AWAITS_SUPPORTED_PASSAGE_WITH_ACTION_SPACE_REGULATION_RETAINED"
    end
    if relation.classification=="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT" then
        return "PERSIST","D0146_POTENTIAL_CONFLICT_RESOLUTION_SPACE_OBLIGATION_PERSISTS"
    end
    if type(relationship)=="table" and type(relationship.reason)=="string" then
        return "PERSIST",relationship.reason
    end
    return "PERSIST","D0146_RELATIONSHIP_DISSOLUTION_NOT_POSITIVELY_ESTABLISHED"
end


function Dispatcher:_regulationRequest(picture,evaluated,candidate,commitment,token,bridge,operation,ownerTag,maxSpeedKmh)
    ownerTag=ownerTag or D0123_OWNER_TAG
    local speed=maxSpeedKmh
    if operation=="APPLY" and speed==nil then speed=OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_KMH or OuttaMyWay.PROTOTYPE_22_REGULATE_DEFAULT_KMH or 1.0 end
    local assemblyId=bridge.progressAssemblyId or bridge.followerAssemblyId or bridge.regulatedAssemblyId
    local referenceKey=bridge.progressReferenceKey or bridge.followerReferenceKey or bridge.regulatedReferenceKey
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
    if excluding~="D0146_ACTION_SPACE" then
        local lease=self.d0146ActionSpaceLease
        if lease~=nil and lease.commitmentId==commitmentId and lease.regulatedAssemblyId==assemblyId then return true end
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

function Dispatcher:_releaseD0146ActionSpaceLease(picture,evaluated,reason)
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
        },"RELEASE",D0146_ACTION_SPACE_OWNER_TAG,nil)
        local ok,result=self.capability:executeControlRequest(request,nil)
        outcome=self:_outcome(request,ok and "ACCEPTED" or "REJECTED",{kind=ok and "REGULATION_LEASE_RELEASED" or "REGULATION_RELEASE_NOT_CONFIRMED",capability="REGULATE_SPEED"},ok and nil or {reason=tostring(result)})
        if ok~=true and type(self.capability.clearRegulationLeaseByReference)=="function" then self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG) end
    elseif self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG)
    end
    if commitment~=nil and not OuttaMyWay.CommitmentStateMachine.isTerminal(commitment.state) then
        local preserve=self:_otherRegulationPurposeOwnsAuthority(commitment.identity,lease.regulatedAssemblyId,"D0146_ACTION_SPACE")
        OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,commitment.identity,lease.regulatedAssemblyId,{reason=reason,preserveAuthority=preserve})
        OuttaMyWay.LiveTrafficCommitmentLifecycle.settleD0146ActionSpacePurpose(self.runtime,commitment.identity,{conflictIdentity=lease.conflictIdentity,reason=reason},{kind="D0146_ACTION_SPACE_POSITIVE_PURPOSE_EXPIRY",reason=reason,conflictIdentity=lease.conflictIdentity})
    end
    self.d0146ActionSpaceReleaseCount=self.d0146ActionSpaceReleaseCount+1
    self.d0146ActionSpaceLease=nil
    logInfo("D0146_ACTION_SPACE_RELEASE commitment=%s conflict=%s regulated=%s ref=%s reason=%s",tostring(lease.commitmentId),tostring(lease.conflictIdentity),tostring(lease.regulatedAssemblyId),tostring(lease.regulatedReferenceKey),tostring(reason))
    return {status="RELEASED",reason=reason,request=request,outcome=outcome,d0146ActionSpace=true}
end

function Dispatcher:_dispatchD0146ActionSpace(picture,evaluated,candidate)
    local bridge=d0146ActionSpaceBridge(candidate)
    local lease=self.d0146ActionSpaceLease
    if lease~=nil then
        local passage=cooperativePassageBridge(candidate)
        if passage~=nil and passage.architecture=="D0146_STEP2" and passage.conflictIdentity==lease.conflictIdentity then
            return nil -- same-Commitment succession is cleared only after Passage admission succeeds
        end
        local relation=d0146ActionSpaceRelation(picture,lease)
        local relationshipState,relationshipReason=d0146ActionSpaceRelationshipState(picture,lease,relation)
        if relationshipState=="PERSIST" then
            return {status="MAINTAINED",reason=relationshipReason,d0146ActionSpace=true,commitmentId=lease.commitmentId}
        end
        return self:_releaseD0146ActionSpaceLease(picture,evaluated,relationshipReason)
    end

    if bridge==nil or candidate.capability~="REGULATE_SPEED" then return nil end
    if self.capability==nil then return {status="NO_DISPATCH",reason="CONTROL_CAPABILITY_UNAVAILABLE",d0146ActionSpace=true} end
    local applied,applyReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyD0146ActionSpaceDecision(self.runtime,picture,evaluated)
    if applied==nil then return {status="NO_DISPATCH",reason=applyReason,d0146ActionSpace=true} end
    local token=applied.authorityToken
    if token==nil or self.runtime.authorities:validate(token)~=true then return {status="NO_DISPATCH",reason="D0146_ACTION_SPACE_VALID_AUTHORITY_TOKEN_UNAVAILABLE",d0146ActionSpace=true} end
    local request=self:_regulationRequest(picture,evaluated,candidate,applied.commitment,token,bridge,"APPLY",D0146_ACTION_SPACE_OWNER_TAG,bridge.requestedCapKmh)
    local started,result=self.capability:executeControlRequest(request,candidate)
    if started~=true then
        if applied.authorityAcquired then
            OuttaMyWay.LiveTrafficCommitmentLifecycle.releaseSupportingRegulationAuthority(self.runtime,applied.commitment.identity,bridge.regulatedAssemblyId,{reason="D0146_ACTION_SPACE_CONTROL_REQUEST_REJECTED:"..tostring(result),preserveAuthority=self:_otherRegulationPurposeOwnsAuthority(applied.commitment.identity,bridge.regulatedAssemblyId,"D0146_ACTION_SPACE")})
        end
        local outcome=self:_outcome(request,"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        return {status="REJECTED",reason=tostring(result),request=request,outcome=outcome,d0146ActionSpace=true}
    end
    self.d0146ActionSpaceLease={
        commitmentId=applied.commitment.identity,conflictIdentity=bridge.conflictIdentity,operationId=bridge.operationId,
        regulatedAssemblyId=bridge.regulatedAssemblyId,regulatedReferenceKey=bridge.regulatedReferenceKey,
        excursionAssemblyId=bridge.excursionAssemblyId,excursionReferenceKey=bridge.excursionReferenceKey,
        governingPurpose=bridge.governingPurpose,authorityTokenId=token.identity,requestId=request.identity,currentCapKmh=bridge.requestedCapKmh
    }
    self.d0146ActionSpaceApplyCount=self.d0146ActionSpaceApplyCount+1; self.dispatchCount=self.dispatchCount+1
    local outcome=self:_outcome(request,"ACCEPTED",{kind="D0146_PASSAGE_ACTION_SPACE_REGULATION_ADMITTED",capability="REGULATE_SPEED",maxSpeedKmh=bridge.requestedCapKmh},nil)
    logInfo("D0146_ACTION_SPACE_APPLY commitment=%s conflict=%s regulated=%s ref=%s excursion=%s request=%s cap=%.2fkmh native=%.2fkmh purpose=%s",
        tostring(applied.commitment.identity),tostring(bridge.conflictIdentity),tostring(bridge.regulatedAssemblyId),tostring(bridge.regulatedReferenceKey),tostring(bridge.excursionAssemblyId),tostring(request.identity),tonumber(bridge.requestedCapKmh) or 0,tonumber(bridge.nativeUnrestrictedKmh) or 0,tostring(bridge.governingPurpose))
    return {status="ACCEPTED",request=request,outcome=outcome,commitment=applied.commitment,candidate=candidate,result=result,d0146ActionSpace=true}
end

function Dispatcher:_supersedeD0146ActionSpaceForCooperativePassage(commitment,candidate)
    local lease=self.d0146ActionSpaceLease
    if lease==nil or commitment==nil or candidate==nil then return nil end
    local bridge=cooperativePassageBridge(candidate)
    if bridge==nil or bridge.architecture~="D0146_STEP2" or bridge.conflictIdentity~=lease.conflictIdentity or lease.commitmentId~=commitment.identity then return nil end
    if self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.regulatedReferenceKey,D0146_ACTION_SPACE_OWNER_TAG)
    end
    local settled,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleD0146ActionSpacePurpose(self.runtime,commitment.identity,{
        conflictIdentity=lease.conflictIdentity,reason="COOPERATIVE_PASSAGE_SUPERSEDES_D0146_ACTION_SPACE_REGULATION"
    },{kind="D0146_ESTABLISHED_CONFLICT_PASSAGE_SUCCESSION",conflictIdentity=lease.conflictIdentity,regulatedAssemblyId=lease.regulatedAssemblyId})
    if settled==nil then
        logWarning("D0146_ACTION_SPACE_PASSAGE_SUPERSESSION commitment=%s conflict=%s physicalLeaseCleared=true obligationSettlement=%s",tostring(commitment.identity),tostring(lease.conflictIdentity),tostring(reason))
    else
        logInfo("D0146_ACTION_SPACE_PASSAGE_SUPERSESSION commitment=%s conflict=%s physicalLeaseCleared=true obligation=%s authorityTokenReused=true",tostring(commitment.identity),tostring(lease.conflictIdentity),tostring(settled.settledObligationId or "NONE"))
    end
    self.d0146ActionSpaceReleaseCount=self.d0146ActionSpaceReleaseCount+1
    self.d0146ActionSpaceLease=nil
    return {settled=settled,reason=reason}
end

function Dispatcher:getD0146ActionSpaceStatus()
    local lease=self.d0146ActionSpaceLease
    return {active=lease~=nil,commitmentId=lease and lease.commitmentId or nil,conflictIdentity=lease and lease.conflictIdentity or nil,
        regulatedReferenceKey=lease and lease.regulatedReferenceKey or nil,excursionReferenceKey=lease and lease.excursionReferenceKey or nil,
        currentCapKmh=lease and lease.currentCapKmh or nil,applyCount=self.d0146ActionSpaceApplyCount,releaseCount=self.d0146ActionSpaceReleaseCount,ownerTag=D0146_ACTION_SPACE_OWNER_TAG}
end

-- Cooperative Passage may supersede a same-pair D-0141 follower strategy under
-- the existing Commitment. Once the Cooperative Passage REVISE Decision has been
-- applied, that D-0141 speed lease is no longer compatible with the worker's
-- new role.  Clear only the D-0141 physical lease and settle its follower
-- obligation; the generic same-Commitment AuthorityToken is deliberately kept
-- live and has already been rebound by applyHeadOnDecision to REPOSITION.
function Dispatcher:_supersedeFollowerBoundaryForCooperativePassage(commitment,candidate)
    local lease=self.followerBoundaryLease
    if lease==nil or commitment==nil or candidate==nil then return nil end
    local ids={}
    for _,id in ipairs(ownershipAssemblyIds(candidate)) do ids[id]=true end
    if lease.commitmentId~=commitment.identity or ids[lease.followerAssemblyId]~=true or ids[lease.leaderAssemblyId]~=true then return nil end

    if self.capability~=nil and type(self.capability.clearRegulationLeaseByReference)=="function" then
        self.capability:clearRegulationLeaseByReference(lease.followerReferenceKey,D0141_OWNER_TAG)
    end
    local settled,settleReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.settleFollowerBoundaryPurpose(self.runtime,commitment.identity,{
        pairKey=lease.pairKey,reason="COOPERATIVE_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION"
    },{kind="D0143_COOPERATIVE_PASSAGE_ROLE_SUCCESSION",pairKey=lease.pairKey,assemblyIds=ownershipAssemblyIds(candidate)})
    if settled==nil then
        logWarning("D0141_COOPERATIVE_SUPERSESSION commitment=%s pair=%s physicalLeaseCleared=true obligationSettlement=%s",
            tostring(commitment.identity),tostring(lease.pairKey),tostring(settleReason))
    else
        logInfo("D0141_COOPERATIVE_SUPERSESSION commitment=%s pair=%s physicalLeaseCleared=true obligation=%s",
            tostring(commitment.identity),tostring(lease.pairKey),tostring(settled.settledObligationId or "NONE"))
    end
    self.followerBoundaryReleaseCount=self.followerBoundaryReleaseCount+1
    self.followerBoundaryLease=nil
    return {settled=settled,reason=settleReason}
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
    local terminal=self:_dispatchTerminalEgress(picture,evaluated,candidate)
    if terminal~=nil then return terminal end
    local followerBridge=followerBoundaryBridge(candidate)
    if followerBridge~=nil and followerBridge.action=="RETIRE" then
        return self:_dispatchFollowerBoundary(picture,evaluated,candidate)
    end
    local guarded=self:_dispatchGuardedRecovery(picture,evaluated,candidate)
    if guarded~=nil then return guarded end
    local actionSpace=self:_dispatchD0146ActionSpace(picture,evaluated,candidate)
    if actionSpace~=nil then return actionSpace end
    local follower=self:_dispatchFollowerBoundary(picture,evaluated,candidate)
    if follower~=nil then return follower end
    if candidate==nil or physical[candidate.capability]~=true then return {status="NO_DISPATCH",reason="NO_SELECTED_PHYSICAL_CANDIDATE"} end
    local bridge=cooperativePassageBridge(candidate)
    if candidate.capability~="REPOSITION" or bridge==nil then return {status="NO_DISPATCH",reason="PHYSICAL_CANDIDATE_NOT_ALIGNED_FOR_LIVE_CONTROL",candidateId=candidate.identity} end
    if self.cooperativePassageControl==nil then return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_CONTROL_UNAVAILABLE",candidateId=candidate.identity} end
    local inventory=evaluated.candidateInventory
    local boundary=inventory and inventory.supportBoundary or nil
    local d0146=bridge.architecture=="D0146_STEP2"
    local expectedBoundary=d0146 and "D0146_COOPERATIVE_PASSAGE_STEP2_TEST" or "TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST"
    if type(boundary)~="table" or boundary.mode~=expectedBoundary then
        return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_SUPPORT_BOUNDARY_MISMATCH",candidateId=candidate.identity}
    end
    if type(self.cooperativePassageControl.isActive)=="function" and self.cooperativePassageControl:isActive() then
        return {status="NO_DISPATCH",reason="COOPERATIVE_PASSAGE_CONTROL_ALREADY_ACTIVE",candidateId=candidate.identity}
    end

    local applied,applyReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision(self.runtime,picture,evaluated)
    if applied==nil then
        logWarning("COOPERATIVE_REFUSED decision=%s candidate=%s reason=COMMITMENT_APPLICATION_FAILED detail=%s",tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(applyReason))
        return {status="NO_DISPATCH",reason="COMMITMENT_APPLICATION_FAILED",detail=applyReason,candidateId=candidate.identity}
    end
    local commitment=applied.commitment
    self:_supersedeFollowerBoundaryForCooperativePassage(commitment,candidate)
    self:_supersedeD0146ActionSpaceForCooperativePassage(commitment,candidate)

    local requests,requestReason=self:_jointCooperativeRequests(picture,evaluated,candidate,commitment,bridge)
    if requests==nil then
        self:_onCooperativePassageCompletion({status="FAILED",commitmentId=commitment.identity,evidence={kind=d0146 and "D0146_JOINT_CONTROL_REQUEST_CREATION_FAILED" or "D0143_JOINT_CONTROL_REQUEST_CREATION_FAILED",reason=requestReason}})
        return {status="NO_DISPATCH",reason=requestReason,candidateId=candidate.identity,commitmentId=commitment.identity}
    end
    local started,result=self.cooperativePassageControl:executeJointRequests(requests[1],requests[2],candidate)
    if started~=true then
        self:_onCooperativePassageCompletion({status="FAILED",commitmentId=commitment.identity,evidence={kind=d0146 and "D0146_COOPERATIVE_CONTROL_START_REJECTED" or "D0143_COOPERATIVE_CONTROL_START_REJECTED",reason=tostring(result)}})
        local outcomes={
            self:_outcome(requests[1],"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)}),
            self:_outcome(requests[2],"REJECTED",{kind="NO_PHYSICAL_EFFECT_OBSERVED"},{reason=tostring(result)})
        }
        logWarning("COOPERATIVE_REJECTED commitment=%s candidate=%s detail=%s",tostring(commitment.identity),tostring(candidate.identity),tostring(result))
        return {status="REJECTED",reason=tostring(result),requests=requests,outcomes=outcomes,commitment=commitment,candidate=candidate}
    end
    self.dispatchCount=self.dispatchCount+1
    local outcomes={
        self:_outcome(requests[1],"ACCEPTED",{kind=d0146 and "D0146_JOINT_REPOSITION_DISPATCH_ACCEPTED" or "D0143_JOINT_REPOSITION_DISPATCH_ACCEPTED",capability="REPOSITION"},nil),
        self:_outcome(requests[2],"ACCEPTED",{kind=d0146 and "D0146_JOINT_REPOSITION_DISPATCH_ACCEPTED" or "D0143_JOINT_REPOSITION_DISPATCH_ACCEPTED",capability="REPOSITION"},nil)
    }
    logInfo("COOPERATIVE_ACCEPTED architecture=%s decision=%s candidate=%s commitment=%s requestA=%s requestB=%s subject=%s other=%s result=%s",
        tostring(bridge.architecture or "D0143_TS015"),tostring(evaluated.decision.identity),tostring(candidate.identity),tostring(commitment.identity),tostring(requests[1].identity),tostring(requests[2].identity),
        tostring(bridge.subjectReferenceKey or bridge.condorReferenceKey),tostring(bridge.otherReferenceKey or bridge.patriotReferenceKey),tostring(result))
    return {status="ACCEPTED",requests=requests,outcomes=outcomes,commitment=commitment,candidate=candidate,result=result}

end
function Dispatcher:getDispatchCount() return self.dispatchCount end
function Dispatcher:getRequests() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.requests) do out[#out+1]=v end; return out end
function Dispatcher:getOutcomes() local out={}; for _,v in OuttaMyWay.ValueRecord.ipairs(self.outcomes) do out[#out+1]=v end; return out end
