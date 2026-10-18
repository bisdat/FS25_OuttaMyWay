-- Registered Source Field geometry for completion parking. A field is
-- associated from the completed assembly's position, not job internals.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionParkingGeometry={}
local M=OuttaMyWay.CompletionParkingGeometry
local G=OuttaMyWay.FarmEdgeGeometry
local MAX_FIELDS=512
-- A possible terminal needs at least three metres of longitudinal margin
-- from each endpoint; actual member fit is evaluated by the route planner.
local MIN_EDGE_M=6
local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end
function M.enumerate(sourceField,vehicle)
    if type(sourceField)~="table" or not finite(sourceField.fieldId)
        or type(sourceField.field)~="table" then
        return nil,"SOURCE_FIELD_ASSOCIATION_UNAVAILABLE"
    end
    local manager=g_fieldManager
    if type(manager)~="table" or type(manager.fields)~="table" then
        return nil,"FIELD_REGISTRY_UNAVAILABLE"
    end
    local poly,why=G.polygonFor(sourceField.field)
    if poly==nil then return nil,why end
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then
        return nil,"COMPLETION_ROOT_POSE_UNAVAILABLE"
    end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if not ok or not finite(x) or not finite(z) then
        return nil,"COMPLETION_ROOT_POSE_UNAVAILABLE"
    end
    local neighbors,seen,scanned={},{},0
    seen[sourceField.field]=true
    for _,field in pairs(manager.fields) do
        scanned=scanned+1
        if scanned>MAX_FIELDS then
            return nil,"FIELD_CATALOGUE_TRUNCATED"
        end
        if type(field)=="table" and not seen[field] then
            seen[field]=true
            local p=G.polygonFor(field)
            if p==nil then return nil,"NEIGHBOR_POLYGON_UNAVAILABLE" end
            neighbors[#neighbors+1]={polygon=p}
        end
    end
    local frames={}
    for _,edge in ipairs(G.edges(poly)) do
        if edge.length>=MIN_EDGE_M then
            local midX,midZ=(edge.ax+edge.bx)/2,(edge.az+edge.bz)/2
            local nx,nz=G.outwardAt(poly,edge,midX,midZ)
            if nx~=nil then
                frames[#frames+1]={index=edge.index,
                    ax=edge.ax,az=edge.az,ux=edge.dx/edge.length,
                    uz=edge.dz/edge.length,nx=nx,nz=nz,
                    length=edge.length,
                    distance=G.pointSegmentDistance(x,z,
                        edge.ax,edge.az,edge.bx,edge.bz)}
            end
        end
    end
    if #frames==0 then return nil,"NO_GEOMETRICALLY_ELIGIBLE_FIELD_EDGE" end
    table.sort(frames,function(a,b)
        if a.distance==b.distance then return a.index<b.index end
        return a.distance<b.distance
    end)
    return {fieldId=sourceField.fieldId,poly=poly,neighbors=neighbors,
        frames=frames,rootX=x,rootZ=z}
end
function M.select(context,edgeIndex)
    if type(context)~="table" or type(context.frames)~="table"
        then return nil,"FIELD_EDGE_CONTEXT_UNAVAILABLE" end
    if edgeIndex==nil then return context.frames[1] end
    for i=1,#context.frames do
        if context.frames[i].index==edgeIndex then
            return context.frames[i]
        end
    end
    return nil,"REQUESTED_FIELD_EDGE_UNAVAILABLE"
end
return M
