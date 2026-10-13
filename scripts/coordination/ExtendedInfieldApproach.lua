-- Experimental Field 77 Extended Infield Approach: heading-aware short
-- forward guidance to an entry REGION on preferred edge 9.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- This is an independent approach planner, NOT parking or BWR Control.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.ExtendedInfieldApproach={}
local M=OuttaMyWay.ExtendedInfieldApproach
local G=OuttaMyWay.FarmEdgeGeometry
local Occupancy=OuttaMyWay.SettlementPhysicalOccupancy
local RAD=math.pi/180
local STEP=8
local TURN=math.pi/8
local HEADINGS=16
local MAX_EXPANSIONS=16000
local MAX_GUIDES=115
local PEER_RESERVE_M=12
local MAX_SCENE=512
local FIXTURE={ax=228.15,az=-243.04,bx=-0.06,bz=-207.44,length=230.97}
local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end
local function pose(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function"
        or type(localDirectionToWorld)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    local yes,fx,_,fz=pcall(localDirectionToWorld,vehicle.rootNode,0,0,1)
    if not ok or not yes or not finite(x) or not finite(z)
        or not finite(fx) or not finite(fz) then return nil end
    local len=math.sqrt(fx*fx+fz*fz)
    if len<0.001 then return nil end
    return {x=x,z=z,fx=fx/len,fz=fz/len}
end
local function context(vehicle)
    local manager=g_fieldManager
    if type(manager)~="table" or type(manager.fields)~="table"
        then return nil,"FIELD_REGISTRY_UNAVAILABLE" end
    local source
    if type(manager.getFieldById)=="function" then
        local ok,f=pcall(manager.getFieldById,manager,77)
        if ok then source=f end
    end
    if source==nil then source=manager.fields[77] end
    local poly=G.polygonFor(source)
    if poly==nil then return nil,"FIELD_77_UNAVAILABLE" end
    local edges=G.edges(poly)
    local edge=edges[9]
    if edge==nil or math.abs(edge.ax-FIXTURE.ax)>3
        or math.abs(edge.az-FIXTURE.az)>3
        or math.abs(edge.bx-FIXTURE.bx)>3
        or math.abs(edge.bz-FIXTURE.bz)>3
        or math.abs(edge.length-FIXTURE.length)>3 then
        return nil,"FIELD_77_EDGE_9_MISMATCH"
    end
    local nx,nz=G.outwardAt(poly,edge,
        (edge.ax+edge.bx)*0.5,(edge.az+edge.bz)*0.5)
    if nx==nil then return nil,"EDGE_NORMAL_UNAVAILABLE" end
    local current=pose(vehicle)
    if current==nil or not G.inside(poly,current.x,current.z) then
        return nil,"COMPLETION_ROOT_OUTSIDE_FIELD_77"
    end
    local foot,why=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if foot==nil then return nil,why end
    if foot.memberCount~=1 then
        return nil,"EXTENDED_ARTICULATED_SWEEP_UNVALIDATED"
    end
    local peers,inventory,reason,evidence=M.activePeers(vehicle,poly)
    if not inventory then return nil,reason,evidence end
    local occupants,occupiedWhy=Occupancy.snapshot(vehicle,poly)
    if occupants==nil then return nil,occupiedWhy,evidence end
    local ownRadius=Occupancy.footRadius(vehicle)
    if ownRadius==nil then
        return nil,"PHYSICAL_OCCUPANCY_OWN_FOOTPRINT_UNAVAILABLE",evidence
    end
    return {poly=poly,foot=foot,initial=current,peers=peers,
        occupants=occupants,ownRadius=ownRadius,
        sceneEvidence=evidence,
        edge={ax=edge.ax,az=edge.az,ux=edge.dx/edge.length,
            uz=edge.dz/edge.length,nx=nx,nz=nz,length=edge.length}},nil,evidence
end
local function peerRange(vehicle)
    local radius=PEER_RESERVE_M
    local footprint=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if type(footprint)=="table" and type(footprint.corners)=="table" then
        for i=1,#footprint.corners do
            local c=footprint.corners[i]
            radius=math.max(radius,
                math.sqrt(c.x*c.x+c.z*c.z)+PEER_RESERVE_M)
        end
    else
        radius=22 -- unknown size is NOT treated as clearance
    end
    return radius
end
-- Use the established GIANTS physical-vehicle registry contract already
-- consumed by StaticBlockageEncounterObservation, NOT mission.vehicles.
-- Evaluate worker status only for objects whose root is inside this field.
-- Unknown AI status for a potentially relevant root must not mean "clear".
local function rootOf(v)
    if type(v)~="table" then return nil end
    if type(v.getRootVehicle)=="function" then
        local ok,root=pcall(v.getRootVehicle,v)
        if ok and type(root)=="table" then return root end
    end
    return type(v.rootVehicle)=="table" and v.rootVehicle or v
end
local function position(v)
    if v.rootNode==nil or v.rootNode==0
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,v.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {x=x,z=z}
end
local function aiState(v)
    local hasFlag=type(v.getIsAIActive)=="function"
    local hasJob=type(v.getCurrentAIJob)=="function"
    if not hasFlag and not hasJob then
        return nil,"NOT_AN_AI_WORKER_CONTRACT"
    end
    local flagKnown,flag=false,nil
    if hasFlag then
        local ok,value=pcall(v.getIsAIActive,v)
        if ok and type(value)=="boolean" then
            flagKnown=true;flag=value
        end
    end
    local jobKnown,job=false,nil
    if hasJob then
        local ok,value=pcall(v.getCurrentAIJob,v)
        if ok then jobKnown=true;job=value~=nil end
    end
    if (flagKnown and flag) or (jobKnown and job) then return true end
    if (not hasFlag or flagKnown) and (not hasJob or jobKnown) then
        return false
    end
    return nil,"AI_STATUS_UNOBSERVABLE"
end
function M.activePeers(selfVehicle,poly)
    local mission=g_currentMission
    local vehicles=mission and mission.vehicleSystem
        and mission.vehicleSystem.vehicles
    local evidence={registry="MISSION_VEHICLE_SYSTEM",scanned=0,
        observedWorkers=0,outsideField=0,nonAiRoots=0,
        failureRoot="none"}
    if type(vehicles)~="table" then
        return {},false,"WORKER_SCENE_REGISTRY_UNAVAILABLE",evidence
    end
    local found,seen={},{}
    local ownRoot=rootOf(selfVehicle)
    local failReason=nil
    local function consider(item)
        if failReason~=nil or type(item)~="table" then return end
        local other=rootOf(item)
        if other==nil or other==ownRoot or other.isDeleted==true
            or other.rootNode==nil or seen[other.rootNode] then return end
        seen[other.rootNode]=true
        local where=position(other)
        if where~=nil and not G.inside(poly,where.x,where.z) then
            evidence.outsideField=evidence.outsideField+1
            return
        end
        local active,why=aiState(other)
        if active==false then return end
        if active==nil and why=="NOT_AN_AI_WORKER_CONTRACT" then
            evidence.nonAiRoots=evidence.nonAiRoots+1
            return
        end
        if active==nil then
            failReason="WORKER_SCENE_AI_STATUS_UNAVAILABLE"
        elseif where==nil then
            failReason="WORKER_SCENE_ACTIVE_POSITION_UNAVAILABLE"
        else
            found[#found+1]={vehicle=other,x=where.x,z=where.z,
                radius=peerRange(other)}
            evidence.observedWorkers=evidence.observedWorkers+1
            return
        end
        evidence.failureRoot=tostring(other.rootNode)
    end
    -- The native vehicle table may use entity keys or values. Scan both,
    -- as the existing blocked-worker observation already does, and dedup.
    for key,value in pairs(vehicles) do
        evidence.scanned=evidence.scanned+1
        if evidence.scanned>MAX_SCENE then
            return found,false,"WORKER_SCENE_CENSUS_LIMIT",evidence
        end
        consider(key)
        consider(value)
        if failReason~=nil then return found,false,failReason,evidence end
    end
    return found,true,nil,evidence
end
local function clearance(p,peers)
    for i=1,#peers do
        local o=peers[i]
        local dx,dz=p.x-o.x,p.z-o.z
        if dx*dx+dz*dz<(o.radius+6)^2 then return false end
    end
    return true
end
local function rotatedFootOK(ctx,p)
    local d=ctx.initial.fx*p.fx+ctx.initial.fz*p.fz
    local s=ctx.initial.fx*p.fz-ctx.initial.fz*p.fx
    for i=1,#ctx.foot.corners do
        local v=ctx.foot.corners[i]
        local x=p.x+v.x*d-v.z*s
        local z=p.z+v.x*s+v.z*d
        if not G.inside(ctx.poly,x,z) then return false end
    end
    return true
end
local function onField(ctx,p)
    return G.inside(ctx.poly,p.x,p.z)
        and rotatedFootOK(ctx,p) and clearance(p,ctx.peers)
        and Occupancy.clear(p,ctx.ownRadius,ctx.occupants)
end
local function coord(p,f)
    local x,z=p.x-f.ax,p.z-f.az
    return x*f.ux+z*f.uz,x*f.nx+z*f.nz
end
local function isEntry(ctx,p)
    if ctx.target~=nil then
        local dx,dz=p.x-ctx.target.x,p.z-ctx.target.z
        return dx*dx+dz*dz<=9*9
            and p.fx*ctx.target.fx+p.fz*ctx.target.fz
                >=math.cos(25*RAD)
            and onField(ctx,p)
    end
    local f=ctx.edge
    local station,depth=coord(p,f)
    return station>=16 and station<=f.length-16
        and depth<=-11 and depth>=-24
        and p.fx*(-f.ux)+p.fz*(-f.uz)>=math.cos(12*RAD)
        and onField(ctx,p)
        and Occupancy.clear({
            x=p.x+f.nx*12,z=p.z+f.nz*12
        },ctx.ownRadius,ctx.occupants,8)
end
local function heuristic(ctx,p)
    if ctx.target~=nil then
        local dx,dz=p.x-ctx.target.x,p.z-ctx.target.z
        return math.sqrt(dx*dx+dz*dz)
    end
    local f=ctx.edge
    local s=coord(p,f)
    s=math.max(18,math.min(f.length-18,s))
    local x=f.ax+f.ux*s-f.nx*17
    local z=f.az+f.uz*s-f.nz*17
    local dx,dz=x-p.x,z-p.z
    return math.sqrt(dx*dx+dz*dz)
end
local function key(ctx,p)
    local angle=math.atan2 and math.atan2(p.fx,p.fz)
        or math.atan(p.fx,p.fz)
    local bin=math.floor((angle+math.pi)/TURN+0.5)%HEADINGS
    return tostring(math.floor((p.x-ctx.poly.minX)/STEP+0.5))..":"..
        tostring(math.floor((p.z-ctx.poly.minZ)/STEP+0.5))..":"..tostring(bin)
end
local function heapPush(heap,n)
    local i=#heap+1
    while i>1 do
        local j=math.floor(i/2)
        if heap[j].f<=n.f then break end
        heap[i]=heap[j];i=j
    end
    heap[i]=n
end
local function heapPop(heap)
    if #heap==0 then return nil end
    local result=heap[1]
    local last=heap[#heap];heap[#heap]=nil
    if #heap==0 then return result end
    local i=1
    while i*2<=#heap do
        local j=i*2
        if j<#heap and heap[j+1].f<heap[j].f then j=j+1 end
        if last.f<=heap[j].f then break end
        heap[i]=heap[j];i=j
    end
    heap[i]=last
    return result
end
local function transition(p,steering,fraction)
    local theta=steering*TURN*fraction
    local h=theta*.5
    local dx=p.fx*math.cos(h)-p.fz*math.sin(h)
    local dz=p.fx*math.sin(h)+p.fz*math.cos(h)
    return {x=p.x+dx*STEP*fraction,z=p.z+dz*STEP*fraction,
        fx=p.fx*math.cos(theta)-p.fz*math.sin(theta),
        fz=p.fx*math.sin(theta)+p.fz*math.cos(theta)}
end
local function candidate(ctx,node,steering)
    -- Every prospective 8m steering step samples intermediate root and
    -- footprint containment, and a known active-worker clearance reserve.
    for j=1,4 do
        local q=transition(node.pose,steering,j*.25)
        if not onField(ctx,q) then return nil end
    end
    return transition(node.pose,steering,1)
end
local function reconstruct(ctx,node)
    local rev={}
    local travelled=0
    while node.parent~=nil do
        rev[#rev+1]=node.pose
        travelled=travelled+STEP
        node=node.parent
        if #rev>MAX_GUIDES then return nil,"EXTENDED_APPROACH_TOO_LONG" end
    end
    local legs={}
    for i=#rev,1,-1 do
        legs[#legs+1]={name="EXTENDED_INFIELD_GUIDANCE",
            point={x=rev[i].x,z=rev[i].z},moveForwards=true}
    end
    if #legs==0 and ctx.target==nil then
        return nil,"EXTENDED_ALREADY_AT_ENTRY"
    end
    return {mode="EXTENDED_INFIELD",field=77,edge=9,
        poly=ctx.poly,entryHeading=ctx.target
            and {fx=ctx.target.fx,fz=ctx.target.fz}
            or {fx=ctx.edge.ux*-1,fz=ctx.edge.uz*-1},
        entryPose=ctx.target,estimatedTravelM=travelled,
        memberCount=ctx.foot.memberCount,
        method="HEADING_LATTICE_INFIELD",reverseM=0,
        guideRadiusM=STEP/TURN,guidancePoints=#legs,
        legs=legs},nil
end
function M.beginPlan(vehicle,target)
    if type(vehicle)~="table" then return nil,"VEHICLE_UNAVAILABLE" end
    return {vehicle=vehicle,target=target,phase="INIT",spent=0,advances=0,
        expansions=0,finished=false}
end
function M.advancePlan(s,budget)
    if type(s)~="table" or s.finished
        or not finite(budget) or budget<3 or budget>2048 then
        return "FAILED",nil,"EXTENDED_PLANNING_SESSION_INVALID"
    end
    s.advances=s.advances+1
    local units=budget
    while units>0 do
        if s.phase=="INIT" then
            local ctx,reason,evidence=context(s.vehicle)
            s.sceneEvidence=evidence
            if ctx==nil then
                s.finished=true;return "FAILED",nil,reason
            end
            ctx.target=s.target
            s.ctx=ctx
            local first={pose=ctx.initial,g=0,parent=nil}
            first.f=heuristic(ctx,first.pose)
            s.heap={first};s.best={[key(ctx,first.pose)]=0}
            s.phase="SEARCH"
        elseif s.phase=="SEARCH" then
            if s.expansions>=MAX_EXPANSIONS then
                s.finished=true;return "FAILED",nil,"EXTENDED_SEARCH_BUDGET_EXHAUSTED"
            end
            local node=heapPop(s.heap)
            if node==nil then
                s.finished=true;return "FAILED",nil,"NO_EXTENDED_APPROACH_TO_EDGE_9"
            end
            s.expansions=s.expansions+1;s.spent=s.spent+1;units=units-1
            if isEntry(s.ctx,node.pose) then
                local route,why=reconstruct(s.ctx,node)
                s.finished=true
                if route~=nil then
                    route.planningExpansions=s.expansions
                    return "DONE",route
                end
                return "FAILED",nil,why
            end
            s.node=node;s.steer=-1;s.phase="EXPAND"
        elseif s.phase=="EXPAND" then
            local nextPose=candidate(s.ctx,s.node,s.steer)
            s.spent=s.spent+1;units=units-1
            if nextPose~=nil then
                local k=key(s.ctx,nextPose)
                local score=s.node.g+STEP+(s.steer~=0 and .35 or 0)
                if s.best[k]==nil or score<s.best[k]-.001 then
                    s.best[k]=score
                    heapPush(s.heap,{pose=nextPose,g=score,
                        f=score+heuristic(s.ctx,nextPose),parent=s.node})
                end
            end
            s.steer=s.steer+1
            if s.steer>1 then s.phase="SEARCH" end
        else
            s.finished=true;return "FAILED",nil,"EXTENDED_PLANNING_PHASE_INVALID"
        end
    end
    return "PENDING"
end
function M.guard(vehicle,route,index)
    local p=pose(vehicle)
    if p==nil then return false,"EXTENDED_APPROACH_POSE_UNAVAILABLE" end
    if not G.inside(route.poly,p.x,p.z) then
        return false,"EXTENDED_APPROACH_FIELD_CONTAINMENT_LOST"
    end
    local others,okay,reason=M.activePeers(vehicle,route.poly)
    if not okay then return false,reason or "EXTENDED_WORKER_OBSERVATION_UNAVAILABLE" end
    local physical,physicalWhy=Occupancy.nextClear(vehicle,route,index)
    if not physical then return false,physicalWhy end
    local goal=route.legs[math.min(index,#route.legs)]
    if goal~=nil then
        local x,z=goal.point.x,goal.point.z
        for i=1,#others do
            local o=others[i]
            local dx,dz=x-o.x,z-o.z
            local rx,rz=p.x-o.x,p.z-o.z
            local threshold=(o.radius+8)^2
            if dx*dx+dz*dz<threshold or rx*rx+rz*rz<threshold then
                return false,"EXTENDED_ACTIVE_WORKER_PROXIMITY"
            end
        end
    end
    return true
end
return M
