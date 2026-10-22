-- Bounded forward-only Boundary Exit Continuation from an observed STRADDLING pose.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- Pure qualification: no GIANTS Control, no terminal claim, no success assertion.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionBoundaryExitContinuation={}
local M=OuttaMyWay.CompletionBoundaryExitContinuation
local Parking=OuttaMyWay.CompletionParkingGeometry
local Membership=OuttaMyWay.CompletionAssemblyFieldOccupancy
local G=OuttaMyWay.FarmEdgeGeometry
local Assessment=OuttaMyWay.SettlementCorridorAssessment
local Occupancy=OuttaMyWay.SettlementPhysicalOccupancy
local Situation=OuttaMyWay.SettlementDestinationAssessment
local MAX_FORWARD_M=12
local SAMPLE_M=1
local FINAL_RADIUS_M=0.75
local MAX_STEPS_PER_ADVANCE=4
local DEPTH_MAX_M=12
local STOP_RESERVE_M=5
local RAD=math.pi/180
local function finite(x)
    return type(x)=="number" and x==x and x~=math.huge and x~=-math.huge
end
local function pose(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function"
        or type(localDirectionToWorld)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    local direction,fx,_,fz=pcall(localDirectionToWorld,
        vehicle.rootNode,0,0,1)
    if not ok or not direction or not finite(x) or not finite(z)
        or not finite(fx) or not finite(fz) then return nil end
    local norm=math.sqrt(fx*fx+fz*fz)
    if norm<0.001 then return nil end
    return {x=x,z=z,fx=fx/norm,fz=fz/norm}
end
local function project(p,edge)
    local x,z=p.x-edge.ax,p.z-edge.az
    return x*edge.ux+z*edge.uz,x*edge.nx+z*edge.nz
end
local function forward(p,metres)
    return {x=p.x+p.fx*metres,z=p.z+p.fz*metres,
        fx=p.fx,fz=p.fz}
end
-- The selected-member world offsets are read from the actual stopped
-- assembly. No fabricated hitch angle or imagined entry is permitted.
local function rectangles(foot,p)
    local boxes={}
    for member=1,foot.memberCount do
        local rect={}
        for _,i in ipairs({1,2,4,3}) do
            local corner=foot.corners[(member-1)*4+i]
            rect[#rect+1]={x=p.x+corner.x,z=p.z+corner.z}
        end
        boxes[#boxes+1]=rect
    end
    return boxes
end
local function safe(s,edge,p,terminal)
    local station,depth=project(p,edge)
    if station<2 or station>edge.length-2
        or depth>DEPTH_MAX_M then return false,"BOUNDARY_EXIT_CORRIDOR" end
    if not G.inside(s.poly,p.x,p.z) and depth<0 then
        return false,"BOUNDARY_EXIT_EXTERIOR_BAND"
    end
    if not Occupancy.clear(p,s.own,s.occupants) then
        return false,"BOUNDARY_EXIT_PHYSICAL_OCCUPANCY"
    end
    local boxes=rectangles(s.foot,p)
    for _,box in ipairs(boxes) do
        for _,neighbor in ipairs(s.neighbors) do
            if Assessment.shapeIntersectsPolygon(box,neighbor.polygon)~=false then
                return false,"BOUNDARY_EXIT_NEIGHBOR_FIELD"
            end
        end
        for _,corner in ipairs(box) do
            local longitudinal,exterior=project(corner,edge)
            if longitudinal<1 or longitudinal>edge.length-1
                or exterior>DEPTH_MAX_M then
                return false,"BOUNDARY_EXIT_MEMBER_OUTSIDE_CORRIDOR"
            end
        end
        if terminal then
            if Assessment.shapeIntersectsPolygon(box,s.poly)~=false then
                return false,"BOUNDARY_EXIT_MEMBER_STILL_IN_SOURCE"
            end
            for _,corner in ipairs(box) do
                local _,exterior=project(corner,edge)
                if exterior<0.15 then
                    return false,"BOUNDARY_EXIT_MEMBER_NOT_IN_EXTERIOR_MARGIN"
                end
            end
        end
    end
    if terminal then
        if G.inside(s.poly,p.x,p.z) or depth<0 or depth>DEPTH_MAX_M then
            return false,"BOUNDARY_EXIT_ROOT_STILL_IN_SOURCE"
        end
        if math.abs(p.fx*edge.ux+p.fz*edge.uz)
            <math.cos(15*RAD) then
            return false,"BOUNDARY_EXIT_HEADING_NOT_EDGE_ALIGNED"
        end
    end
    return true
end
local DIAGONAL=math.sqrt(0.5)
local arrivalSamples={
    {-1,0},{1,0},{0,-1},{0,1},
    {-DIAGONAL,-DIAGONAL},{-DIAGONAL,DIAGONAL},
    {DIAGONAL,-DIAGONAL},{DIAGONAL,DIAGONAL}
}
local function goalClear(s,edge,p)
    local yes,why=safe(s,edge,p,true)
    if not yes then return false,why end
    for _,direction in ipairs(arrivalSamples) do
        local sample={x=p.x+direction[1]*FINAL_RADIUS_M,
            z=p.z+direction[2]*FINAL_RADIUS_M,
            fx=p.fx,fz=p.fz}
        yes,why=safe(s,edge,sample,true)
        if not yes then return false,why end
    end
    return safe(s,edge,forward(p,STOP_RESERVE_M),true)
end
local function connected(s,edge,distance)
    local final=forward(s.initial,distance)
    local yes,why=goalClear(s,edge,final)
    if not yes then return nil,why end
    local situation,whyScene=Situation.observe(s.vehicle,s.poly)
    if situation==nil then return nil,whyScene end
    for _,peer in ipairs(situation.peers) do
        if Situation.risk(final,peer)>=3 then
            return nil,"BOUNDARY_EXIT_PRODUCTIVE_DEMAND"
        end
    end
    local legs={}
    for metre=2,distance,2 do
        local p=forward(s.initial,metre)
        legs[#legs+1]={name="BOUNDARY_EXIT_FORWARD",
            point={x=p.x,z=p.z},moveForwards=true}
    end
    if distance%2~=0 then
        legs[#legs+1]={name="BOUNDARY_EXIT_FORWARD",
            point={x=final.x,z=final.z},moveForwards=true}
    end
    if #legs==0 then return nil,"BOUNDARY_EXIT_TOO_SHORT" end
    legs[#legs].arrivalRadiusM=FINAL_RADIUS_M
    return {mode="BOUNDARY_EXIT",field=s.fieldId,edge=edge.index,
        poly=s.poly,neighbors=s.neighbors,frame=edge,
        memberCount=s.foot.memberCount,
        method="ACTUAL_POSE_FORWARD_BOUNDARY_EXIT",
        reverseM=0,estimatedTravelM=distance,
        terminalArrivalRadiusM=FINAL_RADIUS_M,
        terminalPose=final,legs=legs,
        qualification="REAL_STRADDLING_FORWARD_SWEEP"}
end
function M.beginPlan(vehicle,sourceField,edgeIndex)
    if type(vehicle)~="table" or type(sourceField)~="table" then
        return nil,"BOUNDARY_EXIT_CONTEXT_UNAVAILABLE"
    end
    -- INIT is intentionally lazy; native job-completion callbacks must not
    -- perform registered-polygon geometry.
    return {vehicle=vehicle,sourceField=sourceField,edgeIndex=edgeIndex,
        phase="INIT",advances=0,spent=0,candidates=0,reasonCounts={}}
end
local function reject(s,reason)
    local key=tostring(reason or "BOUNDARY_EXIT_NO_CLEAR_TERMINAL")
    s.reasonCounts[key]=(s.reasonCounts[key] or 0)+1
end
function M.advancePlan(s,units)
    if type(s)~="table" or s.finished
        or type(units)~="number" or units<24 or units>2048 then
        return "FAILED",nil,"BOUNDARY_EXIT_SESSION_INVALID"
    end
    s.advances=s.advances+1
    if s.phase=="INIT" then
        local occupied,why=Membership.assess(s.vehicle,s.sourceField)
        if occupied==nil then
            s.finished=true;return "FAILED",nil,why end
        if occupied.status~="STRADDLING" then
            s.finished=true;return "FAILED",nil,"BOUNDARY_EXIT_NOT_STRADDLING"
        end
        local ctx,contextWhy=Parking.enumerate(s.sourceField,s.vehicle)
        local foot,footWhy=OuttaMyWay.PairTransitRegion.capture(s.vehicle)
        local initial=pose(s.vehicle)
        if ctx==nil or foot==nil or initial==nil then
            s.finished=true
            return "FAILED",nil,contextWhy or footWhy or "BOUNDARY_EXIT_POSE_UNAVAILABLE"
        end
        if type(foot.corners)~="table"
            or #foot.corners~=foot.memberCount*4 then
            s.finished=true
            return "FAILED",nil,"BOUNDARY_EXIT_MEMBERS_UNAVAILABLE"
        end
        local occupants,occWhy=Occupancy.snapshot(s.vehicle,ctx.poly)
        if occupants==nil then
            s.finished=true;return "FAILED",nil,occWhy end
        s.poly,s.neighbors,s.fieldId=ctx.poly,ctx.neighbors,ctx.fieldId
        s.foot,s.initial,s.own,s.occupants=
            foot,initial,Occupancy.footRadius(s.vehicle),occupants
        if not finite(s.own) then
            s.finished=true
            return "FAILED",nil,"BOUNDARY_EXIT_FOOTPRINT_UNAVAILABLE"
        end
        s.edges={}
        for _,edge in ipairs(ctx.frames) do
            if s.edgeIndex==nil or edge.index==s.edgeIndex then
                s.edges[#s.edges+1]=edge
            end
        end
        if #s.edges==0 then
            s.finished=true
            return "FAILED",nil,"BOUNDARY_EXIT_EDGE_UNAVAILABLE"
        end
        s.edgeCursor=1;s.metre=1;s.phase="CHECK"
        return "PENDING"
    end
    local steps=math.min(MAX_STEPS_PER_ADVANCE,math.floor(units/80))
    for _=1,steps do
        local edge=s.edges[s.edgeCursor]
        if edge==nil then
            s.finished=true
            return "FAILED",nil,"NO_QUALIFIED_BOUNDARY_EXIT_CONTINUATION"
        end
        local p=forward(s.initial,s.metre)
        local yes,why=safe(s,edge,p,false)
        s.candidates=s.candidates+1;s.spent=s.spent+80
        if not yes then
            reject(s,why)
            s.edgeCursor=s.edgeCursor+1;s.metre=1
        else
            if s.metre>=2 then
                local route,goalWhy=connected(s,edge,s.metre)
                if route then
                    local actual=pose(s.vehicle)
                    if actual==nil or
                        (actual.x-s.initial.x)^2+
                        (actual.z-s.initial.z)^2>0.04 or
                        actual.fx*s.initial.fx+
                        actual.fz*s.initial.fz<math.cos(1*RAD) then
                        s.finished=true
                        return "FAILED",nil,"BOUNDARY_EXIT_REAL_POSE_CHANGED"
                    end
                    s.finished=true
                    return "DONE",route
                end
                reject(s,goalWhy)
            end
            s.metre=s.metre+SAMPLE_M
            if s.metre>MAX_FORWARD_M then
                s.edgeCursor=s.edgeCursor+1;s.metre=1
            end
        end
    end
    return "PENDING"
end
return M
