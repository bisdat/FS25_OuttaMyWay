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

local function activeFoldMotionEvidence(vehicle)
    local evidence={foldableCount=0,motionObservableCount=0,activeCount=0,maximumAbsDirection=0}
    for _,object in ipairs(collectAssembly(vehicle)) do
        local spec=object~=nil and object.spec_foldable or nil
        if spec~=nil then
            evidence.foldableCount=evidence.foldableCount+1
            local direction=tonumber(spec.foldMoveDirection)
            if direction~=nil then
                evidence.motionObservableCount=evidence.motionObservableCount+1
                local magnitude=math.abs(direction)
                evidence.maximumAbsDirection=math.max(evidence.maximumAbsDirection,magnitude)
                if magnitude>0.1 then evidence.activeCount=evidence.activeCount+1 end
            end
        end
    end
    evidence.active=evidence.activeCount>0
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
    if object == nil or object.isDeleted == true then return false,nil end
    if type(object.getToggledFoldDirection) ~= "function" or type(object.setFoldDirection) ~= "function" then return false,nil end
    local okDirection, direction = pcall(object.getToggledFoldDirection, object)
    direction=okDirection and tonumber(direction) or nil
    if direction == nil or direction == 0 then return false,nil end
    local ok = pcall(object.setFoldDirection, object, direction, true)
    if not ok then ok = pcall(object.setFoldDirection, object, direction) end
    return ok,ok and direction or nil
end

local function requestFoldDirection(object,direction)
    direction=tonumber(direction)
    if object==nil or object.isDeleted==true or direction==nil or direction==0 or type(object.setFoldDirection)~="function" then return false end
    local ok=pcall(object.setFoldDirection,object,direction,true)
    if not ok then ok=pcall(object.setFoldDirection,object,direction) end
    return ok
end

function Authority.new()
    return setmetatable({states = setmetatable({}, {__mode = "k"})}, Authority)
end

function Authority:getEvidence(vehicle)
    return foldEvidence(vehicle)
end

-- D-0178: actuation-motion evidence only; no semantic folded/deployed inference.
function Authority:getActiveFoldMotionEvidence(vehicle)
    return activeFoldMotionEvidence(vehicle)
end


-- D-0179: TRANSIT_BASE Passage consumes the Job-Episode bootstrap capability
-- record directly.  No assembly/capability discovery is performed here.
function Authority:prepareCachedTransit(vehicle,capability)
    if vehicle==nil then return false,"vehicle-unavailable" end
    if self.states[vehicle]~=nil then return false,"configuration-authority-already-owned" end
    if type(capability)~="table" then return false,"transit-capability-unavailable" end
    if capability.isFoldable~=true or type(capability.actuators)~="table" or #capability.actuators<1 then return false,"bootstrap-non-foldable" end

    local state={
        vehicle=vehicle,objects=capability.members or {},workStates={},loweredStates={},foldRequested=false,restoreFoldRequested=false,
        compactRequestedAt=g_time or 0,restoreRequestedAt=nil,workMutations=0,raisedMutations=0,foldMutations=0,
        bootstrapTransitCapability=true,transitActuatorStates={},settlementTimeoutMs=tonumber(capability.settlementTimeoutMs) or (OuttaMyWay.D0146_TRANSIT_FOLD_SETTLEMENT_FALLBACK_MS or 30000)
    }
    for _,object in ipairs(state.objects) do
        if type(object.getIsTurnedOn)=="function" and type(object.setIsTurnedOn)=="function" then
            local ok,current=pcall(object.getIsTurnedOn,object)
            if ok and type(current)=="boolean" then state.workStates[object]=current; if current and setWorkState(object,false) then state.workMutations=state.workMutations+1 end end
        end
        if type(object.getIsLowered)=="function" and type(object.setLowered)=="function" then
            local ok,current=pcall(object.getIsLowered,object)
            if ok and type(current)=="boolean" then state.loweredStates[object]=current; if current and setLoweredState(object,false) then state.raisedMutations=state.raisedMutations+1 end end
        end
    end
    for _,actuator in ipairs(capability.actuators) do
        local object=actuator.object
        local initialFoldAnimTime=foldTime(object)
        local ok,direction=toggleFold(object)
        if ok and direction~=nil then
            state.foldMutations=state.foldMutations+1
            state.transitActuatorStates[#state.transitActuatorStates+1]={
                object=object,memberReferenceKey=actuator.memberReferenceKey,direction=direction,
                initialFoldAnimTime=initialFoldAnimTime,initialTargetFoldAnimTime=initialFoldAnimTime~=nil and (initialFoldAnimTime>=0.5 and 1 or 0) or (direction>0 and 0 or 1),
                targetFoldAnimTime=direction>0 and 1 or 0,settled=false
            }
        end
    end
    state.foldRequested=state.foldMutations>0
    if not state.foldRequested then
        for object,lowered in pairs(state.loweredStates) do setLoweredState(object,lowered) end
        for object,enabled in pairs(state.workStates) do setWorkState(object,enabled) end
        return false,"cached-fold-command-unavailable"
    end
    self.states[vehicle]=state
    return true,state
end

