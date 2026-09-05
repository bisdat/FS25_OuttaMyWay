OuttaMyWay.BoundedAuthority = {}
local Authority = OuttaMyWay.BoundedAuthority
Authority.__index = Authority

local function copyValue(value)
    if type(value)~="table" then return value end
    local result={}
    for key,item in OuttaMyWay.ValueRecord.pairs(value) do result[key]=copyValue(item) end
    return result
end

local function valueEquals(a,b)
    if type(a)~=type(b) then return false end
    if type(a)~="table" then return a==b end
    local seen={}
    for key,item in OuttaMyWay.ValueRecord.pairs(a) do
        if not valueEquals(item,b[key]) then return false end
        seen[key]=true
    end
    for key,_ in OuttaMyWay.ValueRecord.pairs(b) do
        if seen[key]~=true then return false end
    end
    return true
end

local function currentFor(runtime,responsibilityId,commitmentId)
    local transition=runtime and runtime.responsibilityTransitionAuthority or nil
    if transition==nil then return nil end
    local current=transition:getCurrentRegulation(commitmentId)
    if current~=nil and current.identity==responsibilityId then return current end
    current=transition:getCurrentResolutionCommitment(commitmentId)
    if current~=nil and current.identity==responsibilityId then return current end
    return nil
end

local function targetMatchesGrant(requestTarget,grantTarget,capability)
    if type(requestTarget)~="table" or type(grantTarget)~="table" then return false,"BOUNDED_AUTHORITY_TARGET_UNAVAILABLE" end
    if capability=="REGULATE_SPEED" then
        if requestTarget.kind~=grantTarget.kind or requestTarget.vehicleReferenceKey~=grantTarget.vehicleReferenceKey
            or requestTarget.ownerTag~=grantTarget.ownerTag or requestTarget.governingPurpose~=grantTarget.governingPurpose then
            return false,"BOUNDED_AUTHORITY_REGULATION_TARGET_MISMATCH"
        end
        if requestTarget.operation=="RELEASE" then return true,nil end
        if requestTarget.operation~="APPLY" then return false,"BOUNDED_AUTHORITY_REGULATION_OPERATION_UNSUPPORTED" end
        local requested=tonumber(requestTarget.maxSpeedKmh)
        local granted=tonumber(grantTarget.maxSpeedKmh)
        if requested==nil or granted==nil then return false,"BOUNDED_AUTHORITY_REGULATION_MAGNITUDE_UNAVAILABLE" end
        if requested>granted then return false,"BOUNDED_AUTHORITY_REGULATION_MAGNITUDE_BROADENED" end
        return true,nil
    end
    if not valueEquals(requestTarget,grantTarget) then return false,"BOUNDED_AUTHORITY_REPOSITION_TARGET_BROADENED" end
    return true,nil
end

local function tokenFor(runtime,commitmentId,assemblyId,authorityToken)
    for _,token in OuttaMyWay.ValueRecord.ipairs(runtime.authorities:tokensForCommitment(commitmentId)) do
        if token.identity==authorityToken and token.assemblyId==assemblyId and runtime.authorities:validate(token)==true then return token end
    end
    return nil
end

function Authority.new(runtime)
    return setmetatable({runtime=runtime,grantsById={},grantIdsByResponsibilityId={},grantIdsByCommitmentId={}},Authority)
end

