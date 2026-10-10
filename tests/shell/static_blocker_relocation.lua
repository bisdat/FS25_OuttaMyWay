-- Reactive static blocker: inferred subject, native non-job movement and
-- exclusive coordinator, without new shape/proximity sampling.
OuttaMyWay={}
dofile("scripts/observation/StaticBlockageEncounterObservation.lua")
dofile("scripts/coordination/NativePairCommitmentAuthority.lua")
dofile("scripts/coordination/ProjectedEgressRegion.lua")
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
dofile("scripts/control/mechanisms/NativeReverseMechanism.lua")
dofile("scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua")
local coords={[11]={x=0,z=0},[22]={x=10,z=0}}
getWorldTranslation=function(node)
    local p=assert(coords[node])
    return p.x,0,p.z
end
localDirectionToWorld=function(node,x,y,z)
    return z,y,x
end
worldToLocal=function(node,x,y,z)
    local p=assert(coords[node])
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
    getAISteeringNode=function(self)return self.rootNode end}
local cruise={speed=4,speedReverse=4,maxSpeed=35,maxSpeedReverse=22}
local motor={getMaximumForwardSpeed=function()return 12 end,
    getMaximumBackwardSpeed=function()return 5 end}
local running=false
local subject={rootNode=22,lastSpeedReal=0,forceIsActive=nil,
    spec_drivable={cruiseControl=cruise},
    getRootVehicle=function(self)return self end,
    getAISteeringNode=function(self)return self.rootNode end,
    getAIReverserNode=function(self)return self.rootNode end,
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
            coords[22].x=coords[22].x+10
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
    and plan.directionSource=="STATIC_FORWARD_AWAY"
    and plan.returnRegion.requiredProgressM==30
    and plan.targetX==80 and plan.targetZ==0)
local actuator=OuttaMyWay.NativeStaticAssemblyDriveMechanism.new()
local ok,started=actuator:startMovement(subject,plan)
assert(ok and started.requestedDriveSpeedKmh==8 and running)
assert(subject.forceIsActive==true and cruise.speed==8)
local status=nil
for i=1,4 do
    status=actuator:movementStatus(subject,16)
end
assert(status.isComplete and coords[22].x==40)
assert(coords[11].x==0,"the blocked beneficiary is never driven")
assert(actuator:stopMovement(subject))
assert(not running and subject.forceIsActive==nil
    and cruise.speed==4 and cruise.speedReverse==4)
assert(authority:release(admitted))

-- Facing the blocked worker reverses the same native movement axis. No
-- arbitrary world reverse vector is substituted for GIANTS reverser frame.
coords[22].x=10
local reverseCommit={staticRegionDistanceM=30,
    participants={{x=0,z=0}}}
local reverseSubject={x=10,z=0,forwardX=-1,forwardZ=0}
local reversePlan=assert(OuttaMyWay.ProjectedEgressRegion.planStatic(
    reverseCommit,reverseSubject))
assert(reversePlan.isReverse and not reversePlan.moveForwards
    and reversePlan.directionSource=="STATIC_REVERSE_AWAY"
    and reversePlan.returnRegion.directionX==1)
assert(actuator:startMovement(subject,reversePlan))
for i=1,4 do status=actuator:movementStatus(subject,16) end
assert(status.isComplete and actuator:stopMovement(subject))
coords[22].x=10

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
    preflight=function(_,state)
        assert(state.relocator.vehicle==subject)
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
assert(began and description.directionSource=="STATIC_FORWARD_AWAY")
assert(table.concat(events,",")=="PREFLIGHT,TRANSIT,MOVE_STATIC")
coordinator:advance(1016,16)
assert(coordinator:getStatus().lastOutcome.status=="STATIC_BLOCKER_MOVED")
assert(table.concat(events,",")==
    "PREFLIGHT,TRANSIT,MOVE_STATIC,STATUS,STOP,RETAIN_TRANSIT")
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
print("Inferred static blocker / direct native drive / exclusive BWR: PASS")
