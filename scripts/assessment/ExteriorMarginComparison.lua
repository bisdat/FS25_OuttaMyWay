-- Read-only, bounded comparison of nominated exterior edge samples.
-- Specification Jurisdictions: `SETTLEMENT_CORRIDOR_ASSESSMENT`
-- Polygon-only fit and point terrain heights are NOT physical clearance.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.ExteriorMarginComparison={}
local M=OuttaMyWay.ExteriorMarginComparison
local Parking=OuttaMyWay.CompletionParkingGeometry
local Polygon=OuttaMyWay.SettlementCorridorAssessment
local STATIONS={0.25,0.50,0.75}
local DEPTHS={2,6,12}
local DIRECTIONS={1,-1}
local CORNERS={1,2,4,3}
local MAX_EDGES=32
local MAX_MEMBERS=16
local function finite(v)
    return type(v)=="number" and v==v
        and v~=math.huge and v~=-math.huge
end
local function rectAt(foot,fx,fz,frame,station,depth,direction,member)
    local tx,tz=frame.ux*direction,frame.uz*direction
    local dot,cross=fx*tx+fz*tz,fx*tz-fz*tx
    local rootX=frame.ax+frame.ux*station+frame.nx*depth
    local rootZ=frame.az+frame.uz*station+frame.nz*depth
    local rect={}
    for c=1,4 do
        local v=foot.corners[(member-1)*4+CORNERS[c]]
        if v==nil or not finite(v.x) or not finite(v.z) then
            return nil
        end
        rect[c]={x=rootX+v.x*dot-v.z*cross,
            z=rootZ+v.x*cross+v.z*dot}
    end
    return rect
end
local function intersectsNeighbor(rect,neighbor)
    local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge
    for i=1,4 do
        local p=rect[i]
        minX=math.min(minX,p.x);maxX=math.max(maxX,p.x)
        minZ=math.min(minZ,p.z);maxZ=math.max(maxZ,p.z)
    end
    if maxX<neighbor.minX or minX>neighbor.maxX
        or maxZ<neighbor.minZ or minZ>neighbor.maxZ then
        return false
    end
    return Polygon.shapeIntersectsPolygon(rect,neighbor)
end
local function nominalFit(session,frame,station,depth,direction)
    for member=1,session.foot.memberCount do
        local rect=rectAt(session.foot,session.fx,session.fz,frame,
            station,depth,direction,member)
        if rect==nil then return nil end
        -- This edge-aligned representation is a stationary hypothesis,
        -- not a swept approach or a prediction of articulation.
        for i=1,4 do
            local p=rect[i]
            local dx,dz=p.x-frame.ax,p.z-frame.az
            local along=dx*frame.ux+dz*frame.uz
            local outward=dx*frame.nx+dz*frame.nz
            if along<1 or along>frame.length-1
                or outward<0.15 or outward>12 then
                return false
            end
        end
        local inSource=Polygon.shapeIntersectsPolygon(rect,session.poly)
        if inSource==nil then return nil end
        if inSource then return false end
        for i=1,#session.neighbors do
            local hit=intersectsNeighbor(rect,session.neighbors[i].polygon)
            if hit==nil then return nil end
            if hit then return false end
        end
    end
    return true
end
local function height(frame,station,depth)
    local mission=g_currentMission
    local terrain=mission and mission.terrainRootNode
    if terrain==nil or type(getTerrainHeightAtWorldPos)~="function" then
        return nil
    end
    local x=frame.ax+frame.ux*station+frame.nx*depth
    local z=frame.az+frame.uz*station+frame.nz*depth
    local ok,value=pcall(getTerrainHeightAtWorldPos,terrain,x,0,z)
    if ok and finite(value) then return value end
    return nil
end
function M.beginComparison(vehicle,sourceField)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(localDirectionToWorld)~="function" then
        return nil,"ASSEMBLY_HEADING_UNAVAILABLE"
    end
    local context,why=Parking.enumerate(sourceField,vehicle)
    if context==nil then return nil,why end
    local ok,fx,_,fz=pcall(localDirectionToWorld,
        vehicle.rootNode,0,0,1)
    if not ok or not finite(fx) or not finite(fz) then
        return nil,"ASSEMBLY_HEADING_UNAVAILABLE"
    end
    local magnitude=math.sqrt(fx*fx+fz*fz)
    if magnitude<0.001 then return nil,"ASSEMBLY_HEADING_DEGENERATE" end
    local foot,footWhy=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if type(foot)~="table" or type(foot.corners)~="table"
        or not finite(foot.memberCount) or foot.memberCount<1
        or foot.memberCount>MAX_MEMBERS
        or #foot.corners~=foot.memberCount*4 then
        return nil,footWhy or "ASSEMBLY_FOOTPRINT_UNAVAILABLE"
    end
    return {fieldId=context.fieldId,rootNode=vehicle.rootNode,
        nearestEdge=context.frames[1].index,
        frames=context.frames,poly=context.poly,
        neighbors=context.neighbors,foot=foot,
        fx=fx/magnitude,fz=fz/magnitude,
        edgeIndex=0,rows={},
        edgeLimit=math.min(#context.frames,MAX_EDGES),
        truncated=#context.frames>MAX_EDGES},nil
end
function M.advanceComparison(session)
    if type(session)~="table" or session.finished then
        return "FAILED",nil,"COMPARISON_SESSION_INVALID"
    end
    session.edgeIndex=session.edgeIndex+1
    local frame=session.frames[session.edgeIndex]
    if session.edgeIndex>session.edgeLimit or frame==nil then
        session.finished=true
        return "DONE",session
    end
    local row={edge=frame.index,length=frame.length,
        rootDistance=frame.distance,
        tested=0,nominalFits=0,nominalUnknown=0,
        shallowestFit=nil,terrainDelta=nil}
    for _,fraction in ipairs(STATIONS) do
        local station=frame.length*fraction
        for _,depth in ipairs(DEPTHS) do
            for _,direction in ipairs(DIRECTIONS) do
                row.tested=row.tested+1
                local verdict=nominalFit(session,frame,station,depth,direction)
                if verdict==true then
                    row.nominalFits=row.nominalFits+1
                    row.shallowestFit=math.min(row.shallowestFit or depth,depth)
                elseif verdict==nil then
                    row.nominalUnknown=row.nominalUnknown+1
                end
            end
        end
    end
    local inner=height(frame,frame.length*0.5,2)
    local outer=height(frame,frame.length*0.5,12)
    if inner~=nil and outer~=nil then
        row.terrainDelta=outer-inner
    end
    session.rows[#session.rows+1]=row
    if session.edgeIndex>=session.edgeLimit then
        session.finished=true
        return "DONE",session
    end
    return "PENDING"
end
function M.summarize(session)
    local lines={}
    for _,row in ipairs(session.rows) do
        lines[#lines+1]=string.format(
            "%d:len%.1f:near%.1f:nominal%d/%d:unknown%d:shallow%s:terrain%s",
            row.edge,row.length,row.rootDistance,row.nominalFits,row.tested,
            row.nominalUnknown,
            row.shallowestFit and tostring(row.shallowestFit) or "none",
            row.terrainDelta and string.format("%.2f",row.terrainDelta)
                or "unknown")
    end
    return table.concat(lines,";")
end
return M
