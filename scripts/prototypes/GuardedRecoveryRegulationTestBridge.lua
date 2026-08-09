-- FS25_OuttaMyWay v4.7.47 TEST BUILD.
--
-- Narrow D-0123 behavioural bridge for the existing P22 TS015 recovery fixture.
-- It consumes only the validated shadow representation pair
-- VS_COMMITTED_RECOVERY_UNION x CP_CURRENT_HEADING and applies the already-
-- proven P22 GIANTS-route Regulation mechanism to the fixture Progress worker.
--
-- This is NOT production Control authority. It does not create a production
-- Commitment, choose a Refuge Region, choose a production Regulation speed,
-- or alter the initial-head-on timing. The 1 km/h cap is a test literal only.

OuttaMyWay.GuardedRecoveryRegulationTestBridge = {}
local Bridge = OuttaMyWay.GuardedRecoveryRegulationTestBridge
Bridge.__index = Bridge

local OWNER_TAG = "D0123_GUARDED_RECOVERY_TEST"
local COMBINATION_KEY = "COMMITTED_RECOVERY_UNION__CURRENT_HEADING"

local function actualSpeedKmh(vehicle)
    return math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0) * 3600
end

local function logInfo(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][D0123-REGULATION-TEST] %s", message)
    else
        print("[FS25_OuttaMyWay][D0123-REGULATION-TEST] " .. message)
    end
end

local function logWarning(formatText, ...)
    local message = string.format(formatText, ...)
    if Logging ~= nil and type(Logging.warning) == "function" then
        Logging.warning("[FS25_OuttaMyWay][D0123-REGULATION-TEST] %s", message)
    else
        print("[FS25_OuttaMyWay][D0123-REGULATION-TEST][WARN] " .. message)
    end
end

function Bridge.evaluateSignal(sample)
    if OuttaMyWay.GuardedRecoveryConvergenceProbe ~= nil and type(OuttaMyWay.GuardedRecoveryConvergenceProbe.evaluateCurrentHeadingSignal) == "function" then
        return OuttaMyWay.GuardedRecoveryConvergenceProbe.evaluateCurrentHeadingSignal(sample)
    end
    return {status="UNRESOLVED", reason="D0123_SIGNAL_EVALUATOR_UNAVAILABLE"}
end

function Bridge.new()
    return setmetatable({
        active=nil,
        lastSignal=nil,
        lastSignalReason=nil,
        applyCount=0,
        releaseCount=0,
        nextHeartbeatAt=0
    }, Bridge)
end

function Bridge:_clearOwned(capabilityGate, reason, nowMs)
    local active = self.active
    if active == nil then return end
    local authority = capabilityGate and capabilityGate.driveAuthority or nil
    local state = authority and authority:getState(active.vehicle) or nil
    if state ~= nil and state.mode == "REGULATE" and state.ownerTag == OWNER_TAG then
        authority:clear(active.vehicle)
    end
    self.releaseCount = self.releaseCount + 1
    logInfo("RELEASE run=%s progress=%s ref=%s job=%s elapsedMs=%d reason=%s regulationSpeedLiteral=%.2fkmh policyAuthority=false productionControlAuthority=false",
        tostring(active.runNumber), tostring(active.progressName), tostring(active.progressReferenceKey), tostring(active.progressJobToken),
        math.max(0, (nowMs or 0) - (active.appliedAt or (nowMs or 0))), tostring(reason), tonumber(active.speedKmh) or 0)
    self.active = nil
    self.nextHeartbeatAt=0
end

function Bridge:_heartbeat(capabilityGate, signal, nowMs)
    if self.active == nil or nowMs < (self.nextHeartbeatAt or 0) then return end
    self.nextHeartbeatAt = nowMs + (OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_HEARTBEAT_MS or 500)
    local state = capabilityGate and capabilityGate.driveAuthority and capabilityGate.driveAuthority:getState(self.active.vehicle) or nil
    logInfo("SAMPLE run=%s progress=%s job=%s signal=%s actualSpeed=%.2fkmh driveCalls=%d inputMax=%s outputMax=%s inputForward=%s owner=%s regulationSpeedLiteral=%.2fkmh giantsRoute=true giantsSteering=true giantsDirection=true",
        tostring(self.active.runNumber), tostring(self.active.progressName), tostring(self.active.progressJobToken), tostring(signal and signal.status or self.lastSignal),
        actualSpeedKmh(self.active.vehicle), state and (state.driveCalls or 0) or 0,
        state and state.lastInputMaxSpeed and string.format("%.2f",state.lastInputMaxSpeed) or "n/a",
        state and state.lastOutputMaxSpeed and string.format("%.2f",state.lastOutputMaxSpeed) or "n/a",
        state and tostring(state.lastInputForward) or "n/a", state and tostring(state.ownerTag) or "n/a", tonumber(self.active.speedKmh) or 0)
end

function Bridge:reset(capabilityGate, reason)
    self:_clearOwned(capabilityGate, reason or "RESET", g_time or 0)
    self.lastSignal=nil
    self.lastSignalReason=nil
end

