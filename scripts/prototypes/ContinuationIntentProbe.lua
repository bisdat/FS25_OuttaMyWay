-- FS25_OuttaMyWay v4.6.5
-- Prototype 04: passive evidence capture for continuation intent and safe release.
-- This module expires locally revealed intent when a new manoeuvre begins and
-- retrospectively evaluates an observed release through the Progress Entity's
-- next repositioning event. It never holds, releases or controls a vehicle.

OuttaMyWay.ContinuationIntentProbe = OuttaMyWay.ContinuationIntentProbe or {}
local Probe = OuttaMyWay.ContinuationIntentProbe

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

local function stateName(value)
    return value ~= nil and value or "unknown"
end

local function pairConflictPositive(a, b)
    local p2 = OuttaMyWay.ConflictConfidenceProbe
    local confidence = p2 ~= nil and p2.pairStateFor ~= nil and p2.pairStateFor(a, b) or nil
    return confidence ~= nil and confidence.positive == true, confidence
end

function Probe:init()
    self.elapsedMs = 0
    self.entities = {}
    self.trials = {}
    self.lastHeartbeatMs = 0
    self.enabled = OuttaMyWay.PROTOTYPE_04_ENABLED == true

    local observerOnly = OuttaMyWay.AI_EXPLORER_ONLY == true
    local trafficDisabled = OuttaMyWay.TRAFFIC_V2_ENABLED ~= true
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local p2 = OuttaMyWay.ConflictConfidenceProbe
    local p3 = OuttaMyWay.OptionPreservationProbe
    local dependenciesAvailable = p1 ~= nil
        and type(p1.vehicleKey) == "function"
        and type(p1.pairKey) == "function"
        and type(p1.pairNames) == "function"
        and type(p1.closestApproach) == "function"
        and p2 ~= nil
        and type(p2.motionFor) == "function"
        and type(p2.pairStateFor) == "function"
        and p3 ~= nil
        and type(p3.update) == "function"
    local passive = observerOnly and trafficDisabled

    OuttaMyWay.Logger:info(
        "PROTOTYPE 04 ACTIVE: Continuation Intent and Safe Release evidence capture enabled=%s passive=%s dependenciesAvailable=%s no vehicle control",
        tostring(self.enabled), tostring(passive), tostring(dependenciesAvailable))

    if self.enabled and not passive then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 04 PASSIVE GUARANTEE FAILED: AI_EXPLORER_ONLY must be true and TRAFFIC_V2_ENABLED must be false")
        self.enabled = false
    elseif self.enabled and not dependenciesAvailable then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 04 DEPENDENCY FAILED: Prototypes 01, 02 and 03 diagnostic access are unavailable")
        self.enabled = false
    end
end

