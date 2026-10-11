-- Completion TRANSIT requests only after positive native success, never for manual stops.
OuttaMyWay={VERSION="0.5.test"}
local events={}
OuttaMyWay.LogPublication={origin=function()
 return {publish=function(_,class,severity,code,payload)
    events[#events+1]={code=code,payload=payload()}
 end}
end}
AIJobFieldWork={}
AIMessageSuccessFinishedJob={}
local function instance(klass)
 return {isa=function(_,target)return target==klass end}
end
local enabled=true
local config={isResolved=function()return true end,isEnabled=function()return enabled end}
g_server={}
MessageType={AI_JOB_STOPPED=11}
local callback,receiver
g_messageCenter={subscribe=function(_,_,cb,r)callback=cb;receiver=r end,unsubscribeAll=function()end}
local calls,release=0,0
OuttaMyWay.HoldRelocatePhysicalControl={
 buildTransitPlan=function(vehicle,isPair)
    assert(isPair==false)
    calls=calls+1
    return {transitActions={{object=vehicle,method="setLowered",value=false}},
        restoreActions={{object=vehicle,method="setLowered",value=true}}}
 end
}
dofile("scripts/control/mechanisms/NativeTransitRequestMechanism.lua")
dofile("scripts/control/CompletionTransitRuntime.lua")
dofile("scripts/observation/NativeJobCompletionProbe.lua")
local transit=OuttaMyWay.CompletionTransitRuntime.new(config)
local probe=OuttaMyWay.NativeJobCompletionProbe.new(config)
probe:setCompletionListener(function(job,vehicle)transit:onNativeCompletion(job,vehicle)end)
probe:loadMap()
local vehicle={rootNode=123,setLowered=function(_,down)assert(down==false);release=release+1 end,
 getCurrentAIJob=function()return nil end}
local function job(id)
 local j=instance(AIJobFieldWork)
 j.jobId=id
 j.vehicleParameter={getVehicle=function()return vehicle end}
 return j
end
callback(receiver,job(1),nil)
assert(calls==0 and release==0,"manual stop must never configure")
callback(receiver,job(2),instance(AIMessageSuccessFinishedJob))
assert(calls==1 and release==1,"success must issue one TRANSIT request")
callback(receiver,job(3),instance(AIMessageSuccessFinishedJob))
assert(calls==1 and release==1,"one completion request per vehicle")
transit:relinquish()
assert(release==1,"relinquish must never restore productive posture")
enabled=false
callback(receiver,job(4),instance(AIMessageSuccessFinishedJob))
assert(calls==1,"disabled state must not actuate")
enabled=true
local superseded={rootNode=456,setLowered=function()error("superseded worker actuated")end,
 getCurrentAIJob=function()return {} end}
local newer=job(5)
newer.vehicleParameter.getVehicle=function()return superseded end
callback(receiver,newer,instance(AIMessageSuccessFinishedJob))
assert(calls==1,"new AI job supersedes completion")
probe:deleteMap()
transit:deleteMap()
print("completion transit PASS")
