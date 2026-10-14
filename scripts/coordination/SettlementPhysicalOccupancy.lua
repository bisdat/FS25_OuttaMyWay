-- Experimental physical occupancy evidence for settlement allocation.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- AI job completion does NOT release a physical assembly's occupied space.
-- Read-only. No native driving, BWR signalling or Control authority.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.SettlementPhysicalOccupancy={}
local M=OuttaMyWay.SettlementPhysicalOccupancy
local MAX_SCENE=512
local EXTRA_M=3
local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end
local function rootOf(vehicle)
    if type(vehicle)~="table" then return nil end
    if type(vehicle.getRootVehicle)=="function" then
        local ok,root=pcall(vehicle.getRootVehicle,vehicle)
        if ok and type(root)=="table" then return root end
    end
    return type(vehicle.rootVehicle)=="table" and vehicle.rootVehicle or vehicle
end
local function position(root)
    if root.rootNode==nil or root.rootNode==0
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,root.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil end
    return x,z
end
local function radius(vehicle)
    local region=OuttaMyWay.PairTransitRegion
    local foot=type(region)=="table"
        and type(region.capture)=="function"
        and region.capture(vehicle) or nil
    local radiusM=5
    if type(foot)=="table" and type(foot.corners)=="table" then
        for i=1,#foot.corners do
            local v=foot.corners[i]
            if finite(v.x) and finite(v.z) then
                radiusM=math.max(radiusM,math.sqrt(v.x*v.x+v.z*v.z))
            end
        end
    else
        -- Root-only fallback carries a large uncertainty reserve rather
        -- than incorrectly classifying a visible vehicle as empty space.
        radiusM=22
    end
    return radiusM
end
function M.footRadius(vehicle)
    return radius(vehicle)
end
function M.snapshot(vehicle,poly)
    local mission=g_currentMission
    local registry=mission and mission.vehicleSystem
        and mission.vehicleSystem.vehicles
    if type(registry)~="table" then
        return nil,"PHYSICAL_OCCUPANCY_REGISTRY_UNAVAILABLE"
    end
    local selfRoot=rootOf(vehicle)
    local result,seen={},{}
    local examined=0
    local function consider(item)
        if type(item)~="table" then return true end
        local root=rootOf(item)
        if root==nil or root==selfRoot or root.isDeleted==true
            or root.rootNode==nil or root.rootNode==0
            or seen[root.rootNode] then return true end
        seen[root.rootNode]=true
        local x,z=position(root)
        if x==nil then
            return false,"PHYSICAL_OCCUPANCY_POSE_UNAVAILABLE"
        end
        -- Include source field and its immediate exterior parking margin.
        -- A registered other-field vehicle is still physical occupancy.
        if poly~=nil and (x<poly.minX-50 or x>poly.maxX+50
            or z<poly.minZ-50 or z>poly.maxZ+50) then return true end
        local r=radius(root)
        if r==nil then return false,"PHYSICAL_OCCUPANCY_FOOTPRINT_UNAVAILABLE" end
        result[#result+1]={vehicle=root,rootNode=root.rootNode,
            x=x,z=z,radius=r}
        return true
    end
    for key,value in pairs(registry) do
        examined=examined+1
        if examined>MAX_SCENE then
            return nil,"PHYSICAL_OCCUPANCY_CENSUS_LIMIT"
        end
        local ok,why=consider(key)
        if not ok then return nil,why end
        ok,why=consider(value)
        if not ok then return nil,why end
    end
    return result,nil
end
function M.clear(p,selfRadius,other,extra)
    if type(p)~="table" or not finite(p.x) or not finite(p.z)
        or not finite(selfRadius) or type(other)~="table"
        then return false end
    local margin=extra or EXTRA_M
    for i=1,#other do
        local occupant=other[i]
        local reach=selfRadius+occupant.radius+margin
        local dx,dz=p.x-occupant.x,p.z-occupant.z
        if dx*dx+dz*dz<reach*reach then return false end
    end
    return true
end
-- A complete local route is checked against FRESH physical occupancy
-- before acquiring native steering authority, not only at plan time.
function M.routeClear(vehicle,route)
    local scene,why=M.snapshot(vehicle,route.poly)
    if scene==nil then return false,why end
    local own=M.footRadius(vehicle)
    if own==nil then return false,"PHYSICAL_OCCUPANCY_OWN_FOOTPRINT_UNAVAILABLE" end
    for i=1,#route.legs do
        if not M.clear(route.legs[i].point,own,scene) then
            return false,"PHYSICAL_OCCUPANCY_ROUTE_CONFLICT"
        end
    end
    return true
end
function M.nextClear(vehicle,route,index)
    local scene,why=M.snapshot(vehicle,route.poly)
    if scene==nil then return false,why end
    local own=M.footRadius(vehicle)
    if own==nil then return false,"PHYSICAL_OCCUPANCY_OWN_FOOTPRINT_UNAVAILABLE" end
    local target=route.legs[index]
    if target~=nil and not M.clear(target.point,own,scene) then
        return false,"PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED"
    end
    return true
end
return M
