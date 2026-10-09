-- Contract challenge for the live observation -> Pair Commitment -> physical path.
-- GIANTS job, field polygon, fold and drive operations are mocked; Reality untested.
OuttaMyWay={}
dofile("scripts/coordination/NativePairCommitmentAuthority.lua")
dofile("scripts/coordination/ProjectedEgressRegion.lua")
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
localDirectionToWorld=function(node,x,y,z)
    return -z,y,x
end
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
    root.getAIReverserNode=function(self)return self.rootNode end
    root.getAISteeringNode=function(self)return self.rootNode end
    root.getAIWorkAreaWidth=function()return 36 end
    root.getJob=function(self)return self.job end
    root.getAttachedImplements=function()return {} end
    root.getIsTurnedOn=function()return true end
    root.setIsTurnedOn=function() end
    root.getIsLowered=function()return true end
    root.setLowered=function() end
    return root,strategy
end
local first,blocked=nativeWorker(20,20,true)
local second,secondStrategy=nativeWorker(23,20,false)
local authority=Authority.new(configuration)
local accepted,reason=authority:admitCandidate(first,second,first,999)
assert(accepted==nil,"persistence gate must reject a short pulse")
local issued=assert(authority:admitCandidate(first,second,first,1000))
assert(issued.fieldCentroid.x==50 and issued.fieldCentroid.z==50)
assert(issued.offsetM==0 and issued.blockerWorkingWidthM==36 and #issued.nearbyBlockers==1)
assert(type(issued.fieldPolygon)=="table")
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
OuttaMyWay.NativeSpeedRegulationMechanism={new=function()return {} end}
OuttaMyWay.NativeReverseMechanism={new=function()return {} end}
OuttaMyWay.NativeTransitRequestMechanism={new=function()return {} end}
OuttaMyWay.NativeFieldworkJobReplacementMechanism={new=function()return {} end}
local physical=Control.new(authority)
local events={}
-- Replace subordinate native mechanisms only in this offline challenge.
physical.regulationMechanism={
    regulate=function(_,v,p)events[#events+1]="REGULATE:"..p;return true end,
    releaseRegulation=function(_,v,p)
        events[#events+1]="REGULATION_RELEASE:"..p
        return true,{interceptionCount=4,physicalDisplacementM=0.75}
    end,
    refreshInstallation=function()end
}
physical.holdMechanism={
    hold=function(_,v,p)events[#events+1]="HOLD:"..p;return true end,
    releaseHold=function(_,v,p)
        events[#events+1]="RELEASE:"..p
        return true,{interceptionCount=4,physicalDisplacementM=0.75}
    end
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
        if objective.returnRegion.source=="SINGLE_REVERSE_REGION" then
            assert(objective.maxTravelM==nil and objective.steeringHorizonM==80)
            assert(objective.returnRegion.requiredProgressM==40
                and objective.returnRegion.blockerOriginX==nil)
            assert(objective.vectorDistanceM==40 and objective.marginM==nil)
            assert(objective.directionSource=="SINGLE_OBLIQUE_REVERSE")
        else
            assert(objective.maxTravelM==nil and objective.steeringHorizonM==81)
            assert(objective.returnRegion.requiredProgressM>38)
            assert(objective.vectorDistanceM==41 and objective.marginM==5)
            assert(objective.targetInField and objective.directionSource=='OBLIQUE_REVERSE')
        end
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
-- No past FIELDWORK attempt state may veto current TRANSIT restoration.
local coordinator=Coordinator.new(authority,physical)
local ok,entry=coordinator:begin(issued,1000)
assert(ok and entry.relocatingAssemblyReferenceKey==issued.participants[2].assemblyReferenceKey)
assert(entry.objective.returnRegion.requiredProgressM>38
    and entry.vectorDistanceM==41 and entry.blockerWorkingWidthM==36)
assert(events[1]=="REGULATE:EGRESS" and events[2]=="TRANSIT" and events[3]=="REVERSE")
assert(coordinator:getStatus().phase=="REVERSING")
coordinator:advance(5999)
assert(#events==3,"reverse already started, blocker Hold not yet released")
coordinator:advance(6000)
assert(events[4]=="REGULATION_RELEASE:EGRESS")
assert(#coordinator.lastEgressRegulationResults==1)
assert(coordinator.lastEgressRegulationResults[1].rootId==
    issued.participants[1].assemblyReferenceKey)
assert(coordinator.lastEgressRegulationResults[1].interceptCount==4
    and coordinator.lastEgressRegulationResults[1].displacementM==0.75)
reverse={travelledM=20,isComplete=true}
coordinator:advance(6001)
assert(events[5]=="REVERSE_STOP" and events[6]=="HOLD:RELOCATED_WORKER")
coordinator:advance(13000)
assert(#events==6)
coordinator:advance(13001)
assert(events[7]=="RELEASE:RELOCATED_WORKER")
assert(events[8]=="NATIVE_STOP_START" and events[9]=="HANDOFF_TRANSIT")
assert(coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
assert(authority:release(issued))
physical.plans[second]={transitActions={},restoreActions={}}
assert(physical:cancelTransit(second))
assert(events[#events]=="RESTORE")
-- A confined field denies the Return Region before any Control.
g_fieldManager.fields={{densityMapPolygon={
    pointsX={0,30,30,0},pointsZ={0,0,30,30}}}}
local restricted=assert(authority:admitCandidate(first,second,first,1000))
local rejected,geoReason=coordinator:begin(restricted,30000)
assert(not rejected and geoReason=="NO_SUPPORTED_INFIELD_EGRESS_REGION")
assert(authority:release(restricted))
g_fieldManager.fields={{densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}}}}
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

-- Separate single-worker admission shares physical Control, not the pair
-- blocker membership, selection, Regulation or timer-only 7s Hold phase.
secondStrategy.isBlocked=true
g_currentMission.aiSystem={activeJobVehicles={[second]=true}}
local under,reason=authority:admitSingleCandidate(second,999)
assert(under==nil and reason=="SINGLE_ADMISSION_UNAVAILABLE")
local soloCommitment=assert(authority:admitSingleCandidate(second,1000))
assert(soloCommitment.kind=="SINGLE"
    and #soloCommitment.participants==1
    and #soloCommitment.nearbyBlockers==0
    and soloCommitment.singleRegionDistanceM==40)
assert(authority:validateCommitment(soloCommitment))
assert(authority:getExpectedNativeJob(second)==second.job)
assert(soloCommitment.fieldPolygon==nil and soloCommitment.fieldCentroid==nil,
    "solo BWR must not require a field polygon")
local before=#events
reverse={travelledM=0,isComplete=false}
local soloOk,soloDetails=coordinator:begin(soloCommitment,20000)
assert(soloOk and soloDetails.vectorDistanceM==40)
assert(#events==before+2 and events[before+1]=="TRANSIT"
    and events[before+2]=="REVERSE",
    "no other-worker Regulation during solo recovery")
coordinator:advance(26000)
assert(#events==before+2,"no Regulation timer or paired Hold in solo phase")
reverse={travelledM=40,isComplete=true}
coordinator:advance(26001)
assert(events[before+3]=="REVERSE_STOP")
assert(events[before+4]=="NATIVE_STOP_START"
    and events[before+5]=="HANDOFF_TRANSIT",
    "solo must stop/start immediately after the achieved region")
assert(#events==before+5,"no extra Hold or invented blocker")
assert(coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
assert(authority:release(soloCommitment))
local freshSolo=assert(authority:admitSingleCandidate(second,1000))
assert(freshSolo~=soloCommitment and authority:release(freshSolo),
    "later solo blockage remains independently admissible")
-- Reproduce the real TS003 failure mode: a currently blocked FIELDWORK
-- assembly is outside every registered polygon. Admission and physical
-- 40 m relocation must proceed with no field association.
g_fieldManager.fields={}
coords[second.rootNode]={x=300,z=300}
local exterior=assert(authority:admitSingleCandidate(second,1000))
assert(exterior.kind=="SINGLE" and exterior.fieldPolygon==nil)
reverse={travelledM=0,isComplete=false}
before=#events
assert(coordinator:begin(exterior,30000))
assert(events[before+1]=="TRANSIT" and events[before+2]=="REVERSE")
reverse={travelledM=40,isComplete=true}
coordinator:advance(30001)
assert(events[before+3]=="REVERSE_STOP"
    and events[before+4]=="NATIVE_STOP_START"
    and events[before+5]=="HANDOFF_TRANSIT")
assert(#events==before+5,"outside-field solo recovery has no Hold timer")
assert(authority:release(exterior))
coords[second.rootNode]={x=23,z=20}
g_fieldManager.fields={{densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}}}}
g_currentMission.aiSystem.activeJobVehicles[first]=true
coords[first.rootNode]={x=24,z=20}
under,reason=authority:admitSingleCandidate(second,1000)
assert(under==nil and reason=="SINGLE_WORKER_PAIR_NOW_LOCAL",
    "single admission must recheck nearby native workers")
g_currentMission.aiSystem.activeJobVehicles[first]=nil
coords[first.rootNode]={x=20,z=20}

-- Product live runtime uses the independent interfaces and does not command
-- when the server is absent, regardless of a supplied candidate object.
local published={}
OuttaMyWay.VERSION="0.5.1.2"
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
-- A solo native occurrence is admitted without field-polygon evidence.
-- Runtime publication must report the started intervention, not rejection.
observer.getCurrentPairCandidates=function()return {} end
local soloOccurrence={}
observer.getCurrentSingleCandidates=function()return {
    {candidateIdentity=soloOccurrence,worker=second,confirmedBlockedMs=1000}
} end
runtime:update(16)
assert(#published==3,"client cannot admit solo candidates")
g_server={}
local startedSolo=0
runtime.coordinator.begin=function(_,commitment)
    assert(commitment.kind=="SINGLE"
        and commitment.singleRegionDistanceM==40
        and commitment.fieldPolygon==nil)
    startedSolo=startedSolo+1
    return true,{regionRequiredProgressM=40,vectorDistanceM=40,
        directionSource="SINGLE_OBLIQUE_REVERSE"}
end
runtime:update(16)
assert(startedSolo==1 and #published==4
    and published[4].code=="HOLD_RELOCATE_STARTED")
runtime:update(16)
assert(startedSolo==1 and #published==4,
    "one intervention admission per solo blocked occurrence")
-- No player-control veto or diagnostic fields remain in live admission.
print("Live Pair Commitment with GIANTS job and field evidence, no player-control gate: PASS")
