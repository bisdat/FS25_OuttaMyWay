OuttaMyWay.ProductiveContinuationProbe = {}
local Probe = OuttaMyWay.ProductiveContinuationProbe
Probe.__index = Probe

local function logInfo(message)
    if Logging ~= nil and type(Logging.info) == "function" then
        Logging.info("[FS25_OuttaMyWay][PROBE21] %s", message)
    else
        print("[FS25_OuttaMyWay][PROBE21] " .. message)
    end
end

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function className(value)
    if value == nil then return "nil" end
    if type(value) == "table" then
        if value.className ~= nil then return tostring(value.className) end
        if type(value.class) == "table" and value.class.className ~= nil then return tostring(value.class.className) end
    end
    return tostring(value)
end

local function appendStrategies(candidates, spec, source)
    if type(spec) ~= "table" or type(spec.driveStrategies) ~= "table" then return end
    for index, strategy in pairs(spec.driveStrategies) do
        candidates[#candidates + 1] = {strategy = strategy, source = string.format("%s.driveStrategies[%s]", source, tostring(index))}
    end
end

local function findFieldCourseStrategy(vehicle)
    if vehicle == nil then return nil, "NO_VEHICLE" end
    local candidates = {}
    appendStrategies(candidates, vehicle.spec_aiVehicle, "spec_aiVehicle")
    appendStrategies(candidates, vehicle.spec_aiFieldWorker, "spec_aiFieldWorker")
    appendStrategies(candidates, vehicle, "vehicle")
    for _, candidate in ipairs(candidates) do
        local strategy = candidate.strategy
        local name = className(strategy)
        if strategy ~= nil and (strategy.aiFieldCourse ~= nil or string.find(name, "FieldCourse", 1, true) ~= nil) then
            return strategy, candidate.source
        end
    end
    return nil, #candidates > 0 and ("SEARCHED_" .. tostring(#candidates) .. "_STRATEGIES") or "NO_STRATEGY_ARRAYS"
end

local function referenceKey(vehicle)
    return "vehicle-root:" .. tostring(vehicle and (vehicle.rootNode or vehicle) or "nil")
end

local function objectName(object)
    local ok, value = safeCall(object, "getName")
    if ok and value ~= nil and value ~= "" then return tostring(value) end
    return tostring(object and (object.name or object.typeName) or "AI vehicle")
end

local function numberText(value, precision)
    if value == nil then return "n/a" end
    return string.format("%." .. tostring(precision or 2) .. "f", tonumber(value) or 0)
end

local function booleanText(value)
    if value == nil then return "n/a" end
    return value == true and "true" or "false"
end

local function valueOrSpec(vehicle, methodName, fallback)
    local ok, value = safeCall(vehicle, methodName)
    if ok and value ~= nil then return value, methodName end
    if fallback ~= nil then return fallback, "spec_drivable.cruiseControl" end
    return nil, "UNAVAILABLE"
end

local function speedObservations(vehicle)
    local actualKmh = math.abs(tonumber(vehicle and vehicle.lastSpeedReal) or 0) * 3600
    local cruise = vehicle and vehicle.spec_drivable and vehicle.spec_drivable.cruiseControl or nil
    local cruiseState, cruiseStateSource = valueOrSpec(vehicle, "getCruiseControlState", cruise and cruise.state or nil)
    local cruiseSelected, cruiseSelectedSource = valueOrSpec(vehicle, "getCruiseControlSpeed", cruise and cruise.speed or nil)
    local cruiseMax, cruiseMaxSource = valueOrSpec(vehicle, "getCruiseControlMaxSpeed", cruise and cruise.maxSpeed or nil)
    local okTrue, speedLimitTrue = safeCall(vehicle, "getSpeedLimit", true)
    local okFalse, speedLimitFalse = safeCall(vehicle, "getSpeedLimit", false)
    return {
        actualKmh = actualKmh,
        cruiseState = cruiseState,
        cruiseSelectedKmh = cruiseSelected,
        cruiseMaxKmh = cruiseMax,
        cruiseStateSource = cruiseStateSource,
        cruiseSelectedSource = cruiseSelectedSource,
        cruiseMaxSource = cruiseMaxSource,
        speedLimitTrueKmh = okTrue and tonumber(speedLimitTrue) or nil,
        speedLimitFalseKmh = okFalse and tonumber(speedLimitFalse) or nil
    }
end

local function implementLineEvidence(strategy)
    local data = strategy and strategy.implementData or nil
    if type(data) ~= "table" then
        return {classification = "UNAVAILABLE", total = 0, resolved = 0, lowered = 0, raised = 0, unresolved = 0}
    end
    local result = {classification = "UNRESOLVED", total = 0, resolved = 0, lowered = 0, raised = 0, unresolved = 0}
    for _, entry in pairs(data) do
        if type(entry) == "table" then
            result.total = result.total + 1
            if entry.isLowered == true then
                result.resolved = result.resolved + 1
                result.lowered = result.lowered + 1
            elseif entry.isLowered == false then
                result.resolved = result.resolved + 1
                result.raised = result.raised + 1
            else
                result.unresolved = result.unresolved + 1
            end
        end
    end
    if result.total == 0 then
        result.classification = "EMPTY"
    elseif result.unresolved > 0 then
        result.classification = "UNRESOLVED"
    elseif result.lowered > 0 and result.raised > 0 then
        result.classification = "MIXED"
    elseif result.lowered > 0 then
        result.classification = "ACTIVE"
    elseif result.raised > 0 then
        result.classification = "INACTIVE"
    end
    return result
end

local function activeSegmentEvidence(strategy)
    local course = strategy and strategy.aiFieldCourse or nil
    if course == nil or type(course.getActiveSegmentData) ~= "function" then
        return {available = false, reason = "ACTIVE_SEGMENT_DATA_UNAVAILABLE"}
    end
    local ok, isTurn, isInitial, segmentPosition, segmentLength, subSegmentPosition, subSegmentLength = pcall(course.getActiveSegmentData, course)
    if not ok then return {available = false, reason = "ACTIVE_SEGMENT_DATA_CALL_FAILED"} end
    return {
        available = true,
        isTurn = isTurn,
        isInitial = isInitial,
        segmentPosition = tonumber(segmentPosition),
        segmentLength = tonumber(segmentLength),
        subSegmentPosition = tonumber(subSegmentPosition),
        subSegmentLength = tonumber(subSegmentLength)
    }
end

local function evidenceClass(segment, line)
    if segment.available ~= true then return "SEGMENT_UNRESOLVED" end
    if segment.isTurn == true then return "TURN_SEGMENT" end
    if line.classification == "ACTIVE" then return "NON_TURN_LINE_ACTIVE" end
    if line.classification == "INACTIVE" then return "NON_TURN_LINE_INACTIVE" end
    if line.classification == "MIXED" then return "NON_TURN_LINE_MIXED" end
    return "NON_TURN_LINE_UNRESOLVED"
end

function Probe.new()
    return setmetatable({elapsed = 0, signatures = {}, lastHeartbeatAt = {}, announced = false}, Probe)
end

function Probe:reset()
    self.elapsed = 0
    self.signatures = {}
    self.lastHeartbeatAt = {}
    self.announced = false
end

function Probe:loadMap()
    self:reset()
    logInfo("Productive Continuation evidence probe active; passive observation only; absolute speed has no semantic authority")
end

function Probe:deleteMap() self:reset() end
function Probe:keyEvent() end
function Probe:mouseEvent() end
function Probe:draw() end

function Probe:_observeVehicle(vehicle, nowMilliseconds)
    local ref = referenceKey(vehicle)
    local strategy, strategySource = findFieldCourseStrategy(vehicle)
    local segment = activeSegmentEvidence(strategy)
    local line = implementLineEvidence(strategy)
    local speeds = speedObservations(vehicle)
    local job = OuttaMyWay.LiveAIJobEvidence.currentJob(vehicle)
    local jobToken = OuttaMyWay.LiveAIJobEvidence.jobToken(job)
    local settings = strategy and strategy.fieldCourseSettings or nil
    local toolAlwaysActive = settings and settings.toolAlwaysActive or nil
    local lastContinueWorkState = strategy and strategy.lastContinueWorkState or nil
    local movingDirection = strategy and tonumber(strategy.lastMovingDirection) or nil
    local classification = evidenceClass(segment, line)
    local signature = table.concat({
        tostring(jobToken), tostring(strategySource), tostring(classification), tostring(segment.isTurn), tostring(segment.isInitial),
        tostring(line.classification), tostring(line.lowered), tostring(line.raised), tostring(line.unresolved), tostring(toolAlwaysActive),
        tostring(lastContinueWorkState), tostring(movingDirection), tostring(speeds.cruiseState), tostring(speeds.cruiseSelectedKmh), tostring(speeds.cruiseMaxKmh),
        tostring(speeds.speedLimitTrueKmh), tostring(speeds.speedLimitFalseKmh)
    }, "|")
    local heartbeat = OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_HEARTBEAT_MS or 2000
    local due = self.lastHeartbeatAt[ref] == nil or nowMilliseconds - self.lastHeartbeatAt[ref] >= heartbeat
    if self.signatures[ref] ~= signature or due then
        self.signatures[ref] = signature
        self.lastHeartbeatAt[ref] = nowMilliseconds
        logInfo(string.format(
            "worker=%s ref=%s job=%s evidence=%s strategy=%s turn=%s initial=%s segPos=%s segLen=%s subPos=%s subLen=%s line=%s implements=%d resolved=%d lowered=%d raised=%d unresolved=%d toolAlwaysActive=%s continueWork=%s direction=%s actualKmh=%s cruiseState=%s cruiseSelectedKmh=%s cruiseMaxKmh=%s speedLimitTrueKmh=%s speedLimitFalseKmh=%s",
            objectName(vehicle), ref, tostring(jobToken or "unresolved"), classification, tostring(strategySource),
            booleanText(segment.isTurn), booleanText(segment.isInitial), numberText(segment.segmentPosition, 4), numberText(segment.segmentLength, 2), numberText(segment.subSegmentPosition, 4), numberText(segment.subSegmentLength, 2),
            line.classification, line.total, line.resolved, line.lowered, line.raised, line.unresolved, booleanText(toolAlwaysActive), booleanText(lastContinueWorkState), movingDirection == 1 and "FORWARD" or (movingDirection == -1 and "REVERSE" or "n/a"),
            numberText(speeds.actualKmh, 2), tostring(speeds.cruiseState or "n/a"), numberText(speeds.cruiseSelectedKmh, 2), numberText(speeds.cruiseMaxKmh, 2), numberText(speeds.speedLimitTrueKmh, 2), numberText(speeds.speedLimitFalseKmh, 2)
        ))
    end
end

function Probe:update(dt)
    if OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_ENABLED ~= true then return end
    if g_currentMission == nil then return end
    if g_client ~= nil and g_server == nil then return end
    self.elapsed = self.elapsed + (dt or 0)
    local interval = OuttaMyWay.PRODUCTIVE_CONTINUATION_PROBE_INTERVAL_MS or 250
    if self.elapsed < interval then return end
    self.elapsed = self.elapsed % interval
    local nowMilliseconds = tonumber(g_time) or 0
    local seen = {}
    for _, vehicle in OuttaMyWay.ValueRecord.ipairs(OuttaMyWay.LiveAIJobEvidence.activeJobVehicles(g_currentMission)) do
        local ref = referenceKey(vehicle)
        seen[ref] = true
        self:_observeVehicle(vehicle, nowMilliseconds)
    end
    for ref in pairs(self.signatures) do
        if not seen[ref] then
            self.signatures[ref] = nil
            self.lastHeartbeatAt[ref] = nil
        end
    end
end
