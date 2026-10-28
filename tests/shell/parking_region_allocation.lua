-- Parking claim and qualified local-entry validation on Field77 fixture.
-- No native motor calls; geometry feasibility is incremental.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local xs={131.79,143.52,153.81,162.43,165.16,165.55,175.32,
    182.15,228.15,-0.06,-10.56,-40.20}
local zs={-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,
    -480.63,-468.38,-243.04,-207.44,-343.82,-677.42}
local source={densityMapPolygon={pointsX=xs,pointsZ=zs},fieldId=77}
local poly=assert(G.polygonFor(source))
g_fieldManager={fields={[77]=source},
    getFieldById=function(_,id)return g_fieldManager.fields[id]end}
local first={rootNode=100}
local second={rootNode=200}
local poses={
    [100]={x=120,z=-550,fx=-0.2,fz=-0.979795897},
    [200]={x=145,z=-600,fx=-0.2,fz=-0.979795897}
}
g_currentMission={vehicleSystem={vehicles={first,second}}}
getWorldTranslation=function(node)
    local p=poses[node]
    return p.x,0,p.z
end
localDirectionToWorld=function(node)
    local p=poses[node]
    return p.fx,0,p.fz
end
OuttaMyWay.PairTransitRegion={capture=function(vehicle)
    local p=poses[vehicle.rootNode]
    local corners={}
    for _,side in ipairs({-1,1}) do
        for _,front in ipairs({-1,1}) do
            corners[#corners+1]={x=-p.fz*1.2*side+p.fx*2.5*front,
                z=p.fx*1.2*side+p.fz*2.5*front}
        end
    end
    return {memberCount=1,corners=corners}
end}
dofile("scripts/coordination/SettlementPhysicalOccupancy.lua")
dofile("scripts/coordination/CompletionSettlementRoute.lua")
dofile("scripts/coordination/ExtendedInfieldApproach.lua")
dofile("scripts/coordination/SettlementDestinationAssessment.lua")
dofile("scripts/coordination/ParkingRegionAllocation.lua")
local Allocation=OuttaMyWay.ParkingRegionAllocation
local sourceField=assert(OuttaMyWay.CompletionFieldMembership.identify(first))
local ledger={}
local function qualify(vehicle)
    local s=assert(Allocation.beginPlan(vehicle,ledger,sourceField))
    local phase,route,reason
    for i=1,18000 do
        local prior=s.spent
        phase,route,reason=Allocation.advancePlan(s,320)
        assert(s.spent-prior<=320,"allocation must be frame bounded")
        if phase~="PENDING" then break end
    end
    return phase,route,reason
