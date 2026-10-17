-- Registered parking geometry is field-agnostic and never relies on
-- fixture coordinates, native job seeds or displayed farmland identifiers.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionFieldMembership.lua")
dofile("scripts/observation/CompletionParkingGeometry.lua")
local Membership=OuttaMyWay.CompletionFieldMembership
local Parking=OuttaMyWay.CompletionParkingGeometry
local function field(id,x1,z1,x2,z2)
    return {fieldId=id,densityMapPolygon={pointsX={x1,x2,x2,x1},
        pointsZ={z1,z1,z2,z2}}}
end
local field77=field(77,0,0,250,250)
local field29=field(29,500,500,800,800)
g_fieldManager={fields={[77]=field77,[29]=field29}}
local poses={[1]={x=100,z=80},[2]={x=600,z=560}}
getWorldTranslation=function(node)
    local p=poses[node]
    return p.x,0,p.z
end
local first={rootNode=1}
local second={rootNode=2}
local source77=assert(Membership.identify(first))
local source29=assert(Membership.identify(second))
assert(source77.fieldId==77 and source29.fieldId==29)
local c77=assert(Parking.enumerate(source77,first))
local c29=assert(Parking.enumerate(source29,second))
assert(c77.fieldId==77 and c29.fieldId==29)
assert(#c77.frames==4 and #c29.frames==4,
    "every registered candidate is screened by actual geometry")
local found={}
for _,f in ipairs(c29.frames) do
    assert(f.length>=6 and f.index>=1 and f.index<=4)
    found[f.index]=true
    assert(f.nx~=nil and f.nz~=nil and f.ux~=nil)
end
assert(found[1] and found[2] and found[3] and found[4])
assert(assert(Parking.select(c29,3)).index==3)
assert(Parking.select(c29,9)==nil,
    "a fixture edge must not be substituted for an absent field edge")
local initialEdge=assert(Parking.select(c29))
poses[2]={x=790,z=750}
local moved=assert(Parking.enumerate(source29,second))
assert(assert(Parking.select(moved)).index~=initialEdge.index,
    "edge priority responds to current position, not a map fixture")
g_fieldManager.fields[15]=field(15,0,900,50,940)
local context=assert(Parking.enumerate(source29,second))
assert(#context.neighbors==2)
g_fieldManager.fields[15]=nil
local narrow=field(15,1000,1000,1014,1010)
g_fieldManager.fields[15]=narrow
poses[2]={x=790,z=750}
local narrowContext=assert(Parking.enumerate({
    field=narrow,fieldId=15}, {rootNode=2}))
assert(#narrowContext.frames==4,
    "small but geometrically possible edges must not be discarded by a 40m fixture")
g_fieldManager.fields[15]=nil
g_fieldManager.fields[3]={fieldId=3,densityMapPolygon={}}
local missing,why=Parking.enumerate(source29,second)
assert(missing==nil and why=="NEIGHBOR_POLYGON_UNAVAILABLE")
print("completion parking registered multi-field/multi-edge geometry PASS")
