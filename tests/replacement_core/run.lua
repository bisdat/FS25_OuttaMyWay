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
    equal(status.runtimeMode,"OBSERVATION_IDENTITY_OFFLINE"); equal(status.controlAuthorityEnabled,false); equal(status.commitmentCount,0); equal(status.observationCount,0); equal(status.jobEpisodeCount,0)
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

print(string.format("RESULT %d passed, %d failed",passed,failed))
if failed > 0 then os.exit(1) end
