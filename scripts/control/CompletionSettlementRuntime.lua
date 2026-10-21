-- Completion-triggered parking Control. Does not share a
-- native drive instance or intervention state with active Hold & Relocate.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSettlementRuntime={}
local Runtime=OuttaMyWay.CompletionSettlementRuntime
local Allocation=OuttaMyWay.ParkingRegionAllocation
local Situation=OuttaMyWay.SettlementDestinationAssessment
local Membership=OuttaMyWay.CompletionFieldMembership
local AssemblyOccupancy=OuttaMyWay.CompletionAssemblyFieldOccupancy
local MarginComparison=OuttaMyWay.ExteriorMarginComparison
Runtime.__index=Runtime
local publication=OuttaMyWay.LogPublication.origin("COMPLETION_SETTLEMENT")
local TOTAL_DEADLINE_MS=240000
local LEG_DEADLINE_MS=180000
-- TEST response hypothesis: a completed worker must not appear silently
-- stranded while an exhaustive nominal parking search holds no drive lease.
-- This clocks cumulative PENDING assessment, NOT physical Control time.
local PLANNING_RESPONSE_BUDGET_MS=20000
local ALLOCATION_PROGRESS_SAMPLE_MS=5000
local SAMPLE_MS=1000
-- Serial Control remains deliberate. Other completions queue for an
-- independent assessment and space allocation after the current lease.
local MAX_QUEUED_COMPLETIONS=2
-- Each update resumes the route search ONCE with a finite weighted geometry
-- budget. No native movement or fieldwork handback occurs during planning.
local PLAN_UNITS_PER_UPDATE=320
-- BWR's evidenced straight-reverse steering look-through; the terminal
-- guide still owns physical arrival, lease and movement safety.
local STRAIGHT_REVERSE_LOOKTHROUGH_M=40
-- Target-horizon braking model, not a fixed 8 km/h travel limit.
-- TEST assumption: 1.5 m/s^2 controllable deceleration, GIANTS to validate.
local GUIDANCE_DECEL_MPS2=1.5
local function guidanceSpeed(distance)
    return math.sqrt(2*GUIDANCE_DECEL_MPS2*
        math.max(2.5,math.min(distance,12)))*3.6
