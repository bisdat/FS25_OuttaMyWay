-- FS25_OuttaMyWay v4.2.4.0
-- Diagnostic-only conflict consumer for ACTIVE interaction contexts.
-- Uses current observed velocity to estimate closest approach. It never
-- controls speed, steering, implements, priority or AI state.
OuttaMyWay.ConflictPredictor = OuttaMyWay.ConflictPredictor or {}
local Predictor = OuttaMyWay.ConflictPredictor

local function clamp(value, minimum, maximum)
    return math.max(minimum, math.min(maximum, value))
end

local function velocity(state)
    local speedMps = (state.actualSpeed or 0) / 3.6
    local heading = math.rad(state.heading or 0)
    return math.sin(heading) * speedMps, math.cos(heading) * speedMps
end

local function normalizeAngle(value)
    value = (value + 180) % 360 - 180
    return value
end

local function headingDifference(a, b)
    return math.abs(normalizeAngle((a.heading or 0) - (b.heading or 0)))
end

local function lateralOffset(origin, target)
    if origin.x == nil or origin.z == nil or target.x == nil or target.z == nil then return nil end
    local heading = math.rad(origin.heading or 0)
    local rightX, rightZ = math.cos(heading), -math.sin(heading)
    local dx, dz = target.x - origin.x, target.z - origin.z
    return math.abs(dx * rightX + dz * rightZ)
end

local function closestApproach(a, b, horizon)
    if a.x == nil or a.z == nil or b.x == nil or b.z == nil then return nil end

    local rx, rz = b.x - a.x, b.z - a.z
    local currentDistance = math.sqrt(rx * rx + rz * rz)
    local avx, avz = velocity(a)
    local bvx, bvz = velocity(b)
    local rvx, rvz = bvx - avx, bvz - avz
    local relativeSpeedSq = rvx * rvx + rvz * rvz

    local closing = nil
    if currentDistance > 0.01 then
        closing = -((rx * rvx + rz * rvz) / currentDistance)
    end

    if relativeSpeedSq < 0.0025 then
        return {
            distance=currentDistance,
            closing=closing,
            timeToClosest=nil,
            closestDistance=currentDistance
        }
    end

    local rawTime = -((rx * rvx + rz * rvz) / relativeSpeedSq)
    local timeToClosest = clamp(rawTime, 0, horizon)
    local cx, cz = rx + rvx * timeToClosest, rz + rvz * timeToClosest

    return {
        distance=currentDistance,
        closing=closing,
        rawTimeToClosest=rawTime,
        timeToClosest=timeToClosest,
        closestDistance=math.sqrt(cx * cx + cz * cz)
    }
end

local function pairKey(context, a, b)
    local av, bv = tostring(a.vehicle), tostring(b.vehicle)
    if av > bv then av, bv = bv, av end
    return string.format("%s:%s|%s", tostring(context.id), av, bv)
end

local function pairNames(a, b)
    local names = {a.name or "AI vehicle", b.name or "AI vehicle"}
    table.sort(names)
    return table.concat(names, ", ")
end

local function confidence(a, b)
    if a.blocked or b.blocked then return 1.0, "blocked" end
    if a.isTurn and b.isTurn then return 0.35, "both-turning" end
    if a.isTurn or b.isTurn then return 0.55, "one-turning" end
    if (a.actualSpeed or 0) < 0.75 or (b.actualSpeed or 0) < 0.75 then return 0.50, "low-speed" end
    return 0.85, "both-straight"
end

function Predictor:classify(a, b, result)
    if result == nil then return "UNKNOWN", 0, "missing-position" end

    local confidenceValue, confidenceReason = confidence(a, b)
    local closing = result.closing or 0
    local t = result.rawTimeToClosest
    local d = result.closestDistance or math.huge
    local horizon = OuttaMyWay.CONFLICT_PREDICTOR_HORIZON_S or 30.0

    if t == nil or t < 0 or t > horizon or closing <= 0 then
        return "CLEAR", confidenceValue, confidenceReason
    end

    if d <= (OuttaMyWay.CONFLICT_PREDICTOR_CRITICAL_DISTANCE_M or 7.0)
        and t <= (OuttaMyWay.CONFLICT_PREDICTOR_CRITICAL_TIME_S or 10.0) then
        return "CRITICAL", confidenceValue, confidenceReason
    end

    if d <= (OuttaMyWay.CONFLICT_PREDICTOR_POTENTIAL_DISTANCE_M or 14.0)
        and t <= (OuttaMyWay.CONFLICT_PREDICTOR_POTENTIAL_TIME_S or 22.0) then
        return "POTENTIAL", confidenceValue, confidenceReason
    end

    if d <= (OuttaMyWay.CONFLICT_PREDICTOR_WATCH_DISTANCE_M or 28.0) then
        return "WATCH", confidenceValue, confidenceReason
    end

    return "CLEAR", confidenceValue, confidenceReason
end

function Predictor:init()
    self.elapsed = 0
    self.pairs = {}
    self.lastHeartbeat = 0
    print("Info: [FS25_OuttaMyWay] CONFLICT PREDICTOR ACTIVE: diagnostic closest-approach consumer, no vehicle control")
end

