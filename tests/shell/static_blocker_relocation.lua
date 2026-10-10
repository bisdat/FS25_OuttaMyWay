-- Reactive static blocker: inferred subject, native non-job movement and
-- exclusive coordinator, without new shape/proximity sampling.
OuttaMyWay={}
dofile("scripts/observation/StaticBlockageEncounterObservation.lua")
dofile("scripts/coordination/NativePairCommitmentAuthority.lua")
dofile("scripts/coordination/ProjectedEgressRegion.lua")
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
dofile("scripts/control/mechanisms/NativeReverseMechanism.lua")
dofile("scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua")
dofile("scripts/coordination/LiveHoldRelocateRuntime.lua")
local coords={[11]={x=0,z=0},[22]={x=10,z=0},[23]={x=10,y=2,z=0}}
getWorldTranslation=function(node)
    local p=assert(coords[node])
    return p.x,p.y or 0,p.z
end
localDirectionToWorld=function(node,x,y,z)
    return z,y,x
end
worldToLocal=function(node,x,y,z)
    local p=assert(coords[node])
    if node==23 then
        assert(y==2,"GIANTS reverse target uses reverser-node reference height")
    end
    return z-p.z,y,x-p.x
end
local cfg={isResolved=function()return true end,isEnabled=function()return true end}
g_server={}
local originalJob={}
local worker={rootNode=11,spec_aiFieldWorker={
    isActive=true,driveStrategies={{className="AIDriveStrategyFieldCourse",
        isBlocked=true,aiFieldCourse={}}}},
    getJob=function()return originalJob end,
    getRootVehicle=function(self)return self end,
    getAISteeringNode=function(self)return self.rootNode end,
    getAIWorkAreaWidth=function()return 36 end}
local cruise={speed=4,speedReverse=4,maxSpeed=35,maxSpeedReverse=22}
local motor={getMaximumForwardSpeed=function()return 12 end,
    getMaximumBackwardSpeed=function()return 5 end}
local running=false
local subject={rootNode=22,lastSpeedReal=0,forceIsActive=nil,
    spec_drivable={cruiseControl=cruise},
    getRootVehicle=function(self)return self end,
    getAISteeringNode=function(self)return self.rootNode end,
    getAIReverserNode=function()return 23 end,
    getIsAIActive=function()return false end,
    getIsControlled=function()return false end,
    getIsMotorStarted=function()return running end,
    getMotor=function()return motor end,
    startMotor=function()running=true end,
    stopMotor=function()running=false end,
    setCruiseControlMaxSpeed=function(_,forward,reverse)
        cruise.speed=forward;cruise.speedReverse=reverse
    end}
g_currentMission={vehicleSystem={vehicles={[worker]=true,[subject]=true}},
    aiSystem={activeJobVehicles={[worker]=true}}}
AIVehicleUtil={
    getAIToolReverserDirectionNode=function()return nil end,
    driveToPoint=function(vehicle,dt,accel,allowed,forward,lx,lz,speed,doNotSteer)
        assert(doNotSteer==false and type(speed)=="number")
        if allowed then
            assert(vehicle==subject and accel==1)
            -- 2D native-local target is (world Z, world X) in this fixture.
            -- Apply both components so straight-line motion cannot satisfy
            -- the intended lateral egress region accidentally.
            coords[22].x=coords[22].x+10*lz
            coords[22].z=coords[22].z+10*lx
        end
    end
}
local snapshot=OuttaMyWay.StaticBlockageEncounterObservation.capture(
    worker,g_currentMission,100)
assert(snapshot.physicalAssemblyCount==1
    and snapshot.nearestPhysicalAssemblies[1].vehicle==subject
    and snapshot.nearestPhysicalAssemblies[1].reportedSpeedMps==0)
local Authority=OuttaMyWay.NativePairCommitmentAuthority
local authority=Authority.new(cfg)
local short=authority:admitStaticBlockerCandidate(worker,999,snapshot)
assert(short==nil,"native one-second gate preserved")
local admitted=assert(authority:admitStaticBlockerCandidate(worker,1000,snapshot))
assert(admitted.kind=="STATIC_BLOCKER"
    and admitted.relocator.vehicle==subject
    and admitted.participants[1].vehicle==worker)
local plan=assert(OuttaMyWay.ProjectedEgressRegion.planStatic(
    admitted,admitted.relocator))
