-- Request-only TRANSIT actuation tests; fold animation remains unfinished throughout.
OuttaMyWay={}
dofile("scripts/control/mechanisms/NativeTransitRequestMechanism.lua")
local Mechanism=OuttaMyWay.NativeTransitRequestMechanism
local calls={}
local failMethod=nil
local function record(name,value,noEventSend)
    calls[#calls+1]={name=name,value=value,noEventSend=noEventSend}
    if failMethod==name then error("NATIVE_REQUEST_FAILURE") end
end
local work={
    setIsTurnedOn=function(_,v,noEventSend) record("WORK",v,noEventSend) end,
    setLowered=function(_,v,noEventSend) record("RAISE",v,noEventSend) end
}
local fold={
    setFoldDirection=function(_,direction,noEventSend) record("FOLD",direction,noEventSend) end,
    -- An unfinished fold must not be read or treated as a blocker.
    getFoldAnimTime=function() error("FOLD_COMPLETION_MUST_NOT_BE_QUERIED") end,
    getIsLowered=function() error("LOWERING_MUST_NOT_BE_QUERIED") end
}
local vehicle={}
local plan={
    transitActions={
        {object=work,method="setIsTurnedOn",value=false},
        {object=work,method="setLowered",value=false},
        {object=fold,method="setFoldDirection",value=1}
    },
    restoreActions={
        {object=fold,method="setFoldDirection",value=-1},
        {object=work,method="setLowered",value=true},
        {object=work,method="setIsTurnedOn",value=true}
    }
}
local source={
    getTransitRequests=function(_,target)
        assert(target==vehicle)
        return plan
    end
}
g_server={}
local mechanism=Mechanism.new(source)
local ok,evidence=mechanism:requestTransit(vehicle)
assert(ok and evidence.isTransitRequested and not evidence.isConfigurationVerified)
assert(evidence.isReadyGateRequired==false)
assert(#calls==3 and calls[1].name=="WORK" and calls[1].value==false)
assert(calls[2].name=="RAISE" and calls[2].value==false)
assert(calls[3].name=="FOLD" and calls[3].value==1)
assert(calls[3].noEventSend==true)
assert(not mechanism:requestTransit(vehicle),"no duplicate request")
assert(mechanism:getRequestEvidence(vehicle).isActive)
assert(mechanism:getRequestEvidence(vehicle).isConfigurationVerified==false)
ok,evidence=mechanism:cancelTransit(vehicle)
assert(ok and evidence.isRestoreRequested and evidence.isRestorationVerified==false)
assert(#calls==6 and calls[4].name=="FOLD" and calls[4].value==-1)
assert(calls[5].name=="RAISE" and calls[5].value==true)
assert(calls[6].name=="WORK" and calls[6].value==true)
assert(mechanism:getRequestEvidence(vehicle).isActive==false)
assert(mechanism:cancelTransit(vehicle),"idempotent cancellation")
-- Static relocation handback is different: relinquish the cached command
-- without sending ANY working-pose inverses. The same assembly can still
-- receive a fresh TRANSIT request for a later blocked encounter.
assert(mechanism:requestTransit(vehicle))
local beforeRetain=#calls
assert(mechanism:relinquishTransit(vehicle))
assert(#calls==beforeRetain,"static TRANSIT must not restore working pose")
assert(mechanism:getRequestEvidence(vehicle).isActive==false)
assert(mechanism:requestTransit(vehicle),
    "a retained static posture does not gate a later fresh encounter")
assert(mechanism:cancelTransit(vehicle),
    "ordinary cancellation remains available to pair/solo callers")
-- No completion polling; a failed command is not ignored or misclassified as READY.
failMethod="FOLD"
ok,evidence=mechanism:requestTransit(vehicle)
assert(not ok and tostring(evidence):find("TRANSIT_NATIVE_REQUEST_FAILED",1,true))
assert(mechanism:getRequestEvidence(vehicle).isActive)
assert(mechanism:getRequestEvidence(vehicle).isRequestAccepted==false)
failMethod=nil
assert(mechanism:cancelTransit(vehicle),"failed request retains ability to issue restore")
-- Invalid cached plan cannot issue arbitrary native methods.
plan={
    transitActions={{object=work,method="delete",value=true}},
    restoreActions={}
}
local count=#calls
ok,evidence=mechanism:requestTransit(vehicle)
assert(not ok and evidence=="TRANSIT_REQUEST_PLAN_INVALID")
assert(#calls==count)
plan={transitActions={},restoreActions={}}
ok,evidence=mechanism:requestTransit(vehicle)
assert(ok and not evidence.isConfigurationVerified,"no readiness check for empty cached plan")
assert(mechanism:cancelTransit(vehicle))
-- Missing server rejects the request without touching GIANTS.
g_server=nil
count=#calls
ok,evidence=mechanism:requestTransit(vehicle)
assert(not ok and evidence=="SERVER_REQUIRED")
assert(#calls==count)
print("Cached native TRANSIT requests without readiness/settlement gates: PASS")