end
local function objectiveFor(route,index,currentX,currentZ)
    local leg=route.legs[index]
    local distance=math.sqrt((leg.point.x-currentX)^2+
        (leg.point.z-currentZ)^2)
    local beyond=0
    for i=index+1,#route.legs do
        local following=route.legs[i]
        local previous=route.legs[i-1]
        if following.moveForwards~=leg.moveForwards then break end
        beyond=beyond+math.sqrt(
            (following.point.x-previous.point.x)^2+
            (following.point.z-previous.point.z)^2)
    end
    local objective={moveForwards=leg.moveForwards,
        arrivalRadiusM=leg.arrivalRadiusM,
        maximumSpeedKmh=guidanceSpeed(distance),
        remainingAfterTargetM=beyond,
        targetX=leg.point.x,targetZ=leg.point.z,
        returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
    if not leg.moveForwards then
        -- The initial parking reverse is a straight retreat. Reference its
        -- complete reverse leg, not a short mutable guidance point. This is
        -- a look-through target, NEVER an extension to authorised travel.
        local last=leg.point
        for i=index+1,#route.legs do
            if route.legs[i].moveForwards then break end
            last=route.legs[i].point
        end
        local dx,dz=last.x-currentX,last.z-currentZ
        local length=math.sqrt(dx*dx+dz*dz)
        if length>0.001 then
            objective.steeringTargetX=last.x+
                dx/length*STRAIGHT_REVERSE_LOOKTHROUGH_M
            objective.steeringTargetZ=last.z+
                dz/length*STRAIGHT_REVERSE_LOOKTHROUGH_M
        end
    end
    return objective,distance
end
local function publish(publicationClass,level,code,fields)
    publication:publish(publicationClass,level,code,
        type(fields)=="function" and fields or function() return fields end)
end
-- Sort only at publication time, never during candidate assessment.
local function rejectionSummary(counts)
    local keys={}
    for key in pairs(counts or {}) do keys[#keys+1]=key end
    table.sort(keys)
    local parts={}
    local limit=math.min(#keys,40)
    for i=1,limit do
        local key=keys[i]
        parts[#parts+1]=key..":"..tostring(counts[key])
    end
    if #keys>limit then
        parts[#parts+1]="TRUNCATED_REASON_CATEGORIES:"..tostring(#keys-limit)
    end
    return table.concat(parts,";")
end
-- One read-only failure snapshot for a completed OR prematurely bounded
-- allocator. The in-flight site's checks have NOT yet been aggregated into
-- evidence.routeRejections, so publish them separately without claiming
-- exhaustive coverage or mutating the planner's live counters.
local function publishAllocationEvidence(state,reason,incomplete)
    if state.kind~="ALLOCATE" or type(state.plan)~="table"
        or type(state.plan.evidence)~="table" then return end
    local p=state.plan
    local e=p.evidence
    local working=p.phase=="QUALIFY" or p.phase=="CONNECT"
    local localPlan=p.phase=="QUALIFY" and p.localPlan or nil
    local approach=p.phase=="CONNECT" and p.approachPlan or nil
    publish("DIAGNOSTIC","INFO",
        "COMPLETION_SETTLEMENT_ALLOCATION_REJECTIONS",function()
        return {
            rootNode=tostring(state.vehicle.rootNode),
            fieldId=state.sourceField and state.sourceField.fieldId
                or "unknown",
            occupancy=p.disposition or "unknown",
            reason=reason or "NO_QUALIFIED_TERMINAL_REGION",
            incompleteSearch=incomplete==true,
            planningElapsedMs=state.planningElapsedMs or 0,
            sitesTotal=e.sitesTotal or 0,
            sitesExamined=e.sitesExamined or 0,
            sitesCompleted=math.max(0,(p.siteIndex or 0)
                -(working and 1 or 0)),
            currentPhase=p.phase or "unknown",
            currentSiteIndex=working and (p.siteIndex or 0) or "none",
            currentSiteEdge=working and p.site
                and p.site.edgeIndex or "none",
            currentSiteStation=working and p.site
                and p.site.station or "none",
            localPlans=e.localPlans or 0,
            localFeasible=e.localFeasible or 0,
            localCandidates=e.localCandidates or 0,
            approachPlans=e.approachPlans or 0,
            approachConnected=e.approachConnected or 0,
            initialReason=e.initialReason or "unknown",
            initialCandidates=e.initialCandidates or 0,
            initialRejections=rejectionSummary(e.initialRejections),
            siteRejections=rejectionSummary(e.siteRejections),
            routeRejections=rejectionSummary(e.routeRejections),
            inFlightLocalCandidates=localPlan
                and localPlan.candidates or 0,
            inFlightLocalPhase=localPlan and localPlan.phase or "none",
            inFlightLocalRejections=rejectionSummary(
                localPlan and localPlan.rejectionCounts),
            inFlightApproachExpansions=approach
                and approach.expansions or 0,
            actualPoseConnection=p.disposition=="STRADDLING"
                and "DIRECT_LOCAL" or "EXTENDED_FORWARD_ONLY",
            planningUpdates=p.advances or 0,
            weightedGeometryChecks=p.spent or 0
        }
        end)
end
local function rootPose(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if ok and type(x)=="number" and type(z)=="number"
        and x==x and z==z then return x,z end
    return nil
end
local function playerClaim(vehicle)
    if type(vehicle)~="table" then return "VEHICLE_UNAVAILABLE" end
    if type(vehicle.getIsControlled)=="function" then
        local ok,controlled=pcall(vehicle.getIsControlled,vehicle)
        if ok and controlled==true then return "NATIVE_PLAYER_CONTROL_ACTIVE" end
    end
    local selected=g_currentMission and g_currentMission.controlledVehicle
    if selected==vehicle then return "MISSION_PLAYER_CONTROL_ACTIVE" end
    if type(selected)=="table" and type(selected.getRootVehicle)=="function" then
        local ok,root=pcall(selected.getRootVehicle,selected)
        if ok and root==vehicle then
            return "MISSION_ROOT_PLAYER_CONTROL_ACTIVE"
        end
    end
    return nil
end

local function superseded(vehicle)
    if type(vehicle)~="table" or vehicle.isDeleted==true then return true end
    if type(vehicle.getCurrentAIJob)=="function" then
        local ok,job=pcall(vehicle.getCurrentAIJob,vehicle)
        if not ok or job~=nil then return true end
    end
    if type(vehicle.getIsAIActive)=="function" then
        local ok,active=pcall(vehicle.getIsAIActive,vehicle)
        if not ok or active~=false then return true end
    end
    return false
end
local function pairedControlActive()
    local runtime=OuttaMyWay.liveHoldRelocateRuntime
    return runtime~=nil and runtime.coordinator~=nil
        and type(runtime.coordinator.isActive)=="function"
        and runtime.coordinator:isActive()
end
function Runtime.new(configuration)
    return setmetatable({configuration=configuration,
        drive=OuttaMyWay.NativeStaticAssemblyDriveMechanism.new(),
        active=nil,pending=nil,waiting={},claims={},replans=setmetatable({},{__mode="k"}),
        attempted=setmetatable({},{__mode="k"}),
        repositioned=setmetatable({},{__mode="k"}),
        deferred=setmetatable({},{__mode="k"}),
        terminalCorrections=setmetatable({},{__mode="k"}),
        marginComparison=nil},Runtime)
end
function Runtime:isAdmitted()
    return g_server~=nil and self.configuration~=nil
        and self.configuration:isResolved()==true
        and self.configuration:isEnabled()==true
end
function Runtime:finish(code,reason)
    local state=self.active or self.pending
    if state==nil then return end
    self.active=nil
    self.pending=nil
    local releaseClaim=true
    if state.driveArmed then
        local stopped,why=self.drive:cancelMovement(state.vehicle)
        if not stopped then
            releaseClaim=false
            publish("NORMAL","WARNING","COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED",{
                rootNode=tostring(state.vehicle.rootNode),reason=tostring(why)})
        end
    end
    -- A potentially moving owner cannot silently release its destination
    -- to another claimant when its native steering lease is unconfirmed.
    if releaseClaim then
        Allocation.release(self.claims,state.vehicle)
    else
        publish("NORMAL","WARNING","COMPLETION_SETTLEMENT_CLAIM_RETAINED",{
            rootNode=tostring(state.vehicle.rootNode),
            reason="NATIVE_NEUTRALIZATION_UNCONFIRMED"})
    end
    publish("NORMAL",
        (code=="COMPLETION_SETTLEMENT_FINISHED"
            or code=="COMPLETION_SETTLEMENT_NOT_REQUIRED"
            or reason=="PLAYER_DISABLED" or reason=="CONTROL_REVOKED")
            and "INFO" or "WARNING",code,{rootNode=tostring(state.vehicle.rootNode),
            phase=state.phase,leg=state.legIndex,
            reason=tostring(reason)})
end
-- Diagnostic-only sampled control attribution: do not calculate expensive
-- vehicle pose/heading unless DIAGNOSTIC publication is actually eligible.
function Runtime:sampleMotion(state,status)
    if state.telemetryElapsedMs<SAMPLE_MS then return end
    state.telemetryElapsedMs=0
    if type(publication.isEligible)~="function"
        or not publication:isEligible("DIAGNOSTIC","INFO",
            "COMPLETION_SETTLEMENT_MOTION_SAMPLE") then return end
    local vehicle=state.vehicle
    local x,z=rootPose(vehicle)
    local fx,fz=nil,nil
    if type(localDirectionToWorld)=="function" and vehicle.rootNode~=nil then
        local ok,dx,_,dz=pcall(localDirectionToWorld,vehicle.rootNode,0,0,1)
        if ok and type(dx)=="number" and type(dz)=="number" then
            fx,fz=dx,dz
        end
    end
    local cruise=nil
    if type(vehicle.getCruiseControlState)=="function" then
        local ok,v=pcall(vehicle.getCruiseControlState,vehicle)
        if ok then cruise=v end
    end
    publication:publish("DIAGNOSTIC","INFO",
        "COMPLETION_SETTLEMENT_MOTION_SAMPLE",function()
        return {rootNode=tostring(vehicle.rootNode),
            leg=state.route.legs[state.legIndex].name,
            guidanceIndex=state.legIndex,
            guidanceCount=#state.route.legs,
            guideTargetX=state.route.legs[state.legIndex].point.x,
            guideTargetZ=state.route.legs[state.legIndex].point.z,
            moveForwards=state.route.legs[state.legIndex].moveForwards,
            phase=state.phase,x=x,z=z,headingX=fx,headingZ=fz,
            steeringRotatedTime=vehicle.rotatedTime,
            playerClaim=playerClaim(vehicle) or "NO_POSITIVE_CLAIM",
            speedMps=type(vehicle.lastSpeedReal)=="number"
                and math.abs(vehicle.lastSpeedReal)*1000 or "unknown",
            cruiseState=cruise,commanded=self.drive.active
                and self.drive.active.commanded or 0,
            localTargetDistanceM=status and status.localTargetDistanceM,
            regionProgressM=status and status.progressM,
            driveStatus=status and status.reason or "NO_NATIVE_STATUS_REASON",
            motorWasRunningInitially=self.drive.active
                and self.drive.active.motorWasRunningInitially,
            motorStartCallAccepted=self.drive.active
                and self.drive.active.motorStartCallAccepted,
            motorStartReply=self.drive.active
                and self.drive.active.motorStartReply,
            stoppingSteadyMs=status and status.steadyMs}
    end)
end

local retryStopped,allocation
function Runtime:startLeg()
    local s=self.active
    if s==nil then return end
    local leg=s.route.legs[s.legIndex]
    if leg==nil then
        if s.route.mode=="REPOSITION_INFIELD" then
            -- This stop proves only an infield intermediate actual pose.
            -- No exterior terminal was claimed or certified.
            if s.driveArmed then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    "REPOSITION_HANDOFF_WITH_ACTIVE_DRIVE")
                return
            end
            local occupancy,why=AssemblyOccupancy.assess(
                s.vehicle,s.sourceField)
            if occupancy==nil or occupancy.status~="INSIDE" then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                    why or "REPOSITION_ACTUAL_ASSEMBLY_NOT_INSIDE")
                return
            end
            -- A physically observed Manoeuvrable Pose changes which
            -- destinations are attainable. Do not restart nearest-edge
            -- planning and commit before comparing the Source Field edges.
            -- The allocator still requires a fully connected actual-pose
            -- approach before claiming an exterior terminal.
            s.occupancy=occupancy.status
            s.planningElapsedMs=0
            publish("DEBUG","INFO","COMPLETION_SETTLEMENT_REPOSITION_OBSERVED",{
                rootNode=tostring(s.vehicle.rootNode),
                note="PHYSICAL_STOP_CONFIRMED_FIELD_WIDE_DESTINATION_REASSESSMENT"})
            local accepted,reason=allocation(self,s,
                "REPOSITION_ACTUAL_POSE_DESTINATION_REASSESSMENT")
            if not accepted then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                    reason or "REPOSITION_REASSESSMENT_UNAVAILABLE")
            end
            return
        end
        if s.route.mode=="EXTENDED_INFIELD" then
            -- The long approach grants NO terminal parking result.
            -- Its final stop was independently released before handoff.
            if s.driveArmed then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    "EXTENDED_HANDOFF_WITH_ACTIVE_DRIVE")
                return
            end
            if not Allocation.claimCurrent(self.claims,s.vehicle) then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    "TERMINAL_CLAIM_MISSING_AT_HANDOFF")
                return
            end
            local session,why=OuttaMyWay.CompletionSettlementRoute.beginPlan(
                s.vehicle,{sourceField=s.sourceField,edgeIndex=s.edgeIndex,
                    stationMin=s.stationMin,stationMax=s.stationMax,
                    expectedEntryPose=s.route.entryPose})
            if session==nil then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    why or "LOCAL_HANDOFF_PLANNER_UNAVAILABLE")
                return
            end
            self.active=nil
            self.pending={vehicle=s.vehicle,job=s.job,sourceField=s.sourceField,plan=session,
                kind="LOCAL_HANDOFF",elapsedMs=s.totalElapsedMs,
                stationMin=s.stationMin,stationMax=s.stationMax,
                edgeIndex=s.edgeIndex,
                phase="PLANNING",driveArmed=false}
            publish("DEBUG","INFO","COMPLETION_SETTLEMENT_LOCAL_HANDOFF_PLANNING",{
                rootNode=tostring(s.vehicle.rootNode),
                note="EXTENDED_APPROACH_STOPPED_AND_RELEASED"})
            return
        end
        local okay,reason,predicate=OuttaMyWay.CompletionSettlementRoute.verifyTerminal(
            s.vehicle,s.route)
        if okay then
            self:finish("COMPLETION_SETTLEMENT_FINISHED",reason)
            return
        end
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_TERMINAL_REFUSAL",{
            rootNode=tostring(s.vehicle.rootNode),
            reason=reason,predicate=predicate or "unknown",
            edge=s.route.edge,correctionAttempted=s.terminalCorrectionAttempted==true})
        -- Stop and cruise-OFF were established BEFORE reaching here. The
        -- next move requires a newly qualified current-pose corridor and
        -- a retained terminal claim; never blindly add distance.
        if not self.terminalCorrections[s.vehicle] then
            s.terminalCorrectionAttempted=true
            self.terminalCorrections[s.vehicle]=true
            local candidate,why=OuttaMyWay.CompletionSettlementRoute.planTerminalCorrection(
                s.vehicle,s.route)
            if candidate~=nil then
                local matched=Allocation.matchesClaim(self.claims,s.vehicle,candidate)
                local clear=matched and Allocation.claimClear(
                    self.claims,s.vehicle,candidate.poly)
                local routeClear=clear and
                    OuttaMyWay.SettlementPhysicalOccupancy.routeClear(s.vehicle,candidate)
                if matched and clear and routeClear then
                    s.route=candidate
                    s.legIndex=1
                    s.phase="ADMITTED"
                    publish("DEBUG","INFO",
                        "COMPLETION_SETTLEMENT_TERMINAL_CORRECTION_ADMITTED",{
                        rootNode=tostring(s.vehicle.rootNode),
                        edge=candidate.edge,
                        correctionMethod=candidate.method,
                        guidancePoints=#candidate.legs,
                        targetX=candidate.terminalPose.x,
                        targetZ=candidate.terminalPose.z,
                        note="CURRENT_POSE_QUALIFIED_NOT_VERIFIED"})
                    self:startLeg()
                    return
                end
                why="TERMINAL_CORRECTION_CLAIM_OR_OCCUPANCY_REFUSED"
            end
            publish("DEBUG","INFO","COMPLETION_SETTLEMENT_TERMINAL_CORRECTION_UNAVAILABLE",{
                rootNode=tostring(s.vehicle.rootNode),
                reason=why or "NO_CURRENT_POSE_TERMINAL_CORRECTION"})
        end
        if retryStopped(self,s,reason) then return end
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",reason)
        return
    end
    local x,z=rootPose(s.vehicle)
    if x==nil then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED","ROOT_POSE_UNAVAILABLE")
        return
    end
    local dx,dz=leg.point.x-x,leg.point.z-z
    local distance=math.sqrt(dx*dx+dz*dz)
    if distance<=(leg.arrivalRadiusM or 2.5) then
        s.legIndex=s.legIndex+1
        self:startLeg()
        return
    end
    -- Each path point is local guidance, not a commanded stop;
    -- stop and change direction only between physically distinct phases.
    local objective=objectiveFor(s.route,s.legIndex,x,z)
    local started,evidence=self.drive:startMovement(s.vehicle,objective)
    if not started then
        -- Native setters can partially apply before reporting failure.
        s.driveArmed=self.drive.active~=nil
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",evidence)
        return
    end
    s.driveArmed=true
    s.phase="MOVING"
    s.legElapsedMs=0
    s.telemetryElapsedMs=0
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_LEG_STARTED",function() return {
        rootNode=tostring(s.vehicle.rootNode),leg=leg.name,
        ordinal=s.legIndex,moveForwards=leg.moveForwards,
        targetX=string.format("%.2f",leg.point.x),
        targetZ=string.format("%.2f",leg.point.z),
        remainingM=string.format("%.2f",distance),
        requestedSpeedKmh=type(evidence)=="table"
            and evidence.requestedDriveSpeedKmh or "unknown",
        localTargetContract=type(evidence)=="table"
            and evidence.localTargetContract or "unknown",
        initialCruiseState=type(evidence)=="table"
            and evidence.initialCruiseState or "unknown"} end)
