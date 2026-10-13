-- Explicitly opted-in TEST completion settlement Control. Does not share a
-- native drive instance or intervention state with active Hold & Relocate.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSettlementRuntime={}
local Runtime=OuttaMyWay.CompletionSettlementRuntime
Runtime.__index=Runtime
local publication=OuttaMyWay.LogPublication.origin("COMPLETION_SETTLEMENT")
local TOTAL_DEADLINE_MS=240000
local LEG_DEADLINE_MS=180000
local SAMPLE_MS=1000
-- Serial Control remains deliberate. Other completions queue for an
-- independent assessment and space allocation after the current lease.
local MAX_QUEUED_COMPLETIONS=2
-- Each update resumes the route search ONCE with a finite weighted geometry
-- budget. No native movement or fieldwork handback occurs during planning.
local PLAN_UNITS_PER_UPDATE=320
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
    return {moveForwards=leg.moveForwards,
        maximumSpeedKmh=guidanceSpeed(distance),
        remainingAfterTargetM=beyond,
        targetX=leg.point.x,targetZ=leg.point.z,
        returnRegion={source="COMPLETION_SETTLEMENT_LEG"}},distance
end
local function publish(level,code,fields)
    publication:publish("NORMAL",level,code,function()
        fields.version=OuttaMyWay.VERSION
        return fields
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
function Runtime.new(configuration,diagnostics)
    return setmetatable({configuration=configuration,diagnostics=diagnostics,
        drive=OuttaMyWay.NativeStaticAssemblyDriveMechanism.new(),
        active=nil,pending=nil,waiting={},
        attempted=setmetatable({},{__mode="k"}),
        deferred=setmetatable({},{__mode="k"})},Runtime)
end
function Runtime:isAdmitted()
    return g_server~=nil and self.configuration~=nil
        and self.configuration:isResolved()==true
        and self.configuration:isEnabled()==true
        and self.diagnostics~=nil
        and type(self.diagnostics.isSettlementPrototypeEnabled)=="function"
        and self.diagnostics:isSettlementPrototypeEnabled()==true
end
function Runtime:finish(code,reason)
    local state=self.active or self.pending
    if state==nil then return end
    self.active=nil
    self.pending=nil
    if state.driveArmed then
        local stopped,why=self.drive:cancelMovement(state.vehicle)
        if not stopped then
            publish("WARNING","COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED",{
                rootNode=tostring(state.vehicle.rootNode),reason=tostring(why)})
        end
    end
    publish(code=="COMPLETION_SETTLEMENT_FINISHED" and "INFO" or "WARNING",
        code,{rootNode=tostring(state.vehicle.rootNode),
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
        return {version=OuttaMyWay.VERSION,
            rootNode=tostring(vehicle.rootNode),
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
            stoppingSteadyMs=status and status.steadyMs}
    end)
end

function Runtime:startLeg()
    local s=self.active
    if s==nil then return end
    local leg=s.route.legs[s.legIndex]
    if leg==nil then
        if s.route.mode=="EXTENDED_INFIELD" then
            -- The long approach grants NO terminal parking result.
            -- Its final stop was independently released before handoff.
            if s.driveArmed then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    "EXTENDED_HANDOFF_WITH_ACTIVE_DRIVE")
                return
            end
            local session,why=OuttaMyWay.CompletionSettlementRoute.beginPlan(
                s.vehicle)
            if session==nil then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    why or "LOCAL_HANDOFF_PLANNER_UNAVAILABLE")
                return
            end
            self.active=nil
            self.pending={vehicle=s.vehicle,job=s.job,plan=session,
                kind="LOCAL_HANDOFF",elapsedMs=s.totalElapsedMs,
                phase="PLANNING",driveArmed=false}
            publish("INFO","COMPLETION_SETTLEMENT_LOCAL_HANDOFF_PLANNING",{
                rootNode=tostring(s.vehicle.rootNode),
                note="EXTENDED_APPROACH_STOPPED_AND_RELEASED"})
            return
        end
        local okay,reason=OuttaMyWay.CompletionSettlementRoute.verifyTerminal(
            s.vehicle,s.route)
        self:finish(okay and "COMPLETION_SETTLEMENT_FINISHED"
            or "COMPLETION_SETTLEMENT_INTERRUPTED",reason)
        return
    end
    local x,z=rootPose(s.vehicle)
    if x==nil then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED","ROOT_POSE_UNAVAILABLE")
        return
    end
    local dx,dz=leg.point.x-x,leg.point.z-z
    local distance=math.sqrt(dx*dx+dz*dz)
    if distance<=2.5 then
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
    publish("INFO","COMPLETION_SETTLEMENT_LEG_STARTED",{
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
            and evidence.initialCruiseState or "unknown"})
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
    self.waiting[#self.waiting+1]={vehicle=state.vehicle,job=state.job}
    publish("INFO","COMPLETION_SETTLEMENT_DEFERRED_FOR_PARKING_SPACE",{
        rootNode=tostring(state.vehicle.rootNode),reason=reason,
        queuedAfterOther=#self.waiting-1,
        note="PREVIOUS_LONG_APPROACH_PHYSICALLY_STOPPED"})
    return true
end
local function beginEpisode(self,job,vehicle)
    local okay,session,reason=pcall(
        OuttaMyWay.CompletionSettlementRoute.beginPlan,vehicle)
    if not okay or session==nil then
        publish("WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),
            reason=okay and tostring(reason)
                or "SETTLEMENT_PLANNING_SESSION_UNAVAILABLE"})
        return false
    end
    self.pending={vehicle=vehicle,job=job,plan=session,
        kind="LOCAL_INITIAL",elapsedMs=0,phase="PLANNING",driveArmed=false}
    publish("INFO","COMPLETION_SETTLEMENT_PLANNING_STARTED",{
        rootNode=tostring(vehicle.rootNode),
        budgetUnitsPerUpdate=PLAN_UNITS_PER_UPDATE,
        note="NO_MOVEMENT_UNTIL_ROUTE_ADMITTED"})
    return true
