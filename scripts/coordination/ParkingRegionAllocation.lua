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
local Extended=OuttaMyWay.ExtendedInfieldApproach
local Situation=OuttaMyWay.SettlementDestinationAssessment
local Parking=OuttaMyWay.CompletionParkingGeometry
local Membership=OuttaMyWay.CompletionFieldMembership
local MIN_TERMINAL_MARGIN_M=3
local MIN_STATION_SPACING_M=20
-- Counts are collected only when the caller enables the one-shot
-- diagnostic. They do not participate in candidate qualification.
local function rejected(s,bucket,reason,amount)
    local evidence=s.evidence
    if evidence==nil then return end
    local counts=evidence[bucket]
    local key=tostring(reason or "UNSPECIFIED")
    counts[key]=(counts[key] or 0)+(amount or 1)
end
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
-- A terminal is claimable only after proving the complete route from
-- the actual completed assembly pose, not a hypothetical local entry alone.
function M.qualifiedResult(s,approach,direct)
    local route=s.qualifiedLocalRoute
    local latest=s.latestSituation
    return {entryPose=s.site.entry,
        station=s.site.station,terminalPose=route.terminalPose,
        stationMin=math.max(3,s.site.station-26),
        stationMax=math.min(s.site.frame.length-3,s.site.station+26),
        sourceField=s.sourceField,field=s.fieldId,edge=s.site.edgeIndex,
        qualifiedLocalRoute=route,
        qualifiedApproachRoute=approach,qualifiedDirectRoute=direct,
        ownRadius=s.own,
        situationRisk=s.terminalRisk,situationReason=s.terminalReason,
        workingPeers=latest.workingCount,motionWitnesses=latest.motionCount,
        headingWitnesses=latest.headingCount,
        edgeEvidence=s.edgeEvidence,selectionCost=s.site.score,
        claimObstacles=claimObstacles(s.ledger,s.vehicle)}
