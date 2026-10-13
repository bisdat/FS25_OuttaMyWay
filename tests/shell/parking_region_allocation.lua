-- Parking claim and qualified local-entry validation on Field77 fixture.
-- No native motor calls; geometry feasibility is incremental.
OuttaMyWay={}
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/assessment/SettlementCorridorAssessment.lua")
local G=OuttaMyWay.FarmEdgeGeometry
local xs={131.79,143.52,153.81,162.43,165.16,165.55,175.32,
    182.15,228.15,-0.06,-10.56,-40.20}
local zs={-701.23,-656.06,-608.91,-561.34,-542.86,-526.92,
    -480.63,-468.38,-243.04,-207.44,-343.82,-677.42}
local source={densityMapPolygon={pointsX=xs,pointsZ=zs},fieldId=77}
local poly=assert(G.polygonFor(source))
g_fieldManager={fields={[77]=source},
    getFieldById=function(_,id)return g_fieldManager.fields[id]end}
local first={rootNode=100}
local second={rootNode=200}
local poses={
    [100]={x=120,z=-550,fx=-0.2,fz=-0.979795897},
    [200]={x=145,z=-600,fx=-0.2,fz=-0.979795897}
}
g_currentMission={vehicleSystem={vehicles={first,second}}}
getWorldTranslation=function(node)
    local p=poses[node]
    return p.x,0,p.z
end
localDirectionToWorld=function(node)
    local p=poses[node]
    return p.fx,0,p.fz
end
OuttaMyWay.PairTransitRegion={capture=function(vehicle)
    local p=poses[vehicle.rootNode]
    local corners={}
    for _,side in ipairs({-1,1}) do
        for _,front in ipairs({-1,1}) do
            corners[#corners+1]={x=-p.fz*1.2*side+p.fx*2.5*front,
                z=p.fx*1.2*side+p.fz*2.5*front}
        end
    end
    return {memberCount=1,corners=corners}
end}
dofile("scripts/coordination/SettlementPhysicalOccupancy.lua")
dofile("scripts/coordination/CompletionSettlementRoute.lua")
dofile("scripts/coordination/ParkingRegionAllocation.lua")
local Allocation=OuttaMyWay.ParkingRegionAllocation
local ledger={}
local function qualify(vehicle)
    local s=assert(Allocation.beginPlan(vehicle,ledger))
    local phase,route,reason
    for i=1,18000 do
        local prior=s.spent
        phase,route,reason=Allocation.advancePlan(s,320)
        assert(s.spent-prior<=320,"allocation must be frame bounded")
        if phase~="PENDING" then break end
    end
    return phase,route,reason
end
-- The first worker can reserve a concrete edge9 terminal ONLY if its
-- hypothetical entry produces a fully screened actual local route.
local phase,a,why=qualify(first)
assert(phase=="DONE",why)
assert(a.qualifiedLocalRoute and #a.qualifiedLocalRoute.legs>0)
assert(a.entryPose and a.terminalPose and a.station)
local firstClaim=assert(Allocation.claim(ledger,first,a.terminalPose,a.ownRadius))
assert(firstClaim==ledger[first])
assert(Allocation.claimCurrent(ledger,first))
-- Both workers must receive distinct claimable physical footprints
-- or the second must explicitly refuse. The same claimed root is forbidden.
local phase2,b,why2=qualify(second)
if phase2=="DONE" then
    local claim=assert(Allocation.claim(ledger,second,b.terminalPose,b.ownRadius))
    local dx,dz=claim.x-firstClaim.x,claim.z-firstClaim.z
    assert(dx*dx+dz*dz>(claim.radius+firstClaim.radius+4)^2,
        "two claims may not overlap")
    assert(b.qualifiedLocalRoute.terminalPose)
    Allocation.release(ledger,second)
else
    assert(phase2=="FAILED" and why2=="NO_QUALIFIED_TERMINAL_REGION",
        "second assembly must never silently reuse the same station")
end
local conflict,reason=Allocation.claim(ledger,second,
    {x=firstClaim.x,z=firstClaim.z},a.ownRadius)
assert(conflict==nil and reason=="TERMINAL_REGION_ALREADY_CLAIMED")
Allocation.release(ledger,first)
assert(Allocation.claimCurrent(ledger,first)==nil)
print("qualified terminal allocation: screened entry/terminal and exclusive claim PASS")
