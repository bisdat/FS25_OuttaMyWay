-- TEST 0.5.5.3 bounded physical-margin diagnostic, in GIANTS-free LuaJIT.
-- Positive collisions do not imply that a whole articulated assembly fits.
OuttaMyWay={VERSION="0.5.5.3"}
local events={}
OuttaMyWay.LogPublication={origin=function(origin)
    assert(origin=="PHYSICAL_MARGIN")
    return {publish=function(_,kind,severity,code,make)
        assert(kind=="DIAGNOSTIC")
        events[#events+1]={code=code,body=make()}
    end}
end}
local function find(code,role,physics)
    for i=1,#events do
        local event=events[i]
        if event.code==code and (role==nil or event.body.role==role)
            and (physics==nil or event.body.physics==physics) then
            return event.body
        end
    end
end
local calls=0
g_terrainNode=7
g_currentMission={aiSystem={navigationMap=20}}
getTerrainHeightAtWorldPos=function(_,x,__,z)
    if z>0 and z<200 then return 1 end
    return 0
end
getTerrainNormalAtWorldPos=function(_,x,y,z)
    return 0,1,0
end
getVehicleNavigationMapCostAtWorldPos=function(_,x,y,z)
    return 2,false
end
g_farmlandManager={getFarmlandIdAtWorldPosition=function(_,x,z)
    return x<0 and 2 or 77
end}
CollisionFlag={STATIC_OBJECT=1,BUILDING=2,TREE=4,
    ROAD=8,AI_BLOCKING=16}
CollisionFlag.getHasGroupFlagSet=function(node,flag)
    return node==400 and flag==CollisionFlag.TREE
        or node==800 and flag==CollisionFlag.ROAD
end
local mode="field77"
overlapBox=function(x,y,z,rx,ry,rz,ex,ey,ez,callback,target,mask,dyn,kin,stat,exact)
    calls=calls+1
    assert(callback=="onOverlapHit" and type(target[callback])=="function")
    assert(ex==0.45 and ey==1 and ez==0.45)
    assert(dyn==false and kin==true and stat==true and exact==true)
    assert(mask==31)
    if mode=="field77" and x>150 and z< -606 and z> -658 then
        target[callback](target,400) -- hedge collider on an edge-2 control
    elseif mode=="riverbend" and z<115 then
        target[callback](target,800) -- road-labelled collider on edge-7 control
    end
end
getName=function(node) return node==400 and "hedge" or "road" end

dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/PhysicalMarginConstraintProbe.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local physical=OuttaMyWay.PhysicalMarginConstraintProbe
local function geometry(xs,zs)
    local poly=assert(G.polygonFor({densityMapPolygon={pointsX=xs,pointsZ=zs}}))
    local edges=G.edges(poly)
    for i=1,#edges do edges[i].polygon=poly end
    return poly,edges
end

-- Real 1.24 field vertices are deliberately used only as a test fixture;
-- runtime gating checks field identity and edge lengths before sampling.
local field77,edges77=geometry(
    {131.79,143.52,153.81,162.43,165.16,165.55,175.32,
     182.15,228.15,-0.06,-10.56,-40.20},
    {-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,-480.63,
     -468.38,-243.04,-207.44,-343.82,-677.42})
assert(math.abs(edges77[9].length-230.97)<0.02)
assert(physical.run(77,field77,edges77,nil)==true)
local capability=assert(find("PHYSICAL_MARGIN_CAPABILITY"))
assert(capability.field==77 and capability.fixture=="MINDENERWALD_FIELD77")
assert(capability.overlapBoxApi and capability.terrainNormalApi)
local south=assert(find("PHYSICAL_MARGIN_POINT","PREFERRED_MARGIN","NO_REPRESENTED_HIT"))
assert(south.sourcePolygonMembership=="OUTSIDE")
assert(south.terrainStatus=="AVAILABLE" and south.navBlocking=="unblocked")
local hedge=assert(find("PHYSICAL_MARGIN_POINT","VISIBLE_CONTROL","HIT"))
assert(hedge.treeGroupHits>0 and hedge.roadGroupHits==0)
local summary=assert(find("PHYSICAL_MARGIN_SURVEY_FINISHED"))
assert(summary.physicsErrors==0 and summary.physicsCalls<=22
    and summary.points<=24 and summary.roadGroupHits==0)
assert(calls==summary.physicsCalls)
assert(summary.note=="NO_CLEARANCE_OR_ROAD_BOUNDARY_CERTIFICATE")

local riverbend,edges29=geometry(
    {-898.15,-849.01,-850.41,-857.36,-869.46,-888.16,-910.16,
     -969.82,-976.57,-979.42,-974.90,-972.24,-965.02,-954.21},
    {304.13,170.91,158.61,145.55,135.20,127.84,123.27,
     117.04,119.64,126.08,245.24,262.29,276.79,286.41})
mode="riverbend"
events={}
calls=0
assert(math.abs(edges29[1].length-141.99)<0.02)
assert(physical.run(29,riverbend,edges29,2)==true)
capability=assert(find("PHYSICAL_MARGIN_CAPABILITY"))
assert(capability.fixture=="RIVERBEND_FARMLAND2_FIELD29")
local road=assert(find("PHYSICAL_MARGIN_POINT","VISIBLE_CONTROL","HIT"))
assert(road.roadGroupHits>0 and road.treeGroupHits==0)
summary=assert(find("PHYSICAL_MARGIN_SURVEY_FINISHED"))
assert(summary.roadGroupHits>0 and summary.physicsCalls<=22
    and summary.points<=24 and calls==summary.physicsCalls)
assert(summary.sampleTruncated==false and summary.physicsTruncated==false)

-- Missing physics is a stated unknown; terrain evidence still publishes.
events={}
overlapBox=nil
assert(physical.run(29,riverbend,edges29,2)==true)
capability=assert(find("PHYSICAL_MARGIN_CAPABILITY"))
assert(capability.overlapBoxApi==false)
local missing=assert(find("PHYSICAL_MARGIN_POINT","PREFERRED_MARGIN","API_UNAVAILABLE"))
assert(missing.terrainStatus=="AVAILABLE")
assert(missing.physicsHits==0 and missing.note=="OBSERVATION_NOT_CLEARANCE")

-- Faulting API cannot falsely return "no hit".
events={}
overlapBox=function() error("synthetic physics failure") end
assert(physical.run(29,riverbend,edges29,2)==true)
assert(find("PHYSICAL_MARGIN_POINT","PREFERRED_MARGIN","QUERY_FAILED"))
summary=assert(find("PHYSICAL_MARGIN_SURVEY_FINISHED"))
assert(summary.physicsErrors>0)

-- A similarly numbered field with altered topology is NOT the known map.
events={}
local wrong,wrongEdges=geometry({0,24,24,0},{0,0,24,24})
assert(physical.run(77,wrong,wrongEdges,nil)==false)
assert(find("PHYSICAL_MARGIN_UNAVAILABLE").reason=="FIXTURE_EDGE_GEOMETRY_MISMATCH")
assert(find("PHYSICAL_MARGIN_POINT")==nil)
events={}
assert(physical.run(29,riverbend,edges29,7)==false)
assert(find("PHYSICAL_MARGIN_UNAVAILABLE").reason=="UNSUPPORTED_EXPERIMENT_FIXTURE")

print("Physical Margin Constraint probe: bounded source-witness contracts PASS")
