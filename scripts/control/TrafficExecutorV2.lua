-- FS25_OuttaMyWay v4.2.6.3
-- Traffic Manager v2 executor using GIANTS' native field-worker permission gate.
OuttaMyWay.TrafficExecutorV2 = OuttaMyWay.TrafficExecutorV2 or {}
local Executor = OuttaMyWay.TrafficExecutorV2

local function nameOf(state)
    return state ~= nil and (state.name or "AI vehicle") or "AI vehicle"
end

local function countTable(values)
    local count = 0
    if type(values) == "table" then
        for _ in pairs(values) do count = count + 1 end
    end
    return count
end

local function isVehicleUsable(state)
    return state ~= nil and state.vehicle ~= nil and state.active == true
end

function Executor:init()
    self.activeHolds = {}
    self.lastHeartbeat = 0
    OuttaMyWay.Logger:info("Traffic Executor v2 active: native AI permission gate")
end

function Executor:startHold(recommendation, nowMs)
    if recommendation == nil or recommendation.key == nil then return end
    if self.activeHolds[recommendation.key] ~= nil then return end
    if OuttaMyWay.RecoveryHandoff ~= nil and OuttaMyWay.RecoveryHandoff.isSuppressed ~= nil
        and OuttaMyWay.RecoveryHandoff:isSuppressed(recommendation.key) then return end
    if not isVehicleUsable(recommendation.yielding) or not isVehicleUsable(recommendation.priority) then return end

    local vehicle = recommendation.yielding.vehicle
    local priorityVehicle = recommendation.priority.vehicle
    local gate = OuttaMyWay.TrafficPermissionGate
    if gate == nil or gate.setHold == nil then
        OuttaMyWay.Logger:warning("REC", "Traffic v2 hold unavailable: permission gate missing")
        return
    end

    local ok, reason = gate:setHold(vehicle, recommendation.contextId, priorityVehicle, nowMs)
    if not ok then
        OuttaMyWay.Logger:warning("REC", "TRAFFIC V2 HOLD failed context=%s vehicle=%s reason=%s",
            tostring(recommendation.contextId), nameOf(recommendation.yielding), tostring(reason))
        return
    end

    local minHoldMs = OuttaMyWay.TRAFFIC_V2_MIN_HOLD_MS or 3000
    local maxHoldMs = OuttaMyWay.TRAFFIC_V2_MAX_HOLD_MS or 15000
    self.activeHolds[recommendation.key] = {
        key = recommendation.key,
        contextId = recommendation.contextId,
        yielding = recommendation.yielding,
        priority = recommendation.priority,
        startedAt = nowMs,
        committedUntil = nowMs + minHoldMs,
        timeoutAt = nowMs + maxHoldMs,
        clearSince = nil,
        lastClassification = recommendation.sourceClassification,
        recommendation = recommendation,
        nextProbeAt = nowMs,
        probeIndex = 0
    }

    OuttaMyWay.Logger:ctl("Traffic v2 hold start t=%.1fs context=%s hold=%s priority=%s confidence=%.2f tCPA=%s dCPA=%s reason=%s executor=permission-gate minHold=%.1fs maxHold=%.1fs",
        recommendation.timestamp or 0, tostring(recommendation.contextId),
        nameOf(recommendation.yielding), nameOf(recommendation.priority),
        recommendation.confidence or 0,
        recommendation.timeToClosest ~= nil and string.format("%.1fs", recommendation.timeToClosest) or "unknown",
        recommendation.closestDistance ~= nil and string.format("%.1fm", recommendation.closestDistance) or "unknown",
        tostring(recommendation.reason), minHoldMs / 1000, maxHoldMs / 1000)
end