function Probe:updateEntity(state, motion, nowSeconds)
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local key = p1.vehicleKey(state)
    local previous = self.entities[key]
    local turning = bool(state.isTurn)
    local startedNow = previous ~= nil and previous.turning ~= true and turning
    local endedNow = previous ~= nil and previous.turning == true and not turning
    local settled = motion ~= nil and motion.settled == true
    local operational = (state.actualSpeed or 0) >= (OuttaMyWay.PROTOTYPE_04_MIN_OPERATIONAL_SPEED_KMH or 2.0)
    local intentEpoch = previous ~= nil and previous.intentEpoch or 0
    local intentValid = previous ~= nil and previous.intentValid == true or false
    local revealedAt = previous ~= nil and previous.revealedAt or nil
    local expiredAt = previous ~= nil and previous.expiredAt or nil
    local expiryReason = previous ~= nil and previous.expiryReason or nil

    if startedNow and intentValid then
        intentValid = false
        expiredAt = nowSeconds
        expiryReason = "new-manoeuvre"
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 INTENT_EXPIRED t=%.1fs entity=%s epoch=%d validFor=%.2fs reason=new-manoeuvre headingAtReveal=%s currentHeading=%s progress=%s speed=%.2fkm/h",
            nowSeconds, state.name or "AI vehicle", intentEpoch,
            revealedAt ~= nil and math.max(0, nowSeconds - revealedAt) or 0,
            previous ~= nil and formatNumber(previous.headingAtReveal, "%.1f", "deg") or "unknown",
            formatNumber(state.heading, "%.1f", "deg"),
            formatNumber(state.progress, "%.3f", ""), state.actualSpeed or 0)
    elseif previous ~= nil and previous.active ~= true and state.active == true then
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 WORKER_REATTACHED t=%.1fs entity=%s turn=%s phase=%s progress=%s speed=%.2fkm/h intentValid=%s",
            nowSeconds, state.name or "AI vehicle", tostring(turning), tostring(state.phase),
            formatNumber(state.progress, "%.3f", ""), state.actualSpeed or 0, tostring(intentValid))
    end

    local revealNow = settled and not turning and operational and not intentValid
    if revealNow then
        intentEpoch = intentEpoch + 1
        intentValid = true
        revealedAt = nowSeconds
        expiredAt = nil
        expiryReason = nil
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 LOCAL_INTENT_REVEALED t=%.1fs entity=%s epoch=%d heading=%.1fdeg position=(%.2f,%.2f) speed=%.2fkm/h stableFor=%s phase=%s progress=%s scope=local-not-route-continuation",
            nowSeconds, state.name or "AI vehicle", intentEpoch, state.heading or 0,
            state.x or 0, state.z or 0, state.actualSpeed or 0,
            motion ~= nil and formatNumber(motion.stableDuration, "%.2f", "s") or "unknown",
            tostring(state.phase), formatNumber(state.progress, "%.3f", ""))
    end

    local current = {
        key = key,
        name = state.name or "AI vehicle",
        timestamp = nowSeconds,
        active = state.active == true,
        turning = turning,
        startedNow = startedNow,
        endedNow = endedNow,
        settled = settled,
        operational = operational,
        intentEpoch = intentEpoch,
        intentValid = intentValid,
        revealedAt = revealedAt,
        expiredAt = expiredAt,
        expiryReason = expiryReason,
        headingAtReveal = intentValid and (revealNow and state.heading or (previous ~= nil and previous.headingAtReveal)) or nil,
        revealX = intentValid and (revealNow and state.x or (previous ~= nil and previous.revealX)) or nil,
        revealZ = intentValid and (revealNow and state.z or (previous ~= nil and previous.revealZ)) or nil,
        x = state.x,
        z = state.z,
        heading = state.heading,
        speed = state.actualSpeed or 0,
        progress = state.progress,
        phase = state.phase,
        blocked = bool(state.blocked),
        lastSeenAt = nowSeconds
    }

    self.entities[key] = current
    return current
end

function Probe:markMissingEntities(seenEntities, nowSeconds)
    for key, entity in pairs(self.entities) do
        if not seenEntities[key] and entity.active == true then
            entity.active = false
            entity.detachedAt = nowSeconds
            if entity.intentValid then
                entity.intentValid = false
                entity.expiredAt = nowSeconds
                entity.expiryReason = "worker-detached"
                OuttaMyWay.Logger:val(
                    "PROTOTYPE04 INTENT_EXPIRED t=%.1fs entity=%s epoch=%d validFor=%.2fs reason=worker-detached",
                    nowSeconds, entity.name, entity.intentEpoch or 0,
                    entity.revealedAt ~= nil and math.max(0, nowSeconds - entity.revealedAt) or 0)
            end
            OuttaMyWay.Logger:val(
                "PROTOTYPE04 WORKER_DETACHED t=%.1fs entity=%s reason=no-longer-active-or-observed phase=%s progress=%s",
                nowSeconds, entity.name, tostring(entity.phase), formatNumber(entity.progress, "%.3f", ""))
        end
    end
end

