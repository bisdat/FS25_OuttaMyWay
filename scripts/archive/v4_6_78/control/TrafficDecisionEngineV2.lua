-- FS25_OuttaMyWay v4.2.5.2
-- Pure decision consumer for Observer-era traffic prediction.
-- Produces recommendations; TrafficExecutorV2 owns all GIANTS AI mutation.
OuttaMyWay.TrafficDecisionEngineV2 = OuttaMyWay.TrafficDecisionEngineV2 or {}
local Engine = OuttaMyWay.TrafficDecisionEngineV2

local function nameOf(state)
    return state ~= nil and (state.name or "AI vehicle") or "AI vehicle"
end

local function isUsable(state)
    return state ~= nil
        and state.vehicle ~= nil
        and state.active == true
        and state.blocked ~= true
        and state.phase == "WORKING"
        and state.isTurn ~= true
end

local function chooseYielding(a, b)
    local ap = tonumber(a.progress) or 0
    local bp = tonumber(b.progress) or 0
    if math.abs(ap - bp) > 0.01 then
        if ap < bp then return a, b, "lower-segment-progress" end
        return b, a, "lower-segment-progress"
    end

    if tostring(a.vehicle) < tostring(b.vehicle) then
        return a, b, "stable-vehicle-order"
    end
    return b, a, "stable-vehicle-order"
end

function Engine:init()
    self.recommendations = {}
    self.lastLogged = {}
    self.lastHeartbeat = 0
    print("Info: [FS25_OuttaMyWay] TRAFFIC DECISION V2 ACTIVE: live recommendations for executor")
end

function Engine:evaluate(prediction)
    if prediction == nil or prediction.key == nil then return nil end
    if prediction.classification ~= "CRITICAL" then return nil end
    if (prediction.confidence or 0) < (OuttaMyWay.TRAFFIC_V2_MIN_CONFIDENCE or 0.80) then return nil end

    local a, b = prediction.a, prediction.b
    if not isUsable(a) or not isUsable(b) then return nil end

    local yielding, priority, reason = chooseYielding(a, b)
    return {
        key = prediction.key,
        contextId = prediction.contextId,
        timestamp = prediction.timestamp or 0,
        action = "HOLD",
        yielding = yielding,
        priority = priority,
        confidence = prediction.confidence or 0,
        timeToClosest = prediction.timeToClosest,
        closestDistance = prediction.closestDistance,
        reason = reason,
        sourceClassification = prediction.classification
    }
end

function Engine:update(dt)
    if self.recommendations == nil then self:init() end

    local predictorStates = OuttaMyWay.ConflictPredictor ~= nil and OuttaMyWay.ConflictPredictor.pairs or nil
    local nextRecommendations = {}

    if type(predictorStates) == "table" then
        for key, prediction in pairs(predictorStates) do
            local recommendation = self:evaluate(prediction)
            if recommendation ~= nil then
                nextRecommendations[key] = recommendation
                local signature = table.concat({
                    tostring(recommendation.action),
                    tostring(recommendation.yielding.vehicle),
                    tostring(recommendation.priority.vehicle),
                    string.format("%.2f", recommendation.confidence)
                }, "|")

                if self.lastLogged[key] ~= signature then
                    self.lastLogged[key] = signature
                    print(string.format(
                        "Info: [FS25_OuttaMyWay] TRAFFIC V2 WOULD HOLD t=%.1fs context=%s hold=%s priority=%s confidence=%.2f tCPA=%s dCPA=%s reason=%s progress=%.3f/%.3f",
                        recommendation.timestamp,
                        tostring(recommendation.contextId),
                        nameOf(recommendation.yielding),
                        nameOf(recommendation.priority),
                        recommendation.confidence,
                        recommendation.timeToClosest ~= nil and string.format("%.1fs", recommendation.timeToClosest) or "unknown",
                        recommendation.closestDistance ~= nil and string.format("%.1fm", recommendation.closestDistance) or "unknown",
                        tostring(recommendation.reason),
                        tonumber(recommendation.yielding.progress) or -1,
                        tonumber(recommendation.priority.progress) or -1))
                end
            else
                self.lastLogged[key] = nil
            end
        end
    end

    self.recommendations = nextRecommendations

    local nowMs = g_time or 0
    if nowMs - (self.lastHeartbeat or 0) >= (OuttaMyWay.TRAFFIC_V2_HEARTBEAT_MS or 15000) then
        self.lastHeartbeat = nowMs
        local count = 0
        for _ in pairs(self.recommendations) do count = count + 1 end
        print(string.format("Info: [FS25_OuttaMyWay] TRAFFIC DECISION V2 HEARTBEAT recommendations=%d", count))
    end
end
