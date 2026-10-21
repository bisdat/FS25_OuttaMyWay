-- Completion parking destination assessment from a stopped ACTUAL pose.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- No invented local entry, terminal claim or native movement authority.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.CompletionDestinationRouteAssessment={}
local M=OuttaMyWay.CompletionDestinationRouteAssessment
local Parking=OuttaMyWay.CompletionParkingGeometry
local Situation=OuttaMyWay.SettlementDestinationAssessment
local Local=OuttaMyWay.CompletionSettlementRoute
local G=OuttaMyWay.FarmEdgeGeometry
local PREFERRED_RESPONSE_CUTOFF_MS=17000

local function location(vehicle)
    if type(vehicle)~="table" or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if ok and type(x)=="number" and type(z)=="number"
        and x==x and z==z then return {x=x,z=z} end
    return nil
end

function M.beginPlan(vehicle,sourceField)
    local context,why=Parking.enumerate(sourceField,vehicle)
    if context==nil then return nil,why end
    local current=location(vehicle)
    if current==nil then return nil,"DESTINATION_ACTUAL_POSE_UNAVAILABLE" end
    local scene,reason=Situation.observe(vehicle,context.poly)
    if scene==nil then return nil,reason end
    local own=OuttaMyWay.SettlementPhysicalOccupancy.footRadius(vehicle)
    if type(own)~="number" then
        return nil,"DESTINATION_OWN_FOOTPRINT_UNAVAILABLE"
    end
    local sites={}
    for _,edge in ipairs(context.frames) do
        local margin=math.max(3,math.min(own+1,edge.length*0.25))
        local usable=edge.length-2*margin
        if usable>0 then
            local station=edge.length*0.5
            sites[#sites+1]={edgeIndex=edge.index,frame=edge,
                station=station,
                usableLongitudinalM=usable,
                -- This point is a read-only prioritisation witness. It is
                -- NOT supplied to the route planner as a starting pose.
                entry={x=edge.ax+edge.ux*station-edge.nx*18,
                    z=edge.az+edge.uz*station-edge.nz*18}}
        end
    end
    if #sites==0 then return nil,"DESTINATION_NO_ELIGIBLE_EDGE" end
    local ranked,rankWhy=Situation.rank(sites,current,nil,scene)
    if ranked==nil then return nil,rankWhy end
    local preferred,nearest={},context.frames[1].index
    local first=nil
    for _,site in ipairs(ranked) do
        if site.edgeIndex==nearest then first=site
        else preferred[#preferred+1]=site end
    end
    if first==nil then return nil,"DESTINATION_NEAREST_EDGE_UNAVAILABLE" end
    local order={first}
    for _,site in ipairs(preferred) do order[#order+1]=site end
    return {vehicle=vehicle,sourceField=sourceField,poly=context.poly,
        originalPose=current,order=order,nearestEdge=nearest,
        phase="NEXT",edgeIndex=0,spent=0,advances=0,
        examined=0,fullyQualified=0,provisional=nil,
        reasonCounts={}}
end

local function supported(route,plan)
    -- Local planning already screens nominal member envelopes and route
    -- terminal/run-out. Independent live demand is an additional veto.
    local situation,why=Situation.observe(plan.vehicle,plan.poly)
    if situation==nil then return false,why end
    for _,peer in ipairs(situation.peers) do
        local risk=Situation.risk(route.terminalPose,peer)
        if risk>=3 then return false,"DESTINATION_PRODUCTIVE_CORRIDOR_RISK" end
    end
    return true
end

local function rememberRefusal(plan,reason)
    local key=tostring(reason or "DESTINATION_NO_CONNECTED_ROUTE")
    plan.reasonCounts[key]=(plan.reasonCounts[key] or 0)+1
end

function M.advancePlan(plan,units,elapsedMs)
    if type(plan)~="table" or plan.finished
        or type(units)~="number" or units<24 or units>2048 then
        return "FAILED",nil,"DESTINATION_SESSION_INVALID"
    end
    plan.advances=plan.advances+1
    if plan.provisional~=nil
        and type(elapsedMs)=="number"
        and elapsedMs>=PREFERRED_RESPONSE_CUTOFF_MS then
        plan.finished=true
        return "DONE",plan.provisional
    end
    if plan.phase=="NEXT" then
        plan.edgeIndex=plan.edgeIndex+1
        local site=plan.order[plan.edgeIndex]
        -- A route already proven from the real pose is a safe fallback;
        -- only better-ranked destinations merit additional assessment.
        if site==nil
            or (plan.provisional~=nil
                and site.selectionRank>=plan.provisional.selectionRank) then
            plan.finished=true
            if plan.provisional~=nil then return "DONE",plan.provisional end
            return "FAILED",nil,"NO_ACTUAL_POSE_CONNECTED_DESTINATION"
        end
        local options={sourceField=plan.sourceField,edgeIndex=site.edgeIndex}
        if plan.edgeIndex>1 then
            -- Avoid exhaustive minimum-travel optimisation while probing
            -- alternatives; only FULLY qualified local routes may win.
            options.earliestQualified=true
        end
        local localPlan,why=Local.beginPlan(plan.vehicle,options)
        if localPlan==nil then
            rememberRefusal(plan,why)
            return "PENDING"
        end
        plan.active=localPlan
        plan.current=site
        plan.lastSpent=0
        plan.phase="QUALIFY"
        return "PENDING"
    end
    if plan.phase=="QUALIFY" then
        local state,route,why=Local.advancePlan(plan.active,units)
        local spent=plan.active.spent or 0
        plan.spent=plan.spent+math.max(0,spent-plan.lastSpent)
        plan.lastSpent=spent
        if state=="PENDING" then return "PENDING" end
        plan.examined=plan.examined+1
        if state=="DONE" and route~=nil then
            local sound,veto=supported(route,plan)
            if sound then
                plan.fullyQualified=plan.fullyQualified+1
                route.destinationSelectionRank=plan.current.selectionRank
                route.destinationUsableLongitudinalM=
                    plan.current.usableLongitudinalM
                route.destinationAssessment="ACTUAL_POSE_DIRECT"
                if plan.provisional==nil
                    or plan.current.selectionRank
                        <plan.provisional.selectionRank then
                    plan.provisional=route
                    plan.provisional.selectionRank=
                        plan.current.selectionRank
                end
                if plan.edgeIndex>1 then
                    plan.finished=true
                    return "DONE",route
                end
            else rememberRefusal(plan,veto) end
        else rememberRefusal(plan,why) end
        plan.active=nil
        plan.phase="NEXT"
        return "PENDING"
    end
    plan.finished=true
    return "FAILED",nil,"DESTINATION_PHASE_INVALID"
end

function M.priorityPreview(plan)
    local listed={}
    for i,site in ipairs(plan.order or {}) do
        listed[#listed+1]=tostring(site.edgeIndex)
            ..":rank"..tostring(site.selectionRank)
            ..":usable"..string.format("%.1f",
                site.usableLongitudinalM or 0)
            ..(i==1 and ":PROVISIONAL_FIRST" or "")
        if #listed>=16 then break end
    end
    return table.concat(listed,";")
end
return M