assert(plan.moveForwards and not plan.isReverse
    and plan.directionSource=="STATIC_FORWARD_OBLIQUE"
    and plan.returnRegion.source=="STATIC_CROSS_TRACK_REGION"
    and plan.beneficiaryWorkingWidthM==36
    and plan.vectorDistanceM==41 and plan.marginM==5
    and plan.nominalBearingOffsetDeg==70
    and plan.returnRegion.requiredProgressM>38
    and plan.targetX>10 and math.abs(plan.targetZ)>70,
    "forward BWR must steer sideways out of the beneficiary corridor")
-- The steering reference is 40m beyond the signed lateral region. This
-- is essential when GIANTS reverses: steering point must not be the finish.
local function assertTargetBeyondRegion(objective)
    local region=objective.returnRegion
    local projected=OuttaMyWay.ProjectedEgressRegion.progress(
        region,objective.targetX,objective.targetZ)
    assert(projected~=nil
        and projected.progressM>region.requiredProgressM,
        "native steering target must lie beyond lateral completion region")
    local rate=math.abs(objective.returnRegion.directionX*region.normalX
        +objective.returnRegion.directionZ*region.normalZ)
    assert(math.abs((projected.progressM-region.requiredProgressM)/rate-40)<0.001,
        "steering point must provide full 40m lookahead beyond region")
    assert(objective.steeringHorizonM>objective.vectorDistanceM)
end
assertTargetBeyondRegion(plan)
assert(not OuttaMyWay.ProjectedEgressRegion.progress(
    plan.returnRegion,50,0).isInRegion,
    "arbitrary straight-forward travel must not satisfy lateral completion")
assert(OuttaMyWay.ProjectedEgressRegion.progress(
    plan.returnRegion,10,-41).isInRegion)
local actuator=OuttaMyWay.NativeStaticAssemblyDriveMechanism.new()
local ok,started=actuator:startMovement(subject,plan)
assert(ok and started.requestedDriveSpeedKmh==35 and running,
    "forward static egress must use native forward maximum, not 8 km/h")
assert(started.nativeDirectionalMotorMaximumKmh==43.2
    and started.nativeDirectionalCruiseMaximumKmh==35)
assert(subject.forceIsActive==true and cruise.speed==35)
local status=nil
for i=1,12 do
    status=actuator:movementStatus(subject,16)
    if status.isComplete then break end
end
assert(status.isComplete and coords[22].x>10 and coords[22].z< -38,
    "non-job direct drive must physically produce cross-track progress")
assert(coords[11].x==0,"the blocked beneficiary is never driven")
assert(actuator:stopMovement(subject))
assert(not running and subject.forceIsActive==nil
    and cruise.speed==4 and cruise.speedReverse==4)
assert(authority:release(admitted))

-- Opposed facing reverses along the same oblique direction using GIANTS'
-- native reverser frame, not a hard-coded reverse-only departure.
coords[22].x,coords[22].z=10,0
local reverseCommit={beneficiaryWorkingWidthM=36,
    beneficiaryForwardX=1,beneficiaryForwardZ=0,
    participants={{x=0,z=0}}}
local reverseSubject={x=10,z=0,forwardX=-1,forwardZ=0}
local reversePlan=assert(OuttaMyWay.ProjectedEgressRegion.planStatic(
    reverseCommit,reverseSubject))
assert(reversePlan.isReverse and not reversePlan.moveForwards
    and reversePlan.directionSource=="STATIC_REVERSE_OBLIQUE"
    and reversePlan.returnRegion.source=="STATIC_CROSS_TRACK_REGION"
    and reversePlan.returnRegion.requiredProgressM>38
    and reversePlan.targetX>10 and math.abs(reversePlan.targetZ)>70)
assertTargetBeyondRegion(reversePlan)
local reverseStarted,reverseEvidence=actuator:startMovement(subject,reversePlan)
assert(reverseStarted and reverseEvidence.requestedDriveSpeedKmh==18
    and reverseEvidence.nativeDirectionalMotorMaximumKmh==18
    and reverseEvidence.nativeDirectionalCruiseMaximumKmh==22,
    "reverse static egress uses native backward maximum independently")
assert(cruise.speedReverse==18)
for i=1,12 do
    status=actuator:movementStatus(subject,16)
    if status.isComplete then break end
end
assert(status.isComplete and coords[22].z< -38)
assert(actuator:stopMovement(subject))
coords[22].x,coords[22].z=10,0

-- Explicitly reject moving, active or controlled neighbours.
local moving=OuttaMyWay.StaticBlockageEncounterObservation.capture(
    worker,g_currentMission,200)
