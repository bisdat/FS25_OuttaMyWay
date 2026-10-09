-- Coordinates the accepted Hold & Relocate responsibility; does not acquire pair authority or command GIANTS directly.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- The independent commitment authority and physical Control interface are deliberately separate.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.HoldRelocateCoordinator={}
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
Coordinator.__index=Coordinator

local EGRESS_HOLD_MS=5000 -- accepted Hold & Relocate egress timer, not a clearance test
local RELOCATED_HOLD_MS=10000 -- accepted continuation window, independent of pair distance
local MAX_RELOCATION_BASE_M=30 -- movement bound; unrelated to Spatial Pair Inference radius
local BWR_STEERING_HORIZON_M=40 -- steering reference only, not authorised travel

local function finite(value)
    return type(value)=="number" and value==value
        and value~=math.huge and value~=-math.huge
end

local function positioned(participant)
    return type(participant)=="table" and participant.assemblyReferenceKey~=nil
        and participant.vehicle~=nil and finite(participant.x) and finite(participant.z)
end

local function command(port,verb,...)
    if type(port)~="table" or type(port[verb])~="function" then
        return false,"CONTROL_METHOD_UNAVAILABLE:"..verb
    end
    local ok,accepted,evidence=pcall(port[verb],port,...)
    if not ok then return false,"CONTROL_EXCEPTION:"..verb end
    if accepted~=true then return false,evidence or ("CONTROL_REJECTED:"..verb) end
    return true,evidence
end

local function query(port,verb,...)
    if type(port)~="table" or type(port[verb])~="function" then
        return nil,"STATUS_METHOD_UNAVAILABLE:"..verb
    end
    local ok,value=pcall(port[verb],port,...)
    if not ok then return nil,"STATUS_EXCEPTION:"..verb end
    return value
end

local function selectRelocator(first,second,centroid)
    local firstDX,firstDZ=first.x-centroid.x,first.z-centroid.z
    local secondDX,secondDZ=second.x-centroid.x,second.z-centroid.z
    local firstDistanceSquared=firstDX*firstDX+firstDZ*firstDZ
    local secondDistanceSquared=secondDX*secondDX+secondDZ*secondDZ
    if firstDistanceSquared<secondDistanceSquared
        or (firstDistanceSquared==secondDistanceSquared
            and tostring(first.assemblyReferenceKey)<tostring(second.assemblyReferenceKey)) then
        return first,second
    end
    return second,first
end

function Coordinator.new(commitmentAuthority,physicalControl)
    return setmetatable({
        commitmentAuthority=commitmentAuthority,physicalControl=physicalControl,
        active=nil,lastOutcome=nil
    },Coordinator)
end

function Coordinator:isActive()
    return self.active~=nil
end

function Coordinator:getStatus()
    local state=self.active
    if state==nil then return {isActive=false,lastOutcome=self.lastOutcome} end
    return {
        isActive=true,phase=state.phase,commitmentId=state.commitmentId,
        relocatingAssemblyReferenceKey=state.relocator.assemblyReferenceKey,
        maxTravelM=state.maxTravelM,egressHoldUntilMs=state.egressHoldUntilMs,
        relocatedHoldUntilMs=state.relocatedHoldUntilMs,
        unresolvedEffects=state.unresolvedEffects,isNativeJobStateUncertain=state.isNativeJobStateUncertain,
        lastOutcome=state.phase=="WAITING_FOR_PLAYER_INTERVENTION" and self.lastOutcome or nil
    }
end

