-- Fresh selected-assembly occupancy relative to its retained Source Field.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- Called only after the native completion TRANSIT request; no fold readback.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionAssemblyFieldOccupancy={}
local M=OuttaMyWay.CompletionAssemblyFieldOccupancy
local G=OuttaMyWay.FarmEdgeGeometry
local A=OuttaMyWay.SettlementCorridorAssessment

local ORDER={1,2,4,3}
local function finite(v)
    return type(v)=="number" and v==v
        and v~=math.huge and v~=-math.huge
end

function M.assess(vehicle,sourceField)
    if type(sourceField)~="table" or type(sourceField.field)~="table"
        then return nil,"SOURCE_FIELD_ASSOCIATION_UNAVAILABLE" end
    local poly,why=G.polygonFor(sourceField.field)
    if poly==nil then return nil,why end
    local foot,reason=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return nil,reason end
    if not finite(foot.rootX) or not finite(foot.rootZ)
        or type(foot.corners)~="table"
        or not finite(foot.memberCount)
        or foot.memberCount<1 or foot.memberCount>16
        or #foot.corners~=foot.memberCount*4 then
        return nil,"ASSEMBLY_FIELD_OCCUPANCY_GEOMETRY_UNAVAILABLE"
    end
    local intersecting=0
    local allInside=true
    for member=1,foot.memberCount do
        local rect={}
        local memberInside=true
        for i=1,4 do
            local corner=foot.corners[(member-1)*4+ORDER[i]]
            if type(corner)~="table" or not finite(corner.x)
                or not finite(corner.z) then
                return nil,"ASSEMBLY_FIELD_OCCUPANCY_GEOMETRY_UNAVAILABLE"
            end
            local x,z=foot.rootX+corner.x,foot.rootZ+corner.z
            rect[i]={x=x,z=z}
            if not G.inside(poly,x,z) then memberInside=false end
        end
        local hit=A.shapeIntersectsPolygon(rect,poly)
        if hit==nil then return nil,"ASSEMBLY_FIELD_OCCUPANCY_INTERSECTION_UNAVAILABLE" end
        if hit then intersecting=intersecting+1 end
        if not memberInside then allInside=false end
    end
    local status=intersecting==0 and "CLEAR"
        or (allInside and "INSIDE" or "STRADDLING")
    return {status=status,sourceFieldId=sourceField.fieldId,
        memberCount=foot.memberCount,intersectingMembers=intersecting,
        basis=foot.basis or "SELECTED_MEMBER_BASE_RECTANGLES"}
end