moving.nearestPhysicalAssemblies[1].reportedSpeedMps=2
assert(authority:admitStaticBlockerCandidate(worker,1000,moving)==nil)
moving.nearestPhysicalAssemblies[1].reportedSpeedMps=0
moving.nearestPhysicalAssemblies[1].aiActive=true
assert(authority:admitStaticBlockerCandidate(worker,1000,moving)==nil)
moving.nearestPhysicalAssemblies[1].aiActive=false
moving.nearestPhysicalAssemblies[1].playerControlled=true
assert(authority:admitStaticBlockerCandidate(worker,1000,moving)==nil)
moving.nearestPhysicalAssemblies[1].playerControlled=false

-- Coordinator moves the non-job subject rather than the beneficiary.
local events={}
local physical={
    regulate=function(_,v,purpose)
        assert(v==worker and purpose=="EGRESS")
        events[#events+1]="REGULATE";return true
    end,
    releaseRegulation=function(_,v,purpose)
        assert(v==worker and purpose=="EGRESS")
        events[#events+1]="REGULATION_RELEASE"
        return true,{interceptionCount=3,physicalDisplacementM=0.2,
            lastNativeSpeedKmh=1}
    end,
    preflight=function(_,state)
        assert(state.relocator.vehicle==subject
            and state.blockers[1].vehicle==worker)
        events[#events+1]="PREFLIGHT";return true
    end,
    requestTransit=function(_,v)
        assert(v==subject);events[#events+1]="TRANSIT";return true
    end,
    startStaticMovement=function(_,v,objective)
        assert(v==subject and objective.moveForwards)
        events[#events+1]="MOVE_STATIC";return true
    end,
    staticMovementStatus=function(_,v,dt)
        assert(v==subject and dt==16)
        events[#events+1]="STATUS";return {isComplete=true}
    end,
    stopStaticMovement=function(_,v)
        assert(v==subject);events[#events+1]="STOP";return true
    end,
    retainStaticTransit=function(_,v)
        assert(v==subject);events[#events+1]="RETAIN_TRANSIT";return true
    end,
    cancelStaticMovement=function(_,v)
        events[#events+1]="CANCEL";return true
    end,
    cancelTransit=function(_,v)
        events[#events+1]="RESTORE";return true
    end
}
local c=assert(authority:admitStaticBlockerCandidate(worker,1000,snapshot))
local coordinator=OuttaMyWay.HoldRelocateCoordinator.new(authority,physical)
local began,description=coordinator:begin(c,1000)
assert(began and description.directionSource=="STATIC_FORWARD_OBLIQUE"
    and coordinator:getStatus().egressRegulationUntilMs==6000)
assert(table.concat(events,",")=="PREFLIGHT,REGULATE,TRANSIT,MOVE_STATIC")
coordinator:advance(1016,16)
assert(coordinator:isActive()
    and coordinator:getStatus().phase=="STATIC_WAIT_EGRESS_TIMER",
    "an early physical completion must not curtail the 5-second window")
assert(table.concat(events,",")==
    "PREFLIGHT,REGULATE,TRANSIT,MOVE_STATIC,STATUS,STOP,RETAIN_TRANSIT")
coordinator:advance(5999,16)
assert(coordinator:isActive() and #events==7,
    "no early speed release or further static movement")
coordinator:advance(6000,16)
assert(not coordinator:isActive()
    and coordinator:getStatus().lastOutcome.status=="STATIC_BLOCKER_MOVED")
assert(events[8]=="REGULATION_RELEASE")
assert(#coordinator.lastEgressRegulationResults==1
    and coordinator.lastEgressRegulationResults[1].regulatedSpeedKmh==1
    and coordinator.lastEgressRegulationResults[1].rootId
        ==c.participants[1].assemblyReferenceKey)
assert(authority:release(c))
-- A future player claim interrupts direct motion and releases the lease.
local fresh=assert(authority:admitStaticBlockerCandidate(worker,1000,snapshot))
local objective=assert(OuttaMyWay.ProjectedEgressRegion.planStatic(
    fresh,fresh.relocator))
assert(actuator:startMovement(subject,objective))
g_currentMission.controlledVehicle=subject
status=actuator:movementStatus(subject,16)
assert(status.isFailed and status.reason=="STATIC_SUBJECT_CLAIMED")
assert(actuator:cancelMovement(subject))
g_currentMission.controlledVehicle=nil
assert(authority:release(fresh))

-- Explicit shell disable relinquishes the coordinator AND commitment authority.
-- A later occurrence involving exactly the same two roots is a NEW recovery,
-- not rejected by a retained commitment or prior outcome.
local runtime=OuttaMyWay.LiveHoldRelocateRuntime
local stubRuntime=setmetatable({
    coordinator=coordinator,authority=authority,publication=nil},runtime)
local laterSnapshot=OuttaMyWay.StaticBlockageEncounterObservation.capture(
    worker,g_currentMission,300)
local later=assert(authority:admitStaticBlockerCandidate(
    worker,1000,laterSnapshot))
assert(coordinator:begin(later,10000))
local priorReleaseEvents=#events
assert(stubRuntime:relinquish("DISABLED_OR_SERVER_LOST"))
assert(table.concat(events,",",priorReleaseEvents+1)==
    "CANCEL,REGULATION_RELEASE,RETAIN_TRANSIT",
    "interrupted static recovery releases motion and Regulation but NEVER restores working pose")
assert(authority.active==nil and not coordinator:isActive())
local subsequent=assert(authority:admitStaticBlockerCandidate(
    worker,1000,OuttaMyWay.StaticBlockageEncounterObservation.capture(
        worker,g_currentMission,500)))
assert(subsequent.commitmentId~=later.commitmentId,
    "later encounter must receive a new commitment identity")
assert(coordinator:begin(subsequent,15000),
    "no prior relocation may gate a later native blocked occurrence")
priorReleaseEvents=#events
assert(stubRuntime:relinquish("MAP_DELETE"))
assert(table.concat(events,",",priorReleaseEvents+1)==
    "CANCEL,REGULATION_RELEASE,RETAIN_TRANSIT",
    "map teardown preserves TRANSIT for the static subject only")
assert(authority.active==nil and not coordinator:isActive())

-- The exact TS018 interruption: native beneficiary Job Episode turns over
-- during physical static movement. Preserve TRANSIT, but release native
-- speed Regulation, the direct movement lease and the commitment.
local interrupted=assert(authority:admitStaticBlockerCandidate(
    worker,1000,OuttaMyWay.StaticBlockageEncounterObservation.capture(
        worker,g_currentMission,550)))
assert(coordinator:begin(interrupted,16000))
priorReleaseEvents=#events
local originalGetJob=worker.getJob
worker.getJob=function()return {} end
coordinator:advance(16016,16)
assert(not coordinator:isActive()
    and coordinator:getStatus().lastOutcome.status=="RELINQUISHED")
assert(table.concat(events,",",priorReleaseEvents+1)==
    "CANCEL,REGULATION_RELEASE,RETAIN_TRANSIT",
    "GIANTS job turnover cannot restore a static subject to working pose")
worker.getJob=originalGetJob
assert(authority:release(interrupted))

-- A failed Regulation after successful TRANSIT preflight must release the
-- cached (never dispatched) plan. Otherwise the subsequent static incident
-- would incorrectly hit TRANSIT_PLAN_ALREADY_ACTIVE.
OuttaMyWay.NativeTranslationHoldMechanism={
    new=function()return {} end}
OuttaMyWay.NativeSpeedRegulationMechanism={
    new=function()return {} end}
OuttaMyWay.NativeTransitRequestMechanism={new=function()
    return {cancelTransit=function()return true end}
end}
OuttaMyWay.NativeFieldworkJobReplacementMechanism={
    new=function()return {} end}
dofile("scripts/control/HoldRelocatePhysicalControl.lua")
local realControl=OuttaMyWay.HoldRelocatePhysicalControl.new(authority)
realControl.regulationMechanism={
    regulate=function()return false,"REGULATION_REJECTED_FIXTURE" end,
    releaseRegulation=function()return true end
}
local failed=assert(authority:admitStaticBlockerCandidate(
    worker,1000,laterSnapshot))
local aborted=OuttaMyWay.HoldRelocateCoordinator.new(authority,realControl)
local startedBad,why=aborted:begin(failed,20000)
assert(not startedBad and why=="REGULATION_REJECTED_FIXTURE")
assert(realControl.plans[subject]==nil,
    "preflight-only TRANSIT cache must be cleared after a failed start")
assert(authority:release(failed))
local retry=assert(authority:admitStaticBlockerCandidate(
    worker,1000,OuttaMyWay.StaticBlockageEncounterObservation.capture(
        worker,g_currentMission,600)))
assert(realControl:preflight({relocator=retry.relocator,commitment=retry}),
    "subsequent admission must not inherit preflight cache")
assert(realControl:cancelTransit(subject))
assert(authority:release(retry))
print("Inferred static blocker / reverse target beyond region / fresh BWR: PASS")
