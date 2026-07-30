-- FS25_OuttaMyWay vector prediction.
-- Vehicle-agnostic constant-velocity prediction and diagnostic reporting.

local function vectorLog(text, ...)
    if OuttaMyWay.isDebugEnabled ~= nil and not OuttaMyWay:isDebugEnabled("vector") then return end
    Logging.info("[%s] %s", OuttaMyWay.MOD_NAME, string.format(text, ...))
end

local function vehicleName(vehicle)
    if vehicle ~= nil and vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil and name ~= "" then return name end
    end
    return "AI vehicle"
end

local function predictionPairKey(a, b)
    local ka, kb = tostring(a.vehicle), tostring(b.vehicle)
    if ka > kb then ka, kb = kb, ka end
    return ka .. ":" .. kb
end

function OuttaMyWay:buildWorkerProfile(data)
    local workingWidth = math.max(self.MIN_WORKING_WIDTH or 0,
        math.min(self.MAX_WORKING_WIDTH or math.huge,
            data.workingWidth or self.DEFAULT_WORKING_WIDTH or 6))
    local halfWidth = workingWidth * 0.5

    return {
        vehicle = data.vehicle,
        name = vehicleName(data.vehicle),
        fieldId = data.fieldId or 0,
        x = data.x or 0,
        z = data.z or 0,
        headingX = data.dx or 0,
        headingZ = data.dz or 0,
        speedMps = data.speedMps or 0,
        speedKmh = data.speedKmh or 0,
        turnFactor = data.turnFactor or 0,
        workingWidth = workingWidth,
        leftExtent = data.leftExtent or halfWidth,
        rightExtent = data.rightExtent or halfWidth,
        vehicleLength = data.vehicleLength or data.length or self.DEFAULT_VEHICLE_LENGTH,
        lateralOffset = data.lateralOffset or 0,
        reversing = data.reversing == true,
        capabilities = data.capabilities or {
            canSlow = true,
            canStop = true,
            canReverse = true,
            canRaise = false,
            canFold = false
        }
    }
end

function OuttaMyWay:getPredictionClearance(a, b)
    -- Centred tools use half working width A + half working width B.
    -- Separate left/right extents make this API ready for offset tools later.
    return math.max(a.leftExtent or 0, a.rightExtent or 0)
        + math.max(b.leftExtent or 0, b.rightExtent or 0)
end

function OuttaMyWay:predictWorkerPair(a, b)
    local rx, rz = b.x-a.x, b.z-a.z
    local currentDistance = math.sqrt(rx*rx + rz*rz)
    local vax, vaz = a.headingX*a.speedMps, a.headingZ*a.speedMps
    local vbx, vbz = b.headingX*b.speedMps, b.headingZ*b.speedMps
    local rvx, rvz = vbx-vax, vbz-vaz
    local rv2 = rvx*rvx + rvz*rvz
    local required = self:getPredictionClearance(a, b)

    local result = {
        workerA = a,
        workerB = b,
        currentDistance = currentDistance,
        requiredClearance = required,
        headingDot = a.headingX*b.headingX + a.headingZ*b.headingZ,
        stable = a.speedKmh >= self.VECTOR_DEBUG_MIN_SPEED_KMH
            and b.speedKmh >= self.VECTOR_DEBUG_MIN_SPEED_KMH
            and a.turnFactor <= self.VECTOR_DEBUG_MAX_TURN_FACTOR
            and b.turnFactor <= self.VECTOR_DEBUG_MAX_TURN_FACTOR,
        confidence = 0
    }

    if not result.stable then
        result.severity = "UNSTABLE"
        return result
    end
    if rv2 <= 0.01 or currentDistance <= 0.01 then
        result.severity = "PARALLEL"
        return result
    end

    result.closingRate = -((rx*rvx + rz*rvz) / currentDistance)
    result.tcpa = -(rx*rvx + rz*rvz) / rv2
    if result.tcpa < 0 or result.tcpa > self.VECTOR_DEBUG_HORIZON_SECONDS then
        result.severity = "SAFE"
        result.outsideHorizon = true
        return result
    end

    local ax = a.x + vax*result.tcpa
    local az = a.z + vaz*result.tcpa
    local bx = b.x + vbx*result.tcpa
    local bz = b.z + vbz*result.tcpa
    local cdx, cdz = bx-ax, bz-az
    result.cpa = math.sqrt(cdx*cdx + cdz*cdz)
    result.overlap = required - result.cpa
    result.pointX, result.pointZ = (ax+bx)*0.5, (az+bz)*0.5

    local watchLimit = required + self.VECTOR_DEBUG_NEAR_MARGIN
    local criticalLimit = required * self.VECTOR_DEBUG_CRITICAL_FACTOR
    if result.cpa < criticalLimit then
        result.severity = "CRITICAL"
    elseif result.cpa < required then
        result.severity = "CONFLICT"
    elseif result.cpa < watchLimit then
        result.severity = "WATCH"
    else
        result.severity = "SAFE"
    end

    -- Confidence is intentionally simple for now: stable straight motion and
    -- a nearer prediction score higher. DecisionEngine can refine this later.
    local horizonFactor = 1 - math.min(result.tcpa / self.VECTOR_DEBUG_HORIZON_SECONDS, 1)
    local turnPenalty = math.max(a.turnFactor, b.turnFactor) / math.max(self.VECTOR_DEBUG_MAX_TURN_FACTOR, 0.001)
    result.confidence = math.max(0, math.min(1, 0.55 + horizonFactor*0.35 - turnPenalty*0.20))
    return result
