-- Coordinates the accepted Hold & Relocate responsibility; does not acquire pair authority or command GIANTS directly.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- The independent commitment authority and physical Control interface are deliberately separate.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.HoldRelocateCoordinator={}
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
Coordinator.__index=Coordinator

local EGRESS_REGULATION_MS=5000 -- timed 1 km/h egress window
local RELOCATED_HOLD_MS=7000 -- timer-only continuation, independent of pair distance
local EGRESS_PATH_SAMPLE_M=2 -- validate straight segment within polygon
local MIN_CENTROID_BEARING_M=0.01
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
        active=nil,lastOutcome=nil,lastEgressRegulationResults=nil,lastInitialMotionEvidence=nil
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
        regionRequiredProgressM=state.objective.returnRegion.requiredProgressM,
        egressRegulationUntilMs=state.egressRegulationUntilMs,
        relocatedHoldUntilMs=state.relocatedHoldUntilMs,
        egressHoldResults=self.lastEgressRegulationResults
    }
end

-- Release the active physical commands best-effort at the end of this
-- collision. Capture failures only as this operation's outcome; do not keep
-- a historical job or commitment as a future admission veto.
function Coordinator:neutralize(state)
    local failures={}
    local control=self.physicalControl
    if state.isReverseOutstanding then
        local ok,reason=command(control,"cancelReverse",state.relocator.vehicle)
        if not ok then failures[#failures+1]="REVERSE:"..tostring(reason) end
        state.isReverseOutstanding=false
    end
    for i=1,#state.blockers do
        if state.isBlockerRegulated[i] then
            local ok,reason=command(control,"releaseRegulation",
                state.blockers[i].vehicle,"EGRESS")
            if not ok then failures[#failures+1]="REGULATION:"..tostring(reason) end
            state.isBlockerRegulated[i]=false
        end
    end
    if state.isRelocatorHeld then
        local ok,reason=command(control,"releaseHold",
            state.relocator.vehicle,"RELOCATED_WORKER")
        if not ok then failures[#failures+1]="HOLD:"..tostring(reason) end
        state.isRelocatorHeld=false
    end
    if state.isTransitOutstanding then
        local ok,reason=command(control,"cancelTransit",state.relocator.vehicle)
        if not ok then failures[#failures+1]="TRANSIT:"..tostring(reason) end
        state.isTransitOutstanding=false
    end
    return failures
end

function Coordinator:finishWithOutcome(outcome,reason)
    local state=self.active
    if state==nil then return end
    local failures=self:neutralize(state)
    local result=outcome
    if #failures>0 then
        result="CONTROL_INTERRUPTED"
        reason=tostring(reason or "CONTROL_RELEASE_FAILED")
            .." releaseFailures="..table.concat(failures,",")
    end
    self.lastOutcome={status=result,reason=reason,commitmentId=state.commitmentId,
        isNativeContinuationConfirmed=false}
    self.active=nil
end

function Coordinator:relinquish(reason)
    if self.active==nil then return false,"NO_ACTIVE_COMMITMENT" end
    self:finishWithOutcome("RELINQUISHED",reason or "EXTERNAL_RELINQUISH")
    local released=self.lastOutcome.status=="RELINQUISHED"
    return released,released and nil or self.lastOutcome.reason
end

-- The commitment authority must independently validate a live, issued
-- commitment. An input boolean supplied by a candidate is never authority.
function Coordinator:begin(commitment,nowMs)
    if self.active~=nil then return false,"COMMITMENT_ALREADY_ACTIVE" end
    if type(commitment)~="table" or commitment.commitmentId==nil or not finite(nowMs)
        or type(commitment.participants)~="table"
        or (commitment.kind=="SINGLE" and #commitment.participants~=1)
        or (commitment.kind~="SINGLE" and #commitment.participants~=2)
        or (commitment.kind=="SINGLE" and commitment.singleRegionDistanceM~=40)
        or (commitment.kind~="SINGLE"
            and (type(commitment.fieldCentroid)~="table"
                or not finite(commitment.fieldCentroid.x)
                or not finite(commitment.fieldCentroid.z)
                or not finite(commitment.offsetM) or commitment.offsetM<0
                or not finite(commitment.blockerWorkingWidthM)
                or commitment.blockerWorkingWidthM<=0
                or type(commitment.fieldPolygon)~="table"))
        or type(commitment.nearbyBlockers)~="table"
        or (commitment.kind~="SINGLE" and #commitment.nearbyBlockers==0) then
        return false,"COMMITMENT_EVIDENCE_UNAVAILABLE"
    end
    local single=commitment.kind=="SINGLE"
    local first,second=commitment.participants[1],commitment.participants[2]
    if not positioned(first) or (not single and
        (not positioned(second)
            or first.assemblyReferenceKey==second.assemblyReferenceKey
            or first.vehicle==second.vehicle)) then
        return false,"PARTICIPANTS_INVALID"
    end
    local relocator,other
    if single then
        if #commitment.nearbyBlockers~=0 then
            return false,"SINGLE_BLOCKER_MEMBERSHIP_INVALID"
        end
        relocator=first
    else
        relocator,other=selectRelocator(first,second,commitment.fieldCentroid)
    end
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
    if not single and not hasOther then return false,"PAIR_PARTNER_NOT_IN_BLOCKERS" end

    local objective,geometryReason
    if single then
        objective,geometryReason=OuttaMyWay.ProjectedEgressRegion.planSingle(
            commitment,relocator)
    else
        objective,geometryReason=OuttaMyWay.ProjectedEgressRegion.plan(
            commitment,relocator,other)
    end
    if objective==nil then return false,geometryReason end
    local state={
        commitmentId=commitment.commitmentId,commitment=commitment,
        relocator=relocator,blockers=blockers,isBlockerRegulated={},
        isRelocatorHeld=false,isReverseOutstanding=false,isTransitOutstanding=false,
        phase="REQUESTING_TRANSIT",
        egressRegulationUntilMs=single and nil or nowMs+EGRESS_REGULATION_MS,
        relocatedHoldUntilMs=nil,isSingle=single,objective=objective
    }
    if not single and not finite(state.egressRegulationUntilMs) then
        return false,"CLOCK_UNAVAILABLE"
    end
    local accepted,reason=command(self.commitmentAuthority,"validateCommitment",commitment)
    if not accepted then return false,reason end
    local isReady,preflightReason=command(self.physicalControl,"preflight",state)
    if not isReady then return false,preflightReason end
    self.active=state
    self.lastEgressRegulationResults=nil
    self.lastInitialMotionEvidence=nil

    -- Start 1 km/h regulation and Transit preparation together, not
    -- as serial waits. Mark possible effects before each external call.
    for i=1,#blockers do
        state.isBlockerRegulated[i]=true
        local regulated,regulationReason=command(self.physicalControl,
            "regulate",blockers[i].vehicle,"EGRESS")
        if not regulated then
            self:finishWithOutcome("CONTROL_INTERRUPTED",regulationReason)
            return false,regulationReason
        end
    end
    state.isTransitOutstanding=true
    local transitStarted,transitReason=command(self.physicalControl,"requestTransit",relocator.vehicle)
    if not transitStarted then
        self:finishWithOutcome("CONTROL_INTERRUPTED",transitReason)
        return false,transitReason
    end
    -- The TRANSIT request does not establish a configuration-readiness gate:
    -- start reverse in this same admitted operation while raise/fold continues.
    state.isReverseOutstanding=true
    local reversing,reverseEvidence=command(
        self.physicalControl,"startReverse",relocator.vehicle,state.objective)
    if not reversing then
        self:finishWithOutcome("CONTROL_INTERRUPTED",reverseEvidence)
        return false,reverseEvidence
    end
    state.phase="REVERSING"
    return true,{relocatingAssemblyReferenceKey=relocator.assemblyReferenceKey,
        objective=objective,
        directionSource=objective.directionSource,
        regionRequiredProgressM=objective.returnRegion.requiredProgressM,
        blockerWorkingWidthM=objective.blockerWorkingWidthM,
        marginM=objective.marginM,
        vectorDistanceM=objective.vectorDistanceM,
        egressSide=objective.egressSide,
        nominalBearingOffsetDeg=objective.nominalBearingOffsetDeg,
        targetInField=objective.targetInField,
        fieldInteriorScore=objective.fieldInteriorScore,
        requestedReverseSpeedKmh=type(reverseEvidence)=="table"
            and reverseEvidence.requestedReverseSpeedKmh or nil}
end

-- Complete the same native FIELDWORK handback for solo and paired recovery.
function Coordinator:completeNativeHandback(state)
    local restarted,evidence=command(self.physicalControl,
        "restartNativeFieldwork",state.relocator.vehicle)
    if not restarted then
        local cause=type(evidence)=="table" and evidence.reason or evidence
        self:finishWithOutcome("CONTROL_INTERRUPTED",cause)
        return
    end
    -- GIANTS owns the replacement job and TRANSIT configuration.
    state.isTransitOutstanding=false
    self.lastOutcome={status="NATIVE_RESTART_ACCEPTED",
        commitmentId=state.commitmentId,isNativeContinuationConfirmed=false}
    self.active=nil
end

-- advance is a procedure step, not GIANTS' generic update callback. The
-- admission and safety witnesses stay with the independent authority.
function Coordinator:advance(nowMs)
    local state=self.active
    if state==nil then return end
    if not finite(nowMs) then self:finishWithOutcome("CONTROL_INTERRUPTED","CLOCK_UNAVAILABLE");return end
    local isCurrent,reason=command(self.commitmentAuthority,"isCommitmentCurrent",state.commitment)
    if not isCurrent then self:finishWithOutcome("RELINQUISHED",reason);return end

    -- Timer alone releases the other participant's speed regulation.
    if not state.isSingle and nowMs>=state.egressRegulationUntilMs then
        for i=1,#state.blockers do
            if state.isBlockerRegulated[i] then
                local released,releaseEvidence=command(
                    self.physicalControl,"releaseRegulation",state.blockers[i].vehicle,"EGRESS")
                if not released then
                    self:finishWithOutcome("CONTROL_INTERRUPTED",releaseEvidence)
                    return
                end
                if self.lastEgressRegulationResults==nil then
                    self.lastEgressRegulationResults={}
                end
                self.lastEgressRegulationResults[#self.lastEgressRegulationResults+1]={
                    rootId=state.blockers[i].assemblyReferenceKey,
                    interceptCount=type(releaseEvidence)=="table"
                        and releaseEvidence.interceptionCount or nil,
                    displacementM=type(releaseEvidence)=="table"
                        and releaseEvidence.physicalDisplacementM or nil,
                    commitmentId=state.commitmentId,regulatedSpeedKmh=1,
                    lastNativeSpeedKmh=type(releaseEvidence)=="table"
                        and releaseEvidence.lastNativeSpeedKmh or nil}
                state.isBlockerRegulated[i]=false
            end
        end
    end
  -- Reverse is already armed in begin, without a TRANSIT settlement check.
    if state.phase=="REVERSING" then
        local status,statusReason=query(self.physicalControl,"reverseStatus",
            state.relocator.vehicle,state.objective)
        if type(status)~="table" then
            self:finishWithOutcome("CONTROL_INTERRUPTED",statusReason or "REVERSE_STATUS_UNAVAILABLE")
            return
        end
        if self.lastInitialMotionEvidence==nil
            and finite(status.initialMotionDeviationDeg) then
            self.lastInitialMotionEvidence={
                commitmentId=state.commitmentId,
                relativeToTargetDeg=status.initialMotionDeviationDeg,
                relativeToNativeReverseDeg=status.initialMotionRelativeToReverseDeg}
        end
        if status.isFailed==true then
            self:finishWithOutcome("CONTROL_INTERRUPTED",status.reason or "REVERSE_FAILED")
            return
        end
        if status.isComplete~=true then return end
        local stopped,stopReason=command(self.physicalControl,"stopReverse",state.relocator.vehicle)
        if not stopped then self:finishWithOutcome("CONTROL_INTERRUPTED",stopReason);return end
        state.isReverseOutstanding=false
        if state.isSingle then
            -- Solo: region reached -> GIANTS STOP/START immediately.
            -- No additional Hold state, Hold timer, or other-worker Regulation.
            self:completeNativeHandback(state)
            return
        end
        state.isRelocatorHeld=true
        local held,holdReason=command(self.physicalControl,"hold",state.relocator.vehicle,"RELOCATED_WORKER")
        if not held then self:finishWithOutcome("CONTROL_INTERRUPTED",holdReason);return end
        state.relocatedHoldUntilMs=nowMs+RELOCATED_HOLD_MS
        if not finite(state.relocatedHoldUntilMs) then
            self:finishWithOutcome("CONTROL_INTERRUPTED","CLOCK_UNAVAILABLE");return
        end
        state.phase="HOLD_RELOCATED"
        return
    end
    if state.phase=="HOLD_RELOCATED" and nowMs>=state.relocatedHoldUntilMs then
        local released,releaseReason=command(self.physicalControl,
            "releaseHold",state.relocator.vehicle,"RELOCATED_WORKER")
        if not released then self:finishWithOutcome("CONTROL_INTERRUPTED",releaseReason);return end
        state.isRelocatorHeld=false
        self:completeNativeHandback(state)
    end
end
