-- TEST 0.5.5.9: completion settlement selects a nearby reachable
-- nominal parking REGION, from the actual vehicle pose (never a far endpoint).
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local originalX={131.79,143.52,153.81,162.43,165.16,165.55,175.32,
    182.15,228.15,-0.06,-10.56,-40.20}
local originalZ={-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,
    -480.63,-468.38,-243.04,-207.44,-343.82,-677.42}
local source={densityMapPolygon={pointsX=originalX,pointsZ=originalZ},
    fieldId=77}
local neighbor={densityMapPolygon={pointsX={
    -100,300,300,-100},pointsZ={-198,-198,-120,-120}},fieldId=88}
local edge=G.edges(assert(G.polygonFor(source)))[9]
g_fieldManager={fields={[77]=source,[88]=neighbor},
    getFieldById=function(_,id)return g_fieldManager.fields[id] end}
local current={x=201.478,z=-256.684,fx=0.987846,fz=-0.155355}
local vehicle={rootNode=111}
getWorldTranslation=function()
    return current.x,0,current.z
end
localDirectionToWorld=function(_,x,_,z)
    if x==0 and z==1 then return current.fx,0,current.fz end
    return current.fz*x+current.fx*z,0,-current.fx*x+current.fz*z
end
OuttaMyWay.PairTransitRegion={
    capture=function()
        local lateralX,lateralZ=-current.fz,current.fx
        local corners={}
        for _,side in ipairs({-1,1}) do
            for _,front in ipairs({-1,1}) do
                corners[#corners+1]={x=lateralX*1.2*side+
                    current.fx*2.5*front,
                    z=lateralZ*1.2*side+current.fz*2.5*front}
            end
        end
        return {rootX=current.x,rootZ=current.z,
            corners=corners,memberCount=1}
    end
}
dofile("scripts/coordination/CompletionSettlementRoute.lua")
local Route=OuttaMyWay.CompletionSettlementRoute
local a,err=Route.plan(vehicle)
assert(a,err)
assert(a.field==77 and a.edge==9)
assert(a.method=="REVERSE_FORWARD" or a.method=="FORWARD_J")
assert(#a.legs>1 and #a.legs<=55,
    "guidance should have a finite, short target list")
assert(a.estimatedTravelM<120,
    "nearby parking must not require 200-metre edge traversal")
local prev={x=current.x,z=current.z}
local lastDir=nil
local switches=0
local reversePoints=0
for i=1,#a.legs do
    local leg=a.legs[i]
    assert(type(leg.moveForwards)=="boolean")
    local distance=math.sqrt((leg.point.x-prev.x)^2+
        (leg.point.z-prev.z)^2)
    assert(distance<=5.2 and distance>=0.5,
        "GIANTS must only be sent local reachable steering points")
    if lastDir~=nil and lastDir~=leg.moveForwards then
        switches=switches+1
    end
    if not leg.moveForwards then reversePoints=reversePoints+1 end
    lastDir=leg.moveForwards
    prev=leg.point
end
assert(switches<=1 and a.legs[#a.legs].moveForwards,
    "at most brief reverse then forwards, never full-edge reversing")
assert(a.reverseM<=32)
-- The end of the chosen manoeuvre must be a REAL entire-member region
-- witness, not an assumed far point. The idealised plan ended edge-parallel.
current.x,current.z=prev.x,prev.z
current.fx,current.fz=edge.dx/edge.length*a.direction,
    edge.dz/edge.length*a.direction
local finished,reason=Route.verifyTerminal(vehicle,a)
assert(finished,reason)
assert(Route.guard(vehicle,a))
-- Test a *different completing pose* chooses a different terminal position.
local first={x=current.x,z=current.z}
current.x,current.z,current.fx,current.fz=
    141,-252,0.987846,-0.155355
local b,why=Route.plan(vehicle)
assert(b,why)
assert(#b.legs>1 and b.estimatedTravelM<120)
local dest=b.legs[#b.legs].point
assert(math.sqrt((dest.x-first.x)^2+(dest.z-first.z)^2)>10,
    "different completion poses should not share one far endpoint")
-- Both poses must remain well short of the full selected 230-m edge.
assert(a.estimatedTravelM<edge.length*.55)
assert(b.estimatedTravelM<edge.length*.55)
-- The field fixture does not secretly admit another polygon.
current.x,current.z=900,900
assert(Route.plan(vehicle)==nil)
print("completion settlement pose-conditioned parking region PASS")
