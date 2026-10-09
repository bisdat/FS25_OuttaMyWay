-- Scoped 1 km/h GIANTS-native egress regulation. Keeps GIANTS trajectory,
-- steering, acceleration and direction unchanged; only caps requested speed.
-- Independent of the relocated worker's later zero-speed Hold.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeSpeedRegulationMechanism={}
local Mechanism=OuttaMyWay.NativeSpeedRegulationMechanism
Mechanism.__index=Mechanism
local EGRESS_SPEED_KMH=1
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function rootXZ(vehicle)
    if vehicle.rootNode==nil or type(getWorldTranslation)~="function" then return nil,nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil,nil end
    return x,z
end
local function nativeJob(vehicle)
    if type(vehicle.getJob)~="function" then return nil end
    local ok,job=pcall(vehicle.getJob,vehicle)
    return ok and job or nil
end
function Mechanism.new()
    return setmetatable({leases=setmetatable({},{__mode="k"}),
        count=0,original=nil,wrapper=nil},Mechanism)
end
function Mechanism:refreshInstallation()
    if self.wrapper==nil or self.count>0 then return end
    if type(AIVehicleUtil)=="table" and AIVehicleUtil.driveToPoint==self.wrapper then
        AIVehicleUtil.driveToPoint=self.original
        self.original=nil
        self.wrapper=nil
    end
end
function Mechanism:install()
    if self.wrapper~=nil then
        if type(AIVehicleUtil)~="table" or
            (AIVehicleUtil.driveToPoint~=self.wrapper and self.count==0) then
            return false,"REGULATION_DRIVE_CHAIN_UNAVAILABLE"
        end
        return true
    end
    if type(AIVehicleUtil)~="table" or type(AIVehicleUtil.driveToPoint)~="function" then
        return false,"NATIVE_DRIVE_UNAVAILABLE"
    end
    local prior=AIVehicleUtil.driveToPoint
    local mechanism=self
    local function wrapper(vehicle,dt,accel,allowed,forwards,lx,lz,speed,doNotSteer)
        local lease=mechanism.leases[vehicle]
        if lease==nil then
            return prior(vehicle,dt,accel,allowed,forwards,lx,lz,speed,doNotSteer)
        end
        if g_server==nil or nativeJob(vehicle)~=lease.job then
            -- A superseded native job cannot inherit temporary Regulation.
            mechanism.leases[vehicle]=nil
            mechanism.count=math.max(0,mechanism.count-1)
            mechanism:refreshInstallation()
            return prior(vehicle,dt,accel,allowed,forwards,lx,lz,speed,doNotSteer)
        end
        lease.interceptCount=lease.interceptCount+1
        lease.lastNativeSpeedKmh=speed
        local capped=finite(speed) and math.min(math.max(0,speed),EGRESS_SPEED_KMH)
            or EGRESS_SPEED_KMH
        return prior(vehicle,dt,accel,allowed,forwards,lx,lz,capped,doNotSteer)
    end
    self.original=prior
    self.wrapper=wrapper
    AIVehicleUtil.driveToPoint=wrapper
    return true
end
function Mechanism:regulate(vehicle,purpose)
    if g_server==nil then return false,"SERVER_REQUIRED" end
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or purpose~="EGRESS" then return false,"REGULATION_REQUEST_INVALID" end
    if self.leases[vehicle]~=nil then return false,"REGULATION_ALREADY_ACTIVE" end
    local job=nativeJob(vehicle)
    if job==nil then return false,"NATIVE_JOB_UNAVAILABLE" end
    local ok,reason=self:install()
    if not ok then return false,reason end
    local x,z=rootXZ(vehicle)
    self.leases[vehicle]={job=job,interceptCount=0,initialX=x,initialZ=z}
    self.count=self.count+1
    return true,{isRegulationArmed=true,maxSpeedKmh=EGRESS_SPEED_KMH}
end
function Mechanism:releaseRegulation(vehicle,purpose)
    if type(vehicle)~="table" then return false,"VEHICLE_UNAVAILABLE" end
    local lease=self.leases[vehicle]
    if lease==nil then
        self:refreshInstallation()
        return true,{wasRegulated=false,isRestrictionRemoved=true}
    end
    if purpose~="EGRESS" then return false,"REGULATION_PURPOSE_MISMATCH" end
    local x,z=rootXZ(vehicle)
    local movement=nil
    if x~=nil and lease.initialX~=nil then
        movement=math.sqrt((x-lease.initialX)^2+(z-lease.initialZ)^2)
    end
    self.leases[vehicle]=nil
    self.count=math.max(0,self.count-1)
    self:refreshInstallation()
    return true,{wasRegulated=true,isRestrictionRemoved=true,
        interceptionCount=lease.interceptCount,physicalDisplacementM=movement,
        regulatedSpeedKmh=EGRESS_SPEED_KMH,
        lastNativeSpeedKmh=lease.lastNativeSpeedKmh}
end
