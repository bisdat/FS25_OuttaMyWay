-- TEST pose-conditioned terminal region + bounded nominal entry candidates.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- Field 77 edge 9 is the only experimental physical movement fixture.
-- All planned swept footprints are NOMINAL rigid snapshots, not GIANTS physics.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSettlementRoute={}
local Route=OuttaMyWay.CompletionSettlementRoute
local G=OuttaMyWay.FarmEdgeGeometry
local A=OuttaMyWay.SettlementCorridorAssessment
local Occupancy=OuttaMyWay.SettlementPhysicalOccupancy
local FIXTURE={ax=228.15,az=-243.04,bx=-0.06,bz=-207.44,length=230.97}
local RAD=math.pi/180
local MAX_POINTS=55
local STEP_M=5
local STOP_DEPTH_MAX_M=12
-- The first nominal clear pose is not sufficient when cruise is braking:
-- reserve an additional tangent position for physical stopping overshoot.
local STOPPING_RESERVE_M=5
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
local function rotatedFootForEntry(foot,actual,entry)
    if entry==nil then return foot end
    local dot=actual.fx*entry.fx+actual.fz*entry.fz
    local cross=actual.fx*entry.fz-actual.fz*entry.fx
    local corners={}
    for i=1,#foot.corners do
        local p=foot.corners[i]
        corners[i]={x=p.x*dot-p.z*cross,z=p.x*cross+p.z*dot}
    end
    return {memberCount=foot.memberCount,corners=corners}
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
-- Each expensive geometry check has a chargeable, yieldable boundary.
-- Source Field77 polygons have world-space AABBs, so distant fields can be
-- rejected before rectangle/polygon intersection.
local function noNeighborHit(boxes,neighbors,checkpoint)
    for m=1,#boxes do
        local rect=boxes[m]
        local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge
        for j=1,4 do
            local p=rect[j]
            minX,maxX=math.min(minX,p.x),math.max(maxX,p.x)
            minZ,maxZ=math.min(minZ,p.z),math.max(maxZ,p.z)
        end
        for i=1,#neighbors do
            if checkpoint then checkpoint(1) end
            local p=neighbors[i].polygon
            if minX<=p.maxX and maxX>=p.minX
                and minZ<=p.maxZ and maxZ>=p.minZ then
                if checkpoint then checkpoint(24) end
                if A.shapeIntersectsPolygon(rect,p)~=false then
                    return false
                end
            end
        end
    end
    return true
