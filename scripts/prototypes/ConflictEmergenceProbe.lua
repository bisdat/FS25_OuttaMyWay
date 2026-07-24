-- FS25_OuttaMyWay v4.6.5
-- Prototype 01: passive evidence capture for Conflict Emergence Point.
-- This module reads only the central Observer model and never controls vehicles.

OuttaMyWay.ConflictEmergenceProbe = OuttaMyWay.ConflictEmergenceProbe or {}
local Probe = OuttaMyWay.ConflictEmergenceProbe

local function countTable(values)
    local count = 0
    if type(values) == "table" then
        for _ in pairs(values) do count = count + 1 end
    end
    return count
end

local function vehicleKey(state)
    return tostring(state ~= nil and state.vehicle or "nil")
end

local function pairKey(a, b)
    local ak, bk = vehicleKey(a), vehicleKey(b)
    if ak > bk then ak, bk = bk, ak end
    return ak .. "|" .. bk
end

local function pairNames(a, b)
    local names = {a.name or "AI vehicle", b.name or "AI vehicle"}
    table.sort(names)
    return table.concat(names, " / ")
end

local function velocity(state)
    local speedMps = (state.actualSpeed or 0) / 3.6
    local heading = math.rad(state.heading or 0)
    return math.sin(heading) * speedMps, math.cos(heading) * speedMps
end

local function normalizeAngle(value)
    return (value + 180) % 360 - 180
end

local function relationship(a, b)
    local delta = math.abs(normalizeAngle((a.heading or 0) - (b.heading or 0)))
    if delta >= (OuttaMyWay.PROTOTYPE_01_HEAD_ON_MIN_DEG or 150) then
        return "HEAD_ON", delta
    end
    if delta <= (OuttaMyWay.PROTOTYPE_01_SAME_DIRECTION_MAX_DEG or 30) then
        return "SAME_DIRECTION", delta
    end
    return "CROSSING", delta
end

local function closestApproach(a, b)
    if a.x == nil or a.z == nil or b.x == nil or b.z == nil then return nil end

    local rx, rz = b.x - a.x, b.z - a.z
    local distance = math.sqrt(rx * rx + rz * rz)
    local avx, avz = velocity(a)
    local bvx, bvz = velocity(b)
    local rvx, rvz = bvx - avx, bvz - avz
    local relativeSpeedSq = rvx * rvx + rvz * rvz
    local closing = nil

    if distance > 0.01 then
        closing = -((rx * rvx + rz * rvz) / distance)
    end

    local result = {
        distance = distance,
        closing = closing,
        relativeSpeed = math.sqrt(relativeSpeedSq),
        avx = avx,
        avz = avz,
        bvx = bvx,
        bvz = bvz
    }

    if relativeSpeedSq < 0.0025 then return result end

    local tcpa = -((rx * rvx + rz * rvz) / relativeSpeedSq)
    local ax = a.x + avx * tcpa
    local az = a.z + avz * tcpa
    local bx = b.x + bvx * tcpa
    local bz = b.z + bvz * tcpa
    local dx, dz = bx - ax, bz - az

    result.tcpa = tcpa
    result.dcpa = math.sqrt(dx * dx + dz * dz)
    result.aCpaX = ax
    result.aCpaZ = az
    result.bCpaX = bx
    result.bCpaZ = bz
    result.zoneX = (ax + bx) * 0.5
    result.zoneZ = (az + bz) * 0.5
    return result
end

local function provisionalStage(a, b, result, previous)
    if result == nil then return "UNKNOWN" end

    local minClosing = OuttaMyWay.PROTOTYPE_01_MIN_CLOSING_RATE_MPS or 0.10
    local horizon = OuttaMyWay.PROTOTYPE_01_HORIZON_S or 60.0
    local relevanceDistance = OuttaMyWay.PROTOTYPE_01_RELEVANCE_CLEARANCE_M or 14.0
    local relevanceTime = OuttaMyWay.PROTOTYPE_01_RELEVANCE_TIME_S or 30.0
    local immediateDistance = OuttaMyWay.PROTOTYPE_01_IMMEDIATE_CLEARANCE_M or 7.0
    local immediateTime = OuttaMyWay.PROTOTYPE_01_IMMEDIATE_TIME_S or 10.0
    local lowSpeed = OuttaMyWay.PROTOTYPE_01_LOW_SPEED_KMH or 0.75

    local wasRelevant = previous ~= nil
        and (previous.stage == "CONFLICT_RELEVANT"
            or previous.stage == "IMMEDIATE_CONFLICT"
            or previous.stage == "ENCOUNTER_STALLED")

    if wasRelevant and (a.actualSpeed or 0) < lowSpeed and (b.actualSpeed or 0) < lowSpeed then
        return "ENCOUNTER_STALLED"
    end

    if result.tcpa == nil or (result.closing or 0) <= minClosing or result.tcpa < 0 then
        return wasRelevant and "RESOLVING" or "INDEPENDENT"
    end

    if result.tcpa > horizon then
        return wasRelevant and "RESOLVING" or "CONVERGING_OUTSIDE_HORIZON"
    end

    if result.dcpa ~= nil and result.dcpa <= immediateDistance and result.tcpa <= immediateTime then
        return "IMMEDIATE_CONFLICT"
    end

    if result.dcpa ~= nil and result.dcpa <= relevanceDistance and result.tcpa <= relevanceTime then
        return "CONFLICT_RELEVANT"
    end

    return wasRelevant and "RESOLVING" or "CONVERGING"