-- Best-effort physical neutralisation must preserve any effect whose release could
-- not be verified. A failed API call can have partially changed GIANTS state.
function Coordinator:neutralize(state)
    local unresolved={}
    local control=self.physicalControl
    if state.isReverseOutstanding then
        local ok,reason=command(control,"cancelReverse",state.relocator.vehicle)
        if ok then state.isReverseOutstanding=false
        else unresolved[#unresolved+1]="REVERSE:"..tostring(reason) end
    end
    for i=1,#state.blockers do
        if state.isBlockerHeld[i] then
            local ok,reason=command(control,"releaseHold",state.blockers[i].vehicle,"EGRESS")
            if ok then state.isBlockerHeld[i]=false
            else unresolved[#unresolved+1]="BLOCKER_HOLD:"..tostring(reason) end
        end
    end
    if state.isRelocatorHeld then
        local ok,reason=command(control,"releaseHold",state.relocator.vehicle,"RELOCATED_WORKER")
        if ok then state.isRelocatorHeld=false
        else unresolved[#unresolved+1]="RELOCATED_HOLD:"..tostring(reason) end
    end
    if state.isTransitOutstanding then
        local ok,reason=command(control,"cancelTransit",state.relocator.vehicle)
        if ok then state.isTransitOutstanding=false
        else unresolved[#unresolved+1]="TRANSIT:"..tostring(reason) end
    end
    state.unresolvedEffects=unresolved
    return #unresolved==0
end

-- Cleanup failures are not represented as successful relinquishment. Preserve
-- the affected commitment for explicit retry or player intervention.
function Coordinator:finishWithOutcome(outcome,reason,isNativeJobStateUncertain)
    local state=self.active
    if state==nil then return end
    if isNativeJobStateUncertain then state.isNativeJobStateUncertain=true end
    local isNeutral=self:neutralize(state)
    if not isNeutral or state.isNativeJobStateUncertain then
        state.phase="WAITING_FOR_PLAYER_INTERVENTION"
        self.lastOutcome={status="UNRESOLVED",reason=reason,
            commitmentId=state.commitmentId,
            isNativeJobStateUncertain=state.isNativeJobStateUncertain,
            unresolvedEffects=state.unresolvedEffects}
        return
    end
    self.lastOutcome={status=outcome,reason=reason,commitmentId=state.commitmentId,
        isNativeJobStateUncertain=false,unresolvedEffects={}}
    self.active=nil
end

function Coordinator:relinquish(reason)
    if self.active==nil then return false,"NO_ACTIVE_COMMITMENT" end
    local state=self.active
    if state.phase=="WAITING_FOR_PLAYER_INTERVENTION" then
        self:finishWithOutcome("RELINQUISHED",reason or "RETRY_NEUTRALISATION")
    else
        self:finishWithOutcome("RELINQUISHED",reason or "EXTERNAL_RELINQUISH")
    end
    return self.active==nil,self.active and "RELEASE_UNCONFIRMED" or nil
end

-- The commitment authority must independently validate a live, issued
-- commitment. An input boolean supplied by a candidate is never authority.
function Coordinator:begin(commitment,nowMs)
    if self.active~=nil then return false,"COMMITMENT_ALREADY_ACTIVE" end
    if type(commitment)~="table" or commitment.commitmentId==nil or not finite(nowMs)
        or type(commitment.participants)~="table" or #commitment.participants~=2
        or type(commitment.fieldCentroid)~="table"
        or not finite(commitment.fieldCentroid.x) or not finite(commitment.fieldCentroid.z)
        or not finite(commitment.offsetM) or commitment.offsetM<0
        or type(commitment.nearbyBlockers)~="table" or #commitment.nearbyBlockers==0 then
        return false,"COMMITMENT_EVIDENCE_UNAVAILABLE"
    end
    local first,second=commitment.participants[1],commitment.participants[2]
    if not positioned(first) or not positioned(second)
        or first.assemblyReferenceKey==second.assemblyReferenceKey
        or first.vehicle==second.vehicle then
        return false,"PARTICIPANTS_INVALID"
    end
    local relocator,other=selectRelocator(first,second,commitment.fieldCentroid)
    local blockers,seen,hasOther={}, {}, false
    for i=1,#commitment.nearbyBlockers do
        local participant=commitment.nearbyBlockers[i]
        if not positioned(participant)
            or participant.assemblyReferenceKey==relocator.assemblyReferenceKey
            or seen[participant.assemblyReferenceKey] then
            return false,"BLOCKER_MEMBERSHIP_INVALID"
        end
        seen[participant.assemblyReferenceKey]=true
        blockers[#blockers+1]=participant
        if participant.assemblyReferenceKey==other.assemblyReferenceKey
            and participant.vehicle==other.vehicle then hasOther=true end
    end
    if not hasOther then return false,"PAIR_PARTNER_NOT_IN_BLOCKERS" end

    local dx=commitment.fieldCentroid.x-relocator.x
    local dz=commitment.fieldCentroid.z-relocator.z
    local distanceM=math.sqrt(dx*dx+dz*dz)
    local maxTravelM=MAX_RELOCATION_BASE_M+commitment.offsetM
    if not finite(distanceM) or distanceM<=0 or not finite(maxTravelM)
        or maxTravelM<=0 then return false,"REVERSE_OBJECTIVE_UNAVAILABLE" end
    local travelM=math.min(distanceM,maxTravelM)
    local objective={targetX=relocator.x+dx/distanceM*travelM,
        targetZ=relocator.z+dz/distanceM*travelM,
        maxTravelM=maxTravelM,steeringHorizonM=BWR_STEERING_HORIZON_M,
        isReverse=true}
    local state={
        commitmentId=commitment.commitmentId,commitment=commitment,
        relocator=relocator,blockers=blockers,isBlockerHeld={},
        isRelocatorHeld=false,isReverseOutstanding=false,isTransitOutstanding=false,
        isNativeJobStateUncertain=false,unresolvedEffects={},phase="REQUESTING_TRANSIT",
        egressHoldUntilMs=nowMs+EGRESS_HOLD_MS,relocatedHoldUntilMs=nil,
        maxTravelM=maxTravelM,objective=objective
    }
    if not finite(state.egressHoldUntilMs) then return false,"CLOCK_UNAVAILABLE" end
    local accepted,reason=command(self.commitmentAuthority,"validateCommitment",commitment)
    if not accepted then return false,reason end
    local isReady,preflightReason=command(self.physicalControl,"preflight",state)
    if not isReady then return false,preflightReason end
    self.active=state

    -- Start the 5 s egress protection and Transit preparation together, not
    -- as serial waits. Mark possible effects before each external call.
    for i=1,#blockers do
        state.isBlockerHeld[i]=true
        local held,holdReason=command(self.physicalControl,"hold",blockers[i].vehicle,"EGRESS")
        if not held then
            self:finishWithOutcome("FAILED_SAFE",holdReason)
            return false,holdReason
        end
    end
    state.isTransitOutstanding=true
    local transitStarted,transitReason=command(self.physicalControl,"requestTransit",relocator.vehicle)
    if not transitStarted then
        self:finishWithOutcome("FAILED_SAFE",transitReason)
        return false,transitReason
    end
    -- The TRANSIT request does not establish a configuration-readiness gate:
    -- start reverse in this same admitted operation while raise/fold continues.
    state.isReverseOutstanding=true
    local reversing,reverseReason=command(
        self.physicalControl,"startReverse",relocator.vehicle,state.objective)
    if not reversing then
        self:finishWithOutcome("FAILED_SAFE",reverseReason)
        return false,reverseReason
    end
    state.phase="REVERSING"
    return true,{relocatingAssemblyReferenceKey=relocator.assemblyReferenceKey,objective=objective}
end

-- advance is a procedure step, not GIANTS' generic update callback. The
-- admission and safety witnesses stay with the independent authority.
function Coordinator:advance(nowMs)
    local state=self.active
    if state==nil or state.phase=="WAITING_FOR_PLAYER_INTERVENTION" then return end
    if not finite(nowMs) then self:finishWithOutcome("FAILED_SAFE","CLOCK_UNAVAILABLE");return end
    local isCurrent,reason=command(self.commitmentAuthority,"isCommitmentCurrent",state.commitment)
    if not isCurrent then self:finishWithOutcome("RELINQUISHED",reason);return end

    -- Timer is the only ordinary blocker Hold release gate.
    if nowMs>=state.egressHoldUntilMs then
        for i=1,#state.blockers do
            if state.isBlockerHeld[i] then
                local released,releaseReason=command(
                    self.physicalControl,"releaseHold",state.blockers[i].vehicle,"EGRESS")
                if not released then
                    self:finishWithOutcome("FAILED_SAFE",releaseReason)
                    return
                end
                state.isBlockerHeld[i]=false
            end
        end
    end
  -- Reverse is already armed in begin, without a TRANSIT settlement check.
    if state.phase=="REVERSING" then
        local status,statusReason=query(self.physicalControl,"reverseStatus",
            state.relocator.vehicle,state.objective)
        if type(status)~="table" then
            self:finishWithOutcome("FAILED_SAFE",statusReason or "REVERSE_STATUS_UNAVAILABLE")
            return
        end
        if status.isFailed==true then
            self:finishWithOutcome("FAILED_SAFE",status.reason or "REVERSE_FAILED")
            return
        end
        if not finite(status.travelledM) or status.travelledM<0
            or status.travelledM>state.maxTravelM then
            self:finishWithOutcome("FAILED_SAFE","REVERSE_DISTANCE_EVIDENCE_INVALID")
            return
        end
        if status.isComplete~=true then return end
        local stopped,stopReason=command(self.physicalControl,"stopReverse",state.relocator.vehicle)
        if not stopped then self:finishWithOutcome("FAILED_SAFE",stopReason);return end
        state.isReverseOutstanding=false
        state.isRelocatorHeld=true
        local held,holdReason=command(self.physicalControl,"hold",state.relocator.vehicle,"RELOCATED_WORKER")
        if not held then self:finishWithOutcome("FAILED_SAFE",holdReason);return end
        state.relocatedHoldUntilMs=nowMs+RELOCATED_HOLD_MS
        if not finite(state.relocatedHoldUntilMs) then
            self:finishWithOutcome("FAILED_SAFE","CLOCK_UNAVAILABLE");return
        end
        state.phase="HOLD_RELOCATED"
        return
    end
    if state.phase=="HOLD_RELOCATED" and nowMs>=state.relocatedHoldUntilMs then
        local released,releaseReason=command(self.physicalControl,
            "releaseHold",state.relocator.vehicle,"RELOCATED_WORKER")
        if not released then self:finishWithOutcome("FAILED_SAFE",releaseReason);return end
        state.isRelocatorHeld=false
        -- One synchronous GIANTS stop -> start operation. Both native results
        -- must be positively reported; native productive continuation is NOT implied.
        local restarted,evidence=command(self.physicalControl,"restartNativeFieldwork",state.relocator.vehicle)
        if not restarted or type(evidence)~="table"
            or evidence.isOldJobStopped~=true or evidence.isNewJobStarted~=true then
            self:finishWithOutcome("UNRESOLVED",
                restarted and "NATIVE_HANDOFF_EVIDENCE_UNAVAILABLE" or evidence,true)
            return
        end
        -- GIANTS now controls the new native job and its configuration.
        state.isTransitOutstanding=false
        self.lastOutcome={
            status="NATIVE_RESTART_ACCEPTED",commitmentId=state.commitmentId,
            isNativeContinuationConfirmed=false
        }
        self.active=nil
    end
end
