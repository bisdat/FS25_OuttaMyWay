-- TEST 0.5.5.7: completion settlement is a separate, opt-in,
-- finite physical-Control lifecycle. No GIANTS movement in this fixture.
OuttaMyWay={VERSION="0.5.test"}
local events={}
OuttaMyWay.LogPublication={origin=function()
    return {publish=function(_,_,_,code,payload)
        events[#events+1]={code=code,fields=payload()}
    end}
end}
local driveCalls={}
local failure
local failCancel=false
OuttaMyWay.NativeStaticAssemblyDriveMechanism={new=function()
    return {
        active=nil,
        startMovement=function(self,vehicle,objective)
            assert(type(objective.moveForwards)=="boolean")
            assert(objective.maximumSpeedKmh>8
                and objective.maximumSpeedKmh<60,
                "local guidance speed must respond to target horizon")
            assert(objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG")
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
            vehicle.x,vehicle.z=target.targetX,target.targetZ
            return {isComplete=true}
        end,
        beginSettlementStop=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            assert(self.active.objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG")
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
        return true,"WHOLE_NOMINAL_ASSEMBLY_OUTSIDE_SOURCE_FIELD"
    end
}
local refuseExtendedScene=false
local activeConflict=false
local mismatchClaim=false
OuttaMyWay.ParkingRegionAllocation={
    beginPlan=function()return {advances=0,spent=0}end,
    advancePlan=function(session,units)
        session.advances=session.advances+1
        session.spent=session.spent+units
        return "DONE",{entryPose={x=25,z=-30,fx=1,fz=0},
            terminalPose={x=40,z=20},ownRadius=5,
            stationMin=0,stationMax=100,station=50}
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
    beginPlan=function()
        return {advances=0,spent=0}
    end,
    advancePlan=function(session,units)
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
local enabled=true
g_server={}
local config={isResolved=function()return true end,
    isEnabled=function()return enabled end}
getWorldTranslation=function()
    -- The drive mock owns its own successful-leg outcome; this passive
    -- world-pose fixture only feeds each new leg's target distance.
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
dofile("scripts/control/CompletionSettlementRuntime.lua")
local Runtime=OuttaMyWay.CompletionSettlementRuntime
local a={rootNode=12,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local b={rootNode=24,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local runtime=Runtime.new(config)
assert(not runtime:onNativeCompletion({},a,false))
assert(membershipCalls==0,"native transit rejection must not scan registered fields")
assert(#driveCalls==0 and routeCalls==0,
    "Transit rejection must not move")
assert(runtime:onNativeCompletion({},a,true))
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
assert(not runtime:onNativeCompletion({},a,true),
    "same completed vehicle never re-admits in one map")
assert(runtime:onNativeCompletion({},b,true))
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
assert(runtime:onNativeCompletion({},duringMotion,true))
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
assert(runtime:onNativeCompletion({},c,true))
runtime:update(16)
c.getCurrentAIJob=function()return {} end
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "new GIANTS job supersedes prototype Control")
local d={rootNode=48,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},d,true))
runtime:update(16)
failure="NATIVE_STEERING_FAILED"
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "native steering fault must neutralise Control")
failure=nil
local e={rootNode=60,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},e,true))
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
assert(runtime:onNativeCompletion({},distant,true))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE"
    and #driveCalls==callsBefore,
    "failed local search must first assess a qualified parking region")
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="EXTENDED")
runtime:update(16)
assert(runtime.active and runtime.active.route.mode=="EXTENDED_INFIELD")
assert(driveCalls[#driveCalls]=="START")
-- The second native completion is retained; only ONE physical driver
-- may operate until its independent settlement turn begins.
local nextWorker={rootNode=192,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},nextWorker,true))
assert(#runtime.waiting==1 and runtime.waiting[1].vehicle==nextWorker)
assert(not runtime:onNativeCompletion({},nextWorker,true),
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
assert(not runtime:onNativeCompletion({},blocked,true),
    "yielding is bounded, not a second native completion event")
-- Reproduce the TS019-style no-short-route / failed worker-scene path.
-- A failed census reports the exact witnessed limitation but can never
-- hand control to the native driver, or retry the same completed job.
local refused={rootNode=191,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
refuseExtendedScene=true
local beforeRefusal=#driveCalls
assert(runtime:onNativeCompletion({},refused,true))
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="ALLOCATE")
runtime:update(16)
assert(runtime.pending and runtime.pending.kind=="EXTENDED")
runtime:update(16)
assert(runtime.active==nil and runtime.pending==nil
    and #driveCalls==beforeRefusal,
    "unknown relevant worker must refuse before physical actuation")
assert(events[#events-1].code=="COMPLETION_SETTLEMENT_SCENE_ADMISSION_FAILED")
local witness=events[#events-1].fields
assert(witness.reason=="WORKER_SCENE_AI_STATUS_UNAVAILABLE"
    and witness.registry=="MISSION_VEHICLE_SYSTEM"
    and witness.failureRoot=="220"
    and witness.relevantWorkers==1)
assert(events[#events].code=="COMPLETION_SETTLEMENT_NOT_ADMITTED")
assert(not runtime:onNativeCompletion({},refused,true),
    "same native completion must not start a new search after census veto")
refuseExtendedScene=false
-- During a real extended lease, invalidated space must first cause
-- physical braking and a stable released stop; only then can allocator
-- seek an alternative station. It must not issue a new START beforehand.
local reroute={rootNode=199,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
localFallback=true
assert(runtime:onNativeCompletion({},reroute,true))
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
assert(runtime:onNativeCompletion({},uncertain,true))
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
assert(runtime:onNativeCompletion({},other,true))
assert(routeCalls==callsBefore+1 and runtime.active==nil
    and runtime.pending and runtime.pending.sourceField.fieldId==29,
    "non-fixture source fields must enter independently qualified planning")
runtime:loadMap()
fieldOverride=nil
missingMembership=true
assert(not runtime:onNativeCompletion({},other,true))
assert(routeCalls==callsBefore+1
    and events[#events].fields.reason=="ASSEMBLY_OUTSIDE_REGISTERED_FIELDS")
missingMembership=false
-- Physical membership is captured once at completion and retained
-- unchanged through serial admission even if the scene changes later.
local first={rootNode=302,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local queued={rootNode=303,getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},first,true))
assert(runtime:onNativeCompletion({},queued,true))
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
assert(runtime:onNativeCompletion({},other,true,captured))
assert(membershipCalls==oldCalls and runtime.pending.sourceField==captured,
    "the unique Job Episode Source Field survives completion at the margin")
missingMembership=false
runtime:loadMap()
print("completion settlement TEST lifecycle, claim handoff and retained Source Field PASS")
