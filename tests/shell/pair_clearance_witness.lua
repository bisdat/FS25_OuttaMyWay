-- Witness is bounded, passive, and never confers egress authority.
OuttaMyWay={VERSION="TEST"}
local records={}
local diagnosticEnabled=true
local publication={
    isEligible=function(_,class,severity,code)
        assert(class=="DIAGNOSTIC" and severity=="INFO"
            and code=="PAIR_CLEARANCE_OBSERVATION")
        return diagnosticEnabled
    end,
    publish=function(_,class,severity,code,make)
        assert(class=="DIAGNOSTIC" and severity=="INFO")
        records[#records+1]={code=code,payload=make()}
    end
}
local points={}
getWorldTranslation=function(node)
    local p=assert(points[node]);return p.x,0,p.z
end
localDirectionToWorld=function(node,_,__,z)
    return 0,0,z
end
local function actor(root,x,z)
    points[root]={x=x,z=z}
    local vehicle={rootNode=root,getAISteeringNode=function(v)return v.rootNode end}
    return {vehicle=vehicle,assemblyReferenceKey=root,
        transitFootprint={memberGeometry={{object=vehicle}}}}
end
local a,b=actor("a",0,0),actor("b",10,0)
local gaps={5,4,3,2,1,0.8,0.5,0.3}
local samples=0
OuttaMyWay.PairTransitRegion={observePairNominalGap=function()
    samples=samples+1
    return gaps[math.min(samples,#gaps)]
end}
OuttaMyWay.ProjectedEgressRegion={progress=function(_,x,z)
    return {progressM=x,lateralOffsetM=math.abs(z)}
end}
dofile("scripts/diagnostics/PairClearanceWitness.lua")
local w=OuttaMyWay.PairClearanceWitness.new(publication)
local state={commitmentId="pair-1",relocator=a,blockers={b},
    objective={returnRegion={},regionTravelM=11,directionSource="REVERSE_REGION"}}
assert(w:begin(1000,state))
assert(#records==1 and records[1].payload.rootSeparationM==10)
local oldSamples=samples
for t=1001,2499,16 do w:advance(t) end
assert(samples==oldSamples,"nothing sampled per frame before the deadline")
points[a.vehicle.rootNode].x=-1
w:advance(2500)
assert(#records==2)
assert(records[2].payload.observedNominalGapClosingMps>0)
assert(records[2].payload.straightLineNominalTimeToZeroS~=nil)
w:milestone(3000,"RETURN_REGION_REACHED")
assert(#records==3 and records[3].payload.milestone=="RETURN_REGION_REACHED")
w:advance(5000)
assert(#records==4 and records[4].payload.milestone=="HOLD_OBSERVATION")
w:milestone(6000,"REGULATION_ENDED")
assert(#records==5 and records[5].payload.milestone=="REGULATION_ENDED")
w:milestone(8000,"NATIVE_RESTART_ACCEPTED")
assert(#records==6 and records[6].payload.milestone=="NATIVE_RESTART_ACCEPTED")
w:advance(9000)
w:advance(11000)
w:advance(13000)
assert(#records==9 and w.active==nil)
local last=samples;w:advance(50000)
assert(samples==last and #records==9)
assert(not w:begin(1000,{isSingle=true}))
assert(w:begin(60000,state))
w:milestone(60100,"EGRESS_INTERRUPTED")
assert(w.active==nil and records[#records].payload.milestone=="EGRESS_INTERRUPTED")
-- Suppressed DIAGNOSTIC must skip starting the witness AND all geometry sampling.
diagnosticEnabled=false
local before=#records
local beforeSamples=samples
assert(not w:begin(90000,state))
w:advance(92000)
assert(w.active==nil and #records==before and samples==beforeSamples)
-- Disabling while active must discard the witness without another sample.
diagnosticEnabled=true
assert(w:begin(100000,state))
beforeSamples=samples
diagnosticEnabled=false
w:advance(102000)
assert(w.active==nil and samples==beforeSamples)
print("Pair clearance witness: bounded samples, spatial and temporal proxy, independent phase boundaries PASS")
