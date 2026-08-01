-- FS25_OuttaMyWay v4.6.43 cooperative passage evidence consolidation candidate.
-- Prototype 18: fixture-bounded Automatic Encounter Admission.
-- TS016 retains the manoeuvre-aware path validated in v4.6.40. This increment
-- replaces the permanent entity-pair latch with an encounter-scoped lifecycle:
-- COMMITTED -> REARMING -> REARMED. A successful encounter may rearm only after
-- the completed conflict is no longer predicted, the pair is at least the
-- established passage-clear distance apart, and that clear state persists.
-- Failed or unresolved encounters remain latched until explicit recovery.
--
-- No fixed vehicle identity, side, 28 m or 12 m fallback remains.

OuttaMyWay.AutomaticEncounterAdmission = OuttaMyWay.AutomaticEncounterAdmission or {}
local Admission = OuttaMyWay.AutomaticEncounterAdmission

local function nameOf(state)
    return state ~= nil and tostring(state.name or "AI vehicle") or "AI vehicle"
end

local function pairKey(a, b)
    local av = tostring(a ~= nil and a.vehicle or "nil")
    local bv = tostring(b ~= nil and b.vehicle or "nil")
    if av > bv then av, bv = bv, av end
    return av .. "|" .. bv
end

local function headingDifference(a, b)
    local diff = math.abs((tonumber(a) or 0) - (tonumber(b) or 0)) % 360
    if diff > 180 then diff = 360 - diff end
    return diff
end

local function nowSeconds()
    if OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.startedAt ~= nil then
        return ((g_time or 0) - OuttaMyWay.Observer.startedAt) / 1000
    end
    return (g_time or 0) / 1000
end

local function kinematicsFor(yieldState, progressState)
    local source = OuttaMyWay.ConflictEmergenceProbe
    if source == nil or type(source.closestApproach) ~= "function" then return nil end
    local ok, result = pcall(source.closestApproach, yieldState, progressState)
    return ok and result or nil
end

function Admission:init()
    self.enabled = OuttaMyWay.TS018_AUTOMATIC_ADMISSION_ENABLED == true
    self.candidateKey = nil
    self.candidatePairKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.candidateMode = nil
    self.candidateYieldVehicle = nil
    self.candidateCommitWithheld = false
    self.encounterRecords = {}
    self.encounterCounts = {}
    self.absentSince = {}
    self.lastEncounterId = nil
    self.lastState = "IDLE"
    self.lastReason = "none"
    self.lastMetrics = nil

    OuttaMyWay.Logger:info(
        "PROTOTYPE 18 ACTIVE: automatic encounter admission enabled=%s fixturePair=Condor/Patriot straightConfirmation=%.1fs ts016ManoeuvreAware=%s ts016Confirmation=%.1fs role=calculated side=calculated distance=calculated encounterScopedLatch=true rearmDistance=%.1fm rearmClear=%.1fs failedLatch=true noFallback=true",
        tostring(self.enabled), (OuttaMyWay.TS018_ADMISSION_CONFIRM_MS or 3000) / 1000,
        tostring(OuttaMyWay.TS016_MANOEUVRE_ADMISSION_ENABLED == true),
        (OuttaMyWay.TS016_ADMISSION_CONFIRM_MS or 0) / 1000,
        OuttaMyWay.TS018_REARM_MIN_SEPARATION_M or (OuttaMyWay.TS015_PASS_CLEAR_DISTANCE_M or 35.0),
        (OuttaMyWay.TS018_REARM_CLEAR_CONFIRM_MS or 3000) / 1000)
end

function Admission:resetCandidate(reason, nowMs)
    if self.candidateKey ~= nil then
        OuttaMyWay.Logger:val(
            "PROTOTYPE18 ADMISSION_WITHDRAWN t=%.1fs pairKey=%s candidateFor=%.2fs reason=%s action=none",
            nowSeconds(), tostring(self.candidatePairKey or self.candidateKey),
            ((nowMs or 0) - (self.candidateSince or (nowMs or 0))) / 1000,
            tostring(reason or "evidence-lost"))
    end
    self.candidateKey = nil
    self.candidatePairKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.candidateMode = nil
    self.candidateYieldVehicle = nil
    self.candidateCommitWithheld = false
end

