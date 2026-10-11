-- TEST 0.5.5.4: nominal actual-assembly polygon screen, not parking.
OuttaMyWay={VERSION="0.5.5.4"}
local events={}
OuttaMyWay.LogPublication={origin=function(name)
    assert(name=="ASSEMBLY_SETTLEMENT")
    return {publish=function(_,klass,severity,code,body)
        assert(klass=="DIAGNOSTIC" and severity=="INFO")
        events[#events+1]={code=code,body=body()}
    end}
end}
local function find(code)
    for i=1,#events do
        if events[i].code==code then return events[i].body end
    end
end
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
dofile("scripts/coordination/PairTransitRegion.lua")
dofile("scripts/observation/AssemblySettlementProbe.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local assessment=OuttaMyWay.SettlementCorridorAssessment
local probe=OuttaMyWay.AssemblySettlementProbe
local function field(xs,zs)
    local p=assert(G.polygonFor({densityMapPolygon={pointsX=xs,pointsZ=zs}}))
    local edges=G.edges(p)
    return p,edges
end
local source,edges=field({-50,50,50,-50},{-40,-40,0,0})
local band=assert((function()
    local p=G.polygonFor({densityMapPolygon={
        pointsX={-100,100,100,-100},pointsZ={8,8,90,90}}})
    return p
end)())
local fullBlock=assert((function()
    local p=G.polygonFor({densityMapPolygon={
        pointsX={-100,100,100,-100},pointsZ={0,0,90,90}}})
    return p
end)())
local foot={rootX=0,rootZ=-10,memberCount=2,corners={
    {x=-1,z=-3},{x=-1,z=3},{x=1,z=-3},{x=1,z=3},
    {x=-1.5,z=-13},{x=-1.5,z=-5},{x=1.5,z=-13},{x=1.5,z=-5}
}}
local a=assessment.assess(foot,0,1,source,edges[3],
    {{id=20,polygon=band}},false)
assert(a.assessed==144 and a.nominalNoPolygonConflict>0)
assert(a.terminal=="WAITING_FOR_EVIDENCE"
    and a.approach=="WAITING_FOR_EVIDENCE"
    and a.runOut=="WAITING_FOR_EVIDENCE")
assert(a.best and a.best.depthM>=2 and a.best.nominalWidthM>=3)
assert(a.best.direction==1 or a.best.direction==-1)
local blocked=assessment.assess(foot,0,1,source,edges[3],
    {{id=20,polygon=fullBlock}},false)
assert(blocked.nominalNoPolygonConflict==0
    and blocked.neighborConflicts>0)
-- A narrow field stripe can cut through a box even if all its corners are
-- outside; polygon segment intersections are essential.
local stripe=assert((function()
    local p=G.polygonFor({densityMapPolygon={
        pointsX={-100,100,100,-100},pointsZ={3,3,3.3,3.3}}})
    return p
end)())
local across=assessment.assess(foot,0,1,source,edges[3],
    {{id=21,polygon=stripe}},false)
assert(across.neighborConflicts>0)
local truncated=assessment.assess(foot,0,1,source,edges[3],{},true)
assert(truncated.assessed==0
    and truncated.reason=="GEOMETRY_OR_NEIGHBOR_CATALOGUE_UNAVAILABLE"
    and truncated.terminal=="WAITING_FOR_EVIDENCE")
local missing=assessment.assess(nil,0,1,source,edges[3],{},false)
assert(missing.assessed==0 and missing.nominalNoPolygonConflict==0)

-- Actual runtime fixture: mock two coupled native members using the genuine
-- production PairTransitRegion.capture, never an invented root-only outline.
local xs={131.79,143.52,153.81,162.43,165.16,165.55,175.32,
    182.15,228.15,-0.06,-10.56,-40.20}
local zs={-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,-480.63,
    -468.38,-243.04,-207.44,-343.82,-677.42}
local p77,e77=field(xs,zs)
assert(math.abs(e77[9].length-230.97)<0.01)
local positions={
    [100]={x=45,z=-225},
    [101]={x=45,z=-236}
}
local root,child={},{}
local function xml(width,length)
    return {getValue=function(_,key)
        if key=="vehicle.base.size#width" then return width end
        if key=="vehicle.base.size#length" then return length end
        return nil
    end}
end
root.rootNode=100
root.xmlFile=xml(2.4,5.5)
root.getAttachedImplements=function()
    return {{object=child}}
end
root.getRootVehicle=function() return root end
child.rootNode=101
child.xmlFile=xml(3.2,8.0)
child.getAttachedImplements=function() return {} end
child.getRootVehicle=function() return root end
local mutations=0
root.setFoldDirection=function() mutations=mutations+1 end
root.driveToPoint=function() mutations=mutations+1 end
getWorldTranslation=function(node)
    local pos=assert(positions[node])
    return pos.x,0,pos.z
end
localToWorld=function(node,x,_,z)
    local pos=assert(positions[node])
    return pos.x+x,0,pos.z+z
end
localDirectionToWorld=function(node,x,_,z)
    return x,0,z
end
g_currentMission={vehicleSystem={vehicles={root,child}}}
assert(probe.run(77,p77,e77,{},false,nil)==true)
local scan=assert(find("ASSEMBLY_SETTLEMENT_SCAN"))
assert(scan.candidatesNearField==1 and scan.selectedSubjects==1)
local observation=assert(find("ASSEMBLY_SETTLEMENT_NOMINAL_SCREENED"))
assert(observation.memberCount==2
    and observation.nominalBasis=="GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION")
assert(observation.nominalScreened==144
    and observation.nominalCandidateCount>=0
    and observation.terminal=="WAITING_FOR_EVIDENCE"
    and observation.configuration=="UNVERIFIED_TRANSIT")
assert(observation.note=="CANDIDATE_ONLY_NEVER_MOVEMENT_AUTHORITY")
assert(mutations==0,"geometry screening cannot actuate")
assert(find("ASSEMBLY_SETTLEMENT_FINISHED").observedSubjects==1)

events={}
assert(probe.run(77,p77,e77,{},true,nil)==true)
local unresolved=assert(find("ASSEMBLY_SETTLEMENT_NOMINAL_SCREENED"))
assert(unresolved.nominalScreened==0
    and unresolved.reason=="GEOMETRY_OR_NEIGHBOR_CATALOGUE_UNAVAILABLE")
assert(unresolved.nominalCandidateCount==0)

events={}
assert(probe.run(77,p77,e77,{},false,2)==false)
assert(#events==0,"Farmland selector must not open Field77 experiment")
events={}
assert(probe.run(29,p77,e77,{},false,nil)==false)
assert(#events==0)
local shifted={}
for i=1,#xs do shifted[i]=xs[i]+500 end
local fake,fe=field(shifted,zs)
events={}
assert(probe.run(77,fake,fe,{},false,nil)==false)
assert(#events==0,"same edge length on other map must not match")
g_currentMission.vehicles={}
events={}
assert(probe.run(77,p77,e77,{},false,nil)==true)
assert(find("ASSEMBLY_SETTLEMENT_UNAVAILABLE").reason==
    "NO_ASSEMBLY_IN_FIELD_OR_NEAR_EDGE")
assert(mutations==0)
print("Assembly-specific settlement nominal polygon screen: PASS")
