-- TEST .30: blocker width 36 + margin 5 -> 41 m oblique vector.
OuttaMyWay={}
dofile("scripts/coordination/ProjectedEgressRegion.lua")
local Plan=OuttaMyWay.ProjectedEgressRegion
local field={xs={0,200,200,0},zs={0,0,200,200}}
local dirs={}
localDirectionToWorld=function(n,x,y,z)
    local a=assert(dirs[n]);return a.x*z,y,a.z*z
end
local function worker(x,z,fx,fz)
    local node={};dirs[node]={x=fx,z=fz}
    return {x=x,z=z,vehicle={
        getAIReverserNode=function()return node end,
        getAISteeringNode=function()return node end
    }}
end
local mover=worker(100,100,0,1)
local blocker=worker(100,108,0,-1)
local c={fieldCentroid={x=50,z=100},fieldPolygon=field,blockerWorkingWidthM=36}
local a,why=Plan.plan(c,mover,blocker)
assert(a,why)
assert(a.directionSource=="OBLIQUE_REVERSE" and a.vectorDistanceM==41
    and a.blockerWorkingWidthM==36 and a.marginM==5)
assert(a.egressSide==-1 and a.targetInField)
assert(math.abs(a.returnRegion.requiredProgressM-41*math.sin(math.rad(70)))<0.0001)
assert(a.steeringHorizonM==81 and a.targetX<100 and a.targetZ<100)
local region=a.returnRegion
assert(not Plan.progress(region,100,20).isInRegion,
    "axial reverse must not satisfy lateral region")
assert(not Plan.progress(region,100+40*region.directionX,
    100+40*region.directionZ).isInRegion)
assert(Plan.progress(region,100+41*region.directionX,
    100+41*region.directionZ).isInRegion)
assert(Plan.progress(region,55,100).isInRegion,
    "lateral region is not a fixed arrival waypoint")
local near=worker(18,100,0,1)
local nearBlocker=worker(18,108,0,-1)
local opposite=assert(Plan.plan({fieldCentroid={x=1,z=100},
    fieldPolygon=field,blockerWorkingWidthM=36},near,nearBlocker))
assert(opposite.egressSide==1 and opposite.targetInField,
    "prefer reachable in-field region to left-rear preference")
local noWidth,code=Plan.plan({fieldCentroid={x=50,z=100},
    fieldPolygon=field},mover,blocker)
assert(noWidth==nil and code=="BLOCKER_WORK_WIDTH_UNAVAILABLE")
local small={xs={0,30,30,0},zs={0,0,30,30}}
local confined=worker(15,10,0,1)
local confinedBlocker=worker(15,18,0,-1)
local none,reason=Plan.plan({fieldCentroid={x=15,z=15},
    fieldPolygon=small,blockerWorkingWidthM=36},confined,confinedBlocker)
assert(none==nil and reason=="NO_SUPPORTED_INFIELD_EGRESS_REGION")
print("Cross-track egress, 41 m vector, in-field side and region: PASS")
