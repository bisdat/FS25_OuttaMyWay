-- FS25_OuttaMyWay v4.6.6
-- Prototype 03: passive evidence capture for the Candidate Option Preservation Window.
-- This module observes manoeuvre ordering, intent revelation and response margin.
-- It never selects a Commitment and never controls vehicles.

OuttaMyWay.OptionPreservationProbe = OuttaMyWay.OptionPreservationProbe or {}
local Probe = OuttaMyWay.OptionPreservationProbe

local function countTable(values)
    local count = 0
    if type(values) == "table" then
        for _ in pairs(values) do count = count + 1 end
    end
    return count
end

local function bool(value)
    return value == true
end

local function formatNumber(value, format, suffix)
    if value == nil then return "unknown" end
    return string.format(format or "%.2f", value) .. (suffix or "")
end

local function stateName(state)
    return state ~= nil and state.name or "unknown"
end

local function stoppingEstimate(speedKmh)
    local speedMps = math.max(0, speedKmh or 0) / 3.6
    local deceleration = math.max(0.1, OuttaMyWay.PROTOTYPE_03_ASSUMED_DECELERATION_MPS2 or 2.0)
    local reaction = math.max(0, OuttaMyWay.PROTOTYPE_03_REACTION_TIME_S or 0.5)
    local stopTime = reaction + speedMps / deceleration
    local stopDistance = speedMps * reaction + (speedMps * speedMps) / (2 * deceleration)
    return stopTime, stopDistance
end

local function projectedResponseMargin(result, confidence, stopTime)
    if result == nil or result.tcpa == nil or result.tcpa < 0 then return nil end
    if confidence == nil or confidence.positive ~= true then return nil end
    local safetyBuffer = OuttaMyWay.PROTOTYPE_03_RESPONSE_SAFETY_BUFFER_S or 2.0
    return result.tcpa - stopTime - safetyBuffer
end

function Probe:init()
    self.elapsedMs = 0
    self.entities = {}
    self.windows = {}
    self.lastHeartbeatMs = 0
    self.enabled = OuttaMyWay.PROTOTYPE_03_ENABLED == true

    local observerOnly = OuttaMyWay.AI_EXPLORER_ONLY == true
    local trafficDisabled = OuttaMyWay.TRAFFIC_V2_ENABLED ~= true
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local p2 = OuttaMyWay.ConflictConfidenceProbe
    local dependenciesAvailable = p1 ~= nil
        and type(p1.vehicleKey) == "function"
        and type(p1.pairKey) == "function"
        and type(p1.pairNames) == "function"
        and type(p1.closestApproach) == "function"
        and p2 ~= nil
        and type(p2.motionFor) == "function"
        and type(p2.pairStateFor) == "function"
    local passive = observerOnly and trafficDisabled

    OuttaMyWay.Logger:info(
        "PROTOTYPE 03 ACTIVE: Option Preservation Window evidence capture enabled=%s passive=%s dependenciesAvailable=%s no vehicle control",
        tostring(self.enabled), tostring(passive), tostring(dependenciesAvailable))

    if self.enabled and not passive then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 03 PASSIVE GUARANTEE FAILED: AI_EXPLORER_ONLY must be true and TRAFFIC_V2_ENABLED must be false")
        self.enabled = false
    elseif self.enabled and not dependenciesAvailable then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 03 DEPENDENCY FAILED: Prototype 01 kinematics or Prototype 02 evidence accessors are unavailable")
        self.enabled = false
    end
end

