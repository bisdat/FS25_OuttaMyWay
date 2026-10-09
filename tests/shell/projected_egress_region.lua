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
assert(a.egressSide==-1 and a.targetInField and a.fieldInteriorScore>0)
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
-- Both sides fit the polygon: prioritize field-inward direction even if
-- the historical same-side preference would choose the outward one.
local inwardMover=worker(100,100,0,1)
local offsetBlocker=worker(110,108,0,-1)
local inward=assert(Plan.plan({fieldCentroid={x=170,z=100},
    fieldPolygon=field,blockerWorkingWidthM=36},inwardMover,offsetBlocker))
assert(inward.egressSide==1 and inward.fieldInteriorScore>0)
-- Nominal 41 m is not a literal. Only the 5 m margin is fixed.
local narrower=assert(Plan.plan({fieldCentroid={x=50,z=100},
    fieldPolygon=field,blockerWorkingWidthM=24},mover,blocker))
assert(narrower.vectorDistanceM==29 and narrower.blockerWorkingWidthM==24)
local noWidth,code=Plan.plan({fieldCentroid={x=50,z=100},
    fieldPolygon=field},mover,blocker)
assert(noWidth==nil and code=="BLOCKER_WORK_WIDTH_UNAVAILABLE")
local small={xs={0,30,30,0},zs={0,0,30,30}}
local confined=worker(15,10,0,1)
local confinedBlocker=worker(15,18,0,-1)
local none,reason=Plan.plan({fieldCentroid={x=15,z=15},
    fieldPolygon=small,blockerWorkingWidthM=36},confined,confinedBlocker)
assert(none==nil and reason=="NO_SUPPORTED_INFIELD_EGRESS_REGION")
-- Solo objective needs only native pose and reverse heading. Field membership
-- is never an admission or relocation requirement.
g_fieldManager=nil
local solo=assert(Plan.planSingle({singleRegionDistanceM=40},mover))
assert(solo.egressSide==-1 and solo.targetInField==false,
    "no field evidence cannot prevent fixed solo recovery")
assert(solo.vectorDistanceM==40 and solo.steeringHorizonM==80)
assert(solo.directionSource=="SINGLE_OBLIQUE_REVERSE"
    and solo.blockerWorkingWidthM==nil and solo.marginM==nil)
assert(solo.returnRegion.source=="SINGLE_REVERSE_REGION"
    and solo.returnRegion.requiredProgressM==40)
local rr=solo.returnRegion
local initialX,initialZ=rr.originX,rr.originZ
assert(not Plan.progress(rr,initialX,initialZ-40).isInRegion,
    "axial movement is not a solo oblique return region")
assert(not Plan.progress(rr,initialX+39*rr.directionX,
    initialZ+39*rr.directionZ).isInRegion)
assert(Plan.progress(rr,initialX+40*rr.directionX,
    initialZ+40*rr.directionZ).isInRegion)
assert(Plan.progress(rr,initialX+41*rr.directionX+2*rr.directionZ,
    initialZ+41*rr.directionZ-2*rr.directionX).isInRegion,
    "entering the region is not an exact steering-point arrival")
local confinedSolo=assert(Plan.planSingle({singleRegionDistanceM=40},confined))
assert(confinedSolo.vectorDistanceM==40
    and confinedSolo.returnRegion.requiredProgressM==40,
    "small fields cannot veto native solo BWR")

-- Test identity, not proximity: adjacent fields can contain reverse endpoints.
-- Only the active worker's GIANTS-generated course may identify OUR field.
local function ownField(points)
    return {singleRegionDistanceM=40,participants={{
        sourceStrategyReference={aiFieldCourse={fieldCourse={
            courseField={boundaryPositions=points}}}}
    }}}
end
local sourceLeft=ownField({
    {0,0},{200,0},{200,200},{0,200}})
local adjacentRight=ownField({
    {200,0},{400,0},{400,200},{200,200}})
g_fieldManager={fields={{densityMapPolygon={
    pointsX={200,400,400,200},pointsZ={0,0,200,200}}}}}
local outsideRight=worker(210,100,0,1)
local inwardRight=assert(Plan.planSingle(sourceLeft,outsideRight))
assert(inwardRight.egressSide==-1 and inwardRight.targetInField==true
    and inwardRight.fieldIdentitySource=="GIANTS_ACTIVE_COURSE_FIELD",
    "right-side worker must return to its OWN field, not adjacent field")
local adjacentCandidate=assert(Plan.planSingle(adjacentRight,outsideRight))
assert(adjacentCandidate.egressSide==1
    and adjacentCandidate.fieldIdentitySource=="GIANTS_ACTIVE_COURSE_FIELD",
    "same position with different assigned course gives different ownership")
local outsideLeft=worker(-10,100,0,1)
local inwardLeft=assert(Plan.planSingle(sourceLeft,outsideLeft))
assert(inwardLeft.egressSide==1 and inwardLeft.targetInField==true,
    "left-edge exterior origin selects own-field inward region")

-- GIANTS stores the chosen field detection point even when the course
-- boundary is unavailable. It remains a directional source, never a gate.
local nativeDetection={singleRegionDistanceM=40,participants={{
    sourceStrategyReference={fieldDetectionX=100,fieldDetectionZ=100}
}}}
local viaDetection=assert(Plan.planSingle(nativeDetection,outsideRight))
assert(viaDetection.egressSide==-1
    and viaDetection.fieldIdentitySource=="GIANTS_FIELD_DETECTION_POSITION")
g_fieldManager.fields={}
local unassociated=assert(Plan.planSingle({singleRegionDistanceM=40},outsideLeft))
assert(unassociated.egressSide==-1 and unassociated.targetInField==false
    and unassociated.fieldIdentitySource=="NO_NATIVE_FIELD_REFERENCE",
    "absence of native course field must not inhibit 40 m relocation")
print("Pairwise cross-track and solo 40 m projected return region: PASS")
