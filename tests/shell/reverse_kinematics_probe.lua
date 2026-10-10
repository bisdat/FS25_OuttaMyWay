-- #470: signed initial-state and bounded first-five-second probe, no GIANTS dependency.
OuttaMyWay={VERSION="0.5.2.25"}
dofile("scripts/diagnostics/ReverseKinematicsProbe.lua")
local Probe=OuttaMyWay.ReverseKinematicsProbe
local events,enabled={},false
OuttaMyWay.LogPublication={origin=function()
    return {
        isEligible=function(_,class) return enabled and class=="DIAGNOSTIC" end,
        publish=function(_,class,level,code,builder)
            assert(class=="DIAGNOSTIC" and level=="INFO")
            events[#events+1]={code=code,payload=builder()}
            return true
        end
    }
end}
g_time=10000
local degrees=math.pi/180
local positions={
    [1]={x=0,z=0},[2]={x=0,z=0},[3]={x=0,z=-2}
}
getWorldTranslation=function(node)
    local p=positions[node]
    assert(p~=nil)
    return p.x,0,p.z
end
local toolYaw=45
localDirectionToWorld=function(node,x,y,z)
    if node==3 then
        return math.sin(toolYaw*degrees)*z+x,y,
            math.cos(toolYaw*degrees)*z
    end
    return x,y,z
end
local goalX=-math.sin(80*degrees)
local goalZ=-math.cos(80*degrees)
local objective={isReverse=true,targetX=goalX*53,targetZ=goalZ*53,
    steeringHorizonM=53,
    returnRegion={originX=0,originZ=0,directionX=goalX,
        directionZ=goalZ,requiredProgressM=13}}
local vehicle={rootNode=1}
assert(Probe.begin(vehicle,2,3,objective,22)==nil and #events==0,
    "NORMAL/DEBUG cannot create probe or sample frame geometry")
enabled=true
local p=assert(Probe.begin(vehicle,2,3,objective,22))
assert(#events==1 and events[1].code=="REVERSE_KINEMATICS_START")
local start=events[1].payload
assert(start.hasToolReverser and start.regionRequiredProgressM==13
    and start.steeringHorizonM==53 and start.requestedReverseKmh==22)
assert(start.reverseNodeX==0 and start.reverseNodeZ==0
    and start.toolNodeX==0 and start.toolNodeZ==-2
    and start.additionalSteeringLookthroughM==40,
    "admission captures actual node origins and separates travel from look-through")
assert(math.abs(math.abs(start.initialToolVsReverserNodeDeg)-45)<0.001,
    "initial implement/reverser node-frame angle must not be erased")
assert(math.abs(math.abs(start.signedRegionFromReverseDeg)-80)<0.001,
    "signed target bearing distinguishes 80 from 13 degrees")
for n=0,10 do
    g_time=10000+n*500
    positions[1].x=goalX*n/2
    positions[1].z=goalZ*n/2
    toolYaw=45*(1-n/10)
    Probe.sample(p,-0.9,-0.436,12,-25,16,n/2,0.02*n)
    assert(p.sampleCount==n+1)
    if n==0 then
        g_time=g_time+100
        Probe.sample(p,-0.9,-0.436,12,-25,16,0,0)
        assert(p.sampleCount==1,"only a bounded once-per-interval sample")
    end
end
assert(#events==12 and p.sampleCount==11)
local first=events[2].payload
local last=events[#events].payload
assert(first.elapsedMs==0 and last.elapsedMs==5000)
assert(math.abs(math.abs(first.toolVsReverserNodeDeg)-45)<0.001)
assert(math.abs(last.toolVsReverserNodeDeg)<0.001)
assert(last.sampledRootSpeedKmh>0 and last.regionProgressM==5)
assert(math.abs(last.driveLocalX+0.9)<0.0001
    and math.abs(last.driveLocalZ+0.436)<0.0001)
g_time=15001
Probe.sample(p,0,1,10,10,16,12,3)
assert(p.sampleCount==11 and #events==12,
    "diagnostic must stop sampling after five seconds")
Probe.finish(p,"RETURN_REGION_REACHED",13,0.75)
assert(#events==13 and events[13].code=="REVERSE_KINEMATICS_END"
    and events[13].payload.samplesPublished==11)
local withoutTool=assert(Probe.begin(vehicle,2,nil,objective,22))
assert(events[#events].payload.hasToolReverser==false
    and events[#events].payload.initialToolVsReverserNodeDeg==nil,
    "missing GIANTS tool frame must be reported as missing, not invented")
Probe.sample(withoutTool,0,1,0,-15,16,0,0)
assert(events[#events].payload.toolVsReverserNodeDeg==nil)
-- #470 passive counterfactual study: no shadow value may alter the *actual*
-- local command; changing look-through must only change diagnostic payload.
worldToLocal=function(_,x,y,z) return x,y,z end
toolYaw=0
g_time=30000
local witness=assert(Probe.begin(vehicle,2,3,objective,22))
local count=0
local function syntheticTransform(_,_,x,z,capture)
    assert(capture==true)
    count=count+1
    return x+4,z+2,nil,{
        toolLongitudinalM=x,toolSignedLateralM=z,
        toolDistanceToTargetM=math.sqrt(x*x+z*z),
        signedToolFrameRotationDeg=15,
        rotatedLateralM=3,rotatedLongitudinalM=5}
end
local adjustedX=objective.targetX+4
local adjustedZ=objective.targetZ+2
local length=math.sqrt(adjustedX^2+adjustedZ^2)
local sentX,sentZ=adjustedX/length,adjustedZ/length
Probe.sample(witness,sentX,sentZ,adjustedX,adjustedZ,
    16,0,0,syntheticTransform)
assert(count==5,"actual transform plus four passive look-through alternatives")
local sample=events[#events].payload
assert(sample.reverseNodeX==0 and sample.toolNodeZ==-2)
assert(sample.transformToolLongitudinalM==objective.targetX
    and sample.transformToolSignedLateralM==objective.targetZ
    and sample.transformSignedRotationDeg==15)
assert(math.abs(sample.actualReconstructionDifferenceDeg)<0.00001,
    "the recomputed actual command must match the GIANTS-issued command")
for _,extra in ipairs({0,10,20,40}) do
    local key="shadowLookthrough"..extra
    assert(type(sample[key.."BearingDeg"])=="number"
        and type(sample[key.."AdjustedWorldX"])=="number"
        and type(sample[key.."AdjustedWorldZ"])=="number",
        "each shorter look-through must publish diagnostic geometry")
end
assert(sample.shadowLookthrough0BearingDeg~=
    sample.shadowLookthrough40BearingDeg,
    "shorter look-through affects shadow steering, not actual drive")
g_time=30100
Probe.sample(witness,sentX,sentZ,adjustedX,adjustedZ,
    16,0,0,syntheticTransform)
assert(count==5,"shadow math must not run on non-sampled drive calls")
enabled=false
assert(Probe.begin(vehicle,2,3,objective,22)==nil)
print("Reverse kinematics probe: signed initial axis / optional tool / 5s cap / policy: PASS")
