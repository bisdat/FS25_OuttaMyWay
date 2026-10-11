-- Post-interruption observations are passive, finite and actor-specific.
OuttaMyWay={VERSION="0.5.3.test"}
local published={}
local diagnosticEnabled=true
local publisher={
    isEligible=function(_,class,severity,code)
        assert(class=="DIAGNOSTIC" and severity=="INFO"
            and code=="NATIVE_CONTINUATION_WITNESS")
        return diagnosticEnabled
    end,
    publish=function(_,class,severity,code,makePayload)
        assert(class=="DIAGNOSTIC" and severity=="INFO")
        published[#published+1]={code=code,detail=makePayload().detail}
    end
}
local reads=0
local roots=setmetatable({},{__mode="k"})
getWorldTranslation=function(node)
    reads=reads+1
    return roots[node].x,0,roots[node].z
end
local function actor(id,x)
    local node={}
    roots[node]={x=x,z=10}
    local job={}
    local strategy={isBlocked=true}
    local vehicle={rootNode=node,job=job,
        spec_aiFieldWorker={isActive=true,
            driveStrategies={strategy},
            aiDriveParams={valid=true,maxSpeed=6}}}
    vehicle.getJob=function(self)return self.job end
    return {vehicle=vehicle,assemblyReferenceKey=id,
        sourceJobReference=job,sourceStrategyReference=strategy}
end
local mover,peer=actor("M",10),actor("P",12)
local token={}
local observer={getCurrentPairCandidates=function()
    return {{candidateIdentity=token,pairKey="M|P"}}
end}
local physical={reverseMechanism={states={}},
    transitMechanism={requests={}},
    regulationMechanism={leases={}},
    holdMechanism={holds={}}}
dofile("scripts/diagnostics/NativeContinuationWitness.lua")
local Witness=OuttaMyWay.NativeContinuationWitness
local witness=Witness.new(publisher)
local movement={relocator=mover,blockers={peer}}
local outcome={status="EGRESS_INTERRUPTED",
    reason="PAIR_TRAJECTORY_DIVERGED",commitmentId="pair1"}
assert(witness:begin(1000,movement,outcome,observer,token,"M|P",true,physical))
assert(#published==1 and published[1].detail:find("candidate=SAME_NATIVE_OCCURRENCE",1,true))
assert(published[1].detail:find("moverIsBlocked=true",1,true))
assert(published[1].detail:find("moverReverseLease=false",1,true))
assert(published[1].detail:find("moverDriveParamsValid=true",1,true))
local initialReads=reads
for i=1,30 do witness:advance(1000+i*10) end
assert(#published==1 and reads==initialReads,"no continuous sensor polls")
roots[mover.vehicle.rootNode].x=11
witness:advance(1500)
assert(#published==2 and published[2].detail:find("moverRootDisplacementM=1",1,true))
assert(published[2].detail:find("peerJobSame=true",1,true))
mover.vehicle.job={}
mover.sourceStrategyReference.isBlocked=false
witness:advance(3000)
assert(#published==3 and published[3].detail:find("moverJobSame=false",1,true))
assert(published[3].detail:find("moverIsBlocked=false",1,true),
    "native blocker flag may clear during continuation")
observer.getCurrentPairCandidates=function()return {} end
witness:advance(6000)
assert(#published==4 and published[4].detail:find("candidate=NO_PAIR_CANDIDATE",1,true))
assert(not witness:isActive())
local totalReads=reads
witness:advance(10000)
assert(#published==4 and reads==totalReads,"no post-window polling")
assert(not witness:begin(10000,movement,{status="NATIVE_RESTART_ACCEPTED"}))
-- Supersession by another admitted intervention never changes vehicle state.
mover.vehicle.job=mover.sourceJobReference
assert(witness:begin(12000,movement,outcome,observer,token,"M|P",true,physical))
witness:finish(12500,"NEW_COMMITMENT")
assert(#published==6 and published[#published].code=="NATIVE_CONTINUATION_WITNESS_ENDED")
assert(not witness:isActive())
diagnosticEnabled=false
local beforeReads=reads
local beforeLines=#published
assert(not witness:begin(15000,movement,outcome,observer,token,"M|P",
    true,physical))
witness:advance(20000)
assert(reads==beforeReads and #published==beforeLines
    and not witness:isActive(),"suppressed DIAGNOSTIC performs no witness reads")
diagnosticEnabled=true
assert(witness:begin(25000,movement,outcome,observer,token,"M|P",true,physical))
beforeReads=reads
diagnosticEnabled=false
witness:advance(25500)
assert(not witness:isActive() and reads==beforeReads,
    "active witness must stop sampling when DIAGNOSTIC is disabled")
print("Native continuation witness: finite passive readings, occurrence identity, lease state, supersession PASS")
