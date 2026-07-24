-- FS25_OuttaMyWay v4.6.3
-- Prototype 02: passive evidence capture for Trajectory Settlement and Conflict Confidence.
-- This module reads Observer state and Prototype 01 kinematics only. It never controls vehicles.

OuttaMyWay.ConflictConfidenceProbe = OuttaMyWay.ConflictConfidenceProbe or {}
local Probe = OuttaMyWay.ConflictConfidenceProbe

local function countTable(values)
    local count = 0
    if type(values) == "table" then
        for _ in pairs(values) do count = count + 1 end
    end
    return count
end

local function normalizeAngle(value)
    return (value + 180) % 360 - 180
end

local function absAngleDelta(a, b)
    return math.abs(normalizeAngle((a or 0) - (b or 0)))
end

local function bool(value)
    return value == true
end

local function formatNumber(value, format, suffix)
    if value == nil then return "unknown" end
    return string.format(format or "%.2f", value) .. (suffix or "")
end

local function appendSample(samples, sample, nowSeconds, windowSeconds)
    samples[#samples + 1] = sample
    local cutoff = nowSeconds - windowSeconds
    while #samples > 0 and (samples[1].timestamp or nowSeconds) < cutoff do
        table.remove(samples, 1)
    end
end

local function windowMetrics(samples)
    if type(samples) ~= "table" or #samples == 0 then
        return {duration=0, dcpaSpread=nil, zoneDrift=nil, countdownError=nil, positiveSamples=0}
    end

    local first = samples[1]
    local last = samples[#samples]
    local minDcpa, maxDcpa = nil, nil
    local countdownTotal, countdownCount = 0, 0
    local positiveSamples = 0

    for index, sample in ipairs(samples) do
        if sample.positive == true then positiveSamples = positiveSamples + 1 end
        if sample.dcpa ~= nil then
            minDcpa = minDcpa == nil and sample.dcpa or math.min(minDcpa, sample.dcpa)
            maxDcpa = maxDcpa == nil and sample.dcpa or math.max(maxDcpa, sample.dcpa)
        end
        if index > 1 then
            local previous = samples[index - 1]
            if previous.tcpa ~= nil and sample.tcpa ~= nil then
                local elapsed = (sample.timestamp or 0) - (previous.timestamp or 0)
                if elapsed > 0 then
                    countdownTotal = countdownTotal + math.abs(((previous.tcpa - sample.tcpa) - elapsed))
                    countdownCount = countdownCount + 1
                end
            end
        end
    end

    local duration = math.max(0, (last.timestamp or 0) - (first.timestamp or 0))
    local zoneDrift = nil
    if duration > 0 and first.zoneX ~= nil and first.zoneZ ~= nil and last.zoneX ~= nil and last.zoneZ ~= nil then
        local dx = last.zoneX - first.zoneX
        local dz = last.zoneZ - first.zoneZ
        zoneDrift = math.sqrt(dx * dx + dz * dz) / duration
    end

    return {
        duration = duration,
        dcpaSpread = minDcpa ~= nil and maxDcpa ~= nil and (maxDcpa - minDcpa) or nil,
        zoneDrift = zoneDrift,
        countdownError = countdownCount > 0 and (countdownTotal / countdownCount) or nil,
        positiveSamples = positiveSamples
    }
end

function Probe:init()
    self.elapsedMs = 0
    self.entityHistory = {}
    self.pairs = {}
    self.lastHeartbeatMs = 0
    self.enabled = OuttaMyWay.PROTOTYPE_02_ENABLED == true

    local observerOnly = OuttaMyWay.AI_EXPLORER_ONLY == true
    local trafficDisabled = OuttaMyWay.TRAFFIC_V2_ENABLED ~= true
    local prototype01 = OuttaMyWay.ConflictEmergenceProbe
    local kinematicsAvailable = prototype01 ~= nil
        and type(prototype01.closestApproach) == "function"
        and type(prototype01.pairKey) == "function"
        and type(prototype01.pairNames) == "function"
        and type(prototype01.shouldTrack) == "function"
    local passive = observerOnly and trafficDisabled

    OuttaMyWay.Logger:info(
        "PROTOTYPE 02 ACTIVE: Conflict Confidence evidence capture enabled=%s passive=%s kinematicsAvailable=%s no vehicle control",
        tostring(self.enabled), tostring(passive), tostring(kinematicsAvailable))

    if self.enabled and not passive then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 02 PASSIVE GUARANTEE FAILED: AI_EXPLORER_ONLY must be true and TRAFFIC_V2_ENABLED must be false")
        self.enabled = false
    elseif self.enabled and not kinematicsAvailable then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 02 DEPENDENCY FAILED: Prototype 01 kinematics helpers are unavailable")
        self.enabled = false
    end
end

function Probe:updateEntity(state, nowSeconds)
    local kinematics = OuttaMyWay.ConflictEmergenceProbe
    local key = kinematics.vehicleKey(state)
    local previous = self.entityHistory[key]
    local elapsed = previous ~= nil and math.max(0.001, nowSeconds - (previous.timestamp or nowSeconds)) or 0
    local headingDelta = previous ~= nil and absAngleDelta(state.heading, previous.heading) or 0
    local speedDelta = previous ~= nil and math.abs((state.actualSpeed or 0) - (previous.speed or 0)) or 0
    local headingRate = elapsed > 0 and headingDelta / elapsed or 0
    local speedRate = elapsed > 0 and speedDelta / elapsed or 0

    local minimumSpeed = OuttaMyWay.PROTOTYPE_02_MIN_SPEED_KMH or 0.75
    local headingLimit = OuttaMyWay.PROTOTYPE_02_MAX_HEADING_RATE_DEG_S or 4.0
    local speedLimit = OuttaMyWay.PROTOTYPE_02_MAX_SPEED_RATE_KMH_S or 2.0
    local stableNow = not bool(state.isTurn)
        and (state.actualSpeed or 0) >= minimumSpeed
        and headingRate <= headingLimit
        and speedRate <= speedLimit

    local stableDuration = 0
    if stableNow then
        stableDuration = (previous ~= nil and previous.stableDuration or 0) + elapsed
    end

    local settlementDuration = OuttaMyWay.PROTOTYPE_02_SETTLEMENT_DURATION_S or 2.0
    local current = {
        key = key,
        timestamp = nowSeconds,
        heading = state.heading or 0,
        speed = state.actualSpeed or 0,
        headingDelta = headingDelta,
        speedDelta = speedDelta,
        headingRate = headingRate,
        speedRate = speedRate,
        stableNow = stableNow,
        stableDuration = stableDuration,
        settled = stableDuration >= settlementDuration,
        isTurn = bool(state.isTurn),
        phase = state.phase
    }
    self.entityHistory[key] = current
    return current
end

function Probe:isConflictPositive(result)
    if result == nil or result.tcpa == nil or result.dcpa == nil then return false end
    return (result.closing or 0) > (OuttaMyWay.PROTOTYPE_02_MIN_CLOSING_RATE_MPS or 0.10)
        and result.tcpa >= 0
        and result.tcpa <= (OuttaMyWay.PROTOTYPE_02_CONFLICT_TIME_S or 30.0)
        and result.dcpa <= (OuttaMyWay.PROTOTYPE_02_CONFLICT_CLEARANCE_M or 14.0)
end

function Probe:classify(previous, positive, stableConflict, negativeDuration)
    local previousState = previous ~= nil and previous.state or nil
    if stableConflict then return "ESTABLISHED" end
    if positive then
        if previousState == "ESTABLISHED" or previousState == "DECAYING" then return "DECAYING" end
        return "FORMING"
    end

    local wasActive = previousState == "FORMING"
        or previousState == "ESTABLISHED"
        or previousState == "DECAYING"
    if wasActive then
        if negativeDuration >= (OuttaMyWay.PROTOTYPE_02_CLEAR_DURATION_S or 2.0) then
            return "CLEARED"
        end
        return "DECAYING"
    end
    if previousState == "CLEARED" then return "CLEARED" end
    return "CLEAR"
end

function Probe:logSample(a, b, result, aMotion, bMotion, pair, previous, metrics, transition)
    local kinematics = OuttaMyWay.ConflictEmergenceProbe
    local relation, headingDelta = kinematics.relationship(a, b)
    OuttaMyWay.Logger:val(
        "PROTOTYPE02 %s t=%.1fs pair=%s state=%s previous=%s positive=%s persistence=%.2fs samples=%d relation=%s headingDelta=%.1fdeg distance=%.2fm closing=%s tCPA=%s dCPA=%s zone=%s window={duration=%.2fs dCPASpread=%s zoneDrift=%s countdownError=%s positiveSamples=%d} A={name=%s turn=%s phase=%s headingRate=%.2fdeg/s speedRate=%.2fkmh/s stableNow=%s stableFor=%.2fs settled=%s} B={name=%s turn=%s phase=%s headingRate=%.2fdeg/s speedRate=%.2fkmh/s stableNow=%s stableFor=%.2fs settled=%s} thresholds={settlement=%.1fs persistence=%.1fs headingRate<=%.1fdeg/s speedRate<=%.1fkmh/s dCPASpread<=%.1fm zoneDrift<=%.1fm/s countdownError<=%.1fs clear=%.1fs}",
        transition and "TRANSITION" or "SAMPLE",
        pair.timestamp or 0,
        kinematics.pairNames(a, b),
        pair.state,
        previous ~= nil and previous.state or "none",
        tostring(pair.positive),
        pair.positiveDuration or 0,
        pair.positiveSamples or 0,
        relation,
        headingDelta,
        result.distance or -1,
        formatNumber(result.closing, "%.3f", "m/s"),
        formatNumber(result.tcpa, "%.2f", "s"),
        formatNumber(result.dcpa, "%.2f", "m"),
        result.zoneX ~= nil and string.format("(%.2f,%.2f)", result.zoneX, result.zoneZ) or "unknown",
        metrics.duration or 0,
        formatNumber(metrics.dcpaSpread, "%.2f", "m"),
        formatNumber(metrics.zoneDrift, "%.2f", "m/s"),
        formatNumber(metrics.countdownError, "%.2f", "s"),
        metrics.positiveSamples or 0,
        a.name or "AI vehicle", tostring(aMotion.isTurn), tostring(aMotion.phase),
        aMotion.headingRate or 0, aMotion.speedRate or 0, tostring(aMotion.stableNow),
        aMotion.stableDuration or 0, tostring(aMotion.settled),
        b.name or "AI vehicle", tostring(bMotion.isTurn), tostring(bMotion.phase),
        bMotion.headingRate or 0, bMotion.speedRate or 0, tostring(bMotion.stableNow),
        bMotion.stableDuration or 0, tostring(bMotion.settled),
        OuttaMyWay.PROTOTYPE_02_SETTLEMENT_DURATION_S or 2.0,
        OuttaMyWay.PROTOTYPE_02_PERSISTENCE_DURATION_S or 2.0,
        OuttaMyWay.PROTOTYPE_02_MAX_HEADING_RATE_DEG_S or 4.0,
        OuttaMyWay.PROTOTYPE_02_MAX_SPEED_RATE_KMH_S or 2.0,
        OuttaMyWay.PROTOTYPE_02_MAX_DCPA_SPREAD_M or 5.0,
        OuttaMyWay.PROTOTYPE_02_MAX_ZONE_DRIFT_MPS or 2.0,
        OuttaMyWay.PROTOTYPE_02_MAX_TCPA_COUNTDOWN_ERROR_S or 1.5,
        OuttaMyWay.PROTOTYPE_02_CLEAR_DURATION_S or 2.0)
end

function Probe:updatePair(a, b, aMotion, bMotion, nowSeconds, nowMs)
    local kinematics = OuttaMyWay.ConflictEmergenceProbe
    local key = kinematics.pairKey(a, b)
    local previous = self.pairs[key]
    local result = kinematics.closestApproach(a, b)

    if not kinematics.shouldTrack(result) then
        if previous ~= nil then
            OuttaMyWay.Logger:val(
                "PROTOTYPE02 PAIR_EXIT t=%.1fs pair=%s previous=%s reason=outside-observation",
                nowSeconds, kinematics.pairNames(a, b), tostring(previous.state))
            self.pairs[key] = nil
        end
        return false
    end

    local elapsed = previous ~= nil and math.max(0.001, nowSeconds - (previous.timestamp or nowSeconds)) or 0
    local positive = self:isConflictPositive(result)
    local positiveDuration = positive and ((previous ~= nil and previous.positiveDuration or 0) + elapsed) or 0
    local negativeDuration = positive and 0 or ((previous ~= nil and previous.negativeDuration or 0) + elapsed)
    local samples = previous ~= nil and previous.samples or {}
    appendSample(samples, {
        timestamp = nowSeconds,
        positive = positive,
        tcpa = result ~= nil and result.tcpa or nil,
        dcpa = result ~= nil and result.dcpa or nil,
        zoneX = result ~= nil and result.zoneX or nil,
        zoneZ = result ~= nil and result.zoneZ or nil
    }, nowSeconds, OuttaMyWay.PROTOTYPE_02_WINDOW_S or 3.0)
    local metrics = windowMetrics(samples)

    local enoughWindow = metrics.duration >= math.min(
        OuttaMyWay.PROTOTYPE_02_WINDOW_S or 3.0,
        OuttaMyWay.PROTOTYPE_02_PERSISTENCE_DURATION_S or 2.0)
    local stableConflict = positive
        and aMotion.settled == true
        and bMotion.settled == true
        and positiveDuration >= (OuttaMyWay.PROTOTYPE_02_PERSISTENCE_DURATION_S or 2.0)
        and enoughWindow
        and metrics.dcpaSpread ~= nil
        and metrics.dcpaSpread <= (OuttaMyWay.PROTOTYPE_02_MAX_DCPA_SPREAD_M or 5.0)
        and metrics.zoneDrift ~= nil
        and metrics.zoneDrift <= (OuttaMyWay.PROTOTYPE_02_MAX_ZONE_DRIFT_MPS or 2.0)
        and metrics.countdownError ~= nil
        and metrics.countdownError <= (OuttaMyWay.PROTOTYPE_02_MAX_TCPA_COUNTDOWN_ERROR_S or 1.5)

    local stateName = self:classify(previous, positive, stableConflict, negativeDuration)
    local pair = {
        key = key,
        timestamp = nowSeconds,
        state = stateName,
        positive = positive,
        positiveDuration = positiveDuration,
        negativeDuration = negativeDuration,
        positiveSamples = positive and ((previous ~= nil and previous.positiveSamples or 0) + 1) or 0,
        samples = samples,
        lastSeenMs = nowMs,
        nextLogAtMs = previous ~= nil and previous.nextLogAtMs or 0,
        everEstablished = (previous ~= nil and previous.everEstablished == true) or stateName == "ESTABLISHED",
        outcomeLogged = previous ~= nil and previous.outcomeLogged == true
    }

    local changed = previous == nil or previous.state ~= stateName
    local due = nowMs >= (pair.nextLogAtMs or 0)
    if changed or due then
        self:logSample(a, b, result, aMotion, bMotion, pair, previous, metrics, changed)
        pair.nextLogAtMs = nowMs + (OuttaMyWay.PROTOTYPE_02_LOG_INTERVAL_MS or 2000)
    end

    if changed and stateName == "ESTABLISHED" then
        OuttaMyWay.Logger:val(
            "PROTOTYPE02 CONFLICT_CONFIDENCE_ESTABLISHED t=%.1fs pair=%s persistence=%.2fs dCPA=%.2fm tCPA=%.2fs dCPASpread=%.2fm zoneDrift=%.2fm/s countdownError=%.2fs bothSettled=true",
            nowSeconds, kinematics.pairNames(a, b), positiveDuration,
            result.dcpa or -1, result.tcpa or -1, metrics.dcpaSpread or -1,
            metrics.zoneDrift or -1, metrics.countdownError or -1)
    end

    local lowSpeed = OuttaMyWay.PROTOTYPE_02_OUTCOME_LOW_SPEED_KMH or 0.75
    if pair.everEstablished and not pair.outcomeLogged
        and (a.actualSpeed or 0) < lowSpeed and (b.actualSpeed or 0) < lowSpeed then
        pair.outcomeLogged = true
        OuttaMyWay.Logger:val(
            "PROTOTYPE02 OUTCOME_CANDIDATE t=%.1fs pair=%s kind=both-low-speed state=%s distance=%.2fm Aphase=%s Bphase=%s Ablocked=%s Bblocked=%s",
            nowSeconds, kinematics.pairNames(a, b), stateName, result.distance or -1,
            tostring(a.phase), tostring(b.phase), tostring(a.blocked == true), tostring(b.blocked == true))
    end

    self.pairs[key] = pair
    return true
end

function Probe:update(dt)
    if self.pairs == nil then self:init() end
    if self.enabled ~= true then return end

    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_02_INTERVAL_MS or 500
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local observer = OuttaMyWay.Observer
    local observed = observer ~= nil and observer.states or nil
    if type(observed) ~= "table" then return end

    local kinematics = OuttaMyWay.ConflictEmergenceProbe
    local states = {}
    for _, state in pairs(observed) do
        if state ~= nil and state.active == true and state.x ~= nil and state.z ~= nil then
            states[#states + 1] = state
        end
    end
    table.sort(states, function(a, b) return kinematics.vehicleKey(a) < kinematics.vehicleKey(b) end)

    local nowMs = g_time or 0
    local nowSeconds = 0
    local motionByKey = {}
    for _, state in ipairs(states) do
        nowSeconds = math.max(nowSeconds, state.timestamp or 0)
        motionByKey[kinematics.vehicleKey(state)] = self:updateEntity(state, state.timestamp or nowSeconds)
    end

    local seenPairs = {}
    local seenEntities = {}
    for _, state in ipairs(states) do seenEntities[kinematics.vehicleKey(state)] = true end

    for i = 1, #states - 1 do
        for j = i + 1, #states do
            local a, b = states[i], states[j]
            nowSeconds = math.max(nowSeconds, a.timestamp or 0, b.timestamp or 0)
            local aMotion = motionByKey[kinematics.vehicleKey(a)]
            local bMotion = motionByKey[kinematics.vehicleKey(b)]
            local key = kinematics.pairKey(a, b)
            if self:updatePair(a, b, aMotion, bMotion, nowSeconds, nowMs) then seenPairs[key] = true end
        end
    end

    for key, pair in pairs(self.pairs) do
        if not seenPairs[key] then
            OuttaMyWay.Logger:val(
                "PROTOTYPE02 PAIR_ENDED t=%.1fs key=%s previous=%s reason=worker-detached-or-no-longer-observed",
                nowSeconds, tostring(key), tostring(pair.state))
            self.pairs[key] = nil
        end
    end

    for key in pairs(self.entityHistory) do
        if not seenEntities[key] then self.entityHistory[key] = nil end
    end

    local heartbeat = OuttaMyWay.PROTOTYPE_02_HEARTBEAT_MS or 15000
    if nowMs - (self.lastHeartbeatMs or 0) >= heartbeat then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE02 HEARTBEAT t=%.1fs observedWorkers=%d trackedEntities=%d trackedPairs=%d passive=true",
            nowSeconds, #states, countTable(self.entityHistory), countTable(self.pairs))
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.entityHistory = {}
    self.pairs = {}
    self.lastHeartbeatMs = 0
end
