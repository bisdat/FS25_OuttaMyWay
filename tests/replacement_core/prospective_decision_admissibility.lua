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

local function equal(actual,expected,message)
    if actual~=expected then error(message or (tostring(actual).." ~= "..tostring(expected))) end
end

local function contains(values,expected)
    for _,value in OuttaMyWay.ValueRecord.ipairs(values or {}) do
        if value==expected then return true end
    end
    return false
end

local picture=OuttaMyWay.OperationalPicture.new({
    identity="OP-PROSPECTIVE-ADMISSIBILITY",epoch=170,observationSnapshotId="OBS-PROSPECTIVE-ADMISSIBILITY",
    situations={},currentPairAssessmentScope={},
    identities={assemblies={"AS-F","AS-P"},components={},jobEpisodes={active={},admitted={},ended={}},operations={active={},ended={}}},
    currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},
    responsibilityRelations={},uncertainty={},representationFitness={},provenance={source="prospective-decision-admissibility"},
    controlOutcomeEvidence={},candidateSupportEvidence={},commitmentContext={}
})

local forwardBoundary={mode="FORWARD_INTERSECTION_FIXTURE"}
local passageBoundary={mode="PASSAGE_FIXTURE"}

local forward=OuttaMyWay.CandidateAction.new({
    identity="CA-FORWARD",epoch=171,purpose={kind="FORWARD_INTERSECTION_REGULATION"},subject={assemblyId="AS-F"},
    capability="REGULATE_SPEED",expectedEffect={kind="REGULATE_SPEED"},
    evidenceBasis={candidateSupportGroup={groupKey="forward-intersection",family="FORWARD_INTERSECTION",enumerationOrdinal=1,supportBoundary=forwardBoundary}},
    representationFitness={requirements={}},preconditions={},invalidationConditions={},reversibility={reversible=true},
    obligationsCreated={},releaseImplications={required=false},uncertainty={},comparisonCost=1
})

local passage=OuttaMyWay.CandidateAction.new({
    identity="CA-PASSAGE",epoch=172,purpose={kind="COOPERATIVE_PASSAGE"},subject={assemblyId="AS-P"},
    capability="REPOSITION",expectedEffect={kind="REPOSITION"},
    evidenceBasis={candidateSupportGroup={
        groupKey="passage:REL-PROSPECTIVE-ADMISSIBILITY",family="PASSAGE",enumerationOrdinal=1,supportBoundary=passageBoundary,
        conflictIdentity="REL-PROSPECTIVE-ADMISSIBILITY",initialSeparationM=20,assemblyIds={"AS-F","AS-P"}
    }},
    representationFitness={requirements={}},preconditions={},invalidationConditions={},reversibility={reversible=true},
    obligationsCreated={},releaseImplications={required=false},uncertainty={},comparisonCost=2
})

local inventory=OuttaMyWay.CandidateInventory.new({
    identity="CI-PROSPECTIVE-ADMISSIBILITY",epoch=173,operationalPictureId=picture.identity,
    candidateIds={forward.identity,passage.identity},complete=true,
    supportBoundary={mode="PROSPECTIVE_DECISION_PORTFOLIO",groups={
        {groupKey="forward-intersection",family="FORWARD_INTERSECTION",enumerationOrdinal=1,supportBoundary=forwardBoundary},
        {groupKey="passage:REL-PROSPECTIVE-ADMISSIBILITY",family="PASSAGE",enumerationOrdinal=1,supportBoundary=passageBoundary,conflictIdentity="REL-PROSPECTIVE-ADMISSIBILITY",initialSeparationM=20,assemblyIds={"AS-F","AS-P"}}
    }},
    provenance={source="prospective-decision-admissibility"}
})

local function verdict(identity,candidateId,result)
    return OuttaMyWay.ConstraintVerdict.new({
        identity=identity,epoch=174,constraintId="MANDATORY_FIXTURE",evaluator="ProspectiveDecisionAdmissibility",
        candidateId=candidateId,result=result,mandatory=true,evidence={fixture=true},
        provenance={source="prospective-decision-admissibility"},reason="synthetic mandatory verdict",revalidationTrigger={kind="FIXTURE_CHANGE"}
    })
end

