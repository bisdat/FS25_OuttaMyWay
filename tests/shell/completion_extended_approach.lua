-- Bounded Extended Infield Approach contract; no native motor actuation.
-- Same actual Field77 polygon as settlement's shell tests.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
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
g_currentMission={vehicleSystem={vehicles={root,other}}}
getWorldTranslation=function(node)
    local p=node==100 and current or otherPose
    return p.x,0,p.z
end
local noPeerHeading=false
localDirectionToWorld=function(node)
    if node==200 and noPeerHeading then error("unavailable heading") end
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
dofile("scripts/coordination/SettlementPhysicalOccupancy.lua")
dofile("scripts/coordination/ExtendedInfieldApproach.lua")
local A=OuttaMyWay.ExtendedInfieldApproach
local sourceField=assert(OuttaMyWay.CompletionFieldMembership.identify(root))
local context=A.beginPlan(root,nil,sourceField,9)
assert(context and context.phase=="INIT")
local status,route,reason
for i=1,1200 do
    local before=context.spent
    status,route,reason=A.advancePlan(context,64)
    assert(context.spent-before<=64,"weighted budget enforced")
    if status~="PENDING" then break end
end
assert(status=="DONE",reason)
assert(route.mode=="EXTENDED_INFIELD" and route.edge==9
    and route.field==sourceField.fieldId)
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
-- A qualified target remains meaningful even when already inside the
-- generic entry band; zero-distance TARGETED entry is not a route failure.
local target={x=prev.x,z=prev.z,
    fx=route.entryHeading.fx,fz=route.entryHeading.fz}
local saved={x=current.x,z=current.z,fx=current.fx,fz=current.fz}
current.x,current.z,current.fx,current.fz=
    target.x,target.z,target.fx,target.fz
local targeted=assert(A.beginPlan(root,target,sourceField,9))
local targetPhase,targetRoute,targetReason=A.advancePlan(targeted,64)
assert(targetPhase=="DONE" and targetRoute
    and targetRoute.mode=="EXTENDED_INFIELD"
    and #targetRoute.legs==0,
    "qualified entry already reached must hand off to local planner")
current.x,current.z,current.fx,current.fz=
    saved.x,saved.z,saved.fx,saved.fz
-- New active-worker position in front of the route invalidates authority.
otherPose.x,otherPose.z=route.legs[1].point.x,route.legs[1].point.z
local safe,why=A.guard(root,route,1)
assert(not safe and why=="PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED",
    "physical scene veto precedes active-worker proximity guard")
local active,observed=A.activePeers(root,poly)
assert(observed and #active==1,
    "the other worker remains positively AI-active in independent evidence")
-- GIANTS may finish the other job while its body remains present.
other.getIsAIActive=function()return false end
safe,why=A.guard(root,route,1)
assert(not safe and why=="PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED",
    "a completed stationary worker still occupies its actual footprint")
other.getIsAIActive=function()return true end
-- The established registry is mission.vehicleSystem.vehicles. A legacy
-- mission.vehicles alias must not silently stand in for that witness.
g_currentMission.vehicles={root,other}
g_currentMission.vehicleSystem.vehicles=nil
local blank=assert(A.beginPlan(root,nil,sourceField,9))
local phase,_,fail=A.advancePlan(blank,64)
assert(phase=="FAILED" and fail=="WORKER_SCENE_REGISTRY_UNAVAILABLE")
assert(blank.sceneEvidence.registry=="MISSION_VEHICLE_SYSTEM")
g_currentMission.vehicleSystem.vehicles={root,other}
-- Other worker's position can be known even when heading is unavailable.
otherPose.x,otherPose.z=48,-424
noPeerHeading=true
local visible,okay,why,evidence=A.activePeers(root,poly)
assert(okay and why==nil and #visible==1 and evidence.observedWorkers==1,
    "AI-active root position alone suffices for a proximity exclusion")
noPeerHeading=false
-- A distant unreadable status is irrelevant to the Field77 corridor.
local distant={rootNode=300,getIsAIActive=function()error("native AI read")end}
local distantPos={x=500,z=500}
local originalTranslation=getWorldTranslation
getWorldTranslation=function(node)
    if node==300 then return distantPos.x,0,distantPos.z end
    return originalTranslation(node)
end
g_currentMission.vehicleSystem.vehicles={root,other,distant}
local peers,ok,status,scene=A.activePeers(root,poly)
assert(ok and status==nil and #peers==1 and scene.outsideField==1,
    "unrelated distant AI-status failure must not veto navigation")
-- A relevant unobservable AI status is an explicit refusal.
distantPos.x,distantPos.z=otherPose.x,otherPose.z
peers,ok,status,scene=A.activePeers(root,poly)
assert(not ok and status=="WORKER_SCENE_AI_STATUS_UNAVAILABLE"
    and scene.failureRoot=="300",
    "unknown status for a relevant root must not be treated as clear")
-- Positive native AI job evidence can rescue an unavailable activity method.
distant.getCurrentAIJob=function()return {jobId=9}end
peers,ok,status,scene=A.activePeers(root,poly)
assert(ok and #peers==2 and scene.observedWorkers==2)
-- A known active root with no readable X/Z remains a blocker.
distantPos.x,distantPos.z=700,700
getWorldTranslation=function(node)
    if node==300 then error("native position missing") end
    return originalTranslation(node)
end
peers,ok,status,scene=A.activePeers(root,poly)
assert(not ok and status=="WORKER_SCENE_ACTIVE_POSITION_UNAVAILABLE"
    and scene.failureRoot=="300")
-- Non-AI root-level equipment is not an unknown AI worker.
local equipment={rootNode=400}
g_currentMission.vehicleSystem.vehicles={root,other,equipment}
getWorldTranslation=function(node)
    if node==400 then return 48,0,-424 end
    return originalTranslation(node)
end
peers,ok,status,scene=A.activePeers(root,poly)
assert(ok and #peers==1 and scene.nonAiRoots==1)
-- A legitimately inactive worker is excluded even if its position fails.
local idle={rootNode=500,getIsAIActive=function()return false end}
g_currentMission.vehicleSystem.vehicles={root,other,idle}
getWorldTranslation=function(node)
    if node==500 then error("no inactive position") end
    return originalTranslation(node)
end
peers,ok,status=A.activePeers(root,poly)
assert(ok and #peers==1)
print(string.format("extended infield nominal route PASS: %.1fm %d short targets; GIANTS scene contract PASS",
    route.estimatedTravelM,#route.legs))
