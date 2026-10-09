-- Contract challenge for the live observation -> Pair Commitment -> physical path.
-- GIANTS job, field polygon, fold and drive operations are mocked; Reality untested.
OuttaMyWay={}
dofile("scripts/coordination/NativePairCommitmentAuthority.lua")
dofile("scripts/coordination/HoldRelocateCoordinator.lua")
dofile("scripts/control/HoldRelocatePhysicalControl.lua")
dofile("scripts/coordination/LiveHoldRelocateRuntime.lua")
local Authority=OuttaMyWay.NativePairCommitmentAuthority
local Coordinator=OuttaMyWay.HoldRelocateCoordinator
local Control=OuttaMyWay.HoldRelocatePhysicalControl
local Live=OuttaMyWay.LiveHoldRelocateRuntime
local enabled=true
local configuration={isResolved=function()return true end,
    isEnabled=function()return enabled end}
g_server={}
g_time=1000
g_fieldManager={fields={{densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}
}}}}
g_currentMission={}
local coords=setmetatable({},{__mode="k"})
getWorldTranslation=function(node)
    local p=coords[node]
    assert(p~=nil)
    return p.x,0,p.z
end
local function nativeWorker(x,z,blocked)
    local node={}
    coords[node]={x=x,z=z}
    local job={}
    local strategy={className="AIDriveStrategyFieldCourse",isBlocked=blocked}
    local root={rootNode=node,job=job,spec_aiFieldWorker={
        isActive=true,driveStrategies={strategy}}}
    root.getJob=function(self)return self.job end
    root.getAttachedImplements=function()return {} end
    root.getIsTurnedOn=function()return true end
    root.setIsTurnedOn=function() end
    root.getIsLowered=function()return true end
    root.setLowered=function() end
    return root,strategy
