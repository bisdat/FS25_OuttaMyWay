-- Paired coordinator: dual TRANSIT, fold readiness, 15 s continuation,
-- region selection, movement leases, cleanup and native handback.
OuttaMyWay={ProjectedEgressRegion={}}
local selectedMode="OBLIQUE_REVERSE"
OuttaMyWay.ProjectedEgressRegion.planPairCascade=function(_,preferred,other)
    if selectedMode=="NONE" then
        return nil,nil,nil,"NO_FEASIBLE_PAIR_EGRESS"
    end
    local ray={source="SIGNED_CROSS_TRACK_REGION",
        originX=preferred.x,originZ=preferred.z,
        directionX=-1,directionZ=0,
        requiredProgressM=5,initialCrossTrackM=0}
    return {isReverse=true,targetX=preferred.x-45,targetZ=preferred.z,
        steeringHorizonM=45,directionSource=selectedMode,
        cascadeMode=selectedMode,cascadeAttempts=8,
        returnRegion=ray,regionTravelM=5,transitGeometryBasis="GIANTS_BASE_SIZE",
        marginM=1},preferred,other
end
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
local a={assemblyReferenceKey="A",x=10,z=10,vehicle={name="A"}}
local b={assemblyReferenceKey="B",x=20,z=10,vehicle={name="B"}}
local third={assemblyReferenceKey="C",x=15,z=20,vehicle={name="C"}}
local events={}
local current=true
local valid=true
local readyA,readyB=false,false
local failTransit=nil
local failReverse=false
local failRelease=nil
local nativeAccept=true
local completed=false
local function event(verb,v)
    events[#events+1]=verb..":"..(v and v.name or "-")
end
local function has(verb,v)
    for i=1,#events do
        if events[i]==verb..":"..v then return true end
    end
    return false
end
local authority={
    validateCommitment=function(_,c)
        event("VALIDATE")
        return valid and c.token=="admitted","COMMITMENT_UNVERIFIED"
    end,
    isCommitmentCurrent=function()return current,"GIANTS_JOB_EPISODE_CHANGED"end
}
local physical={
    preflightPair=function(_,s)event("PAIR_PREFLIGHT");return true end,
    hold=function(_,v,p)event("HOLD_"..p,v);return true end,
    releaseHold=function(_,v,p)
        event("RELEASE_"..p,v)
        return failRelease~=v.name,"HOLD_RELEASE_FAILURE"
    end,
    requestTransit=function(_,v)
        event("TRANSIT",v)
        return failTransit~=v.name,"TRANSIT_REQUEST_FAILED"
    end,
    transitStatus=function(_,v)
        event("STATUS",v)
        -- Lua 'condition and false or true' cannot represent a false
        -- branch: keep the two participant statuses explicit.
        local settled
        if v.name=="A" then settled=readyA else settled=readyB end
        return {isSettled=settled,
            requiredFoldCount=1,settledFoldCount=0}
    end,
    pairTransitFootprint=function(_,v)
        event("FOOTPRINT",v)
        local p=v.name=="A" and a or b
        return {rootX=p.x,rootZ=p.z,corners={{x=-1,z=-1},
            {x=1,z=1}},basis="GIANTS_BASE_SIZE"}
    end,
    regulate=function(_,v)event("REGULATE",v);return true end,
    releaseRegulation=function(_,v)
        event("REGULATE_RELEASE",v)
        return failRelease~=v.name,"REGULATION_RELEASE_FAILURE"
    end,
    startReverse=function(_,v)event("REVERSE",v)
        return not failReverse,"REVERSE_REQUEST_FAILED"end,
    reverseStatus=function()return {isComplete=completed,
        isFailed=false,travelledM=completed and 5 or 0}end,
    stopReverse=function(_,v)event("REVERSE_STOP",v);return true end,
    cancelReverse=function(_,v)event("REVERSE_CANCEL",v);return true end,
    cancelTransit=function(_,v)event("TRANSIT_CANCEL",v);return true end,
    restartNativeFieldwork=function(_,v)
        event("NATIVE_STOP_START",v)
        return nativeAccept,{reason="NATIVE_HANDOFF_UNCERTAIN"}
    end
}
local function admitted()
    return {token="admitted",commitmentId="PAIR",
        participants={b,a},fieldCentroid={x=0,z=0},
        fieldPolygon={xs={-100,100,100,-100},zs={-100,-100,100,100}},
        nearbyBlockers={b,third}}
end
local c=Coordinator.new(authority,physical)
local started,info=c:begin(admitted(),1000)
assert(started and info.phase=="PAIR_PREPARING_TRANSIT")
assert(c:getStatus().phase=="PAIR_PREPARING_TRANSIT"
    and c:getStatus().regionRequiredProgressM==nil)
assert(has("HOLD_TRANSIT_PREPARATION","A")
    and has("HOLD_TRANSIT_PREPARATION","B"))
assert(has("TRANSIT","A") and has("TRANSIT","B"))
assert(not has("REVERSE","A") and not has("REGULATE","B"),
    "fold preparation has no movement or consumed egress Regulation")
c:advance(15999)
assert(c:isActive() and not has("REVERSE","A"))
c:advance(16000)
assert(c:isActive() and c:getStatus().phase=="REVERSING",
    "15-second deadline must continue into physical egress")
assert(c.lastPairTransitExhaustion
    and c.lastPairMotionStartEvidence.transitWaitExhausted==true)
assert(has("FOOTPRINT","A") and has("FOOTPRINT","B")
    and has("REGULATE","B") and has("REGULATE","C")
    and has("REVERSE","A"))
assert(has("RELEASE_TRANSIT_PREPARATION","A")
    and has("RELEASE_TRANSIT_PREPARATION","B"))
c:advance(20999)
assert(not has("REGULATE_RELEASE","B"))
c:advance(21000)
assert(has("REGULATE_RELEASE","B") and has("REGULATE_RELEASE","C"),
    "5-second window begins at egress, not at TRANSIT request")
completed=true
c:advance(21001)
assert(has("REVERSE_STOP","A") and has("HOLD_RELOCATED_WORKER","A"))
c:advance(28000)
assert(not has("NATIVE_STOP_START","A"))
c:advance(28001)
assert(has("NATIVE_STOP_START","A") and has("TRANSIT_CANCEL","B"),
    "GIANTS owns selected new job; other worker restores configuration")
assert(not has("TRANSIT_CANCEL","A") and not c:isActive())
assert(c:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
-- With both non-foldable/settled, there is no artificial 15-second delay.
events={};completed=false;readyA=true;readyB=true
assert(c:begin(admitted(),30000))
c:advance(30001)
assert(c:getStatus().phase=="REVERSING")
assert(c.lastPairTransitExhaustion==nil)
assert(c.lastPairMotionStartEvidence.transitWaitExhausted==false)
assert(c:relinquish("TEST_CLEANUP"))
assert(has("TRANSIT_CANCEL","A") and has("TRANSIT_CANCEL","B"))
-- One foldable and one already settled: wait for the actual foldable only.
events={};readyA=false;readyB=true
assert(c:begin(admitted(),40000))
c:advance(40001);assert(c:getStatus().phase=="PAIR_PREPARING_TRANSIT")
readyA=true;c:advance(43000)
assert(c:getStatus().phase=="REVERSING")
assert(c:relinquish("TEST_CLEANUP"))
-- Failure during second TRANSIT request neutralises first and both preflights.
events={};failTransit="B"
local ok,reason=c:begin(admitted(),50000)
assert(not ok and reason=="TRANSIT_REQUEST_FAILED")
assert(not c:isActive())
assert(has("TRANSIT_CANCEL","A") and has("TRANSIT_CANCEL","B"))
failTransit=nil
-- Missing pair witness is not replaced by an arbitrary third party.
events={};local bad=admitted();bad.nearbyBlockers={third}
assert(not c:begin(bad,51000))
assert(#events==0)
-- Independent commitment and job-continuity checks precede commands.
valid=false;events={}
assert(not c:begin(admitted(),52000))
assert(#events==1 and events[1]=="VALIDATE:-")
valid=true;events={}
assert(c:begin(admitted(),53000))
current=false;c:advance(53100)
assert(not c:isActive() and has("TRANSIT_CANCEL","A")
    and has("TRANSIT_CANCEL","B"))
current=true
-- Exhaust the available regions, not the fold deadline, before last resort.
events={};readyA=true;readyB=true;selectedMode="NONE"
assert(c:begin(admitted(),60000))
c:advance(60001)
assert(not c:isActive() and not has("REVERSE","A"))
assert(c:getStatus().lastOutcome.status=="NO_FEASIBLE_PAIR_EGRESS")
assert(has("TRANSIT_CANCEL","A") and has("TRANSIT_CANCEL","B"))
selectedMode="OBLIQUE_REVERSE"
-- Reverse request failure cannot leave speed or TRANSIT leases behind.
events={};failReverse=true
assert(c:begin(admitted(),70000))
c:advance(70001)
assert(not c:isActive() and has("REVERSE_CANCEL","A")
    and has("TRANSIT_CANCEL","A") and has("TRANSIT_CANCEL","B"))
failReverse=false
-- Older point-distance abort is forbidden: no completion without region.
events={};completed=false
assert(c:begin(admitted(),80000))
c:advance(80001);c:advance(85001)
assert(c:isActive() and c:getStatus().phase=="REVERSING")
assert(c:relinquish("DISABLED"))
assert(not c:isActive())
-- Failed release does not poison subsequent pair admission.
events={};failRelease="B"
assert(c:begin(admitted(),90000))
c:advance(90001)
assert(not c:isActive() and c:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED")
failRelease=nil
-- Native handback remains a separate Reality claim.
events={};nativeAccept=false;completed=false
assert(c:begin(admitted(),100000))
c:advance(100001)
completed=true;c:advance(100002);c:advance(107002)
assert(not c:isActive() and c:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED")
nativeAccept=true
print("Paired TRANSIT settlement, timeout continuation and recovery leases: PASS")
