local root = arg[1] or "."
local function load(relativePath) dofile(root .. "/" .. relativePath) end

OuttaMyWay = {}
load("scripts/config.lua")
load("scripts/publication/LogPublication.lua")
OuttaMyWay.logPublication=OuttaMyWay.LogPublication.new(function() return "DIAGNOSTIC" end)
load("scripts/contracts/ValueRecord.lua")
load("scripts/contracts/ControlRequest.lua")
load("scripts/commitment/CommitmentStateMachine.lua")

OuttaMyWay.LiveAIJobEvidence = {
    activeJobVehicles=function(mission)
        return mission and mission.aiSystem and mission.aiSystem.activeJobVehicles or {}
    end
}

load("scripts/control/RegulationControl.lua")

local passed,failed=0,0
local function test(name,fn)
    local ok,err=pcall(fn)
    if ok then
        passed=passed+1
        print("PASS "..name)
    else
        failed=failed+1
        print("FAIL "..name..": "..tostring(err))
    end
end

local function equal(actual,expected,message)
    if actual~=expected then error(message or (tostring(actual).." ~= "..tostring(expected)),2) end
end

local function fixture()
    local vehicle={rootNode=101,lastSpeedReal=0}
    g_currentMission={aiSystem={activeJobVehicles={vehicle}}}

    local commitment={
        identity="CM-RC",
        state="ACTIVE",
        effectiveActuationCompositionId="EC-RC"
    }
    local token={identity="AT-RC",assemblyId="AS-RC"}
    local authorityValidationCalls=0
    local runtime={
        commitments={
            get=function(_,commitmentId)
                if commitmentId==commitment.identity then return commitment end
                return nil
            end
        },
        authorities={
            tokensForCommitment=function(_,commitmentId)
                if commitmentId==commitment.identity then return {token} end
                return {}
            end,
            validate=function(_,candidateToken)
                return candidateToken==token
            end
        },
        boundedAuthority={
            validateRequest=function(_,request)
                authorityValidationCalls=authorityValidationCalls+1
                if request.boundedAuthorityId=="BA-RC" then return true,nil end
                return false,"TEST_BOUNDED_AUTHORITY_INVALID"
            end
        }
    }

    local drive={applyCalls=0,releaseCalls=0}
    function drive:setRegulationLease(appliedVehicle,speed,ownerTag,authorityRole)
        self.applyCalls=self.applyCalls+1
        self.lastAppliedVehicle=appliedVehicle
        self.lastAppliedSpeed=speed
        self.lastAppliedOwnerTag=ownerTag
        self.lastAppliedAuthorityRole=authorityRole
        return true,nil
    end
    function drive:clearRegulationLease(releasedVehicle,ownerTag)
        self.releaseCalls=self.releaseCalls+1
        self.lastReleasedVehicle=releasedVehicle
        self.lastReleasedOwnerTag=ownerTag
    end
    function drive:getState() return nil end

    local control=OuttaMyWay.RegulationControl.new(runtime,drive)
    local function request(operation,ownerTag,boundedAuthorityId,authorityRole)
        local authorityToken=token.identity
        if authorityRole=="SUPPORTING_SPEED_CEILING" then authorityToken=nil end
        return OuttaMyWay.ControlRequest.new({
            identity="CR-RC-"..operation.."-"..ownerTag,
            commitmentId=commitment.identity,
            assemblyId=token.assemblyId,
            capability="REGULATE_SPEED",
            target={
                kind="REGULATION_LEASE",
                operation=operation,
                vehicleReferenceKey="vehicle-root:101",
                ownerTag=ownerTag,
                maxSpeedKmh=1,
                governingPurpose="TEST_REGULATION_CONTROL_AUTHORITY"
            },
            authorityToken=authorityToken,
            authorityRole=authorityRole,
            boundedAuthorityId=boundedAuthorityId,
            operationalPictureEpoch=1,
            evidenceEpoch=1,
            effectiveActuationCompositionId=commitment.effectiveActuationCompositionId,
            preconditions={},
            invalidationConditions={}
        })
    end

    return {
        control=control,
        drive=drive,
        request=request,
        authorityValidationCalls=function() return authorityValidationCalls end
    }
end

test("unknown owner APPLY without Bounded Authority fails closed before physical actuation",function()
    local f=fixture()
    local ok,reason=f.control:executeControlRequest(f.request("APPLY","FUTURE_UNKNOWN_OWNER",nil),nil)
    equal(ok,false)
    equal(reason,"BOUNDED_AUTHORITY_GRANT_REQUIRED")
    equal(f.drive.applyCalls,0)
    equal(f.authorityValidationCalls(),0)
end)

test("unknown owner RELEASE without new Bounded Authority remains authority-narrowing cleanup",function()
    local f=fixture()
    local ok,reason=f.control:executeControlRequest(f.request("RELEASE","FUTURE_UNKNOWN_OWNER",nil),nil)
    equal(ok,true)
    equal(reason,"REGULATION_LEASE_RELEASED")
    equal(f.drive.releaseCalls,1)
    equal(f.drive.applyCalls,0)
    equal(f.authorityValidationCalls(),0)
end)

test("unknown owner APPLY with current Bounded Authority may reach physical actuation",function()
    local f=fixture()
    local ok,reason=f.control:executeControlRequest(f.request("APPLY","FUTURE_UNKNOWN_OWNER","BA-RC"),nil)
    equal(ok,true)
    equal(reason,"REGULATION_LEASE_APPLIED")
    equal(f.drive.applyCalls,1)
    equal(f.drive.lastAppliedOwnerTag,"FUTURE_UNKNOWN_OWNER")
    equal(f.authorityValidationCalls(),1)
end)

test("Supporting Speed Ceiling APPLY uses positive Bounded Authority without movement-owner token",function()
    local f=fixture()
    local request=f.request("APPLY","BUBBLE_BULLET_TIME","BA-RC","SUPPORTING_SPEED_CEILING")
    equal(request.authorityToken,nil)
    equal(request.authorityRole,"SUPPORTING_SPEED_CEILING")
    local ok,reason=f.control:executeControlRequest(request,nil)
    equal(ok,true)
    equal(reason,"REGULATION_LEASE_APPLIED")
    equal(f.drive.applyCalls,1)
    equal(f.drive.lastAppliedOwnerTag,"BUBBLE_BULLET_TIME")
    equal(f.drive.lastAppliedAuthorityRole,"SUPPORTING_SPEED_CEILING")
    equal(f.authorityValidationCalls(),1)
end)

test("supplied stale Bounded Authority still rejects APPLY before physical actuation",function()
    local f=fixture()
    local ok,reason=f.control:executeControlRequest(f.request("APPLY","ACTION_SPACE_REGULATION","BA-STALE"),nil)
    equal(ok,false)
    equal(reason,"TEST_BOUNDED_AUTHORITY_INVALID")
    equal(f.drive.applyCalls,0)
    equal(f.authorityValidationCalls(),1)
end)

print(string.format("RESULT passed=%d failed=%d",passed,failed))
if failed>0 then os.exit(1) end
