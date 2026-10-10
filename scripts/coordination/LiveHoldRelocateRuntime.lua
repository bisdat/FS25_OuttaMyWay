-- Runs native blocked recovery after independently admitted pair/solo commitment.
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
    return setmetatable({
        configuration=configuration,observer=observer,
        authority=authority,physicalControl=physical,coordinator=coordinator,
        attempted=setmetatable({},{__mode="k"}),
        publication=OuttaMyWay.LogPublication.origin("HOLD_RELOCATE"),
        lastReportedEgressRegulationResults=nil,
        lastReportedInitialMotionEvidence=nil,
        lastReportedStaticMotionEvidence=nil,
        lastReportedPairMotionStartEvidence=nil,
        lastReportedPairTransitExhaustion=nil,
        isRuntimeReported=false
    },Runtime)
end

function Runtime:loadMap()
    self.isRuntimeReported=false
    -- A new map cannot inherit attempted native occurrences or publication
    -- references from a previous map.
    self.attempted=setmetatable({},{__mode="k"})
    self.lastReportedEgressRegulationResults=nil
    self.lastReportedInitialMotionEvidence=nil
    self.lastReportedStaticMotionEvidence=nil
    self.lastReportedPairMotionStartEvidence=nil
    self.lastReportedPairTransitExhaustion=nil
end

-- Disabling requests immediate native Control release; completion is reported
-- for the current episode only, without parked cross-episode job history.
function Runtime:relinquish(reason)
    local active=self.coordinator.active
    if active==nil then
        -- No physical action survives; likewise do not retain an abandoned
        -- admission when disabling or leaving the map.
        if self.authority.active~=nil then
            self.authority:release(self.authority.active)
        end
        return true
    end
    local commitment=active.commitment
    local released,why=self.coordinator:relinquish(reason or "CONTROL_REVOKED")
    -- The coordinator reports failed native cleanup separately. It always
    -- ends this attempt; its former authority must not veto a later pulse.
    if not self.coordinator:isActive() then
        self.authority:release(commitment)
    end
    if not released then issue(self,"WARNING","HOLD_RELOCATE_UNRESOLVED",why) end
    return released
end

function Runtime:deleteMap()
    self:relinquish("MAP_DELETE")
    self.attempted=setmetatable({},{__mode="k"})
    self.lastReportedEgressRegulationResults=nil
    self.lastReportedInitialMotionEvidence=nil
    self.lastReportedStaticMotionEvidence=nil
    self.lastReportedPairMotionStartEvidence=nil
    self.lastReportedPairTransitExhaustion=nil
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
        coordinator:advance(nowMs,dt)
        local wait=coordinator.lastPairTransitExhaustion
        if wait~=nil and wait~=self.lastReportedPairTransitExhaustion then
            self.lastReportedPairTransitExhaustion=wait
            issue(self,"WARNING","PAIR_TRANSIT_SETTLEMENT_EXHAUSTED",
                "commitmentId="..tostring(wait.commitmentId)
                .." waitedMs="..tostring(wait.elapsedMs)
                .." action=CONTINUE_PAIR_EGRESS_ASSESSMENT"
                .." firstFoldStatus="..tostring(wait.first
                    and wait.first.isSettled)
                .." secondFoldStatus="..tostring(wait.second
                    and wait.second.isSettled))
        end
        local start=coordinator.lastPairMotionStartEvidence
        if start~=nil and start~=self.lastReportedPairMotionStartEvidence then
            self.lastReportedPairMotionStartEvidence=start
            issue(self,"INFO","HOLD_RELOCATE_EGRESS_STARTED",
                "commitmentId="..tostring(start.commitmentId)
                .." relocator="..tostring(start.relocatingAssemblyReferenceKey)
                .." protected="..tostring(start.otherAssemblyReferenceKey)
                .." direction="..tostring(start.directionSource)
                .." optionsAssessed="..tostring(start.cascadeAttempts)
                .." regionTravelM="..tostring(start.regionTravelM)
                .." remainingWorkingWidthM="..tostring(
                    start.remainingWorkingWidthM)
                .." workingCorridorMarginM="..tostring(
                    start.workingCorridorMarginM)
                .." transitWaitExhausted="..tostring(start.transitWaitExhausted)
                .." firstFoldSettled="..tostring(start.firstFoldSettled)
                .." secondFoldSettled="..tostring(start.secondFoldSettled)
                .." representation="..tostring(start.geometryBasis)
                .." confirmedPhysicalClearance=false"
                .." nativeSpeedKmh="..tostring(start.requestedDriveSpeedKmh))
        end
        local static=coordinator.lastStaticMotionEvidence
        if static~=nil and static~=self.lastReportedStaticMotionEvidence then
            self.lastReportedStaticMotionEvidence=static
            issue(self,"INFO","HOLD_RELOCATE_STATIC_ACTUATION_EVIDENCE",
                "commitmentId="..tostring(static.commitmentId)
                .." subjectRootId="..tostring(static.subjectRootId)
                .." motorStarted="..tostring(static.motorStarted)
                .." nativeDriveCalls="..tostring(static.commandedDriveCount)
                .." physicalDisplacementM="..
                    tostring(static.physicalDisplacementM)
                .." lateralProgressM="..tostring(static.progressM)
                .." requiredLateralM="..tostring(static.requiredProgressM)
                .." statusReason="..tostring(static.statusReason))
        end
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
                issue(self,(outcome.status=="NATIVE_RESTART_ACCEPTED"
                    or outcome.status=="STATIC_BLOCKER_MOVED") and "INFO" or "WARNING",
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
                -- Single native pulse: inferred inactive subject first,
                -- established solo BWR when the one-shot snapshot lacks one.
                commitment,reason=self.authority:admitStaticBlockerCandidate(
                    evidence.worker,evidence.confirmedBlockedMs,
                    evidence.encounterSnapshot)
                if commitment==nil then
                    commitment,reason=self.authority:admitSingleCandidate(
                        evidence.worker,evidence.confirmedBlockedMs)
                end
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
                    if commitment.kind=="STATIC_BLOCKER" then
                        details=details.." inferredStaticSubject="
                            ..tostring(commitment.relocator.assemblyReferenceKey)
                            .." blockedBeneficiary="
                            ..tostring(evidence.worker.rootNode)
                    end
                    if type(why)=="table"
                        and type(why.requestedReverseSpeedKmh)=="number" then
                        details=details.." requestedReverseSpeedKmh="..
                            tostring(why.requestedReverseSpeedKmh)
                    end
                    if type(why)=="table" and why.requestedDriveSpeedKmh~=nil then
                        details=details.." requestedDriveSpeedKmh="
                            ..tostring(why.requestedDriveSpeedKmh)
                    end
                    if type(why)=="table" and why.cascadeMode~=nil then
                        details=details.." cascadeMode="..tostring(why.cascadeMode)
                            .." cascadeAttempts="..tostring(why.cascadeAttempts)
                    end
                    if type(why)=="table" and why.beneficiaryWorkingWidthM~=nil then
                        details=details.." beneficiaryWorkingWidthM="
                            ..tostring(why.beneficiaryWorkingWidthM)
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
