-- Actual-pose, whole-assembly infield reposition qualification.
-- A nominal intermediate movement is not a parked terminal.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
dofile("scripts/coordination/SettlementPhysicalOccupancy.lua")
local source={fieldId=2,densityMapPolygon={
    pointsX={0,200,200,0},pointsZ={0,0,120,120}}}
local association={fieldId=2,field=source}
g_fieldManager={fields={[2]=source}}
local vehicle={rootNode=77,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local actual={x=12,z=60,fx=-1,fz=0}
g_currentMission={vehicleSystem={vehicles={vehicle}}}
getWorldTranslation=function(node)
    assert(node==77)
    return actual.x,0,actual.z
end
localDirectionToWorld=function(node)
    assert(node==77)
    return actual.fx,0,actual.fz
end
OuttaMyWay.PairTransitRegion={capture=function()
    local corners={}
    for _,x in ipairs({-1,1}) do
        for _,z in ipairs({-2,2}) do
            corners[#corners+1]={x=x,z=z}
        end
    end
    return {memberCount=1,corners=corners}
end}
dofile("scripts/coordination/ExtendedInfieldApproach.lua")
local E=OuttaMyWay.ExtendedInfieldApproach
local route,why=E.planReposition(vehicle,association)
assert(route,why)
assert(route.mode=="REPOSITION_INFIELD"
    and route.field==2 and route.memberCount==1
    and route.method=="INFIELD_STRAIGHT_REVERSE"
    and route.reverseM>0 and route.reverseM<=12
    and route.estimatedTravelM<=12 and #route.legs>=2,
    "a boundary-facing assembly should qualify a short straight retreat")
assert(route.nominalMarginGainM>=1.5)
for _,leg in ipairs(route.legs) do
    assert(leg.moveForwards==false and leg.arrivalRadiusM==0.75)
    assert(leg.point.x>actual.x)
    assert(OuttaMyWay.FarmEdgeGeometry.inside(
        route.poly,leg.point.x,leg.point.z))
end
assert(E.guard(vehicle,route,1),
    "reposition uses the existing live whole-member infield guard")
-- No physical source-field clearance means no intermediate manoeuvre.
actual.x=0.5
local refused,reason=E.planReposition(vehicle,association)
assert(refused==nil and reason=="REPOSITION_START_NOT_FULLY_INSIDE_SOURCE")
print("extended infield qualified reposition and fail-closed partial-member geometry PASS")
