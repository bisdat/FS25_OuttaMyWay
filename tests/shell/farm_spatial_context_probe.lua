-- Synthetic Field 77: road along Z_MIN, hedge protrusion on X_MAX,
-- field 78 beyond X_MAX and other farmland. Passive survey only.
OuttaMyWay={VERSION="0.5.5.1"}
local events,navCalls,splineCalls={},0,0
local diagnostic=false
OuttaMyWay.LogPublication={origin=function()
    return {publish=function(_,class,severity,code,make)
        assert(class=="DIAGNOSTIC")
        events[#events+1]={code=code,body=make()}
    end}
end}
local configuration={isResolved=function()return true end,
    isEnabled=function()return true end}
local source={publicationPolicy=function()
    return diagnostic and "DIAGNOSTIC" or "NORMAL"
end}
g_server={}
g_terrainNode=7
local function field(xs,zs)
    return {densityMapPolygon={pointsX=xs,pointsZ=zs}}
end
local field77=field({0,24,24,0},{0,0,24,24})
local field78=field({28,38,38,28},{4,4,20,20})
g_fieldManager={fields={[77]=field77,[78]=field78},
    getFieldById=function(self,id)return self.fields[id] end}
g_currentMission={aiSystem={navigationMap={},
    roadSplines={100}}}
getSplineLength=function(spline)
    assert(spline==100)
    return 24
end
getSplinePosition=function(spline,t)
    splineCalls=splineCalls+1
    return t*24,0,-5
end
getTerrainHeightAtWorldPos=function(node,x,y,z)
    assert(node==7)
    return 0
end
getVehicleNavigationMapCostAtWorldPos=function(nav,x,y,z)
    navCalls=navCalls+1
    local hedge=x>=26 and z>=6 and z<=18
    return hedge and 100 or 1,hedge
end
g_farmlandManager={
    getFarmlandIdAtWorldPosition=function(_,x,z)
        return x>24 and 20 or 10
    end,
    getOwnerIdAtWorldPosition=function(_,x,z)
        return x>24 and 8 or 7
    end,
    getCanAccessLandAtWorldPosition=function(_,farm,x,z)
        assert(farm==7)
        return x<=24
    end
}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/FarmSpatialContextProbe.lua")
local probe=OuttaMyWay.FarmSpatialContextProbe.new(configuration,source)
probe:loadMap()
probe:update(7000)
assert(#events==0 and navCalls==0 and splineCalls==0,
    "normal/debug publication must not calculate diagnostic geometry")
diagnostic=true
probe:update(7000)
assert(navCalls>0 and splineCalls>0,"DIAGNOSTIC must survey")
local counts={}
local find=function(code,edge,offset)
    for _,event in ipairs(events) do
        counts[event.code]=(counts[event.code] or 0)+1
        if event.code==code
            and (edge==nil or event.body.edge==edge)
            and (offset==nil or event.body.offsetM==offset) then
            return event.body
        end
    end
end
local summary=assert(find("FARM_CONTEXT_FIELD"))
assert(summary.field==77 and summary.vertexCount==4)
assert(summary.sourceFarmOwner=="7")
assert(summary.roadRegistered==1 and summary.roadPointsNearField>0)
local top=assert(find("FARM_CONTEXT_EDGE",1))
assert(top.side=="Z_MIN")
assert(tonumber(top.nearestRoadSplineSampleM)<=5.01)
local right=assert(find("FARM_CONTEXT_EDGE",2))
assert(right.side=="X_MAX" and right.nextVertex==3)
local rightTwo=assert(find("FIELD_EDGE_OUTSIDE_SAMPLE",2,2))
assert(rightTwo.navBlocked==2 and rightTwo.accessDenied==4)
assert(rightTwo.navBlockedIntervalsM=="6.00-18.00")
local rightSix=assert(find("FIELD_EDGE_OUTSIDE_SAMPLE",2,6))
assert(rightSix.neighborFieldIds=="78")
local left=assert(find("FARM_CONTEXT_EDGE",4))
assert(left.side=="X_MIN")
assert(find("FARM_CONTEXT_SURVEY_FINISHED"))
local before=#events
probe:update(10000)
assert(#events==before,"survey must not repeat")
probe:deleteMap()
diagnostic=false
probe:update(30000)
assert(#events==before,"disabled diagnostic must not run even after map restart")
print("Farm Spatial Context gated Field 77 survey PASS")