end
-- A stopped long-approach worker may yield once if a queued completed
-- peer currently occupies its local parking entry. No uncontrolled
-- correction drive, no unbounded retry, and no simultaneous native leases.
local function deferStoppedEntry(self,state,reason)
    if state.kind~="LOCAL_HANDOFF"
        or #self.waiting==0
        or #self.waiting>=MAX_QUEUED_COMPLETIONS
        or self.deferred[state.vehicle]
        or (reason~="NO_POSE_REACHABLE_PARKING_REGION"
            and reason~="PHYSICAL_OCCUPANCY_ROUTE_CONFLICT") then
        return false
    end
    self.deferred[state.vehicle]=true
    self.pending=nil
    self.waiting[#self.waiting+1]={vehicle=state.vehicle,job=state.job,
        sourceField=state.sourceField}
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_DEFERRED_FOR_PARKING_SPACE",{
        rootNode=tostring(state.vehicle.rootNode),reason=reason,
        queuedAfterOther=#self.waiting-1,
        note="PREVIOUS_LONG_APPROACH_PHYSICALLY_STOPPED"})
    return true
end
local function beginEpisode(self,job,vehicle,sourceField)
    local okay,session,reason=pcall(
        OuttaMyWay.CompletionSettlementRoute.beginPlan,vehicle,
        {sourceField=sourceField})
    if not okay or session==nil then
        publish("NORMAL","WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),
            reason=okay and tostring(reason)
                or "SETTLEMENT_PLANNING_SESSION_UNAVAILABLE"})
        return false
    end
    self.pending={vehicle=vehicle,job=job,sourceField=sourceField,
        plan=session,
        kind="LOCAL_INITIAL",elapsedMs=0,planningElapsedMs=0,
        phase="PLANNING",driveArmed=false}
    -- This passive comparison never affects admission, native TRANSIT,
    -- edge selection or physical Control.
    if type(publication.isEligible)=="function"
        and publication:isEligible("DIAGNOSTIC","INFO",
            "COMPLETION_SETTLEMENT_MARGIN_COMPARISON") then
        local comparison,why=MarginComparison.beginComparison(vehicle,sourceField)
        if comparison~=nil then
            self.marginComparison=comparison
        else
            publish("DIAGNOSTIC","INFO",
                "COMPLETION_SETTLEMENT_MARGIN_COMPARISON_UNAVAILABLE",{
                    rootNode=tostring(vehicle.rootNode),
                    reason=why or "PROFILE_EVIDENCE_UNAVAILABLE"})
        end
    end
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_PLANNING_STARTED",{
        rootNode=tostring(vehicle.rootNode),
        budgetUnitsPerUpdate=PLAN_UNITS_PER_UPDATE,
        note="NO_MOVEMENT_UNTIL_ROUTE_ADMITTED"})
    return true
