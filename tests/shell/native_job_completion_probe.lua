-- The stop-reason witness is read-only and cannot mistake arbitrary termination for success.
OuttaMyWay={VERSION="0.5.test"}
local reports={}
OuttaMyWay.LogPublication={origin=function()
    return {publish=function(_,class,severity,code,payload)
        assert(class=="DIAGNOSTIC" and severity=="INFO")
        reports[#reports+1]={code=code,payload=payload()}
    end}
end}
AIJobFieldWork={}
AIMessageSuccessFinishedJob={}
MessageType={AI_JOB_STOPPED=12}
g_server={}
local callback,target,subscribed,unsubscribed
g_messageCenter={
    subscribe=function(_,message,fn,receiver)
        assert(message==12)
        callback,target=fn,receiver
        subscribed=true
    end,
    unsubscribeAll=function(_,receiver)
        assert(receiver==target)
        unsubscribed=true
    end
}
local enabled=true
local config={isResolved=function()return true end,isEnabled=function()return enabled end}
dofile("scripts/observation/NativeJobCompletionProbe.lua")
local probe=OuttaMyWay.NativeJobCompletionProbe.new(config)
probe:loadMap()
assert(subscribed and target==probe)
local function instance(klass)
    return {isa=function(_,candidate)return candidate==klass end}
end
local function job(id)
    local result=instance(AIJobFieldWork)
    result.jobId=id
    result.vehicleParameter={getVehicle=function()return {rootNode=id+100} end}
    return result
end
local natural=job(1)
callback(target,natural,instance(AIMessageSuccessFinishedJob))
assert(#reports==1 and reports[1].payload.successClass==true)
assert(reports[1].payload.jobId==1 and reports[1].payload.rootNode=="101")
callback(target,natural,instance(AIMessageSuccessFinishedJob))
assert(#reports==1,"duplicate callback must not create a second observation")
local manual=job(2)
callback(target,manual,instance({}))
assert(#reports==2 and reports[2].payload.successClass==false)
local unknown=job(3)
callback(target,unknown,nil)
assert(#reports==3 and reports[3].payload.successClass==false)
enabled=false
callback(target,job(4),instance(AIMessageSuccessFinishedJob))
assert(#reports==3,"disabled product must not report completion")
enabled=true
callback(target,instance({}),instance(AIMessageSuccessFinishedJob))
assert(#reports==3,"unrelated job must be excluded")
probe:deleteMap()
assert(unsubscribed and not probe.subscribed)
print("native job completion probe PASS")