function Authority:getCachedTransitSettlement(vehicle)
    local state=vehicle~=nil and self.states[vehicle] or nil
    if state==nil or state.bootstrapTransitCapability~=true then return {settled=true,exhausted=false,actuatorCount=0,settledCount=0,elapsedMs=0,timeoutMs=0,reason="NO_CACHED_TRANSIT_STATE"} end
    local settledCount=0
    for _,actuator in ipairs(state.transitActuatorStates or {}) do
        local value=foldTime(actuator.object)
        local target=tonumber(actuator.targetFoldAnimTime)
        local settled=value~=nil and target~=nil and ((target>=0.5 and value>=0.999) or (target<0.5 and value<=0.001))
        actuator.settled=settled==true
        if settled then settledCount=settledCount+1 end
    end
    local actuatorCount=#(state.transitActuatorStates or {})
    local elapsed=math.max(0,(g_time or 0)-(state.compactRequestedAt or (g_time or 0)))
    local timeout=tonumber(state.settlementTimeoutMs) or (OuttaMyWay.D0146_TRANSIT_FOLD_SETTLEMENT_FALLBACK_MS or 30000)
    local normal=actuatorCount>0 and settledCount==actuatorCount
    local exhausted=not normal and elapsed>=timeout
    return {settled=normal or exhausted,normal=normal,exhausted=exhausted,actuatorCount=actuatorCount,settledCount=settledCount,elapsedMs=elapsed,timeoutMs=timeout,reason=normal and "ACTUATORS_SETTLED" or (exhausted and "TRANSIT_FOLD_SETTLEMENT_EXHAUSTED" or "ACTUATORS_PENDING")}
end

-- D-0183: D-0146 restoration is symmetrical with D-0179 Transit actuation.
-- Restore only cached actuators whose fold position actually moved away from the
-- pre-Transit endpoint; generic assembly rediscovery and aggregate fold state
-- carry no D-0146 restoration authority.
function Authority:requestCachedTransitRestore(vehicle)
    local state=vehicle~=nil and self.states[vehicle] or nil
    if state==nil or state.bootstrapTransitCapability~=true then return false,"cached-transit-authority-not-owned" end
    if state.restoreRequestedAt~=nil then return true,state end
    state.restoreRequestedAt=g_time or 0
    state.restoreActuatorStates={}
    local requested=0
    for _,actuator in ipairs(state.transitActuatorStates or {}) do
        local current=foldTime(actuator.object)
        local initialTarget=tonumber(actuator.initialTargetFoldAnimTime)
        local physicallyChanged=current~=nil and initialTarget~=nil and math.abs(current-initialTarget)>0.001
        if physicallyChanged then
            local direction=initialTarget>=0.5 and 1 or -1
            if requestFoldDirection(actuator.object,direction) then
                requested=requested+1
                state.restoreActuatorStates[#state.restoreActuatorStates+1]={
                    object=actuator.object,memberReferenceKey=actuator.memberReferenceKey,direction=direction,
                    targetFoldAnimTime=initialTarget,settled=false
                }
            end
        end
    end
    state.restoreFoldRequested=requested>0
    return true,state
end

function Authority:getCachedRestoreSettlement(vehicle)
    local state=vehicle~=nil and self.states[vehicle] or nil
    if state==nil or state.bootstrapTransitCapability~=true then return {settled=true,normal=true,exhausted=false,actuatorCount=0,settledCount=0,elapsedMs=0,timeoutMs=0,reason="NO_CACHED_TRANSIT_STATE"} end
    local actuators=state.restoreActuatorStates or {}
    local actuatorCount=#actuators
    if state.restoreRequestedAt==nil or actuatorCount==0 then return {settled=true,normal=true,exhausted=false,actuatorCount=actuatorCount,settledCount=actuatorCount,elapsedMs=0,timeoutMs=tonumber(state.settlementTimeoutMs) or 0,reason="NO_PHYSICAL_TRANSIT_CHANGE_TO_RESTORE"} end
    local settledCount=0
    for _,actuator in ipairs(actuators) do
        local value=foldTime(actuator.object)
        local target=tonumber(actuator.targetFoldAnimTime)
        local settled=value~=nil and target~=nil and ((target>=0.5 and value>=0.999) or (target<0.5 and value<=0.001))
        actuator.settled=settled==true
        if settled then settledCount=settledCount+1 end
    end
    local elapsed=math.max(0,(g_time or 0)-(state.restoreRequestedAt or (g_time or 0)))
    local timeout=tonumber(state.settlementTimeoutMs) or (OuttaMyWay.D0146_TRANSIT_FOLD_SETTLEMENT_FALLBACK_MS or 30000)
    local normal=settledCount==actuatorCount
    local exhausted=not normal and elapsed>=timeout
    return {settled=normal or exhausted,normal=normal,exhausted=exhausted,actuatorCount=actuatorCount,settledCount=settledCount,elapsedMs=elapsed,timeoutMs=timeout,reason=normal and "RESTORE_ACTUATORS_SETTLED" or (exhausted and "RESTORE_FOLD_SETTLEMENT_EXHAUSTED" or "RESTORE_ACTUATORS_PENDING")}
end

function Authority:finishCachedTransitRestore(vehicle)
    local state=vehicle~=nil and self.states[vehicle] or nil
    if state==nil or state.bootstrapTransitCapability~=true then return false,"cached-transit-authority-not-owned" end
    local settlement=self:getCachedRestoreSettlement(vehicle)
    if settlement.settled~=true then return false,"restore-actuators-pending" end
    for object,lowered in pairs(state.loweredStates) do setLoweredState(object,lowered) end
    for object,enabled in pairs(state.workStates) do setWorkState(object,enabled) end
    self.states[vehicle]=nil
    return true,{state=state,settlement=settlement}
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
