-- Subordinate native reverse evidence under a mocked GIANTS drive path; not in-game validation.
OuttaMyWay={}
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
local vehicle={
    rootNode=1,
    getAISteeringNode=function() return 3 end,
    getAIReverserNode=function() return 2 end
}
local objective={targetX=0,targetZ=-10,maxTravelM=10,steeringHorizonM=40,isReverse=true}
local mechanism=Mechanism.new()
local ok,armed=mechanism:startReverse(vehicle,objective)
assert(ok and armed.kind=="REVERSE_ARMED" and armed.isPhysicalMotionConfirmed==false)
assert(AIVehicleUtil.driveToPoint~=native)
local unrelated={}
AIVehicleUtil.driveToPoint(unrelated,16,1,true,true,7,9,19,true)
assert(calls[1].vehicle==unrelated and calls[1].doNotSteer==true
    and calls[1].lx==7 and calls[1].lz==9 and calls[1].forwards==true,
    "unrelated native call, including optional ninth argument, is unchanged")
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,20,1,0,true)
assert(calls[2].vehicle==vehicle and calls[2].allowed==true
    and calls[2].forwards==false and calls[2].speed==8
    and calls[2].doNotSteer==false,
    "owned call uses native reverse steering despite blocked native input")
assert(math.abs(calls[2].lx)<1e-5 and calls[2].lz<0)
assert(mechanism:reverseStatus(vehicle).commandedDriveCount==1)
assert(not mechanism:stopReverse(vehicle),"issuing drive must not complete movement")
locations[1].z=-9.5
local status=mechanism:reverseStatus(vehicle)
assert(status.isComplete and status.travelledM==9.5 and status.isFailed==false)
assert(mechanism:stopReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native,"completed lease restores original native call")
-- A second objective starts a new displacement sample and cannot borrow completion.
locations[1].z=0
assert(mechanism:startReverse(vehicle,objective))
assert(not mechanism:startReverse(vehicle,objective),"only one leased reverse movement")
AIVehicleUtil.driveToPoint(vehicle,16,0,false,true,1,1,0,false)
locations[1].z=-11
status=mechanism:reverseStatus(vehicle)
assert(status.isFailed and status.reason=="REVERSE_BOUND_EXCEEDED")
assert(not mechanism:stopReverse(vehicle))
assert(mechanism:cancelReverse(vehicle))
assert(AIVehicleUtil.driveToPoint==native)
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
-- Without server permission nothing installs and native calls remain unchanged.
g_server=nil
started,reason=mechanism:startReverse(vehicle,objective)
assert(not started and reason=="SERVER_REQUIRED")
assert(AIVehicleUtil.driveToPoint==native)
assert(OuttaMyWay.runtime==nil,"no Control runtime activation")
print("Dormant native reverse / tool correction / measured travel / passthrough: PASS")