function Admission:updateEpisodePresence(activePairKey, nowMs)
    local resetMs = OuttaMyWay.TS018_EPISODE_RESET_MS or 5000
    for key, record in pairs(self.encounterRecords or {}) do
        if key == activePairKey then
            self.absentSince[key] = nil
        elseif record.state == "REARMING" then
            self.absentSince[key] = self.absentSince[key] or nowMs
            if nowMs - self.absentSince[key] >= resetMs then
                self.encounterRecords[key] = nil
                self.absentSince[key] = nil
                self.lastEncounterId = record.encounterId
                self.lastState, self.lastReason = "REARMED", "completed-pair-absent"
                OuttaMyWay.Logger:val(
                    "PROTOTYPE18 ENCOUNTER_REARMED t=%.1fs pairKey=%s encounter=%s absentFor=%.2fs reason=completed-pair-no-longer-active",
                    nowSeconds(), tostring(key), tostring(record.encounterId), resetMs / 1000)
            end
        else
            -- COMMITTED and FAILED records are deliberately not reset by absence.
            -- They require a controller outcome or explicit recovery respectively.
            self.absentSince[key] = nil
        end
    end
end

function Admission:markRunOutcome(key, encounterId, outcome, nowMs, reason)
    nowMs = nowMs or (g_time or 0)
    local record = key ~= nil and self.encounterRecords ~= nil and self.encounterRecords[key] or nil
    if record == nil or (encounterId ~= nil and record.encounterId ~= encounterId) then
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE18 ENCOUNTER_OUTCOME_IGNORED t=%.1fs pairKey=%s encounter=%s outcome=%s reason=record-mismatch",
            nowSeconds(), tostring(key), tostring(encounterId), tostring(outcome))
        return false
    end

    record.completedAt = nowMs
    record.outcomeReason = reason
    self.lastEncounterId = record.encounterId
    if outcome == "SUCCESS" then
        record.state = "REARMING"
        record.clearSince = nil
        record.rearmCandidateLogged = false
        self.lastState, self.lastReason = "REARMING", "successful-encounter-awaiting-clear-separation"
    else
        record.state = "FAILED"
        record.clearSince = nil
        self.lastState, self.lastReason = "LATCHED", "failed-encounter-requires-explicit-recovery"
    end
    OuttaMyWay.Logger:val(
        "PROTOTYPE18 ENCOUNTER_OUTCOME t=%.1fs pairKey=%s encounter=%s outcome=%s nextState=%s reason=%s",
        nowSeconds(), tostring(key), tostring(record.encounterId), tostring(outcome),
        tostring(record.state), tostring(reason or "none"))
    return true
end

local function straightWorking(state, minimumSpeed)
    return state ~= nil
        and state.phase == "WORKING"
        and state.isTurn ~= true
        and state.blocked ~= true
        and (tonumber(state.actualSpeed) or 0) >= minimumSpeed
end

local function manoeuvring(state)
    return state ~= nil
        and (state.phase == "MANOEUVRING" or state.isTurn == true)
        and state.blocked ~= true
        and (tonumber(state.actualSpeed) or 0) >= (OuttaMyWay.TS016_MIN_MANOEUVRE_SPEED_KMH or 1.0)
end

local function candidateIdentity(pair, mode, yieldState)
    return table.concat({tostring(pair), tostring(mode), tostring(yieldState ~= nil and yieldState.vehicle or "nil")}, "|")
end

local function encounterConflictActive(result, headingDelta)
    if result == nil then return true end
    local opposed = headingDelta ~= nil
        and headingDelta >= (OuttaMyWay.TS015_HEAD_ON_MIN_DEG or 150.0)
    local closing = (tonumber(result.closing) or 0) > (OuttaMyWay.TS018_MIN_CLOSING_RATE_MPS or 0.10)
    local tcpa = tonumber(result.tcpa)
    local dcpa = tonumber(result.dcpa)
    return opposed and closing and tcpa ~= nil and tcpa >= 0
        and tcpa <= (OuttaMyWay.TS018_MAX_TCPA_S or 30.0)
        and dcpa ~= nil and dcpa <= (OuttaMyWay.TS018_MAX_DCPA_M or 14.0)
end

