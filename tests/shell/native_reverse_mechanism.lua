-- Subordinate native reverse evidence under a mocked GIANTS drive path; not in-game validation.
OuttaMyWay={}
dofile("scripts/coordination/ProjectedEgressRegion.lua")
dofile("scripts/control/mechanisms/NativeReverseMechanism.lua")
local Mechanism=OuttaMyWay.NativeReverseMechanism
local calls={}
local locations={
    [1]={x=0,y=0,z=0},[2]={x=0,y=0,z=0},
    [3]={x=100,y=0,z=100},[4]={x=0,y=0,z=0}
}
local selectedTool=nil
g_server={}
getWorldTranslation=function(node)
    local p=locations[node]
    assert(p~=nil,"unknown reference node")
    return p.x,p.y,p.z
end
worldToLocal=function(node,x,y,z)
    local p=locations[node]
    return x-p.x,y-p.y,z-p.z
end
local native=function(vehicle,dt,accel,allowed,forwards,lx,lz,speed,doNotSteer)
    calls[#calls+1]={vehicle=vehicle,allowed=allowed,forwards=forwards,
        lx=lx,lz=lz,speed=speed,doNotSteer=doNotSteer}
end
AIVehicleUtil={
    driveToPoint=native,
    getAIToolReverserDirectionNode=function() return selectedTool end
}
local cruise={speed=8,speedReverse=8,maxSpeed=30,maxSpeedReverse=25}
local motor={getMaximumBackwardSpeed=function()return 25/3.6 end}
local vehicle={
    rootNode=1,
    spec_drivable={cruiseControl=cruise},
    getMotor=function()return motor end,
    setCruiseControlMaxSpeed=function(self,forward,reverse)
        local c=self.spec_drivable.cruiseControl
        c.speed=math.min(forward,c.maxSpeed)
        c.speedReverse=math.min(reverse,c.maxSpeedReverse)
    end,
    getAISteeringNode=function() return 3 end,
    getAIReverserNode=function() return 2 end
}
local objective={targetX=0,targetZ=-40,steeringHorizonM=40,isReverse=true,
    returnRegion={originX=0,originZ=0,directionX=0,directionZ=-1,
        blockerOriginX=0,blockerOriginZ=0,
        corridorNormalX=0,corridorNormalZ=-1,sideSign=1,
        initialCrossTrackM=0,requiredCrossTrackM=9,
        requiredProgressM=9}}
local mechanism=Mechanism.new()
local ok,armed=mechanism:startReverse(vehicle,objective)
assert(ok and armed.kind=="REVERSE_ARMED" and armed.isPhysicalMotionConfirmed==false)
assert(armed.requestedReverseSpeedKmh==25)
assert(cruise.speed==25 and cruise.speedReverse==25,
    "GIANTS cruise settings must not retain the previous 8 km/h limiter")
assert(AIVehicleUtil.driveToPoint~=native)
local unrelated={}
AIVehicleUtil.driveToPoint(unrelated,16,1,true,true,7,9,19,true)
assert(calls[1].vehicle==unrelated and calls[1].doNotSteer==true
    and calls[1].lx==7 and calls[1].lz==9 and calls[1].forwards==true,
    "unrelated native call, including optional ninth argument, is unchanged")
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,20,1,0,true)
assert(calls[2].vehicle==vehicle and calls[2].allowed==true
    and calls[2].forwards==false and calls[2].speed==25
    and calls[2].doNotSteer==false,
    "owned call uses native reverse steering despite blocked native input")
assert(math.abs(calls[2].lx)<1e-5 and calls[2].lz<0)
assert(mechanism:reverseStatus(vehicle).commandedDriveCount==1)
assert(not mechanism:stopReverse(vehicle),"issuing drive must not complete movement")
locations[1].z=-9.5
local status=mechanism:reverseStatus(vehicle)
assert(status.isComplete and status.travelledM==9.5 and status.isFailed==false)
assert(status.regionProgressM==9.5 and status.regionRemainingM==0)
assert(math.abs(status.initialMotionDeviationDeg)<0.0001,
    "first measured reverse vector agrees with projected Return Region")
assert(mechanism:stopReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native,"completed lease restores original native call")
assert(cruise.speed==8 and cruise.speedReverse==8,
    "reverse completion restores the prior native cruise speeds")
-- The very same native reverse wrapper accepts a blocker-free solo 40 m
-- projected region; no fake pair geometry or exact steering-point arrival.
locations[1].z=0
local soloObjective={targetX=0,targetZ=-80,steeringHorizonM=80,isReverse=true,
    returnRegion={source="SINGLE_REVERSE_REGION",
        originX=0,originZ=0,directionX=0,directionZ=-1,
        requiredProgressM=40}}