function Probe:updateEntity(state, motion, nowSeconds)
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local key = p1.vehicleKey(state)
    local previous = self.entities[key]
    local turning = bool(state.isTurn)
    local startedNow = previous ~= nil and previous.turning == false and turning
    local endedNow = previous ~= nil and previous.turning == true and not turning
    local settled = motion ~= nil and motion.settled == true
    local revealedNow = previous ~= nil and previous.settled ~= true and settled

    local current = {
        key = key,
        name = state.name or "AI vehicle",
        timestamp = nowSeconds,
        turning = turning,
        settled = settled,
        startedNow = startedNow,
        endedNow = endedNow,
        revealedNow = revealedNow,
        manoeuvreStartAt = previous ~= nil and previous.manoeuvreStartAt or nil,
        manoeuvreEndAt = previous ~= nil and previous.manoeuvreEndAt or nil,
        intentRevealAt = previous ~= nil and previous.intentRevealAt or nil,
        progress = state.progress,
        speed = state.actualSpeed or 0,
        phase = state.phase,
        blocked = bool(state.blocked),
        active = state.active == true
    }

    if startedNow then
        current.manoeuvreStartAt = nowSeconds
        current.manoeuvreEndAt = nil
        current.intentRevealAt = nil
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 MANOEUVRE_START t=%.1fs entity=%s progress=%s speed=%.2fkm/h phase=%s",
            nowSeconds, current.name, formatNumber(current.progress, "%.3f", ""), current.speed, tostring(current.phase))
    elseif endedNow then
        current.manoeuvreEndAt = nowSeconds
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 MANOEUVRE_END t=%.1fs entity=%s duration=%s progress=%s speed=%.2fkm/h phase=%s",
            nowSeconds, current.name,
            current.manoeuvreStartAt ~= nil and formatNumber(nowSeconds - current.manoeuvreStartAt, "%.2f", "s") or "unknown",
            formatNumber(current.progress, "%.3f", ""), current.speed, tostring(current.phase))
    end

    if revealedNow and current.manoeuvreStartAt ~= nil then
        current.intentRevealAt = nowSeconds
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 INTENT_REVELATION_POINT t=%.1fs entity=%s sinceManoeuvreStart=%.2fs sinceManoeuvreEnd=%s headingStableFor=%s progress=%s speed=%.2fkm/h",
            nowSeconds, current.name, nowSeconds - current.manoeuvreStartAt,
            current.manoeuvreEndAt ~= nil and formatNumber(nowSeconds - current.manoeuvreEndAt, "%.2f", "s") or "manoeuvre-active",
            motion ~= nil and formatNumber(motion.stableDuration, "%.2f", "s") or "unknown",
            formatNumber(current.progress, "%.3f", ""), current.speed)
    end

    self.entities[key] = current
    return current
end

function Probe:openWindow(a, b, aEntity, bEntity, nowSeconds, nowMs, result)
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local key = p1.pairKey(a, b)
    if self.windows[key] ~= nil then return end

    local later, earlier = nil, nil
    if aEntity.startedNow and bEntity.manoeuvreStartAt ~= nil then
        later, earlier = aEntity, bEntity
    elseif bEntity.startedNow and aEntity.manoeuvreStartAt ~= nil then
        later, earlier = bEntity, aEntity
    else
        return
    end

    local lead = (later.manoeuvreStartAt or nowSeconds) - (earlier.manoeuvreStartAt or nowSeconds)
    if lead < (OuttaMyWay.PROTOTYPE_03_MIN_MANOEUVRE_LEAD_S or 0.5) then return end
    if earlier.settled == true or earlier.blocked == true or later.blocked == true then return end
    local minimumOperationalSpeed = OuttaMyWay.PROTOTYPE_03_MIN_OPERATIONAL_SPEED_KMH or 2.0
    if (earlier.speed or 0) < minimumOperationalSpeed or (later.speed or 0) < minimumOperationalSpeed then return end
    if result == nil or result.distance > (OuttaMyWay.PROTOTYPE_03_OBSERVATION_RADIUS_M or 500.0) then return end

    local window = {
        key = key,
        state = "CANDIDATE_OPEN",
        openedAt = nowSeconds,
        nextLogAtMs = 0,
        lastSeenMs = nowMs,
        progressKey = earlier.key,
        progressName = earlier.name,
        holdKey = later.key,
        holdName = later.name,
        progressStartAt = earlier.manoeuvreStartAt,
        holdStartAt = later.manoeuvreStartAt,
        lead = lead,
        revealAt = nil,
        revealSnapshot = nil,
        actionableAt = nil,
        establishedAt = nil,
        progressInvariant = earlier.key ~= later.key,
        completed = false,
        completedAtMs = nil
    }
    self.windows[key] = window

    OuttaMyWay.Logger:val(
        "PROTOTYPE03 WINDOW_OPEN t=%.1fs pair=%s state=CANDIDATE_OPEN progressEntity=%s holdCandidate=%s manoeuvreLead=%.2fs distance=%.2fm progressPreserved=%s heldParticipants=1 totalParticipants=2 reason=later-entity-started-before-earlier-intent-settled",
        nowSeconds, p1.pairNames(a, b), window.progressName, window.holdName, lead,
        result.distance or -1, tostring(window.progressInvariant))
