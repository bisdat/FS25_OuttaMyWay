-- TEST 0.5.5.7: completion settlement is a separate, opt-in,
-- finite physical-Control lifecycle. No GIANTS movement in this fixture.
OuttaMyWay={VERSION="0.5.test"}
local events={}
local diagnosticEnabled=false
OuttaMyWay.LogPublication={origin=function()
    return {isEligible=function(_,class)
        return diagnosticEnabled and class=="DIAGNOSTIC"
    end,
    publish=function(_,_,_,code,payload)
        events[#events+1]={code=code,fields=payload()}
    end}
end}
local marginBegins,marginAdvances=0,0
OuttaMyWay.ExteriorMarginComparison={
    beginComparison=function(vehicle)
        marginBegins=marginBegins+1
        return {rootNode=vehicle.rootNode}
    end,
    advanceComparison=function(session)
        marginAdvances=marginAdvances+1
        return "DONE",{rootNode=session.rootNode,fieldId=29,
            nearestEdge=7,frames={{index=7},{index=1}},
            rows={{edge=7},{edge=1}},truncated=false}
    end,
    summarize=function()return "1:nominal8/18;7:nominal2/18" end
}
local driveCalls={}
local failure
local failCancel=false
local forceStopRefusal=false
local freezeBoundaryMovement=false
OuttaMyWay.NativeStaticAssemblyDriveMechanism={new=function()
    return {
        active=nil,
        startMovement=function(self,vehicle,objective)
            assert(type(objective.moveForwards)=="boolean")
            assert(objective.maximumSpeedKmh>8
                and objective.maximumSpeedKmh<60,
                "local guidance speed must respond to target horizon")
            assert(objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG")
            if not objective.moveForwards then
                assert(type(objective.steeringTargetX)=="number"
                    and type(objective.steeringTargetZ)=="number",
                    "straight parking reverse must separate look-through from waypoint")
                assert(math.sqrt((objective.steeringTargetX-objective.targetX)^2+
                    (objective.steeringTargetZ-objective.targetZ)^2)>30,
                    "short terminal waypoint is not the long reverse steering target")
            end
            driveCalls[#driveCalls+1]="START"
            self.active={vehicle=vehicle,objective=objective}
            return true
        end,
        retargetSettlement=function(self,vehicle,objective)
            assert(self.active and self.active.vehicle==vehicle)
            assert(self.active.objective.moveForwards==objective.moveForwards,
                "a direction change must require a real stop")
            driveCalls[#driveCalls+1]="RETARGET"
            self.active.objective=objective
            return true
        end,
        movementStatus=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            if failure then return {isFailed=true,reason=failure} end
            local target=self.active.objective
            if not freezeBoundaryMovement then
                vehicle.x,vehicle.z=target.targetX,target.targetZ
            end
            return {isComplete=true}
        end,
        beginSettlementStop=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            assert(self.active.objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG")
            if forceStopRefusal then
                return false,"SETTLEMENT_STOP_NOT_ADMITTED"
            end
            driveCalls[#driveCalls+1]="BRAKE"
            return true
        end,
        settlementStopStatus=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            driveCalls[#driveCalls+1]="BRAKING"
            return {isStopped=true,speedMps=0,steadyMs=1200,cruiseState=0}
        end,
        stopMovement=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            driveCalls[#driveCalls+1]="STOP"
            self.active=nil
            return true
        end,
        cancelMovement=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            driveCalls[#driveCalls+1]="CANCEL"
            self.active=nil
            if failCancel then return false,"NATIVE_NEUTRAL_NOT_CONFIRMED" end
            return true
        end,
        discardOnMapDelete=function(self,vehicle)
            driveCalls[#driveCalls+1]="MAP_DELETE"
            self.active=nil
            return true
        end
    }
end}
local route={
    field=77,edge=9,memberCount=1,estimatedTravelM=32,
    method="REVERSE_FORWARD",reverseM=10,guideRadiusM=18,
    legs={
        {name="REVERSE_POSITIONING",point={x=-5,z=10},
            moveForwards=false},
        {name="REVERSE_POSITIONING",point={x=-10,z=10},
            moveForwards=false},
        {name="FORWARD_GUIDANCE",point={x=5,z=10},
            moveForwards=true},
        {name="FORWARD_GUIDANCE",point={x=10,z=12},
            moveForwards=true},
        {name="FORWARD_GUIDANCE",point={x=15,z=12},
            moveForwards=true}
    }
}
local routeCalls,terminalCalls=0,0
local failTerminal=false
local correctionAllowed=false
local correctionCurved=false
local correctionCalls=0
local planAdvances=0
local forcePlanPending=false
local localFallback=false
OuttaMyWay.CompletionSettlementRoute={
    beginPlan=function()
        routeCalls=routeCalls+1
        return {advances=0,spent=0}
    end,
    advancePlan=function(session,units)
        assert(units>0 and units<=2048)
        planAdvances=planAdvances+1
        session.advances=session.advances+1
        session.spent=session.spent+units
        if forcePlanPending then return "PENDING" end
        if localFallback then
            localFallback=false
            return "FAILED",nil,"NO_POSE_REACHABLE_PARKING_REGION"
        end
        return "DONE",route
    end,
    verifyTerminal=function()
        terminalCalls=terminalCalls+1
        if failTerminal then
            return false,"WHOLE_ASSEMBLY_NOT_IN_INTERFIELD_PARKING_REGION",
                "TERMINAL_MEMBER_INTERSECTS_SOURCE"
        end
        return true,"WHOLE_NOMINAL_ASSEMBLY_OUTSIDE_SOURCE_FIELD"
    end,
    planTerminalCorrection=function(_,old)
        correctionCalls=correctionCalls+1
        if not correctionAllowed then
            return nil,"NO_QUALIFIED_SHORT_TERMINAL_CORRECTION"
        end
        correctionAllowed=false
        local copy={}
        for k,v in pairs(old) do copy[k]=v end
        copy.terminalPose={x=19,z=12}
        copy.method=correctionCurved and "STOPPED_TERMINAL_ALIGNMENT"
            or "STOPPED_TERMINAL_CORRECTION"
        copy.legs={}
        if correctionCurved then
            copy.legs[1]={name="TERMINAL_HEADING_GUIDANCE",
                point={x=10,z=10},moveForwards=true,arrivalRadiusM=0.75}
        end
        copy.legs[#copy.legs+1]={name="TERMINAL_PLACEMENT_CORRECTION",
            point={x=19,z=12},moveForwards=true,
            arrivalRadiusM=correctionCurved and 0.75 or nil}
        return copy
    end
}
local boundaryAllowed=false
local boundaryForceRefusal=false
local boundaryBegins=0
local boundaryAdvanced=0
local boundaryLiveGuard=true
OuttaMyWay.CompletionBoundaryExitContinuation={
    beginPlan=function(subject,sourceField,selectedEdge)
        boundaryBegins=boundaryBegins+1
        if not boundaryAllowed then return nil,"NO_SAFE_FORWARD_EXIT" end
        return {advances=0,spent=0,reasonCounts={},
            edgeIndex=selectedEdge,vehicle=subject,initialX=subject.x or 0,
            initialZ=subject.z or 0}
    end,
    advancePlan=function(plan,units)
        boundaryAdvanced=boundaryAdvanced+1
        plan.advances=plan.advances+1
        plan.spent=plan.spent+math.min(units,160)
        if boundaryForceRefusal then
            return "FAILED",nil,"NO_QUALIFIED_BOUNDARY_EXIT_CONTINUATION"
        end
        local target={x=plan.initialX+2.75,z=plan.initialZ}
        return "DONE",{mode="BOUNDARY_CLEARANCE_STEP",
            field=29,edge=7,memberCount=2,
            estimatedTravelM=2.75,nominalStepM=2.75,requiredForwardM=2,
            method="OBSERVED_STRADDLING_FORWARD_2M",
            terminalPose=target,terminalArrivalRadiusM=0.75,
            stepOrigin={x=plan.initialX,z=plan.initialZ,fx=1,fz=0},
            legs={{name="BOUNDARY_CLEARANCE_FORWARD",
                point=target,moveForwards=true,arrivalRadiusM=0.75}}}
    end,
    guard=function()
        return boundaryLiveGuard,"BOUNDARY_STEP_LIVE_GUARD_DENIED"
    end
}
local directDestinationBegins=0
OuttaMyWay.CompletionDestinationRouteAssessment={
    beginPlan=function()
        directDestinationBegins=directDestinationBegins+1
        return {spent=0,advances=0,order={{
            edgeIndex=1,selectionRank=1,usableLongitudinalM=100}}}
    end,
    priorityPreview=function()return "1:rank1:usable100" end,
    advancePlan=function(session,units)
        session.advances=session.advances+1
        session.spent=session.spent+units
        if forcePlanPending then return "PENDING" end
        return "DONE",route
    end
}
local refuseExtendedScene=false
local directAllocation=false
local allocationStalled=false
local lastAllocationDisposition=nil
local occupancyDisposition="INSIDE"
local qualifiedExtendedRoute
local repositionAllowed=false
local repositionPlans=0
local extendedAdvanceCalls=0
local activeConflict=false
local mismatchClaim=false
OuttaMyWay.ParkingRegionAllocation={
    beginPlan=function(_,_,_,disposition)
        lastAllocationDisposition=disposition
        return {advances=0,spent=0}
    end,
    advancePlan=function(session,units)
        session.advances=session.advances+1
        session.spent=session.spent+units
        if allocationStalled then return "PENDING" end
        if refuseExtendedScene then return "FAILED",nil,"WORKER_SCENE_AI_STATUS_UNAVAILABLE" end
        return "DONE",{entryPose={x=25,z=-30,fx=1,fz=0},
            terminalPose={x=40,z=20},ownRadius=5,
            stationMin=0,stationMax=100,station=50,
            qualifiedApproachRoute=not directAllocation and
                qualifiedExtendedRoute or nil,
            qualifiedDirectRoute=directAllocation and route or nil}
    end,
    claim=function(ledger,vehicle,terminal,radius)
        ledger[vehicle]={x=terminal.x,z=terminal.z,radius=radius or 5}
        return ledger[vehicle]
    end,
    claimForRoute=function(ledger,vehicle,planned)
        ledger[vehicle]={x=15,z=12,radius=5}
        return ledger[vehicle]
    end,
    claimClear=function(ledger,vehicle)
        return ledger[vehicle]~=nil,"TERMINAL_CLAIM_MISSING"
    end,
    matchesClaim=function()
        return not mismatchClaim,"LOCAL_ROUTE_MISSES_CLAIMED_TERMINAL"
    end,
    claimCurrent=function(ledger,vehicle)return ledger[vehicle]end,
    release=function(ledger,vehicle)ledger[vehicle]=nil end
}

OuttaMyWay.SettlementPhysicalOccupancy={
    routeClear=function()return true end,
    nextClear=function()return true end
}
OuttaMyWay.ExtendedInfieldApproach={
    planReposition=function()
        repositionPlans=repositionPlans+1
        if not repositionAllowed then
            return nil,"NO_QUALIFIED_INFIELD_REPOSITION"
        end
        return {mode="REPOSITION_INFIELD",
            field=77,edge=9,memberCount=2,
            method="INFIELD_STRAIGHT_REVERSE",
            poly={},estimatedTravelM=8,reverseM=8,
            nominalMarginGainM=3,
            legs={{name="REPOSITION_REVERSE",
                point={x=-4,z=0},moveForwards=false,
                arrivalRadiusM=0.75},
                {name="REPOSITION_REVERSE",
                point={x=-8,z=0},moveForwards=false,
                arrivalRadiusM=0.75}}}
    end,
    beginPlan=function()
        return {advances=0,spent=0}
    end,
    advancePlan=function(session,units)
        extendedAdvanceCalls=extendedAdvanceCalls+1
        session.advances=session.advances+1
        session.spent=session.spent+units
        if refuseExtendedScene then
            session.sceneEvidence={registry="MISSION_VEHICLE_SYSTEM",
                scanned=3,observedWorkers=1,outsideField=2,
                nonAiRoots=0,failureRoot="220"}
            return "FAILED",nil,"WORKER_SCENE_AI_STATUS_UNAVAILABLE"
        end
        return "DONE",{mode="EXTENDED_INFIELD",field=77,edge=9,
            method="HEADING_LATTICE_INFIELD",
            estimatedTravelM=16,guideRadiusM=20,memberCount=1,
            reverseM=0,legs={
                {name="EXTENDED_INFIELD_GUIDANCE",
                    point={x=8,z=0},moveForwards=true},
                {name="EXTENDED_INFIELD_GUIDANCE",
                    point={x=16,z=0},moveForwards=true}
            }}
    end,
    guard=function()
        return not activeConflict,"PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED"
    end
}
qualifiedExtendedRoute={mode="EXTENDED_INFIELD",field=77,edge=9,
    method="HEADING_LATTICE_INFIELD",
    entryPose={x=25,z=-30,fx=1,fz=0},estimatedTravelM=16,
    guideRadiusM=20,memberCount=1,reverseM=0,
    legs={{name="EXTENDED_INFIELD_GUIDANCE",point={x=8,z=0},moveForwards=true},
        {name="EXTENDED_INFIELD_GUIDANCE",point={x=16,z=0},moveForwards=true}}}
local enabled=true
g_server={}
local config={isResolved=function()return true end,
    isEnabled=function()return enabled end}
local physicalBoundaryTestSubject=nil
getWorldTranslation=function(node)
    if physicalBoundaryTestSubject~=nil
        and node==physicalBoundaryTestSubject.rootNode then
        return physicalBoundaryTestSubject.x or 0,0,
            physicalBoundaryTestSubject.z or 0
    end
    -- Else the drive mock owns physical-leg success independently.
    return 0,0,0
end
-- Source Field is observed independently from the native completion job.
-- The lifecycle fixture isolates Control; spatial containment has its own test.
local membershipCalls=0
local missingMembership=false
local fieldOverride=nil
OuttaMyWay.CompletionFieldMembership={identify=function(vehicle)
    membershipCalls=membershipCalls+1
    if missingMembership then return nil,"ASSEMBLY_OUTSIDE_REGISTERED_FIELDS" end
    return {fieldId=fieldOverride or 77,rootNode=vehicle.rootNode,
        provenance="ASSEMBLY_ROOT_REGISTERED_POLYGON_MEMBERSHIP"}
end}
OuttaMyWay.CompletionAssemblyFieldOccupancy={assess=function(_,sourceField)
    return {status=occupancyDisposition,sourceFieldId=sourceField.fieldId,
        memberCount=2,intersectingMembers=occupancyDisposition=="CLEAR"
            and 0 or 1}
end}
dofile("scripts/control/CompletionSettlementRuntime.lua")
local Runtime=OuttaMyWay.CompletionSettlementRuntime
local a={rootNode=12,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local b={rootNode=24,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local runtime=Runtime.new(config)
enabled=false
assert(not runtime:onNativeCompletion({},a))
assert(membershipCalls==0,"disabled parking must not scan registered fields")
assert(#driveCalls==0 and routeCalls==0,
    "disabled parking must not move")
enabled=true
assert(runtime:onNativeCompletion({},a))
assert(#driveCalls==0 and routeCalls==1 and runtime.pending~=nil,
    "successful native completion must not synchronously actuate")
forcePlanPending=true
runtime:update(16)
assert(#driveCalls==0 and runtime.pending~=nil,
    "planning may not command any motor or steer")
forcePlanPending=false
runtime:update(16)
assert(#driveCalls==1 and runtime.pending==nil,
    "only a completed planned route can begin physical Control")
for i=1,9 do runtime:update(16) end
assert(runtime.active==nil and #driveCalls==11,
    "two physical stops, not five per-guidance-point stops")
assert(driveCalls[1]=="START" and driveCalls[2]=="RETARGET"
    and driveCalls[3]=="BRAKE" and driveCalls[5]=="STOP"
    and driveCalls[6]=="START" and driveCalls[7]=="RETARGET"
    and driveCalls[8]=="RETARGET" and driveCalls[11]=="STOP")
assert(terminalCalls==1,"terminal must be independently verified")
assert(events[#events].code=="COMPLETION_SETTLEMENT_FINISHED")
assert(not runtime:onNativeCompletion({},a),
    "same completed vehicle never re-admits in one map")
assert(runtime:onNativeCompletion({},b))
assert(runtime.pending~=nil and runtime.active==nil)
enabled=false
runtime:update(16)
assert(runtime.active==nil and runtime.pending==nil
    and driveCalls[#driveCalls]=="STOP",
    "disable must abandon pending planning without ever driving")
-- Once planning is complete, disable still cancels an actual lease.
enabled=true
local duringMotion={rootNode=25,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},duringMotion))
runtime:update(16)
assert(runtime.active~=nil)
enabled=false
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "disable must cancel active native steering")
enabled=true
local c={rootNode=36,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},c))
runtime:update(16)
c.getCurrentAIJob=function()return {} end
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "new GIANTS job supersedes prototype Control")
local d={rootNode=48,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},d))
runtime:update(16)
failure="NATIVE_STEERING_FAILED"
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "native steering fault must neutralise Control")
failure=nil
local e={rootNode=60,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},e))
runtime:update(16)
runtime:deleteMap()
assert(runtime.active==nil and driveCalls[#driveCalls]=="MAP_DELETE",
    "map teardown cannot issue stale engine Control")
-- When no local route exists, the same worker may receive a separately
-- planned long approach; it MUST stop and release before replanning locally.
runtime:loadMap()
local distant={rootNode=190,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local callsBefore=#driveCalls
localFallback=true
assert(runtime:onNativeCompletion({},distant))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE"
    and #driveCalls==callsBefore,
    "failed local search must first assess a qualified parking region")
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="EXTENDED")
runtime:update(16)
assert(runtime.active and runtime.active.route==qualifiedExtendedRoute
    and extendedAdvanceCalls==0,
    "prequalified route must be executed, never advanced as a session")
assert(driveCalls[#driveCalls]=="START")
-- The second native completion is retained; only ONE physical driver
-- may operate until its independent settlement turn begins.
local nextWorker={rootNode=192,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},nextWorker))
assert(#runtime.waiting==1 and runtime.waiting[1].vehicle==nextWorker)
assert(not runtime:onNativeCompletion({},nextWorker),
    "a queued native completion is never accepted twice")
runtime:update(16) -- first short target retarget
assert(driveCalls[#driveCalls]=="RETARGET")
runtime:update(16) -- final point starts physical stopping
assert(driveCalls[#driveCalls]=="BRAKE")
runtime:update(16) -- mock reports stillness and performs final release
assert(runtime.pending and runtime.pending.kind=="LOCAL_HANDOFF")
assert(driveCalls[#driveCalls]=="STOP")
runtime:update(16) -- local planner admitted only after approach stopped
assert(runtime.active and runtime.active.route.mode==nil)
assert(driveCalls[#driveCalls]=="START")
for i=1,9 do
    runtime:update(16)
    if terminalCalls==2 then break end
end
assert(runtime.active==nil and runtime.pending==nil and terminalCalls==2)
assert(#runtime.waiting==1)
runtime:update(16)
assert(runtime.pending and runtime.pending.vehicle==nextWorker
    and #runtime.waiting==0,"second worker must get its OWN new planning episode")
runtime:update(16)
assert(runtime.active and runtime.active.vehicle==nextWorker)
for i=1,9 do runtime:update(16) end
assert(runtime.active==nil and terminalCalls==3)
-- A confirmed-stop LOCAL_HANDOFF worker yields exactly once when a
-- subsequently completed peer occupies its only local parking route.
local blocked={rootNode=196,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local ahead={rootNode=197,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local deferredJob={}
runtime.attempted[blocked]=true
runtime.attempted[ahead]=true
runtime.pending={vehicle=blocked,job=deferredJob,sourceField={fieldId=77},
    plan={advances=0,spent=0},kind="LOCAL_HANDOFF",elapsedMs=0,
    phase="PLANNING",driveArmed=false}
runtime.waiting={{vehicle=ahead,job={},sourceField={fieldId=77}}}
local callsBeforeDeferral=#driveCalls
localFallback=true
runtime:update(16)
assert(runtime.active==nil and runtime.pending==nil
    and #driveCalls==callsBeforeDeferral)
assert(#runtime.waiting==2 and runtime.waiting[1].vehicle==ahead
    and runtime.waiting[2].vehicle==blocked
    and events[#events].code=="COMPLETION_SETTLEMENT_ALTERNATIVE_QUEUED",
    "physically stopped worker must yield to the queued peer, not collide")
runtime:update(16)
assert(runtime.pending and runtime.pending.vehicle==ahead)
runtime:update(16)
assert(runtime.active and runtime.active.vehicle==ahead)
for i=1,12 do
    runtime:update(16)
    if terminalCalls==4 then break end
end
assert(runtime.active==nil and terminalCalls==4)
runtime:update(16)
assert(runtime.pending and runtime.pending.vehicle==blocked)
runtime:update(16)
assert(runtime.active and runtime.active.vehicle==blocked)
for i=1,12 do
    runtime:update(16)
    if terminalCalls==5 then break end
end
assert(runtime.active==nil and terminalCalls==5
    and runtime.replans[blocked]==1)
assert(not runtime:onNativeCompletion({},blocked),
    "yielding is bounded, not a second native completion event")
-- Reproduce the TS019-style no-short-route / failed worker-scene path.
-- A failed census reports the exact witnessed limitation but can never
-- hand control to the native driver, or retry the same completed job.
local refused={rootNode=191,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
refuseExtendedScene=true
local beforeRefusal=#driveCalls
assert(runtime:onNativeCompletion({},refused))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE")
runtime:update(16)
assert(runtime.active==nil and runtime.pending==nil
    and #driveCalls==beforeRefusal,
    "unknown relevant worker must refuse before physical actuation")
assert(runtime.claims[refused]==nil
    and events[#events].fields.reason=="WORKER_SCENE_AI_STATUS_UNAVAILABLE")
assert(events[#events].code=="COMPLETION_SETTLEMENT_NOT_ADMITTED")
assert(not runtime:onNativeCompletion({},refused),
    "same native completion must not start a new search after census veto")
refuseExtendedScene=false
-- During a real extended lease, invalidated space must first cause
-- physical braking and a stable released stop; only then can allocator
-- seek an alternative station. It must not issue a new START beforehand.
local reroute={rootNode=199,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},reroute))
runtime:update(16) -- initial local refusal => allocation
assert(runtime.pending and runtime.pending.kind=="ALLOCATE")
runtime:update(16) -- qualified terminal claimed => targeted extended
assert(runtime.pending and runtime.pending.kind=="EXTENDED")
runtime:update(16) -- extended native steering admitted
assert(runtime.active and runtime.active.route.mode=="EXTENDED_INFIELD")
local beforeConflict=#driveCalls
activeConflict=true
runtime:update(16)
assert(runtime.active and runtime.active.phase=="STOP_FOR_ALTERNATIVE"
    and driveCalls[#driveCalls]=="BRAKE",
    "occupied next target must trigger a real braking phase")
runtime:update(16)
assert(runtime.active==nil and runtime.pending
    and runtime.pending.kind=="ALLOCATE"
    and driveCalls[#driveCalls]=="STOP"
    and #driveCalls==beforeConflict+3
    and driveCalls[beforeConflict+1]=="BRAKE"
    and driveCalls[beforeConflict+2]=="BRAKING",
    "alternative planning cannot start a new motor before positive stop")
activeConflict=false
assert(runtime.replans[reroute]==1)
-- No second route retry may bypass positive stopping or loop indefinitely.
runtime:loadMap()
-- A native cancellation without positive neutralisation evidence must
-- RETAIN its claim. Another completed worker cannot reuse that location
-- on the assumption that the previous driver definitely stopped.
local uncertain={rootNode=202,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},uncertain))
runtime:update(16)
assert(runtime.active and runtime.claims[uncertain])
failure="SYNTHETIC_NATIVE_GUIDANCE_FAILURE"
failCancel=true
runtime:update(16)
assert(runtime.active==nil and runtime.pending==nil
    and runtime.claims[uncertain]~=nil
    and events[#events-1].code=="COMPLETION_SETTLEMENT_CLAIM_RETAINED",
    "unknown motor neutralisation must preserve the exclusive claim")
failCancel=false
failure=nil
runtime:loadMap()
assert(runtime.claims[uncertain]==nil)
-- Every uniquely identified registered Source Field may begin bounded
-- planning. A different field ID no longer vetoes admission.
local other={rootNode=301,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local callsBefore=routeCalls
fieldOverride=29
assert(runtime:onNativeCompletion({},other))
assert(routeCalls==callsBefore+1 and runtime.active==nil
    and runtime.pending and runtime.pending.sourceField.fieldId==29,
    "non-fixture source fields must enter independently qualified planning")
runtime:loadMap()
fieldOverride=nil
missingMembership=true
assert(not runtime:onNativeCompletion({},other))
assert(routeCalls==callsBefore+1
    and events[#events].fields.reason=="ASSEMBLY_OUTSIDE_REGISTERED_FIELDS")
missingMembership=false
-- Physical membership is captured once at completion and retained
-- unchanged through serial admission even if the scene changes later.
local first={rootNode=302,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local queued={rootNode=303,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},first))
assert(runtime:onNativeCompletion({},queued))
assert(runtime.waiting[1].sourceField.fieldId==77)
local countBefore=membershipCalls
fieldOverride=29
for i=1,12 do runtime:update(16) end
assert(runtime.waiting[1]==nil and membershipCalls==countBefore,
    "queued parking must preserve the original source-field association")
fieldOverride=nil
runtime:loadMap()
-- A work-time witness has priority over the completion-time root-only scan.
missingMembership=true
local oldCalls=membershipCalls
local captured={fieldId=29,field={},rootX=250,rootZ=250,
    provenance="ACTIVE_FIELDWORK_REGISTERED_POLYGON_MEMBERSHIP"}
assert(runtime:onNativeCompletion({},other,captured))
assert(membershipCalls==oldCalls and runtime.pending.sourceField==captured,
    "the unique Job Episode Source Field survives completion at the margin")
missingMembership=false
runtime:loadMap()
-- No physical movement, destination claim or actual parking assertion if
-- the whole selected Physical Assembly is already clear of its Source Field.
occupancyDisposition="CLEAR"
local alreadyClear={rootNode=405,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local starts=#driveCalls
local planned=planAdvances
assert(runtime:onNativeCompletion({},alreadyClear))
assert(runtime.pending and runtime.pending.kind=="LOCAL_INITIAL")
runtime:update(16)
assert(runtime.pending==nil and runtime.active==nil
    and #driveCalls==starts and planAdvances==planned
    and runtime.claims[alreadyClear]==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_NOT_REQUIRED"
    and events[#events].fields.reason=="ASSEMBLY_ALREADY_CLEAR_OF_SOURCE_FIELD",
    "already-clear assemblies require no planning, claim or Control")
runtime:loadMap()
-- A root outside but a member still in the Source Field requires a
-- current-pose local route, not an imaginary infield entry.
occupancyDisposition="STRADDLING"
directAllocation=true
local partial={rootNode=406,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},partial))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE"
    and lastAllocationDisposition=="STRADDLING")
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="LOCAL_ALLOCATED"
    and runtime.claims[partial]~=nil)
runtime:update(16)
assert(runtime.active and runtime.active.vehicle==partial
    and runtime.active.route==route
    and driveCalls[#driveCalls]=="START",
    "direct, actual-pose route must be admitted only after qualification")
runtime:loadMap()
directAllocation=false
occupancyDisposition="INSIDE"
-- An unqualified allocator result must never acquire a parking claim.
local originalAdvance=OuttaMyWay.ParkingRegionAllocation.advancePlan
OuttaMyWay.ParkingRegionAllocation.advancePlan=function(session,units)
    return "DONE",{terminalPose={x=99,z=99},ownRadius=5}
end
local missingApproach={rootNode=407,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},missingApproach))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE")
runtime:update(16)
assert(runtime.pending==nil and runtime.active==nil
    and runtime.claims[missingApproach]==nil
    and events[#events].fields.reason=="PARKING_APPROACH_CONNECTIVITY_UNQUALIFIED",
    "no terminal claim until the current-pose connection is proven")
OuttaMyWay.ParkingRegionAllocation.advancePlan=originalAdvance
runtime:loadMap()
-- A mid-guidance live safety veto can occur before the current leg reaches
-- its target. If the normal completed-leg stop rejects that transition,
-- preserve the originating safety reason, not just the stop API refusal.
local interrupted={rootNode=408,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},interrupted))
runtime:update(16) -- switch local to allocation
runtime:update(16) -- allocation yields qualified extended approach
runtime:update(16) -- active native guidance
assert(runtime.active and runtime.active.route.mode=="EXTENDED_INFIELD")
activeConflict=true
forceStopRefusal=true
runtime:update(16)
assert(runtime.active==nil and runtime.pending==nil
    and events[#events-1].code=="COMPLETION_SETTLEMENT_SAFETY_STOP_UNAVAILABLE"
    and events[#events-1].fields.stopReason=="SETTLEMENT_STOP_NOT_ADMITTED"
    and events[#events-1].fields.safetyReason=="PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED"
    and events[#events].code=="COMPLETION_SETTLEMENT_INTERRUPTED"
    and events[#events].fields.reason=="PHYSICAL_OCCUPANCY_NEXT_GUIDE_OCCUPIED"
    and driveCalls[#driveCalls]=="CANCEL"
    and runtime.claims[interrupted]==nil,
    "originating safety refusal remains observable; native release unchanged")
activeConflict=false
forceStopRefusal=false
runtime:loadMap()
-- A diverged mid-leg plan must physically stop before new allocation.
runtime:loadMap()
local diverged={rootNode=49,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},diverged))
runtime:update(16)
assert(runtime.active and driveCalls[#driveCalls]=="START")
local beforeDivergence=#driveCalls
failure="SETTLEMENT_LEG_TRAJECTORY_DIVERGED"
runtime:update(16)
assert(runtime.active and runtime.active.phase=="STOP_FOR_ALTERNATIVE"
    and driveCalls[#driveCalls]=="BRAKE"
    and #driveCalls==beforeDivergence+1,
    "trajectory divergence must brake instead of abandoning parking")
failure=nil
runtime:update(16)
assert(runtime.active==nil and runtime.pending
    and runtime.pending.kind=="ALLOCATE"
    and runtime.replans[diverged]==1
    and driveCalls[#driveCalls]=="STOP",
    "replan begins only after stable native stop and lease release")
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="EXTENDED",
    "candidate must be newly qualified")
runtime:update(16)
assert(runtime.active and runtime.active.route==qualifiedExtendedRoute
    and driveCalls[#driveCalls]=="START",
    "new movement requires a separately qualified route")
for i=1,20 do
    if runtime.active==nil and runtime.pending==nil then break end
    runtime:update(16)
end
assert(runtime.active==nil and runtime.pending==nil,
    "bounded replan must terminate in offline fixture")
runtime:loadMap()
-- A prequalified zero-leg approach carries entryPose, not session.target.
qualifiedExtendedRoute.legs={}
local zero={rootNode=409,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},zero))
runtime:update(16)
runtime:update(16)
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="LOCAL_HANDOFF")
runtime:loadMap()
-- A terminal-allocation failure publishes ONE bounded reason distribution
-- if diagnostic collection is enabled. Normal runs do not collect it.
local oldBegin,oldAdvance=OuttaMyWay.ParkingRegionAllocation.beginPlan,
    OuttaMyWay.ParkingRegionAllocation.advancePlan
OuttaMyWay.ParkingRegionAllocation.beginPlan=function(_,_,_,_,enabled)
    local session={advances=0,spent=0}
    if enabled then
        session.evidence={sitesTotal=7,sitesExamined=7,localPlans=3,
            localCandidates=450,localFeasible=0,
            approachPlans=0,approachConnected=0,
            siteRejections={ENTRY_PHYSICAL_OCCUPANCY=4},
            routeRejections={REVERSE_MEMBER_OUTSIDE_SOURCE=450}}
    end
    return session
end
OuttaMyWay.ParkingRegionAllocation.advancePlan=function()
    return "FAILED",nil,"NO_QUALIFIED_TERMINAL_REGION"
end
local function summaries()
    local n,fields=0,nil
    for _,event in ipairs(events) do
        if event.code=="COMPLETION_SETTLEMENT_ALLOCATION_REJECTIONS" then
            n=n+1;fields=event.fields
        end
    end
    return n,fields
end
local diagnosticVehicle={rootNode=410,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
diagnosticEnabled=true
localFallback=true
assert(runtime:onNativeCompletion({},diagnosticVehicle))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE")
runtime:update(16)
local count,fields=summaries()
assert(count==1 and fields.rootNode=="410"
    and fields.sitesTotal==7 and fields.sitesExamined==7
    and fields.siteRejections=="ENTRY_PHYSICAL_OCCUPANCY:4"
    and fields.routeRejections=="REVERSE_MEMBER_OUTSIDE_SOURCE:450"
    and events[#events].code=="COMPLETION_SETTLEMENT_NOT_ADMITTED",
    "one terminal failure must publish bounded candidate evidence")
local marginCount,marginFields=0,nil
for _,event in ipairs(events) do
    if event.code=="COMPLETION_SETTLEMENT_MARGIN_COMPARISON" then
        marginCount=marginCount+1;marginFields=event.fields
    end
end
assert(marginCount==1 and marginBegins==1 and marginAdvances==1
    and marginFields.rootNode=="410" and marginFields.nearestEdge==7
    and marginFields.corridorSafety=="NOT_ESTABLISHED"
    and marginFields.roadSurface=="UNKNOWN_NOT_OBSERVED",
    "read-only edge evidence must be published once for diagnostic episode")
runtime:loadMap()
diagnosticEnabled=false
local quietVehicle={rootNode=411,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},quietVehicle))
runtime:update(16)
runtime:update(16)
assert(summaries()==1 and runtime.pending==nil and runtime.active==nil
    and marginBegins==1 and marginAdvances==1,
    "normal logging must not collect or publish candidate comparisons")
OuttaMyWay.ParkingRegionAllocation.beginPlan=oldBegin
OuttaMyWay.ParkingRegionAllocation.advancePlan=oldAdvance
-- A terminal miss following a positive stable stop can receive one
-- newly qualified short correction: never a blind point extension.
runtime:loadMap()
local terminalVehicle={rootNode=630,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
failTerminal=true
correctionAllowed=true
local previousCorrectionCalls=correctionCalls
assert(runtime:onNativeCompletion({},terminalVehicle))
for i=1,16 do
    runtime:update(16)
    if correctionCalls>previousCorrectionCalls then break end
end
assert(correctionCalls==previousCorrectionCalls+1
    and runtime.active and runtime.active.terminalCorrectionAttempted==true
    and runtime.active.route.method=="STOPPED_TERMINAL_CORRECTION",
    "failed terminal must attempt one claimed and qualified forward correction")
failTerminal=false
for i=1,10 do
    runtime:update(16)
    if runtime.active==nil and runtime.pending==nil then break end
end
assert(runtime.active==nil and runtime.pending==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_FINISHED",
    "correction still requires its own independently verified stop and terminal")
-- A heading-changing correction is one continuous forward native lease:
-- its short arc guide cannot count as a final parked/verified terminal.
runtime:loadMap()
local angled={rootNode=634,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
failTerminal=true
correctionAllowed=true
correctionCurved=true
local oldCalls=correctionCalls
assert(runtime:onNativeCompletion({},angled))
for i=1,16 do
    runtime:update(16)
    if correctionCalls>oldCalls then break end
end
assert(runtime.active and runtime.active.route.method==
    "STOPPED_TERMINAL_ALIGNMENT"
    and #runtime.active.route.legs==2
    and runtime.active.route.legs[1].arrivalRadiusM==0.75,
    "misaligned stopped terminal must admit forward heading correction")
local beforeMove=#driveCalls
failTerminal=false
for i=1,14 do
    runtime:update(16)
    if runtime.active==nil and runtime.pending==nil then break end
end
assert(runtime.active==nil and runtime.pending==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_FINISHED"
    and #driveCalls>beforeMove,
    "heading correction must execute then independently verify terminal")
correctionCurved=false
-- If a short correction cannot qualify, reread ACTUAL member occupancy.
-- In particular, STRADDLING must not become an imaginary INSIDE entry.
runtime:loadMap()
local straddling={rootNode=631,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
failTerminal=true
correctionAllowed=false
occupancyDisposition="STRADDLING"
assert(runtime:onNativeCompletion({},straddling))
for i=1,16 do
    runtime:update(16)
    if runtime.pending and runtime.pending.kind=="ALLOCATE" then break end
end
assert(runtime.pending and runtime.pending.kind=="ALLOCATE"
    and lastAllocationDisposition=="STRADDLING"
    and runtime.replans[straddling]==1,
    "failed stopped terminal must requalify from current straddling members")
runtime:loadMap()
failTerminal=false
occupancyDisposition="INSIDE"
-- The global 240s lease is not a player-response budget: pending
-- assessment must return a clear refusal on the bounded planning clock.
local slowInitial={rootNode=720,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
forcePlanPending=true
local initialDriveCount=#driveCalls
assert(runtime:onNativeCompletion({},slowInitial))
for i=1,20 do runtime:update(1000) end
assert(runtime.pending and runtime.pending.kind=="LOCAL_INITIAL"
    and runtime.pending.planningElapsedMs==20000
    and #driveCalls==initialDriveCount,
    "planning remains non-actuating while an incomplete candidate is pending")
runtime:update(1000)
assert(runtime.pending==nil and runtime.active==nil
    and #driveCalls==initialDriveCount
    and events[#events].code=="COMPLETION_SETTLEMENT_NOT_ADMITTED"
    and events[#events].fields.reason=="PARKING_PLANNING_RESPONSE_BUDGET_EXHAUSTED",
    "planning must explicitly refuse at its own response budget, not 240s")
forcePlanPending=false
runtime:loadMap()
-- The first local planner and fallback allocator SHARE one planning clock:
-- switching phases must not restart a 20s invisible wait.
local slowAllocated={rootNode=721,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
allocationStalled=true
diagnosticEnabled=true
assert(runtime:onNativeCompletion({},slowAllocated))
runtime:update(1000)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE"
    and runtime.pending.planningElapsedMs==1000)
-- Ten completed sites plus an unfinished reverse-local site must remain
-- distinguishable in the budget-expiry evidence.
local evidenceSession=runtime.pending.plan
evidenceSession.phase="QUALIFY"
evidenceSession.siteIndex=11
evidenceSession.sites={}
for i=1,23 do evidenceSession.sites[i]={edgeIndex=i} end
evidenceSession.site={edgeIndex=4,station=62.5}
evidenceSession.spent=221911
evidenceSession.advances=82
evidenceSession.localPlan={
    candidates=185,phase="ACTIVE",rejectionCounts={
        REVERSE_MEMBER_OUTSIDE_SOURCE=91,
        TERMINAL_HEADING_BAND=7}}
evidenceSession.evidence={
    sitesTotal=23,sitesExamined=11,localPlans=8,
    localCandidates=650,localFeasible=0,approachPlans=0,
    approachConnected=0,
    initialReason="NO_POSE_REACHABLE_PARKING_REGION",
    initialCandidates=300,
    initialRejections={REVERSE_ROOT_OUTSIDE_SOURCE=5},
    siteRejections={LOCAL_ROUTE_NO_POSE_REACHABLE_PARKING_REGION=7},
    routeRejections={REVERSE_ROOT_OUTSIDE_SOURCE=99}}
for i=1,19 do runtime:update(1000) end
assert(runtime.pending and runtime.pending.planningElapsedMs==20000)
local count=0
for _,event in ipairs(events) do
    if event.code=="COMPLETION_SETTLEMENT_ALLOCATION_PROGRESS"
        and event.fields.rootNode=="721" then
        count=count+1
        assert(event.fields.elapsedMs>=5000
            and event.fields.planningElapsedMs<=20000)
    end
end
assert(count==1,"slow allocation must publish only one bounded in-flight diagnostic")
runtime:update(1000)
assert(runtime.pending==nil and runtime.active==nil
    and #driveCalls==initialDriveCount
    and events[#events].fields.reason=="PARKING_PLANNING_RESPONSE_BUDGET_EXHAUSTED",
    "the allocator must not restart the response clock or move unqualified")
local snapshots=0
for _,event in ipairs(events) do
    if event.code=="COMPLETION_SETTLEMENT_ALLOCATION_REJECTIONS"
        and event.fields.rootNode=="721" then
        snapshots=snapshots+1
        local f=event.fields
        assert(f.incompleteSearch==true and f.sitesTotal==23
            and f.sitesExamined==11 and f.sitesCompleted==10
            and f.currentPhase=="QUALIFY" and f.currentSiteEdge==4
            and f.currentSiteStation==62.5
            and f.inFlightLocalCandidates==185
            and f.inFlightLocalPhase=="ACTIVE"
            and string.find(f.inFlightLocalRejections,
                "REVERSE_MEMBER_OUTSIDE_SOURCE:91",1,true)
            and string.find(f.routeRejections,
                "REVERSE_ROOT_OUTSIDE_SOURCE:99",1,true)
            and f.initialCandidates==300
            and f.actualPoseConnection=="EXTENDED_FORWARD_ONLY"
            and f.approachConnected==0,
            "timeout must retain PARTIAL complete-site and current reverse evidence")
    end
end
assert(snapshots==1,
    "budget failure must publish one incomplete, not exhaustive, reason report")
assert(not runtime:onNativeCompletion({},slowAllocated),
    "budget exhaustion cannot replay consumed native completion evidence")
runtime:loadMap()
allocationStalled=false
diagnosticEnabled=false
-- The search can fail its bounded response without inventing a route, but
-- one freshly qualified infield reposition may create a useful observed
-- actual pose. A real stable STOP precedes the second planning session.
local repositioner={rootNode=722,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
allocationStalled=true
repositionAllowed=true
local beforeReposition=repositionPlans
local beforeNative=#driveCalls
assert(runtime:onNativeCompletion({},repositioner))
for i=1,21 do runtime:update(1000) end
assert(runtime.active and runtime.active.route.mode=="REPOSITION_INFIELD"
    and runtime.repositioned[repositioner]
    and repositionPlans==beforeReposition+1
    and #driveCalls>beforeNative
    and runtime.claims[repositioner]==nil,
    "qualified intermediate positioning is an admitted non-terminal drive")
-- No final parking success until this second planning phase and its
-- eventual complete-assembly terminal have been independently established.
local observed=false
local directBefore=directDestinationBegins
local allocationBefore=lastAllocationDisposition
for i=1,20 do
    runtime:update(16)
    if runtime.pending and runtime.pending.kind=="DIRECT_DESTINATION" then
        observed=true
        assert(runtime.drive.active==nil
            and runtime.pending.planningElapsedMs==0
            and runtime.pending.occupancy=="INSIDE"
            and directDestinationBegins==directBefore+1
            and lastAllocationDisposition==allocationBefore,
            "verified reposition must preserve direct actual-pose routes, not restart hypothetical allocation")
        break
    end
end
local observedEvent=false
for _,event in ipairs(events) do
    if event.code=="COMPLETION_SETTLEMENT_REPOSITION_OBSERVED"
        and event.fields.rootNode=="722" then
        observedEvent=true
    end
end
assert(observed and observedEvent,
    "reposition endpoint cannot be substituted for actual stopped pose")
-- Even if the second planner again cannot connect, do not reposition
-- indefinitely; report the bounded final refusal.
repositionAllowed=true
forcePlanPending=true
local countBefore=repositionPlans
for i=1,21 do runtime:update(1000) end
assert(runtime.pending==nil and runtime.active==nil
    and repositionPlans==countBefore
    and events[#events].fields.reason==
        "PARKING_PLANNING_RESPONSE_BUDGET_EXHAUSTED",
    "one physical reposition attempt cannot loop or fabricate parking")
runtime:loadMap()
forcePlanPending=false
repositionAllowed=false
-- The initial STRADDLING forward option remains a non-blocking
-- alternative; refusal retains the established local-to-allocation path
-- and its already-running response budget.
runtime:loadMap()
occupancyDisposition="STRADDLING"
boundaryAllowed=true
boundaryForceRefusal=true
directAllocation=true
localFallback=true
local refusedBoundary={rootNode=732,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},refusedBoundary))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="BOUNDARY_EXIT")
local elapsedBefore=runtime.pending.planningElapsedMs
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="LOCAL_INITIAL"
    and runtime.pending.planningElapsedMs>elapsedBefore
    and runtime.claims[refusedBoundary]==nil,
    "failed forward exit must retain local qualification without resetting time or creating claims")
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE"
    and lastAllocationDisposition=="STRADDLING",
    "failed forward exit must not suppress the known straddling allocation fallback")
runtime:loadMap()
boundaryForceRefusal=false
directAllocation=false
-- The same forward-only boundary qualifier must be reachable from
-- two different stopped situations, never from a fictional infield pose.
runtime:loadMap()
occupancyDisposition="STRADDLING"
boundaryAllowed=true
local alreadyStraddling={rootNode=733,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local startsBefore=#driveCalls
physicalBoundaryTestSubject=alreadyStraddling
assert(runtime:onNativeCompletion({},alreadyStraddling))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="BOUNDARY_EXIT"
    and runtime.claims[alreadyStraddling]==nil
    and #driveCalls==startsBefore,
    "a native STRADDLING completion must assess before any drive or claim")
runtime:update(16)
assert(runtime.active and runtime.active.route.mode=="BOUNDARY_CLEARANCE_STEP"
    and runtime.claims[alreadyStraddling]~=nil,
    "a qualified physical 2m step admits movement without assuming final parking")
local stoppedStillStraddled=false
for i=1,14 do
    runtime:update(16)
    if runtime.pending and runtime.pending.kind=="BOUNDARY_EXIT"
        and runtime.pending.clearanceSteps==1 then
        stoppedStillStraddled=true
        break
    end
end
assert(stoppedStillStraddled
    and events[#events].code~="COMPLETION_SETTLEMENT_FINISHED",
    "one actual 2m stop still STRADDLING must not fabricate success")
runtime:update(16)
assert(runtime.active and runtime.active.route.mode=="BOUNDARY_CLEARANCE_STEP"
    and runtime.active.clearanceSteps==1,
    "second clearance must start from the newly observed actual root pose")
for i=1,14 do
    runtime:update(16)
    if runtime.active and runtime.active.phase=="STOPPING" then
        occupancyDisposition="CLEAR"
    end
    if runtime.active==nil and runtime.pending==nil then break end
end
assert(runtime.active==nil and runtime.pending==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_FINISHED",
    "only physically CLEAR stopped terminal may complete parking")
physicalBoundaryTestSubject=nil
runtime:loadMap()
occupancyDisposition="INSIDE"
boundaryAllowed=true
failTerminal=true
local memberStillInField={rootNode=734,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
physicalBoundaryTestSubject=memberStillInField
assert(runtime:onNativeCompletion({},memberStillInField))
for i=1,24 do
    runtime:update(16)
    if runtime.active==nil and runtime.pending==nil then break end
    -- The first terminal may be positionally admitted but its live member
    -- still STRADDLES. Do not apply this to initial INSIDE admission.
    if runtime.active and runtime.active.phase=="STOPPING" then
        occupancyDisposition="STRADDLING"
    end
    if runtime.pending and runtime.pending.kind=="BOUNDARY_EXIT" then
        break
    end
end
assert(runtime.pending and runtime.pending.kind=="BOUNDARY_EXIT"
    and runtime.pending.retainClaim==true
    and runtime.claims[memberStillInField]~=nil,
    "a physically stopped member-intersection permits a separately qualified same-edge exit")
failTerminal=false
runtime:update(16)
assert(runtime.active and runtime.active.route.mode=="BOUNDARY_CLEARANCE_STEP"
    and runtime.claims[memberStillInField]~=nil,
    "stopped first-finisher continuation must use the retained short-lived claim")
for i=1,14 do
    runtime:update(16)
    if runtime.active and runtime.active.phase=="STOPPING"
        and runtime.active.route.mode=="BOUNDARY_CLEARANCE_STEP" then
        occupancyDisposition="CLEAR"
    end
    if runtime.active==nil and runtime.pending==nil then break end
end
assert(runtime.active==nil and runtime.pending==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_FINISHED",
    "a first-finisher forward continuation must independently stop and verify")
physicalBoundaryTestSubject=nil
runtime:loadMap()
-- Four separately verified stops are a finite clearance opportunity,
-- NOT permission to continue past a still-straddling boundary forever.
occupancyDisposition="STRADDLING"
boundaryAllowed=true
local stillStraddled={rootNode=735,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
physicalBoundaryTestSubject=stillStraddled
assert(runtime:onNativeCompletion({},stillStraddled))
local stepsObserved=0
for i=1,110 do
    runtime:update(16)
    for _,ev in ipairs(events) do
        if ev.code=="COMPLETION_SETTLEMENT_BOUNDARY_CLEARANCE_OBSERVED"
            and ev.fields.rootNode=="735"
            and (ev.fields.stepsCompleted or 0)>stepsObserved then
            stepsObserved=ev.fields.stepsCompleted
        end
    end
    if runtime.active==nil and runtime.pending==nil then break end
end
assert(stepsObserved==4 and runtime.active==nil and runtime.pending==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_NOT_ADMITTED"
    and events[#events].fields.reason==
        "BOUNDARY_CLEARANCE_FINITE_STEPS_EXHAUSTED"
    and runtime.claims[stillStraddled]==nil,
    "only four observed clearance steps are permitted without physical CLEAR")
runtime:loadMap()
-- A nominally accepted target is not physical progress. No actual
-- forward movement cannot unlock another clearance attempt.
local stalledStep={rootNode=736,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
physicalBoundaryTestSubject=stalledStep
freezeBoundaryMovement=true
assert(runtime:onNativeCompletion({},stalledStep))
for i=1,25 do
    runtime:update(16)
    if runtime.active==nil and runtime.pending==nil then break end
end
assert(runtime.active==nil and runtime.pending==nil
    and events[#events].code=="COMPLETION_SETTLEMENT_INTERRUPTED"
    and events[#events].fields.reason=="BOUNDARY_STEP_NO_PHYSICAL_FORWARD_PROGRESS"
    and runtime.claims[stalledStep]==nil,
    "nominal waypoint completion must not count as measured physical progress")
freezeBoundaryMovement=false
physicalBoundaryTestSubject=nil
runtime:loadMap()
boundaryAllowed=false
occupancyDisposition="INSIDE"
failTerminal=false
print("completion settlement TEST lifecycle, retained Source Field and planning responsiveness PASS")
