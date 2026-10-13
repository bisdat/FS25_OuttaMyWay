-- Experimental Qualified Terminal Claim for Completion Settlement.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- This module performs incremental, non-actuating LOCAL feasibility checks
-- for several separate edge stations BEFORE extended infield navigation.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.ParkingRegionAllocation={}
local M=OuttaMyWay.ParkingRegionAllocation
local G=OuttaMyWay.FarmEdgeGeometry
local Occupancy=OuttaMyWay.SettlementPhysicalOccupancy
local Local=OuttaMyWay.CompletionSettlementRoute
local MAX_SITES=8
local EDGE_STATIONS={20,45,70,95,120,145,170,195}
local function finite(v)
    return type(v)=="number" and v==v and v~=math.huge and v~=-math.huge
end
local function position(vehicle)
    if vehicle==nil or vehicle.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,vehicle.rootNode)
    if ok and finite(x) and finite(z) then return {x=x,z=z} end
    return nil
end
local function fixture()
    local manager=g_fieldManager
    if type(manager)~="table" or type(manager.fields)~="table" then
        return nil,"ALLOCATION_FIELD_REGISTRY_UNAVAILABLE"
    end
    local field=manager.fields[77]
    if type(manager.getFieldById)=="function" then
        local ok,f=pcall(manager.getFieldById,manager,77)
        if ok and type(f)=="table" then field=f end
    end
    local poly=G.polygonFor(field)
    local edge=poly and G.edges(poly)[9]
    if edge==nil or math.abs(edge.length-230.97)>3 then
        return nil,"ALLOCATION_EDGE_9_UNAVAILABLE"
    end
    local nx,nz=G.outwardAt(poly,edge,
        (edge.ax+edge.bx)*.5,(edge.az+edge.bz)*.5)
    if nx==nil then return nil,"ALLOCATION_OUTWARD_UNAVAILABLE" end
    return {poly=poly,ax=edge.ax,az=edge.az,ux=edge.dx/edge.length,
        uz=edge.dz/edge.length,nx=nx,nz=nz,length=edge.length}
end
local function entry(f,station)
    return {x=f.ax+f.ux*station-f.nx*18,
        z=f.az+f.uz*station-f.nz*18,
        fx=-f.ux,fz=-f.uz}
end
local function claimObstacles(ledger,vehicle)
    local results={}
    for other,claim in pairs(ledger) do
        if other~=vehicle then
            results[#results+1]={x=claim.x,z=claim.z,
                radius=claim.radius}
        end
    end
    return results
end
local function clearClaims(ledger,vehicle,p,radius)
    for other,claim in pairs(ledger) do
        if other~=vehicle then
            local reach=radius+claim.radius+4
            local dx,dz=p.x-claim.x,p.z-claim.z
            if dx*dx+dz*dz<reach*reach then return false end
        end
    end
    return true
end
function M.release(ledger,vehicle)
    if type(ledger)=="table" then ledger[vehicle]=nil end
end
function M.claim(ledger,vehicle,terminal,ownRadius)
    if type(ledger)~="table" or type(terminal)~="table"
        or not finite(terminal.x) or not finite(terminal.z)
        or not finite(ownRadius) then
        return nil,"TERMINAL_CLAIM_EVIDENCE_UNAVAILABLE"
    end
    if not clearClaims(ledger,vehicle,terminal,ownRadius+5) then
        return nil,"TERMINAL_REGION_ALREADY_CLAIMED"
    end
    ledger[vehicle]={x=terminal.x,z=terminal.z,
        radius=ownRadius+5,rootNode=vehicle.rootNode}
    return ledger[vehicle]
