-- First observed native blocked edge: one physical pose/facing census per pulse.
-- Reactive recovery is not changed; no actual GIANTS collision attribution.
local publications={}
OuttaMyWay={LogPublication={origin=function()return {
    publish=function(_,level,severity,code,builder)
        assert(level=="DEBUG" and severity=="INFO")
        publications[#publications+1]={code=code,data=builder()}
    end
} end}}
dofile("scripts/assessment/SpatialPairInference.lua")
dofile("scripts/observation/StaticBlockageEncounterObservation.lua")
dofile("scripts/observation/NativeBlockageObservation.lua")
local scans,shapes=0,0
local coords={
    [11]={x=0,z=0},
    [22]={x=0,z=5},
    [33]={x=11,z=0},
    [44]={x=28,z=0}
}
getWorldTranslation=function(node)
    assert(coords[node],"missing native pose")
    return coords[node].x,0,coords[node].z
end
localDirectionToWorld=function(node,x,y,z)
    if node==22 then return z,y,0 end
    if node==33 then return 0,y,-z end
    return x,y,z
end
-- Never query shape primitives or GIANTS geometry during blocked-edge sampling.
getShapeWorldBoundingSphere=function()shapes=shapes+1;error("forbidden")end
local function vehicle(node,aiActive)
    return {
        rootNode=node,
        getRootVehicle=function(self)return self end,
        getAISteeringNode=function(self)return self.rootNode end,
        getIsAIActive=function()
            scans=scans+1
            return aiActive
        end,
        getIsControlled=function()return false end
    }
end
local worker=vehicle(11,true)
local strategy={aiFieldCourse={},isBlocked=false}
local job={}
worker.spec_aiFieldWorker={isActive=true,driveStrategies={strategy}}
worker.spec_aiJobVehicle={job=job}
local blocker=vehicle(22,false)
blocker.lastSpeedReal=0.0015 -- GIANTS native raw value; 1.50 m/s
local other=vehicle(33,true)
local distant=vehicle(44,false)
g_server={}
g_time=0
g_currentMission={
    aiSystem={activeJobVehicles={[worker]=true}},
    vehicleSystem={vehicles={[worker]=true,[blocker]=true,[other]=true,[distant]=true}}
}
local enabled=true
local config={isResolved=function()return true end,isEnabled=function()return enabled end}
local observer=OuttaMyWay.NativeBlockageObservation.new(config)
observer:loadMap()
observer:update(16)
assert(scans==0,"ordinary unblocked updates never scan current physical inventory")
strategy.isBlocked=true
g_time=100;observer:update(16)
local firstScan=scans
assert(firstScan==3 and shapes==0,"one first-edge inventory read")
local state=observer.states[worker]
local first=assert(state.encounterSnapshot)
assert(first.observedAtMs==100
    and first.kind=="FIRST_OBSERVED_NATIVE_BLOCKED_EDGE")
assert(first.beneficiaryFacing.x==0 and first.beneficiaryFacing.z==1)
assert(first.physicalAssemblyCount==3 and #first.nearestPhysicalAssemblies==3)
local near=first.nearestPhysicalAssemblies[1]
assert(near.rootId==22 and near.x==0 and near.z==5
    and near.distanceM==5 and near.relativeForwardM==5
    and near.relativeCrossTrackM==0
    and near.facingAlignmentDot==0
    and near.reportedSpeedMps==1.5
    and near.aiActive==false and near.playerControlled==false)
-- Not physically remeasured after the first edge, even when subject moves.
coords[22].z=9
g_time=600;observer:update(16)
assert(scans==firstScan and #publications==0)
g_time=1100;observer:update(16)
local singles=observer:getCurrentSingleCandidates()
assert(#singles==1 and singles[1].encounterSnapshot==first
    and first.nearestPhysicalAssemblies[1].z==5)
assert(scans==firstScan and shapes==0)
assert(#publications==2
    and publications[1].code=="NATIVE_BLOCKAGE_ENCOUNTER_SNAPSHOT"
    and publications[2].code=="NATIVE_BLOCKAGE_NO_LOCAL_WORKER")
local evidence=publications[1].data.evidence
assert(evidence:find("edgeMs=100",1,true))
assert(evidence:find(
    "near1=22 x=0.00 z=5.00 forwardX=1.00 forwardZ=0.00"
        .." facingSource=NATIVE_STEERING_NODE reportedSpeedMps=1.50",1,true))
assert(evidence:find(
    "near2=33 x=11.00 z=0.00 forwardX=0.00 forwardZ=-1.00"
        .." facingSource=NATIVE_STEERING_NODE reportedSpeedMps=unknown",1,true))
assert(evidence:find("aiActive=false",1,true)
    and not evidence:find("staticCandidateAI",1,true))
assert(scans==firstScan and shapes==0,"publication only formats captured fields")
g_time=2100;observer:update(16)
assert(scans==firstScan and #publications==2,"long pulse no rescan or republish")

-- A new pulse acquires one new sample, not the old approach angle.
strategy.isBlocked=false
g_time=2200;observer:update(16)
coords[22].z=7
g_time=2300;strategy.isBlocked=true;observer:update(16)
assert(scans==firstScan+3)
assert(observer.states[worker].encounterSnapshot.observedAtMs==2300)
assert(observer.states[worker].encounterSnapshot.nearestPhysicalAssemblies[1].z==7)
-- A new GIANTS job while blocked never inherits the earlier sample.
worker.spec_aiJobVehicle.job={}
g_time=2350;observer:update(16)
assert(observer.states[worker].encounterSnapshot.observedAtMs==2350
    and scans==firstScan+6)

-- Missing API or population yields unknown evidence, not a blocker claim.
g_currentMission.vehicleSystem=nil
strategy.isBlocked=false
g_time=2400;observer:update(16)
strategy.isBlocked=true
g_time=2500;observer:update(16)
local unresolved=observer.states[worker].encounterSnapshot
assert(not unresolved.populationAvailable
    and #unresolved.nearestPhysicalAssemblies==0)
-- Player control is recorded, not converted into permission to actuate.
g_currentMission.vehicleSystem={vehicles={[worker]=true,[blocker]=true}}
g_currentMission.controlledVehicle=blocker
strategy.isBlocked=false
g_time=2600;observer:update(16)
strategy.isBlocked=true
g_time=2700;observer:update(16)
assert(observer.states[worker].encounterSnapshot.nearestPhysicalAssemblies[1].playerControlled==true)
-- Lifecycle cleanup relinquishes all retained single-pulse evidence.
observer:deleteMap()
assert(next(observer.states)==nil and next(observer.singles)==nil)
assert(shapes==0)
print("Native blocked-edge one-shot encounter / facing / pulse lifecycle: PASS")
