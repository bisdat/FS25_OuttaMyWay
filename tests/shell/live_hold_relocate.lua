-- Native evidence -> pair role selection -> mover-only TRANSIT while moving.
-- Real production modules with GIANTS native calls mocked. No field PASS claim.
OuttaMyWay={}
dofile("scripts/coordination/NativePairCommitmentAuthority.lua")
dofile("scripts/coordination/ProjectedEgressRegion.lua")
dofile("scripts/coordination/PairTransitRegion.lua")
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
    local p=coords[node];assert(p~=nil)
    return p.x,0,p.z
end
localDirectionToWorld=function(node,x,y,z)
    return -z,y,x
end
localToWorld=function(node,x,y,z)
    local p=coords[node];assert(p~=nil)
    return p.x-z,y,p.z+x
end
local function nativeWorker(x,z,blocked)
    local node={};coords[node]={x=x,z=z}
    local job={}
    local strategy={className="AIDriveStrategyFieldCourse",isBlocked=blocked}
    local root={rootNode=node,job=job,sizeWidth=3,sizeLength=6,
        spec_aiFieldWorker={isActive=true,driveStrategies={strategy}}}
    root.getAIReverserNode=function(self)return self.rootNode end
    root.getAISteeringNode=function(self)return self.rootNode end
    root.getAIWorkAreaWidth=function()return 36 end
    root.getJob=function(self)return self.job end
    root.getAttachedImplements=function()return {} end
    root.getIsTurnedOn=function()
        error("NO_WORK_STATE_POLL_REQUIRED_FOR_TRANSIT")
    end
    root.setIsTurnedOn=function() end
    root.getIsLowered=function()return true end
    root.setLowered=function() end
    return root,strategy
end
local first,blocked=nativeWorker(20,20,true)
local second,secondStrategy=nativeWorker(23,20,false)
local authority=Authority.new(configuration)
local accepted,reason=authority:admitCandidate(first,second,first,999)
assert(accepted==nil,"persistence gate must reject short pulse")
local issued=assert(authority:admitCandidate(first,second,first,1000))
assert(issued.fieldCentroid.x==50 and issued.fieldCentroid.z==50)
assert(issued.blockerWorkingWidthM==nil
    and issued.participants[1].workingWidthM==36
    and issued.participants[2].workingWidthM==36
    and issued.offsetM==0 and #issued.nearbyBlockers==1,
    "paired geometry cannot use productive width")
assert(issued.nearbyBlockers[1].vehicle==first)
assert(authority:validateCommitment(issued))
assert(authority:getExpectedNativeJob(second)==second.job)
assert(not authority:validateCommitment({commitmentId=issued.commitmentId}))
second.job={}
assert(not authority:isCommitmentCurrent(issued))
second.job=issued.participants[2].sourceJobReference
assert(authority:isCommitmentCurrent(issued))
OuttaMyWay.NativeTranslationHoldMechanism={new=function()return {} end}
OuttaMyWay.NativeSpeedRegulationMechanism={new=function()return {} end}
OuttaMyWay.NativeReverseMechanism={new=function()return {} end}
OuttaMyWay.NativeStaticAssemblyDriveMechanism={new=function()return {} end}
OuttaMyWay.NativeTransitRequestMechanism={new=function()return {} end}
OuttaMyWay.NativeFieldworkJobReplacementMechanism={new=function()return {} end}
local physical=Control.new(authority)
local events={}
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
        assert(#plan.restoreActions==2 and #plan.foldTargets==0)
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
            assert(objective.marginM==1 and objective.regionTravelM==41
                and objective.remainingWorkingWidthM==36
                and objective.workingCorridorMarginM==5
                and objective.returnRegion.requiredProgressM==41
                and objective.returnRegion.source==
                    "PAIR_WORKING_CORRIDOR_TRAVEL_REGION")
            assert(objective.transitGeometryBasis==
                "GIANTS_SELECTED_RUNTIME_BASE_SIZE_UNION")
            assert(objective.returnRegion.isPhysicalPairClearanceConfirmed==false)
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
        assert(authority:getExpectedNativeJob(v)~=nil)
        return true,{isOldJobStopped=true,isNewJobStarted=true}
    end
}
local coordinator=Coordinator.new(authority,physical)
local ok,entry=coordinator:begin(issued,1000)
assert(ok and entry.pairedEgressImmediate==true)
assert(coordinator:getStatus().phase=="REVERSING"
    or coordinator:getStatus().phase=="PAIR_FORWARD_MOVING")
