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

-- Admission rejection is a meaningful outcome of a qualifying native pair
-- candidate. Emit once per candidate occurrence; do not silently consume
-- the only evidence that can explain why no physical intervention followed.
local function reportRejectedAdmission(runtime,evidence,reason)
    local publication=runtime.publication
    if publication==nil then return end
    publication:publish("NORMAL","WARNING","HOLD_RELOCATE_ADMISSION_REJECTED",function()
        return {
            pairKey=tostring(evidence.pairKey or "unknown"),
            reason=tostring(reason or "UNSPECIFIED_ADMISSION_REJECTION"),
            confirmedBlockedMs=evidence.confirmedBlockedMs,
            version=OuttaMyWay.VERSION
        }
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
        lastReportedEgressRegulationResults=nil,
        lastReportedInitialMotionEvidence=nil,
        isRuntimeReported=false
    },Runtime)
end

function Runtime:loadMap()
    self.isRuntimeReported=false
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
    if not self.isRuntimeReported then
        self.isRuntimeReported=true
        issue(self,"INFO","HOLD_RELOCATE_RUNTIME_ACTIVE","SERVER_LISTENER_RUNNING")
    end
    local nowMs=tonumber(g_time)
    if type(nowMs)~="number" or nowMs~=nowMs then
        self:relinquish("CLOCK_UNAVAILABLE")
        return
    end
    if coordinator:isActive() then
        coordinator:advance(nowMs)
        local motion=coordinator.lastInitialMotionEvidence
        if motion~=nil and motion~=self.lastReportedInitialMotionEvidence then
            self.lastReportedInitialMotionEvidence=motion
            issue(self,"INFO","HOLD_RELOCATE_INITIAL_REVERSE_VECTOR",
                "commitmentId="..tostring(motion.commitmentId)
                .." angleToTargetDeg="..tostring(motion.relativeToTargetDeg)
                .." angleToNativeReverseDeg="..
                    tostring(motion.relativeToNativeReverseDeg))
        end
        local results=coordinator.lastEgressRegulationResults
        if results~=nil and results~=self.lastReportedEgressRegulationResults then
            self.lastReportedEgressRegulationResults=results
            for i=1,#results do
                local e=results[i]
                issue(self,"INFO","HOLD_RELOCATE_EGRESS_REGULATION_EVIDENCE",
                    "commitmentId="..tostring(e.commitmentId)
                    .." blockerRootId="..tostring(e.rootId)
                    .." nativeDriveCalls="..tostring(e.interceptCount)
                    .." displacementM="..tostring(e.displacementM)
                    .." regulationKmh="..tostring(e.regulatedSpeedKmh)
                    .." lastNativeSpeedKmh="..tostring(e.lastNativeSpeedKmh))
            end
        end
        if not coordinator:isActive() then
            local outcome=coordinator:getStatus().lastOutcome
            if outcome~=nil then
                issue(self,outcome.status=="NATIVE_RESTART_ACCEPTED" and "INFO" or "WARNING",
                    "HOLD_RELOCATE_OUTCOME",outcome.status
                        .." reason="..tostring(outcome.reason))
            end
            self.authority:release(self.authority.active)
        end
        return
    end
    local candidates=        return
    end
    local candidates=self.observer and self.observer:getCurrentPairCandidates() or nil
    if type(candidates)~="table" then return end
    for i=1,#candidates do
        local evidence=candidates[i]
        if type(evidence)=="table" and evidence.candidateIdentity~=nil
            and not self.attempted[evidence.candidateIdentity] then
            local commitment,reason=self.authority:admitCandidate(
                evidence.firstWorker,evidence.secondWorker,
                evidence.blockedWorker,evidence.confirmedBlockedMs)
            -- An admission attempt is single-shot per native pair occurrence,
            -- including rejection. A later native occurrence is a new key.
            self.attempted[evidence.candidateIdentity]=true
            if commitment==nil then
                reportRejectedAdmission(self,evidence,reason)
            else
                local accepted,why=coordinator:begin(commitment,nowMs)
                if accepted then
                    local details=commitment.commitmentId
                    if type(why)=="table"
                        and type(why.requestedReverseSpeedKmh)=="number" then
                        details=details.." requestedReverseSpeedKmh="..
                            tostring(why.requestedReverseSpeedKmh)
                    end
                    if type(why)=="table" and why.regionRequiredProgressM~=nil then
                        details=details.." requiredLateralM="..
                            tostring(why.regionRequiredProgressM)
                            .." directionSource="..tostring(why.directionSource)
                            .." blockerWidthM="..tostring(why.blockerWorkingWidthM)
                            .." marginM="..tostring(why.marginM)
                            .." vectorDistanceM="..tostring(why.vectorDistanceM)
                            .." obliqueDeg="..tostring(why.nominalBearingOffsetDeg)
                            .." egressSide="..tostring(why.egressSide)
                            .." regionInField="..tostring(why.targetInField)
                            .." fieldInteriorScore="..tostring(why.fieldInteriorScore)
                    end
                    issue(self,"INFO","HOLD_RELOCATE_STARTED",details)
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