function Bridge:update(capabilityGate, convergenceProbe, nowMs)
    if capabilityGate == nil or convergenceProbe == nil then return end
    nowMs = nowMs or (g_time or 0)

    if OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_ENABLED ~= true then
        self:_clearOwned(capabilityGate, "TEST_BRIDGE_DISABLED", nowMs)
        return
    end

    local status = type(convergenceProbe.getStatus) == "function" and convergenceProbe:getStatus() or nil
    if type(status) ~= "table" or status.active ~= true then
        self:_clearOwned(capabilityGate, "VULNERABLE_SPACE_WINDOW_ENDED", nowMs)
        self.lastSignal="INACTIVE"
        self.lastSignalReason="NO_ACTIVE_GUARDED_RECOVERY_WINDOW"
        return
    end

    local sample = type(convergenceProbe.getLatestSample) == "function" and convergenceProbe:getLatestSample() or nil
    local signal = Bridge.evaluateSignal(sample)
    local changed = signal.status ~= self.lastSignal or signal.reason ~= self.lastSignalReason
    self.lastSignal=signal.status
    self.lastSignalReason=signal.reason

    if signal.status == "INVALIDATED" then
        self:_clearOwned(capabilityGate, signal.reason, nowMs)
        if changed then logWarning("SIGNAL status=INVALIDATED reason=%s action=RELEASE_TEST_AUTHORITY", tostring(signal.reason)) end
        return
    end

    if signal.status == "UNRESOLVED" then
        -- Once positive convergence has established Regulation, uncertainty does
        -- not manufacture a release. Preserve the existing cap while evidence
        -- reacquires; this is the test equivalent of WAITING_FOR_EVIDENCE.
        if changed then
            logInfo("SIGNAL status=UNRESOLVED reason=%s action=%s existingRegulation=%s",
                tostring(signal.reason), self.active ~= nil and "MAINTAIN_IF_ALREADY_ACTIVE" or "NO_ACTUATION", tostring(self.active ~= nil))
        end
        self:_heartbeat(capabilityGate, signal, nowMs)
        return
    end

    local combination = signal.combination or {}
    if signal.status == "NEGATIVE" then
        if changed then
            logInfo("SIGNAL status=NEGATIVE clearance=%s reason=%s action=RELEASE_IF_ACTIVE",
                combination.clearance and string.format("%.2fm", combination.clearance) or "n/a", tostring(signal.reason))
        end
        self:_clearOwned(capabilityGate, signal.reason, nowMs)
        return
    end

    local vehicle = sample and sample.progressVehicle or nil
    if vehicle == nil then
        if changed then logInfo("SIGNAL status=UNRESOLVED reason=PROGRESS_VEHICLE_UNAVAILABLE action=NO_ACTUATION") end
        return
    end

    if self.active ~= nil and (self.active.vehicle ~= vehicle or self.active.runNumber ~= sample.runNumber) then
        self:_clearOwned(capabilityGate, "GUARDED_RECOVERY_CONTEXT_CHANGED", nowMs)
    end

    local authority = capabilityGate.driveAuthority
    local existing = authority and authority:getState(vehicle) or nil
    if existing ~= nil and not (existing.mode == "REGULATE" and existing.ownerTag == OWNER_TAG) then
        if changed then
            logWarning("APPLY_REFUSED run=%s progress=%s reason=PROGRESS_HAS_OTHER_DRIVE_AUTHORITY mode=%s owner=%s",
                tostring(sample.runNumber), tostring(sample.progressName), tostring(existing.mode), tostring(existing.ownerTag))
        end
        return
    end

    local speedKmh = OuttaMyWay.GUARDED_RECOVERY_REGULATION_TEST_KMH or OuttaMyWay.PROTOTYPE_22_REGULATE_DEFAULT_KMH or 1.0
    if self.active == nil then
        local ok, reason = authority:setRegulation(vehicle, speedKmh, OWNER_TAG)
        if not ok then
            logWarning("APPLY_REFUSED run=%s progress=%s reason=%s", tostring(sample.runNumber), tostring(sample.progressName), tostring(reason))
            return
        end
        self.applyCount = self.applyCount + 1
        self.active={
            vehicle=vehicle,
            runNumber=sample.runNumber,
            progressName=sample.progressName,
            progressReferenceKey=sample.progressReferenceKey,
            progressJobToken=sample.progressExpectedJobToken,
            appliedAt=nowMs,
            speedKmh=speedKmh
        }
        logInfo("APPLY run=%s progress=%s ref=%s job=%s vulnerable=VS_COMMITTED_RECOVERY_UNION projection=CP_CURRENT_HEADING evidence=%s clearance=%s observeExhausted=true capability=REGULATE_SPEED speedLiteral=%.2fkmh speedLiteralAuthority=TEMPORARY_IMPLEMENTATION_VALUE_NOT_POLICY giantsRoute=true giantsSteering=true giantsDirection=true decisionAuthority=TEST_BRIDGE productionCommitment=PARTIAL_LIVE_COMMITMENT_CATCHUP productionControlAuthority=false",
            tostring(sample.runNumber), tostring(sample.progressName), tostring(sample.progressReferenceKey), tostring(sample.progressExpectedJobToken),
            tostring(sample.progressEvidenceClass).."/FORWARD", combination.clearance and string.format("%.2fm", combination.clearance) or "n/a", speedKmh)
    elseif existing == nil then
        -- Unexpected loss of our interceptor state while D-0123 remains positive.
        -- Reapply only our own already-established test authority.
        local ok, reason = authority:setRegulation(vehicle, speedKmh, OWNER_TAG)
        if ok then
            logWarning("REAPPLY run=%s progress=%s reason=OWNED_DRIVE_STATE_LOST_WHILE_CONVERGENCE_POSITIVE speedLiteral=%.2fkmh",
                tostring(sample.runNumber), tostring(sample.progressName), speedKmh)
        else
            logWarning("REAPPLY_REFUSED run=%s progress=%s reason=%s", tostring(sample.runNumber), tostring(sample.progressName), tostring(reason))
        end
    end
    self:_heartbeat(capabilityGate, signal, nowMs)
end

function Bridge:getStatus()
    return {
        active=self.active~=nil,
        lastSignal=self.lastSignal,
        lastSignalReason=self.lastSignalReason,
        applyCount=self.applyCount,
        releaseCount=self.releaseCount,
        ownerTag=OWNER_TAG,
        combinationKey=COMBINATION_KEY
    }
end
