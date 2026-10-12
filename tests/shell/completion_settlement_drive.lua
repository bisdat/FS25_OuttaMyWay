-- Native Completion Settlement drive contract: local POSITION, unchanged
-- Hold & Relocate unit-vector path, and sustained physical stop before release.
OuttaMyWay={}
OuttaMyWay.NativeReverseMechanism={adjustToolTarget=function(_,_,x,z)
    return x,z
end}
OuttaMyWay.ProjectedEgressRegion={progress=function()
    return {progressM=0,isInRegion=false}
end}
local positions={[11]={x=0,y=0,z=0}}
getWorldTranslation=function(node)
    local p=assert(positions[node])
    return p.x,p.y,p.z
end
worldToLocal=function(node,x,y,z)
    local p=assert(positions[node])
    return x-p.x,y-p.y,z-p.z
end
g_server={}
g_currentMission={}
Drivable={CRUISECONTROL_STATE_OFF=0,CRUISECONTROL_STATE_ACTIVE=1}
local cruise={speed=5,speedReverse=4,maxSpeed=36,maxSpeedReverse=15,state=0}
local motorRunning=false
local stopCalls,driveCalls=0,{}
local vehicle={
    rootNode=11,lastSpeedReal=0,forceIsActive=nil,
    spec_drivable={cruiseControl=cruise},
    getIsAIActive=function()return false end,
    getIsControlled=function()return false end,
    getCurrentAIJob=function()return nil end,
    getAISteeringNode=function()return 11 end,
    getAIReverserNode=function()return 11 end,
    getIsMotorStarted=function()return motorRunning end,
    startMotor=function()motorRunning=true;return true end,
    stopMotor=function()motorRunning=false;stopCalls=stopCalls+1;return true end,
    getMotor=function()return {
        getMaximumForwardSpeed=function()return 15 end,
        getMaximumBackwardSpeed=function()return 4 end}
    end,
    getCruiseControlState=function()return cruise.state end,
    setCruiseControlState=function(_,state)
        cruise.state=state
    end,
    setCruiseControlMaxSpeed=function(_,forward,reverse)
        cruise.speed,cruise.speedReverse=forward,reverse
    end
}
AIVehicleUtil={
    getAIToolReverserDirectionNode=function()return nil end,
    driveToPoint=function(_,_,accel,allowed,forwards,tx,tz,speed)
    driveCalls[#driveCalls+1]={accel=accel,allowed=allowed,
        forwards=forwards,tx=tx,tz=tz,speed=speed}
    if allowed then
        if forwards then
            assert(speed>=2.5 and speed<=36,
                "settlement speed must stay within native directional limit")
        else
            assert(speed>=2.5 and speed<=14.4,
                "reverse speed uses native reverse maximum")
        end
    end
    -- GIANTS also reactivates cruise on a NEUTRAL driveToPoint call.
    -- Regressions in order must now fail the physical-stop assertion.
    vehicle:setCruiseControlState(Drivable.CRUISECONTROL_STATE_ACTIVE)
end}
dofile("scripts/control/mechanisms/NativeStaticAssemblyDriveMechanism.lua")
local Drive=OuttaMyWay.NativeStaticAssemblyDriveMechanism
local drive=Drive.new()
local objective={moveForwards=true,targetX=10,targetZ=20,
    returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
assert(drive:startMovement(vehicle,objective))
assert(motorRunning and cruise.speed==36)
local first=drive:movementStatus(vehicle,16)
assert(not first.isComplete and #driveCalls==1)
assert(driveCalls[1].tx==10 and driveCalls[1].tz==20,
    "native driveToPoint expects full local target position")
positions[11].x,positions[11].z=10,20
local arrived=drive:movementStatus(vehicle,16)
assert(arrived.isComplete and not drive:stopMovement(vehicle),
    "point arrival must not release physical Control")
local further={moveForwards=true,targetX=15,targetZ=25,
    maximumSpeedKmh=15,
    returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
assert(drive:retargetSettlement(vehicle,further))
assert(drive.active and cruise.speed==15
    and not drive.active.isComplete,
    "a second steering target must share physical Control")
assert(not drive:movementStatus(vehicle,16).isComplete)
positions[11].x,positions[11].z=15,25
assert(drive:movementStatus(vehicle,16).isComplete)
assert(drive:beginSettlementStop(vehicle))
vehicle.lastSpeedReal=0.002
local moving=drive:settlementStopStatus(vehicle,300)
assert(not moving.isStopped and moving.speedMps==2,
    "2 m/s must not be treated as stationary")
vehicle.lastSpeedReal=0
local final
for i=1,6 do final=drive:settlementStopStatus(vehicle,300) end
assert(final.isStopped and final.steadyMs>=1200
    and final.cruiseState==Drivable.CRUISECONTROL_STATE_OFF)
assert(drive:stopMovement(vehicle))
assert(drive.active==nil and not motorRunning and stopCalls==1)
assert(cruise.state==0 and cruise.speed==5 and cruise.speedReverse==4,
    "completed vehicle remains parked with inactive native cruise")
assert(vehicle.forceIsActive==nil)
assert(#driveCalls>=8 and driveCalls[#driveCalls].allowed==false)
-- Legacy BWR is unchanged: its nominal target is a unit vector.
positions[11].x,positions[11].z=0,0
local bwr={moveForwards=true,targetX=10,targetZ=20,
    returnRegion={source="STATIC_CROSS_TRACK_REGION",
        originX=0,originZ=0,directionX=1,directionZ=0,
        normalX=1,normalZ=0,sideSign=1,requiredProgressM=200}}
assert(drive:startMovement(vehicle,bwr))
drive:movementStatus(vehicle,16)
local legacy=driveCalls[#driveCalls]
local length=math.sqrt(10*10+20*20)
assert(math.abs(legacy.tx-10/length)<0.0001
    and math.abs(legacy.tz-20/length)<0.0001,
    "previous Hold & Relocate steering semantics must stay unchanged")
assert(drive:cancelMovement(vehicle))
-- A short reverse uses GIANTS native reverser frame, not a forward hack.
local reverse={moveForwards=false,targetX=-7,targetZ=0,
    maximumSpeedKmh=12,
    returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
assert(drive:startMovement(vehicle,reverse))
local report=drive:movementStatus(vehicle,16)
assert(not report.isComplete and driveCalls[#driveCalls].forwards==false)
assert(drive:cancelMovement(vehicle))
-- A low-distance direction change must start reducing speed before arrival.
positions[11].x,positions[11].z=0,0
local brake={moveForwards=true,targetX=10,targetZ=0,
    remainingAfterTargetM=0,maximumSpeedKmh=36,
    returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
assert(drive:startMovement(vehicle,brake))
local startBrake=drive:movementStatus(vehicle,16)
assert(startBrake.isComplete==false)
local firstSpeed=driveCalls[#driveCalls].speed
positions[11].x=7
local approach=drive:movementStatus(vehicle,16)
assert(approach.isComplete==false)
local lastSpeed=driveCalls[#driveCalls].speed
assert(lastSpeed<firstSpeed and lastSpeed<=3.61,
    "braking demand must decrease before reaching changeover")
assert(drive:cancelMovement(vehicle))
-- Interruption cannot leave cruise ACTIVE even when never stopped.
assert(drive:startMovement(vehicle,objective))
drive:movementStatus(vehicle,16)
assert(cruise.state==1)
assert(drive:cancelMovement(vehicle))
assert(cruise.state==0 and not motorRunning)
vehicle.getIsControlled=function()return true end
local started,why=drive:startMovement(vehicle,objective)
assert(not started and why=="SETTLEMENT_CONTROL_CLAIMED_OR_CRUISE_UNAVAILABLE")
print("completion settlement native drive target/stop/cruise PASS")