function Admission:updateRearming(key, record, result, headingDelta, nowMs)
    local minimumSeparation = OuttaMyWay.TS018_REARM_MIN_SEPARATION_M
        or (OuttaMyWay.TS015_PASS_CLEAR_DISTANCE_M or 35.0)
    local clearConfirmMs = OuttaMyWay.TS018_REARM_CLEAR_CONFIRM_MS or 3000
    local separation = result ~= nil and tonumber(result.distance) or nil
    local conflictActive = encounterConflictActive(result, headingDelta)
    local clearNow = separation ~= nil and separation >= minimumSeparation and not conflictActive

    if clearNow then
        if record.clearSince == nil then
            record.clearSince = nowMs
            if record.rearmCandidateLogged ~= true then
                record.rearmCandidateLogged = true
                OuttaMyWay.Logger:val(
                    "PROTOTYPE18 REARM_CANDIDATE t=%.1fs pairKey=%s encounter=%s separation=%.2fm conflictActive=false confirmationRequired=%.2fs",
                    nowSeconds(), tostring(key), tostring(record.encounterId), separation, clearConfirmMs / 1000)
            end
        end
        local clearFor = nowMs - record.clearSince
        if clearFor >= clearConfirmMs then
            self.encounterRecords[key] = nil
            self.absentSince[key] = nil
            self.lastEncounterId = record.encounterId
            self.lastState, self.lastReason = "REARMED", "successful-encounter-cleared"
            OuttaMyWay.Logger:val(
                "PROTOTYPE18 ENCOUNTER_REARMED t=%.1fs pairKey=%s encounter=%s separation=%.2fm clearFor=%.2fs reason=completed-conflict-no-longer-active",
                nowSeconds(), tostring(key), tostring(record.encounterId), separation, clearFor / 1000)
            return true
        end
    else
        if record.clearSince ~= nil then
            OuttaMyWay.Logger:val(
                "PROTOTYPE18 REARM_WITHDRAWN t=%.1fs pairKey=%s encounter=%s separation=%s conflictActive=%s reason=clear-evidence-lost",
                nowSeconds(), tostring(key), tostring(record.encounterId),
                separation ~= nil and string.format("%.2fm", separation) or "n/a", tostring(conflictActive))
        end
        record.clearSince = nil
        record.rearmCandidateLogged = false
    end

    self.lastEncounterId = record.encounterId
    self.lastState, self.lastReason = "REARMING", clearNow
        and "clear-confirmation-pending" or "awaiting-clear-separation"
    return false
end