end
local first,blocked=nativeWorker(20,20,true)
local second=nativeWorker(23,20,false)
local authority=Authority.new(configuration)
local accepted,reason=authority:admitCandidate(first,second,first,999)
assert(accepted==nil,"persistence gate must reject a short pulse")
local issued=assert(authority:admitCandidate(first,second,first,1000))
assert(issued.fieldCentroid.x==50 and issued.fieldCentroid.z==50)
assert(issued.offsetM==0 and #issued.nearbyBlockers==1)
assert(issued.nearbyBlockers[1].vehicle==first,
    "closer-to-centroid worker B relocates; A is blocker")
assert(authority:validateCommitment(issued))
assert(authority:getExpectedNativeJob(second)==second.job)
assert(not authority:validateCommitment({commitmentId=issued.commitmentId}),
    "unissued commitment is not authority")
second.job={}
assert(not authority:isCommitmentCurrent(issued),"native job turnover must revoke commitment")
second.job=issued.participants[2].sourceJobReference
assert(authority:isCommitmentCurrent(issued))
-- Mock constructor surfaces only; the adapter under challenge is real.
OuttaMyWay.NativeTranslationHoldMechanism={new=function()return {} end}
OuttaMyWay.NativeReverseMechanism={new=function()return {} end}
OuttaMyWay.NativeTransitRequestMechanism={new=function()return {} end}
OuttaMyWay.NativeFieldworkJobReplacementMechanism={new=function()return {} end}
local physical=Control.new(authority)
local events={}
-- Replace subordinate native mechanisms only in this offline challenge.
physical.holdMechanism={
    hold=function(_,v,p)events[#events+1]="HOLD:"..p;return true end,
    releaseHold=function(_,v,p)events[#events+1]="RELEASE:"..p;return true end
}
physical.transitMechanism={
    requestTransit=function(_,vehicle)
        local plan=physical:getTransitRequests(vehicle)
        assert(plan~=nil and #plan.transitActions==2)
        assert(#plan.restoreActions==2)
        events[#events+1]="TRANSIT"
        return true
    end,
    cancelTransit=function()events[#events+1]="RESTORE";return true end,
    relinquishTransit=function()events[#events+1]="HANDOFF_TRANSIT";return true end
}
local reverse={travelledM=0,isComplete=false}
physical.reverseMechanism={
    startReverse=function(_,v,objective)
        events[#events+1]="REVERSE"
        assert(objective.maxTravelM==30 and objective.steeringHorizonM==40)
        return true
    end,
    reverseStatus=function()return reverse end,
    stopReverse=function()events[#events+1]="REVERSE_STOP";return true end,
    cancelReverse=function()events[#events+1]="REVERSE_CANCEL";return true end
}
physical.jobMechanism={
    restartNativeFieldwork=function(_,v)
        events[#events+1]="NATIVE_STOP_START"
        assert(authority:getExpectedNativeJob(v)==second.job)
        return true,{isOldJobStopped=true,isNewJobStarted=true}
    end
}
-- A possibly committed GIANTS stop forbids replaying inverse TRANSIT
-- commands into a replacement job, even if the native call later threw.
local nativeHandbackStatus={status="NOT_ATTEMPTED"}
physical.jobMechanism.getStatus=function()return nativeHandbackStatus end
local coordinator=Coordinator.new(authority,physical)
local ok,entry=coordinator:begin(issued,1000)
assert(ok and entry.relocatingAssemblyReferenceKey==issued.participants[2].assemblyReferenceKey)
assert(events[1]=="HOLD:EGRESS" and events[2]=="TRANSIT" and events[3]=="REVERSE")
assert(coordinator:getStatus().phase=="REVERSING")
coordinator:advance(5999)
assert(#events==3,"reverse already started, blocker Hold not yet released")
coordinator:advance(6000)
assert(events[4]=="RELEASE:EGRESS")
reverse={travelledM=20,isComplete=true}
coordinator:advance(6001)
assert(events[5]=="REVERSE_STOP" and events[6]=="HOLD:RELOCATED_WORKER")
coordinator:advance(16000)
assert(#events==6)
coordinator:advance(16001)
assert(events[7]=="RELEASE:RELOCATED_WORKER")
assert(events[8]=="NATIVE_STOP_START" and events[9]=="HANDOFF_TRANSIT")
assert(coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
assert(authority:release(issued))
physical.plans[second]={transitActions={},restoreActions={}}
nativeHandbackStatus={oldJobId=40,status="START_INVOCATION_ENTERED"}
local canCancel,why=physical:cancelTransit(second)
assert(not canCancel and why=="NATIVE_JOB_HANDOFF_MAY_HAVE_STARTED")
assert(events[#events]=="HANDOFF_TRANSIT",
    "do not replay old configuration after possible job hand-back")
nativeHandbackStatus={status="NOT_ATTEMPTED"}
assert(physical:cancelTransit(second),"a pre-stop cancellation can request restoration")
assert(events[#events]=="RESTORE")
-- Missing/contradictory field polygons never justify reverse movement.
g_fieldManager.fields={}
accepted,reason=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil and reason=="FIELD_POLYGON_EVIDENCE_UNAVAILABLE")
g_fieldManager.fields={{densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}}}}
-- Native admission rejection has discriminating, explicit evidence.
local originalGetJob=second.getJob
second.getJob=nil
accepted,reason=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil and reason=="NATIVE_JOB_REFERENCE_UNAVAILABLE")
second.getJob=originalGetJob
local originalStrategies=second.spec_aiFieldWorker.driveStrategies
second.spec_aiFieldWorker.driveStrategies={}
accepted,reason=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil and reason=="NATIVE_FIELD_COURSE_STRATEGY_UNAVAILABLE")
second.spec_aiFieldWorker.driveStrategies=originalStrategies
-- GIANTS native player-control and entry surfaces are intentionally
-- irrelevant to authority. If accidentally inspected, these probes fail.
-- Current native worker Job Episode and field-course strategy are still
-- independently required, regardless of any mission-selected vehicle.
second.getIsControlled=function()error("FORBIDDEN_PLAYER_QUERY") end
second.getIsEntered=function()error("FORBIDDEN_ENTRY_QUERY") end
g_currentMission.controlledVehicle=second
local unguarded=assert(authority:admitCandidate(first,second,first,1000))
assert(authority:isCommitmentCurrent(unguarded))
assert(authority:release(unguarded))
g_currentMission.controlledVehicle=nil
second.getIsControlled=nil
second.getIsEntered=nil
enabled=false
accepted=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil)
enabled=true
-- Product live runtime uses the independent interfaces and does not command
-- when the server is absent, regardless of a supplied candidate object.
local published={}
OuttaMyWay.VERSION="0.5.0.26"
OuttaMyWay.LogPublication={origin=function()return {
    publish=function(_,_,_,code,payload)
        published[#published+1]={code=code,detail=payload and payload()}
    end
}end}
local occurrence={}
local observer={getCurrentPairCandidates=function()
    return {{candidateIdentity=occurrence,pairKey="first|second",
        firstWorker=first,secondWorker=second,
        blockedWorker=first,confirmedBlockedMs=1000}}
end}
local runtime=Live.new(configuration,observer)
-- Distinguish a qualifying native Observation from independent admission.
-- Without field geometry, no physical Control is allowed; rejection is
-- nevertheless observable at NORMAL exactly once for this occurrence.
g_server={}
g_fieldManager.fields={}
runtime:update(16)
assert(not runtime.coordinator:isActive())
assert(#published==2 and published[1].code=="HOLD_RELOCATE_RUNTIME_ACTIVE")
assert(published[2].code=="HOLD_RELOCATE_ADMISSION_REJECTED")
assert(published[2].detail.pairKey=="first|second")
assert(published[2].detail.reason=="FIELD_POLYGON_EVIDENCE_UNAVAILABLE")
assert(published[2].detail.confirmedBlockedMs==1000)
assert(published[2].detail.playerWitness==nil
    and published[2].detail.playerEntered==nil
    and published[2].detail.participant==nil)
runtime:update(16)
assert(#published==2,"no rejection heartbeat or repeated admission in one occurrence")
-- A genuinely new native pair occurrence can be considered independently.
occurrence={}
runtime:update(16)
assert(#published==3 and published[3].code=="HOLD_RELOCATE_ADMISSION_REJECTED")
assert(not runtime.coordinator:isActive())
g_server=nil
runtime:update(16)
assert(#published==3 and not runtime.coordinator:isActive())
-- No player-control veto or diagnostic fields remain in live admission.
print("Live Pair Commitment with GIANTS job and field evidence, no player-control gate: PASS")
