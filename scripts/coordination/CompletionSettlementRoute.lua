-- TEST pose-conditioned terminal region + bounded nominal entry candidates.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- Every edge is assessed from registered Source Field geometry.
-- All planned swept footprints are NOMINAL rigid snapshots, not GIANTS physics.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionSettlementRoute={}
local Route=OuttaMyWay.CompletionSettlementRoute
local G=OuttaMyWay.FarmEdgeGeometry
local A=OuttaMyWay.SettlementCorridorAssessment
local Occupancy=OuttaMyWay.SettlementPhysicalOccupancy
local Parking=OuttaMyWay.CompletionParkingGeometry
local Membership=OuttaMyWay.CompletionFieldMembership
local RAD=math.pi/180
local MAX_POINTS=55
local STEP_M=5
local STOP_DEPTH_MAX_M=12
-- The first nominal clear pose is not sufficient when cruise is braking:
-- reserve an additional tangent position for physical stopping overshoot.
local STOPPING_RESERVE_M=5
-- FINAL native waypoints are not ordinary 2.5m guidance points.
-- The existing correction path already uses the 0.75m precision contract.
local TERMINAL_ARRIVAL_RADIUS_M=0.75
-- Bounded radial samples of permitted native positional completion; not a
-- prediction of articulated steering or a continuous physical clearance proof.
local DIAGONAL=math.sqrt(0.5)
local TERMINAL_ARRIVAL_DIRECTIONS={
    {-1,0},{1,0},{0,-1},{0,1},
    {-DIAGONAL,-DIAGONAL},{-DIAGONAL,DIAGONAL},
    {DIAGONAL,-DIAGONAL},{DIAGONAL,DIAGONAL}
}
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function dist(a,b)
    return math.sqrt((a.x-b.x)^2+(a.z-b.z)^2)
end
local function fieldContext(vehicle,options)
    local source=options and options.sourceField
    if source==nil then
        local why
        source,why=Membership.identify(vehicle)
        if source==nil then return nil,nil,nil,nil,why end
    end
    local ctx,why=Parking.enumerate(source,vehicle)
    if ctx==nil then return nil,nil,nil,nil,why end
    local frame,edgeWhy=Parking.select(ctx,options and options.edgeIndex)
    if frame==nil then return nil,nil,nil,nil,edgeWhy end
    return ctx.poly,frame,ctx.neighbors,ctx.fieldId
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
    if edge.ux~=nil and edge.nx~=nil then return edge end
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
-- A completed assembly may start inside the worked field OR within the
-- existing bounded exterior corridor of the selected edge. Identity of its
-- worked field remains independent of the current root position.
local function startInFieldOrEdgeBand(poly,frame,p)
    if G.inside(poly,p.x,p.z) then return true end
    local station,depth=coordinates(p,frame)
    return station>=0 and station<=frame.length
        and depth>=0 and depth<=STOP_DEPTH_MAX_M
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
-- Registered field polygons have world-space AABBs, so distant fields can be
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
local function terminalAllowed(p,foot,initial,poly,neighbors,frame,checkpoint,occupants,ownRadius,reverseExit)
    local station,depth=coordinates(p,frame)
    if occupants~=nil and not Occupancy.clear(p,ownRadius,occupants)
        then return false,"TERMINAL_PHYSICAL_OCCUPANCY" end
    if station<3 or station>frame.length-3
        or depth<0 or depth>STOP_DEPTH_MAX_M then
        return false,"TERMINAL_ROOT_OUTSIDE_EDGE_BAND"
    end
    if reverseExit then
        -- A reverse boundary exit ends with the nose facing back into the
        -- worked field. It is qualified separately from edge-tangent parking.
        local outward=-(p.fx*frame.nx+p.fz*frame.nz)
        if outward<math.cos(20*RAD) then
            return false,"REVERSE_TERMINAL_HEADING_NOT_OUTWARD"
        end
    else
        local parallel=math.abs(p.fx*frame.ux+p.fz*frame.uz)
        if parallel<math.cos(15*RAD) then
            return false,"TERMINAL_HEADING_NOT_EDGE_ALIGNED"
        end
    end
    local boxes=rotatedFoot(foot,initial,p)
    if not noNeighborHit(boxes,neighbors,checkpoint) then
        return false,"TERMINAL_NEIGHBOUR_FIELD_INTERSECTION"
    end
    if G.inside(poly,p.x,p.z) then
        return false,"TERMINAL_ROOT_INSIDE_SOURCE"
    end
    for m=1,#boxes do
        if A.shapeIntersectsPolygon(boxes[m],poly)~=false then
            return false,"TERMINAL_MEMBER_INTERSECTS_SOURCE"
        end
        for i=1,4 do
            local memberStation,memberDepth=coordinates(boxes[m][i],frame)
            if memberStation<1 or memberStation>frame.length-1
                or memberDepth<0.15 or memberDepth>STOP_DEPTH_MAX_M then
                return false,"TERMINAL_MEMBER_OUTSIDE_EDGE_BAND"
            end
        end
    end
    return true
