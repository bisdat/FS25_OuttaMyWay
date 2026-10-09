-- Runs accepted Hold & Relocate only after independently issued Pair Commitment.
-- Specification Jurisdictions: `HOLD_RELOCATE`
-- Observation nominates; authority admits; Control executes; GIANTS owns jobs.
OuttaMyWay=OuttaMyWay or {}
OuttaMyWay.LiveHoldRelocateRuntime={}
local Runtime=OuttaMyWay.LiveHoldRelocateRuntime
Runtime.__index=Runtime

local function issue(runtime,level,code,detail)
    local publication=runtime.publication
    if publication==nil then return end
    publication:publish("NORMAL",level,code,function()
        return {detail=tostring(detail or ""),version=OuttaMyWay.VERSION}
    end)
end

function Runtime.new(configuration,observer)
    local authority=OuttaMyWay.NativePairCommitmentAuthority.new(configuration)
    local physical=OuttaMyWay.HoldRelocatePhysicalControl.new(authority)
    local coordinator=OuttaMyWay.HoldRelocateCoordinator.new(authority,physical)
    return setmetatable({
        configuration=configuration,observer=observer,
        authority=authority,physicalControl=physical,coordinator=coordinator,
        attempted=setmetatable({},{__mode="k"}),
        publication=OuttaMyWay.LogPublication.origin("HOLD_RELOCATE"),
        lastReportedOutcome=nil
    },Runtime)
end

function Runtime:loadMap()
    -- Already constructed after the current Configuration was resolved.
    -- Candidate evidence belongs to the native Observer's map lifecycle.
end

-- Disabling is immediate. Safety/cleanup failure retains the coordinator's
-- explicit UNRESOLVED state; it must never be silently marked successful.
function Runtime:relinquish(reason)
    if not self.coordinator:isActive() then return true end
    local released,why=self.coordinator:relinquish(reason or "CONTROL_REVOKED")
    if not released then issue(self,"WARNING","HOLD_RELOCATE_UNRESOLVED",why) end
    return released
end

function Runtime:deleteMap()
    self:relinquish("MAP_DELETE")
end

function Runtime:update(dt)
    local coordinator=self.coordinator
    if not self.authority:enabled() then
        self:relinquish("DISABLED_OR_SERVER_LOST")
        return
    end
    local nowMs=tonumber(g_time)
    if type(nowMs)~="number" or nowMs~=nowMs then
        self:relinquish("CLOCK_UNAVAILABLE")
        return
    end
    if coordinator:isActive() then
        coordinator:advance(nowMs)
        if not coordinator:isActive() then
            local outcome=coordinator:getStatus().lastOutcome
            if outcome~=nil then
                issue(self,outcome.status=="NATIVE_RESTART_ACCEPTED" and "INFO" or "WARNING",
                    "HOLD_RELOCATE_OUTCOME",outcome.status)
            end
            self.authority:release(self.authority.active)
        elseif coordinator:getStatus().phase=="WAITING_FOR_PLAYER_INTERVENTION" then
            local outcome=coordinator:getStatus().lastOutcome
            if outcome~=self.lastReportedOutcome then
                self.lastReportedOutcome=outcome
                issue(self,"WARNING","HOLD_RELOCATE_UNRESOLVED",
                    outcome and outcome.reason)
            end
        end
        return
    end
    local candidates=self.observer and self.observer:getCurrentPairCandidates() or nil
    if type(candidates)~="table" then return end
    for i=1,#candidates do
        local evidence=candidates[i]
        if type(evidence)=="table" and evidence.candidateIdentity~=nil
            and not self.attempted[evidence.candidateIdentity] then
            self.attempted[evidence.candidateIdentity]=true
            local commitment,reason=self.authority:admitCandidate(
                evidence.firstWorker,evidence.secondWorker,
                evidence.blockedWorker,evidence.confirmedBlockedMs)
            if commitment~=nil then
                local accepted,why=coordinator:begin(commitment,nowMs)
                if accepted then
                    issue(self,"INFO","HOLD_RELOCATE_STARTED",commitment.commitmentId)
                elseif coordinator:isActive() then
                    issue(self,"WARNING","HOLD_RELOCATE_UNRESOLVED",why)
                else
                    self.authority:release(commitment)
                    issue(self,"WARNING","HOLD_RELOCATE_NOT_STARTED",why)
                end
                break
            end
        end
    end
end
