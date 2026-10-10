-- Bounded physical movement of a positively identified non-active obstruction.
-- Specification Jurisdictions: `OBSTRUCTION_RELOCATION`
-- The active beneficiary owns the field; the blocker has no GIANTS AI job to restart.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NonActiveRelocationControl={}
local Control=OuttaMyWay.NonActiveRelocationControl
Control.__index=Control
local MAX_INWARD_M=60 -- archive bounded inward actuation cap
local OFFSET_M=40 -- archive optional offset relocation centre
local OFFSET_ALIGNMENT_DOT=0.8660254037844386 -- archive 30-degree collinearity

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

-- Donor: ObstructionRelocationCandidateSupport.offsetRelocationCentre.
-- Recreate the same inward/offset objective from the beneficiary's own field.
local function relocationCentre(evidence,from,cx,cz)
    local ax,az=evidence.motionDirectionX,evidence.motionDirectionZ
    if not finite(ax) or not finite(az) then
        return cx,cz,"FIELD_WORLD_CENTROID"
    end
    local dx,dz=cx-from.x,cz-from.z
    local length=math.sqrt(dx*dx+dz*dz)
    if length<=0.000001
        or math.abs((dx*ax+dz*az)/length)<OFFSET_ALIGNMENT_DOT then
        return cx,cz,"FIELD_WORLD_CENTROID"
    end
    local px,pz=-az,ax
    local origin=evidence.beneficiaryPose
    local side=1
    if type(origin)=="table" and finite(origin.x) and finite(origin.z) then
        local blockerSide=(from.x-origin.x)*px+(from.z-origin.z)*pz
        local centroidSide=(cx-origin.x)*px+(cz-origin.z)*pz
        if math.abs(blockerSide)>0.05 then side=blockerSide>=0 and 1 or -1
        elseif math.abs(centroidSide)>0.05 then side=centroidSide>=0 and 1 or -1 end
    end
    return cx+px*side*OFFSET_M,cz+pz*side*OFFSET_M,
        "OFFSET_RELOCATION_CENTRE"
end

function Control.new()
    return setmetatable({actuator=OuttaMyWay.NonJobActuationMechanism.new(),
        active=nil,lastOutcome=nil,lastPhysicalEvidence=nil},Control)
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
        driveCalls=state.driveCalls or 0,
        relocationCentreKind=state.relocationCentreKind,
        physicalCleanupConfirmed=not claimed and neutralOk==true
            and propOk==true and activityOk==true,
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
    if strategy==nil then
        return false,"BENEFICIARY_GIANTS_COURSE_UNAVAILABLE"
    end
    local _,fieldCentre,source=OuttaMyWay.ProjectedEgressRegion.ownCourseField(strategy)
    if type(fieldCentre)~="table" or not finite(fieldCentre.x)
        or not finite(fieldCentre.z) then
        return false,"BENEFICIARY_OWN_FIELD_CENTRE_UNAVAILABLE"
    end
    local m=self.actuator
    local start=m:position(blocker)
    if start==nil then return false,"NON_ACTIVE_BLOCKER_POSE_UNAVAILABLE" end
    local centreX,centreZ,centreKind=relocationCentre(evidence,start,
        fieldCentre.x,fieldCentre.z)
    local dx,dz=centreX-start.x,centreZ-start.z
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
    self.lastPhysicalEvidence=nil
    self.active={
        beneficiary=beneficiary,blocker=blocker,
        evidence=evidence,sourceStrategy=strategy,
        activity=activity,propulsion=propulsion,
        originX=start.x,originZ=start.z,
        directionX=dx/distance,directionZ=dz/distance,
        targetProgressM=amount,speedKmh=speed,
        relocationCentreKind=centreKind,
        fieldIdentitySource=source,progressM=0,drove=false,
        nativeBlockageObserved=strategy.isBlocked==true,
        phaseReported=nil,driveCalls=0,progressBucket=0
    }
    return true,{targetProgressM=amount,fieldIdentitySource=source,
        speedKmh=speed,sourceStrategy=strategy,
        relocationCentreKind=centreKind,
        evidenceKind=evidence.evidenceSource}
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
    if s.sourceStrategy.isBlocked==true then
        s.nativeBlockageObserved=true
    elseif s.nativeBlockageObserved==true then
        self:finish("BENEFICIARY_NATIVE_BLOCKAGE_CLEARED")
        return
    end
    if not OuttaMyWay.NonActiveObstructionAssessment.isStillCurrent(s.evidence)
        or activeStrategy(s.beneficiary)~=s.sourceStrategy then
        self:finish("BENEFICIARY_OR_BLOCKER_CHANGED")
        return
    end
    local status=m:propulsionReadiness(s.blocker,s.propulsion)
    if status=="PENDING" then
        if s.phaseReported~="PROPULSION_PENDING" then
            s.phaseReported="PROPULSION_PENDING"
            self.lastPhysicalEvidence={
                phase="PROPULSION_PENDING",
                blockerRootId=tostring(s.blocker.rootNode),
                driveCalls=s.driveCalls,progressM=s.progressM
            }
        end
        return
    end
    if status~="READY" then
        self:finish("PROPULSION_NOT_READY:"..tostring(status))
        return
    end
    if s.phaseReported~="PROPULSION_READY" and s.driveCalls==0 then
        s.phaseReported="PROPULSION_READY"
        self.lastPhysicalEvidence={
            phase="PROPULSION_READY",
            blockerRootId=tostring(s.blocker.rootNode),
            driveCalls=s.driveCalls,progressM=s.progressM
        }
    end
    local position=m:position(s.blocker)
    if position==nil then self:finish("POSE_LOST");return end
    local progressed=(position.x-s.originX)*s.directionX
        +(position.z-s.originZ)*s.directionZ
    s.progressM=progressed
    if progressed>=1 and s.progressBucket==0 then
        s.progressBucket=1
        self.lastPhysicalEvidence={
            phase="FIRST_POSITIVE_DISPLACEMENT",
            blockerRootId=tostring(s.blocker.rootNode),
            driveCalls=s.driveCalls,progressM=progressed
        }
    elseif progressed>=s.progressBucket+5 then
        s.progressBucket=math.floor(progressed/5)*5
        self.lastPhysicalEvidence={
            phase="MEASURED_PROGRESS",
            blockerRootId=tostring(s.blocker.rootNode),
            driveCalls=s.driveCalls,progressM=progressed
        }
    end
    if progressed>=s.targetProgressM then
        self:finish("MANOEUVRE_COMPLETE_PENDING_CONTINUATION")
        return
    end
    local moved,reason=m:driveInWorldDirection(s.blocker,dt,
        s.directionX,s.directionZ,s.speedKmh)
    if not moved then self:finish("NATIVE_DRIVE_FAILED:"..tostring(reason));return end
    s.drove=true
    s.driveCalls=s.driveCalls+1
    if s.driveCalls==1 then
        self.lastPhysicalEvidence={
            phase="FIRST_NATIVE_DRIVE_ACCEPTED",
            blockerRootId=tostring(s.blocker.rootNode),
            driveCalls=1,progressM=progressed
        }
    end
end

-- Mirroring the archived ObstructionRelocationControl.deleteMap: at this
-- GIANTS callback, the vehicle entity may already be destroyed. Do not
-- execute wheel physics, motor calls or activity setters on a dead node.
function Control:discardOnMapDelete()
    self.active=nil
    self.lastPhysicalEvidence=nil
    self.actuator:clearDeferredPropulsionRestoration()
end

function Control:relinquish(reason)
    return self:finish(reason or "CONTROL_REVOKED")
end