end
local function advance(p,length)
    return {x=p.x+p.fx*length,z=p.z+p.fz*length,fx=p.fx,fz=p.fz}
end
-- Each offset is measured relative to the planned FINAL heading. Runtime
-- still judges the actual stopped heading independently and may refuse.
local function terminalArrivalPose(p,sample)
    local longitudinal=sample[1]*TERMINAL_ARRIVAL_RADIUS_M
    local lateral=sample[2]*TERMINAL_ARRIVAL_RADIUS_M
    return {x=p.x+p.fx*longitudinal-p.fz*lateral,
        z=p.z+p.fz*longitudinal+p.fx*lateral,
        fx=p.fx,fz=p.fz}
end
local function nominalTerminalArrivalClear(p,foot,initial,poly,
    neighbors,frame,checkpoint,occupants,ownRadius,reverseExit)
    for i=1,#TERMINAL_ARRIVAL_DIRECTIONS do
        local sample=terminalArrivalPose(p,TERMINAL_ARRIVAL_DIRECTIONS[i])
        if not terminalAllowed(sample,foot,initial,poly,
            neighbors,frame,checkpoint,occupants,ownRadius,
            reverseExit) then
            return false
        end
    end
    return true
end
-- Only an actual-pose reverse directed into the nominated exterior band
-- may cross the Source Field boundary. Each metre screens the full nominal
-- assembly, occupied space and neighbouring fields. This is a direct terminal
-- candidate, not an unverified intermediate exit or a synthetic entry pose.
local REVERSE_EXIT_MAX_M=40
local REVERSE_EXIT_GUIDE_M=4
local REVERSE_EXIT_WORK_UNITS=96
local function reverseExitEligible(p,frame)
    return -(p.fx*frame.nx+p.fz*frame.nz)>=math.cos(20*RAD)
end
local function reverseExitStepAllowed(s,p)
    local station,depth=coordinates(p,s.frame)
    if station<2 or station>s.frame.length-2
        or (not G.inside(s.poly,p.x,p.z)
            and (depth<0 or depth>STOP_DEPTH_MAX_M))
        or not Occupancy.clear(p,s.ownRadius,s.occupants) then
        return false
    end
    local boxes=rotatedFoot(s.foot,s.current,p)
    if not noNeighborHit(boxes,s.neighbors) then return false end
    for m=1,#boxes do
        for i=1,4 do
            local corner=boxes[m][i]
            if not G.inside(s.poly,corner.x,corner.z) then
                local along,out=coordinates(corner,s.frame)
                if along<1 or along>s.frame.length-1
                    or out<0 or out>STOP_DEPTH_MAX_M then
                    return false
                end
            end
        end
    end
    return true