function Admission:evaluate(participantA, participantB, activeWorkerCount, nowMs)
    if self.enabled == nil then self:init() end
    nowMs = nowMs or (g_time or 0)

    if self.enabled ~= true then
        self.lastState, self.lastReason = "DISABLED", "configuration-disabled"
        return {admitted=false, state=self.lastState, reason=self.lastReason}
    end

    local key = participantA ~= nil and participantB ~= nil and pairKey(participantA, participantB) or nil
    self:updateEpisodePresence(key, nowMs)

    if activeWorkerCount ~= 2 or participantA == nil or participantB == nil then
        self:resetCandidate("fixture-pair-not-exclusive", nowMs)
        self.lastState, self.lastReason = "IDLE", "fixture-pair-not-exclusive"
        self.lastMetrics = nil
        return {admitted=false, state=self.lastState, reason=self.lastReason}
    end

    local result = kinematicsFor(participantA, participantB)
    local headingDelta = headingDifference(participantA.heading, participantB.heading)
    local minimumWorkingSpeed = OuttaMyWay.TS015_MIN_WORKING_SPEED_KMH or 2.0
    local minimumProgressSpeed = OuttaMyWay.TS015_MIN_PROGRESS_SPEED_KMH or 2.0
    local straightA = straightWorking(participantA, minimumWorkingSpeed)
    local straightB = straightWorking(participantB, minimumProgressSpeed)
    local turningA = manoeuvring(participantA)
    local turningB = manoeuvring(participantB)
    local opposed = headingDelta ~= nil
        and headingDelta >= (OuttaMyWay.TS015_HEAD_ON_MIN_DEG or 150.0)
    local closing = result ~= nil and (tonumber(result.closing) or 0) > (OuttaMyWay.TS018_MIN_CLOSING_RATE_MPS or 0.10)
    local tcpaRelevant = result ~= nil and result.tcpa ~= nil
        and result.tcpa >= 0
        and result.tcpa <= (OuttaMyWay.TS018_MAX_TCPA_S or 30.0)
    local dcpaRelevant = result ~= nil and result.dcpa ~= nil
        and result.dcpa <= (OuttaMyWay.TS018_MAX_DCPA_M or 14.0)

    local record = self.encounterRecords ~= nil and self.encounterRecords[key] or nil
    if record ~= nil then
        self:resetCandidate("encounter-latched", nowMs)
        if record.state == "REARMING" then
            local rearmMetrics = {
                pairKey=key, admissionMode="REARMING", headingDelta=headingDelta,
                distance=result ~= nil and result.distance or nil,
                closing=result ~= nil and result.closing or nil,
                tcpa=result ~= nil and result.tcpa or nil,
                dcpa=result ~= nil and result.dcpa or nil
            }
            self.lastMetrics = rearmMetrics
            local rearmed = self:updateRearming(key, record, result, headingDelta, nowMs)
            return {
                admitted=false,
                state=self.lastState,
                reason=self.lastReason,
                pairKey=key,
                encounterId=record.encounterId,
                rearmed=rearmed,
                metrics=rearmMetrics
            }
        end
        self.lastEncounterId = record.encounterId
        self.lastState = "LATCHED"
        self.lastReason = record.state == "FAILED"
            and "failed-encounter-requires-explicit-recovery"
            or "encounter-commitment-active"
        return {admitted=false, state=self.lastState, reason=self.lastReason,
            pairKey=key, encounterId=record.encounterId}
    end

    local mode, proposedYield, proposedProgress
    local straightEligible = straightA and straightB and opposed and closing and tcpaRelevant and dcpaRelevant
    if straightEligible then
        mode = "STRAIGHT_HEAD_ON"
    elseif OuttaMyWay.TS016_MANOEUVRE_ADMISSION_ENABLED == true
        and opposed and closing
        and result ~= nil and result.tcpa ~= nil and result.tcpa >= 0
        and result.tcpa <= (OuttaMyWay.TS016_MAX_TCPA_S or 12.0)
        and result.dcpa ~= nil and result.dcpa <= (OuttaMyWay.TS016_MAX_DCPA_M or 14.0)
        and ((straightA and turningB) or (straightB and turningA)) then
        mode = "TS016_TURN_EXIT_HEAD_ON"
        proposedYield = straightA and participantA or participantB
        proposedProgress = straightA and participantB or participantA
    end
    local eligible = mode ~= nil

    self.lastMetrics = {
        pairKey = key,
        admissionMode = mode,
        headingDelta = headingDelta,
        distance = result ~= nil and result.distance or nil,
        closing = result ~= nil and result.closing or nil,
        tcpa = result ~= nil and result.tcpa or nil,
        dcpa = result ~= nil and result.dcpa or nil,
        straightA = straightA,
        straightB = straightB,
        turningA = turningA,
        turningB = turningB,
        opposed = opposed,
        closingRelevant = closing,
        tcpaRelevant = tcpaRelevant,
        dcpaRelevant = dcpaRelevant,
        proposedYield = proposedYield,
        proposedProgress = proposedProgress
    }

    if not eligible then
        local reason = result == nil and "kinematics-unavailable"
            or not opposed and "not-head-on"
            or not closing and "not-closing"
            or result.tcpa == nil and "tcpa-unavailable"
            or not tcpaRelevant and "tcpa-outside-admission-window"
            or not dcpaRelevant and "dcpa-outside-conflict-clearance"
            or "no-supported-straight-or-ts016-state-combination"
        self:resetCandidate(reason, nowMs)
        self.lastState, self.lastReason = "OBSERVING", reason
        return {admitted=false, state=self.lastState, reason=reason, pairKey=key, metrics=self.lastMetrics}
    end

    local roleYield = mode == "TS016_TURN_EXIT_HEAD_ON" and proposedYield or nil
    local identity = candidateIdentity(key, mode, roleYield)
    local confirmationMs = mode == "TS016_TURN_EXIT_HEAD_ON"
        and (OuttaMyWay.TS016_ADMISSION_CONFIRM_MS or 0)
        or (OuttaMyWay.TS018_ADMISSION_CONFIRM_MS or 3000)
    if self.candidateKey ~= identity then
        self:resetCandidate("candidate-mode-or-role-changed", nowMs)
        self.candidateKey = identity
        self.candidatePairKey = key
        self.candidateSince = nowMs
        self.candidateLastReason = mode == "TS016_TURN_EXIT_HEAD_ON"
            and "ts016-live-trajectory-conflict-relevant" or "head-on-conflict-relevant"
        self.candidateMode = mode
        self.candidateYieldVehicle = roleYield ~= nil and roleYield.vehicle or nil
        self.candidateCommitWithheld = false
        OuttaMyWay.Logger:val(
            "PROTOTYPE18 ADMISSION_CANDIDATE t=%.1fs mode=%s participantA=%s participantB=%s pairKey=%s activeWorkers=%d headingDelta=%.1fdeg distance=%.2fm closing=%.3fm/s tCPA=%.2fs dCPA=%.2fm confirmationRequired=%.2fs proposedYield=%s proposedProgress=%s laneCrossingAlone=false role=%s side=pending-calculation distance=pending-calculation authority=fixture-admission-only",
            nowSeconds(), tostring(mode), nameOf(participantA), nameOf(participantB), key, activeWorkerCount,
            headingDelta or -1, result.distance or -1, result.closing or -1,
            result.tcpa or -1, result.dcpa or -1, confirmationMs / 1000,
            proposedYield ~= nil and nameOf(proposedYield) or "pending-calculation",
            proposedProgress ~= nil and nameOf(proposedProgress) or "pending-calculation",
            mode == "TS016_TURN_EXIT_HEAD_ON" and "straight-working-worker" or "pending-calculation")
    end

    local candidateFor = nowMs - (self.candidateSince or nowMs)
    if candidateFor < confirmationMs then
        self.lastState, self.lastReason = "CANDIDATE", "confirmation-pending"
        return {
            admitted=false, state=self.lastState, reason=self.lastReason, pairKey=key,
            candidateForMs=candidateFor, metrics=self.lastMetrics
        }
    end

    local minimumCommitTcpa = mode == "TS016_TURN_EXIT_HEAD_ON"
        and (OuttaMyWay.TS016_MIN_COMMIT_TCPA_S or 6.0)
        or (OuttaMyWay.TS018_MIN_COMMIT_TCPA_S or 6.0)
    if result.tcpa == nil or result.tcpa < minimumCommitTcpa then
        self.lastState, self.lastReason = "TOO_LATE", "insufficient-intervention-time"
        if self.candidateCommitWithheld ~= true then
            self.candidateCommitWithheld = true
            OuttaMyWay.Logger:warning("VAL",
                "PROTOTYPE18 COMMITMENT_WITHHELD t=%.1fs mode=%s pairKey=%s reason=%s tCPA=%s minimumRequired=%.2fs noFallback=true",
                nowSeconds(), tostring(mode), tostring(key), tostring(self.lastReason),
                result.tcpa ~= nil and string.format("%.2fs", result.tcpa) or "n/a", minimumCommitTcpa)
        end
        return {admitted=false, state=self.lastState, reason=self.lastReason, pairKey=key,
            admissionMode=mode, metrics=self.lastMetrics}
    end
    self.candidateCommitWithheld = false

    local comparison = OuttaMyWay.ShadowRefugeCandidateComparison
    if comparison == nil or type(comparison.selectForEncounter) ~= "function" then
        self.candidateSince = nowMs
        self.lastState, self.lastReason = "UNRESOLVED", "calculated-refuge-module-unavailable"
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE18 COMMITMENT_WITHHELD t=%.1fs pairKey=%s reason=%s noFallback=true",
            nowSeconds(), tostring(key), tostring(self.lastReason))
        return {admitted=false, state=self.lastState, reason=self.lastReason, pairKey=key}
    end

    local ok, selection, epoch
    if mode == "TS016_TURN_EXIT_HEAD_ON" then
        if type(comparison.selectForRole) ~= "function" then
            ok, selection, epoch = true, nil, nil
        else
            ok, selection, epoch = pcall(comparison.selectForRole, comparison,
                proposedYield, proposedProgress, nowMs, key, self.lastMetrics,
                "ts016-straight-worker-role-selection")
        end
    else
        ok, selection, epoch = pcall(comparison.selectForEncounter, comparison,
            participantA, participantB, nowMs, key, self.lastMetrics)
    end
    if not ok or selection == nil then
        self.candidateSince = nowMs
        self.lastState, self.lastReason = "UNRESOLVED", ok
            and "no-calculated-refuge-selection" or "calculated-refuge-error"
        OuttaMyWay.Logger:warning("VAL",
            "PROTOTYPE18 COMMITMENT_WITHHELD t=%.1fs pairKey=%s reason=%s detail=%s noFallback=true",
            nowSeconds(), tostring(key), tostring(self.lastReason),
            ok and "selection-none" or tostring(selection))
        return {admitted=false, state=self.lastState, reason=self.lastReason, pairKey=key, epoch=epoch}
    end

    local encounterId = (self.encounterCounts[key] or 0) + 1
    self.encounterCounts[key] = encounterId
    self.encounterRecords[key] = {
        state="COMMITTED",
        encounterId=encounterId,
        committedAt=nowMs,
        admissionMode=mode
    }
    self.absentSince[key] = nil
    self.lastEncounterId = encounterId
    selection.encounterId = encounterId
    self.candidateKey = nil
    self.candidatePairKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.candidateMode = nil
    self.candidateYieldVehicle = nil
    self.candidateCommitWithheld = false
    self.lastState, self.lastReason = "COMMITTED", mode == "TS016_TURN_EXIT_HEAD_ON"
        and "ts016-manoeuvre-aware-calculated-refuge"
        or "automatic-encounter-admission-calculated-refuge"

    OuttaMyWay.Logger:val(
        "PROTOTYPE18 COMMITMENT_POINT t=%.1fs encounter=%d mode=%s participantA=%s participantB=%s pairKey=%s candidateFor=%.2fs headingDelta=%.1fdeg distance=%.2fm closing=%.3fm/s tCPA=%.2fs dCPA=%.2fm selectedYield=%s selectedProgress=%s provisionalSide=%s provisionalLateral=%.2fm provisionalRearward=%.2fm selectionEpoch=%s laneCrossingAlone=false fixedRole=false fixedSide=false fixed28=false fixed12=false authority=calculated-refuge",
        nowSeconds(), encounterId, tostring(mode), nameOf(participantA), nameOf(participantB), key, candidateFor / 1000,
        headingDelta or -1, result.distance or -1, result.closing or -1,
        result.tcpa or -1, result.dcpa or -1, tostring(selection.yieldName),
        tostring(selection.progressName), tostring(selection.sideDiagnostic),
        tonumber(selection.lateralTravel) or -1, tonumber(selection.rearwardTravel) or -1,
        epoch ~= nil and tostring(epoch.id) or "n/a")
    return {
        admitted=true, state=self.lastState, reason=self.lastReason, pairKey=key,
        encounterId=encounterId, selection=selection, epoch=epoch,
        metrics=self.lastMetrics, admissionMode=mode
    }
