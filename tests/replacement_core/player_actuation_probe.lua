local root=arg[1] or "."
OuttaMyWay={}

local publications={}
OuttaMyWay.LogPublication={
    origin=function()
        return {
            info=function(_,publicationClass,code,formatText,...)
                publications[#publications+1]={
                    publicationClass=publicationClass,
                    code=code,
                    text=string.format(formatText,...)
                }
                return true
            end
        }
    end
}

Utils={}
function Utils.appendedFunction(original,appended)
    return function(...)
        local results={original(...)}
        appended(...)
        return unpack(results)
    end
end

local originalAccelerateCalls=0
local originalBrakeCalls=0
local originalSteerCalls=0
Drivable={
    actionEventAccelerate=function() originalAccelerateCalls=originalAccelerateCalls+1 end,
    actionEventBrake=function() originalBrakeCalls=originalBrakeCalls+1 end,
    actionEventSteer=function() originalSteerCalls=originalSteerCalls+1 end
}
Motorized={
    actionEventToggleMotorState=function() end,
    actionEventSetMotorStateIgnition=function() end,
    actionEventSetMotorStateOn=function() end,
    actionEventSetMotorStateOff=function() end
}

g_time=1000
g_currentMission={missionInfo={automaticMotorStartEnabled=false}}

local vehicle={
    rootNode=1,lastSpeedReal=0,
    spec_drivable={lastInputValues={},axisForward=0,axisSide=0,doHandbrake=false},
    getRootVehicle=function(self) return self end,
    getIsEntered=function() return true end,
    getIsControlled=function() return true end,
    getIsAIActive=function() return false end,
    getIsMotorStarted=function() return false end,
    getMotorState=function() return 0 end
}

OuttaMyWay.obstructionRelocationControl={
    active={
        vehicle=vehicle,
        commitmentId="CM-TEST",
        assemblyId="AS-TEST",
        assemblyReferenceKey="REF-TEST"
    }
}

dofile(root.."/scripts/diagnostics/PlayerActuationProbe.lua")

assert(OuttaMyWay.PlayerActuationProbe.suppressesEnteredClaim()==true)

-- Zero input is intentionally quiet.
Drivable.actionEventAccelerate(vehicle,"AXIS_ACCELERATE_VEHICLE",0,"CONTINUOUS",true)
assert(originalAccelerateCalls==1)
assert(#publications==0)

-- First non-zero input publishes causal evidence even with the motor stopped.
Drivable.actionEventAccelerate(vehicle,"AXIS_ACCELERATE_VEHICLE",0.4,"CONTINUOUS",true)
assert(originalAccelerateCalls==2)
assert(#publications==1)
assert(publications[1].code=="PLAYER_ACTUATION_PROBE")
assert(string.find(publications[1].text,"action=ACCELERATE",1,true)~=nil)
assert(string.find(publications[1].text,"inputAction=AXIS_ACCELERATE_VEHICLE",1,true)~=nil)
assert(string.find(publications[1].text,"motorStarted=false",1,true)~=nil)
assert(string.find(publications[1].text,"claimAuthority=false",1,true)~=nil)

-- Held input is rate-limited but a release is published.
Drivable.actionEventAccelerate(vehicle,"AXIS_ACCELERATE_VEHICLE",0.4,"CONTINUOUS",true)
assert(#publications==1)
g_time=1100
Drivable.actionEventAccelerate(vehicle,"AXIS_ACCELERATE_VEHICLE",0,"CONTINUOUS",true)
assert(#publications==2)

-- Independent brake/steer and explicit motor commands are observed.
g_time=1200
Drivable.actionEventBrake(vehicle,"AXIS_BRAKE_VEHICLE",1,"CONTINUOUS",false)
Drivable.actionEventSteer(vehicle,"AXIS_MOVE_SIDE_VEHICLE",-0.5,"CONTINUOUS",true,false,2,"binding")
Motorized.actionEventToggleMotorState(vehicle,"TOGGLE_MOTOR_STATE",1,"PRESSED",false)
assert(originalBrakeCalls==1)
assert(originalSteerCalls==1)
assert(#publications==5)
assert(string.find(publications[3].text,"action=BRAKE",1,true)~=nil)
assert(string.find(publications[4].text,"action=STEER",1,true)~=nil)
assert(string.find(publications[5].text,"action=MOTOR_TOGGLE",1,true)~=nil)

print("PASS player actuation diagnostic probe")
