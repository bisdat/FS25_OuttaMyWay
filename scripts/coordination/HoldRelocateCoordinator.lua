-- Coordinates the accepted Hold & Relocate responsibility; does not acquire pair authority or command GIANTS directly.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- The independent commitment authority and physical Control interface are deliberately separate.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.HoldRelocateCoordinator={}
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
Coordinator.__index=Coordinator

local EGRESS_REGULATION_MS=5000 -- timed 1 km/h egress window
local PAIR_TRANSIT_WAIT_MS=15000 -- preparation limit, NEVER recovery deadline
local STATIC_EGRESS_FAILSAFE_MS=25000 -- cancel static movement after 25 seconds
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
    local ok,value,reason=pcall(port[verb],port,...)
    if not ok then return nil,"STATUS_EXCEPTION:"..verb end
    return value,reason
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
        active=nil,lastOutcome=nil,lastEgressRegulationResults=nil,
        lastInitialMotionEvidence=nil,lastStaticMotionEvidence=nil,
        lastPairMotionStartEvidence=nil,lastPairTransitExhaustion=nil
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
        relocatingAssemblyReferenceKey=state.relocator
            and state.relocator.assemblyReferenceKey or nil,
        regionRequiredProgressM=state.objective
            and state.objective.returnRegion.requiredProgressM or nil,
        pairTransitDeadlineMs=state.pairTransitDeadlineMs,
        egressRegulationUntilMs=state.egressRegulationUntilMs,
        staticEgressDeadlineMs=state.staticEgressDeadlineMs,
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
    if state.isStaticMovementOutstanding then
        local verb=state.isMapDeleting and "discardStaticMovementOnMapDelete"
            or "cancelStaticMovement"
        local ok,reason=command(control,verb,state.relocator.vehicle)
        if not ok then failures[#failures+1]="STATIC_MOVE:"..tostring(reason) end
        state.isStaticMovementOutstanding=false
    end
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
    if state.pairPreparationHolds then
        for i=1,#state.pairPreparationHolds do
            if state.pairPreparationHolds[i] then
                local party=state.commitment.participants[i]
                local ok,reason=command(control,"releaseHold",
                    party.vehicle,"TRANSIT_PREPARATION")
                if not ok then failures[#failures+1]="PREP_HOLD:"..tostring(reason) end
                state.pairPreparationHolds[i]=false
            end
        end
    end
    if state.pairTransitOutstanding then
        for i=1,#state.pairTransitOutstanding do
            if state.pairTransitOutstanding[i] then
                local p=state.commitment.participants[i]
                local ok,reason=command(control,"cancelTransit",p.vehicle)
                if not ok then failures[#failures+1]="PAIR_TRANSIT:"..tostring(reason) end
                state.pairTransitOutstanding[i]=false
            end
        end
    end
    if state.isTransitOutstanding then
        -- A static assembly is intentionally left in TRANSIT once the
        -- request was issued, even if GIANTS changes the beneficiary job
        -- before the lateral region is reached. Relinquish the request
        -- record only; do NOT send the cached working-pose inverses.
        -- A preflight-only plan (no request yet) still needs cancellation.
        -- Paired and solo recoveries retain their existing restore path.
        local verb=state.isStatic and state.staticTransitRequested
            and "retainStaticTransit" or "cancelTransit"
        local ok,reason=command(control,verb,state.relocator.vehicle)
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
    -- Native vehicle entities may already be gone when BaseMission deletes
    -- this runtime. Never call GIANTS driveToPoint on a deleted static root.
    self.active.isMapDeleting=reason=="MAP_DELETE"
    self:finishWithOutcome("RELINQUISHED",reason or "EXTERNAL_RELINQUISH")
    local released=self.lastOutcome.status=="RELINQUISHED"
    return released,released and nil or self.lastOutcome.reason
end

-- Inferred static subjects move under the same exclusive commitment and
-- physical TRANSIT boundary, but without inventing a job for the subject or
-- stopping and restarting the blocked beneficiary's GIANTS FIELDWORK.
function Coordinator:beginStatic(commitment,nowMs)
    if self.active~=nil or not finite(nowMs) or type(commitment)~="table"
        or type(commitment.participants)~="table"
        or #commitment.participants~=1
        or not positioned(commitment.participants[1])
        or not positioned(commitment.relocator)
        or type(commitment.nearbyBlockers)~="table"
        or #commitment.nearbyBlockers~=0 then
        return false,"STATIC_COMMITMENT_INVALID"
    end
    local objective,why=OuttaMyWay.ProjectedEgressRegion.planStatic(
        commitment,commitment.relocator)
    if objective==nil then return false,why end
    local accepted,reason=command(self.commitmentAuthority,
        "validateCommitment",commitment)
    if not accepted then return false,reason end
    local state={
        commitment=commitment,commitmentId=commitment.commitmentId,
        relocator=commitment.relocator,
        blockers={commitment.participants[1]},isBlockerRegulated={},
        isReverseOutstanding=false,isStaticMovementOutstanding=false,
        isTransitOutstanding=false,isRelocatorHeld=false,
        isStatic=true,staticTransitRequested=false,
        phase="STATIC_REQUESTING_TRANSIT",objective=objective,
        egressRegulationUntilMs=nowMs+EGRESS_REGULATION_MS,
        staticEgressDeadlineMs=nowMs+STATIC_EGRESS_FAILSAFE_MS
    }
    local ready,preflightReason=command(self.physicalControl,"preflight",state)
    if not ready then return false,preflightReason end
    if not finite(state.egressRegulationUntilMs)
        or not finite(state.staticEgressDeadlineMs) then
        return false,"STATIC_EGRESS_CLOCK_UNAVAILABLE"
    end
    self.active=state
    self.lastEgressRegulationResults=nil
    self.lastInitialMotionEvidence=nil
    self.lastStaticMotionEvidence=nil
    -- Preflight already cached the TRANSIT plan. Mark it for unconditional
    -- release even if the 1 km/h Regulation request fails before TRANSIT is
    -- sent; otherwise a later encounter sees TRANSIT_PLAN_ALREADY_ACTIVE.
    state.isTransitOutstanding=true
    -- Protect the blocked worker's native steering and drive permission,
    -- capping its current GIANTS speed at 1 km/h for a timed 5 s window.
    state.isBlockerRegulated[1]=true
    local regulated,regulationReason=command(self.physicalControl,
        "regulate",state.blockers[1].vehicle,"EGRESS")
    if not regulated then
        self:finishWithOutcome("CONTROL_INTERRUPTED",regulationReason)
        return false,regulationReason
    end
    -- The GIANTS request can apply some TRANSIT actions before returning a
    -- rejection. From first attempted dispatch, retain the TRANSIT posture
    -- even on interruption; motor, steering and speed Control still release.
    state.staticTransitRequested=true
    local transit,transitReason=command(self.physicalControl,
        "requestTransit",state.relocator.vehicle)
    if not transit then
        self:finishWithOutcome("CONTROL_INTERRUPTED",transitReason)
        return false,transitReason
    end
    state.isStaticMovementOutstanding=true
    local started,movement=command(self.physicalControl,
        "startStaticMovement",state.relocator.vehicle,objective)
    if not started then
        self:finishWithOutcome("CONTROL_INTERRUPTED",movement)
        return false,movement
    end
    state.phase="STATIC_MOVING"
    return true,{relocatingAssemblyReferenceKey=state.relocator.assemblyReferenceKey,
        objective=objective,directionSource=objective.directionSource,
        regionRequiredProgressM=objective.returnRegion.requiredProgressM,
        vectorDistanceM=objective.vectorDistanceM,
        beneficiaryWorkingWidthM=objective.beneficiaryWorkingWidthM,
        requestedDriveSpeedKmh=type(movement)=="table"
            and movement.requestedDriveSpeedKmh or nil}
end

-- The commitment authority must independently validate a live, issued
-- commitment. An input boolean supplied by a candidate is never authority.
-- Pair Commitment retains authority while both assemblies prepare for a
-- bounded TRANSIT wait. No single-mover geometry is selected before folding.
function Coordinator:beginPair(commitment,nowMs)
    if self.active~=nil or not finite(nowMs)
        or type(commitment)~="table" or commitment.commitmentId==nil
        or type(commitment.participants)~="table"
        or #commitment.participants~=2
        or type(commitment.fieldPolygon)~="table"
        or type(commitment.fieldCentroid)~="table"
        or type(commitment.nearbyBlockers)~="table" then
        return false,"PAIR_COMMITMENT_EVIDENCE_UNAVAILABLE"
    end
    local a,b=commitment.participants[1],commitment.participants[2]
    if not positioned(a) or not positioned(b) or a.vehicle==b.vehicle
        or a.assemblyReferenceKey==b.assemblyReferenceKey then
        return false,"PAIR_PARTICIPANTS_INVALID"
    end
    -- A third party cannot replace one genuinely evidenced pair member.
    local memberCaptured=false
    for i=1,#commitment.nearbyBlockers do
        local p=commitment.nearbyBlockers[i]
        if not positioned(p) then return false,"BLOCKER_MEMBERSHIP_INVALID" end
        if p==a or p==b then memberCaptured=true end
    end
    if not memberCaptured then return false,"PAIR_PARTNER_NOT_IN_BLOCKERS" end
    local admitted,reason=command(self.commitmentAuthority,
        "validateCommitment",commitment)
    if not admitted then return false,reason end
    local state={
        commitment=commitment,commitmentId=commitment.commitmentId,
        relocator=nil,blockers={},isBlockerRegulated={},
        isRelocatorHeld=false,isReverseOutstanding=false,
        isTransitOutstanding=false,pairPreparationHolds={false,false},
        pairTransitOutstanding={false,false},
        isSingle=false,phase="PAIR_PREPARING_TRANSIT",
        pairTransitDeadlineMs=nowMs+PAIR_TRANSIT_WAIT_MS,
        objective=nil,egressRegulationUntilMs=nil
    }
    local ready,why=command(self.physicalControl,"preflightPair",state)
    if not ready then return false,why end
    self.active=state
    -- Both cached plans now need release, including if a later preparation
    -- Hold or first TRANSIT request fails before the second is dispatched.
    state.pairTransitOutstanding={true,true}
    self.lastOutcome=nil
    self.lastEgressRegulationResults=nil
    self.lastPairMotionStartEvidence=nil
    self.lastPairTransitExhaustion=nil
    -- Keep native field-course/implement progression permitted while
    -- suppressing only translation. Request TRANSIT on both participants.
    for i=1,2 do
        local p=commitment.participants[i]
        state.pairPreparationHolds[i]=true
        local held,holdReason=command(self.physicalControl,
            "hold",p.vehicle,"TRANSIT_PREPARATION")
        if not held then
            self:finishWithOutcome("CONTROL_INTERRUPTED",holdReason)
            return false,holdReason
        end
    end
    for i=1,2 do
        local p=commitment.participants[i]
        state.pairTransitOutstanding[i]=true
        local requested,requestReason=command(self.physicalControl,
            "requestTransit",p.vehicle)
        if not requested then
            self:finishWithOutcome("CONTROL_INTERRUPTED",requestReason)
            return false,requestReason
        end
    end
    return true,{phase="PAIR_PREPARING_TRANSIT",
        pairTransitDeadlineMs=state.pairTransitDeadlineMs}
end

-- Region-first selection: use nominal selected-runtime TRANSIT geometry
-- after the shared maximum 15 s wait even if folding remains in progress.
-- Readiness only allows an earlier start; it is never a spatial veto.
function Coordinator:startPairEgress(state,nowMs,exhausted,statusA,statusB)
    local first,second=state.commitment.participants[1],
        state.commitment.participants[2]
    for _,party in ipairs({first,second}) do
        local footprint,why=query(self.physicalControl,
            "pairTransitFootprint",party.vehicle)
        if type(footprint)~="table" then
            self:finishWithOutcome("NO_FEASIBLE_PAIR_EGRESS",
                why or "PAIR_TRANSIT_ENVELOPE_UNAVAILABLE")
            return
        end
        party.transitFootprint=footprint
        party.x,party.z=footprint.rootX,footprint.rootZ
    end
    local preferred,alternative=selectRelocator(
        first,second,state.commitment.fieldCentroid)
    local objective,mover,other,reason=
        OuttaMyWay.ProjectedEgressRegion.planPairCascade(
            state.commitment,preferred,alternative)
    if objective==nil then
        self:finishWithOutcome("NO_FEASIBLE_PAIR_EGRESS",
            reason or "ALL_PAIR_EGRESS_OPTIONS_EXHAUSTED")
        return
    end
    state.relocator,state.objective=mover,objective
    local blockers,seen={other},{[other.assemblyReferenceKey]=true}
    for i=1,#state.commitment.nearbyBlockers do
        local p=state.commitment.nearbyBlockers[i]
        if p~=mover and not seen[p.assemblyReferenceKey] then
            seen[p.assemblyReferenceKey]=true
            blockers[#blockers+1]=p
        end
    end
    state.blockers=blockers
    -- Native-drive wrapper transition is one synchronous coordinator
    -- operation: remove both preparation Holds BEFORE installing the 1 km/h
    -- Regulation wrapper. Otherwise the Hold wrapper remains buried below
    -- Regulation and cannot be reacquired for the seven-second relocated Hold
    -- when a short Return Region is achieved before Regulation expires.
    -- No engine update is yielded between these changes; authority, leases
    -- and failure cleanup remain scoped to this same pair commitment.
    for i=1,2 do
        if state.pairPreparationHolds[i] then
            local party=state.commitment.participants[i]
            local released,why=command(self.physicalControl,
                "releaseHold",party.vehicle,"TRANSIT_PREPARATION")
            if not released then
                self:finishWithOutcome("CONTROL_INTERRUPTED",why)
                return
            end
            state.pairPreparationHolds[i]=false
        end
    end
    -- The five-second window begins with the actual egress operation,
    -- never during TRANSIT folding.
    state.egressRegulationUntilMs=nowMs+EGRESS_REGULATION_MS
    for i=1,#blockers do
        state.isBlockerRegulated[i]=true
        local regulated,why=command(self.physicalControl,
            "regulate",blockers[i].vehicle,"EGRESS")
        if not regulated then
            self:finishWithOutcome("CONTROL_INTERRUPTED",why)
            return
        end
    end
    state.isReverseOutstanding=true
    local started,evidence=command(self.physicalControl,
        "startReverse",mover.vehicle,objective)
    if not started then
        self:finishWithOutcome("CONTROL_INTERRUPTED",evidence)
        return
    end
    state.phase=objective.isReverse and "REVERSING" or "PAIR_FORWARD_MOVING"
    self.lastPairMotionStartEvidence={
        commitmentId=state.commitmentId,
        relocatingAssemblyReferenceKey=mover.assemblyReferenceKey,
        otherAssemblyReferenceKey=other.assemblyReferenceKey,
        directionSource=objective.directionSource,
        cascadeAttempts=objective.cascadeAttempts,
        regionTravelM=objective.regionTravelM,
        transitWaitExhausted=exhausted,
        firstFoldSettlement=statusA,
        secondFoldSettlement=statusB,
        geometryBasis=objective.transitGeometryBasis,
        firstFoldSettled=first.transitFootprint.foldSettled,
        secondFoldSettled=second.transitFootprint.foldSettled,
        isPhysicalPairClearanceConfirmed=false,
        requestedDriveSpeedKmh=type(evidence)=="table"
            and (evidence.requestedDriveSpeedKmh
                or evidence.requestedReverseSpeedKmh) or nil}
end

function Coordinator:begin(commitment,nowMs)
    if commitment~=nil and commitment.kind~="STATIC_BLOCKER"
        and commitment.kind~="SINGLE" then
        return self:beginPair(commitment,nowMs)
    end
    if commitment~=nil and commitment.kind=="STATIC_BLOCKER" then
        return self:beginStatic(commitment,nowMs)
    end
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
                or (not (finite(commitment.blockerWorkingWidthM)
                    and commitment.blockerWorkingWidthM>0)
                    and not (commitment.pairWidthsCaptured
                        and ((finite(commitment.participants[1]
                            and commitment.participants[1].workingWidthM)
                            and commitment.participants[1].workingWidthM>0)
                            or (finite(commitment.participants[2]
                            and commitment.participants[2].workingWidthM)
                            and commitment.participants[2].workingWidthM>0))))
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
    local objective,geometryReason
    if single then
        objective,geometryReason=OuttaMyWay.ProjectedEgressRegion.planSingle(
            commitment,relocator)
    else
        -- No motion while exploring options. Assess both mover assignments
        -- and three ordered route classes before any physical Control.
        objective,relocator,other,geometryReason=
            OuttaMyWay.ProjectedEgressRegion.planPairCascade(
                commitment,relocator,other)
    end
    if objective==nil then return false,geometryReason end
    -- The opposite worker always gets Regulation. Preserve any additional
    -- independently captured blockers, even when the cascade swaps mover:
    -- only the actual mover is excluded from the protected parties.
    local blockers,seen={},{}
    -- Even if the selected mover is swapped, a pair commitment must have
    -- independently captured one actual pair partner as blocked-space
    -- membership. An arbitrary third party cannot substitute for it.
    local pairMemberWasCaptured=single
    for i=1,#commitment.nearbyBlockers do
        local p=commitment.nearbyBlockers[i]
        if p==first or p==second then
            pairMemberWasCaptured=true
        end
    end
    if not pairMemberWasCaptured then
        return false,"PAIR_PARTNER_NOT_IN_BLOCKERS"
    end
    if not single then
        if not positioned(other)
            or (other~=first and other~=second)
            or other==relocator then
            return false,"PAIR_PARTNER_NOT_IN_BLOCKERS"
        end
        blockers[1]=other
        seen[other.assemblyReferenceKey]=true
    end
    for i=1,#commitment.nearbyBlockers do
        local party=commitment.nearbyBlockers[i]
        if not positioned(party) then
            return false,"BLOCKER_MEMBERSHIP_INVALID"
        end
        if party.assemblyReferenceKey==relocator.assemblyReferenceKey then
            if party.vehicle~=relocator.vehicle then
                return false,"BLOCKER_MEMBERSHIP_INVALID"
            end
        elseif not seen[party.assemblyReferenceKey] then
            seen[party.assemblyReferenceKey]=true
            blockers[#blockers+1]=party
        elseif party~=other then
            return false,"BLOCKER_MEMBERSHIP_INVALID"
        end
    end
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
    state.phase=objective.isReverse and "REVERSING" or "PAIR_FORWARD_MOVING"
    return true,{relocatingAssemblyReferenceKey=relocator.assemblyReferenceKey,
        objective=objective,
        directionSource=objective.directionSource,
        cascadeMode=objective.cascadeMode,
        cascadeAttempts=objective.cascadeAttempts,
        regionRequiredProgressM=objective.returnRegion.requiredProgressM,
        blockerWorkingWidthM=objective.blockerWorkingWidthM,
        marginM=objective.marginM,
        vectorDistanceM=objective.vectorDistanceM,
        egressSide=objective.egressSide,
        nominalBearingOffsetDeg=objective.nominalBearingOffsetDeg,
        targetInField=objective.targetInField,
        fieldInteriorScore=objective.fieldInteriorScore,
        fieldIdentitySource=objective.fieldIdentitySource,
        requestedReverseSpeedKmh=type(reverseEvidence)=="table"
            and reverseEvidence.requestedReverseSpeedKmh or nil,
        requestedDriveSpeedKmh=type(reverseEvidence)=="table"
            and reverseEvidence.requestedDriveSpeedKmh or nil}
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
    -- GIANTS takes over the relocated worker's new fieldwork job.
    -- The other still-active participant receives its cached configuration
    -- inverse, not a synthetic fieldwork restart.
    if state.pairTransitOutstanding then
        for i=1,2 do
            local party=state.commitment.participants[i]
            if party.vehicle==state.relocator.vehicle then
                state.pairTransitOutstanding[i]=false
            elseif state.pairTransitOutstanding[i] then
                local restored,why=command(self.physicalControl,
                    "cancelTransit",party.vehicle)
                if not restored then
                    self:finishWithOutcome("CONTROL_INTERRUPTED",why)
                    return
                end
                state.pairTransitOutstanding[i]=false
            end
        end
    end
    state.isTransitOutstanding=false
    self.lastOutcome={status="NATIVE_RESTART_ACCEPTED",
        commitmentId=state.commitmentId,isNativeContinuationConfirmed=false}
    self.active=nil
end

-- advance is a procedure step, not GIANTS' generic update callback. The
-- admission and safety witnesses stay with the independent authority.
function Coordinator:advance(nowMs,dt)
    local state=self.active
    if state==nil then return end
    if not finite(nowMs) then self:finishWithOutcome("CONTROL_INTERRUPTED","CLOCK_UNAVAILABLE");return end
    local isCurrent,reason=command(self.commitmentAuthority,"isCommitmentCurrent",state.commitment)
    if not isCurrent then self:finishWithOutcome("RELINQUISHED",reason);return end
    if state.phase=="PAIR_PREPARING_TRANSIT" then
        local a,b=state.commitment.participants[1],
            state.commitment.participants[2]
        local first=query(self.physicalControl,"transitStatus",a.vehicle)
        local second=query(self.physicalControl,"transitStatus",b.vehicle)
        local settled=type(first)=="table" and first.isSettled==true
            and type(second)=="table" and second.isSettled==true
        local exhausted=not settled
            and nowMs>=state.pairTransitDeadlineMs
        if not settled and not exhausted then return end
        if exhausted then
            -- The 15 s bound authorises attempting egress with nominal
            -- selected-runtime TRANSIT geometry, never cleanup on its own.
            self.lastPairTransitExhaustion={
                commitmentId=state.commitmentId,
                elapsedMs=PAIR_TRANSIT_WAIT_MS,
                first=first,second=second}
        end
        self:startPairEgress(state,nowMs,exhausted,first,second)
        return
    end
    -- Timer alone releases native speed Regulation for pair/static egress.
    if not state.isSingle and finite(state.egressRegulationUntilMs)
        and nowMs>=state.egressRegulationUntilMs then
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

    if state.isStatic then
        -- This deadline cancels only an unfinished static relocation. It is
        -- not a new eligibility gate, a repeat cooldown or a steering target.
        -- Existing cleanup stops the drive, releases Regulation, retains
        -- issued TRANSIT and frees authority for a later native encounter.
        if state.isStaticMovementOutstanding
            and nowMs>=state.staticEgressDeadlineMs then
            self:finishWithOutcome("CONTROL_INTERRUPTED",
                "STATIC_EGRESS_FAILSAFE_25S")
            return
        end
        if state.phase=="STATIC_WAIT_EGRESS_TIMER" then
            if nowMs<state.egressRegulationUntilMs then return end
            self.lastOutcome={status="STATIC_BLOCKER_MOVED",
                commitmentId=state.commitmentId,
                isNativeContinuationConfirmed=false,
                reason="INFERRED_SUBJECT_MOVED_GIANTS_CONTINUATION_UNMEASURED"}
            self.active=nil
            return
        end
        local status,statusReason=query(self.physicalControl,
            "staticMovementStatus",state.relocator.vehicle,dt)
        if type(status)~="table" then
            self:finishWithOutcome("CONTROL_INTERRUPTED",
                statusReason or "STATIC_MOVE_STATUS_UNAVAILABLE")
            return
        end
        if status.isFailed then
            self:finishWithOutcome("CONTROL_INTERRUPTED",
                status.reason or "STATIC_MOVE_FAILED")
            return
        end
        -- One actuation check at the existing five-second Regulation boundary.
        -- The movement mechanism already sampled all of these values; do
        -- not add vehicle polls, shape reads or repeated diagnostic output.
        if self.lastStaticMotionEvidence==nil
            and nowMs>=state.egressRegulationUntilMs then
            self.lastStaticMotionEvidence={
                commitmentId=state.commitmentId,
                subjectRootId=state.relocator.assemblyReferenceKey,
                commandedDriveCount=status.commandedDriveCount,
                physicalDisplacementM=status.physicalDisplacementM,
                motorStarted=status.motorStarted,
                progressM=status.progressM,
                requiredProgressM=state.objective.returnRegion.requiredProgressM,
                statusReason=status.reason
            }
        end
        if status.isComplete~=true then return end
        local stopped,stopReason=command(self.physicalControl,
            "stopStaticMovement",state.relocator.vehicle)
        if not stopped then
            self:finishWithOutcome("CONTROL_INTERRUPTED",stopReason)
            return
        end
        state.isStaticMovementOutstanding=false
        local retained,retainReason=command(self.physicalControl,
            "retainStaticTransit",state.relocator.vehicle)
        if not retained then
            self:finishWithOutcome("CONTROL_INTERRUPTED",retainReason)
            return
        end
        state.isTransitOutstanding=false
        -- If the region is reached early, wait out the promised 5 s native
        -- Regulation window, without continuing to move the static subject.
        state.phase="STATIC_WAIT_EGRESS_TIMER"
        if nowMs>=state.egressRegulationUntilMs then
            self.lastOutcome={status="STATIC_BLOCKER_MOVED",
                commitmentId=state.commitmentId,
                isNativeContinuationConfirmed=false,
                reason="INFERRED_SUBJECT_MOVED_GIANTS_CONTINUATION_UNMEASURED"}
            self.active=nil
        end
        return
    end

  -- Reverse is already armed in begin, without a TRANSIT settlement check.
    if state.phase=="REVERSING" or state.phase=="PAIR_FORWARD_MOVING" then
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