function Executor:releaseHold(key, reason, nowMs)
    local hold = self.activeHolds[key]
    if hold == nil then return end

    local vehicle = hold.yielding ~= nil and hold.yielding.vehicle or nil
    local gate = OuttaMyWay.TrafficPermissionGate
    local calls = gate ~= nil and gate.getCallCount ~= nil and gate:getCallCount(vehicle) or 0
    local nativeHold = gate ~= nil and gate.releaseHold ~= nil and gate:releaseHold(vehicle) or nil

    OuttaMyWay.Logger:val("Traffic v2 hold release t=%.1fs context=%s hold=%s priority=%s held=%.1fs reason=%s lastPrediction=%s gateCalls=%d gateFirstAt=%s",
        (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or (nowMs / 1000),
        tostring(hold.contextId), nameOf(hold.yielding), nameOf(hold.priority),
        math.max(0, nowMs - (hold.startedAt or nowMs)) / 1000,
        tostring(reason), tostring(hold.lastClassification), calls,
        nativeHold ~= nil and nativeHold.firstGateAt ~= nil and string.format("%.3fs", nativeHold.firstGateAt / 1000) or "nil")

    self.activeHolds[key] = nil
end

function Executor:handoffToPlayer(key, reason, nowMs)
    local hold = self.activeHolds[key]
    if hold == nil then return end

    local vehicle = hold.yielding ~= nil and hold.yielding.vehicle or nil
    local gate = OuttaMyWay.TrafficPermissionGate
    if gate ~= nil and gate.releaseHold ~= nil then gate:releaseHold(vehicle) end

    self.activeHolds[key] = nil
    if OuttaMyWay.RecoveryHandoff ~= nil and OuttaMyWay.RecoveryHandoff.begin ~= nil then
        OuttaMyWay.RecoveryHandoff:begin(hold, reason, nowMs)
    else
        OuttaMyWay.Logger:warning("REC", "RECOVERY HANDOFF TO PLAYER incident=%s context=%s vehicle=%s reason=%s",
            tostring(key), tostring(hold.contextId), nameOf(hold.yielding), tostring(reason))
    end
end

function Executor:updateHold(key, hold, nowMs)
    local yielding = hold.yielding
    local priority = hold.priority
    local prediction = OuttaMyWay.ConflictPredictor ~= nil
        and OuttaMyWay.ConflictPredictor.pairs ~= nil
        and OuttaMyWay.ConflictPredictor.pairs[key] or nil
    local gate = OuttaMyWay.TrafficPermissionGate

    if not isVehicleUsable(yielding) or not isVehicleUsable(priority) then
        self:releaseHold(key, "AI inactive", nowMs)
        return
    end
    if yielding.blocked == true or priority.blocked == true then
        self:handoffToPlayer(key, "native-blocked-after-automated-hold", nowMs)
        return
    end
    if nowMs >= (hold.timeoutAt or nowMs) then
        self:handoffToPlayer(key, "automated-hold-timeout", nowMs)
        return
    end
    if gate == nil or gate.isHolding == nil or not gate:isHolding(yielding.vehicle) then
        self.activeHolds[key] = nil
        OuttaMyWay.Logger:warning("REC", "TRAFFIC V2 HOLD LOST context=%s vehicle=%s",
            tostring(hold.contextId), nameOf(yielding))
        return
    end

    if prediction ~= nil then
        hold.lastClassification = prediction.classification or hold.lastClassification
    end

    if nowMs >= (hold.nextProbeAt or 0) then
        hold.probeIndex = (hold.probeIndex or 0) + 1
        hold.nextProbeAt = nowMs + ((nowMs - hold.startedAt) < 4000 and 500 or 1000)
        local current = OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.states ~= nil
            and OuttaMyWay.Observer.states[yielding.vehicle] or nil
        if current ~= nil then
            hold.yielding = current
            yielding = current
        end
        OuttaMyWay.Logger:val("Traffic v2 gate probe t=%.3fs context=%s probe=%d vehicle=%s phase=%s actual=%.2f progress=%s blocked=%s gateHolding=%s gateCalls=%d",
            (OuttaMyWay.Observer ~= nil and OuttaMyWay.Observer.elapsedSeconds) or nowMs / 1000,
            tostring(hold.contextId), hold.probeIndex, nameOf(yielding), tostring(yielding.phase),
            tonumber(yielding.actualSpeed) or 0,
            yielding.progress ~= nil and string.format("%.4f", yielding.progress) or "nil",
            tostring(yielding.blocked == true), tostring(gate:isHolding(yielding.vehicle)),
            gate:getCallCount(yielding.vehicle))
    end

    if nowMs < (hold.committedUntil or 0) then
        hold.clearSince = nil
        return
    end

    local clear = prediction ~= nil
        and prediction.classification == "CLEAR"
        and (prediction.closingRate or 0) <= 0
        and prediction.blocked ~= true

    if clear then
        hold.clearSince = hold.clearSince or nowMs
        if nowMs - hold.clearSince >= (OuttaMyWay.TRAFFIC_V2_CLEAR_CONFIRM_MS or 1200) then
            self:releaseHold(key, "clearance confirmed", nowMs)
        end
    else
        hold.clearSince = nil
    end
end

function Executor:update(dt)
    if self.activeHolds == nil then self:init() end
    local nowMs = g_time or 0
    local recommendations = OuttaMyWay.TrafficDecisionEngineV2 ~= nil
        and OuttaMyWay.TrafficDecisionEngineV2.recommendations or nil

    if type(recommendations) == "table" then
        for key, recommendation in pairs(recommendations) do
            if self.activeHolds[key] == nil then self:startHold(recommendation, nowMs) end
        end
    end

    local keys = {}
    for key in pairs(self.activeHolds) do keys[#keys + 1] = key end
    for _, key in ipairs(keys) do
        local hold = self.activeHolds[key]
        if hold ~= nil then self:updateHold(key, hold, nowMs) end
    end

    if nowMs - (self.lastHeartbeat or 0) >= (OuttaMyWay.TRAFFIC_V2_HEARTBEAT_MS or 15000) then
        self.lastHeartbeat = nowMs
        OuttaMyWay.Logger:val("Traffic Executor v2 heartbeat execution=permission-gate activeHolds=%d recommendations=%d",
            countTable(self.activeHolds), countTable(recommendations))
    end
end
