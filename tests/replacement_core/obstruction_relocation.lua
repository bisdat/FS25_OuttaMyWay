local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/OperationalPicture.lua")
load("scripts/contracts/CommitmentRecord.lua")
load("scripts/identity/EpochSequence.lua")
load("scripts/identity/IdentityRegistry.lua")
load("scripts/commitment/CommitmentStateMachine.lua")
load("scripts/commitment/CommitmentRegistry.lua")
load("scripts/authority/AuthorityRegistry.lua")
load("scripts/authority/EffectiveActuationComposition.lua")
load("scripts/control/mechanisms/NonJobActuationMechanism.lua")
load("scripts/control/mechanisms/TransitConfigurationMechanism.lua")
load("scripts/control/ObstructionRelocationControl.lua")
load("scripts/candidates/ObstructionRelocationCandidateSupport.lua")

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
local function expectError(fn)
    local ok = pcall(fn)
    if ok then error("expected rejection", 2) end
end

local function picture(ids, epochs, values)
    values = values or {}
    return OuttaMyWay.OperationalPicture.new({
        identity=values.identity or ids:issue("PICTURE"),
        epoch=values.epoch or epochs:next(),
        observationSnapshotId=values.observationSnapshotId or "OS-TEST",
        situations={},currentPairAssessmentScope={},identities={assemblies={},components={},jobEpisodes={active={},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace={},futureSpace={},
        demand={committedDemand={},potentialDemand={},temporarySlack={}},
        responsibilityRelations={},uncertainty={},representationFitness={},
        provenance={source="obstruction-relocation-test"},
        controlOutcomeEvidence=values.controlOutcomeEvidence or {outcomes={}},
        candidateSupportEvidence={},
        commitmentContext=values.commitmentContext or {},
        motionEvidence=values.motionEvidence or {},
        productiveContinuationKnowledge=values.productiveContinuationKnowledge or {},
        causalObstructionKnowledge=values.causalObstructionKnowledge or {},
        terminalOccupancyKnowledge=values.terminalOccupancyKnowledge or {}
    })
end

local function snapshot(blockerX)
    blockerX=blockerX or 10
    return {
        identity="OS-TEST",
        assemblies={
            {assemblyId="AS-BLOCKER",referenceKey="REF-BLOCKER"},
            {assemblyId="AS-A",referenceKey="REF-A"},
            {assemblyId="AS-B",referenceKey="REF-B"}
        },
        geometry={currentPhysicalPoseEvidence={{assemblyReferenceKey="REF-BLOCKER",x=blockerX,z=10}}},
        fieldWorld={geometryMetrics={centroidX=100,centroidZ=10}},
        playerControl={ ["REF-BLOCKER"]={playerEnteredObserved=true,playerEntered=false} },
        aiStates={ ["REF-BLOCKER"]={aiActiveObserved=true,aiActive=false} }
    }
end

local function relation(beneficiaryId, beneficiaryReferenceKey)
    return {
        operationId="OR-1",
        blockerAssemblyId="AS-BLOCKER",
        blockerAssemblyReferenceKey="REF-BLOCKER",
        beneficiaryAssemblyId=beneficiaryId,
        beneficiaryAssemblyReferenceKey=beneficiaryReferenceKey,
        blockerClassification="NON_ACTIVE_UNCLAIMED",
        relocationEligible=true
    }
end

test("obstruction relocation authority is truthful and mechanically exclusive", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local commitments=OuttaMyWay.CommitmentRegistry.new(ids,epochs)
    local authorities=OuttaMyWay.AuthorityRegistry.new(ids,epochs,commitments)
    local commitment=commitments:create({objective={},governingBasis={responsibilityKey="obstruction-relocation:OR-1:AS-BLOCKER"}})
    local token=authorities:acquireObstructionRelocation("AS-BLOCKER",commitment.identity)
    equal(token.authorityClass,"OBSTRUCTION_RELOCATION_ACTUATION")
    equal(authorities:ownerOf("AS-BLOCKER"),commitment.identity)
    equal(authorities:hasObstructionRelocationAuthority(commitment.identity),true)
    expectError(function() authorities:acquireProgress("AS-BLOCKER",commitment.identity) end)
end)

test("effective composition admits blocker relocation plus beneficiary hold", function()
    local composition=OuttaMyWay.EffectiveActuationComposition.create({
        identity="EC-TEST",epoch=1,relevantAssemblyIds={"AS-BLOCKER","AS-A"},
        entries={
            {assemblyId="AS-BLOCKER",commitmentId="CM-1",capability="REPOSITION",effectClass="OBSTRUCTION_RELOCATION",obstructionRelocationActuation=true},
            {assemblyId="AS-A",commitmentId="CM-1",capability="REGULATE_SPEED",effectClass="HOLD",progressActuation=true}
        }
    })
    equal(OuttaMyWay.ValueRecord.length(composition.entries),2)
end)

test("effective composition rejects cross-entry authority-class aliasing", function()
    expectError(function()
        OuttaMyWay.EffectiveActuationComposition.create({
            identity="EC-BAD",epoch=1,relevantAssemblyIds={"AS-BLOCKER","AS-A"},
            entries={
                {assemblyId="AS-BLOCKER",commitmentId="CM-1",capability="REPOSITION",effectClass="OBSTRUCTION_RELOCATION",obstructionRelocationActuation=true},
                {assemblyId="AS-BLOCKER",commitmentId="CM-1",capability="REGULATE_SPEED",effectClass="REGULATION",progressActuation=true},
                {assemblyId="AS-A",commitmentId="CM-1",capability="CONTINUE",effectClass="CONTINUE"}
            }
        })
    end)
end)

test("control observation envelope kind survives terminal outcome evidence", function()
    local control=OuttaMyWay.ObstructionRelocationControl.new({}, {})
    control:_publish({
        relocationKey="obstruction-relocation:OR-1:AS-BLOCKER",
        assemblyReferenceKey="REF-BLOCKER",
        commitmentId="CM-1",
        phase="INFIELD",
        completionContext={triggerKind="CURRENT_CAUSAL_OBSTRUCTION",relocationKey="obstruction-relocation:OR-1:AS-BLOCKER"}
    },"MANOEUVRE_COMPLETE",{
        kind="BOUNDED_RELOCATION_MANOEUVRE_COMPLETE",
        freshSituationRequired=true,
        semanticResolutionNotInferred=true
    })
    local observed=control:getControlExecutionObservation()
    equal(observed.kind,"OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION")
    equal(observed.completionContext.triggerKind,"CURRENT_CAUSAL_OBSTRUCTION")
    equal(observed.outcomeEvidenceKind,"BOUNDED_RELOCATION_MANOEUVRE_COMPLETE")
    equal(observed.status,"MANOEUVRE_COMPLETE")
    equal(observed.freshSituationRequired,true)
    equal(observed.semanticResolutionNotInferred,true)
end)

test("pairwise causal relations aggregate to one geometry-bounded blocker relocation responsibility", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local base=picture(ids,epochs,{causalObstructionKnowledge={relation("AS-A","REF-A"),relation("AS-B","REF-B")}})
    local supported=support:attach(base,snapshot())
    if supported==nil then error("expected generic relocation support") end
    local specifications=supported.candidateSupportEvidence.candidateSpecifications
    equal(OuttaMyWay.ValueRecord.length(specifications),1)
    local specification=specifications[1]
    equal(specification.evidenceBasis.governingBasis.responsibilityKey,"obstruction-relocation:OR-1:AS-BLOCKER")
    equal(OuttaMyWay.ValueRecord.length(specification.evidenceBasis.governingBasis.authorizingDemandAssemblyIds),2)
    equal(specification.evidenceBasis.obstructionRelocationActuationOwnership.assemblyIds[1],"AS-BLOCKER")
    equal(specification.expectedEffect.boundedInwardRelocation,true)
    equal(specification.evidenceBasis.obstructionRelocationBridge.authorityClass,"OBSTRUCTION_RELOCATION_ACTUATION")
    equal(specification.evidenceBasis.obstructionRelocationBridge.objective.objectiveKind,"CAUSAL_OBSTRUCTION_BOUNDED_INWARD_RELOCATION")
    equal(specification.evidenceBasis.obstructionRelocationBridge.objective.maximumRelocationDistanceM,60)
    equal(specification.releaseImplications.repeatedActuationRequiresFreshPositiveObstruction,true)
    equal(supported.candidateSupportEvidence.supportBoundary.moveCountBudget,false)
end)

test("former terminal provenance does not exclude a current causal blocker", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local base=picture(ids,epochs,{causalObstructionKnowledge={relation("AS-A","REF-A")},terminalOccupancyKnowledge={{assemblyId="AS-BLOCKER",terminalEpisodeId="JE-OLD"}}})
    local supported=support:attach(base,snapshot())
    if supported==nil then error("historical terminal provenance incorrectly gated current Causal Obstruction") end
    equal(supported.candidateSupportEvidence.candidateSpecifications[1].subject.assemblyId,"AS-BLOCKER")
end)

test("observable parked assembly without causal obstruction creates no relocation candidate", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local supported=support:attach(picture(ids,epochs,{}),snapshot())
    equal(supported,nil)
    equal(support:getLastStatus(),"NO_GENERIC_CAUSAL_OBSTRUCTION_ACTION")
end)

local function reassessmentPicture(ids,epochs,productivePositive,retainRelation)
    local values={
        commitmentContext={{commitmentId="CM-1",governingBasis={kind="CAUSAL_OBSTRUCTION_RELOCATION",responsibilityKey="obstruction-relocation:OR-1:AS-BLOCKER",operationIds={"OR-1"},blockerAssemblyId="AS-BLOCKER",authorizingDemandAssemblyIds={"AS-A"}}}},
        controlOutcomeEvidence={outcomes={{kind="OBSTRUCTION_RELOCATION_CONTROL_OBSERVATION",commitmentId="CM-1",status="MANOEUVRE_COMPLETE",completionContext={triggerKind="CURRENT_CAUSAL_OBSTRUCTION",relocationKey="obstruction-relocation:OR-1:AS-BLOCKER"}}}},
        motionEvidence={{assemblyId="AS-A",motionClassification="STABLE_FORWARD",reportedSpeedMps=1.0,positionDerivedSpeedMps=1.0}},
        productiveContinuationKnowledge={{assemblyId="AS-A",productivePositive=productivePositive==true,representationFitness=productivePositive==true and "FIT_FOR_LIMITED_HORIZON" or "UNRESOLVED"}},
        causalObstructionKnowledge=retainRelation and {relation("AS-A","REF-A")} or {}
    }
    return picture(ids,epochs,values)
end

test("manoeuvre completion plus raw movement cannot settle obstruction resolution", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local supported=support:attach(reassessmentPicture(ids,epochs,false,false),snapshot())
    if supported==nil then error("expected waiting reassessment") end
    local specification=supported.candidateSupportEvidence.candidateSpecifications[1]
    equal(specification.purpose.kind,"CAUSAL_OBSTRUCTION_RELOCATION_REASSESSMENT")
    equal(specification.expectedEffect.waitingForEvidence,true)
end)

test("fresh supported continuation and obstruction cessation settle resolution", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local supported=support:attach(reassessmentPicture(ids,epochs,true,false),snapshot())
    if supported==nil then error("expected terminal reassessment") end
    local specification=supported.candidateSupportEvidence.candidateSpecifications[1]
    equal(specification.evidenceBasis.obstructionRelocationBridge.terminalEvent,"OBJECTIVE_SATISFIED")
end)

test("fresh positive obstruction after manoeuvre completion authorises another inward actuation", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local supported=support:attach(reassessmentPicture(ids,epochs,true,true),snapshot(10))
    if supported==nil then error("expected repeated relocation candidate") end
    local specification=supported.candidateSupportEvidence.candidateSpecifications[1]
    equal(specification.capability,"REPOSITION")
    equal(specification.evidenceBasis.maintainsExistingCommitment,true)
    equal(specification.evidenceBasis.obstructionRelocationBridge.existingCommitmentId,"CM-1")
    equal(specification.evidenceBasis.obstructionRelocationBridge.objective.targetProgressM,60)
end)

test("positive obstruction at centroid exhausts inward strategy instead of inventing another move", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local supported=support:attach(reassessmentPicture(ids,epochs,true,true),snapshot(100))
    if supported==nil then error("expected explicit strategy exhaustion settlement") end
    local specification=supported.candidateSupportEvidence.candidateSpecifications[1]
    equal(specification.capability,"ESCALATE")
    equal(specification.evidenceBasis.obstructionRelocationBridge.terminalEvent,"OBJECTIVE_FAILED")
    equal(specification.evidenceBasis.obstructionRelocationBridge.terminalReason,"POSITIVE_CAUSAL_OBSTRUCTION_WITHOUT_MEANINGFUL_INWARD_RELOCATION_SPACE")
end)

test("active Job re-entry terminates retained obstruction relocation responsibility", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local current=snapshot()
    current.aiStates["REF-BLOCKER"]={observedActive=true,aiActive=false,aiActiveObserved=false}
    local supported=support:attach(reassessmentPicture(ids,epochs,false,true),current)
    if supported==nil then error("expected new authoritative intent settlement") end
    local specification=supported.candidateSupportEvidence.candidateSpecifications[1]
    equal(specification.capability,"CONTINUE_UNCHANGED")
    equal(specification.evidenceBasis.obstructionRelocationBridge.terminalEvent,"NEW_AUTHORITATIVE_INTENT")
end)

print(string.format("obstruction relocation focused validation: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end