-- FS25_OuttaMyWay Prototype 22.
-- Temporary same-Job-Episode Hold capability probe.
--
-- This module intentionally reuses the empirically proven GIANTS integration
-- point getCanAIFieldWorkerContinueWork.  It is not production Traffic
-- Policeman policy: a Hold exists only after an explicit Prototype 22 console
-- command and the wrapper is transparent at all other times.

OuttaMyWay.Prototype22PermissionGate = {}
local Gate = OuttaMyWay.Prototype22PermissionGate
Gate.__index = Gate

local function weakKeys()
    return setmetatable({}, {__mode = "k"})
end

function Gate.new()
    return setmetatable({
        holds = weakKeys(),
        installed = weakKeys(),
        callCounts = weakKeys()
    }, Gate)
end

function Gate:install(vehicle)
    if vehicle == nil then return false, "vehicle-unavailable" end
    if self.installed[vehicle] == true then return true end
    if type(vehicle.getCanAIFieldWorkerContinueWork) ~= "function" then
        return false, "getCanAIFieldWorkerContinueWork-unavailable"
    end
    if Utils == nil or type(Utils.overwrittenFunction) ~= "function" then
        return false, "Utils.overwrittenFunction-unavailable"
    end

    local gate = self
    local original = vehicle.getCanAIFieldWorkerContinueWork
    vehicle.getCanAIFieldWorkerContinueWork = Utils.overwrittenFunction(original,
        function(subject, superFunc, isTurning)
            local canContinue, stopAI, stopReason = superFunc(subject, isTurning)
            -- Never overrule a pre-existing GIANTS/mod refusal.
            if canContinue == false then return canContinue, stopAI, stopReason end
            local hold = gate.holds[subject]
            if hold == nil then return canContinue, stopAI, stopReason end
            gate.callCounts[subject] = (gate.callCounts[subject] or 0) + 1
            hold.lastGateAt = g_time or 0
            -- Proven temporary-wait semantics: inhibit movement without asking
            -- GIANTS to terminate the current AI field job.
            return false, false, nil
        end)
    self.installed[vehicle] = true
    return true
end

function Gate:setHold(vehicle, context)
    local ok, reason = self:install(vehicle)
    if not ok then return false, reason end
    self.holds[vehicle] = {
        context = tostring(context or "P22"),
        startedAt = g_time or 0,
        lastGateAt = nil
    }
    self.callCounts[vehicle] = 0
    return true
end

function Gate:release(vehicle)
    if vehicle == nil then return nil end
    local previous = self.holds[vehicle]
    self.holds[vehicle] = nil
    return previous
end

function Gate:isHolding(vehicle)
    return vehicle ~= nil and self.holds[vehicle] ~= nil
end

function Gate:getCallCount(vehicle)
    return vehicle ~= nil and (self.callCounts[vehicle] or 0) or 0
end

function Gate:clear()
    self.holds = weakKeys()
    self.callCounts = weakKeys()
    -- Installed wrappers intentionally remain transparent. Replacing them at
    -- runtime could break another mod's overwrite chain.
end
