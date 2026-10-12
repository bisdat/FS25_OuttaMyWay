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
-- Target-horizon braking model, not a fixed 8 km/h travel limit.
-- TEST assumption: 1.5 m/s^2 controllable deceleration, GIANTS to validate.
local GUIDANCE_DECEL_MPS2=1.5
local function guidanceSpeed(distance)
    return math.sqrt(2*GUIDANCE_DECEL_MPS2*
        math.max(2.5,math.min(distance,12)))*3.6
end
local function objectiveFor(leg,currentX,currentZ)
    local distance=math.sqrt((leg.point.x-currentX)^2+
        (leg.point.z-currentZ)^2)
    return {moveForwards=leg.moveForwards,
        maximumSpeedKmh=guidanceSpeed(distance),
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
        active=nil,attempted=setmetatable({},{__mode="k"})},Runtime)
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
    local state=self.active
    if state==nil then return end
    self.active=nil
    if state.driveArmed then
        local stopped,why=self.drive:cancelMovement(state.vehicle)
        if not stopped then
            publish("WARNING","COMPLETION_SETTLEMENT_NEUTRALIZE_UNCONFIRMED",{
                rootNode=tostring(state.vehicle.rootNode),reason=tostring(why)})
        end
    end
    publish(code=="COMPLETION_SETTLEMENT_FINISHED" and "INFO" or "WARNING",
        code,{rootNode=tostring(state.vehicle.rootNode),
            leg=state.legIndex,reason=tostring(reason)})
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
    local objective=objectiveFor(leg,x,z)
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
function Runtime:onNativeCompletion(job,vehicle,transitAccepted)
    if not self:isAdmitted() or transitAccepted~=true
        or type(vehicle)~="table" or self.attempted[vehicle]
        or self.active~=nil or pairedControlActive()
        or superseded(vehicle) then
        return false
    end
    local claim=playerClaim(vehicle)
    if claim~=nil then
        publish("WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),reason=claim})
        return false
    end
    self.attempted[vehicle]=true
    local planned,route,reason=pcall(
        OuttaMyWay.CompletionSettlementRoute.plan,vehicle)
    if not planned then
        route=nil
        reason="SETTLEMENT_ROUTE_PLAN_EXCEPTION"
    end
    if route==nil then
        publish("WARNING","COMPLETION_SETTLEMENT_NOT_ADMITTED",{
            rootNode=tostring(vehicle.rootNode),reason=tostring(reason)})
        return false
    end
    self.active={vehicle=vehicle,job=job,route=route,legIndex=1,
        totalElapsedMs=0,legElapsedMs=0,telemetryElapsedMs=0,
        phase="ADMITTED",driveArmed=false}
    publish("INFO","COMPLETION_SETTLEMENT_ADMITTED",{
        rootNode=tostring(vehicle.rootNode),field=route.field,edge=route.edge,
        memberCount=route.memberCount,
        plannedMethod=route.method,
        reverseM=route.reverseM,
        guidancePoints=#route.legs,
        estimatedTravelM=route.estimatedTravelM,
        guideRadiusM=route.guideRadiusM,
        note="TEST_NOMINAL_POSE_PATH_NOT_PHYSICAL_CLEARANCE"})
    self:startLeg()
    return self.active~=nil
end
function Runtime:update(dt)
    local s=self.active
    if s==nil then return end
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
    s.totalElapsedMs=s.totalElapsedMs+dt
    s.legElapsedMs=s.legElapsedMs+dt
    s.telemetryElapsedMs=s.telemetryElapsedMs+dt
    if s.totalElapsedMs>TOTAL_DEADLINE_MS
        or s.legElapsedMs>LEG_DEADLINE_MS then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            "FINITE_CONTROL_LEASE_EXPIRED")
        return
    end
    if type(OuttaMyWay.CompletionSettlementRoute.guard)=="function" then
        local valid,why=OuttaMyWay.CompletionSettlementRoute.guard(
            s.vehicle,s.route)
        if not valid then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                why or "SETTLEMENT_PATH_ENVELOPE_LOST")
            return
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
            local objective=objectiveFor(nextLeg,x,z)
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
    self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
        reason or "CONTROL_REVOKED")
end
function Runtime:loadMap()
    self.active=nil
    self.attempted=setmetatable({},{__mode="k"})
end
function Runtime:deleteMap()
    local s=self.active
    if s~=nil and s.driveArmed then
        self.drive:discardOnMapDelete(s.vehicle)
    end
    self.active=nil
    self.attempted=setmetatable({},{__mode="k"})
end
return Runtime
