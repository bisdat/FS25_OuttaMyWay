-- TEST 0.5.5.6: continuous straight rigid-sweep *polygon* geometry,
-- not steering, physical obstacles, post-completion movement or parking.
OuttaMyWay={VERSION="0.5.5.6"}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
dofile("scripts/assessment/SettlementStraightRunout.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local Static=OuttaMyWay.SettlementCorridorAssessment
local Runout=OuttaMyWay.SettlementStraightRunout
local function polygon(xs,zs)
    return assert(G.polygonFor({densityMapPolygon={
        pointsX=xs,pointsZ=zs}}))
end
local source=polygon({-100,100,100,-100},{-20,-20,0,0})
-- Stationary endpoints lie outside this *narrow intervening band*;
-- simple two-pose checks miss it, but exact convex swept union must hit.
local wall=polygon({20,21,21,20},{2,2,10,10})
local root={{x=-1,z=3},{x=-1,z=5},{x=1,z=5},{x=1,z=3}}
local child={{x=-1.5,z=7},{x=-1.5,z=9},{x=1.5,z=9},{x=1.5,z=7}}
local seed={stationM=10,depthM=4,direction=1,tx=1,tz=0,
    forwardHeadroomM=40,rects={root}}
assert(Static.shapeIntersectsPolygon(root,source)==false)
assert(Static.shapeIntersectsPolygon(root,wall)==false)
local endRect={}
for i=1,4 do
    endRect[i]={x=root[i].x+40,z=root[i].z}
end
assert(Static.shapeIntersectsPolygon(endRect,wall)==false,
    "Endpoint-only screening must miss this interior obstruction")
local sampled={sweepSeeds={seed},terminal="WAITING_FOR_EVIDENCE"}
local blocked=Runout.assess(sampled,source,{{polygon=wall}},false)
assert(blocked.assessedSeeds==1
    and blocked.continuousGeometrySeeds==1
    and blocked.unknownSeeds==0
    and blocked.maxLowerBoundM>18 and blocked.maxLowerBoundM<19.001)
assert(blocked.results[1].lowerBoundM<blocked.results[1].upperBoundM)
assert(blocked.results[1].blockedBy=="NEIGHBOR_FIELD_INTERSECTION")
assert(blocked.results[1].queryCount<=10)
assert(blocked.status=="WAITING_FOR_EVIDENCE",
    "Polygon-only geometry never admits physical run-out")
local free=Runout.assess(sampled,source,{},false)
assert(free.results[1].lowerBoundM==40 and free.results[1].upperBoundM==40)
assert(free.results[1].blockedBy=="EDGE_ENDPOINT_LIMIT")
assert(free.status=="WAITING_FOR_EVIDENCE")

-- A trailing member, not the tractor rectangle, strikes a barrier.
local childOnlyWall=polygon({20,21,21,20},{7.2,7.2,8.2,8.2})
assert(Static.shapeIntersectsPolygon(root,childOnlyWall)==false)
local twoMembers={sweepSeeds={{
    stationM=10,depthM=4,direction=1,tx=1,tz=0,
    forwardHeadroomM=40,rects={root,child}
}}}
local trailing=Runout.assess(twoMembers,source,
    {{polygon=childOnlyWall}},false)
assert(trailing.results[1].blockedBy=="NEIGHBOR_FIELD_INTERSECTION")
assert(trailing.results[1].lowerBoundM<40)
-- Unknown polygon coverage must never be silently interpreted as clear.
local unresolved=Runout.assess(sampled,source,{{polygon=nil}},false)
assert(unresolved.continuousGeometrySeeds==0
    and unresolved.unknownSeeds==1
    and unresolved.maxLowerBoundM==0)
assert(unresolved.results[1].status=="WAITING_FOR_EVIDENCE")
local truncated=Runout.assess(sampled,source,{},true)
assert(truncated.assessedSeeds==0
    and truncated.reason=="GEOMETRY_OR_NEIGHBOR_CATALOGUE_UNAVAILABLE")
local missing=Runout.assess({},source,{},false)
assert(missing.assessedSeeds==0 and missing.maxLowerBoundM==0)
local overBudget={sweepSeeds={seed,seed,seed,seed,seed}}
assert(Runout.assess(overBudget,source,{},false).assessedSeeds==0)

-- Direction is physical: along a chosen exterior strip, different
-- directions reach different occlusions, irrespective of static end fits.
local backwards={sweepSeeds={{
    stationM=30,depthM=4,direction=-1,tx=-1,tz=0,
    forwardHeadroomM=40,rects={root}
}}}
local reverse=Runout.assess(backwards,source,{{polygon=wall}},false)
assert(reverse.results[1].lowerBoundM==40)
assert(blocked.results[1].lowerBoundM<reverse.results[1].lowerBoundM)

-- Real two-member static capture remains a *nominal* source and generates
-- at most four direction-aware nonmoving sweep seeds.
local nominalFoot={rootX=0,rootZ=0,memberCount=2,corners={
    {x=-1,z=-3},{x=-1,z=3},{x=1,z=-3},{x=1,z=3},
    {x=-1.5,z=-12},{x=-1.5,z=-5},{x=1.5,z=-12},{x=1.5,z=-5}
}}
local field77=polygon({-50,50,50,-50},{-40,-40,0,0})
local e=G.edges(field77)[3]
local candidate=Static.assess(nominalFoot,0,1,field77,e,{},false)
assert(candidate.nominalNoPolygonConflict>0)
assert(#candidate.sweepSeeds>0 and #candidate.sweepSeeds<=4)
local fromStatic=Runout.assess(candidate,field77,{},false)
assert(fromStatic.assessedSeeds==#candidate.sweepSeeds)
assert(fromStatic.queryCount<=40)
assert(candidate.approach=="WAITING_FOR_EVIDENCE"
    and candidate.runOut=="WAITING_FOR_EVIDENCE"
    and candidate.terminal=="WAITING_FOR_EVIDENCE")
print("Settlement straight-runout continuous nominal polygon contract: PASS")