end
function Runtime:onNativeCompletion(job,vehicle,retainedSourceField)
    if not self:isAdmitted()
        or type(vehicle)~="table" or self.attempted[vehicle]
        or pairedControlActive() or superseded(vehicle) then
        return false
    end
    local claim=playerClaim(vehicle)
    if claim~=nil then
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),reason=claim})
        return false
    end
    local sourceField=retainedSourceField
    local fieldReason=nil
    if sourceField==nil then
        sourceField,fieldReason=Membership.identify(vehicle)
    end
    if sourceField==nil then
        publish("NORMAL","WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),reason=fieldReason})
        return false
    end
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_SOURCE_FIELD",{
        rootNode=tostring(vehicle.rootNode),fieldId=sourceField.fieldId,
        observedX=sourceField.rootX,observedZ=sourceField.rootZ,
        provenance=sourceField.provenance})
    if self.active~=nil or self.pending~=nil or #self.waiting>0 then
        if #self.waiting>=MAX_QUEUED_COMPLETIONS then
            publish("NORMAL","WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
                rootNode=tostring(vehicle.rootNode),
                reason="COMPLETION_QUEUE_CAPACITY_EXHAUSTED"})
            return false
        end
        self.attempted[vehicle]=true
        self.waiting[#self.waiting+1]={vehicle=vehicle,job=job,
            sourceField=sourceField}
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_QUEUED",{
            rootNode=tostring(vehicle.rootNode),
            ordinal=#self.waiting,
            note="NO_SECOND_NATIVE_CONTROL_WHILE_FIRST_SETTLES"})
        return true
    end
    self.attempted[vehicle]=true
    return beginEpisode(self,job,vehicle,sourceField)
end
allocation=function(self,s,why)
    local collectEvidence=type(publication.isEligible)=="function"
        and publication:isEligible("DIAGNOSTIC","INFO",
            "COMPLETION_SETTLEMENT_ALLOCATION_REJECTIONS")
    local plan,reason=Allocation.beginPlan(
        s.vehicle,self.claims,s.sourceField,s.occupancy,collectEvidence)
    if not plan then return false,reason end
    if collectEvidence and type(plan.evidence)=="table" then
        local previous=s.plan
        plan.evidence.initialReason=why
        plan.evidence.initialCandidates=previous and previous.candidates or 0
        plan.evidence.initialRejections=previous
            and previous.rejectionCounts or {}
    end
    self.active=nil
    self.pending={vehicle=s.vehicle,job=s.job,sourceField=s.sourceField,
        plan=plan,
        kind="ALLOCATE",phase="PLANNING",driveArmed=false,
        elapsedMs=s.totalElapsedMs or s.elapsedMs or 0,
        planningElapsedMs=s.planningElapsedMs or 0,
        occupancy=s.occupancy,allocationElapsedMs=0}
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_ALLOCATING_REGION",{
        rootNode=tostring(s.vehicle.rootNode),reason=why})
    return true
end
retryStopped=function(self,s,why)
    if s.driveArmed or (self.replans[s.vehicle] or 0)>=1 then return false end
    -- A completed physical movement can leave the actual selected assembly
    -- STRADDLING: a fictional INSIDE entry would not be a connected route.
    local current,reason=AssemblyOccupancy.assess(s.vehicle,s.sourceField)
    if current==nil or (current.status~="INSIDE"
        and current.status~="STRADDLING") then
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_REASSESSMENT_UNAVAILABLE",{
            rootNode=tostring(s.vehicle.rootNode),
            reason=reason or (current and current.status) or "OCCUPANCY_UNKNOWN"})
        return false
    end
    s.occupancy=current.status
    self.replans[s.vehicle]=(self.replans[s.vehicle] or 0)+1
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_REASSESSMENT_STARTED",{
        rootNode=tostring(s.vehicle.rootNode),occupancy=s.occupancy,
        reason=why})
    Allocation.release(self.claims,s.vehicle)
    if #self.waiting>0 and #self.waiting<MAX_QUEUED_COMPLETIONS then
        self.active=nil;self.pending=nil
        self.waiting[#self.waiting+1]={vehicle=s.vehicle,job=s.job,
            sourceField=s.sourceField}
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_ALTERNATIVE_QUEUED",{
            rootNode=tostring(s.vehicle.rootNode),reason=why,
            note="STABLE_STOP_CONFIRMED"})
        return true
    end
    return allocation(self,s,why)
