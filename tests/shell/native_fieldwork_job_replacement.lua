-- GIANTS FIELDWORK stop/immediate-start contract. Mocked native calls;
-- in-game continuity remains a separate Reality test.
OuttaMyWay={}
dofile("scripts/control/mechanisms/NativeFieldworkJobReplacementMechanism.lua")
local Mechanism=OuttaMyWay.NativeFieldworkJobReplacementMechanism

local function scenario(options)
    options=options or {}
    local events={}
    local job={jobId=40}
    local expected=job
    local nextId=41
    local vehicle={}
    function vehicle:getJob()return job end
    function vehicle:getAIJobFarmId()return options.noFarm and nil or 7 end
    local manager={}
    function manager:getJobTypeIndexByName(name)
        assert(name=="FIELDWORK")
        return 3
    end
    function manager:getJobTypeIndex(candidate)
        return options.wrongType and 4 or 3
    end
    function manager:createJob(kind)
        assert(kind==3)
        events[#events+1]="CREATE"
        local replacement={}
        function replacement:applyCurrentState(v,mission,farmId,direct)
            events[#events+1]="APPLY"
            assert(v==vehicle and mission==g_currentMission and farmId==7 and direct)
            if options.applyError then error("apply failure") end
        end
        function replacement:setValues()events[#events+1]="VALUES" end
        function replacement:validate()
            events[#events+1]="VALIDATE"
            return options.invalid~=true
        end
        function replacement:delete()events[#events+1]="DELETE" end
        return replacement
    end
    local aiSystem={isServer=true}
    function aiSystem:stopJob(current,message)
        events[#events+1]="STOP"
        assert(current==expected and message==nil)
        job=nil
        if options.stopError then error("stop failure") end
    end
    function aiSystem:startJob(replacement,farmId)
        events[#events+1]="START"
        assert(farmId==7)
        replacement.jobId=nextId
        nextId=nextId+1
        if not options.noCurrentAfterStart then job=replacement end
        if options.startError then error("start failure") end
    end
    g_server={}
    g_currentMission={aiSystem=aiSystem,aiJobTypeManager=manager}
    local source={getExpectedNativeJob=function(_,subject)
        assert(subject==vehicle)
        return expected
    end}
    local mechanism=Mechanism.new(source)
    return {
        events=events,vehicle=vehicle,mechanism=mechanism,
        setExpected=function(x)expected=x end,
        setCurrent=function(x)job=x end,
        current=function()return job end
    }
end

local function count(events,kind)
    local n=0
    for i=1,#events do if events[i]==kind then n=n+1 end end
    return n
end

-- One collision produces one immediate native stop then start.
local r=scenario()
local ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(ok and result.isOldJobStopped and result.isNewJobStarted)
assert(result.oldJobId==40 and result.newJobId==41)
assert(not result.isNativeProductiveContinuationConfirmed)
assert(count(r.events,"STOP")==1 and count(r.events,"START")==1)
assert(r.events[#r.events-1]=="STOP" and r.events[#r.events]=="START")
assert(r.mechanism.attempts==nil and r.mechanism.getStatus==nil,
    "no historical job state or replay veto is retained")
-- A stale expected Job Episode is rejected using CURRENT evidence.
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="ORIGINAL_JOB_EPISODE_REPLACED")
assert(count(r.events,"STOP")==1)
-- Second independent collision: same assembly, fresh GIANTS Job Episode.
r.setExpected(r.current())
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(ok and result.oldJobId==41 and result.newJobId==42)
assert(count(r.events,"STOP")==2 and count(r.events,"START")==2)
assert(r.events[#r.events-1]=="STOP" and r.events[#r.events]=="START")

-- Preparation rejection does not stop current GIANTS work.
r=scenario({invalid=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="NATIVE_FIELDWORK_VALIDATION_REJECTED")
assert(count(r.events,"STOP")==0 and count(r.events,"DELETE")==1)
r=scenario({applyError=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="NATIVE_FIELDWORK_APPLY_FAILED")
assert(count(r.events,"STOP")==0)
r=scenario({wrongType=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="CURRENT_JOB_NOT_FIELDWORK")
assert(count(r.events,"STOP")==0)
r=scenario({noFarm=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="AI_JOB_FARM_UNAVAILABLE")
assert(count(r.events,"STOP")==0)
r=scenario()
local noSource=Mechanism.new(nil)
ok,result=noSource:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="SOURCE_JOB_EPISODE_UNAVAILABLE")

-- Native failures are immediate results; no historical records are carried.
r=scenario({stopError=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="NATIVE_FIELDWORK_STOP_FAILED")
assert(count(r.events,"STOP")==1 and count(r.events,"START")==0)
assert(r.mechanism.attempts==nil)
r=scenario({startError=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="NATIVE_FIELDWORK_START_FAILED")
assert(count(r.events,"STOP")==1 and count(r.events,"START")==1)
assert(r.mechanism.attempts==nil)
-- No extra post-start GIANTS job-ID or current-job polling gate.
r=scenario({noCurrentAfterStart=true})
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(ok and result.isNewJobStarted)

r=scenario()
g_server=nil
ok,result=r.mechanism:restartNativeFieldwork(r.vehicle)
assert(not ok and result.reason=="SERVER_REQUIRED")
assert(count(r.events,"STOP")==0)
print("Native FIELDWORK handback without sticky job-state checks: PASS")
