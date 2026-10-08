-- Live-sampler contract with a simulated GIANTS server; no job or Control APIs.
local emissions={}
OuttaMyWay={
    LogPublication={origin=function(name)
        assert(name=="NATIVE_BLOCKAGE_OBSERVATION")
        return {publish=function(_,level,severity,code,builder)
            assert(level=="DEBUG" and severity=="INFO")
            emissions[#emissions+1]={code=code,data=builder()}
        end}
    end}
}
dofile("scripts/assessment/SpatialPairInference.lua")
dofile("scripts/observation/NativeBlockageObservation.lua")

local enabled=true
local config={
    isResolved=function() return true end,
    isEnabled=function() return enabled end
}
local poses={
    [100]={x=0,z=0},
    [200]={x=6,z=8},
    [300]={x=20,z=20}
}
getWorldTranslation=function(node)
    local p=poses[node]
    if p==nil then error("missing root position") end
    return p.x,0,p.z
end
local function worker(id)
    local strategy={aiFieldCourse={},isBlocked=false}
    local job={}
    local vehicle={rootNode=id,rootVehicle=nil,
        spec_aiFieldWorker={isActive=true,driveStrategies={strategy}},
        spec_aiJobVehicle={job=job}}
    vehicle.rootVehicle=vehicle
    vehicle.getRootVehicle=function(self) return self end
    return vehicle,strategy,job
end

local a,courseA,jobA=worker(100)
local b,courseB=worker(200)
local c,courseC=worker(300)
g_server={}
local active={[a]=true,[b]=true,[c]=true}
g_currentMission={aiSystem={activeJobVehicles=active}}
g_time=0
local observation=OuttaMyWay.NativeBlockageObservation.new(config)
observation:loadMap()
observation:update(16)
assert(#emissions==0,"no initial positive evidence")

-- A transient 0.8 s native pulse cannot trigger the existing gate.
courseA.isBlocked=true
g_time=100;observation:update(16)
g_time=800;observation:update(16)
courseA.isBlocked=false
g_time=900;observation:update(16)
assert(#emissions==0,"transient positive edge must not nominate")

-- One full pulse can feed the previously implemented pure evaluator.
courseA.isBlocked=true
g_time=1000;observation:update(16)
g_time=1999;observation:update(16)
assert(#emissions==0,"999 ms must not nominate")
g_time=2000;observation:update(16)
assert(#emissions==1,"1000 ms should nominate once")
assert(emissions[1].code=="NATIVE_BLOCKAGE_PAIR_CANDIDATE")
assert(emissions[1].data.blockedRootId=="100")
assert(emissions[1].data.partnerRootId=="200")
assert(emissions[1].data.distanceM==10)
assert(emissions[1].data.authority=="OBSERVATION_ONLY")
g_time=2700;observation:update(16)
assert(#emissions==1,"long pulse must not spam publication")

-- A distinct pulse is not added to the preceding pulse without
-- established same-encounter continuity.
courseA.isBlocked=false
g_time=2800;observation:update(16)
courseA.isBlocked=true
g_time=2900;observation:update(16)
g_time=3400;observation:update(16)
assert(#emissions==1,"false edge resets this tranche's pulse accumulator")
g_time=3900;observation:update(16)
assert(#emissions==2 and emissions[2].data.partnerRootId=="200")

-- No eligible other worker in 30 m is not an invented blocking pair.
courseA.isBlocked=false
g_time=4000;observation:update(16)
active[b]=nil
poses[300]={x=31,z=0}
courseA.isBlocked=true
g_time=4100;observation:update(16)
g_time=5100;observation:update(16)
assert(#emissions==3 and emissions[3].code=="NATIVE_BLOCKAGE_NO_LOCAL_WORKER")
assert(emissions[3].data.partnerRootId=="none")

-- A changed native Job Episode cannot inherit the old positive duration.
a.spec_aiJobVehicle.job={}
g_time=5200;observation:update(16)
assert(#emissions==3)
g_time=6100;observation:update(16)
assert(#emissions==3,"job turnover must restart native evidence")
g_time=6200;observation:update(16)
assert(#emissions==4,"new job qualifies only after its own full pulse")

-- An absent strategy or worker registry cannot keep stale evidence.
a.spec_aiFieldWorker.driveStrategies={}
g_time=6300;observation:update(16)
assert(observation.states[a]==nil)
a.spec_aiFieldWorker.driveStrategies={courseA}
active[a]=nil
g_time=6400;observation:update(16)
assert(observation.states[a]==nil)

-- Disabled, non-server and map teardown always relinquish observation.
active[a]=true
enabled=false
g_time=6500;observation:update(16)
assert(next(observation.states)==nil,"disabled discards prior state")
enabled=true
g_server=nil
g_time=6600;observation:update(16)
assert(next(observation.states)==nil,"clients do not sample server state")
g_server={}
observation:deleteMap()
assert(next(observation.states)==nil,"map deletion discards evidence")
assert(OuttaMyWay.nativeBlockedEventTap==nil,"retired constructor hook remains absent")
assert(OuttaMyWay.runtime==nil,"no AI Control runtime")
print("Passive native blocked Observation / 1s candidate handoff / lifecycle: PASS")