local soloArmed,soloEvidence=mechanism:startReverse(vehicle,soloObjective)
assert(soloArmed and soloEvidence.kind=="REVERSE_ARMED")
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,false)
locations[1].z=-39
local soloStatus=mechanism:reverseStatus(vehicle)
assert(not soloStatus.isComplete and soloStatus.regionRemainingM==1)
locations[1].z=-40.5
soloStatus=mechanism:reverseStatus(vehicle)
assert(soloStatus.isComplete and not soloStatus.isFailed
    and soloStatus.regionRemainingM==0)
assert(mechanism:stopReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native
    and cruise.speed==8 and cruise.speedReverse==8)
locations[1].z=0
-- A second objective starts a new displacement sample and cannot borrow completion.
locations[1].z=0
assert(mechanism:startReverse(vehicle,objective))
assert(not mechanism:startReverse(vehicle,objective),"only one leased reverse movement")
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,false)
-- Movement beyond the former straight-line distance is no longer an abort:
-- only projection into the Return Region completes the manoeuvre.
locations[1].z=11
status=mechanism:reverseStatus(vehicle)
assert(not status.isFailed and not status.isComplete and status.travelledM==11)
assert(status.regionProgressM==-11)
assert(math.abs(status.initialMotionDeviationDeg-180)<0.0001,
    "an initially opposed physical vector is measured, not forced to 45 degrees")
assert(not mechanism:stopReverse(vehicle))
assert(mechanism:cancelReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native)
assert(cruise.speed==8 and cruise.speedReverse==8,
    "failed reverse cleanup restores the native cruise speeds")
-- Tool node present means native equivalent geometry is mandatory, not optional.
selectedTool=4
local started,reason=mechanism:startReverse(vehicle,objective)
assert(not started and reason=="TOOL_GEOMETRY_UNAVAILABLE")
assert(AIVehicleUtil.driveToPoint==native)
-- Simulated GIANTS tool geometry. Force a distinct forward steering node.
local actualConversionNode=nil
local originalWorldToLocal=worldToLocal
worldToLocal=function(node,x,y,z)
    actualConversionNode=node
    return originalWorldToLocal(node,x,y,z)
end
localDirectionToWorld=function(node,x,y,z) return x,y,z end
localToWorld=function(node,x,y,z)
    local p=locations[node]
    return p.x+x,p.y+y,p.z+z
end
MathUtil={
    vector2Length=function(x,z) return math.sqrt(x*x+z*z) end,
    getProjectOnLineParameter=function(x,z,px,pz,dx,dz)
        return (x-px)*dx+(z-pz)*dz end,
    vector2Normalize=function(x,z)
        local m=math.sqrt(x*x+z*z)
        if m<=0 then return 0,0 end
        return x/m,z/m
    end,
    dotProduct=function(x1,y1,z1,x2,y2,z2)
        return x1*x2+y1*y2+z1*z2 end,
    getSignedAngleBetweenVectors2D=function(x1,z1,x2,z2)
        return math.atan2(x1*z2-z1*x2,x1*x2+z1*z2) end,
    isNan=function(x) return x~=x end
}
ok,armed=mechanism:startReverse(vehicle,objective)
assert(ok and armed.hasToolReverser==true)
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,nil)
assert(actualConversionNode==2,"worldToLocal uses getAIReverserNode, not forward steering")
assert(mechanism:reverseStatus(vehicle).commandedDriveCount==1)
assert(mechanism:cancelReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native)
assert(cruise.speed==8 and cruise.speedReverse==8)
-- Without server permission nothing installs and native calls remain unchanged.
g_server=nil
started,reason=mechanism:startReverse(vehicle,objective)
assert(not started and reason=="SERVER_REQUIRED")
assert(AIVehicleUtil.driveToPoint==native)
assert(OuttaMyWay.runtime==nil,"no Control runtime activation")
-- Missing or faulty GIANTS-native backward speed is an explicit rejection;
-- never fall back to archived fixed 8 km/h or a forward-speed estimate.
g_server={}
local savedGetter=motor.getMaximumBackwardSpeed
motor.getMaximumBackwardSpeed=nil
started,reason=mechanism:startReverse(vehicle,objective)
assert(not started and reason=="NATIVE_REVERSE_SPEED_API_UNAVAILABLE")
motor.getMaximumBackwardSpeed=function()error("NATIVE_MOTOR_QUERY_FAILURE")end
started,reason=mechanism:startReverse(vehicle,objective)
assert(not started and reason=="NATIVE_REVERSE_SPEED_UNAVAILABLE")
motor.getMaximumBackwardSpeed=savedGetter
-- A native setter that partially applies and then fails must preserve a
-- cleanup obligation; the coordinator may safely retry cancellation.
local partialSetter=vehicle.setCruiseControlMaxSpeed
vehicle.setCruiseControlMaxSpeed=function(self,forward,reverse)
    self.spec_drivable.cruiseControl.speed=forward
    error("PARTIAL_NATIVE_CRUISE_CHANGE")