end
local function stopForAlternative(self,s,reason)
    if (self.replans[s.vehicle] or 0)>=1 then return false end
    if not s.driveArmed then return retryStopped(self,s,reason) end
    local started,why=self.drive:beginSettlementStop(s.vehicle,true)
    if not started then
        -- Stop admission applies to a completed guidance leg, whereas a
        -- live safety/occupancy refusal can happen mid-leg. Preserve the
        -- actual safety refusal; finish() still performs the same scoped
        -- native neutralisation and retains the claim if unconfirmed.
        publish("DEBUG","WARNING",
            "COMPLETION_SETTLEMENT_SAFETY_STOP_UNAVAILABLE",{
                rootNode=tostring(s.vehicle.rootNode),
                safetyReason=reason,
                stopReason=why or "ALTERNATIVE_BRAKING_UNAVAILABLE"})
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            reason or why or "ALTERNATIVE_BRAKING_UNAVAILABLE")
        return true
    end
    s.phase="STOP_FOR_ALTERNATIVE"
    s.alternativeReason=reason
    publish("DEBUG","INFO","COMPLETION_SETTLEMENT_ALTERNATIVE_STOPPING",{
        rootNode=tostring(s.vehicle.rootNode),reason=reason})
    return true
end
function Runtime:attemptInfieldReposition(s)
    if self.repositioned[s.vehicle] or s.kind~="ALLOCATE"
        or type(OuttaMyWay.ExtendedInfieldApproach.planReposition)
            ~="function" then return false end
    -- A completed parking attempt must not begin an unexplained new move
    -- from an invented interior state. Reobserve the actual full assembly.
    local occupancy=AssemblyOccupancy.assess(s.vehicle,s.sourceField)
    if occupancy==nil or occupancy.status~="INSIDE" then return false end
    local route,why=OuttaMyWay.ExtendedInfieldApproach.planReposition(
        s.vehicle,s.sourceField)
    if route==nil then
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_REPOSITION_UNAVAILABLE",{
            rootNode=tostring(s.vehicle.rootNode),
            reason=why or "NO_NOMINAL_INFIELD_SPACE_GAIN"})
        return false
    end
    local clear,reason=OuttaMyWay.SettlementPhysicalOccupancy.routeClear(
        s.vehicle,route)
    if not clear then
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_REPOSITION_UNAVAILABLE",{
            rootNode=tostring(s.vehicle.rootNode),
            reason=reason or "INFIELD_REPOSITION_PHYSICAL_OCCUPANCY"})
        return false
    end
    self.repositioned[s.vehicle]=true
    self.pending=nil
    self.active={vehicle=s.vehicle,job=s.job,
        sourceField=s.sourceField,route=route,legIndex=1,
        totalElapsedMs=s.elapsedMs,legElapsedMs=0,telemetryElapsedMs=0,
        phase="ADMITTED",driveArmed=false}
    publish("NORMAL","INFO","COMPLETION_SETTLEMENT_REPOSITION_ADMITTED",{
        rootNode=tostring(s.vehicle.rootNode),method=route.method,
        guideCount=#route.legs,estimatedTravelM=route.estimatedTravelM,
        nominalMarginGainM=route.nominalMarginGainM,
        note="INFIELD_INTERMEDIATE_NOT_PARKED"})
    self:startLeg()
    return true