function Probe:observePrototype03Windows(nowSeconds, nowMs)
    local p3 = OuttaMyWay.OptionPreservationProbe
    if p3 == nil or type(p3.windows) ~= "table" then return end

    for key, window in pairs(p3.windows) do
        if window ~= nil and window.progressKey ~= nil and window.holdKey ~= nil then
            local trial = self.trials[key]
            if trial == nil then
                trial = {
                    key = key,
                    state = "WINDOW_OBSERVED",
                    openedAt = window.openedAt or nowSeconds,
                    progressKey = window.progressKey,
                    progressName = window.progressName,
                    holdKey = window.holdKey,
                    holdName = window.holdName,
                    p3State = window.state,
                    lastSeenMs = nowMs,
                    nextLogAtMs = 0,
                    holdPresent = true,
                    holdDetachedAt = nil,
                    releaseAt = nil,
                    releaseCount = 0,
                    releaseIntentEpoch = nil,
                    continuationManoeuvreAt = nil,
                    continuationManoeuvreEndedAt = nil,
                    conflictAt = nil,
                    safeSince = nil,
                    completed = false,
                    completedAtMs = nil
                }
                self.trials[key] = trial
                OuttaMyWay.Logger:val(
                    "PROTOTYPE04 TRIAL_START t=%.1fs key=%s progressEntity=%s holdCandidate=%s source=prototype03-window p3State=%s purpose=distinguish-local-intent-from-route-continuation",
                    nowSeconds, tostring(key), tostring(trial.progressName), tostring(trial.holdName), tostring(window.state))
            else
                trial.p3State = window.state
                trial.lastSeenMs = nowMs
            end
        end
    end
end

function Probe:logTrial(trial, progressEntity, holdEntity, progressState, holdState, result, confidence, nowSeconds, transition, reason)
    local localAge = progressEntity ~= nil and progressEntity.intentValid and progressEntity.revealedAt ~= nil
        and math.max(0, nowSeconds - progressEntity.revealedAt) or nil
    local releaseAge = trial.releaseAt ~= nil and math.max(0, nowSeconds - trial.releaseAt) or nil

    OuttaMyWay.Logger:val(
        "PROTOTYPE04 %s t=%.1fs key=%s state=%s reason=%s progressEntity=%s holdCandidate=%s p3State=%s progress={present=%s turn=%s settled=%s localIntentValid=%s epoch=%s localIntentAge=%s heading=%s speed=%s phase=%s progress=%s} hold={present=%s turn=%s settled=%s speed=%s phase=%s progress=%s} release={observed=%s count=%d age=%s intentEpoch=%s} continuation={manoeuvreAt=%s manoeuvreEndedAt=%s conflictAt=%s} pair={distance=%s closing=%s tCPA=%s dCPA=%s confidenceState=%s positive=%s} thresholds={safeConfirm=%.1fs retention=%.1fs minSpeed=%.1fkm/h}",
        transition and "TRANSITION" or "SAMPLE",
        nowSeconds, tostring(trial.key), tostring(trial.state), tostring(reason or "periodic"),
        tostring(trial.progressName), tostring(trial.holdName), tostring(trial.p3State),
        tostring(progressState ~= nil), tostring(progressState ~= nil and progressState.isTurn == true),
        tostring(progressEntity ~= nil and progressEntity.settled == true),
        tostring(progressEntity ~= nil and progressEntity.intentValid == true),
        progressEntity ~= nil and tostring(progressEntity.intentEpoch) or "unknown",
        formatNumber(localAge, "%.2f", "s"),
        progressState ~= nil and formatNumber(progressState.heading, "%.1f", "deg") or "unknown",
        progressState ~= nil and formatNumber(progressState.actualSpeed, "%.2f", "km/h") or "unknown",
        progressState ~= nil and tostring(progressState.phase) or "unknown",
        progressState ~= nil and formatNumber(progressState.progress, "%.3f", "") or "unknown",
        tostring(holdState ~= nil), tostring(holdState ~= nil and holdState.isTurn == true),
        tostring(holdEntity ~= nil and holdEntity.settled == true),
        holdState ~= nil and formatNumber(holdState.actualSpeed, "%.2f", "km/h") or "unknown",
        holdState ~= nil and tostring(holdState.phase) or "unknown",
        holdState ~= nil and formatNumber(holdState.progress, "%.3f", "") or "unknown",
        tostring(trial.releaseAt ~= nil), trial.releaseCount or 0,
        formatNumber(releaseAge, "%.2f", "s"),
        trial.releaseIntentEpoch ~= nil and tostring(trial.releaseIntentEpoch) or "unknown",
        formatNumber(trial.continuationManoeuvreAt, "%.1f", "s"),
        formatNumber(trial.continuationManoeuvreEndedAt, "%.1f", "s"),
        formatNumber(trial.conflictAt, "%.1f", "s"),
        result ~= nil and formatNumber(result.distance, "%.2f", "m") or "unknown",
        result ~= nil and formatNumber(result.closing, "%.3f", "m/s") or "unknown",
        result ~= nil and formatNumber(result.tcpa, "%.2f", "s") or "unknown",
        result ~= nil and formatNumber(result.dcpa, "%.2f", "m") or "unknown",
        confidence ~= nil and tostring(confidence.state) or "unknown",
        tostring(confidence ~= nil and confidence.positive == true),
        OuttaMyWay.PROTOTYPE_04_SAFE_CONFIRM_S or 3.0,
        OuttaMyWay.PROTOTYPE_04_TRIAL_RETENTION_S or 120.0,
        OuttaMyWay.PROTOTYPE_04_MIN_OPERATIONAL_SPEED_KMH or 2.0)