end
function Runtime:onNativeCompletion(job,vehicle,transitAccepted)
    if not self:isAdmitted() or transitAccepted~=true
        or type(vehicle)~="table" or self.attempted[vehicle]
        or pairedControlActive() or superseded(vehicle) then
        return false
    end
    local claim=playerClaim(vehicle)
    if claim~=nil then
        publish("WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),reason=claim})
        return false
    end
    if self.active~=nil or self.pending~=nil or #self.waiting>0 then
        if #self.waiting>=MAX_QUEUED_COMPLETIONS then
            publish("WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
                rootNode=tostring(vehicle.rootNode),
                reason="COMPLETION_QUEUE_CAPACITY_EXHAUSTED"})
            return false
        end
        self.attempted[vehicle]=true
        self.waiting[#self.waiting+1]={vehicle=vehicle,job=job}
        publish("INFO","COMPLETION_SETTLEMENT_QUEUED",{
            rootNode=tostring(vehicle.rootNode),
            ordinal=#self.waiting,
            note="NO_SECOND_NATIVE_CONTROL_WHILE_FIRST_SETTLES"})
        return true
    end
    self.attempted[vehicle]=true
    return beginEpisode(self,job,vehicle)
end
function Runtime:update(dt)
    local s=self.active or self.pending
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
            publish("WARNING","COMPLETION_SETTLEMENT_QUEUED_REJECTED",{
                rootNode=tostring(item.vehicle.rootNode),
                reason=claim or "GIANTS_JOB_SUPERSEDED"})
            return
        end
        beginEpisode(self,item.job,item.vehicle)
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
        if s.elapsedMs>TOTAL_DEADLINE_MS then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                "FINITE_PLANNING_LEASE_EXPIRED")
            return
        end
        local planner=s.kind=="EXTENDED"
            and OuttaMyWay.ExtendedInfieldApproach
            or OuttaMyWay.CompletionSettlementRoute
        local phase,route,reason=planner.advancePlan(
            s.plan,PLAN_UNITS_PER_UPDATE)
        if phase=="PENDING" then return end
        if phase~="DONE" or route==nil then
            if s.kind=="EXTENDED" and type(s.plan.sceneEvidence)=="table" then
                -- One bounded evidence line on a failed scene admission,
                -- not a per-frame or per-candidate diagnostic flood.
                local scene=s.plan.sceneEvidence
                publish("WARNING","COMPLETION_SETTLEMENT_SCENE_ADMISSION_FAILED",{
                    rootNode=tostring(s.vehicle.rootNode),
                    reason=tostring(reason),
                    registry=scene.registry or "unknown",
                    examined=scene.scanned or 0,
                    relevantWorkers=scene.observedWorkers or 0,
                    outsideField=scene.outsideField or 0,
                    nonAiRoots=scene.nonAiRoots or 0,
                    failureRoot=scene.failureRoot or "none"})
            end
            if s.kind=="LOCAL_INITIAL"
                and reason=="NO_POSE_REACHABLE_PARKING_REGION" then
                local extended,why=OuttaMyWay.ExtendedInfieldApproach.beginPlan(
                    s.vehicle)
                if extended~=nil then
                    s.plan=extended
                    s.kind="EXTENDED"
                    publish("INFO","COMPLETION_SETTLEMENT_EXTENDED_PLANNING",{
                        rootNode=tostring(s.vehicle.rootNode),
                        reason="LOCAL_ENTRY_UNREACHABLE",
                        note="NO_DRIVE_WHILE_PLANNING"})
                    return
                end
                reason=why or reason
            end
            if deferStoppedEntry(self,s,reason) then return end
            self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                reason or "POSE_CONDITIONED_ROUTE_UNAVAILABLE")
            return
        end
        -- Reobserve ALL physical assemblies: completed workers are not
        -- released parking space merely because their AI job stopped.
        local spaceClear,spaceWhy=OuttaMyWay.SettlementPhysicalOccupancy.routeClear(
            s.vehicle,route)
        if not spaceClear then
            if deferStoppedEntry(self,s,spaceWhy) then return end
            self:finish("COMPLETION_SETTLEMENT_NOT_ADMITTED",
                spaceWhy or "PARKING_SPACE_NO_LONGER_AVAILABLE")
            return
        end
        self.pending=nil
        self.active={vehicle=s.vehicle,job=s.job,route=route,legIndex=1,
            totalElapsedMs=s.elapsedMs,legElapsedMs=0,telemetryElapsedMs=0,
            phase="ADMITTED",driveArmed=false}
        publish("INFO","COMPLETION_SETTLEMENT_ADMITTED",{
            rootNode=tostring(s.vehicle.rootNode),
            planningUpdates=s.plan.advances,
            weightedGeometryChecks=s.plan.spent,
            stage=s.kind or "LOCAL_INITIAL",
            sceneRegistry=type(s.plan.sceneEvidence)=="table"
                and s.plan.sceneEvidence.registry or "not-required",
            observedActiveWorkers=type(s.plan.sceneEvidence)=="table"
                and s.plan.sceneEvidence.observedWorkers or "not-required",
            field=route.field,edge=route.edge,
            memberCount=route.memberCount,
            plannedMethod=route.method,reverseM=route.reverseM,
            guidancePoints=#route.legs,
            estimatedTravelM=route.estimatedTravelM,
            guideRadiusM=route.guideRadiusM,
            note="TEST_NOMINAL_POSE_PATH_NOT_PHYSICAL_CLEARANCE"})
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
    if s.route.mode=="EXTENDED_INFIELD" then
        s.peerCheckMs=(s.peerCheckMs or 250)+dt
        if s.peerCheckMs>=250 then
            s.peerCheckMs=0
            local valid,why=OuttaMyWay.ExtendedInfieldApproach.guard(
                s.vehicle,s.route,s.legIndex)
            if not valid then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    why or "EXTENDED_APPROACH_UNSUPPORTED")
                return
            end
        end
    elseif type(OuttaMyWay.CompletionSettlementRoute.guard)=="function" then
        local valid,why=OuttaMyWay.CompletionSettlementRoute.guard(
            s.vehicle,s.route,s.legIndex)
        if not valid then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                why or "SETTLEMENT_PATH_ENVELOPE_LOST")
            return
        end
        s.peerCheckMs=(s.peerCheckMs or 250)+dt
        if s.peerCheckMs>=250 then
            s.peerCheckMs=0
            local clear,reason=OuttaMyWay.SettlementPhysicalOccupancy.nextClear(
                s.vehicle,s.route,s.legIndex)
            if not clear then
                self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                    reason or "LOCAL_PARKING_SPACE_OCCUPIED")
                return
            end
        end
    end
    local status
    if s.phase=="STOPPING" then
        status=self.drive:settlementStopStatus(s.vehicle,dt)
    else
        status=self.drive:movementStatus(s.vehicle,dt)
    end
    if status==nil or status.isFailed then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            status and status.reason or "DRIVE_STATUS_UNAVAILABLE")
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
        publish("INFO","COMPLETION_SETTLEMENT_STOPPING",{
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
        publish("INFO","COMPLETION_SETTLEMENT_LEG_FINISHED",{
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
    self.waiting={}
    self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
        reason or "CONTROL_REVOKED")
end
function Runtime:loadMap()
    self.pending=nil
    self.active=nil
    self.waiting={}
    self.attempted=setmetatable({},{__mode="k"})
    self.deferred=setmetatable({},{__mode="k"})
end
function Runtime:deleteMap()
    local s=self.active
    if s~=nil and s.driveArmed then
        self.drive:discardOnMapDelete(s.vehicle)
    end
    self.active=nil
    self.pending=nil
    self.waiting={}
    self.attempted=setmetatable({},{__mode="k"})
    self.deferred=setmetatable({},{__mode="k"})
end
return Runtime
