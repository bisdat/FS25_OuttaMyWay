-- Runs native blocked recovery after independently admitted pair/solo commitment.
-- Specification Jurisdictions: `HOLD_RELOCATE`, `OBSTRUCTION_RELOCATION`
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
            pairKey=tostring(evidence.pairKey or "none"),
            candidateKind=evidence.worker~=nil and "SINGLE" or "PAIR",
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
    local nonActiveControl=OuttaMyWay.NonActiveRelocationControl.new()
    return setmetatable({
        configuration=configuration,observer=observer,
        authority=authority,physicalControl=physical,coordinator=coordinator,
        nonActiveControl=nonActiveControl,pendingContinuation=nil,
        attempted=setmetatable({},{__mode="k"}),
        publication=OuttaMyWay.LogPublication.origin("HOLD_RELOCATE"),
        lastReportedEgressRegulationResults=nil,
        lastReportedInitialMotionEvidence=nil,
        isRuntimeReported=false
    },Runtime)
end

function Runtime:loadMap()
    self.isRuntimeReported=false
    self.pendingContinuation=nil
    -- Candidate evidence belongs to the native Observer's map lifecycle.
end

-- Disabling requests immediate native Control release; completion is reported
-- for the current episode only, without parked cross-episode job history.
function Runtime:relinquish(reason)
    local physicalReleased=self.nonActiveControl:relinquish(
        reason or "CONTROL_REVOKED")
    self.pendingContinuation=nil
    if not physicalReleased then
        issue(self,"WARNING","OBSTRUCTION_RELOCATION_UNRESOLVED","PHYSICAL_CLEANUP")
    end
    if not self.coordinator:isActive() then return physicalReleased end
    local released,why=self.coordinator:relinquish(reason or "CONTROL_REVOKED")
    if not released then issue(self,"WARNING","HOLD_RELOCATE_UNRESOLVED",why) end
    return released and physicalReleased
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
    -- Non-job actuation is distinct from the active worker's BWR. It owns
    -- only the current positively nominated single blocked occurrence.
    if self.nonActiveControl:isActive() then
        self.nonActiveControl:advance(dt)
        if not self.nonActiveControl:isActive() then
            local outcome=self.nonActiveControl.lastOutcome
            if outcome~=nil then
                issue(self,outcome.physicalCleanupConfirmed and "INFO" or "WARNING",
                    "OBSTRUCTION_RELOCATION_OUTCOME",
                    outcome.status.." blocker="..outcome.blockerRootId
                    .." progressM="..tostring(outcome.progressM)
                    .." field="..tostring(outcome.fieldIdentitySource))
            end
        end
        return
    end
    if self.pendingContinuation~=nil then
        local pending=self.pendingContinuation
        local current=pending.strategy
        if type(current)=="table" and current.isBlocked==false then
            issue(self,"INFO","OBSTRUCTION_RELOCATION_NATIVE_UNBLOCKED",
                "PRODUCTIVE_CONTINUATION_NOT_INDEPENDENTLY_CONFIRMED")
            self.pendingContinuation=nil
        elseif not OuttaMyWay.NonActiveObstructionAssessment.isStillCurrent(
                pending.evidence) then
            issue(self,"WARNING","OBSTRUCTION_RELOCATION_UNRESOLVED",
                "CURRENT_BENEFICIARY_OR_BLOCKER_CHANGED")
            self.pendingContinuation=nil
        end
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
    -- Pair concern is considered first; solo concerns are independent
    -- blocked-worker occurrences, never forged into synthetic pairs.
    local pairs=self.observer and self.observer:getCurrentPairCandidates() or {}
    local singles=self.observer and self.observer.getCurrentSingleCandidates
        and self.observer:getCurrentSingleCandidates() or {}
    local candidates={}
    if type(pairs)=="table" then
        for i=1,#pairs do candidates[#candidates+1]=pairs[i] end
    end
    if type(singles)=="table" then
        for i=1,#singles do candidates[#candidates+1]=singles[i] end
    end
    for i=1,#candidates do
        local evidence=candidates[i]
        if type(evidence)=="table" and evidence.candidateIdentity~=nil
            and not self.attempted[evidence.candidateIdentity] then
            local commitment,reason
            if evidence.worker~=nil then
                -- Positive current GIANTS blockage plus *one* current
                -- non-active vehicle in the immediate occupied corridor.
                -- Completion history and general proximity are not authority.
                local obstruction=OuttaMyWay.NonActiveObstructionAssessment.find(
                    evidence.worker)
                if obstruction~=nil then
                    local admitted,details=self.nonActiveControl:begin(obstruction)
                    if admitted then
                        self.attempted[evidence.candidateIdentity]=true
                        self.pendingContinuation={
                            evidence=obstruction,
                            strategy=details.sourceStrategy
                        }
                        issue(self,"INFO","OBSTRUCTION_RELOCATION_STARTED",
                            "blocker="..tostring(obstruction.blocker.rootNode)
                            .." beneficiary="..tostring(evidence.worker.rootNode)
                            .." targetProgressM="..tostring(details.targetProgressM)
                            .." field="..tostring(details.fieldIdentitySource))
                        return
                    end
                    issue(self,"WARNING","OBSTRUCTION_RELOCATION_NOT_ADMITTED",
                        tostring(details))
                end
                commitment,reason=self.authority:admitSingleCandidate(
                    evidence.worker,evidence.confirmedBlockedMs)
            else
                commitment,reason=self.authority:admitCandidate(
                    evidence.firstWorker,evidence.secondWorker,
                    evidence.blockedWorker,evidence.confirmedBlockedMs)
            end
            -- An admission is attempted once per current native occurrence.
            -- Later independent blocked pulses create new candidate identities.
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
                        if why.fieldIdentitySource~=nil then
                            details=details.." fieldIdentitySource="
                                ..tostring(why.fieldIdentitySource)
                        end
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
