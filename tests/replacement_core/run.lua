local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
ClassIds={SHAPE=1}
getHasClassId=function() return true end
load("scripts/config.lua")
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/ObservationSnapshot.lua")
load("scripts/contracts/OperationalPicture.lua")
load("scripts/contracts/CandidateAction.lua")
load("scripts/contracts/CandidateInventory.lua")
load("scripts/contracts/ConstraintVerdict.lua")
load("scripts/contracts/ConstraintVerdictSet.lua")
load("scripts/contracts/DecisionRecord.lua")
load("scripts/contracts/CommitmentRecord.lua")
load("scripts/contracts/ObligationRecord.lua")
load("scripts/contracts/ControlRequest.lua")
load("scripts/contracts/ControlOutcome.lua")
load("scripts/contracts/ReplayFixture.lua")
load("scripts/contracts/ReplayRunResult.lua")
load("scripts/contracts/GoverningBasisVerdict.lua")
load("scripts/contracts/CommitmentApplicationRecord.lua")
load("scripts/contracts/PassiveLiveTraceRecord.lua")
load("scripts/identity/EpochSequence.lua")
load("scripts/representation/catalogues/CondorEndurance2Donor.lua")
load("scripts/representation/PlanViewFootprint.lua")
load("scripts/representation/AssemblyRepresentationCache.lua")
load("scripts/diagnostics/LiveInteractionDiagnostics.lua")
load("scripts/identity/IdentityRegistry.lua")
load("scripts/identity/FieldWorldSnapshotRegistry.lua")
load("scripts/identity/FieldWorldEquivalenceEvaluator.lua")
load("scripts/identity/FieldWorldEquivalenceAuthority.lua")
load("scripts/observation/RuntimeObservationAdapter.lua")
load("scripts/observation/LiveAIJobEvidence.lua")
load("scripts/observation/LocalIntentObservation.lua")
load("scripts/observation/FieldBoundedFutureSpace.lua")
load("scripts/observation/NativeFieldWorkObservation.lua")
load("scripts/observation/LiveObservationSource.lua")
load("scripts/identity/JobEpisodeAdmission.lua")
load("scripts/identity/OperationAdmission.lua")
load("scripts/assessment/RepresentationFitness.lua")
load("scripts/assessment/EncounterRegistry.lua")
load("scripts/assessment/ProgressionGeometry.lua")
load("scripts/assessment/GuardedRecoveryThreatAssessment.lua")
load("scripts/assessment/FollowerBoundaryDemandAssessment.lua")
load("scripts/assessment/CooperativePassageAssessment.lua")
load("scripts/assessment/TrajectoryConflictAssessment.lua")
load("scripts/assessment/PassageCapabilityAssessment.lua")
load("scripts/assessment/SituationAssessment.lua")
load("scripts/commitment/CommitmentStateMachine.lua")
load("scripts/commitment/CommitmentRegistry.lua")
load("scripts/commitment/ObligationLedger.lua")
load("scripts/authority/AuthorityRegistry.lua")
load("scripts/authority/EffectiveActuationComposition.lua")
load("scripts/commitment/CommitmentAdmission.lua")
load("scripts/commitment/GoverningBasisEvaluator.lua")
load("scripts/commitment/TerminalSettlementEvaluator.lua")
load("scripts/commitment/DecisionCommitmentBoundary.lua")
load("scripts/commitment/LiveTrafficCommitmentLifecycle.lua")
load("scripts/candidates/CandidateSpace.lua")
load("scripts/candidates/PassiveLiveCandidateSupport.lua")
load("scripts/candidates/LocalPassagePlanner.lua")
load("scripts/candidates/LiveTrafficCandidateSupport.lua")
load("scripts/constraints/ConstraintEvidence.lua")
load("scripts/constraints/evaluators/FieldWorldContainment.lua")
load("scripts/constraints/evaluators/TransitionClearance.lua")
load("scripts/constraints/evaluators/RepresentationFitness.lua")
load("scripts/constraints/evaluators/CapabilityAvailability.lua")
load("scripts/constraints/evaluators/ContinuingIntentPriority.lua")
load("scripts/constraints/evaluators/ProgressPreservation.lua")
load("scripts/constraints/evaluators/ResponsibilityCompatibility.lua")
load("scripts/constraints/evaluators/ObligationCompatibility.lua")
load("scripts/constraints/evaluators/CommitmentPreconditions.lua")
load("scripts/constraints/evaluators/EffectiveActuationComposition.lua")
load("scripts/constraints/evaluators/ReleaseSafety.lua")
load("scripts/constraints/ConstraintEngine.lua")
load("scripts/decision/TrafficPolicemanDecisionPolicy.lua")
load("scripts/decision/DecisionSelector.lua")
load("scripts/diagnostics/ArchitectureTrace.lua")
load("scripts/replay/ConformanceAssertions.lua")
load("scripts/replay/ReplayRunner.lua")
load("scripts/diagnostics/TargetedFieldIdentityProbe.lua")
load("scripts/diagnostics/FutureSpaceHud.lua")
load("scripts/diagnostics/TransitionHud.lua")
load("scripts/diagnostics/PassiveLiveValidator.lua")
load("scripts/diagnostics/ProductiveContinuationProbe.lua")
load("scripts/diagnostics/DemonstratedProductiveCoverageProbe.lua")
load("scripts/diagnostics/NativeFieldWorkerDriveCommandProbe.lua")
load("scripts/diagnostics/ProductiveCoverageResidualProbe.lua")
load("scripts/diagnostics/RefugeQualificationShadowProbe.lua")
load("scripts/diagnostics/GuardedRecoveryConvergenceProbe.lua")
load("scripts/observation/NativeManoeuvreObservationSource.lua")
load("scripts/diagnostics/FollowerMaturationCompressionProbe.lua")
load("scripts/diagnostics/ProgressionPreservationProbe.lua")
load("scripts/prototypes/Prototype22PermissionGate.lua")
load("scripts/prototypes/Prototype22DriveAuthority.lua")
load("scripts/prototypes/GuardedRecoveryRegulationTestBridge.lua")
load("scripts/prototypes/CommittedTransitionRegulationTestBridge.lua")
load("scripts/prototypes/Prototype22ConfigurationAuthority.lua")
load("scripts/prototypes/Prototype22TS015Relocation.lua")
load("scripts/prototypes/Prototype22CapabilityGate.lua")
load("scripts/control/CooperativePassageControl.lua")
load("scripts/control/LiveControlDispatcher.lua")
load("scripts/runtime/LiveRuntimeCoordinator.lua")
load("scripts/runtime/Runtime.lua")

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
local function expectError(fn)
    local ok = pcall(fn)
    if ok then error("expected rejection") end
end
local function equal(a,b,message)
    if a ~= b then error(message or (tostring(a) .. " ~= " .. tostring(b))) end
end

local function newKernel()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local epochs=OuttaMyWay.EpochSequence.new()
    local commitments=OuttaMyWay.CommitmentRegistry.new(ids,epochs)
    local obligations=OuttaMyWay.ObligationLedger.new(ids,epochs,commitments)
    local authorities=OuttaMyWay.AuthorityRegistry.new(ids,epochs,commitments)
    return ids,epochs,commitments,obligations,authorities
end
local function commitment(registry, suffix)
    return registry:create({ objective="objective-"..suffix, governingBasis={id="basis-"..suffix} })
end

test("sealed records reject mutation", function()
    local record=OuttaMyWay.ConstraintVerdict.new({identity="CV-1",epoch=1,constraintId="C",evaluator="E",candidateId="CA",result="PASS",mandatory=true,evidence={},provenance={},reason="ok",revalidationTrigger={}})
    expectError(function() record.result="FAIL" end)
    expectError(function() record.evidence.changed=true end)
end)

test("record schemas reject unknown fields", function()
    expectError(function() OuttaMyWay.ConstraintVerdict.new({identity="CV",epoch=1,constraintId="C",evaluator="E",candidateId="CA",result="PASS",mandatory=true,evidence={},provenance={},reason="ok",revalidationTrigger={},fallback=true}) end)
end)

test("canonical record serialisation is deterministic", function()
    local a=OuttaMyWay.ConstraintVerdict.new({identity="CV",epoch=1,constraintId="C",evaluator="E",candidateId="CA",result="PASS",mandatory=true,evidence={b=2,a=1},provenance={},reason="ok",revalidationTrigger={}})
    local b=OuttaMyWay.ConstraintVerdict.new({mandatory=true,result="PASS",candidateId="CA",constraintId="C",identity="CV",epoch=1,evaluator="E",reason="ok",evidence={a=1,b=2},revalidationTrigger={},provenance={}})
    equal(OuttaMyWay.ValueRecord.canonical(a),OuttaMyWay.ValueRecord.canonical(b))
end)

test("identity and epoch primitives are stable", function()
    local ids=OuttaMyWay.IdentityRegistry.new(); local epochs=OuttaMyWay.EpochSequence.new()
    equal(ids:issue("COMMITMENT"),"CM-00001"); equal(ids:issue("COMMITMENT"),"CM-00002")
    equal(epochs:next(),1); equal(epochs:next(),2)
end)

test("only the canonical lifecycle transitions are legal", function()
    local _,_,registry,ledger=newKernel(); local c=commitment(registry,"a")
    local waiting=OuttaMyWay.CommitmentStateMachine.transition(c,"WAITING_FOR_EVIDENCE",{epoch=2},ledger); registry:save(waiting)
    local active=OuttaMyWay.CommitmentStateMachine.transition(waiting,"ACTIVE",{epoch=3},ledger); registry:save(active)
    local settling=OuttaMyWay.CommitmentStateMachine.transition(active,"SETTLING",{epoch=4,intendedTerminalDisposition="SUCCEEDED",terminalCause="OBJECTIVE_SATISFIED"},ledger); registry:save(settling)
    expectError(function() OuttaMyWay.CommitmentStateMachine.transition(settling,"ACTIVE",{epoch=5},ledger) end)
end)

test("terminal settlement rejects open obligations", function()
    local _,_,registry,ledger=newKernel(); local c=commitment(registry,"b")
    ledger:create({origin={kind="decision"},basis={kind="effect"},ownerCommitmentId=c.identity,requiredOutcome={kind="safe"},evidenceContract={kind="observed"},ownershipClass="ORIGIN_BOUND"})
    local settling=OuttaMyWay.CommitmentStateMachine.transition(c,"SETTLING",{intendedTerminalDisposition="SUCCEEDED",terminalCause="OBJECTIVE_SATISFIED"},ledger); registry:save(settling)
    expectError(function() OuttaMyWay.CommitmentStateMachine.transition(settling,"SUCCEEDED",{terminalSettlementEvidence={ok=true}},ledger) end)
end)

test("satisfied obligations permit matching terminal disposition", function()
    local _,_,registry,ledger=newKernel(); local c=commitment(registry,"c")
    local ob=ledger:create({origin={kind="decision"},basis={kind="effect"},ownerCommitmentId=c.identity,requiredOutcome={kind="safe"},evidenceContract={kind="observed"},ownershipClass="ORIGIN_BOUND"})
    ledger:settle(ob.identity,"SATISFACTION",{observed=true})
    local settling=OuttaMyWay.CommitmentStateMachine.transition(c,"SETTLING",{intendedTerminalDisposition="SUCCEEDED",terminalCause="OBJECTIVE_SATISFIED"},ledger); registry:save(settling)
    local terminal=OuttaMyWay.CommitmentStateMachine.transition(settling,"SUCCEEDED",{terminalSettlementEvidence={all=true}},ledger)
    equal(terminal.state,"SUCCEEDED")
end)

test("origin-bound obligation transfer is rejected", function()
    local _,_,registry,ledger=newKernel(); local a=commitment(registry,"d1"); local b=commitment(registry,"d2")
    local ob=ledger:create({origin={},basis={},ownerCommitmentId=a.identity,requiredOutcome={},evidenceContract={},ownershipClass="ORIGIN_BOUND"})
    expectError(function() ledger:transfer(ob.identity,b.identity,{accepted=true}) end)
end)

test("continuity obligation transfer is atomic", function()
    local _,_,registry,ledger=newKernel(); local a=commitment(registry,"e1"); local b=commitment(registry,"e2")
    local ob=ledger:create({origin={},basis={},ownerCommitmentId=a.identity,requiredOutcome={},evidenceContract={},ownershipClass="CONTINUITY",transferPolicy={allowed=true,eligibleCommitmentIds={b.identity}}})
    local moved=ledger:transfer(ob.identity,b.identity,{accepted=true})
    equal(moved.ownerCommitmentId,b.identity); equal(#ledger:openForOwner(a.identity),0); equal(#ledger:openForOwner(b.identity),1)
end)

test("player cannot become an internal obligation owner", function()
    local _,_,registry,ledger=newKernel(); local a=commitment(registry,"f")
    local ob=ledger:create({origin={},basis={},ownerCommitmentId=a.identity,requiredOutcome={},evidenceContract={},ownershipClass="CONTINUITY",transferPolicy={allowed=true}})
    expectError(function() ledger:transfer(ob.identity,"PLAYER",{accepted=true}) end)
end)

test("one progress owner per assembly", function()
    local _,_,registry,_,authority=newKernel(); local a=commitment(registry,"g1"); local b=commitment(registry,"g2")
    local token=authority:acquireProgress("ASSEMBLY-1",a.identity)
    expectError(function() authority:acquireProgress("ASSEMBLY-1",b.identity) end)
    authority:release(token)
    local token2=authority:acquireProgress("ASSEMBLY-1",b.identity)
    if authority:validate(token) then error("released token remained valid") end
    if not authority:validate(token2) then error("current token invalid") end
end)

test("composition rejects conflicting progress owners", function()
    expectError(function() OuttaMyWay.EffectiveActuationComposition.create({identity="EC-1",epoch=1,relevantAssemblyIds={"A","B"},entries={{assemblyId="A",commitmentId="C1",capability="MOVE",progressActuation=true},{assemblyId="A",commitmentId="C2",capability="SPEED",progressActuation=true}}}) end)
end)

test("composition enforces never hold all", function()
    expectError(function() OuttaMyWay.EffectiveActuationComposition.create({identity="EC-2",epoch=1,relevantAssemblyIds={"A","B"},entries={{assemblyId="A",commitmentId="C1",capability="HOLD",effectClass="HOLD",progressActuation=false},{assemblyId="B",commitmentId="C2",capability="HOLD",effectClass="HOLD",progressActuation=false}}}) end)
end)


test("transfer policy is enforced", function()
    local _,_,registry,ledger=newKernel(); local a=commitment(registry,"tp1"); local b=commitment(registry,"tp2")
    local ob=ledger:create({origin={},basis={},ownerCommitmentId=a.identity,requiredOutcome={},evidenceContract={},ownershipClass="CONTINUITY",transferPolicy={allowed=false}})
    expectError(function() ledger:transfer(ob.identity,b.identity,{accepted=true}) end)
end)

test("WAITING_FOR_EVIDENCE cannot own new progress authority", function()
    local _,_,registry,ledger,authority=newKernel(); local c=commitment(registry,"wait")
    local waiting=OuttaMyWay.CommitmentStateMachine.transition(c,"WAITING_FOR_EVIDENCE",{epoch=2},ledger); registry:save(waiting)
    expectError(function() authority:acquireProgress("ASSEMBLY-W",waiting.identity) end)
end)

test("terminal disposition must match the intended disposition", function()
    local _,_,registry,ledger=newKernel(); local c=commitment(registry,"term")
    local settling=OuttaMyWay.CommitmentStateMachine.transition(c,"SETTLING",{intendedTerminalDisposition="FAILED",terminalCause="UNSUPPORTED"},ledger); registry:save(settling)
    expectError(function() OuttaMyWay.CommitmentStateMachine.transition(settling,"SUCCEEDED",{terminalSettlementEvidence={ok=true}},ledger) end)
end)

test("runtime is passive and inactive before the live listener runs", function()
    local runtime=OuttaMyWay.Runtime.new(); runtime:initialize(); local status=runtime:getStatus()
    equal(status.runtimeMode,"ARCHITECTURE_AUTHORITY_ALIGNMENT"); equal(status.controlAuthorityEnabled,false); equal(status.commitmentCount,0); equal(status.observationCount,0); equal(status.jobEpisodeCount,0); equal(status.operationCount,0); equal(status.operationalPictureCount,0); equal(status.candidateInventoryCount,0); equal(status.constraintVerdictSetCount,0); equal(status.decisionCount,0); equal(status.passiveTraceCount,0)
end)


local function rawObservation(epoch, evidence, assemblyKey)
    assemblyKey = assemblyKey or "assembly-A"
    return {
        timestamp = epoch,
        provenance = { source="fixture", sequence=epoch },
        assemblies = {{ referenceKey=assemblyKey, componentReferenceKeys={assemblyKey.."/vehicle", assemblyKey.."/implement"}, source="fixture" }},
        fieldWorld = {}, geometry = {}, motion = {}, aiStates = {}, playerControl = {},
        jobEpisodeEvidence = evidence and {{ assemblyReferenceKey=assemblyKey, sourceJobToken=evidence.sourceJobToken or "job-1", jobPresent=evidence.jobPresent, aiControlled=evidence.aiControlled, aiActive=evidence.aiActive, blocked=evidence.blocked, outtaMyWayHold=evidence.outtaMyWayHold, temporarilyInactive=evidence.temporarilyInactive, playerStopObserved=evidence.playerStopObserved, playerTakeoverObserved=evidence.playerTakeoverObserved, playerControlled=evidence.playerControlled, giantsAbortObserved=evidence.giantsAbortObserved, giantsFaultObserved=evidence.giantsFaultObserved, restartObserved=evidence.restartObserved, replacementObserved=evidence.replacementObserved, fieldWorldReferenceKey=evidence.fieldWorldReferenceKey, fieldWorldSnapshotReferenceKey=evidence.fieldWorldSnapshotReferenceKey, fieldPolygonReferenceKey=evidence.fieldPolygonReferenceKey, fieldWorldFingerprint=evidence.fieldWorldFingerprint, fieldWorldEquivalenceStatus=evidence.fieldWorldEquivalenceStatus, playerFacingFieldId=evidence.playerFacingFieldId, playerFacingLocatorSource=evidence.playerFacingLocatorSource, provenance={source="fixture"} }} or {},
        operationMembershipEvidence = {}, physicalRepresentationEvidence = {}, controlOutcomes = {}, unavailableSources = {}
    }
end

local function newObservationKernel()
    local ids=OuttaMyWay.IdentityRegistry.new(); local epochs=OuttaMyWay.EpochSequence.new()
    return ids,epochs,OuttaMyWay.RuntimeObservationAdapter.new(ids,epochs),OuttaMyWay.JobEpisodeAdmission.new(ids,epochs)
end

test("Observation rejects Decision semantics at any depth", function()
    expectError(function()
        OuttaMyWay.ObservationSnapshot.new({identity="OS-X",epoch=1,timestamp=1,provenance={},fieldWorld={},assemblies={{candidatePreference="LEFT"}},geometry={},motion={},aiStates={},playerControl={},jobEpisodeEvidence={},operationMembershipEvidence={},physicalRepresentationEvidence={},controlOutcomes={},unavailableSources={}})
    end)
end)

test("assembly identity persists across snapshots", function()
    local _,_,adapter=newObservationKernel()
    local a=adapter:publish(rawObservation(1,nil)); local b=adapter:publish(rawObservation(2,nil))
    equal(a.assemblies[1].assemblyId,b.assemblies[1].assemblyId)
    equal(#a.assemblies[1].componentIds,2)
end)


test("Observation rejects duplicate assembly and episode evidence", function()
    local _,_,adapter=newObservationKernel()
    local raw=rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})
    raw.assemblies[2]=raw.assemblies[1]
    expectError(function() adapter:publish(raw) end)

    local _,_,adapter2=newObservationKernel()
    local raw2=rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})
    raw2.jobEpisodeEvidence[2]=raw2.jobEpisodeEvidence[1]
    expectError(function() adapter2:publish(raw2) end)
end)

test("initial authoritative job evidence admits one episode", function()
    local _,_,adapter,admission=newObservationKernel()
    local snapshot=adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true}))
    local result=admission:observe(snapshot)
    equal(#result.admittedEpisodeIds,1); equal(#result.activeEpisodeIds,1); equal(#result.endedEpisodeIds,0)
end)

test("Field World Snapshot binds once and rejects drift inside one Job Episode",function()
    local _,_,adapter,admission=newObservationKernel()
    local first=adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true,fieldWorldReferenceKey="field-world:A",fieldWorldSnapshotReferenceKey="field-world-snapshot:A",fieldPolygonReferenceKey="field-polygon:A",fieldWorldFingerprint="A",fieldWorldEquivalenceStatus="SAME_FIELD_WORLD"}))
    local admitted=admission:observe(first); local episode=admission:get(admitted.activeEpisodeIds[1])
    equal(episode.fieldWorldReferenceKey,"field-world:A")
    local changed=adapter:publish(rawObservation(2,{jobPresent=true,aiControlled=true,aiActive=true,fieldWorldReferenceKey="field-world:B",fieldWorldSnapshotReferenceKey="field-world-snapshot:B",fieldPolygonReferenceKey="field-polygon:B",fieldWorldFingerprint="B",fieldWorldEquivalenceStatus="DIFFERENT_FIELD_WORLD"}))
    expectError(function() admission:observe(changed) end)
end)

test("replacement Job Episode may capture a different Field World Snapshot",function()
    local _,_,adapter,admission=newObservationKernel()
    local first=adapter:publish(rawObservation(1,{sourceJobToken="job-1",jobPresent=true,aiControlled=true,aiActive=true,fieldWorldReferenceKey="field-world:A",fieldWorldSnapshotReferenceKey="field-world-snapshot:A",fieldPolygonReferenceKey="field-polygon:A",fieldWorldFingerprint="A",fieldWorldEquivalenceStatus="SAME_FIELD_WORLD"}))
    local admitted=admission:observe(first); local oldId=admitted.activeEpisodeIds[1]
    local replacement=adapter:publish(rawObservation(2,{sourceJobToken="job-2",jobPresent=true,aiControlled=true,aiActive=true,replacementObserved=true,fieldWorldReferenceKey="field-world:B",fieldWorldSnapshotReferenceKey="field-world-snapshot:B",fieldPolygonReferenceKey="field-polygon:B",fieldWorldFingerprint="B",fieldWorldEquivalenceStatus="DIFFERENT_FIELD_WORLD"}))
    local result=admission:observe(replacement)
    equal(#result.endedEpisodeIds,1); equal(#result.admittedEpisodeIds,1)
    equal(admission:get(oldId).terminalCause,"REPLACED")
    equal(admission:get(result.activeEpisodeIds[1]).fieldWorldReferenceKey,"field-world:B")
end)

test("blockage hold and temporary inactivity do not end an episode", function()
    local _,_,adapter,admission=newObservationKernel()
    local first=adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})); local admitted=admission:observe(first)
    local episodeId=admitted.activeEpisodeIds[1]
    local blocked=adapter:publish(rawObservation(2,{jobPresent=true,aiControlled=true,aiActive=false,blocked=true})); admission:observe(blocked)
    local held=adapter:publish(rawObservation(3,{jobPresent=true,aiControlled=true,aiActive=false,outtaMyWayHold=true})); admission:observe(held)
    local inactive=adapter:publish(rawObservation(4,{jobPresent=true,aiControlled=true,aiActive=false,temporarilyInactive=true})); local result=admission:observe(inactive)
    equal(result.activeEpisodeIds[1],episodeId); equal(admission:get(episodeId).status,"ACTIVE")
end)

test("player stop ends the episode without replacement", function()
    local _,_,adapter,admission=newObservationKernel()
    local first=admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})))
    local ended=admission:observe(adapter:publish(rawObservation(2,{jobPresent=false,aiControlled=false,playerStopObserved=true})))
    equal(#ended.endedEpisodeIds,1); equal(#ended.activeEpisodeIds,0); equal(admission:get(first.activeEpisodeIds[1]).terminalCause,"PLAYER_STOP")
end)

test("player takeover ends the episode", function()
    local _,_,adapter,admission=newObservationKernel()
    local first=admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})))
    admission:observe(adapter:publish(rawObservation(2,{jobPresent=false,aiControlled=false,playerControlled=true})))
    equal(admission:get(first.activeEpisodeIds[1]).terminalCause,"PLAYER_TAKEOVER")
end)

test("GIANTS abort and fault end episodes", function()
    for field,cause in pairs({giantsAbortObserved="GIANTS_ABORT",giantsFaultObserved="GIANTS_FAULT"}) do
        local _,_,adapter,admission=newObservationKernel()
        local first=admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})))
        local evidence={jobPresent=false,aiControlled=false}; evidence[field]=true
        admission:observe(adapter:publish(rawObservation(2,evidence)))
        equal(admission:get(first.activeEpisodeIds[1]).terminalCause,cause)
    end
end)

test("restart creates a new episode even with the same source token", function()
    local _,_,adapter,admission=newObservationKernel()
    local first=admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true,sourceJobToken="job-1"})))
    local second=admission:observe(adapter:publish(rawObservation(2,{jobPresent=true,aiControlled=true,aiActive=true,restartObserved=true,sourceJobToken="job-1"})))
    if first.activeEpisodeIds[1] == second.activeEpisodeIds[1] then error("restart reused Job Episode identity") end
    equal(admission:get(first.activeEpisodeIds[1]).terminalCause,"RESTARTED")
end)

test("changed source token replaces a live episode", function()
    local _,_,adapter,admission=newObservationKernel()
    local first=admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true,sourceJobToken="job-1"})))
    local second=admission:observe(adapter:publish(rawObservation(2,{jobPresent=true,aiControlled=true,aiActive=true,sourceJobToken="job-2"})))
    equal(admission:get(first.activeEpisodeIds[1]).terminalCause,"REPLACED")
    if first.activeEpisodeIds[1] == second.activeEpisodeIds[1] then error("replacement reused Job Episode identity") end
end)

test("missing episode evidence does not imply termination", function()
    local _,_,adapter,admission=newObservationKernel()
    local first=admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})))
    local missing=adapter:publish(rawObservation(2,nil)); local result=admission:observe(missing)
    equal(result.activeEpisodeIds[1],first.activeEpisodeIds[1]); equal(#result.endedEpisodeIds,0)
end)

test("conflicting authoritative termination evidence is rejected", function()
    local _,_,adapter,admission=newObservationKernel()
    admission:observe(adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true})))
    expectError(function() admission:observe(adapter:publish(rawObservation(2,{jobPresent=false,aiControlled=false,playerStopObserved=true,giantsFaultObserved=true}))) end)
end)

test("Observation and admission are deterministic from fresh state", function()
    local function run()
        local _,_,adapter,admission=newObservationKernel()
        local snapshot=adapter:publish(rawObservation(1,{jobPresent=true,aiControlled=true,aiActive=true}))
        local result=admission:observe(snapshot)
        return OuttaMyWay.ValueRecord.canonical(snapshot),OuttaMyWay.ValueRecord.canonical(result)
    end
    local a,b=run(); local c,d=run(); equal(a,c); equal(b,d)
end)



local function pictureFixture(epoch, options)
    options=options or {}
    local follower=options.follower or "assembly-A"; local leader=options.leader or "assembly-B"
    local evidenceA=options.evidenceA or {jobPresent=true,aiControlled=true,aiActive=true,sourceJobToken="job-A"}
    local evidenceB=options.evidenceB or {jobPresent=true,aiControlled=true,aiActive=true,sourceJobToken="job-B"}
    return {
        timestamp=epoch,provenance={source="picture-fixture",sequence=epoch},
        fieldWorld={referenceKey="field-world-77",fieldPolygonReferenceKey="field-77",fieldPolygonReferenceKeys={"field-77"},fieldWorldSnapshotReferenceKeys={"snapshot-A","snapshot-B"},operationMembershipEvidenceComplete=options.membershipComplete~=false},
        assemblies={{referenceKey=follower,componentReferenceKeys={follower.."/vehicle"},source="fixture"},{referenceKey=leader,componentReferenceKeys={leader.."/vehicle"},source="fixture"}},
        geometry={
            currentSpaceEvidence={{identity="CS-A",assemblyReferenceKey=follower,occupancy={x=0,z=0},provenance={source="fixture"}},{identity="CS-B",assemblyReferenceKey=leader,occupancy={x=10,z=0},provenance={source="fixture"}}},
            futureSpaceEvidence={{identity="FS-A",assemblyReferenceKey=follower,alternatives={{corridor="C1"}},horizon=5,provenance={source="fixture"}},{identity="FS-B",assemblyReferenceKey=leader,alternatives={{corridor="C1"}},horizon=5,provenance={source="fixture"}}},
            demandEvidence={{identity="D-A",class="COMMITTED_DEMAND",assemblyReferenceKey=follower,space={corridor="C1"},basis={source="active continuation"},provenance={source="fixture"}},{identity="D-B",class="POTENTIAL_DEMAND",assemblyReferenceKey=leader,space={corridor="C1"},basis={source="bounded future"},provenance={source="fixture"}},{identity="S-1",class="TEMPORARY_SLACK",space={region="R1"},basis={source="current vacancy"},provenance={source="fixture"}}},
            interactionEvidence=options.interactions or {{interactionReferenceKey="interaction-1",subjectAssemblyReferenceKey=follower,otherAssemblyReferenceKey=leader,currentSpaceIntersects=false,futureSpaceConverges=true,horizon=5,provenance={source="fixture"}}},
            futureSpaceRelationshipEvidence=options.futureSpaceRelationships or {}
        },
        motion={closureEvidence={{followerAssemblyReferenceKey=follower,leaderAssemblyReferenceKey=leader,closingObserved=true,closingRate=2,horizon=5,provenance={source="fixture"}}}},
        aiStates={},playerControl={},
        jobEpisodeEvidence={{assemblyReferenceKey=follower,sourceJobToken=evidenceA.sourceJobToken,jobPresent=evidenceA.jobPresent,aiControlled=evidenceA.aiControlled,aiActive=evidenceA.aiActive,blocked=evidenceA.blocked,playerStopObserved=evidenceA.playerStopObserved,fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-A",fieldPolygonReferenceKey="field-77",fieldWorldFingerprint="fixture-A",fieldWorldEquivalenceStatus="SAME_FIELD_WORLD",provenance={source="fixture"}},{assemblyReferenceKey=leader,sourceJobToken=evidenceB.sourceJobToken,jobPresent=evidenceB.jobPresent,aiControlled=evidenceB.aiControlled,aiActive=evidenceB.aiActive,blocked=evidenceB.blocked,playerStopObserved=evidenceB.playerStopObserved,fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-B",fieldPolygonReferenceKey="field-77",fieldWorldFingerprint="fixture-B",fieldWorldEquivalenceStatus="SAME_FIELD_WORLD",provenance={source="fixture"}}},
        operationMembershipEvidence=options.membership or {{assemblyReferenceKey=follower,fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-A",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}},{assemblyReferenceKey=leader,fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-B",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}},
        physicalRepresentationEvidence=options.representations or {{assemblyReferenceKey=follower,representationId="REP-A",question="CURRENT_OCCUPANCY",assessmentHorizon=5,structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=true,conservative=true,permittedConclusions={"CONFLICT_SUPPORT","CONFLICT_EXCLUSION"},provenance={source="fixture"}},{assemblyReferenceKey=leader,representationId="REP-B",question="CURRENT_OCCUPANCY",assessmentHorizon=5,structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=true,conservative=true,permittedConclusions={"CONFLICT_SUPPORT"},provenance={source="fixture"}}},
        controlOutcomes={},unavailableSources=options.unavailableSources or {}
    }
end

local function newPictureRuntime() local runtime=OuttaMyWay.Runtime.new(); runtime:initialize(); return runtime end

test("Operational Picture rejects Decision semantics",function()
    expectError(function() OuttaMyWay.OperationalPicture.new({identity="OP-X",epoch=1,observationSnapshotId="OS-X",situations={},encounters={},identities={},currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},representationFitness={},provenance={},controlOutcomeEvidence={},candidateSupportEvidence={selectedCandidateId="CA-X"},commitmentContext={}}) end)
end)

test("Observation rejects Operation and fitness interpretations",function()
    expectError(function() OuttaMyWay.ObservationSnapshot.new({identity="OS-X",epoch=1,timestamp=1,provenance={},fieldWorld={},assemblies={},geometry={},motion={},aiStates={},playerControl={},jobEpisodeEvidence={},operationMembershipEvidence={{operationParticipation=true}},physicalRepresentationEvidence={},controlOutcomes={},unavailableSources={}}) end)
    expectError(function() OuttaMyWay.ObservationSnapshot.new({identity="OS-X",epoch=1,timestamp=1,provenance={},fieldWorld={},assemblies={},geometry={},motion={},aiStates={},playerControl={},jobEpisodeEvidence={},operationMembershipEvidence={},physicalRepresentationEvidence={{representationFitness="CURRENTLY_FIT"}},controlOutcomes={},unavailableSources={}}) end)
end)

