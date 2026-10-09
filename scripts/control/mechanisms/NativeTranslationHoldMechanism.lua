-- Translation-only GIANTS AI Hold below the accepted Hold & Relocate contract.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Does not deny GIANTS field-worker continuation permission, create a commitment,
-- or infer that the vehicle has physically stopped.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeTranslationHoldMechanism={}
local Mechanism=OuttaMyWay.NativeTranslationHoldMechanism
Mechanism.__index=Mechanism

local function rootXZ(vehicle)
    if vehicle.rootNode==nil or type(getWorldTranslation)~="function" then
        return nil,nil
    end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or type(x)~="number" or type(z)~="number"
        or x~=x or z~=z then return nil,nil end
    return x,z
end

local function weakKeys()
    return setmetatable({},{__mode="k"})
end

-- The GIANTS job object is a transient runtime reference, not stable semantic
-- Job Episode identity. It is sufficient to detect replacement while Held.
local function currentNativeJob(vehicle)
    if type(vehicle.getJob)~="function" then return nil,"NATIVE_JOB_API_UNAVAILABLE" end
    local ok,job=pcall(vehicle.getJob,vehicle)
    if not ok or job==nil then return nil,"NATIVE_JOB_UNAVAILABLE" end
    return job
end

function Mechanism.new()
    return setmetatable({
        holds=weakKeys(),heldCount=0,
        originalDrive=nil,wrapper=nil,isInstalled=false
    },Mechanism)
end

-- The wrapper can be restored only while it is still the visible GIANTS entry
-- point. With an outer wrapper installed by another mod, releasing this lease
-- leaves a transparent inner wrapper rather than clobbering the outer one.
local function withdrawHold(mechanism,vehicle)
    local previous=mechanism.holds[vehicle]
    if previous~=nil then
        mechanism.holds[vehicle]=nil
        mechanism.heldCount=math.max(0,mechanism.heldCount-1)
    end
    local nativeRestored=false
    if mechanism.heldCount==0 and mechanism.isInstalled
        and type(AIVehicleUtil)=="table"
        and AIVehicleUtil.driveToPoint==mechanism.wrapper then
        AIVehicleUtil.driveToPoint=mechanism.originalDrive
        mechanism.isInstalled=false
        mechanism.wrapper=nil
        mechanism.originalDrive=nil
        nativeRestored=true
    end
    return previous,nativeRestored
end

-- Interpose only on the native translation command. The GIANTS field-worker
-- permission gate is deliberately untouched: it also governs configuration
-- progression, so denying it is not equivalent to stopping translation.
function Mechanism:install()
    if self.isInstalled then
        if type(AIVehicleUtil)~="table"
            or type(AIVehicleUtil.driveToPoint)~="function" then
            return false,"NATIVE_DRIVE_UNAVAILABLE"
        end
        if AIVehicleUtil.driveToPoint~=self.wrapper then
            return false,"NATIVE_DRIVE_WRAPPER_UNVERIFIED"
        end
        return true
    end
    if type(AIVehicleUtil)~="table"
        or type(AIVehicleUtil.driveToPoint)~="function" then
        return false,"NATIVE_DRIVE_UNAVAILABLE"
    end
    local original=AIVehicleUtil.driveToPoint
    local mechanism=self
    local function wrapper(vehicle,dt,acceleration,allowedToDrive,moveForwards,
        localTargetX,localTargetZ,maxSpeed,doNotSteer)
        local state=mechanism.holds[vehicle]
        if state==nil then
            return original(vehicle,dt,acceleration,allowedToDrive,
                moveForwards,localTargetX,localTargetZ,maxSpeed,doNotSteer)
        end
        local currentJob,jobReason=currentNativeJob(vehicle)
        if currentJob~=state.nativeJobReference or g_server==nil then
            -- GIANTS job turnover or server loss revokes this Hold.
            state.isRelinquished=true
            state.relinquishReason=(currentJob~=state.nativeJobReference
                    and (jobReason or "NATIVE_JOB_REPLACED"))
                or "SERVER_UNAVAILABLE"
            withdrawHold(mechanism,vehicle)
            return original(vehicle,dt,acceleration,allowedToDrive,
                moveForwards,localTargetX,localTargetZ,maxSpeed,doNotSteer)
        end
        state.interceptCount=state.interceptCount+1
        state.lastNativeAllowedToDrive=allowedToDrive==true
        -- Retain GIANTS' heading, local target, direction, and optional ninth
        -- input. Only propulsion permission and speed are suppressed.
        return original(vehicle,dt,0,false,moveForwards,
            localTargetX,localTargetZ,0,doNotSteer)
    end
    self.originalDrive=original
    self.wrapper=wrapper
    AIVehicleUtil.driveToPoint=wrapper
    self.isInstalled=true
    return true