end

local function shouldTrack(result)
    if result == nil then return false end
    local radius = OuttaMyWay.PROTOTYPE_01_OBSERVATION_RADIUS_M or 300.0
    local horizon = OuttaMyWay.PROTOTYPE_01_HORIZON_S or 60.0
    return result.distance <= radius
        or (result.tcpa ~= nil and result.tcpa >= 0 and result.tcpa <= horizon)
end

-- Publish only the passive, side-effect-free kinematic helpers required by
-- later evidence probes. Prototype 01 remains the owner of its stage labels.
Probe.vehicleKey = vehicleKey
Probe.pairKey = pairKey
Probe.pairNames = pairNames
Probe.relationship = relationship
Probe.closestApproach = closestApproach
Probe.shouldTrack = shouldTrack

function Probe:init()
    self.elapsedMs = 0
    self.pairs = {}
    self.lastHeartbeatMs = 0
    self.enabled = OuttaMyWay.PROTOTYPE_01_ENABLED == true

    local observerOnly = OuttaMyWay.AI_EXPLORER_ONLY == true
    local trafficDisabled = OuttaMyWay.TRAFFIC_V2_ENABLED ~= true
    local passive = observerOnly and trafficDisabled

    OuttaMyWay.Logger:info(
        "PROTOTYPE 01 ACTIVE: Conflict Emergence Point evidence capture enabled=%s passive=%s observerOnly=%s trafficV2Enabled=%s no vehicle control",
        tostring(self.enabled), tostring(passive), tostring(observerOnly), tostring(OuttaMyWay.TRAFFIC_V2_ENABLED == true))

    if self.enabled and not passive then
        OuttaMyWay.Logger:error("VAL",
            "PROTOTYPE 01 PASSIVE GUARANTEE FAILED: AI_EXPLORER_ONLY must be true and TRAFFIC_V2_ENABLED must be false")
        self.enabled = false
    end
end

function Probe:logSample(a, b, result, state, previous, transition)
    local relation, headingDelta = relationship(a, b)
    OuttaMyWay.Logger:val(
        "PROTOTYPE01 %s t=%.1fs pair=%s stage=%s previous=%s relation=%s headingDelta=%.1fdeg distance=%.2fm closing=%s tCPA=%s dCPA=%s zone=%s A={name=%s pos=(%.2f,%.2f) heading=%.1f speed=%.2f phase=%s turn=%s blocked=%s} B={name=%s pos=(%.2f,%.2f) heading=%.1f speed=%.2f phase=%s turn=%s blocked=%s} thresholds={horizon=%.1fs relevance=%.1fm/%.1fs immediate=%.1fm/%.1fs}",
        transition and "TRANSITION" or "SAMPLE",
        state.timestamp or 0,
        pairNames(a, b),
        state.stage,
        previous ~= nil and previous.stage or "none",
        relation,
        headingDelta,
        result.distance or -1,
        result.closing ~= nil and string.format("%.3fm/s", result.closing) or "unknown",
        result.tcpa ~= nil and string.format("%.2fs", result.tcpa) or "unknown",
        result.dcpa ~= nil and string.format("%.2fm", result.dcpa) or "unknown",
        result.zoneX ~= nil and string.format("(%.2f,%.2f)", result.zoneX, result.zoneZ) or "unknown",
        a.name or "AI vehicle", a.x or 0, a.z or 0, a.heading or 0, a.actualSpeed or 0,
        tostring(a.phase), tostring(a.isTurn == true), tostring(a.blocked == true),
        b.name or "AI vehicle", b.x or 0, b.z or 0, b.heading or 0, b.actualSpeed or 0,
        tostring(b.phase), tostring(b.isTurn == true), tostring(b.blocked == true),
        OuttaMyWay.PROTOTYPE_01_HORIZON_S or 60.0,
        OuttaMyWay.PROTOTYPE_01_RELEVANCE_CLEARANCE_M or 14.0,
        OuttaMyWay.PROTOTYPE_01_RELEVANCE_TIME_S or 30.0,
        OuttaMyWay.PROTOTYPE_01_IMMEDIATE_CLEARANCE_M or 7.0,
        OuttaMyWay.PROTOTYPE_01_IMMEDIATE_TIME_S or 10.0)
