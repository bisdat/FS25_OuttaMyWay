OuttaMyWay.GuardedRecoveryCompatibility = {}
local Compatibility = OuttaMyWay.GuardedRecoveryCompatibility
Compatibility.__index = Compatibility

function Compatibility.new(runtime,regulationAuthority)
    return setmetatable({runtime=runtime,regulationAuthority=regulationAuthority},Compatibility)
end

function Compatibility:dispatch(picture,evaluated,candidate)
    local authority=self.regulationAuthority
    if authority~=nil and type(authority._dispatchGuardedRecovery)=="function" then
        return authority:_dispatchGuardedRecovery(picture,evaluated,candidate)
    end
    return nil
end

function Compatibility:getGuardedRecoveryStatus()
    local authority=self.regulationAuthority
    if authority~=nil and type(authority.getGuardedRecoveryStatus)=="function" then
        return authority:getGuardedRecoveryStatus()
    end
    return {active=false,applyCount=0,releaseCount=0,ownerTag="D0123_GUARDED_RECOVERY"}
end

function Compatibility:retireTrafficLeaseForCommitment(commitmentId,reason)
    local authority=self.regulationAuthority
    if authority~=nil and type(authority.retireGuardedRecoveryLeaseForCommitment)=="function" then
        return authority:retireGuardedRecoveryLeaseForCommitment(commitmentId,reason)
    end
    return {released=0}
end
