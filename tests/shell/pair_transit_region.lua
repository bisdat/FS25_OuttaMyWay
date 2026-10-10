-- TRANSIT member geometry is not productive width or a root-only polygon.
OuttaMyWay={}
dofile("scripts/coordination/ProjectedEgressRegion.lua")
dofile("scripts/coordination/PairTransitRegion.lua")
local Geometry=OuttaMyWay.PairTransitRegion
local Plan=OuttaMyWay.ProjectedEgressRegion
local points=setmetatable({},{__mode="k"})
getWorldTranslation=function(n)
    local p=assert(points[n]);return p.x,0,p.z
end
localDirectionToWorld=function(n,x,y,z)
    local p=assert(points[n]);local hx=p.headingX or p.facing or 1
    local hz=p.headingZ or 0
    return hx*z+hz*x,y,hz*z-hx*x
end
localToWorld=function(n,x,y,z)
    local p=assert(points[n]);local hx=p.headingX or p.facing or 1
    local hz=p.headingZ or 0
    return p.x+hx*z+hz*x,y,p.z+hz*z-hx*x
end
local function assembly(x,z,width,length)
    local node={};points[node]={x=x,z=z}
    local vehicle={rootNode=node,sizeWidth=width,sizeLength=length,
        getAttachedImplements=function()return {} end,
        getAISteeringNode=function(self)return self.rootNode end,
        getAIReverserNode=function(self)return self.rootNode end,
        getAIWorkAreaWidth=function()error("WORK_WIDTH_NOT_PAIR_GEOMETRY")end}
    return {x=x,z=z,vehicle=vehicle}
end
local a=assembly(48,50,3,6)
local b=assembly(52,50,3,6)
-- Snapshot productive working spans BEFORE TRANSIT. The active planning
-- pass must not ask the vehicles for deployed spans after folding.
a.workingWidthM=36
b.workingWidthM=36
-- An actual selected attachment contributes geometry even if the vehicle's
-- work-area span is unrelated. Remote XML catalogue variants never participate.
local toolNode={};points[toolNode]={x=45,z=50}
local tool={rootNode=toolNode,sizeWidth=4,sizeLength=4,
    getAttachedImplements=function()return {} end}
a.vehicle.getAttachedImplements=function()
    return {{object=tool}}
