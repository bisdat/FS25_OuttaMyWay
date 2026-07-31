-- FS25_OuttaMyWay v4.6.33
-- Prototype 18: fixture-bounded Automatic Encounter Admission.
--
-- This Decision-side module consumes Observer and Prototype 01 Situation
-- Assessment evidence. It does not select roles, side or movement. For the
-- exact Condor/Patriot fixture those remain fixed by the validated test
-- contract. Admission grants one commitment opportunity per continuous worker
-- episode and never derives authority from Shadow Clearance Knowledge.

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
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.committedPairs = {}
    self.absentSince = {}
    self.lastState = "IDLE"
    self.lastReason = "none"
    self.lastMetrics = nil

    OuttaMyWay.Logger:info(
        "PROTOTYPE 18 ACTIVE: automatic encounter admission enabled=%s fixture=Condor-yields/Patriot-progresses side=fixed-right confirmation=%.1fs oneCommitmentPerEpisode=true shadowClearanceAuthority=false",
        tostring(self.enabled), (OuttaMyWay.TS018_ADMISSION_CONFIRM_MS or 3000) / 1000)
end

function Admission:resetCandidate(reason, nowMs)
    if self.candidateKey ~= nil then
        OuttaMyWay.Logger:val(
            "PROTOTYPE18 ADMISSION_WITHDRAWN t=%.1fs pairKey=%s candidateFor=%.2fs reason=%s action=none",
            nowSeconds(), tostring(self.candidateKey),
            ((nowMs or 0) - (self.candidateSince or (nowMs or 0))) / 1000,
            tostring(reason or "evidence-lost"))
    end
    self.candidateKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
end

function Admission:updateEpisodePresence(activePairKey, nowMs)
    local resetMs = OuttaMyWay.TS018_EPISODE_RESET_MS or 5000
    for key in pairs(self.committedPairs or {}) do
        if key == activePairKey then
            self.absentSince[key] = nil
        else
            self.absentSince[key] = self.absentSince[key] or nowMs
            if nowMs - self.absentSince[key] >= resetMs then
                self.committedPairs[key] = nil
                self.absentSince[key] = nil
                OuttaMyWay.Logger:val(
                    "PROTOTYPE18 EPISODE_RESET t=%.1fs pairKey=%s absentFor=%.2fs reason=fixture-pair-no-longer-continuously-active",
                    nowSeconds(), tostring(key), resetMs / 1000)
            end
        end
    end
end

