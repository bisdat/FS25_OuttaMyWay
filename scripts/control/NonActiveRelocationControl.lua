-- Bounded physical movement of a positively identified non-active obstruction.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`
-- The active beneficiary owns the field; the blocker has no GIANTS AI job to restart.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NonActiveRelocationControl={}
local Control=OuttaMyWay.NonActiveRelocationControl
Control.__index=Control
local MAX_INWARD_M=60 -- restored archive calibration, not a parking quota

local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end

local function activeStrategy(worker)
    local strategies=worker and worker.spec_aiFieldWorker
        and worker.spec_aiFieldWorker.driveStrategies
    if type(strategies)~="table" then return nil end
    for _,strategy in pairs(strategies) do
        if type(strategy)=="table" and strategy.aiFieldCourse~=nil
            and type(strategy.isBlocked)=="boolean" then return strategy end
    end
    return nil
end

function Control.new()
    return setmetatable({actuator=OuttaMyWay.NonJobActuationMechanism.new(),
        active=nil,lastOutcome=nil},Control)
end

function Control:isActive()
    return self.active~=nil
end

function Control:finish(outcome)
    local state=self.active
    if state==nil then return true end
    local vehicle=state.blocker
    local m=self.actuator
    local claimed=m:isPlayerControlled(vehicle) or m:isSourceReactivated(vehicle)
    local neutralOk=true
    if not claimed and state.drove then
        neutralOk=m:neutralize(vehicle,state.lastDt or 0)
    end
    local propOk=true
    if state.propulsion~=nil then
        propOk=m:releasePropulsionContext(vehicle,state.propulsion)
    end
    local activityOk=true
    if state.activity~=nil and not claimed then
        activityOk=m:releaseVehicleActivityContext(vehicle,state.activity)
    end
    self.lastOutcome={
        status=outcome,blockerRootId=tostring(vehicle.rootNode),
        beneficiaryRootId=tostring(state.beneficiary.rootNode),
        fieldIdentitySource=state.fieldIdentitySource,
        progressM=state.progressM or 0,
        physicalCleanupConfirmed=neutralOk==true and propOk==true
            and activityOk==true,
        continuationConfirmed=false
    }
    self.active=nil
    return self.lastOutcome.physicalCleanupConfirmed
end

function Control:begin(evidence)
    if self.active~=nil or type(evidence)~="table"
        or evidence.positive~=true
        or not OuttaMyWay.NonActiveObstructionAssessment.isStillCurrent(evidence)
        then return false,"CURRENT_CAUSAL_EVIDENCE_UNAVAILABLE" end
    local blocker,beneficiary=evidence.blocker,evidence.beneficiary
    local strategy=activeStrategy(beneficiary)
    if strategy==nil or strategy.isBlocked~=true then
        return false,"BENEFICIARY_NATIVE_BLOCKAGE_CHANGED"
    end
    local _,fieldCentre,source=OuttaMyWay.ProjectedEgressRegion.ownCourseField(strategy)
    if type(fieldCentre)~="table" or not finite(fieldCentre.x)
        or not finite(fieldCentre.z) then
        return false,"BENEFICIARY_OWN_FIELD_CENTRE_UNAVAILABLE"
    end
    local m=self.actuator
    local start=m:position(blocker)
    if start==nil then return false,"NON_ACTIVE_BLOCKER_POSE_UNAVAILABLE" end
    local dx,dz=fieldCentre.x-start.x,fieldCentre.z-start.z
    local distance=math.sqrt(dx*dx+dz*dz)
    if distance<=0.01 then return false,"NO_MEANINGFUL_INWARD_PROGRESS" end
    local amount=math.min(distance,MAX_INWARD_M)
    local activityOk,activity=m:acquireVehicleActivityContext(blocker)
    if not activityOk then return false,activity end
    local propulsionOk,propulsion=m:acquirePropulsionContext(blocker)
    if not propulsionOk then
        m:releaseVehicleActivityContext(blocker,activity)
        return false,propulsion
    end
    local speed,speedReason=m:maximumForwardSpeedKmh(blocker)
    if speed==nil then
        m:releasePropulsionContext(blocker,propulsion)
        m:releaseVehicleActivityContext(blocker,activity)
        return false,speedReason
    end
    self.lastOutcome=nil
    self.active={
        beneficiary=beneficiary,blocker=blocker,
        evidence=evidence,sourceStrategy=strategy,
        activity=activity,propulsion=propulsion,
        originX=start.x,originZ=start.z,
        directionX=dx/distance,directionZ=dz/distance,
        targetProgressM=amount,speedKmh=speed,
        fieldIdentitySource=source,progressM=0,drove=false
    }
    return true,{targetProgressM=amount,fieldIdentitySource=source,
        speedKmh=speed}
end

function Control:advance(dt)
    local s=self.active
    if s==nil then return end
    s.lastDt=dt
    local m=self.actuator
    if m:isPlayerControlled(s.blocker) or m:isSourceReactivated(s.blocker) then
        self:finish("HIGHER_AUTHORITY_SUPERSEDED")
        return
    end
    if not OuttaMyWay.NonActiveObstructionAssessment.isStillCurrent(s.evidence)
        or activeStrategy(s.beneficiary)~=s.sourceStrategy then
        self:finish("BENEFICIARY_OR_BLOCKER_CHANGED")
        return
    end
    local status=m:propulsionReadiness(s.blocker,s.propulsion)
    if status=="PENDING" then return end
    if status~="READY" then
        self:finish("PROPULSION_NOT_READY")
        return
    end
    local position=m:position(s.blocker)
    if position==nil then self:finish("POSE_LOST");return end
    local progressed=(position.x-s.originX)*s.directionX
        +(position.z-s.originZ)*s.directionZ
    s.progressM=progressed
    if progressed>=s.targetProgressM then
        self:finish("MANOEUVRE_COMPLETE_PENDING_CONTINUATION")
        return
    end
    local moved,reason=m:driveInWorldDirection(s.blocker,dt,
        s.directionX,s.directionZ,s.speedKmh)
    if not moved then self:finish("NATIVE_DRIVE_FAILED:"..tostring(reason));return end
    s.drove=true
end

function Control:relinquish(reason)
    return self:finish(reason or "CONTROL_REVOKED")
end