end
local function reverseExitStep(s)
    local r=s.reverseExit
    if r.metres>=REVERSE_EXIT_MAX_M then return "FAILED" end
    local p=advance(r.pose,-1)
    if not reverseExitStepAllowed(s,p) then return "FAILED" end
    r.metres=r.metres+1
    r.pose=p
    if r.metres%REVERSE_EXIT_GUIDE_M==0 then
        r.legs[#r.legs+1]={name="REVERSE_BOUNDARY_GUIDANCE",
            point={x=p.x,z=p.z},moveForwards=false}
    end
    local station=coordinates(p,s.frame)
    local withinClaim=s.options==nil
        or ((type(s.options.stationMin)~="number"
                or station>=s.options.stationMin)
            and (type(s.options.stationMax)~="number"
                or station<=s.options.stationMax))
    if withinClaim and r.metres>=REVERSE_EXIT_GUIDE_M
        and terminalAllowed(p,s.foot,s.current,s.poly,s.neighbors,
            s.frame,nil,s.occupants,s.ownRadius,true)
        and nominalTerminalArrivalClear(p,s.foot,s.current,s.poly,
            s.neighbors,s.frame,nil,s.occupants,s.ownRadius,true)
        and terminalAllowed(advance(p,-STOPPING_RESERVE_M),
            s.foot,s.current,s.poly,s.neighbors,s.frame,
            nil,s.occupants,s.ownRadius,true) then
        local last=r.legs[#r.legs]
        if r.metres%REVERSE_EXIT_GUIDE_M~=0 then
            last={name="REVERSE_BOUNDARY_TERMINAL",
                point={x=p.x,z=p.z},moveForwards=false}
            r.legs[#r.legs+1]=last
        end
        last.arrivalRadiusM=TERMINAL_ARRIVAL_RADIUS_M
        return "DONE",{field=s.fieldId,edge=s.edgeIndex,poly=s.poly,
            neighbors=s.neighbors,memberCount=s.foot.memberCount,
            frame=s.frame,method="REVERSE_BOUNDARY_EXIT",direction=0,
            reverseM=r.metres,guideRadiusM=0,
            estimatedTravelM=r.metres,terminalPose=p,
            terminalArrivalRadiusM=TERMINAL_ARRIVAL_RADIUS_M,
            legs=r.legs}
    end
    return "PENDING"
end
local function beginReverseExit(s)
    if s.options and s.options.entryPose then return false end
    if not reverseExitEligible(s.current,s.frame) then return false end
    s.reverseExit={pose=s.current,metres=0,legs={}}
    return true
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
            poly,neighbors,frame,checkpoint,occupants,ownRadius)
            and nominalTerminalArrivalClear(track.pose,foot,current,
                poly,neighbors,frame,checkpoint,occupants,ownRadius) then
            local beyond=advance(track.pose,STOPPING_RESERVE_M)
            if terminalAllowed(beyond,foot,current,
                poly,neighbors,frame,checkpoint,occupants,ownRadius) then
                local last=track.points[#track.points]
                if last==nil or not last.moveForwards then return nil end
                last.arrivalRadiusM=TERMINAL_ARRIVAL_RADIUS_M
                return track
            end
            -- Without braking reserve, keep looking along the same
            -- tangent. A later station might still offer a safe stop.
        end
        if not move(track,STEP_M,true,foot,current,
            poly,neighbors,frame,checkpoint,occupants,ownRadius) then return nil end
        extra=extra+STEP_M
    end
    return nil
end
function Route.plan(vehicle,checkpoint,options)
    local poly,edge,neighbors,fieldId,reason=fieldContext(vehicle,options)
    if poly==nil then return nil,reason end
    local current=pose(vehicle)
    if current==nil then return nil,"ROOT_POSE_UNAVAILABLE" end
    if not startInFieldOrEdgeBand(poly,edge,current) then
        return nil,"COMPLETED_POSE_OUTSIDE_SELECTED_EDGE_ENVELOPE"
    end
    local foot,why=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return nil,why end
    -- Captured current member rectangles bound the nominal candidate.
    -- The native actuator handles forward/reverse for multi-member assemblies;
    -- live member poses are rechecked during guidance and at final stopping.
    local occupants,occupiedWhy=Occupancy.snapshot(vehicle,poly)
    if occupants==nil then return nil,occupiedWhy end
    local ownRadius=Occupancy.footRadius(vehicle)
    if ownRadius==nil then
        return nil,"PHYSICAL_OCCUPANCY_OWN_FOOTPRINT_UNAVAILABLE"
    end
    local frame=edgeFrame(edge,poly)
    if frame==nil then return nil,"EDGE_OUTWARD_UNAVAILABLE" end
    local reverseSession={options=options,current=current,foot=foot,
        poly=poly,neighbors=neighbors,frame=frame,occupants=occupants,
        ownRadius=ownRadius,fieldId=fieldId,edgeIndex=edge.index}
    if beginReverseExit(reverseSession) then
        for _=1,REVERSE_EXIT_MAX_M do
            local phase,route=reverseExitStep(reverseSession)
            if phase=="DONE" then return route,nil end
            if phase=="FAILED" then break end
        end
    end
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
    return {field=fieldId,edge=edge.index,poly=poly,neighbors=neighbors,
        memberCount=foot.memberCount,frame=frame,
        method=best.method,direction=best.direction,
        reverseM=best.track.reverseM,guideRadiusM=best.radius,
        estimatedTravelM=best.track.travelM,
        terminalArrivalRadiusM=TERMINAL_ARRIVAL_RADIUS_M,
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
    if c~=nil and c.accepted and s.options~=nil
        and s.options.earliestQualified==true then
        -- Allocation needs a feasible destination, not proof that no
        -- geometrically longer feasible manoeuvre exists at this site.
        -- c.accepted is set ONLY after nominal route, terminal and
        -- stopping reserve checks have all passed.
        s.phase="FINISH"
        return
    end
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
    s.candidates=(s.candidates or 0)+1
    local c={track=newTrack(s.current),direction=s.direction,
        reverseLength=REVERSES[s.reverse],
        radius=RADII[s.radius],alpha=ANGLES[s.angle],
        jTurn=s.method==2,stage="REVERSE_INIT",extra=0}
    s.candidate=c
end
-- One bounded count per evaluated rejection, never a steering instruction.
local function denied(s,why)
    s.rejectionCounts=s.rejectionCounts or {}
    s.rejectionCounts[why]=(s.rejectionCounts[why] or 0)+1
end
local function makeCheck(s,p,kind,reverse)
    local c=s.candidate
    local station,depth=coordinates(p,s.frame)
    if kind~="APPROACH" and s.options~=nil
        and type(s.options.stationMin)=="number"
        and type(s.options.stationMax)=="number"
        and (station<s.options.stationMin
            or station>s.options.stationMax) then
        denied(s,"TERMINAL_OUTSIDE_CLAIMED_STATION")
        c.stage="RUNOUT_INIT"
        return
    end
    if kind=="APPROACH" then
        if #c.track.points>=MAX_POINTS
            or station<2 or station>s.frame.length-2 then
            denied(s,#c.track.points>=MAX_POINTS
                and "APPROACH_GUIDANCE_LIMIT" or "APPROACH_STATION_BAND")
            c.stage="REJECT"
            return
        end
    else
        if station<3 or station>s.frame.length-3
            or depth<0 or depth>STOP_DEPTH_MAX_M
            or math.abs(p.fx*s.frame.ux+p.fz*s.frame.uz)
                <math.cos(15*RAD) then
            denied(s,(station<3 or station>s.frame.length-3)
                and "TERMINAL_STATION_BAND"
                or (depth<0 or depth>STOP_DEPTH_MAX_M)
                and "TERMINAL_DEPTH_BAND" or "TERMINAL_HEADING_BAND")
            c.stage="RUNOUT_INIT"
            return
        end
    end
    if not Occupancy.clear(p,s.ownRadius,s.occupants) then
        denied(s,kind=="APPROACH"
            and "APPROACH_PHYSICAL_OCCUPANCY" or "TERMINAL_PHYSICAL_OCCUPANCY")
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
        c.arrivalIndex=1
        c.stage="ARRIVAL_INIT"
    elseif check.kind=="ARRIVAL" and clear then
        c.arrivalIndex=c.arrivalIndex+1
        c.stage="ARRIVAL_INIT"
    elseif check.kind=="RESERVE" and clear then
        local last=c.track.points[#c.track.points]
        if last==nil or not last.moveForwards then
            denied(s,"TERMINAL_FINAL_GUIDANCE_UNAVAILABLE")
            c.stage="REJECT"
        else
            last.arrivalRadiusM=TERMINAL_ARRIVAL_RADIUS_M
            c.accepted=true
            c.stage="ACCEPT"
        end
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
            denied(s,"NEIGHBOR_POLYGON_"..check.kind)
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
                    denied(s,"REVERSE_ROOT_OUTSIDE_SOURCE")
                    checkFinished(s,false)
                    return true
                end
                for m=1,#check.boxes do
                    for i=1,4 do
                        local corner=check.boxes[m][i]
                        if not G.inside(s.poly,corner.x,corner.z) then
                            denied(s,"REVERSE_MEMBER_OUTSIDE_SOURCE")
                            checkFinished(s,false)
                            return true
                        end
                    end
                end
            elseif not G.inside(s.poly,check.point.x,check.point.z)
                and (check.depth<0 or check.depth>STOP_DEPTH_MAX_M) then
                denied(s,"FORWARD_OUTSIDE_EDGE_BAND")
                checkFinished(s,false)
                return true
            end
            checkFinished(s,true)
            return true
        end
        if G.inside(s.poly,check.point.x,check.point.z) then
            denied(s,"TERMINAL_ROOT_STILL_IN_SOURCE")
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
            denied(s,"TERMINAL_MEMBER_INTERSECTS_SOURCE")
            checkFinished(s,false)
            return true
        end
        for i=1,4 do
            local station,depth=coordinates(box[i],s.frame)
            if station<1 or station>s.frame.length-1
                or depth<0.15 or depth>STOP_DEPTH_MAX_M then
                denied(s,"TERMINAL_MEMBER_MARGIN_ENVELOPE")
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
            if math.abs(delta)<20*RAD then
                denied(s,"J_HEADING_TOO_ALIGNED")
                c.stage="REJECT"
            else segment(c,"ARC",delta,true,"S_SETUP") end
        elseif math.abs(delta)>18*RAD then
            denied(s,"DIRECT_HEADING_MISALIGNED")
            c.stage="REJECT"
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
            denied(s,"S_CURVE_TURN_GEOMETRY")
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
    elseif c.stage=="ARRIVAL_INIT" then
        if c.arrivalIndex>#TERMINAL_ARRIVAL_DIRECTIONS then
            c.stage="RESERVE_INIT"
        else
            makeCheck(s,terminalArrivalPose(c.track.pose,
                TERMINAL_ARRIVAL_DIRECTIONS[c.arrivalIndex]),
                "ARRIVAL",false)
        end
    elseif c.stage=="RESERVE_INIT" then
        makeCheck(s,advance(c.track.pose,STOPPING_RESERVE_M),
            "RESERVE",false)
    elseif c.stage=="RUNOUT_INIT" then
        if c.extra>35 then
            denied(s,"RUNOUT_EXHAUSTED")
            c.stage="REJECT"
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
            local poly,edge,neighbors,fieldId,reason=fieldContext(s.vehicle,s.options)
            if poly==nil then return "FAILED",nil,reason end
            local actual=pose(s.vehicle)
            if actual==nil then return "FAILED",nil,"ROOT_POSE_UNAVAILABLE" end
            local current=s.options and s.options.entryPose or actual
            if type(current)~="table" then
                return "FAILED",nil,"ENTRY_POSE_UNAVAILABLE"
            end
            if not startInFieldOrEdgeBand(poly,edge,current) then
                return "FAILED",nil,"COMPLETED_POSE_OUTSIDE_SELECTED_EDGE_ENVELOPE"
            end
            local foot,why=OuttaMyWay.PairTransitRegion.capture(s.vehicle)
            if foot==nil then return "FAILED",nil,why end
            if s.options and s.options.entryPose then
                foot=rotatedFootForEntry(foot,actual,current)
            end
            -- A multi-member assembly participates in the same bounded
            -- candidate search; unsupported routes fail geometry, not identity.
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
            s.poly,s.neighbors,s.current,s.foot,s.frame,s.fieldId,s.edgeIndex=
                poly,neighbors,current,foot,frame,fieldId,edge.index
            s.direction=-1;s.reverse=1;s.radius=1;s.angle=1;s.method=1
            if beginReverseExit(s) then
                s.phase="REVERSE_EXIT"
            else
                s.phase="CANDIDATE"
            end
        elseif s.phase=="REVERSE_EXIT" then
            -- The same 20-second response deadline applies; reverse
            -- screening consumes finite weighted work in each update.
            if not charge(s,REVERSE_EXIT_WORK_UNITS) then
                return "PENDING"
            end
            local result,route=reverseExitStep(s)
            if result=="DONE" then
                s.finished=true
                return "DONE",route
            end
            if result=="FAILED" then s.phase="CANDIDATE" end
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
            return "DONE",{field=s.fieldId,edge=s.edgeIndex,poly=s.poly,
                neighbors=s.neighbors,memberCount=s.foot.memberCount,
                frame=s.frame,method=best.method,
                direction=best.direction,reverseM=best.track.reverseM,
                guideRadiusM=best.radius,
                estimatedTravelM=best.track.travelM,
                terminalPose=best.track.pose,
                terminalArrivalRadiusM=TERMINAL_ARRIVAL_RADIUS_M,
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
    local foot,why=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return false,why end
    if foot.memberCount~=route.memberCount then
        return false,"ASSEMBLY_MEMBERSHIP_CHANGED"
    end
    -- Actual current member poses are independent of root-only guidance.
    -- The nominal planner may rotate a captured configuration; movement
    -- continuation must reject observed deviation into other field polygons
    -- or outside the nominated exterior corridor.
    local boxes=rotatedFoot(foot,p,p)
    if not noNeighborHit(boxes,route.neighbors) then
        return false,"LIVE_MEMBER_INTERSECTS_NEIGHBOUR_FIELD"
    end
    for m=1,#boxes do
        for i=1,4 do
            local v=boxes[m][i]
            if not G.inside(route.poly,v.x,v.z) then
                local station,depth=coordinates(v,route.frame)
                if station<0 or station>route.frame.length
                    or depth<0 or depth>STOP_DEPTH_MAX_M then
                    return false,"LIVE_MEMBER_OUTSIDE_SELECTED_EDGE_CORRIDOR"
                end
            end
        end
    end
    return Occupancy.nextClear(vehicle,route,index or 1)
end
-- One bounded stopped correction, evaluated from ACTUAL selected-member
-- geometry. This does not grant collision/road/terrain clearance. Live route
-- guards, existing claim and native stable-stop authority remain independent.
-- Correct actual stopped terminal position AND heading. Curved candidates
-- are nominal GIANTS-forward hypotheses; only positive terminal and run-out
-- geometry can admit a bounded new native drive lease.
local CORRECTION_MAX_TRAVEL_M=12
local CORRECTION_ARRIVAL_M=0.75
local CORRECTION_RADII={24,18,12}
local function correctionRoute(route,legs,point,travel,direction)
    local correction={}
    for k,v in pairs(route) do correction[k]=v end
    correction.terminalPose={x=point.x,z=point.z,fx=point.fx,fz=point.fz}
    correction.legs=legs
    correction.method=direction=="CURVED" and
        "STOPPED_TERMINAL_ALIGNMENT" or "STOPPED_TERMINAL_CORRECTION"
    correction.reverseM=0
    correction.estimatedTravelM=travel
    return correction
end
function Route.planTerminalCorrection(vehicle,route)
    if type(route)~="table" or type(route.frame)~="table"
        or type(route.poly)~="table"
        or type(route.neighbors)~="table"
        or route.mode=="EXTENDED_INFIELD" then
        return nil,"TERMINAL_CORRECTION_ROUTE_UNAVAILABLE"
    end
    local current=pose(vehicle)
    local foot,reason=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if current==nil or foot==nil or foot.memberCount~=route.memberCount then
        return nil,reason or "TERMINAL_CORRECTION_ASSEMBLY_UNAVAILABLE"
    end
    local frame=route.frame
    if not startInFieldOrEdgeBand(route.poly,frame,current) then
        return nil,"TERMINAL_CORRECTION_START_OUTSIDE_CORRIDOR"
    end
    local occupants,occupiedWhy=Occupancy.snapshot(vehicle,route.poly)
    if occupants==nil then return nil,occupiedWhy end
    local own=Occupancy.footRadius(vehicle)
    if own==nil then return nil,"TERMINAL_CORRECTION_FOOTPRINT_UNKNOWN" end
    local function approach(point)
        return approachAllowed(point,foot,current,route.poly,
            route.neighbors,frame,false,nil,occupants,own)
    end
    local function terminal(point)
        return terminalAllowed(point,foot,current,route.poly,
            route.neighbors,frame,nil,occupants,own)
    end
    local function fitsWithBraking(point)
        return terminal(point)
            and terminal(advance(point,-CORRECTION_ARRIVAL_M))
            and terminal(advance(point,STOPPING_RESERVE_M))
    end
    -- The straight case remains useful when heading already qualifies.
    -- Check the full intermediate corridor, not just its destination.
    local point=current
    for distance=1,8 do
        point=advance(point,1)
        if not approach(point) then break end
        if distance>=3 and fitsWithBraking(point) then
            return correctionRoute(route,{{
                name="TERMINAL_PLACEMENT_CORRECTION",
                point={x=point.x,z=point.z},moveForwards=true,
                arrivalRadiusM=CORRECTION_ARRIVAL_M
            }},point,distance,"STRAIGHT")
        end
    end
    -- A terminal-heading refusal cannot be corrected by translating the
    -- same heading. Use the existing nominal forward-arc mechanism, then
    -- straighten along the nominated edge. Test both tangent directions;
    -- no reverse or unqualified edge crossing is introduced.
    for _,radius in ipairs(CORRECTION_RADII) do
        for _,direction in ipairs({-1,1}) do
            local tx,tz=frame.ux*direction,frame.uz*direction
            local delta=angleBetween(current.fx,current.fz,tx,tz)
            local arcDistance=radius*math.abs(delta)
            if math.abs(delta)>=0.001 and math.abs(delta)<=45*RAD
                and arcDistance>=3 and arcDistance<=CORRECTION_MAX_TRAVEL_M-3 then
                local arcGuides=math.ceil(arcDistance/5)
                local guideDistance=arcDistance/arcGuides
                if guideDistance>=3 then
                    local sampleCount=math.ceil(arcDistance)
                    local poseAt=current
                    local valid=true
                    local legs={}
                    local guideIndex=1
                    for i=1,sampleCount do
                        poseAt=turnStep(poseAt,radius,delta/sampleCount)
                        if not approach(poseAt) then valid=false;break end
                        if i==sampleCount
                            or i*arcDistance/sampleCount>=
                                guideIndex*guideDistance-0.0001 then
                            legs[#legs+1]={
                                name="TERMINAL_HEADING_GUIDANCE",
                                point={x=poseAt.x,z=poseAt.z},
                                moveForwards=true,
                                arrivalRadiusM=CORRECTION_ARRIVAL_M}
                            guideIndex=guideIndex+1
                        end
                    end
                    if valid then
                        local remaining=math.floor(
                            CORRECTION_MAX_TRAVEL_M-arcDistance)
                        local candidate=poseAt
                        for distance=1,remaining do
                            candidate=advance(candidate,1)
                            if not approach(candidate) then break end
                            -- Allow a meaningful edge-aligned straight leg,
                            -- then require verified room to stop early.
                            if distance>=3 and fitsWithBraking(candidate) then
                                legs[#legs+1]={
                                    name="TERMINAL_PLACEMENT_CORRECTION",
                                    point={x=candidate.x,z=candidate.z},
                                    moveForwards=true,
                                    arrivalRadiusM=CORRECTION_ARRIVAL_M}
                                return correctionRoute(route,legs,candidate,
                                    arcDistance+distance,"CURVED")
                            end
                        end
                    end
                end
            end
        end
    end
    return nil,"NO_QUALIFIED_HEADING_AND_TERMINAL_CORRECTION"
end
function Route.verifyTerminal(vehicle,route)
    local foot,reason=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return false,reason end
    if foot.memberCount~=route.memberCount then
        return false,"ASSEMBLY_MEMBERSHIP_CHANGED"
    end
    local p=pose(vehicle)
    if p==nil then return false,"ROOT_POSE_UNAVAILABLE" end
    local valid,predicate=terminalAllowed(p,foot,p,route.poly,
        route.neighbors,route.frame,nil,nil,nil,
        route.method=="REVERSE_BOUNDARY_EXIT")
    if not valid then
        return false,"WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION",predicate
    end
    local available,why=Occupancy.nextClear(vehicle,{
        poly=route.poly,legs={{point={x=p.x,z=p.z}}}},1)
    if not available then return false,why end
    return true,"WHOLE_NOMINAL_ASSEMBLY_IN_INTERFIELD_PARKING_REGION"
end
return Route
