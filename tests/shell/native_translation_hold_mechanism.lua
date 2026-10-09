-- Dormant GIANTS translation gate challenged against an explicit mocked native drive.
OuttaMyWay={}
dofile("scripts/control/mechanisms/NativeTranslationHoldMechanism.lua")
local Mechanism=OuttaMyWay.NativeTranslationHoldMechanism
local events={}
local native=function(vehicle,dt,acceleration,allowed,forwards,x,z,speed,doNotSteer)
    events[#events+1]={
        vehicle=vehicle,dt=dt,acceleration=acceleration,allowed=allowed,
        forwards=forwards,x=x,z=z,speed=speed,doNotSteer=doNotSteer
    }
    return "GIANTS_NATIVE_RETURN"
end
AIVehicleUtil={driveToPoint=native}
local coords={[9901]={x=1,z=2},[9902]={x=20,z=21}}
getWorldTranslation=function(node)
    local p=coords[node]
    assert(p)
    return p.x,0,p.z
end
g_server={}
g_currentMission={controlledVehicle=nil}
local alpha={name="A",job={},rootNode=9901}
local bravo={name="B",job={},rootNode=9902}
local charlie={name="C",job={},rootNode=9903}
for _,vehicle in ipairs({alpha,bravo,charlie}) do
    vehicle.getJob=function(self) return self.job end
    vehicle.getIsControlled=function(self) return self.isControlled==true end
end
local mechanism=Mechanism.new()
local originalPermissions=function() return true,false,nil end
alpha.getCanAIFieldWorkerContinueWork=originalPermissions
local ok,evidence=mechanism:hold(alpha,"EGRESS")
assert(ok and evidence.isGateArmed and not evidence.isVehicleStoppedConfirmed)
assert(alpha.getCanAIFieldWorkerContinueWork==originalPermissions,
    "field-worker continuation permission must remain entirely unmodified")
assert(mechanism:isHolding(alpha))
assert(not mechanism:hold(alpha,"EGRESS"),"duplicate Hold is rejected")
ok=mechanism:hold(bravo,"EGRESS")
assert(ok,"independent blocker Holds coexist")
assert(AIVehicleUtil.driveToPoint~=native)
local result=AIVehicleUtil.driveToPoint(charlie,16,1,true,true,5,8,17,true)
assert(result=="GIANTS_NATIVE_RETURN")
assert(events[1].vehicle==charlie and events[1].acceleration==1
    and events[1].allowed==true and events[1].speed==17
    and events[1].doNotSteer==true)
result=AIVehicleUtil.driveToPoint(alpha,16,1,true,false,3,14,22,true)
assert(result=="GIANTS_NATIVE_RETURN")
assert(events[2].vehicle==alpha and events[2].acceleration==0
    and events[2].allowed==false and events[2].speed==0
    and events[2].forwards==false and events[2].x==3 and events[2].z==14
    and events[2].doNotSteer==true,
    "Hold changes only translation permission/speed; not native steering or direction")
assert(mechanism:getHoldEvidence(alpha).interceptionCount==1)
assert(not mechanism:getHoldEvidence(alpha).isVehicleStoppedConfirmed)
local releaseOk,reason=mechanism:releaseHold(alpha,"RELOCATED_WORKER")
assert(not releaseOk and reason=="HOLD_PURPOSE_MISMATCH")
assert(mechanism:isHolding(alpha))
coords[9901]={x=1.5,z=2}
releaseOk,evidence=mechanism:releaseHold(alpha,"EGRESS")
assert(releaseOk and evidence.isRestrictionRemoved
    and evidence.interceptionCount==1
    and math.abs(evidence.physicalDisplacementM-0.5)<0.001)
assert(not mechanism:isHolding(alpha))
assert(AIVehicleUtil.driveToPoint~=native,"B remains Held")
AIVehicleUtil.driveToPoint(alpha,16,1,true,true,7,9,18,false)
assert(events[3].allowed==true and events[3].speed==18 and events[3].x==7)
releaseOk,evidence=mechanism:releaseHold(bravo,"EGRESS")
assert(releaseOk and evidence.isNativeFunctionRestored)
assert(AIVehicleUtil.driveToPoint==native,"restore direct native function after last release")
releaseOk,evidence=mechanism:releaseHold(bravo,"EGRESS")
assert(releaseOk and not evidence.wasHeld,"idempotent cleanup after uncertain command")
-- No player-control / takeover judgement belongs to this mechanism.
-- Even a mission-controlled root and throwing getter must not be queried.
-- The independent native job and server lifecycle still own release.
local originalControlGetter=alpha.getIsControlled
alpha.getIsControlled=function()error("FORBIDDEN_PLAYER_QUERY") end
g_currentMission.controlledVehicle=alpha
assert(mechanism:hold(alpha,"RELOCATED_WORKER"))
AIVehicleUtil.driveToPoint(alpha,16,1,true,true,1,2,9,nil)
assert(events[#events].allowed==false and events[#events].speed==0)
assert(mechanism:isHolding(alpha),"no takeover-triggered Hold release")
g_currentMission.controlledVehicle=nil
AIVehicleUtil.driveToPoint(alpha,16,1,true,true,1,2,9,nil)
assert(events[#events].allowed==false and events[#events].speed==0)
assert(mechanism:releaseHold(alpha,"RELOCATED_WORKER"))
assert(AIVehicleUtil.driveToPoint==native)
alpha.getIsControlled=originalControlGetter
alpha.job=nil
local releaseOk,reason=mechanism:hold(alpha,"EGRESS")
assert(not releaseOk and reason=="NATIVE_JOB_UNAVAILABLE")
alpha.job={}
-- A different non-null GIANTS job is a new episode, not continued permission
-- to suppress the original job's native translation commands.
assert(mechanism:hold(alpha,"EGRESS"))
local previousJob=alpha.job
alpha.job={}
AIVehicleUtil.driveToPoint(alpha,16,1,true,true,3,4,12,true)
assert(events[#events].allowed==true and events[#events].speed==12
    and events[#events].doNotSteer==true)
assert(not mechanism:isHolding(alpha),"job replacement revokes old Hold")
assert(AIVehicleUtil.driveToPoint==native,
    "job-replacement relinquishment restores the original native drive entry")
assert(mechanism:releaseHold(alpha,"EGRESS"))
alpha.job=previousJob
-- The mechanism must never replace a different outer wrapper during release.
assert(mechanism:hold(alpha,"EGRESS"))
local active=AIVehicleUtil.driveToPoint
local outer=function(...) return active(...) end
AIVehicleUtil.driveToPoint=outer
assert(mechanism:releaseHold(alpha,"EGRESS"))
assert(AIVehicleUtil.driveToPoint==outer,
    "release may not clobber another mod's later native drive wrapper")
assert(not mechanism:hold(alpha,"EGRESS"),
    "cannot establish another Hold if the existing intercept path is unverifiable")
AIVehicleUtil.driveToPoint=active
assert(mechanism:hold(alpha,"EGRESS"))
assert(mechanism:releaseHold(alpha,"EGRESS"))
assert(AIVehicleUtil.driveToPoint==native)
-- Client calls must fail before altering native functions.
g_server=nil
releaseOk,reason=mechanism:hold(alpha,"EGRESS")
assert(not releaseOk and reason=="SERVER_REQUIRED")
assert(AIVehicleUtil.driveToPoint==native)
print("Native translation-only Hold / timers delegated / safe lease release: PASS")
