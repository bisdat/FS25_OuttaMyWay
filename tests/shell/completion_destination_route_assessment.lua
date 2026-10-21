-- Joint destination/route qualification from a real stopped assembly pose.
-- A preference cannot substitute for a connected nominal full parking route.
OuttaMyWay={}
local vehicle={rootNode=91}
local current={x=2,z=4}
getWorldTranslation=function()return current.x,0,current.z end
local long={index=1,ax=200,az=0,ux=0,uz=1,nx=1,nz=0,
    length=160,distance=198}
local short={index=2,ax=10,az=0,ux=0,uz=1,nx=1,nz=0,
    length=65,distance=8}
OuttaMyWay.CompletionParkingGeometry={
    enumerate=function()
        return {frames={short,long},poly={id=9},fieldId=29}
    end
}
OuttaMyWay.SettlementPhysicalOccupancy={
    footRadius=function()return 4 end
}
local scene={peers={}}
local refusedRisk=false
OuttaMyWay.SettlementDestinationAssessment={
    observe=function()return scene end,
    risk=function()return refusedRisk and 3 or 0 end,
    rank=function(sites)
        table.sort(sites,function(a,b)
            return a.usableLongitudinalM>b.usableLongitudinalM
        end)
        for i,s in ipairs(sites) do
            s.selectionRank=i
            s.peerRisk=0
        end
        return sites
    end
}
local beginOptions={}
local longConnected=true
local longPending=false
local spentByEdge={}
OuttaMyWay.CompletionSettlementRoute={
    beginPlan=function(_,options)
        assert(options.sourceField.id==29
            and options.entryPose==nil
            and options.edgeIndex~=nil,
            "all candidate routes must start at the observed pose")
        beginOptions[#beginOptions+1]=options
        return {edge=options.edgeIndex,spent=0}
    end,
    advancePlan=function(s,units)
        assert(units==320)
        s.spent=s.spent+10
        spentByEdge[s.edge]=(spentByEdge[s.edge] or 0)+1
        if s.edge==1 and longPending then return "PENDING" end
        if s.edge==1 and not longConnected then
            return "FAILED",nil,"NO_POSE_REACHABLE_PARKING_REGION"
        end
        return "DONE",{edge=s.edge,field=29,memberCount=2,
            terminalPose={x=s.edge==1 and 207 or 18,z=15},
            legs={{name="REVERSE_POSITIONING",
                point={x=current.x-10,z=current.z},moveForwards=false},
                {name="FORWARD_GUIDANCE",
                point={x=current.x+5,z=current.z+5},moveForwards=true}}}
    end
}
dofile("scripts/coordination/CompletionDestinationRouteAssessment.lua")
local Assessor=OuttaMyWay.CompletionDestinationRouteAssessment
local source={id=29}
local function planUntilDone(s,startClock)
    local phase,route,why
    for i=1,40 do
        phase,route,why=Assessor.advancePlan(s,320,(startClock or 0)+i*16)
        if phase~="PENDING" then return phase,route,why end
    end
    return phase,route,why
end
local s=assert(Assessor.beginPlan(vehicle,source))
assert(s.order[1].edgeIndex==2 and s.order[1].selectionRank==2
    and s.order[2].edgeIndex==1 and s.order[2].selectionRank==1,
    "nearest known reverse-first local route must remain available provisionally")
assert(Assessor.priorityPreview(s):find("1:rank1:",1,true))
local phase,route,why=planUntilDone(s)
assert(phase=="DONE" and route.edge==1
    and route.destinationAssessment=="ACTUAL_POSE_DIRECT"
    and route.destinationSelectionRank==1
    and route.legs[1].moveForwards==false,
    "a preferred region wins ONLY with a fully qualified reverse-first route")
assert(beginOptions[1].edgeIndex==2
    and beginOptions[1].earliestQualified~=true
    and beginOptions[2].edgeIndex==1
    and beginOptions[2].earliestQualified==true,
    "known nearest route and preferred alternative use separate bounded local planners")
-- Failed or incomplete preferred edges are NOT a pretext to drop an
-- already qualified actual-pose route.
longConnected=false
local rejected=assert(Assessor.beginPlan(vehicle,source))
phase,route,why=planUntilDone(rejected)
assert(phase=="DONE" and route.edge==2
    and rejected.reasonCounts.NO_POSE_REACHABLE_PARKING_REGION==1,
    "known actual-pose route must survive distant terminal refusal")
longConnected=true
longPending=true
local pending=assert(Assessor.beginPlan(vehicle,source))
for i=1,12 do
    phase,route=Assessor.advancePlan(pending,320,math.min(16990,i*1000))
end
assert(phase=="PENDING" and pending.provisional
    and pending.provisional.edge==2,
    "pending search cannot claim remote terminal or erase qualified fallback")
phase,route=Assessor.advancePlan(pending,320,17000)
assert(phase=="DONE" and route.edge==2,
    "response budget protects a proven actual-pose route from an unproven priority")
-- A provisional route cannot survive measured drift or a newly
-- relevant productive worker just because it qualified earlier.
local drift=assert(Assessor.beginPlan(vehicle,source))
for i=1,5 do
    phase,route=Assessor.advancePlan(drift,320,i*1000)
end
assert(drift.provisional,"source-pose local route must be established")
current.x=current.x+0.5
phase,route,why=Assessor.advancePlan(drift,320,17000)
assert(phase=="FAILED" and route==nil
    and why=="DESTINATION_ACTUAL_POSE_CHANGED",
    "stale current pose must revoke a provisional destination")
current.x=current.x-0.5
local demand=assert(Assessor.beginPlan(vehicle,source))
for i=1,5 do
    phase,route=Assessor.advancePlan(demand,320,i*1000)
end
assert(demand.provisional)
scene.peers={{vehicle={},x=18,z=15}}
refusedRisk=true
phase,route,why=Assessor.advancePlan(demand,320,17000)
assert(phase=="FAILED" and route==nil
    and why=="DESTINATION_PRODUCTIVE_CORRIDOR_RISK",
    "new worker demand must revoke a provisional terminal")
scene.peers={}
refusedRisk=false
longPending=false
-- If every actual-pose candidate refuses, priority cannot grant Control.
longConnected=false
OuttaMyWay.CompletionSettlementRoute.advancePlan=function(s)
    s.spent=s.spent+1
    return "FAILED",nil,"NO_ACTUAL_POSE_LOCAL_ROUTE"
end
local none=assert(Assessor.beginPlan(vehicle,source))
phase,route,why=planUntilDone(none)
assert(phase=="FAILED" and route==nil
    and why=="NO_ACTUAL_POSE_CONNECTED_DESTINATION",
    "no hypothetical entry/terminal may become an admitted route")
print("actual-pose destination priority, reverse-first and proven-fallback bounds PASS")
