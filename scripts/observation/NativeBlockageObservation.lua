-- Passive, server-side native field-course isBlocked sampler for eligible AI workers.
-- Specification Jurisdictions: `NATIVE_BLOCKAGE_OBSERVATION`
-- GIANTS owns this state. Never replace callbacks, create native events or command vehicles.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeBlockageObservation={}
local Observer=OuttaMyWay.NativeBlockageObservation
Observer.__index=Observer
local publication=OuttaMyWay.LogPublication.origin("NATIVE_BLOCKAGE_OBSERVATION")

local function finite(n)
    return type(n)=="number" and n==n and n~=math.huge and n~=-math.huge
end

-- This is GIANTS' ordinary activeJobVehicles table, proven in the earlier
-- passive field-worker experiment, not an OMW sealed-proxy collection.
local function activeFieldWorkers()
    local mission=g_currentMission
    local registry=mission and mission.aiSystem and mission.aiSystem.activeJobVehicles
    if type(registry)~="table" then return nil end

    local result,seen={},{}
    local function include(worker)
        if type(worker)~="table" or seen[worker] then return end
        local spec=worker.spec_aiFieldWorker
        if type(spec)~="table" or spec.isActive~=true then return end
        seen[worker]=true
        result[#result+1]=worker
    end
    for key,value in pairs(registry) do
        include(key)
        include(value)
        if type(value)=="table" then
            include(value.vehicle)
            include(value.object)
            include(value.rootVehicle)
            include(value[1])
        end
    end
    return result
end

local function fieldCourseStrategy(worker)
    local spec=worker.spec_aiFieldWorker
    local strategies=spec and spec.driveStrategies
    if type(strategies)~="table" then return nil end
    for _,strategy in pairs(strategies) do
        if type(strategy)=="table" and type(strategy.isBlocked)=="boolean" then
            local name=strategy.className
                or (type(strategy.class)=="table" and strategy.class.className)
            if strategy.aiFieldCourse~=nil
                or (type(name)=="string" and string.find(name,"FieldCourse",1,true)~=nil) then
                return strategy
            end
        end
    end
    return nil
end

local function jobReference(worker)
    local jobSpec=worker.spec_aiJobVehicle
    return (jobSpec and jobSpec.job)
        or (worker.spec_aiFieldWorker and worker.spec_aiFieldWorker.fieldJob)
end

local function rootVehicle(worker)
    if type(worker.getRootVehicle)=="function" then
        local ok,root=pcall(worker.getRootVehicle,worker)
        if ok and type(root)=="table" then return root end
    end
    return worker.rootVehicle or worker
end

local function rootRecord(worker)
    local root=rootVehicle(worker)
    if type(root)~="table" or root.rootNode==nil
        or type(getWorldTranslation)~="function" then return nil end
    local ok,x,_,z=pcall(getWorldTranslation,root.rootNode)
    if not ok or not finite(x) or not finite(z) then return nil end
    return {rootId=root.rootNode,x=x,z=z,eligible=true}
end

local function eligibleRoots(workers)
    local roots,seen={},{}
    for i=1,#workers do
        local record=rootRecord(workers[i])
        if record~=nil and not seen[record.rootId] then
            seen[record.rootId]=true
            roots[#roots+1]=record
        end
    end
    return roots
end

-- A pair is an unordered identity, irrespective of which GIANTS worker
-- first reports blockage. This coalesces reciprocal observations; it does not
-- decide which worker should hold, relocate or assume Control.
local function pairKey(firstRootId,secondRootId)
    local first=tostring(firstRootId)
    local second=tostring(secondRootId)
    if first>second then first,second=second,first end
    return first.."|"..second
end

local function findRootWorker(workers,rootId)
    for i=1,#workers do
        local record=rootRecord(workers[i])
        if record~=nil and record.rootId==rootId then return workers[i] end
    end
    return nil
end

local function pairStillCurrent(pair,present)
    local first,second=pair.firstWorker,pair.secondWorker
    if not present[first] or not present[second]
        or jobReference(first)~=pair.firstJob
        or jobReference(second)~=pair.secondJob
        or fieldCourseStrategy(first)~=pair.firstStrategy
        or fieldCourseStrategy(second)~=pair.secondStrategy then return false end

    -- Only the GIANTS-owned field-course strategy's native blocked state
    -- maintains this occurrence; a distinct specialization flag is not needed.
    if pair.firstStrategy.isBlocked~=true and pair.secondStrategy.isBlocked~=true then
        return false
    end

    local a=rootRecord(first)
    local b=rootRecord(second)
    if a==nil or b==nil then return false end
    local dx=a.x-b.x
    local dz=a.z-b.z
    return dx*dx+dz*dz<=900 -- same already-accepted 30 m locality
end

function Observer.new(configuration)
    return setmetatable({configuration=configuration,states={},pairs={},singles={}},Observer)
end

function Observer:loadMap()
    self.states={}
    self.pairs={}
    self.singles={}
end

function Observer:deleteMap()
    self.states={}
    self.pairs={}
    self.singles={}
end

-- Delivers a copy of currently live candidate evidence to the separate
-- Pair Commitment authority. Observation never grants or exercises Control.
function Observer:getCurrentPairCandidates()
    local results={}
    if not self:isEnabled() then return results end
    for _,pair in pairs(self.pairs) do
        results[#results+1]={
            candidateIdentity=pair,
            pairKey=pair.pairKey,
            firstWorker=pair.firstWorker,secondWorker=pair.secondWorker,
            blockedWorker=pair.blockedWorker,
            confirmedBlockedMs=pair.confirmedBlockedMs
        }
    end
    return results
end


-- Native solo concern identity is scoped to the current positive blocked pulse.
-- It is not a retained stop/start attempt history or a fabricated pair.
function Observer:getCurrentSingleCandidates()
    local results={}
    if not self:isEnabled() then return results end
    for _,entry in pairs(self.singles) do
        results[#results+1]={
            candidateIdentity=entry,worker=entry.worker,
            confirmedBlockedMs=entry.confirmedBlockedMs,
            encounterSnapshot=entry.encounterSnapshot
        }
    end
    return results
end

function Observer:isEnabled()
    local c=self.configuration
    return g_server~=nil and c~=nil
        and c:isResolved()==true and c:isEnabled()==true
end

-- Sample only active native field-course workers, using GIANTS' *own* updated
-- strategy.isBlocked field. Only adjacent positive samples accrue time; a
-- false/unknown reading or job/strategy change closes the current pulse.
-- Cross-pulse episode association remains separate from this gate; a
-- full ≥1 s native pulse is sufficient. Reciprocal worker observations are
-- represented by one unordered active pair identity, not two resolutions.
function Observer:update(dt)
    if not self:isEnabled() then
        self.states={}
        self.pairs={}
        self.singles={}
        return
    end

    local nowMs=tonumber(g_time)
    local workers=activeFieldWorkers()
    if not finite(nowMs) or workers==nil then
        self.states={}
        self.pairs={}
        self.singles={}
        return
    end

    local present={}
    for i=1,#workers do present[workers[i]]=true end
    for worker,entry in pairs(self.singles) do
        if not present[worker]
            or jobReference(worker)~=entry.job
            or fieldCourseStrategy(worker)~=entry.strategy
            or entry.strategy.isBlocked~=true then
            self.singles[worker]=nil
        end
    end
    for key,pair in pairs(self.pairs) do
        if not pairStillCurrent(pair,present) then self.pairs[key]=nil end
    end

    for i=1,#workers do
        local worker=workers[i]
        local strategy=fieldCourseStrategy(worker)
        local job=jobReference(worker)
        if strategy==nil or job==nil then
            self.states[worker]=nil
            self.singles[worker]=nil
        else
            local isBlocked=strategy.isBlocked
            local state=self.states[worker]
            if state==nil or state.job~=job or state.strategy~=strategy
                or nowMs<state.lastSampleMs then
                self.singles[worker]=nil
                state={job=job,strategy=strategy,lastSampleMs=nowMs,
                    wasBlocked=false,confirmedBlockedMs=0,reported=false,
                    encounterSnapshot=nil}
            end

            if isBlocked then
                if state.wasBlocked and nowMs>=state.lastSampleMs then
                    state.confirmedBlockedMs=state.confirmedBlockedMs
                        +(nowMs-state.lastSampleMs)
                else
                    state.confirmedBlockedMs=0
                    state.reported=false
                    -- One current physical observation on the FIRST sampled
                    -- positive edge. No synthetic impact timestamp.
                    state.encounterSnapshot=
                        OuttaMyWay.StaticBlockageEncounterObservation.capture(
                            worker,g_currentMission,nowMs)
                end
                if not state.reported and state.confirmedBlockedMs>=1000 then
                    local subject=rootRecord(worker)
                    if subject~=nil then
                        local result=OuttaMyWay.SpatialPairInference.evaluate(
                            state.confirmedBlockedMs,subject,eligibleRoots(workers))
                        state.reported=true
                        local pairIdentity=nil
                        local shouldPublish=true
                        if result~=nil then
                            self.singles[worker]=nil
                            pairIdentity=pairKey(subject.rootId,result.rootId)
                            if self.pairs[pairIdentity]~=nil then
                                -- A reciprocal blocked signal describes the same pair.
                                shouldPublish=false
                            else
                                local other=findRootWorker(workers,result.rootId)
                                if other~=nil then
                                    self.pairs[pairIdentity]={
                                        firstWorker=worker,secondWorker=other,
                                        firstJob=job,secondJob=jobReference(other),
                                        firstStrategy=strategy,
                                        secondStrategy=fieldCourseStrategy(other),
                                        blockedWorker=worker,
                                        confirmedBlockedMs=state.confirmedBlockedMs,
                                        pairKey=pairIdentity
                                    }
                                end
                            end
                        end
                        if result==nil then
                            self.singles[worker]={
                                worker=worker,job=job,strategy=strategy,
                                confirmedBlockedMs=state.confirmedBlockedMs,
                                encounterSnapshot=state.encounterSnapshot
                            }
                        end
                        if result==nil and state.encounterSnapshot~=nil
                            and state.encounterSnapshot.populationAvailable==true then
                            publication:publish("DEBUG","INFO",
                                "NATIVE_BLOCKAGE_ENCOUNTER_SNAPSHOT",function()
                                    return {
                                        blockedRootId=tostring(subject.rootId),
                                        confirmedBlockedMs=math.floor(state.confirmedBlockedMs),
                                        evidence=OuttaMyWay.StaticBlockageEncounterObservation.describe(
                                            state.encounterSnapshot),
                                        authority="OBSERVATION_ONLY"
                                    }
                                end)
                        end
                        if shouldPublish then
                            local code=result~=nil and "NATIVE_BLOCKAGE_PAIR_CANDIDATE"
                                or "NATIVE_BLOCKAGE_NO_LOCAL_WORKER"
                            publication:publish("DEBUG","INFO",code,function()
                                return {
                                    blockedRootId=tostring(subject.rootId),
                                    partnerRootId=result and tostring(result.rootId) or "none",
                                    pairKey=pairIdentity or "none",
                                    distanceM=result and result.distanceMetres or "unavailable",
                                    confirmedBlockedMs=math.floor(state.confirmedBlockedMs),
                                    authority="OBSERVATION_ONLY"
                                }
                            end)
                        end
                    end
                end
            else
                self.singles[worker]=nil
                state.confirmedBlockedMs=0
                state.reported=false
                state.encounterSnapshot=nil
            end
            state.wasBlocked=isBlocked
            state.lastSampleMs=nowMs
            self.states[worker]=state
        end
    end
    -- Leaving GIANTS' active-job registry is not native unblock evidence.
    for worker in pairs(self.states) do
        if not present[worker] then
            self.states[worker]=nil
            self.singles[worker]=nil
        end
    end
end
