-- Executes GIANTS-native FIELDWORK stop/immediate-restart after admitted relocation.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Subordinate mechanism only: source Job Episode admission, pair commitment and
-- productive continuation belong outside this module.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.NativeFieldworkJobReplacementMechanism={}
local Mechanism=OuttaMyWay.NativeFieldworkJobReplacementMechanism
Mechanism.__index=Mechanism

local function fail(reason)
    return false,{kind="NATIVE_FIELDWORK_REQUEST_FAILED",reason=reason,
        isOldJobStopped=false,isNewJobStarted=false}
end

local function invoke(target,method,...)
    if type(target)~="table" or type(target[method])~="function" then
        return false,"NATIVE_METHOD_UNAVAILABLE:"..tostring(method)
    end
    local ok,result,second=pcall(target[method],target,...)
    if not ok or result==false then
        return false,"NATIVE_CALL_FAILED:"..tostring(method)
    end
    return true,result,second
end

local function currentJob(vehicle)
    if type(vehicle)~="table" or type(vehicle.getJob)~="function" then
        return nil,"NATIVE_JOB_QUERY_UNAVAILABLE"
    end
    local ok,job=pcall(vehicle.getJob,vehicle)
    if not ok or job==nil then return nil,"NATIVE_JOB_UNAVAILABLE" end
    return job
end

local function discardBeforeStop(replacement)
    if type(replacement)~="table" or type(replacement.delete)~="function" then
        return false,"REPLACEMENT_DISPOSAL_UNAVAILABLE"
    end
    local ok=pcall(replacement.delete,replacement)
    if not ok then return false,"REPLACEMENT_DISPOSAL_UNCONFIRMED" end
    return true
end

function Mechanism.new(jobEpisodeSource)
    return setmetatable({jobEpisodeSource=jobEpisodeSource},Mechanism)
end

-- The injected source resolves the independently admitted original GIANTS job.
-- A physical adapter must not derive admission from the vehicle's presence,
-- current native job or an unverified candidate pair.
local function expectedJobFromSource(source,vehicle)
    if type(source)~="table" or type(source.getExpectedNativeJob)~="function" then
        return nil,"SOURCE_JOB_EPISODE_UNAVAILABLE"
    end
    local ok,job=pcall(source.getExpectedNativeJob,source,vehicle)
    if not ok or type(job)~="table" then
        return nil,"SOURCE_JOB_EPISODE_UNVERIFIED"
    end
    return job
end

-- All potentially fallible job creation, data capture and validation precede
-- the native stop. This isolates reversible preparation from the irreversible
-- hand-back commitment point.
local function prepare(vehicle)
    if g_server==nil then return nil,"SERVER_REQUIRED" end
    local mission=g_currentMission
    if type(mission)~="table" then return nil,"MISSION_UNAVAILABLE" end
    local aiSystem,manager=mission.aiSystem,mission.aiJobTypeManager
    if type(aiSystem)~="table" or aiSystem.isServer~=true
        or type(manager)~="table" then
        return nil,"NATIVE_JOB_SYSTEM_UNAVAILABLE"
    end
    if type(aiSystem.stopJob)~="function" or type(aiSystem.startJob)~="function" then
        return nil,"NATIVE_JOB_LIFECYCLE_UNAVAILABLE"
    end
    local job,jobReason=currentJob(vehicle)
    if job==nil then return nil,jobReason end

    local ok,fieldworkType=invoke(manager,"getJobTypeIndexByName","FIELDWORK")
    if not ok or fieldworkType==nil then return nil,"FIELDWORK_TYPE_UNAVAILABLE" end
    local typed,currentType=invoke(manager,"getJobTypeIndex",job)
    if not typed or currentType~=fieldworkType then
        return nil,"CURRENT_JOB_NOT_FIELDWORK"
    end
    local farmRead,farmId=invoke(vehicle,"getAIJobFarmId")
    if not farmRead or farmId==nil or farmId==false then
        return nil,"AI_JOB_FARM_UNAVAILABLE"
    end
    local created,replacement=invoke(manager,"createJob",fieldworkType)
    if not created or type(replacement)~="table" then
        return nil,"NATIVE_FIELDWORK_CREATE_FAILED"
    end

    local function preparationFailed(reason)
        local cleaned,why=discardBeforeStop(replacement)
        return nil,cleaned and reason or ("PREPARATION_CLEANUP_UNCONFIRMED:"..why)
    end
    if type(replacement.delete)~="function" then
        return nil,"REPLACEMENT_DISPOSAL_UNAVAILABLE"
    end
    local applied=invoke(replacement,"applyCurrentState",vehicle,mission,farmId,true)
    if not applied then return preparationFailed("NATIVE_FIELDWORK_APPLY_FAILED") end
    local valuesSet=invoke(replacement,"setValues")
    if not valuesSet then return preparationFailed("NATIVE_FIELDWORK_VALUES_FAILED") end
    -- validate() is a positive GIANTS semantic verdict, unlike void mutators.
    if type(replacement.validate)~="function" then
        return preparationFailed("NATIVE_FIELDWORK_VALIDATOR_UNAVAILABLE")
    end
    local validated,isValid=pcall(replacement.validate,replacement,farmId)
    if not validated or isValid~=true then
        return preparationFailed("NATIVE_FIELDWORK_VALIDATION_REJECTED")
    end
    return {mission=mission,aiSystem=aiSystem,manager=manager,
        vehicle=vehicle,oldJob=job,replacement=replacement,
        oldJobId=job.jobId,fieldworkType=fieldworkType,farmId=farmId}
end

-- The handback is a single native stop followed immediately by native start.
-- There is no vehicle-scoped attempt history, uncertainty state, or post-start
-- verification gate. GIANTS governs the resulting Job Episode and configuration.
function Mechanism:restartNativeFieldwork(vehicle)
    if type(vehicle)~="table" then return fail("VEHICLE_UNAVAILABLE") end
    local expected,reason=expectedJobFromSource(self.jobEpisodeSource,vehicle)
    if expected==nil then return fail(reason) end
    local state,why=prepare(vehicle)
    if state==nil then return fail(why) end
    -- One current-episode check prevents stopping a different GIANTS job.
    -- No second pre-stop query or post-start polling is introduced.
    if state.oldJob~=expected then
        discardBeforeStop(state.replacement)
        return fail("ORIGINAL_JOB_EPISODE_REPLACED")
    end
    local stopped=invoke(state.aiSystem,"stopJob",state.oldJob,nil)
    if not stopped then return fail("NATIVE_FIELDWORK_STOP_FAILED") end
    local started=invoke(state.aiSystem,"startJob",state.replacement,state.farmId)
    if not started then return fail("NATIVE_FIELDWORK_START_FAILED") end
    return true,{
        kind="NATIVE_FIELDWORK_REPLACEMENT_REQUESTED",
        oldJobId=state.oldJobId,newJobId=state.replacement.jobId,
        stopInvocationAccepted=true,startInvocationAccepted=true,
        isOldJobStopped=true,isNewJobStarted=true,
        isNativeProductiveContinuationConfirmed=false,
        farmId=state.farmId
    }
end