function Authority:authorize(values)
    if type(values)~="table" then return nil,"BOUNDED_AUTHORITY_CONTEXT_REQUIRED" end
    local responsibilityId=values.responsibilityId
    local commitmentId=values.commitmentId
    if currentFor(self.runtime,responsibilityId,commitmentId)==nil then return nil,"BOUNDED_AUTHORITY_CURRENT_RESPONSIBILITY_MISMATCH" end
    local commitment=self.runtime.commitments:get(commitmentId)
    if commitment==nil or commitment.state~="ACTIVE" then return nil,"BOUNDED_AUTHORITY_RETAINED_COMMITMENT_NOT_ACTIVE" end
    if commitment.effectiveActuationCompositionId~=values.effectiveActuationCompositionId then return nil,"BOUNDED_AUTHORITY_COMPOSITION_STALE" end
    local token=tokenFor(self.runtime,commitmentId,values.assemblyId,values.authorityToken)
    if token==nil then return nil,"BOUNDED_AUTHORITY_TOKEN_INVALID" end
    local grant=OuttaMyWay.BoundedAuthorityGrant.new({
        identity=self.runtime.identities:issue("BOUNDED_AUTHORITY"),
        responsibilityId=responsibilityId,commitmentId=commitmentId,assemblyId=values.assemblyId,capability=values.capability,
        target=copyValue(values.target),authorityToken=values.authorityToken,operationalPictureEpoch=values.operationalPictureEpoch,
        evidenceEpoch=values.evidenceEpoch,effectiveActuationCompositionId=values.effectiveActuationCompositionId,
        preconditions=copyValue(values.preconditions or {}),invalidationConditions=copyValue(values.invalidationConditions or {}),
        provenance=copyValue(values.provenance or {})
    })
    self.grantsById[grant.identity]=grant
    self.grantIdsByResponsibilityId[responsibilityId]=self.grantIdsByResponsibilityId[responsibilityId] or {}
    self.grantIdsByResponsibilityId[responsibilityId][grant.identity]=true
    self.grantIdsByCommitmentId[commitmentId]=self.grantIdsByCommitmentId[commitmentId] or {}
    self.grantIdsByCommitmentId[commitmentId][grant.identity]=true
    return grant,nil
end

function Authority:get(grantId)
    return self.grantsById[grantId]
end

function Authority:isCurrent(grantId)
    return self.grantsById[grantId]~=nil
end

function Authority:validateRequest(request,expectedResponsibilityId)
    OuttaMyWay.ValueRecord.assertType(request,"ControlRequest")
    local grant=self:get(request.boundedAuthorityId)
    if grant==nil then return false,"BOUNDED_AUTHORITY_GRANT_NOT_CURRENT" end
    if expectedResponsibilityId~=nil and grant.responsibilityId~=expectedResponsibilityId then return false,"BOUNDED_AUTHORITY_RESPONSIBILITY_MISMATCH" end
    if currentFor(self.runtime,grant.responsibilityId,grant.commitmentId)==nil then return false,"BOUNDED_AUTHORITY_CURRENT_RESPONSIBILITY_NOT_LIVE" end
    if request.commitmentId~=grant.commitmentId then return false,"BOUNDED_AUTHORITY_COMMITMENT_MISMATCH" end
    if request.assemblyId~=grant.assemblyId then return false,"BOUNDED_AUTHORITY_ASSEMBLY_MISMATCH" end
    if request.capability~=grant.capability then return false,"BOUNDED_AUTHORITY_CAPABILITY_MISMATCH" end
    if request.authorityToken~=grant.authorityToken then return false,"BOUNDED_AUTHORITY_TOKEN_MISMATCH" end
    if request.effectiveActuationCompositionId~=grant.effectiveActuationCompositionId then return false,"BOUNDED_AUTHORITY_COMPOSITION_MISMATCH" end
    if tokenFor(self.runtime,grant.commitmentId,grant.assemblyId,grant.authorityToken)==nil then return false,"BOUNDED_AUTHORITY_TOKEN_STALE" end
    local targetOk,targetReason=targetMatchesGrant(request.target,grant.target,grant.capability)
    if not targetOk then return false,targetReason end
    return true,nil,grant
end

function Authority:release(grantId,reason)
    local grant=self.grantsById[grantId]
    if grant==nil then return false,"BOUNDED_AUTHORITY_GRANT_NOT_CURRENT" end
    self.grantsById[grantId]=nil
    local byResponsibility=self.grantIdsByResponsibilityId[grant.responsibilityId]
    if byResponsibility~=nil then byResponsibility[grantId]=nil end
    local byCommitment=self.grantIdsByCommitmentId[grant.commitmentId]
    if byCommitment~=nil then byCommitment[grantId]=nil end
    return true,reason
end

function Authority:releaseForResponsibility(responsibilityId,reason)
    local ids=self.grantIdsByResponsibilityId[responsibilityId]
    local released={}
    for grantId,_ in pairs(ids or {}) do
        if self:release(grantId,reason)==true then released[#released+1]=grantId end
    end
    table.sort(released)
    return released
end

function Authority:releaseForCommitment(commitmentId,reason)
    local ids=self.grantIdsByCommitmentId[commitmentId]
    local released={}
    for grantId,_ in pairs(ids or {}) do
        if self:release(grantId,reason)==true then released[#released+1]=grantId end
    end
    table.sort(released)
    return released
end
