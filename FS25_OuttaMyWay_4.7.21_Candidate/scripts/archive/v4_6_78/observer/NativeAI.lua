-- FS25_OuttaMyWay v4.2.0.2
-- Read-only access to live GIANTS AI field-course state.
-- Strategy discovery intentionally preserves the proven v4.1.3 Explorer logic.
OuttaMyWay.NativeAI = OuttaMyWay.NativeAI or {}
local NativeAI = OuttaMyWay.NativeAI

local function className(value)
    if value == nil then return "nil" end
    if type(value) == "table" then
        if value.className ~= nil then return tostring(value.className) end
        if type(value.class) == "table" and value.class.className ~= nil then
            return tostring(value.class.className)
        end
    end
    return tostring(value)
end

local function appendStrategies(candidates, spec, source)
    if type(spec) ~= "table" or type(spec.driveStrategies) ~= "table" then return end
    for index, strategy in pairs(spec.driveStrategies) do
        candidates[#candidates + 1] = {
            strategy = strategy,
            source = string.format("%s.driveStrategies[%s]", source, tostring(index))
        }
    end
end

-- This is deliberately identical in behaviour and ordering to the strategy
-- discovery that proved reliable in AIFieldCourseExplorer v4.1.3.0.
function NativeAI.findFieldCourseStrategy(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return nil, "deleted" end

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

    return nil, #candidates > 0 and ("searched=" .. #candidates) or "no strategy arrays"
end

function NativeAI.getActivityFlags(vehicle)
    if vehicle == nil or vehicle.isDeleted == true then return false, false, false end

    local fieldActive = false
    local aiActive = false
    local spec = vehicle.spec_aiFieldWorker

    if spec ~= nil and spec.isActive == true then fieldActive = true end

    if type(vehicle.getIsFieldWorkActive) == "function" then
        local ok, active = pcall(vehicle.getIsFieldWorkActive, vehicle)
        if ok and active == true then fieldActive = true end
    end

    if type(vehicle.getIsAIActive) == "function" then
        local ok, active = pcall(vehicle.getIsAIActive, vehicle)
        if ok and active == true then aiActive = true end
    end

    return fieldActive or aiActive, fieldActive, aiActive
end

function NativeAI.callReturns(object, methodName)
    if object == nil then return {available=false, ok=false, values={}} end
    local fn = object[methodName]
    if type(fn) ~= "function" then return {available=false, ok=false, values={}} end

    local ok, r1,r2,r3,r4,r5,r6,r7,r8,r9,r10 = pcall(fn, object)
    if not ok then
        return {available=true, ok=false, error=tostring(r1), values={}}
    end
    return {available=true, ok=true, values={r1,r2,r3,r4,r5,r6,r7,r8,r9,r10}}
end

function NativeAI.read(vehicle)
    local strategy, source = NativeAI.findFieldCourseStrategy(vehicle)
    if strategy == nil then return nil, source end

    local course = strategy.aiFieldCourse
    return {
        strategy=strategy,
        strategySource=source,
        strategyClass=className(strategy),
        course=course,
        active=NativeAI.callReturns(course, "getActiveSegmentData"),
        next=NativeAI.callReturns(course, "getNextSegmentData"),
        sideOffset=NativeAI.callReturns(course, "getActiveSegmentSideOffset"),
        cornerCutOut=NativeAI.callReturns(course, "getIsCornerCutOutActive"),
        isBlocked=strategy.isBlocked == true,
        hasStaticCollision=strategy.hasStaticCollision == true,
        requestedSpeed=tonumber(strategy.lastMaxSpeed or strategy.maxSpeed),
        lastTargetPosition=strategy.lastTargetPosition,
        lastVehiclePosition=strategy.lastVehiclePosition,
        lastMovingDirection=strategy.lastMovingDirection,
        lastSegmentIsTurn=strategy.lastSegmentIsTurn
    }, source
end