test("sealed fixture produces one Operation Situation and Encounter",function()
    local runtime=newPictureRuntime(); local result=runtime:processSealedObservation(pictureFixture(1))
    equal(#result.operation.activeOperationIds,1); equal(#result.picture.situations,1); equal(#result.picture.encounters,1)
    equal(result.picture.encounters[1].relationship,"FUTURE_SPACE_CONVERGENCE")
    equal(result.picture.observationSnapshotId,result.snapshot.identity)
end)

test("Encounter persists when positive evidence is temporarily absent",function()
    local runtime=newPictureRuntime()
    local first=runtime:processSealedObservation(pictureFixture(1))
    local encounterId=first.picture.encounters[1].identity
    local second=runtime:processSealedObservation(pictureFixture(2,{interactions={}}))
    equal(#second.picture.encounters,1)
    equal(second.picture.encounters[1].identity,encounterId)
    equal(second.picture.encounters[1].evidence.positiveObservedThisAssessment,false)
    equal(runtime.encounters:get(encounterId).status,"ACTIVE")
    local retained=false
    for _,transition in ipairs(second.picture.diagnostics.encounterLifecycleTransitions) do
        if transition.encounterIdentity==encounterId and transition.lifecycle=="RETAINED" and transition.positiveObservedThisAssessment==false then retained=true end
    end
    if not retained then error("temporary evidence absence did not retain Encounter explicitly") end
end)

test("Job Episode end terminates Encounter and restart creates fresh identity",function()
    local runtime=newPictureRuntime()
    local first=runtime:processSealedObservation(pictureFixture(1))
    local oldEncounterId=first.picture.encounters[1].identity
    local oldEpisodeIds={first.jobEpisodes.activeEpisodeIds[1],first.jobEpisodes.activeEpisodeIds[2]}

    local stopped=runtime:processSealedObservation(pictureFixture(2,{
        interactions={},
        evidenceB={sourceJobToken="job-B",jobPresent=false,aiControlled=false,aiActive=false,playerStopObserved=true},
        membership={{assemblyReferenceKey="assembly-A",fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-A",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}}
    }))
    equal(#stopped.picture.encounters,0)
    equal(runtime.encounters:get(oldEncounterId).status,"TERMINATED")
    equal(runtime.encounters:get(oldEncounterId).terminalReason,"JOB_EPISODE_ENDED")
    local terminated=false
    for _,transition in ipairs(stopped.picture.diagnostics.encounterLifecycleTransitions) do
        if transition.encounterIdentity==oldEncounterId and transition.lifecycle=="TERMINATED" and transition.terminalReason=="JOB_EPISODE_ENDED" then
            local ended=transition.terminalEvidence.details.endedJobEpisodes
            equal(#ended,1); equal(ended[1].terminalCause,"PLAYER_STOP")
            terminated=true
        end
    end
    if not terminated then error("Encounter termination transition was not published") end

    local restarted=runtime:processSealedObservation(pictureFixture(3,{
        interactions={},
        evidenceB={sourceJobToken="job-B2",jobPresent=true,aiControlled=true,aiActive=true}
    }))
    equal(#restarted.picture.encounters,0)
    equal(#runtime.encounters:listActive(),0)
    local freshEpisode=false
    for _,episodeId in ipairs(restarted.jobEpisodes.activeEpisodeIds) do
        if episodeId~=oldEpisodeIds[1] and episodeId~=oldEpisodeIds[2] then freshEpisode=true end
    end
    if not freshEpisode then error("restart did not create a fresh Job Episode") end

    local renewed=runtime:processSealedObservation(pictureFixture(4,{
        evidenceB={sourceJobToken="job-B2",jobPresent=true,aiControlled=true,aiActive=true}
    }))
    equal(#renewed.picture.encounters,1)
    local newEncounterId=renewed.picture.encounters[1].identity
    if newEncounterId==oldEncounterId then error("renewed positive evidence resurrected the terminal Encounter") end
    equal(runtime.encounters:get(oldEncounterId).status,"TERMINATED")
    equal(runtime.encounters:get(newEncounterId).status,"ACTIVE")
    if renewed.picture.encounters[1].episodeSignature==first.picture.encounters[1].episodeSignature then error("stale Job Episode signature transferred to new Encounter") end
end)

test("Operation identity persists while membership changes",function()
    local runtime=newPictureRuntime(); local first=runtime:processSealedObservation(pictureFixture(1))
    local second=runtime:processSealedObservation(pictureFixture(2,{membership={{assemblyReferenceKey="assembly-A",fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-A",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}}}))
    equal(first.operation.activeOperationIds[1],second.operation.activeOperationIds[1])
    equal(#runtime.operations:get(second.operation.activeOperationIds[1]).memberAssemblyIds,1)
end)

test("incomplete membership evidence does not end an Operation",function()
    local runtime=newPictureRuntime(); local first=runtime:processSealedObservation(pictureFixture(1))
    local second=runtime:processSealedObservation(pictureFixture(2,{membershipComplete=false,membership={}}))
    equal(second.operation.activeOperationIds[1],first.operation.activeOperationIds[1]); equal(#second.operation.endedOperationIds,0)
    local found=false; for _,u in ipairs(second.picture.uncertainty) do if u.class=="OPERATION_MEMBERSHIP_INCOMPLETE" then found=true end end
    if not found then error("incomplete membership was not preserved as uncertainty") end
end)

test("incomplete membership cannot pre-empt authoritative Job Episode termination",function()
    local runtime=newPictureRuntime()
    local first=runtime:processSealedObservation(pictureFixture(1))
    local encounterId=first.picture.encounters[1].identity
    local operationId=first.operation.activeOperationIds[1]

    local unresolvedStop=runtime:processSealedObservation(pictureFixture(2,{
        interactions={},membershipComplete=false,
        evidenceB={sourceJobToken="job-B",jobPresent=false,aiControlled=false,aiActive=false},
        membership={{assemblyReferenceKey="assembly-A",fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-A",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}}
    }))
    equal(unresolvedStop.operation.activeOperationIds[1],operationId)
    equal(#runtime.operations:get(operationId).memberAssemblyIds,2)
    equal(#unresolvedStop.picture.encounters,1)
    equal(unresolvedStop.picture.encounters[1].identity,encounterId)
    equal(runtime.encounters:get(encounterId).status,"ACTIVE")
    local retained=false
    for _,transition in ipairs(unresolvedStop.picture.diagnostics.encounterLifecycleTransitions) do
        if transition.encounterIdentity==encounterId and transition.lifecycle=="RETAINED" then retained=true end
    end
    if not retained then error("Encounter was not retained while membership evidence was incomplete") end

    local authoritativeStop=runtime:processSealedObservation(pictureFixture(3,{
        interactions={},
        evidenceB={sourceJobToken="job-B",jobPresent=false,aiControlled=false,aiActive=false,playerStopObserved=true},
        membership={{assemblyReferenceKey="assembly-A",fieldWorldReferenceKey="field-world-77",fieldWorldSnapshotReferenceKey="snapshot-A",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}}
    }))
    equal(#authoritativeStop.picture.encounters,0)
    equal(runtime.encounters:get(encounterId).status,"TERMINATED")
    equal(runtime.encounters:get(encounterId).terminalReason,"JOB_EPISODE_ENDED")
    local ended=false
    for _,transition in ipairs(authoritativeStop.picture.diagnostics.encounterLifecycleTransitions) do
        if transition.encounterIdentity==encounterId and transition.lifecycle=="TERMINATED" and transition.terminalReason=="JOB_EPISODE_ENDED" then
            local evidence=transition.terminalEvidence.details.endedJobEpisodes
            equal(#evidence,1); equal(evidence[1].terminalCause,"PLAYER_STOP")
            ended=true
        end
    end
    if not ended then error("authoritative Job Episode termination did not win after incomplete membership evidence") end
end)

test("explicit zero membership ends an Operation and later work creates a new identity",function()
    local runtime=newPictureRuntime(); local first=runtime:processSealedObservation(pictureFixture(1))
    local ended=runtime:processSealedObservation(pictureFixture(2,{membership={},interactions={}}))
    equal(ended.operation.endedOperationIds[1],first.operation.activeOperationIds[1]); equal(#ended.operation.activeOperationIds,0)
    local later=runtime:processSealedObservation(pictureFixture(3))
    if later.operation.activeOperationIds[1]==first.operation.activeOperationIds[1] then error("new Operation reused ended identity") end
end)

test("demand contains only Committed Potential and Temporary Slack",function()
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1)).picture
    equal(#picture.demand.committedDemand,1); equal(#picture.demand.potentialDemand,1); equal(#picture.demand.temporarySlack,1)
    local fixture=pictureFixture(2); fixture.geometry.demandEvidence[1].class="PERMANENTLY_RELEASED"
    expectError(function() runtime:processSealedObservation(fixture) end)
end)

test("Representation Fitness publishes all five canonical states",function()
    local states={
        {id="FIT",data={structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=true,conservative=true},expected="CURRENTLY_FIT"},
        {id="LIMITED",data={structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=false,coverageComplete=true,conservative=true},expected="FIT_FOR_LIMITED_HORIZON"},
        {id="UNCERTAIN",data={structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=false,conservative=false},expected="USABLE_WITH_UNCERTAINTY"},
        {id="REFRESH",data={structurallyValid=true,refreshRequired=true,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=true,conservative=true},expected="REFRESH_REQUIRED"},
        {id="INVALID",data={structurallyValid=false,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=true,conservative=true},expected="STRUCTURALLY_INVALID"}
    }
    for index,item in ipairs(states) do
        local rep={assemblyReferenceKey="assembly-A",representationId=item.id,question="TEST",assessmentHorizon=5,permittedConclusions={"CONFLICT_SUPPORT"},provenance={source="fixture"}}
        for k,v in pairs(item.data) do rep[k]=v end
        local fixture=pictureFixture(index,{representations={rep}})
        local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(fixture).picture
        equal(picture.representationFitness[1].state,item.expected)
    end
end)

test("No Silent Under-Approximation is explicit",function()
    local rep={assemblyReferenceKey="assembly-A",representationId="RISK",question="CLEARANCE",assessmentHorizon=5,structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=true,coverageComplete=false,conservative=false,permittedConclusions={"CONFLICT_SUPPORT"},provenance={source="fixture"}}
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1,{representations={rep}})).picture
    equal(picture.representationFitness[1].state,"USABLE_WITH_UNCERTAINTY"); equal(picture.representationFitness[1].coverage.underApproximationRisk,true)
end)

test("structurally invalid representation grants no claim permission",function()
    local rep={assemblyReferenceKey="assembly-A",representationId="INVALID",question="CLEARANCE",assessmentHorizon=5,structurallyValid=false,coverageComplete=true,conservative=true,permittedConclusions={"CONFLICT_EXCLUSION"},provenance={source="fixture"}}
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1,{representations={rep}})).picture
    equal(#picture.representationFitness[1].claimPermissions,0)
end)

test("Follower Owns Closure is Knowledge not a selected role",function()
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1)).picture
    equal(#picture.responsibilityRelations,1); equal(picture.responsibilityRelations[1].relation,"FOLLOWER_OWNS_CLOSURE")
    if picture.responsibilityRelations[1].yieldRole~=nil or picture.responsibilityRelations[1].progressRole~=nil then error("responsibility relation selected roles") end
end)

test("same pair may have independent Encounter identities",function()
    local interactions={{interactionReferenceKey="first",subjectAssemblyReferenceKey="assembly-A",otherAssemblyReferenceKey="assembly-B",futureSpaceConverges=true,provenance={source="fixture"}},{interactionReferenceKey="second",subjectAssemblyReferenceKey="assembly-A",otherAssemblyReferenceKey="assembly-B",futureSpaceConverges=true,provenance={source="fixture"}}}
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1,{interactions=interactions})).picture
    equal(#picture.encounters,2); if picture.encounters[1].identity==picture.encounters[2].identity then error("pair identity collapsed Encounter identity") end
end)

test("current intersection takes precedence as current relationship Knowledge",function()
    local interactions={{interactionReferenceKey="current",subjectAssemblyReferenceKey="assembly-A",otherAssemblyReferenceKey="assembly-B",currentSpaceIntersects=true,futureSpaceConverges=true,provenance={source="fixture"}}}
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1,{interactions=interactions})).picture
    equal(picture.encounters[1].relationship,"CURRENT_SPACE_INTERACTION")
end)

test("Situation Assessment preserves unavailable sources and non-fit representations",function()
    local rep={assemblyReferenceKey="assembly-A",representationId="LIMIT",question="FUTURE",assessmentHorizon=10,structurallyValid=true,refreshRequired=false,currentForQuestion=true,coversAssessmentHorizon=false,coverageComplete=true,conservative=true,permittedConclusions={"CONFLICT_SUPPORT"},provenance={source="fixture"}}
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1,{representations={rep},unavailableSources={{source="sweep",reason="not observed"}}})).picture
    local classes={}; for _,u in ipairs(picture.uncertainty) do classes[u.class]=true end
    if not classes.REPRESENTATION_FITNESS or not classes.UNAVAILABLE_SOURCE then error("uncertainty was not preserved") end
end)

test("Operational Picture is immutable",function()
    local runtime=newPictureRuntime(); local picture=runtime:processSealedObservation(pictureFixture(1)).picture
    expectError(function() picture.demand.committedDemand[1]={} end)
end)

test("Situation Assessment is deterministic from fresh sealed state",function()
    local function run()
        local runtime=newPictureRuntime(); local result=runtime:processSealedObservation(pictureFixture(1)); return OuttaMyWay.ValueRecord.canonical(result.picture)
    end
    equal(run(),run())
end)


local mandatoryConstraintIds={
    "FIELD_WORLD_CONTAINMENT","TRANSITION_CLEARANCE","REPRESENTATION_FITNESS","CONTROL_CAPABILITY_AVAILABILITY","CONTINUING_INTENT_PRIORITY","PROGRESS_PRESERVATION","RESPONSIBILITY_COMPATIBILITY","OBLIGATION_COMPATIBILITY","COMMITMENT_PRECONDITIONS","EFFECTIVE_ACTUATION_COMPOSITION","SAFE_RELEASE_HANDOVER"
}

local function passConstraintEvidence()
    local result={}
    for _,id in ipairs(mandatoryConstraintIds) do
        result[id]={result="PASS",evidence={fixture=true},provenance={source="sealed-fixture"},reason="fixture supports constraint",revalidationTrigger={kind="FIXTURE_CHANGE"}}
    end
    return result
end

local function candidateSpec(referenceKey,capability,cost,subjectAssemblyId)
    local constraints=passConstraintEvidence()
    return {
        referenceKey=referenceKey,
        purpose={kind="SAFE_CONTINUATION",referenceKey=referenceKey},
        subject={assemblyId=subjectAssemblyId or "AS-00001"},
        capability=capability,
        expectedEffect={kind=capability},
        evidenceBasis={constraintEvidence=constraints},
        representationFitness={requirements={}},
        preconditions={facts={}},
        invalidationConditions={{kind="OPERATIONAL_PICTURE_CHANGE"}},
        reversibility={reversible=capability~="ESCALATE"},
        obligationsCreated={},
        releaseImplications={required=false},
        uncertainty={},
        comparisonCost=cost
    }
end

local function decisionPicture(specifications,options)
    options=options or {}
    return OuttaMyWay.OperationalPicture.new({
        identity=options.identity or "OP-DECISION",
        epoch=options.epoch or 100,
        observationSnapshotId="OS-DECISION",
        situations={{identity="SI-1",operationId="OR-1",memberAssemblyIds={"AS-00001","AS-00002"},relevantAssemblyIds={"AS-00001","AS-00002"},provenance={}}},
        encounters={{identity="EN-1",operationId="OR-1",subjectAssemblyId="AS-00001",otherAssemblyId="AS-00002",relationship="FUTURE_SPACE_CONVERGENCE",evidence={}}},
        identities={assemblies={"AS-00001","AS-00002"},components={},jobEpisodes={active={"JE-1","JE-2"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},
        responsibilityRelations=options.responsibilityRelations or {},
        uncertainty=options.uncertainty or {},
        representationFitness=options.representationFitness or {},
        provenance={source="sealed-decision-fixture"},
        controlOutcomeEvidence={},
        candidateSupportEvidence={complete=true,supportBoundary={kind="SEALED_FIXTURE",capabilityBoundary=options.capabilityBoundary or {},decisionPolicy=options.decisionPolicy},candidateSpecifications=specifications,provenance={source="sealed-fixture"}},
        commitmentContext=options.commitmentContext or {}
    })
end

local function newDecisionRuntime()
    local runtime=OuttaMyWay.Runtime.new(); runtime:initialize(); return runtime
end

local function findVerdict(result,candidateId,constraintId)
    for _,verdict in ipairs(result.verdicts) do
        if verdict.candidateId==candidateId and verdict.constraintId==constraintId then return verdict end
    end
    error("verdict not found")
end

local function candidateByCapability(result,capability)
    for _,candidate in ipairs(result.candidates) do if candidate.capability==capability then return candidate end end
    error("candidate not found " .. capability)
end

test("Candidate Action Space requires explicit complete support boundary",function()
    local picture=decisionPicture({candidateSpec("continue","CONTINUE_UNCHANGED",0)})
    local values=OuttaMyWay.ValueRecord.toTable(picture); values.candidateSupportEvidence.complete=false
    local incomplete=OuttaMyWay.OperationalPicture.new(values)
    local runtime=newDecisionRuntime()
    expectError(function() runtime:evaluateSealedOperationalPicture(incomplete) end)
end)

test("Candidate generator publishes all supportable alternatives without selection",function()
    local specs={candidateSpec("hold","HOLD",5),candidateSpec("continue","CONTINUE_UNCHANGED",0),candidateSpec("observe","CONTINUE_OBSERVATION",2)}
    specs[3].preconditions.boundedObservationContract={knowledgeGap="gap",expectedRealityEvolution="motion",preservedUsefulAction="hold",exhaustionCondition="deadline",reassessmentDeadline=10,progressParticipantId="AS-00002"}
    local runtime=newDecisionRuntime(); local result=runtime:evaluateSealedOperationalPicture(decisionPicture(specs))
    equal(#result.candidates,3); equal(result.candidateInventory.complete,true)
    for _,candidate in ipairs(result.candidates) do
        if candidate.selectedCandidateId~=nil or candidate.viable~=nil then error("candidate generator selected an action") end
    end
end)

test("every candidate receives every mandatory constraint verdict",function()
    local specs={candidateSpec("continue","CONTINUE_UNCHANGED",0),candidateSpec("escalate","ESCALATE",10)}
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture(specs))
    equal(#result.verdictSet.mandatoryConstraintIds,11); equal(#result.verdicts,22); equal(result.verdictSet.complete,true)
end)

test("FAIL and UNRESOLVED mandatory verdicts cannot remain viable",function()
    local failed=candidateSpec("failed","HOLD",0)
    failed.evidenceBasis.constraintEvidence.FIELD_WORLD_CONTAINMENT.result="FAIL"
    local unresolved=candidateSpec("unresolved","REGULATE_SPEED",1)
    unresolved.evidenceBasis.constraintEvidence.TRANSITION_CLEARANCE.result="UNRESOLVED"
    local pass=candidateSpec("pass","CONTINUE_UNCHANGED",5)
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({failed,unresolved,pass}))
    equal(#result.decision.viableCandidateIds,1)
    equal(result.decision.selectedCandidateId,candidateByCapability(result,"CONTINUE_UNCHANGED").identity)
end)

test("comparison cost is applied only after mandatory admissibility",function()
    local cheap=candidateSpec("cheap-fail","HOLD",0)
    cheap.evidenceBasis.constraintEvidence.FIELD_WORLD_CONTAINMENT.result="FAIL"
    local expensive=candidateSpec("expensive-pass","REGULATE_SPEED",10)
    expensive.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    expensive.evidenceBasis.effectiveActuationComposition={identity="EC-A",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-FIXTURE",capability="REGULATE_SPEED",progressActuation=true}}}
    local picture=decisionPicture({cheap,expensive},{representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="SPEED",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"SPEED"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(result.decision.selectedCandidateId,candidateByCapability(result,"REGULATE_SPEED").identity)
end)

local function trafficPolicy(requirementKey)
    return {kind="TRAFFIC_POLICEMAN_SEQUENTIAL_PRIMARY",governingRequirementKey=requirementKey}
end

local function trafficPreference(candidate,requirementKey)
    candidate.evidenceBasis.trafficPolicemanPreference={
        primaryResolution=true,
        governingRequirementKey=requirementKey,
        exhaustionEvidence={}
    }
    return candidate.evidenceBasis.trafficPolicemanPreference
end

local function bandExhaustion(pictureId,requirementKey,capability)
    return {result="PASS",operationalPictureId=pictureId,governingRequirementKey=requirementKey,capability=capability,provenance={source="sealed-fixture"}}
end

test("Traffic Policeman Decision selects Observe before cheaper later bands",function()
    local requirement="traffic:EN-1"
    local observe=candidateSpec("observe-first","CONTINUE_OBSERVATION",100)
    observe.preconditions.boundedObservationContract={knowledgeGap="intent",expectedRealityEvolution="native motion",preservedUsefulAction="regulate",exhaustionCondition="action-space compression",reassessmentDeadline=110,progressParticipantId="AS-00002"}
    trafficPreference(observe,requirement)
    local escalate=candidateSpec("cheap-escalate","ESCALATE",0)
    trafficPreference(escalate,requirement)
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({escalate,observe},{decisionPolicy=trafficPolicy(requirement)}))
    equal(result.decision.selectedCandidateId,candidateByCapability(result,"CONTINUE_OBSERVATION").identity)
    equal(result.decision.comparisonBasis.rule,"TRAFFIC_POLICEMAN_SEQUENTIAL_PRIMARY")
end)

test("Traffic Policeman later band waits without explicit same-picture exhaustion evidence",function()
    local requirement="traffic:EN-1"
    local escalate=candidateSpec("escalate-without-exhaustion","ESCALATE",0)
    trafficPreference(escalate,requirement)
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({escalate},{decisionPolicy=trafficPolicy(requirement)}))
    equal(result.decision.selectedCandidateId,nil)
    equal(result.decision.commitmentAction,"WAIT")
    equal(result.decision.nonIntervention.classification,"WAIT_FOR_PREFERENCE_EXHAUSTION_EVIDENCE")
end)

test("Traffic Policeman Regulation requires explicit Observe exhaustion from the same Operational Picture",function()
    local requirement="traffic:EN-1"
    local regulate=candidateSpec("regulated-progress","REGULATE_SPEED",5)
    local metadata=trafficPreference(regulate,requirement)
    metadata.exhaustionEvidence.CONTINUE_OBSERVATION=bandExhaustion("OP-DECISION",requirement,"CONTINUE_OBSERVATION")
    regulate.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    regulate.evidenceBasis.effectiveActuationComposition={identity="EC-TP",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-TP",capability="REGULATE_SPEED",progressActuation=true}}}
    local picture=decisionPicture({regulate},{decisionPolicy=trafficPolicy(requirement),representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="SPEED",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"SPEED"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(result.decision.selectedCandidateId,result.candidates[1].identity)
    equal(result.decision.comparisonBasis.rankedCandidates[1].preferenceRank,2)
end)

test("Traffic Policeman exhaustion evidence cannot be reused from an older Operational Picture",function()
    local requirement="traffic:EN-1"
    local regulate=candidateSpec("stale-regulation","REGULATE_SPEED",5)
    local metadata=trafficPreference(regulate,requirement)
    metadata.exhaustionEvidence.CONTINUE_OBSERVATION=bandExhaustion("OP-OLD",requirement,"CONTINUE_OBSERVATION")
    regulate.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    regulate.evidenceBasis.effectiveActuationComposition={identity="EC-TP-STALE",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-TP",capability="REGULATE_SPEED",progressActuation=true}}}
    local picture=decisionPicture({regulate},{decisionPolicy=trafficPolicy(requirement),representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="SPEED",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"SPEED"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(result.decision.selectedCandidateId,nil)
    equal(result.decision.nonIntervention.classification,"WAIT_FOR_PREFERENCE_EXHAUSTION_EVIDENCE")
end)

test("Traffic Policeman escalation requires participant-complete autonomous-space exhaustion",function()
    local requirement="traffic:EN-1"
    local escalate=candidateSpec("escalate-complete","ESCALATE",0)
    local metadata=trafficPreference(escalate,requirement)
    for _,capability in ipairs({"CONTINUE_OBSERVATION","REGULATE_SPEED","HOLD","REPOSITION"}) do
        metadata.exhaustionEvidence[capability]=bandExhaustion("OP-DECISION",requirement,capability)
    end
    metadata.autonomousSpaceExhaustion={result="PASS",operationalPictureId="OP-DECISION",governingRequirementKey=requirement,completeSupportableAutonomousSpace=true,participantComplete=true,provenance={source="sealed-fixture"}}
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({escalate},{decisionPolicy=trafficPolicy(requirement)}))
    equal(result.decision.selectedCandidateId,result.candidates[1].identity)
    equal(result.decision.commitmentAction,"SETTLE")
end)


local function headOnTestSnapshot()
    return OuttaMyWay.ObservationSnapshot.new({
        identity="OS-HEADON",epoch=201,timestamp=20,provenance={source="head-on-test"},
        fieldWorld={referenceKey="field-world:test",geometryFingerprint="fw"},
        assemblies={{assemblyId="AS-00001",referenceKey="vehicle-root:101",memberComponentIds={}},{assemblyId="AS-00002",referenceKey="vehicle-root:201",memberComponentIds={}}},
        geometry={currentSpaceEvidence={},futureSpaceEvidence={},futureSpaceRelationshipEvidence={},demandEvidence={},interactionEvidence={}},
        motion={closureEvidence={}},
        aiStates={},playerControl={},jobEpisodeEvidence={},operationMembershipEvidence={},physicalRepresentationEvidence={},controlOutcomes={},unavailableSources={},diagnostics={}
    })
end

local function headOnSupportPicture(options)
    options=options or {}
    local headingDot=options.headingDot or -0.99
    local otherHeadingZ=math.sqrt(math.max(0,1-headingDot*headingDot))
    local subjectJobToken=options.subjectJobToken or "job-A"
    local otherJobToken=options.otherJobToken or "job-B"
    local productive={}
    if options.productive==true then
        productive={
            {assemblyId="AS-00001",assemblyReferenceKey="vehicle-root:101",jobToken=subjectJobToken,evidenceClass="NON_TURN_LINE_ACTIVE",productivePositive=options.subjectProductive~=false,segmentAvailable=true,isTurn=false,movingDirection=1,implementLineClassification="ACTIVE",representationFitness="FIT_FOR_LIMITED_HORIZON",provenance={source="SituationAssessment.ProductiveContinuation",layer="KNOWLEDGE"}},
            {assemblyId="AS-00002",assemblyReferenceKey="vehicle-root:201",jobToken=otherJobToken,evidenceClass="NON_TURN_LINE_ACTIVE",productivePositive=options.otherProductive~=false,segmentAvailable=true,isTurn=false,movingDirection=1,implementLineClassification="ACTIVE",representationFitness="FIT_FOR_LIMITED_HORIZON",provenance={source="SituationAssessment.ProductiveContinuation",layer="KNOWLEDGE"}}
        }
    end
    local currentInteraction=options.currentInteraction==true
    return OuttaMyWay.OperationalPicture.new({
        identity="OP-HEADON",epoch=200,observationSnapshotId="OS-HEADON",
        situations={{identity="SI-HEADON",operationId="OR-1",memberAssemblyIds={"AS-00001","AS-00002"},relevantAssemblyIds={"AS-00001","AS-00002"},futureSpaceRelationships={{interactionReferenceKey="vehicle-root:101|vehicle-root:201",subjectAssemblyId="AS-00001",otherAssemblyId="AS-00002",positiveIntersection=true}},provenance={}}},
        encounters={{identity="EN-HEADON",operationId="OR-1",subjectAssemblyId="AS-00001",otherAssemblyId="AS-00002",relationship="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION",lifecycleState="ACTIVE",evidence={interactionReferenceKey="vehicle-root:101|vehicle-root:201",futureSpaceConverges=true,currentSpaceIntersects=currentInteraction}}},
        identities={assemblies={"AS-00001","AS-00002"},components={},jobEpisodes={active={"JE-A","JE-B"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},representationFitness={},
        motionEvidence={
            {assemblyId="AS-00001",assemblyReferenceKey="vehicle-root:101",sourceJobToken=subjectJobToken,headingX=1,headingZ=0,localIntentClassification="SETTLED_CONTINUATION"},
            {assemblyId="AS-00002",assemblyReferenceKey="vehicle-root:201",sourceJobToken=otherJobToken,headingX=headingDot,headingZ=otherHeadingZ,localIntentClassification="SETTLED_CONTINUATION"}
        },
        physicalSpaceEvidence={{assemblyId="AS-00001"},{assemblyId="AS-00002"}},
        productiveContinuationKnowledge=productive,followerBoundaryKnowledge=options.followerBoundaryKnowledge or {},guardedRecoveryKnowledge={},
        provenance={source="head-on-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext=options.commitmentContext or {},diagnostics={}
    })
end

local function autonomousHeadOnRuntime()
    return newDecisionRuntime()
end

local function autonomousHeadOnPicture(options)
    options=options or {}; options.productive=true
    return headOnSupportPicture(options)
end

test("autonomous head-on support remains passive without positive Productive Continuation evidence",function()
    local runtime=newDecisionRuntime()
    local supported=runtime.liveTrafficCandidateSupport:attach(headOnSupportPicture(),headOnTestSnapshot())
    equal(supported.candidateSupportEvidence.supportBoundary.mode,"PASSIVE_LIVE_ZERO_CONTROL")
end)

local function d0143KnowledgeRecord(options)
    options=options or {}
    return {
        status="SUPPORTED",reason="D0143_TS015_NEAR_COLLINEAR_COOPERATIVE_PASSAGE_SUPPORTED",authority="D0143_P23_EMPIRICALLY_BOUNDED_TS015",
        operationId="OR-1",pairReferenceKey="vehicle-root:101|vehicle-root:201",encounterIdentity="EN-HEADON",
        assemblyIds={"AS-00001","AS-00002"},condorAssemblyId="AS-00001",patriotAssemblyId="AS-00002",
        condorReferenceKey="vehicle-root:101",patriotReferenceKey="vehicle-root:201",condorJobToken="job-A",patriotJobToken="job-B",
        separationM=options.separationM or 60.0,initialLateralOffsetM=options.lateralOffsetM or 0.5,headingDot=options.headingDot or -1.0,
        sharedAxisX=1,sharedAxisZ=0,sharedRightX=0,sharedRightZ=-1,
        representationFitnessIds={"d0143-ts015-cooperative-passage:EN-HEADON:AS-00001","d0143-ts015-cooperative-passage:EN-HEADON:AS-00002"},
        footprintEvidence={source="SITUATION_ASSESSMENT_PHYSICAL_SPACE_EVIDENCE",condorConfigurationProfileId="CFG-A",patriotConfigurationProfileId="CFG-B",noAdditionalGeometryCalculation=true},
        scope={vehiclePair="Condor Endurance II|Patriot 4450",calibrationAuthority="P23_V4_7_92_TO_V4_7_94",generalVehicleAuthority=false,asymmetricAuthority=false},
        provenance={source="CooperativePassageAssessment",layer="SITUATION_ASSESSMENT",decisionAuthority=false,controlAuthority=false}
    }
end

local function d0143Picture(options)
    -- Legacy D-0143 regression fixtures intentionally exercise the retained donor
    -- path rather than the v4.7.101 D-0146 Step-2 production path.
    OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED=false
    options=options or {}
    local record=options.record or d0143KnowledgeRecord(options)
    return OuttaMyWay.OperationalPicture.new({
        identity=options.identity or "OP-D0143",epoch=options.epoch or 220,observationSnapshotId="OS-HEADON",
        situations={},encounters={{identity="EN-HEADON",operationId="OR-1",subjectAssemblyId="AS-00001",otherAssemblyId="AS-00002",relationship="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION",lifecycleState="ACTIVE",evidence={interactionReferenceKey="vehicle-root:101|vehicle-root:201",futureSpaceConverges=true,currentSpaceIntersects=false}}},
        identities={assemblies={"AS-00001","AS-00002"},components={},jobEpisodes={active={"JE-A","JE-B"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},
        representationFitness={
            {representationId="live-representation:vehicle-root:101",assemblyId="AS-00001",question="CURRENT_CONFLICT_SUPPORT",assessmentHorizon=0,state="STRUCTURALLY_INVALID",claimPermissions={},coverage={complete=false,conservative=false},uncertainty={{kind="METADATA_ENVELOPE_INCOMPLETE"}},validityDependencies={},provenance={source="fixture"}},
            {representationId="live-representation:vehicle-root:201",assemblyId="AS-00002",question="CURRENT_CONFLICT_SUPPORT",assessmentHorizon=0,state="STRUCTURALLY_INVALID",claimPermissions={},coverage={complete=false,conservative=false},uncertainty={{kind="METADATA_ENVELOPE_INCOMPLETE"}},validityDependencies={},provenance={source="fixture"}},
            {representationId="d0143-ts015-cooperative-passage:EN-HEADON:AS-00001",assemblyId="AS-00001",question="D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY",assessmentHorizon="CURRENT_SUPPORTED_TS015_ENCOUNTER_ONLY",state="FIT_FOR_LIMITED_HORIZON",claimPermissions={"D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY"},coverage={complete=false,conservative=false,underApproximationRisk=true},uncertainty={"GENERAL_NEGATIVE_CLEARANCE_NOT_CLAIMED"},validityDependencies={"BOOTSTRAP_CACHED_PLAN_VIEW_FOOTPRINT"},provenance={source="fixture"}},
            {representationId="d0143-ts015-cooperative-passage:EN-HEADON:AS-00002",assemblyId="AS-00002",question="D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY",assessmentHorizon="CURRENT_SUPPORTED_TS015_ENCOUNTER_ONLY",state="FIT_FOR_LIMITED_HORIZON",claimPermissions={"D0143_TS015_COOPERATIVE_PASSAGE_EMPIRICAL_ADMISSIBILITY"},coverage={complete=false,conservative=false,underApproximationRisk=true},uncertainty={"GENERAL_NEGATIVE_CLEARANCE_NOT_CLAIMED"},validityDependencies={"BOOTSTRAP_CACHED_PLAN_VIEW_FOOTPRINT"},provenance={source="fixture"}}
        },
        motionEvidence={},physicalSpaceEvidence={},productiveContinuationKnowledge={},guardedRecoveryKnowledge={},followerBoundaryKnowledge=options.followerBoundaryKnowledge or {},cooperativePassageKnowledge={record},
        provenance={source="d0143-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext=options.commitmentContext or {},diagnostics={}
    })
end

local function d0143AssessmentContext(options)
    options=options or {}
    local lateral=options.lateralOffsetM or 0.5
    local separation=options.separationM or 60.0
    local headingDot=options.headingDot or -1.0
    local hz=math.sqrt(math.max(0,1-headingDot*headingDot))
    return {
        currentSpace={
            {assemblyId="AS-00001",occupancy={x=0,z=0}},{assemblyId="AS-00002",occupancy={x=separation,z=lateral}}
        },
        motionEvidence={
            {assemblyId="AS-00001",assemblyReferenceKey="vehicle-root:101",name="Condor Endurance II",sourceJobToken="job-A",headingX=1,headingZ=0,localIntentClassification="SETTLED_CONTINUATION"},
            {assemblyId="AS-00002",assemblyReferenceKey="vehicle-root:201",name="Patriot 4450",sourceJobToken="job-B",headingX=headingDot,headingZ=hz,localIntentClassification="SETTLED_CONTINUATION"}
        },
        productiveKnowledge={
            {assemblyId="AS-00001",jobToken="job-A",productivePositive=true},{assemblyId="AS-00002",jobToken="job-B",productivePositive=true}
        },
        physicalSpaceEvidence=options.noFootprint and {} or {
            {assemblyId="AS-00001",assemblyReferenceKey="vehicle-root:101",episodeKey="vehicle-root:101|job-A",configurationProfileId="CFG-A",primitives={{kind="DISC",positiveConflictSupport=true}},summary={physicalPrimitiveCount=14,hullPointCount=17},coverageComplete=false,negativeClearanceAuthority=false,provenance={source="AssemblyRepresentationCache"}},
            {assemblyId="AS-00002",assemblyReferenceKey="vehicle-root:201",episodeKey="vehicle-root:201|job-B",configurationProfileId="CFG-B",primitives={{kind="DISC",positiveConflictSupport=true}},summary={physicalPrimitiveCount=12,hullPointCount=17},coverageComplete=false,negativeClearanceAuthority=false,provenance={source="AssemblyRepresentationCache"}}
        },
        situations={{identity="SI-HEADON",operationId="OR-1",memberAssemblyIds={"AS-00001","AS-00002"},futureSpaceRelationships={{interactionReferenceKey="vehicle-root:101|vehicle-root:201",subjectAssemblyId="AS-00001",otherAssemblyId="AS-00002",positiveIntersection=true}}}},
        encounters={{identity="EN-HEADON",operationId="OR-1",lifecycleState="ACTIVE",evidence={interactionReferenceKey="vehicle-root:101|vehicle-root:201",currentSpaceIntersects=options.currentInteraction==true}}}
    }
end

test("D-0143 Situation Assessment supports only the narrow near-collinear Condor Patriot TS015 envelope",function()
    local supported,fitness=OuttaMyWay.CooperativePassageAssessment.buildKnowledge(d0143AssessmentContext())
    equal(#supported,1); equal(supported[1].status,"SUPPORTED")
    equal(supported[1].reason,"D0143_TS015_NEAR_COLLINEAR_COOPERATIVE_PASSAGE_SUPPORTED")
    equal(#fitness,2); equal(fitness[1].state,"FIT_FOR_LIMITED_HORIZON"); equal(fitness[2].state,"FIT_FOR_LIMITED_HORIZON")
    equal(fitness[1].evidence.geometryCalculation,"NONE_REUSES_SITUATION_ASSESSMENT_PHYSICAL_SPACE_EVIDENCE")
    equal(supported[1].footprintEvidence.noAdditionalGeometryCalculation,true)
    local asymmetric=OuttaMyWay.CooperativePassageAssessment.buildKnowledge(d0143AssessmentContext({lateralOffsetM=4.0}))
    equal(asymmetric[1].status,"UNSUPPORTED"); equal(asymmetric[1].reason,"INITIAL_LATERAL_OFFSET_OUTSIDE_PROVEN_TS015_SCOPE")
    local tooClose=OuttaMyWay.CooperativePassageAssessment.buildKnowledge(d0143AssessmentContext({separationM=45.0}))
    equal(tooClose[1].status,"UNSUPPORTED"); equal(tooClose[1].reason,"PAIR_TOO_CLOSE_FOR_PROVEN_TS015_ENTRY")
    local interacting=OuttaMyWay.CooperativePassageAssessment.buildKnowledge(d0143AssessmentContext({currentInteraction=true}))
    equal(interacting[1].status,"UNSUPPORTED"); equal(interacting[1].reason,"CURRENT_PHYSICAL_INTERACTION_ALREADY_BEGUN")
    local noFootprint,noFitness=OuttaMyWay.CooperativePassageAssessment.buildKnowledge(d0143AssessmentContext({noFootprint=true}))
    equal(noFootprint[1].status,"UNSUPPORTED"); equal(noFootprint[1].reason,"PURPOSE_SPECIFIC_FOOTPRINT_EVIDENCE_UNAVAILABLE"); equal(#noFitness,0)
end)

test("D-0143 publishes one joint Cooperative Passage Reposition Candidate with same-picture preference exhaustion",function()
    local runtime=autonomousHeadOnRuntime()
    local supported=runtime.liveTrafficCandidateSupport:attach(d0143Picture(),headOnTestSnapshot())
    equal(supported.candidateSupportEvidence.supportBoundary.mode,"TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST")
    equal(#supported.candidateSupportEvidence.candidateSpecifications,1)
    local spec=supported.candidateSupportEvidence.candidateSpecifications[1]
    equal(spec.capability,"REPOSITION"); equal(#spec.subject.assemblyIds,2)
    equal(#spec.evidenceBasis.progressActuationOwnership.assemblyIds,2)
    equal(#spec.evidenceBasis.effectiveActuationComposition.entries,2)
    equal(spec.evidenceBasis.autonomousHeadOnBridge,nil)
    equal(spec.representationFitness.requirements[1].representationId,"d0143-ts015-cooperative-passage:EN-HEADON:AS-00001")
    equal(spec.representationFitness.requirements[2].representationId,"d0143-ts015-cooperative-passage:EN-HEADON:AS-00002")
    for _,capability in ipairs({"CONTINUE_OBSERVATION","REGULATE_SPEED","HOLD"}) do
        local exhaustion=spec.evidenceBasis.trafficPolicemanPreference.exhaustionEvidence[capability]
        equal(exhaustion.result,"PASS"); equal(exhaustion.operationalPictureId,supported.identity); equal(exhaustion.capability,capability)
    end
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    equal(#evaluated.candidates,1)
    equal(findVerdict(evaluated,evaluated.candidates[1].identity,"REPRESENTATION_FITNESS").result,"PASS")
    equal(evaluated.decision.selectedCandidateId,evaluated.candidates[1].identity)
    equal(evaluated.decision.commitmentAction,"CREATE")
end)

test("D-0143 joint Candidate crosses the normal Commitment boundary with both progress owners",function()
    local runtime=autonomousHeadOnRuntime()
    local supported=runtime.liveTrafficCandidateSupport:attach(d0143Picture(),headOnTestSnapshot())
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    local applied,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision(runtime,supported,evaluated)
    equal(reason,nil); equal(applied.commitment.state,"ACTIVE")
    equal(runtime.authorities:ownerOf("AS-00001"),applied.commitment.identity)
    equal(runtime.authorities:ownerOf("AS-00002"),applied.commitment.identity)
    equal(#runtime.authorities:tokensForCommitment(applied.commitment.identity),2)
    local obligations=runtime.obligations:openForOwner(applied.commitment.identity)
    equal(#obligations,1); equal(obligations[1].requiredOutcome.kind,"COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK")
end)

test("D-0143 Dispatcher emits two typed ControlRequests and positive handoff settles immediately with no cooldown",function()
    local runtime=autonomousHeadOnRuntime()
    local handler=nil; local accepted=nil
    local control={}
    function control:setCompletionHandler(fn) handler=fn end
    function control:isActive() return false end
    function control:executeJointRequests(a,b,candidate) accepted={a,b,candidate}; return true,"COOPERATIVE_PASSAGE_STARTED" end
    runtime.liveControlDispatcher:setCooperativePassageControl(control)
    local supported=runtime.liveTrafficCandidateSupport:attach(d0143Picture(),headOnTestSnapshot())
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    local dispatched=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    equal(dispatched.status,"ACCEPTED"); equal(#accepted,3); equal(#dispatched.requests,2)
    equal(dispatched.requests[1].commitmentId,dispatched.requests[2].commitmentId)
    equal(dispatched.requests[1].capability,"REPOSITION"); equal(dispatched.requests[2].capability,"REPOSITION")
    equal(dispatched.requests[1].assemblyId~=dispatched.requests[2].assemblyId,true)
    local commitmentId=dispatched.commitment.identity
    handler({status="SUCCEEDED",commitmentId=commitmentId,evidence={kind="D0143_COOPERATIVE_PASSAGE_RESTORED_AND_HANDED_BACK",sameJobs=true,bothRestored=true,cooldown=false}})
    equal(runtime.commitments:get(commitmentId).state,"SUCCEEDED")
    equal(runtime.authorities:ownerOf("AS-00001"),nil); equal(runtime.authorities:ownerOf("AS-00002"),nil)
    equal(#runtime.obligations:openForOwner(commitmentId),0)
end)

test("v4.7.57 refuge redispatch requires independent current head-on support",function()
    equal(OuttaMyWay.Prototype22CapabilityGate.autonomousHeadOnDispatchDisposition({kind="TS015_RELOCATE"},nil,true),"BLOCK_ACTIVE_REFUGE_RESOLUTION")
    equal(OuttaMyWay.Prototype22CapabilityGate.autonomousHeadOnDispatchDisposition(nil,{kind="TS015_RELOCATE",firstNativeAt=nil},true),"BLOCK_PRIOR_REFUGE_HANDOFF_UNRESOLVED")
    equal(OuttaMyWay.Prototype22CapabilityGate.autonomousHeadOnDispatchDisposition(nil,{kind="TS015_RELOCATE",firstNativeAt=123},false),"BLOCK_NO_INDEPENDENT_HEAD_ON_SUPPORT")
    equal(OuttaMyWay.Prototype22CapabilityGate.autonomousHeadOnDispatchDisposition(nil,{kind="TS015_RELOCATE",firstNativeAt=123},true),"ALLOW_SUPERSEDE_PRIOR_REFUGE_MONITOR_AFTER_INDEPENDENT_HEAD_ON_SUPPORT")
    equal(OuttaMyWay.Prototype22CapabilityGate.autonomousHeadOnDispatchDisposition(nil,nil,false),"BLOCK_NO_INDEPENDENT_HEAD_ON_SUPPORT")
    equal(OuttaMyWay.Prototype22CapabilityGate.autonomousHeadOnDispatchDisposition(nil,nil,true),"ALLOW")
end)

test("D-0143 later convergence after positive handoff creates a fresh Commitment with no cooldown ownership",function()
    local runtime=autonomousHeadOnRuntime()
    local first=runtime.liveTrafficCandidateSupport:attach(d0143Picture({identity="OP-D0143-FIRST",epoch=230}),headOnTestSnapshot())
    local firstEval=runtime:evaluateSealedOperationalPicture(first)
    local firstApplied,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision(runtime,first,firstEval)
    equal(reason,nil)
    local firstId=firstApplied.commitment.identity
    local settled,settleReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.completeCooperativePassage(runtime,firstId,{kind="D0143_POSITIVE_RESTORATION_AND_HANDOFF",sameJobs=true,bothRestored=true})
    equal(settleReason,nil); equal(settled.commitment.state,"SUCCEEDED")
    equal(runtime.authorities:ownerOf("AS-00001"),nil); equal(runtime.authorities:ownerOf("AS-00002"),nil)

    local second=runtime.liveTrafficCandidateSupport:attach(d0143Picture({identity="OP-D0143-SECOND",epoch=231}),headOnTestSnapshot())
    local secondEval=runtime:evaluateSealedOperationalPicture(second)
    equal(secondEval.decision.commitmentAction,"CREATE")
    local secondApplied,secondReason=OuttaMyWay.LiveTrafficCommitmentLifecycle.applyCooperativePassageDecision(runtime,second,secondEval)
    equal(secondReason,nil); equal(secondApplied.commitment.identity~=firstId,true)
end)

test("Follower Owns Closure rejects generic Leader reposition",function()
    local reposition=candidateSpec("leader-reposition","REPOSITION",1,"AS-00001")
    reposition.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    reposition.evidenceBasis.effectiveActuationComposition={identity="EC-R",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-R",capability="REPOSITION",progressActuation=true}}}
    local picture=decisionPicture({reposition},{responsibilityRelations={{relation="FOLLOWER_OWNS_CLOSURE",followerAssemblyId="AS-00002",leaderAssemblyId="AS-00001",closingRate=1,horizon=5,provenance={}}},representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="REPOSITION",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"REPOSITION"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    local candidate=result.candidates[1]
    equal(findVerdict(result,candidate.identity,"RESPONSIBILITY_COMPATIBILITY").result,"FAIL")
    equal(result.decision.commitmentAction,"SETTLE")
end)

test("explicit responsibility exception may admit Leader reposition",function()
    local reposition=candidateSpec("leader-reposition-exception","REPOSITION",1,"AS-00001")
    reposition.evidenceBasis.responsibilityException={result="PASS",reason="explicit transfer evidence",evidence={accepted=true},provenance={source="fixture"}}
    reposition.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    reposition.evidenceBasis.effectiveActuationComposition={identity="EC-R2",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-R",capability="REPOSITION",progressActuation=true}}}
    local picture=decisionPicture({reposition},{responsibilityRelations={{relation="FOLLOWER_OWNS_CLOSURE",followerAssemblyId="AS-00002",leaderAssemblyId="AS-00001",closingRate=1,horizon=5,provenance={}}},representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="REPOSITION",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"REPOSITION"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(findVerdict(result,result.candidates[1].identity,"RESPONSIBILITY_COMPATIBILITY").result,"PASS")
    equal(result.decision.selectedCandidateId,result.candidates[1].identity)
end)

test("purpose-specific Representation Fitness withholds unsupported authority",function()
    local hold=candidateSpec("hold","HOLD",1)
    hold.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    hold.evidenceBasis.effectiveActuationComposition={identity="EC-H",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-H",capability="HOLD",effectClass="HOLD",progressActuation=false}}}
    local picture=decisionPicture({hold},{representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="HOLD",assessmentHorizon=5,state="REFRESH_REQUIRED",claimPermissions={},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(findVerdict(result,result.candidates[1].identity,"REPRESENTATION_FITNESS").result,"UNRESOLVED")
    equal(result.decision.commitmentAction,"WAIT")
end)

test("CONTINUE_OBSERVATION requires a complete Bounded Observation Contract",function()
    local observe=candidateSpec("observe","CONTINUE_OBSERVATION",1)
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({observe}))
    equal(findVerdict(result,result.candidates[1].identity,"COMMITMENT_PRECONDITIONS").result,"FAIL")
end)

test("complete Bounded Observation Contract admits CONTINUE_OBSERVATION",function()
    local observe=candidateSpec("observe","CONTINUE_OBSERVATION",1)
    observe.preconditions.boundedObservationContract={knowledgeGap="clearance",expectedRealityEvolution="follower advances",preservedUsefulAction="hold later",exhaustionCondition="reserve exhausted",reassessmentDeadline=12,progressParticipantId="AS-00002"}
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({observe}))
    equal(result.decision.selectedCandidateId,result.candidates[1].identity)
    equal(result.decision.commitmentAction,"WAIT")
    equal(result.decision.nonIntervention.explicit,true)
end)

test("Effective Actuation Composition rejects never hold all",function()
    local hold=candidateSpec("all-held","HOLD",1)
    hold.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    hold.evidenceBasis.effectiveActuationComposition={identity="EC-ALL",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-H",capability="HOLD",effectClass="HOLD",progressActuation=false},{assemblyId="AS-00002",commitmentId="CM-H",capability="HOLD",effectClass="HOLD",progressActuation=false}}}
    local picture=decisionPicture({hold},{representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="HOLD",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"HOLD"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(findVerdict(result,result.candidates[1].identity,"EFFECTIVE_ACTUATION_COMPOSITION").result,"FAIL")
end)

test("unresolved complete space produces explicit WAIT non-intervention",function()
    local hold=candidateSpec("hold-unresolved","HOLD",1)
    hold.evidenceBasis.constraintEvidence.CONTROL_CAPABILITY_AVAILABILITY.result="UNRESOLVED"
    hold.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    hold.evidenceBasis.effectiveActuationComposition={identity="EC-U",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="CM-U",capability="HOLD",effectClass="HOLD",progressActuation=false}}}
    local picture=decisionPicture({hold},{representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="HOLD",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"HOLD"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(picture)
    equal(result.decision.selectedCandidateId,nil); equal(result.decision.commitmentAction,"WAIT"); equal(result.decision.nonIntervention.classification,"WAIT_FOR_EVIDENCE")
end)

test("fully failed complete space produces explicit SETTLE non-intervention",function()
    local candidate=candidateSpec("failed","CONTINUE_UNCHANGED",1)
    candidate.evidenceBasis.constraintEvidence.CONTINUING_INTENT_PRIORITY.result="FAIL"
    local result=newDecisionRuntime():evaluateSealedOperationalPicture(decisionPicture({candidate}))
    equal(result.decision.selectedCandidateId,nil); equal(result.decision.commitmentAction,"SETTLE"); equal(result.decision.nonIntervention.classification,"COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED")
end)

test("Decision selection is deterministic from identical sealed inputs",function()
    local function run()
        local a=candidateSpec("a","CONTINUE_UNCHANGED",1)
        local b=candidateSpec("b","ESCALATE",2)
        local runtime=newDecisionRuntime(); local result=runtime:evaluateSealedOperationalPicture(decisionPicture({b,a}))
        return OuttaMyWay.ValueRecord.canonical(result.candidateInventory),OuttaMyWay.ValueRecord.canonical(result.verdictSet),OuttaMyWay.ValueRecord.canonical(result.decision)
    end
    local ai,av,ad=run(); local bi,bv,bd=run(); equal(ai,bi); equal(av,bv); equal(ad,bd)
end)



local fixtureModule=dofile(root .. "/scenarios/replay/HistoricalFixtures.lua")

test("ReplayFixture rejects duplicate aliases",function()
    expectError(function() OuttaMyWay.ReplayFixture.new({identity="RF-X",title="x",sourceEvidence={{source="x"}},steps={{kind="NO_ACTIVITY",alias="a"},{kind="NO_ACTIVITY",alias="a"}},expected={},provenance={}}) end)
end)

test("Governing Basis preserves intent through non-terminal evidence",function()
    local runtime=newDecisionRuntime()
    local admitted=runtime.commitmentAdmission:admit({objective={kind="x"},governingBasis={responsibilityKey="basis-continuity"}})
    for _,kind in ipairs({"BLOCKED","OUTTAMYWAY_HOLD","TEMPORARY_INACTIVITY","MISSING_EVIDENCE","INTENT_EXPIRY"}) do
        local verdict=runtime.governingBasisEvaluator:evaluate(admitted.commitment,{kind=kind,evidence={},provenance={}})
        equal(verdict.invalidated,false)
        equal(runtime.commitments:get(admitted.commitment.identity).state,"ACTIVE")
    end
end)

test("Commitment admission rejects duplicate unresolved responsibility",function()
    local runtime=newDecisionRuntime()
    runtime.commitmentAdmission:admit({objective={kind="a"},governingBasis={responsibilityKey="same"}})
    expectError(function() runtime.commitmentAdmission:admit({objective={kind="b"},governingBasis={responsibilityKey="same"}}) end)
    equal(#runtime.commitments:list(),1)
end)

test("Terminal Settlement releases authority but retains obligations",function()
    local runtime=newDecisionRuntime()
    local admitted=runtime.commitmentAdmission:admit({objective={kind="x"},governingBasis={responsibilityKey="settle"},progressAssemblyIds={"AS-X"},obligationSpecifications={{origin={},basis={},requiredOutcome={},evidenceContract={},ownershipClass="ORIGIN_BOUND"}}})
    local verdict=runtime.governingBasisEvaluator:evaluate(admitted.commitment,{kind="PLAYER_TAKEOVER",evidence={},provenance={}})
    local result=runtime.terminalSettlementEvaluator:enterSettling(admitted.commitment.identity,verdict)
    equal(result.commitment.state,"SETTLING"); equal(#result.releasedAuthorityTokenIds,1); equal(#runtime.obligations:openForOwner(admitted.commitment.identity),1)
end)

test("historical replay corpus passes deterministically",function()
    equal(#fixtureModule.fixtures,10)
    local first={}
    for index,fixture in ipairs(fixtureModule.fixtures) do
        local runtime=newDecisionRuntime(); local result=runtime:runReplay(fixture)
        equal(result.conformance,"PASS","replay failed " .. fixture.identity .. ": " .. tostring(result.earliestDivergence and result.earliestDivergence.reason))
        first[index]=OuttaMyWay.ValueRecord.canonical(result)
    end
    for index,fixture in ipairs(fixtureModule.fixtures) do
        local runtime=newDecisionRuntime(); local result=runtime:runReplay(fixture)
        equal(OuttaMyWay.ValueRecord.canonical(result),first[index],"non-deterministic replay " .. fixture.identity)
    end
end)

test("replay reports earliest divergence",function()
    local fixture=OuttaMyWay.ReplayFixture.new({identity="RF-DIVERGENCE",title="divergence",sourceEvidence={{source="test"}},steps={{kind="NO_ACTIVITY",expect={activityCount=1}},{kind="NO_ACTIVITY",expect={activityCount=0}}},expected={},provenance={}})
    local result=newDecisionRuntime():runReplay(fixture)
    equal(result.conformance,"FAIL"); equal(result.earliestDivergence.step,1); equal(#result.stepResults,1)
end)



test("physical CREATE requires explicit progress-actuation ownership",function()
    local move=candidateSpec("physical-create","REPOSITION",1)
    move.evidenceBasis.governingBasis={responsibilityKey="physical-create"}
    move.representationFitness={requirements={{representationId="REP-A",acceptedStates={"CURRENTLY_FIT"}}}}
    move.evidenceBasis.effectiveActuationComposition={identity="EC-PHYSICAL",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="PROPOSED",capability="REPOSITION",effectClass="MOVEMENT",progressActuation=true}}}
    local picture=decisionPicture({move},{representationFitness={{representationId="REP-A",assemblyId="AS-00001",question="REPOSITION",assessmentHorizon=5,state="CURRENTLY_FIT",claimPermissions={"REPOSITION"},coverage={complete=true,conservative=true},uncertainty={},validityDependencies={},provenance={}}}})
    local runtime=newDecisionRuntime(); local result=runtime:evaluateSealedOperationalPicture(picture)
    equal(result.decision.commitmentAction,"CREATE")
    expectError(function() runtime.decisionCommitmentBoundary:apply(picture,result) end)
    equal(#runtime.commitments:list(),0)
end)


test("v4.7.48 physical CREATE rejects ownership/composition disagreement",function()
    local move=candidateSpec("physical-mismatch","REPOSITION",1)
    move.evidenceBasis.governingBasis={responsibilityKey="physical-mismatch"}
    move.evidenceBasis.progressActuationOwnership={assemblyIds={"AS-00001"}}
    move.evidenceBasis.effectiveActuationComposition={identity="EC-MISMATCH",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00002",commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="MOVEMENT",progressActuation=true}}}
    local picture=decisionPicture({move})
    local runtime=newDecisionRuntime(); local result=runtime:evaluateSealedOperationalPicture(picture)
    expectError(function() runtime.decisionCommitmentBoundary:_admitFromCandidate(picture,result.decision,result.candidates[1]) end)
    equal(#runtime.commitments:list(),0)
end)

test("v4.7.47 CREATE boundary rebinds proposed composition to admitted Commitment",function()
    local move=candidateSpec("live-create","REPOSITION",1)
    move.evidenceBasis.governingBasis={responsibilityKey="live-create"}
    move.evidenceBasis.progressActuationOwnership={assemblyIds={"AS-00001"}}
    move.evidenceBasis.effectiveActuationComposition={identity="EC-LIVE-CREATE",epoch=1,relevantAssemblyIds={"AS-00001","AS-00002"},entries={{assemblyId="AS-00001",commitmentId="$NEW_COMMITMENT",capability="REPOSITION",effectClass="MOVEMENT",progressActuation=true}}}
    move.obligationsCreated={
        {origin={kind="OTM_DISPLACEMENT"},basis={decision="D-0122"},requiredOutcome={kind="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED"},evidenceContract={kind="POSITIVE_GIANTS_REACQUISITION"},ownershipClass="ORIGIN_BOUND"},
        {origin={kind="TRAFFIC_INTERVENTION"},basis={decision="D-0119"},requiredOutcome={kind="DURABLE_SEPARATION_SUPPORTED"},evidenceContract={kind="CONTINUATION_AWARE_TRAFFIC_SETTLEMENT_NO_FIXED_DISTANCE_OR_TIME"},ownershipClass="CONTINUITY"}
    }
    local runtime=newDecisionRuntime(); local picture=decisionPicture({move})
    local result=runtime:evaluateSealedOperationalPicture(picture)
    local admitted=runtime.decisionCommitmentBoundary:_admitFromCandidate(picture,result.decision,result.candidates[1])
    local commitment=runtime.commitments:get(admitted.commitment.identity)
    equal(commitment.state,"ACTIVE")
    equal(#runtime.obligations:openForOwner(commitment.identity),2)
    equal(#runtime.authorities:tokensForCommitment(commitment.identity),1)
    if commitment.effectiveActuationCompositionId==nil then error("composition id not rebound onto Commitment") end
end)


test("v4.7.47 failed actuator start releases progress authority but retains responsibility",function()
    local runtime=newDecisionRuntime()
    local admitted=runtime.commitmentAdmission:admit({
        objective={kind="TRAFFIC_RESOLUTION"},governingBasis={responsibilityKey="start-failure"},progressAssemblyIds={"AS-YIELD"},
        obligationSpecifications={{origin={kind="OTM_DISPLACEMENT"},basis={decision="D-0122"},requiredOutcome={kind="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED"},evidenceContract={kind="POSITIVE_GIANTS_REACQUISITION"},ownershipClass="ORIGIN_BOUND"}}
    })
    local result,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.markActuationStartFailed(runtime,admitted.commitment.identity,{reason="FIXTURE_REFUSED"})
    equal(reason,nil); equal(result.commitment.state,"WAITING_FOR_EVIDENCE")
    equal(#result.remainingObligations,1); equal(#runtime.authorities:tokensForCommitment(admitted.commitment.identity),0)
end)

test("v4.7.47 Native reacquisition settles recovery only and keeps traffic responsibility",function()
    local runtime=newDecisionRuntime()
    local admitted=runtime.commitmentAdmission:admit({
        objective={kind="TRAFFIC_RESOLUTION"},governingBasis={responsibilityKey="recovery-continuity"},progressAssemblyIds={"AS-YIELD"},
        obligationSpecifications={
            {origin={kind="OTM_DISPLACEMENT"},basis={decision="D-0122"},requiredOutcome={kind="NATIVE_CONTINUATION_RESTORED_AND_GIANTS_REACQUIRED"},evidenceContract={kind="POSITIVE_GIANTS_REACQUISITION"},ownershipClass="ORIGIN_BOUND"},
            {origin={kind="TRAFFIC_INTERVENTION"},basis={decision="D-0119"},requiredOutcome={kind="DURABLE_SEPARATION_SUPPORTED"},evidenceContract={kind="CONTINUATION_AWARE_TRAFFIC_SETTLEMENT_NO_FIXED_DISTANCE_OR_TIME"},ownershipClass="CONTINUITY"}
        }
    })
    local result,reason=OuttaMyWay.LiveTrafficCommitmentLifecycle.markNativeReacquisition(runtime,admitted.commitment.identity,{kind="POSITIVE_GIANTS_REACQUISITION"})
    equal(reason,nil); equal(result.commitment.state,"WAITING_FOR_EVIDENCE")
    equal(#result.settledObligationIds,1); equal(#result.remainingObligations,1)
    equal(result.remainingObligations[1].requiredOutcome.kind,"DURABLE_SEPARATION_SUPPORTED")
    equal(#runtime.authorities:tokensForCommitment(admitted.commitment.identity),0)
end)

test("v4.7.47 recovery admission distinguishes refuge wait from Guarded Recovery start",function()
    equal(OuttaMyWay.Prototype22TS015Relocation.recoveryAdmissionActionFromSignal({status="POSITIVE"}),"WAIT_AT_REFUGE")
    equal(OuttaMyWay.Prototype22TS015Relocation.recoveryAdmissionActionFromSignal({status="NEGATIVE"}),"BEGIN_GUARDED_RECOVERY")
    equal(OuttaMyWay.Prototype22TS015Relocation.recoveryAdmissionActionFromSignal({status="UNRESOLVED"}),"WAIT_FOR_EVIDENCE")
    equal(OuttaMyWay.Prototype22TS015Relocation.recoveryAdmissionActionFromSignal({status="INVALIDATED"}),"FAIL_CONTEXT")
end)

test("SETTLING Commitment rejects maintain or revise strategy",function()
    local runtime=newDecisionRuntime()
    local admitted=runtime.commitmentAdmission:admit({objective={kind="x"},governingBasis={responsibilityKey="settling-no-progress"}})
    local verdict=runtime.governingBasisEvaluator:evaluate(admitted.commitment,{kind="OBJECTIVE_FAILED",evidence={},provenance={}})
    runtime.terminalSettlementEvaluator:enterSettling(admitted.commitment.identity,verdict)
    local keep=candidateSpec("keep","CONTINUE_UNCHANGED",1)
    local picture=decisionPicture({keep},{commitmentContext={{commitmentId=admitted.commitment.identity}}})
    local result=runtime:evaluateSealedOperationalPicture(picture)
    equal(result.decision.commitmentAction,"MAINTAIN")
    expectError(function() runtime.decisionCommitmentBoundary:apply(picture,result) end)
end)

test("SETTLE directive cannot contradict canonical Governing Basis event",function()
    local runtime=newDecisionRuntime()
    local admitted=runtime.commitmentAdmission:admit({objective={kind="x"},governingBasis={responsibilityKey="settle-mapping"}})
    local failed=candidateSpec("failed","CONTINUE_UNCHANGED",1)
    failed.evidenceBasis.constraintEvidence.CONTINUING_INTENT_PRIORITY.result="FAIL"
    local picture=decisionPicture({failed},{commitmentContext={{commitmentId=admitted.commitment.identity,settlementDirective={eventKind="OBJECTIVE_SATISFIED",intendedTerminalDisposition="FAILED",terminalCause="OBJECTIVE_FAILED"}}}})
    local result=runtime:evaluateSealedOperationalPicture(picture)
    equal(result.decision.commitmentAction,"SETTLE")
    expectError(function() runtime.decisionCommitmentBoundary:apply(picture,result) end)
    equal(runtime.commitments:get(admitted.commitment.identity).state,"ACTIVE")
end)



test("PassiveLiveTraceRecord rejects enabled Control",function()
    expectError(function() OuttaMyWay.PassiveLiveTraceRecord.new({identity="LT-X",epoch=1,timestamp=1,status="TRACE",activeAssemblyCount=0,activeJobEpisodeCount=0,activeOperationCount=0,situationCount=0,encounterCount=0,controlAuthorityEnabled=true,provenance={}}) end)
end)


local function withFakeLiveGlobals(fn)
    local oldTranslation,oldDirection=getWorldTranslation,localDirectionToWorld
    local oldFieldManager,oldFarmlandManager=g_fieldManager,g_farmlandManager
    local oldFieldCourseSettings,oldFieldCourseField=FieldCourseSettings,FieldCourseField
    local positions={[101]={0,0,0},[201]={0,0,20}}
    local directions={[101]={0,1},[201]={0,1}}
    getWorldTranslation=function(node) local p=positions[node]; return p[1],p[2],p[3] end
    localDirectionToWorld=function(node,x,y,z) local d=directions[node] or {0,1}; return d[1],0,d[2] end
    local field={id=77,getId=function(self) return self.id end,getPolygonPoints=function() return {{x=-10,z=-10},{x=10,z=-10},{x=10,z=30},{x=-10,z=30}} end}
    local farmland={id=77}
    local farmlandManager={getFarmlandAtWorldPosition=function(self,x,z) return farmland end}
    local fieldManager={farmlandIdFieldMapping={[77]=field},fields={field}}
    g_fieldManager,g_farmlandManager=fieldManager,farmlandManager
    FieldCourseSettings={generate=function(vehicle) return {} end}
    FieldCourseField={generateAtPosition=function(x,z,settings,callback)
        return {update=function(self,dt,budget) callback({fieldRootBoundary={boundaryLine={{x=-10,z=-10},{x=10,z=-10},{x=10,z=30},{x=-10,z=30}}},islands={}},true); return false end}
    end}
    local function job(id,x,z)
        local parameter={getPosition=function() return x,z end}
        return {jobId=id,currentTaskIndex=2,helperIndex=id,positionAngleParameter=parameter}
    end
    local jobA,jobB=job(1001,0,0),job(1002,0,20)
    local a={rootNode=101,sizeWidth=3,sizeLength=7,lastSpeedReal=0.003,spec_aiFieldWorker={isActive=true,isBlocked=false,fieldJob=jobA},spec_aiJobVehicle={job=jobA,lastJob=jobA},getIsAIActive=function(self) return self.spec_aiFieldWorker.isActive end,getIsFieldWorkActive=function(self) return self.spec_aiFieldWorker.isActive end,getAISteeringNode=function(self) return self.rootNode end,getRootVehicle=function(self) return self end,getName=function() return "A" end}
    local b={rootNode=201,sizeWidth=3,sizeLength=7,lastSpeedReal=0.002,spec_aiFieldWorker={isActive=true,isBlocked=false,fieldJob=jobB},spec_aiJobVehicle={job=jobB,lastJob=jobB},getIsAIActive=function(self) return self.spec_aiFieldWorker.isActive end,getIsFieldWorkActive=function(self) return self.spec_aiFieldWorker.isActive end,getAISteeringNode=function(self) return self.rootNode end,getRootVehicle=function(self) return self end,getName=function() return "B" end}
    local mission={vehicles={a,b},controlledVehicle=nil,fieldManager=fieldManager,farmlandManager=farmlandManager,aiSystem={activeJobVehicles={a,b},activeJobs={jobA,jobB}}}
    local ok,result=pcall(fn,mission,a,b,positions,jobA,jobB,field,farmland,directions)
    getWorldTranslation,localDirectionToWorld=oldTranslation,oldDirection
    g_fieldManager,g_farmlandManager=oldFieldManager,oldFarmlandManager
    FieldCourseSettings,FieldCourseField=oldFieldCourseSettings,oldFieldCourseField
    if not ok then error(result,0) end
    return result
end

local function setActiveVehicles(mission,...)
    mission.aiSystem.activeJobVehicles={...}
end

test("live source admits GIANTS Job identities from activeJobVehicles",function()
    withFakeLiveGlobals(function(mission,a,b)
        local registry=OuttaMyWay.FieldWorldSnapshotRegistry.new(); local ids=OuttaMyWay.IdentityRegistry.new(); local evaluator=OuttaMyWay.FieldWorldEquivalenceEvaluator.new(); local authority=OuttaMyWay.FieldWorldEquivalenceAuthority.new(ids,evaluator); local source=OuttaMyWay.LiveObservationSource.new(registry,authority); local observations=source:capture(mission,10)
        equal(#observations,1); equal(#observations[1].assemblies,2); equal(#observations[1].jobEpisodeEvidence,2)
        if not string.find(observations[1].fieldWorld.referenceKey,"field-world:equivalence:FWE1:",1,true) then error("equivalence Field World identity missing") end
        equal(observations[1].fieldWorld.operationMembershipEvidenceComplete,true)
        local tokens={}
        for _,evidence in ipairs(observations[1].jobEpisodeEvidence) do
            tokens[evidence.sourceJobToken]=true
            equal(evidence.jobPresent,true); equal(evidence.aiControlled,true)
            equal(evidence.provenance.activeJobVehicleMembership,true)
        end
        equal(tokens["giants-ai-job-id:1001"],true); equal(tokens["giants-ai-job-id:1002"],true)
        equal(#observations[1].unavailableSources,0)
    end)
end)


test("interaction diagnostics publish current pair state without future prediction",function()
    local diagnostics=OuttaMyWay.LiveInteractionDiagnostics
    local a={pose={x=0,z=0,dx=0,dz=1},speedMps=3,radius=nil}
    local b={pose={x=0,z=20,dx=0,dz=-1},speedMps=3,radius=4}
    local missing=diagnostics.observePairState(a,b)
    equal(missing.principalOutcome,"MISSING_SUBJECT_RADIUS"); equal(missing.interactionEvidenceEmitted,false)
    a.radius=4
    local separated=diagnostics.observePairState(a,b)
    equal(separated.principalOutcome,"CURRENT_INTERACTION_UNRESOLVED"); equal(separated.current,false); equal(separated.interactionEvidenceEmitted,false)
    if separated.closingRate<=0 then error("present-state closing rate was not preserved") end
    b.pose.z=4
    local current=diagnostics.observePairState(a,b)
    equal(current.principalOutcome,"CURRENT_INTERACTION_QUALIFIED"); equal(current.current,true); equal(current.interactionEvidenceEmitted,true)
end)

test("position-derived motion diagnostics separate forward reverse turning and stationary evidence",function()
    local diagnostics=OuttaMyWay.LiveInteractionDiagnostics
    local previous={x=0,z=0,dx=0,dz=1}
    local forward=diagnostics.deriveMotion(previous,{x=0,z=2,dx=0,dz=1},0,1,2)
    equal(forward.classification,"STABLE_FORWARD")
    local reverse=diagnostics.deriveMotion(previous,{x=0,z=-2,dx=0,dz=1},0,1,2)
    equal(reverse.classification,"REVERSING_OR_OPPOSED_TRAVEL")
    local turning=diagnostics.deriveMotion(previous,{x=2,z=0,dx=1,dz=0},0,1,2)
    equal(turning.classification,"TURNING")
    local stationary=diagnostics.deriveMotion(previous,{x=0,z=0,dx=0,dz=1},0,1,0)
    equal(stationary.classification,"STATIONARY")
end)

test("live source enumerates every unique unordered pair for three workers",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA,jobB,field,farmland,directions)
        positions[301]={10,0,10}; directions[301]={1,0}
        local parameter={getPosition=function() return 10,10 end}
        local jobC={jobId=1003,currentTaskIndex=2,helperIndex=1003,positionAngleParameter=parameter}
        local c={rootNode=301,sizeWidth=4,sizeLength=8,lastSpeedReal=0.001,spec_aiFieldWorker={isActive=true,isBlocked=false,fieldJob=jobC},spec_aiJobVehicle={job=jobC,lastJob=jobC},getIsAIActive=function(self) return true end,getIsFieldWorkActive=function(self) return true end,getAISteeringNode=function(self) return self.rootNode end,getRootVehicle=function(self) return self end,getName=function() return "C" end}
        mission.vehicles={a,b,c}; mission.aiSystem.activeJobVehicles={a,b,c}; mission.aiSystem.activeJobs={jobA,jobB,jobC}
        local registry=OuttaMyWay.FieldWorldSnapshotRegistry.new(); local ids=OuttaMyWay.IdentityRegistry.new(); local evaluator=OuttaMyWay.FieldWorldEquivalenceEvaluator.new(); local authority=OuttaMyWay.FieldWorldEquivalenceAuthority.new(ids,evaluator); local source=OuttaMyWay.LiveObservationSource.new(registry,authority)
        local raw=source:capture(mission,10)[1]
        equal(raw.diagnostics.sourceCounters.mathematicallyPossiblePairCount,3)
        equal(raw.diagnostics.sourceCounters.relevantPairCount,3)
        equal(#raw.diagnostics.pairDiagnostics,3)
        local seen={}
        for _,pair in ipairs(raw.diagnostics.pairDiagnostics) do
            if seen[pair.pairReferenceKey] then error("duplicate unordered pair diagnostic") end
            seen[pair.pairReferenceKey]=true
        end
    end)
end)

test("missing radius suppression survives the source-to-assessment diagnostic handoff",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA,jobB,field,farmland,directions)
        directions[201]={0,-1}; b.sizeWidth=nil
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        equal(#raw.diagnostics.pairDiagnostics,1)
        equal(raw.diagnostics.pairDiagnostics[1].principalOutcome,"MISSING_OTHER_RADIUS")
        equal(raw.diagnostics.pairDiagnostics[1].interactionEvidenceEmitted,false)
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.picture.encounters,0)
        equal(processed.picture.diagnostics.counters.interactionEvidenceEmittedCount,0)
        equal(processed.picture.diagnostics.counters.interactionEvidenceReceivedCount,0)
        equal(processed.picture.diagnostics.pairPipeline[1].sameOperation,true)
    end)
end)

test("closing motion alone cannot admit Encounter without supported Future Space",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA,jobB,field,farmland,directions)
        directions[201]={0,-1}; a.lastSpeedReal=0.003; b.lastSpeedReal=0.003
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        local pair=raw.diagnostics.pairDiagnostics[1]
        equal(pair.principalOutcome,"CURRENT_INTERACTION_UNRESOLVED")
        if pair.closingRate<=0 then error("closing motion evidence was not preserved") end
        equal(pair.fieldBoundedFutureSpacePositive,false)
        equal(pair.interactionEvidenceEmitted,false)
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.picture.encounters,0)
        equal(processed.picture.diagnostics.counters.interactionEvidenceEmittedCount,0)
        equal(processed.picture.diagnostics.counters.interactionEvidenceReceivedCount,0)
        equal(processed.picture.diagnostics.pairPipeline[1].encounterCreated,false)
    end)
end)

test("active Job vehicle pose failure is explicit without changing admission",function()
    withFakeLiveGlobals(function(mission,a,b,positions)
        mission.vehicles={a}; setActiveVehicles(mission,a); positions[101]=nil
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        local diagnostics=runtime.liveObservationSource:getLastDiagnostics()
        equal(#diagnostics.contradictions,1)
        equal(diagnostics.contradictions[1].code,"ACTIVE_JOB_VEHICLE_WITHOUT_POSE")
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.jobEpisodes.activeEpisodeIds,0)
        equal(#processed.operation.activeOperationIds,0)
    end)
end)

test("mutually blocked same-Operation pair without Encounter is an explicit diagnostic contradiction",function()
    withFakeLiveGlobals(function(mission,a,b)
        a.spec_aiFieldWorker.isBlocked=true; b.spec_aiFieldWorker.isBlocked=true
        a.lastSpeedReal=0; b.lastSpeedReal=0
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.picture.encounters,0)
        local found=false
        for _,item in OuttaMyWay.ValueRecord.ipairs(processed.picture.diagnostics.contradictions) do if item.code=="BOTH_WORKERS_BLOCKED_WITHOUT_ENCOUNTER" then found=true end end
        equal(found,true)
    end)
end)

test("player presence in an AI-active vehicle does not imply player Control",function()
    withFakeLiveGlobals(function(mission,a,b)
        mission.vehicles={a}; setActiveVehicles(mission,a); mission.controlledVehicle=a
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        equal(raw.playerControl["vehicle-root:101"].playerPresent,true)
        equal(raw.playerControl["vehicle-root:101"].playerControlled,false)
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.jobEpisodes.activeEpisodeIds,1)
    end)
end)

test("activeJobVehicles membership is authoritative over false corroborating methods",function()
    withFakeLiveGlobals(function(mission,a,b)
        a.spec_aiFieldWorker.isActive=false; b.spec_aiFieldWorker.isActive=false
        a.getIsAIActive=function() return false end; b.getIsAIActive=function() return false end
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.jobEpisodes.activeEpisodeIds,2); equal(#processed.operation.activeOperationIds,1); equal(#processed.picture.situations,1)
    end)
end)

test("active Job Episodes with unresolved field identity wait rather than exhaust supportable space",function()
    withFakeLiveGlobals(function(mission,a,b)
        FieldCourseSettings=nil; FieldCourseField=nil
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raws=runtime.liveObservationSource:capture(mission,10)
        equal(#raws,2)
        local processed=nil
        for _,raw in ipairs(raws) do
            if not string.find(raw.fieldWorld.referenceKey,"field-world:unresolved:",1,true) then error("unresolved Field World did not remain isolated by Job Episode") end
            equal(raw.fieldWorld.operationMembershipEvidenceComplete,false)
            processed=runtime:processSealedObservation(raw)
            equal(OuttaMyWay.ValueRecord.length(processed.operation.activeOperationIds),0)
        end
        equal(OuttaMyWay.ValueRecord.length(processed.jobEpisodes.activeEpisodeIds),2)
        local supported=runtime.passiveCandidateSupport:attach(processed.picture,processed.snapshot)
        local evaluated=runtime:evaluateSealedOperationalPicture(supported)
        equal(evaluated.decision.commitmentAction,"WAIT")
        equal(evaluated.decision.nonIntervention.classification,"CONTINUE_OBSERVATION")
        if evaluated.decision.nonIntervention.classification=="COMPLETE_SUPPORTABLE_SPACE_EXHAUSTED" then
            error("unresolved field identity falsely exhausted supportable space")
        end
        equal(runtime:getStatus().controlAuthorityEnabled,false)
    end)
end)

test("inactive assembly without terminal cause preserves episode and unresolved Operation",function()
    withFakeLiveGlobals(function(mission,a,b)
        mission.vehicles={a}; setActiveVehicles(mission,a)
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local first=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,10)[1])
        equal(#first.jobEpisodes.activeEpisodeIds,1); equal(#first.operation.activeOperationIds,1)
        setActiveVehicles(mission); a.spec_aiFieldWorker.isActive=false; a.spec_aiJobVehicle.job=nil; a.spec_aiFieldWorker.fieldJob=nil
        local secondRaw=runtime.liveObservationSource:capture(mission,11)[1]
        equal(secondRaw.fieldWorld.operationMembershipEvidenceComplete,false)
        local gap=false; for _,item in ipairs(secondRaw.unavailableSources) do if item.source=="JOB_EPISODE_TERMINATION_CAUSE" then gap=true end end
        if not gap then error("termination-cause gap was not published") end
        local second=runtime:processSealedObservation(secondRaw)
        equal(#second.jobEpisodes.activeEpisodeIds,1); equal(#second.operation.activeOperationIds,1)
        local supported=runtime.passiveCandidateSupport:attach(second.picture,second.snapshot)
        local evaluated=runtime:evaluateSealedOperationalPicture(supported)
        equal(evaluated.decision.commitmentAction,"WAIT"); equal(evaluated.decision.nonIntervention.classification,"CONTINUE_OBSERVATION")
    end)
end)

test("lastJob transition provides source-intent termination without guessing manual stop versus GIANTS termination",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA)
        mission.vehicles={a}; setActiveVehicles(mission,a); mission.aiSystem.activeJobs={jobA}
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local first=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,10)[1])
        equal(#first.jobEpisodes.activeEpisodeIds,1); equal(#first.operation.activeOperationIds,1)
        setActiveVehicles(mission); mission.aiSystem.activeJobs={}
        a.spec_aiFieldWorker.isActive=false; a.spec_aiJobVehicle.job=nil; a.spec_aiFieldWorker.fieldJob=jobA; a.spec_aiJobVehicle.lastJob=jobA
        local second=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,11)[1])
        equal(#second.jobEpisodes.activeEpisodeIds,0); equal(#second.jobEpisodes.endedEpisodeIds,1)
        equal(runtime.jobEpisodes:get(first.jobEpisodes.activeEpisodeIds[1]).terminalCause,"SOURCE_INTENT_TERMINATION")
        equal(#second.operation.activeOperationIds,0); equal(#second.operation.endedOperationIds,1)
    end)
end)

test("restarted same source token captures a fresh immutable Field World Snapshot",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA)
        mission.vehicles={a}; setActiveVehicles(mission,a); mission.aiSystem.activeJobs={jobA}
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local first=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,10)[1])
        local firstEpisode=first.jobEpisodes.activeEpisodeIds[1]
        setActiveVehicles(mission); mission.aiSystem.activeJobs={}
        a.spec_aiFieldWorker.isActive=false; a.spec_aiJobVehicle.job=nil; a.spec_aiFieldWorker.fieldJob=jobA; a.spec_aiJobVehicle.lastJob=jobA
        runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,11)[1])
        a.spec_aiFieldWorker.isActive=true; a.spec_aiJobVehicle.job=jobA; a.spec_aiFieldWorker.fieldJob=jobA
        setActiveVehicles(mission,a); mission.aiSystem.activeJobs={jobA}
        local restarted=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,12)[1])
        local secondEpisode=restarted.jobEpisodes.activeEpisodeIds[1]
        if secondEpisode==firstEpisode then error("restart reused Job Episode identity") end
        equal(runtime.fieldWorldSnapshots:getRecordCount(),2)
        equal(runtime.jobEpisodes:get(firstEpisode).fieldWorldReferenceKey,runtime.jobEpisodes:get(secondEpisode).fieldWorldReferenceKey)
    end)
end)

test("player takeover supplies genuine Job Episode termination evidence",function()
    withFakeLiveGlobals(function(mission,a,b)
        mission.vehicles={a}; setActiveVehicles(mission,a)
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local first=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,10)[1])
        equal(#first.jobEpisodes.activeEpisodeIds,1)
        setActiveVehicles(mission); a.spec_aiFieldWorker.isActive=false; a.spec_aiJobVehicle.job=nil; a.spec_aiFieldWorker.fieldJob=nil; mission.controlledVehicle=a
        local second=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,11)[1])
        equal(#second.jobEpisodes.activeEpisodeIds,0); equal(#second.jobEpisodes.endedEpisodeIds,1)
        equal(runtime.jobEpisodes:get(first.jobEpisodes.activeEpisodeIds[1]).terminalCause,"PLAYER_TAKEOVER")
        equal(#second.operation.activeOperationIds,0)
    end)
end)

test("native job replacement receives a new Job Episode identity",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA)
        mission.vehicles={a}; setActiveVehicles(mission,a); mission.aiSystem.activeJobs={jobA}
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local first=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,10)[1])
        local firstId=first.jobEpisodes.activeEpisodeIds[1]
        local nextJob={jobId=2001,currentTaskIndex=2,positionAngleParameter={getPosition=function() return 0,0 end}}
        a.spec_aiJobVehicle.job=nextJob; a.spec_aiFieldWorker.fieldJob=nextJob; mission.aiSystem.activeJobs={nextJob}
        local second=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,11)[1])
        equal(#second.jobEpisodes.endedEpisodeIds,1); equal(#second.jobEpisodes.admittedEpisodeIds,1)
        if second.jobEpisodes.activeEpisodeIds[1]==firstId then error("replacement reused Job Episode identity") end
        equal(runtime.jobEpisodes:get(firstId).terminalCause,"REPLACED")
    end)
end)

test("blocked active worker preserves the same Job Episode",function()
    withFakeLiveGlobals(function(mission,a,b)
        mission.vehicles={a}; setActiveVehicles(mission,a)
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local first=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,10)[1])
        local firstId=first.jobEpisodes.activeEpisodeIds[1]
        a.spec_aiFieldWorker.isBlocked=true; a.lastSpeedReal=0
        local second=runtime:processSealedObservation(runtime.liveObservationSource:capture(mission,11)[1])
        equal(#second.jobEpisodes.activeEpisodeIds,1); equal(second.jobEpisodes.activeEpisodeIds[1],firstId)
        equal(second.snapshot.jobEpisodeEvidence[1].blocked,true)
    end)
end)

test("field resolver uses exact source-field polygons while retaining farmland as context",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA,jobB,field,farmland)
        local result=OuttaMyWay.LiveAIJobEvidence.resolveField(mission,{x=0,z=0},jobA)
        equal(result.resolved,true); equal(result.sourceFieldId,77)
        equal(result.current.source,"fieldManager.fields+field.getPolygonPoints")
        equal(result.current.farmlandId,77); equal(result.current.contextualMappedFieldId,77)
        equal(result.source,"CURRENT_POSITION_SOURCE_FIELD_POLYGON")
    end)
end)

test("farmland mapping cannot establish field identity outside a source-field polygon",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA)
        local result=OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(mission,1000,1000)
        equal(result.resolved,false); equal(result.fieldId,0)
        equal(result.contextualMappedFieldId,77)
        equal(result.reason,"NO_FIELD_POLYGON_MATCH")
    end)
end)

test("different source field labels require derived Field World evidence",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA)
        local otherField={id=68,getId=function(self) return self.id end,getPolygonPoints=function() return {{x=-10,z=80},{x=10,z=80},{x=10,z=120},{x=-10,z=120}} end}
        mission.fieldManager.fields={mission.fieldManager.fields[1],otherField}
        jobA.positionAngleParameter.getPosition=function() return 0,100 end
        local result=OuttaMyWay.LiveAIJobEvidence.resolveField(mission,{x=0,z=0},jobA)
        equal(result.resolved,false); equal(result.conflict,true); equal(result.derivedFieldWorldRequired,true)
        equal(result.reason,"SOURCE_FIELD_LABELS_DIFFER_DERIVED_FIELD_WORLD_REQUIRED")
    end)
end)

test("passive support publishes only one non-actuating complete candidate",function()
    local runtime=newPictureRuntime(); local processed=runtime:processSealedObservation(pictureFixture(1))
    local supported=runtime.passiveCandidateSupport:attach(processed.picture,processed.snapshot)
    equal(supported.candidateSupportEvidence.complete,true)
    equal(#supported.candidateSupportEvidence.candidateSpecifications,1)
    local capability=supported.candidateSupportEvidence.candidateSpecifications[1].capability
    if capability~="CONTINUE_OBSERVATION" and capability~="CONTINUE_UNCHANGED" then error("passive support emitted actuation") end
    equal(supported.candidateSupportEvidence.supportBoundary.controlAuthority,false)
end)

test("passive validator publishes admitted episodes Operation and candidate diagnostics",function()
    withFakeLiveGlobals(function(mission)
        local oldMission,oldServer,oldClient,oldTime=g_currentMission,g_server,g_client,g_time
        g_currentMission,g_server,g_client,g_time=mission,{},nil,1000
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize(); runtime.passiveLiveValidator:loadMap()
        local coordinator=OuttaMyWay.LiveRuntimeCoordinator.new(runtime,runtime.liveObservationSource,runtime.targetedFieldIdentityProbe,runtime.fieldWorldSnapshots,runtime.passiveLiveValidator)
        runtime.liveRuntimeCoordinator=coordinator; coordinator:loadMap(); coordinator:update(1000)
        local record=runtime.passiveLiveValidator:getRecords()[1]
        if record==nil then error("runtime-owned coordinator did not publish diagnostic record") end
        equal(record.generalControlAuthorityEnabled,false); equal(record.activeAssemblyCount,2); equal(record.activeJobEpisodeCount,2); equal(record.activeOperationCount,1); equal(record.globalActiveOperationCount,1)
        equal(record.candidateCount,1); equal(record.allPassCandidateCount,1); equal(record.unresolvedCandidateCount,0); equal(record.failedCandidateCount,0)
        equal(record.selectedCapability,"CONTINUE_OBSERVATION"); equal(record.nonIntervention.classification,"CONTINUE_OBSERVATION")
        equal(#runtime.commitments:list(),0); equal(runtime.decisionCommitmentBoundary:getPublishedCount(),0)
        equal(coordinator:getCycleCount(),1)
        g_currentMission,g_server,g_client,g_time=oldMission,oldServer,oldClient,oldTime
    end)
end)


test("passive live source and reasoning are deterministic from fresh state",function()
    withFakeLiveGlobals(function(mission)
        local function run()
            local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
            local raw=runtime.liveObservationSource:capture(mission,10)[1]
            local processed=runtime:processSealedObservation(raw)
            local supported=runtime.passiveCandidateSupport:attach(processed.picture,processed.snapshot)
            local evaluated=runtime:evaluateSealedOperationalPicture(supported)
            return OuttaMyWay.ValueRecord.canonical(evaluated.decision)
        end
        equal(run(),run())
    end)
end)

test("Field World fingerprint is invariant to ring start winding and sub-quantum jitter",function()
    local a={{x=0,z=0},{x=40,z=0},{x=40,z=20},{x=0,z=20}}
    local b={{x=40.02,z=20.01},{x=40.01,z=0.02},{x=0.01,z=-0.01},{x=-0.02,z=20.01}}
    local fa=OuttaMyWay.FieldWorldSnapshotRegistry.fingerprintGeometry(a,{},0.1)
    local fb=OuttaMyWay.FieldWorldSnapshotRegistry.fingerprintGeometry(b,{},0.1)
    equal(fa,fb)
end)

test("different split polygons receive different Field World fingerprints",function()
    local upper={{x=-15.2,z=-408.2},{x=229.2,z=-408.2},{x=229.2,z=-206.8},{x=-15.2,z=-206.8}}
    local lower={{x=-40.8,z=-701.2},{x=191.8,z=-701.2},{x=191.8,z=-407.8},{x=-40.8,z=-407.8}}
    local a=OuttaMyWay.FieldWorldSnapshotRegistry.fingerprintGeometry(upper,{},0.1)
    local b=OuttaMyWay.FieldWorldSnapshotRegistry.fingerprintGeometry(lower,{},0.1)
    if a==b then error("split Field Worlds shared a fingerprint") end
end)

test("merged and split concurrent workers form three geometry Operations",function()
    withFakeLiveGlobals(function(mission,a,b,positions)
        local oldGenerator=FieldCourseField
        local function makeVehicle(root,id,x,z,name)
            positions[root]={x,0,z}
            local job={jobId=id,currentTaskIndex=2,positionAngleParameter={getPosition=function() return x,z end}}
            local vehicle={rootNode=root,sizeWidth=3,sizeLength=7,lastSpeedReal=0.003,spec_aiFieldWorker={isActive=true,isBlocked=false,fieldJob=job},spec_aiJobVehicle={job=job,lastJob=job},getIsAIActive=function(self) return self.spec_aiFieldWorker.isActive end,getIsFieldWorkActive=function(self) return self.spec_aiFieldWorker.isActive end,getAISteeringNode=function(self) return self.rootNode end,getRootVehicle=function(self) return self end,getName=function() return name end}
            return vehicle,job
        end
        local v68,j68=makeVehicle(301,2001,-100,-600,"68")
        local v69,j69=makeVehicle(302,2002,-100,-450,"69")
        local v70,j70=makeVehicle(303,2003,-100,-250,"70")
        local vu,ju=makeVehicle(304,2004,60,-348,"77 upper")
        local vl,jl=makeVehicle(305,2005,128,-448,"77 lower")
        local merged={{x=-228.2,z=-677.8},{x=-6.2,z=-677.8},{x=-6.2,z=-177.8},{x=-228.2,z=-177.8}}
        local upper={{x=300,z=-400},{x=540,z=-400},{x=540,z=-200},{x=300,z=-200}}
        local lower={{x=300,z=-700},{x=540,z=-700},{x=540,z=-410},{x=300,z=-410}}
        FieldCourseField={generateAtPosition=function(x,z,settings,callback)
            local boundary=(x<0 and merged) or (z>-408 and upper) or lower
            return {update=function(self,dt,budget) callback({fieldRootBoundary={boundaryLine=boundary},islands={}},true); return false end}
        end}
        mission.vehicles={v68,v69,v70,vu,vl}; mission.aiSystem.activeJobVehicles={v68,v69,v70,vu,vl}; mission.aiSystem.activeJobs={j68,j69,j70,ju,jl}
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local observations=runtime.liveObservationSource:capture(mission,10)
        equal(#observations,3)
        local sizes,keys={},{}
        for _,raw in ipairs(observations) do sizes[#sizes+1]=#raw.assemblies; keys[raw.fieldWorld.referenceKey]=true end
        table.sort(sizes); equal(table.concat(sizes,","),"1,1,3")
        local keyCount=0; for _ in pairs(keys) do keyCount=keyCount+1 end; equal(keyCount,3)
        for _,raw in ipairs(observations) do runtime:processSealedObservation(raw) end
        equal(#runtime.jobEpisodes:list(),5)
        equal(#runtime.operations:listActive(),3)
        FieldCourseField=oldGenerator
    end)
end)



test("Field World geometry measurements are deterministic",function()
    local rectangle={{x=0,z=0},{x=40,z=0},{x=40,z=20},{x=0,z=20}}
    local metrics=OuttaMyWay.FieldWorldSnapshotRegistry.measureGeometry(rectangle,{})
    if math.abs(metrics.areaSquareMetres-800)>0.0001 then error("area mismatch") end
    if math.abs(metrics.perimeterMetres-120)>0.0001 then error("perimeter mismatch") end
    if math.abs(metrics.centroidX-20)>0.0001 then error("centroid x mismatch") end
    if math.abs(metrics.centroidZ-10)>0.0001 then error("centroid z mismatch") end
    equal(metrics.boundaryPointCount,4)
end)

test("Field World evaluator resolves strong compound overlap as SAME",function()
    local a={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}}
    local b={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0.2,z=99.8}}
    local fa=OuttaMyWay.FieldWorldSnapshotRegistry.fingerprintGeometry(a,{},0.1)
    local fb=OuttaMyWay.FieldWorldSnapshotRegistry.fingerprintGeometry(b,{},0.1)
    if fa==fb then error("test requires non-exact fingerprints") end
    local ca=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(a,{},0.1)
    local cb=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(b,{},0.1)
    local evaluator=OuttaMyWay.FieldWorldEquivalenceEvaluator.new()
    local result=evaluator:evaluate({referenceKey="snapshot-A",canonicalGeometry=ca.canonicalGeometry,geometryFingerprint=ca.fingerprint,geometryMetrics=OuttaMyWay.FieldWorldSnapshotRegistry.measureGeometry(a,{})},{referenceKey="snapshot-B",canonicalGeometry=cb.canonicalGeometry,geometryFingerprint=cb.fingerprint,geometryMetrics=OuttaMyWay.FieldWorldSnapshotRegistry.measureGeometry(b,{})})
    equal(result.outcome,"SAME_FIELD_WORLD")
    if result.comparison.sampledJaccard<0.99 then error("near-identical polygons lacked strong sampled overlap") end
    if result.comparison.symmetricBoundaryMaxDistanceMetres>0.3 then error("boundary difference unexpectedly large") end
end)

test("split Field World comparison exposes low overlap",function()
    local upper={{x=-15.2,z=-408.2},{x=229.2,z=-408.2},{x=229.2,z=-206.8},{x=-15.2,z=-206.8}}
    local lower={{x=-40.8,z=-701.2},{x=191.8,z=-701.2},{x=191.8,z=-407.8},{x=-40.8,z=-407.8}}
    local comparison=OuttaMyWay.FieldWorldSnapshotRegistry.compareGeometry({boundary=upper,islands={}},{boundary=lower,islands={}},31)
    if comparison.sampledJaccard>0.02 then error("disconnected split polygons reported material overlap") end
    if comparison.centroidDistanceMetres<200 then error("split polygon centroids were not separated") end
end)

test("equivalence authority merges non-exact representations into one Operation",function()
    withFakeLiveGlobals(function(mission,a,b,positions)
        local oldGenerator=FieldCourseField
        positions[a.rootNode]={0,0,0}; positions[b.rootNode]={0,0,0}
        local polygonA={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}}
        local polygonB={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0.2,z=99.8}}
        local call=0
        FieldCourseField={generateAtPosition=function(x,z,settings,callback)
            call=call+1; local boundary=call==1 and polygonA or polygonB
            return {update=function(self,dt,budget) callback({fieldRootBoundary={boundaryLine=boundary},islands={}},true); return false end}
        end}
        mission.vehicles={a,b}; mission.aiSystem.activeJobVehicles={a,b}; mission.aiSystem.activeJobs={a.spec_aiJobVehicle.job,b.spec_aiJobVehicle.job}
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        runtime.liveObservationSource:capture(mission,10)
        local observations=runtime.liveObservationSource:capture(mission,11)
        equal(#observations,1)
        for _,raw in ipairs(observations) do runtime:processSealedObservation(raw) end
        equal(#runtime.operations:listActive(),1)
        equal(runtime.fieldWorldEquivalenceAuthority:getComparisonRecordCount(),1)
        local comparison=runtime.fieldWorldEquivalenceAuthority:getComparisonRecords()[1]
        equal(comparison.exactFingerprint,false)
        equal(comparison.outcome,"SAME_FIELD_WORLD")
        local operation=runtime.operations:listActive()[1]
        equal(#operation.memberFieldWorldSnapshotReferenceKeys,2)
        equal(#operation.memberFieldPolygonReferenceKeys,2)
        FieldCourseField=oldGenerator
    end)
end)

test("targeted field identity probe records only active job vehicles",function()
    withFakeLiveGlobals(function(mission,a,b)
        a.configFileName="data/vehicles/testA.xml"
        local pallet={rootNode=301,getRootVehicle=function(self) return self end}
        mission.vehicles={a,b,pallet}
        local probe=OuttaMyWay.TargetedFieldIdentityProbe.new()
        local captured=probe:capture(mission,10)
        equal(#captured.records,2)
        equal(captured.records[1].field.resolved,true); equal(captured.records[1].field.fieldId,77)
        if captured.records[1].jobProbe.token==nil then error("targeted probe omitted job token") end
        equal(probe:getSampleCount(),0)
    end)
end)

test("targeted field identity probe is diagnostic-only and does not affect admission",function()
    withFakeLiveGlobals(function(mission,a,b)
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        runtime.targetedFieldIdentityProbe:capture(mission,10)
        equal(#runtime.jobEpisodes:list(),0)
        equal(#runtime.operations:list(),0)
        equal(#runtime.commitments:list(),0)
        equal(runtime.controlAuthorityEnabled,false)
    end)
end)


test("GIANTS raw traversal cannot see sealed collections but ValueRecord accessors can", function()
    local snapshot=OuttaMyWay.ObservationSnapshot.new({identity="OS-GIANTS",epoch=1,timestamp=1,provenance={},fieldWorld={referenceKey="field-world:1",fieldPolygonReferenceKey="field-polygon:1",operationMembershipEvidenceComplete=false},assemblies={{assemblyId="AS-1",referenceKey="vehicle-root:1",componentIds={"CP-1"},componentReferenceKeys={"component-root:1"}}},geometry={currentSpaceEvidence={},futureSpaceEvidence={},demandEvidence={},interactionEvidence={}},motion={closureEvidence={}},aiStates={ ["AS-1"]={observedActive=true}},playerControl={},jobEpisodeEvidence={{assemblyId="AS-1",sourceJobToken="giants-ai-job-id:7",jobPresent=true,aiControlled=true}},operationMembershipEvidence={},physicalRepresentationEvidence={},controlOutcomes={},unavailableSources={{source="FIELD_WORLD"}}})
    local rawCount=0
    for _ in next,snapshot.jobEpisodeEvidence,nil do rawCount=rawCount+1 end
    equal(rawCount,0)
    local explicitCount=0
    for _,evidence in OuttaMyWay.ValueRecord.ipairs(snapshot.jobEpisodeEvidence) do explicitCount=explicitCount+1; equal(evidence.sourceJobToken,"giants-ai-job-id:7") end
    equal(explicitCount,1)
    local mapCount=0
    for _,state in OuttaMyWay.ValueRecord.pairs(snapshot.aiStates) do mapCount=mapCount+1; equal(state.observedActive,true) end
    equal(mapCount,1)
    equal(OuttaMyWay.ValueRecord.length(snapshot.assemblies),1)
end)

test("polygon field identity resolves without farmland service", function()
    local oldWorld=getWorldTranslation
    local points={ [11]={0,0}, [12]={100,0}, [13]={100,100}, [14]={0,100} }
    getWorldTranslation=function(node) local q=points[node]; return q[1],0,q[2] end
    local field={getId=function() return 77 end,getPolygonPoints=function() return {11,12,13,14} end}
    local mission={fieldManager={fields={field},farmlandIdFieldMapping={}}}
    local result=OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(mission,50,50)
    equal(result.resolved,true); equal(result.fieldId,77); equal(result.source,"fieldManager.fields+field.getPolygonPoints")
    local outside=OuttaMyWay.LiveAIJobEvidence.fieldAtPosition(mission,150,150)
    equal(outside.resolved,false); equal(outside.reason,"NO_FIELD_POLYGON_MATCH")
    getWorldTranslation=oldWorld
end)


local function fieldWorldSnapshotFixture(referenceKey,boundary,islands)
    islands=islands or {}
    local canonical,reason=OuttaMyWay.FieldWorldSnapshotRegistry.canonicalizeBoundary(boundary,islands,0.1)
    if canonical==nil then error(reason) end
    return {
        referenceKey=referenceKey,
        fieldWorldSnapshotReferenceKey=referenceKey,
        fieldPolygonReferenceKey="field-world-polygon:"..canonical.canonicalizationVersion..":"..canonical.fingerprint,
        geometryFingerprint=canonical.fingerprint,
        canonicalGeometry=canonical.canonicalGeometry,
        geometryMetrics=OuttaMyWay.FieldWorldSnapshotRegistry.measureGeometry(boundary,islands),
        boundary=boundary,islands=islands,immutableForJobEpisode=true
    }
end

local function newFieldWorldAuthority()
    local ids=OuttaMyWay.IdentityRegistry.new()
    local evaluator=OuttaMyWay.FieldWorldEquivalenceEvaluator.new()
    return evaluator,OuttaMyWay.FieldWorldEquivalenceAuthority.new(ids,evaluator)
end

test("exact canonical geometry shares Field World while retaining distinct Snapshot identity",function()
    local boundary={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}}
    local a=fieldWorldSnapshotFixture("snapshot-exact-A",boundary)
    local b=fieldWorldSnapshotFixture("snapshot-exact-B",boundary)
    local evaluator,authority=newFieldWorldAuthority()
    local evaluation=evaluator:evaluate(a,b)
    equal(evaluation.outcome,"SAME_FIELD_WORLD"); equal(evaluation.exactCanonicalGeometry,true)
    authority:beginObservationCycle()
    local ra=authority:resolve(a); local rb=authority:resolve(b)
    equal(ra.fieldWorldReferenceKey,rb.fieldWorldReferenceKey)
    if a.referenceKey==b.referenceKey then error("Snapshot identity collapsed") end
    equal(#authority:listActiveClasses()[1].snapshots,2)
    authority:endObservationCycle()
end)

test("four non-exact merged representations form one coherent Field World",function()
    local boundaries={
        {{x=0,z=0},{x=222,z=0},{x=222,z=500},{x=0,z=500}},
        {{x=0,z=0},{x=222,z=0},{x=222,z=500},{x=0.2,z=499.8}},
        {{x=0,z=0},{x=222,z=0.1},{x=221.9,z=500},{x=0,z=500}},
        {{x=0.1,z=0},{x=222,z=0},{x=222,z=499.9},{x=0,z=500}}
    }
    local _,authority=newFieldWorldAuthority(); authority:beginObservationCycle()
    local worldKey=nil; local fingerprints={}
    for index,boundary in ipairs(boundaries) do
        local snapshot=fieldWorldSnapshotFixture("snapshot-merged-"..index,boundary)
        if fingerprints[snapshot.geometryFingerprint] then error("fixture fingerprints were not distinct") end
        fingerprints[snapshot.geometryFingerprint]=true
        local result=authority:resolve(snapshot)
        if result.fieldWorldReferenceKey==nil then error("merged representation remained unresolved") end
        worldKey=worldKey or result.fieldWorldReferenceKey
        equal(result.fieldWorldReferenceKey,worldKey)
    end
    equal(authority:getActiveClassCount(),1)
    equal(#authority:listActiveClasses()[1].snapshots,4)
    authority:endObservationCycle()
end)

test("positive separation establishes two Field Worlds",function()
    local upper=fieldWorldSnapshotFixture("snapshot-split-upper",{{x=0,z=110},{x=100,z=110},{x=100,z=210},{x=0,z=210}})
    local lower=fieldWorldSnapshotFixture("snapshot-split-lower",{{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}})
    local evaluator,authority=newFieldWorldAuthority()
    local evaluation=evaluator:evaluate(upper,lower)
    equal(evaluation.outcome,"DIFFERENT_FIELD_WORLD")
    equal(evaluation.comparison.occupiedRegionsDisjoint,true)
    if evaluation.comparison.minimumBoundaryDistanceMetres<9.9 then error("separation evidence too small") end
    authority:beginObservationCycle()
    local a=authority:resolve(upper); local b=authority:resolve(lower)
    if a.fieldWorldReferenceKey==b.fieldWorldReferenceKey then error("separate Field Worlds were merged") end
    equal(authority:getActiveClassCount(),2)
    authority:endObservationCycle()
end)

test("partial overlap remains UNRESOLVED and does not join established Field World",function()
    local established=fieldWorldSnapshotFixture("snapshot-established",{{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}})
    local overlap=fieldWorldSnapshotFixture("snapshot-overlap",{{x=50,z=0},{x=150,z=0},{x=150,z=100},{x=50,z=100}})
    local evaluator,authority=newFieldWorldAuthority()
    equal(evaluator:evaluate(overlap,established).outcome,"UNRESOLVED")
    authority:beginObservationCycle()
    local first=authority:resolve(established); local second=authority:resolve(overlap)
    if first.fieldWorldReferenceKey==nil then error("established Field World was not assigned") end
    equal(second.outcome,"UNRESOLVED"); equal(second.fieldWorldReferenceKey,nil)
    equal(authority:getActiveClassCount(),1)
    equal(#authority:listActiveClasses()[1].snapshots,1)
    authority:endObservationCycle()
end)

test("class-wide coherence prevents tolerance chaining",function()
    local function shifted(referenceKey,offset)
        return fieldWorldSnapshotFixture(referenceKey,{{x=offset,z=0},{x=200+offset,z=0},{x=200+offset,z=200},{x=offset,z=200}})
    end
    local a,b,c=shifted("snapshot-chain-A",0),shifted("snapshot-chain-B",0.4),shifted("snapshot-chain-C",0.8)
    local evaluator,authority=newFieldWorldAuthority()
    equal(evaluator:evaluate(a,b).outcome,"SAME_FIELD_WORLD")
    equal(evaluator:evaluate(b,c).outcome,"SAME_FIELD_WORLD")
    equal(evaluator:evaluate(a,c).outcome,"UNRESOLVED")
    authority:beginObservationCycle()
    local ra=authority:resolve(a); local rb=authority:resolve(b); local rc=authority:resolve(c)
    equal(ra.fieldWorldReferenceKey,rb.fieldWorldReferenceKey)
    equal(rc.outcome,"UNRESOLVED"); equal(rc.fieldWorldReferenceKey,nil)
    equal(#authority:listActiveClasses()[1].snapshots,2)
    authority:endObservationCycle()
end)

test("Field World class retires after relevance ends and later Reality receives new identity",function()
    local boundary={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}}
    local first=fieldWorldSnapshotFixture("snapshot-lifecycle-A",boundary)
    local later=fieldWorldSnapshotFixture("snapshot-lifecycle-B",boundary)
    local _,authority=newFieldWorldAuthority()
    authority:beginObservationCycle(); local initial=authority:resolve(first); authority:endObservationCycle()
    equal(authority:getActiveClassCount(),1)
    authority:beginObservationCycle(); authority:endObservationCycle()
    equal(authority:getActiveClassCount(),0); equal(authority:getRetiredClassCount(),1)
    authority:beginObservationCycle(); local replacement=authority:resolve(later); authority:endObservationCycle()
    if initial.fieldWorldReferenceKey==replacement.fieldWorldReferenceKey then error("retired Field World identity was reused") end
end)

test("ambiguous live Snapshot receives no Operation authority",function()
    withFakeLiveGlobals(function(mission,a,b,positions)
        local oldGenerator=FieldCourseField
        positions[a.rootNode]={0,0,0}; positions[b.rootNode]={0,0,0}
        local polygonA={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}}
        local polygonB={{x=50,z=0},{x=150,z=0},{x=150,z=100},{x=50,z=100}}
        local call=0
        FieldCourseField={generateAtPosition=function(x,z,settings,callback)
            call=call+1; local boundary=call==1 and polygonA or polygonB
            return {update=function(self,dt,budget) callback({fieldRootBoundary={boundaryLine=boundary},islands={}},true); return false end}
        end}
        mission.vehicles={a,b}; mission.aiSystem.activeJobVehicles={a,b}; mission.aiSystem.activeJobs={a.spec_aiJobVehicle.job,b.spec_aiJobVehicle.job}
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local observations=runtime.liveObservationSource:capture(mission,10)
        equal(#observations,2)
        local unresolvedCount=0
        for _,raw in ipairs(observations) do
            if raw.fieldWorld.identityStatus=="UNRESOLVED" then
                unresolvedCount=unresolvedCount+1
                equal(raw.fieldWorld.operationMembershipEvidenceComplete,false)
                equal(raw.operationMembershipEvidence[1].performingRecognisedFieldWork,false)
            end
            runtime:processSealedObservation(raw)
        end
        equal(unresolvedCount,1)
        equal(#runtime.operations:listActive(),1)
        FieldCourseField=oldGenerator
    end)
end)


test("plan-view footprint preserves non-rectangular component composition",function()
    local primitives={
        {identity="body",kind="DISC",x=0,z=0,radius=2,positiveConflictSupport=true},
        {identity="left",kind="DISC",x=-8,z=-2,radius=1,positiveConflictSupport=true},
        {identity="right",kind="DISC",x=8,z=-2,radius=1,positiveConflictSupport=true}
    }
    local summary=OuttaMyWay.PlanViewFootprint.summarise(primitives)
    equal(summary.physicalPrimitiveCount,3)
    if summary.bounds.width<17.9 or summary.bounds.length<4.9 then error("T-shaped component extent was flattened or lost") end
    if summary.hullPointCount<4 then error("plan-view hull was not produced") end
end)

test("current footprint supports present conflict but never negative clearance",function()
    local a={worldPrimitives={{identity="a-boom",kind="DISC",x=0,z=0,radius=2,positiveConflictSupport=true}}}
    local b={worldPrimitives={{identity="b-boom",kind="DISC",x=20,z=0,radius=2,positiveConflictSupport=true}}}
    local separated=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(a,b)
    equal(separated.current,false)
    equal(separated.outcome,"CURRENT_FOOTPRINT_INTERACTION_UNRESOLVED")
    equal(separated.authority,"NO_NEGATIVE_CLEARANCE_AUTHORITY")
    b.worldPrimitives[1].x=3
    local overlap=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(a,b)
    equal(overlap.current,true)
    equal(overlap.outcome,"CURRENT_FOOTPRINT_INTERACTION_POSITIVE")
    equal(overlap.authority,"POSITIVE_CONFLICT_SUPPORT_ONLY")
end)

test("Job Episode representation cache discovers compound members once and reuses local geometry",function()
    local sphereCalls=0
    local positions={[1]={0,0,0},[2]={-6,0,-2},[10]={0,0,-5},[11]={2,0,-5}}
    local children={[1]={2},[2]={},[10]={11},[11]={}}
    local names={[1]="tractorRoot",[2]="body_colPart",[10]="ploughRoot",[11]="offsetPlough_colPart"}
    local localSpheres={[1]={0,0,0,2},[2]={0,0,0,1},[10]={0,0,0,1.5},[11]={0,0,0,1}}
    local function localToWorldMock(node,x,y,z) local p=positions[node]; return p[1]+x,p[2]+y,p[3]+z end
    local function localSphere(node) sphereCalls=sphereCalls+1; local s=localSpheres[node]; return s[1],s[2],s[3],s[4],true end
    local function worldSphere(node) sphereCalls=sphereCalls+1; local s=localSpheres[node]; local p=positions[node]; return p[1]+s[1],p[2]+s[2],p[3]+s[3],s[4] end
    local attached={}
    local implement={rootNode=10,configFileName="data/implements/test/offsetPlough.xml",components={{node=10}},getName=function() return "Offset Plough" end,getAttachedImplements=function() return {} end}
    local worker={rootNode=1,configFileName="data/vehicles/test/tractor.xml",components={{node=1}},getName=function() return "Tractor" end,getAttachedImplements=function() return attached end}
    attached={{object=implement}}
    local cache=OuttaMyWay.AssemblyRepresentationCache.new({api={
        getNumOfChildren=function(node) return #(children[node] or {}) end,
        getChildAt=function(node,index) return children[node][index+1] end,
        getName=function(node) return names[node] end,
        localToWorld=localToWorldMock,
        getShapeGeometryBoundingSphere=localSphere,
        getShapeBoundingSphere=localSphere,
        getShapeWorldBoundingSphere=worldSphere,
        getIsCompoundChild=function(node) return node==2 or node==11 end
    }})
    cache:beginObservationCycle()
    local first=cache:observe(worker,"vehicle-root:1","episode-1",0)
    cache:endObservationCycle()
    equal(first.memberCount,2); equal(first.edgeCount,1)
    if first.physicalPrimitiveCount<4 then error("compound member/component geometry was not composed") end
    local afterFirst=sphereCalls
    cache:beginObservationCycle()
    positions[11]={4,0,-6}
    local second=cache:observe(worker,"vehicle-root:1","episode-1",1)
    cache:endObservationCycle()
    equal(second.cacheHit,true); equal(second.configurationProfileCacheHit,true)
    equal(sphereCalls,afterFirst,"geometry APIs were called again on cache hit")
    local found=false
    for _,primitive in ipairs(second.worldPrimitives) do if primitive.nodeName=="offsetPlough_colPart" and math.abs(primitive.x-4)<0.001 then found=true end end
    if not found then error("cached local geometry did not follow current articulated member pose") end
end)

test("assembly membership change invalidates the same Job Episode representation",function()
    local children={[1]={},[10]={}}
    local positions={[1]={0,0,0},[10]={0,0,-5}}
    local attached={}
    local implement={rootNode=10,configFileName="implement.xml",components={{node=10}},getAttachedImplements=function() return {} end}
    local worker={rootNode=1,configFileName="tractor.xml",components={{node=1}},getAttachedImplements=function() return attached end}
    attached={{object=implement}}
    local function localSphere(node) return 0,0,0,1,true end
    local cache=OuttaMyWay.AssemblyRepresentationCache.new({api={
        getNumOfChildren=function(node) return 0 end,getChildAt=function() return nil end,getName=function(node) return "root" end,
        localToWorld=function(node,x,y,z) local p=positions[node]; return p[1]+x,p[2]+y,p[3]+z end,
        getShapeGeometryBoundingSphere=localSphere,getShapeBoundingSphere=localSphere,
        getShapeWorldBoundingSphere=function(node) local p=positions[node]; return p[1],p[2],p[3],1 end,
        getIsCompoundChild=function() return false end
    }})
    cache:beginObservationCycle(); cache:observe(worker,"vehicle-root:1","episode-1",0); cache:endObservationCycle()
    attached={}
    cache:beginObservationCycle(); local changed=cache:observe(worker,"vehicle-root:1","episode-1",6); cache:endObservationCycle()
    equal(changed.membershipChanged,true); equal(changed.structurallyValid,false); equal(changed.worldPrimitiveCount,0)
end)


test("configuration profile excludes inactive alternative shop geometry",function()
    local positions={[1]={0,0,0},[2]={-15,0,-4},[3]={15,0,-4},[4]={-27,0,-4},[5]={27,0,-4}}
    local children={[1]={2,3,4,5},[2]={},[3]={},[4]={},[5]={}}
    local names={[1]="condorRoot",[2]="boom01ArmLeftCol03",[3]="boom01ArmRightCol03",[4]="boom03ArmLeftCol03",[5]="boom03ArmRightCol03"}
    local worker={rootNode=1,configFileName="data/vehicles/agrifac/condorEndurance2/condorEndurance2.xml",configurations={folding=1},components={{node=1}},getName=function() return "Condor" end,getAttachedImplements=function() return {} end}
    local function localSphere(node) return 0,0,0,node==1 and 2 or 1,true end
    local cache=OuttaMyWay.AssemblyRepresentationCache.new({api={
        getNumOfChildren=function(node) return #(children[node] or {}) end,getChildAt=function(node,index) return children[node][index+1] end,getName=function(node) return names[node] end,
        localToWorld=function(node,x,y,z) local p=positions[node]; return p[1]+x,p[2]+y,p[3]+z end,
        getShapeGeometryBoundingSphere=localSphere,getShapeBoundingSphere=localSphere,getShapeWorldBoundingSphere=function(node) local p=positions[node]; local r=node==1 and 2 or 1; return p[1],p[2],p[3],r end,
        getIsCompoundChild=function(node) return node==2 or node==3 end
    }})
    cache:beginObservationCycle(); local result=cache:observe(worker,"vehicle-root:1","episode-config",0); cache:endObservationCycle()
    equal(result.inventoryPrimitiveCount,5)
    equal(result.participatingPrimitiveCount,3)
    equal(result.inactivePrimitiveCount,2)
    equal(result.unresolvedPrimitiveCount,0)
    equal(result.runtimeConfirmedPrimitiveCount,2)
    if result.planViewSummary.bounds.width>40 then error("inactive 54 m alternative geometry contaminated 36 m profile") end
    if result.planViewSummary.bounds.width<31 then error("active 36 m component span was lost") end
end)

test("runtime compound-child evidence can select a different purchased geometry family",function()
    local positions={[1]={0,0,0},[2]={-15,0,-4},[3]={15,0,-4},[4]={-27,0,-4},[5]={27,0,-4}}
    local children={[1]={2,3,4,5},[2]={},[3]={},[4]={},[5]={}}
    local names={[1]="condorRoot",[2]="boom01ArmLeftCol03",[3]="boom01ArmRightCol03",[4]="boom03ArmLeftCol03",[5]="boom03ArmRightCol03"}
    local worker={rootNode=1,configFileName="data/vehicles/agrifac/condorEndurance2/condorEndurance2.xml",configurations={folding=3},components={{node=1}},getName=function() return "Condor" end,getAttachedImplements=function() return {} end}
    local function localSphere(node) return 0,0,0,node==1 and 2 or 1,true end
    local cache=OuttaMyWay.AssemblyRepresentationCache.new({api={
        getNumOfChildren=function(node) return #(children[node] or {}) end,getChildAt=function(node,index) return children[node][index+1] end,getName=function(node) return names[node] end,
        localToWorld=function(node,x,y,z) local p=positions[node]; return p[1]+x,p[2]+y,p[3]+z end,
        getShapeGeometryBoundingSphere=localSphere,getShapeBoundingSphere=localSphere,getShapeWorldBoundingSphere=function(node) local p=positions[node]; local r=node==1 and 2 or 1; return p[1],p[2],p[3],r end,
        getIsCompoundChild=function(node) return node==4 or node==5 end
    }})
    cache:beginObservationCycle(); local result=cache:observe(worker,"vehicle-root:1","episode-config-3",0); cache:endObservationCycle()
    equal(result.participatingPrimitiveCount,3)
    equal(result.runtimeConfirmedPrimitiveCount,2)
    if result.planViewSummary.bounds.width<55 then error("runtime-active alternative geometry was not selected") end
    if string.find(result.configurationSelectorSummary,"MISMATCH",1,true)==nil then error("donor selector mismatch was not exposed") end
end)


test("current footprint overlap remains positive-only evidence",function()
    local a={worldPrimitives={{identity="a",kind="DISC",x=0,z=0,radius=2,positiveConflictSupport=true}}}
    local b={worldPrimitives={{identity="b",kind="DISC",x=10,z=0,radius=2,positiveConflictSupport=true}}}
    local unresolved=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(a,b)
    equal(unresolved.current,false); equal(unresolved.authority,"NO_NEGATIVE_CLEARANCE_AUTHORITY")
    b.worldPrimitives[1].x=2
    local positive=OuttaMyWay.PlanViewFootprint.evaluateCurrentOverlap(a,b)
    equal(positive.current,true); equal(positive.authority,"POSITIVE_CONFLICT_SUPPORT_ONLY")
end)

test("filtered current-space footprint positive reaches Encounter when scalar radius is missing",function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA,jobB,field,farmland,directions)
        local saved={
            getNumOfChildren=getNumOfChildren,getChildAt=getChildAt,getName=getName,localToWorld=localToWorld,
            getShapeGeometryBoundingSphere=getShapeGeometryBoundingSphere,getShapeBoundingSphere=getShapeBoundingSphere,
            getShapeWorldBoundingSphere=getShapeWorldBoundingSphere,getIsCompoundChild=getIsCompoundChild
        }
        getNumOfChildren=function() return 0 end
        getChildAt=function() return nil end
        getName=function(node) return "root"..tostring(node) end
        localToWorld=function(node,x,y,z) local p=positions[node]; return p[1]+x,p[2]+y,p[3]+z end
        getShapeGeometryBoundingSphere=function(node) return 0,0,0,2.5,true end
        getShapeBoundingSphere=function(node) return 0,0,0,2.5,true end
        getShapeWorldBoundingSphere=function(node) local p=positions[node]; return p[1],p[2],p[3],2.5 end
        getIsCompoundChild=function() return false end
        directions[201]={0,-1}; positions[201]={0,0,4}; b.sizeWidth=nil
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        local pair=raw.diagnostics.pairDiagnostics[1]
        equal(pair.principalOutcome,"MISSING_OTHER_RADIUS")
        equal(pair.currentFootprintIntersects,true)
        equal(pair.interactionEvidenceSource,"CURRENT_SPACE_POSITIVE")
        equal(pair.interactionEvidenceEmitted,true)
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.picture.encounters,1)
        equal(processed.picture.encounters[1].relationship,"CURRENT_SPACE_INTERACTION")
        equal(processed.picture.encounters[1].evidence.provenance.authority,"POSITIVE_INTERACTION_ONLY")
        equal(processed.picture.encounters[1].evidence.provenance.negativeClearanceAuthority,false)
        getNumOfChildren=saved.getNumOfChildren; getChildAt=saved.getChildAt; getName=saved.getName; localToWorld=saved.localToWorld
        getShapeGeometryBoundingSphere=saved.getShapeGeometryBoundingSphere; getShapeBoundingSphere=saved.getShapeBoundingSphere
        getShapeWorldBoundingSphere=saved.getShapeWorldBoundingSphere; getIsCompoundChild=saved.getIsCompoundChild
    end)
end)

test("shape type gate rejects transform groups before shape-bound APIs", function()
    local calls=0
    local cache=OuttaMyWay.AssemblyRepresentationCache.new({api={
        ClassIds={SHAPE=17},
        getHasClassId=function(node,classId) equal(classId,17); return node==101 end,
        getShapeGeometryBoundingSphere=function() calls=calls+1; error("must not be called for transform group") end
    }})
    local rejected=cache:_callSphere("getShapeGeometryBoundingSphere",202)
    equal(rejected.valid,false)
    equal(rejected.error,"NOT_SHAPE")
    equal(calls,0)
end)

test("native Local Intent follows GIANTS active-segment turn state", function()
    local turn=false
    local vehicle={spec_aiVehicle={driveStrategies={{className="AIDriveStrategyFieldCourse",aiFieldCourse={getActiveSegmentData=function() return turn,4,0.25,100,nil,75 end}}}}}
    local track={}
    local straight=OuttaMyWay.LocalIntentObservation.updateTrack(track,OuttaMyWay.LocalIntentObservation.observe(vehicle))
    equal(straight.classification,"SETTLED_CONTINUATION"); equal(straight.intentEpoch,1); equal(straight.intentValid,true)
    turn=true
    local manoeuvre=OuttaMyWay.LocalIntentObservation.updateTrack(track,OuttaMyWay.LocalIntentObservation.observe(vehicle))
    equal(manoeuvre.classification,"TURNING"); equal(manoeuvre.intentEpoch,1); equal(manoeuvre.intentValid,false); equal(manoeuvre.transition,"INTENT_EXPIRED_BY_MANOEUVRE")
    turn=false
    local settled=OuttaMyWay.LocalIntentObservation.updateTrack(track,OuttaMyWay.LocalIntentObservation.observe(vehicle))
    equal(settled.classification,"SETTLED_CONTINUATION"); equal(settled.intentEpoch,2); equal(settled.intentValid,true); equal(settled.transition,"LOCAL_INTENT_REVEALED_AFTER_MANOEUVRE")
end)

test("field-bounded continuation reaches forward Field World boundary", function()
    local field={boundary={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}},islands={}}
    local distance,source=OuttaMyWay.FieldBoundedFutureSpace.forwardBoundaryDistance(field,{x=50,z=20,dx=0,dz=1})
    equal(math.floor(distance+0.5),80); equal(source,"FIELD_WORLD_OUTER_BOUNDARY")
end)

test("field-bounded component continuations support positive intersection and turning remains unresolved", function()
    local field={boundary={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}},islands={}}
    local function worker(x,z,dx,dz,intent)
        return {activeObserved=true,fieldWorldSnapshot=field,pose={x=x,z=z,dx=dx,dz=dz},localIntent=intent,shadowRepresentation={worldPrimitives={{kind="DISC",identity=tostring(x)..":"..tostring(z),x=x,z=z,radius=2,positiveConflictSupport=true}}}}
    end
    local settledA={classification="SETTLED_CONTINUATION",intentEpoch=1,intentValid=true}
    local settledB={classification="SETTLED_CONTINUATION",intentEpoch=1,intentValid=true}
    local a=worker(50,20,0,1,settledA); local b=worker(20,50,1,0,settledB)
    local positive=OuttaMyWay.FieldBoundedFutureSpace.evaluatePair(a,b)
    equal(positive.positive,true); equal(positive.outcome,"FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE"); equal(positive.negativeClearanceAuthority,false)
    b.localIntent={classification="TURNING",intentEpoch=1,intentValid=false}
    local unresolved=OuttaMyWay.FieldBoundedFutureSpace.evaluatePair(a,b)
    equal(unresolved.positive,false); equal(unresolved.unresolved,true); equal(unresolved.outcome,"FUTURE_SPACE_INTERACTION_UNRESOLVED")
end)

test("field-bounded Future Space admits Encounter after legacy predictor removal", function()
    withFakeLiveGlobals(function(mission,a,b,positions,jobA,jobB,field,farmland,directions)
        local saved={
            getNumOfChildren=getNumOfChildren,getChildAt=getChildAt,getName=getName,localToWorld=localToWorld,
            getShapeGeometryBoundingSphere=getShapeGeometryBoundingSphere,getShapeBoundingSphere=getShapeBoundingSphere,
            getShapeWorldBoundingSphere=getShapeWorldBoundingSphere,getIsCompoundChild=getIsCompoundChild
        }
        getNumOfChildren=function() return 0 end
        getChildAt=function() return nil end
        getName=function(node) return "root"..tostring(node) end
        localToWorld=function(node,x,y,z) local p=positions[node]; return p[1]+x,p[2]+y,p[3]+z end
        getShapeGeometryBoundingSphere=function(node) return 0,0,0,2.5,true end
        getShapeBoundingSphere=function(node) return 0,0,0,2.5,true end
        getShapeWorldBoundingSphere=function(node) local p=positions[node]; return p[1],p[2],p[3],2.5 end
        getIsCompoundChild=function() return false end
        local function settledStrategy()
            return {className="AIDriveStrategyFieldCourse",aiFieldCourse={getActiveSegmentData=function() return false,4,0.25,100,nil,75 end}}
        end
        a.spec_aiVehicle={driveStrategies={settledStrategy()}}
        b.spec_aiVehicle={driveStrategies={settledStrategy()}}
        directions[101]={0,1}; directions[201]={0,-1}
        a.lastSpeedReal=0.0005; b.lastSpeedReal=0.0005
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize()
        local raw=runtime.liveObservationSource:capture(mission,10)[1]
        local pair=raw.diagnostics.pairDiagnostics[1]
        equal(pair.futureSpaceOutcome,"FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE")
        equal(pair.fieldBoundedFutureSpacePositive,true)
        equal(pair.interactionEvidenceEmitted,true)
        equal(pair.interactionEvidenceSource,"FIELD_BOUNDED_FUTURE_SPACE_POSITIVE")
        equal(raw.geometry.interactionEvidence[1].relationship,"FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION")
        equal(raw.geometry.interactionEvidence[1].provenance.legacyShadow,nil)
        local processed=runtime:processSealedObservation(raw)
        equal(#processed.picture.encounters,1)
        equal(processed.picture.encounters[1].relationship,"FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION")
        equal(processed.picture.encounters[1].evidence.provenance.source,"FIELD_BOUNDED_FUTURE_SPACE_POSITIVE")
        equal(processed.picture.encounters[1].evidence.provenance.negativeClearanceAuthority,false)
        getNumOfChildren=saved.getNumOfChildren; getChildAt=saved.getChildAt; getName=saved.getName; localToWorld=saved.localToWorld
        getShapeGeometryBoundingSphere=saved.getShapeGeometryBoundingSphere; getShapeBoundingSphere=saved.getShapeBoundingSphere
        getShapeWorldBoundingSphere=saved.getShapeWorldBoundingSphere; getIsCompoundChild=saved.getIsCompoundChild
    end)
end)

test("Situation Assessment publishes field-bounded Future Space relationship as Knowledge only", function()
    local runtime=newPictureRuntime()
    local relationship={{interactionReferenceKey="future-rel-1",subjectAssemblyReferenceKey="assembly-A",otherAssemblyReferenceKey="assembly-B",positiveIntersection=true,unresolved=false,outcome="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE",subjectIntentClassification="SETTLED_CONTINUATION",otherIntentClassification="SETTLED_CONTINUATION",subjectIntentEpoch=1,otherIntentEpoch=2,subjectBoundaryDistance=80,otherBoundaryDistance=70,distance=0,required=4,authority="POSITIVE_FUTURE_SPACE_SUPPORT_ONLY",negativeClearanceAuthority=false,provenance={source="fixture"}}}
    local result=runtime:processSealedObservation(pictureFixture(1,{interactions={},futureSpaceRelationships=relationship}))
    equal(#result.picture.encounters,0)
    equal(#result.picture.situations[1].futureSpaceRelationships,1)
    equal(result.picture.situations[1].futureSpaceRelationships[1].classification,"FUTURE_SPACE_INTERSECTION")
    equal(result.picture.situations[1].futureSpaceRelationships[1].negativeClearanceAuthority,false)
end)

test("Lifecycle test HUD preserves Encounter stop restart gate", function()
    local hud=OuttaMyWay.TransitionHud.new()
    equal(hud:getState().phase,"WAITING_FOR_ENCOUNTER")
    hud:observeEncounterTransition({lifecycle="CREATED",encounterIdentity="EN-1",relationship="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION"})
    equal(hud:getState().phase,"ENCOUNTER_ACTIVE"); equal(hud:getState().title,"OTM TEST — FUTURE SPACE ENCOUNTER")
    hud:observeEncounterTransition({lifecycle="TERMINATED",encounterIdentity="EN-1",terminalReason="JOB_EPISODE_ENDED"})
    equal(hud:getState().phase,"ENCOUNTER_TERMINATED")
    hud:observeAdmittedEpisodes({"JE-NEW"})
    equal(hud:getState().phase,"NEW_JOB_EPISODE")
    hud:observeEncounterTransition({lifecycle="CREATED",encounterIdentity="EN-2",relationship="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION"})
    equal(hud:getState().phase,"TEST_COMPLETE"); equal(hud:getState().title,"OTM TEST — NEW FUTURE SPACE ENCOUNTER")
end)

test("Future Space HUD reports settled, manoeuvring and intersecting Knowledge", function()
    local hud=OuttaMyWay.FutureSpaceHud.new()
    hud:observeRecord({assemblyDiagnostics={{assemblyReferenceKey="A",name="Condor",activeJobVehicleMembership=true,localIntent={classification="SETTLED_CONTINUATION"},futureSpace={boundaryDistance=120}},{assemblyReferenceKey="B",name="Patriot",activeJobVehicleMembership=true,localIntent={classification="TURNING"},futureSpace={}}},pairDiagnostics={{eligible=true,futureSpaceOutcome="FUTURE_SPACE_INTERACTION_UNRESOLVED"}}})
    equal(hud.lines[2],"Condor: STRAIGHT → 120m"); equal(hud.lines[3],"Patriot: TURNING"); equal(hud.lines[4],"Pair: UNRESOLVED WHILE MANOEUVRING")
    hud:observeRecord({assemblyDiagnostics={{assemblyReferenceKey="A",name="Condor",activeJobVehicleMembership=true,localIntent={classification="SETTLED_CONTINUATION"},futureSpace={boundaryDistance=100}},{assemblyReferenceKey="B",name="Patriot",activeJobVehicleMembership=true,localIntent={classification="SETTLED_CONTINUATION"},futureSpace={boundaryDistance=90}}},pairDiagnostics={{eligible=true,futureSpaceOutcome="FIELD_BOUNDED_FUTURE_SPACE_INTERSECTION_POSITIVE"}}})
    equal(hud.lines[4],"Pair: FUTURE SPACES INTERSECT")
end)


test("D-0123 shadow geometry distinguishes convergent from divergent revealed continuation", function()
    local base={
        recoveryPose={x=0,z=0,dx=1,dz=0},rejoinTargetX=10,rejoinTargetZ=0,rejoinAnchorX=4,rejoinAnchorZ=0,
        recoveryCurrentSpanM=4,recoveryInitialSpanM=36,progressSpanM=4
    }
    local convergent={} for k,v in pairs(base) do convergent[k]=v end
    convergent.progressPose={x=20,z=10,dx=0,dz=-1}
    convergent.previousProgressPose={x=20,z=11,dx=0,dz=-1}
    local yes=OuttaMyWay.GuardedRecoveryConvergenceProbe.evaluateGeometry(convergent)
    equal(yes.resolved,true)
    equal(yes.combinations.COMMITTED_RECOVERY_UNION__CURRENT_HEADING.positive,true)

    local divergent={} for k,v in pairs(base) do divergent[k]=v end
    divergent.progressPose={x=20,z=10,dx=0,dz=1}
    divergent.previousProgressPose={x=20,z=9,dx=0,dz=1}
    local no=OuttaMyWay.GuardedRecoveryConvergenceProbe.evaluateGeometry(divergent)
    equal(no.resolved,true)
    equal(no.combinations.CURRENT_TO_REJOIN__CURRENT_HEADING.positive,false)
end)

test("D-0123 shadow probe carries no actuation vocabulary", function()
    local probe=OuttaMyWay.GuardedRecoveryConvergenceProbe.new()
    local status=probe:getStatus()
    equal(status.active,false)
end)


test("D-0123 Regulation test signal uses committed recovery plus current heading", function()
    local base={
        runNumber=1,geometryResolved=true,progressExpectedJobToken="JOB-P",progressEvidenceJobToken="JOB-P",
        progressEvidenceClass="NON_TURN_LINE_ACTIVE",progressMovingDirection=1,
        combinations={COMMITTED_RECOVERY_UNION__CURRENT_HEADING={resolved=true,positive=true,clearance=-2.5}}
    }
    local positive=OuttaMyWay.GuardedRecoveryRegulationTestBridge.evaluateSignal(base)
    equal(positive.status,"POSITIVE")
    equal(positive.reason,"REVEALED_NATIVE_CONTINUATION_INTERSECTS_VULNERABLE_SPACE")

    base.progressEvidenceClass="TURN_SEGMENT"
    equal(OuttaMyWay.GuardedRecoveryRegulationTestBridge.evaluateSignal(base).status,"POSITIVE")

    base.combinations.COMMITTED_RECOVERY_UNION__CURRENT_HEADING.positive=false
    base.combinations.COMMITTED_RECOVERY_UNION__CURRENT_HEADING.clearance=8.0
    equal(OuttaMyWay.GuardedRecoveryRegulationTestBridge.evaluateSignal(base).status,"NEGATIVE")

    base.progressEvidenceClass="NON_TURN_LINE_INACTIVE"
    equal(OuttaMyWay.GuardedRecoveryRegulationTestBridge.evaluateSignal(base).status,"UNRESOLVED")

    base.progressEvidenceClass="NON_TURN_LINE_ACTIVE"
    base.progressMovingDirection=-1
    equal(OuttaMyWay.GuardedRecoveryRegulationTestBridge.evaluateSignal(base).status,"UNRESOLVED")
    base.progressMovingDirection=1
    base.progressEvidenceJobToken="JOB-OTHER"
    equal(OuttaMyWay.GuardedRecoveryRegulationTestBridge.evaluateSignal(base).status,"INVALIDATED")
end)

test("D-0123 Regulation test bridge maintains through uncertainty and releases only on positive clear or window end", function()
    local vehicle={name="Patriot"}
    local authority={states={}}
    function authority:getState(v) return self.states[v] end
    function authority:setRegulation(v,speed,ownerTag)
        self.states[v]={mode="REGULATE",speedKmh=speed,ownerTag=ownerTag,driveCalls=0}
        return true
    end
    function authority:clear(v) self.states[v]=nil end
    local gate={driveAuthority=authority}
    local probe={active=true}
    function probe:getStatus() return {active=self.active} end
    function probe:getLatestSample() return self.sample end
    local function sample(positive,evidenceClass)
        return {
            runNumber=7,progressVehicle=vehicle,progressName="Patriot 4450",progressReferenceKey="vehicle-root:201",
            progressExpectedJobToken="JOB-P",progressEvidenceJobToken="JOB-P",progressEvidenceClass=evidenceClass or "NON_TURN_LINE_ACTIVE",progressMovingDirection=1,
            geometryResolved=true,combinations={COMMITTED_RECOVERY_UNION__CURRENT_HEADING={resolved=true,positive=positive,clearance=positive and -1 or 5}}
        }
    end
    local bridge=OuttaMyWay.GuardedRecoveryRegulationTestBridge.new()
    OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_ENABLED=true
    OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_KMH=1.0

    probe.sample=sample(true)
    bridge:update(gate,probe,1000)
    equal(bridge:getStatus().active,true)
    equal(authority:getState(vehicle).mode,"REGULATE")
    equal(authority:getState(vehicle).speedKmh,1.0)

    -- Loss of positive continuing-intent evidence is uncertainty, not release.
    probe.sample=sample(true,"NON_TURN_LINE_INACTIVE")
    bridge:update(gate,probe,1100)
    equal(bridge:getStatus().active,true)
    equal(authority:getState(vehicle).mode,"REGULATE")

    -- A positively supported clear current heading may release the cap.
    probe.sample=sample(false,"NON_TURN_LINE_ACTIVE")
    bridge:update(gate,probe,1200)
    equal(bridge:getStatus().active,false)
    equal(authority:getState(vehicle),nil)

    -- Reapply on renewed convergence, then end on vulnerability-window expiry.
    probe.sample=sample(true,"TURN_SEGMENT")
    bridge:update(gate,probe,1300)
    equal(bridge:getStatus().active,true)
    probe.active=false
    bridge:update(gate,probe,1400)
    equal(bridge:getStatus().active,false)
    equal(authority:getState(vehicle),nil)
end)




test("D-0130 Guarded-Recovery lease temporarily tightens retained maturation Regulation", function()
    local oldAIVehicleUtil=AIVehicleUtil
    AIVehicleUtil={driveToPoint=function(...) return true end}
    local vehicle={name="Patriot"}
    local authority=OuttaMyWay.Prototype22DriveAuthority.new()
    equal(authority:setRegulationLease(vehicle,17.1,"MATURATION"),true)
    local gate={driveAuthority=authority}
    local probe={active=true}
    function probe:getStatus() return {active=self.active} end
    function probe:getLatestSample() return self.sample end
    probe.sample={
        runNumber=8,progressVehicle=vehicle,progressName="Patriot 4450",progressReferenceKey="vehicle-root:201",
        progressExpectedJobToken="JOB-P",progressEvidenceJobToken="JOB-P",progressEvidenceClass="NON_TURN_LINE_ACTIVE",progressMovingDirection=1,
        geometryResolved=true,combinations={COMMITTED_RECOVERY_UNION__CURRENT_HEADING={resolved=true,positive=true,clearance=-1}}
    }
    local bridge=OuttaMyWay.GuardedRecoveryRegulationTestBridge.new()
    OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_ENABLED=true
    OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_KMH=1.0
    bridge:update(gate,probe,1000)
    equal(authority:getState(vehicle).speedKmh,1.0)
    equal(authority:hasRegulationLease(vehicle,"MATURATION"),true)
    equal(authority:hasRegulationLease(vehicle,"D0123_GUARDED_RECOVERY_TEST"),true)
    probe.sample.combinations.COMMITTED_RECOVERY_UNION__CURRENT_HEADING={resolved=true,positive=false,clearance=5}
    bridge:update(gate,probe,1100)
    equal(bridge:getStatus().active,false)
    equal(authority:getState(vehicle).speedKmh,17.1)
    equal(authority:hasRegulationLease(vehicle,"MATURATION"),true)
    AIVehicleUtil=oldAIVehicleUtil
end)



test("D-0141 current Adjacent Following topology supports the v4.7.70 positive case without historical sweep authority", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=144,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local follower={assemblyId="AS-P",x=0,z=-26,dx=0,dz=1,boundaryDistanceM=170,workingWidthM=30,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.relationship.status,"POSITIVE")
    equal(result.relationship.reason,"CURRENT_COHERENT_LINE_ASTERN_PRODUCTIVE_TOPOLOGY")
    equal(result.status,"REGULATE_SUPPORTED")
    equal(result.purposeState,"ADMIT")
    equal(result.demandSeed.kind,"PROVISIONAL_DEMAND_SEED")
    equal(result.demandSeed.spatialSeedSource,"OBSERVED_GIANTS_WORKING_WIDTH")
    equal(result.controlMagnitude.nativeUnrestrictedFollowerKmh,25)
    equal(result.controlMagnitude.requestedFollowerCapKmh>0,true)
    equal(result.controlMagnitude.requestedFollowerCapKmh<25,true)
end)

test("D-0141 native zero command is unresolved rate evidence and cannot derive a zero policy cap", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=60,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local follower={assemblyId="AS-P",x=0,z=-26,dx=0,dz=1,boundaryDistanceM=86,workingWidthM=30,productivePositive=true,settledContinuation=true,progressSpeedKmh=0,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=0,nativeZeroCommand=true}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.relationship.status,"POSITIVE")
    equal(result.status,"UNRESOLVED")
    equal(result.reason,"FOLLOWER_NATIVE_ZERO_COMMAND_HAS_NO_RATE_AUTHORITY")
    equal(result.controlMagnitude.requestedFollowerCapKmh,nil)
end)

test("D-0141 distant same-corridor following remains current topology but needs no Control while natural ordering is preserved", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=100,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local follower={assemblyId="AS-P",x=0,z=-200,dx=0,dz=1,boundaryDistanceM=300,workingWidthM=30,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.relationship.status,"POSITIVE")
    equal(result.status,"OBSERVE_SUPPORTED")
    equal(result.purposeState,"NONE")
    equal(result.controlMagnitude.regulationRequired,false)
    equal(result.controlMagnitude.requestedFollowerCapKmh,25)
end)

test("D-0141 current work-corridor topology rejects the v4.7.69 opposite-corners false follower", function()
    local dx,dz=-0.086,-0.996
    local leader={assemblyId="AS-P",x=147.77,z=-376.48,dx=dx,dz=dz,boundaryDistanceM=100,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local follower={assemblyId="AS-C",x=54.08,z=-259.24,dx=dx,dz=dz,boundaryDistanceM=120,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.relationship.status,"NEGATIVE")
    equal(result.relationship.reason,"CURRENT_PRODUCTIVE_WORK_CORRIDORS_DO_NOT_OVERLAP")
    equal(math.abs(result.relationship.lateralOffsetM)>100,true)
    equal(result.status,"NOT_APPLICABLE")
end)

test("D-0141 existing follower purpose actively follows positive leader Transitional rate with clearance factor and Progress Passage positively retires it", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=30,workingWidthM=36,productivePositive=false,settledContinuation=false,turning=true,progressSpeedKmh=10,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=10}
    local follower={assemblyId="AS-P",x=0,z=-20,dx=0,dz=1,boundaryDistanceM=50,workingWidthM=30,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local preserved=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99})
    equal(preserved.status,"REGULATE_SUPPORTED")
    equal(preserved.purposeState,"PERSIST")
    equal(preserved.transitionPreservation,true)
    equal(preserved.controlMagnitude.requestedFollowerCapKmh,9)
    equal(preserved.reason,"EXISTING_FOLLOWER_PURPOSE_BOUNDED_BY_LEADER_TRANSITION_PROGRESS_RATE")
    local retired=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,progressPassage=true,provisionalDurationSec=13,minHeadingDot=0.99})
    equal(retired.status,"RETIRE_SUPPORTED")
    equal(retired.reason,"PROGRESS_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION")
end)

test("D-0141 established purpose ignores millimetric corridor-edge noise but still retires on material separation", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=100,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local follower={assemblyId="AS-P",x=36.182,z=-30,dx=0,dz=1,boundaryDistanceM=130,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=25,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local retained=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99,establishedLateralRetentionM=1.0})
    equal(retained.relationship.status,"UNRESOLVED")
    equal(retained.relationship.reason,"ESTABLISHED_FOLLOWER_CORRIDOR_WITHIN_RETENTION_MARGIN")
    equal(retained.status,"UNRESOLVED")
    equal(retained.purposeState,"PERSIST_UNRESOLVED")
    follower.x=40
    local retired=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99,establishedLateralRetentionM=1.0})
    equal(retired.relationship.status,"NEGATIVE")
    equal(retired.status,"RETIRE_SUPPORTED")
    equal(retired.reason,"CURRENT_PRODUCTIVE_WORK_CORRIDORS_DO_NOT_OVERLAP")
end)

test("D-0141 established follower purpose survives clean opposed strategy succession until Progress Passage", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=30,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=4,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=4,nativeZeroCommand=false}
    local follower={assemblyId="AS-P",x=0,z=-28,dx=0,dz=-1,boundaryDistanceM=58,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=4,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25,nativeZeroCommand=false}
    local preserved=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99,establishedOpposedSuccessionMaxDot=-0.95,clearanceFactor=0.90})
    equal(preserved.relationship.status,"UNRESOLVED")
    equal(preserved.relationship.reason,"ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION")
    equal(preserved.status,"UNRESOLVED")
    equal(preserved.purposeState,"PERSIST_UNRESOLVED")
    local retired=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,progressPassage=true,provisionalDurationSec=13,minHeadingDot=0.99,establishedOpposedSuccessionMaxDot=-0.95,clearanceFactor=0.90})
    equal(retired.status,"RETIRE_SUPPORTED")
    equal(retired.reason,"PROGRESS_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION")
end)

test("D-0141 D0146 Established Opposed Corridor Conflict positively retires stale follower purpose before transition preservation", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=30,workingWidthM=36,productivePositive=false,settledContinuation=false,turning=true,progressSpeedKmh=15,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=15}
    local follower={assemblyId="AS-P",x=0,z=-28,dx=0,dz=-1,boundaryDistanceM=58,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=4,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,opposedRelationship={classification="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT",reason="PERSISTENT_OPPOSED_CLOSING_MOTION_WITH_POSITIVE_SUPPORTED_CORRIDOR_OVERLAP"},provisionalDurationSec=13,minHeadingDot=0.99,clearanceFactor=0.90})
    equal(result.status,"RETIRE_SUPPORTED")
    equal(result.purposeState,"RETIRE")
    equal(result.reason,"ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION")
end)

test("D-0141 D0146 positive post-passage relationship invalidation retires stale follower purpose", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=30,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=10,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=10}
    local follower={assemblyId="AS-P",x=0,z=20,dx=0,dz=-1,boundaryDistanceM=50,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=10,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=10}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,opposedRelationship={classification="NO_OPPOSED_CONFLICT",reason="PARTICIPANTS_NOT_MUTUALLY_AHEAD_ON_ESTABLISHED_TRAJECTORIES"},provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.status,"RETIRE_SUPPORTED")
    equal(result.reason,"ESTABLISHED_OPPOSED_PASSAGE_INVALIDATES_FOLLOWER_BOUNDARY_PROTECTION")
end)

test("D-0141 admitted lease is frozen through P22 outbound egress until Progress Passage", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=30,workingWidthM=36,productivePositive=false,settledContinuation=false,progressSpeedKmh=15,nativeCommandValid=false,nativeMoveForwards=nil,nativeMaxSpeedKmh=0,nativeZeroCommand=true}
    local follower={assemblyId="AS-P",x=0,z=-28,dx=0,dz=-1,boundaryDistanceM=58,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=4,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25,nativeZeroCommand=false}
    local preserved=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,headOnOutboundEgress=true,headOnOutboundEgressPhase="TS015_MOVING",provisionalDurationSec=13,minHeadingDot=0.99,clearanceFactor=0.90})
    equal(preserved.status,"UNRESOLVED")
    equal(preserved.purposeState,"PERSIST_UNRESOLVED")
    equal(preserved.reason,"ESTABLISHED_FOLLOWER_LEASE_PRESERVED_DURING_HEAD_ON_OUTBOUND_EGRESS")
    equal(preserved.controlMagnitude,nil)
    equal(preserved.outboundEgress,true)
    local retired=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,headOnOutboundEgress=true,progressPassage=true,provisionalDurationSec=13,minHeadingDot=0.99,clearanceFactor=0.90})
    equal(retired.status,"RETIRE_SUPPORTED")
    equal(retired.reason,"PROGRESS_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION")
end)

test("D-0141 positive GIANTS leader pre-turn slowdown applies the active 0.90 clearance factor", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=30,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=13.9,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=4,nativeZeroCommand=false}
    local follower={assemblyId="AS-P",x=0,z=-60,dx=0,dz=1,boundaryDistanceM=96,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=17,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25,nativeZeroCommand=false}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.status,"REGULATE_SUPPORTED")
    equal(result.purposeState,"PERSIST")
    equal(result.controlMagnitude.leaderNativeCommandKmh,4)
    equal(result.controlMagnitude.leaderRateUsedKmh,4)
    equal(result.controlMagnitude.requestedFollowerCapKmh,3.6)
end)

test("D-0141 turn progression updates preserved cap and positive native reverse may stop follower", function()
    local leader={assemblyId="AS-C",x=0,z=0,dx=0,dz=1,boundaryDistanceM=20,workingWidthM=36,productivePositive=false,settledContinuation=false,turning=true,progressSpeedKmh=3.68,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=15,nativeZeroCommand=false}
    local follower={assemblyId="AS-P",x=0,z=-50,dx=0,dz=1,boundaryDistanceM=70,workingWidthM=36,productivePositive=true,settledContinuation=true,progressSpeedKmh=16.6,nativeCommandValid=true,nativeMoveForwards=true,nativeMaxSpeedKmh=25,nativeZeroCommand=false}
    local result=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99})
    equal(result.status,"REGULATE_SUPPORTED")
    equal(result.transitionPreservation,true)
    equal(math.abs(result.controlMagnitude.requestedFollowerCapKmh-3.312)<0.000001,true)
    -- Even while Productive evidence has not yet fallen away, positive GIANTS
    -- turning supersedes the old line-astern heading test for this existing purpose.
    leader.productivePositive=true; leader.settledContinuation=true; leader.dx=0.6; leader.dz=0.8; leader.progressSpeedKmh=7.87; leader.nativeMaxSpeedKmh=15
    local rotating=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99,establishedAlignmentMinDot=0.95})
    equal(rotating.status,"REGULATE_SUPPORTED")
    equal(rotating.transitionPreservation,true)
    equal(math.abs(rotating.controlMagnitude.requestedFollowerCapKmh-7.083)<0.000001,true)
    leader.productivePositive=false; leader.settledContinuation=false; leader.dx=0; leader.dz=1
    leader.nativeMoveForwards=false; leader.nativeMaxSpeedKmh=15; leader.progressSpeedKmh=2
    local reverse=OuttaMyWay.FollowerBoundaryDemandAssessment.evaluatePair(leader,follower,{existingPurpose=true,provisionalDurationSec=13,minHeadingDot=0.99})
    equal(reverse.status,"REGULATE_SUPPORTED")
    equal(reverse.controlMagnitude.requestedFollowerCapKmh,0)
    equal(reverse.reason,"LEADER_NATIVE_REVERSE_COMMAND_REQUIRES_FOLLOWER_STOP")
end)

local function d0141Picture(record,commitmentId)
    local contexts={}
    if commitmentId~=nil then contexts={{commitmentId=commitmentId}} end
    return OuttaMyWay.OperationalPicture.new({
        identity="OP-D0141-"..tostring(record.reason).."-"..tostring(record.controlMagnitude and record.controlMagnitude.requestedFollowerCapKmh or "x"),epoch=410,observationSnapshotId="OS-HEADON",
        situations={},encounters={},identities={assemblies={"AS-C","AS-P"},components={},jobEpisodes={active={"JE-C","JE-P"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},representationFitness={},
        motionEvidence={},physicalSpaceEvidence={},productiveContinuationKnowledge={},guardedRecoveryKnowledge={},followerBoundaryKnowledge={record},
        provenance={source="d0141-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext=contexts,diagnostics={}
    })
end

local function d0141Record(cap,existingCommitmentId,existingObligationId)
    return {
        pairKey="AS-C|AS-P",operationId="OR-1",leaderAssemblyId="AS-C",followerAssemblyId="AS-P",leaderReferenceKey="vehicle-root:C",followerReferenceKey="vehicle-root:P",
        status="REGULATE_SUPPORTED",purposeState=existingCommitmentId and "PERSIST" or "ADMIT",reason="UNRESTRICTED_NATIVE_FOLLOWER_PROGRESSION_WOULD_MATURE_BEFORE_PROVISIONAL_LEADER_DEMAND_VACATES",
        relationship={status="POSITIVE",reason="CURRENT_COHERENT_LINE_ASTERN_PRODUCTIVE_TOPOLOGY",headingDot=1,leaderToFollowerForwardM=-26,lateralOffsetM=0,corridorHalfWidthM=33,corridorOverlap=true},
        demandSeed={kind="PROVISIONAL_DEMAND_SEED",representationFitness="USABLE_WITH_UNCERTAINTY",uncertainty={"TEMPORAL_SEED_IS_TEST_MECHANIC_NOT_NATIVE_ROUTE_PREDICTION"}},
        controlMagnitude={status="SUPPORTED",regulationRequired=cap<25,nativeUnrestrictedFollowerKmh=25,maxAdmissibleFollowerKmh=cap,requestedFollowerCapKmh=cap},
        representationFitness="USABLE_WITH_UNCERTAINTY",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",existingCommitmentId=existingCommitmentId,existingObligationId=existingObligationId,
        provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
    }
end

test("D-0143 positive Cooperative Passage strategy succession supersedes a preserved D-0141 follower Candidate for the same pair", function()
    local runtime=autonomousHeadOnRuntime()
    local preserved={
        pairKey="AS-00001|AS-00002",operationId="OR-1",leaderAssemblyId="AS-00001",followerAssemblyId="AS-00002",
        leaderReferenceKey="vehicle-root:101",followerReferenceKey="vehicle-root:201",
        status="UNRESOLVED",purposeState="PERSIST_UNRESOLVED",reason="ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION",
        relationship={status="UNRESOLVED",reason="ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION",headingDot=-1,leaderToFollowerForwardM=34,lateralOffsetM=0,corridorHalfWidthM=36,corridorOverlap=true},
        representationFitness="UNRESOLVED",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
        existingCommitmentId="CM-EXISTING",existingObligationId="OB-FOLLOWER",provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE"}
    }
    local base=d0143Picture({commitmentContext={{commitmentId="CM-EXISTING"}},followerBoundaryKnowledge={preserved}})
    local supported=runtime.liveTrafficCandidateSupport:attach(base,headOnTestSnapshot())
    equal(supported.candidateSupportEvidence.supportBoundary.mode,"TS015_COOPERATIVE_PASSAGE_PRODUCTION_TEST")
    equal(supported.provenance.followerBoundarySupportingLeaseRetained,true)
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    equal(evaluated.decision.commitmentAction,"REVISE")
    local selected=nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(evaluated.candidates) do if candidate.identity==evaluated.decision.selectedCandidateId then selected=candidate end end
    if selected==nil then error("expected selected Cooperative Passage candidate") end
    equal(selected.capability,"REPOSITION"); equal(#selected.subject.assemblyIds,2)
end)

test("D-0143 Cooperative Passage reuses the same D-0141 Commitment, clears its speed lease and acquires joint progress authority", function()
    local runtime=autonomousHeadOnRuntime()
    local followerRecord={
        pairKey="AS-00001|AS-00002",operationId="OR-1",leaderAssemblyId="AS-00001",followerAssemblyId="AS-00002",
        leaderReferenceKey="vehicle-root:101",followerReferenceKey="vehicle-root:201",status="REGULATE_SUPPORTED",purposeState="ADMIT",
        reason="UNRESTRICTED_NATIVE_FOLLOWER_PROGRESSION_WOULD_MATURE_BEFORE_PROVISIONAL_LEADER_DEMAND_VACATES",
        relationship={status="POSITIVE",reason="CURRENT_COHERENT_LINE_ASTERN_PRODUCTIVE_TOPOLOGY",headingDot=1,leaderToFollowerForwardM=-26,lateralOffsetM=0,corridorHalfWidthM=33,corridorOverlap=true},
        demandSeed={kind="PROVISIONAL_DEMAND_SEED",representationFitness="USABLE_WITH_UNCERTAINTY",uncertainty={"TEMPORAL_SEED_IS_TEST_MECHANIC_NOT_NATIVE_ROUTE_PREDICTION"}},
        controlMagnitude={status="SUPPORTED",regulationRequired=true,nativeUnrestrictedFollowerKmh=25,maxAdmissibleFollowerKmh=8,requestedFollowerCapKmh=8},
        representationFitness="USABLE_WITH_UNCERTAINTY",governingPurpose="PRESERVE_BOUNDARY_TRANSITION_ORDERING",
        provenance={source="FollowerBoundaryDemandAssessment",layer="KNOWLEDGE",historicalNativeManoeuvreAuthority=false}
    }
    local function followerPicture(record,commitmentId)
        local contexts={} if commitmentId~=nil then contexts={{commitmentId=commitmentId}} end
        return OuttaMyWay.OperationalPicture.new({
            identity="OP-D0141-COOP-"..tostring(commitmentId or "NEW"),epoch=610,observationSnapshotId="OS-HEADON",situations={},encounters={},
            identities={assemblies={"AS-00001","AS-00002"},components={},jobEpisodes={active={"JE-A","JE-B"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
            currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},representationFitness={},
            motionEvidence={},physicalSpaceEvidence={},productiveContinuationKnowledge={},guardedRecoveryKnowledge={},followerBoundaryKnowledge={record},cooperativePassageKnowledge={},
            provenance={source="d0141-cooperative-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext=contexts,diagnostics={}
        })
    end
    local cleared={}; local regulationRequests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) regulationRequests[#regulationRequests+1]=request; return true,"ACCEPTED" end
    function capability:clearRegulationLeaseByReference(referenceKey,ownerTag) cleared[#cleared+1]={referenceKey=referenceKey,ownerTag=ownerTag}; return true end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local followerBase=followerPicture(followerRecord,nil)
    local followerSupported=runtime.liveTrafficCandidateSupport:attach(followerBase,headOnTestSnapshot())
    local followerEval=runtime:evaluateSealedOperationalPicture(followerSupported)
    local followerDispatch=runtime.liveControlDispatcher:dispatch(followerSupported,followerEval)
    equal(followerDispatch.status,"ACCEPTED")
    local commitmentId=followerDispatch.commitment.identity
    local followerObligationId=followerDispatch.obligation and followerDispatch.obligation.identity or runtime.obligations:openForOwner(commitmentId)[1].identity
    equal(runtime.authorities:ownerOf("AS-00002"),commitmentId)
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().active,true)

    local preserved={} for key,value in pairs(followerRecord) do preserved[key]=value end
    preserved.status="UNRESOLVED"; preserved.purposeState="PERSIST_UNRESOLVED"; preserved.reason="ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION"
    preserved.relationship={status="UNRESOLVED",reason="ESTABLISHED_PURPOSE_PRESERVED_THROUGH_OPPOSED_CONTINUATION",headingDot=-1,leaderToFollowerForwardM=34,lateralOffsetM=0,corridorHalfWidthM=36,corridorOverlap=true}
    preserved.representationFitness="UNRESOLVED"; preserved.controlMagnitude=nil; preserved.existingCommitmentId=commitmentId; preserved.existingObligationId=followerObligationId

    local accepted=nil; local completionHandler=nil
    local cooperativeControl={}
    function cooperativeControl:setCompletionHandler(fn) completionHandler=fn end
    function cooperativeControl:isActive() return false end
    function cooperativeControl:executeJointRequests(a,b,candidate) accepted={a,b,candidate}; return true,"COOPERATIVE_PASSAGE_STARTED" end
    runtime.liveControlDispatcher:setCooperativePassageControl(cooperativeControl)

    local cooperativeBase=d0143Picture({identity="OP-D0143-SUCCESSION",epoch=611,commitmentContext={{commitmentId=commitmentId}},followerBoundaryKnowledge={preserved}})
    local cooperativeSupported=runtime.liveTrafficCandidateSupport:attach(cooperativeBase,headOnTestSnapshot())
    local cooperativeEval=runtime:evaluateSealedOperationalPicture(cooperativeSupported)
    equal(cooperativeEval.decision.commitmentAction,"REVISE")
    local dispatched=runtime.liveControlDispatcher:dispatch(cooperativeSupported,cooperativeEval)
    equal(dispatched.status,"ACCEPTED"); equal(dispatched.commitment.identity,commitmentId)
    equal(runtime.authorities:ownerOf("AS-00001"),commitmentId); equal(runtime.authorities:ownerOf("AS-00002"),commitmentId)
    equal(#runtime.authorities:tokensForCommitment(commitmentId),2)
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().active,false)
    equal(#cleared,1); equal(cleared[1].referenceKey,"vehicle-root:201"); equal(cleared[1].ownerTag,"D0141_FOLLOWER_BOUNDARY")
    equal(runtime.obligations:get(followerObligationId).status,"SETTLED")
    equal(#accepted,3); equal(accepted[1].capability,"REPOSITION"); equal(accepted[2].capability,"REPOSITION")
    equal(type(completionHandler),"function")
end)

test("D-0141 aligned follower Regulation travels Situation Candidate Decision Commitment central Control and cap magnitude is elastic", function()
    local runtime=autonomousHeadOnRuntime()
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) requests[#requests+1]=request; return true,request.target.operation end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local firstBase=d0141Picture(d0141Record(12,nil,nil),nil)
    local first=runtime.liveTrafficCandidateSupport:attach(firstBase,headOnTestSnapshot())
    equal(first.candidateSupportEvidence.supportBoundary.mode,"FOLLOWER_BOUNDARY_D0141")
    local firstEval=runtime:evaluateSealedOperationalPicture(first)
    equal(firstEval.decision.commitmentAction,"CREATE")
    local firstCandidate=nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(firstEval.candidates) do if candidate.identity==firstEval.decision.selectedCandidateId then firstCandidate=candidate end end
    equal(firstCandidate.capability,"REGULATE_SPEED")
    local admitted=runtime.liveControlDispatcher:dispatch(first,firstEval)
    equal(admitted.status,"ACCEPTED")
    equal(admitted.followerBoundary,true)
    equal(requests[#requests].target.ownerTag,"D0141_FOLLOWER_BOUNDARY")
    equal(requests[#requests].target.maxSpeedKmh,12)
    local commitmentId=admitted.commitment.identity
    local open=runtime.obligations:openForOwner(commitmentId)
    equal(#open,1)
    local obligationId=open[1].identity
    equal(open[1].basis.kind,"FOLLOWER_BOUNDARY_PROTECTION")
    equal(runtime.authorities:ownerOf("AS-P"),commitmentId)

    -- Same sticky purpose, but current evidence now supports a higher cap.  The
    -- dispatcher must raise the owner-tag lease instead of preserving the
    -- historical minimum-ever cap.
    local secondBase=d0141Picture(d0141Record(20,commitmentId,obligationId),commitmentId)
    local second=runtime.liveTrafficCandidateSupport:attach(secondBase,headOnTestSnapshot())
    local secondEval=runtime:evaluateSealedOperationalPicture(second)
    equal(secondEval.decision.commitmentAction,"MAINTAIN")
    local updated=runtime.liveControlDispatcher:dispatch(second,secondEval)
    equal(updated.status,"ACCEPTED")
    equal(updated.elasticUpdate,true)
    equal(requests[#requests].target.maxSpeedKmh,20)
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().currentCapKmh,20)

    -- The same purpose must also tighten again when the current sealed picture
    -- requires it; elasticity is bidirectional rather than relaxation-only.
    local thirdBase=d0141Picture(d0141Record(8,commitmentId,obligationId),commitmentId)
    local third=runtime.liveTrafficCandidateSupport:attach(thirdBase,headOnTestSnapshot())
    local thirdEval=runtime:evaluateSealedOperationalPicture(third)
    local tightened=runtime.liveControlDispatcher:dispatch(third,thirdEval)
    equal(tightened.status,"ACCEPTED")
    equal(tightened.elasticUpdate,true)
    equal(requests[#requests].target.maxSpeedKmh,8)
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().currentCapKmh,8)

    local retireRecord=d0141Record(25,commitmentId,obligationId)
    retireRecord.status="RETIRE_SUPPORTED"; retireRecord.purposeState="RETIRE"; retireRecord.reason="PROGRESS_PASSAGE_SUPERSEDES_FOLLOWER_BOUNDARY_PROTECTION"; retireRecord.controlMagnitude=nil
    local retireBase=d0141Picture(retireRecord,commitmentId)
    local retire=runtime.liveTrafficCandidateSupport:attach(retireBase,headOnTestSnapshot())
    local retireEval=runtime:evaluateSealedOperationalPicture(retire)
    equal(retireEval.decision.commitmentAction,"MAINTAIN")
    local released=runtime.liveControlDispatcher:dispatch(retire,retireEval)
    equal(released.status,"RELEASED")
    equal(requests[#requests].target.operation,"RELEASE")
    equal(requests[#requests].target.ownerTag,"D0141_FOLLOWER_BOUNDARY")
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().active,false)
    equal(runtime.authorities:ownerOf("AS-P"),nil)
    equal(runtime.obligations:get(obligationId).status,"SETTLED")
    equal(runtime.commitments:get(commitmentId).state,"SUCCEEDED")
end)



test("D-0141 follower and D-0123 Guarded-Recovery Regulation purposes share authority but release owner-tag leases independently", function()
    local runtime=autonomousHeadOnRuntime()
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) requests[#requests+1]=request; return true,request.target.operation end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local first=runtime.liveTrafficCandidateSupport:attach(d0141Picture(d0141Record(14,nil,nil),nil),headOnTestSnapshot())
    local firstEval=runtime:evaluateSealedOperationalPicture(first)
    local admitted=runtime.liveControlDispatcher:dispatch(first,firstEval)
    local commitmentId=admitted.commitment.identity
    equal(runtime.authorities:ownerOf("AS-P"),commitmentId)

    local function guardPicture(status)
        return OuttaMyWay.OperationalPicture.new({
            identity="OP-D0141-GUARD-"..status,epoch=500,observationSnapshotId="OS-HEADON",
            situations={},encounters={},identities={assemblies={"AS-C","AS-P"},components={},jobEpisodes={active={"JE-C","JE-P"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
            currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},
            representationFitness={{representationId="REP-D0141-GUARD",assemblyId="AS-P",question="GUARDED_RECOVERY_CONVERGENT_PROJECTION",assessmentHorizon="CURRENT_BOUNDED_RECOVERY",state=status=="POSITIVE" and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",claimPermissions={"GUARDED_RECOVERY"},coverage={complete=false,conservative=true},uncertainty={},validityDependencies={},provenance={source="d0141-test"}}},
            motionEvidence={},physicalSpaceEvidence={},productiveContinuationKnowledge={},
            guardedRecoveryKnowledge={{representationId="REP-D0141-GUARD",commitmentId=commitmentId,controlRequestId="CR-REPOSITION",governingRequirementKey="guarded-recovery:"..commitmentId,encounterIdentity="EN-X",yieldAssemblyId="AS-C",progressAssemblyId="AS-P",yieldReferenceKey="vehicle-root:C",progressReferenceKey="vehicle-root:P",progressJobToken="JOB-P",phase="TS015_REJOINING",activeRecovery=true,postHandoff=false,nativeReacquired=false,signalStatus=status,reason=status=="POSITIVE" and "CONVERGENT_PROJECTION_INTERSECTS_VULNERABLE_SPACE" or "POSITIVE_CURRENT_HEADING_CLEAR_OF_VULNERABLE_SPACE",combination="COMMITTED_RECOVERY_UNION__CURRENT_HEADING",geometryResolved=true,governingPurpose="PRESERVE_GUARDED_RECOVERY_COMMITTED_DEMAND",representationFitness=status=="POSITIVE" and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",provenance={source="SituationAssessment.GuardedRecovery",layer="KNOWLEDGE"}}},
            followerBoundaryKnowledge={d0141Record(14,commitmentId,runtime.obligations:openForOwner(commitmentId)[1].identity)},
            provenance={source="d0141-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext={{commitmentId=commitmentId}},diagnostics={}
        })
    end

    local guardPositive=runtime.liveTrafficCandidateSupport:attach(guardPicture("POSITIVE"),headOnTestSnapshot())
    equal(guardPositive.candidateSupportEvidence.supportBoundary.mode,"GUARDED_RECOVERY_D0123")
    local guardPositiveEval=runtime:evaluateSealedOperationalPicture(guardPositive)
    local guarded=runtime.liveControlDispatcher:dispatch(guardPositive,guardPositiveEval)
    equal(guarded.status,"ACCEPTED")
    equal(requests[#requests].target.ownerTag,"D0123_GUARDED_RECOVERY")
    equal(runtime.authorities:ownerOf("AS-P"),commitmentId)
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().active,true)

    local guardNegative=runtime.liveTrafficCandidateSupport:attach(guardPicture("NEGATIVE"),headOnTestSnapshot())
    local guardNegativeEval=runtime:evaluateSealedOperationalPicture(guardNegative)
    local released=runtime.liveControlDispatcher:dispatch(guardNegative,guardNegativeEval)
    equal(released.status,"RELEASED")
    equal(requests[#requests].target.ownerTag,"D0123_GUARDED_RECOVERY")
    equal(runtime.authorities:ownerOf("AS-P"),commitmentId)
    equal(runtime.liveControlDispatcher:getFollowerBoundaryStatus().active,true)
end)

test("D-0124 follower shadow derives a lower cap when unrestricted demand would be consumed", function()
    local leader={x=0,z=0,dx=1,dz=0}
    local follower={x=-10,z=0,dx=1,dz=0}
    local rep={worldPrimitives={{kind="DISC",positiveConflictSupport=true,x=-10,z=0,radius=2}}}
    local demand={entryBoundaryDistanceM=28,durationMs=12000,sweep={minForward=-18,maxForward=23,minLateral=-20,maxLateral=54}}
    local r=OuttaMyWay.FollowerMaturationCompressionProbe.evaluateShadow(leader,100,25,follower,rep,25,demand)
    equal(r.status,"REGULATE_SUPPORTED")
    equal(r.maxAdmissibleFollowerKmh < 25,true)
end)

test("D-0124 follower maturation is shadow-only and owns no drive authority", function()
    local probe=OuttaMyWay.FollowerMaturationCompressionProbe.new({},nil,nil)
    equal(probe.setDriveAuthoritySource,nil)
    equal(probe._applyOrUpdate,nil)
    equal(OuttaMyWay.FOLLOWER_MATURATION_REGULATION_TEST_ENABLED,false)
end)


test("D-0130 tighten-only follower cap implementation is removed from active diagnostic path", function()
    local probe=OuttaMyWay.FollowerMaturationCompressionProbe.new({},nil,nil)
    equal(probe._applyOrUpdate,nil)
    equal(probe.activeByFollower,nil)
    equal(type(probe.shadowByFollower),"table")
end)


test("D-0124 unresolved boundary demand cannot acquire Control authority", function()
    local leader={x=0,z=0,dx=1,dz=0}
    local follower={x=-10,z=0,dx=1,dz=0}
    local r=OuttaMyWay.FollowerMaturationCompressionProbe.evaluateShadow(leader,100,25,follower,nil,25,{entryBoundaryDistanceM=28,durationMs=12000,sweep={minForward=-18,maxForward=23,minLateral=-20,maxLateral=54}})
    equal(r.status,"UNRESOLVED")
    equal(r.reason,"FOLLOWER_REPRESENTATION_UNAVAILABLE")
end)


test("D-0124 opposed or non-trailing geometry is descriptive non-applicability only", function()
    local rep={worldPrimitives={{kind="DISC",positiveConflictSupport=true,x=-10,z=0,radius=2}}}
    local demand={entryBoundaryDistanceM=28,durationMs=12000,sweep={minForward=-18,maxForward=23,minLateral=-20,maxLateral=54}}
    local opposed=OuttaMyWay.FollowerMaturationCompressionProbe.evaluateShadow({x=0,z=0,dx=1,dz=0},100,25,{x=-10,z=0,dx=-1,dz=0},rep,25,demand)
    equal(opposed.status,"NOT_APPLICABLE"); equal(opposed.reason,"CONTINUATIONS_NOT_POSITIVELY_ALIGNED")
    local ahead=OuttaMyWay.FollowerMaturationCompressionProbe.evaluateShadow({x=0,z=0,dx=1,dz=0},100,25,{x=10,z=0,dx=1,dz=0},rep,25,demand)
    equal(ahead.status,"NOT_APPLICABLE"); equal(ahead.reason,"NO_TRAILING_RELATIONSHIP")
end)


test("D-0130 regulation leases compose by least-permissive cap and release independently", function()
    local oldAIVehicleUtil=AIVehicleUtil
    AIVehicleUtil={driveToPoint=function(...) return true end}
    local authority=OuttaMyWay.Prototype22DriveAuthority.new()
    local vehicle={name="Patriot"}
    local ok=authority:setRegulationLease(vehicle,17.1,"MATURATION")
    equal(ok,true)
    equal(authority:getState(vehicle).speedKmh,17.1)
    equal(authority:hasRegulationLease(vehicle,"MATURATION"),true)
    ok=authority:setRegulationLease(vehicle,1.0,"GUARDED_RECOVERY")
    equal(ok,true)
    equal(authority:getState(vehicle).speedKmh,1.0)
    equal(authority:hasRegulationLease(vehicle,"MATURATION"),true)
    equal(authority:hasRegulationLease(vehicle,"GUARDED_RECOVERY"),true)
    equal(authority:clearRegulationLease(vehicle,"GUARDED_RECOVERY"),true)
    equal(authority:getState(vehicle).speedKmh,17.1)
    equal(authority:hasRegulationLease(vehicle,"MATURATION"),true)
    equal(authority:clearRegulationLease(vehicle,"MATURATION"),true)
    equal(authority:getState(vehicle),nil)
    AIVehicleUtil=oldAIVehicleUtil
end)

test("D-0130 follower strategy succession no longer lives in the diagnostic probe", function()
    local probe=OuttaMyWay.FollowerMaturationCompressionProbe.new({},nil,nil)
    equal(probe._strategySupersessionReason,nil)
    equal(probe._positiveRetirementReason,nil)
end)


test("D-0139 Progress Passage semantics are removed from P22 capability ownership", function()
    equal(OuttaMyWay.Prototype22CapabilityGate.progressPassageContextForRun,nil)
    local probe=OuttaMyWay.FollowerMaturationCompressionProbe.new({},nil,nil)
    equal(probe.setPurposeSuccessionSource,nil)
    equal(probe._retireForProgressPassage,nil)
end)


test("D-0139 authority reset prevents any follower-compression lease from existing", function()
    local probe=OuttaMyWay.FollowerMaturationCompressionProbe.new({},nil,nil)
    equal(OuttaMyWay.FOLLOWER_MATURATION_REGULATION_TEST_ENABLED,false)
    equal(probe.setDriveAuthoritySource,nil)
    equal(probe.activeByFollower,nil)
    equal(type(probe.shadowByFollower),"table")
end)


test("D-0127 deferred native manoeuvre closure freezes measurement while boundary-demand fitness stays unresolved", function()
    local source=OuttaMyWay.NativeManoeuvreObservationSource.new({})
    local state={
        run=91,vehicle={name="Condor"},ref="vehicle-root:91",name="Condor",jobToken="JOB-C",startMs=1000,
        entryPose={x=0,z=0,dx=1,dz=0},entryBoundaryDistanceM=10,entrySpeedKmh=25,
        samples={
            {elapsedMs=0,localEnvelope={minForward=-20,maxForward=20,minLateral=-5,maxLateral=5}},
            {elapsedMs=200,localEnvelope={minForward=-20,maxForward=20,minLateral=-6,maxLateral=6}}
        },
        controlInfluenced=false,phase="WAITING_FOR_EVIDENCE",measurementEndMs=1200,
        measurementExitPose={x=2,z=0,dx=-1,dz=0}
    }
    source.states[state.ref]=state
    source:_finish(state,1500,{x=20,z=0,dx=-1,dz=0},"GIANTS_TURN_SEGMENT_ENDED_AFTER_WAITING_FOR_EVIDENCE")
    local observations=source:getObservations(state.ref,"JOB-C")
    equal(#observations,1)
    equal(observations[1].durationMs,200)
    equal(observations[1].exitForwardM,2)
    equal(observations[1].representationFitnessForBoundaryDemand,"UNRESOLVED")
    equal(observations[1].boundaryDemandAuthority,false)
    equal(source.states[state.ref],nil)
end)


test("D-0127 new turn before settled continuation cannot promote a native manoeuvre observation", function()
    local source=OuttaMyWay.NativeManoeuvreObservationSource.new({})
    local state={
        run=92,vehicle={name="Condor"},ref="vehicle-root:92",name="Condor",jobToken="JOB-C",startMs=1000,
        entryPose={x=0,z=0,dx=1,dz=0},entryBoundaryDistanceM=10,entrySpeedKmh=25,
        samples={{elapsedMs=200,localEnvelope={minForward=-20,maxForward=20,minLateral=-5,maxLateral=5}}},
        controlInfluenced=false,phase="WAITING_FOR_EVIDENCE",measurementEndMs=1200,
        measurementExitPose={x=2,z=0,dx=-1,dz=0}
    }
    source.states[state.ref]=state
    source:_finish(state,1400,{x=3,z=0,dx=0,dz=1},"NEW_TURN_SEGMENT_BEFORE_SETTLED_CONTINUATION")
    equal(#source:getObservations(state.ref,"JOB-C"),0)
end)


test("D-0126 empirical Transition-Clearance factor remains visible in legacy shadow and is restored explicitly to aligned D-0141", function()
    equal(OuttaMyWay.FOLLOWER_MATURATION_TRANSITION_CLEARANCE_FACTOR,0.90)
    equal(OuttaMyWay.FOLLOWER_BOUNDARY_TRANSITION_CLEARANCE_FACTOR,0.90)
    equal(OuttaMyWay.FOLLOWER_MATURATION_REGULATION_TEST_ENABLED,false)
    local probe=OuttaMyWay.FollowerMaturationCompressionProbe.new({},nil,nil)
    equal(probe._applyOrUpdate,nil)
end)


test("D-0129 ray-capsule witness distance is geometric and positive-only", function()
    local d,reason=OuttaMyWay.ProgressionPreservationProbe.rayCapsuleEntry(0,0,1,0,10,0,20,0,2)
    equal(math.abs(d-8)<0.000001,true)
    equal(reason,"RAY_CAPSULE_ENTRY")
end)

test("D-0129 subject projection reports represented witness within local-intent horizon", function()
    local subject={dx=1,dz=0,projectionLimitM=20,discs={{identity="S1",x=0,z=0,radius=1}}}
    local region={kind="CAPSULE",ax=10,az=0,bx=10,bz=0,radius=1}
    local r=OuttaMyWay.ProgressionPreservationProbe.evaluateSubjectAgainstRegion(subject,region)
    equal(r.status,"POSITIVE_WITNESS_WITHIN_LOCAL_INTENT")
    equal(math.abs(r.knownWitnessEntryM-8)<0.000001,true)
    equal(r.negativeClearanceAuthority,false)
    equal(r.responseAdjustedSupportableProgression,"UNRESOLVED")
end)

test("D-0129 represented witness beyond bounded native horizon cannot claim current progression pressure", function()
    local subject={dx=1,dz=0,projectionLimitM=5,discs={{identity="S1",x=0,z=0,radius=1}}}
    local region={kind="CAPSULE",ax=10,az=0,bx=10,bz=0,radius=1}
    local r=OuttaMyWay.ProgressionPreservationProbe.evaluateSubjectAgainstRegion(subject,region)
    equal(r.status,"POSITIVE_WITNESS_BEYOND_LOCAL_INTENT")
    equal(r.withinLocalIntentHorizon,false)
end)



test("D-0133 retained Progress horizon survives the pre-handoff seam and preserves a fixed endpoint", function()
    local bridge=OuttaMyWay.CommittedTransitionRegulationTestBridge.new()
    local ok,reason=bridge:retainPositiveProgressHorizon({
        progressName="Patriot",referenceKey="vehicle-root:P",jobToken="JOB-P",intentEpoch=7,
        intentValid=true,intentClassification="SETTLED_CONTINUATION",productivePositive=true,movingDirection=1,
        x=10,z=0,dx=1,dz=0,boundaryM=90,nowMs=1000,source="TEST_FIELD_BOUNDARY"
    })
    equal(ok,true); equal(reason,"RETAINED")
    local retained=bridge.retainedProgressHorizons["vehicle-root:P"]
    equal(retained~=nil,true)
    equal(math.abs(retained.boundaryX-100)<0.000001,true)
    equal(math.abs(retained.boundaryZ)<0.000001,true)

    -- Advancing the worker shrinks the distance to the same retained endpoint;
    -- it does not redefine a new moving baseline.
    local current={jobToken="JOB-P",intentEpoch=7,intentValid=true,intentClassification="SETTLED_CONTINUATION",productivePositive=true,movingDirection=1,x=25,z=0}
    local remaining,source=OuttaMyWay.CommittedTransitionRegulationTestBridge.remainingSealedBoundary(retained,current)
    equal(math.abs(remaining-75)<0.000001,true)
    equal(source,"SEALED_AT_COMMITTED_TRANSITION_ADMISSION")
end)

test("D-0132 sealed Progress horizon bridges only the same positive Job and Local Intent epoch", function()
    local sealed={jobToken="JOB-P",intentEpoch=7,boundaryX=100,boundaryZ=0,dx=1,dz=0}
    local current={jobToken="JOB-P",intentEpoch=7,intentValid=true,intentClassification="SETTLED_CONTINUATION",productivePositive=true,movingDirection=1,x=10,z=0}
    local remaining,source=OuttaMyWay.CommittedTransitionRegulationTestBridge.remainingSealedBoundary(sealed,current)
    equal(math.abs(remaining-90)<0.000001,true)
    equal(source,"SEALED_AT_COMMITTED_TRANSITION_ADMISSION")

    local changed={} for k,v in pairs(current) do changed[k]=v end
    changed.intentEpoch=8
    local unavailable,reason=OuttaMyWay.CommittedTransitionRegulationTestBridge.remainingSealedBoundary(sealed,changed)
    equal(unavailable,nil)
    equal(reason,"SEALED_PROGRESS_INTENT_EPOCH_CHANGED")

    local transitional={} for k,v in pairs(current) do transitional[k]=v end
    transitional.intentValid=false; transitional.intentClassification="TURNING"
    unavailable,reason=OuttaMyWay.CommittedTransitionRegulationTestBridge.remainingSealedBoundary(sealed,transitional)
    equal(unavailable,nil)
    equal(reason,"SEALED_PROGRESS_LOCAL_INTENT_NO_LONGER_SETTLED")
end)

test("D-0131 committed egress threat requires positive Productive bounded timing evidence", function()
    local base={
        progressExpectedJobToken="JOB-P",progressEvidenceJobToken="JOB-P",progressProductivePositive=true,progressMovingDirection=1,
        progressEntryM=30,progressBoundaryM=100,progressSpeedMps=18.6/3.6,egressRemainingM=30,egressSpeedCeilingMps=15/3.6
    }
    local positive=OuttaMyWay.CommittedTransitionRegulationTestBridge.evaluateSignal(base)
    equal(positive.status,"POSITIVE")
    equal(positive.reason,"PROGRESS_ENTRY_NOT_LATER_THAN_IDEAL_EGRESS_COMPLETION_LOWER_BOUND")

    local far={} for k,v in pairs(base) do far[k]=v end
    far.progressEntryM=300
    equal(OuttaMyWay.CommittedTransitionRegulationTestBridge.evaluateSignal(far).status,"UNRESOLVED")

    local beyond={} for k,v in pairs(base) do beyond[k]=v end
    beyond.progressBoundaryM=20
    equal(OuttaMyWay.CommittedTransitionRegulationTestBridge.evaluateSignal(beyond).reason,"EGRESS_SWEEP_INTERSECTION_BEYOND_CURRENT_FIELD_BOUNDED_CONTINUATION")

    local transitional={} for k,v in pairs(base) do transitional[k]=v end
    transitional.progressProductivePositive=false
    equal(OuttaMyWay.CommittedTransitionRegulationTestBridge.evaluateSignal(transitional).reason,"POSITIVE_PRODUCTIVE_CONTINUATION_UNAVAILABLE")
end)

test("D-0131 committed-transition timing remains passive shadow and cannot acquire a lease", function()
    local bridge=OuttaMyWay.CommittedTransitionRegulationTestBridge.new()
    equal(OuttaMyWay.COMMITTED_TRANSITION_REGULATION_TEST_ENABLED,false)
    equal(bridge.driveAuthority,nil)
    equal(bridge.active,nil)
    local sample={
        progressExpectedJobToken="JOB-P",progressEvidenceJobToken="JOB-P",progressProductivePositive=true,progressMovingDirection=1,
        progressEntryM=20,progressBoundaryM=100,progressSpeedMps=18.6/3.6,egressRemainingM=30,egressSpeedCeilingMps=15/3.6
    }
    local signal=OuttaMyWay.CommittedTransitionRegulationTestBridge.evaluateSignal(sample)
    equal(signal.status,"POSITIVE")
    equal(bridge.active,nil)
end)


test("architecture alignment routes D-0123 through Situation Candidate Decision Commitment and central Control", function()
    local runtime=autonomousHeadOnRuntime()
    -- D-0143 retired the old unilateral TS015 head-on admission path.  D-0123
    -- remains independently testable against any already-live recovery Commitment,
    -- so establish the minimal existing recovery ownership directly.
    local yieldAssemblyId="AS-00001"
    local progressAssemblyId="AS-00002"
    local progressJobToken="job-B"
    local admitted=runtime.commitmentAdmission:admit({
        objective={kind="LEGACY_GUARDED_RECOVERY_TEST"},
        governingBasis={responsibilityKey="guarded-recovery-test:EN-HEADON"},
        progressAssemblyIds={yieldAssemblyId}
    })
    local commitmentId=admitted.commitment.identity
    local bridge={yieldParticipantReferenceKey="vehicle-root:101",progressParticipantReferenceKey="vehicle-root:201"}
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate)
        requests[#requests+1]=request
        return true,tostring(request.target and request.target.operation or "ACCEPTED")
    end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local function guardPicture(status,guardReason)
        local repId="REP-GUARD-"..status
        return OuttaMyWay.OperationalPicture.new({
            identity="OP-GUARD-"..status,epoch=300+#requests,observationSnapshotId="OS-HEADON",
            situations={},encounters={},identities={assemblies={"AS-00001","AS-00002"},components={},jobEpisodes={active={"JE-A","JE-B"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
            currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},
            representationFitness={{representationId=repId,assemblyId=progressAssemblyId,question="GUARDED_RECOVERY_CONVERGENT_PROJECTION",assessmentHorizon="CURRENT_BOUNDED_RECOVERY",state=status=="POSITIVE" and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",claimPermissions={"GUARDED_RECOVERY"},coverage={complete=false,conservative=true},uncertainty={},validityDependencies={},provenance={source="alignment-test"}}},
            guardedRecoveryKnowledge={{representationId=repId,commitmentId=commitmentId,controlRequestId="CR-REPOSITION",governingRequirementKey="guarded-recovery:"..commitmentId,encounterIdentity="EN-HEADON",yieldAssemblyId=yieldAssemblyId,progressAssemblyId=progressAssemblyId,yieldReferenceKey=bridge.yieldParticipantReferenceKey,progressReferenceKey=bridge.progressParticipantReferenceKey,progressJobToken=progressJobToken,phase="TS015_REJOINING",activeRecovery=true,postHandoff=false,nativeReacquired=false,signalStatus=status,reason=guardReason or status,combination="COMMITTED_RECOVERY_UNION__CURRENT_HEADING",geometryResolved=status~="UNRESOLVED",governingPurpose="PRESERVE_GUARDED_RECOVERY_COMMITTED_DEMAND",representationFitness=status=="POSITIVE" and "FIT_FOR_LIMITED_HORIZON" or "REFRESH_REQUIRED",provenance={source="SituationAssessment.GuardedRecovery",layer="KNOWLEDGE"}}},
            provenance={source="alignment-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext={{commitmentId=commitmentId}},diagnostics={}
        })
    end

    local positive=runtime.liveTrafficCandidateSupport:attach(guardPicture("POSITIVE","CONVERGENT_PROJECTION_INTERSECTS_VULNERABLE_SPACE"),headOnTestSnapshot())
    equal(positive.candidateSupportEvidence.supportBoundary.mode,"GUARDED_RECOVERY_D0123")
    local positiveEval=runtime:evaluateSealedOperationalPicture(positive)
    equal(positiveEval.decision.commitmentAction,"MAINTAIN")
    local positiveCandidate=nil
    for _,candidate in OuttaMyWay.ValueRecord.ipairs(positiveEval.candidates) do if candidate.identity==positiveEval.decision.selectedCandidateId then positiveCandidate=candidate end end
    equal(positiveCandidate.capability,"REGULATE_SPEED")
    local dispatched=runtime.liveControlDispatcher:dispatch(positive,positiveEval)
    equal(dispatched.status,"ACCEPTED")
    equal(requests[#requests].target.operation,"APPLY")
    equal(runtime.authorities:ownerOf(yieldAssemblyId),commitmentId)
    equal(runtime.authorities:ownerOf(progressAssemblyId),commitmentId)
    equal(#runtime.authorities:tokensForCommitment(commitmentId),2)

    local unresolved=runtime.liveTrafficCandidateSupport:attach(guardPicture("UNRESOLVED","PROGRESS_CONTINUATION_UNRESOLVED"),headOnTestSnapshot())
    local unresolvedEval=runtime:evaluateSealedOperationalPicture(unresolved)
    equal(unresolvedEval.decision.commitmentAction,"MAINTAIN")
    local before=#requests
    local maintained=runtime.liveControlDispatcher:dispatch(unresolved,unresolvedEval)
    equal(maintained.reason,"D0123_UNRESOLVED_PRESERVE_EXISTING_REGULATION")
    equal(#requests,before)
    equal(runtime.authorities:ownerOf(progressAssemblyId),commitmentId)

    local negative=runtime.liveTrafficCandidateSupport:attach(guardPicture("NEGATIVE","POSITIVE_CURRENT_HEADING_CLEAR_OF_VULNERABLE_SPACE"),headOnTestSnapshot())
    local negativeEval=runtime:evaluateSealedOperationalPicture(negative)
    equal(negativeEval.decision.commitmentAction,"MAINTAIN")
    local released=runtime.liveControlDispatcher:dispatch(negative,negativeEval)
    equal(released.status,"RELEASED")
    equal(requests[#requests].target.operation,"RELEASE")
    equal(runtime.authorities:ownerOf(progressAssemblyId),nil)
    equal(runtime.authorities:ownerOf(yieldAssemblyId),commitmentId)
    equal(#runtime.authorities:tokensForCommitment(commitmentId),1)
end)

test("D0134 productive coverage raster paints only cells inside swept marker quadrilateral",function()
    local previous={left={x=0,z=0},right={x=10,z=0},width=10,source="TEST"}
    local current={left={x=0,z=5},right={x=10,z=5},width=10,source="TEST"}
    local cells=OuttaMyWay.DemonstratedProductiveCoverageProbe.rasterizeQuadCells(previous,current,5)
    equal(#cells,2)
    equal(OuttaMyWay.DemonstratedProductiveCoverageProbe.coverageClassFromSamples(13,13),"FULL_DEMONSTRATED_PRODUCTIVE_COVERAGE")
    equal(OuttaMyWay.DemonstratedProductiveCoverageProbe.coverageClassFromSamples(3,13),"PARTIAL_DEMONSTRATED_PRODUCTIVE_COVERAGE")
    equal(OuttaMyWay.DemonstratedProductiveCoverageProbe.coverageClassFromSamples(0,13),"NO_DEMONSTRATED_PRODUCTIVE_COVERAGE")
end)

test("D0134 infield shadow candidates point toward Field World centroid without selection authority",function()
    local candidates=OuttaMyWay.RefugeQualificationShadowProbe.generateInfieldCandidates({x=0,z=0},{x=0,z=100},{20,35})
    equal(#candidates,2)
    equal(candidates[1].targetX,0); equal(candidates[1].targetZ,20)
    equal(candidates[2].targetZ,35)
    equal(candidates[1].kind,"INFIELD_SHADOW")
    equal(OuttaMyWay.RefugeQualificationShadowProbe.boundaryDemandClass(8,12),"WITHIN_DEMONSTRATED_BOUNDARY_MANOEUVRE_ENTRY_BAND")
    equal(OuttaMyWay.RefugeQualificationShadowProbe.boundaryDemandClass(20,12),"BEYOND_DEMONSTRATED_BOUNDARY_MANOEUVRE_ENTRY_BAND")
end)

test("D0136 geometric residual fill remains supporting evidence rather than settlement authority",function()
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.residualClass(0,0),"NO_COHERENT_PRODUCTIVE_COVERAGE_RESIDUAL")
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.residualClass(8,0),"RESIDUAL_OPEN")
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.residualClass(8,3),"RESIDUAL_PARTIALLY_FILLED")
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.residualClass(8,8),"RESIDUAL_GEOMETRICALLY_FILLED")
end)

test("D0136 intent settlement requires ordered productive return and Productive-to-turn transition",function()
    local state={productiveReentryObserved=true,returnConsumptionObserved=true,originReacquired=true}
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.intentSettlementEligible(state,{productivePositive=true,evidenceClass="NON_TURN_LINE_ACTIVE"},{productivePositive=false,evidenceClass="TURN_SEGMENT"}),true)
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.intentSettlementEligible({productiveReentryObserved=true,returnConsumptionObserved=false,originReacquired=true},{productivePositive=true},{productivePositive=false,evidenceClass="TURN_SEGMENT"}),false)
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.intentSettlementEligible(state,{productivePositive=true},{productivePositive=false,evidenceClass="NON_TURN_LINE_INACTIVE"}),false)
end)

test("D0136 origin reacquisition uses productive sweep cells at coverage representation scale",function()
    local previous={left={x=0,z=-5},right={x=10,z=-5},width=10,source="TEST"}
    local current={left={x=0,z=0},right={x=10,z=0},width=10,source="TEST"}
    local anchorCells=OuttaMyWay.DemonstratedProductiveCoverageProbe.rasterizeQuadCells(previous,current,5)
    local set={}
    for _,cell in ipairs(anchorCells) do set[cell.key]=true end
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.sweepIntersectsCellSet(previous,current,5,set),true)
    local far={left={x=0,z=20},right={x=10,z=20},width=10,source="TEST"}
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.sweepIntersectsCellSet(current,far,5,{["999:999"]=true}),false)
end)

test("D0138 native field-worker drive command relation remains descriptive only",function()
    local r=OuttaMyWay.NativeFieldWorkerDriveCommandProbe.candidateRelation({valid=true,targetX=10,targetZ=20},16,28)
    equal(r.status,"DESCRIBED")
    equal(math.abs(r.targetDistanceM-10)<0.000001,true)
    equal(r.targetDeltaX,6); equal(r.targetDeltaZ,8)
    equal(r.authority,"DESCRIPTIVE_ONLY")
    equal(r.routePrediction,false); equal(r.negativeClearanceAuthority,false)
end)

test("D0137 settlement comparison visibility uses persistent LiveObservationSource track activity",function()
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.trackIsActive({active=true}),true)
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.trackIsActive({activeObserved=true}),false)
    equal(OuttaMyWay.ProductiveCoverageResidualProbe.trackIsActive({active=false}),false)
end)

test("D0136 settlement Future-Space adapter preserves representation boundary",function()
    local field={boundary={{x=0,z=0},{x=100,z=0},{x=100,z=100},{x=0,z=100}},islands={}}
    local intent={classification="SETTLED_CONTINUATION",intentEpoch=4,intentValid=true}
    local representation={worldPrimitives={{kind="DISC",identity="track-disc",x=50,z=20,radius=2,positiveConflictSupport=true}}}
    local track={active=true,localIntent=intent,fieldWorldSnapshot=field,pose={x=50,z=20,dx=0,dz=1},shadowRepresentation=representation}
    local worker=OuttaMyWay.ProductiveCoverageResidualProbe.futureSpaceWorkerFromTrack(track)
    equal(worker.activeObserved,true)
    equal(worker.localIntent,intent)
    equal(worker.fieldWorldSnapshot,field)
    equal(worker.shadowRepresentation,representation)
    equal(track.activeObserved,nil)
    local future=OuttaMyWay.FieldBoundedFutureSpace.build(worker)
    equal(future.bounded,true)
    equal(future.reason,"SETTLED_GIANTS_LOCAL_INTENT_WITH_FIELD_WORLD_BOUNDARY")
end)


local function d0146Motion(assemblyId,jobToken,dx,dz,speed,interval,nativeForwardKmh,localIntentClassification,intentValid)
    local result={assemblyId=assemblyId,assemblyReferenceKey="REF-"..assemblyId,sourceJobToken=jobToken,travelDirectionX=dx,travelDirectionZ=dz,positionDerivedSpeedMps=speed,sampleIntervalSeconds=interval,motionClassification="PHYSICAL_TRAVEL"}
    if nativeForwardKmh~=nil then
        result.nativeFieldWork={nativeDriveCommand={valid=true,zeroCommand=false,moveForwards=true,maxSpeedKmh=nativeForwardKmh}}
    end
    if localIntentClassification~=nil then result.localIntentClassification=localIntentClassification end
    if intentValid~=nil then result.intentValid=intentValid==true end
    return result
end

local function d0146Productive(assemblyId,positive,evidenceClass)
    return {assemblyId=assemblyId,productivePositive=positive==true,evidenceClass=evidenceClass or (positive==true and "NON_TURN_LINE_ACTIVE" or "TURN_SEGMENT")}
end

local function d0146Space(assemblyId,x,z)
    return {assemblyId=assemblyId,occupancy={x=x,z=z}}
end

local function d0146Physical(assemblyId,x,z,radius)
    return {assemblyId=assemblyId,primitives={{kind="DISC",identity="DISC-"..assemblyId,x=x,z=z,radius=radius,positiveConflictSupport=true}}}
end

local function d0146Update(tracks,motions,spaces,snapshotId,productiveKnowledge)
    return OuttaMyWay.TrajectoryConflictAssessment.updateTrajectories(tracks,{
        motionEvidence=motions,currentSpace=spaces,productiveKnowledge=productiveKnowledge or {},observationSnapshotId=snapshotId,timestamp=snapshotId,
        minSampleDistanceM=0.10,establishDistanceM=3.0,coherenceMinDot=0.94,persistenceAlignmentMinDot=0.85,supersessionDistanceM=4.0,stableMemoryDistanceM=12.0
    })
end

local function d0146Classify(trajectories,motions,spaces,physical)
    return OuttaMyWay.TrajectoryConflictAssessment.classifyPairs({
        trajectoryKnowledge=trajectories,motionEvidence=motions,currentSpace=spaces,physicalSpaceEvidence=physical,
        situations={{operationId="OR-D0146",memberAssemblyIds={"AS-A","AS-B"}}},
        opposedMaxDot=-0.85,currentOpposedMaxDot=-0.85,persistenceAlignmentMinDot=0.85,currentStableDistanceM=1.0,minClosingRateMps=0.05
    })[1]
end

test("D0146 Established Trajectory persists through Current Excursion and supersedes only after sustained contradictory travel",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0)}
    local formed=d0146Update(tracks,{d0146Motion("AS-A","JE-A",0,1,3,1)},spaces,1)[1]
    equal(formed.status,"ESTABLISHED_TRAJECTORY")
    equal(formed.currentExcursion,false)
    equal(formed.establishedDirectionZ,1)

    local excursion=d0146Update(tracks,{d0146Motion("AS-A","JE-A",1,0,2,1)},spaces,2)[1]
    equal(excursion.status,"ESTABLISHED_TRAJECTORY")
    equal(excursion.currentExcursion,true)
    equal(excursion.excursionDistanceM,2)
    equal(excursion.establishedDirectionZ,1)

    local superseded=d0146Update(tracks,{d0146Motion("AS-A","JE-A",1,0,2,1)},spaces,3)[1]
    equal(superseded.status,"ESTABLISHED_TRAJECTORY")
    equal(superseded.currentExcursion,false)
    equal(superseded.lastTransition,"ESTABLISHED_TRAJECTORY_SUPERSEDED_BY_SUSTAINED_CONTRADICTORY_MOTION")
    equal(superseded.establishedDirectionX,1)
    equal(superseded.establishedDirectionZ,0)
end)

test("D0146 opposed corridor classification matures Potential to Established from persistent current motion",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",0,20)}
    local physical={d0146Physical("AS-A",0,0,2),d0146Physical("AS-B",0,20,2)}
    local initialMotion={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,3,1)}
    local trajectories=d0146Update(tracks,initialMotion,spaces,1)
    equal(d0146Classify(trajectories,initialMotion,spaces,physical).classification,"ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT")

    local excursionMotion={d0146Motion("AS-A","JE-A",1,0,1,1),d0146Motion("AS-B","JE-B",0,-1,1,1)}
    trajectories=d0146Update(tracks,excursionMotion,spaces,2)
    local potential=d0146Classify(trajectories,excursionMotion,spaces,physical)
    equal(potential.classification,"POTENTIAL_OPPOSED_CORRIDOR_CONFLICT")
    equal(potential.reason,"CURRENT_MOTION_NOT_YET_SUBSTANTIALLY_OPPOSED")

    local restoredMotion={d0146Motion("AS-A","JE-A",0,1,1,1),d0146Motion("AS-B","JE-B",0,-1,1,1)}
    trajectories=d0146Update(tracks,restoredMotion,spaces,3)
    local established=d0146Classify(trajectories,restoredMotion,spaces,physical)
    equal(established.classification,"ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT")
    equal(established.supportedCorridorOverlap.positive,true)
    equal(established.currentClosingPositive,true)
end)

test("D0146 any positive supported corridor overlap is sufficient without an admission magnitude threshold",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",3.9,20)}
    local physical={d0146Physical("AS-A",0,0,2),d0146Physical("AS-B",3.9,20,2)}
    local motions={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,3,1)}
    local trajectories=d0146Update(tracks,motions,spaces,1)
    local classified=d0146Classify(trajectories,motions,spaces,physical)
    equal(classified.supportedCorridorOverlap.positive,true)
    equal(classified.supportedCorridorOverlap.overlapM>0,true)
    equal(classified.supportedCorridorOverlap.overlapM<0.11,true)
    equal(classified.classification,"ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT")
end)

test("D0146 lack of positive supported corridor overlap cannot establish opposed conflict",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",10,20)}
    local physical={d0146Physical("AS-A",0,0,2),d0146Physical("AS-B",10,20,2)}
    local motions={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,3,1)}
    local trajectories=d0146Update(tracks,motions,spaces,1)
    local classified=d0146Classify(trajectories,motions,spaces,physical)
    equal(classified.supportedCorridorOverlap.positive,false)
    equal(classified.classification,"POTENTIAL_OPPOSED_CORRIDOR_CONFLICT")
    equal(classified.reason,"POSITIVE_SUPPORTED_CORRIDOR_OVERLAP_NOT_YET_ESTABLISHED")
end)

test("D0146 Current Excursion positively supports bounded Action-Space Conservation before trajectory supersession",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",0,60)}
    local physical={d0146Physical("AS-A",0,0,3),d0146Physical("AS-B",0,60,3)}
    local initial={d0146Motion("AS-A","JE-A",0,-1,4,1),d0146Motion("AS-B","JE-B",0,-1,7,1,25)}
    local trajectories=d0146Update(tracks,initial,spaces,1)
    local excursion={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,7,1,25)}
    trajectories=d0146Update(tracks,excursion,spaces,2)
    local classified=d0146Classify(trajectories,excursion,spaces,physical)
    equal(classified.classification,"POTENTIAL_OPPOSED_CORRIDOR_CONFLICT")
    equal(classified.reason,"CURRENT_EXCURSION_CONSUMES_LOCAL_PASSAGE_ACTION_SPACE")
    equal(classified.actionSpaceConservation.status,"REGULATE_SUPPORTED")
    equal(classified.actionSpaceConservation.supported,true)
    equal(classified.actionSpaceConservation.excursionAssemblyId,"AS-A")
    equal(classified.actionSpaceConservation.regulatedAssemblyId,"AS-B")
    equal(classified.actionSpaceConservation.currentCorridorOverlap.positive,true)
    equal(classified.actionSpaceConservation.requestedCapKmh,8)
    equal(classified.actionSpaceConservation.nativeUnrestrictedKmh,25)
    equal(classified.currentClosingPositive,true)
end)

test("D0146 Resolution-Space relationship requires Settled Continuation before non-opposed trajectories positively dissolve",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",0,60)}
    local physical={d0146Physical("AS-A",0,0,3),d0146Physical("AS-B",0,60,3)}
    local initial={d0146Motion("AS-A","JE-A",1,0,4,1),d0146Motion("AS-B","JE-B",0,-1,4,1,25)}
    local trajectories=d0146Update(tracks,initial,spaces,1)

    local approaching={d0146Motion("AS-A","JE-A",0,1,2,1),d0146Motion("AS-B","JE-B",0,-1,2,1,25)}
    trajectories=d0146Update(tracks,approaching,spaces,2)
    local admitted=d0146Classify(trajectories,approaching,spaces,physical)
    equal(admitted.classification,"POTENTIAL_OPPOSED_CORRIDOR_CONFLICT")
    equal(admitted.resolutionSpaceRelationship.status,"RELATIONSHIP_REMAINS_ACTIVE")
    equal(admitted.resolutionSpaceRelationship.positiveDissolution,false)

    local reversingAway={d0146Motion("AS-A","JE-A",0,-1,2,1,15,"TURNING",false),d0146Motion("AS-B","JE-B",0,-1,2,1,25,"SETTLED_CONTINUATION",true)}
    trajectories=d0146Update(tracks,reversingAway,spaces,3,{d0146Productive("AS-A",false,"TURN_SEGMENT"),d0146Productive("AS-B",true,"NON_TURN_LINE_ACTIVE")})
    local transient=d0146Classify(trajectories,reversingAway,spaces,physical)
    equal(transient.classification,"NO_OPPOSED_CONFLICT")
    equal(transient.reason,"ESTABLISHED_TRAJECTORIES_NOT_SUBSTANTIALLY_OPPOSED")
    equal(transient.subjectCurrentExcursion,true)
    equal(transient.resolutionSpaceRelationship.status,"TRANSIENT_RELATIONSHIP_CHANGE")
    equal(transient.resolutionSpaceRelationship.positiveDissolution,false)

    local acceptedButTurning={d0146Motion("AS-A","JE-A",1,0,2,1,15,"TURNING",false),d0146Motion("AS-B","JE-B",0,-1,2,1,25,"SETTLED_CONTINUATION",true)}
    trajectories=d0146Update(tracks,acceptedButTurning,spaces,4,{d0146Productive("AS-A",false,"TURN_SEGMENT"),d0146Productive("AS-B",true,"NON_TURN_LINE_ACTIVE")})
    local transitional=d0146Classify(trajectories,acceptedButTurning,spaces,physical)
    equal(transitional.classification,"NO_OPPOSED_CONFLICT")
    equal(transitional.subjectCurrentExcursion,false)
    equal(transitional.subjectSettledContinuation,false)
    equal(transitional.otherSettledContinuation,true)
    equal(transitional.resolutionSpaceRelationship.status,"TRANSITIONAL_RELATIONSHIP_CHANGE")
    equal(transitional.resolutionSpaceRelationship.positiveDissolution,false)
    equal(transitional.resolutionSpaceRelationship.reason,"D0146_TRANSITIONAL_CONTINUATION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION")

    local settledDissolution={d0146Motion("AS-A","JE-A",1,0,2,1,25,"SETTLED_CONTINUATION",true),d0146Motion("AS-B","JE-B",0,-1,2,1,25,"SETTLED_CONTINUATION",true)}
    trajectories=d0146Update(tracks,settledDissolution,spaces,5,{d0146Productive("AS-A",true,"NON_TURN_LINE_ACTIVE"),d0146Productive("AS-B",true,"NON_TURN_LINE_ACTIVE")})
    local dissolved=d0146Classify(trajectories,settledDissolution,spaces,physical)
    equal(dissolved.classification,"NO_OPPOSED_CONFLICT")
    equal(dissolved.subjectCurrentExcursion,false)
    equal(dissolved.subjectSettledContinuation,true)
    equal(dissolved.otherSettledContinuation,true)
    equal(dissolved.resolutionSpaceRelationship.status,"POSITIVELY_DISSOLVED")
    equal(dissolved.resolutionSpaceRelationship.positiveDissolution,true)
    equal(dissolved.resolutionSpaceRelationship.reason,"D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION")
end)

test("D0146 Current Excursion Action-Space Conservation fails closed outside local envelope or without positive corridor support",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",0,90)}
    local physical={d0146Physical("AS-A",0,0,3),d0146Physical("AS-B",0,90,3)}
    local initial={d0146Motion("AS-A","JE-A",0,-1,4,1),d0146Motion("AS-B","JE-B",0,-1,7,1,25)}
    local trajectories=d0146Update(tracks,initial,spaces,1)
    local excursion={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,7,1,25)}
    trajectories=d0146Update(tracks,excursion,spaces,2)
    local outside=d0146Classify(trajectories,excursion,spaces,physical)
    equal(outside.actionSpaceConservation.supported,false)
    equal(outside.actionSpaceConservation.reason,"CURRENT_EXCURSION_PAIR_OUTSIDE_LOCAL_PASSAGE_ACTION_SPACE_ENVELOPE")

    spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",12,60)}
    physical={d0146Physical("AS-A",0,0,3),d0146Physical("AS-B",12,60,3)}
    local lateral=d0146Classify(trajectories,excursion,spaces,physical)
    equal(lateral.actionSpaceConservation.supported,false)
    equal(lateral.actionSpaceConservation.reason,"CURRENT_EXCURSION_NOT_IN_STABLE_PARTICIPANT_SUPPORTED_CORRIDOR")
end)

test("D0146 Current Excursion does not add Regulation when native progression is already within bounded conservation rate",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",0,60)}
    local physical={d0146Physical("AS-A",0,0,3),d0146Physical("AS-B",0,60,3)}
    local initial={d0146Motion("AS-A","JE-A",0,-1,4,1),d0146Motion("AS-B","JE-B",0,-1,2,1,8)}
    local trajectories=d0146Update(tracks,initial,spaces,1)
    local excursion={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,2,1,8)}
    trajectories=d0146Update(tracks,excursion,spaces,2)
    local classified=d0146Classify(trajectories,excursion,spaces,physical)
    equal(classified.actionSpaceConservation.status,"OBSERVE_SUPPORTED")
    equal(classified.actionSpaceConservation.supported,false)
    equal(classified.actionSpaceConservation.reason,"NATIVE_PROGRESS_ALREADY_WITHIN_ACTION_SPACE_CONSERVATION_RATE")
end)

test("D0146 missing trajectory corridor anchor fails closed instead of inventing an origin anchor",function()
    local tracks={}
    local spaces={d0146Space("AS-A",0,0),d0146Space("AS-B",0,20)}
    local physical={d0146Physical("AS-A",0,0,2),d0146Physical("AS-B",0,20,2)}
    local motions={d0146Motion("AS-A","JE-A",0,1,3,1),d0146Motion("AS-B","JE-B",0,-1,3,1)}
    local trajectories=d0146Update(tracks,motions,spaces,1)
    trajectories[1].corridorAnchorX=nil
    local classified=d0146Classify(trajectories,motions,spaces,physical)
    equal(classified.supportedCorridorOverlap.status,"UNRESOLVED")
    equal(classified.supportedCorridorOverlap.reason,"ESTABLISHED_TRAJECTORY_CORRIDOR_ANCHOR_UNAVAILABLE")
    equal(classified.classification,"POTENTIAL_OPPOSED_CORRIDOR_CONFLICT")
end)


local function d0146Step2Fixture(fieldMinX,fieldMaxX)
    OuttaMyWay.D0146_STEP2_COOPERATIVE_PASSAGE_ENABLED=true
    fieldMinX=fieldMinX or -40; fieldMaxX=fieldMaxX or 40
    local conflict={
        identity="OC-D0146",operationId="OR-1",subjectAssemblyId="AS-A",otherAssemblyId="AS-B",
        status="SUPPORTED",classification="ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT",reason="PERSISTENT_CURRENT_MOTION_SUBSTANTIATES_ESTABLISHED_OPPOSED_CORRIDOR_CONFLICT",
        trajectoryDot=-1,mutuallyFacing=true,currentOpposed=true,currentClosingPositive=true,subjectCurrentStable=true,otherCurrentStable=true,subjectCurrentExcursion=false,otherCurrentExcursion=false,
        currentClosing={separationM=60,currentDirectionDot=-1,closingRateMps=10},
        supportedCorridorOverlap={status="SUPPORTED",positive=true,overlapM=4,sharedRightX=1,sharedRightZ=0,subjectPhysicalPrimitiveCount=2,otherPhysicalPrimitiveCount=2}
    }
    local trajectories={
        {assemblyId="AS-A",assemblyReferenceKey="vehicle-root:101",jobToken="job-A",status="ESTABLISHED_TRAJECTORY",establishedDirectionX=0,establishedDirectionZ=1,corridorAnchorX=0,corridorAnchorZ=0,currentExcursion=false},
        {assemblyId="AS-B",assemblyReferenceKey="vehicle-root:201",jobToken="job-B",status="ESTABLISHED_TRAJECTORY",establishedDirectionX=0,establishedDirectionZ=-1,corridorAnchorX=0,corridorAnchorZ=60,currentExcursion=false}
    }
    local spaces={{assemblyId="AS-A",occupancy={x=0,z=0}},{assemblyId="AS-B",occupancy={x=0,z=60}}}
    local motion={
        {assemblyId="AS-A",assemblyReferenceKey="vehicle-root:101",name="Condor Endurance II",sourceJobToken="job-A",headingX=0,headingZ=1,localIntentClassification="SETTLED_CONTINUATION"},
        {assemblyId="AS-B",assemblyReferenceKey="vehicle-root:201",name="Patriot 4450",sourceJobToken="job-B",headingX=0,headingZ=-1,localIntentClassification="SETTLED_CONTINUATION"}
    }
    local physical={
        {assemblyId="AS-A",assemblyReferenceKey="vehicle-root:101",configurationProfileId="CFG-A",primitives={{kind="DISC",positiveConflictSupport=true,x=-17,z=0,radius=1},{kind="DISC",positiveConflictSupport=true,x=17,z=0,radius=1}},summary={physicalPrimitiveCount=2}},
        {assemblyId="AS-B",assemblyReferenceKey="vehicle-root:201",configurationProfileId="CFG-B",primitives={{kind="DISC",positiveConflictSupport=true,x=-17,z=60,radius=1},{kind="DISC",positiveConflictSupport=true,x=17,z=60,radius=1}},summary={physicalPrimitiveCount=2}}
    }
    local fitness=OuttaMyWay.PassageCapabilityAssessment.buildFitness({opposedCorridorKnowledge={conflict},motionEvidence=motion,physicalSpaceEvidence=physical})
    local picture=OuttaMyWay.OperationalPicture.new({
        identity="OP-D0146-STEP2",epoch=800,observationSnapshotId="OS-D0146-STEP2",
        situations={},encounters={{identity="EN-D0146",operationId="OR-1",subjectAssemblyId="AS-A",otherAssemblyId="AS-B",relationship="FUTURE_SPACE_INTERSECTION",lifecycleState="ACTIVE",evidence={interactionReferenceKey="vehicle-root:101|vehicle-root:201",currentSpaceIntersects=false,futureSpaceConverges=true}}},
        identities={assemblies={"AS-A","AS-B"},components={},jobEpisodes={active={"JE-A","JE-B"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace=spaces,futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},representationFitness=fitness,
        motionEvidence=motion,physicalSpaceEvidence=physical,productiveContinuationKnowledge={},guardedRecoveryKnowledge={},followerBoundaryKnowledge={},trajectoryKnowledge=trajectories,opposedCorridorKnowledge={conflict},cooperativePassageKnowledge={},
        provenance={source="d0146-step2-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext={},diagnostics={}
    })
    local snapshot=OuttaMyWay.ObservationSnapshot.new({
        identity="OS-D0146-STEP2",epoch=801,timestamp=80,provenance={source="d0146-step2-test"},
        fieldWorld={referenceKey="field-world:d0146",geometryFingerprint="fw-d0146",boundary={{x=fieldMinX,z=-30},{x=fieldMaxX,z=-30},{x=fieldMaxX,z=90},{x=fieldMinX,z=90}},islands={}},
        assemblies={{assemblyId="AS-A",referenceKey="vehicle-root:101",memberComponentIds={}},{assemblyId="AS-B",referenceKey="vehicle-root:201",memberComponentIds={}}},
        geometry={currentSpaceEvidence={},futureSpaceEvidence={},futureSpaceRelationshipEvidence={},demandEvidence={},interactionEvidence={}},motion={closureEvidence={}},aiStates={},playerControl={},jobEpisodeEvidence={},operationMembershipEvidence={},physicalRepresentationEvidence={},controlOutcomes={},unavailableSources={},diagnostics={}
    })
    return picture,snapshot
end

test("D0146 Step2 progressive local passage search selects a sufficient multi-gate arrangement",function()
    local picture,snapshot=d0146Step2Fixture()
    local plan,reason=OuttaMyWay.LocalPassagePlanner.plan(picture,snapshot)
    equal(reason,nil); equal(plan.status,"SUPPORTED"); equal(plan.controlProfile,"D0146_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_V3")
    equal(#plan.passageGuide.gates,5); equal(plan.progressiveSearch.satisficed,true)
    equal(plan.passageGuide.gates[1].kind,"DEVELOPMENT_ENTRY"); equal(plan.passageGuide.gates[5].kind,"NATIVE_REACQUISITION")
    equal(plan.passageGuide.pairSweepSupport.minimumCentreSeparationM>=12,true)
    equal(math.abs(plan.passageArrangement.subjectLateralOffsetM)+math.abs(plan.passageArrangement.otherLateralOffsetM),12)
end)

test("D0146 Step2 Pairwise Passage Economy may choose a unilateral arrangement when local field support requires it",function()
    local picture,snapshot=d0146Step2Fixture(-2,15)
    local plan,reason=OuttaMyWay.LocalPassagePlanner.plan(picture,snapshot)
    equal(reason,nil); equal(plan.status,"SUPPORTED")
    equal(math.abs(plan.passageArrangement.subjectLateralOffsetM)<0.001 or math.abs(plan.passageArrangement.otherLateralOffsetM)<0.001,true)
    equal(plan.passageArrangement.maximumParticipantLateralBurdenM,12)
end)

test("D0146 Step2 mechanical preflight is vehicle-name independent and remains Control-revalidated",function()
    local picture,snapshot=d0146Step2Fixture()
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.motionEvidence[1].name="S 416"
    values.motionEvidence[2].name="Arbitrary Foldable Worker"
    local fitness=OuttaMyWay.PassageCapabilityAssessment.buildFitness({opposedCorridorKnowledge=values.opposedCorridorKnowledge,motionEvidence=values.motionEvidence,physicalSpaceEvidence=values.physicalSpaceEvidence})
    equal(#fitness,2)
    equal(fitness[1].evidence.controlProfile,"D0146_OPTIONAL_CONFIGURATION_GUIDED_PASSAGE_V3")
    equal(fitness[1].evidence.vehicleNameAdmissionGate,false)
end)


test("D0146 Step2 configuration reduction is optional per participant when current represented envelope already fits passage reserve",function()
    local picture,snapshot=d0146Step2Fixture()
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.motionEvidence[2].name="S 416"
    values.physicalSpaceEvidence[2].primitives={
        {kind="DISC",positiveConflictSupport=true,x=-2,z=60,radius=1},
        {kind="DISC",positiveConflictSupport=true,x=2,z=60,radius=1}
    }
    values.physicalSpaceEvidence[2].summary={physicalPrimitiveCount=2}
    local adapted=OuttaMyWay.OperationalPicture.new(values)
    local plan,reason=OuttaMyWay.LocalPassagePlanner.plan(adapted,snapshot)
    equal(reason,nil); equal(plan.status,"SUPPORTED")
    equal(plan.passageConfiguration.policy,"OPTIONAL_PER_PARTICIPANT_CONFIGURATION_REDUCTION")
    local modes={}
    for _,entry in OuttaMyWay.ValueRecord.ipairs(plan.passageConfiguration.participants) do modes[entry.assemblyId]=entry.mode end
    equal(modes["AS-A"],"COMPACT_REQUIRED")
    equal(modes["AS-B"],"RETAIN_CURRENT")
    equal(plan.passageArrangement.configurationReduction,"OPTIONAL_PER_PARTICIPANT")
end)

test("D0146 Step2 two already-narrow participants require no configuration reduction",function()
    local picture,snapshot=d0146Step2Fixture()
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.physicalSpaceEvidence[1].primitives={{kind="DISC",positiveConflictSupport=true,x=-2,z=0,radius=1},{kind="DISC",positiveConflictSupport=true,x=2,z=0,radius=1}}
    values.physicalSpaceEvidence[2].primitives={{kind="DISC",positiveConflictSupport=true,x=-2,z=60,radius=1},{kind="DISC",positiveConflictSupport=true,x=2,z=60,radius=1}}
    local adapted=OuttaMyWay.OperationalPicture.new(values)
    local plan,reason=OuttaMyWay.LocalPassagePlanner.plan(adapted,snapshot)
    equal(reason,nil); equal(plan.status,"SUPPORTED")
    for _,entry in OuttaMyWay.ValueRecord.ipairs(plan.passageConfiguration.participants) do equal(entry.mode,"RETAIN_CURRENT") end
end)

test("D0146 Step2 treats a third active assembly's positive current occupancy as Local Spatial Constraint",function()
    local picture,snapshot=d0146Step2Fixture()
    local values=OuttaMyWay.ValueRecord.toTable(picture)
    values.situations={{operationId="OR-1",memberAssemblyIds={"AS-A","AS-B","AS-C"}}}
    values.identities.assemblies={"AS-A","AS-B","AS-C"}
    values.currentSpace[#values.currentSpace+1]={assemblyId="AS-C",occupancy={x=10,z=48}}
    values.motionEvidence[#values.motionEvidence+1]={assemblyId="AS-C",assemblyReferenceKey="vehicle-root:301",name="Third Worker",sourceJobToken="job-C"}
    values.physicalSpaceEvidence[#values.physicalSpaceEvidence+1]={assemblyId="AS-C",assemblyReferenceKey="vehicle-root:301",configurationProfileId="CFG-C",primitives={{kind="DISC",positiveConflictSupport=true,x=10,z=48,radius=2}},summary={physicalPrimitiveCount=1}}
    local constrained=OuttaMyWay.OperationalPicture.new(values)
    local plan,reason=OuttaMyWay.LocalPassagePlanner.plan(constrained,snapshot)
    equal(reason,nil); equal(plan.status,"SUPPORTED")
    equal(plan.localPassageSpace.thirdPartyConstraintCount,1)
    equal(plan.localPassageSpace.thirdPartyConstraints[1].assemblyId,"AS-C")
    equal(plan.passageArrangement.desiredSignedSeparationM<0,true)
    equal(#plan.progressiveSearch.rejectedBeforeSelection>0,true)
end)

local function d0146ActionSpacePicture()
    local relation={
        identity="OC-D0146",operationId="OR-1",subjectAssemblyId="AS-A",otherAssemblyId="AS-B",
        subjectAssemblyReferenceKey="vehicle-root:101",otherAssemblyReferenceKey="vehicle-root:201",
        status="CLASSIFIED",classification="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT",reason="CURRENT_EXCURSION_CONSUMES_LOCAL_PASSAGE_ACTION_SPACE",
        subjectCurrentExcursion=true,otherCurrentExcursion=false,
        actionSpaceConservation={
            status="REGULATE_SUPPORTED",supported=true,reason="CURRENT_EXCURSION_OCCUPIES_APPROACHING_STABLE_TRAJECTORY_CORRIDOR_WHILE_LOCAL_PASSAGE_ACTION_SPACE_COMPRESSES",
            excursionAssemblyId="AS-A",excursionReferenceKey="vehicle-root:101",regulatedAssemblyId="AS-B",regulatedReferenceKey="vehicle-root:201",
            separationM=70,maxSeparationM=80,currentCorridorOverlap={positive=true,overlapM=6},currentClosing={resolved=true,separationM=70,closingRateMps=8},
            nativeUnrestrictedKmh=25,requestedCapKmh=8,governingPurpose="PRESERVE_D0146_PASSAGE_ACTION_SPACE_UNTIL_RELATIONSHIP_MATURES_OR_POSITIVELY_DISSOLVES"
        }
    }
    return OuttaMyWay.OperationalPicture.new({
        identity="OP-D0146-ACTION",epoch=790,observationSnapshotId="OS-D0146-ACTION",situations={},encounters={},
        identities={assemblies={"AS-A","AS-B"},components={},jobEpisodes={active={"JE-A","JE-B"},admitted={},ended={}},operations={active={"OR-1"},ended={}}},
        currentSpace={},futureSpace={},demand={committedDemand={},potentialDemand={},temporarySlack={}},responsibilityRelations={},uncertainty={},representationFitness={},
        motionEvidence={},physicalSpaceEvidence={},productiveContinuationKnowledge={},guardedRecoveryKnowledge={},followerBoundaryKnowledge={},trajectoryKnowledge={},opposedCorridorKnowledge={relation},cooperativePassageKnowledge={},
        provenance={source="d0146-action-space-test"},controlOutcomeEvidence={},candidateSupportEvidence={complete=false,supportBoundary={},candidateSpecifications={},provenance={}},commitmentContext={},diagnostics={}
    })
end

test("D0146 Action-Space Regulation crosses Candidate Decision Commitment Control and succeeds into same-Commitment Passage",function()
    local runtime=autonomousHeadOnRuntime()
    local regulationRequests={}; local cleared={}
    local capability={}
    function capability:executeControlRequest(request,candidate) regulationRequests[#regulationRequests+1]=request; return true,"ACCEPTED" end
    function capability:clearRegulationLeaseByReference(referenceKey,ownerTag) cleared[#cleared+1]={referenceKey=referenceKey,ownerTag=ownerTag}; return true end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local base=d0146ActionSpacePicture()
    local supported=runtime.liveTrafficCandidateSupport:attach(base,headOnTestSnapshot())
    equal(supported.candidateSupportEvidence.supportBoundary.mode,"D0146_POTENTIAL_ACTION_SPACE_REGULATION")
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    equal(evaluated.decision.commitmentAction,"CREATE")
    local admitted=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    equal(admitted.status,"ACCEPTED"); equal(admitted.d0146ActionSpace,true)
    equal(regulationRequests[#regulationRequests].target.ownerTag,"D0146_ACTION_SPACE_CONSERVATION")
    equal(regulationRequests[#regulationRequests].target.maxSpeedKmh,8)
    local commitmentId=admitted.commitment.identity
    equal(runtime.authorities:ownerOf("AS-B"),commitmentId)
    equal(runtime.liveControlDispatcher:getD0146ActionSpaceStatus().active,true)
    local actionObligation=runtime.obligations:openForOwner(commitmentId)[1]
    equal(actionObligation.basis.kind,"D0146_PASSAGE_ACTION_SPACE_CONSERVATION")

    local passagePicture,passageSnapshot=d0146Step2Fixture()
    local values=OuttaMyWay.ValueRecord.toTable(passagePicture)
    values.identity="OP-D0146-STEP2-SUCCESSION"; values.epoch=802; values.commitmentContext={{commitmentId=commitmentId}}
    passagePicture=OuttaMyWay.OperationalPicture.new(values)
    local accepted=nil
    local cooperativeControl={}
    function cooperativeControl:setCompletionHandler(fn) end
    function cooperativeControl:isActive() return false end
    function cooperativeControl:executeJointRequests(a,b,candidate) accepted={a,b,candidate}; return true,"D0146_COOPERATIVE_PASSAGE_STARTED" end
    runtime.liveControlDispatcher:setCooperativePassageControl(cooperativeControl)
    local passageSupported=runtime.liveTrafficCandidateSupport:attach(passagePicture,passageSnapshot)
    equal(passageSupported.candidateSupportEvidence.supportBoundary.mode,"D0146_COOPERATIVE_PASSAGE_STEP2_TEST")
    local passageEval=runtime:evaluateSealedOperationalPicture(passageSupported)
    equal(passageEval.decision.commitmentAction,"REVISE")
    local dispatched=runtime.liveControlDispatcher:dispatch(passageSupported,passageEval)
    equal(dispatched.status,"ACCEPTED"); equal(dispatched.commitment.identity,commitmentId)
    equal(runtime.liveControlDispatcher:getD0146ActionSpaceStatus().active,false)
    equal(#cleared,1); equal(cleared[1].referenceKey,"vehicle-root:201"); equal(cleared[1].ownerTag,"D0146_ACTION_SPACE_CONSERVATION")
    equal(runtime.obligations:get(actionObligation.identity).status,"SETTLED")
    equal(#runtime.authorities:tokensForCommitment(commitmentId),2)
    equal(#accepted,3)
end)

test("D0146 Action-Space Regulation persists through transient reverse/non-closing evidence after admission",function()
    local runtime=autonomousHeadOnRuntime()
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) requests[#requests+1]=request; return true,"ACCEPTED" end
    function capability:clearRegulationLeaseByReference(referenceKey,ownerTag) return true end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local active=d0146ActionSpacePicture()
    local supported=runtime.liveTrafficCandidateSupport:attach(active,headOnTestSnapshot())
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    local admitted=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    equal(admitted.status,"ACCEPTED")
    local commitmentId=admitted.commitment.identity

    local values=OuttaMyWay.ValueRecord.toTable(active)
    values.identity="OP-D0146-ACTION-TRANSIENT"; values.epoch=791; values.commitmentContext={{commitmentId=commitmentId}}
    local relation=values.opposedCorridorKnowledge[1]
    relation.classification="NO_OPPOSED_CONFLICT"
    relation.reason="ESTABLISHED_TRAJECTORIES_NOT_SUBSTANTIALLY_OPPOSED"
    relation.subjectCurrentExcursion=true; relation.otherCurrentExcursion=false
    relation.resolutionSpaceRelationship={status="TRANSIENT_RELATIONSHIP_CHANGE",positiveDissolution=false,reason="D0146_TRANSIENT_EXCURSION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION"}
    relation.actionSpaceConservation={status="NOT_REQUIRED",supported=false,reason="CURRENT_EXCURSION_PAIR_NOT_POSITIVELY_CLOSING"}
    local transient=OuttaMyWay.OperationalPicture.new(values)
    local transientSupported=runtime.liveTrafficCandidateSupport:attach(transient,headOnTestSnapshot())
    local transientEval=runtime:evaluateSealedOperationalPicture(transientSupported)
    local maintained=runtime.liveControlDispatcher:dispatch(transientSupported,transientEval)
    equal(maintained.status,"MAINTAINED")
    equal(maintained.reason,"D0146_TRANSIENT_EXCURSION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION")
    equal(runtime.liveControlDispatcher:getD0146ActionSpaceStatus().active,true)
    equal(#requests,1)
end)

test("D0146 Action-Space Regulation persists after excursion witness ends while Potential conflict remains",function()
    local runtime=autonomousHeadOnRuntime()
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) requests[#requests+1]=request; return true,"ACCEPTED" end
    function capability:clearRegulationLeaseByReference(referenceKey,ownerTag) return true end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local active=d0146ActionSpacePicture()
    local supported=runtime.liveTrafficCandidateSupport:attach(active,headOnTestSnapshot())
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    local admitted=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    local commitmentId=admitted.commitment.identity

    local values=OuttaMyWay.ValueRecord.toTable(active)
    values.identity="OP-D0146-ACTION-POTENTIAL"; values.epoch=792; values.commitmentContext={{commitmentId=commitmentId}}
    local relation=values.opposedCorridorKnowledge[1]
    relation.classification="POTENTIAL_OPPOSED_CORRIDOR_CONFLICT"
    relation.reason="CURRENT_CLOSURE_NOT_YET_POSITIVELY_ESTABLISHED"
    relation.subjectCurrentExcursion=false; relation.otherCurrentExcursion=false
    relation.trajectoryDot=-0.999; relation.mutuallyFacing=true
    relation.supportedCorridorOverlap={status="POSITIVE_SUPPORTED_CORRIDOR_OVERLAP",positive=true,overlapM=35.5}
    relation.resolutionSpaceRelationship={status="RELATIONSHIP_REMAINS_ACTIVE",positiveDissolution=false,reason="OPPOSED_CORRIDOR_RELATIONSHIP_REMAINS_ESTABLISHED_OR_POTENTIAL"}
    relation.actionSpaceConservation={status="NOT_REQUIRED",supported=false,reason="NO_CURRENT_EXCURSION"}
    local potential=OuttaMyWay.OperationalPicture.new(values)
    local potentialSupported=runtime.liveTrafficCandidateSupport:attach(potential,headOnTestSnapshot())
    local potentialEval=runtime:evaluateSealedOperationalPicture(potentialSupported)
    local maintained=runtime.liveControlDispatcher:dispatch(potentialSupported,potentialEval)
    equal(maintained.status,"MAINTAINED")
    equal(maintained.reason,"D0146_POTENTIAL_CONFLICT_RESOLUTION_SPACE_OBLIGATION_PERSISTS")
    equal(runtime.liveControlDispatcher:getD0146ActionSpaceStatus().active,true)
    equal(runtime.commitments:get(commitmentId).state,"ACTIVE")
    equal(#requests,1)
end)

test("D0146 Action-Space Regulation persists while non-opposed trajectories remain Transitional Continuation",function()
    local runtime=autonomousHeadOnRuntime()
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) requests[#requests+1]=request; return true,"ACCEPTED" end
    function capability:clearRegulationLeaseByReference(referenceKey,ownerTag) return true end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local active=d0146ActionSpacePicture()
    local supported=runtime.liveTrafficCandidateSupport:attach(active,headOnTestSnapshot())
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    local admitted=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    equal(admitted.status,"ACCEPTED")
    local commitmentId=admitted.commitment.identity

    local values=OuttaMyWay.ValueRecord.toTable(active)
    values.identity="OP-D0146-ACTION-TRANSITIONAL"; values.epoch=794; values.commitmentContext={{commitmentId=commitmentId}}
    local relation=values.opposedCorridorKnowledge[1]
    relation.classification="NO_OPPOSED_CONFLICT"
    relation.reason="ESTABLISHED_TRAJECTORIES_NOT_SUBSTANTIALLY_OPPOSED"
    relation.subjectCurrentExcursion=false; relation.otherCurrentExcursion=false
    relation.subjectSettledContinuation=false; relation.otherSettledContinuation=true
    relation.resolutionSpaceRelationship={status="TRANSITIONAL_RELATIONSHIP_CHANGE",positiveDissolution=false,reason="D0146_TRANSITIONAL_CONTINUATION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION"}
    relation.actionSpaceConservation={status="NOT_REQUIRED",supported=false,reason="NO_CURRENT_EXCURSION"}
    local transitional=OuttaMyWay.OperationalPicture.new(values)
    local transitionalSupported=runtime.liveTrafficCandidateSupport:attach(transitional,headOnTestSnapshot())
    local transitionalEval=runtime:evaluateSealedOperationalPicture(transitionalSupported)
    local maintained=runtime.liveControlDispatcher:dispatch(transitionalSupported,transitionalEval)
    equal(maintained.status,"MAINTAINED")
    equal(maintained.reason,"D0146_TRANSITIONAL_CONTINUATION_DOES_NOT_POSITIVELY_DISSOLVE_RESOLUTION_SPACE_OBLIGATION")
    equal(runtime.liveControlDispatcher:getD0146ActionSpaceStatus().active,true)
    equal(runtime.commitments:get(commitmentId).state,"ACTIVE")
    equal(#requests,1)
end)

test("D0146 Action-Space Regulation releases only on positive settled relationship dissolution",function()
    local runtime=autonomousHeadOnRuntime()
    local requests={}
    local capability={}
    function capability:executeControlRequest(request,candidate) requests[#requests+1]=request; return true,"ACCEPTED" end
    function capability:clearRegulationLeaseByReference(referenceKey,ownerTag) return true end
    function capability:getControlExecutionObservation() return nil end
    runtime:setLiveControlCapability(capability)

    local active=d0146ActionSpacePicture()
    local supported=runtime.liveTrafficCandidateSupport:attach(active,headOnTestSnapshot())
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    local admitted=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    equal(admitted.status,"ACCEPTED")
    local commitmentId=admitted.commitment.identity

    local values=OuttaMyWay.ValueRecord.toTable(active)
    values.identity="OP-D0146-ACTION-DISSOLVED"; values.epoch=793; values.commitmentContext={{commitmentId=commitmentId}}
    local relation=values.opposedCorridorKnowledge[1]
    relation.classification="NO_OPPOSED_CONFLICT"
    relation.reason="ESTABLISHED_TRAJECTORIES_NOT_SUBSTANTIALLY_OPPOSED"
    relation.subjectCurrentExcursion=false; relation.otherCurrentExcursion=false
    relation.resolutionSpaceRelationship={status="POSITIVELY_DISSOLVED",positiveDissolution=true,reason="D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION"}
    relation.actionSpaceConservation={status="NOT_REQUIRED",supported=false,reason="NO_CURRENT_EXCURSION"}
    local dissolved=OuttaMyWay.OperationalPicture.new(values)
    local dissolvedSupported=runtime.liveTrafficCandidateSupport:attach(dissolved,headOnTestSnapshot())
    local dissolvedEval=runtime:evaluateSealedOperationalPicture(dissolvedSupported)
    local released=runtime.liveControlDispatcher:dispatch(dissolvedSupported,dissolvedEval)
    equal(released.status,"RELEASED")
    equal(released.reason,"D0146_POSITIVE_SETTLED_TRAJECTORY_RELATIONSHIP_DISSOLUTION")
    equal(requests[#requests].target.operation,"RELEASE")
    equal(runtime.liveControlDispatcher:getD0146ActionSpaceStatus().active,false)
    equal(runtime.authorities:ownerOf("AS-B"),nil)
    equal(runtime.commitments:get(commitmentId).state,"SUCCEEDED")
end)

test("D0146 Step2 Established Conflict crosses Candidate Decision Commitment and central Control dispatch",function()
    local runtime=autonomousHeadOnRuntime()
    local picture,snapshot=d0146Step2Fixture()
    local supported=runtime.liveTrafficCandidateSupport:attach(picture,snapshot)
    equal(supported.candidateSupportEvidence.supportBoundary.mode,"D0146_COOPERATIVE_PASSAGE_STEP2_TEST")
    local evaluated=runtime:evaluateSealedOperationalPicture(supported)
    equal(#evaluated.candidates,1); equal(evaluated.decision.selectedCandidateId,evaluated.candidates[1].identity); equal(evaluated.decision.commitmentAction,"CREATE")
    local accepted=nil
    local control={}
    function control:setCompletionHandler(fn) self.handler=fn end
    function control:isActive() return false end
    function control:executeJointRequests(a,b,candidate) accepted={a,b,candidate}; return true,"D0146_COOPERATIVE_PASSAGE_STARTED" end
    runtime.liveControlDispatcher:setCooperativePassageControl(control)
    local dispatched=runtime.liveControlDispatcher:dispatch(supported,evaluated)
    equal(dispatched.status,"ACCEPTED"); equal(#accepted,3); equal(#dispatched.requests,2)
    equal(dispatched.requests[1].target.kind,"D0146_COOPERATIVE_PASSAGE"); equal(dispatched.requests[2].target.kind,"D0146_COOPERATIVE_PASSAGE")
    equal(dispatched.candidate.evidenceBasis.cooperativePassageBridge.architecture,"D0146_STEP2")
end)

print(string.format("RESULT %d passed, %d failed",passed,failed))
if failed > 0 then os.exit(1) end