end

function Probe:updateTrial(trial, stateByKey, nowSeconds, nowMs)
    local p1 = OuttaMyWay.ConflictEmergenceProbe
    local progressState = stateByKey[trial.progressKey]
    local holdState = stateByKey[trial.holdKey]
    local progressEntity = self.entities[trial.progressKey]
    local holdEntity = self.entities[trial.holdKey]
    local previousState = trial.state
    local reason = nil
    local result = nil
    local confidence = nil

    if progressState ~= nil and holdState ~= nil then
        result = p1.closestApproach(progressState, holdState)
        local _, pairConfidence = pairConflictPositive(progressState, holdState)
        confidence = pairConfidence
    end

    local holdPresent = holdState ~= nil and holdState.active == true
    local progressPresent = progressState ~= nil and progressState.active == true

    if trial.completed == true then
        local due = nowMs >= (trial.nextLogAtMs or 0)
        if due then
            self:logTrial(trial, progressEntity, holdEntity, progressState, holdState,
                result, confidence, nowSeconds, false, "completed-retained")
            trial.nextLogAtMs = nowMs + (OuttaMyWay.PROTOTYPE_04_LOG_INTERVAL_MS or 1000)
        end
        trial.lastSeenMs = nowMs
        return
    end

    if trial.holdPresent == true and not holdPresent then
        trial.holdPresent = false
        trial.holdDetachedAt = nowSeconds
        trial.state = "HOLD_ABSENT"
        reason = "hold-candidate-detached"
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 HOLD_ABSENCE_OBSERVED t=%.1fs key=%s progressEntity=%s holdCandidate=%s cause=external-or-native-worker-detach p3State=%s no-control-issued=true",
            nowSeconds, tostring(trial.key), tostring(trial.progressName), tostring(trial.holdName), tostring(trial.p3State))
    elseif trial.holdPresent ~= true and holdPresent then
        trial.holdPresent = true
        trial.releaseAt = nowSeconds
        trial.releaseCount = (trial.releaseCount or 0) + 1
        trial.releaseIntentEpoch = progressEntity ~= nil and progressEntity.intentValid and progressEntity.intentEpoch or nil
        trial.continuationManoeuvreAt = nil
        trial.continuationManoeuvreEndedAt = nil
        trial.conflictAt = nil
        trial.safeSince = nil
        trial.completed = false
        trial.completedAtMs = nil
        if progressEntity ~= nil and progressEntity.intentValid then
            trial.state = "RELEASE_WITH_LOCAL_INTENT"
            reason = "hold-candidate-returned-while-progress-local-intent-valid"
        else
            trial.state = "RELEASE_WITHOUT_CONTINUATION_INTENT"
            reason = "hold-candidate-returned-before-progress-intent-settled"
        end
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 RELEASE_OBSERVED t=%.1fs key=%s progressEntity=%s holdCandidate=%s releaseCount=%d progressIntentValid=%s progressIntentEpoch=%s progressTurn=%s holdTurn=%s source=worker-reattached no-release-issued=true",
            nowSeconds, tostring(trial.key), tostring(trial.progressName), tostring(trial.holdName),
            trial.releaseCount, tostring(progressEntity ~= nil and progressEntity.intentValid == true),
            trial.releaseIntentEpoch ~= nil and tostring(trial.releaseIntentEpoch) or "unknown",
            tostring(progressState ~= nil and progressState.isTurn == true), tostring(holdState.isTurn == true))
    end

    if progressEntity ~= nil and progressEntity.intentValid
        and trial.lastObservedIntentEpoch ~= progressEntity.intentEpoch then
        trial.lastObservedIntentEpoch = progressEntity.intentEpoch
        trial.localIntentAt = progressEntity.revealedAt
        if trial.releaseAt ~= nil then
            trial.state = "LOCAL_INTENT_AFTER_RELEASE"
            reason = "progress-local-intent-revealed-after-release"
        elseif not holdPresent then
            trial.state = "LOCAL_INTENT_WHILE_HOLD_ABSENT"
            reason = "progress-local-intent-revealed-while-hold-absent"
        else
            trial.state = "LOCAL_INTENT_VALID"
            reason = "progress-local-intent-revealed"
        end
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 LOCAL_INTENT_APPLIED_TO_TRIAL t=%.1fs key=%s progressEntity=%s holdCandidate=%s epoch=%d holdPresent=%s releaseObserved=%s scope=local intentMayExpireAtNextManoeuvre=true",
            nowSeconds, tostring(trial.key), tostring(trial.progressName), tostring(trial.holdName),
            progressEntity.intentEpoch or 0, tostring(holdPresent), tostring(trial.releaseAt ~= nil))
    end

    if progressEntity ~= nil and progressEntity.startedNow then
        trial.continuationManoeuvreAt = nowSeconds
        trial.continuationManoeuvreEndedAt = nil
        trial.safeSince = nil
        trial.state = "CONTINUATION_UNCERTAIN"
        reason = "progress-entity-started-next-manoeuvre"
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 CONTINUATION_MANOEUVRE_START t=%.1fs key=%s progressEntity=%s holdCandidate=%s releaseObserved=%s releaseAge=%s priorIntentEpoch=%s localIntentExpired=true continuationUnknown=true",
            nowSeconds, tostring(trial.key), tostring(trial.progressName), tostring(trial.holdName),
            tostring(trial.releaseAt ~= nil),
            trial.releaseAt ~= nil and formatNumber(nowSeconds - trial.releaseAt, "%.2f", "s") or "unknown",
            trial.lastObservedIntentEpoch ~= nil and tostring(trial.lastObservedIntentEpoch) or "unknown")
    elseif progressEntity ~= nil and progressEntity.endedNow
        and trial.continuationManoeuvreAt ~= nil
        and nowSeconds >= trial.continuationManoeuvreAt then
        trial.continuationManoeuvreEndedAt = nowSeconds
        trial.state = "CONTINUATION_SETTLING"
        reason = "progress-entity-ended-next-manoeuvre"
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 CONTINUATION_MANOEUVRE_END t=%.1fs key=%s progressEntity=%s duration=%.2fs conflictObserved=%s waitingForLocalSettlement=true",
            nowSeconds, tostring(trial.key), tostring(trial.progressName),
            nowSeconds - trial.continuationManoeuvreAt, tostring(trial.conflictAt ~= nil))
    end

    local positive = confidence ~= nil and confidence.positive == true
    if trial.releaseAt ~= nil and trial.continuationManoeuvreAt ~= nil and positive and trial.conflictAt == nil then
        trial.conflictAt = nowSeconds
        trial.state = "UNSAFE_THROUGH_NEXT_MANOEUVRE"
        trial.completed = true
        trial.completedAtMs = nowMs
        reason = "new-conflict-formed-during-next-progress-manoeuvre"
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 UNSAFE_CONTINUATION_OBSERVED t=%.1fs key=%s progressEntity=%s holdCandidate=%s releaseToNextManoeuvre=%.2fs nextManoeuvreToConflict=%.2fs releaseToConflict=%.2fs relation=%s dCPA=%s tCPA=%s confidenceState=%s encounterChainCandidate=true safeReleaseDisprovedForObservedTiming=true",
            nowSeconds, tostring(trial.key), tostring(trial.progressName), tostring(trial.holdName),
            trial.continuationManoeuvreAt - trial.releaseAt,
            nowSeconds - trial.continuationManoeuvreAt,
            nowSeconds - trial.releaseAt,
            result ~= nil and select(1, p1.relationship(progressState, holdState)) or "unknown",
            result ~= nil and formatNumber(result.dcpa, "%.2f", "m") or "unknown",
            result ~= nil and formatNumber(result.tcpa, "%.2f", "s") or "unknown",
            confidence ~= nil and tostring(confidence.state) or "unknown")
    elseif trial.releaseAt ~= nil
        and trial.continuationManoeuvreEndedAt ~= nil
        and progressEntity ~= nil and progressEntity.intentValid
        and holdPresent and progressPresent and not positive
        and trial.completed ~= true then
        trial.safeSince = trial.safeSince or nowSeconds
        if nowSeconds - trial.safeSince >= (OuttaMyWay.PROTOTYPE_04_SAFE_CONFIRM_S or 3.0) then
            trial.state = "SAFE_THROUGH_NEXT_MANOEUVRE"
            trial.completed = true
            trial.completedAtMs = nowMs
            reason = "next-manoeuvre-settled-and-pair-remained-clear"
            OuttaMyWay.Logger:val(
                "PROTOTYPE04 SAFE_CONTINUATION_CANDIDATE t=%.1fs key=%s progressEntity=%s holdCandidate=%s releaseToSafe=%.2fs nextManoeuvreDuration=%.2fs clearConfirm=%.2fs retrospectiveOnly=true",
                nowSeconds, tostring(trial.key), tostring(trial.progressName), tostring(trial.holdName),
                nowSeconds - trial.releaseAt,
                trial.continuationManoeuvreEndedAt - trial.continuationManoeuvreAt,
                nowSeconds - trial.safeSince)
        end
    elseif positive then
        trial.safeSince = nil
    end

    if not progressPresent and trial.completed ~= true then
        trial.state = "INCONCLUSIVE"
        trial.completed = true
        trial.completedAtMs = nowMs
        reason = "progress-entity-detached"
    end

    trial.lastSeenMs = nowMs
    local changed = previousState ~= trial.state
    local due = nowMs >= (trial.nextLogAtMs or 0)
    if changed or due then
        self:logTrial(trial, progressEntity, holdEntity, progressState, holdState,
            result, confidence, nowSeconds, changed, reason)
        trial.nextLogAtMs = nowMs + (OuttaMyWay.PROTOTYPE_04_LOG_INTERVAL_MS or 1000)
    end
