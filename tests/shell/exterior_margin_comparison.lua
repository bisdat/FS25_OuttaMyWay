-- A passive diagnostic comparison must not choose or actuate parking.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
dofile("scripts/assessment/ExteriorMarginComparison.lua")
local Geometry=OuttaMyWay.FarmEdgeGeometry
local source={fieldId=29,densityMapPolygon={
    pointsX={0,50,50,0},pointsZ={0,0,30,30}}}
local neighbor={fieldId=30,densityMapPolygon={
    pointsX={50,70,70,50},pointsZ={0,0,30,30}}}
g_fieldManager={fields={[29]=source,[30]=neighbor}}
local vehicle={rootNode=400}
getWorldTranslation=function()return 20,0,15 end
localDirectionToWorld=function()return 0,0,1 end
g_currentMission={terrainRootNode=1234}
local terrainCalls=0
getTerrainHeightAtWorldPos=function(_,x,_,z)
    terrainCalls=terrainCalls+1
    return x*0.1
end
local footprintCalls=0
OuttaMyWay.PairTransitRegion={capture=function()
    footprintCalls=footprintCalls+1
    -- Two selected attached-member rectangles at different offsets.
    local result={}
    for _,offset in ipairs({0,-7}) do
        for _,side in ipairs({-1,1}) do
            for _,longitudinal in ipairs({-2,2}) do
                result[#result+1]={x=side,z=offset+longitudinal}
            end
        end
    end
    return {memberCount=2,corners=result}
end}
local Comparison=OuttaMyWay.ExteriorMarginComparison
local field={fieldId=29,field=source}
local episode=assert(Comparison.beginComparison(vehicle,field))
assert(episode.nearestEdge and episode.foot.memberCount==2
    and footprintCalls==1)
local phases={}
for i=1,4 do
    local phase,result,reason=Comparison.advanceComparison(episode)
    phases[i]=phase
    if i<4 then
        assert(phase=="PENDING" and result==nil and #episode.rows==i,
            "comparison must only process one edge per update")
    else
        assert(phase=="DONE" and result==episode and #episode.rows==4)
    end
end
assert(terrainCalls==8,"two optional terrain reads per edge")
local byEdge={}
for _,row in ipairs(episode.rows) do
    byEdge[row.edge]=row
    assert(row.tested==18 and row.nominalUnknown==0,
        "finite stationary samples must not claim continuous coverage")
end
assert(byEdge[2].nominalFits==0,
    "a directly adjacent registered field must not appear clear")
assert(byEdge[4].nominalFits>0,
    "an exterior strip without a neighbour can have nominal fits")
assert(math.abs(byEdge[4].terrainDelta)>0.1,
    "terrain report must retain measured elevation change")
assert(string.find(Comparison.summarize(episode),"nominal",1,true))
assert(Comparison.advanceComparison(episode)=="FAILED",
    "completed comparison cannot silently repeat")
getTerrainHeightAtWorldPos=nil
local unavailable=assert(Comparison.beginComparison(vehicle,field))
for i=1,4 do Comparison.advanceComparison(unavailable) end
for _,row in ipairs(unavailable.rows) do
    assert(row.terrainDelta==nil,
        "missing terrain API is unknown, not zero gradient")
end
assert(footprintCalls==2,
    "a separate complete comparison captures the actual member geometry once")
print("exterior margin comparison: incremental nominal evidence and unknown terrain PASS")
