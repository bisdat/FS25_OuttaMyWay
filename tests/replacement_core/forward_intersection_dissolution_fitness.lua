local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/contracts/ValueRecord.lua")
load("scripts/assessment/SpatialConstraintAssessment.lua")
load("scripts/assessment/CurrentResponsibilityAssessment.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then
        passed=passed+1
        print("PASS "..name)
    else
        failed=failed+1
        print("FAIL "..name..": "..tostring(err))
    end
end

local function equal(actual,expected,message)
    if actual~=expected then error(message or (tostring(actual).." ~= "..tostring(expected)),2) end
end

local function truth(value,message)
    if value~=true then error(message or "expected true",2) end
end

local world={
    representativeSnapshotReferenceKey="FW-SNAPSHOT",
    boundary={
        {x=0,z=0},
        {x=100,z=0},
        {x=100,z=100},
        {x=0,z=100}
    },
    islands={}
}

local function future(assemblyId,startX,startZ,endX,endZ,headingX,headingZ,boundaryDistance)
    return {
        assemblyId=assemblyId,
        identity="future:"..assemblyId,
        alternatives={{
            identity="continuation:"..assemblyId,
            kind="FIELD_WORLD_BOUNDED_LOCAL_CONTINUATION",
            startX=startX,startZ=startZ,endX=endX,endZ=endZ,
            headingX=headingX,headingZ=headingZ,
            boundaryDistance=boundaryDistance,
            boundarySource="FIELD_WORLD_OUTER_BOUNDARY"
        }}
    }
end

local function motion(assemblyId,travelX,travelZ)
    return {
        assemblyId=assemblyId,
        assemblyReferenceKey="vehicle:"..assemblyId,
        reportedSpeedMps=5,
        travelDirectionX=travelX,
        travelDirectionZ=travelZ,
        nativeFieldWork={
            workingWidth={available=true,widthMetres=6,source="TEST",authority="TEST"}
        }
    }
end

local function assess(otherTravelX,otherTravelZ)
    local result=OuttaMyWay.SpatialConstraintAssessment.new():assess({
        operationId="OP-FI-DISSOLUTION",
        fieldWorld=world,
        fieldWorldReferenceKey="FW",
        assemblyIds={"AS-A","AS-B"},
        futureSpace={
            future("AS-A",90,50,90,0,0,-1,50),
            future("AS-B",95,5,100,5,1,0,5)
        },
        motionEvidence={
            motion("AS-A",0,-1),
            motion("AS-B",otherTravelX,otherTravelZ)
        },
        followerBoundaryKnowledge={}
    })
    return result.pairRelationships[1]
end

local current={
    provenance={admissionKind="FORWARD_INTERSECTION"}
}

local responsibility=OuttaMyWay.CurrentResponsibilityAssessment.new()

test("realised progression opposite projection vetoes incumbent FI dissolution without changing geometry",function()
    local relation=assess(-1,0)
    equal(relation.relationshipStatus,"NEGATIVE")
    equal(relation.classification,"NO_FORWARD_INTERSECTION")
    equal(relation.reason,"INTERSECTION_NOT_FORWARD_OF_BOTH_PARTICIPANTS")
    equal(relation.incumbentDissolutionEvidenceState,"UNRESOLVED")
    equal(relation.incumbentDissolutionReason,"REALIZED_PROGRESSION_CONTRADICTS_CURRENT_FORWARD_PROJECTION")
    truth(relation.otherProjection.realizedProgressionToProjectionDot<0)
end)

test("contradicted negative keeps incumbent FI Regulation waiting",function()
    local outcome=responsibility:assessActionSpaceRegulation(current,assess(-1,0))
    equal(outcome.disposition,"PERSIST")
    equal(outcome.evidenceState,"WAITING_FOR_EVIDENCE")
    equal(outcome.reason,"REALIZED_PROGRESSION_CONTRADICTS_CURRENT_FORWARD_PROJECTION")
    equal(outcome.terminationEvidenceKind,nil)
end)

test("weak positive alignment is not promoted into a corroboration requirement",function()
    local relation=assess(0.1,1)
    equal(relation.relationshipStatus,"NEGATIVE")
    equal(relation.incumbentDissolutionEvidenceState,"SUPPORTED")
    truth(relation.otherProjection.realizedProgressionToProjectionDot>0)
    truth(relation.otherProjection.realizedProgressionToProjectionDot<0.5)
    local outcome=responsibility:assessActionSpaceRegulation(current,relation)
    equal(outcome.disposition,"TERMINATE")
    equal(outcome.terminationEvidenceKind,"FORWARD_INTERSECTION_POSITIVE_DISSOLUTION")
end)

test("unavailable realised travel does not manufacture Regulation stickiness",function()
    local relation=assess(nil,nil)
    equal(relation.relationshipStatus,"NEGATIVE")
    equal(relation.incumbentDissolutionEvidenceState,"SUPPORTED")
    equal(relation.otherProjection.realizedProgressionToProjectionDot,nil)
    local outcome=responsibility:assessActionSpaceRegulation(current,relation)
    equal(outcome.disposition,"TERMINATE")
    equal(outcome.terminationEvidenceKind,"FORWARD_INTERSECTION_POSITIVE_DISSOLUTION")
end)

print(string.format("RESULT passed=%d failed=%d",passed,failed))
if failed>0 then os.exit(1) end