end

function Probe:logWindow(a, b, progressState, holdState, progressMotion, holdMotion, result, confidence, window, previousState, nowSeconds, transition, reason)
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local stopTime, stopDistance = stoppingEstimate(holdState ~= nil and holdState.actualSpeed or 0)
    local safetyBuffer = OuttaMyWay.PROTOTYPE_03_RESPONSE_SAFETY_BUFFER_S or 2.0
    local timeMargin = projectedResponseMargin(result, confidence, stopTime)
    local remainingProgress = holdState ~= nil and holdState.progress ~= nil
        and math.max(0, 1 - holdState.progress) or nil
    local progressEntity = self.entities ~= nil and self.entities[window.progressKey] or nil
    local overlapEnd = progressEntity ~= nil and progressEntity.manoeuvreEndAt or nowSeconds
    local overlapDuration = math.max(0, math.min(nowSeconds, overlapEnd or nowSeconds) - (window.holdStartAt or nowSeconds))

    OuttaMyWay.Logger:val(
        "PROTOTYPE03 %s t=%.1fs pair=%s state=%s previous=%s reason=%s progressEntity=%s holdCandidate=%s progressPreserved=%s heldParticipants=1 totalParticipants=2 windowAge=%.2fs manoeuvreOverlap=%.2fs distance=%s closing=%s tCPA=%s dCPA=%s confidenceState=%s progress={turn=%s settled=%s revealAt=%s progress=%s speed=%.2fkm/h phase=%s blocked=%s} hold={turn=%s settled=%s progress=%s remainingProgress=%s speed=%.2fkm/h stopTime=%.2fs stopDistance=%.2fm projectedResponseMargin=%s phase=%s blocked=%s} thresholds={lead>=%.1fs observe>=%.1fs radius=%.1fm decel=%.1fm/s2 reaction=%.1fs safetyBuffer=%.1fs}",
        transition and "TRANSITION" or "SAMPLE",
        nowSeconds,
        p1.pairNames(a, b),
        window.state,
        previousState or "none",
        reason or "periodic",
        window.progressName,
        window.holdName,
        tostring(window.progressInvariant),
        math.max(0, nowSeconds - (window.openedAt or nowSeconds)),
        overlapDuration,
        result ~= nil and formatNumber(result.distance, "%.2f", "m") or "unknown",
        result ~= nil and formatNumber(result.closing, "%.3f", "m/s") or "unknown",
        result ~= nil and formatNumber(result.tcpa, "%.2f", "s") or "unknown",
        result ~= nil and formatNumber(result.dcpa, "%.2f", "m") or "unknown",
        confidence ~= nil and tostring(confidence.state) or "unknown",
        tostring(progressState ~= nil and progressState.isTurn == true),
        tostring(progressMotion ~= nil and progressMotion.settled == true),
        window.revealAt ~= nil and formatNumber(window.revealAt, "%.1f", "s") or "unknown",
        progressState ~= nil and formatNumber(progressState.progress, "%.3f", "") or "unknown",
        progressState ~= nil and (progressState.actualSpeed or 0) or 0,
        progressState ~= nil and tostring(progressState.phase) or "unknown",
        tostring(progressState ~= nil and progressState.blocked == true),
        tostring(holdState ~= nil and holdState.isTurn == true),
        tostring(holdMotion ~= nil and holdMotion.settled == true),
        holdState ~= nil and formatNumber(holdState.progress, "%.3f", "") or "unknown",
        formatNumber(remainingProgress, "%.3f", ""),
        holdState ~= nil and (holdState.actualSpeed or 0) or 0,
        stopTime,
        stopDistance,
        formatNumber(timeMargin, "%.2f", "s"),
        holdState ~= nil and tostring(holdState.phase) or "unknown",
        tostring(holdState ~= nil and holdState.blocked == true),
        OuttaMyWay.PROTOTYPE_03_MIN_MANOEUVRE_LEAD_S or 0.5,
        OuttaMyWay.PROTOTYPE_03_OBSERVING_CONFIRM_S or 0.5,
        OuttaMyWay.PROTOTYPE_03_OBSERVATION_RADIUS_M or 500.0,
        OuttaMyWay.PROTOTYPE_03_ASSUMED_DECELERATION_MPS2 or 2.0,
        OuttaMyWay.PROTOTYPE_03_REACTION_TIME_S or 0.5,
        safetyBuffer)
