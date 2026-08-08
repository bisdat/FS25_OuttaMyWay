-- FS25_OuttaMyWay Prototype 22 configuration capability probe.
--
-- Temporary, explicit-console-only assembly configuration authority used only
-- by P22-C.  This module reuses previously proven GIANTS integration
-- mechanisms (work off, raise/lower, fold-direction request) without creating
-- production Traffic Policeman policy.  Fold animation values are diagnostic
-- motion evidence only; spatial PASS is established separately from realised
-- plan-view representation evidence.

OuttaMyWay.Prototype22ConfigurationAuthority = {}
local Authority = OuttaMyWay.Prototype22ConfigurationAuthority
Authority.__index = Authority

local function safeCall(object, methodName, ...)
    if object == nil or type(object[methodName]) ~= "function" then return false, nil end
    return pcall(object[methodName], object, ...)
end

local function collectAssembly(root)
    local output, seen = {}, {}
    local function scan(object)
        if object == nil or object.isDeleted == true or seen[object] then return end
        seen[object] = true
        output[#output + 1] = object
        local ok, implements = safeCall(object, "getAttachedImplements")
        if ok and type(implements) == "table" then
            for _, implement in pairs(implements) do
                scan(implement ~= nil and (implement.object or implement) or nil)
            end
        end
    end
    scan(root)
    return output
end

local function foldTime(object)
    local value = object and object.spec_foldable and tonumber(object.spec_foldable.foldAnimTime) or nil
    if value == nil then
        local ok, result = safeCall(object, "getFoldAnimTime")
        if ok then value = tonumber(result) end
    end
    return value
end

local function foldClass(value)
    if value == nil then return "UNKNOWN" end
    if value <= 0.02 then return "DEPLOYED" end
    if value >= 0.98 then return "FOLDED" end
    return "TRANSITION"
end

local function foldEvidence(vehicle)
    local evidence = {
        foldableCount = 0,
        deployedCount = 0,
        transitionCount = 0,
        foldedCount = 0,
        unknownCount = 0,
        minimum = nil,
        maximum = nil
    }
    for _, object in ipairs(collectAssembly(vehicle)) do
        if object.spec_foldable ~= nil or type(object.getFoldAnimTime) == "function" then
            evidence.foldableCount = evidence.foldableCount + 1
            local value = foldTime(object)
            if value ~= nil then
                evidence.minimum = evidence.minimum == nil and value or math.min(evidence.minimum, value)
                evidence.maximum = evidence.maximum == nil and value or math.max(evidence.maximum, value)
            end
            local class = foldClass(value)
            if class == "DEPLOYED" then evidence.deployedCount = evidence.deployedCount + 1
            elseif class == "TRANSITION" then evidence.transitionCount = evidence.transitionCount + 1
            elseif class == "FOLDED" then evidence.foldedCount = evidence.foldedCount + 1
            else evidence.unknownCount = evidence.unknownCount + 1 end
        end
    end
    evidence.allDeployed = evidence.foldableCount > 0 and evidence.deployedCount == evidence.foldableCount
    evidence.allFolded = evidence.foldableCount > 0 and evidence.foldedCount == evidence.foldableCount
    evidence.motionObserved = evidence.transitionCount > 0 or evidence.foldedCount > 0
    return evidence
end

local function setWorkState(object, enabled)
    if object == nil or object.isDeleted == true then return false end
    if type(object.setIsTurnedOn) ~= "function" then return false end
    local ok = pcall(object.setIsTurnedOn, object, enabled, true)
    if not ok then ok = pcall(object.setIsTurnedOn, object, enabled) end
    return ok
end

local function setLoweredState(object, lowered)
    if object == nil or object.isDeleted == true or type(object.setLowered) ~= "function" then return false end
    local ok = pcall(object.setLowered, object, lowered, true)
    if not ok then ok = pcall(object.setLowered, object, lowered) end
    return ok
end

local function toggleFold(object)
    if object == nil or object.isDeleted == true then return false end
    if type(object.getToggledFoldDirection) ~= "function" or type(object.setFoldDirection) ~= "function" then return false end
    local okDirection, direction = pcall(object.getToggledFoldDirection, object)
    if not okDirection or direction == nil or direction == 0 then return false end
    local ok = pcall(object.setFoldDirection, object, direction, true)
    if not ok then ok = pcall(object.setFoldDirection, object, direction) end
    return ok
end

function Authority.new()
    return setmetatable({states = setmetatable({}, {__mode = "k"})}, Authority)
end

function Authority:getEvidence(vehicle)
    return foldEvidence(vehicle)
end

function Authority:prepareCompact(vehicle)
    if vehicle == nil then return false, "vehicle-unavailable" end
    if self.states[vehicle] ~= nil then return false, "configuration-authority-already-owned" end

    local initial = foldEvidence(vehicle)
    if initial.foldableCount == 0 then return false, "no-foldable-object" end
    if initial.unknownCount > 0 then return false, "fold-state-unresolved" end
    if not initial.allDeployed then return false, "probe-requires-fully-deployed-start" end

    local state = {
        vehicle = vehicle,
        objects = collectAssembly(vehicle),
        initialFoldEvidence = initial,
        workStates = {},
        loweredStates = {},
        foldRequested = false,
        restoreFoldRequested = false,
        compactRequestedAt = g_time or 0,
        restoreRequestedAt = nil,
        workMutations = 0,
        raisedMutations = 0,
        foldMutations = 0
    }

    for _, object in ipairs(state.objects) do
        if type(object.getIsTurnedOn) == "function" and type(object.setIsTurnedOn) == "function" then
            local ok, current = pcall(object.getIsTurnedOn, object)
            if ok and type(current) == "boolean" then
                state.workStates[object] = current
                if current == true and setWorkState(object, false) then state.workMutations = state.workMutations + 1 end
            end
        end
        if type(object.getIsLowered) == "function" and type(object.setLowered) == "function" then
            local ok, current = pcall(object.getIsLowered, object)
            if ok and type(current) == "boolean" then
                state.loweredStates[object] = current
                if current == true and setLoweredState(object, false) then state.raisedMutations = state.raisedMutations + 1 end
            end
        end
    end

    for _, object in ipairs(state.objects) do
        if (object.spec_foldable ~= nil or type(object.getFoldAnimTime) == "function") and toggleFold(object) then
            state.foldMutations = state.foldMutations + 1
        end
    end
    state.foldRequested = state.foldMutations > 0
    if not state.foldRequested then
        -- Restore any work/raise mutations immediately if no fold command can be made.
        for object, lowered in pairs(state.loweredStates) do setLoweredState(object, lowered) end
        for object, enabled in pairs(state.workStates) do setWorkState(object, enabled) end
        return false, "fold-command-unavailable"
    end

    self.states[vehicle] = state
    return true, state
end

function Authority:requestRestore(vehicle)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil then return false, "configuration-authority-not-owned" end
    if state.restoreRequestedAt ~= nil then return true, state end
    state.restoreRequestedAt = g_time or 0

    local evidence = foldEvidence(vehicle)
    if evidence.allDeployed then
        state.restoreFoldRequested = false
        return true, state
    end

    local toggled = 0
    for _, object in ipairs(state.objects) do
        if (object.spec_foldable ~= nil or type(object.getFoldAnimTime) == "function") and toggleFold(object) then
            toggled = toggled + 1
        end
    end
    state.restoreFoldRequested = toggled > 0
    if toggled == 0 then return false, "restore-fold-command-unavailable" end
    return true, state
end

function Authority:finishRestore(vehicle)
    local state = vehicle ~= nil and self.states[vehicle] or nil
    if state == nil then return false, "configuration-authority-not-owned" end
    local evidence = foldEvidence(vehicle)
    if not evidence.allDeployed then return false, "not-yet-deployed" end

    for object, lowered in pairs(state.loweredStates) do setLoweredState(object, lowered) end
    for object, enabled in pairs(state.workStates) do setWorkState(object, enabled) end
    self.states[vehicle] = nil
    return true, state
end

function Authority:getState(vehicle)
    return vehicle ~= nil and self.states[vehicle] or nil
end

function Authority:clear(vehicle)
    if vehicle ~= nil then self.states[vehicle] = nil end
end

function Authority:clearAll()
    self.states = setmetatable({}, {__mode = "k"})
end
