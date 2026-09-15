local root=arg[1] or "."
local function load(relativePath) dofile(root.."/"..relativePath) end

OuttaMyWay={}
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/OperationalPicture.lua")
load("scripts/assessment/ProgressionGeometry.lua")
load("scripts/assessment/ResolutionMarginDemandAssessment.lua")
load("scripts/assessment/ResolutionMarginSituationAssessment.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b)),2) end
end
local function near(a,b,tolerance,message)
    tolerance=tolerance or 0.0001
    if type(a)~="number" or math.abs(a-b)>tolerance then error(message or (tostring(a).." not near "..tostring(b)),2) end
end
local function truthy(value,message)
    if value~=true then error(message or "expected true",2) end
end

local function context(targetZ)
    targetZ=targetZ or 0
    return {
        observationSnapshotId="OBS-1",
        situations={{operationId="OP-1",memberAssemblyIds={"A","B"},resolutionSpaceAssemblyIds={"A","B"}}},
        currentSpace={
            {identity="CURRENT-A",assemblyId="A",occupancy={x=0,z=0},provenance={source="CURRENT"}},
            {identity="CURRENT-B",assemblyId="B",occupancy={x=6,z=targetZ},provenance={source="CURRENT"}}
        },
        futureSpace={
            {identity="FUTURE-A",assemblyId="A",alternatives={{identity="ALT-A",headingX=1,headingZ=0,boundaryDistance=20,intentEpoch="IA"}}},
            {identity="FUTURE-B",assemblyId="B",alternatives={}}
        },
        demand={committedDemand={},potentialDemand={},temporarySlack={}},
        motionEvidence={
            {assemblyId="A",assemblyReferenceKey="vehicle-root:A",name="Settled A",sourceJobToken="JOB-A",intentEpoch="IA",intentValid=true,localIntentClassification="SETTLED_CONTINUATION",travelDirectionX=1,travelDirectionZ=0},
            {assemblyId="B",assemblyReferenceKey="vehicle-root:B",name="Turning B",sourceJobToken="JOB-B",intentEpoch="IB",intentValid=true,localIntentClassification="TURNING",travelDirectionX=0,travelDirectionZ=1}
        },
        physicalSpaceEvidence={
            {assemblyId="A",assemblyReferenceKey="vehicle-root:A",negativeClearanceAuthority=false,primitives={{identity="DISC-A",kind="DISC",positiveConflictSupport=true,x=0,z=0,radius=1}},provenance={source="PHYSICAL-A"}},
            {assemblyId="B",assemblyReferenceKey="vehicle-root:B",negativeClearanceAuthority=false,primitives={{identity="DISC-B",kind="DISC",positiveConflictSupport=true,x=6,z=targetZ,radius=1}},provenance={source="PHYSICAL-B"}}
        },
        representationFitness={
            {representationId="REP-A",assemblyId="A",question="CURRENT_PHYSICAL_CONFLICT",assessmentHorizon="CURRENT",state="USABLE_WITH_UNCERTAINTY",claimPermissions={"POSITIVE_CONFLICT_SUPPORT"},coverage={complete=false,conservative=false},uncertainty={"NO_NEGATIVE_CLEARANCE"},validityDependencies={"OBS-1"},provenance={source="FITNESS-A"}},
            {representationId="REP-B",assemblyId="B",question="CURRENT_PHYSICAL_CONFLICT",assessmentHorizon="CURRENT",state="USABLE_WITH_UNCERTAINTY",claimPermissions={"POSITIVE_CONFLICT_SUPPORT"},coverage={complete=false,conservative=false},uncertainty={"NO_NEGATIVE_CLEARANCE"},validityDependencies={"OBS-1"},provenance={source="FITNESS-B"}}
        }
    }
end

test("positive Current Space witness follows supported progression without Current Excursion input",function()
    local result=OuttaMyWay.ResolutionMarginDemandAssessment.assess(context(0))
    equal(OuttaMyWay.ValueRecord.length(result),1)
    local record=result[1]
    equal(record.status,"POSITIVE_WITNESS_WITHIN_LOCAL_INTENT")
    equal(record.subjectAssemblyId,"A")
    equal(record.representedClaim.class,"CURRENT_SPACE")
    equal(record.representedClaim.targetAssemblyId,"B")
    near(record.knownWitnessEntryM,4.0)
    equal(OuttaMyWay.ValueRecord.length(record.subjectRepresentationFitness),1)
    equal(record.subjectRepresentationFitness[1].representationId,"REP-A")
    equal(OuttaMyWay.ValueRecord.length(record.representedClaim.representationFitness),1)
    equal(record.representedClaim.representationFitness[1].representationId,"REP-B")
    truthy(record.claimLimits.positiveRepresentedDemandOnly)
    equal(record.claimLimits.negativeClearanceAuthority,false)
    equal(record.claimLimits.safeClearanceAuthority,false)
    equal(record.claimLimits.speedAuthority,false)
    equal(record.progressionBasis.localIntentClassification,"SETTLED_CONTINUATION")
end)

test("nearby turning worker off supported progression does not manufacture positive demand",function()
    local result=OuttaMyWay.ResolutionMarginDemandAssessment.assess(context(10))
    equal(OuttaMyWay.ValueRecord.length(result),0)
end)

test("missing usable representation fitness cannot manufacture a positive witness",function()
    local values=context(0)
    values.representationFitness={}
    local result=OuttaMyWay.ResolutionMarginDemandAssessment.assess(values)
    equal(OuttaMyWay.ValueRecord.length(result),0)
end)

local function basePicture()
    local values=context(0)
    return OuttaMyWay.OperationalPicture.new({
        identity="PICTURE-1",epoch=42,observationSnapshotId=values.observationSnapshotId,
        situations=values.situations,currentPairAssessmentScope={},
        identities={assemblies={"A","B"},components={},jobEpisodes={active={},admitted={},ended={}},operations={active={"OP-1"},ended={}}},
        currentSpace=values.currentSpace,futureSpace=values.futureSpace,demand=values.demand,responsibilityRelations={},
        uncertainty={},representationFitness=values.representationFitness,provenance={source="BASE"},controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext={},
        diagnostics={},motionEvidence=values.motionEvidence,physicalSpaceEvidence=values.physicalSpaceEvidence,
        productiveContinuationKnowledge={},followerBoundaryKnowledge={},trajectoryKnowledge={},opposedCorridorKnowledge={},spatialConstraintKnowledge={},cooperativePassageKnowledge={},causalObstructionKnowledge={}
    })
end

test("Situation decorator preserves picture identity and epoch while adding only Situation knowledge",function()
    local resetCalls=0
    local delegate={
        assess=function() return basePicture() end,
        resetSituationKnowledge=function() resetCalls=resetCalls+1 end,
        getEvidence=function(_,referenceKey,jobToken) return {referenceKey=referenceKey,jobToken=jobToken} end,
        getPublishedCount=function() return 7 end
    }
    local assessment=OuttaMyWay.ResolutionMarginSituationAssessment.new(delegate)
    local picture=assessment:assess({}, {}, {})
    equal(picture.identity,"PICTURE-1")
    equal(picture.epoch,42)
    equal(OuttaMyWay.ValueRecord.length(picture.resolutionMarginDemandKnowledge),1)
    equal(OuttaMyWay.ValueRecord.length(picture.candidateSupportEvidence.candidateSpecifications or {}),0)
    equal(assessment:getPublishedCount(),7)
    local evidence=assessment:getEvidence("vehicle-root:A","JOB-A")
    equal(evidence.referenceKey,"vehicle-root:A")
    assessment:resetSituationKnowledge()
    equal(resetCalls,1)
end)

print(string.format("RESULT %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