end

function Probe:updatePair(a, b, nowSeconds, nowMs)
    local key = pairKey(a, b)
    local previous = self.pairs[key]
    local result = closestApproach(a, b)

    if not shouldTrack(result) then
        if previous ~= nil then
            OuttaMyWay.Logger:val(
                "PROTOTYPE01 PAIR_EXIT t=%.1fs pair=%s previous=%s distance=%.2fm reason=outside-observation",
                nowSeconds, pairNames(a, b), tostring(previous.stage), result ~= nil and result.distance or -1)
            self.pairs[key] = nil
        end
        return false
    end

    local stage = provisionalStage(a, b, result, previous)
    local state = {
        key = key,
        timestamp = nowSeconds,
        stage = stage,
        lastSeenMs = nowMs,
        nextLogAtMs = previous ~= nil and previous.nextLogAtMs or 0
    }

    local changed = previous == nil or previous.stage ~= stage
    local due = nowMs >= (state.nextLogAtMs or 0)
    if changed or due then
        self:logSample(a, b, result, state, previous, changed)
        state.nextLogAtMs = nowMs + (OuttaMyWay.PROTOTYPE_01_LOG_INTERVAL_MS or 2000)
    end

    if changed and (stage == "CONFLICT_RELEVANT" or stage == "IMMEDIATE_CONFLICT") then
        OuttaMyWay.Logger:val(
            "PROTOTYPE01 CONFLICT_EMERGENCE_POINT t=%.1fs pair=%s distance=%.2fm tCPA=%.2fs dCPA=%.2fm confidenceBasis=constant-velocity relationship=%s",
            nowSeconds, pairNames(a, b), result.distance or -1, result.tcpa or -1, result.dcpa or -1,
            select(1, relationship(a, b)))
    end

    self.pairs[key] = state
    return true
end

function Probe:update(dt)
    if self.pairs == nil then self:init() end
    if self.enabled ~= true then return end

    self.elapsedMs = self.elapsedMs + dt
    local interval = OuttaMyWay.PROTOTYPE_01_INTERVAL_MS or 500
    if self.elapsedMs < interval then return end
    self.elapsedMs = self.elapsedMs % interval

    local observer = OuttaMyWay.Observer
    local observed = observer ~= nil and observer.states or nil
    if type(observed) ~= "table" then return end

    local states = {}
    for _, state in pairs(observed) do
        if state ~= nil and state.active == true and state.x ~= nil and state.z ~= nil then
            states[#states + 1] = state
        end
    end
    table.sort(states, function(a, b) return vehicleKey(a) < vehicleKey(b) end)

    local seen = {}
    local nowMs = g_time or 0
    local nowSeconds = 0
    if #states > 0 then nowSeconds = states[1].timestamp or 0 end

    for i = 1, #states - 1 do
        for j = i + 1, #states do
            local a, b = states[i], states[j]
            nowSeconds = math.max(nowSeconds, a.timestamp or 0, b.timestamp or 0)
            local key = pairKey(a, b)
            if self:updatePair(a, b, nowSeconds, nowMs) then seen[key] = true end
        end
    end

    for key, state in pairs(self.pairs) do
        if not seen[key] then
            OuttaMyWay.Logger:val(
                "PROTOTYPE01 PAIR_ENDED t=%.1fs key=%s previous=%s reason=worker-detached-or-no-longer-observed",
                nowSeconds, tostring(key), tostring(state.stage))
            self.pairs[key] = nil
        end
    end

    local heartbeat = OuttaMyWay.PROTOTYPE_01_HEARTBEAT_MS or 15000
    if nowMs - (self.lastHeartbeatMs or 0) >= heartbeat then
        self.lastHeartbeatMs = nowMs
        OuttaMyWay.Logger:val(
            "PROTOTYPE01 HEARTBEAT t=%.1fs observedWorkers=%d trackedPairs=%d passive=true",
            nowSeconds, #states, countTable(self.pairs))
    end
end

function Probe:clear()
    self.elapsedMs = 0
    self.pairs = {}
    self.lastHeartbeatMs = 0
end
