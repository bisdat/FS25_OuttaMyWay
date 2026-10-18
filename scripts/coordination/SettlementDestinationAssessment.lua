-- Read-only Destination Situation Assessment for experimental completion.
-- Specification Jurisdictions: `COMPLETION_SETTLEMENT_CONTROL`
-- Separate currently occupied space from potential demand by a working peer.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.SettlementDestinationAssessment={}
local M=OuttaMyWay.SettlementDestinationAssessment
local G=OuttaMyWay.FarmEdgeGeometry
local SAMPLE_MS=500
local MAX_SAMPLE_GAP_MS=5000
local HISTORY_LIMIT=4
local histories={}
local elapsedMs=0
local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end
local function magnitude(x,z)
    return math.sqrt(x*x+z*z)
end
local function direction(v)
    if type(localDirectionToWorld)~="function"
        or type(v)~="table" or v.rootNode==nil then return nil,nil end
    local ok,x,_,z=pcall(localDirectionToWorld,v.rootNode,0,0,1)
    if not ok or not finite(x) or not finite(z) then return nil,nil end
    local m=magnitude(x,z)
    if m<0.001 then return nil,nil end
    return x/m,z/m
end
local function peersFor(vehicle,poly)
    local approach=OuttaMyWay.ExtendedInfieldApproach
    if type(approach)~="table"
        or type(approach.activePeers)~="function" then
        return nil,"DESTINATION_PEER_EVIDENCE_UNAVAILABLE"
    end
    local peers,okay,why=approach.activePeers(vehicle,poly)
    if not okay then return nil,why end
    return peers
end
function M.reset()
    histories={}
    elapsedMs=0
end
-- Physical motion is inferred ONLY from two separated position samples.
-- Native heading alone is never labelled a measured movement vector.
function M.sample(vehicle,dt,sourceField)
    if type(dt)~="number" or dt<=0 then return end
    elapsedMs=elapsedMs+dt
    if elapsedMs<SAMPLE_MS then return end
    local period=elapsedMs
    elapsedMs=0
    local source=sourceField
    if source==nil and type(OuttaMyWay.CompletionFieldMembership)=="table" then
        source=OuttaMyWay.CompletionFieldMembership.identify(vehicle)
    end
    local poly=source and source.polygon
    if poly==nil and source and source.field then
        poly=G.polygonFor(source.field)
    end
    if poly==nil then return end
    local peers=peersFor(vehicle,poly)
    if type(peers)~="table" then return end
    local seen={}
    for i=1,#peers do
        local p=peers[i]
        local key=p.vehicle.rootNode
        seen[key]=true
        local old=histories[key]
        local history={x=p.x,z=p.z,seen=period}
        if old~=nil and period<=MAX_SAMPLE_GAP_MS then
            local dx,dz=p.x-old.x,p.z-old.z
            local distance=magnitude(dx,dz)
            if distance>=0.3 and distance<=period*0.03 then
                history.motionX=dx/distance
                history.motionZ=dz/distance
                history.speedMps=distance*1000/period
                history.motionObserved=true
            end
        end
        histories[key]=history
    end
    local n=0
    for k,_ in pairs(histories) do
        if not seen[k] then histories[k]=nil end
        n=n+1
        if n>HISTORY_LIMIT*128 then histories={} break end
    end
