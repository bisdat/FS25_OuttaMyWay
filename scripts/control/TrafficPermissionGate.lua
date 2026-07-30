-- FS25_OuttaMyWay v4.2.5.4
-- Narrow native AI permission gate used by Traffic Manager v2.
-- Overwrites only getCanAIFieldWorkerContinueWork on vehicles that OuttaMyWay
-- actually needs to hold, and always respects the pre-existing overwrite chain.
OuttaMyWay.TrafficPermissionGate = OuttaMyWay.TrafficPermissionGate or {}
local Gate = OuttaMyWay.TrafficPermissionGate

Gate.holds = Gate.holds or setmetatable({}, {__mode = "k"})
Gate.installed = Gate.installed or setmetatable({}, {__mode = "k"})
Gate.callCounts = Gate.callCounts or setmetatable({}, {__mode = "k"})
Gate.lastLogAt = Gate.lastLogAt or setmetatable({}, {__mode = "k"})

local function vehicleName(vehicle)
    if vehicle ~= nil and vehicle.getName ~= nil then
        local ok, name = pcall(vehicle.getName, vehicle)
        if ok and name ~= nil then return tostring(name) end
    end
    return "AI vehicle"
end

function Gate.overwrite(vehicle, superFunc, isTurning)
    local canContinue, stopAI, stopReason = superFunc(vehicle, isTurning)

    -- Never overrule GIANTS or another mod that already refused permission.
    if canContinue == false then
        return canContinue, stopAI, stopReason
    end

    local hold = Gate.holds[vehicle]
    if hold == nil then
        return canContinue, stopAI, stopReason
    end

    local now = g_time or 0
    Gate.callCounts[vehicle] = (Gate.callCounts[vehicle] or 0) + 1
    if hold.firstGateAt == nil then hold.firstGateAt = now end

    if hold.firstLogDone ~= true or now - (Gate.lastLogAt[vehicle] or 0) >= 1000 then
        hold.firstLogDone = true
        Gate.lastLogAt[vehicle] = now
        print(string.format(
            "Info: [FS25_OuttaMyWay] TRAFFIC V2 PERMISSION GATE vehicle=%s context=%s superAllowed=%s superStopAI=%s hold=true resultAllowed=false resultStopAI=false turning=%s calls=%d",
            vehicleName(vehicle), tostring(hold.contextId), tostring(canContinue), tostring(stopAI),
            tostring(isTurning == true), Gate.callCounts[vehicle] or 0))
    end

    -- Native temporary wait semantics: stop movement without ending the AI job.
    return false, false, nil
end

function Gate:installOnVehicle(vehicle)
    if vehicle == nil then return false, "vehicle nil" end
    if self.installed[vehicle] == true then return true end

    local original = vehicle.getCanAIFieldWorkerContinueWork
    if type(original) ~= "function" then
        return false, "getCanAIFieldWorkerContinueWork unavailable"
    end
    if Utils == nil or Utils.overwrittenFunction == nil then
        return false, "Utils.overwrittenFunction unavailable"
    end

    vehicle.getCanAIFieldWorkerContinueWork = Utils.overwrittenFunction(original, Gate.overwrite)
    self.installed[vehicle] = true
    print(string.format(
        "Info: [FS25_OuttaMyWay] TRAFFIC V2 PERMISSION OVERWRITE INSTALLED vehicle=%s function=getCanAIFieldWorkerContinueWork",
        vehicleName(vehicle)))
    return true
end

function Gate:setHold(vehicle, contextId, priorityVehicle, nowMs)
    local ok, reason = self:installOnVehicle(vehicle)
    if not ok then return false, reason end

    self.holds[vehicle] = {
        contextId = contextId,
        priorityVehicle = priorityVehicle,
        startedAt = nowMs or (g_time or 0),
        firstGateAt = nil,
        firstLogDone = false
    }
    self.callCounts[vehicle] = 0
    self.lastLogAt[vehicle] = 0
    return true
end

function Gate:releaseHold(vehicle)
    local hold = vehicle ~= nil and self.holds[vehicle] or nil
    self.holds[vehicle] = nil
    return hold
end

function Gate:isHolding(vehicle)
    return vehicle ~= nil and self.holds[vehicle] ~= nil
end

function Gate:getHold(vehicle)
    return vehicle ~= nil and self.holds[vehicle] or nil
end

function Gate:getCallCount(vehicle)
    return vehicle ~= nil and (self.callCounts[vehicle] or 0) or 0
end

function Gate:clear()
    self.holds = setmetatable({}, {__mode = "k"})
    self.callCounts = setmetatable({}, {__mode = "k"})
    self.lastLogAt = setmetatable({}, {__mode = "k"})
    -- Installed wrappers intentionally remain in place and become transparent
    -- when no hold exists. This avoids repeatedly wrapping the same method.
end
