local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/OperationalPicture.lua")
load("scripts/contracts/CommitmentRecord.lua")
load("scripts/contracts/ControlRequest.lua")
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
        causalObstructionKnowledge=values.causalObstructionKnowledge or {}
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

test("generic Causal Obstruction relocation requires no historical Job provenance field", function()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local support=OuttaMyWay.ObstructionRelocationCandidateSupport.new(ids,epochs)
    local base=picture(ids,epochs,{causalObstructionKnowledge={relation("AS-A","REF-A")}})
    local supported=support:attach(base,snapshot())
    if supported==nil then error("expected generic relocation support") end
    local bridge=supported.candidateSupportEvidence.candidateSpecifications[1].evidenceBasis.obstructionRelocationBridge
    equal(bridge.historicalJobProvenanceRequired,false)
    equal(bridge.blockerAssemblyId,"AS-BLOCKER")
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

local function genericControlFixture()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local commitments=OuttaMyWay.CommitmentRegistry.new(ids,epochs)
    local authorities=OuttaMyWay.AuthorityRegistry.new(ids,epochs,commitments)
    local commitment=commitments:create({objective={kind="CAUSAL_OBSTRUCTION_RELOCATION"},governingBasis={responsibilityKey="obstruction-relocation:OR-1:AS-BLOCKER"}})
    local token=authorities:acquireObstructionRelocation("AS-BLOCKER",commitment.identity)
    local runtime={
        identities=ids,epochs=epochs,commitments=commitments,authorities=authorities,
        boundedAuthority={
            validateRequest=function(_,request) return request.boundedAuthorityId=="BA-TEST",nil end,
            isCurrent=function(_,identity) return identity=="BA-TEST" end
        }
    }
    local vehicle={rootNode=9901,forceIsActive=false,rotatedTime=0}
    local entered=false
    function vehicle:getAISteeringNode() return self.rootNode end
    function vehicle:getIsEntered() return entered end
    function vehicle:getIsAIActive() return false end
    function vehicle:getMotor() return {getMaximumForwardSpeed=function() return 10 end} end
    function vehicle:getCruiseControlState() return 0 end
    local source={getCurrentPhysicalObject=function(_,referenceKey) if referenceKey=="REF-BLOCKER" then return vehicle end return nil end}
    local control=OuttaMyWay.ObstructionRelocationControl.new(runtime,source)
    local completion=nil
    control:setCompletionHandler(function(result) completion=result end)
    local request=OuttaMyWay.ControlRequest.new({
        identity="CR-GENERIC",commitmentId=commitment.identity,assemblyId="AS-BLOCKER",capability="REPOSITION",
        target={
            kind="OBSTRUCTION_RELOCATION",phase="INFIELD",assemblyReferenceKey="REF-BLOCKER",
            objective={infieldDirectionX=1,infieldDirectionZ=0,targetProgressM=20,targetX=20,targetZ=0,destinationKind="CENTROID_BEARING_DISTANCE_CAP",objectiveKind="CAUSAL_OBSTRUCTION_BOUNDED_INWARD_RELOCATION"},
            configurationPolicy="RETAIN_CURRENT",cleanupFailurePolicy="FAIL_COMPLETION",
            completionContext={triggerKind="CURRENT_CAUSAL_OBSTRUCTION",relocationKey="obstruction-relocation:OR-1:AS-BLOCKER"}
        },
        authorityToken=token.identity,boundedAuthorityId="BA-TEST",operationalPictureEpoch=1,evidenceEpoch=1,
        effectiveActuationCompositionId="EC-GENERIC",preconditions={},invalidationConditions={}
    })
    return control,request,vehicle,function(value) entered=value end,function() return completion end
end

test("generic Obstruction Relocation Player Claim relinquishes activity context without post-claim actuation", function()
    local oldAIVehicleUtil,oldWheelsUtil,oldTranslation,oldWorldDirection=AIVehicleUtil,WheelsUtil,getWorldTranslation,worldDirectionToLocal
    local driveCalls,neutralizeCalls=0,0
    AIVehicleUtil={driveInDirection=function() driveCalls=driveCalls+1; return true end}
    WheelsUtil={updateWheelsPhysics=function() neutralizeCalls=neutralizeCalls+1; return true end}
    getWorldTranslation=function() return 0,0,0 end
    worldDirectionToLocal=function(_,x,y,z) return x,y,z end

    local control,request,vehicle,setEntered,completion=genericControlFixture()
    local started=control:executeControlRequest(request,nil)
    equal(started,true)
    equal(vehicle.forceIsActive,true)
    setEntered(true)
    control:update(16)
    equal(completion().status,"PLAYER_CLAIM")
    equal(vehicle.forceIsActive,false)
    equal(driveCalls,0)
    equal(neutralizeCalls,0)
    equal(completion().evidence.activityContext.released,true)

    AIVehicleUtil,WheelsUtil,getWorldTranslation,worldDirectionToLocal=oldAIVehicleUtil,oldWheelsUtil,oldTranslation,oldWorldDirection
end)

test("generic Obstruction Relocation owned drive failure neutralizes propulsion before releasing activity context", function()
    local oldAIVehicleUtil,oldWheelsUtil,oldTranslation,oldWorldDirection=AIVehicleUtil,WheelsUtil,getWorldTranslation,worldDirectionToLocal
    local driveCalls,neutralizeCalls=0,0
    local failDrive=false
    AIVehicleUtil={driveInDirection=function()
        driveCalls=driveCalls+1
        if failDrive then error("synthetic direction actuation failure") end
        return true
    end}
    WheelsUtil={updateWheelsPhysics=function() neutralizeCalls=neutralizeCalls+1; return true end}
    getWorldTranslation=function() return 0,0,0 end
    worldDirectionToLocal=function(_,x,y,z) return x,y,z end

    local control,request,vehicle,_,completion=genericControlFixture()
    local started=control:executeControlRequest(request,nil)
    equal(started,true)
    control:update(16)
    equal(driveCalls,1)
    equal(completion(),nil)
    failDrive=true
    control:update(16)
    equal(completion().status,"FAILED")
    equal(neutralizeCalls,1)
    equal(completion().evidence.neutralization.performed,true)
    equal(completion().evidence.activityContext.released,true)
    equal(vehicle.forceIsActive,false)

    AIVehicleUtil,WheelsUtil,getWorldTranslation,worldDirectionToLocal=oldAIVehicleUtil,oldWheelsUtil,oldTranslation,oldWorldDirection
end)

print(string.format("obstruction relocation focused validation: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end