end

function Probe:update(dt)
    if self.trials == nil then self:init() end
    if self.enabled ~= true then return end

    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_04_INTERVAL_MS or 250
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
    local seenEntities = {}

    for _, state in ipairs(states) do
        nowSeconds = math.max(nowSeconds, state.timestamp or 0)
        local key = p1.vehicleKey(state)
        local motion = p2.motionFor(state)
        stateByKey[key] = state
        self:updateEntity(state, motion, state.timestamp or nowSeconds)
        seenEntities[key] = true
    end

    self:markMissingEntities(seenEntities, nowSeconds)
    self:observePrototype03Windows(nowSeconds, nowMs)

    for _, trial in pairs(self.trials) do
        self:updateTrial(trial, stateByKey, nowSeconds, nowMs)
    end

    local retentionMs = (OuttaMyWay.PROTOTYPE_04_TRIAL_RETENTION_S or 120.0) * 1000
    for key, trial in pairs(self.trials) do
        local ageMs = nowMs - (trial.lastSeenMs or nowMs)
        local completedAgeMs = trial.completedAtMs ~= nil and nowMs - trial.completedAtMs or 0
        if ageMs > retentionMs or (trial.completed and completedAgeMs > retentionMs) then
            self.trials[key] = nil
        end
    end

    local heartbeat = OuttaMyWay.PROTOTYPE_04_HEARTBEAT_MS or 15000
    if nowMs - (self.lastHeartbeatMs or 0) >= heartbeat then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE04 HEARTBEAT t=%.1fs observedWorkers=%d trackedEntities=%d trackedTrials=%d passive=true localIntentExpiry=enabled safeReleaseAssessment=retrospective-only",
            nowSeconds, #states, countTable(self.entities), countTable(self.trials))
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.entities = {}
    self.trials = {}
    self.lastHeartbeatMs = 0
end
