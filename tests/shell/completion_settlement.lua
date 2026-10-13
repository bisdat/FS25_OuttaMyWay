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
        return true
    end
}
local optin=false
local enabled=true
g_server={}
local config={isResolved=function()return true end,
    isEnabled=function()return enabled end}
local diagnostic={isSettlementPrototypeEnabled=function()return optin end}
getWorldTranslation=function()
    -- The drive mock owns its own successful-leg outcome; this passive
    -- world-pose fixture only feeds each new leg's target distance.
    return 0,0,0
end
dofile("scripts/control/CompletionSettlementRuntime.lua")
local Runtime=OuttaMyWay.CompletionSettlementRuntime
local a={rootNode=12,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local b={rootNode=24,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
local runtime=Runtime.new(config,diagnostic)
assert(not runtime:onNativeCompletion({},a,true))
assert(#driveCalls==0 and routeCalls==0,
    "diagnostics without explicit prototype consent never move")
optin=true
assert(not runtime:onNativeCompletion({},a,false))
assert(#driveCalls==0,"Transit rejection must not move")
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
assert(runtime.pending and runtime.pending.kind=="EXTENDED"
    and #driveCalls==callsBefore,
    "failed local search must not issue native motion")
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
print("completion settlement TEST lifecycle, extended handoff and scene failure attribution PASS")
