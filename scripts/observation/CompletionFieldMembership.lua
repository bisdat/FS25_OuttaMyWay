-- Read-only Source Field association from the completed assembly's actual
-- position, independent of native FIELDWORK course/job internals.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionFieldMembership={}
local Membership=OuttaMyWay.CompletionFieldMembership
local G=OuttaMyWay.FarmEdgeGeometry
local MAX_FIELDS=512

local function finite(v)
    return type(v)=="number" and v==v
        and v~=math.huge and v~=-math.huge
end

function Membership.identify(vehicle)
    if type(vehicle)~="table" then
        return nil,"COMPLETED_ASSEMBLY_UNAVAILABLE"
    end
    local root=vehicle
    if type(vehicle.getRootVehicle)=="function" then
        local ok,result=pcall(vehicle.getRootVehicle,vehicle)
        if not ok or type(result)~="table" then
            return nil,"COMPLETED_ASSEMBLY_ROOT_UNAVAILABLE"
        end
        root=result
    end
    if root.rootNode==nil or root.rootNode==0
        or type(getWorldTranslation)~="function" then
        return nil,"COMPLETED_ASSEMBLY_POSE_UNAVAILABLE"
    end
    local ok,x,_,z=pcall(getWorldTranslation,root.rootNode)
    if not ok or not finite(x) or not finite(z) then
        return nil,"COMPLETED_ASSEMBLY_POSE_UNAVAILABLE"
    end
    local manager=g_fieldManager
    local fields=manager and manager.fields
    if type(fields)~="table" then
        return nil,"REGISTERED_FIELD_CATALOGUE_UNAVAILABLE"
    end
    if type(G)~="table" or type(G.polygonFor)~="function"
        or type(G.inside)~="function" then
        return nil,"FIELD_GEOMETRY_UNAVAILABLE"
    end
    local selected,examined=nil,0
    local seen={}
    for key,field in pairs(fields) do
        examined=examined+1
        if examined>MAX_FIELDS then
            return nil,"REGISTERED_FIELD_CATALOGUE_LIMIT"
        end
        if type(field)=="table" and not seen[field] then
            seen[field]=true
            local poly=G.polygonFor(field)
            if poly==nil then
                -- Cannot positively establish a unique match if another
                -- registered polygon's membership is unreadable.
                return nil,"REGISTERED_FIELD_POLYGON_UNAVAILABLE"
            end
            if G.inside(poly,x,z) then
                if selected~=nil then
                    return nil,"ASSEMBLY_FIELD_MEMBERSHIP_AMBIGUOUS"
                end
                local id=field.fieldId or key
                if type(id)~="number" or not finite(id)
                    or id<1 or id%1~=0 then
                    return nil,"REGISTERED_FIELD_ID_UNAVAILABLE"
                end
                selected={fieldId=id,field=field,polygon=poly,
                    rootX=x,rootZ=z,rootNode=root.rootNode,
                    provenance="ASSEMBLY_ROOT_REGISTERED_POLYGON_MEMBERSHIP"}
            end
        end
    end
    if selected==nil then
        return nil,"ASSEMBLY_OUTSIDE_REGISTERED_FIELDS"
    end
    return selected
end
return Membership
