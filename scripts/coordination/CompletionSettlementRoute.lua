-- TEST pose-conditioned terminal region + bounded nominal entry candidates.
-- Specification Jurisdiction: COMPLETION_SETTLEMENT_CONTROL
-- Field 77 edge 9 is the only experimental physical movement fixture.
-- All planned swept footprints are NOMINAL rigid snapshots, not GIANTS physics.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSettlementRoute={}
local Route=OuttaMyWay.CompletionSettlementRoute
local G=OuttaMyWay.FarmEdgeGeometry
local A=OuttaMyWay.SettlementCorridorAssessment
local FIXTURE={ax=228.15,az=-243.04,bx=-0.06,bz=-207.44,length=230.97}
local RAD=math.pi/180
local MAX_POINTS=55
local STEP_M=5
local STOP_DEPTH_MAX_M=12
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function near(a,b) return finite(a) and math.abs(a-b)<=3 end
local function dist(a,b)
    return math.sqrt((a.x-b.x)^2+(a.z-b.z)^2)
end
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
        local count=0
        for id,entry in pairs(manager.fields) do
            count=count+1
            if count>512 then return nil,nil,nil,"FIELD_CATALOGUE_TRUNCATED" end
            if type(entry)=="table" and (id==77 or entry.fieldId==77) then
                field=entry;break
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
            if p==nil then return nil,nil,nil,"NEIGHBOR_POLYGON_UNAVAILABLE" end
            neighbors[#neighbors+1]={polygon=p}
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
    local magnitude=math.sqrt(fx*fx+fz*fz)
    if magnitude<0.001 then return nil end
    return {x=x,z=z,fx=fx/magnitude,fz=fz/magnitude}
end
local function edgeFrame(edge,poly)
    local mx,mz=(edge.ax+edge.bx)*0.5,(edge.az+edge.bz)*0.5
    local nx,nz=G.outwardAt(poly,edge,mx,mz)
    if nx==nil then return nil end
    return {ax=edge.ax,az=edge.az,ux=edge.dx/edge.length,
        uz=edge.dz/edge.length,nx=nx,nz=nz,length=edge.length}
end
local function coordinates(p,f)
    local x,z=p.x-f.ax,p.z-f.az
    return x*f.ux+z*f.uz,x*f.nx+z*f.nz
end
local function rotatedFoot(foot,initial,p)
    local dot=initial.fx*p.fx+initial.fz*p.fz
    local cross=initial.fx*p.fz-initial.fz*p.fx
    local boxes={}
    local order={1,2,4,3}
    for m=1,foot.memberCount do
        local rect={}
        for c=1,4 do
            local v=foot.corners[(m-1)*4+order[c]]
            rect[c]={x=p.x+v.x*dot-v.z*cross,
                z=p.z+v.x*cross+v.z*dot}
        end
        boxes[m]=rect
    end
    return boxes
end
local function noNeighborHit(boxes,neighbors)
    for m=1,#boxes do
        for i=1,#neighbors do
            if A.shapeIntersectsPolygon(boxes[m],
                neighbors[i].polygon)~=false then
                return false
            end
        end
    end
    return true
end
-- Candidate points may be in the completed source field during approach.
-- Once outside they must be within the nominated edge's bounded exterior
-- band, never beyond another end/corner of the field.
local function approachAllowed(p,foot,initial,poly,neighbors,frame,reverse)
    local station,depth=coordinates(p,frame)
    if station<2 or station>frame.length-2 then return false end
    local boxes=rotatedFoot(foot,initial,p)
    if not noNeighborHit(boxes,neighbors) then return false end
    if reverse then
        if not G.inside(poly,p.x,p.z) then return false end
        for m=1,#boxes do
            for i=1,4 do
                if not G.inside(poly,boxes[m][i].x,boxes[m][i].z) then
                    return false
                end
            end
        end
    elseif not G.inside(poly,p.x,p.z) then
        if depth<0 or depth>STOP_DEPTH_MAX_M then return false end
    end
    return true
end
local function terminalAllowed(p,foot,initial,poly,neighbors,frame)
    local station,depth=coordinates(p,frame)
    if station<3 or station>frame.length-3
        or depth<0 or depth>STOP_DEPTH_MAX_M then return false end
    local parallel=math.abs(p.fx*frame.ux+p.fz*frame.uz)
    if parallel<math.cos(15*RAD) then return false end
    local boxes=rotatedFoot(foot,initial,p)
    if not noNeighborHit(boxes,neighbors) then return false end
    if G.inside(poly,p.x,p.z) then return false end
    for m=1,#boxes do
        if A.shapeIntersectsPolygon(boxes[m],poly)~=false then
            return false
        end
        for i=1,4 do
            local s,d=coordinates(boxes[m][i],frame)
            if s<1 or s>frame.length-1 or d<0.15
                or d>STOP_DEPTH_MAX_M then return false end
        end
    end
    return true
end
local function advance(p,length)
    return {x=p.x+p.fx*length,z=p.z+p.fz*length,fx=p.fx,fz=p.fz}
end
local function turnStep(p,radius,angle)
    local h=angle*0.5
    local midX=p.fx*math.cos(h)-p.fz*math.sin(h)
    local midZ=p.fx*math.sin(h)+p.fz*math.cos(h)
    local length=radius*math.abs(angle)
    return {x=p.x+midX*length,z=p.z+midZ*length,
        fx=p.fx*math.cos(angle)-p.fz*math.sin(angle),
        fz=p.fx*math.sin(angle)+p.fz*math.cos(angle)}
end
local function newTrack(current)
    return {points={},pose={x=current.x,z=current.z,
        fx=current.fx,fz=current.fz},travelM=0,reverseM=0}
end
local function addPoint(track,point,forward,foot,initial,poly,neighbors,frame)
    if #track.points>=MAX_POINTS
        or not approachAllowed(point,foot,initial,poly,
            neighbors,frame,not forward) then return false end
    local distance=dist(track.pose,point)
    if distance<0.5 then return true end
    track.travelM=track.travelM+distance
    if not forward then track.reverseM=track.reverseM+distance end
    track.points[#track.points+1]={name=forward and "FORWARD_GUIDANCE"
        or "REVERSE_POSITIONING",point={x=point.x,z=point.z},
        moveForwards=forward}
    track.pose=point
    return true
end
local function move(track,length,forward,foot,initial,poly,neighbors,frame)
    local steps=math.ceil(math.abs(length)/STEP_M)
    if steps<1 then return true end
    local step=length/steps
    for i=1,steps do
        local p=advance(track.pose,step)
        if not addPoint(track,p,forward,foot,initial,
            poly,neighbors,frame) then return false end
    end
    return true
end
local function arc(track,radius,angle,foot,initial,poly,neighbors,frame)
    local steps=math.ceil(math.abs(radius*angle)/STEP_M)
    if steps<1 then return true end
    local each=angle/steps
    for i=1,steps do
        local p=turnStep(track.pose,radius,each)
        if not addPoint(track,p,true,foot,initial,
            poly,neighbors,frame) then return false end
    end
    return true
end
local function angleBetween(ax,az,bx,bz)
    return math.atan2 and math.atan2(ax*bz-az*bx,ax*bx+az*bz)
        or math.atan(ax*bz-az*bx,ax*bx+az*bz)
end
local function tryTrack(current,foot,poly,neighbors,frame,
    direction,reverseLength,radius,alpha,jTurn)
    local track=newTrack(current)
    local tx,tz=frame.ux*direction,frame.uz*direction
    if reverseLength>0 then
        if not move(track,-reverseLength,false,foot,current,
            poly,neighbors,frame) then return nil end
    end
    local delta=angleBetween(track.pose.fx,track.pose.fz,tx,tz)
    if jTurn then
        -- Real heading acquisition, inside the field, before the S crossing.
        -- A forward J loop is a fallback when heading is not edge-aligned.
        if math.abs(delta)<20*RAD then return nil end
        local turn=delta
        if not arc(track,radius,turn,foot,current,
            poly,neighbors,frame) then return nil end
    elseif math.abs(delta)>18*RAD then
        return nil
    end
    -- Two opposite short arcs: acquire exterior offset while returning to
    -- the final edge tangent. This is a testable kinematic hypothesis, not
    -- proof that GIANTS steering or articulated implements will track it.
    local side=track.pose.fx*frame.nz-track.pose.fz*frame.nx
    local sense=side>=0 and 1 or -1
    local residual=angleBetween(track.pose.fx,track.pose.fz,tx,tz)
    local first=sense*alpha
    local second=residual-first
    if first*second>=0 or math.abs(second)>95*RAD then return nil end
    if not arc(track,radius,first,foot,current,
        poly,neighbors,frame) then return nil end
    if not arc(track,radius,second,foot,current,
        poly,neighbors,frame) then return nil end
    -- Continue edge-parallel only until the FIRST nominal full-member
    -- exterior pose. The terminal is a region, not the edge endpoint.
    local extra=0
    while extra<=35 do
        if terminalAllowed(track.pose,foot,current,
            poly,neighbors,frame) then
            return track
        end
        if not move(track,STEP_M,true,foot,current,
            poly,neighbors,frame) then return nil end
        extra=extra+STEP_M
    end
    return nil
end
function Route.plan(vehicle)
    local poly,edge,neighbors,reason=field77()
    if poly==nil then return nil,reason end
    local current=pose(vehicle)
    if current==nil then return nil,"ROOT_POSE_UNAVAILABLE" end
    if not G.inside(poly,current.x,current.z) then
        return nil,"COMPLETED_ROOT_NOT_IN_FIXTURE_FIELD"
    end
    local foot,why=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return nil,why end
    local frame=edgeFrame(edge,poly)
    if frame==nil then return nil,"EDGE_OUTWARD_UNAVAILABLE" end
    local best
    -- A finite pose-sensitive candidate set, tried for both edge directions.
    -- Reverse-first is preferred when total safe travel is comparable.
    local reverses={12,18,24,0,30}
    local radii={12,18,24}
    local angles={35*RAD,45*RAD,55*RAD,65*RAD,75*RAD}
    for direction=-1,1,2 do
        for j=1,#reverses do
            for k=1,#radii do
                for a=1,#angles do
                    for method=1,2 do
                        local track=tryTrack(current,foot,poly,neighbors,frame,
                            direction,reverses[j],radii[k],angles[a],
                            method==2)
                        if track~=nil then
                            local score=track.travelM+
                                (method==2 and 5 or 0)+
                                (track.reverseM>0 and 0 or 2)
                            if best==nil or score<best.score then
                                best={score=score,track=track,
                                    direction=direction,radius=radii[k],
                                    reverseM=reverses[j],
                                    method=method==2 and "FORWARD_J"
                                        or "REVERSE_FORWARD"}
                            end
                        end
                    end
                end
            end
        end
    end
    if best==nil then return nil,"NO_POSE_REACHABLE_PARKING_REGION" end
    return {field=77,edge=9,poly=poly,neighbors=neighbors,
        memberCount=foot.memberCount,frame=frame,
        method=best.method,direction=best.direction,
        reverseM=best.track.reverseM,guideRadiusM=best.radius,
        estimatedTravelM=best.track.travelM,
        legs=best.track.points},nil
end
function Route.guard(vehicle,route)
    local p=pose(vehicle)
    if p==nil then return false,"SETTLEMENT_POSE_UNAVAILABLE" end
    local s,d=coordinates(p,route.frame)
    if s<0 or s>route.frame.length
        or (not G.inside(route.poly,p.x,p.z)
            and (d<0 or d>STOP_DEPTH_MAX_M)) then
        return false,"SETTLEMENT_ENTRY_OUTSIDE_EDGE_ENVELOPE"
    end
    return true
end
function Route.verifyTerminal(vehicle,route)
    local foot,reason=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return false,reason end
    if foot.memberCount~=route.memberCount then
        return false,"ASSEMBLY_MEMBERSHIP_CHANGED"
    end
    local p=pose(vehicle)
    if p==nil then return false,"ROOT_POSE_UNAVAILABLE" end
    if not terminalAllowed(p,foot,p,route.poly,
        route.neighbors,route.frame) then
        return false,"WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION"
    end
    return true,"WHOLE_NOMINAL_ASSEMBLY_IN_INTERFIELD_PARKING_REGION"
end
return Route