function Predictor:logTransition(context, a, b, state, previous)
    print(string.format(
        "Info: [FS25_OuttaMyWay] CONFLICT PREDICTOR %s t=%.1fs context=%d members=%s distance=%.1fm closing=%s tCPA=%s dCPA=%.1fm headingDelta=%.1f lateralAB=%s lateralBA=%s confidence=%.2f reason=%s phases=%s/%s turns=%s/%s previous=%s",
        state.classification,
        state.timestamp,
        context.id,
        pairNames(a,b),
        state.distance or -1,
        state.closing ~= nil and string.format("%.2fm/s", state.closing) or "unknown",
        state.timeToClosest ~= nil and string.format("%.1fs", state.timeToClosest) or "unknown",
        state.closestDistance or -1,
        state.headingDifference or -1,
        state.lateralAB ~= nil and string.format("%.1fm", state.lateralAB) or "unknown",
        state.lateralBA ~= nil and string.format("%.1fm", state.lateralBA) or "unknown",
        state.confidence or 0,
        state.confidenceReason or "unknown",
        tostring(a.phase), tostring(b.phase),
        tostring(a.isTurn), tostring(b.isTurn),
        previous ~= nil and tostring(previous.classification) or "none"))
end

function Predictor:updatePair(context, a, b, now)
    local horizon = OuttaMyWay.CONFLICT_PREDICTOR_HORIZON_S or 30.0
    local result = closestApproach(a, b, horizon)
    local classification, confidenceValue, confidenceReason = self:classify(a, b, result)
    local key = pairKey(context, a, b)
    local previous = self.pairs[key]

    local state = {
        key=key,
        contextId=context.id,
        a=a,
        b=b,
        timestamp=now,
        classification=classification,
        confidence=confidenceValue,
        confidenceReason=confidenceReason,
        distance=result ~= nil and result.distance or nil,
        closing=result ~= nil and result.closing or nil,
        timeToClosest=result ~= nil and result.rawTimeToClosest or nil,
        closestDistance=result ~= nil and result.closestDistance or nil,
        headingDifference=headingDifference(a,b),
        lateralAB=lateralOffset(a,b),
        lateralBA=lateralOffset(b,a),
        lastSeen=now
    }

    local logInterval = OuttaMyWay.CONFLICT_PREDICTOR_ACTIVE_LOG_INTERVAL_S or 3.0
    local changed = previous == nil or previous.classification ~= classification
    local due = classification ~= "CLEAR" and (previous == nil or now - (previous.lastLogged or -math.huge) >= logInterval)

    if changed or due then
        self:logTransition(context, a, b, state, previous)
        state.lastLogged = now
    elseif previous ~= nil then
        state.lastLogged = previous.lastLogged
    end

    self.pairs[key] = state

    if changed and OuttaMyWay.EventBus ~= nil then
        OuttaMyWay.EventBus:emit("conflictPredictionChanged", {current=state, previous=previous, context=context, timestamp=now})
    end
end

function Predictor:update(dt)
    if self.pairs == nil then self:init() end
    self.elapsed = self.elapsed + dt
    local interval = OuttaMyWay.CONFLICT_PREDICTOR_INTERVAL_MS or 500
    if self.elapsed < interval then return end
    self.elapsed = self.elapsed % interval

    local contexts = OuttaMyWay.InteractionContexts ~= nil and OuttaMyWay.InteractionContexts.contexts or nil
    if contexts == nil then return end

    local seen = {}
    local now = 0
    local activeContexts = 0
    local activePairs = 0

    for _, context in pairs(contexts) do
        if context.status == "ACTIVE" and type(context.members) == "table" then
            activeContexts = activeContexts + 1
            for i=1,#context.members-1 do
                for j=i+1,#context.members do
                    local a, b = context.members[i], context.members[j]
                    now = math.max(now, a.timestamp or 0, b.timestamp or 0)
                    local key = pairKey(context,a,b)
                    seen[key] = true
                    activePairs = activePairs + 1
                    self:updatePair(context,a,b,now)
                end
            end
        end
    end

    local retention = OuttaMyWay.CONFLICT_PREDICTOR_RETENTION_S or 15.0
    for key,state in pairs(self.pairs) do
        if not seen[key] and now - (state.lastSeen or now) > retention then
            self.pairs[key] = nil
        end
    end

    local heartbeatMs = OuttaMyWay.CONFLICT_PREDICTOR_HEARTBEAT_MS or 15000
    if (g_time or 0) - (self.lastHeartbeat or 0) >= heartbeatMs then
        self.lastHeartbeat = g_time or 0
        local watch,potential,critical = 0,0,0
        for _,state in pairs(self.pairs) do
            if state.classification == "WATCH" then watch=watch+1
            elseif state.classification == "POTENTIAL" then potential=potential+1
            elseif state.classification == "CRITICAL" then critical=critical+1 end
        end
        print(string.format(
            "Info: [FS25_OuttaMyWay] CONFLICT PREDICTOR HEARTBEAT t=%.1fs activeContexts=%d activePairs=%d watch=%d potential=%d critical=%d trackedPairs=%d",
            now, activeContexts, activePairs, watch, potential, critical,
            (function() local n=0 for _ in pairs(self.pairs) do n=n+1 end return n end)()))
    end
end
