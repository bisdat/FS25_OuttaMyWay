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
load("scripts/observation/LiveObservationSource.lua")
load("scripts/identity/JobEpisodeAdmission.lua")
load("scripts/identity/OperationAdmission.lua")
load("scripts/assessment/RepresentationFitness.lua")
load("scripts/assessment/EncounterRegistry.lua")
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
load("scripts/candidates/CandidateSpace.lua")
load("scripts/candidates/PassiveLiveCandidateSupport.lua")
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
load("scripts/decision/DecisionSelector.lua")
load("scripts/diagnostics/ArchitectureTrace.lua")
load("scripts/replay/ConformanceAssertions.lua")
load("scripts/replay/ReplayRunner.lua")
load("scripts/diagnostics/TargetedFieldIdentityProbe.lua")
load("scripts/diagnostics/FutureSpaceHud.lua")
load("scripts/diagnostics/TransitionHud.lua")
load("scripts/diagnostics/PassiveLiveValidator.lua")
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
    equal(status.runtimeMode,"LEGACY_SHADOW_CLEANUP_CONFORMANCE"); equal(status.controlAuthorityEnabled,false); equal(status.commitmentCount,0); equal(status.observationCount,0); equal(status.jobEpisodeCount,0); equal(status.operationCount,0); equal(status.operationalPictureCount,0); equal(status.candidateInventoryCount,0); equal(status.constraintVerdictSetCount,0); equal(status.decisionCount,0); equal(status.passiveTraceCount,0)
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
        candidateSupportEvidence={complete=true,supportBoundary={kind="SEALED_FIXTURE",capabilityBoundary=options.capabilityBoundary or {}},candidateSpecifications=specifications,provenance={source="sealed-fixture"}},
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
        local runtime=OuttaMyWay.Runtime.new(); runtime:initialize(); runtime.passiveLiveValidator:loadMap(); runtime.passiveLiveValidator:update(1000)
        local record=runtime.passiveLiveValidator:getRecords()[1]
        equal(record.controlAuthorityEnabled,false); equal(record.activeAssemblyCount,2); equal(record.activeJobEpisodeCount,2); equal(record.activeOperationCount,1); equal(record.globalActiveOperationCount,1)
        equal(record.candidateCount,1); equal(record.allPassCandidateCount,1); equal(record.unresolvedCandidateCount,0); equal(record.failedCandidateCount,0)
        equal(record.selectedCapability,"CONTINUE_OBSERVATION"); equal(record.nonIntervention.classification,"CONTINUE_OBSERVATION")
        equal(#runtime.commitments:list(),0); equal(runtime.decisionCommitmentBoundary:getPublishedCount(),0)
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

print(string.format("RESULT %d passed, %d failed",passed,failed))
if failed > 0 then os.exit(1) end