end
started,reason=mechanism:startReverse(vehicle,objective)
assert(not started and reason=="NATIVE_CRUISE_SPEED_STATE_UNRESOLVED")
assert(mechanism.activeVehicle==vehicle)
vehicle.setCruiseControlMaxSpeed=partialSetter
assert(mechanism:cancelReverse(vehicle))
assert(cruise.speed==8 and cruise.speedReverse==8)
assert(AIVehicleUtil.driveToPoint==native)
-- A vehicle whose native reverse cruise limit is smaller than the motor
-- capability receives that *native* limit, not an imagined 25 km/h.
local maxReverse=cruise.maxSpeedReverse
cruise.maxSpeedReverse=18
selectedTool=nil
started,armed=mechanism:startReverse(vehicle,objective)
assert(started and armed.requestedReverseSpeedKmh==18)
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,false)
assert(calls[#calls].speed==18)
assert(mechanism:cancelReverse(vehicle))
assert(cruise.speed==8 and cruise.speedReverse==8)
cruise.maxSpeedReverse=maxReverse
-- Restoration failure must retain the reverse lease for safe follow-up.
local setter=vehicle.setCruiseControlMaxSpeed
started=assert(mechanism:startReverse(vehicle,objective))
vehicle.setCruiseControlMaxSpeed=function()error("NATIVE_RESTORE_FAILURE")end
local released,releaseReason=mechanism:cancelReverse(vehicle)
assert(not released and releaseReason=="NATIVE_CRUISE_RESTORE_UNCONFIRMED")
assert(mechanism.activeVehicle==vehicle)
vehicle.setCruiseControlMaxSpeed=setter
assert(mechanism:cancelReverse(vehicle))
assert(cruise.speed==8 and cruise.speedReverse==8)
-- A paired forward option must use GIANTS' *forward* motor and steering
-- frame, without reverse tool correction or a synthetic fieldwork job.
motor.getMaximumForwardSpeed=function()return 27/3.6 end
local forwardObjective={isReverse=false,moveForwards=true,
    targetX=100,targetZ=140,steeringHorizonM=150,
    returnRegion={source="SIGNED_CROSS_TRACK_REGION",
        originX=0,originZ=0,directionX=0,directionZ=1,
        blockerOriginX=0,blockerOriginZ=0,
        corridorNormalX=0,corridorNormalZ=1,sideSign=1,
        initialCrossTrackM=0,requiredCrossTrackM=9,
        requiredProgressM=9}}
locations[1].x=0;locations[1].z=0
local forwardArmed,forwardEvidence=mechanism:startReverse(vehicle,forwardObjective)
assert(forwardArmed and forwardEvidence.kind=="PAIR_FORWARD_ARMED"
    and forwardEvidence.requestedDriveSpeedKmh==25
    and forwardEvidence.requestedReverseSpeedKmh==nil)
AIVehicleUtil.driveToPoint(vehicle,16,0,false,false,1,1,0,true)
assert(calls[#calls].forwards==true and calls[#calls].allowed==true
    and calls[#calls].doNotSteer==false and calls[#calls].speed==25
    and actualConversionNode==3,
    "forward egress is not sent through the reverse node")
locations[1].z=10
assert(mechanism:reverseStatus(vehicle).isComplete)
assert(mechanism:stopReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native
    and cruise.speed==8 and cruise.speedReverse==8)
-- TS001 TEST 0.5.2.18: the actual actuator, not a coordinator mock,
-- must accept the new PAIR_WORKING_CORRIDOR_TRAVEL_REGION contract.
-- This objective intentionally has NO requiredCrossTrackM: its completion
-- is the remaining worker's 36 m work width + 5 m directional travel.
local function pairedTravel(forward)
    local dz=forward and 1 or -1
    return {isReverse=not forward,moveForwards=forward,
        targetX=0,targetZ=dz*81,steeringHorizonM=81,
        returnRegion={source="PAIR_WORKING_CORRIDOR_TRAVEL_REGION",
            originX=0,originZ=0,directionX=0,directionZ=dz,
            requiredProgressM=41}}
end
for _,forward in ipairs({false,true}) do
    locations[1].x=0;locations[1].z=0
    local candidate=pairedTravel(forward)
    local passed,observed=mechanism:startReverse(vehicle,candidate)
    assert(passed, "TS001 real native drive actuator rejected paired 41 m region")
    assert(observed.kind==(forward and "PAIR_FORWARD_ARMED" or "REVERSE_ARMED"))
    AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,false)
    local dz=forward and 1 or -1
    locations[1].z=dz*2
    local progress=mechanism:reverseStatus(vehicle)
    assert(not progress.isComplete and progress.regionRemainingM>38,
        "2 m is not the 41 m paired Return Region")
    locations[1].z=dz*40
    progress=mechanism:reverseStatus(vehicle)
    assert(not progress.isComplete and progress.regionRemainingM>0.9,
        "40 m must not satisfy 41 m directional travel")
    locations[1].z=dz*41
    progress=mechanism:reverseStatus(vehicle)
    assert(progress.isComplete and progress.regionRemainingM==0,
        "41 m must complete the actual native directional drive")
    assert(mechanism:stopReverse(vehicle))
    assert(AIVehicleUtil.driveToPoint==native
        and cruise.speed==8 and cruise.speedReverse==8,
        "native lease restores after paired 41 m completion")
end
-- Preserve meaningful mandatory schema validation: do not repair the
-- contract mismatch by accepting missing travel or direction data.
local broken=pairedTravel(true)
broken.returnRegion.requiredProgressM=nil
local allowed,brokenReason=mechanism:startReverse(vehicle,broken)
assert(not allowed and brokenReason=="REVERSE_REQUEST_INVALID")
broken=pairedTravel(false)
broken.returnRegion.directionZ=nil
allowed,brokenReason=mechanism:startReverse(vehicle,broken)
assert(not allowed and brokenReason=="REVERSE_REQUEST_INVALID")
-- Issue #470: DIAGNOSTIC publication must never change the exact GIANTS
-- drive parameters, even when sampled tool/heading evidence is unavailable.
locations[1].x=0;locations[1].z=0
selectedTool=nil
local baseline=pairedTravel(false)
assert(mechanism:startReverse(vehicle,baseline))
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,true)
local previous=calls[#calls]
assert(mechanism:cancelReverse(vehicle))
local reported={}
local diagnosticEnabled=true
OuttaMyWay.LogPublication={origin=function()
    return {isEligible=function()return diagnosticEnabled end,
        publish=function(_,class,severity,code,payload)
            reported[#reported+1]={code=code,payload=payload()}
            return true
        end}
end}
dofile("scripts/diagnostics/ReverseKinematicsProbe.lua")
g_time=30000
locations[1].x=0;locations[1].z=0
assert(mechanism:startReverse(vehicle,baseline))
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,true)
local diagnosticCall=calls[#calls]
assert(diagnosticCall.forwards==previous.forwards
    and diagnosticCall.allowed==previous.allowed
    and diagnosticCall.speed==previous.speed
    and diagnosticCall.doNotSteer==previous.doNotSteer
    and diagnosticCall.lx==previous.lx and diagnosticCall.lz==previous.lz,
    "diagnostic cannot modify GIANTS native drive request")
assert(#reported==2 and reported[1].code=="REVERSE_KINEMATICS_START"
    and reported[2].code=="REVERSE_KINEMATICS_SAMPLE")
-- An instrument error must not revoke or change physical Control.
local savedSample=OuttaMyWay.ReverseKinematicsProbe.sample
OuttaMyWay.ReverseKinematicsProbe.sample=function()error("SENSOR_FAILED")end
g_time=30500
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,true)
assert(calls[#calls].allowed==true and calls[#calls].speed==previous.speed)
OuttaMyWay.ReverseKinematicsProbe.sample=savedSample
assert(mechanism:cancelReverse(vehicle))
assert(reported[#reported].code=="REVERSE_KINEMATICS_END")
reported={}
diagnosticEnabled=false
assert(mechanism:startReverse(vehicle,baseline))
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,true)
assert(#reported==0,"NORMAL mode must suppress all diagnostic construction")
assert(mechanism:cancelReverse(vehicle))
assert(#reported==0)
print("Native directional pair egress and reverse restoration: PASS")
