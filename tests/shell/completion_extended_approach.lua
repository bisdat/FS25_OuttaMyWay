-- Bounded Extended Infield Approach contract; no native motor actuation.
-- Same actual Field77 polygon as settlement's shell tests.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local xs={131.79,143.52,153.81,162.43,165.16,165.55,175.32,
    182.15,228.15,-0.06,-10.56,-40.20}
local zs={-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,
    -480.63,-468.38,-243.04,-207.44,-343.82,-677.42}
local source={densityMapPolygon={pointsX=xs,pointsZ=zs},fieldId=77}
local poly=assert(G.polygonFor(source))
assert(G.inside(poly,120,-570),"synthetic remote worker must be in field")
g_fieldManager={fields={[77]=source},getFieldById=function(_,id)
    return g_fieldManager.fields[id]
end}
local current={x=120,z=-570,fx=-0.2,fz=-0.979795897}
local root={rootNode=100,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local other={rootNode=200,getIsAIActive=function()return true end}
local otherPose={x=48,z=-424,fx=0,fz=1}
g_currentMission={vehicles={root,other}}
getWorldTranslation=function(node)
    local p=node==100 and current or otherPose
    return p.x,0,p.z
end
localDirectionToWorld=function(node)
    local p=node==100 and current or otherPose
    return p.fx,0,p.fz
end
OuttaMyWay.PairTransitRegion={capture=function(vehicle)
    local p=vehicle==root and current or otherPose
    local corners={}
    for _,signZ in ipairs({-1,1}) do
        for _,signX in ipairs({-1,1}) do
            corners[#corners+1]={x=signX*1.5*p.fz+signZ*3*p.fx,
                z=-signX*1.5*p.fx+signZ*3*p.fz}
        end
    end
    return {memberCount=1,corners=corners}
end}
dofile("scripts/coordination/ExtendedInfieldApproach.lua")
local A=OuttaMyWay.ExtendedInfieldApproach
local context=A.beginPlan(root)
assert(context and context.phase=="INIT")
local status,route,reason
for i=1,1200 do
    local before=context.spent
    status,route,reason=A.advancePlan(context,64)
    assert(context.spent-before<=64,"weighted budget enforced")
    if status~="PENDING" then break end
end
assert(status=="DONE",reason)
assert(route.mode=="EXTENDED_INFIELD" and route.edge==9)
assert(route.estimatedTravelM>80 and #route.legs>10,
    "remote completion must require an actual connecting approach")
assert(#route.legs<=115)
local prev=current
for i=1,#route.legs do
    local p=route.legs[i].point
    assert(route.legs[i].moveForwards)
    assert(math.sqrt((p.x-prev.x)^2+(p.z-prev.z)^2)<9,
        "no 200m or other distant GIANTS steering target")
    assert(G.inside(poly,p.x,p.z))
    local dx,dz=p.x-otherPose.x,p.z-otherPose.z
    assert(dx*dx+dz*dz>18*18,"initial known worker must be avoided")
    prev=p
end
local edge=G.edges(poly)[9]
local f={ux=edge.dx/edge.length,uz=edge.dz/edge.length,
    ax=edge.ax,az=edge.az}
local tx,tz=prev.x-f.ax,prev.z-f.az
local along=tx*f.ux+tz*f.uz
assert(along>12 and along<edge.length-12)
assert(route.planningExpansions>3)
-- New active-worker position in front of the route invalidates authority.
otherPose.x,otherPose.z=route.legs[1].point.x,route.legs[1].point.z
local safe,why=A.guard(root,route,1)
assert(not safe and why=="EXTENDED_ACTIVE_WORKER_PROXIMITY",
    "dynamic worker position must revoke the long approach")
-- No scene witness is an explicit refusal, not a clearance claim.
g_currentMission.vehicles=nil
local blank=assert(A.beginPlan(root))
local phase,_,fail=A.advancePlan(blank,64)
assert(phase=="FAILED" and fail=="WORKER_SCENE_EVIDENCE_UNAVAILABLE")
print(string.format("extended infield nominal route PASS: %.1fm %d short targets; worker guard PASS",
    route.estimatedTravelM,#route.legs))