end
function M.beginPlan(vehicle,ledger,sourceField,disposition,collectEvidence)
    if type(vehicle)~="table" or type(ledger)~="table" then
        return nil,"ALLOCATION_INPUT_UNAVAILABLE"
    end
    local session={vehicle=vehicle,ledger=ledger,sourceField=sourceField,
        disposition=disposition or "INSIDE",phase="INIT",
        spent=0,advances=0,siteIndex=0}
    if collectEvidence==true then
        session.evidence={sitesTotal=0,sitesExamined=0,
            localPlans=0,localCandidates=0,localFeasible=0,
            approachPlans=0,approachConnected=0,
            siteRejections={},routeRejections={}}
    end
    return session
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
            -- Candidate stations span the *actual* edge. The previous
            -- 20+25m*8 stations examined only the first 195 metres,
            -- excluding usable portions of longer edges by construction.
            local margin=math.max(MIN_TERMINAL_MARGIN_M,math.min(own+1,
                f.length*0.25))
            local available=f.length-2*margin
            if available>0 then
                -- Sampling density follows actual edge length and the
                -- represented assembly, not a fixed first-N site quota.
                local spacing=math.max(MIN_STATION_SPACING_M,own*2)
                local stations=math.max(1,math.ceil(available/spacing))
                for j=1,stations do
                    local station=margin+available*(j-0.5)/stations
                    local candidate=entry(f,station)
                    local dx,dz=p.x-candidate.x,p.z-candidate.z
                    sorted[#sorted+1]={edgeIndex=f.index,frame=f,
                        station=station,entry=candidate,
                        score=math.sqrt(dx*dx+dz*dz)}
                end
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
        if s.evidence~=nil then s.evidence.sitesTotal=#ranked end
        s.phase="NEXT"
        s.spent=s.spent+1
        return "PENDING"
    end
    if s.phase=="NEXT" then
        if s.siteIndex>=#s.sites then
            s.finished=true
            return "FAILED",nil,"NO_QUALIFIED_TERMINAL_REGION"
        end
        s.siteIndex=s.siteIndex+1
        if s.evidence~=nil then
            s.evidence.sitesExamined=s.evidence.sitesExamined+1
        end
        local site=s.sites[s.siteIndex]
        local f=site.frame
        -- Approximate outfield parking region only pre-screens the candidate;
        -- full polygon+physical stopping reserve is proven by Local planning.
        local parked={x=f.ax+f.ux*site.station+f.nx*4,
            z=f.az+f.uz*site.station+f.nz*4}
        -- A currently empty position is not operationally free if it
        -- intercepts a positively observed near-term work corridor.
        local refreshed,why=Situation.observe(s.vehicle,s.poly)
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
        -- Preserve the existing short-circuit qualification order,
        -- but retain the FIRST refusal for this site when enabled.
        local siteRefusal
        if newRisk>=3 then
            siteRefusal="WORKER_CORRIDOR_RISK"
        elseif not Occupancy.clear(parked,s.own,s.occupants,6) then
            siteRefusal="TERMINAL_PHYSICAL_OCCUPANCY"
        elseif not clearClaims(s.ledger,s.vehicle,parked,s.own+5) then
            siteRefusal="TERMINAL_CLAIM_CONFLICT"
        elseif not Occupancy.clear(site.entry,s.own,s.occupants) then
            siteRefusal="ENTRY_PHYSICAL_OCCUPANCY"
        end
        if siteRefusal~=nil then
            rejected(s,"siteRejections",siteRefusal)
            s.spent=s.spent+1
            return "PENDING"
        end
        -- A straddling assembly needs an actual-pose local egress;
        -- an imagined infield entry is not a connected route.
        local options={entryPose=site.entry,sourceField=s.sourceField,
            edgeIndex=site.edgeIndex,
            stationMin=math.max(3,site.station-26),
            stationMax=math.min(f.length-3,site.station+26),
            claimObstacles=claimObstacles(s.ledger,s.vehicle)}
        if s.disposition=="STRADDLING" then options.entryPose=nil end
        local session,why=Local.beginPlan(s.vehicle,options)
        if session==nil then
            rejected(s,"siteRejections",
                "LOCAL_SESSION_"..tostring(why))
            s.finished=true;return "FAILED",nil,why
        end
        if s.evidence~=nil then
            s.evidence.localPlans=s.evidence.localPlans+1
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
        if s.evidence~=nil then
            s.evidence.localCandidates=s.evidence.localCandidates+
                (s.localPlan.candidates or 0)
            for cause,count in pairs(s.localPlan.rejectionCounts or {}) do
                rejected(s,"routeRejections",cause,count)
            end
        end
        local terminal=phase=="DONE" and route and route.terminalPose
        local claimAvailable=terminal
            and clearClaims(s.ledger,s.vehicle,terminal,s.own+5)
        local occupiedClear=claimAvailable
            and Occupancy.clear(terminal,s.own,s.occupants,5)
        if occupiedClear then
            if s.evidence~=nil then
                s.evidence.localFeasible=s.evidence.localFeasible+1
            end
            local latest,latestWhy=Situation.observe(s.vehicle,s.poly)
            if latest==nil then
                s.finished=true;return "FAILED",nil,latestWhy
            end
            local risk,riskReason=0,#latest.peers>0
                and "NO_NEAR_DEMAND_EVIDENCE" or "NO_ACTIVE_WORKER"
            for i=1,#latest.peers do
                local candidate,reason=Situation.risk(
                    route.terminalPose,latest.peers[i])
                if candidate>risk then risk,riskReason=candidate,reason end
            end
            if risk<3 then
                s.qualifiedLocalRoute=route
                s.latestSituation=latest
                s.terminalRisk=risk
                s.terminalReason=riskReason
                if s.disposition=="STRADDLING" then
                    -- This local route already starts at the current actual
                    -- pose. No imagined return to infield space is required.
                    s.finished=true
                    return "DONE",M.qualifiedResult(s,nil,route)
                end
                local approach,reason=Extended.beginPlan(s.vehicle,
                    s.site.entry,s.sourceField,s.site.edgeIndex)
                if approach~=nil then
                    if s.evidence~=nil then
                        s.evidence.approachPlans=s.evidence.approachPlans+1
                    end
                    s.approachPlan=approach
                    s.phase="CONNECT"
                    return "PENDING"
                end
                rejected(s,"siteRejections",
                    "APPROACH_SESSION_"..tostring(reason))
            else
                rejected(s,"siteRejections","TERMINAL_WORKER_RISK")
            end
        else
            rejected(s,"siteRejections",
                not terminal and ("LOCAL_ROUTE_"..tostring(why or "NO_TERMINAL"))
                or not claimAvailable and "LOCAL_TERMINAL_CLAIM"
                or "LOCAL_TERMINAL_OCCUPIED")
        end
        s.prevSpent=nil;s.localPlan=nil;s.phase="NEXT"
        return "PENDING"
    end
    if s.phase=="CONNECT" then
        -- Qualification includes the actual root-to-entry path BEFORE
        -- an exclusive terminal claim. Continue within per-frame budget.
        local phase,approach,why=Extended.advancePlan(s.approachPlan,units)
        s.spent=s.spent+(s.approachPlan.spent-(s.prevApproachSpent or 0))
        s.prevApproachSpent=s.approachPlan.spent
        if phase=="PENDING" then return "PENDING" end
        if phase=="DONE" and approach then
            if s.evidence~=nil then
                s.evidence.approachConnected=s.evidence.approachConnected+1
            end
            s.finished=true
            return "DONE",M.qualifiedResult(s,approach,nil)
        end
        -- This terminal was locally feasible from an imaginary entry
        -- but unreachable from actual completion pose: reject and try next.
        rejected(s,"siteRejections",
            "APPROACH_CONNECT_"..tostring(why or "NO_ROUTE"))
        s.prevSpent=nil;s.prevApproachSpent=nil
        s.localPlan=nil;s.approachPlan=nil
        s.qualifiedLocalRoute=nil;s.phase="NEXT"
        return "PENDING"
    end
    s.finished=true
    return "FAILED",nil,"ALLOCATION_PHASE_INVALID"
end
return M
