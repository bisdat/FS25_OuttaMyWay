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
            assert(objective.moveForwards==true)
            assert(objective.returnRegion.source=="COMPLETION_SETTLEMENT_LEG")
            assert(objective.maximumSpeedKmh==8)
            driveCalls[#driveCalls+1]="START"
            self.active={vehicle=vehicle,objective=objective}
            return true
        end,
        movementStatus=function(self,vehicle)
            assert(self.active and self.active.vehicle==vehicle)
            if failure then return {isFailed=true,reason=failure} end
            local target=self.active.objective
            vehicle.x,vehicle.z=target.targetX,target.targetZ
            return {isComplete=true}
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
    field=77,edge=9,memberCount=2,lengthM=204.55,
    legs={
        {name="INFIELD_APPROACH",point={x=10,z=10}},
        {name="SHALLOW_CROSSING",point={x=30,z=12}},
        {name="FORWARD_RUNOUT",point={x=200,z=12}}
    }
}
local routeCalls,terminalCalls=0,0
OuttaMyWay.CompletionSettlementRoute={
    plan=function()
        routeCalls=routeCalls+1
        return route
    end,
    verifyTerminal=function()
        terminalCalls=terminalCalls+1
        return true,"WHOLE_NOMINAL_ASSEMBLY_OUTSIDE_SOURCE_FIELD"
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
assert(#driveCalls==1 and routeCalls==1)
for i=1,3 do runtime:update(16) end
assert(runtime.active==nil and #driveCalls==6)
assert(terminalCalls==1,"terminal must be independently verified")
assert(events[#events].code=="COMPLETION_SETTLEMENT_FINISHED")
assert(not runtime:onNativeCompletion({},a,true),
    "same completed vehicle never re-admits in one map")
assert(runtime:onNativeCompletion({},b,true))
enabled=false
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "disable must cancel active native steering")
enabled=true
local c={rootNode=36,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},c,true))
c.getCurrentAIJob=function()return {} end
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "new GIANTS job supersedes prototype Control")
local d={rootNode=48,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},d,true))
failure="NATIVE_STEERING_FAILED"
runtime:update(16)
assert(runtime.active==nil and driveCalls[#driveCalls]=="CANCEL",
    "native steering fault must neutralise Control")
failure=nil
local e={rootNode=60,x=0,z=0,
    getIsAIActive=function()return false end,
    getCurrentAIJob=function()return nil end}
assert(runtime:onNativeCompletion({},e,true))
runtime:deleteMap()
assert(runtime.active==nil and driveCalls[#driveCalls]=="MAP_DELETE",
    "map teardown cannot issue stale engine Control")
print("completion settlement TEST lifecycle PASS")
