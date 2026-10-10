-- A completed, cold-loaded physical blocker is a current object, not a job history.
OuttaMyWay={}
dofile("scripts/observation/CurrentPlayerControlObservation.lua")
dofile("scripts/assessment/NonActiveObstructionAssessment.lua")
dofile("scripts/coordination/ProjectedEgressRegion.lua")
local poses={[1]={x=0,z=0},[2]={x=0,z=5},[3]={x=30,z=5}}
getWorldTranslation=function(n) local p=assert(poses[n]);return p.x,0,p.z end
localDirectionToWorld=function(_,x,y,z)return x,y,z end

local course={aiFieldCourse={fieldCourse={courseField={boundaryPositions={
    {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}
}}}},isBlocked=true}
local beneficiary={rootNode=1,size={width=4,length=8},
    spec_aiFieldWorker={isActive=true,driveStrategies={course}},
    getRootVehicle=function(self)return self end,
    getAISteeringNode=function(self)return self.rootNode end,
    getIsAIActive=function() return true end,
    getIsControlled=function()return false end}
local blocker={rootNode=2,size={width=3,length=3},
    getRootVehicle=function(self)return self end,
    getIsAIActive=function()return false end,
    getIsControlled=function()return false end}
local beside={rootNode=3,size={width=3,length=3},
    getRootVehicle=function(self)return self end,
    getIsAIActive=function()return false end,
    getIsControlled=function()return false end}
g_currentMission={aiSystem={activeJobVehicles={[beneficiary]=true}},
    vehicleSystem={vehicles={[beneficiary]=true,[blocker]=true,[beside]=true}},
    controlledVehicle=nil}

local assess=OuttaMyWay.NonActiveObstructionAssessment
local positive=assert(assess.find(beneficiary))
assert(positive.positive and positive.blocker==blocker
    and positive.beneficiary==beneficiary)
assert(positive.relation.forwardM==5
    and positive.relation.lateralM==0)
assert(assess.isStillCurrent(positive))

poses[2].x=12
assert(assess.find(beneficiary)==nil,"close lateral neighbour is not causal")
poses[2].x=0
poses[2].z=-4
assert(assess.find(beneficiary)==nil,"parked vehicle behind active heading")
poses[2].z=5
g_currentMission.controlledVehicle=blocker
assert(assess.find(beneficiary)==nil,"player-controlled blocker not moved")
g_currentMission.controlledVehicle=nil
blocker.getIsAIActive=function()return true end
assert(assess.find(beneficiary)==nil,"active non-solo worker is not a non-job blocker")
blocker.getIsAIActive=function()return false end
poses[3]={x=0,z=4}
assert(assess.find(beneficiary)==nil,"two possible blockers must not be guessed")
poses[3]={x=30,z=5}
assert(assess.find(beneficiary).blocker==blocker)
-- Neither old completion provenance nor root-in-polygon membership is needed.
poses[1]={x=0,z=-4}
poses[2]={x=0,z=1}
local exterior=assert(assess.find(beneficiary))
assert(exterior.blocker==blocker)

local driveCalls,neutrals,releases=0,0,0
OuttaMyWay.NonJobActuationMechanism={new=function()
    return {
        position=function(_,vehicle)return poses[vehicle.rootNode] end,
        isPlayerControlled=function(_,v)return g_currentMission.controlledVehicle==v end,
        isSourceReactivated=function(_,v)return v==blocker and v.getIsAIActive() end,
        acquireVehicleActivityContext=function()return true,{previousForceIsActive=false} end,
        releaseVehicleActivityContext=function()releases=releases+1;return true end,
        acquirePropulsionContext=function()return true,{startedByOuttaMyWay=true} end,
        releasePropulsionContext=function()releases=releases+1;return true end,
        maximumForwardSpeedKmh=function()return 25 end,
        propulsionReadiness=function()return "READY" end,
        driveInWorldDirection=function(_,v,dt,dx,dz,speed)
            assert(v==blocker and speed==25)
            driveCalls=driveCalls+1
            return true
        end,
        neutralize=function(_,v)assert(v==blocker);neutrals=neutrals+1;return true end
    }
end}
dofile("scripts/control/NonActiveRelocationControl.lua")
local control=OuttaMyWay.NonActiveRelocationControl.new()
local ok,details=control:begin(exterior)
assert(ok and control:isActive()
    and details.fieldIdentitySource=="GIANTS_ACTIVE_COURSE_FIELD")
assert(details.targetProgressM==60,"archived non-job inward cap")
control:advance(16)
assert(driveCalls==1)
local dx,dz=50-poses[2].x,50-poses[2].z
local distance=math.sqrt(dx*dx+dz*dz)
poses[2].x=poses[2].x+60*dx/distance
poses[2].z=poses[2].z+60*dz/distance
control:advance(16)
assert(not control:isActive() and neutrals==1 and releases==2)
assert(control.lastOutcome.status=="MANOEUVRE_COMPLETE_PENDING_CONTINUATION"
    and control.lastOutcome.continuationConfirmed==false)
assert(not control:isActive() and driveCalls==1,"no invented stop/start or hold")

-- Activity can change while relocation is executing: no stale drive.
poses[2]={x=0,z=1}
assert(control:begin(assess.find(beneficiary)))
g_currentMission.controlledVehicle=blocker
control:advance(16)
assert(not control:isActive() and driveCalls==1
    and control.lastOutcome.status=="HIGHER_AUTHORITY_SUPERSEDED")
print("Native blocked + one non-active forward obstruction / inward actuation: PASS")