end
function M.observe(vehicle,poly)
    local peers,why=peersFor(vehicle,poly)
    if peers==nil then return nil,why end
    local result={peers={},workingCount=0,motionCount=0,headingCount=0}
    for i=1,#peers do
        local p=peers[i]
        local hX,hZ=direction(p.vehicle)
        local old=histories[p.vehicle.rootNode]
        local rec={vehicle=p.vehicle,x=p.x,z=p.z,radius=p.radius,
            headingX=hX,headingZ=hZ,
            motionX=old and old.motionX or nil,
            motionZ=old and old.motionZ or nil,
            speedMps=old and old.speedMps or nil,
            motionObserved=old and old.motionObserved or false}
        result.peers[#result.peers+1]=rec
        result.workingCount=result.workingCount+1
        if rec.motionObserved then result.motionCount=result.motionCount+1 end
        if hX then result.headingCount=result.headingCount+1 end
    end
    return result
end
local function distanceToForwardCorridor(p,peer,dx,dz)
    local offsetX,offsetZ=p.x-peer.x,p.z-peer.z
    local along=offsetX*dx+offsetZ*dz
    local cross=math.abs(offsetX*dz-offsetZ*dx)
    return along,cross
end
-- A conservative ordinal risk, NOT a predicted GIANTS trajectory.
-- Measured movement informs the near-term corridor; heading alone is a
-- lower-confidence directional hint and never asserts a future destination.
function M.risk(candidate,peer)
    local dx,dz=candidate.x-peer.x,candidate.z-peer.z
    local range=magnitude(dx,dz)
    if range<peer.radius+35 then return 4,"NEAR_ACTIVE_WORKER" end
    if peer.motionObserved and finite(peer.motionX) then
        local along,cross=distanceToForwardCorridor(
            candidate,peer,peer.motionX,peer.motionZ)
        if along>=-15 and along<=170 and cross<50+peer.radius then
            return 3,"OBSERVED_MOTION_CORRIDOR"
        end
    elseif finite(peer.headingX) then
        local along,cross=distanceToForwardCorridor(
            candidate,peer,peer.headingX,peer.headingZ)
        if along>=-10 and along<=120 and cross<35+peer.radius then
            return 2,"HEADING_POTENTIAL_CORRIDOR"
        end
    end
    if range<110+peer.radius then return 2,"NEAR_PRODUCTIVE_DEMAND" end
    return 0,"NO_NEAR_DEMAND_EVIDENCE"
end
function M.rank(sites,origin,frame,situation)
    if type(sites)~="table" or type(origin)~="table"
        or type(situation)~="table" then
        return nil,"DESTINATION_SITUATION_UNAVAILABLE"
    end
    for i=1,#sites do
        local site=sites[i]
        local f=site.frame or frame
        local terminal={x=f.ax+f.ux*site.station+f.nx*4,
            z=f.az+f.uz*site.station+f.nz*4}
        local worst,reason=0,#situation.peers>0
            and "NO_NEAR_DEMAND_EVIDENCE" or "NO_ACTIVE_WORKER"
        for j=1,#situation.peers do
            local risk,why=M.risk(terminal,situation.peers[j])
            if risk>worst then worst,reason=risk,why end
        end
        site.peerRisk=worst
        site.peerRiskReason=reason
        local dx,dz=origin.x-site.entry.x,origin.z-site.entry.z
        site.entryDistance=magnitude(dx,dz)
        site.centreDistance=math.abs(site.station-f.length/2)
        -- With active workers, protect other productive space first.
        -- When no peer is working, preserve the previously tested
        -- proximity preference. These scores are EXPERIMENTAL ranking
        -- estimates, not complete path lengths or physics forecasts.
        if #situation.peers>0 then
            site.score=worst*1000+site.centreDistance*1.0+
                site.entryDistance*0.15
        else
            site.score=site.entryDistance
        end
    end
    table.sort(sites,function(a,b)
        if a.score==b.score then
            if a.edgeIndex~=b.edgeIndex then
                return (a.edgeIndex or 0)<(b.edgeIndex or 0)
            end
            return a.station<b.station
        end
        return a.score<b.score
    end)
    return sites
end
-- Edge candidacy is geometric; route/terminal qualification is separate.
function M.edgeEvidence(poly)
    local result={}
    for _,edge in ipairs(G.edges(poly)) do
        if edge.length>6 then
            local x,z=(edge.ax+edge.bx)/2,(edge.az+edge.bz)/2
            local nx=G.outwardAt(poly,edge,x,z)
            if nx~=nil then
                result[#result+1]={edge=edge.index,
                    status="GEOMETRIC_CANDIDATE_PENDING_ROUTE_QUALIFICATION",
                    length=edge.length}
            end
        end
    end
    return result
end
return M