end

function Probe:updateWindow(a, b, stateByKey, motionByKey, nowSeconds, nowMs)
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local p2 = OuttaMyWay.ConflictConfidenceProbe
    local key = p1.pairKey(a, b)
    local window = self.windows[key]
    if window == nil then return false end

    local progressState = stateByKey[window.progressKey]
    local holdState = stateByKey[window.holdKey]
    local progressMotion = motionByKey[window.progressKey]
    local holdMotion = motionByKey[window.holdKey]
    local result = p1.closestApproach(a, b)
    local confidence = p2.pairStateFor(a, b)
    local previousState = window.state
    local reason = nil

    window.lastSeenMs = nowMs
    window.progressInvariant = window.progressKey ~= window.holdKey
        and progressState ~= nil and progressState.active == true
        and progressState.blocked ~= true

    local observationAge = nowSeconds - (window.openedAt or nowSeconds)

    if window.revealAt ~= nil
        and progressState ~= nil and progressState.isTurn == true
        and window.completed ~= true then
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 LOCAL_INTENT_EXPIRED t=%.1fs pair=%s progressEntity=%s holdCandidate=%s previousRevealAt=%.1fs validFor=%.2fs reason=progress-entity-entered-new-manoeuvre",
            nowSeconds, p1.pairNames(a, b), window.progressName, window.holdName,
            window.revealAt, math.max(0, nowSeconds - window.revealAt))
        window.revealAt = nil
        window.revealSnapshot = nil
        window.actionableAt = nil
        window.state = "OBSERVING"
        reason = "progress-local-intent-expired-at-new-manoeuvre"
    end

    if window.state == "CANDIDATE_OPEN"
        and observationAge >= (OuttaMyWay.PROTOTYPE_03_OBSERVING_CONFIRM_S or 0.5) then
        window.state = "OBSERVING"
        reason = "progress-entity-continues-and-can-reveal-intent"
    end

    if window.revealAt == nil
        and progressMotion ~= nil and progressMotion.settled == true
        and progressState ~= nil and progressState.blocked ~= true then
        window.revealAt = nowSeconds
        local stopTime, stopDistance = stoppingEstimate(holdState ~= nil and holdState.actualSpeed or 0)
        local timeMargin = projectedResponseMargin(result, confidence, stopTime)
        window.revealSnapshot = {
            holdProgress = holdState ~= nil and holdState.progress or nil,
            holdSpeed = holdState ~= nil and holdState.actualSpeed or 0,
            stopTime = stopTime,
            stopDistance = stopDistance,
            projectedMargin = timeMargin,
            confidenceState = confidence ~= nil and confidence.state or nil,
            conflictPositive = confidence ~= nil and confidence.positive == true
        }
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 INTENT_REVEALED_TO_PAIR t=%.1fs pair=%s progressEntity=%s holdCandidate=%s windowAge=%.2fs holdTurn=%s holdSettled=%s holdProgress=%s holdSpeed=%.2fkm/h stopTime=%.2fs stopDistance=%.2fm tCPA=%s projectedResponseMargin=%s conflictPositive=%s progressPreserved=%s",
            nowSeconds, p1.pairNames(a, b), window.progressName, window.holdName,
            nowSeconds - window.openedAt,
            tostring(holdState ~= nil and holdState.isTurn == true),
            tostring(holdMotion ~= nil and holdMotion.settled == true),
            holdState ~= nil and formatNumber(holdState.progress, "%.3f", "") or "unknown",
            holdState ~= nil and (holdState.actualSpeed or 0) or 0,
            stopTime, stopDistance,
            result ~= nil and formatNumber(result.tcpa, "%.2f", "s") or "unknown",
            formatNumber(timeMargin, "%.2f", "s"),
            tostring(confidence ~= nil and confidence.positive == true),
            tostring(window.progressInvariant))
    end

    if window.revealAt ~= nil
        and window.actionableAt == nil
        and holdMotion ~= nil and holdMotion.settled ~= true
        and window.progressInvariant then
        window.actionableAt = nowSeconds
        window.state = "ACTIONABLE"
        reason = "progress-intent-revealed-while-hold-candidate-remains-unsettled"
    end

    if window.completed ~= true and confidence ~= nil and confidence.state == "ESTABLISHED" then
        window.establishedAt = window.establishedAt or nowSeconds
        window.state = "EXHAUSTED"
        window.completed = true
        window.completedAtMs = window.completedAtMs or nowMs
        reason = "both-trajectories-settled-and-conflict-established"
        local revealInterval = window.revealAt ~= nil and (nowSeconds - window.revealAt) or nil
        local revealStopTime = window.revealSnapshot ~= nil and window.revealSnapshot.stopTime or nil
        local retrospectiveMargin = revealInterval ~= nil and revealStopTime ~= nil
            and revealInterval - revealStopTime - (OuttaMyWay.PROTOTYPE_03_RESPONSE_SAFETY_BUFFER_S or 2.0) or nil
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 ALTERNATE_EXHAUSTION_CANDIDATE t=%.1fs pair=%s progressEntity=%s holdCandidate=%s openToEstablished=%.2fs revealToEstablished=%s actionableToEstablished=%s holdProgressAtReveal=%s holdSpeedAtReveal=%s stopTimeAtReveal=%s stopDistanceAtReveal=%s retrospectiveResponseMargin=%s conflictState=%s progressPreserved=%s mutualCommitmentTrapCandidate=true",
            nowSeconds, p1.pairNames(a, b), window.progressName, window.holdName,
            nowSeconds - window.openedAt,
            formatNumber(revealInterval, "%.2f", "s"),
            window.actionableAt ~= nil and formatNumber(nowSeconds - window.actionableAt, "%.2f", "s") or "unknown",
            window.revealSnapshot ~= nil and formatNumber(window.revealSnapshot.holdProgress, "%.3f", "") or "unknown",
            window.revealSnapshot ~= nil and formatNumber(window.revealSnapshot.holdSpeed, "%.2f", "km/h") or "unknown",
            formatNumber(revealStopTime, "%.2f", "s"),
            window.revealSnapshot ~= nil and formatNumber(window.revealSnapshot.stopDistance, "%.2f", "m") or "unknown",
            formatNumber(retrospectiveMargin, "%.2f", "s"),
            tostring(confidence.state), tostring(window.progressInvariant))
    elseif window.completed ~= true
        and confidence ~= nil and (confidence.state == "CLEAR" or confidence.state == "CLEARED")
        and progressMotion ~= nil and progressMotion.settled == true
        and holdMotion ~= nil and holdMotion.settled == true
        and observationAge >= (OuttaMyWay.PROTOTYPE_03_SAFE_CLOSE_DURATION_S or 2.0) then
        window.state = "CLOSED_SAFE"
        window.completed = true
        window.completedAtMs = window.completedAtMs or nowMs
        reason = "both-trajectories-settled-without-established-conflict"
    end

    local changed = previousState ~= window.state
    local due = nowMs >= (window.nextLogAtMs or 0)
    if changed or due then
        self:logWindow(a, b, progressState, holdState, progressMotion, holdMotion,
            result, confidence, window, previousState, nowSeconds, changed, reason)
        window.nextLogAtMs = nowMs + (OuttaMyWay.PROTOTYPE_03_LOG_INTERVAL_MS or 1000)
    end

    if changed and window.state == "ACTIONABLE" then
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 OPTION_PRESERVATION_ACTIONABLE t=%.1fs pair=%s progressEntity=%s holdCandidate=%s responseMarginBegins=true progressPreserved=%s observationDeadlockAvoided=true",
            nowSeconds, p1.pairNames(a, b), window.progressName, window.holdName,
            tostring(window.progressInvariant))
    end

    return true
