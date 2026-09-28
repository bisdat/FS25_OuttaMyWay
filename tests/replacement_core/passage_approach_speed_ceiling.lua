local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/publication/LogPublication.lua")
OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new(function() return "DIAGNOSTIC" end)
load("scripts/contracts/ValueRecord.lua")
load("scripts/authority/EffectiveActuationComposition.lua")
load("scripts/authority/PassageApproachSpeedCeiling.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then passed=passed+1; print("PASS "..name)
    else failed=failed+1; print("FAIL "..name..": "..tostring(err)) end
end
local function equal(a,b,message)
    if a~=b then error(message or (tostring(a).." ~= "..tostring(b)),2) end
end

test("Passage approach ceiling applies ten kilometre per hour supporting leases to both participants and releases at Capture",function()
    local commitment={identity="CM-1",state="ACTIVE",effectiveActuationCompositionId="COMP-PAIR"}
    local current={identity="RS-1"}
    local compositionSequence=0
    local grants,dispatches,clears,releases=0,0,0,0
    OuttaMyWay.CommitmentStateMachine={isTerminal=function(record) return record.state~="ACTIVE" end}

    local runtime={
        identities={issue=function(_,kind)
            equal(kind,"COMPOSITION")
            compositionSequence=compositionSequence+1
            return "COMP-SUPPORT-"..tostring(compositionSequence)
        end},
        epochs={next=function() return 12 end},
        commitments={get=function(_,id) if id=="CM-1" then return commitment end end},
        boundedAuthority={
            authorize=function(_,values)
                grants=grants+1
                equal(values.responsibilityId,"RS-1")
                equal(values.commitmentId,"CM-1")
                equal(values.capability,"REGULATE_SPEED")
                equal(values.authorityRole,"SUPPORTING_SPEED_CEILING")
                equal(values.target.ownerTag,"PASSAGE_APPROACH_SPEED_CEILING")
                equal(values.target.maxSpeedKmh,10.0)
                equal(values.effectiveActuationCompositionId,"COMP-PAIR")
                equal(values.supportingSpeedCeilingComposition.identity,"COMP-SUPPORT-1")
                equal(#values.supportingSpeedCeilingComposition.entries,2)
                return {identity="BA-"..tostring(grants),preconditions={},invalidationConditions={}},nil
            end,
            materializeRequest=function(_,values)
                return {
                    identity="CR-"..tostring(grants),boundedAuthorityId=values.boundedAuthorityId,
                    commitmentId="CM-1",assemblyId=grants==1 and "A" or "B",capability="REGULATE_SPEED",
                    target=values.target,authorityRole="SUPPORTING_SPEED_CEILING",effectiveActuationCompositionId="COMP-PAIR"
                },nil
            end,
            release=function() releases=releases+1; return true end
        },
        responsibilityTransitionAuthority={
            getCurrentResolutionCommitment=function(_,id) if id=="CM-1" and commitment.state=="ACTIVE" then return current end end
        },
        liveControlDispatcher={
            dispatch=function(_,request)
                dispatches=dispatches+1
                equal(request.target.operation,"APPLY")
                equal(request.target.maxSpeedKmh,10.0)
                equal(request.authorityRole,"SUPPORTING_SPEED_CEILING")
                return true,"REGULATION_LEASE_APPLIED"
            end,
            notifyAccepted=function() return true end,
            regulationControl={
                clearRegulationLeaseByReference=function(_,referenceKey,ownerTag)
                    clears=clears+1
                    equal(ownerTag,"PASSAGE_APPROACH_SPEED_CEILING")
                    if referenceKey~="vehicle-root:A" and referenceKey~="vehicle-root:B" then error("unexpected reference") end
                    return true,"CONTROL_CLEANUP_RELEASED"
                end
            }
        }
    }
    local candidate={preconditions={},invalidationConditions={},evidenceBasis={cooperativePassageBridge={
        subjectAssemblyId="A",otherAssemblyId="B",subjectReferenceKey="vehicle-root:A",otherReferenceKey="vehicle-root:B"
    }}}
    local ceiling=OuttaMyWay.PassageApproachSpeedCeiling.new(runtime)
    local prepared,reason=ceiling:prepareAtBubbleFormation(candidate,{commitment=commitment})
    equal(reason,nil); equal(prepared.status,"PREPARED"); equal(prepared.maxSpeedKmh,10.0)
    local active,activateReason=ceiling:activatePrepared("CM-1",{
        effectiveActuationCompositionId="COMP-PAIR",operationalPictureEpoch=10,evidenceEpoch=11,
        preconditions={},invalidationConditions={}
    },candidate)
    equal(activateReason,nil); equal(active.status,"ACTIVE"); equal(grants,2); equal(dispatches,2)
    equal(ceiling:releaseForCommitment("CM-1","PASSAGE_CAPTURE_HOLD_SUPERSEDES_APPROACH_CEILING"),true)
    equal(clears,2); equal(releases,2); equal(ceiling:getLease("CM-1"),nil)
end)

print(string.format("Passage Approach Speed Ceiling focused contract: %d passed, %d failed",passed,failed))
if failed>0 then os.exit(1) end