end

-- Only a separately authorised caller may acquire Hold. True means its
-- translation gate is armed; it is not evidence of stationary physics.
function Mechanism:hold(vehicle,purpose)
    if g_server==nil then return false,"SERVER_REQUIRED" end
    if type(vehicle)~="table" then return false,"VEHICLE_UNAVAILABLE" end
    if type(purpose)~="string" or purpose=="" then
        return false,"HOLD_PURPOSE_REQUIRED"
    end
    if self.holds[vehicle]~=nil then return false,"HOLD_ALREADY_ACTIVE" end
    local nativeJob,jobReason=currentNativeJob(vehicle)
    if nativeJob==nil then return false,jobReason end
    local installed,why=self:install()
    if not installed then return false,why end
    local initialX,initialZ=rootXZ(vehicle)
    self.holds[vehicle]={
        purpose=purpose,interceptCount=0,nativeJobReference=nativeJob,
        initialX=initialX,initialZ=initialZ,
        isRelinquished=false,lastNativeAllowedToDrive=nil
    }
    self.heldCount=self.heldCount+1
    return true,{isGateArmed=true,isVehicleStoppedConfirmed=false}
end

-- Release is idempotent to support cleanup after an external call returned
-- uncertain. It removes the owned propulsion restriction without waiting for
-- pair clearance, blockage state, worker separation or another native drive call.
function Mechanism:releaseHold(vehicle,purpose)
    if type(vehicle)~="table" then return false,"VEHICLE_UNAVAILABLE" end
    local state=self.holds[vehicle]
    if state==nil then return true,{wasHeld=false,isRestrictionRemoved=true} end
    if purpose~=state.purpose then return false,"HOLD_PURPOSE_MISMATCH" end
    local endingX,endingZ=rootXZ(vehicle)
    local displacementM=nil
    if state.initialX~=nil and endingX~=nil then
        displacementM=math.sqrt((endingX-state.initialX)^2
            +(endingZ-state.initialZ)^2)
    end
    local _,nativeRestored=withdrawHold(self,vehicle)
    -- A later wrapper may have chained this one. In that case the released
    -- inner wrapper is behaviourally transparent, and we do not overwrite
    -- another mod's current native drive function.
    return true,{wasHeld=true,isRestrictionRemoved=true,
        isNativeFunctionRestored=nativeRestored,
        interceptionCount=state.interceptCount,
        physicalDisplacementM=displacementM}
end

function Mechanism:getHoldEvidence(vehicle)
    local state=type(vehicle)=="table" and self.holds[vehicle] or nil
    if state==nil then
        return {isHeld=false,isVehicleStoppedConfirmed=false}
    end
    return {isHeld=true,purpose=state.purpose,
        interceptionCount=state.interceptCount,
        isVehicleStoppedConfirmed=false,
        lastNativeAllowedToDrive=state.lastNativeAllowedToDrive}
end

function Mechanism:isHolding(vehicle)
    return type(vehicle)=="table" and self.holds[vehicle]~=nil
end
