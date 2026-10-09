-- The coordinator is dormant in production; these interfaces are independent mocked contracts.
OuttaMyWay={}
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
local a={assemblyReferenceKey="A",x=10,z=0,vehicle={name="A"}}
local b={assemblyReferenceKey="B",x=15,z=0,vehicle={name="B"}}
local c={assemblyReferenceKey="C",x=11,z=10,vehicle={name="C"}}
local events={}
local isCurrent=true
local isTransitReady=false
local reverseStatus={travelledM=0,isComplete=false}
local refuseReleaseFor=nil
local isNativeRestartAccepted=true
local function record(kind,vehicle,extra)
    events[#events+1]={kind=kind,vehicle=vehicle and vehicle.name,extra=extra}
end
local authority={
    validateCommitment=function(_,commitment)
        record("VALIDATE")
        return commitment.token=="issued-by-authority", "COMMITMENT_NOT_ISSUED"
    end,
    isCommitmentCurrent=function() return isCurrent,"LIFECYCLE_INVALID" end
}
local control={
    preflight=function(_,state) record("PREFLIGHT",state.relocator.vehicle);return true end,
    hold=function(_,vehicle,purpose)record("HOLD",vehicle,purpose);return true end,
    releaseHold=function(_,vehicle,purpose)
        record("RELEASE",vehicle,purpose)
        if refuseReleaseFor==vehicle.name then return false,"PHYSICAL_RELEASE_UNCONFIRMED" end
        return true
    end,
    requestTransit=function(_,vehicle)record("TRANSIT",vehicle);return true end,
    transitStatus=function() return isTransitReady and "READY" or "WAITING" end,
    startReverse=function(_,vehicle,objective)record("REVERSE",vehicle,objective);return true end,
    reverseStatus=function() return reverseStatus end,
    stopReverse=function(_,vehicle)record("REVERSE_STOP",vehicle);return true end,
    cancelReverse=function(_,vehicle)record("REVERSE_CANCEL",vehicle);return true end,
    cancelTransit=function(_,vehicle)record("TRANSIT_CANCEL",vehicle);return true end,
    restartNativeFieldwork=function(_,vehicle)
        record("NATIVE_STOP_THEN_START",vehicle)
        if isNativeRestartAccepted then
            return true,{isOldJobStopped=true,isNewJobStarted=true}
        end
        return false,"NATIVE_START_UNCERTAIN"
    end
}
local function admitted()
    return {token="issued-by-authority",commitmentId="PAIR1",
        participants={b,a},fieldCentroid={x=0,z=0},
        nearbyBlockers={b,c},offsetM=0}
end
local function contains(kind,vehicle)
    for i=1,#events do
        if events[i].kind==kind and events[i].vehicle==vehicle then return true end
    end
    return false
end
local coordinator=Coordinator.new(authority,control)
local ok,commitment=coordinator:begin(admitted(),1000)
assert(ok and commitment.relocatingAssemblyReferenceKey=="A")
assert(commitment.objective.isReverse and commitment.objective.maxTravelM==30)
assert(commitment.objective.steeringHorizonM==40)
assert(commitment.objective.targetX==0 and commitment.objective.targetZ==0)
assert(events[1].kind=="VALIDATE" and events[2].kind=="PREFLIGHT")
assert(events[3].kind=="HOLD" and events[3].vehicle=="B")
assert(events[4].kind=="HOLD" and events[4].vehicle=="C")
assert(events[5].kind=="TRANSIT","Hold and TRANSIT begin without idle delay")
coordinator:advance(5999)
assert(#events==5,"no early Hold release")
isTransitReady=true
coordinator:advance(6000)
assert(events[6].kind=="RELEASE" and events[7].kind=="RELEASE")
assert(events[8].kind=="REVERSE","5 s release independent of egress completion")
reverseStatus={travelledM=9,isComplete=true}
coordinator:advance(6100)
assert(events[9].kind=="REVERSE_STOP" and events[10].kind=="HOLD"
    and events[10].vehicle=="A")
coordinator:advance(16099)
assert(#events==10,"no pair-clearance gate and no premature 10 s release")
coordinator:advance(16100)
assert(events[11].kind=="RELEASE" and events[12].kind=="NATIVE_STOP_THEN_START")
assert(coordinator:isActive()==false)
assert(coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
assert(coordinator:getStatus().lastOutcome.isNativeContinuationConfirmed==false)
-- Absence of issued commitment provenance prevents any physical action.
events={}
local bad=admitted();bad.token="invented";assert(not coordinator:begin(bad,20000))
assert(#events==1 and events[1].kind=="VALIDATE")
-- A candidate's own assertion is irrelevant to independent authority.
bad=admitted();bad.authorized=true;bad.token=nil
assert(not coordinator:begin(bad,20000))
-- A blocked worker need not be the selected relocator; no other blocker can
-- replace the other pair participant in the explicit set.
bad=admitted();bad.nearbyBlockers={c}
assert(not coordinator:begin(bad,20000))
bad=admitted();bad.fieldCentroid={x=10,z=0}
assert(not coordinator:begin(bad,20000))
-- Deterministic tie by assembly reference, independent of input ordering.
local d={assemblyReferenceKey="D",x=-10,z=0,vehicle={name="D"}}
bad=admitted();bad.participants={d,a};bad.nearbyBlockers={d}
local accepted,tie=coordinator:begin(bad,22000)
assert(accepted and tie.relocatingAssemblyReferenceKey=="A")
assert(not coordinator:begin(bad,22001),"one active pair commitment")
isCurrent=false;coordinator:advance(22100)
assert(coordinator:isActive()==false)
assert(contains("RELEASE","D") and contains("TRANSIT_CANCEL","A"))
isCurrent=true
-- Fail-closed bound, even though steering horizon is longer than movement.
bad=admitted();bad.fieldCentroid={x=-100,z=0};bad.offsetM=2
isTransitReady=true;events={}
local accepted2,bounded=coordinator:begin(bad,30000)
assert(accepted2 and bounded.objective.maxTravelM==32)
coordinator:advance(30001)
reverseStatus={travelledM=32.1,isComplete=false}
coordinator:advance(30002)
assert(coordinator:isActive()==false)
assert(coordinator:getStatus().lastOutcome.reason=="REVERSE_DISTANCE_EVIDENCE_INVALID")
-- Failure to physically release a Hold retains explicit unresolved state.
isTransitReady=false
reverseStatus={travelledM=0,isComplete=false}
events={}
assert(coordinator:begin(admitted(),40000))
refuseReleaseFor="B"
coordinator:advance(45000)
assert(coordinator:isActive() and coordinator:getStatus().phase=="WAITING_FOR_PLAYER_INTERVENTION")
assert(coordinator:getStatus().unresolvedEffects[1]~=nil)
assert(coordinator:getStatus().lastOutcome.status=="UNRESOLVED")
assert(not coordinator:relinquish("DISABLED"),"cannot report relinquished while Hold remains")
refuseReleaseFor=nil
assert(coordinator:relinquish("EXPLICIT_RETRY"),"verified cleanup permits relinquishment")
assert(coordinator:isActive()==false)
-- Native stop/start failure is explicitly unresolved even if physical cleanup works.
isTransitReady=true;isNativeRestartAccepted=false;events={}
assert(coordinator:begin(admitted(),50000))
coordinator:advance(50001)
reverseStatus={travelledM=1,isComplete=true}
coordinator:advance(50002)
coordinator:advance(60002)
assert(coordinator:isActive() and coordinator:getStatus().phase=="WAITING_FOR_PLAYER_INTERVENTION")
assert(coordinator:getStatus().isNativeJobStateUncertain==true)
assert(coordinator:getStatus().lastOutcome.status=="UNRESOLVED")
assert(not coordinator:relinquish("DISABLED"),"uncertain native job handback must remain visible")
print("Hold & Relocate coordination, timer releases, commitment authority and unresolved cleanup: PASS")
