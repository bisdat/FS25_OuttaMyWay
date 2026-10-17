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
local Situation=OuttaMyWay.SettlementDestinationAssessment
local Parking=OuttaMyWay.CompletionParkingGeometry
local Membership=OuttaMyWay.CompletionFieldMembership
local MAX_SITES=64
local MAX_SITES_PER_EDGE=8
local STATION_START_M=20
local STATION_STEP_M=25
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
    -- Reserve endpoint uncertainty as well as the physical footprint:
    -- the actual stopped root may differ from the nominal local guide.
    ledger[vehicle]={x=terminal.x,z=terminal.z,
        radius=ownRadius+14,rootNode=vehicle.rootNode}
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
function M.matchesClaim(ledger,vehicle,route)
    local claim=M.claimCurrent(ledger,vehicle)
    local destination=route and route.terminalPose
    if claim==nil or type(destination)~="table" then
        return false,"QUALIFIED_TERMINAL_EVIDENCE_MISSING"
    end
    local dx,dz=destination.x-claim.x,destination.z-claim.z
    if dx*dx+dz*dz>8*8 then
        return false,"LOCAL_ROUTE_MISSES_CLAIMED_TERMINAL"
    end
    return true
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
function M.beginPlan(vehicle,ledger,sourceField)
    if type(vehicle)~="table" or type(ledger)~="table" then
        return nil,"ALLOCATION_INPUT_UNAVAILABLE"
    end
    return {vehicle=vehicle,ledger=ledger,sourceField=sourceField,phase="INIT",
        spent=0,advances=0,siteIndex=0}
end
function M.advancePlan(s,units)
    if type(s)~="table" or s.finished or type(units)~="number"
        or units<24 or units>2048 then
        return "FAILED",nil,"ALLOCATION_SESSION_INVALID"
    end
    s.advances=s.advances+1
    if s.phase=="INIT" then
        local source=s.sourceField
        if source==nil then
            local why
            source,why=Membership.identify(s.vehicle)
            if source==nil then
                s.finished=true;return "FAILED",nil,why
            end
        end
        local context,why=Parking.enumerate(source,s.vehicle)
        if context==nil then s.finished=true;return "FAILED",nil,why end
        s.sourceField=source
        local poly=context.poly
        local p=position(s.vehicle)
        if p==nil then
            s.finished=true;return "FAILED",nil,"ALLOCATION_ROOT_POSE_UNAVAILABLE"
        end
        local own=Occupancy.footRadius(s.vehicle)
        local occupants,occupiedWhy=Occupancy.snapshot(s.vehicle,poly)
        if occupants==nil then
            s.finished=true;return "FAILED",nil,occupiedWhy
        end
        if own==nil then
            s.finished=true;return "FAILED",nil,"ALLOCATION_OWN_FOOTPRINT_UNKNOWN"
        end
        local situation,situationWhy=Situation.observe(s.vehicle,poly)
        if situation==nil then
            s.finished=true
            return "FAILED",nil,situationWhy or "DESTINATION_SITUATION_UNAVAILABLE"
        end
        s.poly,s.own,s.occupants=poly,own,occupants
        s.situation=situation
        s.fieldId=context.fieldId
        s.edgeEvidence=Situation.edgeEvidence(poly)
        local sorted={}
        for _,f in ipairs(context.frames) do
            local stations=0
            for station=STATION_START_M,f.length-STATION_START_M,STATION_STEP_M do
                if stations>=MAX_SITES_PER_EDGE then break end
                stations=stations+1
                local candidate=entry(f,station)
                local dx,dz=p.x-candidate.x,p.z-candidate.z
                sorted[#sorted+1]={edgeIndex=f.index,frame=f,
                    station=station,entry=candidate,
                    score=math.sqrt(dx*dx+dz*dz)}
            end
        end
        if #sorted==0 then
            s.finished=true;return "FAILED",nil,"NO_EDGE_ENTRY_STATIONS"
        end
        local ranked,why=Situation.rank(sorted,p,nil,situation)
        if ranked==nil then
            s.finished=true;return "FAILED",nil,why
        end
        s.sites=ranked
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
        local f=site.frame
        -- Approximate outfield parking region only pre-screens the candidate;
        -- full polygon+physical stopping reserve is proven by Local planning.
        local parked={x=f.ax+f.ux*site.station+f.nx*4,
            z=f.az+f.uz*site.station+f.nz*4}
        -- A currently empty position is not operationally free if it
        -- intercepts a positively observed near-term work corridor.
        local refreshed,why=Situation.observe(s.vehicle,poly)
        if refreshed==nil then
            s.finished=true;return "FAILED",nil,why
        end
        local newRisk,newReason=0,#refreshed.peers>0
            and "NO_NEAR_DEMAND_EVIDENCE" or "NO_ACTIVE_WORKER"
        for i=1,#refreshed.peers do
            local risk,reason=Situation.risk(parked,refreshed.peers[i])
            if risk>newRisk then newRisk,newReason=risk,reason end
        end
        site.peerRisk=newRisk
        site.peerRiskReason=newReason
        if newRisk>=3
            or not Occupancy.clear(parked,s.own,s.occupants,6)
            or not clearClaims(s.ledger,s.vehicle,parked,s.own+5)
            or not Occupancy.clear(site.entry,s.own,s.occupants) then
            s.spent=s.spent+1
            return "PENDING"
        end
        local options={entryPose=site.entry,sourceField=s.sourceField,
            edgeIndex=site.edgeIndex,
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
            local latest,latestWhy=Situation.observe(s.vehicle,s.poly)
            if latest==nil then
                s.finished=true;return "FAILED",nil,latestWhy
            end
            local terminalRisk,terminalReason=0,#latest.peers>0
                and "NO_NEAR_DEMAND_EVIDENCE" or "NO_ACTIVE_WORKER"
            for i=1,#latest.peers do
                local risk,reason=Situation.risk(route.terminalPose,latest.peers[i])
                if risk>terminalRisk then
                    terminalRisk,terminalReason=risk,reason
                end
            end
            if terminalRisk>=3 then
                s.prevSpent=nil;s.localPlan=nil;s.phase="NEXT"
                return "PENDING"
            end
            s.finished=true
            return "DONE",{entryPose=s.site.entry,
                station=s.site.station,terminalPose=route.terminalPose,
                stationMin=math.max(3,s.site.station-26),
                stationMax=math.min(s.site.frame.length-3,s.site.station+26),
                sourceField=s.sourceField,field=s.fieldId,
                edge=s.site.edgeIndex,
                qualifiedLocalRoute=route,
                ownRadius=s.own,
                situationRisk=terminalRisk,
                situationReason=terminalReason,
                workingPeers=latest.workingCount,
                motionWitnesses=latest.motionCount,
                headingWitnesses=latest.headingCount,
                edgeEvidence=s.edgeEvidence,
                selectionCost=s.site.score,
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