end
local fa=assert(Geometry.capture(a.vehicle))
local fb=assert(Geometry.capture(b.vehicle))
assert(fa.memberCount==2 and #fa.corners==8
    and fb.memberCount==1 and #fb.corners==4)
assert(fa.basis=="GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION"
    and fa.negativeClearanceAuthority==false)
a.transitFootprint=fa;b.transitFootprint=fb
local field={xs={0,100,100,0},zs={0,0,100,100}}
local c={fieldPolygon=field,fieldCentroid={x=50,z=50}}
local choice,mover,other=Plan.planPairCascade(c,a,b)
assert(choice and mover and other and mover~=other)
assert(choice.targetInField and choice.regionTravelM==41
    and choice.vectorDistanceM==41
    and choice.remainingWorkingWidthM==36
    and choice.workingCorridorMarginM==5
    and choice.returnRegion.requiredProgressM==41
    and choice.marginM==1
    and choice.returnRegion.source=="PAIR_WORKING_CORRIDOR_TRAVEL_REGION"
    and choice.returnRegion.isPhysicalPairClearanceConfirmed==false,
    "TS001: 36 m protected WORKING corridor + 5 m = 41 m travel")
assert(choice.cascadeAttempts>=2,
    "compare multiple spatial alternatives before selecting")
assert(choice.directionSource=="OBLIQUE_REVERSE",
    "available 70-degree reverse must outrank centroid preference")
-- TS015 head-to-head: centroid points toward the other machine,
-- but the first permitted manoeuvre is oblique withdrawal.
local headA=assembly(30,50,3,6)
local headB=assembly(43,50,3,6)
points[headB.vehicle.rootNode].facing=-1
headA.workingWidthM=36;headB.workingWidthM=36
headA.transitFootprint=assert(Geometry.capture(headA.vehicle))
headB.transitFootprint=assert(Geometry.capture(headB.vehicle))
local headChoice,headMover,headOther=Plan.planPairCascade(c,headA,headB)
assert(headChoice and headMover==headA and headOther==headB
    and headChoice.directionSource=="OBLIQUE_REVERSE"
    and headChoice.isReverse and not headChoice.moveForwards,
    "head-to-head must select 70-degree withdrawal, not forward")
local headRegion=headChoice.returnRegion
assert(headRegion.directionX*(headOther.x-headMover.x)
    +headRegion.directionZ*(headOther.z-headMover.z)<=0.001,
    "reverse direction must withdraw from the opposing assembly")
assert(math.abs(headRegion.directionX)>0.0001
    and math.abs(headRegion.directionZ)>0.0001,
    "neither assembly's straight longitudinal axis is an exit")
local r=choice.returnRegion
assert(not Plan.progress(r,r.originX,r.originZ).isInRegion)
assert(not Plan.progress(r,r.originX+2*r.directionX,
    r.originZ+2*r.directionZ).isInRegion,
    "the old 2 m movement may not complete this 41 m pair relocation")
assert(not Plan.progress(r,r.originX+40*r.directionX,
    r.originZ+40*r.directionZ).isInRegion)
assert(Plan.progress(r,r.originX+r.directionX*choice.regionTravelM,
    r.originZ+r.directionZ*choice.regionTravelM).isInRegion)
-- The distance belongs to the worker remaining in the corridor,
-- never to the moving worker. Preserve both possible mover assignments.
a.workingWidthM=12
b.workingWidthM=36
local different,moving,remaining=Plan.planPairCascade(c,a,b)
assert(different~=nil and different.regionTravelM==
    remaining.workingWidthM+5
    and different.remainingWorkingWidthM==remaining.workingWidthM
    and different.regionTravelM~=moving.workingWidthM+5,
    "relocation distance must be recomputed for the actual nonmover")
a.workingWidthM=36
b.workingWidthM=36
-- Do not veto the whole pair if one side's optional working-width capture
-- fails; the other assignment remains possible if its remaining worker
-- has a recorded width.
a.workingWidthM=nil
local partial,partialMover,partialRemaining=Plan.planPairCascade(c,a,b)
assert(partial~=nil and partialMover==a and partialRemaining==b
    and partial.regionTravelM==41)
a.workingWidthM=nil
b.workingWidthM=nil
local absent,_,__,missing=Plan.planPairCascade(c,a,b)
assert(absent==nil and missing=="NO_SAFE_PAIR_EGRESS_REGION")
a.workingWidthM=36
b.workingWidthM=36
-- An enclosed 20 m pocket may offer a short but useful FIRST relocation.
-- It is staging, never reported as complete physical conflict clearance.
local shortPocket={xs={40,60,60,40},zs={40,40,60,60}}
local staged=assert(Plan.planPairCascade({
    fieldPolygon=shortPocket,fieldCentroid={x=50,z=50}},a,b))
assert(staged.isPartialEgress and staged.regionTravelM>=2
    and staged.regionTravelM<41
    and staged.returnRegion.requiredProgressM==staged.regionTravelM
    and not staged.returnRegion.isPhysicalPairClearanceConfirmed,
    "field limit must allow useful partial movement without claiming clearance")
-- For perpendicular native headings, broad non-axial sectors exist. The
-- previous 'lateral to BOTH' test admitted literally no such direction.
local crossingA=assembly(39,42,3,6)
local crossingB=assembly(55,58,3,6)
points[crossingB.vehicle.rootNode].headingX=0
points[crossingB.vehicle.rootNode].headingZ=1
crossingA.workingWidthM=36;crossingB.workingWidthM=36
crossingA.transitFootprint=assert(Geometry.capture(crossingA.vehicle))
crossingB.transitFootprint=assert(Geometry.capture(crossingB.vehicle))
local crossing,moved,remains=Plan.planPairCascade(c,crossingA,crossingB)
assert(crossing and moved and remains and moved~=remains
    and crossing.regionTravelM>=3,
    "crossing-axis pair must discover usable egress rather than reject all")
local moveDirection=crossing.returnRegion
local otherNode=remains.vehicle.rootNode
local otherHeading=assert(points[otherNode])
local fx=otherHeading.headingX or otherHeading.facing or 1
local fz=otherHeading.headingZ or 0
assert(math.abs(moveDirection.directionX*fx+
    moveDirection.directionZ*fz)<math.cos(math.rad(12)),
    "discovered egress must not align with the other assembly's axis")
-- An in-field root is NOT sufficient when any attached-member corner
-- starts outside the polygon; reject all unsupported swept paths.
local narrow={xs={48,52,52,48},zs={49,49,51,51}}
local none,_,__,reason=Plan.planPairCascade({
    fieldPolygon=narrow,fieldCentroid={x=50,z=50}},a,b)
assert(none==nil and reason=="NO_SAFE_PAIR_EGRESS_REGION")
-- A known third vehicle's physical region must restrict candidate routes;
-- do not treat the common field as empty merely because pair roots fit.
local third=assembly(50,50,85,85)
g_currentMission={vehicles={a.vehicle,b.vehicle,tool,third.vehicle}}
local occluded=Plan.planPairCascade(c,a,b)
assert(occluded==nil,"other known vehicles must veto overlapping regions")
g_currentMission={vehicles={a.vehicle,b.vehicle,tool}}
assert(Plan.planPairCascade(c,a,b),
    "an attached implement already represented in a pair must not masquerade as an independent third-party obstacle")
g_currentMission=nil
-- Missing complete member size is not replaced by productive width or a
-- fabricated fallback, even if the worker root alone is valid.
local noSize=assembly(30,30,nil,nil)
local invalid,why=Geometry.capture(noSize.vehicle)
assert(invalid==nil and why=="TRANSIT_MEMBER_SIZE_UNAVAILABLE")
-- A second foldable implementation may be associated via loaded native XML.
local xmlNode={};points[xmlNode]={x=40,z=40}
local xml={
    getValue=function(_,key)
        local v={["vehicle.base.size#width"]=5,
            ["vehicle.base.size#length"]=9,
            ["vehicle.base.size#widthOffset"]=2,
            ["vehicle.base.size#lengthOffset"]=1}
        return v[key]
    end}
local actual=assert(Geometry.capture({
    rootNode=xmlNode,xmlFile=xml,
    getAttachedImplements=function()return {} end
}))
assert(actual.memberCount==1 and actual.corners[1].x~=nil)
print("Paired TRANSIT region, head-on, crossing and partial egress: PASS")
