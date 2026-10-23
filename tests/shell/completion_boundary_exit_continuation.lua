-- Real-member straddling assessment, not route authority or GIANTS parking proof.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
dofile("scripts/observation/CompletionAssemblyFieldOccupancy.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local field={densityMapPolygon={pointsX={0,100,100,0},
    pointsZ={0,0,100,100}},fieldId=29}
local neighbor={densityMapPolygon={pointsX={250,260,260,250},
    pointsZ={250,250,260,260}},fieldId=30}
g_fieldManager={fields={[29]=field,[30]=neighbor}}
local source={field=field,fieldId=29}
local current={x=50,z=-0.5,fx=math.cos(10*math.pi/180),
    fz=-math.sin(10*math.pi/180)}
local vehicle={rootNode=111}
local blocked={rootNode=222}
local blockedPos={x=90,z=-50}
getWorldTranslation=function(node)
    local p=node==blocked.rootNode and blockedPos or current
    return p.x,0,p.z
end
localDirectionToWorld=function(_,x,_,z)
    return current.fz*x+current.fx*z,0,
        -current.fx*x+current.fz*z
end
g_currentMission={vehicleSystem={vehicles={vehicle}}}
local maxMemberOffset=1.5
OuttaMyWay.PairTransitRegion={
    capture=function(v)
        local p=v==blocked and blockedPos or current
        local corners={}
        for _,x in ipairs({-1,1}) do
            for _,z in ipairs({-1,maxMemberOffset}) do
                corners[#corners+1]={x=x,z=z}
            end
        end
        return {rootX=p.x,rootZ=p.z,
            memberCount=1,corners=corners}
    end
}
dofile("scripts/coordination/SettlementPhysicalOccupancy.lua")
OuttaMyWay.SettlementDestinationAssessment={
    observe=function()return {peers={}} end,
    risk=function()return 0 end
}
dofile("scripts/coordination/CompletionBoundaryExitContinuation.lua")
local Boundary=OuttaMyWay.CompletionBoundaryExitContinuation
local occupancy=OuttaMyWay.CompletionAssemblyFieldOccupancy
assert(occupancy.assess(vehicle,source).status=="STRADDLING",
    "the real selected member footprint must intersect the Source Field")
local plan=assert(Boundary.beginPlan(vehicle,source))
assert(plan.phase=="INIT" and plan.spent==0 and plan.advances==0,
    "completion callback must not synchronously enumerate field geometry")
local phase,route,reason
local previous=0
for i=1,150 do
    phase,route,reason=Boundary.advancePlan(plan,320)
    assert(plan.spent-previous<=320,"finite per-UPDATE geometry work")
    previous=plan.spent
    if phase~="PENDING" then break end
end
assert(phase=="DONE" and route
    and route.mode=="BOUNDARY_CLEARANCE_STEP",reason)
assert(route.edge and route.requiredForwardM==2
    and route.estimatedTravelM==2.75
    and route.reverseM==0
    and route.method=="OBSERVED_STRADDLING_FORWARD_2M"
    and route.terminalArrivalRadiusM==0.75,
    "a real stopped STRADDLING pose may qualify a 2m action without a fully parked endpoint")
assert(#route.legs==1)
assert(route.legs[1].point.x==
        current.x+current.fx*2.75 or
    math.abs(route.legs[1].point.x-current.x-current.fx*2.75)<0.00001,
    "with 0.75m arrival radius, the command must guarantee at least 2m forward travel")
for i,leg in ipairs(route.legs) do
    assert(leg.moveForwards==true
        and (i==#route.legs and leg.arrivalRadiusM==0.75
            or (i<#route.legs and leg.arrivalRadiusM==nil)),
        "full source boundary exit remains forward-only, final precision only")
end
assert(occupancy.assess(vehicle,source).status=="STRADDLING",
    "nominal qualification cannot change actual assembly disposition")
current.x,current.z=route.terminalPose.x,route.terminalPose.z
assert(occupancy.assess(vehicle,source).status=="STRADDLING",
    "2m interim movement may still leave a member inside; this must NOT veto movement")
assert(Boundary.guard(vehicle,route),
    "current physical-member guard must permit a still-straddling safe pose")
local confirmed=route.terminalPose
current.x,current.z=50,-0.5
local sameEdge=assert(Boundary.beginPlan(vehicle,source,route.edge))
for i=1,150 do
    phase,route,reason=Boundary.advancePlan(sameEdge,320)
    if phase~="PENDING" then break end
end
assert(phase=="DONE" and route.edge==sameEdge.edgeIndex,
    "a nominated previously selected edge must be respected")
-- An already CLEAR assembly must not receive another movement route.
current.x,current.z=confirmed.x,confirmed.z
current.z=-10
local cleared=assert(Boundary.beginPlan(vehicle,source))
phase,route,reason=Boundary.advancePlan(cleared,320)
assert(phase=="FAILED" and route==nil
    and reason=="BOUNDARY_STEP_NOT_STRADDLING")
current.x,current.z=50,-0.5
-- Heading need not be edge-parallel for a small *intermediate*
-- movement; its true terminal heading remains unverified.
current.fx,current.fz=0,-1
local misaligned=assert(Boundary.beginPlan(vehicle,source))
for i=1,180 do
    phase,route,reason=Boundary.advancePlan(misaligned,320)
    if phase~="PENDING" then break end
end
assert(phase=="DONE" and route~=nil,
    "terminal heading constraints cannot veto a safe intermediate 2m translation")
current.fx,current.fz=math.cos(10*math.pi/180),
    -math.sin(10*math.pi/180)
-- A longer member may still be inside the Source Field after a safe
-- 2m translation; this must not turn progress into terminal refusal.
maxMemberOffset=4
local extended=assert(Boundary.beginPlan(vehicle,source))
for i=1,180 do
    phase,route,reason=Boundary.advancePlan(extended,320)
    if phase~="PENDING" then break end
end
assert(phase=="DONE" and route~=nil,
    "a too-long member must remain STRADDLING but may safely advance")
maxMemberOffset=1.5
-- A stationary second assembly consumes actual physical space and vetoes
-- intermediate clearance despite a nominally free registered edge.
blockedPos.x,blockedPos.z=59,-1.8
g_currentMission.vehicleSystem.vehicles={vehicle,blocked}
local blockedPlan=assert(Boundary.beginPlan(vehicle,source))
for i=1,180 do
    phase,route,reason=Boundary.advancePlan(blockedPlan,320)
    if phase~="PENDING" then break end
end
assert(phase=="FAILED" and route==nil,
    "the actual physical occupancy of another assembly is not free space")
print("2m real-member STRADDLING clearance-step qualification PASS")
