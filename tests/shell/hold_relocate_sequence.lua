-- Offline coordination contract. All physical operations are adapter stubs.
OuttaMyWay={}
dofile("scripts/control/HoldRelocateSequence.lua")
local Sequence=OuttaMyWay.HoldRelocateSequence
local centroid={x=0,z=0}
local a={rootId=101,x=10,z=0,vehicle={name="A"}}
local b={rootId=202,x=15,z=0,vehicle={name="B"}}
local c={rootId=303,x=11,z=10,vehicle={name="C"}}
local log={}
local transit="WAITING"
local reverse={travelledM=0,completed=false}
local valid=true
local function record(verb,p,extra)
    log[#log+1]={verb=verb,worker=p and p.name,extra=extra}
end
local adapter={
    preflight=function(_,state) record("PREFLIGHT",state.relocator.vehicle);return true end,
    setHold=function(_,vehicle,on,purpose) record(on and "HOLD" or "RELEASE",vehicle,purpose);return true end,
    requestTransit=function(_,vehicle)record("TRANSIT",vehicle);return true end,
    transitStatus=function() return transit end,
    stillAuthorized=function() return valid,"JOB_OR_PLAYER_CHANGED" end,
    startReverse=function(_,vehicle,objective)record("REVERSE",vehicle,objective);return true end,
    reverseStatus=function() return reverse end,
    stopReverse=function(_,vehicle)record("REVERSE_STOP",vehicle);return true end,
    cancelReverse=function(_,vehicle)record("REVERSE_CANCEL",vehicle);return true end,
    cancelTransit=function(_,vehicle)record("TRANSIT_CANCEL",vehicle);return true end,
    restartNativeJob=function(_,vehicle)record("STOP_AND_START_JOB",vehicle);return true end
}
local function request()
    return {authorized=true,commitmentId="PAIR-1",participants={b,a},
        centroid=centroid,blockers={b,c},offsetM=0}
end
local seq=Sequence.new(adapter)
local ok,result=seq:begin(request(),1000)
assert(ok and result.relocatingRootId==101,"centroid nearest, not first blocked or enumeration")
assert(result.objective.reverse==true and result.objective.maxTravelM==30)
assert(result.objective.steeringHorizonM==40)
assert(result.objective.x==0 and result.objective.z==0)
assert(log[1].verb=="PREFLIGHT" and log[1].worker=="A")
assert(log[2].verb=="HOLD" and log[2].worker=="B")
assert(log[3].verb=="HOLD" and log[3].worker=="C")
assert(log[4].verb=="TRANSIT" and log[4].worker=="A",
    "start egress Hold and Transit without artificial five-second pause")
seq:update(4000)
assert(#log==4,"Transit can remain pending without premature reverse")
transit="READY";seq:update(4200)
assert(log[#log].verb=="REVERSE","ready Transit admits reverse")
seq:update(5999)
assert(#log==5,"no distance or blocked-state condition releases a Hold")
seq:update(6000)
assert(log[6].verb=="RELEASE" and log[6].worker=="B"
    and log[7].verb=="RELEASE" and log[7].worker=="C",
    "five-second release occurs while reverse is still in progress")
reverse={travelledM=8,completed=true}
seq:update(6250)
assert(log[8].verb=="REVERSE_STOP" and log[9].verb=="HOLD"
    and log[9].worker=="A")
seq:update(16249)
assert(#log==9,"relocated Hold lasts ten seconds, no clearance release")
seq:update(16250)
assert(log[10].verb=="RELEASE" and log[11].verb=="STOP_AND_START_JOB"
    and log[11].worker=="A","native stop/start is one immediate hand-back operation")
assert(not seq:isActive() and seq:getStatus().lastOutcome.status=="COMPLETED")
-- One active pair at a time; no competing reciprocal commitments.
transit="WAITING";reverse={travelledM=0,completed=false}
log={}
assert(seq:begin(request(),20000))
local denied,why=seq:begin(request(),20001)
assert(not denied and why=="SEQUENCE_ALREADY_ACTIVE")
valid=false;seq:update(20100)
assert(not seq:isActive() and seq:getStatus().lastOutcome.status=="RELINQUISHED")
assert(log[#log].verb=="RELEASE","job/player lifecycle abort relinquishes held Control")
assert(not seq:abort("ALREADY_DONE"))
valid=true
local bad=request()
bad.authorized=false
assert(not seq:begin(bad,21000))
assert(#log==5,"no actuation from passive candidate")
bad=request();bad.blockers={c}
assert(not seq:begin(bad,21000),"paired other must be protected")
bad=request();bad.centroid={x=10,z=0}
assert(not seq:begin(bad,21000),"no invented direction when centroid coincides")
-- Reverse bound is explicit; 40 m steering horizon never widens movement.
bad=request();bad.centroid={x=-100,z=0};bad.offsetM=2
assert(seq:begin(bad,22000))
local status=seq:getStatus()
assert(status.reverseLimitM==32 and status.relocatingRootId==101)
transit="READY";seq:update(22010)
reverse={travelledM=32.1,completed=false}
seq:update(22020)
assert(not seq:isActive() and seq:getStatus().lastOutcome.reason=="REVERSE_DISTANCE_EVIDENCE_INVALID")
-- Deterministic equal-distance role selection is independent of pair order.
local d={rootId=102,x=-10,z=0,vehicle={name="D"}}
bad=request();bad.participants={d,a};bad.blockers={d};bad.centroid={x=0,z=0}
assert(seq:begin(bad,23000))
assert(seq:getStatus().relocatingRootId==101)
seq:abort("TEST_END")
-- Adapter failure cannot leave a blocker held.
local failedAdapter={}
for k,v in pairs(adapter) do failedAdapter[k]=v end
failedAdapter.requestTransit=function()return false,"TRANSIT_UNAVAILABLE" end
local failed=Sequence.new(failedAdapter)
log={}
assert(not failed:begin(request(),24000))
assert(not failed:isActive())
assert(log[#log].verb=="RELEASE","partial actuation requires best-effort release")
print("Hold & Relocate role, timers, bounded reverse, lifecycle and hand-back: PASS")
