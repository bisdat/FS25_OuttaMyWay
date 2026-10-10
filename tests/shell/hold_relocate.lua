-- Asymmetric Cooperative Egress: select together, configure/move one,
-- regulate the remaining worker independently. Solo/static are separate.
OuttaMyWay={ProjectedEgressRegion={}}
local selectedMode="OBLIQUE_REVERSE"
OuttaMyWay.ProjectedEgressRegion.planPairCascade=function(_,preferred,other)
    if selectedMode=="NONE" then
        return nil,nil,nil,"NO_FEASIBLE_PAIR_EGRESS"
    end
    return {isReverse=true,targetX=preferred.x-81,targetZ=preferred.z,
        steeringHorizonM=81,directionSource=selectedMode,
        cascadeMode=selectedMode,cascadeAttempts=8,
        returnRegion={source="PAIR_WORKING_CORRIDOR_TRAVEL_REGION",
            originX=preferred.x,originZ=preferred.z,
            directionX=-1,directionZ=0,requiredProgressM=41},
        regionTravelM=41,remainingWorkingWidthM=36,
        workingCorridorMarginM=5,transitGeometryBasis="GIANTS_BASE_SIZE",
        marginM=1},preferred,other
end
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
local a={assemblyReferenceKey="A",x=10,z=10,vehicle={name="A"}}
local b={assemblyReferenceKey="B",x=20,z=10,vehicle={name="B"}}
local third={assemblyReferenceKey="C",x=15,z=20,vehicle={name="C"}}
local events={}
local current,valid=true,true
local failTransit,failReverse,failPreflight,failRelease=nil,false,nil,nil
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
    isCommitmentCurrent=function()
        return current,"GIANTS_JOB_EPISODE_CHANGED"
    end
}
local physical={
    preflightPairMover=function(_,state)
        event("PAIR_MOVER_PREFLIGHT",state.relocator.vehicle)
        return state.relocator.vehicle.name~=failPreflight,
            "MOVER_TRANSIT_PREFLIGHT_FAILED"
    end,
    hold=function(_,v,p)event("HOLD_"..p,v);return true end,
    releaseHold=function(_,v,p)
        event("RELEASE_"..p,v)
        return failRelease~=v.name,"HOLD_RELEASE_FAILURE"
    end,
    requestTransit=function(_,v)
        event("TRANSIT",v)
        return failTransit~=v.name,"TRANSIT_REQUEST_FAILED"
    end,
    transitStatus=function()
        error("FOLD_STATUS_MUST_NOT_DELAY_PAIRED_EGRESS")
    end,
    pairTransitFootprint=function(_,v)
        event("FOOTPRINT",v)
        local p=v.name=="A" and a or b
        return {rootX=p.x,rootZ=p.z,corners={{x=-1,z=-1},
            {x=1,z=1}},basis="GIANTS_BASE_SIZE",foldSettled=false}
    end,
    regulate=function(_,v)event("REGULATE",v);return true end,
    releaseRegulation=function(_,v)
        event("REGULATE_RELEASE",v)
        return failRelease~=v.name,"REGULATION_RELEASE_FAILURE"
    end,
    startReverse=function(_,v,objective)
        event("REVERSE",v)
        assert(objective.regionTravelM==41
            and objective.returnRegion.requiredProgressM==41)
        return not failReverse,"REVERSE_REQUEST_FAILED"
    end,
    reverseStatus=function()
        return {isComplete=completed,isFailed=false,
            travelledM=completed and 41 or 0}
    end,
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
assert(started and info.pairedEgressImmediate
    and c:getStatus().phase=="REVERSING")
assert(#events==8 and events[1]=="VALIDATE:-"
    and events[2]=="FOOTPRINT:B" and events[3]=="FOOTPRINT:A"
    and events[4]=="PAIR_MOVER_PREFLIGHT:A"
    and events[5]=="REGULATE:B" and events[6]=="REGULATE:C"
    and events[7]=="TRANSIT:A" and events[8]=="REVERSE:A",
    "pair selects roles before commanding only mover TRANSIT and motion")
assert(not has("TRANSIT","B") and not has("HOLD_TRANSIT_PREPARATION","A")
    and not has("HOLD_TRANSIT_PREPARATION","B"))
assert(c.lastPairMotionStartEvidence.pairedEgressImmediate
    and c.lastPairMotionStartEvidence.remainingWorkerConfiguration==
        "WORKING_UNCHANGED")
c:advance(5999)
assert(not has("REGULATE_RELEASE","B"))
c:advance(6000)
assert(not has("REGULATE_RELEASE","B") and not has("REGULATE_RELEASE","C"),
    "the prior 5 s boundary is no longer pair Regulation release")
c:advance(8999)
assert(not has("REGULATE_RELEASE","B"))
c:advance(9000)
assert(has("REGULATE_RELEASE","B") and has("REGULATE_RELEASE","C")
    and not has("TRANSIT_CANCEL","B") and not has("REVERSE_STOP","A"),
    "8 s courtesy releases both independent blocker leases even while mover is reversing")
completed=true;c:advance(9001)
assert(has("REVERSE_STOP","A") and has("HOLD_RELOCATED_WORKER","A"))
c:advance(16000)
assert(not has("NATIVE_STOP_START","A"))
c:advance(16001)
assert(has("NATIVE_STOP_START","A") and not has("TRANSIT_CANCEL","B")
    and not has("TRANSIT_CANCEL","A") and not c:isActive())
assert(c:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")

-- If egress completes before one second, the unchanged seven-second mover
-- Hold can finish before the independent eight-second Regulation deadline.
-- That must never strand a 1 km/h cap or block the mover's native restart.
events={};completed=true
assert(c:begin(admitted(),20000))
c:advance(20001)
assert(has("REVERSE_STOP","A") and has("HOLD_RELOCATED_WORKER","A")
    and not has("REGULATE_RELEASE","B"))
c:advance(27000)
assert(not has("NATIVE_STOP_START","A"))
c:advance(27001)
assert(has("REGULATE_RELEASE","B") and has("REGULATE_RELEASE","C")
    and has("NATIVE_STOP_START","A") and not c:isActive(),
    "fast mover handback releases residual leases without waiting for 8 s")
assert(c:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")

-- Even an unknown folding position cannot add a preparation phase.
events={};completed=false
assert(c:begin(admitted(),30000))
assert(c:getStatus().phase=="REVERSING" and has("REVERSE","A"))
assert(c:relinquish("TEST_CLEANUP"))
assert(has("TRANSIT_CANCEL","A") and not has("TRANSIT_CANCEL","B"))

-- No route: no configuration changes to either worker.
events={};selectedMode="NONE"
local no,why=c:begin(admitted(),40000)
assert(not no and not c:isActive())
assert(c:getStatus().lastOutcome.status=="NO_FEASIBLE_PAIR_EGRESS")
assert(not has("TRANSIT","A") and not has("TRANSIT","B"))
selectedMode="OBLIQUE_REVERSE"

-- Only selected mover may fail preflight; nonmover untouched.
events={};failPreflight="A"
no=c:begin(admitted(),50000)
assert(not no and not c:isActive())
assert(c:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED")
assert(not has("TRANSIT","A") and not has("TRANSIT","B"))
failPreflight=nil
events={};failTransit="A"
no=c:begin(admitted(),60000)
assert(not no and not c:isActive())
assert(has("TRANSIT:A","-")==false)
assert(has("TRANSIT","A") and not has("TRANSIT","B")
    and has("TRANSIT_CANCEL","A") and not has("TRANSIT_CANCEL","B"))
failTransit=nil

events={};failReverse=true
no=c:begin(admitted(),70000)
assert(not no and not c:isActive())
assert(has("REVERSE_CANCEL","A") and has("TRANSIT_CANCEL","A")
    and not has("TRANSIT_CANCEL","B"))
failReverse=false

events={};valid=false
assert(not c:begin(admitted(),80000))
assert(#events==1 and events[1]=="VALIDATE:-")
valid=true
events={};completed=false
assert(c:begin(admitted(),90000))
current=false;c:advance(90001)
assert(not c:isActive() and has("TRANSIT_CANCEL","A")
    and not has("TRANSIT_CANCEL","B"))
current=true

events={};failRelease="B"
assert(c:begin(admitted(),100000))
c:advance(108000)
assert(not c:isActive()
    and c:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED")
failRelease=nil

events={};nativeAccept=false;completed=false
assert(c:begin(admitted(),110000))
completed=true;c:advance(110001);c:advance(117001)
assert(not c:isActive()
    and c:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED"
    and not has("TRANSIT_CANCEL","B"))
nativeAccept=true

-- Failure to clear a still-owned blocker lease during unusually early
-- handback is NOT a successful native restart. Normal interruption cleanup
-- must run, and never allow a silent orphaned speed cap.
events={};completed=true;failRelease="B"
assert(c:begin(admitted(),120000))
c:advance(120001)
assert(c:isActive() and has("HOLD_RELOCATED_WORKER","A")
    and not has("REGULATE_RELEASE","B"))
c:advance(127001)
assert(not c:isActive()
    and c:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED"
    and not has("NATIVE_STOP_START","A"),
    "failure to release early Regulation must interrupt handback")
failRelease=nil
print("Asymmetric paired egress: mover-only TRANSIT, independent 8s pair/5s static Regulation and 7s Hold, scoped cleanup PASS")
