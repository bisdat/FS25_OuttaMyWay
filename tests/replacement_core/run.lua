local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/ObservationSnapshot.lua")
load("scripts/contracts/OperationalPicture.lua")
load("scripts/contracts/CandidateAction.lua")
load("scripts/contracts/ConstraintVerdict.lua")
load("scripts/contracts/DecisionRecord.lua")
load("scripts/contracts/CommitmentRecord.lua")
load("scripts/contracts/ObligationRecord.lua")
load("scripts/contracts/ControlRequest.lua")
load("scripts/contracts/ControlOutcome.lua")
load("scripts/identity/EpochSequence.lua")
load("scripts/identity/IdentityRegistry.lua")
load("scripts/observation/RuntimeObservationAdapter.lua")
load("scripts/identity/JobEpisodeAdmission.lua")
load("scripts/identity/OperationAdmission.lua")
load("scripts/assessment/RepresentationFitness.lua")
load("scripts/assessment/SituationAssessment.lua")
load("scripts/commitment/CommitmentStateMachine.lua")
load("scripts/commitment/CommitmentRegistry.lua")
load("scripts/commitment/ObligationLedger.lua")
load("scripts/authority/AuthorityRegistry.lua")
load("scripts/authority/EffectiveActuationComposition.lua")
load("scripts/diagnostics/ArchitectureTrace.lua")
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

test("runtime is explicitly inert", function()
    local runtime=OuttaMyWay.Runtime.new(); runtime:initialize(); local status=runtime:getStatus()
    equal(status.runtimeMode,"OPERATIONAL_PICTURE_OFFLINE"); equal(status.controlAuthorityEnabled,false); equal(status.commitmentCount,0); equal(status.observationCount,0); equal(status.jobEpisodeCount,0); equal(status.operationCount,0); equal(status.operationalPictureCount,0)
end)


local function rawObservation(epoch, evidence, assemblyKey)
    assemblyKey = assemblyKey or "assembly-A"
    return {
        timestamp = epoch,
        provenance = { source="fixture", sequence=epoch },
        assemblies = {{ referenceKey=assemblyKey, componentReferenceKeys={assemblyKey.."/vehicle", assemblyKey.."/implement"}, source="fixture" }},
        fieldWorld = {}, geometry = {}, motion = {}, aiStates = {}, playerControl = {},
        jobEpisodeEvidence = evidence and {{ assemblyReferenceKey=assemblyKey, sourceJobToken=evidence.sourceJobToken or "job-1", jobPresent=evidence.jobPresent, aiControlled=evidence.aiControlled, aiActive=evidence.aiActive, blocked=evidence.blocked, outtaMyWayHold=evidence.outtaMyWayHold, temporarilyInactive=evidence.temporarilyInactive, playerStopObserved=evidence.playerStopObserved, playerTakeoverObserved=evidence.playerTakeoverObserved, playerControlled=evidence.playerControlled, giantsAbortObserved=evidence.giantsAbortObserved, giantsFaultObserved=evidence.giantsFaultObserved, restartObserved=evidence.restartObserved, replacementObserved=evidence.replacementObserved, provenance={source="fixture"} }} or {},
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
        fieldWorld={referenceKey="field-world-77",fieldPolygonReferenceKey="field-77",operationMembershipEvidenceComplete=options.membershipComplete~=false},
        assemblies={{referenceKey=follower,componentReferenceKeys={follower.."/vehicle"},source="fixture"},{referenceKey=leader,componentReferenceKeys={leader.."/vehicle"},source="fixture"}},
        geometry={
            currentSpaceEvidence={{identity="CS-A",assemblyReferenceKey=follower,occupancy={x=0,z=0},provenance={source="fixture"}},{identity="CS-B",assemblyReferenceKey=leader,occupancy={x=10,z=0},provenance={source="fixture"}}},
            futureSpaceEvidence={{identity="FS-A",assemblyReferenceKey=follower,alternatives={{corridor="C1"}},horizon=5,provenance={source="fixture"}},{identity="FS-B",assemblyReferenceKey=leader,alternatives={{corridor="C1"}},horizon=5,provenance={source="fixture"}}},
            demandEvidence={{identity="D-A",class="COMMITTED_DEMAND",assemblyReferenceKey=follower,space={corridor="C1"},basis={source="active continuation"},provenance={source="fixture"}},{identity="D-B",class="POTENTIAL_DEMAND",assemblyReferenceKey=leader,space={corridor="C1"},basis={source="bounded future"},provenance={source="fixture"}},{identity="S-1",class="TEMPORARY_SLACK",space={region="R1"},basis={source="current vacancy"},provenance={source="fixture"}}},
            interactionEvidence=options.interactions or {{interactionReferenceKey="interaction-1",subjectAssemblyReferenceKey=follower,otherAssemblyReferenceKey=leader,currentSpaceIntersects=false,futureSpaceConverges=true,horizon=5,provenance={source="fixture"}}}
        },
        motion={closureEvidence={{followerAssemblyReferenceKey=follower,leaderAssemblyReferenceKey=leader,closingObserved=true,closingRate=2,horizon=5,provenance={source="fixture"}}}},
        aiStates={},playerControl={},
        jobEpisodeEvidence={{assemblyReferenceKey=follower,sourceJobToken=evidenceA.sourceJobToken,jobPresent=evidenceA.jobPresent,aiControlled=evidenceA.aiControlled,aiActive=evidenceA.aiActive,blocked=evidenceA.blocked,playerStopObserved=evidenceA.playerStopObserved,provenance={source="fixture"}},{assemblyReferenceKey=leader,sourceJobToken=evidenceB.sourceJobToken,jobPresent=evidenceB.jobPresent,aiControlled=evidenceB.aiControlled,aiActive=evidenceB.aiActive,blocked=evidenceB.blocked,playerStopObserved=evidenceB.playerStopObserved,provenance={source="fixture"}}},
        operationMembershipEvidence=options.membership or {{assemblyReferenceKey=follower,fieldWorldReferenceKey="field-world-77",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}},{assemblyReferenceKey=leader,fieldWorldReferenceKey="field-world-77",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}},
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

test("Operation identity persists while membership changes",function()
    local runtime=newPictureRuntime(); local first=runtime:processSealedObservation(pictureFixture(1))
    local second=runtime:processSealedObservation(pictureFixture(2,{membership={{assemblyReferenceKey="assembly-A",fieldWorldReferenceKey="field-world-77",fieldPolygonReferenceKey="field-77",performingRecognisedFieldWork=true,provenance={source="fixture"}}}}))
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

print(string.format("RESULT %d passed, %d failed",passed,failed))
if failed > 0 then os.exit(1) end
