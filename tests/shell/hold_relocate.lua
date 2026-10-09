-- Independent mocked coordinator contracts; physical GIANTS Reality is tested in-game.
OuttaMyWay={ProjectedEgressRegion={plan=function(_,relocator)
    return {isReverse=true,targetX=relocator.x-40,targetZ=relocator.z,
        steeringHorizonM=40,directionSource="NATIVE_REVERSE_AXIS",
        returnRegion={originX=relocator.x,originZ=relocator.z,
            directionX=-1,directionZ=0,requiredProgressM=20}}
end}}
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
local a={assemblyReferenceKey="A",x=10,z=0,vehicle={name="A"}}
local b={assemblyReferenceKey="B",x=15,z=0,vehicle={name="B"}}
local c={assemblyReferenceKey="C",x=11,z=10,vehicle={name="C"}}
local events={}
local isCurrent=true
local isInitialJobEpisodeCurrent=true
local isTransitRequestAccepted=true
local isReverseRequestAccepted=true
local reverseStatus={travelledM=0,isComplete=false}
local refuseReleaseFor=nil
local isNativeRestartAccepted=true
local isNativePreparationRejected=false
local function record(kind,vehicle,extra)
    events[#events+1]={kind=kind,vehicle=vehicle and vehicle.name,extra=extra}
end
local authority={
    validateCommitment=function(_,commitment)
        record("VALIDATE")
        return commitment.token=="issued-by-authority" and isInitialJobEpisodeCurrent,
            "COMMITMENT_OR_JOB_EPISODE_UNVERIFIED"
    end,
    isCommitmentCurrent=function() return isCurrent,"LIFECYCLE_INVALID" end
}
local control={
    preflight=function(_,state) record("PREFLIGHT",state.relocator.vehicle);return true end,
    hold=function(_,vehicle,purpose)record("HOLD",vehicle,purpose);return true end,
    regulate=function(_,vehicle,purpose)record("REGULATE",vehicle,purpose);return true end,
    releaseRegulation=function(_,vehicle,purpose)
        record("REGULATE_RELEASE",vehicle,purpose)
        if refuseReleaseFor==vehicle.name then
            return false,"NATIVE_REGULATION_RELEASE_UNCONFIRMED"
        end
        return true,{interceptionCount=7,physicalDisplacementM=0.5}
    end,
    releaseHold=function(_,vehicle,purpose)
        record("RELEASE",vehicle,purpose)
        if refuseReleaseFor==vehicle.name then return false,"PHYSICAL_RELEASE_UNCONFIRMED" end
        return true
    end,
    requestTransit=function(_,vehicle)
        record("TRANSIT",vehicle)
        return isTransitRequestAccepted,"NATIVE_TRANSIT_REQUEST_FAILED"
    end,
    transitStatus=function() error("TRANSIT_READINESS_MUST_NOT_BE_QUERIED") end,
    startReverse=function(_,vehicle,objective)
        record("REVERSE",vehicle,objective)
        return isReverseRequestAccepted,"NATIVE_REVERSE_REQUEST_FAILED"
    end,
    reverseStatus=function() return reverseStatus end,
    stopReverse=function(_,vehicle)record("REVERSE_STOP",vehicle);return true end,
    cancelReverse=function(_,vehicle)record("REVERSE_CANCEL",vehicle);return true end,
    cancelTransit=function(_,vehicle)record("TRANSIT_CANCEL",vehicle);return true end,
    restartNativeFieldwork=function(_,vehicle)
        record("NATIVE_STOP_THEN_START",vehicle)
        if isNativePreparationRejected then
            return false,{reason="NATIVE_FIELDWORK_VALIDATION_REJECTED",
                isNativeJobStateUncertain=false}
        end
        if isNativeRestartAccepted then
            return true,{isOldJobStopped=true,isNewJobStarted=true}
        end
        return false,{reason="NATIVE_START_UNCERTAIN",
            isNativeJobStateUncertain=true}
    end
}
local function admitted()
    return {token="issued-by-authority",commitmentId="PAIR1",
        participants={b,a},fieldCentroid={x=0,z=0},
        fieldPolygon={xs={-200,200,200,-200},zs={-200,-200,200,200}},
        nearbyBlockers={b,c},blockerWorkingWidthM=10,offsetM=0}
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
assert(commitment.objective.isReverse and commitment.objective.maxTravelM==nil)
assert(commitment.objective.returnRegion.requiredProgressM==20)
assert(commitment.objective.steeringHorizonM==40)
assert(commitment.objective.targetX==-30 and commitment.objective.targetZ==0)
assert(events[1].kind=="VALIDATE" and events[2].kind=="PREFLIGHT")
assert(events[3].kind=="REGULATE" and events[3].vehicle=="B")
assert(events[4].kind=="REGULATE" and events[4].vehicle=="C")
assert(events[5].kind=="TRANSIT","Hold and TRANSIT begin without idle delay")
assert(events[6].kind=="REVERSE","reverse starts immediately even though TRANSIT is not complete")
assert(coordinator:getStatus().phase=="REVERSING")
coordinator:advance(5999)
assert(#events==6,"no early Hold release; reverse already underway")
coordinator:advance(6000)
assert(events[7].kind=="REGULATE_RELEASE" and events[8].kind=="REGULATE_RELEASE",
    "5 s blocker Regulation release never waits for reverse or folding completion")
reverseStatus={travelledM=9,isComplete=true}
coordinator:advance(6100)
assert(events[9].kind=="REVERSE_STOP" and events[10].kind=="HOLD"
    and events[10].vehicle=="A")
coordinator:advance(13099)
assert(#events==10,"no pair-clearance gate and no premature 7 s release")
coordinator:advance(13100)
assert(events[11].kind=="RELEASE" and events[12].kind=="NATIVE_STOP_THEN_START")
assert(coordinator:isActive()==false)
assert(coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
assert(coordinator:getStatus().lastOutcome.isNativeContinuationConfirmed==false)
-- Rejected native request must not start reverse; cleanup retains prior effects.
events={}
isTransitRequestAccepted=false
local rejected,transitFailure=coordinator:begin(admitted(),17500)
assert(not rejected and transitFailure=="NATIVE_TRANSIT_REQUEST_FAILED")
assert(not contains("REVERSE","A"))
assert(contains("TRANSIT_CANCEL","A"))
assert(not coordinator:isActive())
isTransitRequestAccepted=true
-- A failed reverse request after TRANSIT must cancel that configuration request.
events={}
isReverseRequestAccepted=false
local reverseRejected,reverseFailure=coordinator:begin(admitted(),18000)
assert(not reverseRejected and reverseFailure=="NATIVE_REVERSE_REQUEST_FAILED")
assert(contains("TRANSIT","A") and contains("REVERSE","A"))
assert(contains("REVERSE_CANCEL","A") and contains("TRANSIT_CANCEL","A"))
assert(not coordinator:isActive())
isReverseRequestAccepted=true
-- Absence of issued commitment provenance prevents any physical action.
events={}
local bad=admitted();bad.token="invented";assert(not coordinator:begin(bad,20000))
assert(#events==1 and events[1].kind=="VALIDATE")
-- A token is insufficient when GIANTS Job Episode freshness is unknown.
isInitialJobEpisodeCurrent=false
events={}
assert(not coordinator:begin(admitted(),20001))
assert(#events==1 and events[1].kind=="VALIDATE")
isInitialJobEpisodeCurrent=true
-- A candidate's own assertion is irrelevant to independent authority.
bad=admitted();bad.authorized=true;bad.token=nil
assert(not coordinator:begin(bad,20000))
-- A blocked worker need not be the selected relocator; no other blocker can
-- replace the other pair participant in the explicit set.
bad=admitted();bad.nearbyBlockers={c}
assert(not coordinator:begin(bad,20000))
bad=admitted();bad.fieldCentroid={x=nil,z=0}
assert(not coordinator:begin(bad,20000))
-- Deterministic tie by assembly reference, independent of input ordering.
local d={assemblyReferenceKey="D",x=-10,z=0,vehicle={name="D"}}
bad=admitted();bad.participants={d,a};bad.nearbyBlockers={d}
local accepted,tie=coordinator:begin(bad,22000)
assert(accepted and tie.relocatingAssemblyReferenceKey=="A")
assert(not coordinator:begin(bad,22001),"one active pair commitment")
isCurrent=false;coordinator:advance(22100)
assert(coordinator:isActive()==false)
assert(contains("REGULATE_RELEASE","D") and contains("TRANSIT_CANCEL","A"))
isCurrent=true
-- Old point-distance abort has been explicitly withdrawn. Accumulated
-- travel alone must not end the manoeuvre without Return Region membership.
reverseStatus={travelledM=200,isComplete=false};events={}
local stillActive=assert(coordinator:begin(admitted(),30000))
coordinator:advance(30002)
assert(coordinator:isActive() and coordinator:getStatus().phase=="REVERSING")
assert(coordinator:relinquish("TEST_CLEANUP"))
-- Failure to physically remove speed Regulation retains cleanup debt.
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
isNativeRestartAccepted=false;events={}
assert(coordinator:begin(admitted(),50000))
coordinator:advance(50001)
reverseStatus={travelledM=1,isComplete=true}
coordinator:advance(50002)
coordinator:advance(57002)
assert(coordinator:isActive() and coordinator:getStatus().phase=="WAITING_FOR_PLAYER_INTERVENTION")
assert(coordinator:getStatus().isNativeJobStateUncertain==true)
assert(coordinator:getStatus().lastOutcome.status=="UNRESOLVED")
assert(not coordinator:relinquish("DISABLED"),"uncertain native job handback must remain visible")
-- A native FIELDWORK rejection BEFORE stop does not imply an irreversible
-- handback and must allow the old TRANSIT request to restore.
isNativeRestartAccepted=true
isNativePreparationRejected=true
reverseStatus={travelledM=0,isComplete=false}
events={}
local fresh=Coordinator.new(authority,control)
assert(fresh:begin(admitted(),70000))
reverseStatus={travelledM=1,isComplete=true}
fresh:advance(70001)
fresh:advance(77001)
assert(not fresh:isActive(),"pre-stop failure must not retain false job uncertainty")
assert(fresh:getStatus().lastOutcome.status=="CONTROL_INTERRUPTED")
assert(fresh:getStatus().lastOutcome.reason=="NATIVE_FIELDWORK_VALIDATION_REJECTED")
assert(contains("TRANSIT_CANCEL","A"))
print("Hold & Relocate coordination, timer releases, commitment authority and unresolved cleanup: PASS")