end

function Admission:statusText()
    if self.enabled == nil then self:init() end
    local metrics = self.lastMetrics
    return string.format(
        "state=%s reason=%s encounter=%s mode=%s candidateFor=%s headingDelta=%s tCPA=%s dCPA=%s",
        tostring(self.lastState or "IDLE"), tostring(self.lastReason or "none"),
        tostring(self.lastEncounterId or "none"),
        tostring(self.candidateMode or (metrics ~= nil and metrics.admissionMode) or "none"),
        self.candidateSince ~= nil and string.format("%.1fs", ((g_time or 0) - self.candidateSince) / 1000) or "n/a",
        metrics ~= nil and metrics.headingDelta ~= nil and string.format("%.1fdeg", metrics.headingDelta) or "n/a",
        metrics ~= nil and metrics.tcpa ~= nil and string.format("%.1fs", metrics.tcpa) or "n/a",
        metrics ~= nil and metrics.dcpa ~= nil and string.format("%.1fm", metrics.dcpa) or "n/a")
end

function Admission:clear()
    self.enabled = nil
    self.candidateKey = nil
    self.candidatePairKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.candidateMode = nil
    self.candidateYieldVehicle = nil
    self.candidateCommitWithheld = false
    self.encounterRecords = {}
    self.encounterCounts = {}
    self.absentSince = {}
    self.lastEncounterId = nil
    self.lastState = "IDLE"
    self.lastReason = "none"
    self.lastMetrics = nil
    local comparison = OuttaMyWay.ShadowRefugeCandidateComparison
    if comparison ~= nil and type(comparison.clear) == "function" then comparison:clear() end
end
