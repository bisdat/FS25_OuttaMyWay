local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/publication/LogPublication.lua")
local publications={}
Logging={
    info=function(formatText,message) publications[#publications+1]=string.format(formatText,message) end,
    warning=function(formatText,message) publications[#publications+1]=string.format(formatText,message) end,
    error=function(formatText,message) publications[#publications+1]=string.format(formatText,message) end
}
OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new(function() return "DIAGNOSTIC" end)
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/ObservationSnapshot.lua")
load("scripts/identity/EpochSequence.lua")
load("scripts/identity/IdentityRegistry.lua")
load("scripts/identity/JobEpisodeAdmission.lua")
load("scripts/identity/OperationAdmission.lua")

local passed, failed = 0, 0
local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
        passed = passed + 1
        print("PASS " .. name)
    else
        failed = failed + 1
        print("FAIL " .. name .. ": " .. tostring(err))
    end
end
local function equal(actual, expected, message)
    if actual ~= expected then error(message or (tostring(actual) .. " ~= " .. tostring(expected)), 2) end
end
local function contains(values, expected)
    for _, value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if value == expected then return true end
    end
    return false
end

local function activeJob(assemblyId, token)
    return {
        assemblyId=assemblyId,
        sourceJobToken=token,
        jobPresent=true,
        aiControlled=true,
        aiActive=true,
        fieldWorldReferenceKey="FW-TEST",
        fieldWorldSnapshotReferenceKey="SNAP-" .. assemblyId,
        fieldPolygonReferenceKey="FIELD-TEST",
        fieldWorldFingerprint="FINGERPRINT-" .. assemblyId,
        fieldWorldEquivalenceStatus="SAME_FIELD_WORLD",
        playerFacingFieldId=77,
        playerFacingLocatorSource="FOCUSED_FIXTURE",
        provenance={source="operation-lifecycle-focused-test"}
    }
end

local function activeMember(assemblyId)
    return {
        assemblyId=assemblyId,
        fieldWorldReferenceKey="FW-TEST",
        fieldWorldSnapshotReferenceKey="SNAP-" .. assemblyId,
        fieldPolygonReferenceKey="FIELD-TEST",
        performingRecognisedFieldWork=true,
        provenance={source="operation-lifecycle-focused-test"}
    }
end

local function snapshot(identity, epoch, complete, jobEpisodeEvidence, operationMembershipEvidence)
    return OuttaMyWay.ObservationSnapshot.new({
        identity=identity,
        epoch=epoch,
        timestamp=epoch,
        provenance={source="operation-lifecycle-focused-test"},
        fieldWorld={referenceKey="FW-TEST",operationMembershipEvidenceComplete=complete},
        assemblies={},
        geometry={},
        motion={},
        aiStates={},
        playerControl={},
        jobEpisodeEvidence=jobEpisodeEvidence,
        operationMembershipEvidence=operationMembershipEvidence,
        physicalRepresentationEvidence={},
        controlOutcomes={},
        unavailableSources={}
    })
end

test("positive member termination is honoured while another member remains unresolved", function()
    local identities=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local jobEpisodes=OuttaMyWay.JobEpisodeAdmission.new(identities,epochs)
    local operations=OuttaMyWay.OperationAdmission.new(identities,epochs,jobEpisodes)

    local first=snapshot(
        "OS-1",
        1,
        true,
        {
            activeJob("AS-A","job-A"),
            activeJob("AS-B","job-B"),
            activeJob("AS-C","job-C")
        },
        {
            activeMember("AS-A"),
            activeMember("AS-B"),
            activeMember("AS-C")
        }
    )
    local firstEpisodes=jobEpisodes:observe(first)
    local firstOperations=operations:observe(first,firstEpisodes)
    local operationId=firstOperations.activeOperationIds[1]
    if operationId==nil then error("expected one active Operation") end
    local admitted=operations:get(operationId)
    equal(OuttaMyWay.ValueRecord.length(admitted.memberAssemblyIds),3)
    equal(OuttaMyWay.ValueRecord.length(admitted.memberJobEpisodeIds),3)

    local endedA={
        assemblyId="AS-A",
        sourceJobToken="job-A",
        jobPresent=false,
        aiControlled=false,
        aiActive=false,
        sourceJobEndEvidence={observed=true,reason="FOCUSED_FIXTURE_SOURCE_JOB_ENDED"},
        provenance={source="operation-lifecycle-focused-test"}
    }
    local unresolvedB={
        assemblyId="AS-B",
        sourceJobToken="job-B",
        jobPresent=false,
        aiControlled=false,
        aiActive=false,
        provenance={source="operation-lifecycle-focused-test"}
    }
    local second=snapshot(
        "OS-2",
        2,
        false,
        {
            endedA,
            unresolvedB,
            activeJob("AS-C","job-C")
        },
        {
            activeMember("AS-C")
        }
    )
    local secondEpisodes=jobEpisodes:observe(second)
    local secondOperations=operations:observe(second,secondEpisodes)
    equal(secondOperations.membershipEvidenceComplete,false)
    equal(secondOperations.activeOperationIds[1],operationId)
    equal(OuttaMyWay.ValueRecord.length(secondEpisodes.endedEpisodeIds),1)
    equal(jobEpisodes:getActiveForAssembly("AS-A"),nil)
    if jobEpisodes:getActiveForAssembly("AS-B")==nil then error("B should remain unresolved rather than terminated by absence") end
    if jobEpisodes:getActiveForAssembly("AS-C")==nil then error("C should remain positively active") end

    local reconciled=operations:get(operationId)
    equal(OuttaMyWay.ValueRecord.length(reconciled.memberAssemblyIds),2)
    equal(OuttaMyWay.ValueRecord.length(reconciled.memberJobEpisodeIds),2)
    equal(contains(reconciled.memberAssemblyIds,"AS-A"),false,"positively terminated A must leave active Operation membership")
    equal(contains(reconciled.memberAssemblyIds,"AS-B"),true,"unresolved B must remain conservatively retained")
    equal(contains(reconciled.memberAssemblyIds,"AS-C"),true,"positively active C must remain a member")
end)

test("authoritative Job Episode and Operation transitions publish the NORMAL lifecycle journal", function()
    publications={}
    local identities=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local jobEpisodes=OuttaMyWay.JobEpisodeAdmission.new(identities,epochs)
    local operations=OuttaMyWay.OperationAdmission.new(identities,epochs,jobEpisodes)

    local first=snapshot("OS-JOURNAL-1",10,true,{activeJob("AS-J","job-J")},{activeMember("AS-J")})
    local firstEpisodes=jobEpisodes:observe(first)
    operations:observe(first,firstEpisodes)

    local ended={
        assemblyId="AS-J",sourceJobToken="job-J",jobPresent=false,aiControlled=false,aiActive=false,
        sourceJobEndEvidence={observed=true,reason="FOCUSED_FIXTURE_SOURCE_JOB_ENDED"},
        provenance={source="operation-lifecycle-focused-test"}
    }
    local last=snapshot("OS-JOURNAL-2",11,true,{ended},{})
    local lastEpisodes=jobEpisodes:observe(last)
    operations:observe(last,lastEpisodes)

    local joined=table.concat(publications,"\n")
    for _,code in OuttaMyWay.ValueRecord.ipairs({"JOB_EPISODE_STARTED","OPERATION_STARTED","JOB_EPISODE_ENDED","OPERATION_ENDED"}) do
        if string.find(joined,"["..code.."]",1,true)==nil then error("missing NORMAL lifecycle publication "..code) end
    end
    if string.find(joined,"field=77",1,true)==nil then error("expected player-facing field locator") end
    if string.find(joined,"[OPERATION_STARTED]",1,true)~=nil and string.find(joined,"members=AS-J",1,true)==nil then
        error("expected Operation lifecycle publication to preserve sealed member identity")
    end
end)

print(string.format("operation lifecycle focused validation: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
