-- TEST 0.5.5.9: completion settlement selects a nearby reachable
-- nominal parking REGION, from the actual vehicle pose (never a far endpoint).
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
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
local other={rootNode=222}
local otherPos={x=900,z=900,fx=1,fz=0}
local memberCount=1
g_currentMission={vehicleSystem={vehicles={vehicle}}}
getWorldTranslation=function(node)
    local p=node==222 and otherPos or current
    return p.x,0,p.z
end
localDirectionToWorld=function(node,x,_,z)
    local p=node==222 and otherPos or current
    if x==0 and z==1 then return p.fx,0,p.fz end
    return p.fz*x+p.fx*z,0,-p.fx*x+p.fz*z
end
OuttaMyWay.PairTransitRegion={
    capture=function(v)
        local p=v==other and otherPos or current
        local lateralX,lateralZ=-p.fz,p.fx
        local corners={}
        for _,side in ipairs({-1,1}) do
            for _,front in ipairs({-1,1}) do
                corners[#corners+1]={x=lateralX*1.2*side+
                    p.fx*2.5*front,
                    z=lateralZ*1.2*side+p.fz*2.5*front}
            end
        end
        if v~=other and memberCount>1 then
            -- Identical nominal members isolate *admission policy* from
            -- geometry feasibility. Real articulated node changes are
            -- covered separately by the live-member-geometry witness.
            for i=1,4 do
                corners[#corners+1]={x=corners[i].x,z=corners[i].z}
            end
        end
        return {rootX=p.x,rootZ=p.z,
            corners=corners,memberCount=v==other and 1 or memberCount}
    end
}
dofile("scripts/coordination/SettlementPhysicalOccupancy.lua")
dofile("scripts/coordination/CompletionSettlementRoute.lua")
local Route=OuttaMyWay.CompletionSettlementRoute
local sourceField=assert(OuttaMyWay.CompletionFieldMembership.identify(vehicle))
local fixtureOptions={sourceField=sourceField,edgeIndex=9}
-- Admission from native job-stop MUST only create the planning session;
-- no single update may complete the whole expensive route search.
local coroutineOriginal=coroutine
coroutine=nil -- GIANTS Reality: no global coroutine table was available.
local async=assert(Route.beginPlan(vehicle,fixtureOptions))
assert(async.advances==0 and async.spent==0
    and async.phase=="INIT" and async.poly==nil,
    "native completion must do no field geometry")
local phase,route,reason
local yielded=0
for i=1,12500 do
    local before=async.spent
    phase,route,reason=Route.advancePlan(async,64)
    assert(async.spent-before<=64 and async.advances==i,
        "each explicit update must respect its geometry-work allowance")
    if phase=="PENDING" then
        yielded=yielded+1
        assert(route==nil,"partially screened routes cannot be admitted")
    else
        break
    end
end
assert(phase=="DONE",reason)
assert(yielded>=3,
    "the completed-job callback cannot synchronously consume the search")
assert(Route.advancePlan(async,64)=="FAILED",
    "finished planning cannot resume again")
assert(coroutine==nil,"the implementation must not require coroutines")
coroutine=coroutineOriginal
local a,err=Route.plan(vehicle,nil,fixtureOptions)
assert(a,err)
assert(route.estimatedTravelM==a.estimatedTravelM
    and route.method==a.method and #route.legs==#a.legs
    and route.direction==a.direction and route.reverseM==a.reverseM
    and route.guideRadiusM==a.guideRadiusM,
    "incremental and synchronous reference route must select alike")
for i=1,#a.legs do
    local x,y=route.legs[i],a.legs[i]
    assert(x.moveForwards==y.moveForwards and x.name==y.name
        and math.abs(x.point.x-y.point.x)<0.00001
        and math.abs(x.point.z-y.point.z)<0.00001,
        "explicit planner must reproduce every reference guidance point")
end
assert(a.field==sourceField.fieldId and a.edge==fixtureOptions.edgeIndex)
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
current.x=current.x+current.fx*5
current.z=current.z+current.fz*5
local reserved,whyReserved=Route.verifyTerminal(vehicle,a)
assert(reserved,whyReserved,
    "the chosen terminal requires five metres of stopping reserve")
current.x,current.z=prev.x,prev.z
print(string.format("TS018 nominal chosen route: %s reverse=%.1fm travel=%.1fm targets=%d",
    a.method,a.reverseM,a.estimatedTravelM,#a.legs))
-- Terminal Placement Reassessment: an actual stopped assembly near the
-- corner can qualify a short FORWARD correction only if complete member
-- geometry, early-arrival tolerance and run-out reserve remain inside the
-- same nominated exterior corridor.
local testSource={densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}},fieldId=777}
local testPoly=assert(G.polygonFor(testSource))
local testFrame={index=1,ax=0,az=0,ux=1,uz=0,nx=0,nz=-1,length=100}
local correctionRoute={field=777,edge=1,memberCount=1,
    frame=testFrame,poly=testPoly,neighbors={},
    method="FORWARD_J",legs={{name="FORWARD_GUIDANCE",
        point={x=3,z=-3},moveForwards=true}}}
local restored={x=current.x,z=current.z,fx=current.fx,fz=current.fz}
current.x,current.z,current.fx,current.fz=2,-3,1,0
local terminal,why,predicate=Route.verifyTerminal(vehicle,correctionRoute)
assert(not terminal and why=="WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION"
    and predicate=="TERMINAL_ROOT_OUTSIDE_EDGE_BAND",
    "stopped terminal failure must identify the actual geometric predicate")
local correction,reason=Route.planTerminalCorrection(vehicle,correctionRoute)
assert(correction,reason)
assert(correction.method=="STOPPED_TERMINAL_CORRECTION"
    and correction.reverseM==0 and correction.estimatedTravelM<=8
    and #correction.legs==1 and correction.legs[1].moveForwards,
    "one bounded current-pose forward correction must be separately qualified")
assert(correction.terminalPose.x>=6
    and correction.terminalPose.z==-3)
current.x,current.z=correction.terminalPose.x,correction.terminalPose.z
local verified,verifiedWhy=Route.verifyTerminal(vehicle,correction)
assert(verified,verifiedWhy)
-- A stopped root with an invalid EDGE HEADING cannot be fixed by
-- translating that same heading. It must acquire the nominated tangent
-- through a bounded forward arc and then reach a separately verified
-- straight terminal pose.
current.x,current.z=20,-4
current.fx,current.fz=math.cos(25*math.pi/180),
    -math.sin(25*math.pi/180)
local bad,failed,headingFailure=Route.verifyTerminal(vehicle,correctionRoute)
assert(not bad and headingFailure=="TERMINAL_HEADING_NOT_EDGE_ALIGNED")
local aligned,alignWhy=Route.planTerminalCorrection(vehicle,correctionRoute)
assert(aligned,alignWhy)
assert(aligned.method=="STOPPED_TERMINAL_ALIGNMENT"
    and aligned.reverseM==0 and aligned.estimatedTravelM<=12
    and #aligned.legs>=2
    and aligned.legs[1].name=="TERMINAL_HEADING_GUIDANCE"
    and aligned.legs[#aligned.legs].name=="TERMINAL_PLACEMENT_CORRECTION",
    "misaligned stop must qualify a real bounded forward turn, not a translation")
for _,leg in ipairs(aligned.legs) do
    assert(leg.moveForwards and leg.arrivalRadiusM==0.75,
        "alignment requires precise forward waypoint admission")
end
local lastGuide=aligned.legs[#aligned.legs].point
assert(math.abs(aligned.terminalPose.x-lastGuide.x)<0.00001
    and math.abs(aligned.terminalPose.z-lastGuide.z)<0.00001)
current.x,current.z=aligned.terminalPose.x,aligned.terminalPose.z
current.fx,current.fz=aligned.terminalPose.fx,aligned.terminalPose.fz
assert(Route.verifyTerminal(vehicle,aligned),
    "a qualified corrected heading must verify at the planned stopped pose")
-- An ineligible member corridor must be refused, not driven through.
current.x,current.z,current.fx,current.fz=1,-3,0,-1
assert(Route.planTerminalCorrection(vehicle,correctionRoute)==nil)
current.x,current.z,current.fx,current.fz=
    restored.x,restored.z,restored.fx,restored.fz
-- Test a *different completing pose* chooses a different terminal position.
local first={x=current.x,z=current.z}
current.x,current.z,current.fx,current.fz=
    141,-252,0.987846,-0.155355
local b,why=Route.plan(vehicle,nil,fixtureOptions)
assert(b,why)
assert(#b.legs>1 and b.estimatedTravelM<120)
-- Route agreement and bounded work must also hold for a new completion pose.
local alternate=assert(Route.beginPlan(vehicle,fixtureOptions))
local altPhase,altRoute,altReason
for i=1,12500 do
    local before=alternate.spent
    altPhase,altRoute,altReason=Route.advancePlan(alternate,64)
    assert(alternate.spent-before<=64)
    if altPhase~="PENDING" then break end
end
assert(altPhase=="DONE",altReason)
assert(altRoute.method==b.method and altRoute.direction==b.direction
    and math.abs(altRoute.estimatedTravelM-b.estimatedTravelM)<0.00001)
for i=1,#b.legs do
    local x,y=altRoute.legs[i],b.legs[i]
    assert(x.moveForwards==y.moveForwards and
        math.abs(x.point.x-y.point.x)<0.00001 and
        math.abs(x.point.z-y.point.z)<0.00001)
end
print(string.format("Alternate pose chosen: %s reverse=%.1fm travel=%.1fm targets=%d",
    b.method,b.reverseM,b.estimatedTravelM,#b.legs))
local dest=b.legs[#b.legs].point
assert(math.sqrt((dest.x-first.x)^2+(dest.z-first.z)^2)>10,
    "different completion poses should not share one far endpoint")
-- Both poses must remain well short of the full selected 230-m edge.
assert(a.estimatedTravelM<edge.length*.55)
assert(b.estimatedTravelM<edge.length*.55)
-- A completed, AI-inactive second sprayer remains PHYSICAL occupancy.
-- The original first worker's space must not be allocated twice.
local occupied=a.legs[#a.legs].point
otherPos.x,otherPos.z=occupied.x,occupied.z
otherPos.fx,otherPos.fz=current.fx,current.fz
g_currentMission.vehicleSystem.vehicles={vehicle,other}
local clear,conflict=OuttaMyWay.SettlementPhysicalOccupancy.routeClear(
    vehicle,a)
assert(not clear and conflict=="PHYSICAL_OCCUPANCY_ROUTE_CONFLICT")
current.x,current.z,current.fx,current.fz=201.478,-256.684,0.987846,-0.155355
local second,secondReason=Route.plan(vehicle,nil,fixtureOptions)
if second~=nil then
    local target=second.legs[#second.legs].point
    local delta=math.sqrt((target.x-occupied.x)^2+
        (target.z-occupied.z)^2)
    assert(delta>10,"the same occupied parking space was reused")
else
    assert(secondReason=="NO_POSE_REACHABLE_PARKING_REGION",
        "unknown occupancy failure must not be interpreted as clear")
end
local nextStep,whyNext=OuttaMyWay.SettlementPhysicalOccupancy.nextClear(
    vehicle,{poly=assert(G.polygonFor(source)),
        legs={{point={x=occupied.x,z=occupied.z}}}},1)
assert(not nextStep and whyNext=="PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED")
g_currentMission.vehicleSystem.vehicles={vehicle}
-- The field fixture does not secretly admit another polygon.
current.x,current.z=900,900
assert(Route.plan(vehicle,nil,fixtureOptions)==nil)
current.x,current.z=201.478,-256.684
memberCount=2
local multi,reasonMulti=Route.plan(vehicle,nil,fixtureOptions)
assert(multi and multi.memberCount==2,reasonMulti or
    "a multi-member assembly must enter nominal route qualification")
local multiSession=assert(Route.beginPlan(vehicle,fixtureOptions))
local multiPhase,multiRoute,multiReason
for i=1,12500 do
    multiPhase,multiRoute,multiReason=Route.advancePlan(multiSession,64)
    if multiPhase~="PENDING" then break end
end
assert(multiPhase=="DONE" and multiRoute.memberCount==2,multiReason or
    "incremental planner must not retain a single-member prototype veto")
-- This fixture cannot prove the TS019 world failure. Deliberately deny
-- all terminal stations to exercise attributed, finite local refusal.
memberCount=1
current.x,current.z,current.fx,current.fz=128.628,-245.676,0.953,0.302
local rejected=assert(Route.beginPlan(vehicle,{
    sourceField=sourceField,edgeIndex=9,stationMin=0,stationMax=0,
    expectedEntryPose={x=131.509,z=-246.184,fx=0.988,fz=-0.154}}))
local rejectedPhase,rejectedRoute,rejectedReason
for i=1,12500 do
    rejectedPhase,rejectedRoute,rejectedReason=Route.advancePlan(rejected,64)
    if rejectedPhase~="PENDING" then break end
end
assert(rejectedPhase=="FAILED" and rejectedRoute==nil
    and rejectedReason=="NO_POSE_REACHABLE_PARKING_REGION")
assert(rejected.candidates==300,
    "bounded local candidate enumeration must finish")
local observedRejections=0
for _,count in pairs(rejected.rejectionCounts or {}) do
    observedRejections=observedRejections+count
end
assert(observedRejections>0
    and rejected.rejectionCounts.TERMINAL_OUTSIDE_CLAIMED_STATION,
    "failed entry must retain predicate-attributed evidence")
assert(rejected.current.x==128.628 and rejected.options.expectedEntryPose.x==131.509,
    "nominal entry must remain distinct from measured arrival")
-- An independent registered Source Field ID and translated polygon must
-- produce the same shape-relative manoeuvre, never the old world fixture.
current.x,current.z,current.fx,current.fz=201.478,-256.684,0.987846,-0.155355
local shiftedX,shiftedZ={},{}
for i=1,#originalX do
    shiftedX[i]=originalX[i]+330
    shiftedZ[i]=originalZ[i]+540
end
local shiftedNeighborX,shiftedNeighborZ={},{}
for i=1,#neighbor.densityMapPolygon.pointsX do
    shiftedNeighborX[i]=neighbor.densityMapPolygon.pointsX[i]+330
    shiftedNeighborZ[i]=neighbor.densityMapPolygon.pointsZ[i]+540
end
local shiftedField={densityMapPolygon={pointsX=shiftedX,
    pointsZ=shiftedZ},fieldId=29}
local shiftedNeighbor={densityMapPolygon={pointsX=shiftedNeighborX,
    pointsZ=shiftedNeighborZ},fieldId=88}
g_fieldManager.fields={[29]=shiftedField,[88]=shiftedNeighbor}
current.x,current.z=current.x+330,current.z+540
local nonFixtureField=assert(OuttaMyWay.CompletionFieldMembership.identify(vehicle))
assert(nonFixtureField.fieldId==29)
local translated,translatedWhy=Route.plan(vehicle,nil,{
    sourceField=nonFixtureField,edgeIndex=9})
assert(translated,translatedWhy)
assert(translated.field==29 and translated.edge==9
    and translated.method==a.method and #translated.legs==#a.legs
    and math.abs(translated.estimatedTravelM-a.estimatedTravelM)<0.001,
    "local parking depends on registered field geometry, not Field77")
for i=1,#translated.legs do
    local original=a.legs[i].point
    local shifted=translated.legs[i].point
    assert(math.abs(shifted.x-(original.x+330))<0.001
        and math.abs(shifted.z-(original.z+540))<0.001,
        "all guidance targets must follow the registered polygon translation")
end
local shiftedSession=assert(Route.beginPlan(vehicle,{
    sourceField=nonFixtureField,edgeIndex=9}))
local shiftedPhase,shiftedRoute,shiftedReason
for i=1,12500 do
    shiftedPhase,shiftedRoute,shiftedReason=Route.advancePlan(
        shiftedSession,64)
    if shiftedPhase~="PENDING" then break end
end
assert(shiftedPhase=="DONE",shiftedReason)
assert(shiftedRoute.field==29 and shiftedRoute.edge==9
    and math.abs(shiftedRoute.estimatedTravelM-
        translated.estimatedTravelM)<0.001,
    "incremental general-field Control planning must match the reference")
-- Root outside the polygon may still start within the selected bounded
-- exterior edge corridor. Do not mistake identity for a field-interior veto.
local polygon=assert(G.polygonFor(g_fieldManager.fields[29]))
local exterior=G.edges(polygon)[9]
local midpointX=(exterior.ax+exterior.bx)/2
local midpointZ=(exterior.az+exterior.bz)/2
local nx,nz=G.outwardAt(polygon,exterior,midpointX,midpointZ)
assert(nx~=nil)
current.x,current.z=midpointX+nx*2,midpointZ+nz*2
assert(not G.inside(polygon,current.x,current.z))
local marginSession=assert(Route.beginPlan(vehicle,{
    sourceField=nonFixtureField,edgeIndex=9}))
local marginPhase,marginRoute,marginReason
for i=1,12500 do
    marginPhase,marginRoute,marginReason=Route.advancePlan(marginSession,64)
    if marginPhase~="PENDING" then break end
end
assert(marginPhase=="DONE"
    or (marginPhase=="FAILED"
        and marginReason~="COMPLETED_POSE_OUTSIDE_SELECTED_EDGE_ENVELOPE"),
    "bounded exterior start must be evaluated, never categorically vetoed")
current.x,current.z=midpointX+nx*30,midpointZ+nz*30
local refused,refusal=Route.plan(vehicle,nil,{
    sourceField=nonFixtureField,edgeIndex=9})
assert(refused==nil and refusal=="COMPLETED_POSE_OUTSIDE_SELECTED_EDGE_ENVELOPE",
    "an unqualified exterior start must remain outside admission")
print("completion settlement registered-field, actual-pose margin and TS019 regression PASS")
