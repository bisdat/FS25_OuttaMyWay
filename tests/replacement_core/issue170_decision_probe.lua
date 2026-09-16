local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/OperationalPicture.lua")
load("scripts/contracts/CandidateAction.lua")
load("scripts/contracts/CandidateInventory.lua")
load("scripts/contracts/ConstraintVerdict.lua")
load("scripts/contracts/ConstraintVerdictSet.lua")
load("scripts/contracts/DecisionRecord.lua")
load("scripts/identity/EpochSequence.lua")
load("scripts/identity/IdentityRegistry.lua")
load("scripts/decision/TrafficPolicemanDecisionPolicy.lua")
load("scripts/decision/ProspectivePortfolioDecisionPolicy.lua")
load("scripts/decision/DecisionSelector.lua")

local function equal(actual, expected, message)
    if actual ~= expected then
        error(message or (tostring(actual) .. " ~= " .. tostring(expected)))
    end
end

local function contains(values, expected)
    for _, value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if value == expected then return true end
    end
    return false
end

local picture = OuttaMyWay.OperationalPicture.new({
    identity="OP-ISSUE170",
    epoch=170,
    observationSnapshotId="OBS-ISSUE170",
    situations={},
    currentPairAssessmentScope={},
    identities={assemblies={"AS-F","AS-P"},components={},jobEpisodes={active={},admitted={},ended={}},operations={active={},ended={}}},
    currentSpace={},
    futureSpace={},
    demand={committedDemand={},potentialDemand={},temporarySlack={}},
    responsibilityRelations={},
    uncertainty={},
    representationFitness={},
    provenance={source="issue170-decision-probe"},
    controlOutcomeEvidence={},
    candidateSupportEvidence={},
    commitmentContext={}
})

local forwardGroupBoundary={mode="ISSUE170_FORWARD_INTERSECTION_GROUP"}
local passageGroupBoundary={mode="ISSUE170_PASSAGE_GROUP"}

local forward = OuttaMyWay.CandidateAction.new({
    identity="CA-FORWARD",
    epoch=171,
    purpose={kind="FORWARD_INTERSECTION_REGULATION"},
    subject={assemblyId="AS-F"},
    capability="REGULATE_SPEED",
    expectedEffect={kind="REGULATE_SPEED"},
    evidenceBasis={candidateSupportGroup={
        groupKey="forward-intersection",
        family="FORWARD_INTERSECTION",
        enumerationOrdinal=1,
        supportBoundary=forwardGroupBoundary
    }},
    representationFitness={requirements={}},
    preconditions={},
    invalidationConditions={},
    reversibility={reversible=true},
    obligationsCreated={},
    releaseImplications={required=false},
    uncertainty={},
    comparisonCost=1
})

local passage = OuttaMyWay.CandidateAction.new({
    identity="CA-PASSAGE",
    epoch=172,
    purpose={kind="COOPERATIVE_PASSAGE"},
    subject={assemblyId="AS-P"},
    capability="REPOSITION",
    expectedEffect={kind="REPOSITION"},
    evidenceBasis={candidateSupportGroup={
        groupKey="passage:REL-ISSUE170",
        family="PASSAGE",
        enumerationOrdinal=1,
        supportBoundary=passageGroupBoundary,
        conflictIdentity="REL-ISSUE170",
        initialSeparationM=20,
        assemblyIds={"AS-F","AS-P"}
    }},
    representationFitness={requirements={}},
    preconditions={},
    invalidationConditions={},
    reversibility={reversible=true},
    obligationsCreated={},
    releaseImplications={required=false},
    uncertainty={},
    comparisonCost=2
})

