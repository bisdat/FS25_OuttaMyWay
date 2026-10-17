-- Completion TRANSIT must not gate parking on unreadable optional fold
-- metadata when independently supported native work-off/raise exists.
OuttaMyWay={}
local events={}
OuttaMyWay.LogPublication={origin=function()
    return {publish=function(_,class,severity,code,producer)
        events[#events+1]={code=code,fields=producer()}
    end}
end}
g_server={}
dofile("scripts/control/HoldRelocatePhysicalControl.lua")
dofile("scripts/control/mechanisms/NativeTransitRequestMechanism.lua")
dofile("scripts/control/CompletionTransitRuntime.lua")
local Control=OuttaMyWay.HoldRelocatePhysicalControl
local Runtime=OuttaMyWay.CompletionTransitRuntime
local enabled={isResolved=function()return true end,
    isEnabled=function()return true end}
local requests={}
local vehicle={rootNode=41,
    setIsTurnedOn=function(_,on)
        requests[#requests+1]={"WORK",on}
    end,
    setLowered=function(_,lowered)
        requests[#requests+1]={"RAISE",lowered}
    end,
    setFoldDirection=function()
        error("UNKNOWN_FOLD_DIRECTION_MUST_NOT_BE_COMMANDED")
    end,
    getToggledFoldDirection=function()
        error("UNKNOWN_FOLD_DIRECTION")
    end,
    getFoldAnimTime=function()
        error("FOLD_POSITION_NOT_EXPOSED")
    end,
    spec_foldable={},
    getAttachedImplements=function()return {} end,
    getCurrentAIJob=function()return nil end}
local old,oldWhy=Control.buildTransitPlan(vehicle,false)
assert(old==nil and oldWhy=="FOLD_START_UNKNOWN",
    "preserve the original blocked-recovery planning semantics")
local new,newWhy=Control.buildTransitPlan(vehicle,false,{completion=true})
assert(new and newWhy==nil and new.unknownFoldCount==1
    and #new.transitActions==2,
    "Completion only tolerates optional unobserved fold, not arbitrary plan errors")
local completion=Runtime.new(enabled)
local success=completion:onNativeCompletion({jobId=1},vehicle)
assert(success and #requests==2
    and requests[1][1]=="WORK" and requests[1][2]==false
    and requests[2][1]=="RAISE" and requests[2][2]==false,
    "work-off and raise are requested even without readable fold state")
assert(events[#events].code=="COMPLETED_WORKER_TRANSIT_REQUESTED"
    and events[#events].fields.unresolvedFoldCount==1,
    "accepted request must disclose unobserved fold configuration")
local invalid={rootNode=42,
    getCurrentAIJob=function()return nil end,
    getAttachedImplements=function()error("UNREADABLE_ATTACHMENTS")end}
local no=completion:onNativeCompletion({jobId=2},invalid)
assert(no==false
    and events[#events].code=="COMPLETED_WORKER_TRANSIT_UNAVAILABLE"
    and events[#events].fields.reason=="ATTACHMENT_EVIDENCE_UNAVAILABLE",
    "producer cause must survive the native request mechanism")
local noAction={rootNode=43,
    getCurrentAIJob=function()return nil end,
    getAttachedImplements=function()return {} end}
assert(completion:onNativeCompletion({jobId=3},noAction),
    "zero native configuration actions are a valid request-only outcome")
local configuredCount=0
local folded={rootNode=44,
    getCurrentAIJob=function()return nil end,
    getAttachedImplements=function()return {} end,
    setFoldDirection=function(_,direction)
        assert(direction==1)
        configuredCount=configuredCount+1
    end,
    getToggledFoldDirection=function()return 1 end,
    getFoldAnimTime=function()return 0 end}
assert(completion:onNativeCompletion({jobId=4},folded)
    and configuredCount==1,
    "known native folding must still be requested")
local Broken=OuttaMyWay.NativeTransitRequestMechanism.new({
    getTransitRequests=function()error("BROKEN_PRODUCER")end})
local ok,why=Broken:requestTransit({})
assert(ok==false and why=="TRANSIT_REQUEST_SOURCE_EXCEPTION",
    "producer exception must be distinguished from an invalid action plan")
completion:relinquish()
print("Completion TRANSIT optional fold / no-op / attributable failure PASS")
