-- Native 1 km/h speed cap: route and permission stay GIANTS-owned.
OuttaMyWay={}
dofile("scripts/control/mechanisms/NativeSpeedRegulationMechanism.lua")
local Mechanism=OuttaMyWay.NativeSpeedRegulationMechanism
local events={}
local native=function(vehicle,dt,accel,allowed,forwards,lx,lz,speed,doNotSteer)
    events[#events+1]={vehicle=vehicle,dt=dt,accel=accel,allowed=allowed,
        forwards=forwards,lx=lx,lz=lz,speed=speed,doNotSteer=doNotSteer}
    return "NATIVE"
end
AIVehicleUtil={driveToPoint=native}
g_server={}
local pos={[1]={x=0,z=0},[2]={x=8,z=0}}
getWorldTranslation=function(node)
    local p=assert(pos[node]);return p.x,0,p.z
end
local a={rootNode=1,job={}}
local b={rootNode=2,job={}}
for _,v in ipairs({a,b}) do v.getJob=function(self)return self.job end end
local m=Mechanism.new()
local ok,e=m:regulate(a,"EGRESS")
assert(ok and e.isRegulationArmed and e.maxSpeedKmh==1)
assert(not m:regulate(a,"EGRESS"),"duplicate regulation rejected")
assert(m:regulate(b,"EGRESS"),"independent other-worker leases coexist")
local unrelated={}
assert(AIVehicleUtil.driveToPoint(unrelated,16,1,true,true,3,4,25,true)=="NATIVE")
local u=events[#events]
assert(u.speed==25 and u.accel==1 and u.allowed and u.doNotSteer)
assert(AIVehicleUtil.driveToPoint(a,16,0.75,true,false,0.4,-0.8,15,true)=="NATIVE")
local v=events[#events]
assert(v.speed==1 and v.accel==0.75 and v.allowed
    and v.forwards==false and v.lx==0.4 and v.lz==-0.8 and v.doNotSteer)
AIVehicleUtil.driveToPoint(a,16,1,false,true,0.9,0.1,0,false)
v=events[#events]
assert(v.speed==0 and not v.allowed and v.accel==1,
    "native zero permission is not upgraded by Regulation")
assert(m.leases[a].interceptCount==2)
local inner=AIVehicleUtil.driveToPoint
local outer=function(...)return inner(...) end
AIVehicleUtil.driveToPoint=outer
pos[1]={x=0.2,z=0}
ok,e=m:releaseRegulation(a,"EGRESS")
assert(ok and e.wasRegulated and e.interceptionCount==2
    and math.abs(e.physicalDisplacementM-0.2)<0.0001)
assert(AIVehicleUtil.driveToPoint==outer,"do not overwrite outer reverser")
assert(m:releaseRegulation(b,"EGRESS"))
assert(AIVehicleUtil.driveToPoint==outer,"transparent inner lease persists until outer finishes")
AIVehicleUtil.driveToPoint=inner
m:refreshInstallation()
assert(AIVehicleUtil.driveToPoint==native,"cleanup restores native drive after reverse unhooks")
assert(m:regulate(a,"EGRESS"))
a.job={}
AIVehicleUtil.driveToPoint(a,16,1,true,true,0,1,15,false)
assert(events[#events].speed==15,"new native Job Episode not subject to old cap")
assert(m.count==0 and AIVehicleUtil.driveToPoint==native)
g_server=nil
assert(not m:regulate(a,"EGRESS"))
print("Native 1 km/h Regulation / GIANTS route preservation / scoped cleanup: PASS")