end
-- Candidate points may be in the completed source field during approach.
-- Once outside they must be within the nominated edge's bounded exterior
-- band, never beyond another end/corner of the field.
local function approachAllowed(p,foot,initial,poly,neighbors,frame,reverse,checkpoint,occupants,ownRadius)
    local station,depth=coordinates(p,frame)
    if occupants~=nil and not Occupancy.clear(p,ownRadius,occupants)
        then return false end
    if station<2 or station>frame.length-2 then return false end
    local boxes=rotatedFoot(foot,initial,p)
    if not noNeighborHit(boxes,neighbors,checkpoint) then return false end
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
local function terminalAllowed(p,foot,initial,poly,neighbors,frame,checkpoint,occupants,ownRadius)
    local station,depth=coordinates(p,frame)
    if occupants~=nil and not Occupancy.clear(p,ownRadius,occupants)
        then return false end
    if station<3 or station>frame.length-3
        or depth<0 or depth>STOP_DEPTH_MAX_M then return false end
    local parallel=math.abs(p.fx*frame.ux+p.fz*frame.uz)
    if parallel<math.cos(15*RAD) then return false end
    local boxes=rotatedFoot(foot,initial,p)
    if not noNeighborHit(boxes,neighbors,checkpoint) then return false end
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
local function addPoint(track,point,forward,foot,initial,poly,neighbors,frame,checkpoint,occupants,ownRadius)
    if #track.points>=MAX_POINTS
        or not approachAllowed(point,foot,initial,poly,
            neighbors,frame,not forward,checkpoint,occupants,ownRadius) then return false end
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
local function move(track,length,forward,foot,initial,poly,neighbors,frame,checkpoint,occupants,ownRadius)
    local steps=math.ceil(math.abs(length)/STEP_M)
    if steps<1 then return true end
    local step=length/steps
    for i=1,steps do
        local p=advance(track.pose,step)
        if not addPoint(track,p,forward,foot,initial,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then return false end
    end
    return true
end
local function arc(track,radius,angle,foot,initial,poly,neighbors,frame,checkpoint,occupants,ownRadius)
    local steps=math.ceil(math.abs(radius*angle)/STEP_M)
    if steps<1 then return true end
    local each=angle/steps
    for i=1,steps do
        local p=turnStep(track.pose,radius,each)
        if not addPoint(track,p,true,foot,initial,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then return false end
    end
    return true
end
local function angleBetween(ax,az,bx,bz)
    return math.atan2 and math.atan2(ax*bz-az*bx,ax*bx+az*bz)
        or math.atan(ax*bz-az*bx,ax*bx+az*bz)
end
local function tryTrack(current,foot,poly,neighbors,frame,
    direction,reverseLength,radius,alpha,jTurn,checkpoint,occupants,ownRadius)
    local track=newTrack(current)
    local tx,tz=frame.ux*direction,frame.uz*direction
    if reverseLength>0 then
        if not move(track,-reverseLength,false,foot,current,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then return nil end
    end
    local delta=angleBetween(track.pose.fx,track.pose.fz,tx,tz)
    if jTurn then
        -- Real heading acquisition, inside the field, before the S crossing.
        -- A forward J loop is a fallback when heading is not edge-aligned.
        if math.abs(delta)<20*RAD then return nil end
        local turn=delta
        if not arc(track,radius,turn,foot,current,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then return nil end
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
        poly,neighbors,frame,checkpoint,occupants,ownRadius) then return nil end
    if not arc(track,radius,second,foot,current,
        poly,neighbors,frame,checkpoint,occupants,ownRadius) then return nil end
    -- Continue edge-parallel only until the FIRST nominal full-member
    -- exterior pose. The terminal is a region, not the edge endpoint.
    local extra=0
    while extra<=35 do
        if terminalAllowed(track.pose,foot,current,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then
            local beyond=advance(track.pose,STOPPING_RESERVE_M)
            if terminalAllowed(beyond,foot,current,
                poly,neighbors,frame,checkpoint,occupants,ownRadius) then return track end
            -- Without braking reserve, keep looking along the same
            -- tangent. A later station might still offer a safe stop.
        end
        if not move(track,STEP_M,true,foot,current,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then return nil end
        extra=extra+STEP_M
    end
    return nil
end
function Route.plan(vehicle,checkpoint)
    local poly,edge,neighbors,reason=field77()
    if poly==nil then return nil,reason end
    local current=pose(vehicle)
    if current==nil then return nil,"ROOT_POSE_UNAVAILABLE" end
    if not G.inside(poly,current.x,current.z) then
        return nil,"COMPLETED_ROOT_NOT_IN_FIXTURE_FIELD"
    end
    local foot,why=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return nil,why end
    -- This bounded experiment does not infer articulation stability from
    -- nominal rigid rectangles. Multi-member reversing remains unvalidated.
    if foot.memberCount~=1 then
        return nil,"ARTICULATED_ENTRY_REALITY_UNVALIDATED"
    end
    local occupants,occupiedWhy=Occupancy.snapshot(vehicle,poly)
    if occupants==nil then return nil,occupiedWhy end
    local ownRadius=Occupancy.footRadius(vehicle)
    if ownRadius==nil then
        return nil,"PHYSICAL_OCCUPANCY_OWN_FOOTPRINT_UNAVAILABLE"
    end
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
                        if checkpoint then checkpoint(1) end
                        local track=tryTrack(current,foot,poly,neighbors,frame,
                            direction,reverses[j],radii[k],angles[a],
                            method==2,checkpoint,occupants,ownRadius)
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
-- Explicit Incremental Planner: all continuation state is ordinary Lua data.
-- GIANTS exposes no coroutine capability in TEST 0.5.5.10. Each UPDATE may
-- inspect only a fixed weighted number of geometry checks, including partial
-- neighbour scans within one short guidance point.
local REVERSES={12,18,24,0,30}
local RADII={12,18,24}
local ANGLES={35*RAD,45*RAD,55*RAD,65*RAD,75*RAD}
local function charge(session,cost)
    if session.remaining<cost then return false end
    session.remaining=session.remaining-cost
    session.spent=session.spent+cost
    return true
end
local function finishCandidate(s)
    local c=s.candidate
    if c~=nil and c.accepted then
        local track=c.track
        local score=track.travelM+(c.jTurn and 5 or 0)
            +(track.reverseM>0 and 0 or 2)
        if s.best==nil or score<s.best.score then
            s.best={score=score,track=track,
                direction=c.direction,radius=c.radius,
                reverseM=c.reverseLength,
                method=c.jTurn and "FORWARD_J" or "REVERSE_FORWARD"}
        end
    end
    s.candidate=nil
    s.method=s.method+1
    if s.method>2 then s.method=1;s.angle=s.angle+1 end
    if s.angle>#ANGLES then s.angle=1;s.radius=s.radius+1 end
    if s.radius>#RADII then s.radius=1;s.reverse=s.reverse+1 end
    if s.reverse>#REVERSES then
        s.reverse=1;s.direction=s.direction+2
    end
    if s.direction>1 then s.phase="FINISH" end
end
local function segment(c,kind,length,forward,nextStage)
    local steps
    if kind=="MOVE" then
        steps=math.ceil(math.abs(length)/STEP_M)
    else
        steps=math.ceil(math.abs(c.radius*length)/STEP_M)
    end
    if steps<1 then
        c.stage=nextStage
        return
    end
    c.segment={kind=kind,step=length/steps,steps=steps,
        index=0,forward=forward,nextStage=nextStage}
    c.stage="SEGMENT"
end
local function createCandidate(s)
    local c={track=newTrack(s.current),direction=s.direction,
        reverseLength=REVERSES[s.reverse],
        radius=RADII[s.radius],alpha=ANGLES[s.angle],
        jTurn=s.method==2,stage="REVERSE_INIT",extra=0}
    s.candidate=c
end
local function makeCheck(s,p,kind,reverse)
    local c=s.candidate
    local station,depth=coordinates(p,s.frame)
    if kind~="APPROACH" and s.options~=nil
        and (station<s.options.stationMin
            or station>s.options.stationMax) then
        c.stage="RUNOUT_INIT"
        return
    end
    if kind=="APPROACH" then
        if #c.track.points>=MAX_POINTS
            or station<2 or station>s.frame.length-2 then
            c.stage="REJECT"
            return
        end
    else
        if station<3 or station>s.frame.length-3
            or depth<0 or depth>STOP_DEPTH_MAX_M
            or math.abs(p.fx*s.frame.ux+p.fz*s.frame.uz)
                <math.cos(15*RAD) then
            c.stage=kind=="TERMINAL" and "RUNOUT_INIT" or "RUNOUT_INIT"
            return
        end
    end
    if not Occupancy.clear(p,s.ownRadius,s.occupants) then
        c.stage=kind=="APPROACH" and "REJECT" or "RUNOUT_INIT"
        return
    end
    local boxes=rotatedFoot(s.foot,s.current,p)
    local check={point=p,kind=kind,reverse=reverse,
        station=station,depth=depth,boxes=boxes,
        member=1,neighbor=1,phase="NEIGHBOR"}
    c.check=check
    c.stage="CHECK"
end
local function checkFinished(s,clear)
    local c=s.candidate
    local check=c.check
    c.check=nil
    if check.kind=="APPROACH" then
        if not clear then c.stage="REJECT";return end
        local track=c.track
        local distance=dist(track.pose,check.point)
        if distance>=0.5 then
            track.travelM=track.travelM+distance
            if not c.segment.forward then
                track.reverseM=track.reverseM+distance
            end
            track.points[#track.points+1]={
                name=c.segment.forward and "FORWARD_GUIDANCE"
                    or "REVERSE_POSITIONING",
                point={x=check.point.x,z=check.point.z},
                moveForwards=c.segment.forward}
            track.pose=check.point
        end
        c.segment.index=c.segment.index+1
        c.stage="SEGMENT"
    elseif check.kind=="TERMINAL" and clear then
        c.stage="RESERVE_INIT"
    elseif check.kind=="RESERVE" and clear then
        c.accepted=true
        c.stage="ACCEPT"
    else
        c.stage="RUNOUT_INIT"
    end
end
local function processCheck(s)
    local c=s.candidate
    local check=c.check
    if check.phase=="NEIGHBOR" then
        if check.member>#check.boxes then
            check.phase="SOURCE"
            return true
        end
        if check.neighbor>#s.neighbors then
            check.member=check.member+1
            check.neighbor=1
            return true
        end
        if not charge(s,1) then return false end
        local rect=check.boxes[check.member]
        local minX,maxX,minZ,maxZ=math.huge,-math.huge,math.huge,-math.huge
        for j=1,4 do
            local p=rect[j]
            minX=math.min(minX,p.x);maxX=math.max(maxX,p.x)
            minZ=math.min(minZ,p.z);maxZ=math.max(maxZ,p.z)
        end
        local p=s.neighbors[check.neighbor].polygon
        if minX<=p.maxX and maxX>=p.minX
            and minZ<=p.maxZ and maxZ>=p.minZ then
            check.phase="NEIGHBOR_EXACT"
        else
            check.neighbor=check.neighbor+1
        end
        return true
    elseif check.phase=="NEIGHBOR_EXACT" then
        if not charge(s,24) then return false end
        local rect=check.boxes[check.member]
        local poly=s.neighbors[check.neighbor].polygon
        if A.shapeIntersectsPolygon(rect,poly)~=false then
            checkFinished(s,false)
        else
            check.neighbor=check.neighbor+1
            check.phase="NEIGHBOR"
        end
        return true
    elseif check.phase=="SOURCE" then
        if not charge(s,1) then return false end
        if check.kind=="APPROACH" then
            if check.reverse then
                if not G.inside(s.poly,check.point.x,check.point.z) then
                    checkFinished(s,false)
                    return true
                end
                for m=1,#check.boxes do
                    for i=1,4 do
                        local corner=check.boxes[m][i]
                        if not G.inside(s.poly,corner.x,corner.z) then
                            checkFinished(s,false)
                            return true
                        end
                    end
                end
            elseif not G.inside(s.poly,check.point.x,check.point.z)
                and (check.depth<0 or check.depth>STOP_DEPTH_MAX_M) then
                checkFinished(s,false)
                return true
            end
            checkFinished(s,true)
            return true
        end
        if G.inside(s.poly,check.point.x,check.point.z) then
            checkFinished(s,false)
            return true
        end
        check.sourceMember=1
        check.phase="SOURCE_MEMBER"
        return true
    elseif check.phase=="SOURCE_MEMBER" then
        if check.sourceMember>#check.boxes then
            checkFinished(s,true)
            return true
        end
        if not charge(s,24) then return false end
        local box=check.boxes[check.sourceMember]
        if A.shapeIntersectsPolygon(box,s.poly)~=false then
            checkFinished(s,false)
            return true
        end
        for i=1,4 do
            local station,depth=coordinates(box[i],s.frame)
            if station<1 or station>s.frame.length-1
                or depth<0.15 or depth>STOP_DEPTH_MAX_M then
                checkFinished(s,false)
                return true
            end
        end
        check.sourceMember=check.sourceMember+1
        return true
    end
    error("INCREMENTAL_GEOMETRY_PHASE_INVALID")
end
local function advanceCandidate(s)
    local c=s.candidate
    if c.stage=="REVERSE_INIT" then
        if c.reverseLength>0 then
            segment(c,"MOVE",-c.reverseLength,false,"HEADING")
        else c.stage="HEADING" end
    elseif c.stage=="HEADING" then
        local tx,tz=s.frame.ux*c.direction,s.frame.uz*c.direction
        local p=c.track.pose
        local delta=angleBetween(p.fx,p.fz,tx,tz)
        if c.jTurn then
            if math.abs(delta)<20*RAD then c.stage="REJECT"
            else segment(c,"ARC",delta,true,"S_SETUP") end
        elseif math.abs(delta)>18*RAD then c.stage="REJECT"
        else c.stage="S_SETUP" end
    elseif c.stage=="S_SETUP" then
        local p=c.track.pose
        local tx,tz=s.frame.ux*c.direction,s.frame.uz*c.direction
        local side=p.fx*s.frame.nz-p.fz*s.frame.nx
        local sense=side>=0 and 1 or -1
        local residual=angleBetween(p.fx,p.fz,tx,tz)
        local first=sense*c.alpha
        c.second=residual-first
        if first*c.second>=0 or math.abs(c.second)>95*RAD then
            c.stage="REJECT"
        else segment(c,"ARC",first,true,"ARC2_INIT") end
    elseif c.stage=="ARC2_INIT" then
        segment(c,"ARC",c.second,true,"TERMINAL_INIT")
    elseif c.stage=="SEGMENT" then
        local seg=c.segment
        if seg.index>=seg.steps then
            c.segment=nil
            c.stage=seg.nextStage
        else
            local p
            if seg.kind=="MOVE" then
                p=advance(c.track.pose,seg.step)
            else
                p=turnStep(c.track.pose,c.radius,seg.step)
            end
            makeCheck(s,p,"APPROACH",not seg.forward)
        end
    elseif c.stage=="TERMINAL_INIT" then
        makeCheck(s,c.track.pose,"TERMINAL",false)
    elseif c.stage=="RESERVE_INIT" then
        makeCheck(s,advance(c.track.pose,STOPPING_RESERVE_M),
            "RESERVE",false)
    elseif c.stage=="RUNOUT_INIT" then
        if c.extra>35 then c.stage="REJECT"
        else segment(c,"MOVE",STEP_M,true,"RUNOUT_DONE") end
    elseif c.stage=="RUNOUT_DONE" then
        c.extra=c.extra+STEP_M
        c.stage="TERMINAL_INIT"
    elseif c.stage=="CHECK" then
        return processCheck(s)
    elseif c.stage=="ACCEPT" or c.stage=="REJECT" then
        finishCandidate(s)
    else error("INCREMENTAL_CANDIDATE_PHASE_INVALID") end
    return true
end
local function executeBudget(s)
    while s.remaining>0 do
        if s.phase=="INIT" then
            if not charge(s,1) then return "PENDING" end
            local poly,edge,neighbors,reason=field77()
            if poly==nil then return "FAILED",nil,reason end
            local actual=pose(s.vehicle)
            if actual==nil then return "FAILED",nil,"ROOT_POSE_UNAVAILABLE" end
            local current=s.options and s.options.entryPose or actual
            if type(current)~="table" then
                return "FAILED",nil,"ENTRY_POSE_UNAVAILABLE"
            end
            if not G.inside(poly,current.x,current.z) then
                return "FAILED",nil,"COMPLETED_ROOT_NOT_IN_FIXTURE_FIELD"
            end
            local foot,why=OuttaMyWay.PairTransitRegion.capture(s.vehicle)
            if foot==nil then return "FAILED",nil,why end
            if s.options and s.options.entryPose then
                foot=rotatedFootForEntry(foot,actual,current)
            end
            if foot.memberCount~=1 then
                return "FAILED",nil,"ARTICULATED_ENTRY_REALITY_UNVALIDATED"
            end
            local frame=edgeFrame(edge,poly)
            if frame==nil then return "FAILED",nil,"EDGE_OUTWARD_UNAVAILABLE" end
            local occupants,occupiedWhy=Occupancy.snapshot(s.vehicle,poly)
            if occupants==nil then return "FAILED",nil,occupiedWhy end
            if s.options and s.options.claimObstacles then
                for i=1,#s.options.claimObstacles do
                    occupants[#occupants+1]=s.options.claimObstacles[i]
                end
            end
            local ownRadius=Occupancy.footRadius(s.vehicle)
            if ownRadius==nil then
                return "FAILED",nil,"PHYSICAL_OCCUPANCY_OWN_FOOTPRINT_UNAVAILABLE"
            end
            s.occupants,s.ownRadius=occupants,ownRadius
            s.poly,s.neighbors,s.current,s.foot,s.frame=
                poly,neighbors,current,foot,frame
            s.direction=-1;s.reverse=1;s.radius=1;s.angle=1;s.method=1
            s.phase="CANDIDATE"
        elseif s.phase=="CANDIDATE" then
            if not charge(s,1) then return "PENDING" end
            createCandidate(s)
            s.phase="ACTIVE"
        elseif s.phase=="ACTIVE" then
            -- Charge constant-cost control transitions separately from
            -- the 1-unit neighbour AABB and 24-unit exact intersections.
            if s.candidate.stage~="CHECK" then
                if not charge(s,1) then return "PENDING" end
            end
            if not advanceCandidate(s) then return "PENDING" end
            if s.candidate==nil and s.phase~="FINISH" then
                s.phase="CANDIDATE"
            end
        elseif s.phase=="FINISH" then
            s.finished=true
            if s.best==nil then
                return "FAILED",nil,"NO_POSE_REACHABLE_PARKING_REGION"
            end
            local best=s.best
            return "DONE",{field=77,edge=9,poly=s.poly,
                neighbors=s.neighbors,memberCount=s.foot.memberCount,
                frame=s.frame,method=best.method,
                direction=best.direction,reverseM=best.track.reverseM,
                guideRadiusM=best.radius,
                estimatedTravelM=best.track.travelM,
                terminalPose=best.track.pose,
                legs=best.track.points}
        else error("INCREMENTAL_PLANNING_PHASE_INVALID") end
    end
    return "PENDING"
end
function Route.beginPlan(vehicle,options)
    -- No native-world geometry or actuator call from completion callback.
    if type(vehicle)~="table" then
        return nil,"PLANNING_VEHICLE_UNAVAILABLE"
    end
    return {vehicle=vehicle,phase="INIT",spent=0,advances=0,
        remaining=0,finished=false,options=options}
end
function Route.advancePlan(session,units)
    if type(session)~="table" or session.finished
        or type(units)~="number" or units<24 or units>2048
        or type(session.phase)~="string" then
        return "FAILED",nil,"PLANNING_SESSION_INVALID"
    end
    session.remaining=units
    session.advances=session.advances+1
    local ok,phase,route,reason=pcall(executeBudget,session)
    if not ok then
        session.finished=true
        return "FAILED",nil,"SETTLEMENT_ROUTE_PLAN_EXCEPTION"
    end
    if phase~="PENDING" then session.finished=true end
    return phase,route,reason
end
function Route.guard(vehicle,route,index)
    local p=pose(vehicle)
    if p==nil then return false,"SETTLEMENT_POSE_UNAVAILABLE" end
    local s,d=coordinates(p,route.frame)
    if s<0 or s>route.frame.length
        or (not G.inside(route.poly,p.x,p.z)
            and (d<0 or d>STOP_DEPTH_MAX_M)) then
        return false,"SETTLEMENT_ENTRY_OUTSIDE_EDGE_ENVELOPE"
    end
    return Occupancy.nextClear(vehicle,route,index or 1)
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
    local available,why=Occupancy.nextClear(vehicle,{
        poly=route.poly,legs={{point={x=p.x,z=p.z}}}},1)
    if not available then return false,why end
    return true,"WHOLE_NOMINAL_ASSEMBLY_IN_INTERFIELD_PARKING_REGION"
end
return Route