end
function M.claimForRoute(ledger,vehicle,route)
    local target=route.terminalPose or
        (route.legs and route.legs[#route.legs] and
            route.legs[#route.legs].point)
    return M.claim(ledger,vehicle,target,Occupancy.footRadius(vehicle))
end
function M.claimCurrent(ledger,vehicle)
    return type(ledger)=="table" and ledger[vehicle] or nil
end
function M.claimClear(ledger,vehicle,poly)
    local claim=M.claimCurrent(ledger,vehicle)
    if claim==nil then return false,"TERMINAL_CLAIM_MISSING" end
    local scene,why=Occupancy.snapshot(vehicle,poly)
    if scene==nil then return false,why end
    local own=Occupancy.footRadius(vehicle)
    if own==nil then return false,"TERMINAL_CLAIM_FOOTPRINT_UNKNOWN" end
    if not Occupancy.clear({x=claim.x,z=claim.z},own,scene,5) then
        return false,"TERMINAL_CLAIM_OCCUPIED"
    end
    if not clearClaims(ledger,vehicle,claim,claim.radius) then
        return false,"TERMINAL_CLAIM_CONFLICT"
    end
    return true
end
function M.beginPlan(vehicle,ledger)
    if type(vehicle)~="table" or type(ledger)~="table" then
        return nil,"ALLOCATION_INPUT_UNAVAILABLE"
    end
    return {vehicle=vehicle,ledger=ledger,phase="INIT",
        spent=0,advances=0,siteIndex=0}
end
function M.advancePlan(s,units)
    if type(s)~="table" or s.finished or type(units)~="number"
        or units<24 or units>2048 then
        return "FAILED",nil,"ALLOCATION_SESSION_INVALID"
    end
    s.advances=s.advances+1
    if s.phase=="INIT" then
        local f,why=fixture()
        if f==nil then s.finished=true;return "FAILED",nil,why end
        local p=position(s.vehicle)
        if p==nil then
            s.finished=true;return "FAILED",nil,"ALLOCATION_ROOT_POSE_UNAVAILABLE"
        end
        local own=Occupancy.footRadius(s.vehicle)
        local occupants,occupiedWhy=Occupancy.snapshot(s.vehicle,f.poly)
        if occupants==nil then
            s.finished=true;return "FAILED",nil,occupiedWhy
        end
        if own==nil then
            s.finished=true;return "FAILED",nil,"ALLOCATION_OWN_FOOTPRINT_UNKNOWN"
        end
        s.frame,s.own,s.occupants=f,own,occupants
        local sorted={}
        for i=1,#EDGE_STATIONS do
            local station=EDGE_STATIONS[i]
            local candidate=entry(f,station)
            local dx,dz=p.x-candidate.x,p.z-candidate.z
            sorted[#sorted+1]={station=station,entry=candidate,
                score=math.sqrt(dx*dx+dz*dz)}
        end
        table.sort(sorted,function(a,b)
            if a.score==b.score then return a.station<b.station end
            return a.score<b.score
        end)
        s.sites=sorted
        s.phase="NEXT"
        s.spent=s.spent+1
        return "PENDING"
    end
    if s.phase=="NEXT" then
        if s.siteIndex>=math.min(MAX_SITES,#s.sites) then
            s.finished=true
            return "FAILED",nil,"NO_QUALIFIED_TERMINAL_REGION"
        end
        s.siteIndex=s.siteIndex+1
        local site=s.sites[s.siteIndex]
        local f=s.frame
        -- Approximate outfield parking region only pre-screens the candidate;
        -- full polygon+physical stopping reserve is proven by Local planning.
        local parked={x=f.ax+f.ux*site.station+f.nx*4,
            z=f.az+f.uz*site.station+f.nz*4}
        if not Occupancy.clear(parked,s.own,s.occupants,6)
            or not clearClaims(s.ledger,s.vehicle,parked,s.own+5)
            or not Occupancy.clear(site.entry,s.own,s.occupants) then
            s.spent=s.spent+1
            return "PENDING"
        end
        local options={entryPose=site.entry,
            stationMin=math.max(3,site.station-26),
            stationMax=math.min(f.length-3,site.station+26),
            claimObstacles=claimObstacles(s.ledger,s.vehicle)}
        local session,why=Local.beginPlan(s.vehicle,options)
        if session==nil then
            s.finished=true;return "FAILED",nil,why
        end
        s.localPlan=session
        s.site=site
        s.phase="QUALIFY"
        return "PENDING"
    end
    if s.phase=="QUALIFY" then
        local phase,route,why=Local.advancePlan(s.localPlan,units)
        s.spent=s.spent+(s.localPlan.spent-(s.prevSpent or 0))
        s.prevSpent=s.localPlan.spent
        if phase=="PENDING" then return "PENDING" end
        if phase=="DONE" and route and route.terminalPose
            and clearClaims(s.ledger,s.vehicle,route.terminalPose,
                s.own+5)
            and Occupancy.clear(route.terminalPose,s.own,s.occupants,5) then
            s.finished=true
            return "DONE",{entryPose=s.site.entry,
                station=s.site.station,terminalPose=route.terminalPose,
                stationMin=math.max(3,s.site.station-26),
                stationMax=math.min(s.frame.length-3,s.site.station+26),
                qualifiedLocalRoute=route,
                ownRadius=s.own,
                claimObstacles=claimObstacles(s.ledger,s.vehicle)}
        end
        s.prevSpent=nil
        s.localPlan=nil
        s.phase="NEXT"
        return "PENDING"
    end
    s.finished=true
    return "FAILED",nil,"ALLOCATION_PHASE_INVALID"
end
return M
