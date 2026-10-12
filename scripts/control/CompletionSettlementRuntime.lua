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
local SPEED_KMH=8
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
    -- Same proven GIANTS driveToPoint mechanism, independent lease.
    -- This point-target contract is not BWR cross-track settlement.
    local objective={moveForwards=true,maximumSpeedKmh=SPEED_KMH,
        targetX=leg.point.x,targetZ=leg.point.z,
        returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
    local started,evidence=self.drive:startMovement(s.vehicle,objective)
    if not started then
        -- Native setters can partially apply before reporting failure.
        s.driveArmed=self.drive.active~=nil
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",evidence)
        return
    end
    s.driveArmed=true
    s.legElapsedMs=0
    publish("INFO","COMPLETION_SETTLEMENT_LEG_STARTED",{
        rootNode=tostring(s.vehicle.rootNode),leg=leg.name,
        ordinal=s.legIndex,targetX=string.format("%.2f",leg.point.x),
        targetZ=string.format("%.2f",leg.point.z),
        remainingM=string.format("%.2f",distance),
        requestedSpeedKmh=SPEED_KMH})
end
function Runtime:onNativeCompletion(job,vehicle,transitAccepted)
    if not self:isAdmitted() or transitAccepted~=true
        or type(vehicle)~="table" or self.attempted[vehicle]
        or self.active~=nil or pairedControlActive() or superseded(vehicle) then
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
        totalElapsedMs=0,legElapsedMs=0,driveArmed=false}
    publish("INFO","COMPLETION_SETTLEMENT_ADMITTED",{
        rootNode=tostring(vehicle.rootNode),field=route.field,edge=route.edge,
        memberCount=route.memberCount,
        assumedPolygonRunM=string.format("%.2f",route.lengthM),
        note="EXPLICIT_TEST_ROUTE_ASSUMED_DRIVABLE"})
    self:startLeg()
    return self.active~=nil
end
function Runtime:update(dt)
    local s=self.active
    if s==nil then return end
    if not self:isAdmitted() or superseded(s.vehicle)
        or pairedControlActive() then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            "CONFIGURATION_JOB_OR_OTHER_CONTROL_SUPERSEDED")
        return
    end
    if type(dt)~="number" or dt<=0 or dt>5000 then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            "UPDATE_CLOCK_UNAVAILABLE")
        return
    end
    s.totalElapsedMs=s.totalElapsedMs+dt
    s.legElapsedMs=s.legElapsedMs+dt
    if s.totalElapsedMs>TOTAL_DEADLINE_MS
        or s.legElapsedMs>LEG_DEADLINE_MS then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            "FINITE_CONTROL_LEASE_EXPIRED")
        return
    end
    local status=self.drive:movementStatus(s.vehicle,dt)
    if status==nil or status.isFailed then
        self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
            status and status.reason or "DRIVE_STATUS_UNAVAILABLE")
        return
    end
    if status.isComplete then
        local stopped,why=self.drive:stopMovement(s.vehicle)
        if not stopped then
            self:finish("COMPLETION_SETTLEMENT_INTERRUPTED",
                why or "LEG_STOP_UNCONFIRMED")
            return
        end
        s.driveArmed=false
        publish("INFO","COMPLETION_SETTLEMENT_LEG_FINISHED",{
            rootNode=tostring(s.vehicle.rootNode),
            leg=s.route.legs[s.legIndex].name,ordinal=s.legIndex})
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
