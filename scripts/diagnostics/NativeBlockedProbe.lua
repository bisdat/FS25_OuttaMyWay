--- Read-only native blocked-state correlation experiment. No worker authority or actuation.
OuttaMyWay.NativeBlockedProbe={}
local Probe=OuttaMyWay.NativeBlockedProbe
Probe.__index=Probe
local publication=OuttaMyWay.LogPublication.origin("NATIVE_BLOCKED_PROBE")
local INTERVAL_MS=500

local function label(v)
    if v==true then return "true" end
    if v==false then return "false" end
    return "unavailable"
end

local function activeWorkers()
    local mission=g_currentMission
    local registry=mission and mission.aiSystem and mission.aiSystem.activeJobVehicles
    if type(registry)~="table" then return nil end
    local result,seen={},{}
    local function add(vehicle)
        if type(vehicle)~="table" or type(vehicle.spec_aiFieldWorker)~="table"
            or vehicle.spec_aiFieldWorker.isActive~=true or seen[vehicle] then return end
        seen[vehicle]=true
        result[#result+1]=vehicle
    end
    for key,value in pairs(registry) do
        add(key); add(value)
        if type(value)=="table" then
            add(value.vehicle); add(value.object); add(value.rootVehicle); add(value[1])
        end
    end
    return result
end

local function findStrategy(vehicle)
    for _,source in ipairs({vehicle.spec_aiFieldWorker or {},vehicle.spec_aiVehicle or {},vehicle}) do
        if source~=nil and type(source.driveStrategies)=="table" then
            for _,strategy in pairs(source.driveStrategies) do
                if type(strategy)=="table" then
                    local name=strategy.className or
                        (type(strategy.class)=="table" and strategy.class.className)
                    if strategy.aiFieldCourse~=nil
                        or (type(name)=="string" and string.find(name,"FieldCourse",1,true)~=nil) then
                        return strategy
                    end
                end
            end
        end
    end
    return nil
end

local function reading(vehicle)
    local s=findStrategy(vehicle)
    local job=vehicle.spec_aiJobVehicle and vehicle.spec_aiJobVehicle.job
        or vehicle.spec_aiFieldWorker.fieldJob
    return {
        job=job,field=label(vehicle.spec_aiFieldWorker.isBlocked),
        course=label(s and s.isBlocked),static=label(s and s.hasStaticCollision),
        timer=s and s.hasStaticCollisionTimer or nil
    }
end

local function publish(vehicle,r,code)
    publication:publish("DEBUG","INFO",code,function()
        local name="unavailable"
        if type(vehicle.getName)=="function" then
            local ok,n=pcall(vehicle.getName,vehicle)
            if ok and type(n)=="string" then name=n end
        end
        return {vehicleNode=tostring(vehicle.rootNode or "unavailable"),name=name,
            jobRef=r.job and tostring(r.job) or "unavailable",
            fieldBlocked=r.field,courseBlocked=r.course,staticCollision=r.static,
            staticTimerMs=tonumber(r.timer) or "unavailable",authority="NATIVE_EVIDENCE_ONLY"}
    end)
end

function Probe.new(config,diagnostic)
    return setmetatable({config=config,diagnostic=diagnostic,remaining=0,states={},warned=false},Probe)
end
function Probe:loadMap()
    self.remaining=0;self.states={};self.warned=false
end
function Probe:deleteMap() self:loadMap() end
function Probe:enabled()
    local c=self.config
    return c~=nil and c:isResolved()==true and c:isEnabled()==true
        and (c:isDebugEnabled()==true
            or (self.diagnostic~=nil and self.diagnostic:publicationPolicy()=="DIAGNOSTIC"))
end
function Probe:update(dt)
    if not self:enabled() then
        self.states={};self.remaining=0
        return
    end
    self.remaining=self.remaining-(tonumber(dt) or 0)
    if self.remaining>0 then return end
    self.remaining=INTERVAL_MS
    local workers=activeWorkers()
    if workers==nil then
        if not self.warned then
            publication:publish("DEBUG","WARNING","NATIVE_BLOCKED_SOURCE_UNAVAILABLE",function()
                return {source="mission.aiSystem.activeJobVehicles"}
            end)
            self.warned=true
        end
        self.states={}
        return
    end
    self.warned=false
    local seen={}
    for _,vehicle in ipairs(workers) do
        seen[vehicle]=true
        local now=reading(vehicle)
        local last=self.states[vehicle]
        if last==nil or last.job~=now.job or last.field~=now.field
            or last.course~=now.course or last.static~=now.static then
            publish(vehicle,now,"NATIVE_BLOCKED_STATE_SAMPLE")
            now.elapsed=0
        else
            now.elapsed=last.elapsed or 0
            if now.field=="true" or now.course=="true" or now.static=="true" then
                now.elapsed=now.elapsed+INTERVAL_MS
                if now.elapsed>=5000 then
                    publish(vehicle,now,"NATIVE_BLOCKED_STILL_PRESENT")
                    now.elapsed=0
                end
            else
                now.elapsed=0
            end
        end
        self.states[vehicle]=now
    end
    -- Disappearance of a job is not proof of an 'unblocked' transition.
    for vehicle in pairs(self.states) do
        if not seen[vehicle] then self.states[vehicle]=nil end
    end
end
