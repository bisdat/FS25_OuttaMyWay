-- Archive non-job physical donor; this fixture never grants relocation authority.
OuttaMyWay={}
MotorState={OFF=0,IGNITION=1,STARTING=2,ON=3}
Drivable={CRUISECONTROL_STATE_OFF=0}
dofile("scripts/observation/CurrentPlayerControlObservation.lua")
dofile("scripts/control/mechanisms/NonJobActuationMechanism.lua")
local state,running,ai,claimed=MotorState.OFF,false,false,false
local starts,stops,moves,neutralized=0,0,0,0
local motor={getMaximumForwardSpeed=function() return 10 end}
local vehicle={rootNode=101,forceIsActive=false,rotatedTime=0.1,
    motor="prior",cruiseControl="prior",
    getRootVehicle=function(self) return self end,
    getIsControlled=function() return claimed end,
    getIsAIActive=function() return ai end,
    getIsMotorStarted=function() return running end,
    getMotorState=function() return state end,
    getCanMotorRun=function() return true end,
    startMotor=function() starts=starts+1;state=MotorState.ON;running=true end,
    stopMotor=function() stops=stops+1;state=MotorState.OFF;running=false end,
    getMotor=function() return motor end,
    getCruiseControlState=function() return 1 end,
    getAISteeringNode=function() return 101 end,
    brake=function() end,stopVehicle=function() end,
    setCruiseControlState=function(_,v) assert(v==0) end}
g_currentMission={controlledVehicle=nil}
getWorldTranslation=function(node)assert(node==101);return 100,0,50 end
localDirectionToWorld=function(_,x,y,z)return x,y,z end
worldDirectionToLocal=function(_,x,y,z)return x,y,z end
AIVehicleUtil={driveInDirection=function(v,dt,rot,accel,slow,maxRot,allowed,
    forwards,lx,lz,speed,extra)
    assert(v==vehicle and v.motor==motor and v.cruiseControl.state==1)
    assert(forwards and lx==1 and lz==0 and speed==12)
    moves=moves+1
end}
WheelsUtil={updateWheelsPhysics=function(v) assert(v==vehicle);neutralized=neutralized+1 end}
local m=OuttaMyWay.NonJobActuationMechanism.new()
assert(not m:isPlayerControlled(vehicle) and not m:isSourceReactivated(vehicle))
assert(m:position(vehicle).x==100 and m:heading(vehicle).z==1)
assert(m:maximumForwardSpeedKmh(vehicle)==36)
local ok,activity=m:acquireVehicleActivityContext(vehicle)
assert(ok and vehicle.forceIsActive)
local started,context=m:acquirePropulsionContext(vehicle)
assert(started and context.startedByOuttaMyWay and starts==1)
assert(m:propulsionReadiness(vehicle,context)=="READY")
local drove=m:driveInWorldDirection(vehicle,16,1,0,12)
assert(drove and moves==1 and vehicle.motor=="prior" and vehicle.cruiseControl=="prior")
assert(m:neutralize(vehicle,16) and neutralized==1)
assert(m:releasePropulsionContext(vehicle,context) and stops==1 and not running)
assert(m:releaseVehicleActivityContext(vehicle,activity) and not vehicle.forceIsActive)
g_currentMission.controlledVehicle=vehicle
assert(m:isPlayerControlled(vehicle))
local denied,reason=m:driveInWorldDirection(vehicle,16,1,0,12)
assert(not denied and reason=="PLAYER_CONTROL" and moves==1)
g_currentMission.controlledVehicle=nil
claimed=true
assert(m:isPlayerControlled(vehicle))
claimed=false
ai=true
assert(m:isSourceReactivated(vehicle))
denied,reason=m:driveInWorldDirection(vehicle,16,1,0,12)
assert(not denied and reason=="SOURCE_INTENT_REACTIVATED" and moves==1)
denied,reason=m:acquirePropulsionContext(vehicle)
assert(not denied and reason=="SOURCE_INTENT_REACTIVATED")
print("Non-job physical donor / current authority contract: PASS")