function Admission:evaluate(yieldState, progressState, activeWorkerCount, nowMs)
    if self.enabled == nil then self:init() end
    nowMs = nowMs or (g_time or 0)

    if self.enabled ~= true then
        self.lastState, self.lastReason = "DISABLED", "configuration-disabled"
        return {admitted=false, state=self.lastState, reason=self.lastReason}
    end

    local key = yieldState ~= nil and progressState ~= nil and pairKey(yieldState, progressState) or nil
    self:updateEpisodePresence(key, nowMs)

    if activeWorkerCount ~= 2 or yieldState == nil or progressState == nil then
        self:resetCandidate("fixture-pair-not-exclusive", nowMs)
        self.lastState, self.lastReason = "IDLE", "fixture-pair-not-exclusive"
        self.lastMetrics = nil
        return {admitted=false, state=self.lastState, reason=self.lastReason}
    end

    if self.committedPairs[key] == true then
        self:resetCandidate("episode-latched", nowMs)
        self.lastState, self.lastReason = "LATCHED", "one-commitment-per-episode"
        return {admitted=false, state=self.lastState, reason=self.lastReason, pairKey=key}
    end

    local result = kinematicsFor(yieldState, progressState)
    local headingDelta = headingDifference(yieldState.heading, progressState.heading)
    local eligibleYield = yieldState.phase == "WORKING"
        and yieldState.isTurn ~= true
        and yieldState.blocked ~= true
        and (tonumber(yieldState.actualSpeed) or 0) >= (OuttaMyWay.TS015_MIN_WORKING_SPEED_KMH or 2.0)
    local eligibleProgress = progressState.phase == "WORKING"
        and progressState.isTurn ~= true
        and progressState.blocked ~= true
        and (tonumber(progressState.actualSpeed) or 0) >= (OuttaMyWay.TS015_MIN_PROGRESS_SPEED_KMH or 2.0)
    local opposed = headingDelta ~= nil
        and headingDelta >= (OuttaMyWay.TS015_HEAD_ON_MIN_DEG or 150.0)
    local closing = result ~= nil and (tonumber(result.closing) or 0) > (OuttaMyWay.TS018_MIN_CLOSING_RATE_MPS or 0.10)
    local tcpaRelevant = result ~= nil and result.tcpa ~= nil
        and result.tcpa >= 0
        and result.tcpa <= (OuttaMyWay.TS018_MAX_TCPA_S or 30.0)
    local dcpaRelevant = result ~= nil and result.dcpa ~= nil
        and result.dcpa <= (OuttaMyWay.TS018_MAX_DCPA_M or 14.0)
    local eligible = eligibleYield and eligibleProgress and opposed and closing and tcpaRelevant and dcpaRelevant

    self.lastMetrics = {
        pairKey = key,
        headingDelta = headingDelta,
        distance = result ~= nil and result.distance or nil,
        closing = result ~= nil and result.closing or nil,
        tcpa = result ~= nil and result.tcpa or nil,
        dcpa = result ~= nil and result.dcpa or nil,
        eligibleYield = eligibleYield,
        eligibleProgress = eligibleProgress,
        opposed = opposed,
        closingRelevant = closing,
        tcpaRelevant = tcpaRelevant,
        dcpaRelevant = dcpaRelevant
    }

    if not eligible then
        local reason = not eligibleYield and "yield-not-straight-working"
            or not eligibleProgress and "progress-not-straight-working"
            or not opposed and "not-head-on"
            or not closing and "not-closing"
            or not tcpaRelevant and "tcpa-outside-admission-window"
            or not dcpaRelevant and "dcpa-outside-conflict-clearance"
            or "evidence-incomplete"
        self:resetCandidate(reason, nowMs)
        self.lastState, self.lastReason = "OBSERVING", reason
        return {admitted=false, state=self.lastState, reason=reason, pairKey=key, metrics=self.lastMetrics}
    end

    if self.candidateKey ~= key then
        self:resetCandidate("candidate-pair-changed", nowMs)
        self.candidateKey = key
        self.candidateSince = nowMs
        self.candidateLastReason = "head-on-conflict-relevant"
        OuttaMyWay.Logger:val(
            "PROTOTYPE18 ADMISSION_CANDIDATE t=%.1fs yield=%s progress=%s pairKey=%s activeWorkers=%d headingDelta=%.1fdeg distance=%.2fm closing=%.3fm/s tCPA=%.2fs dCPA=%.2fm confirmationRequired=%.2fs fixedRole=true fixedSide=right authority=fixture-bounded",
            nowSeconds(), nameOf(yieldState), nameOf(progressState), key, activeWorkerCount,
            headingDelta or -1, result.distance or -1, result.closing or -1,
            result.tcpa or -1, result.dcpa or -1,
            (OuttaMyWay.TS018_ADMISSION_CONFIRM_MS or 3000) / 1000)
    end

    local candidateFor = nowMs - (self.candidateSince or nowMs)
    local confirmationMs = OuttaMyWay.TS018_ADMISSION_CONFIRM_MS or 3000
    if candidateFor < confirmationMs then
        self.lastState, self.lastReason = "CANDIDATE", "confirmation-pending"
        return {
            admitted=false, state=self.lastState, reason=self.lastReason, pairKey=key,
            candidateForMs=candidateFor, metrics=self.lastMetrics
        }
    end

    self.committedPairs[key] = true
    self.absentSince[key] = nil
    self.candidateKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.lastState, self.lastReason = "COMMITTED", "automatic-encounter-admission"
    OuttaMyWay.Logger:val(
        "PROTOTYPE18 COMMITMENT_POINT t=%.1fs yield=%s progress=%s pairKey=%s candidateFor=%.2fs headingDelta=%.1fdeg distance=%.2fm closing=%.3fm/s tCPA=%.2fs dCPA=%.2fm selectedRole=CONDOR_YIELD selectedProgress=PATRIOT_GIANTS_UNMODIFIED selectedSide=right selectedMovement=28m-lateral-12m-rearward shadowClearanceAuthority=false",
        nowSeconds(), nameOf(yieldState), nameOf(progressState), key, candidateFor / 1000,
        headingDelta or -1, result.distance or -1, result.closing or -1,
        result.tcpa or -1, result.dcpa or -1)
    return {
        admitted=true, state=self.lastState, reason=self.lastReason, pairKey=key,
        side="right", metrics=self.lastMetrics
    }
end

function Admission:statusText()
    if self.enabled == nil then self:init() end
    local metrics = self.lastMetrics
    return string.format(
        "state=%s reason=%s candidateFor=%s headingDelta=%s tCPA=%s dCPA=%s",
        tostring(self.lastState or "IDLE"), tostring(self.lastReason or "none"),
        self.candidateSince ~= nil and string.format("%.1fs", ((g_time or 0) - self.candidateSince) / 1000) or "n/a",
        metrics ~= nil and metrics.headingDelta ~= nil and string.format("%.1fdeg", metrics.headingDelta) or "n/a",
        metrics ~= nil and metrics.tcpa ~= nil and string.format("%.1fs", metrics.tcpa) or "n/a",
        metrics ~= nil and metrics.dcpa ~= nil and string.format("%.1fm", metrics.dcpa) or "n/a")
end

function Admission:clear()
    self.enabled = nil
    self.candidateKey = nil
    self.candidateSince = nil
    self.candidateLastReason = nil
    self.committedPairs = {}
    self.absentSince = {}
    self.lastState = "IDLE"
    self.lastReason = "none"
    self.lastMetrics = nil
end