local function runCase(label,forwardResult,passageResult)
    local forwardVerdict=verdict("CV-FORWARD-"..label,forward.identity,forwardResult)
    local passageVerdict=verdict("CV-PASSAGE-"..label,passage.identity,passageResult)
    local set=OuttaMyWay.ConstraintVerdictSet.new({
        identity="CVS-"..label,epoch=175,operationalPictureId=picture.identity,candidateInventoryId=inventory.identity,
        verdictIds={forwardVerdict.identity,passageVerdict.identity},mandatoryConstraintIds={"MANDATORY_FIXTURE"},complete=true,
        provenance={source="prospective-decision-admissibility"}
    })
    local selector=OuttaMyWay.DecisionSelector.new(OuttaMyWay.IdentityRegistry.new(),OuttaMyWay.EpochSequence.new())
    return selector:select(picture,{inventory=inventory,candidates={forward,passage}},{set=set,verdicts={forwardVerdict,passageVerdict}})
end

local bothPass=runCase("BOTH-PASS","PASS","PASS")
equal(bothPass.selectedCandidateId,passage.identity,"supported mandatory-admissible Passage must end tactical Forward Intersection Regulation")
equal(bothPass.comparisonBasis.selectedGroupKey,"passage:REL-PROSPECTIVE-ADMISSIBILITY")
equal(bothPass.comparisonBasis.rule,OuttaMyWay.ProspectivePortfolioDecisionPolicy.KIND)
equal(bothPass.comparisonBasis.compatibilityRule,"SPATIAL_NEGOTIATION_STAGE_TRANSITION")
equal(bothPass.comparisonBasis.admissibilityAwareGroupSelection,true)
equal(contains(bothPass.viableCandidateIds,forward.identity),true)
equal(contains(bothPass.viableCandidateIds,passage.identity),true)

local passageFail=runCase("PASSAGE-FAIL","PASS","FAIL")
equal(passageFail.selectedCandidateId,forward.identity,"inadmissible Passage must not suppress admissible tactical Regulation")
equal(passageFail.comparisonBasis.selectedGroupKey,"forward-intersection")
equal(passageFail.comparisonBasis.rule,OuttaMyWay.ProspectivePortfolioDecisionPolicy.KIND)
equal(passageFail.comparisonBasis.compatibilityRule,"TACTICAL_REGULATION_SINGLE_PURPOSE")
equal(passageFail.comparisonBasis.admissibilityAwareGroupSelection,true)
equal(contains(passageFail.viableCandidateIds,forward.identity),true)
equal(contains(passageFail.viableCandidateIds,passage.identity),false)

local forwardFail=runCase("FORWARD-FAIL","FAIL","PASS")
equal(forwardFail.selectedCandidateId,passage.identity,"inadmissible preferred support must not suppress admissible Passage")
equal(forwardFail.comparisonBasis.selectedGroupKey,"passage:REL-PROSPECTIVE-ADMISSIBILITY")
equal(forwardFail.comparisonBasis.admissibilityAwareGroupSelection,true)
equal(contains(forwardFail.viableCandidateIds,forward.identity),false)
equal(contains(forwardFail.viableCandidateIds,passage.identity),true)

local forwardUnresolved=runCase("FORWARD-UNRESOLVED","UNRESOLVED","PASS")
equal(forwardUnresolved.selectedCandidateId,passage.identity,"unresolved preferred support must not suppress admissible Passage")
equal(forwardUnresolved.comparisonBasis.selectedGroupKey,"passage:REL-PROSPECTIVE-ADMISSIBILITY")
equal(contains(forwardUnresolved.viableCandidateIds,forward.identity),false)
equal(contains(forwardUnresolved.viableCandidateIds,passage.identity),true)

local noPassUnresolved=runCase("NO-PASS-UNRESOLVED","UNRESOLVED","FAIL")
equal(noPassUnresolved.selectedCandidateId,nil)
equal(noPassUnresolved.commitmentAction,"WAIT")
equal(noPassUnresolved.nonIntervention.classification,"WAIT_FOR_EVIDENCE")
equal(noPassUnresolved.comparisonBasis.selection,"NO_MANDATORY_ADMISSIBLE_GROUP")
equal(noPassUnresolved.comparisonBasis.admissibilityAwareGroupSelection,true)

local allFail=runCase("ALL-FAIL","FAIL","FAIL")
equal(allFail.selectedCandidateId,nil)
equal(allFail.commitmentAction,"SETTLE")
equal(allFail.nonIntervention.classification,"COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED")
equal(allFail.comparisonBasis.selection,"NO_MANDATORY_ADMISSIBLE_GROUP")

print("prospective decision admissibility PASS")