assert(#events==3 and events[1]=="REGULATE:EGRESS"
    and events[2]=="TRANSIT" and events[3]=="REVERSE",
    "the selected mover requests TRANSIT concurrently with egress")
local motion=assert(coordinator.lastPairMotionStartEvidence)
assert(motion.regionTravelM==41 and motion.remainingWorkingWidthM==36
    and motion.workingCorridorMarginM==5
    and motion.pairedEgressImmediate and motion.moverTransitRequested
    and motion.remainingWorkerConfiguration=="WORKING_UNCHANGED")
local mover=motion.relocatingAssemblyReferenceKey
local other=motion.otherAssemblyReferenceKey
local moverVehicle=mover==issued.participants[1].assemblyReferenceKey
    and first or second
local remainingVehicle=other==issued.participants[1].assemblyReferenceKey
    and first or second
assert(physical:getTransitRequests(moverVehicle)~=nil)
assert(physical:getTransitRequests(remainingVehicle)==nil,
    "remaining FIELDWORK worker must never have a TRANSIT plan")
-- The nonmover's GIANTS job can turn over while the mover travels.
-- Ongoing pair validity belongs to the mover, not the regulated partner.
local originalRemainingJob=remainingVehicle.job
remainingVehicle.job={}
assert(authority:isCommitmentCurrent(issued),
    "nonmover job change must not revoke moving assembly authority")