end
function Runtime:update(dt)
    -- One candidate edge per update, only with DIAGNOSTIC enabled.
    local comparison=self.marginComparison
    if comparison~=nil then
        local phase,result,why=MarginComparison.advanceComparison(comparison)
        if phase~="PENDING" then
            self.marginComparison=nil
            if phase=="DONE" then
                publish("DIAGNOSTIC","INFO",
                    "COMPLETION_SETTLEMENT_MARGIN_COMPARISON",function()
                    return {
                        rootNode=tostring(result.rootNode),
                        fieldId=result.fieldId,
                        nearestEdge=result.nearestEdge,
                        edgesExamined=#result.rows,
                        edgeCount=#result.frames,
                        truncated=result.truncated,
                        sampleBasis="CURRENT_NOMINAL_MEMBER_RECTANGLES",
                        nominalEnvelope="TERMINAL_ONLY_NOT_APPROACH_OR_RUNOUT",
                        roadSurface="UNKNOWN_NOT_OBSERVED",
                        staticObstacles="UNKNOWN_NOT_OBSERVED",
                        terrainBasis="MIDPOINT_HEIGHT_DELTA_2_TO_12_M_ONLY",
                        corridorSafety="NOT_ESTABLISHED",
                        edgeEvidence=MarginComparison.summarize(result)
                    }
                    end)
            else
                publish("DIAGNOSTIC","INFO",
                    "COMPLETION_SETTLEMENT_MARGIN_COMPARISON_UNAVAILABLE",{
                        rootNode=tostring(comparison.rootNode),
                        reason=why or "COMPARISON_FAILED"})
            end
        end
    end
    local s=self.active or self.pending
    if s~=nil and type(Situation)=="table"
        and type(Situation.sample)=="function" then
        Situation.sample(s.vehicle,dt,s.sourceField)
    end
    if s==nil then
        if #self.waiting==0 then return end
        if not self:isAdmitted() then
            self.waiting={}
            return
        end
        if pairedControlActive() then return end
        local item=table.remove(self.waiting,1)
        local claim=playerClaim(item.vehicle)
        if superseded(item.vehicle) or claim~=nil then
            publish("DEBUG","INFO","COMPLETION_SETTLEMENT_QUEUED_REJECTED",{
                rootNode=tostring(item.vehicle.rootNode),
                reason=claim or "GIANTS_JOB_SUPERSEDED"})
            return
        end
        beginEpisode(self,item.job,item.vehicle,item.sourceField)
        return
    end
    local claim=playerClaim(s.vehicle)
    if not self:isAdmitted() or superseded(s.vehicle)
        or pairedControlActive() or claim~=nil then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            claim or "CONFIGURATION_JOB_OR_OTHER_CONTROL_SUPERSEDED")
        return
    end
    if type(dt)~="number" or dt<=0 or dt>5000 then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            "UPDATE_CLOCK_UNAVAILABLE")
        return
    end
    if self.pending~=nil then
        s.elapsedMs=s.elapsedMs+dt
        s.planningElapsedMs=(s.planningElapsedMs or 0)+dt
        if s.kind=="ALLOCATE" then
            s.allocationElapsedMs=(s.allocationElapsedMs or 0)+dt
            -- One in-progress witness makes early-ended GIANTS captures
            -- interpretable without per-frame logging or physical work.
            if s.allocationElapsedMs>=ALLOCATION_PROGRESS_SAMPLE_MS
                and not s.allocationProgressPublished then
                s.allocationProgressPublished=true
                publish("DIAGNOSTIC","INFO",
                    "COMPLETION_SETTLEMENT_ALLOCATION_PROGRESS",function()
                    local p=s.plan
                    return {rootNode=tostring(s.vehicle.rootNode),
                        elapsedMs=s.allocationElapsedMs,
                        planningElapsedMs=s.planningElapsedMs,
                        sitesExamined=p.siteIndex or 0,
                        sitesTotal=p.sites and #p.sites or "unknown",
                        currentSite=p.site and p.site.edgeIndex or "none",
                        phase=p.phase,
                        localCandidates=p.localPlan and
                            p.localPlan.candidates or 0,
                        weightedGeometryChecks=p.spent or 0}
                    end)
            end
        end
        if s.kind=="LOCAL_INITIAL" and not s.occupancyAssessed then
            -- Parking independently assesses current occupancy. The selected
            -- real member rectangles, not tractor-root containment, decide
            -- whether this Source Field still needs clearing.
            local result,why=AssemblyOccupancy.assess(s.vehicle,s.sourceField)
            if result==nil then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                    why or "ASSEMBLY_FIELD_OCCUPANCY_UNAVAILABLE")
                return
            end
            s.occupancyAssessed=true
            s.occupancy=result.status
            publish("DEBUG","INFO","COMPLETION_ASSEMBLY_FIELD_OCCUPANCY",{
                rootNode=tostring(s.vehicle.rootNode),
                fieldId=result.sourceFieldId,
                status=result.status,memberCount=result.memberCount,
                intersectingMembers=result.intersectingMembers})
            if result.status=="CLEAR" then
                -- No physical Control, no parking claim, no fake successful
                -- terminal manoeuvre. A queued episode uses this same test.
                self:finish("COMPLETION_SETTLEMENT_NOT_REQUIRED",
                    "ASSEMBLY_ALREADY_CLEAR_OF_SOURCE_FIELD")
                return
            end
            if result.status~="INSIDE" and result.status~="STRADDLING" then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                    "ASSEMBLY_FIELD_OCCUPANCY_UNKNOWN")
                return
            end
        end
        if s.elapsedMs>TOTAL_DEADLINE_MS then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                "FINITE_PLANNING_LEASE_EXPIRED")
            return
        end
        if s.planningElapsedMs>PLANNING_RESPONSE_BUDGET_MS then
            -- Budget expiry refuses unqualified parking; it never turns
            -- a candidate into a route or authorises native steering.
            publish("DEBUG","INFO",
                "COMPLETION_SETTLEMENT_PLANNING_RESPONSE_LIMIT",{
                rootNode=tostring(s.vehicle.rootNode),
                stage=s.kind,elapsedMs=s.planningElapsedMs,
                sitesExamined=s.plan and s.plan.siteIndex or 0,
                sitesTotal=s.plan and s.plan.sites
                    and #s.plan.sites or "unknown",
                weightedGeometryChecks=s.plan and s.plan.spent or 0})
            publishAllocationEvidence(s,
                "PARKING_PLANNING_RESPONSE_BUDGET_EXHAUSTED",true)
            if self:attemptInfieldReposition(s) then return end
            self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                "PARKING_PLANNING_RESPONSE_BUDGET_EXHAUSTED")
            return
        end
        local phase,route,reason
        if s.prequalifiedRoute~=nil and (s.kind=="LOCAL_ALLOCATED" or s.kind=="EXTENDED") then
            -- The allocator has qualified a complete local route from the
            -- actual straddling pose, rather than an imaginary entry point.
            phase,route="DONE",s.prequalifiedRoute
        else
            local planner=s.kind=="ALLOCATE" and Allocation or
                (s.kind=="EXTENDED" and OuttaMyWay.ExtendedInfieldApproach
                or OuttaMyWay.CompletionSettlementRoute)
            phase,route,reason=planner.advancePlan(
                s.plan,PLAN_UNITS_PER_UPDATE)
        end
        if s.kind=="ALLOCATE" and s.plan and s.plan.sites
            and not s.destinationPriorityPublished then
            s.destinationPriorityPublished=true
            publish("DIAGNOSTIC","INFO",
                "COMPLETION_SETTLEMENT_DESTINATION_PRIORITIES",function()
                local listed={}
                local seen={}
                for i=1,math.min(#s.plan.sites,20) do
                    local site=s.plan.sites[i]
                    if not seen[site.edgeIndex] then
                        seen[site.edgeIndex]=true
                        listed[#listed+1]=tostring(site.edgeIndex)
                            ..":rank"..tostring(site.selectionRank)
                            ..":usable"..string.format("%.1f",
                                site.usableLongitudinalM or 0)
                            ..":risk"..tostring(site.peerRisk)
                    end
                end
                return {rootNode=tostring(s.vehicle.rootNode),
                    fieldId=s.sourceField and s.sourceField.fieldId,
                    occupancy=s.occupancy,
                    totalSites=#s.plan.sites,
                    priorityPreview=table.concat(listed,";"),
                    basis="PEER_RISK_USABLE_LENGTH_CROSS_EDGE_COVERAGE",
                    exteriorRoadClearance="UNKNOWN_NOT_OBSERVED",
                    selection="ORDER_ONLY_NO_MOVEMENT_OR_CLAIM"}
                end)
        end
        if phase=="PENDING" then return end
        if s.kind=="ALLOCATE" and phase=="DONE" and route then
            -- The allocator must have qualified the actual-pose connection
            -- before returning this terminal as claimable.
            if route.qualifiedDirectRoute==nil
                and route.qualifiedApproachRoute==nil then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                    "PARKING_APPROACH_CONNECTIVITY_UNQUALIFIED")
                return
            end
            local claim,why=Allocation.claim(self.claims,s.vehicle,
                route.terminalPose,route.ownRadius)
            if not claim then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",why)
                return
            end
            s.stationMin=route.stationMin;s.stationMax=route.stationMax
            s.edgeIndex=route.edge
            if route.qualifiedDirectRoute~=nil then
                s.plan=nil
                s.prequalifiedRoute=route.qualifiedDirectRoute
                s.kind="LOCAL_ALLOCATED"
            else
                s.plan=nil
                s.prequalifiedRoute=route.qualifiedApproachRoute
                s.kind="EXTENDED"
            end
            publish("DEBUG","INFO","COMPLETION_SETTLEMENT_REGION_CLAIMED",function() return {
                rootNode=tostring(s.vehicle.rootNode),station=route.station,
                terminalX=route.terminalPose.x,terminalZ=route.terminalPose.z,
                entryX=route.entryPose.x,entryZ=route.entryPose.z,
                situationRisk=route.situationRisk,
                situationReason=route.situationReason,
                workingPeers=route.workingPeers,
                motionWitnesses=route.motionWitnesses,
                headingWitnesses=route.headingWitnesses,
                selectionCost=route.selectionCost,
                edgeIndex=route.edge,
                selectionRank=route.selectionRank,
                usableLongitudinalM=route.usableLongitudinalM,
                selectionBasis="PEER_RISK_THEN_USABLE_EDGE_SPACE_NOT_ROAD_PROOF",
                edgeQualification="LOCAL_ROUTE_AND_TERMINAL_QUALIFIED"} end)
            return
        end
        if s.kind=="EXTENDED" and phase=="DONE" and route
            and #route.legs==0 then
            local plan=OuttaMyWay.CompletionSettlementRoute.beginPlan(
                s.vehicle,{sourceField=s.sourceField,edgeIndex=s.edgeIndex,
                    stationMin=s.stationMin,stationMax=s.stationMax,
                    expectedEntryPose=route.entryPose})
            if not plan then
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                    "LOCAL_HANDOFF_PLANNER_UNAVAILABLE")
                return
            end
            s.plan=plan;s.kind="LOCAL_HANDOFF"
            publish("DEBUG","INFO","COMPLETION_SETTLEMENT_ALREADY_AT_QUALIFIED_ENTRY",{
                rootNode=tostring(s.vehicle.rootNode)})
            return
        end
        if phase~="DONE" or route==nil then
            publishAllocationEvidence(s,
                reason or "NO_QUALIFIED_TERMINAL_REGION",false)
            if s.kind=="EXTENDED" and type(s.plan.sceneEvidence)=="table" then
                -- One bounded evidence line on a failed scene admission,
                -- not a per-frame or per-candidate diagnostic flood.
                local scene=s.plan.sceneEvidence
                publish("DEBUG","INFO","COMPLETION_SETTLEMENT_SCENE_ADMISSION_FAILED",{
                    rootNode=tostring(s.vehicle.rootNode),
                    reason=tostring(reason),
                    registry=scene.registry or "unknown",
                    examined=scene.scanned or 0,
                    relevantWorkers=scene.observedWorkers or 0,
                    outsideField=scene.outsideField or 0,
                    nonAiRoots=scene.nonAiRoots or 0,
                    failureRoot=scene.failureRoot or "none"})
            end
            if s.kind=="LOCAL_HANDOFF"
                and reason=="NO_POSE_REACHABLE_PARKING_REGION"
                and type(publication.isEligible)=="function"
                and publication:isEligible("DIAGNOSTIC","INFO",
                    "COMPLETION_SETTLEMENT_LOCAL_ENTRY_REJECTED") then
                -- A stopped guidance handoff is not a proven feasible entry.
                -- Publish the bounded actual-pose refusal only once.
                local counts={}
                for name,amount in pairs(s.plan.rejectionCounts or {}) do
                    counts[#counts+1]=name..":"..tostring(amount)
                end
                table.sort(counts)
                local actual=s.plan.current or {}
                local expected=s.plan.options
                    and s.plan.options.expectedEntryPose or {}
                publish("DIAGNOSTIC","INFO","COMPLETION_SETTLEMENT_LOCAL_ENTRY_REJECTED",{
                    rootNode=tostring(s.vehicle.rootNode),
                    actualX=actual.x or "unknown",
                    actualZ=actual.z or "unknown",
                    actualFx=actual.fx or "unknown",
                    actualFz=actual.fz or "unknown",
                    qualifiedX=expected.x or "unknown",
                    qualifiedZ=expected.z or "unknown",
                    qualifiedFx=expected.fx or "unknown",
                    qualifiedFz=expected.fz or "unknown",
                    stationMin=s.stationMin or "unknown",
                    stationMax=s.stationMax or "unknown",
                    candidates=s.plan.candidates or 0,
                    rejectionCounts=table.concat(counts,";"),
                    note="NOMINAL_ENTRY_NOT_PHYSICAL_HANDOFF_PROOF"})
            end
            if s.kind=="LOCAL_INITIAL"
                and reason=="NO_POSE_REACHABLE_PARKING_REGION" then
                if allocation(self,s,reason) then return end
            elseif s.kind=="LOCAL_HANDOFF" then
                if retryStopped(self,s,reason) then return end
            end
            self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                reason or "POSE_CONDITIONED_ROUTE_UNAVAILABLE")
            return
        end
        if s.kind=="LOCAL_INITIAL" then
            local claim,why=Allocation.claimForRoute(self.claims,s.vehicle,route)
            if not claim then
                if allocation(self,s,why) then return end
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",why)
                return
            end
        elseif s.kind=="LOCAL_HANDOFF" or s.kind=="LOCAL_ALLOCATED" then
            local matched,miss=Allocation.matchesClaim(
                self.claims,s.vehicle,route)
            if not matched then
                if retryStopped(self,s,miss) then return end
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",miss)
                return
            end
            local okay,why=Allocation.claimClear(self.claims,s.vehicle,route.poly)
            if not okay then
                if retryStopped(self,s,why) then return end
                self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",why)
                return
            end
        end
        -- Reobserve ALL physical assemblies: completed workers are not
        -- released parking space merely because their AI job stopped.
        local spaceClear,spaceWhy=OuttaMyWay.SettlementPhysicalOccupancy.routeClear(
            s.vehicle,route)
        if not spaceClear then
            if retryStopped(self,s,spaceWhy) then return end
            self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                spaceWhy or "PARKING_SPACE_NO_LONGER_AVAILABLE")
            return
        end
        self.pending=nil
        self.active={vehicle=s.vehicle,job=s.job,sourceField=s.sourceField,
            route=route,legIndex=1,
            stationMin=s.stationMin,stationMax=s.stationMax,
            edgeIndex=s.edgeIndex or route.edge,
            totalElapsedMs=s.elapsedMs,legElapsedMs=0,telemetryElapsedMs=0,
            phase="ADMITTED",driveArmed=false}
        publish("NORMAL","INFO","COMPLETION_SETTLEMENT_ADMITTED",{
            rootNode=tostring(s.vehicle.rootNode),
            field=route.field,edge=route.edge,
            stage=s.kind or "LOCAL_INITIAL",
            plannedMethod=route.method,
            verification="ADMITTED_ROUTE_NOT_PHYSICAL_PARKING_RESULT"})
        publication:publish("DEBUG","INFO",
            "COMPLETION_SETTLEMENT_ADMISSION_EVIDENCE",function()
            return {
            rootNode=tostring(s.vehicle.rootNode),
            planningUpdates=s.plan and s.plan.advances or "prequalified",
            weightedGeometryChecks=s.plan and s.plan.spent or "prequalified",
            stage=s.kind or "LOCAL_INITIAL",
            sceneRegistry=s.plan and type(s.plan.sceneEvidence)=="table"
                and s.plan.sceneEvidence.registry or "not-required",
            observedActiveWorkers=s.plan and type(s.plan.sceneEvidence)=="table"
                and s.plan.sceneEvidence.observedWorkers or "not-required",
            field=route.field,edge=route.edge,
            memberCount=route.memberCount,
            plannedMethod=route.method,reverseM=route.reverseM,
            guidancePoints=#route.legs,
            estimatedTravelM=route.estimatedTravelM,
            guideRadiusM=route.guideRadiusM,
            note="TEST_NOMINAL_POSE_PATH_NOT_PHYSICAL_CLEARANCE"}
        end)
        self:startLeg()
        return
    end
    s.totalElapsedMs=s.totalElapsedMs+dt
    s.legElapsedMs=s.legElapsedMs+dt
    s.telemetryElapsedMs=s.telemetryElapsedMs+dt
    if s.totalElapsedMs>TOTAL_DEADLINE_MS
        or s.legElapsedMs>LEG_DEADLINE_MS then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            "FINITE_CONTROL_LEASE_EXPIRED")
        return
    end
    if s.phase=="MOVING" and
        (s.route.mode=="EXTENDED_INFIELD"
            or s.route.mode=="REPOSITION_INFIELD") then
        s.peerCheckMs=(s.peerCheckMs or 250)+dt
        if s.peerCheckMs>=250 then
            s.peerCheckMs=0
            local valid,why=OuttaMyWay.ExtendedInfieldApproach.guard(
                s.vehicle,s.route,s.legIndex)
            -- A bounded infield reposition has no exterior terminal
            -- claim. Its actual assembly, peer and occupancy guards remain
            -- mandatory; the claim is needed only for a parking approach.
            local claimed,claimWhy=true,nil
            if s.route.mode=="EXTENDED_INFIELD" then
                claimed,claimWhy=Allocation.claimClear(
                    self.claims,s.vehicle,s.route.poly)
            end
            if not valid or not claimed then
                local reason=not claimed and claimWhy or why
                    or "EXTENDED_APPROACH_UNSUPPORTED"
                if not stopForAlternative(self,s,reason) then
                    self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",reason)
                end
                return
            end
        end
    elseif s.phase=="MOVING"
        and type(OuttaMyWay.CompletionSettlementRoute.guard)=="function" then
        local valid,why=OuttaMyWay.CompletionSettlementRoute.guard(
            s.vehicle,s.route,s.legIndex)
        if not valid then
            local reason=why or "SETTLEMENT_PATH_ENVELOPE_LOST"
            if not stopForAlternative(self,s,reason) then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",reason)
            end
            return
        end
        s.peerCheckMs=(s.peerCheckMs or 250)+dt
        if s.peerCheckMs>=250 then
            s.peerCheckMs=0
            local clear,reason=OuttaMyWay.SettlementPhysicalOccupancy.nextClear(
                s.vehicle,s.route,s.legIndex)
            if not clear then
                local why=reason or "LOCAL_PARKING_SPACE_OCCUPIED"
                if not stopForAlternative(self,s,why) then
                    self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",why)
                end
                return
            end
        end
    end
    local status
    if s.phase=="STOPPING" or s.phase=="STOP_FOR_ALTERNATIVE" then
        status=self.drive:settlementStopStatus(s.vehicle,dt)
    else
        status=self.drive:movementStatus(s.vehicle,dt)
    end
    if status==nil or status.isFailed then
        -- A diverged nominal trajectory disproves this route, not every
        -- route. Physically stop before requalifying from the live pose.
        if status~=nil and s.phase=="MOVING"
            and status.reason=="SETTLEMENT_LEG_TRAJECTORY_DIVERGED"
            and stopForAlternative(self,s,status.reason) then
            return
        end
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            status and status.reason or "DRIVE_STATUS_UNAVAILABLE")
        return
    end
    if s.phase=="STOP_FOR_ALTERNATIVE" and status.isStopped then
        local stopped,why=self.drive:stopMovement(s.vehicle,true)
        if not stopped then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                why or "ALTERNATIVE_NATIVE_RELEASE_UNCONFIRMED")
            return
        end
        s.driveArmed=false
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_ALTERNATIVE_STOPPED",{
            rootNode=tostring(s.vehicle.rootNode),
            stableMs=status.steadyMs,cruiseState=status.cruiseState})
        if not retryStopped(self,s,s.alternativeReason) then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                "NO_REASSESSMENT_AVAILABLE")
        end
        return
    end
    self:sampleMotion(s,status)
    if s.phase=="MOVING" and status.isComplete then
        local completedLeg=s.route.legs[s.legIndex]
        local nextLeg=s.route.legs[s.legIndex+1]
        if nextLeg~=nil
            and nextLeg.moveForwards==completedLeg.moveForwards then
            -- Short steering points are continuous tracking targets.
            -- One native lease, no artificial braking between points.
            local x,z=rootPose(s.vehicle)
            if x==nil then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    "GUIDANCE_POSE_UNAVAILABLE")
                return
            end
            local objective=objectiveFor(
                s.route,s.legIndex+1,x,z)
            local changed,why=self.drive:retargetSettlement(
                s.vehicle,objective)
            if not changed then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    why or "GUIDANCE_RETARGET_FAILED")
                return
            end
            s.legIndex=s.legIndex+1
            s.legElapsedMs=0
            return
        end
        local started,reason=self.drive:beginSettlementStop(s.vehicle)
        if not started then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                reason or "SETTLEMENT_BRAKING_UNAVAILABLE")
            return
        end
        s.phase="STOPPING"
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_STOPPING",{
            rootNode=tostring(s.vehicle.rootNode),
            leg=completedLeg.name,
            note=nextLeg and "DIRECTION_CHANGE_REQUIRES_STOP"
                or "PARKING_REGION_REQUIRES_STOP"})
        return
    end
    if s.phase=="STOPPING" and status.isStopped then
        local stopped,why=self.drive:stopMovement(s.vehicle)
        if not stopped then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                why or "PHYSICAL_STOP_RELEASE_UNCONFIRMED")
            return
        end
        s.driveArmed=false
        publish("DEBUG","INFO","COMPLETION_SETTLEMENT_LEG_FINISHED",{
            rootNode=tostring(s.vehicle.rootNode),
            leg=s.route.legs[s.legIndex].name,ordinal=s.legIndex,
            physicalSpeedMps=status.speedMps,
            steadyMs=status.steadyMs,
            cruiseState=status.cruiseState})
        s.legIndex=s.legIndex+1
        self:startLeg()
    end
