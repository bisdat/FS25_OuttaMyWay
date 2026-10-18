-- Registered Source Field occupancy uses real selected-member rectangles,
-- never just tractor root membership or fold animation state.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local field={fieldId=29,densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}}}
local source={field=field,fieldId=29}
local root={rootNode=10}
local boxes={}
local function rectangle(cx,cz,w,l)
    return {{x=cx-w/2,z=cz-l/2},{x=cx-w/2,z=cz+l/2},
        {x=cx+w/2,z=cz-l/2},{x=cx+w/2,z=cz+l/2}}
end
OuttaMyWay.PairTransitRegion={capture=function()
    local corners={}
    for _,rect in ipairs(boxes) do
        for _,v in ipairs(rect) do
            corners[#corners+1]={x=v.x,z=v.z}
        end
    end
    return {rootX=0,rootZ=0,corners=corners,memberCount=#boxes}
end}
dofile("scripts/observation/CompletionAssemblyFieldOccupancy.lua")
local classify=OuttaMyWay.CompletionAssemblyFieldOccupancy.assess
boxes={rectangle(10,10,4,8)}
local result=assert(classify(root,source))
assert(result.status=="INSIDE" and result.intersectingMembers==1)
-- The tractor root and its rectangle can be outside, while the implement
-- remains in productive space. Neither is inferable from root position alone.
boxes={rectangle(105,40,4,8),rectangle(98,40,8,12)}
result=assert(classify(root,source))
assert(result.status=="STRADDLING" and result.memberCount==2
    and result.intersectingMembers==1)
boxes={rectangle(105,40,4,8),rectangle(110,40,4,8)}
result=assert(classify(root,source))
assert(result.status=="CLEAR" and result.intersectingMembers==0)
-- The root itself may be within the field even though attached members
-- still straddle its boundary.
boxes={rectangle(97,40,8,8),rectangle(105,40,4,8)}
assert(assert(classify(root,source)).status=="STRADDLING")
-- Boundary crossing without any rectangle corner inside must be detected.
boxes={rectangle(50,50,110,4)}
assert(assert(classify(root,source)).status=="STRADDLING")
-- Missing geometry is not successful field clearance.
OuttaMyWay.PairTransitRegion.capture=function()
    return nil,"TRANSIT_MEMBER_SIZE_UNAVAILABLE"
end
local unknown,why=classify(root,source)
assert(unknown==nil and why=="TRANSIT_MEMBER_SIZE_UNAVAILABLE")
print("selected physical-assembly Source Field occupancy PASS")
