-- Native FIELDWORK stop/restart contract using the archived BWR API signature.
-- The GIANTS functions here are mocked; neither admission nor work progress is
-- claimed validated against the game.
OuttaMyWay={}
dofile("scripts/observation/CurrentPlayerControlObservation.lua")
dofile("scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua")
local Mechanism=OuttaMyWay.NativeFieldworkJobReplacementMechanism

local function scenario(options)
    options=options or {}
    local events={}
    local original={jobId=40}
    local current=original
    local expected=original
    local replacement=nil
    local farm=7
    local vehicle={rootNode=7701}
    function vehicle:getJob() return current end
    function vehicle:getAIJobFarmId()
        if options.noFarm then return nil end
        return farm
    end
    function vehicle:getIsControlled()
        if options.getterError then error("NATIVE_CONTROL_UNAVAILABLE") end
        return options.player==true
    end
    if options.noControlMethod then vehicle.getIsControlled=nil end
    vehicle.getRootVehicle=function(self)return self end
    local manager={}
    function manager:getJobTypeIndexByName(name)
        assert(name=="FIELDWORK")
        return 3
    end
    function manager:getJobTypeIndex(job)
        return options.wrongType and 5 or 3
    end
    function manager:createJob(kind)
        assert(kind==3)
        events[#events+1]="CREATE"
        replacement={jobId=nil}
        function replacement:applyCurrentState(v,mission,farmId,isDirectStart)
            events[#events+1]="APPLY"
            assert(v==vehicle and mission==g_currentMission)
            assert(farmId==farm and isDirectStart==true)
            if options.applyError then error("NATIVE_APPLY_ERROR") end
        end
        function replacement:setValues()
            events[#events+1]="SET_VALUES"
        end
        function replacement:validate(farmId)
            events[#events+1]="VALIDATE"
            assert(farmId==farm)
            return options.rejectValidation~=true
        end
        function replacement:delete()
            events[#events+1]="DELETE"
        end
        return replacement
    end
    local aiSystem={isServer=true}
    function aiSystem:stopJob(job,message)
        events[#events+1]="STOP"
        assert(job==original and message==nil)
        current=nil
        if options.stopError then error("NATIVE_STOP_ERROR_AFTER_EFFECT") end
        if options.stopRejected then return false end
    end
    function aiSystem:startJob(job,farmId)
        events[#events+1]="START"
        assert(job==replacement and farmId==farm)
        if not options.missingNewId then job.jobId=41 end
        if not options.unobservedNewJob then current=job end
        if options.startError then error("NATIVE_START_ERROR_AFTER_EFFECT") end
        if options.startRejected then return false end
    end
    g_server={}
    g_currentMission={aiSystem=aiSystem,aiJobTypeManager=manager}
    if options.missionRootAlias then
        g_currentMission.controlledVehicle={
            rootNode=7702,getRootVehicle=function()return vehicle end
        }
    end
    local source={
        getExpectedNativeJob=function(_,subject)
            assert(subject==vehicle)
            return expected
        end
    }
    local mechanism=Mechanism.new(source)
    return {
        vehicle=vehicle,original=original,events=events,mechanism=mechanism,
        replaceExpected=function(job) expected=job end,
        replaceCurrent=function(job) current=job end,
        markPlayer=function(value) options.player=value end,
        currentJob=function() return current end
    }
end

local function order(events,sequence)
    local filtered={}
    for _,name in ipairs(events) do
        if name~="DELETE" then filtered[#filtered+1]=name end
    end
    assert(#filtered==#sequence,
        "unexpected number of native calls "..tostring(#filtered))
    for i=1,#sequence do
        assert(filtered[i]==sequence[i],
            "native call ordering mismatch at "..i..": "..tostring(filtered[i]))
    end
end

-- Positive case must follow the archived GIANTS preparation API in order,
-- then perform stop and start as consecutive native lifecycle calls.
local r=scenario()
local ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(ok and evidence.isOldJobStopped==true and evidence.isNewJobStarted==true)
assert(evidence.stopInvocationAccepted and evidence.startInvocationAccepted)
assert(evidence.oldJobId==40 and evidence.newJobId==41)
assert(not evidence.isNativeProductiveContinuationConfirmed)
assert(r.currentJob().jobId==41)
order(r.events,{"CREATE","APPLY","SET_VALUES","VALIDATE","STOP","START"})
assert(not r.mechanism:restartNativeFieldwork(r.vehicle),
    "a replacement commitment cannot repeat on the same instance")
-- No time, fold position, Transit readiness or pair-clearance inspection.
assert(OuttaMyWay.nativeTransitRequestMechanism==nil)
assert(OuttaMyWay.runtime==nil)

-- Validation failure must leave the original GIANTS job running.
r=scenario({rejectValidation=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="NATIVE_FIELDWORK_VALIDATION_REJECTED")
assert(r.currentJob()==r.original)
assert(r.events[#r.events]=="DELETE")
order(r.events,{"CREATE","APPLY","SET_VALUES","VALIDATE"})
-- A preparation exception is also safely discarded before any stop.
r=scenario({applyError=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="NATIVE_FIELDWORK_APPLY_FAILED")
assert(r.events[#r.events]=="DELETE")
order(r.events,{"CREATE","APPLY"})
-- Job Episode continuity is not derived from a live worker alone.
r=scenario()
r.replaceExpected({jobId=32})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="ORIGINAL_JOB_EPISODE_REPLACED")
assert(r.currentJob()==r.original)
assert(r.events[#r.events]=="DELETE")
order(r.events,{"CREATE","APPLY","SET_VALUES","VALIDATE"})
-- Never stop a non-FIELDWORK job.
r=scenario({wrongType=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="CURRENT_JOB_NOT_FIELDWORK")
assert(#r.events==0)
-- Missing AI Job farm authority fails before replacement creation.
r=scenario({noFarm=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="AI_JOB_FARM_UNAVAILABLE")
assert(#r.events==0)
-- Player control interlock fails before mutation.
r=scenario({player=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="PLAYER_CONTROL_ACTIVE")
assert(#r.events==0)
-- Archived positive-root predicate: a different mission object resolving to
-- the same root is player takeover, even without the worker's local flag.
r=scenario({missionRootAlias=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="PLAYER_CONTROL_ACTIVE")
assert(#r.events==0)
-- Missing native negative evidence and getter exceptions do not constitute
-- positive player control. Job Episode and FIELDWORK checks still apply.
r=scenario({noControlMethod=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(ok and evidence.isNewJobStarted)
r=scenario({getterError=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(ok and evidence.isNewJobStarted)
-- Missing independent job-episode source can never self-authorise a job.
r=scenario()
local withoutSource=Mechanism.new(nil)
ok,evidence=withoutSource:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="SOURCE_JOB_EPISODE_UNAVAILABLE")
assert(#r.events==0)
-- A stopped GIANTS job is an irreversible commitment even when stop throws.
r=scenario({stopError=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.isNativeJobStateUncertain)
assert(evidence.reason=="NATIVE_FIELDWORK_STOP_UNCERTAIN")
order(r.events,{"CREATE","APPLY","SET_VALUES","VALIDATE","STOP"})
assert(not r.mechanism:restartNativeFieldwork(r.vehicle))
assert(#r.events==5,"no second stop during failed native hand-back")
-- A start exception after side effects is unresolved, not successful.
r=scenario({startError=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.isNativeJobStateUncertain)
assert(evidence.reason=="NATIVE_FIELDWORK_START_UNCERTAIN")
order(r.events,{"CREATE","APPLY","SET_VALUES","VALIDATE","STOP","START"})
assert(r.currentJob().jobId==41,"native effects can precede an exception")
-- A start call returning without an error cannot alone prove current-job
-- admission; the result must remain uncertain when GIANTS evidence is absent.
r=scenario({unobservedNewJob=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.isNativeJobStateUncertain)
assert(evidence.reason=="NATIVE_FIELDWORK_HANDOFF_NOT_OBSERVED")
order(r.events,{"CREATE","APPLY","SET_VALUES","VALIDATE","STOP","START"})
r=scenario({missingNewId=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="NATIVE_FIELDWORK_HANDOFF_NOT_OBSERVED")
-- Explicit native failure cannot be reported as accepted.
r=scenario({startRejected=true})
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="NATIVE_FIELDWORK_START_UNCERTAIN")
assert(evidence.isNativeJobStateUncertain)
-- Server-side boundary is mandatory.
r=scenario()
g_server=nil
ok,evidence=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and evidence.reason=="SERVER_REQUIRED" and #r.events==0)

print("Native FIELDWORK stop-then-immediate-start and unresolved hand-back: PASS")