end
function Runtime:relinquish(reason)
    self.marginComparison=nil
    self.waiting={}
    self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
        reason or "CONTROL_REVOKED")
end
function Runtime:loadMap()
    self.marginComparison=nil
    self.pending=nil
    self.active=nil
    self.waiting={}
    self.claims={}
    self.replans=setmetatable({},{__mode="k"})
    self.terminalCorrections=setmetatable({},{__mode="k"})
    self.attempted=setmetatable({},{__mode="k"})
    self.repositioned=setmetatable({},{__mode="k"})
    self.deferred=setmetatable({},{__mode="k"})
    if type(Situation)=="table" and type(Situation.reset)=="function" then
        Situation.reset()
    end
end
function Runtime:deleteMap()
    self.marginComparison=nil
    local s=self.active
    if s~=nil and s.driveArmed then
        self.drive:discardOnMapDelete(s.vehicle)
    end
    self.active=nil
    self.pending=nil
    self.waiting={}
    self.claims={}
    self.replans=setmetatable({},{__mode="k"})
    self.terminalCorrections=setmetatable({},{__mode="k"})
    self.attempted=setmetatable({},{__mode="k"})
    self.repositioned=setmetatable({},{__mode="k"})
    self.deferred=setmetatable({},{__mode="k"})
    if type(Situation)=="table" and type(Situation.reset)=="function" then
        Situation.reset()
    end
end
return Runtime