end

function Probe:update(dt)
    if self.windows == nil then self:init() end
    if self.enabled ~= true then return end

    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_03_INTERVAL_MS or 250
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local observer = OuttaMyWay.Observer
    local observed = observer ~= nil and observer.states or nil
    if type(observed) ~= "table" then return end

    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local p2 = OuttaMyWay.ConflictConfidenceProbe
    local states = {}
    for _, state in pairs(observed) do
        if state ~= nil and state.active == true and state.x ~= nil and state.z ~= nil then
            states[#states + 1] = state
        end
    end
    table.sort(states, function(a, b) return p1.vehicleKey(a) < p1.vehicleKey(b) end)

    local nowMs = g_time or 0
    local nowSeconds = 0
    local stateByKey = {}
    local motionByKey = {}
    local entityByKey = {}
    local seenEntities = {}

    for _, state in ipairs(states) do
        nowSeconds = math.max(nowSeconds, state.timestamp or 0)
        local key = p1.vehicleKey(state)
        local motion = p2.motionFor(state)
        stateByKey[key] = state
        motionByKey[key] = motion
        entityByKey[key] = self:updateEntity(state, motion, state.timestamp or nowSeconds)
        seenEntities[key] = true
    end

    local seenWindows = {}
    for i = 1, #states - 1 do
        for j = i + 1, #states do
            local a, b = states[i], states[j]
            local aKey, bKey = p1.vehicleKey(a), p1.vehicleKey(b)
            local result = p1.closestApproach(a, b)
            self:openWindow(a, b, entityByKey[aKey], entityByKey[bKey], nowSeconds, nowMs, result)
            local key = p1.pairKey(a, b)
            if self:updateWindow(a, b, stateByKey, motionByKey, nowSeconds, nowMs) then
                seenWindows[key] = true
            end
        end
    end

    for key, window in pairs(self.windows) do
        if not seenWindows[key] then
            if window.completed ~= true then
                OuttaMyWay.Logger:val(
                    "PROTOTYPE03 WINDOW_ENDED t=%.1fs key=%s previous=%s progressEntity=%s holdCandidate=%s reason=worker-detached-or-no-longer-observed",
                    nowSeconds, tostring(key), tostring(window.state), tostring(window.progressName), tostring(window.holdName))
            end
            self.windows[key] = nil
        elseif window.completed == true
            and nowMs - (window.completedAtMs or nowMs) >= (OuttaMyWay.PROTOTYPE_03_COMPLETED_RETENTION_MS or 5000) then
            self.windows[key] = nil
        end
    end

    for key in pairs(self.entities) do
        if not seenEntities[key] then self.entities[key] = nil end
    end

    local heartbeat = OuttaMyWay.PROTOTYPE_03_HEARTBEAT_MS or 15000
    if nowMs - (self.lastHeartbeatMs or 0) >= heartbeat then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE03 HEARTBEAT t=%.1fs observedWorkers=%d trackedEntities=%d trackedWindows=%d passive=true progressPreservationInvariant=enabled",
            nowSeconds, #states, countTable(self.entities), countTable(self.windows))
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.entities = {}
    self.windows = {}
    self.lastHeartbeatMs = 0
end
