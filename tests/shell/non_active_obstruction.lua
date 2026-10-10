-- 0.4.11.0 Causal Obstruction kernels adapted to the 0.5 native evidence seam.
-- The archived shape representation is mocked here; its production source is
-- compiled and loaded in the product and source-contract tests.
OuttaMyWay={}
dofile("scripts/observation/CurrentPlayerControlObservation.lua")
dofile("scripts/representation/PlanViewFootprint.lua")
dofile("scripts/assessment/CausalObstructionAssessment.lua")
local poses={[1]={x=0,z=0},[2]={x=0,z=11},[3]={x=25,z=11}}
getWorldTranslation=function(n)
    local p=assert(poses[n],"no mocked GIANTS root")
    return p.x,0,p.z
end
localDirectionToWorld=function(_,x,y,z)return x,y,z end
g_time=0
local course={aiFieldCourse={fieldCourse={courseField={boundaryPositions={
    {x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}
}}}},isBlocked=false}
local worker={rootNode=1,
    spec_aiFieldWorker={driveStrategies={course}},
    getRootVehicle=function(self)return self end,
    getAISteeringNode=function(self)return self.rootNode end,
    getIsAIActive=function()return true end,
    getIsControlled=function()return false end}
local blocker={rootNode=2,
    getRootVehicle=function(self)return self end,
    getIsAIActive=function()return false end,
    getIsControlled=function()return false end}
local innocent={rootNode=3,
    getRootVehicle=function(self)return self end,
    getIsAIActive=function()return false end,
    getIsControlled=function()return false end}
g_currentMission={aiSystem={activeJobVehicles={[worker]=true}},
    vehicleSystem={vehicles={[worker]=true,[blocker]=true,[innocent]=true}},
    controlledVehicle=nil}
OuttaMyWay.CurrentPhysicalConflictRepresentation={new=function()
    return {
        reset=function() end,
        observe=function(_,vehicle)
            local at=assert(poses[vehicle.rootNode])
            return {structurallyValid=true,worldPrimitives={{
                kind="DISC",identity=tostring(vehicle.rootNode),
                x=at.x,z=at.z,radius=1,positiveConflictSupport=true
            }}}
        end
    }
end}
dofile("scripts/assessment/NonActiveObstructionAssessment.lua")
dofile("scripts/coordination/ProjectedEgressRegion.lua")
local assessment=OuttaMyWay.NonActiveObstructionAssessment.new()
assessment:advance(1000)
assert(assessment:findProspective()==nil,
    "proximity alone, without aligned realised progression or current contact, cannot nominate")
poses[1].z=4;g_time=1000;assessment:advance(1000)
assert(assessment:findProspective()==nil,
    "archive bounded reach must not be expanded to the full upcoming field")
poses[1].z=8;g_time=2000;assessment:advance(1000)
local evidence=assert(assessment:findProspective(),
    "supported realised motion must find positive pre-contact Causal Obstruction")
assert(evidence.blocker==blocker and evidence.beneficiary==worker
    and evidence.evidenceSource=="REALISED_MOTION_DEMAND"
    and evidence.nativeBlockedRequired==false and course.isBlocked==false)
assert(assessment.isStillCurrent(evidence))
-- Archive current-overlap evidence is independent of native isBlocked.
poses[2].z=9
local overlap=assert(assessment:find(worker))
assert(overlap.evidenceSource=="CURRENT_PHYSICAL_OCCUPANCY")
poses[2].z=11
poses[2].x=15
assert(assessment:find(worker)==nil,"lateral harmless completed worker")
poses[2].x=0
g_currentMission.controlledVehicle=blocker
assert(assessment:find(worker)==nil,"current player control suppresses non-job actuation")
g_currentMission.controlledVehicle=nil
blocker.getIsAIActive=function()return true end
assert(assessment:find(worker)==nil,"active GIANTS worker cannot be non-job subject")
blocker.getIsAIActive=function()return false end
poses[3]={x=0,z=11}
assert(assessment:find(worker)==nil,"two causative physical subjects are ambiguous")
poses[3]={x=25,z=11}
assert(assessment:find(worker).blocker==blocker)

local driveCalls,neutrals,releases=0,0,0
OuttaMyWay.NonJobActuationMechanism={new=function()
    return {
        position=function(_,vehicle)return poses[vehicle.rootNode] end,
        isPlayerControlled=function(_,vehicle)
            return g_currentMission.controlledVehicle==vehicle end,
        isSourceReactivated=function(_,vehicle)
            return vehicle==blocker and vehicle.getIsAIActive() end,
        acquireVehicleActivityContext=function()return true,{previousForceIsActive=false} end,
        releaseVehicleActivityContext=function()releases=releases+1;return true end,
        acquirePropulsionContext=function()return true,{startedByOuttaMyWay=true} end,
        releasePropulsionContext=function()releases=releases+1;return true end,
        maximumForwardSpeedKmh=function()return 25 end,
        propulsionReadiness=function()return "READY" end,
        driveInWorldDirection=function(_,vehicle,dt,dx,dz,speed)
            assert(vehicle==blocker and speed==25)
            driveCalls=driveCalls+1
            return true
        end,
        neutralize=function(_,vehicle)
            assert(vehicle==blocker);neutrals=neutrals+1;return true end,
        clearDeferredPropulsionRestoration=function()end
    }
end}
dofile("scripts/control/NonActiveRelocationControl.lua")
local control=OuttaMyWay.NonActiveRelocationControl.new()
local admitted,details=control:begin(evidence)
assert(admitted and details.fieldIdentitySource=="GIANTS_ACTIVE_COURSE_FIELD"
    and details.evidenceKind=="REALISED_MOTION_DEMAND"
    and details.targetProgressM==60)
assert(course.isBlocked==false,"pre-contact admission must not set GIANTS blocked")
control:advance(16)
assert(driveCalls==1 and control:isActive(),
    "control must not exit when beneficiary native blocked remains false")
local start=poses[2]
local fieldX,fieldZ=50,50
local dx,dz=fieldX-start.x,fieldZ-start.z
local len=math.sqrt(dx*dx+dz*dz)
poses[2]={x=start.x+60.5*dx/len,z=start.z+60.5*dz/len}
control:advance(16)
assert(not control:isActive() and neutrals==1 and releases==2)
assert(control.lastOutcome.status=="MANOEUVRE_COMPLETE_PENDING_CONTINUATION"
    and control.lastOutcome.continuationConfirmed==false
    and control.lastOutcome.driveCalls==1)

-- Archived deleteMap retires state without native physics against destroyed nodes.
poses[2]={x=0,z=11}
assert(control:begin(assessment:find(worker)))
control:advance(16)
local prevNeutral=neutrals
control:discardOnMapDelete()
assert(not control:isActive() and neutrals==prevNeutral,
    "destroyed GIANTS entity must not be neutralized during map deletion")
-- Source reactivation remains higher authority.
local newEvidence=assert(assessment:find(worker))
assert(control:begin(newEvidence))
blocker.getIsAIActive=function()return true end
control:advance(16)
assert(not control:isActive() and driveCalls==2
    and control.lastOutcome.status=="HIGHER_AUTHORITY_SUPERSEDED")
print("Archived Causal Obstruction: pre-contact positive, negatives, bounded non-job actuation: PASS")
