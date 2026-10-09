-- Translation-only GIANTS AI Hold below the accepted Hold & Relocate contract.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Does not deny GIANTS field-worker continuation permission, create a commitment,
-- or infer that the vehicle has physically stopped.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeTranslationHoldMechanism={}
local Mechanism=OuttaMyWay.NativeTranslationHoldMechanism
Mechanism.__index=Mechanism

local function weakKeys()
    return setmetatable({},{__mode="k"})
end

local function isCurrentPlayerControl(vehicle)
    if type(vehicle.getIsControlled)=="function" then
        local ok,controlled=pcall(vehicle.getIsControlled,vehicle)
        if not ok then return nil,"PLAYER_CONTROL_EVIDENCE_UNAVAILABLE" end
        if controlled==true then return true end
    end
    local mission=g_currentMission
    if type(mission)=="table" and mission.controlledVehicle==vehicle then return true end
    return false
end

local function isNativeJobCurrent(vehicle)
    if type(vehicle.getJob)~="function" then return false end
    local ok,job=pcall(vehicle.getJob,vehicle)
    return ok and job~=nil
end

function Mechanism.new()
    return setmetatable({
        holds=weakKeys(),heldCount=0,
        originalDrive=nil,wrapper=nil,isInstalled=false
    },Mechanism)
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
        local isControlled,controlReason=isCurrentPlayerControl(vehicle)
        if isControlled~=false or not isNativeJobCurrent(vehicle)
            or g_server==nil then
            -- Do not apply an OMW command after player takeover or native job
            -- turnover. The deliberate relinquishment is recorded, not silently
            -- mistaken for an expiry of the coordinator's timer.
            mechanism.holds[vehicle]=nil
            mechanism.heldCount=math.max(0,mechanism.heldCount-1)
            state.isRelinquished=true
            state.relinquishReason=controlReason or
                (isControlled and "PLAYER_TAKEOVER" or "NATIVE_JOB_UNAVAILABLE")
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
    local isControlled,reason=isCurrentPlayerControl(vehicle)
    if isControlled~=false then return false,reason or "PLAYER_CONTROL_ACTIVE" end
    if not isNativeJobCurrent(vehicle) then return false,"NATIVE_JOB_UNAVAILABLE" end
    local installed,why=self:install()
    if not installed then return false,why end
    self.holds[vehicle]={
        purpose=purpose,interceptCount=0,
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
    self.holds[vehicle]=nil
    self.heldCount=math.max(0,self.heldCount-1)
    local nativeRestored=false
    if self.heldCount==0 and self.isInstalled
        and type(AIVehicleUtil)=="table"
        and AIVehicleUtil.driveToPoint==self.wrapper then
        AIVehicleUtil.driveToPoint=self.originalDrive
        self.isInstalled=false
        self.wrapper=nil
        self.originalDrive=nil
        nativeRestored=true
    end
    -- A later wrapper may have chained this one. In that case the released
    -- inner wrapper is behaviourally transparent, and we do not overwrite
    -- another mod's current native drive function.
    return true,{wasHeld=true,isRestrictionRemoved=true,
        isNativeFunctionRestored=nativeRestored,
        interceptionCount=state.interceptCount}
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
