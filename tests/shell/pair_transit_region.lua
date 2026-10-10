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
    return z,y,-x
end
localToWorld=function(n,x,y,z)
    local p=assert(points[n])
    return p.x+z,y,p.z-x
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
assert(choice.targetInField and choice.regionTravelM>=2
    and choice.marginM==1
    and choice.returnRegion.source=="SIGNED_CROSS_TRACK_REGION"
    and choice.returnRegion.isPhysicalPairClearanceConfirmed==false)
assert(choice.cascadeAttempts>=2,
    "compare multiple spatial alternatives before selecting")
assert(choice.directionSource=="OBLIQUE_REVERSE"
    or choice.directionSource=="PAIR_FORWARD"
    or choice.directionSource=="PAIR_CENTROID")
local r=choice.returnRegion
assert(not Plan.progress(r,r.originX,r.originZ).isInRegion)
assert(Plan.progress(r,r.originX+r.directionX*choice.regionTravelM,
    r.originZ+r.directionZ*choice.regionTravelM).isInRegion)
-- An in-field root is NOT sufficient when any attached-member corner
-- starts outside the polygon; reject all unsupported swept paths.
local narrow={xs={48,52,52,48},zs={49,49,51,51}}
local none,_,__,reason=Plan.planPairCascade({
    fieldPolygon=narrow,fieldCentroid={x=50,z=50}},a,b)
assert(none==nil and reason=="NO_FEASIBLE_PAIR_EGRESS")
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
print("Paired TRANSIT region, member transforms and complete-field path: PASS")