end
-- The first worker can reserve a concrete edge9 terminal ONLY if its
-- hypothetical entry produces a fully screened actual local route.
local phase,a,why=qualify(first)
assert(phase=="DONE",why)
assert(a.qualifiedLocalRoute and #a.qualifiedLocalRoute.legs>0)
assert(a.qualifiedApproachRoute and a.qualifiedDirectRoute==nil,
    "allocator must establish actual current-pose entry connectivity first")
assert(a.entryPose and a.terminalPose and a.station
    and type(a.edge)=="number" and a.field==sourceField.fieldId)
local firstClaim=assert(Allocation.claim(ledger,first,a.terminalPose,a.ownRadius))
assert(firstClaim==ledger[first])
assert(Allocation.claimCurrent(ledger,first))
assert(Allocation.matchesClaim(ledger,first,
    {terminalPose=a.terminalPose}))
local incorrect,whyIncorrect=Allocation.matchesClaim(ledger,first,
    {terminalPose={x=a.terminalPose.x+25,z=a.terminalPose.z}})
assert(not incorrect and whyIncorrect=="LOCAL_ROUTE_MISSES_CLAIMED_TERMINAL",
    "a handoff cannot quietly park far outside its exclusive claim")
-- This fixture has a long edge and two separated physical starting
-- poses. Both must discover distinct qualified terminals, not merely
-- demonstrate that the second can refuse an occupied claim.
local phase2,b,why2=qualify(second)
assert(phase2=="DONE",why2)
local secondClaim=assert(Allocation.claim(ledger,second,
    b.terminalPose,b.ownRadius))
local dx,dz=secondClaim.x-firstClaim.x,secondClaim.z-firstClaim.z
assert(dx*dx+dz*dz>(secondClaim.radius+firstClaim.radius+4)^2,
    "two qualified terminal claims must be physically distinct")
assert(b.qualifiedLocalRoute.terminalPose and b.qualifiedApproachRoute,
    "second terminal also needs an actual-pose-connected approach")
Allocation.release(ledger,second)
-- The remote first worker must find a goal-directed extended route to the
-- specifically qualified entry, not any convenient generic edge band.
local Extended=OuttaMyWay.ExtendedInfieldApproach
local travel=assert(Extended.beginPlan(first,a.entryPose,sourceField,a.edge))
local kind,planned,fail
for i=1,1000 do
    kind,planned,fail=Extended.advancePlan(travel,320)
    if kind~="PENDING" then break end
end
assert(kind=="DONE",fail)
assert(a.qualifiedApproachRoute.mode==planned.mode
    and #a.qualifiedApproachRoute.legs==#planned.legs,
    "allocation connectivity uses the existing independent extended planner")
assert(planned and planned.mode=="EXTENDED_INFIELD")
assert(planned.entryPose and planned.entryPose.x==a.entryPose.x)
assert(#planned.legs>0,"distant completion must actually navigate to claim")
local last=planned.legs[#planned.legs].point
local ex,ez=last.x-a.entryPose.x,last.z-a.entryPose.z
assert(ex*ex+ez*ez<=81,
    "planned approach must finish at the QUALIFIED entry, not a generic band")

local conflict,reason=Allocation.claim(ledger,second,
    {x=firstClaim.x,z=firstClaim.z},a.ownRadius)
assert(conflict==nil and reason=="TERMINAL_REGION_ALREADY_CLAIMED")
Allocation.release(ledger,first)
assert(Allocation.claimCurrent(ledger,first)==nil)
-- Actual allocator integration: first finisher is remote, while the peer
-- remains northbound on the eastern working corridor. The original .15
-- station20 MUST NOT quietly win merely from Euclidean proximity.
local Situation=OuttaMyWay.SettlementDestinationAssessment
poses[100]={x=165.047,z=-465.489,fx=-0.20,fz=0.979795897}
poses[200]={x=195,z=-355,fx=0,fz=1}
second.getIsAIActive=function()return true end
Situation.reset()
poses[200].z=-360
Situation.sample(first,500)
poses[200].z=-355
Situation.sample(first,500)
local assessed=assert(Allocation.beginPlan(first,ledger,sourceField))
local status,chosen,reason=Allocation.advancePlan(assessed,320)
assert(status=="PENDING" and assessed.siteIndex==0)
local leading=assessed.sites[1]
-- The same edge station must permit both legitimate tangent entries.
-- A single imposed entry orientation can make forward reachability appear
-- impossible even when the local parking solver supports the other side.
local seenDirections={}
for _,site in ipairs(assessed.sites) do
    local key=tostring(site.edgeIndex)..":"..string.format("%.3f",site.station)
    seenDirections[key]=seenDirections[key] or {}
    seenDirections[key][site.entryDirection]=true
end
for _,directions in pairs(seenDirections) do
    assert(directions[-1] and directions[1],
        "each nominal site must evaluate both edge-parallel entry headings")
end
assert(leading.frame and leading.edgeIndex
    and #assessed.sites>1,
    "all registered edge sites must carry their geometric provenance")
assert(assessed.situation.motionCount==1)
for i=1,#assessed.sites do
    assert(assessed.sites[i].selectionRank==i
        and type(assessed.sites[i].usableLongitudinalM)=="number",
        "global destination consideration must retain rank and real edge-space evidence")
end
-- A distant longer usable margin outranks a nearby shorter one for
-- otherwise comparable productive demand. Sampling covers another edge
-- before exhausting all stations of the longest edge.
local candidateFrames={
    [1]={ax=0,az=0,ux=1,uz=0,nx=0,nz=1,length=120},
    [2]={ax=0,az=0,ux=1,uz=0,nx=0,nz=1,length=40}
}
local synthetic={}
for _,edgeIndex in ipairs({1,2}) do
    local frame=candidateFrames[edgeIndex]
    for _,station in ipairs(edgeIndex==1 and {60,85} or {20}) do
        for _,direction in ipairs({-1,1}) do
            synthetic[#synthetic+1]={edgeIndex=edgeIndex,frame=frame,
                station=station,entryDirection=direction,
                entry={x=edgeIndex==1 and 100 or 5,z=0},
                usableLongitudinalM=edgeIndex==1 and 105 or 25}
        end
    end
end
local ordered=assert(Situation.rank(synthetic,{x=0,z=0},nil,{peers={}}))
assert(ordered[1].edgeIndex==1 and ordered[2].edgeIndex==1
    and ordered[3].edgeIndex==2 and ordered[4].edgeIndex==2
    and ordered[5].edgeIndex==1,
    "usable destination extent must beat proximity without starving other edges")
assert(ordered[1].selectionRank==1 and ordered[3].selectionRank==3,
    "priority rank must not be conflated with travel cost")
for i=1,18000 do
    status,chosen,reason=Allocation.advancePlan(assessed,320)
    if status~="PENDING" then break end
end
assert(status=="DONE",reason or "NO_ALTERNATIVE_QUALIFIED_TERMINAL")
assert(chosen.edge and chosen.field==sourceField.fieldId
    and chosen.situationRisk<3 and chosen.motionWitnesses==1,
    "productive demand and actual route must qualify the selected field edge")
print(string.format("active peer selection: station %d risk %d (%s), observed motion=%d",
    chosen.station,chosen.situationRisk,chosen.situationReason,
    chosen.motionWitnesses))
-- For a boundary-straddling assembly, the allocator may only return
-- a complete route from the actual pose (never a hypothetical infield entry).
second.getIsAIActive=nil
Situation.reset()
poses[100]={x=229,z=-244,fx=0,fz=1}
local straddling=assert(Allocation.beginPlan(
    first,ledger,sourceField,"STRADDLING"))
local state,selected,why
for i=1,18000 do
    state,selected,why=Allocation.advancePlan(straddling,320)
    if state~="PENDING" then break end
end
assert(state=="FAILED" or (state=="DONE" and selected.qualifiedDirectRoute
    and selected.qualifiedApproachRoute==nil),
    "straddling cannot grant a claim using an imaginary infield starting pose")

-- Diagnostic evidence must identify why every candidate was rejected
-- without introducing a new admission rule, new native movement or
-- per-frame publication. An ordinary session collects no such counters.
assert(straddling.evidence==nil,
    "diagnostic aggregation must be disabled by default")
local savedObserve=Situation.observe
local savedClear=OuttaMyWay.SettlementPhysicalOccupancy.clear
local Local=OuttaMyWay.CompletionSettlementRoute
local savedBegin,savedAdvance=Local.beginPlan,Local.advancePlan
local sawEarliestQualified=false
local observedPolygon
Situation.observe=function(_,polygon)
    assert(polygon~=nil,
        "each site must assess the retained Source Field polygon")
    if observedPolygon==nil then observedPolygon=polygon end
    assert(polygon==observedPolygon,
        "allocation site assessment must use its initial Source Field")
    return {peers={},workingCount=0,motionCount=0,headingCount=0}
end
OuttaMyWay.SettlementPhysicalOccupancy.clear=function()return true end
Local.beginPlan=function(_,options)
    assert(options.earliestQualified==true,
        "region allocation must prefer first fully qualified local route")
    sawEarliestQualified=true
    return {spent=0,candidates=0,rejectionCounts={}}
end
Local.advancePlan=function(session)
    session.spent=session.spent+1
    session.candidates=3
    session.rejectionCounts={
        REVERSE_MEMBER_OUTSIDE_SOURCE=2,
        TERMINAL_MEMBER_INTERSECTS_SOURCE=1}
    return "FAILED",nil,"NO_POSE_REACHABLE_PARKING_REGION"
end
local diagnostic=assert(Allocation.beginPlan(
    first,ledger,sourceField,"STRADDLING",true))
local diagnosis,_,refusal
for i=1,18000 do
    local before=diagnostic.spent
    diagnosis,_,refusal=Allocation.advancePlan(diagnostic,320)
    assert(diagnostic.spent-before<=320,
        "instrumented allocation must remain bounded per update")
    if diagnosis~="PENDING" then break end
end
assert(diagnosis=="FAILED" and refusal=="NO_QUALIFIED_TERMINAL_REGION")
local e=assert(diagnostic.evidence)
assert(e.sitesTotal>0 and e.sitesExamined==e.sitesTotal
    and observedPolygon==diagnostic.poly,
    "failure summary must cover every real Source Field candidate")
assert(sawEarliestQualified and e.localPlans>0
    and e.localCandidates==3*e.localPlans
    and e.siteRejections.LOCAL_ROUTE_NO_POSE_REACHABLE_PARKING_REGION
        ==e.localPlans
    and e.routeRejections.REVERSE_MEMBER_OUTSIDE_SOURCE==2*e.localPlans
    and e.routeRejections.TERMINAL_MEMBER_INTERSECTS_SOURCE==e.localPlans,
    "site and nominal-route refusal distributions must be preserved")
Situation.observe=savedObserve
OuttaMyWay.SettlementPhysicalOccupancy.clear=savedClear
Local.beginPlan,Local.advancePlan=savedBegin,savedAdvance
-- Long local qualification must not prevent a second edge from
-- receiving a first work slice. The paused candidate remains resumable,
-- and no unfinished candidate becomes an admitted route or claim.
local visitedEdges={}
Situation.observe=function() return {
    peers={},workingCount=0,motionCount=0,headingCount=0} end
OuttaMyWay.SettlementPhysicalOccupancy.clear=function()return true end
Local.beginPlan=function(_,options)
    visitedEdges[options.edgeIndex]=true
    return {spent=0,candidates=0,rejectionCounts={}}
end
Local.advancePlan=function(plan,units)
    plan.spent=plan.spent+units
    plan.candidates=plan.candidates+1
    return "PENDING"
end
local fair=assert(Allocation.beginPlan(
    first,ledger,sourceField,"INSIDE",true))
local fairState
for i=1,400 do
    local before=fair.spent
    fairState=Allocation.advancePlan(fair,320)
    assert(fair.spent-before<=320,
        "cross-edge scheduling must preserve the frame work budget")
    if fair.siteIndex>=4 and #fair.deferredLocal>=2 then break end
end
local distinct=0
for _ in pairs(visitedEdges) do distinct=distinct+1 end
assert(fairState=="PENDING" and distinct>=2
    and #fair.deferredLocal>=2 and fair.completedCount==0,
    "unfinished edge searches must yield fairly, not be mistaken for refusals")
assert(fair.evidence and fair.evidence.localFeasible==0,
    "fair scheduling cannot invent a completed candidate")
Situation.observe=savedObserve
OuttaMyWay.SettlementPhysicalOccupancy.clear=savedClear
Local.beginPlan,Local.advancePlan=savedBegin,savedAdvance
print("qualified terminal allocation: disjoint claims and future-demand-aware real allocator PASS")
