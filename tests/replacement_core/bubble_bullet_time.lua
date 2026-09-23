local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/contracts/ValueRecord.lua")
load("scripts/candidates/BubbleDecisionHorizonCandidateSupport.lua")
load("scripts/authority/BubbleBulletTime.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b)),2) end
end
local function truthy(value,message)
    if value~=true then error(message or "expected true",2) end
end

local function activePassagePicture()
    return {
        commitmentContext={{
            commitmentId="CM-1",lifecycleState="ACTIVE",
            openObligations={{basis={kind="COOPERATIVE_PASSAGE_LEG",assemblyId="A"}}}
        }}
    }
end

test("Bubble decision horizon defers ordinary traffic negotiation while Passage Leg is live",function()
    local delegateCalls,passiveCalls=0,0
    local delegate={
        publishDecisionPicture=function() delegateCalls=delegateCalls+1; return {path="delegate"} end,
        buildProjectedGroup=function() delegateCalls=delegateCalls+1; return {path="delegate-projection"},nil end,
        getLastStatus=function() return "DELEGATE" end,
        getPublishedCount=function() return 4 end
    }
    local passive={
        publishDecisionPicture=function() passiveCalls=passiveCalls+1; return {path="passive"} end,
        buildProjectedGroup=function() passiveCalls=passiveCalls+1; return {path="passive-projection"},nil end
    }
    local support=OuttaMyWay.BubbleDecisionHorizonCandidateSupport.new(delegate,passive)
    local result=support:publishDecisionPicture(activePassagePicture(),{})
    equal(result.path,"passive")
    equal(passiveCalls,1)
    equal(delegateCalls,0)
    equal(support:getLastStatus(),"BUBBLE_RESOLUTION_EPOCH_DEFERS_INDEPENDENT_TRAFFIC_NEGOTIATION")

    local projection=support:buildProjectedGroup(activePassagePicture(),{},{kind="FORWARD_INTERSECTION"},"PICTURE-2",2)
    equal(projection.path,"passive-projection")
    equal(passiveCalls,2)
    equal(delegateCalls,0)

    local ordinary=support:publishDecisionPicture({commitmentContext={}}, {})
    equal(ordinary.path,"delegate")
    equal(delegateCalls,1)
end)

test("Bubble preparation precedes responsibility-backed fixed one kilometre per hour activation",function()
    local events={}
    local commitment={identity="CM-1",state="ACTIVE",effectiveActuationCompositionId="COMP-PAIR",strategy={capability="REPOSITION"}}
    local currentResponsibility={identity="RS-1"}
    local supportToken={identity="AU-C",assemblyId="C"}
    local releaseCalls=0
    local cleared=0

    OuttaMyWay.CommitmentStateMachine={
        isTerminal=function(record) return record.state=="SUCCEEDED" or record.state=="FAILED" end
    }
    OuttaMyWay.LiveTrafficCommitmentLifecycle={
        acquireSupportingRegulationAuthority=function(runtime,commitmentId,assemblyId,evidence)
            events[#events+1]="support-authority"
            equal(commitmentId,"CM-1"); equal(assemblyId,"C")
            equal(evidence.governingPurpose,"COOPERATIVE_PASSAGE_BUBBLE_BULLET_TIME")
            commitment.effectiveActuationCompositionId="COMP-THREE"
            return {commitment=commitment,authorityToken=supportToken,composition={identity="COMP-THREE"}},nil
        end
    }

    local runtime={
        commitments={get=function(_,id) if id=="CM-1" then return commitment end end},
        authorities={
            tokensForCommitment=function(_,id) if id=="CM-1" then return {supportToken} end return {} end,
            validate=function(_,token) return token==supportToken end
        },
        boundedAuthority={
            authorize=function(_,values)
                events[#events+1]="bounded-authority"
                equal(values.responsibilityId,"RS-1")
                equal(values.commitmentId,"CM-1")
                equal(values.assemblyId,"C")
                equal(values.capability,"REGULATE_SPEED")
                equal(values.target.ownerTag,"BUBBLE_BULLET_TIME")
                equal(values.target.maxSpeedKmh,1.0)
                equal(values.effectiveActuationCompositionId,"COMP-THREE")
                return {identity="BA-1",preconditions={},invalidationConditions={}},nil
            end,
            materializeRequest=function(_,values)
                events[#events+1]="request"
                equal(values.boundedAuthorityId,"BA-1")
                equal(values.target.operation,"APPLY")
                equal(values.target.ownerTag,"BUBBLE_BULLET_TIME")
                equal(values.target.maxSpeedKmh,1.0)
                return {
                    identity="CR-1",boundedAuthorityId="BA-1",commitmentId="CM-1",assemblyId="C",capability="REGULATE_SPEED",
                    target=values.target,authorityToken="AU-C",effectiveActuationCompositionId="COMP-THREE"
                },nil
            end,
            release=function(_,id)
                events[#events+1]="release-"..tostring(id)
                releaseCalls=releaseCalls+1
                return true
            end
        },
        liveControlDispatcher={
            dispatch=function(_,request)
                events[#events+1]="dispatch"
                equal(request.target.ownerTag,"BUBBLE_BULLET_TIME")
                equal(request.target.maxSpeedKmh,1.0)
                return true,"REGULATION_LEASE_APPLIED"
            end,
            notifyAccepted=function(_,request,effect)
                events[#events+1]="accepted"
                equal(request.identity,"CR-1")
                equal(effect.maxSpeedKmh,1.0)
                return {identity="OUTCOME-1"}
            end,
            regulationControl={
                clearRegulationLeaseByReference=function(_,referenceKey,ownerTag)
                    cleared=cleared+1
                    equal(referenceKey,"vehicle-root:C")
                    equal(ownerTag,"BUBBLE_BULLET_TIME")
                    return true,"CONTROL_CLEANUP_RELEASED"
                end
            }
        },
        responsibilityTransitionAuthority={
            getCurrentResolutionCommitment=function(_,id)
                if id=="CM-1" and commitment.state=="ACTIVE" then return currentResponsibility end
                return nil
            end
        }
    }

    local picture={
        epoch=10,
        situations={{operationId="OP-1",memberAssemblyIds={"A","B","C"}}},
        motionEvidence={
            {assemblyId="A",assemblyReferenceKey="vehicle-root:A"},
            {assemblyId="B",assemblyReferenceKey="vehicle-root:B"},
            {assemblyId="C",assemblyReferenceKey="vehicle-root:C"}
        },
        physicalSpaceEvidence={},productiveContinuationKnowledge={}
    }
    local candidate={
        preconditions={},invalidationConditions={},
        evidenceBasis={cooperativePassageBridge={operationId="OP-1",assemblyIds={"A","B"}}}
    }
    local applied={commitment=commitment}

    local bullet=OuttaMyWay.BubbleBulletTime.new(runtime)
    local prepared,prepareReason=bullet:prepareAtBubbleFormation(picture,candidate,applied)
    equal(prepareReason,nil)
    equal(prepared.status,"PREPARED")
    equal(prepared.assemblyId,"C")
    equal(prepared.maxSpeedKmh,1.0)
    equal(prepared.physicalActive,false)
    equal(events[1],"support-authority")
    equal(events[2],nil,"Positive Bounded Authority must wait for current Resolution responsibility")

    local pairRequestContext={
        effectiveActuationCompositionId="COMP-THREE",operationalPictureEpoch=10,evidenceEpoch=11,
        preconditions={},invalidationConditions={}
    }
    local lease,activateReason=bullet:activatePrepared("CM-1",pairRequestContext,candidate)
    equal(activateReason,nil)
    equal(lease.status,"ACTIVE")
    equal(lease.physicalActive,true)
    equal(events[2],"bounded-authority")
    equal(events[3],"request")
    equal(events[4],"dispatch")
    equal(events[5],"accepted")
    equal(releaseCalls,0)

    -- A and B remain the only Passage participants. C is supporting Regulation only.
    equal(candidate.evidenceBasis.cooperativePassageBridge.assemblyIds[1],"A")
    equal(candidate.evidenceBasis.cooperativePassageBridge.assemblyIds[2],"B")

    local reconciliation=bullet:releaseUnsupportedProtection({picture={situations={{operationId="OP-1",memberAssemblyIds={"A","B"}}}}})
    equal(reconciliation[1].status,"QUIESCENT_BASIS_ENDED")
    equal(cleared,1)
    truthy(releaseCalls>=1,"Bounded Authority should be released when the formation-time third party leaves")
    equal(bullet:getLease("CM-1").physicalActive,false)

    commitment.state="SUCCEEDED"
    local terminal=bullet:releaseUnsupportedProtection({picture={situations={{operationId="OP-1",memberAssemblyIds={"A","B"}}}}})
    equal(terminal[1].status,"RELEASED")
    equal(bullet:getLease("CM-1"),nil)
end)

test("Two-worker Bubble formation does not manufacture third-party Regulation",function()
    OuttaMyWay.LiveTrafficCommitmentLifecycle={
        acquireSupportingRegulationAuthority=function() error("must not acquire supporting authority for two-worker Passage") end
    }
    local runtime={}
    local bullet=OuttaMyWay.BubbleBulletTime.new(runtime)
    local picture={epoch=1,situations={{operationId="OP-2",memberAssemblyIds={"A","B"}}},motionEvidence={}}
    local candidate={evidenceBasis={cooperativePassageBridge={operationId="OP-2",assemblyIds={"A","B"}}}}
    local result,reason=bullet:prepareAtBubbleFormation(picture,candidate,{commitment={identity="CM-2"}})
    equal(reason,nil)
    equal(result.status,"NOT_REQUIRED")
    equal(result.physicalActive,nil)
end)

print(string.format("Bubble Bullet Time focused contract: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