local inventory = OuttaMyWay.CandidateInventory.new({
    identity="CI-ISSUE170",
    epoch=173,
    operationalPictureId=picture.identity,
    candidateIds={forward.identity,passage.identity},
    complete=true,
    supportBoundary={
        mode="PROSPECTIVE_DECISION_PORTFOLIO",
        groups={
            {groupKey="forward-intersection",family="FORWARD_INTERSECTION",enumerationOrdinal=1,supportBoundary=forwardGroupBoundary},
            {groupKey="passage:REL-ISSUE170",family="PASSAGE",enumerationOrdinal=1,supportBoundary=passageGroupBoundary,conflictIdentity="REL-ISSUE170",initialSeparationM=20,assemblyIds={"AS-F","AS-P"}}
        }
    },
    provenance={source="issue170-decision-probe"}
})

local function verdict(identity,candidateId,result)
    return OuttaMyWay.ConstraintVerdict.new({
        identity=identity,
        epoch=174,
        constraintId="ISSUE170_MANDATORY",
        evaluator="Issue170Probe",
        candidateId=candidateId,
        result=result,
        mandatory=true,
        evidence={fixture=true},
        provenance={source="issue170-decision-probe"},
        reason="synthetic mandatory verdict",
        revalidationTrigger={kind="FIXTURE_CHANGE"}
    })
end

local function runCase(label, forwardResult)
    local forwardVerdict=verdict("CV-FORWARD-"..label,forward.identity,forwardResult)
    local passageVerdict=verdict("CV-PASSAGE-"..label,passage.identity,"PASS")
    local set=OuttaMyWay.ConstraintVerdictSet.new({
        identity="CVS-"..label,
        epoch=175,
        operationalPictureId=picture.identity,
        candidateInventoryId=inventory.identity,
        verdictIds={forwardVerdict.identity,passageVerdict.identity},
        mandatoryConstraintIds={"ISSUE170_MANDATORY"},
        complete=true,
        provenance={source="issue170-decision-probe"}
    })

    local selector=OuttaMyWay.DecisionSelector.new(OuttaMyWay.IdentityRegistry.new(),OuttaMyWay.EpochSequence.new())
    local decision=selector:select(
        picture,
        {inventory=inventory,candidates={forward,passage}},
        {set=set,verdicts={forwardVerdict,passageVerdict}}
    )

    equal(contains(decision.viableCandidateIds,passage.identity),true,"PASSAGE Candidate must be globally mandatory-admissible")
    equal(contains(decision.viableCandidateIds,forward.identity),false,"preferred FORWARD Candidate must not be globally mandatory-admissible")
    equal(decision.comparisonBasis.selectedGroupKey,"forward-intersection","current portfolio policy must prefer Forward Intersection support")
    equal(decision.comparisonBasis.lowerPrecedenceConstraintFallback,false,"current source must expose disabled lower-precedence fallback")
    equal(decision.selectedCandidateId,nil,"current source unexpectedly selected the admissible lower-precedence Candidate")

    print(string.format(
        "ISSUE170 case=%s forwardVerdict=%s globallyViablePassage=%s selectedGroup=%s selectedCandidate=%s action=%s nonIntervention=%s lowerPrecedenceConstraintFallback=%s",
        label,
        forwardResult,
        tostring(contains(decision.viableCandidateIds,passage.identity)),
        tostring(decision.comparisonBasis.selectedGroupKey),
        tostring(decision.selectedCandidateId),
        tostring(decision.commitmentAction),
        tostring(decision.nonIntervention and decision.nonIntervention.classification),
        tostring(decision.comparisonBasis.lowerPrecedenceConstraintFallback)
    ))

    return decision
end

local failed=runCase("FAIL","FAIL")
equal(failed.commitmentAction,"SETTLE")
equal(failed.nonIntervention.classification,"COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED")

local unresolved=runCase("UNRESOLVED","UNRESOLVED")
equal(unresolved.commitmentAction,"WAIT")
equal(unresolved.nonIntervention.classification,"WAIT_FOR_EVIDENCE")

print("ISSUE170 PROBE PASS: current Decision path suppresses a globally admissible lower-precedence Candidate when the preferred support group has no admissible Candidate")
