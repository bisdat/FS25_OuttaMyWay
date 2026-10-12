-- Selects a bounded completion-settlement prototype route for a real
-- assembly. The first GIANTS Reality fixture is Mindenerwald Field 77/edge 9.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSettlementRoute={}
local Route=OuttaMyWay.CompletionSettlementRoute
local G=OuttaMyWay.FarmEdgeGeometry
local Assessment=OuttaMyWay.SettlementCorridorAssessment
local Runout=OuttaMyWay.SettlementStraightRunout
local FIXTURE={ax=228.15,az=-243.04,bx=-0.06,bz=-207.44,length=230.97}
local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end
local function near(a,b) return finite(a) and math.abs(a-b)<=3 end
local function field77()
    local manager=g_fieldManager
    if type(manager)~="table" or type(manager.fields)~="table" then
        return nil,nil,nil,"FIELD_REGISTRY_UNAVAILABLE"
    end
    local field
    if type(manager.getFieldById)=="function" then
        local ok,result=pcall(manager.getFieldById,manager,77)
        if ok then field=result end
    end
    if field==nil then
        for id,entry in pairs(manager.fields) do
            if type(entry)=="table" and (id==77 or entry.fieldId==77) then
                field=entry
                break
            end
        end
    end
    if type(field)~="table" then return nil,nil,nil,"FIELD_77_UNAVAILABLE" end
    local poly=G.polygonFor(field)
    local edge=poly and G.edges(poly)[9] or nil
    if edge==nil or edge.index~=9
        or not near(edge.ax,FIXTURE.ax) or not near(edge.az,FIXTURE.az)
        or not near(edge.bx,FIXTURE.bx) or not near(edge.bz,FIXTURE.bz)
        or not near(edge.length,FIXTURE.length) then
        return nil,nil,nil,"FIELD_77_EDGE_9_MISMATCH"
    end
    local neighbors,scanned={},0
    for _,other in pairs(manager.fields) do
        scanned=scanned+1
        if scanned>512 then return nil,nil,nil,"FIELD_CATALOGUE_TRUNCATED" end
        if other~=field and type(other)=="table" then
            local p=G.polygonFor(other)
            if p~=nil then neighbors[#neighbors+1]={polygon=p} end
        end
    end
    return poly,edge,neighbors,nil
end
local function pose(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function"
        or type(localDirectionToWorld)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    local heading,fx,_,fz=pcall(localDirectionToWorld,
        vehicle.rootNode,0,0,1)
    if not ok or not heading or not finite(x) or not finite(z)
        or not finite(fx) or not finite(fz) then return nil end
    local length=math.sqrt(fx*fx+fz*fz)
    if length<0.001 then return nil end
    return {x=x,z=z,fx=fx/length,fz=fz/length}
end
local function edgePoint(edge,nx,nz,station,depth)
    return {x=edge.ax+edge.dx*station/edge.length+nx*depth,
        z=edge.az+edge.dz*station/edge.length+nz*depth}
end
-- A selected nominal sweep is treated as driveable ONLY for this explicit
-- prototype. An actual approach, crossing and run-out will test that premise.
function Route.plan(vehicle)
    local poly,edge,neighbors,errorReason=field77()
    if poly==nil then return nil,errorReason end
    local current=pose(vehicle)
    if current==nil then return nil,"ROOT_POSE_UNAVAILABLE" end
    if not G.inside(poly,current.x,current.z) then
        return nil,"COMPLETED_ROOT_NOT_IN_FIXTURE_FIELD"
    end
    local foot,reason=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return nil,reason end
    local static=Assessment.assess(foot,current.fx,current.fz,
        poly,edge,neighbors,false)
    local swept=Runout.assess(static,poly,neighbors,false)
    local best
    for i=1,#swept.results do
        local sample=swept.results[i]
        local seed=static.sweepSeeds[i]
        if seed~=nil and sample.status=="POLYGON_ONLY_CONTINUOUS_GEOMETRY"
            and sample.lowerBoundM>=60 then
            local edgeX=edge.ax+edge.dx*seed.stationM/edge.length
            local edgeZ=edge.az+edge.dz*seed.stationM/edge.length
            local nx,nz=G.outwardAt(poly,edge,edgeX,edgeZ)
            if nx~=nil then
                local stageS=seed.stationM-seed.direction*16
                local crossS=seed.stationM+seed.direction*8
                local stopS=seed.stationM+
                    seed.direction*(sample.lowerBoundM-3)
                if stageS>=2 and stageS<=edge.length-2
                    and stopS>=2 and stopS<=edge.length-2 then
                    local stage=edgePoint(edge,nx,nz,stageS,-6)
                    local crossing=edgePoint(edge,nx,nz,crossS,seed.depthM)
                    local stop=edgePoint(edge,nx,nz,stopS,seed.depthM)
                    if G.inside(poly,stage.x,stage.z)
                        and not G.inside(poly,crossing.x,crossing.z)
                        and not G.inside(poly,stop.x,stop.z) then
                        local choice={field=77,edge=9,poly=poly,neighbors=neighbors,
                            memberCount=foot.memberCount,
                            stationM=seed.stationM,
                            direction=seed.direction,depthM=seed.depthM,
                            lengthM=sample.lowerBoundM,
                            legs={{name="INFIELD_APPROACH",point=stage},
                                {name="SHALLOW_CROSSING",point=crossing},
                                {name="FORWARD_RUNOUT",point=stop}}}
                        if best==nil or choice.lengthM>best.lengthM then
                            best=choice
                        end
                    end
                end
            end
        end
    end
    return best,best==nil and "NO_SETTLEMENT_ROUTE_IN_FIXTURE" or nil
end
-- Terminal success refers to every currently observed member corner.
-- It is not inferred from the root reaching the final steering point.
function Route.verifyTerminal(vehicle,route)
    local foot,reason=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return false,reason end
    if foot.memberCount~=route.memberCount then
        return false,"ASSEMBLY_MEMBERSHIP_CHANGED"
    end
    if G.inside(route.poly,foot.rootX,foot.rootZ) then
        return false,"ROOT_STILL_IN_SOURCE_FIELD"
    end
    local order={1,2,4,3}
    for member=1,foot.memberCount do
        local rect={}
        for j=1,4 do
            local p=foot.corners[(member-1)*4+order[j]]
            rect[j]={x=foot.rootX+p.x,z=foot.rootZ+p.z}
        end
        local intersects=Assessment.shapeIntersectsPolygon(rect,route.poly)
        if intersects~=false then
            return false,"ASSEMBLY_MEMBER_INTERSECTS_SOURCE_FIELD"
        end
        for n=1,#route.neighbors do
            local other=Assessment.shapeIntersectsPolygon(rect,
                route.neighbors[n].polygon)
            if other~=false then
                return false,"ASSEMBLY_MEMBER_INTERSECTS_NEIGHBOR_FIELD"
            end
        end
    end
    return true,"WHOLE_NOMINAL_ASSEMBLY_OUTSIDE_REGISTERED_FIELDS"
end
return Route
