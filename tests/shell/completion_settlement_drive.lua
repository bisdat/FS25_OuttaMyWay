-- Native Completion Settlement drive contract: local POSITION, unchanged
-- Hold & Relocate unit-vector path, and sustained physical stop before release.
OuttaMyWay={}
local toolCorrections=0
OuttaMyWay.NativeReverseMechanism={adjustToolTarget=function(_,tool,x,z)
    if tool~=nil then
        toolCorrections=toolCorrections+1
        return x+4,z+2
    end
    return x,z
end}
OuttaMyWay.ProjectedEgressRegion={progress=function()
    return {progressM=0,isInRegion=false}
end}
local positions={[11]={x=0,y=0,z=0},[12]={x=2,y=0,z=0},
    [99]={x=-3,y=0,z=0}}
local selectedTool=nil
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
    getAIReverserNode=function()return 12 end,
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
    getAIToolReverserDirectionNode=function()return selectedTool end,
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
assert(drive.active.motorWasRunningInitially==false
    and drive.active.motorStartCallAccepted==true
    and drive.active.motorStartReply=="true",
    "native motor start request response is captured without asserting readiness")
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
-- BWR's longer steering look-through is independent from a SHORT parking
-- arrival point, and parking must still honour the tool reverse transform.
selectedTool=99
local lookThrough={moveForwards=false,targetX=-7,targetZ=0,
    steeringTargetX=-47,steeringTargetZ=0,
    maximumSpeedKmh=12,
    returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
assert(drive:startMovement(vehicle,lookThrough))
local before=toolCorrections
local beforeCommands=#driveCalls
assert(not drive:movementStatus(vehicle,16).isComplete)
assert(toolCorrections==before+1 and #driveCalls==beforeCommands+1
    and driveCalls[#driveCalls].forwards==false
    and driveCalls[#driveCalls].tx==-45
    and driveCalls[#driveCalls].tz==2,
    "GIANTS tool correction and reverse node must see distant steering position")
positions[11].x=-7
assert(drive:movementStatus(vehicle,16).isComplete,
    "movement ends at original -7m root target, NOT -47m steering reference")
assert(drive:beginSettlementStop(vehicle))
vehicle.lastSpeedReal=0
for i=1,5 do drive:settlementStopStatus(vehicle,300) end
assert(drive:stopMovement(vehicle))
positions[11].x=0
selectedTool=nil
-- A diverged guide can be stopped before arrival, but never released
-- without confirmed stillness and cruise-OFF.
assert(drive:startMovement(vehicle,reverse))
positions[11].z=13
local diverged=drive:movementStatus(vehicle,16)
assert(diverged.isFailed and diverged.reason=="SETTLEMENT_LEG_TRAJECTORY_DIVERGED")
assert(not drive:beginSettlementStop(vehicle),
    "ordinary guide stop still requires completed arrival")
assert(drive:beginSettlementStop(vehicle,true),
    "reassessment must permit stopping an incomplete leg")
assert(not drive:stopMovement(vehicle,true),
    "reassessment must not release an unverified stop")
vehicle.lastSpeedReal=0
local alternativeStop
for i=1,6 do alternativeStop=drive:settlementStopStatus(vehicle,300) end
assert(alternativeStop.isStopped and alternativeStop.steadyMs>=1200)
assert(drive:stopMovement(vehicle,true)
    and drive.active==nil and cruise.state==0,
    "stopped reassessment releases native control and remains cruise-OFF")
positions[11].x,positions[11].z=0,0
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
assert(lastSpeed<firstSpeed
    and math.abs(lastSpeed-math.sqrt(2*1.5*0.5)*3.6)<0.02,
    "braking demand must decrease before reaching changeover")
assert(drive:cancelMovement(vehicle))
-- A headed terminal correction must not complete at the ordinary
-- 2.5m arrival band; GIANTS must receive more forward steering until
-- the separately authorised finer 0.75m arrival boundary is observed.
positions[11].x,positions[11].z=0,0
local precision={moveForwards=true,targetX=10,targetZ=0,
    arrivalRadiusM=0.75,maximumSpeedKmh=15,
    returnRegion={source="COMPLETION_SETTLEMENT_LEG"}}
assert(drive:startMovement(vehicle,precision))
assert(not drive:movementStatus(vehicle,16).isComplete)
positions[11].x=8.5
assert(not drive:movementStatus(vehicle,16).isComplete,
    "a 1.5m remainder cannot complete a precise terminal correction")
positions[11].x=9.4
assert(drive:movementStatus(vehicle,16).isComplete,
    "fine terminal guide only arrives inside its 0.75m boundary")
assert(drive:beginSettlementStop(vehicle))
vehicle.lastSpeedReal=0
for i=1,5 do drive:settlementStopStatus(vehicle,300) end
assert(drive:stopMovement(vehicle))
positions[11].x,positions[11].z=0,0
-- Interruption cannot leave cruise ACTIVE even when never stopped.
assert(drive:startMovement(vehicle,objective))
drive:movementStatus(vehicle,16)
assert(cruise.state==1)
assert(drive:cancelMovement(vehicle))
assert(cruise.state==0 and not motorRunning)
-- Native motor readback must not withhold an otherwise valid reverse
-- steering request. GIANTS can accept startMotor with nil return while
-- reporting OFF, even after completed FIELDWORK.
local originalStartMotor=vehicle.startMotor
local originalMotorRead=vehicle.getIsMotorStarted
vehicle.startMotor=function()return nil end
local previousCommands=#driveCalls
assert(drive:startMovement(vehicle,reverse))
local issued=drive:movementStatus(vehicle,16)
assert(issued.commandedDriveCount==1 and #driveCalls==previousCommands+1
    and driveCalls[#driveCalls].allowed
    and driveCalls[#driveCalls].forwards==false
    and drive.active.motorStartCallAccepted==true
    and drive.active.motorStartReply=="nil",
    "native reverse must be issued without motor-running readback")
assert(drive:cancelMovement(vehicle))
-- Missing or throwing native motor-state observation is no permission veto.
vehicle.getIsMotorStarted=function()error("readback unavailable")end
previousCommands=#driveCalls
assert(drive:startMovement(vehicle,objective))
assert(drive.active.motorWasRunningInitially=="UNKNOWN")
issued=drive:movementStatus(vehicle,16)
assert(issued.commandedDriveCount==1
    and #driveCalls==previousCommands+1
    and driveCalls[#driveCalls].forwards==true,
    "native forward guidance must continue when motor readback is unavailable")
assert(drive:cancelMovement(vehicle))
vehicle.getIsMotorStarted=originalMotorRead
vehicle.startMotor=originalStartMotor
vehicle.getIsControlled=function()return true end
local started,why=drive:startMovement(vehicle,objective)
assert(not started and why=="SETTLEMENT_CONTROL_CLAIMED_OR_CRUISE_UNAVAILABLE")
print("completion settlement native drive target/stop/cruise PASS")
