-- The completion observer correlates an active native FIELDWORK detection
-- seed with the same job at successful termination. It never grants Control.
OuttaMyWay={VERSION="0.5.test"}
local reports,completions={},{}
local diagnostics=true
OuttaMyWay.LogPublication={origin=function()
    return {
        isEligible=function()return diagnostics end,
        publish=function(_,class,severity,code,payload)
            assert(class=="DIAGNOSTIC" and severity=="INFO")
            if diagnostics then reports[#reports+1]={code=code,payload=payload()} end
            return diagnostics
        end
    }
end}
AIJobFieldWork={}
AIMessageSuccessFinishedJob={}
MessageType={AI_JOB_STOPPED=12}
g_server={}
local callback,target,subscribed,unsubscribed
g_messageCenter={
    subscribe=function(_,message,fn,receiver)
        assert(message==12)
        callback,target=fn,receiver
        subscribed=true
    end,
    unsubscribeAll=function(_,receiver)
        assert(receiver==target)
        unsubscribed=true
    end
}
local enabled=true
local config={isResolved=function()return true end,isEnabled=function()return enabled end}
local function instance(klass)
    return {isa=function(_,candidate)return candidate==klass end}
end
local function field(id,x1,z1,x2,z2)
    return {fieldId=id,densityMapPolygon={
        pointsX={x1,x2,x2,x1},pointsZ={z1,z1,z2,z2}}}
end
g_fieldManager={fields={
    [77]=field(77,0,0,100,100),
    [29]=field(29,200,200,300,300)
}}
g_currentMission={aiSystem={activeJobVehicles={}}}
local worker={rootNode=201}
local function job(id,vehicle)
    local result=instance(AIJobFieldWork)
    result.jobId=id
    result.vehicleParameter={getVehicle=function()return vehicle end}
    vehicle.spec_aiJobVehicle={job=result}
    vehicle.spec_aiFieldWorker={isActive=true,driveStrategies={
        {aiFieldCourse={},fieldDetectionX=250,fieldDetectionZ=250}}}
    return result
end
dofile("scripts/observation/FarmEdgeGeometry.lua")
dofile("scripts/observation/CompletionSourceFieldObservation.lua")
dofile("scripts/observation/NativeJobCompletionProbe.lua")
local observation=OuttaMyWay.CompletionSourceFieldObservation
local probe=OuttaMyWay.NativeJobCompletionProbe.new(config)
probe:setCompletionListener(function(j,v,source)
    completions[#completions+1]={job=j,vehicle=v,source=source}
end)
probe:loadMap()
assert(subscribed and target==probe)
local natural=job(1,worker)
local direct=assert(observation.observe(worker,natural))
assert(direct.fieldId==29 and direct.status=="CANDIDATE_NOT_CONTROL_AUTHORITY"
    and direct.detectionX==250 and direct.detectionZ==250)
assert(direct.fieldId~=2,"displayed farmland label must never be substituted")
assert(not observation.observe(worker,instance(AIJobFieldWork)),
    "a different job must not acquire the worker's Source Field")
local strategy=worker.spec_aiFieldWorker.driveStrategies[1]
strategy.fieldDetectionX=500
local missing,why=observation.observe(worker,natural)
assert(missing==nil and why=="FIELD_DETECTION_POLYGON_UNMATCHED")
strategy.fieldDetectionX=250
local overlapping=g_fieldManager.fields[88]
g_fieldManager.fields[88]=field(88,220,220,280,280)
local ambiguous,ambiguousWhy=observation.observe(worker,natural)
assert(ambiguous==nil and ambiguousWhy=="FIELD_DETECTION_POLYGON_AMBIGUOUS")
g_fieldManager.fields[88]=overlapping
strategy.fieldDetectionX=nil
local noSeed,seedWhy=observation.observe(worker,natural)
assert(noSeed==nil and seedWhy=="FIELD_DETECTION_SEED_UNAVAILABLE")
strategy.fieldDetectionX=250
g_currentMission.aiSystem.activeJobVehicles={[worker]=true}
probe:update(400)
assert(probe.sourceFields[natural]==nil,"sampling must be bounded")
probe:update(600)
assert(probe.sourceFields[natural] and probe.sourceFields[natural].candidate.fieldId==29)
assert(#reports==0,"field candidate must be published only at success")
callback(target,natural,instance(AIMessageSuccessFinishedJob))
assert(#reports==2
    and reports[1].code=="NATIVE_FIELDWORK_JOB_STOPPED"
    and reports[2].code=="NATIVE_COMPLETION_SOURCE_FIELD_CANDIDATE")
assert(reports[2].payload.fieldId==29
    and reports[2].payload.status=="CANDIDATE_NOT_CONTROL_AUTHORITY"
    and reports[2].payload.reason=="CANDIDATE_OBSERVED"
    and reports[2].payload.sampleCount==1
    and reports[2].payload.sampledJobId==1)
assert(#completions==1 and completions[1].job==natural
    and completions[1].vehicle==worker
    and completions[1].source.fieldId==29)
assert(probe.sourceFields[natural]==nil)
callback(target,natural,instance(AIMessageSuccessFinishedJob))
assert(#reports==2 and #completions==1,"duplicate native event must be ignored")
local manual=job(2,worker)
callback(target,manual,instance({}))
assert(#reports==3 and reports[3].payload.successClass==false)
assert(#completions==1)
local unknown=job(3,worker)
callback(target,unknown,nil)
assert(#reports==4 and reports[4].payload.successClass==false)
local late=job(4,worker)
callback(target,late,instance(AIMessageSuccessFinishedJob))
assert(#reports==6 and reports[6].payload.status=="NOT_OBSERVED"
    and reports[6].payload.fieldId=="unavailable"
    and reports[6].payload.reason=="NO_MATCHING_ACTIVE_WORKER_SAMPLE"
    and #completions==2 and completions[2].source==nil,
    "no observed native seed cannot be promoted to field identity")
diagnostics=false
local noDiag=job(5,worker)
probe:update(1000)
assert(probe.sourceFields[noDiag]==nil,
    "ordinary product use must not perform the diagnostic field census")
callback(target,noDiag,instance(AIMessageSuccessFinishedJob))
assert(#reports==6 and #completions==3 and completions[3].source==nil)
diagnostics=true
enabled=false
local disabled=job(6,worker)
probe:update(1000)
callback(target,disabled,instance(AIMessageSuccessFinishedJob))
assert(#reports==6 and #completions==3,
    "disabled product must neither observe nor forward completion")
enabled=true
callback(target,instance({}),instance(AIMessageSuccessFinishedJob))
callback(target,nil,instance(AIMessageSuccessFinishedJob))
assert(#reports==6,"nil and unrelated jobs must be ignored")

-- Failed seed evidence must survive for the exact successful Job Episode.
local missingSeedJob=job(7,worker)
worker.spec_aiFieldWorker.driveStrategies[1].fieldDetectionX=nil
probe:update(1000)
assert(probe.sourceFields[missingSeedJob]~=nil
    and probe.sourceFields[missingSeedJob].reason=="FIELD_DETECTION_SEED_UNAVAILABLE")
callback(target,missingSeedJob,instance(AIMessageSuccessFinishedJob))
assert(#reports==8 and #completions==4)
assert(reports[8].payload.status=="NOT_OBSERVED"
    and reports[8].payload.reason=="FIELD_DETECTION_SEED_UNAVAILABLE"
    and reports[8].payload.sampleCount==1
    and reports[8].payload.sampledJobId==7)

-- A present strategy without an aiFieldCourse is a distinct diagnosis.
local incompleteCourse=job(8,worker)
worker.spec_aiFieldWorker.driveStrategies[1].aiFieldCourse=nil
probe:update(1000)
callback(target,incompleteCourse,instance(AIMessageSuccessFinishedJob))
assert(reports[10].payload.reason=="ACTIVE_FIELD_COURSE_OBJECT_UNAVAILABLE")

-- A sample for a newer native job must not be promoted to an older job.
local previousJob=job(9,worker)
local replacement=job(10,worker)
probe:update(1000)
callback(target,previousJob,instance(AIMessageSuccessFinishedJob))
assert(reports[12].payload.status=="NOT_OBSERVED"
    and reports[12].payload.reason=="ACTIVE_JOB_REFERENCE_MISMATCH_AT_COMPLETION"
    and reports[12].payload.sampledJobId==10
    and completions[#completions].source==nil)
callback(target,replacement,instance(AIMessageSuccessFinishedJob))
assert(reports[14].payload.fieldId==29
    and reports[14].payload.reason=="CANDIDATE_OBSERVED")

-- Missing registry is not mistaken for a clean spatial result.
g_currentMission.aiSystem.activeJobVehicles=nil
local noRegistry=job(11,worker)
probe:update(1000)
callback(target,noRegistry,instance(AIMessageSuccessFinishedJob))
assert(reports[16].payload.reason=="NO_MATCHING_ACTIVE_WORKER_SAMPLE"
    and reports[16].payload.sampleStatus=="ACTIVE_JOB_REGISTRY_UNAVAILABLE")
probe:deleteMap()
assert(unsubscribed and not probe.subscribed
    and next(probe.sourceFields)==nil)
print("Native completion source-field identity candidate PASS")