end

function OuttaMyWay:updateVectorPrediction(active)
    local now = g_time or 0
    local seen = {}
    self.vectorPredictions = self.vectorPredictions or {}

    for i=1,#active-1 do
        for j=i+1,#active do
            local a = self:buildWorkerProfile(active[i])
            local b = self:buildWorkerProfile(active[j])
            local key = predictionPairKey(a, b)
            seen[key] = true

            local state = self.vectorDebugState[key] or {}
            self.vectorDebugState[key] = state
            local result = self:predictWorkerPair(a, b)
            self.vectorPredictions[key] = result

            if result.stable then
                if state.stableSince == nil then state.stableSince = now end
                result.stableSeconds = math.max(0, now-state.stableSince)/1000
            else
                result.stableSeconds = 0
            end

            local class = result.severity
            local changed = state.class ~= class
            local due = now >= (state.nextLogAt or 0)
            local activeClass = class == "WATCH" or class == "CONFLICT" or class == "CRITICAL"

            if activeClass and (changed or due) then
                vectorLog("VECTOR %s: %s / %s TCPA=%.1fs CPA=%.1fm required=%.1fm overlap=%+.1fm point=(%.1f, %.1f) current=%.1fm closing=%.2fm/s headingDot=%.2f speed=%.1f/%.1fkm/h stable=%.1fs turn=%.2f/%.2f confidence=%.2f",
                    class, a.name, b.name, result.tcpa, result.cpa,
                    result.requiredClearance, result.overlap, result.pointX, result.pointZ,
                    result.currentDistance, result.closingRate or 0, result.headingDot,
                    a.speedKmh, b.speedKmh, result.stableSeconds,
                    a.turnFactor, b.turnFactor, result.confidence or 0)
                state.nextLogAt = now + self.VECTOR_DEBUG_UPDATE_MS
            elseif changed and state.class ~= nil and state.class ~= "SAFE" and class ~= "UNSTABLE" then
                vectorLog("VECTOR DIVERGING: %s / %s %s -> %s TCPA=%.1fs CPA=%.1fm required=%.1fm closing=%.2fm/s",
                    a.name, b.name, state.class, class,
                    result.tcpa or -1, result.cpa or -1,
                    result.requiredClearance or 0, result.closingRate or 0)
            elseif class == "UNSTABLE" and (state.class == "WATCH" or state.class == "CONFLICT" or state.class == "CRITICAL") then
                vectorLog("VECTOR PAUSED: %s / %s previous=%s speed=%.1f/%.1fkm/h turn=%.2f/%.2f",
                    a.name, b.name, state.class, a.speedKmh, b.speedKmh,
                    a.turnFactor, b.turnFactor)
            elseif result.outsideHorizon and (state.class == "WATCH" or state.class == "CONFLICT" or state.class == "CRITICAL") then
                vectorLog("VECTOR DIVERGING: %s / %s %s -> OUTSIDE_HORIZON TCPA=%.1fs closing=%.2fm/s",
                    a.name, b.name, state.class, result.tcpa or -1, result.closingRate or 0)
            end

            state.class = class
            if class == "UNSTABLE" then state.stableSince = nil end
        end
    end

    for key in pairs(self.vectorDebugState) do
        if not seen[key] then self.vectorDebugState[key] = nil end
    end
    for key in pairs(self.vectorPredictions) do
        if not seen[key] then self.vectorPredictions[key] = nil end
    end
end