coordinator:advance(3000)
assert(coordinator:isActive(),"nonmover job change must not abort movement")
coordinator:advance(5999)
assert(#events==3,"pair Regulation remains active before 8 s")
coordinator:advance(6000)
assert(#events==3,"old 5 s deadline may not release pair Regulation")
local oldStrategyList=remainingVehicle.spec_aiFieldWorker.driveStrategies
remainingVehicle.spec_aiFieldWorker.driveStrategies={}
assert(authority:isCommitmentCurrent(issued),
    "nonmover strategy turnover before Regulation release must not revoke mover")
coordinator:advance(6001)
assert(coordinator:isActive())
reverse={travelledM=41,isComplete=true}
coordinator:advance(6001)
assert(events[4]=="REVERSE_STOP"
    and events[5]=="HOLD:RELOCATED_WORKER")
coordinator:advance(8999)
assert(#events==5)
coordinator:advance(9000)
assert(events[6]=="REGULATION_RELEASE:EGRESS"
    and coordinator.lastEgressRegulationResults[1].rootId==other,
    "pair nonmover's native Regulation expires at 8 s independently")
coordinator:advance(13000)
assert(#events==6)
coordinator:advance(13001)
assert(events[7]=="RELEASE:RELOCATED_WORKER"
    and events[8]=="NATIVE_STOP_START"
    and events[9]=="HANDOFF_TRANSIT"
    and #events==9,
    "no protected-worker TRANSIT restoration or job replacement")
assert(coordinator:getStatus().lastOutcome.status=="NATIVE_RESTART_ACCEPTED")
remainingVehicle.job=originalRemainingJob
remainingVehicle.spec_aiFieldWorker.driveStrategies=oldStrategyList
assert(authority:release(issued))
-- Real-world unavailable fold endpoints must not delay the mover.
local originalStatus=physical.transitStatus
physical.transitStatus=function()
    error("PAIR_FOLD_STATUS_MUST_NOT_BE_QUERIED")
end
reverse={travelledM=0,isComplete=false}
local immediate=assert(authority:admitCandidate(first,second,first,1000))
local before=#events
local began=assert(coordinator:begin(immediate,16000))
assert(began and #events==before+3 and events[#events]=="REVERSE")
assert(coordinator.lastPairMotionStartEvidence.pairedEgressImmediate)
-- The mover's own GIANTS job turnover MUST revoke its authority and clean
-- up its independent Control. Removing the pair-wide gate does not weaken it.
local activeMover=assert(coordinator.active.relocator.vehicle)
local activeMoverJob=activeMover.job
activeMover.job={}
coordinator:advance(16100)
assert(not coordinator:isActive()
    and coordinator.lastOutcome.status=="RELINQUISHED"
    and coordinator.lastOutcome.reason=="GIANTS_JOB_EPISODE_CHANGED")
assert(events[#events]=="RESTORE",
    "mover turnover must restore only the controlled mover TRANSIT")
activeMover.job=activeMoverJob
assert(authority:release(immediate))
physical.transitStatus=originalStatus
-- Field too small for all full-distance options still produces a
-- last-resort outcome without controlling either worker's configuration.
g_fieldManager.fields={{densityMapPolygon={
    pointsX={19,24,24,19},pointsZ={18,18,22,22}}}}
local restricted=assert(authority:admitCandidate(first,second,first,1000))
before=#events
local admittedRestricted,why=coordinator:begin(restricted,30000)
assert(not admittedRestricted and not coordinator:isActive()
    and coordinator:getStatus().lastOutcome.status=="NO_FEASIBLE_PAIR_EGRESS"
    and #events==before)
assert(authority:release(restricted))
g_fieldManager.fields={{densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}}}}
-- Missing field, job, strategy and player-control evidence contract.
g_fieldManager.fields={}
accepted,reason=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil and reason=="FIELD_POLYGON_EVIDENCE_UNAVAILABLE")
g_fieldManager.fields={{densityMapPolygon={
    pointsX={0,100,100,0},pointsZ={0,0,100,100}}}}
local oldJob=second.getJob
second.getJob=nil
accepted,reason=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil and reason=="NATIVE_JOB_REFERENCE_UNAVAILABLE")
second.getJob=oldJob
local oldStrategies=second.spec_aiFieldWorker.driveStrategies
second.spec_aiFieldWorker.driveStrategies={}
accepted,reason=authority:admitCandidate(first,second,first,1000)
assert(accepted==nil and reason=="NATIVE_FIELD_COURSE_STRATEGY_UNAVAILABLE")
second.spec_aiFieldWorker.driveStrategies=oldStrategies
second.getIsControlled=function()error("FORBIDDEN_PLAYER_QUERY")end
second.getIsEntered=function()error("FORBIDDEN_ENTRY_QUERY")end
g_currentMission.controlledVehicle=second
local unguarded=assert(authority:admitCandidate(first,second,first,1000))
assert(authority:isCommitmentCurrent(unguarded))
assert(authority:release(unguarded))
g_currentMission.controlledVehicle=nil
second.getIsControlled=nil
second.getIsEntered=nil
enabled=false
assert(authority:admitCandidate(first,second,first,1000)==nil)
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
coords[second.rootNode]={x=110,z=50}
-- This exterior fixture faces north: its 70-degree native reverse can
-- actually aim westward back into the native course field. Earlier
-- eastward-backward orientation could not support that inward objective.
local previousDirection=localDirectionToWorld
localDirectionToWorld=function(node,x,y,z)
    if node==second.rootNode then return 0,y,z end
    return previousDirection(node,x,y,z)
end
secondStrategy.aiFieldCourse={fieldCourse={courseField={
    boundaryPositions={{0,0},{100,0},{100,100},{0,100}}
}}}
local exterior=assert(authority:admitSingleCandidate(second,1000))
assert(exterior.kind=="SINGLE" and exterior.fieldPolygon==nil)
reverse={travelledM=0,isComplete=false}
before=#events
local startedExterior,exteriorDetails=coordinator:begin(exterior,30000)
assert(startedExterior
    and exteriorDetails.objective.fieldIdentitySource=="GIANTS_ACTIVE_COURSE_FIELD"
    and exteriorDetails.objective.egressSide==-1
    and exteriorDetails.objective.targetInField==true,
    "recovery selects native OWN field even with no g_fieldManager")
assert(events[before+1]=="TRANSIT" and events[before+2]=="REVERSE")
reverse={travelledM=40,isComplete=true}
coordinator:advance(30001)
assert(events[before+3]=="REVERSE_STOP"
    and events[before+4]=="NATIVE_STOP_START"
    and events[before+5]=="HANDOFF_TRANSIT")
assert(#events==before+5,"outside-field solo recovery has no Hold timer")
assert(authority:release(exterior))
localDirectionToWorld=previousDirection
coords[second.rootNode]={x=23,z=20}
secondStrategy.aiFieldCourse={}
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
OuttaMyWay.VERSION="0.5.1.3"
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
