-- Bounded forward boundary CLEARANCE step from an observed STRADDLING pose.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- Read-only qualification; physical clearance is observed AFTER a real stop.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionBoundaryExitContinuation={}
local M=OuttaMyWay.CompletionBoundaryExitContinuation
local Parking=OuttaMyWay.CompletionParkingGeometry
local Membership=OuttaMyWay.CompletionAssemblyFieldOccupancy
local G=OuttaMyWay.FarmEdgeGeometry
local Assessment=OuttaMyWay.SettlementCorridorAssessment
local Occupancy=OuttaMyWay.SettlementPhysicalOccupancy
local Situation=OuttaMyWay.SettlementDestinationAssessment
-- A 2m target with 0.75m native arrival permits stopping after 1.25m.
-- Place the target 0.75m beyond the required movement and screen the
-- possible forward run-out; do not confuse a target with travelled distance.
local MIN_FORWARD_M=2
local ARRIVAL_M=0.75
local TARGET_M=MIN_FORWARD_M+ARRIVAL_M
local SAMPLES={1,2,TARGET_M,TARGET_M+ARRIVAL_M}
local EXTERIOR_ROOT_LIMIT_M=12
local HEADING_DRIFT_RAD=15*math.pi/180
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function pose(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function"
        or type(localDirectionToWorld)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    local heading,fx,_,fz=pcall(localDirectionToWorld,vehicle.rootNode,0,0,1)
    if not ok or not heading or not finite(x) or not finite(z)
        or not finite(fx) or not finite(fz) then return nil end
    local n=math.sqrt(fx*fx+fz*fz)
    if n<0.001 then return nil end
    return {x=x,z=z,fx=fx/n,fz=fz/n}
end
local function forward(p,length)
    return {x=p.x+p.fx*length,z=p.z+p.fz*length,
        fx=p.fx,fz=p.fz}
end
local function coordinates(p,edge)
    local dx,dz=p.x-edge.ax,p.z-edge.az
    return dx*edge.ux+dz*edge.uz,dx*edge.nx+dz*edge.nz
end
-- The captured selected members are WORLD-relative to the actual root.
-- Do not rotate implements as though their articulation were rigid.
local function rectangles(foot,p)
    local boxes={}
    for m=1,foot.memberCount do
        local box={}
        for _,i in ipairs({1,2,4,3}) do
            local v=foot.corners[(m-1)*4+i]
            box[#box+1]={x=p.x+v.x,z=p.z+v.z}
        end
        boxes[#boxes+1]=box
    end
    return boxes
end
local function safe(s,p)
    local edge=s.edge
    local station,depth=coordinates(p,edge)
    -- The forward step is not a parking terminal. A selected-member
    -- corner may STILL intersect the field or pass beyond the edge
    -- station while the assembly is clearing. Never use that fact alone
    -- to prohibit the intermediate movement.
    if station< -TARGET_M or station>edge.length+TARGET_M
        or (not G.inside(s.poly,p.x,p.z)
            and (depth<0 or depth>EXTERIOR_ROOT_LIMIT_M)) then
        return false,"BOUNDARY_STEP_ROOT_OUTSIDE_LOCAL_CORRIDOR"
    end
    if not Occupancy.clear(p,s.own,s.occupants) then
        return false,"BOUNDARY_STEP_OTHER_ASSEMBLY_OCCUPIED"
    end
    local boxes=rectangles(s.foot,p)
    for _,box in ipairs(boxes) do
        for _,neighbor in ipairs(s.neighbors) do
            if Assessment.shapeIntersectsPolygon(box,neighbor.polygon)~=false then
                return false,"BOUNDARY_STEP_NEIGHBOR_FIELD"
            end
        end
    end
    return true
end
local function sceneClear(s,target)
    local situation,why=Situation.observe(s.vehicle,s.poly)
    if situation==nil then return false,why end
    for _,peer in ipairs(situation.peers or {}) do
        if Situation.risk(target,peer)>=3 then
            return false,"BOUNDARY_STEP_PRODUCTIVE_DEMAND"
        end
    end
    return true
end
function M.beginPlan(vehicle,sourceField,edgeIndex)
    if type(vehicle)~="table" or type(sourceField)~="table" then
        return nil,"BOUNDARY_STEP_CONTEXT_UNAVAILABLE"
    end
    return {vehicle=vehicle,sourceField=sourceField,edgeIndex=edgeIndex,
        phase="INIT",advances=0,spent=0,candidates=0,reasonCounts={}}
end
local function rejected(s,reason)
    local key=reason or "BOUNDARY_STEP_NOT_QUALIFIED"
    s.reasonCounts[key]=(s.reasonCounts[key] or 0)+1
end
function M.advancePlan(s,units)
    if type(s)~="table" or s.finished
        or type(units)~="number" or units<24 or units>2048 then
        return "FAILED",nil,"BOUNDARY_STEP_SESSION_INVALID"
    end
    s.advances=s.advances+1
    if s.phase=="INIT" then
        local observed,why=Membership.assess(s.vehicle,s.sourceField)
        if observed==nil then s.finished=true;return "FAILED",nil,why end
        if observed.status~="STRADDLING" then
            s.finished=true;return "FAILED",nil,"BOUNDARY_STEP_NOT_STRADDLING"
        end
        local ctx,ctxWhy=Parking.enumerate(s.sourceField,s.vehicle)
        local foot,footWhy=OuttaMyWay.PairTransitRegion.capture(s.vehicle)
        local root=pose(s.vehicle)
        if ctx==nil or foot==nil or root==nil then
            s.finished=true
            return "FAILED",nil,ctxWhy or footWhy or "BOUNDARY_STEP_POSE_UNAVAILABLE"
        end
        if type(foot.corners)~="table" or type(foot.memberCount)~="number"
            or foot.memberCount<1 or #foot.corners~=foot.memberCount*4 then
            s.finished=true
            return "FAILED",nil,"BOUNDARY_STEP_MEMBER_GEOMETRY_UNAVAILABLE"
        end
        local scene,sceneWhy=Occupancy.snapshot(s.vehicle,ctx.poly)
        if scene==nil then s.finished=true;return "FAILED",nil,sceneWhy end
        local own=Occupancy.footRadius(s.vehicle)
        if not finite(own) then
            s.finished=true;return "FAILED",nil,"BOUNDARY_STEP_FOOTPRINT_UNAVAILABLE"
        end
        s.poly,s.neighbors,s.fieldId=ctx.poly,ctx.neighbors,ctx.fieldId
        s.initial,s.foot,s.own,s.occupants=root,foot,own,scene
        s.edges={}
        for _,edge in ipairs(ctx.frames) do
            if s.edgeIndex==nil or s.edgeIndex==edge.index then
                s.edges[#s.edges+1]=edge
            end
        end
        if #s.edges==0 then
            s.finished=true;return "FAILED",nil,"BOUNDARY_STEP_EDGE_UNAVAILABLE"
        end
        s.edgeCursor=1;s.sample=1;s.phase="CHECK"
        return "PENDING"
    end
    -- Screen the required 2m travel, native arrival target and possible
    -- 0.75m run-out. No terminal member-CLEAR gate at intermediate points.
    for _=1,math.min(4,math.floor(units/80)) do
        local edge=s.edges[s.edgeCursor]
        if edge==nil then
            s.finished=true
            return "FAILED",nil,"NO_QUALIFIED_BOUNDARY_CLEARANCE_STEP"
        end
        s.edge=edge
        local tested=forward(s.initial,SAMPLES[s.sample])
        s.spent=s.spent+80;s.candidates=s.candidates+1
        local clear,why=safe(s,tested)
        if not clear then
            rejected(s,why)
            s.edgeCursor=s.edgeCursor+1;s.sample=1
        elseif s.sample<#SAMPLES then
            s.sample=s.sample+1
        else
            local target=forward(s.initial,TARGET_M)
            local supported,sceneWhy=sceneClear(s,target)
            if not supported then
                rejected(s,sceneWhy)
                s.edgeCursor=s.edgeCursor+1;s.sample=1
            else
                local now=pose(s.vehicle)
                if now==nil
                    or (now.x-s.initial.x)^2+(now.z-s.initial.z)^2>0.04
                    or now.fx*s.initial.fx+now.fz*s.initial.fz
                        <math.cos(1*math.pi/180) then
                    s.finished=true
                    return "FAILED",nil,"BOUNDARY_STEP_START_POSE_CHANGED"
                end
                s.finished=true
                return "DONE",{
                    mode="BOUNDARY_CLEARANCE_STEP",
                    field=s.fieldId,edge=edge.index,
                    poly=s.poly,neighbors=s.neighbors,frame=edge,
                    memberCount=s.foot.memberCount,
                    method="OBSERVED_STRADDLING_FORWARD_2M",
                    reverseM=0,estimatedTravelM=TARGET_M,
                    requiredForwardM=MIN_FORWARD_M,
                    nominalStepM=TARGET_M,
                    stepOrigin=s.initial,
                    -- For existing temporary exclusive stop-region claim:
                    -- this is NOT a certified parking terminal.
                    terminalPose=target,
                    terminalArrivalRadiusM=ARRIVAL_M,
                    legs={{name="BOUNDARY_CLEARANCE_FORWARD",
                        point={x=target.x,z=target.z},
                        moveForwards=true,arrivalRadiusM=ARRIVAL_M}}
                }
            end
        end
    end
    return "PENDING"
end
function M.guard(vehicle,route)
    if type(route)~="table" or route.mode~="BOUNDARY_CLEARANCE_STEP"
        or type(route.stepOrigin)~="table" then
        return false,"BOUNDARY_STEP_GUARD_UNAVAILABLE"
    end
    local current=pose(vehicle)
    local foot=OuttaMyWay.PairTransitRegion.capture(vehicle)
    if current==nil or foot==nil
        or foot.memberCount~=route.memberCount then
        return false,"BOUNDARY_STEP_ACTUAL_MEMBERS_UNAVAILABLE"
    end
    local travelled=(current.x-route.stepOrigin.x)*route.stepOrigin.fx+
        (current.z-route.stepOrigin.z)*route.stepOrigin.fz
    local lateral=math.abs((current.x-route.stepOrigin.x)*route.stepOrigin.fz-
        (current.z-route.stepOrigin.z)*route.stepOrigin.fx)
    if travelled< -0.5 or travelled>TARGET_M+ARRIVAL_M+0.5
        or lateral>1.5
        or current.fx*route.stepOrigin.fx+
            current.fz*route.stepOrigin.fz<math.cos(HEADING_DRIFT_RAD) then
        return false,"BOUNDARY_STEP_PHYSICAL_TRAJECTORY_DIVERGED"
    end
    local scene,why=Occupancy.snapshot(vehicle,route.poly)
    if scene==nil then return false,why end
    local edge=route.frame
    return safe({poly=route.poly,neighbors=route.neighbors,
        edge=edge,foot=foot,
        own=Occupancy.footRadius(vehicle),occupants=scene},current)
end
return M
